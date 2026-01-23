;======================================================================
; CODE 21 Disassembly
; File: /tmp/maven_code_21.bin
; Header: JT offset=1064, JT entries=39
; Code size: 13718 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
0008: 2F2E0008      MOVE.L     8(A6),-(A7)
000C: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
0010: 266E0008      MOVEA.L    8(A6),A3
0014: 206DDE78      MOVEA.L    -8584(A5),A0
0018: 2850          MOVEA.L    (A0),A4
001A: 49EC0312      LEA        786(A4),A4
001E: 588F          MOVE.B     A7,(A4)
0020: 601A          BRA.S      $003C
0022: 7C00          MOVEQ      #0,D6
0024: 45EDA54E      LEA        -23218(A5),A2                  ; A5-23218
0028: D4C7          MOVE.B     D7,(A2)+
002A: 6006          BRA.S      $0032
002C: 1687          MOVE.B     D7,(A3)
002E: 5246          MOVEA.B    D6,A1
0030: 528B          MOVE.B     A3,(A1)
0032: 1012          MOVE.B     (A2),D0
0034: 4880          EXT.W      D0
0036: B046          MOVEA.W    D6,A0
0038: 6EF2          BGT.S      $002C
003A: 528C          MOVE.B     A4,(A1)
003C: 1E14          MOVE.B     (A4),D7
003E: 4887          EXT.W      D7
0040: 4A47          TST.W      D7
0042: 66DE          BNE.S      $0022
0044: 4213          CLR.B      (A3)
0046: 4CDF1CC0      MOVEM.L    (SP)+,D6/D7/A2/A3/A4           ; restore
004A: 4E5E          UNLK       A6
004C: 4E75          RTS        


; ======= Function at 0x004E =======
004E: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0052: 48E70738      MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)        ; save
0056: 486DC366      PEA        -15514(A5)                     ; g_field_14
005A: 4EBAFFA4      JSR        -92(PC)
005E: 7C00          MOVEQ      #0,D6
0060: 49EDDE28      LEA        -8664(A5),A4                   ; g_flag1
0064: 588F          MOVE.B     A7,(A4)
0066: 6028          BRA.S      $0090
0068: 486DC366      PEA        -15514(A5)                     ; g_field_14
006C: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0070: 3046          MOVEA.W    D6,A0
0072: B088          MOVE.W     A0,(A0)
0074: 588F          MOVE.B     A7,(A4)
0076: 6204          BHI.S      $007C
0078: 4254          CLR.W      (A4)
007A: 600C          BRA.S      $0088
007C: 204D          MOVEA.L    A5,A0
007E: D0C6          MOVE.B     D6,(A0)+
0080: 1028C366      MOVE.B     -15514(A0),D0
0084: 4880          EXT.W      D0
0086: 3880          MOVE.W     D0,(A4)
0088: 426C0002      CLR.W      2(A4)
008C: 5246          MOVEA.B    D6,A1
008E: 588C          MOVE.B     A4,(A4)
0090: 0C460007      CMPI.W     #$0007,D6
0094: 6DD2          BLT.S      $0068
0096: 426DDE44      CLR.W      -8636(A5)
009A: 4EBA0B4A      JSR        2890(PC)
009E: 7C01          MOVEQ      #1,D6
00A0: 49EDD77D      LEA        -10371(A5),A4                  ; A5-10371
00A4: 47EDD89E      LEA        -10082(A5),A3                  ; A5-10082
00A8: 6038          BRA.S      $00E2
00AA: 7A01          MOVEQ      #1,D5
00AC: 244B          MOVEA.L    A3,A2
00AE: 2E0C          MOVE.L     A4,D7
00B0: 6020          BRA.S      $00D2
00B2: 3045          MOVEA.W    D5,A0
00B4: 10325000      MOVE.B     0(A2,D5.W),D0
00B8: B0307800      MOVE.W     0(A0,D7.L),D0
00BC: 6712          BEQ.S      $00D0
00BE: 3045          MOVEA.W    D5,A0
00C0: 11B250007800  MOVE.B     0(A2,D5.W),0(A0,D7.L)
00C6: 3F05          MOVE.W     D5,-(A7)
00C8: 3F06          MOVE.W     D6,-(A7)
00CA: 4EAD03DA      JSR        986(A5)                        ; JT[986]
00CE: 588F          MOVE.B     A7,(A4)
00D0: 5245          MOVEA.B    D5,A1
00D2: 0C450010      CMPI.W     #$0010,D5
00D6: 6DDA          BLT.S      $00B2
00D8: 5246          MOVEA.B    D6,A1
00DA: 49EC0011      LEA        17(A4),A4
00DE: 47EB0011      LEA        17(A3),A3
00E2: 0C460010      CMPI.W     #$0010,D6
00E6: 6DC2          BLT.S      $00AA
00E8: 4EAD03C2      JSR        962(A5)                        ; JT[962]
00EC: 4EBA080C      JSR        2060(PC)
00F0: 4CDF1CE0      MOVEM.L    (SP)+,D5/D6/D7/A2/A3/A4        ; restore
00F4: 4E5E          UNLK       A6
00F6: 4E75          RTS        


; ======= Function at 0x00F8 =======
00F8: 4E56FFEA      LINK       A6,#-22                        ; frame=22
00FC: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0100: 362E000C      MOVE.W     12(A6),D3
0104: 4A6DD9AE      TST.W      -9810(A5)
0108: 66000326      BNE.W      $0432
010C: 7011          MOVEQ      #17,D0
010E: C1EE0008      ANDA.L     8(A6),A0
0112: D08D          MOVE.B     A5,(A0)
0114: 386E000A      MOVEA.W    10(A6),A4
0118: 49ECD88D      LEA        -10099(A4),A4
011C: D08C          MOVE.B     A4,(A0)
011E: 2840          MOVEA.L    D0,A4
0120: 4A14          TST.B      (A4)
0122: 6722          BEQ.S      $0146
0124: 1014          MOVE.B     (A4),D0
0126: 4880          EXT.W      D0
0128: 3F00          MOVE.W     D0,-(A7)
012A: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
012E: 3D40FFEA      MOVE.W     D0,-22(A6)
0132: 3E83          MOVE.W     D3,(A7)
0134: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
0138: B06EFFEA      MOVEA.W    -22(A6),A0
013C: 548F          MOVE.B     A7,(A2)
013E: 6706          BEQ.S      $0146
0140: 7000          MOVEQ      #0,D0
0142: 6000030C      BRA.W      $0452
0146: 3F03          MOVE.W     D3,-(A7)
0148: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
014C: 7211          MOVEQ      #17,D1
014E: C3EE0008      ANDA.L     8(A6),A1
0152: D28D          MOVE.B     A5,(A1)
0154: 306E000A      MOVEA.W    10(A6),A0
0158: D1C11228      MOVE.B     D1,$1228.W
015C: D76C4881B041  MOVE.B     18561(A4),-20415(A3)
0162: 548F          MOVE.B     A7,(A2)
0164: 660A          BNE.S      $0170
0166: 3F03          MOVE.W     D3,-(A7)
0168: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
016C: 3600          MOVE.W     D0,D3
016E: 548F          MOVE.B     A7,(A2)
0170: 486DC366      PEA        -15514(A5)                     ; g_field_14
0174: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
0178: 426EFFF2      CLR.W      -14(A6)
017C: 7E00          MOVEQ      #0,D7
017E: 3D47FFF4      MOVE.W     D7,-12(A6)
0182: 3C07          MOVE.W     D7,D6
0184: 7801          MOVEQ      #1,D4
0186: 49EDD89E      LEA        -10082(A5),A4                  ; A5-10082
018A: 47EDD77D      LEA        -10371(A5),A3                  ; A5-10371
018E: 588F          MOVE.B     A7,(A4)
0190: 600000AE      BRA.W      $0242
0194: 7A01          MOVEQ      #1,D5
0196: 2D4BFFFA      MOVE.L     A3,-6(A6)
019A: 2D4CFFF6      MOVE.L     A4,-10(A6)
019E: 6000008E      BRA.W      $0230
01A2: 206EFFFA      MOVEA.L    -6(A6),A0
01A6: 226EFFF6      MOVEA.L    -10(A6),A1
01AA: 10305000      MOVE.B     0(A0,D5.W),D0
01AE: B0315000      MOVE.W     0(A1,D5.W),D0
01B2: 6778          BEQ.S      $022C
01B4: 2D4CFFF6      MOVE.L     A4,-10(A6)
01B8: 206EFFF6      MOVEA.L    -10(A6),A0
01BC: 4A305000      TST.B      0(A0,D5.W)
01C0: 6704          BEQ.S      $01C6
01C2: 4EAD01A2      JSR        418(A5)                        ; JT[418]
01C6: 3445          MOVEA.W    D5,A2
01C8: D5CB2D4B      MOVE.B     A3,11595(PC)
01CC: FFFA7000      MOVE.W     28672(PC),???
01D0: 1012          MOVE.B     (A2),D0
01D2: 204D          MOVEA.L    A5,A0
01D4: D1C04A28      MOVE.B     D0,$4A28.W
01D8: FBD8          MOVE.W     (A0)+,???
01DA: 6A0C          BPL.S      $01E8
01DC: 4A2DA58D      TST.B      -23155(A5)
01E0: 674A          BEQ.S      $022C
01E2: 532DA58D      MOVE.B     -23155(A5),-(A1)               ; A5-23155
01E6: 6044          BRA.S      $022C
01E8: 1012          MOVE.B     (A2),D0
01EA: 4880          EXT.W      D0
01EC: 3F00          MOVE.W     D0,-(A7)
01EE: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
01F2: 3D40FFEC      MOVE.W     D0,-20(A6)
01F6: 204D          MOVEA.L    A5,A0
01F8: D0C0          MOVE.B     D0,(A0)+
01FA: 4A28A54E      TST.B      -23218(A0)
01FE: 548F          MOVE.B     A7,(A2)
0200: 670C          BEQ.S      $020E
0202: 204D          MOVEA.L    A5,A0
0204: D0EEFFEC      MOVE.B     -20(A6),(A0)+
0208: 5328A54E      MOVE.B     -23218(A0),-(A1)
020C: 601E          BRA.S      $022C
020E: 4A2DA58D      TST.B      -23155(A5)
0212: 6712          BEQ.S      $0226
0214: 532DA58D      MOVE.B     -23155(A5),-(A1)               ; A5-23155
0218: 3D46FFF4      MOVE.W     D6,-12(A6)
021C: 3C04          MOVE.W     D4,D6
021E: 3D47FFF2      MOVE.W     D7,-14(A6)
0222: 3E05          MOVE.W     D5,D7
0224: 6006          BRA.S      $022C
0226: 7000          MOVEQ      #0,D0
0228: 60000226      BRA.W      $0452
022C: 5245          MOVEA.B    D5,A1
022E: 0C450010      CMPI.W     #$0010,D5
0232: 6D00FF6E      BLT.W      $01A4
0236: 5244          MOVEA.B    D4,A1
0238: 49EC0011      LEA        17(A4),A4
023C: 47EB0011      LEA        17(A3),A3
0240: 0C440010      CMPI.W     #$0010,D4
0244: 6D00FF4E      BLT.W      $0196
0248: 4A43          TST.W      D3
024A: 663E          BNE.S      $028A
024C: 7011          MOVEQ      #17,D0
024E: C1EE0008      ANDA.L     8(A6),A0
0252: D08D          MOVE.B     A5,(A0)
0254: 386E000A      MOVEA.W    10(A6),A4
0258: 49ECD76C      LEA        -10388(A4),A4
025C: D08C          MOVE.B     A4,(A0)
025E: 2840          MOVEA.L    D0,A4
0260: 7000          MOVEQ      #0,D0
0262: 1014          MOVE.B     (A4),D0
0264: 204D          MOVEA.L    A5,A0
0266: D1C04A28      MOVE.B     D0,$4A28.W
026A: FBD8          MOVE.W     (A0)+,???
026C: 6A04          BPL.S      $0272
026E: 703F          MOVEQ      #63,D0
0270: 600C          BRA.S      $027E
0272: 1014          MOVE.B     (A4),D0
0274: 4880          EXT.W      D0
0276: 3F00          MOVE.W     D0,-(A7)
0278: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
027C: 548F          MOVE.B     A7,(A2)
027E: 204D          MOVEA.L    A5,A0
0280: D0C0          MOVE.B     D0,(A0)+
0282: 5228A54E      MOVE.B     -23218(A0),D1
0286: 600000E6      BRA.W      $0370
028A: 7011          MOVEQ      #17,D0
028C: C1EE0008      ANDA.L     8(A6),A0
0290: D08D          MOVE.B     A5,(A0)
0292: 306E000A      MOVEA.W    10(A6),A0
0296: D1C01828      MOVE.B     D0,$1828.W
029A: D76C7011C1EE  MOVE.B     28689(A4),-15890(A3)
02A0: 0008D08D      ORI.B      #$D08D,A0
02A4: 386E000A      MOVEA.W    10(A6),A4
02A8: 49ECD76C      LEA        -10388(A4),A4
02AC: D08C          MOVE.B     A4,(A0)
02AE: 2840          MOVEA.L    D0,A4
02B0: 4A04          TST.B      D4
02B2: 6726          BEQ.S      $02DA
02B4: 7000          MOVEQ      #0,D0
02B6: 1004          MOVE.B     D4,D0
02B8: 204D          MOVEA.L    A5,A0
02BA: D1C04A28      MOVE.B     D0,$4A28.W
02BE: FBD8          MOVE.W     (A0)+,???
02C0: 6A04          BPL.S      $02C6
02C2: 703F          MOVEQ      #63,D0
02C4: 600C          BRA.S      $02D2
02C6: 1014          MOVE.B     (A4),D0
02C8: 4880          EXT.W      D0
02CA: 3F00          MOVE.W     D0,-(A7)
02CC: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
02D0: 548F          MOVE.B     A7,(A2)
02D2: 204D          MOVEA.L    A5,A0
02D4: D0C0          MOVE.B     D0,(A0)+
02D6: 5228A54E      MOVE.B     -23218(A0),D1
02DA: 7000          MOVEQ      #0,D0
02DC: 1003          MOVE.B     D3,D0
02DE: 204D          MOVEA.L    A5,A0
02E0: D1C04A28      MOVE.B     D0,$4A28.W
02E4: FBD8          MOVE.W     (A0)+,???
02E6: 6A28          BPL.S      $0310
02E8: 4A2DA58D      TST.B      -23155(A5)
02EC: 6622          BNE.S      $0310
02EE: 3F03          MOVE.W     D3,-(A7)
02F0: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
02F4: 204D          MOVEA.L    A5,A0
02F6: D0C0          MOVE.B     D0,(A0)+
02F8: 4A28A54E      TST.B      -23218(A0)
02FC: 548F          MOVE.B     A7,(A2)
02FE: 6606          BNE.S      $0306
0300: 7000          MOVEQ      #0,D0
0302: 6000014C      BRA.W      $0452
0306: 3F03          MOVE.W     D3,-(A7)
0308: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
030C: 3600          MOVE.W     D0,D3
030E: 548F          MOVE.B     A7,(A2)
0310: 7000          MOVEQ      #0,D0
0312: 1003          MOVE.B     D3,D0
0314: 204D          MOVEA.L    A5,A0
0316: D1C04A28      MOVE.B     D0,$4A28.W
031A: FBD8          MOVE.W     (A0)+,???
031C: 6A0C          BPL.S      $032A
031E: 4A2DA58D      TST.B      -23155(A5)
0322: 674A          BEQ.S      $036E
0324: 532DA58D      MOVE.B     -23155(A5),-(A1)               ; A5-23155
0328: 6044          BRA.S      $036E
032A: 3F03          MOVE.W     D3,-(A7)
032C: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
0330: 3D40FFEC      MOVE.W     D0,-20(A6)
0334: 204D          MOVEA.L    A5,A0
0336: D0C0          MOVE.B     D0,(A0)+
0338: 4A28A54E      TST.B      -23218(A0)
033C: 548F          MOVE.B     A7,(A2)
033E: 670C          BEQ.S      $034C
0340: 204D          MOVEA.L    A5,A0
0342: D0EEFFEC      MOVE.B     -20(A6),(A0)+
0346: 5328A54E      MOVE.B     -23218(A0),-(A1)
034A: 6022          BRA.S      $036E
034C: 4A2DA58D      TST.B      -23155(A5)
0350: 6716          BEQ.S      $0368
0352: 532DA58D      MOVE.B     -23155(A5),-(A1)               ; A5-23155
0356: 3D46FFF4      MOVE.W     D6,-12(A6)
035A: 3C2E0008      MOVE.W     8(A6),D6
035E: 3D47FFF2      MOVE.W     D7,-14(A6)
0362: 3E2E000A      MOVE.W     10(A6),D7
0366: 6006          BRA.S      $036E
0368: 7000          MOVEQ      #0,D0
036A: 600000E4      BRA.W      $0452
036E: 1883          MOVE.B     D3,(A4)
0370: 7011          MOVEQ      #17,D0
0372: C1C6          ANDA.L     D6,A0
0374: 49EDD76C      LEA        -10388(A5),A4                  ; g_lookup_tbl
0378: D08C          MOVE.B     A4,(A0)
037A: 3847          MOVEA.W    D7,A4
037C: D08C          MOVE.B     A4,(A0)
037E: 2840          MOVEA.L    D0,A4
0380: 1014          MOVE.B     (A4),D0
0382: 4880          EXT.W      D0
0384: 3F00          MOVE.W     D0,-(A7)
0386: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
038A: 1880          MOVE.B     D0,(A4)
038C: 3E87          MOVE.W     D7,(A7)
038E: 3F06          MOVE.W     D6,-(A7)
0390: 4EAD03DA      JSR        986(A5)                        ; JT[986]
0394: 7011          MOVEQ      #17,D0
0396: C1EEFFF4      ANDA.L     -12(A6),A0
039A: D08D          MOVE.B     A5,(A0)
039C: 386EFFF2      MOVEA.W    -14(A6),A4
03A0: 49ECD76C      LEA        -10388(A4),A4
03A4: D08C          MOVE.B     A4,(A0)
03A6: 2840          MOVEA.L    D0,A4
03A8: 1014          MOVE.B     (A4),D0
03AA: 4880          EXT.W      D0
03AC: 3E80          MOVE.W     D0,(A7)
03AE: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
03B2: 1880          MOVE.B     D0,(A4)
03B4: 3EAEFFF2      MOVE.W     -14(A6),(A7)
03B8: 3F2EFFF4      MOVE.W     -12(A6),-(A7)
03BC: 4EAD03DA      JSR        986(A5)                        ; JT[986]
03C0: 4A6E0010      TST.W      16(A6)
03C4: 5C8F          MOVE.B     A7,(A6)
03C6: 673C          BEQ.S      $0404
03C8: 7800          MOVEQ      #0,D4
03CA: 49EDDE28      LEA        -8664(A5),A4                   ; g_flag1
03CE: 3614          MOVE.W     (A4),D3
03D0: 4A43          TST.W      D3
03D2: 6730          BEQ.S      $0404
03D4: 3D43FFEC      MOVE.W     D3,-20(A6)
03D8: 45EDA54E      LEA        -23218(A5),A2                  ; A5-23218
03DC: D4EEFFEC      MOVE.B     -20(A6),(A2)+
03E0: 4A12          TST.B      (A2)
03E2: 660E          BNE.S      $03F2
03E4: 3F3C0001      MOVE.W     #$0001,-(A7)
03E8: 3F04          MOVE.W     D4,-(A7)
03EA: 4EBA01A8      JSR        424(PC)
03EE: 588F          MOVE.B     A7,(A4)
03F0: 600C          BRA.S      $03FE
03F2: 5312          MOVE.B     (A2),-(A1)
03F4: 4267          CLR.W      -(A7)
03F6: 3F04          MOVE.W     D4,-(A7)
03F8: 4EBA019A      JSR        410(PC)
03FC: 588F          MOVE.B     A7,(A4)
03FE: 5244          MOVEA.B    D4,A1
0400: 588C          MOVE.B     A4,(A4)
0402: 60CA          BRA.S      $03CE
0404: 4A6E000E      TST.W      14(A6)
0408: 6738          BEQ.S      $0442
040A: 4267          CLR.W      -(A7)
040C: 4EAD017A      JSR        378(A5)                        ; JT[378]
0410: 4A40          TST.W      D0
0412: 548F          MOVE.B     A7,(A2)
0414: 670A          BEQ.S      $0420
0416: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
041A: 4EAD02FA      JSR        762(A5)                        ; JT[762]
041E: 588F          MOVE.B     A7,(A4)
0420: 48780022      PEA        $0022.W
0424: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0428: 4EAD01AA      JSR        426(A5)                        ; JT[426]
042C: 508F          MOVE.B     A7,(A0)
042E: 6012          BRA.S      $0442
0430: 7011          MOVEQ      #17,D0
0432: C1EE0008      ANDA.L     8(A6),A0
0436: D08D          MOVE.B     A5,(A0)
0438: 306E000A      MOVEA.W    10(A6),A0
043C: D1C01143      MOVE.B     D0,$1143.W
0440: D76C3F2E000A  MOVE.B     16174(A4),10(A3)
0446: 3F2E0008      MOVE.W     8(A6),-(A7)
044A: 4EAD03DA      JSR        986(A5)                        ; JT[986]
044E: 7001          MOVEQ      #1,D0
0450: 4CEE1CF8FFCA  MOVEM.L    -54(A6),D3/D4/D5/D6/D7/A2/A3/A4
0456: 4E5E          UNLK       A6
0458: 4E75          RTS        


; ======= Function at 0x045A =======
045A: 4E560000      LINK       A6,#0
045E: 48E70700      MOVEM.L    D5/D6/D7,-(SP)                 ; save
0462: 3E2E0008      MOVE.W     8(A6),D7
0466: 3C2E000A      MOVE.W     10(A6),D6
046A: BE6DDE50      MOVEA.W    -8624(A5),A7
046E: 6606          BNE.S      $0476
0470: BC6DDE52      MOVEA.W    -8622(A5),A6
0474: 672A          BEQ.S      $04A0
0476: 3A2DDE50      MOVE.W     -8624(A5),D5                   ; A5-8624
047A: 3B47DE50      MOVE.W     D7,-8624(A5)
047E: 3E05          MOVE.W     D5,D7
0480: 3A2DDE52      MOVE.W     -8622(A5),D5                   ; A5-8622
0484: 3B46DE52      MOVE.W     D6,-8622(A5)
0488: 3C05          MOVE.W     D5,D6
048A: 3F06          MOVE.W     D6,-(A7)
048C: 3F07          MOVE.W     D7,-(A7)
048E: 4EAD03DA      JSR        986(A5)                        ; JT[986]
0492: 3EADDE52      MOVE.W     -8622(A5),(A7)                 ; A5-8622
0496: 3F2DDE50      MOVE.W     -8624(A5),-(A7)                ; A5-8624
049A: 4EAD03DA      JSR        986(A5)                        ; JT[986]
049E: 5C8F          MOVE.B     A7,(A6)
04A0: 4CDF00E0      MOVEM.L    (SP)+,D5/D6/D7                 ; restore
04A4: 4E5E          UNLK       A6
04A6: 4E75          RTS        


; ======= Function at 0x04A8 =======
04A8: 4E56FF80      LINK       A6,#-128                       ; frame=128
04AC: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
04B0: 7C00          MOVEQ      #0,D6
04B2: 48780080      PEA        $0080.W
04B6: 486D9512      PEA        -27374(A5)                     ; A5-27374
04BA: 486EFF80      PEA        -128(A6)
04BE: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
04C2: 7A01          MOVEQ      #1,D5
04C4: 49EDD89E      LEA        -10082(A5),A4                  ; A5-10082
04C8: 47EDD77D      LEA        -10371(A5),A3                  ; A5-10371
04CC: 4FEF000C      LEA        12(A7),A7
04D0: 6050          BRA.S      $0522
04D2: 7801          MOVEQ      #1,D4
04D4: 244B          MOVEA.L    A3,A2
04D6: 2E0C          MOVE.L     A4,D7
04D8: 6038          BRA.S      $0512
04DA: 16324000      MOVE.B     0(A2,D4.W),D3
04DE: 4883          EXT.W      D3
04E0: 4A43          TST.W      D3
04E2: 672C          BEQ.S      $0510
04E4: 3044          MOVEA.W    D4,A0
04E6: 10307800      MOVE.B     0(A0,D7.L),D0
04EA: 4880          EXT.W      D0
04EC: B640          MOVEA.W    D0,A3
04EE: 6620          BNE.S      $0510
04F0: 7000          MOVEQ      #0,D0
04F2: 1003          MOVE.B     D3,D0
04F4: 204D          MOVEA.L    A5,A0
04F6: D1C04A28      MOVE.B     D0,$4A28.W
04FA: FBD8          MOVE.W     (A0)+,???
04FC: 6A06          BPL.S      $0504
04FE: 532EFFBF      MOVE.B     -65(A6),-(A1)
0502: 600C          BRA.S      $0510
0504: 3F03          MOVE.W     D3,-(A7)
0506: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
050A: 53360080      MOVE.B     -128(A6,D0.W),-(A1)
050E: 548F          MOVE.B     A7,(A2)
0510: 5244          MOVEA.B    D4,A1
0512: 0C440010      CMPI.W     #$0010,D4
0516: 6DC2          BLT.S      $04DA
0518: 5245          MOVEA.B    D5,A1
051A: 49EC0011      LEA        17(A4),A4
051E: 47EB0011      LEA        17(A3),A3
0522: 0C450010      CMPI.W     #$0010,D5
0526: 6DAA          BLT.S      $04D2
0528: 7A00          MOVEQ      #0,D5
052A: 49EDDE28      LEA        -8664(A5),A4                   ; g_flag1
052E: 600A          BRA.S      $053A
0530: 3014          MOVE.W     (A4),D0
0532: 53360080      MOVE.B     -128(A6,D0.W),-(A1)
0536: 5245          MOVEA.B    D5,A1
0538: 588C          MOVE.B     A4,(A4)
053A: 4A54          TST.W      (A4)
053C: 66F2          BNE.S      $0530
053E: 206DDE78      MOVEA.L    -8584(A5),A0
0542: 2850          MOVEA.L    (A0),A4
0544: 49EC0312      LEA        786(A4),A4
0548: 266E0008      MOVEA.L    8(A6),A3
054C: 6028          BRA.S      $0576
054E: 18363080      MOVE.B     -128(A6,D3.W),D4
0552: 4884          EXT.W      D4
0554: 4A44          TST.W      D4
0556: 6F1C          BLE.S      $0574
0558: 3F03          MOVE.W     D3,-(A7)
055A: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
055E: 3600          MOVE.W     D0,D3
0560: DC44          MOVEA.B    D4,A6
0562: 7A00          MOVEQ      #0,D5
0564: 548F          MOVE.B     A7,(A2)
0566: 6004          BRA.S      $056C
0568: 16C3          MOVE.B     D3,(A3)+
056A: 5245          MOVEA.B    D5,A1
056C: B845          MOVEA.W    D5,A4
056E: 6EF8          BGT.S      $0568
0570: 16FC0020      MOVE.B     #$20,(A3)+
0574: 528C          MOVE.B     A4,(A1)
0576: 1614          MOVE.B     (A4),D3
0578: 4883          EXT.W      D3
057A: 4A43          TST.W      D3
057C: 66D0          BNE.S      $054E
057E: 3F06          MOVE.W     D6,-(A7)
0580: 486DEEDA      PEA        -4390(A5)                      ; A5-4390
0584: 2F0B          MOVE.L     A3,-(A7)
0586: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
058A: 4CEE1CF8FF60  MOVEM.L    -160(A6),D3/D4/D5/D6/D7/A2/A3/A4
0590: 4E5E          UNLK       A6
0592: 4E75          RTS        


; ======= Function at 0x0594 =======
0594: 4E560000      LINK       A6,#0
0598: 2F0C          MOVE.L     A4,-(A7)
059A: 49EDDE2A      LEA        -8662(A5),A4                   ; A5-8662
059E: 302E0008      MOVE.W     8(A6),D0
05A2: 48C0          EXT.L      D0
05A4: E588D08C      MOVE.L     A0,-116(A2,A5.W)
05A8: 2840          MOVEA.L    D0,A4
05AA: 3014          MOVE.W     (A4),D0
05AC: B06E000A      MOVEA.W    10(A6),A0
05B0: 670E          BEQ.S      $05C0
05B2: 38AE000A      MOVE.W     10(A6),(A4)
05B6: 3F2E0008      MOVE.W     8(A6),-(A7)
05BA: 4EBA251A      JSR        9498(PC)
05BE: 548F          MOVE.B     A7,(A2)
05C0: 285F          MOVEA.L    (A7)+,A4
05C2: 4E5E          UNLK       A6
05C4: 4E75          RTS        


; ======= Function at 0x05C6 =======
05C6: 4E560000      LINK       A6,#0
05CA: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
05CE: 286E0008      MOVEA.L    8(A6),A4
05D2: 7E00          MOVEQ      #0,D7
05D4: 47EDDE28      LEA        -8664(A5),A3                   ; g_flag1
05D8: 600E          BRA.S      $05E8
05DA: 4A6B0002      TST.W      2(A3)
05DE: 6604          BNE.S      $05E4
05E0: 18EB0001      MOVE.B     1(A3),(A4)+
05E4: 5247          MOVEA.B    D7,A1
05E6: 588B          MOVE.B     A3,(A4)
05E8: 4A53          TST.W      (A3)
05EA: 66EE          BNE.S      $05DA
05EC: 4214          CLR.B      (A4)
05EE: 202E0008      MOVE.L     8(A6),D0
05F2: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
05F6: 4E5E          UNLK       A6
05F8: 4E75          RTS        


; ======= Function at 0x05FA =======
05FA: 4E560000      LINK       A6,#0
05FE: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
0602: 286E0008      MOVEA.L    8(A6),A4
0606: 2F0C          MOVE.L     A4,-(A7)
0608: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
060C: 5F80588F      MOVE.B     D0,-113(A7,D5.L)
0610: 6304          BLS.S      $0616
0612: 7000          MOVEQ      #0,D0
0614: 6062          BRA.S      $0678
0616: 7E00          MOVEQ      #0,D7
0618: 47EDDE28      LEA        -8664(A5),A3                   ; g_flag1
061C: 1C347000      MOVE.B     0(A4,D7.W),D6
0620: 3447          MOVEA.W    D7,A2
0622: D5CC4A06      MOVE.B     A4,18950(PC)
0626: 6730          BEQ.S      $0658
0628: 7000          MOVEQ      #0,D0
062A: 1006          MOVE.B     D6,D0
062C: 204D          MOVEA.L    A5,A0
062E: D1C01028      MOVE.B     D0,$1028.W
0632: FBD8          MOVE.W     (A0)+,???
0634: 020000C0      ANDI.B     #$00C0,D0
0638: 660A          BNE.S      $0644
063A: 0C06003F      CMPI.B     #$003F,D6
063E: 6704          BEQ.S      $0644
0640: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0644: 1012          MOVE.B     (A2),D0
0646: 4880          EXT.W      D0
0648: 3F00          MOVE.W     D0,-(A7)
064A: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
064E: 3680          MOVE.W     D0,(A3)
0650: 548F          MOVE.B     A7,(A2)
0652: 5247          MOVEA.B    D7,A1
0654: 588B          MOVE.B     A3,(A4)
0656: 60C4          BRA.S      $061C
0658: 3F3C03FF      MOVE.W     #$03FF,-(A7)
065C: 4EAD058A      JSR        1418(A5)                       ; JT[1418]
0660: 4A40          TST.W      D0
0662: 548F          MOVE.B     A7,(A2)
0664: 6604          BNE.S      $066A
0666: 7000          MOVEQ      #0,D0
0668: 600E          BRA.S      $0678
066A: 42A7          CLR.L      -(A7)
066C: 2F0C          MOVE.L     A4,-(A7)
066E: 4EBAFF56      JSR        -170(PC)
0672: 2E80          MOVE.L     D0,(A7)
0674: 4EBA000C      JSR        12(PC)
0678: 4CEE1CC0FFEC  MOVEM.L    -20(A6),D6/D7/A2/A3/A4
067E: 4E5E          UNLK       A6
0680: 4E75          RTS        


