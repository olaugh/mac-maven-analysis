;======================================================================
; CODE 15 Disassembly
; File: /tmp/maven_code_15.bin
; Header: JT offset=736, JT entries=5
; Code size: 3568 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0004: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0008: 266E000C      MOVEA.L    12(A6),A3
000C: 486EFFFC      PEA        -4(A6)
0010: 4267          CLR.W      -(A7)
0012: 2F2E0008      MOVE.L     8(A6),-(A7)
0016: 4EAD0D3A      JSR        3386(A5)                       ; JT[3386]
001A: 2840          MOVEA.L    D0,A4
001C: 200C          MOVE.L     A4,D0
001E: 4FEF000A      LEA        10(A7),A7
0022: 6626          BNE.S      $004A
0024: 2B6D9F28A222  MOVE.L     -24792(A5),-24030(A5)          ; A5-24792
002A: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
0030: C1EDA386      ANDA.L     -23674(A5),A0
0034: 41EDA226      LEA        -24026(A5),A0                  ; g_common
0038: D088          MOVE.B     A0,(A0)
003A: 2040          MOVEA.L    D0,A0
003C: 7001          MOVEQ      #1,D0
003E: 4A40          TST.W      D0
0040: 6602          BNE.S      $0044
0042: 7001          MOVEQ      #1,D0
0044: 4CD8          DC.W       $4CD8
0046: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
004A: 202EFFFC      MOVE.L     -4(A6),D0
004E: E488          MOVE.L     A0,(A2)
0050: 2D40FFFC      MOVE.L     D0,-4(A6)
0054: 55802680      MOVE.B     D0,-128(A2,D2.W*8)
0058: 4A80          TST.L      D0
005A: 6226          BHI.S      $0082
005C: 2B6D9F28A222  MOVE.L     -24792(A5),-24030(A5)          ; A5-24792
0062: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
0068: C1EDA386      ANDA.L     -23674(A5),A0
006C: 41EDA226      LEA        -24026(A5),A0                  ; g_common
0070: D088          MOVE.B     A0,(A0)
0072: 2040          MOVEA.L    D0,A0
0074: 7001          MOVEQ      #1,D0
0076: 4A40          TST.W      D0
0078: 6602          BNE.S      $007C
007A: 7001          MOVEQ      #1,D0
007C: 4CD8          DC.W       $4CD8
007E: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
0082: 2E13          MOVE.L     (A3),D7
0084: 2007          MOVE.L     D7,D0
0086: E5880C34      MOVE.L     A0,52(A2,D0.L*4)
008A: 00610803      ORI.W      #$0803,-(A1)
008E: 6734          BEQ.S      $00C4
0090: 70E6          MOVEQ      #-26,D0
0092: D0AEFFFC      MOVE.B     -4(A6),(A0)
0096: B087          MOVE.W     D7,(A0)
0098: 6326          BLS.S      $00C0
009A: 2B6D9F28A222  MOVE.L     -24792(A5),-24030(A5)          ; A5-24792
00A0: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
00A6: C1EDA386      ANDA.L     -23674(A5),A0
00AA: 41EDA226      LEA        -24026(A5),A0                  ; g_common
00AE: D088          MOVE.B     A0,(A0)
00B0: 2040          MOVEA.L    D0,A0
00B2: 7001          MOVEQ      #1,D0
00B4: 4A40          TST.W      D0
00B6: 6602          BNE.S      $00BA
00B8: 7001          MOVEQ      #1,D0
00BA: 4CD8          DC.W       $4CD8
00BC: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
00C0: 539360BE      MOVE.B     (A3),-66(A1,D6.W)
00C4: 200C          MOVE.L     A4,D0
00C6: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
00CA: 4E5E          UNLK       A6
00CC: 4E75          RTS        


; ======= Function at 0x00CE =======
00CE: 4E560000      LINK       A6,#0
00D2: 48E70700      MOVEM.L    D5/D6/D7,-(SP)                 ; save
00D6: 206E0008      MOVEA.L    8(A6),A0
00DA: 1E10          MOVE.B     (A0),D7
00DC: 2C2DD144      MOVE.L     -11964(A5),D6                  ; A5-11964
00E0: 6034          BRA.S      $0116
00E2: 2006          MOVE.L     D6,D0
00E4: E588D0AD      MOVE.L     A0,-83(A2,A5.W)
00E8: D1402040      MOVE.B     D0,8256(A0)
00EC: 2A10          MOVE.L     (A0),D5
00EE: BE05          MOVE.W     D5,D7
00F0: 6614          BNE.S      $0106
00F2: 2C05          MOVE.L     D5,D6
00F4: 700A          MOVEQ      #10,D0
00F6: E0A6          MOVE.L     -(A6),(A0)
00F8: 6720          BEQ.S      $011A
00FA: 52AE0008      MOVE.B     8(A6),(A1)
00FE: 206E0008      MOVEA.L    8(A6),A0
0102: 1E10          MOVE.B     (A0),D7
0104: 6010          BRA.S      $0116
0106: 08050009      BTST       #9,D5
010A: 6604          BNE.S      $0110
010C: BE05          MOVE.W     D5,D7
010E: 6C04          BGE.S      $0114
0110: 7000          MOVEQ      #0,D0
0112: 6008          BRA.S      $011C
0114: 5286          MOVE.B     D6,(A1)
0116: 4A07          TST.B      D7
0118: 66C8          BNE.S      $00E2
011A: 2006          MOVE.L     D6,D0
011C: 4CDF00E0      MOVEM.L    (SP)+,D5/D6/D7                 ; restore
0120: 4E5E          UNLK       A6
0122: 4E75          RTS        


; ======= Function at 0x0124 =======
0124: 4E560000      LINK       A6,#0
0128: 48E70718      MOVEM.L    D5/D6/D7/A3/A4,-(SP)           ; save
012C: 266E0008      MOVEA.L    8(A6),A3
0130: 7E00          MOVEQ      #0,D7
0132: 49EDD148      LEA        -11960(A5),A4                  ; A5-11960
0136: 2B54D140      MOVE.L     (A4),-11968(A5)
013A: 3B47D548      MOVE.W     D7,-10936(A5)
013E: 204D          MOVEA.L    A5,A0
0140: 2007          MOVE.L     D7,D0
0142: 48C0          EXT.L      D0
0144: E788D1C0      MOVE.L     A0,-64(A3,A5.W)
0148: 2B68D14CD144  MOVE.L     -11956(A0),-11964(A5)
014E: 673A          BEQ.S      $018A
0150: 2F2E000C      MOVE.L     12(A6),-(A7)
0154: 4EBAFF78      JSR        -136(PC)
0158: 2C00          MOVE.L     D0,D6
015A: 4A86          TST.L      D6
015C: 588F          MOVE.B     A7,(A4)
015E: 6724          BEQ.S      $0184
0160: 2006          MOVE.L     D6,D0
0162: 5286          MOVE.B     D6,(A1)
0164: E588D0AD      MOVE.L     A0,-83(A2,A5.W)
0168: D1402040      MOVE.B     D0,8256(A0)
016C: 2A10          MOVE.L     (A0),D5
016E: 1685          MOVE.B     D5,(A3)
0170: 4A6E0010      TST.W      16(A6)
0174: 6706          BEQ.S      $017C
0176: 08050008      BTST       #8,D5
017A: 6702          BEQ.S      $017E
017C: 528B          MOVE.B     A3,(A1)
017E: 08050009      BTST       #9,D5
0182: 67DC          BEQ.S      $0160
0184: 5287          MOVE.B     D7,(A1)
0186: 508C          MOVE.B     A4,(A0)
0188: 60AC          BRA.S      $0136
018A: 4213          CLR.B      (A3)
018C: 4CDF18E0      MOVEM.L    (SP)+,D5/D6/D7/A3/A4           ; restore
0190: 4E5E          UNLK       A6
0192: 4E75          RTS        


; ======= Function at 0x0194 =======
0194: 4E560000      LINK       A6,#0
0198: 2F07          MOVE.L     D7,-(A7)
019A: 7E00          MOVEQ      #0,D7
019C: 6018          BRA.S      $01B6
019E: 2F2E0008      MOVE.L     8(A6),-(A7)
01A2: 3047          MOVEA.W    D7,A0
01A4: 2F08          MOVE.L     A0,-(A7)
01A6: 4EBA001C      JSR        28(PC)
01AA: 4A80          TST.L      D0
01AC: 508F          MOVE.B     A7,(A0)
01AE: 6704          BEQ.S      $01B4
01B0: 7001          MOVEQ      #1,D0
01B2: 600A          BRA.S      $01BE
01B4: 5247          MOVEA.B    D7,A1
01B6: BE6DD548      MOVEA.W    -10936(A5),A7
01BA: 6DE2          BLT.S      $019E
01BC: 7000          MOVEQ      #0,D0
01BE: 2E1F          MOVE.L     (A7)+,D7
01C0: 4E5E          UNLK       A6
01C2: 4E75          RTS        


