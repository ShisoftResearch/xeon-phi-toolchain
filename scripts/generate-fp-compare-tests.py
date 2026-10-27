#!/usr/bin/env python3
from pathlib import Path
root=Path(__file__).resolve().parents[1]
preds=['false','oeq','ogt','oge','olt','ole','one','ord','uno','ueq','ugt','uge','ult','ule','une','true']
ops=['minnum','maxnum','minimum','maximum','minimumnum','maximumnum']
s='''; RUN: llc -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -O0 -mcpu=knc -mattr=-sse,-sse2,+soft-float,+knc-native-abi -verify-machineinstrs < %s -o /dev/null
target triple = "x86_64-unknown-linux-gnu"
'''
for bits,n,ty in [(32,16,'float'),(64,8,'double')]:
 vt=f'<{n} x {ty}>';it=f'<{n} x i{bits}>';bt=f'<{n} x i1>';align=bits//8
 def head(name,other=True):
  return f'define void @{name}(ptr %out,ptr %a,ptr %b) {{\n %x=load {vt},ptr %a,align {align}\n'+(f' %y=load {vt},ptr %b,align {align}\n' if other else '')
 for pred in preds:
  for select in [False,True]:
   name=f'{"select" if select else "cmp"}_f{bits}_{pred}'
   if pred=='oeq':s+=f'; CHECK-LABEL: {name}:\n; CHECK: knc.vcmp{ "ps" if bits==32 else "pd"}\n'
   s+=head(name)+f' %c=fcmp {pred} {vt} %x,%y\n'
   s+=(f' %r=select {bt} %c,{vt} %x,{vt} %y\n store {vt} %r,ptr %out,align {align}\n' if select else f' %r=sext {bt} %c to {it}\n store {it} %r,ptr %out,align {align}\n')+' ret void\n}\n'
 for op in ['fabs','fneg']+ops:
  name=f'{op}_f{bits}'
  if op=='minnum':
   s+=f'; CHECK-LABEL: {name}:\n; CHECK: knc.vcmp{"ps" if bits==32 else "pd"}\n'
   if bits==64:s+='; CHECK: knc.vblendmpd\n'
  s+=head(name,op not in ['fabs','fneg'])
  if op=='fneg':s+=f' %r=fneg {vt} %x\n'
  else:
   args=f'{vt} %x'+(f',{vt} %y' if op!='fabs' else '')
   s+=f' %r=call {vt} @llvm.{op}.v{n}f{bits}({args})\n'
  s+=f' store {vt} %r,ptr %out,align {align}\n ret void\n}}\n'
  if op!='fneg':s+=f'declare {vt} @llvm.{op}.v{n}f{bits}({vt}'+(f',{vt}' if op!='fabs' else '')+')\n'
 s+=head(f'variable_select_f{bits}')+f' %mi=load {it},ptr %out,align {align}\n %c=icmp ne {it} %mi,zeroinitializer\n %r=select {bt} %c,{vt} %x,{vt} %y\n store {vt} %r,ptr %out,align {align}\n ret void\n}}\n'
(root/'tests/knc-fp-compare.ll').write_text(s)
h='/* Generated comparison X-macro matrix. */\n'+''.join(f'P({p})\n' for p in preds)+''.join(f'M({m})\n' for m in ops)
(root/'tests/fp-compare-cases.h').write_text(h)
