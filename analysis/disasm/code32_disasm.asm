;======================================================================
; CODE 32 Disassembly
; File: /tmp/maven_code_32.bin
; Header: JT offset=2384, JT entries=13
; Code size: 6464 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FEBC      LINK       A6,#-324                       ; frame=324
0004: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0008: 426DBCFA      CLR.W      -17158(A5)
000C: 426DBCF8      CLR.W      -17160(A5)
0010: 426DBCF6      CLR.W      -17162(A5)
0014: 426DBCF4      CLR.W      -17164(A5)
0018: 426DB1D6      CLR.W      -20010(A5)
001C: 7020          MOVEQ      #32,D0
001E: D0AE0008      MOVE.B     8(A6),(A0)
0022: 2840          MOVEA.L    D0,A4
0024: 4A14          TST.B      (A4)
0026: 6606          BNE.S      $002E
0028: 7000          MOVEQ      #0,D0
002A: 60000618      BRA.W      $0646
002E: 246D99D2      MOVEA.L    -26158(A5),A2
0032: 600C          BRA.S      $0040
0034: 204E          MOVEA.L    A6,A0
0036: D0C6          MOVE.B     D6,(A0)+
0038: D0C6          MOVE.B     D6,(A0)+
003A: 4268FF00      CLR.W      -256(A0)
003E: 528A          MOVE.B     A2,(A1)
0040: 1C12          MOVE.B     (A2),D6
0042: 4886          EXT.W      D6
0044: 4A46          TST.W      D6
0046: 66EC          BNE.S      $0034
0048: 246E000C      MOVEA.L    12(A6),A2
004C: 600C          BRA.S      $005A
004E: 204E          MOVEA.L    A6,A0
0050: D0C6          MOVE.B     D6,(A0)+
0052: D0C6          MOVE.B     D6,(A0)+
0054: 5268FF00      MOVEA.B    -256(A0),A1
0058: 528A          MOVE.B     A2,(A1)
005A: 1C12          MOVE.B     (A2),D6
005C: 4886          EXT.W      D6
005E: 4A46          TST.W      D6
0060: 66EC          BNE.S      $004E
0062: 306EFF7E      MOVEA.W    -130(A6),A0
0066: 2D48FEE2      MOVE.L     A0,-286(A6)
006A: 42AEFECE      CLR.L      -306(A6)
006E: 7A00          MOVEQ      #0,D5
0070: 7001          MOVEQ      #1,D0
0072: 2D40FEBC      MOVE.L     D0,-324(A6)
0076: 1814          MOVE.B     (A4),D4
0078: 4884          EXT.W      D4
007A: 226E0008      MOVEA.L    8(A6),A1
007E: 16290021      MOVE.B     33(A1),D3
0082: 4883          EXT.W      D3
0084: 2449          MOVEA.L    A1,A2
0086: 7211          MOVEQ      #17,D1
0088: C3C4          ANDA.L     D4,A1
008A: 49EDBCFE      LEA        -17154(A5),A4                  ; g_state1
008E: D28C          MOVE.B     A4,(A1)
0090: 2841          MOVEA.L    D1,A4
0092: 7211          MOVEQ      #17,D1
0094: C3C4          ANDA.L     D4,A1
0096: 41ED97B2      LEA        -26702(A5),A0                  ; A5-26702
009A: D288          MOVE.B     A0,(A1)
009C: 2D41FED2      MOVE.L     D1,-302(A6)
00A0: 7411          MOVEQ      #17,D2
00A2: C5C4          ANDA.L     D4,A2
00A4: 41ED9592      LEA        -27246(A5),A0                  ; A5-27246
00A8: D488          MOVE.B     A0,(A2)
00AA: 2D42FED6      MOVE.L     D2,-298(A6)
00AE: 70FF          MOVEQ      #-1,D0
00B0: D044          MOVEA.B    D4,A0
00B2: 3D40FECA      MOVE.W     D0,-310(A6)
00B6: 70FF          MOVEQ      #-1,D0
00B8: D044          MOVEA.B    D4,A0
00BA: C1FC001141ED  ANDA.L     #$001141ED,A0
00C0: BCFE          MOVE.W     ???,(A6)+
00C2: D088          MOVE.B     A0,(A0)
00C4: 2D40FEF2      MOVE.L     D0,-270(A6)
00C8: 7001          MOVEQ      #1,D0
00CA: D044          MOVEA.B    D4,A0
00CC: 3D40FEC6      MOVE.W     D0,-314(A6)
00D0: 7001          MOVEQ      #1,D0
00D2: D044          MOVEA.B    D4,A0
00D4: C1FC001141ED  ANDA.L     #$001141ED,A0
00DA: BCFE          MOVE.W     ???,(A6)+
00DC: D088          MOVE.B     A0,(A0)
00DE: 2D40FEF6      MOVE.L     D0,-266(A6)
00E2: 7022          MOVEQ      #34,D0
00E4: C1C4          ANDA.L     D4,A0
00E6: 41EDBF1E      LEA        -16610(A5),A0                  ; g_state2
00EA: D088          MOVE.B     A0,(A0)
00EC: 2D40FEFA      MOVE.L     D0,-262(A6)
00F0: 3043          MOVEA.W    D3,A0
00F2: D1C82D48      MOVE.B     A0,$2D48.W
00F6: FEEE6000      MOVE.W     24576(A6),(A7)+
00FA: 01F07000      BSET       D0,0(A0,D7.W)
00FE: 1006          MOVE.B     D6,D0
0100: 204D          MOVEA.L    A5,A0
0102: D1C04A28      MOVE.B     D0,$4A28.W
0106: FBD8          MOVE.W     (A0)+,???
0108: 6B04          BMI.S      $010E
010A: 4EAD01A2      JSR        418(A5)                        ; JT[418]
010E: 4A343000      TST.B      0(A4,D3.W)
0112: 660001A2      BNE.W      $02B8
0116: 2F2EFEBC      MOVE.L     -324(A6),-(A7)
011A: 206EFED2      MOVEA.L    -302(A6),A0
011E: 10303000      MOVE.B     0(A0,D3.W),D0
0122: 4880          EXT.W      D0
0124: 3240          MOVEA.W    D0,A1
0126: 2F09          MOVE.L     A1,-(A7)
0128: 4EAD0042      JSR        66(A5)                         ; JT[66]
012C: 2D40FEBC      MOVE.L     D0,-324(A6)
0130: 526DB1D6      MOVEA.B    -20010(A5),A1
0134: 0C6D0008B1D6  CMPI.W     #$0008,-20010(A5)
013A: 6C06          BGE.S      $0142
013C: 4A6DB1D6      TST.W      -20010(A5)
0140: 6E04          BGT.S      $0146
0142: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0146: 47EEFF00      LEA        -256(A6),A3
014A: D6C6          MOVE.B     D6,(A3)+
014C: D6C6          MOVE.B     D6,(A3)+
014E: 4A53          TST.W      (A3)
0150: 6628          BNE.S      $017A
0152: 302EFF7E      MOVE.W     -130(A6),D0
0156: 536EFF7E3040  MOVE.B     -130(A6),12352(A1)
015C: 202EFEE2      MOVE.L     -286(A6),D0
0160: 9088          MOVE.B     A0,(A0)
0162: 204E          MOVEA.L    A6,A0
0164: D1C01146      MOVE.B     D0,$1146.W
0168: FEFE          MOVE.W     ???,(A7)+
016A: 4A6EFF7E      TST.W      -130(A6)
016E: 6C0C          BGE.S      $017C
0170: 2D7CFFFF3CB0FECE  MOVE.L     #$FFFF3CB0,-306(A6)
0178: 6002          BRA.S      $017C
017A: 5353204D      MOVE.B     (A3),8269(A1)
017E: D0C6          MOVE.B     D6,(A0)+
0180: D0C6          MOVE.B     D6,(A0)+
0182: 3D689412FEC4  MOVE.W     -27630(A0),-316(A6)
0188: 206EFED6      MOVEA.L    -298(A6),A0
018C: 10303000      MOVE.B     0(A0,D3.W),D0
0190: 4880          EXT.W      D0
0192: C1EEFEC4      ANDA.L     -316(A6),A0
0196: 3240          MOVEA.W    D0,A1
0198: DA89          MOVE.B     A1,(A5)
019A: 0C440010      CMPI.W     #$0010,D4
019E: 670A          BEQ.S      $01AA
01A0: 206EFEF2      MOVEA.L    -270(A6),A0
01A4: 4A303000      TST.B      0(A0,D3.W)
01A8: 6614          BNE.S      $01BE
01AA: 0C44000F      CMPI.W     #$000F,D4
01AE: 67000134      BEQ.W      $02E6
01B2: 206EFEF6      MOVEA.L    -266(A6),A0
01B6: 4A303000      TST.B      0(A0,D3.W)
01BA: 67000128      BEQ.W      $02E6
01BE: 42AEFEC0      CLR.L      -320(A6)
01C2: 3E2EFECA      MOVE.W     -310(A6),D7
01C6: 48C7          EXT.L      D7
01C8: 266EFEEE      MOVEA.L    -274(A6),A3
01CC: 48780022      PEA        $0022.W
01D0: 2F07          MOVE.L     D7,-(A7)
01D2: 4EAD0042      JSR        66(A5)                         ; JT[66]
01D6: 41EDBF1E      LEA        -16610(A5),A0                  ; g_state2
01DA: D088          MOVE.B     A0,(A0)
01DC: 2D40FEDE      MOVE.L     D0,-290(A6)
01E0: 48780011      PEA        $0011.W
01E4: 2F07          MOVE.L     D7,-(A7)
01E6: 4EAD0042      JSR        66(A5)                         ; JT[66]
01EA: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
01EE: D088          MOVE.B     A0,(A0)
01F0: 2D40FEDA      MOVE.L     D0,-294(A6)
01F4: 601C          BRA.S      $0212
01F6: 204B          MOVEA.L    A3,A0
01F8: D1EEFEDE3010  MOVE.B     -290(A6),$3010.W
01FE: 48C0          EXT.L      D0
0200: D1AEFEC05387  MOVE.B     -320(A6),-121(A0,D5.W*2)
0206: 70DE          MOVEQ      #-34,D0
0208: D1AEFEDE70EF  MOVE.B     -290(A6),-17(A0,D7.W)
020E: D1AEFEDA4A87  MOVE.B     -294(A6),-121(A0,D4.L*2)
0214: 6710          BEQ.S      $0226
0216: 700F          MOVEQ      #15,D0
0218: B087          MOVE.W     D7,(A0)
021A: 670A          BEQ.S      $0226
021C: 206EFEDA      MOVEA.L    -294(A6),A0
0220: 4A303000      TST.B      0(A0,D3.W)
0224: 66D0          BNE.S      $01F6
0226: 3E2EFEC6      MOVE.W     -314(A6),D7
022A: 48C7          EXT.L      D7
022C: 48780022      PEA        $0022.W
0230: 2F07          MOVE.L     D7,-(A7)
0232: 4EAD0042      JSR        66(A5)                         ; JT[66]
0236: 41EDBF1E      LEA        -16610(A5),A0                  ; g_state2
023A: D088          MOVE.B     A0,(A0)
023C: 2D40FEDE      MOVE.L     D0,-290(A6)
0240: 48780011      PEA        $0011.W
0244: 2F07          MOVE.L     D7,-(A7)
0246: 4EAD0042      JSR        66(A5)                         ; JT[66]
024A: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
024E: D088          MOVE.B     A0,(A0)
0250: 2D40FEDA      MOVE.L     D0,-294(A6)
0254: 601C          BRA.S      $0272
0256: 204B          MOVEA.L    A3,A0
0258: D1EEFEDE3010  MOVE.B     -290(A6),$3010.W
025E: 48C0          EXT.L      D0
0260: D1AEFEC05287  MOVE.B     -320(A6),-121(A0,D5.W*2)
0266: 7022          MOVEQ      #34,D0
0268: D1AEFEDE7011  MOVE.B     -290(A6),17(A0,D7.W)
026E: D1AEFEDA701F  MOVE.B     -294(A6),31(A0,D7.W)
0274: B087          MOVE.W     D7,(A0)
0276: 6710          BEQ.S      $0288
0278: 7010          MOVEQ      #16,D0
027A: B087          MOVE.W     D7,(A0)
027C: 670A          BEQ.S      $0288
027E: 206EFEDA      MOVEA.L    -294(A6),A0
0282: 4A303000      TST.B      0(A0,D3.W)
0286: 66CE          BNE.S      $0256
0288: 206EFED2      MOVEA.L    -302(A6),A0
028C: 10303000      MOVE.B     0(A0,D3.W),D0
0290: 4880          EXT.W      D0
0292: 3240          MOVEA.W    D0,A1
0294: 2F09          MOVE.L     A1,-(A7)
0296: 226EFED6      MOVEA.L    -298(A6),A1
029A: 10313000      MOVE.B     0(A1,D3.W),D0
029E: 4880          EXT.W      D0
02A0: C1EEFEC4      ANDA.L     -316(A6),A0
02A4: 48C0          EXT.L      D0
02A6: D0AEFEC0      MOVE.B     -320(A6),(A0)
02AA: 2F00          MOVE.L     D0,-(A7)
02AC: 4EAD0042      JSR        66(A5)                         ; JT[66]
02B0: D1AEFECE602E  MOVE.B     -306(A6),46(A0,D6.W)
02B6: 266EFEEE      MOVEA.L    -274(A6),A3
02BA: 204B          MOVEA.L    A3,A0
02BC: D1EEFEFA4A50  MOVE.B     -262(A6),$4A50.W
02C2: 670C          BEQ.S      $02D0
02C4: 204B          MOVEA.L    A3,A0
02C6: D1EEFEFA3050  MOVE.B     -262(A6),$3050.W
02CC: DA88          MOVE.B     A0,(A5)
02CE: 6014          BRA.S      $02E4
02D0: 3B6DBCF6BCF4  MOVE.W     -17162(A5),-17164(A5)          ; A5-17162
02D6: 3B6DBCFABCF8  MOVE.W     -17158(A5),-17160(A5)          ; A5-17158
02DC: 3B44BCF6      MOVE.W     D4,-17162(A5)
02E0: 3B43BCFA      MOVE.W     D3,-17158(A5)
02E4: 5243          MOVEA.B    D3,A1
02E6: 54AEFEEE      MOVE.B     -274(A6),(A2)
02EA: 1C1A          MOVE.B     (A2)+,D6
02EC: 4886          EXT.W      D6
02EE: 4A46          TST.W      D6
02F0: 6600FE0A      BNE.W      $00FE
02F4: 7001          MOVEQ      #1,D0
02F6: B0AEFEBC      MOVE.W     -324(A6),(A0)
02FA: 672C          BEQ.S      $0328
02FC: 7002          MOVEQ      #2,D0
02FE: B0AEFEBC      MOVE.W     -324(A6),(A0)
0302: 6724          BEQ.S      $0328
0304: 7003          MOVEQ      #3,D0
0306: B0AEFEBC      MOVE.W     -324(A6),(A0)
030A: 671C          BEQ.S      $0328
030C: 7004          MOVEQ      #4,D0
030E: B0AEFEBC      MOVE.W     -324(A6),(A0)
0312: 6714          BEQ.S      $0328
0314: 7009          MOVEQ      #9,D0
0316: B0AEFEBC      MOVE.W     -324(A6),(A0)
031A: 670C          BEQ.S      $0328
031C: 701B          MOVEQ      #27,D0
031E: B0AEFEBC      MOVE.W     -324(A6),(A0)
0322: 6704          BEQ.S      $0328
0324: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0328: 0C6D0007B1D6  CMPI.W     #$0007,-20010(A5)
032E: 6606          BNE.S      $0336
0330: 303C1388      MOVE.W     #$1388,D0
0334: 6002          BRA.S      $0338
0336: 7000          MOVEQ      #0,D0
0338: 2F05          MOVE.L     D5,-(A7)
033A: 2F2EFEBC      MOVE.L     -324(A6),-(A7)
033E: 2200          MOVE.L     D0,D1
0340: 4EAD0042      JSR        66(A5)                         ; JT[66]
0344: C141          AND.W      D0,D1
0346: 3040          MOVEA.W    D0,A0
0348: D288          MOVE.B     A0,(A1)
034A: D3AEFECE306E  MOVE.B     -306(A6),110(A1,D3.W)
0350: FF7EB1EE      MOVE.W     ???,-19986(A7)
0354: FEE2          MOVE.W     -(A2),(A7)+
0356: 670002B2      BEQ.W      $060C
035A: 206E0008      MOVEA.L    8(A6),A0
035E: 16280021      MOVE.B     33(A0),D3
0362: 4883          EXT.W      D3
0364: 3B44BCF4      MOVE.W     D4,-17164(A5)
0368: 203C00007530  MOVE.L     #$00007530,D0
036E: 2D40FEC6      MOVE.L     D0,-314(A6)
0372: 2D40FECA      MOVE.L     D0,-310(A6)
0376: 326EFF7E      MOVEA.W    -130(A6),A1
037A: 222EFEE2      MOVE.L     -286(A6),D1
037E: 9289          MOVE.B     A1,(A1)
0380: 53816600      MOVE.B     D1,0(A1,D6.W*8)
0384: 00AC246E0008102E  ORI.L      #$246E0008,4142(A4)
038C: FEFE          MOVE.W     ???,(A7)+
038E: 4880          EXT.W      D0
0390: 3D40FEE2      MOVE.W     D0,-286(A6)
0394: 6000008C      BRA.W      $0424
0398: BC6EFEE2      MOVEA.W    -286(A6),A6
039C: 66000082      BNE.W      $0422
03A0: 7011          MOVEQ      #17,D0
03A2: C1C4          ANDA.L     D4,A0
03A4: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
03A8: D088          MOVE.B     A0,(A0)
03AA: 3043          MOVEA.W    D3,A0
03AC: 4A300800      TST.B      0(A0,D0.L)
03B0: 666E          BNE.S      $0420
03B2: 2A2EFEBC      MOVE.L     -324(A6),D5
03B6: 0C440010      CMPI.W     #$0010,D4
03BA: 6716          BEQ.S      $03D2
03BC: 70FF          MOVEQ      #-1,D0
03BE: D044          MOVEA.B    D4,A0
03C0: C1FC001141ED  ANDA.L     #$001141ED,A0
03C6: BCFE          MOVE.W     ???,(A6)+
03C8: D088          MOVE.B     A0,(A0)
03CA: 3043          MOVEA.W    D3,A0
03CC: 4A300800      TST.B      0(A0,D0.L)
03D0: 661C          BNE.S      $03EE
03D2: 0C44000F      CMPI.W     #$000F,D4
03D6: 6724          BEQ.S      $03FC
03D8: 7001          MOVEQ      #1,D0
03DA: D044          MOVEA.B    D4,A0
03DC: C1FC001141ED  ANDA.L     #$001141ED,A0
03E2: BCFE          MOVE.W     ???,(A6)+
03E4: D088          MOVE.B     A0,(A0)
03E6: 3043          MOVEA.W    D3,A0
03E8: 4A300800      TST.B      0(A0,D0.L)
03EC: 670E          BEQ.S      $03FC
03EE: 206EFED2      MOVEA.L    -302(A6),A0
03F2: 10303000      MOVE.B     0(A0,D3.W),D0
03F6: 4880          EXT.W      D0
03F8: 3240          MOVEA.W    D0,A1
03FA: DA89          MOVE.B     A1,(A5)
03FC: 206EFED6      MOVEA.L    -298(A6),A0
0400: 10303000      MOVE.B     0(A0,D3.W),D0
0404: 4880          EXT.W      D0
0406: 3240          MOVEA.W    D0,A1
0408: 2F09          MOVE.L     A1,-(A7)
040A: 2F05          MOVE.L     D5,-(A7)
040C: 4EAD0042      JSR        66(A5)                         ; JT[66]
0410: 2A00          MOVE.L     D0,D5
0412: BAAEFECA      MOVE.W     -310(A6),(A5)
0416: 6C08          BGE.S      $0420
0418: 3B43BCF8      MOVE.W     D3,-17160(A5)
041C: 2D45FECA      MOVE.L     D5,-310(A6)
0420: 5243          MOVEA.B    D3,A1
0422: 1C1A          MOVE.B     (A2)+,D6
0424: 4886          EXT.W      D6
0426: 4A46          TST.W      D6
0428: 6600FF6E      BNE.W      $039A
042C: 600001B4      BRA.W      $05E4
0430: 3B44BCF6      MOVE.W     D4,-17162(A5)
0434: 102EFEFE      MOVE.B     -258(A6),D0
0438: B02EFEFF      MOVE.W     -257(A6),D0
043C: 670000C8      BEQ.W      $0508
0440: 246E0008      MOVEA.L    8(A6),A2
0444: 600000B2      BRA.W      $04FA
0448: 4A343000      TST.B      0(A4,D3.W)
044C: 660000A8      BNE.W      $04F8
0450: 102EFEFE      MOVE.B     -258(A6),D0
0454: 4880          EXT.W      D0
0456: B046          MOVEA.W    D6,A0
0458: 670C          BEQ.S      $0466
045A: 102EFEFF      MOVE.B     -257(A6),D0
045E: 4880          EXT.W      D0
0460: B046          MOVEA.W    D6,A0
0462: 66000092      BNE.W      $04F8
0466: 7000          MOVEQ      #0,D0
0468: 1006          MOVE.B     D6,D0
046A: 204D          MOVEA.L    A5,A0
046C: D1C01028      MOVE.B     D0,$1028.W
0470: FBD8          MOVE.W     (A0)+,???
0472: 020000C0      ANDI.B     #$00C0,D0
0476: 6604          BNE.S      $047C
0478: 4EAD01A2      JSR        418(A5)                        ; JT[418]
047C: 2A2EFEBC      MOVE.L     -324(A6),D5
0480: 0C440010      CMPI.W     #$0010,D4
0484: 670A          BEQ.S      $0490
0486: 206EFEF2      MOVEA.L    -270(A6),A0
048A: 4A303000      TST.B      0(A0,D3.W)
048E: 6610          BNE.S      $04A0
0490: 0C44000F      CMPI.W     #$000F,D4
0494: 6718          BEQ.S      $04AE
0496: 206EFEF6      MOVEA.L    -266(A6),A0
049A: 4A303000      TST.B      0(A0,D3.W)
049E: 670E          BEQ.S      $04AE
04A0: 206EFED2      MOVEA.L    -302(A6),A0
04A4: 10303000      MOVE.B     0(A0,D3.W),D0
04A8: 4880          EXT.W      D0
04AA: 3240          MOVEA.W    D0,A1
04AC: DA89          MOVE.B     A1,(A5)
04AE: 206EFED6      MOVEA.L    -298(A6),A0
04B2: 10303000      MOVE.B     0(A0,D3.W),D0
04B6: 4880          EXT.W      D0
04B8: 3240          MOVEA.W    D0,A1
04BA: 2F09          MOVE.L     A1,-(A7)
04BC: 2F05          MOVE.L     D5,-(A7)
04BE: 4EAD0042      JSR        66(A5)                         ; JT[66]
04C2: 2A00          MOVE.L     D0,D5
04C4: 102EFEFE      MOVE.B     -258(A6),D0
04C8: 4880          EXT.W      D0
04CA: B046          MOVEA.W    D6,A0
04CC: 6610          BNE.S      $04DE
04CE: BAAEFECA      MOVE.W     -310(A6),(A5)
04D2: 6C0A          BGE.S      $04DE
04D4: 3B43BCF8      MOVE.W     D3,-17160(A5)
04D8: 2D45FECA      MOVE.L     D5,-310(A6)
04DC: 6018          BRA.S      $04F6
04DE: 102EFEFF      MOVE.B     -257(A6),D0
04E2: 4880          EXT.W      D0
04E4: B046          MOVEA.W    D6,A0
04E6: 660E          BNE.S      $04F6
04E8: BAAEFEC6      MOVE.W     -314(A6),(A5)
04EC: 6C08          BGE.S      $04F6
04EE: 3B43BCFA      MOVE.W     D3,-17158(A5)
04F2: 2D45FEC6      MOVE.L     D5,-314(A6)
04F6: 5243          MOVEA.B    D3,A1
04F8: 1C1A          MOVE.B     (A2)+,D6
04FA: 4886          EXT.W      D6
04FC: 4A46          TST.W      D6
04FE: 6600FF48      BNE.W      $044A
0502: 600000C0      BRA.W      $05C6
0506: 246E0008      MOVEA.L    8(A6),A2
050A: 600000AE      BRA.W      $05BC
050E: 102EFEFE      MOVE.B     -258(A6),D0
0512: 4880          EXT.W      D0
0514: B046          MOVEA.W    D6,A0
0516: 660000A0      BNE.W      $05BA
051A: 7011          MOVEQ      #17,D0
051C: C1C4          ANDA.L     D4,A0
051E: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
0522: D088          MOVE.B     A0,(A0)
0524: 3043          MOVEA.W    D3,A0
0526: 4A300800      TST.B      0(A0,D0.L)
052A: 6600008C      BNE.W      $05BA
052E: 2A2EFEBC      MOVE.L     -324(A6),D5
0532: 0C440010      CMPI.W     #$0010,D4
0536: 6716          BEQ.S      $054E
0538: 70FF          MOVEQ      #-1,D0
053A: D044          MOVEA.B    D4,A0
053C: C1FC001141ED  ANDA.L     #$001141ED,A0
0542: BCFE          MOVE.W     ???,(A6)+
0544: D088          MOVE.B     A0,(A0)
0546: 3043          MOVEA.W    D3,A0
0548: 4A300800      TST.B      0(A0,D0.L)
054C: 661C          BNE.S      $056A
054E: 0C44000F      CMPI.W     #$000F,D4
0552: 6724          BEQ.S      $0578
0554: 7001          MOVEQ      #1,D0
0556: D044          MOVEA.B    D4,A0
0558: C1FC001141ED  ANDA.L     #$001141ED,A0
055E: BCFE          MOVE.W     ???,(A6)+
0560: D088          MOVE.B     A0,(A0)
0562: 3043          MOVEA.W    D3,A0
0564: 4A300800      TST.B      0(A0,D0.L)
0568: 670E          BEQ.S      $0578
056A: 206EFED2      MOVEA.L    -302(A6),A0
056E: 10303000      MOVE.B     0(A0,D3.W),D0
0572: 4880          EXT.W      D0
0574: 3240          MOVEA.W    D0,A1
0576: DA89          MOVE.B     A1,(A5)
0578: 206EFED6      MOVEA.L    -298(A6),A0
057C: 10303000      MOVE.B     0(A0,D3.W),D0
0580: 4880          EXT.W      D0
0582: 3240          MOVEA.W    D0,A1
0584: 2F09          MOVE.L     A1,-(A7)
0586: 2F05          MOVE.L     D5,-(A7)
0588: 4EAD0042      JSR        66(A5)                         ; JT[66]
058C: 2A00          MOVE.L     D0,D5
058E: BAAEFEC6      MOVE.W     -314(A6),(A5)
0592: 6C24          BGE.S      $05B8
0594: BAAEFECA      MOVE.W     -310(A6),(A5)
0598: 6C16          BGE.S      $05B0
059A: 3B6DBCF8BCFA  MOVE.W     -17160(A5),-17158(A5)          ; A5-17160
05A0: 2D6EFECAFEC6  MOVE.L     -310(A6),-314(A6)
05A6: 3B43BCF8      MOVE.W     D3,-17160(A5)
05AA: 2D45FECA      MOVE.L     D5,-310(A6)
05AE: 6008          BRA.S      $05B8
05B0: 3B43BCFA      MOVE.W     D3,-17158(A5)
05B4: 2D45FEC6      MOVE.L     D5,-314(A6)
05B8: 5243          MOVEA.B    D3,A1
05BA: 1C1A          MOVE.B     (A2)+,D6
05BC: 4886          EXT.W      D6
05BE: 4A46          TST.W      D6
05C0: 6600FF4C      BNE.W      $0510
05C4: 2F2EFEC6      MOVE.L     -314(A6),-(A7)
05C8: 102EFEFF      MOVE.B     -257(A6),D0
05CC: 4880          EXT.W      D0
05CE: 204D          MOVEA.L    A5,A0
05D0: D0C0          MOVE.B     D0,(A0)+
05D2: D0C0          MOVE.B     D0,(A0)+
05D4: 30689412      MOVEA.W    -27630(A0),A0
05D8: 2F08          MOVE.L     A0,-(A7)
05DA: 4EAD0042      JSR        66(A5)                         ; JT[66]
05DE: 91AEFECE2F2E  MOVE.B     -306(A6),46(A0,D2.L*8)
05E4: FECA          MOVE.W     A2,(A7)+
05E6: 102EFEFE      MOVE.B     -258(A6),D0
05EA: 4880          EXT.W      D0
05EC: 204D          MOVEA.L    A5,A0
05EE: D0C0          MOVE.B     D0,(A0)+
05F0: D0C0          MOVE.B     D0,(A0)+
05F2: 30689412      MOVEA.W    -27630(A0),A0
05F6: 2F08          MOVE.L     A0,-(A7)
05F8: 4EAD0042      JSR        66(A5)                         ; JT[66]
05FC: 91AEFECE4AAE  MOVE.B     -306(A6),-82(A0,D4.L*2)
0602: FECE          MOVE.W     A6,(A7)+
0604: 6C04          BGE.S      $060A
0606: 4EAD01A2      JSR        418(A5)                        ; JT[418]
060A: 246D99D2      MOVEA.L    -26158(A5),A2
060E: 6022          BRA.S      $0632
0610: 204E          MOVEA.L    A6,A0
0612: D0C6          MOVE.B     D6,(A0)+
0614: D0C6          MOVE.B     D6,(A0)+
0616: 3A28FF00      MOVE.W     -256(A0),D5
061A: 48C5          EXT.L      D5
061C: 7E00          MOVEQ      #0,D7
061E: 600C          BRA.S      $062C
0620: 206E0010      MOVEA.L    16(A6),A0
0624: 1086          MOVE.B     D6,(A0)
0626: 5287          MOVE.B     D7,(A1)
0628: 52AE0010      MOVE.B     16(A6),(A1)
062C: BA87          MOVE.W     D7,(A5)
062E: 6EF0          BGT.S      $0620
0630: 528A          MOVE.B     A2,(A1)
0632: 1C12          MOVE.B     (A2),D6
0634: 4886          EXT.W      D6
0636: 4A46          TST.W      D6
0638: 66D6          BNE.S      $0610
063A: 206E0010      MOVEA.L    16(A6),A0
063E: 4210          CLR.B      (A0)
0640: 202EFECE      MOVE.L     -306(A6),D0
0644: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0648: 4E5E          UNLK       A6
064A: 4E75          RTS        


