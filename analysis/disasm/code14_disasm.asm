;======================================================================
; CODE 14 Disassembly
; File: /tmp/maven_code_14.bin
; Header: JT offset=624, JT entries=14
; Code size: 2766 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0008: 286E0008      MOVEA.L    8(A6),A4
000C: 7E00          MOVEQ      #0,D7
000E: 47EDDE28      LEA        -8664(A5),A3                   ; g_flag1
0012: 6008          BRA.S      $001C
0014: 18EB0001      MOVE.B     1(A3),(A4)+
0018: 5247          MOVEA.B    D7,A1
001A: 588B          MOVE.B     A3,(A4)
001C: 4A53          TST.W      (A3)
001E: 66F4          BNE.S      $0014
0020: 4214          CLR.B      (A4)
0022: 202E0008      MOVE.L     8(A6),D0
0026: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
002A: 4E5E          UNLK       A6
002C: 4E75          RTS        


; ======= Function at 0x002E =======
002E: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0032: 4EBA0A40      JSR        2624(PC)
0036: 4EAD043A      JSR        1082(A5)                       ; JT[1082]
003A: 4EAD03FA      JSR        1018(A5)                       ; JT[1018]
003E: 486DC366      PEA        -15514(A5)                     ; g_field_14
0042: 4EBAFFBC      JSR        -68(PC)
0046: 4EAD06AA      JSR        1706(A5)                       ; JT[1706]
004A: 486D02B2      PEA        690(A5)                        ; A5+690
004E: 486EFFFC      PEA        -4(A6)
0052: 4EAD06BA      JSR        1722(A5)                       ; JT[1722]
0056: 0C6D0008A386  CMPI.W     #$0008,-23674(A5)
005C: 4FEF000C      LEA        12(A7),A7
0060: 6406          BCC.S      $0068
0062: 4A6DA386      TST.W      -23674(A5)
0066: 6C04          BGE.S      $006C
0068: 4EAD01A2      JSR        418(A5)                        ; JT[418]
006C: 302DA386      MOVE.W     -23674(A5),D0                  ; A5-23674
0070: 526DA386      MOVEA.B    -23674(A5),A1
0074: C1FC002C41ED  ANDA.L     #$002C41ED,A0
007A: A226          MOVE.L     -(A6),D1
007C: D088          MOVE.B     A0,(A0)
007E: 2040          MOVEA.L    D0,A0
0080: 7000          MOVEQ      #0,D0
0082: 43FA0006      LEA        6(PC),A1
0086: 48D0          DC.W       $48D0
0088: DEF84A40      MOVE.B     $4A40.W,(A7)+
008C: 662E          BNE.S      $00BC
008E: 3F3C0001      MOVE.W     #$0001,-(A7)
0092: 48780078      PEA        $0078.W
0096: 486DC366      PEA        -15514(A5)                     ; g_field_14
009A: 4EAD0AC2      JSR        2754(A5)                       ; JT[2754]
009E: 4EAD01B2      JSR        434(A5)                        ; JT[434]
00A2: 3EADCF04      MOVE.W     -12540(A5),(A7)                ; A5-12540
00A6: 486DA5F0      PEA        -23056(A5)                     ; g_dawg_?
00AA: 486DE2E8      PEA        -7448(A5)                      ; A5-7448
00AE: 4EBA0396      JSR        918(PC)
00B2: 536DA3864FEF  MOVE.B     -23674(A5),20463(A1)           ; A5-23674
00B8: 00126048      ORI.B      #$6048,(A2)
00BC: 2F2DA222      MOVE.L     -24030(A5),-(A7)               ; A5-24030
00C0: 2F2D93AC      MOVE.L     -27732(A5),-(A7)               ; A5-27732
00C4: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
00C8: 4A40          TST.W      D0
00CA: 508F          MOVE.B     A7,(A0)
00CC: 6606          BNE.S      $00D4
00CE: 4EBA0244      JSR        580(PC)
00D2: 6030          BRA.S      $0104
00D4: 4A6DA386      TST.W      -23674(A5)
00D8: 6E04          BGT.S      $00DE
00DA: 4EAD01A2      JSR        418(A5)                        ; JT[418]
00DE: 2B6DA222A222  MOVE.L     -24030(A5),-24030(A5)          ; A5-24030
00E4: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
00EA: C1EDA386      ANDA.L     -23674(A5),A0
00EE: 41EDA226      LEA        -24026(A5),A0                  ; g_common
00F2: D088          MOVE.B     A0,(A0)
00F4: 2040          MOVEA.L    D0,A0
00F6: 7001          MOVEQ      #1,D0
00F8: 4A40          TST.W      D0
00FA: 6602          BNE.S      $00FE
00FC: 7001          MOVEQ      #1,D0
00FE: 4CD8          DC.W       $4CD8
0100: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
0104: 42ADB3E2      CLR.L      -19486(A5)
0108: 4EAD06B2      JSR        1714(A5)                       ; JT[1714]
010C: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
0110: 4EAD06C2      JSR        1730(A5)                       ; JT[1730]
0114: 4E5E          UNLK       A6
0116: 4E75          RTS        


; ======= Function at 0x0118 =======
0118: 4E560000      LINK       A6,#0
011C: 48E70718      MOVEM.L    D5/D6/D7/A3/A4,-(SP)           ; save
0120: 286E0008      MOVEA.L    8(A6),A4
0124: 266E000C      MOVEA.L    12(A6),A3
0128: 2E2C0014      MOVE.L     20(A4),D7
012C: DEAC0010      MOVE.B     16(A4),(A7)
0130: DEAC0018      MOVE.B     24(A4),(A7)
0134: 2C2B0014      MOVE.L     20(A3),D6
0138: DCAB0010      MOVE.B     16(A3),(A6)
013C: DCAB0018      MOVE.B     24(A3),(A6)
0140: BE86          MOVE.W     D6,(A7)
0142: 6E30          BGT.S      $0174
0144: BC87          MOVE.W     D7,(A6)
0146: 6608          BNE.S      $0150
0148: 41EDE2FE      LEA        -7426(A5),A0                   ; A5-7426
014C: 2008          MOVE.L     A0,D0
014E: 602A          BRA.S      $017A
0150: 2A06          MOVE.L     D6,D5
0152: 9A87          MOVE.B     D7,(A5)
0154: 0C85000000C8  CMPI.L     #$000000C8,D5
015A: 6E08          BGT.S      $0164
015C: 41EDE304      LEA        -7420(A5),A0                   ; A5-7420
0160: 2008          MOVE.L     A0,D0
0162: 6016          BRA.S      $017A
0164: 0C85000001F4  CMPI.L     #$000001F4,D5
016A: 6E08          BGT.S      $0174
016C: 41EDE30A      LEA        -7414(A5),A0                   ; A5-7414
0170: 2008          MOVE.L     A0,D0
0172: 6006          BRA.S      $017A
0174: 41EDE30E      LEA        -7410(A5),A0                   ; A5-7410
0178: 2008          MOVE.L     A0,D0
017A: 4CDF18E0      MOVEM.L    (SP)+,D5/D6/D7/A3/A4           ; restore
017E: 4E5E          UNLK       A6
0180: 4E75          RTS        


