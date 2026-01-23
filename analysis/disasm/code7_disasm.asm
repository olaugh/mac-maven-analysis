;======================================================================
; CODE 7 Disassembly
; File: /tmp/maven_code_7.bin
; Header: JT offset=224, JT entries=13
; Code size: 2872 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 3F2E0008      MOVE.W     8(A6),-(A7)
0008: 4EBA0582      JSR        1410(PC)
000C: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
0010: 2B48C376      MOVE.L     A0,-15498(A5)
0014: 4A10          TST.B      (A0)
0016: 548F          MOVE.B     A7,(A2)
0018: 6704          BEQ.S      $001E
001A: 7008          MOVEQ      #8,D0
001C: 6002          BRA.S      $0020
001E: 7000          MOVEQ      #0,D0
0020: 3B40DE64      MOVE.W     D0,-8604(A5)
0024: 4EAD040A      JSR        1034(A5)                       ; JT[1034]
0028: 4EAD04EA      JSR        1258(A5)                       ; JT[1258]
002C: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
0030: 4EAD0292      JSR        658(A5)                        ; JT[658]
0034: 4E5E          UNLK       A6
0036: 4E75          RTS        


; ======= Function at 0x0038 =======
0038: 4E56FFFE      LINK       A6,#-2                         ; frame=2
003C: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0040: 266E0008      MOVEA.L    8(A6),A3
0044: 362E000E      MOVE.W     14(A6),D3
0048: 302E000C      MOVE.W     12(A6),D0
004C: 6778          BEQ.S      $00C6
004E: 6B000292      BMI.W      $02E4
0052: 57406700      MOVE.B     D0,26368(A3)
0056: 01E6          BSET       D0,-(A6)
0058: 6A08          BPL.S      $0062
005A: 5240          MOVEA.B    D0,A1
005C: 6A000216      BPL.W      $0276
0060: 600A          BRA.S      $006C
0062: 55406A00      MOVE.B     D0,27136(A2)
0066: 027C600001FC  ANDI.W     #$6000,#$01FC
006C: 284B          MOVEA.L    A3,A4
006E: 48780220      PEA        $0220.W
0072: 486DBCFE      PEA        -17154(A5)                     ; g_state1
0076: 4EAD01AA      JSR        426(A5)                        ; JT[426]
007A: 48780440      PEA        $0440.W
007E: 486DBF1E      PEA        -16610(A5)                     ; g_state2
0082: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0086: 486C0006      PEA        6(A4)
008A: 486DC366      PEA        -15514(A5)                     ; g_field_14
008E: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0092: 486C000E      PEA        14(A4)
0096: 486DC35E      PEA        -15522(A5)                     ; g_field_22
009A: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
009E: 4A6C0002      TST.W      2(A4)
00A2: 4FEF0020      LEA        32(A7),A7
00A6: 6708          BEQ.S      $00B0
00A8: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
00AC: 2008          MOVE.L     A0,D0
00AE: 6006          BRA.S      $00B6
00B0: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
00B4: 2008          MOVE.L     A0,D0
00B6: 2B40C376      MOVE.L     D0,-15498(A5)
00BA: 42ADC372      CLR.L      -15502(A5)
00BE: 42ADC36E      CLR.L      -15506(A5)
00C2: 6000021E      BRA.W      $02E4
00C6: 284B          MOVEA.L    A3,A4
00C8: 48780110      PEA        $0110.W
00CC: 486DBCFE      PEA        -17154(A5)                     ; g_state1
00D0: 2F0C          MOVE.L     A4,-(A7)
00D2: 4EAD067A      JSR        1658(A5)                       ; JT[1658]
00D6: 7011          MOVEQ      #17,D0
00D8: 2E80          MOVE.L     D0,(A7)
00DA: 486DBCFE      PEA        -17154(A5)                     ; g_state1
00DE: 4EAD01AA      JSR        426(A5)                        ; JT[426]
00E2: 7810          MOVEQ      #16,D4
00E4: 47EDBE0E      LEA        -16882(A5),A3                  ; A5-16882
00E8: 4FEF0010      LEA        16(A7),A7
00EC: 6034          BRA.S      $0122
00EE: 7601          MOVEQ      #1,D3
00F0: 244B          MOVEA.L    A3,A2
00F2: 70F1          MOVEQ      #-15,D0
00F4: D044          MOVEA.B    D4,A0
00F6: 3D40FFFE      MOVE.W     D0,-2(A6)
00FA: 7E11          MOVEQ      #17,D7
00FC: CFC3          ANDA.L     D3,A7
00FE: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
0102: DE88          MOVE.B     A0,(A7)
0104: 6010          BRA.S      $0116
0106: 306EFFFE      MOVEA.W    -2(A6),A0
010A: 15B078003000  MOVE.B     0(A0,D7.L),0(A2,D3.W)
0110: 5243          MOVEA.B    D3,A1
0112: 7011          MOVEQ      #17,D0
0114: DE80          MOVE.B     D0,(A7)
0116: 0C430010      CMPI.W     #$0010,D3
011A: 6DEA          BLT.S      $0106
011C: 5244          MOVEA.B    D4,A1
011E: 47EB0011      LEA        17(A3),A3
0122: 0C440020      CMPI.W     #$0020,D4
0126: 65C6          BCS.S      $00EE
0128: 48780440      PEA        $0440.W
012C: 486DBF1E      PEA        -16610(A5)                     ; g_state2
0130: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0134: 7800          MOVEQ      #0,D4
0136: 47EDBCFE      LEA        -17154(A5),A3                  ; g_state1
013A: 45EDBF1E      LEA        -16610(A5),A2                  ; g_state2
013E: 508F          MOVE.B     A7,(A0)
0140: 6040          BRA.S      $0182
0142: 7600          MOVEQ      #0,D3
0144: 2E0A          MOVE.L     A2,D7
0146: 2C03          MOVE.L     D3,D6
0148: 48C6          EXT.L      D6
014A: DC86          MOVE.B     D6,(A6)
014C: 6024          BRA.S      $0172
014E: 2A03          MOVE.L     D3,D5
0150: 48C5          EXT.L      D5
0152: DA8B          MOVE.B     A3,(A5)
0154: 2045          MOVEA.L    D5,A0
0156: 4A10          TST.B      (A0)
0158: 6714          BEQ.S      $016E
015A: 2045          MOVEA.L    D5,A0
015C: 1010          MOVE.B     (A0),D0
015E: 4880          EXT.W      D0
0160: 204D          MOVEA.L    A5,A0
0162: D0C0          MOVE.B     D0,(A0)+
0164: D0C0          MOVE.B     D0,(A0)+
0166: 2247          MOVEA.L    D7,A1
0168: D3C632A89412  MOVE.B     D6,$32A89412
016E: 5243          MOVEA.B    D3,A1
0170: 5486          MOVE.B     D6,(A2)
0172: 0C430011      CMPI.W     #$0011,D3
0176: 65D6          BCS.S      $014E
0178: 5244          MOVEA.B    D4,A1
017A: 47EB0011      LEA        17(A3),A3
017E: 45EA0022      LEA        34(A2),A2
0182: 0C440020      CMPI.W     #$0020,D4
0186: 65BA          BCS.S      $0142
0188: 102C012A      MOVE.B     298(A4),D0
018C: 4880          EXT.W      D0
018E: C1FC0022122C  ANDA.L     #$0022122C,A0
0194: 012B4881      BTST       D0,18561(A3)
0198: 41EDBF1E      LEA        -16610(A5),A0                  ; g_state2
019C: D088          MOVE.B     A0,(A0)
019E: 3041          MOVEA.W    D1,A0
01A0: D1C84270      MOVE.B     A0,$4270.W
01A4: 0800102C      BTST       #4140,D0
01A8: 01284880      BTST       D0,18560(A0)
01AC: C1FC0022122C  ANDA.L     #$0022122C,A0
01B2: 01294881      BTST       D0,18561(A1)
01B6: 41EDBF1E      LEA        -16610(A5),A0                  ; g_state2
01BA: D088          MOVE.B     A0,(A0)
01BC: 3041          MOVEA.W    D1,A0
01BE: D1C84270      MOVE.B     A0,$4270.W
01C2: 0800102C      BTST       #4140,D0
01C6: 012B4880      BTST       D0,18560(A3)
01CA: 06400010      ADDI.W     #$0010,D0
01CE: C1FC0022122C  ANDA.L     #$0022122C,A0
01D4: 012A4881      BTST       D0,18561(A2)
01D8: 41EDBF1E      LEA        -16610(A5),A0                  ; g_state2
01DC: D088          MOVE.B     A0,(A0)
01DE: 3041          MOVEA.W    D1,A0
01E0: D1C84270      MOVE.B     A0,$4270.W
01E4: 0800102C      BTST       #4140,D0
01E8: 01294880      BTST       D0,18560(A1)
01EC: 06400010      ADDI.W     #$0010,D0
01F0: C1FC0022122C  ANDA.L     #$0022122C,A0
01F6: 01284881      BTST       D0,18561(A0)
01FA: 41EDBF1E      LEA        -16610(A5),A0                  ; g_state2
01FE: D088          MOVE.B     A0,(A0)
0200: 3041          MOVEA.W    D1,A0
0202: D1C84270      MOVE.B     A0,$4270.W
0206: 0800486C      BTST       #18540,D0
020A: 0110          BTST       D0,(A0)
020C: 486DC366      PEA        -15514(A5)                     ; g_field_14
0210: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0214: 486C0118      PEA        280(A4)
0218: 486DC35E      PEA        -15522(A5)                     ; g_field_22
021C: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0220: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
0224: 2B48C376      MOVE.L     A0,-15498(A5)
0228: 2B6C0124C36E  MOVE.L     292(A4),-15506(A5)
022E: 2B6C0120C372  MOVE.L     288(A4),-15502(A5)
0234: 4FEF0010      LEA        16(A7),A7
0238: 600000A8      BRA.W      $02E4
023C: 284B          MOVEA.L    A3,A4
023E: 70FF          MOVEQ      #-1,D0
0240: D043          MOVEA.B    D3,A0
0242: 3F00          MOVE.W     D0,-(A7)
0244: 4EBA0346      JSR        838(PC)
0248: 4A54          TST.W      (A4)
024A: 548F          MOVE.B     A7,(A2)
024C: 6708          BEQ.S      $0256
024E: 2B6C000EC372  MOVE.L     14(A4),-15502(A5)
0254: 6006          BRA.S      $025C
0256: 2B6C000EC36E  MOVE.L     14(A4),-15506(A5)
025C: 422DC366      CLR.B      -15514(A5)
0260: 422DC35E      CLR.B      -15522(A5)
0264: 607C          BRA.S      $02E2
0266: 70FF          MOVEQ      #-1,D0
0268: D043          MOVEA.B    D3,A0
026A: 3F00          MOVE.W     D0,-(A7)
026C: 4EBA031E      JSR        798(PC)
0270: 548F          MOVE.B     A7,(A2)
0272: 606E          BRA.S      $02E2
0274: 284B          MOVEA.L    A3,A4
0276: 70FF          MOVEQ      #-1,D0
0278: D043          MOVEA.B    D3,A0
027A: 3F00          MOVE.W     D0,-(A7)
027C: 4EBA030E      JSR        782(PC)
0280: 4A6C0022      TST.W      34(A4)
0284: 548F          MOVE.B     A7,(A2)
0286: 671C          BEQ.S      $02A4
0288: 47EDC366      LEA        -15514(A5),A3                  ; g_field_14
028C: 486C002C      PEA        44(A4)
0290: 486DC35E      PEA        -15522(A5)                     ; g_field_22
0294: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0298: 202C0010      MOVE.L     16(A4),D0
029C: D1ADC372508F  MOVE.B     -15502(A5),-113(A0,D5.W)       ; g_size2=65536
02A2: 601A          BRA.S      $02BE
02A4: 47EDC35E      LEA        -15522(A5),A3                  ; g_field_22
02A8: 486C002C      PEA        44(A4)
02AC: 486DC366      PEA        -15514(A5)                     ; g_field_14
02B0: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
02B4: 202C0010      MOVE.L     16(A4),D0
02B8: D1ADC36E508F  MOVE.B     -15506(A5),-113(A0,D5.W)       ; g_size1=56630
02BE: 486C0024      PEA        36(A4)
02C2: 2F0B          MOVE.L     A3,-(A7)
02C4: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
02C8: 2E8B          MOVE.L     A3,(A7)
02CA: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
02CE: 4257          CLR.W      (A7)
02D0: 2F0B          MOVE.L     A3,-(A7)
02D2: 2F0C          MOVE.L     A4,-(A7)
02D4: 4EAD0942      JSR        2370(A5)                       ; JT[2370]
02D8: 2E8B          MOVE.L     A3,(A7)
02DA: 4EAD0582      JSR        1410(A5)                       ; JT[1410]
02DE: 4FEF0010      LEA        16(A7),A7
02E2: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
02E6: 4E5E          UNLK       A6
02E8: 4E75          RTS        


