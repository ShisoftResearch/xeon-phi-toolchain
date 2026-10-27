use std::{
    collections::HashMap,
    fs,
    io::{Read, Write},
    net::{TcpListener, TcpStream},
    sync::{
        Arc,
        atomic::{AtomicU64, Ordering},
    },
    thread,
};
thread_local! {static LOCAL:std::cell::Cell<u64>=const{std::cell::Cell::new(0)};}
fn main() {
    let counter = Arc::new(AtomicU64::new(0));
    let mut workers = Vec::new();
    for i in 0..4 {
        let c = counter.clone();
        workers.push(thread::spawn(move || {
            LOCAL.with(|v| v.set(i + 10));
            for _ in 0..2000 {
                c.fetch_add(1, Ordering::SeqCst);
            }
            LOCAL.with(|v| assert_eq!(v.get(), i + 10));
        }));
    }
    for w in workers {
        w.join().unwrap();
    }
    assert_eq!(counter.load(Ordering::Acquire), 8000);
    LOCAL.with(|v| assert_eq!(v.get(), 0));
    let path = format!("/tmp/knc-std-{}.txt", std::process::id());
    fs::write(&path, b"Rust KNC file IO").unwrap();
    assert_eq!(fs::read(&path).unwrap(), b"Rust KNC file IO");
    fs::remove_file(&path).unwrap();
    let mut map = HashMap::new();
    map.insert("answer", 42);
    assert_eq!(map["answer"], 42);
    let listener = TcpListener::bind("127.0.0.1:0").unwrap();
    let addr = listener.local_addr().unwrap();
    let server = thread::spawn(move || {
        let (mut s, _) = listener.accept().unwrap();
        let mut b = [0; 4];
        s.read_exact(&mut b).unwrap();
        assert_eq!(&b, b"ping");
        s.write_all(b"pong").unwrap();
    });
    let mut client = TcpStream::connect(addr).unwrap();
    client.write_all(b"ping").unwrap();
    let mut b = [0; 4];
    client.read_exact(&mut b).unwrap();
    assert_eq!(&b, b"pong");
    server.join().unwrap();
    let x = std::hint::black_box(0.5f64);
    assert!((x.sin() - 0.479425538604203).abs() < 1e-15);
    assert_eq!(std::hint::black_box(9.0f64).sqrt(), 3.0);
    assert_eq!(std::hint::black_box(2.0f64).powf(10.0), 1024.0);
    let y = std::hint::black_box(0.5f32);
    assert!((y.sin() - 0.47942555).abs() < 1e-6);
    assert_eq!(std::hint::black_box(8.0f64).log2(), 3.0);
    assert_eq!(std::hint::black_box(-3.0f64).exp2(), 0.125);
    assert_eq!(std::hint::black_box(2.5f64).round_ties_even(), 2.0);
    assert_eq!(std::hint::black_box(2.0f64).mul_add(3.0, 4.0), 10.0);
    assert_eq!("1.25".parse::<f64>().unwrap(), 1.25);
    assert_eq!(format!("{:.3}", x), "0.500");
    println!(
        "PASS Rust std on KNC: ordinary main, formatting {}, heap, HashMap/random seed, threads, native TLS, files and loopback TCP",
        42
    );
}