; ======= Function at 0x0182 =======
0182: 4E56FFF0      LINK       A6,#-16                        ; frame=16
0186: 48E70738      MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)        ; save
018A: 246E0008      MOVEA.L    8(A6),A2
018E: 4EBA0916      JSR        2326(PC)
0192: 4A40          TST.W      D0
0194: 6700013A      BEQ.W      $02D2
0198: 486DC366      PEA        -15514(A5)                     ; g_field_14
019C: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
01A0: 486DC366      PEA        -15514(A5)                     ; g_field_14
01A4: 4EAD0952      JSR        2386(A5)                       ; JT[2386]
01A8: 7E00          MOVEQ      #0,D7
01AA: 49EDDE28      LEA        -8664(A5),A4                   ; g_flag1
01AE: 508F          MOVE.B     A7,(A0)
01B0: 601A          BRA.S      $01CC
01B2: 4A6C0002      TST.W      2(A4)
01B6: 6710          BEQ.S      $01C8
01B8: 47EDA54E      LEA        -23218(A5),A3                  ; A5-23218
01BC: D6C6          MOVE.B     D6,(A3)+
01BE: 4A13          TST.B      (A3)
01C0: 6C04          BGE.S      $01C6
01C2: 4EAD01A2      JSR        418(A5)                        ; JT[418]
01C6: 5313          MOVE.B     (A3),-(A1)
01C8: 5247          MOVEA.B    D7,A1
01CA: 588C          MOVE.B     A4,(A4)
01CC: 3C14          MOVE.W     (A4),D6
01CE: 66E2          BNE.S      $01B2
01D0: 486EFFF0      PEA        -16(A6)
01D4: 4EAD0952      JSR        2386(A5)                       ; JT[2386]
01D8: 49EA001E      LEA        30(A2),A4
01DC: 486EFFF0      PEA        -16(A6)
01E0: 486DC366      PEA        -15514(A5)                     ; g_field_14
01E4: 4EAD09A2      JSR        2466(A5)                       ; JT[2466]
01E8: 3880          MOVE.W     D0,(A4)
01EA: 204D          MOVEA.L    A5,A0
01EC: 3014          MOVE.W     (A4),D0
01EE: D0C0          MOVE.B     D0,(A0)+
01F0: D0C0          MOVE.B     D0,(A0)+
01F2: 3068BBF4      MOVEA.W    -17420(A0),A0
01F6: 25480014      MOVE.L     A0,20(A2)
01FA: 4EBA01B0      JSR        432(PC)
01FE: 48C0          EXT.L      D0
0200: 2C00          MOVE.L     D0,D6
0202: 7E00          MOVEQ      #0,D7
0204: 4FEF000C      LEA        12(A7),A7
0208: 6042          BRA.S      $024C
020A: 3F07          MOVE.W     D7,-(A7)
020C: 4EBA01C4      JSR        452(PC)
0210: 2840          MOVEA.L    D0,A4
0212: 102A0020      MOVE.B     32(A2),D0
0216: B02C0020      MOVE.W     32(A4),D0
021A: 548F          MOVE.B     A7,(A2)
021C: 6618          BNE.S      $0236
021E: 102A0021      MOVE.B     33(A2),D0
0222: B02C0021      MOVE.W     33(A4),D0
0226: 660E          BNE.S      $0236
0228: 2F0C          MOVE.L     A4,-(A7)
022A: 2F0A          MOVE.L     A2,-(A7)
022C: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
0230: 4A40          TST.W      D0
0232: 508F          MOVE.B     A7,(A0)
0234: 6704          BEQ.S      $023A
0236: 7A00          MOVEQ      #0,D5
0238: 6002          BRA.S      $023C
023A: 7A01          MOVEQ      #1,D5
023C: 3F07          MOVE.W     D7,-(A7)
023E: 4EBA01E8      JSR        488(PC)
0242: 4A45          TST.W      D5
0244: 548F          MOVE.B     A7,(A2)
0246: 66000088      BNE.W      $02D2
024A: 5247          MOVEA.B    D7,A1
024C: 3047          MOVEA.W    D7,A0
024E: BC88          MOVE.W     A0,(A6)
0250: 6EB8          BGT.S      $020A
0252: 4A86          TST.L      D6
0254: 6604          BNE.S      $025A
0256: 5286          MOVE.B     D6,(A1)
0258: 6066          BRA.S      $02C0
025A: 7EFF          MOVEQ      #-1,D7
025C: DE46          MOVEA.B    D6,A7
025E: 3F07          MOVE.W     D7,-(A7)
0260: 4EBA0170      JSR        368(PC)
0264: 2840          MOVEA.L    D0,A4
0266: 102A0020      MOVE.B     32(A2),D0
026A: B02C0020      MOVE.W     32(A4),D0
026E: 548F          MOVE.B     A7,(A2)
0270: 6644          BNE.S      $02B6
0272: 486A0001      PEA        1(A2)
0276: 2F0C          MOVE.L     A4,-(A7)
0278: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
027C: 4A40          TST.W      D0
027E: 508F          MOVE.B     A7,(A0)
0280: 6612          BNE.S      $0294
0282: 102C0021      MOVE.B     33(A4),D0
0286: 4880          EXT.W      D0
0288: 122A0021      MOVE.B     33(A2),D1
028C: 4881          EXT.W      D1
028E: 5241          MOVEA.B    D1,A1
0290: B240          MOVEA.W    D0,A1
0292: 6724          BEQ.S      $02B8
0294: 2F0C          MOVE.L     A4,-(A7)
0296: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
029A: 2E80          MOVE.L     D0,(A7)
029C: 2F0C          MOVE.L     A4,-(A7)
029E: 2F0A          MOVE.L     A2,-(A7)
02A0: 4EAD0DD2      JSR        3538(A5)                       ; JT[3538]
02A4: 4A40          TST.W      D0
02A6: 4FEF000C      LEA        12(A7),A7
02AA: 660A          BNE.S      $02B6
02AC: 102A0021      MOVE.B     33(A2),D0
02B0: B02C0021      MOVE.W     33(A4),D0
02B4: 6702          BEQ.S      $02B8
02B6: 5286          MOVE.B     D6,(A1)
02B8: 3F07          MOVE.W     D7,-(A7)
02BA: 4EBA016C      JSR        364(PC)
02BE: 548F          MOVE.B     A7,(A2)
02C0: 2F0A          MOVE.L     A2,-(A7)
02C2: 70FF          MOVEQ      #-1,D0
02C4: D046          MOVEA.B    D6,A0
02C6: 3F00          MOVE.W     D0,-(A7)
02C8: 4EBA0146      JSR        326(PC)
02CC: 4EBA0232      JSR        562(PC)
02D0: 4CEE1CE0FFD8  MOVEM.L    -40(A6),D5/D6/D7/A2/A3/A4
02D6: 4E5E          UNLK       A6
02D8: 4E75          RTS        


