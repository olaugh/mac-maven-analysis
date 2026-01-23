;======================================================================
; CODE 20 Disassembly
; File: /tmp/maven_code_20.bin
; Header: JT offset=928, JT entries=17
; Code size: 3398 bytes
;======================================================================

0000: 4EBA051A      JSR        1306(PC)
0004: 48780220      PEA        $0220.W
0008: 486DBCFE      PEA        -17154(A5)                     ; g_state1
000C: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0010: 48780121      PEA        $0121.W
0014: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
0018: 4EAD01AA      JSR        426(A5)                        ; JT[426]
001C: 48780121      PEA        $0121.W
0020: 486DD88D      PEA        -10099(A5)                     ; A5-10099
0024: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0028: 48780440      PEA        $0440.W
002C: 486DBF1E      PEA        -16610(A5)                     ; g_state2
0030: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0034: 426DD9AE      CLR.W      -9810(A5)
0038: 4EAD0292      JSR        658(A5)                        ; JT[658]
003C: 4EAD053A      JSR        1338(A5)                       ; JT[1338]
0040: 4EBA0CB4      JSR        3252(PC)
0044: 4FEF0020      LEA        32(A7),A7
0048: 4E75          RTS        

004A: 48780220      PEA        $0220.W
004E: 486DBCFE      PEA        -17154(A5)                     ; g_state1
0052: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0056: 48780440      PEA        $0440.W
005A: 486DBF1E      PEA        -16610(A5)                     ; g_state2
005E: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0062: 486D0442      PEA        1090(A5)                       ; A5+1090
0066: 4EBA03AE      JSR        942(PC)
006A: 4EAD053A      JSR        1338(A5)                       ; JT[1338]
006E: 4FEF0014      LEA        20(A7),A7
0072: 4E75          RTS        


; ======= Function at 0x0074 =======
0074: 4E560000      LINK       A6,#0
0078: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
007C: 3E2E0008      MOVE.W     8(A6),D7
0080: 3C2E000A      MOVE.W     10(A6),D6
0084: 7011          MOVEQ      #17,D0
0086: C1C7          ANDA.L     D7,A0
0088: 49EDD76C      LEA        -10388(A5),A4                  ; g_lookup_tbl
008C: D08C          MOVE.B     A4,(A0)
008E: 3846          MOVEA.W    D6,A4
0090: D08C          MOVE.B     A4,(A0)
0092: 2840          MOVEA.L    D0,A4
0094: 7011          MOVEQ      #17,D0
0096: C1C7          ANDA.L     D7,A0
0098: 47EDD88D      LEA        -10099(A5),A3                  ; A5-10099
009C: D08B          MOVE.B     A3,(A0)
009E: 3646          MOVEA.W    D6,A3
00A0: D08B          MOVE.B     A3,(A0)
00A2: 2640          MOVEA.L    D0,A3
00A4: 1014          MOVE.B     (A4),D0
00A6: B013          MOVE.W     (A3),D0
00A8: 670C          BEQ.S      $00B6
00AA: 1893          MOVE.B     (A3),(A4)
00AC: 3F06          MOVE.W     D6,-(A7)
00AE: 3F07          MOVE.W     D7,-(A7)
00B0: 4EBA0592      JSR        1426(PC)
00B4: 588F          MOVE.B     A7,(A4)
00B6: 4CDF18C0      MOVEM.L    (SP)+,D6/D7/A3/A4              ; restore
00BA: 4E5E          UNLK       A6
00BC: 4E75          RTS        


; ======= Function at 0x00BE =======
00BE: 4E56FFF8      LINK       A6,#-8                         ; frame=8
00C2: 48E71F08      MOVEM.L    D3/D4/D5/D6/D7/A4,-(SP)        ; save
00C6: 7E00          MOVEQ      #0,D7
00C8: 7C00          MOVEQ      #0,D6
00CA: 42AEFFF8      CLR.L      -8(A6)
00CE: 42AEFFFC      CLR.L      -4(A6)
00D2: 7A00          MOVEQ      #0,D5
00D4: 49EDDE28      LEA        -8664(A5),A4                   ; g_flag1
00D8: 3814          MOVE.W     (A4),D4
00DA: 4A44          TST.W      D4
00DC: 6738          BEQ.S      $0116
00DE: 2604          MOVE.L     D4,D3
00E0: 48C3          EXT.L      D3
00E2: D7AEFFFC2F03  MOVE.B     -4(A6),3(A3,D2.L*8)
00E8: 2F03          MOVE.L     D3,-(A7)
00EA: 4EAD0042      JSR        66(A5)                         ; JT[66]
00EE: DC80          MOVE.B     D0,(A6)
00F0: 2F03          MOVE.L     D3,-(A7)
00F2: 2F03          MOVE.L     D3,-(A7)
00F4: 2F03          MOVE.L     D3,-(A7)
00F6: 4EAD0042      JSR        66(A5)                         ; JT[66]
00FA: 2F00          MOVE.L     D0,-(A7)
00FC: 4EAD0042      JSR        66(A5)                         ; JT[66]
0100: 2800          MOVE.L     D0,D4
0102: DE84          MOVE.B     D4,(A7)
0104: 2F04          MOVE.L     D4,-(A7)
0106: 2F03          MOVE.L     D3,-(A7)
0108: 4EAD0042      JSR        66(A5)                         ; JT[66]
010C: D1AEFFF85285  MOVE.B     -8(A6),-123(A0,D5.W*2)
0112: 588C          MOVE.B     A4,(A4)
0114: 60C2          BRA.S      $00D8
0116: 486DC366      PEA        -15514(A5)                     ; g_field_14
011A: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
011E: B085          MOVE.W     D5,(A0)
0120: 588F          MOVE.B     A7,(A4)
0122: 6704          BEQ.S      $0128
0124: 7000          MOVEQ      #0,D0
0126: 6060          BRA.S      $0188
0128: 7A00          MOVEQ      #0,D5
012A: 204D          MOVEA.L    A5,A0
012C: D1C51828      MOVE.B     D5,$1828.W
0130: C366          AND.W      D1,-(A6)
0132: 4A04          TST.B      D4
0134: 6738          BEQ.S      $016E
0136: 1604          MOVE.B     D4,D3
0138: 4883          EXT.W      D3
013A: 48C3          EXT.L      D3
013C: 97AEFFFC2F03  MOVE.B     -4(A6),3(A3,D2.L*8)
0142: 2F03          MOVE.L     D3,-(A7)
0144: 4EAD0042      JSR        66(A5)                         ; JT[66]
0148: 9C80          MOVE.B     D0,(A6)
014A: 2F03          MOVE.L     D3,-(A7)
014C: 2F03          MOVE.L     D3,-(A7)
014E: 2F03          MOVE.L     D3,-(A7)
0150: 4EAD0042      JSR        66(A5)                         ; JT[66]
0154: 2F00          MOVE.L     D0,-(A7)
0156: 4EAD0042      JSR        66(A5)                         ; JT[66]
015A: 2800          MOVE.L     D0,D4
015C: 9E84          MOVE.B     D4,(A7)
015E: 2F04          MOVE.L     D4,-(A7)
0160: 2F03          MOVE.L     D3,-(A7)
0162: 4EAD0042      JSR        66(A5)                         ; JT[66]
0166: 91AEFFF85285  MOVE.B     -8(A6),-123(A0,D5.W*2)
016C: 60BC          BRA.S      $012A
016E: 4AAEFFFC      TST.L      -4(A6)
0172: 660E          BNE.S      $0182
0174: 4A86          TST.L      D6
0176: 660A          BNE.S      $0182
0178: 4A87          TST.L      D7
017A: 6606          BNE.S      $0182
017C: 4AAEFFF8      TST.L      -8(A6)
0180: 6704          BEQ.S      $0186
0182: 7000          MOVEQ      #0,D0
0184: 6002          BRA.S      $0188
0186: 7001          MOVEQ      #1,D0
0188: 4CDF10F8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A4        ; restore
018C: 4E5E          UNLK       A6
018E: 4E75          RTS        

