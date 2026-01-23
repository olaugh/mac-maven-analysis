;======================================================================
; CODE 27 Disassembly
; File: /tmp/maven_code_27.bin
; Header: JT offset=2048, JT entries=4
; Code size: 662 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 2F0C          MOVE.L     A4,-(A7)
0006: 286DF51E      MOVEA.L    -2786(A5),A4
000A: 600C          BRA.S      $0018
000C: 2F0C          MOVE.L     A4,-(A7)
000E: 206E0008      MOVEA.L    8(A6),A0
0012: 4E90          JSR        (A0)
0014: 588F          MOVE.B     A7,(A4)
0016: 2854          MOVEA.L    (A4),A4
0018: 200C          MOVE.L     A4,D0
001A: 66F0          BNE.S      $000C
001C: 285F          MOVEA.L    (A7)+,A4
001E: 4E5E          UNLK       A6
0020: 4E75          RTS        


; ======= Function at 0x0022 =======
0022: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0026: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
002A: 246E0008      MOVEA.L    8(A6),A2
002E: 206E0014      MOVEA.L    20(A6),A0
0032: 4250          CLR.W      (A0)
0034: 7E00          MOVEQ      #0,D7
0036: 4EAD0AB2      JSR        2738(A5)                       ; JT[2738]
003A: 2A3C0BEBC200  MOVE.L     #$0BEBC200,D5
0040: 2C05          MOVE.L     D5,D6
0042: 49EDF51E      LEA        -2786(A5),A4                   ; A5-2786
0046: 600000A0      BRA.W      $00EA
004A: 2F0A          MOVE.L     A2,-(A7)
004C: 2F0B          MOVE.L     A3,-(A7)
004E: 4EAD0AA2      JSR        2722(A5)                       ; JT[2722]
0052: 4A80          TST.L      D0
0054: 508F          MOVE.B     A7,(A0)
0056: 6600008E      BNE.W      $00E8
005A: 4A2B0008      TST.B      8(A3)
005E: 6726          BEQ.S      $0086
0060: 204D          MOVEA.L    A5,A0
0062: 302A001E      MOVE.W     30(A2),D0
0066: D0C0          MOVE.B     D0,(A0)+
0068: D0C0          MOVE.B     D0,(A0)+
006A: 3068CBFA      MOVEA.W    -13318(A0),A0
006E: D1C8262A      MOVE.B     A0,$262A.W
0072: 001096AB      ORI.B      #$96AB,(A0)
0076: 00049688      ORI.B      #$9688,D4
007A: 2803          MOVE.L     D3,D4
007C: 206E0014      MOVEA.L    20(A6),A0
0080: 30BC0001      MOVE.W     #$0001,(A0)
0084: 6036          BRA.S      $00BC
0086: 486EFFFC      PEA        -4(A6)
008A: 486EFFFE      PEA        -2(A6)
008E: 102B0009      MOVE.B     9(A3),D0
0092: 4880          EXT.W      D0
0094: 3F00          MOVE.W     D0,-(A7)
0096: 3F2A001E      MOVE.W     30(A2),-(A7)
009A: 4EAD0A6A      JSR        2666(A5)                       ; JT[2666]
009E: 262A0010      MOVE.L     16(A2),D3
00A2: 96AB0004      MOVE.B     4(A3),(A3)
00A6: 3040          MOVEA.W    D0,A0
00A8: D688          MOVE.B     A0,(A3)
00AA: 2803          MOVE.L     D3,D4
00AC: 306EFFFE      MOVEA.W    -2(A6),A0
00B0: D888          MOVE.B     A0,(A4)
00B2: 306EFFFC      MOVEA.W    -4(A6),A0
00B6: 9688          MOVE.B     A0,(A3)
00B8: 4FEF000C      LEA        12(A7),A7
00BC: BC84          MOVE.W     D4,(A6)
00BE: 6F02          BLE.S      $00C2
00C0: 2C04          MOVE.L     D4,D6
00C2: BA83          MOVE.W     D3,(A5)
00C4: 6F02          BLE.S      $00C8
00C6: 2A03          MOVE.L     D3,D5
00C8: 206E000C      MOVEA.L    12(A6),A0
00CC: BC90          MOVE.W     (A0),(A6)
00CE: 6C16          BGE.S      $00E6
00D0: 206E0010      MOVEA.L    16(A6),A0
00D4: BA90          MOVE.W     (A0),(A5)
00D6: 6C0E          BGE.S      $00E6
00D8: 2893          MOVE.L     (A3),(A4)
00DA: 26ADF51E      MOVE.L     -2786(A5),(A3)                 ; A5-2786
00DE: 2B4BF51E      MOVE.L     A3,-2786(A5)
00E2: 7E01          MOVEQ      #1,D7
00E4: 600A          BRA.S      $00F0
00E6: 284B          MOVEA.L    A3,A4
00E8: 2654          MOVEA.L    (A4),A3
00EA: 200B          MOVE.L     A3,D0
00EC: 6600FF5C      BNE.W      $004C
00F0: 0C860BEBC200  CMPI.L     #$0BEBC200,D6
00F6: 6632          BNE.S      $012A
00F8: 486EFFFC      PEA        -4(A6)
00FC: 486EFFFE      PEA        -2(A6)
0100: 3F2A001E      MOVE.W     30(A2),-(A7)
0104: 4EAD0A62      JSR        2658(A5)                       ; JT[2658]
0108: 48C0          EXT.L      D0
010A: D0AA0010      MOVE.B     16(A2),(A0)
010E: 2A00          MOVE.L     D0,D5
0110: 2C00          MOVE.L     D0,D6
0112: 306EFFFE      MOVEA.W    -2(A6),A0
0116: DC88          MOVE.B     A0,(A6)
0118: 306EFFFC      MOVEA.W    -4(A6),A0
011C: 9A88          MOVE.B     A0,(A5)
011E: 206E0018      MOVEA.L    24(A6),A0
0122: 4250          CLR.W      (A0)
0124: 4FEF000A      LEA        10(A7),A7
0128: 6008          BRA.S      $0132
012A: 206E0018      MOVEA.L    24(A6),A0
012E: 30BC0001      MOVE.W     #$0001,(A0)
0132: 206E000C      MOVEA.L    12(A6),A0
0136: 2086          MOVE.L     D6,(A0)
0138: 226E0010      MOVEA.L    16(A6),A1
013C: 2285          MOVE.L     D5,(A1)
013E: 3007          MOVE.W     D7,D0
0140: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0144: 4E5E          UNLK       A6
0146: 4E75          RTS        