; ======= Function at 0x01C4 =======
01C4: 4E560000      LINK       A6,#0
01C8: 48E70708      MOVEM.L    D5/D6/D7/A4,-(SP)              ; save
01CC: 2C2E0008      MOVE.L     8(A6),D6
01D0: 206E000C      MOVEA.L    12(A6),A0
01D4: 1E10          MOVE.B     (A0),D7
01D6: 224D          MOVEA.L    A5,A1
01D8: 2006          MOVE.L     D6,D0
01DA: E788D3C0      MOVE.L     A0,-64(A3,A5.W*2)
01DE: 2869D148      MOVEA.L    -11960(A1),A4
01E2: 224D          MOVEA.L    A5,A1
01E4: 2006          MOVE.L     D6,D0
01E6: E788D3C0      MOVE.L     A0,-64(A3,A5.W*2)
01EA: 2C29D14C      MOVE.L     -11956(A1),D6
01EE: 2006          MOVE.L     D6,D0
01F0: E5882A34      MOVE.L     A0,52(A2,D2.L*2)
01F4: 0800BE05      BTST       #48645,D0
01F8: 6622          BNE.S      $021C
01FA: 52AE000C      MOVE.B     12(A6),(A1)
01FE: 206E000C      MOVEA.L    12(A6),A0
0202: 1E10          MOVE.B     (A0),D7
0204: 660A          BNE.S      $0210
0206: 2005          MOVE.L     D5,D0
0208: 028000000100  ANDI.L     #$00000100,D0
020E: 6022          BRA.S      $0232
0210: 2C05          MOVE.L     D5,D6
0212: 700A          MOVEQ      #10,D0
0214: E0A6          MOVE.L     -(A6),(A0)
0216: 66D6          BNE.S      $01EE
0218: 7000          MOVEQ      #0,D0
021A: 6016          BRA.S      $0232
021C: 08050009      BTST       #9,D5
0220: 6604          BNE.S      $0226
0222: BE05          MOVE.W     D5,D7
0224: 6C04          BGE.S      $022A
0226: 7000          MOVEQ      #0,D0
0228: 6008          BRA.S      $0232
022A: 5286          MOVE.B     D6,(A1)
022C: 60C0          BRA.S      $01EE
022E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0232: 4CDF10E0      MOVEM.L    (SP)+,D5/D6/D7/A4              ; restore
0236: 4E5E          UNLK       A6
0238: 4E75          RTS        


; ======= Function at 0x023A =======
023A: 4E560000      LINK       A6,#0
023E: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0242: 7E00          MOVEQ      #0,D7
0244: 49EDD148      LEA        -11960(A5),A4                  ; A5-11960
0248: 6018          BRA.S      $0262
024A: 2F2E0008      MOVE.L     8(A6),-(A7)
024E: 2F07          MOVE.L     D7,-(A7)
0250: 4EBAFF72      JSR        -142(PC)
0254: 4A80          TST.L      D0
0256: 508F          MOVE.B     A7,(A0)
0258: 6704          BEQ.S      $025E
025A: 7001          MOVEQ      #1,D0
025C: 600C          BRA.S      $026A
025E: 5287          MOVE.B     D7,(A1)
0260: 508C          MOVE.B     A4,(A0)
0262: 4AAC0004      TST.L      4(A4)
0266: 66E2          BNE.S      $024A
0268: 7000          MOVEQ      #0,D0
026A: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
026E: 4E5E          UNLK       A6
0270: 4E75          RTS        


; ======= Function at 0x0272 =======
0272: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0276: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
027A: 382E000E      MOVE.W     14(A6),D4
027E: 286E001C      MOVEA.L    28(A6),A4
0282: 4A6E000C      TST.W      12(A6)
0286: 661E          BNE.S      $02A6
0288: 4AAE0014      TST.L      20(A6)
028C: 6712          BEQ.S      $02A0
028E: 2F2E0024      MOVE.L     36(A6),-(A7)
0292: 2F0C          MOVE.L     A4,-(A7)
0294: 206E0018      MOVEA.L    24(A6),A0
0298: 4E90          JSR        (A0)
029A: 508F          MOVE.B     A7,(A0)
029C: 600000B0      BRA.W      $0350
02A0: 7000          MOVEQ      #0,D0
02A2: 600000AA      BRA.W      $0350
02A6: 4AAE0010      TST.L      16(A6)
02AA: 6606          BNE.S      $02B2
02AC: 7000          MOVEQ      #0,D0
02AE: 6000009E      BRA.W      $0350
02B2: 2004          MOVE.L     D4,D0
02B4: 48C0          EXT.L      D0
02B6: E588D0AE      MOVE.L     A0,-82(A2,A5.W)
02BA: 00202640      ORI.B      #$2640,-(A0)
02BE: 3444          MOVEA.W    D4,A2
02C0: D5CC7E01      MOVE.B     A4,32257(PC)
02C4: DE44          MOVEA.B    D4,A7
02C6: 78FF          MOVEQ      #-1,D4
02C8: D86E000C      MOVEA.B    12(A6),A4
02CC: 202E0010      MOVE.L     16(A6),D0
02D0: 52AE0010      MOVE.B     16(A6),(A1)
02D4: E588D0AD      MOVE.L     A0,-83(A2,A5.W)
02D8: D1402040      MOVE.B     D0,8256(A0)
02DC: 2610          MOVE.L     (A0),D3
02DE: 1C03          MOVE.B     D3,D6
02E0: 4886          EXT.W      D6
02E2: 206E0008      MOVEA.L    8(A6),A0
02E6: 1A10          MOVE.B     (A0),D5
02E8: 1005          MOVE.B     D5,D0
02EA: 4880          EXT.W      D0
02EC: BC40          MOVEA.W    D0,A6
02EE: 6716          BEQ.S      $0306
02F0: 4A05          TST.B      D5
02F2: 6652          BNE.S      $0346
02F4: 4AAE0020      TST.L      32(A6)
02F8: 670C          BEQ.S      $0306
02FA: 709F          MOVEQ      #-97,D0
02FC: D006          MOVE.B     D6,D0
02FE: 7201          MOVEQ      #1,D1
0300: E1A9C2936740  MOVE.L     -15725(A1),64(A0,D6.W*8)
0306: 1486          MOVE.B     D6,(A2)
0308: 2F2E0024      MOVE.L     36(A6),-(A7)
030C: 2F2E0020      MOVE.L     32(A6),-(A7)
0310: 2F0C          MOVE.L     A4,-(A7)
0312: 2F2E0018      MOVE.L     24(A6),-(A7)
0316: 2003          MOVE.L     D3,D0
0318: 028000000100  ANDI.L     #$00000100,D0
031E: 2F00          MOVE.L     D0,-(A7)
0320: 2003          MOVE.L     D3,D0
0322: 720A          MOVEQ      #10,D1
0324: E2A82F00      MOVE.L     12032(A0),(A1)
0328: 3F07          MOVE.W     D7,-(A7)
032A: 3F04          MOVE.W     D4,-(A7)
032C: 206E0008      MOVEA.L    8(A6),A0
0330: 48680001      PEA        1(A0)
0334: 4EBAFF3C      JSR        -196(PC)
0338: 3C00          MOVE.W     D0,D6
033A: 4A46          TST.W      D6
033C: 4FEF0020      LEA        32(A7),A7
0340: 6704          BEQ.S      $0346
0342: 3006          MOVE.W     D6,D0
0344: 6008          BRA.S      $034E
0346: 08030009      BTST       #9,D3
034A: 6780          BEQ.S      $02CC
034C: 7000          MOVEQ      #0,D0
034E: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0352: 4E5E          UNLK       A6
0354: 4E75          RTS        


