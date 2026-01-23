;======================================================================
; CODE 42 Disassembly
; File: /tmp/maven_code_42.bin
; Header: JT offset=2672, JT entries=2
; Code size: 734 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
0008: 426DF97C      CLR.W      -1668(A5)
000C: 426DF97E      CLR.W      -1666(A5)
0010: 49EDF960      LEA        -1696(A5),A4                   ; A5-1696
0014: 266D99D2      MOVEA.L    -26158(A5),A3
0018: 6044          BRA.S      $005E
001A: 206E0008      MOVEA.L    8(A6),A0
001E: 4A307000      TST.B      0(A0,D7.W)
0022: 6738          BEQ.S      $005C
0024: 206E000C      MOVEA.L    12(A6),A0
0028: 52AE000C      MOVE.B     12(A6),(A1)
002C: 1087          MOVE.B     D7,(A0)
002E: 206E0008      MOVEA.L    8(A6),A0
0032: 1C307000      MOVE.B     0(A0,D7.W),D6
0036: 1006          MOVE.B     D6,D0
0038: 4880          EXT.W      D0
003A: D16DF97E0C06  MOVE.B     -1666(A5),3078(A0)             ; A5-1666
0040: 00016616      ORI.B      #$6616,D1
0044: 2007          MOVE.L     D7,D0
0046: 48C0          EXT.L      D0
0048: E988204D      MOVE.L     A0,77(A4,D2.W)
004C: D1C03028      MOVE.B     D0,$3028.W
0050: B3F44640816DF97C  MOVE.W     64(A4,D4.W*8),$816DF97C
0058: 6002          BRA.S      $005C
005A: 18C7          MOVE.B     D7,(A4)+
005C: 528B          MOVE.B     A3,(A1)
005E: 1E13          MOVE.B     (A3),D7
0060: 4887          EXT.W      D7
0062: 4A47          TST.W      D7
0064: 66B4          BNE.S      $001A
0066: 206E000C      MOVEA.L    12(A6),A0
006A: 4210          CLR.B      (A0)
006C: 4214          CLR.B      (A4)
006E: 302DF97E      MOVE.W     -1666(A5),D0                   ; A5-1666
0072: 43EDBC04      LEA        -17404(A5),A1                  ; A5-17404
0076: 41EDBBA4      LEA        -17500(A5),A0                  ; A5-17500
007A: D0C0          MOVE.B     D0,(A0)+
007C: D0C0          MOVE.B     D0,(A0)+
007E: B3C862044EAD  MOVE.W     A0,$62044EAD
0084: 01A2          BCLR       D0,-(A2)
0086: 7E00          MOVEQ      #0,D7
0088: 49EDBBA4      LEA        -17500(A5),A4                  ; A5-17500
008C: 6008          BRA.S      $0096
008E: 38BCFFFF      MOVE.W     #$FFFF,(A4)
0092: 5247          MOVEA.B    D7,A1
0094: 548C          MOVE.B     A4,(A2)
0096: BE6DF97E      MOVEA.W    -1666(A5),A7
009A: 6DF2          BLT.S      $008E
009C: 4CDF18C0      MOVEM.L    (SP)+,D6/D7/A3/A4              ; restore
00A0: 4E5E          UNLK       A6
00A2: 4E75          RTS        


