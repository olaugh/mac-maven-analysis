;======================================================================
; CODE 30 Disassembly
; File: /tmp/maven_code_30.bin
; Header: JT offset=2168, JT entries=12
; Code size: 3492 bytes
;======================================================================

0000: 202DF52E      MOVE.L     -2770(A5),D0                   ; A5-2770
0004: B0ADD134      MOVE.W     -11980(A5),(A0)                ; A5-11980
0008: 670A          BEQ.S      $0014
000A: 206DF52E      MOVEA.L    -2770(A5),A0
000E: 4A28001A      TST.B      26(A0)
0012: 6704          BEQ.S      $0018
0014: 7000          MOVEQ      #0,D0
0016: 6002          BRA.S      $001A
0018: 7001          MOVEQ      #1,D0
001A: 4E75          RTS        


; ======= Function at 0x001C =======
001C: 4E560000      LINK       A6,#0
0020: 2B6D9B68A222  MOVE.L     -25752(A5),-24030(A5)          ; A5-25752
0026: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
002C: C1EDA386      ANDA.L     -23674(A5),A0
0030: 41EDA226      LEA        -24026(A5),A0                  ; g_common
0034: D088          MOVE.B     A0,(A0)
0036: 2040          MOVEA.L    D0,A0
0038: 7001          MOVEQ      #1,D0
003A: 4A40          TST.W      D0
003C: 6602          BNE.S      $0040
003E: 7001          MOVEQ      #1,D0
0040: 4CD8          DC.W       $4CD8
0042: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
0046: 4E5E          UNLK       A6
0048: 4E75          RTS        


; ======= Function at 0x004A =======
004A: 4E560000      LINK       A6,#0
004E: 2F07          MOVE.L     D7,-(A7)
0050: 7E00          MOVEQ      #0,D7
0052: 2F2E0008      MOVE.L     8(A6),-(A7)
0056: 4EAD0AFA      JSR        2810(A5)                       ; JT[2810]
005A: 3B7C007FA60E  MOVE.W     #$007F,-23026(A5)
0060: 0C6D0008A386  CMPI.W     #$0008,-23674(A5)
0066: 588F          MOVE.B     A7,(A4)
0068: 6406          BCC.S      $0070
006A: 4A6DA386      TST.W      -23674(A5)
006E: 6C04          BGE.S      $0074
0070: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0074: 302DA386      MOVE.W     -23674(A5),D0                  ; A5-23674
0078: 526DA386      MOVEA.B    -23674(A5),A1
007C: C1FC002C41ED  ANDA.L     #$002C41ED,A0
0082: A226          MOVE.L     -(A6),D1
0084: D088          MOVE.B     A0,(A0)
0086: 2040          MOVEA.L    D0,A0
0088: 7000          MOVEQ      #0,D0
008A: 43FA0006      LEA        6(PC),A1
008E: 48D0          DC.W       $48D0
0090: DEF84A40      MOVE.B     $4A40.W,(A7)+
0094: 6610          BNE.S      $00A6
0096: 486D08D2      PEA        2258(A5)                       ; A5+2258
009A: 4EAD0A3A      JSR        2618(A5)                       ; JT[2618]
009E: 536DA386588F  MOVE.B     -23674(A5),22671(A1)           ; A5-23674
00A4: 6046          BRA.S      $00EC
00A6: 2F2DA222      MOVE.L     -24030(A5),-(A7)               ; A5-24030
00AA: 2F2D9B68      MOVE.L     -25752(A5),-(A7)               ; A5-25752
00AE: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
00B2: 4A40          TST.W      D0
00B4: 508F          MOVE.B     A7,(A0)
00B6: 6604          BNE.S      $00BC
00B8: 7E01          MOVEQ      #1,D7
00BA: 6030          BRA.S      $00EC
00BC: 4A6DA386      TST.W      -23674(A5)
00C0: 6E04          BGT.S      $00C6
00C2: 4EAD01A2      JSR        418(A5)                        ; JT[418]
00C6: 2B6DA222A222  MOVE.L     -24030(A5),-24030(A5)          ; A5-24030
00CC: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
00D2: C1EDA386      ANDA.L     -23674(A5),A0
00D6: 41EDA226      LEA        -24026(A5),A0                  ; g_common
00DA: D088          MOVE.B     A0,(A0)
00DC: 2040          MOVEA.L    D0,A0
00DE: 7001          MOVEQ      #1,D0
00E0: 4A40          TST.W      D0
00E2: 6602          BNE.S      $00E6
00E4: 7001          MOVEQ      #1,D0
00E6: 4CD8          DC.W       $4CD8
00E8: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
00EC: 3007          MOVE.W     D7,D0
00EE: 2E1F          MOVE.L     (A7)+,D7
00F0: 4E5E          UNLK       A6
00F2: 4E75          RTS        

00F4: 2F07          MOVE.L     D7,-(A7)
00F6: 4AADD134      TST.L      -11980(A5)
00FA: 6604          BNE.S      $0100
00FC: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0100: 202DD138      MOVE.L     -11976(A5),D0                  ; A5-11976
0104: EB882F00      MOVE.L     A0,0(A5,D2.L*8)
0108: 2F2DD134      MOVE.L     -11980(A5),-(A7)               ; A5-11980
010C: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0110: 3B7C0001F532  MOVE.W     #$0001,-2766(A5)
0116: 3E2DD13A      MOVE.W     -11974(A5),D7                  ; A5-11974
011A: 53472007      MOVE.B     D7,8199(A1)
011E: 48C0          EXT.L      D0
0120: EB88206D      MOVE.L     A0,109(A5,D2.W)
0124: D1344270      MOVE.B     112(A4,D4.W*2),-(A0)
0128: 0806508F      BTST       #20623,D6
012C: 6012          BRA.S      $0140
012E: 2007          MOVE.L     D7,D0
0130: 48C0          EXT.L      D0
0132: EB887201      MOVE.L     A0,1(A5,D7.W*2)
0136: D247          MOVEA.B    D7,A1
0138: 206DD134      MOVEA.L    -11980(A5),A0
013C: 31810806      MOVE.W     D1,6(A0,D0.L)
0140: 53474A47      MOVE.B     D7,19015(A1)
0144: 6CE8          BGE.S      $012E
0146: 2E1F          MOVE.L     (A7)+,D7
0148: 4E75          RTS        