; ======= Function at 0x02DA =======
02DA: 4E560000      LINK       A6,#0
02DE: 302DD76A      MOVE.W     -10390(A5),D0                  ; A5-10390
02E2: B06E0008      MOVEA.W    8(A6),A0
02E6: 6716          BEQ.S      $02FE
02E8: 3F2DD76A      MOVE.W     -10390(A5),-(A7)               ; A5-10390
02EC: 4EBA044C      JSR        1100(PC)
02F0: 3B6E0008D76A  MOVE.W     8(A6),-10390(A5)
02F6: 3EADD76A      MOVE.W     -10390(A5),(A7)                ; A5-10390
02FA: 4EBA043E      JSR        1086(PC)
02FE: 4E5E          UNLK       A6
0300: 4E75          RTS        


; ======= Function at 0x0302 =======
0302: 4E560000      LINK       A6,#0
0306: 2F2DDEB8      MOVE.L     -8520(A5),-(A7)                ; A5-8520
030A: 2F2E0008      MOVE.L     8(A6),-(A7)
030E: A91A          MOVE.L     (A2)+,-(A4)
0310: 4E5E          UNLK       A6
0312: 4E75          RTS        

0314: 4267          CLR.W      -(A7)
0316: 2F2DDEB8      MOVE.L     -8520(A5),-(A7)                ; A5-8520
031A: 4EAD0D62      JSR        3426(A5)                       ; JT[3426]
031E: 4257          CLR.W      (A7)
0320: 2F2DDEB0      MOVE.L     -8528(A5),-(A7)                ; A5-8528
0324: 4EAD0D62      JSR        3426(A5)                       ; JT[3426]
0328: 4FEF000A      LEA        10(A7),A7
032C: 4E75          RTS        


; ======= Function at 0x032E =======
032E: 4E56FFF8      LINK       A6,#-8                         ; frame=8
0332: 206E0008      MOVEA.L    8(A6),A0
0336: 2D680010FFF8  MOVE.L     16(A0),-8(A6)
033C: 2D680014FFFC  MOVE.L     20(A0),-4(A6)
0342: 700C          MOVEQ      #12,D0
0344: C1EE000C      ANDA.L     12(A6),A0
0348: 3D40FFFC      MOVE.W     D0,-4(A6)
034C: 3D40FFF8      MOVE.W     D0,-8(A6)
0350: 066E000CFFFC  ADDI.W     #$000C,-4(A6)
0356: 2F08          MOVE.L     A0,-(A7)
0358: A873486E      MOVEA.L    110(A3,D4.L),A4
035C: FFF8A928      MOVE.W     $A928.W,???
0360: 302E000C      MOVE.W     12(A6),D0
0364: 4E5E          UNLK       A6
0366: 4E75          RTS        


; ======= Function at 0x0368 =======
0368: 4E560000      LINK       A6,#0
036C: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
0370: B1EDC3766614  MOVE.W     -15498(A5),$6614.W             ; A5-15498
0376: 4A2DC366      TST.B      -15514(A5)
037A: 670E          BEQ.S      $038A
037C: 4EAD0502      JSR        1282(A5)                       ; JT[1282]
0380: 4A40          TST.W      D0
0382: 6606          BNE.S      $038A
0384: 4A6DD9AE      TST.W      -9810(A5)
0388: 6704          BEQ.S      $038E
038A: 7000          MOVEQ      #0,D0
038C: 6002          BRA.S      $0390
038E: 7001          MOVEQ      #1,D0
0390: 4E5E          UNLK       A6
0392: 4E75          RTS        

0394: 2B78016AA38E  MOVE.L     $016A.W,-23666(A5)
039A: 4EAD06CA      JSR        1738(A5)                       ; JT[1738]
039E: 4E75          RTS        


; ======= Function at 0x03A0 =======
03A0: 4E560000      LINK       A6,#0
03A4: 4EBAFC88      JSR        -888(PC)
03A8: 4E5E          UNLK       A6
03AA: 4E75          RTS        


; ======= Function at 0x03AC =======
03AC: 4E56FFFC      LINK       A6,#-4                         ; frame=4
03B0: 42A7          CLR.L      -(A7)
03B2: 206DDEB8      MOVEA.L    -8520(A5),A0
03B6: 2F2800CA      MOVE.L     202(A0),-(A7)
03BA: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
03BE: 2D5FFFFC      MOVE.L     (A7)+,-4(A6)
03C2: 48780006      PEA        $0006.W
03C6: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
03CA: 4EAD004A      JSR        74(A5)                         ; JT[74]
03CE: 4E5E          UNLK       A6
03D0: 4E75          RTS        


; ======= Function at 0x03D2 =======
03D2: 4E560000      LINK       A6,#0
03D6: 2F0C          MOVE.L     A4,-(A7)
03D8: 7006          MOVEQ      #6,D0
03DA: C1EE0008      ANDA.L     8(A6),A0
03DE: 2840          MOVEA.L    D0,A4
03E0: 206DDEB8      MOVEA.L    -8520(A5),A0
03E4: 206800CA      MOVEA.L    202(A0),A0
03E8: 224C          MOVEA.L    A4,A1
03EA: D3D00C110002  MOVE.B     (A0),$0C110002
03F0: 6704          BEQ.S      $03F6
03F2: 4EAD01A2      JSR        418(A5)                        ; JT[418]
03F6: 206DDEB8      MOVEA.L    -8520(A5),A0
03FA: 206800CA      MOVEA.L    202(A0),A0
03FE: 2010          MOVE.L     (A0),D0
0400: 2F340802      MOVE.L     2(A4,D0.L),-(A7)
0404: 4EAD05EA      JSR        1514(A5)                       ; JT[1514]
0408: 286EFFFC      MOVEA.L    -4(A6),A4
040C: 4E5E          UNLK       A6
040E: 4E75          RTS        