; ======= Function at 0x02EA =======
02EA: 4E560000      LINK       A6,#0
02EE: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
02F2: 286E0008      MOVEA.L    8(A6),A4
02F6: 48780110      PEA        $0110.W
02FA: 2F0C          MOVE.L     A4,-(A7)
02FC: 486DBCFE      PEA        -17154(A5)                     ; g_state1
0300: 4EAD067A      JSR        1658(A5)                       ; JT[1658]
0304: 486DC366      PEA        -15514(A5)                     ; g_field_14
0308: 486C0110      PEA        272(A4)
030C: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0310: 486DC35E      PEA        -15522(A5)                     ; g_field_22
0314: 486C0118      PEA        280(A4)
0318: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
031C: 296DC3720120  MOVE.L     -15502(A5),288(A4)             ; g_size2=65536
0322: 296DC36E0124  MOVE.L     -15506(A5),292(A4)             ; g_size1=56630
0328: 422C0129      CLR.B      297(A4)
032C: 422C0129      CLR.B      297(A4)
0330: 422C012B      CLR.B      299(A4)
0334: 422C0128      CLR.B      296(A4)
0338: 422C012A      CLR.B      298(A4)
033C: 7800          MOVEQ      #0,D4
033E: 47EDBF1E      LEA        -16610(A5),A3                  ; g_state2
0342: 45EDBCFE      LEA        -17154(A5),A2                  ; g_state1
0346: 4FEF001C      LEA        28(A7),A7
034A: 6046          BRA.S      $0392
034C: 7600          MOVEQ      #0,D3
034E: 2E0A          MOVE.L     A2,D7
0350: 2C0B          MOVE.L     A3,D6
0352: 2A03          MOVE.L     D3,D5
0354: 48C5          EXT.L      D5
0356: DA85          MOVE.B     D5,(A5)
0358: 6028          BRA.S      $0382
035A: 3043          MOVEA.W    D3,A0
035C: 4A307800      TST.B      0(A0,D7.L)
0360: 671C          BEQ.S      $037E
0362: 2046          MOVEA.L    D6,A0
0364: D1C54A50      MOVE.B     D5,$4A50.W
0368: 6614          BNE.S      $037E
036A: 196C0128012A  MOVE.B     296(A4),298(A4)
0370: 19440128      MOVE.B     D4,296(A4)
0374: 196C0129012B  MOVE.B     297(A4),299(A4)
037A: 19430129      MOVE.B     D3,297(A4)
037E: 5243          MOVEA.B    D3,A1
0380: 5485          MOVE.B     D5,(A2)
0382: 0C430011      CMPI.W     #$0011,D3
0386: 65D2          BCS.S      $035A
0388: 5244          MOVEA.B    D4,A1
038A: 47EB0022      LEA        34(A3),A3
038E: 45EA0011      LEA        17(A2),A2
0392: 0C440010      CMPI.W     #$0010,D4
0396: 65B4          BCS.S      $034C
0398: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
039C: 4E5E          UNLK       A6
039E: 4E75          RTS        


