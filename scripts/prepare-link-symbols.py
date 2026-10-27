#!/usr/bin/env python3
"""Re-emit rustc's undefined-symbol roots as K1OM assembler metadata; never code."""
import pathlib,re,struct,subprocess,sys
source=pathlib.Path(sys.argv[1]);target=pathlib.Path(sys.argv[2]);root=pathlib.Path(__file__).resolve().parents[1];b=source.read_bytes()
if b[:6]!=b'\x7fELF\x02\x01' or int.from_bytes(b[18:20],'little')!=62:raise SystemExit('expected rustc ELF64 x86-64 symbols metadata')
off=struct.unpack_from('<Q',b,40)[0];size,num=struct.unpack_from('<HH',b,58);sections=[];symbols=[]
for i in range(num):
 s=struct.unpack_from('<IIQQQQIIQQ',b,off+i*size);sections.append(s)
 if s[2]&6 or s[1] in (1,4,9):raise SystemExit('refusing symbols metadata containing code, allocated data, PROGBITS, or relocations')
for s in sections:
 if s[1]!=2:continue
 strings=sections[s[6]];table=b[strings[4]:strings[4]+strings[5]]
 for pos in range(s[4],s[4]+s[5],s[9]):
  name,info,other,index,value,length=struct.unpack_from('<IBBHQQ',b,pos)
  if not name:continue
  name=table[name:table.index(b'\0',name)].decode('ascii')
  if index or value or length or info!=16 or other or not re.fullmatch(r'[A-Za-z_.$][A-Za-z0-9_.$]*',name):raise SystemExit('unexpected defined, typed, non-global, or non-default-visibility symbol')
  symbols.append(name)
asm=target.with_suffix('.s');asm.write_text('.section .note.GNU-stack,"",@progbits\n'+'\n'.join('.globl '+s for s in symbols)+'\n')
from phi_common import sdk_tool
subprocess.run([str(sdk_tool('as')),'-march=k1om','--64',str(asm),'-o',str(target)],check=True)
if int.from_bytes(target.read_bytes()[18:20],'little')!=181:raise SystemExit('assembler did not emit K1OM symbols metadata')
