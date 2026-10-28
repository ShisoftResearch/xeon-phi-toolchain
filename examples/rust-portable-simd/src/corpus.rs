#![feature(portable_simd, f16)]
#![allow(unsafe_op_in_unsafe_fn)]
use std::{io::{Read,Write},fs::File};
type Kernel = unsafe extern "C" fn(*mut u8,*const u8,*const u8,*const u8,usize,*const usize,u64);
struct Case {name:&'static str,element:&'static str,lanes:usize,operation:&'static str,result:&'static str,run:Kernel}
include!(env!("PHI_SIMD_CORPUS"));

fn bytes(ty:&str)->usize {match ty {"i8"|"u8"=>1,"i16"|"u16"|"f16"=>2,"i32"|"u32"|"f32"=>4,_=>8}}
fn fill(storage:&mut [u64],offset:usize,ty:&str,count:usize,trial:usize,which:usize) {
    let size=bytes(ty);
    let floats=[1.0f64,2.0,0.5,-1.0,0.25,4.0,-0.5,-2.0];
    for lane in 0..count {
        let v=if ty.starts_with('f') {
            let value=if which==1 {[1.0,2.0,0.5,4.0][(lane+trial)%4]} else {floats[(lane+trial)%8]};
            match ty {"f16"=>(value as f16).to_bits() as u64,"f32"=>(value as f32).to_bits() as u64,_=>value.to_bits()}
        } else if which==1 {((lane+trial)%7+1) as u64}
        else {
            let sign=1u64<<(size*8-1);
            [0,1,u64::MAX,sign,sign-1,0x55aa55aa55aa55aa,0x1122334455667788][(lane+trial)%7]
        };
        unsafe{std::ptr::copy_nonoverlapping(v.to_le_bytes().as_ptr(),storage.as_mut_ptr().cast::<u8>().add(offset+lane*size),size)};
    }
}
fn raw(data:&[u8])->u64 {let mut a=[0u8;8];a[..data.len()].copy_from_slice(data);u64::from_le_bytes(a)}
fn float_match(a:&[u8],b:&[u8],ty:&str,op:&str)->bool {
    let size=bytes(ty);let bits=size*8;let sign=1u64<<(bits-1);
    let inf=match ty {"f16"=>0x7c00,"f32"=>0x7f800000,_=>0x7ff0000000000000};
    let x=raw(a);let y=raw(b);
    if x==y{return true}
    if x&!sign>inf && y&!sign>inf{return true}
    if matches!(op,"min"|"max"|"clamp"|"reduce_min"|"reduce_max") && x&!sign==0 && y&!sign==0{return true}
    let tolerance=if matches!(op,"sin"|"cos"|"exp"|"exp2"|"ln"|"log2"|"log10"|"recip") {4}else{0};
    if tolerance==0 || x&!sign>=inf || y&!sign>=inf{return false}
    let order=|v:u64|if v&sign!=0 {!v & (u64::MAX>>(64-bits))}else{v|sign};
    order(x).abs_diff(order(y))<=tolerance
}
fn main()->std::io::Result<()> {
    let args:Vec<String>=std::env::args().collect();assert_eq!(args.len(),3,"--record FILE or --check FILE");
    let recording=args[1]=="--record";assert!(recording||args[1]=="--check");
    let mut file=if recording {File::create(&args[2])?}else{File::open(&args[2])?};
    let signature=format!("PHISIMD1{SCHEMA}\n");
    if recording {file.write_all(signature.as_bytes())?}else{let mut h=vec![0;signature.len()];file.read_exact(&mut h)?;assert_eq!(h,signature.as_bytes(),"fixture schema differs")}
    let mut checks=0u64;let mut failures=0u64;
    for c in CASES {
        let n=c.lanes;let size=bytes(c.element);let payload=16*n+64;
        for trial in 0..8 {
            let input_offset=trial%4;
            let mut a=vec![0u64;n+16];let mut b=vec![0u64;n+16];let mut source=vec![0u64;2*n+16];
            fill(&mut a,input_offset,c.element,n,trial,0);fill(&mut b,input_offset,c.element,n,trial,1);fill(&mut source,0,c.element,2*n+3,trial,2);
            let mut index=vec![0u64;n+2];
            for lane in 0..n {
                let value=match trial {0=>lane,1=>2*n-1-lane,2=>lane%3,3=>if lane%3==0{usize::MAX}else{lane},4=>(lane*7)%(2*n+3),5=>n*4+lane,6=>0,_=>lane*2};
                unsafe{(index.as_mut_ptr().cast::<u8>().add(input_offset) as *mut usize).add(lane).write_unaligned(value)};
            }
            let length=[0,1,n.saturating_sub(1),n,n+3,2*n,2*n+3,n][trial];
            let bits=[0,u64::MAX,0xaaaaaaaaaaaaaaaa,0x5555555555555555,1,1u64<<63,0x13579bdf2468ace0,u64::MAX][trial];
            let start=64+(trial%4)*size;
            let mut arena=vec![0xa5a5a5a5a5a5a5a5u64;(payload+256)/8+1];
            unsafe{(c.run)(arena.as_mut_ptr().cast::<u8>().add(start),a.as_ptr().cast::<u8>().add(input_offset),b.as_ptr().cast::<u8>().add(input_offset),source.as_ptr().cast(),length,index.as_ptr().cast::<u8>().add(input_offset).cast(),bits)};
            let all=unsafe{std::slice::from_raw_parts(arena.as_ptr().cast::<u8>(),arena.len()*8)};
            assert!(all[..start].iter().all(|x|*x==0xa5)&&all[start+payload..].iter().all(|x|*x==0xa5),"output guard corrupted: {} trial {}",c.name,trial);
            let got=&all[start..start+payload];
            if recording {file.write_all(got)?}else{
                let mut expected=vec![0u8;payload];file.read_exact(&mut expected)?;
                let result_size=bytes(c.result);
                let output_lanes=if c.operation.starts_with("reduce_"){1}else if c.operation=="scatter"||c.operation=="store_select"{length}else{n};
                let float_len=if c.result.starts_with('f'){result_size*output_lanes}else{0};
                let matches=expected[float_len..]==got[float_len..] && (0..float_len).step_by(result_size).all(|i|float_match(&expected[i..i+result_size],&got[i..i+result_size],c.result,c.operation));
                if !matches {failures+=1;if failures<=20{eprintln!("FAIL {} trial {}",c.name,trial)}}
            }
            checks+=1;
        }
    }
    if !recording{let mut extra=[0];assert_eq!(file.read(&mut extra)?,0,"fixture has trailing records")}
    eprintln!("{} portable SIMD: {} API cases, {} differential trials, {} failures",if failures==0{"PASS"}else{"FAIL"},CASES.len(),checks,failures);
    if failures!=0{std::process::exit(1)}
    Ok(())
}
