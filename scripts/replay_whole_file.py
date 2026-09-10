#!/usr/bin/env python3
"""Compare reconstructed whole-file loading with recorded natural startup."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile

def digest(data):return hashlib.sha256(data).hexdigest()

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--capture',type=Path,required=True)
    p.add_argument('--data-file',type=Path,required=True)
    p.add_argument('--index',action='store_true',help='Also execute the reconstructed index caller (not covered by this guest capture)')
    args=p.parse_args();capture=json.loads(args.capture.read_text());data=args.data_file.read_bytes()
    assert digest(data)==capture['source_sha256']==capture['data_sha256']
    assert capture['complete_loaded_code_matches']
    assert digest(Path('resources/CODE/47_47.bin').read_bytes())==capture['code47_sha256']
    assert [r['operation'] for r in capture['calls']]==['FSOpen','GetEOF','NewPtrClear','FSRead','GetPtrSize','FSClose']
    assert all(r.get('error',0)==0 for r in capture['calls'])
    with tempfile.TemporaryDirectory() as temp:
        exe=Path(temp)/'probe';out=Path(temp)/'result'
        subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-Ireconstruction',
                        'scripts/whole_file_probe.c','reconstruction/whole_file.c','reconstruction/index_file.c',
                        'reconstruction/error_context.c','-o',str(exe)],check=True)
        result=json.loads(subprocess.check_output([str(exe),str(args.data_file),capture['name'],str(capture['volume']),
                           str(capture['calls'][0]['length']),str(out)]+(['index'] if args.index else []),text=True))
        actual=out.read_bytes()
    assert result['calls']=='oearsc'
    assert result['length']==capture['length']==capture['calls'][1]['length']==capture['calls'][3]['length']
    assert result['allocation']==capture['calls'][4]['size']
    assert result['trailing_byte']==capture['trailing_byte']==0
    assert actual==data+b'\0'
    if args.index:
        count=len(data)//4
        candidates=range(count-2,count-28,-1)
        expected=next(i for i in candidates if data[4*i+3]==ord('a'))
        assert result['index']==expected
    print(json.dumps(dict(scope='Native C replay of captured natural success using filesystem/allocator adapters; no guest pointer or error-path equivalence claim',
                         matches=True,reconstructed=result,data_sha256=digest(actual[:-1]),
                         index_caller_host_checked=args.index,index_caller_live_verified=False,
                         capture_sha256=digest(args.capture.read_bytes()),
                         index_source_sha256=digest(Path('reconstruction/index_file.c').read_bytes()) if args.index else None,
                         probe_sha256=digest(Path('scripts/whole_file_probe.c').read_bytes()),
                         reconstruction_sha256=digest(Path('reconstruction/whole_file.c').read_bytes())),indent=2))

if __name__=='__main__':main()
