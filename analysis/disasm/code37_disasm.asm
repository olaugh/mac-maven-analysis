;======================================================================
; CODE 37 Disassembly
; File: /tmp/maven_code_37.bin
; Header: JT offset=2560, JT entries=4
; Code size: 5344 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FFA0      LINK       A6,#-96                        ; frame=96
0004: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0008: 3F3C0220      MOVE.W     #$0220,-(A7)
000C: 486DBCFE      PEA        -17154(A5)                     ; g_state1
0010: 4EAD0D7A      JSR        3450(A5)                       ; JT[3450]
0014: 4A40          TST.W      D0
0016: 5C8F          MOVE.B     A7,(A6)
0018: 6700008C      BEQ.W      $00A8
001C: 486EFFA0      PEA        -96(A6)
0020: 2F2E0008      MOVE.L     8(A6),-(A7)
0024: 4EBA00AC      JSR        172(PC)
0028: 3B7C0007BCFC  MOVE.W     #$0007,-17156(A5)
002E: 7022          MOVEQ      #34,D0
0030: 2E80          MOVE.L     D0,(A7)
0032: 486DD60E      PEA        -10738(A5)                     ; A5-10738
0036: 4EAD01AA      JSR        426(A5)                        ; JT[426]
003A: 7022          MOVEQ      #34,D0
003C: 2E80          MOVE.L     D0,(A7)
003E: 486DD630      PEA        -10704(A5)                     ; A5-10704
0042: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0046: 206DD5FA      MOVEA.L    -10758(A5),A0
004A: 117C00080020  MOVE.B     #$08,32(A0)
0050: 70FF          MOVEQ      #-1,D0
0052: D0ADD5FA      MOVE.B     -10758(A5),(A0)                ; A5-10758
0056: 2B40D606      MOVE.L     D0,-10746(A5)
005A: 41EDBD86      LEA        -17018(A5),A0                  ; A5-17018
005E: 2B48D5FE      MOVE.L     A0,-10754(A5)
0062: 3EBC0008      MOVE.W     #$0008,(A7)
0066: 4EBA07E2      JSR        2018(PC)
006A: 41ED961A      LEA        -27110(A5),A0                  ; A5-27110
006E: 2B48D602      MOVE.L     A0,-10750(A5)
0072: 7E00          MOVEQ      #0,D7
0074: 49EDD148      LEA        -11960(A5),A4                  ; A5-11960
0078: 4FEF0010      LEA        16(A7),A7
007C: 2B54D140      MOVE.L     (A4),-11968(A5)
0080: 3B47D548      MOVE.W     D7,-10936(A5)
0084: 204D          MOVEA.L    A5,A0
0086: 2007          MOVE.L     D7,D0
0088: 48C0          EXT.L      D0
008A: E788D1C0      MOVE.L     A0,-64(A3,A5.W)
008E: 2B68D14CD144  MOVE.L     -11956(A0),-11964(A5)
0094: 6734          BEQ.S      $00CA
0096: 2F2DD144      MOVE.L     -11964(A5),-(A7)               ; A5-11964
009A: 4EBA01AE      JSR        430(PC)
009E: 588F          MOVE.B     A7,(A4)
00A0: 5247          MOVEA.B    D7,A1
00A2: 508C          MOVE.B     A4,(A0)
00A4: 60D6          BRA.S      $007C
00A6: 7E01          MOVEQ      #1,D7
00A8: 47EEFFC4      LEA        -60(A6),A3
00AC: 6008          BRA.S      $00B6
00AE: 36BCFFFF      MOVE.W     #$FFFF,(A3)
00B2: 5247          MOVEA.B    D7,A1
00B4: 548B          MOVE.B     A3,(A2)
00B6: 0C47001F      CMPI.W     #$001F,D7
00BA: 6DF2          BLT.S      $00AE
00BC: 2F2E0008      MOVE.L     8(A6),-(A7)
00C0: 486EFFC2      PEA        -62(A6)
00C4: 4EBA06EC      JSR        1772(PC)
00C8: 508F          MOVE.B     A7,(A0)
00CA: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
00CE: 4E5E          UNLK       A6
00D0: 4E75          RTS        


; ======= Function at 0x00D2 =======
00D2: 4E560000      LINK       A6,#0
00D6: 48780080      PEA        $0080.W
00DA: 486DCE84      PEA        -12668(A5)                     ; A5-12668
00DE: 4EAD01AA      JSR        426(A5)                        ; JT[426]
00E2: 2B6E000CD5FA  MOVE.L     12(A6),-10758(A5)
00E8: 7022          MOVEQ      #34,D0
00EA: 2E80          MOVE.L     D0,(A7)
00EC: 2F2E000C      MOVE.L     12(A6),-(A7)
00F0: 4EAD01AA      JSR        426(A5)                        ; JT[426]
00F4: 48780080      PEA        $0080.W
00F8: 486DA54E      PEA        -23218(A5)                     ; A5-23218
00FC: 486DD678      PEA        -10632(A5)                     ; A5-10632
0100: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0104: 2B6E0008D674  MOVE.L     8(A6),-10636(A5)
010A: 4E5E          UNLK       A6
010C: 4E75          RTS        


; ======= Function at 0x010E =======
010E: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0112: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0116: 3F3C0011      MOVE.W     #$0011,-(A7)
011A: 486DF94E      PEA        -1714(A5)                      ; A5-1714
011E: 4EAD0D7A      JSR        3450(A5)                       ; JT[3450]
0122: 4A40          TST.W      D0
0124: 5C8F          MOVE.B     A7,(A6)
0126: 6604          BNE.S      $012C
0128: 4EAD01A2      JSR        418(A5)                        ; JT[418]
012C: 7801          MOVEQ      #1,D4
012E: 49EDA99A      LEA        -22118(A5),A4                  ; A5-22118
0132: 41EDBD0F      LEA        -17137(A5),A0                  ; A5-17137
0136: 2A08          MOVE.L     A0,D5
0138: 60000100      BRA.W      $023C
013C: 0C440001      CMPI.W     #$0001,D4
0140: 6706          BEQ.S      $0148
0142: 0C440010      CMPI.W     #$0010,D4
0146: 6608          BNE.S      $0150
0148: 41EDF94E      LEA        -1714(A5),A0                   ; A5-1714
014C: 2008          MOVE.L     A0,D0
014E: 600E          BRA.S      $015E
0150: 70FF          MOVEQ      #-1,D0
0152: D044          MOVEA.B    D4,A0
0154: C1FC001141ED  ANDA.L     #$001141ED,A0
015A: BCFE          MOVE.W     ???,(A6)+
015C: D088          MOVE.B     A0,(A0)
015E: 2C00          MOVE.L     D0,D6
0160: 2B45D5FE      MOVE.L     D5,-10754(A5)
0164: 0C44000F      CMPI.W     #$000F,D4
0168: 6706          BEQ.S      $0170
016A: 0C44001E      CMPI.W     #$001E,D4
016E: 6608          BNE.S      $0178
0170: 41EDF94E      LEA        -1714(A5),A0                   ; A5-1714
0174: 2008          MOVE.L     A0,D0
0176: 600E          BRA.S      $0186
0178: 7001          MOVEQ      #1,D0
017A: D044          MOVEA.B    D4,A0
017C: C1FC001141ED  ANDA.L     #$001141ED,A0
0182: BCFE          MOVE.W     ???,(A6)+
0184: D088          MOVE.B     A0,(A0)
0186: 2E00          MOVE.L     D0,D7
0188: 47EC0004      LEA        4(A4),A3
018C: 7601          MOVEQ      #1,D3
018E: 60000098      BRA.W      $022A
0192: 246DD5FE      MOVEA.L    -10754(A5),A2
0196: D4C3          MOVE.B     D3,(A2)+
0198: 4A12          TST.B      (A2)
019A: 6712          BEQ.S      $01AE
019C: 1012          MOVE.B     (A2),D0
019E: 4880          EXT.W      D0
01A0: 204D          MOVEA.L    A5,A0
01A2: 48C0          EXT.L      D0
01A4: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
01A8: 26A89852      MOVE.L     -26542(A0),(A3)
01AC: 6076          BRA.S      $0224
01AE: 3043          MOVEA.W    D3,A0
01B0: 4A306800      TST.B      0(A0,D6.L)
01B4: 660E          BNE.S      $01C4
01B6: 3043          MOVEA.W    D3,A0
01B8: 4A307800      TST.B      0(A0,D7.L)
01BC: 6606          BNE.S      $01C4
01BE: 70FF          MOVEQ      #-1,D0
01C0: 2680          MOVE.L     D0,(A3)
01C2: 6060          BRA.S      $0224
01C4: 486EFFFC      PEA        -4(A6)
01C8: 486EFFFE      PEA        -2(A6)
01CC: 3F03          MOVE.W     D3,-(A7)
01CE: 3F04          MOVE.W     D4,-(A7)
01D0: 4EAD0922      JSR        2338(A5)                       ; JT[2338]
01D4: 7011          MOVEQ      #17,D0
01D6: C1EEFFFE      ANDA.L     -2(A6),A0
01DA: D08D          MOVE.B     A5,(A0)
01DC: 346EFFFC      MOVEA.W    -4(A6),A2
01E0: 45EABCFD      LEA        -17155(A2),A2
01E4: D08A          MOVE.B     A2,(A0)
01E6: 2440          MOVEA.L    D0,A2
01E8: 4FEF000C      LEA        12(A7),A7
01EC: 6002          BRA.S      $01F0
01EE: 538A4A12      MOVE.B     A2,18(A1,D4.L*2)
01F2: 66FA          BNE.S      $01EE
01F4: 528A          MOVE.B     A2,(A1)
01F6: 4293          CLR.L      (A3)
01F8: 206D99D2      MOVEA.L    -26158(A5),A0
01FC: 48680001      PEA        1(A0)
0200: 2F0A          MOVE.L     A2,-(A7)
0202: 4EBA01C6      JSR        454(PC)
0206: 2440          MOVEA.L    D0,A2
0208: 508F          MOVE.B     A7,(A0)
020A: 6014          BRA.S      $0220
020C: 1012          MOVE.B     (A2),D0
020E: 4880          EXT.W      D0
0210: 204D          MOVEA.L    A5,A0
0212: 48C0          EXT.L      D0
0214: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0218: 20289852      MOVE.L     -26542(A0),D0
021C: 8193          OR.L       D0,(A3)
021E: 528A          MOVE.B     A2,(A1)
0220: 4A12          TST.B      (A2)
0222: 66E8          BNE.S      $020C
0224: 5243          MOVEA.B    D3,A1
0226: 588B          MOVE.B     A3,(A4)
0228: 0C430010      CMPI.W     #$0010,D3
022C: 6D00FF64      BLT.W      $0194
0230: 5244          MOVEA.B    D4,A1
0232: 49EC0044      LEA        68(A4),A4
0236: 7011          MOVEQ      #17,D0
0238: DA80          MOVE.B     D0,(A5)
023A: 0C44001F      CMPI.W     #$001F,D4
023E: 6D00FEFC      BLT.W      $013E
0242: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0246: 4E5E          UNLK       A6
0248: 4E75          RTS        