; ======= Function at 0x014A =======
014A: 4E56F91A      LINK       A6,#-1766                      ; frame=1766
014E: 48E70738      MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)        ; save
0152: 41EEF926      LEA        -1754(A6),A0
0156: 43EDA5CE      LEA        -23090(A5),A1                  ; g_dawg_info
015A: 7007          MOVEQ      #7,D0
015C: 20D9          MOVE.L     (A1)+,(A0)+
015E: 51C8FFFC      DBF        D0,$015C                       ; loop
0162: 30D9          MOVE.W     (A1)+,(A0)+
0164: 426EF922      CLR.W      -1758(A6)
0168: 486EF91E      PEA        -1762(A6)
016C: 4EAD069A      JSR        1690(A5)                       ; JT[1690]
0170: 48780154      PEA        $0154.W
0174: 486DA5F0      PEA        -23056(A5)                     ; g_dawg_?
0178: 4EAD01AA      JSR        426(A5)                        ; JT[426]
017C: 2EAE0008      MOVE.L     8(A6),(A7)
0180: 4EBAFEC8      JSR        -312(PC)
0184: 4A40          TST.W      D0
0186: 4FEF000C      LEA        12(A7),A7
018A: 6610          BNE.S      $019C
018C: 3B7C0001CF04  MOVE.W     #$0001,-12540(A5)
0192: 41EDA5F0      LEA        -23056(A5),A0                  ; g_dawg_?
0196: 2008          MOVE.L     A0,D0
0198: 600004C0      BRA.W      $065C
019C: 4EBA04C4      JSR        1220(PC)
01A0: 4EBAFF52      JSR        -174(PC)
01A4: 48780100      PEA        $0100.W
01A8: 486DBBF4      PEA        -17420(A5)                     ; A5-17420
01AC: 4EAD01AA      JSR        426(A5)                        ; JT[426]
01B0: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
01B4: B1EE0008508F  MOVE.W     8(A6),$508F.W
01BA: 670E          BEQ.S      $01CA
01BC: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
01C0: B1EE00086704  MOVE.W     8(A6),$6704.W
01C6: 4EAD01A2      JSR        418(A5)                        ; JT[418]
01CA: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
01CE: B1EE00086608  MOVE.W     8(A6),$6608.W
01D4: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
01D8: 2008          MOVE.L     A0,D0
01DA: 6006          BRA.S      $01E2
01DC: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
01E0: 2008          MOVE.L     A0,D0
01E2: 2840          MOVEA.L    D0,A4
01E4: 2F0C          MOVE.L     A4,-(A7)
01E6: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
01EA: 2E8C          MOVE.L     A4,(A7)
01EC: 4EAD0952      JSR        2386(A5)                       ; JT[2386]
01F0: 2EAE0008      MOVE.L     8(A6),(A7)
01F4: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
01F8: 2EAE0008      MOVE.L     8(A6),(A7)
01FC: 4EAD0952      JSR        2386(A5)                       ; JT[2386]
0200: 48780220      PEA        $0220.W
0204: 486DBCFE      PEA        -17154(A5)                     ; g_state1
0208: 486EFDCE      PEA        -562(A6)
020C: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0210: 48780440      PEA        $0440.W
0214: 486DBF1E      PEA        -16610(A5)                     ; g_state2
0218: 486EF98E      PEA        -1650(A6)
021C: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0220: 3D6DB3F2F924  MOVE.W     -19470(A5),-1756(A6)           ; A5-19470
0226: 246E0008      MOVEA.L    8(A6),A2
022A: 264C          MOVEA.L    A4,A3
022C: 2EAE0008      MOVE.L     8(A6),(A7)
0230: 486EFFF6      PEA        -10(A6)
0234: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0238: 2E8C          MOVE.L     A4,(A7)
023A: 486EFFEE      PEA        -18(A6)
023E: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0242: 2D6DD134F98A  MOVE.L     -11980(A5),-1654(A6)           ; A5-11980
0248: 0C6D0008A386  CMPI.W     #$0008,-23674(A5)
024E: 4FEF0024      LEA        36(A7),A7
0252: 6406          BCC.S      $025A
0254: 4A6DA386      TST.W      -23674(A5)
0258: 6C04          BGE.S      $025E
025A: 4EAD01A2      JSR        418(A5)                        ; JT[418]
025E: 302DA386      MOVE.W     -23674(A5),D0                  ; A5-23674
0262: 526DA386      MOVEA.B    -23674(A5),A1
0266: C1FC002C41ED  ANDA.L     #$002C41ED,A0
026C: A226          MOVE.L     -(A6),D1
026E: D088          MOVE.B     A0,(A0)
0270: 2040          MOVEA.L    D0,A0
0272: 7000          MOVEQ      #0,D0
0274: 43FA0006      LEA        6(PC),A1
0278: 48D0          DC.W       $48D0
027A: DEF84A40      MOVE.B     $4A40.W,(A7)+
027E: 6600030A      BNE.W      $058C
0282: 426EFFFE      CLR.W      -2(A6)
0286: 202EF98A      MOVE.L     -1654(A6),D0
028A: 2B40F52E      MOVE.L     D0,-2770(A5)
028E: 2D40F97A      MOVE.L     D0,-1670(A6)
0292: 6078          BRA.S      $030C
0294: 202DF52E      MOVE.L     -2770(A5),D0                   ; A5-2770
0298: B0ADD134      MOVE.W     -11980(A5),(A0)                ; A5-11980
029C: 6760          BEQ.S      $02FE
029E: 526EFFFE      MOVEA.B    -2(A6),A1
02A2: 0C6E00C8FFFE  CMPI.W     #$00C8,-2(A6)
02A8: 6D04          BLT.S      $02AE
02AA: 4EAD01A2      JSR        418(A5)                        ; JT[418]
02AE: 2D6DF52EF97A  MOVE.L     -2770(A5),-1670(A6)            ; A5-2770
02B4: 2F2E0008      MOVE.L     8(A6),-(A7)
02B8: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
02BC: 4EAD0982      JSR        2434(A5)                       ; JT[2434]
02C0: 2EADF52E      MOVE.L     -2770(A5),(A7)                 ; A5-2770
02C4: 486EF948      PEA        -1720(A6)
02C8: 4EBA0A04      JSR        2564(PC)
02CC: 4257          CLR.W      (A7)
02CE: 2F2E0008      MOVE.L     8(A6),-(A7)
02D2: 486EF948      PEA        -1720(A6)
02D6: 4EAD0942      JSR        2370(A5)                       ; JT[2370]
02DA: 3EAEF966      MOVE.W     -1690(A6),(A7)
02DE: 4EAD0992      JSR        2450(A5)                       ; JT[2450]
02E2: 2E80          MOVE.L     D0,(A7)
02E4: 2F2E0008      MOVE.L     8(A6),-(A7)
02E8: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
02EC: 2D6E0008F976  MOVE.L     8(A6),-1674(A6)
02F2: 2D4C0008      MOVE.L     A4,8(A6)
02F6: 286EF976      MOVEA.L    -1674(A6),A4
02FA: 4FEF0014      LEA        20(A7),A7
02FE: 2F2DF52E      MOVE.L     -2770(A5),-(A7)                ; A5-2770
0302: 4EBA05B6      JSR        1462(PC)
0306: 2B40F52E      MOVE.L     D0,-2770(A5)
030A: 588F          MOVE.B     A7,(A4)
030C: 4AADF52E      TST.L      -2770(A5)
0310: 6682          BNE.S      $0294
0312: 2B6EF97AF52E  MOVE.L     -1670(A6),-2770(A5)
0318: 202DF52E      MOVE.L     -2770(A5),D0                   ; A5-2770
031C: B0ADD134      MOVE.W     -11980(A5),(A0)                ; A5-11980
0320: 6510          BCS.S      $0332
0322: 202DD138      MOVE.L     -11976(A5),D0                  ; A5-11976
0326: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
032A: D134B0AD      MOVE.B     -83(A4,A3.W),-(A0)
032E: F52E6404      MOVE.W     25604(A6),-(A2)
0332: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0336: 2F0C          MOVE.L     A4,-(A7)
0338: 2F2E0008      MOVE.L     8(A6),-(A7)
033C: 4EAD0AF2      JSR        2802(A5)                       ; JT[2802]
0340: 2EADD134      MOVE.L     -11980(A5),(A7)                ; A5-11980
0344: 4EBA05DA      JSR        1498(PC)
0348: 2EADD134      MOVE.L     -11980(A5),(A7)                ; A5-11980
034C: 4EBA056C      JSR        1388(PC)
0350: 2D40F986      MOVE.L     D0,-1658(A6)
0354: 223CF4143E00  MOVE.L     #$F4143E00,D1
035A: 2D41F96A      MOVE.L     D1,-1686(A6)
035E: 2D41F972      MOVE.L     D1,-1678(A6)
0362: 2D41F96E      MOVE.L     D1,-1682(A6)
0366: 42AEF97E      CLR.L      -1666(A6)
036A: 42AEF982      CLR.L      -1662(A6)
036E: 206DD134      MOVEA.L    -11980(A5),A0
0372: 3E280004      MOVE.W     4(A0),D7
0376: 508F          MOVE.B     A7,(A0)
0378: 6064          BRA.S      $03DE
037A: 2007          MOVE.L     D7,D0
037C: 48C0          EXT.L      D0
037E: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
0382: D1342D40      MOVE.B     64(A4,D2.L*4),-(A0)
0386: F97A20403A28  MOVE.W     8256(PC),14888(A4)
038C: 000A48C5      ORI.B      #$48C5,A2
0390: 2C05          MOVE.L     D5,D6
0392: 2040          MOVEA.L    D0,A0
0394: 3050          MOVEA.W    (A0),A0
0396: 9C88          MOVE.B     A0,(A6)
0398: 2040          MOVEA.L    D0,A0
039A: 30680002      MOVEA.W    2(A0),A0
039E: 9A88          MOVE.B     A0,(A5)
03A0: B0AEF986      MOVE.W     -1658(A6),(A0)
03A4: 6710          BEQ.S      $03B6
03A6: BCAEF972      MOVE.W     -1678(A6),(A6)
03AA: 6F0A          BLE.S      $03B6
03AC: 2D6EF97AF97E  MOVE.L     -1670(A6),-1666(A6)
03B2: 2D46F972      MOVE.L     D6,-1678(A6)
03B6: BAAEF96E      MOVE.W     -1682(A6),(A5)
03BA: 6E0C          BGT.S      $03C8
03BC: BAAEF96E      MOVE.W     -1682(A6),(A5)
03C0: 6614          BNE.S      $03D6
03C2: BCAEF96A      MOVE.W     -1686(A6),(A6)
03C6: 6F0E          BLE.S      $03D6
03C8: 2D6EF97AF982  MOVE.L     -1670(A6),-1662(A6)
03CE: 2D45F96E      MOVE.L     D5,-1682(A6)
03D2: 2D46F96A      MOVE.L     D6,-1686(A6)
03D6: 206EF97A      MOVEA.L    -1670(A6),A0
03DA: 3E280006      MOVE.W     6(A0),D7
03DE: 4A47          TST.W      D7
03E0: 6698          BNE.S      $037A
03E2: 202EF986      MOVE.L     -1658(A6),D0
03E6: B0AEF982      MOVE.W     -1662(A6),(A0)
03EA: 6616          BNE.S      $0402
03EC: 202EF98A      MOVE.L     -1654(A6),D0
03F0: B0AEF986      MOVE.W     -1658(A6),(A0)
03F4: 660C          BNE.S      $0402
03F6: 4AAEF97E      TST.L      -1666(A6)
03FA: 6706          BEQ.S      $0402
03FC: 202EF97E      MOVE.L     -1666(A6),D0
0400: 6004          BRA.S      $0406
0402: 202EF986      MOVE.L     -1658(A6),D0
0406: 2D40F98A      MOVE.L     D0,-1654(A6)
040A: 48780220      PEA        $0220.W
040E: 486EFDCE      PEA        -562(A6)
0412: 486DBCFE      PEA        -17154(A5)                     ; g_state1
0416: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
041A: 48780440      PEA        $0440.W
041E: 486EF98E      PEA        -1650(A6)
0422: 486DBF1E      PEA        -16610(A5)                     ; g_state2
0426: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
042A: 2D4A0008      MOVE.L     A2,8(A6)
042E: 284B          MOVEA.L    A3,A4
0430: 486EFFF6      PEA        -10(A6)
0434: 2F2E0008      MOVE.L     8(A6),-(A7)
0438: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
043C: 486EFFEE      PEA        -18(A6)
0440: 2F0C          MOVE.L     A4,-(A7)
0442: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0446: 4A6EF922      TST.W      -1758(A6)
044A: 4FEF0028      LEA        40(A7),A7
044E: 6606          BNE.S      $0456
0450: 3D6DF534F922  MOVE.W     -2764(A5),-1758(A6)            ; A5-2764
0456: 302DF534      MOVE.W     -2764(A5),D0                   ; A5-2764
045A: D06EF922      MOVEA.B    -1758(A6),A0
045E: 3040          MOVEA.W    D0,A0
0460: B1EDD1386C5A  MOVE.W     -11976(A5),$6C5A.W             ; A5-11976
0466: 2F2EF91E      MOVE.L     -1762(A6),-(A7)
046A: 4EAD06A2      JSR        1698(A5)                       ; JT[1698]
046E: B0AE000C      MOVE.W     12(A6),(A0)
0472: 588F          MOVE.B     A7,(A4)
0474: 6C4A          BGE.S      $04C0
0476: 4AAEF97E      TST.L      -1666(A6)
047A: 6744          BEQ.S      $04C0
047C: 206EF986      MOVEA.L    -1658(A6),A0
0480: 4A680004      TST.W      4(A0)
0484: 660C          BNE.S      $0492
0486: 206EF986      MOVEA.L    -1658(A6),A0
048A: 4A28001C      TST.B      28(A0)
048E: 6700FDF2      BEQ.W      $0284
0492: 206EF986      MOVEA.L    -1658(A6),A0
0496: 30680002      MOVEA.W    2(A0),A0
049A: 226EF986      MOVEA.L    -1658(A6),A1
049E: 3269000A      MOVEA.W    10(A1),A1
04A2: 93C8206EF97E  MOVE.B     A0,$206EF97E
04A8: 3050          MOVEA.W    (A0),A0
04AA: 2D49F91A      MOVE.L     A1,-1766(A6)
04AE: 226EF97E      MOVEA.L    -1666(A6),A1
04B2: 3269000A      MOVEA.W    10(A1),A1
04B6: 93C8B3EEF91A  MOVE.B     A0,$B3EEF91A
04BC: 6E00FDC4      BGT.W      $0284
04C0: 2F2E0008      MOVE.L     8(A6),-(A7)
04C4: 4EAD0AFA      JSR        2810(A5)                       ; JT[2810]
04C8: 426DCF04      CLR.W      -12540(A5)
04CC: 42ADB3E2      CLR.L      -19486(A5)
04D0: 206DD134      MOVEA.L    -11980(A5),A0
04D4: 3E280004      MOVE.W     4(A0),D7
04D8: 588F          MOVE.B     A7,(A4)
04DA: 600000A0      BRA.W      $057E
04DE: 2007          MOVE.L     D7,D0
04E0: 48C0          EXT.L      D0
04E2: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
04E6: D1342D40      MOVE.B     64(A4,D2.L*4),-(A0)
04EA: F97A20403A28  MOVE.W     8256(PC),14888(A4)
04F0: 000A48C5      ORI.B      #$48C5,A2
04F4: 2C05          MOVE.L     D5,D6
04F6: 2040          MOVEA.L    D0,A0
04F8: 3050          MOVEA.W    (A0),A0
04FA: 9C88          MOVE.B     A0,(A6)
04FC: 2040          MOVEA.L    D0,A0
04FE: 30680002      MOVEA.W    2(A0),A0
0502: 9A88          MOVE.B     A0,(A5)
0504: 2F00          MOVE.L     D0,-(A7)
0506: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
050A: 4EBA07C2      JSR        1986(PC)
050E: 4A6EF924      TST.W      -1756(A6)
0512: 508F          MOVE.B     A7,(A0)
0514: 6734          BEQ.S      $054A
0516: 4A2DA5EE      TST.B      -23058(A5)
051A: 662E          BNE.S      $054A
051C: 2F0B          MOVE.L     A3,-(A7)
051E: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
0522: 3D40F91C      MOVE.W     D0,-1764(A6)
0526: 2E8A          MOVE.L     A2,(A7)
0528: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
052C: 322EF91C      MOVE.W     -1764(A6),D1
0530: 9240          MOVEA.B    D0,A1
0532: 3041          MOVEA.W    D1,A0
0534: 2B48A5DE      MOVE.L     A0,-23074(A5)
0538: 7064          MOVEQ      #100,D0
053A: 2E80          MOVE.L     D0,(A7)
053C: 2F2DA5DE      MOVE.L     -23074(A5),-(A7)               ; g_dawg_ptr
0540: 4EAD0042      JSR        66(A5)                         ; JT[66]
0544: 2B40A5DE      MOVE.L     D0,-23074(A5)
0548: 6018          BRA.S      $0562
054A: 206EF97A      MOVEA.L    -1670(A6),A0
054E: 7064          MOVEQ      #100,D0
0550: C1E80002      ANDA.L     2(A0),A0
0554: 4440          NEG.W      D0
0556: 3240          MOVEA.W    D0,A1
0558: 2B49A5E2      MOVE.L     A1,-23070(A5)
055C: 3050          MOVEA.W    (A0),A0
055E: 2B48A5E6      MOVE.L     A0,-23066(A5)
0562: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0566: 4EAD0912      JSR        2322(A5)                       ; JT[2322]
056A: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
056E: 4EAD0842      JSR        2114(A5)                       ; JT[2114]
0572: 508F          MOVE.B     A7,(A0)
0574: 206EF97A      MOVEA.L    -1670(A6),A0
0578: 3E280006      MOVE.W     6(A0),D7
057C: 4A47          TST.W      D7
057E: 6600FF5E      BNE.W      $04E0
0582: 536DA3866000  MOVE.B     -23674(A5),24576(A1)           ; A5-23674
0588: 00B02F2DA2222F2D  ORI.L      #$2F2DA222,45(A0,D2.L*8)
0590: 93AC4EAD0DB2  MOVE.B     20141(A4),-78(A1,D0.L*4)
0596: 4A40          TST.W      D0
0598: 508F          MOVE.B     A7,(A0)
059A: 666C          BNE.S      $0608
059C: 4EBA012E      JSR        302(PC)
05A0: 48780220      PEA        $0220.W
05A4: 486EFDCE      PEA        -562(A6)
05A8: 486DBCFE      PEA        -17154(A5)                     ; g_state1
05AC: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
05B0: 48780440      PEA        $0440.W
05B4: 486EF98E      PEA        -1650(A6)
05B8: 486DBF1E      PEA        -16610(A5)                     ; g_state2
05BC: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
05C0: 2D4A0008      MOVE.L     A2,8(A6)
05C4: 284B          MOVEA.L    A3,A4
05C6: 486EFFF6      PEA        -10(A6)
05CA: 2F2E0008      MOVE.L     8(A6),-(A7)
05CE: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
05D2: 486EFFEE      PEA        -18(A6)
05D6: 2F0C          MOVE.L     A4,-(A7)
05D8: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
05DC: 2B6D93ACA222  MOVE.L     -27732(A5),-24030(A5)          ; A5-27732
05E2: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
05E8: C1EDA386      ANDA.L     -23674(A5),A0
05EC: 41EDA226      LEA        -24026(A5),A0                  ; g_common
05F0: D088          MOVE.B     A0,(A0)
05F2: 2040          MOVEA.L    D0,A0
05F4: 7001          MOVEQ      #1,D0
05F6: 4A40          TST.W      D0
05F8: 6602          BNE.S      $05FC
05FA: 7001          MOVEQ      #1,D0
05FC: 4CD8          DC.W       $4CD8
05FE: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
0602: 4FEF0028      LEA        40(A7),A7
0606: 6030          BRA.S      $0638
0608: 4A6DA386      TST.W      -23674(A5)
060C: 6E04          BGT.S      $0612
060E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0612: 2B6DA222A222  MOVE.L     -24030(A5),-24030(A5)          ; A5-24030
0618: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
061E: C1EDA386      ANDA.L     -23674(A5),A0
0622: 41EDA226      LEA        -24026(A5),A0                  ; g_common
0626: D088          MOVE.B     A0,(A0)
0628: 2040          MOVEA.L    D0,A0
062A: 7001          MOVEQ      #1,D0
062C: 4A40          TST.W      D0
062E: 6602          BNE.S      $0632
0630: 7001          MOVEQ      #1,D0
0632: 4CD8          DC.W       $4CD8
0634: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
0638: 41EDA5CE      LEA        -23090(A5),A0                  ; g_dawg_info
063C: 43EEF926      LEA        -1754(A6),A1
0640: 7007          MOVEQ      #7,D0
0642: 20D9          MOVE.L     (A1)+,(A0)+
0644: 51C8FFFC      DBF        D0,$0642                       ; loop
0648: 30D9          MOVE.W     (A1)+,(A0)+
064A: 3B6EF924B3F2  MOVE.W     -1756(A6),-19470(A5)
0650: 4EBA007A      JSR        122(PC)
0654: 41EDA5F0      LEA        -23056(A5),A0                  ; g_dawg_?
0658: 2008          MOVE.L     A0,D0
065A: 4CDF1CE0      MOVEM.L    (SP)+,D5/D6/D7/A2/A3/A4        ; restore
065E: 4E5E          UNLK       A6
0660: 4E75          RTS        

