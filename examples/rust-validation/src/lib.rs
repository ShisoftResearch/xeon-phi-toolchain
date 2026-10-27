#![no_std]
#![feature(core_intrinsics)]
#![allow(internal_features)]
use core::{
    ptr,
    sync::atomic::{AtomicU64, Ordering},
};
unsafe extern "C" {
    fn abort() -> !;
}
#[panic_handler]
fn panic(_: &core::panic::PanicInfo<'_>) -> ! {
    unsafe { abort() }
}
#[repr(C)]
pub struct Pair {
    a: u64,
    b: i64,
}
#[repr(C)]
pub struct Large {
    a: [u64; 5],
}
#[repr(C, packed)]
pub struct Packed {
    tag: u8,
    value: u64,
}
#[unsafe(no_mangle)]
pub extern "C" fn knc_pair(p: Pair, x: u64) -> Pair {
    Pair {
        a: p.a.wrapping_add(x),
        b: p.b.wrapping_mul(-3),
    }
}
#[unsafe(no_mangle)]
pub extern "C" fn knc_large(mut p: Large) -> Large {
    for (i, x) in p.a.iter_mut().enumerate() {
        *x = x.wrapping_add((i as u64) * 17);
    }
    p
}
#[unsafe(no_mangle)]
pub extern "C" fn knc_packed(p: Packed) -> Packed {
    Packed {
        tag: p.tag.wrapping_add(1),
        value: p.value.rotate_left(13),
    }
}
#[unsafe(no_mangle)]
pub extern "C" fn knc_callback(f: extern "C" fn(u64, u64) -> u64, a: u64, b: u64) -> u64 {
    f(a, b).wrapping_add(7)
}
#[unsafe(no_mangle)]
pub extern "C" fn knc_many(
    a: u64,
    b: u64,
    c: u64,
    d: u64,
    e: u64,
    f: u64,
    g: u64,
    h: u64,
    i: u64,
    j: u64,
) -> u64 {
    a.wrapping_add(b.wrapping_mul(2))
        .wrapping_add(c.wrapping_mul(3))
        .wrapping_add(d.wrapping_mul(4))
        .wrapping_add(e.wrapping_mul(5))
        .wrapping_add(f.wrapping_mul(6))
        .wrapping_add(g.wrapping_mul(7))
        .wrapping_add(h.wrapping_mul(8))
        .wrapping_add(i.wrapping_mul(9))
        .wrapping_add(j.wrapping_mul(10))
}
#[unsafe(no_mangle)]
pub extern "C" fn knc_bits(x: u64, n: u32) -> u64 {
    x.rotate_left(n)
        ^ x.rotate_right(n)
        ^ ((x.leading_zeros() as u64) << 40)
        ^ ((x.trailing_zeros() as u64) << 32)
        ^ (x.count_ones() as u64)
}
#[unsafe(no_mangle)]
pub extern "C" fn knc_div(a: i64, b: i64) -> i64 {
    a.wrapping_div(b)
}
#[unsafe(no_mangle)]
pub unsafe extern "C" fn knc_u128(hi: u64, lo: u64, d: u64, out: *mut u64) {
    let x = ((hi as u128) << 64) | (lo as u128);
    let q = x / (d as u128);
    unsafe {
        out.write(q as u64);
        out.add(1).write((q >> 64) as u64);
        out.add(2).write((x % (d as u128)) as u64);
    }
}
#[unsafe(no_mangle)]
pub unsafe extern "C" fn knc_memory(dst: *mut u8, src: *const u8, n: usize, kind: u32) {
    unsafe {
        match kind {
            0 => ptr::copy_nonoverlapping(src, dst, n),
            1 => ptr::copy(src, dst, n),
            _ => ptr::write_bytes(dst, 0xa5, n),
        }
    }
}
#[unsafe(no_mangle)]
pub unsafe extern "C" fn knc_cas(p: *const AtomicU64) -> u64 {
    let p = unsafe { &*p };
    let mut old = p.load(Ordering::Relaxed);
    loop {
        match p.compare_exchange_weak(
            old,
            old.wrapping_add(1),
            Ordering::SeqCst,
            Ordering::Relaxed,
        ) {
            Ok(v) => return v,
            Err(v) => {
                old = v;
                core::hint::spin_loop();
            }
        }
    }
}
#[unsafe(no_mangle)]
pub unsafe extern "C" fn knc_fp64(a: *const u64, b: *const u64, out: *mut u64, op: u32) {
    let x = f64::from_bits(unsafe { a.read() });
    let y = f64::from_bits(unsafe { b.read() });
    let v = match op {
        0 => x + y,
        1 => x - y,
        2 => x * y,
        3 => x / y,
        5 => core::intrinsics::sqrtf64(x),
        _ => {
            if x < y {
                x
            } else {
                y
            }
        }
    };
    unsafe { out.write(v.to_bits()) }
}
#[unsafe(no_mangle)]
pub unsafe extern "C" fn knc_fp32(a: *const u32, b: *const u32, out: *mut u32, op: u32) {
    let x = f32::from_bits(unsafe { a.read() });
    let y = f32::from_bits(unsafe { b.read() });
    let v = match op {
        0 => x + y,
        1 => x - y,
        2 => x * y,
        3 => x / y,
        5 => core::intrinsics::sqrtf32(x),
        _ => {
            if x < y {
                x
            } else {
                y
            }
        }
    };
    unsafe { out.write(v.to_bits()) }
}
