;======================================================================
; CODE 11 Disassembly
; File: /tmp/maven_code_11.bin
; Header: JT offset=376, JT entries=19
; Code size: 4478 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 2F0C          MOVE.L     A4,-(A7)
0006: 286E0008      MOVEA.L    8(A6),A4
000A: 200C          MOVE.L     A4,D0
000C: 6608          BNE.S      $0016
000E: 41ED92F8      LEA        -27912(A5),A0                  ; A5-27912
0012: 2008          MOVE.L     A0,D0
0014: 603C          BRA.S      $0052
0016: 2F0C          MOVE.L     A4,-(A7)
0018: 4EAD064A      JSR        1610(A5)                       ; JT[1610]
001C: 4A40          TST.W      D0
001E: 588F          MOVE.B     A7,(A4)
0020: 6708          BEQ.S      $002A
0022: 41ED9308      LEA        -27896(A5),A0                  ; A5-27896
0026: 2008          MOVE.L     A0,D0
0028: 6028          BRA.S      $0052
002A: 0C6C0008006C  CMPI.W     #$0008,108(A4)
0030: 6C14          BGE.S      $0046
0032: 082C0001006D  BTST       #1,109(A4)
0038: 6712          BEQ.S      $004C
003A: 2F0C          MOVE.L     A4,-(A7)
003C: 4EBA010E      JSR        270(PC)
0040: 4A40          TST.W      D0
0042: 588F          MOVE.B     A7,(A4)
0044: 6706          BEQ.S      $004C
0046: 202C0098      MOVE.L     152(A4),D0
004A: 6006          BRA.S      $0052
004C: 41ED9308      LEA        -27896(A5),A0                  ; A5-27896
0050: 2008          MOVE.L     A0,D0
0052: 285F          MOVEA.L    (A7)+,A4
0054: 4E5E          UNLK       A6
0056: 4E75          RTS        


; ======= Function at 0x0058 =======
0058: 4E560000      LINK       A6,#0
005C: 2F0C          MOVE.L     A4,-(A7)
005E: 2F2E000C      MOVE.L     12(A6),-(A7)
0062: 2F2E0008      MOVE.L     8(A6),-(A7)
0066: 4EBA001E      JSR        30(PC)
006A: 2840          MOVEA.L    D0,A4
006C: 200C          MOVE.L     A4,D0
006E: 508F          MOVE.B     A7,(A0)
0070: 670C          BEQ.S      $007E
0072: 2F2E0010      MOVE.L     16(A6),-(A7)
0076: 2F2E0008      MOVE.L     8(A6),-(A7)
007A: 4E94          JSR        (A4)
007C: 508F          MOVE.B     A7,(A0)
007E: 7001          MOVEQ      #1,D0
0080: 285F          MOVEA.L    (A7)+,A4
0082: 4E5E          UNLK       A6
0084: 4E75          RTS        


; ======= Function at 0x0086 =======
0086: 4E560000      LINK       A6,#0
008A: 2F2E000C      MOVE.L     12(A6),-(A7)
008E: 2F2E0008      MOVE.L     8(A6),-(A7)
0092: 4EBAFF6C      JSR        -148(PC)
0096: 2E80          MOVE.L     D0,(A7)
0098: 4EBA0006      JSR        6(PC)
009C: 4E5E          UNLK       A6
009E: 4E75          RTS        


; ======= Function at 0x00A0 =======
00A0: 4E560000      LINK       A6,#0
00A4: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
00A8: 286E0008      MOVEA.L    8(A6),A4
00AC: 602A          BRA.S      $00D8
00AE: 3E2C0002      MOVE.W     2(A4),D7
00B2: 7C01          MOVEQ      #1,D6
00B4: 367C0008      MOVEA.W    #$0008,A3
00B8: 6016          BRA.S      $00D0
00BA: 244B          MOVEA.L    A3,A2
00BC: D5CC2012      MOVE.B     A4,8210(PC)
00C0: B0AE000C      MOVE.W     12(A6),(A0)
00C4: 6606          BNE.S      $00CC
00C6: 202A0004      MOVE.L     4(A2),D0
00CA: 6012          BRA.S      $00DE
00CC: 5246          MOVEA.B    D6,A1
00CE: 508B          MOVE.B     A3,(A0)
00D0: BE46          MOVEA.W    D6,A7
00D2: 6CE6          BGE.S      $00BA
00D4: 286C0004      MOVEA.L    4(A4),A4
00D8: 200C          MOVE.L     A4,D0
00DA: 66D2          BNE.S      $00AE
00DC: 7000          MOVEQ      #0,D0
00DE: 4CDF1CC0      MOVEM.L    (SP)+,D6/D7/A2/A3/A4           ; restore
00E2: 4E5E          UNLK       A6
00E4: 4E75          RTS        


; ======= Function at 0x00E6 =======
00E6: 4E560000      LINK       A6,#0
00EA: 42A7          CLR.L      -(A7)
00EC: 2F2E0008      MOVE.L     8(A6),-(A7)
00F0: A917          MOVE.L     (A7),-(A4)
00F2: 206E000C      MOVEA.L    12(A6),A0
00F6: 215F0004      MOVE.L     (A7)+,4(A0)
00FA: 2F2E0008      MOVE.L     8(A6),-(A7)
00FE: 2F08          MOVE.L     A0,-(A7)
0100: A918          MOVE.L     (A0)+,-(A4)
0102: 4E5E          UNLK       A6
0104: 4E75          RTS        


; ======= Function at 0x0106 =======
0106: 4E560000      LINK       A6,#0
010A: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
010E: 2F2E0008      MOVE.L     8(A6),-(A7)
0112: 4EBAFEEC      JSR        -276(PC)
0116: 2840          MOVEA.L    D0,A4
0118: 7E01          MOVEQ      #1,D7
011A: 367C0008      MOVEA.W    #$0008,A3
011E: 588F          MOVE.B     A7,(A4)
0120: 6018          BRA.S      $013A
0122: 244B          MOVEA.L    A3,A2
0124: D5CC2012      MOVE.B     A4,8210(PC)
0128: B0AE000C      MOVE.W     12(A6),(A0)
012C: 6608          BNE.S      $0136
012E: 256E00100004  MOVE.L     16(A6),4(A2)
0134: 600E          BRA.S      $0144
0136: 5247          MOVEA.B    D7,A1
0138: 508B          MOVE.B     A3,(A0)
013A: 3047          MOVEA.W    D7,A0
013C: B1D46FE2      MOVE.W     (A4),$6FE2.W
0140: 4EBA1022      JSR        4130(PC)
0144: 4CDF1C80      MOVEM.L    (SP)+,D7/A2/A3/A4              ; restore
0148: 4E5E          UNLK       A6
014A: 4E75          RTS        


; ======= Function at 0x014C =======
014C: 4E560000      LINK       A6,#0
0150: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0154: 7E00          MOVEQ      #0,D7
0156: 49ED9368      LEA        -27800(A5),A4                  ; A5-27800
015A: 6010          BRA.S      $016C
015C: 2014          MOVE.L     (A4),D0
015E: B0AE0008      MOVE.W     8(A6),(A0)
0162: 6604          BNE.S      $0168
0164: 7001          MOVEQ      #1,D0
0166: 600C          BRA.S      $0174
0168: 5247          MOVEA.B    D7,A1
016A: 588C          MOVE.B     A4,(A4)
016C: BE6D9320      MOVEA.W    -27872(A5),A7
0170: 6DEA          BLT.S      $015C
0172: 7000          MOVEQ      #0,D0
0174: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
0178: 4E5E          UNLK       A6
017A: 4E75          RTS        


; ======= Function at 0x017C =======
017C: 4E560000      LINK       A6,#0
0180: 0C6D00109320  CMPI.W     #$0010,-27872(A5)
0186: 6504          BCS.S      $018C
0188: 4EBA0FDA      JSR        4058(PC)
018C: 302D9320      MOVE.W     -27872(A5),D0                  ; A5-27872
0190: 526D9320      MOVEA.B    -27872(A5),A1
0194: 204D          MOVEA.L    A5,A0
0196: 48C0          EXT.L      D0
0198: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
019C: 216E00089368  MOVE.L     8(A6),-27800(A0)
01A2: 4E5E          UNLK       A6
01A4: 4E75          RTS        


; ======= Function at 0x01A6 =======
01A6: 4E560000      LINK       A6,#0
01AA: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
01AE: 7E00          MOVEQ      #0,D7
01B0: 49ED9368      LEA        -27800(A5),A4                  ; A5-27800
01B4: 6004          BRA.S      $01BA
01B6: 5247          MOVEA.B    D7,A1
01B8: 588C          MOVE.B     A4,(A4)
01BA: BE6D9320      MOVEA.W    -27872(A5),A7
01BE: 6C08          BGE.S      $01C8
01C0: 2014          MOVE.L     (A4),D0
01C2: B0AE0008      MOVE.W     8(A6),(A0)
01C6: 66EE          BNE.S      $01B6
01C8: BE6D9320      MOVEA.W    -27872(A5),A7
01CC: 6604          BNE.S      $01D2
01CE: 4EBA0F94      JSR        3988(PC)
01D2: 4A6D9320      TST.W      -27872(A5)
01D6: 6E04          BGT.S      $01DC
01D8: 4EBA0F8A      JSR        3978(PC)
01DC: 536D9320302D  MOVE.B     -27872(A5),12333(A1)           ; A5-27872
01E2: 9320          MOVE.B     -(A0),-(A1)
01E4: 204D          MOVEA.L    A5,A0
01E6: 48C0          EXT.L      D0
01E8: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
01EC: 224D          MOVEA.L    A5,A1
01EE: 2007          MOVE.L     D7,D0
01F0: 48C0          EXT.L      D0
01F2: E588D3C0      MOVE.L     A0,-64(A2,A5.W*2)
01F6: 236893689368  MOVE.L     -27800(A0),-27800(A1)
01FC: 48780004      PEA        $0004.W
0200: 4EBA034E      JSR        846(PC)
0204: 4CEE1080FFF8  MOVEM.L    -8(A6),D7/A4
020A: 4E5E          UNLK       A6
020C: 4E75          RTS        