0190: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
0194: 486D0432      PEA        1074(A5)                       ; A5+1074
0198: 4EBA027C      JSR        636(PC)
019C: 7008          MOVEQ      #8,D0
019E: 2E80          MOVE.L     D0,(A7)
01A0: 486DA74E      PEA        -22706(A5)                     ; A5-22706
01A4: 4EAD01AA      JSR        426(A5)                        ; JT[426]
01A8: 4EBAFF14      JSR        -236(PC)
01AC: 4A40          TST.W      D0
01AE: 508F          MOVE.B     A7,(A0)
01B0: 6718          BEQ.S      $01CA
01B2: 7E00          MOVEQ      #0,D7
01B4: 600C          BRA.S      $01C2
01B6: 4267          CLR.W      -(A7)
01B8: 3F07          MOVE.W     D7,-(A7)
01BA: 4EAD0562      JSR        1378(A5)                       ; JT[1378]
01BE: 588F          MOVE.B     A7,(A4)
01C0: 5247          MOVEA.B    D7,A1
01C2: 0C470007      CMPI.W     #$0007,D7
01C6: 6DEE          BLT.S      $01B6
01C8: 6062          BRA.S      $022C
01CA: 7E00          MOVEQ      #0,D7
01CC: 49EDDE28      LEA        -8664(A5),A4                   ; g_flag1
01D0: 204D          MOVEA.L    A5,A0
01D2: D0C7          MOVE.B     D7,(A0)+
01D4: 1C28C366      MOVE.B     -15514(A0),D6
01D8: 47EDC366      LEA        -15514(A5),A3                  ; g_field_14
01DC: D6C7          MOVE.B     D7,(A3)+
01DE: 4A06          TST.B      D6
01E0: 6724          BEQ.S      $0206
01E2: 1006          MOVE.B     D6,D0
01E4: 4880          EXT.W      D0
01E6: B054          MOVEA.W    (A4),A0
01E8: 6706          BEQ.S      $01F0
01EA: 397C00010002  MOVE.W     #$0001,2(A4)
01F0: 1013          MOVE.B     (A3),D0
01F2: 4880          EXT.W      D0
01F4: 3880          MOVE.W     D0,(A4)
01F6: 4267          CLR.W      -(A7)
01F8: 3F07          MOVE.W     D7,-(A7)
01FA: 4EAD0562      JSR        1378(A5)                       ; JT[1378]
01FE: 588F          MOVE.B     A7,(A4)
0200: 5247          MOVEA.B    D7,A1
0202: 588C          MOVE.B     A4,(A4)
0204: 60CA          BRA.S      $01D0
0206: 2007          MOVE.L     D7,D0
0208: 48C0          EXT.L      D0
020A: E58849ED      MOVE.L     A0,-19(A2,D4.L)
020E: DE28D08C      MOVE.B     -12148(A0),D7
0212: 2840          MOVEA.L    D0,A4
0214: 6010          BRA.S      $0226
0216: 4254          CLR.W      (A4)
0218: 4267          CLR.W      -(A7)
021A: 3F07          MOVE.W     D7,-(A7)
021C: 4EAD0562      JSR        1378(A5)                       ; JT[1378]
0220: 588F          MOVE.B     A7,(A4)
0222: 5247          MOVEA.B    D7,A1
0224: 588C          MOVE.B     A4,(A4)
0226: 0C470007      CMPI.W     #$0007,D7
022A: 6DEA          BLT.S      $0216
022C: 4CDF18C0      MOVEM.L    (SP)+,D6/D7/A3/A4              ; restore
0230: 4E75          RTS        


; ======= Function at 0x0232 =======
0232: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0236: 4A6DD9AE      TST.W      -9810(A5)
023A: 6626          BNE.S      $0262
023C: 7011          MOVEQ      #17,D0
023E: C1EE0008      ANDA.L     8(A6),A0
0242: D08D          MOVE.B     A5,(A0)
0244: 306E000A      MOVEA.W    10(A6),A0
0248: D1C07011      MOVE.B     D0,$7011.W
024C: C1EE0008      ANDA.L     8(A6),A0
0250: D08D          MOVE.B     A5,(A0)
0252: 326E000A      MOVEA.W    10(A6),A1
0256: D3C01028D88D  MOVE.B     D0,$1028D88D
025C: B029D76C      MOVE.W     -10388(A1),D0
0260: 660C          BNE.S      $026E
0262: 3F2E000A      MOVE.W     10(A6),-(A7)
0266: 3F2E0008      MOVE.W     8(A6),-(A7)
026A: 4EBA0006      JSR        6(PC)
026E: 4E5E          UNLK       A6
0270: 4E75          RTS        


; ======= Function at 0x0272 =======
0272: 4E560000      LINK       A6,#0
0276: 48E71F08      MOVEM.L    D3/D4/D5/D6/D7/A4,-(SP)        ; save
027A: 3C2E0008      MOVE.W     8(A6),D6
027E: 3A2E000A      MOVE.W     10(A6),D5
0282: 7011          MOVEQ      #17,D0
0284: C1C6          ANDA.L     D6,A0
0286: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
028A: D088          MOVE.B     A0,(A0)
028C: 3045          MOVEA.W    D5,A0
028E: 1E300800      MOVE.B     0(A0,D0.L),D7
0292: 4887          EXT.W      D7
0294: 7011          MOVEQ      #17,D0
0296: C1C6          ANDA.L     D6,A0
0298: 49EDD88D      LEA        -10099(A5),A4                  ; A5-10099
029C: D08C          MOVE.B     A4,(A0)
029E: 3845          MOVEA.W    D5,A4
02A0: D08C          MOVE.B     A4,(A0)
02A2: 2840          MOVEA.L    D0,A4
02A4: 1014          MOVE.B     (A4),D0
02A6: 4880          EXT.W      D0
02A8: BE40          MOVEA.W    D0,A7
02AA: 670C          BEQ.S      $02B8
02AC: 1887          MOVE.B     D7,(A4)
02AE: 3F05          MOVE.W     D5,-(A7)
02B0: 3F06          MOVE.W     D6,-(A7)
02B2: 4EBA0390      JSR        912(PC)
02B6: 588F          MOVE.B     A7,(A4)
02B8: 4A47          TST.W      D7
02BA: 6774          BEQ.S      $0330
02BC: 780F          MOVEQ      #15,D4
02BE: D845          MOVEA.B    D5,A4
02C0: 3606          MOVE.W     D6,D3
02C2: 7011          MOVEQ      #17,D0
02C4: C1C6          ANDA.L     D6,A0
02C6: 49EDBCFE      LEA        -17154(A5),A4                  ; g_state1
02CA: D08C          MOVE.B     A4,(A0)
02CC: 3845          MOVEA.W    D5,A4
02CE: D08C          MOVE.B     A4,(A0)
02D0: 2840          MOVEA.L    D0,A4
02D2: 3F07          MOVE.W     D7,-(A7)
02D4: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
02D8: 1880          MOVE.B     D0,(A4)
02DA: 7211          MOVEQ      #17,D1
02DC: C3C4          ANDA.L     D4,A1
02DE: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
02E2: D288          MOVE.B     A0,(A1)
02E4: 3043          MOVEA.W    D3,A0
02E6: 11801800      MOVE.B     D0,0(A0,D1.L)
02EA: 7000          MOVEQ      #0,D0
02EC: 1007          MOVE.B     D7,D0
02EE: 204D          MOVEA.L    A5,A0
02F0: D1C04A28      MOVE.B     D0,$4A28.W
02F4: FBD8          MOVE.W     (A0)+,???
02F6: 548F          MOVE.B     A7,(A2)
02F8: 6A04          BPL.S      $02FE
02FA: 7000          MOVEQ      #0,D0
02FC: 600E          BRA.S      $030C
02FE: 1014          MOVE.B     (A4),D0
0300: 4880          EXT.W      D0
0302: 204D          MOVEA.L    A5,A0
0304: D0C0          MOVE.B     D0,(A0)+
0306: D0C0          MOVE.B     D0,(A0)+
0308: 30289412      MOVE.W     -27630(A0),D0
030C: 7222          MOVEQ      #34,D1
030E: C3C6          ANDA.L     D6,A1
0310: 41EDBF1E      LEA        -16610(A5),A0                  ; g_state2
0314: D288          MOVE.B     A0,(A1)
0316: 3045          MOVEA.W    D5,A0
0318: D1C83180      MOVE.B     A0,$3180.W
031C: 1800          MOVE.B     D0,D4
031E: 7222          MOVEQ      #34,D1
0320: C3C4          ANDA.L     D4,A1
0322: 41EDBF1E      LEA        -16610(A5),A0                  ; g_state2
0326: D288          MOVE.B     A0,(A1)
0328: 3043          MOVEA.W    D3,A0
032A: D1C83180      MOVE.B     A0,$3180.W
032E: 1800          MOVE.B     D0,D4
0330: 4CDF10F8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A4        ; restore
0334: 4E5E          UNLK       A6
0336: 4E75          RTS        


