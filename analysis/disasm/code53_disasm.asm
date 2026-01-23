;======================================================================
; CODE 53 Disassembly
; File: /tmp/maven_code_53.bin
; Header: JT offset=3408, JT entries=1
; Code size: 106 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
0008: 266E0008      MOVEA.L    8(A6),A3
000C: 284B          MOVEA.L    A3,A4
000E: D9EE000C7E00  MOVE.B     12(A6),#$00
0014: 4AADFB98      TST.L      -1128(A5)
0018: 6618          BNE.S      $0032
001A: 7C00          MOVEQ      #0,D6
001C: 45EDFB98      LEA        -1128(A5),A2                   ; A5-1128
0020: 600A          BRA.S      $002C
0022: 4EAD05B2      JSR        1458(A5)                       ; JT[1458]
0026: 2480          MOVE.L     D0,(A2)
0028: 5246          MOVEA.B    D6,A1
002A: 588A          MOVE.B     A2,(A4)
002C: 0C460010      CMPI.W     #$0010,D6
0030: 65F0          BCS.S      $0022
0032: 4AADFB98      TST.L      -1128(A5)
0036: 6624          BNE.S      $005C
0038: 4EAD01A2      JSR        418(A5)                        ; JT[418]
003C: 601E          BRA.S      $005C
003E: 1013          MOVE.B     (A3),D0
0040: 4880          EXT.W      D0
0042: 2207          MOVE.L     D7,D1
0044: E889          MOVE.L     A1,(A4)
0046: 740F          MOVEQ      #15,D2
0048: C487          AND.L      D7,D2
004A: 204D          MOVEA.L    A5,A0
004C: E58AD1C2      MOVE.L     A2,-62(A2,A5.W)
0050: D2A8FB98      MOVE.B     -1128(A0),(A1)
0054: 3040          MOVEA.W    D0,A0
0056: D288          MOVE.B     A0,(A1)
0058: 2E01          MOVE.L     D1,D7
005A: 528B          MOVE.B     A3,(A1)
005C: B9CB62DE      MOVE.W     A3,#$62DE
0060: 2007          MOVE.L     D7,D0
0062: 4CDF1CC0      MOVEM.L    (SP)+,D6/D7/A2/A3/A4           ; restore
0066: 4E5E          UNLK       A6
0068: 4E75          RTS        