; ======= Function at 0x03A0 =======
03A0: 4E56FF7E      LINK       A6,#-130                       ; frame=130
03A4: 48E71F18      MOVEM.L    D3/D4/D5/D6/D7/A3/A4,-(SP)     ; save
03A8: 486DC366      PEA        -15514(A5)                     ; g_field_14
03AC: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
03B0: 3E00          MOVE.W     D0,D7
03B2: 486DC35E      PEA        -15522(A5)                     ; g_field_22
03B6: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
03BA: 3C00          MOVE.W     D0,D6
03BC: 4A2DC35E      TST.B      -15522(A5)
03C0: 508F          MOVE.B     A7,(A0)
03C2: 6604          BNE.S      $03C8
03C4: DE47          MOVEA.B    D7,A7
03C6: 6014          BRA.S      $03DC
03C8: 4A2DC366      TST.B      -15514(A5)
03CC: 6604          BNE.S      $03D2
03CE: DC46          MOVEA.B    D6,A6
03D0: 600A          BRA.S      $03DC
03D2: 3A07          MOVE.W     D7,D5
03D4: 3E06          MOVE.W     D6,D7
03D6: 4447          NEG.W      D7
03D8: 3C05          MOVE.W     D5,D6
03DA: 4446          NEG.W      D6
03DC: 2006          MOVE.L     D6,D0
03DE: 48C0          EXT.L      D0
03E0: D1ADA4A82007  MOVE.B     -23384(A5),7(A0,D2.W)          ; A5-23384
03E6: 48C0          EXT.L      D0
03E8: D1ADA5002007  MOVE.B     -23296(A5),7(A0,D2.W)          ; A5-23296
03EE: 48C0          EXT.L      D0
03F0: D1ADC36E2006  MOVE.B     -15506(A5),6(A0,D2.W)          ; g_size1=56630
03F6: 48C0          EXT.L      D0
03F8: D1ADC37241ED  MOVE.B     -15502(A5),-19(A0,D4.W)        ; g_size2=65536
03FE: C35E          AND.W      D1,(A6)+
0400: B1EDC3766614  MOVE.W     -15498(A5),$6614.W             ; A5-15498
0406: 49EDC366      LEA        -15514(A5),A4                  ; g_field_14
040A: 2A2DC36E      MOVE.L     -15506(A5),D5                  ; g_size1=56630
040E: 282DC372      MOVE.L     -15502(A5),D4                  ; g_size2=65536
0412: 3607          MOVE.W     D7,D3
0414: 3D46FF7E      MOVE.W     D6,-130(A6)
0418: 6012          BRA.S      $042C
041A: 49EDC35E      LEA        -15522(A5),A4                  ; g_field_22
041E: 2A2DC372      MOVE.L     -15502(A5),D5                  ; g_size2=65536
0422: 282DC36E      MOVE.L     -15506(A5),D4                  ; g_size1=56630
0426: 3606          MOVE.W     D6,D3
0428: 3D47FF7E      MOVE.W     D7,-130(A6)
042C: 4A2DC35E      TST.B      -15522(A5)
0430: 6710          BEQ.S      $0442
0432: 4A2DC366      TST.B      -15514(A5)
0436: 670A          BEQ.S      $0442
0438: 264C          MOVEA.L    A4,A3
043A: 286DC376      MOVEA.L    -15498(A5),A4
043E: 2B4BC376      MOVE.L     A3,-15498(A5)
0442: 2F04          MOVE.L     D4,-(A7)
0444: 3F03          MOVE.W     D3,-(A7)
0446: 2F0C          MOVE.L     A4,-(A7)
0448: 4EBA0372      JSR        882(PC)
044C: 2E85          MOVE.L     D5,(A7)
044E: 3F2EFF7E      MOVE.W     -130(A6),-(A7)
0452: 2F2DC376      MOVE.L     -15498(A5),-(A7)               ; A5-15498
0456: 4EBA0364      JSR        868(PC)
045A: 422DC366      CLR.B      -15514(A5)
045E: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
0462: 4CEE18F8FF62  MOVEM.L    -158(A6),D3/D4/D5/D6/D7/A3/A4
0468: 4E5E          UNLK       A6
046A: 4E75          RTS        


