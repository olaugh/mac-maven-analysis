#!/usr/bin/env python3
"""
QEMU GDB debugging helper for Maven reverse engineering.
Connects to QEMU's GDB server and extracts resource data from running Maven.

Usage:
    python3 qemu_debug.py [command]

Commands:
    dump_vcb    - Dump VCBh resource from memory
    dump_frst   - Dump FRST resource from memory
    dump_mul X  - Dump MUL resource for tile X (e.g., dump_mul S)
    dump_expr   - Dump EXPR resource from memory
    compare     - Compare disk vs memory for VCBh/FRST
    handles     - Show all resource handles from A5 global table
    regs        - Show 68k registers

Requires QEMU running with -s flag (GDB server on port 1234)
"""

import socket
import struct
import sys
import os

GDB_HOST = 'localhost'
GDB_PORT = 1234
RESOURCES_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/resources"

# Known handle offsets from A5
HANDLE_OFFSETS = {
    'EXPR': -10908,
    'FRST': -10904,
    'VCBa': -10900,
    'VCBb': -10896,
    'VCBc': -10892,
    'VCBd': -10888,
    'VCBe': -10884,
    'VCBf': -10880,
    'VCBg': -10876,
    'VCBh': -10872,
}

# MUL handles are at A5-10868 (array of 27 handles)
MUL_BASE_OFFSET = -10868


class GDBConnection:
    def __init__(self, host=GDB_HOST, port=GDB_PORT):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.settimeout(10)
        self.sock.connect((host, port))
        try:
            self.sock.recv(1024)  # Consume any initial output
        except:
            pass

    def send_command(self, cmd):
        """Send a GDB remote protocol command and return response."""
        checksum = sum(ord(c) for c in cmd) & 0xff
        packet = f'${cmd}#{checksum:02x}'
        self.sock.send(packet.encode())

        response = b''
        while True:
            chunk = self.sock.recv(4096)
            if not chunk:
                break
            response += chunk
            if b'#' in response and len(response) >= response.index(b'#') + 3:
                break
        return response.decode('latin-1')

    def read_memory(self, addr, size):
        """Read memory and return bytes."""
        response = self.send_command(f'm{addr:x},{size}')
        if response.startswith('+$'):
            hex_data = response[2:response.index('#')]
        elif response.startswith('$'):
            hex_data = response[1:response.index('#')]
        else:
            return None

        if hex_data and not hex_data.startswith('E'):
            return bytes.fromhex(hex_data)
        return None

    def read_registers(self):
        """Read all 68k registers."""
        response = self.send_command('g')
        if '+$' in response:
            hex_start = response.index('+$') + 2
        else:
            hex_start = response.index('$') + 1
        hex_end = response.index('#')
        reg_hex = response[hex_start:hex_end]

        regs = {}
        # 68k register order: D0-D7, A0-A7, SR, PC
        reg_names = ['D0', 'D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7',
                     'A0', 'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7']

        for i, name in enumerate(reg_names):
            if len(reg_hex) >= (i + 1) * 8:
                regs[name] = int(reg_hex[i*8:(i+1)*8], 16)

        return regs

    def close(self):
        self.sock.close()


def parse_vcb_record(data, offset=0):
    """Parse a 28-byte VCB/MUL record."""
    rec = data[offset:offset+28]
    return {
        'expected_score': struct.unpack('>d', rec[0:8])[0],
        'secondary_val': struct.unpack('>d', rec[8:16])[0],
        'sample_count': struct.unpack('>I', rec[16:20])[0],
        'unknown': struct.unpack('>i', rec[20:24])[0],
        'leave_adj': struct.unpack('>i', rec[24:28])[0],
    }


