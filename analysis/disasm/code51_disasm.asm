;======================================================================
; CODE 51 Disassembly
; File: /tmp/maven_code_51.bin
; Header: JT offset=3360, JT entries=6
; Code size: 236 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 2F07          MOVE.L     D7,-(A7)
0006: 48780018      PEA        $0018.W
000A: 2F2E0008      MOVE.L     8(A6),-(A7)
000E: 4EAD01FA      JSR        506(A5)                        ; JT[506]
0012: 2E00          MOVE.L     D0,D7
0014: 4A87          TST.L      D7
0016: 508F          MOVE.B     A7,(A0)
0018: 6604          BNE.S      $001E
001A: 4EAD01A2      JSR        418(A5)                        ; JT[418]
001E: 2007          MOVE.L     D7,D0
0020: 2E1F          MOVE.L     (A7)+,D7
0022: 4E5E          UNLK       A6
0024: 4E75          RTS        


; ======= Function at 0x0026 =======
0026: 4E560000      LINK       A6,#0
002A: 48780007      PEA        $0007.W
002E: 2F2E0008      MOVE.L     8(A6),-(A7)
0032: 4EAD01FA      JSR        506(A5)                        ; JT[506]
0036: 4A80          TST.L      D0
0038: 56C0          SNE        D0
003A: 4400          NEG.B      D0
003C: 4880          EXT.W      D0
003E: 48C0          EXT.L      D0
0040: 4E5E          UNLK       A6
0042: 4E75          RTS        


; ======= Function at 0x0044 =======
0044: 4E560000      LINK       A6,#0
0048: 2F0C          MOVE.L     A4,-(A7)
004A: 48780007      PEA        $0007.W
004E: 2F2E0008      MOVE.L     8(A6),-(A7)
0052: 4EAD01FA      JSR        506(A5)                        ; JT[506]
0056: 2840          MOVEA.L    D0,A4
0058: 200C          MOVE.L     A4,D0
005A: 508F          MOVE.B     A7,(A0)
005C: 6604          BNE.S      $0062
005E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0062: 2F2E0008      MOVE.L     8(A6),-(A7)
0066: 4E94          JSR        (A4)
0068: 286EFFFC      MOVEA.L    -4(A6),A4
006C: 4E5E          UNLK       A6
006E: 4E75          RTS        


; ======= Function at 0x0070 =======
0070: 4E560000      LINK       A6,#0
0074: 2F0C          MOVE.L     A4,-(A7)
0076: 286E0008      MOVEA.L    8(A6),A4
007A: 206E000C      MOVEA.L    12(A6),A0
007E: 08280000000E  BTST       #0,14(A0)
0084: 662C          BNE.S      $00B2
0086: 2F0C          MOVE.L     A4,-(A7)
0088: 4EBAFF76      JSR        -138(PC)
008C: 02400080      ANDI.W     #$0080,D0
0090: 588F          MOVE.B     A7,(A4)
0092: 670A          BEQ.S      $009E
0094: 2F0C          MOVE.L     A4,-(A7)
0096: 4EAD0BFA      JSR        3066(A5)                       ; JT[3066]
009A: 588F          MOVE.B     A7,(A4)
009C: 6014          BRA.S      $00B2
009E: 2F0C          MOVE.L     A4,-(A7)
00A0: 4EAD0C2A      JSR        3114(A5)                       ; JT[3114]
00A4: 4A40          TST.W      D0
00A6: 588F          MOVE.B     A7,(A4)
00A8: 6608          BNE.S      $00B2
00AA: 2F0C          MOVE.L     A4,-(A7)
00AC: 4EAD0C3A      JSR        3130(A5)                       ; JT[3130]
00B0: 588F          MOVE.B     A7,(A4)
00B2: 486DFA56      PEA        -1450(A5)                      ; A5-1450
00B6: 206E000C      MOVEA.L    12(A6),A0
00BA: 2F28000A      MOVE.L     10(A0),-(A7)
00BE: 2F0C          MOVE.L     A4,-(A7)
00C0: 4EAD0C32      JSR        3122(A5)                       ; JT[3122]
00C4: 286EFFFC      MOVEA.L    -4(A6),A4
00C8: 4E5E          UNLK       A6
00CA: 4E75          RTS        


; ======= Function at 0x00CC =======
00CC: 4E560000      LINK       A6,#0
00D0: 2F2E0008      MOVE.L     8(A6),-(A7)
00D4: 4EAD0C3A      JSR        3130(A5)                       ; JT[3130]
00D8: 4E5E          UNLK       A6
00DA: 4E75          RTS        


; ======= Function at 0x00DC =======
00DC: 4E560000      LINK       A6,#0
00E0: 2F2E0008      MOVE.L     8(A6),-(A7)
00E4: 4EAD0C02      JSR        3074(A5)                       ; JT[3074]
00E8: 4E5E          UNLK       A6
00EA: 4E75          RTS        
