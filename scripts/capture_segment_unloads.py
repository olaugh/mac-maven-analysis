#!/usr/bin/env python3
"""Observe original UnloadSeg arguments from CODE 11's fifteen-call routine.

Select Maven in Finder first; --launch-selected opens it after arming the trap.
Only debugger breakpoints and reads are used. Leaves the guest paused.
"""
import argparse
import ctypes
import hashlib
import json
from pathlib import Path
import re
import struct
import subprocess
import tempfile
import time
from gdb_remote import Remote
from qmp_session import command


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--launch-selected', action='store_true')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    code = Path('resources/CODE/11_11.bin').read_bytes()
    command('stop')
    r = Remote()
    handler = None
    armed = False
    rows = []
    try:
        r.command('?')
        assert r.command('m40800000,10') == 'f1acad130000002a067c4efa00804efa'
        xml = r.command('qXfer:features:read:m68k-core.xml:0,fff')
        assert re.findall(r'<reg name="([^"]+)"', xml) == (
            [f'd{i}' for i in range(8)] + [f'a{i}' for i in range(6)] + ['fp','sp','ps','pc'])
        handler = int(r.command('m15c4,4'),16) # Toolbox table, A9F1
        assert r.command(f'Z0,{handler:x},2') == 'OK'
        armed = True
        r.command('c',wait=False)
        if args.launch_selected:
            command('human-monitor-command',{'command-line':'sendkey meta_l-o 30'})
        deadline = time.monotonic()+120
        base = None
        unrelated = 0
        while len(rows) < 15:
            if time.monotonic() > deadline:
                raise TimeoutError('Maven unload sequence did not finish')
            r.receive()
            assert r.command(f'z0,{handler:x},2') == 'OK'
            armed = False
            regs = struct.unpack('>18I',bytes.fromhex(r.command('g')))
            assert regs[17] == handler
            ret, arg = struct.unpack('>2I',bytes.fromhex(r.command(f'm{regs[15]:x},8')))
            if base is None:
                candidate = ret-0x0d52
                if candidate >= 0:
                    live = r.command(f'm{candidate:x},{len(code):x}')
                    if not live.startswith('E') and bytes.fromhex(live) == code:
                        base = candidate
                        a5 = regs[13]
            if base is not None and base+0xd52 <= ret <= base+0xda6:
                assert ret == base+0xd52+6*len(rows)
                assert regs[13] == a5
                rows.append(dict(return_resource_offset=ret-base,
                                 routine_address=arg,a5_offset=arg-a5))
            else:
                unrelated += 1
            if len(rows) < 15:
                r.command('s')
                assert r.command(f'Z0,{handler:x},2') == 'OK'
                armed = True
                r.command('c',wait=False)
        # Compare compiled reconstruction through its explicit Toolbox adapter.
        source = Path('reconstruction/segment_management.c').resolve()
        with tempfile.TemporaryDirectory() as temp:
            libpath = Path(temp)/'segments.dylib'
            subprocess.run(['cc','-Wall','-Wextra','-Werror','-dynamiclib',
                            str(source),'-o',str(libpath)],check=True)
            lib = ctypes.CDLL(str(libpath))
            buffer = ctypes.create_string_buffer(3584)
            hostbase = ctypes.addressof(buffer)
            offsets = []
            callback_type = ctypes.CFUNCTYPE(None,ctypes.c_void_p)
            callback = callback_type(lambda address: offsets.append(address-hostbase))
            fn = lib.maven_unload_startup_segments
            fn.argtypes = [ctypes.c_void_p,callback_type]
            fn.restype = None
            fn(buffer,callback)
        actual = [row['a5_offset'] for row in rows]
        report = dict(code11_base=base,a5=a5,unloadseg_handler=handler,
                      code11_exact_match=True,code11_sha256=hashlib.sha256(code).hexdigest(),
                      calls=rows,unrelated_calls=unrelated,reconstructed_offsets=offsets,
                      exact_argument_sequence_match=actual == offsets,
                      scope='Original trap entry arguments; Toolbox implementation not reconstructed')
        args.output.parent.mkdir(parents=True,exist_ok=True)
        args.output.write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps(report,indent=2),flush=True)
        assert actual == offsets
    finally:
        command('stop')
        if armed:
            r.command(f'z0,{handler:x},2')
        r.close()


if __name__ == '__main__':
    main()
