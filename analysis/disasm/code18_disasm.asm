;======================================================================
; CODE 18 Disassembly
; File: /tmp/maven_code_18.bin
; Header: JT offset=816, JT entries=4
; Code size: 4460 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FFE8      LINK       A6,#-24                        ; frame=24
0004: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
0008: 266E0008      MOVEA.L    8(A6),A3
000C: 286E000C      MOVEA.L    12(A6),A4
0010: 4A2C0020      TST.B      32(A4)
0014: 6730          BEQ.S      $0046
0016: 2F0C          MOVE.L     A4,-(A7)
0018: 2F0C          MOVE.L     A4,-(A7)
001A: 2F2E0010      MOVE.L     16(A6),-(A7)
001E: 2F0C          MOVE.L     A4,-(A7)
0020: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
0024: 4A40          TST.W      D0
0026: 508F          MOVE.B     A7,(A0)
0028: 6708          BEQ.S      $0032
002A: 41EDE9D2      LEA        -5678(A5),A0                   ; A5-5678
002E: 2008          MOVE.L     A0,D0
0030: 6006          BRA.S      $0038
0032: 41EDE9D6      LEA        -5674(A5),A0                   ; A5-5674
0036: 2008          MOVE.L     A0,D0
0038: 2F00          MOVE.L     D0,-(A7)
003A: 2F0B          MOVE.L     A3,-(A7)
003C: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0040: 4FEF0010      LEA        16(A7),A7
0044: 6044          BRA.S      $008A
0046: 4A14          TST.B      (A4)
0048: 660E          BNE.S      $0058
004A: 486DE9DC      PEA        -5668(A5)                      ; A5-5668
004E: 2F0B          MOVE.L     A3,-(A7)
0050: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0054: 508F          MOVE.B     A7,(A0)
0056: 6032          BRA.S      $008A
0058: 206E0010      MOVEA.L    16(A6),A0
005C: 4A280020      TST.B      32(A0)
0060: 661C          BNE.S      $007E
0062: 2F0C          MOVE.L     A4,-(A7)
0064: 486EFFE8      PEA        -24(A6)
0068: 4EAD07EA      JSR        2026(A5)                       ; JT[2026]
006C: 2E80          MOVE.L     D0,(A7)
006E: 486DE9E4      PEA        -5660(A5)                      ; A5-5660
0072: 2F0B          MOVE.L     A3,-(A7)
0074: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0078: 4FEF0010      LEA        16(A7),A7
007C: 600C          BRA.S      $008A
007E: 486DE9F0      PEA        -5648(A5)                      ; A5-5648
0082: 2F0B          MOVE.L     A3,-(A7)
0084: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0088: 508F          MOVE.B     A7,(A0)
008A: 200B          MOVE.L     A3,D0
008C: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
0090: 4E5E          UNLK       A6
0092: 4E75          RTS        


