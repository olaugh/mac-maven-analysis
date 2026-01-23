#!/usr/bin/env python3
"""
Disassemble Mac CODE resource with proper header handling.
CODE resources have a header before the actual code.
"""

import struct

def load_code_resource(path):
    """Load CODE resource and return (header_info, code_bytes)"""
    with open(path, 'rb') as f:
        data = f.read()

    # CODE resource header (except CODE 0):
    # Offset 0: First jump table entry offset (2 bytes)
    # Offset 2: Number of jump table entries (2 bytes)
    # Offset 4: Code starts here

    # But some resources might not have this header
    # Check if first bytes look like LINK A6,#n (0x4E56 xxxx)
    if len(data) >= 4:
        first_word = struct.unpack('>H', data[0:2])[0]
        if first_word == 0x4E56:  # LINK instruction
            # No header, code starts at 0
            return None, data
        else:
            # Has header
            jt_offset = struct.unpack('>H', data[0:2])[0]
            jt_count = struct.unpack('>H', data[2:4])[0]
            return {'jt_offset': jt_offset, 'jt_count': jt_count}, data[4:]

    return None, data

class M68KDisassembler:
    """Improved m68k disassembler"""

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
                    return f"#${v&0xff:02X}", 2
                elif size == 1:
                    v = self.u16(off)
                    return f"#${v:04X}", 2
                else:
                    v = self.u32(off)
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
            return 4, "LINK", f"A6,#{d}", f"frame {-d} bytes" if d else ""

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
            return 4, "MOVEM.L", f"{regs},-(SP)", "save regs"

        # MOVEM.L (SP)+,regs
        if w == 0x4CDF:
            mask = self.u16(off+2)
            regs = self._decode_movem_mask(mask, False)
            return 4, "MOVEM.L", f"(SP)+,{regs}", "restore regs"

        # JSR/JMP
        if (w & 0xFFC0) == 0x4E80:  # JSR
            ea_m = (w >> 3) & 7
            ea_r = w & 7
            ea, n = self.disasm_ea(ea_m, ea_r, 2, off+2)
            comment = ""
            if ea_m == 5 and ea_r == 5:
                comment = "A5 jump table"
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
                comment = f"global at A5{d:+d}"
            return 2+n, "LEA", f"{ea},A{reg}", comment

        # PEA
        if (w & 0xFFC0) == 0x4840:
            ea_m = (w >> 3) & 7
            ea_r = w & 7
            ea, n = self.disasm_ea(ea_m, ea_r, 2, off+2)
            return 2+n, "PEA", ea, ""

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
                comment = f"global A5{d:+d}"

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
                return 2+n, f"{name}.{sz}", f"{ea},D{reg}", ""
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

        # CLR/TST/NEG
        for opw, nm in [(0x4200, 'CLR'), (0x4A00, 'TST'), (0x4400, 'NEG')]:
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

        # ANDI/ORI/EORI immediate
        imm_ops = {0x0200: 'ORI', 0x0000: 'ORI', 0x0240: 'ANDI', 0x0A00: 'EORI'}
        for opw, nm in [(0x0000, 'ORI'), (0x0200, 'ANDI'), (0x0A00, 'EORI')]:
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

        # CMPI/ADDI/SUBI
        for opw, nm in [(0x0C00, 'CMPI'), (0x0600, 'ADDI'), (0x0400, 'SUBI')]:
            if (w & 0xFF00) == opw:
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

        # A-line traps
        if (w & 0xF000) == 0xA000:
            return 2, f"DC.W", f"${w:04X}", "A-line trap"

        # Default
        return 2, "DC.W", f"${w:04X}", ""

    def _decode_movem_mask(self, mask, to_mem):
        """Decode MOVEM register mask"""
        regs = []
        if to_mem:
            # For -(An), bit order is reversed: D0-D7, A0-A7
            for i in range(8):
                if mask & (0x8000 >> i):
                    regs.append(f"D{i}")
            for i in range(8):
                if mask & (0x80 >> i):
                    regs.append(f"A{i}")
        else:
            # For (An)+, normal order
            for i in range(8):
                if mask & (1 << i):
                    regs.append(f"D{i}")
            for i in range(8):
                if mask & (1 << (8+i)):
                    regs.append(f"A{i}")
        return '/'.join(regs) if regs else "none"

    def disassemble_all(self):
        """Disassemble entire buffer"""
        lines = []
        off = 0
        while off < len(self.data):
            length, mnem, ops, comment = self.disasm(off)
            hexb = self.data[off:off+length].hex().upper()
            if comment:
                line = f"{off:04X}: {hexb:<12}  {mnem:<10} {ops:<28} ; {comment}"
            else:
                line = f"{off:04X}: {hexb:<12}  {mnem:<10} {ops}"
            lines.append(line)
            off += length
        return '\n'.join(lines)


def main():
    import sys

    for code_id in [3]:  # Focus on CODE 3
        path = f'/tmp/maven_code_{code_id}.bin'
        try:
            header, code = load_code_resource(path)
        except FileNotFoundError:
            continue

        print(f";{'='*70}")
        print(f"; CODE {code_id} Disassembly")
        print(f"; File: {path}")
        if header:
            print(f"; Header: JT offset={header['jt_offset']}, JT entries={header['jt_count']}")
        print(f"; Code size: {len(code)} bytes")
        print(f";{'='*70}")
        print()

        dis = M68KDisassembler(code)
        print(dis.disassemble_all())


if __name__ == '__main__':
    main()