0662: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
0666: 7E00          MOVEQ      #0,D7
0668: 49EDBF1E      LEA        -16610(A5),A4                  ; g_state2
066C: 6028          BRA.S      $0696
066E: 7C00          MOVEQ      #0,D6
0670: 264C          MOVEA.L    A4,A3
0672: 3446          MOVEA.W    D6,A2
0674: D5CA6012      MOVE.B     A2,24594(PC)
0678: 204B          MOVEA.L    A3,A0
067A: D1CA3010      MOVE.B     A2,$3010.W
067E: 48C0          EXT.L      D0
0680: 81FC00643080  ORA.L      #$00643080,A0
0686: 5246          MOVEA.B    D6,A1
0688: 548A          MOVE.B     A2,(A2)
068A: 0C460011      CMPI.W     #$0011,D6
068E: 65E8          BCS.S      $0678
0690: 5247          MOVEA.B    D7,A1
0692: 49EC0022      LEA        34(A4),A4
0696: 0C470020      CMPI.W     #$0020,D7
069A: 65D2          BCS.S      $066E
069C: 7E00          MOVEQ      #0,D7
069E: 49ED9412      LEA        -27630(A5),A4                  ; A5-27630
06A2: 600E          BRA.S      $06B2
06A4: 3014          MOVE.W     (A4),D0
06A6: 48C0          EXT.L      D0
06A8: 81FC00643880  ORA.L      #$00643880,A0
06AE: 5247          MOVEA.B    D7,A1
06B0: 548C          MOVE.B     A4,(A2)
06B2: 0C470080      CMPI.W     #$0080,D7
06B6: 65EC          BCS.S      $06A4
06B8: 302D9A56      MOVE.W     -26026(A5),D0                  ; A5-26026
06BC: 48C0          EXT.L      D0
06BE: 81FC00643B40  ORA.L      #$00643B40,A0
06C4: 9A56          MOVEA.B    (A6),A5
06C6: 4CDF1CC0      MOVEM.L    (SP)+,D6/D7/A2/A3/A4           ; restore
06CA: 4E75          RTS        