; ======= Function at 0x0094 =======
0094: 4E56FF5C      LINK       A6,#-164                       ; frame=164
0098: 48E71F00      MOVEM.L    D3/D4/D5/D6/D7,-(SP)           ; save
009C: 3E2E0008      MOVE.W     8(A6),D7
00A0: 4A47          TST.W      D7
00A2: 6604          BNE.S      $00A8
00A4: 4EAD01A2      JSR        418(A5)                        ; JT[418]
00A8: 486EFF70      PEA        -144(A6)
00AC: 4EAD095A      JSR        2394(A5)                       ; JT[2394]
00B0: 0C474E20      CMPI.W     #$4E20,D7
00B4: 588F          MOVE.B     A7,(A4)
00B6: 662A          BNE.S      $00E2
00B8: 4A6E000C      TST.W      12(A6)
00BC: 670A          BEQ.S      $00C8
00BE: 41EDE9FC      LEA        -5636(A5),A0                   ; A5-5636
00C2: 2008          MOVE.L     A0,D0
00C4: 600004D4      BRA.W      $059C
00C8: 4A6E000A      TST.W      10(A6)
00CC: 6F0A          BLE.S      $00D8
00CE: 41EDEA28      LEA        -5592(A5),A0                   ; A5-5592
00D2: 2008          MOVE.L     A0,D0
00D4: 600004C4      BRA.W      $059C
00D8: 41EDEA4E      LEA        -5554(A5),A0                   ; A5-5554
00DC: 2008          MOVE.L     A0,D0
00DE: 600004BA      BRA.W      $059C
00E2: 0C478001      CMPI.W     #$8001,D7
00E6: 660A          BNE.S      $00F2
00E8: 41EDEA74      LEA        -5516(A5),A0                   ; A5-5516
00EC: 2008          MOVE.L     A0,D0
00EE: 600004AA      BRA.W      $059C
00F2: 0C47FFFF      CMPI.W     #$FFFF,D7
00F6: 660A          BNE.S      $0102
00F8: 41EDEA7A      LEA        -5510(A5),A0                   ; A5-5510
00FC: 2008          MOVE.L     A0,D0
00FE: 6000049A      BRA.W      $059C
0102: 0C47FFFE      CMPI.W     #$FFFE,D7
0106: 660A          BNE.S      $0112
0108: 41EDEA92      LEA        -5486(A5),A0                   ; A5-5486
010C: 2008          MOVE.L     A0,D0
010E: 6000048A      BRA.W      $059C
0112: 0C47FFE0      CMPI.W     #$FFE0,D7
0116: 660A          BNE.S      $0122
0118: 41EDEAAA      LEA        -5462(A5),A0                   ; A5-5462
011C: 2008          MOVE.L     A0,D0
011E: 6000047A      BRA.W      $059C
0122: 0C47FFDF      CMPI.W     #$FFDF,D7
0126: 660A          BNE.S      $0132
0128: 41EDEABA      LEA        -5446(A5),A0                   ; A5-5446
012C: 2008          MOVE.L     A0,D0
012E: 6000046A      BRA.W      $059C
0132: 0C47FFFD      CMPI.W     #$FFFD,D7
0136: 661A          BNE.S      $0152
0138: 4A6E000C      TST.W      12(A6)
013C: 670A          BEQ.S      $0148
013E: 41EDEACA      LEA        -5430(A5),A0                   ; A5-5430
0142: 2008          MOVE.L     A0,D0
0144: 60000454      BRA.W      $059C
0148: 41EDEB0A      LEA        -5366(A5),A0                   ; A5-5366
014C: 2008          MOVE.L     A0,D0
014E: 6000044A      BRA.W      $059C
0152: 0C4707DA      CMPI.W     #$07DA,D7
0156: 660A          BNE.S      $0162
0158: 41EDEB26      LEA        -5338(A5),A0                   ; A5-5338
015C: 2008          MOVE.L     A0,D0
015E: 6000043A      BRA.W      $059C
0162: 0C47FFFC      CMPI.W     #$FFFC,D7
0166: 660A          BNE.S      $0172
0168: 41EDEB3C      LEA        -5316(A5),A0                   ; A5-5316
016C: 2008          MOVE.L     A0,D0
016E: 6000042A      BRA.W      $059C
0172: 0C47FFFB      CMPI.W     #$FFFB,D7
0176: 6E00008C      BGT.W      $0206
017A: 0C47FFE1      CMPI.W     #$FFE1,D7
017E: 6D000084      BLT.W      $0206
0182: 70FB          MOVEQ      #-5,D0
0184: 9047          MOVEA.B    D7,A0
0186: 206D99D2      MOVEA.L    -26158(A5),A0
018A: 10300000      MOVE.B     0(A0,D0.W),D0
018E: 4880          EXT.W      D0
0190: 224E          MOVEA.L    A6,A1
0192: D2C0          MOVE.B     D0,(A1)+
0194: 4A29FF70      TST.B      -144(A1)
0198: 662A          BNE.S      $01C4
019A: 70FB          MOVEQ      #-5,D0
019C: 9047          MOVEA.B    D7,A0
019E: 206D99D2      MOVEA.L    -26158(A5),A0
01A2: 10300000      MOVE.B     0(A0,D0.W),D0
01A6: 4880          EXT.W      D0
01A8: 3F00          MOVE.W     D0,-(A7)
01AA: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
01AE: 3E80          MOVE.W     D0,(A7)
01B0: 486DEB60      PEA        -5280(A5)                      ; A5-5280
01B4: 486DE972      PEA        -5774(A5)                      ; A5-5774
01B8: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
01BC: 4FEF000A      LEA        10(A7),A7
01C0: 600003D2      BRA.W      $0596
01C4: 70FB          MOVEQ      #-5,D0
01C6: 9047          MOVEA.B    D7,A0
01C8: 206D99D2      MOVEA.L    -26158(A5),A0
01CC: 10300000      MOVE.B     0(A0,D0.W),D0
01D0: 4880          EXT.W      D0
01D2: 3F00          MOVE.W     D0,-(A7)
01D4: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
01D8: 3E80          MOVE.W     D0,(A7)
01DA: 4A6E000A      TST.W      10(A6)
01DE: 6F08          BLE.S      $01E8
01E0: 41EDEB74      LEA        -5260(A5),A0                   ; A5-5260
01E4: 2008          MOVE.L     A0,D0
01E6: 6006          BRA.S      $01EE
01E8: 41EDEB78      LEA        -5256(A5),A0                   ; A5-5256
01EC: 2008          MOVE.L     A0,D0
01EE: 2F00          MOVE.L     D0,-(A7)
01F0: 486DEB7E      PEA        -5250(A5)                      ; A5-5250
01F4: 486DE972      PEA        -5774(A5)                      ; A5-5774
01F8: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
01FC: 4FEF000E      LEA        14(A7),A7
0200: 60000392      BRA.W      $0596
0204: 2007          MOVE.L     D7,D0
0206: 48C0          EXT.L      D0
0208: E788206D      MOVE.L     A0,109(A3,D2.W)
020C: D55A4A30      MOVE.B     (A2)+,18992(A2)
0210: 08066632      BTST       #26162,D6
0214: 2007          MOVE.L     D7,D0
0216: 48C0          EXT.L      D0
0218: E788206D      MOVE.L     A0,109(A3,D2.W)
021C: D55A3070      MOVE.B     (A2)+,12400(A2)
0220: 0802D1ED      BTST       #53741,D2
0224: D5602F08      MOVE.B     -(A0),12040(A2)
0228: 486EFFF0      PEA        -16(A6)
022C: 4EAD07EA      JSR        2026(A5)                       ; JT[2026]
0230: 2E80          MOVE.L     D0,(A7)
0232: 486DEB94      PEA        -5228(A5)                      ; A5-5228
0236: 486DE972      PEA        -5774(A5)                      ; A5-5774
023A: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
023E: 4FEF0010      LEA        16(A7),A7
0242: 60000350      BRA.W      $0596
0246: 7C00          MOVEQ      #0,D6
0248: 3606          MOVE.W     D6,D3
024A: 3A06          MOVE.W     D6,D5
024C: 3806          MOVE.W     D6,D4
024E: 3D47FF60      MOVE.W     D7,-160(A6)
0252: 604E          BRA.S      $02A2
0254: 302EFF60      MOVE.W     -160(A6),D0
0258: 48C0          EXT.L      D0
025A: E788206D      MOVE.L     A0,109(A3,D2.W)
025E: D55A1030      MOVE.B     (A2)+,4144(A2)
0262: 08064880      BTST       #18560,D6
0266: 3D40FF66      MOVE.W     D0,-154(A6)
026A: 322EFF60      MOVE.W     -160(A6),D1
026E: 48C1          EXT.L      D1
0270: E7891230      MOVE.L     A1,48(A3,D1.W*2)
0274: 1807          MOVE.B     D7,D4
0276: 4881          EXT.W      D1
0278: 3D41FF68      MOVE.W     D1,-152(A6)
027C: BA40          MOVEA.W    D0,A5
027E: 6C04          BGE.S      $0284
0280: 3A2EFF66      MOVE.W     -154(A6),D5
0284: B86EFF66      MOVEA.W    -154(A6),A4
0288: 6F04          BLE.S      $028E
028A: 382EFF66      MOVE.W     -154(A6),D4
028E: BC6EFF68      MOVEA.W    -152(A6),A6
0292: 6C04          BGE.S      $0298
0294: 3C2EFF68      MOVE.W     -152(A6),D6
0298: B66EFF68      MOVEA.W    -152(A6),A3
029C: 6F04          BLE.S      $02A2
029E: 362EFF68      MOVE.W     -152(A6),D3
02A2: 302EFF60      MOVE.W     -160(A6),D0
02A6: 48C0          EXT.L      D0
02A8: E788D0AD      MOVE.L     A0,-83(A3,A5.W)
02AC: D55A2040      MOVE.B     (A2)+,8256(A2)
02B0: 3D50FF60      MOVE.W     (A0),-160(A6)
02B4: 669E          BNE.S      $0254
02B6: 2007          MOVE.L     D7,D0
02B8: 48C0          EXT.L      D0
02BA: E788206D      MOVE.L     A0,109(A3,D2.W)
02BE: D55A1030      MOVE.B     (A2)+,4144(A2)
02C2: 08074880      BTST       #18560,D7
02C6: D046          MOVEA.B    D6,A0
02C8: 0C40000F      CMPI.W     #$000F,D0
02CC: 6602          BNE.S      $02D0
02CE: 5246          MOVEA.B    D6,A1
02D0: 2007          MOVE.L     D7,D0
02D2: 48C0          EXT.L      D0
02D4: E788206D      MOVE.L     A0,109(A3,D2.W)
02D8: D55A1030      MOVE.B     (A2)+,4144(A2)
02DC: 08074880      BTST       #18560,D7
02E0: D043          MOVEA.B    D3,A0
02E2: 53406602      MOVE.B     D0,26114(A1)
02E6: 53432007      MOVE.B     D3,8199(A1)
02EA: 48C0          EXT.L      D0
02EC: E788206D      MOVE.L     A0,109(A3,D2.W)
02F0: D55A1030      MOVE.B     (A2)+,4144(A2)
02F4: 08064880      BTST       #18560,D6
02F8: D045          MOVEA.B    D5,A0
02FA: 0C40000F      CMPI.W     #$000F,D0
02FE: 6602          BNE.S      $0302
0300: 5245          MOVEA.B    D5,A1
0302: 2007          MOVE.L     D7,D0
0304: 48C0          EXT.L      D0
0306: E788206D      MOVE.L     A0,109(A3,D2.W)
030A: D55A1030      MOVE.B     (A2)+,4144(A2)
030E: 08064880      BTST       #18560,D6
0312: D044          MOVEA.B    D4,A0
0314: 53406602      MOVE.B     D0,26114(A1)
0318: 53443005      MOVE.B     D4,12293(A1)
031C: 9044          MOVEA.B    D4,A0
031E: 3206          MOVE.W     D6,D1
0320: 9243          MOVEA.B    D3,A1
0322: B240          MOVEA.W    D0,A1
0324: 6C000128      BGE.W      $0450
0328: 3006          MOVE.W     D6,D0
032A: 9043          MOVEA.B    D3,A0
032C: 67000254      BEQ.W      $0584
0330: 6B000250      BMI.W      $0584
0334: 57406734      MOVE.B     D0,26420(A3)
0338: 6A000248      BPL.W      $0584
033C: 5240          MOVEA.B    D0,A1
033E: 6A16          BPL.S      $0356
0340: 2007          MOVE.L     D7,D0
0342: 48C0          EXT.L      D0
0344: E788206D      MOVE.L     A0,109(A3,D2.W)
0348: D55A1030      MOVE.B     (A2)+,4144(A2)
034C: 08074880      BTST       #18560,D7
0350: 3D40FF62      MOVE.W     D0,-158(A6)
0354: 6052          BRA.S      $03A8
0356: 2007          MOVE.L     D7,D0
0358: 48C0          EXT.L      D0
035A: E788206D      MOVE.L     A0,109(A3,D2.W)
035E: D55A1030      MOVE.B     (A2)+,4144(A2)
0362: 08074880      BTST       #18560,D7
0366: 3D40FF62      MOVE.W     D0,-158(A6)
036A: 603C          BRA.S      $03A8
036C: 0C43FFFF      CMPI.W     #$FFFF,D3
0370: 6618          BNE.S      $038A
0372: 2007          MOVE.L     D7,D0
0374: 48C0          EXT.L      D0
0376: E788206D      MOVE.L     A0,109(A3,D2.W)
037A: D55A1030      MOVE.B     (A2)+,4144(A2)
037E: 08074880      BTST       #18560,D7
0382: 5240          MOVEA.B    D0,A1
0384: 3D40FF62      MOVE.W     D0,-158(A6)
0388: 601E          BRA.S      $03A8
038A: 0C43FFFE      CMPI.W     #$FFFE,D3
038E: 660001F2      BNE.W      $0584
0392: 2007          MOVE.L     D7,D0
0394: 48C0          EXT.L      D0
0396: E788206D      MOVE.L     A0,109(A3,D2.W)
039A: D55A1030      MOVE.B     (A2)+,4144(A2)
039E: 08074880      BTST       #18560,D7
03A2: 53403D40      MOVE.B     D0,15680(A1)
03A6: FF62066E      MOVE.W     -(A2),1646(A7)
03AA: 0040FF62      ORI.W      #$FF62,D0
03AE: 2007          MOVE.L     D7,D0
03B0: 48C0          EXT.L      D0
03B2: E788206D      MOVE.L     A0,109(A3,D2.W)
03B6: D55A1030      MOVE.B     (A2)+,4144(A2)
03BA: 08074880      BTST       #18560,D7
03BE: D046          MOVEA.B    D6,A0
03C0: 0C400010      CMPI.W     #$0010,D0
03C4: 6602          BNE.S      $03C8
03C6: 53462007      MOVE.B     D6,8199(A1)
03CA: 48C0          EXT.L      D0
03CC: E788206D      MOVE.L     A0,109(A3,D2.W)
03D0: D55A1030      MOVE.B     (A2)+,4144(A2)
03D4: 08074880      BTST       #18560,D7
03D8: D043          MOVEA.B    D3,A0
03DA: 6602          BNE.S      $03DE
03DC: 5243          MOVEA.B    D3,A1
03DE: 2007          MOVE.L     D7,D0
03E0: 48C0          EXT.L      D0
03E2: E788206D      MOVE.L     A0,109(A3,D2.W)
03E6: D55A1030      MOVE.B     (A2)+,4144(A2)
03EA: 08064880      BTST       #18560,D6
03EE: D045          MOVEA.B    D5,A0
03F0: 0C400010      CMPI.W     #$0010,D0
03F4: 6602          BNE.S      $03F8
03F6: 53452007      MOVE.B     D5,8199(A1)
03FA: 48C0          EXT.L      D0
03FC: E788206D      MOVE.L     A0,109(A3,D2.W)
0400: D55A1030      MOVE.B     (A2)+,4144(A2)
0404: 08064880      BTST       #18560,D6
0408: D044          MOVEA.B    D4,A0
040A: 6602          BNE.S      $040E
040C: 5244          MOVEA.B    D4,A1
040E: 2007          MOVE.L     D7,D0
0410: 48C0          EXT.L      D0
0412: E788206D      MOVE.L     A0,109(A3,D2.W)
0416: D55A1030      MOVE.B     (A2)+,4144(A2)
041A: 08064880      BTST       #18560,D6
041E: D045          MOVEA.B    D5,A0
0420: 3F00          MOVE.W     D0,-(A7)
0422: 3F2EFF62      MOVE.W     -158(A6),-(A7)
0426: 2007          MOVE.L     D7,D0
0428: 48C0          EXT.L      D0
042A: E7881030      MOVE.L     A0,48(A3,D1.W)
042E: 08064880      BTST       #18560,D6
0432: D044          MOVEA.B    D4,A0
0434: 3F00          MOVE.W     D0,-(A7)
0436: 3F2EFF62      MOVE.W     -158(A6),-(A7)
043A: 486DEBA2      PEA        -5214(A5)                      ; A5-5214
043E: 486DE972      PEA        -5774(A5)                      ; A5-5774
0442: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0446: 4FEF0010      LEA        16(A7),A7
044A: 60000148      BRA.W      $0596
044E: 3005          MOVE.W     D5,D0
0450: 9044          MOVEA.B    D4,A0
0452: 3206          MOVE.W     D6,D1
0454: 9243          MOVEA.B    D3,A1
0456: B240          MOVEA.W    D0,A1
0458: 6D000128      BLT.W      $0584
045C: 3005          MOVE.W     D5,D0
045E: 9044          MOVEA.B    D4,A0
0460: 67000120      BEQ.W      $0584
0464: 6B00011C      BMI.W      $0584
0468: 57406734      MOVE.B     D0,26420(A3)
046C: 6A000114      BPL.W      $0584
0470: 5240          MOVEA.B    D0,A1
0472: 6A16          BPL.S      $048A
0474: 2007          MOVE.L     D7,D0
0476: 48C0          EXT.L      D0
0478: E788206D      MOVE.L     A0,109(A3,D2.W)
047C: D55A1030      MOVE.B     (A2)+,4144(A2)
0480: 08064880      BTST       #18560,D6
0484: 3D40FF64      MOVE.W     D0,-156(A6)
0488: 6052          BRA.S      $04DC
048A: 2007          MOVE.L     D7,D0
048C: 48C0          EXT.L      D0
048E: E788206D      MOVE.L     A0,109(A3,D2.W)
0492: D55A1030      MOVE.B     (A2)+,4144(A2)
0496: 08064880      BTST       #18560,D6
049A: 3D40FF64      MOVE.W     D0,-156(A6)
049E: 603C          BRA.S      $04DC
04A0: 0C44FFFF      CMPI.W     #$FFFF,D4
04A4: 6618          BNE.S      $04BE
04A6: 2007          MOVE.L     D7,D0
04A8: 48C0          EXT.L      D0
04AA: E788206D      MOVE.L     A0,109(A3,D2.W)
04AE: D55A1030      MOVE.B     (A2)+,4144(A2)
04B2: 08064880      BTST       #18560,D6
04B6: 5240          MOVEA.B    D0,A1
04B8: 3D40FF64      MOVE.W     D0,-156(A6)
04BC: 601E          BRA.S      $04DC
04BE: 0C44FFFE      CMPI.W     #$FFFE,D4
04C2: 660000BE      BNE.W      $0584
04C6: 2007          MOVE.L     D7,D0
04C8: 48C0          EXT.L      D0
04CA: E788206D      MOVE.L     A0,109(A3,D2.W)
04CE: D55A1030      MOVE.B     (A2)+,4144(A2)
04D2: 08064880      BTST       #18560,D6
04D6: 53403D40      MOVE.B     D0,15680(A1)
04DA: FF642007      MOVE.W     -(A4),8199(A7)
04DE: 48C0          EXT.L      D0
04E0: E788206D      MOVE.L     A0,109(A3,D2.W)
04E4: D55A1030      MOVE.B     (A2)+,4144(A2)
04E8: 08074880      BTST       #18560,D7
04EC: D046          MOVEA.B    D6,A0
04EE: 0C400010      CMPI.W     #$0010,D0
04F2: 6602          BNE.S      $04F6
04F4: 53462007      MOVE.B     D6,8199(A1)
04F8: 48C0          EXT.L      D0
04FA: E788206D      MOVE.L     A0,109(A3,D2.W)
04FE: D55A1030      MOVE.B     (A2)+,4144(A2)
0502: 08074880      BTST       #18560,D7
0506: D043          MOVEA.B    D3,A0
0508: 6602          BNE.S      $050C
050A: 5243          MOVEA.B    D3,A1
050C: 2007          MOVE.L     D7,D0
050E: 48C0          EXT.L      D0
0510: E788206D      MOVE.L     A0,109(A3,D2.W)
0514: D55A1030      MOVE.B     (A2)+,4144(A2)
0518: 08064880      BTST       #18560,D6
051C: D045          MOVEA.B    D5,A0
051E: 0C400010      CMPI.W     #$0010,D0
0522: 6602          BNE.S      $0526
0524: 53452007      MOVE.B     D5,8199(A1)
0528: 48C0          EXT.L      D0
052A: E788206D      MOVE.L     A0,109(A3,D2.W)
052E: D55A1030      MOVE.B     (A2)+,4144(A2)
0532: 08064880      BTST       #18560,D6
0536: D044          MOVEA.B    D4,A0
0538: 6602          BNE.S      $053C
053A: 5244          MOVEA.B    D4,A1
053C: 2007          MOVE.L     D7,D0
053E: 48C0          EXT.L      D0
0540: E788206D      MOVE.L     A0,109(A3,D2.W)
0544: D55A1030      MOVE.B     (A2)+,4144(A2)
0548: 08074880      BTST       #18560,D7
054C: D046          MOVEA.B    D6,A0
054E: 06400040      ADDI.W     #$0040,D0
0552: 3F00          MOVE.W     D0,-(A7)
0554: 3F2EFF64      MOVE.W     -156(A6),-(A7)
0558: 2007          MOVE.L     D7,D0
055A: 48C0          EXT.L      D0
055C: E7881030      MOVE.L     A0,48(A3,D1.W)
0560: 08074880      BTST       #18560,D7
0564: D043          MOVEA.B    D3,A0
0566: 06400040      ADDI.W     #$0040,D0
056A: 3F00          MOVE.W     D0,-(A7)
056C: 3F2EFF64      MOVE.W     -156(A6),-(A7)
0570: 486DEBB8      PEA        -5192(A5)                      ; A5-5192
0574: 486DE972      PEA        -5774(A5)                      ; A5-5774
0578: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
057C: 4FEF0010      LEA        16(A7),A7
0580: 6012          BRA.S      $0594
0582: 3F07          MOVE.W     D7,-(A7)
0584: 486DEBCE      PEA        -5170(A5)                      ; A5-5170
0588: 486DE972      PEA        -5774(A5)                      ; A5-5774
058C: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0590: 4FEF000A      LEA        10(A7),A7
0594: 41EDE972      LEA        -5774(A5),A0                   ; A5-5774
0598: 2008          MOVE.L     A0,D0
059A: 4CDF00F8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7           ; restore
059E: 4E5E          UNLK       A6
05A0: 4E75          RTS        


