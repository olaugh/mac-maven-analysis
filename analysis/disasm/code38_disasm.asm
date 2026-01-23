;======================================================================
; CODE 38 Disassembly
; File: /tmp/maven_code_38.bin
; Header: JT offset=2592, JT entries=2
; Code size: 374 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 7001          MOVEQ      #1,D0
0006: 4E5E          UNLK       A6
0008: 4E75          RTS        


; ======= Function at 0x000A =======
000A: 4E56FFF8      LINK       A6,#-8                         ; frame=8
000E: 422EFFF8      CLR.B      -8(A6)
0012: 422DC35E      CLR.B      -15522(A5)
0016: 486EFFF8      PEA        -8(A6)
001A: 4EAD0962      JSR        2402(A5)                       ; JT[2402]
001E: 486EFFF8      PEA        -8(A6)
0022: 4EBAFFDC      JSR        -36(PC)
0026: 4A40          TST.W      D0
0028: 508F          MOVE.B     A7,(A0)
002A: 67E2          BEQ.S      $000E
002C: 48780001      PEA        $0001.W
0030: 486EFFF8      PEA        -8(A6)
0034: 206E0008      MOVEA.L    8(A6),A0
0038: 4E90          JSR        (A0)
003A: 508F          MOVE.B     A7,(A0)
003C: 60D0          BRA.S      $000E
003E: 4E5E          UNLK       A6
0040: 4E75          RTS        


; ======= Function at 0x0042 =======
0042: 4E56FEE0      LINK       A6,#-288                       ; frame=288
0046: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
004A: 4AAE0008      TST.L      8(A6)
004E: 6604          BNE.S      $0054
0050: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0054: 486EFF80      PEA        -128(A6)
0058: 4EAD095A      JSR        2394(A5)                       ; JT[2394]
005C: 3E00          MOVE.W     D0,D7
005E: 0C470012      CMPI.W     #$0012,D7
0062: 588F          MOVE.B     A7,(A4)
0064: 6D04          BLT.S      $006A
0066: 4EAD01A2      JSR        418(A5)                        ; JT[418]
006A: 49EEFEE0      LEA        -288(A6),A4
006E: 266D99D2      MOVEA.L    -26158(A5),A3
0072: 1E13          MOVE.B     (A3),D7
0074: 4A07          TST.B      D7
0076: 6710          BEQ.S      $0088
0078: 1007          MOVE.B     D7,D0
007A: 4880          EXT.W      D0
007C: 4A360080      TST.B      -128(A6,D0.W)
0080: 6702          BEQ.S      $0084
0082: 18D3          MOVE.B     (A3),(A4)+
0084: 528B          MOVE.B     A3,(A1)
0086: 60EA          BRA.S      $0072
0088: 4214          CLR.B      (A4)
008A: 2F2E0008      MOVE.L     8(A6),-(A7)
008E: 4267          CLR.W      -(A7)
0090: 486EFEE0      PEA        -288(A6)
0094: 486EFF00      PEA        -256(A6)
0098: 486EFF80      PEA        -128(A6)
009C: 4EBA000C      JSR        12(PC)
00A0: 4CEE1880FED4  MOVEM.L    -300(A6),D7/A3/A4
00A6: 4E5E          UNLK       A6
00A8: 4E75          RTS        


; ======= Function at 0x00AA =======
00AA: 4E560000      LINK       A6,#0
00AE: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
00B2: 2E2E0008      MOVE.L     8(A6),D7
00B6: 286E000C      MOVEA.L    12(A6),A4
00BA: 266E0010      MOVEA.L    16(A6),A3
00BE: 3C2E0014      MOVE.W     20(A6),D6
00C2: 0C460007      CMPI.W     #$0007,D6
00C6: 6F06          BLE.S      $00CE
00C8: 7000          MOVEQ      #0,D0
00CA: 600000A0      BRA.W      $016E
00CE: 0C460007      CMPI.W     #$0007,D6
00D2: 6656          BNE.S      $012A
00D4: 4214          CLR.B      (A4)
00D6: 5F8C7C01      MOVE.B     A4,1(A7,D7.L*4)
00DA: 264C          MOVEA.L    A4,A3
00DC: 45EBFFFF      LEA        -1(A3),A2
00E0: 1A13          MOVE.B     (A3),D5
00E2: 4A05          TST.B      D5
00E4: 6738          BEQ.S      $011E
00E6: BA2B0001      MOVE.W     1(A3),D5
00EA: 672E          BEQ.S      $011A
00EC: 1005          MOVE.B     D5,D0
00EE: 4880          EXT.W      D0
00F0: 3040          MOVEA.W    D0,A0
00F2: 10307800      MOVE.B     0(A0,D7.L),D0
00F6: 4880          EXT.W      D0
00F8: 48C0          EXT.L      D0
00FA: E988220B      MOVE.L     A0,11(A4,D2.W*2)
00FE: 928A          MOVE.B     A2,(A1)
0100: 41ED9A58      LEA        -26024(A5),A0                  ; A5-26024
0104: D088          MOVE.B     A0,(A0)
0106: D281          MOVE.B     D1,(A1)
0108: D081          MOVE.B     D1,(A0)
010A: 2040          MOVEA.L    D0,A0
010C: 3050          MOVEA.W    (A0),A0
010E: 2F08          MOVE.L     A0,-(A7)
0110: 2F06          MOVE.L     D6,-(A7)
0112: 4EAD0042      JSR        66(A5)                         ; JT[66]
0116: 2C00          MOVE.L     D0,D6
0118: 244B          MOVEA.L    A3,A2
011A: 528B          MOVE.B     A3,(A1)
011C: 60C2          BRA.S      $00E0
011E: 2F06          MOVE.L     D6,-(A7)
0120: 2F0C          MOVE.L     A4,-(A7)
0122: 206E0016      MOVEA.L    22(A6),A0
0126: 4E90          JSR        (A0)
0128: 6042          BRA.S      $016C
012A: 4A13          TST.B      (A3)
012C: 6604          BNE.S      $0132
012E: 7000          MOVEQ      #0,D0
0130: 603A          BRA.S      $016C
0132: 7800          MOVEQ      #0,D4
0134: 2F2E0016      MOVE.L     22(A6),-(A7)
0138: 3F06          MOVE.W     D6,-(A7)
013A: 486B0001      PEA        1(A3)
013E: 2F0C          MOVE.L     A4,-(A7)
0140: 2F07          MOVE.L     D7,-(A7)
0142: 4EBAFF66      JSR        -154(PC)
0146: 4A40          TST.W      D0
0148: 4FEF0012      LEA        18(A7),A7
014C: 6704          BEQ.S      $0152
014E: 7001          MOVEQ      #1,D0
0150: 601A          BRA.S      $016C
0152: 18D3          MOVE.B     (A3),(A4)+
0154: 5246          MOVEA.B    D6,A1
0156: 3004          MOVE.W     D4,D0
0158: 5244          MOVEA.B    D4,A1
015A: 1213          MOVE.B     (A3),D1
015C: 4881          EXT.W      D1
015E: 3041          MOVEA.W    D1,A0
0160: 12307800      MOVE.B     0(A0,D7.L),D1
0164: 4881          EXT.W      D1
0166: B240          MOVEA.W    D0,A1
0168: 6ECA          BGT.S      $0134
016A: 7000          MOVEQ      #0,D0
016C: 4CEE1CF0FFE4  MOVEM.L    -28(A6),D4/D5/D6/D7/A2/A3/A4
0172: 4E5E          UNLK       A6
0174: 4E75          RTS        
