;======================================================================
; CODE 39 Disassembly
; File: /tmp/maven_code_39.bin
; Header: JT offset=2608, JT entries=4
; Code size: 1784 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FFEA      LINK       A6,#-22                        ; frame=22
0004: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0008: 2F2E000C      MOVE.L     12(A6),-(A7)
000C: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0010: 204D          MOVEA.L    A5,A0
0012: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0016: 3A3C0080      MOVE.W     #$0080,D5
001A: 9A6899D8      MOVEA.B    -26152(A0),A5
001E: 206E0018      MOVEA.L    24(A6),A0
0022: 4290          CLR.L      (A0)
0024: 226E0014      MOVEA.L    20(A6),A1
0028: 4291          CLR.L      (A1)
002A: 7019          MOVEQ      #25,D0
002C: D0AE0008      MOVE.B     8(A6),(A0)
0030: 2840          MOVEA.L    D0,A4
0032: 1014          MOVE.B     (A4),D0
0034: 4880          EXT.W      D0
0036: 3E80          MOVE.W     D0,(A7)
0038: 3F3C007F      MOVE.W     #$007F,-(A7)
003C: 4EAD09AA      JSR        2474(A5)                       ; JT[2474]
0040: 8045          OR.W       D5,D0
0042: 3D40FFF2      MOVE.W     D0,-14(A6)
0046: 7C00          MOVEQ      #0,D6
0048: 306E0010      MOVEA.W    16(A6),A0
004C: D1C82D48      MOVE.B     A0,$2D48.W
0050: FFEE366E      MOVE.W     13934(A6),???
0054: 0012D7CB      ORI.B      #$D7CB,(A2)
0058: 45EDCCFC      LEA        -13060(A5),A2                  ; A5-13060
005C: D4C6          MOVE.B     D6,(A2)+
005E: D4C6          MOVE.B     D6,(A2)+
0060: 5C8F          MOVE.B     A7,(A6)
0062: 60000118      BRA.W      $017E
0066: 3612          MOVE.W     (A2),D3
0068: 3005          MOVE.W     D5,D0
006A: C043          AND.W      D3,D0
006C: B045          MOVEA.W    D5,A0
006E: 66000108      BNE.W      $017A
0072: 204D          MOVEA.L    A5,A0
0074: 2003          MOVE.L     D3,D0
0076: 48C0          EXT.L      D0
0078: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
007C: 4AA8A756      TST.L      -22698(A0)
0080: 670000F6      BEQ.W      $017A
0084: 3F12          MOVE.W     (A2),-(A7)
0086: 3F3C007F      MOVE.W     #$007F,-(A7)
008A: 4EAD09AA      JSR        2474(A5)                       ; JT[2474]
008E: 8045          OR.W       D5,D0
0090: 3600          MOVE.W     D0,D3
0092: 1814          MOVE.B     (A4),D4
0094: 4884          EXT.W      D4
0096: 3004          MOVE.W     D4,D0
0098: 8043          OR.W       D3,D0
009A: B840          MOVEA.W    D0,A4
009C: 588F          MOVE.B     A7,(A4)
009E: 6704          BEQ.S      $00A4
00A0: 4EAD01A2      JSR        418(A5)                        ; JT[418]
00A4: 7012          MOVEQ      #18,D0
00A6: C1C3          ANDA.L     D3,A0
00A8: D0ADCF0C      MOVE.B     -12532(A5),(A0)                ; A5-12532
00AC: D0AEFFEE      MOVE.B     -18(A6),(A0)
00B0: 2040          MOVEA.L    D0,A0
00B2: 224D          MOVEA.L    A5,A1
00B4: 3012          MOVE.W     (A2),D0
00B6: 48C0          EXT.L      D0
00B8: E588D3C0      MOVE.L     A0,-64(A2,A5.W*2)
00BC: 3829A758      MOVE.W     -22696(A1),D4
00C0: 9850          MOVEA.B    (A0),A4
00C2: 3F05          MOVE.W     D5,-(A7)
00C4: 3D43FFEC      MOVE.W     D3,-20(A6)
00C8: 3F03          MOVE.W     D3,-(A7)
00CA: 3F2EFFF2      MOVE.W     -14(A6),-(A7)
00CE: 4EAD09B2      JSR        2482(A5)                       ; JT[2482]
00D2: 3600          MOVE.W     D0,D3
00D4: 0C43007F      CMPI.W     #$007F,D3
00D8: 5C8F          MOVE.B     A7,(A6)
00DA: 6632          BNE.S      $010E
00DC: 7012          MOVEQ      #18,D0
00DE: C1EEFFEC      ANDA.L     -20(A6),A0
00E2: D0ADCF10      MOVE.B     -12528(A5),(A0)                ; A5-12528
00E6: 2040          MOVEA.L    D0,A0
00E8: 302E0010      MOVE.W     16(A6),D0
00EC: D0C0          MOVE.B     D0,(A0)+
00EE: 3D700000FFEA  MOVE.W     0(A0,D0.W),-22(A6)
00F4: 4A6EFFEA      TST.W      -22(A6)
00F8: 6F14          BLE.S      $010E
00FA: 206DCF1C      MOVEA.L    -12516(A5),A0
00FE: 41E808EE      LEA        2286(A0),A0
0102: D1EEFFEE3010  MOVE.B     -18(A6),$3010.W
0108: D06EFFEA      MOVEA.B    -22(A6),A0
010C: D840          MOVEA.B    D0,A4
010E: 206E0014      MOVEA.L    20(A6),A0
0112: 3244          MOVEA.W    D4,A1
0114: B3D06F083044  MOVE.W     (A0),$6F083044
011A: 226E0014      MOVEA.L    20(A6),A1
011E: 2288          MOVE.L     A0,(A1)
0120: 7012          MOVEQ      #18,D0
0122: C1C3          ANDA.L     D3,A0
0124: D0ADCF0C      MOVE.B     -12532(A5),(A0)                ; A5-12532
0128: 2E00          MOVE.L     D0,D7
012A: 206E0018      MOVEA.L    24(A6),A0
012E: 226E0008      MOVEA.L    8(A6),A1
0132: 3012          MOVE.W     (A2),D0
0134: 48C0          EXT.L      D0
0136: E5884878      MOVE.L     A0,120(A2,D4.L)
013A: A756D09F      MOVE.L     (A6),-12129(A3)
013E: 3229000A      MOVE.W     10(A1),D1
0142: D2750802      MOVEA.B    2(A5,D0.L),A1
0146: 92737800      MOVEA.B    0(A3,D7.L),A1
014A: 3241          MOVEA.W    D1,A1
014C: B3D06F28206E  MOVE.W     (A0),$6F28206E
0152: 001C3083      ORI.B      #$3083,(A4)+
0156: 226E0008      MOVEA.L    8(A6),A1
015A: 204D          MOVEA.L    A5,A0
015C: 3012          MOVE.W     (A2),D0
015E: 48C0          EXT.L      D0
0160: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0164: 3029000A      MOVE.W     10(A1),D0
0168: D068A758      MOVEA.B    -22696(A0),A0
016C: 90737800      MOVEA.B    0(A3,D7.L),A0
0170: 3040          MOVEA.W    D0,A0
0172: 226E0018      MOVEA.L    24(A6),A1
0176: 2288          MOVE.L     A0,(A1)
0178: 5246          MOVEA.B    D6,A1
017A: 548A          MOVE.B     A2,(A2)
017C: BC6DCCFA      MOVEA.W    -13062(A5),A6
0180: 6D00FEE4      BLT.W      $0068
0184: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0188: 4E5E          UNLK       A6
018A: 4E75          RTS        