; ======= Function at 0x05A2 =======
05A2: 4E560000      LINK       A6,#0
05A6: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
05AA: 3C2E0008      MOVE.W     8(A6),D6
05AE: 2006          MOVE.L     D6,D0
05B0: 48C0          EXT.L      D0
05B2: 81FC0064C1FC  ORA.L      #$0064C1FC,A0
05B8: 00643E06      ORI.W      #$3E06,-(A4)
05BC: 9E40          MOVEA.B    D0,A7
05BE: 4A47          TST.W      D7
05C0: 6D06          BLT.S      $05C8
05C2: 0C470064      CMPI.W     #$0064,D7
05C6: 6D04          BLT.S      $05CC
05C8: 4EAD01A2      JSR        418(A5)                        ; JT[418]
05CC: 0C470002      CMPI.W     #$0002,D7
05D0: 6C0E          BGE.S      $05E0
05D2: 0C460001      CMPI.W     #$0001,D6
05D6: 6F08          BLE.S      $05E0
05D8: 49EDEBD8      LEA        -5160(A5),A4                   ; A5-5160
05DC: 6000009C      BRA.W      $067C
05E0: 4A46          TST.W      D6
05E2: 6C06          BGE.S      $05EA
05E4: 3006          MOVE.W     D6,D0
05E6: 4440          NEG.W      D0
05E8: 6002          BRA.S      $05EC
05EA: 3006          MOVE.W     D6,D0
05EC: 0C40000A      CMPI.W     #$000A,D0
05F0: 6C08          BGE.S      $05FA
05F2: 49EDEBE6      LEA        -5146(A5),A4                   ; A5-5146
05F6: 60000082      BRA.W      $067C
05FA: 4A46          TST.W      D6
05FC: 6C06          BGE.S      $0604
05FE: 3006          MOVE.W     D6,D0
0600: 4440          NEG.W      D0
0602: 6002          BRA.S      $0606
0604: 3006          MOVE.W     D6,D0
0606: 0C40001E      CMPI.W     #$001E,D0
060A: 6C06          BGE.S      $0612
060C: 49EDEBF0      LEA        -5136(A5),A4                   ; A5-5136
0610: 6068          BRA.S      $067A
0612: 4A46          TST.W      D6
0614: 6C06          BGE.S      $061C
0616: 3006          MOVE.W     D6,D0
0618: 4440          NEG.W      D0
061A: 6002          BRA.S      $061E
061C: 3006          MOVE.W     D6,D0
061E: 0C400032      CMPI.W     #$0032,D0
0622: 6C06          BGE.S      $062A
0624: 49EDEBFA      LEA        -5126(A5),A4                   ; A5-5126
0628: 6050          BRA.S      $067A
062A: 0C47000A      CMPI.W     #$000A,D7
062E: 6C06          BGE.S      $0636
0630: 49EDEC04      LEA        -5116(A5),A4                   ; A5-5116
0634: 6044          BRA.S      $067A
0636: 0C470019      CMPI.W     #$0019,D7
063A: 6C06          BGE.S      $0642
063C: 49EDEC1C      LEA        -5092(A5),A4                   ; A5-5092
0640: 6038          BRA.S      $067A
0642: 0C470030      CMPI.W     #$0030,D7
0646: 6C06          BGE.S      $064E
0648: 49EDEC34      LEA        -5068(A5),A4                   ; A5-5068
064C: 602C          BRA.S      $067A
064E: 0C470034      CMPI.W     #$0034,D7
0652: 6C06          BGE.S      $065A
0654: 49EDEC4A      LEA        -5046(A5),A4                   ; A5-5046
0658: 6020          BRA.S      $067A
065A: 0C47003C      CMPI.W     #$003C,D7
065E: 6C06          BGE.S      $0666
0660: 49EDEC5A      LEA        -5030(A5),A4                   ; A5-5030
0664: 6014          BRA.S      $067A
0666: 0C47004B      CMPI.W     #$004B,D7
066A: 6C06          BGE.S      $0672
066C: 49EDEC74      LEA        -5004(A5),A4                   ; A5-5004
0670: 6008          BRA.S      $067A
0672: 06460064      ADDI.W     #$0064,D6
0676: 49EDEC8E      LEA        -4978(A5),A4                   ; A5-4978
067A: 2E06          MOVE.L     D6,D7
067C: 48C7          EXT.L      D7
067E: 8FFC00640C47  ORA.L      #$00640C47,A7
0684: 00016608      ORI.B      #$6608,D1
0688: 41EDECA4      LEA        -4956(A5),A0                   ; A5-4956
068C: 2008          MOVE.L     A0,D0
068E: 6006          BRA.S      $0696
0690: 41EDECA6      LEA        -4954(A5),A0                   ; A5-4954
0694: 2008          MOVE.L     A0,D0
0696: 2F00          MOVE.L     D0,-(A7)
0698: 3F07          MOVE.W     D7,-(A7)
069A: 2F0C          MOVE.L     A4,-(A7)
069C: 486DE9B2      PEA        -5710(A5)                      ; A5-5710
06A0: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
06A4: 41EDE9B2      LEA        -5710(A5),A0                   ; A5-5710
06A8: 2008          MOVE.L     A0,D0
06AA: 4CEE10C0FFF4  MOVEM.L    -12(A6),D6/D7/A4
06B0: 4E5E          UNLK       A6
06B2: 4E75          RTS        


