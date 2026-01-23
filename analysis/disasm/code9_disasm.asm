;======================================================================
; CODE 9 Disassembly
; File: /tmp/maven_code_9.bin
; Header: JT offset=1440, JT entries=37
; Code size: 3940 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 4267          CLR.W      -(A7)
0006: 3F2E0008      MOVE.W     8(A6),-(A7)
000A: 486E000A      PEA        10(A6)
000E: 2F2E000E      MOVE.L     14(A6),-(A7)
0012: 4EAD0B32      JSR        2866(A5)                       ; JT[2866]
0016: 4E5E          UNLK       A6
0018: 4E75          RTS        


; ======= Function at 0x001A =======
001A: 4E56FFFC      LINK       A6,#-4                         ; frame=4
001E: 43EEFFFC      LEA        -4(A6),A1
0022: 206E0008      MOVEA.L    8(A6),A0
0026: A03B2280      MOVE.L     -128(PC,D2.W),D0
002A: 4E5E          UNLK       A6
002C: 4E75          RTS        

002E: 3F3C0140      MOVE.W     #$0140,-(A7)
0032: 4EAD01E2      JSR        482(A5)                        ; JT[482]
0036: 548F          MOVE.B     A7,(A2)
0038: 4E75          RTS        


; ======= Function at 0x003A =======
003A: 4E560000      LINK       A6,#0
003E: 206E0008      MOVEA.L    8(A6),A0
0042: 20ADA38A      MOVE.L     -23670(A5),(A0)                ; A5-23670
0046: 2B6E000CA38A  MOVE.L     12(A6),-23670(A5)
004C: 4E5E          UNLK       A6
004E: 4E75          RTS        


; ======= Function at 0x0050 =======
0050: 4E560000      LINK       A6,#0
0054: 2B6E0008A38A  MOVE.L     8(A6),-23670(A5)
005A: 4E5E          UNLK       A6
005C: 4E75          RTS        

005E: 486DF2BC      PEA        -3396(A5)                      ; A5-3396
0062: A851          MOVEA.L    (A1),A4
0064: 4E75          RTS        

0066: A850          MOVEA.L    (A0),A4
0068: 4E75          RTS        

006A: 4267          CLR.W      -(A7)
006C: A861          MOVEA.L    -(A1),A4
006E: 301F          MOVE.W     (A7)+,D0
0070: 4E75          RTS        


; ======= Function at 0x0072 =======
0072: 4E560000      LINK       A6,#0
0076: 206E0008      MOVEA.L    8(A6),A0
007A: 20B8016A      MOVE.L     $016A.W,(A0)
007E: 4E5E          UNLK       A6
0080: 4E75          RTS        


; ======= Function at 0x0082 =======
0082: 4E560000      LINK       A6,#0
0086: 4878003C      PEA        $003C.W
008A: 2038016A      MOVE.L     $016A.W,D0
008E: 90AE0008      MOVE.B     8(A6),(A0)
0092: 2040          MOVEA.L    D0,A0
0094: 4868001E      PEA        30(A0)
0098: 4EAD005A      JSR        90(A5)                         ; JT[90]
009C: 4E5E          UNLK       A6
009E: 4E75          RTS        


; ======= Function at 0x00A0 =======
00A0: 4E560000      LINK       A6,#0
00A4: 202E0008      MOVE.L     8(A6),D0
00A8: A11E          MOVE.L     (A6)+,-(A0)
00AA: 2008          MOVE.L     A0,D0
00AC: 4E5E          UNLK       A6
00AE: 4E75          RTS        


; ======= Function at 0x00B0 =======
00B0: 4E560000      LINK       A6,#0
00B4: 206E0008      MOVEA.L    8(A6),A0
00B8: A01F          MOVE.L     (A7)+,D0
00BA: 4E5E          UNLK       A6
00BC: 4E75          RTS        


; ======= Function at 0x00BE =======
00BE: 4E560000      LINK       A6,#0
00C2: 202E0010      MOVE.L     16(A6),D0
00C6: 226E000C      MOVEA.L    12(A6),A1
00CA: 206E0008      MOVEA.L    8(A6),A0
00CE: A02E4E5E      MOVE.L     20062(A6),D0
00D2: 4E75          RTS        


; ======= Function at 0x00D4 =======
00D4: 4E560000      LINK       A6,#0
00D8: 2F2E000C      MOVE.L     12(A6),-(A7)
00DC: 4267          CLR.W      -(A7)
00DE: 2F2E0008      MOVE.L     8(A6),-(A7)
00E2: 4EAD0D3A      JSR        3386(A5)                       ; JT[3386]
00E6: 4E5E          UNLK       A6
00E8: 4E75          RTS        

00EA: 4EBA0152      JSR        338(PC)
00EE: 4EBA014E      JSR        334(PC)
00F2: 4E75          RTS        


; ======= Function at 0x00F4 =======
00F4: 4E56FFFC      LINK       A6,#-4                         ; frame=4
00F8: 42A7          CLR.L      -(A7)
00FA: 2F2E000C      MOVE.L     12(A6),-(A7)
00FE: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0102: 2F2E000C      MOVE.L     12(A6),-(A7)
0106: 4EBA0122      JSR        290(PC)
010A: 2E80          MOVE.L     D0,(A7)
010C: 2F2E0008      MOVE.L     8(A6),-(A7)
0110: 4EAD07E2      JSR        2018(A5)                       ; JT[2018]
0114: 206E000C      MOVEA.L    12(A6),A0
0118: A02A4E5E      MOVE.L     20062(A2),D0
011C: 4E75          RTS        


; ======= Function at 0x011E =======
011E: 4E560000      LINK       A6,#0
0122: 3F2E000C      MOVE.W     12(A6),-(A7)
0126: 2F2E0008      MOVE.L     8(A6),-(A7)
012A: 4EBA0C34      JSR        3124(PC)
012E: 2E80          MOVE.L     D0,(A7)
0130: 4EBA00DC      JSR        220(PC)
0134: 4E5E          UNLK       A6
0136: 4E75          RTS        


; ======= Function at 0x0138 =======
0138: 4E560000      LINK       A6,#0
013C: 3F2E000C      MOVE.W     12(A6),-(A7)
0140: 2F2E0008      MOVE.L     8(A6),-(A7)
0144: 4EBA0C1A      JSR        3098(PC)
0148: 2E80          MOVE.L     D0,(A7)
014A: 3F2E000E      MOVE.W     14(A6),-(A7)
014E: A95D4E5E      MOVE.L     (A5)+,20062(A4)
0152: 4E75          RTS        


; ======= Function at 0x0154 =======
0154: 4E560000      LINK       A6,#0
0158: 3F2E000C      MOVE.W     12(A6),-(A7)
015C: 2F2E0008      MOVE.L     8(A6),-(A7)
0160: 4EBA0BFE      JSR        3070(PC)
0164: 2E80          MOVE.L     D0,(A7)
0166: 3F2E000E      MOVE.W     14(A6),-(A7)
016A: A9634E5E      MOVE.L     -(A3),20062(A4)
016E: 4E75          RTS        


; ======= Function at 0x0170 =======
0170: 4E560000      LINK       A6,#0
0174: 4267          CLR.W      -(A7)
0176: 3F2E000C      MOVE.W     12(A6),-(A7)
017A: 2F2E0008      MOVE.L     8(A6),-(A7)
017E: 4EBA0BE0      JSR        3040(PC)
0182: 548F          MOVE.B     A7,(A2)
0184: 2E80          MOVE.L     D0,(A7)
0186: A960301F      MOVE.L     -(A0),12319(A4)
018A: 4E5E          UNLK       A6
018C: 4E75          RTS        


; ======= Function at 0x018E =======
018E: 4E560000      LINK       A6,#0
0192: 2F2E0008      MOVE.L     8(A6),-(A7)
0196: A873206E      MOVEA.L    110(A3,D2.W),A4
019A: 00084868      ORI.B      #$4868,A0
019E: 0010A928      ORI.B      #$A928,(A0)
01A2: 4E5E          UNLK       A6
01A4: 4E75          RTS        


; ======= Function at 0x01A6 =======
01A6: 4E560000      LINK       A6,#0
01AA: 2F0C          MOVE.L     A4,-(A7)
01AC: 42A7          CLR.L      -(A7)
01AE: 2F2E000C      MOVE.L     12(A6),-(A7)
01B2: 4267          CLR.W      -(A7)
01B4: A9A0285F      MOVE.L     -(A0),95(A4,D2.L)
01B8: 200C          MOVE.L     A4,D0
01BA: 6724          BEQ.S      $01E0
01BC: 204C          MOVEA.L    A4,A0
01BE: A02942A7      MOVE.L     17063(A1),D0
01C2: 2F0C          MOVE.L     A4,-(A7)
01C4: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
01C8: 201F          MOVE.L     (A7)+,D0
01CA: 2254          MOVEA.L    (A4),A1
01CC: 206E0008      MOVEA.L    8(A6),A0
01D0: A02E204C      MOVE.L     8268(A6),D0
01D4: A02A2F0C      MOVE.L     12044(A2),D0
01D8: A9AA4267A994  MOVE.L     16999(A2),-108(A4,A2.L)
01DE: A999285F      MOVE.L     (A1)+,95(A4,D2.L)
01E2: 4E5E          UNLK       A6
01E4: 4E75          RTS        


