#[inline(never)]
#[no_mangle]
pub fn affine(out:&mut [u32],a:&[u32],b:&[u32]) {
    assert_eq!(out.len(),a.len());assert_eq!(a.len(),b.len());
    for ((dst,&x),&y) in out.iter_mut().zip(a).zip(b) {
        *dst=x.wrapping_mul(13).wrapping_add(y);
    }
}
fn main(){
    for n in 0..257 {
        let a:Vec<u32>=(0..n+16).map(|x|(x as u32).wrapping_mul(0x98765431)).collect();
        let b:Vec<u32>=(0..n+16).map(|x|!(x as u32)).collect();
        for offset in 0..16 {
            let mut out=vec![0x55555555;n+32];
            affine(&mut out[offset..offset+n],&a[offset..offset+n],&b[offset..offset+n]);
            for i in 0..out.len(){
                assert_eq!(out[i],if (offset..offset+n).contains(&i){a[i].wrapping_mul(13).wrapping_add(b[i])}else{0x55555555});
            }
        }
    }
    println!("PASS automatic integer SIMD: ordinary Rust affine loop, 257 lengths, 16 offsets, tails and surrounding sentinels");
}