; ======= Function at 0x0682 =======
0682: 4E56FEF8      LINK       A6,#-264                       ; frame=264
0686: 48E70718      MOVEM.L    D5/D6/D7/A3/A4,-(SP)           ; save
068A: 48780100      PEA        $0100.W
068E: 486EFF00      PEA        -256(A6)
0692: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0696: 7E01          MOVEQ      #1,D7
0698: 49EDD77D      LEA        -10371(A5),A4                  ; A5-10371
069C: 508F          MOVE.B     A7,(A0)
069E: 6058          BRA.S      $06F8
06A0: 7C01          MOVEQ      #1,D6
06A2: 264C          MOVEA.L    A4,A3
06A4: 6046          BRA.S      $06EC
06A6: 1A336000      MOVE.B     0(A3,D6.W),D5
06AA: 4885          EXT.W      D5
06AC: 4A45          TST.W      D5
06AE: 673A          BEQ.S      $06EA
06B0: 4A2DD7FC      TST.B      -10244(A5)
06B4: 660E          BNE.S      $06C4
06B6: 3F3C03E9      MOVE.W     #$03E9,-(A7)
06BA: 4EAD0C6A      JSR        3178(A5)                       ; JT[3178]
06BE: 7000          MOVEQ      #0,D0
06C0: 600000DA      BRA.W      $079E
06C4: 7000          MOVEQ      #0,D0
06C6: 1005          MOVE.B     D5,D0
06C8: 204D          MOVEA.L    A5,A0
06CA: D1C04A28      MOVE.B     D0,$4A28.W
06CE: FBD8          MOVE.W     (A0)+,???
06D0: 6A06          BPL.S      $06D8
06D2: 526EFF7E      MOVEA.B    -130(A6),A1
06D6: 6012          BRA.S      $06EA
06D8: 3F05          MOVE.W     D5,-(A7)
06DA: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
06DE: 204E          MOVEA.L    A6,A0
06E0: D0C0          MOVE.B     D0,(A0)+
06E2: D0C0          MOVE.B     D0,(A0)+
06E4: 5268FF00      MOVEA.B    -256(A0),A1
06E8: 548F          MOVE.B     A7,(A2)
06EA: 5246          MOVEA.B    D6,A1
06EC: 0C460010      CMPI.W     #$0010,D6
06F0: 6DB4          BLT.S      $06A6
06F2: 5247          MOVEA.B    D7,A1
06F4: 49EC0011      LEA        17(A4),A4
06F8: 0C470010      CMPI.W     #$0010,D7
06FC: 6DA2          BLT.S      $06A0
06FE: 4AAE0008      TST.L      8(A6)
0702: 660C          BNE.S      $0710
0704: 601A          BRA.S      $0720
0706: 204E          MOVEA.L    A6,A0
0708: D0C5          MOVE.B     D5,(A0)+
070A: D0C5          MOVE.B     D5,(A0)+
070C: 5268FF00      MOVEA.B    -256(A0),A1
0710: 206E0008      MOVEA.L    8(A6),A0
0714: 52AE0008      MOVE.B     8(A6),(A1)
0718: 1A10          MOVE.B     (A0),D5
071A: 4885          EXT.W      D5
071C: 4A45          TST.W      D5
071E: 66E6          BNE.S      $0706
0720: 4AAE000C      TST.L      12(A6)
0724: 660C          BNE.S      $0732
0726: 601A          BRA.S      $0742
0728: 204E          MOVEA.L    A6,A0
072A: D0C5          MOVE.B     D5,(A0)+
072C: D0C5          MOVE.B     D5,(A0)+
072E: 5268FF00      MOVEA.B    -256(A0),A1
0732: 206E000C      MOVEA.L    12(A6),A0
0736: 52AE000C      MOVE.B     12(A6),(A1)
073A: 1A10          MOVE.B     (A0),D5
073C: 4885          EXT.W      D5
073E: 4A45          TST.W      D5
0740: 66E6          BNE.S      $0728
0742: 286D99D2      MOVEA.L    -26158(A5),A4
0746: 604A          BRA.S      $0792
0748: 204E          MOVEA.L    A6,A0
074A: D0C5          MOVE.B     D5,(A0)+
074C: D0C5          MOVE.B     D5,(A0)+
074E: 224D          MOVEA.L    A5,A1
0750: D2C5          MOVE.B     D5,(A1)+
0752: 10299512      MOVE.B     -27374(A1),D0
0756: 4880          EXT.W      D0
0758: B068FF00      MOVEA.W    -256(A0),A0
075C: 6C34          BGE.S      $0792
075E: 1D45FEF8      MOVE.B     D5,-264(A6)
0762: 422EFEF9      CLR.B      -263(A6)
0766: 0C45003F      CMPI.W     #$003F,D5
076A: 6708          BEQ.S      $0774
076C: 41EEFEF8      LEA        -264(A6),A0
0770: 2008          MOVE.L     A0,D0
0772: 6006          BRA.S      $077A
0774: 41EDEEDE      LEA        -4386(A5),A0                   ; A5-4386
0778: 2008          MOVE.L     A0,D0
077A: 2F00          MOVE.L     D0,-(A7)
077C: 4EAD0C62      JSR        3170(A5)                       ; JT[3170]
0780: 3EBC03F1      MOVE.W     #$03F1,(A7)
0784: 4EAD0C6A      JSR        3178(A5)                       ; JT[3178]
0788: 5340588F      MOVE.B     D0,22671(A1)
078C: 6704          BEQ.S      $0792
078E: 7000          MOVEQ      #0,D0
0790: 600A          BRA.S      $079C
0792: 1A1C          MOVE.B     (A4)+,D5
0794: 4885          EXT.W      D5
0796: 4A45          TST.W      D5
0798: 66AE          BNE.S      $0748
079A: 7001          MOVEQ      #1,D0
079C: 4CEE18E0FEE4  MOVEM.L    -284(A6),D5/D6/D7/A3/A4
07A2: 4E5E          UNLK       A6
07A4: 4E75          RTS        

07A6: 4EBA0B64      JSR        2916(PC)
07AA: 4EAD03C2      JSR        962(A5)                        ; JT[962]
07AE: 4267          CLR.W      -(A7)
07B0: 4EBA0C46      JSR        3142(PC)
07B4: 4EBA03CC      JSR        972(PC)
07B8: 4EBA0270      JSR        624(PC)
07BC: 548F          MOVE.B     A7,(A2)
07BE: 4E75          RTS        

07C0: 4A6DD9AE      TST.W      -9810(A5)
07C4: 670E          BEQ.S      $07D4
07C6: 4EAD043A      JSR        1082(A5)                       ; JT[1082]
07CA: 4EAD03C2      JSR        962(A5)                        ; JT[962]
07CE: 4EBA001C      JSR        28(PC)
07D2: 6012          BRA.S      $07E6
07D4: 4A6DDE54      TST.W      -8620(A5)
07D8: 670C          BEQ.S      $07E6
07DA: 4EBA1194      JSR        4500(PC)
07DE: 3F00          MOVE.W     D0,-(A7)
07E0: 4EAD0162      JSR        354(A5)                        ; JT[354]
07E4: 548F          MOVE.B     A7,(A2)
07E6: 426DDE54      CLR.W      -8620(A5)
07EA: 4E75          RTS        

07EC: 426DD9AE      CLR.W      -9810(A5)
07F0: 4EBA110A      JSR        4362(PC)
07F4: 2F00          MOVE.L     D0,-(A7)
07F6: 4EBA110C      JSR        4364(PC)
07FA: 4EBA10FA      JSR        4346(PC)
07FE: 2B40DE5A      MOVE.L     D0,-8614(A5)
0802: 4EBA106C      JSR        4204(PC)
0806: 588F          MOVE.B     A7,(A4)
0808: 4E75          RTS        

080A: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
080E: 4EBA288E      JSR        10382(PC)
0812: 4A40          TST.W      D0
0814: 670E          BEQ.S      $0824
0816: 3F3C0001      MOVE.W     #$0001,-(A7)
081A: 4EBA0106      JSR        262(PC)
081E: 548F          MOVE.B     A7,(A2)
0820: 600000D2      BRA.W      $08F6
0824: 4A6DD9AE      TST.W      -9810(A5)
0828: 670000A8      BEQ.W      $08D4
082C: 4EBA21EA      JSR        8682(PC)
0830: 4A40          TST.W      D0
0832: 670000C0      BEQ.W      $08F6
0836: 4A2DC366      TST.B      -15514(A5)
083A: 6728          BEQ.S      $0864
083C: 4267          CLR.W      -(A7)
083E: 4EAD017A      JSR        378(A5)                        ; JT[378]
0842: 4A40          TST.W      D0
0844: 548F          MOVE.B     A7,(A2)
0846: 671C          BEQ.S      $0864
0848: 4A6DDE54      TST.W      -8620(A5)
084C: 6616          BNE.S      $0864
084E: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0852: 3F3C7FFF      MOVE.W     #$7FFF,-(A7)
0856: 4EBA21A8      JSR        8616(PC)
085A: 4EBA0AB0      JSR        2736(PC)
085E: 7E00          MOVEQ      #0,D7
0860: 5C8F          MOVE.B     A7,(A6)
0862: 6002          BRA.S      $0866
0864: 7E01          MOVEQ      #1,D7
0866: 4EAD0422      JSR        1058(A5)                       ; JT[1058]
086A: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
086E: 2B48C376      MOVE.L     A0,-15498(A5)
0872: 7C00          MOVEQ      #0,D6
0874: 49EDDE28      LEA        -8664(A5),A4                   ; g_flag1
0878: 6012          BRA.S      $088C
087A: 204D          MOVEA.L    A5,A0
087C: D0C6          MOVE.B     D6,(A0)+
087E: 116C0001C366  MOVE.B     1(A4),-15514(A0)
0884: 426C0002      CLR.W      2(A4)
0888: 5246          MOVEA.B    D6,A1
088A: 588C          MOVE.B     A4,(A4)
088C: 4A54          TST.W      (A4)
088E: 66EA          BNE.S      $087A
0890: 204D          MOVEA.L    A5,A0
0892: D0C6          MOVE.B     D6,(A0)+
0894: 4228C366      CLR.B      -15514(A0)
0898: 422DC35E      CLR.B      -15522(A5)
089C: 486DC35E      PEA        -15522(A5)                     ; g_field_22
08A0: 4EAD0582      JSR        1410(A5)                       ; JT[1410]
08A4: 486DC366      PEA        -15514(A5)                     ; g_field_14
08A8: 4EAD0582      JSR        1410(A5)                       ; JT[1410]
08AC: 486DC366      PEA        -15514(A5)                     ; g_field_14
08B0: 4EBAF74E      JSR        -2226(PC)
08B4: 4EBAFF36      JSR        -202(PC)
08B8: 4EAD03C2      JSR        962(A5)                        ; JT[962]
08BC: 4A47          TST.W      D7
08BE: 4FEF000C      LEA        12(A7),A7
08C2: 6730          BEQ.S      $08F4
08C4: 42ADC372      CLR.L      -15502(A5)
08C8: 42ADC36E      CLR.L      -15506(A5)
08CC: 4EAD012A      JSR        298(A5)                        ; JT[298]
08D0: 6022          BRA.S      $08F4
08D2: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
08D6: B1EDC3766618  MOVE.W     -15498(A5),$6618.W             ; A5-15498
08DC: 3F3C03FB      MOVE.W     #$03FB,-(A7)
08E0: 4EAD017A      JSR        378(A5)                        ; JT[378]
08E4: 4A40          TST.W      D0
08E6: 548F          MOVE.B     A7,(A2)
08E8: 670A          BEQ.S      $08F4
08EA: 3B7C0007DE64  MOVE.W     #$0007,-8604(A5)
08F0: 4EAD0292      JSR        658(A5)                        ; JT[658]
08F4: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
08F8: 4E75          RTS        

08FA: 2F07          MOVE.L     D7,-(A7)
08FC: 4EAD0932      JSR        2354(A5)                       ; JT[2354]
0900: 4A40          TST.W      D0
0902: 6706          BEQ.S      $090A
0904: 4A6DDE28      TST.W      -8664(A5)
0908: 6604          BNE.S      $090E
090A: 7E00          MOVEQ      #0,D7
090C: 6002          BRA.S      $0910
090E: 7E01          MOVEQ      #1,D7
0910: BE6DDE5E      MOVEA.W    -8610(A5),A7
0914: 6708          BEQ.S      $091E
0916: 3B47DE5E      MOVE.W     D7,-8610(A5)
091A: 4EBA20D2      JSR        8402(PC)
091E: 2E1F          MOVE.L     (A7)+,D7
0920: 4E75          RTS        


; ======= Function at 0x0922 =======
0922: 4E560000      LINK       A6,#0
0926: 4AADEED6      TST.L      -4394(A5)
092A: 670000EC      BEQ.W      $0A1A
092E: 4A6E0008      TST.W      8(A6)
0932: 6626          BNE.S      $095A
0934: 48780220      PEA        $0220.W
0938: 2F2DEEC2      MOVE.L     -4414(A5),-(A7)                ; A5-4414
093C: 486D97B2      PEA        -26702(A5)                     ; A5-26702
0940: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0944: 48780220      PEA        $0220.W
0948: 2F2DEEC6      MOVE.L     -4410(A5),-(A7)                ; A5-4410
094C: 486D9592      PEA        -27246(A5)                     ; A5-27246
0950: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0954: 4FEF0018      LEA        24(A7),A7
0958: 603E          BRA.S      $0998
095A: 4AADDE60      TST.L      -8608(A5)
095E: 6604          BNE.S      $0964
0960: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0964: 4EBA2A7A      JSR        10874(PC)
0968: 48780220      PEA        $0220.W
096C: 486D97B2      PEA        -26702(A5)                     ; A5-26702
0970: 206DDE60      MOVEA.L    -8608(A5),A0
0974: 2F10          MOVE.L     (A0),-(A7)
0976: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
097A: 48780220      PEA        $0220.W
097E: 486D9592      PEA        -27246(A5)                     ; A5-27246
0982: 206DDE60      MOVEA.L    -8608(A5),A0
0986: 2050          MOVEA.L    (A0),A0
0988: 48680220      PEA        544(A0)
098C: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0990: 4EBA2A68      JSR        10856(PC)
0994: 4FEF0018      LEA        24(A7),A7
0998: 48780121      PEA        $0121.W
099C: 2F2DEECE      MOVE.L     -4402(A5),-(A7)                ; A5-4402
09A0: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
09A4: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
09A8: 48780121      PEA        $0121.W
09AC: 2F2DEED2      MOVE.L     -4398(A5),-(A7)                ; A5-4398
09B0: 486DD88D      PEA        -10099(A5)                     ; A5-10099
09B4: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
09B8: 48780220      PEA        $0220.W
09BC: 2F2DEECA      MOVE.L     -4406(A5),-(A7)                ; A5-4406
09C0: 486DBCFE      PEA        -17154(A5)                     ; g_state1
09C4: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
09C8: 48780440      PEA        $0440.W
09CC: 2F2DEED6      MOVE.L     -4394(A5),-(A7)                ; A5-4394
09D0: 486DBF1E      PEA        -16610(A5)                     ; g_state2
09D4: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
09D8: 2EADEEC2      MOVE.L     -4414(A5),(A7)                 ; A5-4414
09DC: 4EAD068A      JSR        1674(A5)                       ; JT[1674]
09E0: 2EADEEC6      MOVE.L     -4410(A5),(A7)                 ; A5-4410
09E4: 4EAD068A      JSR        1674(A5)                       ; JT[1674]
09E8: 2EADEECE      MOVE.L     -4402(A5),(A7)                 ; A5-4402
09EC: 4EAD068A      JSR        1674(A5)                       ; JT[1674]
09F0: 2EADEED2      MOVE.L     -4398(A5),(A7)                 ; A5-4398
09F4: 4EAD068A      JSR        1674(A5)                       ; JT[1674]
09F8: 2EADEECA      MOVE.L     -4406(A5),(A7)                 ; A5-4406
09FC: 4EAD068A      JSR        1674(A5)                       ; JT[1674]
0A00: 2EADEED6      MOVE.L     -4394(A5),(A7)                 ; A5-4394
0A04: 4EAD068A      JSR        1674(A5)                       ; JT[1674]
0A08: 7018          MOVEQ      #24,D0
0A0A: 2E80          MOVE.L     D0,(A7)
0A0C: 486DEEC2      PEA        -4414(A5)                      ; A5-4414
0A10: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0A14: 4FEF0034      LEA        52(A7),A7
0A18: 4EBA0E62      JSR        3682(PC)
0A1C: 4EBA0EDE      JSR        3806(PC)
0A20: 2F00          MOVE.L     D0,-(A7)
0A22: 4EBA0EE0      JSR        3808(PC)
0A26: 4E5E          UNLK       A6
0A28: 4E75          RTS        

0A2A: 48780220      PEA        $0220.W
0A2E: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
0A32: 2B40EEC2      MOVE.L     D0,-4414(A5)
0A36: 48780220      PEA        $0220.W
0A3A: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
0A3E: 2B40EEC6      MOVE.L     D0,-4410(A5)
0A42: 48780121      PEA        $0121.W
0A46: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
0A4A: 2B40EECE      MOVE.L     D0,-4402(A5)
0A4E: 48780121      PEA        $0121.W
0A52: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
0A56: 2B40EED2      MOVE.L     D0,-4398(A5)
0A5A: 48780220      PEA        $0220.W
0A5E: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
0A62: 2B40EECA      MOVE.L     D0,-4406(A5)
0A66: 48780440      PEA        $0440.W
0A6A: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
0A6E: 2B40EED6      MOVE.L     D0,-4394(A5)
0A72: 4AADEED6      TST.L      -4394(A5)
0A76: 4FEF0018      LEA        24(A7),A7
0A7A: 6604          BNE.S      $0A80
0A7C: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0A80: 48780220      PEA        $0220.W
0A84: 486D97B2      PEA        -26702(A5)                     ; A5-26702
0A88: 2F2DEEC2      MOVE.L     -4414(A5),-(A7)                ; A5-4414
0A8C: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0A90: 48780220      PEA        $0220.W
0A94: 486D9592      PEA        -27246(A5)                     ; A5-27246
0A98: 2F2DEEC6      MOVE.L     -4410(A5),-(A7)                ; A5-4410
0A9C: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0AA0: 48780121      PEA        $0121.W
0AA4: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
0AA8: 2F2DEECE      MOVE.L     -4402(A5),-(A7)                ; A5-4402
0AAC: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0AB0: 48780121      PEA        $0121.W
0AB4: 486DD88D      PEA        -10099(A5)                     ; A5-10099
0AB8: 2F2DEED2      MOVE.L     -4398(A5),-(A7)                ; A5-4398
0ABC: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0AC0: 48780220      PEA        $0220.W
0AC4: 486DBCFE      PEA        -17154(A5)                     ; g_state1
0AC8: 2F2DEECA      MOVE.L     -4406(A5),-(A7)                ; A5-4406
0ACC: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0AD0: 48780440      PEA        $0440.W
0AD4: 486DBF1E      PEA        -16610(A5)                     ; g_state2
0AD8: 2F2DEED6      MOVE.L     -4394(A5),-(A7)                ; A5-4394
0ADC: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0AE0: 48780121      PEA        $0121.W
0AE4: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
0AE8: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0AEC: 48780121      PEA        $0121.W
0AF0: 486DD88D      PEA        -10099(A5)                     ; A5-10099
0AF4: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0AF8: 48780220      PEA        $0220.W
0AFC: 486DBCFE      PEA        -17154(A5)                     ; g_state1
0B00: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0B04: 48780440      PEA        $0440.W
0B08: 486DBF1E      PEA        -16610(A5)                     ; g_state2
0B0C: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0B10: 4FEF0068      LEA        104(A7),A7
0B14: 4EBA0DA0      JSR        3488(PC)
0B18: 486DEEE4      PEA        -4380(A5)                      ; A5-4380
0B1C: 4EBA0DE6      JSR        3558(PC)
0B20: 588F          MOVE.B     A7,(A4)
0B22: 4E75          RTS        


; ======= Function at 0x0B24 =======
0B24: 4E560000      LINK       A6,#0
0B28: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0B2C: 3E2E0008      MOVE.W     8(A6),D7
0B30: 700A          MOVEQ      #10,D0
0B32: C1C7          ANDA.L     D7,A0
0B34: 49EDEFE2      LEA        -4126(A5),A4                   ; A5-4126
0B38: D08C          MOVE.B     A4,(A0)
0B3A: 2840          MOVEA.L    D0,A4
0B3C: 2F14          MOVE.L     (A4),-(A7)
0B3E: A9A3536D      MOVE.L     -(A3),109(A4,D5.W*2)
0B42: EF1C          MOVE.L     (A4)+,-(A7)
0B44: 302DEF1C      MOVE.W     -4324(A5),D0                   ; A5-4324
0B48: 9047          MOVEA.B    D7,A0
0B4A: C1FC000A2F00  ANDA.L     #$000A2F00,A0
0B50: 7001          MOVEQ      #1,D0
0B52: D047          MOVEA.B    D7,A0
0B54: C1FC000A204D  ANDA.L     #$000A204D,A0
0B5A: D1C04868      MOVE.B     D0,$4868.W
0B5E: EFE2          MOVE.L     -(A2),???
0B60: 2F0C          MOVE.L     A4,-(A7)
0B62: 4EAD0D82      JSR        3458(A5)                       ; JT[3458]
0B66: 4A47          TST.W      D7
0B68: 4FEF000C      LEA        12(A7),A7
0B6C: 660C          BNE.S      $0B7A
0B6E: 2038016A      MOVE.L     $016A.W,D0
0B72: D1ADEFE64EBA  MOVE.B     -4122(A5),-70(A0,D4.L*8)       ; A5-4122
0B78: 000A4CDF      ORI.B      #$4CDF,A2
0B7C: 1080          MOVE.B     D0,(A0)
0B7E: 4E5E          UNLK       A6
0B80: 4E75          RTS        

0B82: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
0B86: A873206D      MOVEA.L    109(A3,D2.W),A4
0B8A: DE80          MOVE.B     D0,(A7)
0B8C: 48680062      PEA        98(A0)
0B90: A9284E75      MOVE.L     20085(A0),-(A4)
0B94: 2F0C          MOVE.L     A4,-(A7)
0B96: 206DDE78      MOVEA.L    -8584(A5),A0
0B9A: 2050          MOVEA.L    (A0),A0
0B9C: 4A680310      TST.W      784(A0)
0BA0: 6740          BEQ.S      $0BE2
0BA2: 4A6DEF1C      TST.W      -4324(A5)
0BA6: 673A          BEQ.S      $0BE2
0BA8: 4227          CLR.B      -(A7)
0BAA: 206DDE80      MOVEA.L    -8576(A5),A0
0BAE: 48680062      PEA        98(A0)
0BB2: 226DDEC2      MOVEA.L    -8510(A5),A1
0BB6: 2F290018      MOVE.L     24(A1),-(A7)
0BBA: A8E94A1F      MOVE.L     18975(A1),(A4)+
0BBE: 6722          BEQ.S      $0BE2
0BC0: 286DEFE2      MOVEA.L    -4126(A5),A4
0BC4: 204C          MOVEA.L    A4,A0
0BC6: A0292F14      MOVE.L     12052(A1),D0
0BCA: 42A7          CLR.L      -(A7)
0BCC: 2F0C          MOVE.L     A4,-(A7)
0BCE: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0BD2: 206DDE80      MOVEA.L    -8576(A5),A0
0BD6: 48680062      PEA        98(A0)
0BDA: 4267          CLR.W      -(A7)
0BDC: A9CE204CA02A  MOVE.L     A6,#$204CA02A
0BE2: 285F          MOVEA.L    (A7)+,A4
0BE4: 4E75          RTS        


; ======= Function at 0x0BE6 =======
0BE6: 4E56FFF8      LINK       A6,#-8                         ; frame=8
0BEA: 2F07          MOVE.L     D7,-(A7)
0BEC: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
0BF0: A8737E00      MOVEA.L    0(A3,D7.L*8),A4
0BF4: 6014          BRA.S      $0C0A
0BF6: 486EFFF8      PEA        -8(A6)
0BFA: 3F07          MOVE.W     D7,-(A7)
0BFC: 4EBA1E7C      JSR        7804(PC)
0C00: 486EFFF8      PEA        -8(A6)
0C04: A9285C8F      MOVE.L     23695(A0),-(A4)
0C08: 5247          MOVEA.B    D7,A1
0C0A: 0C470007      CMPI.W     #$0007,D7
0C0E: 6DE6          BLT.S      $0BF6
0C10: 2E1F          MOVE.L     (A7)+,D7
0C12: 4E5E          UNLK       A6
0C14: 4E75          RTS        


; ======= Function at 0x0C16 =======
0C16: 4E56FFF4      LINK       A6,#-12                        ; frame=12
0C1A: 48E70F18      MOVEM.L    D4/D5/D6/D7/A3/A4,-(SP)        ; save
0C1E: 3E2E000C      MOVE.W     12(A6),D7
0C22: 206E0008      MOVEA.L    8(A6),A0
0C26: 286800CA      MOVEA.L    202(A0),A4
0C2A: 42A7          CLR.L      -(A7)
0C2C: 2F0C          MOVE.L     A4,-(A7)
0C2E: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0C32: 2D5FFFF4      MOVE.L     (A7)+,-12(A6)
0C36: 48780006      PEA        $0006.W
0C3A: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
0C3E: 4EAD004A      JSR        74(A5)                         ; JT[74]
0C42: 3047          MOVEA.W    D7,A0
0C44: B088          MOVE.W     A0,(A0)
0C46: 641A          BCC.S      $0C62
0C48: 42A7          CLR.L      -(A7)
0C4A: 2F0C          MOVE.L     A4,-(A7)
0C4C: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0C50: 2D5FFFF4      MOVE.L     (A7)+,-12(A6)
0C54: 48780006      PEA        $0006.W
0C58: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
0C5C: 4EAD004A      JSR        74(A5)                         ; JT[74]
0C60: 3E00          MOVE.W     D0,D7
0C62: 0C2E0001000E  CMPI.B     #$0001,14(A6)
0C68: 6706          BEQ.S      $0C70
0C6A: 4A2E000E      TST.B      14(A6)
0C6E: 6614          BNE.S      $0C84
0C70: 2C07          MOVE.L     D7,D6
0C72: 48C6          EXT.L      D6
0C74: 8DFC00024846  ORA.L      #$00024846,A6
0C7A: 7A02          MOVEQ      #2,D5
0C7C: DA46          MOVEA.B    D6,A5
0C7E: 3806          MOVE.W     D6,D4
0C80: D847          MOVEA.B    D7,A4
0C82: 6004          BRA.S      $0C88
0C84: 7A01          MOVEQ      #1,D5
0C86: 3807          MOVE.W     D7,D4
0C88: 7006          MOVEQ      #6,D0
0C8A: C1C5          ANDA.L     D5,A0
0C8C: 2F00          MOVE.L     D0,-(A7)
0C8E: 2F0C          MOVE.L     A4,-(A7)
0C90: 4EAD05CA      JSR        1482(A5)                       ; JT[1482]
0C94: 2EAE0008      MOVE.L     8(A6),(A7)
0C98: A873204C      MOVEA.L    76(A3,D2.W),A4
0C9C: A029588F      MOVE.L     22671(A1),D0
0CA0: 6066          BRA.S      $0D08
0CA2: 3C05          MOVE.W     D5,D6
0CA4: DC47          MOVEA.B    D7,A6
0CA6: 7006          MOVEQ      #6,D0
0CA8: C1C6          ANDA.L     D6,A0
0CAA: 2640          MOVEA.L    D0,A3
0CAC: 204B          MOVEA.L    A3,A0
0CAE: D1D410BC      MOVE.B     (A4),$10BC.W
0CB2: 00047000      ORI.B      #$7000,D4
0CB6: A122          MOVE.L     -(A2),-(A0)
0CB8: 2014          MOVE.L     (A4),D0
0CBA: 27880802      MOVE.L     A0,2(A3,D0.L)
0CBE: 0C460016      CMPI.W     #$0016,D6
0CC2: 6F06          BLE.S      $0CCA
0CC4: 7C16          MOVEQ      #22,D6
0CC6: 9C45          MOVEA.B    D5,A6
0CC8: 5346703E      MOVE.B     D6,28734(A1)
0CCC: D0ADDE80      MOVE.B     -8576(A5),(A0)                 ; A5-8576
0CD0: 2640          MOVEA.L    D0,A3
0CD2: 70EF          MOVEQ      #-17,D0
0CD4: D06B0006      MOVEA.B    6(A3),A0
0CD8: 3D40FFFE      MOVE.W     D0,-2(A6)
0CDC: 3D6B0002FFFA  MOVE.W     2(A3),-6(A6)
0CE2: 2006          MOVE.L     D6,D0
0CE4: 48C0          EXT.L      D0
0CE6: 81FC0002C1FC  ORA.L      #$0002C1FC,A0
0CEC: 000CD053      ORI.B      #$D053,A4
0CF0: 0640000F      ADDI.W     #$000F,D0
0CF4: 3D40FFF8      MOVE.W     D0,-8(A6)
0CF8: 700C          MOVEQ      #12,D0
0CFA: D06EFFF8      MOVEA.B    -8(A6),A0
0CFE: 3D40FFFC      MOVE.W     D0,-4(A6)
0D02: 486EFFF8      PEA        -8(A6)
0D06: A9285345      MOVE.L     21317(A0),-(A4)
0D0A: 4A45          TST.W      D5
0D0C: 6C94          BGE.S      $0CA2
0D0E: 204C          MOVEA.L    A4,A0
0D10: A02A4EBA      MOVE.L     20154(A2),D0
0D14: 078E          BCLR       D3,A6
0D16: 3004          MOVE.W     D4,D0
0D18: 4CDF18F0      MOVEM.L    (SP)+,D4/D5/D6/D7/A3/A4        ; restore
0D1C: 4E5E          UNLK       A6
0D1E: 4E75          RTS        