; ======= Function at 0x064C =======
064C: 4E560000      LINK       A6,#0
0650: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
0654: 3F2E0008      MOVE.W     8(A6),-(A7)
0658: 4EBA0162      JSR        354(PC)
065C: 7E00          MOVEQ      #0,D7
065E: 49EDF558      LEA        -2728(A5),A4                   ; A5-2728
0662: 47EDCDFC      LEA        -12804(A5),A3                  ; A5-12804
0666: 2007          MOVE.L     D7,D0
0668: 48C0          EXT.L      D0
066A: E58845ED      MOVE.L     A0,-19(A2,D4.W*4)
066E: 99D6D08A      MOVE.B     (A6),#$8A
0672: 2440          MOVEA.L    D0,A2
0674: 548F          MOVE.B     A7,(A2)
0676: 6012          BRA.S      $068A
0678: 302E0008      MOVE.W     8(A6),D0
067C: 48C0          EXT.L      D0
067E: C092          AND.L      (A2),D0
0680: 6702          BEQ.S      $0684
0682: 18D3          MOVE.B     (A3),(A4)+
0684: 528B          MOVE.B     A3,(A1)
0686: 5247          MOVEA.B    D7,A1
0688: 588A          MOVE.B     A2,(A4)
068A: 4A13          TST.B      (A3)
068C: 66EA          BNE.S      $0678
068E: 4214          CLR.B      (A4)
0690: 41EDF558      LEA        -2728(A5),A0                   ; A5-2728
0694: 2008          MOVE.L     A0,D0
0696: 4CDF1C80      MOVEM.L    (SP)+,D7/A2/A3/A4              ; restore
069A: 4E5E          UNLK       A6
069C: 4E75          RTS        


