;======================================================================
; CODE 31 Disassembly
; File: /tmp/maven_code_31.bin
; Header: JT offset=2264, JT entries=15
; Code size: 2510 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 48E70038      MOVEM.L    A2/A3/A4,-(SP)                 ; save
0008: 266E0008      MOVEA.L    8(A6),A3
000C: 426DB1D6      CLR.W      -20010(A5)
0010: 284B          MOVEA.L    A3,A4
0012: 102B0021      MOVE.B     33(A3),D0
0016: 4880          EXT.W      D0
0018: 122B0020      MOVE.B     32(A3),D1
001C: 4881          EXT.W      D1
001E: C3FC001145ED  ANDA.L     #$001145ED,A1
0024: BCFE          MOVE.W     ???,(A6)+
0026: D28A          MOVE.B     A2,(A1)
0028: 3440          MOVEA.W    D0,A2
002A: D28A          MOVE.B     A2,(A1)
002C: 2441          MOVEA.L    D1,A2
002E: 600C          BRA.S      $003C
0030: 4A12          TST.B      (A2)
0032: 6604          BNE.S      $0038
0034: 526DB1D6      MOVEA.B    -20010(A5),A1
0038: 528C          MOVE.B     A4,(A1)
003A: 528A          MOVE.B     A2,(A1)
003C: 4A14          TST.B      (A4)
003E: 66F0          BNE.S      $0030
0040: 4CDF1C00      MOVEM.L    (SP)+,A2/A3/A4                 ; restore
0044: 4E5E          UNLK       A6
0046: 4E75          RTS        


; ======= Function at 0x0048 =======
0048: 4E560000      LINK       A6,#0
004C: 2F0C          MOVE.L     A4,-(A7)
004E: 7011          MOVEQ      #17,D0
0050: C1EE0008      ANDA.L     8(A6),A0
0054: D08D          MOVE.B     A5,(A0)
0056: 386E000A      MOVEA.W    10(A6),A4
005A: 49ECBCFD      LEA        -17155(A4),A4
005E: D08C          MOVE.B     A4,(A0)
0060: 2840          MOVEA.L    D0,A4
0062: 6002          BRA.S      $0066
0064: 538C4A14      MOVE.B     A4,20(A1,D4.L*2)
0068: 66FA          BNE.S      $0064
006A: 200C          MOVE.L     A4,D0
006C: 5280          MOVE.B     D0,(A1)
006E: 285F          MOVEA.L    (A7)+,A4
0070: 4E5E          UNLK       A6
0072: 4E75          RTS        


; ======= Function at 0x0074 =======
0074: 4E56FFFE      LINK       A6,#-2                         ; frame=2
0078: 0C6E00100008  CMPI.W     #$0010,8(A6)
007E: 6C16          BGE.S      $0096
0080: 700F          MOVEQ      #15,D0
0082: D06E000A      MOVEA.B    10(A6),A0
0086: 206E000C      MOVEA.L    12(A6),A0
008A: 3080          MOVE.W     D0,(A0)
008C: 226E0010      MOVEA.L    16(A6),A1
0090: 32AE0008      MOVE.W     8(A6),(A1)
0094: 6014          BRA.S      $00AA
0096: 206E000C      MOVEA.L    12(A6),A0
009A: 30AE000A      MOVE.W     10(A6),(A0)
009E: 70F1          MOVEQ      #-15,D0
00A0: D06E0008      MOVEA.B    8(A6),A0
00A4: 226E0010      MOVEA.L    16(A6),A1
00A8: 3280          MOVE.W     D0,(A1)
00AA: 4E5E          UNLK       A6
00AC: 4E75          RTS        

00AE: 4A2DC35E      TST.B      -15522(A5)
00B2: 6722          BEQ.S      $00D6
00B4: 4A2DC366      TST.B      -15514(A5)
00B8: 671C          BEQ.S      $00D6
00BA: 0C6D0006B3F2  CMPI.W     #$0006,-19470(A5)
00C0: 6714          BEQ.S      $00D6
00C2: 0C6D0002B3F2  CMPI.W     #$0002,-19470(A5)
00C8: 6608          BNE.S      $00D2
00CA: 4EBA0038      JSR        56(PC)
00CE: 4A40          TST.W      D0
00D0: 6704          BEQ.S      $00D6
00D2: 7000          MOVEQ      #0,D0
00D4: 6002          BRA.S      $00D8
00D6: 7001          MOVEQ      #1,D0
00D8: 4E75          RTS        


; ======= Function at 0x00DA =======
00DA: 4E56FFFC      LINK       A6,#-4                         ; frame=4
00DE: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
00E2: 7E00          MOVEQ      #0,D7
00E4: 49EDBD0F      LEA        -17137(A5),A4                  ; A5-17137
00E8: 6008          BRA.S      $00F2
00EA: 4A14          TST.B      (A4)
00EC: 6702          BEQ.S      $00F0
00EE: 5247          MOVEA.B    D7,A1
00F0: 528C          MOVE.B     A4,(A1)
00F2: 41EDBE0E      LEA        -16882(A5),A0                  ; A5-16882
00F6: B1CC62F0      MOVE.W     A4,$62F0.W
00FA: 3007          MOVE.W     D7,D0
00FC: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
0100: 4E5E          UNLK       A6
0102: 4E75          RTS        

0104: 4EBAFFD4      JSR        -44(PC)
0108: 0C40004F      CMPI.W     #$004F,D0
010C: 5FC0          SLE        D0
010E: 4400          NEG.B      D0
0110: 4880          EXT.W      D0
0112: 4E75          RTS        

0114: 4EBAFFC4      JSR        -60(PC)
0118: 0C400056      CMPI.W     #$0056,D0
011C: 5CC0          SGE        D0
011E: 4400          NEG.B      D0
0120: 4880          EXT.W      D0
0122: 4E75          RTS        


