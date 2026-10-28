#![feature(portable_simd,f16)]
#![allow(unsafe_op_in_unsafe_fn)]
use core::simd::{Simd,prelude::*};
use std::hint::black_box;
mod guards;
fn main() {
    let mut checks=0u64;
    for offset in 0..16 {
        let a:Vec<u32>=(0..64).map(|i|(i as u32).wrapping_mul(0x98765431)).collect();
        let b:Vec<u32>=(0..64).map(|i|!(i as u32)).collect();
        let mut out=vec![0x55aa55aa;64];
        knc_portable_simd::portable_affine(&mut out[offset..],&a[offset..],&b[offset..]);
        for i in 0..64 {
            assert_eq!(out[i],if (offset..offset+16).contains(&i){a[i].wrapping_mul(13).wrapping_add(b[i])}else{0x55aa55aa});checks+=1;
        }
        knc_portable_simd::portable_swizzle(&mut out[offset..],&a[offset..]);
        for i in 0..16{assert_eq!(out[offset+i],a[offset+15-i]);checks+=1}
    }
    macro_rules! fp_edges {($ty:ty,$ity:ty,$lanes:expr,$nan:expr)=>{{
        let inputs=black_box([<$ty>::NAN,<$ty>::INFINITY,<$ty>::NEG_INFINITY,-0.0,0.0,1.5,-1.5,1000.0]);
        let a=Simd::<$ty,$lanes>::from_array(core::array::from_fn(|i|inputs[i%8]));
        let cast=a.cast::<i32>().to_array();let roundtrip=a.to_bits().to_array();
        for i in 0..$lanes{assert_eq!(cast[i],inputs[i%8] as i32);assert_eq!(roundtrip[i],inputs[i%8].to_bits());checks+=2}
        let nan=Simd::<$ty,$lanes>::splat(black_box(<$ty>::from_bits($nan as $ity)));
        let b=Simd::<$ty,$lanes>::splat(black_box(2.0));
        assert_eq!(nan.simd_min(b).to_array(),[2.0;$lanes]);assert_eq!(nan.simd_max(b).to_array(),[2.0;$lanes]);checks+=2*$lanes as u64;
        let z=Simd::<$ty,$lanes>::splat(black_box(-0.0));
        assert!(z.is_sign_negative().all());assert_eq!(z.abs().to_bits().to_array(),[0;$lanes]);checks+=2*$lanes as u64;
    }}}
    fp_edges!(f16,u16,32,0x7c01);fp_edges!(f32,u32,16,0x7f800001);fp_edges!(f64,u64,8,0x7ff0000000000001);
    let guards=guards::run();
    let abi=guards::run_abi();
    println!("PASS Rust portable SIMD: {checks} scalar/bit/offset checks, {guards} protected-page lane checks, {abi} vector-value/callback ABI lane checks");
}