06CC: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
06D0: 7E00          MOVEQ      #0,D7
06D2: 49EDBF1E      LEA        -16610(A5),A4                  ; g_state2
06D6: 6024          BRA.S      $06FC
06D8: 7C00          MOVEQ      #0,D6
06DA: 264C          MOVEA.L    A4,A3
06DC: 3446          MOVEA.W    D6,A2
06DE: D5CA600E      MOVE.B     A2,24590(PC)
06E2: 204B          MOVEA.L    A3,A0
06E4: D1CA7064      MOVE.B     A2,$7064.W
06E8: C1D0          ANDA.L     (A0),A0
06EA: 3080          MOVE.W     D0,(A0)
06EC: 5246          MOVEA.B    D6,A1
06EE: 548A          MOVE.B     A2,(A2)
06F0: 0C460011      CMPI.W     #$0011,D6
06F4: 65EC          BCS.S      $06E2
06F6: 5247          MOVEA.B    D7,A1
06F8: 49EC0022      LEA        34(A4),A4
06FC: 0C470020      CMPI.W     #$0020,D7
0700: 65D6          BCS.S      $06D8
0702: 7E00          MOVEQ      #0,D7
0704: 49ED9412      LEA        -27630(A5),A4                  ; A5-27630
0708: 600A          BRA.S      $0714
070A: 7064          MOVEQ      #100,D0
070C: C1D4          ANDA.L     (A4),A0
070E: 3880          MOVE.W     D0,(A4)
0710: 5247          MOVEA.B    D7,A1
0712: 548C          MOVE.B     A4,(A2)
0714: 0C470080      CMPI.W     #$0080,D7
0718: 65F0          BCS.S      $070A
071A: 7064          MOVEQ      #100,D0
071C: C1ED9A56      ANDA.L     -26026(A5),A0
0720: 3B409A56      MOVE.W     D0,-26026(A5)
0724: 4CDF1CC0      MOVEM.L    (SP)+,D6/D7/A2/A3/A4           ; restore
0728: 4E75          RTS        