; ======= Function at 0x024A =======
024A: 4E560000      LINK       A6,#0
024E: 48E70F18      MOVEM.L    D4/D5/D6/D7/A3/A4,-(SP)        ; save
0252: 52ADD606      MOVE.B     -10746(A5),(A1)                ; A5-10746
0256: 202E0008      MOVE.L     8(A6),D0
025A: 52AE0008      MOVE.B     8(A6),(A1)
025E: E588D0AD      MOVE.L     A0,-83(A2,A5.W)
0262: D1402040      MOVE.B     D0,8256(A0)
0266: 2E10          MOVE.L     (A0),D7
0268: 206DD606      MOVEA.L    -10746(A5),A0
026C: 1087          MOVE.B     D7,(A0)
026E: 1C07          MOVE.B     D7,D6
0270: 206DD606      MOVEA.L    -10746(A5),A0
0274: 7000          MOVEQ      #0,D0
0276: 1010          MOVE.B     (A0),D0
0278: 224D          MOVEA.L    A5,A1
027A: D3C04A29FBD8  MOVE.B     D0,$4A29FBD8
0280: 6B04          BMI.S      $0286
0282: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0286: 1006          MOVE.B     D6,D0
0288: 4880          EXT.W      D0
028A: 49EDD678      LEA        -10632(A5),A4                  ; A5-10632
028E: D8C0          MOVE.B     D0,(A4)+
0290: 4A14          TST.B      (A4)
0292: 670000B0      BEQ.W      $0346
0296: 5314          MOVE.B     (A4),-(A1)
0298: 08070008      BTST       #8,D7
029C: 6700008C      BEQ.W      $032C
02A0: 202DD606      MOVE.L     -10746(A5),D0                  ; A5-10746
02A4: 90ADD5FA      MOVE.B     -10758(A5),(A0)                ; A5-10758
02A8: 7A08          MOVEQ      #8,D5
02AA: 9A40          MOVEA.B    D0,A5
02AC: 6076          BRA.S      $0324
02AE: 206DD5FA      MOVEA.L    -10758(A5),A0
02B2: 11450021      MOVE.B     D5,33(A0)
02B6: 206DD5FA      MOVEA.L    -10758(A5),A0
02BA: 42A80018      CLR.L      24(A0)
02BE: 3805          MOVE.W     D5,D4
02C0: 266DD5FA      MOVEA.L    -10758(A5),A3
02C4: 604C          BRA.S      $0312
02C6: 1013          MOVE.B     (A3),D0
02C8: 4880          EXT.W      D0
02CA: 3F00          MOVE.W     D0,-(A7)
02CC: 4EAD07D2      JSR        2002(A5)                       ; JT[2002]
02D0: 4A40          TST.W      D0
02D2: 548F          MOVE.B     A7,(A2)
02D4: 6738          BEQ.S      $030E
02D6: 204D          MOVEA.L    A5,A0
02D8: D0C4          MOVE.B     D4,(A0)+
02DA: 0C2800019609  CMPI.B     #$0001,-27127(A0)
02E0: 6E24          BGT.S      $0306
02E2: 204D          MOVEA.L    A5,A0
02E4: D0C4          MOVE.B     D4,(A0)+
02E6: 0C2800019829  CMPI.B     #$0001,-26583(A0)
02EC: 6E18          BGT.S      $0306
02EE: 204D          MOVEA.L    A5,A0
02F0: D0C4          MOVE.B     D4,(A0)+
02F2: 0C280001962B  CMPI.B     #$0001,-27093(A0)
02F8: 6E0C          BGT.S      $0306
02FA: 204D          MOVEA.L    A5,A0
02FC: D0C4          MOVE.B     D4,(A0)+
02FE: 0C280001984B  CMPI.B     #$0001,-26549(A0)
0304: 6F08          BLE.S      $030E
0306: 206DD5FA      MOVEA.L    -10758(A5),A0
030A: 53A80018528B  MOVE.B     24(A0),-117(A1,D5.W*2)
0310: 5244          MOVEA.B    D4,A1
0312: 4A13          TST.B      (A3)
0314: 66B0          BNE.S      $02C6
0316: 4EBA0B2A      JSR        2858(PC)
031A: 206DD5FA      MOVEA.L    -10758(A5),A0
031E: 42A80018      CLR.L      24(A0)
0322: 5245          MOVEA.B    D5,A1
0324: 0C450008      CMPI.W     #$0008,D5
0328: 6F84          BLE.S      $02AE
032A: 2007          MOVE.L     D7,D0
032C: 720A          MOVEQ      #10,D1
032E: E2A8670E      MOVE.L     26382(A0),(A1)
0332: 2007          MOVE.L     D7,D0
0334: 720A          MOVEQ      #10,D1
0336: E2A82F00      MOVE.L     12032(A0),(A1)
033A: 4EBAFF0E      JSR        -242(PC)
033E: 588F          MOVE.B     A7,(A4)
0340: 5214          MOVE.B     (A4),D1
0342: 600A          BRA.S      $034E
0344: 49EDD6B7      LEA        -10569(A5),A4                  ; A5-10569
0348: 4A14          TST.B      (A4)
034A: 6600FF4A      BNE.W      $0298
034E: 08070009      BTST       #9,D7
0352: 6700FF02      BEQ.W      $0258
0356: 206DD606      MOVEA.L    -10746(A5),A0
035A: 53ADD6064210  MOVE.B     -10746(A5),16(A1,D4.W*2)       ; A5-10746
0360: 4CDF18F0      MOVEM.L    (SP)+,D4/D5/D6/D7/A3/A4        ; restore
0364: 4E5E          UNLK       A6
0366: 4E75          RTS        


; ======= Function at 0x0368 =======
0368: 4E560000      LINK       A6,#0
036C: 48E70700      MOVEM.L    D5/D6/D7,-(SP)                 ; save
0370: 206E0008      MOVEA.L    8(A6),A0
0374: 1E10          MOVE.B     (A0),D7
0376: 6606          BNE.S      $037E
0378: 202DD144      MOVE.L     -11964(A5),D0                  ; A5-11964
037C: 6044          BRA.S      $03C2
037E: 2C2DD144      MOVE.L     -11964(A5),D6                  ; A5-11964
0382: 2006          MOVE.L     D6,D0
0384: E588D0AD      MOVE.L     A0,-83(A2,A5.W)
0388: D1402040      MOVE.B     D0,8256(A0)
038C: 2A10          MOVE.L     (A0),D5
038E: BE05          MOVE.W     D5,D7
0390: 661E          BNE.S      $03B0
0392: 2C05          MOVE.L     D5,D6
0394: 700A          MOVEQ      #10,D0
0396: E0A6          MOVE.L     -(A6),(A0)
0398: 52AE0008      MOVE.B     8(A6),(A1)
039C: 206E0008      MOVEA.L    8(A6),A0
03A0: 1E10          MOVE.B     (A0),D7
03A2: 6604          BNE.S      $03A8
03A4: 2006          MOVE.L     D6,D0
03A6: 601A          BRA.S      $03C2
03A8: 4A86          TST.L      D6
03AA: 66D6          BNE.S      $0382
03AC: 70FF          MOVEQ      #-1,D0
03AE: 6012          BRA.S      $03C2
03B0: 08050009      BTST       #9,D5
03B4: 6604          BNE.S      $03BA
03B6: BE05          MOVE.W     D5,D7
03B8: 6C04          BGE.S      $03BE
03BA: 70FF          MOVEQ      #-1,D0
03BC: 6004          BRA.S      $03C2
03BE: 5286          MOVE.B     D6,(A1)
03C0: 60C0          BRA.S      $0382
03C2: 4CDF00E0      MOVEM.L    (SP)+,D5/D6/D7                 ; restore
03C6: 4E5E          UNLK       A6
03C8: 4E75          RTS        


; ======= Function at 0x03CA =======
03CA: 4E56FFF2      LINK       A6,#-14                        ; frame=14
03CE: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
03D2: 266E0008      MOVEA.L    8(A6),A3
03D6: 246E000C      MOVEA.L    12(A6),A2
03DA: 2D4BFFFC      MOVE.L     A3,-4(A6)
03DE: 2D4AFFF8      MOVE.L     A2,-8(A6)
03E2: 49EDF90E      LEA        -1778(A5),A4                   ; A5-1778
03E6: 426EFFF6      CLR.W      -10(A6)
03EA: 41EDD148      LEA        -11960(A5),A0                  ; A5-11960
03EE: 2D48FFF2      MOVE.L     A0,-14(A6)
03F2: 206EFFF2      MOVEA.L    -14(A6),A0
03F6: 2B50D140      MOVE.L     (A0),-11968(A5)
03FA: 302EFFF6      MOVE.W     -10(A6),D0
03FE: 3B40D548      MOVE.W     D0,-10936(A5)
0402: 224D          MOVEA.L    A5,A1
0404: 48C0          EXT.L      D0
0406: E788D3C0      MOVE.L     A0,-64(A3,A5.W*2)
040A: 2B69D14CD144  MOVE.L     -11956(A1),-11964(A5)
0410: 670000B4      BEQ.W      $04C8
0414: 266EFFFC      MOVEA.L    -4(A6),A3
0418: 246EFFF8      MOVEA.L    -8(A6),A2
041C: 2F0B          MOVE.L     A3,-(A7)
041E: 4EBAFF48      JSR        -184(PC)
0422: 2C00          MOVE.L     D0,D6
0424: 4A86          TST.L      D6
0426: 588F          MOVE.B     A7,(A4)
0428: 6F000090      BLE.W      $04BC
042C: 4A1B          TST.B      (A3)+
042E: 66FC          BNE.S      $042C
0430: 2006          MOVE.L     D6,D0
0432: E588D0AD      MOVE.L     A0,-83(A2,A5.W)
0436: D1402040      MOVE.B     D0,8256(A0)
043A: 2610          MOVE.L     (A0),D3
043C: 1812          MOVE.B     (A2),D4
043E: B803          MOVE.W     D3,D4
0440: 6C04          BGE.S      $0446
0442: 528A          MOVE.B     A2,(A1)
0444: 6070          BRA.S      $04B6
0446: B803          MOVE.W     D3,D4
0448: 6658          BNE.S      $04A2
044A: 4A13          TST.B      (A3)
044C: 660A          BNE.S      $0458
044E: 08030008      BTST       #8,D3
0452: 674C          BEQ.S      $04A0
0454: 18C3          MOVE.B     D3,(A4)+
0456: 6048          BRA.S      $04A0
0458: 2803          MOVE.L     D3,D4
045A: 700A          MOVEQ      #10,D0
045C: E0AC6740      MOVE.L     26432(A4),(A0)
0460: 2E0B          MOVE.L     A3,D7
0462: 2004          MOVE.L     D4,D0
0464: E588D0AD      MOVE.L     A0,-83(A2,A5.W)
0468: D1402040      MOVE.B     D0,8256(A0)
046C: 2A10          MOVE.L     (A0),D5
046E: 2047          MOVEA.L    D7,A0
0470: BA10          MOVE.W     (A0),D5
0472: 661C          BNE.S      $0490
0474: 5287          MOVE.B     D7,(A1)
0476: 2047          MOVEA.L    D7,A0
0478: 4A10          TST.B      (A0)
047A: 660A          BNE.S      $0486
047C: 08050008      BTST       #8,D5
0480: 671E          BEQ.S      $04A0
0482: 18C3          MOVE.B     D3,(A4)+
0484: 601A          BRA.S      $04A0
0486: 2805          MOVE.L     D5,D4
0488: 700A          MOVEQ      #10,D0
048A: E0AC6712      MOVE.L     26386(A4),(A0)
048E: 60D2          BRA.S      $0462
0490: 08050009      BTST       #9,D5
0494: 660A          BNE.S      $04A0
0496: 2047          MOVEA.L    D7,A0
0498: BA10          MOVE.W     (A0),D5
049A: 6E04          BGT.S      $04A0
049C: 5284          MOVE.B     D4,(A1)
049E: 60C2          BRA.S      $0462
04A0: 528A          MOVE.B     A2,(A1)
04A2: 08030009      BTST       #9,D3
04A6: 6612          BNE.S      $04BA
04A8: 5286          MOVE.B     D6,(A1)
04AA: 2006          MOVE.L     D6,D0
04AC: E588D0AD      MOVE.L     A0,-83(A2,A5.W)
04B0: D1402040      MOVE.B     D0,8256(A0)
04B4: 2610          MOVE.L     (A0),D3
04B6: 4A12          TST.B      (A2)
04B8: 6682          BNE.S      $043C
04BA: 526EFFF6      MOVEA.B    -10(A6),A1
04BE: 50AEFFF2      MOVE.B     -14(A6),(A0)
04C2: 6000FF2E      BRA.W      $03F4
04C6: 4214          CLR.B      (A4)
04C8: 41EDF90E      LEA        -1778(A5),A0                   ; A5-1778
04CC: 2008          MOVE.L     A0,D0
04CE: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
04D2: 4E5E          UNLK       A6
04D4: 4E75          RTS        


; ======= Function at 0x04D6 =======
04D6: 4E560000      LINK       A6,#0
04DA: 204D          MOVEA.L    A5,A0
04DC: 302E000A      MOVE.W     10(A6),D0
04E0: 48C0          EXT.L      D0
04E2: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
04E6: 224D          MOVEA.L    A5,A1
04E8: 302E0008      MOVE.W     8(A6),D0
04EC: 48C0          EXT.L      D0
04EE: E588D3C0      MOVE.L     A0,-64(A2,A5.W*2)
04F2: 70FF          MOVEQ      #-1,D0
04F4: D0A999D6      MOVE.B     -26154(A1),(A0)
04F8: 4680          NOT.L      D0
04FA: 72FF          MOVEQ      #-1,D1
04FC: D2A899DA      MOVE.B     -26150(A0),(A1)
0500: C081          AND.L      D1,D0
0502: 4E5E          UNLK       A6
0504: 4E75          RTS        


; ======= Function at 0x0506 =======
0506: 4E560000      LINK       A6,#0
050A: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
050E: 3C2E000A      MOVE.W     10(A6),D6
0512: 7011          MOVEQ      #17,D0
0514: C1EE0008      ANDA.L     8(A6),A0
0518: 49EDBCFE      LEA        -17154(A5),A4                  ; g_state1
051C: D08C          MOVE.B     A4,(A0)
051E: 2840          MOVEA.L    D0,A4
0520: 7E00          MOVEQ      #0,D7
0522: 600A          BRA.S      $052E
0524: 4A346000      TST.B      0(A4,D6.W)
0528: 6602          BNE.S      $052C
052A: 5247          MOVEA.B    D7,A1
052C: 53464A46      MOVE.B     D6,19014(A1)
0530: 6706          BEQ.S      $0538
0532: BE6E000C      MOVEA.W    12(A6),A7
0536: 6DEC          BLT.S      $0524
0538: 7001          MOVEQ      #1,D0
053A: D046          MOVEA.B    D6,A0
053C: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
0540: 4E5E          UNLK       A6
0542: 4E75          RTS        