; ======= Function at 0x0356 =======
0356: 4E56FF00      LINK       A6,#-256                       ; frame=256
035A: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
035E: 7E00          MOVEQ      #0,D7
0360: 302E000C      MOVE.W     12(A6),D0
0364: 49EEFF00      LEA        -256(A6),A4
0368: D8C0          MOVE.B     D0,(A4)+
036A: 2207          MOVE.L     D7,D1
036C: 48C1          EXT.L      D1
036E: E78947ED      MOVE.L     A1,-19(A3,D4.W*8)
0372: D148D28B      MOVE.B     A0,-11637(A0)
0376: 2641          MOVEA.L    D1,A3
0378: 2B53D140      MOVE.L     (A3),-11968(A5)
037C: 3B47D548      MOVE.W     D7,-10936(A5)
0380: 204D          MOVEA.L    A5,A0
0382: 2007          MOVE.L     D7,D0
0384: 48C0          EXT.L      D0
0386: E788D1C0      MOVE.L     A0,-64(A3,A5.W)
038A: 2B68D14CD144  MOVE.L     -11956(A0),-11964(A5)
0390: 673A          BEQ.S      $03CC
0392: 4214          CLR.B      (A4)
0394: 2F2E0016      MOVE.L     22(A6),-(A7)
0398: 2F2E0012      MOVE.L     18(A6),-(A7)
039C: 486EFF00      PEA        -256(A6)
03A0: 2F2E000E      MOVE.L     14(A6),-(A7)
03A4: 42A7          CLR.L      -(A7)
03A6: 2F2DD144      MOVE.L     -11964(A5),-(A7)               ; A5-11964
03AA: 4267          CLR.W      -(A7)
03AC: 3F2E000C      MOVE.W     12(A6),-(A7)
03B0: 2F2E0008      MOVE.L     8(A6),-(A7)
03B4: 4EBAFEBC      JSR        -324(PC)
03B8: 3C00          MOVE.W     D0,D6
03BA: 4A46          TST.W      D6
03BC: 4FEF0020      LEA        32(A7),A7
03C0: 6704          BEQ.S      $03C6
03C2: 3006          MOVE.W     D6,D0
03C4: 6008          BRA.S      $03CE
03C6: 5247          MOVEA.B    D7,A1
03C8: 508B          MOVE.B     A3,(A0)
03CA: 60AC          BRA.S      $0378
03CC: 7000          MOVEQ      #0,D0
03CE: 4CDF18C0      MOVEM.L    (SP)+,D6/D7/A3/A4              ; restore
03D2: 4E5E          UNLK       A6
03D4: 4E75          RTS        


; ======= Function at 0x03D6 =======
03D6: 4E560000      LINK       A6,#0
03DA: 2F0C          MOVE.L     A4,-(A7)
03DC: 42A7          CLR.L      -(A7)
03DE: 3F2E0008      MOVE.W     8(A6),-(A7)
03E2: 2F2E000A      MOVE.L     10(A6),-(A7)
03E6: 2F2E000E      MOVE.L     14(A6),-(A7)
03EA: A9BD285F      MOVE.L     ???,95(A4,D2.L)
03EE: 2F0C          MOVE.L     A4,-(A7)
03F0: 1F3C0001      MOVE.B     #$01,-(A7)
03F4: A91C          MOVE.L     (A4)+,-(A4)
03F6: 296DE38C007E  MOVE.L     -7284(A5),126(A4)              ; A5-7284
03FC: 200C          MOVE.L     A4,D0
03FE: 285F          MOVEA.L    (A7)+,A4
0400: 4E5E          UNLK       A6
0402: 4E75          RTS        


; ======= Function at 0x0404 =======
0404: 4E560000      LINK       A6,#0
0408: 2F0C          MOVE.L     A4,-(A7)
040A: 42A7          CLR.L      -(A7)
040C: 2F2E0008      MOVE.L     8(A6),-(A7)
0410: 2F2E000C      MOVE.L     12(A6),-(A7)
0414: 2F2E0010      MOVE.L     16(A6),-(A7)
0418: 4227          CLR.B      -(A7)
041A: 3F2E0016      MOVE.W     22(A6),-(A7)
041E: 42A7          CLR.L      -(A7)
0420: 1F2E001C      MOVE.B     28(A6),-(A7)
0424: 2F2E001E      MOVE.L     30(A6),-(A7)
0428: A913          MOVE.L     (A3),-(A4)
042A: 285F          MOVEA.L    (A7)+,A4
042C: 2F0C          MOVE.L     A4,-(A7)
042E: 1F3C0001      MOVE.B     #$01,-(A7)
0432: A91C          MOVE.L     (A4)+,-(A4)
0434: 296DE38C007E  MOVE.L     -7284(A5),126(A4)              ; A5-7284
043A: 2F0C          MOVE.L     A4,-(A7)
043C: 4EAD0C3A      JSR        3130(A5)                       ; JT[3130]
0440: 4A2E0014      TST.B      20(A6)
0444: 588F          MOVE.B     A7,(A4)
0446: 6708          BEQ.S      $0450
0448: 2F0C          MOVE.L     A4,-(A7)
044A: 1F3C0001      MOVE.B     #$01,-(A7)
044E: A908          MOVE.L     A0,-(A4)
0450: 200C          MOVE.L     A4,D0
0452: 285F          MOVEA.L    (A7)+,A4
0454: 4E5E          UNLK       A6
0456: 4E75          RTS        


; ======= Function at 0x0458 =======
0458: 4E560000      LINK       A6,#0
045C: 2F0C          MOVE.L     A4,-(A7)
045E: 42A7          CLR.L      -(A7)
0460: 2F2E0008      MOVE.L     8(A6),-(A7)
0464: 2F2E000C      MOVE.L     12(A6),-(A7)
0468: 2F2E0010      MOVE.L     16(A6),-(A7)
046C: 4227          CLR.B      -(A7)
046E: 3F2E0016      MOVE.W     22(A6),-(A7)
0472: 42A7          CLR.L      -(A7)
0474: 1F2E001C      MOVE.B     28(A6),-(A7)
0478: 2F2E001E      MOVE.L     30(A6),-(A7)
047C: 2F2E0022      MOVE.L     34(A6),-(A7)
0480: A97D285F      MOVE.L     ???,10335(A4)
0484: 2F0C          MOVE.L     A4,-(A7)
0486: 1F3C0001      MOVE.B     #$01,-(A7)
048A: A91C          MOVE.L     (A4)+,-(A4)
048C: 296DE38C007E  MOVE.L     -7284(A5),126(A4)              ; A5-7284
0492: 2F0C          MOVE.L     A4,-(A7)
0494: 4EAD0C3A      JSR        3130(A5)                       ; JT[3130]
0498: 4A2E0014      TST.B      20(A6)
049C: 588F          MOVE.B     A7,(A4)
049E: 6708          BEQ.S      $04A8
04A0: 2F0C          MOVE.L     A4,-(A7)
04A2: 1F3C0001      MOVE.B     #$01,-(A7)
04A6: A908          MOVE.L     A0,-(A4)
04A8: 200C          MOVE.L     A4,D0
04AA: 285F          MOVEA.L    (A7)+,A4
04AC: 4E5E          UNLK       A6
04AE: 4E75          RTS        

04B0: 7006          MOVEQ      #6,D0
04B2: A122          MOVE.L     -(A2),-(A0)
04B4: 2B48E38C      MOVE.L     A0,-7284(A5)
04B8: 2050          MOVEA.L    (A0),A0
04BA: 30BC4EF9      MOVE.W     #$4EF9,(A0)
04BE: 206DE38C      MOVEA.L    -7284(A5),A0
04C2: 43ED0C52      LEA        3154(A5),A1                    ; A5+3154
04C6: 2050          MOVEA.L    (A0),A0
04C8: 21490002      MOVE.L     A1,2(A0)
04CC: 4E75          RTS        