; ======= Function at 0x01E6 =======
01E6: 4E560000      LINK       A6,#0
01EA: 42A7          CLR.L      -(A7)
01EC: 2F2E0008      MOVE.L     8(A6),-(A7)
01F0: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
01F4: 202E000C      MOVE.L     12(A6),D0
01F8: D09F          MOVE.B     (A7)+,(A0)
01FA: 206E0008      MOVEA.L    8(A6),A0
01FE: A024          MOVE.L     -(A4),D0
0200: 4A780220      TST.W      $0220.W
0204: 6704          BEQ.S      $020A
0206: 4EAD01A2      JSR        418(A5)                        ; JT[418]
020A: 4E5E          UNLK       A6
020C: 4E75          RTS        


; ======= Function at 0x020E =======
020E: 4E560000      LINK       A6,#0
0212: 2F2E0008      MOVE.L     8(A6),-(A7)
0216: 4267          CLR.W      -(A7)
0218: 2F2E0008      MOVE.L     8(A6),-(A7)
021C: A9607001      MOVE.L     -(A0),28673(A4)
0220: 905F          MOVEA.B    (A7)+,A0
0222: 3F00          MOVE.W     D0,-(A7)
0224: A9634E5E      MOVE.L     -(A3),20062(A4)
0228: 4E75          RTS        


; ======= Function at 0x022A =======
022A: 4E560000      LINK       A6,#0
022E: 206E0008      MOVEA.L    8(A6),A0
0232: A029206E      MOVE.L     8302(A1),D0
0236: 00082010      ORI.B      #$2010,A0
023A: 4E5E          UNLK       A6
023C: 4E75          RTS        

023E: 48E70300      MOVEM.L    D6/D7,-(SP)                    ; save
0242: 2E38016A      MOVE.L     $016A.W,D7
0246: 7C00          MOVEQ      #0,D6
0248: 6002          BRA.S      $024C
024A: 5286          MOVE.B     D6,(A1)
024C: BEB8016A      MOVE.W     $016A.W,(A7)
0250: 67F8          BEQ.S      $024A
0252: 2006          MOVE.L     D6,D0
0254: 4CDF00C0      MOVEM.L    (SP)+,D6/D7                    ; restore
0258: 4E75          RTS        


; ======= Function at 0x025A =======
025A: 4E56FFF8      LINK       A6,#-8                         ; frame=8
025E: 2F0C          MOVE.L     A4,-(A7)
0260: 286E0008      MOVEA.L    8(A6),A4
0264: 200C          MOVE.L     A4,D0
0266: 6758          BEQ.S      $02C0
0268: 2F0C          MOVE.L     A4,-(A7)
026A: A9582054      MOVE.L     (A0)+,8276(A4)
026E: 20680004      MOVEA.L    4(A0),A0
0272: 2D680010FFF8  MOVE.L     16(A0),-8(A6)
0278: 2D680014FFFC  MOVE.L     20(A0),-4(A6)
027E: 486EFFF8      PEA        -8(A6)
0282: 4878FFFF      PEA        $FFFF.W
0286: A8A970F0      MOVE.L     28912(A1),(A4)
028A: D06EFFFE      MOVEA.B    -2(A6),A0
028E: 3D40FFFA      MOVE.W     D0,-6(A6)
0292: 046E000FFFFC  SUBI.W     #$000F,-4(A6)
0298: 2F0C          MOVE.L     A4,-(A7)
029A: 3F2EFFFA      MOVE.W     -6(A6),-(A7)
029E: 3F2EFFF8      MOVE.W     -8(A6),-(A7)
02A2: A9592F0C      MOVE.L     (A1)+,12044(A4)
02A6: 302EFFFE      MOVE.W     -2(A6),D0
02AA: 906EFFFA      MOVEA.B    -6(A6),A0
02AE: 3F00          MOVE.W     D0,-(A7)
02B0: 302EFFFC      MOVE.W     -4(A6),D0
02B4: 906EFFF8      MOVEA.B    -8(A6),A0
02B8: 3F00          MOVE.W     D0,-(A7)
02BA: A95C2F0C      MOVE.L     (A4)+,12044(A4)
02BE: A957285F      MOVE.L     (A7),10335(A4)
02C2: 4E5E          UNLK       A6
02C4: 4E75          RTS        


; ======= Function at 0x02C6 =======
02C6: 4E56FFEC      LINK       A6,#-20                        ; frame=20
02CA: 486EFFF0      PEA        -16(A6)
02CE: A8742F2E      MOVEA.L    46(A4,D2.L*8),A4
02D2: 0008A873      ORI.B      #$A873,A0
02D6: 206E0008      MOVEA.L    8(A6),A0
02DA: 2D680010FFF8  MOVE.L     16(A0),-8(A6)
02E0: 2D680014FFFC  MOVE.L     20(A0),-4(A6)
02E6: 486EFFF8      PEA        -8(A6)
02EA: A870486E      MOVEA.L    110(A0,D4.L),A4
02EE: FFFCA870      MOVE.W     #$A870,???
02F2: 2D6EFFF8FFF4  MOVE.L     -8(A6),-12(A6)
02F8: 302EFFFE      MOVE.W     -2(A6),D0
02FC: B06DFA5C      MOVEA.W    -1444(A5),A0
0300: 6D10          BLT.S      $0312
0302: 302DFA5C      MOVE.W     -1444(A5),D0                   ; A5-1444
0306: 906EFFFE      MOVEA.B    -2(A6),A0
030A: D06EFFFA      MOVEA.B    -6(A6),A0
030E: 3D40FFF6      MOVE.W     D0,-10(A6)
0312: 4A6EFFF6      TST.W      -10(A6)
0316: 6C04          BGE.S      $031C
0318: 426EFFF6      CLR.W      -10(A6)
031C: 302EFFFC      MOVE.W     -4(A6),D0
0320: B06DFA5A      MOVEA.W    -1446(A5),A0
0324: 6D10          BLT.S      $0336
0326: 302DFA5A      MOVE.W     -1446(A5),D0                   ; A5-1446
032A: 906EFFFC      MOVEA.B    -4(A6),A0
032E: D06EFFF8      MOVEA.B    -8(A6),A0
0332: 3D40FFF4      MOVE.W     D0,-12(A6)
0336: 0C6E0014FFF4  CMPI.W     #$0014,-12(A6)
033C: 6C06          BGE.S      $0344
033E: 3D7C0014FFF4  MOVE.W     #$0014,-12(A6)
0344: 302EFFF6      MOVE.W     -10(A6),D0
0348: B06EFFFA      MOVEA.W    -6(A6),A0
034C: 660A          BNE.S      $0358
034E: 302EFFF4      MOVE.W     -12(A6),D0
0352: B06EFFF8      MOVEA.W    -8(A6),A0
0356: 6710          BEQ.S      $0368
0358: 2F2E0008      MOVE.L     8(A6),-(A7)
035C: 3F2EFFF6      MOVE.W     -10(A6),-(A7)
0360: 3F2EFFF4      MOVE.W     -12(A6),-(A7)
0364: 4227          CLR.B      -(A7)
0366: A91B          MOVE.L     (A3)+,-(A4)
0368: 2F2EFFF0      MOVE.L     -16(A6),-(A7)
036C: A8734E5E      MOVEA.L    94(A3,D4.L*8),A4
0370: 4E75          RTS        


; ======= Function at 0x0372 =======
0372: 4E56FFF0      LINK       A6,#-16                        ; frame=16
0376: 4227          CLR.B      -(A7)
0378: 3F3C0008      MOVE.W     #$0008,-(A7)
037C: 486EFFF0      PEA        -16(A6)
0380: A9704A1F673E  MOVE.L     31(A0,D4.L*2),26430(A4)
0386: 082E0000FFFE  BTST       #0,-2(A6)
038C: 6708          BEQ.S      $0396
038E: 0C2E002EFFF5  CMPI.B     #$002E,-11(A6)
0394: 6708          BEQ.S      $039E
0396: 0C2E001BFFF5  CMPI.B     #$001B,-11(A6)
039C: 6626          BNE.S      $03C4
039E: 2B6D93ACA222  MOVE.L     -27732(A5),-24030(A5)          ; A5-27732
03A4: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
03AA: C1EDA386      ANDA.L     -23674(A5),A0
03AE: 41EDA226      LEA        -24026(A5),A0                  ; g_common
03B2: D088          MOVE.B     A0,(A0)
03B4: 2040          MOVEA.L    D0,A0
03B6: 7001          MOVEQ      #1,D0
03B8: 4A40          TST.W      D0
03BA: 6602          BNE.S      $03BE
03BC: 7001          MOVEQ      #1,D0
03BE: 4CD8          DC.W       $4CD8
03C0: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
03C4: 4E5E          UNLK       A6
03C6: 4E75          RTS        


; ======= Function at 0x03C8 =======
03C8: 4E560000      LINK       A6,#0
03CC: 2F0C          MOVE.L     A4,-(A7)
03CE: 42A7          CLR.L      -(A7)
03D0: 3F2E0008      MOVE.W     8(A6),-(A7)
03D4: A9C0A93C42A7  MOVE.L     D0,#$A93C42A7
03DA: 3F3C0080      MOVE.W     #$0080,-(A7)
03DE: A949285F      MOVE.L     A1,10335(A4)
03E2: 200C          MOVE.L     A4,D0
03E4: 6604          BNE.S      $03EA
03E6: 4EAD01A2      JSR        418(A5)                        ; JT[418]
03EA: 2F0C          MOVE.L     A4,-(A7)
03EC: 2F3C44525652  MOVE.L     #$44525652,-(A7)
03F2: A94D285F      MOVE.L     A5,10335(A4)
03F6: 4E5E          UNLK       A6
03F8: 4E75          RTS        