; ======= Function at 0x0338 =======
0338: 4E560000      LINK       A6,#0
033C: 48E70718      MOVEM.L    D5/D6/D7/A3/A4,-(SP)           ; save
0340: 3C2E0008      MOVE.W     8(A6),D6
0344: 3A2E000A      MOVE.W     10(A6),D5
0348: 7011          MOVEQ      #17,D0
034A: C1C6          ANDA.L     D6,A0
034C: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
0350: D088          MOVE.B     A0,(A0)
0352: 3045          MOVEA.W    D5,A0
0354: 1E300800      MOVE.B     0(A0,D0.L),D7
0358: 4887          EXT.W      D7
035A: 7022          MOVEQ      #34,D0
035C: C1C6          ANDA.L     D6,A0
035E: 41EDBF1E      LEA        -16610(A5),A0                  ; g_state2
0362: D088          MOVE.B     A0,(A0)
0364: 3045          MOVEA.W    D5,A0
0366: D1C84A70      MOVE.B     A0,$4A70.W
036A: 0800670A      BTST       #26378,D0
036E: 3F07          MOVE.W     D7,-(A7)
0370: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
0374: 548F          MOVE.B     A7,(A2)
0376: 6002          BRA.S      $037A
0378: 3007          MOVE.W     D7,D0
037A: 7211          MOVEQ      #17,D1
037C: C3C6          ANDA.L     D6,A1
037E: 49EDD88D      LEA        -10099(A5),A4                  ; A5-10099
0382: D28C          MOVE.B     A4,(A1)
0384: 3845          MOVEA.W    D5,A4
0386: D28C          MOVE.B     A4,(A1)
0388: 2841          MOVEA.L    D1,A4
038A: 1880          MOVE.B     D0,(A4)
038C: 7011          MOVEQ      #17,D0
038E: C1C6          ANDA.L     D6,A0
0390: 47EDD76C      LEA        -10388(A5),A3                  ; g_lookup_tbl
0394: D08B          MOVE.B     A3,(A0)
0396: 3645          MOVEA.W    D5,A3
0398: D08B          MOVE.B     A3,(A0)
039A: 2640          MOVEA.L    D0,A3
039C: 1013          MOVE.B     (A3),D0
039E: B014          MOVE.W     (A4),D0
03A0: 670C          BEQ.S      $03AE
03A2: 1694          MOVE.B     (A4),(A3)
03A4: 3F05          MOVE.W     D5,-(A7)
03A6: 3F06          MOVE.W     D6,-(A7)
03A8: 4EBA029A      JSR        666(PC)
03AC: 588F          MOVE.B     A7,(A4)
03AE: 4CDF18E0      MOVEM.L    (SP)+,D5/D6/D7/A3/A4           ; restore
03B2: 4E5E          UNLK       A6
03B4: 4E75          RTS        

03B6: 48780220      PEA        $0220.W
03BA: 486DBCFE      PEA        -17154(A5)                     ; g_state1
03BE: 4EAD01AA      JSR        426(A5)                        ; JT[426]
03C2: 48780440      PEA        $0440.W
03C6: 486DBF1E      PEA        -16610(A5)                     ; g_state2
03CA: 4EAD01AA      JSR        426(A5)                        ; JT[426]
03CE: 486D041A      PEA        1050(A5)                       ; A5+1050
03D2: 4EBA0042      JSR        66(PC)
03D6: 4FEF0014      LEA        20(A7),A7
03DA: 4E75          RTS        


; ======= Function at 0x03DC =======
03DC: 4E56FFFE      LINK       A6,#-2                         ; frame=2
03E0: 48780121      PEA        $0121.W
03E4: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
03E8: 4EAD01AA      JSR        426(A5)                        ; JT[426]
03EC: 48780121      PEA        $0121.W
03F0: 486DD88D      PEA        -10099(A5)                     ; A5-10099
03F4: 4EAD01AA      JSR        426(A5)                        ; JT[426]
03F8: 486D0402      PEA        1026(A5)                       ; A5+1026
03FC: 4EBA0018      JSR        24(PC)
0400: 4EBA011A      JSR        282(PC)
0404: 4EAD053A      JSR        1338(A5)                       ; JT[1338]
0408: 4E5E          UNLK       A6
040A: 4E75          RTS        

040C: 4EBA010E      JSR        270(PC)
0410: 4EBA05BA      JSR        1466(PC)
0414: 4E75          RTS        


; ======= Function at 0x0416 =======
0416: 4E560000      LINK       A6,#0
041A: 48E70300      MOVEM.L    D6/D7,-(SP)                    ; save
041E: 7E01          MOVEQ      #1,D7
0420: 601A          BRA.S      $043C
0422: 7C01          MOVEQ      #1,D6
0424: 600E          BRA.S      $0434
0426: 3F06          MOVE.W     D6,-(A7)
0428: 3F07          MOVE.W     D7,-(A7)
042A: 206E0008      MOVEA.L    8(A6),A0
042E: 4E90          JSR        (A0)
0430: 588F          MOVE.B     A7,(A4)
0432: 5246          MOVEA.B    D6,A1
0434: 0C460010      CMPI.W     #$0010,D6
0438: 6DEC          BLT.S      $0426
043A: 5247          MOVEA.B    D7,A1
043C: 0C470010      CMPI.W     #$0010,D7
0440: 6DE0          BLT.S      $0422
0442: 4CDF00C0      MOVEM.L    (SP)+,D6/D7                    ; restore
0446: 4E5E          UNLK       A6
0448: 4E75          RTS        


; ======= Function at 0x044A =======
044A: 4E56FFF8      LINK       A6,#-8                         ; frame=8
044E: 48E71F08      MOVEM.L    D3/D4/D5/D6/D7/A4,-(SP)        ; save
0452: 7E00          MOVEQ      #0,D7
0454: 7C00          MOVEQ      #0,D6
0456: 42AEFFF8      CLR.L      -8(A6)
045A: 42AEFFFC      CLR.L      -4(A6)
045E: 7A00          MOVEQ      #0,D5
0460: 49EDDE28      LEA        -8664(A5),A4                   ; g_flag1
0464: 3814          MOVE.W     (A4),D4
0466: 4A44          TST.W      D4
0468: 6738          BEQ.S      $04A2
046A: 2604          MOVE.L     D4,D3
046C: 48C3          EXT.L      D3
046E: D7AEFFFC2F03  MOVE.B     -4(A6),3(A3,D2.L*8)
0474: 2F03          MOVE.L     D3,-(A7)
0476: 4EAD0042      JSR        66(A5)                         ; JT[66]
047A: DC80          MOVE.B     D0,(A6)
047C: 2F03          MOVE.L     D3,-(A7)
047E: 2F03          MOVE.L     D3,-(A7)
0480: 2F03          MOVE.L     D3,-(A7)
0482: 4EAD0042      JSR        66(A5)                         ; JT[66]
0486: 2F00          MOVE.L     D0,-(A7)
0488: 4EAD0042      JSR        66(A5)                         ; JT[66]
048C: 2800          MOVE.L     D0,D4
048E: DE84          MOVE.B     D4,(A7)
0490: 2F04          MOVE.L     D4,-(A7)
0492: 2F03          MOVE.L     D3,-(A7)
0494: 4EAD0042      JSR        66(A5)                         ; JT[66]
0498: D1AEFFF85285  MOVE.B     -8(A6),-123(A0,D5.W*2)
049E: 588C          MOVE.B     A4,(A4)
04A0: 60C2          BRA.S      $0464
04A2: 486DC366      PEA        -15514(A5)                     ; g_field_14
04A6: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
04AA: B085          MOVE.W     D5,(A0)
04AC: 588F          MOVE.B     A7,(A4)
04AE: 6704          BEQ.S      $04B4
04B0: 7000          MOVEQ      #0,D0
04B2: 6060          BRA.S      $0514
04B4: 7A00          MOVEQ      #0,D5
04B6: 204D          MOVEA.L    A5,A0
04B8: D1C51828      MOVE.B     D5,$1828.W
04BC: C366          AND.W      D1,-(A6)
04BE: 4A04          TST.B      D4
04C0: 6738          BEQ.S      $04FA
04C2: 1604          MOVE.B     D4,D3
04C4: 4883          EXT.W      D3
04C6: 48C3          EXT.L      D3
04C8: 97AEFFFC2F03  MOVE.B     -4(A6),3(A3,D2.L*8)
04CE: 2F03          MOVE.L     D3,-(A7)
04D0: 4EAD0042      JSR        66(A5)                         ; JT[66]
04D4: 9C80          MOVE.B     D0,(A6)
04D6: 2F03          MOVE.L     D3,-(A7)
04D8: 2F03          MOVE.L     D3,-(A7)
04DA: 2F03          MOVE.L     D3,-(A7)
04DC: 4EAD0042      JSR        66(A5)                         ; JT[66]
04E0: 2F00          MOVE.L     D0,-(A7)
04E2: 4EAD0042      JSR        66(A5)                         ; JT[66]
04E6: 2800          MOVE.L     D0,D4
04E8: 9E84          MOVE.B     D4,(A7)
04EA: 2F04          MOVE.L     D4,-(A7)
04EC: 2F03          MOVE.L     D3,-(A7)
04EE: 4EAD0042      JSR        66(A5)                         ; JT[66]
04F2: 91AEFFF85285  MOVE.B     -8(A6),-123(A0,D5.W*2)
04F8: 60BC          BRA.S      $04B6
04FA: 4AAEFFFC      TST.L      -4(A6)
04FE: 660E          BNE.S      $050E
0500: 4A86          TST.L      D6
0502: 660A          BNE.S      $050E
0504: 4A87          TST.L      D7
0506: 6606          BNE.S      $050E
0508: 4AAEFFF8      TST.L      -8(A6)
050C: 6704          BEQ.S      $0512
050E: 7000          MOVEQ      #0,D0
0510: 6002          BRA.S      $0514
0512: 7001          MOVEQ      #1,D0
0514: 4CDF10F8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A4        ; restore
0518: 4E5E          UNLK       A6
051A: 4E75          RTS        