; ======= Function at 0x00A4 =======
00A4: 4E56FF60      LINK       A6,#-160                       ; frame=160
00A8: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
00AC: 2E2E0008      MOVE.L     8(A6),D7
00B0: 382E000C      MOVE.W     12(A6),D4
00B4: 7C07          MOVEQ      #7,D6
00B6: 3A2DF97C      MOVE.W     -1668(A5),D5                   ; A5-1668
00BA: CA44          AND.W      D4,D5
00BC: 600A          BRA.S      $00C8
00BE: 534670FF      MOVE.B     D6,28927(A1)
00C2: D045          MOVEA.B    D5,A0
00C4: C045          AND.W      D5,D0
00C6: 3A00          MOVE.W     D0,D5
00C8: 4A45          TST.W      D5
00CA: 66F2          BNE.S      $00BE
00CC: 4A46          TST.W      D6
00CE: 6C04          BGE.S      $00D4
00D0: 4EAD01A2      JSR        418(A5)                        ; JT[418]
00D4: 302DF97C      MOVE.W     -1668(A5),D0                   ; A5-1668
00D8: 4640          NOT.W      D0
00DA: C840          AND.W      D0,D4
00DC: 3A2DF97E      MOVE.W     -1666(A5),D5                   ; A5-1666
00E0: DA46          MOVEA.B    D6,A5
00E2: 5F454A44      MOVE.B     D5,19012(A7)
00E6: 6616          BNE.S      $00FE
00E8: 2005          MOVE.L     D5,D0
00EA: 48C0          EXT.L      D0
00EC: E98841ED      MOVE.L     A0,-19(A4,D4.W)
00F0: 9A58          MOVEA.B    (A0)+,A5
00F2: D088          MOVE.B     A0,(A0)
00F4: 3046          MOVEA.W    D6,A0
00F6: D1C83030      MOVE.B     A0,$3030.W
00FA: 0800605A      BTST       #24666,D0
00FE: 707B          MOVEQ      #123,D0
0100: D087          MOVE.B     D7,(A0)
0102: 2840          MOVEA.L    D0,A4
0104: 1885          MOVE.B     D5,(A4)
0106: 45EEFF60      LEA        -160(A6),A2
010A: 47EDF960      LEA        -1696(A5),A3                   ; A5-1696
010E: 6020          BRA.S      $0130
0110: 2005          MOVE.L     D5,D0
0112: 48C0          EXT.L      D0
0114: E988204D      MOVE.L     A0,77(A4,D2.W)
0118: D1C03028      MOVE.B     D0,$3028.W
011C: B3F44640C044670A  MOVE.W     64(A4,D4.W*8),$C044670A
0124: 14C5          MOVE.B     D5,(A2)+
0126: 3045          MOVEA.W    D5,A0
0128: 10307800      MOVE.B     0(A0,D7.L),D0
012C: 9114          MOVE.B     (A4),-(A0)
012E: 528B          MOVE.B     A3,(A1)
0130: 1A13          MOVE.B     (A3),D5
0132: 4885          EXT.W      D5
0134: 4A45          TST.W      D5
0136: 66D8          BNE.S      $0110
0138: 14FC007B      MOVE.B     #$7B,(A2)+
013C: 4212          CLR.B      (A2)
013E: 3F06          MOVE.W     D6,-(A7)
0140: 4267          CLR.W      -(A7)
0142: 486EFF60      PEA        -160(A6)
0146: 486EFF80      PEA        -128(A6)
014A: 3F04          MOVE.W     D4,-(A7)
014C: 2F07          MOVE.L     D7,-(A7)
014E: 4EBA0012      JSR        18(PC)
0152: 3A00          MOVE.W     D0,D5
0154: 4214          CLR.B      (A4)
0156: 3005          MOVE.W     D5,D0
0158: 4CEE1CF0FF44  MOVEM.L    -188(A6),D4/D5/D6/D7/A2/A3/A4
015E: 4E5E          UNLK       A6
0160: 4E75          RTS        


