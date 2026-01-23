#!/bin/bash
# Run QEMU headlessly with VNC and QMP for automation

cd /Volumes/T7/retrogames/oldmac

qemu-system-m68k \
    -M q800 \
    -m 128 \
    -bios roms/quadra800.rom \
    -display vnc=:0 \
    -monitor stdio \
    -qmp unix:/tmp/qemu-maven.sock,server,nowait \
    -gdb tcp::1234 \
    -drive file=isos/os8.iso,media=cdrom,if=none,id=cd0 \
    -device scsi-cd,scsi-id=3,drive=cd0 \
    -drive file=hds/pram.img,format=raw,if=mtd \
    -device scsi-hd,scsi-id=0,drive=hd0 \
    -drive file=hds/macos8.img,media=disk,format=raw,if=none,id=hd0 \
    -device nubus-virtio-mmio,romfile=virtio/classic/declrom \
    -device virtio-9p-device,fsdev=qemu-m68k-share,mount_tag="Macintosh HD" \
    -fsdev local,id=qemu-m68k-share,security_model=none,path=share
