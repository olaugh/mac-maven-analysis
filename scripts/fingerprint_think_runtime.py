#!/usr/bin/env python3
"""Compare independently recovered THINK runtime code to Maven's CODE 1."""
import argparse
import hashlib
import json
import sys
from pathlib import Path
from resource_inventory import resources

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from extract_resources import parse_rdump


def digest(data):
    return hashlib.sha256(data).hexdigest()


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--maven', type=Path, required=True)
    p.add_argument('--compiler', type=Path, required=True)
    p.add_argument('--probe', type=Path, required=True)
    p.add_argument('--disks', type=Path, required=True)
    a = p.parse_args()
    maven_fork = Path(str(a.maven)+'/..namedfork/rsrc').read_bytes()
    compiler_fork = Path(str(a.compiler)+'/..namedfork/rsrc').read_bytes()
    maven = {i:b for t,i,n,f,o,b in resources(maven_fork) if t=='CODE'}[1]
    comp = list(resources(compiler_fork))
    candidates = [('compiler', i, b) for t,i,n,f,o,b in comp if t=='CODE']
    probe = parse_rdump(a.probe)
    candidates += [('compiled_probe', i, r['data']) for i,r in probe['CODE'].items()]
    # This boundary follows decoded startup calls, not a generic short opcode.
    fingerprints = [('global_initializer_and_arithmetic',0x48,0x242),
                    ('globals',0x48,0xaa),('switches',0xaa,0xee),
                    ('multiply',0xee,0x124),('division',0x124,0x242)]
    matches = []
    for name, start, end in fingerprints:
        needle = maven[start:end]
        for source, rid, data in candidates:
            offset = data.find(needle)
            if offset >= 0:
                matches.append(dict(fingerprint=name, maven_offset=start,
                                    length=len(needle), sha256=digest(needle),
                                    reference=source, resource_id=rid, offset=offset))
    assert any(x['fingerprint']==fingerprints[0][0] and x['reference']=='compiled_probe'
               for x in matches), 'new compiler output does not match the full runtime block'
    print(json.dumps(dict(
        interpretation='Exact runtime-family match; not a unique compiler/linker version identification.',
        compiler_version_resources=[b.hex() for t,i,n,f,o,b in comp if t=='vers'],
        compiler_resource_sha256=digest(compiler_fork), maven_code1_sha256=digest(maven),
        probe_rdump_sha256=digest(a.probe.read_bytes()),
        distribution_disks=[dict(name=f.name,sha256=digest(f.read_bytes()))
                            for f in sorted(a.disks.glob('disk*.img'))],
        matches=matches),indent=2))


if __name__ == '__main__':
    main()