; ======= Function at 0x06B4 =======
06B4: 4E560000      LINK       A6,#0
06B8: 4A6E0008      TST.W      8(A6)
06BC: 6C38          BGE.S      $06F6
06BE: 4EAD05B2      JSR        1458(A5)                       ; JT[1458]
06C2: 48780003      PEA        $0003.W
06C6: 2F00          MOVE.L     D0,-(A7)
06C8: 4EAD0052      JSR        82(A5)                         ; JT[82]
06CC: 4A80          TST.L      D0
06CE: 670A          BEQ.S      $06DA
06D0: 6B20          BMI.S      $06F2
06D2: 55806714      MOVE.B     D0,20(A2,D6.W*8)
06D6: 6A1A          BPL.S      $06F2
06D8: 6008          BRA.S      $06E2
06DA: 41EDECA8      LEA        -4952(A5),A0                   ; A5-4952
06DE: 2008          MOVE.L     A0,D0
06E0: 603A          BRA.S      $071C
06E2: 41EDECAE      LEA        -4946(A5),A0                   ; A5-4946
06E6: 2008          MOVE.L     A0,D0
06E8: 6032          BRA.S      $071C
06EA: 41EDECB8      LEA        -4936(A5),A0                   ; A5-4936
06EE: 2008          MOVE.L     A0,D0
06F0: 602A          BRA.S      $071C
06F2: 4EAD01A2      JSR        418(A5)                        ; JT[418]
06F6: 4EAD05B2      JSR        1458(A5)                       ; JT[1458]
06FA: 7201          MOVEQ      #1,D1
06FC: C280          AND.L      D0,D1
06FE: 6708          BEQ.S      $0708
0700: 6B16          BMI.S      $0718
0702: 55816A12      MOVE.B     D1,18(A2,D6.L*2)
0706: 6008          BRA.S      $0710
0708: 41EDECBE      LEA        -4930(A5),A0                   ; A5-4930
070C: 2008          MOVE.L     A0,D0
070E: 600C          BRA.S      $071C
0710: 41EDECC6      LEA        -4922(A5),A0                   ; A5-4922
0714: 2008          MOVE.L     A0,D0
0716: 6004          BRA.S      $071C
0718: 4EAD01A2      JSR        418(A5)                        ; JT[418]
071C: 4E5E          UNLK       A6
071E: 4E75          RTS        


; ======= Function at 0x0720 =======
0720: 4E560000      LINK       A6,#0
0724: 48E70F18      MOVEM.L    D4/D5/D6/D7/A3/A4,-(SP)        ; save
0728: 3E2E0008      MOVE.W     8(A6),D7
072C: 3C2E000A      MOVE.W     10(A6),D6
0730: 4A47          TST.W      D7
0732: 6604          BNE.S      $0738
0734: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0738: 4A46          TST.W      D6
073A: 6604          BNE.S      $0740
073C: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0740: 4A47          TST.W      D7
0742: 6F0001AC      BLE.W      $08F2
0746: BE6DD55E      MOVEA.W    -10914(A5),A7
074A: 6C0001A4      BGE.W      $08F2
074E: 2007          MOVE.L     D7,D0
0750: 48C0          EXT.L      D0
0752: E788206D      MOVE.L     A0,109(A3,D2.W)
0756: D55A4A30      MOVE.B     (A2)+,18992(A2)
075A: 08066654      BTST       #26196,D6
075E: 2007          MOVE.L     D7,D0
0760: 48C0          EXT.L      D0
0762: E788206D      MOVE.L     A0,109(A3,D2.W)
0766: D55A3070      MOVE.B     (A2)+,12400(A2)
076A: 0802D1ED      BTST       #53741,D2
076E: D5602F08      MOVE.B     -(A0),12040(A2)
0772: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0776: 5380588F      MOVE.B     D0,-113(A1,D5.L)
077A: 6636          BNE.S      $07B2
077C: 2007          MOVE.L     D7,D0
077E: 48C0          EXT.L      D0
0780: E788206D      MOVE.L     A0,109(A3,D2.W)
0784: D55A3070      MOVE.B     (A2)+,12400(A2)
0788: 0802D1ED      BTST       #53741,D2
078C: D5601010      MOVE.B     -(A0),4112(A2)
0790: 4880          EXT.W      D0
0792: 3F00          MOVE.W     D0,-(A7)
0794: 2F2D99D2      MOVE.L     -26158(A5),-(A7)               ; A5-26158
0798: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
079C: 90AD99D2      MOVE.B     -26158(A5),(A0)                ; A5-26158
07A0: 72FB          MOVEQ      #-5,D1
07A2: 9280          MOVE.B     D0,(A1)
07A4: 3046          MOVEA.W    D6,A0
07A6: B288          MOVE.W     A0,(A1)
07A8: 5C8F          MOVE.B     A7,(A6)
07AA: 6606          BNE.S      $07B2
07AC: 7001          MOVEQ      #1,D0
07AE: 60000142      BRA.W      $08F4
07B2: 2007          MOVE.L     D7,D0
07B4: 48C0          EXT.L      D0
07B6: E788206D      MOVE.L     A0,109(A3,D2.W)
07BA: D55A4A30      MOVE.B     (A2)+,18992(A2)
07BE: 08066662      BTST       #26210,D6
07C2: 4A46          TST.W      D6
07C4: 6F5E          BLE.S      $0824
07C6: BC6DD55E      MOVEA.W    -10914(A5),A6
07CA: 6C58          BGE.S      $0824
07CC: 2006          MOVE.L     D6,D0
07CE: 48C0          EXT.L      D0
07D0: E788206D      MOVE.L     A0,109(A3,D2.W)
07D4: D55A4A30      MOVE.B     (A2)+,18992(A2)
07D8: 08066648      BTST       #26184,D6
07DC: 2007          MOVE.L     D7,D0
07DE: 48C0          EXT.L      D0
07E0: E788206D      MOVE.L     A0,109(A3,D2.W)
07E4: D55A3870      MOVE.B     (A2)+,14448(A2)
07E8: 0802D9ED      BTST       #55789,D2
07EC: D5602006      MOVE.B     -(A0),8198(A2)
07F0: 48C0          EXT.L      D0
07F2: E7883670      MOVE.L     A0,112(A3,D3.W*8)
07F6: 0802D7ED      BTST       #55277,D2
07FA: D5606018      MOVE.B     -(A0),24600(A2)
07FE: 1013          MOVE.B     (A3),D0
0800: 4880          EXT.W      D0
0802: 3F00          MOVE.W     D0,-(A7)
0804: 2F0C          MOVE.L     A4,-(A7)
0806: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
080A: 2840          MOVEA.L    D0,A4
080C: 200C          MOVE.L     A4,D0
080E: 5C8F          MOVE.B     A7,(A6)
0810: 6708          BEQ.S      $081A
0812: 528B          MOVE.B     A3,(A1)
0814: 528C          MOVE.B     A4,(A1)
0816: 4A13          TST.B      (A3)
0818: 66E4          BNE.S      $07FE
081A: 200C          MOVE.L     A4,D0
081C: 6706          BEQ.S      $0824
081E: 7001          MOVEQ      #1,D0
0820: 600000D0      BRA.W      $08F4
0824: 2007          MOVE.L     D7,D0
0826: 48C0          EXT.L      D0
0828: E788206D      MOVE.L     A0,109(A3,D2.W)
082C: D55A4A30      MOVE.B     (A2)+,18992(A2)
0830: 08066700      BTST       #26368,D6
0834: 00BC4A466F0000B6BC6D  ORI.L      #$4A466F00,#$00B6BC6D
083E: D55E6C00      MOVE.B     (A6)+,27648(A2)
0842: 00AE200648C0E788  ORI.L      #$200648C0,-6264(A6)
084A: 206DD55A      MOVEA.L    -10918(A5),A0
084E: 4A300806      TST.B      6(A0,D0.L)
0852: 6700009C      BEQ.W      $08F2
0856: 2006          MOVE.L     D6,D0
0858: 48C0          EXT.L      D0
085A: E788206D      MOVE.L     A0,109(A3,D2.W)
085E: D55A2207      MOVE.B     (A2)+,8711(A2)
0862: 48C1          EXT.L      D1
0864: E7891230      MOVE.L     A1,48(A3,D1.W*2)
0868: 1806          MOVE.B     D6,D4
086A: B2300806      MOVE.W     6(A0,D0.L),D1
086E: 66000080      BNE.W      $08F2
0872: 2006          MOVE.L     D6,D0
0874: 48C0          EXT.L      D0
0876: E788206D      MOVE.L     A0,109(A3,D2.W)
087A: D55A2207      MOVE.B     (A2)+,8711(A2)
087E: 48C1          EXT.L      D1
0880: E7891230      MOVE.L     A1,48(A3,D1.W*2)
0884: 1807          MOVE.B     D7,D4
0886: B2300807      MOVE.W     7(A0,D0.L),D1
088A: 6664          BNE.S      $08F0
088C: 3A06          MOVE.W     D6,D5
088E: 604C          BRA.S      $08DC
0890: 3807          MOVE.W     D7,D4
0892: 6034          BRA.S      $08C8
0894: 2004          MOVE.L     D4,D0
0896: 48C0          EXT.L      D0
0898: E788206D      MOVE.L     A0,109(A3,D2.W)
089C: D55A2205      MOVE.B     (A2)+,8709(A2)
08A0: 48C1          EXT.L      D1
08A2: E7891230      MOVE.L     A1,48(A3,D1.W*2)
08A6: 1806          MOVE.B     D6,D4
08A8: B2300806      MOVE.W     6(A0,D0.L),D1
08AC: 661A          BNE.S      $08C8
08AE: 2004          MOVE.L     D4,D0
08B0: 48C0          EXT.L      D0
08B2: E788206D      MOVE.L     A0,109(A3,D2.W)
08B6: D55A2205      MOVE.B     (A2)+,8709(A2)
08BA: 48C1          EXT.L      D1
08BC: E7891230      MOVE.L     A1,48(A3,D1.W*2)
08C0: 1807          MOVE.B     D7,D4
08C2: B2300807      MOVE.W     7(A0,D0.L),D1
08C6: 6710          BEQ.S      $08D8
08C8: 2004          MOVE.L     D4,D0
08CA: 48C0          EXT.L      D0
08CC: E788D0AD      MOVE.L     A0,-83(A3,A5.W)
08D0: D55A2040      MOVE.B     (A2)+,8256(A2)
08D4: 3810          MOVE.W     (A0),D4
08D6: 66BC          BNE.S      $0894
08D8: 4A44          TST.W      D4
08DA: 6714          BEQ.S      $08F0
08DC: 2005          MOVE.L     D5,D0
08DE: 48C0          EXT.L      D0
08E0: E788D0AD      MOVE.L     A0,-83(A3,A5.W)
08E4: D55A2040      MOVE.B     (A2)+,8256(A2)
08E8: 3A10          MOVE.W     (A0),D5
08EA: 66A4          BNE.S      $0890
08EC: 7001          MOVEQ      #1,D0
08EE: 6002          BRA.S      $08F2
08F0: 7000          MOVEQ      #0,D0
08F2: 4CDF18F0      MOVEM.L    (SP)+,D4/D5/D6/D7/A3/A4        ; restore
08F6: 4E5E          UNLK       A6
08F8: 4E75          RTS        


