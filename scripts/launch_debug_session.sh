#!/bin/bash
# Foreground, disposable-disk Maven session. Ctrl-C terminates it.
set -euo pipefail
repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
runtime_dir="${MAVEN_RUNTIME_ROOT:-$repo_dir/../../media/maven}"
cd "$runtime_dir"
if [[ -S /tmp/maven-re-qmp.sock || -S /tmp/maven-re-gdb.sock ]]; then
    echo 'A Maven debugger socket already exists; inspect its owner before restarting.' >&2
    exit 1
fi
mkdir -p session/share
/usr/bin/rsync -aE --ignore-existing share/ session/share/
# Keep this nonempty: macOS Bash 3 treats an empty array as unset under -u.
installer_args=(-pidfile session/qemu.pid)
if [[ "${MAVEN_THINK6_INSTALLER:-0}" == 1 ]]; then
    for disk in 1 2 3 4; do
        installer_image="toolchains/think-c-6/hfs-media/disk$disk.img"
        [[ -f "$installer_image" ]] || { echo "Missing $installer_image" >&2; exit 1; }
        scsi_id=$disk
        [[ $disk -ge 3 ]] && scsi_id=$((disk+1))
        installer_args+=(
            -drive "file=$installer_image,format=raw,media=disk,if=none,id=think6-$disk"
            -device "scsi-hd,scsi-id=$scsi_id,drive=think6-$disk"
        )
    done
fi
exec qemu-system-m68k \
    -M q800 -m 128 -bios roms/quadra800.rom \
    -display none -monitor none \
    -qmp unix:/tmp/maven-re-qmp.sock,server=on,wait=off \
    -gdb unix:/tmp/maven-re-gdb.sock,server=on,wait=off -S \
    -snapshot \
    -drive file=isos/os8.iso,media=cdrom,if=none,id=cd0 \
    -device scsi-cd,scsi-id=3,drive=cd0 \
    -drive file=hds/pram.img,format=raw,if=mtd \
    -device scsi-hd,scsi-id=0,drive=hd0 \
    -drive file=hds/macos8.img,media=disk,format=raw,if=none,id=hd0 \
    -device nubus-virtio-mmio,romfile=virtio/classic/declrom \
    -device virtio-9p-device,fsdev=maven-share,mount_tag='Macintosh HD' \
    -fsdev local,id=maven-share,security_model=none,path=session/share \
    "${installer_args[@]}"