def get_handle_addr(gdb, handle_name):
    """Get the data address for a resource handle."""
    regs = gdb.read_registers()
    a5 = regs.get('A5', 0)

    if handle_name in HANDLE_OFFSETS:
        offset = HANDLE_OFFSETS[handle_name]
    elif handle_name.startswith('MUL'):
        # MUL handles are in an array
        tile = handle_name[3:]
        if tile == '?':
            idx = 26
        else:
            idx = ord(tile.upper()) - ord('A')
        offset = MUL_BASE_OFFSET + idx * 4
    else:
        return None, None

    # Read handle from A5-relative location
    handle_loc = a5 + offset
    handle_data = gdb.read_memory(handle_loc, 4)
    if not handle_data:
        return None, None

    handle_addr = struct.unpack('>I', handle_data)[0]
    return handle_addr, offset


def cmd_dump_vcb(gdb, letter='h'):
    """Dump VCB resource from memory."""
    handle_name = f'VCB{letter}'
    addr, offset = get_handle_addr(gdb, handle_name)

    if not addr:
        print(f"Could not find handle for {handle_name}")
        return

    print(f"{handle_name} at 0x{addr:08x} (A5{offset:+d})")
    print("-" * 50)

    data = gdb.read_memory(addr, 224)
    if not data:
        print("Could not read memory")
        return

    print(f"{'Index':<6} {'LeaveAdj':<10} {'Points':<10} {'ExpScore':<12}")
    print("-" * 50)

    for i in range(8):
        rec = parse_vcb_record(data, i * 28)
        pts = rec['leave_adj'] / 100.0
        print(f"{i:<6} {rec['leave_adj']:<10} {pts:>+9.2f} {rec['expected_score']:>11.4f}")


def cmd_dump_frst(gdb):
    """Dump FRST resource from memory."""
    addr, offset = get_handle_addr(gdb, 'FRST')

    if not addr:
        print("Could not find FRST handle")
        return

    print(f"FRST at 0x{addr:08x} (A5{offset:+d})")
    print("-" * 50)

    data = gdb.read_memory(addr, 224)
    if not data:
        print("Could not read memory")
        return

    is_zeros = all(b == 0 for b in data[:224])
    print(f"All zeros: {is_zeros}")

    if not is_zeros:
        print(f"\n{'Index':<6} {'LeaveAdj':<10} {'Points':<10}")
        print("-" * 35)

        for i in range(8):
            rec = parse_vcb_record(data, i * 28)
            pts = rec['leave_adj'] / 100.0
            print(f"{i:<6} {rec['leave_adj']:<10} {pts:>+9.2f}")


def cmd_dump_mul(gdb, tile):
    """Dump MUL resource for a tile from memory."""
    tile = tile.upper()
    if tile not in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ?':
        print(f"Invalid tile: {tile}")
        return

    handle_name = f'MUL{tile}'
    addr, offset = get_handle_addr(gdb, handle_name)

    if not addr:
        print(f"Could not find handle for {handle_name}")
        return

    print(f"{handle_name} at 0x{addr:08x}")
    print("-" * 50)

    data = gdb.read_memory(addr, 224)
    if not data:
        print("Could not read memory")
        return

    print(f"{'Count':<6} {'LeaveAdj':<10} {'Points':<10} {'Samples':<12}")
    print("-" * 50)

    for i in range(8):
        rec = parse_vcb_record(data, i * 28)
        pts = rec['leave_adj'] / 100.0
        print(f"{i:<6} {rec['leave_adj']:<10} {pts:>+9.2f} {rec['sample_count']:<12}")


