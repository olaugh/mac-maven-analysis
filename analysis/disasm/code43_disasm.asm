;======================================================================
; CODE 43 Disassembly
; File: /tmp/maven_code_43.bin
; Header: JT offset=2688, JT entries=4
; Code size: 1486 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0004: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0008: 206E0008      MOVEA.L    8(A6),A0
000C: 7A00          MOVEQ      #0,D5
000E: 1A28000D      MOVE.B     13(A0),D5
0012: 2E05          MOVE.L     D5,D7
0014: 48C7          EXT.L      D7
0016: 8FFC00204847  ORA.L      #$00204847,A7
001C: 48C5          EXT.L      D5
001E: 8BFC00207006  ORA.L      #$00207006,A5
0024: C1C5          ANDA.L     D5,A0
0026: 49EDF980      LEA        -1664(A5),A4                   ; A5-1664
002A: D08C          MOVE.B     A4,(A0)
002C: 2840          MOVEA.L    D0,A4
002E: 4A54          TST.W      (A4)
0030: 665A          BNE.S      $008C
0032: 206E000C      MOVEA.L    12(A6),A0
0036: 16280020      MOVE.B     32(A0),D3
003A: 4883          EXT.W      D3
003C: 18280021      MOVE.B     33(A0),D4
0040: 4884          EXT.W      D4
0042: 7011          MOVEQ      #17,D0
0044: C1C3          ANDA.L     D3,A0
0046: 45EDBCFE      LEA        -17154(A5),A2                  ; g_state1
004A: D08A          MOVE.B     A2,(A0)
004C: 3444          MOVEA.W    D4,A2
004E: D08A          MOVE.B     A2,(A0)
0050: 2440          MOVEA.L    D0,A2
0052: 7044          MOVEQ      #68,D0
0054: C1C3          ANDA.L     D3,A0
0056: 323C0880      MOVE.W     #$0880,D1
005A: C3C5          ANDA.L     D5,A1
005C: D2ADCF08      MOVE.B     -12536(A5),(A1)                ; A5-12536
0060: D081          MOVE.B     D1,(A0)
0062: 2204          MOVE.L     D4,D1
0064: 48C1          EXT.L      D1
0066: E589D280      MOVE.L     A1,-128(A2,A5.W*2)
006A: 2641          MOVEA.L    D1,A3
006C: 7A00          MOVEQ      #0,D5
006E: 2C08          MOVE.L     A0,D6
0070: 600C          BRA.S      $007E
0072: 4A12          TST.B      (A2)
0074: 6602          BNE.S      $0078
0076: 8A93          OR.L       (A3),D5
0078: 5286          MOVE.B     D6,(A1)
007A: 528A          MOVE.B     A2,(A1)
007C: 588B          MOVE.B     A3,(A4)
007E: 2046          MOVEA.L    D6,A0
0080: 4A10          TST.B      (A0)
0082: 66EE          BNE.S      $0072
0084: 29450002      MOVE.L     D5,2(A4)
0088: 38BC0001      MOVE.W     #$0001,(A4)
008C: 204D          MOVEA.L    A5,A0
008E: 2007          MOVE.L     D7,D0
0090: 48C0          EXT.L      D0
0092: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0096: 202899D6      MOVE.L     -26154(A0),D0
009A: C0AC0002      AND.L      2(A4),D0
009E: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
00A2: 4E5E          UNLK       A6
00A4: 4E75          RTS        

00A6: 48780030      PEA        $0030.W
00AA: 486DF980      PEA        -1664(A5)                      ; A5-1664
00AE: 4EAD01AA      JSR        426(A5)                        ; JT[426]
00B2: 508F          MOVE.B     A7,(A0)
00B4: 4E75          RTS        


