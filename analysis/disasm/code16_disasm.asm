;======================================================================
; CODE 16 Disassembly
; File: /tmp/maven_code_16.bin
; Header: JT offset=776, JT entries=5
; Code size: 1894 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0008: 286E0008      MOVEA.L    8(A6),A4
000C: 266E000C      MOVEA.L    12(A6),A3
0010: 7E00          MOVEQ      #0,D7
0012: 6006          BRA.S      $001A
0014: 201C          MOVE.L     (A4)+,D0
0016: D19B5247      MOVE.B     (A3)+,71(A0,D5.W*2)
001A: 0C470016      CMPI.W     #$0016,D7
001E: 65F4          BCS.S      $0014
0020: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
0024: 4E5E          UNLK       A6
0026: 4E75          RTS        


; ======= Function at 0x0028 =======
0028: 4E560000      LINK       A6,#0
002C: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
0030: 286E0008      MOVEA.L    8(A6),A4
0034: 2E2E0010      MOVE.L     16(A6),D7
0038: 48780064      PEA        $0064.W
003C: 2F07          MOVE.L     D7,-(A7)
003E: 4EAD0042      JSR        66(A5)                         ; JT[66]
0042: 2E00          MOVE.L     D0,D7
0044: 48780002      PEA        $0002.W
0048: 2F07          MOVE.L     D7,-(A7)
004A: 4EAD005A      JSR        90(A5)                         ; JT[90]
004E: 2C00          MOVE.L     D0,D6
0050: 206E000C      MOVEA.L    12(A6),A0
0054: 43D4          LEA        (A4),A1
0056: 7015          MOVEQ      #21,D0
0058: 22D8          MOVE.L     (A0)+,(A1)+
005A: 51C8FFFC      DBF        D0,$0058                       ; loop
005E: DDAC0004DDAC  MOVE.B     4(A4),-84(A6,A5.L*4)
0064: 0008DDAC      ORI.B      #$DDAC,A0
0068: 000CDDAC      ORI.B      #$DDAC,A4
006C: 0010DDAC      ORI.B      #$DDAC,(A0)
0070: 0014DDAC      ORI.B      #$DDAC,(A4)
0074: 001CDDAC      ORI.B      #$DDAC,(A4)+
0078: 0020DDAC      ORI.B      #$DDAC,-(A0)
007C: 0024DDAC      ORI.B      #$DDAC,-(A4)
0080: 0028DDAC002C  ORI.B      #$DDAC,44(A0)
0086: DDAC00304878  MOVE.B     48(A4),120(A6,D4.L)
008C: 00022F14      ORI.B      #$2F14,D2
0090: 4EAD005A      JSR        90(A5)                         ; JT[90]
0094: D1AC003841EC  MOVE.B     56(A4),-20(A0,D4.W)
009A: 00042F07      ORI.B      #$2F07,D4
009E: 2F10          MOVE.L     (A0),-(A7)
00A0: 4EAD005A      JSR        90(A5)                         ; JT[90]
00A4: 2080          MOVE.L     D0,(A0)
00A6: 43EC0008      LEA        8(A4),A1
00AA: 2F07          MOVE.L     D7,-(A7)
00AC: 2F11          MOVE.L     (A1),-(A7)
00AE: 4EAD005A      JSR        90(A5)                         ; JT[90]
00B2: 2280          MOVE.L     D0,(A1)
00B4: 41EC000C      LEA        12(A4),A0
00B8: 2F07          MOVE.L     D7,-(A7)
00BA: 2F10          MOVE.L     (A0),-(A7)
00BC: 4EAD005A      JSR        90(A5)                         ; JT[90]
00C0: 2080          MOVE.L     D0,(A0)
00C2: 41EC0010      LEA        16(A4),A0
00C6: 2F07          MOVE.L     D7,-(A7)
00C8: 2F10          MOVE.L     (A0),-(A7)
00CA: 4EAD005A      JSR        90(A5)                         ; JT[90]
00CE: 2080          MOVE.L     D0,(A0)
00D0: 41EC0014      LEA        20(A4),A0
00D4: 2F07          MOVE.L     D7,-(A7)
00D6: 2F10          MOVE.L     (A0),-(A7)
00D8: 4EAD005A      JSR        90(A5)                         ; JT[90]
00DC: 2080          MOVE.L     D0,(A0)
00DE: 41EC001C      LEA        28(A4),A0
00E2: 2F07          MOVE.L     D7,-(A7)
00E4: 2F10          MOVE.L     (A0),-(A7)
00E6: 4EAD005A      JSR        90(A5)                         ; JT[90]
00EA: 2080          MOVE.L     D0,(A0)
00EC: 41EC0020      LEA        32(A4),A0
00F0: 2F07          MOVE.L     D7,-(A7)
00F2: 2F10          MOVE.L     (A0),-(A7)
00F4: 4EAD005A      JSR        90(A5)                         ; JT[90]
00F8: 2080          MOVE.L     D0,(A0)
00FA: 41EC0024      LEA        36(A4),A0
00FE: 2F07          MOVE.L     D7,-(A7)
0100: 2F10          MOVE.L     (A0),-(A7)
0102: 4EAD005A      JSR        90(A5)                         ; JT[90]
0106: 2080          MOVE.L     D0,(A0)
0108: 41EC0028      LEA        40(A4),A0
010C: 2F07          MOVE.L     D7,-(A7)
010E: 2F10          MOVE.L     (A0),-(A7)
0110: 4EAD005A      JSR        90(A5)                         ; JT[90]
0114: 2080          MOVE.L     D0,(A0)
0116: 41EC002C      LEA        44(A4),A0
011A: 2F07          MOVE.L     D7,-(A7)
011C: 2F10          MOVE.L     (A0),-(A7)
011E: 4EAD005A      JSR        90(A5)                         ; JT[90]
0122: 2080          MOVE.L     D0,(A0)
0124: 41EC0030      LEA        48(A4),A0
0128: 2F07          MOVE.L     D7,-(A7)
012A: 2F10          MOVE.L     (A0),-(A7)
012C: 4EAD005A      JSR        90(A5)                         ; JT[90]
0130: 2080          MOVE.L     D0,(A0)
0132: 41EC0038      LEA        56(A4),A0
0136: 2F14          MOVE.L     (A4),-(A7)
0138: 2F10          MOVE.L     (A0),-(A7)
013A: 4EAD005A      JSR        90(A5)                         ; JT[90]
013E: 2080          MOVE.L     D0,(A0)
0140: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
0144: 4E5E          UNLK       A6
0146: 4E75          RTS        