; ======= Function at 0x018C =======
018C: 4E56DA60      LINK       A6,#-9632                      ; frame=9632
0190: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0194: 4A6E0008      TST.W      8(A6)
0198: 6714          BEQ.S      $01AE
019A: 2D6DCF0CDA84  MOVE.L     -12532(A5),-9596(A6)           ; A5-12532
01A0: 2D6DCF10DA76  MOVE.L     -12528(A5),-9610(A6)           ; A5-12528
01A6: 2D6DCF14DA7C  MOVE.L     -12524(A5),-9604(A6)           ; A5-12524
01AC: 6012          BRA.S      $01C0
01AE: 2D6DCF18DA84  MOVE.L     -12520(A5),-9596(A6)           ; A5-12520
01B4: 2D6DCF1CDA76  MOVE.L     -12516(A5),-9610(A6)           ; A5-12516
01BA: 2D6DCF20DA7C  MOVE.L     -12512(A5),-9604(A6)           ; A5-12512
01C0: 2F2E000A      MOVE.L     10(A6),-(A7)
01C4: 4EAD0AAA      JSR        2730(A5)                       ; JT[2730]
01C8: 2EAE000A      MOVE.L     10(A6),(A7)
01CC: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
01D0: 204D          MOVEA.L    A5,A0
01D2: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
01D6: 303C0080      MOVE.W     #$0080,D0
01DA: 906899D8      MOVEA.B    -26152(A0),A0
01DE: 3D40DA74      MOVE.W     D0,-9612(A6)
01E2: 7600          MOVEQ      #0,D3
01E4: 3D43DA7A      MOVE.W     D3,-9606(A6)
01E8: 45EDCCFC      LEA        -13060(A5),A2                  ; A5-13060
01EC: D4C3          MOVE.B     D3,(A2)+
01EE: D4C3          MOVE.B     D3,(A2)+
01F0: 588F          MOVE.B     A7,(A4)
01F2: 6032          BRA.S      $0226
01F4: 3812          MOVE.W     (A2),D4
01F6: 707F          MOVEQ      #127,D0
01F8: 8044          OR.W       D4,D0
01FA: 0C40007F      CMPI.W     #$007F,D0
01FE: 6704          BEQ.S      $0204
0200: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0204: 302EDA74      MOVE.W     -9612(A6),D0
0208: C044          AND.W      D4,D0
020A: B06EDA74      MOVEA.W    -9612(A6),A0
020E: 6612          BNE.S      $0222
0210: 302EDA7A      MOVE.W     -9606(A6),D0
0214: 526EDA7A      MOVEA.B    -9606(A6),A1
0218: 204E          MOVEA.L    A6,A0
021A: D0C0          MOVE.B     D0,(A0)+
021C: D0C0          MOVE.B     D0,(A0)+
021E: 3144FEFC      MOVE.W     D4,-260(A0)
0222: 5243          MOVEA.B    D3,A1
0224: 548A          MOVE.B     A2,(A2)
0226: B66DCCFA      MOVEA.W    -13062(A5),A3
022A: 6DC8          BLT.S      $01F4
022C: 45EEDC9C      LEA        -9060(A6),A2
0230: 7600          MOVEQ      #0,D3
0232: 47EEFEFC      LEA        -260(A6),A3
0236: 41EEDA98      LEA        -9576(A6),A0
023A: 2D48DA88      MOVE.L     A0,-9592(A6)
023E: 605A          BRA.S      $029A
0240: 206EDA88      MOVEA.L    -9592(A6),A0
0244: 208A          MOVE.L     A2,(A0)
0246: 3813          MOVE.W     (A3),D4
0248: 3A03          MOVE.W     D3,D5
024A: 43EEFEFC      LEA        -260(A6),A1
024E: D2C5          MOVE.B     D5,(A1)+
0250: D2C5          MOVE.B     D5,(A1)+
0252: 2E09          MOVE.L     A1,D7
0254: 6036          BRA.S      $028C
0256: 2047          MOVEA.L    D7,A0
0258: 3C10          MOVE.W     (A0),D6
025A: 3004          MOVE.W     D4,D0
025C: 8046          OR.W       D6,D0
025E: B840          MOVEA.W    D0,A4
0260: 6626          BNE.S      $0288
0262: 204D          MOVEA.L    A5,A0
0264: 2006          MOVE.L     D6,D0
0266: 48C0          EXT.L      D0
0268: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
026C: 4AA8A756      TST.L      -22698(A0)
0270: 6716          BEQ.S      $0288
0272: 3F06          MOVE.W     D6,-(A7)
0274: 3F04          MOVE.W     D4,-(A7)
0276: 4EAD09AA      JSR        2474(A5)                       ; JT[2474]
027A: 806EDA74      OR.W       -9612(A6),D0
027E: 3480          MOVE.W     D0,(A2)
0280: 35460002      MOVE.W     D6,2(A2)
0284: 588A          MOVE.B     A2,(A4)
0286: 588F          MOVE.B     A7,(A4)
0288: 5245          MOVEA.B    D5,A1
028A: 5487          MOVE.B     D7,(A2)
028C: BA6EDA7A      MOVEA.W    -9606(A6),A5
0290: 6DC4          BLT.S      $0256
0292: 5243          MOVEA.B    D3,A1
0294: 548B          MOVE.B     A3,(A2)
0296: 58AEDA88      MOVE.B     -9592(A6),(A4)
029A: B66EDA7A      MOVEA.W    -9606(A6),A3
029E: 6DA0          BLT.S      $0240
02A0: 204E          MOVEA.L    A6,A0
02A2: 2003          MOVE.L     D3,D0
02A4: 48C0          EXT.L      D0
02A6: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
02AA: 214ADA98      MOVE.L     A2,-9576(A0)
02AE: 7600          MOVEQ      #0,D3
02B0: 45EEFEFC      LEA        -260(A6),A2
02B4: 602C          BRA.S      $02E2
02B6: 3812          MOVE.W     (A2),D4
02B8: 7012          MOVEQ      #18,D0
02BA: C1C4          ANDA.L     D4,A0
02BC: 2640          MOVEA.L    D0,A3
02BE: 204B          MOVEA.L    A3,A0
02C0: D1EEDA844250  MOVE.B     -9596(A6),$4250.W
02C6: 204B          MOVEA.L    A3,A0
02C8: D1EEDA7C4250  MOVE.B     -9604(A6),$4250.W
02CE: 204D          MOVEA.L    A5,A0
02D0: D0C4          MOVE.B     D4,(A0)+
02D2: D0C4          MOVE.B     D4,(A0)+
02D4: 224B          MOVEA.L    A3,A1
02D6: D3EEDA7632A8CBFA  MOVE.B     -9610(A6),$32A8CBFA
02DE: 5243          MOVEA.B    D3,A1
02E0: 548A          MOVE.B     A2,(A2)
02E2: B66EDA7A      MOVEA.W    -9606(A6),A3
02E6: 6DCE          BLT.S      $02B6
02E8: 3D7C0001DA74  MOVE.W     #$0001,-9612(A6)
02EE: 3D7C0001DA6A  MOVE.W     #$0001,-9622(A6)
02F4: 7002          MOVEQ      #2,D0
02F6: 2D40DA88      MOVE.L     D0,-9592(A6)
02FA: 60000198      BRA.W      $0496
02FE: 426EDA74      CLR.W      -9612(A6)
0302: 7600          MOVEQ      #0,D3
0304: 2E2EDA88      MOVE.L     -9592(A6),D7
0308: 306EDA6A      MOVEA.W    -9622(A6),A0
030C: D1C85588      MOVE.B     A0,$5588.W
0310: 2D48DA94      MOVE.L     A0,-9580(A6)
0314: 2003          MOVE.L     D3,D0
0316: 48C0          EXT.L      D0
0318: E58843EE      MOVE.L     A0,-18(A2,D4.W*2)
031C: DA98          MOVE.B     (A0)+,(A5)
031E: D089          MOVE.B     A1,(A0)
0320: 2D40DA8C      MOVE.L     D0,-9588(A6)
0324: 43EEFEFC      LEA        -260(A6),A1
0328: D2C3          MOVE.B     D3,(A1)+
032A: D2C3          MOVE.B     D3,(A1)+
032C: 2D49DA90      MOVE.L     A1,-9584(A6)
0330: 60000152      BRA.W      $0486
0334: 206EDA90      MOVEA.L    -9584(A6),A0
0338: 3810          MOVE.W     (A0),D4
033A: 7012          MOVEQ      #18,D0
033C: C1C4          ANDA.L     D4,A0
033E: 2640          MOVEA.L    D0,A3
0340: 224B          MOVEA.L    A3,A1
0342: D3EEDA84D3C72D49  MOVE.B     -9596(A6),$D3C72D49
034A: DA70284B      MOVEA.B    75(A0,D2.L),A5
034E: D9EEDA76D9C7  MOVE.B     -9610(A6),#$C7
0354: 204B          MOVEA.L    A3,A0
0356: D1EEDA7CD1C7  MOVE.B     -9604(A6),$D1C7.W
035C: 2D48DA6C      MOVE.L     A0,-9620(A6)
0360: 3829FFFE      MOVE.W     -2(A1),D4
0364: 3284          MOVE.W     D4,(A1)
0366: 48C4          EXT.L      D4
0368: 30A8FFFE      MOVE.W     -2(A0),(A0)
036C: 38ACFFFE      MOVE.W     -2(A4),(A4)
0370: 670A          BEQ.S      $037C
0372: 3054          MOVEA.W    (A4),A0
0374: D1C870E8      MOVE.B     A0,$70E8.W
0378: D880          MOVE.B     D0,(A4)
037A: 9888          MOVE.B     A0,(A4)
037C: 206EDA8C      MOVEA.L    -9588(A6),A0
0380: 2450          MOVEA.L    (A0),A2
0382: 2003          MOVE.L     D3,D0
0384: 48C0          EXT.L      D0
0386: E58847EE      MOVE.L     A0,-18(A2,D4.W*8)
038A: DA9C          MOVE.B     (A4)+,(A5)
038C: D08B          MOVE.B     A3,(A0)
038E: 2640          MOVEA.L    D0,A3
0390: 600000C0      BRA.W      $0454
0394: 3C2A0002      MOVE.W     2(A2),D6
0398: 3A12          MOVE.W     (A2),D5
039A: 204D          MOVEA.L    A5,A0
039C: 2006          MOVE.L     D6,D0
039E: 48C0          EXT.L      D0
03A0: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
03A4: 7012          MOVEQ      #18,D0
03A6: C1C5          ANDA.L     D5,A0
03A8: D0AEDA84      MOVE.B     -9596(A6),(A0)
03AC: D0AEDA94      MOVE.B     -9580(A6),(A0)
03B0: 2240          MOVEA.L    D0,A1
03B2: 3251          MOVEA.W    (A1),A1
03B4: D3E8A7562D49DA62  MOVE.B     -22698(A0),$2D49DA62
03BC: 2D49DA66      MOVE.L     A1,-9626(A6)
03C0: 7012          MOVEQ      #18,D0
03C2: C1C5          ANDA.L     D5,A0
03C4: 5580D0AE      MOVE.B     D0,-82(A2,A5.W)
03C8: DA762040      MOVEA.B    64(A6,D2.W),A5
03CC: 302EDA6A      MOVE.W     -9622(A6),D0
03D0: D0C0          MOVE.B     D0,(A0)+
03D2: 3D700000DA60  MOVE.W     0(A0,D0.W),-9632(A6)
03D8: 7212          MOVEQ      #18,D1
03DA: C3C5          ANDA.L     D5,A1
03DC: 5581D2AE      MOVE.B     D1,-82(A2,A5.W*2)
03E0: DA763040      MOVEA.B    64(A6,D3.W),A5
03E4: D1C8D288      MOVE.B     A0,$D288.W
03E8: 2D41DA80      MOVE.L     D1,-9600(A6)
03EC: 4A6EDA60      TST.W      -9632(A6)
03F0: 670E          BEQ.S      $0400
03F2: 306EDA60      MOVEA.W    -9632(A6),A0
03F6: D1C87018      MOVE.B     A0,$7018.W
03FA: D088          MOVE.B     A0,(A0)
03FC: 91AEDA66B8AE  MOVE.B     -9626(A6),-82(A0,A3.L)
0402: DA66          MOVEA.B    -(A6),A5
0404: 6C4A          BGE.S      $0450
0406: 204D          MOVEA.L    A5,A0
0408: 2006          MOVE.L     D6,D0
040A: 48C0          EXT.L      D0
040C: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0410: 2828CF30      MOVE.L     -12496(A0),D4
0414: 7012          MOVEQ      #18,D0
0416: C1C5          ANDA.L     D5,A0
0418: 5580D0AE      MOVE.B     D0,-82(A2,A5.W)
041C: DA7C2040      MOVEA.B    #$40,A5
0420: 302EDA6A      MOVE.W     -9622(A6),D0
0424: D0C0          MOVE.B     D0,(A0)+
0426: 3C300000      MOVE.W     0(A0,D0.W),D6
042A: 3046          MOVEA.W    D6,A0
042C: B1C46F06      MOVE.W     D4,$6F06.W
0430: 2006          MOVE.L     D6,D0
0432: 48C0          EXT.L      D0
0434: 6002          BRA.S      $0438
0436: 2004          MOVE.L     D4,D0
0438: 206EDA6C      MOVEA.L    -9620(A6),A0
043C: 3080          MOVE.W     D0,(A0)
043E: 226EDA80      MOVEA.L    -9600(A6),A1
0442: 3891          MOVE.W     (A1),(A4)
0444: 206EDA70      MOVEA.L    -9616(A6),A0
0448: 30AEDA64      MOVE.W     -9628(A6),(A0)
044C: 282EDA66      MOVE.L     -9626(A6),D4
0450: 588A          MOVE.B     A2,(A4)
0452: B5D36500      MOVE.W     (A3),25856(PC)
0456: FF3E          MOVE.W     ???,-(A7)
0458: 206EDA70      MOVEA.L    -9616(A6),A0
045C: 3010          MOVE.W     (A0),D0
045E: B060          MOVEA.W    -(A0),A0
0460: 6612          BNE.S      $0474
0462: 206EDA6C      MOVEA.L    -9620(A6),A0
0466: 3010          MOVE.W     (A0),D0
0468: B060          MOVEA.W    -(A0),A0
046A: 6608          BNE.S      $0474
046C: 3014          MOVE.W     (A4),D0
046E: B06CFFFE      MOVEA.W    -2(A4),A0
0472: 6706          BEQ.S      $047A
0474: 3D7C0001DA74  MOVE.W     #$0001,-9612(A6)
047A: 5243          MOVEA.B    D3,A1
047C: 58AEDA8C      MOVE.B     -9588(A6),(A4)
0480: 54AEDA90      MOVE.B     -9584(A6),(A2)
0484: B66EDA7A      MOVEA.W    -9606(A6),A3
0488: 6D00FEAA      BLT.W      $0336
048C: 526EDA6A      MOVEA.B    -9622(A6),A1
0490: 54AEDA88      MOVE.B     -9592(A6),(A2)
0494: 4A6EDA74      TST.W      -9612(A6)
0498: 6600FE64      BNE.W      $0300
049C: 7600          MOVEQ      #0,D3
049E: 3E2EDA6A      MOVE.W     -9622(A6),D7
04A2: 48C7          EXT.L      D7
04A4: DE87          MOVE.B     D7,(A7)
04A6: 45EEFEFC      LEA        -260(A6),A2
04AA: D4C3          MOVE.B     D3,(A2)+
04AC: D4C3          MOVE.B     D3,(A2)+
04AE: 6058          BRA.S      $0508
04B0: 3812          MOVE.W     (A2),D4
04B2: 7012          MOVEQ      #18,D0
04B4: C1C4          ANDA.L     D4,A0
04B6: 2640          MOVEA.L    D0,A3
04B8: 204B          MOVEA.L    A3,A0
04BA: D1EEDA84D1C7  MOVE.B     -9596(A6),$D1C7.W
04C0: 2D48DA70      MOVE.L     A0,-9616(A6)
04C4: 284B          MOVEA.L    A3,A4
04C6: D9EEDA76D9C7  MOVE.B     -9610(A6),#$C7
04CC: 224B          MOVEA.L    A3,A1
04CE: D3EEDA7CD3C72D49  MOVE.B     -9604(A6),$D3C72D49
04D6: DA6C3A2E      MOVEA.B    14894(A4),A5
04DA: DA6A6020      MOVEA.B    24608(A2),A5
04DE: 206EDA70      MOVEA.L    -9616(A6),A0
04E2: 30A8FFFE      MOVE.W     -2(A0),(A0)
04E6: 38ACFFFE      MOVE.W     -2(A4),(A4)
04EA: 226EDA6C      MOVEA.L    -9620(A6),A1
04EE: 32A9FFFE      MOVE.W     -2(A1),(A1)
04F2: 5245          MOVEA.B    D5,A1
04F4: 54AEDA70      MOVE.B     -9616(A6),(A2)
04F8: 548C          MOVE.B     A4,(A2)
04FA: 54AEDA6C      MOVE.B     -9620(A6),(A2)
04FE: 0C450009      CMPI.W     #$0009,D5
0502: 6DDA          BLT.S      $04DE
0504: 5243          MOVEA.B    D3,A1
0506: 548A          MOVE.B     A2,(A2)
0508: B66EDA7A      MOVEA.W    -9606(A6),A3
050C: 6DA2          BLT.S      $04B0
050E: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0512: 4E5E          UNLK       A6
0514: 4E75          RTS        


