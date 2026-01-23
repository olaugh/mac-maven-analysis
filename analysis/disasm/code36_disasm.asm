;======================================================================
; CODE 36 Disassembly
; File: /tmp/maven_code_36.bin
; Header: JT offset=2520, JT entries=5
; Code size: 9102 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0008: 286E0008      MOVEA.L    8(A6),A4
000C: 0CAC000013880010  CMPI.L     #$00001388,16(A4)
0014: 6F0A          BLE.S      $0020
0016: 102DA58D      MOVE.B     -23155(A5),D0                  ; A5-23155
001A: B02DCEC3      MOVE.W     -12605(A5),D0                  ; A5-12605
001E: 6606          BNE.S      $0026
0020: 7A00          MOVEQ      #0,D5
0022: 60000102      BRA.W      $0128
0026: 4AADF8E4      TST.L      -1820(A5)
002A: 670000AA      BEQ.W      $00D8
002E: 7A00          MOVEQ      #0,D5
0030: 264C          MOVEA.L    A4,A3
0032: 102C0021      MOVE.B     33(A4),D0
0036: 4880          EXT.W      D0
0038: 122C0020      MOVE.B     32(A4),D1
003C: 4881          EXT.W      D1
003E: C3FC001145ED  ANDA.L     #$001145ED,A1
0044: BCFE          MOVE.W     ???,(A6)+
0046: D28A          MOVE.B     A2,(A1)
0048: 3440          MOVEA.W    D0,A2
004A: D28A          MOVE.B     A2,(A1)
004C: 2441          MOVEA.L    D1,A2
004E: 607A          BRA.S      $00CA
0050: 4A12          TST.B      (A2)
0052: 6672          BNE.S      $00C6
0054: 204D          MOVEA.L    A5,A0
0056: D0C7          MOVE.B     D7,(A0)+
0058: D0C7          MOVE.B     D7,(A0)+
005A: 0C6803209412  CMPI.W     #$0320,-27630(A0)
0060: 6C64          BGE.S      $00C6
0062: 102DCEC3      MOVE.B     -12605(A5),D0                  ; A5-12605
0066: 4880          EXT.W      D0
0068: 204D          MOVEA.L    A5,A0
006A: D0C0          MOVE.B     D0,(A0)+
006C: D0C0          MOVE.B     D0,(A0)+
006E: 2007          MOVE.L     D7,D0
0070: 48C0          EXT.L      D0
0072: E988224D      MOVE.L     A0,77(A4,D2.W*2)
0076: D2C7          MOVE.B     D7,(A1)+
0078: 1229CE84      MOVE.B     -12668(A1),D1
007C: 4881          EXT.W      D1
007E: 43EDB3F2      LEA        -19470(A5),A1                  ; A5-19470
0082: D089          MOVE.B     A1,(A0)
0084: 3241          MOVEA.W    D1,A1
0086: D3C930310800  MOVE.B     A1,$30310800
008C: 4640          NOT.W      D0
008E: 806C001E      OR.W       30(A4),D0
0092: C068B7E4      AND.W      -18460(A0),D0
0096: 3800          MOVE.W     D0,D4
0098: 7000          MOVEQ      #0,D0
009A: 3004          MOVE.W     D4,D0
009C: D0ADF8E4      MOVE.B     -1820(A5),(A0)                 ; A5-1820
00A0: 2040          MOVEA.L    D0,A0
00A2: 1010          MOVE.B     (A0),D0
00A4: 4880          EXT.W      D0
00A6: B06E000C      MOVEA.W    12(A6),A0
00AA: 671A          BEQ.S      $00C6
00AC: 204D          MOVEA.L    A5,A0
00AE: D0C7          MOVE.B     D7,(A0)+
00B0: 1028CE84      MOVE.B     -12668(A0),D0
00B4: 4880          EXT.W      D0
00B6: DA40          MOVEA.B    D0,A5
00B8: 7000          MOVEQ      #0,D0
00BA: 3004          MOVE.W     D4,D0
00BC: D0ADF8E4      MOVE.B     -1820(A5),(A0)                 ; A5-1820
00C0: 2040          MOVEA.L    D0,A0
00C2: 10AE000D      MOVE.B     13(A6),(A0)
00C6: 528B          MOVE.B     A3,(A1)
00C8: 528A          MOVE.B     A2,(A1)
00CA: 1E13          MOVE.B     (A3),D7
00CC: 4887          EXT.W      D7
00CE: 4A47          TST.W      D7
00D0: 6600FF7E      BNE.W      $0052
00D4: 6050          BRA.S      $0126
00D6: 0C6D0007B1D6  CMPI.W     #$0007,-20010(A5)
00DC: 6746          BEQ.S      $0124
00DE: 302DF7D6      MOVE.W     -2090(A5),D0                   ; A5-2090
00E2: 204D          MOVEA.L    A5,A0
00E4: D0C0          MOVE.B     D0,(A0)+
00E6: 1228CE84      MOVE.B     -12668(A0),D1
00EA: 4881          EXT.W      D1
00EC: 342DF7DA      MOVE.W     -2086(A5),D2                   ; A5-2086
00F0: 204D          MOVEA.L    A5,A0
00F2: D0C2          MOVE.B     D2,(A0)+
00F4: 1028CE84      MOVE.B     -12668(A0),D0
00F8: 4880          EXT.W      D0
00FA: 342DF7D4      MOVE.W     -2092(A5),D2                   ; A5-2092
00FE: 204D          MOVEA.L    A5,A0
0100: D0C2          MOVE.B     D2,(A0)+
0102: 1428CE84      MOVE.B     -12668(A0),D2
0106: 4882          EXT.W      D2
0108: 306DF7D8      MOVEA.W    -2088(A5),A0
010C: 41E8CE84      LEA        -12668(A0),A0
0110: D1CD1610      MOVE.B     A5,$1610.W
0114: 4883          EXT.W      D3
0116: 3A2DB1D6      MOVE.W     -20010(A5),D5                  ; A5-20010
011A: 9A43          MOVEA.B    D3,A5
011C: 9A42          MOVEA.B    D2,A5
011E: 9A40          MOVEA.B    D0,A5
0120: 9A41          MOVEA.B    D1,A5
0122: 6002          BRA.S      $0126
0124: 7A07          MOVEQ      #7,D5
0126: 264C          MOVEA.L    A4,A3
0128: 4280          CLR.L      D0
012A: 4281          CLR.L      D1
012C: 4287          CLR.L      D7
012E: 41EDA54E      LEA        -23218(A5),A0                  ; A5-23218
0132: 43EDCE84      LEA        -12668(A5),A1                  ; A5-12668
0136: 45ED9A58      LEA        -26024(A5),A2                  ; A5-26024
013A: 1028003F      MOVE.B     63(A0),D0
013E: 1229003F      MOVE.B     63(A1),D1
0142: E948D5C0      MOVE.L     A0,-10816(A4)
0146: D241          MOVEA.B    D1,A1
0148: 3C321000      MOVE.W     0(A2,D1.W),D6
014C: 1E1B          MOVE.B     (A3)+,D7
014E: 12317000      MOVE.B     0(A1,D7.W),D1
0152: 671C          BEQ.S      $0170
0154: 42317000      CLR.B      0(A1,D7.W)
0158: 10307000      MOVE.B     0(A0,D7.W),D0
015C: B200          MOVE.W     D0,D1
015E: 6710          BEQ.S      $0170
0160: 4880          EXT.W      D0
0162: E94845ED      MOVE.L     A0,17901(A4)
0166: 9A58          MOVEA.B    (A0)+,A5
0168: D5C0D241      MOVE.B     D0,-11711(PC)
016C: CCF21000      ANDA.W     0(A2,D1.W),A6
0170: 1E1B          MOVE.B     (A3)+,D7
0172: 66DA          BNE.S      $014E
0174: 4A46          TST.W      D6
0176: 6604          BNE.S      $017C
0178: 4EAD01A2      JSR        418(A5)                        ; JT[418]
017C: 3005          MOVE.W     D5,D0
017E: D046          MOVEA.B    D6,A0
0180: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0184: 4E5E          UNLK       A6
0186: 4E75          RTS        


; ======= Function at 0x0188 =======
0188: 4E560000      LINK       A6,#0
018C: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0190: 266E0008      MOVEA.L    8(A6),A3
0194: 0C6D0007B1D6  CMPI.W     #$0007,-20010(A5)
019A: 6E000332      BGT.W      $04D0
019E: 49EB0010      LEA        16(A3),A4
01A2: 2E2DF87C      MOVE.L     -1924(A5),D7                   ; A5-1924
01A6: DE94          MOVE.B     (A4),(A7)
01A8: 70FF          MOVEQ      #-1,D0
01AA: D06DCF04      MOVEA.B    -12540(A5),A0
01AE: C1FC0042206D  ANDA.L     #$0042206D,A0
01B4: CF24          AND.B      D7,-(A4)
01B6: BEB00804      MOVE.W     4(A0,D0.L),(A7)
01BA: 6F000312      BLE.W      $04D0
01BE: 3C2DF7D2      MOVE.W     -2094(A5),D6                   ; A5-2094
01C2: 9C6DB1D6      MOVEA.B    -20010(A5),A6
01C6: 3A06          MOVE.W     D6,D5
01C8: 57450C45      MOVE.B     D5,3141(A3)
01CC: 00076F04      ORI.B      #$6F04,D7
01D0: 7A07          MOVEQ      #7,D5
01D2: 6006          BRA.S      $01DA
01D4: 4A45          TST.W      D5
01D6: 6E02          BGT.S      $01DA
01D8: 7A01          MOVEQ      #1,D5
01DA: 4EBA115A      JSR        4442(PC)
01DE: 2800          MOVE.L     D0,D4
01E0: 302DB1D6      MOVE.W     -20010(A5),D0                  ; A5-20010
01E4: C1EDF8E2      ANDA.L     -1822(A5),A0
01E8: 3046          MOVEA.W    D6,A0
01EA: 2F08          MOVE.L     A0,-(A7)
01EC: 3045          MOVEA.W    D5,A0
01EE: 2F08          MOVE.L     A0,-(A7)
01F0: 2F04          MOVE.L     D4,-(A7)
01F2: 2200          MOVE.L     D0,D1
01F4: 4EAD0042      JSR        66(A5)                         ; JT[66]
01F8: C141          AND.W      D0,D1
01FA: 2F01          MOVE.L     D1,-(A7)
01FC: 2200          MOVE.L     D0,D1
01FE: 4EAD005A      JSR        90(A5)                         ; JT[90]
0202: C141          AND.W      D0,D1
0204: D294          MOVE.B     (A4),(A1)
0206: 3040          MOVEA.W    D0,A0
0208: D288          MOVE.B     A0,(A1)
020A: 2E01          MOVE.L     D1,D7
020C: 70FF          MOVEQ      #-1,D0
020E: D06DCF04      MOVEA.B    -12540(A5),A0
0212: C1FC0042206D  ANDA.L     #$0042206D,A0
0218: CF24          AND.B      D7,-(A4)
021A: BEB00804      MOVE.W     4(A0,D0.L),(A7)
021E: 6F0002AE      BLE.W      $04D0
0222: 0C6D005ACF04  CMPI.W     #$005A,-12540(A5)
0228: 6704          BEQ.S      $022E
022A: 4EAD01A2      JSR        418(A5)                        ; JT[418]
022E: 4AADF8E4      TST.L      -1820(A5)
0232: 670000E6      BEQ.W      $031C
0236: 7000          MOVEQ      #0,D0
0238: 302B001E      MOVE.W     30(A3),D0
023C: D0ADF8E4      MOVE.B     -1820(A5),(A0)                 ; A5-1820
0240: 2040          MOVEA.L    D0,A0
0242: 1C10          MOVE.B     (A0),D6
0244: 4886          EXT.W      D6
0246: 0C46FFFF      CMPI.W     #$FFFF,D6
024A: 670000CE      BEQ.W      $031C
024E: BC6DCF04      MOVEA.W    -12540(A5),A6
0252: 6C04          BGE.S      $0258
0254: 4A46          TST.W      D6
0256: 6C04          BGE.S      $025C
0258: 4EAD01A2      JSR        418(A5)                        ; JT[418]
025C: 286DCF24      MOVEA.L    -12508(A5),A4
0260: 7042          MOVEQ      #66,D0
0262: C1EDCF04      ANDA.L     -12540(A5),A0
0266: D0ADCF24      MOVE.B     -12508(A5),(A0)                ; A5-12508
026A: B08C          MOVE.W     A4,(A0)
026C: 6204          BHI.S      $0272
026E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0272: 45EC0028      LEA        40(A4),A2
0276: 3046          MOVEA.W    D6,A0
0278: B1D26600      MOVE.W     (A2),$6600.W
027C: 0096102C0030  ORI.L      #$102C0030,(A6)
0282: B02B0020      MOVE.W     32(A3),D0
0286: 66000092      BNE.W      $031C
028A: 102C0031      MOVE.B     49(A4),D0
028E: B02B0021      MOVE.W     33(A3),D0
0292: 66000086      BNE.W      $031C
0296: 102C003C      MOVE.B     60(A4),D0
029A: 4880          EXT.W      D0
029C: B06DB1D6      MOVEA.W    -20010(A5),A0
02A0: 6678          BNE.S      $031A
02A2: 302DF7D8      MOVE.W     -2088(A5),D0                   ; A5-2088
02A6: 204D          MOVEA.L    A5,A0
02A8: D0C0          MOVE.B     D0,(A0)+
02AA: 122C003D      MOVE.B     61(A4),D1
02AE: B228CE84      MOVE.W     -12668(A0),D1
02B2: 6666          BNE.S      $031A
02B4: 302DF7D4      MOVE.W     -2092(A5),D0                   ; A5-2092
02B8: 204D          MOVEA.L    A5,A0
02BA: D0C0          MOVE.B     D0,(A0)+
02BC: 122C003E      MOVE.B     62(A4),D1
02C0: B228CE84      MOVE.W     -12668(A0),D1
02C4: 6654          BNE.S      $031A
02C6: 302DF7DA      MOVE.W     -2086(A5),D0                   ; A5-2086
02CA: 204D          MOVEA.L    A5,A0
02CC: D0C0          MOVE.B     D0,(A0)+
02CE: 122C003F      MOVE.B     63(A4),D1
02D2: B228CE84      MOVE.W     -12668(A0),D1
02D6: 6642          BNE.S      $031A
02D8: 302DF7D6      MOVE.W     -2090(A5),D0                   ; A5-2090
02DC: 204D          MOVEA.L    A5,A0
02DE: D0C0          MOVE.B     D0,(A0)+
02E0: 122C0040      MOVE.B     64(A4),D1
02E4: B228CE84      MOVE.W     -12668(A0),D1
02E8: 6630          BNE.S      $031A
02EA: BEAC0004      MOVE.W     4(A4),(A7)
02EE: 6F0001DE      BLE.W      $04D0
02F2: 29470004      MOVE.L     D7,4(A4)
02F6: 41EC0010      LEA        16(A4),A0
02FA: 43D3          LEA        (A3),A1
02FC: 7007          MOVEQ      #7,D0
02FE: 20D9          MOVE.L     (A1)+,(A0)+
0300: 51C8FFFC      DBF        D0,$02FE                       ; loop
0304: 30D9          MOVE.W     (A1)+,(A0)+
0306: 3944003A      MOVE.W     D4,58(A4)
030A: 3046          MOVEA.W    D6,A0
030C: 2488          MOVE.L     A0,(A2)
030E: 600001BE      BRA.W      $04D0
0312: 49EC0042      LEA        66(A4),A4
0316: 6000FF48      BRA.W      $0262
031A: 7600          MOVEQ      #0,D3
031C: 0C6D0007B1D6  CMPI.W     #$0007,-20010(A5)
0322: 663A          BNE.S      $035E
0324: 286DF8C4      MOVEA.L    -1852(A5),A4
0328: 6026          BRA.S      $0350
032A: 204D          MOVEA.L    A5,A0
032C: D0C5          MOVE.B     D5,(A0)+
032E: D0C5          MOVE.B     D5,(A0)+
0330: 224D          MOVEA.L    A5,A1
0332: D2C5          MOVE.B     D5,(A1)+
0334: 1029CE84      MOVE.B     -12668(A1),D0
0338: 4880          EXT.W      D0
033A: 224D          MOVEA.L    A5,A1
033C: D2C5          MOVE.B     D5,(A1)+
033E: 1229A54E      MOVE.B     -23218(A1),D1
0342: 4881          EXT.W      D1
0344: 9240          MOVEA.B    D0,A1
0346: C3E89412      ANDA.L     -27630(A0),A1
034A: 3041          MOVEA.W    D1,A0
034C: D688          MOVE.B     A0,(A3)
034E: 528C          MOVE.B     A4,(A1)
0350: 1A14          MOVE.B     (A4),D5
0352: 4885          EXT.W      D5
0354: 4A45          TST.W      D5
0356: 66D2          BNE.S      $032A
0358: D683          MOVE.B     D3,(A3)
035A: D6AB0010      MOVE.B     16(A3),(A3)
035E: 302DF7D6      MOVE.W     -2090(A5),D0                   ; A5-2090
0362: 204D          MOVEA.L    A5,A0
0364: D0C0          MOVE.B     D0,(A0)+
0366: 1228CE84      MOVE.B     -12668(A0),D1
036A: 4881          EXT.W      D1
036C: 3F01          MOVE.W     D1,-(A7)
036E: 322DF7DA      MOVE.W     -2086(A5),D1                   ; A5-2086
0372: 204D          MOVEA.L    A5,A0
0374: D0C1          MOVE.B     D1,(A0)+
0376: 1428CE84      MOVE.B     -12668(A0),D2
037A: 4882          EXT.W      D2
037C: 3F02          MOVE.W     D2,-(A7)
037E: 342DF7D4      MOVE.W     -2092(A5),D2                   ; A5-2092
0382: 204D          MOVEA.L    A5,A0
0384: D0C2          MOVE.B     D2,(A0)+
0386: 1028CE84      MOVE.B     -12668(A0),D0
038A: 4880          EXT.W      D0
038C: 3F00          MOVE.W     D0,-(A7)
038E: 302DF7D8      MOVE.W     -2088(A5),D0                   ; A5-2088
0392: 204D          MOVEA.L    A5,A0
0394: D0C0          MOVE.B     D0,(A0)+
0396: 1028CE84      MOVE.B     -12668(A0),D0
039A: 4880          EXT.W      D0
039C: 3F00          MOVE.W     D0,-(A7)
039E: 2F0B          MOVE.L     A3,-(A7)
03A0: 2F07          MOVE.L     D7,-(A7)
03A2: 2F2DCF24      MOVE.L     -12508(A5),-(A7)               ; A5-12508
03A6: 4EBA0FCA      JSR        4042(PC)
03AA: 2840          MOVEA.L    D0,A4
03AC: 200C          MOVE.L     A4,D0
03AE: 4FEF0014      LEA        20(A7),A7
03B2: 6746          BEQ.S      $03FA
03B4: 306C000E      MOVEA.W    14(A4),A0
03B8: B1C36C04      MOVE.W     D3,$6C04.W
03BC: 3943000E      MOVE.W     D3,14(A4)
03C0: 3C2C002A      MOVE.W     42(A4),D6
03C4: BEAC0004      MOVE.W     4(A4),(A7)
03C8: 6614          BNE.S      $03DE
03CA: 41EC0010      LEA        16(A4),A0
03CE: 43D3          LEA        (A3),A1
03D0: 7007          MOVEQ      #7,D0
03D2: 20D9          MOVE.L     (A1)+,(A0)+
03D4: 51C8FFFC      DBF        D0,$03D2                       ; loop
03D8: 30D9          MOVE.W     (A1)+,(A0)+
03DA: 3944003A      MOVE.W     D4,58(A4)
03DE: 3F06          MOVE.W     D6,-(A7)
03E0: 2F0B          MOVE.L     A3,-(A7)
03E2: 4EBAFC1C      JSR        -996(PC)
03E6: D16C0038302B  MOVE.B     56(A4),12331(A0)
03EC: 001E4640      ORI.B      #$4640,(A6)+
03F0: C16C0036      AND.W      D0,54(A4)
03F4: 5C8F          MOVE.B     A7,(A6)
03F6: 600000BA      BRA.W      $04B4
03FA: 286DCF24      MOVEA.L    -12508(A5),A4
03FE: 6004          BRA.S      $0404
0400: 49EC0042      LEA        66(A4),A4
0404: BEAC0004      MOVE.W     4(A4),(A7)
0408: 6FF6          BLE.S      $0400
040A: 206DCF24      MOVEA.L    -12508(A5),A0
040E: 3C28171C      MOVE.W     5916(A0),D6
0412: 48780042      PEA        $0042.W
0416: 48780042      PEA        $0042.W
041A: 200C          MOVE.L     A4,D0
041C: 9088          MOVE.B     A0,(A0)
041E: 2F00          MOVE.L     D0,-(A7)
0420: 4EAD005A      JSR        90(A5)                         ; JT[90]
0424: 326DCF04      MOVEA.W    -12540(A5),A1
0428: 538993C0      MOVE.B     A1,-64(A1,A1.W*2)
042C: 2F09          MOVE.L     A1,-(A7)
042E: 4EAD0042      JSR        66(A5)                         ; JT[66]
0432: 2F00          MOVE.L     D0,-(A7)
0434: 2F0C          MOVE.L     A4,-(A7)
0436: 486C0042      PEA        66(A4)
043A: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
043E: 3944003A      MOVE.W     D4,58(A4)
0442: 29470004      MOVE.L     D7,4(A4)
0446: 41EC0010      LEA        16(A4),A0
044A: 43D3          LEA        (A3),A1
044C: 7007          MOVEQ      #7,D0
044E: 20D9          MOVE.L     (A1)+,(A0)+
0450: 51C8FFFC      DBF        D0,$044E                       ; loop
0454: 30D9          MOVE.W     (A1)+,(A0)+
0456: 196DB1D7003C  MOVE.B     -20009(A5),60(A4)              ; A5-20009
045C: 3943000E      MOVE.W     D3,14(A4)
0460: 302DF7D8      MOVE.W     -2088(A5),D0                   ; A5-2088
0464: 204D          MOVEA.L    A5,A0
0466: D0C0          MOVE.B     D0,(A0)+
0468: 1968CE84003D  MOVE.B     -12668(A0),61(A4)
046E: 302DF7D4      MOVE.W     -2092(A5),D0                   ; A5-2092
0472: 204D          MOVEA.L    A5,A0
0474: D0C0          MOVE.B     D0,(A0)+
0476: 1968CE84003E  MOVE.B     -12668(A0),62(A4)
047C: 302DF7DA      MOVE.W     -2086(A5),D0                   ; A5-2086
0480: 204D          MOVEA.L    A5,A0
0482: D0C0          MOVE.B     D0,(A0)+
0484: 1968CE84003F  MOVE.B     -12668(A0),63(A4)
048A: 302DF7D6      MOVE.W     -2090(A5),D0                   ; A5-2090
048E: 204D          MOVEA.L    A5,A0
0490: D0C0          MOVE.B     D0,(A0)+
0492: 1968CE840040  MOVE.B     -12668(A0),64(A4)
0498: 302B001E      MOVE.W     30(A3),D0
049C: 4640          NOT.W      D0
049E: 39400036      MOVE.W     D0,54(A4)
04A2: 3E86          MOVE.W     D6,(A7)
04A4: 2F0B          MOVE.L     A3,-(A7)
04A6: 4EBAFB58      JSR        -1192(PC)
04AA: 39400038      MOVE.W     D0,56(A4)
04AE: 4FEF0010      LEA        16(A7),A7
04B2: 4AADF8E4      TST.L      -1820(A5)
04B6: 6716          BEQ.S      $04CE
04B8: 3046          MOVEA.W    D6,A0
04BA: 29480028      MOVE.L     A0,40(A4)
04BE: 2008          MOVE.L     A0,D0
04C0: 7200          MOVEQ      #0,D1
04C2: 322B001E      MOVE.W     30(A3),D1
04C6: D2ADF8E4      MOVE.B     -1820(A5),(A1)                 ; A5-1820
04CA: 2041          MOVEA.L    D1,A0
04CC: 1080          MOVE.B     D0,(A0)
04CE: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
04D2: 4E5E          UNLK       A6
04D4: 4E75          RTS        


