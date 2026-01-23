;======================================================================
; CODE 4 Disassembly
; File: /tmp/maven_code_4.bin
; Header: JT offset=1424, JT entries=2
; Code size: 108 bytes
;======================================================================

0000: 2F07          MOVE.L     D7,-(A7)
0002: 2E2DF23C      MOVE.L     -3524(A5),D7                   ; A5-3524
0006: 2007          MOVE.L     D7,D0
0008: E888          MOVE.L     A0,(A4)
000A: BF800240      MOVE.W     D0,64(A7,D0.W*2)
000E: 00016708      ORI.B      #$6708,D1
0012: 203C40000000  MOVE.L     #$40000000,D0
0018: 6002          BRA.S      $001C
001A: 7000          MOVEQ      #0,D0
001C: 2207          MOVE.L     D7,D1
001E: E289          MOVE.L     A1,(A1)
0020: D280          MOVE.B     D0,(A1)
0022: 2B41F23C      MOVE.L     D1,-3524(A5)
0026: 2001          MOVE.L     D1,D0
0028: 2E1F          MOVE.L     (A7)+,D7
002A: 4E75          RTS        


; ======= Function at 0x002C =======
002C: 4E560000      LINK       A6,#0
0030: 2B6E0008F23C  MOVE.L     8(A6),-3524(A5)
0036: 4E5E          UNLK       A6
0038: 4E75          RTS        


; ======= Function at 0x003A =======
003A: 4E560000      LINK       A6,#0
003E: 48E70700      MOVEM.L    D5/D6/D7,-(SP)                 ; save
0042: 2E2E0008      MOVE.L     8(A6),D7
0046: 2C2E000C      MOVE.L     12(A6),D6
004A: BC87          MOVE.W     D7,(A6)
004C: 6F06          BLE.S      $0054
004E: 2A07          MOVE.L     D7,D5
0050: 2E06          MOVE.L     D6,D7
0052: 2C05          MOVE.L     D5,D6
0054: 2F06          MOVE.L     D6,-(A7)
0056: 2F07          MOVE.L     D7,-(A7)
0058: 4EAD0062      JSR        98(A5)                         ; JT[98]
005C: 2E00          MOVE.L     D0,D7
005E: 4A87          TST.L      D7
0060: 66E8          BNE.S      $004A
0062: 2006          MOVE.L     D6,D0
0064: 4CDF00E0      MOVEM.L    (SP)+,D5/D6/D7                 ; restore
0068: 4E5E          UNLK       A6
006A: 4E75          RTS        