; ======= Function at 0x0544 =======
0544: 4E56FFA8      LINK       A6,#-88                        ; frame=88
0548: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
054C: 286E0008      MOVEA.L    8(A6),A4
0550: 2F2E0014      MOVE.L     20(A6),-(A7)
0554: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0558: 3A00          MOVE.W     D0,D5
055A: 0C450007      CMPI.W     #$0007,D5
055E: 588F          MOVE.B     A7,(A4)
0560: 6F02          BLE.S      $0564
0562: 7A07          MOVEQ      #7,D5
0564: 182C0021      MOVE.B     33(A4),D4
0568: 4884          EXT.W      D4
056A: 1C2C0020      MOVE.B     32(A4),D6
056E: 4886          EXT.W      D6
0570: 7011          MOVEQ      #17,D0
0572: C1C6          ANDA.L     D6,A0
0574: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
0578: D088          MOVE.B     A0,(A0)
057A: 3044          MOVEA.W    D4,A0
057C: D088          MOVE.B     A0,(A0)
057E: 2D40FFB0      MOVE.L     D0,-80(A6)
0582: 4878003E      PEA        $003E.W
0586: 486EFFC0      PEA        -64(A6)
058A: 4EAD01AA      JSR        426(A5)                        ; JT[426]
058E: 7EFF          MOVEQ      #-1,D7
0590: DE44          MOVEA.B    D4,A7
0592: 2E8C          MOVE.L     A4,(A7)
0594: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0598: D044          MOVEA.B    D4,A0
059A: 3E80          MOVE.W     D0,(A7)
059C: 3F05          MOVE.W     D5,-(A7)
059E: 3F07          MOVE.W     D7,-(A7)
05A0: 3F06          MOVE.W     D6,-(A7)
05A2: 4EBAFF62      JSR        -158(PC)
05A6: 588F          MOVE.B     A7,(A4)
05A8: 3E80          MOVE.W     D0,(A7)
05AA: 4EBAFF2A      JSR        -214(PC)
05AE: 204E          MOVEA.L    A6,A0
05B0: D0C6          MOVE.B     D6,(A0)+
05B2: 817060C0      OR.W       D0,-64(A0,D6.W)
05B6: 0C440001      CMPI.W     #$0001,D4
05BA: 4FEF000A      LEA        10(A7),A7
05BE: 673A          BEQ.S      $05FA
05C0: 486EFFB8      PEA        -72(A6)
05C4: 486EFFBA      PEA        -70(A6)
05C8: 3F07          MOVE.W     D7,-(A7)
05CA: 3F06          MOVE.W     D6,-(A7)
05CC: 4EAD0922      JSR        2338(A5)                       ; JT[2338]
05D0: 3EAEFFB8      MOVE.W     -72(A6),(A7)
05D4: 3F05          MOVE.W     D5,-(A7)
05D6: 3F2EFFB8      MOVE.W     -72(A6),-(A7)
05DA: 3F2EFFBA      MOVE.W     -70(A6),-(A7)
05DE: 4EBAFF26      JSR        -218(PC)
05E2: 588F          MOVE.B     A7,(A4)
05E4: 3E80          MOVE.W     D0,(A7)
05E6: 4EBAFEEE      JSR        -274(PC)
05EA: 322EFFBA      MOVE.W     -70(A6),D1
05EE: 48C1          EXT.L      D1
05F0: D281          MOVE.B     D1,(A1)
05F2: 817618C0      OR.W       D0,-64(A6,D1.L)
05F6: 4FEF000E      LEA        14(A7),A7
05FA: 2D4CFFA8      MOVE.L     A4,-88(A6)
05FE: 7E01          MOVEQ      #1,D7
0600: DE46          MOVEA.B    D6,A7
0602: 7002          MOVEQ      #2,D0
0604: D045          MOVEA.B    D5,A0
0606: 3D40FFAE      MOVE.W     D0,-82(A6)
060A: 72FF          MOVEQ      #-1,D1
060C: D246          MOVEA.B    D6,A1
060E: 3D41FFAC      MOVE.W     D1,-84(A6)
0612: 60000102      BRA.W      $0718
0616: 206EFFB0      MOVEA.L    -80(A6),A0
061A: 4A10          TST.B      (A0)
061C: 660000EE      BNE.W      $070E
0620: 4A44          TST.W      D4
0622: 6F06          BLE.S      $062A
0624: 0C440010      CMPI.W     #$0010,D4
0628: 6D04          BLT.S      $062E
062A: 4EAD01A2      JSR        418(A5)                        ; JT[418]
062E: 3607          MOVE.W     D7,D3
0630: 45F630C0      LEA        -64(A6,D3.W),A2
0634: D4C3          MOVE.B     D3,(A2)+
0636: 7011          MOVEQ      #17,D0
0638: C1C3          ANDA.L     D3,A0
063A: 47EDBCFE      LEA        -17154(A5),A3                  ; g_state1
063E: D08B          MOVE.B     A3,(A0)
0640: 2640          MOVEA.L    D0,A3
0642: 6028          BRA.S      $066C
0644: 4A334000      TST.B      0(A3,D4.W)
0648: 661A          BNE.S      $0664
064A: 3F04          MOVE.W     D4,-(A7)
064C: 3F05          MOVE.W     D5,-(A7)
064E: 3F04          MOVE.W     D4,-(A7)
0650: 3F03          MOVE.W     D3,-(A7)
0652: 4EBAFEB2      JSR        -334(PC)
0656: 588F          MOVE.B     A7,(A4)
0658: 3E80          MOVE.W     D0,(A7)
065A: 4EBAFE7A      JSR        -390(PC)
065E: 8152          OR.W       D0,(A2)
0660: 588F          MOVE.B     A7,(A4)
0662: 6014          BRA.S      $0678
0664: 5243          MOVEA.B    D3,A1
0666: 548A          MOVE.B     A2,(A2)
0668: 47EB0011      LEA        17(A3),A3
066C: 0C43001F      CMPI.W     #$001F,D3
0670: 6706          BEQ.S      $0678
0672: 0C430010      CMPI.W     #$0010,D3
0676: 66CC          BNE.S      $0644
0678: 0C43001F      CMPI.W     #$001F,D3
067C: 6706          BEQ.S      $0684
067E: 0C430010      CMPI.W     #$0010,D3
0682: 6602          BNE.S      $0686
0684: 5343486E      MOVE.B     D3,18542(A1)
0688: FFB8486EFFBA  MOVE.W     $486E.W,-70(A7,A7.L*8)
068E: 3F04          MOVE.W     D4,-(A7)
0690: 3F03          MOVE.W     D3,-(A7)
0692: 4EAD0922      JSR        2338(A5)                       ; JT[2338]
0696: 3EAEFFB8      MOVE.W     -72(A6),(A7)
069A: 3F2EFFAE      MOVE.W     -82(A6),-(A7)
069E: 3F2EFFB8      MOVE.W     -72(A6),-(A7)
06A2: 3F2EFFBA      MOVE.W     -70(A6),-(A7)
06A6: 4EBAFE5E      JSR        -418(PC)
06AA: 588F          MOVE.B     A7,(A4)
06AC: 3E80          MOVE.W     D0,(A7)
06AE: 4EBAFE26      JSR        -474(PC)
06B2: 322EFFBA      MOVE.W     -70(A6),D1
06B6: 48C1          EXT.L      D1
06B8: D281          MOVE.B     D1,(A1)
06BA: 817618C0      OR.W       D0,-64(A6,D1.L)
06BE: 362EFFAC      MOVE.W     -84(A6),D3
06C2: 45F630C0      LEA        -64(A6,D3.W),A2
06C6: D4C3          MOVE.B     D3,(A2)+
06C8: 7011          MOVEQ      #17,D0
06CA: C1C3          ANDA.L     D3,A0
06CC: 47EDBCFE      LEA        -17154(A5),A3                  ; g_state1
06D0: D08B          MOVE.B     A3,(A0)
06D2: 2640          MOVEA.L    D0,A3
06D4: 4FEF000E      LEA        14(A7),A7
06D8: 6028          BRA.S      $0702
06DA: 4A334000      TST.B      0(A3,D4.W)
06DE: 661A          BNE.S      $06FA
06E0: 3F04          MOVE.W     D4,-(A7)
06E2: 3F05          MOVE.W     D5,-(A7)
06E4: 3F04          MOVE.W     D4,-(A7)
06E6: 3F03          MOVE.W     D3,-(A7)
06E8: 4EBAFE1C      JSR        -484(PC)
06EC: 588F          MOVE.B     A7,(A4)
06EE: 3E80          MOVE.W     D0,(A7)
06F0: 4EBAFDE4      JSR        -540(PC)
06F4: 8152          OR.W       D0,(A2)
06F6: 588F          MOVE.B     A7,(A4)
06F8: 6012          BRA.S      $070C
06FA: 5343558A      MOVE.B     D3,21898(A1)
06FE: 47EBFFEF      LEA        -17(A3),A3
0702: 4A43          TST.W      D3
0704: 6706          BEQ.S      $070C
0706: 0C43000F      CMPI.W     #$000F,D3
070A: 66CE          BNE.S      $06DA
070C: 52AEFFB0      MOVE.B     -80(A6),(A1)
0710: 52AEFFA8      MOVE.B     -88(A6),(A1)
0714: 5244          MOVEA.B    D4,A1
0716: 206EFFA8      MOVEA.L    -88(A6),A0
071A: 4A10          TST.B      (A0)
071C: 6600FEF8      BNE.W      $0618
0720: 0C440010      CMPI.W     #$0010,D4
0724: 673A          BEQ.S      $0760
0726: 486EFFB8      PEA        -72(A6)
072A: 486EFFBA      PEA        -70(A6)
072E: 3F04          MOVE.W     D4,-(A7)
0730: 3F06          MOVE.W     D6,-(A7)
0732: 4EAD0922      JSR        2338(A5)                       ; JT[2338]
0736: 3EAEFFB8      MOVE.W     -72(A6),(A7)
073A: 3F05          MOVE.W     D5,-(A7)
073C: 3F2EFFB8      MOVE.W     -72(A6),-(A7)
0740: 3F2EFFBA      MOVE.W     -70(A6),-(A7)
0744: 4EBAFDC0      JSR        -576(PC)
0748: 588F          MOVE.B     A7,(A4)
074A: 3E80          MOVE.W     D0,(A7)
074C: 4EBAFD88      JSR        -632(PC)
0750: 322EFFBA      MOVE.W     -70(A6),D1
0754: 48C1          EXT.L      D1
0756: D281          MOVE.B     D1,(A1)
0758: 817618C0      OR.W       D0,-64(A6,D1.L)
075C: 4FEF000E      LEA        14(A7),A7
0760: 2F2E000C      MOVE.L     12(A6),-(A7)
0764: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
0768: 4257          CLR.W      (A7)
076A: 2F2E000C      MOVE.L     12(A6),-(A7)
076E: 2F0C          MOVE.L     A4,-(A7)
0770: 4EAD0942      JSR        2370(A5)                       ; JT[2370]
0774: 2EAE0014      MOVE.L     20(A6),(A7)
0778: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
077C: 3EBC0011      MOVE.W     #$0011,(A7)
0780: 486DF94E      PEA        -1714(A5)                      ; A5-1714
0784: 4EAD0D7A      JSR        3450(A5)                       ; JT[3450]
0788: 4A40          TST.W      D0
078A: 4FEF0010      LEA        16(A7),A7
078E: 6604          BNE.S      $0794
0790: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0794: 2F2E0010      MOVE.L     16(A6),-(A7)
0798: 486EFFC0      PEA        -64(A6)
079C: 4EBA0014      JSR        20(PC)
07A0: 2EAE000C      MOVE.L     12(A6),(A7)
07A4: 4EAD094A      JSR        2378(A5)                       ; JT[2378]
07A8: 4CEE1CF8FF88  MOVEM.L    -120(A6),D3/D4/D5/D6/D7/A2/A3/A4
07AE: 4E5E          UNLK       A6
07B0: 4E75          RTS        


; ======= Function at 0x07B2 =======
07B2: 4E56FFBE      LINK       A6,#-66                        ; frame=66
07B6: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
07BA: 4EBA066E      JSR        1646(PC)
07BE: 486EFFBE      PEA        -66(A6)
07C2: 2F2E000C      MOVE.L     12(A6),-(A7)
07C6: 4EBAF90A      JSR        -1782(PC)
07CA: 486EFFE0      PEA        -32(A6)
07CE: 4EBA05B2      JSR        1458(PC)
07D2: 2E00          MOVE.L     D0,D7
07D4: 7C00          MOVEQ      #0,D6
07D6: 99CC4FEF      MOVE.B     A4,#$EF
07DA: 000C601C      ORI.B      #$601C,A4
07DE: 204C          MOVEA.L    A4,A0
07E0: D1EE00083F10  MOVE.B     8(A6),$3F10.W
07E6: 486EFFE0      PEA        -32(A6)
07EA: 2F07          MOVE.L     D7,-(A7)
07EC: 3F06          MOVE.W     D6,-(A7)
07EE: 4EBA0198      JSR        408(PC)
07F2: 4FEF000C      LEA        12(A7),A7
07F6: 5246          MOVEA.B    D6,A1
07F8: 548C          MOVE.B     A4,(A2)
07FA: 0C46001F      CMPI.W     #$001F,D6
07FE: 6DDE          BLT.S      $07DE
0800: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
0804: 4E5E          UNLK       A6
0806: 4E75          RTS        


