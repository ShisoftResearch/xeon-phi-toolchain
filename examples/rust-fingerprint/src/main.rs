use knc_runtime::U32Vector;
use std::{hint::black_box,time::Instant};
const BASE:u32=16_777_619;
extern "C" { fn gcc_fingerprints(tokens:*const u32,out:*mut u32,count:usize); }
#[inline(never)]
fn scalar(tokens:&[u32],out:&mut [u32]) {
    for (i,dst) in out.iter_mut().enumerate() {
        let mut h=0u32;
        for j in 0..16 { h=h.wrapping_mul(BASE).wrapping_add(tokens[i+j]); }
        *dst=h;
    }
}
#[inline(never)]
fn simd(tokens:&[u32],out:&mut [u32]) {
    let base=U32Vector::splat(BASE);
    let bulk=out.len()/16*16;
    for i in (0..bulk).step_by(16) {
        let mut h=U32Vector::splat(0);
        for j in 0..16 { h=h*base+U32Vector::from_slice(&tokens[i+j..]); }
        h.write_to_slice(&mut out[i..]);
    }
    for i in bulk..out.len() {
        let mut h=0u32;
        for j in 0..16 {h=h.wrapping_mul(BASE).wrapping_add(tokens[i+j]);}
        out[i]=h;
    }
}
fn main() {
    let mut state=0x1357_2468u32;
    let tokens:Vec<u32>=(0..131072).map(|_|{state^=state<<13;state^=state>>17;state^=state<<5;state}).collect();
    let mut c=vec![0;tokens.len()-15];
    let mut r=c.clone();let mut v=c.clone();
    unsafe{gcc_fingerprints(tokens.as_ptr(),c.as_mut_ptr(),c.len());}
    scalar(&tokens,&mut r);simd(&tokens,&mut v);
    assert_eq!(c,r);assert_eq!(c,v);
    let checksum:u64=c.iter().map(|&x|u64::from(x)).sum();
    println!("PASS fingerprints: {} windows of 16 tokens; all outputs match independent MPSS GCC; checksum={checksum}",c.len());
    for name in ["mpss_gcc_scalar","rust_scalar","rust_imci"] {
        let start=Instant::now();
        for _ in 0..3 {
            match name {
                "mpss_gcc_scalar"=>unsafe{gcc_fingerprints(black_box(tokens.as_ptr()),black_box(c.as_mut_ptr()),c.len());},
                "rust_scalar"=>scalar(black_box(&tokens),black_box(&mut r)),
                _=>simd(black_box(&tokens),black_box(&mut v)),
            }
        }
        println!("TIMING {name} ns={} rounds=3",start.elapsed().as_nanos());
    }
}