; ======= Function at 0x04D6 =======
04D6: 4E560000      LINK       A6,#0
04DA: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
04DE: 266E0008      MOVEA.L    8(A6),A3
04E2: 0C6D0007B1D6  CMPI.W     #$0007,-20010(A5)
04E8: 6E0001E8      BGT.W      $06D4
04EC: 49EB0010      LEA        16(A3),A4
04F0: 2E2DF87C      MOVE.L     -1924(A5),D7                   ; A5-1924
04F4: DE94          MOVE.B     (A4),(A7)
04F6: 70FF          MOVEQ      #-1,D0
04F8: D06DCF04      MOVEA.B    -12540(A5),A0
04FC: C1FC0042206D  ANDA.L     #$0042206D,A0
0502: CF24          AND.B      D7,-(A4)
0504: BEB00804      MOVE.W     4(A0,D0.L),(A7)
0508: 6F0001C8      BLE.W      $06D4
050C: 3C2DF7D2      MOVE.W     -2094(A5),D6                   ; A5-2094
0510: 9C6DB1D6      MOVEA.B    -20010(A5),A6
0514: 3A06          MOVE.W     D6,D5
0516: 57450C45      MOVE.B     D5,3141(A3)
051A: 00076F04      ORI.B      #$6F04,D7
051E: 7A07          MOVEQ      #7,D5
0520: 6006          BRA.S      $0528
0522: 4A45          TST.W      D5
0524: 6E02          BGT.S      $0528
0526: 7A01          MOVEQ      #1,D5
0528: 4EBA0E0C      JSR        3596(PC)
052C: 2800          MOVE.L     D0,D4
052E: 302DB1D6      MOVE.W     -20010(A5),D0                  ; A5-20010
0532: C1EDF8E2      ANDA.L     -1822(A5),A0
0536: 3046          MOVEA.W    D6,A0
0538: 2F08          MOVE.L     A0,-(A7)
053A: 3045          MOVEA.W    D5,A0
053C: 2F08          MOVE.L     A0,-(A7)
053E: 2F04          MOVE.L     D4,-(A7)
0540: 2200          MOVE.L     D0,D1
0542: 4EAD0042      JSR        66(A5)                         ; JT[66]
0546: C141          AND.W      D0,D1
0548: 2F01          MOVE.L     D1,-(A7)
054A: 2200          MOVE.L     D0,D1
054C: 4EAD005A      JSR        90(A5)                         ; JT[90]
0550: C141          AND.W      D0,D1
0552: D294          MOVE.B     (A4),(A1)
0554: 3040          MOVEA.W    D0,A0
0556: D288          MOVE.B     A0,(A1)
0558: 2E01          MOVE.L     D1,D7
055A: 70FF          MOVEQ      #-1,D0
055C: D06DCF04      MOVEA.B    -12540(A5),A0
0560: C1FC0042206D  ANDA.L     #$0042206D,A0
0566: CF24          AND.B      D7,-(A4)
0568: BEB00804      MOVE.W     4(A0,D0.L),(A7)
056C: 6F000164      BLE.W      $06D4
0570: 4AADF8E4      TST.L      -1820(A5)
0574: 670000B0      BEQ.W      $0628
0578: 7000          MOVEQ      #0,D0
057A: 302B001E      MOVE.W     30(A3),D0
057E: D0ADF8E4      MOVE.B     -1820(A5),(A0)                 ; A5-1820
0582: 2040          MOVEA.L    D0,A0
0584: 1C10          MOVE.B     (A0),D6
0586: 4886          EXT.W      D6
0588: 0C46FFFF      CMPI.W     #$FFFF,D6
058C: 67000098      BEQ.W      $0628
0590: 302DF7D8      MOVE.W     -2088(A5),D0                   ; A5-2088
0594: 204D          MOVEA.L    A5,A0
0596: D0C0          MOVE.B     D0,(A0)+
0598: 122A003D      MOVE.B     61(A2),D1
059C: B228CE84      MOVE.W     -12668(A0),D1
05A0: 66000084      BNE.W      $0628
05A4: 302DF7D4      MOVE.W     -2092(A5),D0                   ; A5-2092
05A8: 204D          MOVEA.L    A5,A0
05AA: D0C0          MOVE.B     D0,(A0)+
05AC: 122A003E      MOVE.B     62(A2),D1
05B0: B228CE84      MOVE.W     -12668(A0),D1
05B4: 6670          BNE.S      $0626
05B6: 302DF7DA      MOVE.W     -2086(A5),D0                   ; A5-2086
05BA: 204D          MOVEA.L    A5,A0
05BC: D0C0          MOVE.B     D0,(A0)+
05BE: 122A003F      MOVE.B     63(A2),D1
05C2: B228CE84      MOVE.W     -12668(A0),D1
05C6: 665E          BNE.S      $0626
05C8: 302DF7D6      MOVE.W     -2090(A5),D0                   ; A5-2090
05CC: 204D          MOVEA.L    A5,A0
05CE: D0C0          MOVE.B     D0,(A0)+
05D0: 122A0040      MOVE.B     64(A2),D1
05D4: B228CE84      MOVE.W     -12668(A0),D1
05D8: 664C          BNE.S      $0626
05DA: BC6DCF04      MOVEA.W    -12540(A5),A6
05DE: 6C04          BGE.S      $05E4
05E0: 4A46          TST.W      D6
05E2: 6C04          BGE.S      $05E8
05E4: 4EAD01A2      JSR        418(A5)                        ; JT[418]
05E8: 7042          MOVEQ      #66,D0
05EA: C1C6          ANDA.L     D6,A0
05EC: D0ADCF24      MOVE.B     -12508(A5),(A0)                ; A5-12508
05F0: 2440          MOVEA.L    D0,A2
05F2: 102A0030      MOVE.B     48(A2),D0
05F6: B02B0020      MOVE.W     32(A3),D0
05FA: 662A          BNE.S      $0626
05FC: 102A0031      MOVE.B     49(A2),D0
0600: B02B0021      MOVE.W     33(A3),D0
0604: 6620          BNE.S      $0626
0606: 102A003C      MOVE.B     60(A2),D0
060A: 4880          EXT.W      D0
060C: B06DB1D6      MOVEA.W    -20010(A5),A0
0610: 6704          BEQ.S      $0616
0612: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0616: BEAA0004      MOVE.W     4(A2),(A7)
061A: 6F0000B6      BLE.W      $06D4
061E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0622: 600000AE      BRA.W      $06D4
0626: 302DF7D6      MOVE.W     -2090(A5),D0                   ; A5-2090
062A: 204D          MOVEA.L    A5,A0
062C: D0C0          MOVE.B     D0,(A0)+
062E: 1228CE84      MOVE.B     -12668(A0),D1
0632: 4881          EXT.W      D1
0634: 3F01          MOVE.W     D1,-(A7)
0636: 322DF7DA      MOVE.W     -2086(A5),D1                   ; A5-2086
063A: 204D          MOVEA.L    A5,A0
063C: D0C1          MOVE.B     D1,(A0)+
063E: 1428CE84      MOVE.B     -12668(A0),D2
0642: 4882          EXT.W      D2
0644: 3F02          MOVE.W     D2,-(A7)
0646: 342DF7D4      MOVE.W     -2092(A5),D2                   ; A5-2092
064A: 204D          MOVEA.L    A5,A0
064C: D0C2          MOVE.B     D2,(A0)+
064E: 1028CE84      MOVE.B     -12668(A0),D0
0652: 4880          EXT.W      D0
0654: 3F00          MOVE.W     D0,-(A7)
0656: 302DF7D8      MOVE.W     -2088(A5),D0                   ; A5-2088
065A: 204D          MOVEA.L    A5,A0
065C: D0C0          MOVE.B     D0,(A0)+
065E: 1028CE84      MOVE.B     -12668(A0),D0
0662: 4880          EXT.W      D0
0664: 3F00          MOVE.W     D0,-(A7)
0666: 2F0B          MOVE.L     A3,-(A7)
0668: 2F07          MOVE.L     D7,-(A7)
066A: 2F2DCF24      MOVE.L     -12508(A5),-(A7)               ; A5-12508
066E: 4EBA0D02      JSR        3330(PC)
0672: 2440          MOVEA.L    D0,A2
0674: 200A          MOVE.L     A2,D0
0676: 4FEF0014      LEA        20(A7),A7
067A: 6756          BEQ.S      $06D2
067C: 48780042      PEA        $0042.W
0680: 200A          MOVE.L     A2,D0
0682: 90ADCF24      MOVE.B     -12508(A5),(A0)                ; A5-12508
0686: 2F00          MOVE.L     D0,-(A7)
0688: 4EAD005A      JSR        90(A5)                         ; JT[90]
068C: 3F00          MOVE.W     D0,-(A7)
068E: 2F0B          MOVE.L     A3,-(A7)
0690: 4EBAF96E      JSR        -1682(PC)
0694: D16A0038302B  MOVE.B     56(A2),12331(A0)
069A: 001E4640      ORI.B      #$4640,(A6)+
069E: C16A0036      AND.W      D0,54(A2)
06A2: BEAA0004      MOVE.W     4(A2),(A7)
06A6: 5C8F          MOVE.B     A7,(A6)
06A8: 6F04          BLE.S      $06AE
06AA: 4EAD01A2      JSR        418(A5)                        ; JT[418]
06AE: 4AADF8E4      TST.L      -1820(A5)
06B2: 671E          BEQ.S      $06D2
06B4: 48780042      PEA        $0042.W
06B8: 200A          MOVE.L     A2,D0
06BA: 90ADCF24      MOVE.B     -12508(A5),(A0)                ; A5-12508
06BE: 2F00          MOVE.L     D0,-(A7)
06C0: 4EAD005A      JSR        90(A5)                         ; JT[90]
06C4: 7200          MOVEQ      #0,D1
06C6: 322B001E      MOVE.W     30(A3),D1
06CA: D2ADF8E4      MOVE.B     -1820(A5),(A1)                 ; A5-1820
06CE: 2041          MOVEA.L    D1,A0
06D0: 1080          MOVE.B     D0,(A0)
06D2: 4CDF1CF0      MOVEM.L    (SP)+,D4/D5/D6/D7/A2/A3/A4     ; restore
06D6: 4E5E          UNLK       A6
06D8: 4E75          RTS        


; ======= Function at 0x06DA =======
06DA: 4E560000      LINK       A6,#0
06DE: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
06E2: 266E0008      MOVEA.L    8(A6),A3
06E6: 0C6D0007B1D6  CMPI.W     #$0007,-20010(A5)
06EC: 6E000224      BGT.W      $0914
06F0: 49EB0010      LEA        16(A3),A4
06F4: 2E2DF87C      MOVE.L     -1924(A5),D7                   ; A5-1924
06F8: DE94          MOVE.B     (A4),(A7)
06FA: 0C6D005ACF04  CMPI.W     #$005A,-12540(A5)
0700: 6608          BNE.S      $070A
0702: BEADF880      MOVE.W     -1920(A5),(A7)                 ; A5-1920
0706: 6F00020A      BLE.W      $0914
070A: 3C2DF7D2      MOVE.W     -2094(A5),D6                   ; A5-2094
070E: 9C6DB1D6      MOVEA.B    -20010(A5),A6
0712: 3A06          MOVE.W     D6,D5
0714: 57450C45      MOVE.B     D5,3141(A3)
0718: 00076F04      ORI.B      #$6F04,D7
071C: 7A07          MOVEQ      #7,D5
071E: 6006          BRA.S      $0726
0720: 4A45          TST.W      D5
0722: 6E02          BGT.S      $0726
0724: 7A01          MOVEQ      #1,D5
0726: 4EBA0C0E      JSR        3086(PC)
072A: 2800          MOVE.L     D0,D4
072C: 302DB1D6      MOVE.W     -20010(A5),D0                  ; A5-20010
0730: C1EDF8E2      ANDA.L     -1822(A5),A0
0734: 3046          MOVEA.W    D6,A0
0736: 2F08          MOVE.L     A0,-(A7)
0738: 3045          MOVEA.W    D5,A0
073A: 2F08          MOVE.L     A0,-(A7)
073C: 2F04          MOVE.L     D4,-(A7)
073E: 2200          MOVE.L     D0,D1
0740: 4EAD0042      JSR        66(A5)                         ; JT[66]
0744: C141          AND.W      D0,D1
0746: 2F01          MOVE.L     D1,-(A7)
0748: 2200          MOVE.L     D0,D1
074A: 4EAD005A      JSR        90(A5)                         ; JT[90]
074E: C141          AND.W      D0,D1
0750: D294          MOVE.B     (A4),(A1)
0752: 3040          MOVEA.W    D0,A0
0754: D288          MOVE.B     A0,(A1)
0756: 2E01          MOVE.L     D1,D7
0758: 4A6DCF04      TST.W      -12540(A5)
075C: 660A          BNE.S      $0768
075E: 0CADF4143E00F880  CMPI.L     #$F4143E00,-1920(A5)
0766: 671C          BEQ.S      $0784
0768: 70FF          MOVEQ      #-1,D0
076A: D06DCF04      MOVEA.B    -12540(A5),A0
076E: C1FC0042206D  ANDA.L     #$0042206D,A0
0774: CF24          AND.B      D7,-(A4)
0776: 20300804      MOVE.L     4(A0,D0.L),D0
077A: B0ADF880      MOVE.W     -1920(A5),(A0)                 ; A5-1920
077E: 6704          BEQ.S      $0784
0780: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0784: 0C6D005ACF04  CMPI.W     #$005A,-12540(A5)
078A: 6608          BNE.S      $0794
078C: BEADF880      MOVE.W     -1920(A5),(A7)                 ; A5-1920
0790: 6F000180      BLE.W      $0914
0794: 7C00          MOVEQ      #0,D6
0796: 0C6D0007B1D6  CMPI.W     #$0007,-20010(A5)
079C: 6638          BNE.S      $07D6
079E: 246DF8C4      MOVEA.L    -1852(A5),A2
07A2: 6026          BRA.S      $07CA
07A4: 204D          MOVEA.L    A5,A0
07A6: D0C5          MOVE.B     D5,(A0)+
07A8: D0C5          MOVE.B     D5,(A0)+
07AA: 224D          MOVEA.L    A5,A1
07AC: D2C5          MOVE.B     D5,(A1)+
07AE: 1029CE84      MOVE.B     -12668(A1),D0
07B2: 4880          EXT.W      D0
07B4: 224D          MOVEA.L    A5,A1
07B6: D2C5          MOVE.B     D5,(A1)+
07B8: 1229A54E      MOVE.B     -23218(A1),D1
07BC: 4881          EXT.W      D1
07BE: 9240          MOVEA.B    D0,A1
07C0: C3E89412      ANDA.L     -27630(A0),A1
07C4: 3041          MOVEA.W    D1,A0
07C6: DC88          MOVE.B     A0,(A6)
07C8: 528A          MOVE.B     A2,(A1)
07CA: 1A12          MOVE.B     (A2),D5
07CC: 4885          EXT.W      D5
07CE: 4A45          TST.W      D5
07D0: 66D2          BNE.S      $07A4
07D2: DC86          MOVE.B     D6,(A6)
07D4: DC94          MOVE.B     (A4),(A6)
07D6: 302DF7D6      MOVE.W     -2090(A5),D0                   ; A5-2090
07DA: 204D          MOVEA.L    A5,A0
07DC: D0C0          MOVE.B     D0,(A0)+
07DE: 1228CE84      MOVE.B     -12668(A0),D1
07E2: 4881          EXT.W      D1
07E4: 3F01          MOVE.W     D1,-(A7)
07E6: 322DF7DA      MOVE.W     -2086(A5),D1                   ; A5-2086
07EA: 204D          MOVEA.L    A5,A0
07EC: D0C1          MOVE.B     D1,(A0)+
07EE: 1428CE84      MOVE.B     -12668(A0),D2
07F2: 4882          EXT.W      D2
07F4: 3F02          MOVE.W     D2,-(A7)
07F6: 342DF7D4      MOVE.W     -2092(A5),D2                   ; A5-2092
07FA: 204D          MOVEA.L    A5,A0
07FC: D0C2          MOVE.B     D2,(A0)+
07FE: 1028CE84      MOVE.B     -12668(A0),D0
0802: 4880          EXT.W      D0
0804: 3F00          MOVE.W     D0,-(A7)
0806: 302DF7D8      MOVE.W     -2088(A5),D0                   ; A5-2088
080A: 204D          MOVEA.L    A5,A0
080C: D0C0          MOVE.B     D0,(A0)+
080E: 1028CE84      MOVE.B     -12668(A0),D0
0812: 4880          EXT.W      D0
0814: 3F00          MOVE.W     D0,-(A7)
0816: 2F0B          MOVE.L     A3,-(A7)
0818: 2F07          MOVE.L     D7,-(A7)
081A: 2F2DCF24      MOVE.L     -12508(A5),-(A7)               ; A5-12508
081E: 4EBA0B52      JSR        2898(PC)
0822: 2840          MOVEA.L    D0,A4
0824: 200C          MOVE.L     A4,D0
0826: 4FEF0014      LEA        20(A7),A7
082A: 6672          BNE.S      $089E
082C: 0C6D005ACF04  CMPI.W     #$005A,-12540(A5)
0832: 6612          BNE.S      $0846
0834: 286DCF24      MOVEA.L    -12508(A5),A4
0838: 6004          BRA.S      $083E
083A: 49EC0042      LEA        66(A4),A4
083E: BEAC0004      MOVE.W     4(A4),(A7)
0842: 6FF6          BLE.S      $083A
0844: 6024          BRA.S      $086A
0846: 286DCF24      MOVEA.L    -12508(A5),A4
084A: 7042          MOVEQ      #66,D0
084C: C1EDCF04      ANDA.L     -12540(A5),A0
0850: D0ADCF24      MOVE.B     -12508(A5),(A0)                ; A5-12508
0854: 2440          MOVEA.L    D0,A2
0856: 6004          BRA.S      $085C
0858: 49EC0042      LEA        66(A4),A4
085C: B5CC6306      MOVE.W     A4,25350(PC)
0860: BEAC0004      MOVE.W     4(A4),(A7)
0864: 6FF2          BLE.S      $0858
0866: 526DCF04      MOVEA.B    -12540(A5),A1
086A: 48780042      PEA        $0042.W
086E: 48780042      PEA        $0042.W
0872: 200C          MOVE.L     A4,D0
0874: 90ADCF24      MOVE.B     -12508(A5),(A0)                ; A5-12508
0878: 2F00          MOVE.L     D0,-(A7)
087A: 4EAD005A      JSR        90(A5)                         ; JT[90]
087E: 306DCF04      MOVEA.W    -12540(A5),A0
0882: 538891C0      MOVE.B     A0,-64(A1,A1.W)
0886: 2F08          MOVE.L     A0,-(A7)
0888: 4EAD0042      JSR        66(A5)                         ; JT[66]
088C: 2F00          MOVE.L     D0,-(A7)
088E: 2F0C          MOVE.L     A4,-(A7)
0890: 486C0042      PEA        66(A4)
0894: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0898: 4FEF000C      LEA        12(A7),A7
089C: 6006          BRA.S      $08A4
089E: BEAC0004      MOVE.W     4(A4),(A7)
08A2: 6D6E          BLT.S      $0912
08A4: 3944003A      MOVE.W     D4,58(A4)
08A8: 3946000E      MOVE.W     D6,14(A4)
08AC: 29470004      MOVE.L     D7,4(A4)
08B0: 41EC0010      LEA        16(A4),A0
08B4: 43D3          LEA        (A3),A1
08B6: 7007          MOVEQ      #7,D0
08B8: 20D9          MOVE.L     (A1)+,(A0)+
08BA: 51C8FFFC      DBF        D0,$08B8                       ; loop
08BE: 30D9          MOVE.W     (A1)+,(A0)+
08C0: 196DB1D7003C  MOVE.B     -20009(A5),60(A4)              ; A5-20009
08C6: 302DF7D8      MOVE.W     -2088(A5),D0                   ; A5-2088
08CA: 204D          MOVEA.L    A5,A0
08CC: D0C0          MOVE.B     D0,(A0)+
08CE: 1968CE84003D  MOVE.B     -12668(A0),61(A4)
08D4: 302DF7D4      MOVE.W     -2092(A5),D0                   ; A5-2092
08D8: 204D          MOVEA.L    A5,A0
08DA: D0C0          MOVE.B     D0,(A0)+
08DC: 1968CE84003E  MOVE.B     -12668(A0),62(A4)
08E2: 302DF7DA      MOVE.W     -2086(A5),D0                   ; A5-2086
08E6: 204D          MOVEA.L    A5,A0
08E8: D0C0          MOVE.B     D0,(A0)+
08EA: 1968CE84003F  MOVE.B     -12668(A0),63(A4)
08F0: 302DF7D6      MOVE.W     -2090(A5),D0                   ; A5-2090
08F4: 204D          MOVEA.L    A5,A0
08F6: D0C0          MOVE.B     D0,(A0)+
08F8: 1968CE840040  MOVE.B     -12668(A0),64(A4)
08FE: 70FF          MOVEQ      #-1,D0
0900: D06DCF04      MOVEA.B    -12540(A5),A0
0904: C1FC0042206D  ANDA.L     #$0042206D,A0
090A: CF24          AND.B      D7,-(A4)
090C: 2B700804F880  MOVE.L     4(A0,D0.L),-1920(A5)
0912: 4CDF1CF0      MOVEM.L    (SP)+,D4/D5/D6/D7/A2/A3/A4     ; restore
0916: 4E5E          UNLK       A6
0918: 4E75          RTS        