; ======= Function at 0x020E =======
020E: 4E560000      LINK       A6,#0
0212: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
0216: 286E0008      MOVEA.L    8(A6),A4
021A: 2E2E000C      MOVE.L     12(A6),D7
021E: 200C          MOVE.L     A4,D0
0220: 6754          BEQ.S      $0276
0222: 4A2C006E      TST.B      110(A4)
0226: 674E          BEQ.S      $0276
0228: 2F0C          MOVE.L     A4,-(A7)
022A: 4EBAFDD4      JSR        -556(PC)
022E: 2640          MOVEA.L    D0,A3
0230: 2047          MOVEA.L    D7,A0
0232: 08280000000F  BTST       #0,15(A0)
0238: 588F          MOVE.B     A7,(A4)
023A: 6720          BEQ.S      $025C
023C: 2B4C9364      MOVE.L     A4,-27804(A5)
0240: 48780004      PEA        $0004.W
0244: 2F0B          MOVE.L     A3,-(A7)
0246: 4EBAFE58      JSR        -424(PC)
024A: 2440          MOVEA.L    D0,A2
024C: 200A          MOVE.L     A2,D0
024E: 508F          MOVE.B     A7,(A0)
0250: 6724          BEQ.S      $0276
0252: 2F07          MOVE.L     D7,-(A7)
0254: 2F0C          MOVE.L     A4,-(A7)
0256: 4E92          JSR        (A2)
0258: 508F          MOVE.B     A7,(A0)
025A: 601A          BRA.S      $0276
025C: 48780005      PEA        $0005.W
0260: 2F0B          MOVE.L     A3,-(A7)
0262: 4EBAFE3C      JSR        -452(PC)
0266: 2440          MOVEA.L    D0,A2
0268: 200A          MOVE.L     A2,D0
026A: 508F          MOVE.B     A7,(A0)
026C: 6708          BEQ.S      $0276
026E: 2F07          MOVE.L     D7,-(A7)
0270: 2F0C          MOVE.L     A4,-(A7)
0272: 4E92          JSR        (A2)
0274: 508F          MOVE.B     A7,(A0)
0276: 4CDF1C80      MOVEM.L    (SP)+,D7/A2/A3/A4              ; restore
027A: 4E5E          UNLK       A6
027C: 4E75          RTS        


; ======= Function at 0x027E =======
027E: 4E56FE00      LINK       A6,#-512                       ; frame=512
0282: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
0286: 286E0008      MOVEA.L    8(A6),A4
028A: 200C          MOVE.L     A4,D0
028C: 6604          BNE.S      $0292
028E: 4EBA0ED4      JSR        3796(PC)
0292: 4267          CLR.W      -(A7)
0294: 2F0C          MOVE.L     A4,-(A7)
0296: A9503E1F      MOVE.L     (A0),15903(A4)
029A: 7C01          MOVEQ      #1,D6
029C: 6028          BRA.S      $02C6
029E: 2F0C          MOVE.L     A4,-(A7)
02A0: 3F06          MOVE.W     D6,-(A7)
02A2: 486EFE00      PEA        -512(A6)
02A6: A9460C2E      MOVE.L     D6,3118(A4)
02AA: 002DFE01670E  ORI.B      #$FE01,26382(A5)
02B0: 4A6E000C      TST.W      12(A6)
02B4: 6708          BEQ.S      $02BE
02B6: 2F0C          MOVE.L     A4,-(A7)
02B8: 3F06          MOVE.W     D6,-(A7)
02BA: A93960062F0C  MOVE.L     $60062F0C,-(A4)
02C0: 3F06          MOVE.W     D6,-(A7)
02C2: A93A5246      MOVE.L     21062(PC),-(A4)
02C6: BE46          MOVEA.W    D6,A7
02C8: 6CD4          BGE.S      $029E
02CA: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
02CE: 4E5E          UNLK       A6
02D0: 4E75          RTS        


; ======= Function at 0x02D2 =======
02D2: 4E56FEFA      LINK       A6,#-262                       ; frame=262
02D6: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
02DA: 4267          CLR.W      -(A7)
02DC: 2F3C4D454E55  MOVE.L     #$4D454E55,-(A7)
02E2: A80D          MOVE.L     A5,D4
02E4: 3E1F          MOVE.W     (A7)+,D7
02E6: 604E          BRA.S      $0336
02E8: 4227          CLR.B      -(A7)
02EA: A99B42A7      MOVE.L     (A3)+,-89(A4,D4.W*2)
02EE: 2F3C4D454E55  MOVE.L     #$4D454E55,-(A7)
02F4: 3F07          MOVE.W     D7,-(A7)
02F6: A80E          MOVE.L     A6,D4
02F8: 285F          MOVEA.L    (A7)+,A4
02FA: 200C          MOVE.L     A4,D0
02FC: 6604          BNE.S      $0302
02FE: 4EBA0E64      JSR        3684(PC)
0302: 1F3C0001      MOVE.B     #$01,-(A7)
0306: A99B2F0C      MOVE.L     (A3)+,12(A4,D2.L*8)
030A: 486EFFFE      PEA        -2(A6)
030E: 486EFFFA      PEA        -6(A6)
0312: 486EFEFA      PEA        -262(A6)
0316: A9A842A73F2E  MOVE.L     17063(A0),46(A4,D3.L*8)
031C: FFFE          MOVE.W     ???,???
031E: A949285F      MOVE.L     A1,10335(A4)
0322: 200C          MOVE.L     A4,D0
0324: 670E          BEQ.S      $0334
0326: 3F2E000C      MOVE.W     12(A6),-(A7)
032A: 2F0C          MOVE.L     A4,-(A7)
032C: 206E0008      MOVEA.L    8(A6),A0
0330: 4E90          JSR        (A0)
0332: 5C8F          MOVE.B     A7,(A6)
0334: 53474A47      MOVE.B     D7,19015(A1)
0338: 66AE          BNE.S      $02E8
033A: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
033E: 4E5E          UNLK       A6
0340: 4E75          RTS        


; ======= Function at 0x0342 =======
0342: 4E560000      LINK       A6,#0
0346: 4267          CLR.W      -(A7)
0348: 486D01F2      PEA        498(A5)                        ; A5+498
034C: 4EBAFF84      JSR        -124(PC)
0350: 2EAE000C      MOVE.L     12(A6),(A7)
0354: 2F2E0008      MOVE.L     8(A6),-(A7)
0358: 4EBA005A      JSR        90(PC)
035C: 4AADFACE      TST.L      -1330(A5)
0360: 4FEF000A      LEA        10(A7),A7
0364: 6714          BEQ.S      $037A
0366: 2F2DFACE      MOVE.L     -1330(A5),-(A7)                ; A5-1330
036A: 4EBAFC94      JSR        -876(PC)
036E: 2E80          MOVE.L     D0,(A7)
0370: 2F2DFACE      MOVE.L     -1330(A5),-(A7)                ; A5-1330
0374: 4EBA003E      JSR        62(PC)
0378: 508F          MOVE.B     A7,(A0)
037A: 4E5E          UNLK       A6
037C: 4E75          RTS        


; ======= Function at 0x037E =======
037E: 4E560000      LINK       A6,#0
0382: 4A6E000C      TST.W      12(A6)
0386: 670A          BEQ.S      $0392
0388: 2F2E0008      MOVE.L     8(A6),-(A7)
038C: 4267          CLR.W      -(A7)
038E: A93960082F2E  MOVE.L     $60082F2E,-(A4)
0394: 00084267      ORI.B      #$4267,A0
0398: A93A4E5E      MOVE.L     20062(PC),-(A4)
039C: 4E75          RTS        


; ======= Function at 0x039E =======
039E: 4E560000      LINK       A6,#0
03A2: 3F2E0008      MOVE.W     8(A6),-(A7)
03A6: 486D01C2      PEA        450(A5)                        ; A5+450
03AA: 4EBAFF26      JSR        -218(PC)
03AE: A9374E5E      MOVE.L     94(A7,D4.L*8),-(A4)
03B2: 4E75          RTS        


; ======= Function at 0x03B4 =======
03B4: 4E560000      LINK       A6,#0
03B8: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
03BC: 286E000C      MOVEA.L    12(A6),A4
03C0: 42A7          CLR.L      -(A7)
03C2: 2F0C          MOVE.L     A4,-(A7)
03C4: 4EBAFCDA      JSR        -806(PC)
03C8: 2840          MOVEA.L    D0,A4
03CA: 508F          MOVE.B     A7,(A0)
03CC: 6000008C      BRA.W      $045C
03D0: 7C01          MOVEQ      #1,D6
03D2: 367C000C      MOVEA.W    #$000C,A3
03D6: 6078          BRA.S      $0450
03D8: 204B          MOVEA.L    A3,A0
03DA: D1CC2E08      MOVE.B     A4,$2E08.W
03DE: 2047          MOVEA.L    D7,A0
03E0: 4AA80008      TST.L      8(A0)
03E4: 6764          BEQ.S      $044A
03E6: 42A7          CLR.L      -(A7)
03E8: 4267          CLR.W      -(A7)
03EA: 2047          MOVEA.L    D7,A0
03EC: 2F10          MOVE.L     (A0),-(A7)
03EE: A86AA949      MOVEA.L    -22199(A2),A4
03F2: 245F          MOVEA.L    (A7)+,A2
03F4: 200A          MOVE.L     A2,D0
03F6: 6752          BEQ.S      $044A
03F8: 204C          MOVEA.L    A4,A0
03FA: D1CB4AA8      MOVE.B     A3,$4AA8.W
03FE: 0004671C      ORI.B      #$671C,D4
0402: 204C          MOVEA.L    A4,A0
0404: D1CB2F10      MOVE.B     A3,$2F10.W
0408: 2F0A          MOVE.L     A2,-(A7)
040A: 2F2E0008      MOVE.L     8(A6),-(A7)
040E: 204C          MOVEA.L    A4,A0
0410: D1CB2068      MOVE.B     A3,$2068.W
0414: 00044E90      ORI.B      #$4E90,D4
0418: 4FEF000C      LEA        12(A7),A7
041C: 6002          BRA.S      $0420
041E: 7001          MOVEQ      #1,D0
0420: 4A80          TST.L      D0
0422: 6726          BEQ.S      $044A
0424: 4267          CLR.W      -(A7)
0426: 2047          MOVEA.L    D7,A0
0428: 2F10          MOVE.L     (A0),-(A7)
042A: A86B4A5F      MOVEA.L    19039(A3),A4
042E: 670E          BEQ.S      $043E
0430: 2F0A          MOVE.L     A2,-(A7)
0432: 4267          CLR.W      -(A7)
0434: 2047          MOVEA.L    D7,A0
0436: 2F10          MOVE.L     (A0),-(A7)
0438: A86BA939      MOVEA.L    -22215(A3),A4
043C: 600C          BRA.S      $044A
043E: 3F3C0001      MOVE.W     #$0001,-(A7)
0442: 2F0A          MOVE.L     A2,-(A7)
0444: 4EBAFE38      JSR        -456(PC)
0448: 5C8F          MOVE.B     A7,(A6)
044A: 5246          MOVEA.B    D6,A1
044C: 47EB000C      LEA        12(A3),A3
0450: 3046          MOVEA.W    D6,A0
0452: B1D46F82      MOVE.W     (A4),$6F82.W
0456: 286C0008      MOVEA.L    8(A4),A4
045A: 200C          MOVE.L     A4,D0
045C: 6600FF72      BNE.W      $03D2
0460: 4CDF1CC0      MOVEM.L    (SP)+,D6/D7/A2/A3/A4           ; restore
0464: 4E5E          UNLK       A6
0466: 4E75          RTS        


