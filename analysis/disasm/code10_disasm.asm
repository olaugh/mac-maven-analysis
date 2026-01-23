;======================================================================
; CODE 10 Disassembly
; File: /tmp/maven_code_10.bin
; Header: JT offset=352, JT entries=3
; Code size: 138 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FF00      LINK       A6,#-256                       ; frame=256
0004: 42A7          CLR.L      -(A7)
0006: 3F3C0080      MOVE.W     #$0080,-(A7)
000A: A9493F2E      MOVE.L     A1,16174(A4)
000E: 000C486E      ORI.B      #$486E,A4
0012: FF00          MOVE.W     D0,-(A7)
0014: A9464267      MOVE.L     D6,16999(A4)
0018: 486EFF00      PEA        -256(A6)
001C: A9B64E5E4E75  MOVE.L     94(A6,D4.L*8),117(A4,D4.L*8)

; ======= Function at 0x0022 =======
0022: 4E560000      LINK       A6,#0
0026: 7000          MOVEQ      #0,D0
0028: 102DD720      MOVE.B     -10464(A5),D0                  ; g_state3
002C: 3F00          MOVE.W     D0,-(A7)
002E: 4EAD0112      JSR        274(A5)                        ; JT[274]
0032: 4E5E          UNLK       A6
0034: 4E75          RTS        


; ======= Function at 0x0036 =======
0036: 4E560000      LINK       A6,#0
003A: 4267          CLR.W      -(A7)
003C: 4EAD0112      JSR        274(A5)                        ; JT[274]
0040: 4E5E          UNLK       A6
0042: 4E75          RTS        


; ======= Function at 0x0044 =======
0044: 4E560000      LINK       A6,#0
0048: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
004C: 286E0008      MOVEA.L    8(A6),A4
0050: 2F0C          MOVE.L     A4,-(A7)
0052: 4EAD064A      JSR        1610(A5)                       ; JT[1610]
0056: 4A40          TST.W      D0
0058: 588F          MOVE.B     A7,(A4)
005A: 670E          BEQ.S      $006A
005C: 2F0C          MOVE.L     A4,-(A7)
005E: 4EAD064A      JSR        1610(A5)                       ; JT[1610]
0062: 3E80          MOVE.W     D0,(A7)
0064: A9B7548F6018  MOVE.L     -113(A7,D5.W*4),24(A4,D6.W)
006A: 48780007      PEA        $0007.W
006E: 2F0C          MOVE.L     A4,-(A7)
0070: 4EAD01FA      JSR        506(A5)                        ; JT[506]
0074: 2640          MOVEA.L    D0,A3
0076: 200B          MOVE.L     A3,D0
0078: 508F          MOVE.B     A7,(A0)
007A: 6706          BEQ.S      $0082
007C: 2F0C          MOVE.L     A4,-(A7)
007E: 4E93          JSR        (A3)
0080: 588F          MOVE.B     A7,(A4)
0082: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
0086: 4E5E          UNLK       A6
0088: 4E75          RTS        