; ======= Function at 0x0D20 =======
0D20: 4E56FE62      LINK       A6,#-414                       ; frame=414
0D24: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0D28: 206DDE80      MOVEA.L    -8576(A5),A0
0D2C: 7A0D          MOVEQ      #13,D5
0D2E: DA68003E      MOVEA.B    62(A0),A5
0D32: 700E          MOVEQ      #14,D0
0D34: D0680040      MOVEA.B    64(A0),A0
0D38: 3D40FE74      MOVE.W     D0,-396(A6)
0D3C: 72F0          MOVEQ      #-16,D1
0D3E: D2680044      MOVEA.B    68(A0),A1
0D42: 3D41FE76      MOVE.W     D1,-394(A6)
0D46: 3C280044      MOVE.W     68(A0),D6
0D4A: DC680040      MOVEA.B    64(A0),A6
0D4E: 554648C6      MOVE.B     D6,18630(A2)
0D52: 8DFC00024227  ORA.L      #$00024227,A6
0D58: 4868003E      PEA        62(A0)
0D5C: 226DDEC2      MOVEA.L    -8510(A5),A1
0D60: 2F290018      MOVE.L     24(A1),-(A7)
0D64: A8E94A1F      MOVE.L     18975(A1),(A4)+
0D68: 6700059A      BEQ.W      $1306
0D6C: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
0D70: A8732F3C      MOVEA.L    60(A3,D2.L*8),A4
0D74: 00020002      ORI.B      #$0002,D2
0D78: A89B          MOVE.L     (A3)+,(A4)
0D7A: 206DDE80      MOVEA.L    -8576(A5),A0
0D7E: 4868003E      PEA        62(A0)
0D82: A8A1          MOVE.L     -(A1),(A4)
0D84: 206DDE80      MOVEA.L    -8576(A5),A0
0D88: 3F280040      MOVE.W     64(A0),-(A7)
0D8C: 3F05          MOVE.W     D5,-(A7)
0D8E: A893          MOVE.L     (A3),(A4)
0D90: 206DDE80      MOVEA.L    -8576(A5),A0
0D94: 70FE          MOVEQ      #-2,D0
0D96: D0680044      MOVEA.B    68(A0),A0
0D9A: 3F00          MOVE.W     D0,-(A7)
0D9C: 3F05          MOVE.W     D5,-(A7)
0D9E: A891          MOVE.L     (A1),(A4)
0DA0: A89E          MOVE.L     (A6)+,(A4)
0DA2: 486DFAB2      PEA        -1358(A5)                      ; A5-1358
0DA6: A89D          MOVE.L     (A5)+,(A4)
0DA8: 3F3C0009      MOVE.W     #$0009,-(A7)
0DAC: A89C          MOVE.L     (A4)+,(A4)
0DAE: 3F2EFE74      MOVE.W     -396(A6),-(A7)
0DB2: 3F05          MOVE.W     D5,-(A7)
0DB4: A893          MOVE.L     (A3),(A4)
0DB6: 3F2EFE74      MOVE.W     -396(A6),-(A7)
0DBA: 206DDE80      MOVEA.L    -8576(A5),A0
0DBE: 70FE          MOVEQ      #-2,D0
0DC0: D0680042      MOVEA.B    66(A0),A0
0DC4: 3F00          MOVE.W     D0,-(A7)
0DC6: A891          MOVE.L     (A1),(A4)
0DC8: 3F06          MOVE.W     D6,-(A7)
0DCA: 206DDE80      MOVEA.L    -8576(A5),A0
0DCE: 3F28003E      MOVE.W     62(A0),-(A7)
0DD2: A893          MOVE.L     (A3),(A4)
0DD4: 3F06          MOVE.W     D6,-(A7)
0DD6: 206DDE80      MOVEA.L    -8576(A5),A0
0DDA: 70FE          MOVEQ      #-2,D0
0DDC: D0680042      MOVEA.B    66(A0),A0
0DE0: 3F00          MOVE.W     D0,-(A7)
0DE2: A891          MOVE.L     (A1),(A4)
0DE4: A89E          MOVE.L     (A6)+,(A4)
0DE6: 3F3C0004      MOVE.W     #$0004,-(A7)
0DEA: A887          MOVE.L     D7,(A4)
0DEC: 3F3C0009      MOVE.W     #$0009,-(A7)
0DF0: A88A          MOVE.L     A2,(A4)
0DF2: 4267          CLR.W      -(A7)
0DF4: A888          MOVE.L     A0,(A4)
0DF6: 4267          CLR.W      -(A7)
0DF8: A889          MOVE.L     A1,(A4)
0DFA: 0645000C      ADDI.W     #$000C,D5
0DFE: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
0E02: B1EDC37657C0  MOVE.W     -15498(A5),$57C0.W             ; A5-15498
0E08: 4400          NEG.B      D0
0E0A: 4880          EXT.W      D0
0E0C: 3D40FE70      MOVE.W     D0,-400(A6)
0E10: 4267          CLR.W      -(A7)
0E12: 2F2DDEC6      MOVE.L     -8506(A5),-(A7)                ; A5-8506
0E16: A9603E1F      MOVE.L     -(A0),15903(A4)
0E1A: BE6E0008      MOVEA.W    8(A6),A7
0E1E: 6F04          BLE.S      $0E24
0E20: 3D470008      MOVE.W     D7,8(A6)
0E24: 0C6E7FFF000A  CMPI.W     #$7FFF,10(A6)
0E2A: 660A          BNE.S      $0E36
0E2C: 7016          MOVEQ      #22,D0
0E2E: D06E0008      MOVEA.B    8(A6),A0
0E32: 3D40000A      MOVE.W     D0,10(A6)
0E36: 3D7C0001FE6E  MOVE.W     #$0001,-402(A6)
0E3C: 7600          MOVEQ      #0,D3
0E3E: 42A7          CLR.L      -(A7)
0E40: 206DDEC2      MOVEA.L    -8510(A5),A0
0E44: 2F2800CA      MOVE.L     202(A0),-(A7)
0E48: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0E4C: 2D5FFE62      MOVE.L     (A7)+,-414(A6)
0E50: 48780006      PEA        $0006.W
0E54: 2F2EFE62      MOVE.L     -414(A6),-(A7)
0E58: 4EAD004A      JSR        74(A5)                         ; JT[74]
0E5C: 3043          MOVEA.W    D3,A0
0E5E: B088          MOVE.W     A0,(A0)
0E60: 63000324      BLS.W      $1188
0E64: 3803          MOVE.W     D3,D4
0E66: 9847          MOVEA.B    D7,A4
0E68: 48C4          EXT.L      D4
0E6A: 89FC0002206D  ORA.L      #$0002206D,A4
0E70: DEC2          MOVE.B     D2,(A7)+
0E72: 206800CA      MOVEA.L    202(A0),A0
0E76: 7006          MOVEQ      #6,D0
0E78: C1C3          ANDA.L     D3,A0
0E7A: D090          MOVE.B     (A0),(A0)
0E7C: 2040          MOVEA.L    D0,A0
0E7E: 1010          MOVE.B     (A0),D0
0E80: 6764          BEQ.S      $0EE6
0E82: 6B0002C8      BMI.W      $114E
0E86: 5700          MOVE.B     D0,-(A3)
0E88: 670000C0      BEQ.W      $0F4C
0E8C: 6A08          BPL.S      $0E96
0E8E: 5200          MOVE.B     D0,D1
0E90: 6A000172      BPL.W      $1006
0E94: 6026          BRA.S      $0EBC
0E96: 5500          MOVE.B     D0,-(A2)
0E98: 6A0002B2      BPL.W      $114E
0E9C: B66E0008      MOVEA.W    8(A6),A3
0EA0: 6D0002AA      BLT.W      $114E
0EA4: B66E000A      MOVEA.W    10(A6),A3
0EA8: 6C0002A2      BGE.W      $114E
0EAC: 3003          MOVE.W     D3,D0
0EAE: 9047          MOVEA.B    D7,A0
0EB0: 3F00          MOVE.W     D0,-(A7)
0EB2: 4EBA0744      JSR        1860(PC)
0EB6: 548F          MOVE.B     A7,(A2)
0EB8: 60000292      BRA.W      $114E
0EBC: 206DDEC2      MOVEA.L    -8510(A5),A0
0EC0: 206800CA      MOVEA.L    202(A0),A0
0EC4: 7006          MOVEQ      #6,D0
0EC6: C1C3          ANDA.L     D3,A0
0EC8: 2050          MOVEA.L    (A0),A0
0ECA: 2F300802      MOVE.L     2(A0,D0.L),-(A7)
0ECE: 4EAD05EA      JSR        1514(A5)                       ; JT[1514]
0ED2: 2D40FFFC      MOVE.L     D0,-4(A6)
0ED6: 2040          MOVEA.L    D0,A0
0ED8: 3D680004FE6E  MOVE.W     4(A0),-402(A6)
0EDE: 45EDF09A      LEA        -3942(A5),A2                   ; A5-3942
0EE2: 588F          MOVE.B     A7,(A4)
0EE4: 600E          BRA.S      $0EF4
0EE6: B66DDE54      MOVEA.W    -8620(A5),A3
0EEA: 6E04          BGT.S      $0EF0
0EEC: 426EFE6E      CLR.W      -402(A6)
0EF0: 45EDF0A4      LEA        -3932(A5),A2                   ; A5-3932
0EF4: 3D7C0001FE72  MOVE.W     #$0001,-398(A6)
0EFA: 2003          MOVE.L     D3,D0
0EFC: 48C0          EXT.L      D0
0EFE: 81FC00024840  ORA.L      #$00024840,A0
0F04: 4A40          TST.W      D0
0F06: 6704          BEQ.S      $0F0C
0F08: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0F0C: B66E0008      MOVEA.W    8(A6),A3
0F10: 6D00023A      BLT.W      $114E
0F14: B66E000A      MOVEA.W    10(A6),A3
0F18: 6C000232      BGE.W      $114E
0F1C: 4267          CLR.W      -(A7)
0F1E: 3F04          MOVE.W     D4,-(A7)
0F20: 4EBA08A0      JSR        2208(PC)
0F24: 7002          MOVEQ      #2,D0
0F26: D06EFE74      MOVEA.B    -396(A6),A0
0F2A: 3E80          MOVE.W     D0,(A7)
0F2C: 700C          MOVEQ      #12,D0
0F2E: C1C4          ANDA.L     D4,A0
0F30: D045          MOVEA.B    D5,A0
0F32: 3F00          MOVE.W     D0,-(A7)
0F34: A893          MOVE.L     (A3),(A4)
0F36: 2F0A          MOVE.L     A2,-(A7)
0F38: A884          MOVE.L     D4,(A4)
0F3A: 3003          MOVE.W     D3,D0
0F3C: 9047          MOVEA.B    D7,A0
0F3E: 3E80          MOVE.W     D0,(A7)
0F40: 4EBA0766      JSR        1894(PC)
0F44: 548F          MOVE.B     A7,(A2)
0F46: 60000204      BRA.W      $114E
0F4A: B66E0008      MOVEA.W    8(A6),A3
0F4E: 6D0001FC      BLT.W      $114E
0F52: B66E000A      MOVEA.W    10(A6),A3
0F56: 6C0001F4      BGE.W      $114E
0F5A: 206DDEC2      MOVEA.L    -8510(A5),A0
0F5E: 206800CA      MOVEA.L    202(A0),A0
0F62: 7006          MOVEQ      #6,D0
0F64: C1C3          ANDA.L     D3,A0
0F66: 2050          MOVEA.L    (A0),A0
0F68: 2F300802      MOVE.L     2(A0,D0.L),-(A7)
0F6C: 4EAD05EA      JSR        1514(A5)                       ; JT[1514]
0F70: 2D40FFFC      MOVE.L     D0,-4(A6)
0F74: 2203          MOVE.L     D3,D1
0F76: 48C1          EXT.L      D1
0F78: 83FC00024841  ORA.L      #$00024841,A1
0F7E: 4A41          TST.W      D1
0F80: 588F          MOVE.B     A7,(A4)
0F82: 660A          BNE.S      $0F8E
0F84: 4267          CLR.W      -(A7)
0F86: 3F04          MOVE.W     D4,-(A7)
0F88: 4EBA0838      JSR        2104(PC)
0F8C: 588F          MOVE.B     A7,(A4)
0F8E: 48780064      PEA        $0064.W
0F92: 206EFFFC      MOVEA.L    -4(A6),A0
0F96: 2F28000A      MOVE.L     10(A0),-(A7)
0F9A: 4EAD005A      JSR        90(A5)                         ; JT[90]
0F9E: 2F00          MOVE.L     D0,-(A7)
0FA0: 48680002      PEA        2(A0)
0FA4: 486DF0B2      PEA        -3918(A5)                      ; A5-3918
0FA8: 486EFEFD      PEA        -259(A6)
0FAC: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0FB0: 1D40FEFC      MOVE.B     D0,-260(A6)
0FB4: 2003          MOVE.L     D3,D0
0FB6: 48C0          EXT.L      D0
0FB8: 81FC00024840  ORA.L      #$00024840,A0
0FBE: 4A40          TST.W      D0
0FC0: 4FEF0010      LEA        16(A7),A7
0FC4: 6706          BEQ.S      $0FCC
0FC6: 302EFE76      MOVE.W     -394(A6),D0
0FCA: 6002          BRA.S      $0FCE
0FCC: 3006          MOVE.W     D6,D0
0FCE: 3D40FE64      MOVE.W     D0,-412(A6)
0FD2: 4267          CLR.W      -(A7)
0FD4: 486EFEFC      PEA        -260(A6)
0FD8: A88C          MOVE.L     A4,(A4)
0FDA: 302EFE64      MOVE.W     -412(A6),D0
0FDE: 905F          MOVEA.B    (A7)+,A0
0FE0: 55403F00      MOVE.B     D0,16128(A2)
0FE4: 700C          MOVEQ      #12,D0
0FE6: C1C4          ANDA.L     D4,A0
0FE8: D045          MOVEA.B    D5,A0
0FEA: 3F00          MOVE.W     D0,-(A7)
0FEC: A893          MOVE.L     (A3),(A4)
0FEE: 3003          MOVE.W     D3,D0
0FF0: 9047          MOVEA.B    D7,A0
0FF2: 3F00          MOVE.W     D0,-(A7)
0FF4: 4EBA0744      JSR        1860(PC)
0FF8: 486EFEFC      PEA        -260(A6)
0FFC: A884          MOVE.L     D4,(A4)
0FFE: 548F          MOVE.B     A7,(A2)
1000: 6000014A      BRA.W      $114E
1004: 206DDEC2      MOVEA.L    -8510(A5),A0
1008: 206800CA      MOVEA.L    202(A0),A0
100C: 7006          MOVEQ      #6,D0
100E: C1C3          ANDA.L     D3,A0
1010: 2050          MOVEA.L    (A0),A0
1012: 2F300802      MOVE.L     2(A0,D0.L),-(A7)
1016: 4EAD05EA      JSR        1514(A5)                       ; JT[1514]
101A: 2D40FFFC      MOVE.L     D0,-4(A6)
101E: 0C6E0001FE72  CMPI.W     #$0001,-398(A6)
1024: 588F          MOVE.B     A7,(A4)
1026: 661C          BNE.S      $1044
1028: 2003          MOVE.L     D3,D0
102A: 48C0          EXT.L      D0
102C: 81FC00024840  ORA.L      #$00024840,A0
1032: 4A40          TST.W      D0
1034: 6704          BEQ.S      $103A
1036: 4EAD01A2      JSR        418(A5)                        ; JT[418]
103A: 206EFFFC      MOVEA.L    -4(A6),A0
103E: 3D680022FE70  MOVE.W     34(A0),-400(A6)
1044: 526EFE72      MOVEA.B    -398(A6),A1
1048: B66E0008      MOVEA.W    8(A6),A3
104C: 6D0000FE      BLT.W      $114E
1050: B66E000A      MOVEA.W    10(A6),A3
1054: 6C0000F6      BGE.W      $114E
1058: 302EFE72      MOVE.W     -398(A6),D0
105C: 48C0          EXT.L      D0
105E: 81FC00023F00  ORA.L      #$00023F00,A0
1064: 3F04          MOVE.W     D4,-(A7)
1066: 4EBA075A      JSR        1882(PC)
106A: 206EFFFC      MOVEA.L    -4(A6),A0
106E: 4A280020      TST.B      32(A0)
1072: 588F          MOVE.B     A7,(A4)
1074: 672A          BEQ.S      $10A0
1076: 48780064      PEA        $0064.W
107A: 206EFFFC      MOVEA.L    -4(A6),A0
107E: 2F280010      MOVE.L     16(A0),-(A7)
1082: 4EAD005A      JSR        90(A5)                         ; JT[90]
1086: 2F00          MOVE.L     D0,-(A7)
1088: 2F08          MOVE.L     A0,-(A7)
108A: 486DF0BC      PEA        -3908(A5)                      ; A5-3908
108E: 486EFEFD      PEA        -259(A6)
1092: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
1096: 1D40FEFC      MOVE.B     D0,-260(A6)
109A: 4FEF0010      LEA        16(A7),A7
109E: 6064          BRA.S      $1104
10A0: 206EFFFC      MOVEA.L    -4(A6),A0
10A4: 4A680022      TST.W      34(A0)
10A8: 672A          BEQ.S      $10D4
10AA: 48780064      PEA        $0064.W
10AE: 206EFFFC      MOVEA.L    -4(A6),A0
10B2: 2F280010      MOVE.L     16(A0),-(A7)
10B6: 4EAD005A      JSR        90(A5)                         ; JT[90]
10BA: 2F00          MOVE.L     D0,-(A7)
10BC: 2F08          MOVE.L     A0,-(A7)
10BE: 486DF0C4      PEA        -3900(A5)                      ; A5-3900
10C2: 486EFEFD      PEA        -259(A6)
10C6: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
10CA: 1D40FEFC      MOVE.B     D0,-260(A6)
10CE: 4FEF0010      LEA        16(A7),A7
10D2: 6030          BRA.S      $1104
10D4: 48780064      PEA        $0064.W
10D8: 206EFFFC      MOVEA.L    -4(A6),A0
10DC: 2F280010      MOVE.L     16(A0),-(A7)
10E0: 4EAD005A      JSR        90(A5)                         ; JT[90]
10E4: 2F00          MOVE.L     D0,-(A7)
10E6: 2F08          MOVE.L     A0,-(A7)
10E8: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
10EC: 548F          MOVE.B     A7,(A2)
10EE: 3E80          MOVE.W     D0,(A7)
10F0: 486DF0CE      PEA        -3890(A5)                      ; A5-3890
10F4: 486EFEFD      PEA        -259(A6)
10F8: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
10FC: 1D40FEFC      MOVE.B     D0,-260(A6)
1100: 4FEF000E      LEA        14(A7),A7
1104: 2003          MOVE.L     D3,D0
1106: 48C0          EXT.L      D0
1108: 81FC00024840  ORA.L      #$00024840,A0
110E: 4A40          TST.W      D0
1110: 6706          BEQ.S      $1118
1112: 302EFE76      MOVE.W     -394(A6),D0
1116: 6002          BRA.S      $111A
1118: 3006          MOVE.W     D6,D0
111A: 3D40FE64      MOVE.W     D0,-412(A6)
111E: 4267          CLR.W      -(A7)
1120: 486EFEFC      PEA        -260(A6)
1124: A88C          MOVE.L     A4,(A4)
1126: 302EFE64      MOVE.W     -412(A6),D0
112A: 905F          MOVEA.B    (A7)+,A0
112C: 55403F00      MOVE.B     D0,16128(A2)
1130: 700C          MOVEQ      #12,D0
1132: C1C4          ANDA.L     D4,A0
1134: D045          MOVEA.B    D5,A0
1136: 3F00          MOVE.W     D0,-(A7)
1138: A893          MOVE.L     (A3),(A4)
113A: 3003          MOVE.W     D3,D0
113C: 9047          MOVEA.B    D7,A0
113E: 3F00          MOVE.W     D0,-(A7)
1140: 4EBA05F8      JSR        1528(PC)
1144: 486EFEFC      PEA        -260(A6)
1148: A884          MOVE.L     D4,(A4)
114A: 548F          MOVE.B     A7,(A2)
114C: 206DDEC2      MOVEA.L    -8510(A5),A0
1150: 206800CA      MOVEA.L    202(A0),A0
1154: 7006          MOVEQ      #6,D0
1156: C1C3          ANDA.L     D3,A0
1158: 2050          MOVEA.L    (A0),A0
115A: 20700802      MOVEA.L    2(A0,D0.L),A0
115E: A02A5243      MOVE.L     21059(A2),D0
1162: 6000FCDA      BRA.W      $0E40
1166: 3803          MOVE.W     D3,D4
1168: 5243          MOVEA.B    D3,A1
116A: 9847          MOVEA.B    D7,A4
116C: 4267          CLR.W      -(A7)
116E: 2004          MOVE.L     D4,D0
1170: 5240          MOVEA.B    D0,A1
1172: 48C0          EXT.L      D0
1174: 81FC00023F00  ORA.L      #$00023F00,A0
117A: 4EBA0646      JSR        1606(PC)
117E: 3E84          MOVE.W     D4,(A7)
1180: 4EBA0476      JSR        1142(PC)
1184: 588F          MOVE.B     A7,(A4)
1186: B66E000A      MOVEA.W    10(A6),A3
118A: 6DDA          BLT.S      $1166
118C: 0645FFF4      ADDI.W     #$FFF4,D5
1190: 206DDE78      MOVEA.L    -8584(A5),A0
1194: A029206D      MOVE.L     8301(A1),D0
1198: DE782050      MOVEA.B    $2050.W,A7
119C: 4868032E      PEA        814(A0)
11A0: 486EFF7C      PEA        -132(A6)
11A4: 4EAD07EA      JSR        2026(A5)                       ; JT[2026]
11A8: 206DDE78      MOVEA.L    -8584(A5),A0
11AC: A02A3EBC      MOVE.L     16060(A2),D0
11B0: 0020486E      ORI.B      #$486E,-(A0)
11B4: FF7C4EAD0DBA  MOVE.W     #$4EAD,3514(A7)
11BA: 2440          MOVEA.L    D0,A2
11BC: 200A          MOVE.L     A2,D0
11BE: 4FEF000C      LEA        12(A7),A7
11C2: 6702          BEQ.S      $11C6
11C4: 4212          CLR.B      (A2)
11C6: 422EFF86      CLR.B      -122(A6)
11CA: 48780064      PEA        $0064.W
11CE: 2F2DC372      MOVE.L     -15502(A5),-(A7)               ; g_size2=65536
11D2: 4EAD005A      JSR        90(A5)                         ; JT[90]
11D6: 2F00          MOVE.L     D0,-(A7)
11D8: 4A6EFE6E      TST.W      -402(A6)
11DC: 6708          BEQ.S      $11E6
11DE: 41EEFF7C      LEA        -132(A6),A0
11E2: 2008          MOVE.L     A0,D0
11E4: 6006          BRA.S      $11EC
11E6: 41EDF0DC      LEA        -3876(A5),A0                   ; A5-3876
11EA: 2008          MOVE.L     A0,D0
11EC: 2F00          MOVE.L     D0,-(A7)
11EE: 486DF0E4      PEA        -3868(A5)                      ; A5-3868
11F2: 486EFEFD      PEA        -259(A6)
11F6: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
11FA: 1D40FEFC      MOVE.B     D0,-260(A6)
11FE: 7064          MOVEQ      #100,D0
1200: 2E80          MOVE.L     D0,(A7)
1202: 2F2DC36E      MOVE.L     -15506(A5),-(A7)               ; g_size1=56630
1206: 4EAD005A      JSR        90(A5)                         ; JT[90]
120A: 2E80          MOVE.L     D0,(A7)
120C: 4A6EFE6E      TST.W      -402(A6)
1210: 6708          BEQ.S      $121A
1212: 41EDF0EC      LEA        -3860(A5),A0                   ; A5-3860
1216: 2008          MOVE.L     A0,D0
1218: 6006          BRA.S      $1220
121A: 41EDF0F2      LEA        -3854(A5),A0                   ; A5-3854
121E: 2008          MOVE.L     A0,D0
1220: 2F00          MOVE.L     D0,-(A7)
1222: 486DF0FA      PEA        -3846(A5)                      ; A5-3846
1226: 486EFE7D      PEA        -387(A6)
122A: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
122E: 1D40FE7C      MOVE.B     D0,-388(A6)
1232: 4A6EFE70      TST.W      -400(A6)
1236: 4FEF0018      LEA        24(A7),A7
123A: 670A          BEQ.S      $1246
123C: 49EEFEFC      LEA        -260(A6),A4
1240: 47EEFE7C      LEA        -388(A6),A3
1244: 6008          BRA.S      $124E
1246: 49EEFE7C      LEA        -388(A6),A4
124A: 47EEFEFC      LEA        -260(A6),A3
124E: 3F3C0001      MOVE.W     #$0001,-(A7)
1252: A888          MOVE.L     A0,(A4)
1254: 206DDE80      MOVEA.L    -8576(A5),A0
1258: 7002          MOVEQ      #2,D0
125A: D068003E      MOVEA.B    62(A0),A0
125E: 3D40FE66      MOVE.W     D0,-410(A6)
1262: 700B          MOVEQ      #11,D0
1264: D06EFE66      MOVEA.B    -410(A6),A0
1268: 3D40FE6A      MOVE.W     D0,-406(A6)
126C: 4267          CLR.W      -(A7)
126E: 2F0C          MOVE.L     A4,-(A7)
1270: A88C          MOVE.L     A4,(A4)
1272: 3006          MOVE.W     D6,D0
1274: 905F          MOVEA.B    (A7)+,A0
1276: 55403D40      MOVE.B     D0,15680(A2)
127A: FE6C3F00      MOVEA.W    16128(A4),A7
127E: 70FE          MOVEQ      #-2,D0
1280: D045          MOVEA.B    D5,A0
1282: 3F00          MOVE.W     D0,-(A7)
1284: A893          MOVE.L     (A3),(A4)
1286: 206DDE80      MOVEA.L    -8576(A5),A0
128A: 7002          MOVEQ      #2,D0
128C: D0680040      MOVEA.B    64(A0),A0
1290: 3D40FE68      MOVE.W     D0,-408(A6)
1294: 486EFE66      PEA        -410(A6)
1298: A8A3          MOVE.L     -(A3),(A4)
129A: 2F0C          MOVE.L     A4,-(A7)
129C: A884          MOVE.L     D4,(A4)
129E: 4267          CLR.W      -(A7)
12A0: 2F0B          MOVE.L     A3,-(A7)
12A2: A88C          MOVE.L     A4,(A4)
12A4: 302EFE76      MOVE.W     -394(A6),D0
12A8: 905F          MOVEA.B    (A7)+,A0
12AA: 55403D40      MOVE.B     D0,15680(A2)
12AE: FE6C3F00      MOVEA.W    16128(A4),A7
12B2: 70FE          MOVEQ      #-2,D0
12B4: D045          MOVEA.B    D5,A0
12B6: 3F00          MOVE.W     D0,-(A7)
12B8: A893          MOVE.L     (A3),(A4)
12BA: 7002          MOVEQ      #2,D0
12BC: D046          MOVEA.B    D6,A0
12BE: B06EFE6C      MOVEA.W    -404(A6),A0
12C2: 6F12          BLE.S      $12D6
12C4: 7002          MOVEQ      #2,D0
12C6: D046          MOVEA.B    D6,A0
12C8: 906EFE6C      MOVEA.B    -404(A6),A0
12CC: 3F00          MOVE.W     D0,-(A7)
12CE: 4267          CLR.W      -(A7)
12D0: A894          MOVE.L     (A4),(A4)
12D2: 3D46FE6C      MOVE.W     D6,-404(A6)
12D6: 206DDE80      MOVEA.L    -8576(A5),A0
12DA: 30280040      MOVE.W     64(A0),D0
12DE: D0680044      MOVEA.B    68(A0),A0
12E2: 554048C0      MOVE.B     D0,18624(A2)
12E6: 81FC00025240  ORA.L      #$00025240,A0
12EC: 3D40FE68      MOVE.W     D0,-408(A6)
12F0: 486EFE66      PEA        -410(A6)
12F4: A8A3          MOVE.L     -(A3),(A4)
12F6: 2F0B          MOVE.L     A3,-(A7)
12F8: A884          MOVE.L     D4,(A4)
12FA: 4267          CLR.W      -(A7)
12FC: A888          MOVE.L     A0,(A4)
12FE: 3F3C0001      MOVE.W     #$0001,-(A7)
1302: A889          MOVE.L     A1,(A4)
1304: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
1308: 4E5E          UNLK       A6
130A: 4E75          RTS        


; ======= Function at 0x130C =======
130C: 4E56FFF8      LINK       A6,#-8                         ; frame=8
1310: 206DDE80      MOVEA.L    -8576(A5),A0
1314: 2D68003EFFF8  MOVE.L     62(A0),-8(A6)
131A: 2D680042FFFC  MOVE.L     66(A0),-4(A6)
1320: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
1324: A873700D      MOVEA.L    13(A3,D7.W),A4
1328: D06EFFF8      MOVEA.B    -8(A6),A0
132C: 3D40FFFC      MOVE.W     D0,-4(A6)
1330: 486EFFF8      PEA        -8(A6)
1334: A9284E5E      MOVE.L     20062(A0),-(A4)
1338: 4E75          RTS        


; ======= Function at 0x133A =======
133A: 4E56FFD8      LINK       A6,#-40                        ; frame=40
133E: 2F07          MOVE.L     D7,-(A7)
1340: 206DDE78      MOVEA.L    -8584(A5),A0
1344: 2050          MOVEA.L    (A0),A0
1346: 4A68030E      TST.W      782(A0)
134A: 670000A4      BEQ.W      $13F2
134E: 3F3C0012      MOVE.W     #$0012,-(A7)
1352: A88A          MOVE.L     A2,(A4)
1354: 3F3C0003      MOVE.W     #$0003,-(A7)
1358: A887          MOVE.L     D7,(A4)
135A: 4267          CLR.W      -(A7)
135C: A889          MOVE.L     A1,(A4)
135E: 206DDE80      MOVEA.L    -8576(A5),A0
1362: 2D68004EFFD8  MOVE.L     78(A0),-40(A6)
1368: 2D680052FFDC  MOVE.L     82(A0),-36(A6)
136E: 486EFFD8      PEA        -40(A6)
1372: A8A1          MOVE.L     -(A1),(A4)
1374: 4878003C      PEA        $003C.W
1378: 2F2DDE56      MOVE.L     -8618(A5),-(A7)                ; A5-8618
137C: 4EAD005A      JSR        90(A5)                         ; JT[90]
1380: 2E00          MOVE.L     D0,D7
1382: 4878003C      PEA        $003C.W
1386: 2F07          MOVE.L     D7,-(A7)
1388: 4EAD0062      JSR        98(A5)                         ; JT[98]
138C: 2F00          MOVE.L     D0,-(A7)
138E: 48780064      PEA        $0064.W
1392: 4878003C      PEA        $003C.W
1396: 2F07          MOVE.L     D7,-(A7)
1398: 4EAD005A      JSR        90(A5)                         ; JT[90]
139C: 2F00          MOVE.L     D0,-(A7)
139E: 4EAD0062      JSR        98(A5)                         ; JT[98]
13A2: 2F00          MOVE.L     D0,-(A7)
13A4: 486DF102      PEA        -3838(A5)                      ; A5-3838
13A8: 486EFFE1      PEA        -31(A6)
13AC: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
13B0: 1D40FFE0      MOVE.B     D0,-32(A6)
13B4: 4257          CLR.W      (A7)
13B6: 486EFFE0      PEA        -32(A6)
13BA: A88C          MOVE.L     A4,(A4)
13BC: 3E2EFFDE      MOVE.W     -34(A6),D7
13C0: 9E5F          MOVEA.B    (A7)+,A7
13C2: 5347486E      MOVE.B     D7,18542(A1)
13C6: FFD8          MOVE.W     (A0)+,???
13C8: 2F3C00010001  MOVE.L     #$00010001,-(A7)
13CE: A8A93D47      MOVE.L     15687(A1),(A4)
13D2: FFDE          MOVE.W     (A6)+,???
13D4: 486EFFD8      PEA        -40(A6)
13D8: A8A3          MOVE.L     -(A3),(A4)
13DA: 3E87          MOVE.W     D7,(A7)
13DC: 206DDE80      MOVEA.L    -8576(A5),A0
13E0: 70FB          MOVEQ      #-5,D0
13E2: D0680052      MOVEA.B    82(A0),A0
13E6: 3F00          MOVE.W     D0,-(A7)
13E8: A893          MOVE.L     (A3),(A4)
13EA: 486EFFE0      PEA        -32(A6)
13EE: A884          MOVE.L     D4,(A4)
13F0: 2E2EFFD4      MOVE.L     -44(A6),D7
13F4: 4E5E          UNLK       A6
13F6: 4E75          RTS        


; ======= Function at 0x13F8 =======
13F8: 4E56FFF8      LINK       A6,#-8                         ; frame=8
13FC: 206DDE80      MOVEA.L    -8576(A5),A0
1400: 2D68004EFFF8  MOVE.L     78(A0),-8(A6)
1406: 2D680052FFFC  MOVE.L     82(A0),-4(A6)
140C: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
1410: A873486E      MOVEA.L    110(A3,D4.L),A4
1414: FFF83F2E      MOVE.W     $3F2E.W,???
1418: 00083F2E      ORI.B      #$3F2E,A0
141C: 0008A8A9      ORI.B      #$A8A9,A0
1420: 486EFFF8      PEA        -8(A6)
1424: A9284E5E      MOVE.L     20062(A0),-(A4)
1428: 4E75          RTS        