; ======= Function at 0x072A =======
072A: 4E560000      LINK       A6,#0
072E: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
0732: 286E0008      MOVEA.L    8(A6),A4
0736: 0C6E00020010  CMPI.W     #$0002,16(A6)
073C: 6604          BNE.S      $0742
073E: 7000          MOVEQ      #0,D0
0740: 6056          BRA.S      $0798
0742: 202C000C      MOVE.L     12(A4),D0
0746: B0AE000C      MOVE.W     12(A6),(A0)
074A: 6604          BNE.S      $0750
074C: 200C          MOVE.L     A4,D0
074E: 6048          BRA.S      $0798
0750: 3E2C0004      MOVE.W     4(A4),D7
0754: 7C01          MOVEQ      #1,D6
0756: DC6E0010      MOVEA.B    16(A6),A6
075A: 6036          BRA.S      $0792
075C: 2007          MOVE.L     D7,D0
075E: 48C0          EXT.L      D0
0760: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
0764: D1342840      MOVE.B     64(A4,D2.L),-(A0)
0768: 4A2C001A      TST.B      26(A4)
076C: 6604          BNE.S      $0772
076E: 3006          MOVE.W     D6,D0
0770: 6002          BRA.S      $0774
0772: 7000          MOVEQ      #0,D0
0774: 3F00          MOVE.W     D0,-(A7)
0776: 2F2E000C      MOVE.L     12(A6),-(A7)
077A: 2F0C          MOVE.L     A4,-(A7)
077C: 4EBAFFAC      JSR        -84(PC)
0780: 2640          MOVEA.L    D0,A3
0782: 200B          MOVE.L     A3,D0
0784: 4FEF000A      LEA        10(A7),A7
0788: 6704          BEQ.S      $078E
078A: 200B          MOVE.L     A3,D0
078C: 600A          BRA.S      $0798
078E: 3E2C0006      MOVE.W     6(A4),D7
0792: 4A47          TST.W      D7
0794: 66C6          BNE.S      $075C
0796: 7000          MOVEQ      #0,D0
0798: 4CDF18C0      MOVEM.L    (SP)+,D6/D7/A3/A4              ; restore
079C: 4E5E          UNLK       A6
079E: 4E75          RTS        


; ======= Function at 0x07A0 =======
07A0: 4E56FFFC      LINK       A6,#-4                         ; frame=4
07A4: 2F0C          MOVE.L     A4,-(A7)
07A6: 4EBA039A      JSR        922(PC)
07AA: 2840          MOVEA.L    D0,A4
07AC: 200C          MOVE.L     A4,D0
07AE: 6738          BEQ.S      $07E8
07B0: 197C007F0019  MOVE.B     #$7F,25(A4)
07B6: 2F0C          MOVE.L     A4,-(A7)
07B8: 2F2DF52E      MOVE.L     -2770(A5),-(A7)                ; A5-2770
07BC: 4EBA03FA      JSR        1018(PC)
07C0: 206DF52E      MOVEA.L    -2770(A5),A0
07C4: 30280002      MOVE.W     2(A0),D0
07C8: 4440          NEG.W      D0
07CA: 3880          MOVE.W     D0,(A4)
07CC: 206DF52E      MOVEA.L    -2770(A5),A0
07D0: 3010          MOVE.W     (A0),D0
07D2: 4440          NEG.W      D0
07D4: 39400002      MOVE.W     D0,2(A4)
07D8: 206DF52E      MOVEA.L    -2770(A5),A0
07DC: 4A680004      TST.W      4(A0)
07E0: 508F          MOVE.B     A7,(A0)
07E2: 6604          BNE.S      $07E8
07E4: 4EAD01A2      JSR        418(A5)                        ; JT[418]
07E8: 285F          MOVEA.L    (A7)+,A4
07EA: 4E5E          UNLK       A6
07EC: 4E75          RTS        

07EE: 206DF52E      MOVEA.L    -2770(A5),A0
07F2: 42680004      CLR.W      4(A0)
07F6: 4E75          RTS        


; ======= Function at 0x07F8 =======
07F8: 4E56FFF8      LINK       A6,#-8                         ; frame=8
07FC: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0800: 48780110      PEA        $0110.W
0804: 486DBCFE      PEA        -17154(A5)                     ; g_state1
0808: 4EAD0D72      JSR        3442(A5)                       ; JT[3442]
080C: 2D40FFFC      MOVE.L     D0,-4(A6)
0810: 2EAE000C      MOVE.L     12(A6),(A7)
0814: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0818: 2E80          MOVE.L     D0,(A7)
081A: 2F2E000C      MOVE.L     12(A6),-(A7)
081E: 4EAD0D72      JSR        3442(A5)                       ; JT[3442]
0822: 2D40FFF8      MOVE.L     D0,-8(A6)
0826: 2EAE0010      MOVE.L     16(A6),(A7)
082A: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
082E: 2E80          MOVE.L     D0,(A7)
0830: 2F2E0010      MOVE.L     16(A6),-(A7)
0834: 4EAD0D72      JSR        3442(A5)                       ; JT[3442]
0838: 2E2EFFF8      MOVE.L     -8(A6),D7
083C: DEAEFFFC      MOVE.B     -4(A6),(A7)
0840: D080          MOVE.B     D0,(A0)
0842: DE80          MOVE.B     D0,(A7)
0844: 4EAD0A22      JSR        2594(A5)                       ; JT[2594]
0848: 4A87          TST.L      D7
084A: 4FEF0010      LEA        16(A7),A7
084E: 6602          BNE.S      $0852
0850: 7E01          MOVEQ      #1,D7
0852: 4267          CLR.W      -(A7)
0854: 2F07          MOVE.L     D7,-(A7)
0856: 2F2DD134      MOVE.L     -11980(A5),-(A7)               ; A5-11980
085A: 4EBAFECE      JSR        -306(PC)
085E: 2840          MOVEA.L    D0,A4
0860: 200C          MOVE.L     A4,D0
0862: 4FEF000A      LEA        10(A7),A7
0866: 660C          BNE.S      $0874
0868: 206DF52E      MOVEA.L    -2770(A5),A0
086C: 2147000C      MOVE.L     D7,12(A0)
0870: 7000          MOVEQ      #0,D0
0872: 603E          BRA.S      $08B2
0874: 206DF52E      MOVEA.L    -2770(A5),A0
0878: 2147000C      MOVE.L     D7,12(A0)
087C: 206DF52E      MOVEA.L    -2770(A5),A0
0880: 316C00040004  MOVE.W     4(A4),4(A0)
0886: 206DF52E      MOVEA.L    -2770(A5),A0
088A: 316C00020002  MOVE.W     2(A4),2(A0)
0890: 206DF52E      MOVEA.L    -2770(A5),A0
0894: 3094          MOVE.W     (A4),(A0)
0896: 206DF52E      MOVEA.L    -2770(A5),A0
089A: 4A680004      TST.W      4(A0)
089E: 6610          BNE.S      $08B0
08A0: 206DF52E      MOVEA.L    -2770(A5),A0
08A4: 30280002      MOVE.W     2(A0),D0
08A8: B050          MOVEA.W    (A0),A0
08AA: 6704          BEQ.S      $08B0
08AC: 7000          MOVEQ      #0,D0
08AE: 6002          BRA.S      $08B2
08B0: 200C          MOVE.L     A4,D0
08B2: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
08B6: 4E5E          UNLK       A6
08B8: 4E75          RTS        