; ======= Function at 0x0516 =======
0516: 4E560000      LINK       A6,#0
051A: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
051E: 206E000A      MOVEA.L    10(A6),A0
0522: 4250          CLR.W      (A0)
0524: 7012          MOVEQ      #18,D0
0526: C1EE0008      ANDA.L     8(A6),A0
052A: 2840          MOVEA.L    D0,A4
052C: 202DCF14      MOVE.L     -12524(A5),D0                  ; A5-12524
0530: 226E000E      MOVEA.L    14(A6),A1
0534: 32B40810      MOVE.W     16(A4,D0.L),(A1)
0538: 7012          MOVEQ      #18,D0
053A: C1EE0008      ANDA.L     8(A6),A0
053E: 206DCF10      MOVEA.L    -12528(A5),A0
0542: 3E300810      MOVE.W     16(A0,D0.L),D7
0546: 4A47          TST.W      D7
0548: 6706          BEQ.S      $0550
054A: 3007          MOVE.W     D7,D0
054C: 4440          NEG.W      D0
054E: 6008          BRA.S      $0558
0550: 206DCF1C      MOVEA.L    -12516(A5),A0
0554: 302808EE      MOVE.W     2286(A0),D0
0558: 206DCF1C      MOVEA.L    -12516(A5),A0
055C: 222DCF0C      MOVE.L     -12532(A5),D1                  ; A5-12532
0560: 342808EE      MOVE.W     2286(A0),D2
0564: D4741810      MOVEA.B    16(A4,D1.L),A2
0568: D042          MOVEA.B    D2,A0
056A: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
056E: 4E5E          UNLK       A6
0570: 4E75          RTS        