; ======= Function at 0x051C =======
051C: 4E56FFF8      LINK       A6,#-8                         ; frame=8
0520: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
0524: A873486E      MOVEA.L    110(A3,D4.L),A4
0528: FFF84EBA      MOVE.W     $4EBA.W,???
052C: 000C486E      ORI.B      #$486E,A4
0530: FFF8A928      MOVE.W     $A928.W,???
0534: 4E5E          UNLK       A6
0536: 4E75          RTS        


; ======= Function at 0x0538 =======
0538: 4E560000      LINK       A6,#0
053C: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
0540: 286E0008      MOVEA.L    8(A6),A4
0544: 2F3C00010001  MOVE.L     #$00010001,-(A7)
054A: 2F0C          MOVE.L     A4,-(A7)
054C: 4EBA00A2      JSR        162(PC)
0550: 700A          MOVEQ      #10,D0
0552: D0ADDE80      MOVE.B     -8576(A5),(A0)                 ; A5-8576
0556: 2640          MOVEA.L    D0,A3
0558: 700F          MOVEQ      #15,D0
055A: C1D3          ANDA.L     (A3),A0
055C: D06C0002      MOVEA.B    2(A4),A0
0560: 39400006      MOVE.W     D0,6(A4)
0564: 700F          MOVEQ      #15,D0
0566: C1D3          ANDA.L     (A3),A0
0568: D054          MOVEA.B    (A4),A0
056A: 39400004      MOVE.W     D0,4(A4)
056E: 2E8C          MOVE.L     A4,(A7)
0570: 2F3CFFFEFFFE  MOVE.L     #$FFFEFFFE,-(A7)
0576: A8A94CEE      MOVE.L     19694(A1),(A4)
057A: 1800          MOVE.B     D0,D4
057C: FFF84E5E      MOVE.W     $4E5E.W,???
0580: 4E75          RTS        


; ======= Function at 0x0582 =======
0582: 4E560000      LINK       A6,#0
0586: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
058A: 266E0008      MOVEA.L    8(A6),A3
058E: 7010          MOVEQ      #16,D0
0590: D0ADDE80      MOVE.B     -8576(A5),(A0)                 ; A5-8576
0594: 2840          MOVEA.L    D0,A4
0596: 3013          MOVE.W     (A3),D0
0598: B054          MOVEA.W    (A4),A0
059A: 6D0E          BLT.S      $05AA
059C: 206DDE80      MOVEA.L    -8576(A5),A0
05A0: 302B0002      MOVE.W     2(A3),D0
05A4: B068000E      MOVEA.W    14(A0),A0
05A8: 6C0E          BGE.S      $05B8
05AA: 206E0010      MOVEA.L    16(A6),A0
05AE: 4250          CLR.W      (A0)
05B0: 226E000C      MOVEA.L    12(A6),A1
05B4: 4251          CLR.W      (A1)
05B6: 6030          BRA.S      $05E8
05B8: 206DDE80      MOVEA.L    -8576(A5),A0
05BC: 3013          MOVE.W     (A3),D0
05BE: 9054          MOVEA.B    (A4),A0
05C0: 48C0          EXT.L      D0
05C2: 81E8000A      ORA.L      10(A0),A0
05C6: 5240          MOVEA.B    D0,A1
05C8: 226E000C      MOVEA.L    12(A6),A1
05CC: 3280          MOVE.W     D0,(A1)
05CE: 206DDE80      MOVEA.L    -8576(A5),A0
05D2: 302B0002      MOVE.W     2(A3),D0
05D6: 9068000E      MOVEA.B    14(A0),A0
05DA: 48C0          EXT.L      D0
05DC: 81E8000A      ORA.L      10(A0),A0
05E0: 5240          MOVEA.B    D0,A1
05E2: 206E0010      MOVEA.L    16(A6),A0
05E6: 3080          MOVE.W     D0,(A0)
05E8: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
05EC: 4E5E          UNLK       A6
05EE: 4E75          RTS        


; ======= Function at 0x05F0 =======
05F0: 4E560000      LINK       A6,#0
05F4: 2F2E0008      MOVE.L     8(A6),-(A7)
05F8: 206DDE80      MOVEA.L    -8576(A5),A0
05FC: 70FF          MOVEQ      #-1,D0
05FE: D06E000E      MOVEA.B    14(A6),A0
0602: C1E8000A      ANDA.L     10(A0),A0
0606: 53403F00      MOVE.B     D0,16128(A1)
060A: 70FF          MOVEQ      #-1,D0
060C: D06E000C      MOVEA.B    12(A6),A0
0610: C1E8000A      ANDA.L     10(A0),A0
0614: 53403F00      MOVE.B     D0,16128(A1)
0618: 3028000A      MOVE.W     10(A0),D0
061C: C1EE000E      ANDA.L     14(A6),A0
0620: 3F00          MOVE.W     D0,-(A7)
0622: 3028000A      MOVE.W     10(A0),D0
0626: C1EE000C      ANDA.L     12(A6),A0
062A: 3F00          MOVE.W     D0,-(A7)
062C: A8A7          MOVE.L     -(A7),(A4)
062E: 2F2E0008      MOVE.L     8(A6),-(A7)
0632: 206DDE80      MOVEA.L    -8576(A5),A0
0636: 3F28000E      MOVE.W     14(A0),-(A7)
063A: 3F280010      MOVE.W     16(A0),-(A7)
063E: A8A84E5E      MOVE.L     20062(A0),(A4)
0642: 4E75          RTS        


; ======= Function at 0x0644 =======
0644: 4E560000      LINK       A6,#0
0648: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
064C: A8733F2E      MOVEA.L    46(A3,D3.L*8),A4
0650: 000A3F2E      ORI.B      #$3F2E,A2
0654: 00084EBA      ORI.B      #$4EBA,A0
0658: 01F44E5E      BSET       D0,94(A4,D4.L*8)
065C: 4E75          RTS        


