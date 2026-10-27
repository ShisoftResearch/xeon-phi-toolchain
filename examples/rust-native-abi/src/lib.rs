#![no_std]
#[panic_handler]
fn panic(_: &core::panic::PanicInfo) -> ! { loop { core::hint::spin_loop(); } }
#[repr(C)]
#[derive(Clone, Copy)]
pub struct Mixed { pub value: f64, pub count: i64 }
#[repr(C)]
#[derive(Clone, Copy)]
pub struct Pair { pub first: f64, pub second: f64 }
#[repr(C)]
#[derive(Clone, Copy)]
pub struct FloatPair { pub first: f32, pub second: f32 }
extern "C" {
    fn c_pair(p: Pair) -> Pair;
    fn c_mixed(p: Mixed) -> Mixed;
    fn c_ten(a:f64,b:f64,c:f64,d:f64,e:f64,f:f64,g:f64,h:f64,i:f64,j:f64) -> f64;
    fn c_varargs(n:i32, ...) -> f64;
}
#[no_mangle] pub extern "C" fn rust_identity(x:f64) -> f64 { x }
#[no_mangle] pub extern "C" fn rust_add(x:f64,y:f64) -> f64 { x+y }
#[no_mangle] pub extern "C" fn rust_addf(x:f32,y:f32) -> f32 { x+y }
#[no_mangle] pub extern "C" fn rust_sub(x:f64,y:f64) -> f64 { x-y }
#[no_mangle] pub extern "C" fn rust_subf(x:f32,y:f32) -> f32 { x-y }
#[no_mangle] pub extern "C" fn rust_mul(x:f64,y:f64) -> f64 { x*y }
#[no_mangle] pub extern "C" fn rust_mulf(x:f32,y:f32) -> f32 { x*y }
#[no_mangle] pub extern "C" fn rust_mixed(p:Mixed) -> Mixed {
    Mixed { value:p.value + p.count as f64, count:p.count + 1 }
}
#[no_mangle] pub extern "C" fn rust_pair(p:Pair) -> Pair {
    Pair { first:p.second, second:p.first }
}
#[no_mangle] pub extern "C" fn rust_float_pair(p:FloatPair) -> FloatPair {
    FloatPair { first:p.second, second:p.first }
}
#[no_mangle] pub extern "C" fn rust_callback(x:f64, cb:extern "C" fn(f64)->f64) -> f64 { cb(x) }
#[no_mangle] pub extern "C" fn rust_ten(a:f64,b:f64,c:f64,d:f64,e:f64,f:f64,g:f64,h:f64,i:f64,j:f64) -> f64 {
    a+2.0*b+3.0*c+4.0*d+5.0*e+6.0*f+7.0*g+8.0*h+9.0*i+10.0*j
}
#[no_mangle] pub unsafe extern "C" fn rust_calls_c(x:f64) -> f64 {
    let p=c_pair(Pair {first:x,second:2.0});
    let m=c_mixed(Mixed {value:p.first,count:3});
    c_ten(p.first,p.second,m.value,m.count as f64,5.0,6.0,7.0,8.0,9.0,10.0)
}
#[no_mangle] pub unsafe extern "C" fn rust_calls_varargs(x:f64) -> f64 {
    c_varargs(10,x,2.0f64,3.0f64,4.0f64,5.0f64,6.0f64,7.0f64,8.0f64,9.0f64,10.0f64)
}