; ======= Function at 0x03FA =======
03FA: 4E560000      LINK       A6,#0
03FE: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
0402: 266E0008      MOVEA.L    8(A6),A3
0406: 3E2E000C      MOVE.W     12(A6),D7
040A: 3C2E000E      MOVE.W     14(A6),D6
040E: 2053          MOVEA.L    (A3),A0
0410: 2F28003E      MOVE.L     62(A0),-(A7)
0414: 4EBAFE14      JSR        -492(PC)
0418: 2840          MOVEA.L    D0,A4
041A: DE46          MOVEA.B    D6,A7
041C: 588F          MOVE.B     A7,(A4)
041E: 6022          BRA.S      $0442
0420: 4227          CLR.B      -(A7)
0422: 2F0C          MOVE.L     A4,-(A7)
0424: 3F07          MOVE.W     D7,-(A7)
0426: 4EBA0316      JSR        790(PC)
042A: 4A1F          TST.B      (A7)+
042C: 6612          BNE.S      $0440
042E: 4227          CLR.B      -(A7)
0430: 2F0C          MOVE.L     A4,-(A7)
0432: 3007          MOVE.W     D7,D0
0434: D046          MOVEA.B    D6,A0
0436: 3F00          MOVE.W     D0,-(A7)
0438: 4EBA0304      JSR        772(PC)
043C: 4A1F          TST.B      (A7)+
043E: 660E          BNE.S      $044E
0440: DE46          MOVEA.B    D6,A7
0442: 4A47          TST.W      D7
0444: 6F08          BLE.S      $044E
0446: 2053          MOVEA.L    (A3),A0
0448: BE68003C      MOVEA.W    60(A0),A7
044C: 6DD2          BLT.S      $0420
044E: 2053          MOVEA.L    (A3),A0
0450: 2068003E      MOVEA.L    62(A0),A0
0454: A02A4A47      MOVE.L     19015(A2),D0
0458: 6C04          BGE.S      $045E
045A: 7000          MOVEQ      #0,D0
045C: 6002          BRA.S      $0460
045E: 3007          MOVE.W     D7,D0
0460: 4CDF18C0      MOVEM.L    (SP)+,D6/D7/A3/A4              ; restore
0464: 4E5E          UNLK       A6
0466: 4E75          RTS        


; ======= Function at 0x0468 =======
0468: 4E560000      LINK       A6,#0
046C: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0470: 266E0008      MOVEA.L    8(A6),A3
0474: 286E000C      MOVEA.L    12(A6),A4
0478: 1E2C0005      MOVE.B     5(A4),D7
047C: 2F0C          MOVE.L     A4,-(A7)
047E: 1F07          MOVE.B     D7,-(A7)
0480: 2F0B          MOVE.L     A3,-(A7)
0482: 4EBA0068      JSR        104(PC)
0486: 4A40          TST.W      D0
0488: 4FEF000A      LEA        10(A7),A7
048C: 6704          BEQ.S      $0492
048E: 7000          MOVEQ      #0,D0
0490: 6052          BRA.S      $04E4
0492: 082C0000000E  BTST       #0,14(A4)
0498: 6704          BEQ.S      $049E
049A: 7000          MOVEQ      #0,D0
049C: 6046          BRA.S      $04E4
049E: 4A6E0010      TST.W      16(A6)
04A2: 6704          BEQ.S      $04A8
04A4: 7000          MOVEQ      #0,D0
04A6: 603C          BRA.S      $04E4
04A8: 0C070009      CMPI.B     #$0009,D7
04AC: 6612          BNE.S      $04C0
04AE: 2F0B          MOVE.L     A3,-(A7)
04B0: A9D7486DF300  MOVE.L     (A7),#$486DF300
04B6: 48780004      PEA        $0004.W
04BA: 2F0B          MOVE.L     A3,-(A7)
04BC: A9DE60220C07  MOVE.L     (A6)+,#$60220C07
04C2: 001B6606      ORI.B      #$6606,(A3)+
04C6: 2F0B          MOVE.L     A3,-(A7)
04C8: A9D760162F0B  MOVE.L     (A7),#$60162F0B
04CE: 1F07          MOVE.B     D7,-(A7)
04D0: 4EBA03AA      JSR        938(PC)
04D4: 1E00          MOVE.B     D0,D7
04D6: 1007          MOVE.B     D7,D0
04D8: 4880          EXT.W      D0
04DA: 3E80          MOVE.W     D0,(A7)
04DC: 2F0B          MOVE.L     A3,-(A7)
04DE: A9DC588F7001  MOVE.L     (A4)+,#$588F7001
04E4: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
04E8: 4E5E          UNLK       A6
04EA: 4E75          RTS        


