;======================================================================
; CODE 44 Disassembly
; File: /tmp/maven_code_44.bin
; Header: JT offset=2720, JT entries=4
; Code size: 424 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FF80      LINK       A6,#-128                       ; frame=128
0004: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0008: 286E0008      MOVEA.L    8(A6),A4
000C: 2F0C          MOVE.L     A4,-(A7)
000E: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
0012: 486EFF80      PEA        -128(A6)
0016: 4EAD095A      JSR        2394(A5)                       ; JT[2394]
001A: 3E00          MOVE.W     D0,D7
001C: 0C470011      CMPI.W     #$0011,D7
0020: 508F          MOVE.B     A7,(A0)
0022: 652E          BCS.S      $0052
0024: 3F3C0220      MOVE.W     #$0220,-(A7)
0028: 486DBCFE      PEA        -17154(A5)                     ; g_state1
002C: 4EAD0D7A      JSR        3450(A5)                       ; JT[3450]
0030: 4A40          TST.W      D0
0032: 5C8F          MOVE.B     A7,(A6)
0034: 6708          BEQ.S      $003E
0036: 41ED0AD2      LEA        2770(A5),A0                    ; A5+2770
003A: 2008          MOVE.L     A0,D0
003C: 6002          BRA.S      $0040
003E: 7000          MOVEQ      #0,D0
0040: 2B40B3E2      MOVE.L     D0,-19486(A5)
0044: 486D0842      PEA        2114(A5)                       ; A5+2114
0048: 2F0C          MOVE.L     A4,-(A7)
004A: 4EAD0852      JSR        2130(A5)                       ; JT[2130]
004E: 508F          MOVE.B     A7,(A0)
0050: 6020          BRA.S      $0072
0052: 0C470008      CMPI.W     #$0008,D7
0056: 6C0E          BGE.S      $0066
0058: 2F2E000C      MOVE.L     12(A6),-(A7)
005C: 2F0C          MOVE.L     A4,-(A7)
005E: 4EAD089A      JSR        2202(A5)                       ; JT[2202]
0062: 508F          MOVE.B     A7,(A0)
0064: 600C          BRA.S      $0072
0066: 3F2E0010      MOVE.W     16(A6),-(A7)
006A: 2F0C          MOVE.L     A4,-(A7)
006C: 4EAD0A1A      JSR        2586(A5)                       ; JT[2586]
0070: 5C8F          MOVE.B     A7,(A6)
0072: 41EDA5F0      LEA        -23056(A5),A0                  ; g_dawg_?
0076: 2008          MOVE.L     A0,D0
0078: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
007C: 4E5E          UNLK       A6
007E: 4E75          RTS        


; ======= Function at 0x0080 =======
0080: 4E560000      LINK       A6,#0
0084: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
0088: 246E0008      MOVEA.L    8(A6),A2
008C: 49EDA5F0      LEA        -23056(A5),A4                  ; g_dawg_?
0090: 7022          MOVEQ      #34,D0
0092: C1EDCF04      ANDA.L     -12540(A5),A0
0096: 47EDA5F0      LEA        -23056(A5),A3                  ; g_dawg_?
009A: D08B          MOVE.B     A3,(A0)
009C: 2640          MOVEA.L    D0,A3
009E: 2E2A0014      MOVE.L     20(A2),D7
00A2: DEAA0010      MOVE.B     16(A2),(A7)
00A6: DEAA0018      MOVE.B     24(A2),(A7)
00AA: 6030          BRA.S      $00DC
00AC: 2F0C          MOVE.L     A4,-(A7)
00AE: 2F0A          MOVE.L     A2,-(A7)
00B0: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
00B4: 4A40          TST.W      D0
00B6: 508F          MOVE.B     A7,(A0)
00B8: 661E          BNE.S      $00D8
00BA: 202C0010      MOVE.L     16(A4),D0
00BE: D0AC0014      MOVE.B     20(A4),(A0)
00C2: D0AC0018      MOVE.B     24(A4),(A0)
00C6: B087          MOVE.W     D7,(A0)
00C8: 6D04          BLT.S      $00CE
00CA: 7000          MOVEQ      #0,D0
00CC: 6014          BRA.S      $00E2
00CE: 2F0C          MOVE.L     A4,-(A7)
00D0: 4EBA0098      JSR        152(PC)
00D4: 588F          MOVE.B     A7,(A4)
00D6: 6008          BRA.S      $00E0
00D8: 49EC0022      LEA        34(A4),A4
00DC: B7CC62CC      MOVE.W     A4,-52(PC,D6.W)
00E0: 7001          MOVEQ      #1,D0
00E2: 4CDF1C80      MOVEM.L    (SP)+,D7/A2/A3/A4              ; restore
00E6: 4E5E          UNLK       A6
00E8: 4E75          RTS        