; ======= Function at 0x00B6 =======
00B6: 4E56FFF4      LINK       A6,#-12                        ; frame=12
00BA: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
00BE: 48780080      PEA        $0080.W
00C2: 486DCE84      PEA        -12668(A5)                     ; A5-12668
00C6: 4EAD01AA      JSR        426(A5)                        ; JT[426]
00CA: 7C00          MOVEQ      #0,D6
00CC: 49EDCCFC      LEA        -13060(A5),A4                  ; A5-13060
00D0: 508F          MOVE.B     A7,(A0)
00D2: 600000F4      BRA.W      $01CA
00D6: 3814          MOVE.W     (A4),D4
00D8: 3F04          MOVE.W     D4,-(A7)
00DA: 4EAD0992      JSR        2450(A5)                       ; JT[2450]
00DE: 2640          MOVEA.L    D0,A3
00E0: 244B          MOVEA.L    A3,A2
00E2: 548F          MOVE.B     A7,(A2)
00E4: 600A          BRA.S      $00F0
00E6: 204D          MOVEA.L    A5,A0
00E8: D0C3          MOVE.B     D3,(A0)+
00EA: 5228CE84      MOVE.B     -12668(A0),D1
00EE: 528A          MOVE.B     A2,(A1)
00F0: 1612          MOVE.B     (A2),D3
00F2: 4883          EXT.W      D3
00F4: 4A43          TST.W      D3
00F6: 66EE          BNE.S      $00E6
00F8: 102DCEC3      MOVE.B     -12605(A5),D0                  ; A5-12605
00FC: B02DA58D      MOVE.W     -23155(A5),D0                  ; A5-23155
0100: 6C0000AC      BGE.W      $01B0
0104: 244B          MOVEA.L    A3,A2
0106: 2E04          MOVE.L     D4,D7
0108: 48C7          EXT.L      D7
010A: E58F41ED      MOVE.L     A7,-19(A2,D4.W)
010E: A756DE88      MOVE.L     (A6),-8568(A3)
0112: 60000090      BRA.W      $01A6
0116: 0C43003F      CMPI.W     #$003F,D3
011A: 67000086      BEQ.W      $01A4
011E: 102A0001      MOVE.B     1(A2),D0
0122: 4880          EXT.W      D0
0124: B043          MOVEA.W    D3,A0
0126: 677A          BEQ.S      $01A2
0128: 3A04          MOVE.W     D4,D5
012A: 2003          MOVE.L     D3,D0
012C: 48C0          EXT.L      D0
012E: E988204D      MOVE.L     A0,77(A4,D2.W)
0132: D0C3          MOVE.B     D3,(A0)+
0134: 1228CE84      MOVE.B     -12668(A0),D1
0138: 4881          EXT.W      D1
013A: 41EDB3F2      LEA        -19470(A5),A0                  ; A5-19470
013E: D088          MOVE.B     A0,(A0)
0140: 3041          MOVEA.W    D1,A0
0142: D1C8CA70      MOVE.B     A0,$CA70.W
0146: 0800102D      BTST       #4141,D0
014A: CEC3          ANDA.W     D3,A7
014C: 4880          EXT.W      D0
014E: 204D          MOVEA.L    A5,A0
0150: D0C0          MOVE.B     D0,(A0)+
0152: D0C0          MOVE.B     D0,(A0)+
0154: 3028B7E4      MOVE.W     -18460(A0),D0
0158: 4640          NOT.W      D0
015A: 0240007F      ANDI.W     #$007F,D0
015E: 8A40          OR.W       D0,D5
0160: 2005          MOVE.L     D5,D0
0162: 48C0          EXT.L      D0
0164: E58841ED      MOVE.L     A0,-19(A2,D4.W)
0168: A756D088      MOVE.L     (A6),-12152(A3)
016C: 2D40FFF8      MOVE.L     D0,-8(A6)
0170: 41ED9412      LEA        -27630(A5),A0                  ; A5-27630
0174: D0C3          MOVE.B     D3,(A0)+
0176: D0C3          MOVE.B     D3,(A0)+
0178: 2D48FFFC      MOVE.L     A0,-4(A6)
017C: 2240          MOVEA.L    D0,A1
017E: 3050          MOVEA.W    (A0),A0
0180: 2D51FFF4      MOVE.L     (A1),-12(A6)
0184: 2247          MOVEA.L    D7,A1
0186: 2211          MOVE.L     (A1),D1
0188: 9288          MOVE.B     A0,(A1)
018A: B2AEFFF4      MOVE.W     -12(A6),(A1)
018E: 6F12          BLE.S      $01A2
0190: 206EFFFC      MOVEA.L    -4(A6),A0
0194: 3050          MOVEA.W    (A0),A0
0196: 2247          MOVEA.L    D7,A1
0198: 2011          MOVE.L     (A1),D0
019A: 9088          MOVE.B     A0,(A0)
019C: 206EFFF8      MOVEA.L    -8(A6),A0
01A0: 2080          MOVE.L     D0,(A0)
01A2: 528A          MOVE.B     A2,(A1)
01A4: 1612          MOVE.B     (A2),D3
01A6: 4883          EXT.W      D3
01A8: 4A43          TST.W      D3
01AA: 6600FF6A      BNE.W      $0118
01AE: 244B          MOVEA.L    A3,A2
01B0: 600A          BRA.S      $01BC
01B2: 204D          MOVEA.L    A5,A0
01B4: D0C3          MOVE.B     D3,(A0)+
01B6: 4228CE84      CLR.B      -12668(A0)
01BA: 528A          MOVE.B     A2,(A1)
01BC: 1612          MOVE.B     (A2),D3
01BE: 4883          EXT.W      D3
01C0: 4A43          TST.W      D3
01C2: 66EE          BNE.S      $01B2
01C4: 5246          MOVEA.B    D6,A1
01C6: 548C          MOVE.B     A4,(A2)
01C8: BC6DCCFA      MOVEA.W    -13062(A5),A6
01CC: 6D00FF08      BLT.W      $00D8
01D0: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
01D4: 4E5E          UNLK       A6
01D6: 4E75          RTS        