; ======= Function at 0x0148 =======
0148: 4E560000      LINK       A6,#0
014C: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
0150: 286E0008      MOVEA.L    8(A6),A4
0154: 266E000C      MOVEA.L    12(A6),A3
0158: 102C0009      MOVE.B     9(A4),D0
015C: B02B0009      MOVE.W     9(A3),D0
0160: 661E          BNE.S      $0180
0162: 102C000A      MOVE.B     10(A4),D0
0166: B02B000A      MOVE.W     10(A3),D0
016A: 6614          BNE.S      $0180
016C: 102C000B      MOVE.B     11(A4),D0
0170: B02B000B      MOVE.W     11(A3),D0
0174: 660A          BNE.S      $0180
0176: 102C000C      MOVE.B     12(A4),D0
017A: B02B000C      MOVE.W     12(A3),D0
017E: 6704          BEQ.S      $0184
0180: 7000          MOVEQ      #0,D0
0182: 6002          BRA.S      $0186
0184: 7001          MOVEQ      #1,D0
0186: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
018A: 4E5E          UNLK       A6
018C: 4E75          RTS        


; ======= Function at 0x018E =======
018E: 4E560000      LINK       A6,#0
0192: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
0196: 286E0008      MOVEA.L    8(A6),A4
019A: 266E000C      MOVEA.L    12(A6),A3
019E: 196B001D0008  MOVE.B     29(A3),8(A4)
01A4: 296B00100004  MOVE.L     16(A3),4(A4)
01AA: 196B0020000A  MOVE.B     32(A3),10(A4)
01B0: 196B0021000B  MOVE.B     33(A3),11(A4)
01B6: 2F0B          MOVE.L     A3,-(A7)
01B8: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
01BC: 1940000C      MOVE.B     D0,12(A4)
01C0: 196B001F0009  MOVE.B     31(A3),9(A4)
01C6: 4CEE1800FFF8  MOVEM.L    -8(A6),A3/A4
01CC: 4E5E          UNLK       A6
01CE: 4E75          RTS        