; ======= Function at 0x0808 =======
0808: 4E560000      LINK       A6,#0
080C: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
0810: 7011          MOVEQ      #17,D0
0812: C1EE0008      ANDA.L     8(A6),A0
0816: 2840          MOVEA.L    D0,A4
0818: 47EDBCFE      LEA        -17154(A5),A3                  ; g_state1
081C: D7CC528B      MOVE.B     A4,-117(PC,D5.W)
0820: 45ED97B2      LEA        -26702(A5),A2                  ; A5-26702
0824: D5CC528A      MOVE.B     A4,21130(PC)
0828: 6012          BRA.S      $083C
082A: 4A13          TST.B      (A3)
082C: 660A          BNE.S      $0838
082E: 0C070001      CMPI.B     #$0001,D7
0832: 6704          BEQ.S      $0838
0834: 7000          MOVEQ      #0,D0
0836: 600A          BRA.S      $0842
0838: 528B          MOVE.B     A3,(A1)
083A: 528A          MOVE.B     A2,(A1)
083C: 1E12          MOVE.B     (A2),D7
083E: 66EA          BNE.S      $082A
0840: 7001          MOVEQ      #1,D0
0842: 4CDF1C80      MOVEM.L    (SP)+,D7/A2/A3/A4              ; restore
0846: 4E5E          UNLK       A6
0848: 4E75          RTS        


; ======= Function at 0x084A =======
084A: 4E56FFF2      LINK       A6,#-14                        ; frame=14
084E: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0852: 3A2E0008      MOVE.W     8(A6),D5
0856: 7011          MOVEQ      #17,D0
0858: C1C5          ANDA.L     D5,A0
085A: 41ED97B2      LEA        -26702(A5),A0                  ; A5-26702
085E: D088          MOVE.B     A0,(A0)
0860: 2D40FFF8      MOVE.L     D0,-8(A6)
0864: 204D          MOVEA.L    A5,A0
0866: D0C5          MOVE.B     D5,(A0)+
0868: 4A28F92E      TST.B      -1746(A0)
086C: 660C          BNE.S      $087A
086E: 3F05          MOVE.W     D5,-(A7)
0870: 4EBAFF96      JSR        -106(PC)
0874: 4A40          TST.W      D0
0876: 548F          MOVE.B     A7,(A2)
0878: 6716          BEQ.S      $0890
087A: 47EDA14C      LEA        -24244(A5),A3                  ; A5-24244
087E: 45ED9F4E      LEA        -24754(A5),A2                  ; A5-24754
0882: 6006          BRA.S      $088A
0884: 34BC0001      MOVE.W     #$0001,(A2)
0888: 548A          MOVE.B     A2,(A2)
088A: B7CA62F6      MOVE.W     A2,-10(PC,D6.W)
088E: 607C          BRA.S      $090C
0890: 45ED9F2C      LEA        -24788(A5),A2                  ; A5-24788
0894: 7601          MOVEQ      #1,D3
0896: 7011          MOVEQ      #17,D0
0898: C1C5          ANDA.L     D5,A0
089A: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
089E: D088          MOVE.B     A0,(A0)
08A0: 2D40FFFC      MOVE.L     D0,-4(A6)
08A4: 7222          MOVEQ      #34,D1
08A6: C3C3          ANDA.L     D3,A1
08A8: 41ED9F2C      LEA        -24788(A5),A0                  ; A5-24788
08AC: D288          MOVE.B     A0,(A1)
08AE: 2D41FFF2      MOVE.L     D1,-14(A6)
08B2: 6052          BRA.S      $0906
08B4: 264A          MOVEA.L    A2,A3
08B6: 246EFFF2      MOVEA.L    -14(A6),A2
08BA: 206EFFFC      MOVEA.L    -4(A6),A0
08BE: 41F030FF      LEA        -1(A0,D3.W),A0
08C2: 2808          MOVE.L     A0,D4
08C4: 7C00          MOVEQ      #0,D6
08C6: 99CC3006      MOVE.B     A4,#$06
08CA: D043          MOVEA.B    D3,A0
08CC: 3D40FFF6      MOVE.W     D0,-10(A6)
08D0: 0C400011      CMPI.W     #$0011,D0
08D4: 6428          BCC.S      $08FE
08D6: 204B          MOVEA.L    A3,A0
08D8: D1CC3E10      MOVE.B     A4,$3E10.W
08DC: 2044          MOVEA.L    D4,A0
08DE: 4A10          TST.B      (A0)
08E0: 660E          BNE.S      $08F0
08E2: 306EFFF6      MOVEA.W    -10(A6),A0
08E6: D1EEFFF81020  MOVE.B     -8(A6),$1020.W
08EC: 4880          EXT.W      D0
08EE: CFC0          ANDA.L     D0,A7
08F0: 204A          MOVEA.L    A2,A0
08F2: D1CC3087      MOVE.B     A4,$3087.W
08F6: 5246          MOVEA.B    D6,A1
08F8: 548C          MOVE.B     A4,(A2)
08FA: 5284          MOVE.B     D4,(A1)
08FC: 60CA          BRA.S      $08C8
08FE: 5243          MOVEA.B    D3,A1
0900: 7022          MOVEQ      #34,D0
0902: D1AEFFF20C43  MOVE.B     -14(A6),67(A0,D0.L*4)
0908: 001065A8      ORI.B      #$65A8,(A0)
090C: 3F05          MOVE.W     D5,-(A7)
090E: 4EBA000C      JSR        12(PC)
0912: 4CEE1CF8FFD2  MOVEM.L    -46(A6),D3/D4/D5/D6/D7/A2/A3/A4
0918: 4E5E          UNLK       A6
091A: 4E75          RTS        


; ======= Function at 0x091C =======
091C: 4E560000      LINK       A6,#0
0920: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
0924: 49EDD652      LEA        -10670(A5),A4                  ; A5-10670
0928: 47EDD654      LEA        -10668(A5),A3                  ; A5-10668
092C: 7022          MOVEQ      #34,D0
092E: C1EE0008      ANDA.L     8(A6),A0
0932: 45EDBF1E      LEA        -16610(A5),A2                  ; g_state2
0936: D08A          MOVE.B     A2,(A0)
0938: 2440          MOVEA.L    D0,A2
093A: 41EDD674      LEA        -10636(A5),A0                  ; A5-10636
093E: 2E08          MOVE.L     A0,D7
0940: 600C          BRA.S      $094E
0942: 3014          MOVE.W     (A4),D0
0944: D052          MOVEA.B    (A2),A0
0946: 3680          MOVE.W     D0,(A3)
0948: 548C          MOVE.B     A4,(A2)
094A: 548B          MOVE.B     A3,(A2)
094C: 548A          MOVE.B     A2,(A2)
094E: BE8B          MOVE.W     A3,(A7)
0950: 62F0          BHI.S      $0942
0952: 47EDD60E      LEA        -10738(A5),A3                  ; A5-10738
0956: 284B          MOVEA.L    A3,A4
0958: 548B          MOVE.B     A3,(A2)
095A: 45EDD630      LEA        -10704(A5),A2                  ; A5-10704
095E: 6008          BRA.S      $0968
0960: 3014          MOVE.W     (A4),D0
0962: D153548C      MOVE.B     (A3),21644(A0)
0966: 548B          MOVE.B     A3,(A2)
0968: B5CB62F4      MOVE.W     A3,25332(PC)
096C: 45EDD60E      LEA        -10738(A5),A2                  ; A5-10738
0970: 558B558C      MOVE.B     A3,-116(A2,D5.W*4)
0974: 6006          BRA.S      $097C
0976: 3694          MOVE.W     (A4),(A3)
0978: 558C558B      MOVE.B     A4,-117(A2,D5.W*4)
097C: B5CC63F6      MOVE.W     A4,25590(PC)
0980: 4CDF1C80      MOVEM.L    (SP)+,D7/A2/A3/A4              ; restore
0984: 4E5E          UNLK       A6
0986: 4E75          RTS        