; ======= Function at 0x0148 =======
0148: 4E56FF14      LINK       A6,#-236                       ; frame=236
014C: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0150: 286E0008      MOVEA.L    8(A6),A4
0154: 206DDE78      MOVEA.L    -8584(A5),A0
0158: 2050          MOVEA.L    (A0),A0
015A: 30280302      MOVE.W     770(A0),D0
015E: 204D          MOVEA.L    A5,A0
0160: 48C0          EXT.L      D0
0162: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0166: 2F28E4D4      MOVE.L     -6956(A0),-(A7)
016A: 486DE4E4      PEA        -6940(A5)                      ; A5-6940
016E: 2F0C          MOVE.L     A4,-(A7)
0170: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0174: D8C0          MOVE.B     D0,(A4)+
0176: 486EFFFC      PEA        -4(A6)
017A: 4EBA03CE      JSR        974(PC)
017E: 2640          MOVEA.L    D0,A3
0180: 200B          MOVE.L     A3,D0
0182: 4FEF0010      LEA        16(A7),A7
0186: 6700035C      BEQ.W      $04E6
018A: 42AEFF22      CLR.L      -222(A6)
018E: 42AEFF30      CLR.L      -208(A6)
0192: 42AEFF28      CLR.L      -216(A6)
0196: 42AEFF2C      CLR.L      -212(A6)
019A: 7C00          MOVEQ      #0,D6
019C: 2A06          MOVE.L     D6,D5
019E: 7800          MOVEQ      #0,D4
01A0: 2E13          MOVE.L     (A3),D7
01A2: 206DDE78      MOVEA.L    -8584(A5),A0
01A6: 2050          MOVEA.L    (A0),A0
01A8: 3D680302FF26  MOVE.W     770(A0),-218(A6)
01AE: 2004          MOVE.L     D4,D0
01B0: 48C0          EXT.L      D0
01B2: E7882440      MOVE.L     A0,64(A3,D2.W*4)
01B6: 6062          BRA.S      $021A
01B8: 30327806      MOVE.W     6(A2,D7.L),D0
01BC: B06EFF26      MOVEA.W    -218(A6),A0
01C0: 6654          BNE.S      $0216
01C2: 204A          MOVEA.L    A2,A0
01C4: D1D33610      MOVE.B     (A3),$3610.W
01C8: 204A          MOVEA.L    A2,A0
01CA: D1D32D48      MOVE.B     (A3),$2D48.W
01CE: FF342003      MOVE.W     3(A4,D2.W),-(A7)
01D2: 48C0          EXT.L      D0
01D4: D1AEFF282013  MOVE.B     -216(A6),19(A0,D2.W)
01DA: 3D720802FF20  MOVE.W     2(A2,D0.L),-224(A6)
01E0: 322EFF20      MOVE.W     -224(A6),D1
01E4: 48C1          EXT.L      D1
01E6: D3AEFF223228  MOVE.B     -222(A6),40(A1,D3.W*2)
01EC: 0004224D      ORI.B      #$224D,D4
01F0: D2C1          MOVE.B     D1,(A1)+
01F2: D2C1          MOVE.B     D1,(A1)+
01F4: 3229A18C      MOVE.W     -24180(A1),D1
01F8: 48C1          EXT.L      D1
01FA: D3AEFF30B66E  MOVE.B     -208(A6),110(A1,A3.W*8)
0200: FF20          MOVE.W     -(A0),-(A7)
0202: 6F04          BLE.S      $0208
0204: 5285          MOVE.B     D5,(A1)
0206: 600E          BRA.S      $0216
0208: B66EFF20      MOVEA.W    -224(A6),A3
020C: 6606          BNE.S      $0214
020E: 52AEFF2C      MOVE.B     -212(A6),(A1)
0212: 6002          BRA.S      $0216
0214: 5286          MOVE.B     D6,(A1)
0216: 5244          MOVEA.B    D4,A1
0218: 508A          MOVE.B     A2,(A0)
021A: 3044          MOVEA.W    D4,A0
021C: B1EEFFFC6D96  MOVE.W     -4(A6),$6D96.W
0222: 2605          MOVE.L     D5,D3
0224: D6AEFF2C      MOVE.B     -212(A6),(A3)
0228: D686          MOVE.B     D6,(A3)
022A: 4A83          TST.L      D3
022C: 670002B6      BEQ.W      $04E6
0230: 48780002      PEA        $0002.W
0234: 2F03          MOVE.L     D3,-(A7)
0236: 4EAD005A      JSR        90(A5)                         ; JT[90]
023A: 2800          MOVE.L     D0,D4
023C: D9AEFF282F03  MOVE.B     -216(A6),3(A4,D2.L*8)
0242: 2F2EFF28      MOVE.L     -216(A6),-(A7)
0246: 4EAD005A      JSR        90(A5)                         ; JT[90]
024A: 2D40FF28      MOVE.L     D0,-216(A6)
024E: D9AEFF222F03  MOVE.B     -222(A6),3(A4,D2.L*8)
0254: 2F2EFF22      MOVE.L     -222(A6),-(A7)
0258: 4EAD005A      JSR        90(A5)                         ; JT[90]
025C: 2D40FF22      MOVE.L     D0,-222(A6)
0260: 2F2EFF2C      MOVE.L     -212(A6),-(A7)
0264: 2F06          MOVE.L     D6,-(A7)
0266: 2F05          MOVE.L     D5,-(A7)
0268: 2F03          MOVE.L     D3,-(A7)
026A: 2204          MOVE.L     D4,D1
026C: D2AEFF30      MOVE.B     -208(A6),(A1)
0270: 2F01          MOVE.L     D1,-(A7)
0272: 4EAD005A      JSR        90(A5)                         ; JT[90]
0276: 2F00          MOVE.L     D0,-(A7)
0278: 206DDE78      MOVEA.L    -8584(A5),A0
027C: 2250          MOVEA.L    (A0),A1
027E: 30290302      MOVE.W     770(A1),D0
0282: C1FC00C0D090  ANDA.L     #$00C0D090,A0
0288: 2240          MOVEA.L    D0,A1
028A: 41EEFF14      LEA        -236(A6),A0
028E: 20D9          MOVE.L     (A1)+,(A0)+
0290: 20D9          MOVE.L     (A1)+,(A0)+
0292: 30D9          MOVE.W     (A1)+,(A0)+
0294: 4868FFF6      PEA        -10(A0)
0298: 3F3C0016      MOVE.W     #$0016,-(A7)
029C: A9EB4868FFF6486E  MOVE.L     18536(A3),#$FFF6486E
02A4: FF1E          MOVE.W     (A6)+,-(A7)
02A6: 3F3C2010      MOVE.W     #$2010,-(A7)
02AA: A9EB3F2EFF1E486D  MOVE.L     16174(A3),#$FF1E486D
02B2: E4F82F0C      MOVE.L     $2F0C.W,(A2)+
02B6: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
02BA: D8C0          MOVE.B     D0,(A4)+
02BC: 2E83          MOVE.L     D3,(A7)
02BE: 206DDE78      MOVEA.L    -8584(A5),A0
02C2: 2250          MOVEA.L    (A0),A1
02C4: 30290302      MOVE.W     770(A1),D0
02C8: C1FC00C02050  ANDA.L     #$00C02050,A0
02CE: 48700810      PEA        16(A0,D0.L)
02D2: 486EFF90      PEA        -112(A6)
02D6: 4EBAFD50      JSR        -688(PC)
02DA: 2E83          MOVE.L     D3,(A7)
02DC: 206DDE78      MOVEA.L    -8584(A5),A0
02E0: 2250          MOVEA.L    (A0),A1
02E2: 30290302      MOVE.W     770(A1),D0
02E6: C1FC00C02050  ANDA.L     #$00C02050,A0
02EC: 48700868      PEA        104(A0,D0.L)
02F0: 486EFF38      PEA        -200(A6)
02F4: 4EBAFD32      JSR        -718(PC)
02F8: 2EAEFF48      MOVE.L     -184(A6),(A7)
02FC: 2F2EFFA0      MOVE.L     -96(A6),-(A7)
0300: 2F2EFF44      MOVE.L     -188(A6),-(A7)
0304: 2F2EFF9C      MOVE.L     -100(A6),-(A7)
0308: 2F2EFF40      MOVE.L     -192(A6),-(A7)
030C: 2F2EFF98      MOVE.L     -104(A6),-(A7)
0310: 2F2EFF3C      MOVE.L     -196(A6),-(A7)
0314: 2F2EFF94      MOVE.L     -108(A6),-(A7)
0318: 202EFF28      MOVE.L     -216(A6),D0
031C: 90AEFF22      MOVE.B     -222(A6),(A0)
0320: 2F00          MOVE.L     D0,-(A7)
0322: 2F2EFF22      MOVE.L     -222(A6),-(A7)
0326: 2F2EFF28      MOVE.L     -216(A6),-(A7)
032A: 486DE556      PEA        -6826(A5)                      ; A5-6826
032E: 2F0C          MOVE.L     A4,-(A7)
0330: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0334: D8C0          MOVE.B     D0,(A4)+
0336: 2EAEFF64      MOVE.L     -156(A6),(A7)
033A: 2F2EFFBC      MOVE.L     -68(A6),-(A7)
033E: 2F2EFF5C      MOVE.L     -164(A6),-(A7)
0342: 2F2EFFB4      MOVE.L     -76(A6),-(A7)
0346: 2F2EFF58      MOVE.L     -168(A6),-(A7)
034A: 2F2EFFB0      MOVE.L     -80(A6),-(A7)
034E: 2F2EFF60      MOVE.L     -160(A6),-(A7)
0352: 2F2EFFB8      MOVE.L     -72(A6),-(A7)
0356: 2F2EFF54      MOVE.L     -172(A6),-(A7)
035A: 2F2EFFAC      MOVE.L     -84(A6),-(A7)
035E: 486DE5EE      PEA        -6674(A5)                      ; A5-6674
0362: 2F0C          MOVE.L     A4,-(A7)
0364: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0368: 4FEF0086      LEA        134(A7),A7
036C: D8C0          MOVE.B     D0,(A4)+
036E: 2F2EFF4C      MOVE.L     -180(A6),-(A7)
0372: 2F2EFFA4      MOVE.L     -92(A6),-(A7)
0376: 2F2EFF50      MOVE.L     -176(A6),-(A7)
037A: 2F2EFFA8      MOVE.L     -88(A6),-(A7)
037E: 486DE69E      PEA        -6498(A5)                      ; A5-6498
0382: 2F0C          MOVE.L     A4,-(A7)
0384: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0388: D8C0          MOVE.B     D0,(A4)+
038A: 2EAEFF68      MOVE.L     -152(A6),(A7)
038E: 2F2EFFC0      MOVE.L     -64(A6),-(A7)
0392: 2F2EFF6C      MOVE.L     -148(A6),-(A7)
0396: 2F2EFFC4      MOVE.L     -60(A6),-(A7)
039A: 486DE6EC      PEA        -6420(A5)                      ; A5-6420
039E: 2F0C          MOVE.L     A4,-(A7)
03A0: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
03A4: D8C0          MOVE.B     D0,(A4)+
03A6: 486EFFC8      PEA        -56(A6)
03AA: 486EFF16      PEA        -234(A6)
03AE: 3F3C280E      MOVE.W     #$280E,-(A7)
03B2: A9EB487A0192486E  MOVE.L     18554(A3),#$0192486E
03BA: FF16          MOVE.W     (A6),-(A7)
03BC: 3F3C2006      MOVE.W     #$2006,-(A7)
03C0: A9EB41EEFFF243EE  MOVE.L     16878(A3),#$FFF243EE
03C8: FF16          MOVE.W     (A6),-(A7)
03CA: 20D9          MOVE.L     (A1)+,(A0)+
03CC: 20D9          MOVE.L     (A1)+,(A0)+
03CE: 30D9          MOVE.W     (A1)+,(A0)+
03D0: 486EFF70      PEA        -144(A6)
03D4: 486EFF16      PEA        -234(A6)
03D8: 3F3C280E      MOVE.W     #$280E,-(A7)
03DC: A9EB487A0166486E  MOVE.L     18554(A3),#$0166486E
03E4: FF16          MOVE.W     (A6),-(A7)
03E6: 3F3C2006      MOVE.W     #$2006,-(A7)
03EA: A9EB41EEFFE843EE  MOVE.L     16878(A3),#$FFE843EE
03F2: FF16          MOVE.W     (A6),-(A7)
03F4: 20D9          MOVE.L     (A1)+,(A0)+
03F6: 20D9          MOVE.L     (A1)+,(A0)+
03F8: 30D9          MOVE.W     (A1)+,(A0)+
03FA: 2EAEFF8C      MOVE.L     -116(A6),(A7)
03FE: 2F2EFFE4      MOVE.L     -28(A6),-(A7)
0402: 2F2EFF88      MOVE.L     -120(A6),-(A7)
0406: 2F2EFFE0      MOVE.L     -32(A6),-(A7)
040A: 2F2EFF84      MOVE.L     -124(A6),-(A7)
040E: 2F2EFFDC      MOVE.L     -36(A6),-(A7)
0412: 2F2EFF80      MOVE.L     -128(A6),-(A7)
0416: 2F2EFFD8      MOVE.L     -40(A6),-(A7)
041A: 2F2EFF7C      MOVE.L     -132(A6),-(A7)
041E: 2F2EFFD4      MOVE.L     -44(A6),-(A7)
0422: 2F2EFF78      MOVE.L     -136(A6),-(A7)
0426: 2F2EFFD0      MOVE.L     -48(A6),-(A7)
042A: 2F2EFF74      MOVE.L     -140(A6),-(A7)
042E: 2F2EFFCC      MOVE.L     -52(A6),-(A7)
0432: 41EEFFF2      LEA        -14(A6),A0
0436: 3F20          MOVE.W     -(A0),-(A7)
0438: 2F20          MOVE.L     -(A0),-(A7)
043A: 2F20          MOVE.L     -(A0),-(A7)
043C: 41EEFFFC      LEA        -4(A6),A0
0440: 3F20          MOVE.W     -(A0),-(A7)
0442: 2F20          MOVE.L     -(A0),-(A7)
0444: 2F20          MOVE.L     -(A0),-(A7)
0446: 486DE742      PEA        -6334(A5)                      ; A5-6334
044A: 2F0C          MOVE.L     A4,-(A7)
044C: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0450: 4FEF007C      LEA        124(A7),A7
0454: D8C0          MOVE.B     D0,(A4)+
0456: 486DE85E      PEA        -6050(A5)                      ; A5-6050
045A: 2F0C          MOVE.L     A4,-(A7)
045C: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0460: D8C0          MOVE.B     D0,(A4)+
0462: 78FF          MOVEQ      #-1,D4
0464: D86EFFFE      MOVEA.B    -2(A6),A4
0468: 2004          MOVE.L     D4,D0
046A: 48C0          EXT.L      D0
046C: E7882440      MOVE.L     A0,64(A3,D2.W*4)
0470: 508F          MOVE.B     A7,(A0)
0472: 606C          BRA.S      $04E0
0474: 2013          MOVE.L     (A3),D0
0476: 206DDE78      MOVEA.L    -8584(A5),A0
047A: 2050          MOVEA.L    (A0),A0
047C: 30320806      MOVE.W     6(A2,D0.L),D0
0480: B0680302      MOVEA.W    770(A0),A0
0484: 6656          BNE.S      $04DC
0486: 204A          MOVEA.L    A2,A0
0488: D1D33A10      MOVE.B     (A3),$3A10.W
048C: 2013          MOVE.L     (A3),D0
048E: 3C320802      MOVE.W     2(A2,D0.L),D6
0492: BC45          MOVEA.W    D5,A6
0494: 6C08          BGE.S      $049E
0496: 41EDE878      LEA        -6024(A5),A0                   ; A5-6024
049A: 2E08          MOVE.L     A0,D7
049C: 6012          BRA.S      $04B0
049E: BC45          MOVEA.W    D5,A6
04A0: 6608          BNE.S      $04AA
04A2: 41EDE87C      LEA        -6020(A5),A0                   ; A5-6020
04A6: 2E08          MOVE.L     A0,D7
04A8: 6006          BRA.S      $04B0
04AA: 41EDE880      LEA        -6016(A5),A0                   ; A5-6016
04AE: 2E08          MOVE.L     A0,D7
04B0: 2F07          MOVE.L     D7,-(A7)
04B2: 2013          MOVE.L     (A3),D0
04B4: 30320804      MOVE.W     4(A2,D0.L),D0
04B8: 204D          MOVEA.L    A5,A0
04BA: D0C0          MOVE.B     D0,(A0)+
04BC: D0C0          MOVE.B     D0,(A0)+
04BE: 3F28A18C      MOVE.W     -24180(A0),-(A7)
04C2: 2013          MOVE.L     (A3),D0
04C4: 3F320802      MOVE.W     2(A2,D0.L),-(A7)
04C8: 3F320800      MOVE.W     0(A2,D0.L),-(A7)
04CC: 486DE882      PEA        -6014(A5)                      ; A5-6014
04D0: 2F0C          MOVE.L     A4,-(A7)
04D2: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
04D6: D8C0          MOVE.B     D0,(A4)+
04D8: 4FEF0012      LEA        18(A7),A7
04DC: 5344518A      MOVE.B     D4,20874(A1)
04E0: 4A44          TST.W      D4
04E2: 6C90          BGE.S      $0474
04E4: 200B          MOVE.L     A3,D0
04E6: 6704          BEQ.S      $04EC
04E8: 4A83          TST.L      D3
04EA: 664C          BNE.S      $0538
04EC: 206DDE78      MOVEA.L    -8584(A5),A0
04F0: 2250          MOVEA.L    (A0),A1
04F2: 30290302      MOVE.W     770(A1),D0
04F6: C1FC00C0D090  ANDA.L     #$00C0D090,A0
04FC: 2240          MOVEA.L    D0,A1
04FE: 41EEFF14      LEA        -236(A6),A0
0502: 20D9          MOVE.L     (A1)+,(A0)+
0504: 20D9          MOVE.L     (A1)+,(A0)+
0506: 30D9          MOVE.W     (A1)+,(A0)+
0508: 4868FFF6      PEA        -10(A0)
050C: 3F3C0016      MOVE.W     #$0016,-(A7)
0510: A9EB4868FFF6486E  MOVE.L     18536(A3),#$FFF6486E
0518: FF1E          MOVE.W     (A6)+,-(A7)
051A: 3F3C2010      MOVE.W     #$2010,-(A7)
051E: A9EB3F2EFF1E486D  MOVE.L     16174(A3),#$FF1E486D
0526: D700          MOVE.B     D0,-(A3)
0528: 486DE894      PEA        -5996(A5)                      ; A5-5996
052C: 2F0C          MOVE.L     A4,-(A7)
052E: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0532: D8C0          MOVE.B     D0,(A4)+
0534: 4FEF000E      LEA        14(A7),A7
0538: 200C          MOVE.L     A4,D0
053A: 90AE0008      MOVE.B     8(A6),(A0)
053E: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0542: 4E5E          UNLK       A6
0544: 4E75          RTS        

