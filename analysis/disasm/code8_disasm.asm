;======================================================================
; CODE 8 Disassembly
; File: /tmp/maven_code_8.bin
; Header: JT offset=328, JT entries=3
; Code size: 2326 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FFC0      LINK       A6,#-64                        ; frame=64
0004: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0008: 266E0008      MOVEA.L    8(A6),A3
000C: 42AEFFDC      CLR.L      -36(A6)
0010: 7E01          MOVEQ      #1,D7
0012: 42AEFFCC      CLR.L      -52(A6)
0016: 41EB0010      LEA        16(A3),A0
001A: 2D48FFE4      MOVE.L     A0,-28(A6)
001E: 42AB0014      CLR.L      20(A3)
0022: 7000          MOVEQ      #0,D0
0024: 3740001E      MOVE.W     D0,30(A3)
0028: 3240          MOVEA.W    D0,A1
002A: 27490018      MOVE.L     A1,24(A3)
002E: 2009          MOVE.L     A1,D0
0030: 3740001C      MOVE.W     D0,28(A3)
0034: 3240          MOVEA.W    D0,A1
0036: 2089          MOVE.L     A1,(A0)
0038: 2009          MOVE.L     A1,D0
003A: 3B40BCFA      MOVE.W     D0,-17158(A5)
003E: 3B40BCF8      MOVE.W     D0,-17160(A5)
0042: 3B40BCF6      MOVE.W     D0,-17162(A5)
0046: 3B40BCF4      MOVE.W     D0,-17164(A5)
004A: 3B40B1D6      MOVE.W     D0,-20010(A5)
004E: 162B0020      MOVE.B     32(A3),D3
0052: 4A03          TST.B      D3
0054: 67000312      BEQ.W      $036A
0058: 2D4BFFE0      MOVE.L     A3,-32(A6)
005C: 0C030010      CMPI.B     #$0010,D3
0060: 6C24          BGE.S      $0086
0062: 1C2B0021      MOVE.B     33(A3),D6
0066: 4886          EXT.W      D6
0068: 48C6          EXT.L      D6
006A: 1003          MOVE.B     D3,D0
006C: 4880          EXT.W      D0
006E: C1FC001141ED  ANDA.L     #$001141ED,A0
0074: D76CD088D086  MOVE.B     -12152(A4),-12154(A3)
007A: 2D40FFD4      MOVE.L     D0,-44(A6)
007E: 7201          MOVEQ      #1,D1
0080: 2D41FFD0      MOVE.L     D1,-48(A6)
0084: 602C          BRA.S      $00B2
0086: 1C2B0021      MOVE.B     33(A3),D6
008A: 4886          EXT.W      D6
008C: 48C6          EXT.L      D6
008E: 48780011      PEA        $0011.W
0092: 2F06          MOVE.L     D6,-(A7)
0094: 4EAD0042      JSR        66(A5)                         ; JT[66]
0098: 122B0020      MOVE.B     32(A3),D1
009C: 4881          EXT.W      D1
009E: 41EDD75D      LEA        -10403(A5),A0                  ; A5-10403
00A2: D088          MOVE.B     A0,(A0)
00A4: 3041          MOVEA.W    D1,A0
00A6: D088          MOVE.B     A0,(A0)
00A8: 2D40FFD4      MOVE.L     D0,-44(A6)
00AC: 7211          MOVEQ      #17,D1
00AE: 2D41FFD0      MOVE.L     D1,-48(A6)
00B2: 1803          MOVE.B     D3,D4
00B4: 4884          EXT.W      D4
00B6: 48C4          EXT.L      D4
00B8: 2606          MOVE.L     D6,D3
00BA: 2D4BFFE0      MOVE.L     A3,-32(A6)
00BE: 48780011      PEA        $0011.W
00C2: 2F04          MOVE.L     D4,-(A7)
00C4: 4EAD0042      JSR        66(A5)                         ; JT[66]
00C8: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
00CC: D088          MOVE.B     A0,(A0)
00CE: 2D40FFF4      MOVE.L     D0,-12(A6)
00D2: 48780011      PEA        $0011.W
00D6: 2F04          MOVE.L     D4,-(A7)
00D8: 4EAD0042      JSR        66(A5)                         ; JT[66]
00DC: 41ED97B2      LEA        -26702(A5),A0                  ; A5-26702
00E0: D088          MOVE.B     A0,(A0)
00E2: 2D40FFEC      MOVE.L     D0,-20(A6)
00E6: 122B0020      MOVE.B     32(A3),D1
00EA: 4881          EXT.W      D1
00EC: 3D41FFCA      MOVE.W     D1,-54(A6)
00F0: 48780011      PEA        $0011.W
00F4: 2F04          MOVE.L     D4,-(A7)
00F6: 4EAD0042      JSR        66(A5)                         ; JT[66]
00FA: 41ED9592      LEA        -27246(A5),A0                  ; A5-27246
00FE: D088          MOVE.B     A0,(A0)
0100: 2D40FFF0      MOVE.L     D0,-16(A6)
0104: 48780011      PEA        $0011.W
0108: 2044          MOVEA.L    D4,A0
010A: 4868FFFF      PEA        -1(A0)
010E: 4EAD0042      JSR        66(A5)                         ; JT[66]
0112: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
0116: D088          MOVE.B     A0,(A0)
0118: 2D40FFF8      MOVE.L     D0,-8(A6)
011C: 48780011      PEA        $0011.W
0120: 2044          MOVEA.L    D4,A0
0122: 48680001      PEA        1(A0)
0126: 4EAD0042      JSR        66(A5)                         ; JT[66]
012A: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
012E: D088          MOVE.B     A0,(A0)
0130: 2D40FFFC      MOVE.L     D0,-4(A6)
0134: 48780022      PEA        $0022.W
0138: 2F04          MOVE.L     D4,-(A7)
013A: 4EAD0042      JSR        66(A5)                         ; JT[66]
013E: 41EDBF1E      LEA        -16610(A5),A0                  ; g_state2
0142: D088          MOVE.B     A0,(A0)
0144: 2D40FFE8      MOVE.L     D0,-24(A6)
0148: 2403          MOVE.L     D3,D2
014A: D482          MOVE.B     D2,(A2)
014C: 2D42FFD8      MOVE.L     D2,-40(A6)
0150: 600001A4      BRA.W      $02F8
0154: 206EFFF4      MOVEA.L    -12(A6),A0
0158: 4A303800      TST.B      0(A0,D3.L)
015C: 6600016E      BNE.W      $02CE
0160: 526DB1D6      MOVEA.B    -20010(A5),A1
0164: 206EFFEC      MOVEA.L    -20(A6),A0
0168: 10303800      MOVE.B     0(A0,D3.L),D0
016C: 4880          EXT.W      D0
016E: 3240          MOVEA.W    D0,A1
0170: 2F09          MOVE.L     A1,-(A7)
0172: 2F07          MOVE.L     D7,-(A7)
0174: 4EAD0042      JSR        66(A5)                         ; JT[66]
0178: 2E00          MOVE.L     D0,D7
017A: 226EFFD4      MOVEA.L    -44(A6),A1
017E: 7000          MOVEQ      #0,D0
0180: 1011          MOVE.B     (A1),D0
0182: 204D          MOVEA.L    A5,A0
0184: D1C04A28      MOVE.B     D0,$4A28.W
0188: FBD8          MOVE.W     (A0)+,???
018A: 6A1E          BPL.S      $01AA
018C: 4A6DBCF4      TST.W      -17164(A5)
0190: 660C          BNE.S      $019E
0192: 3B6EFFCABCF4  MOVE.W     -54(A6),-17164(A5)
0198: 3B43BCF8      MOVE.W     D3,-17160(A5)
019C: 600A          BRA.S      $01A8
019E: 3B6EFFCABCF6  MOVE.W     -54(A6),-17162(A5)
01A4: 3B43BCFA      MOVE.W     D3,-17158(A5)
01A8: 7C3F          MOVEQ      #63,D6
01AA: 204D          MOVEA.L    A5,A0
01AC: D1C6D1C6      MOVE.B     D6,$D1C6.W
01B0: 3D689412FFC8  MOVE.W     -27630(A0),-56(A6)
01B6: 206EFFF0      MOVEA.L    -16(A6),A0
01BA: 10303800      MOVE.B     0(A0,D3.L),D0
01BE: 4880          EXT.W      D0
01C0: C1EEFFC8      ANDA.L     -56(A6),A0
01C4: 48C0          EXT.L      D0
01C6: D1AEFFDC7010  MOVE.B     -36(A6),16(A0,D7.W)
01CC: B084          MOVE.W     D4,(A0)
01CE: 670A          BEQ.S      $01DA
01D0: 206EFFF8      MOVEA.L    -8(A6),A0
01D4: 4A303800      TST.B      0(A0,D3.L)
01D8: 6614          BNE.S      $01EE
01DA: 700F          MOVEQ      #15,D0
01DC: B084          MOVE.W     D4,(A0)
01DE: 67000108      BEQ.W      $02EA
01E2: 206EFFFC      MOVEA.L    -4(A6),A0
01E6: 4A303800      TST.B      0(A0,D3.L)
01EA: 670000FC      BEQ.W      $02EA
01EE: 42AEFFC4      CLR.L      -60(A6)
01F2: 2A04          MOVE.L     D4,D5
01F4: 5385246E      MOVE.B     D5,110(A1,D2.W*4)
01F8: FFD8          MOVE.W     (A0)+,???
01FA: 48780022      PEA        $0022.W
01FE: 2F05          MOVE.L     D5,-(A7)
0200: 4EAD0042      JSR        66(A5)                         ; JT[66]
0204: 49EDBF1E      LEA        -16610(A5),A4                  ; g_state2
0208: D08C          MOVE.B     A4,(A0)
020A: 2840          MOVEA.L    D0,A4
020C: 48780011      PEA        $0011.W
0210: 2F05          MOVE.L     D5,-(A7)
0212: 4EAD0042      JSR        66(A5)                         ; JT[66]
0216: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
021A: D088          MOVE.B     A0,(A0)
021C: 2D40FFC0      MOVE.L     D0,-64(A6)
0220: 6018          BRA.S      $023A
0222: 204C          MOVEA.L    A4,A0
0224: D1CA3010      MOVE.B     A2,$3010.W
0228: 48C0          EXT.L      D0
022A: D1AEFFC45385  MOVE.B     -60(A6),-123(A0,D5.W*2)
0230: 49ECFFDE      LEA        -34(A4),A4
0234: 70EF          MOVEQ      #-17,D0
0236: D1AEFFC0700F  MOVE.B     -64(A6),15(A0,D7.W)
023C: B085          MOVE.W     D5,(A0)
023E: 670A          BEQ.S      $024A
0240: 206EFFC0      MOVEA.L    -64(A6),A0
0244: 4A303800      TST.B      0(A0,D3.L)
0248: 66D8          BNE.S      $0222
024A: 2A04          MOVE.L     D4,D5
024C: 5285          MOVE.B     D5,(A1)
024E: 48780022      PEA        $0022.W
0252: 2F05          MOVE.L     D5,-(A7)
0254: 4EAD0042      JSR        66(A5)                         ; JT[66]
0258: 49EDBF1E      LEA        -16610(A5),A4                  ; g_state2
025C: D08C          MOVE.B     A4,(A0)
025E: 2840          MOVEA.L    D0,A4
0260: 48780011      PEA        $0011.W
0264: 2F05          MOVE.L     D5,-(A7)
0266: 4EAD0042      JSR        66(A5)                         ; JT[66]
026A: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
026E: D088          MOVE.B     A0,(A0)
0270: 2D40FFC0      MOVE.L     D0,-64(A6)
0274: 6018          BRA.S      $028E
0276: 204C          MOVEA.L    A4,A0
0278: D1CA3010      MOVE.B     A2,$3010.W
027C: 48C0          EXT.L      D0
027E: D1AEFFC45285  MOVE.B     -60(A6),-123(A0,D5.W*2)
0284: 49EC0022      LEA        34(A4),A4
0288: 7011          MOVEQ      #17,D0
028A: D1AEFFC07010  MOVE.B     -64(A6),16(A0,D7.W)
0290: B085          MOVE.W     D5,(A0)
0292: 670A          BEQ.S      $029E
0294: 206EFFC0      MOVEA.L    -64(A6),A0
0298: 4A303800      TST.B      0(A0,D3.L)
029C: 66D8          BNE.S      $0276
029E: 206EFFEC      MOVEA.L    -20(A6),A0
02A2: 10303800      MOVE.B     0(A0,D3.L),D0
02A6: 4880          EXT.W      D0
02A8: 3240          MOVEA.W    D0,A1
02AA: 2F09          MOVE.L     A1,-(A7)
02AC: 226EFFF0      MOVEA.L    -16(A6),A1
02B0: 10313800      MOVE.B     0(A1,D3.L),D0
02B4: 4880          EXT.W      D0
02B6: C1EEFFC8      ANDA.L     -56(A6),A0
02BA: 48C0          EXT.L      D0
02BC: D0AEFFC4      MOVE.B     -60(A6),(A0)
02C0: 2F00          MOVE.L     D0,-(A7)
02C2: 4EAD0042      JSR        66(A5)                         ; JT[66]
02C6: D1AEFFCC601C  MOVE.B     -52(A6),28(A0,D6.W)
02CC: 246EFFD8      MOVEA.L    -40(A6),A2
02D0: 204A          MOVEA.L    A2,A0
02D2: D1EEFFE84A50  MOVE.B     -24(A6),$4A50.W
02D8: 670E          BEQ.S      $02E8
02DA: 204A          MOVEA.L    A2,A0
02DC: D1EEFFE83010  MOVE.B     -24(A6),$3010.W
02E2: 48C0          EXT.L      D0
02E4: D1AEFFDC5283  MOVE.B     -36(A6),-125(A0,D5.W*2)
02EA: 54AEFFD8      MOVE.B     -40(A6),(A2)
02EE: 202EFFD0      MOVE.L     -48(A6),D0
02F2: D1AEFFD4206E  MOVE.B     -44(A6),110(A0,D2.W)
02F8: FFE0          MOVE.W     -(A0),???
02FA: 52AEFFE0      MOVE.B     -32(A6),(A1)
02FE: 1C10          MOVE.B     (A0),D6
0300: 4886          EXT.W      D6
0302: 48C6          EXT.L      D6
0304: 6600FE4E      BNE.W      $0156
0308: 7001          MOVEQ      #1,D0
030A: B087          MOVE.W     D7,(A0)
030C: 671C          BEQ.S      $032A
030E: 7002          MOVEQ      #2,D0
0310: B087          MOVE.W     D7,(A0)
0312: 6716          BEQ.S      $032A
0314: 7003          MOVEQ      #3,D0
0316: B087          MOVE.W     D7,(A0)
0318: 6710          BEQ.S      $032A
031A: 7004          MOVEQ      #4,D0
031C: B087          MOVE.W     D7,(A0)
031E: 670A          BEQ.S      $032A
0320: 7009          MOVEQ      #9,D0
0322: B087          MOVE.W     D7,(A0)
0324: 6704          BEQ.S      $032A
0326: 4EAD01A2      JSR        418(A5)                        ; JT[418]
032A: 2F2EFFDC      MOVE.L     -36(A6),-(A7)
032E: 2F07          MOVE.L     D7,-(A7)
0330: 4EAD0042      JSR        66(A5)                         ; JT[66]
0334: D1AEFFCC486D  MOVE.B     -52(A6),109(A0,D4.L)
033A: C366          AND.W      D1,-(A6)
033C: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0340: 306DB1D6      MOVEA.W    -20010(A5),A0
0344: B088          MOVE.W     A0,(A0)
0346: 588F          MOVE.B     A7,(A4)
0348: 6616          BNE.S      $0360
034A: 0C6D0007B1D6  CMPI.W     #$0007,-20010(A5)
0350: 6608          BNE.S      $035A
0352: 06AE00001388FFCC  ADDI.L     #$00001388,-52(A6)
035A: 377C0001001C  MOVE.W     #$0001,28(A3)
0360: 206EFFE4      MOVEA.L    -28(A6),A0
0364: 20AEFFCC      MOVE.L     -52(A6),(A0)
0368: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
036C: 4E5E          UNLK       A6
036E: 4E75          RTS        