def cmd_compare(gdb):
    """Compare disk vs memory for VCBh and FRST."""
    print("=== VCBh: Disk vs Memory ===\n")

    # Load from disk
    vcbh_path = os.path.join(RESOURCES_DIR, "VCBh/0_0.bin")
    if os.path.exists(vcbh_path):
        with open(vcbh_path, 'rb') as f:
            vcbh_disk = f.read()
    else:
        vcbh_disk = None
        print("VCBh not found on disk")

    # Load from memory
    addr, _ = get_handle_addr(gdb, 'VCBh')
    vcbh_mem = gdb.read_memory(addr, 224) if addr else None

    if vcbh_disk and vcbh_mem:
        print(f"{'Vowels':<8} {'Disk':<10} {'Memory':<10} {'Match'}")
        print("-" * 40)

        for i in range(8):
            disk_rec = parse_vcb_record(vcbh_disk, i * 28)
            mem_rec = parse_vcb_record(vcbh_mem, i * 28)
            match = "Yes" if disk_rec['leave_adj'] == mem_rec['leave_adj'] else "NO"
            print(f"{i:<8} {disk_rec['leave_adj']:<10} {mem_rec['leave_adj']:<10} {match}")

    print("\n=== FRST: Disk vs Memory ===\n")

    # Load from disk
    frst_path = os.path.join(RESOURCES_DIR, "FRST/0_0.bin")
    if os.path.exists(frst_path):
        with open(frst_path, 'rb') as f:
            frst_disk = f.read()
    else:
        frst_disk = None
        print("FRST not found on disk")

    # Load from memory
    addr, _ = get_handle_addr(gdb, 'FRST')
    frst_mem = gdb.read_memory(addr, 224) if addr else None

    if frst_disk and frst_mem:
        disk_zeros = all(b == 0 for b in frst_disk)
        mem_zeros = all(b == 0 for b in frst_mem[:224])

        print(f"Disk all zeros: {disk_zeros}")
        print(f"Memory all zeros: {mem_zeros}")

        if not mem_zeros:
            print("\nFRST Memory Records:")
            for i in range(8):
                rec = parse_vcb_record(frst_mem, i * 28)
                print(f"  Index {i}: leave_adj = {rec['leave_adj']}")


def cmd_handles(gdb):
    """Show all resource handles."""
    regs = gdb.read_registers()
    a5 = regs.get('A5', 0)

    print(f"A5 = 0x{a5:08x}")
    print("-" * 50)
    print(f"{'Resource':<10} {'A5 Offset':<12} {'Handle Addr':<12}")
    print("-" * 50)

    for name, offset in sorted(HANDLE_OFFSETS.items(), key=lambda x: x[1]):
        handle_loc = a5 + offset
        handle_data = gdb.read_memory(handle_loc, 4)
        if handle_data:
            handle_addr = struct.unpack('>I', handle_data)[0]
            print(f"{name:<10} {offset:<12} 0x{handle_addr:08x}")


def cmd_regs(gdb):
    """Show 68k registers."""
    regs = gdb.read_registers()

    print("68000 Registers:")
    print("-" * 40)

    # Data registers
    for i in range(8):
        name = f'D{i}'
        if name in regs:
            print(f"  {name}: 0x{regs[name]:08x}")

    print()

    # Address registers
    for i in range(8):
        name = f'A{i}'
        if name in regs:
            print(f"  {name}: 0x{regs[name]:08x}")


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return

    cmd = sys.argv[1].lower()

    try:
        gdb = GDBConnection()
    except Exception as e:
        print(f"Could not connect to QEMU GDB server: {e}")
        print("Make sure QEMU is running with -s flag")
        return

    try:
        if cmd == 'dump_vcb':
            letter = sys.argv[2] if len(sys.argv) > 2 else 'h'
            cmd_dump_vcb(gdb, letter)
        elif cmd == 'dump_frst':
            cmd_dump_frst(gdb)
        elif cmd == 'dump_mul':
            if len(sys.argv) < 3:
                print("Usage: dump_mul <tile>")
            else:
                cmd_dump_mul(gdb, sys.argv[2])
        elif cmd == 'dump_expr':
            addr, _ = get_handle_addr(gdb, 'EXPR')
            if addr:
                data = gdb.read_memory(addr, 224)
                if data:
                    print(f"EXPR at 0x{addr:08x}:")
                    for i in range(8):
                        rec = parse_vcb_record(data, i * 28)
                        print(f"  Index {i}: leave_adj={rec['leave_adj']}, exp={rec['expected_score']:.4f}")
        elif cmd == 'compare':
            cmd_compare(gdb)
        elif cmd == 'handles':
            cmd_handles(gdb)
        elif cmd == 'regs':
            cmd_regs(gdb)
        else:
            print(f"Unknown command: {cmd}")
            print(__doc__)
    finally:
        gdb.close()


if __name__ == "__main__":
    main()