; ======= Function at 0x04EC =======
04EC: 4E560000      LINK       A6,#0
04F0: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
04F4: 286E0008      MOVEA.L    8(A6),A4
04F8: 0C2E001C000C  CMPI.B     #$001C,12(A6)
04FE: 66000118      BNE.W      $061A
0502: 206E000E      MOVEA.L    14(A6),A0
0506: 3E28000E      MOVE.W     14(A0),D7
050A: 08070009      BTST       #9,D7
050E: 670000B4      BEQ.W      $05C6
0512: 08070008      BTST       #8,D7
0516: 6712          BEQ.S      $052A
0518: 42A7          CLR.L      -(A7)
051A: 2054          MOVEA.L    (A4),A0
051C: 30680022      MOVEA.W    34(A0),A0
0520: 2F08          MOVE.L     A0,-(A7)
0522: 2F0C          MOVE.L     A4,-(A7)
0524: A9D160000096  MOVE.L     (A1),#$60000096
052A: 0807000B      BTST       #11,D7
052E: 6770          BEQ.S      $05A0
0530: 4227          CLR.B      -(A7)
0532: 2054          MOVEA.L    (A4),A0
0534: 2F28003E      MOVE.L     62(A0),-(A7)
0538: 4EBAFCF0      JSR        -784(PC)
053C: 2E80          MOVE.L     D0,(A7)
053E: 2054          MOVEA.L    (A4),A0
0540: 3F280022      MOVE.W     34(A0),-(A7)
0544: 4EBA01F8      JSR        504(PC)
0548: 4A1F          TST.B      (A7)+
054A: 6626          BNE.S      $0572
054C: 3F3C0001      MOVE.W     #$0001,-(A7)
0550: 2054          MOVEA.L    (A4),A0
0552: 3F280022      MOVE.W     34(A0),-(A7)
0556: 2F0C          MOVE.L     A4,-(A7)
0558: 4EBAFEA0      JSR        -352(PC)
055C: 5240          MOVEA.B    D0,A1
055E: 3E00          MOVE.W     D0,D7
0560: 2054          MOVEA.L    (A4),A0
0562: 30680020      MOVEA.W    32(A0),A0
0566: 2E88          MOVE.L     A0,(A7)
0568: 3047          MOVEA.W    D7,A0
056A: 2F08          MOVE.L     A0,-(A7)
056C: 2F0C          MOVE.L     A4,-(A7)
056E: A9D1588F2054  MOVE.L     (A1),#$588F2054
0574: 2068003E      MOVEA.L    62(A0),A0
0578: A02A3F3C      MOVE.L     16188(A2),D0
057C: FFFF          MOVE.W     ???,???
057E: 2054          MOVEA.L    (A4),A0
0580: 3F280020      MOVE.W     32(A0),-(A7)
0584: 2F0C          MOVE.L     A4,-(A7)
0586: 4EBAFE72      JSR        -398(PC)
058A: 3E00          MOVE.W     D0,D7
058C: 3047          MOVEA.W    D7,A0
058E: 2E88          MOVE.L     A0,(A7)
0590: 2054          MOVEA.L    (A4),A0
0592: 30680022      MOVEA.W    34(A0),A0
0596: 2F08          MOVE.L     A0,-(A7)
0598: 2F0C          MOVE.L     A4,-(A7)
059A: A9D1588F601E  MOVE.L     (A1),#$588F601E
05A0: 2054          MOVEA.L    (A4),A0
05A2: 4A680020      TST.W      32(A0)
05A6: 6716          BEQ.S      $05BE
05A8: 2054          MOVEA.L    (A4),A0
05AA: 30680020      MOVEA.W    32(A0),A0
05AE: 4868FFFF      PEA        -1(A0)
05B2: 2054          MOVEA.L    (A4),A0
05B4: 30680022      MOVEA.W    34(A0),A0
05B8: 2F08          MOVE.L     A0,-(A7)
05BA: 2F0C          MOVE.L     A4,-(A7)
05BC: A9D170016000  MOVE.L     (A1),#$70016000
05C2: 01720807      BCHG       D0,7(A2,D0.L)
05C6: 0008670C      ORI.B      #$670C,A0
05CA: 42A7          CLR.L      -(A7)
05CC: 42A7          CLR.L      -(A7)
05CE: 2F0C          MOVE.L     A4,-(A7)
05D0: A9D16000015E  MOVE.L     (A1),#$6000015E
05D6: 0807000B      BTST       #11,D7
05DA: 6724          BEQ.S      $0600
05DC: 3F3CFFFF      MOVE.W     #$FFFF,-(A7)
05E0: 2054          MOVEA.L    (A4),A0
05E2: 3F280020      MOVE.W     32(A0),-(A7)
05E6: 2F0C          MOVE.L     A4,-(A7)
05E8: 4EBAFE10      JSR        -496(PC)
05EC: 3E00          MOVE.W     D0,D7
05EE: 3047          MOVEA.W    D7,A0
05F0: 2E88          MOVE.L     A0,(A7)
05F2: 3047          MOVEA.W    D7,A0
05F4: 2F08          MOVE.L     A0,-(A7)
05F6: 2F0C          MOVE.L     A4,-(A7)
05F8: A9D170016000  MOVE.L     (A1),#$70016000
05FE: 01362054      BTST       D0,84(A6,D2.W)
0602: 30680020      MOVEA.W    32(A0),A0
0606: 2F08          MOVE.L     A0,-(A7)
0608: 2054          MOVEA.L    (A4),A0
060A: 30680020      MOVEA.W    32(A0),A0
060E: 2F08          MOVE.L     A0,-(A7)
0610: 2F0C          MOVE.L     A4,-(A7)
0612: A9D16000011C  MOVE.L     (A1),#$6000011C
0618: 0C2E001D000C  CMPI.B     #$001D,12(A6)
061E: 66000112      BNE.W      $0734
0622: 206E000E      MOVEA.L    14(A6),A0
0626: 3E28000E      MOVE.W     14(A0),D7
062A: 08070009      BTST       #9,D7
062E: 670000B0      BEQ.W      $06E2
0632: 08070008      BTST       #8,D7
0636: 6714          BEQ.S      $064C
0638: 2054          MOVEA.L    (A4),A0
063A: 30680020      MOVEA.W    32(A0),A0
063E: 2F08          MOVE.L     A0,-(A7)
0640: 48787FFF      PEA        $7FFF.W
0644: 2F0C          MOVE.L     A4,-(A7)
0646: A9D160000092  MOVE.L     (A1),#$60000092
064C: 0807000B      BTST       #11,D7
0650: 6774          BEQ.S      $06C6
0652: 4227          CLR.B      -(A7)
0654: 2054          MOVEA.L    (A4),A0
0656: 2F28003E      MOVE.L     62(A0),-(A7)
065A: 4EBAFBCE      JSR        -1074(PC)
065E: 2E80          MOVE.L     D0,(A7)
0660: 2054          MOVEA.L    (A4),A0
0662: 70FF          MOVEQ      #-1,D0
0664: D0680020      MOVEA.B    32(A0),A0
0668: 3F00          MOVE.W     D0,-(A7)
066A: 4EBA00D2      JSR        210(PC)
066E: 4A1F          TST.B      (A7)+
0670: 6624          BNE.S      $0696
0672: 3F3CFFFF      MOVE.W     #$FFFF,-(A7)
0676: 2054          MOVEA.L    (A4),A0
0678: 3F280020      MOVE.W     32(A0),-(A7)
067C: 2F0C          MOVE.L     A4,-(A7)
067E: 4EBAFD7A      JSR        -646(PC)
0682: 3E00          MOVE.W     D0,D7
0684: 3047          MOVEA.W    D7,A0
0686: 2E88          MOVE.L     A0,(A7)
0688: 2054          MOVEA.L    (A4),A0
068A: 30680022      MOVEA.W    34(A0),A0
068E: 2F08          MOVE.L     A0,-(A7)
0690: 2F0C          MOVE.L     A4,-(A7)
0692: A9D1588F2054  MOVE.L     (A1),#$588F2054
0698: 2068003E      MOVEA.L    62(A0),A0
069C: A02A3F3C      MOVE.L     16188(A2),D0
06A0: 00012054      ORI.B      #$2054,D1
06A4: 3F280022      MOVE.W     34(A0),-(A7)
06A8: 2F0C          MOVE.L     A4,-(A7)
06AA: 4EBAFD4E      JSR        -690(PC)
06AE: 5240          MOVEA.B    D0,A1
06B0: 3E00          MOVE.W     D0,D7
06B2: 2054          MOVEA.L    (A4),A0
06B4: 30680020      MOVEA.W    32(A0),A0
06B8: 2E88          MOVE.L     A0,(A7)
06BA: 3047          MOVEA.W    D7,A0
06BC: 2F08          MOVE.L     A0,-(A7)
06BE: 2F0C          MOVE.L     A4,-(A7)
06C0: A9D1588F6016  MOVE.L     (A1),#$588F6016
06C6: 2054          MOVEA.L    (A4),A0
06C8: 30680020      MOVEA.W    32(A0),A0
06CC: 2F08          MOVE.L     A0,-(A7)
06CE: 2054          MOVEA.L    (A4),A0
06D0: 30680022      MOVEA.W    34(A0),A0
06D4: 48680001      PEA        1(A0)
06D8: 2F0C          MOVE.L     A4,-(A7)
06DA: A9D170016054  MOVE.L     (A1),#$70016054
06E0: 08070008      BTST       #8,D7
06E4: 670E          BEQ.S      $06F4
06E6: 48787FFF      PEA        $7FFF.W
06EA: 48787FFF      PEA        $7FFF.W
06EE: 2F0C          MOVE.L     A4,-(A7)
06F0: A9D1603E0807  MOVE.L     (A1),#$603E0807
06F6: 000B6724      ORI.B      #$6724,A3
06FA: 3F3C0001      MOVE.W     #$0001,-(A7)
06FE: 2054          MOVEA.L    (A4),A0
0700: 3F280022      MOVE.W     34(A0),-(A7)
0704: 2F0C          MOVE.L     A4,-(A7)
0706: 4EBAFCF2      JSR        -782(PC)
070A: 5240          MOVEA.B    D0,A1
070C: 3E00          MOVE.W     D0,D7
070E: 3047          MOVEA.W    D7,A0
0710: 2E88          MOVE.L     A0,(A7)
0712: 3047          MOVEA.W    D7,A0
0714: 2F08          MOVE.L     A0,-(A7)
0716: 2F0C          MOVE.L     A4,-(A7)
0718: A9D170016016  MOVE.L     (A1),#$70016016
071E: 2054          MOVEA.L    (A4),A0
0720: 30680022      MOVEA.W    34(A0),A0
0724: 2F08          MOVE.L     A0,-(A7)
0726: 2054          MOVEA.L    (A4),A0
0728: 30680022      MOVEA.W    34(A0),A0
072C: 2F08          MOVE.L     A0,-(A7)
072E: 2F0C          MOVE.L     A4,-(A7)
0730: A9D170004CEE  MOVE.L     (A1),#$70004CEE
0736: 1080          MOVE.B     D0,(A0)
0738: FFF84E5E      MOVE.W     $4E5E.W,???
073C: 4E75          RTS        