; ======= Function at 0x0124 =======
0124: 4E560000      LINK       A6,#0
0128: 2F07          MOVE.L     D7,-(A7)
012A: 204D          MOVEA.L    A5,A0
012C: 302E0008      MOVE.W     8(A6),D0
0130: D0C0          MOVE.B     D0,(A0)+
0132: D0C0          MOVE.B     D0,(A0)+
0134: 3E289412      MOVE.W     -27630(A0),D7
0138: 0C470064      CMPI.W     #$0064,D7
013C: 6C04          BGE.S      $0142
013E: 3007          MOVE.W     D7,D0
0140: 6008          BRA.S      $014A
0142: 2007          MOVE.L     D7,D0
0144: 48C0          EXT.L      D0
0146: 81FC00642E1F  ORA.L      #$00642E1F,A0
014C: 4E5E          UNLK       A6
014E: 4E75          RTS        


; ======= Function at 0x0150 =======
0150: 4E560000      LINK       A6,#0
0154: 48780021      PEA        $0021.W
0158: 486DF536      PEA        -2762(A5)                      ; A5-2762
015C: 2F2E0008      MOVE.L     8(A6),-(A7)
0160: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0164: 4E5E          UNLK       A6
0166: 4E75          RTS        


; ======= Function at 0x0168 =======
0168: 4E560000      LINK       A6,#0
016C: 48780021      PEA        $0021.W
0170: 2F2E0008      MOVE.L     8(A6),-(A7)
0174: 486DF536      PEA        -2762(A5)                      ; A5-2762
0178: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
017C: 4E5E          UNLK       A6
017E: 4E75          RTS        


