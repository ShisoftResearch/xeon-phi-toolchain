#![no_std]
#![feature(link_llvm_intrinsics, repr_simd, simd_ffi)]
#![allow(internal_features, improper_ctypes)]
use core::ops::{Add, AddAssign, Mul};

#[repr(simd)]
#[derive(Clone, Copy)]
struct RawI32([u32; 16]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct RawF32([f32; 16]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct RawF64([f64; 8]);
unsafe extern "C" {
    #[link_name = "llvm.x86.knc.load.i32"] fn load(p: *const u32) -> RawI32;
    #[link_name = "llvm.x86.knc.store.i32"] fn store(p: *mut u32, v: RawI32);
    #[link_name = "llvm.x86.knc.loadu.i32"] fn loadu(p: *const u32) -> RawI32;
    #[link_name = "llvm.x86.knc.storeu.i32"] fn storeu(p: *mut u32, v: RawI32);
    #[link_name = "llvm.x86.knc.add.i32"] fn add(a: RawI32, b: RawI32) -> RawI32;
    #[link_name = "llvm.x86.knc.mul.i32"] fn mul(a: RawI32, b: RawI32) -> RawI32;
    #[link_name = "llvm.x86.knc.mask.add.i32"] fn mask_add(old: RawI32, a: RawI32, b: RawI32, mask: u32) -> RawI32;
    #[link_name = "llvm.x86.knc.add.f32"] fn addf(a: RawF32, b: RawF32) -> RawF32;
    #[link_name = "llvm.x86.knc.mul.f32"] fn mulf(a: RawF32, b: RawF32) -> RawF32;
    #[link_name = "llvm.x86.knc.add.f64"] fn addd(a: RawF64, b: RawF64) -> RawF64;
    #[link_name = "llvm.x86.knc.mul.f64"] fn muld(a: RawF64, b: RawF64) -> RawF64;
}
/// Sixteen unsigned lanes; arithmetic wraps modulo 2^32.
#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct U32x16(pub [u32; 16]);
impl U32x16 {
    /// Load sixteen naturally aligned elements, without requiring 64-byte alignment.
    pub fn from_slice(input: &[u32]) -> Self {
        assert!(input.len() >= 16);
        let mut out = Self::default();
        unsafe { store(out.0.as_mut_ptr(), loadu(input.as_ptr())); }
        out
    }
    /// Store sixteen elements, preserving surrounding elements.
    pub fn write_to_slice(self, output: &mut [u32]) {
        assert!(output.len() >= 16);
        unsafe { storeu(output.as_mut_ptr(), load(self.0.as_ptr())); }
    }
    /// Active lanes receive a wrapping sum; inactive lanes retain `self`.
    pub fn masked_add(self, lhs: Self, rhs: Self, mask: u16) -> Self {
        let mut out = Self::default();
        unsafe { store(out.0.as_mut_ptr(), mask_add(load(self.0.as_ptr()), load(lhs.0.as_ptr()), load(rhs.0.as_ptr()), mask as u32)); }
        out
    }
}
impl Add for U32x16 {
    type Output = Self;
    fn add(self, rhs: Self) -> Self {
        let mut out = Self::default();
        unsafe { store(out.0.as_mut_ptr(), add(load(self.0.as_ptr()), load(rhs.0.as_ptr()))); }
        out
    }
}
impl Mul for U32x16 {
    type Output = Self;
    fn mul(self, rhs: Self) -> Self {
        let mut out = Self::default();
        unsafe { store(out.0.as_mut_ptr(), mul(load(self.0.as_ptr()), load(rhs.0.as_ptr()))); }
        out
    }
}
impl AddAssign for U32x16 { fn add_assign(&mut self, rhs: Self) { *self = *self + rhs; } }

macro_rules! float_vector {
    ($name:ident, $elem:ty, $lanes:expr, $raw:ty, $add:ident, $mul:ident) => {
        /// Aligned IMCI floating-point lanes using the card's FP environment.
        #[repr(C, align(64))]
        #[derive(Clone, Copy, Debug, Default, PartialEq)]
        pub struct $name(pub [$elem; $lanes]);
        impl Add for $name {
            type Output = Self;
            fn add(self, rhs: Self) -> Self {
                let mut out = Self::default();
                unsafe {
                    let a: $raw = core::mem::transmute(load(self.0.as_ptr().cast()));
                    let b: $raw = core::mem::transmute(load(rhs.0.as_ptr().cast()));
                    store(out.0.as_mut_ptr().cast(), core::mem::transmute($add(a, b)));
                }
                out
            }
        }
        impl Mul for $name {
            type Output = Self;
            fn mul(self, rhs: Self) -> Self {
                let mut out = Self::default();
                unsafe {
                    let a: $raw = core::mem::transmute(load(self.0.as_ptr().cast()));
                    let b: $raw = core::mem::transmute(load(rhs.0.as_ptr().cast()));
                    store(out.0.as_mut_ptr().cast(), core::mem::transmute($mul(a, b)));
                }
                out
            }
        }
    };
}
float_vector!(F32x16, f32, 16, RawF32, addf, mulf);
float_vector!(F64x8, f64, 8, RawF64, addd, muld);

/// An opaque vector value for keeping intermediate results in IMCI registers.
#[derive(Clone, Copy)]
pub struct U32Vector(RawI32);
impl U32Vector {
    #[inline(always)]
    pub fn from_slice(input: &[u32]) -> Self {
        assert!(input.len() >= 16);
        unsafe { Self(loadu(input.as_ptr())) }
    }
    #[inline(always)]
    pub fn splat(value: u32) -> Self {
        let block = U32x16([value; 16]);
        unsafe { Self(load(block.0.as_ptr())) }
    }
    #[inline(always)]
    pub fn write_to_slice(self, output: &mut [u32]) {
        assert!(output.len() >= 16);
        unsafe { storeu(output.as_mut_ptr(), self.0); }
    }
    #[inline(always)]
    pub fn masked_add(self, lhs: Self, rhs: Self, mask: u16) -> Self {
        unsafe { Self(mask_add(self.0, lhs.0, rhs.0, mask as u32)) }
    }
}
impl Add for U32Vector {
    type Output = Self;
    #[inline(always)]
    fn add(self, rhs: Self) -> Self { unsafe { Self(add(self.0, rhs.0)) } }
}
impl Mul for U32Vector {
    type Output = Self;
    #[inline(always)]
    fn mul(self, rhs: Self) -> Self { unsafe { Self(mul(self.0, rhs.0)) } }
}