; ======= Function at 0x0410 =======
0410: 4E560000      LINK       A6,#0
0414: 2F2E000A      MOVE.L     10(A6),-(A7)
0418: 3F2E0008      MOVE.W     8(A6),-(A7)
041C: 2F2DDEB8      MOVE.L     -8520(A5),-(A7)                ; A5-8520
0420: 4EAD0152      JSR        338(A5)                        ; JT[338]
0424: 4E5E          UNLK       A6
0426: 4E75          RTS        


; ======= Function at 0x0428 =======
0428: 4E560000      LINK       A6,#0
042C: 206DDEB8      MOVEA.L    -8520(A5),A0
0430: 206800CA      MOVEA.L    202(A0),A0
0434: 7006          MOVEQ      #6,D0
0436: C1EE0008      ANDA.L     8(A6),A0
043A: 2050          MOVEA.L    (A0),A0
043C: 20700802      MOVEA.L    2(A0,D0.L),A0
0440: A02A4E5E      MOVE.L     20062(A2),D0
0444: 4E75          RTS        


; ======= Function at 0x0446 =======
0446: 4E56FFF6      LINK       A6,#-10                        ; frame=10
044A: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
044E: 42A7          CLR.L      -(A7)
0450: 206DDEB8      MOVEA.L    -8520(A5),A0
0454: 2F2800CA      MOVE.L     202(A0),-(A7)
0458: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
045C: 2D5FFFF6      MOVE.L     (A7)+,-10(A6)
0460: 48780006      PEA        $0006.W
0464: 2F2EFFF6      MOVE.L     -10(A6),-(A7)
0468: 4EAD004A      JSR        74(A5)                         ; JT[74]
046C: 2E00          MOVE.L     D0,D7
046E: 7C00          MOVEQ      #0,D6
0470: 99CC601C      MOVE.B     A4,#$1C
0474: 204C          MOVEA.L    A4,A0
0476: D1EE000C2F08  MOVE.B     12(A6),$2F08.W
047C: 3F06          MOVE.W     D6,-(A7)
047E: 2F2DDEB8      MOVE.L     -8520(A5),-(A7)                ; A5-8520
0482: 4EAD0152      JSR        338(A5)                        ; JT[338]
0486: 4FEF000A      LEA        10(A7),A7
048A: 5246          MOVEA.B    D6,A1
048C: 49EC0022      LEA        34(A4),A4
0490: BC6E0010      MOVEA.W    16(A6),A6
0494: 6DDE          BLT.S      $0474
0496: 7006          MOVEQ      #6,D0
0498: C1C6          ANDA.L     D6,A0
049A: 2840          MOVEA.L    D0,A4
049C: 6014          BRA.S      $04B2
049E: 206DDEB8      MOVEA.L    -8520(A5),A0
04A2: 206800CA      MOVEA.L    202(A0),A0
04A6: 2010          MOVE.L     (A0),D0
04A8: 20740802      MOVEA.L    2(A4,D0.L),A0
04AC: A023          MOVE.L     -(A3),D0
04AE: 5246          MOVEA.B    D6,A1
04B0: 5C8C          MOVE.B     A4,(A6)
04B2: 3046          MOVEA.W    D6,A0
04B4: BE88          MOVE.W     A0,(A7)
04B6: 6EE6          BGT.S      $049E
04B8: 206DDEB8      MOVEA.L    -8520(A5),A0
04BC: 7006          MOVEQ      #6,D0
04BE: C1EE0010      ANDA.L     16(A6),A0
04C2: 206800CA      MOVEA.L    202(A0),A0
04C6: A024          MOVE.L     -(A4),D0
04C8: 4A780220      TST.W      $0220.W
04CC: 6704          BEQ.S      $04D2
04CE: 4EAD01A2      JSR        418(A5)                        ; JT[418]
04D2: 4EBA002C      JSR        44(PC)
04D6: 2F2E0008      MOVE.L     8(A6),-(A7)
04DA: 206DDEB8      MOVEA.L    -8520(A5),A0
04DE: 486800AA      PEA        170(A0)
04E2: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
04E6: 2EADDEB8      MOVE.L     -8520(A5),(A7)                 ; A5-8520
04EA: A873206D      MOVEA.L    109(A3,D2.W),A4
04EE: DEB84868      MOVE.B     $4868.W,(A7)
04F2: 0010A928      ORI.B      #$A928,(A0)
04F6: 4CEE10C0FFEA  MOVEM.L    -22(A6),D6/D7/A4
04FC: 4E5E          UNLK       A6
04FE: 4E75          RTS        


; ======= Function at 0x0500 =======
0500: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0504: 2F07          MOVE.L     D7,-(A7)
0506: 42A7          CLR.L      -(A7)
0508: 206DDEB8      MOVEA.L    -8520(A5),A0
050C: 2F2800CA      MOVE.L     202(A0),-(A7)
0510: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0514: 2D5FFFFC      MOVE.L     (A7)+,-4(A6)
0518: 48780006      PEA        $0006.W
051C: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
0520: 4EAD004A      JSR        74(A5)                         ; JT[74]
0524: 3E00          MOVE.W     D0,D7
0526: 4A47          TST.W      D7
0528: 660C          BNE.S      $0536
052A: 2F2DDEB8      MOVE.L     -8520(A5),-(A7)                ; A5-8520
052E: 4EAD0C02      JSR        3074(A5)                       ; JT[3074]
0532: 588F          MOVE.B     A7,(A4)
0534: 6032          BRA.S      $0568
0536: 2F2DDEB8      MOVE.L     -8520(A5),-(A7)                ; A5-8520
053A: 206DDEB8      MOVEA.L    -8520(A5),A0
053E: 3F280016      MOVE.W     22(A0),-(A7)
0542: 700C          MOVEQ      #12,D0
0544: C1C7          ANDA.L     D7,A0
0546: 3F00          MOVE.W     D0,-(A7)
0548: 1F3C0001      MOVE.B     #$01,-(A7)
054C: A91D          MOVE.L     (A5)+,-(A4)
054E: BE6DD76A      MOVEA.W    -10390(A5),A7
0552: 6E14          BGT.S      $0568
0554: 70FF          MOVEQ      #-1,D0
0556: D047          MOVEA.B    D7,A0
0558: 3B40D76A      MOVE.W     D0,-10390(A5)
055C: 42ADE368      CLR.L      -7320(A5)
0560: 3F00          MOVE.W     D0,-(A7)
0562: 4EBA01D6      JSR        470(PC)
0566: 548F          MOVE.B     A7,(A2)
0568: 2E1F          MOVE.L     (A7)+,D7
056A: 4E5E          UNLK       A6
056C: 4E75          RTS        