; ======= Function at 0x069E =======
069E: 4E56FFFC      LINK       A6,#-4                         ; frame=4
06A2: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
06A6: 3E2E0010      MOVE.W     16(A6),D7
06AA: 3C2E0012      MOVE.W     18(A6),D6
06AE: 7011          MOVEQ      #17,D0
06B0: C1C7          ANDA.L     D7,A0
06B2: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
06B6: D088          MOVE.B     A0,(A0)
06B8: 3046          MOVEA.W    D6,A0
06BA: 4A300800      TST.B      0(A0,D0.L)
06BE: 6704          BEQ.S      $06C4
06C0: 4EAD01A2      JSR        418(A5)                        ; JT[418]
06C4: 0C470010      CMPI.W     #$0010,D7
06C8: 6716          BEQ.S      $06E0
06CA: 70FF          MOVEQ      #-1,D0
06CC: D047          MOVEA.B    D7,A0
06CE: C1FC001141ED  ANDA.L     #$001141ED,A0
06D4: BCFE          MOVE.W     ???,(A6)+
06D6: D088          MOVE.B     A0,(A0)
06D8: 3046          MOVEA.W    D6,A0
06DA: 4A300800      TST.B      0(A0,D0.L)
06DE: 6620          BNE.S      $0700
06E0: 0C47000F      CMPI.W     #$000F,D7
06E4: 6716          BEQ.S      $06FC
06E6: 7001          MOVEQ      #1,D0
06E8: D047          MOVEA.B    D7,A0
06EA: C1FC001141ED  ANDA.L     #$001141ED,A0
06F0: BCFE          MOVE.W     ???,(A6)+
06F2: D088          MOVE.B     A0,(A0)
06F4: 3046          MOVEA.W    D6,A0
06F6: 4A300800      TST.B      0(A0,D0.L)
06FA: 6604          BNE.S      $0700
06FC: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0700: 486EFFFC      PEA        -4(A6)
0704: 486EFFFE      PEA        -2(A6)
0708: 3F06          MOVE.W     D6,-(A7)
070A: 3F07          MOVE.W     D7,-(A7)
070C: 4EAD0922      JSR        2338(A5)                       ; JT[2338]
0710: 7011          MOVEQ      #17,D0
0712: C1EEFFFE      ANDA.L     -2(A6),A0
0716: 49EDBCFE      LEA        -17154(A5),A4                  ; g_state1
071A: D08C          MOVE.B     A4,(A0)
071C: 2840          MOVEA.L    D0,A4
071E: 47ECFFFF      LEA        -1(A4),A3
0722: D6EEFFFC      MOVE.B     -4(A6),(A3)+
0726: 4FEF000C      LEA        12(A7),A7
072A: 6002          BRA.S      $072E
072C: 538B4A13      MOVE.B     A3,19(A1,D4.L*2)
0730: 66FA          BNE.S      $072C
0732: 528B          MOVE.B     A3,(A1)
0734: 306EFFFC      MOVEA.W    -4(A6),A0
0738: D1CCB1CB      MOVE.B     A4,$B1CB.W
073C: 6604          BNE.S      $0742
073E: 4A13          TST.B      (A3)
0740: 670E          BEQ.S      $0750
0742: 4A13          TST.B      (A3)
0744: 6706          BEQ.S      $074C
0746: 4A2BFFFF      TST.B      -1(A3)
074A: 6704          BEQ.S      $0750
074C: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0750: 286E000C      MOVEA.L    12(A6),A4
0754: 6042          BRA.S      $0798
0756: 206E0008      MOVEA.L    8(A6),A0
075A: D0C7          MOVE.B     D7,(A0)+
075C: 4A707000      TST.W      0(A0,D7.W)
0760: 6734          BEQ.S      $0796
0762: 7011          MOVEQ      #17,D0
0764: C1EEFFFE      ANDA.L     -2(A6),A0
0768: D08D          MOVE.B     A5,(A0)
076A: 306EFFFC      MOVEA.W    -4(A6),A0
076E: D1C01147      MOVE.B     D0,$1147.W
0772: BCFE          MOVE.W     ???,(A6)+
0774: 2F0B          MOVE.L     A3,-(A7)
0776: 4EAD031A      JSR        794(A5)                        ; JT[794]
077A: 4A80          TST.L      D0
077C: 588F          MOVE.B     A7,(A4)
077E: 6716          BEQ.S      $0796
0780: 7011          MOVEQ      #17,D0
0782: C1EEFFFE      ANDA.L     -2(A6),A0
0786: D08D          MOVE.B     A5,(A0)
0788: 306EFFFC      MOVEA.W    -4(A6),A0
078C: D1C04228      MOVE.B     D0,$4228.W
0790: BCFE          MOVE.W     ???,(A6)+
0792: 7001          MOVEQ      #1,D0
0794: 601E          BRA.S      $07B4
0796: 528C          MOVE.B     A4,(A1)
0798: 1E14          MOVE.B     (A4),D7
079A: 4887          EXT.W      D7
079C: 4A47          TST.W      D7
079E: 66B6          BNE.S      $0756
07A0: 7011          MOVEQ      #17,D0
07A2: C1EEFFFE      ANDA.L     -2(A6),A0
07A6: D08D          MOVE.B     A5,(A0)
07A8: 306EFFFC      MOVEA.W    -4(A6),A0
07AC: D1C04228      MOVE.B     D0,$4228.W
07B0: BCFE          MOVE.W     ???,(A6)+
07B2: 7000          MOVEQ      #0,D0
07B4: 4CDF18C0      MOVEM.L    (SP)+,D6/D7/A3/A4              ; restore
07B8: 4E5E          UNLK       A6
07BA: 4E75          RTS        


; ======= Function at 0x07BC =======
07BC: 4E560000      LINK       A6,#0
07C0: 3F2E0008      MOVE.W     8(A6),-(A7)
07C4: 4EBA0010      JSR        16(PC)
07C8: 4A40          TST.W      D0
07CA: 548F          MOVE.B     A7,(A2)
07CC: 6604          BNE.S      $07D2
07CE: 4EAD01A2      JSR        418(A5)                        ; JT[418]
07D2: 4E5E          UNLK       A6
07D4: 4E75          RTS        


; ======= Function at 0x07D6 =======
07D6: 4E560000      LINK       A6,#0
07DA: 48E70F00      MOVEM.L    D4/D5/D6/D7,-(SP)              ; save
07DE: 7E00          MOVEQ      #0,D7
07E0: 7CFF          MOVEQ      #-1,D6
07E2: DC6DCCFA      MOVEA.B    -13062(A5),A6
07E6: 602A          BRA.S      $0812
07E8: 3A07          MOVE.W     D7,D5
07EA: DA46          MOVEA.B    D6,A5
07EC: E245          MOVEA.L    D5,A1
07EE: 204D          MOVEA.L    A5,A0
07F0: D0C5          MOVE.B     D5,(A0)+
07F2: D0C5          MOVE.B     D5,(A0)+
07F4: 3828CCFC      MOVE.W     -13060(A0),D4
07F8: B86E0008      MOVEA.W    8(A6),A4
07FC: 6604          BNE.S      $0802
07FE: 7001          MOVEQ      #1,D0
0800: 6016          BRA.S      $0818
0802: B86E0008      MOVEA.W    8(A6),A4
0806: 6F06          BLE.S      $080E
0808: 7E01          MOVEQ      #1,D7
080A: DE45          MOVEA.B    D5,A7
080C: 6004          BRA.S      $0812
080E: 7CFF          MOVEQ      #-1,D6
0810: DC45          MOVEA.B    D5,A6
0812: BE46          MOVEA.W    D6,A7
0814: 6FD2          BLE.S      $07E8
0816: 7000          MOVEQ      #0,D0
0818: 4CDF00F0      MOVEM.L    (SP)+,D4/D5/D6/D7              ; restore
081C: 4E5E          UNLK       A6
081E: 4E75          RTS        

0820: 48E70738      MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)        ; save
0824: 486DCDFC      PEA        -12804(A5)                     ; A5-12804
0828: 4EAD0952      JSR        2386(A5)                       ; JT[2386]
082C: 486DCDFC      PEA        -12804(A5)                     ; A5-12804
0830: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0834: 7211          MOVEQ      #17,D1
0836: B280          MOVE.W     D0,(A1)
0838: 508F          MOVE.B     A7,(A0)
083A: 6204          BHI.S      $0840
083C: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0840: 486DCDFC      PEA        -12804(A5)                     ; A5-12804
0844: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0848: 204D          MOVEA.L    A5,A0
084A: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
084E: 7EFF          MOVEQ      #-1,D7
0850: DEA899D6      MOVE.B     -26154(A0),(A7)
0854: 707F          MOVEQ      #127,D0
0856: B087          MOVE.W     D7,(A0)
0858: 588F          MOVE.B     A7,(A4)
085A: 6302          BLS.S      $085E
085C: 7E7F          MOVEQ      #127,D7
085E: 49EDCDFC      LEA        -12804(A5),A4                  ; A5-12804
0862: 47ED99D6      LEA        -26154(A5),A3                  ; A5-26154
0866: 6042          BRA.S      $08AA
0868: 41EDCDFC      LEA        -12804(A5),A0                  ; A5-12804
086C: B1CC670A      MOVE.W     A4,$670A.W
0870: 102CFFFF      MOVE.B     -1(A4),D0
0874: 4880          EXT.W      D0
0876: B046          MOVEA.W    D6,A0
0878: 6704          BEQ.S      $087E
087A: 7A00          MOVEQ      #0,D5
087C: 6002          BRA.S      $0880
087E: 5245          MOVEA.B    D5,A1
0880: 2006          MOVE.L     D6,D0
0882: 48C0          EXT.L      D0
0884: E98845ED      MOVE.L     A0,-19(A4,D4.W*4)
0888: B3F4D08A3445D5CA  MOVE.W     -118(A4,A5.W),$3445D5CA
0890: D08A          MOVE.B     A2,(A0)
0892: 2440          MOVEA.L    D0,A2
0894: 302B0002      MOVE.W     2(A3),D0
0898: 4640          NOT.W      D0
089A: C047          AND.W      D7,D0
089C: 3480          MOVE.W     D0,(A2)
089E: 4A52          TST.W      (A2)
08A0: 6604          BNE.S      $08A6
08A2: 4EAD01A2      JSR        418(A5)                        ; JT[418]
08A6: 588B          MOVE.B     A3,(A4)
08A8: 528C          MOVE.B     A4,(A1)
08AA: 1C14          MOVE.B     (A4),D6
08AC: 4886          EXT.W      D6
08AE: 4A46          TST.W      D6
08B0: 66B6          BNE.S      $0868
08B2: 4CDF1CE0      MOVEM.L    (SP)+,D5/D6/D7/A2/A3/A4        ; restore
08B6: 4E75          RTS        


; ======= Function at 0x08B8 =======
08B8: 4E56FF78      LINK       A6,#-136                       ; frame=136
08BC: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
08C0: 2E2E000C      MOVE.L     12(A6),D7
08C4: 286E0010      MOVEA.L    16(A6),A4
08C8: 52ADB1DC      MOVE.B     -20004(A5),(A1)                ; A5-20004
08CC: 2B6DB1DCB1D8  MOVE.L     -20004(A5),-20008(A5)          ; A5-20004
08D2: 48780100      PEA        $0100.W
08D6: 486DBBF4      PEA        -17420(A5)                     ; A5-17420
08DA: 4EAD01AA      JSR        426(A5)                        ; JT[426]
08DE: 48780100      PEA        $0100.W
08E2: 486DCCFC      PEA        -13060(A5)                     ; A5-13060
08E6: 4EAD01AA      JSR        426(A5)                        ; JT[426]
08EA: 426DCCFA      CLR.W      -13062(A5)
08EE: 4EBAFF30      JSR        -208(PC)
08F2: 486DCE04      PEA        -12796(A5)                     ; A5-12796
08F6: 4EAD095A      JSR        2394(A5)                       ; JT[2394]
08FA: 3B40CF06      MOVE.W     D0,-12538(A5)
08FE: 422EFF7D      CLR.B      -131(A6)
0902: 2047          MOVEA.L    D7,A0
0904: 4250          CLR.W      (A0)
0906: 206E0008      MOVEA.L    8(A6),A0
090A: 4290          CLR.L      (A0)
090C: 266D99D2      MOVEA.L    -26158(A5),A3
0910: 4FEF0014      LEA        20(A7),A7
0914: 6052          BRA.S      $0968
0916: 1D46FF7C      MOVE.B     D6,-132(A6)
091A: 4A46          TST.W      D6
091C: 6D10          BLT.S      $092E
091E: 0C460080      CMPI.W     #$0080,D6
0922: 640A          BCC.S      $092E
0924: 204D          MOVEA.L    A5,A0
0926: D0C6          MOVE.B     D6,(A0)+
0928: 4A28CE04      TST.B      -12796(A0)
092C: 6C04          BGE.S      $0932
092E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0932: 45EDCE04      LEA        -12796(A5),A2                  ; A5-12796
0936: D4C6          MOVE.B     D6,(A2)+
0938: 1012          MOVE.B     (A2),D0
093A: 4880          EXT.W      D0
093C: 204D          MOVEA.L    A5,A0
093E: D0C6          MOVE.B     D6,(A0)+
0940: D0C6          MOVE.B     D6,(A0)+
0942: C1E89412      ANDA.L     -27630(A0),A0
0946: 2047          MOVEA.L    D7,A0
0948: D150486E      MOVE.B     (A0),18542(A0)
094C: FF78486EFF7C  MOVE.W     $486E.W,-132(A7)
0952: 4EBA0D68      JSR        3432(PC)
0956: 1212          MOVE.B     (A2),D1
0958: 4881          EXT.W      D1
095A: C3C0          ANDA.L     D0,A1
095C: 48C1          EXT.L      D1
095E: 206E0008      MOVEA.L    8(A6),A0
0962: D390508F      MOVE.B     (A0),-113(A1,D5.W)
0966: 528B          MOVE.B     A3,(A1)
0968: 1C13          MOVE.B     (A3),D6
096A: 4886          EXT.W      D6
096C: 4A46          TST.W      D6
096E: 66A6          BNE.S      $0916
0970: 2047          MOVEA.L    D7,A0
0972: 4A50          TST.W      (A0)
0974: 6C04          BGE.S      $097A
0976: 4EAD01A2      JSR        418(A5)                        ; JT[418]
097A: 102DCE65      MOVE.B     -12699(A5),D0                  ; A5-12699
097E: 4880          EXT.W      D0
0980: 122DCE69      MOVE.B     -12695(A5),D1                  ; A5-12695
0984: 4881          EXT.W      D1
0986: D041          MOVEA.B    D1,A0
0988: 122DCE6D      MOVE.B     -12691(A5),D1                  ; A5-12691
098C: 4881          EXT.W      D1
098E: D041          MOVEA.B    D1,A0
0990: 122DCE73      MOVE.B     -12685(A5),D1                  ; A5-12685
0994: 4881          EXT.W      D1
0996: D041          MOVEA.B    D1,A0
0998: 122DCE79      MOVE.B     -12679(A5),D1                  ; A5-12679
099C: 4881          EXT.W      D1
099E: D041          MOVEA.B    D1,A0
09A0: 3880          MOVE.W     D0,(A4)
09A2: 322DCF06      MOVE.W     -12538(A5),D1                  ; A5-12538
09A6: 9240          MOVEA.B    D0,A1
09A8: 206E0014      MOVEA.L    20(A6),A0
09AC: 3081          MOVE.W     D1,(A0)
09AE: 700A          MOVEQ      #10,D0
09B0: C1D4          ANDA.L     (A4),A0
09B2: 322DCF06      MOVE.W     -12538(A5),D1                  ; A5-12538
09B6: E549B240      MOVE.L     A1,-19904(A2)
09BA: 6F14          BLE.S      $09D0
09BC: 102DCE43      MOVE.B     -12733(A5),D0                  ; A5-12733
09C0: 4880          EXT.W      D0
09C2: D154102D      MOVE.B     (A4),4141(A0)
09C6: CE43          AND.W      D3,D7
09C8: 4880          EXT.W      D0
09CA: 206E0014      MOVEA.L    20(A6),A0
09CE: 91504CDF      MOVE.B     (A0),19679(A0)
09D2: 1CC0          MOVE.B     D0,(A6)+
09D4: 4E5E          UNLK       A6
09D6: 4E75          RTS        