; ======= Function at 0x073E =======
073E: 4E560000      LINK       A6,#0
0742: 48E70708      MOVEM.L    D5/D6/D7/A4,-(SP)              ; save
0746: 286E000A      MOVEA.L    10(A6),A4
074A: 3C2E0008      MOVE.W     8(A6),D6
074E: 1E346000      MOVE.B     0(A4,D6.W),D7
0752: 42A7          CLR.L      -(A7)
0754: 2F0C          MOVE.L     A4,-(A7)
0756: 4EAD0B02      JSR        2818(A5)                       ; JT[2818]
075A: 3046          MOVEA.W    D6,A0
075C: B1DF6608      MOVE.W     (A7)+,$6608.W
0760: 422E000E      CLR.B      14(A6)
0764: 6000010A      BRA.W      $0872
0768: 7000          MOVEQ      #0,D0
076A: 1007          MOVE.B     D7,D0
076C: 204D          MOVEA.L    A5,A0
076E: D1C01A28      MOVE.B     D0,$1A28.W
0772: FBD8          MOVE.W     (A0)+,???
0774: 4885          EXT.W      D5
0776: 3005          MOVE.W     D5,D0
0778: 024000C0      ANDI.W     #$00C0,D0
077C: 6606          BNE.S      $0784
077E: 08050004      BTST       #4,D5
0782: 6708          BEQ.S      $078C
0784: 422E000E      CLR.B      14(A6)
0788: 600000E6      BRA.W      $0872
078C: 0C0700CA      CMPI.B     #$00CA,D7
0790: 6724          BEQ.S      $07B6
0792: 0C070024      CMPI.B     #$0024,D7
0796: 671E          BEQ.S      $07B6
0798: 0C0700A2      CMPI.B     #$00A2,D7
079C: 6718          BEQ.S      $07B6
079E: 0C0700A3      CMPI.B     #$00A3,D7
07A2: 6712          BEQ.S      $07B6
07A4: 0C0700B4      CMPI.B     #$00B4,D7
07A8: 670C          BEQ.S      $07B6
07AA: 0C070025      CMPI.B     #$0025,D7
07AE: 6706          BEQ.S      $07B6
07B0: 0C07002D      CMPI.B     #$002D,D7
07B4: 6608          BNE.S      $07BE
07B6: 422E000E      CLR.B      14(A6)
07BA: 600000B4      BRA.W      $0872
07BE: 0C07002C      CMPI.B     #$002C,D7
07C2: 6632          BNE.S      $07F6
07C4: 4A46          TST.W      D6
07C6: 6F0000A2      BLE.W      $086C
07CA: 7000          MOVEQ      #0,D0
07CC: 103460FF      MOVE.B     -1(A4,D6.W),D0
07D0: 204D          MOVEA.L    A5,A0
07D2: D1C00828      MOVE.B     D0,$0828.W
07D6: 0004FBD8      ORI.B      #$FBD8,D4
07DA: 6700008E      BEQ.W      $086C
07DE: 7000          MOVEQ      #0,D0
07E0: 10346001      MOVE.B     1(A4,D6.W),D0
07E4: 204D          MOVEA.L    A5,A0
07E6: D1C00828      MOVE.B     D0,$0828.W
07EA: 0004FBD8      ORI.B      #$FBD8,D4
07EE: 677A          BEQ.S      $086A
07F0: 422E000E      CLR.B      14(A6)
07F4: 607A          BRA.S      $0870
07F6: 0C07002E      CMPI.B     #$002E,D7
07FA: 6618          BNE.S      $0814
07FC: 7000          MOVEQ      #0,D0
07FE: 10346001      MOVE.B     1(A4,D6.W),D0
0802: 204D          MOVEA.L    A5,A0
0804: D1C00828      MOVE.B     D0,$0828.W
0808: 0004FBD8      ORI.B      #$FBD8,D4
080C: 675C          BEQ.S      $086A
080E: 422E000E      CLR.B      14(A6)
0812: 605C          BRA.S      $0870
0814: 0C070027      CMPI.B     #$0027,D7
0818: 6706          BEQ.S      $0820
081A: 0C0700D5      CMPI.B     #$00D5,D7
081E: 664A          BNE.S      $086A
0820: 4A46          TST.W      D6
0822: 6F46          BLE.S      $086A
0824: 1E3460FF      MOVE.B     -1(A4,D6.W),D7
0828: 7000          MOVEQ      #0,D0
082A: 1007          MOVE.B     D7,D0
082C: 204D          MOVEA.L    A5,A0
082E: D1C01A28      MOVE.B     D0,$1A28.W
0832: FBD8          MOVE.W     (A0)+,???
0834: 4885          EXT.W      D5
0836: 3005          MOVE.W     D5,D0
0838: 024000C0      ANDI.W     #$00C0,D0
083C: 6606          BNE.S      $0844
083E: 08050004      BTST       #4,D5
0842: 6726          BEQ.S      $086A
0844: 1E346001      MOVE.B     1(A4,D6.W),D7
0848: 7000          MOVEQ      #0,D0
084A: 1007          MOVE.B     D7,D0
084C: 204D          MOVEA.L    A5,A0
084E: D1C01C28      MOVE.B     D0,$1C28.W
0852: FBD8          MOVE.W     (A0)+,???
0854: 4886          EXT.W      D6
0856: 3006          MOVE.W     D6,D0
0858: 024000C0      ANDI.W     #$00C0,D0
085C: 6606          BNE.S      $0864
085E: 08060004      BTST       #4,D6
0862: 6706          BEQ.S      $086A
0864: 422E000E      CLR.B      14(A6)
0868: 6006          BRA.S      $0870
086A: 1D7C0001000E  MOVE.B     #$01,14(A6)
0870: 4CDF10E0      MOVEM.L    (SP)+,D5/D6/D7/A4              ; restore
0874: 4E5E          UNLK       A6
0876: 205F          MOVEA.L    (A7)+,A0
0878: 5C8F          MOVE.B     A7,(A6)
087A: 4ED0          JMP        (A0)

; ======= Function at 0x087C =======
087C: 4E560000      LINK       A6,#0
0880: 48E70708      MOVEM.L    D5/D6/D7/A4,-(SP)              ; save
0884: 1E2E0008      MOVE.B     8(A6),D7
0888: 0C070022      CMPI.B     #$0022,D7
088C: 670A          BEQ.S      $0898
088E: 0C070027      CMPI.B     #$0027,D7
0892: 6704          BEQ.S      $0898
0894: 1007          MOVE.B     D7,D0
0896: 607A          BRA.S      $0912
0898: 206E000A      MOVEA.L    10(A6),A0
089C: 2850          MOVEA.L    (A0),A4
089E: 3C2C0020      MOVE.W     32(A4),D6
08A2: 226C003E      MOVEA.L    62(A4),A1
08A6: 2251          MOVEA.L    (A1),A1
08A8: 1A3160FF      MOVE.B     -1(A1,D6.W),D5
08AC: 4885          EXT.W      D5
08AE: 4A46          TST.W      D6
08B0: 6746          BEQ.S      $08F8
08B2: 7000          MOVEQ      #0,D0
08B4: 1005          MOVE.B     D5,D0
08B6: 204D          MOVEA.L    A5,A0
08B8: D1C07006      MOVE.B     D0,$7006.W
08BC: C028FBD8      AND.B      -1064(A0),D0
08C0: 6636          BNE.S      $08F8
08C2: 0C450028      CMPI.W     #$0028,D5
08C6: 6730          BEQ.S      $08F8
08C8: 0C45005B      CMPI.W     #$005B,D5
08CC: 672A          BEQ.S      $08F8
08CE: 0C45007B      CMPI.W     #$007B,D5
08D2: 6724          BEQ.S      $08F8
08D4: 0C45003C      CMPI.W     #$003C,D5
08D8: 671E          BEQ.S      $08F8
08DA: 0C45FFCA      CMPI.W     #$FFCA,D5
08DE: 6718          BEQ.S      $08F8
08E0: 0C45FFD2      CMPI.W     #$FFD2,D5
08E4: 6606          BNE.S      $08EC
08E6: 0C070027      CMPI.B     #$0027,D7
08EA: 670C          BEQ.S      $08F8
08EC: 0C45FFD4      CMPI.W     #$FFD4,D5
08F0: 6614          BNE.S      $0906
08F2: 0C070022      CMPI.B     #$0022,D7
08F6: 660E          BNE.S      $0906
08F8: 0C070022      CMPI.B     #$0022,D7
08FC: 6604          BNE.S      $0902
08FE: 70D2          MOVEQ      #-46,D0
0900: 6010          BRA.S      $0912
0902: 70D4          MOVEQ      #-44,D0
0904: 600C          BRA.S      $0912
0906: 0C070022      CMPI.B     #$0022,D7
090A: 6604          BNE.S      $0910
090C: 70D3          MOVEQ      #-45,D0
090E: 6002          BRA.S      $0912
0910: 70D5          MOVEQ      #-43,D0
0912: 4CDF10E0      MOVEM.L    (SP)+,D5/D6/D7/A4              ; restore
0916: 4E5E          UNLK       A6
0918: 4E75          RTS        


; ======= Function at 0x091A =======
091A: 4E56FE5E      LINK       A6,#-418                       ; frame=418
091E: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0922: 286E000C      MOVEA.L    12(A6),A4
0926: 4267          CLR.W      -(A7)
0928: 486EFF00      PEA        -256(A6)
092C: 2F0C          MOVE.L     A4,-(A7)
092E: 4EAD0B42      JSR        2882(A5)                       ; JT[2882]
0932: 4878006C      PEA        $006C.W
0936: 486EFE92      PEA        -366(A6)
093A: 4EAD01AA      JSR        426(A5)                        ; JT[426]
093E: 2D6E0008FEA4  MOVE.L     8(A6),-348(A6)
0944: 3D54FEA8      MOVE.W     (A4),-344(A6)
0948: 4257          CLR.W      (A7)
094A: 486EFE92      PEA        -366(A6)
094E: 4227          CLR.B      -(A7)
0950: 4EAD0B7A      JSR        2938(A5)                       ; JT[2938]
0954: 206E0010      MOVEA.L    16(A6),A0
0958: 20AEFEC2      MOVE.L     -318(A6),(A0)
095C: 7034          MOVEQ      #52,D0
095E: 2E80          MOVE.L     D0,(A7)
0960: 486EFE5E      PEA        -418(A6)
0964: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0968: 48780100      PEA        $0100.W
096C: 486EFF00      PEA        -256(A6)
0970: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0974: 41EEFF00      LEA        -256(A6),A0
0978: 2D48FE70      MOVE.L     A0,-400(A6)
097C: 3D54FE74      MOVE.W     (A4),-396(A6)
0980: 4257          CLR.W      (A7)
0982: 486EFE5E      PEA        -418(A6)
0986: 4227          CLR.B      -(A7)
0988: 4EAD0B72      JSR        2930(A5)                       ; JT[2930]
098C: 3E1F          MOVE.W     (A7)+,D7
098E: 4A47          TST.W      D7
0990: 4FEF0014      LEA        20(A7),A7
0994: 6704          BEQ.S      $099A
0996: 4EAD01A2      JSR        418(A5)                        ; JT[418]
099A: 38AEFE7E      MOVE.W     -386(A6),(A4)
099E: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
09A2: 4E5E          UNLK       A6
09A4: 4E75          RTS        