; ======= Function at 0x08FA =======
08FA: 4E56FDDE      LINK       A6,#-546                       ; frame=546
08FE: 2F06          MOVE.L     D6,-(A7)
0900: 3C2E000C      MOVE.W     12(A6),D6
0904: 526DDE84      MOVEA.B    -8572(A5),A1
0908: 4A6E000A      TST.W      10(A6)
090C: 673C          BEQ.S      $094A
090E: 4A46          TST.W      D6
0910: 6C06          BGE.S      $0918
0912: 3006          MOVE.W     D6,D0
0914: 4440          NEG.W      D0
0916: 6002          BRA.S      $091A
0918: 3006          MOVE.W     D6,D0
091A: 3F00          MOVE.W     D0,-(A7)
091C: 4EBAFC84      JSR        -892(PC)
0920: 2F00          MOVE.L     D0,-(A7)
0922: 2F2E000E      MOVE.L     14(A6),-(A7)
0926: 3F2E000A      MOVE.W     10(A6),-(A7)
092A: 3F06          MOVE.W     D6,-(A7)
092C: 3F2E0008      MOVE.W     8(A6),-(A7)
0930: 4EBAF762      JSR        -2206(PC)
0934: 548F          MOVE.B     A7,(A2)
0936: 2E80          MOVE.L     D0,(A7)
0938: 486DECCC      PEA        -4916(A5)                      ; A5-4916
093C: 486EFE00      PEA        -512(A6)
0940: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0944: 4FEF0016      LEA        22(A7),A7
0948: 6044          BRA.S      $098E
094A: 4A46          TST.W      D6
094C: 6C06          BGE.S      $0954
094E: 3006          MOVE.W     D6,D0
0950: 4440          NEG.W      D0
0952: 6002          BRA.S      $0956
0954: 3006          MOVE.W     D6,D0
0956: 3F00          MOVE.W     D0,-(A7)
0958: 4EBAFC48      JSR        -952(PC)
095C: 2F00          MOVE.L     D0,-(A7)
095E: 2F2E000E      MOVE.L     14(A6),-(A7)
0962: 3F06          MOVE.W     D6,-(A7)
0964: 4EBAFD4E      JSR        -690(PC)
0968: 548F          MOVE.B     A7,(A2)
096A: 2F00          MOVE.L     D0,-(A7)
096C: 3F2E000A      MOVE.W     10(A6),-(A7)
0970: 3F06          MOVE.W     D6,-(A7)
0972: 3F2E0008      MOVE.W     8(A6),-(A7)
0976: 4EBAF71C      JSR        -2276(PC)
097A: 548F          MOVE.B     A7,(A2)
097C: 2E80          MOVE.L     D0,(A7)
097E: 486DECE6      PEA        -4890(A5)                      ; A5-4890
0982: 486EFE00      PEA        -512(A6)
0986: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
098A: 4FEF001A      LEA        26(A7),A7
098E: 486EFE00      PEA        -512(A6)
0992: 4EBA0326      JSR        806(PC)
0996: 2C2EFDDA      MOVE.L     -550(A6),D6
099A: 4E5E          UNLK       A6
099C: 4E75          RTS        


; ======= Function at 0x099E =======
099E: 4E560000      LINK       A6,#0
09A2: 3F2E0008      MOVE.W     8(A6),-(A7)
09A6: 4EAD09F2      JSR        2546(A5)                       ; JT[2546]
09AA: 4A40          TST.W      D0
09AC: 57C0          SEQ        D0
09AE: 4400          NEG.B      D0
09B0: 4880          EXT.W      D0
09B2: 4E5E          UNLK       A6
09B4: 4E75          RTS        


; ======= Function at 0x09B6 =======
09B6: 4E56FF00      LINK       A6,#-256                       ; frame=256
09BA: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
09BE: 206E0008      MOVEA.L    8(A6),A0
09C2: 2E280010      MOVE.L     16(A0),D7
09C6: 47E80010      LEA        16(A0),A3
09CA: 226E0018      MOVEA.L    24(A6),A1
09CE: 2C290010      MOVE.L     16(A1),D6
09D2: 49E90010      LEA        16(A1),A4
09D6: BC87          MOVE.W     D7,(A6)
09D8: 661C          BNE.S      $09F6
09DA: 486DDE9B      PEA        -8549(A5)                      ; A5-8549
09DE: 486DDE86      PEA        -8570(A5)                      ; A5-8570
09E2: 486DECF8      PEA        -4872(A5)                      ; A5-4872
09E6: 486EFF00      PEA        -256(A6)
09EA: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
09EE: 4FEF0010      LEA        16(A7),A7
09F2: 6000008C      BRA.W      $0A82
09F6: BC87          MOVE.W     D7,(A6)
09F8: 6C44          BGE.S      $0A3E
09FA: 2013          MOVE.L     (A3),D0
09FC: 9094          MOVE.B     (A4),(A0)
09FE: 7264          MOVEQ      #100,D1
0A00: B280          MOVE.W     D0,(A1)
0A02: 6608          BNE.S      $0A0C
0A04: 41EDED14      LEA        -4844(A5),A0                   ; A5-4844
0A08: 2008          MOVE.L     A0,D0
0A0A: 6006          BRA.S      $0A12
0A0C: 41EDED16      LEA        -4842(A5),A0                   ; A5-4842
0A10: 2008          MOVE.L     A0,D0
0A12: 2F00          MOVE.L     D0,-(A7)
0A14: 48780064      PEA        $0064.W
0A18: 2013          MOVE.L     (A3),D0
0A1A: 9094          MOVE.B     (A4),(A0)
0A1C: 2F00          MOVE.L     D0,-(A7)
0A1E: 4EAD005A      JSR        90(A5)                         ; JT[90]
0A22: 2F00          MOVE.L     D0,-(A7)
0A24: 486DDE9B      PEA        -8549(A5)                      ; A5-8549
0A28: 486DDE86      PEA        -8570(A5)                      ; A5-8570
0A2C: 486DED18      PEA        -4840(A5)                      ; A5-4840
0A30: 486EFF00      PEA        -256(A6)
0A34: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0A38: 4FEF0018      LEA        24(A7),A7
0A3C: 6042          BRA.S      $0A80
0A3E: 2014          MOVE.L     (A4),D0
0A40: 9093          MOVE.B     (A3),(A0)
0A42: 7264          MOVEQ      #100,D1
0A44: B280          MOVE.W     D0,(A1)
0A46: 6608          BNE.S      $0A50
0A48: 41EDED3A      LEA        -4806(A5),A0                   ; A5-4806
0A4C: 2008          MOVE.L     A0,D0
0A4E: 6006          BRA.S      $0A56
0A50: 41EDED3C      LEA        -4804(A5),A0                   ; A5-4804
0A54: 2008          MOVE.L     A0,D0
0A56: 2F00          MOVE.L     D0,-(A7)
0A58: 48780064      PEA        $0064.W
0A5C: 2014          MOVE.L     (A4),D0
0A5E: 9093          MOVE.B     (A3),(A0)
0A60: 2F00          MOVE.L     D0,-(A7)
0A62: 4EAD005A      JSR        90(A5)                         ; JT[90]
0A66: 2F00          MOVE.L     D0,-(A7)
0A68: 486DDE86      PEA        -8570(A5)                      ; A5-8570
0A6C: 486DDE9B      PEA        -8549(A5)                      ; A5-8549
0A70: 486DED3E      PEA        -4802(A5)                      ; A5-4802
0A74: 486EFF00      PEA        -256(A6)
0A78: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0A7C: 4FEF0018      LEA        24(A7),A7
0A80: 486EFF00      PEA        -256(A6)
0A84: 4EBA0234      JSR        564(PC)
0A88: 4CEE18C0FEF0  MOVEM.L    -272(A6),D6/D7/A3/A4
0A8E: 4E5E          UNLK       A6
0A90: 4E75          RTS        