; ======= Function at 0x0572 =======
0572: 4E56FFEC      LINK       A6,#-20                        ; frame=20
0576: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
057A: 7012          MOVEQ      #18,D0
057C: C1EE0008      ANDA.L     8(A6),A0
0580: 2840          MOVEA.L    D0,A4
0582: 264C          MOVEA.L    A4,A3
0584: D7EDCF107012  MOVE.B     -12528(A5),18(PC,D7.W)         ; A5-12528
058A: C1EE000A      ANDA.L     10(A6),A0
058E: 2440          MOVEA.L    D0,A2
0590: 2E2DCF1C      MOVE.L     -12516(A5),D7                  ; A5-12516
0594: DE8A          MOVE.B     A2,(A7)
0596: 2C2DCF0C      MOVE.L     -12532(A5),D6                  ; A5-12532
059A: DC8C          MOVE.B     A4,(A6)
059C: 204A          MOVEA.L    A2,A0
059E: D1EDCF182D48  MOVE.B     -12520(A5),$2D48.W             ; A5-12520
05A4: FFEC224C      MOVE.W     8780(A4),???
05A8: D3EDCF142D49FFF0  MOVE.B     -12524(A5),$2D49FFF0           ; A5-12524
05B0: 284A          MOVEA.L    A2,A4
05B2: D9EDCF203A2B  MOVE.B     -12512(A5),#$2B                ; A5-12512
05B8: 00102246      ORI.B      #$2246,(A0)
05BC: 38290010      MOVE.W     16(A1),D4
05C0: 98680010      MOVEA.B    16(A0),A4
05C4: 9845          MOVEA.B    D5,A4
05C6: 2247          MOVEA.L    D7,A1
05C8: 36290010      MOVE.W     16(A1),D3
05CC: 4A43          TST.W      D3
05CE: 6704          BEQ.S      $05D4
05D0: 3003          MOVE.W     D3,D0
05D2: 6004          BRA.S      $05D8
05D4: 3005          MOVE.W     D5,D0
05D6: 4440          NEG.W      D0
05D8: D840          MOVEA.B    D0,A4
05DA: 206E000C      MOVEA.L    12(A6),A0
05DE: 30AC0010      MOVE.W     16(A4),(A0)
05E2: 226EFFF0      MOVEA.L    -16(A6),A1
05E6: 206E0010      MOVEA.L    16(A6),A0
05EA: 30A90010      MOVE.W     16(A1),(A0)
05EE: 7A07          MOVEQ      #7,D5
05F0: 347C000E      MOVEA.W    #$000E,A2
05F4: 60000082      BRA.W      $067A
05F8: 4A727800      TST.W      0(A2,D7.L)
05FC: 6632          BNE.S      $0630
05FE: 204B          MOVEA.L    A3,A0
0600: D1CA3010      MOVE.B     A2,$3010.W
0604: D040          MOVEA.B    D0,A0
0606: 204A          MOVEA.L    A2,A0
0608: D1EEFFEC3632  MOVE.B     -20(A6),$3632.W
060E: 68009650      BVC.W      $-639E
0612: 9640          MOVEA.B    D0,A3
0614: B843          MOVEA.W    D3,A4
0616: 6F18          BLE.S      $0630
0618: 3803          MOVE.W     D3,D4
061A: 204C          MOVEA.L    A4,A0
061C: D1CA226E      MOVE.B     A2,$226E.W
0620: 000C3290      ORI.B      #$3290,A4
0624: 204A          MOVEA.L    A2,A0
0626: D1EEFFF0226E  MOVE.B     -16(A6),$226E.W
062C: 00103290      ORI.B      #$3290,(A0)
0630: 204B          MOVEA.L    A3,A0
0632: D1CA4A50      MOVE.B     A2,$4A50.W
0636: 663C          BNE.S      $0674
0638: 3045          MOVEA.W    D5,A0
063A: 41F050FE      LEA        -2(A0,D5.W),A0
063E: 2D48FFF4      MOVE.L     A0,-12(A6)
0642: 2248          MOVEA.L    A0,A1
0644: D3EEFFEC36326800  MOVE.B     -20(A6),$36326800
064C: 9651          MOVEA.B    (A1),A3
064E: 30307800      MOVE.W     0(A0,D7.L),D0
0652: D040          MOVEA.B    D0,A0
0654: D640          MOVEA.B    D0,A3
0656: B843          MOVEA.W    D3,A4
0658: 6C1A          BGE.S      $0674
065A: 3803          MOVE.W     D3,D4
065C: 204C          MOVEA.L    A4,A0
065E: D1EEFFF4226E  MOVE.B     -12(A6),$226E.W
0664: 000C3290      ORI.B      #$3290,A4
0668: 204A          MOVEA.L    A2,A0
066A: D1EEFFF0226E  MOVE.B     -16(A6),$226E.W
0670: 00103290      ORI.B      #$3290,(A0)
0674: 5345558A      MOVE.B     D5,21898(A1)
0678: 4A45          TST.W      D5
067A: 6E00FF7C      BGT.W      $05FA
067E: 3004          MOVE.W     D4,D0
0680: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0684: 4E5E          UNLK       A6
0686: 4E75          RTS        