0546: 00640064      ORI.W      #$0064,-(A4)

; ======= Function at 0x054A =======
054A: 4E560000      LINK       A6,#0
054E: 2F0C          MOVE.L     A4,-(A7)
0550: 42A7          CLR.L      -(A7)
0552: 2F3C48495354  MOVE.L     #$48495354,-(A7)
0558: 4267          CLR.W      -(A7)
055A: A9A0285F      MOVE.L     -(A0),95(A4,D2.L)
055E: 200C          MOVE.L     A4,D0
0560: 6712          BEQ.S      $0574
0562: 42A7          CLR.L      -(A7)
0564: 2F0C          MOVE.L     A4,-(A7)
0566: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
056A: 201F          MOVE.L     (A7)+,D0
056C: E688          MOVE.L     A0,(A3)
056E: 206E0008      MOVEA.L    8(A6),A0
0572: 2080          MOVE.L     D0,(A0)
0574: 200C          MOVE.L     A4,D0
0576: 285F          MOVEA.L    (A7)+,A4
0578: 4E5E          UNLK       A6
057A: 4E75          RTS        


; ======= Function at 0x057C =======
057C: 4E560000      LINK       A6,#0
0580: 2F2DDE7C      MOVE.L     -8580(A5),-(A7)                ; A5-8580
0584: 4EAD066A      JSR        1642(A5)                       ; JT[1642]
0588: 4A40          TST.W      D0
058A: 588F          MOVE.B     A7,(A4)
058C: 6610          BNE.S      $059E
058E: 2F2DDE7C      MOVE.L     -8580(A5),-(A7)                ; A5-8580
0592: A873206D      MOVEA.L    109(A3,D2.W),A4
0596: DE7C4868      MOVEA.B    #$68,A7
059A: 0010A928      ORI.B      #$A928,(A0)
059E: 4E5E          UNLK       A6
05A0: 4E75          RTS        