; ======= Function at 0x0180 =======
0180: 4E56F79A      LINK       A6,#-2150                      ; frame=2150
0184: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0188: 266E0008      MOVEA.L    8(A6),A3
018C: 246E000C      MOVEA.L    12(A6),A2
0190: 49EB0020      LEA        32(A3),A4
0194: 1B54F536      MOVE.B     (A4),-2762(A5)
0198: 7E01          MOVEQ      #1,D7
019A: 4A6E0010      TST.W      16(A6)
019E: 670000C2      BEQ.W      $0264
01A2: 486EF7C6      PEA        -2106(A6)
01A6: 486EFBC6      PEA        -1082(A6)
01AA: 2F0B          MOVE.L     A3,-(A7)
01AC: 4EAD09E2      JSR        2530(A5)                       ; JT[2530]
01B0: 7058          MOVEQ      #88,D0
01B2: 2E80          MOVE.L     D0,(A7)
01B4: 486DA440      PEA        -23488(A5)                     ; A5-23488
01B8: 4EAD01AA      JSR        426(A5)                        ; JT[426]
01BC: 102DA5B8      MOVE.B     -23112(A5),D0                  ; A5-23112
01C0: 4880          EXT.W      D0
01C2: 3D40F7B6      MOVE.W     D0,-2122(A6)
01C6: 122DA5BF      MOVE.B     -23105(A5),D1                  ; A5-23105
01CA: 4881          EXT.W      D1
01CC: 3D41F79E      MOVE.W     D1,-2146(A6)
01D0: 142DA5C6      MOVE.B     -23098(A5),D2                  ; A5-23098
01D4: 4882          EXT.W      D2
01D6: 3D42F7B0      MOVE.W     D2,-2128(A6)
01DA: 102DA5C8      MOVE.B     -23096(A5),D0                  ; A5-23096
01DE: 4880          EXT.W      D0
01E0: 3D40F7AE      MOVE.W     D0,-2130(A6)
01E4: 102DA58D      MOVE.B     -23155(A5),D0                  ; A5-23155
01E8: 4880          EXT.W      D0
01EA: 3D40F79C      MOVE.W     D0,-2148(A6)
01EE: 2E8A          MOVE.L     A2,(A7)
01F0: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
01F4: 3D40F7A8      MOVE.W     D0,-2136(A6)
01F8: 7800          MOVEQ      #0,D4
01FA: 3C04          MOVE.W     D4,D6
01FC: 7661          MOVEQ      #97,D3
01FE: 4FEF0010      LEA        16(A7),A7
0202: 603E          BRA.S      $0242
0204: 204D          MOVEA.L    A5,A0
0206: D0C3          MOVE.B     D3,(A0)+
0208: 1A28A54E      MOVE.B     -23218(A0),D5
020C: 4885          EXT.W      D5
020E: 4A45          TST.W      D5
0210: 672E          BEQ.S      $0240
0212: 3F03          MOVE.W     D3,-(A7)
0214: 4EAD07D2      JSR        2002(A5)                       ; JT[2002]
0218: 4A40          TST.W      D0
021A: 548F          MOVE.B     A7,(A2)
021C: 6704          BEQ.S      $0222
021E: DC45          MOVEA.B    D5,A6
0220: 6002          BRA.S      $0224
0222: D845          MOVEA.B    D5,A4
0224: 0C450003      CMPI.W     #$0003,D5
0228: 6D06          BLT.S      $0230
022A: 52ADA480      MOVE.B     -23424(A5),(A1)                ; A5-23424
022E: 6010          BRA.S      $0240
0230: 0C430073      CMPI.W     #$0073,D3
0234: 670A          BEQ.S      $0240
0236: 0C450002      CMPI.W     #$0002,D5
023A: 6604          BNE.S      $0240
023C: 52ADA47C      MOVE.B     -23428(A5),(A1)                ; A5-23428
0240: 5243          MOVEA.B    D3,A1
0242: 0C43007A      CMPI.W     #$007A,D3
0246: 6FBC          BLE.S      $0204
0248: 0C460006      CMPI.W     #$0006,D6
024C: 6D08          BLT.S      $0256
024E: 7001          MOVEQ      #1,D0
0250: 2B40A488      MOVE.L     D0,-23416(A5)
0254: 600C          BRA.S      $0262
0256: 0C440006      CMPI.W     #$0006,D4
025A: 6D06          BLT.S      $0262
025C: 7001          MOVEQ      #1,D0
025E: 2B40A484      MOVE.L     D0,-23420(A5)
0262: 4EBAFE76      JSR        -394(PC)
0266: 3A00          MOVE.W     D0,D5
0268: 7C00          MOVEQ      #0,D6
026A: 4A14          TST.B      (A4)
026C: 6638          BNE.S      $02A6
026E: 526DB3F2      MOVEA.B    -19470(A5),A1
0272: 284B          MOVEA.L    A3,A4
0274: 600E          BRA.S      $0284
0276: 1014          MOVE.B     (A4),D0
0278: 4880          EXT.W      D0
027A: 204D          MOVEA.L    A5,A0
027C: D0C0          MOVE.B     D0,(A0)+
027E: 5328A54E      MOVE.B     -23218(A0),-(A1)
0282: 528C          MOVE.B     A4,(A1)
0284: 4A14          TST.B      (A4)
0286: 66EE          BNE.S      $0276
0288: 2F0B          MOVE.L     A3,-(A7)
028A: 486DBCFE      PEA        -17154(A5)                     ; g_state1
028E: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0292: 4A6E0010      TST.W      16(A6)
0296: 508F          MOVE.B     A7,(A0)
0298: 67000258      BEQ.W      $04F4
029C: 7001          MOVEQ      #1,D0
029E: 2B40A494      MOVE.L     D0,-23404(A5)
02A2: 6000024E      BRA.W      $04F4
02A6: 426DB3F2      CLR.W      -19470(A5)
02AA: 41EEFFDE      LEA        -34(A6),A0
02AE: 43D3          LEA        (A3),A1
02B0: 7007          MOVEQ      #7,D0
02B2: 20D9          MOVE.L     (A1)+,(A0)+
02B4: 51C8FFFC      DBF        D0,$02B2                       ; loop
02B8: 30D9          MOVE.W     (A1)+,(A0)+
02BA: 486EFFCE      PEA        -50(A6)
02BE: 2F0A          MOVE.L     A2,-(A7)
02C0: 486EFFDE      PEA        -34(A6)
02C4: 4EAD098A      JSR        2442(A5)                       ; JT[2442]
02C8: 2D40FFEE      MOVE.L     D0,-18(A6)
02CC: 4AAEFFEE      TST.L      -18(A6)
02D0: 4FEF000C      LEA        12(A7),A7
02D4: 6C04          BGE.S      $02DA
02D6: 4EAD01A2      JSR        418(A5)                        ; JT[418]
02DA: 4AADB3EE      TST.L      -19474(A5)
02DE: 670C          BEQ.S      $02EC
02E0: 486EFFDE      PEA        -34(A6)
02E4: 206DB3EE      MOVEA.L    -19474(A5),A0
02E8: 4E90          JSR        (A0)
02EA: 588F          MOVE.B     A7,(A4)
02EC: 1814          MOVE.B     (A4),D4
02EE: 4884          EXT.W      D4
02F0: 162B0021      MOVE.B     33(A3),D3
02F4: 4883          EXT.W      D3
02F6: 486EF7C2      PEA        -2110(A6)
02FA: 486EF7C4      PEA        -2108(A6)
02FE: 3F03          MOVE.W     D3,-(A7)
0300: 3F04          MOVE.W     D4,-(A7)
0302: 4EBAFD70      JSR        -656(PC)
0306: 284B          MOVEA.L    A3,A4
0308: 7011          MOVEQ      #17,D0
030A: C1C4          ANDA.L     D4,A0
030C: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
0310: D088          MOVE.B     A0,(A0)
0312: 2D40F7AA      MOVE.L     D0,-2134(A6)
0316: 7222          MOVEQ      #34,D1
0318: C3C4          ANDA.L     D4,A1
031A: 41EDBF1E      LEA        -16610(A5),A0                  ; g_state2
031E: D288          MOVE.B     A0,(A1)
0320: 2D41F7B2      MOVE.L     D1,-2126(A6)
0324: 7411          MOVEQ      #17,D2
0326: C5C4          ANDA.L     D4,A2
0328: 41ED97B2      LEA        -26702(A5),A0                  ; A5-26702
032C: D488          MOVE.B     A0,(A2)
032E: 2D42F7BA      MOVE.L     D2,-2118(A6)
0332: 3043          MOVEA.W    D3,A0
0334: D1C82D48      MOVE.B     A0,$2D48.W
0338: F7A44FEF      MOVE.W     -(A4),-17(A3,D4.L*8)
033C: 000C6000      ORI.B      #$6000,A4
0340: 010C          BTST       D0,A4
0342: 200C          MOVE.L     A4,D0
0344: 908B          MOVE.B     A3,(A0)
0346: 720F          MOVEQ      #15,D1
0348: B280          MOVE.W     D0,(A1)
034A: 6E04          BGT.S      $0350
034C: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0350: 206EF7AA      MOVEA.L    -2134(A6),A0
0354: 10303000      MOVE.B     0(A0,D3.W),D0
0358: B014          MOVE.W     (A4),D0
035A: 6716          BEQ.S      $0372
035C: 7011          MOVEQ      #17,D0
035E: C1C4          ANDA.L     D4,A0
0360: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
0364: D088          MOVE.B     A0,(A0)
0366: 3043          MOVEA.W    D3,A0
0368: 4A300800      TST.B      0(A0,D0.L)
036C: 6704          BEQ.S      $0372
036E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0372: 7011          MOVEQ      #17,D0
0374: C1EEF7C4      ANDA.L     -2108(A6),A0
0378: D08D          MOVE.B     A5,(A0)
037A: 306EF7C2      MOVEA.W    -2110(A6),A0
037E: D1C01D68      MOVE.B     D0,$1D68.W
0382: BCFE          MOVE.W     ???,(A6)+
0384: F79B102E      MOVE.W     (A3)+,46(A3,D1.W)
0388: F79BB014      MOVE.W     (A3)+,20(A3,A3.W)
038C: 670A          BEQ.S      $0398
038E: 4A2EF79B      TST.B      -2149(A6)
0392: 6704          BEQ.S      $0398
0394: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0398: 7011          MOVEQ      #17,D0
039A: C1C4          ANDA.L     D4,A0
039C: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
03A0: D088          MOVE.B     A0,(A0)
03A2: 3043          MOVEA.W    D3,A0
03A4: D088          MOVE.B     A0,(A0)
03A6: 2D40F7A0      MOVE.L     D0,-2144(A6)
03AA: 2040          MOVEA.L    D0,A0
03AC: 4A10          TST.B      (A0)
03AE: 66000090      BNE.W      $0442
03B2: 1014          MOVE.B     (A4),D0
03B4: 4880          EXT.W      D0
03B6: 204D          MOVEA.L    A5,A0
03B8: D0C0          MOVE.B     D0,(A0)+
03BA: 4A28A54E      TST.B      -23218(A0)
03BE: 6610          BNE.S      $03D0
03C0: 4A2DA58D      TST.B      -23155(A5)
03C4: 6E04          BGT.S      $03CA
03C6: 4EAD01A2      JSR        418(A5)                        ; JT[418]
03CA: 532DA58D      MOVE.B     -23155(A5),-(A1)               ; A5-23155
03CE: 600C          BRA.S      $03DC
03D0: 1014          MOVE.B     (A4),D0
03D2: 4880          EXT.W      D0
03D4: 204D          MOVEA.L    A5,A0
03D6: D0C0          MOVE.B     D0,(A0)+
03D8: 5328A54E      MOVE.B     -23218(A0),-(A1)
03DC: 3007          MOVE.W     D7,D0
03DE: 5247          MOVEA.B    D7,A1
03E0: 204D          MOVEA.L    A5,A0
03E2: D0C0          MOVE.B     D0,(A0)+
03E4: 1143F536      MOVE.B     D3,-2762(A0)
03E8: 7011          MOVEQ      #17,D0
03EA: C1EEF7C4      ANDA.L     -2108(A6),A0
03EE: D08D          MOVE.B     A5,(A0)
03F0: 306EF7C2      MOVEA.W    -2110(A6),A0
03F4: D1C01014      MOVE.B     D0,$1014.W
03F8: 1140BCFE      MOVE.B     D0,-17154(A0)
03FC: 206EF7A0      MOVEA.L    -2144(A6),A0
0400: 1080          MOVE.B     D0,(A0)
0402: 1014          MOVE.B     (A4),D0
0404: 4880          EXT.W      D0
0406: 224D          MOVEA.L    A5,A1
0408: D2C0          MOVE.B     D0,(A1)+
040A: D2C0          MOVE.B     D0,(A1)+
040C: 7022          MOVEQ      #34,D0
040E: C1EEF7C4      ANDA.L     -2108(A6),A0
0412: D08D          MOVE.B     A5,(A0)
0414: 2040          MOVEA.L    D0,A0
0416: 302EF7C2      MOVE.W     -2110(A6),D0
041A: D0C0          MOVE.B     D0,(A0)+
041C: D0C0          MOVE.B     D0,(A0)+
041E: 32299412      MOVE.W     -27630(A1),D1
0422: 3141BF1E      MOVE.W     D1,-16610(A0)
0426: 206EF7B2      MOVEA.L    -2126(A6),A0
042A: D1EEF7A43081  MOVE.B     -2140(A6),$3081.W
0430: 206EF7BA      MOVEA.L    -2118(A6),A0
0434: 0C3000033000  CMPI.B     #$0003,0(A0,D3.W)
043A: 6604          BNE.S      $0440
043C: 3C2B0012      MOVE.W     18(A3),D6
0440: 528C          MOVE.B     A4,(A1)
0442: 5243          MOVEA.B    D3,A1
0444: 54AEF7A4      MOVE.B     -2140(A6),(A2)
0448: 526EF7C4      MOVEA.B    -2108(A6),A1
044C: 4A14          TST.B      (A4)
044E: 6600FEF2      BNE.W      $0344
0452: 7022          MOVEQ      #34,D0
0454: C1EDBCF6      ANDA.L     -17162(A5),A0
0458: D08D          MOVE.B     A5,(A0)
045A: 2040          MOVEA.L    D0,A0
045C: 302DBCFA      MOVE.W     -17158(A5),D0                  ; A5-17158
0460: D0C0          MOVE.B     D0,(A0)+
0462: D0C0          MOVE.B     D0,(A0)+
0464: 4268BF1E      CLR.W      -16610(A0)
0468: 7222          MOVEQ      #34,D1
046A: C3EDBCF4      ANDA.L     -17164(A5),A1
046E: D28D          MOVE.B     A5,(A1)
0470: 2041          MOVEA.L    D1,A0
0472: 322DBCF8      MOVE.W     -17160(A5),D1                  ; A5-17160
0476: D0C1          MOVE.B     D1,(A0)+
0478: D0C1          MOVE.B     D1,(A0)+
047A: 4268BF1E      CLR.W      -16610(A0)
047E: 0C6D000FBCF4  CMPI.W     #$000F,-17164(A5)
0484: 6F18          BLE.S      $049E
0486: 7022          MOVEQ      #34,D0
0488: C1EDBCF8      ANDA.L     -17160(A5),A0
048C: D08D          MOVE.B     A5,(A0)
048E: 2040          MOVEA.L    D0,A0
0490: 302DBCF4      MOVE.W     -17164(A5),D0                  ; A5-17164
0494: D0C0          MOVE.B     D0,(A0)+
0496: D0C0          MOVE.B     D0,(A0)+
0498: 4268BF00      CLR.W      -16640(A0)
049C: 601A          BRA.S      $04B8
049E: 700F          MOVEQ      #15,D0
04A0: D06DBCF8      MOVEA.B    -17160(A5),A0
04A4: C1FC0022D08D  ANDA.L     #$0022D08D,A0
04AA: 2040          MOVEA.L    D0,A0
04AC: 302DBCF4      MOVE.W     -17164(A5),D0                  ; A5-17164
04B0: D0C0          MOVE.B     D0,(A0)+
04B2: D0C0          MOVE.B     D0,(A0)+
04B4: 4268BF1E      CLR.W      -16610(A0)
04B8: 0C6D000FBCF6  CMPI.W     #$000F,-17162(A5)
04BE: 6F18          BLE.S      $04D8
04C0: 7022          MOVEQ      #34,D0
04C2: C1EDBCFA      ANDA.L     -17158(A5),A0
04C6: D08D          MOVE.B     A5,(A0)
04C8: 2040          MOVEA.L    D0,A0
04CA: 302DBCF6      MOVE.W     -17162(A5),D0                  ; A5-17162
04CE: D0C0          MOVE.B     D0,(A0)+
04D0: D0C0          MOVE.B     D0,(A0)+
04D2: 4268BF00      CLR.W      -16640(A0)
04D6: 601A          BRA.S      $04F2
04D8: 700F          MOVEQ      #15,D0
04DA: D06DBCFA      MOVEA.B    -17158(A5),A0
04DE: C1FC0022D08D  ANDA.L     #$0022D08D,A0
04E4: 2040          MOVEA.L    D0,A0
04E6: 302DBCF6      MOVE.W     -17162(A5),D0                  ; A5-17162
04EA: D0C0          MOVE.B     D0,(A0)+
04EC: D0C0          MOVE.B     D0,(A0)+
04EE: 4268BF1E      CLR.W      -16610(A0)
04F2: 204D          MOVEA.L    A5,A0
04F4: D0C7          MOVE.B     D7,(A0)+
04F6: 117C00FFF536  MOVE.B     #$FF,-2762(A0)
04FC: 2F0A          MOVE.L     A2,-(A7)
04FE: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0502: 3047          MOVEA.W    D7,A0
0504: D088          MOVE.B     A0,(A0)
0506: 721F          MOVEQ      #31,D1
0508: B280          MOVE.W     D0,(A1)
050A: 588F          MOVE.B     A7,(A4)
050C: 6204          BHI.S      $0512
050E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0512: 2F0A          MOVE.L     A2,-(A7)
0514: 204D          MOVEA.L    A5,A0
0516: D0C7          MOVE.B     D7,(A0)+
0518: 4868F537      PEA        -2761(A0)
051C: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0520: 2E8A          MOVE.L     A2,(A7)
0522: 4EBA01F6      JSR        502(PC)
0526: 4A6E0010      TST.W      16(A6)
052A: 508F          MOVE.B     A7,(A0)
052C: 67000108      BEQ.W      $0638
0530: 102DA5B8      MOVE.B     -23112(A5),D0                  ; A5-23112
0534: 4880          EXT.W      D0
0536: B06EF7B6      MOVEA.W    -2122(A6),A0
053A: 6706          BEQ.S      $0542
053C: 2B6B0010A468  MOVE.L     16(A3),-23448(A5)
0542: 102DA5BF      MOVE.B     -23105(A5),D0                  ; A5-23105
0546: 4880          EXT.W      D0
0548: B06EF79E      MOVEA.W    -2146(A6),A0
054C: 6706          BEQ.S      $0554
054E: 2B6B0010A460  MOVE.L     16(A3),-23456(A5)
0554: 102DA5C6      MOVE.B     -23098(A5),D0                  ; A5-23098
0558: 4880          EXT.W      D0
055A: B06EF7B0      MOVEA.W    -2128(A6),A0
055E: 6706          BEQ.S      $0566
0560: 2B6B0010A464  MOVE.L     16(A3),-23452(A5)
0566: 102DA5C8      MOVE.B     -23096(A5),D0                  ; A5-23096
056A: 4880          EXT.W      D0
056C: B06EF7AE      MOVEA.W    -2130(A6),A0
0570: 6706          BEQ.S      $0578
0572: 2B6B0010A46C  MOVE.L     16(A3),-23444(A5)
0578: 102DA58D      MOVE.B     -23155(A5),D0                  ; A5-23155
057C: 4880          EXT.W      D0
057E: B06EF79C      MOVEA.W    -2148(A6),A0
0582: 6706          BEQ.S      $058A
0584: 2B6B0010A45C  MOVE.L     16(A3),-23460(A5)
058A: 7001          MOVEQ      #1,D0
058C: 2B40A440      MOVE.L     D0,-23488(A5)
0590: 0C450056      CMPI.W     #$0056,D5
0594: 6D08          BLT.S      $059E
0596: 2B6B0010A450  MOVE.L     16(A3),-23472(A5)
059C: 6022          BRA.S      $05C0
059E: 0C45004D      CMPI.W     #$004D,D5
05A2: 6D08          BLT.S      $05AC
05A4: 2B6B0010A44C  MOVE.L     16(A3),-23476(A5)
05AA: 6014          BRA.S      $05C0
05AC: 0C45001E      CMPI.W     #$001E,D5
05B0: 6D08          BLT.S      $05BA
05B2: 2B6B0010A448  MOVE.L     16(A3),-23480(A5)
05B8: 6006          BRA.S      $05C0
05BA: 2B6B0010A444  MOVE.L     16(A3),-23484(A5)
05C0: 486EFFCE      PEA        -50(A6)
05C4: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
05C8: 4A80          TST.L      D0
05CA: 588F          MOVE.B     A7,(A4)
05CC: 661E          BNE.S      $05EC
05CE: 0C6E0007F7A8  CMPI.W     #$0007,-2136(A6)
05D4: 6616          BNE.S      $05EC
05D6: 0CAB000013880010  CMPI.L     #$00001388,16(A3)
05DE: 6D0C          BLT.S      $05EC
05E0: 2B6B0010A454  MOVE.L     16(A3),-23468(A5)
05E6: 7001          MOVEQ      #1,D0
05E8: 2B40A458      MOVE.L     D0,-23464(A5)
05EC: 306EF79E      MOVEA.W    -2146(A6),A0
05F0: 2B48A48C      MOVE.L     A0,-23412(A5)
05F4: 306EF79C      MOVEA.W    -2148(A6),A0
05F8: 2B48A490      MOVE.L     A0,-23408(A5)
05FC: 4A46          TST.W      D6
05FE: 670C          BEQ.S      $060C
0600: 3046          MOVEA.W    D6,A0
0602: 2B48A470      MOVE.L     A0,-23440(A5)
0606: 7001          MOVEQ      #1,D0
0608: 2B40A474      MOVE.L     D0,-23436(A5)
060C: 7600          MOVEQ      #0,D3
060E: 49EEF7C6      LEA        -2106(A6),A4
0612: 47EEFBC6      LEA        -1082(A6),A3
0616: 601A          BRA.S      $0632
0618: 3F13          MOVE.W     (A3),-(A7)
061A: 4EAD09F2      JSR        2546(A5)                       ; JT[2546]
061E: 4A40          TST.W      D0
0620: 548F          MOVE.B     A7,(A2)
0622: 6708          BEQ.S      $062C
0624: 3014          MOVE.W     (A4),D0
0626: 48C0          EXT.L      D0
0628: D1ADA4785243  MOVE.B     -23432(A5),67(A0,D5.W*2)       ; A5-23432
062E: 548C          MOVE.B     A4,(A2)
0630: 548B          MOVE.B     A3,(A2)
0632: 4A53          TST.W      (A3)
0634: 66E2          BNE.S      $0618
0636: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
063A: 4E5E          UNLK       A6
063C: 4E75          RTS        


