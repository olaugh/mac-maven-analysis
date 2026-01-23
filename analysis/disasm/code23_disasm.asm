;======================================================================
; CODE 23 Disassembly
; File: /tmp/maven_code_23.bin
; Header: JT offset=1968, JT entries=7
; Code size: 608 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 3F2E0008      MOVE.W     8(A6),-(A7)
0008: 486DF436      PEA        -3018(A5)                      ; A5-3018
000C: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
0010: 4A80          TST.L      D0
0012: 56C0          SNE        D0
0014: 4400          NEG.B      D0
0016: 4880          EXT.W      D0
0018: 4E5E          UNLK       A6
001A: 4E75          RTS        


; ======= Function at 0x001C =======
001C: 4E560000      LINK       A6,#0
0020: 2F0C          MOVE.L     A4,-(A7)
0022: 286E000C      MOVEA.L    12(A6),A4
0026: 601C          BRA.S      $0044
0028: 1014          MOVE.B     (A4),D0
002A: 4880          EXT.W      D0
002C: 3F00          MOVE.W     D0,-(A7)
002E: 2F2E0008      MOVE.L     8(A6),-(A7)
0032: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
0036: 4A80          TST.L      D0
0038: 5C8F          MOVE.B     A7,(A6)
003A: 6706          BEQ.S      $0042
003C: 1014          MOVE.B     (A4),D0
003E: 4880          EXT.W      D0
0040: 6008          BRA.S      $004A
0042: 528C          MOVE.B     A4,(A1)
0044: 4A14          TST.B      (A4)
0046: 66E0          BNE.S      $0028
0048: 7000          MOVEQ      #0,D0
004A: 285F          MOVEA.L    (A7)+,A4
004C: 4E5E          UNLK       A6
004E: 4E75          RTS        


; ======= Function at 0x0050 =======
0050: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0054: 601C          BRA.S      $0072
0056: 206E0008      MOVEA.L    8(A6),A0
005A: 1010          MOVE.B     (A0),D0
005C: 4880          EXT.W      D0
005E: 3F00          MOVE.W     D0,-(A7)
0060: 2F2E0010      MOVE.L     16(A6),-(A7)
0064: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
0068: 4A80          TST.L      D0
006A: 5C8F          MOVE.B     A7,(A6)
006C: 6704          BEQ.S      $0072
006E: 52AE0008      MOVE.B     8(A6),(A1)
0072: 206E000C      MOVEA.L    12(A6),A0
0076: 52AE000C      MOVE.B     12(A6),(A1)
007A: 226E0008      MOVEA.L    8(A6),A1
007E: 1290          MOVE.B     (A0),(A1)
0080: 66D4          BNE.S      $0056
0082: 4E5E          UNLK       A6
0084: 4E75          RTS        


; ======= Function at 0x0086 =======
0086: 4E560000      LINK       A6,#0
008A: 2F0C          MOVE.L     A4,-(A7)
008C: 286E0008      MOVEA.L    8(A6),A4
0090: 6012          BRA.S      $00A4
0092: 7000          MOVEQ      #0,D0
0094: 1014          MOVE.B     (A4),D0
0096: 204D          MOVEA.L    A5,A0
0098: D1C07006      MOVE.B     D0,$7006.W
009C: C028FBD8      AND.B      -1064(A0),D0
00A0: 6602          BNE.S      $00A4
00A2: 528C          MOVE.B     A4,(A1)
00A4: 206E000C      MOVEA.L    12(A6),A0
00A8: 52AE000C      MOVE.B     12(A6),(A1)
00AC: 1890          MOVE.B     (A0),(A4)
00AE: 66E2          BNE.S      $0092
00B0: 4214          CLR.B      (A4)
00B2: 285F          MOVEA.L    (A7)+,A4
00B4: 4E5E          UNLK       A6
00B6: 4E75          RTS        


