unsafe extern "C" {
    fn fminimum(a: f64, b: f64) -> f64;
    fn fminimum_num(a: f64, b: f64) -> f64;
    fn fmaximumf(a: f32, b: f32) -> f32;
}
fn main() {
    let a32 = [f32::from_bits(0x7f7fffff); 16];
    let a64 = [f64::from_bits(0x7fefffffffffffff); 8];
    let mut out32 = [0f32; 16];
    let mut out64 = [0f64; 8];
    for _ in 0..100 {
        unsafe {
            knc_vector_math::rust_vector_sqrt16_f32(out32.as_mut_ptr().cast(), a32.as_ptr().cast(), core::ptr::null());
            knc_vector_math::rust_vector_sqrt8_f64(out64.as_mut_ptr().cast(), a64.as_ptr().cast(), core::ptr::null());
        }
        assert!(out32.iter().all(|v| v.to_bits() == 0x5f7fffff));
        assert!(out64.iter().all(|v| v.to_bits() == 0x5fefffffffffffff));
        unsafe {
            knc_vector_math::rust_vector_div16_f32(out32.as_mut_ptr().cast(), a32.as_ptr().cast(), a32.as_ptr().cast());
            knc_vector_math::rust_vector_div8_f64(out64.as_mut_ptr().cast(), a64.as_ptr().cast(), a64.as_ptr().cast());
        }
        assert!(out32.iter().all(|v| v.to_bits() == 1f32.to_bits()));
        assert!(out64.iter().all(|v| v.to_bits() == 1f64.to_bits()));
    }
    unsafe {
        let nan = std::hint::black_box(f64::from_bits(0x7ff8000000000001));
        let one = std::hint::black_box(1.0f64);
        let negative_zero = std::hint::black_box(-0.0f64);
        assert!(fminimum(nan, one).is_nan());
        assert_eq!(fminimum_num(nan, one).to_bits(), one.to_bits());
        assert_eq!(fminimum(negative_zero, 0.0).to_bits(), (-0.0f64).to_bits());
        let nz32 = std::hint::black_box(-0.0f32);
        assert_eq!(fmaximumf(nz32, 0.0).to_bits(), 0.0f32.to_bits());
    }
    println!("PASS Cargo vector math: SIMD division/sqrt expansion, automatic sqrt/minmax runtime linking, upper-range double-rounding regression and C23 minimum/maximum semantics");
}