; ======= Function at 0x065E =======
065E: 4E560000      LINK       A6,#0
0662: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
0666: 3E2E0008      MOVE.W     8(A6),D7
066A: 286E000A      MOVEA.L    10(A6),A4
066E: 4A2DF269      TST.B      -3479(A5)
0672: 6712          BEQ.S      $0686
0674: 3F3C0002      MOVE.W     #$0002,-(A7)
0678: AA98          MOVE.L     (A0)+,(A5)
067A: 2F0C          MOVE.L     A4,-(A7)
067C: A8A3          MOVE.L     -(A3),(A4)
067E: 4878001E      PEA        $001E.W
0682: A863          MOVEA.L    -(A3),A4
0684: 6004          BRA.S      $068A
0686: 2F0C          MOVE.L     A4,-(A7)
0688: A8A3          MOVE.L     -(A3),(A4)
068A: 3F07          MOVE.W     D7,-(A7)
068C: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
0690: 204D          MOVEA.L    A5,A0
0692: D0C0          MOVE.B     D0,(A0)+
0694: D0C0          MOVE.B     D0,(A0)+
0696: 3C289412      MOVE.W     -27630(A0),D6
069A: 7000          MOVEQ      #0,D0
069C: 1007          MOVE.B     D7,D0
069E: 204D          MOVEA.L    A5,A0
06A0: D1C04A28      MOVE.B     D0,$4A28.W
06A4: FBD8          MOVE.W     (A0)+,???
06A6: 548F          MOVE.B     A7,(A2)
06A8: 6A06          BPL.S      $06B0
06AA: 2F0C          MOVE.L     A4,-(A7)
06AC: A8A1          MOVE.L     -(A1),(A4)
06AE: 7C00          MOVEQ      #0,D6
06B0: 3F2E0012      MOVE.W     18(A6),-(A7)
06B4: A888          MOVE.L     A0,(A4)
06B6: 3F07          MOVE.W     D7,-(A7)
06B8: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
06BC: 3E00          MOVE.W     D0,D7
06BE: 4257          CLR.W      (A7)
06C0: 3F07          MOVE.W     D7,-(A7)
06C2: A88D          MOVE.L     A5,(A4)
06C4: 302C0002      MOVE.W     2(A4),D0
06C8: D06C0006      MOVEA.B    6(A4),A0
06CC: 905F          MOVEA.B    (A7)+,A0
06CE: 48C0          EXT.L      D0
06D0: 81FC00023F00  ORA.L      #$00023F00,A0
06D6: 302C0004      MOVE.W     4(A4),D0
06DA: D054          MOVEA.B    (A4),A0
06DC: 206E000E      MOVEA.L    14(A6),A0
06E0: 3050          MOVEA.W    (A0),A0
06E2: D0C0          MOVE.B     D0,(A0)+
06E4: 2008          MOVE.L     A0,D0
06E6: 81FC00023F00  ORA.L      #$00023F00,A0
06EC: A893          MOVE.L     (A3),(A4)
06EE: 3F3C0001      MOVE.W     #$0001,-(A7)
06F2: A889          MOVE.L     A1,(A4)
06F4: 3F07          MOVE.W     D7,-(A7)
06F6: A883          MOVE.L     D3,(A4)
06F8: 4A6E0012      TST.W      18(A6)
06FC: 660A          BNE.S      $0708
06FE: 3F06          MOVE.W     D6,-(A7)
0700: 2F0C          MOVE.L     A4,-(A7)
0702: 4EBA0496      JSR        1174(PC)
0706: 5C8F          MOVE.B     A7,(A6)
0708: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
070C: 4E5E          UNLK       A6
070E: 4E75          RTS        


; ======= Function at 0x0710 =======
0710: 4E560000      LINK       A6,#0
0714: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0718: 266E000C      MOVEA.L    12(A6),A3
071C: 7011          MOVEQ      #17,D0
071E: C1EE0008      ANDA.L     8(A6),A0
0722: 2840          MOVEA.L    D0,A4
0724: 41ED97B2      LEA        -26702(A5),A0                  ; A5-26702
0728: D1CCD0EE      MOVE.B     A4,$D0EE.W
072C: 000A1E10      ORI.B      #$1E10,A2
0730: 0C070003      CMPI.B     #$0003,D7
0734: 661E          BNE.S      $0754
0736: 487800CD      PEA        $00CD.W
073A: A862          MOVEA.L    -(A2),A4
073C: 2F0B          MOVE.L     A3,-(A7)
073E: 486DFABA      PEA        -1350(A5)                      ; A5-1350
0742: A8A5          MOVE.L     -(A5),(A4)
0744: 486DEEA6      PEA        -4442(A5)                      ; A5-4442
0748: 2F0B          MOVE.L     A3,-(A7)
074A: 4EBA04F2      JSR        1266(PC)
074E: 508F          MOVE.B     A7,(A0)
0750: 60000090      BRA.W      $07E4
0754: 0C070002      CMPI.B     #$0002,D7
0758: 661C          BNE.S      $0776
075A: 487800CD      PEA        $00CD.W
075E: A862          MOVEA.L    -(A2),A4
0760: 2F0B          MOVE.L     A3,-(A7)
0762: 486DFAB2      PEA        -1358(A5)                      ; A5-1358
0766: A8A5          MOVE.L     -(A5),(A4)
0768: 486DEEAA      PEA        -4438(A5)                      ; A5-4438
076C: 2F0B          MOVE.L     A3,-(A7)
076E: 4EBA04CE      JSR        1230(PC)
0772: 508F          MOVE.B     A7,(A0)
0774: 606C          BRA.S      $07E2
0776: 41ED9592      LEA        -27246(A5),A0                  ; A5-27246
077A: D1CCD0EE      MOVE.B     A4,$D0EE.W
077E: 000A1E10      ORI.B      #$1E10,A2
0782: 0C070003      CMPI.B     #$0003,D7
0786: 661C          BNE.S      $07A4
0788: 48780199      PEA        $0199.W
078C: A862          MOVEA.L    -(A2),A4
078E: 2F0B          MOVE.L     A3,-(A7)
0790: 486DFAA2      PEA        -1374(A5)                      ; A5-1374
0794: A8A5          MOVE.L     -(A5),(A4)
0796: 486DEEAE      PEA        -4434(A5)                      ; A5-4434
079A: 2F0B          MOVE.L     A3,-(A7)
079C: 4EBA04A0      JSR        1184(PC)
07A0: 508F          MOVE.B     A7,(A0)
07A2: 603E          BRA.S      $07E2
07A4: 0C070002      CMPI.B     #$0002,D7
07A8: 661C          BNE.S      $07C6
07AA: 48780199      PEA        $0199.W
07AE: A862          MOVEA.L    -(A2),A4
07B0: 2F0B          MOVE.L     A3,-(A7)
07B2: 486DFAAA      PEA        -1366(A5)                      ; A5-1366
07B6: A8A5          MOVE.L     -(A5),(A4)
07B8: 486DEEB2      PEA        -4430(A5)                      ; A5-4430
07BC: 2F0B          MOVE.L     A3,-(A7)
07BE: 4EBA047E      JSR        1150(PC)
07C2: 508F          MOVE.B     A7,(A0)
07C4: 601C          BRA.S      $07E2
07C6: 4A2DF269      TST.B      -3479(A5)
07CA: 6712          BEQ.S      $07DE
07CC: 3F3C0002      MOVE.W     #$0002,-(A7)
07D0: AA98          MOVE.L     (A0)+,(A5)
07D2: 2F0B          MOVE.L     A3,-(A7)
07D4: A8A3          MOVE.L     -(A3),(A4)
07D6: 4878001E      PEA        $001E.W
07DA: A863          MOVEA.L    -(A3),A4
07DC: 6004          BRA.S      $07E2
07DE: 2F0B          MOVE.L     A3,-(A7)
07E0: A8A3          MOVE.L     -(A3),(A4)
07E2: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
07E6: 4E5E          UNLK       A6
07E8: 4E75          RTS        

07EA: 2F07          MOVE.L     D7,-(A7)
07EC: 206DDE80      MOVEA.L    -8576(A5),A0
07F0: 3028000A      MOVE.W     10(A0),D0
07F4: 0440000C      SUBI.W     #$000C,D0
07F8: 0C400010      CMPI.W     #$0010,D0
07FC: 6220          BHI.S      $081E
07FE: 43FA002A      LEA        42(PC),A1
0802: D040          MOVEA.B    D0,A0
0804: D2F10000      MOVE.B     0(A1,D0.W),(A1)+
0808: 4ED1          JMP        (A1)
080A: 7E18          MOVEQ      #24,D7
080C: 6014          BRA.S      $0822
080E: 7E0E          MOVEQ      #14,D7
0810: 6010          BRA.S      $0822
0812: 7E0D          MOVEQ      #13,D7
0814: 600C          BRA.S      $0822
0816: 7E0C          MOVEQ      #12,D7
0818: 6008          BRA.S      $0822
081A: 7E0A          MOVEQ      #10,D7
081C: 6004          BRA.S      $0822
081E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0822: 3F07          MOVE.W     D7,-(A7)
0824: A88A          MOVE.L     A2,(A4)
0826: 2E1F          MOVE.L     (A7)+,D7
0828: 4E75          RTS        