; ======= Function at 0x04CE =======
04CE: 4E56FFF8      LINK       A6,#-8                         ; frame=8
04D2: 4EBA07E8      JSR        2024(PC)
04D6: 20380908      MOVE.L     $0908.W,D0
04DA: 0680FFFF4000  ADDI.L     #$FFFF4000,D0
04E0: 2040          MOVEA.L    D0,A0
04E2: A02D486D      MOVE.L     18541(A5),D0                   ; A5+18541
04E6: E46C486D      MOVEA.L    18541(A4),A2
04EA: D700          MOVE.B     D0,-(A3)
04EC: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
04F0: 0C6D0280FA5C  CMPI.W     #$0280,-1444(A5)
04F6: 508F          MOVE.B     A7,(A0)
04F8: 6D12          BLT.S      $050C
04FA: 0C6D01E0FA5A  CMPI.W     #$01E0,-1446(A5)
0500: 6D0A          BLT.S      $050C
0502: 41EDE398      LEA        -7272(A5),A0                   ; A5-7272
0506: 2B48DE80      MOVE.L     A0,-8576(A5)
050A: 6008          BRA.S      $0514
050C: 41EDE402      LEA        -7166(A5),A0                   ; A5-7166
0510: 2B48DE80      MOVE.L     A0,-8576(A5)
0514: 4EBAFF9A      JSR        -102(PC)
0518: 3F2DF270      MOVE.W     -3472(A5),-(A7)                ; A5-3472
051C: 48780910      PEA        $0910.W
0520: 4EBA0826      JSR        2086(PC)
0524: 4A40          TST.W      D0
0526: 5C8F          MOVE.B     A7,(A6)
0528: 6726          BEQ.S      $0550
052A: 2B6DA1B2A222  MOVE.L     -24142(A5),-24030(A5)          ; A5-24142
0530: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
0536: C1EDA386      ANDA.L     -23674(A5),A0
053A: 41EDA226      LEA        -24026(A5),A0                  ; g_common
053E: D088          MOVE.B     A0,(A0)
0540: 2040          MOVEA.L    D0,A0
0542: 7001          MOVEQ      #1,D0
0544: 4A40          TST.W      D0
0546: 6602          BNE.S      $054A
0548: 7001          MOVEQ      #1,D0
054A: 4CD8          DC.W       $4CD8
054C: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
0550: 4EAD00F2      JSR        242(A5)                        ; JT[242]
0554: 422DC35E      CLR.B      -15522(A5)
0558: 422DC366      CLR.B      -15514(A5)
055C: 4A2DD72A      TST.B      -10454(A5)
0560: 6618          BNE.S      $057A
0562: 486DD700      PEA        -10496(A5)                     ; A5-10496
0566: 486DE47C      PEA        -7044(A5)                      ; A5-7044
056A: 486DD72B      PEA        -10453(A5)                     ; A5-10453
056E: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0572: 1B40D72A      MOVE.B     D0,-10454(A5)
0576: 4FEF000C      LEA        12(A7),A7
057A: 4EBA04DE      JSR        1246(PC)
057E: 486DE488      PEA        -7032(A5)                      ; A5-7032
0582: 486DDEC0      PEA        -8512(A5)                      ; A5-8512
0586: A900          MOVE.L     D0,-(A4)
0588: 4A6DDEC0      TST.W      -8512(A5)
058C: 6604          BNE.S      $0592
058E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0592: 4267          CLR.W      -(A7)
0594: 42A7          CLR.L      -(A7)
0596: 4EAD0082      JSR        130(A5)                        ; JT[130]
059A: 4EAD00FA      JSR        250(A5)                        ; JT[250]
059E: 4EBA006A      JSR        106(PC)
05A2: 4E5E          UNLK       A6
05A4: 4E75          RTS        


; ======= Function at 0x05A6 =======
05A6: 4E56FFF8      LINK       A6,#-8                         ; frame=8
05AA: 2F0C          MOVE.L     A4,-(A7)
05AC: 486EFFF8      PEA        -8(A6)
05B0: 206DDE80      MOVEA.L    -8576(A5),A0
05B4: 3F28005A      MOVE.W     90(A0),-(A7)
05B8: 3F28005C      MOVE.W     92(A0),-(A7)
05BC: 3F28005E      MOVE.W     94(A0),-(A7)
05C0: 3F280060      MOVE.W     96(A0),-(A7)
05C4: A8A7          MOVE.L     -(A7),(A4)
05C6: 2F2E000C      MOVE.L     12(A6),-(A7)
05CA: 1F3C0001      MOVE.B     #$01,-(A7)
05CE: 4878FFFF      PEA        $FFFF.W
05D2: 42A7          CLR.L      -(A7)
05D4: 2F2E0008      MOVE.L     8(A6),-(A7)
05D8: 486EFFF8      PEA        -8(A6)
05DC: 203C000000A8  MOVE.L     #$000000A8,D0
05E2: A31E          MOVE.L     (A6)+,-(A1)
05E4: 2F08          MOVE.L     A0,-(A7)
05E6: 4EBAFE1C      JSR        -484(PC)
05EA: 2840          MOVEA.L    D0,A4
05EC: 2EBC0016000A  MOVE.L     #$0016000A,(A7)
05F2: 3F3C0001      MOVE.W     #$0001,-(A7)
05F6: 486EFFF8      PEA        -8(A6)
05FA: 2F0C          MOVE.L     A4,-(A7)
05FC: 4EAD073A      JSR        1850(A5)                       ; JT[1850]
0600: 200C          MOVE.L     A4,D0
0602: 286EFFF4      MOVEA.L    -12(A6),A4
0606: 4E5E          UNLK       A6
0608: 4E75          RTS        

060A: 2F0C          MOVE.L     A4,-(A7)
060C: 42A7          CLR.L      -(A7)
060E: 3F3C0081      MOVE.W     #$0081,-(A7)
0612: A9C0A93C42A7  MOVE.L     D0,#$A93C42A7
0618: 3F3C0080      MOVE.W     #$0080,-(A7)
061C: A949285F      MOVE.L     A1,10335(A4)
0620: 200C          MOVE.L     A4,D0
0622: 6604          BNE.S      $0628
0624: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0628: 2F0C          MOVE.L     A4,-(A7)
062A: 2F3C44525652  MOVE.L     #$44525652,-(A7)
0630: A94D206D      MOVE.L     A5,8301(A4)
0634: DE782050      MOVEA.B    $2050.W,A7
0638: 3F280300      MOVE.W     768(A0),-(A7)
063C: 4267          CLR.W      -(A7)
063E: 42A7          CLR.L      -(A7)
0640: 3F3C0005      MOVE.W     #$0005,-(A7)
0644: A949A950      MOVE.L     A1,-22192(A4)
0648: 4EAD0272      JSR        626(A5)                        ; JT[626]
064C: 3EBC0001      MOVE.W     #$0001,(A7)
0650: 206DDE78      MOVEA.L    -8584(A5),A0
0654: 2250          MOVEA.L    (A0),A1
0656: 30290302      MOVE.W     770(A1),D0
065A: C1FC00C02050  ANDA.L     #$00C02050,A0
0660: 3F30080A      MOVE.W     10(A0,D0.L),-(A7)
0664: 4EAD0272      JSR        626(A5)                        ; JT[626]
0668: A9375C8F      MOVE.L     -113(A7,D5.L*4),-(A4)
066C: 285F          MOVEA.L    (A7)+,A4
066E: 4E75          RTS        