; ======= Function at 0x00EA =======
00EA: 4E560000      LINK       A6,#0
00EE: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
00F2: 286E0008      MOVEA.L    8(A6),A4
00F6: 0C6D0001B1D6  CMPI.W     #$0001,-20010(A5)
00FC: 664A          BNE.S      $0148
00FE: 0C2C000F0020  CMPI.B     #$000F,32(A4)
0104: 6F42          BLE.S      $0148
0106: 1E2C0020      MOVE.B     32(A4),D7
010A: 102C0021      MOVE.B     33(A4),D0
010E: 4880          EXT.W      D0
0110: 1207          MOVE.B     D7,D1
0112: 4881          EXT.W      D1
0114: C3FC001147ED  ANDA.L     #$001147ED,A1
011A: BCFE          MOVE.W     ???,(A6)+
011C: D28B          MOVE.B     A3,(A1)
011E: 3640          MOVEA.W    D0,A3
0120: D28B          MOVE.B     A3,(A1)
0122: 2641          MOVEA.L    D1,A3
0124: 6002          BRA.S      $0128
0126: 528B          MOVE.B     A3,(A1)
0128: 4A13          TST.B      (A3)
012A: 66FA          BNE.S      $0126
012C: 0C070010      CMPI.B     #$0010,D7
0130: 6706          BEQ.S      $0138
0132: 4A2BFFEF      TST.B      -17(A3)
0136: 660C          BNE.S      $0144
0138: 0C07001E      CMPI.B     #$001E,D7
013C: 670A          BEQ.S      $0148
013E: 4A2B0011      TST.B      17(A3)
0142: 6704          BEQ.S      $0148
0144: 7000          MOVEQ      #0,D0
0146: 601A          BRA.S      $0162
0148: 4AADB3E2      TST.L      -19486(A5)
014C: 6712          BEQ.S      $0160
014E: 2F0C          MOVE.L     A4,-(A7)
0150: 206DB3E2      MOVEA.L    -19486(A5),A0
0154: 4E90          JSR        (A0)
0156: 4A40          TST.W      D0
0158: 588F          MOVE.B     A7,(A4)
015A: 6604          BNE.S      $0160
015C: 7000          MOVEQ      #0,D0
015E: 6002          BRA.S      $0162
0160: 7001          MOVEQ      #1,D0
0162: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
0166: 4E5E          UNLK       A6
0168: 4E75          RTS        


; ======= Function at 0x016A =======
016A: 4E56FFFC      LINK       A6,#-4                         ; frame=4
016E: 2F0C          MOVE.L     A4,-(A7)
0170: 536DCF047022  MOVE.B     -12540(A5),28706(A1)           ; A5-12540
0176: C1EDCF04      ANDA.L     -12540(A5),A0
017A: 49EDA5F0      LEA        -23056(A5),A4                  ; g_dawg_?
017E: D08C          MOVE.B     A4,(A0)
0180: 2840          MOVEA.L    D0,A4
0182: 6012          BRA.S      $0196
0184: 206E0008      MOVEA.L    8(A6),A0
0188: 43E8FFDE      LEA        -34(A0),A1
018C: 7007          MOVEQ      #7,D0
018E: 22D8          MOVE.L     (A0)+,(A1)+
0190: 51C8FFFC      DBF        D0,$018E                       ; loop
0194: 32D8          MOVE.W     (A0)+,(A1)+
0196: 7022          MOVEQ      #34,D0
0198: D1AE0008B9EE  MOVE.B     8(A6),-18(A0,A3.L)
019E: 000864E2      ORI.B      #$64E2,A0
01A2: 285F          MOVEA.L    (A7)+,A4
01A4: 4E5E          UNLK       A6
01A6: 4E75          RTS        