082A: FFF0FFF4      MOVE.W     -12(A0,A7.L*8),???
082E: FFECFFE8      MOVE.W     -24(A4),???
0832: FFF4FFF4      MOVE.W     -12(A4,A7.L*8),???
0836: FFE4          MOVE.W     -(A4),???
0838: FFF4FFE4      MOVE.W     -28(A4,A7.L*8),???
083C: FFF4FFF4      MOVE.W     -12(A4,A7.L*8),???
0840: FFF4FFF4      MOVE.W     -12(A4,A7.L*8),???
0844: FFF4FFE0      MOVE.W     -32(A4,A7.L*8),???
0848: FFF4FFE0      MOVE.W     -32(A4,A7.L*8),???

; ======= Function at 0x084C =======
084C: 4E56FFF0      LINK       A6,#-16                        ; frame=16
0850: 48E70718      MOVEM.L    D5/D6/D7/A3/A4,-(SP)           ; save
0854: 3E2E0008      MOVE.W     8(A6),D7
0858: 3C2E000A      MOVE.W     10(A6),D6
085C: 4A47          TST.W      D7
085E: 670000BE      BEQ.W      $0920
0862: 4A46          TST.W      D6
0864: 670000B8      BEQ.W      $0920
0868: 3F3C0003      MOVE.W     #$0003,-(A7)
086C: A887          MOVE.L     D7,(A4)
086E: 4EBAFF7A      JSR        -134(PC)
0872: 3F06          MOVE.W     D6,-(A7)
0874: 3F07          MOVE.W     D7,-(A7)
0876: 486EFFF8      PEA        -8(A6)
087A: 4EBAFD74      JSR        -652(PC)
087E: 486EFFF8      PEA        -8(A6)
0882: A8A1          MOVE.L     -(A1),(A4)
0884: 486EFFF8      PEA        -8(A6)
0888: 2F3C00010001  MOVE.L     #$00010001,-(A7)
088E: A8A97011      MOVE.L     28689(A1),(A4)
0892: C1C7          ANDA.L     D7,A0
0894: 49EDD76C      LEA        -10388(A5),A4                  ; g_lookup_tbl
0898: D08C          MOVE.B     A4,(A0)
089A: 3846          MOVEA.W    D6,A4
089C: D08C          MOVE.B     A4,(A0)
089E: 2840          MOVEA.L    D0,A4
08A0: 7011          MOVEQ      #17,D0
08A2: C1C7          ANDA.L     D7,A0
08A4: 2640          MOVEA.L    D0,A3
08A6: 1A14          MOVE.B     (A4),D5
08A8: 4885          EXT.W      D5
08AA: 4A45          TST.W      D5
08AC: 508F          MOVE.B     A7,(A0)
08AE: 6730          BEQ.S      $08E0
08B0: 486EFFF0      PEA        -16(A6)
08B4: A88B          MOVE.L     A3,(A4)
08B6: 41EDD88D      LEA        -10099(A5),A0                  ; A5-10099
08BA: D1CB1014      MOVE.B     A3,$1014.W
08BE: B0306000      MOVE.W     0(A0,D6.W),D0
08C2: 6704          BEQ.S      $08C8
08C4: 7008          MOVEQ      #8,D0
08C6: 6002          BRA.S      $08CA
08C8: 7001          MOVEQ      #1,D0
08CA: 3F00          MOVE.W     D0,-(A7)
08CC: 486EFFF0      PEA        -16(A6)
08D0: 486EFFF8      PEA        -8(A6)
08D4: 3F05          MOVE.W     D5,-(A7)
08D6: 4EBAFD86      JSR        -634(PC)
08DA: 4FEF000C      LEA        12(A7),A7
08DE: 600E          BRA.S      $08EE
08E0: 486EFFF8      PEA        -8(A6)
08E4: 3F06          MOVE.W     D6,-(A7)
08E6: 3F07          MOVE.W     D7,-(A7)
08E8: 4EBAFE26      JSR        -474(PC)
08EC: 508F          MOVE.B     A7,(A0)
08EE: BE6DDE50      MOVEA.W    -8624(A5),A7
08F2: 6610          BNE.S      $0904
08F4: BC6DDE52      MOVEA.W    -8622(A5),A6
08F8: 660A          BNE.S      $0904
08FA: 486EFFF8      PEA        -8(A6)
08FE: 4EBA0026      JSR        38(PC)
0902: 588F          MOVE.B     A7,(A4)
0904: 48780021      PEA        $0021.W
0908: A862          MOVEA.L    -(A2),A4
090A: 486EFFF8      PEA        -8(A6)
090E: 4878FFFF      PEA        $FFFF.W
0912: A8A9486E      MOVE.L     18542(A1),(A4)
0916: FFF8A92A      MOVE.W     $A92A.W,???
091A: 4267          CLR.W      -(A7)
091C: A888          MOVE.L     A0,(A4)
091E: 4CDF18E0      MOVEM.L    (SP)+,D5/D6/D7/A3/A4           ; restore
0922: 4E5E          UNLK       A6
0924: 4E75          RTS        


; ======= Function at 0x0926 =======
0926: 4E56FFF8      LINK       A6,#-8                         ; frame=8
092A: 206E0008      MOVEA.L    8(A6),A0
092E: 2D50FFF8      MOVE.L     (A0),-8(A6)
0932: 2D680004FFFC  MOVE.L     4(A0),-4(A6)
0938: 48780021      PEA        $0021.W
093C: A862          MOVEA.L    -(A2),A4
093E: 4A6DDE4E      TST.W      -8626(A5)
0942: 6744          BEQ.S      $0988
0944: 7003          MOVEQ      #3,D0
0946: D06EFFF8      MOVEA.B    -8(A6),A0
094A: 3D40FFFC      MOVE.W     D0,-4(A6)
094E: 576EFFFE486E  MOVE.B     -2(A6),18542(A3)
0954: FFF8A8A3      MOVE.W     $A8A3.W,???
0958: 526EFFF8      MOVEA.B    -8(A6),A1
095C: 7001          MOVEQ      #1,D0
095E: D06EFFFA      MOVEA.B    -6(A6),A0
0962: 3F00          MOVE.W     D0,-(A7)
0964: 3F2EFFF8      MOVE.W     -8(A6),-(A7)
0968: A893          MOVE.L     (A3),(A4)
096A: 70FE          MOVEQ      #-2,D0
096C: D06EFFFE      MOVEA.B    -2(A6),A0
0970: 3F00          MOVE.W     D0,-(A7)
0972: 3F2EFFF8      MOVE.W     -8(A6),-(A7)
0976: A891          MOVE.L     (A1),(A4)
0978: 4878FFFF      PEA        $FFFF.W
097C: A894          MOVE.L     (A4),(A4)
097E: 2F3C00020000  MOVE.L     #$00020000,-(A7)
0984: A892          MOVE.L     (A2),(A4)
0986: 6040          BRA.S      $09C8
0988: 576EFFFC7003  MOVE.B     -4(A6),28675(A3)
098E: D06EFFFA      MOVEA.B    -6(A6),A0
0992: 3D40FFFE      MOVE.W     D0,-2(A6)
0996: 486EFFF8      PEA        -8(A6)
099A: A8A3          MOVE.L     -(A3),(A4)
099C: 526EFFFA      MOVEA.B    -6(A6),A1
09A0: 3F2EFFFA      MOVE.W     -6(A6),-(A7)
09A4: 7001          MOVEQ      #1,D0
09A6: D06EFFF8      MOVEA.B    -8(A6),A0
09AA: 3F00          MOVE.W     D0,-(A7)
09AC: A893          MOVE.L     (A3),(A4)
09AE: 3F2EFFFA      MOVE.W     -6(A6),-(A7)
09B2: 70FE          MOVEQ      #-2,D0
09B4: D06EFFFC      MOVEA.B    -4(A6),A0
09B8: 3F00          MOVE.W     D0,-(A7)
09BA: A891          MOVE.L     (A1),(A4)
09BC: 4878FFFF      PEA        $FFFF.W
09C0: A894          MOVE.L     (A4),(A4)
09C2: 48780002      PEA        $0002.W
09C6: A892          MOVE.L     (A2),(A4)
09C8: 4E5E          UNLK       A6
09CA: 4E75          RTS        