; ======= Function at 0x09D8 =======
09D8: 4E56FFD8      LINK       A6,#-40                        ; frame=40
09DC: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
09E0: 486EFFEA      PEA        -22(A6)
09E4: 486EFFEC      PEA        -20(A6)
09E8: 486EFFEE      PEA        -18(A6)
09EC: 486EFFE6      PEA        -26(A6)
09F0: 4EBAFEC6      JSR        -314(PC)
09F4: 486EFFE2      PEA        -30(A6)
09F8: 2F2D93BC      MOVE.L     -27716(A5),-(A7)               ; A5-27716
09FC: 4EBA0CBE      JSR        3262(PC)
0A00: 122DCE75      MOVE.B     -12683(A5),D1                  ; A5-12683
0A04: 4881          EXT.W      D1
0A06: C3C0          ANDA.L     D0,A1
0A08: 48C1          EXT.L      D1
0A0A: 93AEFFE67C7F  MOVE.B     -26(A6),127(A1,D7.L*4)
0A10: 49EDBCF2      LEA        -17166(A5),A4                  ; A5-17166
0A14: 41EDCCF8      LEA        -13064(A5),A0                  ; A5-13064
0A18: 2E08          MOVE.L     A0,D7
0A1A: 4FEF0018      LEA        24(A7),A7
0A1E: 600001CE      BRA.W      $0BF0
0A22: 426EFFE0      CLR.W      -32(A6)
0A26: 426EFFDE      CLR.W      -34(A6)
0A2A: 426EFFDC      CLR.W      -36(A6)
0A2E: 47EDCDFC      LEA        -12804(A5),A3                  ; A5-12804
0A32: 45EEFFF0      LEA        -16(A6),A2
0A36: 7800          MOVEQ      #0,D4
0A38: 41ED99D6      LEA        -26154(A5),A0                  ; A5-26154
0A3C: 2D48FFD8      MOVE.L     A0,-40(A6)
0A40: 6056          BRA.S      $0A98
0A42: 206EFFD8      MOVEA.L    -40(A6),A0
0A46: 2006          MOVE.L     D6,D0
0A48: 48C0          EXT.L      D0
0A4A: C090          AND.L      (A0),D0
0A4C: 6742          BEQ.S      $0A90
0A4E: 14C5          MOVE.B     D5,(A2)+
0A50: 3F05          MOVE.W     D5,-(A7)
0A52: 4EAD07D2      JSR        2002(A5)                       ; JT[2002]
0A56: 4A40          TST.W      D0
0A58: 548F          MOVE.B     A7,(A2)
0A5A: 6706          BEQ.S      $0A62
0A5C: 526EFFDC      MOVEA.B    -36(A6),A1
0A60: 6010          BRA.S      $0A72
0A62: 0C45003F      CMPI.W     #$003F,D5
0A66: 6706          BEQ.S      $0A6E
0A68: 526EFFDE      MOVEA.B    -34(A6),A1
0A6C: 6004          BRA.S      $0A72
0A6E: 526EFFE0      MOVEA.B    -32(A6),A1
0A72: 102B0001      MOVE.B     1(A3),D0
0A76: 4880          EXT.W      D0
0A78: B045          MOVEA.W    D5,A0
0A7A: 6614          BNE.S      $0A90
0A7C: 204D          MOVEA.L    A5,A0
0A7E: 2004          MOVE.L     D4,D0
0A80: 48C0          EXT.L      D0
0A82: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0A86: 2006          MOVE.L     D6,D0
0A88: 48C0          EXT.L      D0
0A8A: C0A899DA      AND.L      -26150(A0),D0
0A8E: 6710          BEQ.S      $0AA0
0A90: 5244          MOVEA.B    D4,A1
0A92: 58AEFFD8      MOVE.B     -40(A6),(A4)
0A96: 528B          MOVE.B     A3,(A1)
0A98: 1A13          MOVE.B     (A3),D5
0A9A: 4885          EXT.W      D5
0A9C: 4A45          TST.W      D5
0A9E: 66A2          BNE.S      $0A42
0AA0: 4A45          TST.W      D5
0AA2: 66000144      BNE.W      $0BEA
0AA6: 4212          CLR.B      (A2)
0AA8: 302DCCFA      MOVE.W     -13062(A5),D0                  ; A5-13062
0AAC: 526DCCFA      MOVEA.B    -13062(A5),A1
0AB0: 204D          MOVEA.L    A5,A0
0AB2: D0C0          MOVE.B     D0,(A0)+
0AB4: D0C0          MOVE.B     D0,(A0)+
0AB6: 3146CCFC      MOVE.W     D6,-13060(A0)
0ABA: 2047          MOVEA.L    D7,A0
0ABC: 4250          CLR.W      (A0)
0ABE: 45EEFFF0      LEA        -16(A6),A2
0AC2: 6010          BRA.S      $0AD4
0AC4: 204D          MOVEA.L    A5,A0
0AC6: D0C5          MOVE.B     D5,(A0)+
0AC8: D0C5          MOVE.B     D5,(A0)+
0ACA: 30289412      MOVE.W     -27630(A0),D0
0ACE: 2047          MOVEA.L    D7,A0
0AD0: D150528A      MOVE.B     (A0),21130(A0)
0AD4: 1A12          MOVE.B     (A2),D5
0AD6: 4885          EXT.W      D5
0AD8: 4A45          TST.W      D5
0ADA: 66E8          BNE.S      $0AC4
0ADC: 486EFFF0      PEA        -16(A6)
0AE0: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0AE4: 7807          MOVEQ      #7,D4
0AE6: 9840          MOVEA.B    D0,A4
0AE8: 76F9          MOVEQ      #-7,D3
0AEA: D66DCF06      MOVEA.B    -12538(A5),A3
0AEE: B644          MOVEA.W    D4,A3
0AF0: 588F          MOVE.B     A7,(A4)
0AF2: 6C04          BGE.S      $0AF8
0AF4: 3003          MOVE.W     D3,D0
0AF6: 6002          BRA.S      $0AFA
0AF8: 3004          MOVE.W     D4,D0
0AFA: 3800          MOVE.W     D0,D4
0AFC: 486EFFE2      PEA        -30(A6)
0B00: 486EFFF0      PEA        -16(A6)
0B04: 4EBA0B42      JSR        2882(PC)
0B08: 3600          MOVE.W     D0,D3
0B0A: 508F          MOVE.B     A7,(A0)
0B0C: 670000A2      BEQ.W      $0BB2
0B10: 206EFFE2      MOVEA.L    -30(A6),A0
0B14: 2010          MOVE.L     (A0),D0
0B16: B0ADB1D8      MOVE.W     -20008(A5),(A0)                ; A5-20008
0B1A: 6E000094      BGT.W      $0BB2
0B1E: 3F3C0071      MOVE.W     #$0071,-(A7)
0B22: 486EFFF0      PEA        -16(A6)
0B26: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
0B2A: 4A80          TST.L      D0
0B2C: 5C8F          MOVE.B     A7,(A6)
0B2E: 6738          BEQ.S      $0B68
0B30: 2F2D93BC      MOVE.L     -27716(A5),-(A7)               ; A5-27716
0B34: 486EFFF0      PEA        -16(A6)
0B38: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
0B3C: 4A40          TST.W      D0
0B3E: 508F          MOVE.B     A7,(A0)
0B40: 6622          BNE.S      $0B64
0B42: 306DCF06      MOVEA.W    -12538(A5),A0
0B46: 2F08          MOVE.L     A0,-(A7)
0B48: 306DCF06      MOVEA.W    -12538(A5),A0
0B4C: 202EFFE6      MOVE.L     -26(A6),D0
0B50: 9088          MOVE.B     A0,(A0)
0B52: 2F00          MOVE.L     D0,-(A7)
0B54: 4EAD005A      JSR        90(A5)                         ; JT[90]
0B58: 3600          MOVE.W     D0,D3
0B5A: 0C43FF9C      CMPI.W     #$FF9C,D3
0B5E: 6F3A          BLE.S      $0B9A
0B60: 769C          MOVEQ      #-100,D3
0B62: 6036          BRA.S      $0B9A
0B64: 7600          MOVEQ      #0,D3
0B66: 6032          BRA.S      $0B9A
0B68: 486DF684      PEA        -2428(A5)                      ; A5-2428
0B6C: 486EFFF0      PEA        -16(A6)
0B70: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
0B74: 4A40          TST.W      D0
0B76: 508F          MOVE.B     A7,(A0)
0B78: 6620          BNE.S      $0B9A
0B7A: 4A2DCE75      TST.B      -12683(A5)
0B7E: 671A          BEQ.S      $0B9A
0B80: 4A2DCE79      TST.B      -12679(A5)
0B84: 6614          BNE.S      $0B9A
0B86: 486EFFE2      PEA        -30(A6)
0B8A: 2F2D93C0      MOVE.L     -27712(A5),-(A7)               ; A5-27712
0B8E: 4EBA0B2C      JSR        2860(PC)
0B92: 06400258      ADDI.W     #$0258,D0
0B96: 3600          MOVE.W     D0,D3
0B98: 508F          MOVE.B     A7,(A0)
0B9A: 52ADB1DC      MOVE.B     -20004(A5),(A1)                ; A5-20004
0B9E: 206EFFE2      MOVEA.L    -30(A6),A0
0BA2: 20ADB1DC      MOVE.L     -20004(A5),(A0)                ; A5-20004
0BA6: 3F03          MOVE.W     D3,-(A7)
0BA8: 3F06          MOVE.W     D6,-(A7)
0BAA: 4EBA0D34      JSR        3380(PC)
0BAE: 588F          MOVE.B     A7,(A4)
0BB0: 3F04          MOVE.W     D4,-(A7)
0BB2: 3F2EFFEA      MOVE.W     -22(A6),-(A7)
0BB6: 3F2EFFEC      MOVE.W     -20(A6),-(A7)
0BBA: 3F2EFFE0      MOVE.W     -32(A6),-(A7)
0BBE: 3F2EFFDE      MOVE.W     -34(A6),-(A7)
0BC2: 3F2EFFDC      MOVE.W     -36(A6),-(A7)
0BC6: 4EBA00F8      JSR        248(PC)
0BCA: D154306D      MOVE.B     (A4),12397(A0)
0BCE: CF06          AND.B      D7,D6
0BD0: 2E88          MOVE.L     A0,(A7)
0BD2: 3044          MOVEA.W    D4,A0
0BD4: 2F08          MOVE.L     A0,-(A7)
0BD6: 2F2EFFE6      MOVE.L     -26(A6),-(A7)
0BDA: 4EAD0042      JSR        66(A5)                         ; JT[66]
0BDE: 2F00          MOVE.L     D0,-(A7)
0BE0: 4EAD005A      JSR        90(A5)                         ; JT[90]
0BE4: D154508F      MOVE.B     (A4),20623(A0)
0BE8: 5346558C      MOVE.B     D6,21900(A1)
0BEC: 55874A46      MOVE.B     D7,70(A2,D4.L*2)
0BF0: 6C00FE30      BGE.W      $0A24
0BF4: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0BF8: 4E5E          UNLK       A6
0BFA: 4E75          RTS        


; ======= Function at 0x0BFC =======
0BFC: 4E56FFFA      LINK       A6,#-6                         ; frame=6
0C00: 48E71F08      MOVEM.L    D3/D4/D5/D6/D7/A4,-(SP)        ; save
0C04: 3C2E0008      MOVE.W     8(A6),D6
0C08: 3A2E000A      MOVE.W     10(A6),D5
0C0C: 382E000C      MOVE.W     12(A6),D4
0C10: 3E2E000E      MOVE.W     14(A6),D7
0C14: 4A6E0010      TST.W      16(A6)
0C18: 6C04          BGE.S      $0C1E
0C1A: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0C1E: 3006          MOVE.W     D6,D0
0C20: D045          MOVEA.B    D5,A0
0C22: D06E0010      MOVEA.B    16(A6),A0
0C26: 5F406F0A      MOVE.B     D0,28426(A7)
0C2A: 7007          MOVEQ      #7,D0
0C2C: 9046          MOVEA.B    D6,A0
0C2E: 9045          MOVEA.B    D5,A0
0C30: 3D400010      MOVE.W     D0,16(A6)
0C34: 4A45          TST.W      D5
0C36: 6608          BNE.S      $0C40
0C38: 4A46          TST.W      D6
0C3A: 6604          BNE.S      $0C40
0C3C: 7000          MOVEQ      #0,D0
0C3E: 6078          BRA.S      $0CB8
0C40: 3044          MOVEA.W    D4,A0
0C42: B1EDF6686608  MOVE.W     -2456(A5),$6608.W              ; A5-2456
0C48: 3047          MOVEA.W    D7,A0
0C4A: B1EDF66C671A  MOVE.W     -2452(A5),$671A.W              ; A5-2452
0C50: 48780100      PEA        $0100.W
0C54: 486DF568      PEA        -2712(A5)                      ; A5-2712
0C58: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0C5C: 3044          MOVEA.W    D4,A0
0C5E: 2B48F668      MOVE.L     A0,-2456(A5)
0C62: 3247          MOVEA.W    D7,A1
0C64: 2B49F66C      MOVE.L     A1,-2452(A5)
0C68: 508F          MOVE.B     A7,(A0)
0C6A: 2005          MOVE.L     D5,D0
0C6C: 48C0          EXT.L      D0
0C6E: EB8849ED      MOVE.L     A0,-19(A5,D4.L)
0C72: F568D08C2206  MOVE.W     -12148(A0),8710(A2)
0C78: 48C1          EXT.L      D1
0C7A: E589D280      MOVE.L     A1,-128(A2,A5.W*2)
0C7E: 2841          MOVEA.L    D1,A4
0C80: 4A94          TST.L      (A4)
0C82: 6632          BNE.S      $0CB6
0C84: 3605          MOVE.W     D5,D3
0C86: D646          MOVEA.B    D6,A3
0C88: D66E0010      MOVEA.B    16(A6),A3
0C8C: 3F03          MOVE.W     D3,-(A7)
0C8E: 3F07          MOVE.W     D7,-(A7)
0C90: 3F04          MOVE.W     D4,-(A7)
0C92: 3F05          MOVE.W     D5,-(A7)
0C94: 3F06          MOVE.W     D6,-(A7)
0C96: 4EBA0114      JSR        276(PC)
0C9A: 2D40FFFA      MOVE.L     D0,-6(A6)
0C9E: 3E83          MOVE.W     D3,(A7)
0CA0: 3F07          MOVE.W     D7,-(A7)
0CA2: 3F04          MOVE.W     D4,-(A7)
0CA4: 42A7          CLR.L      -(A7)
0CA6: 4EBA0104      JSR        260(PC)
0CAA: 222EFFFA      MOVE.L     -6(A6),D1
0CAE: 9280          MOVE.B     D0,(A1)
0CB0: 2881          MOVE.L     D1,(A4)
0CB2: 4FEF0012      LEA        18(A7),A7
0CB6: 2014          MOVE.L     (A4),D0
0CB8: 4CDF10F8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A4        ; restore
0CBC: 4E5E          UNLK       A6
0CBE: 4E75          RTS        