; ======= Function at 0x0670 =======
0670: 4E56FFE6      LINK       A6,#-26                        ; frame=26
0674: 48E70738      MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)        ; save
0678: 486EFFF8      PEA        -8(A6)
067C: 206DDE80      MOVEA.L    -8576(A5),A0
0680: 3F28002E      MOVE.W     46(A0),-(A7)
0684: 3F280030      MOVE.W     48(A0),-(A7)
0688: 3F280032      MOVE.W     50(A0),-(A7)
068C: 3F280034      MOVE.W     52(A0),-(A7)
0690: A8A7          MOVE.L     -(A7),(A4)
0692: 42A7          CLR.L      -(A7)
0694: 2F3C4449544C  MOVE.L     #$4449544C,-(A7)
069A: 206DDE80      MOVEA.L    -8576(A5),A0
069E: 3F10          MOVE.W     (A0),-(A7)
06A0: A9A0285F      MOVE.L     -(A0),95(A4,D2.L)
06A4: 200C          MOVE.L     A4,D0
06A6: 6604          BNE.S      $06AC
06A8: 4EAD01A2      JSR        418(A5)                        ; JT[418]
06AC: 486EFFF8      PEA        -8(A6)
06B0: 206DDE80      MOVEA.L    -8576(A5),A0
06B4: 3F10          MOVE.W     (A0),-(A7)
06B6: 2F3C4449544C  MOVE.L     #$4449544C,-(A7)
06BC: 4EAD0D12      JSR        3346(A5)                       ; JT[3346]
06C0: 4A2DF269      TST.B      -3479(A5)
06C4: 4FEF000A      LEA        10(A7),A7
06C8: 6740          BEQ.S      $070A
06CA: 42A7          CLR.L      -(A7)
06CC: 203C000000D4  MOVE.L     #$000000D4,D0
06D2: A31E          MOVE.L     (A6)+,-(A1)
06D4: 2F08          MOVE.L     A0,-(A7)
06D6: 486EFFF8      PEA        -8(A6)
06DA: 486DD72A      PEA        -10454(A5)                     ; A5-10454
06DE: 2F3C00040100  MOVE.L     #$00040100,-(A7)
06E4: 4878FFFF      PEA        $FFFF.W
06E8: 4227          CLR.B      -(A7)
06EA: 486DEF2A      PEA        -4310(A5)                      ; A5-4310
06EE: 2F0C          MOVE.L     A4,-(A7)
06F0: AA4B          MOVEA.L    A3,A5
06F2: 2B5FDEC2      MOVE.L     (A7)+,-8510(A5)
06F6: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
06FA: 42A7          CLR.L      -(A7)
06FC: 3F3C0080      MOVE.W     #$0080,-(A7)
0700: AA92          MOVE.L     (A2),(A5)
0702: 1F3C0001      MOVE.B     #$01,-(A7)
0706: AA95          MOVE.L     (A5),(A5)
0708: 602C          BRA.S      $0736
070A: 42A7          CLR.L      -(A7)
070C: 203C000000D4  MOVE.L     #$000000D4,D0
0712: A31E          MOVE.L     (A6)+,-(A1)
0714: 2F08          MOVE.L     A0,-(A7)
0716: 486EFFF8      PEA        -8(A6)
071A: 486DD72A      PEA        -10454(A5)                     ; A5-10454
071E: 2F3C00040100  MOVE.L     #$00040100,-(A7)
0724: 4878FFFF      PEA        $FFFF.W
0728: 4227          CLR.B      -(A7)
072A: 486DEF2A      PEA        -4310(A5)                      ; A5-4310
072E: 2F0C          MOVE.L     A4,-(A7)
0730: A97D2B5F      MOVE.L     ???,11103(A4)
0734: DEC2          MOVE.B     D2,(A7)+
0736: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
073A: 4EAD0212      JSR        530(A5)                        ; JT[530]
073E: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
0742: 7001          MOVEQ      #1,D0
0744: 3B40DE4E      MOVE.W     D0,-8626(A5)
0748: 3B40DE52      MOVE.W     D0,-8622(A5)
074C: 3B40DE50      MOVE.W     D0,-8624(A5)
0750: 486DEF7A      PEA        -4230(A5)                      ; A5-4230
0754: 3F3C0001      MOVE.W     #$0001,-(A7)
0758: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
075C: 4EAD05DA      JSR        1498(A5)                       ; JT[1498]
0760: 2EADDEC2      MOVE.L     -8510(A5),(A7)                 ; A5-8510
0764: 3F3C0001      MOVE.W     #$0001,-(A7)
0768: 486EFFF6      PEA        -10(A6)
076C: 486DDECA      PEA        -8502(A5)                      ; A5-8502
0770: 486EFFF8      PEA        -8(A6)
0774: A98D486D      MOVE.L     A5,109(A4,D4.L)
0778: EF8A3F3C      MOVE.L     A2,60(A7,D3.L*8)
077C: 00022F2D      ORI.B      #$2F2D,D2
0780: DEC2          MOVE.B     D2,(A7)+
0782: 4EAD05DA      JSR        1498(A5)                       ; JT[1498]
0786: 2EADDEC2      MOVE.L     -8510(A5),(A7)                 ; A5-8510
078A: 3F3C0002      MOVE.W     #$0002,-(A7)
078E: 486EFFF6      PEA        -10(A6)
0792: 486DDECE      PEA        -8498(A5)                      ; A5-8498
0796: 486EFFF8      PEA        -8(A6)
079A: A98D486D      MOVE.L     A5,109(A4,D4.L)
079E: EF9A3F3C      MOVE.L     (A2)+,60(A7,D3.L*8)
07A2: 00042F2D      ORI.B      #$2F2D,D4
07A6: DEC2          MOVE.B     D2,(A7)+
07A8: 4EAD05DA      JSR        1498(A5)                       ; JT[1498]
07AC: 2EADDEC2      MOVE.L     -8510(A5),(A7)                 ; A5-8510
07B0: 3F3C0004      MOVE.W     #$0004,-(A7)
07B4: 486EFFF6      PEA        -10(A6)
07B8: 486DDED2      PEA        -8494(A5)                      ; A5-8494
07BC: 486EFFF8      PEA        -8(A6)
07C0: A98D2EAD      MOVE.L     A5,-83(A4,D2.L*8)
07C4: DEC2          MOVE.B     D2,(A7)+
07C6: 3F3C0003      MOVE.W     #$0003,-(A7)
07CA: A827          MOVE.L     -(A7),D4
07CC: 206DDE80      MOVEA.L    -8576(A5),A0
07D0: 2D68003EFFF8  MOVE.L     62(A0),-8(A6)
07D6: 2D680042FFFC  MOVE.L     66(A0),-4(A6)
07DC: 486EFFF8      PEA        -8(A6)
07E0: 2F3C00010001  MOVE.L     #$00010001,-(A7)
07E6: A8A970F0      MOVE.L     28912(A1),(A4)
07EA: D06EFFFE      MOVEA.B    -2(A6),A0
07EE: 3D40FFFA      MOVE.W     D0,-6(A6)
07F2: 066E000DFFF8  ADDI.W     #$000D,-8(A6)
07F8: 4297          CLR.L      (A7)
07FA: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
07FE: 486EFFF8      PEA        -8(A6)
0802: 2F2DF248      MOVE.L     -3512(A5),-(A7)                ; A5-3512
0806: 42A7          CLR.L      -(A7)
0808: 42A7          CLR.L      -(A7)
080A: 3F3C0010      MOVE.W     #$0010,-(A7)
080E: 486DEF04      PEA        -4348(A5)                      ; A5-4348
0812: A9542B5F      MOVE.L     (A4),11103(A4)
0816: DEC6          MOVE.B     D6,(A7)+
0818: 2EADDEC6      MOVE.L     -8506(A5),(A7)                 ; A5-8506
081C: A9574297      MOVE.L     (A7),17047(A4)
0820: 2F3C43464947  MOVE.L     #$43464947,-(A7)
0826: 4267          CLR.W      -(A7)
0828: A9A0201F      MOVE.L     -(A0),31(A4,D2.W)
082C: 2B40DE60      MOVE.L     D0,-8608(A5)
0830: 5C8F          MOVE.B     A7,(A6)
0832: 660000BE      BNE.W      $08F4
0836: 203C00000440  MOVE.L     #$00000440,D0
083C: A322          MOVE.L     -(A2),-(A1)
083E: 2B48DE60      MOVE.L     A0,-8608(A5)
0842: 2008          MOVE.L     A0,D0
0844: 6626          BNE.S      $086C
0846: 2B6D93A8A222  MOVE.L     -27736(A5),-24030(A5)          ; A5-27736
084C: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
0852: C1EDA386      ANDA.L     -23674(A5),A0
0856: 41EDA226      LEA        -24026(A5),A0                  ; g_common
085A: D088          MOVE.B     A0,(A0)
085C: 2040          MOVEA.L    D0,A0
085E: 7001          MOVEQ      #1,D0
0860: 4A40          TST.W      D0
0862: 6602          BNE.S      $0866
0864: 7001          MOVEQ      #1,D0
0866: 4CD8          DC.W       $4CD8
0868: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
086C: 2F2DDE60      MOVE.L     -8608(A5),-(A7)                ; A5-8608
0870: 2F3C43464947  MOVE.L     #$43464947,-(A7)
0876: 4267          CLR.W      -(A7)
0878: 2F2DF248      MOVE.L     -3512(A5),-(A7)                ; A5-3512
087C: A9AB7C0149ED  MOVE.L     31745(A3),-19(A4,D4.L)
0882: 95A347ED      MOVE.B     -(A3),-19(A2,D4.W*8)
0886: 97C36026      MOVE.B     D3,38(PC,D6.W)
088A: 7A01          MOVEQ      #1,D5
088C: 244B          MOVEA.L    A3,A2
088E: 2E0C          MOVE.L     A4,D7
0890: 600E          BRA.S      $08A0
0892: 3045          MOVEA.W    D5,A0
0894: 7001          MOVEQ      #1,D0
0896: 11807800      MOVE.B     D0,0(A0,D7.L)
089A: 15805000      MOVE.B     D0,0(A2,D5.W)
089E: 5245          MOVEA.B    D5,A1
08A0: 0C450010      CMPI.W     #$0010,D5
08A4: 65EC          BCS.S      $0892
08A6: 5246          MOVEA.B    D6,A1
08A8: 49EC0011      LEA        17(A4),A4
08AC: 47EB0011      LEA        17(A3),A3
08B0: 0C46001F      CMPI.W     #$001F,D6
08B4: 65D4          BCS.S      $088A
08B6: 206DDE60      MOVEA.L    -8608(A5),A0
08BA: A0294878      MOVE.L     18552(A1),D0
08BE: 0220486D      ANDI.B     #$486D,-(A0)
08C2: 97B2206DDE60  MOVE.B     109(A2,D2.W),96(A3,A5.L*8)
08C8: 2F10          MOVE.L     (A0),-(A7)
08CA: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
08CE: 48780220      PEA        $0220.W
08D2: 486D9592      PEA        -27246(A5)                     ; A5-27246
08D6: 206DDE60      MOVEA.L    -8608(A5),A0
08DA: 2050          MOVEA.L    (A0),A0
08DC: 48680220      PEA        544(A0)
08E0: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
08E4: 4EAD056A      JSR        1386(A5)                       ; JT[1386]
08E8: 4EAD0512      JSR        1298(A5)                       ; JT[1298]
08EC: 4FEF0018      LEA        24(A7),A7
08F0: 603C          BRA.S      $092E
08F2: 4EAD050A      JSR        1290(A5)                       ; JT[1290]
08F6: 48780220      PEA        $0220.W
08FA: 206DDE60      MOVEA.L    -8608(A5),A0
08FE: 2F10          MOVE.L     (A0),-(A7)
0900: 486D97B2      PEA        -26702(A5)                     ; A5-26702
0904: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0908: 48780220      PEA        $0220.W
090C: 206DDE60      MOVEA.L    -8608(A5),A0
0910: 2050          MOVEA.L    (A0),A0
0912: 48680220      PEA        544(A0)
0916: 486D9592      PEA        -27246(A5)                     ; A5-27246
091A: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
091E: 206DDE60      MOVEA.L    -8608(A5),A0
0922: A02A4257      MOVE.L     16983(A2),D0
0926: 4EAD0572      JSR        1394(A5)                       ; JT[1394]
092A: 4FEF0018      LEA        24(A7),A7
092E: 4CDF1CE0      MOVEM.L    (SP)+,D5/D6/D7/A2/A3/A4        ; restore
0932: 4E5E          UNLK       A6
0934: 4E75          RTS        


