#![feature(core_intrinsics, repr_simd)]
#![allow(internal_features)]
#[repr(simd)]
#[derive(Clone, Copy)]
struct F32x16([f32; 16]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct F64x8([f64; 8]);
// Pointer ABI keeps the C harness independent of compiler vector calling conventions.
macro_rules! kernels {
    ($raw:ty, $div:ident, $sqrt:ident) => {
        #[no_mangle]
        pub unsafe extern "C" fn $div(out: *mut u8, a: *const u8, b: *const u8) {
            let x = a.cast::<$raw>().read_unaligned();
            let y = b.cast::<$raw>().read_unaligned();
            let z = core::intrinsics::simd::simd_div(x, y);
            out.cast::<$raw>().write_unaligned(z);
        }
        #[no_mangle]
        pub unsafe extern "C" fn $sqrt(out: *mut u8, a: *const u8, _b: *const u8) {
            let x = a.cast::<$raw>().read_unaligned();
            let z = core::intrinsics::simd::simd_fsqrt(x);
            out.cast::<$raw>().write_unaligned(z);
        }
    };
}
kernels!(F32x16, rust_vector_div16_f32, rust_vector_sqrt16_f32);
kernels!(F64x8, rust_vector_div8_f64, rust_vector_sqrt8_f64);

#[allow(non_camel_case_types)]
mod conversions;