; ======= Function at 0x01D8 =======
01D8: 4E56FFFC      LINK       A6,#-4                         ; frame=4
01DC: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
01E0: 2F2E0008      MOVE.L     8(A6),-(A7)
01E4: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
01E8: 204D          MOVEA.L    A5,A0
01EA: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
01EE: 3C3C0080      MOVE.W     #$0080,D6
01F2: 9C6899D8      MOVEA.B    -26152(A0),A6
01F6: 7A00          MOVEQ      #0,D5
01F8: 41EDCCFC      LEA        -13060(A5),A0                  ; A5-13060
01FC: 2D48FFFC      MOVE.L     A0,-4(A6)
0200: 588F          MOVE.B     A7,(A4)
0202: 606C          BRA.S      $0270
0204: 206EFFFC      MOVEA.L    -4(A6),A0
0208: 3810          MOVE.W     (A0),D4
020A: 3006          MOVE.W     D6,D0
020C: C044          AND.W      D4,D0
020E: B046          MOVEA.W    D6,A0
0210: 6658          BNE.S      $026A
0212: 3F04          MOVE.W     D4,-(A7)
0214: 3F3C007F      MOVE.W     #$007F,-(A7)
0218: 4EAD09AA      JSR        2474(A5)                       ; JT[2474]
021C: 8046          OR.W       D6,D0
021E: 3600          MOVE.W     D0,D3
0220: B843          MOVEA.W    D3,A4
0222: 588F          MOVE.B     A7,(A4)
0224: 6D44          BLT.S      $026A
0226: 2004          MOVE.L     D4,D0
0228: 48C0          EXT.L      D0
022A: E58847ED      MOVE.L     A0,-19(A2,D4.W*8)
022E: A756D08B      MOVE.L     (A6),-12149(A3)
0232: 2640          MOVEA.L    D0,A3
0234: 2E13          MOVE.L     (A3),D7
0236: 2003          MOVE.L     D3,D0
0238: 48C0          EXT.L      D0
023A: E58845ED      MOVE.L     A0,-19(A2,D4.W*4)
023E: A756D08A      MOVE.L     (A6),-12150(A3)
0242: 2440          MOVEA.L    D0,A2
0244: 2692          MOVE.L     (A2),(A3)
0246: 2487          MOVE.L     D7,(A2)
0248: 2004          MOVE.L     D4,D0
024A: 48C0          EXT.L      D0
024C: E58845ED      MOVE.L     A0,-19(A2,D4.W*4)
0250: CF30D08A      AND.B      D7,-118(A0,A5.W)
0254: 2440          MOVEA.L    D0,A2
0256: 2E12          MOVE.L     (A2),D7
0258: 2003          MOVE.L     D3,D0
025A: 48C0          EXT.L      D0
025C: E58847ED      MOVE.L     A0,-19(A2,D4.W*8)
0260: CF30D08B      AND.B      D7,-117(A0,A5.W)
0264: 2640          MOVEA.L    D0,A3
0266: 2493          MOVE.L     (A3),(A2)
0268: 2687          MOVE.L     D7,(A3)
026A: 5245          MOVEA.B    D5,A1
026C: 54AEFFFC      MOVE.B     -4(A6),(A2)
0270: BA6DCCFA      MOVEA.W    -13062(A5),A5
0274: 6D8E          BLT.S      $0204
0276: 3F3C003F      MOVE.W     #$003F,-(A7)
027A: 2F2E0008      MOVE.L     8(A6),-(A7)
027E: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
0282: 4A80          TST.L      D0
0284: 5C8F          MOVE.B     A7,(A6)
0286: 6704          BEQ.S      $028C
0288: 4EBAFE2C      JSR        -468(PC)
028C: 7A00          MOVEQ      #0,D5
028E: 49EDCCFC      LEA        -13060(A5),A4                  ; A5-13060
0292: 606E          BRA.S      $0302
0294: 3814          MOVE.W     (A4),D4
0296: 204D          MOVEA.L    A5,A0
0298: 2004          MOVE.L     D4,D0
029A: 48C0          EXT.L      D0
029C: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
02A0: 2C28CF30      MOVE.L     -12496(A0),D6
02A4: 2004          MOVE.L     D4,D0
02A6: 48C0          EXT.L      D0
02A8: E58845ED      MOVE.L     A0,-19(A2,D4.W*4)
02AC: CF30D08A      AND.B      D7,-118(A0,A5.W)
02B0: 2440          MOVEA.L    D0,A2
02B2: 4A86          TST.L      D6
02B4: 6620          BNE.S      $02D6
02B6: 204D          MOVEA.L    A5,A0
02B8: 2004          MOVE.L     D4,D0
02BA: 48C0          EXT.L      D0
02BC: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
02C0: 4AA8A756      TST.L      -22698(A0)
02C4: 6710          BEQ.S      $02D6
02C6: 204D          MOVEA.L    A5,A0
02C8: D0C4          MOVE.B     D4,(A0)+
02CA: D0C4          MOVE.B     D4,(A0)+
02CC: 3028CBFA      MOVE.W     -13318(A0),D0
02D0: D040          MOVEA.B    D0,A0
02D2: 48C0          EXT.L      D0
02D4: 6004          BRA.S      $02DA
02D6: 2006          MOVE.L     D6,D0
02D8: 4480          NEG.L      D0
02DA: 204D          MOVEA.L    A5,A0
02DC: 2204          MOVE.L     D4,D1
02DE: 48C1          EXT.L      D1
02E0: E589D1C1      MOVE.L     A1,-63(A2,A5.W)
02E4: D0A8A756      MOVE.B     -22698(A0),(A0)
02E8: 2480          MOVE.L     D0,(A2)
02EA: 204D          MOVEA.L    A5,A0
02EC: 2004          MOVE.L     D4,D0
02EE: 48C0          EXT.L      D0
02F0: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
02F4: 4AA8CF30      TST.L      -12496(A0)
02F8: 6C04          BGE.S      $02FE
02FA: 4EAD01A2      JSR        418(A5)                        ; JT[418]
02FE: 5245          MOVEA.B    D5,A1
0300: 548C          MOVE.B     A4,(A2)
0302: BA6DCCFA      MOVEA.W    -13062(A5),A5
0306: 6D8C          BLT.S      $0294
0308: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
030C: 4E5E          UNLK       A6
030E: 4E75          RTS        