; ======= Function at 0x046C =======
046C: 4E560000      LINK       A6,#0
0470: 302E0008      MOVE.W     8(A6),D0
0474: 6B14          BMI.S      $048A
0476: 5B406A10      MOVE.B     D0,27152(A5)
047A: 5640          MOVEA.B    D0,A3
047C: 6A06          BPL.S      $0484
047E: 302E000A      MOVE.W     10(A6),D0
0482: 6006          BRA.S      $048A
0484: 70FF          MOVEQ      #-1,D0
0486: D06E000A      MOVEA.B    10(A6),A0
048A: 4E5E          UNLK       A6
048C: 4E75          RTS        


; ======= Function at 0x048E =======
048E: 4E560000      LINK       A6,#0
0492: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0496: 302E000C      MOVE.W     12(A6),D0
049A: 6B66          BMI.S      $0502
049C: 57406708      MOVE.B     D0,26376(A3)
04A0: 6A60          BPL.S      $0502
04A2: 5240          MOVEA.B    D0,A1
04A4: 6A18          BPL.S      $04BE
04A6: 605A          BRA.S      $0502
04A8: 422DC35E      CLR.B      -15522(A5)
04AC: 422DC366      CLR.B      -15514(A5)
04B0: 42ADC376      CLR.L      -15498(A5)
04B4: 4EAD04EA      JSR        1258(A5)                       ; JT[1258]
04B8: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
04BC: 6044          BRA.S      $0502
04BE: 286E0008      MOVEA.L    8(A6),A4
04C2: 486C0024      PEA        36(A4)
04C6: 486DC366      PEA        -15514(A5)                     ; g_field_14
04CA: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
04CE: 486C002C      PEA        44(A4)
04D2: 486DC35E      PEA        -15522(A5)                     ; g_field_22
04D6: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
04DA: 4A6C0022      TST.W      34(A4)
04DE: 4FEF0010      LEA        16(A7),A7
04E2: 660E          BNE.S      $04F2
04E4: 2E2DC36E      MOVE.L     -15506(A5),D7                  ; g_size1=56630
04E8: 2B6DC372C36E  MOVE.L     -15502(A5),-15506(A5)          ; g_size2=65536
04EE: 2B47C372      MOVE.L     D7,-15502(A5)
04F2: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
04F6: 2B48C376      MOVE.L     A0,-15498(A5)
04FA: 4EAD04EA      JSR        1258(A5)                       ; JT[1258]
04FE: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
0502: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
0506: 4E5E          UNLK       A6
0508: 4E75          RTS        


; ======= Function at 0x050A =======
050A: 4E560000      LINK       A6,#0
050E: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0512: 7006          MOVEQ      #6,D0
0514: C1EE0008      ANDA.L     8(A6),A0
0518: 2840          MOVEA.L    D0,A4
051A: 206DDEC2      MOVEA.L    -8510(A5),A0
051E: 206800CA      MOVEA.L    202(A0),A0
0522: 2010          MOVE.L     (A0),D0
0524: 2F340802      MOVE.L     2(A4,D0.L),-(A7)
0528: 4EAD05EA      JSR        1514(A5)                       ; JT[1514]
052C: 2640          MOVEA.L    D0,A3
052E: 206DDEC2      MOVEA.L    -8510(A5),A0
0532: 206800CA      MOVEA.L    202(A0),A0
0536: 224C          MOVEA.L    A4,A1
0538: D3D01E114887  MOVE.B     (A0),$1E114887
053E: 3EAE0008      MOVE.W     8(A6),(A7)
0542: 3F07          MOVE.W     D7,-(A7)
0544: 2F0B          MOVE.L     A3,-(A7)
0546: 4EBAFF46      JSR        -186(PC)
054A: 206DDEC2      MOVEA.L    -8510(A5),A0
054E: 206800CA      MOVEA.L    202(A0),A0
0552: 2010          MOVE.L     (A0),D0
0554: 20740802      MOVEA.L    2(A4,D0.L),A0
0558: A02A4CEE      MOVE.L     19694(A2),D0
055C: 1880          MOVE.B     D0,(A4)
055E: FFF44E5E      MOVE.W     94(A4,D4.L*8),???
0562: 4E75          RTS        


; ======= Function at 0x0564 =======
0564: 4E560000      LINK       A6,#0
0568: 3F2E0008      MOVE.W     8(A6),-(A7)
056C: 206DDEC2      MOVEA.L    -8510(A5),A0
0570: 206800CA      MOVEA.L    202(A0),A0
0574: 7006          MOVEQ      #6,D0
0576: C1EE0008      ANDA.L     8(A6),A0
057A: D090          MOVE.B     (A0),(A0)
057C: 2040          MOVEA.L    D0,A0
057E: 1010          MOVE.B     (A0),D0
0580: 4880          EXT.W      D0
0582: 3F00          MOVE.W     D0,-(A7)
0584: 4EBAFEE6      JSR        -282(PC)
0588: 4E5E          UNLK       A6
058A: 4E75          RTS        