; ======= Function at 0x0CC0 =======
0CC0: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0CC4: 48E71F00      MOVEM.L    D3/D4/D5/D6/D7,-(SP)           ; save
0CC8: 3C2E0008      MOVE.W     8(A6),D6
0CCC: 382E000E      MOVE.W     14(A6),D4
0CD0: 3A2E0010      MOVE.W     16(A6),D5
0CD4: 0C6E0002000C  CMPI.W     #$0002,12(A6)
0CDA: 6662          BNE.S      $0D3E
0CDC: 3F2E0012      MOVE.W     18(A6),-(A7)
0CE0: 3F05          MOVE.W     D5,-(A7)
0CE2: 3F04          MOVE.W     D4,-(A7)
0CE4: 7002          MOVEQ      #2,D0
0CE6: D06E000A      MOVEA.B    10(A6),A0
0CEA: 3F00          MOVE.W     D0,-(A7)
0CEC: 3F06          MOVE.W     D6,-(A7)
0CEE: 4EBAFF0C      JSR        -244(PC)
0CF2: 2E00          MOVE.L     D0,D7
0CF4: 3EAE0012      MOVE.W     18(A6),(A7)
0CF8: 3F05          MOVE.W     D5,-(A7)
0CFA: 3F04          MOVE.W     D4,-(A7)
0CFC: 7001          MOVEQ      #1,D0
0CFE: D06E000A      MOVEA.B    10(A6),A0
0D02: 3F00          MOVE.W     D0,-(A7)
0D04: 7001          MOVEQ      #1,D0
0D06: D046          MOVEA.B    D6,A0
0D08: 3F00          MOVE.W     D0,-(A7)
0D0A: 4EBAFEF0      JSR        -272(PC)
0D0E: 2600          MOVE.L     D0,D3
0D10: BE83          MOVE.W     D3,(A7)
0D12: 4FEF0012      LEA        18(A7),A7
0D16: 6C02          BGE.S      $0D1A
0D18: 2E03          MOVE.L     D3,D7
0D1A: 3F2E0012      MOVE.W     18(A6),-(A7)
0D1E: 3F05          MOVE.W     D5,-(A7)
0D20: 3F04          MOVE.W     D4,-(A7)
0D22: 3F2E000A      MOVE.W     10(A6),-(A7)
0D26: 7002          MOVEQ      #2,D0
0D28: D046          MOVEA.B    D6,A0
0D2A: 3F00          MOVE.W     D0,-(A7)
0D2C: 4EBAFECE      JSR        -306(PC)
0D30: 2600          MOVE.L     D0,D3
0D32: BE83          MOVE.W     D3,(A7)
0D34: 4FEF000A      LEA        10(A7),A7
0D38: 6C68          BGE.S      $0DA2
0D3A: 2E03          MOVE.L     D3,D7
0D3C: 6064          BRA.S      $0DA2
0D3E: 0C6E0001000C  CMPI.W     #$0001,12(A6)
0D44: 6644          BNE.S      $0D8A
0D46: 3F2E0012      MOVE.W     18(A6),-(A7)
0D4A: 3F05          MOVE.W     D5,-(A7)
0D4C: 3F04          MOVE.W     D4,-(A7)
0D4E: 7001          MOVEQ      #1,D0
0D50: D06E000A      MOVEA.B    10(A6),A0
0D54: 3F00          MOVE.W     D0,-(A7)
0D56: 3F06          MOVE.W     D6,-(A7)
0D58: 4EBAFEA2      JSR        -350(PC)
0D5C: 2E00          MOVE.L     D0,D7
0D5E: 3EAE0012      MOVE.W     18(A6),(A7)
0D62: 3F05          MOVE.W     D5,-(A7)
0D64: 3F04          MOVE.W     D4,-(A7)
0D66: 3F2E000A      MOVE.W     10(A6),-(A7)
0D6A: 7001          MOVEQ      #1,D0
0D6C: D046          MOVEA.B    D6,A0
0D6E: 3F00          MOVE.W     D0,-(A7)
0D70: 4EBAFE8A      JSR        -374(PC)
0D74: 2600          MOVE.L     D0,D3
0D76: DE83          MOVE.B     D3,(A7)
0D78: 7002          MOVEQ      #2,D0
0D7A: 2E80          MOVE.L     D0,(A7)
0D7C: 2F07          MOVE.L     D7,-(A7)
0D7E: 4EAD005A      JSR        90(A5)                         ; JT[90]
0D82: 2E00          MOVE.L     D0,D7
0D84: 4FEF000E      LEA        14(A7),A7
0D88: 6018          BRA.S      $0DA2
0D8A: 3F2E0012      MOVE.W     18(A6),-(A7)
0D8E: 3F05          MOVE.W     D5,-(A7)
0D90: 3F04          MOVE.W     D4,-(A7)
0D92: 3F2E000A      MOVE.W     10(A6),-(A7)
0D96: 3F06          MOVE.W     D6,-(A7)
0D98: 4EBAFE62      JSR        -414(PC)
0D9C: 2E00          MOVE.L     D0,D7
0D9E: 4FEF000A      LEA        10(A7),A7
0DA2: 2007          MOVE.L     D7,D0
0DA4: 4CDF00F8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7           ; restore
0DA8: 4E5E          UNLK       A6
0DAA: 4E75          RTS        


; ======= Function at 0x0DAC =======
0DAC: 4E56FEF0      LINK       A6,#-272                       ; frame=272
0DB0: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0DB4: 3C2E0010      MOVE.W     16(A6),D6
0DB8: 7E00          MOVEQ      #0,D7
0DBA: 2006          MOVE.L     D6,D0
0DBC: 48C0          EXT.L      D0
0DBE: E58849ED      MOVE.L     A0,-19(A2,D4.L)
0DC2: D56CD08C2840  MOVE.B     -12148(A4),10304(A2)
0DC8: 4878001C      PEA        $001C.W
0DCC: 2F07          MOVE.L     D7,-(A7)
0DCE: 4EAD0042      JSR        66(A5)                         ; JT[66]
0DD2: 2640          MOVEA.L    D0,A3
0DD4: 2007          MOVE.L     D7,D0
0DD6: EB8845EE      MOVE.L     A0,-18(A5,D4.W*4)
0DDA: FF00          MOVE.W     D0,-(A7)
0DDC: D08A          MOVE.B     A2,(A0)
0DDE: 2440          MOVEA.L    D0,A2
0DE0: 601A          BRA.S      $0DFC
0DE2: 2014          MOVE.L     (A4),D0
0DE4: 3046          MOVEA.W    D6,A0
0DE6: 91C72208      MOVE.B     D7,$2208.W
0DEA: E58925B3      MOVE.L     A1,-77(A2,D2.W*4)
0DEE: 08181800      BTST       #6144,(A0)+
0DF2: 5287          MOVE.B     D7,(A1)
0DF4: 47EB001C      LEA        28(A3),A3
0DF8: 45EA0020      LEA        32(A2),A2
0DFC: 3046          MOVEA.W    D6,A0
0DFE: B1C76CE0      MOVE.W     D7,$6CE0.W
0E02: 2E06          MOVE.L     D6,D7
0E04: 534748C7      MOVE.B     D7,18631(A1)
0E08: 3C2E000A      MOVE.W     10(A6),D6
0E0C: DC6E0008      MOVEA.B    8(A6),A6
0E10: 600000BA      BRA.W      $0ECE
0E14: 362E000A      MOVE.W     10(A6),D3
0E18: 48C3          EXT.L      D3
0E1A: 306E0008      MOVEA.W    8(A6),A0
0E1E: 2007          MOVE.L     D7,D0
0E20: 9088          MOVE.B     A0,(A0)
0E22: 2D40FEFC      MOVE.L     D0,-260(A6)
0E26: 306E000C      MOVEA.W    12(A6),A0
0E2A: 91C72D48      MOVE.B     D7,$2D48.W
0E2E: FEF82203      MOVE.W     $2203.W,(A7)+
0E32: EB8949EE      MOVE.L     A1,-18(A5,D4.L)
0E36: FF00          MOVE.W     D0,-(A7)
0E38: D28C          MOVE.B     A4,(A1)
0E3A: 2841          MOVEA.L    D1,A4
0E3C: 60000084      BRA.W      $0EC4
0E40: 306E000E      MOVEA.W    14(A6),A0
0E44: 91C3D0EE      MOVE.B     D3,$D0EE.W
0E48: 000A2808      ORI.B      #$2808,A2
0E4C: 4A84          TST.L      D4
0E4E: 6C02          BGE.S      $0E52
0E50: 7800          MOVEQ      #0,D4
0E52: 2A03          MOVE.L     D3,D5
0E54: DAAEFEF8      MOVE.B     -264(A6),(A5)
0E58: 306E0008      MOVEA.W    8(A6),A0
0E5C: DA88          MOVE.B     A0,(A5)
0E5E: 4A85          TST.L      D5
0E60: 6C02          BGE.S      $0E64
0E62: 7A00          MOVEQ      #0,D5
0E64: 2004          MOVE.L     D4,D0
0E66: D085          MOVE.B     D5,(A0)
0E68: 6604          BNE.S      $0E6E
0E6A: 7801          MOVEQ      #1,D4
0E6C: 7A01          MOVEQ      #1,D5
0E6E: 2007          MOVE.L     D7,D0
0E70: 9083          MOVE.B     D3,(A0)
0E72: E5882640      MOVE.L     A0,64(A2,D2.W*8)
0E76: 2007          MOVE.L     D7,D0
0E78: 9083          MOVE.B     D3,(A0)
0E7A: 2D40FEF0      MOVE.L     D0,-272(A6)
0E7E: 2204          MOVE.L     D4,D1
0E80: D285          MOVE.B     D5,(A1)
0E82: 2F01          MOVE.L     D1,-(A7)
0E84: 2F04          MOVE.L     D4,-(A7)
0E86: 2203          MOVE.L     D3,D1
0E88: 5281          MOVE.B     D1,(A1)
0E8A: EB8941EE      MOVE.L     A1,-18(A5,D4.W)
0E8E: FF00          MOVE.W     D0,-(A7)
0E90: D288          MOVE.B     A0,(A1)
0E92: 2F331800      MOVE.L     0(A3,D1.L),-(A7)
0E96: 4EAD0042      JSR        66(A5)                         ; JT[66]
0E9A: 2F05          MOVE.L     D5,-(A7)
0E9C: 222EFEF0      MOVE.L     -272(A6),D1
0EA0: E5892F34      MOVE.L     A1,52(A2,D2.L*8)
0EA4: 1804          MOVE.B     D4,D4
0EA6: 2200          MOVE.L     D0,D1
0EA8: 4EAD0042      JSR        66(A5)                         ; JT[66]
0EAC: C141          AND.W      D0,D1
0EAE: D081          MOVE.B     D1,(A0)
0EB0: 2F00          MOVE.L     D0,-(A7)
0EB2: 4EAD005A      JSR        90(A5)                         ; JT[90]
0EB6: 204C          MOVEA.L    A4,A0
0EB8: D1CB2080      MOVE.B     A3,$2080.W
0EBC: 5283          MOVE.B     D3,(A1)
0EBE: 49EC0020      LEA        32(A4),A4
0EC2: B6AEFEFC      MOVE.W     -260(A6),(A3)
0EC6: 6F00FF78      BLE.W      $0E42
0ECA: 53873046      MOVE.B     D7,70(A1,D3.W)
0ECE: B1C76F00      MOVE.W     D7,$6F00.W
0ED2: FF42302E      MOVE.W     D2,12334(A7)
0ED6: 000A48C0      ORI.B      #$48C0,A2
0EDA: EB88D08E      MOVE.L     A0,-114(A5,A5.W)
0EDE: 2040          MOVEA.L    D0,A0
0EE0: 302E0008      MOVE.W     8(A6),D0
0EE4: 48C0          EXT.L      D0
0EE6: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0EEA: 2028FF00      MOVE.L     -256(A0),D0
0EEE: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0EF2: 4E5E          UNLK       A6
0EF4: 4E75          RTS        