; ======= Function at 0x0936 =======
0936: 4E56FFEC      LINK       A6,#-20                        ; frame=20
093A: 2F0C          MOVE.L     A4,-(A7)
093C: 486EFFEC      PEA        -20(A6)
0940: 3F3C03F6      MOVE.W     #$03F6,-(A7)
0944: 2F3C4449544C  MOVE.L     #$4449544C,-(A7)
094A: 4EAD060A      JSR        1546(A5)                       ; JT[1546]
094E: 2840          MOVEA.L    D0,A4
0950: 200C          MOVE.L     A4,D0
0952: 4FEF000A      LEA        10(A7),A7
0956: 6604          BNE.S      $095C
0958: 4EAD01A2      JSR        418(A5)                        ; JT[418]
095C: 3F3C0016      MOVE.W     #$0016,-(A7)
0960: 31DF0AFA      MOVE.W     (A7)+,$0AFA.W
0964: 2F0C          MOVE.L     A4,-(A7)
0966: 486DE260      PEA        -7584(A5)                      ; A5-7584
096A: 1F3C0001      MOVE.B     #$01,-(A7)
096E: 4878FFFF      PEA        $FFFF.W
0972: 48780004      PEA        $0004.W
0976: 2F2DA1EA      MOVE.L     -24086(A5),-(A7)               ; A5-24086
097A: 486EFFEC      PEA        -20(A6)
097E: 203C000000AA  MOVE.L     #$000000AA,D0
0984: A31E          MOVE.L     (A6)+,-(A1)
0986: 2F08          MOVE.L     A0,-(A7)
0988: 4EBAFACE      JSR        -1330(PC)
098C: 2B40DEB4      MOVE.L     D0,-8524(A5)
0990: 4257          CLR.W      (A7)
0992: 31DF0AFA      MOVE.W     (A7)+,$0AFA.W
0996: 2EADDEB4      MOVE.L     -8524(A5),(A7)                 ; A5-8524
099A: 4EAD0212      JSR        530(A5)                        ; JT[530]
099E: 486DE280      PEA        -7552(A5)                      ; A5-7552
09A2: 3F3C0001      MOVE.W     #$0001,-(A7)
09A6: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
09AA: 4EAD05DA      JSR        1498(A5)                       ; JT[1498]
09AE: 486DE290      PEA        -7536(A5)                      ; A5-7536
09B2: 3F3C000A      MOVE.W     #$000A,-(A7)
09B6: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
09BA: 4EAD05DA      JSR        1498(A5)                       ; JT[1498]
09BE: 486DE248      PEA        -7608(A5)                      ; A5-7608
09C2: 3F3C000F      MOVE.W     #$000F,-(A7)
09C6: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
09CA: 4EAD05DA      JSR        1498(A5)                       ; JT[1498]
09CE: 286EFFE8      MOVEA.L    -24(A6),A4
09D2: 4E5E          UNLK       A6
09D4: 4E75          RTS        


; ======= Function at 0x09D6 =======
09D6: 4E56FFF8      LINK       A6,#-8                         ; frame=8
09DA: 486EFFF8      PEA        -8(A6)
09DE: 206DDE80      MOVEA.L    -8576(A5),A0
09E2: 3F280036      MOVE.W     54(A0),-(A7)
09E6: 3F280038      MOVE.W     56(A0),-(A7)
09EA: 3F28003A      MOVE.W     58(A0),-(A7)
09EE: 3F28003C      MOVE.W     60(A0),-(A7)
09F2: A8A7          MOVE.L     -(A7),(A4)
09F4: 486DE338      PEA        -7368(A5)                      ; A5-7368
09F8: 1F3C0001      MOVE.B     #$01,-(A7)
09FC: 42A7          CLR.L      -(A7)
09FE: 48780004      PEA        $0004.W
0A02: 486DE490      PEA        -7024(A5)                      ; A5-7024
0A06: 486EFFF8      PEA        -8(A6)
0A0A: 203C000000D4  MOVE.L     #$000000D4,D0
0A10: A31E          MOVE.L     (A6)+,-(A1)
0A12: 2F08          MOVE.L     A0,-(A7)
0A14: 4EBAF9EE      JSR        -1554(PC)
0A18: 2B40DEB8      MOVE.L     D0,-8520(A5)
0A1C: 2E80          MOVE.L     D0,(A7)
0A1E: A8733EBC      MOVEA.L    -68(A3,D3.L*8),A4
0A22: 0016A887      ORI.B      #$A887,(A6)
0A26: 3EBC000A      MOVE.W     #$000A,(A7)
0A2A: A88A          MOVE.L     A2,(A4)
0A2C: 426EFFFC      CLR.W      -4(A6)
0A30: 426EFFFA      CLR.W      -6(A6)
0A34: 426EFFF8      CLR.W      -8(A6)
0A38: 3D7C0001FFFE  MOVE.W     #$0001,-2(A6)
0A3E: 7000          MOVEQ      #0,D0
0A40: A122          MOVE.L     -(A2),-(A0)
0A42: 226DDEB8      MOVEA.L    -8520(A5),A1
0A46: 234800CA      MOVE.L     A0,202(A1)
0A4A: 41ED02BA      LEA        698(A5),A0                     ; A5+698
0A4E: 226DDEB8      MOVEA.L    -8520(A5),A1
0A52: 234800CE      MOVE.L     A0,206(A1)
0A56: 4E5E          UNLK       A6
0A58: 4E75          RTS        

0A5A: 4EBAFC14      JSR        -1004(PC)
0A5E: 4EBAFED6      JSR        -298(PC)
0A62: 4EBAFF72      JSR        -142(PC)
0A66: 486DE936      PEA        -5834(A5)                      ; A5-5834
0A6A: 2F2DA216      MOVE.L     -24042(A5),-(A7)               ; A5-24042
0A6E: 4EBAFB36      JSR        -1226(PC)
0A72: 2B40DE7C      MOVE.L     D0,-8580(A5)
0A76: 486DEDFE      PEA        -4610(A5)                      ; A5-4610
0A7A: 2F2DA21A      MOVE.L     -24038(A5),-(A7)               ; A5-24038
0A7E: 4EBAFB26      JSR        -1242(PC)
0A82: 2B40DEB0      MOVE.L     D0,-8528(A5)
0A86: 7000          MOVEQ      #0,D0
0A88: A122          MOVE.L     -(A2),-(A0)
0A8A: 226DDEC2      MOVEA.L    -8510(A5),A1
0A8E: 234800CA      MOVE.L     A0,202(A1)
0A92: 41ED04B2      LEA        1202(A5),A0                    ; A5+1202
0A96: 226DDEC2      MOVEA.L    -8510(A5),A1
0A9A: 234800CE      MOVE.L     A0,206(A1)
0A9E: 4FEF0010      LEA        16(A7),A7
0AA2: 4E75          RTS        