; ======= Function at 0x0A92 =======
0A92: 4E56FDEA      LINK       A6,#-534                       ; frame=534
0A96: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0A9A: 2E2E000C      MOVE.L     12(A6),D7
0A9E: 7A00          MOVEQ      #0,D5
0AA0: 3605          MOVE.W     D5,D3
0AA2: 7C00          MOVEQ      #0,D6
0AA4: 99CC6022      MOVE.B     A4,#$22
0AA8: 244C          MOVEA.L    A4,A2
0AAA: D5EE00104A52  MOVE.B     16(A6),19026(PC)
0AB0: 6714          BEQ.S      $0AC6
0AB2: 3F347800      MOVE.W     0(A4,D7.L),-(A7)
0AB6: 206E0028      MOVEA.L    40(A6),A0
0ABA: 4E90          JSR        (A0)
0ABC: 4A40          TST.W      D0
0ABE: 548F          MOVE.B     A7,(A2)
0AC0: 6704          BEQ.S      $0AC6
0AC2: 5245          MOVEA.B    D5,A1
0AC4: D652          MOVEA.B    (A2),A3
0AC6: 5246          MOVEA.B    D6,A1
0AC8: 548C          MOVE.B     A4,(A2)
0ACA: 4A747800      TST.W      0(A4,D7.L)
0ACE: 66D8          BNE.S      $0AA8
0AD0: 7C00          MOVEQ      #0,D6
0AD2: 99CC6026      MOVE.B     A4,#$26
0AD6: 244C          MOVEA.L    A4,A2
0AD8: D5EE00204A52  MOVE.B     32(A6),19026(PC)
0ADE: 6718          BEQ.S      $0AF8
0AE0: 204C          MOVEA.L    A4,A0
0AE2: D1EE001C3F10  MOVE.B     28(A6),$3F10.W
0AE8: 206E0028      MOVEA.L    40(A6),A0
0AEC: 4E90          JSR        (A0)
0AEE: 4A40          TST.W      D0
0AF0: 548F          MOVE.B     A7,(A2)
0AF2: 6704          BEQ.S      $0AF8
0AF4: 5245          MOVEA.B    D5,A1
0AF6: 9652          MOVEA.B    (A2),A3
0AF8: 5246          MOVEA.B    D6,A1
0AFA: 548C          MOVE.B     A4,(A2)
0AFC: 204C          MOVEA.L    A4,A0
0AFE: D1EE001C4A50  MOVE.B     28(A6),$4A50.W
0B04: 66D0          BNE.S      $0AD6
0B06: 4A45          TST.W      D5
0B08: 662C          BNE.S      $0B36
0B0A: 4A43          TST.W      D3
0B0C: 6704          BEQ.S      $0B12
0B0E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0B12: 2F2E002C      MOVE.L     44(A6),-(A7)
0B16: 486DDE9B      PEA        -8549(A5)                      ; A5-8549
0B1A: 486DDE86      PEA        -8570(A5)                      ; A5-8570
0B1E: 486DED60      PEA        -4768(A5)                      ; A5-4768
0B22: 486EFDFE      PEA        -514(A6)
0B26: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0B2A: 486EFDFE      PEA        -514(A6)
0B2E: 4EBA018A      JSR        394(PC)
0B32: 6000009E      BRA.W      $0BD4
0B36: 2F2E0030      MOVE.L     48(A6),-(A7)
0B3A: 4A43          TST.W      D3
0B3C: 6F08          BLE.S      $0B46
0B3E: 41EDDE86      LEA        -8570(A5),A0                   ; A5-8570
0B42: 2008          MOVE.L     A0,D0
0B44: 6006          BRA.S      $0B4C
0B46: 41EDDE9B      LEA        -8549(A5),A0                   ; A5-8549
0B4A: 2008          MOVE.L     A0,D0
0B4C: 2F00          MOVE.L     D0,-(A7)
0B4E: 486DED70      PEA        -4752(A5)                      ; A5-4752
0B52: 486EFDFE      PEA        -514(A6)
0B56: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0B5A: 486EFDFE      PEA        -514(A6)
0B5E: 4EBA015A      JSR        346(PC)
0B62: 4A43          TST.W      D3
0B64: 4FEF0014      LEA        20(A7),A7
0B68: 6F10          BLE.S      $0B7A
0B6A: 49EDDE86      LEA        -8570(A5),A4                   ; A5-8570
0B6E: 2447          MOVEA.L    D7,A2
0B70: 266E0010      MOVEA.L    16(A6),A3
0B74: 282E0014      MOVE.L     20(A6),D4
0B78: 6010          BRA.S      $0B8A
0B7A: 49EDDE9B      LEA        -8549(A5),A4                   ; A5-8549
0B7E: 246E001C      MOVEA.L    28(A6),A2
0B82: 266E0020      MOVEA.L    32(A6),A3
0B86: 282E0024      MOVE.L     36(A6),D4
0B8A: 2F2E0028      MOVE.L     40(A6),-(A7)
0B8E: 2F04          MOVE.L     D4,-(A7)
0B90: 2F0B          MOVE.L     A3,-(A7)
0B92: 2F0A          MOVE.L     A2,-(A7)
0B94: 2F0C          MOVE.L     A4,-(A7)
0B96: 4EBA0044      JSR        68(PC)
0B9A: 4A43          TST.W      D3
0B9C: 4FEF0014      LEA        20(A7),A7
0BA0: 6E10          BGT.S      $0BB2
0BA2: 49EDDE86      LEA        -8570(A5),A4                   ; A5-8570
0BA6: 2447          MOVEA.L    D7,A2
0BA8: 266E0010      MOVEA.L    16(A6),A3
0BAC: 282E0014      MOVE.L     20(A6),D4
0BB0: 6010          BRA.S      $0BC2
0BB2: 49EDDE9B      LEA        -8549(A5),A4                   ; A5-8549
0BB6: 246E001C      MOVEA.L    28(A6),A2
0BBA: 266E0020      MOVEA.L    32(A6),A3
0BBE: 282E0024      MOVE.L     36(A6),D4
0BC2: 2F2E0028      MOVE.L     40(A6),-(A7)
0BC6: 2F04          MOVE.L     D4,-(A7)
0BC8: 2F0B          MOVE.L     A3,-(A7)
0BCA: 2F0A          MOVE.L     A2,-(A7)
0BCC: 2F0C          MOVE.L     A4,-(A7)
0BCE: 4EBA000C      JSR        12(PC)
0BD2: 4CEE1CF8FDCA  MOVEM.L    -566(A6),D3/D4/D5/D6/D7/A2/A3/A4
0BD8: 4E5E          UNLK       A6
0BDA: 4E75          RTS        


; ======= Function at 0x0BDC =======
0BDC: 4E560000      LINK       A6,#0
0BE0: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0BE4: 3E3C8001      MOVE.W     #$8001,D7
0BE8: 7C00          MOVEQ      #0,D6
0BEA: 99CC264C      MOVE.B     A4,#$4C
0BEE: D7EE000C4A53  MOVE.B     12(A6),83(PC,D4.L)
0BF4: 6736          BEQ.S      $0C2C
0BF6: 244C          MOVEA.L    A4,A2
0BF8: D5EE00104A52  MOVE.B     16(A6),19026(PC)
0BFE: 6726          BEQ.S      $0C26
0C00: 204C          MOVEA.L    A4,A0
0C02: D1EE000C3F10  MOVE.B     12(A6),$3F10.W
0C08: 206E0018      MOVEA.L    24(A6),A0
0C0C: 4E90          JSR        (A0)
0C0E: 4A40          TST.W      D0
0C10: 548F          MOVE.B     A7,(A2)
0C12: 6712          BEQ.S      $0C26
0C14: BE52          MOVEA.W    (A2),A7
0C16: 6C0E          BGE.S      $0C26
0C18: 3E12          MOVE.W     (A2),D7
0C1A: 3A06          MOVE.W     D6,D5
0C1C: 3813          MOVE.W     (A3),D4
0C1E: 204C          MOVEA.L    A4,A0
0C20: D1EE00143610  MOVE.B     20(A6),$3610.W
0C26: 5246          MOVEA.B    D6,A1
0C28: 548C          MOVE.B     A4,(A2)
0C2A: 60C0          BRA.S      $0BEC
0C2C: 0C478001      CMPI.W     #$8001,D7
0C30: 671E          BEQ.S      $0C50
0C32: 2F2E0008      MOVE.L     8(A6),-(A7)
0C36: 3F07          MOVE.W     D7,-(A7)
0C38: 3F03          MOVE.W     D3,-(A7)
0C3A: 3F04          MOVE.W     D4,-(A7)
0C3C: 4EBAFCBC      JSR        -836(PC)
0C40: 206E0010      MOVEA.L    16(A6),A0
0C44: D0C5          MOVE.B     D5,(A0)+
0C46: 42705000      CLR.W      0(A0,D5.W)
0C4A: 4FEF000A      LEA        10(A7),A7
0C4E: 6094          BRA.S      $0BE4
0C50: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0C54: 4E5E          UNLK       A6
0C56: 4E75          RTS        


; ======= Function at 0x0C58 =======
0C58: 4E560000      LINK       A6,#0
0C5C: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0C60: 3E2E000A      MOVE.W     10(A6),D7
0C64: 99CC0C47      MOVE.B     A4,#$47
0C68: 07D0          BSET       D3,(A0)
0C6A: 6F06          BLE.S      $0C72
0C6C: 49EDED7A      LEA        -4742(A5),A4                   ; A5-4742
0C70: 6034          BRA.S      $0CA6
0C72: 0C4703E8      CMPI.W     #$03E8,D7
0C76: 6F06          BLE.S      $0C7E
0C78: 49EDED90      LEA        -4720(A5),A4                   ; A5-4720
0C7C: 6028          BRA.S      $0CA6
0C7E: 0C4701F4      CMPI.W     #$01F4,D7
0C82: 6F06          BLE.S      $0C8A
0C84: 49EDEDA4      LEA        -4700(A5),A4                   ; A5-4700
0C88: 601C          BRA.S      $0CA6
0C8A: 0C4700FA      CMPI.W     #$00FA,D7
0C8E: 6F06          BLE.S      $0C96
0C90: 49EDEDBA      LEA        -4678(A5),A4                   ; A5-4678
0C94: 6010          BRA.S      $0CA6
0C96: 4A6E0008      TST.W      8(A6)
0C9A: 6606          BNE.S      $0CA2
0C9C: 49EDEDD2      LEA        -4654(A5),A4                   ; A5-4654
0CA0: 6004          BRA.S      $0CA6
0CA2: 49EDEDEC      LEA        -4628(A5),A4                   ; A5-4628
0CA6: 200C          MOVE.L     A4,D0
0CA8: 6708          BEQ.S      $0CB2
0CAA: 2F0C          MOVE.L     A4,-(A7)
0CAC: 4EBA000C      JSR        12(PC)
0CB0: 588F          MOVE.B     A7,(A4)
0CB2: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
0CB6: 4E5E          UNLK       A6
0CB8: 4E75          RTS        


; ======= Function at 0x0CBA =======
0CBA: 4E560000      LINK       A6,#0
0CBE: 2F2E0008      MOVE.L     8(A6),-(A7)
0CC2: 2F2DDEB0      MOVE.L     -8528(A5),-(A7)                ; A5-8528
0CC6: 4EAD07AA      JSR        1962(A5)                       ; JT[1962]
0CCA: 4E5E          UNLK       A6
0CCC: 4E75          RTS        


; ======= Function at 0x0CCE =======
0CCE: 4E560000      LINK       A6,#0
0CD2: 2F2E0008      MOVE.L     8(A6),-(A7)
0CD6: 4EAD077A      JSR        1914(A5)                       ; JT[1914]
0CDA: 4E5E          UNLK       A6
0CDC: 4E75          RTS        