; ======= Function at 0x063E =======
063E: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0642: 48E70718      MOVEM.L    D5/D6/D7/A3/A4,-(SP)           ; save
0646: 7E01          MOVEQ      #1,D7
0648: 1C2DF536      MOVE.B     -2762(A5),D6                   ; A5-2762
064C: 4886          EXT.W      D6
064E: 4A46          TST.W      D6
0650: 663C          BNE.S      $068E
0652: 0C2D00FFF537  CMPI.B     #$00FF,-2761(A5)
0658: 6704          BEQ.S      $065E
065A: 4EAD01A2      JSR        418(A5)                        ; JT[418]
065E: 4A2DBCFE      TST.B      -17154(A5)
0662: 6716          BEQ.S      $067A
0664: 204D          MOVEA.L    A5,A0
0666: D0C7          MOVE.B     D7,(A0)+
0668: 4868F537      PEA        -2761(A0)
066C: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0670: 5F80588F      MOVE.B     D0,-113(A7,D5.L)
0674: 6704          BEQ.S      $067A
0676: 4EAD01A2      JSR        418(A5)                        ; JT[418]
067A: 536DB3F24878  MOVE.B     -19470(A5),18552(A1)           ; A5-19470
0680: 0011486D      ORI.B      #$486D,(A1)
0684: BCFE          MOVE.W     ???,(A6)+
0686: 4EAD01AA      JSR        426(A5)                        ; JT[426]
068A: 508F          MOVE.B     A7,(A0)
068C: 6072          BRA.S      $0700
068E: 7011          MOVEQ      #17,D0
0690: C1C6          ANDA.L     D6,A0
0692: 49EDBCFE      LEA        -17154(A5),A4                  ; g_state1
0696: D08C          MOVE.B     A4,(A0)
0698: 2840          MOVEA.L    D0,A4
069A: 7022          MOVEQ      #34,D0
069C: C1C6          ANDA.L     D6,A0
069E: 47EDBF1E      LEA        -16610(A5),A3                  ; g_state2
06A2: D08B          MOVE.B     A3,(A0)
06A4: 2640          MOVEA.L    D0,A3
06A6: 604A          BRA.S      $06F2
06A8: 486EFFFC      PEA        -4(A6)
06AC: 486EFFFE      PEA        -2(A6)
06B0: 3F05          MOVE.W     D5,-(A7)
06B2: 3F06          MOVE.W     D6,-(A7)
06B4: 4EBAF9BE      JSR        -1602(PC)
06B8: 7011          MOVEQ      #17,D0
06BA: C1EEFFFE      ANDA.L     -2(A6),A0
06BE: D08D          MOVE.B     A5,(A0)
06C0: 306EFFFC      MOVEA.W    -4(A6),A0
06C4: D1C04228      MOVE.B     D0,$4228.W
06C8: BCFE          MOVE.W     ???,(A6)+
06CA: 42345000      CLR.B      0(A4,D5.W)
06CE: 7022          MOVEQ      #34,D0
06D0: C1EEFFFE      ANDA.L     -2(A6),A0
06D4: D08D          MOVE.B     A5,(A0)
06D6: 2040          MOVEA.L    D0,A0
06D8: 302EFFFC      MOVE.W     -4(A6),D0
06DC: D0C0          MOVE.B     D0,(A0)+
06DE: D0C0          MOVE.B     D0,(A0)+
06E0: 4268BF1E      CLR.W      -16610(A0)
06E4: 204B          MOVEA.L    A3,A0
06E6: D0C5          MOVE.B     D5,(A0)+
06E8: 42705000      CLR.W      0(A0,D5.W)
06EC: 4FEF000C      LEA        12(A7),A7
06F0: 5247          MOVEA.B    D7,A1
06F2: 204D          MOVEA.L    A5,A0
06F4: D0C7          MOVE.B     D7,(A0)+
06F6: 1A28F536      MOVE.B     -2762(A0),D5
06FA: 4885          EXT.W      D5
06FC: 4A45          TST.W      D5
06FE: 6EA8          BGT.S      $06A8
0700: 204D          MOVEA.L    A5,A0
0702: D0C7          MOVE.B     D7,(A0)+
0704: 4868F537      PEA        -2761(A0)
0708: 2F2E0008      MOVE.L     8(A6),-(A7)
070C: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0710: 4CEE18E0FFE8  MOVEM.L    -24(A6),D5/D6/D7/A3/A4
0716: 4E5E          UNLK       A6
0718: 4E75          RTS        