; ======= Function at 0x0468 =======
0468: 4E560000      LINK       A6,#0
046C: 2F0C          MOVE.L     A4,-(A7)
046E: 2F2E0010      MOVE.L     16(A6),-(A7)
0472: 2F2E000C      MOVE.L     12(A6),-(A7)
0476: 206E0008      MOVEA.L    8(A6),A0
047A: 2F10          MOVE.L     (A0),-(A7)
047C: 4EBA004A      JSR        74(PC)
0480: 2840          MOVEA.L    D0,A4
0482: 200C          MOVE.L     A4,D0
0484: 4FEF000C      LEA        12(A7),A7
0488: 6704          BEQ.S      $048E
048A: 200C          MOVE.L     A4,D0
048C: 6034          BRA.S      $04C2
048E: 4AADFACE      TST.L      -1330(A5)
0492: 672C          BEQ.S      $04C0
0494: 2F2E0010      MOVE.L     16(A6),-(A7)
0498: 2F2DFACE      MOVE.L     -1330(A5),-(A7)                ; A5-1330
049C: 4EBAFB62      JSR        -1182(PC)
04A0: 2E80          MOVE.L     D0,(A7)
04A2: 2F2DFACE      MOVE.L     -1330(A5),-(A7)                ; A5-1330
04A6: 4EBA0020      JSR        32(PC)
04AA: 2840          MOVEA.L    D0,A4
04AC: 200C          MOVE.L     A4,D0
04AE: 4FEF000C      LEA        12(A7),A7
04B2: 670C          BEQ.S      $04C0
04B4: 206E0008      MOVEA.L    8(A6),A0
04B8: 20ADFACE      MOVE.L     -1330(A5),(A0)                 ; A5-1330
04BC: 200C          MOVE.L     A4,D0
04BE: 6002          BRA.S      $04C2
04C0: 7000          MOVEQ      #0,D0
04C2: 285F          MOVEA.L    (A7)+,A4
04C4: 4E5E          UNLK       A6
04C6: 4E75          RTS        


; ======= Function at 0x04C8 =======
04C8: 4E560000      LINK       A6,#0
04CC: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
04D0: 286E000C      MOVEA.L    12(A6),A4
04D4: 2C2E0010      MOVE.L     16(A6),D6
04D8: 02460000      ANDI.W     #$0000,D6
04DC: 42A7          CLR.L      -(A7)
04DE: 2F0C          MOVE.L     A4,-(A7)
04E0: 4EBAFBBE      JSR        -1090(PC)
04E4: 2840          MOVEA.L    D0,A4
04E6: 508F          MOVE.B     A7,(A0)
04E8: 6058          BRA.S      $0542
04EA: 3A2C0002      MOVE.W     2(A4),D5
04EE: 7801          MOVEQ      #1,D4
04F0: 367C000C      MOVEA.W    #$000C,A3
04F4: 6044          BRA.S      $053A
04F6: 244B          MOVEA.L    A3,A2
04F8: D5CC2612      MOVE.B     A4,9746(PC)
04FC: B6AE0010      MOVE.W     16(A6),(A3)
0500: 6704          BEQ.S      $0506
0502: BC83          MOVE.W     D3,(A6)
0504: 662E          BNE.S      $0534
0506: 42A7          CLR.L      -(A7)
0508: 4267          CLR.W      -(A7)
050A: 2F12          MOVE.L     (A2),-(A7)
050C: A86AA949      MOVEA.L    -22199(A2),A4
0510: 2E1F          MOVE.L     (A7)+,D7
0512: 4AAA0004      TST.L      4(A2)
0516: 6716          BEQ.S      $052E
0518: 2F12          MOVE.L     (A2),-(A7)
051A: 2F07          MOVE.L     D7,-(A7)
051C: 2F2E0008      MOVE.L     8(A6),-(A7)
0520: 206A0004      MOVEA.L    4(A2),A0
0524: 4E90          JSR        (A0)
0526: 4A80          TST.L      D0
0528: 4FEF000C      LEA        12(A7),A7
052C: 6706          BEQ.S      $0534
052E: 202A0008      MOVE.L     8(A2),D0
0532: 6014          BRA.S      $0548
0534: 5244          MOVEA.B    D4,A1
0536: 47EB000C      LEA        12(A3),A3
053A: BA44          MOVEA.W    D4,A5
053C: 6CB8          BGE.S      $04F6
053E: 286C0008      MOVEA.L    8(A4),A4
0542: 200C          MOVE.L     A4,D0
0544: 66A4          BNE.S      $04EA
0546: 7000          MOVEQ      #0,D0
0548: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
054C: 4E5E          UNLK       A6
054E: 4E75          RTS        


; ======= Function at 0x0550 =======
0550: 4E560000      LINK       A6,#0
0554: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0558: 2E2E0008      MOVE.L     8(A6),D7
055C: 2F2DFAD2      MOVE.L     -1326(A5),-(A7)                ; A5-1326
0560: 4EBAFA9E      JSR        -1378(PC)
0564: 2840          MOVEA.L    D0,A4
0566: 2EADFACE      MOVE.L     -1330(A5),(A7)                 ; A5-1330
056A: 4EBAFA94      JSR        -1388(PC)
056E: 2640          MOVEA.L    D0,A3
0570: 2E87          MOVE.L     D7,(A7)
0572: 2F0C          MOVE.L     A4,-(A7)
0574: 4EBAFB2A      JSR        -1238(PC)
0578: 4A80          TST.L      D0
057A: 508F          MOVE.B     A7,(A0)
057C: 6716          BEQ.S      $0594
057E: 2F07          MOVE.L     D7,-(A7)
0580: 2F0B          MOVE.L     A3,-(A7)
0582: 4EBAFB1C      JSR        -1252(PC)
0586: 4A80          TST.L      D0
0588: 508F          MOVE.B     A7,(A0)
058A: 6622          BNE.S      $05AE
058C: 2B6DFAD29364  MOVE.L     -1326(A5),-27804(A5)           ; A5-1326
0592: 601A          BRA.S      $05AE
0594: 2F07          MOVE.L     D7,-(A7)
0596: 2F0B          MOVE.L     A3,-(A7)
0598: 4EBAFB06      JSR        -1274(PC)
059C: 4A80          TST.L      D0
059E: 508F          MOVE.B     A7,(A0)
05A0: 6708          BEQ.S      $05AA
05A2: 2B6DFACE9364  MOVE.L     -1330(A5),-27804(A5)           ; A5-1330
05A8: 6004          BRA.S      $05AE
05AA: 7000          MOVEQ      #0,D0
05AC: 6004          BRA.S      $05B2
05AE: 202D9364      MOVE.L     -27804(A5),D0                  ; A5-27804
05B2: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
05B6: 4E5E          UNLK       A6
05B8: 4E75          RTS        


; ======= Function at 0x05BA =======
05BA: 4E560000      LINK       A6,#0
05BE: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
05C2: 286E000C      MOVEA.L    12(A6),A4
05C6: 4267          CLR.W      -(A7)
05C8: 2F2E0008      MOVE.L     8(A6),-(A7)
05CC: 2F0C          MOVE.L     A4,-(A7)
05CE: A92C3E1F      MOVE.L     15903(A4),-(A4)
05D2: 4A94          TST.L      (A4)
05D4: 6606          BNE.S      $05DC
05D6: 4EAD0C42      JSR        3138(A5)                       ; JT[3138]
05DA: 2880          MOVE.L     D0,(A4)
05DC: 2B549364      MOVE.L     (A4),-27804(A5)
05E0: 3007          MOVE.W     D7,D0
05E2: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
05E6: 4E5E          UNLK       A6
05E8: 4E75          RTS        