; ======= Function at 0x08BA =======
08BA: 4E560000      LINK       A6,#0
08BE: 48E70738      MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)        ; save
08C2: 286E0008      MOVEA.L    8(A6),A4
08C6: B9EDD1346706  MOVE.W     -11980(A5),#$6706              ; A5-11980
08CC: 4A2C0010      TST.B      16(A4)
08D0: 6704          BEQ.S      $08D6
08D2: 7E00          MOVEQ      #0,D7
08D4: 6002          BRA.S      $08D8
08D6: 7E01          MOVEQ      #1,D7
08D8: 2C3CF4143E00  MOVE.L     #$F4143E00,D6
08DE: 97CB3A2C      MOVE.B     A3,44(PC,D3.L)
08E2: 0004602C      ORI.B      #$602C,D4
08E6: 2005          MOVE.L     D5,D0
08E8: 48C0          EXT.L      D0
08EA: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
08EE: D1342440      MOVE.B     64(A4,D2.W*4),-(A0)
08F2: 3A2A000A      MOVE.W     10(A2),D5
08F6: 48C5          EXT.L      D5
08F8: 3052          MOVEA.W    (A2),A0
08FA: 9A88          MOVE.B     A0,(A5)
08FC: BC85          MOVE.W     D5,(A6)
08FE: 6C0E          BGE.S      $090E
0900: 4A47          TST.W      D7
0902: 6706          BEQ.S      $090A
0904: 4A2A0010      TST.B      16(A2)
0908: 6704          BEQ.S      $090E
090A: 2C05          MOVE.L     D5,D6
090C: 264A          MOVEA.L    A2,A3
090E: 3A2A0006      MOVE.W     6(A2),D5
0912: 4A45          TST.W      D5
0914: 66D0          BNE.S      $08E6
0916: 200B          MOVE.L     A3,D0
0918: 4CDF1CE0      MOVEM.L    (SP)+,D5/D6/D7/A2/A3/A4        ; restore
091C: 4E5E          UNLK       A6
091E: 4E75          RTS        


; ======= Function at 0x0920 =======
0920: 4E560000      LINK       A6,#0
0924: 48E71F18      MOVEM.L    D3/D4/D5/D6/D7/A3/A4,-(SP)     ; save
0928: 286E0008      MOVEA.L    8(A6),A4
092C: B9EDD134650E  MOVE.W     -11980(A5),#$650E              ; A5-11980
0932: 202DD138      MOVE.L     -11976(A5),D0                  ; A5-11976
0936: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
093A: D134B08C      MOVE.B     -116(A4,A3.W),-(A0)
093E: 6204          BHI.S      $0944
0940: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0944: 3E2C0004      MOVE.W     4(A4),D7
0948: 6770          BEQ.S      $09BA
094A: 4A2C001E      TST.B      30(A4)
094E: 666A          BNE.S      $09BA
0950: 197C0001001E  MOVE.B     #$01,30(A4)
0956: 2A3CF4143E00  MOVE.L     #$F4143E00,D5
095C: 2C05          MOVE.L     D5,D6
095E: 6044          BRA.S      $09A4
0960: 2007          MOVE.L     D7,D0
0962: 48C0          EXT.L      D0
0964: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
0968: D1342640      MOVE.B     64(A4,D2.W*8),-(A0)
096C: BE6B0006      MOVEA.W    6(A3),A7
0970: 6604          BNE.S      $0976
0972: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0976: 2F0B          MOVE.L     A3,-(A7)
0978: 4EBAFFA6      JSR        -90(PC)
097C: 3E2B000A      MOVE.W     10(A3),D7
0980: 2807          MOVE.L     D7,D4
0982: 48C4          EXT.L      D4
0984: 3053          MOVEA.W    (A3),A0
0986: 9888          MOVE.B     A0,(A4)
0988: 2607          MOVE.L     D7,D3
098A: 48C3          EXT.L      D3
098C: 306B0002      MOVEA.W    2(A3),A0
0990: 9688          MOVE.B     A0,(A3)
0992: BC84          MOVE.W     D4,(A6)
0994: 588F          MOVE.B     A7,(A4)
0996: 6C02          BGE.S      $099A
0998: 2C04          MOVE.L     D4,D6
099A: BA83          MOVE.W     D3,(A5)
099C: 6C02          BGE.S      $09A0
099E: 2A03          MOVE.L     D3,D5
09A0: 3E2B0006      MOVE.W     6(A3),D7
09A4: 4A47          TST.W      D7
09A6: 66B8          BNE.S      $0960
09A8: BA86          MOVE.W     D6,(A5)
09AA: 6F04          BLE.S      $09B0
09AC: 4EAD01A2      JSR        418(A5)                        ; JT[418]
09B0: 39460002      MOVE.W     D6,2(A4)
09B4: 3885          MOVE.W     D5,(A4)
09B6: 422C001E      CLR.B      30(A4)
09BA: 4CDF18F8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A3/A4     ; restore
09BE: 4E5E          UNLK       A6
09C0: 4E75          RTS        


; ======= Function at 0x09C2 =======
09C2: 4E560000      LINK       A6,#0
09C6: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
09CA: 286E0008      MOVEA.L    8(A6),A4
09CE: B9EDF52E6700  MOVE.W     -2770(A5),#$6700               ; A5-2770
09D4: 00BC4A2C001E67044EAD  ORI.L      #$4A2C001E,#$67044EAD
09DE: 01A2          BCLR       D0,-(A2)
09E0: 197C0001001E  MOVE.B     #$01,30(A4)
09E6: 4A2C001C      TST.B      28(A4)
09EA: 670A          BEQ.S      $09F6
09EC: 4A6C0004      TST.W      4(A4)
09F0: 6704          BEQ.S      $09F6
09F2: 4EAD01A2      JSR        418(A5)                        ; JT[418]
09F6: 2E3CF4143E00  MOVE.L     #$F4143E00,D7
09FC: 3C2C0004      MOVE.W     4(A4),D6
0A00: 6022          BRA.S      $0A24
0A02: 2006          MOVE.L     D6,D0
0A04: 48C0          EXT.L      D0
0A06: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
0A0A: D1342640      MOVE.B     64(A4,D2.W*8),-(A0)
0A0E: 3A2B000A      MOVE.W     10(A3),D5
0A12: 48C5          EXT.L      D5
0A14: 306B0002      MOVEA.W    2(A3),A0
0A18: 9A88          MOVE.B     A0,(A5)
0A1A: BE85          MOVE.W     D5,(A7)
0A1C: 6C02          BGE.S      $0A20
0A1E: 2E05          MOVE.L     D5,D7
0A20: 3C2B0006      MOVE.W     6(A3),D6
0A24: 4A46          TST.W      D6
0A26: 66DA          BNE.S      $0A02
0A28: 45EC0004      LEA        4(A4),A2
0A2C: 605A          BRA.S      $0A88
0A2E: 2006          MOVE.L     D6,D0
0A30: 48C0          EXT.L      D0
0A32: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
0A36: D1342640      MOVE.B     64(A4,D2.W*8),-(A0)
0A3A: 3A2B000A      MOVE.W     10(A3),D5
0A3E: 48C5          EXT.L      D5
0A40: 3813          MOVE.W     (A3),D4
0A42: 3044          MOVEA.W    D4,A0
0A44: 9A88          MOVE.B     A0,(A5)
0A46: BE85          MOVE.W     D5,(A7)
0A48: 6E0C          BGT.S      $0A56
0A4A: BE85          MOVE.W     D5,(A7)
0A4C: 6622          BNE.S      $0A70
0A4E: 3013          MOVE.W     (A3),D0
0A50: B06B0002      MOVEA.W    2(A3),A0
0A54: 671A          BEQ.S      $0A70
0A56: 3A2B0006      MOVE.W     6(A3),D5
0A5A: 4A45          TST.W      D5
0A5C: 6D08          BLT.S      $0A66
0A5E: 3045          MOVEA.W    D5,A0
0A60: B1EDD1386D04  MOVE.W     -11976(A5),$6D04.W             ; A5-11976
0A66: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0A6A: 34AB0006      MOVE.W     6(A3),(A2)
0A6E: 6018          BRA.S      $0A88
0A70: B86B0002      MOVEA.W    2(A3),A4
0A74: 6606          BNE.S      $0A7C
0A76: 426B0004      CLR.W      4(A3)
0A7A: 6008          BRA.S      $0A84
0A7C: 2F0B          MOVE.L     A3,-(A7)
0A7E: 4EBAFF42      JSR        -190(PC)
0A82: 588F          MOVE.B     A7,(A4)
0A84: 45EB0006      LEA        6(A3),A2
0A88: 3C12          MOVE.W     (A2),D6
0A8A: 66A2          BNE.S      $0A2E
0A8C: 422C001E      CLR.B      30(A4)
0A90: 4CDF1CF0      MOVEM.L    (SP)+,D4/D5/D6/D7/A2/A3/A4     ; restore
0A94: 4E5E          UNLK       A6
0A96: 4E75          RTS        


