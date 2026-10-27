#![no_std]
#![feature(alloc_error_handler)]
extern crate alloc;
use alloc::{collections::BTreeMap, vec::Vec};
use core::alloc::{GlobalAlloc, Layout};
struct LibcAllocator;
unsafe impl GlobalAlloc for LibcAllocator {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        let mut p = core::ptr::null_mut();
        if unsafe { posix_memalign(&mut p, layout.align().max(8), layout.size().max(1)) } != 0 {
            core::ptr::null_mut()
        } else { p.cast() }
    }
    unsafe fn dealloc(&self, p: *mut u8, _: Layout) { unsafe { free(p.cast()) } }
}
#[global_allocator]
static ALLOCATOR: LibcAllocator = LibcAllocator;
#[alloc_error_handler]
fn oom(_: Layout) -> ! { unsafe { abort() } }

use core::sync::atomic::{AtomicU64, Ordering};
unsafe extern "C" {
    fn puts(s: *const core::ffi::c_char) -> i32;
    fn abort() -> !;
    fn posix_memalign(p: *mut *mut core::ffi::c_void, align: usize, size: usize) -> i32;
    fn free(p: *mut core::ffi::c_void);
}
#[panic_handler]
fn panic(_: &core::panic::PanicInfo<'_>) -> ! { unsafe { abort() } }
static COUNTER: AtomicU64 = AtomicU64::new(0);
#[unsafe(no_mangle)]
pub extern "C" fn main() -> i32 {
    let mut values = [83i64, -5, 42, i64::MIN, 0, i64::MAX, -123, 83, 1, 9, -9, 2, 100, -100, 7, 6];
    values.sort_unstable();
    if values.windows(2).any(|w| w[0] > w[1]) { return 1; }
    let old = COUNTER.fetch_add(7, Ordering::SeqCst);
    if old != 0 || COUNTER.load(Ordering::Acquire) != 7 { return 2; }
    core::hint::spin_loop();
    let mut numbers = Vec::new();
    let mut seed = 12345u64;
    for _ in 0..4096 {
        seed = seed.wrapping_mul(6364136223846793005).wrapping_add(1);
        numbers.push(seed >> 32);
    }
    let before: u64 = numbers.iter().sum();
    numbers.sort_unstable();
    if numbers.windows(2).any(|w| w[0] > w[1]) || numbers.iter().sum::<u64>() != before { return 3; }
    let mut map = BTreeMap::new();
    for i in 0u64..100 { map.insert(i, i.wrapping_mul(i)); }
    if map.get(&17) != Some(&289) || map.len() != 100 { return 4; }
    let text = c"Hello from Rust on Knights Corner! PASS: sort, Vec, BTreeMap, heap allocation, atomics, core/alloc and libc.";
    unsafe { puts(text.as_ptr()); }
    0
}
