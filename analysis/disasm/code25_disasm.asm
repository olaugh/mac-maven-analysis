;======================================================================
; CODE 25 Disassembly
; File: /tmp/maven_code_25.bin
; Header: JT offset=3536, JT entries=1
; Code size: 200 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 48E70718      MOVEM.L    D5/D6/D7/A3/A4,-(SP)           ; save
0008: 286E000C      MOVEA.L    12(A6),A4
000C: 200C          MOVE.L     A4,D0
000E: 6604          BNE.S      $0014
0010: 49EDA54E      LEA        -23218(A5),A4                  ; A5-23218
0014: 266E0008      MOVEA.L    8(A6),A3
0018: 600A          BRA.S      $0024
001A: 1013          MOVE.B     (A3),D0
001C: 4880          EXT.W      D0
001E: 42340000      CLR.B      0(A4,D0.W)
0022: 528B          MOVE.B     A3,(A1)
0024: 4A13          TST.B      (A3)
0026: 66F2          BNE.S      $001A
0028: 7C01          MOVEQ      #1,D6
002A: 2E06          MOVE.L     D6,D7
002C: 266E0008      MOVEA.L    8(A6),A3
0030: 1A13          MOVE.B     (A3),D5
0032: 4A05          TST.B      D5
0034: 676E          BEQ.S      $00A4
0036: 1005          MOVE.B     D5,D0
0038: 4880          EXT.W      D0
003A: 10340000      MOVE.B     0(A4,D0.W),D0
003E: 4880          EXT.W      D0
0040: 1205          MOVE.B     D5,D1
0042: 4881          EXT.W      D1
0044: 204D          MOVEA.L    A5,A0
0046: D0C1          MOVE.B     D1,(A0)+
0048: 12289512      MOVE.B     -27374(A0),D1
004C: 4881          EXT.W      D1
004E: 9240          MOVEA.B    D0,A1
0050: 3041          MOVEA.W    D1,A0
0052: 2F08          MOVE.L     A0,-(A7)
0054: 2F07          MOVE.L     D7,-(A7)
0056: 4EAD0042      JSR        66(A5)                         ; JT[66]
005A: 2E00          MOVE.L     D0,D7
005C: 4A87          TST.L      D7
005E: 6744          BEQ.S      $00A4
0060: 1013          MOVE.B     (A3),D0
0062: 4880          EXT.W      D0
0064: 52340000      MOVE.B     0(A4,D0.W),D1
0068: 10340000      MOVE.B     0(A4,D0.W),D0
006C: 4880          EXT.W      D0
006E: 3040          MOVEA.W    D0,A0
0070: 2F08          MOVE.L     A0,-(A7)
0072: 2F06          MOVE.L     D6,-(A7)
0074: 4EAD0042      JSR        66(A5)                         ; JT[66]
0078: 2C00          MOVE.L     D0,D6
007A: 2F06          MOVE.L     D6,-(A7)
007C: 2F07          MOVE.L     D7,-(A7)
007E: 4EAD05BA      JSR        1466(A5)                       ; JT[1466]
0082: 2A00          MOVE.L     D0,D5
0084: 7001          MOVEQ      #1,D0
0086: B085          MOVE.W     D5,(A0)
0088: 508F          MOVE.B     A7,(A0)
008A: 6C14          BGE.S      $00A0
008C: 2F05          MOVE.L     D5,-(A7)
008E: 2F07          MOVE.L     D7,-(A7)
0090: 4EAD005A      JSR        90(A5)                         ; JT[90]
0094: 2E00          MOVE.L     D0,D7
0096: 2F05          MOVE.L     D5,-(A7)
0098: 2F06          MOVE.L     D6,-(A7)
009A: 4EAD005A      JSR        90(A5)                         ; JT[90]
009E: 2C00          MOVE.L     D0,D6
00A0: 528B          MOVE.B     A3,(A1)
00A2: 608C          BRA.S      $0030
00A4: 2F06          MOVE.L     D6,-(A7)
00A6: 2F07          MOVE.L     D7,-(A7)
00A8: 4EAD0062      JSR        98(A5)                         ; JT[98]
00AC: 4A80          TST.L      D0
00AE: 6704          BEQ.S      $00B4
00B0: 4EAD01A2      JSR        418(A5)                        ; JT[418]
00B4: 2F06          MOVE.L     D6,-(A7)
00B6: 2F07          MOVE.L     D7,-(A7)
00B8: 4EAD005A      JSR        90(A5)                         ; JT[90]
00BC: 2E00          MOVE.L     D0,D7
00BE: 2007          MOVE.L     D7,D0
00C0: 4CDF18E0      MOVEM.L    (SP)+,D5/D6/D7/A3/A4           ; restore
00C4: 4E5E          UNLK       A6
00C6: 4E75          RTS        