; ======= Function at 0x056E =======
056E: 4E56FF58      LINK       A6,#-168                       ; frame=168
0572: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0576: 286E0008      MOVEA.L    8(A6),A4
057A: 426EFF60      CLR.W      -160(A6)
057E: 426EFF62      CLR.W      -158(A6)
0582: 2F2C0018      MOVE.L     24(A4),-(A7)
0586: A8D4          MOVE.L     (A4),(A4)+
0588: 47EEFFDE      LEA        -34(A6),A3
058C: 206C00CA      MOVEA.L    202(A4),A0
0590: 2050          MOVEA.L    (A0),A0
0592: 20680002      MOVEA.L    2(A0),A0
0596: 2050          MOVEA.L    (A0),A0
0598: 43EEFFBC      LEA        -68(A6),A1
059C: 7007          MOVEQ      #7,D0
059E: 22D8          MOVE.L     (A0)+,(A1)+
05A0: 51C8FFFC      DBF        D0,$059E                       ; loop
05A4: 32D8          MOVE.W     (A0)+,(A1)+
05A6: 41EEFFDE      LEA        -34(A6),A0
05AA: 43E9FFDE      LEA        -34(A1),A1
05AE: 7007          MOVEQ      #7,D0
05B0: 20D9          MOVE.L     (A1)+,(A0)+
05B2: 51C8FFFC      DBF        D0,$05B0                       ; loop
05B6: 30D9          MOVE.W     (A1)+,(A0)+
05B8: 282B0014      MOVE.L     20(A3),D4
05BC: D8AB0010      MOVE.B     16(A3),(A4)
05C0: D8AB0018      MOVE.B     24(A3),(A4)
05C4: 2A04          MOVE.L     D4,D5
05C6: 42A7          CLR.L      -(A7)
05C8: 2F2C00CA      MOVE.L     202(A4),-(A7)
05CC: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
05D0: 2D5FFF58      MOVE.L     (A7)+,-168(A6)
05D4: 48780006      PEA        $0006.W
05D8: 2F2EFF58      MOVE.L     -168(A6),-(A7)
05DC: 4EAD004A      JSR        74(A5)                         ; JT[74]
05E0: 2D40FF68      MOVE.L     D0,-152(A6)
05E4: 7600          MOVEQ      #0,D3
05E6: 41EC0016      LEA        22(A4),A0
05EA: 2D48FF70      MOVE.L     A0,-144(A6)
05EE: 43EC0012      LEA        18(A4),A1
05F2: 2D49FF6C      MOVE.L     A1,-148(A6)
05F6: 7C0C          MOVEQ      #12,D6
05F8: CDC3          ANDA.L     D3,A6
05FA: 7206          MOVEQ      #6,D1
05FC: C3C3          ANDA.L     D3,A1
05FE: 2D41FF64      MOVE.L     D1,-156(A6)
0602: 6000011A      BRA.W      $0720
0606: 206C00CA      MOVEA.L    202(A4),A0
060A: 2050          MOVEA.L    (A0),A0
060C: D1EEFF642068  MOVE.B     -156(A6),$2068.W
0612: 00022050      ORI.B      #$2050,D2
0616: 43EEFFDE      LEA        -34(A6),A1
061A: 7007          MOVEQ      #7,D0
061C: 22D8          MOVE.L     (A0)+,(A1)+
061E: 51C8FFFC      DBF        D0,$061C                       ; loop
0622: 32D8          MOVE.W     (A0)+,(A1)+
0624: 45EDFAC2      LEA        -1342(A5),A2                   ; A5-1342
0628: 2E2B0014      MOVE.L     20(A3),D7
062C: DEAB0010      MOVE.B     16(A3),(A7)
0630: DEAB0018      MOVE.B     24(A3),(A7)
0634: 2004          MOVE.L     D4,D0
0636: 9087          MOVE.B     D7,(A0)
0638: 2D40FF5C      MOVE.L     D0,-164(A6)
063C: 0C80000000C8  CMPI.L     #$000000C8,D0
0642: 6F16          BLE.S      $065A
0644: 2004          MOVE.L     D4,D0
0646: 9085          MOVE.B     D5,(A0)
0648: 0C80000000C8  CMPI.L     #$000000C8,D0
064E: 6E0A          BGT.S      $065A
0650: 4A6EFF60      TST.W      -160(A6)
0654: 6604          BNE.S      $065A
0656: 45EDFAB2      LEA        -1358(A5),A2                   ; A5-1358
065A: 0CAE000001F4FF5C  CMPI.L     #$000001F4,-164(A6)
0662: 6F16          BLE.S      $067A
0664: 2004          MOVE.L     D4,D0
0666: 9085          MOVE.B     D5,(A0)
0668: 0C80000001F4  CMPI.L     #$000001F4,D0
066E: 6E0A          BGT.S      $067A
0670: 4A6EFF62      TST.W      -158(A6)
0674: 6604          BNE.S      $067A
0676: 45EDFABA      LEA        -1350(A5),A2                   ; A5-1350
067A: 41EDFAC2      LEA        -1342(A5),A0                   ; A5-1342
067E: B1CA6742      MOVE.W     A2,$6742.W
0682: 41EDFAB2      LEA        -1358(A5),A0                   ; A5-1358
0686: B1CA57C0      MOVE.W     A2,$57C0.W
068A: 4400          NEG.B      D0
068C: 4880          EXT.W      D0
068E: 3D40FF60      MOVE.W     D0,-160(A6)
0692: 41EDFABA      LEA        -1350(A5),A0                   ; A5-1350
0696: B1CA57C1      MOVE.W     A2,$57C1.W
069A: 4401          NEG.B      D1
069C: 4881          EXT.W      D1
069E: 3D41FF62      MOVE.W     D1,-158(A6)
06A2: 4267          CLR.W      -(A7)
06A4: 3F06          MOVE.W     D6,-(A7)
06A6: A893          MOVE.L     (A3),(A4)
06A8: 2F0A          MOVE.L     A2,-(A7)
06AA: A89D          MOVE.L     (A5)+,(A4)
06AC: 206EFF6C      MOVEA.L    -148(A6),A0
06B0: 226EFF70      MOVEA.L    -144(A6),A1
06B4: 3011          MOVE.W     (A1),D0
06B6: 9050          MOVEA.B    (A0),A0
06B8: 3F00          MOVE.W     D0,-(A7)
06BA: 4267          CLR.W      -(A7)
06BC: A892          MOVE.L     (A2),(A4)
06BE: 486DFABA      PEA        -1350(A5)                      ; A5-1350
06C2: A89D          MOVE.L     (A5)+,(A4)
06C4: 2A07          MOVE.L     D7,D5
06C6: 2F0B          MOVE.L     A3,-(A7)
06C8: 2F0B          MOVE.L     A3,-(A7)
06CA: 2F0B          MOVE.L     A3,-(A7)
06CC: 4A2B0020      TST.B      32(A3)
06D0: 6704          BEQ.S      $06D6
06D2: 7004          MOVEQ      #4,D0
06D4: 6002          BRA.S      $06D8
06D6: 7004          MOVEQ      #4,D0
06D8: 3F00          MOVE.W     D0,-(A7)
06DA: 2F0B          MOVE.L     A3,-(A7)
06DC: 486EFFBC      PEA        -68(A6)
06E0: 2F0B          MOVE.L     A3,-(A7)
06E2: 4EBAFA34      JSR        -1484(PC)
06E6: 588F          MOVE.B     A7,(A4)
06E8: 2E80          MOVE.L     D0,(A7)
06EA: 206DDEB8      MOVEA.L    -8520(A5),A0
06EE: 486800AA      PEA        170(A0)
06F2: 486EFF75      PEA        -139(A6)
06F6: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
06FA: 1D40FF74      MOVE.B     D0,-140(A6)
06FE: 3EBC0001      MOVE.W     #$0001,(A7)
0702: 700A          MOVEQ      #10,D0
0704: D046          MOVEA.B    D6,A0
0706: 3F00          MOVE.W     D0,-(A7)
0708: A893          MOVE.L     (A3),(A4)
070A: 486EFF74      PEA        -140(A6)
070E: A884          MOVE.L     D4,(A4)
0710: 4FEF001C      LEA        28(A7),A7
0714: 5243          MOVEA.B    D3,A1
0716: 0646000C      ADDI.W     #$000C,D6
071A: 5CAEFF64      MOVE.B     -156(A6),(A6)
071E: 3043          MOVEA.W    D3,A0
0720: B1EEFF686D00  MOVE.W     -152(A6),$6D00.W
0726: FEE0          MOVE.W     -(A0),(A7)+
0728: 3F2DD76A      MOVE.W     -10390(A5),-(A7)               ; A5-10390
072C: 4EBA000C      JSR        12(PC)
0730: 4CEE1CF8FF38  MOVEM.L    -200(A6),D3/D4/D5/D6/D7/A2/A3/A4
0736: 4E5E          UNLK       A6
0738: 4E75          RTS        