; ======= Function at 0x091A =======
091A: 4E56FFE8      LINK       A6,#-24                        ; frame=24
091E: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0922: 286E0008      MOVEA.L    8(A6),A4
0926: 266E000C      MOVEA.L    12(A6),A3
092A: 42AC0014      CLR.L      20(A4)
092E: 4A2C0020      TST.B      32(A4)
0932: 66000310      BNE.W      $0C46
0936: 204D          MOVEA.L    A5,A0
0938: 302C001E      MOVE.W     30(A4),D0
093C: D0C0          MOVE.B     D0,(A0)+
093E: D0C0          MOVE.B     D0,(A0)+
0940: 3D68BBF4FFF6  MOVE.W     -17420(A0),-10(A6)
0946: 3C2EFFF6      MOVE.W     -10(A6),D6
094A: 48C6          EXT.L      D6
094C: 2D6B0020FFF2  MOVE.L     32(A3),-14(A6)
0952: 9CAEFFF2      MOVE.B     -14(A6),(A6)
0956: 9CAB0024      MOVE.B     36(A3),(A6)
095A: 182B003C      MOVE.B     60(A3),D4
095E: 4884          EXT.W      D4
0960: B86DF8CC      MOVEA.W    -1844(A5),A4
0964: 6F06          BLE.S      $096C
0966: 302DF8CC      MOVE.W     -1844(A5),D0                   ; A5-1844
096A: 6002          BRA.S      $096E
096C: 3004          MOVE.W     D4,D0
096E: 3A00          MOVE.W     D0,D5
0970: 9B6DF8CC102B  MOVE.B     -1844(A5),4139(A5)             ; A5-1844
0976: 003C48809045  ORI.B      #$4880,#$45
097C: 3D40FFFA      MOVE.W     D0,-6(A6)
0980: 916DF8CA7800  MOVE.B     -1846(A5),30720(A0)            ; A5-1846
0986: 244C          MOVEA.L    A4,A2
0988: 1612          MOVE.B     (A2),D3
098A: 4A03          TST.B      D3
098C: 6730          BEQ.S      $09BE
098E: 0C030071      CMPI.B     #$0071,D3
0992: 6726          BEQ.S      $09BA
0994: B62A0001      MOVE.W     1(A2),D3
0998: 6720          BEQ.S      $09BA
099A: 1003          MOVE.B     D3,D0
099C: 4880          EXT.W      D0
099E: 204D          MOVEA.L    A5,A0
09A0: D0C0          MOVE.B     D0,(A0)+
09A2: 1028CE84      MOVE.B     -12668(A0),D0
09A6: 4880          EXT.W      D0
09A8: 1203          MOVE.B     D3,D1
09AA: 4881          EXT.W      D1
09AC: 204D          MOVEA.L    A5,A0
09AE: D0C1          MOVE.B     D1,(A0)+
09B0: D0C1          MOVE.B     D1,(A0)+
09B2: C1E8F778      ANDA.L     -2184(A0),A0
09B6: 3040          MOVEA.W    D0,A0
09B8: D888          MOVE.B     A0,(A4)
09BA: 528A          MOVE.B     A2,(A1)
09BC: 60CA          BRA.S      $0988
09BE: 362B003A      MOVE.W     58(A3),D3
09C2: 48C3          EXT.L      D3
09C4: 4A2B003E      TST.B      62(A3)
09C8: 660C          BNE.S      $09D6
09CA: 4A6DF8CE      TST.W      -1842(A5)
09CE: 6706          BEQ.S      $09D6
09D0: 306DF85A      MOVEA.W    -1958(A5),A0
09D4: 9688          MOVE.B     A0,(A3)
09D6: 102B003C      MOVE.B     60(A3),D0
09DA: 4880          EXT.W      D0
09DC: 322DF7D2      MOVE.W     -2094(A5),D1                   ; A5-2094
09E0: 9240          MOVEA.B    D0,A1
09E2: 3D41FFEE      MOVE.W     D1,-18(A6)
09E6: 48C1          EXT.L      D1
09E8: 2E01          MOVE.L     D1,D7
09EA: 2F07          MOVE.L     D7,-(A7)
09EC: 306DF8CA      MOVEA.W    -1846(A5),A0
09F0: 2F08          MOVE.L     A0,-(A7)
09F2: 2F03          MOVE.L     D3,-(A7)
09F4: 4EAD0042      JSR        66(A5)                         ; JT[66]
09F8: 2F00          MOVE.L     D0,-(A7)
09FA: 4EAD005A      JSR        90(A5)                         ; JT[90]
09FE: 306DF7D2      MOVEA.W    -2094(A5),A0
0A02: 4868FFF9      PEA        -7(A0)
0A06: 3045          MOVEA.W    D5,A0
0A08: 2F08          MOVE.L     A0,-(A7)
0A0A: 2F07          MOVE.L     D7,-(A7)
0A0C: 306DB1D6      MOVEA.W    -20010(A5),A0
0A10: 2F08          MOVE.L     A0,-(A7)
0A12: 2F03          MOVE.L     D3,-(A7)
0A14: 2200          MOVE.L     D0,D1
0A16: 4EAD0042      JSR        66(A5)                         ; JT[66]
0A1A: C141          AND.W      D0,D1
0A1C: 2F01          MOVE.L     D1,-(A7)
0A1E: 2200          MOVE.L     D0,D1
0A20: 4EAD005A      JSR        90(A5)                         ; JT[90]
0A24: C141          AND.W      D0,D1
0A26: 2404          MOVE.L     D4,D2
0A28: 9481          MOVE.B     D1,(A2)
0A2A: 2F02          MOVE.L     D2,-(A7)
0A2C: 2200          MOVE.L     D0,D1
0A2E: 4EAD0042      JSR        66(A5)                         ; JT[66]
0A32: C141          AND.W      D0,D1
0A34: 2F01          MOVE.L     D1,-(A7)
0A36: 2200          MOVE.L     D0,D1
0A38: 4EAD005A      JSR        90(A5)                         ; JT[90]
0A3C: C141          AND.W      D0,D1
0A3E: D081          MOVE.B     D1,(A0)
0A40: 9C80          MOVE.B     D0,(A6)
0A42: 4A2DCEF5      TST.B      -12555(A5)
0A46: 6752          BEQ.S      $0A9A
0A48: 4A6DF8CC      TST.W      -1844(A5)
0A4C: 6726          BEQ.S      $0A74
0A4E: 302EFFEE      MOVE.W     -18(A6),D0
0A52: 9045          MOVEA.B    D5,A0
0A54: 322DF8CC      MOVE.W     -1844(A5),D1                   ; A5-1844
0A58: 204D          MOVEA.L    A5,A0
0A5A: D0C1          MOVE.B     D1,(A0)+
0A5C: D0C1          MOVE.B     D1,(A0)+
0A5E: C1E89EEC      ANDA.L     -24852(A0),A0
0A62: 204D          MOVEA.L    A5,A0
0A64: D0C1          MOVE.B     D1,(A0)+
0A66: D0C1          MOVE.B     D1,(A0)+
0A68: 38289F14      MOVE.W     -24812(A0),D4
0A6C: C9C5          ANDA.L     D5,A4
0A6E: D840          MOVEA.B    D0,A4
0A70: 48C4          EXT.L      D4
0A72: 6014          BRA.S      $0A88
0A74: 302EFFEE      MOVE.W     -18(A6),D0
0A78: 9045          MOVEA.B    D5,A0
0A7A: C1ED9CEA      ANDA.L     -25366(A5),A0
0A7E: 382D9DEA      MOVE.W     -25110(A5),D4                  ; A5-25110
0A82: C9C5          ANDA.L     D5,A4
0A84: D840          MOVEA.B    D0,A4
0A86: 48C4          EXT.L      D4
0A88: 306EFFEE      MOVEA.W    -18(A6),A0
0A8C: 2F08          MOVE.L     A0,-(A7)
0A8E: 2F04          MOVE.L     D4,-(A7)
0A90: 4EAD005A      JSR        90(A5)                         ; JT[90]
0A94: DC80          MOVE.B     D0,(A6)
0A96: 6000019C      BRA.W      $0C36
0A9A: 4A6DF8CE      TST.W      -1842(A5)
0A9E: 67000168      BEQ.W      $0C0A
0AA2: 4A2B003E      TST.B      62(A3)
0AA6: 66000160      BNE.W      $0C0A
0AAA: 0C6D000DF7D2  CMPI.W     #$000D,-2094(A5)
0AB0: 6F000104      BLE.W      $0BB8
0AB4: 3C2EFFF6      MOVE.W     -10(A6),D6
0AB8: 48C6          EXT.L      D6
0ABA: 202B0020      MOVE.L     32(A3),D0
0ABE: 4480          NEG.L      D0
0AC0: 2D40FFF6      MOVE.L     D0,-10(A6)
0AC4: 322DF8CC      MOVE.W     -1844(A5),D1                   ; A5-1844
0AC8: 204D          MOVEA.L    A5,A0
0ACA: D0C1          MOVE.B     D1,(A0)+
0ACC: D0C1          MOVE.B     D1,(A0)+
0ACE: 30689F00      MOVEA.W    -24832(A0),A0
0AD2: D088          MOVE.B     A0,(A0)
0AD4: 2800          MOVE.L     D0,D4
0AD6: 102DA5C3      MOVE.B     -23101(A5),D0                  ; A5-23101
0ADA: B02DCEF9      MOVE.W     -12551(A5),D0                  ; A5-12551
0ADE: 6706          BEQ.S      $0AE6
0AE0: 306DF86E      MOVEA.W    -1938(A5),A0
0AE4: D888          MOVE.B     A0,(A4)
0AE6: 48780007      PEA        $0007.W
0AEA: 2F03          MOVE.L     D3,-(A7)
0AEC: 4EAD0042      JSR        66(A5)                         ; JT[66]
0AF0: 2D40FFEE      MOVE.L     D0,-18(A6)
0AF4: 322DF7D2      MOVE.W     -2094(A5),D1                   ; A5-2094
0AF8: D26DB1D6      MOVEA.B    -20010(A5),A1
0AFC: 53413D41      MOVE.B     D1,15681(A1)
0B00: FFEC3041      MOVE.W     12353(A4),???
0B04: 2F08          MOVE.L     A0,-(A7)
0B06: 2F00          MOVE.L     D0,-(A7)
0B08: 4EAD005A      JSR        90(A5)                         ; JT[90]
0B0C: 2D40FFEE      MOVE.L     D0,-18(A6)
0B10: 9880          MOVE.B     D0,(A4)
0B12: 306DB1D6      MOVEA.W    -20010(A5),A0
0B16: 2F08          MOVE.L     A0,-(A7)
0B18: 2F04          MOVE.L     D4,-(A7)
0B1A: 4EAD0042      JSR        66(A5)                         ; JT[66]
0B1E: 2800          MOVE.L     D0,D4
0B20: 302DF85A      MOVE.W     -1958(A5),D0                   ; A5-1958
0B24: 48C0          EXT.L      D0
0B26: 81EDF7D2      ORA.L      -2094(A5),A0
0B2A: 3040          MOVEA.W    D0,A0
0B2C: 2E2EFFEE      MOVE.L     -18(A6),D7
0B30: 9E88          MOVE.B     A0,(A7)
0B32: 2D6EFFF2FFE8  MOVE.L     -14(A6),-24(A6)
0B38: 3041          MOVEA.W    D1,A0
0B3A: 2F08          MOVE.L     A0,-(A7)
0B3C: 48780006      PEA        $0006.W
0B40: 2F03          MOVE.L     D3,-(A7)
0B42: 4EAD0042      JSR        66(A5)                         ; JT[66]
0B46: 2F00          MOVE.L     D0,-(A7)
0B48: 4EAD005A      JSR        90(A5)                         ; JT[90]
0B4C: D1AEFFE8302D  MOVE.B     -24(A6),45(A0,D3.W)
0B52: F8CC          MOVE.W     A4,(A4)+
0B54: 204D          MOVEA.L    A5,A0
0B56: D0C0          MOVE.B     D0,(A0)+
0B58: D0C0          MOVE.B     D0,(A0)+
0B5A: 3D689F14FFF2  MOVE.W     -24812(A0),-14(A6)
0B60: 342EFFF2      MOVE.W     -14(A6),D2
0B64: 48C2          EXT.L      D2
0B66: 95AEFFE8BEAE  MOVE.B     -24(A6),-82(A2,A3.L*8)
0B6C: FFE86C06      MOVE.W     27654(A0),???
0B70: 202EFFE8      MOVE.L     -24(A6),D0
0B74: 6002          BRA.S      $0B78
0B76: 2007          MOVE.L     D7,D0
0B78: 7207          MOVEQ      #7,D1
0B7A: 9245          MOVEA.B    D5,A1
0B7C: 3041          MOVEA.W    D1,A0
0B7E: 2F08          MOVE.L     A0,-(A7)
0B80: 2F00          MOVE.L     D0,-(A7)
0B82: 4EAD0042      JSR        66(A5)                         ; JT[66]
0B86: 9880          MOVE.B     D0,(A4)
0B88: 3045          MOVEA.W    D5,A0
0B8A: 2F08          MOVE.L     A0,-(A7)
0B8C: 202EFFF6      MOVE.L     -10(A6),D0
0B90: 90AEFFEE      MOVE.B     -18(A6),(A0)
0B94: 306EFFF2      MOVEA.W    -14(A6),A0
0B98: 48700800      PEA        0(A0,D0.L)
0B9C: 4EAD0042      JSR        66(A5)                         ; JT[66]
0BA0: D880          MOVE.B     D0,(A4)
0BA2: 306DB1D6      MOVEA.W    -20010(A5),A0
0BA6: 48680007      PEA        7(A0)
0BAA: 2F04          MOVE.L     D4,-(A7)
0BAC: 4EAD005A      JSR        90(A5)                         ; JT[90]
0BB0: DC80          MOVE.B     D0,(A6)
0BB2: 60000080      BRA.W      $0C36
0BB6: 302DF8CC      MOVE.W     -1844(A5),D0                   ; A5-1844
0BBA: 204D          MOVEA.L    A5,A0
0BBC: D0C0          MOVE.B     D0,(A0)+
0BBE: D0C0          MOVE.B     D0,(A0)+
0BC0: 38289F00      MOVE.W     -24832(A0),D4
0BC4: 48C4          EXT.L      D4
0BC6: 122DA5C3      MOVE.B     -23101(A5),D1                  ; A5-23101
0BCA: B22DCEF9      MOVE.W     -12551(A5),D1                  ; A5-12551
0BCE: 6706          BEQ.S      $0BD6
0BD0: 306DF86E      MOVEA.W    -1938(A5),A0
0BD4: D888          MOVE.B     A0,(A4)
0BD6: 306DB1D6      MOVEA.W    -20010(A5),A0
0BDA: 2F08          MOVE.L     A0,-(A7)
0BDC: 2F04          MOVE.L     D4,-(A7)
0BDE: 4EAD0042      JSR        66(A5)                         ; JT[66]
0BE2: 2800          MOVE.L     D0,D4
0BE4: 302DF8CC      MOVE.W     -1844(A5),D0                   ; A5-1844
0BE8: 204D          MOVEA.L    A5,A0
0BEA: D0C0          MOVE.B     D0,(A0)+
0BEC: D0C0          MOVE.B     D0,(A0)+
0BEE: 7207          MOVEQ      #7,D1
0BF0: C3E89F14      ANDA.L     -24812(A0),A1
0BF4: D881          MOVE.B     D1,(A4)
0BF6: 306DB1D6      MOVEA.W    -20010(A5),A0
0BFA: 48680007      PEA        7(A0)
0BFE: 2F04          MOVE.L     D4,-(A7)
0C00: 4EAD005A      JSR        90(A5)                         ; JT[90]
0C04: DC80          MOVE.B     D0,(A6)
0C06: 602C          BRA.S      $0C34
0C08: 102DA5BF      MOVE.B     -23105(A5),D0                  ; A5-23105
0C0C: B02DCEF5      MOVE.W     -12555(A5),D0                  ; A5-12555
0C10: 6712          BEQ.S      $0C24
0C12: 302DF8CC      MOVE.W     -1844(A5),D0                   ; A5-1844
0C16: 204D          MOVEA.L    A5,A0
0C18: D0C0          MOVE.B     D0,(A0)+
0C1A: D0C0          MOVE.B     D0,(A0)+
0C1C: 30689F00      MOVEA.W    -24832(A0),A0
0C20: DC88          MOVE.B     A0,(A6)
0C22: 6010          BRA.S      $0C34
0C24: 302DF8CC      MOVE.W     -1844(A5),D0                   ; A5-1844
0C28: 204D          MOVEA.L    A5,A0
0C2A: D0C0          MOVE.B     D0,(A0)+
0C2C: D0C0          MOVE.B     D0,(A0)+
0C2E: 30689EEC      MOVEA.W    -24852(A0),A0
0C32: DC88          MOVE.B     A0,(A6)
0C34: 302EFFFA      MOVE.W     -6(A6),D0
0C38: D16DF8CADB6D  MOVE.B     -1846(A5),-9363(A0)            ; A5-1846
0C3E: F8CC          MOVE.W     A4,(A4)+
0C40: 600004EA      BRA.W      $112E
0C44: 0C2B0007003C  CMPI.B     #$0007,60(A3)
0C4A: 6634          BNE.S      $0C80
0C4C: 70F9          MOVEQ      #-7,D0
0C4E: D06DF7D2      MOVEA.B    -2094(A5),A0
0C52: B06DB1D6      MOVEA.W    -20010(A5),A0
0C56: 6E28          BGT.S      $0C80
0C58: 346C001E      MOVEA.W    30(A4),A2
0C5C: D5CA41ED      MOVE.B     A2,16877(PC)
0C60: BBF4D1CA      MOVE.W     -54(A4,A5.W),???
0C64: 3C10          MOVE.W     (A0),D6
0C66: EE46          MOVEA.L    D6,A7
0C68: 48C6          EXT.L      D6
0C6A: 41EDCBFA      LEA        -13318(A5),A0                  ; A5-13318
0C6E: D1CA3010      MOVE.B     A2,$3010.W
0C72: D040          MOVEA.B    D0,A0
0C74: 306B000E      MOVEA.W    14(A3),A0
0C78: D0C0          MOVE.B     D0,(A0)+
0C7A: 9C88          MOVE.B     A0,(A6)
0C7C: 600004AE      BRA.W      $112E
0C80: 204D          MOVEA.L    A5,A0
0C82: 302C001E      MOVE.W     30(A4),D0
0C86: D0C0          MOVE.B     D0,(A0)+
0C88: D0C0          MOVE.B     D0,(A0)+
0C8A: 3C28BBF4      MOVE.W     -17420(A0),D6
0C8E: 48C6          EXT.L      D6
0C90: 282B0024      MOVE.L     36(A3),D4
0C94: 4A84          TST.L      D4
0C96: 6708          BEQ.S      $0CA0
0C98: 4A6DA43E      TST.W      -23490(A5)
0C9C: 6602          BNE.S      $0CA0
0C9E: 9C84          MOVE.B     D4,(A6)
0CA0: 9CAB0020      MOVE.B     32(A3),(A6)
0CA4: 302DB1D6      MOVE.W     -20010(A5),D0                  ; A5-20010
0CA8: B06DF8CC      MOVEA.W    -1844(A5),A0
0CAC: 6F06          BLE.S      $0CB4
0CAE: 302DF8CC      MOVE.W     -1844(A5),D0                   ; A5-1844
0CB2: 6004          BRA.S      $0CB8
0CB4: 302DB1D6      MOVE.W     -20010(A5),D0                  ; A5-20010
0CB8: 3600          MOVE.W     D0,D3
0CBA: 976DF8CC302D  MOVE.B     -1844(A5),12333(A3)            ; A5-1844
0CC0: B1D69043      MOVE.W     (A6),$9043.W
0CC4: 916DF8C84A6D  MOVE.B     -1848(A5),19053(A0)            ; A5-1848
0CCA: F8CC          MOVE.W     A4,(A4)+
0CCC: 6620          BNE.S      $0CEE
0CCE: 102DA58D      MOVE.B     -23155(A5),D0                  ; A5-23155
0CD2: B02DCEC3      MOVE.W     -12605(A5),D0                  ; A5-12605
0CD6: 6710          BEQ.S      $0CE8
0CD8: 0C6D0007F8C8  CMPI.W     #$0007,-1848(A5)
0CDE: 6608          BNE.S      $0CE8
0CE0: 0686FFFFFB50  ADDI.L     #$FFFFFB50,D6
0CE6: 6006          BRA.S      $0CEE
0CE8: 0686FFFFFED4  ADDI.L     #$FFFFFED4,D6
0CEE: 182B003C      MOVE.B     60(A3),D4
0CF2: 4884          EXT.W      D4
0CF4: B86DF8CC      MOVEA.W    -1844(A5),A4
0CF8: 6F06          BLE.S      $0D00
0CFA: 302DF8CC      MOVE.W     -1844(A5),D0                   ; A5-1844
0CFE: 6002          BRA.S      $0D02
0D00: 3004          MOVE.W     D4,D0
0D02: 3A00          MOVE.W     D0,D5
0D04: 9B6DF8CC102B  MOVE.B     -1844(A5),4139(A5)             ; A5-1844
0D0A: 003C48809045  ORI.B      #$4880,#$45
0D10: 916DF8CA382B  MOVE.B     -1846(A5),14379(A0)            ; A5-1846
0D16: 003A48C4102B  ORI.B      #$48C4,4139(PC)
0D1C: 003C48803E2D  ORI.B      #$4880,#$2D
0D22: F7D29E40      MOVE.W     (A2),64(PC,A1.L)
0D26: 48C7          EXT.L      D7
0D28: 4A2B003E      TST.B      62(A3)
0D2C: 660E          BNE.S      $0D3C
0D2E: 4A6DF8CE      TST.W      -1842(A5)
0D32: 6708          BEQ.S      $0D3C
0D34: 306DF85A      MOVEA.W    -1958(A5),A0
0D38: 9888          MOVE.B     A0,(A4)
0D3A: 53872F07      MOVE.B     D7,7(A1,D2.L*8)
0D3E: 306DF8CA      MOVEA.W    -1846(A5),A0
0D42: 2F08          MOVE.L     A0,-(A7)
0D44: 2F04          MOVE.L     D4,-(A7)
0D46: 4EAD0042      JSR        66(A5)                         ; JT[66]
0D4A: 2F00          MOVE.L     D0,-(A7)
0D4C: 4EAD005A      JSR        90(A5)                         ; JT[90]
0D50: 9C80          MOVE.B     D0,(A6)
0D52: 4A6DF8CC      TST.W      -1844(A5)
0D56: 670001BE      BEQ.W      $0F18
0D5A: 0C6D000AF8CC  CMPI.W     #$000A,-1844(A5)
0D60: 6504          BCS.S      $0D66
0D62: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0D66: 4A6DF8CE      TST.W      -1842(A5)
0D6A: 67000178      BEQ.W      $0EE6
0D6E: 4A2B003E      TST.B      62(A3)
0D72: 66000170      BNE.W      $0EE6
0D76: 70F3          MOVEQ      #-13,D0
0D78: D06DF7D2      MOVEA.B    -2094(A5),A0
0D7C: B06DB1D6      MOVEA.W    -20010(A5),A0
0D80: 6F000112      BLE.W      $0E96
0D84: 204D          MOVEA.L    A5,A0
0D86: 302C001E      MOVE.W     30(A4),D0
0D8A: D0C0          MOVE.B     D0,(A0)+
0D8C: D0C0          MOVE.B     D0,(A0)+
0D8E: 3C28BBF4      MOVE.W     -17420(A0),D6
0D92: 48C6          EXT.L      D6
0D94: 202B0020      MOVE.L     32(A3),D0
0D98: 4480          NEG.L      D0
0D9A: 2D40FFF6      MOVE.L     D0,-10(A6)
0D9E: 2D6B0020FFF2  MOVE.L     32(A3),-14(A6)
0DA4: 322DF8CC      MOVE.W     -1844(A5),D1                   ; A5-1844
0DA8: 204D          MOVEA.L    A5,A0
0DAA: D0C1          MOVE.B     D1,(A0)+
0DAC: D0C1          MOVE.B     D1,(A0)+
0DAE: 30689F00      MOVEA.W    -24832(A0),A0
0DB2: D088          MOVE.B     A0,(A0)
0DB4: 2800          MOVE.L     D0,D4
0DB6: 102DA5C3      MOVE.B     -23101(A5),D0                  ; A5-23101
0DBA: B02DCEF9      MOVE.W     -12551(A5),D0                  ; A5-12551
0DBE: 6706          BEQ.S      $0DC6
0DC0: 306DF86E      MOVEA.W    -1938(A5),A0
0DC4: D888          MOVE.B     A0,(A4)
0DC6: 302B003A      MOVE.W     58(A3),D0
0DCA: 906DF85A      MOVEA.B    -1958(A5),A0
0DCE: 3D40FFFA      MOVE.W     D0,-6(A6)
0DD2: C1FC00073040  ANDA.L     #$00073040,A0
0DD8: 2D48FFEE      MOVE.L     A0,-18(A6)
0DDC: 70FF          MOVEQ      #-1,D0
0DDE: D06DF7D2      MOVEA.B    -2094(A5),A0
0DE2: 3D40FFEC      MOVE.W     D0,-20(A6)
0DE6: 3240          MOVEA.W    D0,A1
0DE8: 2F09          MOVE.L     A1,-(A7)
0DEA: 2F08          MOVE.L     A0,-(A7)
0DEC: 4EAD005A      JSR        90(A5)                         ; JT[90]
0DF0: 2D40FFEE      MOVE.L     D0,-18(A6)
0DF4: 9880          MOVE.B     D0,(A4)
0DF6: 3043          MOVEA.W    D3,A0
0DF8: 2F08          MOVE.L     A0,-(A7)
0DFA: 2F04          MOVE.L     D4,-(A7)
0DFC: 4EAD0042      JSR        66(A5)                         ; JT[66]
0E00: 2800          MOVE.L     D0,D4
0E02: 302DF8CC      MOVE.W     -1844(A5),D0                   ; A5-1844
0E06: D045          MOVEA.B    D5,A0
0E08: 322DF85A      MOVE.W     -1958(A5),D1                   ; A5-1958
0E0C: 48C1          EXT.L      D1
0E0E: 83C0          ORA.L      D0,A1
0E10: 3041          MOVEA.W    D1,A0
0E12: 2E2EFFEE      MOVE.L     -18(A6),D7
0E16: 9E88          MOVE.B     A0,(A7)
0E18: 2D6EFFF2FFE8  MOVE.L     -14(A6),-24(A6)
0E1E: 7006          MOVEQ      #6,D0
0E20: C1EEFFFA      ANDA.L     -6(A6),A0
0E24: 48C0          EXT.L      D0
0E26: 81EEFFEC      ORA.L      -20(A6),A0
0E2A: 48C0          EXT.L      D0
0E2C: D1AEFFE8302D  MOVE.B     -24(A6),45(A0,D3.W)
0E32: F8CC          MOVE.W     A4,(A4)+
0E34: 204D          MOVEA.L    A5,A0
0E36: D0C0          MOVE.B     D0,(A0)+
0E38: D0C0          MOVE.B     D0,(A0)+
0E3A: 3D689F14FFF2  MOVE.W     -24812(A0),-14(A6)
0E40: 322EFFF2      MOVE.W     -14(A6),D1
0E44: 48C1          EXT.L      D1
0E46: 93AEFFE8BEAE  MOVE.B     -24(A6),-82(A1,A3.L*8)
0E4C: FFE86C06      MOVE.W     27654(A0),???
0E50: 202EFFE8      MOVE.L     -24(A6),D0
0E54: 6002          BRA.S      $0E58
0E56: 2007          MOVE.L     D7,D0
0E58: 7207          MOVEQ      #7,D1
0E5A: 9245          MOVEA.B    D5,A1
0E5C: 3041          MOVEA.W    D1,A0
0E5E: 2F08          MOVE.L     A0,-(A7)
0E60: 2F00          MOVE.L     D0,-(A7)
0E62: 4EAD0042      JSR        66(A5)                         ; JT[66]
0E66: 9880          MOVE.B     D0,(A4)
0E68: 3045          MOVEA.W    D5,A0
0E6A: 2F08          MOVE.L     A0,-(A7)
0E6C: 202EFFF6      MOVE.L     -10(A6),D0
0E70: 90AEFFEE      MOVE.B     -18(A6),(A0)
0E74: 306EFFF2      MOVEA.W    -14(A6),A0
0E78: 48700800      PEA        0(A0,D0.L)
0E7C: 4EAD0042      JSR        66(A5)                         ; JT[66]
0E80: D880          MOVE.B     D0,(A4)
0E82: 3043          MOVEA.W    D3,A0
0E84: 48680007      PEA        7(A0)
0E88: 2F04          MOVE.L     D4,-(A7)
0E8A: 4EAD005A      JSR        90(A5)                         ; JT[90]
0E8E: DC80          MOVE.B     D0,(A6)
0E90: 6000027C      BRA.W      $1110
0E94: 302DF8CC      MOVE.W     -1844(A5),D0                   ; A5-1844
0E98: 204D          MOVEA.L    A5,A0
0E9A: D0C0          MOVE.B     D0,(A0)+
0E9C: D0C0          MOVE.B     D0,(A0)+
0E9E: 38289F00      MOVE.W     -24832(A0),D4
0EA2: 48C4          EXT.L      D4
0EA4: 122DA5C3      MOVE.B     -23101(A5),D1                  ; A5-23101
0EA8: B22DCEF9      MOVE.W     -12551(A5),D1                  ; A5-12551
0EAC: 6706          BEQ.S      $0EB4
0EAE: 306DF86E      MOVEA.W    -1938(A5),A0
0EB2: D888          MOVE.B     A0,(A4)
0EB4: 3043          MOVEA.W    D3,A0
0EB6: 2F08          MOVE.L     A0,-(A7)
0EB8: 2F04          MOVE.L     D4,-(A7)
0EBA: 4EAD0042      JSR        66(A5)                         ; JT[66]
0EBE: 2800          MOVE.L     D0,D4
0EC0: 302DF8CC      MOVE.W     -1844(A5),D0                   ; A5-1844
0EC4: 204D          MOVEA.L    A5,A0
0EC6: D0C0          MOVE.B     D0,(A0)+
0EC8: D0C0          MOVE.B     D0,(A0)+
0ECA: 7207          MOVEQ      #7,D1
0ECC: C3E89F14      ANDA.L     -24812(A0),A1
0ED0: D881          MOVE.B     D1,(A4)
0ED2: 3043          MOVEA.W    D3,A0
0ED4: 48680007      PEA        7(A0)
0ED8: 2F04          MOVE.L     D4,-(A7)
0EDA: 4EAD005A      JSR        90(A5)                         ; JT[90]
0EDE: DC80          MOVE.B     D0,(A6)
0EE0: 6000022C      BRA.W      $1110
0EE4: 102DA5BF      MOVE.B     -23105(A5),D0                  ; A5-23105
0EE8: B02DCEF5      MOVE.W     -12555(A5),D0                  ; A5-12555
0EEC: 6714          BEQ.S      $0F02
0EEE: 302DF8CC      MOVE.W     -1844(A5),D0                   ; A5-1844
0EF2: 204D          MOVEA.L    A5,A0
0EF4: D0C0          MOVE.B     D0,(A0)+
0EF6: D0C0          MOVE.B     D0,(A0)+
0EF8: 30689F00      MOVEA.W    -24832(A0),A0
0EFC: DC88          MOVE.B     A0,(A6)
0EFE: 6000020E      BRA.W      $1110
0F02: 302DF8CC      MOVE.W     -1844(A5),D0                   ; A5-1844
0F06: 204D          MOVEA.L    A5,A0
0F08: D0C0          MOVE.B     D0,(A0)+
0F0A: D0C0          MOVE.B     D0,(A0)+
0F0C: 30689EEC      MOVEA.W    -24852(A0),A0
0F10: DC88          MOVE.B     A0,(A6)
0F12: 600001FA      BRA.W      $1110
0F16: 4A6DF8CE      TST.W      -1842(A5)
0F1A: 6700011C      BEQ.W      $103A
0F1E: 4A2B003E      TST.B      62(A3)
0F22: 66000114      BNE.W      $103A
0F26: 102DA5C3      MOVE.B     -23101(A5),D0                  ; A5-23101
0F2A: B02DCEF9      MOVE.W     -12551(A5),D0                  ; A5-12551
0F2E: 671C          BEQ.S      $0F4C
0F30: 302DF8C8      MOVE.W     -1848(A5),D0                   ; A5-1848
0F34: 48C0          EXT.L      D0
0F36: E988D08D      MOVE.L     A0,-115(A4,A5.W)
0F3A: 2040          MOVEA.L    D0,A0
0F3C: 302DF8CA      MOVE.W     -1846(A5),D0                   ; A5-1846
0F40: D0C0          MOVE.B     D0,(A0)+
0F42: D0C0          MOVE.B     D0,(A0)+
0F44: 3E289DEC      MOVE.W     -25108(A0),D7
0F48: 48C7          EXT.L      D7
0F4A: 6052          BRA.S      $0F9E
0F4C: 102DA58D      MOVE.B     -23155(A5),D0                  ; A5-23155
0F50: B02DCEC3      MOVE.W     -12605(A5),D0                  ; A5-12605
0F54: 672E          BEQ.S      $0F84
0F56: 302DF8C8      MOVE.W     -1848(A5),D0                   ; A5-1848
0F5A: 48C0          EXT.L      D0
0F5C: E988D08D      MOVE.L     A0,-115(A4,A5.W)
0F60: 2040          MOVEA.L    D0,A0
0F62: 302DF8CA      MOVE.W     -1846(A5),D0                   ; A5-1846
0F66: D0C0          MOVE.B     D0,(A0)+
0F68: D0C0          MOVE.B     D0,(A0)+
0F6A: 3E289DEC      MOVE.W     -25108(A0),D7
0F6E: 48C7          EXT.L      D7
0F70: 486EFFFC      PEA        -4(A6)
0F74: 2F2D93C4      MOVE.L     -27708(A5),-(A7)               ; A5-27708
0F78: 4EAD09C2      JSR        2498(A5)                       ; JT[2498]
0F7C: 3040          MOVEA.W    D0,A0
0F7E: 9E88          MOVE.B     A0,(A7)
0F80: 508F          MOVE.B     A7,(A0)
0F82: 601A          BRA.S      $0F9E
0F84: 302DF8C8      MOVE.W     -1848(A5),D0                   ; A5-1848
0F88: 48C0          EXT.L      D0
0F8A: E988D08D      MOVE.L     A0,-115(A4,A5.W)
0F8E: 2040          MOVEA.L    D0,A0
0F90: 302DF8CA      MOVE.W     -1846(A5),D0                   ; A5-1846
0F94: D0C0          MOVE.B     D0,(A0)+
0F96: D0C0          MOVE.B     D0,(A0)+
0F98: 3E289CEC      MOVE.W     -25364(A0),D7
0F9C: 48C7          EXT.L      D7
0F9E: 302DF8C8      MOVE.W     -1848(A5),D0                   ; A5-1848
0FA2: 48C0          EXT.L      D0
0FA4: E988D08D      MOVE.L     A0,-115(A4,A5.W)
0FA8: 2040          MOVEA.L    D0,A0
0FAA: 302DF8CA      MOVE.W     -1846(A5),D0                   ; A5-1846
0FAE: D0C0          MOVE.B     D0,(A0)+
0FB0: D0C0          MOVE.B     D0,(A0)+
0FB2: 30689D6C      MOVEA.W    -25236(A0),A0
0FB6: 2D48FFE8      MOVE.L     A0,-24(A6)
0FBA: 122DA58D      MOVE.B     -23155(A5),D1                  ; A5-23155
0FBE: B22DCEC3      MOVE.W     -12605(A5),D1                  ; A5-12605
0FC2: 6746          BEQ.S      $100A
0FC4: 486EFFFC      PEA        -4(A6)
0FC8: 2F2D93C4      MOVE.L     -27708(A5),-(A7)               ; A5-27708
0FCC: 4EAD09C2      JSR        2498(A5)                       ; JT[2498]
0FD0: 48C0          EXT.L      D0
0FD2: 91AEFFE8302D  MOVE.B     -24(A6),45(A0,D3.W)
0FD8: F8C8          MOVE.W     A0,(A4)+
0FDA: 48C0          EXT.L      D0
0FDC: E988D08D      MOVE.L     A0,-115(A4,A5.W)
0FE0: 2040          MOVEA.L    D0,A0
0FE2: 302DF8CA      MOVE.W     -1846(A5),D0                   ; A5-1846
0FE6: D0C0          MOVE.B     D0,(A0)+
0FE8: D0C0          MOVE.B     D0,(A0)+
0FEA: 32289B6C      MOVE.W     -25748(A0),D1
0FEE: 48C1          EXT.L      D1
0FF0: D3AEFFE84A6D  MOVE.B     -24(A6),109(A1,D4.L*2)
0FF6: F8CC          MOVE.W     A4,(A4)+
0FF8: 508F          MOVE.B     A7,(A0)
0FFA: 660E          BNE.S      $100A
0FFC: 0C6D0007F8C8  CMPI.W     #$0007,-1848(A5)
1002: 6606          BNE.S      $100A
1004: 0686000004B0  ADDI.L     #$000004B0,D6
100A: 3043          MOVEA.W    D3,A0
100C: 48680005      PEA        5(A0)
1010: 2F07          MOVE.L     D7,-(A7)
1012: 3043          MOVEA.W    D3,A0
1014: 2F08          MOVE.L     A0,-(A7)
1016: 4EAD0042      JSR        66(A5)                         ; JT[66]
101A: 48780005      PEA        $0005.W
101E: 2F2EFFE8      MOVE.L     -24(A6),-(A7)
1022: 2200          MOVE.L     D0,D1
1024: 4EAD0042      JSR        66(A5)                         ; JT[66]
1028: C141          AND.W      D0,D1
102A: D081          MOVE.B     D1,(A0)
102C: 2F00          MOVE.L     D0,-(A7)
102E: 4EAD005A      JSR        90(A5)                         ; JT[90]
1032: DC80          MOVE.B     D0,(A6)
1034: 600000D8      BRA.W      $1110
1038: 102DA5BF      MOVE.B     -23105(A5),D0                  ; A5-23105
103C: B02DCEF5      MOVE.W     -12555(A5),D0                  ; A5-12555
1040: 677C          BEQ.S      $10BE
1042: 102DA5C3      MOVE.B     -23101(A5),D0                  ; A5-23101
1046: B02DCEF9      MOVE.W     -12551(A5),D0                  ; A5-12551
104A: 671E          BEQ.S      $106A
104C: 302DF8C8      MOVE.W     -1848(A5),D0                   ; A5-1848
1050: 48C0          EXT.L      D0
1052: E988D08D      MOVE.L     A0,-115(A4,A5.W)
1056: 2040          MOVEA.L    D0,A0
1058: 302DF8CA      MOVE.W     -1846(A5),D0                   ; A5-1846
105C: D0C0          MOVE.B     D0,(A0)+
105E: D0C0          MOVE.B     D0,(A0)+
1060: 30689DEC      MOVEA.W    -25108(A0),A0
1064: DC88          MOVE.B     A0,(A6)
1066: 600000A6      BRA.W      $1110
106A: 102DA58D      MOVE.B     -23155(A5),D0                  ; A5-23155
106E: B02DCEC3      MOVE.W     -12605(A5),D0                  ; A5-12605
1072: 672E          BEQ.S      $10A2
1074: 302DF8C8      MOVE.W     -1848(A5),D0                   ; A5-1848
1078: 48C0          EXT.L      D0
107A: E988D08D      MOVE.L     A0,-115(A4,A5.W)
107E: 2040          MOVEA.L    D0,A0
1080: 302DF8CA      MOVE.W     -1846(A5),D0                   ; A5-1846
1084: D0C0          MOVE.B     D0,(A0)+
1086: D0C0          MOVE.B     D0,(A0)+
1088: 38289DEC      MOVE.W     -25108(A0),D4
108C: 48C4          EXT.L      D4
108E: 486EFFFC      PEA        -4(A6)
1092: 2F2D93C4      MOVE.L     -27708(A5),-(A7)               ; A5-27708
1096: 4EAD09C2      JSR        2498(A5)                       ; JT[2498]
109A: 3040          MOVEA.W    D0,A0
109C: 9888          MOVE.B     A0,(A4)
109E: 508F          MOVE.B     A7,(A0)
10A0: 606C          BRA.S      $110E
10A2: 302DF8C8      MOVE.W     -1848(A5),D0                   ; A5-1848
10A6: 48C0          EXT.L      D0
10A8: E988D08D      MOVE.L     A0,-115(A4,A5.W)
10AC: 2040          MOVEA.L    D0,A0
10AE: 302DF8CA      MOVE.W     -1846(A5),D0                   ; A5-1846
10B2: D0C0          MOVE.B     D0,(A0)+
10B4: D0C0          MOVE.B     D0,(A0)+
10B6: 30689CEC      MOVEA.W    -25364(A0),A0
10BA: DC88          MOVE.B     A0,(A6)
10BC: 6050          BRA.S      $110E
10BE: 302DF8C8      MOVE.W     -1848(A5),D0                   ; A5-1848
10C2: 48C0          EXT.L      D0
10C4: E988D08D      MOVE.L     A0,-115(A4,A5.W)
10C8: 2040          MOVEA.L    D0,A0
10CA: 302DF8CA      MOVE.W     -1846(A5),D0                   ; A5-1846
10CE: D0C0          MOVE.B     D0,(A0)+
10D0: D0C0          MOVE.B     D0,(A0)+
10D2: 30689C6C      MOVEA.W    -25492(A0),A0
10D6: DC88          MOVE.B     A0,(A6)
10D8: 122DA58D      MOVE.B     -23155(A5),D1                  ; A5-23155
10DC: B22DCEC3      MOVE.W     -12605(A5),D1                  ; A5-12605
10E0: 672C          BEQ.S      $110E
10E2: 486EFFFC      PEA        -4(A6)
10E6: 2F2D93C4      MOVE.L     -27708(A5),-(A7)               ; A5-27708
10EA: 4EAD09C2      JSR        2498(A5)                       ; JT[2498]
10EE: 3040          MOVEA.W    D0,A0
10F0: 9C88          MOVE.B     A0,(A6)
10F2: 302DF8C8      MOVE.W     -1848(A5),D0                   ; A5-1848
10F6: 48C0          EXT.L      D0
10F8: E988D08D      MOVE.L     A0,-115(A4,A5.W)
10FC: 2040          MOVEA.L    D0,A0
10FE: 302DF8CA      MOVE.W     -1846(A5),D0                   ; A5-1846
1102: D0C0          MOVE.B     D0,(A0)+
1104: D0C0          MOVE.B     D0,(A0)+
1106: 30689B6C      MOVEA.W    -25748(A0),A0
110A: DC88          MOVE.B     A0,(A6)
110C: 508F          MOVE.B     A7,(A0)
110E: 102B003C      MOVE.B     60(A3),D0
1112: 4880          EXT.W      D0
1114: 9045          MOVEA.B    D5,A0
1116: D16DF8CADB6D  MOVE.B     -1846(A5),-9363(A0)            ; A5-1846
111C: F8CC          MOVE.W     A4,(A4)+
111E: 302DB1D6      MOVE.W     -20010(A5),D0                  ; A5-20010
1122: 9043          MOVEA.B    D3,A0
1124: D16DF8C8D76D  MOVE.B     -1848(A5),-10387(A0)           ; A5-1848
112A: F8CC          MOVE.W     A4,(A4)+
112C: 2006          MOVE.L     D6,D0
112E: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
1132: 4E5E          UNLK       A6
1134: 4E75          RTS        