; ======= Function at 0x142A =======
142A: 4E560000      LINK       A6,#0
142E: 2F07          MOVE.L     D7,-(A7)
1430: 302E0008      MOVE.W     8(A6),D0
1434: 6B3C          BMI.S      $1472
1436: 04400016      SUBI.W     #$0016,D0
143A: 6718          BEQ.S      $1454
143C: 6A08          BPL.S      $1446
143E: 5440          MOVEA.B    D0,A2
1440: 670A          BEQ.S      $144C
1442: 6A0C          BPL.S      $1450
1444: 602C          BRA.S      $1472
1446: 55406A28      MOVE.B     D0,27176(A2)
144A: 600C          BRA.S      $1458
144C: 7EFE          MOVEQ      #-2,D7
144E: 600A          BRA.S      $145A
1450: 7E02          MOVEQ      #2,D7
1452: 6006          BRA.S      $145A
1454: 7EEE          MOVEQ      #-18,D7
1456: 6002          BRA.S      $145A
1458: 7E12          MOVEQ      #18,D7
145A: 2F2E000A      MOVE.L     10(A6),-(A7)
145E: 4267          CLR.W      -(A7)
1460: 2F2E000A      MOVE.L     10(A6),-(A7)
1464: A960301F      MOVE.L     -(A0),12319(A4)
1468: D047          MOVEA.B    D7,A0
146A: 3F00          MOVE.W     D0,-(A7)
146C: A9634EBA      MOVE.L     -(A3),20154(A4)
1470: 00A22E1F4E5E  ORI.L      #$2E1F4E5E,-(A2)
1476: 205F          MOVEA.L    (A7)+,A0
1478: 5C8F          MOVE.B     A7,(A6)
147A: 4ED0          JMP        (A0)

; ======= Function at 0x147C =======
147C: 4E560000      LINK       A6,#0
1480: 0C6E0081000C  CMPI.W     #$0081,12(A6)
1486: 6604          BNE.S      $148C
1488: 7000          MOVEQ      #0,D0
148A: 6006          BRA.S      $1492
148C: 41ED044A      LEA        1098(A5),A0                    ; A5+1098
1490: 2008          MOVE.L     A0,D0
1492: 4E5E          UNLK       A6
1494: 4E75          RTS        


; ======= Function at 0x1496 =======
1496: 4E560000      LINK       A6,#0
149A: 4EBA0076      JSR        118(PC)
149E: 4E5E          UNLK       A6
14A0: 4E75          RTS        


; ======= Function at 0x14A2 =======
14A2: 4E56FFFA      LINK       A6,#-6                         ; frame=6
14A6: 2F07          MOVE.L     D7,-(A7)
14A8: 42A7          CLR.L      -(A7)
14AA: 206DDEC2      MOVEA.L    -8510(A5),A0
14AE: 2F2800CA      MOVE.L     202(A0),-(A7)
14B2: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
14B6: 2D5FFFFA      MOVE.L     (A7)+,-6(A6)
14BA: 48780006      PEA        $0006.W
14BE: 2F2EFFFA      MOVE.L     -6(A6),-(A7)
14C2: 4EAD004A      JSR        74(A5)                         ; JT[74]
14C6: 3E00          MOVE.W     D0,D7
14C8: 0647FFEA      ADDI.W     #$FFEA,D7
14CC: 2007          MOVE.L     D7,D0
14CE: 48C0          EXT.L      D0
14D0: 81FC00024840  ORA.L      #$00024840,A0
14D6: DE40          MOVEA.B    D0,A7
14D8: 4267          CLR.W      -(A7)
14DA: 2F2DDEC6      MOVE.L     -8506(A5),-(A7)                ; A5-8506
14DE: A960BE5F      MOVE.L     -(A0),-16801(A4)
14E2: 6728          BEQ.S      $150C
14E4: 4A47          TST.W      D7
14E6: 6D24          BLT.S      $150C
14E8: 2F2DDEC6      MOVE.L     -8506(A5),-(A7)                ; A5-8506
14EC: 3F07          MOVE.W     D7,-(A7)
14EE: A9652F2D      MOVE.L     -(A5),12077(A4)
14F2: DEC6          MOVE.B     D6,(A7)+
14F4: 3F07          MOVE.W     D7,-(A7)
14F6: A9633B47      MOVE.L     -(A3),15175(A4)
14FA: EF00          MOVE.L     D0,-(A7)
14FC: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
1500: A873206D      MOVEA.L    109(A3,D2.W),A4
1504: DE80          MOVE.B     D0,(A7)
1506: 4868003E      PEA        62(A0)
150A: A9282E1F      MOVE.L     11807(A0),-(A4)
150E: 4E5E          UNLK       A6
1510: 4E75          RTS        

1512: 48E70300      MOVEM.L    D6/D7,-(SP)                    ; save
1516: 4267          CLR.W      -(A7)
1518: 2F2DDEC6      MOVE.L     -8506(A5),-(A7)                ; A5-8506
151C: A9603E1F      MOVE.L     -(A0),15903(A4)
1520: 2C07          MOVE.L     D7,D6
1522: 48C6          EXT.L      D6
1524: 8DFC00024846  ORA.L      #$00024846,A6
152A: 4A46          TST.W      D6
152C: 670A          BEQ.S      $1538
152E: 9E46          MOVEA.B    D6,A7
1530: 2F2DDEC6      MOVE.L     -8506(A5),-(A7)                ; A5-8506
1534: 3F07          MOVE.W     D7,-(A7)
1536: A963BE6D      MOVE.L     -(A3),-16787(A4)
153A: EF00          MOVE.L     D0,-(A7)
153C: 6712          BEQ.S      $1550
153E: 302DEF00      MOVE.W     -4352(A5),D0                   ; A5-4352
1542: 9047          MOVEA.B    D7,A0
1544: 3F00          MOVE.W     D0,-(A7)
1546: 4EBA000E      JSR        14(PC)
154A: 3B47EF00      MOVE.W     D7,-4352(A5)
154E: 548F          MOVE.B     A7,(A2)
1550: 4CDF00C0      MOVEM.L    (SP)+,D6/D7                    ; restore
1554: 4E75          RTS        


; ======= Function at 0x1556 =======
1556: 4E56FFF4      LINK       A6,#-12                        ; frame=12
155A: 48E70708      MOVEM.L    D5/D6/D7/A4,-(SP)              ; save
155E: 3E2E0008      MOVE.W     8(A6),D7
1562: 206DDE80      MOVEA.L    -8576(A5),A0
1566: 2D68003EFFF4  MOVE.L     62(A0),-12(A6)
156C: 2D680042FFF8  MOVE.L     66(A0),-8(A6)
1572: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
1576: A873486E      MOVEA.L    110(A3,D4.L),A4
157A: FFF42F3C      MOVE.W     60(A4,D2.L*8),???
157E: 00020002      ORI.B      #$0002,D2
1582: A8A9066E      MOVE.L     1646(A1),(A4)
1586: 000DFFF4      ORI.B      #$FFF4,A5
158A: 046E0010FFFA  SUBI.W     #$0010,-6(A6)
1590: 0C470016      CMPI.W     #$0016,D7
1594: 6F02          BLE.S      $1598
1596: 7E16          MOVEQ      #22,D7
1598: 42A7          CLR.L      -(A7)
159A: A8D8          MOVE.L     (A0)+,(A4)+
159C: 285F          MOVEA.L    (A7)+,A4
159E: 486EFFF4      PEA        -12(A6)
15A2: 4267          CLR.W      -(A7)
15A4: 2007          MOVE.L     D7,D0
15A6: 48C0          EXT.L      D0
15A8: 81FC00024840  ORA.L      #$00024840,A0
15AE: D047          MOVEA.B    D7,A0
15B0: 48C0          EXT.L      D0
15B2: 81FC0002C1FC  ORA.L      #$0002C1FC,A0
15B8: 000C3F00      ORI.B      #$3F00,A4
15BC: 2F0C          MOVE.L     A4,-(A7)
15BE: A8EF2F0C      MOVE.L     12044(A7),(A4)+
15C2: A8D9          MOVE.L     (A1)+,(A4)+
15C4: 4267          CLR.W      -(A7)
15C6: 2F2DDEC6      MOVE.L     -8506(A5),-(A7)                ; A5-8506
15CA: A9603C1F      MOVE.L     -(A0),15391(A4)
15CE: 3A07          MOVE.W     D7,D5
15D0: DA46          MOVEA.B    D6,A5
15D2: 4A47          TST.W      D7
15D4: 6F08          BLE.S      $15DE
15D6: 3E05          MOVE.W     D5,D7
15D8: 3A06          MOVE.W     D6,D5
15DA: 3C07          MOVE.W     D7,D6
15DC: 6008          BRA.S      $15E6
15DE: 06450016      ADDI.W     #$0016,D5
15E2: 06460016      ADDI.W     #$0016,D6
15E6: 3F06          MOVE.W     D6,-(A7)
15E8: 3F05          MOVE.W     D5,-(A7)
15EA: 4EBAF734      JSR        -2252(PC)
15EE: 4CEE10E0FFE4  MOVEM.L    -28(A6),D5/D6/D7/A4
15F4: 4E5E          UNLK       A6
15F6: 4E75          RTS        


; ======= Function at 0x15F8 =======
15F8: 4E56FFF8      LINK       A6,#-8                         ; frame=8
15FC: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
1600: 3E2E0008      MOVE.W     8(A6),D7
1604: 4A47          TST.W      D7
1606: 6D000098      BLT.W      $16A2
160A: 2007          MOVE.L     D7,D0
160C: 48C0          EXT.L      D0
160E: 81FC00024840  ORA.L      #$00024840,A0
1614: 4A40          TST.W      D0
1616: 6732          BEQ.S      $164A
1618: 7044          MOVEQ      #68,D0
161A: D0ADDE80      MOVE.B     -8576(A5),(A0)                 ; A5-8576
161E: 2840          MOVEA.L    D0,A4
1620: 703E          MOVEQ      #62,D0
1622: D0ADDE80      MOVE.B     -8576(A5),(A0)                 ; A5-8576
1626: 2640          MOVEA.L    D0,A3
1628: 70EF          MOVEQ      #-17,D0
162A: D054          MOVEA.B    (A4),A0
162C: 3D40FFFE      MOVE.W     D0,-2(A6)
1630: 206DDE80      MOVEA.L    -8576(A5),A0
1634: 30280040      MOVE.W     64(A0),D0
1638: D054          MOVEA.B    (A4),A0
163A: 554048C0      MOVE.B     D0,18624(A2)
163E: 81FC00025240  ORA.L      #$00025240,A0
1644: 3D40FFFA      MOVE.W     D0,-6(A6)
1648: 6030          BRA.S      $167A
164A: 7040          MOVEQ      #64,D0
164C: D0ADDE80      MOVE.B     -8576(A5),(A0)                 ; A5-8576
1650: 2440          MOVEA.L    D0,A2
1652: 703E          MOVEQ      #62,D0
1654: D0ADDE80      MOVE.B     -8576(A5),(A0)                 ; A5-8576
1658: 2640          MOVEA.L    D0,A3
165A: 700F          MOVEQ      #15,D0
165C: D052          MOVEA.B    (A2),A0
165E: 3D40FFFA      MOVE.W     D0,-6(A6)
1662: 206DDE80      MOVEA.L    -8576(A5),A0
1666: 30280044      MOVE.W     68(A0),D0
166A: D052          MOVEA.B    (A2),A0
166C: 554048C0      MOVE.B     D0,18624(A2)
1670: 81FC00025340  ORA.L      #$00025340,A0
1676: 3D40FFFE      MOVE.W     D0,-2(A6)
167A: 2007          MOVE.L     D7,D0
167C: 48C0          EXT.L      D0
167E: 81FC0002C1FC  ORA.L      #$0002C1FC,A0
1684: 000CD053      ORI.B      #$D053,A4
1688: 0640000F      ADDI.W     #$000F,D0
168C: 3D40FFF8      MOVE.W     D0,-8(A6)
1690: 700C          MOVEQ      #12,D0
1692: D06EFFF8      MOVEA.B    -8(A6),A0
1696: 3D40FFFC      MOVE.W     D0,-4(A6)
169A: 486EFFF8      PEA        -8(A6)
169E: A8A3          MOVE.L     -(A3),(A4)
16A0: 4CDF1C80      MOVEM.L    (SP)+,D7/A2/A3/A4              ; restore
16A4: 4E5E          UNLK       A6
16A6: 4E75          RTS        


; ======= Function at 0x16A8 =======
16A8: 4E56FFF4      LINK       A6,#-12                        ; frame=12
16AC: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
16B0: 3E2E0008      MOVE.W     8(A6),D7
16B4: 4A47          TST.W      D7
16B6: 6D7A          BLT.S      $1732
16B8: 2C07          MOVE.L     D7,D6
16BA: 48C6          EXT.L      D6
16BC: 8DFC00024846  ORA.L      #$00024846,A6
16C2: 4A46          TST.W      D6
16C4: 6704          BEQ.S      $16CA
16C6: 4EAD01A2      JSR        418(A5)                        ; JT[418]
16CA: 486EFFF4      PEA        -12(A6)
16CE: A89A          MOVE.L     (A2)+,(A4)
16D0: 3D6EFFF6FFFA  MOVE.W     -10(A6),-6(A6)
16D6: 4A46          TST.W      D6
16D8: 6714          BEQ.S      $16EE
16DA: 703E          MOVEQ      #62,D0
16DC: D0ADDE80      MOVE.B     -8576(A5),(A0)                 ; A5-8576
16E0: 2840          MOVEA.L    D0,A4
16E2: 70EF          MOVEQ      #-17,D0
16E4: D06C0006      MOVEA.B    6(A4),A0
16E8: 3D40FFFE      MOVE.W     D0,-2(A6)
16EC: 601E          BRA.S      $170C
16EE: 703E          MOVEQ      #62,D0
16F0: D0ADDE80      MOVE.B     -8576(A5),(A0)                 ; A5-8576
16F4: 2840          MOVEA.L    D0,A4
16F6: 302C0002      MOVE.W     2(A4),D0
16FA: D06C0006      MOVEA.B    6(A4),A0
16FE: 554048C0      MOVE.B     D0,18624(A2)
1702: 81FC00025340  ORA.L      #$00025340,A0
1708: 3D40FFFE      MOVE.W     D0,-2(A6)
170C: 2007          MOVE.L     D7,D0
170E: 48C0          EXT.L      D0
1710: 81FC0002C1FC  ORA.L      #$0002C1FC,A0
1716: 000CD054      ORI.B      #$D054,A4
171A: 0640000F      ADDI.W     #$000F,D0
171E: 3D40FFF8      MOVE.W     D0,-8(A6)
1722: 700C          MOVEQ      #12,D0
1724: D06EFFF8      MOVEA.B    -8(A6),A0
1728: 3D40FFFC      MOVE.W     D0,-4(A6)
172C: 486EFFF8      PEA        -8(A6)
1730: A8A3          MOVE.L     -(A3),(A4)
1732: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
1736: 4E5E          UNLK       A6
1738: 4E75          RTS        


; ======= Function at 0x173A =======
173A: 4E56FFF2      LINK       A6,#-14                        ; frame=14
173E: 2F0C          MOVE.L     A4,-(A7)
1740: 4A6E0008      TST.W      8(A6)
1744: 6D76          BLT.S      $17BC
1746: 486EFFF4      PEA        -12(A6)
174A: A89A          MOVE.L     (A2)+,(A4)
174C: 3D6EFFF6FFFE  MOVE.W     -10(A6),-2(A6)
1752: 302E0008      MOVE.W     8(A6),D0
1756: 48C0          EXT.L      D0
1758: 81FC00024840  ORA.L      #$00024840,A0
175E: 4A40          TST.W      D0
1760: 6720          BEQ.S      $1782
1762: 703E          MOVEQ      #62,D0
1764: D0ADDE80      MOVE.B     -8576(A5),(A0)                 ; A5-8576
1768: 2840          MOVEA.L    D0,A4
176A: 302C0002      MOVE.W     2(A4),D0
176E: D06C0006      MOVEA.B    6(A4),A0
1772: 554048C0      MOVE.B     D0,18624(A2)
1776: 81FC00025240  ORA.L      #$00025240,A0
177C: 3D40FFFA      MOVE.W     D0,-6(A6)
1780: 6012          BRA.S      $1794
1782: 703E          MOVEQ      #62,D0
1784: D0ADDE80      MOVE.B     -8576(A5),(A0)                 ; A5-8576
1788: 2840          MOVEA.L    D0,A4
178A: 700F          MOVEQ      #15,D0
178C: D06C0002      MOVEA.B    2(A4),A0
1790: 3D40FFFA      MOVE.W     D0,-6(A6)
1794: 302E0008      MOVE.W     8(A6),D0
1798: 48C0          EXT.L      D0
179A: 81FC0002C1FC  ORA.L      #$0002C1FC,A0
17A0: 000CD054      ORI.B      #$D054,A4
17A4: 0640000F      ADDI.W     #$000F,D0
17A8: 3D40FFF8      MOVE.W     D0,-8(A6)
17AC: 700C          MOVEQ      #12,D0
17AE: D06EFFF8      MOVEA.B    -8(A6),A0
17B2: 3D40FFFC      MOVE.W     D0,-4(A6)
17B6: 486EFFF8      PEA        -8(A6)
17BA: A8A3          MOVE.L     -(A3),(A4)
17BC: 285F          MOVEA.L    (A7)+,A4
17BE: 4E5E          UNLK       A6
17C0: 4E75          RTS        


; ======= Function at 0x17C2 =======
17C2: 4E56FFF0      LINK       A6,#-16                        ; frame=16
17C6: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
17CA: 3E2E0008      MOVE.W     8(A6),D7
17CE: 0C47000B      CMPI.W     #$000B,D7
17D2: 6C000088      BGE.W      $185E
17D6: 4A47          TST.W      D7
17D8: 6D000082      BLT.W      $185E
17DC: 7040          MOVEQ      #64,D0
17DE: D0ADDE80      MOVE.B     -8576(A5),(A0)                 ; A5-8576
17E2: 2840          MOVEA.L    D0,A4
17E4: 703E          MOVEQ      #62,D0
17E6: D0ADDE80      MOVE.B     -8576(A5),(A0)                 ; A5-8576
17EA: 2640          MOVEA.L    D0,A3
17EC: 7002          MOVEQ      #2,D0
17EE: D054          MOVEA.B    (A4),A0
17F0: 3D40FFF2      MOVE.W     D0,-14(A6)
17F4: 700E          MOVEQ      #14,D0
17F6: D054          MOVEA.B    (A4),A0
17F8: 3D40FFF6      MOVE.W     D0,-10(A6)
17FC: 700C          MOVEQ      #12,D0
17FE: C1C7          ANDA.L     D7,A0
1800: D053          MOVEA.B    (A3),A0
1802: 0640000F      ADDI.W     #$000F,D0
1806: 3D40FFF0      MOVE.W     D0,-16(A6)
180A: 700C          MOVEQ      #12,D0
180C: D06EFFF0      MOVEA.B    -16(A6),A0
1810: 3D40FFF4      MOVE.W     D0,-12(A6)
1814: 4A6E000A      TST.W      10(A6)
1818: 673C          BEQ.S      $1856
181A: 3F2E000A      MOVE.W     10(A6),-(A7)
181E: 486DF10E      PEA        -3826(A5)                      ; A5-3826
1822: 486EFFF9      PEA        -7(A6)
1826: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
182A: 1D40FFF8      MOVE.B     D0,-8(A6)
182E: 4257          CLR.W      (A7)
1830: 486EFFF8      PEA        -8(A6)
1834: A88C          MOVE.L     A4,(A4)
1836: 301F          MOVE.W     (A7)+,D0
1838: 916EFFF63EAE  MOVE.B     -10(A6),16046(A0)
183E: FFF670FE      MOVE.W     -2(A6,D7.W),???
1842: D06EFFF4      MOVEA.B    -12(A6),A0
1846: 3F00          MOVE.W     D0,-(A7)
1848: A893          MOVE.L     (A3),(A4)
184A: 536EFFF6486E  MOVE.B     -10(A6),18542(A1)
1850: FFF8A884      MOVE.W     $A884.W,???
1854: 5C8F          MOVE.B     A7,(A6)
1856: 486EFFF0      PEA        -16(A6)
185A: A8A3          MOVE.L     -(A3),(A4)
185C: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
1860: 4E5E          UNLK       A6
1862: 4E75          RTS        


; ======= Function at 0x1864 =======
1864: 4E560000      LINK       A6,#0
1868: 4EBAEFA0      JSR        -4192(PC)
186C: 4E5E          UNLK       A6
186E: 4E75          RTS        

1870: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
1874: 3F3C0003      MOVE.W     #$0003,-(A7)
1878: A827          MOVE.L     -(A7),D4
187A: 4E75          RTS        

187C: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
1880: 3F3C0004      MOVE.W     #$0004,-(A7)
1884: A827          MOVE.L     -(A7),D4
1886: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
188A: 3F3C0002      MOVE.W     #$0002,-(A7)
188E: A828206D      MOVE.L     8301(A0),D4
1892: DED2          MOVE.B     (A2),(A7)+
1894: 2050          MOVEA.L    (A0),A0
1896: 42280010      CLR.B      16(A0)
189A: 206DDEC6      MOVEA.L    -8506(A5),A0
189E: 2050          MOVEA.L    (A0),A0
18A0: 117C00FF0010  MOVE.B     #$FF,16(A0)
18A6: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
18AA: 4EAD05C2      JSR        1474(A5)                       ; JT[1474]
18AE: 42ADEFDA      CLR.L      -4134(A5)
18B2: 588F          MOVE.B     A7,(A4)
18B4: 4E75          RTS        

18B6: 206DDED2      MOVEA.L    -8494(A5),A0
18BA: 2050          MOVEA.L    (A0),A0
18BC: 117C00FF0010  MOVE.B     #$FF,16(A0)
18C2: 206DDEC6      MOVEA.L    -8506(A5),A0
18C6: 2050          MOVEA.L    (A0),A0
18C8: 42280010      CLR.B      16(A0)
18CC: 2F2DDEC6      MOVE.L     -8506(A5),-(A7)                ; A5-8506
18D0: A96D2F2DDEC2  MOVE.L     12077(A5),-8510(A4)            ; A5+12077
18D6: 3F3C0004      MOVE.W     #$0004,-(A7)
18DA: A8282F2D      MOVE.L     12077(A0),D4
18DE: DEC2          MOVE.B     D2,(A7)+
18E0: 3F3C0002      MOVE.W     #$0002,-(A7)
18E4: A827          MOVE.L     -(A7),D4
18E6: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
18EA: 4EAD05C2      JSR        1474(A5)                       ; JT[1474]
18EE: 42ADEFDA      CLR.L      -4134(A5)
18F2: 588F          MOVE.B     A7,(A4)
18F4: 4E75          RTS        

18F6: 2038016A      MOVE.L     $016A.W,D0
18FA: 4E75          RTS        

18FC: 41EDD72A      LEA        -10454(A5),A0                  ; A5-10454
1900: 2008          MOVE.L     A0,D0
1902: 4E75          RTS        


; ======= Function at 0x1904 =======
1904: 4E560000      LINK       A6,#0
1908: 2F0C          MOVE.L     A4,-(A7)
190A: 286E0008      MOVEA.L    8(A6),A4
190E: 1014          MOVE.B     (A4),D0
1910: 4880          EXT.W      D0
1912: 42340001      CLR.B      1(A4,D0.W)
1916: 2F0C          MOVE.L     A4,-(A7)
1918: 486DD72A      PEA        -10454(A5)                     ; A5-10454
191C: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
1920: 2EADDEC2      MOVE.L     -8510(A5),(A7)                 ; A5-8510
1924: 2F0C          MOVE.L     A4,-(A7)
1926: A91A          MOVE.L     (A2)+,-(A4)
1928: 286EFFFC      MOVEA.L    -4(A6),A4
192C: 4E5E          UNLK       A6
192E: 4E75          RTS        


; ======= Function at 0x1930 =======
1930: 4E56FFFC      LINK       A6,#-4                         ; frame=4
1934: 2F07          MOVE.L     D7,-(A7)
1936: 4A6DDE5E      TST.W      -8610(A5)
193A: 672E          BEQ.S      $196A
193C: 486EFFFC      PEA        -4(A6)
1940: A97242272F2E  MOVE.L     39(A2,D4.W*2),12078(A4)
1946: FFFC206D      MOVE.W     #$206D,???
194A: DE80          MOVE.B     D0,(A7)
194C: 48680012      PEA        18(A0)
1950: A8AD7E00      MOVE.L     32256(A5),(A4)                 ; A5+32256
1954: 1E1F          MOVE.B     (A7)+,D7
1956: BE6DEF02      MOVEA.W    -4350(A5),A7
195A: 670A          BEQ.S      $1966
195C: 206DDE80      MOVEA.L    -8576(A5),A0
1960: 48680012      PEA        18(A0)
1964: A8A4          MOVE.L     -(A4),(A4)
1966: 3B47EF02      MOVE.W     D7,-4350(A5)
196A: 2E1F          MOVE.L     (A7)+,D7
196C: 4E5E          UNLK       A6
196E: 4E75          RTS        


; ======= Function at 0x1970 =======
1970: 4E56FFFC      LINK       A6,#-4                         ; frame=4
1974: 42A7          CLR.L      -(A7)
1976: 206DDEC2      MOVEA.L    -8510(A5),A0
197A: 2F2800CA      MOVE.L     202(A0),-(A7)
197E: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
1982: 2D5FFFFC      MOVE.L     (A7)+,-4(A6)
1986: 48780006      PEA        $0006.W
198A: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
198E: 4EAD004A      JSR        74(A5)                         ; JT[74]
1992: 53804E5E      MOVE.B     D0,94(A1,D4.L*8)
1996: 4E75          RTS        


