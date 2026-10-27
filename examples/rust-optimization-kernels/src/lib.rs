#![no_std]
// Ordinary Rust loops: no SIMD intrinsics and no requested vector widths.
// The independent C harness supplies valid, disjoint, naturally aligned memory.
macro_rules! cast_loop {
    ($name:ident,$src:ty,$dst:ty) => {
        #[no_mangle]
        #[inline(never)]
        pub unsafe extern "C" fn $name(out: *mut $dst, input: *const $src, n: usize) {
            let mut i = 0;
            while i < n {
                *out.add(i) = *input.add(i) as $dst;
                i += 1;
            }
        }
    };
}
cast_loop!(rust_cast_i32_f64, i32, f64);
cast_loop!(rust_cast_u32_f64, u32, f64);
cast_loop!(rust_cast_f32_f64, f32, f64);
cast_loop!(rust_cast_f64_f32, f64, f32);
#[no_mangle]
#[inline(never)]
pub unsafe extern "C" fn rust_cast_f64_i32(out: *mut i32, input: *const f64, n: usize) {
    // Match C/LLVM's defined conversion domain, rather than Rust's distinct
    // saturating `as` contract. Every test input is finite and representable.
    let mut i = 0;
    while i < n {
        *out.add(i) = (*input.add(i)).to_int_unchecked::<i32>();
        i += 1;
    }
}
#[no_mangle]
#[inline(never)]
pub unsafe extern "C" fn rust_affine_i16_f32(out: *mut f32, input: *const i16, scale: *const f32, n: usize) {
    let mut i = 0;
    while i < n {
        *out.add(i) = (*input.add(i) as f32) * *scale.add(i);
        i += 1;
    }
}
#[no_mangle]
#[inline(never)]
pub unsafe extern "C" fn rust_affine_i32_f64(out: *mut f64, input: *const i32, scale: *const f64, n: usize) {
    let mut i = 0;
    while i < n {
        *out.add(i) = (*input.add(i) as f64) * *scale.add(i);
        i += 1;
    }
}
#[no_mangle]
#[inline(never)]
pub unsafe extern "C" fn rust_dot_f64_ordered(a: *const f64, b: *const f64, n: usize) -> f64 {
    let mut sum = 0.0;
    let mut i = 0;
    while i < n {
        sum += *a.add(i) * *b.add(i);
        i += 1;
    }
    sum
}
#[no_mangle]
#[inline(never)]
pub unsafe extern "C" fn rust_clamp_f64(out: *mut f64, input: *const f64, n: usize) {
    let mut i = 0;
    while i < n {
        let v = *input.add(i);
        *out.add(i) = if v < 0.0 { 0.0 } else if v > 6.0 { 6.0 } else { v };
        i += 1;
    }
}