; ======= Function at 0x1136 =======
1136: 4E56FE3A      LINK       A6,#-454                       ; frame=454
113A: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
113E: 282E0008      MOVE.L     8(A6),D4
1142: 7E00          MOVEQ      #0,D7
1144: 42AEFE46      CLR.L      -442(A6)
1148: 42AEFE42      CLR.L      -446(A6)
114C: 4EAD0AB2      JSR        2738(A5)                       ; JT[2738]
1150: 306DF7F4      MOVEA.W    -2060(A5),A0
1154: D1C82F08      MOVE.B     A0,$2F08.W
1158: 486EFE96      PEA        -362(A6)
115C: 2F2DF7F0      MOVE.L     -2064(A5),-(A7)                ; A5-2064
1160: 4EAD067A      JSR        1658(A5)                       ; JT[1658]
1164: 266DF870      MOVEA.L    -1936(A5),A3
1168: 246DF874      MOVEA.L    -1932(A5),A2
116C: 2D6DF880FE8C  MOVE.L     -1920(A5),-372(A6)             ; A5-1920
1172: 203C0BEBC200  MOVE.L     #$0BEBC200,D0
1178: 2D40FE3A      MOVE.L     D0,-454(A6)
117C: 2D40FE3E      MOVE.L     D0,-450(A6)
1180: 4FEF000C      LEA        12(A7),A7
1184: 600000E2      BRA.W      $126A
1188: 3D7C0001FE94  MOVE.W     #$0001,-364(A6)
118E: 200B          MOVE.L     A3,D0
1190: 675E          BEQ.S      $11F0
1192: 200A          MOVE.L     A2,D0
1194: 670A          BEQ.S      $11A0
1196: 202B0004      MOVE.L     4(A3),D0
119A: B0AA0004      MOVE.W     4(A2),(A0)
119E: 6F16          BLE.S      $11B6
11A0: 284B          MOVEA.L    A3,A4
11A2: 2653          MOVEA.L    (A3),A3
11A4: 2F04          MOVE.L     D4,-(A7)
11A6: 2F0C          MOVE.L     A4,-(A7)
11A8: 4EAD0AA2      JSR        2722(A5)                       ; JT[2722]
11AC: 4A80          TST.L      D0
11AE: 508F          MOVE.B     A7,(A0)
11B0: 660000B6      BNE.W      $126A
11B4: 6040          BRA.S      $11F6
11B6: 102A000A      MOVE.B     10(A2),D0
11BA: B02B000A      MOVE.W     10(A3),D0
11BE: 6616          BNE.S      $11D6
11C0: 102A000B      MOVE.B     11(A2),D0
11C4: B02B000B      MOVE.W     11(A3),D0
11C8: 660C          BNE.S      $11D6
11CA: 102A000C      MOVE.B     12(A2),D0
11CE: B02B000C      MOVE.W     12(A3),D0
11D2: 6602          BNE.S      $11D6
11D4: 2653          MOVEA.L    (A3),A3
11D6: 426EFE94      CLR.W      -364(A6)
11DA: 202A0004      MOVE.L     4(A2),D0
11DE: B0ADF880      MOVE.W     -1920(A5),(A0)                 ; A5-1920
11E2: 6E06          BGT.S      $11EA
11E4: 95CA6000      MOVE.B     A2,24576(PC)
11E8: 0080284A2452  ORI.L      #$284A2452,D0
11EE: 6006          BRA.S      $11F6
11F0: 200A          MOVE.L     A2,D0
11F2: 66E2          BNE.S      $11D6
11F4: 607A          BRA.S      $1270
11F6: 7C00          MOVEQ      #0,D6
11F8: 3C2C0038      MOVE.W     56(A4),D6
11FC: 2D6C0032FE90  MOVE.L     50(A4),-368(A6)
1202: 206EFE90      MOVEA.L    -368(A6),A0
1206: 54AEFE90      MOVE.B     -368(A6),(A2)
120A: 3A10          MOVE.W     (A0),D5
120C: 204E          MOVEA.L    A6,A0
120E: D0C5          MOVE.B     D5,(A0)+
1210: D0C5          MOVE.B     D5,(A0)+
1212: 3068FE96      MOVEA.W    -362(A0),A0
1216: B1C66C0C      MOVE.W     D6,$6C0C.W
121A: 204E          MOVEA.L    A6,A0
121C: D0C5          MOVE.B     D5,(A0)+
121E: D0C5          MOVE.B     D5,(A0)+
1220: 3C28FE96      MOVE.W     -362(A0),D6
1224: 48C6          EXT.L      D6
1226: 4A45          TST.W      D5
1228: 66D8          BNE.S      $1202
122A: 4A86          TST.L      D6
122C: 673A          BEQ.S      $1268
122E: 2D6C0032FE90  MOVE.L     50(A4),-368(A6)
1234: 206EFE90      MOVEA.L    -368(A6),A0
1238: 54AEFE90      MOVE.B     -368(A6),(A2)
123C: 3A10          MOVE.W     (A0),D5
123E: 204E          MOVEA.L    A6,A0
1240: D0C5          MOVE.B     D5,(A0)+
1242: D0C5          MOVE.B     D5,(A0)+
1244: 9D68FE964A45  MOVE.B     -362(A0),19013(A6)
124A: 66E8          BNE.S      $1234
124C: 2F0C          MOVE.L     A4,-(A7)
124E: 2F04          MOVE.L     D4,-(A7)
1250: 4EBAF6C8      JSR        -2360(PC)
1254: 2600          MOVE.L     D0,D3
1256: 2D6C0004FE8C  MOVE.L     4(A4),-372(A6)
125C: 2E86          MOVE.L     D6,(A7)
125E: 2F03          MOVE.L     D3,-(A7)
1260: 4EAD0042      JSR        66(A5)                         ; JT[66]
1264: DE80          MOVE.B     D0,(A7)
1266: 588F          MOVE.B     A7,(A4)
1268: 4A6EFE96      TST.W      -362(A6)
126C: 6600FF1A      BNE.W      $118A
1270: 4A6EFE96      TST.W      -362(A6)
1274: 6700008C      BEQ.W      $1304
1278: 302DB1D6      MOVE.W     -20010(A5),D0                  ; A5-20010
127C: 122DCEF5      MOVE.B     -12555(A5),D1                  ; A5-12555
1280: 4881          EXT.W      D1
1282: 48C0          EXT.L      D0
1284: E78841ED      MOVE.L     A0,-19(A3,D4.W)
1288: F884          MOVE.W     D4,(A4)
128A: D088          MOVE.B     A0,(A0)
128C: 48C1          EXT.L      D1
128E: E589D081      MOVE.L     A1,-127(A2,A5.W)
1292: 2040          MOVEA.L    D0,A0
1294: 2610          MOVE.L     (A0),D3
1296: 0C830BEBC200  CMPI.L     #$0BEBC200,D3
129C: 6644          BNE.S      $12E2
129E: 2F2DF878      MOVE.L     -1928(A5),-(A7)                ; A5-1928
12A2: 2F04          MOVE.L     D4,-(A7)
12A4: 4EBAF674      JSR        -2444(PC)
12A8: 2044          MOVEA.L    D4,A0
12AA: 3228001E      MOVE.W     30(A0),D1
12AE: 204D          MOVEA.L    A5,A0
12B0: D0C1          MOVE.B     D1,(A0)+
12B2: D0C1          MOVE.B     D1,(A0)+
12B4: 3068BBF4      MOVEA.W    -17420(A0),A0
12B8: 2240          MOVEA.L    D0,A1
12BA: 43E9012C      LEA        300(A1),A1
12BE: 93C8302DB1D6  MOVE.B     A0,$302DB1D6
12C4: 122DCEF5      MOVE.B     -12555(A5),D1                  ; A5-12555
12C8: 4881          EXT.W      D1
12CA: 48C0          EXT.L      D0
12CC: E78841ED      MOVE.L     A0,-19(A3,D4.W)
12D0: F884          MOVE.W     D4,(A4)
12D2: D088          MOVE.B     A0,(A0)
12D4: 48C1          EXT.L      D1
12D6: E589D081      MOVE.L     A1,-127(A2,A5.W)
12DA: 2040          MOVEA.L    D0,A0
12DC: 2089          MOVE.L     A1,(A0)
12DE: 2609          MOVE.L     A1,D3
12E0: 508F          MOVE.B     A7,(A0)
12E2: 2044          MOVEA.L    D4,A0
12E4: 3028001E      MOVE.W     30(A0),D0
12E8: 204D          MOVEA.L    A5,A0
12EA: D0C0          MOVE.B     D0,(A0)+
12EC: D0C0          MOVE.B     D0,(A0)+
12EE: 3068BBF4      MOVEA.W    -17420(A0),A0
12F2: D688          MOVE.B     A0,(A3)
12F4: 306EFE96      MOVEA.W    -362(A6),A0
12F8: 2F08          MOVE.L     A0,-(A7)
12FA: 2F03          MOVE.L     D3,-(A7)
12FC: 4EAD0042      JSR        66(A5)                         ; JT[66]
1300: DE80          MOVE.B     D0,(A7)
1302: 306DF8D0      MOVEA.W    -1840(A5),A0
1306: 2F08          MOVE.L     A0,-(A7)
1308: 2F07          MOVE.L     D7,-(A7)
130A: 4EAD005A      JSR        90(A5)                         ; JT[90]
130E: 2E00          MOVE.L     D0,D7
1310: 202EFE8C      MOVE.L     -372(A6),D0
1314: B0ADF8EC      MOVE.W     -1812(A5),(A0)                 ; A5-1812
1318: 6C06          BGE.S      $1320
131A: 2B6EFE8CF8EC  MOVE.L     -372(A6),-1812(A5)
1320: 2044          MOVEA.L    D4,A0
1322: 21470018      MOVE.L     D7,24(A0)
1326: 2F04          MOVE.L     D4,-(A7)
1328: 4EAD0842      JSR        2114(A5)                       ; JT[2114]
132C: 4CEE1CF8FE1A  MOVEM.L    -486(A6),D3/D4/D5/D6/D7/A2/A3/A4
1332: 4E5E          UNLK       A6
1334: 4E75          RTS        