; ======= Function at 0x09CC =======
09CC: 4E56FFEC      LINK       A6,#-20                        ; frame=20
09D0: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
09D4: 486EFFF8      PEA        -8(A6)
09D8: 4EBAFB5E      JSR        -1186(PC)
09DC: 4217          CLR.B      (A7)
09DE: 486EFFF8      PEA        -8(A6)
09E2: 206DDEC2      MOVEA.L    -8510(A5),A0
09E6: 2F280018      MOVE.L     24(A0),-(A7)
09EA: A8E94A1F      MOVE.L     18975(A1),(A4)+
09EE: 548F          MOVE.B     A7,(A2)
09F0: 6700019E      BEQ.W      $0B92
09F4: 3F3C0003      MOVE.W     #$0003,-(A7)
09F8: A887          MOVE.L     D7,(A4)
09FA: 4EBAFDEE      JSR        -530(PC)
09FE: 486EFFEC      PEA        -20(A6)
0A02: A88B          MOVE.L     A3,(A4)
0A04: 7C01          MOVEQ      #1,D6
0A06: 49EDD89E      LEA        -10082(A5),A4                  ; A5-10082
0A0A: 47EDD77D      LEA        -10371(A5),A3                  ; A5-10371
0A0E: 600000F2      BRA.W      $0B04
0A12: 48780021      PEA        $0021.W
0A16: A862          MOVEA.L    -(A2),A4
0A18: 7AFF          MOVEQ      #-1,D5
0A1A: DA46          MOVEA.B    D6,A5
0A1C: 206DDE80      MOVEA.L    -8576(A5),A0
0A20: 70FF          MOVEQ      #-1,D0
0A22: D068000E      MOVEA.B    14(A0),A0
0A26: 3F00          MOVE.W     D0,-(A7)
0A28: 3028000A      MOVE.W     10(A0),D0
0A2C: C1C5          ANDA.L     D5,A0
0A2E: D0680010      MOVEA.B    16(A0),A0
0A32: 53403F00      MOVE.B     D0,16128(A1)
0A36: A893          MOVE.L     (A3),(A4)
0A38: 206DDE80      MOVEA.L    -8576(A5),A0
0A3C: 700F          MOVEQ      #15,D0
0A3E: C1E8000A      ANDA.L     10(A0),A0
0A42: 3F00          MOVE.W     D0,-(A7)
0A44: 4267          CLR.W      -(A7)
0A46: A892          MOVE.L     (A2),(A4)
0A48: 206DDE80      MOVEA.L    -8576(A5),A0
0A4C: 3028000A      MOVE.W     10(A0),D0
0A50: C1C5          ANDA.L     D5,A0
0A52: D068000E      MOVEA.B    14(A0),A0
0A56: 53403F00      MOVE.B     D0,16128(A1)
0A5A: 3F280010      MOVE.W     16(A0),-(A7)
0A5E: A893          MOVE.L     (A3),(A4)
0A60: 4267          CLR.W      -(A7)
0A62: 206DDE80      MOVEA.L    -8576(A5),A0
0A66: 700F          MOVEQ      #15,D0
0A68: C1E8000A      ANDA.L     10(A0),A0
0A6C: 53403F00      MOVE.B     D0,16128(A1)
0A70: A892          MOVE.L     (A2),(A4)
0A72: 3F3C0001      MOVE.W     #$0001,-(A7)
0A76: 3F06          MOVE.W     D6,-(A7)
0A78: 486EFFF8      PEA        -8(A6)
0A7C: 4EBAFB72      JSR        -1166(PC)
0A80: 486EFFF8      PEA        -8(A6)
0A84: 2F3C00010001  MOVE.L     #$00010001,-(A7)
0A8A: A8A97A01      MOVE.L     31233(A1),(A4)
0A8E: 244B          MOVEA.L    A3,A2
0A90: 2E0C          MOVE.L     A4,D7
0A92: 508F          MOVE.B     A7,(A0)
0A94: 605C          BRA.S      $0AF2
0A96: 48780021      PEA        $0021.W
0A9A: A862          MOVEA.L    -(A2),A4
0A9C: 18325000      MOVE.B     0(A2,D5.W),D4
0AA0: 4884          EXT.W      D4
0AA2: 4A44          TST.W      D4
0AA4: 6728          BEQ.S      $0ACE
0AA6: 3045          MOVEA.W    D5,A0
0AA8: 10325000      MOVE.B     0(A2,D5.W),D0
0AAC: B0307800      MOVE.W     0(A0,D7.L),D0
0AB0: 6704          BEQ.S      $0AB6
0AB2: 7008          MOVEQ      #8,D0
0AB4: 6002          BRA.S      $0AB8
0AB6: 7001          MOVEQ      #1,D0
0AB8: 3F00          MOVE.W     D0,-(A7)
0ABA: 486EFFEC      PEA        -20(A6)
0ABE: 486EFFF8      PEA        -8(A6)
0AC2: 3F04          MOVE.W     D4,-(A7)
0AC4: 4EBAFB98      JSR        -1128(PC)
0AC8: 4FEF000C      LEA        12(A7),A7
0ACC: 600E          BRA.S      $0ADC
0ACE: 486EFFF8      PEA        -8(A6)
0AD2: 3F05          MOVE.W     D5,-(A7)
0AD4: 3F06          MOVE.W     D6,-(A7)
0AD6: 4EBAFC38      JSR        -968(PC)
0ADA: 508F          MOVE.B     A7,(A0)
0ADC: 5245          MOVEA.B    D5,A1
0ADE: 206DDE80      MOVEA.L    -8576(A5),A0
0AE2: 3028000A      MOVE.W     10(A0),D0
0AE6: D16EFFFA3028  MOVE.B     -6(A6),12328(A0)
0AEC: 000AD16E      ORI.B      #$D16E,A2
0AF0: FFFE          MOVE.W     ???,???
0AF2: 0C450010      CMPI.W     #$0010,D5
0AF6: 6D9E          BLT.S      $0A96
0AF8: 5246          MOVEA.B    D6,A1
0AFA: 49EC0011      LEA        17(A4),A4
0AFE: 47EB0011      LEA        17(A3),A3
0B02: 0C460010      CMPI.W     #$0010,D6
0B06: 6D00FF0A      BLT.W      $0A14
0B0A: 48780021      PEA        $0021.W
0B0E: A862          MOVEA.L    -(A2),A4
0B10: 7AFF          MOVEQ      #-1,D5
0B12: DA46          MOVEA.B    D6,A5
0B14: 206DDE80      MOVEA.L    -8576(A5),A0
0B18: 3F28000E      MOVE.W     14(A0),-(A7)
0B1C: 3028000A      MOVE.W     10(A0),D0
0B20: C1C5          ANDA.L     D5,A0
0B22: D0680010      MOVEA.B    16(A0),A0
0B26: 53403F00      MOVE.B     D0,16128(A1)
0B2A: A893          MOVE.L     (A3),(A4)
0B2C: 206DDE80      MOVEA.L    -8576(A5),A0
0B30: 700F          MOVEQ      #15,D0
0B32: C1E8000A      ANDA.L     10(A0),A0
0B36: 53403F00      MOVE.B     D0,16128(A1)
0B3A: 4267          CLR.W      -(A7)
0B3C: A892          MOVE.L     (A2),(A4)
0B3E: 206DDE80      MOVEA.L    -8576(A5),A0
0B42: 3028000A      MOVE.W     10(A0),D0
0B46: C1C5          ANDA.L     D5,A0
0B48: D068000E      MOVEA.B    14(A0),A0
0B4C: 53403F00      MOVE.B     D0,16128(A1)
0B50: 3F280010      MOVE.W     16(A0),-(A7)
0B54: A893          MOVE.L     (A3),(A4)
0B56: 4267          CLR.W      -(A7)
0B58: 206DDE80      MOVEA.L    -8576(A5),A0
0B5C: 700F          MOVEQ      #15,D0
0B5E: C1E8000A      ANDA.L     10(A0),A0
0B62: 53403F00      MOVE.B     D0,16128(A1)
0B66: A892          MOVE.L     (A2),(A4)
0B68: 3F2DDE52      MOVE.W     -8622(A5),-(A7)                ; A5-8622
0B6C: 3F2DDE50      MOVE.W     -8624(A5),-(A7)                ; A5-8624
0B70: 486EFFF8      PEA        -8(A6)
0B74: 4EBAFA7A      JSR        -1414(PC)
0B78: 486EFFF8      PEA        -8(A6)
0B7C: 2F3C00010001  MOVE.L     #$00010001,-(A7)
0B82: A8A9486E      MOVE.L     18542(A1),(A4)
0B86: FFF84EBA      MOVE.W     $4EBA.W,???
0B8A: FD9C4257      MOVE.W     (A4)+,87(A6,D4.W*2)
0B8E: A888          MOVE.L     A0,(A4)
0B90: 4CEE1CF0FFD0  MOVEM.L    -48(A6),D4/D5/D6/D7/A2/A3/A4
0B96: 4E5E          UNLK       A6
0B98: 4E75          RTS        


