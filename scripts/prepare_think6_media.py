#!/usr/bin/env python3
"""Repack preserved HFS installer floppies as partitioned SCSI volumes.

Requires machfs (isolated /tmp/maven-tools-venv in this workspace). Original
images are never modified. Verify every original file's forks/type/creator.
"""
import argparse
import hashlib
import json
import struct
from pathlib import Path
import machfs


def verify_files(original, reconstructed):
    for name, item in original.items():
        other = reconstructed[name]
        if isinstance(item, machfs.Folder):
            verify_files(item, other)
        else:
            assert (item.data,item.rsrc,item.type,item.creator) == (
                other.data,other.rsrc,other.type,other.creator)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('toolchain_root',type=Path)
    parser.add_argument('--driver-template',type=Path,required=True)
    args=parser.parse_args()
    output=args.toolchain_root/'hfs-media'
    output.mkdir(exist_ok=True)
    records=[]
    # Reuse the known-working disk's existing partition map and SCSI drivers.
    # This exact template has its HFS partition fifth, starting at block 704.
    with args.driver_template.open('rb') as f:
        prefix=bytearray(f.read(704*512))
    assert prefix[:2]==b'ER' and prefix[5*512:5*512+2]==b'PM'
    assert struct.unpack_from('>I',prefix,5*512+8)[0]==704
    assert prefix[5*512+48:5*512+57]==b'Apple_HFS'
    prefix_hash=hashlib.sha256(prefix).hexdigest()
    struct.pack_into('>I',prefix,4,704+4096)
    for index in range(1,6):
        struct.pack_into('>I',prefix,index*512+4,5)
    prefix[6*512:7*512]=bytes(512) # Remove obsolete trailing free partition.
    struct.pack_into('>I',prefix,5*512+12,4096)
    struct.pack_into('>I',prefix,5*512+84,4096)
    for path in sorted((args.toolchain_root/'disks').rglob('disk*.img')):
        source=path.read_bytes()
        assert source[1024:1026] == b'BD'
        # machfs 1.3 read() does not restore Volume.name. Read the actual MDB.
        name=source[1061:1061+source[1060]].decode('mac_roman')
        volume=machfs.Volume();volume.read(source);volume.name=name
        packed=volume.write(size=2*1024*1024,bootable=False)
        check=machfs.Volume();check.read(packed)
        assert packed[1061:1061+packed[1060]].decode('mac_roman') == name
        verify_files(volume,check)
        target=output/f'disk{int(path.stem[-2:])}.img'
        disk=bytes(prefix)+packed
        target.write_bytes(disk)
        records.append(dict(source=str(path),volume_name=name,output=str(target),
                            source_sha256=hashlib.sha256(source).hexdigest(),
                            output_sha256=hashlib.sha256(disk).hexdigest(),
                            driver_template_prefix_sha256=prefix_hash,
                            original_forks_types_creators_verified=True))
    assert len(records)==4
    print(json.dumps(records,indent=2))


if __name__=='__main__':
    main()
