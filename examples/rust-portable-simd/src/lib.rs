#![no_std]
#![feature(portable_simd)]
use core::simd::{prelude::*, simd_swizzle, Simd};

#[unsafe(no_mangle)]
pub fn portable_affine(out: &mut [u32], a: &[u32], b: &[u32]) {
    assert!(out.len() >= 16 && a.len() >= 16 && b.len() >= 16);
    let a = Simd::<u32,16>::from_slice(a);
    let b = Simd::<u32,16>::from_slice(b);
    (a * Simd::splat(13) + b).copy_to_slice(out);
}

#[unsafe(no_mangle)]
pub fn portable_select(out: &mut [f32], a: &[f32], b: &[f32]) {
    assert!(out.len() >= 16 && a.len() >= 16 && b.len() >= 16);
    let a = Simd::<f32,16>::from_slice(a);
    let b = Simd::<f32,16>::from_slice(b);
    a.simd_lt(b).select(a,b).copy_to_slice(out);
}

#[unsafe(no_mangle)]
pub fn portable_swizzle(out: &mut [u32], a: &[u32]) {
    assert!(out.len() >= 16 && a.len() >= 16);
    let a = Simd::<u32,16>::from_slice(a);
    simd_swizzle!(a, [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]).copy_to_slice(out);
}