; ======= Function at 0x071A =======
071A: 4E560000      LINK       A6,#0
071E: 48E70718      MOVEM.L    D5/D6/D7/A3/A4,-(SP)           ; save
0722: 266E0008      MOVEA.L    8(A6),A3
0726: 286D99D2      MOVEA.L    -26158(A5),A4
072A: 601A          BRA.S      $0746
072C: 204D          MOVEA.L    A5,A0
072E: D0C7          MOVE.B     D7,(A0)+
0730: 1C28A54E      MOVE.B     -23218(A0),D6
0734: 4886          EXT.W      D6
0736: 7A00          MOVEQ      #0,D5
0738: 6006          BRA.S      $0740
073A: 1687          MOVE.B     D7,(A3)
073C: 5245          MOVEA.B    D5,A1
073E: 528B          MOVE.B     A3,(A1)
0740: BC45          MOVEA.W    D5,A6
0742: 6EF6          BGT.S      $073A
0744: 528C          MOVE.B     A4,(A1)
0746: 1E14          MOVE.B     (A4),D7
0748: 4887          EXT.W      D7
074A: 4A47          TST.W      D7
074C: 66DE          BNE.S      $072C
074E: 4213          CLR.B      (A3)
0750: 4CDF18E0      MOVEM.L    (SP)+,D5/D6/D7/A3/A4           ; restore
0754: 4E5E          UNLK       A6
0756: 4E75          RTS        