; ======= Function at 0x09A6 =======
09A6: 4E560000      LINK       A6,#0
09AA: 48E70718      MOVEM.L    D5/D6/D7/A3/A4,-(SP)           ; save
09AE: 266E0008      MOVEA.L    8(A6),A3
09B2: 49EB0006      LEA        6(A3),A4
09B6: 3E14          MOVE.W     (A4),D7
09B8: 9E6B0002      MOVEA.B    2(A3),A7
09BC: 3C2B0004      MOVE.W     4(A3),D6
09C0: 9C53          MOVEA.B    (A3),A6
09C2: 302DFA5C      MOVE.W     -1444(A5),D0                   ; A5-1444
09C6: 906B0002      MOVEA.B    2(A3),A0
09CA: 9054          MOVEA.B    (A4),A0
09CC: 48C0          EXT.L      D0
09CE: 81FC0002D16B  ORA.L      #$0002D16B,A0
09D4: 0002302D      ORI.B      #$302D,D2
09D8: FA5A          MOVEA.W    (A2)+,A5
09DA: 9053          MOVEA.B    (A3),A0
09DC: 906B0004      MOVEA.B    4(A3),A0
09E0: 48C0          EXT.L      D0
09E2: 81FC0002D153  ORA.L      #$0002D153,A0
09E8: 302DFA5A      MOVE.W     -1446(A5),D0                   ; A5-1446
09EC: 48C0          EXT.L      D0
09EE: 81FC00069153  ORA.L      #$00069153,A0
09F4: 7A1C          MOVEQ      #28,D5
09F6: DA780BAA      MOVEA.B    $0BAA.W,A5
09FA: BA53          MOVEA.W    (A3),A5
09FC: 6F02          BLE.S      $0A00
09FE: 3685          MOVE.W     D5,(A3)
0A00: 302B0002      MOVE.W     2(A3),D0
0A04: D047          MOVEA.B    D7,A0
0A06: 3880          MOVE.W     D0,(A4)
0A08: 3013          MOVE.W     (A3),D0
0A0A: D046          MOVEA.B    D6,A0
0A0C: 37400004      MOVE.W     D0,4(A3)
0A10: 4CDF18E0      MOVEM.L    (SP)+,D5/D6/D7/A3/A4           ; restore
0A14: 4E5E          UNLK       A6
0A16: 4E75          RTS        


; ======= Function at 0x0A18 =======
0A18: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0A1C: 48E70738      MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)        ; save
0A20: 2C2E0008      MOVE.L     8(A6),D6
0A24: 266E000E      MOVEA.L    14(A6),A3
0A28: 42A7          CLR.L      -(A7)
0A2A: 2F06          MOVE.L     D6,-(A7)
0A2C: 3F2E000C      MOVE.W     12(A6),-(A7)
0A30: A9A0285F      MOVE.L     -(A0),95(A4,D2.L)
0A34: 200C          MOVE.L     A4,D0
0A36: 6604          BNE.S      $0A3C
0A38: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0A3C: 204C          MOVEA.L    A4,A0
0A3E: A0290C86      MOVE.L     3206(A1),D0
0A42: 444C          NEG.W      A4
0A44: 4F47          DC.W       $4F47
0A46: 660E          BNE.S      $0A56
0A48: 2054          MOVEA.L    (A4),A0
0A4A: 2690          MOVE.L     (A0),(A3)
0A4C: 276800040004  MOVE.L     4(A0),4(A3)
0A52: 600000AE      BRA.W      $0B04
0A56: 0C864449544C  CMPI.L     #$4449544C,D6
0A5C: 66000094      BNE.W      $0AF4
0A60: 2454          MOVEA.L    (A4),A2
0A62: 3C12          MOVE.W     (A2),D6
0A64: 2E0A          MOVE.L     A2,D7
0A66: 5487          MOVE.B     D7,(A2)
0A68: 48780008      PEA        $0008.W
0A6C: 2F0B          MOVE.L     A3,-(A7)
0A6E: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0A72: 303C7FFF      MOVE.W     #$7FFF,D0
0A76: 37400002      MOVE.W     D0,2(A3)
0A7A: 3680          MOVE.W     D0,(A3)
0A7C: 7A00          MOVEQ      #0,D5
0A7E: 508F          MOVE.B     A7,(A0)
0A80: 6056          BRA.S      $0AD8
0A82: 5887          MOVE.B     D7,(A4)
0A84: 2447          MOVEA.L    D7,A2
0A86: 302A0006      MOVE.W     6(A2),D0
0A8A: B06B0006      MOVEA.W    6(A3),A0
0A8E: 6F06          BLE.S      $0A96
0A90: 376A00060006  MOVE.W     6(A2),6(A3)
0A96: 302A0004      MOVE.W     4(A2),D0
0A9A: B06B0004      MOVEA.W    4(A3),A0
0A9E: 6F06          BLE.S      $0AA6
0AA0: 376A00040004  MOVE.W     4(A2),4(A3)
0AA6: 3012          MOVE.W     (A2),D0
0AA8: B053          MOVEA.W    (A3),A0
0AAA: 6C02          BGE.S      $0AAE
0AAC: 3692          MOVE.W     (A2),(A3)
0AAE: 302A0002      MOVE.W     2(A2),D0
0AB2: B06B0002      MOVEA.W    2(A3),A0
0AB6: 6C06          BGE.S      $0ABE
0AB8: 376A00020002  MOVE.W     2(A2),2(A3)
0ABE: 5087          MOVE.B     D7,(A0)
0AC0: 5287          MOVE.B     D7,(A1)
0AC2: 2047          MOVEA.L    D7,A0
0AC4: 7000          MOVEQ      #0,D0
0AC6: 1010          MOVE.B     (A0),D0
0AC8: 5240          MOVEA.B    D0,A1
0ACA: 3040          MOVEA.W    D0,A0
0ACC: DE88          MOVE.B     A0,(A7)
0ACE: 08070000      BTST       #0,D7
0AD2: 6702          BEQ.S      $0AD6
0AD4: 5287          MOVE.B     D7,(A1)
0AD6: 5245          MOVEA.B    D5,A1
0AD8: BC45          MOVEA.W    D5,A6
0ADA: 6CA6          BGE.S      $0A82
0ADC: 3013          MOVE.W     (A3),D0
0ADE: D16B00044253  MOVE.B     4(A3),16979(A0)
0AE4: 302B0002      MOVE.W     2(A3),D0
0AE8: D16B0006426B  MOVE.B     6(A3),17003(A0)
0AEE: 00026010      ORI.B      #$6010,D2
0AF2: 0C86414C5254  CMPI.L     #$414C5254,D6
0AF8: 6604          BNE.S      $0AFE
0AFA: 2654          MOVEA.L    (A4),A3
0AFC: 6004          BRA.S      $0B02
0AFE: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0B02: 2D4CFFFC      MOVE.L     A4,-4(A6)
0B06: 4267          CLR.W      -(A7)
0B08: 486EFFFC      PEA        -4(A6)
0B0C: 4EAD0BA2      JSR        2978(A5)                       ; JT[2978]
0B10: 3C1F          MOVE.W     (A7)+,D6
0B12: 4A46          TST.W      D6
0B14: 6704          BEQ.S      $0B1A
0B16: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0B1A: 204C          MOVEA.L    A4,A0
0B1C: A02A2F0C      MOVE.L     12044(A2),D0
0B20: A9A3286E      MOVE.L     -(A3),110(A4,D2.L)
0B24: FFFC204C      MOVE.W     #$204C,???
0B28: A0292F0B      MOVE.L     12043(A1),D0
0B2C: 4EBAFE78      JSR        -392(PC)
0B30: 204C          MOVEA.L    A4,A0
0B32: A02A200C      MOVE.L     8204(A2),D0
0B36: 4CEE1CE0FFE4  MOVEM.L    -28(A6),D5/D6/D7/A2/A3/A4
0B3C: 4E5E          UNLK       A6
0B3E: 4E75          RTS        


; ======= Function at 0x0B40 =======
0B40: 4E56FFF8      LINK       A6,#-8                         ; frame=8
0B44: 2F0C          MOVE.L     A4,-(A7)
0B46: 486EFFF8      PEA        -8(A6)
0B4A: 3F2E000C      MOVE.W     12(A6),-(A7)
0B4E: 2F3C444C4F47  MOVE.L     #$444C4F47,-(A7)
0B54: 4EBAFEC2      JSR        -318(PC)
0B58: 2840          MOVEA.L    D0,A4
0B5A: 200C          MOVE.L     A4,D0
0B5C: 4FEF000A      LEA        10(A7),A7
0B60: 6604          BNE.S      $0B66
0B62: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0B66: 2F2E0008      MOVE.L     8(A6),-(A7)
0B6A: 3F2EFFFA      MOVE.W     -6(A6),-(A7)
0B6E: 3F2EFFF8      MOVE.W     -8(A6),-(A7)
0B72: A880          MOVE.L     D0,(A4)
0B74: 204C          MOVEA.L    A4,A0
0B76: A023          MOVE.L     -(A3),D0
0B78: 285F          MOVEA.L    (A7)+,A4
0B7A: 4E5E          UNLK       A6
0B7C: 4E75          RTS        