; ======= Function at 0x0EF6 =======
0EF6: 4E56FF5C      LINK       A6,#-164                       ; frame=164
0EFA: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0EFE: 486EFF76      PEA        -138(A6)
0F02: 486EFF78      PEA        -136(A6)
0F06: 486EFF7A      PEA        -134(A6)
0F0A: 486EFF72      PEA        -142(A6)
0F0E: 4EBAF9A8      JSR        -1624(PC)
0F12: 102DCE79      MOVE.B     -12679(A5),D0                  ; A5-12679
0F16: 4880          EXT.W      D0
0F18: 204D          MOVEA.L    A5,A0
0F1A: D0C0          MOVE.B     D0,(A0)+
0F1C: D0C0          MOVE.B     D0,(A0)+
0F1E: 3028F702      MOVE.W     -2302(A0),D0
0F22: 48C0          EXT.L      D0
0F24: D1AEFF72486E  MOVE.B     -142(A6),110(A0,D4.L)
0F2A: FF6E486DF686  MOVE.W     18541(A6),-2426(A7)
0F30: 4EBA078A      JSR        1930(PC)
0F34: 3040          MOVEA.W    D0,A0
0F36: 2D48FF6A      MOVE.L     A0,-150(A6)
0F3A: 7A7F          MOVEQ      #127,D5
0F3C: 49EDBCF2      LEA        -17166(A5),A4                  ; A5-17166
0F40: 47EDCCF8      LEA        -13064(A5),A3                  ; A5-13064
0F44: 4FEF0018      LEA        24(A7),A7
0F48: 60000200      BRA.W      $114C
0F4C: 426EFF64      CLR.W      -156(A6)
0F50: 426EFF66      CLR.W      -154(A6)
0F54: 426EFF5E      CLR.W      -162(A6)
0F58: 426EFF5C      CLR.W      -164(A6)
0F5C: 426EFF68      CLR.W      -152(A6)
0F60: 41EDCDFC      LEA        -12804(A5),A0                  ; A5-12804
0F64: 2E08          MOVE.L     A0,D7
0F66: 45EEFF7C      LEA        -132(A6),A2
0F6A: 7600          MOVEQ      #0,D3
0F6C: 41ED99D6      LEA        -26154(A5),A0                  ; A5-26154
0F70: 2D48FF60      MOVE.L     A0,-160(A6)
0F74: 6070          BRA.S      $0FE6
0F76: 206EFF60      MOVEA.L    -160(A6),A0
0F7A: 2005          MOVE.L     D5,D0
0F7C: 48C0          EXT.L      D0
0F7E: C090          AND.L      (A0),D0
0F80: 675C          BEQ.S      $0FDE
0F82: 14C4          MOVE.B     D4,(A2)+
0F84: 3F04          MOVE.W     D4,-(A7)
0F86: 4EAD07D2      JSR        2002(A5)                       ; JT[2002]
0F8A: 4A40          TST.W      D0
0F8C: 548F          MOVE.B     A7,(A2)
0F8E: 6712          BEQ.S      $0FA2
0F90: 0C440075      CMPI.W     #$0075,D4
0F94: 6606          BNE.S      $0F9C
0F96: 3D7C0001FF5C  MOVE.W     #$0001,-164(A6)
0F9C: 526EFF5E      MOVEA.B    -162(A6),A1
0FA0: 601C          BRA.S      $0FBE
0FA2: 0C44003F      CMPI.W     #$003F,D4
0FA6: 6712          BEQ.S      $0FBA
0FA8: 0C440071      CMPI.W     #$0071,D4
0FAC: 6606          BNE.S      $0FB4
0FAE: 3D7C0001FF68  MOVE.W     #$0001,-152(A6)
0FB4: 526EFF66      MOVEA.B    -154(A6),A1
0FB8: 6004          BRA.S      $0FBE
0FBA: 526EFF64      MOVEA.B    -156(A6),A1
0FBE: 2047          MOVEA.L    D7,A0
0FC0: 10280001      MOVE.B     1(A0),D0
0FC4: 4880          EXT.W      D0
0FC6: B044          MOVEA.W    D4,A0
0FC8: 6614          BNE.S      $0FDE
0FCA: 204D          MOVEA.L    A5,A0
0FCC: 2003          MOVE.L     D3,D0
0FCE: 48C0          EXT.L      D0
0FD0: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0FD4: 2005          MOVE.L     D5,D0
0FD6: 48C0          EXT.L      D0
0FD8: C0A899DA      AND.L      -26150(A0),D0
0FDC: 6712          BEQ.S      $0FF0
0FDE: 5243          MOVEA.B    D3,A1
0FE0: 58AEFF60      MOVE.B     -160(A6),(A4)
0FE4: 5287          MOVE.B     D7,(A1)
0FE6: 2047          MOVEA.L    D7,A0
0FE8: 1810          MOVE.B     (A0),D4
0FEA: 4884          EXT.W      D4
0FEC: 4A44          TST.W      D4
0FEE: 6686          BNE.S      $0F76
0FF0: 4A44          TST.W      D4
0FF2: 66000150      BNE.W      $1146
0FF6: 4212          CLR.B      (A2)
0FF8: 302DCCFA      MOVE.W     -13062(A5),D0                  ; A5-13062
0FFC: 526DCCFA      MOVEA.B    -13062(A5),A1
1000: 204D          MOVEA.L    A5,A0
1002: D0C0          MOVE.B     D0,(A0)+
1004: D0C0          MOVE.B     D0,(A0)+
1006: 3145CCFC      MOVE.W     D5,-13060(A0)
100A: 0C6D0007CF06  CMPI.W     #$0007,-12538(A5)
1010: 6E42          BGT.S      $1054
1012: 4253          CLR.W      (A3)
1014: 45EEFF7C      LEA        -132(A6),A2
1018: 600E          BRA.S      $1028
101A: 204D          MOVEA.L    A5,A0
101C: D0C4          MOVE.B     D4,(A0)+
101E: D0C4          MOVE.B     D4,(A0)+
1020: 30289412      MOVE.W     -27630(A0),D0
1024: D153528A      MOVE.B     (A3),21130(A0)
1028: 1812          MOVE.B     (A2),D4
102A: 4884          EXT.W      D4
102C: 4A44          TST.W      D4
102E: 66EA          BNE.S      $101A
1030: 4A2EFF7C      TST.B      -132(A6)
1034: 660C          BNE.S      $1042
1036: 302EFF7A      MOVE.W     -134(A6),D0
103A: D040          MOVEA.B    D0,A0
103C: 3880          MOVE.W     D0,(A4)
103E: 60000104      BRA.W      $1146
1042: 3013          MOVE.W     (A3),D0
1044: D040          MOVEA.B    D0,A0
1046: 322EFF7A      MOVE.W     -134(A6),D1
104A: 4441          NEG.W      D1
104C: 9240          MOVEA.B    D0,A1
104E: 3881          MOVE.W     D1,(A4)
1050: 600000F2      BRA.W      $1146
1054: 486EFF7C      PEA        -132(A6)
1058: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
105C: 7607          MOVEQ      #7,D3
105E: 9640          MOVEA.B    D0,A3
1060: 7CF9          MOVEQ      #-7,D6
1062: DC6DCF06      MOVEA.B    -12538(A5),A6
1066: BC43          MOVEA.W    D3,A6
1068: 588F          MOVE.B     A7,(A4)
106A: 6C04          BGE.S      $1070
106C: 3006          MOVE.W     D6,D0
106E: 6002          BRA.S      $1072
1070: 3003          MOVE.W     D3,D0
1072: 3600          MOVE.W     D0,D3
1074: 486EFF6E      PEA        -146(A6)
1078: 486EFF7C      PEA        -132(A6)
107C: 4EBA05CA      JSR        1482(PC)
1080: 3C00          MOVE.W     D0,D6
1082: 508F          MOVE.B     A7,(A0)
1084: 6722          BEQ.S      $10A8
1086: 206EFF6E      MOVEA.L    -146(A6),A0
108A: 2010          MOVE.L     (A0),D0
108C: B0ADB1D8      MOVE.W     -20008(A5),(A0)                ; A5-20008
1090: 6E16          BGT.S      $10A8
1092: 52ADB1DC      MOVE.B     -20004(A5),(A1)                ; A5-20004
1096: 206EFF6E      MOVEA.L    -146(A6),A0
109A: 20ADB1DC      MOVE.L     -20004(A5),(A0)                ; A5-20004
109E: 3F06          MOVE.W     D6,-(A7)
10A0: 3F05          MOVE.W     D5,-(A7)
10A2: 4EBA083C      JSR        2108(PC)
10A6: 588F          MOVE.B     A7,(A4)
10A8: 3F03          MOVE.W     D3,-(A7)
10AA: 3F2EFF76      MOVE.W     -138(A6),-(A7)
10AE: 3F2EFF78      MOVE.W     -136(A6),-(A7)
10B2: 3F2EFF64      MOVE.W     -156(A6),-(A7)
10B6: 3F2EFF66      MOVE.W     -154(A6),-(A7)
10BA: 3F2EFF5E      MOVE.W     -162(A6),-(A7)
10BE: 4EBAFC00      JSR        -1024(PC)
10C2: 3C00          MOVE.W     D0,D6
10C4: D1544A6E      MOVE.B     (A4),19054(A0)
10C8: FF684FEF000C  MOVE.W     20463(A0),12(A7)
10CE: 6720          BEQ.S      $10F0
10D0: 4A6EFF5C      TST.W      -164(A6)
10D4: 661A          BNE.S      $10F0
10D6: 700A          MOVEQ      #10,D0
10D8: C1C3          ANDA.L     D3,A0
10DA: 122DCE79      MOVE.B     -12679(A5),D1                  ; A5-12679
10DE: 4881          EXT.W      D1
10E0: 41EDF6DA      LEA        -2342(A5),A0                   ; A5-2342
10E4: D088          MOVE.B     A0,(A0)
10E6: 3041          MOVEA.W    D1,A0
10E8: D1C83030      MOVE.B     A0,$3030.W
10EC: 0800D154      BTST       #53588,D0
10F0: 4A6EFF5C      TST.W      -164(A6)
10F4: 6734          BEQ.S      $112A
10F6: 4A2DCE75      TST.B      -12683(A5)
10FA: 672E          BEQ.S      $112A
10FC: 306DCF06      MOVEA.W    -12538(A5),A0
1100: 2F08          MOVE.L     A0,-(A7)
1102: 102DCE79      MOVE.B     -12679(A5),D0                  ; A5-12679
1106: 4880          EXT.W      D0
1108: 204D          MOVEA.L    A5,A0
110A: D0C0          MOVE.B     D0,(A0)+
110C: D0C0          MOVE.B     D0,(A0)+
110E: 3068F702      MOVEA.W    -2302(A0),A0
1112: 202EFF6A      MOVE.L     -150(A6),D0
1116: 9088          MOVE.B     A0,(A0)
1118: 2F00          MOVE.L     D0,-(A7)
111A: 3043          MOVEA.W    D3,A0
111C: 2F08          MOVE.L     A0,-(A7)
111E: 4EAD0042      JSR        66(A5)                         ; JT[66]
1122: 2F00          MOVE.L     D0,-(A7)
1124: 4EAD005A      JSR        90(A5)                         ; JT[90]
1128: D154306D      MOVE.B     (A4),12397(A0)
112C: CF06          AND.B      D7,D6
112E: 2F08          MOVE.L     A0,-(A7)
1130: 3043          MOVEA.W    D3,A0
1132: 2F08          MOVE.L     A0,-(A7)
1134: 2F2EFF72      MOVE.L     -142(A6),-(A7)
1138: 4EAD0042      JSR        66(A5)                         ; JT[66]
113C: 2F00          MOVE.L     D0,-(A7)
113E: 4EAD005A      JSR        90(A5)                         ; JT[90]
1142: D1545345      MOVE.B     (A4),21317(A0)
1146: 558C558B      MOVE.B     A4,-117(A2,D5.W*4)
114A: 4A45          TST.W      D5
114C: 6C00FDFE      BGE.W      $0F4E
1150: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
1154: 4E5E          UNLK       A6
1156: 4E75          RTS        

1158: 48E70718      MOVEM.L    D5/D6/D7/A3/A4,-(SP)           ; save
115C: 48780100      PEA        $0100.W
1160: 486DCCFC      PEA        -13060(A5)                     ; A5-13060
1164: 4EAD01AA      JSR        426(A5)                        ; JT[426]
1168: 426DCCFA      CLR.W      -13062(A5)
116C: 48780100      PEA        $0100.W
1170: 486DCBFA      PEA        -13318(A5)                     ; A5-13318
1174: 4EAD01AA      JSR        426(A5)                        ; JT[426]
1178: 4EBAF6A6      JSR        -2394(PC)
117C: 7C7F          MOVEQ      #127,D6
117E: 4FEF0010      LEA        16(A7),A7
1182: 6054          BRA.S      $11D8
1184: 49EDCDFC      LEA        -12804(A5),A4                  ; A5-12804
1188: 7E00          MOVEQ      #0,D7
118A: 47ED99D6      LEA        -26154(A5),A3                  ; A5-26154
118E: 6026          BRA.S      $11B6
1190: 2006          MOVE.L     D6,D0
1192: 48C0          EXT.L      D0
1194: C09B          AND.L      (A3)+,D0
1196: 671C          BEQ.S      $11B4
1198: BA2C0001      MOVE.W     1(A4),D5
119C: 6608          BNE.S      $11A6
119E: 2006          MOVE.L     D6,D0
11A0: 48C0          EXT.L      D0
11A2: C093          AND.L      (A3),D0
11A4: 6730          BEQ.S      $11D6
11A6: 1005          MOVE.B     D5,D0
11A8: 4880          EXT.W      D0
11AA: 204D          MOVEA.L    A5,A0
11AC: D0C0          MOVE.B     D0,(A0)+
11AE: D0C0          MOVE.B     D0,(A0)+
11B0: DE689412      MOVEA.B    -27630(A0),A7
11B4: 528C          MOVE.B     A4,(A1)
11B6: 1A14          MOVE.B     (A4),D5
11B8: 66D6          BNE.S      $1190
11BA: 302DCCFA      MOVE.W     -13062(A5),D0                  ; A5-13062
11BE: 526DCCFA      MOVEA.B    -13062(A5),A1
11C2: 204D          MOVEA.L    A5,A0
11C4: D0C0          MOVE.B     D0,(A0)+
11C6: D0C0          MOVE.B     D0,(A0)+
11C8: 3146CCFC      MOVE.W     D6,-13060(A0)
11CC: 204D          MOVEA.L    A5,A0
11CE: D0C6          MOVE.B     D6,(A0)+
11D0: D0C6          MOVE.B     D6,(A0)+
11D2: 3147CBFA      MOVE.W     D7,-13318(A0)
11D6: 53464A46      MOVE.B     D6,19014(A1)
11DA: 6CA8          BGE.S      $1184
11DC: 4CDF18E0      MOVEM.L    (SP)+,D5/D6/D7/A3/A4           ; restore
11E0: 4E75          RTS        


; ======= Function at 0x11E2 =======
11E2: 4E56FFEE      LINK       A6,#-18                        ; frame=18
11E6: 48E70738      MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)        ; save
11EA: 7E00          MOVEQ      #0,D7
11EC: 49EDCCFC      LEA        -13060(A5),A4                  ; A5-13060
11F0: 603A          BRA.S      $122C
11F2: 3C14          MOVE.W     (A4),D6
11F4: 47EEFFEE      LEA        -18(A6),A3
11F8: 7A01          MOVEQ      #1,D5
11FA: 246E0008      MOVEA.L    8(A6),A2
11FE: 600C          BRA.S      $120C
1200: 3006          MOVE.W     D6,D0
1202: C045          AND.W      D5,D0
1204: 6702          BEQ.S      $1208
1206: 16D2          MOVE.B     (A2),(A3)+
1208: 528A          MOVE.B     A2,(A1)
120A: DA45          MOVEA.B    D5,A5
120C: 4A12          TST.B      (A2)
120E: 66F0          BNE.S      $1200
1210: 4213          CLR.B      (A3)
1212: 2F2E000C      MOVE.L     12(A6),-(A7)
1216: 486EFFEE      PEA        -18(A6)
121A: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
121E: 4A40          TST.W      D0
1220: 508F          MOVE.B     A7,(A0)
1222: 6604          BNE.S      $1228
1224: 3006          MOVE.W     D6,D0
1226: 600E          BRA.S      $1236
1228: 5247          MOVEA.B    D7,A1
122A: 548C          MOVE.B     A4,(A2)
122C: BE6DCCFA      MOVEA.W    -13062(A5),A7
1230: 6DC0          BLT.S      $11F2
1232: 4EAD01A2      JSR        418(A5)                        ; JT[418]
1236: 4CDF1CE0      MOVEM.L    (SP)+,D5/D6/D7/A2/A3/A4        ; restore
123A: 4E5E          UNLK       A6
123C: 4E75          RTS        


; ======= Function at 0x123E =======
123E: 4E560000      LINK       A6,#0
1242: 48E70F18      MOVEM.L    D4/D5/D6/D7/A3/A4,-(SP)        ; save
1246: 3E2E0008      MOVE.W     8(A6),D7
124A: 3C2E000A      MOVE.W     10(A6),D6
124E: 3007          MOVE.W     D7,D0
1250: 8046          OR.W       D6,D0
1252: BE40          MOVEA.W    D0,A7
1254: 6704          BEQ.S      $125A
1256: 4EAD01A2      JSR        418(A5)                        ; JT[418]
125A: 3006          MOVE.W     D6,D0
125C: 4640          NOT.W      D0
125E: C047          AND.W      D7,D0
1260: 3C00          MOVE.W     D0,D6
1262: 7A00          MOVEQ      #0,D5
1264: 3E05          MOVE.W     D5,D7
1266: 49EDCDFC      LEA        -12804(A5),A4                  ; A5-12804
126A: 2007          MOVE.L     D7,D0
126C: 48C0          EXT.L      D0
126E: E58847ED      MOVE.L     A0,-19(A2,D4.W*8)
1272: 99D6D08B      MOVE.B     (A6),#$8B
1276: 2640          MOVEA.L    D0,A3
1278: 1814          MOVE.B     (A4),D4
127A: 4A04          TST.B      D4
127C: 6742          BEQ.S      $12C0
127E: 8A6B0002      OR.W       2(A3),D5
1282: B82C0001      MOVE.W     1(A4),D4
1286: 6730          BEQ.S      $12B8
1288: 3806          MOVE.W     D6,D4
128A: C845          AND.W      D5,D4
128C: 6728          BEQ.S      $12B6
128E: 3005          MOVE.W     D5,D0
1290: 4640          NOT.W      D0
1292: CC40          AND.W      D0,D6
1294: 4A44          TST.W      D4
1296: 6604          BNE.S      $129C
1298: 4EAD01A2      JSR        418(A5)                        ; JT[418]
129C: 0C440080      CMPI.W     #$0080,D4
12A0: 6D04          BLT.S      $12A6
12A2: 4EAD01A2      JSR        418(A5)                        ; JT[418]
12A6: D844          MOVEA.B    D4,A4
12A8: 3004          MOVE.W     D4,D0
12AA: C045          AND.W      D5,D0
12AC: B840          MOVEA.W    D0,A4
12AE: 67E4          BEQ.S      $1294
12B0: 3004          MOVE.W     D4,D0
12B2: E240          MOVEA.L    D0,A1
12B4: 8C40          OR.W       D0,D6
12B6: 7A00          MOVEQ      #0,D5
12B8: 528C          MOVE.B     A4,(A1)
12BA: 5247          MOVEA.B    D7,A1
12BC: 588B          MOVE.B     A3,(A4)
12BE: 60B8          BRA.S      $1278
12C0: 3006          MOVE.W     D6,D0
12C2: 4CDF18F0      MOVEM.L    (SP)+,D4/D5/D6/D7/A3/A4        ; restore
12C6: 4E5E          UNLK       A6
12C8: 4E75          RTS        