; ======= Function at 0x0AA4 =======
0AA4: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0AA8: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
0AAC: 3C2E000C      MOVE.W     12(A6),D6
0AB0: 42A7          CLR.L      -(A7)
0AB2: 2F2E0008      MOVE.L     8(A6),-(A7)
0AB6: 4267          CLR.W      -(A7)
0AB8: A9A0285F      MOVE.L     -(A0),95(A4,D2.L)
0ABC: 200C          MOVE.L     A4,D0
0ABE: 6614          BNE.S      $0AD4
0AC0: 7000          MOVEQ      #0,D0
0AC2: A122          MOVE.L     -(A2),-(A0)
0AC4: 2848          MOVEA.L    A0,A4
0AC6: 2F0C          MOVE.L     A4,-(A7)
0AC8: 2F2E0008      MOVE.L     8(A6),-(A7)
0ACC: 4267          CLR.W      -(A7)
0ACE: 486DE4D2      PEA        -6958(A5)                      ; A5-6958
0AD2: A9AB200C6604  MOVE.L     8204(A3),4(A4,D6.W*8)
0AD8: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0ADC: 4A94          TST.L      (A4)
0ADE: 6604          BNE.S      $0AE4
0AE0: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0AE4: 42A7          CLR.L      -(A7)
0AE6: 2F0C          MOVE.L     A4,-(A7)
0AE8: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0AEC: 2D5FFFFC      MOVE.L     (A7)+,-4(A6)
0AF0: 4878001C      PEA        $001C.W
0AF4: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
0AF8: 4EAD004A      JSR        74(A5)                         ; JT[74]
0AFC: 3E00          MOVE.W     D0,D7
0AFE: BC47          MOVEA.W    D7,A6
0B00: 6734          BEQ.S      $0B36
0B02: 701C          MOVEQ      #28,D0
0B04: C1C6          ANDA.L     D6,A0
0B06: 204C          MOVEA.L    A4,A0
0B08: A024          MOVE.L     -(A4),D0
0B0A: 701C          MOVEQ      #28,D0
0B0C: C1C7          ANDA.L     D7,A0
0B0E: 2640          MOVEA.L    D0,A3
0B10: 6016          BRA.S      $0B28
0B12: 4878001C      PEA        $001C.W
0B16: 204B          MOVEA.L    A3,A0
0B18: D1D42F08      MOVE.B     (A4),$2F08.W
0B1C: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0B20: 508F          MOVE.B     A7,(A0)
0B22: 5247          MOVEA.B    D7,A1
0B24: 47EB001C      LEA        28(A3),A3
0B28: BC47          MOVEA.W    D7,A6
0B2A: 6EE6          BGT.S      $0B12
0B2C: 2F0C          MOVE.L     A4,-(A7)
0B2E: A9AA4267A994  MOVE.L     16999(A2),-108(A4,A2.L)
0B34: A999204C      MOVE.L     (A1)+,76(A4,D2.W)
0B38: A064          MOVEA.L    -(A4),A0
0B3A: 204C          MOVEA.L    A4,A0
0B3C: A0292654      MOVE.L     9812(A1),D0
0B40: 2F0C          MOVE.L     A4,-(A7)
0B42: A9927E00      MOVE.L     (A2),0(A4,D7.L*8)
0B46: 99CC6012      MOVE.B     A4,#$12
0B4A: 204B          MOVEA.L    A3,A0
0B4C: D1CC2F08      MOVE.B     A4,$2F08.W
0B50: 4EAD09EA      JSR        2538(A5)                       ; JT[2538]
0B54: 588F          MOVE.B     A7,(A4)
0B56: 5247          MOVEA.B    D7,A1
0B58: 49EC001C      LEA        28(A4),A4
0B5C: BC47          MOVEA.W    D7,A6
0B5E: 6EEA          BGT.S      $0B4A
0B60: 200B          MOVE.L     A3,D0
0B62: 4CDF18C0      MOVEM.L    (SP)+,D6/D7/A3/A4              ; restore
0B66: 4E5E          UNLK       A6
0B68: 4E75          RTS        


; ======= Function at 0x0B6A =======
0B6A: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0B6E: 48E70708      MOVEM.L    D5/D6/D7/A4,-(SP)              ; save
0B72: 4267          CLR.W      -(A7)
0B74: 2F2E0008      MOVE.L     8(A6),-(A7)
0B78: A9973E1F      MOVE.L     (A7),31(A4,D3.L*8)
0B7C: 4A47          TST.W      D7
0B7E: 6C04          BGE.S      $0B84
0B80: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0B84: 42A7          CLR.L      -(A7)
0B86: 2F3C45535452  MOVE.L     #$45535452,-(A7)
0B8C: 4267          CLR.W      -(A7)
0B8E: A9A0285F      MOVE.L     -(A0),95(A4,D2.L)
0B92: 200C          MOVE.L     A4,D0
0B94: 6604          BNE.S      $0B9A
0B96: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0B9A: 204C          MOVEA.L    A4,A0
0B9C: A064          MOVEA.L    -(A4),A0
0B9E: 204C          MOVEA.L    A4,A0
0BA0: A0292B54      MOVE.L     11092(A1),D0
0BA4: D5602F0C      MOVE.B     -(A0),12044(A2)
0BA8: A99242A7      MOVE.L     (A2),-89(A4,D4.W*2)
0BAC: 2F3C50415442  MOVE.L     #$50415442,-(A7)
0BB2: 4267          CLR.W      -(A7)
0BB4: A9A0285F      MOVE.L     -(A0),95(A4,D2.L)
0BB8: 200C          MOVE.L     A4,D0
0BBA: 6604          BNE.S      $0BC0
0BBC: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0BC0: 204C          MOVEA.L    A4,A0
0BC2: A064          MOVEA.L    -(A4),A0
0BC4: 204C          MOVEA.L    A4,A0
0BC6: A0292B54      MOVE.L     11092(A1),D0
0BCA: D55A2F0C      MOVE.B     (A2)+,12044(A2)
0BCE: A99242A7      MOVE.L     (A2),-89(A4,D4.W*2)
0BD2: 2F0C          MOVE.L     A4,-(A7)
0BD4: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0BD8: 201F          MOVE.L     (A7)+,D0
0BDA: E688          MOVE.L     A0,(A3)
0BDC: 3B40D55E      MOVE.W     D0,-10914(A5)
0BE0: 426DD5F8      CLR.W      -10760(A5)
0BE4: 7C00          MOVEQ      #0,D6
0BE6: 99CC6016      MOVE.B     A4,#$16
0BEA: 202DD55A      MOVE.L     -10918(A5),D0                  ; A5-10918
0BEE: 3A340804      MOVE.W     4(A4,D0.L),D5
0BF2: BA6DD5F8      MOVEA.W    -10760(A5),A5
0BF6: 6F04          BLE.S      $0BFC
0BF8: 3B45D5F8      MOVE.W     D5,-10760(A5)
0BFC: 5246          MOVEA.B    D6,A1
0BFE: 508C          MOVE.B     A4,(A0)
0C00: BC6DD55E      MOVEA.W    -10914(A5),A6
0C04: 6DE4          BLT.S      $0BEA
0C06: 526DD5F8      MOVEA.B    -10760(A5),A1
0C0A: 3F2DD5F8      MOVE.W     -10760(A5),-(A7)               ; A5-10760
0C0E: 2F3C45585052  MOVE.L     #$45585052,-(A7)
0C14: 4EBAFE8E      JSR        -370(PC)
0C18: 2B40D564      MOVE.L     D0,-10908(A5)
0C1C: 3EBC0008      MOVE.W     #$0008,(A7)
0C20: 2F3C46525354  MOVE.L     #$46525354,-(A7)
0C26: 4EBAFE7C      JSR        -388(PC)
0C2A: 2B40D568      MOVE.L     D0,-10904(A5)
0C2E: 7C00          MOVEQ      #0,D6
0C30: 49EDD56C      LEA        -10900(A5),A4                  ; A5-10900
0C34: 4FEF000A      LEA        10(A7),A7
0C38: 601A          BRA.S      $0C54
0C3A: 3F3C0008      MOVE.W     #$0008,-(A7)
0C3E: 3046          MOVEA.W    D6,A0
0C40: D1FC56434261  MOVE.B     #$43,$4261.W
0C46: 2F08          MOVE.L     A0,-(A7)
0C48: 4EBAFE5A      JSR        -422(PC)
0C4C: 2880          MOVE.L     D0,(A4)
0C4E: 5C8F          MOVE.B     A7,(A6)
0C50: 5246          MOVEA.B    D6,A1
0C52: 588C          MOVE.B     A4,(A4)
0C54: 0C460008      CMPI.W     #$0008,D6
0C58: 65E0          BCS.S      $0C3A
0C5A: 7C00          MOVEQ      #0,D6
0C5C: 49EDD58C      LEA        -10868(A5),A4                  ; A5-10868
0C60: 6024          BRA.S      $0C86
0C62: 3F3C0008      MOVE.W     #$0008,-(A7)
0C66: 206D99D2      MOVEA.L    -26158(A5),A0
0C6A: 10306000      MOVE.B     0(A0,D6.W),D0
0C6E: 4880          EXT.W      D0
0C70: 3240          MOVEA.W    D0,A1
0C72: D3FC4D554C002F09  MOVE.B     #$55,$4C002F09
0C7A: 4EBAFE28      JSR        -472(PC)
0C7E: 2880          MOVE.L     D0,(A4)
0C80: 5C8F          MOVE.B     A7,(A6)
0C82: 5246          MOVEA.B    D6,A1
0C84: 588C          MOVE.B     A4,(A4)
0C86: 0C46001B      CMPI.W     #$001B,D6
0C8A: 65D6          BCS.S      $0C62
0C8C: 202E0008      MOVE.L     8(A6),D0
0C90: B0BC0000      MOVE.W     #$0000,(A0)
0C94: 0910          BTST       D4,(A0)
0C96: 6704          BEQ.S      $0C9C
0C98: 3F07          MOVE.W     D7,-(A7)
0C9A: A99A4CDF      MOVE.L     (A2)+,-33(A4,D4.L*4)
0C9E: 10E0          MOVE.B     -(A0),(A0)+
0CA0: 4E5E          UNLK       A6
0CA2: 4E75          RTS        