; ======= Function at 0x073A =======
073A: 4E56FFF8      LINK       A6,#-8                         ; frame=8
073E: 4A6E0008      TST.W      8(A6)
0742: 6D30          BLT.S      $0774
0744: 2F2DDEB8      MOVE.L     -8520(A5),-(A7)                ; A5-8520
0748: A873206D      MOVEA.L    109(A3,D2.W),A4
074C: DEB82D68      MOVE.B     $2D68.W,(A7)
0750: 0010FFF8      ORI.B      #$FFF8,(A0)
0754: 2D680014FFFC  MOVE.L     20(A0),-4(A6)
075A: 700C          MOVEQ      #12,D0
075C: C1EE0008      ANDA.L     8(A6),A0
0760: 3D40FFFC      MOVE.W     D0,-4(A6)
0764: 3D40FFF8      MOVE.W     D0,-8(A6)
0768: 066E000CFFFC  ADDI.W     #$000C,-4(A6)
076E: 486EFFF8      PEA        -8(A6)
0772: A8A4          MOVE.L     -(A4),(A4)
0774: 4E5E          UNLK       A6
0776: 4E75          RTS        


; ======= Function at 0x0778 =======
0778: 4E56FFC4      LINK       A6,#-60                        ; frame=60
077C: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0780: 266E0008      MOVEA.L    8(A6),A3
0784: 286E000C      MOVEA.L    12(A6),A4
0788: 2D6C000AFFFC  MOVE.L     10(A4),-4(A6)
078E: 2F0B          MOVE.L     A3,-(A7)
0790: A873B7ED      MOVEA.L    -19(A3,A3.W*8),A4
0794: DEB86704      MOVE.B     $6704.W,(A7)
0798: 4EAD01A2      JSR        418(A5)                        ; JT[418]
079C: 486EFFFC      PEA        -4(A6)
07A0: A8713E2E      MOVEA.L    46(A1,D3.L*8),A4
07A4: FFFC48C7      MOVE.W     #$48C7,???
07A8: 8FFC000C0C54  ORA.L      #$000C0C54,A7
07AE: 00016600      ORI.B      #$6600,D1
07B2: 016E4EAD      BCHG       D0,20141(A6)
07B6: 043ABE6DD76A  SUBI.B     #$BE6D,-10390(PC)
07BC: 6600015C      BNE.W      $091C
07C0: 202C0006      MOVE.L     6(A4),D0
07C4: 90ADE368      MOVE.B     -7320(A5),(A0)                 ; A5-7320
07C8: B0B802F0      MOVE.W     $02F0.W,(A0)
07CC: 6200014C      BHI.W      $091C
07D0: 246B00CA      MOVEA.L    202(A3),A2
07D4: 42A7          CLR.L      -(A7)
07D6: 2F0A          MOVE.L     A2,-(A7)
07D8: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
07DC: 2D5FFFC4      MOVE.L     (A7)+,-60(A6)
07E0: 48780006      PEA        $0006.W
07E4: 2F2EFFC4      MOVE.L     -60(A6),-(A7)
07E8: 4EAD004A      JSR        74(A5)                         ; JT[74]
07EC: 3C00          MOVE.W     D0,D6
07EE: BC47          MOVEA.W    D7,A6
07F0: 6F000128      BLE.W      $091C
07F4: 7006          MOVEQ      #6,D0
07F6: C1C7          ANDA.L     D7,A0
07F8: 2052          MOVEA.L    (A2),A0
07FA: 20700802      MOVEA.L    2(A0,D0.L),A0
07FE: 2050          MOVEA.L    (A0),A0
0800: 43EEFFCA      LEA        -54(A6),A1
0804: 7007          MOVEQ      #7,D0
0806: 22D8          MOVE.L     (A0)+,(A1)+
0808: 51C8FFFC      DBF        D0,$0806                       ; loop
080C: 32D8          MOVE.W     (A0)+,(A1)+
080E: 4A2EFFEA      TST.B      -22(A6)
0812: 6644          BNE.S      $0858
0814: 486EFFCA      PEA        -54(A6)
0818: 486DA74E      PEA        -22706(A5)                     ; A5-22706
081C: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0820: 47EEFFCA      LEA        -54(A6),A3
0824: 508F          MOVE.B     A7,(A0)
0826: 6024          BRA.S      $084C
0828: 7A00          MOVEQ      #0,D5
082A: 45EDDE28      LEA        -8664(A5),A2                   ; g_flag1
082E: 6004          BRA.S      $0834
0830: 5245          MOVEA.B    D5,A1
0832: 588A          MOVE.B     A2,(A4)
0834: 4A6A0002      TST.W      2(A2)
0838: 66F6          BNE.S      $0830
083A: BC52          MOVEA.W    (A2),A6
083C: 66F2          BNE.S      $0830
083E: 3F3C0001      MOVE.W     #$0001,-(A7)
0842: 3F05          MOVE.W     D5,-(A7)
0844: 4EAD0562      JSR        1378(A5)                       ; JT[1378]
0848: 588F          MOVE.B     A7,(A4)
084A: 528B          MOVE.B     A3,(A1)
084C: 1C13          MOVE.B     (A3),D6
084E: 4886          EXT.W      D6
0850: 4A46          TST.W      D6
0852: 66D4          BNE.S      $0828
0854: 600000C4      BRA.W      $091C
0858: 486EFFEC      PEA        -20(A6)
085C: 486DC366      PEA        -15514(A5)                     ; g_field_14
0860: 486EFFCA      PEA        -54(A6)
0864: 4EAD098A      JSR        2442(A5)                       ; JT[2442]
0868: 0C2E0010FFEA  CMPI.B     #$0010,-22(A6)
086E: 4FEF000C      LEA        12(A7),A7
0872: 6C10          BGE.S      $0884
0874: 1A2EFFEA      MOVE.B     -22(A6),D5
0878: 4885          EXT.W      D5
087A: 182EFFEB      MOVE.B     -21(A6),D4
087E: 4884          EXT.W      D4
0880: 7600          MOVEQ      #0,D3
0882: 6042          BRA.S      $08C6
0884: 4A6DBCF4      TST.W      -17164(A5)
0888: 6712          BEQ.S      $089C
088A: 3A2DBCF8      MOVE.W     -17160(A5),D5                  ; A5-17160
088E: 70F1          MOVEQ      #-15,D0
0890: D06DBCF4      MOVEA.B    -17164(A5),A0
0894: 3B40BCF8      MOVE.W     D0,-17160(A5)
0898: 3B45BCF4      MOVE.W     D5,-17164(A5)
089C: 4A6DBCF6      TST.W      -17162(A5)
08A0: 6712          BEQ.S      $08B4
08A2: 3A2DBCFA      MOVE.W     -17158(A5),D5                  ; A5-17158
08A6: 70F1          MOVEQ      #-15,D0
08A8: D06DBCF6      MOVEA.B    -17162(A5),A0
08AC: 3B40BCFA      MOVE.W     D0,-17158(A5)
08B0: 3B45BCF6      MOVE.W     D5,-17162(A5)
08B4: 1A2EFFEB      MOVE.B     -21(A6),D5
08B8: 4885          EXT.W      D5
08BA: 182EFFEA      MOVE.B     -22(A6),D4
08BE: 4884          EXT.W      D4
08C0: 0644FFF1      ADDI.W     #$FFF1,D4
08C4: 7601          MOVEQ      #1,D3
08C6: 7001          MOVEQ      #1,D0
08C8: 9043          MOVEA.B    D3,A0
08CA: 3D40FFC8      MOVE.W     D0,-56(A6)
08CE: 47EEFFCA      LEA        -54(A6),A3
08D2: 603E          BRA.S      $0912
08D4: 48780001      PEA        $0001.W
08D8: BA6DBCF4      MOVEA.W    -17164(A5),A5
08DC: 6606          BNE.S      $08E4
08DE: B86DBCF8      MOVEA.W    -17160(A5),A4
08E2: 670C          BEQ.S      $08F0
08E4: BA6DBCF6      MOVEA.W    -17162(A5),A5
08E8: 660A          BNE.S      $08F4
08EA: B86DBCFA      MOVEA.W    -17158(A5),A4
08EE: 6604          BNE.S      $08F4
08F0: 3006          MOVE.W     D6,D0
08F2: 6008          BRA.S      $08FC
08F4: 3F06          MOVE.W     D6,-(A7)
08F6: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
08FA: 548F          MOVE.B     A7,(A2)
08FC: 3F00          MOVE.W     D0,-(A7)
08FE: 3F04          MOVE.W     D4,-(A7)
0900: 3F05          MOVE.W     D5,-(A7)
0902: 4EAD055A      JSR        1370(A5)                       ; JT[1370]
0906: 4FEF000A      LEA        10(A7),A7
090A: DA43          MOVEA.B    D3,A5
090C: D86EFFC8      MOVEA.B    -56(A6),A4
0910: 528B          MOVE.B     A3,(A1)
0912: 1C13          MOVE.B     (A3),D6
0914: 4886          EXT.W      D6
0916: 4A46          TST.W      D6
0918: 66BA          BNE.S      $08D4
091A: 2B6C0006E368  MOVE.L     6(A4),-7320(A5)
0920: 3F07          MOVE.W     D7,-(A7)
0922: 4EBAF9B6      JSR        -1610(PC)
0926: 4CEE1CF8FFA4  MOVEM.L    -92(A6),D3/D4/D5/D6/D7/A2/A3/A4
092C: 4E5E          UNLK       A6
092E: 4E75          RTS        