; ======= Function at 0x12CA =======
12CA: 4E560000      LINK       A6,#0
12CE: 48E70F00      MOVEM.L    D4/D5/D6/D7,-(SP)              ; save
12D2: 382E0008      MOVE.W     8(A6),D4
12D6: 3C2E000A      MOVE.W     10(A6),D6
12DA: 3E2E000C      MOVE.W     12(A6),D7
12DE: 4647          NOT.W      D7
12E0: 600C          BRA.S      $12EE
12E2: 3A04          MOVE.W     D4,D5
12E4: 8846          OR.W       D6,D4
12E6: 3005          MOVE.W     D5,D0
12E8: C047          AND.W      D7,D0
12EA: CC40          AND.W      D0,D6
12EC: E246          MOVEA.L    D6,A1
12EE: 4A46          TST.W      D6
12F0: 66F0          BNE.S      $12E2
12F2: 3007          MOVE.W     D7,D0
12F4: 4640          NOT.W      D0
12F6: 8044          OR.W       D4,D0
12F8: 4CDF00F0      MOVEM.L    (SP)+,D4/D5/D6/D7              ; restore
12FC: 4E5E          UNLK       A6
12FE: 4E75          RTS        


; ======= Function at 0x1300 =======
1300: 4E56FE5A      LINK       A6,#-422                       ; frame=422
1304: 48E70F18      MOVEM.L    D4/D5/D6/D7/A3/A4,-(SP)        ; save
1308: 486EFE5E      PEA        -418(A6)
130C: 4EAD095A      JSR        2394(A5)                       ; JT[2394]
1310: 3E00          MOVE.W     D0,D7
1312: 5F477022      MOVE.B     D7,28706(A7)
1316: 2E80          MOVE.L     D0,(A7)
1318: 486EFFDE      PEA        -34(A6)
131C: 4EAD01AA      JSR        426(A5)                        ; JT[426]
1320: 422EFE5F      CLR.B      -417(A6)
1324: 286DC376      MOVEA.L    -15498(A5),A4
1328: 508F          MOVE.B     A7,(A0)
132A: 601E          BRA.S      $134A
132C: 486EFE5A      PEA        -422(A6)
1330: 486EFE5E      PEA        -418(A6)
1334: 4EBA0312      JSR        786(PC)
1338: 1214          MOVE.B     (A4),D1
133A: 4881          EXT.W      D1
133C: 204E          MOVEA.L    A6,A0
133E: D0C1          MOVE.B     D1,(A0)+
1340: D0C1          MOVE.B     D1,(A0)+
1342: 3140FEDE      MOVE.W     D0,-290(A0)
1346: 508F          MOVE.B     A7,(A0)
1348: 528C          MOVE.B     A4,(A1)
134A: 1D54FE5E      MOVE.B     (A4),-418(A6)
134E: 66DC          BNE.S      $132C
1350: 7C00          MOVEQ      #0,D6
1352: 47EDCCFC      LEA        -13060(A5),A3                  ; A5-13060
1356: 60000092      BRA.W      $13EC
135A: 3D53FFFC      MOVE.W     (A3),-4(A6)
135E: 3F2EFFFC      MOVE.W     -4(A6),-(A7)
1362: 4EBAF458      JSR        -2984(PC)
1366: 204D          MOVEA.L    A5,A0
1368: 302EFFFC      MOVE.W     -4(A6),D0
136C: D0C0          MOVE.B     D0,(A0)+
136E: D0C0          MOVE.B     D0,(A0)+
1370: 3028BBF4      MOVE.W     -17420(A0),D0
1374: D06DA54C      MOVEA.B    -23220(A5),A0
1378: 3040          MOVEA.W    D0,A0
137A: 2D48FFF2      MOVE.L     A0,-14(A6)
137E: 3EAEFFFC      MOVE.W     -4(A6),(A7)
1382: 3F3C007F      MOVE.W     #$007F,-(A7)
1386: 4EBAFEB6      JSR        -330(PC)
138A: 3E80          MOVE.W     D0,(A7)
138C: 4EBAF2BE      JSR        -3394(PC)
1390: 2E80          MOVE.L     D0,(A7)
1392: 486EFFDE      PEA        -34(A6)
1396: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
139A: 7A00          MOVEQ      #0,D5
139C: 49EEFFDE      LEA        -34(A6),A4
13A0: 508F          MOVE.B     A7,(A0)
13A2: 1814          MOVE.B     (A4),D4
13A4: 4A04          TST.B      D4
13A6: 6712          BEQ.S      $13BA
13A8: 1004          MOVE.B     D4,D0
13AA: 4880          EXT.W      D0
13AC: 204E          MOVEA.L    A6,A0
13AE: D0C0          MOVE.B     D0,(A0)+
13B0: D0C0          MOVE.B     D0,(A0)+
13B2: 9A68FEDE      MOVEA.B    -290(A0),A5
13B6: 528C          MOVE.B     A4,(A1)
13B8: 60E8          BRA.S      $13A2
13BA: DA45          MOVEA.B    D5,A5
13BC: 48C5          EXT.L      D5
13BE: 8BC7          ORA.L      D7,A5
13C0: 4A2DBD8E      TST.B      -17010(A5)
13C4: 660E          BNE.S      $13D4
13C6: 206DD568      MOVEA.L    -10904(A5),A0
13CA: 3028001A      MOVE.W     26(A0),D0
13CE: 906800A6      MOVEA.B    166(A0),A0
13D2: DA40          MOVEA.B    D0,A5
13D4: 3045          MOVEA.W    D5,A0
13D6: 2D48FFF6      MOVE.L     A0,-10(A6)
13DA: 486EFFDE      PEA        -34(A6)
13DE: 206E0008      MOVEA.L    8(A6),A0
13E2: 4E90          JSR        (A0)
13E4: 588F          MOVE.B     A7,(A4)
13E6: 5246          MOVEA.B    D6,A1
13E8: 548B          MOVE.B     A3,(A2)
13EA: BC6DCCFA      MOVEA.W    -13062(A5),A6
13EE: 6D00FF6A      BLT.W      $135C
13F2: 4A6DCF04      TST.W      -12540(A5)
13F6: 6706          BEQ.S      $13FE
13F8: 3B7C0001CF04  MOVE.W     #$0001,-12540(A5)
13FE: 4CDF18F0      MOVEM.L    (SP)+,D4/D5/D6/D7/A3/A4        ; restore
1402: 4E5E          UNLK       A6
1404: 4E75          RTS        


; ======= Function at 0x1406 =======
1406: 4E56FFCE      LINK       A6,#-50                        ; frame=50
140A: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
140E: 3A2E0008      MOVE.W     8(A6),D5
1412: 3C2E000A      MOVE.W     10(A6),D6
1416: 0C460007      CMPI.W     #$0007,D6
141A: 6C06          BGE.S      $1422
141C: 7000          MOVEQ      #0,D0
141E: 60000220      BRA.W      $1642
1422: 0C45003F      CMPI.W     #$003F,D5
1426: 6604          BNE.S      $142C
1428: 7000          MOVEQ      #0,D0
142A: 6004          BRA.S      $1430
142C: 70A0          MOVEQ      #-96,D0
142E: D045          MOVEA.B    D5,A0
1430: 3A00          MOVE.W     D0,D5
1432: 4AADF670      TST.L      -2448(A5)
1436: 660000D0      BNE.W      $150A
143A: 48781F90      PEA        $1F90.W
143E: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
1442: 2B40F670      MOVE.L     D0,-2448(A5)
1446: 4A80          TST.L      D0
1448: 588F          MOVE.B     A7,(A4)
144A: 6604          BNE.S      $1450
144C: 4EAD01A2      JSR        418(A5)                        ; JT[418]
1450: 7801          MOVEQ      #1,D4
1452: 387C000A      MOVEA.W    #$000A,A4
1456: 6016          BRA.S      $146E
1458: 204C          MOVEA.L    A4,A0
145A: D1EDF67042A8  MOVE.B     -2448(A5),$42A8.W              ; A5-2448
1460: 000642A8      ORI.B      #$42A8,D6
1464: 00024250      ORI.B      #$4250,D2
1468: 5244          MOVEA.B    D4,A1
146A: 49EC000A      LEA        10(A4),A4
146E: 0C440008      CMPI.W     #$0008,D4
1472: 6DE4          BLT.S      $1458
1474: 7800          MOVEQ      #0,D4
1476: 99CC601C      MOVE.B     A4,#$1C
147A: 204C          MOVEA.L    A4,A0
147C: D1EDF67042A8  MOVE.B     -2448(A5),$42A8.W              ; A5-2448
1482: 0006217C      ORI.B      #$217C,D6
1486: 8000          OR.B       D0,D0
1488: 00000002      ORI.B      #$0002,D0
148C: 30BC3FFF      MOVE.W     #$3FFF,(A0)
1490: 5244          MOVEA.B    D4,A1
1492: 49EC0050      LEA        80(A4),A4
1496: 0C440065      CMPI.W     #$0065,D4
149A: 6DDE          BLT.S      $147A
149C: 7801          MOVEQ      #1,D4
149E: 387C0050      MOVEA.W    #$0050,A4
14A2: 605E          BRA.S      $1502
14A4: 7601          MOVEQ      #1,D3
14A6: 70FF          MOVEQ      #-1,D0
14A8: D044          MOVEA.B    D4,A0
14AA: C1FC0050D0AD  ANDA.L     #$0050D0AD,A0
14B0: F6702640      MOVEA.W    64(A0,D2.W*8),A3
14B4: 700A          MOVEQ      #10,D0
14B6: C1C3          ANDA.L     D3,A0
14B8: 2440          MOVEA.L    D0,A2
14BA: 603A          BRA.S      $14F6
14BC: 70FF          MOVEQ      #-1,D0
14BE: D043          MOVEA.B    D3,A0
14C0: C1FC000A204B  ANDA.L     #$000A204B,A0
14C6: D1CA43EE      MOVE.B     A2,$43EE.W
14CA: FFD2          MOVE.W     (A2),???
14CC: 22D8          MOVE.L     (A0)+,(A1)+
14CE: 22D8          MOVE.L     (A0)+,(A1)+
14D0: 32D8          MOVE.W     (A0)+,(A1)+
14D2: 48730800      PEA        0(A3,D0.L)
14D6: 4869FFF6      PEA        -10(A1)
14DA: 4267          CLR.W      -(A7)
14DC: A9EB204CD1EDF670  MOVE.L     8268(A3),#$D1EDF670
14E4: D1CA43E9      MOVE.B     A2,$43E9.W
14E8: FFF620D9      MOVE.W     -39(A6,D2.W),???
14EC: 20D9          MOVE.L     (A1)+,(A0)+
14EE: 30D9          MOVE.W     (A1)+,(A0)+
14F0: 5243          MOVEA.B    D3,A1
14F2: 45EA000A      LEA        10(A2),A2
14F6: 0C430008      CMPI.W     #$0008,D3
14FA: 6DC0          BLT.S      $14BC
14FC: 5244          MOVEA.B    D4,A1
14FE: 49EC0050      LEA        80(A4),A4
1502: 0C440065      CMPI.W     #$0065,D4
1506: 6D9C          BLT.S      $14A4
1508: 42AEFFF2      CLR.L      -14(A6)
150C: 42AEFFEE      CLR.L      -18(A6)
1510: 426EFFEC      CLR.W      -20(A6)
1514: 42AEFFE8      CLR.L      -24(A6)
1518: 42AEFFE4      CLR.L      -28(A6)
151C: 426EFFE2      CLR.W      -30(A6)
1520: 78F9          MOVEQ      #-7,D4
1522: D846          MOVEA.B    D6,A4
1524: 0C440006      CMPI.W     #$0006,D4
1528: 6C04          BGE.S      $152E
152A: 3004          MOVE.W     D4,D0
152C: 6002          BRA.S      $1530
152E: 7006          MOVEQ      #6,D0
1530: 3600          MOVE.W     D0,D3
1532: 9C6E000C      MOVEA.B    12(A6),A6
1536: 7800          MOVEQ      #0,D4
1538: 7050          MOVEQ      #80,D0
153A: C1EE000C      ANDA.L     12(A6),A0
153E: D0ADF670      MOVE.B     -2448(A5),(A0)                 ; A5-2448
1542: 2840          MOVEA.L    D0,A4
1544: 7050          MOVEQ      #80,D0
1546: C1C6          ANDA.L     D6,A0
1548: D0ADF670      MOVE.B     -2448(A5),(A0)                 ; A5-2448
154C: 2640          MOVEA.L    D0,A3
154E: 204D          MOVEA.L    A5,A0
1550: 2005          MOVE.L     D5,D0
1552: 48C0          EXT.L      D0
1554: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1558: 2468D58C      MOVEA.L    -10868(A0),A2
155C: 204D          MOVEA.L    A5,A0
155E: 2005          MOVE.L     D5,D0
1560: 48C0          EXT.L      D0
1562: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1566: 2068D58C      MOVEA.L    -10868(A0),A0
156A: 2D680018FFDC  MOVE.L     24(A0),-36(A6)
1570: 7E0A          MOVEQ      #10,D7
1572: CFC4          ANDA.L     D4,A7
1574: 60000082      BRA.W      $15FA
1578: 3003          MOVE.W     D3,D0
157A: 9044          MOVEA.B    D4,A0
157C: C1FC000A41EE  ANDA.L     #$000A41EE,A0
1582: FFD2          MOVE.W     (A2),???
1584: 43F47800      LEA        0(A4,D7.L),A1
1588: 20D9          MOVE.L     (A1)+,(A0)+
158A: 20D9          MOVE.L     (A1)+,(A0)+
158C: 30D9          MOVE.W     (A1)+,(A0)+
158E: 48730800      PEA        0(A3,D0.L)
1592: 4868FFF6      PEA        -10(A0)
1596: 3F3C0004      MOVE.W     #$0004,-(A7)
159A: A9EB43EEFFF641E8  MOVE.L     17390(A3),#$FFF641E8
15A2: FFF622D8      MOVE.W     -40(A6,D2.W*2),???
15A6: 22D8          MOVE.L     (A0)+,(A1)+
15A8: 32D8          MOVE.W     (A0)+,(A1)+
15AA: 486EFFF6      PEA        -10(A6)
15AE: 486EFFE2      PEA        -30(A6)
15B2: 4267          CLR.W      -(A7)
15B4: A9EB7001D044C1FC  MOVE.L     28673(A3),#$D044C1FC
15BC: 001C2032      ORI.B      #$2032,(A4)+
15C0: 081890AE      BTST       #37038,(A0)+
15C4: FFDC          MOVE.W     (A4)+,???
15C6: 41EEFFD2      LEA        -46(A6),A0
15CA: 43EEFFF6      LEA        -10(A6),A1
15CE: 20D9          MOVE.L     (A1)+,(A0)+
15D0: 20D9          MOVE.L     (A1)+,(A0)+
15D2: 30D9          MOVE.W     (A1)+,(A0)+
15D4: 2D40FFCE      MOVE.L     D0,-50(A6)
15D8: 486EFFCE      PEA        -50(A6)
15DC: 4868FFF6      PEA        -10(A0)
15E0: 3F3C2804      MOVE.W     #$2804,-(A7)
15E4: A9EB4868FFF6486E  MOVE.L     18536(A3),#$FFF6486E
15EC: FFEC4267      MOVE.W     16999(A4),???
15F0: A9EB5244700ADE80  MOVE.L     21060(A3),#$700ADE80
15F8: B86E000C      MOVEA.W    12(A6),A4
15FC: 6E06          BGT.S      $1604
15FE: B644          MOVEA.W    D4,A3
1600: 6C00FF76      BGE.W      $157A
1604: 486EFFE2      PEA        -30(A6)
1608: 486EFFEC      PEA        -20(A6)
160C: 3F3C0006      MOVE.W     #$0006,-(A7)
1610: A9EBDC6E000C41EE  MOVE.L     -9106(A3),#$000C41EE
1618: FFCE          MOVE.W     A6,???
161A: 43EEFFEC      LEA        -20(A6),A1
161E: 20D9          MOVE.L     (A1)+,(A0)+
1620: 20D9          MOVE.L     (A1)+,(A0)+
1622: 30D9          MOVE.W     (A1)+,(A0)+
1624: 4868FFF6      PEA        -10(A0)
1628: 3F3C0016      MOVE.W     #$0016,-(A7)
162C: A9EB4868FFF6486E  MOVE.L     18536(A3),#$FFF6486E
1634: FFD8          MOVE.W     (A0)+,???
1636: 3F3C2810      MOVE.W     #$2810,-(A7)
163A: A9EB202EFFD84CDF  MOVE.L     8238(A3),#$FFD84CDF
1642: 1CF84E5E      MOVE.B     $4E5E.W,(A6)+
1646: 4E75          RTS        


