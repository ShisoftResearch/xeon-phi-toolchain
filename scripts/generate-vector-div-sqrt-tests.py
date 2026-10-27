#!/usr/bin/env python3
from pathlib import Path
root=Path(__file__).resolve().parents[1]
s='''; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,-knc-native-abi -verify-machineinstrs < %s -o /dev/null
; KNC has no exact native vector divide/sqrt: expand before scalar FP softening.
target triple = "x86_64-unknown-linux-gnu"
'''
h='/* Generated scalar-runtime vector math matrix. */\n'
for bits,ty in [(32,'float'),(64,'double')]:
 for n in [2,4,8,16,32]:
  for op in ['div','sqrt']:
   name=f'vector_{op}{n}_f{bits}';vt=f'<{n} x {ty}>';align=bits//8
   callee=('__divsf3' if bits==32 else '__divdf3') if op=='div' else ('sqrtf' if bits==32 else 'sqrt')
   s+=f'; CHECK-LABEL: {name}:\n; CHECK: callq {callee}\n'
   s+=f'define void @{name}(ptr %out,ptr %a,ptr %b) {{\n %x=load {vt},ptr %a,align {align}\n'
   if op=='div':s+=f' %y=load {vt},ptr %b,align {align}\n %r=fdiv {vt} %x,%y\n'
   else:s+=f' %r=call {vt} @llvm.sqrt.v{n}f{bits}({vt} %x)\n'
   s+=f' store {vt} %r,ptr %out,align {align}\n ret void\n}}\n'
   if op=='sqrt':s+=f'declare {vt} @llvm.sqrt.v{n}f{bits}({vt})\n'
  h+=f'K({n},{bits})\n'
(root/'tests/knc-vector-div-sqrt.ll').write_text(s)
(root/'tests/vector-div-sqrt-cases.h').write_text(h)
