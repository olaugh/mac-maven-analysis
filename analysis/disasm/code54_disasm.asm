;======================================================================
; CODE 54 Disassembly
; File: /tmp/maven_code_54.bin
; Header: JT offset=3416, JT entries=1
; Code size: 42 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
0008: 286E0008      MOVEA.L    8(A6),A4
000C: 366E000C      MOVEA.W    12(A6),A3
0010: D7CC6008      MOVE.B     A4,8(PC,D6.W)
0014: 4A1C          TST.B      (A4)+
0016: 6704          BEQ.S      $001C
0018: 7000          MOVEQ      #0,D0
001A: 6006          BRA.S      $0022
001C: B7CC62F4      MOVE.W     A4,-12(PC,D6.W)
0020: 7001          MOVEQ      #1,D0
0022: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
0026: 4E5E          UNLK       A6
0028: 4E75          RTS        