; ======= Function at 0x0310 =======
0310: 4E56FFEE      LINK       A6,#-18                        ; frame=18
0314: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0318: 48784400      PEA        $4400.W
031C: 2F2DCF08      MOVE.L     -12536(A5),-(A7)               ; A5-12536
0320: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0324: 286E0008      MOVEA.L    8(A6),A4
0328: 508F          MOVE.B     A7,(A0)
032A: 60000196      BRA.W      $04C4
032E: 7600          MOVEQ      #0,D3
0330: 162C000D      MOVE.B     13(A4),D3
0334: 2C03          MOVE.L     D3,D6
0336: 48C6          EXT.L      D6
0338: 8DFC00204A46  ORA.L      #$00204A46,A6
033E: 6D06          BLT.S      $0346
0340: 0C460008      CMPI.W     #$0008,D6
0344: 6D04          BLT.S      $034A
0346: 4EAD01A2      JSR        418(A5)                        ; JT[418]
034A: 48C3          EXT.L      D3
034C: 87FC00204843  ORA.L      #$00204843,A3
0352: 4A43          TST.W      D3
0354: 6D06          BLT.S      $035C
0356: 0C430020      CMPI.W     #$0020,D3
035A: 6504          BCS.S      $0360
035C: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0360: 204D          MOVEA.L    A5,A0
0362: 2003          MOVE.L     D3,D0
0364: 48C0          EXT.L      D0
0366: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
036A: 2A2899D6      MOVE.L     -26154(A0),D5
036E: 162C000A      MOVE.B     10(A4),D3
0372: 4883          EXT.W      D3
0374: 4A43          TST.W      D3
0376: 6D06          BLT.S      $037E
0378: 0C43001F      CMPI.W     #$001F,D3
037C: 6D04          BLT.S      $0382
037E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0382: 4A43          TST.W      D3
0384: 6700013A      BEQ.W      $04C2
0388: 182C000B      MOVE.B     11(A4),D4
038C: 4884          EXT.W      D4
038E: 4A44          TST.W      D4
0390: 6F06          BLE.S      $0398
0392: 0C44000F      CMPI.W     #$000F,D4
0396: 6D04          BLT.S      $039C
0398: 4EAD01A2      JSR        418(A5)                        ; JT[418]
039C: 7011          MOVEQ      #17,D0
039E: C1C3          ANDA.L     D3,A0
03A0: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
03A4: D088          MOVE.B     A0,(A0)
03A6: 3044          MOVEA.W    D4,A0
03A8: D088          MOVE.B     A0,(A0)
03AA: 2D40FFF0      MOVE.L     D0,-16(A6)
03AE: 122C000C      MOVE.B     12(A4),D1
03B2: 4881          EXT.W      D1
03B4: 3041          MOVEA.W    D1,A0
03B6: D088          MOVE.B     A0,(A0)
03B8: 2D40FFFC      MOVE.L     D0,-4(A6)
03BC: 323C0880      MOVE.W     #$0880,D1
03C0: C3C6          ANDA.L     D6,A1
03C2: 2D41FFF8      MOVE.L     D1,-8(A6)
03C6: 2404          MOVE.L     D4,D2
03C8: 48C2          EXT.L      D2
03CA: E58A2442      MOVE.L     A2,66(A2,D2.W*4)
03CE: 7444          MOVEQ      #68,D2
03D0: C5C3          ANDA.L     D3,A2
03D2: D2ADCF08      MOVE.B     -12536(A5),(A1)                ; A5-12536
03D6: D481          MOVE.B     D1,(A2)
03D8: D48A          MOVE.B     A2,(A2)
03DA: 2E02          MOVE.L     D2,D7
03DC: 0C440001      CMPI.W     #$0001,D4
03E0: 6704          BEQ.S      $03E6
03E2: 2047          MOVEA.L    D7,A0
03E4: 8BA0          OR.L       D5,-(A0)
03E6: 7C01          MOVEQ      #1,D6
03E8: DC43          MOVEA.B    D3,A6
03EA: 70FF          MOVEQ      #-1,D0
03EC: D043          MOVEA.B    D3,A0
03EE: 3D40FFEE      MOVE.W     D0,-18(A6)
03F2: 2D4AFFF4      MOVE.L     A2,-12(A6)
03F6: 600000B2      BRA.W      $04AC
03FA: 206EFFF0      MOVEA.L    -16(A6),A0
03FE: 4A10          TST.B      (A0)
0400: 6600009C      BNE.W      $04A0
0404: 4A44          TST.W      D4
0406: 6F06          BLE.S      $040E
0408: 0C440010      CMPI.W     #$0010,D4
040C: 6D04          BLT.S      $0412
040E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0412: 2047          MOVEA.L    D7,A0
0414: 8B90          OR.L       D5,(A0)
0416: 3606          MOVE.W     D6,D3
0418: 7044          MOVEQ      #68,D0
041A: C1C3          ANDA.L     D3,A0
041C: 2440          MOVEA.L    D0,A2
041E: 7011          MOVEQ      #17,D0
0420: C1C3          ANDA.L     D3,A0
0422: 47EDBCFE      LEA        -17154(A5),A3                  ; g_state1
0426: D08B          MOVE.B     A3,(A0)
0428: 2640          MOVEA.L    D0,A3
042A: 6022          BRA.S      $044E
042C: 4A334000      TST.B      0(A3,D4.W)
0430: 6612          BNE.S      $0444
0432: 206DCF08      MOVEA.L    -12536(A5),A0
0436: D1EEFFF8D1CA  MOVE.B     -8(A6),$D1CA.W
043C: D1EEFFF48B90  MOVE.B     -12(A6),$8B90.W
0442: 6016          BRA.S      $045A
0444: 5243          MOVEA.B    D3,A1
0446: 45EA0044      LEA        68(A2),A2
044A: 47EB0011      LEA        17(A3),A3
044E: 0C43001F      CMPI.W     #$001F,D3
0452: 6706          BEQ.S      $045A
0454: 0C430010      CMPI.W     #$0010,D3
0458: 66D2          BNE.S      $042C
045A: 362EFFEE      MOVE.W     -18(A6),D3
045E: 7044          MOVEQ      #68,D0
0460: C1C3          ANDA.L     D3,A0
0462: 2440          MOVEA.L    D0,A2
0464: 7011          MOVEQ      #17,D0
0466: C1C3          ANDA.L     D3,A0
0468: 47EDBCFE      LEA        -17154(A5),A3                  ; g_state1
046C: D08B          MOVE.B     A3,(A0)
046E: 2640          MOVEA.L    D0,A3
0470: 6022          BRA.S      $0494
0472: 4A334000      TST.B      0(A3,D4.W)
0476: 6612          BNE.S      $048A
0478: 206DCF08      MOVEA.L    -12536(A5),A0
047C: D1EEFFF8D1CA  MOVE.B     -8(A6),$D1CA.W
0482: D1EEFFF48B90  MOVE.B     -12(A6),$8B90.W
0488: 6014          BRA.S      $049E
048A: 534345EA      MOVE.B     D3,17898(A1)
048E: FFBC47EBFFEF  MOVE.W     #$47EB,-17(A7,A7.L*8)
0494: 4A43          TST.W      D3
0496: 6706          BEQ.S      $049E
0498: 0C43000F      CMPI.W     #$000F,D3
049C: 66D4          BNE.S      $0472
049E: 52AEFFF0      MOVE.B     -16(A6),(A1)
04A2: 5887          MOVE.B     D7,(A4)
04A4: 5244          MOVEA.B    D4,A1
04A6: 58AEFFF4      MOVE.B     -12(A6),(A4)
04AA: 202EFFF0      MOVE.L     -16(A6),D0
04AE: B0AEFFFC      MOVE.W     -4(A6),(A0)
04B2: 6500FF46      BCS.W      $03FC
04B6: 0C440010      CMPI.W     #$0010,D4
04BA: 6704          BEQ.S      $04C0
04BC: 2047          MOVEA.L    D7,A0
04BE: 8B90          OR.L       D5,(A0)
04C0: 2854          MOVEA.L    (A4),A4
04C2: 200C          MOVE.L     A4,D0
04C4: 6600FE68      BNE.W      $0330
04C8: 4EBA000A      JSR        10(PC)
04CC: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
04D0: 4E5E          UNLK       A6
04D2: 4E75          RTS        