; ======= Function at 0x0CDE =======
0CDE: 4E56FF7C      LINK       A6,#-132                       ; frame=132
0CE2: 48E70038      MOVEM.L    A2/A3/A4,-(SP)                 ; save
0CE6: 4A6DD76A      TST.W      -10390(A5)
0CEA: 6F0000E2      BLE.W      $0DD0
0CEE: 42A7          CLR.L      -(A7)
0CF0: 206E0008      MOVEA.L    8(A6),A0
0CF4: 2F2800CA      MOVE.L     202(A0),-(A7)
0CF8: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0CFC: 2D5FFF7C      MOVE.L     (A7)+,-132(A6)
0D00: 48780006      PEA        $0006.W
0D04: 2F2EFF7C      MOVE.L     -132(A6),-(A7)
0D08: 4EAD004A      JSR        74(A5)                         ; JT[74]
0D0C: 306DD76A      MOVEA.W    -10390(A5),A0
0D10: B088          MOVE.W     A0,(A0)
0D12: 630000BA      BLS.W      $0DD0
0D16: 4EAD093A      JSR        2362(A5)                       ; JT[2362]
0D1A: 4A40          TST.W      D0
0D1C: 660000B0      BNE.W      $0DD0
0D20: 206DDEB8      MOVEA.L    -8520(A5),A0
0D24: 206800CA      MOVEA.L    202(A0),A0
0D28: 2050          MOVEA.L    (A0),A0
0D2A: 20680002      MOVEA.L    2(A0),A0
0D2E: A029206D      MOVE.L     8301(A1),D0
0D32: DEB82068      MOVE.B     $2068.W,(A7)
0D36: 00CA          DC.W       $00CA
0D38: 7006          MOVEQ      #6,D0
0D3A: C1EDD76A      ANDA.L     -10390(A5),A0
0D3E: 2050          MOVEA.L    (A0),A0
0D40: 20700802      MOVEA.L    2(A0,D0.L),A0
0D44: A029206D      MOVE.L     8301(A1),D0
0D48: DEB82068      MOVE.B     $2068.W,(A7)
0D4C: 00CA          DC.W       $00CA
0D4E: 2850          MOVEA.L    (A0),A4
0D50: 206C0002      MOVEA.L    2(A4),A0
0D54: 2650          MOVEA.L    (A0),A3
0D56: 7006          MOVEQ      #6,D0
0D58: C1EDD76A      ANDA.L     -10390(A5),A0
0D5C: 20740802      MOVEA.L    2(A4,D0.L),A0
0D60: 2450          MOVEA.L    (A0),A2
0D62: 2F0A          MOVE.L     A2,-(A7)
0D64: 2F0B          MOVE.L     A3,-(A7)
0D66: 486DDE86      PEA        -8570(A5)                      ; A5-8570
0D6A: 4EBAF294      JSR        -3436(PC)
0D6E: 2E8B          MOVE.L     A3,(A7)
0D70: 2F0A          MOVE.L     A2,-(A7)
0D72: 486DDE9B      PEA        -8549(A5)                      ; A5-8549
0D76: 4EBAF288      JSR        -3448(PC)
0D7A: 206DDEB8      MOVEA.L    -8520(A5),A0
0D7E: 206800CA      MOVEA.L    202(A0),A0
0D82: 2050          MOVEA.L    (A0),A0
0D84: 20680002      MOVEA.L    2(A0),A0
0D88: A02A206D      MOVE.L     8301(A2),D0
0D8C: DEB82068      MOVE.B     $2068.W,(A7)
0D90: 00CA          DC.W       $00CA
0D92: 7006          MOVEQ      #6,D0
0D94: C1EDD76A      ANDA.L     -10390(A5),A0
0D98: 2050          MOVEA.L    (A0),A0
0D9A: 20700802      MOVEA.L    2(A0,D0.L),A0
0D9E: A02A486D      MOVE.L     18541(A2),D0
0DA2: DE86          MOVE.B     D6,(A7)
0DA4: 486DDE9B      PEA        -8549(A5)                      ; A5-8549
0DA8: 486DEE16      PEA        -4586(A5)                      ; A5-4586
0DAC: 486EFF81      PEA        -127(A6)
0DB0: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0DB4: 1D40FF80      MOVE.B     D0,-128(A6)
0DB8: 2EAE000C      MOVE.L     12(A6),(A7)
0DBC: 4267          CLR.W      -(A7)
0DBE: 2F2E0010      MOVE.L     16(A6),-(A7)
0DC2: A86B486E      MOVEA.L    18542(A3),A4
0DC6: FF80A947      MOVE.W     D0,71(A7,A2.L)
0DCA: 7001          MOVEQ      #1,D0
0DCC: 6002          BRA.S      $0DD0
0DCE: 7000          MOVEQ      #0,D0
0DD0: 4CEE1C00FF70  MOVEM.L    -144(A6),A2/A3/A4
0DD6: 4E5E          UNLK       A6
0DD8: 4E75          RTS        