; ======= Function at 0x0758 =======
0758: 4E560000      LINK       A6,#0
075C: 48E70738      MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)        ; save
0760: 2E2E0008      MOVE.L     8(A6),D7
0764: 7C00          MOVEQ      #0,D6
0766: 48780080      PEA        $0080.W
076A: 486D9512      PEA        -27374(A5)                     ; A5-27374
076E: 2F07          MOVE.L     D7,-(A7)
0770: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0774: 47EDBD0F      LEA        -17137(A5),A3                  ; A5-17137
0778: 49EDBF40      LEA        -16576(A5),A4                  ; A5-16576
077C: 4FEF000C      LEA        12(A7),A7
0780: 601E          BRA.S      $07A0
0782: 1A13          MOVE.B     (A3),D5
0784: 4885          EXT.W      D5
0786: 4A45          TST.W      D5
0788: 6712          BEQ.S      $079C
078A: 4A54          TST.W      (A4)
078C: 6708          BEQ.S      $0796
078E: 3045          MOVEA.W    D5,A0
0790: 53307800      MOVE.B     0(A0,D7.L),-(A1)
0794: 6006          BRA.S      $079C
0796: 2047          MOVEA.L    D7,A0
0798: 5328003F      MOVE.B     63(A0),-(A1)
079C: 528B          MOVE.B     A3,(A1)
079E: 548C          MOVE.B     A4,(A2)
07A0: 41EDBE0E      LEA        -16882(A5),A0                  ; A5-16882
07A4: B1CB62DA      MOVE.W     A3,$62DA.W
07A8: 266D99D2      MOVEA.L    -26158(A5),A3
07AC: 601C          BRA.S      $07CA
07AE: 3445          MOVEA.W    D5,A2
07B0: D5C7204D      MOVE.B     D7,8269(PC)
07B4: D0C5          MOVE.B     D5,(A0)+
07B6: 1028A54E      MOVE.B     -23218(A0),D0
07BA: 9112          MOVE.B     (A2),-(A0)
07BC: 4A12          TST.B      (A2)
07BE: 6C02          BGE.S      $07C2
07C0: 4212          CLR.B      (A2)
07C2: 1012          MOVE.B     (A2),D0
07C4: 4880          EXT.W      D0
07C6: DC40          MOVEA.B    D0,A6
07C8: 528B          MOVE.B     A3,(A1)
07CA: 1A13          MOVE.B     (A3),D5
07CC: 4885          EXT.W      D5
07CE: 4A45          TST.W      D5
07D0: 66DC          BNE.S      $07AE
07D2: 3006          MOVE.W     D6,D0
07D4: 4CDF1CE0      MOVEM.L    (SP)+,D5/D6/D7/A2/A3/A4        ; restore
07D8: 4E5E          UNLK       A6
07DA: 4E75          RTS        