; ======= Function at 0x05EA =======
05EA: 4E56FFDC      LINK       A6,#-36                        ; frame=36
05EE: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
05F2: 286E0008      MOVEA.L    8(A6),A4
05F6: 0C540001      CMPI.W     #$0001,(A4)
05FA: 660001B8      BNE.W      $07B6
05FE: 486EFFF4      PEA        -12(A6)
0602: 2F2C000A      MOVE.L     10(A4),-(A7)
0606: 4EBAFFB2      JSR        -78(PC)
060A: 3A00          MOVE.W     D0,D5
060C: 2EAEFFF4      MOVE.L     -12(A6),(A7)
0610: 4EBAF9EE      JSR        -1554(PC)
0614: 2640          MOVEA.L    D0,A3
0616: 3005          MOVE.W     D5,D0
0618: 0C400008      CMPI.W     #$0008,D0
061C: 508F          MOVE.B     A7,(A0)
061E: 620003E4      BHI.W      $0A06
0622: 43FA0408      LEA        1032(PC),A1
0626: D040          MOVEA.B    D0,A0
0628: D2F10000      MOVE.B     0(A1,D0.W),(A1)+
062C: 4ED1          JMP        (A1)
062E: 2F0C          MOVE.L     A4,-(A7)
0630: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
0634: A9B3600003CC  MOVE.L     0(A3,D6.W),-52(A4,D0.W*2)
063A: 7C08          MOVEQ      #8,D6
063C: 600001C6      BRA.W      $0806
0640: 7C01          MOVEQ      #1,D6
0642: 600001C0      BRA.W      $0806
0646: A850          MOVEA.L    (A0),A4
0648: 2F0B          MOVE.L     A3,-(A7)
064A: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
064E: 4EBAFCF2      JSR        -782(PC)
0652: 4297          CLR.L      (A7)
0654: 2F2C000A      MOVE.L     10(A4),-(A7)
0658: A93D          MOVE.L     ???,-(A4)
065A: 2E1F          MOVE.L     (A7)+,D7
065C: 588F          MOVE.B     A7,(A4)
065E: 4267          CLR.W      -(A7)
0660: 2F07          MOVE.L     D7,-(A7)
0662: A86A4A5F      MOVEA.L    19039(A2),A4
0666: 6700039C      BEQ.W      $0A06
066A: 2F07          MOVE.L     D7,-(A7)
066C: 2F0B          MOVE.L     A3,-(A7)
066E: 486EFFF4      PEA        -12(A6)
0672: 4EBAFDF4      JSR        -524(PC)
0676: 2440          MOVEA.L    D0,A2
0678: 200A          MOVE.L     A2,D0
067A: 4FEF000C      LEA        12(A7),A7
067E: 670E          BEQ.S      $068E
0680: 4267          CLR.W      -(A7)
0682: 2F07          MOVE.L     D7,-(A7)
0684: A86B2F2E      MOVEA.L    12078(A3),A4
0688: FFF44E92      MOVE.W     -110(A4,D4.L*8),???
068C: 5C8F          MOVE.B     A7,(A6)
068E: 4267          CLR.W      -(A7)
0690: A9386000      MOVE.L     $6000.W,-(A4)
0694: 03702F2E      BCHG       D1,46(A0,D2.L*8)
0698: FFF44EAD      MOVE.W     -83(A4,D4.L*8),???
069C: 0C2A4A40588F  CMPI.B     #$4A40,22671(A2)
06A2: 6606          BNE.S      $06AA
06A4: 7C12          MOVEQ      #18,D6
06A6: 6000015C      BRA.W      $0806
06AA: 2D6C000AFFEC  MOVE.L     10(A4),-20(A6)
06B0: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
06B4: A873486E      MOVEA.L    110(A3,D4.L),A4
06B8: FFECA871      MOVE.W     -22415(A4),???
06BC: 4267          CLR.W      -(A7)
06BE: 2F2EFFEC      MOVE.L     -20(A6),-(A7)
06C2: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
06C6: 486EFFE8      PEA        -24(A6)
06CA: A96C3A1F6760  MOVE.L     14879(A4),26464(A4)
06D0: 42A7          CLR.L      -(A7)
06D2: 2F2EFFE8      MOVE.L     -24(A6),-(A7)
06D6: A95A265F      MOVE.L     (A2)+,9823(A4)
06DA: 48780014      PEA        $0014.W
06DE: 2F0B          MOVE.L     A3,-(A7)
06E0: 4EBAF9BE      JSR        -1602(PC)
06E4: 2440          MOVEA.L    D0,A2
06E6: 200A          MOVE.L     A2,D0
06E8: 508F          MOVE.B     A7,(A0)
06EA: 670C          BEQ.S      $06F8
06EC: 3F05          MOVE.W     D5,-(A7)
06EE: 2F2EFFE8      MOVE.L     -24(A6),-(A7)
06F2: 4E92          JSR        (A2)
06F4: 2440          MOVEA.L    D0,A2
06F6: 5C8F          MOVE.B     A7,(A6)
06F8: 4267          CLR.W      -(A7)
06FA: 2F2EFFE8      MOVE.L     -24(A6),-(A7)
06FE: 2F2EFFEC      MOVE.L     -20(A6),-(A7)
0702: 2F0A          MOVE.L     A2,-(A7)
0704: A9683A1F4A45  MOVE.L     14879(A0),19013(A4)
070A: 670002F8      BEQ.W      $0A06
070E: 48780015      PEA        $0015.W
0712: 2F0B          MOVE.L     A3,-(A7)
0714: 4EBAF98A      JSR        -1654(PC)
0718: 2440          MOVEA.L    D0,A2
071A: 200A          MOVE.L     A2,D0
071C: 508F          MOVE.B     A7,(A0)
071E: 670002E4      BEQ.W      $0A06
0722: 3F05          MOVE.W     D5,-(A7)
0724: 2F2EFFE8      MOVE.L     -24(A6),-(A7)
0728: 4E92          JSR        (A2)
072A: 5C8F          MOVE.B     A7,(A6)
072C: 600002D6      BRA.W      $0A06
0730: 7C06          MOVEQ      #6,D6
0732: 600000D0      BRA.W      $0806
0736: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
073A: 4EAD0C2A      JSR        3114(A5)                       ; JT[3114]
073E: 4A40          TST.W      D0
0740: 588F          MOVE.B     A7,(A4)
0742: 6700FF60      BEQ.W      $06A6
0746: 7C09          MOVEQ      #9,D6
0748: 600000BA      BRA.W      $0806
074C: 4878000B      PEA        $000B.W
0750: 2F0B          MOVE.L     A3,-(A7)
0752: 4EBAF94C      JSR        -1716(PC)
0756: 2440          MOVEA.L    D0,A2
0758: 200A          MOVE.L     A2,D0
075A: 508F          MOVE.B     A7,(A0)
075C: 670002A6      BEQ.W      $0A06
0760: 4227          CLR.B      -(A7)
0762: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
0766: 2F2C000A      MOVE.L     10(A4),-(A7)
076A: 3F05          MOVE.W     D5,-(A7)
076C: A83B4A1F      MOVE.L     31(PC,D4.L),D4
0770: 67000292      BEQ.W      $0A06
0774: 3F05          MOVE.W     D5,-(A7)
0776: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
077A: 4E92          JSR        (A2)
077C: 5C8F          MOVE.B     A7,(A6)
077E: 60000284      BRA.W      $0A06
0782: 48780007      PEA        $0007.W
0786: 2F0B          MOVE.L     A3,-(A7)
0788: 4EBAF916      JSR        -1770(PC)
078C: 2440          MOVEA.L    D0,A2
078E: 200A          MOVE.L     A2,D0
0790: 508F          MOVE.B     A7,(A0)
0792: 67000270      BEQ.W      $0A06
0796: 4227          CLR.B      -(A7)
0798: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
079C: 2F2C000A      MOVE.L     10(A4),-(A7)
07A0: A91E          MOVE.L     (A6)+,-(A4)
07A2: 4A1F          TST.B      (A7)+
07A4: 6700025E      BEQ.W      $0A06
07A8: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
07AC: 4E92          JSR        (A2)
07AE: 588F          MOVE.B     A7,(A4)
07B0: 60000252      BRA.W      $0A06
07B4: 3014          MOVE.W     (A4),D0
07B6: 0C40000F      CMPI.W     #$000F,D0
07BA: 62000248      BHI.W      $0A06
07BE: 43FA024C      LEA        588(PC),A1
07C2: D040          MOVEA.B    D0,A0
07C4: D2F10000      MOVE.B     0(A1,D0.W),(A1)+
07C8: 4ED1          JMP        (A1)
07CA: 082C0000000F  BTST       #0,15(A4)
07D0: 6708          BEQ.S      $07DA
07D2: 4EAD0622      JSR        1570(A5)                       ; JT[1570]
07D6: 6000022C      BRA.W      $0A06
07DA: 4EAD062A      JSR        1578(A5)                       ; JT[1578]
07DE: 60000224      BRA.W      $0A06
07E2: 204D          MOVEA.L    A5,A0
07E4: 3014          MOVE.W     (A4),D0
07E6: 48C0          EXT.L      D0
07E8: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
07EC: 2C289322      MOVE.L     -27870(A0),D6
07F0: 2F06          MOVE.L     D6,-(A7)
07F2: 4EBAFD5C      JSR        -676(PC)
07F6: 2D40FFF4      MOVE.L     D0,-12(A6)
07FA: 2E80          MOVE.L     D0,(A7)
07FC: 4EBAF802      JSR        -2046(PC)
0800: 2640          MOVEA.L    D0,A3
0802: 588F          MOVE.B     A7,(A4)
0804: 2F06          MOVE.L     D6,-(A7)
0806: 2F0B          MOVE.L     A3,-(A7)
0808: 4EBAF896      JSR        -1898(PC)
080C: 2440          MOVEA.L    D0,A2
080E: 200A          MOVE.L     A2,D0
0810: 508F          MOVE.B     A7,(A0)
0812: 670001F0      BEQ.W      $0A06
0816: 2F0C          MOVE.L     A4,-(A7)
0818: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
081C: 4E92          JSR        (A2)
081E: 508F          MOVE.B     A7,(A0)
0820: 600001E2      BRA.W      $0A06
0824: 082C0000000E  BTST       #0,14(A4)
082A: 6758          BEQ.S      $0884
082C: 0C540003      CMPI.W     #$0003,(A4)
0830: 660001D2      BNE.W      $0A06
0834: 2D6D9364FFF4  MOVE.L     -27804(A5),-12(A6)             ; A5-27804
083A: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
083E: 4EBAF7C0      JSR        -2112(PC)
0842: 2640          MOVEA.L    D0,A3
0844: 0C2C002F0005  CMPI.B     #$002F,5(A4)
084A: 588F          MOVE.B     A7,(A4)
084C: 660A          BNE.S      $0858
084E: 2E2D9360      MOVE.L     -27808(A5),D7                  ; A5-27808
0852: 6600FE0A      BNE.W      $0660
0856: 6028          BRA.S      $0880
0858: 2F0B          MOVE.L     A3,-(A7)
085A: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
085E: 4EBAFAE2      JSR        -1310(PC)
0862: 4297          CLR.L      (A7)
0864: 302C0004      MOVE.W     4(A4),D0
0868: 024000FF      ANDI.W     #$00FF,D0
086C: 3F00          MOVE.W     D0,-(A7)
086E: A93E          MOVE.L     ???,-(A4)
0870: 2E1F          MOVE.L     (A7)+,D7
0872: 4257          CLR.W      (A7)
0874: 2F07          MOVE.L     D7,-(A7)
0876: A86A4A5F      MOVEA.L    19039(A2),A4
087A: 548F          MOVE.B     A7,(A2)
087C: 6600FDE0      BNE.W      $0660
0880: 7C13          MOVEQ      #19,D6
0882: 6080          BRA.S      $0804
0884: 202C0002      MOVE.L     2(A4),D0
0888: 02800000FF00  ANDI.L     #$0000FF00,D0
088E: 5B806612      MOVE.B     D0,18(A5,D6.W*8)
0892: 2D6D9364FFF4  MOVE.L     -27804(A5),-12(A6)             ; A5-27804
0898: 2E2D9360      MOVE.L     -27808(A5),D7                  ; A5-27808
089C: 6600FDC0      BNE.W      $0660
08A0: 60000162      BRA.W      $0A06
08A4: 7C0C          MOVEQ      #12,D6
08A6: 6000FF48      BRA.W      $07F2
08AA: 2D6C0002FFF4  MOVE.L     2(A4),-12(A6)
08B0: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
08B4: A8732F2E      MOVEA.L    46(A3,D2.L*8),A4
08B8: FFF4A922      MOVE.W     34(A4,A2.L),???
08BC: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
08C0: 4EAD065A      JSR        1626(A5)                       ; JT[1626]
08C4: 4A40          TST.W      D0
08C6: 588F          MOVE.B     A7,(A4)
08C8: 6610          BNE.S      $08DA
08CA: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
08CE: 206EFFF4      MOVEA.L    -12(A6),A0
08D2: 2F280018      MOVE.L     24(A0),-(A7)
08D6: A9536074      MOVE.L     (A3),24692(A4)
08DA: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
08DE: 206EFFF4      MOVEA.L    -12(A6),A0
08E2: 2F280018      MOVE.L     24(A0),-(A7)
08E6: A97842A7A8D8  MOVE.L     $42A7.W,-22312(A4)
08EC: 261F          MOVE.L     (A7)+,D3
08EE: 7801          MOVEQ      #1,D4
08F0: 604A          BRA.S      $093C
08F2: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
08F6: 3F04          MOVE.W     D4,-(A7)
08F8: 486EFFF2      PEA        -14(A6)
08FC: 486EFFDC      PEA        -36(A6)
0900: 486EFFE0      PEA        -32(A6)
0904: A98D082E      MOVE.L     A5,46(A4,D0.L)
0908: 0002FFF3      ORI.B      #$FFF3,D2
090C: 662C          BNE.S      $093A
090E: 082E0004FFF3  BTST       #4,-13(A6)
0914: 670C          BEQ.S      $0922
0916: 486EFFE0      PEA        -32(A6)
091A: 2F3CFFFCFFFC  MOVE.L     #$FFFCFFFC,-(A7)
0920: A8A92F03      MOVE.L     12035(A1),(A4)
0924: 486EFFE0      PEA        -32(A6)
0928: A8DF          MOVE.L     (A7)+,(A4)+
092A: 206EFFF4      MOVEA.L    -12(A6),A0
092E: 2F280018      MOVE.L     24(A0),-(A7)
0932: 2F03          MOVE.L     D3,-(A7)
0934: 2F280018      MOVE.L     24(A0),-(A7)
0938: A8E6          MOVE.L     -(A6),(A4)+
093A: 5244          MOVEA.B    D4,A1
093C: 206EFFF4      MOVEA.L    -12(A6),A0
0940: 2068009C      MOVEA.L    156(A0),A0
0944: 2050          MOVEA.L    (A0),A0
0946: B850          MOVEA.W    (A0),A4
0948: 6FA8          BLE.S      $08F2
094A: 2F03          MOVE.L     D3,-(A7)
094C: A8D9          MOVE.L     (A1)+,(A4)+
094E: 206EFFF4      MOVEA.L    -12(A6),A0
0952: 4AA8008C      TST.L      140(A0)
0956: 6770          BEQ.S      $09C8
0958: 42A7          CLR.L      -(A7)
095A: A8D8          MOVE.L     (A0)+,(A4)+
095C: 2D5FFFFC      MOVE.L     (A7)+,-4(A6)
0960: 206EFFF4      MOVEA.L    -12(A6),A0
0964: 2D68008CFFF8  MOVE.L     140(A0),-8(A6)
096A: 6050          BRA.S      $09BC
096C: 206EFFF8      MOVEA.L    -8(A6),A0
0970: A029206E      MOVE.L     8302(A1),D0
0974: FFF82050      MOVE.W     $2050.W,???
0978: 4A280010      TST.B      16(A0)
097C: 660C          BNE.S      $098A
097E: 206EFFF8      MOVEA.L    -8(A6),A0
0982: 2050          MOVEA.L    (A0),A0
0984: 48680008      PEA        8(A0)
0988: A8A3          MOVE.L     -(A3),(A4)
098A: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
098E: 206EFFF8      MOVEA.L    -8(A6),A0
0992: 2050          MOVEA.L    (A0),A0
0994: 48680008      PEA        8(A0)
0998: A8DF          MOVE.L     (A7)+,(A4)+
099A: 206EFFF8      MOVEA.L    -8(A6),A0
099E: A02A206E      MOVE.L     8302(A2),D0
09A2: FFF42F28      MOVE.W     40(A4,D2.L*8),???
09A6: 00182F2E      ORI.B      #$2F2E,(A0)+
09AA: FFFC2F28      MOVE.W     #$2F28,???
09AE: 0018A8E6      ORI.B      #$A8E6,(A0)+
09B2: 206EFFF8      MOVEA.L    -8(A6),A0
09B6: 2050          MOVEA.L    (A0),A0
09B8: 2D50FFF8      MOVE.L     (A0),-8(A6)
09BC: 4AAEFFF8      TST.L      -8(A6)
09C0: 66AA          BNE.S      $096C
09C2: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
09C6: A8D9          MOVE.L     (A1)+,(A4)+
09C8: 48780003      PEA        $0003.W
09CC: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
09D0: 4EBAF62E      JSR        -2514(PC)
09D4: 2E80          MOVE.L     D0,(A7)
09D6: 4EBAF6C8      JSR        -2360(PC)
09DA: 2440          MOVEA.L    D0,A2
09DC: 200A          MOVE.L     A2,D0
09DE: 508F          MOVE.B     A7,(A0)
09E0: 6708          BEQ.S      $09EA
09E2: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
09E6: 4E92          JSR        (A2)
09E8: 588F          MOVE.B     A7,(A4)
09EA: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
09EE: A923          MOVE.L     -(A3),-(A4)
09F0: 6012          BRA.S      $0A04
09F2: 2D6C0002FFF4  MOVE.L     2(A4),-12(A6)
09F8: 2F0C          MOVE.L     A4,-(A7)
09FA: 2F2C0002      MOVE.L     2(A4),-(A7)
09FE: 4EBAF80E      JSR        -2034(PC)
0A02: 508F          MOVE.B     A7,(A0)
0A04: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
0A08: 4E5E          UNLK       A6
0A0A: 4E75          RTS        

