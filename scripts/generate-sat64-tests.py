#!/usr/bin/env python3
from pathlib import Path
root=Path(__file__).resolve().parents[1]
s='''; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
'''
for width in [8,16,32,64]:
 for sign in ['s','u']:
  s+=f'; CHECK-LABEL: sat64_{sign}{width}:\n; CHECK: knc.vpermd\n; CHECK: knc.vpsrlvd\n'
  s+=f'define void @sat64_{sign}{width}(ptr %out,ptr %in) {{\n %v=load <8 x double>,ptr %in,align 8\n %r=call <8 x i{width}> @llvm.fpto{sign}i.sat.v8i{width}.v8f64(<8 x double> %v)\n store <8 x i{width}> %r,ptr %out,align {width//8}\n ret void\n}}\ndeclare <8 x i{width}> @llvm.fpto{sign}i.sat.v8i{width}.v8f64(<8 x double>)\n'
(root/'tests/knc-saturating-f64.ll').write_text(s)