; ======= Function at 0x07DC =======
07DC: 4E56FF74      LINK       A6,#-140                       ; frame=140
07E0: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
07E4: 286E0008      MOVEA.L    8(A6),A4
07E8: 486EFF80      PEA        -128(A6)
07EC: 4EBA00CC      JSR        204(PC)
07F0: 2E00          MOVE.L     D0,D7
07F2: 2E8C          MOVE.L     A4,(A7)
07F4: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
07F8: 2C00          MOVE.L     D0,D6
07FA: 7008          MOVEQ      #8,D0
07FC: 9086          MOVE.B     D6,(A0)
07FE: B087          MOVE.W     D7,(A0)
0800: 588F          MOVE.B     A7,(A4)
0802: 6456          BCC.S      $085A
0804: 486EFF7C      PEA        -132(A6)
0808: 4EAD069A      JSR        1690(A5)                       ; JT[1690]
080C: 2D6EFF7CFF78  MOVE.L     -132(A6),-136(A6)
0812: 47EEFF7F      LEA        -129(A6),A3
0816: D7C7588F      MOVE.B     D7,-113(PC,D5.L)
081A: 6034          BRA.S      $0850
081C: 4EAD05B2      JSR        1458(A5)                       ; JT[1458]
0820: 2D40FF74      MOVE.L     D0,-140(A6)
0824: 4EAD06E2      JSR        1762(A5)                       ; JT[1762]
0828: 2F07          MOVE.L     D7,-(A7)
082A: 48C0          EXT.L      D0
082C: D0AEFF74      MOVE.B     -140(A6),(A0)
0830: 2F00          MOVE.L     D0,-(A7)
0832: 4EAD0052      JSR        82(A5)                         ; JT[82]
0836: 2A00          MOVE.L     D0,D5
0838: 45F65880      LEA        -128(A6,D5.L),A2
083C: 1812          MOVE.B     (A2),D4
083E: 4884          EXT.W      D4
0840: 48C4          EXT.L      D4
0842: 1493          MOVE.B     (A3),(A2)
0844: 1684          MOVE.B     D4,(A3)
0846: 486EFF78      PEA        -136(A6)
084A: 4EAD069A      JSR        1690(A5)                       ; JT[1690]
084E: 588F          MOVE.B     A7,(A4)
0850: 202EFF78      MOVE.L     -136(A6),D0
0854: B0AEFF7C      MOVE.W     -132(A6),(A0)
0858: 67C2          BEQ.S      $081C
085A: 7800          MOVEQ      #0,D4
085C: 6038          BRA.S      $0896
085E: 4EAD05B2      JSR        1458(A5)                       ; JT[1458]
0862: 2A00          MOVE.L     D0,D5
0864: 4EAD06E2      JSR        1762(A5)                       ; JT[1762]
0868: 3040          MOVEA.W    D0,A0
086A: DA88          MOVE.B     A0,(A5)
086C: DAAEFF7C      MOVE.B     -132(A6),(A5)
0870: 2F07          MOVE.L     D7,-(A7)
0872: 2F05          MOVE.L     D5,-(A7)
0874: 4EAD0052      JSR        82(A5)                         ; JT[82]
0878: 2A00          MOVE.L     D0,D5
087A: 45F65880      LEA        -128(A6,D5.L),A2
087E: 2006          MOVE.L     D6,D0
0880: 5286          MOVE.B     D6,(A1)
0882: 19920800      MOVE.B     (A2),0(A4,D0.L)
0886: 538714B6      MOVE.B     D7,-74(A1,D1.W*4)
088A: 7880          MOVEQ      #-128,D4
088C: 5284          MOVE.B     D4,(A1)
088E: 06AE000000D3FF7C  ADDI.L     #$000000D3,-132(A6)
0896: 7007          MOVEQ      #7,D0
0898: B086          MOVE.W     D6,(A0)
089A: 6304          BLS.S      $08A0
089C: 4A87          TST.L      D7
089E: 62BE          BHI.S      $085E
08A0: 42346800      CLR.B      0(A4,D6.L)
08A4: 48780011      PEA        $0011.W
08A8: 486DBCFE      PEA        -17154(A5)                     ; g_state1
08AC: 4EAD01AA      JSR        426(A5)                        ; JT[426]
08B0: 4CEE1CF0FF58  MOVEM.L    -168(A6),D4/D5/D6/D7/A2/A3/A4
08B6: 4E5E          UNLK       A6
08B8: 4E75          RTS        