1336: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
133A: 286DF8C4      MOVEA.L    -1852(A5),A4
133E: 47EDF7F6      LEA        -2058(A5),A3                   ; A5-2058
1342: 4280          CLR.L      D0
1344: 41EDA54E      LEA        -23218(A5),A0                  ; A5-23218
1348: 43EDCE84      LEA        -12668(A5),A1                  ; A5-12668
134C: 121C          MOVE.B     (A4)+,D1
134E: 4881          EXT.W      D1
1350: 4282          CLR.L      D2
1352: 14301000      MOVE.B     0(A0,D1.W),D2
1356: 94311000      MOVE.B     0(A1,D1.W),D2
135A: 670C          BEQ.S      $1368
135C: 0441003F      SUBI.W     #$003F,D1
1360: D241          MOVEA.B    D1,A1
1362: C5F31000      ANDA.L     0(A3,D1.W),A2
1366: D082          MOVE.B     D2,(A0)
1368: 121C          MOVE.B     (A4)+,D1
136A: 66E2          BNE.S      $134E
136C: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
1370: 4E75          RTS        


; ======= Function at 0x1372 =======
1372: 4E56FFBE      LINK       A6,#-66                        ; frame=66
1376: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
137A: 2C2E0008      MOVE.L     8(A6),D6
137E: 266E0010      MOVEA.L    16(A6),A3
1382: 2E2E000C      MOVE.L     12(A6),D7
1386: 7042          MOVEQ      #66,D0
1388: C1EDCF04      ANDA.L     -12540(A5),A0
138C: D086          MOVE.B     D6,(A0)
138E: 2840          MOVEA.L    D0,A4
1390: 102B0021      MOVE.B     33(A3),D0
1394: 4880          EXT.W      D0
1396: 204D          MOVEA.L    A5,A0
1398: 48C0          EXT.L      D0
139A: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
139E: 2468F72A      MOVEA.L    -2262(A0),A2
13A2: BC8A          MOVE.W     A2,(A6)
13A4: 6454          BCC.S      $13FA
13A6: B9CA6350      MOVE.W     A2,#$6350
13AA: 102A0030      MOVE.B     48(A2),D0
13AE: B02B0020      MOVE.W     32(A3),D0
13B2: 6646          BNE.S      $13FA
13B4: 102A0031      MOVE.B     49(A2),D0
13B8: B02B0021      MOVE.W     33(A3),D0
13BC: 663C          BNE.S      $13FA
13BE: 102A003C      MOVE.B     60(A2),D0
13C2: 4880          EXT.W      D0
13C4: B06DB1D6      MOVEA.W    -20010(A5),A0
13C8: 6630          BNE.S      $13FA
13CA: 102A003E      MOVE.B     62(A2),D0
13CE: 4880          EXT.W      D0
13D0: B06E0016      MOVEA.W    22(A6),A0
13D4: 6624          BNE.S      $13FA
13D6: 102A003D      MOVE.B     61(A2),D0
13DA: 4880          EXT.W      D0
13DC: B06E0014      MOVEA.W    20(A6),A0
13E0: 6618          BNE.S      $13FA
13E2: 102A003F      MOVE.B     63(A2),D0
13E6: 4880          EXT.W      D0
13E8: B06E0018      MOVEA.W    24(A6),A0
13EC: 660C          BNE.S      $13FA
13EE: 102A0040      MOVE.B     64(A2),D0
13F2: 4880          EXT.W      D0
13F4: B06E001A      MOVEA.W    26(A6),A0
13F8: 6770          BEQ.S      $146A
13FA: 2446          MOVEA.L    D6,A2
13FC: 600000BE      BRA.W      $14BE
1400: 102A0030      MOVE.B     48(A2),D0
1404: B02B0020      MOVE.W     32(A3),D0
1408: 660000AE      BNE.W      $14BA
140C: 102A0031      MOVE.B     49(A2),D0
1410: B02B0021      MOVE.W     33(A3),D0
1414: 660000A2      BNE.W      $14BA
1418: 102A003C      MOVE.B     60(A2),D0
141C: 4880          EXT.W      D0
141E: B06DB1D6      MOVEA.W    -20010(A5),A0
1422: 66000094      BNE.W      $14BA
1426: 102A003E      MOVE.B     62(A2),D0
142A: 4880          EXT.W      D0
142C: B06E0016      MOVEA.W    22(A6),A0
1430: 66000086      BNE.W      $14BA
1434: 102A003D      MOVE.B     61(A2),D0
1438: 4880          EXT.W      D0
143A: B06E0014      MOVEA.W    20(A6),A0
143E: 6678          BNE.S      $14B8
1440: 102A003F      MOVE.B     63(A2),D0
1444: 4880          EXT.W      D0
1446: B06E0018      MOVEA.W    24(A6),A0
144A: 666C          BNE.S      $14B8
144C: 102A0040      MOVE.B     64(A2),D0
1450: 4880          EXT.W      D0
1452: B06E001A      MOVEA.W    26(A6),A0
1456: 6660          BNE.S      $14B8
1458: 102B0021      MOVE.B     33(A3),D0
145C: 4880          EXT.W      D0
145E: 204D          MOVEA.L    A5,A0
1460: 48C0          EXT.L      D0
1462: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1466: 214AF72A      MOVE.L     A2,-2262(A0)
146A: BEAA0004      MOVE.W     4(A2),(A7)
146E: 6F44          BLE.S      $14B4
1470: 41EEFFBE      LEA        -66(A6),A0
1474: 43D2          LEA        (A2),A1
1476: 700F          MOVEQ      #15,D0
1478: 20D9          MOVE.L     (A1)+,(A0)+
147A: 51C8FFFC      DBF        D0,$1478                       ; loop
147E: 30D9          MOVE.W     (A1)+,(A0)+
1480: 6014          BRA.S      $1496
1482: 41D2          LEA        (A2),A0
1484: 43EAFFBE      LEA        -66(A2),A1
1488: 700F          MOVEQ      #15,D0
148A: 20D9          MOVE.L     (A1)+,(A0)+
148C: 51C8FFFC      DBF        D0,$148A                       ; loop
1490: 30D9          MOVE.W     (A1)+,(A0)+
1492: 45EAFFBE      LEA        -66(A2),A2
1496: BC8A          MOVE.W     A2,(A6)
1498: 6406          BCC.S      $14A0
149A: BEAAFFC2      MOVE.W     -62(A2),(A7)
149E: 6EE2          BGT.S      $1482
14A0: 41D2          LEA        (A2),A0
14A2: 43EEFFBE      LEA        -66(A6),A1
14A6: 700F          MOVEQ      #15,D0
14A8: 20D9          MOVE.L     (A1)+,(A0)+
14AA: 51C8FFFC      DBF        D0,$14A8                       ; loop
14AE: 30D9          MOVE.W     (A1)+,(A0)+
14B0: 25470004      MOVE.L     D7,4(A2)
14B4: 200A          MOVE.L     A2,D0
14B6: 600C          BRA.S      $14C4
14B8: 45EA0042      LEA        66(A2),A2
14BC: B9CA6200      MOVE.W     A2,#$6200
14C0: FF407000      MOVE.W     D0,28672(A7)
14C4: 4CDF1CC0      MOVEM.L    (SP)+,D6/D7/A2/A3/A4           ; restore
14C8: 4E5E          UNLK       A6
14CA: 4E75          RTS        


; ======= Function at 0x14CC =======
14CC: 4E56FFBE      LINK       A6,#-66                        ; frame=66
14D0: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
14D4: 2E2E0008      MOVE.L     8(A6),D7
14D8: 4A6DCF04      TST.W      -12540(A5)
14DC: 6606          BNE.S      $14E4
14DE: 7000          MOVEQ      #0,D0
14E0: 60000154      BRA.W      $1638
14E4: 7A00          MOVEQ      #0,D5
14E6: 99CC6000      MOVE.B     A4,#$00
14EA: 00EC          DC.W       $00EC
14EC: 2007          MOVE.L     D7,D0
14EE: D08C          MOVE.B     A4,(A0)
14F0: 2640          MOVEA.L    D0,A3
14F2: 422B0009      CLR.B      9(A3)
14F6: 422B0008      CLR.B      8(A3)
14FA: 45F47810      LEA        16(A4,D7.L),A2
14FE: 176A0020000A  MOVE.B     32(A2),10(A3)
1504: 176A0021000B  MOVE.B     33(A2),11(A3)
150A: 2F0A          MOVE.L     A2,-(A7)
150C: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
1510: 1740000C      MOVE.B     D0,12(A3)
1514: 41EB0038      LEA        56(A3),A0
1518: 102B003C      MOVE.B     60(A3),D0
151C: 4880          EXT.W      D0
151E: 224D          MOVEA.L    A5,A1
1520: D2C0          MOVE.B     D0,(A1)+
1522: D2C0          MOVE.B     D0,(A1)+
1524: 3029F8D2      MOVE.W     -1838(A1),D0
1528: C0D0          ANDA.W     (A0),A0
152A: 3080          MOVE.W     D0,(A0)
152C: 4257          CLR.W      (A7)
152E: 486DF7DC      PEA        -2084(A5)                      ; A5-2084
1532: 2F0A          MOVE.L     A2,-(A7)
1534: 4EAD0942      JSR        2370(A5)                       ; JT[2370]
1538: 45F47824      LEA        36(A4,D7.L),A2
153C: 3EBC0001      MOVE.W     #$0001,(A7)
1540: 42A7          CLR.L      -(A7)
1542: 42A7          CLR.L      -(A7)
1544: 4EAD09DA      JSR        2522(A5)                       ; JT[2522]
1548: 2480          MOVE.L     D0,(A2)
154A: 4A92          TST.L      (A2)
154C: 4FEF0014      LEA        20(A7),A7
1550: 6C06          BGE.S      $1558
1552: 04920000012C  SUBI.L     #$0000012C,(A2)
1558: 2012          MOVE.L     (A2),D0
155A: D1AB0004486D  MOVE.B     4(A3),109(A0,D4.L)
1560: F7DC4EAD      MOVE.W     (A4)+,-83(PC,D4.L)
1564: 094A          BCHG       D4,A2
1566: 486DF7DC      PEA        -2084(A5)                      ; A5-2084
156A: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
156E: 3805          MOVE.W     D5,D4
1570: 7042          MOVEQ      #66,D0
1572: C1C4          ANDA.L     D4,A0
1574: 2640          MOVEA.L    D0,A3
1576: 508F          MOVE.B     A7,(A0)
1578: 6052          BRA.S      $15CC
157A: 2007          MOVE.L     D7,D0
157C: D08B          MOVE.B     A3,(A0)
157E: 2440          MOVEA.L    D0,A2
1580: 70FF          MOVEQ      #-1,D0
1582: D044          MOVEA.B    D4,A0
1584: C1FC0042D087  ANDA.L     #$0042D087,A0
158A: 2C00          MOVE.L     D0,D6
158C: 2046          MOVEA.L    D6,A0
158E: 202A0004      MOVE.L     4(A2),D0
1592: B0A80004      MOVE.W     4(A0),(A0)
1596: 6F2E          BLE.S      $15C6
1598: 41EEFFBE      LEA        -66(A6),A0
159C: 43D2          LEA        (A2),A1
159E: 700F          MOVEQ      #15,D0
15A0: 20D9          MOVE.L     (A1)+,(A0)+
15A2: 51C8FFFC      DBF        D0,$15A0                       ; loop
15A6: 30D9          MOVE.W     (A1)+,(A0)+
15A8: 2046          MOVEA.L    D6,A0
15AA: 43D2          LEA        (A2),A1
15AC: 700F          MOVEQ      #15,D0
15AE: 22D8          MOVE.L     (A0)+,(A1)+
15B0: 51C8FFFC      DBF        D0,$15AE                       ; loop
15B4: 32D8          MOVE.W     (A0)+,(A1)+
15B6: 2046          MOVEA.L    D6,A0
15B8: 43EEFFBE      LEA        -66(A6),A1
15BC: 700F          MOVEQ      #15,D0
15BE: 20D9          MOVE.L     (A1)+,(A0)+
15C0: 51C8FFFC      DBF        D0,$15BE                       ; loop
15C4: 30D9          MOVE.W     (A1)+,(A0)+
15C6: 534447EB      MOVE.B     D4,18411(A1)
15CA: FFBE4A44      MOVE.W     ???,68(A7,D4.L*2)
15CE: 66AA          BNE.S      $157A
15D0: 5245          MOVEA.B    D5,A1
15D2: 49EC0042      LEA        66(A4),A4
15D6: BA6DCF04      MOVEA.W    -12540(A5),A5
15DA: 6D00FF10      BLT.W      $14EE
15DE: 7A00          MOVEQ      #0,D5
15E0: 99CC603C      MOVE.B     A4,#$3C
15E4: 47F47838      LEA        56(A4,D7.L),A3
15E8: 2007          MOVE.L     D7,D0
15EA: D08C          MOVE.B     A4,(A0)
15EC: 2440          MOVEA.L    D0,A2
15EE: 3013          MOVE.W     (A3),D0
15F0: B06DF8D0      MOVEA.W    -1840(A5),A0
15F4: 6304          BLS.S      $15FA
15F6: 36ADF8D0      MOVE.W     -1840(A5),(A3)                 ; A5-1840
15FA: 102A003C      MOVE.B     60(A2),D0
15FE: 4880          EXT.W      D0
1600: C1EDF8E2      ANDA.L     -1822(A5),A0
1604: 48C0          EXT.L      D0
1606: 91AA00047001  MOVE.B     4(A2),1(A0,D7.W)
160C: D045          MOVEA.B    D5,A0
160E: C1FC0042D087  ANDA.L     #$0042D087,A0
1614: 2480          MOVE.L     D0,(A2)
1616: 1545000D      MOVE.B     D5,13(A2)
161A: 5245          MOVEA.B    D5,A1
161C: 49EC0042      LEA        66(A4),A4
1620: BA6DCF04      MOVEA.W    -12540(A5),A5
1624: 6DBE          BLT.S      $15E4
1626: 70FF          MOVEQ      #-1,D0
1628: D045          MOVEA.B    D5,A0
162A: C1FC0042D087  ANDA.L     #$0042D087,A0
1630: 2040          MOVEA.L    D0,A0
1632: 4290          CLR.L      (A0)
1634: 2007          MOVE.L     D7,D0
1636: 4CDF1CF0      MOVEM.L    (SP)+,D4/D5/D6/D7/A2/A3/A4     ; restore
163A: 4E5E          UNLK       A6
163C: 4E75          RTS        