; ======= Function at 0x04D4 =======
04D4: 4E56FFEE      LINK       A6,#-18                        ; frame=18
04D8: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
04DC: 4AADCF08      TST.L      -12536(A5)
04E0: 6604          BNE.S      $04E6
04E2: 4EAD01A2      JSR        418(A5)                        ; JT[418]
04E6: 7A00          MOVEQ      #0,D5
04E8: 99CC6000      MOVE.B     A4,#$00
04EC: 00D2          DC.W       $00D2
04EE: 7600          MOVEQ      #0,D3
04F0: 2E2DCF08      MOVE.L     -12536(A5),D7                  ; A5-12536
04F4: DE8C          MOVE.B     A4,(A7)
04F6: 7044          MOVEQ      #68,D0
04F8: C1C3          ANDA.L     D3,A0
04FA: 2440          MOVEA.L    D0,A2
04FC: 6012          BRA.S      $0510
04FE: 2007          MOVE.L     D7,D0
0500: D08A          MOVE.B     A2,(A0)
0502: 2640          MOVEA.L    D0,A3
0504: 42AB0040      CLR.L      64(A3)
0508: 4293          CLR.L      (A3)
050A: 5243          MOVEA.B    D3,A1
050C: 45EA0044      LEA        68(A2),A2
0510: 0C43001F      CMPI.W     #$001F,D3
0514: 6DE8          BLT.S      $04FE
0516: 7600          MOVEQ      #0,D3
0518: 244C          MOVEA.L    A4,A2
051A: D5EDCF0847EC  MOVE.B     -12536(A5),18412(PC)           ; A5-12536
0520: 083CD7EDCF08  BTST       #55277,#$08
0526: 2C03          MOVE.L     D3,D6
0528: 48C6          EXT.L      D6
052A: E58E600C      MOVE.L     A6,12(A2,D6.W)
052E: 42B36800      CLR.L      0(A3,D6.L)
0532: 42B26800      CLR.L      0(A2,D6.L)
0536: 5243          MOVEA.B    D3,A1
0538: 5886          MOVE.B     D6,(A4)
053A: 0C430011      CMPI.W     #$0011,D3
053E: 6DEE          BLT.S      $052E
0540: 7600          MOVEQ      #0,D3
0542: 2003          MOVE.L     D3,D0
0544: 48C0          EXT.L      D0
0546: E5882440      MOVE.L     A0,64(A2,D2.W*4)
054A: 7044          MOVEQ      #68,D0
054C: C1C3          ANDA.L     D3,A0
054E: 2640          MOVEA.L    D0,A3
0550: 6060          BRA.S      $05B2
0552: 7800          MOVEQ      #0,D4
0554: 204C          MOVEA.L    A4,A0
0556: D1EDCF08D1CB  MOVE.B     -12536(A5),$D1CB.W             ; A5-12536
055C: 2C08          MOVE.L     A0,D6
055E: 2D4AFFFC      MOVE.L     A2,-4(A6)
0562: 2004          MOVE.L     D4,D0
0564: 48C0          EXT.L      D0
0566: E5882D40      MOVE.L     A0,64(A2,D2.L*4)
056A: FFF46036      MOVE.W     54(A4,D6.W),???
056E: 700F          MOVEQ      #15,D0
0570: D044          MOVEA.B    D4,A0
0572: 3D40FFEE      MOVE.W     D0,-18(A6)
0576: 2206          MOVE.L     D6,D1
0578: D2AEFFF4      MOVE.B     -12(A6),(A1)
057C: 2D41FFF8      MOVE.L     D1,-8(A6)
0580: C1FC0044D087  ANDA.L     #$0044D087,A0
0586: D0AEFFFC      MOVE.B     -4(A6),(A0)
058A: 2D40FFF0      MOVE.L     D0,-16(A6)
058E: 2041          MOVEA.L    D1,A0
0590: 2240          MOVEA.L    D0,A1
0592: 2410          MOVE.L     (A0),D2
0594: 8491          OR.L       (A1),D2
0596: 2040          MOVEA.L    D0,A0
0598: 2082          MOVE.L     D2,(A0)
059A: 2041          MOVEA.L    D1,A0
059C: 2082          MOVE.L     D2,(A0)
059E: 5244          MOVEA.B    D4,A1
05A0: 58AEFFF4      MOVE.B     -12(A6),(A4)
05A4: 0C440010      CMPI.W     #$0010,D4
05A8: 6DC4          BLT.S      $056E
05AA: 5243          MOVEA.B    D3,A1
05AC: 588A          MOVE.B     A2,(A4)
05AE: 47EB0044      LEA        68(A3),A3
05B2: 0C430010      CMPI.W     #$0010,D3
05B6: 6D9A          BLT.S      $0552
05B8: 5245          MOVEA.B    D5,A1
05BA: 49EC0880      LEA        2176(A4),A4
05BE: 0C450008      CMPI.W     #$0008,D5
05C2: 6D00FF2A      BLT.W      $04F0
05C6: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
05CA: 4E5E          UNLK       A6
05CC: 4E75          RTS        