; ======= Function at 0x05A2 =======
05A2: 4E560000      LINK       A6,#0
05A6: 2F2E000C      MOVE.L     12(A6),-(A7)
05AA: 3F2E0012      MOVE.W     18(A6),-(A7)
05AE: 2F2DDE7C      MOVE.L     -8580(A5),-(A7)                ; A5-8580
05B2: 4EAD066A      JSR        1642(A5)                       ; JT[1642]
05B6: 4A40          TST.W      D0
05B8: 588F          MOVE.B     A7,(A4)
05BA: 6706          BEQ.S      $05C2
05BC: 202DE92E      MOVE.L     -5842(A5),D0                   ; A5-5842
05C0: 6004          BRA.S      $05C6
05C2: 202DE932      MOVE.L     -5838(A5),D0                   ; A5-5838
05C6: 2F00          MOVE.L     D0,-(A7)
05C8: A9477001      MOVE.L     D7,28673(A4)
05CC: 4E5E          UNLK       A6
05CE: 4E75          RTS        


; ======= Function at 0x05D0 =======
05D0: 4E560000      LINK       A6,#0
05D4: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
05D8: 286E0008      MOVEA.L    8(A6),A4
05DC: 2E2E0010      MOVE.L     16(A6),D7
05E0: 48780064      PEA        $0064.W
05E4: 2F07          MOVE.L     D7,-(A7)
05E6: 4EAD0042      JSR        66(A5)                         ; JT[66]
05EA: 2E00          MOVE.L     D0,D7
05EC: 48780002      PEA        $0002.W
05F0: 2F07          MOVE.L     D7,-(A7)
05F2: 4EAD005A      JSR        90(A5)                         ; JT[90]
05F6: 2C00          MOVE.L     D0,D6
05F8: 206E000C      MOVEA.L    12(A6),A0
05FC: 43D4          LEA        (A4),A1
05FE: 7015          MOVEQ      #21,D0
0600: 22D8          MOVE.L     (A0)+,(A1)+
0602: 51C8FFFC      DBF        D0,$0600                       ; loop
0606: DDAC0004DDAC  MOVE.B     4(A4),-84(A6,A5.L*4)
060C: 0008DDAC      ORI.B      #$DDAC,A0
0610: 000CDDAC      ORI.B      #$DDAC,A4
0614: 0010DDAC      ORI.B      #$DDAC,(A0)
0618: 0014DDAC      ORI.B      #$DDAC,(A4)
061C: 001CDDAC      ORI.B      #$DDAC,(A4)+
0620: 0020DDAC      ORI.B      #$DDAC,-(A0)
0624: 0024DDAC      ORI.B      #$DDAC,-(A4)
0628: 0028DDAC002C  ORI.B      #$DDAC,44(A0)
062E: DDAC00304878  MOVE.B     48(A4),120(A6,D4.L)
0634: 00022F14      ORI.B      #$2F14,D2
0638: 4EAD005A      JSR        90(A5)                         ; JT[90]
063C: D1AC003841EC  MOVE.B     56(A4),-20(A0,D4.W)
0642: 00042F07      ORI.B      #$2F07,D4
0646: 2F10          MOVE.L     (A0),-(A7)
0648: 4EAD005A      JSR        90(A5)                         ; JT[90]
064C: 2080          MOVE.L     D0,(A0)
064E: 43EC0008      LEA        8(A4),A1
0652: 2F07          MOVE.L     D7,-(A7)
0654: 2F11          MOVE.L     (A1),-(A7)
0656: 4EAD005A      JSR        90(A5)                         ; JT[90]
065A: 2280          MOVE.L     D0,(A1)
065C: 41EC000C      LEA        12(A4),A0
0660: 2F07          MOVE.L     D7,-(A7)
0662: 2F10          MOVE.L     (A0),-(A7)
0664: 4EAD005A      JSR        90(A5)                         ; JT[90]
0668: 2080          MOVE.L     D0,(A0)
066A: 41EC0010      LEA        16(A4),A0
066E: 2F07          MOVE.L     D7,-(A7)
0670: 2F10          MOVE.L     (A0),-(A7)
0672: 4EAD005A      JSR        90(A5)                         ; JT[90]
0676: 2080          MOVE.L     D0,(A0)
0678: 41EC0014      LEA        20(A4),A0
067C: 2F07          MOVE.L     D7,-(A7)
067E: 2F10          MOVE.L     (A0),-(A7)
0680: 4EAD005A      JSR        90(A5)                         ; JT[90]
0684: 2080          MOVE.L     D0,(A0)
0686: 41EC001C      LEA        28(A4),A0
068A: 2F07          MOVE.L     D7,-(A7)
068C: 2F10          MOVE.L     (A0),-(A7)
068E: 4EAD005A      JSR        90(A5)                         ; JT[90]
0692: 2080          MOVE.L     D0,(A0)
0694: 41EC0020      LEA        32(A4),A0
0698: 2F07          MOVE.L     D7,-(A7)
069A: 2F10          MOVE.L     (A0),-(A7)
069C: 4EAD005A      JSR        90(A5)                         ; JT[90]
06A0: 2080          MOVE.L     D0,(A0)
06A2: 41EC0024      LEA        36(A4),A0
06A6: 2F07          MOVE.L     D7,-(A7)
06A8: 2F10          MOVE.L     (A0),-(A7)
06AA: 4EAD005A      JSR        90(A5)                         ; JT[90]
06AE: 2080          MOVE.L     D0,(A0)
06B0: 41EC0028      LEA        40(A4),A0
06B4: 2F07          MOVE.L     D7,-(A7)
06B6: 2F10          MOVE.L     (A0),-(A7)
06B8: 4EAD005A      JSR        90(A5)                         ; JT[90]
06BC: 2080          MOVE.L     D0,(A0)
06BE: 41EC002C      LEA        44(A4),A0
06C2: 2F07          MOVE.L     D7,-(A7)
06C4: 2F10          MOVE.L     (A0),-(A7)
06C6: 4EAD005A      JSR        90(A5)                         ; JT[90]
06CA: 2080          MOVE.L     D0,(A0)
06CC: 41EC0030      LEA        48(A4),A0
06D0: 2F07          MOVE.L     D7,-(A7)
06D2: 2F10          MOVE.L     (A0),-(A7)
06D4: 4EAD005A      JSR        90(A5)                         ; JT[90]
06D8: 2080          MOVE.L     D0,(A0)
06DA: 41EC0038      LEA        56(A4),A0
06DE: 2F14          MOVE.L     (A4),-(A7)
06E0: 2F10          MOVE.L     (A0),-(A7)
06E2: 4EAD005A      JSR        90(A5)                         ; JT[90]
06E6: 2080          MOVE.L     D0,(A0)
06E8: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
06EC: 4E5E          UNLK       A6
06EE: 4E75          RTS        