; ======= Function at 0x058C =======
058C: 4E560000      LINK       A6,#0
0590: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0594: 7006          MOVEQ      #6,D0
0596: C1EE0008      ANDA.L     8(A6),A0
059A: 2840          MOVEA.L    D0,A4
059C: 206DDEC2      MOVEA.L    -8510(A5),A0
05A0: 206800CA      MOVEA.L    202(A0),A0
05A4: 2010          MOVE.L     (A0),D0
05A6: 2F340802      MOVE.L     2(A4,D0.L),-(A7)
05AA: 4EAD05EA      JSR        1514(A5)                       ; JT[1514]
05AE: 2640          MOVEA.L    D0,A3
05B0: 206DDEC2      MOVEA.L    -8510(A5),A0
05B4: 206800CA      MOVEA.L    202(A0),A0
05B8: 224C          MOVEA.L    A4,A1
05BA: D3D01E114887  MOVE.B     (A0),$1E114887
05C0: 3EAE0008      MOVE.W     8(A6),(A7)
05C4: 3F07          MOVE.W     D7,-(A7)
05C6: 2F0B          MOVE.L     A3,-(A7)
05C8: 4EBAFA6E      JSR        -1426(PC)
05CC: 206DDEC2      MOVEA.L    -8510(A5),A0
05D0: 206800CA      MOVEA.L    202(A0),A0
05D4: 2010          MOVE.L     (A0),D0
05D6: 20740802      MOVEA.L    2(A4,D0.L),A0
05DA: A02A4CEE      MOVE.L     19694(A2),D0
05DE: 1880          MOVE.B     D0,(A4)
05E0: FFF44E5E      MOVE.W     94(A4,D4.L*8),???
05E4: 4E75          RTS        


; ======= Function at 0x05E6 =======
05E6: 4E56FFFC      LINK       A6,#-4                         ; frame=4
05EA: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
05EE: 42A7          CLR.L      -(A7)
05F0: 206DDEC2      MOVEA.L    -8510(A5),A0
05F4: 2F2800CA      MOVE.L     202(A0),-(A7)
05F8: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
05FC: 2D5FFFFC      MOVE.L     (A7)+,-4(A6)
0600: 48780006      PEA        $0006.W
0604: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
0608: 4EAD004A      JSR        74(A5)                         ; JT[74]
060C: 3E00          MOVE.W     D0,D7
060E: 206DDEC2      MOVEA.L    -8510(A5),A0
0612: 206800CA      MOVEA.L    202(A0),A0
0616: 2850          MOVEA.L    (A0),A4
0618: 6028          BRA.S      $0642
061A: 7006          MOVEQ      #6,D0
061C: C1C7          ANDA.L     D7,A0
061E: 2640          MOVEA.L    D0,A3
0620: 204C          MOVEA.L    A4,A0
0622: D1CB1010      MOVE.B     A3,$1010.W
0626: 6716          BEQ.S      $063E
0628: 6B18          BMI.S      $0642
062A: 5500          MOVE.B     D0,-(A2)
062C: 6A14          BPL.S      $0642
062E: 204C          MOVEA.L    A4,A0
0630: D1CB2468      MOVE.B     A3,$2468.W
0634: 00022052      ORI.B      #$2052,D2
0638: 30280004      MOVE.W     4(A0),D0
063C: 600C          BRA.S      $064A
063E: 7000          MOVEQ      #0,D0
0640: 6008          BRA.S      $064A
0642: 53474A47      MOVE.B     D7,19015(A1)
0646: 6CD2          BGE.S      $061A
0648: 7000          MOVEQ      #0,D0
064A: 4CDF1C80      MOVEM.L    (SP)+,D7/A2/A3/A4              ; restore
064E: 4E5E          UNLK       A6
0650: 4E75          RTS        


; ======= Function at 0x0652 =======
0652: 4E56FF66      LINK       A6,#-154                       ; frame=154
0656: 2F07          MOVE.L     D7,-(A7)
0658: 42A7          CLR.L      -(A7)
065A: 206DDEC2      MOVEA.L    -8510(A5),A0
065E: 2F2800CA      MOVE.L     202(A0),-(A7)
0662: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0666: 2D5FFF66      MOVE.L     (A7)+,-154(A6)
066A: 48780006      PEA        $0006.W
066E: 2F2EFF66      MOVE.L     -154(A6),-(A7)
0672: 4EAD004A      JSR        74(A5)                         ; JT[74]
0676: 3E00          MOVE.W     D0,D7
0678: 6014          BRA.S      $068E
067A: 206DDEC2      MOVEA.L    -8510(A5),A0
067E: 206800CA      MOVEA.L    202(A0),A0
0682: 7006          MOVEQ      #6,D0
0684: C1C7          ANDA.L     D7,A0
0686: 2050          MOVEA.L    (A0),A0
0688: 20700802      MOVEA.L    2(A0,D0.L),A0
068C: A023          MOVE.L     -(A3),D0
068E: 53474A47      MOVE.B     D7,19015(A1)
0692: 6CE6          BGE.S      $067A
0694: 206DDEC2      MOVEA.L    -8510(A5),A0
0698: 7000          MOVEQ      #0,D0
069A: 206800CA      MOVEA.L    202(A0),A0
069E: A024          MOVE.L     -(A4),D0
06A0: 4A780220      TST.W      $0220.W
06A4: 6704          BEQ.S      $06AA
06A6: 4EAD01A2      JSR        418(A5)                        ; JT[418]
06AA: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
06AE: A873206D      MOVEA.L    109(A3,D2.W),A4
06B2: DE80          MOVE.B     D0,(A7)
06B4: 4868003E      PEA        62(A0)
06B8: A9282F2D      MOVE.L     12077(A0),-(A4)
06BC: DEC6          MOVE.B     D6,(A7)+
06BE: 4267          CLR.W      -(A7)
06C0: A9652F2D      MOVE.L     -(A5),12077(A4)
06C4: DEC6          MOVE.B     D6,(A7)+
06C6: 4267          CLR.W      -(A7)
06C8: A963426E      MOVE.L     -(A3),17006(A4)
06CC: FFEA41ED      MOVE.W     16877(A2),???
06D0: C366          AND.W      D1,-(A6)
06D2: B1EDC37657C0  MOVE.W     -15498(A5),$57C0.W             ; A5-15498
06D8: 4400          NEG.B      D0
06DA: 4880          EXT.W      D0
06DC: 3D40FFEC      MOVE.W     D0,-20(A6)
06E0: 3D7C0001FFEE  MOVE.W     #$0001,-18(A6)
06E6: 486DC366      PEA        -15514(A5)                     ; g_field_14
06EA: 486EFFF0      PEA        -16(A6)
06EE: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
06F2: 486DC35E      PEA        -15522(A5)                     ; g_field_22
06F6: 486EFFF8      PEA        -8(A6)
06FA: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
06FE: 1EBC0001      MOVE.B     #$01,(A7)
0702: 48780016      PEA        $0016.W
0706: 486EFFEA      PEA        -22(A6)
070A: 3F3C7FFF      MOVE.W     #$7FFF,-(A7)
070E: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
0712: 4EBA00F4      JSR        244(PC)
0716: 426DDE54      CLR.W      -8620(A5)
071A: 206DDE78      MOVEA.L    -8584(A5),A0
071E: A02941ED      MOVE.L     16877(A1),D0
0722: C366          AND.W      D1,-(A6)
0724: B1EDC3764FEF  MOVE.W     -15498(A5),$4FEF.W             ; A5-15498
072A: 001E6624      ORI.B      #$6624,(A6)+
072E: 486DD700      PEA        -10496(A5)                     ; A5-10496
0732: 206DDE78      MOVEA.L    -8584(A5),A0
0736: 2050          MOVEA.L    (A0),A0
0738: 4868032E      PEA        814(A0)
073C: 486D90C4      PEA        -28476(A5)                     ; A5-28476
0740: 486EFF6B      PEA        -149(A6)
0744: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0748: 1D40FF6A      MOVE.B     D0,-150(A6)
074C: 4FEF0010      LEA        16(A7),A7
0750: 6022          BRA.S      $0774
0752: 206DDE78      MOVEA.L    -8584(A5),A0
0756: 2050          MOVEA.L    (A0),A0
0758: 4868032E      PEA        814(A0)
075C: 486DD700      PEA        -10496(A5)                     ; A5-10496
0760: 486D90CC      PEA        -28468(A5)                     ; A5-28468
0764: 486EFF6B      PEA        -149(A6)
0768: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
076C: 1D40FF6A      MOVE.B     D0,-150(A6)
0770: 4FEF0010      LEA        16(A7),A7
0774: 206DDE78      MOVEA.L    -8584(A5),A0
0778: A02A4878      MOVE.L     18552(A2),D0
077C: 004A486D      ORI.W      #$486D,A2
0780: D720          MOVE.B     -(A0),-(A3)
0782: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0786: 486EFF6A      PEA        -150(A6)
078A: 4EAD04DA      JSR        1242(A5)                       ; JT[1242]
078E: 2E2EFF62      MOVE.L     -158(A6),D7
0792: 4E5E          UNLK       A6
0794: 4E75          RTS        