; ======= Function at 0x0688 =======
0688: 4E560000      LINK       A6,#0
068C: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
0690: 3C2E000A      MOVE.W     10(A6),D6
0694: 2F2E0010      MOVE.L     16(A6),-(A7)
0698: 2F2E000C      MOVE.L     12(A6),-(A7)
069C: 3F06          MOVE.W     D6,-(A7)
069E: 3F2E0008      MOVE.W     8(A6),-(A7)
06A2: 4EBAFECE      JSR        -306(PC)
06A6: 3E00          MOVE.W     D0,D7
06A8: 7012          MOVEQ      #18,D0
06AA: C1C6          ANDA.L     D6,A0
06AC: D0ADCF1C      MOVE.B     -12516(A5),(A0)                ; A5-12516
06B0: 2840          MOVEA.L    D0,A4
06B2: 7012          MOVEQ      #18,D0
06B4: C1C6          ANDA.L     D6,A0
06B6: 206DCF20      MOVEA.L    -12512(A5),A0
06BA: 7212          MOVEQ      #18,D1
06BC: C3C6          ANDA.L     D6,A1
06BE: 226DCF18      MOVEA.L    -12520(A5),A1
06C2: 3414          MOVE.W     (A4),D2
06C4: D442          MOVEA.B    D2,A2
06C6: D4711810      MOVEA.B    16(A1,D1.L),A2
06CA: B4700810      MOVEA.W    16(A0,D0.L),A2
06CE: 4FEF000C      LEA        12(A7),A7
06D2: 661A          BNE.S      $06EE
06D4: 7012          MOVEQ      #18,D0
06D6: C1EE0008      ANDA.L     8(A6),A0
06DA: 206DCF0C      MOVEA.L    -12532(A5),A0
06DE: 3214          MOVE.W     (A4),D1
06E0: D241          MOVEA.B    D1,A1
06E2: D2700810      MOVEA.B    16(A0,D0.L),A1
06E6: 9247          MOVEA.B    D7,A1
06E8: 226E000C      MOVEA.L    12(A6),A1
06EC: 3281          MOVE.W     D1,(A1)
06EE: 3007          MOVE.W     D7,D0
06F0: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
06F4: 4E5E          UNLK       A6
06F6: 4E75          RTS        