0A0C: FFF8FFF8      MOVE.W     $FFF8.W,???
0A10: FDD6          MOVE.W     (A6),???
0A12: FE18          MOVE.W     (A0)+,D7
0A14: FDD6          MOVE.W     (A6),???
0A16: FE18          MOVE.W     (A0)+,D7
0A18: FE9E          MOVE.W     (A6)+,(A7)
0A1A: FDD6          MOVE.W     (A6),???
0A1C: FFE6          MOVE.W     -(A6),???
0A1E: FFF8FDD6      MOVE.W     $FDD6.W,???
0A22: FDD6          MOVE.W     (A6),???
0A24: FDD6          MOVE.W     (A6),???
0A26: FDD6          MOVE.W     (A6),???
0A28: FDD6          MOVE.W     (A6),???
0A2A: FDBEFC14      MOVE.W     ???,20(A6,A7.L*4)
0A2E: FC1A          MOVE.W     (A2)+,D6
0A30: FC02          MOVE.W     D2,D6
0A32: FC6AFC0E      MOVEA.W    -1010(A2),A6
0A36: FD0A          MOVE.W     A2,-(A6)
0A38: FD56FD20      MOVE.W     (A6),-736(A6)
0A3C: FD20          MOVE.W     -(A0),-(A6)

; ======= Function at 0x0A3E =======
0A3E: 4E560000      LINK       A6,#0
0A42: 0C6D0008A386  CMPI.W     #$0008,-23674(A5)
0A48: 6406          BCC.S      $0A50
0A4A: 4A6DA386      TST.W      -23674(A5)
0A4E: 6C04          BGE.S      $0A54
0A50: 4EBA0712      JSR        1810(PC)
0A54: 302DA386      MOVE.W     -23674(A5),D0                  ; A5-23674
0A58: 526DA386      MOVEA.B    -23674(A5),A1
0A5C: C1FC002C41ED  ANDA.L     #$002C41ED,A0
0A62: A226          MOVE.L     -(A6),D1
0A64: D088          MOVE.B     A0,(A0)
0A66: 2040          MOVEA.L    D0,A0
0A68: 7000          MOVEQ      #0,D0
0A6A: 43FA0006      LEA        6(PC),A1
0A6E: 48D0          DC.W       $48D0
0A70: DEF84A40      MOVE.B     $4A40.W,(A7)+
0A74: 6610          BNE.S      $0A86
0A76: 2F2E0008      MOVE.L     8(A6),-(A7)
0A7A: 4EBAFB6E      JSR        -1170(PC)
0A7E: 536DA386588F  MOVE.B     -23674(A5),22671(A1)           ; A5-23674
0A84: 6048          BRA.S      $0ACE
0A86: 2F2DA222      MOVE.L     -24030(A5),-(A7)               ; A5-24030
0A8A: 2F2D93AC      MOVE.L     -27732(A5),-(A7)               ; A5-27732
0A8E: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
0A92: 4A40          TST.W      D0
0A94: 508F          MOVE.B     A7,(A0)
0A96: 6606          BNE.S      $0A9E
0A98: 4267          CLR.W      -(A7)
0A9A: A9386030      MOVE.L     $6030.W,-(A4)
0A9E: 4A6DA386      TST.W      -23674(A5)
0AA2: 6E04          BGT.S      $0AA8
0AA4: 4EBA06BE      JSR        1726(PC)
0AA8: 2B6DA222A222  MOVE.L     -24030(A5),-24030(A5)          ; A5-24030
0AAE: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
0AB4: C1EDA386      ANDA.L     -23674(A5),A0
0AB8: 41EDA226      LEA        -24026(A5),A0                  ; g_common
0ABC: D088          MOVE.B     A0,(A0)
0ABE: 2040          MOVEA.L    D0,A0
0AC0: 7001          MOVEQ      #1,D0
0AC2: 4A40          TST.W      D0
0AC4: 6602          BNE.S      $0AC8
0AC6: 7001          MOVEQ      #1,D0
0AC8: 4CD8          DC.W       $4CD8
0ACA: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
0ACE: 4E5E          UNLK       A6
0AD0: 4E75          RTS        