; ======= Function at 0x1998 =======
1998: 4E56FF9A      LINK       A6,#-102                       ; frame=102
199C: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
19A0: 286E000C      MOVEA.L    12(A6),A4
19A4: 202E0008      MOVE.L     8(A6),D0
19A8: B0ADDEC2      MOVE.W     -8510(A5),(A0)                 ; A5-8510
19AC: 6704          BEQ.S      $19B2
19AE: 4EAD01A2      JSR        418(A5)                        ; JT[418]
19B2: 2F2E0008      MOVE.L     8(A6),-(A7)
19B6: A8732D6C      MOVEA.L    108(A3,D2.L*4),A4
19BA: 000AFFD8      ORI.B      #$FFD8,A2
19BE: 486EFFD8      PEA        -40(A6)
19C2: A8714EBA      MOVEA.L    -70(A1,D4.L*8),A4
19C6: 16D8          MOVE.B     (A0)+,(A3)+
19C8: 4A40          TST.W      D0
19CA: 670000A4      BEQ.W      $1A72
19CE: 4227          CLR.B      -(A7)
19D0: 2F2EFFD8      MOVE.L     -40(A6),-(A7)
19D4: 486DEFB2      PEA        -4174(A5)                      ; A5-4174
19D8: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
19DC: 6712          BEQ.S      $19F0
19DE: 42A7          CLR.L      -(A7)
19E0: 3F3C0082      MOVE.W     #$0082,-(A7)
19E4: A9B9205F2B50EFDA  MOVE.L     $205F2B50,-38(A4,A6.L*8)
19EC: 60000082      BRA.W      $1A72
19F0: 4227          CLR.B      -(A7)
19F2: 2F2EFFD8      MOVE.L     -40(A6),-(A7)
19F6: 486DEFBA      PEA        -4166(A5)                      ; A5-4166
19FA: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
19FE: 6710          BEQ.S      $1A10
1A00: 42A7          CLR.L      -(A7)
1A02: 3F3C0080      MOVE.W     #$0080,-(A7)
1A06: A9B9205F2B50EFDA  MOVE.L     $205F2B50,-38(A4,A6.L*8)
1A0E: 6060          BRA.S      $1A70
1A10: 4227          CLR.B      -(A7)
1A12: 2F2EFFD8      MOVE.L     -40(A6),-(A7)
1A16: 486DEFC2      PEA        -4158(A5)                      ; A5-4158
1A1A: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
1A1E: 6710          BEQ.S      $1A30
1A20: 42A7          CLR.L      -(A7)
1A22: 3F3C0083      MOVE.W     #$0083,-(A7)
1A26: A9B9205F2B50EFDA  MOVE.L     $205F2B50,-38(A4,A6.L*8)
1A2E: 6040          BRA.S      $1A70
1A30: 4227          CLR.B      -(A7)
1A32: 2F2EFFD8      MOVE.L     -40(A6),-(A7)
1A36: 486DEFCA      PEA        -4150(A5)                      ; A5-4150
1A3A: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
1A3E: 6710          BEQ.S      $1A50
1A40: 42A7          CLR.L      -(A7)
1A42: 3F3C0081      MOVE.W     #$0081,-(A7)
1A46: A9B9205F2B50EFDA  MOVE.L     $205F2B50,-38(A4,A6.L*8)
1A4E: 6020          BRA.S      $1A70
1A50: 4227          CLR.B      -(A7)
1A52: 2F2EFFD8      MOVE.L     -40(A6),-(A7)
1A56: 486DEFD2      PEA        -4142(A5)                      ; A5-4142
1A5A: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
1A5E: 6700050A      BEQ.W      $1F6C
1A62: 42A7          CLR.L      -(A7)
1A64: 3F3C0084      MOVE.W     #$0084,-(A7)
1A68: A9B9205F2B50EFDA  MOVE.L     $205F2B50,-38(A4,A6.L*8)
1A70: 206DDEC2      MOVEA.L    -8510(A5),A0
1A74: 2D6800A0FF9E  MOVE.L     160(A0),-98(A6)
1A7A: 4A6DD9AE      TST.W      -9810(A5)
1A7E: 670000AC      BEQ.W      $1B2E
1A82: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
1A86: 3F3C0003      MOVE.W     #$0003,-(A7)
1A8A: 486EFFC4      PEA        -60(A6)
1A8E: 486EFFA2      PEA        -94(A6)
1A92: 486EFFAA      PEA        -86(A6)
1A96: A98D4227      MOVE.L     A5,39(A4,D4.W*2)
1A9A: 2F2EFFD8      MOVE.L     -40(A6),-(A7)
1A9E: 486EFFAA      PEA        -86(A6)
1AA2: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
1AA6: 6732          BEQ.S      $1ADA
1AA8: 0C6D0001D9AE  CMPI.W     #$0001,-9810(A5)
1AAE: 6706          BEQ.S      $1AB6
1AB0: 2F2EFF9E      MOVE.L     -98(A6),-(A7)
1AB4: A9D82F2EFFD8  MOVE.L     (A0)+,#$2F2EFFD8
1ABA: 082C0001000E  BTST       #1,14(A4)
1AC0: 6704          BEQ.S      $1AC6
1AC2: 7001          MOVEQ      #1,D0
1AC4: 6002          BRA.S      $1AC8
1AC6: 7000          MOVEQ      #0,D0
1AC8: 1F00          MOVE.B     D0,-(A7)
1ACA: 2F2EFF9E      MOVE.L     -98(A6),-(A7)
1ACE: A9D43B7C0001  MOVE.L     (A4),#$3B7C0001
1AD4: D9AE60000A12  MOVE.B     24576(A6),18(A4,D0.L*2)
1ADA: 486EFFCC      PEA        -52(A6)
1ADE: 486EFFCE      PEA        -50(A6)
1AE2: 486EFFD8      PEA        -40(A6)
1AE6: 4EAD03F2      JSR        1010(A5)                       ; JT[1010]
1AEA: 4A6EFFCE      TST.W      -50(A6)
1AEE: 4FEF000C      LEA        12(A7),A7
1AF2: 6F38          BLE.S      $1B2C
1AF4: 0C6E000FFFCE  CMPI.W     #$000F,-50(A6)
1AFA: 6E30          BGT.S      $1B2C
1AFC: 4A6EFFCC      TST.W      -52(A6)
1B00: 6F2A          BLE.S      $1B2C
1B02: 0C6E000FFFCC  CMPI.W     #$000F,-52(A6)
1B08: 6E22          BGT.S      $1B2C
1B0A: 0C6D0001D9AE  CMPI.W     #$0001,-9810(A5)
1B10: 6606          BNE.S      $1B18
1B12: 2F2EFF9E      MOVE.L     -98(A6),-(A7)
1B16: A9D93F2EFFCC  MOVE.L     (A1)+,#$3F2EFFCC
1B1C: 3F2EFFCE      MOVE.W     -50(A6),-(A7)
1B20: 4EBA0A4A      JSR        2634(PC)
1B24: 3B7C0002D9AE  MOVE.W     #$0002,-9810(A5)
1B2A: 588F          MOVE.B     A7,(A4)
1B2C: 486EFFAA      PEA        -86(A6)
1B30: 2F2EFFD8      MOVE.L     -40(A6),-(A7)
1B34: 4EBA0F02      JSR        3842(PC)
1B38: 3E00          MOVE.W     D0,D7
1B3A: 0C47FFFF      CMPI.W     #$FFFF,D7
1B3E: 508F          MOVE.B     A7,(A0)
1B40: 67000428      BEQ.W      $1F6C
1B44: 204D          MOVEA.L    A5,A0
1B46: 2007          MOVE.L     D7,D0
1B48: 48C0          EXT.L      D0
1B4A: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1B4E: 4A68DE2A      TST.W      -8662(A0)
1B52: 670000C4      BEQ.W      $1C1A
1B56: 204D          MOVEA.L    A5,A0
1B58: 2007          MOVE.L     D7,D0
1B5A: 48C0          EXT.L      D0
1B5C: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1B60: 3F28DE28      MOVE.W     -8664(A0),-(A7)
1B64: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
1B68: 1800          MOVE.B     D0,D4
1B6A: 1004          MOVE.B     D4,D0
1B6C: 4880          EXT.W      D0
1B6E: 3E80          MOVE.W     D0,(A7)
1B70: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
1B74: 3E80          MOVE.W     D0,(A7)
1B76: 486DA74E      PEA        -22706(A5)                     ; A5-22706
1B7A: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
1B7E: 2640          MOVEA.L    D0,A3
1B80: 200B          MOVE.L     A3,D0
1B82: 5C8F          MOVE.B     A7,(A6)
1B84: 6604          BNE.S      $1B8A
1B86: 600C          BRA.S      $1B94
1B88: 528B          MOVE.B     A3,(A1)
1B8A: 16AB0001      MOVE.B     1(A3),(A3)
1B8E: 66F8          BNE.S      $1B88
1B90: 60000092      BRA.W      $1C26
1B94: 7A01          MOVEQ      #1,D5
1B96: 6076          BRA.S      $1C0E
1B98: 7C01          MOVEQ      #1,D6
1B9A: 606A          BRA.S      $1C06
1B9C: 7011          MOVEQ      #17,D0
1B9E: C1C5          ANDA.L     D5,A0
1BA0: 41EDD88D      LEA        -10099(A5),A0                  ; A5-10099
1BA4: D088          MOVE.B     A0,(A0)
1BA6: 3046          MOVEA.W    D6,A0
1BA8: 7211          MOVEQ      #17,D1
1BAA: C3C5          ANDA.L     D5,A1
1BAC: 43EDD76C      LEA        -10388(A5),A1                  ; g_lookup_tbl
1BB0: D289          MOVE.B     A1,(A1)
1BB2: 3246          MOVEA.W    D6,A1
1BB4: 12311800      MOVE.B     0(A1,D1.L),D1
1BB8: B2300800      MOVE.W     0(A0,D0.L),D1
1BBC: 6746          BEQ.S      $1C04
1BBE: 7011          MOVEQ      #17,D0
1BC0: C1C5          ANDA.L     D5,A0
1BC2: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
1BC6: D088          MOVE.B     A0,(A0)
1BC8: 3046          MOVEA.W    D6,A0
1BCA: B8300800      MOVE.W     0(A0,D0.L),D4
1BCE: 6722          BEQ.S      $1BF2
1BD0: 0C04003F      CMPI.B     #$003F,D4
1BD4: 662E          BNE.S      $1C04
1BD6: 7011          MOVEQ      #17,D0
1BD8: C1C5          ANDA.L     D5,A0
1BDA: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
1BDE: D088          MOVE.B     A0,(A0)
1BE0: 3046          MOVEA.W    D6,A0
1BE2: 7200          MOVEQ      #0,D1
1BE4: 12300800      MOVE.B     0(A0,D0.L),D1
1BE8: 204D          MOVEA.L    A5,A0
1BEA: D1C14A28      MOVE.B     D1,$4A28.W
1BEE: FBD8          MOVE.W     (A0)+,???
1BF0: 6A12          BPL.S      $1C04
1BF2: 42A7          CLR.L      -(A7)
1BF4: 4267          CLR.W      -(A7)
1BF6: 3F06          MOVE.W     D6,-(A7)
1BF8: 3F05          MOVE.W     D5,-(A7)
1BFA: 4EBAE4FC      JSR        -6916(PC)
1BFE: 4FEF000A      LEA        10(A7),A7
1C02: 6020          BRA.S      $1C24
1C04: 5246          MOVEA.B    D6,A1
1C06: 0C460010      CMPI.W     #$0010,D6
1C0A: 6D90          BLT.S      $1B9C
1C0C: 5245          MOVEA.B    D5,A1
1C0E: 0C450010      CMPI.W     #$0010,D5
1C12: 6D84          BLT.S      $1B98
1C14: 4EAD01A2      JSR        418(A5)                        ; JT[418]
1C18: 3F3C0001      MOVE.W     #$0001,-(A7)
1C1C: 3F07          MOVE.W     D7,-(A7)
1C1E: 4EBAE974      JSR        -5772(PC)
1C22: 588F          MOVE.B     A7,(A4)
1C24: 206DDEC2      MOVEA.L    -8510(A5),A0
1C28: 2D680010FFB2  MOVE.L     16(A0),-78(A6)
1C2E: 2D680014FFB6  MOVE.L     20(A0),-74(A6)
1C34: 2D680010FFBA  MOVE.L     16(A0),-70(A6)
1C3A: 2D680014FFBE  MOVE.L     20(A0),-66(A6)
1C40: 302EFFAC      MOVE.W     -84(A6),D0
1C44: D06EFFB0      MOVEA.B    -80(A6),A0
1C48: 48C0          EXT.L      D0
1C4A: 81FC00023D40  ORA.L      #$00023D40,A0
1C50: FFDA          MOVE.W     (A2)+,???
1C52: 302EFFAA      MOVE.W     -86(A6),D0
1C56: D06EFFAE      MOVEA.B    -82(A6),A0
1C5A: 48C0          EXT.L      D0
1C5C: 81FC00023D40  ORA.L      #$00023D40,A0
1C62: FFD8          MOVE.W     (A0)+,???
1C64: 42A7          CLR.L      -(A7)
1C66: A8D8          MOVE.L     (A0)+,(A4)+
1C68: 245F          MOVEA.L    (A7)+,A2
1C6A: 2F0A          MOVE.L     A2,-(A7)
1C6C: 486EFFAA      PEA        -86(A6)
1C70: A8DF          MOVE.L     (A7)+,(A4)+
1C72: 426DEF02      CLR.W      -4350(A5)
1C76: 42A7          CLR.L      -(A7)
1C78: 2F0A          MOVE.L     A2,-(A7)
1C7A: 2F2EFFD8      MOVE.L     -40(A6),-(A7)
1C7E: 486EFFB2      PEA        -78(A6)
1C82: 486EFFBA      PEA        -70(A6)
1C86: 4267          CLR.W      -(A7)
1C88: 486D0452      PEA        1106(A5)                       ; A5+1106
1C8C: A905          MOVE.L     D5,-(A4)
1C8E: 2D5FFFA6      MOVE.L     (A7)+,-90(A6)
1C92: 4A6DEF02      TST.W      -4350(A5)
1C96: 670A          BEQ.S      $1CA2
1C98: 206DDE80      MOVEA.L    -8576(A5),A0
1C9C: 48680012      PEA        18(A0)
1CA0: A8A4          MOVE.L     -(A4),(A4)
1CA2: 2F0A          MOVE.L     A2,-(A7)
1CA4: A8D9          MOVE.L     (A1)+,(A4)+
1CA6: 4267          CLR.W      -(A7)
1CA8: 2F2EFFA6      MOVE.L     -90(A6),-(A7)
1CAC: A86B302E      MOVEA.L    12334(A3),A4
1CB0: FFDA          MOVE.W     (A2)+,???
1CB2: D05F          MOVEA.B    (A7)+,A0
1CB4: 3D40FFD6      MOVE.W     D0,-42(A6)
1CB8: 4267          CLR.W      -(A7)
1CBA: 2F2EFFA6      MOVE.L     -90(A6),-(A7)
1CBE: A86A302E      MOVEA.L    12334(A2),A4
1CC2: FFD8          MOVE.W     (A0)+,???
1CC4: D05F          MOVEA.B    (A7)+,A0
1CC6: 3D40FFD4      MOVE.W     D0,-44(A6)
1CCA: 486EFFD4      PEA        -44(A6)
1CCE: A8704267      MOVEA.L    103(A0,D4.W*2),A4
1CD2: 2F2EFFD4      MOVE.L     -44(A6),-(A7)
1CD6: 486E0008      PEA        8(A6)
1CDA: A92C4AAE      MOVE.L     19118(A4),-(A4)
1CDE: 0008548F      ORI.B      #$548F,A0
1CE2: 670007FE      BEQ.W      $24E4
1CE6: 202E0008      MOVE.L     8(A6),D0
1CEA: B0ADDEC2      MOVE.W     -8510(A5),(A0)                 ; A5-8510
1CEE: 660007F2      BNE.W      $24E4
1CF2: 486EFFD4      PEA        -44(A6)
1CF6: A8714227      MOVEA.L    39(A1,D4.W*2),A4
1CFA: 2F2EFFD4      MOVE.L     -44(A6),-(A7)
1CFE: 206DDE80      MOVEA.L    -8576(A5),A0
1D02: 48680012      PEA        18(A0)
1D06: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
1D0A: 670000B8      BEQ.W      $1DC6
1D0E: 4EAD0932      JSR        2354(A5)                       ; JT[2354]
1D12: 4A40          TST.W      D0
1D14: 670000AE      BEQ.W      $1DC6
1D18: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
1D1C: B1EDC3766608  MOVE.W     -15498(A5),$6608.W             ; A5-15498
1D22: 363C03EE      MOVE.W     #$03EE,D3
1D26: 600007B2      BRA.W      $24DC
1D2A: 7A01          MOVEQ      #1,D5
1D2C: 6038          BRA.S      $1D66
1D2E: 7C01          MOVEQ      #1,D6
1D30: 602C          BRA.S      $1D5E
1D32: 7011          MOVEQ      #17,D0
1D34: C1C5          ANDA.L     D5,A0
1D36: 41EDD88D      LEA        -10099(A5),A0                  ; A5-10099
1D3A: D088          MOVE.B     A0,(A0)
1D3C: 3046          MOVEA.W    D6,A0
1D3E: 7211          MOVEQ      #17,D1
1D40: C3C5          ANDA.L     D5,A1
1D42: 43EDD76C      LEA        -10388(A5),A1                  ; g_lookup_tbl
1D46: D289          MOVE.B     A1,(A1)
1D48: 3246          MOVEA.W    D6,A1
1D4A: 12311800      MOVE.B     0(A1,D1.L),D1
1D4E: B2300800      MOVE.W     0(A0,D0.L),D1
1D52: 6708          BEQ.S      $1D5C
1D54: 363C03EF      MOVE.W     #$03EF,D3
1D58: 60000780      BRA.W      $24DC
1D5C: 5246          MOVEA.B    D6,A1
1D5E: 0C460010      CMPI.W     #$0010,D6
1D62: 6DCE          BLT.S      $1D32
1D64: 5245          MOVEA.B    D5,A1
1D66: 0C450010      CMPI.W     #$0010,D5
1D6A: 6DC2          BLT.S      $1D2E
1D6C: 204D          MOVEA.L    A5,A0
1D6E: 2007          MOVE.L     D7,D0
1D70: 48C0          EXT.L      D0
1D72: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1D76: 1828DE29      MOVE.B     -8663(A0),D4
1D7A: 47EDA74E      LEA        -22706(A5),A3                  ; A5-22706
1D7E: 6002          BRA.S      $1D82
1D80: 528B          MOVE.B     A3,(A1)
1D82: B813          MOVE.W     (A3),D4
1D84: 6DFA          BLT.S      $1D80
1D86: 1C13          MOVE.B     (A3),D6
1D88: 4886          EXT.W      D6
1D8A: 16C4          MOVE.B     D4,(A3)+
1D8C: 1806          MOVE.B     D6,D4
1D8E: 4A04          TST.B      D4
1D90: 66F4          BNE.S      $1D86
1D92: 4213          CLR.B      (A3)
1D94: 4A6DD9AE      TST.W      -9810(A5)
1D98: 66000750      BNE.W      $24EC
1D9C: 4267          CLR.W      -(A7)
1D9E: 4EAD017A      JSR        378(A5)                        ; JT[378]
1DA2: 4A40          TST.W      D0
1DA4: 548F          MOVE.B     A7,(A2)
1DA6: 670A          BEQ.S      $1DB2
1DA8: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
1DAC: 4EAD02FA      JSR        762(A5)                        ; JT[762]
1DB0: 588F          MOVE.B     A7,(A4)
1DB2: 48780022      PEA        $0022.W
1DB6: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
1DBA: 4EAD01AA      JSR        426(A5)                        ; JT[426]
1DBE: 508F          MOVE.B     A7,(A0)
1DC0: 60000728      BRA.W      $24EC
1DC4: 486EFFAA      PEA        -86(A6)
1DC8: 2F2EFFD4      MOVE.L     -44(A6),-(A7)
1DCC: 4EBA0C6A      JSR        3178(PC)
1DD0: 3C00          MOVE.W     D0,D6
1DD2: 0C46FFFF      CMPI.W     #$FFFF,D6
1DD6: 508F          MOVE.B     A7,(A0)
1DD8: 677A          BEQ.S      $1E54
1DDA: BC47          MOVEA.W    D7,A6
1DDC: 6D04          BLT.S      $1DE2
1DDE: 7001          MOVEQ      #1,D0
1DE0: 6002          BRA.S      $1DE4
1DE2: 70FF          MOVEQ      #-1,D0
1DE4: 3D40FFCA      MOVE.W     D0,-54(A6)
1DE8: 204D          MOVEA.L    A5,A0
1DEA: 2207          MOVE.L     D7,D1
1DEC: 48C1          EXT.L      D1
1DEE: E589D1C1      MOVE.L     A1,-63(A2,A5.W)
1DF2: 2B68DE28DE48  MOVE.L     -8664(A0),-8632(A5)
1DF8: 3A07          MOVE.W     D7,D5
1DFA: 602C          BRA.S      $1E28
1DFC: 306EFFCA      MOVEA.W    -54(A6),A0
1E00: D0C5          MOVE.B     D5,(A0)+
1E02: 2008          MOVE.L     A0,D0
1E04: E5882040      MOVE.L     A0,64(A2,D2.W)
1E08: 41E8DE28      LEA        -8664(A0),A0
1E0C: D1CD224D      MOVE.B     A5,$224D.W
1E10: 2005          MOVE.L     D5,D0
1E12: 48C0          EXT.L      D0
1E14: E588D3C0      MOVE.L     A0,-64(A2,A5.W*2)
1E18: 2350DE28      MOVE.L     (A0),-8664(A1)
1E1C: 3F05          MOVE.W     D5,-(A7)
1E1E: 4EBA0CB6      JSR        3254(PC)
1E22: 548F          MOVE.B     A7,(A2)
1E24: DA6EFFCA      MOVEA.B    -54(A6),A5
1E28: BC45          MOVEA.W    D5,A6
1E2A: 66D0          BNE.S      $1DFC
1E2C: 204D          MOVEA.L    A5,A0
1E2E: 2006          MOVE.L     D6,D0
1E30: 48C0          EXT.L      D0
1E32: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1E36: 316DDE48DE28  MOVE.W     -8632(A5),-8664(A0)            ; A5-8632
1E3C: 204D          MOVEA.L    A5,A0
1E3E: 2006          MOVE.L     D6,D0
1E40: 48C0          EXT.L      D0
1E42: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1E46: 4268DE2A      CLR.W      -8662(A0)
1E4A: 3F06          MOVE.W     D6,-(A7)
1E4C: 4EBA0C88      JSR        3208(PC)
1E50: 60000698      BRA.W      $24EC
1E54: 486EFFCC      PEA        -52(A6)
1E58: 486EFFCE      PEA        -50(A6)
1E5C: 486EFFD4      PEA        -44(A6)
1E60: 4EAD03F2      JSR        1010(A5)                       ; JT[1010]
1E64: 0C6E0001FFCE  CMPI.W     #$0001,-50(A6)
1E6A: 4FEF000C      LEA        12(A7),A7
1E6E: 6D000672      BLT.W      $24E4
1E72: 0C6E000FFFCE  CMPI.W     #$000F,-50(A6)
1E78: 6E000668      BGT.W      $24E4
1E7C: 0C6E0001FFCC  CMPI.W     #$0001,-52(A6)
1E82: 6D00065E      BLT.W      $24E4
1E86: 0C6E000FFFCC  CMPI.W     #$000F,-52(A6)
1E8C: 6E000654      BGT.W      $24E4
1E90: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
1E94: B1EDC3766608  MOVE.W     -15498(A5),$6608.W             ; A5-15498
1E9A: 363C03EE      MOVE.W     #$03EE,D3
1E9E: 6000063A      BRA.W      $24DC
1EA2: 4A2DA74E      TST.B      -22706(A5)
1EA6: 6708          BEQ.S      $1EB0
1EA8: 363C03EF      MOVE.W     #$03EF,D3
1EAC: 6000062C      BRA.W      $24DC
1EB0: 7011          MOVEQ      #17,D0
1EB2: C1EEFFCE      ANDA.L     -50(A6),A0
1EB6: D08D          MOVE.B     A5,(A0)
1EB8: 306EFFCC      MOVEA.W    -52(A6),A0
1EBC: D1C04A28      MOVE.B     D0,$4A28.W
1EC0: D76C6708363C  MOVE.B     26376(A4),13884(A3)
1EC6: 03ED6000      BSET       D1,24576(A5)
1ECA: 0610204D      ADDI.B     #$204D,(A0)
1ECE: 2007          MOVE.L     D7,D0
1ED0: 48C0          EXT.L      D0
1ED2: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1ED6: 4268DE2A      CLR.W      -8662(A0)
1EDA: 204D          MOVEA.L    A5,A0
1EDC: 2007          MOVE.L     D7,D0
1EDE: 48C0          EXT.L      D0
1EE0: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1EE4: 0C68003FDE28  CMPI.W     #$003F,-8664(A0)
1EEA: 6636          BNE.S      $1F22
1EEC: 42A7          CLR.L      -(A7)
1EEE: 3F3C003F      MOVE.W     #$003F,-(A7)
1EF2: 3F2EFFCC      MOVE.W     -52(A6),-(A7)
1EF6: 3F2EFFCE      MOVE.W     -50(A6),-(A7)
1EFA: 4EBAE1FC      JSR        -7684(PC)
1EFE: 4EBA1686      JSR        5766(PC)
1F02: 2EBC00010001  MOVE.L     #$00010001,(A7)
1F08: 102DDE4C      MOVE.B     -8628(A5),D0                   ; A5-8628
1F0C: 4880          EXT.W      D0
1F0E: 3F00          MOVE.W     D0,-(A7)
1F10: 3F2EFFCC      MOVE.W     -52(A6),-(A7)
1F14: 3F2EFFCE      MOVE.W     -50(A6),-(A7)
1F18: 4EBAE1DE      JSR        -7714(PC)
1F1C: 4FEF0010      LEA        16(A7),A7
1F20: 602A          BRA.S      $1F4C
1F22: 2F3C00010001  MOVE.L     #$00010001,-(A7)
1F28: 204D          MOVEA.L    A5,A0
1F2A: 2007          MOVE.L     D7,D0
1F2C: 48C0          EXT.L      D0
1F2E: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1F32: 3F28DE28      MOVE.W     -8664(A0),-(A7)
1F36: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
1F3A: 3E80          MOVE.W     D0,(A7)
1F3C: 3F2EFFCC      MOVE.W     -52(A6),-(A7)
1F40: 3F2EFFCE      MOVE.W     -50(A6),-(A7)
1F44: 4EBAE1B2      JSR        -7758(PC)
1F48: 4FEF000A      LEA        10(A7),A7
1F4C: 204D          MOVEA.L    A5,A0
1F4E: 2007          MOVE.L     D7,D0
1F50: 48C0          EXT.L      D0
1F52: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1F56: 4A68DE2A      TST.W      -8662(A0)
1F5A: 6600058E      BNE.W      $24EC
1F5E: 3F07          MOVE.W     D7,-(A7)
1F60: 4EBA0B74      JSR        2932(PC)
1F64: 548F          MOVE.B     A7,(A2)
1F66: 60000582      BRA.W      $24EC
1F6A: 486EFFCC      PEA        -52(A6)
1F6E: 486EFFCE      PEA        -50(A6)
1F72: 486EFFD8      PEA        -40(A6)
1F76: 4EAD03F2      JSR        1010(A5)                       ; JT[1010]
1F7A: 4EBA1122      JSR        4386(PC)
1F7E: 4A40          TST.W      D0
1F80: 4FEF000C      LEA        12(A7),A7
1F84: 67000252      BEQ.W      $21DA
1F88: 0C6E0001FFCE  CMPI.W     #$0001,-50(A6)
1F8E: 6D00055A      BLT.W      $24EC
1F92: 0C6E000FFFCE  CMPI.W     #$000F,-50(A6)
1F98: 6E000550      BGT.W      $24EC
1F9C: 0C6E0001FFCC  CMPI.W     #$0001,-52(A6)
1FA2: 6D000546      BLT.W      $24EC
1FA6: 0C6E000FFFCC  CMPI.W     #$000F,-52(A6)
1FAC: 6E00053C      BGT.W      $24EC
1FB0: 4AADEFDA      TST.L      -4134(A5)
1FB4: 67000212      BEQ.W      $21CA
1FB8: 42A7          CLR.L      -(A7)
1FBA: 3F3C0082      MOVE.W     #$0082,-(A7)
1FBE: A9B9205F202DEFDA  MOVE.L     $205F202D,-38(A4,A6.L*8)
1FC6: B090          MOVE.W     (A0),(A0)
1FC8: 6658          BNE.S      $2022
1FCA: 700F          MOVEQ      #15,D0
1FCC: D06EFFCC      MOVEA.B    -52(A6),A0
1FD0: C1FC0011D08D  ANDA.L     #$0011D08D,A0
1FD6: 306EFFCE      MOVEA.W    -50(A6),A0
1FDA: D1C07003      MOVE.B     D0,$7003.W
1FDE: 114097B2      MOVE.B     D0,-26702(A0)
1FE2: 7211          MOVEQ      #17,D1
1FE4: C3EEFFCE      ANDA.L     -50(A6),A1
1FE8: D28D          MOVE.B     A5,(A1)
1FEA: 306EFFCC      MOVEA.W    -52(A6),A0
1FEE: D1C11140      MOVE.B     D1,$1140.W
1FF2: 97B2700FD06E  MOVE.B     15(A2,D7.W),110(A3,A5.W)
1FF8: FFCC          MOVE.W     A4,???
1FFA: C1FC0011D08D  ANDA.L     #$0011D08D,A0
2000: 306EFFCE      MOVEA.W    -50(A6),A0
2004: D1C07001      MOVE.B     D0,$7001.W
2008: 11409592      MOVE.B     D0,-27246(A0)
200C: 7211          MOVEQ      #17,D1
200E: C3EEFFCE      ANDA.L     -50(A6),A1
2012: D28D          MOVE.B     A5,(A1)
2014: 306EFFCC      MOVEA.W    -52(A6),A0
2018: D1C11140      MOVE.B     D1,$1140.W
201C: 95926000      MOVE.B     (A2),0(A2,D6.W)
2020: 01A842A7      BCLR       D0,17063(A0)
2024: 3F3C0080      MOVE.W     #$0080,-(A7)
2028: A9B9205F202DEFDA  MOVE.L     $205F202D,-38(A4,A6.L*8)
2030: B090          MOVE.W     (A0),(A0)
2032: 6658          BNE.S      $208C
2034: 700F          MOVEQ      #15,D0
2036: D06EFFCC      MOVEA.B    -52(A6),A0
203A: C1FC0011D08D  ANDA.L     #$0011D08D,A0
2040: 306EFFCE      MOVEA.W    -50(A6),A0
2044: D1C07001      MOVE.B     D0,$7001.W
2048: 114097B2      MOVE.B     D0,-26702(A0)
204C: 7211          MOVEQ      #17,D1
204E: C3EEFFCE      ANDA.L     -50(A6),A1
2052: D28D          MOVE.B     A5,(A1)
2054: 306EFFCC      MOVEA.W    -52(A6),A0
2058: D1C11140      MOVE.B     D1,$1140.W
205C: 97B2700FD06E  MOVE.B     15(A2,D7.W),110(A3,A5.W)
2062: FFCC          MOVE.W     A4,???
2064: C1FC0011D08D  ANDA.L     #$0011D08D,A0
206A: 306EFFCE      MOVEA.W    -50(A6),A0
206E: D1C07003      MOVE.B     D0,$7003.W
2072: 11409592      MOVE.B     D0,-27246(A0)
2076: 7211          MOVEQ      #17,D1
2078: C3EEFFCE      ANDA.L     -50(A6),A1
207C: D28D          MOVE.B     A5,(A1)
207E: 306EFFCC      MOVEA.W    -52(A6),A0
2082: D1C11140      MOVE.B     D1,$1140.W
2086: 95926000      MOVE.B     (A2),0(A2,D6.W)
208A: 013E          BTST       D0,???
208C: 42A7          CLR.L      -(A7)
208E: 3F3C0083      MOVE.W     #$0083,-(A7)
2092: A9B9205F202DEFDA  MOVE.L     $205F202D,-38(A4,A6.L*8)
209A: B090          MOVE.W     (A0),(A0)
209C: 6658          BNE.S      $20F6
209E: 700F          MOVEQ      #15,D0
20A0: D06EFFCC      MOVEA.B    -52(A6),A0
20A4: C1FC0011D08D  ANDA.L     #$0011D08D,A0
20AA: 306EFFCE      MOVEA.W    -50(A6),A0
20AE: D1C07002      MOVE.B     D0,$7002.W
20B2: 114097B2      MOVE.B     D0,-26702(A0)
20B6: 7211          MOVEQ      #17,D1
20B8: C3EEFFCE      ANDA.L     -50(A6),A1
20BC: D28D          MOVE.B     A5,(A1)
20BE: 306EFFCC      MOVEA.W    -52(A6),A0
20C2: D1C11140      MOVE.B     D1,$1140.W
20C6: 97B2700FD06E  MOVE.B     15(A2,D7.W),110(A3,A5.W)
20CC: FFCC          MOVE.W     A4,???
20CE: C1FC0011D08D  ANDA.L     #$0011D08D,A0
20D4: 306EFFCE      MOVEA.W    -50(A6),A0
20D8: D1C07001      MOVE.B     D0,$7001.W
20DC: 11409592      MOVE.B     D0,-27246(A0)
20E0: 7211          MOVEQ      #17,D1
20E2: C3EEFFCE      ANDA.L     -50(A6),A1
20E6: D28D          MOVE.B     A5,(A1)
20E8: 306EFFCC      MOVEA.W    -52(A6),A0
20EC: D1C11140      MOVE.B     D1,$1140.W
20F0: 95926000      MOVE.B     (A2),0(A2,D6.W)
20F4: 00D4          DC.W       $00D4
20F6: 42A7          CLR.L      -(A7)
20F8: 3F3C0081      MOVE.W     #$0081,-(A7)
20FC: A9B9205F202DEFDA  MOVE.L     $205F202D,-38(A4,A6.L*8)
2104: B090          MOVE.W     (A0),(A0)
2106: 6656          BNE.S      $215E
2108: 700F          MOVEQ      #15,D0
210A: D06EFFCC      MOVEA.B    -52(A6),A0
210E: C1FC0011D08D  ANDA.L     #$0011D08D,A0
2114: 306EFFCE      MOVEA.W    -50(A6),A0
2118: D1C07001      MOVE.B     D0,$7001.W
211C: 114097B2      MOVE.B     D0,-26702(A0)
2120: 7211          MOVEQ      #17,D1
2122: C3EEFFCE      ANDA.L     -50(A6),A1
2126: D28D          MOVE.B     A5,(A1)
2128: 306EFFCC      MOVEA.W    -52(A6),A0
212C: D1C11140      MOVE.B     D1,$1140.W
2130: 97B2700FD06E  MOVE.B     15(A2,D7.W),110(A3,A5.W)
2136: FFCC          MOVE.W     A4,???
2138: C1FC0011D08D  ANDA.L     #$0011D08D,A0
213E: 306EFFCE      MOVEA.W    -50(A6),A0
2142: D1C07002      MOVE.B     D0,$7002.W
2146: 11409592      MOVE.B     D0,-27246(A0)
214A: 7211          MOVEQ      #17,D1
214C: C3EEFFCE      ANDA.L     -50(A6),A1
2150: D28D          MOVE.B     A5,(A1)
2152: 306EFFCC      MOVEA.W    -52(A6),A0
2156: D1C11140      MOVE.B     D1,$1140.W
215A: 9592606A      MOVE.B     (A2),106(A2,D6.W)
215E: 42A7          CLR.L      -(A7)
2160: 3F3C0084      MOVE.W     #$0084,-(A7)
2164: A9B9205F202DEFDA  MOVE.L     $205F202D,-38(A4,A6.L*8)
216C: B090          MOVE.W     (A0),(A0)
216E: 6704          BEQ.S      $2174
2170: 4EAD01A2      JSR        418(A5)                        ; JT[418]
2174: 700F          MOVEQ      #15,D0
2176: D06EFFCC      MOVEA.B    -52(A6),A0
217A: C1FC0011D08D  ANDA.L     #$0011D08D,A0
2180: 306EFFCE      MOVEA.W    -50(A6),A0
2184: D1C07001      MOVE.B     D0,$7001.W
2188: 114097B2      MOVE.B     D0,-26702(A0)
218C: 7211          MOVEQ      #17,D1
218E: C3EEFFCE      ANDA.L     -50(A6),A1
2192: D28D          MOVE.B     A5,(A1)
2194: 306EFFCC      MOVEA.W    -52(A6),A0
2198: D1C11140      MOVE.B     D1,$1140.W
219C: 97B2700FD06E  MOVE.B     15(A2,D7.W),110(A3,A5.W)
21A2: FFCC          MOVE.W     A4,???
21A4: C1FC0011D08D  ANDA.L     #$0011D08D,A0
21AA: 306EFFCE      MOVEA.W    -50(A6),A0
21AE: D1C07001      MOVE.B     D0,$7001.W
21B2: 11409592      MOVE.B     D0,-27246(A0)
21B6: 7211          MOVEQ      #17,D1
21B8: C3EEFFCE      ANDA.L     -50(A6),A1
21BC: D28D          MOVE.B     A5,(A1)
21BE: 306EFFCC      MOVEA.W    -52(A6),A0
21C2: D1C11140      MOVE.B     D1,$1140.W
21C6: 95923F2E      MOVE.B     (A2),46(A2,D3.L*8)
21CA: FFCC          MOVE.W     A4,???
21CC: 3F2EFFCE      MOVE.W     -50(A6),-(A7)
21D0: 4EAD03DA      JSR        986(A5)                        ; JT[986]
21D4: 60000314      BRA.W      $24EC
21D8: 0C6E0001FFCE  CMPI.W     #$0001,-50(A6)
21DE: 6D1A          BLT.S      $21FA
21E0: 0C6E000FFFCE  CMPI.W     #$000F,-50(A6)
21E6: 6E12          BGT.S      $21FA
21E8: 0C6E0001FFCC  CMPI.W     #$0001,-52(A6)
21EE: 6D0A          BLT.S      $21FA
21F0: 0C6E000FFFCC  CMPI.W     #$000F,-52(A6)
21F6: 6F000128      BLE.W      $2322
21FA: 2F2EFFD8      MOVE.L     -40(A6),-(A7)
21FE: 486EFFFE      PEA        -2(A6)
2202: 4EBA02F0      JSR        752(PC)
2206: 4A40          TST.W      D0
2208: 508F          MOVE.B     A7,(A0)
220A: 670000AE      BEQ.W      $22BC
220E: 302DEFB0      MOVE.W     -4176(A5),D0                   ; A5-4176
2212: B06EFFFE      MOVEA.W    -2(A6),A0
2216: 66000092      BNE.W      $22AC
221A: 202C0006      MOVE.L     6(A4),D0
221E: 90ADEFDE      MOVE.B     -4130(A5),(A0)                 ; A5-4130
2222: B0B802F0      MOVE.W     $02F0.W,(A0)
2226: 62000082      BHI.W      $22AC
222A: 42A7          CLR.L      -(A7)
222C: 42A7          CLR.L      -(A7)
222E: 42A7          CLR.L      -(A7)
2230: 4EAD019A      JSR        410(A5)                        ; JT[410]
2234: 4A80          TST.L      D0
2236: 4FEF000C      LEA        12(A7),A7
223A: 676E          BEQ.S      $22AA
223C: 4267          CLR.W      -(A7)
223E: 2F2DDEC6      MOVE.L     -8506(A5),-(A7)                ; A5-8506
2242: A960302E      MOVE.L     -(A0),12334(A4)
2246: FFFE          MOVE.W     ???,???
2248: D05F          MOVEA.B    (A7)+,A0
224A: 3B40DE54      MOVE.W     D0,-8620(A5)
224E: 42A7          CLR.L      -(A7)
2250: 206DDEC2      MOVEA.L    -8510(A5),A0
2254: 2F2800CA      MOVE.L     202(A0),-(A7)
2258: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
225C: 2D5FFF9A      MOVE.L     (A7)+,-102(A6)
2260: 48780006      PEA        $0006.W
2264: 2F2EFF9A      MOVE.L     -102(A6),-(A7)
2268: 4EAD004A      JSR        74(A5)                         ; JT[74]
226C: 306DDE54      MOVEA.W    -8620(A5),A0
2270: B088          MOVE.W     A0,(A0)
2272: 6332          BLS.S      $22A6
2274: 206DDEC2      MOVEA.L    -8510(A5),A0
2278: 206800CA      MOVEA.L    202(A0),A0
227C: 7006          MOVEQ      #6,D0
227E: C1EDDE54      ANDA.L     -8620(A5),A0
2282: D090          MOVE.B     (A0),(A0)
2284: 2040          MOVEA.L    D0,A0
2286: 0C100004      CMPI.B     #$0004,(A0)
228A: 671A          BEQ.S      $22A6
228C: 3F2DDE54      MOVE.W     -8620(A5),-(A7)                ; A5-8620
2290: 4EAD0132      JSR        306(A5)                        ; JT[306]
2294: 3E80          MOVE.W     D0,(A7)
2296: 4EAD0162      JSR        354(A5)                        ; JT[354]
229A: 3EADDE54      MOVE.W     -8620(A5),(A7)                 ; A5-8620
229E: 4EAD0142      JSR        322(A5)                        ; JT[322]
22A2: 548F          MOVE.B     A7,(A2)
22A4: 6004          BRA.S      $22AA
22A6: 426DDE54      CLR.W      -8620(A5)
22AA: 3B6EFFFEEFB0  MOVE.W     -2(A6),-4176(A5)
22B0: 2B6C0006EFDE  MOVE.L     6(A4),-4130(A5)
22B6: 60000232      BRA.W      $24EC
22BA: 4227          CLR.B      -(A7)
22BC: 2F2EFFD8      MOVE.L     -40(A6),-(A7)
22C0: 206DDE80      MOVEA.L    -8576(A5),A0
22C4: 48680012      PEA        18(A0)
22C8: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
22CC: 6700021C      BEQ.W      $24EC
22D0: 206DDEB8      MOVEA.L    -8520(A5),A0
22D4: 4A28006E      TST.B      110(A0)
22D8: 67000210      BEQ.W      $24EC
22DC: 0C6DFFEFEFB0  CMPI.W     #$FFEF,-4176(A5)
22E2: 662C          BNE.S      $2310
22E4: 202C0006      MOVE.L     6(A4),D0
22E8: 90ADEFDE      MOVE.B     -4130(A5),(A0)                 ; A5-4130
22EC: B0B802F0      MOVE.W     $02F0.W,(A0)
22F0: 621E          BHI.S      $2310
22F2: 48780022      PEA        $0022.W
22F6: 486EFFDC      PEA        -36(A6)
22FA: 4EAD01AA      JSR        426(A5)                        ; JT[426]
22FE: 3D7C007FFFFA  MOVE.W     #$007F,-6(A6)
2304: 486EFFDC      PEA        -36(A6)
2308: 4EAD02FA      JSR        762(A5)                        ; JT[762]
230C: 4FEF000C      LEA        12(A7),A7
2310: 3B7CFFEFEFB0  MOVE.W     #$FFEF,-4176(A5)
2316: 2B6C0006EFDE  MOVE.L     6(A4),-4130(A5)
231C: 600001CC      BRA.W      $24EC
2320: 4A6DD9AE      TST.W      -9810(A5)
2324: 660000CA      BNE.W      $23F2
2328: 7011          MOVEQ      #17,D0
232A: C1EEFFCE      ANDA.L     -50(A6),A0
232E: D08D          MOVE.B     A5,(A0)
2330: 306EFFCC      MOVEA.W    -52(A6),A0
2334: D1C07011      MOVE.B     D0,$7011.W
2338: C1EEFFCE      ANDA.L     -50(A6),A0
233C: D08D          MOVE.B     A5,(A0)
233E: 326EFFCC      MOVEA.W    -52(A6),A1
2342: D3C01028D88D  MOVE.B     D0,$1028D88D
2348: B029D76C      MOVE.W     -10388(A1),D0
234C: 67000088      BEQ.W      $23D8
2350: 7011          MOVEQ      #17,D0
2352: C1EEFFCE      ANDA.L     -50(A6),A0
2356: D08D          MOVE.B     A5,(A0)
2358: 306EFFCC      MOVEA.W    -52(A6),A0
235C: D1C01828      MOVE.B     D0,$1828.W
2360: D76C42A74267  MOVE.B     17063(A4),16999(A3)
2366: 3F2EFFCC      MOVE.W     -52(A6),-(A7)
236A: 3F2EFFCE      MOVE.W     -50(A6),-(A7)
236E: 4EBADD88      JSR        -8824(PC)
2372: 7000          MOVEQ      #0,D0
2374: 1004          MOVE.B     D4,D0
2376: 204D          MOVEA.L    A5,A0
2378: D1C04A28      MOVE.B     D0,$4A28.W
237C: FBD8          MOVE.W     (A0)+,???
237E: 4FEF000A      LEA        10(A7),A7
2382: 6A04          BPL.S      $2388
2384: 703F          MOVEQ      #63,D0
2386: 600C          BRA.S      $2394
2388: 1004          MOVE.B     D4,D0
238A: 4880          EXT.W      D0
238C: 3F00          MOVE.W     D0,-(A7)
238E: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
2392: 548F          MOVE.B     A7,(A2)
2394: 1800          MOVE.B     D0,D4
2396: 7E00          MOVEQ      #0,D7
2398: 6002          BRA.S      $239C
239A: 5247          MOVEA.B    D7,A1
239C: 204D          MOVEA.L    A5,A0
239E: 2007          MOVE.L     D7,D0
23A0: 48C0          EXT.L      D0
23A2: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
23A6: 4A68DE28      TST.W      -8664(A0)
23AA: 6700F878      BEQ.W      $1C26
23AE: 204D          MOVEA.L    A5,A0
23B0: 2007          MOVE.L     D7,D0
23B2: 48C0          EXT.L      D0
23B4: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
23B8: 4A68DE2A      TST.W      -8662(A0)
23BC: 67DC          BEQ.S      $239A
23BE: 204D          MOVEA.L    A5,A0
23C0: 2007          MOVE.L     D7,D0
23C2: 48C0          EXT.L      D0
23C4: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
23C8: 1004          MOVE.B     D4,D0
23CA: 4880          EXT.W      D0
23CC: B068DE28      MOVEA.W    -8664(A0),A0
23D0: 66C8          BNE.S      $239A
23D2: 6000F850      BRA.W      $1C26
23D6: 0C6D0004DE66  CMPI.W     #$0004,-8602(A5)
23DC: 6712          BEQ.S      $23F0
23DE: 4EAD043A      JSR        1082(A5)                       ; JT[1082]
23E2: 4EAD03FA      JSR        1018(A5)                       ; JT[1018]
23E6: 486DC366      PEA        -15514(A5)                     ; g_field_14
23EA: 4EAD02F2      JSR        754(A5)                        ; JT[754]
23EE: 588F          MOVE.B     A7,(A4)
23F0: 3F2EFFCC      MOVE.W     -52(A6),-(A7)
23F4: 3F2EFFCE      MOVE.W     -50(A6),-(A7)
23F8: 4EBA0172      JSR        370(PC)
23FC: 588F          MOVE.B     A7,(A4)
23FE: 600000CE      BRA.W      $24D0
2402: 486EFFD8      PEA        -40(A6)
2406: A972486EFFC6  MOVE.L     110(A2,D4.L),-58(A4)
240C: 486EFFC8      PEA        -56(A6)
2410: 486EFFD8      PEA        -40(A6)
2414: 4EAD03F2      JSR        1010(A5)                       ; JT[1010]
2418: 0C6E000FFFC8  CMPI.W     #$000F,-56(A6)
241E: 4FEF000C      LEA        12(A7),A7
2422: 6F08          BLE.S      $242C
2424: 3D7C000FFFC8  MOVE.W     #$000F,-56(A6)
242A: 600E          BRA.S      $243A
242C: 0C6E0001FFC8  CMPI.W     #$0001,-56(A6)
2432: 6C06          BGE.S      $243A
2434: 3D7C0001FFC8  MOVE.W     #$0001,-56(A6)
243A: 0C6E000FFFC6  CMPI.W     #$000F,-58(A6)
2440: 6F08          BLE.S      $244A
2442: 3D7C000FFFC6  MOVE.W     #$000F,-58(A6)
2448: 600E          BRA.S      $2458
244A: 0C6E0001FFC6  CMPI.W     #$0001,-58(A6)
2450: 6C06          BGE.S      $2458
2452: 3D7C0001FFC6  MOVE.W     #$0001,-58(A6)
2458: 302EFFC8      MOVE.W     -56(A6),D0
245C: B06EFFCE      MOVEA.W    -50(A6),A0
2460: 6624          BNE.S      $2486
2462: 302EFFC6      MOVE.W     -58(A6),D0
2466: B06EFFCC      MOVEA.W    -52(A6),A0
246A: 6F1A          BLE.S      $2486
246C: 4A6DDE4E      TST.W      -8626(A5)
2470: 6614          BNE.S      $2486
2472: 3B7C0001DE4E  MOVE.W     #$0001,-8626(A5)
2478: 3F2EFFCC      MOVE.W     -52(A6),-(A7)
247C: 3F2EFFCE      MOVE.W     -50(A6),-(A7)
2480: 4EAD03DA      JSR        986(A5)                        ; JT[986]
2484: 588F          MOVE.B     A7,(A4)
2486: 302EFFC6      MOVE.W     -58(A6),D0
248A: B06EFFCC      MOVEA.W    -52(A6),A0
248E: 6622          BNE.S      $24B2
2490: 302EFFC8      MOVE.W     -56(A6),D0
2494: B06EFFCE      MOVEA.W    -50(A6),A0
2498: 6F18          BLE.S      $24B2
249A: 4A6DDE4E      TST.W      -8626(A5)
249E: 6712          BEQ.S      $24B2
24A0: 426DDE4E      CLR.W      -8626(A5)
24A4: 3F2EFFCC      MOVE.W     -52(A6),-(A7)
24A8: 3F2EFFCE      MOVE.W     -50(A6),-(A7)
24AC: 4EAD03DA      JSR        986(A5)                        ; JT[986]
24B0: 588F          MOVE.B     A7,(A4)
24B2: 2F0C          MOVE.L     A4,-(A7)
24B4: 2F2E0008      MOVE.L     8(A6),-(A7)
24B8: 4EBA0C36      JSR        3126(PC)
24BC: 2D40FFD0      MOVE.L     D0,-48(A6)
24C0: 508F          MOVE.B     A7,(A0)
24C2: 6708          BEQ.S      $24CC
24C4: 2F2EFFD0      MOVE.L     -48(A6),-(A7)
24C8: A851          MOVEA.L    (A1),A4
24CA: 6002          BRA.S      $24CE
24CC: A850          MOVEA.L    (A0),A4
24CE: 4227          CLR.B      -(A7)
24D0: A9734A1F6600  MOVE.L     31(A3,D4.L*2),26112(A4)
24D6: FF2C6010      MOVE.W     24592(A4),-(A7)
24DA: 3F03          MOVE.W     D3,-(A7)
24DC: 4EAD0C6A      JSR        3178(A5)                       ; JT[3178]
24E0: 548F          MOVE.B     A7,(A2)
24E2: 4267          CLR.W      -(A7)
24E4: 3F07          MOVE.W     D7,-(A7)
24E6: 4EBAE0AC      JSR        -8020(PC)
24EA: 4CEE1CF8FF7A  MOVEM.L    -134(A6),D3/D4/D5/D6/D7/A2/A3/A4
24F0: 4E5E          UNLK       A6
24F2: 4E75          RTS        