; ======= Function at 0x0370 =======
0370: 4E56FF68      LINK       A6,#-152                       ; frame=152
0374: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0378: 7E01          MOVEQ      #1,D7
037A: 426EFF74      CLR.W      -140(A6)
037E: 426EFF72      CLR.W      -142(A6)
0382: 7C11          MOVEQ      #17,D6
0384: 426EFF70      CLR.W      -144(A6)
0388: 3D7C0011FF6C  MOVE.W     #$0011,-148(A6)
038E: 426EFF6E      CLR.W      -146(A6)
0392: 486DC366      PEA        -15514(A5)                     ; g_field_14
0396: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
039A: 7801          MOVEQ      #1,D4
039C: 49EDD77D      LEA        -10371(A5),A4                  ; A5-10371
03A0: 47EDD89E      LEA        -10082(A5),A3                  ; A5-10082
03A4: 588F          MOVE.B     A7,(A4)
03A6: 6000008A      BRA.W      $0434
03AA: 7601          MOVEQ      #1,D3
03AC: 2D4BFF7A      MOVE.L     A3,-134(A6)
03B0: 244C          MOVEA.L    A4,A2
03B2: 606E          BRA.S      $0422
03B4: 206EFF7A      MOVEA.L    -134(A6),A0
03B8: 10303000      MOVE.B     0(A0,D3.W),D0
03BC: B0323000      MOVE.W     0(A2,D3.W),D0
03C0: 675E          BEQ.S      $0420
03C2: BC44          MOVEA.W    D4,A6
03C4: 6F02          BLE.S      $03C8
03C6: 3C04          MOVE.W     D4,D6
03C8: B86EFF70      MOVEA.W    -144(A6),A4
03CC: 6F04          BLE.S      $03D2
03CE: 3D44FF70      MOVE.W     D4,-144(A6)
03D2: B66EFF6C      MOVEA.W    -148(A6),A3
03D6: 6C04          BGE.S      $03DC
03D8: 3D43FF6C      MOVE.W     D3,-148(A6)
03DC: B66EFF6E      MOVEA.W    -146(A6),A3
03E0: 6F04          BLE.S      $03E6
03E2: 3D43FF6E      MOVE.W     D3,-146(A6)
03E6: 7E00          MOVEQ      #0,D7
03E8: 244C          MOVEA.L    A4,A2
03EA: 10323000      MOVE.B     0(A2,D3.W),D0
03EE: 4880          EXT.W      D0
03F0: 3F00          MOVE.W     D0,-(A7)
03F2: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
03F6: 3A00          MOVE.W     D0,D5
03F8: 41EDA54E      LEA        -23218(A5),A0                  ; A5-23218
03FC: D0C5          MOVE.B     D5,(A0)+
03FE: 2D48FF76      MOVE.L     A0,-138(A6)
0402: 4A10          TST.B      (A0)
0404: 548F          MOVE.B     A7,(A2)
0406: 6612          BNE.S      $041A
0408: 4A2DA58D      TST.B      -23155(A5)
040C: 6606          BNE.S      $0414
040E: 7000          MOVEQ      #0,D0
0410: 600002F8      BRA.W      $070C
0414: 532DA58D      MOVE.B     -23155(A5),-(A1)               ; A5-23155
0418: 6006          BRA.S      $0420
041A: 206EFF76      MOVEA.L    -138(A6),A0
041E: 5310          MOVE.B     (A0),-(A1)
0420: 5243          MOVEA.B    D3,A1
0422: 0C430010      CMPI.W     #$0010,D3
0426: 6D8C          BLT.S      $03B4
0428: 5244          MOVEA.B    D4,A1
042A: 49EC0011      LEA        17(A4),A4
042E: 47EB0011      LEA        17(A3),A3
0432: 0C440010      CMPI.W     #$0010,D4
0436: 6D00FF72      BLT.W      $03AC
043A: 486DC366      PEA        -15514(A5)                     ; g_field_14
043E: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
0442: 4A47          TST.W      D7
0444: 588F          MOVE.B     A7,(A4)
0446: 674C          BEQ.S      $0494
0448: 4A2DA74E      TST.B      -22706(A5)
044C: 6628          BNE.S      $0476
044E: 486DC366      PEA        -15514(A5)                     ; g_field_14
0452: 4EAD08DA      JSR        2266(A5)                       ; JT[2266]
0456: 4A40          TST.W      D0
0458: 588F          MOVE.B     A7,(A4)
045A: 671A          BEQ.S      $0476
045C: 4A6E0008      TST.W      8(A6)
0460: 670E          BEQ.S      $0470
0462: 3F3C03F0      MOVE.W     #$03F0,-(A7)
0466: 4EAD0C6A      JSR        3178(A5)                       ; JT[3178]
046A: 5340548F      MOVE.B     D0,21647(A1)
046E: 6606          BNE.S      $0476
0470: 7000          MOVEQ      #0,D0
0472: 60000296      BRA.W      $070C
0476: 48780022      PEA        $0022.W
047A: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
047E: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0482: 486DA74E      PEA        -22706(A5)                     ; A5-22706
0486: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
048A: 4EAD07F2      JSR        2034(A5)                       ; JT[2034]
048E: 7001          MOVEQ      #1,D0
0490: 60000278      BRA.W      $070C
0494: 48780022      PEA        $0022.W
0498: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
049C: 4EAD01AA      JSR        426(A5)                        ; JT[426]
04A0: 302EFF6E      MOVE.W     -146(A6),D0
04A4: B06EFF6C      MOVEA.W    -148(A6),A0
04A8: 508F          MOVE.B     A7,(A0)
04AA: 6F1C          BLE.S      $04C8
04AC: BC6EFF70      MOVEA.W    -144(A6),A6
04B0: 6C16          BGE.S      $04C8
04B2: 4A6E0008      TST.W      8(A6)
04B6: 670A          BEQ.S      $04C2
04B8: 3F3C03EC      MOVE.W     #$03EC,-(A7)
04BC: 4EAD0C6A      JSR        3178(A5)                       ; JT[3178]
04C0: 548F          MOVE.B     A7,(A2)
04C2: 7000          MOVEQ      #0,D0
04C4: 60000244      BRA.W      $070C
04C8: BC6EFF70      MOVEA.W    -144(A6),A6
04CC: 6704          BEQ.S      $04D2
04CE: 7001          MOVEQ      #1,D0
04D0: 6002          BRA.S      $04D4
04D2: 7000          MOVEQ      #0,D0
04D4: 3E00          MOVE.W     D0,D7
04D6: 302EFF6E      MOVE.W     -146(A6),D0
04DA: B06EFF6C      MOVEA.W    -148(A6),A0
04DE: 6704          BEQ.S      $04E4
04E0: 7001          MOVEQ      #1,D0
04E2: 6002          BRA.S      $04E6
04E4: 7000          MOVEQ      #0,D0
04E6: 3A00          MOVE.W     D0,D5
04E8: 4A47          TST.W      D7
04EA: 6672          BNE.S      $055E
04EC: 4A45          TST.W      D5
04EE: 666E          BNE.S      $055E
04F0: 4A2DBD8E      TST.B      -17010(A5)
04F4: 662A          BNE.S      $0520
04F6: 7011          MOVEQ      #17,D0
04F8: C1C6          ANDA.L     D6,A0
04FA: D08D          MOVE.B     A5,(A0)
04FC: 306EFF6C      MOVEA.W    -148(A6),A0
0500: D1C01D68      MOVE.B     D0,$1D68.W
0504: D76CFF7E422E  MOVE.B     -130(A4),16942(A3)
050A: FF7F4267      MOVE.W     ???,16999(A7)
050E: 486EFF7E      PEA        -130(A6)
0512: 3F2E0008      MOVE.W     8(A6),-(A7)
0516: 4EAD0592      JSR        1426(A5)                       ; JT[1426]
051A: 7000          MOVEQ      #0,D0
051C: 600001EC      BRA.W      $070C
0520: 0C460010      CMPI.W     #$0010,D6
0524: 6716          BEQ.S      $053C
0526: 70FF          MOVEQ      #-1,D0
0528: D046          MOVEA.B    D6,A0
052A: C1FC0011D08D  ANDA.L     #$0011D08D,A0
0530: 306EFF6C      MOVEA.W    -148(A6),A0
0534: D1C04A28      MOVE.B     D0,$4A28.W
0538: BCFE          MOVE.W     ???,(A6)+
053A: 661C          BNE.S      $0558
053C: 0C46000F      CMPI.W     #$000F,D6
0540: 671A          BEQ.S      $055C
0542: 7001          MOVEQ      #1,D0
0544: D046          MOVEA.B    D6,A0
0546: C1FC0011D08D  ANDA.L     #$0011D08D,A0
054C: 306EFF6C      MOVEA.W    -148(A6),A0
0550: D1C04A28      MOVE.B     D0,$4A28.W
0554: BCFE          MOVE.W     ???,(A6)+
0556: 6704          BEQ.S      $055C
0558: 7E01          MOVEQ      #1,D7
055A: 6002          BRA.S      $055E
055C: 7A01          MOVEQ      #1,D5
055E: 3806          MOVE.W     D6,D4
0560: 362EFF6C      MOVE.W     -148(A6),D3
0564: 6004          BRA.S      $056A
0566: 9847          MOVEA.B    D7,A4
0568: 9645          MOVEA.B    D5,A3
056A: 7011          MOVEQ      #17,D0
056C: C1C4          ANDA.L     D4,A0
056E: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
0572: D088          MOVE.B     A0,(A0)
0574: 3043          MOVEA.W    D3,A0
0576: 4A300800      TST.B      0(A0,D0.L)
057A: 66EA          BNE.S      $0566
057C: D847          MOVEA.B    D7,A4
057E: D645          MOVEA.B    D5,A3
0580: 0C450001      CMPI.W     #$0001,D5
0584: 660A          BNE.S      $0590
0586: 1B44A5EE      MOVE.B     D4,-23058(A5)
058A: 1B43A5EF      MOVE.B     D3,-23057(A5)
058E: 600C          BRA.S      $059C
0590: 700F          MOVEQ      #15,D0
0592: D003          MOVE.B     D3,D0
0594: 1B40A5EE      MOVE.B     D0,-23058(A5)
0598: 1B44A5EF      MOVE.B     D4,-23057(A5)
059C: 49EDA5CE      LEA        -23090(A5),A4                  ; g_dawg_info
05A0: 6004          BRA.S      $05A6
05A2: D847          MOVEA.B    D7,A4
05A4: D645          MOVEA.B    D5,A3
05A6: 7011          MOVEQ      #17,D0
05A8: C1C4          ANDA.L     D4,A0
05AA: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
05AE: D088          MOVE.B     A0,(A0)
05B0: 3043          MOVEA.W    D3,A0
05B2: 10300800      MOVE.B     0(A0,D0.L),D0
05B6: 4880          EXT.W      D0
05B8: 3F00          MOVE.W     D0,-(A7)
05BA: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
05BE: 18C0          MOVE.B     D0,(A4)+
05C0: 548F          MOVE.B     A7,(A2)
05C2: 66DE          BNE.S      $05A2
05C4: 486EFF7E      PEA        -130(A6)
05C8: 486DC366      PEA        -15514(A5)                     ; g_field_14
05CC: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
05D0: 4EAD098A      JSR        2442(A5)                       ; JT[2442]
05D4: 2B40A5DE      MOVE.L     D0,-23074(A5)
05D8: 3006          MOVE.W     D6,D0
05DA: 9047          MOVEA.B    D7,A0
05DC: C1FC0011322E  ANDA.L     #$0011322E,A0
05E2: FF6C924541ED  MOVE.W     -28091(A4),16877(A7)
05E8: D76CD0883041  MOVE.B     -12152(A4),12353(A3)
05EE: 4A300800      TST.B      0(A0,D0.L)
05F2: 4FEF000C      LEA        12(A7),A7
05F6: 6706          BEQ.S      $05FE
05F8: 3D7C0001FF72  MOVE.W     #$0001,-142(A6)
05FE: 3806          MOVE.W     D6,D4
0600: 362EFF6C      MOVE.W     -148(A6),D3
0604: 60000096      BRA.W      $069E
0608: 0C440008      CMPI.W     #$0008,D4
060C: 660C          BNE.S      $061A
060E: 0C430008      CMPI.W     #$0008,D3
0612: 6606          BNE.S      $061A
0614: 3D7C0001FF74  MOVE.W     #$0001,-140(A6)
061A: 7011          MOVEQ      #17,D0
061C: C1C4          ANDA.L     D4,A0
061E: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
0622: D088          MOVE.B     A0,(A0)
0624: 3043          MOVEA.W    D3,A0
0626: 1D700800FF69  MOVE.B     0(A0,D0.L),-151(A6)
062C: 4A2EFF69      TST.B      -151(A6)
0630: 6616          BNE.S      $0648
0632: 4A6E0008      TST.W      8(A6)
0636: 670A          BEQ.S      $0642
0638: 3F3C03EB      MOVE.W     #$03EB,-(A7)
063C: 4EAD0C6A      JSR        3178(A5)                       ; JT[3178]
0640: 548F          MOVE.B     A7,(A2)
0642: 7000          MOVEQ      #0,D0
0644: 600000C4      BRA.W      $070C
0648: 7011          MOVEQ      #17,D0
064A: C1C4          ANDA.L     D4,A0
064C: 41EDD88D      LEA        -10099(A5),A0                  ; A5-10099
0650: D088          MOVE.B     A0,(A0)
0652: 3043          MOVEA.W    D3,A0
0654: 10300800      MOVE.B     0(A0,D0.L),D0
0658: B02EFF69      MOVE.W     -151(A6),D0
065C: 6734          BEQ.S      $0692
065E: 3004          MOVE.W     D4,D0
0660: D045          MOVEA.B    D5,A0
0662: C1FC00113203  ANDA.L     #$00113203,A0
0668: D247          MOVEA.B    D7,A1
066A: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
066E: D088          MOVE.B     A0,(A0)
0670: 3041          MOVEA.W    D1,A0
0672: 4A300800      TST.B      0(A0,D0.L)
0676: 661A          BNE.S      $0692
0678: 3004          MOVE.W     D4,D0
067A: 9045          MOVEA.B    D5,A0
067C: C1FC00113203  ANDA.L     #$00113203,A0
0682: 9247          MOVEA.B    D7,A1
0684: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
0688: D088          MOVE.B     A0,(A0)
068A: 3041          MOVEA.W    D1,A0
068C: 4A300800      TST.B      0(A0,D0.L)
0690: 6706          BEQ.S      $0698
0692: 3D7C0001FF72  MOVE.W     #$0001,-142(A6)
0698: D847          MOVEA.B    D7,A4
069A: D645          MOVEA.B    D5,A3
069C: B86EFF70      MOVEA.W    -144(A6),A4
06A0: 6E08          BGT.S      $06AA
06A2: B66EFF6E      MOVEA.W    -146(A6),A3
06A6: 6F00FF60      BLE.W      $060A
06AA: 7011          MOVEQ      #17,D0
06AC: C1C4          ANDA.L     D4,A0
06AE: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
06B2: D088          MOVE.B     A0,(A0)
06B4: 3043          MOVEA.W    D3,A0
06B6: 4A300800      TST.B      0(A0,D0.L)
06BA: 6706          BEQ.S      $06C2
06BC: 3D7C0001FF72  MOVE.W     #$0001,-142(A6)
06C2: 4A2DBD8E      TST.B      -17010(A5)
06C6: 671A          BEQ.S      $06E2
06C8: 4A6EFF72      TST.W      -142(A6)
06CC: 6614          BNE.S      $06E2
06CE: 4A6E0008      TST.W      8(A6)
06D2: 670A          BEQ.S      $06DE
06D4: 3F3C03EA      MOVE.W     #$03EA,-(A7)
06D8: 4EAD0C6A      JSR        3178(A5)                       ; JT[3178]
06DC: 548F          MOVE.B     A7,(A2)
06DE: 7000          MOVEQ      #0,D0
06E0: 6028          BRA.S      $070A
06E2: 4A2DBD8E      TST.B      -17010(A5)
06E6: 661A          BNE.S      $0702
06E8: 4A6EFF74      TST.W      -140(A6)
06EC: 6614          BNE.S      $0702
06EE: 4A6E0008      TST.W      8(A6)
06F2: 670A          BEQ.S      $06FE
06F4: 3F3C03E9      MOVE.W     #$03E9,-(A7)
06F8: 4EAD0C6A      JSR        3178(A5)                       ; JT[3178]
06FC: 548F          MOVE.B     A7,(A2)
06FE: 7000          MOVEQ      #0,D0
0700: 6008          BRA.S      $070A
0702: 3F2E0008      MOVE.W     8(A6),-(A7)
0706: 4EAD058A      JSR        1418(A5)                       ; JT[1418]
070A: 4CEE1CF8FF48  MOVEM.L    -184(A6),D3/D4/D5/D6/D7/A2/A3/A4
0710: 4E5E          UNLK       A6
0712: 4E75          RTS        


