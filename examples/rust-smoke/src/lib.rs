#![no_std]
use core::sync::atomic::{AtomicU64, Ordering};

#[unsafe(no_mangle)]
pub extern "C" fn knc_mix(mut x: u64, rounds: u32) -> u64 {
    for _ in 0..rounds {
        x ^= x >> 12;
        x ^= x << 25;
        x ^= x >> 27;
        x = x.wrapping_mul(0x2545_f491_4f6c_dd1d);
    }
    x
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn knc_sum(p: *const u32, n: usize) -> u64 {
    let data = unsafe { core::slice::from_raw_parts(p, n) };
    data.iter().map(|&x| u64::from(x)).sum()
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn knc_atomic(p: *mut AtomicU64, n: u64) -> u64 {
    unsafe { &*p }.fetch_add(n, Ordering::SeqCst)
}

#[unsafe(no_mangle)]
pub extern "C" fn knc_choose(a: i64, b: i64) -> i64 {
    if a < b { a } else { b }
}
