#!/usr/bin/env python3
"""Record the natural return of the already-observed late13 CODE36 search."""
import gzip,json,struct
from pathlib import Path
from gdb_remote import Remote
from qmp_session import command
from maven_debug_cleanup import cleanup_breakpoints
command('stop');r=Remote();r.sock.settimeout(60);points=set();out=Path('analysis/toolchain/late-search-finish-live.json')
def read(addr,n):return bytes.fromhex(r.command(f'm{addr:x},{n:x}'))
try:
 r.command('?');assert read(0x40800000,16).hex()=='f1acad130000002a067c4efa00804efa';entry=json.loads(Path('analysis/toolchain/late-search-dispatch-02-live.json').read_text());a5=int.from_bytes(read(0x904,4),'big');assert a5==entry['a5'];caller=int.from_bytes(bytes.fromhex(entry['stack'])[:4],'big');assert r.command(f'Z0,{caller:x},2')=='OK';points.add(caller);r.command('c');g=struct.unpack('>18I',bytes.fromhex(r.command('g')));assert g[17]==caller;report=dict(scope=__doc__,registers=g,ranking=read(a5-0x5a10,340).hex(),count=int.from_bytes(read(a5-0x30fc,2),'big'),board=read(a5-0x4302,544).hex(),values=read(a5-0x40e2,1088).hex(),rack0=read(a5-0x3c9a,8).hex(),rack1=read(a5-0x3ca2,8).hex(),complete=True);out.write_text(json.dumps(report,indent=2)+'\n');print('Returned',report['count'],'ranked moves',flush=True)
finally:
 cleanup=cleanup_breakpoints(r,points)
 if 'report' in locals():report['cleanup']=cleanup;out.write_text(json.dumps(report,indent=2)+'\n')