; ======= Function at 0x0988 =======
0988: 4E56FF8C      LINK       A6,#-116                       ; frame=116
098C: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0990: 3A2E0008      MOVE.W     8(A6),D5
0994: 4A6E0012      TST.W      18(A6)
0998: 670003E0      BEQ.W      $0D7C
099C: 48780022      PEA        $0022.W
09A0: 486DD60E      PEA        -10738(A5)                     ; A5-10738
09A4: 4EAD01AA      JSR        426(A5)                        ; JT[426]
09A8: 7022          MOVEQ      #34,D0
09AA: 2E80          MOVE.L     D0,(A7)
09AC: 486DD630      PEA        -10704(A5)                     ; A5-10704
09B0: 4EAD01AA      JSR        426(A5)                        ; JT[426]
09B4: 7044          MOVEQ      #68,D0
09B6: 2E80          MOVE.L     D0,(A7)
09B8: 486EFFB8      PEA        -72(A6)
09BC: 4EAD01AA      JSR        426(A5)                        ; JT[426]
09C0: 7011          MOVEQ      #17,D0
09C2: 2E80          MOVE.L     D0,(A7)
09C4: 7011          MOVEQ      #17,D0
09C6: C1C5          ANDA.L     D5,A0
09C8: 204D          MOVEA.L    A5,A0
09CA: D1C04868      MOVE.B     D0,$4868.W
09CE: 9592486E      MOVE.B     (A2),110(A2,D4.L)
09D2: FFA64EAD      MOVE.W     -(A6),-83(A7,D4.L*8)
09D6: 0D8A          BCLR       D6,A2
09D8: 41EEFFA6      LEA        -90(A6),A0
09DC: 2B48D602      MOVE.L     A0,-10750(A5)
09E0: 426EFF92      CLR.W      -110(A6)
09E4: 7C11          MOVEQ      #17,D6
09E6: CDC5          ANDA.L     D5,A6
09E8: 43EDBCFE      LEA        -17154(A5),A1                  ; g_state1
09EC: DC89          MOVE.B     A1,(A6)
09EE: 2B46D5FE      MOVE.L     D6,-10754(A5)
09F2: 0C450001      CMPI.W     #$0001,D5
09F6: 4FEF0018      LEA        24(A7),A7
09FA: 6706          BEQ.S      $0A02
09FC: 0C450010      CMPI.W     #$0010,D5
0A00: 6608          BNE.S      $0A0A
0A02: 41EDF94E      LEA        -1714(A5),A0                   ; A5-1714
0A06: 2008          MOVE.L     A0,D0
0A08: 600E          BRA.S      $0A18
0A0A: 70FF          MOVEQ      #-1,D0
0A0C: D045          MOVEA.B    D5,A0
0A0E: C1FC001141ED  ANDA.L     #$001141ED,A0
0A14: BCFE          MOVE.W     ???,(A6)+
0A16: D088          MOVE.B     A0,(A0)
0A18: 2840          MOVEA.L    D0,A4
0A1A: 0C45000F      CMPI.W     #$000F,D5
0A1E: 6706          BEQ.S      $0A26
0A20: 0C45001E      CMPI.W     #$001E,D5
0A24: 6608          BNE.S      $0A2E
0A26: 41EDF94E      LEA        -1714(A5),A0                   ; A5-1714
0A2A: 2008          MOVE.L     A0,D0
0A2C: 600E          BRA.S      $0A3C
0A2E: 7001          MOVEQ      #1,D0
0A30: D045          MOVEA.B    D5,A0
0A32: C1FC001141ED  ANDA.L     #$001141ED,A0
0A38: BCFE          MOVE.W     ???,(A6)+
0A3A: D088          MOVE.B     A0,(A0)
0A3C: 2D40FF9A      MOVE.L     D0,-102(A6)
0A40: 47EEFFB8      LEA        -72(A6),A3
0A44: 7601          MOVEQ      #1,D3
0A46: 7211          MOVEQ      #17,D1
0A48: C3C5          ANDA.L     D5,A1
0A4A: 41ED97B2      LEA        -26702(A5),A0                  ; A5-26702
0A4E: D288          MOVE.B     A0,(A1)
0A50: 2D41FF8E      MOVE.L     D1,-114(A6)
0A54: 3043          MOVEA.W    D3,A0
0A56: D1C82D48      MOVE.B     A0,$2D48.W
0A5A: FF9643ED      MOVE.W     (A6),-19(A7,D4.W*2)
0A5E: D60E          MOVE.B     A6,D3
0A60: D3C82D49FF9E  MOVE.B     A0,$2D49FF9E
0A66: 43EDD630      LEA        -10704(A5),A1                  ; A5-10704
0A6A: D3C82D49FFA2  MOVE.B     A0,$2D49FFA2
0A70: 2403          MOVE.L     D3,D2
0A72: 48C2          EXT.L      D2
0A74: E58A41F6      MOVE.L     A2,-10(A2,D4.W)
0A78: 28B82D48      MOVE.L     $2D48.W,(A4)
0A7C: FF966000      MOVE.W     (A6),0(A7,D6.W)
0A80: 014A          BCHG       D0,A2
0A82: 588B          MOVE.B     A3,(A4)
0A84: B7EEFF966704  MOVE.W     -106(A6),4(PC,D6.W)
0A8A: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0A8E: 206DD5FE      MOVEA.L    -10754(A5),A0
0A92: 18303000      MOVE.B     0(A0,D3.W),D4
0A96: 4884          EXT.W      D4
0A98: 4A44          TST.W      D4
0A9A: 6718          BEQ.S      $0AB4
0A9C: 204D          MOVEA.L    A5,A0
0A9E: 2004          MOVE.L     D4,D0
0AA0: 48C0          EXT.L      D0
0AA2: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0AA6: 26A89852      MOVE.L     -26542(A0),(A3)
0AAA: 3D7C0001FF92  MOVE.W     #$0001,-110(A6)
0AB0: 6000010A      BRA.W      $0BBE
0AB4: 4A343000      TST.B      0(A4,D3.W)
0AB8: 6612          BNE.S      $0ACC
0ABA: 206EFF9A      MOVEA.L    -102(A6),A0
0ABE: 4A303000      TST.B      0(A0,D3.W)
0AC2: 6608          BNE.S      $0ACC
0AC4: 26AE000A      MOVE.L     10(A6),(A3)
0AC8: 600000F2      BRA.W      $0BBE
0ACC: 486EFFFC      PEA        -4(A6)
0AD0: 486EFFFE      PEA        -2(A6)
0AD4: 3F03          MOVE.W     D3,-(A7)
0AD6: 3F05          MOVE.W     D5,-(A7)
0AD8: 4EAD0922      JSR        2338(A5)                       ; JT[2338]
0ADC: 3EAEFFFC      MOVE.W     -4(A6),(A7)
0AE0: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
0AE4: 4EAD091A      JSR        2330(A5)                       ; JT[2330]
0AE8: 2440          MOVEA.L    D0,A2
0AEA: 7011          MOVEQ      #17,D0
0AEC: C1EEFFFE      ANDA.L     -2(A6),A0
0AF0: D08D          MOVE.B     A5,(A0)
0AF2: 306EFFFC      MOVEA.W    -4(A6),A0
0AF6: 41E8BCFE      LEA        -17154(A0),A0
0AFA: D088          MOVE.B     A0,(A0)
0AFC: B08A          MOVE.W     A2,(A0)
0AFE: 4FEF000E      LEA        14(A7),A7
0B02: 6604          BNE.S      $0B08
0B04: 4A12          TST.B      (A2)
0B06: 670E          BEQ.S      $0B16
0B08: 4A12          TST.B      (A2)
0B0A: 6706          BEQ.S      $0B12
0B0C: 4A2AFFFF      TST.B      -1(A2)
0B10: 6704          BEQ.S      $0B16
0B12: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0B16: 2F2E000E      MOVE.L     14(A6),-(A7)
0B1A: 2F0A          MOVE.L     A2,-(A7)
0B1C: 4EBAF8AC      JSR        -1876(PC)
0B20: 2E00          MOVE.L     D0,D7
0B22: 508F          MOVE.B     A7,(A0)
0B24: 6012          BRA.S      $0B38
0B26: 204D          MOVEA.L    A5,A0
0B28: 2004          MOVE.L     D4,D0
0B2A: 48C0          EXT.L      D0
0B2C: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0B30: 20289852      MOVE.L     -26542(A0),D0
0B34: 8193          OR.L       D0,(A3)
0B36: 5287          MOVE.B     D7,(A1)
0B38: 2047          MOVEA.L    D7,A0
0B3A: 1810          MOVE.B     (A0),D4
0B3C: 4884          EXT.W      D4
0B3E: 4A44          TST.W      D4
0B40: 66E4          BNE.S      $0B26
0B42: 206EFF8E      MOVEA.L    -114(A6),A0
0B46: 10303000      MOVE.B     0(A0,D3.W),D0
0B4A: 4880          EXT.W      D0
0B4C: 123630A6      MOVE.B     -90(A6,D3.W),D1
0B50: 4881          EXT.W      D1
0B52: C1C1          ANDA.L     D1,A0
0B54: 226EFFA2      MOVEA.L    -94(A6),A1
0B58: 3280          MOVE.W     D0,(A1)
0B5A: 4A93          TST.L      (A3)
0B5C: 675E          BEQ.S      $0BBC
0B5E: 3D7C0001FF92  MOVE.W     #$0001,-110(A6)
0B64: 7011          MOVEQ      #17,D0
0B66: C1EEFFFE      ANDA.L     -2(A6),A0
0B6A: D08D          MOVE.B     A5,(A0)
0B6C: 306EFFFC      MOVEA.W    -4(A6),A0
0B70: D1C0117C      MOVE.B     D0,$117C.W
0B74: 003FBCFE      ORI.B      #$BCFE,???
0B78: 7800          MOVEQ      #0,D4
0B7A: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
0B7E: 2E0A          MOVE.L     A2,D7
0B80: 9E88          MOVE.B     A0,(A7)
0B82: DE87          MOVE.B     D7,(A7)
0B84: 41EDBF1E      LEA        -16610(A5),A0                  ; g_state2
0B88: DE88          MOVE.B     A0,(A7)
0B8A: 6008          BRA.S      $0B94
0B8C: 2047          MOVEA.L    D7,A0
0B8E: D850          MOVEA.B    (A0),A4
0B90: 528A          MOVE.B     A2,(A1)
0B92: 5487          MOVE.B     D7,(A2)
0B94: 4A12          TST.B      (A2)
0B96: 66F4          BNE.S      $0B8C
0B98: 7011          MOVEQ      #17,D0
0B9A: C1EEFFFE      ANDA.L     -2(A6),A0
0B9E: D08D          MOVE.B     A5,(A0)
0BA0: 306EFFFC      MOVEA.W    -4(A6),A0
0BA4: D1C04228      MOVE.B     D0,$4228.W
0BA8: BCFE          MOVE.W     ???,(A6)+
0BAA: 206EFF8E      MOVEA.L    -114(A6),A0
0BAE: 10303000      MOVE.B     0(A0,D3.W),D0
0BB2: 4880          EXT.W      D0
0BB4: C1C4          ANDA.L     D4,A0
0BB6: 226EFF9E      MOVEA.L    -98(A6),A1
0BBA: 3280          MOVE.W     D0,(A1)
0BBC: 5243          MOVEA.B    D3,A1
0BBE: 54AEFF9E      MOVE.B     -98(A6),(A2)
0BC2: 54AEFFA2      MOVE.B     -94(A6),(A2)
0BC6: 58AEFF96      MOVE.B     -106(A6),(A4)
0BCA: 0C430010      CMPI.W     #$0010,D3
0BCE: 6D00FEB2      BLT.W      $0A84
0BD2: 4A6EFF92      TST.W      -110(A6)
0BD6: 670001A2      BEQ.W      $0D7C
0BDA: 3F05          MOVE.W     D5,-(A7)
0BDC: 4EBAFC6C      JSR        -916(PC)
0BE0: 2846          MOVEA.L    D6,A4
0BE2: 41EC0001      LEA        1(A4),A0
0BE6: 2B48D60A      MOVE.L     A0,-10742(A5)
0BEA: 226DD5FA      MOVEA.L    -10758(A5),A1
0BEE: 13450020      MOVE.B     D5,32(A1)
0BF2: 7601          MOVEQ      #1,D3
0BF4: 7000          MOVEQ      #0,D0
0BF6: 302E0012      MOVE.W     18(A6),D0
0BFA: 2D40FF92      MOVE.L     D0,-110(A6)
0BFE: 2203          MOVE.L     D3,D1
0C00: 48C1          EXT.L      D1
0C02: E5892441      MOVE.L     A1,65(A2,D2.W*4)
0C06: 41EEFFB8      LEA        -72(A6),A0
0C0A: D1CA2C08      MOVE.B     A2,$2C08.W
0C0E: 41ED99D6      LEA        -26154(A5),A0                  ; A5-26154
0C12: D1CA2D48      MOVE.B     A2,$2D48.W
0C16: FF9A47ED      MOVE.W     (A2)+,-19(A7,D4.W*8)
0C1A: D630D6C3      MOVE.B     -61(A0,A5.W*8),D3
0C1E: D6C3          MOVE.B     D3,(A3)+
0C20: 548F          MOVE.B     A7,(A2)
0C22: 6000014E      BRA.W      $0D74
0C26: 246DD5FE      MOVEA.L    -10754(A5),A2
0C2A: D4C3          MOVE.B     D3,(A2)+
0C2C: 4A12          TST.B      (A2)
0C2E: 66000138      BNE.W      $0D6A
0C32: 4A53          TST.W      (A3)
0C34: 6616          BNE.S      $0C4C
0C36: 206DD5FE      MOVEA.L    -10754(A5),A0
0C3A: 4A3030FF      TST.B      -1(A0,D3.W)
0C3E: 660C          BNE.S      $0C4C
0C40: 206DD5FE      MOVEA.L    -10754(A5),A0
0C44: 4A303001      TST.B      1(A0,D3.W)
0C48: 6700011E      BEQ.W      $0D6A
0C4C: 2B4AD6F8      MOVE.L     A2,-10504(A5)
0C50: 206EFF9A      MOVEA.L    -102(A6),A0
0C54: 2010          MOVE.L     (A0),D0
0C56: C0AEFF92      AND.L      -110(A6),D0
0C5A: 67000108      BEQ.W      $0D66
0C5E: 2046          MOVEA.L    D6,A0
0C60: 4A90          TST.L      (A0)
0C62: 67000100      BEQ.W      $0D66
0C66: 48780010      PEA        $0010.W
0C6A: 2F2DD5FA      MOVE.L     -10758(A5),-(A7)               ; A5-10758
0C6E: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0C72: 2B46D6FC      MOVE.L     D6,-10500(A5)
0C76: 206DD5FE      MOVEA.L    -10754(A5),A0
0C7A: 4A3030FF      TST.B      -1(A0,D3.W)
0C7E: 508F          MOVE.B     A7,(A0)
0C80: 676C          BEQ.S      $0CEE
0C82: 426EFF8C      CLR.W      -116(A6)
0C86: 49EDD148      LEA        -11960(A5),A4                  ; A5-11960
0C8A: 2B54D140      MOVE.L     (A4),-11968(A5)
0C8E: 302EFF8C      MOVE.W     -116(A6),D0
0C92: 3B40D548      MOVE.W     D0,-10936(A5)
0C96: 204D          MOVEA.L    A5,A0
0C98: 48C0          EXT.L      D0
0C9A: E788D1C0      MOVE.L     A0,-64(A3,A5.W)
0C9E: 2B68D14CD144  MOVE.L     -11956(A0),-11964(A5)
0CA4: 670000BE      BEQ.W      $0D66
0CA8: 3F03          MOVE.W     D3,-(A7)
0CAA: 3F05          MOVE.W     D5,-(A7)
0CAC: 4EAD091A      JSR        2330(A5)                       ; JT[2330]
0CB0: 2440          MOVEA.L    D0,A2
0CB2: 2E8A          MOVE.L     A2,(A7)
0CB4: 4EBAF6B2      JSR        -2382(PC)
0CB8: 2800          MOVE.L     D0,D4
0CBA: 4A84          TST.L      D4
0CBC: 588F          MOVE.B     A7,(A4)
0CBE: 6F26          BLE.S      $0CE6
0CC0: 2B6DD5FAD606  MOVE.L     -10758(A5),-10746(A5)          ; A5-10758
0CC6: 6004          BRA.S      $0CCC
0CC8: 52ADD606      MOVE.B     -10746(A5),(A1)                ; A5-10746
0CCC: 206DD606      MOVEA.L    -10746(A5),A0
0CD0: 109A          MOVE.B     (A2)+,(A0)
0CD2: 66F4          BNE.S      $0CC8
0CD4: 2F2DD6F8      MOVE.L     -10504(A5),-(A7)               ; A5-10504
0CD8: 2004          MOVE.L     D4,D0
0CDA: 720A          MOVEQ      #10,D1
0CDC: E3A82F004EBA  MOVE.L     12032(A0),-70(A1,D4.L*8)
0CE2: 0702          BTST       D3,D2
0CE4: 508F          MOVE.B     A7,(A0)
0CE6: 526EFF8C      MOVEA.B    -116(A6),A1
0CEA: 508C          MOVE.B     A4,(A0)
0CEC: 609C          BRA.S      $0C8A
0CEE: 426EFF8C      CLR.W      -116(A6)
0CF2: 41EDD148      LEA        -11960(A5),A0                  ; A5-11960
0CF6: 2D48FF8E      MOVE.L     A0,-114(A6)
0CFA: 206EFF8E      MOVEA.L    -114(A6),A0
0CFE: 2B50D140      MOVE.L     (A0),-11968(A5)
0D02: 302EFF8C      MOVE.W     -116(A6),D0
0D06: 3B40D548      MOVE.W     D0,-10936(A5)
0D0A: 224D          MOVEA.L    A5,A1
0D0C: 48C0          EXT.L      D0
0D0E: E788D3C0      MOVE.L     A0,-64(A3,A5.W*2)
0D12: 2B69D14CD144  MOVE.L     -11956(A1),-11964(A5)
0D18: 674A          BEQ.S      $0D64
0D1A: 2B6DD5FAD606  MOVE.L     -10758(A5),-10746(A5)          ; A5-10758
0D20: 2F2DD6F8      MOVE.L     -10504(A5),-(A7)               ; A5-10504
0D24: 202DD144      MOVE.L     -11964(A5),D0                  ; A5-11964
0D28: 720A          MOVEQ      #10,D1
0D2A: E3A82F004EBA  MOVE.L     12032(A0),-70(A1,D4.L*8)
0D30: 06B4282DD6F8988C  ADDI.L     #$282DD6F8,-116(A4,A1.L)
0D38: 53444A44      MOVE.B     D4,19012(A1)
0D3C: 508F          MOVE.B     A7,(A0)
0D3E: 671A          BEQ.S      $0D5A
0D40: 0C440007      CMPI.W     #$0007,D4
0D44: 6F02          BLE.S      $0D48
0D46: 7807          MOVEQ      #7,D4
0D48: 3F04          MOVE.W     D4,-(A7)
0D4A: 202DD144      MOVE.L     -11964(A5),D0                  ; A5-11964
0D4E: 720A          MOVEQ      #10,D1
0D50: E3A82F004EBA  MOVE.L     12032(A0),-70(A1,D4.L*8)
0D56: 05FC5C8F      BSET       D2,#$8F
0D5A: 526EFF8C      MOVEA.B    -116(A6),A1
0D5E: 50AEFF8E      MOVE.B     -114(A6),(A0)
0D62: 6096          BRA.S      $0CFA
0D64: 286DD6F8      MOVEA.L    -10504(A5),A4
0D68: 5243          MOVEA.B    D3,A1
0D6A: 5886          MOVE.B     D6,(A4)
0D6C: 58AEFF9A      MOVE.B     -102(A6),(A4)
0D70: 548B          MOVE.B     A3,(A2)
0D72: 0C430010      CMPI.W     #$0010,D3
0D76: 6D00FEAE      BLT.W      $0C28
0D7A: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0D7E: 4E5E          UNLK       A6
0D80: 4E75          RTS        


