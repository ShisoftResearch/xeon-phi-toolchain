#![feature(link_llvm_intrinsics)]
#[repr(C, align(64))]
struct Block([u32; 16]);
unsafe extern "C" {
    #[link_name = "llvm.x86.knc.vadd.i32"]
    fn add(out: *mut u32, lhs: *const u32, rhs: *const u32);
}
fn main() {
    let (mut a, mut b, mut out) = (
        Box::new(Block([0; 16])),
        Box::new(Block([0; 16])),
        Box::new(Block([0; 16])),
    );
    let mut seed = 1u32;
    for _ in 0..1000 {
        for i in 0..16 {
            seed = seed.wrapping_mul(1664525).wrapping_add(1013904223);
            a.0[i] = seed;
            b.0[i] = seed.rotate_left(13);
        }
        unsafe {
            add(out.0.as_mut_ptr(), a.0.as_ptr(), b.0.as_ptr());
        }
        for i in 0..16 {
            assert_eq!(out.0[i], a.0[i].wrapping_add(b.0[i]));
        }
        let ap = a.0.as_mut_ptr();
        unsafe {
            add(ap, ap, b.0.as_ptr());
        }
        assert_eq!(a.0, out.0);
    }
    for i in 0..1000u32 {
        let a = knc_runtime::U32x16([i.wrapping_mul(123456789); 16]);
        let b = knc_runtime::U32x16([u32::MAX - i; 16]);
        let mut c = a + b;
        assert_eq!(c.0, [a.0[0].wrapping_add(b.0[0]); 16]);
        c += a;
        assert_eq!(c.0, [a.0[0].wrapping_mul(2).wrapping_add(b.0[0]); 16]);
    }
    use knc_runtime::{F32x16, F64x8, U32x16, U32Vector};
    for i in 0..1000u32 {
        let a = U32x16([i.wrapping_mul(123456789); 16]);
        let b = U32x16([u32::MAX - i; 16]);
        let c = a * b;
        assert_eq!(c.0, [a.0[0].wrapping_mul(b.0[0]); 16]);
        let m = a.masked_add(a, b, 0xa55a);
        for lane in 0..16 {
            assert_eq!(m.0[lane], if 0xa55au16 >> lane & 1 != 0 { a.0[lane].wrapping_add(b.0[lane]) } else { a.0[lane] });
        }
        let a = F32x16([i as f32 * 0.25; 16]);
        let b = F32x16([i as f32 - 500.0; 16]);
        assert_eq!((a+b).0, [a.0[0]+b.0[0];16]);
        assert_eq!((a*b).0, [a.0[0]*b.0[0];16]);
        let a = F64x8([i as f64 * 0.25; 8]);
        let b = F64x8([i as f64 - 500.0; 8]);
        assert_eq!((a+b).0, [a.0[0]+b.0[0];8]);
        assert_eq!((a*b).0, [a.0[0]*b.0[0];8]);
    }
    let source: Vec<u32> = (0..64u32).map(|x| x.wrapping_mul(172389)).collect();
    for offset in 0..16 {
        let v = U32Vector::from_slice(&source[offset..]);
        let mut dest = vec![99u32;64];
        (v * U32Vector::splat(13)).write_to_slice(&mut dest[offset..]);
        for i in 0..64 {
            assert_eq!(dest[i], if (offset..offset+16).contains(&i) {source[i].wrapping_mul(13)} else {99});
        }
    }
    println!(
        "PASS LLVM IMCI intrinsic from Rust: 1000 random 16-lane i32 vector additions, wrapping overflow, aligned heap buffers, in-place output safe operators, integer multiply/masks, FP32/FP64 arithmetic and unaligned slices"
    );
}
