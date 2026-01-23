;======================================================================
; CODE 28 Disassembly
; File: /tmp/maven_code_28.bin
; Header: JT offset=2080, JT entries=3
; Code size: 664 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
0008: 286E0008      MOVEA.L    8(A6),A4
000C: 2E2C0014      MOVE.L     20(A4),D7
0010: DEAC0010      MOVE.B     16(A4),(A7)
0014: DEAC0018      MOVE.B     24(A4),(A7)
0018: 0C6D000ACF04  CMPI.W     #$000A,-12540(A5)
001E: 6608          BNE.S      $0028
0020: BEADF522      MOVE.W     -2782(A5),(A7)                 ; A5-2782
0024: 6F0000B6      BLE.W      $00DE
0028: 2F0C          MOVE.L     A4,-(A7)
002A: 4EAD0ACA      JSR        2762(A5)                       ; JT[2762]
002E: 4A40          TST.W      D0
0030: 588F          MOVE.B     A7,(A4)
0032: 670000A8      BEQ.W      $00DE
0036: 0C6D000ACF04  CMPI.W     #$000A,-12540(A5)
003C: 661C          BNE.S      $005A
003E: 47EDA5F0      LEA        -23056(A5),A3                  ; g_dawg_?
0042: 6004          BRA.S      $0048
0044: 47EB0022      LEA        34(A3),A3
0048: 202B0010      MOVE.L     16(A3),D0
004C: D0AB0014      MOVE.B     20(A3),(A0)
0050: D0AB0018      MOVE.B     24(A3),(A0)
0054: B087          MOVE.W     D7,(A0)
0056: 6CEC          BGE.S      $0044
0058: 6030          BRA.S      $008A
005A: 47EDA5F0      LEA        -23056(A5),A3                  ; g_dawg_?
005E: 7022          MOVEQ      #34,D0
0060: C1EDCF04      ANDA.L     -12540(A5),A0
0064: 45EDA5F0      LEA        -23056(A5),A2                  ; g_dawg_?
0068: D08A          MOVE.B     A2,(A0)
006A: 2440          MOVEA.L    D0,A2
006C: 6004          BRA.S      $0072
006E: 47EB0022      LEA        34(A3),A3
0072: B5CB6310      MOVE.W     A3,25360(PC)
0076: 202B0010      MOVE.L     16(A3),D0
007A: D0AB0014      MOVE.B     20(A3),(A0)
007E: D0AB0018      MOVE.B     24(A3),(A0)
0082: B087          MOVE.W     D7,(A0)
0084: 6CE8          BGE.S      $006E
0086: 526DCF04      MOVEA.B    -12540(A5),A1
008A: 48780022      PEA        $0022.W
008E: 48780022      PEA        $0022.W
0092: 41EDA5F0      LEA        -23056(A5),A0                  ; g_dawg_?
0096: 200B          MOVE.L     A3,D0
0098: 9088          MOVE.B     A0,(A0)
009A: 2F00          MOVE.L     D0,-(A7)
009C: 4EAD005A      JSR        90(A5)                         ; JT[90]
00A0: 306DCF04      MOVEA.W    -12540(A5),A0
00A4: 538891C0      MOVE.B     A0,-64(A1,A1.W)
00A8: 2F08          MOVE.L     A0,-(A7)
00AA: 4EAD0042      JSR        66(A5)                         ; JT[66]
00AE: 2F00          MOVE.L     D0,-(A7)
00B0: 2F0B          MOVE.L     A3,-(A7)
00B2: 486B0022      PEA        34(A3)
00B6: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
00BA: 41D3          LEA        (A3),A0
00BC: 43D4          LEA        (A4),A1
00BE: 7007          MOVEQ      #7,D0
00C0: 20D9          MOVE.L     (A1)+,(A0)+
00C2: 51C8FFFC      DBF        D0,$00C0                       ; loop
00C6: 30D9          MOVE.W     (A1)+,(A0)+
00C8: 47EDA722      LEA        -22750(A5),A3                  ; A5-22750
00CC: 202B0010      MOVE.L     16(A3),D0
00D0: D0AB0014      MOVE.B     20(A3),(A0)
00D4: D0AB0018      MOVE.B     24(A3),(A0)
00D8: 2B40F522      MOVE.L     D0,-2782(A5)
00DC: 4CEE1C80FFF0  MOVEM.L    -16(A6),D7/A2/A3/A4
00E2: 4E5E          UNLK       A6
00E4: 4E75          RTS        