; ======= Function at 0x24F4 =======
24F4: 4E56FFF8      LINK       A6,#-8                         ; frame=8
24F8: 2F07          MOVE.L     D7,-(A7)
24FA: 206DDE80      MOVEA.L    -8576(A5),A0
24FE: 2D68003EFFF8  MOVE.L     62(A0),-8(A6)
2504: 2D680042FFFC  MOVE.L     66(A0),-4(A6)
250A: 066E000DFFF8  ADDI.W     #$000D,-8(A6)
2510: 066E000EFFFA  ADDI.W     #$000E,-6(A6)
2516: 046E0010FFFE  SUBI.W     #$0010,-2(A6)
251C: 4227          CLR.B      -(A7)
251E: 2F2E000C      MOVE.L     12(A6),-(A7)
2522: 486EFFF8      PEA        -8(A6)
2526: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
252A: 6604          BNE.S      $2530
252C: 7000          MOVEQ      #0,D0
252E: 6036          BRA.S      $2566
2530: 3E2E000C      MOVE.W     12(A6),D7
2534: 9E6EFFF8      MOVEA.B    -8(A6),A7
2538: 48C7          EXT.L      D7
253A: 8FFC000CDE47  ORA.L      #$000CDE47,A7
2540: 302EFFFA      MOVE.W     -6(A6),D0
2544: D06EFFFE      MOVEA.B    -2(A6),A0
2548: 322E000E      MOVE.W     14(A6),D1
254C: D241          MOVEA.B    D1,A1
254E: B041          MOVEA.W    D1,A0
2550: 6C02          BGE.S      $2554
2552: 5247          MOVEA.B    D7,A1
2554: 206E0008      MOVEA.L    8(A6),A0
2558: 3087          MOVE.W     D7,(A0)
255A: 0C47FFEF      CMPI.W     #$FFEF,D7
255E: 6604          BNE.S      $2564
2560: 4EAD01A2      JSR        418(A5)                        ; JT[418]
2564: 7001          MOVEQ      #1,D0
2566: 2E1F          MOVE.L     (A7)+,D7
2568: 4E5E          UNLK       A6
256A: 4E75          RTS        


; ======= Function at 0x256C =======
256C: 4E560000      LINK       A6,#0
2570: 48E70700      MOVEM.L    D5/D6/D7,-(SP)                 ; save
2574: 3E2E0008      MOVE.W     8(A6),D7
2578: 3C2E000A      MOVE.W     10(A6),D6
257C: BE6DDE50      MOVEA.W    -8624(A5),A7
2580: 6606          BNE.S      $2588
2582: BC6DDE52      MOVEA.W    -8622(A5),A6
2586: 672A          BEQ.S      $25B2
2588: 3A2DDE50      MOVE.W     -8624(A5),D5                   ; A5-8624
258C: 3B47DE50      MOVE.W     D7,-8624(A5)
2590: 3E05          MOVE.W     D5,D7
2592: 3A2DDE52      MOVE.W     -8622(A5),D5                   ; A5-8622
2596: 3B46DE52      MOVE.W     D6,-8622(A5)
259A: 3C05          MOVE.W     D5,D6
259C: 3F06          MOVE.W     D6,-(A7)
259E: 3F07          MOVE.W     D7,-(A7)
25A0: 4EAD03DA      JSR        986(A5)                        ; JT[986]
25A4: 3EADDE52      MOVE.W     -8622(A5),(A7)                 ; A5-8622
25A8: 3F2DDE50      MOVE.W     -8624(A5),-(A7)                ; A5-8624
25AC: 4EAD03DA      JSR        986(A5)                        ; JT[986]
25B0: 5C8F          MOVE.B     A7,(A6)
25B2: 4CDF00E0      MOVEM.L    (SP)+,D5/D6/D7                 ; restore
25B6: 4E5E          UNLK       A6
25B8: 4E75          RTS        


; ======= Function at 0x25BA =======
25BA: 4E56FFE8      LINK       A6,#-24                        ; frame=24
25BE: 48E70718      MOVEM.L    D5/D6/D7/A3/A4,-(SP)           ; save
25C2: 202DDEC2      MOVE.L     -8510(A5),D0                   ; A5-8510
25C6: B0AE0008      MOVE.W     8(A6),(A0)
25CA: 6704          BEQ.S      $25D0
25CC: 4EAD01A2      JSR        418(A5)                        ; JT[418]
25D0: 42A7          CLR.L      -(A7)
25D2: A8D8          MOVE.L     (A0)+,(A4)+
25D4: 265F          MOVEA.L    (A7)+,A3
25D6: 206E0008      MOVEA.L    8(A6),A0
25DA: 2F280018      MOVE.L     24(A0),-(A7)
25DE: 2F0B          MOVE.L     A3,-(A7)
25E0: A8DC          MOVE.L     (A4)+,(A4)+
25E2: 2F3C00010001  MOVE.L     #$00010001,-(A7)
25E8: 486EFFF0      PEA        -16(A6)
25EC: 4EAD03EA      JSR        1002(A5)                       ; JT[1002]
25F0: 2EBC000F000F  MOVE.L     #$000F000F,(A7)
25F6: 486EFFE8      PEA        -24(A6)
25FA: 4EAD03EA      JSR        1002(A5)                       ; JT[1002]
25FE: 3D6EFFEEFFF6  MOVE.W     -18(A6),-10(A6)
2604: 3D6EFFECFFF4  MOVE.W     -20(A6),-12(A6)
260A: 4297          CLR.L      (A7)
260C: A8D8          MOVE.L     (A0)+,(A4)+
260E: 285F          MOVEA.L    (A7)+,A4
2610: 2E8C          MOVE.L     A4,(A7)
2612: 486EFFF0      PEA        -16(A6)
2616: A8DF          MOVE.L     (A7)+,(A4)+
2618: 2E8B          MOVE.L     A3,(A7)
261A: 2F0C          MOVE.L     A4,-(A7)
261C: 2F0B          MOVE.L     A3,-(A7)
261E: A8E6          MOVE.L     -(A6),(A4)+
2620: 4EBA0A7C      JSR        2684(PC)
2624: 4A40          TST.W      D0
2626: 6668          BNE.S      $2690
2628: 206DDE78      MOVEA.L    -8584(A5),A0
262C: 2050          MOVEA.L    (A0),A0
262E: 4A68030A      TST.W      778(A0)
2632: 6714          BEQ.S      $2648
2634: 2F0C          MOVE.L     A4,-(A7)
2636: 206DDE80      MOVEA.L    -8576(A5),A0
263A: 48680046      PEA        70(A0)
263E: A8DF          MOVE.L     (A7)+,(A4)+
2640: 2F0B          MOVE.L     A3,-(A7)
2642: 2F0C          MOVE.L     A4,-(A7)
2644: 2F0B          MOVE.L     A3,-(A7)
2646: A8E6          MOVE.L     -(A6),(A4)+
2648: 2F0C          MOVE.L     A4,-(A7)
264A: 206DDE80      MOVEA.L    -8576(A5),A0
264E: 4868003E      PEA        62(A0)
2652: A8DF          MOVE.L     (A7)+,(A4)+
2654: 2F0B          MOVE.L     A3,-(A7)
2656: 2F0C          MOVE.L     A4,-(A7)
2658: 2F0B          MOVE.L     A3,-(A7)
265A: A8E6          MOVE.L     -(A6),(A4)+
265C: 206DDE78      MOVEA.L    -8584(A5),A0
2660: 2050          MOVEA.L    (A0),A0
2662: 4A68030E      TST.W      782(A0)
2666: 6714          BEQ.S      $267C
2668: 2F0C          MOVE.L     A4,-(A7)
266A: 206DDE80      MOVEA.L    -8576(A5),A0
266E: 4868004E      PEA        78(A0)
2672: A8DF          MOVE.L     (A7)+,(A4)+
2674: 2F0B          MOVE.L     A3,-(A7)
2676: 2F0C          MOVE.L     A4,-(A7)
2678: 2F0B          MOVE.L     A3,-(A7)
267A: A8E6          MOVE.L     -(A6),(A4)+
267C: 2F0B          MOVE.L     A3,-(A7)
267E: A8D4          MOVE.L     (A4),(A4)+
2680: 2F0B          MOVE.L     A3,-(A7)
2682: A8D9          MOVE.L     (A1)+,(A4)+
2684: 4EBA01E4      JSR        484(PC)
2688: 4EBAECB0      JSR        -4944(PC)
268C: 60000192      BRA.W      $2822
2690: 2F0B          MOVE.L     A3,-(A7)
2692: A8D4          MOVE.L     (A4),(A4)+
2694: 2F0B          MOVE.L     A3,-(A7)
2696: A8D9          MOVE.L     (A1)+,(A4)+
2698: 3F3C0003      MOVE.W     #$0003,-(A7)
269C: A887          MOVE.L     D7,(A4)
269E: 3F3C000C      MOVE.W     #$000C,-(A7)
26A2: A88A          MOVE.L     A2,(A4)
26A4: 4267          CLR.W      -(A7)
26A6: A889          MOVE.L     A1,(A4)
26A8: 4267          CLR.W      -(A7)
26AA: A888          MOVE.L     A0,(A4)
26AC: 486EFFF8      PEA        -8(A6)
26B0: A88B          MOVE.L     A3,(A4)
26B2: 7E03          MOVEQ      #3,D7
26B4: CFEEFFFE      ANDA.L     -2(A6),A7
26B8: 3C07          MOVE.W     D7,D6
26BA: DC46          MOVEA.B    D6,A6
26BC: 3A2EFFFA      MOVE.W     -6(A6),D5
26C0: DA6EFFF8      MOVEA.B    -8(A6),A5
26C4: DA6EFFFE      MOVEA.B    -2(A6),A5
26C8: DA46          MOVEA.B    D6,A5
26CA: 206DDE80      MOVEA.L    -8576(A5),A0
26CE: 3B680040EFB4  MOVE.W     64(A0),-4172(A5)
26D4: 3B68003EEFB2  MOVE.W     62(A0),-4174(A5)
26DA: 302DEFB2      MOVE.W     -4174(A5),D0                   ; A5-4174
26DE: D045          MOVEA.B    D5,A0
26E0: 9047          MOVEA.B    D7,A0
26E2: 3B40EFB6      MOVE.W     D0,-4170(A5)
26E6: 4267          CLR.W      -(A7)
26E8: 486DF112      PEA        -3822(A5)                      ; A5-3822
26EC: A88C          MOVE.L     A4,(A4)
26EE: 302DEFB4      MOVE.W     -4172(A5),D0                   ; A5-4172
26F2: D05F          MOVEA.B    (A7)+,A0
26F4: D046          MOVEA.B    D6,A0
26F6: 3B40EFB8      MOVE.W     D0,-4168(A5)
26FA: 486DEFB2      PEA        -4174(A5)                      ; A5-4174
26FE: A8A1          MOVE.L     -(A1),(A4)
2700: 206DDE80      MOVEA.L    -8576(A5),A0
2704: 30280040      MOVE.W     64(A0),D0
2708: D047          MOVEA.B    D7,A0
270A: 3F00          MOVE.W     D0,-(A7)
270C: 3028003E      MOVE.W     62(A0),D0
2710: D06EFFF8      MOVEA.B    -8(A6),A0
2714: D047          MOVEA.B    D7,A0
2716: 3F00          MOVE.W     D0,-(A7)
2718: A893          MOVE.L     (A3),(A4)
271A: 486DF116      PEA        -3818(A5)                      ; A5-3818
271E: A884          MOVE.L     D4,(A4)
2720: 2B6DEFB2EFBA  MOVE.L     -4174(A5),-4166(A5)            ; A5-4174
2726: 2B6DEFB6EFBE  MOVE.L     -4170(A5),-4162(A5)            ; A5-4170
272C: DB6DEFBADB6D  MOVE.B     -4166(A5),-9363(A5)            ; A5-4166
2732: EFBE486D      MOVE.L     ???,109(A7,D4.L)
2736: EFBAA8A1206D  MOVE.L     -22367(PC),109(A7,D2.W)
273C: DE80          MOVE.B     D0,(A7)
273E: 30280040      MOVE.W     64(A0),D0
2742: D047          MOVEA.B    D7,A0
2744: 3F00          MOVE.W     D0,-(A7)
2746: 3028003E      MOVE.W     62(A0),D0
274A: D06EFFF8      MOVEA.B    -8(A6),A0
274E: D045          MOVEA.B    D5,A0
2750: D047          MOVEA.B    D7,A0
2752: 3F00          MOVE.W     D0,-(A7)
2754: A893          MOVE.L     (A3),(A4)
2756: 486DF11A      PEA        -3814(A5)                      ; A5-3814
275A: A884          MOVE.L     D4,(A4)
275C: 2B6DEFBAEFC2  MOVE.L     -4166(A5),-4158(A5)            ; A5-4166
2762: 2B6DEFBEEFC6  MOVE.L     -4162(A5),-4154(A5)            ; A5-4162
2768: DB6DEFC2DB6D  MOVE.B     -4158(A5),-9363(A5)            ; A5-4158
276E: EFC6          MOVE.L     D6,???
2770: 486DEFC2      PEA        -4158(A5)                      ; A5-4158
2774: A8A1          MOVE.L     -(A1),(A4)
2776: 206DDE80      MOVEA.L    -8576(A5),A0
277A: 30280040      MOVE.W     64(A0),D0
277E: D047          MOVEA.B    D7,A0
2780: 3F00          MOVE.W     D0,-(A7)
2782: 3028003E      MOVE.W     62(A0),D0
2786: D06EFFF8      MOVEA.B    -8(A6),A0
278A: 3205          MOVE.W     D5,D1
278C: D241          MOVEA.B    D1,A1
278E: D041          MOVEA.B    D1,A0
2790: D047          MOVEA.B    D7,A0
2792: 3F00          MOVE.W     D0,-(A7)
2794: A893          MOVE.L     (A3),(A4)
2796: 486DF11E      PEA        -3810(A5)                      ; A5-3810
279A: A884          MOVE.L     D4,(A4)
279C: 2B6DEFC2EFCA  MOVE.L     -4158(A5),-4150(A5)            ; A5-4158
27A2: 2B6DEFC6EFCE  MOVE.L     -4154(A5),-4146(A5)            ; A5-4154
27A8: DB6DEFCADB6D  MOVE.B     -4150(A5),-9363(A5)            ; A5-4150
27AE: EFCE          MOVE.L     A6,???
27B0: 486DEFCA      PEA        -4150(A5)                      ; A5-4150
27B4: A8A1          MOVE.L     -(A1),(A4)
27B6: 206DDE80      MOVEA.L    -8576(A5),A0
27BA: 30280040      MOVE.W     64(A0),D0
27BE: D047          MOVEA.B    D7,A0
27C0: 3F00          MOVE.W     D0,-(A7)
27C2: 3028003E      MOVE.W     62(A0),D0
27C6: D06EFFF8      MOVEA.B    -8(A6),A0
27CA: 7203          MOVEQ      #3,D1
27CC: C3C5          ANDA.L     D5,A1
27CE: D041          MOVEA.B    D1,A0
27D0: D047          MOVEA.B    D7,A0
27D2: 3F00          MOVE.W     D0,-(A7)
27D4: A893          MOVE.L     (A3),(A4)
27D6: 486DF122      PEA        -3806(A5)                      ; A5-3806
27DA: A884          MOVE.L     D4,(A4)
27DC: 2B6DEFCAEFD2  MOVE.L     -4150(A5),-4142(A5)            ; A5-4150
27E2: 2B6DEFCEEFD6  MOVE.L     -4146(A5),-4138(A5)            ; A5-4146
27E8: DB6DEFD2DB6D  MOVE.B     -4142(A5),-9363(A5)            ; A5-4142
27EE: EFD6          MOVE.L     (A6),???
27F0: 486DEFD2      PEA        -4142(A5)                      ; A5-4142
27F4: A8A1          MOVE.L     -(A1),(A4)
27F6: 206DDE80      MOVEA.L    -8576(A5),A0
27FA: 30280040      MOVE.W     64(A0),D0
27FE: D047          MOVEA.B    D7,A0
2800: 3F00          MOVE.W     D0,-(A7)
2802: 3028003E      MOVE.W     62(A0),D0
2806: D06EFFF8      MOVEA.B    -8(A6),A0
280A: 3205          MOVE.W     D5,D1
280C: E549D041      MOVE.L     A1,-12223(A2)
2810: D047          MOVEA.B    D7,A0
2812: 3F00          MOVE.W     D0,-(A7)
2814: A893          MOVE.L     (A3),(A4)
2816: 486DF126      PEA        -3802(A5)                      ; A5-3802
281A: A884          MOVE.L     D4,(A4)
281C: 4EAD03D2      JSR        978(A5)                        ; JT[978]
2820: 2F0C          MOVE.L     A4,-(A7)
2822: A8D9          MOVE.L     (A1)+,(A4)+
2824: 4EBA0A90      JSR        2704(PC)
2828: 2F3C00030003  MOVE.L     #$00030003,-(A7)
282E: A89B          MOVE.L     (A3)+,(A4)
2830: 206DDE80      MOVEA.L    -8576(A5),A0
2834: 4868001A      PEA        26(A0)
2838: 2F3CFFFCFFFC  MOVE.L     #$FFFCFFFC,-(A7)
283E: A8A9206D      MOVE.L     8301(A1),(A4)
2842: DE80          MOVE.B     D0,(A7)
2844: 4868001A      PEA        26(A0)
2848: 2F3C00100010  MOVE.L     #$00100010,-(A7)
284E: A8B0206D      MOVE.L     109(A0,D2.W),(A4)
2852: DE80          MOVE.B     D0,(A7)
2854: 4868001A      PEA        26(A0)
2858: 2F3C00040004  MOVE.L     #$00040004,-(A7)
285E: A8A9A89E      MOVE.L     -22370(A1),(A4)
2862: 4CDF18E0      MOVEM.L    (SP)+,D5/D6/D7/A3/A4           ; restore
2866: 4E5E          UNLK       A6
2868: 4E75          RTS        