; ======= Function at 0x00B8 =======
00B8: 4E56FFFC      LINK       A6,#-4                         ; frame=4
00BC: 2F2E000C      MOVE.L     12(A6),-(A7)
00C0: 486DF43C      PEA        -3012(A5)                      ; A5-3012
00C4: 206E0008      MOVEA.L    8(A6),A0
00C8: 48680001      PEA        1(A0)
00CC: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
00D0: 206E0008      MOVEA.L    8(A6),A0
00D4: 1080          MOVE.B     D0,(A0)
00D6: 2008          MOVE.L     A0,D0
00D8: 4E5E          UNLK       A6
00DA: 4E75          RTS        


; ======= Function at 0x00DC =======
00DC: 4E560000      LINK       A6,#0
00E0: 48E70300      MOVEM.L    D6/D7,-(SP)                    ; save
00E4: 3E2E0010      MOVE.W     16(A6),D7
00E8: 53473047      MOVE.B     D7,12359(A1)
00EC: 2F08          MOVE.L     A0,-(A7)
00EE: 2F2E000C      MOVE.L     12(A6),-(A7)
00F2: 206E0008      MOVEA.L    8(A6),A0
00F6: 48680001      PEA        1(A0)
00FA: 4EAD0DCA      JSR        3530(A5)                       ; JT[3530]
00FE: 2EAE000C      MOVE.L     12(A6),(A7)
0102: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0106: 3C00          MOVE.W     D0,D6
0108: BE46          MOVEA.W    D6,A7
010A: 4FEF000C      LEA        12(A7),A7
010E: 6C04          BGE.S      $0114
0110: 3007          MOVE.W     D7,D0
0112: 6002          BRA.S      $0116
0114: 3006          MOVE.W     D6,D0
0116: 206E0008      MOVEA.L    8(A6),A0
011A: 1080          MOVE.B     D0,(A0)
011C: 4CDF00C0      MOVEM.L    (SP)+,D6/D7                    ; restore
0120: 4E5E          UNLK       A6
0122: 4E75          RTS        


; ======= Function at 0x0124 =======
0124: 4E560000      LINK       A6,#0
0128: 206E0008      MOVEA.L    8(A6),A0
012C: D1EE00104210  MOVE.B     16(A6),$4210.W
0132: 2F2E0010      MOVE.L     16(A6),-(A7)
0136: 2F2E000C      MOVE.L     12(A6),-(A7)
013A: 2F2E0008      MOVE.L     8(A6),-(A7)
013E: 4EAD0DCA      JSR        3530(A5)                       ; JT[3530]
0142: 4E5E          UNLK       A6
0144: 4E75          RTS        


; ======= Function at 0x0146 =======
0146: 4E560000      LINK       A6,#0
014A: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
014E: 266E0008      MOVEA.L    8(A6),A3
0152: 284B          MOVEA.L    A3,A4
0154: 6002          BRA.S      $0158
0156: 528B          MOVE.B     A3,(A1)
0158: 4A13          TST.B      (A3)
015A: 66FA          BNE.S      $0156
015C: 2F2E0010      MOVE.L     16(A6),-(A7)
0160: 2F2E000C      MOVE.L     12(A6),-(A7)
0164: 2F0B          MOVE.L     A3,-(A7)
0166: 4EBAFFBC      JSR        -68(PC)
016A: 200C          MOVE.L     A4,D0
016C: 4CEE1800FFF8  MOVEM.L    -8(A6),A3/A4
0172: 4E5E          UNLK       A6
0174: 4E75          RTS        


; ======= Function at 0x0176 =======
0176: 4E560000      LINK       A6,#0
017A: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
017E: 286E000C      MOVEA.L    12(A6),A4
0182: 206E0008      MOVEA.L    8(A6),A0
0186: 1014          MOVE.B     (A4),D0
0188: B010          MOVE.W     (A0),D0
018A: 6704          BEQ.S      $0190
018C: 7001          MOVEQ      #1,D0
018E: 6022          BRA.S      $01B2
0190: 7E01          MOVEQ      #1,D7
0192: 1C14          MOVE.B     (A4),D6
0194: 4886          EXT.W      D6
0196: 6014          BRA.S      $01AC
0198: 206E0008      MOVEA.L    8(A6),A0
019C: 10347000      MOVE.B     0(A4,D7.W),D0
01A0: B0307000      MOVE.W     0(A0,D7.W),D0
01A4: 6704          BEQ.S      $01AA
01A6: 7001          MOVEQ      #1,D0
01A8: 6008          BRA.S      $01B2
01AA: 5247          MOVEA.B    D7,A1
01AC: BC47          MOVEA.W    D7,A6
01AE: 6EE8          BGT.S      $0198
01B0: 7000          MOVEQ      #0,D0
01B2: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
01B6: 4E5E          UNLK       A6
01B8: 4E75          RTS        


