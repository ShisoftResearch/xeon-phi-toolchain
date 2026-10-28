"""Check fixture schema/ABI metadata used by the differential SIMD suite."""
import contextlib
import io
import json
from pathlib import Path
import runpy
import sys
import tempfile
import unittest
from unittest.mock import patch
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'scripts'))
import phi_common

class PortableSimdMetadata(unittest.TestCase):
    def generate(self,root):
        with patch.object(phi_common,'BUILD',root),contextlib.redirect_stdout(io.StringIO()):
            result=runpy.run_path(str(phi_common.ROOT/'scripts/generate-portable-simd.py'))
        data=json.loads((root/'portable-simd/manifest.json').read_text())
        return data,result['schema']
    def test_output_abi_and_relocatable_fixture_identity(self):
        with tempfile.TemporaryDirectory() as temp:
            data,schema=self.generate(Path(temp)/'first')
            sample=Path(data['groups'][0]['source']);mtime=sample.stat().st_mtime_ns
            self.generate(Path(temp)/'first')
            self.assertEqual(sample.stat().st_mtime_ns,mtime,'unchanged probes should not force a Cargo rebuild')
            relocated,other_schema=self.generate(Path(temp)/'second')
            self.assertEqual(schema,other_schema)
            self.assertEqual(data['cases'],9380)
            self.assertEqual(len(data['groups']),130)
            group=next(g for g in data['groups'] if g['element']=='i16' and g['lanes']==17)
            cases={c['operation']:c for c in group['cases']}
            for op in ['count_ones','count_zeros','leading_zeros','trailing_zeros','abs_diff']:
                self.assertEqual(cases[op]['result'],'u16')
            for op in ['mask_any','mask_all','mask_first_set','mask_last_set','mask_roundtrip','compare_eq']:
                self.assertEqual(cases[op]['result'],'u64')
            self.assertEqual(cases['cast_f16']['result'],'f16')
            self.assertIn('scatter',cases)
            self.assertIn('gather',cases)

if __name__=='__main__':unittest.main()