; ======= Function at 0x0796 =======
0796: 4E56FED4      LINK       A6,#-300                       ; frame=300
079A: 486EFED4      PEA        -300(A6)
079E: 4EBAFB4A      JSR        -1206(PC)
07A2: 4217          CLR.B      (A7)
07A4: 4878012C      PEA        $012C.W
07A8: 486EFED4      PEA        -300(A6)
07AC: 3F3C7FFF      MOVE.W     #$7FFF,-(A7)
07B0: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
07B4: 4EBA0052      JSR        82(PC)
07B8: 4E5E          UNLK       A6
07BA: 4E75          RTS        


; ======= Function at 0x07BC =======
07BC: 4E56FF6E      LINK       A6,#-146                       ; frame=146
07C0: 306E000C      MOVEA.W    12(A6),A0
07C4: 2D48FF78      MOVE.L     A0,-136(A6)
07C8: 2D6E000EFF7C  MOVE.L     14(A6),-132(A6)
07CE: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
07D2: B1EE000857C0  MOVE.W     8(A6),$57C0.W
07D8: 4400          NEG.B      D0
07DA: 4880          EXT.W      D0
07DC: 3D40FF6E      MOVE.W     D0,-146(A6)
07E0: 2F2E0008      MOVE.L     8(A6),-(A7)
07E4: 486EFF70      PEA        -144(A6)
07E8: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
07EC: 1EBC0003      MOVE.B     #$03,(A7)
07F0: 48780012      PEA        $0012.W
07F4: 486EFF6E      PEA        -146(A6)
07F8: 3F3C7FFF      MOVE.W     #$7FFF,-(A7)
07FC: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
0800: 4EBA0006      JSR        6(PC)
0804: 4E5E          UNLK       A6
0806: 4E75          RTS        


; ======= Function at 0x0808 =======
0808: 4E56FFFC      LINK       A6,#-4                         ; frame=4
080C: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
0810: 266E0008      MOVEA.L    8(A6),A3
0814: 3C2E000C      MOVE.W     12(A6),D6
0818: 282E0012      MOVE.L     18(A6),D4
081C: 286B00CA      MOVEA.L    202(A3),A4
0820: 4AAB00CE      TST.L      206(A3)
0824: 6712          BEQ.S      $0838
0826: 1F2E0016      MOVE.B     22(A6),-(A7)
082A: 3F06          MOVE.W     D6,-(A7)
082C: 2F0B          MOVE.L     A3,-(A7)
082E: 206B00CE      MOVEA.L    206(A3),A0
0832: 4E90          JSR        (A0)
0834: 3C00          MOVE.W     D0,D6
0836: 508F          MOVE.B     A7,(A0)
0838: 42A7          CLR.L      -(A7)
083A: 2F0C          MOVE.L     A4,-(A7)
083C: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0840: 2D5FFFFC      MOVE.L     (A7)+,-4(A6)
0844: 48780006      PEA        $0006.W
0848: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
084C: 4EAD004A      JSR        74(A5)                         ; JT[74]
0850: 2A00          MOVE.L     D0,D5
0852: 3046          MOVEA.W    D6,A0
0854: BA88          MOVE.W     A0,(A5)
0856: 6E1E          BGT.S      $0876
0858: 3C05          MOVE.W     D5,D6
085A: 48780006      PEA        $0006.W
085E: 2F0C          MOVE.L     A4,-(A7)
0860: 4EAD05CA      JSR        1482(A5)                       ; JT[1482]
0864: 2004          MOVE.L     D4,D0
0866: A122          MOVE.L     -(A2),-(A0)
0868: 2448          MOVEA.L    A0,A2
086A: 7006          MOVEQ      #6,D0
086C: C1C6          ANDA.L     D6,A0
086E: 2054          MOVEA.L    (A4),A0
0870: 218A0802      MOVE.L     A2,2(A0,D0.L)
0874: 508F          MOVE.B     A7,(A0)
0876: 7E06          MOVEQ      #6,D7
0878: CFC6          ANDA.L     D6,A7
087A: 2054          MOVEA.L    (A4),A0
087C: 11AE00167800  MOVE.B     22(A6),0(A0,D7.L)
0882: 2054          MOVEA.L    (A4),A0
0884: 24707802      MOVEA.L    2(A0,D7.L),A2
0888: 2004          MOVE.L     D4,D0
088A: 204A          MOVEA.L    A2,A0
088C: A024          MOVE.L     -(A4),D0
088E: 4A780220      TST.W      $0220.W
0892: 6704          BEQ.S      $0898
0894: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0898: 204A          MOVEA.L    A2,A0
089A: A0292004      MOVE.L     8196(A1),D0
089E: 2252          MOVEA.L    (A2),A1
08A0: 206E000E      MOVEA.L    14(A6),A0
08A4: A02E204A      MOVE.L     8266(A6),D0
08A8: A02A377C      MOVE.L     14204(A2),D0
08AC: 000100D2      ORI.B      #$00D2,D1
08B0: 4CDF1CF0      MOVEM.L    (SP)+,D4/D5/D6/D7/A2/A3/A4     ; restore
08B4: 4E5E          UNLK       A6
08B6: 4E75          RTS        