; ======= Function at 0x00E6 =======
00E6: 4E560000      LINK       A6,#0
00EA: 48E70300      MOVEM.L    D6/D7,-(SP)                    ; save
00EE: 7E00          MOVEQ      #0,D7
00F0: 600E          BRA.S      $0100
00F2: 1006          MOVE.B     D6,D0
00F4: 4880          EXT.W      D0
00F6: 204D          MOVEA.L    A5,A0
00F8: D0C0          MOVE.B     D0,(A0)+
00FA: D0C0          MOVE.B     D0,(A0)+
00FC: DE689412      MOVEA.B    -27630(A0),A7
0100: 206E0008      MOVEA.L    8(A6),A0
0104: 52AE0008      MOVE.B     8(A6),(A1)
0108: 1C10          MOVE.B     (A0),D6
010A: 66E6          BNE.S      $00F2
010C: 3007          MOVE.W     D7,D0
010E: 4CDF00C0      MOVEM.L    (SP)+,D6/D7                    ; restore
0112: 4E5E          UNLK       A6
0114: 4E75          RTS        


; ======= Function at 0x0116 =======
0116: 4E56FDF0      LINK       A6,#-528                       ; frame=528
011A: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
011E: 286E0008      MOVEA.L    8(A6),A4
0122: 266E000C      MOVEA.L    12(A6),A3
0126: 2F0C          MOVE.L     A4,-(A7)
0128: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
012C: 486EFF7C      PEA        -132(A6)
0130: 4EAD095A      JSR        2394(A5)                       ; JT[2394]
0134: 1800          MOVE.B     D0,D4
0136: 4EAD099A      JSR        2458(A5)                       ; JT[2458]
013A: 48780154      PEA        $0154.W
013E: 486DA5F0      PEA        -23056(A5)                     ; g_dawg_?
0142: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0146: 7022          MOVEQ      #34,D0
0148: 2E80          MOVE.L     D0,(A7)
014A: 486EFF4A      PEA        -182(A6)
014E: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0152: 426DCF04      CLR.W      -12540(A5)
0156: 426DB1D6      CLR.W      -20010(A5)
015A: 2B7CF4143E00A600  MOVE.L     #$F4143E00,-23040(A5)
0162: 4EAD0932      JSR        2354(A5)                       ; JT[2354]
0166: 4A40          TST.W      D0
0168: 4FEF0014      LEA        20(A7),A7
016C: 670A          BEQ.S      $0178
016E: 2F0B          MOVE.L     A3,-(A7)
0170: 4EAD09BA      JSR        2490(A5)                       ; JT[2490]
0174: 588F          MOVE.B     A7,(A4)
0176: 6046          BRA.S      $01BE
0178: 4EAD093A      JSR        2362(A5)                       ; JT[2362]
017C: 4A40          TST.W      D0
017E: 673E          BEQ.S      $01BE
0180: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
0184: B1CC6608      MOVE.W     A4,$6608.W
0188: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
018C: 2008          MOVE.L     A0,D0
018E: 6006          BRA.S      $0196
0190: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
0194: 2008          MOVE.L     A0,D0
0196: 2F00          MOVE.L     D0,-(A7)
0198: 4EBAFF4C      JSR        -180(PC)
019C: 4440          NEG.W      D0
019E: 3D40FDF0      MOVE.W     D0,-528(A6)
01A2: 2E8C          MOVE.L     A4,(A7)
01A4: 4EBAFF40      JSR        -192(PC)
01A8: D040          MOVEA.B    D0,A0
01AA: 322EFDF0      MOVE.W     -528(A6),D1
01AE: 9240          MOVEA.B    D0,A1
01B0: 3041          MOVEA.W    D1,A0
01B2: 2D48FF5E      MOVE.L     A0,-162(A6)
01B6: 486EFF4A      PEA        -182(A6)
01BA: 4E93          JSR        (A3)
01BC: 508F          MOVE.B     A7,(A0)
01BE: 2F0B          MOVE.L     A3,-(A7)
01C0: 4EAD0A3A      JSR        2618(A5)                       ; JT[2618]
01C4: 0CADF4143E00A600  CMPI.L     #$F4143E00,-23040(A5)
01CC: 588F          MOVE.B     A7,(A4)
01CE: 6608          BNE.S      $01D8
01D0: 42ADA600      CLR.L      -23040(A5)
01D4: 600000BA      BRA.W      $0292
01D8: 0C040011      CMPI.B     #$0011,D4
01DC: 650000B2      BCS.W      $0292
01E0: 48780154      PEA        $0154.W
01E4: 486DA5F0      PEA        -23056(A5)                     ; g_dawg_?
01E8: 486EFDF6      PEA        -522(A6)
01EC: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
01F0: 382DCF04      MOVE.W     -12540(A5),D4                  ; A5-12540
01F4: 426DCF04      CLR.W      -12540(A5)
01F8: 7A00          MOVEQ      #0,D5
01FA: 47EEFDF6      LEA        -522(A6),A3
01FE: 4FEF000C      LEA        12(A7),A7
0202: 60000086      BRA.W      $028C
0206: 4A2DBD8E      TST.B      -17010(A5)
020A: 665C          BNE.S      $0268
020C: 2F0B          MOVE.L     A3,-(A7)
020E: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0212: 7609          MOVEQ      #9,D3
0214: 9640          MOVEA.B    D0,A3
0216: 45EB0021      LEA        33(A3),A2
021A: 7E18          MOVEQ      #24,D7
021C: DE8B          MOVE.B     A3,(A7)
021E: 7C14          MOVEQ      #20,D6
0220: DC8B          MOVE.B     A3,(A6)
0222: 41EB0010      LEA        16(A3),A0
0226: 2D48FDF2      MOVE.L     A0,-526(A6)
022A: 588F          MOVE.B     A7,(A4)
022C: 6032          BRA.S      $0260
022E: 1483          MOVE.B     D3,(A2)
0230: 42A7          CLR.L      -(A7)
0232: 42A7          CLR.L      -(A7)
0234: 2F0B          MOVE.L     A3,-(A7)
0236: 4EAD09E2      JSR        2530(A5)                       ; JT[2530]
023A: 2046          MOVEA.L    D6,A0
023C: 9090          MOVE.B     (A0),(A0)
023E: 2047          MOVEA.L    D7,A0
0240: 2080          MOVE.L     D0,(A0)
0242: 486EFF6C      PEA        -148(A6)
0246: 2F0C          MOVE.L     A4,-(A7)
0248: 2F0B          MOVE.L     A3,-(A7)
024A: 4EAD098A      JSR        2442(A5)                       ; JT[2442]
024E: 206EFDF2      MOVEA.L    -526(A6),A0
0252: 2080          MOVE.L     D0,(A0)
0254: 2E8B          MOVE.L     A3,(A7)
0256: 4EBAFDA8      JSR        -600(PC)
025A: 4FEF0018      LEA        24(A7),A7
025E: 5243          MOVEA.B    D3,A1
0260: 0C430008      CMPI.W     #$0008,D3
0264: 6FC8          BLE.S      $022E
0266: 601C          BRA.S      $0284
0268: 42A7          CLR.L      -(A7)
026A: 42A7          CLR.L      -(A7)
026C: 2F0B          MOVE.L     A3,-(A7)
026E: 4EAD09E2      JSR        2530(A5)                       ; JT[2530]
0272: 90AB0014      MOVE.B     20(A3),(A0)
0276: 27400018      MOVE.L     D0,24(A3)
027A: 2E8B          MOVE.L     A3,(A7)
027C: 4EBAFD82      JSR        -638(PC)
0280: 4FEF000C      LEA        12(A7),A7
0284: 5245          MOVEA.B    D5,A1
0286: 47EB0022      LEA        34(A3),A3
028A: B845          MOVEA.W    D5,A4
028C: 6E00FF78      BGT.W      $0208
0290: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0294: 4E5E          UNLK       A6
0296: 4E75          RTS        