; ======= Function at 0x286A =======
286A: 4E56FFF2      LINK       A6,#-14                        ; frame=14
286E: 4EBA0048      JSR        72(PC)
2872: 48787FFF      PEA        $7FFF.W
2876: 4EBAE4A8      JSR        -7000(PC)
287A: 4EAD03D2      JSR        978(A5)                        ; JT[978]
287E: 4EBA0BBC      JSR        3004(PC)
2882: 4EBAE310      JSR        -7408(PC)
2886: 4EAD0932      JSR        2354(A5)                       ; JT[2354]
288A: 4A40          TST.W      D0
288C: 588F          MOVE.B     A7,(A4)
288E: 671A          BEQ.S      $28AA
2890: 4A6DDE28      TST.W      -8664(A5)
2894: 6714          BEQ.S      $28AA
2896: 206DDE80      MOVEA.L    -8576(A5),A0
289A: 48680012      PEA        18(A0)
289E: 42A7          CLR.L      -(A7)
28A0: 3F3C00B6      MOVE.W     #$00B6,-(A7)
28A4: A9BBA94B600A  MOVE.L     75(PC,A2.L),10(A4,D6.W)
28AA: 206DDE80      MOVEA.L    -8576(A5),A0
28AE: 48680012      PEA        18(A0)
28B2: A8A3          MOVE.L     -(A3),(A4)
28B4: 4E5E          UNLK       A6
28B6: 4E75          RTS        


; ======= Function at 0x28B8 =======
28B8: 4E56FFF0      LINK       A6,#-16                        ; frame=16
28BC: 2F07          MOVE.L     D7,-(A7)
28BE: 4A6DD9AE      TST.W      -9810(A5)
28C2: 6648          BNE.S      $290C
28C4: 486EFFF8      PEA        -8(A6)
28C8: 4267          CLR.W      -(A7)
28CA: 4EBA01AE      JSR        430(PC)
28CE: 486EFFF0      PEA        -16(A6)
28D2: 3F3C0006      MOVE.W     #$0006,-(A7)
28D6: 4EBA01A2      JSR        418(PC)
28DA: 3D6EFFF6FFFE  MOVE.W     -10(A6),-2(A6)
28E0: 4217          CLR.B      (A7)
28E2: 486EFFF8      PEA        -8(A6)
28E6: 206DDEC2      MOVEA.L    -8510(A5),A0
28EA: 2F280018      MOVE.L     24(A0),-(A7)
28EE: A8E94A1F      MOVE.L     18975(A1),(A4)+
28F2: 4FEF000A      LEA        10(A7),A7
28F6: 6714          BEQ.S      $290C
28F8: 7E00          MOVEQ      #0,D7
28FA: 600A          BRA.S      $2906
28FC: 3F07          MOVE.W     D7,-(A7)
28FE: 4EBA01D6      JSR        470(PC)
2902: 548F          MOVE.B     A7,(A2)
2904: 5247          MOVEA.B    D7,A1
2906: 0C470007      CMPI.W     #$0007,D7
290A: 6DF0          BLT.S      $28FC
290C: 2E1F          MOVE.L     (A7)+,D7
290E: 4E5E          UNLK       A6
2910: 4E75          RTS        


; ======= Function at 0x2912 =======
2912: 4E56FFDA      LINK       A6,#-38                        ; frame=38
2916: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
291A: 3B7C0001D9AE  MOVE.W     #$0001,-9810(A5)
2920: 7E00          MOVEQ      #0,D7
2922: 49EDDE28      LEA        -8664(A5),A4                   ; g_flag1
2926: 6018          BRA.S      $2940
2928: 3F14          MOVE.W     (A4),-(A7)
292A: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
292E: 1D8070E2      MOVE.B     D0,-30(A6,D7.W)
2932: 4254          CLR.W      (A4)
2934: 3E87          MOVE.W     D7,(A7)
2936: 4EBA019E      JSR        414(PC)
293A: 548F          MOVE.B     A7,(A2)
293C: 5247          MOVEA.B    D7,A1
293E: 588C          MOVE.B     A4,(A4)
2940: 0C470008      CMPI.W     #$0008,D7
2944: 65E2          BCS.S      $2928
2946: 423670E2      CLR.B      -30(A6,D7.W)
294A: 206DDEC2      MOVEA.L    -8510(A5),A0
294E: 286800A0      MOVEA.L    160(A0),A4
2952: 3F3C0003      MOVE.W     #$0003,-(A7)
2956: A887          MOVE.L     D7,(A4)
2958: 3F3C0001      MOVE.W     #$0001,-(A7)
295C: A888          MOVE.L     A0,(A4)
295E: 206DDE80      MOVEA.L    -8576(A5),A0
2962: 3F28000C      MOVE.W     12(A0),-(A7)
2966: A88A          MOVE.L     A2,(A4)
2968: 486EFFDA      PEA        -38(A6)
296C: A88B          MOVE.L     A3,(A4)
296E: 2054          MOVEA.L    (A4),A0
2970: 317C0003004A  MOVE.W     #$0003,74(A0)
2976: 2054          MOVEA.L    (A4),A0
2978: 117C0001004C  MOVE.B     #$01,76(A0)
297E: 206DDE80      MOVEA.L    -8576(A5),A0
2982: 2254          MOVEA.L    (A4),A1
2984: 3368000C0050  MOVE.W     12(A0),80(A1)
298A: 302EFFDA      MOVE.W     -38(A6),D0
298E: D06EFFDC      MOVEA.B    -36(A6),A0
2992: D06EFFE0      MOVEA.B    -32(A6),A0
2996: 2054          MOVEA.L    (A4),A0
2998: 31400018      MOVE.W     D0,24(A0)
299C: 2054          MOVEA.L    (A4),A0
299E: 316EFFDA001A  MOVE.W     -38(A6),26(A0)
29A4: 2054          MOVEA.L    (A4),A0
29A6: 4228004C      CLR.B      76(A0)
29AA: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
29AE: 3F3C0003      MOVE.W     #$0003,-(A7)
29B2: A828486E      MOVE.L     18542(A0),D4
29B6: FFE2          MOVE.W     -(A2),???
29B8: 3F3C0003      MOVE.W     #$0003,-(A7)
29BC: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
29C0: 4EAD063A      JSR        1594(A5)                       ; JT[1594]
29C4: 2EADDEC2      MOVE.L     -8510(A5),(A7)                 ; A5-8510
29C8: 48780003      PEA        $0003.W
29CC: 3F3C7FFF      MOVE.W     #$7FFF,-(A7)
29D0: A97E2EAD      MOVE.L     ???,11949(A4)
29D4: DEC2          MOVE.B     D2,(A7)+
29D6: 486DF12A      PEA        -3798(A5)                      ; A5-3798
29DA: A91A          MOVE.L     (A2)+,-(A4)
29DC: 4EAD0292      JSR        658(A5)                        ; JT[658]
29E0: 4EBAFE88      JSR        -376(PC)
29E4: 4CEE1080FFD2  MOVEM.L    -46(A6),D7/A4
29EA: 4E5E          UNLK       A6
29EC: 4E75          RTS        

29EE: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
29F2: A873206D      MOVEA.L    109(A3,D2.W),A4
29F6: DE80          MOVE.B     D0,(A7)
29F8: 48680012      PEA        18(A0)
29FC: A9284E75      MOVE.L     20085(A0),-(A4)

; ======= Function at 0x2A00 =======
2A00: 4E560000      LINK       A6,#0
2A04: 2F2E000A      MOVE.L     10(A6),-(A7)
2A08: 3F3C7FFF      MOVE.W     #$7FFF,-(A7)
2A0C: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
2A10: 4EAD0152      JSR        338(A5)                        ; JT[338]
2A14: 4E5E          UNLK       A6
2A16: 4E75          RTS        


; ======= Function at 0x2A18 =======
2A18: 4E56FEFE      LINK       A6,#-258                       ; frame=258
2A1C: 486EFEFE      PEA        -258(A6)
2A20: 3F3C0003      MOVE.W     #$0003,-(A7)
2A24: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
2A28: 4EAD0642      JSR        1602(A5)                       ; JT[1602]
2A2C: 486EFEFE      PEA        -258(A6)
2A30: 4EBADBC8      JSR        -9272(PC)
2A34: 4E5E          UNLK       A6
2A36: 4E75          RTS        


; ======= Function at 0x2A38 =======
2A38: 4E560000      LINK       A6,#0
2A3C: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
2A40: 7E00          MOVEQ      #0,D7
2A42: 49EDDE28      LEA        -8664(A5),A4                   ; g_flag1
2A46: 6024          BRA.S      $2A6C
2A48: 2F2E000C      MOVE.L     12(A6),-(A7)
2A4C: 3F07          MOVE.W     D7,-(A7)
2A4E: 4EBA002A      JSR        42(PC)
2A52: 4217          CLR.B      (A7)
2A54: 2F2E0008      MOVE.L     8(A6),-(A7)
2A58: 2F2E000C      MOVE.L     12(A6),-(A7)
2A5C: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
2A60: 588F          MOVE.B     A7,(A4)
2A62: 6704          BEQ.S      $2A68
2A64: 3007          MOVE.W     D7,D0
2A66: 600A          BRA.S      $2A72
2A68: 5247          MOVEA.B    D7,A1
2A6A: 588C          MOVE.B     A4,(A4)
2A6C: 4A54          TST.W      (A4)
2A6E: 66D8          BNE.S      $2A48
2A70: 70FF          MOVEQ      #-1,D0
2A72: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
2A76: 4E5E          UNLK       A6
2A78: 4E75          RTS        


; ======= Function at 0x2A7A =======
2A7A: 4E560000      LINK       A6,#0
2A7E: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
2A82: 266E000A      MOVEA.L    10(A6),A3
2A86: 49EB0002      LEA        2(A3),A4
2A8A: 206DDE80      MOVEA.L    -8576(A5),A0
2A8E: 38A80006      MOVE.W     6(A0),(A4)
2A92: 206DDE80      MOVEA.L    -8576(A5),A0
2A96: 30280004      MOVE.W     4(A0),D0
2A9A: D054          MOVEA.B    (A4),A0
2A9C: 5240          MOVEA.B    D0,A1
2A9E: 37400006      MOVE.W     D0,6(A3)
2AA2: 206DDE80      MOVEA.L    -8576(A5),A0
2AA6: 36A80008      MOVE.W     8(A0),(A3)
2AAA: 206DDE80      MOVEA.L    -8576(A5),A0
2AAE: 30280004      MOVE.W     4(A0),D0
2AB2: D053          MOVEA.B    (A3),A0
2AB4: 5240          MOVEA.B    D0,A1
2AB6: 37400004      MOVE.W     D0,4(A3)
2ABA: 2F0B          MOVE.L     A3,-(A7)
2ABC: 206DDE80      MOVEA.L    -8576(A5),A0
2AC0: 30280002      MOVE.W     2(A0),D0
2AC4: C1EE0008      ANDA.L     8(A6),A0
2AC8: 3F00          MOVE.W     D0,-(A7)
2ACA: 4267          CLR.W      -(A7)
2ACC: A8A84CDF      MOVE.L     19679(A0),(A4)
2AD0: 1800          MOVE.B     D0,D4
2AD2: 4E5E          UNLK       A6
2AD4: 4E75          RTS        


; ======= Function at 0x2AD6 =======
2AD6: 4E56FFF0      LINK       A6,#-16                        ; frame=16
2ADA: 48E70708      MOVEM.L    D5/D6/D7/A4,-(SP)              ; save
2ADE: 3E2E0008      MOVE.W     8(A6),D7
2AE2: 4A47          TST.W      D7
2AE4: 6D06          BLT.S      $2AEC
2AE6: 0C470008      CMPI.W     #$0008,D7
2AEA: 6504          BCS.S      $2AF0
2AEC: 4EAD01A2      JSR        418(A5)                        ; JT[418]
2AF0: 0C470007      CMPI.W     #$0007,D7
2AF4: 6C0001F2      BGE.W      $2CEA
2AF8: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
2AFC: A873486E      MOVEA.L    110(A3,D4.L),A4
2B00: FFF83F07      MOVE.W     $3F07.W,???
2B04: 4EBAFF74      JSR        -140(PC)
2B08: 4A6DD9AE      TST.W      -9810(A5)
2B0C: 5C8F          MOVE.B     A7,(A6)
2B0E: 6610          BNE.S      $2B20
2B10: 204D          MOVEA.L    A5,A0
2B12: 2007          MOVE.L     D7,D0
2B14: 48C0          EXT.L      D0
2B16: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
2B1A: 4A68DE28      TST.W      -8664(A0)
2B1E: 660A          BNE.S      $2B2A
2B20: 486EFFF8      PEA        -8(A6)
2B24: A8A3          MOVE.L     -(A3),(A4)
2B26: 600001C0      BRA.W      $2CEA
2B2A: 4A2DF269      TST.B      -3479(A5)
2B2E: 6714          BEQ.S      $2B44
2B30: 3F3C0002      MOVE.W     #$0002,-(A7)
2B34: AA98          MOVE.L     (A0)+,(A5)
2B36: 486EFFF8      PEA        -8(A6)
2B3A: A8A3          MOVE.L     -(A3),(A4)
2B3C: 4878001E      PEA        $001E.W
2B40: A863          MOVEA.L    -(A3),A4
2B42: 6006          BRA.S      $2B4A
2B44: 486EFFF8      PEA        -8(A6)
2B48: A8A3          MOVE.L     -(A3),(A4)
2B4A: 70FF          MOVEQ      #-1,D0
2B4C: D06EFFFE      MOVEA.B    -2(A6),A0
2B50: 3F00          MOVE.W     D0,-(A7)
2B52: 7001          MOVEQ      #1,D0
2B54: D06EFFF8      MOVEA.B    -8(A6),A0
2B58: 3F00          MOVE.W     D0,-(A7)
2B5A: A893          MOVE.L     (A3),(A4)
2B5C: 70FF          MOVEQ      #-1,D0
2B5E: D06EFFFE      MOVEA.B    -2(A6),A0
2B62: 3F00          MOVE.W     D0,-(A7)
2B64: 70FF          MOVEQ      #-1,D0
2B66: D06EFFFC      MOVEA.B    -4(A6),A0
2B6A: 3F00          MOVE.W     D0,-(A7)
2B6C: A891          MOVE.L     (A1),(A4)
2B6E: 7001          MOVEQ      #1,D0
2B70: D06EFFFA      MOVEA.B    -6(A6),A0
2B74: 3F00          MOVE.W     D0,-(A7)
2B76: 70FF          MOVEQ      #-1,D0
2B78: D06EFFFC      MOVEA.B    -4(A6),A0
2B7C: 3F00          MOVE.W     D0,-(A7)
2B7E: A891          MOVE.L     (A1),(A4)
2B80: 536EFFFE536E  MOVE.B     -2(A6),21358(A1)
2B86: FFFC486E      MOVE.W     #$486E,???
2B8A: FFF8A8A1      MOVE.W     $A8A1.W,???
2B8E: 2007          MOVE.L     D7,D0
2B90: 48C0          EXT.L      D0
2B92: E58849ED      MOVE.L     A0,-19(A2,D4.L)
2B96: DE28D08C      MOVE.B     -12148(A0),D7
2B9A: 2840          MOVEA.L    D0,A4
2B9C: 3F14          MOVE.W     (A4),-(A7)
2B9E: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
2BA2: 3E00          MOVE.W     D0,D7
2BA4: 0C54003F      CMPI.W     #$003F,(A4)
2BA8: 548F          MOVE.B     A7,(A2)
2BAA: 6604          BNE.S      $2BB0
2BAC: 7000          MOVEQ      #0,D0
2BAE: 600E          BRA.S      $2BBE
2BB0: 3F07          MOVE.W     D7,-(A7)
2BB2: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
2BB6: 3E80          MOVE.W     D0,(A7)
2BB8: 4EAD090A      JSR        2314(A5)                       ; JT[2314]
2BBC: 548F          MOVE.B     A7,(A2)
2BBE: 3C00          MOVE.W     D0,D6
2BC0: 3F3C0003      MOVE.W     #$0003,-(A7)
2BC4: A887          MOVE.L     D7,(A4)
2BC6: 206DDE80      MOVEA.L    -8576(A5),A0
2BCA: 3F28000C      MOVE.W     12(A0),-(A7)
2BCE: A88A          MOVE.L     A2,(A4)
2BD0: 3F3C0001      MOVE.W     #$0001,-(A7)
2BD4: A888          MOVE.L     A0,(A4)
2BD6: 3F3C0001      MOVE.W     #$0001,-(A7)
2BDA: A889          MOVE.L     A1,(A4)
2BDC: 4267          CLR.W      -(A7)
2BDE: 3F07          MOVE.W     D7,-(A7)
2BE0: A88D          MOVE.L     A5,(A4)
2BE2: 3A1F          MOVE.W     (A7)+,D5
2BE4: 486EFFF0      PEA        -16(A6)
2BE8: A88B          MOVE.L     A3,(A4)
2BEA: 302EFFFA      MOVE.W     -6(A6),D0
2BEE: D06EFFFE      MOVEA.B    -2(A6),A0
2BF2: 9045          MOVEA.B    D5,A0
2BF4: 48C0          EXT.L      D0
2BF6: 81FC00025540  ORA.L      #$00025540,A0
2BFC: 3F00          MOVE.W     D0,-(A7)
2BFE: 302EFFFC      MOVE.W     -4(A6),D0
2C02: D06EFFF8      MOVEA.B    -8(A6),A0
2C06: 306EFFF0      MOVEA.W    -16(A6),A0
2C0A: 5340D0C0      MOVE.B     D0,-12096(A1)
2C0E: 2008          MOVE.L     A0,D0
2C10: 81FC00025340  ORA.L      #$00025340,A0
2C16: 3F00          MOVE.W     D0,-(A7)
2C18: A893          MOVE.L     (A3),(A4)
2C1A: 0C47005A      CMPI.W     #$005A,D7
2C1E: 660A          BNE.S      $2C2A
2C20: 2F3C0000FFFF  MOVE.L     #$0000FFFF,-(A7)
2C26: A894          MOVE.L     (A4),(A4)
2C28: 601C          BRA.S      $2C46
2C2A: 0C470051      CMPI.W     #$0051,D7
2C2E: 660A          BNE.S      $2C3A
2C30: 2F3C0000FFFE  MOVE.L     #$0000FFFE,-(A7)
2C36: A894          MOVE.L     (A4),(A4)
2C38: 600C          BRA.S      $2C46
2C3A: 0C470057      CMPI.W     #$0057,D7
2C3E: 6606          BNE.S      $2C46
2C40: 48780001      PEA        $0001.W
2C44: A894          MOVE.L     (A4),(A4)
2C46: 3F07          MOVE.W     D7,-(A7)
2C48: A883          MOVE.L     D3,(A4)
2C4A: 3005          MOVE.W     D5,D0
2C4C: 4440          NEG.W      D0
2C4E: 3F00          MOVE.W     D0,-(A7)
2C50: 3F3CFFFF      MOVE.W     #$FFFF,-(A7)
2C54: A894          MOVE.L     (A4),(A4)
2C56: 3F07          MOVE.W     D7,-(A7)
2C58: A883          MOVE.L     D3,(A4)
2C5A: 3F3C0009      MOVE.W     #$0009,-(A7)
2C5E: A88A          MOVE.L     A2,(A4)
2C60: 4267          CLR.W      -(A7)
2C62: A888          MOVE.L     A0,(A4)
2C64: 0C46000A      CMPI.W     #$000A,D6
2C68: 6628          BNE.S      $2C92
2C6A: 70F6          MOVEQ      #-10,D0
2C6C: D06EFFFE      MOVEA.B    -2(A6),A0
2C70: 3F00          MOVE.W     D0,-(A7)
2C72: 70FE          MOVEQ      #-2,D0
2C74: D06EFFFC      MOVEA.B    -4(A6),A0
2C78: 3F00          MOVE.W     D0,-(A7)
2C7A: A893          MOVE.L     (A3),(A4)
2C7C: 3F3C0031      MOVE.W     #$0031,-(A7)
2C80: A883          MOVE.L     D3,(A4)
2C82: 2F3C0000FFFE  MOVE.L     #$0000FFFE,-(A7)
2C88: A894          MOVE.L     (A4),(A4)
2C8A: 3F3C0030      MOVE.W     #$0030,-(A7)
2C8E: A883          MOVE.L     D3,(A4)
2C90: 6032          BRA.S      $2CC4
2C92: 0C46000A      CMPI.W     #$000A,D6
2C96: 6C04          BGE.S      $2C9C
2C98: 4A46          TST.W      D6
2C9A: 6C04          BGE.S      $2CA0
2C9C: 4EAD01A2      JSR        418(A5)                        ; JT[418]
2CA0: 7E30          MOVEQ      #48,D7
2CA2: DE46          MOVEA.B    D6,A7
2CA4: 4267          CLR.W      -(A7)
2CA6: 3F07          MOVE.W     D7,-(A7)
2CA8: A88D          MOVE.L     A5,(A4)
2CAA: 3A1F          MOVE.W     (A7)+,D5
2CAC: 302EFFFE      MOVE.W     -2(A6),D0
2CB0: 9045          MOVEA.B    D5,A0
2CB2: 55403F00      MOVE.B     D0,16128(A2)
2CB6: 70FE          MOVEQ      #-2,D0
2CB8: D06EFFFC      MOVEA.B    -4(A6),A0
2CBC: 3F00          MOVE.W     D0,-(A7)
2CBE: A893          MOVE.L     (A3),(A4)
2CC0: 3F07          MOVE.W     D7,-(A7)
2CC2: A883          MOVE.L     D3,(A4)
2CC4: 4A6C0002      TST.W      2(A4)
2CC8: 671E          BEQ.S      $2CE8
2CCA: 486DFAB2      PEA        -1358(A5)                      ; A5-1358
2CCE: A89D          MOVE.L     (A5)+,(A4)
2CD0: 3F3C000B      MOVE.W     #$000B,-(A7)
2CD4: A89C          MOVE.L     (A4)+,(A4)
2CD6: 486EFFF8      PEA        -8(A6)
2CDA: A8A2          MOVE.L     -(A2),(A4)
2CDC: 486DFABA      PEA        -1350(A5)                      ; A5-1350
2CE0: A89D          MOVE.L     (A5)+,(A4)
2CE2: 3F3C0008      MOVE.W     #$0008,-(A7)
2CE6: A89C          MOVE.L     (A4)+,(A4)
2CE8: 4CDF10E0      MOVEM.L    (SP)+,D5/D6/D7/A4              ; restore
2CEC: 4E5E          UNLK       A6
2CEE: 4E75          RTS        


; ======= Function at 0x2CF0 =======
2CF0: 4E560000      LINK       A6,#0
2CF4: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
2CF8: 286E0008      MOVEA.L    8(A6),A4
2CFC: 7E00          MOVEQ      #0,D7
2CFE: 47EDDE28      LEA        -8664(A5),A3                   ; g_flag1
2D02: 600E          BRA.S      $2D12
2D04: 4A6B0002      TST.W      2(A3)
2D08: 6604          BNE.S      $2D0E
2D0A: 18EB0001      MOVE.B     1(A3),(A4)+
2D0E: 5247          MOVEA.B    D7,A1
2D10: 588B          MOVE.B     A3,(A4)
2D12: 4A53          TST.W      (A3)
2D14: 66EE          BNE.S      $2D04
2D16: 4214          CLR.B      (A4)
2D18: 202E0008      MOVE.L     8(A6),D0
2D1C: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
2D20: 4E5E          UNLK       A6
2D22: 4E75          RTS        


; ======= Function at 0x2D24 =======
2D24: 4E56FFF4      LINK       A6,#-12                        ; frame=12
2D28: 48E71F08      MOVEM.L    D3/D4/D5/D6/D7/A4,-(SP)        ; save
2D2C: 206E000C      MOVEA.L    12(A6),A0
2D30: 1A280005      MOVE.B     5(A0),D5
2D34: 0C6D0001D9AE  CMPI.W     #$0001,-9810(A5)
2D3A: 66000098      BNE.W      $2DD6
2D3E: 1005          MOVE.B     D5,D0
2D40: 4880          EXT.W      D0
2D42: 3F00          MOVE.W     D0,-(A7)
2D44: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
2D48: 1A00          MOVE.B     D0,D5
2D4A: 206E000C      MOVEA.L    12(A6),A0
2D4E: 08280000000E  BTST       #0,14(A0)
2D54: 548F          MOVE.B     A7,(A2)
2D56: 660002B2      BNE.W      $300C
2D5A: 7000          MOVEQ      #0,D0
2D5C: 1005          MOVE.B     D5,D0
2D5E: 204D          MOVEA.L    A5,A0
2D60: D1C01028      MOVE.B     D0,$1028.W
2D64: FBD8          MOVE.W     (A0)+,???
2D66: 020000C0      ANDI.B     #$00C0,D0
2D6A: 661A          BNE.S      $2D86
2D6C: 0C05003F      CMPI.B     #$003F,D5
2D70: 6714          BEQ.S      $2D86
2D72: 0C05001B      CMPI.B     #$001B,D5
2D76: 670E          BEQ.S      $2D86
2D78: 0C050008      CMPI.B     #$0008,D5
2D7C: 6708          BEQ.S      $2D86
2D7E: 0C050003      CMPI.B     #$0003,D5
2D82: 66000286      BNE.W      $300C
2D86: 206DDEC2      MOVEA.L    -8510(A5),A0
2D8A: 286800A0      MOVEA.L    160(A0),A4
2D8E: 0C05001B      CMPI.B     #$001B,D5
2D92: 6712          BEQ.S      $2DA6
2D94: 0C050008      CMPI.B     #$0008,D5
2D98: 6614          BNE.S      $2DAE
2D9A: 2054          MOVEA.L    (A4),A0
2D9C: 30280020      MOVE.W     32(A0),D0
2DA0: B0680022      MOVEA.W    34(A0),A0
2DA4: 6708          BEQ.S      $2DAE
2DA6: 2F0C          MOVE.L     A4,-(A7)
2DA8: A9D76000025E  MOVE.L     (A7),#$6000025E
2DAE: 0C050003      CMPI.B     #$0003,D5
2DB2: 6612          BNE.S      $2DC6
2DB4: 3F3C000A      MOVE.W     #$000A,-(A7)
2DB8: 2F2DDECA      MOVE.L     -8502(A5),-(A7)                ; A5-8502
2DBC: 4EAD01D2      JSR        466(A5)                        ; JT[466]
2DC0: 5C8F          MOVE.B     A7,(A6)
2DC2: 60000246      BRA.W      $300C
2DC6: 1005          MOVE.B     D5,D0
2DC8: 4880          EXT.W      D0
2DCA: 3F00          MOVE.W     D0,-(A7)
2DCC: 2F0C          MOVE.L     A4,-(A7)
2DCE: A9DC60000238  MOVE.L     (A4)+,#$60000238
2DD4: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
2DD8: B1EDC3766700  MOVE.W     -15498(A5),$6700.W             ; A5-15498
2DDE: 022C362DDE50  ANDI.B     #$362D,-8624(A4)
2DE4: 382DDE52      MOVE.W     -8622(A5),D4                   ; A5-8622
2DE8: 4A6DDE4E      TST.W      -8626(A5)
2DEC: 6704          BEQ.S      $2DF2
2DEE: 7001          MOVEQ      #1,D0
2DF0: 6002          BRA.S      $2DF4
2DF2: 7000          MOVEQ      #0,D0
2DF4: 3C00          MOVE.W     D0,D6
2DF6: 7E01          MOVEQ      #1,D7
2DF8: 9E46          MOVEA.B    D6,A7
2DFA: 7011          MOVEQ      #17,D0
2DFC: C1C3          ANDA.L     D3,A0
2DFE: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
2E02: D088          MOVE.B     A0,(A0)
2E04: 3044          MOVEA.W    D4,A0
2E06: 1D700800FFFF  MOVE.B     0(A0,D0.L),-1(A6)
2E0C: 1005          MOVE.B     D5,D0
2E0E: 4880          EXT.W      D0
2E10: 57400C40      MOVE.B     D0,3136(A3)
2E14: 001D6200      ORI.B      #$6200,(A5)+
2E18: 017243FA      BCHG       D0,-6(A2,D4.W*2)
2E1C: 01F8D040      BSET       D0,$D040.W
2E20: D2F10000      MOVE.B     0(A1,D0.W),(A1)+
2E24: 4ED1          JMP        (A1)
2E26: 0C430001      CMPI.W     #$0001,D3
2E2A: 6F0001D6      BLE.W      $3004
2E2E: 53436000      MOVE.B     D3,24576(A1)
2E32: 01D0          BSET       D0,(A0)
2E34: 7001          MOVEQ      #1,D0
2E36: D043          MOVEA.B    D3,A0
2E38: 0C400010      CMPI.W     #$0010,D0
2E3C: 6C0001C4      BGE.W      $3004
2E40: 5243          MOVEA.B    D3,A1
2E42: 600001BE      BRA.W      $3004
2E46: 0C440001      CMPI.W     #$0001,D4
2E4A: 6F0001B6      BLE.W      $3004
2E4E: 53446000      MOVE.B     D4,24576(A1)
2E52: 01B00C44      BCLR       D0,68(A0,D0.L*4)
2E56: 00016604      ORI.B      #$6604,D1
2E5A: 4A46          TST.W      D6
2E5C: 660A          BNE.S      $2E68
2E5E: 0C430001      CMPI.W     #$0001,D3
2E62: 660E          BNE.S      $2E72
2E64: 4A47          TST.W      D7
2E66: 670A          BEQ.S      $2E72
2E68: 3F3C000F      MOVE.W     #$000F,-(A7)
2E6C: A9C860000192  MOVE.L     A0,#$60000192
2E72: 3004          MOVE.W     D4,D0
2E74: D046          MOVEA.B    D6,A0
2E76: 0C400010      CMPI.W     #$0010,D0
2E7A: 670A          BEQ.S      $2E86
2E7C: 3003          MOVE.W     D3,D0
2E7E: D047          MOVEA.B    D7,A0
2E80: 0C400010      CMPI.W     #$0010,D0
2E84: 6626          BNE.S      $2EAC
2E86: 7011          MOVEQ      #17,D0
2E88: C1C3          ANDA.L     D3,A0
2E8A: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
2E8E: D088          MOVE.B     A0,(A0)
2E90: 3044          MOVEA.W    D4,A0
2E92: 4A300800      TST.B      0(A0,D0.L)
2E96: 6714          BEQ.S      $2EAC
2E98: 7011          MOVEQ      #17,D0
2E9A: C1C3          ANDA.L     D3,A0
2E9C: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
2EA0: D088          MOVE.B     A0,(A0)
2EA2: 3044          MOVEA.W    D4,A0
2EA4: 1D700800FFFF  MOVE.B     0(A0,D0.L),-1(A6)
2EAA: 6016          BRA.S      $2EC2
2EAC: 9647          MOVEA.B    D7,A3
2EAE: 7011          MOVEQ      #17,D0
2EB0: C1C3          ANDA.L     D3,A0
2EB2: 9846          MOVEA.B    D6,A4
2EB4: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
2EB8: D088          MOVE.B     A0,(A0)
2EBA: 3044          MOVEA.W    D4,A0
2EBC: 1D700800FFFF  MOVE.B     0(A0,D0.L),-1(A6)
2EC2: 4A2EFFFF      TST.B      -1(A6)
2EC6: 6700013A      BEQ.W      $3004
2ECA: 2F3C00010001  MOVE.L     #$00010001,-(A7)
2ED0: 4267          CLR.W      -(A7)
2ED2: 3F04          MOVE.W     D4,-(A7)
2ED4: 3F03          MOVE.W     D3,-(A7)
2ED6: 4EBAD220      JSR        -11744(PC)
2EDA: 4A40          TST.W      D0
2EDC: 4FEF000A      LEA        10(A7),A7
2EE0: 67000128      BEQ.W      $300C
2EE4: 6000011C      BRA.W      $3004
2EE8: 7001          MOVEQ      #1,D0
2EEA: D044          MOVEA.B    D4,A0
2EEC: 0C400010      CMPI.W     #$0010,D0
2EF0: 6C000110      BGE.W      $3004
2EF4: 5244          MOVEA.B    D4,A1
2EF6: 6000010A      BRA.W      $3004
2EFA: 4A6DD9AE      TST.W      -9810(A5)
2EFE: 6718          BEQ.S      $2F18
2F00: 7801          MOVEQ      #1,D4
2F02: 7001          MOVEQ      #1,D0
2F04: D043          MOVEA.B    D3,A0
2F06: 0C400010      CMPI.W     #$0010,D0
2F0A: 6C06          BGE.S      $2F12
2F0C: 5243          MOVEA.B    D3,A1
2F0E: 600000F2      BRA.W      $3004
2F12: 7601          MOVEQ      #1,D3
2F14: 600000EC      BRA.W      $3004
2F18: 206DDECA      MOVEA.L    -8502(A5),A0
2F1C: 2050          MOVEA.L    (A0),A0
2F1E: 4A280011      TST.B      17(A0)
2F22: 660000DE      BNE.W      $3004
2F26: 3F3C000A      MOVE.W     #$000A,-(A7)
2F2A: 2F2DDECA      MOVE.L     -8502(A5),-(A7)                ; A5-8502
2F2E: 4EAD01D2      JSR        466(A5)                        ; JT[466]
2F32: 5C8F          MOVE.B     A7,(A6)
2F34: 600000CC      BRA.W      $3004
2F38: 0C6D0002D9AE  CMPI.W     #$0002,-9810(A5)
2F3E: 660000C2      BNE.W      $3004
2F42: 206DDEC2      MOVEA.L    -8510(A5),A0
2F46: 2F2800A0      MOVE.L     160(A0),-(A7)
2F4A: A9D83B7C0001  MOVE.L     (A0)+,#$3B7C0001
2F50: D9AE600000AE  MOVE.B     24576(A6),-82(A4,D0.W)
2F56: 4A2EFFFF      TST.B      -1(A6)
2F5A: 671A          BEQ.S      $2F76
2F5C: 2F3C00010001  MOVE.L     #$00010001,-(A7)
2F62: 4267          CLR.W      -(A7)
2F64: 3F04          MOVE.W     D4,-(A7)
2F66: 3F03          MOVE.W     D3,-(A7)
2F68: 4EBAD18E      JSR        -11890(PC)
2F6C: 4A40          TST.W      D0
2F6E: 4FEF000A      LEA        10(A7),A7
2F72: 67000096      BEQ.W      $300C
2F76: 4A47          TST.W      D7
2F78: 6600FEBA      BNE.W      $2E36
2F7C: 4A46          TST.W      D6
2F7E: 6600FF68      BNE.W      $2EEA
2F82: 4EAD01A2      JSR        418(A5)                        ; JT[418]
2F86: 6000FF60      BRA.W      $2EEA
2F8A: 7000          MOVEQ      #0,D0
2F8C: 1005          MOVE.B     D5,D0
2F8E: 204D          MOVEA.L    A5,A0
2F90: D1C00828      MOVE.B     D0,$0828.W
2F94: 0006FBD8      ORI.B      #$FBD8,D6
2F98: 670E          BEQ.S      $2FA8
2F9A: 1005          MOVE.B     D5,D0
2F9C: 4880          EXT.W      D0
2F9E: 3F00          MOVE.W     D0,-(A7)
2FA0: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
2FA4: 548F          MOVE.B     A7,(A2)
2FA6: 600C          BRA.S      $2FB4
2FA8: 1005          MOVE.B     D5,D0
2FAA: 4880          EXT.W      D0
2FAC: 3F00          MOVE.W     D0,-(A7)
2FAE: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
2FB2: 548F          MOVE.B     A7,(A2)
2FB4: 1A00          MOVE.B     D0,D5
2FB6: 7000          MOVEQ      #0,D0
2FB8: 1005          MOVE.B     D5,D0
2FBA: 204D          MOVEA.L    A5,A0
2FBC: D1C01028      MOVE.B     D0,$1028.W
2FC0: FBD8          MOVE.W     (A0)+,???
2FC2: 020000C0      ANDI.B     #$00C0,D0
2FC6: 6742          BEQ.S      $300A
2FC8: BA2EFFFF      MOVE.W     -1(A6),D5
2FCC: 671C          BEQ.S      $2FEA
2FCE: 2F3C00010001  MOVE.L     #$00010001,-(A7)
2FD4: 1005          MOVE.B     D5,D0
2FD6: 4880          EXT.W      D0
2FD8: 3F00          MOVE.W     D0,-(A7)
2FDA: 3F04          MOVE.W     D4,-(A7)
2FDC: 3F03          MOVE.W     D3,-(A7)
2FDE: 4EBAD118      JSR        -12008(PC)
2FE2: 4A40          TST.W      D0
2FE4: 4FEF000A      LEA        10(A7),A7
2FE8: 6720          BEQ.S      $300A
2FEA: 3004          MOVE.W     D4,D0
2FEC: D046          MOVEA.B    D6,A0
2FEE: 0C400010      CMPI.W     #$0010,D0
2FF2: 6C0E          BGE.S      $3002
2FF4: 3003          MOVE.W     D3,D0
2FF6: D047          MOVEA.B    D7,A0
2FF8: 0C400010      CMPI.W     #$0010,D0
2FFC: 6C04          BGE.S      $3002
2FFE: D846          MOVEA.B    D6,A4
3000: D647          MOVEA.B    D7,A3
3002: 3F04          MOVE.W     D4,-(A7)
3004: 3F03          MOVE.W     D3,-(A7)
3006: 4EBAF564      JSR        -2716(PC)
300A: 4CEE10F8FFDC  MOVEM.L    -36(A6),D3/D4/D5/D6/D7/A4
3010: 4E5E          UNLK       A6
3012: 4E75          RTS        