; ======= Function at 0x163E =======
163E: 4E560000      LINK       A6,#0
1642: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
1646: 266E0008      MOVEA.L    8(A6),A3
164A: 102B0021      MOVE.B     33(A3),D0
164E: 4880          EXT.W      D0
1650: 122B0020      MOVE.B     32(A3),D1
1654: 4881          EXT.W      D1
1656: C3FC001149ED  ANDA.L     #$001149ED,A1
165C: BCFE          MOVE.W     ???,(A6)+
165E: D28C          MOVE.B     A4,(A1)
1660: 3840          MOVEA.W    D0,A4
1662: D28C          MOVE.B     A4,(A1)
1664: 2841          MOVEA.L    D1,A4
1666: 426DB1D6      CLR.W      -20010(A5)
166A: 48780080      PEA        $0080.W
166E: 486DCE84      PEA        -12668(A5)                     ; A5-12668
1672: 4EAD01AA      JSR        426(A5)                        ; JT[426]
1676: 244B          MOVEA.L    A3,A2
1678: 508F          MOVE.B     A7,(A0)
167A: 1E12          MOVE.B     (A2),D7
167C: 4A07          TST.B      D7
167E: 6746          BEQ.S      $16C6
1680: 4A1C          TST.B      (A4)+
1682: 663E          BNE.S      $16C2
1684: 526DB1D6      MOVEA.B    -20010(A5),A1
1688: 1007          MOVE.B     D7,D0
168A: 4880          EXT.W      D0
168C: 204D          MOVEA.L    A5,A0
168E: D0C0          MOVE.B     D0,(A0)+
1690: 1007          MOVE.B     D7,D0
1692: 4880          EXT.W      D0
1694: 224D          MOVEA.L    A5,A1
1696: D2C0          MOVE.B     D0,(A1)+
1698: 1028CE84      MOVE.B     -12668(A0),D0
169C: B029A54E      MOVE.W     -23218(A1),D0
16A0: 6614          BNE.S      $16B6
16A2: 102DCEC3      MOVE.B     -12605(A5),D0                  ; A5-12605
16A6: B02DA58D      MOVE.W     -23155(A5),D0                  ; A5-23155
16AA: 6D04          BLT.S      $16B0
16AC: 4EAD01A2      JSR        418(A5)                        ; JT[418]
16B0: 522DCEC3      MOVE.B     -12605(A5),D1                  ; A5-12605
16B4: 600C          BRA.S      $16C2
16B6: 1012          MOVE.B     (A2),D0
16B8: 4880          EXT.W      D0
16BA: 204D          MOVEA.L    A5,A0
16BC: D0C0          MOVE.B     D0,(A0)+
16BE: 5228CE84      MOVE.B     -12668(A0),D1
16C2: 528A          MOVE.B     A2,(A1)
16C4: 60B4          BRA.S      $167A
16C6: 4CDF1C80      MOVEM.L    (SP)+,D7/A2/A3/A4              ; restore
16CA: 4E5E          UNLK       A6
16CC: 4E75          RTS        


; ======= Function at 0x16CE =======
16CE: 4E56FFFE      LINK       A6,#-2                         ; frame=2
16D2: 2F0C          MOVE.L     A4,-(A7)
16D4: 286E0016      MOVEA.L    22(A6),A4
16D8: 6028          BRA.S      $1702
16DA: 4A2C0030      TST.B      48(A4)
16DE: 6F20          BLE.S      $1700
16E0: 3F2C0036      MOVE.W     54(A4),-(A7)
16E4: 2F2E0012      MOVE.L     18(A6),-(A7)
16E8: 3F2E0010      MOVE.W     16(A6),-(A7)
16EC: 2F2E000C      MOVE.L     12(A6),-(A7)
16F0: 2F2E0008      MOVE.L     8(A6),-(A7)
16F4: 4EBA001A      JSR        26(PC)
16F8: 3D400010      MOVE.W     D0,16(A6)
16FC: 4FEF0010      LEA        16(A7),A7
1700: 2854          MOVEA.L    (A4),A4
1702: 200C          MOVE.L     A4,D0
1704: 66D4          BNE.S      $16DA
1706: 302E0010      MOVE.W     16(A6),D0
170A: 285F          MOVEA.L    (A7)+,A4
170C: 4E5E          UNLK       A6
170E: 4E75          RTS        


; ======= Function at 0x1710 =======
1710: 4E560000      LINK       A6,#0
1714: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
1718: 266E0008      MOVEA.L    8(A6),A3
171C: 3C2E0010      MOVE.W     16(A6),D6
1720: 3E2E0016      MOVE.W     22(A6),D7
1724: 0C47FFFF      CMPI.W     #$FFFF,D7
1728: 6604          BNE.S      $172E
172A: 3006          MOVE.W     D6,D0
172C: 6056          BRA.S      $1784
172E: 3846          MOVEA.W    D6,A4
1730: D9CC204B      MOVE.B     A4,#$4B
1734: D1CC3087      MOVE.B     A4,$3087.W
1738: 7A00          MOVEQ      #0,D5
173A: 204B          MOVEA.L    A3,A0
173C: D0C6          MOVE.B     D6,(A0)+
173E: 38306000      MOVE.W     0(A0,D6.W),D4
1742: 3445          MOVEA.W    D5,A2
1744: D5CA6004      MOVE.B     A2,24580(PC)
1748: 5245          MOVEA.B    D5,A1
174A: 548A          MOVE.B     A2,(A2)
174C: 204B          MOVEA.L    A3,A0
174E: D1CAB850      MOVE.B     A2,$B850.W
1752: 66F4          BNE.S      $1748
1754: BC45          MOVEA.W    D5,A6
1756: 662A          BNE.S      $1782
1758: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
175C: 204D          MOVEA.L    A5,A0
175E: 48C0          EXT.L      D0
1760: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1764: 70FF          MOVEQ      #-1,D0
1766: D06899D8      MOVEA.B    -26152(A0),A0
176A: C047          AND.W      D7,D0
176C: 3F00          MOVE.W     D0,-(A7)
176E: 2F2E0012      MOVE.L     18(A6),-(A7)
1772: 4EAD0A9A      JSR        2714(A5)                       ; JT[2714]
1776: 204C          MOVEA.L    A4,A0
1778: D1EE000C3080  MOVE.B     12(A6),$3080.W
177E: 5246          MOVEA.B    D6,A1
1780: 5C8F          MOVE.B     A7,(A6)
1782: 3006          MOVE.W     D6,D0
1784: 4CDF1CF0      MOVEM.L    (SP)+,D4/D5/D6/D7/A2/A3/A4     ; restore
1788: 4E5E          UNLK       A6
178A: 4E75          RTS        


; ======= Function at 0x178C =======
178C: 4E56FFFC      LINK       A6,#-4                         ; frame=4
1790: 2F0C          MOVE.L     A4,-(A7)
1792: 286E0012      MOVEA.L    18(A6),A4
1796: 601C          BRA.S      $17B4
1798: 2F0C          MOVE.L     A4,-(A7)
179A: 2F2E000E      MOVE.L     14(A6),-(A7)
179E: 3F2E000C      MOVE.W     12(A6),-(A7)
17A2: 2F2E0008      MOVE.L     8(A6),-(A7)
17A6: 4EBA001A      JSR        26(PC)
17AA: 2D40000E      MOVE.L     D0,14(A6)
17AE: 4FEF000E      LEA        14(A7),A7
17B2: 2854          MOVEA.L    (A4),A4
17B4: 200C          MOVE.L     A4,D0
17B6: 66E0          BNE.S      $1798
17B8: 202E000E      MOVE.L     14(A6),D0
17BC: 285F          MOVEA.L    (A7)+,A4
17BE: 4E5E          UNLK       A6
17C0: 4E75          RTS        


; ======= Function at 0x17C2 =======
17C2: 4E560000      LINK       A6,#0
17C6: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
17CA: 286E000E      MOVEA.L    14(A6),A4
17CE: 206E0012      MOVEA.L    18(A6),A0
17D2: 214C0032      MOVE.L     A4,50(A0)
17D6: 7E01          MOVEQ      #1,D7
17D8: 367C0002      MOVEA.W    #$0002,A3
17DC: 601C          BRA.S      $17FA
17DE: 206E0012      MOVEA.L    18(A6),A0
17E2: 3C280036      MOVE.W     54(A0),D6
17E6: 224B          MOVEA.L    A3,A1
17E8: D3EE000830118046  MOVE.B     8(A6),$30118046
17F0: BC40          MOVEA.W    D0,A6
17F2: 6602          BNE.S      $17F6
17F4: 38C7          MOVE.W     D7,(A4)+
17F6: 5247          MOVEA.B    D7,A1
17F8: 548B          MOVE.B     A3,(A2)
17FA: BE6E000C      MOVEA.W    12(A6),A7
17FE: 6DDE          BLT.S      $17DE
1800: 425C          CLR.W      (A4)+
1802: 200C          MOVE.L     A4,D0
1804: 4CDF18C0      MOVEM.L    (SP)+,D6/D7/A3/A4              ; restore
1808: 4E5E          UNLK       A6
180A: 4E75          RTS        