; ======= Function at 0x0B9A =======
0B9A: 4E560000      LINK       A6,#0
0B9E: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0BA2: 286E0008      MOVEA.L    8(A6),A4
0BA6: 3E2E000C      MOVE.W     12(A6),D7
0BAA: 206DDE78      MOVEA.L    -8584(A5),A0
0BAE: 2050          MOVEA.L    (A0),A0
0BB0: 4A680308      TST.W      776(A0)
0BB4: 67000080      BEQ.W      $0C38
0BB8: 4A47          TST.W      D7
0BBA: 677A          BEQ.S      $0C36
0BBC: 3F3C000C      MOVE.W     #$000C,-(A7)
0BC0: A88A          MOVE.L     A2,(A4)
0BC2: 3F2DDEC0      MOVE.W     -8512(A5),-(A7)                ; A5-8512
0BC6: A887          MOVE.L     D7,(A4)
0BC8: 0C4703E8      CMPI.W     #$03E8,D7
0BCC: 673C          BEQ.S      $0C0A
0BCE: 4267          CLR.W      -(A7)
0BD0: 7030          MOVEQ      #48,D0
0BD2: D047          MOVEA.B    D7,A0
0BD4: 3F00          MOVE.W     D0,-(A7)
0BD6: A88D          MOVE.L     A5,(A4)
0BD8: 302C0006      MOVE.W     6(A4),D0
0BDC: 905F          MOVEA.B    (A7)+,A0
0BDE: 53403F00      MOVE.B     D0,16128(A1)
0BE2: 70FF          MOVEQ      #-1,D0
0BE4: D06C0004      MOVEA.B    4(A4),A0
0BE8: 3F00          MOVE.W     D0,-(A7)
0BEA: A893          MOVE.L     (A3),(A4)
0BEC: 0C470064      CMPI.W     #$0064,D7
0BF0: 6606          BNE.S      $0BF8
0BF2: 48780001      PEA        $0001.W
0BF6: A894          MOVE.L     (A4),(A4)
0BF8: 2007          MOVE.L     D7,D0
0BFA: 48C0          EXT.L      D0
0BFC: 81FC00640640  ORA.L      #$00640640,A0
0C02: 00303F00A883  ORI.B      #$3F00,-125(A0,A2.L)
0C08: 6022          BRA.S      $0C2C
0C0A: 4267          CLR.W      -(A7)
0C0C: 486DEEB6      PEA        -4426(A5)                      ; A5-4426
0C10: A88C          MOVE.L     A4,(A4)
0C12: 302C0006      MOVE.W     6(A4),D0
0C16: 905F          MOVEA.B    (A7)+,A0
0C18: 53403F00      MOVE.B     D0,16128(A1)
0C1C: 70FF          MOVEQ      #-1,D0
0C1E: D06C0004      MOVEA.B    4(A4),A0
0C22: 3F00          MOVE.W     D0,-(A7)
0C24: A893          MOVE.L     (A3),(A4)
0C26: 486DEEBA      PEA        -4422(A5)                      ; A5-4422
0C2A: A884          MOVE.L     D4,(A4)
0C2C: 4EBAFBBC      JSR        -1092(PC)
0C30: 3F3C0003      MOVE.W     #$0003,-(A7)
0C34: A887          MOVE.L     D7,(A4)
0C36: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
0C3A: 4E5E          UNLK       A6
0C3C: 4E75          RTS        


; ======= Function at 0x0C3E =======
0C3E: 4E56FFF8      LINK       A6,#-8                         ; frame=8
0C42: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
0C46: 286E0008      MOVEA.L    8(A6),A4
0C4A: 266E000C      MOVEA.L    12(A6),A3
0C4E: 206DDE78      MOVEA.L    -8584(A5),A0
0C52: 2050          MOVEA.L    (A0),A0
0C54: 4A680306      TST.W      774(A0)
0C58: 67000094      BEQ.W      $0CF0
0C5C: 48780021      PEA        $0021.W
0C60: A862          MOVEA.L    -(A2),A4
0C62: 3F3C000C      MOVE.W     #$000C,-(A7)
0C66: A88A          MOVE.L     A2,(A4)
0C68: 3F2DDEC0      MOVE.W     -8512(A5),-(A7)                ; A5-8512
0C6C: A887          MOVE.L     D7,(A4)
0C6E: 4267          CLR.W      -(A7)
0C70: A888          MOVE.L     A0,(A4)
0C72: 3014          MOVE.W     (A4),D0
0C74: D06C0004      MOVEA.B    4(A4),A0
0C78: 48C0          EXT.L      D0
0C7A: 81FC00025940  ORA.L      #$00025940,A0
0C80: 3D40FFF8      MOVE.W     D0,-8(A6)
0C84: 7007          MOVEQ      #7,D0
0C86: D06EFFF8      MOVEA.B    -8(A6),A0
0C8A: 3D40FFFC      MOVE.W     D0,-4(A6)
0C8E: 4267          CLR.W      -(A7)
0C90: 2F0B          MOVE.L     A3,-(A7)
0C92: A88C          MOVE.L     A4,(A4)
0C94: 302C0002      MOVE.W     2(A4),D0
0C98: D06C0006      MOVEA.B    6(A4),A0
0C9C: 905F          MOVEA.B    (A7)+,A0
0C9E: 48C0          EXT.L      D0
0CA0: 81FC00023D40  ORA.L      #$00023D40,A0
0CA6: FFFA4267      MOVE.W     16999(PC),???
0CAA: 2F0B          MOVE.L     A3,-(A7)
0CAC: A88C          MOVE.L     A4,(A4)
0CAE: 302EFFFA      MOVE.W     -6(A6),D0
0CB2: D05F          MOVEA.B    (A7)+,A0
0CB4: 3D40FFFE      MOVE.W     D0,-2(A6)
0CB8: 486DEEBE      PEA        -4418(A5)                      ; A5-4418
0CBC: 2F0B          MOVE.L     A3,-(A7)
0CBE: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
0CC2: 4A40          TST.W      D0
0CC4: 508F          MOVE.B     A7,(A0)
0CC6: 6704          BEQ.S      $0CCC
0CC8: 526EFFFE      MOVEA.B    -2(A6),A1
0CCC: 486EFFF8      PEA        -8(A6)
0CD0: A8A3          MOVE.L     -(A3),(A4)
0CD2: 3F2EFFFA      MOVE.W     -6(A6),-(A7)
0CD6: 70FF          MOVEQ      #-1,D0
0CD8: D06EFFFC      MOVEA.B    -4(A6),A0
0CDC: 3F00          MOVE.W     D0,-(A7)
0CDE: A893          MOVE.L     (A3),(A4)
0CE0: 2F0B          MOVE.L     A3,-(A7)
0CE2: A884          MOVE.L     D4,(A4)
0CE4: 4EBAFB04      JSR        -1276(PC)
0CE8: 3F3C0003      MOVE.W     #$0003,-(A7)
0CEC: A887          MOVE.L     D7,(A4)
0CEE: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
0CF2: 4E5E          UNLK       A6
0CF4: 4E75          RTS        


; ======= Function at 0x0CF6 =======
0CF6: 4E56FFF8      LINK       A6,#-8                         ; frame=8
0CFA: 2F07          MOVE.L     D7,-(A7)
0CFC: 206DDE80      MOVEA.L    -8576(A5),A0
0D00: 2D680046FFF8  MOVE.L     70(A0),-8(A6)
0D06: 2D68004AFFFC  MOVE.L     74(A0),-4(A6)
0D0C: 226DDE78      MOVEA.L    -8584(A5),A1
0D10: 2251          MOVEA.L    (A1),A1
0D12: 3E29030A      MOVE.W     778(A1),D7
0D16: BE6DEEA4      MOVEA.W    -4444(A5),A7
0D1A: 6706          BEQ.S      $0D22
0D1C: 3B47EEA4      MOVE.W     D7,-4444(A5)
0D20: 6012          BRA.S      $0D34
0D22: 4A6DEEA4      TST.W      -4444(A5)
0D26: 6718          BEQ.S      $0D40
0D28: 486EFFF8      PEA        -8(A6)
0D2C: 2F3C00010001  MOVE.L     #$00010001,-(A7)
0D32: A8A92F2D      MOVE.L     12077(A1),(A4)
0D36: DEC2          MOVE.B     D2,(A7)+
0D38: A873486E      MOVEA.L    110(A3,D4.L),A4
0D3C: FFF8A928      MOVE.W     $A928.W,???
0D40: 2E1F          MOVE.L     (A7)+,D7
0D42: 4E5E          UNLK       A6
0D44: 4E75          RTS        
