#!/usr/bin/env python3
"""
Generate detailed disassemblies for all Maven CODE resources.
"""

import struct
import os

def load_code_resource(path):
    """Load CODE resource and return (header_info, code_bytes)"""
    with open(path, 'rb') as f:
        data = f.read()

    if len(data) >= 4:
        first_word = struct.unpack('>H', data[0:2])[0]
        if first_word == 0x4E56:  # LINK instruction - no header
            return None, data
        else:
            jt_offset = struct.unpack('>H', data[0:2])[0]
            jt_count = struct.unpack('>H', data[2:4])[0]
            return {'jt_offset': jt_offset, 'jt_count': jt_count}, data[4:]
    return None, data

class M68KDisassembler:
    """Improved m68k disassembler with annotations"""

    # Known globals from analysis
    KNOWN_GLOBALS = {
        -23090: "g_dawg_info",
        -23074: "g_dawg_ptr",
        -23070: "g_sect1_off",
        -23066: "g_sect2_off",
        -23056: "g_dawg_?",
        -15506: "g_size1=56630",
        -15502: "g_size2=65536",
        -15514: "g_field_14",
        -15522: "g_field_22",
        -11972: "g_dawg_ptr2",
        -10388: "g_lookup_tbl",
        -8664: "g_flag1",
        -9810: "g_flag2",
        -28628: "g_buffer",
        -24026: "g_common",
        -17154: "g_state1",
        -16610: "g_state2",
        -10464: "g_state3",
    }

    # Toolbox traps
    TOOLBOX_TRAPS = {
        0xA009: "GetResource",
        0xA024: "NewHandle",
        0xA025: "DisposHandle",
        0xA029: "HLock",
        0xA02A: "HUnlock",
        0xA122: "LineTo",
        0xA860: "SysBeep",
        0xA873: "Alert",
        0xA910: "GetNextEvent",
        0xA912: "WaitNextEvent",
        0xA914: "GlobalToLocal",
        0xA915: "LocalToGlobal",
        0xA93A: "SystemTask",
        0xA946: "Eject",
        0xA960: "Delete",
        0xA985: "SFPutFile",
        0xA986: "SFGetFile",
    }

    def __init__(self, data, base_offset=0):
        self.data = data
        self.base = base_offset

    def u16(self, off):
        if off + 2 > len(self.data):
            return None
        return struct.unpack('>H', self.data[off:off+2])[0]

    def s16(self, off):
        if off + 2 > len(self.data):
            return None
        return struct.unpack('>h', self.data[off:off+2])[0]

    def u32(self, off):
        if off + 4 > len(self.data):
            return None
        return struct.unpack('>I', self.data[off:off+4])[0]

    def disasm_ea(self, mode, reg, size, off):
        """Return (string, extra_bytes)"""
        if mode == 0:
            return f"D{reg}", 0
        elif mode == 1:
            return f"A{reg}", 0
        elif mode == 2:
            return f"(A{reg})", 0
        elif mode == 3:
            return f"(A{reg})+", 0
        elif mode == 4:
            return f"-(A{reg})", 0
        elif mode == 5:
            d = self.s16(off)
            if d is None:
                return "???", 0
            return f"{d}(A{reg})", 2
        elif mode == 6:
            ext = self.u16(off)
            if ext is None:
                return "???", 0
            xreg = (ext >> 12) & 7
            xtype = 'A' if ext & 0x8000 else 'D'
            xsize = '.L' if ext & 0x800 else '.W'
            scale = (ext >> 9) & 3
            disp = ext & 0xff
            if disp > 127:
                disp -= 256
            scale_str = f"*{1<<scale}" if scale else ""
            return f"{disp}(A{reg},{xtype}{xreg}{xsize}{scale_str})", 2
        elif mode == 7:
            if reg == 0:
                addr = self.u16(off)
                return f"${addr:04X}.W", 2
            elif reg == 1:
                addr = self.u32(off)
                return f"${addr:08X}", 4
            elif reg == 2:
                d = self.s16(off)
                return f"{d}(PC)", 2
            elif reg == 3:
                ext = self.u16(off)
                if ext is None:
                    return "???", 0
                xreg = (ext >> 12) & 7
                xtype = 'A' if ext & 0x8000 else 'D'
                xsize = '.L' if ext & 0x800 else '.W'
                disp = ext & 0xff
                if disp > 127:
                    disp -= 256
                return f"{disp}(PC,{xtype}{xreg}{xsize})", 2
            elif reg == 4:
                if size == 0:
                    v = self.u16(off)
                    if v is None:
                        return "???", 0
                    return f"#${v&0xff:02X}", 2
                elif size == 1:
                    v = self.u16(off)
                    if v is None:
                        return "???", 0
                    return f"#${v:04X}", 2
                else:
                    v = self.u32(off)
                    if v is None:
                        return "???", 0
                    return f"#${v:08X}", 4
        return "???", 0

    def disasm(self, off):
        """Return (length, mnemonic, operands, comment)"""
        w = self.u16(off)
        if w is None:
            return 2, "DC.W", "$????", ""

        # LINK A6,#n
        if w == 0x4E56:
            d = self.s16(off+2)
            return 4, "LINK", f"A6,#{d}", f"frame={-d}" if d else ""

        # UNLK A6
        if w == 0x4E5E:
            return 2, "UNLK", "A6", ""

        # RTS
        if w == 0x4E75:
            return 2, "RTS", "", ""

        # RTE
        if w == 0x4E73:
            return 2, "RTE", "", ""

        # NOP
        if w == 0x4E71:
            return 2, "NOP", "", ""

        # TRAP #n
        if (w & 0xFFF0) == 0x4E40:
            return 2, "TRAP", f"#{w & 0xF}", ""

        # MOVEQ
        if (w & 0xF100) == 0x7000:
            data = w & 0xFF
            if data > 127:
                data -= 256
            reg = (w >> 9) & 7
            return 2, "MOVEQ", f"#{data},D{reg}", ""

        # MOVEM.L regs,-(SP)
        if w == 0x48E7:
            mask = self.u16(off+2)
            regs = self._decode_movem_mask(mask, True)
            return 4, "MOVEM.L", f"{regs},-(SP)", "save"

        # MOVEM.L (SP)+,regs
        if w == 0x4CDF:
            mask = self.u16(off+2)
            regs = self._decode_movem_mask(mask, False)
            return 4, "MOVEM.L", f"(SP)+,{regs}", "restore"

        # MOVEM.L d(A6),regs
        if (w & 0xFFF8) == 0x4CE8:
            mask = self.u16(off+2)
            d = self.s16(off+4)
            regs = self._decode_movem_mask(mask, False)
            reg = w & 7
            return 6, "MOVEM.L", f"{d}(A{reg}),{regs}", ""

        # MOVEM.L regs,d(A6)
        if (w & 0xFFF8) == 0x48E8:
            mask = self.u16(off+2)
            d = self.s16(off+4)
            regs = self._decode_movem_mask(mask, True)
            reg = w & 7
            return 6, "MOVEM.L", f"{regs},{d}(A{reg})", ""

        # JSR/JMP
        if (w & 0xFFC0) == 0x4E80:  # JSR
            ea_m = (w >> 3) & 7
            ea_r = w & 7
            ea, n = self.disasm_ea(ea_m, ea_r, 2, off+2)
            comment = ""
            if ea_m == 5 and ea_r == 5:
                d = self.s16(off+2)
                comment = f"JT[{d}]"
            return 2+n, "JSR", ea, comment
        if (w & 0xFFC0) == 0x4EC0:  # JMP
            ea_m = (w >> 3) & 7
            ea_r = w & 7
            ea, n = self.disasm_ea(ea_m, ea_r, 2, off+2)
            return 2+n, "JMP", ea, ""

        # LEA
        if (w & 0xF1C0) == 0x41C0:
            reg = (w >> 9) & 7
            ea_m = (w >> 3) & 7
            ea_r = w & 7
            ea, n = self.disasm_ea(ea_m, ea_r, 2, off+2)
            comment = ""
            if ea_m == 5 and ea_r == 5:
                d = self.s16(off+2)
                comment = self.KNOWN_GLOBALS.get(d, f"A5{d:+d}")
            return 2+n, "LEA", f"{ea},A{reg}", comment

        # PEA
        if (w & 0xFFC0) == 0x4840:
            ea_m = (w >> 3) & 7
            ea_r = w & 7
            ea, n = self.disasm_ea(ea_m, ea_r, 2, off+2)
            comment = ""
            if ea_m == 5 and ea_r == 5:
                d = self.s16(off+2)
                comment = self.KNOWN_GLOBALS.get(d, f"A5{d:+d}")
            return 2+n, "PEA", ea, comment

        # Bcc/BRA/BSR
        if (w & 0xF000) == 0x6000:
            cc = (w >> 8) & 0xF
            names = ['RA','SR','HI','LS','CC','CS','NE','EQ','VC','VS','PL','MI','GE','LT','GT','LE']
            disp = w & 0xFF
            if disp == 0:
                d = self.s16(off+2)
                target = off + 4 + d
                return 4, f"B{names[cc]}.W", f"${target:04X}", ""
            elif disp == 0xFF:
                d = self.u32(off+2)
                if d > 0x7FFFFFFF:
                    d -= 0x100000000
                target = off + 2 + d
                return 6, f"B{names[cc]}.L", f"${target:08X}", ""
            else:
                if disp > 127:
                    disp -= 256
                target = off + 2 + disp
                return 2, f"B{names[cc]}.S", f"${target:04X}", ""

        # DBcc
        if (w & 0xF0F8) == 0x50C8:
            cc = (w >> 8) & 0xF
            names = ['T','F','HI','LS','CC','CS','NE','EQ','VC','VS','PL','MI','GE','LT','GT','LE']
            reg = w & 7
            d = self.s16(off+2)
            target = off + 2 + d
            return 4, f"DB{names[cc]}", f"D{reg},${target:04X}", "loop"

        # Scc
        if (w & 0xF0C0) == 0x50C0 and (w & 0x38) != 0x08:
            cc = (w >> 8) & 0xF
            names = ['T','F','HI','LS','CC','CS','NE','EQ','VC','VS','PL','MI','GE','LT','GT','LE']
            ea_m = (w >> 3) & 7
            ea_r = w & 7
            ea, n = self.disasm_ea(ea_m, ea_r, 0, off+2)
            return 2+n, f"S{names[cc]}", ea, ""

        # MOVE.x
        sizes = {1: ('B', 0), 3: ('W', 1), 2: ('L', 2)}
        sz_bits = (w >> 12) & 3
        if sz_bits in sizes and (w >> 12) != 0:
            sz_str, sz_code = sizes[sz_bits]
            dst_r = (w >> 9) & 7
            dst_m = (w >> 6) & 7
            src_m = (w >> 3) & 7
            src_r = w & 7

            src, src_n = self.disasm_ea(src_m, src_r, sz_code, off+2)
            dst, dst_n = self.disasm_ea(dst_m, dst_r, sz_code, off+2+src_n)

            if dst_m == 1:
                return 2+src_n+dst_n, f"MOVEA.{sz_str}", f"{src},A{dst_r}", ""

            comment = ""
            if src_m == 5 and src_r == 5:
                d = self.s16(off+2)
                comment = self.KNOWN_GLOBALS.get(d, f"A5{d:+d}")

            return 2+src_n+dst_n, f"MOVE.{sz_str}", f"{src},{dst}", comment

        # ADD/SUB/CMP/AND/OR
        arith = {0xD: 'ADD', 0x9: 'SUB', 0xB: 'CMP', 0xC: 'AND', 0x8: 'OR'}
        op = (w >> 12) & 0xF
        if op in arith:
            name = arith[op]
            opmode = (w >> 6) & 7
            reg = (w >> 9) & 7
            ea_m = (w >> 3) & 7
            ea_r = w & 7

            if opmode in [0, 1, 2]:
                sz = ['B', 'W', 'L'][opmode]
                ea, n = self.disasm_ea(ea_m, ea_r, opmode, off+2)
                comment = ""
                if ea_m == 5 and ea_r == 5:
                    d = self.s16(off+2)
                    comment = self.KNOWN_GLOBALS.get(d, f"A5{d:+d}")
                return 2+n, f"{name}.{sz}", f"{ea},D{reg}", comment
            elif opmode == 3:
                ea, n = self.disasm_ea(ea_m, ea_r, 1, off+2)
                return 2+n, f"{name}A.W", f"{ea},A{reg}", ""
            elif opmode == 7:
                ea, n = self.disasm_ea(ea_m, ea_r, 2, off+2)
                return 2+n, f"{name}A.L", f"{ea},A{reg}", ""
            elif opmode in [4, 5, 6] and op != 0xB:
                sz = ['B', 'W', 'L'][opmode-4]
                ea, n = self.disasm_ea(ea_m, ea_r, opmode-4, off+2)
                return 2+n, f"{name}.{sz}", f"D{reg},{ea}", ""

        # ADDQ/SUBQ
        if (w & 0xF100) == 0x5000 or (w & 0xF100) == 0x5100:
            name = 'ADDQ' if (w & 0x0100) == 0 else 'SUBQ'
            data = (w >> 9) & 7
            if data == 0:
                data = 8
            sz = (w >> 6) & 3
            if sz < 3:
                sz_str = ['B', 'W', 'L'][sz]
                ea_m = (w >> 3) & 7
                ea_r = w & 7
                ea, n = self.disasm_ea(ea_m, ea_r, sz, off+2)
                return 2+n, f"{name}.{sz_str}", f"#{data},{ea}", ""

        # CLR/TST/NEG/NOT
        for opw, nm in [(0x4200, 'CLR'), (0x4A00, 'TST'), (0x4400, 'NEG'), (0x4600, 'NOT')]:
            if (w & 0xFF00) == opw:
                sz = (w >> 6) & 3
                if sz < 3:
                    ea_m = (w >> 3) & 7
                    ea_r = w & 7
                    ea, n = self.disasm_ea(ea_m, ea_r, sz, off+2)
                    return 2+n, f"{nm}.{['B','W','L'][sz]}", ea, ""

        # EXT
        if (w & 0xFFF8) == 0x4880:
            return 2, "EXT.W", f"D{w&7}", ""
        if (w & 0xFFF8) == 0x48C0:
            return 2, "EXT.L", f"D{w&7}", ""

        # SWAP
        if (w & 0xFFF8) == 0x4840:
            return 2, "SWAP", f"D{w&7}", ""

        # Shifts
        if (w & 0xF010) == 0xE000:
            dr = 'L' if w & 0x100 else 'R'
            sz = (w >> 6) & 3
            if sz < 3:
                sz_str = ['B', 'W', 'L'][sz]
                kind = ['AS', 'LS', 'ROX', 'RO'][(w >> 3) & 3]
                dreg = w & 7
                if w & 0x20:
                    creg = (w >> 9) & 7
                    return 2, f"{kind}{dr}.{sz_str}", f"D{creg},D{dreg}", ""
                else:
                    cnt = (w >> 9) & 7
                    if cnt == 0:
                        cnt = 8
                    return 2, f"{kind}{dr}.{sz_str}", f"#{cnt},D{dreg}", ""

        # MULU/MULS/DIVU/DIVS
        for opw, nm in [(0xC0C0, 'MULU'), (0xC1C0, 'MULS'), (0x80C0, 'DIVU'), (0x81C0, 'DIVS')]:
            if (w & 0xF1C0) == opw:
                reg = (w >> 9) & 7
                ea_m = (w >> 3) & 7
                ea_r = w & 7
                ea, n = self.disasm_ea(ea_m, ea_r, 1, off+2)
                return 2+n, nm, f"{ea},D{reg}", ""

        # ADDI/SUBI/CMPI/ORI/ANDI/EORI
        for opw, nm in [(0x0600, 'ADDI'), (0x0400, 'SUBI'), (0x0C00, 'CMPI'),
                        (0x0000, 'ORI'), (0x0200, 'ANDI'), (0x0A00, 'EORI')]:
            if (w & 0xFF00) == opw and (w & 0xC0) != 0xC0:
                sz = (w >> 6) & 3
                if sz < 3:
                    ea_m = (w >> 3) & 7
                    ea_r = w & 7
                    if sz == 2:
                        imm = self.u32(off+2)
                        imm_str = f"#${imm:08X}"
                        imm_n = 4
                    else:
                        imm = self.u16(off+2)
                        imm_str = f"#${imm:04X}"
                        imm_n = 2
                    ea, ea_n = self.disasm_ea(ea_m, ea_r, sz, off+2+imm_n)
                    return 2+imm_n+ea_n, f"{nm}.{['B','W','L'][sz]}", f"{imm_str},{ea}", ""

        # BTST/BCHG/BCLR/BSET immediate
        for opw, nm in [(0x0800, 'BTST'), (0x0840, 'BCHG'), (0x0880, 'BCLR'), (0x08C0, 'BSET')]:
            if (w & 0xFFC0) == opw:
                bit = self.u16(off+2)
                ea_m = (w >> 3) & 7
                ea_r = w & 7
                ea, n = self.disasm_ea(ea_m, ea_r, 0, off+4)
                return 4+n, nm, f"#{bit},{ea}", ""

        # BTST/BCHG/BCLR/BSET register
        for opw, nm in [(0x0100, 'BTST'), (0x0140, 'BCHG'), (0x0180, 'BCLR'), (0x01C0, 'BSET')]:
            if (w & 0xF1C0) == opw:
                reg = (w >> 9) & 7
                ea_m = (w >> 3) & 7
                ea_r = w & 7
                ea, n = self.disasm_ea(ea_m, ea_r, 0, off+2)
                return 2+n, nm, f"D{reg},{ea}", ""

        # EXG
        if (w & 0xF130) == 0xC100:
            rx = (w >> 9) & 7
            ry = w & 7
            opmode = (w >> 3) & 0x1F
            if opmode == 0x08:
                return 2, "EXG", f"D{rx},D{ry}", ""
            elif opmode == 0x09:
                return 2, "EXG", f"A{rx},A{ry}", ""
            elif opmode == 0x11:
                return 2, "EXG", f"D{rx},A{ry}", ""

        # A-line traps
        if (w & 0xF000) == 0xA000:
            trap_name = self.TOOLBOX_TRAPS.get(w, "")
            return 2, f"DC.W", f"${w:04X}", f"trap {trap_name}" if trap_name else "trap"

        # Default
        return 2, "DC.W", f"${w:04X}", ""

    def _decode_movem_mask(self, mask, to_mem):
        """Decode MOVEM register mask"""
        regs = []
        if to_mem:
            for i in range(8):
                if mask & (0x8000 >> i):
                    regs.append(f"D{i}")
            for i in range(8):
                if mask & (0x80 >> i):
                    regs.append(f"A{i}")
        else:
            for i in range(8):
                if mask & (1 << i):
                    regs.append(f"D{i}")
            for i in range(8):
                if mask & (1 << (8+i)):
                    regs.append(f"A{i}")
        return '/'.join(regs) if regs else "none"

    def disassemble_all(self):
        """Disassemble entire buffer with function boundaries"""
        lines = []
        off = 0

        # Find function starts (LINK A6,#n)
        func_starts = set()
        i = 0
        while i < len(self.data) - 3:
            if self.u16(i) == 0x4E56:
                func_starts.add(i)
            i += 2

        while off < len(self.data):
            # Mark function boundaries
            if off in func_starts:
                lines.append("")
                lines.append(f"; ======= Function at 0x{off:04X} =======")

            length, mnem, ops, comment = self.disasm(off)
            hexb = self.data[off:off+length].hex().upper()
            if comment:
                line = f"{off:04X}: {hexb:<12}  {mnem:<10} {ops:<30} ; {comment}"
            else:
                line = f"{off:04X}: {hexb:<12}  {mnem:<10} {ops}"
            lines.append(line)

            # Mark function end
            if mnem == "RTS":
                lines.append("")

            off += length

        return '\n'.join(lines)