; ======= Function at 0x06F0 =======
06F0: 4E56C000      LINK       A6,#-16384                     ; frame=16384
06F4: 2F07          MOVE.L     D7,-(A7)
06F6: 486EC000      PEA        -16384(A6)
06FA: 4EBAFA4C      JSR        -1460(PC)
06FE: 2E00          MOVE.L     D0,D7
0700: 486EC000      PEA        -16384(A6)
0704: 2F07          MOVE.L     D7,-(A7)
0706: 206DDE7C      MOVEA.L    -8580(A5),A0
070A: 2F2800A0      MOVE.L     160(A0),-(A7)
070E: A9CF2EADDE7C  MOVE.L     A7,#$2EADDE7C
0714: 4EAD0762      JSR        1890(A5)                       ; JT[1890]
0718: 2EADDE7C      MOVE.L     -8580(A5),(A7)                 ; A5-8580
071C: 4EAD0752      JSR        1874(A5)                       ; JT[1874]
0720: 4257          CLR.W      (A7)
0722: 4EBAFE58      JSR        -424(PC)
0726: 2E2EBFFC      MOVE.L     -16388(A6),D7
072A: 4E5E          UNLK       A6
072C: 4E75          RTS        


; ======= Function at 0x072E =======
072E: 4E560000      LINK       A6,#0
0732: 2F2DDE7C      MOVE.L     -8580(A5),-(A7)                ; A5-8580
0736: 4EAD066A      JSR        1642(A5)                       ; JT[1642]
073A: 4A40          TST.W      D0
073C: 588F          MOVE.B     A7,(A4)
073E: 6718          BEQ.S      $0758
0740: 4EBAFFAE      JSR        -82(PC)
0744: 2F2DDE7C      MOVE.L     -8580(A5),-(A7)                ; A5-8580
0748: 4EAD0C3A      JSR        3130(A5)                       ; JT[3130]
074C: 2EADDE7C      MOVE.L     -8580(A5),(A7)                 ; A5-8580
0750: 4EAD0C1A      JSR        3098(A5)                       ; JT[3098]
0754: 588F          MOVE.B     A7,(A4)
0756: 600A          BRA.S      $0762
0758: 2F2DDE7C      MOVE.L     -8580(A5),-(A7)                ; A5-8580
075C: 4EAD0C02      JSR        3074(A5)                       ; JT[3074]
0760: 588F          MOVE.B     A7,(A4)
0762: 4E5E          UNLK       A6
0764: 4E75          RTS        