; ======= Function at 0x0A98 =======
0A98: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0A9C: 48780020      PEA        $0020.W
0AA0: 2F2E0008      MOVE.L     8(A6),-(A7)
0AA4: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0AA8: 206E0008      MOVEA.L    8(A6),A0
0AAC: 316DF5320006  MOVE.W     -2766(A5),6(A0)                ; A5-2766
0AB2: 91EDD1342008  MOVE.B     -11980(A5),$2008.W             ; A5-11980
0AB8: EA80          MOVE.L     D0,(A5)
0ABA: 3B40F532      MOVE.W     D0,-2766(A5)
0ABE: 4E5E          UNLK       A6
0AC0: 4E75          RTS        

0AC2: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
0AC6: 202DD138      MOVE.L     -11976(A5),D0                  ; A5-11976
0ACA: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
0ACE: D1342840      MOVE.B     64(A4,D2.L),-(A0)
0AD2: 266DD134      MOVEA.L    -11980(A5),A3
0AD6: 6012          BRA.S      $0AEA
0AD8: 4A2B001E      TST.B      30(A3)
0ADC: 6608          BNE.S      $0AE6
0ADE: 2F0B          MOVE.L     A3,-(A7)
0AE0: 4EBAFFB6      JSR        -74(PC)
0AE4: 588F          MOVE.B     A7,(A4)
0AE6: 47EB0020      LEA        32(A3),A3
0AEA: B9CB62EA      MOVE.W     A3,#$62EA
0AEE: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
0AF2: 4E75          RTS        


; ======= Function at 0x0AF4 =======
0AF4: 4E560000      LINK       A6,#0
0AF8: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
0AFC: 3E2E000C      MOVE.W     12(A6),D7
0B00: 701E          MOVEQ      #30,D0
0B02: D0AE0008      MOVE.B     8(A6),(A0)
0B06: 2840          MOVEA.L    D0,A4
0B08: 1014          MOVE.B     (A4),D0
0B0A: 4880          EXT.W      D0
0B0C: BE40          MOVEA.W    D0,A7
0B0E: 672A          BEQ.S      $0B3A
0B10: 1887          MOVE.B     D7,(A4)
0B12: 206E0008      MOVEA.L    8(A6),A0
0B16: 3C280004      MOVE.W     4(A0),D6
0B1A: 601A          BRA.S      $0B36
0B1C: 2006          MOVE.L     D6,D0
0B1E: 48C0          EXT.L      D0
0B20: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
0B24: D1342640      MOVE.B     64(A4,D2.W*8),-(A0)
0B28: 3F07          MOVE.W     D7,-(A7)
0B2A: 2F0B          MOVE.L     A3,-(A7)
0B2C: 4EBAFFC6      JSR        -58(PC)
0B30: 5C8F          MOVE.B     A7,(A6)
0B32: 3C2B0006      MOVE.W     6(A3),D6
0B36: 4A46          TST.W      D6
0B38: 66E2          BNE.S      $0B1C
0B3A: 4CDF18C0      MOVEM.L    (SP)+,D6/D7/A3/A4              ; restore
0B3E: 4E5E          UNLK       A6
0B40: 4E75          RTS        

0B42: 2F0C          MOVE.L     A4,-(A7)
0B44: 4A6DF532      TST.W      -2766(A5)
0B48: 6634          BNE.S      $0B7E
0B4A: 2F2DD134      MOVE.L     -11980(A5),-(A7)               ; A5-11980
0B4E: 4EBAFE72      JSR        -398(PC)
0B52: 3EBC0001      MOVE.W     #$0001,(A7)
0B56: 2F2DD134      MOVE.L     -11980(A5),-(A7)               ; A5-11980
0B5A: 4EBAFF98      JSR        -104(PC)
0B5E: 4EAD0A22      JSR        2594(A5)                       ; JT[2594]
0B62: 4EBAFF5E      JSR        -162(PC)
0B66: 4257          CLR.W      (A7)
0B68: 2F2DD134      MOVE.L     -11980(A5),-(A7)               ; A5-11980
0B6C: 4EBAFF86      JSR        -122(PC)
0B70: 4A6DF532      TST.W      -2766(A5)
0B74: 4FEF000C      LEA        12(A7),A7
0B78: 6604          BNE.S      $0B7E
0B7A: 7000          MOVEQ      #0,D0
0B7C: 6036          BRA.S      $0BB4
0B7E: 4A6DF532      TST.W      -2766(A5)
0B82: 6D0A          BLT.S      $0B8E
0B84: 306DF532      MOVEA.W    -2766(A5),A0
0B88: B1EDD1386D04  MOVE.W     -11976(A5),$6D04.W             ; A5-11976
0B8E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0B92: 302DF532      MOVE.W     -2766(A5),D0                   ; A5-2766
0B96: 48C0          EXT.L      D0
0B98: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
0B9C: D1342840      MOVE.B     64(A4,D2.L),-(A0)
0BA0: 3B6C0006F532  MOVE.W     6(A4),-2766(A5)
0BA6: 48780020      PEA        $0020.W
0BAA: 2F0C          MOVE.L     A4,-(A7)
0BAC: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0BB0: 200C          MOVE.L     A4,D0
0BB2: 508F          MOVE.B     A7,(A0)
0BB4: 285F          MOVEA.L    (A7)+,A4
0BB6: 4E75          RTS        


; ======= Function at 0x0BB8 =======
0BB8: 4E560000      LINK       A6,#0
0BBC: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
0BC0: 266E0008      MOVEA.L    8(A6),A3
0BC4: 246E000C      MOVEA.L    12(A6),A2
0BC8: 49EB0004      LEA        4(A3),A4
0BCC: 3E14          MOVE.W     (A4),D7
0BCE: 4A47          TST.W      D7
0BD0: 6D08          BLT.S      $0BDA
0BD2: 3047          MOVEA.W    D7,A0
0BD4: B1EDD1386D04  MOVE.W     -11976(A5),$6D04.W             ; A5-11976
0BDA: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0BDE: 3014          MOVE.W     (A4),D0
0BE0: 48C0          EXT.L      D0
0BE2: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
0BE6: D134B08A      MOVE.B     -118(A4,A3.W),-(A0)
0BEA: 6604          BNE.S      $0BF0
0BEC: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0BF0: 35540006      MOVE.W     (A4),6(A2)
0BF4: B5EDD134650E  MOVE.W     -11980(A5),25870(PC)           ; A5-11980
0BFA: 202DD138      MOVE.L     -11976(A5),D0                  ; A5-11976
0BFE: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
0C02: D134B08A      MOVE.B     -118(A4,A3.W),-(A0)
0C06: 6204          BHI.S      $0C0C
0C08: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0C0C: 200A          MOVE.L     A2,D0
0C0E: 90ADD134      MOVE.B     -11980(A5),(A0)                ; A5-11980
0C12: EA80          MOVE.L     D0,(A5)
0C14: 3880          MOVE.W     D0,(A4)
0C16: 4CDF1C80      MOVEM.L    (SP)+,D7/A2/A3/A4              ; restore
0C1A: 4E5E          UNLK       A6
0C1C: 4E75          RTS        