def main():
    output_dir = '/Volumes/T7/retrogames/oldmac/maven_re/analysis/disasm'
    os.makedirs(output_dir, exist_ok=True)

    # Find all CODE resources
    code_ids = []
    for f in os.listdir('/tmp'):
        if f.startswith('maven_code_') and f.endswith('.bin'):
            code_id = int(f.replace('maven_code_', '').replace('.bin', ''))
            code_ids.append(code_id)
    code_ids.sort()

    for code_id in code_ids:
        path = f'/tmp/maven_code_{code_id}.bin'
        try:
            header, code = load_code_resource(path)
        except FileNotFoundError:
            continue

        output_file = f'{output_dir}/code{code_id}_disasm.asm'

        with open(output_file, 'w') as f:
            f.write(f";{'='*70}\n")
            f.write(f"; CODE {code_id} Disassembly\n")
            f.write(f"; File: {path}\n")
            if header:
                f.write(f"; Header: JT offset={header['jt_offset']}, JT entries={header['jt_count']}\n")
            f.write(f"; Code size: {len(code)} bytes\n")
            f.write(f";{'='*70}\n\n")

            dis = M68KDisassembler(code)
            f.write(dis.disassemble_all())

        print(f"Written: {output_file}")


if __name__ == '__main__':
    main()