; ======= Function at 0x180C =======
180C: 4E56CD52      LINK       A6,#-12974                     ; frame=12974
1810: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
1814: 286E0008      MOVEA.L    8(A6),A4
1818: 2F0C          MOVE.L     A4,-(A7)
181A: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
181E: 486EFF5C      PEA        -164(A6)
1822: 4EAD095A      JSR        2394(A5)                       ; JT[2394]
1826: 3B40F7D2      MOVE.W     D0,-2094(A5)
182A: 2B6DD134A548  MOVE.L     -11980(A5),-23224(A5)          ; A5-11980
1830: 4A6E000C      TST.W      12(A6)
1834: 508F          MOVE.B     A7,(A0)
1836: 665E          BNE.S      $1896
1838: 4EAD0692      JSR        1682(A5)                       ; JT[1682]
183C: 2800          MOVE.L     D0,D4
183E: 1C2DA58D      MOVE.B     -23155(A5),D6                  ; A5-23155
1842: 4886          EXT.W      D6
1844: 102EFF9B      MOVE.B     -101(A6),D0
1848: 4880          EXT.W      D0
184A: D046          MOVEA.B    D6,A0
184C: 3600          MOVE.W     D0,D3
184E: 4A2DA58D      TST.B      -23155(A5)
1852: 6706          BEQ.S      $185A
1854: 7001          MOVEQ      #1,D0
1856: D046          MOVEA.B    D6,A0
1858: D640          MOVEA.B    D0,A3
185A: 2F04          MOVE.L     D4,-(A7)
185C: 7012          MOVEQ      #18,D0
185E: C1C3          ANDA.L     D3,A0
1860: D08D          MOVE.B     A5,(A0)
1862: 2040          MOVEA.L    D0,A0
1864: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
1868: D0C0          MOVE.B     D0,(A0)+
186A: D0C0          MOVE.B     D0,(A0)+
186C: 3228F756      MOVE.W     -2218(A0),D1
1870: C3FC20202F01  ANDA.L     #$20202F01,A1
1876: 4EAD004A      JSR        74(A5)                         ; JT[74]
187A: 0C80000006A4  CMPI.L     #$000006A4,D0
1880: 6314          BLS.S      $1896
1882: 486D0842      PEA        2114(A5)                       ; A5+2114
1886: 2F0C          MOVE.L     A4,-(A7)
1888: 4EAD0852      JSR        2130(A5)                       ; JT[2130]
188C: 41EDA5F0      LEA        -23056(A5),A0                  ; g_dawg_?
1890: 2008          MOVE.L     A0,D0
1892: 60000AF0      BRA.W      $2386
1896: 422EFF4E      CLR.B      -178(A6)
189A: 422EFF4D      CLR.B      -179(A6)
189E: 42ADF87C      CLR.L      -1924(A5)
18A2: 266D99D2      MOVEA.L    -26158(A5),A3
18A6: 60000096      BRA.W      $1940
18AA: 486EFEF6      PEA        -266(A6)
18AE: 486EFF4C      PEA        -180(A6)
18B2: 4EAD09C2      JSR        2498(A5)                       ; JT[2498]
18B6: 1213          MOVE.B     (A3),D1
18B8: 4881          EXT.W      D1
18BA: 204D          MOVEA.L    A5,A0
18BC: D0C1          MOVE.B     D1,(A0)+
18BE: D0C1          MOVE.B     D1,(A0)+
18C0: 3140F778      MOVE.W     D0,-2184(A0)
18C4: 4A40          TST.W      D0
18C6: 508F          MOVE.B     A7,(A0)
18C8: 6F22          BLE.S      $18EC
18CA: 1013          MOVE.B     (A3),D0
18CC: 4880          EXT.W      D0
18CE: 204E          MOVEA.L    A6,A0
18D0: D0C0          MOVE.B     D0,(A0)+
18D2: 1028FF5C      MOVE.B     -164(A0),D0
18D6: 4880          EXT.W      D0
18D8: 1213          MOVE.B     (A3),D1
18DA: 4881          EXT.W      D1
18DC: 204D          MOVEA.L    A5,A0
18DE: D0C1          MOVE.B     D1,(A0)+
18E0: D0C1          MOVE.B     D1,(A0)+
18E2: C1E8F778      ANDA.L     -2184(A0),A0
18E6: 48C0          EXT.L      D0
18E8: D1ADF87C1013  MOVE.B     -1924(A5),19(A0,D1.W)          ; A5-1924
18EE: 4880          EXT.W      D0
18F0: 204E          MOVEA.L    A6,A0
18F2: D0C0          MOVE.B     D0,(A0)+
18F4: 0C280001FF5C  CMPI.B     #$0001,-164(A0)
18FA: 6F40          BLE.S      $193C
18FC: 1D53FF4D      MOVE.B     (A3),-179(A6)
1900: 486EFEF6      PEA        -266(A6)
1904: 486EFF4C      PEA        -180(A6)
1908: 4EAD09C2      JSR        2498(A5)                       ; JT[2498]
190C: C1FC00071213  ANDA.L     #$00071213,A0
1912: 4881          EXT.W      D1
1914: 204E          MOVEA.L    A6,A0
1916: D0C1          MOVE.B     D1,(A0)+
1918: 1228FF5C      MOVE.B     -164(A0),D1
191C: 4881          EXT.W      D1
191E: 5341C1C1      MOVE.B     D1,-15935(A1)
1922: 48C0          EXT.L      D0
1924: 81EDF7D2      ORA.L      -2094(A5),A0
1928: 1213          MOVE.B     (A3),D1
192A: 4881          EXT.W      D1
192C: 204D          MOVEA.L    A5,A0
192E: D0C1          MOVE.B     D1,(A0)+
1930: D0C1          MOVE.B     D1,(A0)+
1932: D168F778422E  MOVE.B     -2184(A0),16942(A0)
1938: FF4D508F      MOVE.W     A5,20623(A7)
193C: 528B          MOVE.B     A3,(A1)
193E: 1D53FF4C      MOVE.B     (A3),-180(A6)
1942: 6600FF66      BNE.W      $18AC
1946: 046D01F4F84C  SUBI.W     #$01F4,-1972(A5)
194C: 046D0BB8F85A  SUBI.W     #$0BB8,-1958(A5)
1952: 046D03E8F86C  SUBI.W     #$03E8,-1940(A5)
1958: 486EFEF6      PEA        -266(A6)
195C: 2F2D93C0      MOVE.L     -27712(A5),-(A7)               ; A5-27712
1960: 4EAD09C2      JSR        2498(A5)                       ; JT[2498]
1964: 3B40F86E      MOVE.W     D0,-1938(A5)
1968: 2EADF726      MOVE.L     -2266(A5),(A7)                 ; A5-2266
196C: 486EFEFA      PEA        -262(A6)
1970: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
1974: 45EEFEFA      LEA        -262(A6),A2
1978: 4FEF000C      LEA        12(A7),A7
197C: 60000090      BRA.W      $1A10
1980: 1012          MOVE.B     (A2),D0
1982: 4880          EXT.W      D0
1984: 3F00          MOVE.W     D0,-(A7)
1986: 2F2DF726      MOVE.L     -2266(A5),-(A7)                ; A5-2266
198A: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
198E: 1812          MOVE.B     (A2),D4
1990: 4884          EXT.W      D4
1992: 48C4          EXT.L      D4
1994: 90ADF726      MOVE.B     -2266(A5),(A0)                 ; A5-2266
1998: 204E          MOVEA.L    A6,A0
199A: D1C41228      MOVE.B     D4,$1228.W
199E: FF5C4881      MOVE.W     (A4)+,18561(A7)
19A2: C3FC001E204D  ANDA.L     #$001E204D,A1
19A8: D1C4D1C4      MOVE.B     D4,$D1C4.W
19AC: 760A          MOVEQ      #10,D3
19AE: C7E89412      ANDA.L     -27630(A0),A3
19B2: 9641          MOVEA.B    D1,A3
19B4: D640          MOVEA.B    D0,A3
19B6: 47EA0001      LEA        1(A2),A3
19BA: 5C8F          MOVE.B     A7,(A6)
19BC: 604A          BRA.S      $1A08
19BE: 1013          MOVE.B     (A3),D0
19C0: 4880          EXT.W      D0
19C2: 3F00          MOVE.W     D0,-(A7)
19C4: 2F2DF726      MOVE.L     -2266(A5),-(A7)                ; A5-2266
19C8: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
19CC: 1813          MOVE.B     (A3),D4
19CE: 1C04          MOVE.B     D4,D6
19D0: 4886          EXT.W      D6
19D2: 48C6          EXT.L      D6
19D4: 90ADF726      MOVE.B     -2266(A5),(A0)                 ; A5-2266
19D8: 204E          MOVEA.L    A6,A0
19DA: D1C61228      MOVE.B     D6,$1228.W
19DE: FF5C4881      MOVE.W     (A4)+,18561(A7)
19E2: C3FC001E204D  ANDA.L     #$001E204D,A1
19E8: D1C6D1C6      MOVE.B     D6,$D1C6.W
19EC: 7A0A          MOVEQ      #10,D5
19EE: CBE89412      ANDA.L     -27630(A0),A5
19F2: 9A41          MOVEA.B    D1,A5
19F4: DA40          MOVEA.B    D0,A5
19F6: B645          MOVEA.W    D5,A3
19F8: 5C8F          MOVE.B     A7,(A6)
19FA: 6F0A          BLE.S      $1A06
19FC: 3605          MOVE.W     D5,D3
19FE: 1A04          MOVE.B     D4,D5
1A00: 4885          EXT.W      D5
1A02: 1692          MOVE.B     (A2),(A3)
1A04: 1485          MOVE.B     D5,(A2)
1A06: 528B          MOVE.B     A3,(A1)
1A08: 4A13          TST.B      (A3)
1A0A: 66B2          BNE.S      $19BE
1A0C: 528A          MOVE.B     A2,(A1)
1A0E: 4A12          TST.B      (A2)
1A10: 6600FF6E      BNE.W      $1982
1A14: 426DF7DA      CLR.W      -2086(A5)
1A18: 426DF7D8      CLR.W      -2088(A5)
1A1C: 426DF7D6      CLR.W      -2090(A5)
1A20: 426DF7D4      CLR.W      -2092(A5)
1A24: 47EEFEFA      LEA        -262(A6),A3
1A28: 1813          MOVE.B     (A3),D4
1A2A: 4A04          TST.B      D4
1A2C: 672C          BEQ.S      $1A5A
1A2E: 1004          MOVE.B     D4,D0
1A30: 4880          EXT.W      D0
1A32: 204E          MOVEA.L    A6,A0
1A34: D0C0          MOVE.B     D0,(A0)+
1A36: 4A28FF5C      TST.B      -164(A0)
1A3A: 671A          BEQ.S      $1A56
1A3C: 3B6DF7D8F7DA  MOVE.W     -2088(A5),-2086(A5)            ; A5-2088
1A42: 3B6DF7D6F7D8  MOVE.W     -2090(A5),-2088(A5)            ; A5-2090
1A48: 3B6DF7D4F7D6  MOVE.W     -2092(A5),-2090(A5)            ; A5-2092
1A4E: 1004          MOVE.B     D4,D0
1A50: 4880          EXT.W      D0
1A52: 3B40F7D4      MOVE.W     D0,-2092(A5)
1A56: 528B          MOVE.B     A3,(A1)
1A58: 60CE          BRA.S      $1A28
1A5A: 4A6DF7DA      TST.W      -2086(A5)
1A5E: 6604          BNE.S      $1A64
1A60: 4EAD01A2      JSR        418(A5)                        ; JT[418]
1A64: 0C6D000AF7D2  CMPI.W     #$000A,-2094(A5)
1A6A: 6F20          BLE.S      $1A8C
1A6C: 302DF7D6      MOVE.W     -2090(A5),D0                   ; A5-2090
1A70: 204D          MOVEA.L    A5,A0
1A72: D0C0          MOVE.B     D0,(A0)+
1A74: D0C0          MOVE.B     D0,(A0)+
1A76: 32289412      MOVE.W     -27630(A0),D1
1A7A: B26D94D6      MOVEA.W    -27434(A5),A1
1A7E: 6C0C          BGE.S      $1A8C
1A80: 426DF7DA      CLR.W      -2086(A5)
1A84: 426DF7D8      CLR.W      -2088(A5)
1A88: 426DF7D6      CLR.W      -2090(A5)
1A8C: 0C6D000DF7D2  CMPI.W     #$000D,-2094(A5)
1A92: 6F1C          BLE.S      $1AB0
1A94: 302DF7D8      MOVE.W     -2088(A5),D0                   ; A5-2088
1A98: 204D          MOVEA.L    A5,A0
1A9A: D0C0          MOVE.B     D0,(A0)+
1A9C: D0C0          MOVE.B     D0,(A0)+
1A9E: 32289412      MOVE.W     -27630(A0),D1
1AA2: B26D94D6      MOVEA.W    -27434(A5),A1
1AA6: 6E08          BGT.S      $1AB0
1AA8: 426DF7DA      CLR.W      -2086(A5)
1AAC: 426DF7D8      CLR.W      -2088(A5)
1AB0: 3F3C0071      MOVE.W     #$0071,-(A7)
1AB4: 2F0C          MOVE.L     A4,-(A7)
1AB6: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
1ABA: 122EFFCD      MOVE.B     -51(A6),D1
1ABE: 4881          EXT.W      D1
1AC0: 3041          MOVEA.W    D1,A0
1AC2: D088          MOVE.B     A0,(A0)
1AC4: 5C8F          MOVE.B     A7,(A6)
1AC6: 6706          BEQ.S      $1ACE
1AC8: 303CFE0C      MOVE.W     #$FE0C,D0
1ACC: 6002          BRA.S      $1AD0
1ACE: 7000          MOVEQ      #0,D0
1AD0: 3B40F8E2      MOVE.W     D0,-1822(A5)
1AD4: 72F9          MOVEQ      #-7,D1
1AD6: D26DF7D2      MOVEA.B    -2094(A5),A1
1ADA: 48C0          EXT.L      D0
1ADC: 81C1          ORA.L      D1,A0
1ADE: 3B40F8E2      MOVE.W     D0,-1822(A5)
1AE2: 122EFFCD      MOVE.B     -51(A6),D1
1AE6: 4881          EXT.W      D1
1AE8: 3B41F8CE      MOVE.W     D1,-1842(A5)
1AEC: 48780080      PEA        $0080.W
1AF0: 486EFF5C      PEA        -164(A6)
1AF4: 486DA54E      PEA        -23218(A5)                     ; A5-23218
1AF8: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
1AFC: 486DF7DC      PEA        -2084(A5)                      ; A5-2084
1B00: 4EAD0952      JSR        2386(A5)                       ; JT[2386]
1B04: 41EEE7A0      LEA        -6240(A6),A0
1B08: 2B48CF24      MOVE.L     A0,-12508(A5)
1B0C: 426DCF04      CLR.W      -12540(A5)
1B10: 2B7CF4143E00F880  MOVE.L     #$F4143E00,-1920(A5)
1B18: 4EAD0972      JSR        2418(A5)                       ; JT[2418]
1B1C: 486EFF1A      PEA        -230(A6)
1B20: 486EFF5C      PEA        -164(A6)
1B24: 4EAD0A92      JSR        2706(A5)                       ; JT[2706]
1B28: 41EEFF1A      LEA        -230(A6),A0
1B2C: 2B48F8C4      MOVE.L     A0,-1852(A5)
1B30: 486D09FA      PEA        2554(A5)                       ; A5+2554
1B34: 4EAD0A3A      JSR        2618(A5)                       ; JT[2618]
1B38: 4A6DCF04      TST.W      -12540(A5)
1B3C: 4FEF001C      LEA        28(A7),A7
1B40: 6614          BNE.S      $1B56
1B42: 486D0842      PEA        2114(A5)                       ; A5+2114
1B46: 2F0C          MOVE.L     A4,-(A7)
1B48: 4EAD0852      JSR        2130(A5)                       ; JT[2130]
1B4C: 41EDA5F0      LEA        -23056(A5),A0                  ; g_dawg_?
1B50: 2008          MOVE.L     A0,D0
1B52: 60000830      BRA.W      $2386
1B56: 7600          MOVEQ      #0,D3
1B58: 95CA6020      MOVE.B     A2,24608(PC)
1B5C: 2E2DCF24      MOVE.L     -12508(A5),D7                  ; A5-12508
1B60: DE8A          MOVE.B     A2,(A7)
1B62: 2047          MOVEA.L    D7,A0
1B64: 42680038      CLR.W      56(A0)
1B68: 2047          MOVEA.L    D7,A0
1B6A: 42A80032      CLR.L      50(A0)
1B6E: 2047          MOVEA.L    D7,A0
1B70: 317CFFFF0036  MOVE.W     #$FFFF,54(A0)
1B76: 5243          MOVEA.B    D3,A1
1B78: 45EA0042      LEA        66(A2),A2
1B7C: B66DCF04      MOVEA.W    -12540(A5),A3
1B80: 6DDA          BLT.S      $1B5C
1B82: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
1B86: 204D          MOVEA.L    A5,A0
1B88: 48C0          EXT.L      D0
1B8A: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1B8E: 202899D6      MOVE.L     -26154(A0),D0
1B92: 2B40F8E8      MOVE.L     D0,-1816(A5)
1B96: 2F00          MOVE.L     D0,-(A7)
1B98: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
1B9C: 2B40F8E4      MOVE.L     D0,-1820(A5)
1BA0: 4A80          TST.L      D0
1BA2: 588F          MOVE.B     A7,(A4)
1BA4: 6714          BEQ.S      $1BBA
1BA6: 2F2DF8E8      MOVE.L     -1816(A5),-(A7)                ; A5-1816
1BAA: 3F3CFFFF      MOVE.W     #$FFFF,-(A7)
1BAE: 2F2DF8E4      MOVE.L     -1820(A5),-(A7)                ; A5-1820
1BB2: 4EAD0D9A      JSR        3482(A5)                       ; JT[3482]
1BB6: 4FEF000A      LEA        10(A7),A7
1BBA: 4878003E      PEA        $003E.W
1BBE: 486ECD5A      PEA        -12966(A6)
1BC2: 4EAD01AA      JSR        426(A5)                        ; JT[426]
1BC6: 7600          MOVEQ      #0,D3
1BC8: 95CA508F      MOVE.B     A2,20623(PC)
1BCC: 600000CC      BRA.W      $1C9C
1BD0: 202DCF24      MOVE.L     -12508(A5),D0                  ; A5-12508
1BD4: 18320830      MOVE.B     48(A2,D0.L),D4
1BD8: 4884          EXT.W      D4
1BDA: 4A44          TST.W      D4
1BDC: 6604          BNE.S      $1BE2
1BDE: 4EAD01A2      JSR        418(A5)                        ; JT[418]
1BE2: 202DCF24      MOVE.L     -12508(A5),D0                  ; A5-12508
1BE6: 1A320831      MOVE.B     49(A2,D0.L),D5
1BEA: 4885          EXT.W      D5
1BEC: 7E11          MOVEQ      #17,D7
1BEE: CFC4          ANDA.L     D4,A7
1BF0: 41EDBCFE      LEA        -17154(A5),A0                  ; g_state1
1BF4: DE88          MOVE.B     A0,(A7)
1BF6: 72FF          MOVEQ      #-1,D1
1BF8: D244          MOVEA.B    D4,A1
1BFA: C3FC001141ED  ANDA.L     #$001141ED,A1
1C00: BCFE          MOVE.W     ???,(A6)+
1C02: D288          MOVE.B     A0,(A1)
1C04: 2D41CD52      MOVE.L     D1,-12974(A6)
1C08: 7401          MOVEQ      #1,D2
1C0A: D444          MOVEA.B    D4,A2
1C0C: C5FC001141ED  ANDA.L     #$001141ED,A2
1C12: BCFE          MOVE.W     ???,(A6)+
1C14: D488          MOVE.B     A0,(A2)
1C16: 2D42CD56      MOVE.L     D2,-12970(A6)
1C1A: 4A45          TST.W      D5
1C1C: 6604          BNE.S      $1C22
1C1E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
1C22: 0C450010      CMPI.W     #$0010,D5
1C26: 6D04          BLT.S      $1C2C
1C28: 4EAD01A2      JSR        418(A5)                        ; JT[418]
1C2C: 3045          MOVEA.W    D5,A0
1C2E: 4A307800      TST.B      0(A0,D7.L)
1C32: 6644          BNE.S      $1C78
1C34: 7011          MOVEQ      #17,D0
1C36: C1C4          ANDA.L     D4,A0
1C38: 41EDBCFD      LEA        -17155(A5),A0                  ; A5-17155
1C3C: D088          MOVE.B     A0,(A0)
1C3E: 3045          MOVEA.W    D5,A0
1C40: 4A300800      TST.B      0(A0,D0.L)
1C44: 6636          BNE.S      $1C7C
1C46: 7011          MOVEQ      #17,D0
1C48: C1C4          ANDA.L     D4,A0
1C4A: 41EDBCFF      LEA        -17153(A5),A0                  ; A5-17153
1C4E: D088          MOVE.B     A0,(A0)
1C50: 3045          MOVEA.W    D5,A0
1C52: 4A300800      TST.B      0(A0,D0.L)
1C56: 6624          BNE.S      $1C7C
1C58: 0C440010      CMPI.W     #$0010,D4
1C5C: 670A          BEQ.S      $1C68
1C5E: 206ECD52      MOVEA.L    -12974(A6),A0
1C62: 4A305000      TST.B      0(A0,D5.W)
1C66: 6614          BNE.S      $1C7C
1C68: 0C44000F      CMPI.W     #$000F,D4
1C6C: 670A          BEQ.S      $1C78
1C6E: 206ECD56      MOVEA.L    -12970(A6),A0
1C72: 4A305000      TST.B      0(A0,D5.W)
1C76: 6604          BNE.S      $1C7C
1C78: 5245          MOVEA.B    D5,A1
1C7A: 609E          BRA.S      $1C1A
1C7C: 204D          MOVEA.L    A5,A0
1C7E: 2005          MOVE.L     D5,D0
1C80: 48C0          EXT.L      D0
1C82: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1C86: 302899D8      MOVE.W     -26152(A0),D0
1C8A: 204E          MOVEA.L    A6,A0
1C8C: D0C4          MOVE.B     D4,(A0)+
1C8E: D0C4          MOVE.B     D4,(A0)+
1C90: 8168CD5A      OR.W       D0,-12966(A0)
1C94: 5243          MOVEA.B    D3,A1
1C96: 45EA0042      LEA        66(A2),A2
1C9A: B66DCF04      MOVEA.W    -12540(A5),A3
1C9E: 6D00FF30      BLT.W      $1BD2
1CA2: 486D0A02      PEA        2562(A5)                       ; A5+2562
1CA6: 486ECD5A      PEA        -12966(A6)
1CAA: 4EAD0A2A      JSR        2602(A5)                       ; JT[2602]
1CAE: 7600          MOVEQ      #0,D3
1CB0: 45EDF884      LEA        -1916(A5),A2                   ; A5-1916
1CB4: 508F          MOVE.B     A7,(A0)
1CB6: 602C          BRA.S      $1CE4
1CB8: 7A00          MOVEQ      #0,D5
1CBA: 2E0A          MOVE.L     A2,D7
1CBC: 2005          MOVE.L     D5,D0
1CBE: 48C0          EXT.L      D0
1CC0: E5882D40      MOVE.L     A0,64(A2,D2.L*4)
1CC4: CD52          AND.W      D6,(A2)
1CC6: 6012          BRA.S      $1CDA
1CC8: 206ECD52      MOVEA.L    -12974(A6),A0
1CCC: 21BC0BEBC2007800  MOVE.L     #$0BEBC200,0(A0,D7.L)
1CD4: 5245          MOVEA.B    D5,A1
1CD6: 58AECD52      MOVE.B     -12974(A6),(A4)
1CDA: 0C450002      CMPI.W     #$0002,D5
1CDE: 65E8          BCS.S      $1CC8
1CE0: 5243          MOVEA.B    D3,A1
1CE2: 508A          MOVE.B     A2,(A0)
1CE4: 0C430008      CMPI.W     #$0008,D3
1CE8: 65CE          BCS.S      $1CB8
1CEA: 7600          MOVEQ      #0,D3
1CEC: 45EDF8D2      LEA        -1838(A5),A2                   ; A5-1838
1CF0: 6030          BRA.S      $1D22
1CF2: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
1CF6: 9043          MOVEA.B    D3,A0
1CF8: 0C400011      CMPI.W     #$0011,D0
1CFC: 6504          BCS.S      $1D02
1CFE: 4EAD01A2      JSR        418(A5)                        ; JT[418]
1D02: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
1D06: 9043          MOVEA.B    D3,A0
1D08: 48C0          EXT.L      D0
1D0A: E9887207      MOVE.L     A0,7(A4,D7.W*2)
1D0E: 9243          MOVEA.B    D3,A1
1D10: 41ED9A58      LEA        -26024(A5),A0                  ; A5-26024
1D14: D088          MOVE.B     A0,(A0)
1D16: 3041          MOVEA.W    D1,A0
1D18: D1C834B0      MOVE.B     A0,$34B0.W
1D1C: 08005243      BTST       #21059,D0
1D20: 548A          MOVE.B     A2,(A2)
1D22: 0C430008      CMPI.W     #$0008,D3
1D26: 65CA          BCS.S      $1CF2
1D28: 3B6DF8D2F8D0  MOVE.W     -1838(A5),-1840(A5)            ; A5-1838
1D2E: 7007          MOVEQ      #7,D0
1D30: 3B40F8CA      MOVE.W     D0,-1846(A5)
1D34: 3B40F8C8      MOVE.W     D0,-1848(A5)
1D38: 72F9          MOVEQ      #-7,D1
1D3A: D26DF7D2      MOVEA.B    -2094(A5),A1
1D3E: 3B41F8CC      MOVE.W     D1,-1844(A5)
1D42: 2F2DCF24      MOVE.L     -12508(A5),-(A7)               ; A5-12508
1D46: 4EBAF784      JSR        -2172(PC)
1D4A: 2B40F870      MOVE.L     D0,-1936(A5)
1D4E: 42ADF874      CLR.L      -1932(A5)
1D52: 2E80          MOVE.L     D0,(A7)
1D54: 4EAD0ABA      JSR        2746(A5)                       ; JT[2746]
1D58: 2B6DF870F878  MOVE.L     -1936(A5),-1928(A5)            ; A5-1936
1D5E: 588F          MOVE.B     A7,(A4)
1D60: 6008          BRA.S      $1D6A
1D62: 206DF878      MOVEA.L    -1928(A5),A0
1D66: 2B50F878      MOVE.L     (A0),-1928(A5)
1D6A: 206DF878      MOVEA.L    -1928(A5),A0
1D6E: 4A90          TST.L      (A0)
1D70: 66F0          BNE.S      $1D62
1D72: 41EECF02      LEA        -12542(A6),A0
1D76: 2B48F7F0      MOVE.L     A0,-2064(A5)
1D7A: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
1D7E: 224D          MOVEA.L    A5,A1
1D80: 48C0          EXT.L      D0
1D82: E588D3C0      MOVE.L     A0,-64(A2,A5.W*2)
1D86: 70FF          MOVEQ      #-1,D0
1D88: D06999D8      MOVEA.B    -26152(A1),A0
1D8C: 4640          NOT.W      D0
1D8E: 3F00          MOVE.W     D0,-(A7)
1D90: 486EFF5C      PEA        -164(A6)
1D94: 4267          CLR.W      -(A7)
1D96: 486ECF02      PEA        -12542(A6)
1D9A: 486ECD98      PEA        -12904(A6)
1D9E: 4EBAF970      JSR        -1680(PC)
1DA2: 3B40F7F4      MOVE.W     D0,-2060(A5)
1DA6: 4A6DF7D4      TST.W      -2092(A5)
1DAA: 4FEF0010      LEA        16(A7),A7
1DAE: 6742          BEQ.S      $1DF2
1DB0: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
1DB4: 204D          MOVEA.L    A5,A0
1DB6: 48C0          EXT.L      D0
1DB8: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1DBC: 70FF          MOVEQ      #-1,D0
1DBE: D06899D8      MOVEA.B    -26152(A0),A0
1DC2: 322DF7D4      MOVE.W     -2092(A5),D1                   ; A5-2092
1DC6: 48C1          EXT.L      D1
1DC8: E989204D      MOVE.L     A1,77(A4,D2.W)
1DCC: D1C1C068      MOVE.B     D1,$C068.W
1DD0: B3F446403F00486E  MOVE.W     64(A4,D4.W*8),$3F00486E
1DD8: FF5C3F2D      MOVE.W     (A4)+,16173(A7)
1DDC: F7F4486ECF02  MOVE.W     110(A4,D4.L),2(PC,A4.L)
1DE2: 486ECD98      PEA        -12904(A6)
1DE6: 4EBAF928      JSR        -1752(PC)
1DEA: 3B40F7F4      MOVE.W     D0,-2060(A5)
1DEE: 4FEF0010      LEA        16(A7),A7
1DF2: 4A6DF7D6      TST.W      -2090(A5)
1DF6: 6742          BEQ.S      $1E3A
1DF8: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
1DFC: 204D          MOVEA.L    A5,A0
1DFE: 48C0          EXT.L      D0
1E00: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1E04: 70FF          MOVEQ      #-1,D0
1E06: D06899D8      MOVEA.B    -26152(A0),A0
1E0A: 322DF7D6      MOVE.W     -2090(A5),D1                   ; A5-2090
1E0E: 48C1          EXT.L      D1
1E10: E989204D      MOVE.L     A1,77(A4,D2.W)
1E14: D1C1C068      MOVE.B     D1,$C068.W
1E18: B3F446403F00486E  MOVE.W     64(A4,D4.W*8),$3F00486E
1E20: FF5C3F2D      MOVE.W     (A4)+,16173(A7)
1E24: F7F4486ECF02  MOVE.W     110(A4,D4.L),2(PC,A4.L)
1E2A: 486ECD98      PEA        -12904(A6)
1E2E: 4EBAF8E0      JSR        -1824(PC)
1E32: 3B40F7F4      MOVE.W     D0,-2060(A5)
1E36: 4FEF0010      LEA        16(A7),A7
1E3A: 4A6DF7D8      TST.W      -2088(A5)
1E3E: 6742          BEQ.S      $1E82
1E40: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
1E44: 204D          MOVEA.L    A5,A0
1E46: 48C0          EXT.L      D0
1E48: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1E4C: 70FF          MOVEQ      #-1,D0
1E4E: D06899D8      MOVEA.B    -26152(A0),A0
1E52: 322DF7D8      MOVE.W     -2088(A5),D1                   ; A5-2088
1E56: 48C1          EXT.L      D1
1E58: E989204D      MOVE.L     A1,77(A4,D2.W)
1E5C: D1C1C068      MOVE.B     D1,$C068.W
1E60: B3F446403F00486E  MOVE.W     64(A4,D4.W*8),$3F00486E
1E68: FF5C3F2D      MOVE.W     (A4)+,16173(A7)
1E6C: F7F4486ECF02  MOVE.W     110(A4,D4.L),2(PC,A4.L)
1E72: 486ECD98      PEA        -12904(A6)
1E76: 4EBAF898      JSR        -1896(PC)
1E7A: 3B40F7F4      MOVE.W     D0,-2060(A5)
1E7E: 4FEF0010      LEA        16(A7),A7
1E82: 4A6DF7DA      TST.W      -2086(A5)
1E86: 6742          BEQ.S      $1ECA
1E88: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
1E8C: 204D          MOVEA.L    A5,A0
1E8E: 48C0          EXT.L      D0
1E90: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
1E94: 70FF          MOVEQ      #-1,D0
1E96: D06899D8      MOVEA.B    -26152(A0),A0
1E9A: 322DF7DA      MOVE.W     -2086(A5),D1                   ; A5-2086
1E9E: 48C1          EXT.L      D1
1EA0: E989204D      MOVE.L     A1,77(A4,D2.W)
1EA4: D1C1C068      MOVE.B     D1,$C068.W
1EA8: B3F446403F00486E  MOVE.W     64(A4,D4.W*8),$3F00486E
1EB0: FF5C3F2D      MOVE.W     (A4)+,16173(A7)
1EB4: F7F4486ECF02  MOVE.W     110(A4,D4.L),2(PC,A4.L)
1EBA: 486ECD98      PEA        -12904(A6)
1EBE: 4EBAF850      JSR        -1968(PC)
1EC2: 3B40F7F4      MOVE.W     D0,-2060(A5)
1EC6: 4FEF0010      LEA        16(A7),A7
1ECA: 2F2DF870      MOVE.L     -1936(A5),-(A7)                ; A5-1936
1ECE: 486EFF5C      PEA        -164(A6)
1ED2: 3F2DF7F4      MOVE.W     -2060(A5),-(A7)                ; A5-2060
1ED6: 486ECF02      PEA        -12542(A6)
1EDA: 486ECD98      PEA        -12904(A6)
1EDE: 4EBAF7EE      JSR        -2066(PC)
1EE2: 3B40F7F4      MOVE.W     D0,-2060(A5)
1EE6: 2EADF870      MOVE.L     -1936(A5),(A7)                 ; A5-1936
1EEA: 2F2DA548      MOVE.L     -23224(A5),-(A7)               ; A5-23224
1EEE: 3F00          MOVE.W     D0,-(A7)
1EF0: 486ECD98      PEA        -12904(A6)
1EF4: 4EBAF896      JSR        -1898(PC)
1EF8: 2440          MOVEA.L    D0,A2
1EFA: 2E8C          MOVE.L     A4,(A7)
1EFC: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
1F00: 42ADB3E2      CLR.L      -19486(A5)
1F04: 4EAD097A      JSR        2426(A5)                       ; JT[2426]
1F08: 48780154      PEA        $0154.W
1F0C: 486DA5F0      PEA        -23056(A5)                     ; g_dawg_?
1F10: 4EAD01AA      JSR        426(A5)                        ; JT[426]
1F14: 7022          MOVEQ      #34,D0
1F16: 2E80          MOVE.L     D0,(A7)
1F18: 486EFED4      PEA        -300(A6)
1F1C: 4EAD01AA      JSR        426(A5)                        ; JT[426]
1F20: 426DCF04      CLR.W      -12540(A5)
1F24: 4EAD0932      JSR        2354(A5)                       ; JT[2354]
1F28: 4A40          TST.W      D0
1F2A: 4FEF0028      LEA        40(A7),A7
1F2E: 670000FA      BEQ.W      $202C
1F32: 486D0842      PEA        2114(A5)                       ; A5+2114
1F36: 4EAD09BA      JSR        2490(A5)                       ; JT[2490]
1F3A: 0C6D0001CF04  CMPI.W     #$0001,-12540(A5)
1F40: 588F          MOVE.B     A7,(A4)
1F42: 6704          BEQ.S      $1F48
1F44: 4EAD01A2      JSR        418(A5)                        ; JT[418]
1F48: 41EEFED4      LEA        -300(A6),A0
1F4C: 43EDA5F0      LEA        -23056(A5),A1                  ; g_dawg_?
1F50: 7007          MOVEQ      #7,D0
1F52: 20D9          MOVE.L     (A1)+,(A0)+
1F54: 51C8FFFC      DBF        D0,$1F52                       ; loop
1F58: 30D9          MOVE.W     (A1)+,(A0)+
1F5A: 3F3C0071      MOVE.W     #$0071,-(A7)
1F5E: 2F0C          MOVE.L     A4,-(A7)
1F60: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
1F64: 4A80          TST.L      D0
1F66: 5C8F          MOVE.B     A7,(A6)
1F68: 6722          BEQ.S      $1F8C
1F6A: 3F3C0071      MOVE.W     #$0071,-(A7)
1F6E: 486EFED4      PEA        -300(A6)
1F72: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
1F76: 4A80          TST.L      D0
1F78: 5C8F          MOVE.B     A7,(A6)
1F7A: 6610          BNE.S      $1F8C
1F7C: 486DF8F0      PEA        -1808(A5)                      ; A5-1808
1F80: 486EFED4      PEA        -300(A6)
1F84: 4EAD0DAA      JSR        3498(A5)                       ; JT[3498]
1F88: 508F          MOVE.B     A7,(A0)
1F8A: 6048          BRA.S      $1FD4
1F8C: 3F3C0071      MOVE.W     #$0071,-(A7)
1F90: 486EFED4      PEA        -300(A6)
1F94: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
1F98: 4A80          TST.L      D0
1F9A: 5C8F          MOVE.B     A7,(A6)
1F9C: 6736          BEQ.S      $1FD4
1F9E: 3F3C0075      MOVE.W     #$0075,-(A7)
1FA2: 486EFED4      PEA        -300(A6)
1FA6: 4EAD0DBA      JSR        3514(A5)                       ; JT[3514]
1FAA: 2640          MOVEA.L    D0,A3
1FAC: 200B          MOVE.L     A3,D0
1FAE: 5C8F          MOVE.B     A7,(A6)
1FB0: 6722          BEQ.S      $1FD4
1FB2: 486EFED4      PEA        -300(A6)
1FB6: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
1FBA: 204E          MOVEA.L    A6,A0
1FBC: D1C016A8      MOVE.B     D0,$16A8.W
1FC0: FED3          MOVE.W     (A3),(A7)+
1FC2: 486EFED4      PEA        -300(A6)
1FC6: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
1FCA: 204E          MOVEA.L    A6,A0
1FCC: D1C04228      MOVE.B     D0,$4228.W
1FD0: FED3          MOVE.W     (A3),(A7)+
1FD2: 508F          MOVE.B     A7,(A0)
1FD4: 2F0C          MOVE.L     A4,-(A7)
1FD6: 4EAD0952      JSR        2386(A5)                       ; JT[2386]
1FDA: 47EEFED4      LEA        -300(A6),A3
1FDE: 588F          MOVE.B     A7,(A4)
1FE0: 600E          BRA.S      $1FF0
1FE2: 1013          MOVE.B     (A3),D0
1FE4: 4880          EXT.W      D0
1FE6: 204D          MOVEA.L    A5,A0
1FE8: D0C0          MOVE.B     D0,(A0)+
1FEA: 5328A54E      MOVE.B     -23218(A0),-(A1)
1FEE: 528B          MOVE.B     A3,(A1)
1FF0: 4A13          TST.B      (A3)
1FF2: 66EE          BNE.S      $1FE2
1FF4: 486EFF4C      PEA        -180(A6)
1FF8: 4EAD0952      JSR        2386(A5)                       ; JT[2386]
1FFC: 486EFF4C      PEA        -180(A6)
2000: 2F0C          MOVE.L     A4,-(A7)
2002: 4EAD09A2      JSR        2466(A5)                       ; JT[2466]
2006: 3D40FEF2      MOVE.W     D0,-270(A6)
200A: 486EFED4      PEA        -300(A6)
200E: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
2012: 486EFED4      PEA        -300(A6)
2016: 4EAD0952      JSR        2386(A5)                       ; JT[2386]
201A: 2E8C          MOVE.L     A4,(A7)
201C: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
2020: 426DCF04      CLR.W      -12540(A5)
2024: 4FEF0014      LEA        20(A7),A7
2028: 600E          BRA.S      $2038
202A: 3D7C007FFEF2  MOVE.W     #$007F,-270(A6)
2030: 306DBCF2      MOVEA.W    -17166(A5),A0
2034: 2D48FEE8      MOVE.L     A0,-280(A6)
2038: 486EFED4      PEA        -300(A6)
203C: 4EBAF600      JSR        -2560(PC)
2040: 486EFED4      PEA        -300(A6)
2044: 4EBAF0F0      JSR        -3856(PC)
2048: 48780080      PEA        $0080.W
204C: 486DCE84      PEA        -12668(A5)                     ; A5-12668
2050: 4EAD01AA      JSR        426(A5)                        ; JT[426]
2054: 2B7C0BEBC200F8EC  MOVE.L     #$0BEBC200,-1812(A5)
205C: 486D0A0A      PEA        2570(A5)                       ; A5+2570
2060: 4EAD0A3A      JSR        2618(A5)                       ; JT[2618]
2064: 2B6DF8ECF880  MOVE.L     -1812(A5),-1920(A5)            ; A5-1812
206A: 382DCF04      MOVE.W     -12540(A5),D4                  ; A5-12540
206E: 7600          MOVEQ      #0,D3
2070: 47EDA5F0      LEA        -23056(A5),A3                  ; g_dawg_?
2074: 4FEF0014      LEA        20(A7),A7
2078: 600002EA      BRA.W      $2366
207C: 41EEFED4      LEA        -300(A6),A0
2080: 43D3          LEA        (A3),A1
2082: 7007          MOVEQ      #7,D0
2084: 20D9          MOVE.L     (A1)+,(A0)+
2086: 51C8FFFC      DBF        D0,$2084                       ; loop
208A: 30D9          MOVE.W     (A1)+,(A0)+
208C: 4A2EFEF4      TST.B      -268(A6)
2090: 670002A4      BEQ.W      $2338
2094: 4A6E000C      TST.W      12(A6)
2098: 661A          BNE.S      $20B4
209A: 4A43          TST.W      D3
209C: 6716          BEQ.S      $20B4
209E: 202EFEE4      MOVE.L     -284(A6),D0
20A2: D0AEFEEC      MOVE.B     -276(A6),(A0)
20A6: 222DA600      MOVE.L     -23040(A5),D1                  ; A5-23040
20AA: D2ADA608      MOVE.B     -23032(A5),(A1)                ; A5-23032
20AE: B280          MOVE.W     D0,(A1)
20B0: 6C000284      BGE.W      $2338
20B4: 3B7C005ACF04  MOVE.W     #$005A,-12540(A5)
20BA: 41EED06C      LEA        -12180(A6),A0
20BE: 2B48CF24      MOVE.L     A0,-12508(A5)
20C2: 7A00          MOVEQ      #0,D5
20C4: 95CA6036      MOVE.B     A2,24630(PC)
20C8: 48780042      PEA        $0042.W
20CC: 204A          MOVEA.L    A2,A0
20CE: D1EDCF242F08  MOVE.B     -12508(A5),$2F08.W             ; A5-12508
20D4: 4EAD01AA      JSR        426(A5)                        ; JT[426]
20D8: 2E2DCF24      MOVE.L     -12508(A5),D7                  ; A5-12508
20DC: DE8A          MOVE.B     A2,(A7)
20DE: 2047          MOVEA.L    D7,A0
20E0: 216DF8800004  MOVE.L     -1920(A5),4(A0)                ; A5-1920
20E6: 2047          MOVEA.L    D7,A0
20E8: 317CFFFF0036  MOVE.W     #$FFFF,54(A0)
20EE: 3045          MOVEA.W    D5,A0
20F0: 2247          MOVEA.L    D7,A1
20F2: 23480028      MOVE.L     A0,40(A1)
20F6: 508F          MOVE.B     A7,(A0)
20F8: 5245          MOVEA.B    D5,A1
20FA: 45EA0042      LEA        66(A2),A2
20FE: BA6DCF04      MOVEA.W    -12540(A5),A5
2102: 6DC4          BLT.S      $20C8
2104: 4AADF8E4      TST.L      -1820(A5)
2108: 6714          BEQ.S      $211E
210A: 2F2DF8E8      MOVE.L     -1816(A5),-(A7)                ; A5-1816
210E: 3F3CFFFF      MOVE.W     #$FFFF,-(A7)
2112: 2F2DF8E4      MOVE.L     -1820(A5),-(A7)                ; A5-1820
2116: 4EAD0D9A      JSR        3482(A5)                       ; JT[3482]
211A: 4FEF000A      LEA        10(A7),A7
211E: 486DF7DC      PEA        -2084(A5)                      ; A5-2084
2122: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
2126: 4EAD0972      JSR        2418(A5)                       ; JT[2418]
212A: 486DF7DC      PEA        -2084(A5)                      ; A5-2084
212E: 486D0A12      PEA        2578(A5)                       ; A5+2578
2132: 2F0C          MOVE.L     A4,-(A7)
2134: 486EFED4      PEA        -300(A6)
2138: 4EAD0A32      JSR        2610(A5)                       ; JT[2610]
213C: 2E8C          MOVE.L     A4,(A7)
213E: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
2142: 4257          CLR.W      (A7)
2144: 2F0C          MOVE.L     A4,-(A7)
2146: 486EFED4      PEA        -300(A6)
214A: 4EAD0942      JSR        2370(A5)                       ; JT[2370]
214E: 486DF7DC      PEA        -2084(A5)                      ; A5-2084
2152: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
2156: 486EFFDC      PEA        -36(A6)
215A: 4EAD08FA      JSR        2298(A5)                       ; JT[2298]
215E: 2EADCF24      MOVE.L     -12508(A5),(A7)                ; A5-12508
2162: 4EBAF368      JSR        -3224(PC)
2166: 2B40F874      MOVE.L     D0,-1932(A5)
216A: 486EFFDC      PEA        -36(A6)
216E: 4EAD0902      JSR        2306(A5)                       ; JT[2306]
2172: 2E8C          MOVE.L     A4,(A7)
2174: 4EAD094A      JSR        2378(A5)                       ; JT[2378]
2178: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
217C: 204D          MOVEA.L    A5,A0
217E: 48C0          EXT.L      D0
2180: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
2184: 70FF          MOVEQ      #-1,D0
2186: D06899D8      MOVEA.B    -26152(A0),A0
218A: 4640          NOT.W      D0
218C: 3E80          MOVE.W     D0,(A7)
218E: 486EFF5C      PEA        -164(A6)
2192: 4267          CLR.W      -(A7)
2194: 486ECF02      PEA        -12542(A6)
2198: 486ECD98      PEA        -12904(A6)
219C: 4EBAF572      JSR        -2702(PC)
21A0: 3B40F7F4      MOVE.W     D0,-2060(A5)
21A4: 4A6DF7D4      TST.W      -2092(A5)
21A8: 4FEF0036      LEA        54(A7),A7
21AC: 6742          BEQ.S      $21F0
21AE: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
21B2: 204D          MOVEA.L    A5,A0
21B4: 48C0          EXT.L      D0
21B6: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
21BA: 70FF          MOVEQ      #-1,D0
21BC: D06899D8      MOVEA.B    -26152(A0),A0
21C0: 322DF7D4      MOVE.W     -2092(A5),D1                   ; A5-2092
21C4: 48C1          EXT.L      D1
21C6: E989204D      MOVE.L     A1,77(A4,D2.W)
21CA: D1C1C068      MOVE.B     D1,$C068.W
21CE: B3F446403F00486E  MOVE.W     64(A4,D4.W*8),$3F00486E
21D6: FF5C3F2D      MOVE.W     (A4)+,16173(A7)
21DA: F7F4486ECF02  MOVE.W     110(A4,D4.L),2(PC,A4.L)
21E0: 486ECD98      PEA        -12904(A6)
21E4: 4EBAF52A      JSR        -2774(PC)
21E8: 3B40F7F4      MOVE.W     D0,-2060(A5)
21EC: 4FEF0010      LEA        16(A7),A7
21F0: 4A6DF7D6      TST.W      -2090(A5)
21F4: 6742          BEQ.S      $2238
21F6: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
21FA: 204D          MOVEA.L    A5,A0
21FC: 48C0          EXT.L      D0
21FE: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
2202: 70FF          MOVEQ      #-1,D0
2204: D06899D8      MOVEA.B    -26152(A0),A0
2208: 322DF7D6      MOVE.W     -2090(A5),D1                   ; A5-2090
220C: 48C1          EXT.L      D1
220E: E989204D      MOVE.L     A1,77(A4,D2.W)
2212: D1C1C068      MOVE.B     D1,$C068.W
2216: B3F446403F00486E  MOVE.W     64(A4,D4.W*8),$3F00486E
221E: FF5C3F2D      MOVE.W     (A4)+,16173(A7)
2222: F7F4486ECF02  MOVE.W     110(A4,D4.L),2(PC,A4.L)
2228: 486ECD98      PEA        -12904(A6)
222C: 4EBAF4E2      JSR        -2846(PC)
2230: 3B40F7F4      MOVE.W     D0,-2060(A5)
2234: 4FEF0010      LEA        16(A7),A7
2238: 4A6DF7D8      TST.W      -2088(A5)
223C: 6742          BEQ.S      $2280
223E: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
2242: 204D          MOVEA.L    A5,A0
2244: 48C0          EXT.L      D0
2246: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
224A: 70FF          MOVEQ      #-1,D0
224C: D06899D8      MOVEA.B    -26152(A0),A0
2250: 322DF7D8      MOVE.W     -2088(A5),D1                   ; A5-2088
2254: 48C1          EXT.L      D1
2256: E989204D      MOVE.L     A1,77(A4,D2.W)
225A: D1C1C068      MOVE.B     D1,$C068.W
225E: B3F446403F00486E  MOVE.W     64(A4,D4.W*8),$3F00486E
2266: FF5C3F2D      MOVE.W     (A4)+,16173(A7)
226A: F7F4486ECF02  MOVE.W     110(A4,D4.L),2(PC,A4.L)
2270: 486ECD98      PEA        -12904(A6)
2274: 4EBAF49A      JSR        -2918(PC)
2278: 3B40F7F4      MOVE.W     D0,-2060(A5)
227C: 4FEF0010      LEA        16(A7),A7
2280: 4A6DF7DA      TST.W      -2086(A5)
2284: 6742          BEQ.S      $22C8
2286: 302DF7D2      MOVE.W     -2094(A5),D0                   ; A5-2094
228A: 204D          MOVEA.L    A5,A0
228C: 48C0          EXT.L      D0
228E: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
2292: 70FF          MOVEQ      #-1,D0
2294: D06899D8      MOVEA.B    -26152(A0),A0
2298: 322DF7DA      MOVE.W     -2086(A5),D1                   ; A5-2086
229C: 48C1          EXT.L      D1
229E: E989204D      MOVE.L     A1,77(A4,D2.W)
22A2: D1C1C068      MOVE.B     D1,$C068.W
22A6: B3F446403F00486E  MOVE.W     64(A4,D4.W*8),$3F00486E
22AE: FF5C3F2D      MOVE.W     (A4)+,16173(A7)
22B2: F7F4486ECF02  MOVE.W     110(A4,D4.L),2(PC,A4.L)
22B8: 486ECD98      PEA        -12904(A6)
22BC: 4EBAF452      JSR        -2990(PC)
22C0: 3B40F7F4      MOVE.W     D0,-2060(A5)
22C4: 4FEF0010      LEA        16(A7),A7
22C8: 2F2DF870      MOVE.L     -1936(A5),-(A7)                ; A5-1936
22CC: 486EFF5C      PEA        -164(A6)
22D0: 3F2DF7F4      MOVE.W     -2060(A5),-(A7)                ; A5-2060
22D4: 486ECF02      PEA        -12542(A6)
22D8: 486ECD98      PEA        -12904(A6)
22DC: 4EBAF3F0      JSR        -3088(PC)
22E0: 3B40F7F4      MOVE.W     D0,-2060(A5)
22E4: 2EADF874      MOVE.L     -1932(A5),(A7)                 ; A5-1932
22E8: 486EFF5C      PEA        -164(A6)
22EC: 3F00          MOVE.W     D0,-(A7)
22EE: 486ECF02      PEA        -12542(A6)
22F2: 486ECD98      PEA        -12904(A6)
22F6: 4EBAF3D6      JSR        -3114(PC)
22FA: 3B40F7F4      MOVE.W     D0,-2060(A5)
22FE: 2EADF870      MOVE.L     -1936(A5),(A7)                 ; A5-1936
2302: 2F2DA548      MOVE.L     -23224(A5),-(A7)               ; A5-23224
2306: 3F00          MOVE.W     D0,-(A7)
2308: 486ECD98      PEA        -12904(A6)
230C: 4EBAF47E      JSR        -2946(PC)
2310: 2440          MOVEA.L    D0,A2
2312: 2EADF874      MOVE.L     -1932(A5),(A7)                 ; A5-1932
2316: 2F0A          MOVE.L     A2,-(A7)
2318: 3F2DF7F4      MOVE.W     -2060(A5),-(A7)                ; A5-2060
231C: 486ECD98      PEA        -12904(A6)
2320: 4EBAF46A      JSR        -2966(PC)
2324: 2440          MOVEA.L    D0,A2
2326: 2E8C          MOVE.L     A4,(A7)
2328: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
232C: 4EAD0972      JSR        2418(A5)                       ; JT[2418]
2330: 4FEF0034      LEA        52(A7),A7
2334: 6004          BRA.S      $233A
2336: 42ADF874      CLR.L      -1932(A5)
233A: 3B43CF04      MOVE.W     D3,-12540(A5)
233E: 486EFED4      PEA        -300(A6)
2342: 4EBAF2FA      JSR        -3334(PC)
2346: 486EFED4      PEA        -300(A6)
234A: 4EBAEDEA      JSR        -4630(PC)
234E: 48780080      PEA        $0080.W
2352: 486DCE84      PEA        -12668(A5)                     ; A5-12668
2356: 4EAD01AA      JSR        426(A5)                        ; JT[426]
235A: 4FEF0010      LEA        16(A7),A7
235E: 5243          MOVEA.B    D3,A1
2360: 47EB0022      LEA        34(A3),A3
2364: B843          MOVEA.W    D3,A4
2366: 6E00FD14      BGT.W      $207E
236A: 4AADF8E4      TST.L      -1820(A5)
236E: 670E          BEQ.S      $237E
2370: 2F2DF8E4      MOVE.L     -1820(A5),-(A7)                ; A5-1820
2374: 4EAD068A      JSR        1674(A5)                       ; JT[1674]
2378: 42ADF8E4      CLR.L      -1820(A5)
237C: 588F          MOVE.B     A7,(A4)
237E: 41EDA5F0      LEA        -23056(A5),A0                  ; g_dawg_?
2382: 2008          MOVE.L     A0,D0
2384: 4CEE1CF8CD32  MOVEM.L    -13006(A6),D3/D4/D5/D6/D7/A2/A3/A4
238A: 4E5E          UNLK       A6
238C: 4E75          RTS        
