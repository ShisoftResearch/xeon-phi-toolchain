#!/usr/bin/env python3
from pathlib import Path
root=Path(__file__).resolve().parents[1]
types=[('i8','i8',1),('i16','i16',2),('i32','i32',4),('i64','i64',8),('f32','float',4),('f64','double',8),('p0','ptr',8)]
s='''; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: opt -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -passes=scalarize-masked-mem-intrin -S < %s | FileCheck %s --check-prefix=KEEP
; KEEP: call <2 x i8> @llvm.masked.expandload
; KEEP: call void @llvm.masked.compressstore.v16p0
target triple = "x86_64-unknown-linux-gnu"
'''
h='/* Packed-memory X-macro cases: K(lanes, element tag, bytes). */\n'
for n in [2,4,8,16]:
 for tag,ty,b in types:
  h+=f'K({n},{tag},{b})\n';v=f'<{n} x {ty}>'
  for mode in ['aligned','unaligned']:
   for op in ['expand','compress']:
    native=b==4 and mode=='aligned'
    s+=f'; CHECK-LABEL: packed_{op}{n}_{tag}_{mode}:\n'
    s+=f'; CHECK: knc.vp{"gather" if op=="expand" else "scatter"}dd\n' if native else '; CHECK: bsfl\n'
    s+=f'define void @packed_{op}{n}_{tag}_{mode}(ptr %out,ptr %base,ptr %values,ptr %maskptr) {{\n %mi=load <{n} x i32>,ptr %maskptr,align 4\n %mask=icmp ne <{n} x i32> %mi,zeroinitializer\n %v=load {v},ptr %values,align 1\n'
    align=b if mode=='aligned' else 1
    if op=='expand':s+=f' %r=call {v} @llvm.masked.expandload.v{n}{tag}(ptr align {align} %base,<{n} x i1> %mask,{v} %v)\n store {v} %r,ptr %out,align 1\n'
    else:s+=f' call void @llvm.masked.compressstore.v{n}{tag}({v} %v,ptr align {align} %base,<{n} x i1> %mask)\n'
    s+=' ret void\n}\n'
  s+=f'declare {v} @llvm.masked.expandload.v{n}{tag}(ptr,<{n} x i1>,{v})\n'
  s+=f'declare void @llvm.masked.compressstore.v{n}{tag}({v},ptr,<{n} x i1>)\n'
(root/'tests/knc-packed.ll').write_text(s);(root/'tests/packed-cases.h').write_text(h)