; ======= Function at 0x0930 =======
0930: 4E56FFF4      LINK       A6,#-12                        ; frame=12
0934: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0938: 286E0008      MOVEA.L    8(A6),A4
093C: 2F0C          MOVE.L     A4,-(A7)
093E: A8732D6C      MOVEA.L    108(A3,D2.L*4),A4
0942: 0010FFF8      ORI.B      #$FFF8,(A0)
0946: 2D6C0014FFFC  MOVE.L     20(A4),-4(A6)
094C: 42A7          CLR.L      -(A7)
094E: 2F2C00CA      MOVE.L     202(A4),-(A7)
0952: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0956: 2D5FFFF4      MOVE.L     (A7)+,-12(A6)
095A: 48780006      PEA        $0006.W
095E: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
0962: 4EAD004A      JSR        74(A5)                         ; JT[74]
0966: 2E00          MOVE.L     D0,D7
0968: 4A6DD76A      TST.W      -10390(A5)
096C: 6D08          BLT.S      $0976
096E: 306DD76A      MOVEA.W    -10390(A5),A0
0972: BE88          MOVE.W     A0,(A7)
0974: 6E04          BGT.S      $097A
0976: 4EAD01A2      JSR        418(A5)                        ; JT[418]
097A: 700C          MOVEQ      #12,D0
097C: C1EDD76A      ANDA.L     -10390(A5),A0
0980: 3D40FFF8      MOVE.W     D0,-8(A6)
0984: 486EFFF8      PEA        -8(A6)
0988: A9284A87      MOVE.L     19079(A0),-(A4)
098C: 6E04          BGT.S      $0992
098E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0992: 42A7          CLR.L      -(A7)
0994: 2F2C00CA      MOVE.L     202(A4),-(A7)
0998: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
099C: 2D5FFFF4      MOVE.L     (A7)+,-12(A6)
09A0: 2F07          MOVE.L     D7,-(A7)
09A2: 48780006      PEA        $0006.W
09A6: 4EAD0042      JSR        66(A5)                         ; JT[66]
09AA: B0AEFFF4      MOVE.W     -12(A6),(A0)
09AE: 6704          BEQ.S      $09B4
09B0: 4EAD01A2      JSR        418(A5)                        ; JT[418]
09B4: 2F2C00CA      MOVE.L     202(A4),-(A7)
09B8: 4EAD05EA      JSR        1514(A5)                       ; JT[1514]
09BC: 2640          MOVEA.L    D0,A3
09BE: 7006          MOVEQ      #6,D0
09C0: C1EDD76A      ANDA.L     -10390(A5),A0
09C4: 20730802      MOVEA.L    2(A3,D0.L),A0
09C8: A023          MOVE.L     -(A3),D0
09CA: 7006          MOVEQ      #6,D0
09CC: 2E80          MOVE.L     D0,(A7)
09CE: 306DD76A      MOVEA.W    -10390(A5),A0
09D2: 2007          MOVE.L     D7,D0
09D4: 53809088      MOVE.B     D0,-120(A1,A1.W)
09D8: 2F00          MOVE.L     D0,-(A7)
09DA: 4EAD0042      JSR        66(A5)                         ; JT[66]
09DE: 2F00          MOVE.L     D0,-(A7)
09E0: 7006          MOVEQ      #6,D0
09E2: C1EDD76A      ANDA.L     -10390(A5),A0
09E6: 48730806      PEA        6(A3,D0.L)
09EA: 7006          MOVEQ      #6,D0
09EC: C1EDD76A      ANDA.L     -10390(A5),A0
09F0: 48730800      PEA        0(A3,D0.L)
09F4: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
09F8: 206C00CA      MOVEA.L    202(A4),A0
09FC: A02A70FA      MOVE.L     28922(A2),D0
0A00: 2E80          MOVE.L     D0,(A7)
0A02: 2F2C00CA      MOVE.L     202(A4),-(A7)
0A06: 4EAD05CA      JSR        1482(A5)                       ; JT[1482]
0A0A: 4EBAFAF4      JSR        -1292(PC)
0A0E: 4CEE1880FFE8  MOVEM.L    -24(A6),D7/A3/A4
0A14: 4E5E          UNLK       A6
0A16: 4E75          RTS        