; ======= Function at 0x0AD2 =======
0AD2: 4E56FFF0      LINK       A6,#-16                        ; frame=16
0AD6: 600E          BRA.S      $0AE6
0AD8: 486EFFF0      PEA        -16(A6)
0ADC: 3F2E0008      MOVE.W     8(A6),-(A7)
0AE0: 4EBA0072      JSR        114(PC)
0AE4: 5C8F          MOVE.B     A7,(A6)
0AE6: 4227          CLR.B      -(A7)
0AE8: 3F2E0008      MOVE.W     8(A6),-(A7)
0AEC: 486EFFF0      PEA        -16(A6)
0AF0: A9714A1F66E2  MOVE.L     31(A1,D4.L*2),26338(A4)
0AF6: 4E5E          UNLK       A6
0AF8: 4E75          RTS        


; ======= Function at 0x0AFA =======
0AFA: 4E560000      LINK       A6,#0
0AFE: 48E70038      MOVEM.L    A2/A3/A4,-(SP)                 ; save
0B02: 2F2E0008      MOVE.L     8(A6),-(A7)
0B06: 4EBAF4F8      JSR        -2824(PC)
0B0A: 2840          MOVEA.L    D0,A4
0B0C: 97CB7011      MOVE.B     A3,17(PC,D7.W)
0B10: 2E80          MOVE.L     D0,(A7)
0B12: 2F0C          MOVE.L     A4,-(A7)
0B14: 4EBAF58A      JSR        -2678(PC)
0B18: 2440          MOVEA.L    D0,A2
0B1A: 200A          MOVE.L     A2,D0
0B1C: 508F          MOVE.B     A7,(A0)
0B1E: 670E          BEQ.S      $0B2E
0B20: 2F2E000C      MOVE.L     12(A6),-(A7)
0B24: 2F2E0008      MOVE.L     8(A6),-(A7)
0B28: 4E92          JSR        (A2)
0B2A: 2640          MOVEA.L    D0,A3
0B2C: 508F          MOVE.B     A7,(A0)
0B2E: 2F2E000C      MOVE.L     12(A6),-(A7)
0B32: 4EAD0C0A      JSR        3082(A5)                       ; JT[3082]
0B36: 2840          MOVEA.L    D0,A4
0B38: 200B          MOVE.L     A3,D0
0B3A: 588F          MOVE.B     A7,(A4)
0B3C: 6602          BNE.S      $0B40
0B3E: 264C          MOVEA.L    A4,A3
0B40: 200B          MOVE.L     A3,D0
0B42: 6604          BNE.S      $0B48
0B44: 47EDFA5E      LEA        -1442(A5),A3                   ; A5-1442
0B48: 2F0B          MOVE.L     A3,-(A7)
0B4A: A851          MOVEA.L    (A1),A4
0B4C: 4CDF1C00      MOVEM.L    (SP)+,A2/A3/A4                 ; restore
0B50: 4E5E          UNLK       A6
0B52: 4E75          RTS        


; ======= Function at 0x0B54 =======
0B54: 4E56FFFE      LINK       A6,#-2                         ; frame=2
0B58: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
0B5C: 286E000A      MOVEA.L    10(A6),A4
0B60: A9B442273F2E  MOVE.L     39(A4,D4.W*2),46(A4,D3.L*8)
0B66: 00082F0C      ORI.B      #$2F0C,A0
0B6A: A9704A1F6708  MOVE.L     31(A0,D4.L*2),26376(A4)
0B70: 2F0C          MOVE.L     A4,-(A7)
0B72: 4EBAFECA      JSR        -310(PC)
0B76: 588F          MOVE.B     A7,(A4)
0B78: 0C540008      CMPI.W     #$0008,(A4)
0B7C: 665A          BNE.S      $0BD8
0B7E: 4EAD0C42      JSR        3138(A5)                       ; JT[3138]
0B82: 2640          MOVEA.L    D0,A3
0B84: 2F0B          MOVE.L     A3,-(A7)
0B86: 4EAD064A      JSR        1610(A5)                       ; JT[1610]
0B8A: 4A40          TST.W      D0
0B8C: 588F          MOVE.B     A7,(A4)
0B8E: 6714          BEQ.S      $0BA4
0B90: 0C6D0001935E  CMPI.W     #$0001,-27810(A5)
0B96: 6754          BEQ.S      $0BEC
0B98: 4EAD0622      JSR        1570(A5)                       ; JT[1570]
0B9C: 3B7C0001935E  MOVE.W     #$0001,-27810(A5)
0BA2: 6048          BRA.S      $0BEC
0BA4: 200B          MOVE.L     A3,D0
0BA6: 6610          BNE.S      $0BB8
0BA8: 4A6D935E      TST.W      -27810(A5)
0BAC: 673E          BEQ.S      $0BEC
0BAE: 4EAD062A      JSR        1578(A5)                       ; JT[1578]
0BB2: 426D935E      CLR.W      -27810(A5)
0BB6: 6034          BRA.S      $0BEC
0BB8: 2F0B          MOVE.L     A3,-(A7)
0BBA: 4EAD0652      JSR        1618(A5)                       ; JT[1618]
0BBE: 4A40          TST.W      D0
0BC0: 588F          MOVE.B     A7,(A4)
0BC2: 6728          BEQ.S      $0BEC
0BC4: 0C6D0002935E  CMPI.W     #$0002,-27810(A5)
0BCA: 6720          BEQ.S      $0BEC
0BCC: 4EAD062A      JSR        1578(A5)                       ; JT[1578]
0BD0: 3B7C0002935E  MOVE.W     #$0002,-27810(A5)
0BD6: 6014          BRA.S      $0BEC
0BD8: 4EAD0C42      JSR        3138(A5)                       ; JT[3138]
0BDC: 2640          MOVEA.L    D0,A3
0BDE: 200B          MOVE.L     A3,D0
0BE0: 670A          BEQ.S      $0BEC
0BE2: 2F0C          MOVE.L     A4,-(A7)
0BE4: 2F0B          MOVE.L     A3,-(A7)
0BE6: 4EBAFF12      JSR        -238(PC)
0BEA: 508F          MOVE.B     A7,(A0)
0BEC: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
0BF0: 4E5E          UNLK       A6
0BF2: 4E75          RTS        


; ======= Function at 0x0BF4 =======
0BF4: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0BF8: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
0BFC: 286E0008      MOVEA.L    8(A6),A4
0C00: 2F0C          MOVE.L     A4,-(A7)
0C02: 3F2E000C      MOVE.W     12(A6),-(A7)
0C06: A95D43EE      MOVE.L     (A5)+,17390(A4)
0C0A: FFFC307C      MOVE.W     #$307C,???
0C0E: 0002A03B      ORI.B      #$A03B,D2
0C12: 2280          MOVE.L     D0,(A1)
0C14: 48780015      PEA        $0015.W
0C18: 42A7          CLR.L      -(A7)
0C1A: 2F0C          MOVE.L     A4,-(A7)
0C1C: A95A4EBA      MOVE.L     (A2)+,20154(A4)
0C20: F480          MOVE.W     D0,(A2)
0C22: 2640          MOVEA.L    D0,A3
0C24: 4257          CLR.W      (A7)
0C26: 2F0C          MOVE.L     A4,-(A7)
0C28: 4E93          JSR        (A3)
0C2A: 2E8C          MOVE.L     A4,(A7)
0C2C: 4267          CLR.W      -(A7)
0C2E: A95D4CEE      MOVE.L     (A5)+,19694(A4)
0C32: 1800          MOVE.B     D0,D4
0C34: FFF44E5E      MOVE.W     94(A4,D4.L*8),???
0C38: 4E75          RTS        


; ======= Function at 0x0C3A =======
0C3A: 4E56FFF0      LINK       A6,#-16                        ; frame=16
0C3E: 2B78016AA38E  MOVE.L     $016A.W,-23666(A5)
0C44: 422DA388      CLR.B      -23672(A5)
0C48: 486EFFF0      PEA        -16(A6)
0C4C: 3F3CFFFF      MOVE.W     #$FFFF,-(A7)
0C50: 4EBAFF02      JSR        -254(PC)
0C54: 4E5E          UNLK       A6
0C56: 4E75          RTS        


; ======= Function at 0x0C58 =======
0C58: 4E560000      LINK       A6,#0
0C5C: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
0C60: 286E0008      MOVEA.L    8(A6),A4
0C64: 264C          MOVEA.L    A4,A3
0C66: D7EE000C6002  MOVE.B     12(A6),2(PC,D6.W)
0C6C: 421C          CLR.B      (A4)+
0C6E: B7CC62FA      MOVE.W     A4,-6(PC,D6.W)
0C72: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
0C76: 4E5E          UNLK       A6
0C78: 4E75          RTS        