; ======= Function at 0x0DDA =======
0DDA: 4E56E58C      LINK       A6,#-6772                      ; frame=6772
0DDE: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0DE2: 286E0008      MOVEA.L    8(A6),A4
0DE6: 49EC00CA      LEA        202(A4),A4
0DEA: 2054          MOVEA.L    (A4),A0
0DEC: 2050          MOVEA.L    (A0),A0
0DEE: 20680002      MOVEA.L    2(A0),A0
0DF2: 2050          MOVEA.L    (A0),A0
0DF4: 43EEFFDE      LEA        -34(A6),A1
0DF8: 7007          MOVEQ      #7,D0
0DFA: 22D8          MOVE.L     (A0)+,(A1)+
0DFC: 51C8FFFC      DBF        D0,$0DFA                       ; loop
0E00: 32D8          MOVE.W     (A0)+,(A1)+
0E02: 2054          MOVEA.L    (A4),A0
0E04: 7006          MOVEQ      #6,D0
0E06: C1EDD76A      ANDA.L     -10390(A5),A0
0E0A: 2050          MOVEA.L    (A0),A0
0E0C: 20700802      MOVEA.L    2(A0,D0.L),A0
0E10: 2050          MOVEA.L    (A0),A0
0E12: 43EEFFBC      LEA        -68(A6),A1
0E16: 7007          MOVEQ      #7,D0
0E18: 22D8          MOVE.L     (A0)+,(A1)+
0E1A: 51C8FFFC      DBF        D0,$0E18                       ; loop
0E1E: 32D8          MOVE.W     (A0)+,(A1)+
0E20: 4EAD03FA      JSR        1018(A5)                       ; JT[1018]
0E24: 486DC366      PEA        -15514(A5)                     ; g_field_14
0E28: 4EAD02F2      JSR        754(A5)                        ; JT[754]
0E2C: 486EF7B4      PEA        -2124(A6)
0E30: 486EFBB4      PEA        -1100(A6)
0E34: 486EFFDE      PEA        -34(A6)
0E38: 4EAD09E2      JSR        2530(A5)                       ; JT[2530]
0E3C: D0AEFFEE      MOVE.B     -18(A6),(A0)
0E40: 2D40E59A      MOVE.L     D0,-6758(A6)
0E44: 48780400      PEA        $0400.W
0E48: 486EEBB4      PEA        -5196(A6)
0E4C: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0E50: 486EEFB4      PEA        -4172(A6)
0E54: 486EF3B4      PEA        -3148(A6)
0E58: 486EFFBC      PEA        -68(A6)
0E5C: 4EAD09E2      JSR        2530(A5)                       ; JT[2530]
0E60: D0AEFFCC      MOVE.B     -52(A6),(A0)
0E64: 91AEE59A4878  MOVE.B     -6758(A6),120(A0,D4.L)
0E6A: 0400486E      SUBI.B     #$486E,D0
0E6E: E7B44EAD01AA  MOVE.L     -83(A4,D4.L*8),-86(A3,D0.W)
0E74: 7800          MOVEQ      #0,D4
0E76: 49EEEBB4      LEA        -5196(A6),A4
0E7A: 47EEF7B4      LEA        -2124(A6),A3
0E7E: 41EEFBB4      LEA        -1100(A6),A0
0E82: 2E08          MOVE.L     A0,D7
0E84: 4FEF002C      LEA        44(A7),A7
0E88: 60000094      BRA.W      $0F20
0E8C: 7600          MOVEQ      #0,D3
0E8E: 244B          MOVEA.L    A3,A2
0E90: 2D4CE592      MOVE.L     A4,-6766(A6)
0E94: 2A03          MOVE.L     D3,D5
0E96: 48C5          EXT.L      D5
0E98: DA85          MOVE.B     D5,(A5)
0E9A: 41EEE7B4      LEA        -6220(A6),A0
0E9E: D1C52D48      MOVE.B     D5,$2D48.W
0EA2: E5962C05      MOVE.L     (A6),5(A2,D2.L*4)
0EA6: 43EEEFB4      LEA        -4172(A6),A1
0EAA: DC89          MOVE.B     A1,(A6)
0EAC: 43EEF3B4      LEA        -3148(A6),A1
0EB0: D3C52D49E59E  MOVE.B     D5,$2D49E59E
0EB6: 206EE59E      MOVEA.L    -6754(A6),A0
0EBA: 3D50E58E      MOVE.W     (A0),-6770(A6)
0EBE: 4A6EE58E      TST.W      -6770(A6)
0EC2: 6752          BEQ.S      $0F16
0EC4: 2047          MOVEA.L    D7,A0
0EC6: 3010          MOVE.W     (A0),D0
0EC8: B06EE58E      MOVEA.W    -6770(A6),A0
0ECC: 663A          BNE.S      $0F08
0ECE: 2046          MOVEA.L    D6,A0
0ED0: 3610          MOVE.W     (A0),D3
0ED2: B652          MOVEA.W    (A2),A3
0ED4: 6608          BNE.S      $0EDE
0ED6: 2046          MOVEA.L    D6,A0
0ED8: 4250          CLR.W      (A0)
0EDA: 4252          CLR.W      (A2)
0EDC: 6038          BRA.S      $0F16
0EDE: B652          MOVEA.W    (A2),A3
0EE0: 6C14          BGE.S      $0EF6
0EE2: 2046          MOVEA.L    D6,A0
0EE4: 3010          MOVE.W     (A0),D0
0EE6: 9152206E      MOVE.B     (A2),8302(A0)
0EEA: E59230BC      MOVE.L     (A2),-68(A2,D3.W)
0EEE: 00012246      ORI.B      #$2246,D1
0EF2: 4251          CLR.W      (A1)
0EF4: 6020          BRA.S      $0F16
0EF6: 3012          MOVE.W     (A2),D0
0EF8: 2046          MOVEA.L    D6,A0
0EFA: 9150206E      MOVE.B     (A0),8302(A0)
0EFE: E59630BC      MOVE.L     (A6),-68(A2,D3.W)
0F02: 00014252      ORI.B      #$4252,D1
0F06: 600E          BRA.S      $0F16
0F08: 5243          MOVEA.B    D3,A1
0F0A: 54AEE596      MOVE.B     -6762(A6),(A2)
0F0E: 5486          MOVE.B     D6,(A2)
0F10: 54AEE59E      MOVE.B     -6754(A6),(A2)
0F14: 60A0          BRA.S      $0EB6
0F16: 5244          MOVEA.B    D4,A1
0F18: 548C          MOVE.B     A4,(A2)
0F1A: 548B          MOVE.B     A3,(A2)
0F1C: 5487          MOVE.B     D7,(A2)
0F1E: 2047          MOVEA.L    D7,A0
0F20: 4A50          TST.W      (A0)
0F22: 6600FF68      BNE.W      $0E8E
0F26: 7800          MOVEQ      #0,D4
0F28: 49EEF7B4      LEA        -2124(A6),A4
0F2C: 47EEFBB4      LEA        -1100(A6),A3
0F30: 2E0B          MOVE.L     A3,D7
0F32: 2047          MOVEA.L    D7,A0
0F34: 4A50          TST.W      (A0)
0F36: 6758          BEQ.S      $0F90
0F38: 4A54          TST.W      (A4)
0F3A: 674C          BEQ.S      $0F88
0F3C: 7600          MOVEQ      #0,D3
0F3E: 2A03          MOVE.L     D3,D5
0F40: 48C5          EXT.L      D5
0F42: DA85          MOVE.B     D5,(A5)
0F44: 45EEF7B4      LEA        -2124(A6),A2
0F48: D5C541EE      MOVE.B     D5,16878(PC)
0F4C: FBB4D1C52D48  MOVE.W     -59(A4,A5.W),72(A5,D2.L*4)
0F52: E592602A      MOVE.L     (A2),42(A2,D6.W)
0F56: B644          MOVEA.W    D4,A3
0F58: 671E          BEQ.S      $0F78
0F5A: 4A52          TST.W      (A2)
0F5C: 671A          BEQ.S      $0F78
0F5E: 206EE592      MOVEA.L    -6766(A6),A0
0F62: 3F10          MOVE.W     (A0),-(A7)
0F64: 2247          MOVEA.L    D7,A1
0F66: 3F11          MOVE.W     (A1),-(A7)
0F68: 4EBAF7B6      JSR        -2122(PC)
0F6C: 4A40          TST.W      D0
0F6E: 588F          MOVE.B     A7,(A4)
0F70: 6706          BEQ.S      $0F78
0F72: 3012          MOVE.W     (A2),D0
0F74: D1544252      MOVE.B     (A4),16978(A0)
0F78: 5243          MOVEA.B    D3,A1
0F7A: 548A          MOVE.B     A2,(A2)
0F7C: 54AEE592      MOVE.B     -6766(A6),(A2)
0F80: 206EE592      MOVEA.L    -6766(A6),A0
0F84: 4A50          TST.W      (A0)
0F86: 66CE          BNE.S      $0F56
0F88: 5244          MOVEA.B    D4,A1
0F8A: 548C          MOVE.B     A4,(A2)
0F8C: 548B          MOVE.B     A3,(A2)
0F8E: 60A0          BRA.S      $0F30
0F90: 7800          MOVEQ      #0,D4
0F92: 49EEEFB4      LEA        -4172(A6),A4
0F96: 47EEF3B4      LEA        -3148(A6),A3
0F9A: 6044          BRA.S      $0FE0
0F9C: 4A54          TST.W      (A4)
0F9E: 673A          BEQ.S      $0FDA
0FA0: 7600          MOVEQ      #0,D3
0FA2: 41EEEFB4      LEA        -4172(A6),A0
0FA6: 2E08          MOVE.L     A0,D7
0FA8: 45EEF3B4      LEA        -3148(A6),A2
0FAC: 6028          BRA.S      $0FD6
0FAE: B644          MOVEA.W    D4,A3
0FB0: 671E          BEQ.S      $0FD0
0FB2: 2047          MOVEA.L    D7,A0
0FB4: 4A50          TST.W      (A0)
0FB6: 6718          BEQ.S      $0FD0
0FB8: 3F12          MOVE.W     (A2),-(A7)
0FBA: 3F13          MOVE.W     (A3),-(A7)
0FBC: 4EBAF762      JSR        -2206(PC)
0FC0: 4A40          TST.W      D0
0FC2: 588F          MOVE.B     A7,(A4)
0FC4: 670A          BEQ.S      $0FD0
0FC6: 2047          MOVEA.L    D7,A0
0FC8: 3010          MOVE.W     (A0),D0
0FCA: D1542047      MOVE.B     (A4),8263(A0)
0FCE: 4250          CLR.W      (A0)
0FD0: 5243          MOVEA.B    D3,A1
0FD2: 5487          MOVE.B     D7,(A2)
0FD4: 548A          MOVE.B     A2,(A2)
0FD6: 4A52          TST.W      (A2)
0FD8: 66D4          BNE.S      $0FAE
0FDA: 5244          MOVEA.B    D4,A1
0FDC: 548C          MOVE.B     A4,(A2)
0FDE: 548B          MOVE.B     A3,(A2)
0FE0: 4A53          TST.W      (A3)
0FE2: 66B8          BNE.S      $0F9C
0FE4: 202EFFEE      MOVE.L     -18(A6),D0
0FE8: B0AEFFCC      MOVE.W     -52(A6),(A0)
0FEC: 6D04          BLT.S      $0FF2
0FEE: 7000          MOVEQ      #0,D0
0FF0: 6002          BRA.S      $0FF4
0FF2: 7001          MOVEQ      #1,D0
0FF4: 3040          MOVEA.W    D0,A0
0FF6: 2D48E58E      MOVE.L     A0,-6770(A6)
0FFA: 202EFFEE      MOVE.L     -18(A6),D0
0FFE: B0AEFFCC      MOVE.W     -52(A6),(A0)
1002: 6604          BNE.S      $1008
1004: 7000          MOVEQ      #0,D0
1006: 6002          BRA.S      $100A
1008: 7001          MOVEQ      #1,D0
100A: 3B40DE84      MOVE.W     D0,-8572(A5)
100E: 7800          MOVEQ      #0,D4
1010: 49EEF7B4      LEA        -2124(A6),A4
1014: 47EEFBB4      LEA        -1100(A6),A3
1018: 6018          BRA.S      $1032
101A: 3614          MOVE.W     (A4),D3
101C: 4A43          TST.W      D3
101E: 670C          BEQ.S      $102C
1020: 526DDE84      MOVEA.B    -8572(A5),A1
1024: 4A43          TST.W      D3
1026: 6C04          BGE.S      $102C
1028: 52AEE58E      MOVE.B     -6770(A6),(A1)
102C: 5244          MOVEA.B    D4,A1
102E: 548C          MOVE.B     A4,(A2)
1030: 548B          MOVE.B     A3,(A2)
1032: 4A53          TST.W      (A3)
1034: 66E4          BNE.S      $101A
1036: 7600          MOVEQ      #0,D3
1038: 49EEF3B4      LEA        -3148(A6),A4
103C: 6024          BRA.S      $1062
103E: 204E          MOVEA.L    A6,A0
1040: D0C4          MOVE.B     D4,(A0)+
1042: D0C4          MOVE.B     D4,(A0)+
1044: 3D68EFB4E58C  MOVE.W     -4172(A0),-6772(A6)
104A: 4A6EE58C      TST.W      -6772(A6)
104E: 670E          BEQ.S      $105E
1050: 526DDE84      MOVEA.B    -8572(A5),A1
1054: 4A6EE58C      TST.W      -6772(A6)
1058: 6F04          BLE.S      $105E
105A: 52AEE58E      MOVE.B     -6770(A6),(A1)
105E: 5243          MOVEA.B    D3,A1
1060: 548C          MOVE.B     A4,(A2)
1062: 4A54          TST.W      (A4)
1064: 66D8          BNE.S      $103E
1066: 2F2DDEB0      MOVE.L     -8528(A5),-(A7)                ; A5-8528
106A: 4EAD07BA      JSR        1978(A5)                       ; JT[1978]
106E: 4A6DDE84      TST.W      -8572(A5)
1072: 588F          MOVE.B     A7,(A4)
1074: 6628          BNE.S      $109E
1076: 486DDE9B      PEA        -8549(A5)                      ; A5-8549
107A: 486DDE86      PEA        -8570(A5)                      ; A5-8570
107E: 486DEE28      PEA        -4568(A5)                      ; A5-4568
1082: 486EE5A6      PEA        -6746(A6)
1086: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
108A: 486EE5A6      PEA        -6746(A6)
108E: 2F2DDEB0      MOVE.L     -8528(A5),-(A7)                ; A5-8528
1092: 4EAD07AA      JSR        1962(A5)                       ; JT[1962]
1096: 4FEF0018      LEA        24(A7),A7
109A: 600000A6      BRA.W      $1144
109E: 426DDE84      CLR.W      -8572(A5)
10A2: 486EE7B4      PEA        -6220(A6)
10A6: 486EEFB4      PEA        -4172(A6)
10AA: 486EF3B4      PEA        -3148(A6)
10AE: 486EFFBC      PEA        -68(A6)
10B2: 486EEBB4      PEA        -5196(A6)
10B6: 486EF7B4      PEA        -2124(A6)
10BA: 486EFBB4      PEA        -1100(A6)
10BE: 486EFFDE      PEA        -34(A6)
10C2: 4EBAF8F2      JSR        -1806(PC)
10C6: 486DEE3E      PEA        -4546(A5)                      ; A5-4546
10CA: 486DEE58      PEA        -4520(A5)                      ; A5-4520
10CE: 486D09F2      PEA        2546(A5)                       ; A5+2546
10D2: 486EE7B4      PEA        -6220(A6)
10D6: 486EEFB4      PEA        -4172(A6)
10DA: 486EF3B4      PEA        -3148(A6)
10DE: 486EFFBC      PEA        -68(A6)
10E2: 486EEBB4      PEA        -5196(A6)
10E6: 486EF7B4      PEA        -2124(A6)
10EA: 486EFBB4      PEA        -1100(A6)
10EE: 486EFFDE      PEA        -34(A6)
10F2: 4EBAF99E      JSR        -1634(PC)
10F6: 486DEE74      PEA        -4492(A5)                      ; A5-4492
10FA: 486DEE8C      PEA        -4468(A5)                      ; A5-4468
10FE: 486D036A      PEA        874(A5)                        ; A5+874
1102: 486EE7B4      PEA        -6220(A6)
1106: 486EEFB4      PEA        -4172(A6)
110A: 486EF3B4      PEA        -3148(A6)
110E: 486EFFBC      PEA        -68(A6)
1112: 486EEBB4      PEA        -5196(A6)
1116: 486EF7B4      PEA        -2124(A6)
111A: 486EFBB4      PEA        -1100(A6)
111E: 486EFFDE      PEA        -34(A6)
1122: 4EBAF96E      JSR        -1682(PC)
1126: 4FEF0078      LEA        120(A7),A7
112A: 486EFFBC      PEA        -68(A6)
112E: 486EFFDE      PEA        -34(A6)
1132: 3F2EE59C      MOVE.W     -6756(A6),-(A7)
1136: 3F2EE590      MOVE.W     -6768(A6),-(A7)
113A: 4EBAFB1C      JSR        -1252(PC)
113E: 4FEF000C      LEA        12(A7),A7
1142: 2F2DDEB0      MOVE.L     -8528(A5),-(A7)                ; A5-8528
1146: A873206D      MOVEA.L    109(A3,D2.W),A4
114A: DEB04868      MOVE.B     104(A0,D4.L),(A7)
114E: 0010A928      ORI.B      #$A928,(A0)
1152: 2F2DDEB0      MOVE.L     -8528(A5),-(A7)                ; A5-8528
1156: 4EAD0C3A      JSR        3130(A5)                       ; JT[3130]
115A: 2EADDEB0      MOVE.L     -8528(A5),(A7)                 ; A5-8528
115E: 4EAD0C1A      JSR        3098(A5)                       ; JT[3098]
1162: 4CEE1CF8E56C  MOVEM.L    -6804(A6),D3/D4/D5/D6/D7/A2/A3/A4
1168: 4E5E          UNLK       A6
116A: 4E75          RTS        