; ======= Function at 0x0CA4 =======
0CA4: 4E56FFFA      LINK       A6,#-6                         ; frame=6
0CA8: 2038020C      MOVE.L     $020C.W,D0
0CAC: B0AE0008      MOVE.W     8(A6),(A0)
0CB0: 6404          BCC.S      $0CB6
0CB2: 7000          MOVEQ      #0,D0
0CB4: 6002          BRA.S      $0CB8
0CB6: 7001          MOVEQ      #1,D0
0CB8: 4E5E          UNLK       A6
0CBA: 4E75          RTS        

0CBC: 2F07          MOVE.L     D7,-(A7)
0CBE: 7E00          MOVEQ      #0,D7
0CC0: 6004          BRA.S      $0CC6
0CC2: A0365247      MOVE.L     71(A6,D5.W*2),D0
0CC6: 0C470004      CMPI.W     #$0004,D7
0CCA: 6DF6          BLT.S      $0CC2
0CCC: 486DFACA      PEA        -1334(A5)                      ; A5-1334
0CD0: A86EA8FE      MOVEA.L    -22274(A6),A4
0CD4: A912          MOVE.L     (A2),-(A4)
0CD6: A930A9CC      MOVE.L     -52(A0,A2.L),-(A4)
0CDA: 42A7          CLR.L      -(A7)
0CDC: A97B42673F3C  MOVE.L     103(PC,D4.W),16188(A4)
0CE2: 0001486D      ORI.B      #$486D,D1
0CE6: F260          MOVEA.W    -(A0),A1
0CE8: 4EAD0BE2      JSR        3042(A5)                       ; JT[3042]
0CEC: A850          MOVEA.L    (A0),A4
0CEE: 4EAD0622      JSR        1570(A5)                       ; JT[1570]
0CF2: 42A7          CLR.L      -(A7)
0CF4: 3F3C0001      MOVE.W     #$0001,-(A7)
0CF8: A9B9205F205043ED  MOVE.L     $205F2050,-19(A4,D4.W*2)
0D00: F2787010      MOVEA.W    $7010.W,A1
0D04: 22D8          MOVE.L     (A0)+,(A1)+
0D06: 51C8FFFC      DBF        D0,$0D04                       ; loop
0D0A: 42A7          CLR.L      -(A7)
0D0C: 3F3C0004      MOVE.W     #$0004,-(A7)
0D10: A9B9205F205043ED  MOVE.L     $205F2050,-19(A4,D4.W*2)
0D18: F2BC7010      MOVE.W     #$7010,(A1)
0D1C: 22D8          MOVE.L     (A0)+,(A1)+
0D1E: 51C8FFFC      DBF        D0,$0D1C                       ; loop
0D22: 2F3C0000FFFF  MOVE.L     #$0000FFFF,-(A7)
0D28: 201F          MOVE.L     (A7)+,D0
0D2A: A03270FF      MOVE.L     -1(A2,D7.W),D0
0D2E: 31C00144      MOVE.W     D0,$0144.W
0D32: 4257          CLR.W      (A7)
0D34: 42A7          CLR.L      -(A7)
0D36: 486DF270      PEA        -3472(A5)                      ; A5-3472
0D3A: 4EAD0B42      JSR        2882(A5)                       ; JT[2882]
0D3E: 1EBC0001      MOVE.B     #$01,(A7)
0D42: A9932E1F      MOVE.L     (A3),31(A4,D2.L*8)
0D46: 4E75          RTS        


; ======= Function at 0x0D48 =======
0D48: 4E56FFD6      LINK       A6,#-42                        ; frame=42
0D4C: 2F07          MOVE.L     D7,-(A7)
0D4E: 7001          MOVEQ      #1,D0
0D50: 2D40FFDC      MOVE.L     D0,-36(A6)
0D54: 4267          CLR.W      -(A7)
0D56: 2F2E0008      MOVE.L     8(A6),-(A7)
0D5A: 3F2E000C      MOVE.W     12(A6),-(A7)
0D5E: 486EFFDA      PEA        -38(A6)
0D62: 4EAD0B1A      JSR        2842(A5)                       ; JT[2842]
0D66: 4A5F          TST.W      (A7)+
0D68: 6704          BEQ.S      $0D6E
0D6A: 7001          MOVEQ      #1,D0
0D6C: 607C          BRA.S      $0DEA
0D6E: 4267          CLR.W      -(A7)
0D70: 3F2EFFDA      MOVE.W     -38(A6),-(A7)
0D74: 486EFFD6      PEA        -42(A6)
0D78: 4EAD0B62      JSR        2914(A5)                       ; JT[2914]
0D7C: 4A5F          TST.W      (A7)+
0D7E: 6704          BEQ.S      $0D84
0D80: 7001          MOVEQ      #1,D0
0D82: 6066          BRA.S      $0DEA
0D84: 4267          CLR.W      -(A7)
0D86: 3F2EFFDA      MOVE.W     -38(A6),-(A7)
0D8A: 486EFFDC      PEA        -36(A6)
0D8E: 486EFFE0      PEA        -32(A6)
0D92: 4EAD0B2A      JSR        2858(A5)                       ; JT[2858]
0D96: 3E1F          MOVE.W     (A7)+,D7
0D98: 4A47          TST.W      D7
0D9A: 670A          BEQ.S      $0DA6
0D9C: 0C47FFD9      CMPI.W     #$FFD9,D7
0DA0: 6704          BEQ.S      $0DA6
0DA2: 7001          MOVEQ      #1,D0
0DA4: 6044          BRA.S      $0DEA
0DA6: 4267          CLR.W      -(A7)
0DA8: 3F2EFFDA      MOVE.W     -38(A6),-(A7)
0DAC: 486EFFDC      PEA        -36(A6)
0DB0: 486EFFE0      PEA        -32(A6)
0DB4: 4EAD0B32      JSR        2866(A5)                       ; JT[2866]
0DB8: 4A5F          TST.W      (A7)+
0DBA: 6704          BEQ.S      $0DC0
0DBC: 7001          MOVEQ      #1,D0
0DBE: 602A          BRA.S      $0DEA
0DC0: 4267          CLR.W      -(A7)
0DC2: 3F2EFFDA      MOVE.W     -38(A6),-(A7)
0DC6: 2F2EFFD6      MOVE.L     -42(A6),-(A7)
0DCA: 4EAD0B6A      JSR        2922(A5)                       ; JT[2922]
0DCE: 4A5F          TST.W      (A7)+
0DD0: 6704          BEQ.S      $0DD6
0DD2: 7001          MOVEQ      #1,D0
0DD4: 6014          BRA.S      $0DEA
0DD6: 4267          CLR.W      -(A7)
0DD8: 3F2EFFDA      MOVE.W     -38(A6),-(A7)
0DDC: 4EAD0B22      JSR        2850(A5)                       ; JT[2850]
0DE0: 4A5F          TST.W      (A7)+
0DE2: 6704          BEQ.S      $0DE8
0DE4: 7001          MOVEQ      #1,D0
0DE6: 6002          BRA.S      $0DEA
0DE8: 7000          MOVEQ      #0,D0
0DEA: 2E1F          MOVE.L     (A7)+,D7
0DEC: 4E5E          UNLK       A6
0DEE: 4E75          RTS        