; ======= Function at 0x0C7A =======
0C7A: 4E56FEE6      LINK       A6,#-282                       ; frame=282
0C7E: 0C6D0008A386  CMPI.W     #$0008,-23674(A5)
0C84: 6406          BCC.S      $0C8C
0C86: 4A6DA386      TST.W      -23674(A5)
0C8A: 6C04          BGE.S      $0C90
0C8C: 4EBA04D6      JSR        1238(PC)
0C90: 302DA386      MOVE.W     -23674(A5),D0                  ; A5-23674
0C94: 526DA386      MOVEA.B    -23674(A5),A1
0C98: C1FC002C41ED  ANDA.L     #$002C41ED,A0
0C9E: A226          MOVE.L     -(A6),D1
0CA0: D088          MOVE.B     A0,(A0)
0CA2: 2040          MOVEA.L    D0,A0
0CA4: 7000          MOVEQ      #0,D0
0CA6: 43FA0006      LEA        6(PC),A1
0CAA: 48D0          DC.W       $48D0
0CAC: DEF84A40      MOVE.B     $4A40.W,(A7)+
0CB0: 66000084      BNE.W      $0D38
0CB4: 4EAD030A      JSR        778(A5)                        ; JT[778]
0CB8: 486EFFFE      PEA        -2(A6)
0CBC: 486EFFFC      PEA        -4(A6)
0CC0: 4EAD0B8A      JSR        2954(A5)                       ; JT[2954]
0CC4: 3D7C0001FFFA  MOVE.W     #$0001,-6(A6)
0CCA: 6036          BRA.S      $0D02
0CCC: 3F2EFFFA      MOVE.W     -6(A6),-(A7)
0CD0: 486EFEF2      PEA        -270(A6)
0CD4: 4EAD0B92      JSR        2962(A5)                       ; JT[2962]
0CD8: 0CAE58474D45FEF4  CMPI.L     #$58474D45,-268(A6)
0CE0: 6614          BNE.S      $0CF6
0CE2: 486EFEFA      PEA        -262(A6)
0CE6: 3F2EFEF2      MOVE.W     -270(A6),-(A7)
0CEA: 4EAD05AA      JSR        1450(A5)                       ; JT[1450]
0CEE: 0C6E0001FFFE  CMPI.W     #$0001,-2(A6)
0CF4: 5C8F          MOVE.B     A7,(A6)
0CF6: 3F2EFFFA      MOVE.W     -6(A6),-(A7)
0CFA: 4EAD0B9A      JSR        2970(A5)                       ; JT[2970]
0CFE: 526EFFFA      MOVEA.B    -6(A6),A1
0D02: 302EFFFA      MOVE.W     -6(A6),D0
0D06: B06EFFFC      MOVEA.W    -4(A6),A0
0D0A: 6FC0          BLE.S      $0CCC
0D0C: 0C6E0001FFFE  CMPI.W     #$0001,-2(A6)
0D12: 671C          BEQ.S      $0D30
0D14: 4EBA03D4      JSR        980(PC)
0D18: 2F2DDE78      MOVE.L     -8584(A5),-(A7)                ; A5-8584
0D1C: A9AA4267A9AF  MOVE.L     16999(A2),-81(A4,A2.L)
0D22: 4A5F          TST.W      (A7)+
0D24: 6704          BEQ.S      $0D2A
0D26: 4EBA043C      JSR        1084(PC)
0D2A: 4267          CLR.W      -(A7)
0D2C: A994A999      MOVE.L     (A4),-103(A4,A2.L)
0D30: 536DA386600A  MOVE.B     -23674(A5),24586(A1)           ; A5-23674
0D36: 2F2DA222      MOVE.L     -24030(A5),-(A7)               ; A5-24030
0D3A: 4EAD0C7A      JSR        3194(A5)                       ; JT[3194]
0D3E: 588F          MOVE.B     A7,(A4)
0D40: 4EAD0662      JSR        1634(A5)                       ; JT[1634]
0D44: 4E5E          UNLK       A6
0D46: 4E75          RTS        

0D48: 486D0AC2      PEA        2754(A5)                       ; A5+2754
0D4C: A9F1486D0A92A9F1  MOVE.L     109(A1,D4.L),#$0A92A9F1
0D54: 486D0AA2      PEA        2722(A5)                       ; A5+2722
0D58: A9F1486D0822A9F1  MOVE.L     109(A1,D4.L),#$0822A9F1
0D60: 486D0862      PEA        2146(A5)                       ; A5+2146
0D64: A9F1486D08B2A9F1  MOVE.L     109(A1,D4.L),#$08B2A9F1
0D6C: 486D0AEA      PEA        2794(A5)                       ; A5+2794
0D70: A9F1486D0A7AA9F1  MOVE.L     109(A1,D4.L),#$0A7AA9F1
0D78: 486D0A1A      PEA        2586(A5)                       ; A5+2586
0D7C: A9F1486D0D72A9F1  MOVE.L     109(A1,D4.L),#$0D72A9F1
0D84: 486D0A3A      PEA        2618(A5)                       ; A5+2618
0D88: A9F1486D0A52A9F1  MOVE.L     109(A1,D4.L),#$0A52A9F1
0D90: 486D0912      PEA        2322(A5)                       ; A5+2322
0D94: A9F1486D0842A9F1  MOVE.L     109(A1,D4.L),#$0842A9F1
0D9C: 486D098A      PEA        2442(A5)                       ; A5+2442
0DA0: A9F14E754E56FF80  MOVE.L     117(A1,D4.L*8),#$4E56FF80
0DA8: 4EBAFF9E      JSR        -98(PC)
0DAC: 486D0D7A      PEA        3450(A5)                       ; A5+3450
0DB0: A9F1486D0C62A9F1  MOVE.L     109(A1,D4.L),#$0C62A9F1
0DB8: 486D09F2      PEA        2546(A5)                       ; A5+2546
0DBC: A9F1486D0DF2A9F1  MOVE.L     109(A1,D4.L),#$0DF2A9F1
0DC4: 486D00C2      PEA        194(A5)                        ; A5+194
0DC8: A9F1486D0082A9F1  MOVE.L     109(A1,D4.L),#$0082A9F1
0DD0: 486D0582      PEA        1410(A5)                       ; A5+1410
0DD4: A9F1486D059AA9F1  MOVE.L     109(A1,D4.L),#$059AA9F1
0DDC: 486D0362      PEA        866(A5)                        ; A5+866
0DE0: A9F1486D0C6AA9F1  MOVE.L     109(A1,D4.L),#$0C6AA9F1
0DE8: 486D05B2      PEA        1458(A5)                       ; A5+1458
0DEC: A9F1486D0C22A9F1  MOVE.L     109(A1,D4.L),#$0C22A9F1
0DF4: 486D0812      PEA        2066(A5)                       ; A5+2066
0DF8: A9F1486D0312A9F1  MOVE.L     109(A1,D4.L),#$0312A9F1
0E00: 486D030A      PEA        778(A5)                        ; A5+778
0E04: A9F1486D0242A9F1  MOVE.L     109(A1,D4.L),#$0242A9F1
0E0C: 486D02C2      PEA        706(A5)                        ; A5+706
0E10: A9F1486D0A4AA9F1  MOVE.L     109(A1,D4.L),#$0A4AA9F1
0E18: 486D027A      PEA        634(A5)                        ; A5+634
0E1C: A9F1486D0D22A9F1  MOVE.L     109(A1,D4.L),#$0D22A9F1
0E24: 486D0342      PEA        834(A5)                        ; A5+834
0E28: A9F1486D05EAA9F1  MOVE.L     109(A1,D4.L),#$05EAA9F1
0E30: 486D0D12      PEA        3346(A5)                       ; A5+3346
0E34: A9F1486D0DDAA9F1  MOVE.L     109(A1,D4.L),#$0DDAA9F1
0E3C: 486D0DCA      PEA        3530(A5)                       ; A5+3530
0E40: A9F1486D0DA2A9F1  MOVE.L     109(A1,D4.L),#$0DA2A9F1
0E48: 486D0D82      PEA        3458(A5)                       ; A5+3458
0E4C: A9F1486D0482A9F1  MOVE.L     109(A1,D4.L),#$0482A9F1
0E54: 486D00F2      PEA        242(A5)                        ; A5+242
0E58: A9F1486D0D62A9F1  MOVE.L     109(A1,D4.L),#$0D62A9F1
0E60: 486D0412      PEA        1042(A5)                       ; A5+1042
0E64: A9F1486D0742A9F1  MOVE.L     109(A1,D4.L),#$0742A9F1
0E6C: 486D07DA      PEA        2010(A5)                       ; A5+2010
0E70: A9F1486D0DFAA9F1  MOVE.L     109(A1,D4.L),#$0DFAA9F1
0E78: 486D00A2      PEA        162(A5)                        ; A5+162
0E7C: A9F1486D011AA9F1  MOVE.L     109(A1,D4.L),#$011AA9F1
0E84: 486D0172      PEA        370(A5)                        ; A5+370
0E88: A9F1486D0182A9F1  MOVE.L     109(A1,D4.L),#$0182A9F1
0E90: 486D0CAA      PEA        3242(A5)                       ; A5+3242
0E94: A9F1486D0372A9F1  MOVE.L     109(A1,D4.L),#$0372A9F1
0E9C: 302DDE66      MOVE.W     -8602(A5),D0                   ; A5-8602
0EA0: 57400C40      MOVE.B     D0,3136(A3)
0EA4: 00056200      ORI.B      #$6200,D5
0EA8: 023243FA0232  ANDI.B     #$43FA,50(A2,D0.W*2)
0EAE: D040          MOVEA.B    D0,A0
0EB0: D2F10000      MOVE.B     0(A1,D0.W),(A1)+
0EB4: 4ED1          JMP        (A1)
0EB6: 486DF2BC      PEA        -3396(A5)                      ; A5-3396
0EBA: A851          MOVEA.L    (A1),A4
0EBC: 4EAD0412      JSR        1042(A5)                       ; JT[1042]
0EC0: 42ADC372      CLR.L      -15502(A5)
0EC4: 42ADC36E      CLR.L      -15506(A5)
0EC8: 7000          MOVEQ      #0,D0
0ECA: 1B40C366      MOVE.B     D0,-15514(A5)
0ECE: 1B40C35E      MOVE.B     D0,-15522(A5)
0ED2: 4880          EXT.W      D0
0ED4: 3B40B3F2      MOVE.W     D0,-19470(A5)
0ED8: 4EAD04EA      JSR        1258(A5)                       ; JT[1258]
0EDC: 4EAD00EA      JSR        234(A5)                        ; JT[234]
0EE0: 486DC35E      PEA        -15522(A5)                     ; g_field_22
0EE4: 4EAD0582      JSR        1410(A5)                       ; JT[1410]
0EE8: 486DC366      PEA        -15514(A5)                     ; g_field_14
0EEC: 4EAD0582      JSR        1410(A5)                       ; JT[1410]
0EF0: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
0EF4: A850          MOVEA.L    (A0),A4
0EF6: 4EAD0122      JSR        290(A5)                        ; JT[290]
0EFA: 42ADDE56      CLR.L      -8618(A5)
0EFE: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
0F02: B1EDC376508F  MOVE.W     -15498(A5),$508F.W             ; A5-15498
0F08: 6604          BNE.S      $0F0E
0F0A: 7002          MOVEQ      #2,D0
0F0C: 6002          BRA.S      $0F10
0F0E: 7003          MOVEQ      #3,D0
0F10: 3B40DE64      MOVE.W     D0,-8604(A5)
0F14: 48780058      PEA        $0058.W
0F18: 486DA498      PEA        -23400(A5)                     ; A5-23400
0F1C: 4EBAFD3A      JSR        -710(PC)
0F20: 7058          MOVEQ      #88,D0
0F22: 2E80          MOVE.L     D0,(A7)
0F24: 486DA4F0      PEA        -23312(A5)                     ; A5-23312
0F28: 4EBAFD2E      JSR        -722(PC)
0F2C: 4FEF000C      LEA        12(A7),A7
0F30: 600001A8      BRA.W      $10DC
0F34: 2B78016ADE5A  MOVE.L     $016A.W,-8614(A5)
0F3A: 48780022      PEA        $0022.W
0F3E: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0F42: 4EBAFD14      JSR        -748(PC)
0F46: 7008          MOVEQ      #8,D0
0F48: 2E80          MOVE.L     D0,(A7)
0F4A: 486DA74E      PEA        -22706(A5)                     ; A5-22706
0F4E: 4EBAFD08      JSR        -760(PC)
0F52: 4FEF000C      LEA        12(A7),A7
0F56: 60000182      BRA.W      $10DC
0F5A: 41ED0172      LEA        370(A5),A0                     ; A5+370
0F5E: 2B48B3EE      MOVE.L     A0,-19474(A5)
0F62: 2F2DC376      MOVE.L     -15498(A5),-(A7)               ; A5-15498
0F66: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
0F6A: 4EAD0982      JSR        2434(A5)                       ; JT[2434]
0F6E: 202DC372      MOVE.L     -15502(A5),D0                  ; g_size2=65536
0F72: D0ADA5DE      MOVE.B     -23074(A5),(A0)                ; g_dawg_ptr
0F76: 2E80          MOVE.L     D0,(A7)
0F78: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0F7C: 486DDED6      PEA        -8490(A5)                      ; A5-8490
0F80: 4EAD013A      JSR        314(A5)                        ; JT[314]
0F84: 202DA5DE      MOVE.L     -23074(A5),D0                  ; g_dawg_ptr
0F88: D1ADC3724EAD  MOVE.B     -15502(A5),-83(A0,D4.L*8)      ; g_size2=65536
0F8E: 04EA          DC.W       $04EA
0F90: 3EBC0001      MOVE.W     #$0001,(A7)
0F94: 2F2DC376      MOVE.L     -15498(A5),-(A7)               ; A5-15498
0F98: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0F9C: 4EAD0942      JSR        2370(A5)                       ; JT[2370]
0FA0: 486DA498      PEA        -23400(A5)                     ; A5-23400
0FA4: 486DA440      PEA        -23488(A5)                     ; A5-23488
0FA8: 4EAD034A      JSR        842(A5)                        ; JT[842]
0FAC: 42ADB3EE      CLR.L      -19474(A5)
0FB0: 2EADC376      MOVE.L     -15498(A5),(A7)                ; A5-15498
0FB4: 4EAD0582      JSR        1410(A5)                       ; JT[1410]
0FB8: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
0FBC: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
0FC0: 2B48C376      MOVE.L     A0,-15498(A5)
0FC4: 4EAD0292      JSR        658(A5)                        ; JT[658]
0FC8: 4297          CLR.L      (A7)
0FCA: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0FCE: 4EAD016A      JSR        362(A5)                        ; JT[362]
0FD2: 4EAD092A      JSR        2346(A5)                       ; JT[2346]
0FD6: 4A40          TST.W      D0
0FD8: 4FEF0020      LEA        32(A7),A7
0FDC: 6704          BEQ.S      $0FE2
0FDE: 7004          MOVEQ      #4,D0
0FE0: 6002          BRA.S      $0FE4
0FE2: 7002          MOVEQ      #2,D0
0FE4: 3B40DE64      MOVE.W     D0,-8604(A5)
0FE8: 48780022      PEA        $0022.W
0FEC: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0FF0: 4EBAFC66      JSR        -922(PC)
0FF4: 508F          MOVE.B     A7,(A0)
0FF6: 600000E2      BRA.W      $10DC
0FFA: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
0FFE: B1EDC3766704  MOVE.W     -15498(A5),$6704.W             ; A5-15498
1004: 4EBA015E      JSR        350(PC)
1008: 41ED01CA      LEA        458(A5),A0                     ; A5+458
100C: 2B48A38A      MOVE.L     A0,-23670(A5)
1010: 4EBAFC28      JSR        -984(PC)
1014: 426DDE64      CLR.W      -8604(A5)
1018: 48780078      PEA        $0078.W
101C: 2F2DC376      MOVE.L     -15498(A5),-(A7)               ; A5-15498
1020: 4EAD028A      JSR        650(A5)                        ; JT[650]
1024: 2040          MOVEA.L    D0,A0
1026: 43EDA5CE      LEA        -23090(A5),A1                  ; g_dawg_info
102A: 7007          MOVEQ      #7,D0
102C: 22D8          MOVE.L     (A0)+,(A1)+
102E: 51C8FFFC      DBF        D0,$102C                       ; loop
1032: 32D8          MOVE.W     (A0)+,(A1)+
1034: 42ADA38A      CLR.L      -23670(A5)
1038: 202DA5DE      MOVE.L     -23074(A5),D0                  ; g_dawg_ptr
103C: D1ADC36E4EAD  MOVE.B     -15506(A5),-83(A0,D4.L*8)      ; g_size1=56630
1042: 04EA          DC.W       $04EA
1044: 2EADC36E      MOVE.L     -15506(A5),(A7)                ; g_size1=56630
1048: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
104C: 486DDEF0      PEA        -8464(A5)                      ; A5-8464
1050: 4EAD013A      JSR        314(A5)                        ; JT[314]
1054: 3EBC0001      MOVE.W     #$0001,(A7)
1058: 2F2DC376      MOVE.L     -15498(A5),-(A7)               ; A5-15498
105C: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
1060: 4EAD0942      JSR        2370(A5)                       ; JT[2370]
1064: 486DA4F0      PEA        -23312(A5)                     ; A5-23312
1068: 486DA440      PEA        -23488(A5)                     ; A5-23488
106C: 4EAD034A      JSR        842(A5)                        ; JT[842]
1070: 2EADC376      MOVE.L     -15498(A5),(A7)                ; A5-15498
1074: 4EAD0582      JSR        1410(A5)                       ; JT[1410]
1078: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
107C: 2B48C376      MOVE.L     A0,-15498(A5)
1080: 4EAD0292      JSR        658(A5)                        ; JT[658]
1084: 2EBC00010001  MOVE.L     #$00010001,(A7)
108A: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
108E: 4EAD016A      JSR        362(A5)                        ; JT[362]
1092: 4EAD092A      JSR        2346(A5)                       ; JT[2346]
1096: 4A40          TST.W      D0
1098: 4FEF0024      LEA        36(A7),A7
109C: 6704          BEQ.S      $10A2
109E: 7004          MOVEQ      #4,D0
10A0: 6002          BRA.S      $10A4
10A2: 7003          MOVEQ      #3,D0
10A4: 3B40DE64      MOVE.W     D0,-8604(A5)
10A8: 6030          BRA.S      $10DA
10AA: 4EAD015A      JSR        346(A5)                        ; JT[346]
10AE: 42ADC376      CLR.L      -15498(A5)
10B2: 3B7C0005DE64  MOVE.W     #$0005,-8604(A5)
10B8: 4EAD011A      JSR        282(A5)                        ; JT[282]
10BC: 4A40          TST.W      D0
10BE: 670E          BEQ.S      $10CE
10C0: 2F2DC36E      MOVE.L     -15506(A5),-(A7)               ; g_size1=56630
10C4: 2F2DC372      MOVE.L     -15502(A5),-(A7)               ; g_size2=65536
10C8: 4EAD0DFA      JSR        3578(A5)                       ; JT[3578]
10CC: 508F          MOVE.B     A7,(A0)
10CE: 42A7          CLR.L      -(A7)
10D0: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
10D4: 4EAD04C2      JSR        1218(A5)                       ; JT[1218]
10D8: 508F          MOVE.B     A7,(A0)
10DA: 4E5E          UNLK       A6
10DC: 4E75          RTS        