; ======= Function at 0x08B8 =======
08B8: 4E56FFCC      LINK       A6,#-52                        ; frame=52
08BC: 206E000E      MOVEA.L    14(A6),A0
08C0: 43EEFFCC      LEA        -52(A6),A1
08C4: 7007          MOVEQ      #7,D0
08C6: 22D8          MOVE.L     (A0)+,(A1)+
08C8: 51C8FFFC      DBF        D0,$08C6                       ; loop
08CC: 32D8          MOVE.W     (A0)+,(A1)+
08CE: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
08D2: B1EDC37657C0  MOVE.W     -15498(A5),$57C0.W             ; A5-15498
08D8: 4400          NEG.B      D0
08DA: 4880          EXT.W      D0
08DC: 3D40FFEE      MOVE.W     D0,-18(A6)
08E0: 2F2DC376      MOVE.L     -15498(A5),-(A7)               ; A5-15498
08E4: 486EFFF0      PEA        -16(A6)
08E8: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
08EC: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
08F0: B1EDC376508F  MOVE.W     -15498(A5),$508F.W             ; A5-15498
08F6: 6608          BNE.S      $0900
08F8: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
08FC: 2008          MOVE.L     A0,D0
08FE: 6006          BRA.S      $0906
0900: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
0904: 2008          MOVE.L     A0,D0
0906: 2F00          MOVE.L     D0,-(A7)
0908: 486EFFF8      PEA        -8(A6)
090C: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0910: 1EBC0002      MOVE.B     #$02,(A7)
0914: 48780034      PEA        $0034.W
0918: 486EFFCC      PEA        -52(A6)
091C: 3F2E000C      MOVE.W     12(A6),-(A7)
0920: 2F2E0008      MOVE.L     8(A6),-(A7)
0924: 4EBAFEE2      JSR        -286(PC)
0928: 4E5E          UNLK       A6
092A: 4E75          RTS        


; ======= Function at 0x092C =======
092C: 4E56FF80      LINK       A6,#-128                       ; frame=128
0930: 4A6DDE54      TST.W      -8620(A5)
0934: 6708          BEQ.S      $093E
0936: 4EBAFE5E      JSR        -418(PC)
093A: 426DDE54      CLR.W      -8620(A5)
093E: 2F2E000C      MOVE.L     12(A6),-(A7)
0942: 3F3C7FFF      MOVE.W     #$7FFF,-(A7)
0946: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
094A: 4EBAFF6C      JSR        -148(PC)
094E: 3EBC0006      MOVE.W     #$0006,(A7)
0952: 4EAD01E2      JSR        482(A5)                        ; JT[482]
0956: 4E5E          UNLK       A6
0958: 4E75          RTS        


; ======= Function at 0x095A =======
095A: 4E56FFFE      LINK       A6,#-2                         ; frame=2
095E: 0C6D0005DE66  CMPI.W     #$0005,-8602(A5)
0964: 6612          BNE.S      $0978
0966: 4EBAFC7E      JSR        -898(PC)
096A: 4A40          TST.W      D0
096C: 670A          BEQ.S      $0978
096E: 486D90D4      PEA        -28460(A5)                     ; A5-28460
0972: 4EAD0C72      JSR        3186(A5)                       ; JT[3186]
0976: 588F          MOVE.B     A7,(A4)
0978: 206DDEC2      MOVEA.L    -8510(A5),A0
097C: 4A6800D2      TST.W      210(A0)
0980: 6728          BEQ.S      $09AA
0982: 3F3C0402      MOVE.W     #$0402,-(A7)
0986: 4EAD0C6A      JSR        3178(A5)                       ; JT[3178]
098A: 3D40000C      MOVE.W     D0,12(A6)
098E: 5340548F      MOVE.B     D0,21647(A1)
0992: 660E          BNE.S      $09A2
0994: 3F3C0001      MOVE.W     #$0001,-(A7)
0998: 4EBA0130      JSR        304(PC)
099C: 4A40          TST.W      D0
099E: 548F          MOVE.B     A7,(A2)
09A0: 6608          BNE.S      $09AA
09A2: 0C6E0002000C  CMPI.W     #$0002,12(A6)
09A8: 6604          BNE.S      $09AE
09AA: 4EBA0006      JSR        6(PC)
09AE: 4E5E          UNLK       A6
09B0: 4E75          RTS        


; ======= Function at 0x09B2 =======
09B2: 4E56FFA6      LINK       A6,#-90                        ; frame=90
09B6: 4878004A      PEA        $004A.W
09BA: 486EFFA6      PEA        -90(A6)
09BE: 4EAD01AA      JSR        426(A5)                        ; JT[426]
09C2: 2D7C58474D45FFF0  MOVE.L     #$58474D45,-16(A6)
09CA: 3EBC0001      MOVE.W     #$0001,(A7)
09CE: 486EFFF0      PEA        -16(A6)
09D2: 486EFFA6      PEA        -90(A6)
09D6: 4EAD0612      JSR        1554(A5)                       ; JT[1554]
09DA: 4A2EFFA6      TST.B      -90(A6)
09DE: 4FEF0010      LEA        16(A7),A7
09E2: 672E          BEQ.S      $0A12
09E4: 486EFFB0      PEA        -80(A6)
09E8: 3F2EFFAC      MOVE.W     -84(A6),-(A7)
09EC: 4EAD05AA      JSR        1450(A5)                       ; JT[1450]
09F0: 4A40          TST.W      D0
09F2: 5C8F          MOVE.B     A7,(A6)
09F4: 671C          BEQ.S      $0A12
09F6: 41EDD720      LEA        -10464(A5),A0                  ; g_state3
09FA: 43EEFFA6      LEA        -90(A6),A1
09FE: 7011          MOVEQ      #17,D0
0A00: 20D9          MOVE.L     (A1)+,(A0)+
0A02: 51C8FFFC      DBF        D0,$0A00                       ; loop
0A06: 30D9          MOVE.W     (A1)+,(A0)+
0A08: 4EAD057A      JSR        1402(A5)                       ; JT[1402]
0A0C: 3B7C0008DE64  MOVE.W     #$0008,-8604(A5)
0A12: 4E5E          UNLK       A6
0A14: 4E75          RTS        