; ======= Function at 0x01BA =======
01BA: 4E56FFF8      LINK       A6,#-8                         ; frame=8
01BE: 2F0C          MOVE.L     A4,-(A7)
01C0: 286E0008      MOVEA.L    8(A6),A4
01C4: 601E          BRA.S      $01E4
01C6: 206E000C      MOVEA.L    12(A6),A0
01CA: 1010          MOVE.B     (A0),D0
01CC: 4880          EXT.W      D0
01CE: 3F00          MOVE.W     D0,-(A7)
01D0: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
01D4: 206E0008      MOVEA.L    8(A6),A0
01D8: 52AE0008      MOVE.B     8(A6),(A1)
01DC: 1080          MOVE.B     D0,(A0)
01DE: 52AE000C      MOVE.B     12(A6),(A1)
01E2: 548F          MOVE.B     A7,(A2)
01E4: 206E000C      MOVEA.L    12(A6),A0
01E8: 4A10          TST.B      (A0)
01EA: 66DA          BNE.S      $01C6
01EC: 206E0008      MOVEA.L    8(A6),A0
01F0: 4210          CLR.B      (A0)
01F2: 200C          MOVE.L     A4,D0
01F4: 285F          MOVEA.L    (A7)+,A4
01F6: 4E5E          UNLK       A6
01F8: 4E75          RTS        


; ======= Function at 0x01FA =======
01FA: 4E56FFF8      LINK       A6,#-8                         ; frame=8
01FE: 2F0C          MOVE.L     A4,-(A7)
0200: 286E0008      MOVEA.L    8(A6),A4
0204: 601E          BRA.S      $0224
0206: 206E000C      MOVEA.L    12(A6),A0
020A: 1010          MOVE.B     (A0),D0
020C: 4880          EXT.W      D0
020E: 3F00          MOVE.W     D0,-(A7)
0210: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
0214: 206E0008      MOVEA.L    8(A6),A0
0218: 52AE0008      MOVE.B     8(A6),(A1)
021C: 1080          MOVE.B     D0,(A0)
021E: 52AE000C      MOVE.B     12(A6),(A1)
0222: 548F          MOVE.B     A7,(A2)
0224: 206E000C      MOVEA.L    12(A6),A0
0228: 4A10          TST.B      (A0)
022A: 66DA          BNE.S      $0206
022C: 206E0008      MOVEA.L    8(A6),A0
0230: 4210          CLR.B      (A0)
0232: 200C          MOVE.L     A4,D0
0234: 285F          MOVEA.L    (A7)+,A4
0236: 4E5E          UNLK       A6
0238: 4E75          RTS        


; ======= Function at 0x023A =======
023A: 4E56FFFC      LINK       A6,#-4                         ; frame=4
023E: 6004          BRA.S      $0244
0240: 52AE0008      MOVE.B     8(A6),(A1)
0244: 206E0008      MOVEA.L    8(A6),A0
0248: 7000          MOVEQ      #0,D0
024A: 1010          MOVE.B     (A0),D0
024C: 224D          MOVEA.L    A5,A1
024E: D3C07006C029  MOVE.B     D0,$7006C029
0254: FBD8          MOVE.W     (A0)+,???
0256: 66E8          BNE.S      $0240
0258: 202E0008      MOVE.L     8(A6),D0
025C: 4E5E          UNLK       A6
025E: 4E75          RTS        