; ======= Function at 0x0D82 =======
0D82: 4E560000      LINK       A6,#0
0D86: 48E70708      MOVEM.L    D5/D6/D7/A4,-(SP)              ; save
0D8A: 286E0008      MOVEA.L    8(A6),A4
0D8E: 7E00          MOVEQ      #0,D7
0D90: 102DD6B7      MOVE.B     -10569(A5),D0                  ; A5-10569
0D94: 4880          EXT.W      D0
0D96: 3B40BCFC      MOVE.W     D0,-17156(A5)
0D9A: 6744          BEQ.S      $0DE0
0D9C: 7C61          MOVEQ      #97,D6
0D9E: 6016          BRA.S      $0DB6
0DA0: 204D          MOVEA.L    A5,A0
0DA2: D0C6          MOVE.B     D6,(A0)+
0DA4: 1A28D678      MOVE.B     -10632(A0),D5
0DA8: 4A05          TST.B      D5
0DAA: 6708          BEQ.S      $0DB4
0DAC: 1005          MOVE.B     D5,D0
0DAE: 4880          EXT.W      D0
0DB0: D16DBCFC5246  MOVE.B     -17156(A5),21062(A0)           ; A5-17156
0DB6: 0C46007A      CMPI.W     #$007A,D6
0DBA: 6FE4          BLE.S      $0DA0
0DBC: 206D99D2      MOVEA.L    -26158(A5),A0
0DC0: 48680001      PEA        1(A0)
0DC4: 2F0C          MOVE.L     A4,-(A7)
0DC6: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0DCA: 7EFF          MOVEQ      #-1,D7
0DCC: DEAD9A3E      MOVE.B     -26050(A5),(A7)                ; A5-26050
0DD0: 202D9A3A      MOVE.L     -26054(A5),D0                  ; A5-26054
0DD4: C087          AND.L      D7,D0
0DD6: 508F          MOVE.B     A7,(A0)
0DD8: 6638          BNE.S      $0E12
0DDA: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0DDE: 6032          BRA.S      $0E12
0DE0: 7C61          MOVEQ      #97,D6
0DE2: 6026          BRA.S      $0E0A
0DE4: 204D          MOVEA.L    A5,A0
0DE6: D0C6          MOVE.B     D6,(A0)+
0DE8: 1A28D678      MOVE.B     -10632(A0),D5
0DEC: 4A05          TST.B      D5
0DEE: 6718          BEQ.S      $0E08
0DF0: 1005          MOVE.B     D5,D0
0DF2: 4880          EXT.W      D0
0DF4: D16DBCFC18C6  MOVE.B     -17156(A5),6342(A0)            ; A5-17156
0DFA: 204D          MOVEA.L    A5,A0
0DFC: 2006          MOVE.L     D6,D0
0DFE: 48C0          EXT.L      D0
0E00: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0E04: 8EA89852      OR.L       -26542(A0),D7
0E08: 5246          MOVEA.B    D6,A1
0E0A: 0C46007A      CMPI.W     #$007A,D6
0E0E: 6FD4          BLE.S      $0DE4
0E10: 4214          CLR.B      (A4)
0E12: 0C6D0007BCFC  CMPI.W     #$0007,-17156(A5)
0E18: 6F06          BLE.S      $0E20
0E1A: 3B7C0007BCFC  MOVE.W     #$0007,-17156(A5)
0E20: 2007          MOVE.L     D7,D0
0E22: 4CDF10E0      MOVEM.L    (SP)+,D5/D6/D7/A4              ; restore
0E26: 4E5E          UNLK       A6
0E28: 4E75          RTS        

0E2A: 4AADA38A      TST.L      -23670(A5)
0E2E: 6710          BEQ.S      $0E40
0E30: 2038016A      MOVE.L     $016A.W,D0
0E34: B0ADA38E      MOVE.W     -23666(A5),(A0)                ; A5-23666
0E38: 6F06          BLE.S      $0E40
0E3A: 206DA38A      MOVEA.L    -23670(A5),A0
0E3E: 4E90          JSR        (A0)
0E40: 4E75          RTS        