; ======= Function at 0x0B7E =======
0B7E: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0B82: 2F0C          MOVE.L     A4,-(A7)
0B84: 286E0008      MOVEA.L    8(A6),A4
0B88: 4A14          TST.B      (A4)
0B8A: 670E          BEQ.S      $0B9A
0B8C: 486C000A      PEA        10(A4)
0B90: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0B94: 5580588F      MOVE.B     D0,-113(A2,D5.L)
0B98: 6456          BCC.S      $0BF0
0B9A: 4AAE000C      TST.L      12(A6)
0B9E: 672C          BEQ.S      $0BCC
0BA0: 3F3CF060      MOVE.W     #$F060,-(A7)
0BA4: 486EFFFC      PEA        -4(A6)
0BA8: 4EBAFF96      JSR        -106(PC)
0BAC: 2EAEFFFC      MOVE.L     -4(A6),(A7)
0BB0: 2F2DF248      MOVE.L     -3512(A5),-(A7)                ; A5-3512
0BB4: 42A7          CLR.L      -(A7)
0BB6: 3F2E0010      MOVE.W     16(A6),-(A7)
0BBA: 2F2E000C      MOVE.L     12(A6),-(A7)
0BBE: 42A7          CLR.L      -(A7)
0BC0: 2F0C          MOVE.L     A4,-(A7)
0BC2: 3F3C0002      MOVE.W     #$0002,-(A7)
0BC6: A9EA548F60243F3C  MOVE.L     21647(A2),#$60243F3C
0BCE: F061          MOVEA.W    -(A1),A0
0BD0: 486EFFFC      PEA        -4(A6)
0BD4: 4EBAFF6A      JSR        -150(PC)
0BD8: 2EAEFFFC      MOVE.L     -4(A6),(A7)
0BDC: 2F2DF24C      MOVE.L     -3508(A5),-(A7)                ; A5-3508
0BE0: 486C000A      PEA        10(A4)
0BE4: 42A7          CLR.L      -(A7)
0BE6: 2F0C          MOVE.L     A4,-(A7)
0BE8: 3F3C0001      MOVE.W     #$0001,-(A7)
0BEC: A9EA548F70001014  MOVE.L     21647(A2),#$70001014
0BF4: 285F          MOVEA.L    (A7)+,A4
0BF6: 4E5E          UNLK       A6
0BF8: 4E75          RTS        


; ======= Function at 0x0BFA =======
0BFA: 4E56FFF8      LINK       A6,#-8                         ; frame=8
0BFE: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0C02: 286E0008      MOVEA.L    8(A6),A4
0C06: 2F0C          MOVE.L     A4,-(A7)
0C08: 4EAD0D6A      JSR        3434(A5)                       ; JT[3434]
0C0C: 2E00          MOVE.L     D0,D7
0C0E: 08070006      BTST       #6,D7
0C12: 588F          MOVE.B     A7,(A4)
0C14: 663C          BNE.S      $0C52
0C16: 08070001      BTST       #1,D7
0C1A: 6636          BNE.S      $0C52
0C1C: 2F0C          MOVE.L     A4,-(A7)
0C1E: A8732D6C      MOVEA.L    108(A3,D2.L*4),A4
0C22: 0010FFF8      ORI.B      #$FFF8,(A0)
0C26: 2D6C0014FFFC  MOVE.L     20(A4),-4(A6)
0C2C: 70F1          MOVEQ      #-15,D0
0C2E: D06EFFFE      MOVEA.B    -2(A6),A0
0C32: 3D40FFFA      MOVE.W     D0,-6(A6)
0C36: 42A7          CLR.L      -(A7)
0C38: A8D8          MOVE.L     (A0)+,(A4)+
0C3A: 265F          MOVEA.L    (A7)+,A3
0C3C: 2F0B          MOVE.L     A3,-(A7)
0C3E: A87A486E      MOVEA.L    18542(PC),A4
0C42: FFF8A87B      MOVE.W     $A87B.W,???
0C46: 2F0C          MOVE.L     A4,-(A7)
0C48: A904          MOVE.L     D4,-(A4)
0C4A: 2F0B          MOVE.L     A3,-(A7)
0C4C: A8792F0BA8D9  MOVEA.L    $2F0BA8D9,A4
0C52: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
0C56: 4E5E          UNLK       A6
0C58: 4E75          RTS        

0C5A: 42A7          CLR.L      -(A7)
0C5C: A9F9205F302DF274B068  MOVE.L     $205F302D,#$F274B068
0C66: 00086714      ORI.B      #$6714,A0
0C6A: 4267          CLR.W      -(A7)
0C6C: 4EAD0BCA      JSR        3018(A5)                       ; JT[3018]
0C70: 42A7          CLR.L      -(A7)
0C72: A9F9205F3B680008F274  MOVE.L     $205F3B68,#$0008F274
0C7C: 548F          MOVE.B     A7,(A2)
0C7E: 4E75          RTS        

0C80: 4A6DF276      TST.W      -3466(A5)
0C84: 6716          BEQ.S      $0C9C
0C86: 42A7          CLR.L      -(A7)
0C88: A9FC201F3B40F2744267  MOVE.L     #$201F3B40,#$F2744267
0C92: 4EAD0BD2      JSR        3026(A5)                       ; JT[3026]
0C96: 426DF276      CLR.W      -3466(A5)
0C9A: 548F          MOVE.B     A7,(A2)
0C9C: 4E75          RTS        


; ======= Function at 0x0C9E =======
0C9E: 4E56FDFC      LINK       A6,#-516                       ; frame=516
0CA2: 2F07          MOVE.L     D7,-(A7)
0CA4: 48780200      PEA        $0200.W
0CA8: 486EFE00      PEA        -512(A6)
0CAC: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0CB0: 508F          MOVE.B     A7,(A0)
0CB2: 601A          BRA.S      $0CCE
0CB4: 206E0010      MOVEA.L    16(A6),A0
0CB8: 52AE0010      MOVE.B     16(A6),(A1)
0CBC: 7000          MOVEQ      #0,D0
0CBE: 1010          MOVE.B     (A0),D0
0CC0: 4880          EXT.W      D0
0CC2: 204E          MOVEA.L    A6,A0
0CC4: D1C0D1C0      MOVE.B     D0,$D1C0.W
0CC8: 317C0001FE00  MOVE.W     #$0001,-512(A0)
0CCE: 206E0010      MOVEA.L    16(A6),A0
0CD2: 4A10          TST.B      (A0)
0CD4: 66DE          BNE.S      $0CB4
0CD6: 7E00          MOVEQ      #0,D7
0CD8: 6022          BRA.S      $0CFC
0CDA: 206E000C      MOVEA.L    12(A6),A0
0CDE: 7000          MOVEQ      #0,D0
0CE0: 1010          MOVE.B     (A0),D0
0CE2: 4880          EXT.W      D0
0CE4: 224E          MOVEA.L    A6,A1
0CE6: D3C0D3C04A69  MOVE.B     D0,$D3C04A69
0CEC: FE00          MOVE.W     D0,D7
0CEE: 6706          BEQ.S      $0CF6
0CF0: 52AE000C      MOVE.B     12(A6),(A1)
0CF4: 6002          BRA.S      $0CF8
0CF6: 7E01          MOVEQ      #1,D7
0CF8: 52AE0008      MOVE.B     8(A6),(A1)
0CFC: 206E0008      MOVEA.L    8(A6),A0
0D00: 226E000C      MOVEA.L    12(A6),A1
0D04: 1290          MOVE.B     (A0),(A1)
0D06: 66D2          BNE.S      $0CDA
0D08: 3007          MOVE.W     D7,D0
0D0A: 2E1F          MOVE.L     (A7)+,D7
0D0C: 4E5E          UNLK       A6
0D0E: 4E75          RTS        


; ======= Function at 0x0D10 =======
0D10: 4E56FFF2      LINK       A6,#-14                        ; frame=14
0D14: 2F2E0008      MOVE.L     8(A6),-(A7)
0D18: 3F2E000C      MOVE.W     12(A6),-(A7)
0D1C: 486EFFFA      PEA        -6(A6)
0D20: 486EFFFC      PEA        -4(A6)
0D24: 486EFFF2      PEA        -14(A6)
0D28: A98D2F2E      MOVE.L     A5,46(A4,D2.L*8)
0D2C: FFFC2F2E      MOVE.W     #$2F2E,???
0D30: 000EA95B      ORI.B      #$A95B,A6
0D34: 4E5E          UNLK       A6
0D36: 4E75          RTS        


; ======= Function at 0x0D38 =======
0D38: 4E56FFF2      LINK       A6,#-14                        ; frame=14
0D3C: 2F2E0008      MOVE.L     8(A6),-(A7)
0D40: 3F2E000C      MOVE.W     12(A6),-(A7)
0D44: 486EFFFA      PEA        -6(A6)
0D48: 486EFFFC      PEA        -4(A6)
0D4C: 486EFFF2      PEA        -14(A6)
0D50: A98D4267      MOVE.L     A5,103(A4,D4.W*2)
0D54: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
0D58: A960301F      MOVE.L     -(A0),12319(A4)
0D5C: 4E5E          UNLK       A6
0D5E: 4E75          RTS        


; ======= Function at 0x0D60 =======
0D60: 4E56FFF2      LINK       A6,#-14                        ; frame=14
0D64: 2F2E0008      MOVE.L     8(A6),-(A7)
0D68: 3F2E000C      MOVE.W     12(A6),-(A7)
0D6C: 486EFFFA      PEA        -6(A6)
0D70: 486EFFFC      PEA        -4(A6)
0D74: 486EFFF2      PEA        -14(A6)
0D78: A98D202E      MOVE.L     A5,46(A4,D2.W)
0D7C: FFFC4E5E      MOVE.W     #$4E5E,???
0D80: 4E75          RTS        