3014: FF04          MOVE.W     D4,-(A7)
3016: FF76FF76FF76  MOVE.W     118(A6,A7.L*8),-138(A7)
301C: FF76FE40FF24  MOVE.W     64(A6,A7.L*8),-220(A7)
3022: FF76FF76FF76  MOVE.W     118(A6,A7.L*8),-138(A7)
3028: FEE6          MOVE.W     -(A6),(A7)+
302A: FF76FF76FF76  MOVE.W     118(A6,A7.L*8),-138(A7)
3030: FF76FF76FF76  MOVE.W     118(A6,A7.L*8),-138(A7)
3036: FF76FF76FF76  MOVE.W     118(A6,A7.L*8),-138(A7)
303C: FF76FF76FF76  MOVE.W     118(A6,A7.L*8),-138(A7)
3042: FF76FF76FE32  MOVE.W     118(A6,A7.L*8),-462(A7)
3048: FED4          MOVE.W     (A4),(A7)+
304A: FE12          MOVE.W     (A2),D7
304C: FE20          MOVE.W     -(A0),D7
304E: FF424E56      MOVE.W     D2,20054(A7)
3052: 00004A6D      ORI.B      #$4A6D,D0
3056: D9AE66204EBA  MOVE.B     26144(A6),-70(A4,D4.L*8)
305C: 00424A40      ORI.W      #$4A40,D2
3060: 6618          BNE.S      $307A
3062: 2F2E0010      MOVE.L     16(A6),-(A7)
3066: 2F2E000C      MOVE.L     12(A6),-(A7)
306A: 2F2E0008      MOVE.L     8(A6),-(A7)
306E: 4EAD019A      JSR        410(A5)                        ; JT[410]
3072: 4A80          TST.L      D0
3074: 4FEF000C      LEA        12(A7),A7
3078: 6604          BNE.S      $307E
307A: 7000          MOVEQ      #0,D0
307C: 6002          BRA.S      $3080
307E: 7001          MOVEQ      #1,D0
3080: 4E5E          UNLK       A6
3082: 4E75          RTS        


; ======= Function at 0x3084 =======
3084: 4E560000      LINK       A6,#0
3088: 4EBAD71C      JSR        -10468(PC)
308C: 4E5E          UNLK       A6
308E: 4E75          RTS        


; ======= Function at 0x3090 =======
3090: 4E560000      LINK       A6,#0
3094: 4267          CLR.W      -(A7)
3096: 4EBAD88A      JSR        -10102(PC)
309A: 4E5E          UNLK       A6
309C: 4E75          RTS        

309E: 206DDED2      MOVEA.L    -8494(A5),A0
30A2: 2050          MOVEA.L    (A0),A0
30A4: 4A280010      TST.B      16(A0)
30A8: 56C0          SNE        D0
30AA: 4400          NEG.B      D0
30AC: 4880          EXT.W      D0
30AE: 4E75          RTS        


; ======= Function at 0x30B0 =======
30B0: 4E560000      LINK       A6,#0
30B4: 2F2E000C      MOVE.L     12(A6),-(A7)
30B8: 2F2E0008      MOVE.L     8(A6),-(A7)
30BC: 4EAD0CF2      JSR        3314(A5)                       ; JT[3314]
30C0: 2EAE000C      MOVE.L     12(A6),(A7)
30C4: 2F2E0008      MOVE.L     8(A6),-(A7)
30C8: 4EAD0C4A      JSR        3146(A5)                       ; JT[3146]
30CC: 4E5E          UNLK       A6
30CE: 4E75          RTS        


; ======= Function at 0x30D0 =======
30D0: 4E560000      LINK       A6,#0
30D4: 2F2E000C      MOVE.L     12(A6),-(A7)
30D8: 2F2E0008      MOVE.L     8(A6),-(A7)
30DC: 4EAD0CFA      JSR        3322(A5)                       ; JT[3322]
30E0: 2EAE000C      MOVE.L     12(A6),(A7)
30E4: 2F2E0008      MOVE.L     8(A6),-(A7)
30E8: 4EAD0C4A      JSR        3146(A5)                       ; JT[3146]
30EC: 4E5E          UNLK       A6
30EE: 4E75          RTS        


; ======= Function at 0x30F0 =======
30F0: 4E56FFF2      LINK       A6,#-14                        ; frame=14
30F4: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
30F8: 266E000C      MOVEA.L    12(A6),A3
30FC: 99CC2F2E      MOVE.B     A4,#$2E
3100: 0008A873      ORI.B      #$A873,A0
3104: 2D6B000AFFF4  MOVE.L     10(A3),-12(A6)
310A: 486EFFF4      PEA        -12(A6)
310E: A8714227      MOVEA.L    39(A1,D4.W*2),A4
3112: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
3116: 206E0008      MOVEA.L    8(A6),A0
311A: 2F280018      MOVE.L     24(A0),-(A7)
311E: A8E84A1F      MOVE.L     18975(A0),(A4)+
3122: 673C          BEQ.S      $3160
3124: 486EFFF8      PEA        -8(A6)
3128: 4EAD03E2      JSR        994(A5)                        ; JT[994]
312C: 4217          CLR.B      (A7)
312E: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
3132: 486EFFF8      PEA        -8(A6)
3136: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
313A: 548F          MOVE.B     A7,(A2)
313C: 6722          BEQ.S      $3160
313E: 4A6DDE4E      TST.W      -8626(A5)
3142: 670E          BEQ.S      $3152
3144: 42A7          CLR.L      -(A7)
3146: 3F3C3903      MOVE.W     #$3903,-(A7)
314A: A9B9205F2010600C  MOVE.L     $205F2010,12(A4,D6.W)
3152: 42A7          CLR.L      -(A7)
3154: 3F3C0003      MOVE.W     #$0003,-(A7)
3158: A9B9205F20102840  MOVE.L     $205F2010,64(A4,D2.L)
3160: 4EBAFF3C      JSR        -196(PC)
3164: 4A40          TST.W      D0
3166: 6622          BNE.S      $318A
3168: 4A6DD9AE      TST.W      -9810(A5)
316C: 661C          BNE.S      $318A
316E: 0C6D0005DE66  CMPI.W     #$0005,-8602(A5)
3174: 6708          BEQ.S      $317E
3176: 0C6D0008DE66  CMPI.W     #$0008,-8602(A5)
317C: 6606          BNE.S      $3184
317E: 4A2DC366      TST.B      -15514(A5)
3182: 6606          BNE.S      $318A
3184: 303C00FF      MOVE.W     #$00FF,D0
3188: 6002          BRA.S      $318C
318A: 7000          MOVEQ      #0,D0
318C: 3E00          MOVE.W     D0,D7
318E: 206DDECA      MOVEA.L    -8502(A5),A0
3192: 2050          MOVEA.L    (A0),A0
3194: 7000          MOVEQ      #0,D0
3196: 10280011      MOVE.B     17(A0),D0
319A: B047          MOVEA.W    D7,A0
319C: 6708          BEQ.S      $31A6
319E: 2F2DDECA      MOVE.L     -8502(A5),-(A7)                ; A5-8502
31A2: 3F07          MOVE.W     D7,-(A7)
31A4: A95D302D      MOVE.L     (A5)+,12333(A4)
31A8: D9AEB06DEFAC  MOVE.B     -20371(A6),-84(A4,A6.L*8)
31AE: 661A          BNE.S      $31CA
31B0: 4A2DA74E      TST.B      -22706(A5)
31B4: 56C0          SNE        D0
31B6: 4400          NEG.B      D0
31B8: 4880          EXT.W      D0
31BA: B06DEFAA      MOVEA.W    -4182(A5),A0
31BE: 660A          BNE.S      $31CA
31C0: 302DDE66      MOVE.W     -8602(A5),D0                   ; A5-8602
31C4: B06DEFAE      MOVEA.W    -4178(A5),A0
31C8: 674C          BEQ.S      $3216
31CA: 4A2DA74E      TST.B      -22706(A5)
31CE: 56C0          SNE        D0
31D0: 4400          NEG.B      D0
31D2: 4880          EXT.W      D0
31D4: 3B40EFAA      MOVE.W     D0,-4182(A5)
31D8: 3B6DD9AEEFAC  MOVE.W     -9810(A5),-4180(A5)            ; g_flag2
31DE: 3B6DDE66EFAE  MOVE.W     -8602(A5),-4178(A5)            ; A5-8602
31E4: 2F2DDECA      MOVE.L     -8502(A5),-(A7)                ; A5-8502
31E8: 4A6DD9AE      TST.W      -9810(A5)
31EC: 6608          BNE.S      $31F6
31EE: 4EBAFEAE      JSR        -338(PC)
31F2: 4A40          TST.W      D0
31F4: 6708          BEQ.S      $31FE
31F6: 41EDF138      LEA        -3784(A5),A0                   ; A5-3784
31FA: 2008          MOVE.L     A0,D0
31FC: 6014          BRA.S      $3212
31FE: 4A6DEFAA      TST.W      -4182(A5)
3202: 6708          BEQ.S      $320C
3204: 41EDF13C      LEA        -3780(A5),A0                   ; A5-3780
3208: 2008          MOVE.L     A0,D0
320A: 6006          BRA.S      $3212
320C: 41EDF142      LEA        -3774(A5),A0                   ; A5-3774
3210: 2008          MOVE.L     A0,D0
3212: 2F00          MOVE.L     D0,-(A7)
3214: A95F2F2D      MOVE.L     (A7)+,12077(A4)
3218: DECE          MOVE.B     A6,(A7)+
321A: 4A6DD9AE      TST.W      -9810(A5)
321E: 6606          BNE.S      $3226
3220: 4A6DDE54      TST.W      -8620(A5)
3224: 6704          BEQ.S      $322A
3226: 7000          MOVEQ      #0,D0
3228: 6004          BRA.S      $322E
322A: 303C00FF      MOVE.W     #$00FF,D0
322E: 3F00          MOVE.W     D0,-(A7)
3230: A95D4A6D      MOVE.L     (A5)+,19053(A4)
3234: D9AE662E0C6D  MOVE.B     26158(A6),109(A4,D0.L*4)
323A: 0005DE66      ORI.B      #$DE66,D5
323E: 6626          BNE.S      $3266
3240: 2E2B0006      MOVE.L     6(A3),D7
3244: 703C          MOVEQ      #60,D0
3246: D0ADDE5A      MOVE.B     -8614(A5),(A0)                 ; A5-8614
324A: B087          MOVE.W     D7,(A0)
324C: 6E18          BGT.S      $3266
324E: 2007          MOVE.L     D7,D0
3250: 90ADDE5A      MOVE.B     -8614(A5),(A0)                 ; A5-8614
3254: D1ADDE562B47  MOVE.B     -8618(A5),71(A0,D2.L*2)        ; A5-8618
325A: DE5A          MOVEA.B    (A2)+,A7
325C: 3F3C0001      MOVE.W     #$0001,-(A7)
3260: 4EBAE196      JSR        -7786(PC)
3264: 548F          MOVE.B     A7,(A2)
3266: 4A6DEF1C      TST.W      -4324(A5)
326A: 6722          BEQ.S      $328E
326C: 202DEFE6      MOVE.L     -4122(A5),D0                   ; A5-4122
3270: B0AB0006      MOVE.W     6(A3),(A0)
3274: 6E18          BGT.S      $328E
3276: 0C6D0001EF1C  CMPI.W     #$0001,-4324(A5)
327C: 6C08          BGE.S      $3286
327E: 703C          MOVEQ      #60,D0
3280: D1ADEFE66008  MOVE.B     -4122(A5),8(A0,D6.W)           ; A5-4122
3286: 4267          CLR.W      -(A7)
3288: 4EBAD89A      JSR        -10086(PC)
328C: 548F          MOVE.B     A7,(A2)
328E: 0C6D0001D9AE  CMPI.W     #$0001,-9810(A5)
3294: 660A          BNE.S      $32A0
3296: 206DDEC2      MOVEA.L    -8510(A5),A0
329A: 2F2800A0      MOVE.L     160(A0),-(A7)
329E: A9DA4EBAFDFC  MOVE.L     (A2)+,#$4EBAFDFC
32A4: 4A40          TST.W      D0
32A6: 6704          BEQ.S      $32AC
32A8: 286DEFDA      MOVEA.L    -4134(A5),A4
32AC: 200C          MOVE.L     A4,D0
32AE: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
32B2: 4E5E          UNLK       A6
32B4: 4E75          RTS        


; ======= Function at 0x32B6 =======
32B6: 4E56FFF0      LINK       A6,#-16                        ; frame=16
32BA: 48E70300      MOVEM.L    D6/D7,-(SP)                    ; save
32BE: 206DDE78      MOVEA.L    -8584(A5),A0
32C2: 2050          MOVEA.L    (A0),A0
32C4: 4A68030C      TST.W      780(A0)
32C8: 6700010E      BEQ.W      $33DA
32CC: 3F3C0016      MOVE.W     #$0016,-(A7)
32D0: A887          MOVE.L     D7,(A4)
32D2: 3F3C000A      MOVE.W     #$000A,-(A7)
32D6: A88A          MOVE.L     A2,(A4)
32D8: 486EFFF0      PEA        -16(A6)
32DC: A88B          MOVE.L     A3,(A4)
32DE: 7E41          MOVEQ      #65,D7
32E0: 6042          BRA.S      $3324
32E2: 1C07          MOVE.B     D7,D6
32E4: 4886          EXT.W      D6
32E6: 70C0          MOVEQ      #-64,D0
32E8: D046          MOVEA.B    D6,A0
32EA: 3F00          MOVE.W     D0,-(A7)
32EC: 3F3C0001      MOVE.W     #$0001,-(A7)
32F0: 486EFFF8      PEA        -8(A6)
32F4: 4EAD03EA      JSR        1002(A5)                       ; JT[1002]
32F8: 4257          CLR.W      (A7)
32FA: 3F06          MOVE.W     D6,-(A7)
32FC: A88D          MOVE.L     A5,(A4)
32FE: 302EFFFE      MOVE.W     -2(A6),D0
3302: D06EFFFA      MOVEA.B    -6(A6),A0
3306: 905F          MOVEA.B    (A7)+,A0
3308: 48C0          EXT.L      D0
330A: 81FC00023E80  ORA.L      #$00023E80,A0
3310: 302EFFF8      MOVE.W     -8(A6),D0
3314: 906EFFF2      MOVEA.B    -14(A6),A0
3318: 3F00          MOVE.W     D0,-(A7)
331A: A893          MOVE.L     (A3),(A4)
331C: 3E86          MOVE.W     D6,(A7)
331E: A883          MOVE.L     D3,(A4)
3320: 548F          MOVE.B     A7,(A2)
3322: 5207          MOVE.B     D7,D1
3324: 0C07004F      CMPI.B     #$004F,D7
3328: 6FB8          BLE.S      $32E2
332A: 7E31          MOVEQ      #49,D7
332C: 6046          BRA.S      $3374
332E: 1C07          MOVE.B     D7,D6
3330: 4886          EXT.W      D6
3332: 3F3C0001      MOVE.W     #$0001,-(A7)
3336: 70D0          MOVEQ      #-48,D0
3338: D046          MOVEA.B    D6,A0
333A: 3F00          MOVE.W     D0,-(A7)
333C: 486EFFF8      PEA        -8(A6)
3340: 4EAD03EA      JSR        1002(A5)                       ; JT[1002]
3344: 4257          CLR.W      (A7)
3346: 3F06          MOVE.W     D6,-(A7)
3348: A88D          MOVE.L     A5,(A4)
334A: 302EFFFA      MOVE.W     -6(A6),D0
334E: 905F          MOVEA.B    (A7)+,A0
3350: 55403E80      MOVE.B     D0,16000(A2)
3354: 302EFFF8      MOVE.W     -8(A6),D0
3358: D06EFFFC      MOVEA.B    -4(A6),A0
335C: 306EFFF0      MOVEA.W    -16(A6),A0
3360: D0C0          MOVE.B     D0,(A0)+
3362: 2008          MOVE.L     A0,D0
3364: 81FC00023F00  ORA.L      #$00023F00,A0
336A: A893          MOVE.L     (A3),(A4)
336C: 3E86          MOVE.W     D6,(A7)
336E: A883          MOVE.L     D3,(A4)
3370: 548F          MOVE.B     A7,(A2)
3372: 5207          MOVE.B     D7,D1
3374: 0C070039      CMPI.B     #$0039,D7
3378: 6FB4          BLE.S      $332E
337A: 7E30          MOVEQ      #48,D7
337C: 6054          BRA.S      $33D2
337E: 1C07          MOVE.B     D7,D6
3380: 4886          EXT.W      D6
3382: 3F3C0001      MOVE.W     #$0001,-(A7)
3386: 70DA          MOVEQ      #-38,D0
3388: D046          MOVEA.B    D6,A0
338A: 3F00          MOVE.W     D0,-(A7)
338C: 486EFFF8      PEA        -8(A6)
3390: 4EAD03EA      JSR        1002(A5)                       ; JT[1002]
3394: 4257          CLR.W      (A7)
3396: 3F06          MOVE.W     D6,-(A7)
3398: A88D          MOVE.L     A5,(A4)
339A: 301F          MOVE.W     (A7)+,D0
339C: D040          MOVEA.B    D0,A0
339E: 322EFFFA      MOVE.W     -6(A6),D1
33A2: 9240          MOVEA.B    D0,A1
33A4: 3E81          MOVE.W     D1,(A7)
33A6: 302EFFF8      MOVE.W     -8(A6),D0
33AA: D06EFFFC      MOVEA.B    -4(A6),A0
33AE: 306EFFF0      MOVEA.W    -16(A6),A0
33B2: D0C0          MOVE.B     D0,(A0)+
33B4: 2008          MOVE.L     A0,D0
33B6: 81FC00023F00  ORA.L      #$00023F00,A0
33BC: A893          MOVE.L     (A3),(A4)
33BE: 3EBC0031      MOVE.W     #$0031,(A7)
33C2: A883          MOVE.L     D3,(A4)
33C4: 2F3C0000FFFF  MOVE.L     #$0000FFFF,-(A7)
33CA: A894          MOVE.L     (A4),(A4)
33CC: 3E86          MOVE.W     D6,(A7)
33CE: A883          MOVE.L     D3,(A4)
33D0: 5207          MOVE.B     D7,D1
33D2: 0C070035      CMPI.B     #$0035,D7
33D6: 6FA6          BLE.S      $337E
33D8: 4CDF00C0      MOVEM.L    (SP)+,D6/D7                    ; restore
33DC: 4E5E          UNLK       A6
33DE: 4E75          RTS        

33E0: 2F2DDE60      MOVE.L     -8608(A5),-(A7)                ; A5-8608
33E4: A9A2206D      MOVE.L     -(A2),109(A4,D2.W)
33E8: DE60          MOVEA.B    -(A0),A7
33EA: 4A90          TST.L      (A0)
33EC: 6604          BNE.S      $33F2
33EE: 4EAD01A2      JSR        418(A5)                        ; JT[418]
33F2: 206DDE60      MOVEA.L    -8608(A5),A0
33F6: A0294E75      MOVE.L     20085(A1),D0
33FA: 206DDE60      MOVEA.L    -8608(A5),A0
33FE: A02A2F2D      MOVE.L     12077(A2),D0
3402: DE60          MOVEA.B    -(A0),A7
3404: 3F3C0020      MOVE.W     #$0020,-(A7)
3408: A9A72F2D      MOVE.L     -(A7),45(A4,D2.L*8)
340C: DE60          MOVEA.B    -(A0),A7
340E: A9AA4267A994  MOVE.L     16999(A2),-108(A4,A2.L)
3414: A9994E75      MOVE.L     (A1)+,117(A4,D4.L*8)

; ======= Function at 0x3418 =======
3418: 4E560000      LINK       A6,#0
341C: 4EBAD3A2      JSR        -11358(PC)
3420: 4E5E          UNLK       A6
3422: 4E75          RTS        

3424: 4AADDEC2      TST.L      -8510(A5)
3428: 6710          BEQ.S      $343A
342A: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
342E: A873206D      MOVEA.L    109(A3,D2.W),A4
3432: DEC2          MOVE.B     D2,(A7)+
3434: 48680010      PEA        16(A0)
3438: A9284E75      MOVE.L     20085(A0),-(A4)

; ======= Function at 0x343C =======
343C: 4E56FEF8      LINK       A6,#-264                       ; frame=264
3440: 206DDE78      MOVEA.L    -8584(A5),A0
3444: 2050          MOVEA.L    (A0),A0
3446: 4A68030A      TST.W      778(A0)
344A: 6778          BEQ.S      $34C4
344C: 4227          CLR.B      -(A7)
344E: 206DDE80      MOVEA.L    -8576(A5),A0
3452: 48680046      PEA        70(A0)
3456: 226DDEC2      MOVEA.L    -8510(A5),A1
345A: 2F290018      MOVE.L     24(A1),-(A7)
345E: A8E94A1F      MOVE.L     18975(A1),(A4)+
3462: 6760          BEQ.S      $34C4
3464: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
3468: A8734267      MOVEA.L    103(A3,D4.W*2),A4
346C: A889          MOVE.L     A1,(A4)
346E: 3F3C0004      MOVE.W     #$0004,-(A7)
3472: A887          MOVE.L     D7,(A4)
3474: 3F3C0009      MOVE.W     #$0009,-(A7)
3478: A88A          MOVE.L     A2,(A4)
347A: 206DDE80      MOVEA.L    -8576(A5),A0
347E: 48680046      PEA        70(A0)
3482: A8A1          MOVE.L     -(A1),(A4)
3484: 486EFF00      PEA        -256(A6)
3488: 4EBAD01E      JSR        -12258(PC)
348C: 206DDE80      MOVEA.L    -8576(A5),A0
3490: 2D680046FEF8  MOVE.L     70(A0),-264(A6)
3496: 2D68004AFEFC  MOVE.L     74(A0),-260(A6)
349C: 486EFEF8      PEA        -264(A6)
34A0: 2F3C00010001  MOVE.L     #$00010001,-(A7)
34A6: A8A9486E      MOVE.L     18542(A1),(A4)
34AA: FF00          MOVE.W     D0,-(A7)
34AC: 486EFF00      PEA        -256(A6)
34B0: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
34B4: 2E80          MOVE.L     D0,(A7)
34B6: 486EFEF8      PEA        -264(A6)
34BA: 4267          CLR.W      -(A7)
34BC: A9CE3EBC0001  MOVE.L     A6,#$3EBC0001
34C2: A889          MOVE.L     A1,(A4)
34C4: 4E5E          UNLK       A6
34C6: 4E75          RTS        

34C8: 4EBAFF5A      JSR        -166(PC)
34CC: 206DDE78      MOVEA.L    -8584(A5),A0
34D0: 2050          MOVEA.L    (A0),A0
34D2: 4A68030C      TST.W      780(A0)
34D6: 671E          BEQ.S      $34F6
34D8: 206DDE80      MOVEA.L    -8576(A5),A0
34DC: 5568000A206D  MOVE.B     10(A0),8301(A2)
34E2: DE80          MOVE.B     D0,(A7)
34E4: 0668000D000E  ADDI.W     #$000D,14(A0)
34EA: 206DDE80      MOVEA.L    -8576(A5),A0
34EE: 0668000D0010  ADDI.W     #$000D,16(A0)
34F4: 601C          BRA.S      $3512
34F6: 206DDE80      MOVEA.L    -8576(A5),A0
34FA: 5468000A      MOVEA.B    10(A0),A2
34FE: 206DDE80      MOVEA.L    -8576(A5),A0
3502: 0468000D000E  SUBI.W     #$000D,14(A0)
3508: 206DDE80      MOVEA.L    -8576(A5),A0
350C: 0468000D0010  SUBI.W     #$000D,16(A0)
3512: 4E75          RTS        


; ======= Function at 0x3514 =======
3514: 4E560000      LINK       A6,#0
3518: 2F0C          MOVE.L     A4,-(A7)
351A: 286E000C      MOVEA.L    12(A6),A4
351E: 0C540003      CMPI.W     #$0003,(A4)
3522: 6640          BNE.S      $3564
3524: 70FF          MOVEQ      #-1,D0
3526: C02C0005      AND.B      5(A4),D0
352A: 1B40DE4C      MOVE.B     D0,-8628(A5)
352E: 322C000E      MOVE.W     14(A4),D1
3532: 02410900      ANDI.W     #$0900,D1
3536: 662C          BNE.S      $3564
3538: 7000          MOVEQ      #0,D0
353A: 102DDE4C      MOVE.B     -8628(A5),D0                   ; A5-8628
353E: 204D          MOVEA.L    A5,A0
3540: D1C01028      MOVE.B     D0,$1028.W
3544: FBD8          MOVE.W     (A0)+,???
3546: 020000C0      ANDI.B     #$00C0,D0
354A: 6718          BEQ.S      $3564
354C: 102DDE4C      MOVE.B     -8628(A5),D0                   ; A5-8628
3550: 4880          EXT.W      D0
3552: 3F00          MOVE.W     D0,-(A7)
3554: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
3558: 1B40DE4C      MOVE.B     D0,-8628(A5)
355C: 1D7C00010014  MOVE.B     #$01,20(A6)
3562: 6014          BRA.S      $3578
3564: 4227          CLR.B      -(A7)
3566: 2F2E0010      MOVE.L     16(A6),-(A7)
356A: 2F0C          MOVE.L     A4,-(A7)
356C: 2F2E0008      MOVE.L     8(A6),-(A7)
3570: 4EAD0C8A      JSR        3210(A5)                       ; JT[3210]
3574: 1D5F0014      MOVE.B     (A7)+,20(A6)
3578: 286EFFFC      MOVEA.L    -4(A6),A4
357C: 4E5E          UNLK       A6
357E: 205F          MOVEA.L    (A7)+,A0
3580: 4FEF000C      LEA        12(A7),A7
3584: 4ED0          JMP        (A0)
3586: 486D0532      PEA        1330(A5)                       ; A5+1330
358A: 3F3C03F2      MOVE.W     #$03F2,-(A7)
358E: 4EAD0C82      JSR        3202(A5)                       ; JT[3202]
3592: 5C8F          MOVE.B     A7,(A6)
3594: 4E75          RTS        
