#!/usr/bin/env python3
"""Recheck preserved comparison builds; does not launch the historical compilers."""
import argparse
import hashlib
import json
from pathlib import Path
import sys
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from extract_resources import parse_rdump

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--runtime',type=Path,default=ROOT/'../../media/maven');a=p.parse_args()
    share=a.runtime/'session/share';five=share/'THINK C 5/Probe App.rdump';six=share/'Development/THINK C/Probe App 6.rdump';source=share/'Development/THINK C/probe.c'
    maven=(ROOT/'resources/CODE/1_1.bin').read_bytes();p5=parse_rdump(five)['CODE'];p6=parse_rdump(six)['CODE']
    c5=p5[1]['data'];c6=p6[1]['data'];report=json.loads((ROOT/'analysis/toolchain/think-c-6-probe.json').read_text())
    digest=lambda b:hashlib.sha256(b).hexdigest()
    assert digest(six.read_bytes())==report['probe_rdump_sha256']
    host_source=(ROOT/'reconstruction/toolchain_probe.c').read_bytes()
    assert digest(host_source)==report['source_sha256']
    assert source.read_bytes()==host_source.replace(b'\n',b'\r')
    assert (share/'THINK C 5/probe.c').read_bytes()==source.read_bytes()
    assert len(c6)==len(maven)==578
    differences=[i for i,(a,b) in enumerate(zip(c6,maven)) if a!=b]
    assert set(differences)<=set(range(4,8)) and c6[12:]==maven[12:]
    assert c5[0x34:0x22e]==maven[0x48:0x242]
    assert p5[2]['data'][4:]==p6[2]['data'][4:]
    assert p6[2]['data'].hex()==report['code2_hex']
    print(json.dumps(dict(scope='Preserved artifacts reverified, not a new compiler execution. THINK-family startup match does not uniquely identify original release or optimization settings.',maven_code1_sha256=digest(maven),think6_code1_sha256=digest(c6),think6_startup_body_matching_bytes=566,think6_differing_offsets=differences,think5_shared_runtime_matching_bytes=506,probe_main_matching_between_versions_bytes=len(p6[2]['data'])-4,think6_probe_rdump_sha256=digest(six.read_bytes()),think6_probe_source_cr_sha256=digest(source.read_bytes()),canonical_source_lf_sha256=digest(host_source),source_copies_differ_only_in_line_endings=True,prior_runtime_execution=report['runtime_execution']),indent=2))
if __name__=='__main__':main()
