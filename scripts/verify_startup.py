#!/usr/bin/env python3
"""Compare compiled readable startup with a complete original-runtime capture."""
import argparse
import ctypes
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('capture_dir', type=Path)
    parser.add_argument('--resources', type=Path, default=Path('resources'))
    args = parser.parse_args()
    report = json.loads((args.capture_dir/'startup-capture.json').read_text())
    before = (args.capture_dir/'globals-before.bin').read_bytes()
    actual = (args.capture_dir/'globals-after.bin').read_bytes()
    assert len(before) == len(actual) == report['below_a5']
    for data, field in ((before, 'before_sha256'), (actual, 'actual_sha256')):
        assert hashlib.sha256(data).hexdigest() == report[field]
    blobs = [(args.resources/kind/'0_0.bin').read_bytes() for kind in ('DATA','ZERO','DREL')]
    source = Path(__file__).resolve().parents[1]/'reconstruction/global_initializer.c'
    with tempfile.TemporaryDirectory() as temp:
        library_path = Path(temp)/'initializer.dylib'
        subprocess.run(['cc','-Wall','-Wextra','-Werror','-dynamiclib',str(source),
                        '-o',str(library_path)],check=True)
        library = ctypes.CDLL(str(library_path))
        function = library.maven_initialize_globals
        function.argtypes = [ctypes.c_void_p,ctypes.c_size_t]*4 + [ctypes.c_uint32]
        function.restype = ctypes.c_int
        output = ctypes.create_string_buffer(before,len(before))
        inputs = [item for blob in blobs for item in (blob,len(blob))]
        assert function(output,len(before),*inputs,report['a5']) == 0
        reconstructed = output.raw
    report.update(compared_bytes=len(actual),
                  mismatches=sum(a != b for a,b in zip(actual,reconstructed)),
                  reconstruction_sha256=hashlib.sha256(reconstructed).hexdigest(),
                  before_distinct_byte_values=len(set(before)),
                  changed_byte_count=sum(a != b for a,b in zip(before,actual)),
                  drel_entries=len(blobs[2])//2)
    print(json.dumps(report,indent=2))
    if actual != reconstructed:
        raise SystemExit('Reconstruction differs from original runtime')


if __name__ == '__main__':
    main()