; ======= Function at 0x01D0 =======
01D0: 4E560000      LINK       A6,#0
01D4: 48E70738      MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)        ; save
01D8: 2E2E0008      MOVE.L     8(A6),D7
01DC: 2847          MOVEA.L    D7,A4
01DE: 7C00          MOVEQ      #0,D6
01E0: 2447          MOVEA.L    D7,A2
01E2: 45EA0E00      LEA        3584(A2),A2
01E6: 42ADF51E      CLR.L      -2786(A5)
01EA: 6020          BRA.S      $020C
01EC: 4A2A000A      TST.B      10(A2)
01F0: 671A          BEQ.S      $020C
01F2: 0C460100      CMPI.W     #$0100,D6
01F6: 6D04          BLT.S      $01FC
01F8: 4EAD01A2      JSR        418(A5)                        ; JT[418]
01FC: 3006          MOVE.W     D6,D0
01FE: 5246          MOVEA.B    D6,A1
0200: 1540000D      MOVE.B     D0,13(A2)
0204: 24ADF51E      MOVE.L     -2786(A5),(A2)                 ; A5-2786
0208: 2B4AF51E      MOVE.L     A2,-2786(A5)
020C: 45EAFFF2      LEA        -14(A2),A2
0210: B9CA63D8      MOVE.W     A2,#$63D8
0214: 7A00          MOVEQ      #0,D5
0216: 49EDA5F0      LEA        -23056(A5),A4                  ; g_dawg_?
021A: 47EDF492      LEA        -2926(A5),A3                   ; A5-2926
021E: 605E          BRA.S      $027E
0220: 244B          MOVEA.L    A3,A2
0222: 2F0C          MOVE.L     A4,-(A7)
0224: 2F0A          MOVE.L     A2,-(A7)
0226: 4EBAFF66      JSR        -154(PC)
022A: 102A0009      MOVE.B     9(A2),D0
022E: 4880          EXT.W      D0
0230: C1FC001CD087  ANDA.L     #$001CD087,A0
0236: 2E80          MOVE.L     D0,(A7)
0238: 2F0A          MOVE.L     A2,-(A7)
023A: 4EBAFF0C      JSR        -244(PC)
023E: 4A40          TST.W      D0
0240: 4FEF000C      LEA        12(A7),A7
0244: 662E          BNE.S      $0274
0246: 102A0009      MOVE.B     9(A2),D0
024A: 4880          EXT.W      D0
024C: C1FC001CD087  ANDA.L     #$001CD087,A0
0252: 2040          MOVEA.L    D0,A0
0254: 4868000E      PEA        14(A0)
0258: 2F0A          MOVE.L     A2,-(A7)
025A: 4EBAFEEC      JSR        -276(PC)
025E: 4A40          TST.W      D0
0260: 508F          MOVE.B     A7,(A0)
0262: 6610          BNE.S      $0274
0264: 3006          MOVE.W     D6,D0
0266: 5246          MOVEA.B    D6,A1
0268: 1540000D      MOVE.B     D0,13(A2)
026C: 24ADF51E      MOVE.L     -2786(A5),(A2)                 ; A5-2786
0270: 2B4AF51E      MOVE.L     A2,-2786(A5)
0274: 5245          MOVEA.B    D5,A1
0276: 49EC0022      LEA        34(A4),A4
027A: 47EB000E      LEA        14(A3),A3
027E: BA6DCF04      MOVEA.W    -12540(A5),A5
0282: 6C06          BGE.S      $028A
0284: 0C460100      CMPI.W     #$0100,D6
0288: 6D96          BLT.S      $0220
028A: 202DF51E      MOVE.L     -2786(A5),D0                   ; A5-2786
028E: 4CDF1CE0      MOVEM.L    (SP)+,D5/D6/D7/A2/A3/A4        ; restore
0292: 4E5E          UNLK       A6
0294: 4E75          RTS        
