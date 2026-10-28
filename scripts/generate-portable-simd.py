#!/usr/bin/env python3
"""Generate Rust portable-SIMD API probes, grouped by element type and lane count."""
import json
from phi_common import BUILD

out=BUILD/'portable-simd/probes';out.mkdir(parents=True,exist_ok=True)
widths=[1,2,3,4,7,8,16,17,32,64]
types=['i8','u8','i16','u16','i32','u32','i64','u64','isize','usize','f16','f32','f64']
def write(path,text):
    if not path.exists() or path.read_text()!=text:path.write_text(text)

manifest=[]
wrappers=[]
entries=[]
modules=[]
for ty in types:
    floating=ty.startswith('f');signed=ty.startswith('i')
    mask='i'+ty[1:] if ty.startswith(('u','f')) else ty
    for n in widths:
        vector=f'Simd::<{ty},{n}>'
        ops={'add':'a+b','sub':'a-b','mul':'a*b','div':'a/b','rem':'a%b',
             'select':'a.simd_lt(b).select(a,b)',
             'min':'a.simd_min(b)','max':'a.simd_max(b)',
             'clamp':'a.simd_clamp(b.simd_min(a),b.simd_max(a))',
             'reverse':f'simd_swizzle!(a, [{",".join(str(x) for x in reversed(range(n)))}])',
             'two_swizzle':f'simd_swizzle!(a,b,[{",".join(str((i*3)%(n*2)) for i in range(n))}])',
             'reverse_method':'a.reverse()',
             'rotate_left':'a.rotate_elements_left::<0>()' if n==1 else 'a.rotate_elements_left::<1>()',
             'rotate_right':'a.rotate_elements_right::<0>()' if n==1 else 'a.rotate_elements_right::<1>()',
             'interleave_lo':'a.interleave(b).0','interleave_hi':'a.interleave(b).1',
             'deinterleave_lo':'a.deinterleave(b).0','deinterleave_hi':'a.deinterleave(b).1',
             'mask_select':f'Mask::<{mask},{n}>::from_bitmask(bits).select(a,b)',
             'load_select':f'{vector}::load_select(slice,Mask::<{mask},{n}>::from_bitmask(bits),b)',
             'gather':f'{vector}::gather_select(slice,Mask::<isize,{n}>::from_bitmask(bits),indexes,b)'}
        reductions={op:f'a.{op}()' for op in ['reduce_sum','reduce_product','reduce_min','reduce_max']}
        if not floating:
            ops.update({'and':'a&b','or':'a|b','xor':'a^b','not':'!a','shl':'a<<b','shr':'a>>b',
                        'saturating_add':'a.saturating_add(b)','saturating_sub':'a.saturating_sub(b)',
                        'reverse_bits':'a.reverse_bits','count_ones':'a.count_ones'})
            # The trait methods are callable, not associated vector values.
            ops['reverse_bits']='a.reverse_bits()';ops['count_ones']='a.count_ones()'
            for op in ['swap_bytes','count_zeros','leading_zeros','trailing_zeros','leading_ones','trailing_ones','abs_diff']:
                ops[op]='a.abs_diff(b)' if op=='abs_diff' else f'a.{op}()'
            if not signed:ops['wrapping_neg']='a.wrapping_neg()'
            reductions.update({op:f'a.{op}()' for op in ['reduce_and','reduce_or','reduce_xor']})
            if signed:
                ops.update({'abs':'a.abs()','signum':'a.signum()','saturating_abs':'a.saturating_abs()','saturating_neg':'a.saturating_neg()','neg':'-a'})
            if ty=='u8':ops['dynamic_swizzle']='a.swizzle_dyn(b)'
        else:
            ops.update({op:f'a.{op}()' for op in ['abs','signum','recip','sqrt','floor','ceil','trunc','round','sin','cos','exp','exp2','ln','log2','log10','round_ties_even','fract']})
            ops['mul_add']='a.mul_add(b,a)'
            ops['neg']='-a'
        header='#![no_std]\n#![feature(portable_simd,f16)]\n#![allow(unused_attributes,unused_imports,unused_variables,unsafe_op_in_unsafe_fn)]\nextern crate std;\nuse core::simd::{Simd,Mask,prelude::*,simd_swizzle};\nuse std::simd::StdFloat;\n'
        functions=[];cases=[]
        prefix=f'psimd_{ty}_{n}_'
        pre=f'let a={vector}::from_array(a.cast::<[{ty};{n}]>().read_unaligned());let b={vector}::from_array(b.cast::<[{ty};{n}]>().read_unaligned());let slice=core::slice::from_raw_parts(source,length);let indexes=Simd::<usize,{n}>::from_array(index.cast::<[usize;{n}]>().read_unaligned());'
        signature=f'out:*mut {ty}, a:*const {ty}, b:*const {ty}, source:*const {ty},length:usize,index:*const usize,bits:u64'
        def add(name,body,result=ty):
            symbol=prefix+name
            functions.append(f'#[unsafe(no_mangle)] pub unsafe extern "C" fn {symbol}({signature}){{{pre}{body}}}\n')
            cases.append({'symbol':symbol,'operation':name,'result':result})
            module=f'group_{ty}_{n}'
            wrapper='call_'+symbol
            wrappers.append(f'unsafe extern "C" fn {wrapper}(o:*mut u8,a:*const u8,b:*const u8,s:*const u8,l:usize,i:*const usize,m:u64){{unsafe{{{module}::{symbol}(o.cast(),a.cast(),b.cast(),s.cast(),l,i,m)}}}}')
            entries.append(f'Case{{name:"{symbol}",element:"{ty}",lanes:{n},operation:"{name}",result:"{result}",run:{wrapper}}}')
        for op,expr in ops.items():
            result_ty = ('u'+ty[1:]) if signed and (op in ['count_ones','count_zeros','leading_zeros','trailing_zeros','leading_ones','trailing_ones','abs_diff']) else ty
            add(op,f'let r={expr};out.cast::<[{result_ty};{n}]>().write_unaligned(r.to_array());',result_ty)
        for op,expr in reductions.items():add(op,f'out.write_unaligned({expr});')
        for dest in types:
            if dest==ty:continue
            add('cast_'+dest,f'let r=a.cast::<{dest}>();out.cast::<[{dest};{n}]>().write_unaligned(r.to_array());',dest)
        for op in ['eq','ne','lt','le','gt','ge']:
            add('compare_'+op,f'out.cast::<u64>().write_unaligned(a.simd_{op}(b).to_bitmask());','u64')
        add('mask_roundtrip',f'let m=Mask::<{mask},{n}>::from_bitmask(bits);out.cast::<u64>().write_unaligned(m.to_bitmask());','u64')
        for op in ['any','all','first_set','last_set']:
            expr=f'a.simd_lt(b).{op}()'
            if op.endswith('_set'):expr=f'({expr}).unwrap_or(usize::MAX) as u64'
            else:expr=f'({expr}) as u64'
            add('mask_'+op,f'out.cast::<u64>().write_unaligned({expr});','u64')
        add('store_select',f'a.store_select(core::slice::from_raw_parts_mut(out,length),Mask::<{mask},{n}>::from_bitmask(bits));')
        add('scatter',f'a.scatter_select(core::slice::from_raw_parts_mut(out,length),Mask::<isize,{n}>::from_bitmask(bits),indexes);')
        path=out/f'{ty}-{n}.rs';write(path,header+'\n'.join(functions))
        modules.append(f'#[path={json.dumps(str(path))}] mod group_{ty}_{n};')
        manifest.append({'element':ty,'lanes':n,'source':str(path),'cases':cases})
write(out.parent/'manifest.json',json.dumps({'groups':manifest,'cases':sum(len(x['cases']) for x in manifest)},indent=2)+'\n')
print('Generated',len(manifest),'groups and',sum(len(x['cases']) for x in manifest),'portable SIMD API cases')

import hashlib
schema=hashlib.sha256(json.dumps([{'element':g['element'],'lanes':g['lanes'],'cases':g['cases']} for g in manifest],sort_keys=True).encode()).hexdigest()
write(out.parent/'corpus-generated.rs','\n'.join(modules+wrappers)+f'\nconst SCHEMA:&str="{schema}";\nstatic CASES:&[Case]=&[\n'+',\n'.join(entries)+'\n];\n')
