use core::{ffi::c_void,fmt::Debug,simd::{Mask,Simd,SimdElement}};
unsafe extern "C" {
    fn getpagesize()->i32;
    fn mmap(addr:*mut c_void,len:usize,prot:i32,flags:i32,fd:i32,offset:isize)->*mut c_void;
    fn mprotect(addr:*mut c_void,len:usize,prot:i32)->i32;
    fn munmap(addr:*mut c_void,len:usize)->i32;
}
struct Pages {base:*mut u8,page:usize}
impl Pages {
    fn new()->Self {unsafe{
        let page=getpagesize() as usize;
        let base=mmap(core::ptr::null_mut(),page*3,0,0x22,-1,0).cast::<u8>();
        assert_ne!(base as usize,usize::MAX,"mmap failed");
        assert_eq!(mprotect(base.add(page).cast(),page,3),0,"mprotect failed");
        Self{base,page}
    }}
}
impl Drop for Pages {fn drop(&mut self){unsafe{assert_eq!(munmap(self.base.cast(),self.page*3),0)}}}
trait Value:SimdElement+PartialEq+Debug {fn value(i:usize)->Self;}
macro_rules! values {($($t:ty),*)=>{$(impl Value for $t{fn value(i:usize)->Self{(i+1) as Self}})*}}
values!(i8,u8,i16,u16,i32,u32,i64,u64,isize,usize,f16,f32,f64);
fn check<T:Value,const N:usize>()->usize {
    let pages=Pages::new();let size=size_of::<T>();let mut checks=0;
    for active in 0..=N {
        unsafe {
            let middle=pages.base.add(pages.page);core::ptr::write_bytes(middle,0x5a,pages.page);
            let guard=pages.base.add(2*pages.page).cast::<T>();
            let start=guard.sub(active);
            for i in 0..active{start.add(i).write(T::value(i))}
            let enabled=Mask::<<T as SimdElement>::Mask,N>::from_array(core::array::from_fn(|i|i<active));
            let fallback=Simd::<T,N>::splat(T::value(200));
            let loaded=Simd::<T,N>::load_select_ptr(start,enabled,fallback).to_array();
            for i in 0..N{assert_eq!(loaded[i],if i<active{T::value(i)}else{T::value(200)},"masked load N={N} active={active} lane={i}");checks+=1}
            let ptrs=Simd::<*const T,N>::from_array(core::array::from_fn(|i|if i<active{start.add(i).cast_const()}else{guard.cast_const()}));
            let pmask=Mask::<isize,N>::from_array(core::array::from_fn(|i|i<active));
            let gathered=Simd::<T,N>::gather_select_ptr(ptrs,pmask,fallback).to_array();
            assert_eq!(loaded,gathered,"masked pointer gather N={N} active={active}");checks+=N;
            let vector=Simd::<T,N>::from_array(core::array::from_fn(|i|T::value(i+80)));
            vector.store_select_ptr(start,enabled);
            for i in 0..active{assert_eq!(start.add(i).read(),T::value(i+80));checks+=1}
            for i in 0..active{start.add(i).write(T::value(i))}
            let dest=Simd::<*mut T,N>::from_array(core::array::from_fn(|i|if i<active{start.add(i)}else{guard}));
            vector.scatter_select_ptr(dest,pmask);
            for i in 0..active{assert_eq!(start.add(i).read(),T::value(i+80));checks+=1}
            let prefix=core::slice::from_raw_parts(start.cast::<u8>().sub(size),size);
            assert!(prefix.iter().all(|b|*b==0x5a),"store overwrote prefix");
        }
    }
    checks
}
pub fn run()->usize {
    let mut count=0;
    macro_rules! widths {($t:ty)=>{count+=check::<$t,1>()+check::<$t,2>()+check::<$t,3>()+check::<$t,4>()+check::<$t,7>()+check::<$t,8>()+check::<$t,16>()+check::<$t,17>()+check::<$t,32>()+check::<$t,64>();}}
    widths!(i8);widths!(u8);widths!(i16);widths!(u16);widths!(i32);widths!(u32);widths!(i64);widths!(u64);widths!(isize);widths!(usize);widths!(f16);widths!(f32);widths!(f64);
    count
}

#[inline(never)]
fn by_value<T:Value,const N:usize>(a:Simd<T,N>,b:Simd<T,N>)->(Simd<T,N>,Simd<T,N>)
where Simd<T,N>:core::ops::Add<Output=Simd<T,N>>+core::ops::Sub<Output=Simd<T,N>> {
    (a+b,a-b)
}
fn abi<T:Value+core::ops::Add<Output=T>+core::ops::Sub<Output=T>,const N:usize>()->usize
where Simd<T,N>:core::ops::Add<Output=Simd<T,N>>+core::ops::Sub<Output=Simd<T,N>> {
    let a=core::array::from_fn(|i|T::value(i%7+8));
    let b=core::array::from_fn(|i|T::value(i%7));
    let call=std::hint::black_box(by_value::<T,N> as fn(Simd<T,N>,Simd<T,N>)->(Simd<T,N>,Simd<T,N>));
    let (sum,difference)=call(Simd::from_array(a),Simd::from_array(b));
    assert_eq!(sum.to_array(),core::array::from_fn(|i|a[i]+b[i]),"vector tuple return through function pointer");
    assert_eq!(difference.to_array(),core::array::from_fn(|i|a[i]-b[i]));
    N*2
}
pub fn run_abi()->usize {
    let mut count=0;
    macro_rules! widths {($t:ty)=>{count+=abi::<$t,1>()+abi::<$t,2>()+abi::<$t,3>()+abi::<$t,4>()+abi::<$t,7>()+abi::<$t,8>()+abi::<$t,16>()+abi::<$t,17>()+abi::<$t,32>()+abi::<$t,64>();}}
    widths!(i8);widths!(u8);widths!(i16);widths!(u16);widths!(i32);widths!(u32);widths!(i64);widths!(u64);widths!(isize);widths!(usize);widths!(f16);widths!(f32);widths!(f64);
    count
}