; ======= Function at 0x0E42 =======
0E42: 4E56FFF0      LINK       A6,#-16                        ; frame=16
0E46: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
0E4A: 206DD5FA      MOVEA.L    -10758(A5),A0
0E4E: 1C280021      MOVE.B     33(A0),D6
0E52: 4886          EXT.W      D6
0E54: 7800          MOVEQ      #0,D4
0E56: 42AEFFFC      CLR.L      -4(A6)
0E5A: 2F08          MOVE.L     A0,-(A7)
0E5C: 4EAD0322      JSR        802(A5)                        ; JT[802]
0E60: 588F          MOVE.B     A7,(A4)
0E62: 4A40          TST.W      D0
0E64: 660004E4      BNE.W      $134C
0E68: 4AADA38A      TST.L      -23670(A5)
0E6C: 6710          BEQ.S      $0E7E
0E6E: 2038016A      MOVE.L     $016A.W,D0
0E72: B0ADA38E      MOVE.W     -23666(A5),(A0)                ; A5-23666
0E76: 6F06          BLE.S      $0E7E
0E78: 206DA38A      MOVEA.L    -23670(A5),A0
0E7C: 4E90          JSR        (A0)
0E7E: 3D7CFFFFFFF0  MOVE.W     #$FFFF,-16(A6)
0E84: 246DD5FE      MOVEA.L    -10754(A5),A2
0E88: D4C6          MOVE.B     D6,(A2)+
0E8A: 206DD602      MOVEA.L    -10750(A5),A0
0E8E: D0C6          MOVE.B     D6,(A0)+
0E90: 2D48FFF8      MOVE.L     A0,-8(A6)
0E94: 49EDD630      LEA        -10704(A5),A4                  ; A5-10704
0E98: D8C6          MOVE.B     D6,(A4)+
0E9A: D8C6          MOVE.B     D6,(A4)+
0E9C: 266DD5FA      MOVEA.L    -10758(A5),A3
0EA0: 426DB1D6      CLR.W      -20010(A5)
0EA4: 600000A0      BRA.W      $0F48
0EA8: 4A12          TST.B      (A2)
0EAA: 66000090      BNE.W      $0F3E
0EAE: 526DB1D6      MOVEA.B    -20010(A5),A1
0EB2: 4280          CLR.L      D0
0EB4: 3007          MOVE.W     D7,D0
0EB6: D040          MOVEA.B    D0,A0
0EB8: 41ED9412      LEA        -27630(A5),A0                  ; A5-27630
0EBC: 3A300000      MOVE.W     0(A0,D0.W),D5
0EC0: 4280          CLR.L      D0
0EC2: 206EFFF8      MOVEA.L    -8(A6),A0
0EC6: 1010          MOVE.B     (A0),D0
0EC8: C0C5          ANDA.W     D5,A0
0ECA: D840          MOVEA.B    D0,A4
0ECC: 3014          MOVE.W     (A4),D0
0ECE: 6714          BEQ.S      $0EE4
0ED0: 48C5          EXT.L      D5
0ED2: 0C000002      CMPI.B     #$0002,D0
0ED6: 6D08          BLT.S      $0EE0
0ED8: 6704          BEQ.S      $0EDE
0EDA: DBAEFFFCDA85  MOVE.B     -4(A6),-123(A5,A5.L*2)
0EE0: DBAEFFFC43ED  MOVE.B     -4(A6),-19(A5,D4.W*2)
0EE6: CE84          AND.L      D4,D7
0EE8: 41EDA54E      LEA        -23218(A5),A0                  ; A5-23218
0EEC: 4280          CLR.L      D0
0EEE: 10317000      MOVE.B     0(A1,D7.W),D0
0EF2: B0307000      MOVE.W     0(A0,D7.W),D0
0EF6: 662A          BNE.S      $0F22
0EF8: 206EFFF8      MOVEA.L    -8(A6),A0
0EFC: 1010          MOVE.B     (A0),D0
0EFE: 3D40FFF6      MOVE.W     D0,-10(A6)
0F02: 3D54FFF4      MOVE.W     (A4),-12(A6)
0F06: 41EDB3E0      LEA        -19488(A5),A0                  ; A5-19488
0F0A: 102DCEC3      MOVE.B     -12605(A5),D0                  ; A5-12605
0F0E: 11870000      MOVE.B     D7,0(A0,D0.W)
0F12: 3E3C003F      MOVE.W     #$003F,D7
0F16: 41EDA54E      LEA        -23218(A5),A0                  ; A5-23218
0F1A: B0307000      MOVE.W     0(A0,D7.W),D0
0F1E: 6D06          BLT.S      $0F26
0F20: A9FF10317000  MOVE.L     ???,#$10317000
0F26: 52317000      MOVE.B     0(A1,D7.W),D1
0F2A: E94F43ED      MOVE.L     A7,17389(A4)
0F2E: B3F4D2C7D0403231  MOVE.W     -57(A4,A5.W*2),$D0403231
0F36: 0000C36E      ORI.B      #$C36E,D0
0F3A: FFF0528A      MOVE.W     -118(A0,D5.W*2),???
0F3E: 548C          MOVE.B     A4,(A2)
0F40: 52AEFFF8      MOVE.B     -8(A6),(A1)
0F44: 528B          MOVE.B     A3,(A1)
0F46: 1E13          MOVE.B     (A3),D7
0F48: 4887          EXT.W      D7
0F4A: 4A47          TST.W      D7
0F4C: 6600FF5A      BNE.W      $0EAA
0F50: 2E0B          MOVE.L     A3,D7
0F52: 9EADD5FA      MOVE.B     -10758(A5),(A7)                ; A5-10758
0F56: 7022          MOVEQ      #34,D0
0F58: C1C7          ANDA.L     D7,A0
0F5A: 41ED9F2C      LEA        -24788(A5),A0                  ; A5-24788
0F5E: D088          MOVE.B     A0,(A0)
0F60: 3046          MOVEA.W    D6,A0
0F62: D1C83A30      MOVE.B     A0,$3A30.W
0F66: 08000C45      BTST       #3141,D0
0F6A: 00036706      ORI.B      #$6706,D3
0F6E: 0C450009      CMPI.W     #$0009,D5
0F72: 6608          BNE.S      $0F7C
0F74: 3B7C0001A43E  MOVE.W     #$0001,-23490(A5)
0F7A: 6004          BRA.S      $0F80
0F7C: 426DA43E      CLR.W      -23490(A5)
0F80: DE46          MOVEA.B    D6,A7
0F82: 49EDD652      LEA        -10670(A5),A4                  ; A5-10670
0F86: 204C          MOVEA.L    A4,A0
0F88: D0C7          MOVE.B     D7,(A0)+
0F8A: 30707000      MOVEA.W    0(A0,D7.W),A0
0F8E: D888          MOVE.B     A0,(A4)
0F90: 204C          MOVEA.L    A4,A0
0F92: D0C6          MOVE.B     D6,(A0)+
0F94: 30706000      MOVEA.W    0(A0,D6.W),A0
0F98: 9888          MOVE.B     A0,(A4)
0F9A: 3045          MOVEA.W    D5,A0
0F9C: 2F08          MOVE.L     A0,-(A7)
0F9E: 2F04          MOVE.L     D4,-(A7)
0FA0: 4EAD0042      JSR        66(A5)                         ; JT[66]
0FA4: 2800          MOVE.L     D0,D4
0FA6: D9AEFFFC49ED  MOVE.B     -4(A6),-19(A4,D4.L)
0FAC: D60E          MOVE.B     A6,D3
0FAE: 204C          MOVEA.L    A4,A0
0FB0: D0C7          MOVE.B     D7,(A0)+
0FB2: 30307000      MOVE.W     0(A0,D7.W),D0
0FB6: 48C0          EXT.L      D0
0FB8: D1AEFFFC204C  MOVE.B     -4(A6),76(A0,D2.W)
0FBE: D0C6          MOVE.B     D6,(A0)+
0FC0: 30306000      MOVE.W     0(A0,D6.W),D0
0FC4: 48C0          EXT.L      D0
0FC6: 91AEFFFC302D  MOVE.B     -4(A6),45(A0,D3.W)
0FCC: B1D6B06D      MOVE.W     (A6),$B06D.W
0FD0: BCFC661E      MOVE.W     #$661E,(A6)+
0FD4: 206DD5FA      MOVEA.L    -10758(A5),A0
0FD8: 317C0001001C  MOVE.W     #$0001,28(A0)
0FDE: 0C6D0007B1D6  CMPI.W     #$0007,-20010(A5)
0FE4: 6614          BNE.S      $0FFA
0FE6: 302D9A56      MOVE.W     -26026(A5),D0                  ; A5-26026
0FEA: 48C0          EXT.L      D0
0FEC: D1AEFFFC6008  MOVE.B     -4(A6),8(A0,D6.W)
0FF2: 206DD5FA      MOVEA.L    -10758(A5),A0
0FF6: 4268001C      CLR.W      28(A0)
0FFA: 206DD5FA      MOVEA.L    -10758(A5),A0
0FFE: 316EFFF0001E  MOVE.W     -16(A6),30(A0)
1004: 0C6E0080FFF0  CMPI.W     #$0080,-16(A6)
100A: 6418          BCC.S      $1024
100C: 7000          MOVEQ      #0,D0
100E: 302EFFF0      MOVE.W     -16(A6),D0
1012: 204D          MOVEA.L    A5,A0
1014: D1C0D1C0      MOVE.B     D0,$D1C0.W
1018: 3068BBF4      MOVEA.W    -17420(A0),A0
101C: 226DD5FA      MOVEA.L    -10758(A5),A1
1020: 23480014      MOVE.L     A0,20(A1)
1024: 4A2DCEC3      TST.B      -12605(A5)
1028: 670002F2      BEQ.W      $131E
102C: 102DB3E0      MOVE.B     -19488(A5),D0                  ; A5-19488
1030: 4880          EXT.W      D0
1032: 3D40FFF2      MOVE.W     D0,-14(A6)
1036: 0C2D0001CEC3  CMPI.B     #$0001,-12605(A5)
103C: 660000C0      BNE.W      $1100
1040: 204D          MOVEA.L    A5,A0
1042: D0EEFFF2      MOVE.B     -14(A6),(A0)+
1046: 4A28CE84      TST.B      -12668(A0)
104A: 6614          BNE.S      $1060
104C: 302EFFF6      MOVE.W     -10(A6),D0
1050: C1C5          ANDA.L     D5,A0
1052: 3D40FFF6      MOVE.W     D0,-10(A6)
1056: 322EFFF4      MOVE.W     -12(A6),D1
105A: D36EFFF6606E  MOVE.B     -10(A6),24686(A1)
1060: 246DD5FE      MOVEA.L    -10754(A5),A2
1064: D4C6          MOVE.B     D6,(A2)+
1066: 206DD602      MOVEA.L    -10750(A5),A0
106A: D0C6          MOVE.B     D6,(A0)+
106C: 2D48FFF8      MOVE.L     A0,-8(A6)
1070: 49EDD630      LEA        -10704(A5),A4                  ; A5-10704
1074: D8C6          MOVE.B     D6,(A4)+
1076: D8C6          MOVE.B     D6,(A4)+
1078: 224D          MOVEA.L    A5,A1
107A: D2EEFFF2      MOVE.B     -14(A6),(A1)+
107E: 1C29CE84      MOVE.B     -12668(A1),D6
1082: 4886          EXT.W      D6
1084: 5246          MOVEA.B    D6,A1
1086: 7E00          MOVEQ      #0,D7
1088: 3D7C7530FFF6  MOVE.W     #$7530,-10(A6)
108E: 266DD5FA      MOVEA.L    -10758(A5),A3
1092: 6036          BRA.S      $10CA
1094: 1013          MOVE.B     (A3),D0
1096: 4880          EXT.W      D0
1098: B06EFFF2      MOVEA.W    -14(A6),A0
109C: 6622          BNE.S      $10C0
109E: 4A12          TST.B      (A2)
10A0: 661E          BNE.S      $10C0
10A2: 5247          MOVEA.B    D7,A1
10A4: 206EFFF8      MOVEA.L    -8(A6),A0
10A8: 1010          MOVE.B     (A0),D0
10AA: 4880          EXT.W      D0
10AC: C1C5          ANDA.L     D5,A0
10AE: 3254          MOVEA.W    (A4),A1
10B0: D2C0          MOVE.B     D0,(A1)+
10B2: 2809          MOVE.L     A1,D4
10B4: 326EFFF6      MOVEA.W    -10(A6),A1
10B8: B3C46F043D44  MOVE.W     D4,$6F043D44
10BE: FFF6528B      MOVE.W     -117(A6,D5.W*2),???
10C2: 52AEFFF8      MOVE.B     -8(A6),(A1)
10C6: 548C          MOVE.B     A4,(A2)
10C8: 528A          MOVE.B     A2,(A1)
10CA: BC47          MOVEA.W    D7,A6
10CC: 6EC6          BGT.S      $1094
10CE: 204D          MOVEA.L    A5,A0
10D0: 302EFFF2      MOVE.W     -14(A6),D0
10D4: D0C0          MOVE.B     D0,(A0)+
10D6: D0C0          MOVE.B     D0,(A0)+
10D8: 32289412      MOVE.W     -27630(A0),D1
10DC: C3EEFFF6      ANDA.L     -10(A6),A1
10E0: 48C1          EXT.L      D1
10E2: 93AEFFFC0C6E  MOVE.B     -4(A6),110(A1,D0.L*4)
10E8: 001DFFF6      ORI.B      #$FFF6,(A5)+
10EC: 6E08          BGT.S      $10F6
10EE: 4A6EFFF6      TST.W      -10(A6)
10F2: 6E00021E      BGT.W      $1314
10F6: 4EAD01A2      JSR        418(A5)                        ; JT[418]
10FA: 60000216      BRA.W      $1314
10FE: 246DD5FE      MOVEA.L    -10754(A5),A2
1102: D4C6          MOVE.B     D6,(A2)+
1104: 206DD602      MOVEA.L    -10750(A5),A0
1108: D0C6          MOVE.B     D6,(A0)+
110A: 2D48FFF8      MOVE.L     A0,-8(A6)
110E: 49EDD630      LEA        -10704(A5),A4                  ; A5-10704
1112: D8C6          MOVE.B     D6,(A4)+
1114: D8C6          MOVE.B     D6,(A4)+
1116: 102DB3E1      MOVE.B     -19487(A5),D0                  ; A5-19487
111A: 4880          EXT.W      D0
111C: B06EFFF2      MOVEA.W    -14(A6),A0
1120: 6700011A      BEQ.W      $123E
1124: 102DB3E1      MOVE.B     -19487(A5),D0                  ; A5-19487
1128: 4880          EXT.W      D0
112A: 204D          MOVEA.L    A5,A0
112C: D0C0          MOVE.B     D0,(A0)+
112E: 4A28CE84      TST.B      -12668(A0)
1132: 6666          BNE.S      $119A
1134: 302EFFF6      MOVE.W     -10(A6),D0
1138: C1C5          ANDA.L     D5,A0
113A: 3D40FFF6      MOVE.W     D0,-10(A6)
113E: D16EFFF4204D  MOVE.B     -12(A6),8269(A0)
1144: D0EEFFF2      MOVE.B     -14(A6),(A0)+
1148: 1C28CE84      MOVE.B     -12668(A0),D6
114C: 4886          EXT.W      D6
114E: 5246          MOVEA.B    D6,A1
1150: 7E00          MOVEQ      #0,D7
1152: 3D7C7530FFF6  MOVE.W     #$7530,-10(A6)
1158: 266DD5FA      MOVEA.L    -10758(A5),A3
115C: 6036          BRA.S      $1194
115E: 1013          MOVE.B     (A3),D0
1160: 4880          EXT.W      D0
1162: B06EFFF2      MOVEA.W    -14(A6),A0
1166: 6622          BNE.S      $118A
1168: 4A12          TST.B      (A2)
116A: 661E          BNE.S      $118A
116C: 5247          MOVEA.B    D7,A1
116E: 206EFFF8      MOVEA.L    -8(A6),A0
1172: 1010          MOVE.B     (A0),D0
1174: 4880          EXT.W      D0
1176: C1C5          ANDA.L     D5,A0
1178: 3254          MOVEA.W    (A4),A1
117A: D2C0          MOVE.B     D0,(A1)+
117C: 2809          MOVE.L     A1,D4
117E: 326EFFF6      MOVEA.W    -10(A6),A1
1182: B3C46F043D44  MOVE.W     D4,$6F043D44
1188: FFF6528B      MOVE.W     -117(A6,D5.W*2),???
118C: 52AEFFF8      MOVE.B     -8(A6),(A1)
1190: 548C          MOVE.B     A4,(A2)
1192: 528A          MOVE.B     A2,(A1)
1194: BC47          MOVEA.W    D7,A6
1196: 6EC6          BGT.S      $115E
1198: 6070          BRA.S      $120A
119A: 303C7530      MOVE.W     #$7530,D0
119E: 3D40FFF4      MOVE.W     D0,-12(A6)
11A2: 3D40FFF6      MOVE.W     D0,-10(A6)
11A6: 266DD5FA      MOVEA.L    -10758(A5),A3
11AA: 6056          BRA.S      $1202
11AC: 4A12          TST.B      (A2)
11AE: 664A          BNE.S      $11FA
11B0: BC6EFFF2      MOVEA.W    -14(A6),A6
11B4: 661E          BNE.S      $11D4
11B6: 206EFFF8      MOVEA.L    -8(A6),A0
11BA: 1010          MOVE.B     (A0),D0
11BC: 4880          EXT.W      D0
11BE: C1C5          ANDA.L     D5,A0
11C0: 3254          MOVEA.W    (A4),A1
11C2: D2C0          MOVE.B     D0,(A1)+
11C4: 2809          MOVE.L     A1,D4
11C6: 326EFFF6      MOVEA.W    -10(A6),A1
11CA: B3C46F2C3D44  MOVE.W     D4,$6F2C3D44
11D0: FFF66026      MOVE.W     38(A6,D6.W),???
11D4: 102DB3E1      MOVE.B     -19487(A5),D0                  ; A5-19487
11D8: 4880          EXT.W      D0
11DA: B046          MOVEA.W    D6,A0
11DC: 661C          BNE.S      $11FA
11DE: 206EFFF8      MOVEA.L    -8(A6),A0
11E2: 1010          MOVE.B     (A0),D0
11E4: 4880          EXT.W      D0
11E6: C1C5          ANDA.L     D5,A0
11E8: 3254          MOVEA.W    (A4),A1
11EA: D2C0          MOVE.B     D0,(A1)+
11EC: 2809          MOVE.L     A1,D4
11EE: 326EFFF4      MOVEA.W    -12(A6),A1
11F2: B3C46F043D44  MOVE.W     D4,$6F043D44
11F8: FFF452AE      MOVE.W     -82(A4,D5.W*2),???
11FC: FFF8548C      MOVE.W     $548C.W,???
1200: 528A          MOVE.B     A2,(A1)
1202: 1C1B          MOVE.B     (A3)+,D6
1204: 4886          EXT.W      D6
1206: 4A46          TST.W      D6
1208: 66A2          BNE.S      $11AC
120A: 204D          MOVEA.L    A5,A0
120C: 302EFFF2      MOVE.W     -14(A6),D0
1210: D0C0          MOVE.B     D0,(A0)+
1212: D0C0          MOVE.B     D0,(A0)+
1214: 32289412      MOVE.W     -27630(A0),D1
1218: C3EEFFF6      ANDA.L     -10(A6),A1
121C: 142DB3E1      MOVE.B     -19487(A5),D2                  ; A5-19487
1220: 4882          EXT.W      D2
1222: 204D          MOVEA.L    A5,A0
1224: D0C2          MOVE.B     D2,(A0)+
1226: D0C2          MOVE.B     D2,(A0)+
1228: 34289412      MOVE.W     -27630(A0),D2
122C: C5EEFFF4      ANDA.L     -12(A6),A2
1230: D242          MOVEA.B    D2,A1
1232: 48C1          EXT.L      D1
1234: 93AEFFFC6000  MOVE.B     -4(A6),0(A1,D6.W)
123A: 00D8          DC.W       $00D8
123C: 204D          MOVEA.L    A5,A0
123E: D0EEFFF2      MOVE.B     -14(A6),(A0)+
1242: 4A28CE84      TST.B      -12668(A0)
1246: 663E          BNE.S      $1286
1248: 302EFFF6      MOVE.W     -10(A6),D0
124C: C1C5          ANDA.L     D5,A0
124E: 3D40FFF6      MOVE.W     D0,-10(A6)
1252: D16EFFF4266D  MOVE.B     -12(A6),9837(A0)
1258: D5FA600A528B  MOVE.B     24586(PC),21131(PC)
125E: 52AEFFF8      MOVE.B     -8(A6),(A1)
1262: 548C          MOVE.B     A4,(A2)
1264: 528A          MOVE.B     A2,(A1)
1266: 1013          MOVE.B     (A3),D0
1268: 4880          EXT.W      D0
126A: B06EFFF2      MOVEA.W    -14(A6),A0
126E: 66EC          BNE.S      $125C
1270: 4A12          TST.B      (A2)
1272: 66E8          BNE.S      $125C
1274: 206EFFF8      MOVEA.L    -8(A6),A0
1278: 1010          MOVE.B     (A0),D0
127A: 4880          EXT.W      D0
127C: C1C5          ANDA.L     D5,A0
127E: D054          MOVEA.B    (A4),A0
1280: 3D40FFF6      MOVE.W     D0,-10(A6)
1284: 6070          BRA.S      $12F6
1286: 204D          MOVEA.L    A5,A0
1288: D0EEFFF2      MOVE.B     -14(A6),(A0)+
128C: 1C28CE84      MOVE.B     -12668(A0),D6
1290: 4886          EXT.W      D6
1292: 5446          MOVEA.B    D6,A2
1294: 7E00          MOVEQ      #0,D7
1296: 303C7530      MOVE.W     #$7530,D0
129A: 3D40FFF4      MOVE.W     D0,-12(A6)
129E: 3D40FFF6      MOVE.W     D0,-10(A6)
12A2: 266DD5FA      MOVEA.L    -10758(A5),A3
12A6: 604A          BRA.S      $12F2
12A8: 1013          MOVE.B     (A3),D0
12AA: 4880          EXT.W      D0
12AC: B06EFFF2      MOVEA.W    -14(A6),A0
12B0: 6636          BNE.S      $12E8
12B2: 4A12          TST.B      (A2)
12B4: 6632          BNE.S      $12E8
12B6: 5247          MOVEA.B    D7,A1
12B8: 206EFFF8      MOVEA.L    -8(A6),A0
12BC: 1010          MOVE.B     (A0),D0
12BE: 4880          EXT.W      D0
12C0: C1C5          ANDA.L     D5,A0
12C2: 3254          MOVEA.W    (A4),A1
12C4: D2C0          MOVE.B     D0,(A1)+
12C6: 2809          MOVE.L     A1,D4
12C8: 326EFFF4      MOVEA.W    -12(A6),A1
12CC: B3C46F18306E  MOVE.W     D4,$6F18306E
12D2: FFF6B1C4      MOVE.W     -60(A6,A3.W),???
12D6: 6F0C          BLE.S      $12E4
12D8: 3D6EFFF6FFF4  MOVE.W     -10(A6),-12(A6)
12DE: 3D44FFF6      MOVE.W     D4,-10(A6)
12E2: 6004          BRA.S      $12E8
12E4: 3D44FFF4      MOVE.W     D4,-12(A6)
12E8: 528B          MOVE.B     A3,(A1)
12EA: 52AEFFF8      MOVE.B     -8(A6),(A1)
12EE: 548C          MOVE.B     A4,(A2)
12F0: 528A          MOVE.B     A2,(A1)
12F2: BC47          MOVEA.W    D7,A6
12F4: 6EB2          BGT.S      $12A8
12F6: 204D          MOVEA.L    A5,A0
12F8: 302EFFF2      MOVE.W     -14(A6),D0
12FC: D0C0          MOVE.B     D0,(A0)+
12FE: D0C0          MOVE.B     D0,(A0)+
1300: 322EFFF6      MOVE.W     -10(A6),D1
1304: D26EFFF4      MOVEA.B    -12(A6),A1
1308: C3E89412      ANDA.L     -27630(A0),A1
130C: 48C1          EXT.L      D1
130E: 93AEFFFC4AAE  MOVE.B     -4(A6),-82(A1,D4.L*2)
1314: FFFC6C04      MOVE.W     #$6C04,???
1318: 4EAD01A2      JSR        418(A5)                        ; JT[418]
131C: 206DD5FA      MOVEA.L    -10758(A5),A0
1320: 216EFFFC0010  MOVE.L     -4(A6),16(A0)
1326: 2F2DD5FA      MOVE.L     -10758(A5),-(A7)               ; A5-10758
132A: 206DD674      MOVEA.L    -10636(A5),A0
132E: 4E90          JSR        (A0)
1330: 588F          MOVE.B     A7,(A4)
1332: 422DCEC3      CLR.B      -12605(A5)
1336: 266DD5FA      MOVEA.L    -10758(A5),A3
133A: 41EDCE84      LEA        -12668(A5),A0                  ; A5-12668
133E: 1E1B          MOVE.B     (A3)+,D7
1340: 4887          EXT.W      D7
1342: 42307000      CLR.B      0(A0,D7.W)
1346: 1E1B          MOVE.B     (A3)+,D7
1348: 66F6          BNE.S      $1340
134A: 4CDF1CF0      MOVEM.L    (SP)+,D4/D5/D6/D7/A2/A3/A4     ; restore
134E: 4E5E          UNLK       A6
1350: 4E75          RTS        