; ======= Function at 0x0162 =======
0162: 4E56FFFE      LINK       A6,#-2                         ; frame=2
0166: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
016A: 246E0008      MOVEA.L    8(A6),A2
016E: 3C2E000C      MOVE.W     12(A6),D6
0172: 286E000E      MOVEA.L    14(A6),A4
0176: 266E0012      MOVEA.L    18(A6),A3
017A: 3E2E0016      MOVE.W     22(A6),D7
017E: BE6E0018      MOVEA.W    24(A6),A7
0182: 6F06          BLE.S      $018A
0184: 7000          MOVEQ      #0,D0
0186: 6000014E      BRA.W      $02D8
018A: BE6E0018      MOVEA.W    24(A6),A7
018E: 6650          BNE.S      $01E0
0190: 4A46          TST.W      D6
0192: 6706          BEQ.S      $019A
0194: 7000          MOVEQ      #0,D0
0196: 6000013E      BRA.W      $02D8
019A: 4214          CLR.B      (A4)
019C: 3047          MOVEA.W    D7,A0
019E: 99C87801      MOVE.B     A0,#$01
01A2: 264C          MOVEA.L    A4,A3
01A4: 49EBFFFF      LEA        -1(A3),A4
01A8: 1613          MOVE.B     (A3),D3
01AA: 4A03          TST.B      D3
01AC: 672C          BEQ.S      $01DA
01AE: B62B0001      MOVE.W     1(A3),D3
01B2: 6722          BEQ.S      $01D6
01B4: 1003          MOVE.B     D3,D0
01B6: 4880          EXT.W      D0
01B8: 10320000      MOVE.B     0(A2,D0.W),D0
01BC: 4880          EXT.W      D0
01BE: 48C0          EXT.L      D0
01C0: E988220B      MOVE.L     A0,11(A4,D2.W*2)
01C4: 928C          MOVE.B     A4,(A1)
01C6: 41ED9A58      LEA        -26024(A5),A0                  ; A5-26024
01CA: D088          MOVE.B     A0,(A0)
01CC: D281          MOVE.B     D1,(A1)
01CE: D081          MOVE.B     D1,(A0)
01D0: 2040          MOVEA.L    D0,A0
01D2: C9D0          ANDA.L     (A0),A4
01D4: 284B          MOVEA.L    A3,A4
01D6: 528B          MOVE.B     A3,(A1)
01D8: 60CE          BRA.S      $01A8
01DA: 3004          MOVE.W     D4,D0
01DC: 600000F8      BRA.W      $02D8
01E0: 4A13          TST.B      (A3)
01E2: 6606          BNE.S      $01EA
01E4: 7000          MOVEQ      #0,D0
01E6: 600000EE      BRA.W      $02D8
01EA: 4A46          TST.W      D6
01EC: 66000080      BNE.W      $0270
01F0: 7A00          MOVEQ      #0,D5
01F2: 1613          MOVE.B     (A3),D3
01F4: 4A03          TST.B      D3
01F6: 6710          BEQ.S      $0208
01F8: 1003          MOVE.B     D3,D0
01FA: 4880          EXT.W      D0
01FC: 10320000      MOVE.B     0(A2,D0.W),D0
0200: 4880          EXT.W      D0
0202: DA40          MOVEA.B    D0,A5
0204: 528B          MOVE.B     A3,(A1)
0206: 60EA          BRA.S      $01F2
0208: 3C2E0018      MOVE.W     24(A6),D6
020C: 9C47          MOVEA.B    D7,A6
020E: BC45          MOVEA.W    D5,A6
0210: 6F06          BLE.S      $0218
0212: 7000          MOVEQ      #0,D0
0214: 600000C0      BRA.W      $02D8
0218: 4214          CLR.B      (A4)
021A: 3047          MOVEA.W    D7,A0
021C: 99C82005      MOVE.B     A0,#$05
0220: 48C0          EXT.L      D0
0222: E98841ED      MOVE.L     A0,-19(A4,D4.W)
0226: 9A58          MOVEA.B    (A0)+,A5
0228: D088          MOVE.B     A0,(A0)
022A: 3046          MOVEA.W    D6,A0
022C: D1C83830      MOVE.B     A0,$3830.W
0230: 0800264C      BTST       #9804,D0
0234: 49EBFFFF      LEA        -1(A3),A4
0238: 1613          MOVE.B     (A3),D3
023A: 4A03          TST.B      D3
023C: 672C          BEQ.S      $026A
023E: B62B0001      MOVE.W     1(A3),D3
0242: 6722          BEQ.S      $0266
0244: 1003          MOVE.B     D3,D0
0246: 4880          EXT.W      D0
0248: 10320000      MOVE.B     0(A2,D0.W),D0
024C: 4880          EXT.W      D0
024E: 48C0          EXT.L      D0
0250: E988220B      MOVE.L     A0,11(A4,D2.W*2)
0254: 928C          MOVE.B     A4,(A1)
0256: 41ED9A58      LEA        -26024(A5),A0                  ; A5-26024
025A: D088          MOVE.B     A0,(A0)
025C: D281          MOVE.B     D1,(A1)
025E: D081          MOVE.B     D1,(A0)
0260: 2040          MOVEA.L    D0,A0
0262: C9D0          ANDA.L     (A0),A4
0264: 284B          MOVEA.L    A3,A4
0266: 528B          MOVE.B     A3,(A1)
0268: 60CE          BRA.S      $0238
026A: 3004          MOVE.W     D4,D0
026C: 6068          BRA.S      $02D6
026E: 1013          MOVE.B     (A3),D0
0270: 4880          EXT.W      D0
0272: 48C0          EXT.L      D0
0274: E988204D      MOVE.L     A0,77(A4,D2.W)
0278: D1C03028      MOVE.B     D0,$3028.W
027C: B3F446405340C046  MOVE.W     64(A4,D4.W*8),$5340C046
0284: 6704          BEQ.S      $028A
0286: 7000          MOVEQ      #0,D0
0288: 604C          BRA.S      $02D6
028A: 7A00          MOVEQ      #0,D5
028C: 7800          MOVEQ      #0,D4
028E: 3F2E0018      MOVE.W     24(A6),-(A7)
0292: 3F07          MOVE.W     D7,-(A7)
0294: 486B0001      PEA        1(A3)
0298: 2F0C          MOVE.L     A4,-(A7)
029A: 3F06          MOVE.W     D6,-(A7)
029C: 2F0A          MOVE.L     A2,-(A7)
029E: 4EBAFEC2      JSR        -318(PC)
02A2: D840          MOVEA.B    D0,A4
02A4: 1013          MOVE.B     (A3),D0
02A6: 4880          EXT.W      D0
02A8: 48C0          EXT.L      D0
02AA: E98841ED      MOVE.L     A0,-19(A4,D4.W)
02AE: B3F4D0883045D1C8  MOVE.W     -120(A4,A5.W),$3045D1C8
02B6: CC700800      AND.W      0(A0,D0.L),D6
02BA: 18D3          MOVE.B     (A3),(A4)+
02BC: 5247          MOVEA.B    D7,A1
02BE: 4FEF0012      LEA        18(A7),A7
02C2: 3005          MOVE.W     D5,D0
02C4: 5245          MOVEA.B    D5,A1
02C6: 1213          MOVE.B     (A3),D1
02C8: 4881          EXT.W      D1
02CA: 12321000      MOVE.B     0(A2,D1.W),D1
02CE: 4881          EXT.W      D1
02D0: B240          MOVEA.W    D0,A1
02D2: 6EBA          BGT.S      $028E
02D4: 3004          MOVE.W     D4,D0
02D6: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
02DA: 4E5E          UNLK       A6
02DC: 4E75          RTS        
