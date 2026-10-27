#!/usr/bin/env python3
"""FP extending loads / truncating stores, contiguous and indexed masks."""
from pathlib import Path
root=Path(__file__).resolve().parents[1]
s='''; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
'''
h='/* Generated masked FP conversion matrix. */\n'
decls=set()
for n in (2,4,8,16,32):
 for indexed in (0,1):
  for align in (1,4):
   for store in (0,1):
    name=f'masked_fp_{"store" if store else "load"}_{n}_{indexed}_{align}'
    s+=f'define void @{name}(ptr %out, ptr %base, ptr %values, ptr %maskptr) {{\n %mi=load <{n} x i32>,ptr %maskptr,align 4\n %mask=icmp ne <{n} x i32> %mi,zeroinitializer\n'
    if indexed:s+=f' %ptrs=load <{n} x ptr>,ptr %base,align 8\n'
    addr=f'<{n} x ptr> %ptrs' if indexed else 'ptr %base'
    if not store:
     op='gather' if indexed else 'load';suffix=f'v{n}p0' if indexed else 'p0'
     # Alignment is an immediate for gather, pointer annotation for load.
     args=f'{addr},i32 {align}' if indexed else f'ptr align {align} %base'
     s+=f' %pass=load <{n} x float>,ptr %values,align 1\n %x=call <{n} x float> @llvm.masked.{op}.v{n}f32.{suffix}({args},<{n} x i1> %mask,<{n} x float> %pass)\n %r=fpext <{n} x float> %x to <{n} x double>\n store <{n} x double> %r,ptr %out,align 1\n'
     decls.add(f'declare <{n} x float> @llvm.masked.{op}.v{n}f32.{suffix}('+ (f'<{n} x ptr>,i32 immarg' if indexed else 'ptr')+f',<{n} x i1>,<{n} x float>)\n')
    else:
     op='scatter' if indexed else 'store';suffix=f'v{n}p0' if indexed else 'p0'
     args=f'{addr},i32 {align}' if indexed else f'ptr align {align} %base'
     s+=f' %x=load <{n} x double>,ptr %values,align 1\n %r=fptrunc <{n} x double> %x to <{n} x float>\n call void @llvm.masked.{op}.v{n}f32.{suffix}(<{n} x float> %r,{args},<{n} x i1> %mask)\n'
     decls.add(f'declare void @llvm.masked.{op}.v{n}f32.{suffix}(<{n} x float>,'+ (f'<{n} x ptr>,i32 immarg' if indexed else 'ptr')+f',<{n} x i1>)\n')
    s+=' ret void\n}\n'
    h+=f'K({name},{n},{indexed},{align},{store})\n'
s+=''.join(sorted(decls))
(root/'tests/knc-masked-fp-conversions.ll').write_text(s)
(root/'tests/masked-fp-conversion-cases.h').write_text(h)