; ======= Function at 0x0C1E =======
0C1E: 4E560000      LINK       A6,#0
0C22: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
0C26: 266E0008      MOVEA.L    8(A6),A3
0C2A: 4EBAFF16      JSR        -234(PC)
0C2E: 2840          MOVEA.L    D0,A4
0C30: 200C          MOVE.L     A4,D0
0C32: 67000092      BEQ.W      $0CC8
0C36: 202E000C      MOVE.L     12(A6),D0
0C3A: B0AE0010      MOVE.W     16(A6),(A0)
0C3E: 6C04          BGE.S      $0C44
0C40: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0C44: 196B0017001D  MOVE.B     23(A3),29(A4)
0C4A: 196B001B0018  MOVE.B     27(A3),24(A4)
0C50: 196B001D001C  MOVE.B     29(A3),28(A4)
0C56: 396E000E0002  MOVE.W     14(A6),2(A4)
0C5C: 38AE0012      MOVE.W     18(A6),(A4)
0C60: 2F0C          MOVE.L     A4,-(A7)
0C62: 2F2DF52E      MOVE.L     -2770(A5),-(A7)                ; A5-2770
0C66: 4EBAFF50      JSR        -176(PC)
0C6A: 396B0012000A  MOVE.W     18(A3),10(A4)
0C70: 196B0020001A  MOVE.B     32(A3),26(A4)
0C76: 196B0021001B  MOVE.B     33(A3),27(A4)
0C7C: 196B001F0019  MOVE.B     31(A3),25(A4)
0C82: 102B0021      MOVE.B     33(A3),D0
0C86: 4880          EXT.W      D0
0C88: 1E2B0020      MOVE.B     32(A3),D7
0C8C: 4887          EXT.W      D7
0C8E: CFFC001141ED  ANDA.L     #$001141ED,A7
0C94: BCFE          MOVE.W     ???,(A6)+
0C96: DE88          MOVE.B     A0,(A7)
0C98: 3040          MOVEA.W    D0,A0
0C9A: DE88          MOVE.B     A0,(A7)
0C9C: 45EC0010      LEA        16(A4),A2
0CA0: 284B          MOVEA.L    A3,A4
0CA2: 508F          MOVE.B     A7,(A0)
0CA4: 600C          BRA.S      $0CB2
0CA6: 2047          MOVEA.L    D7,A0
0CA8: 5287          MOVE.B     D7,(A1)
0CAA: 4A10          TST.B      (A0)
0CAC: 6602          BNE.S      $0CB0
0CAE: 14D4          MOVE.B     (A4),(A2)+
0CB0: 528C          MOVE.B     A4,(A1)
0CB2: 4A14          TST.B      (A4)
0CB4: 66F0          BNE.S      $0CA6
0CB6: 4212          CLR.B      (A2)
0CB8: 206DF52E      MOVEA.L    -2770(A5),A0
0CBC: 4A680004      TST.W      4(A0)
0CC0: 6604          BNE.S      $0CC6
0CC2: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0CC6: 4CDF1C80      MOVEM.L    (SP)+,D7/A2/A3/A4              ; restore
0CCA: 4E5E          UNLK       A6
0CCC: 4E75          RTS        


; ======= Function at 0x0CCE =======
0CCE: 4E560000      LINK       A6,#0
0CD2: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
0CD6: 266E0008      MOVEA.L    8(A6),A3
0CDA: 246E000C      MOVEA.L    12(A6),A2
0CDE: 49EB0010      LEA        16(A3),A4
0CE2: 306A000A      MOVEA.W    10(A2),A0
0CE6: 2888          MOVE.L     A0,(A4)
0CE8: 48780064      PEA        $0064.W
0CEC: 2F14          MOVE.L     (A4),-(A7)
0CEE: 4EAD0042      JSR        66(A5)                         ; JT[66]
0CF2: 2880          MOVE.L     D0,(A4)
0CF4: 176A001A0020  MOVE.B     26(A2),32(A3)
0CFA: 176A001B0021  MOVE.B     27(A2),33(A3)
0D00: 102A0019      MOVE.B     25(A2),D0
0D04: 4880          EXT.W      D0
0D06: 3740001E      MOVE.W     D0,30(A3)
0D0A: 42AB0018      CLR.L      24(A3)
0D0E: 42AB0014      CLR.L      20(A3)
0D12: 102A001C      MOVE.B     28(A2),D0
0D16: 4880          EXT.W      D0
0D18: 3740001C      MOVE.W     D0,28(A3)
0D1C: 102B0021      MOVE.B     33(A3),D0
0D20: 4880          EXT.W      D0
0D22: 122B0020      MOVE.B     32(A3),D1
0D26: 4881          EXT.W      D1
0D28: C3FC001149ED  ANDA.L     #$001149ED,A1
0D2E: BCFE          MOVE.W     ???,(A6)+
0D30: D28C          MOVE.B     A4,(A1)
0D32: 3840          MOVEA.W    D0,A4
0D34: D28C          MOVE.B     A4,(A1)
0D36: 2841          MOVEA.L    D1,A4
0D38: 7E10          MOVEQ      #16,D7
0D3A: DE8A          MOVE.B     A2,(A7)
0D3C: 244B          MOVEA.L    A3,A2
0D3E: 600E          BRA.S      $0D4E
0D40: 1494          MOVE.B     (A4),(A2)
0D42: 6606          BNE.S      $0D4A
0D44: 2047          MOVEA.L    D7,A0
0D46: 5287          MOVE.B     D7,(A1)
0D48: 1490          MOVE.B     (A0),(A2)
0D4A: 528A          MOVE.B     A2,(A1)
0D4C: 528C          MOVE.B     A4,(A1)
0D4E: 2047          MOVEA.L    D7,A0
0D50: 4A10          TST.B      (A0)
0D52: 66EC          BNE.S      $0D40
0D54: 4A14          TST.B      (A4)
0D56: 66E8          BNE.S      $0D40
0D58: 4212          CLR.B      (A2)
0D5A: 4CDF1C80      MOVEM.L    (SP)+,D7/A2/A3/A4              ; restore
0D5E: 4E5E          UNLK       A6
0D60: 4E75          RTS        


; ======= Function at 0x0D62 =======
0D62: 4E560000      LINK       A6,#0
0D66: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0D6A: 206DF52E      MOVEA.L    -2770(A5),A0
0D6E: 3E280004      MOVE.W     4(A0),D7
0D72: 6024          BRA.S      $0D98
0D74: 2007          MOVE.L     D7,D0
0D76: 48C0          EXT.L      D0
0D78: EB88D0AD      MOVE.L     A0,-83(A5,A5.W)
0D7C: D1342840      MOVE.B     64(A4,D2.L),-(A0)
0D80: 2F0C          MOVE.L     A4,-(A7)
0D82: 206E0008      MOVEA.L    8(A6),A0
0D86: 4E90          JSR        (A0)
0D88: BE6C0006      MOVEA.W    6(A4),A7
0D8C: 588F          MOVE.B     A7,(A4)
0D8E: 6604          BNE.S      $0D94
0D90: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0D94: 3E2C0006      MOVE.W     6(A4),D7
0D98: 4A47          TST.W      D7
0D9A: 66D8          BNE.S      $0D74
0D9C: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
0DA0: 4E5E          UNLK       A6
0DA2: 4E75          RTS        