; ======= Function at 0x0A16 =======
0A16: 4E56FFFE      LINK       A6,#-2                         ; frame=2
0A1A: 0C6D0005DE66  CMPI.W     #$0005,-8602(A5)
0A20: 6612          BNE.S      $0A34
0A22: 4EBAFBC2      JSR        -1086(PC)
0A26: 4A40          TST.W      D0
0A28: 670A          BEQ.S      $0A34
0A2A: 486D910E      PEA        -28402(A5)                     ; A5-28402
0A2E: 4EAD0C72      JSR        3186(A5)                       ; JT[3186]
0A32: 588F          MOVE.B     A7,(A4)
0A34: 206DDEC2      MOVEA.L    -8510(A5),A0
0A38: 4A6800D2      TST.W      210(A0)
0A3C: 6728          BEQ.S      $0A66
0A3E: 3F3C0401      MOVE.W     #$0401,-(A7)
0A42: 4EAD0C6A      JSR        3178(A5)                       ; JT[3178]
0A46: 3D40000C      MOVE.W     D0,12(A6)
0A4A: 5340548F      MOVE.B     D0,21647(A1)
0A4E: 660E          BNE.S      $0A5E
0A50: 3F3C0001      MOVE.W     #$0001,-(A7)
0A54: 4EBA0074      JSR        116(PC)
0A58: 4A40          TST.W      D0
0A5A: 548F          MOVE.B     A7,(A2)
0A5C: 6608          BNE.S      $0A66
0A5E: 0C6E0002000C  CMPI.W     #$0002,12(A6)
0A64: 6606          BNE.S      $0A6C
0A66: 3B7C0006DE64  MOVE.W     #$0006,-8604(A5)
0A6C: 4E5E          UNLK       A6
0A6E: 4E75          RTS        


; ======= Function at 0x0A70 =======
0A70: 4E56FFFE      LINK       A6,#-2                         ; frame=2
0A74: 0C6D0005DE66  CMPI.W     #$0005,-8602(A5)
0A7A: 6612          BNE.S      $0A8E
0A7C: 4EBAFB68      JSR        -1176(PC)
0A80: 4A40          TST.W      D0
0A82: 670A          BEQ.S      $0A8E
0A84: 486D9148      PEA        -28344(A5)                     ; A5-28344
0A88: 4EAD0C72      JSR        3186(A5)                       ; JT[3186]
0A8C: 588F          MOVE.B     A7,(A4)
0A8E: 206DDEC2      MOVEA.L    -8510(A5),A0
0A92: 4A6800D2      TST.W      210(A0)
0A96: 6728          BEQ.S      $0AC0
0A98: 3F3C0403      MOVE.W     #$0403,-(A7)
0A9C: 4EAD0C6A      JSR        3178(A5)                       ; JT[3178]
0AA0: 3D40000C      MOVE.W     D0,12(A6)
0AA4: 5340548F      MOVE.B     D0,21647(A1)
0AA8: 660E          BNE.S      $0AB8
0AAA: 3F3C0001      MOVE.W     #$0001,-(A7)
0AAE: 4EBA001A      JSR        26(PC)
0AB2: 4A40          TST.W      D0
0AB4: 548F          MOVE.B     A7,(A2)
0AB6: 6608          BNE.S      $0AC0
0AB8: 0C6E0002000C  CMPI.W     #$0002,12(A6)
0ABE: 6606          BNE.S      $0AC6
0AC0: 3B7C0001DE64  MOVE.W     #$0001,-8604(A5)
0AC6: 4E5E          UNLK       A6
0AC8: 4E75          RTS        


; ======= Function at 0x0ACA =======
0ACA: 4E56FFB6      LINK       A6,#-74                        ; frame=74
0ACE: 1D6E0009FFB6  MOVE.B     9(A6),-74(A6)
0AD4: 6714          BEQ.S      $0AEA
0AD6: 41EEFFB6      LEA        -74(A6),A0
0ADA: 43EDD720      LEA        -10464(A5),A1                  ; g_state3
0ADE: 7011          MOVEQ      #17,D0
0AE0: 20D9          MOVE.L     (A1)+,(A0)+
0AE2: 51C8FFFC      DBF        D0,$0AE0                       ; loop
0AE6: 30D9          MOVE.W     (A1)+,(A0)+
0AE8: 600E          BRA.S      $0AF8
0AEA: 4878004A      PEA        $004A.W
0AEE: 486EFFB6      PEA        -74(A6)
0AF2: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0AF6: 508F          MOVE.B     A7,(A0)
0AF8: 4267          CLR.W      -(A7)
0AFA: 42A7          CLR.L      -(A7)
0AFC: 486EFFB6      PEA        -74(A6)
0B00: 4EAD0612      JSR        1554(A5)                       ; JT[1554]
0B04: 4A2EFFB6      TST.B      -74(A6)
0B08: 4FEF000A      LEA        10(A7),A7
0B0C: 6720          BEQ.S      $0B2E
0B0E: 41EDD720      LEA        -10464(A5),A0                  ; g_state3
0B12: 43EEFFB6      LEA        -74(A6),A1
0B16: 7011          MOVEQ      #17,D0
0B18: 20D9          MOVE.L     (A1)+,(A0)+
0B1A: 51C8FFFC      DBF        D0,$0B18                       ; loop
0B1E: 30D9          MOVE.W     (A1)+,(A0)+
0B20: 486EFFC0      PEA        -64(A6)
0B24: 3F2EFFBC      MOVE.W     -68(A6),-(A7)
0B28: 4EAD05A2      JSR        1442(A5)                       ; JT[1442]
0B2C: 5C8F          MOVE.B     A7,(A6)
0B2E: 7000          MOVEQ      #0,D0
0B30: 102EFFB6      MOVE.B     -74(A6),D0
0B34: 4E5E          UNLK       A6
0B36: 4E75          RTS        