; ======= Function at 0x1352 =======
1352: 4E560000      LINK       A6,#0
1356: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
135A: 3C2E000C      MOVE.W     12(A6),D6
135E: 2F2E0008      MOVE.L     8(A6),-(A7)
1362: 4EBA000C      JSR        12(PC)
1366: 4CEE18C0FFF0  MOVEM.L    -16(A6),D6/D7/A3/A4
136C: 4E5E          UNLK       A6
136E: 4E75          RTS        

1370: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
1374: 2E2F0014      MOVE.L     20(A7),D7
1378: 5346EA87      MOVE.B     D6,-5497(A1)
137C: EA87          MOVE.L     D7,(A5)
137E: E58F286D      MOVE.L     A7,109(A2,D2.L)
1382: D140D9C7      MOVE.B     D0,-9785(A0)
1386: 2E1C          MOVE.L     (A4)+,D7
1388: 203CFFFFFC00  MOVE.L     #$FFFFFC00,D0
138E: C087          AND.L      D7,D0
1390: 6744          BEQ.S      $13D6
1392: 1007          MOVE.B     D7,D0
1394: 4880          EXT.W      D0
1396: 47EDD678      LEA        -10632(A5),A3                  ; A5-10632
139A: D6C0          MOVE.B     D0,(A3)+
139C: 4A13          TST.B      (A3)
139E: 6608          BNE.S      $13A8
13A0: 47EDD6B7      LEA        -10569(A5),A3                  ; A5-10569
13A4: 4A13          TST.B      (A3)
13A6: 672E          BEQ.S      $13D6
13A8: 206DD606      MOVEA.L    -10746(A5),A0
13AC: 52ADD606      MOVE.B     -10746(A5),(A1)                ; A5-10746
13B0: 1087          MOVE.B     D7,(A0)
13B2: 5313          MOVE.B     (A3),-(A1)
13B4: 0247FEFF      ANDI.W     #$FEFF,D7
13B8: 246DD6F8      MOVEA.L    -10504(A5),A2
13BC: 2F07          MOVE.L     D7,-(A7)
13BE: 61000042      BSR.W      $1404
13C2: 588F          MOVE.B     A7,(A4)
13C4: 4A46          TST.W      D6
13C6: 6708          BEQ.S      $13D0
13C8: 2F07          MOVE.L     D7,-(A7)
13CA: 6100FFA4      BSR.W      $1372
13CE: 588F          MOVE.B     A7,(A4)
13D0: 5213          MOVE.B     (A3),D1
13D2: 53ADD6060807  MOVE.B     -10746(A5),7(A1,D0.L)          ; A5-10746
13D8: 000967AA      ORI.B      #$67AA,A1
13DC: 5246          MOVEA.B    D6,A1
13DE: 4CDF18C0      MOVEM.L    (SP)+,D6/D7/A3/A4              ; restore
13E2: 4E75          RTS        


; ======= Function at 0x13E4 =======
13E4: 4E560000      LINK       A6,#0
13E8: 48E70738      MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)        ; save
13EC: 246E000C      MOVEA.L    12(A6),A2
13F0: 2F2E0008      MOVE.L     8(A6),-(A7)
13F4: 4EBA000C      JSR        12(PC)
13F8: 4CEE1CE0FFE8  MOVEM.L    -24(A6),D5/D6/D7/A2/A3/A4
13FE: 4E5E          UNLK       A6
1400: 4E75          RTS        

1402: 48E70738      MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)        ; save
1406: 2E2F001C      MOVE.L     28(A7),D7
140A: 1A1A          MOVE.B     (A2)+,D5
140C: 6740          BEQ.S      $144E
140E: EA8F          MOVE.L     A7,(A5)
1410: EA8F          MOVE.L     A7,(A5)
1412: E58F286D      MOVE.L     A7,109(A2,D2.L)
1416: D140D9C7      MOVE.B     D0,-9785(A0)
141A: 2E1C          MOVE.L     (A4)+,D7
141C: 08070009      BTST       #9,D7
1420: 6604          BNE.S      $1426
1422: BE05          MOVE.W     D5,D7
1424: 6DF4          BLT.S      $141A
1426: BE05          MOVE.W     D5,D7
1428: 660000AE      BNE.W      $14DA
142C: 206DD606      MOVEA.L    -10746(A5),A0
1430: 52ADD606      MOVE.B     -10746(A5),(A1)                ; A5-10746
1434: 1087          MOVE.B     D7,(A0)
1436: 58ADD6FC      MOVE.B     -10500(A5),(A4)                ; A5-10500
143A: 2F07          MOVE.L     D7,-(A7)
143C: 6100FFC4      BSR.W      $1404
1440: 588F          MOVE.B     A7,(A4)
1442: 59ADD6FC53AD  MOVE.B     -10500(A5),-83(A4,D5.W*2)      ; A5-10500
1448: D606          MOVE.B     D6,D3
144A: 6000008C      BRA.W      $14DA
144E: 08070008      BTST       #8,D7
1452: 6722          BEQ.S      $1476
1454: 206DD606      MOVEA.L    -10746(A5),A0
1458: 4210          CLR.B      (A0)
145A: 202DD606      MOVE.L     -10746(A5),D0                  ; A5-10746
145E: 90ADD5FA      MOVE.B     -10758(A5),(A0)                ; A5-10758
1462: 220A          MOVE.L     A2,D1
1464: 92ADD60A      MOVE.B     -10742(A5),(A1)                ; A5-10742
1468: 9200          MOVE.B     D0,D1
146A: 206DD5FA      MOVEA.L    -10758(A5),A0
146E: 11410021      MOVE.B     D1,33(A0)
1472: 4EBAF9CE      JSR        -1586(PC)
1476: EA8F          MOVE.L     A7,(A5)
1478: EA8F          MOVE.L     A7,(A5)
147A: 675C          BEQ.S      $14D8
147C: 206DD6FC      MOVEA.L    -10500(A5),A0
1480: 2C10          MOVE.L     (A0),D6
1482: 6754          BEQ.S      $14D8
1484: E58F286D      MOVE.L     A7,109(A2,D2.L)
1488: D140D9C7      MOVE.B     D0,-9785(A0)
148C: 2E1C          MOVE.L     (A4)+,D7
148E: 4280          CLR.L      D0
1490: 1007          MOVE.B     D7,D0
1492: 04000061      SUBI.B     #$0061,D0
1496: 0106          BTST       D0,D6
1498: 6738          BEQ.S      $14D2
149A: 1007          MOVE.B     D7,D0
149C: 4880          EXT.W      D0
149E: 47EDD678      LEA        -10632(A5),A3                  ; A5-10632
14A2: D6C0          MOVE.B     D0,(A3)+
14A4: 4A13          TST.B      (A3)
14A6: 6608          BNE.S      $14B0
14A8: 47EDD6B7      LEA        -10569(A5),A3                  ; A5-10569
14AC: 4A13          TST.B      (A3)
14AE: 6722          BEQ.S      $14D2
14B0: 206DD606      MOVEA.L    -10746(A5),A0
14B4: 52ADD606      MOVE.B     -10746(A5),(A1)                ; A5-10746
14B8: 1087          MOVE.B     D7,(A0)
14BA: 5313          MOVE.B     (A3),-(A1)
14BC: 58ADD6FC      MOVE.B     -10500(A5),(A4)                ; A5-10500
14C0: 2F07          MOVE.L     D7,-(A7)
14C2: 6100FF3E      BSR.W      $1404
14C6: 588F          MOVE.B     A7,(A4)
14C8: 59ADD6FC5213  MOVE.B     -10500(A5),19(A4,D5.W*2)       ; A5-10500
14CE: 53ADD6060807  MOVE.B     -10746(A5),7(A1,D0.L)          ; A5-10746
14D4: 000967B4      ORI.B      #$67B4,A1
14D8: 538A4CDF      MOVE.B     A2,-33(A1,D4.L*4)
14DC: 1CE0          MOVE.B     -(A0),(A6)+
14DE: 4E75          RTS        