; ======= Function at 0x0714 =======
0714: 4E56FF74      LINK       A6,#-140                       ; frame=140
0718: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
071C: 286E0008      MOVEA.L    8(A6),A4
0720: 4A2C0020      TST.B      32(A4)
0724: 6640          BNE.S      $0766
0726: 4A6E000E      TST.W      14(A6)
072A: 672A          BEQ.S      $0756
072C: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0730: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0734: 3E80          MOVE.W     D0,(A7)
0736: 486D9172      PEA        -28302(A5)                     ; A5-28302
073A: 486EFF7C      PEA        -132(A6)
073E: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0742: 486EFF7C      PEA        -132(A6)
0746: 4EAD0C62      JSR        3170(A5)                       ; JT[3170]
074A: 3EBC03E8      MOVE.W     #$03E8,(A7)
074E: 4EAD0C6A      JSR        3178(A5)                       ; JT[3178]
0752: 4FEF0010      LEA        16(A7),A7
0756: 2F0C          MOVE.L     A4,-(A7)
0758: 486DB3E6      PEA        -19482(A5)                     ; A5-19482
075C: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0760: 508F          MOVE.B     A7,(A0)
0762: 60000190      BRA.W      $08F6
0766: 0C2C00100020  CMPI.B     #$0010,32(A4)
076C: 6C14          BGE.S      $0782
076E: 1E2C0020      MOVE.B     32(A4),D7
0772: 4887          EXT.W      D7
0774: 1C2C0021      MOVE.B     33(A4),D6
0778: 4886          EXT.W      D6
077A: 7A00          MOVEQ      #0,D5
077C: 47EEFF7A      LEA        -134(A6),A3
0780: 6016          BRA.S      $0798
0782: 1E2C0021      MOVE.B     33(A4),D7
0786: 4887          EXT.W      D7
0788: 1C2C0020      MOVE.B     32(A4),D6
078C: 4886          EXT.W      D6
078E: 0646FFF1      ADDI.W     #$FFF1,D6
0792: 7A01          MOVEQ      #1,D5
0794: 47EEFF78      LEA        -136(A6),A3
0798: 7801          MOVEQ      #1,D4
079A: 9845          MOVEA.B    D5,A4
079C: 3F06          MOVE.W     D6,-(A7)
079E: 3F07          MOVE.W     D7,-(A7)
07A0: 486EFF74      PEA        -140(A6)
07A4: 4EAD03EA      JSR        1002(A5)                       ; JT[1002]
07A8: 4297          CLR.L      (A7)
07AA: 2F3C464F4E54  MOVE.L     #$464F4E54,-(A7)
07B0: 2F2D916E      MOVE.L     -28306(A5),-(A7)               ; A5-28306
07B4: A9A1205F      MOVE.L     -(A1),95(A4,D2.W)
07B8: A04A          MOVEA.L    A2,A0
07BA: 41EDB3E6      LEA        -19482(A5),A0                  ; A5-19482
07BE: 2608          MOVE.L     A0,D3
07C0: 244C          MOVEA.L    A4,A2
07C2: 588F          MOVE.B     A7,(A4)
07C4: 600000C0      BRA.W      $0888
07C8: 7011          MOVEQ      #17,D0
07CA: C1C7          ANDA.L     D7,A0
07CC: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
07D0: D088          MOVE.B     A0,(A0)
07D2: 3046          MOVEA.W    D6,A0
07D4: 4A300800      TST.B      0(A0,D0.L)
07D8: 6722          BEQ.S      $07FC
07DA: 7011          MOVEQ      #17,D0
07DC: C1C7          ANDA.L     D7,A0
07DE: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
07E2: D088          MOVE.B     A0,(A0)
07E4: 3046          MOVEA.W    D6,A0
07E6: 7211          MOVEQ      #17,D1
07E8: C3C7          ANDA.L     D7,A1
07EA: 43EDD88D      LEA        -10099(A5),A1                  ; A5-10099
07EE: D289          MOVE.B     A1,(A1)
07F0: 3246          MOVEA.W    D6,A1
07F2: 12311800      MOVE.B     0(A1,D1.L),D1
07F6: B2300800      MOVE.W     0(A0,D0.L),D1
07FA: 677A          BEQ.S      $0876
07FC: 7011          MOVEQ      #17,D0
07FE: C1C7          ANDA.L     D7,A0
0800: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
0804: D088          MOVE.B     A0,(A0)
0806: 3046          MOVEA.W    D6,A0
0808: 4A300800      TST.B      0(A0,D0.L)
080C: 6604          BNE.S      $0812
080E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0812: 7022          MOVEQ      #34,D0
0814: C1C7          ANDA.L     D7,A0
0816: 41EDBF1E      LEA        -16610(A5),A0                  ; g_state2
081A: D088          MOVE.B     A0,(A0)
081C: 3046          MOVEA.W    D6,A0
081E: D1C84A70      MOVE.B     A0,$4A70.W
0822: 0800670E      BTST       #26382,D0
0826: 1012          MOVE.B     (A2),D0
0828: 4880          EXT.W      D0
082A: 3F00          MOVE.W     D0,-(A7)
082C: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
0830: 548F          MOVE.B     A7,(A2)
0832: 6004          BRA.S      $0838
0834: 1012          MOVE.B     (A2),D0
0836: 4880          EXT.W      D0
0838: 7211          MOVEQ      #17,D1
083A: C3C7          ANDA.L     D7,A1
083C: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
0840: D288          MOVE.B     A0,(A1)
0842: 3046          MOVEA.W    D6,A0
0844: 11801800      MOVE.B     D0,0(A0,D1.L)
0848: 2043          MOVEA.L    D3,A0
084A: 5283          MOVE.B     D3,(A1)
084C: 1080          MOVE.B     D0,(A0)
084E: 7011          MOVEQ      #17,D0
0850: C1C7          ANDA.L     D7,A0
0852: 41EDD76C      LEA        -10388(A5),A0                  ; g_lookup_tbl
0856: D088          MOVE.B     A0,(A0)
0858: 3046          MOVEA.W    D6,A0
085A: 7211          MOVEQ      #17,D1
085C: C3C7          ANDA.L     D7,A1
085E: 43EDD88D      LEA        -10099(A5),A1                  ; A5-10099
0862: D289          MOVE.B     A1,(A1)
0864: 3246          MOVEA.W    D6,A1
0866: 13B008001800  MOVE.B     0(A0,D0.L),0(A1,D1.L)
086C: 3F06          MOVE.W     D6,-(A7)
086E: 3F07          MOVE.W     D7,-(A7)
0870: 4EAD03DA      JSR        986(A5)                        ; JT[986]
0874: 588F          MOVE.B     A7,(A4)
0876: DE45          MOVEA.B    D5,A7
0878: DC44          MOVEA.B    D4,A6
087A: 528A          MOVE.B     A2,(A1)
087C: 206DDE80      MOVEA.L    -8576(A5),A0
0880: 3028000A      MOVE.W     10(A0),D0
0884: D1534A12      MOVE.B     (A3),18962(A0)
0888: 6600FF3E      BNE.W      $07CA
088C: 42A7          CLR.L      -(A7)
088E: 2F3C464F4E54  MOVE.L     #$464F4E54,-(A7)
0894: 2F2D916E      MOVE.L     -28306(A5),-(A7)               ; A5-28306
0898: A9A1205F      MOVE.L     -(A1),95(A4,D2.W)
089C: A049          MOVEA.L    A1,A0
089E: 206DDE80      MOVEA.L    -8576(A5),A0
08A2: 3028000A      MOVE.W     10(A0),D0
08A6: 91532043      MOVE.B     (A3),8259(A0)
08AA: 4210          CLR.B      (A0)
08AC: 4A6E000C      TST.W      12(A6)
08B0: 6742          BEQ.S      $08F4
08B2: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
08B6: A873486E      MOVEA.L    110(A3,D4.L),A4
08BA: FF74A8A443EE  MOVE.W     -92(A4,A2.L),17390(A7)
08C0: FFFC307C      MOVE.W     #$307C,???
08C4: 000FA03B      ORI.B      #$A03B,A7
08C8: 2280          MOVE.L     D0,(A1)
08CA: 486EFF74      PEA        -140(A6)
08CE: A8A4          MOVE.L     -(A4),(A4)
08D0: 43EEFFFC      LEA        -4(A6),A1
08D4: 307C000F      MOVEA.W    #$000F,A0
08D8: A03B2280      MOVE.L     -128(PC,D2.W),D0
08DC: 486EFF74      PEA        -140(A6)
08E0: A8A4          MOVE.L     -(A4),(A4)
08E2: 43EEFFFC      LEA        -4(A6),A1
08E6: 307C000F      MOVEA.W    #$000F,A0
08EA: A03B2280      MOVE.L     -128(PC,D2.W),D0
08EE: 486EFF74      PEA        -140(A6)
08F2: A8A4          MOVE.L     -(A4),(A4)
08F4: 48780121      PEA        $0121.W
08F8: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
08FC: 486DD88D      PEA        -10099(A5)                     ; A5-10099
0900: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0904: 4EAD053A      JSR        1338(A5)                       ; JT[1338]
0908: 4EAD03C2      JSR        962(A5)                        ; JT[962]
090C: 4CEE1CF8FF54  MOVEM.L    -172(A6),D3/D4/D5/D6/D7/A2/A3/A4
0912: 4E5E          UNLK       A6
0914: 4E75          RTS        