; ======= Function at 0x0A18 =======
0A18: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0A1C: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0A20: 42A7          CLR.L      -(A7)
0A22: 206E0008      MOVEA.L    8(A6),A0
0A26: 2F2800CA      MOVE.L     202(A0),-(A7)
0A2A: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0A2E: 2D5FFFFC      MOVE.L     (A7)+,-4(A6)
0A32: 48780006      PEA        $0006.W
0A36: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
0A3A: 4EAD004A      JSR        74(A5)                         ; JT[74]
0A3E: 306DD76A      MOVEA.W    -10390(A5),A0
0A42: B088          MOVE.W     A0,(A0)
0A44: 630E          BLS.S      $0A54
0A46: 4A6DD76A      TST.W      -10390(A5)
0A4A: 6D08          BLT.S      $0A54
0A4C: 49EDE36C      LEA        -7316(A5),A4                   ; A5-7316
0A50: 7E01          MOVEQ      #1,D7
0A52: 6006          BRA.S      $0A5A
0A54: 286DF250      MOVEA.L    -3504(A5),A4
0A58: 7E00          MOVEQ      #0,D7
0A5A: 2F2E000C      MOVE.L     12(A6),-(A7)
0A5E: 4267          CLR.W      -(A7)
0A60: 2F2E0010      MOVE.L     16(A6),-(A7)
0A64: A86B2F0C      MOVEA.L    12044(A3),A4
0A68: A9472007      MOVE.L     D7,8199(A4)
0A6C: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
0A70: 4E5E          UNLK       A6
0A72: 4E75          RTS        

0A74: 2F2DDEB8      MOVE.L     -8520(A5),-(A7)                ; A5-8520
0A78: 486DE376      PEA        -7306(A5)                      ; A5-7306
0A7C: A91A          MOVE.L     (A2)+,-(A4)
0A7E: 2F2DDEB8      MOVE.L     -8520(A5),-(A7)                ; A5-8520
0A82: 4EAD0C3A      JSR        3130(A5)                       ; JT[3130]
0A86: 2EADDEB8      MOVE.L     -8520(A5),(A7)                 ; A5-8520
0A8A: 4EAD0C1A      JSR        3098(A5)                       ; JT[3098]
0A8E: 2EADDEB8      MOVE.L     -8520(A5),(A7)                 ; A5-8520
0A92: A873206D      MOVEA.L    109(A3,D2.W),A4
0A96: DEB84868      MOVE.B     $4868.W,(A7)
0A9A: 0010A8A3      ORI.B      #$A8A3,(A0)
0A9E: 3B7CFFFFD76A  MOVE.W     #$FFFF,-10390(A5)
0AA4: 4E75          RTS        

0AA6: 2F2DDEB8      MOVE.L     -8520(A5),-(A7)                ; A5-8520
0AAA: 4EAD066A      JSR        1642(A5)                       ; JT[1642]
0AAE: 4A40          TST.W      D0
0AB0: 588F          MOVE.B     A7,(A4)
0AB2: 6612          BNE.S      $0AC6
0AB4: 42A7          CLR.L      -(A7)
0AB6: 206DDEB8      MOVEA.L    -8520(A5),A0
0ABA: 2F2800CA      MOVE.L     202(A0),-(A7)
0ABE: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0AC2: 4A9F          TST.L      (A7)+
0AC4: 6604          BNE.S      $0ACA
0AC6: 7000          MOVEQ      #0,D0
0AC8: 6002          BRA.S      $0ACC
0ACA: 7001          MOVEQ      #1,D0
0ACC: 4E75          RTS        