; ======= Function at 0x0D82 =======
0D82: 4E56FEEE      LINK       A6,#-274                       ; frame=274
0D86: 2F2E0008      MOVE.L     8(A6),-(A7)
0D8A: 3F2E000C      MOVE.W     12(A6),-(A7)
0D8E: 486EFFFA      PEA        -6(A6)
0D92: 486EFFFC      PEA        -4(A6)
0D96: 486EFFF2      PEA        -14(A6)
0D9A: A98D4AAE      MOVE.L     A5,-82(A4,D4.L*2)
0D9E: FFFC6604      MOVE.W     #$6604,???
0DA2: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0DA6: 2F2E000E      MOVE.L     14(A6),-(A7)
0DAA: 486EFEF2      PEA        -270(A6)
0DAE: 4EAD07DA      JSR        2010(A5)                       ; JT[2010]
0DB2: 2EAEFFFC      MOVE.L     -4(A6),(A7)
0DB6: 486EFEF2      PEA        -270(A6)
0DBA: A98F2EAE      MOVE.L     A7,-82(A4,D2.L*8)
0DBE: 00083F2E      ORI.B      #$3F2E,A0
0DC2: 000C102E      ORI.B      #$102E,A4
0DC6: FEF24880      MOVE.W     -128(A2,D4.L),(A7)+
0DCA: 3F00          MOVE.W     D0,-(A7)
0DCC: 102EFEF2      MOVE.B     -270(A6),D0
0DD0: 4880          EXT.W      D0
0DD2: 3F00          MOVE.W     D0,-(A7)
0DD4: A97E2F2E      MOVE.L     ???,12078(A4)
0DD8: 0008A873      ORI.B      #$A873,A0
0DDC: 486EFFF2      PEA        -14(A6)
0DE0: A9284E5E      MOVE.L     20062(A0),-(A4)
0DE4: 4E75          RTS        


; ======= Function at 0x0DE6 =======
0DE6: 4E56FFF2      LINK       A6,#-14                        ; frame=14
0DEA: 2F0C          MOVE.L     A4,-(A7)
0DEC: 286E000E      MOVEA.L    14(A6),A4
0DF0: 2F2E0008      MOVE.L     8(A6),-(A7)
0DF4: 3F2E000C      MOVE.W     12(A6),-(A7)
0DF8: 486EFFFA      PEA        -6(A6)
0DFC: 486EFFFC      PEA        -4(A6)
0E00: 486EFFF2      PEA        -14(A6)
0E04: A98D4AAE      MOVE.L     A5,-82(A4,D4.L*2)
0E08: FFFC6604      MOVE.W     #$6604,???
0E0C: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0E10: 422C0001      CLR.B      1(A4)
0E14: 4214          CLR.B      (A4)
0E16: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
0E1A: 2F0C          MOVE.L     A4,-(A7)
0E1C: A9902F0C      MOVE.L     (A0),12(A4,D2.L*8)
0E20: 4EAD0BEA      JSR        3050(A5)                       ; JT[3050]
0E24: 286EFFEE      MOVEA.L    -18(A6),A4
0E28: 4E5E          UNLK       A6
0E2A: 4E75          RTS        


; ======= Function at 0x0E2C =======
0E2C: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0E30: 4AAE0008      TST.L      8(A6)
0E34: 6714          BEQ.S      $0E4A
0E36: 206E0008      MOVEA.L    8(A6),A0
0E3A: 4A68006C      TST.W      108(A0)
0E3E: 6C0A          BGE.S      $0E4A
0E40: 206E0008      MOVEA.L    8(A6),A0
0E44: 3028006C      MOVE.W     108(A0),D0
0E48: 6002          BRA.S      $0E4C
0E4A: 7000          MOVEQ      #0,D0
0E4C: 4E5E          UNLK       A6
0E4E: 4E75          RTS        


; ======= Function at 0x0E50 =======
0E50: 4E560000      LINK       A6,#0
0E54: 2F0C          MOVE.L     A4,-(A7)
0E56: 286E0008      MOVEA.L    8(A6),A4
0E5A: 200C          MOVE.L     A4,D0
0E5C: 6716          BEQ.S      $0E74
0E5E: 4A6C006C      TST.W      108(A4)
0E62: 6D10          BLT.S      $0E74
0E64: 0C6C0008006C  CMPI.W     #$0008,108(A4)
0E6A: 6C0C          BGE.S      $0E78
0E6C: 082C0001006D  BTST       #1,109(A4)
0E72: 6604          BNE.S      $0E78
0E74: 7000          MOVEQ      #0,D0
0E76: 6002          BRA.S      $0E7A
0E78: 7001          MOVEQ      #1,D0
0E7A: 285F          MOVEA.L    (A7)+,A4
0E7C: 4E5E          UNLK       A6
0E7E: 4E75          RTS        


; ======= Function at 0x0E80 =======
0E80: 4E560000      LINK       A6,#0
0E84: 2F07          MOVE.L     D7,-(A7)
0E86: 206E0008      MOVEA.L    8(A6),A0
0E8A: 3E28006C      MOVE.W     108(A0),D7
0E8E: 4A47          TST.W      D7
0E90: 6D06          BLT.S      $0E98
0E92: 08070001      BTST       #1,D7
0E96: 6604          BNE.S      $0E9C
0E98: 7000          MOVEQ      #0,D0
0E9A: 6002          BRA.S      $0E9E
0E9C: 7001          MOVEQ      #1,D0
0E9E: 2E1F          MOVE.L     (A7)+,D7
0EA0: 4E5E          UNLK       A6
0EA2: 4E75          RTS        

0EA4: 4EBAFDDA      JSR        -550(PC)
0EA8: 4E75          RTS        


; ======= Function at 0x0EAA =======
0EAA: 4E560000      LINK       A6,#0
0EAE: 2F0C          MOVE.L     A4,-(A7)
0EB0: 286E0008      MOVEA.L    8(A6),A4
0EB4: 4878006C      PEA        $006C.W
0EB8: 2F0C          MOVE.L     A4,-(A7)
0EBA: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0EBE: 486DFB70      PEA        -1168(A5)                      ; A5-1168
0EC2: 4227          CLR.B      -(A7)
0EC4: 4878FFFF      PEA        $FFFF.W
0EC8: 48780002      PEA        $0002.W
0ECC: 2F2DF248      MOVE.L     -3512(A5),-(A7)                ; A5-3512
0ED0: 2F2E000C      MOVE.L     12(A6),-(A7)
0ED4: 2F0C          MOVE.L     A4,-(A7)
0ED6: 4EAD0C12      JSR        3090(A5)                       ; JT[3090]
0EDA: B08C          MOVE.W     A4,(A0)
0EDC: 4FEF0022      LEA        34(A7),A7
0EE0: 6704          BEQ.S      $0EE6
0EE2: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0EE6: 4A6E0010      TST.W      16(A6)
0EEA: 6708          BEQ.S      $0EF4
0EEC: 2F0C          MOVE.L     A4,-(A7)
0EEE: 4EAD0C1A      JSR        3098(A5)                       ; JT[3098]
0EF2: 588F          MOVE.B     A7,(A4)
0EF4: 200C          MOVE.L     A4,D0
0EF6: 285F          MOVEA.L    (A7)+,A4
0EF8: 4E5E          UNLK       A6
0EFA: 4E75          RTS        


; ======= Function at 0x0EFC =======
0EFC: 4E560000      LINK       A6,#0
0F00: 4AAE0008      TST.L      8(A6)
0F04: 670E          BEQ.S      $0F14
0F06: 206E0008      MOVEA.L    8(A6),A0
0F0A: 4A28006E      TST.B      110(A0)
0F0E: 6704          BEQ.S      $0F14
0F10: 7000          MOVEQ      #0,D0
0F12: 6002          BRA.S      $0F16
0F14: 7001          MOVEQ      #1,D0
0F16: 4E5E          UNLK       A6
0F18: 4E75          RTS        


; ======= Function at 0x0F1A =======
0F1A: 4E56FEFE      LINK       A6,#-258                       ; frame=258
0F1E: 2F2E0008      MOVE.L     8(A6),-(A7)
0F22: 486EFEFE      PEA        -258(A6)
0F26: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0F2A: 486EFEFE      PEA        -258(A6)
0F2E: 4EAD0BF2      JSR        3058(A5)                       ; JT[3058]
0F32: 3EAE000C      MOVE.W     12(A6),(A7)
0F36: 3F2E000E      MOVE.W     14(A6),-(A7)
0F3A: A893          MOVE.L     (A3),(A4)
0F3C: 486EFEFE      PEA        -258(A6)
0F40: A884          MOVE.L     D4,(A4)
0F42: 4E5E          UNLK       A6
0F44: 4E75          RTS        


; ======= Function at 0x0F46 =======
0F46: 4E56FFF0      LINK       A6,#-16                        ; frame=16
0F4A: 41EEFFF0      LEA        -16(A6),A0
0F4E: 700A          MOVEQ      #10,D0
0F50: A0305240      MOVE.L     64(A0,D5.W*2),D0
0F54: 4A00          TST.B      D0
0F56: 67F2          BEQ.S      $0F4A
0F58: 4878000A      PEA        $000A.W
0F5C: 201F          MOVE.L     (A7)+,D0
0F5E: A0324E5E      MOVE.L     94(A2,D4.L*8),D0
0F62: 4E75          RTS        
