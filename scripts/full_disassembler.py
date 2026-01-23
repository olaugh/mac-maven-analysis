#!/usr/bin/env python3
"""
Full m68k disassembler for Maven CODE resources.
Outputs annotated assembly with C-style comments.
"""

import struct
import sys

class M68KDisassembler:
    def __init__(self, data, base_offset=0):
        self.data = data
        self.base = base_offset
        self.labels = {}  # address -> label name
        self.comments = {}  # address -> comment

    def read_word(self, offset):
        if offset + 2 > len(self.data):
            return None
        return struct.unpack('>H', self.data[offset:offset+2])[0]

    def read_long(self, offset):
        if offset + 4 > len(self.data):
            return None
        return struct.unpack('>I', self.data[offset:offset+4])[0]

    def read_sword(self, offset):
        if offset + 2 > len(self.data):
            return None
        return struct.unpack('>h', self.data[offset:offset+2])[0]

    def disasm_ea(self, mode, reg, size, offset):
        """Disassemble effective address, return (string, bytes_consumed)"""
        if mode == 0:  # Dn
            return f"D{reg}", 0
        elif mode == 1:  # An
            return f"A{reg}", 0
        elif mode == 2:  # (An)
            return f"(A{reg})", 0
        elif mode == 3:  # (An)+
            return f"(A{reg})+", 0
        elif mode == 4:  # -(An)
            return f"-(A{reg})", 0
        elif mode == 5:  # d(An)
            disp = self.read_sword(offset)
            return f"{disp}(A{reg})", 2
        elif mode == 6:  # d(An,Xn)
            ext = self.read_word(offset)
            xn = (ext >> 12) & 7
            da = 'A' if ext & 0x8000 else 'D'
            wl = '.L' if ext & 0x800 else '.W'
            scale = (ext >> 9) & 3
            disp = ext & 0xff
            if disp > 127:
                disp -= 256
            scale_str = '' if scale == 0 else f'*{1 << scale}'
            return f"{disp}(A{reg},{da}{xn}{wl}{scale_str})", 2
        elif mode == 7:
            if reg == 0:  # abs.W
                addr = self.read_word(offset)
                return f"${addr:04X}.W", 2
            elif reg == 1:  # abs.L
                addr = self.read_long(offset)
                return f"${addr:08X}.L", 4
            elif reg == 2:  # d(PC)
                disp = self.read_sword(offset)
                target = offset + disp
                return f"{disp}(PC)", 2
            elif reg == 3:  # d(PC,Xn)
                ext = self.read_word(offset)
                xn = (ext >> 12) & 7
                da = 'A' if ext & 0x8000 else 'D'
                wl = '.L' if ext & 0x800 else '.W'
                disp = ext & 0xff
                if disp > 127:
                    disp -= 256
                return f"{disp}(PC,{da}{xn}{wl})", 2
            elif reg == 4:  # #imm
                if size == 0:  # byte
                    val = self.read_word(offset) & 0xff
                    return f"#${val:02X}", 2
                elif size == 1:  # word
                    val = self.read_word(offset)
                    return f"#${val:04X}", 2
                else:  # long
                    val = self.read_long(offset)
                    return f"#${val:08X}", 4
        return "???", 0

    def disasm_one(self, offset):
        """Disassemble one instruction, return (length, mnemonic, operands, comment)"""
        word = self.read_word(offset)
        if word is None:
            return 2, "DC.W", "???", ""

        comment = ""
        length = 2

        # MOVE instructions (00xx, 01xx, 02xx, 03xx)
        if (word >> 14) in [0, 1, 2, 3] and (word >> 12) != 0:
            size_map = {1: ('B', 0), 3: ('W', 1), 2: ('L', 2)}
            sz = (word >> 12) & 3
            if sz in size_map:
                size_str, size_code = size_map[sz]
                dst_reg = (word >> 9) & 7
                dst_mode = (word >> 6) & 7
                src_mode = (word >> 3) & 7
                src_reg = word & 7

                src_ea, src_len = self.disasm_ea(src_mode, src_reg, size_code, offset + 2)
                dst_ea, dst_len = self.disasm_ea(dst_mode, dst_reg, size_code, offset + 2 + src_len)

                length = 2 + src_len + dst_len

                # Special: MOVEA
                if dst_mode == 1:
                    return length, f"MOVEA.{size_str}", f"{src_ea},A{dst_reg}", comment

                return length, f"MOVE.{size_str}", f"{src_ea},{dst_ea}", comment

        # MOVEQ
        if (word & 0xF100) == 0x7000:
            data = word & 0xFF
            if data > 127:
                data -= 256
            reg = (word >> 9) & 7
            return 2, "MOVEQ", f"#{data},D{reg}", ""

        # ADD/SUB/CMP/AND/OR
        arith_ops = {
            0xD: ('ADD', False), 0x9: ('SUB', False),
            0xB: ('CMP', True), 0xC: ('AND', False), 0x8: ('OR', False)
        }
        op = (word >> 12) & 0xF
        if op in arith_ops:
            name, cmp_only = arith_ops[op]
            opmode = (word >> 6) & 7
            reg = (word >> 9) & 7
            ea_mode = (word >> 3) & 7
            ea_reg = word & 7

            if opmode in [0, 1, 2]:  # <ea>,Dn
                size_code = opmode
                size_str = ['B', 'W', 'L'][size_code]
                ea, ea_len = self.disasm_ea(ea_mode, ea_reg, size_code, offset + 2)
                return 2 + ea_len, f"{name}.{size_str}", f"{ea},D{reg}", ""
            elif opmode in [4, 5, 6] and not cmp_only:  # Dn,<ea>
                size_code = opmode - 4
                size_str = ['B', 'W', 'L'][size_code]
                ea, ea_len = self.disasm_ea(ea_mode, ea_reg, size_code, offset + 2)
                return 2 + ea_len, f"{name}.{size_str}", f"D{reg},{ea}", ""
            elif opmode == 3:  # ADDA.W / CMPA.W
                ea, ea_len = self.disasm_ea(ea_mode, ea_reg, 1, offset + 2)
                return 2 + ea_len, f"{name}A.W", f"{ea},A{reg}", ""
            elif opmode == 7:  # ADDA.L / CMPA.L
                ea, ea_len = self.disasm_ea(ea_mode, ea_reg, 2, offset + 2)
                return 2 + ea_len, f"{name}A.L", f"{ea},A{reg}", ""

        # LEA
        if (word & 0xF1C0) == 0x41C0:
            reg = (word >> 9) & 7
            ea_mode = (word >> 3) & 7
            ea_reg = word & 7
            ea, ea_len = self.disasm_ea(ea_mode, ea_reg, 2, offset + 2)
            if ea_mode == 5 and ea_reg == 5:  # d(A5)
                comment = "global address"
            return 2 + ea_len, "LEA", f"{ea},A{reg}", comment

        # LINK
        if word == 0x4E56:
            disp = self.read_sword(offset + 2)
            return 4, "LINK", f"A6,#{disp}", f"stack frame {-disp} bytes"

        # UNLK
        if word == 0x4E5E:
            return 2, "UNLK", "A6", ""

        # RTS
        if word == 0x4E75:
            return 2, "RTS", "", ""

        # NOP
        if word == 0x4E71:
            return 2, "NOP", "", ""

        # JMP/JSR
        if (word & 0xFFC0) == 0x4EC0:  # JMP
            ea_mode = (word >> 3) & 7
            ea_reg = word & 7
            ea, ea_len = self.disasm_ea(ea_mode, ea_reg, 2, offset + 2)
            return 2 + ea_len, "JMP", ea, ""
        if (word & 0xFFC0) == 0x4E80:  # JSR
            ea_mode = (word >> 3) & 7
            ea_reg = word & 7
            if ea_mode == 5 and ea_reg == 5:  # d(A5)
                disp = self.read_sword(offset + 2)
                return 4, "JSR", f"{disp}(A5)", "jump table call"
            ea, ea_len = self.disasm_ea(ea_mode, ea_reg, 2, offset + 2)
            return 2 + ea_len, "JSR", ea, ""

        # Bcc/BRA/BSR
        if (word & 0xF000) == 0x6000:
            cc = (word >> 8) & 0xF
            cc_names = ['RA', 'SR', 'HI', 'LS', 'CC', 'CS', 'NE', 'EQ',
                        'VC', 'VS', 'PL', 'MI', 'GE', 'LT', 'GT', 'LE']
            name = 'B' + cc_names[cc]
            disp = word & 0xFF
            if disp == 0:
                disp = self.read_sword(offset + 2)
                target = offset + 4 + disp
                return 4, f"{name}.W", f"${target:04X}", ""
            elif disp == 0xFF:
                disp = self.read_long(offset + 2)
                target = offset + 6 + disp
                return 6, f"{name}.L", f"${target:08X}", ""
            else:
                if disp > 127:
                    disp -= 256
                target = offset + 2 + disp
                return 2, f"{name}.S", f"${target:04X}", ""

        # DBcc
        if (word & 0xF0F8) == 0x50C8:
            cc = (word >> 8) & 0xF
            cc_names = ['T', 'F', 'HI', 'LS', 'CC', 'CS', 'NE', 'EQ',
                        'VC', 'VS', 'PL', 'MI', 'GE', 'LT', 'GT', 'LE']
            reg = word & 7
            disp = self.read_sword(offset + 2)
            target = offset + 2 + disp
            return 4, f"DB{cc_names[cc]}", f"D{reg},${target:04X}", "loop"

        # MOVEM
        if word == 0x48E7:  # MOVEM.L regs,-(SP)
            mask = self.read_word(offset + 2)
            return 4, "MOVEM.L", f"#${mask:04X},-(SP)", "save registers"
        if word == 0x4CDF:  # MOVEM.L (SP)+,regs
            mask = self.read_word(offset + 2)
            return 4, "MOVEM.L", f"(SP)+,#${mask:04X}", "restore registers"

        # A-line traps
        if (word & 0xF000) == 0xA000:
            trap_names = {
                0xA000: "_Open", 0xA001: "_Close", 0xA002: "_Read", 0xA003: "_Write",
                0xA9FF: "_DCF6", 0xA22F: "_Debugger", 0xA917: "_InitPort",
                0xA918: "_InitGraf",
            }
            name = trap_names.get(word, f"_Trap${word:04X}")
            return 2, name, "", "Toolbox trap"

        # MULU/MULS
        if (word & 0xF1C0) == 0xC0C0:  # MULU
            reg = (word >> 9) & 7
            ea_mode = (word >> 3) & 7
            ea_reg = word & 7
            ea, ea_len = self.disasm_ea(ea_mode, ea_reg, 1, offset + 2)
            return 2 + ea_len, "MULU", f"{ea},D{reg}", ""
        if (word & 0xF1C0) == 0xC1C0:  # MULS
            reg = (word >> 9) & 7
            ea_mode = (word >> 3) & 7
            ea_reg = word & 7
            ea, ea_len = self.disasm_ea(ea_mode, ea_reg, 1, offset + 2)
            return 2 + ea_len, "MULS", f"{ea},D{reg}", ""

        # SWAP
        if (word & 0xFFF8) == 0x4840:
            reg = word & 7
            return 2, "SWAP", f"D{reg}", ""

        # EXT
        if (word & 0xFFF8) == 0x4880:
            return 2, "EXT.W", f"D{word & 7}", ""
        if (word & 0xFFF8) == 0x48C0:
            return 2, "EXT.L", f"D{word & 7}", ""

        # CLR
        if (word & 0xFF00) == 0x4200:
            size = (word >> 6) & 3
            ea_mode = (word >> 3) & 7
            ea_reg = word & 7
            size_str = ['B', 'W', 'L', '?'][size]
            ea, ea_len = self.disasm_ea(ea_mode, ea_reg, size, offset + 2)
            return 2 + ea_len, f"CLR.{size_str}", ea, ""

        # TST
        if (word & 0xFF00) == 0x4A00:
            size = (word >> 6) & 3
            ea_mode = (word >> 3) & 7
            ea_reg = word & 7
            size_str = ['B', 'W', 'L', '?'][size]
            ea, ea_len = self.disasm_ea(ea_mode, ea_reg, size, offset + 2)
            return 2 + ea_len, f"TST.{size_str}", ea, ""

        # PEA
        if (word & 0xFFC0) == 0x4840:
            ea_mode = (word >> 3) & 7
            ea_reg = word & 7
            ea, ea_len = self.disasm_ea(ea_mode, ea_reg, 2, offset + 2)
            return 2 + ea_len, "PEA", ea, "push address"

        # ADDQ/SUBQ
        if (word & 0xF100) == 0x5000:  # ADDQ
            data = (word >> 9) & 7
            if data == 0:
                data = 8
            size = (word >> 6) & 3
            if size < 3:
                size_str = ['B', 'W', 'L'][size]
                ea_mode = (word >> 3) & 7
                ea_reg = word & 7
                ea, ea_len = self.disasm_ea(ea_mode, ea_reg, size, offset + 2)
                return 2 + ea_len, f"ADDQ.{size_str}", f"#{data},{ea}", ""
        if (word & 0xF100) == 0x5100:  # SUBQ
            data = (word >> 9) & 7
            if data == 0:
                data = 8
            size = (word >> 6) & 3
            if size < 3:
                size_str = ['B', 'W', 'L'][size]
                ea_mode = (word >> 3) & 7
                ea_reg = word & 7
                ea, ea_len = self.disasm_ea(ea_mode, ea_reg, size, offset + 2)
                return 2 + ea_len, f"SUBQ.{size_str}", f"#{data},{ea}", ""

        # Shift/Rotate
        if (word & 0xF018) == 0xE000:  # ASR/ASL/LSR/LSL/ROR/ROL
            direction = 'L' if word & 0x100 else 'R'
            size = (word >> 6) & 3
            if size < 3:
                size_str = ['B', 'W', 'L'][size]
                kind = (word >> 3) & 3
                kind_names = ['AS', 'LS', 'ROX', 'RO']
                if word & 0x20:  # register count
                    cnt_reg = (word >> 9) & 7
                    reg = word & 7
                    return 2, f"{kind_names[kind]}{direction}.{size_str}", f"D{cnt_reg},D{reg}", ""
                else:  # immediate count
                    cnt = (word >> 9) & 7
                    if cnt == 0:
                        cnt = 8
                    reg = word & 7
                    return 2, f"{kind_names[kind]}{direction}.{size_str}", f"#{cnt},D{reg}", ""

        # ANDI/ORI/EORI to data
        imm_ops = {0: 'ORI', 1: 'ANDI', 5: 'EORI'}
        op = (word >> 9) & 7
        if (word & 0xF000) == 0x0000 and op in imm_ops:
            name = imm_ops[op]
            size = (word >> 6) & 3
            if size < 3:
                size_str = ['B', 'W', 'L'][size]
                ea_mode = (word >> 3) & 7
                ea_reg = word & 7
                if size == 2:
                    imm = self.read_long(offset + 2)
                    imm_str = f"#${imm:08X}"
                    imm_len = 4
                else:
                    imm = self.read_word(offset + 2)
                    imm_str = f"#${imm:04X}"
                    imm_len = 2
                ea, ea_len = self.disasm_ea(ea_mode, ea_reg, size, offset + 2 + imm_len)
                return 2 + imm_len + ea_len, f"{name}.{size_str}", f"{imm_str},{ea}", ""

        # CMPI
        if (word & 0xFF00) == 0x0C00:
            size = (word >> 6) & 3
            if size < 3:
                size_str = ['B', 'W', 'L'][size]
                ea_mode = (word >> 3) & 7
                ea_reg = word & 7
                if size == 2:
                    imm = self.read_long(offset + 2)
                    imm_str = f"#${imm:08X}"
                    imm_len = 4
                else:
                    imm = self.read_word(offset + 2)
                    imm_str = f"#${imm:04X}"
                    imm_len = 2
                ea, ea_len = self.disasm_ea(ea_mode, ea_reg, size, offset + 2 + imm_len)
                return 2 + imm_len + ea_len, f"CMPI.{size_str}", f"{imm_str},{ea}", ""

        # ADDI
        if (word & 0xFF00) == 0x0600:
            size = (word >> 6) & 3
            if size < 3:
                size_str = ['B', 'W', 'L'][size]
                ea_mode = (word >> 3) & 7
                ea_reg = word & 7
                if size == 2:
                    imm = self.read_long(offset + 2)
                    imm_str = f"#${imm:08X}"
                    imm_len = 4
                else:
                    imm = self.read_word(offset + 2)
                    imm_str = f"#${imm:04X}"
                    imm_len = 2
                ea, ea_len = self.disasm_ea(ea_mode, ea_reg, size, offset + 2 + imm_len)
                return 2 + imm_len + ea_len, f"ADDI.{size_str}", f"{imm_str},{ea}", ""

        # SUBI
        if (word & 0xFF00) == 0x0400:
            size = (word >> 6) & 3
            if size < 3:
                size_str = ['B', 'W', 'L'][size]
                ea_mode = (word >> 3) & 7
                ea_reg = word & 7
                if size == 2:
                    imm = self.read_long(offset + 2)
                    imm_str = f"#${imm:08X}"
                    imm_len = 4
                else:
                    imm = self.read_word(offset + 2)
                    imm_str = f"#${imm:04X}"
                    imm_len = 2
                ea, ea_len = self.disasm_ea(ea_mode, ea_reg, size, offset + 2 + imm_len)
                return 2 + imm_len + ea_len, f"SUBI.{size_str}", f"{imm_str},{ea}", ""

        # Default: unknown
        return 2, "DC.W", f"${word:04X}", ""

    def disassemble(self, start=0, end=None, show_hex=True):
        """Disassemble a range and return formatted output"""
        if end is None:
            end = len(self.data)

        lines = []
        offset = start
        while offset < end:
            length, mnemonic, operands, comment = self.disasm_one(offset)

            # Format hex bytes
            hex_bytes = self.data[offset:offset+length].hex().upper()

            # Format line
            if show_hex:
                if comment:
                    line = f"{offset:04X}: {hex_bytes:<12}  {mnemonic:<10} {operands:<24} ; {comment}"
                else:
                    line = f"{offset:04X}: {hex_bytes:<12}  {mnemonic:<10} {operands}"
            else:
                if comment:
                    line = f"{offset:04X}:  {mnemonic:<10} {operands:<24} ; {comment}"
                else:
                    line = f"{offset:04X}:  {mnemonic:<10} {operands}"

            lines.append(line)
            offset += length

        return '\n'.join(lines)


def main():
    # Load and disassemble CODE 3
    with open('/tmp/maven_code_3.bin', 'rb') as f:
        data = f.read()

    dis = M68KDisassembler(data)

    print(";" + "=" * 70)
    print("; Maven CODE 3 Full Disassembly")
    print("; Size:", len(data), "bytes")
    print(";" + "=" * 70)
    print()

    # Disassemble in chunks with function boundaries
    print(dis.disassemble(0, len(data)))


if __name__ == '__main__':
    main()