10DE: FDD8          MOVE.W     (A0)+,???
10E0: FF1C          MOVE.W     (A4)+,-(A7)
10E2: FE56          MOVEA.W    (A6),A7
10E4: FFCC          MOVE.W     A4,???
10E6: FE7CFE5C      MOVEA.W    #$FE5C,A7
10EA: 3B7C0001DE66  MOVE.W     #$0001,-8602(A5)
10F0: 4EBAFCB2      JSR        -846(PC)
10F4: 4A6DDE64      TST.W      -8604(A5)
10F8: 660C          BNE.S      $1106
10FA: 4EBAFB3E      JSR        -1218(PC)
10FE: 4EBA001C      JSR        28(PC)
1102: 4A40          TST.W      D0
1104: 67F4          BEQ.S      $10FA
1106: 4EBA0014      JSR        20(PC)
110A: 3B40DE66      MOVE.W     D0,-8602(A5)
110E: 426DDE64      CLR.W      -8604(A5)
1112: 0C6D0002DE66  CMPI.W     #$0002,-8602(A5)
1118: 66D6          BNE.S      $10F0
111A: 4E75          RTS        

111C: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
1120: 4A6DDE64      TST.W      -8604(A5)
1124: 6736          BEQ.S      $115C
1126: 49EDA184      LEA        -24188(A5),A4                  ; A5-24188
112A: 47EDA14C      LEA        -24244(A5),A3                  ; A5-24244
112E: 6028          BRA.S      $1158
1130: 1E13          MOVE.B     (A3),D7
1132: 1007          MOVE.B     D7,D0
1134: 4880          EXT.W      D0
1136: B06DDE66      MOVEA.W    -8602(A5),A0
113A: 6706          BEQ.S      $1142
113C: 0C0700FF      CMPI.B     #$00FF,D7
1140: 6614          BNE.S      $1156
1142: 102B0001      MOVE.B     1(A3),D0
1146: 4880          EXT.W      D0
1148: B06DDE64      MOVEA.W    -8604(A5),A0
114C: 6608          BNE.S      $1156
114E: 102B0002      MOVE.B     2(A3),D0
1152: 4880          EXT.W      D0
1154: 6008          BRA.S      $115E
1156: 588B          MOVE.B     A3,(A4)
1158: B9CB62D4      MOVE.W     A3,#$62D4
115C: 7000          MOVEQ      #0,D0
115E: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
1162: 4E75          RTS        

1164: A9FF4E754E56  MOVE.L     ???,#$4E754E56
116A: 00000C6D      ORI.B      #$0C6D,D0
116E: 0004DE66      ORI.B      #$DE66,D4
1172: 56C0          SNE        D0
1174: 4400          NEG.B      D0
1176: 4880          EXT.W      D0
1178: 48C0          EXT.L      D0
117A: 4E5E          UNLK       A6
117C: 4E75          RTS        
