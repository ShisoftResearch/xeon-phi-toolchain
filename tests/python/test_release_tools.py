"""Regression tests for safe source preparation and publication boundaries."""
import hashlib
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

SCRIPTS=Path(__file__).resolve().parents[2]/'scripts';sys.path.insert(0,str(SCRIPTS))
import phi
import release
import phi_compiler

class SourcePreparation(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory();self.addCleanup(self.temp.cleanup)
        self.root=Path(self.temp.name);self.upstream=self.root/'upstream';self.upstream.mkdir()
        self.git('init','-q');self.git('config','user.name','Fixture');self.git('config','user.email','fixture@example.invalid')
        (self.upstream/'sample.c').write_text('int value = 1;\n');self.git('add','.');self.git('commit','-qm','fixture')
        revision=self.git('rev-parse','HEAD').strip()
        (self.upstream/'sample.c').write_text('int value = 2;\n');data=subprocess.check_output(['git','-C',str(self.upstream),'diff','--binary','HEAD'])
        (self.upstream/'sample.c').write_text('int value = 1;\n')
        (self.root/'change.patch').write_bytes(data)
        self.item={'url':str(self.upstream),'revision':revision,'patch':'change.patch','patch_sha256':hashlib.sha256(data).hexdigest()}
        self.source=self.root/'checkout'
        self.patcher=patch.multiple(phi,ROOT=self.root,LLVM_SOURCE=self.source,LOCK={'llvm':self.item},record=lambda *a:None)
        self.patcher.start();self.addCleanup(self.patcher.stop)
    def git(self,*args):
        return subprocess.check_output(['git','-C',str(self.upstream),*args],text=True)
    def test_fetch_apply_and_repeat(self):
        phi.prepare('llvm');self.assertEqual((self.source/'sample.c').read_text(),'int value = 2;\n')
        phi.prepare('llvm')
    def test_wrong_patch_hash_rejected_before_fetch(self):
        self.item['patch_sha256']='0'*64
        with self.assertRaisesRegex(SystemExit,'Patch hash'):phi.prepare('llvm')
        self.assertFalse(self.source.exists())
    def test_modified_source_is_preserved(self):
        phi.prepare('llvm');p=self.source/'sample.c';p.write_text('local edit\n')
        with self.assertRaisesRegex(SystemExit,'changes other'):phi.prepare('llvm')
        self.assertEqual(p.read_text(),'local edit\n')
    def test_wrong_revision_is_preserved(self):
        phi.prepare('llvm');self.item['revision']='0'*40
        with self.assertRaisesRegex(SystemExit,'revision differs'):phi.prepare('llvm')
        self.assertEqual((self.source/'sample.c').read_text(),'int value = 2;\n')

class PublicationBoundaries(unittest.TestCase):
    def test_private_material_is_rejected(self):
        home=('/'+'home'+'/operator/project').encode()
        address=str(__import__('ipaddress').IPv4Address(0xc0a80102)).encode()
        key=('ssh-'+'ed25519 '+'A'*68).encode()
        private=('-----BEGIN '+'PRIVATE KEY-----').encode()
        for data in [home,address,key,private,b'\x7fELF\x00compiled']:
            self.assertTrue(release.inspect_file('sample.txt',data))
        self.assertTrue(release.inspect_file('build/sdk/file',b'ordinary text'))
    def test_public_source_is_allowed(self):
        self.assertFalse(release.inspect_file('examples/hello.c',b'int main(void) { return 0; }\n'))
    def test_verbose_link_retains_target_linker_and_runtime(self):
        self.assertTrue(phi_compiler.linking(['-v','hello.c','-o','hello']))
        self.assertFalse(phi_compiler.linking(['-v']))
        self.assertFalse(phi_compiler.linking(['-c','hello.c']))
    def test_architecture_profiles_do_not_advertise_missing_isa(self):
        knl=phi.llama_options('knl','repack');knc=phi.llama_options('knc','default')
        self.assertIn('-DGGML_AVX512=OFF',knl)
        self.assertIn('-DCMAKE_C_FLAGS=-march=knl -mtune=knl',knl)
        self.assertIn('-DGGML_AVX2=OFF',knc)
        self.assertIn('-DGGML_K1OM_NATIVE_QUANTS=ON',knc)
        self.assertIn('-DGGML_K1OM_MM_TILES=ON',knc)

if __name__=='__main__':unittest.main()