; ======= Function at 0x08BA =======
08BA: 4E56FF78      LINK       A6,#-136                       ; frame=136
08BE: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
08C2: 2E2E0008      MOVE.L     8(A6),D7
08C6: 2C07          MOVE.L     D7,D6
08C8: 48780080      PEA        $0080.W
08CC: 486D9512      PEA        -27374(A5)                     ; A5-27374
08D0: 486EFF80      PEA        -128(A6)
08D4: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
08D8: 7800          MOVEQ      #0,D4
08DA: 45EDBF1E      LEA        -16610(A5),A2                  ; g_state2
08DE: 47EDBCFE      LEA        -17154(A5),A3                  ; g_state1
08E2: 4FEF000C      LEA        12(A7),A7
08E6: 604A          BRA.S      $0932
08E8: 7A00          MOVEQ      #0,D5
08EA: 2D4BFF78      MOVE.L     A3,-136(A6)
08EE: 2D4AFF7C      MOVE.L     A2,-132(A6)
08F2: 3845          MOVEA.W    D5,A4
08F4: D9CC602A      MOVE.B     A4,#$2A
08F8: 206EFF78      MOVEA.L    -136(A6),A0
08FC: 16305000      MOVE.B     0(A0,D5.W),D3
0900: 4883          EXT.W      D3
0902: 4A43          TST.W      D3
0904: 6718          BEQ.S      $091E
0906: 204C          MOVEA.L    A4,A0
0908: D1EEFF7C4A50  MOVE.B     -132(A6),$4A50.W
090E: 6604          BNE.S      $0914
0910: 4A44          TST.W      D4
0912: 6606          BNE.S      $091A
0914: 53363080      MOVE.B     -128(A6,D3.W),-(A1)
0918: 6004          BRA.S      $091E
091A: 532EFFBF      MOVE.B     -65(A6),-(A1)
091E: 5245          MOVEA.B    D5,A1
0920: 548C          MOVE.B     A4,(A2)
0922: 0C450010      CMPI.W     #$0010,D5
0926: 6DD0          BLT.S      $08F8
0928: 5244          MOVEA.B    D4,A1
092A: 45EA0022      LEA        34(A2),A2
092E: 47EB0011      LEA        17(A3),A3
0932: 0C440010      CMPI.W     #$0010,D4
0936: 6DB0          BLT.S      $08E8
0938: 45EDC35E      LEA        -15522(A5),A2                  ; g_field_22
093C: 6004          BRA.S      $0942
093E: 53363080      MOVE.B     -128(A6,D3.W),-(A1)
0942: 161A          MOVE.B     (A2)+,D3
0944: 4883          EXT.W      D3
0946: 4A43          TST.W      D3
0948: 66F4          BNE.S      $093E
094A: 45EDC366      LEA        -15514(A5),A2                  ; g_field_14
094E: 6004          BRA.S      $0954
0950: 53363080      MOVE.B     -128(A6,D3.W),-(A1)
0954: 161A          MOVE.B     (A2)+,D3
0956: 4883          EXT.W      D3
0958: 4A43          TST.W      D3
095A: 66F4          BNE.S      $0950
095C: 246D99D2      MOVEA.L    -26158(A5),A2
0960: 6014          BRA.S      $0976
0962: 18363080      MOVE.B     -128(A6,D3.W),D4
0966: 4884          EXT.W      D4
0968: 6008          BRA.S      $0972
096A: 2047          MOVEA.L    D7,A0
096C: 5287          MOVE.B     D7,(A1)
096E: 1083          MOVE.B     D3,(A0)
0970: 53444A44      MOVE.B     D4,19012(A1)
0974: 6EF4          BGT.S      $096A
0976: 161A          MOVE.B     (A2)+,D3
0978: 4883          EXT.W      D3
097A: 4A43          TST.W      D3
097C: 66E4          BNE.S      $0962
097E: 2047          MOVEA.L    D7,A0
0980: 4210          CLR.B      (A0)
0982: 2007          MOVE.L     D7,D0
0984: 9086          MOVE.B     D6,(A0)
0986: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
098A: 4E5E          UNLK       A6
098C: 4E75          RTS        


; ======= Function at 0x098E =======
098E: 4E560000      LINK       A6,#0
0992: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0996: 286D99D2      MOVEA.L    -26158(A5),A4
099A: 600A          BRA.S      $09A6
099C: 204D          MOVEA.L    A5,A0
099E: D0C7          MOVE.B     D7,(A0)+
09A0: 4228A54E      CLR.B      -23218(A0)
09A4: 528C          MOVE.B     A4,(A1)
09A6: 1E14          MOVE.B     (A4),D7
09A8: 4887          EXT.W      D7
09AA: 4A47          TST.W      D7
09AC: 66EE          BNE.S      $099C
09AE: 286E0008      MOVEA.L    8(A6),A4
09B2: 600A          BRA.S      $09BE
09B4: 204D          MOVEA.L    A5,A0
09B6: D0C7          MOVE.B     D7,(A0)+
09B8: 5228A54E      MOVE.B     -23218(A0),D1
09BC: 528C          MOVE.B     A4,(A1)
09BE: 1E14          MOVE.B     (A4),D7
09C0: 4887          EXT.W      D7
09C2: 4A47          TST.W      D7
09C4: 66EE          BNE.S      $09B4
09C6: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
09CA: 4E5E          UNLK       A6
09CC: 4E75          RTS        