; ======= Function at 0x1648 =======
1648: 4E560000      LINK       A6,#0
164C: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
1650: 286E0008      MOVEA.L    8(A6),A4
1654: 2F2E000C      MOVE.L     12(A6),-(A7)
1658: 2F0C          MOVE.L     A4,-(A7)
165A: 4EBA0060      JSR        96(PC)
165E: 3E00          MOVE.W     D0,D7
1660: 2E8C          MOVE.L     A4,(A7)
1662: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
1666: 5380508F      MOVE.B     D0,-113(A1,D5.W)
166A: 6646          BNE.S      $16B2
166C: 1014          MOVE.B     (A4),D0
166E: 4880          EXT.W      D0
1670: 204D          MOVEA.L    A5,A0
1672: D0C0          MOVE.B     D0,(A0)+
1674: 1028CE04      MOVE.B     -12796(A0),D0
1678: 4880          EXT.W      D0
167A: 3F00          MOVE.W     D0,-(A7)
167C: 3F2DCF06      MOVE.W     -12538(A5),-(A7)               ; A5-12538
1680: 1014          MOVE.B     (A4),D0
1682: 4880          EXT.W      D0
1684: 3F00          MOVE.W     D0,-(A7)
1686: 4EBAFD7E      JSR        -642(PC)
168A: DE40          MOVEA.B    D0,A7
168C: 1014          MOVE.B     (A4),D0
168E: 4880          EXT.W      D0
1690: 204D          MOVEA.L    A5,A0
1692: D0C0          MOVE.B     D0,(A0)+
1694: 10289512      MOVE.B     -27374(A0),D0
1698: 4880          EXT.W      D0
169A: 53403E80      MOVE.B     D0,16000(A1)
169E: 3F3C0060      MOVE.W     #$0060,-(A7)
16A2: 1014          MOVE.B     (A4),D0
16A4: 4880          EXT.W      D0
16A6: 3F00          MOVE.W     D0,-(A7)
16A8: 4EBAFD5C      JSR        -676(PC)
16AC: 9E40          MOVEA.B    D0,A7
16AE: 4FEF000A      LEA        10(A7),A7
16B2: 3007          MOVE.W     D7,D0
16B4: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
16B8: 4E5E          UNLK       A6
16BA: 4E75          RTS        


; ======= Function at 0x16BC =======
16BC: 4E560000      LINK       A6,#0
16C0: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
16C4: 4AADF674      TST.L      -2444(A5)
16C8: 660001A4      BNE.W      $1870
16CC: 4A6DF682      TST.W      -2430(A5)
16D0: 6704          BEQ.S      $16D6
16D2: 4EAD01A2      JSR        418(A5)                        ; JT[418]
16D6: 7C01          MOVEQ      #1,D6
16D8: 387C0008      MOVEA.W    #$0008,A4
16DC: 601A          BRA.S      $16F8
16DE: 264C          MOVEA.L    A4,A3
16E0: D7EDD55A4A6B  MOVE.B     -10918(A5),107(PC,D4.L)        ; A5-10918
16E6: 0004670A      ORI.B      #$670A,D4
16EA: 4A2B0006      TST.B      6(A3)
16EE: 6604          BNE.S      $16F4
16F0: 526DF682      MOVEA.B    -2430(A5),A1
16F4: 5246          MOVEA.B    D6,A1
16F6: 508C          MOVE.B     A4,(A0)
16F8: BC6DD55E      MOVEA.W    -10914(A5),A6
16FC: 6DE0          BLT.S      $16DE
16FE: 700A          MOVEQ      #10,D0
1700: C1EDF682      ANDA.L     -2430(A5),A0
1704: 2F00          MOVE.L     D0,-(A7)
1706: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
170A: 2B40F674      MOVE.L     D0,-2444(A5)
170E: 3A2DF682      MOVE.W     -2430(A5),D5                   ; A5-2430
1712: 48C5          EXT.L      D5
1714: 426DF682      CLR.W      -2430(A5)
1718: 7C01          MOVEQ      #1,D6
171A: 387C0008      MOVEA.W    #$0008,A4
171E: 588F          MOVE.B     A7,(A4)
1720: 6064          BRA.S      $1786
1722: 264C          MOVEA.L    A4,A3
1724: D7EDD55A4A6B  MOVE.B     -10918(A5),107(PC,D4.L)        ; A5-10918
172A: 00046754      ORI.B      #$6754,D4
172E: 4A2B0006      TST.B      6(A3)
1732: 664E          BNE.S      $1782
1734: 306B0002      MOVEA.W    2(A3),A0
1738: 700A          MOVEQ      #10,D0
173A: C1EDF682      ANDA.L     -2430(A5),A0
173E: D1EDD560D0AD  MOVE.B     -10912(A5),$D0AD.W             ; A5-10912
1744: F6742240      MOVEA.W    64(A4,D2.W*2),A3
1748: 2288          MOVE.L     A0,(A1)
174A: 2448          MOVEA.L    A0,A2
174C: 600C          BRA.S      $175A
174E: 1012          MOVE.B     (A2),D0
1750: B02AFFFF      MOVE.W     -1(A2),D0
1754: 6C04          BGE.S      $175A
1756: 4EAD01A2      JSR        418(A5)                        ; JT[418]
175A: 528A          MOVE.B     A2,(A1)
175C: 4A12          TST.B      (A2)
175E: 66EE          BNE.S      $174E
1760: 700A          MOVEQ      #10,D0
1762: C1EDF682      ANDA.L     -2430(A5),A0
1766: D0ADF674      MOVE.B     -2444(A5),(A0)                 ; A5-2444
176A: 2E00          MOVE.L     D0,D7
176C: 2047          MOVEA.L    D7,A0
176E: 42A80004      CLR.L      4(A0)
1772: 202DD55A      MOVE.L     -10918(A5),D0                  ; A5-10918
1776: 2047          MOVEA.L    D7,A0
1778: 317408040008  MOVE.W     4(A4,D0.L),8(A0)
177E: 526DF682      MOVEA.B    -2430(A5),A1
1782: 5246          MOVEA.B    D6,A1
1784: 508C          MOVE.B     A4,(A0)
1786: BC6DD55E      MOVEA.W    -10914(A5),A6
178A: 6D96          BLT.S      $1722
178C: 306DF682      MOVEA.W    -2430(A5),A0
1790: BA88          MOVE.W     A0,(A5)
1792: 6704          BEQ.S      $1798
1794: 4EAD01A2      JSR        418(A5)                        ; JT[418]
1798: 7A00          MOVEQ      #0,D5
179A: CBFC00035245  ANDA.L     #$00035245,A5
17A0: BA6DF682      MOVEA.W    -2430(A5),A5
17A4: 6DF4          BLT.S      $179A
17A6: 48C5          EXT.L      D5
17A8: 8BFC00033805  ORA.L      #$00033805,A5
17AE: 700A          MOVEQ      #10,D0
17B0: C1C4          ANDA.L     D4,A0
17B2: 2840          MOVEA.L    D0,A4
17B4: 6070          BRA.S      $1826
17B6: 204C          MOVEA.L    A4,A0
17B8: D1EDF67443ED  MOVE.B     -2444(A5),$43ED.W              ; A5-2444
17BE: F67822D8      MOVEA.W    $22D8.W,A3
17C2: 22D8          MOVE.L     (A0)+,(A1)+
17C4: 32D8          MOVE.W     (A0)+,(A1)+
17C6: 3C04          MOVE.W     D4,D6
17C8: 6020          BRA.S      $17EA
17CA: 3006          MOVE.W     D6,D0
17CC: 9045          MOVEA.B    D5,A0
17CE: C1FC000AD0AD  ANDA.L     #$000AD0AD,A0
17D4: F6742040      MOVEA.W    64(A4,D2.W),A3
17D8: 700A          MOVEQ      #10,D0
17DA: C1C6          ANDA.L     D6,A0
17DC: D0ADF674      MOVE.B     -2444(A5),(A0)                 ; A5-2444
17E0: 2240          MOVEA.L    D0,A1
17E2: 22D8          MOVE.L     (A0)+,(A1)+
17E4: 22D8          MOVE.L     (A0)+,(A1)+
17E6: 32D8          MOVE.W     (A0)+,(A1)+
17E8: 9C45          MOVEA.B    D5,A6
17EA: BA46          MOVEA.W    D6,A5
17EC: 6E1E          BGT.S      $180C
17EE: 3006          MOVE.W     D6,D0
17F0: 9045          MOVEA.B    D5,A0
17F2: C1FC000AD0AD  ANDA.L     #$000AD0AD,A0
17F8: F6742040      MOVEA.W    64(A4,D2.W),A3
17FC: 2F10          MOVE.L     (A0),-(A7)
17FE: 2F2DF678      MOVE.L     -2440(A5),-(A7)                ; A5-2440
1802: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
1806: 4A40          TST.W      D0
1808: 508F          MOVE.B     A7,(A0)
180A: 6DBE          BLT.S      $17CA
180C: 700A          MOVEQ      #10,D0
180E: C1C6          ANDA.L     D6,A0
1810: D0ADF674      MOVE.B     -2444(A5),(A0)                 ; A5-2444
1814: 2040          MOVEA.L    D0,A0
1816: 43EDF678      LEA        -2440(A5),A1                   ; A5-2440
181A: 20D9          MOVE.L     (A1)+,(A0)+
181C: 20D9          MOVE.L     (A1)+,(A0)+
181E: 30D9          MOVE.W     (A1)+,(A0)+
1820: 5244          MOVEA.B    D4,A1
1822: 49EC000A      LEA        10(A4),A4
1826: B86DF682      MOVEA.W    -2430(A5),A4
182A: 6D8A          BLT.S      $17B6
182C: 0C450001      CMPI.W     #$0001,D5
1830: 6E00FF74      BGT.W      $17A8
1834: 7A01          MOVEQ      #1,D5
1836: 387C000A      MOVEA.W    #$000A,A4
183A: 602C          BRA.S      $1868
183C: 70FF          MOVEQ      #-1,D0
183E: D045          MOVEA.B    D5,A0
1840: C1FC000AD0AD  ANDA.L     #$000AD0AD,A0
1846: F6742040      MOVEA.W    64(A4,D2.W),A3
184A: 2F10          MOVE.L     (A0),-(A7)
184C: 204C          MOVEA.L    A4,A0
184E: D1EDF6742F10  MOVE.B     -2444(A5),$2F10.W              ; A5-2444
1854: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
1858: 4A40          TST.W      D0
185A: 508F          MOVE.B     A7,(A0)
185C: 6E04          BGT.S      $1862
185E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
1862: 5245          MOVEA.B    D5,A1
1864: 49EC000A      LEA        10(A4),A4
1868: BA6DF682      MOVEA.W    -2430(A5),A5
186C: 6DCE          BLT.S      $183C
186E: 7A00          MOVEQ      #0,D5
1870: 7CFF          MOVEQ      #-1,D6
1872: DC6DF682      MOVEA.B    -2430(A5),A6
1876: 206E000C      MOVEA.L    12(A6),A0
187A: 4290          CLR.L      (A0)
187C: 6054          BRA.S      $18D2
187E: 3806          MOVE.W     D6,D4
1880: D845          MOVEA.B    D5,A4
1882: E244          MOVEA.L    D4,A1
1884: 700A          MOVEQ      #10,D0
1886: C1C4          ANDA.L     D4,A0
1888: D0ADF674      MOVE.B     -2444(A5),(A0)                 ; A5-2444
188C: 2040          MOVEA.L    D0,A0
188E: 2F10          MOVE.L     (A0),-(A7)
1890: 2F2E0008      MOVE.L     8(A6),-(A7)
1894: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
1898: 3600          MOVE.W     D0,D3
189A: 4A43          TST.W      D3
189C: 508F          MOVE.B     A7,(A0)
189E: 6624          BNE.S      $18C4
18A0: 700A          MOVEQ      #10,D0
18A2: C1C4          ANDA.L     D4,A0
18A4: D0ADF674      MOVE.B     -2444(A5),(A0)                 ; A5-2444
18A8: 2840          MOVEA.L    D0,A4
18AA: 41EC0004      LEA        4(A4),A0
18AE: 226E000C      MOVEA.L    12(A6),A1
18B2: 2288          MOVE.L     A0,(A1)
18B4: 701C          MOVEQ      #28,D0
18B6: C1EC0008      ANDA.L     8(A4),A0
18BA: 206DD564      MOVEA.L    -10908(A5),A0
18BE: 3030081A      MOVE.W     26(A0,D0.L),D0
18C2: 6014          BRA.S      $18D8
18C4: 4A43          TST.W      D3
18C6: 6C06          BGE.S      $18CE
18C8: 7CFF          MOVEQ      #-1,D6
18CA: DC44          MOVEA.B    D4,A6
18CC: 6004          BRA.S      $18D2
18CE: 7A01          MOVEQ      #1,D5
18D0: DA44          MOVEA.B    D4,A5
18D2: BA46          MOVEA.W    D6,A5
18D4: 6FA8          BLE.S      $187E
18D6: 7000          MOVEQ      #0,D0
18D8: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
18DC: 4E5E          UNLK       A6
18DE: 4E75          RTS        


; ======= Function at 0x18E0 =======
18E0: 4E560000      LINK       A6,#0
18E4: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
18E8: 3E2E0008      MOVE.W     8(A6),D7
18EC: 2007          MOVE.L     D7,D0
18EE: 48C0          EXT.L      D0
18F0: E58849ED      MOVE.L     A0,-19(A2,D4.L)
18F4: B1E0D08C      MOVE.W     -(A0),$D08C.W
18F8: 2840          MOVEA.L    D0,A4
18FA: 2014          MOVE.L     (A4),D0
18FC: B0ADB1DC      MOVE.W     -20004(A5),(A0)                ; A5-20004
1900: 6736          BEQ.S      $1938
1902: 28ADB1DC      MOVE.L     -20004(A5),(A4)                ; A5-20004
1906: 302E000A      MOVE.W     10(A6),D0
190A: 204D          MOVEA.L    A5,A0
190C: D0C7          MOVE.B     D7,(A0)+
190E: D0C7          MOVE.B     D7,(A0)+
1910: D168BBF47C00  MOVE.B     -17420(A0),31744(A0)
1916: 49ED99D6      LEA        -26154(A5),A4                  ; A5-26154
191A: 6016          BRA.S      $1932
191C: 3F2E000A      MOVE.W     10(A6),-(A7)
1920: 302C0002      MOVE.W     2(A4),D0
1924: 8047          OR.W       D7,D0
1926: 3F00          MOVE.W     D0,-(A7)
1928: 4EBAFFB6      JSR        -74(PC)
192C: 588F          MOVE.B     A7,(A4)
192E: 5246          MOVEA.B    D6,A1
1930: 588C          MOVE.B     A4,(A4)
1932: 0C460007      CMPI.W     #$0007,D6
1936: 6DE4          BLT.S      $191C
1938: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
193C: 4E5E          UNLK       A6
193E: 4E75          RTS        
