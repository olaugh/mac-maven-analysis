;======================================================================
; CODE 46 Disassembly
; File: /tmp/maven_code_46.bin
; Header: JT offset=3032, JT entries=12
; Code size: 2904 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0008: 286E000E      MOVEA.L    14(A6),A4
000C: 3E2E000C      MOVE.W     12(A6),D7
0010: 4A47          TST.W      D7
0012: 660E          BNE.S      $0022
0014: 2F2E0008      MOVE.L     8(A6),-(A7)
0018: 2F0C          MOVE.L     A4,-(A7)
001A: 4EBA024C      JSR        588(PC)
001E: 508F          MOVE.B     A7,(A0)
0020: 6050          BRA.S      $0072
0022: 0C470002      CMPI.W     #$0002,D7
0026: 660A          BNE.S      $0032
0028: 2F0C          MOVE.L     A4,-(A7)
002A: 4EBA0452      JSR        1106(PC)
002E: 588F          MOVE.B     A7,(A4)
0030: 6040          BRA.S      $0072
0032: 0C470001      CMPI.W     #$0001,D7
0036: 6614          BNE.S      $004C
0038: 2F2E0008      MOVE.L     8(A6),-(A7)
003C: 3F2E0012      MOVE.W     18(A6),-(A7)
0040: 2F0C          MOVE.L     A4,-(A7)
0042: 4EBA04C8      JSR        1224(PC)
0046: 2D400014      MOVE.L     D0,20(A6)
004A: 602A          BRA.S      $0076
004C: 0C470006      CMPI.W     #$0006,D7
0050: 6610          BNE.S      $0062
0052: 4A6E0012      TST.W      18(A6)
0056: 660A          BNE.S      $0062
0058: 2F0C          MOVE.L     A4,-(A7)
005A: 4EBA00A4      JSR        164(PC)
005E: 588F          MOVE.B     A7,(A4)
0060: 6010          BRA.S      $0072
0062: 0C470005      CMPI.W     #$0005,D7
0066: 660A          BNE.S      $0072
0068: 2F2E0008      MOVE.L     8(A6),-(A7)
006C: 4EBA0018      JSR        24(PC)
0070: 588F          MOVE.B     A7,(A4)
0072: 42AE0014      CLR.L      20(A6)
0076: 4CEE1080FFF8  MOVEM.L    -8(A6),D7/A4
007C: 4E5E          UNLK       A6
007E: 205F          MOVEA.L    (A7)+,A0
0080: 4FEF000C      LEA        12(A7),A7
0084: 4ED0          JMP        (A0)

; ======= Function at 0x0086 =======
0086: 4E56FFF8      LINK       A6,#-8                         ; frame=8
008A: 2F0C          MOVE.L     A4,-(A7)
008C: 286E0008      MOVEA.L    8(A6),A4
0090: 2D54FFF8      MOVE.L     (A4),-8(A6)
0094: 2D6C0004FFFC  MOVE.L     4(A4),-4(A6)
009A: 486EFFF8      PEA        -8(A6)
009E: 4878FFFF      PEA        $FFFF.W
00A2: A8A9486E      MOVE.L     18542(A1),(A4)
00A6: FFF8A8A1      MOVE.W     $A8A1.W,???
00AA: 3F2C0002      MOVE.W     2(A4),-(A7)
00AE: 3F14          MOVE.W     (A4),-(A7)
00B0: A893          MOVE.L     (A3),(A4)
00B2: 2F3CFFF30000  MOVE.L     #$FFF30000,-(A7)
00B8: A892          MOVE.L     (A2),(A4)
00BA: 302C0006      MOVE.W     6(A4),D0
00BE: 906C0002      MOVEA.B    2(A4),A0
00C2: 3F00          MOVE.W     D0,-(A7)
00C4: 4267          CLR.W      -(A7)
00C6: A892          MOVE.L     (A2),(A4)
00C8: 2F3C000D0000  MOVE.L     #$000D0000,-(A7)
00CE: A892          MOVE.L     (A2),(A4)
00D0: 2F3C0000FFF1  MOVE.L     #$0000FFF1,-(A7)
00D6: A894          MOVE.L     (A4),(A4)
00D8: 4267          CLR.W      -(A7)
00DA: 302C0004      MOVE.W     4(A4),D0
00DE: 9054          MOVEA.B    (A4),A0
00E0: 3F00          MOVE.W     D0,-(A7)
00E2: A892          MOVE.L     (A2),(A4)
00E4: 2F3CFFF1000F  MOVE.L     #$FFF1000F,-(A7)
00EA: A894          MOVE.L     (A4),(A4)
00EC: 302C0002      MOVE.W     2(A4),D0
00F0: 906C0006      MOVEA.B    6(A4),A0
00F4: 3F00          MOVE.W     D0,-(A7)
00F6: 4267          CLR.W      -(A7)
00F8: A892          MOVE.L     (A2),(A4)
00FA: 285F          MOVEA.L    (A7)+,A4
00FC: 4E5E          UNLK       A6
00FE: 4E75          RTS        


; ======= Function at 0x0100 =======
0100: 4E56FFEC      LINK       A6,#-20                        ; frame=20
0104: 486EFFF0      PEA        -16(A6)
0108: A8742F2E      MOVEA.L    46(A4,D2.L*8),A4
010C: 0008A873      ORI.B      #$A873,A0
0110: 206E0008      MOVEA.L    8(A6),A0
0114: 2D680010FFF8  MOVE.L     16(A0),-8(A6)
011A: 2D680014FFFC  MOVE.L     20(A0),-4(A6)
0120: 70F2          MOVEQ      #-14,D0
0122: D06EFFFE      MOVEA.B    -2(A6),A0
0126: 3D40FFFA      MOVE.W     D0,-6(A6)
012A: 70F2          MOVEQ      #-14,D0
012C: D06EFFFC      MOVEA.B    -4(A6),A0
0130: 3D40FFF8      MOVE.W     D0,-8(A6)
0134: 486EFFF8      PEA        -8(A6)
0138: A8A3          MOVE.L     -(A3),(A4)
013A: 486EFFF8      PEA        -8(A6)
013E: 4878FFFF      PEA        $FFFF.W
0142: A8A9486E      MOVE.L     18542(A1),(A4)
0146: FFF8A8A1      MOVE.W     $A8A1.W,???
014A: 4EBA08DA      JSR        2266(PC)
014E: B0AE0008      MOVE.W     8(A6),(A0)
0152: 665C          BNE.S      $01B0
0154: 2D6EFFFCFFF4  MOVE.L     -4(A6),-12(A6)
015A: 70F3          MOVEQ      #-13,D0
015C: D06EFFF6      MOVEA.B    -10(A6),A0
0160: 3F00          MOVE.W     D0,-(A7)
0162: 70F3          MOVEQ      #-13,D0
0164: D06EFFF4      MOVEA.B    -12(A6),A0
0168: 3F00          MOVE.W     D0,-(A7)
016A: A893          MOVE.L     (A3),(A4)
016C: 48780006      PEA        $0006.W
0170: A892          MOVE.L     (A2),(A4)
0172: 2F3C00060000  MOVE.L     #$00060000,-(A7)
0178: A892          MOVE.L     (A2),(A4)
017A: 2F3C0000FFFA  MOVE.L     #$0000FFFA,-(A7)
0180: A892          MOVE.L     (A2),(A4)
0182: 2F3CFFFA0000  MOVE.L     #$FFFA0000,-(A7)
0188: A892          MOVE.L     (A2),(A4)
018A: 2F3C00020006  MOVE.L     #$00020006,-(A7)
0190: A894          MOVE.L     (A4),(A4)
0192: 48780004      PEA        $0004.W
0196: A892          MOVE.L     (A2),(A4)
0198: 2F3C00080000  MOVE.L     #$00080000,-(A7)
019E: A892          MOVE.L     (A2),(A4)
01A0: 2F3C0000FFF8  MOVE.L     #$0000FFF8,-(A7)
01A6: A892          MOVE.L     (A2),(A4)
01A8: 2F3CFFFC0000  MOVE.L     #$FFFC0000,-(A7)
01AE: A892          MOVE.L     (A2),(A4)
01B0: 2F2EFFF0      MOVE.L     -16(A6),-(A7)
01B4: A8734E5E      MOVEA.L    94(A3,D4.L*8),A4
01B8: 4E75          RTS        


; ======= Function at 0x01BA =======
01BA: 4E56FFF8      LINK       A6,#-8                         ; frame=8
01BE: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
01C2: 286E0008      MOVEA.L    8(A6),A4
01C6: 2E3C00AA00AA  MOVE.L     #$00AA00AA,D7
01CC: 2C3C00550055  MOVE.L     #$00550055,D6
01D2: 082C00000003  BTST       #0,3(A4)
01D8: 6704          BEQ.S      $01DE
01DA: 2006          MOVE.L     D6,D0
01DC: 6002          BRA.S      $01E0
01DE: 2007          MOVE.L     D7,D0
01E0: 2D40FFF8      MOVE.L     D0,-8(A6)
01E4: 082C00000001  BTST       #0,1(A4)
01EA: 670A          BEQ.S      $01F6
01EC: 202EFFF8      MOVE.L     -8(A6),D0
01F0: E1882D40      MOVE.L     A0,64(A0,D2.L*4)
01F4: FFF82D6E      MOVE.W     $2D6E.W,???
01F8: FFF8FFFC      MOVE.W     $FFFC.W,???
01FC: 2F0C          MOVE.L     A4,-(A7)
01FE: 486EFFF8      PEA        -8(A6)
0202: A8A5          MOVE.L     -(A5),(A4)
0204: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
0208: 4E5E          UNLK       A6
020A: 4E75          RTS        


; ======= Function at 0x020C =======
020C: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0210: 206E0008      MOVEA.L    8(A6),A0
0214: 20680072      MOVEA.L    114(A0),A0
0218: 2050          MOVEA.L    (A0),A0
021A: 226E000C      MOVEA.L    12(A6),A1
021E: 22A80002      MOVE.L     2(A0),(A1)
0222: 236800060004  MOVE.L     6(A0),4(A1)
0228: 700D          MOVEQ      #13,D0
022A: D051          MOVEA.B    (A1),A0
022C: 33400004      MOVE.W     D0,4(A1)
0230: 4E5E          UNLK       A6
0232: 4E75          RTS        


; ======= Function at 0x0234 =======
0234: 4E560000      LINK       A6,#0
0238: 2F0C          MOVE.L     A4,-(A7)
023A: 286E000C      MOVEA.L    12(A6),A4
023E: 2F0C          MOVE.L     A4,-(A7)
0240: 2F2E0008      MOVE.L     8(A6),-(A7)
0244: 4EBAFFC6      JSR        -58(PC)
0248: 5454          MOVEA.B    (A4),A2
024A: 5E6C0002      MOVEA.B    2(A4),A7
024E: 7009          MOVEQ      #9,D0
0250: D054          MOVEA.B    (A4),A0
0252: 39400004      MOVE.W     D0,4(A4)
0256: 7009          MOVEQ      #9,D0
0258: D06C0002      MOVEA.B    2(A4),A0
025C: 39400006      MOVE.W     D0,6(A4)
0260: 286EFFFC      MOVEA.L    -4(A6),A4
0264: 4E5E          UNLK       A6
0266: 4E75          RTS        


; ======= Function at 0x0268 =======
0268: 4E56FEF8      LINK       A6,#-264                       ; frame=264
026C: 48E71F08      MOVEM.L    D3/D4/D5/D6/D7/A4,-(SP)        ; save
0270: 286E0008      MOVEA.L    8(A6),A4
0274: 4A2C006E      TST.B      110(A4)
0278: 670001FC      BEQ.W      $0478
027C: 4AAE000C      TST.L      12(A6)
0280: 670000B2      BEQ.W      $0336
0284: 486EFFF8      PEA        -8(A6)
0288: 2F0C          MOVE.L     A4,-(A7)
028A: 4EBAFFA8      JSR        -88(PC)
028E: 207809DE      MOVEA.L    $09DE.W,A0
0292: 3E280038      MOVE.W     56(A0),D7
0296: 3EBC000A      MOVE.W     #$000A,(A7)
029A: A89C          MOVE.L     (A4)+,(A4)
029C: 7002          MOVEQ      #2,D0
029E: D06EFFFA      MOVEA.B    -6(A6),A0
02A2: 3E80          MOVE.W     D0,(A7)
02A4: 7002          MOVEQ      #2,D0
02A6: D06EFFF8      MOVEA.B    -8(A6),A0
02AA: 3F00          MOVE.W     D0,-(A7)
02AC: A893          MOVE.L     (A3),(A4)
02AE: 70FD          MOVEQ      #-3,D0
02B0: D06EFFFE      MOVEA.B    -2(A6),A0
02B4: 3E80          MOVE.W     D0,(A7)
02B6: 70FD          MOVEQ      #-3,D0
02B8: D06EFFFC      MOVEA.B    -4(A6),A0
02BC: 3F00          MOVE.W     D0,-(A7)
02BE: A891          MOVE.L     (A1),(A4)
02C0: 70FD          MOVEQ      #-3,D0
02C2: D06EFFFE      MOVEA.B    -2(A6),A0
02C6: 3E80          MOVE.W     D0,(A7)
02C8: 7002          MOVEQ      #2,D0
02CA: D06EFFF8      MOVEA.B    -8(A6),A0
02CE: 3F00          MOVE.W     D0,-(A7)
02D0: A893          MOVE.L     (A3),(A4)
02D2: 7002          MOVEQ      #2,D0
02D4: D06EFFFA      MOVEA.B    -6(A6),A0
02D8: 3F00          MOVE.W     D0,-(A7)
02DA: 70FD          MOVEQ      #-3,D0
02DC: D06EFFFC      MOVEA.B    -4(A6),A0
02E0: 3F00          MOVE.W     D0,-(A7)
02E2: A891          MOVE.L     (A1),(A4)
02E4: 7004          MOVEQ      #4,D0
02E6: D06EFFFA      MOVEA.B    -6(A6),A0
02EA: 3F00          MOVE.W     D0,-(A7)
02EC: 7001          MOVEQ      #1,D0
02EE: D06EFFF8      MOVEA.B    -8(A6),A0
02F2: 3F00          MOVE.W     D0,-(A7)
02F4: A893          MOVE.L     (A3),(A4)
02F6: 7004          MOVEQ      #4,D0
02F8: D06EFFFA      MOVEA.B    -6(A6),A0
02FC: 3F00          MOVE.W     D0,-(A7)
02FE: 70FE          MOVEQ      #-2,D0
0300: D06EFFFC      MOVEA.B    -4(A6),A0
0304: 3F00          MOVE.W     D0,-(A7)
0306: A891          MOVE.L     (A1),(A4)
0308: 7001          MOVEQ      #1,D0
030A: D06EFFFA      MOVEA.B    -6(A6),A0
030E: 3F00          MOVE.W     D0,-(A7)
0310: 7004          MOVEQ      #4,D0
0312: D06EFFF8      MOVEA.B    -8(A6),A0
0316: 3F00          MOVE.W     D0,-(A7)
0318: A893          MOVE.L     (A3),(A4)
031A: 70FE          MOVEQ      #-2,D0
031C: D06EFFFE      MOVEA.B    -2(A6),A0
0320: 3F00          MOVE.W     D0,-(A7)
0322: 7004          MOVEQ      #4,D0
0324: D06EFFF8      MOVEA.B    -8(A6),A0
0328: 3F00          MOVE.W     D0,-(A7)
032A: A891          MOVE.L     (A1),(A4)
032C: 3F07          MOVE.W     D7,-(A7)
032E: A89C          MOVE.L     (A4)+,(A4)
0330: 60000144      BRA.W      $0478
0334: 486EFFF8      PEA        -8(A6)
0338: 2F0C          MOVE.L     A4,-(A7)
033A: 4EBAFED0      JSR        -304(PC)
033E: A89E          MOVE.L     (A6)+,(A4)
0340: 486EFFF8      PEA        -8(A6)
0344: A8A1          MOVE.L     -(A1),(A4)
0346: 486EFFF8      PEA        -8(A6)
034A: 2F3C00010001  MOVE.L     #$00010001,-(A7)
0350: A8A9486E      MOVE.L     18542(A1),(A4)
0354: FFF8A8A3      MOVE.W     $A8A3.W,???
0358: 4A2C006F      TST.B      111(A4)
035C: 508F          MOVE.B     A7,(A0)
035E: 6734          BEQ.S      $0394
0360: 486EFFF8      PEA        -8(A6)
0364: 4EBAFE54      JSR        -428(PC)
0368: 4A2C0070      TST.B      112(A4)
036C: 588F          MOVE.B     A7,(A4)
036E: 6724          BEQ.S      $0394
0370: 486EFFF8      PEA        -8(A6)
0374: 2F0C          MOVE.L     A4,-(A7)
0376: 4EBAFEBC      JSR        -324(PC)
037A: 486EFFF8      PEA        -8(A6)
037E: A8A1          MOVE.L     -(A1),(A4)
0380: 486EFFF8      PEA        -8(A6)
0384: 2F3C00010001  MOVE.L     #$00010001,-(A7)
038A: A8A9486E      MOVE.L     18542(A1),(A4)
038E: FFF8A8A3      MOVE.W     $A8A3.W,???
0392: 508F          MOVE.B     A7,(A0)
0394: 207809DE      MOVEA.L    $09DE.W,A0
0398: 3C280044      MOVE.W     68(A0),D6
039C: 207809DE      MOVEA.L    $09DE.W,A0
03A0: 7A00          MOVEQ      #0,D5
03A2: 1A280046      MOVE.B     70(A0),D5
03A6: 207809DE      MOVEA.L    $09DE.W,A0
03AA: 3E280048      MOVE.W     72(A0),D7
03AE: 207809DE      MOVEA.L    $09DE.W,A0
03B2: 3828004A      MOVE.W     74(A0),D4
03B6: 3F3C0004      MOVE.W     #$0004,-(A7)
03BA: A887          MOVE.L     D7,(A4)
03BC: 3F3C0001      MOVE.W     #$0001,-(A7)
03C0: A888          MOVE.L     A0,(A4)
03C2: 4267          CLR.W      -(A7)
03C4: A889          MOVE.L     A1,(A4)
03C6: 3F3C0009      MOVE.W     #$0009,-(A7)
03CA: A88A          MOVE.L     A2,(A4)
03CC: 486EFFF8      PEA        -8(A6)
03D0: 2F0C          MOVE.L     A4,-(A7)
03D2: 4EBAFE38      JSR        -456(PC)
03D6: 362EFFFE      MOVE.W     -2(A6),D3
03DA: 966EFFFA      MOVEA.B    -6(A6),A3
03DE: 0643FFD8      ADDI.W     #$FFD8,D3
03E2: 2E8C          MOVE.L     A4,(A7)
03E4: 486EFEF8      PEA        -264(A6)
03E8: A919          MOVE.L     (A1)+,-(A4)
03EA: 4257          CLR.W      (A7)
03EC: 486EFEF8      PEA        -264(A6)
03F0: A88C          MOVE.L     A4,(A4)
03F2: 965F          MOVEA.B    (A7)+,A3
03F4: 48C3          EXT.L      D3
03F6: 87FC00020643  ORA.L      #$00020643,A3
03FC: 0014302E      ORI.B      #$302E,(A4)
0400: FFFAD043      MOVE.W     -12221(PC),???
0404: 3E80          MOVE.W     D0,(A7)
0406: 70FD          MOVEQ      #-3,D0
0408: D06EFFFC      MOVEA.B    -4(A6),A0
040C: 3F00          MOVE.W     D0,-(A7)
040E: A893          MOVE.L     (A3),(A4)
0410: 486EFEF8      PEA        -264(A6)
0414: A884          MOVE.L     D4,(A4)
0416: 3F06          MOVE.W     D6,-(A7)
0418: A887          MOVE.L     D7,(A4)
041A: 3F05          MOVE.W     D5,-(A7)
041C: A888          MOVE.L     A0,(A4)
041E: 3F07          MOVE.W     D7,-(A7)
0420: A889          MOVE.L     A1,(A4)
0422: 3F04          MOVE.W     D4,-(A7)
0424: A88A          MOVE.L     A2,(A4)
0426: 206C0072      MOVEA.L    114(A4),A0
042A: 2050          MOVEA.L    (A0),A0
042C: 2D680002FFF8  MOVE.L     2(A0),-8(A6)
0432: 2D680006FFFC  MOVE.L     6(A0),-4(A6)
0438: 536EFFFE536E  MOVE.B     -2(A6),21358(A1)
043E: FFFC486E      MOVE.W     #$486E,???
0442: FFF8A8A1      MOVE.W     $A8A1.W,???
0446: 2F3C00010001  MOVE.L     #$00010001,-(A7)
044C: A89B          MOVE.L     (A3)+,(A4)
044E: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
0452: 7002          MOVEQ      #2,D0
0454: D06EFFF8      MOVEA.B    -8(A6),A0
0458: 3F00          MOVE.W     D0,-(A7)
045A: A893          MOVE.L     (A3),(A4)
045C: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
0460: 3F2EFFFC      MOVE.W     -4(A6),-(A7)
0464: A891          MOVE.L     (A1),(A4)
0466: 7002          MOVEQ      #2,D0
0468: D06EFFFA      MOVEA.B    -6(A6),A0
046C: 3F00          MOVE.W     D0,-(A7)
046E: 3F2EFFFC      MOVE.W     -4(A6),-(A7)
0472: A891          MOVE.L     (A1),(A4)
0474: A89E          MOVE.L     (A6)+,(A4)
0476: 4CDF10F8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A4        ; restore
047A: 4E5E          UNLK       A6
047C: 4E75          RTS        


; ======= Function at 0x047E =======
047E: 4E56FFF8      LINK       A6,#-8                         ; frame=8
0482: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
0486: 286E0008      MOVEA.L    8(A6),A4
048A: 2D6C0010FFF8  MOVE.L     16(A4),-8(A6)
0490: 2D6C0014FFFC  MOVE.L     20(A4),-4(A6)
0496: 47EC0008      LEA        8(A4),A3
049A: 486EFFF8      PEA        -8(A6)
049E: 302B0002      MOVE.W     2(A3),D0
04A2: 4440          NEG.W      D0
04A4: 3F00          MOVE.W     D0,-(A7)
04A6: 3013          MOVE.W     (A3),D0
04A8: 4440          NEG.W      D0
04AA: 3F00          MOVE.W     D0,-(A7)
04AC: A8A82F2C      MOVE.L     12076(A0),(A4)
04B0: 0076486EFFF8  ORI.W      #$486E,-8(A6,A7.L*8)
04B6: A8DF          MOVE.L     (A7)+,(A4)+
04B8: 486EFFF8      PEA        -8(A6)
04BC: 4878FFFF      PEA        $FFFF.W
04C0: A8A9046E      MOVE.L     1134(A1),(A4)
04C4: 000CFFF8      ORI.B      #$FFF8,A4
04C8: 2F2C0072      MOVE.L     114(A4),-(A7)
04CC: 486EFFF8      PEA        -8(A6)
04D0: A8DF          MOVE.L     (A7)+,(A4)+
04D2: 486EFFF8      PEA        -8(A6)
04D6: 2F3C00020002  MOVE.L     #$00020002,-(A7)
04DC: A8A8536E      MOVE.L     21358(A0),(A4)
04E0: FFFC536E      MOVE.W     #$536E,???
04E4: FFFE          MOVE.W     ???,???
04E6: 42A7          CLR.L      -(A7)
04E8: A8D8          MOVE.L     (A0)+,(A4)+
04EA: 265F          MOVEA.L    (A7)+,A3
04EC: 2F0B          MOVE.L     A3,-(A7)
04EE: 486EFFF8      PEA        -8(A6)
04F2: A8DF          MOVE.L     (A7)+,(A4)+
04F4: 2F2C0072      MOVE.L     114(A4),-(A7)
04F8: 2F0B          MOVE.L     A3,-(A7)
04FA: 2F2C0072      MOVE.L     114(A4),-(A7)
04FE: A8E5          MOVE.L     -(A5),(A4)+
0500: 2F0B          MOVE.L     A3,-(A7)
0502: A8D9          MOVE.L     (A1)+,(A4)+
0504: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
0508: 4E5E          UNLK       A6
050A: 4E75          RTS        


; ======= Function at 0x050C =======
050C: 4E56FFF8      LINK       A6,#-8                         ; frame=8
0510: 2F0C          MOVE.L     A4,-(A7)
0512: 286E0008      MOVEA.L    8(A6),A4
0516: 206C0072      MOVEA.L    114(A4),A0
051A: 2050          MOVEA.L    (A0),A0
051C: 2D680002FFF8  MOVE.L     2(A0),-8(A6)
0522: 2D680006FFFC  MOVE.L     6(A0),-4(A6)
0528: 4227          CLR.B      -(A7)
052A: 2F2E000E      MOVE.L     14(A6),-(A7)
052E: 486EFFF8      PEA        -8(A6)
0532: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
0536: 6700008E      BEQ.W      $05C8
053A: 4227          CLR.B      -(A7)
053C: 2F2E000E      MOVE.L     14(A6),-(A7)
0540: 206C0076      MOVEA.L    118(A4),A0
0544: 2050          MOVEA.L    (A0),A0
0546: 48680002      PEA        2(A0)
054A: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
054E: 6732          BEQ.S      $0582
0550: 4A6E000C      TST.W      12(A6)
0554: 6628          BNE.S      $057E
0556: 70F0          MOVEQ      #-16,D0
0558: D06EFFFE      MOVEA.B    -2(A6),A0
055C: 3D40FFFA      MOVE.W     D0,-6(A6)
0560: 70F0          MOVEQ      #-16,D0
0562: D06EFFFC      MOVEA.B    -4(A6),A0
0566: 3D40FFF8      MOVE.W     D0,-8(A6)
056A: 4227          CLR.B      -(A7)
056C: 2F2E000E      MOVE.L     14(A6),-(A7)
0570: 486EFFF8      PEA        -8(A6)
0574: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
0578: 6704          BEQ.S      $057E
057A: 7003          MOVEQ      #3,D0
057C: 604A          BRA.S      $05C8
057E: 7001          MOVEQ      #1,D0
0580: 6046          BRA.S      $05C8
0582: 700D          MOVEQ      #13,D0
0584: D06EFFF8      MOVEA.B    -8(A6),A0
0588: 3D40FFFC      MOVE.W     D0,-4(A6)
058C: 4227          CLR.B      -(A7)
058E: 2F2E000E      MOVE.L     14(A6),-(A7)
0592: 486EFFF8      PEA        -8(A6)
0596: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
059A: 672A          BEQ.S      $05C6
059C: 4A2C006F      TST.B      111(A4)
05A0: 6720          BEQ.S      $05C2
05A2: 486EFFF8      PEA        -8(A6)
05A6: 2F0C          MOVE.L     A4,-(A7)
05A8: 4EBAFC8A      JSR        -886(PC)
05AC: 4217          CLR.B      (A7)
05AE: 2F2E000E      MOVE.L     14(A6),-(A7)
05B2: 486EFFF8      PEA        -8(A6)
05B6: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
05BA: 5C8F          MOVE.B     A7,(A6)
05BC: 6704          BEQ.S      $05C2
05BE: 7004          MOVEQ      #4,D0
05C0: 6006          BRA.S      $05C8
05C2: 7002          MOVEQ      #2,D0
05C4: 6002          BRA.S      $05C8
05C6: 7000          MOVEQ      #0,D0
05C8: 285F          MOVEA.L    (A7)+,A4
05CA: 4E5E          UNLK       A6
05CC: 4E75          RTS        

05CE: 4E75          RTS        

05D0: 4E75          RTS        


; ======= Function at 0x05D2 =======
05D2: 4E560000      LINK       A6,#0
05D6: 2F2E0008      MOVE.L     8(A6),-(A7)
05DA: 4EAD064A      JSR        1610(A5)                       ; JT[1610]
05DE: 4A40          TST.W      D0
05E0: 588F          MOVE.B     A7,(A4)
05E2: 6610          BNE.S      $05F4
05E4: 2F2E0008      MOVE.L     8(A6),-(A7)
05E8: 4EAD0D6A      JSR        3434(A5)                       ; JT[3434]
05EC: 02400080      ANDI.W     #$0080,D0
05F0: 588F          MOVE.B     A7,(A4)
05F2: 6704          BEQ.S      $05F8
05F4: 7000          MOVEQ      #0,D0
05F6: 6002          BRA.S      $05FA
05F8: 7001          MOVEQ      #1,D0
05FA: 4E5E          UNLK       A6
05FC: 4E75          RTS        


; ======= Function at 0x05FE =======
05FE: 4E560000      LINK       A6,#0
0602: 2F2E0008      MOVE.L     8(A6),-(A7)
0606: 4EAD0D6A      JSR        3434(A5)                       ; JT[3434]
060A: 02400080      ANDI.W     #$0080,D0
060E: 4E5E          UNLK       A6
0610: 4E75          RTS        


; ======= Function at 0x0612 =======
0612: 4E560000      LINK       A6,#0
0616: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
061A: 99CC4AAD      MOVE.B     A4,#$AD
061E: FACE          MOVE.W     A6,(A5)+
0620: 6728          BEQ.S      $064A
0622: 48780011      PEA        $0011.W
0626: 2F2DFACE      MOVE.L     -1330(A5),-(A7)                ; A5-1330
062A: 4EAD020A      JSR        522(A5)                        ; JT[522]
062E: 2E80          MOVE.L     D0,(A7)
0630: 4EAD0202      JSR        514(A5)                        ; JT[514]
0634: 2640          MOVEA.L    D0,A3
0636: 200B          MOVE.L     A3,D0
0638: 508F          MOVE.B     A7,(A0)
063A: 670E          BEQ.S      $064A
063C: 2F2E0008      MOVE.L     8(A6),-(A7)
0640: 2F2DFACE      MOVE.L     -1330(A5),-(A7)                ; A5-1330
0644: 4E93          JSR        (A3)
0646: 2840          MOVEA.L    D0,A4
0648: 508F          MOVE.B     A7,(A0)
064A: 200C          MOVE.L     A4,D0
064C: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
0650: 4E5E          UNLK       A6
0652: 4E75          RTS        


; ======= Function at 0x0654 =======
0654: 4E560000      LINK       A6,#0
0658: 2F0C          MOVE.L     A4,-(A7)
065A: 286E0008      MOVEA.L    8(A6),A4
065E: B9EDFAD26714  MOVE.W     -1326(A5),#$6714               ; A5-1326
0664: B9EDFACE6630  MOVE.W     -1330(A5),#$6630               ; A5-1330
066A: 2F2C0090      MOVE.L     144(A4),-(A7)
066E: 4EBAFF8E      JSR        -114(PC)
0672: 4A40          TST.W      D0
0674: 588F          MOVE.B     A7,(A4)
0676: 6722          BEQ.S      $069A
0678: 21EC00900A64  MOVE.L     144(A4),$0A64.W
067E: 600A          BRA.S      $068A
0680: 20780A64      MOVEA.L    $0A64.W,A0
0684: 21E800900A64  MOVE.L     144(A0),$0A64.W
068A: 4AB80A64      TST.L      $0A64.W
068E: 670A          BEQ.S      $069A
0690: 20780A64      MOVEA.L    $0A64.W,A0
0694: 4A28006E      TST.B      110(A0)
0698: 67E6          BEQ.S      $0680
069A: 2F0C          MOVE.L     A4,-(A7)
069C: 4227          CLR.B      -(A7)
069E: A908          MOVE.L     A0,-(A4)
06A0: 4EBA0384      JSR        900(PC)
06A4: 4AADFAD2      TST.L      -1326(A5)
06A8: 670E          BEQ.S      $06B8
06AA: 1F3C0001      MOVE.B     #$01,-(A7)
06AE: 2F2DFAD2      MOVE.L     -1326(A5),-(A7)                ; A5-1326
06B2: 4EBA01B2      JSR        434(PC)
06B6: 5C8F          MOVE.B     A7,(A6)
06B8: 285F          MOVEA.L    (A7)+,A4
06BA: 4E5E          UNLK       A6
06BC: 4E75          RTS        


; ======= Function at 0x06BE =======
06BE: 4E560000      LINK       A6,#0
06C2: 2F2E0008      MOVE.L     8(A6),-(A7)
06C6: 4EBAFF8C      JSR        -116(PC)
06CA: 2EAE0008      MOVE.L     8(A6),(A7)
06CE: A92D4E5E      MOVE.L     20062(A5),-(A4)                ; A5+20062
06D2: 4E75          RTS        


; ======= Function at 0x06D4 =======
06D4: 4E56FFFC      LINK       A6,#-4                         ; frame=4
06D8: 2F0C          MOVE.L     A4,-(A7)
06DA: 42A7          CLR.L      -(A7)
06DC: 2F2E0008      MOVE.L     8(A6),-(A7)
06E0: 2F2E000C      MOVE.L     12(A6),-(A7)
06E4: 2F2E0010      MOVE.L     16(A6),-(A7)
06E8: 4227          CLR.B      -(A7)
06EA: 3F2E0016      MOVE.W     22(A6),-(A7)
06EE: 42A7          CLR.L      -(A7)
06F0: 1F2E001C      MOVE.B     28(A6),-(A7)
06F4: 2F2E001E      MOVE.L     30(A6),-(A7)
06F8: A913          MOVE.L     (A3),-(A4)
06FA: 285F          MOVEA.L    (A7)+,A4
06FC: 70FF          MOVEQ      #-1,D0
06FE: B0AE0018      MOVE.W     24(A6),(A0)
0702: 6612          BNE.S      $0716
0704: 2F0C          MOVE.L     A4,-(A7)
0706: 1F3C0001      MOVE.B     #$01,-(A7)
070A: A91C          MOVE.L     (A4)+,-(A4)
070C: 2F0C          MOVE.L     A4,-(A7)
070E: 4EBA0252      JSR        594(PC)
0712: 588F          MOVE.B     A7,(A4)
0714: 6012          BRA.S      $0728
0716: 4AAE0018      TST.L      24(A6)
071A: 670C          BEQ.S      $0728
071C: 2F2E0018      MOVE.L     24(A6),-(A7)
0720: 2F0C          MOVE.L     A4,-(A7)
0722: 4EBA01C0      JSR        448(PC)
0726: 508F          MOVE.B     A7,(A0)
0728: 4A2E0014      TST.B      20(A6)
072C: 6708          BEQ.S      $0736
072E: 2F0C          MOVE.L     A4,-(A7)
0730: 4EBA000C      JSR        12(PC)
0734: 588F          MOVE.B     A7,(A4)
0736: 200C          MOVE.L     A4,D0
0738: 285F          MOVEA.L    (A7)+,A4
073A: 4E5E          UNLK       A6
073C: 4E75          RTS        


; ======= Function at 0x073E =======
073E: 4E560000      LINK       A6,#0
0742: 2F0C          MOVE.L     A4,-(A7)
0744: 286E0008      MOVEA.L    8(A6),A4
0748: 2F0C          MOVE.L     A4,-(A7)
074A: 4EBAFEB2      JSR        -334(PC)
074E: 4A40          TST.W      D0
0750: 588F          MOVE.B     A7,(A4)
0752: 6712          BEQ.S      $0766
0754: 2F0C          MOVE.L     A4,-(A7)
0756: 1F3C0001      MOVE.B     #$01,-(A7)
075A: A91C          MOVE.L     (A4)+,-(A4)
075C: 2F0C          MOVE.L     A4,-(A7)
075E: 1F3C0001      MOVE.B     #$01,-(A7)
0762: A908          MOVE.L     A0,-(A4)
0764: 6004          BRA.S      $076A
0766: 2F0C          MOVE.L     A4,-(A7)
0768: A915          MOVE.L     (A5),-(A4)
076A: 285F          MOVEA.L    (A7)+,A4
076C: 4E5E          UNLK       A6
076E: 4E75          RTS        


; ======= Function at 0x0770 =======
0770: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0774: 2F2DFAD6      MOVE.L     -1322(A5),-(A7)                ; A5-1322
0778: 4EAD064A      JSR        1610(A5)                       ; JT[1610]
077C: 4A40          TST.W      D0
077E: 588F          MOVE.B     A7,(A4)
0780: 661A          BNE.S      $079C
0782: 4AAE0008      TST.L      8(A6)
0786: 670A          BEQ.S      $0792
0788: 202E0008      MOVE.L     8(A6),D0
078C: B0ADFAD2      MOVE.W     -1326(A5),(A0)                 ; A5-1326
0790: 670E          BEQ.S      $07A0
0792: 202E0008      MOVE.L     8(A6),D0
0796: B0ADFACE      MOVE.W     -1330(A5),(A0)                 ; A5-1330
079A: 6704          BEQ.S      $07A0
079C: 7000          MOVEQ      #0,D0
079E: 6002          BRA.S      $07A2
07A0: 7001          MOVEQ      #1,D0
07A2: 4E5E          UNLK       A6
07A4: 4E75          RTS        

07A6: 30380BAA      MOVE.W     $0BAA.W,D0
07AA: 4E75          RTS        


; ======= Function at 0x07AC =======
07AC: 4E56FFF8      LINK       A6,#-8                         ; frame=8
07B0: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
07B4: 266E0008      MOVEA.L    8(A6),A3
07B8: 4227          CLR.B      -(A7)
07BA: A9734A1F6700  MOVE.L     31(A3,D4.L*2),26368(A4)
07C0: 009E486EFFF8  ORI.L      #$486EFFF8,(A6)+
07C6: A8742F38      MOVEA.L    56(A4,D2.L*8),A4
07CA: 09DE          BSET       D4,(A6)+
07CC: A87342A7      MOVEA.L    -89(A3,D4.W*2),A4
07D0: A8D8          MOVE.L     (A0)+,(A4)+
07D2: 285F          MOVEA.L    (A7)+,A4
07D4: 2F0C          MOVE.L     A4,-(A7)
07D6: A87A2F38      MOVEA.L    12088(PC),A4
07DA: 09EEA879      BSET       D4,-22407(A6)
07DE: 2F0B          MOVE.L     A3,-(A7)
07E0: A90B          MOVE.L     A3,-(A4)
07E2: 486E000C      PEA        12(A6)
07E6: A8712F2B      MOVEA.L    43(A1,D2.L*8),A4
07EA: 007242A7A8D8  ORI.W      #$42A7,-40(A2,A2.L)
07F0: 245F          MOVEA.L    (A7)+,A2
07F2: 2F0A          MOVE.L     A2,-(A7)
07F4: A8DC          MOVE.L     (A4)+,(A4)+
07F6: 42A7          CLR.L      -(A7)
07F8: 2F0A          MOVE.L     A2,-(A7)
07FA: 2F2E000C      MOVE.L     12(A6),-(A7)
07FE: 2F2E0010      MOVE.L     16(A6),-(A7)
0802: 2F2E0010      MOVE.L     16(A6),-(A7)
0806: 4267          CLR.W      -(A7)
0808: 42A7          CLR.L      -(A7)
080A: A905          MOVE.L     D5,-(A4)
080C: 2E1F          MOVE.L     (A7)+,D7
080E: 4267          CLR.W      -(A7)
0810: 2F07          MOVE.L     D7,-(A7)
0812: A86A3D5F      MOVEA.L    15711(A2),A4
0816: FFFC3D47      MOVE.W     #$3D47,???
081A: FFFE          MOVE.W     ???,???
081C: 2F0C          MOVE.L     A4,-(A7)
081E: A8792F0CA8D9  MOVEA.L    $2F0CA8D9,A4
0824: 2F0A          MOVE.L     A2,-(A7)
0826: A8D9          MOVE.L     (A1)+,(A4)+
0828: 0C6E8000FFFC  CMPI.W     #$8000,-4(A6)
082E: 6728          BEQ.S      $0858
0830: 302B0010      MOVE.W     16(A3),D0
0834: D16EFFFC302B  MOVE.B     -4(A6),12331(A0)
083A: 0012D16E      ORI.B      #$D16E,(A2)
083E: FFFE          MOVE.W     ???,???
0840: 2F0B          MOVE.L     A3,-(A7)
0842: A873486E      MOVEA.L    110(A3,D4.L),A4
0846: FFFCA870      MOVE.W     #$A870,???
084A: 2F0B          MOVE.L     A3,-(A7)
084C: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
0850: 3F2EFFFC      MOVE.W     -4(A6),-(A7)
0854: 4227          CLR.B      -(A7)
0856: A91B          MOVE.L     (A3)+,-(A4)
0858: 2F2EFFF8      MOVE.L     -8(A6),-(A7)
085C: A8734CDF      MOVEA.L    -33(A3,D4.L*4),A4
0860: 1C80          MOVE.B     D0,(A6)
0862: 4E5E          UNLK       A6
0864: 4E75          RTS        


; ======= Function at 0x0866 =======
0866: 4E56FFFA      LINK       A6,#-6                         ; frame=6
086A: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
086E: 286E0008      MOVEA.L    8(A6),A4
0872: 2F0C          MOVE.L     A4,-(A7)
0874: 1F2E000C      MOVE.B     12(A6),-(A7)
0878: A91C          MOVE.L     (A4)+,-(A4)
087A: 2F0C          MOVE.L     A4,-(A7)
087C: A8734AAD      MOVEA.L    -83(A3,D4.L*2),A4
0880: FACE          MOVE.W     A6,(A5)+
0882: 6726          BEQ.S      $08AA
0884: 202DFAD6      MOVE.L     -1322(A5),D0                   ; A5-1322
0888: B0ADFACE      MOVE.W     -1330(A5),(A0)                 ; A5-1330
088C: 57C7          SEQ        D7
088E: 4407          NEG.B      D7
0890: 266DFACE      MOVEA.L    -1330(A5),A3
0894: 6010          BRA.S      $08A6
0896: 2F0B          MOVE.L     A3,-(A7)
0898: 1F07          MOVE.B     D7,-(A7)
089A: A91C          MOVE.L     (A4)+,-(A4)
089C: B7EDFADA6708  MOVE.W     -1318(A5),8(PC,D6.W)           ; A5-1318
08A2: 266B0090      MOVEA.L    144(A3),A3
08A6: 200B          MOVE.L     A3,D0
08A8: 66EC          BNE.S      $0896
08AA: 4AADFAD2      TST.L      -1326(A5)
08AE: 6724          BEQ.S      $08D4
08B0: 206DFAD2      MOVEA.L    -1326(A5),A0
08B4: 26680090      MOVEA.L    144(A0),A3
08B8: 6016          BRA.S      $08D0
08BA: 2F0B          MOVE.L     A3,-(A7)
08BC: 4EBAFD14      JSR        -748(PC)
08C0: 4A40          TST.W      D0
08C2: 588F          MOVE.B     A7,(A4)
08C4: 6706          BEQ.S      $08CC
08C6: 2F0B          MOVE.L     A3,-(A7)
08C8: 4227          CLR.B      -(A7)
08CA: A91C          MOVE.L     (A4)+,-(A4)
08CC: 266B0090      MOVEA.L    144(A3),A3
08D0: 200B          MOVE.L     A3,D0
08D2: 66E6          BNE.S      $08BA
08D4: 2F0C          MOVE.L     A4,-(A7)
08D6: 4EAD061A      JSR        1562(A5)                       ; JT[1562]
08DA: 4CEE1880FFEE  MOVEM.L    -18(A6),D7/A3/A4
08E0: 4E5E          UNLK       A6
08E2: 4E75          RTS        


; ======= Function at 0x08E4 =======
08E4: 4E56FFF8      LINK       A6,#-8                         ; frame=8
08E8: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
08EC: 286E0008      MOVEA.L    8(A6),A4
08F0: 486EFFFC      PEA        -4(A6)
08F4: A8742F0C      MOVEA.L    12(A4,D2.L*8),A4
08F8: A87342A7      MOVEA.L    -89(A3,D4.W*2),A4
08FC: A8D8          MOVE.L     (A0)+,(A4)+
08FE: 265F          MOVEA.L    (A7)+,A3
0900: 2F2C0018      MOVE.L     24(A4),-(A7)
0904: 2F0B          MOVE.L     A3,-(A7)
0906: A8DC          MOVE.L     (A4)+,(A4)+
0908: 2F0C          MOVE.L     A4,-(A7)
090A: 2F2E000C      MOVE.L     12(A6),-(A7)
090E: A921          MOVE.L     -(A1),-(A4)
0910: 2053          MOVEA.L    (A3),A0
0912: 2D680002FFF8  MOVE.L     2(A0),-8(A6)
0918: 486EFFF8      PEA        -8(A6)
091C: A8702F0B      MOVEA.L    11(A0,D2.L*8),A4
0920: 2053          MOVEA.L    (A3),A0
0922: 302EFFFA      MOVE.W     -6(A6),D0
0926: 90680004      MOVEA.B    4(A0),A0
092A: 3F00          MOVE.W     D0,-(A7)
092C: 302EFFF8      MOVE.W     -8(A6),D0
0930: 90680002      MOVEA.B    2(A0),A0
0934: 3F00          MOVE.W     D0,-(A7)
0936: A8E0          MOVE.L     -(A0),(A4)+
0938: 2F2C0072      MOVE.L     114(A4),-(A7)
093C: 2F0B          MOVE.L     A3,-(A7)
093E: 2F0B          MOVE.L     A3,-(A7)
0940: A8E6          MOVE.L     -(A6),(A4)+
0942: 2F0C          MOVE.L     A4,-(A7)
0944: 2F0B          MOVE.L     A3,-(A7)
0946: A90C          MOVE.L     A4,-(A4)
0948: 2F0C          MOVE.L     A4,-(A7)
094A: 2F2C0072      MOVE.L     114(A4),-(A7)
094E: A90A          MOVE.L     A2,-(A4)
0950: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
0954: A8732F0B      MOVEA.L    11(A3,D2.L*8),A4
0958: A8D9          MOVE.L     (A1)+,(A4)+
095A: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
095E: 4E5E          UNLK       A6
0960: 4E75          RTS        


; ======= Function at 0x0962 =======
0962: 4E56FFF0      LINK       A6,#-16                        ; frame=16
0966: 2F0C          MOVE.L     A4,-(A7)
0968: 286E0008      MOVEA.L    8(A6),A4
096C: 2F0C          MOVE.L     A4,-(A7)
096E: 4EBAFC62      JSR        -926(PC)
0972: 4A40          TST.W      D0
0974: 588F          MOVE.B     A7,(A4)
0976: 6744          BEQ.S      $09BC
0978: 4AADFACE      TST.L      -1330(A5)
097C: 6738          BEQ.S      $09B6
097E: 2F2DFADA      MOVE.L     -1318(A5),-(A7)                ; A5-1318
0982: 2F0C          MOVE.L     A4,-(A7)
0984: 4EBAFF5E      JSR        -162(PC)
0988: 202DFACE      MOVE.L     -1330(A5),D0                   ; A5-1330
098C: B0ADFAD6      MOVE.W     -1322(A5),(A0)                 ; A5-1322
0990: 508F          MOVE.B     A7,(A0)
0992: 6708          BEQ.S      $099C
0994: 2F2DFACE      MOVE.L     -1330(A5),-(A7)                ; A5-1330
0998: A91F          MOVE.L     (A7)+,-(A4)
099A: 600C          BRA.S      $09A8
099C: 1F3C0001      MOVE.B     #$01,-(A7)
09A0: 2F0C          MOVE.L     A4,-(A7)
09A2: 4EBAFEC2      JSR        -318(PC)
09A6: 5C8F          MOVE.B     A7,(A6)
09A8: 4227          CLR.B      -(A7)
09AA: 2F2DFAD2      MOVE.L     -1326(A5),-(A7)                ; A5-1326
09AE: 4EBAFEB6      JSR        -330(PC)
09B2: 5C8F          MOVE.B     A7,(A6)
09B4: 603A          BRA.S      $09F0
09B6: 2F0C          MOVE.L     A4,-(A7)
09B8: A91F          MOVE.L     (A7)+,-(A4)
09BA: 6034          BRA.S      $09F0
09BC: 2F0C          MOVE.L     A4,-(A7)
09BE: 4EBAFC3E      JSR        -962(PC)
09C2: 4A40          TST.W      D0
09C4: 588F          MOVE.B     A7,(A4)
09C6: 6724          BEQ.S      $09EC
09C8: 4AADFAD6      TST.L      -1322(A5)
09CC: 670E          BEQ.S      $09DC
09CE: 2F2DFAD6      MOVE.L     -1322(A5),-(A7)                ; A5-1322
09D2: 4EAD064A      JSR        1610(A5)                       ; JT[1610]
09D6: 4A40          TST.W      D0
09D8: 588F          MOVE.B     A7,(A4)
09DA: 660A          BNE.S      $09E6
09DC: 2F0C          MOVE.L     A4,-(A7)
09DE: 4EBA0016      JSR        22(PC)
09E2: 588F          MOVE.B     A7,(A4)
09E4: 600A          BRA.S      $09F0
09E6: 2F0C          MOVE.L     A4,-(A7)
09E8: A91F          MOVE.L     (A7)+,-(A4)
09EA: 6004          BRA.S      $09F0
09EC: 2F0C          MOVE.L     A4,-(A7)
09EE: A91F          MOVE.L     (A7)+,-(A4)
09F0: 285F          MOVEA.L    (A7)+,A4
09F2: 4E5E          UNLK       A6
09F4: 4E75          RTS        


; ======= Function at 0x09F6 =======
09F6: 4E56FFFC      LINK       A6,#-4                         ; frame=4
09FA: 2F2E0008      MOVE.L     8(A6),-(A7)
09FE: 4EBAFBFE      JSR        -1026(PC)
0A02: 4A40          TST.W      D0
0A04: 588F          MOVE.B     A7,(A4)
0A06: 6706          BEQ.S      $0A0E
0A08: 202DFACE      MOVE.L     -1330(A5),D0                   ; A5-1330
0A0C: 6004          BRA.S      $0A12
0A0E: 202DFAD2      MOVE.L     -1326(A5),D0                   ; A5-1326
0A12: 21C00A68      MOVE.L     D0,$0A68.W
0A16: 2F2E0008      MOVE.L     8(A6),-(A7)
0A1A: A920          MOVE.L     -(A0),-(A4)
0A1C: 21EE00080A64  MOVE.L     8(A6),$0A64.W
0A22: 4E5E          UNLK       A6
0A24: 4E75          RTS        

0A26: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
0A2A: 7E01          MOVEQ      #1,D7
0A2C: 7C00          MOVEQ      #0,D6
0A2E: 42ADFAD2      CLR.L      -1326(A5)
0A32: 42ADFACE      CLR.L      -1330(A5)
0A36: 42ADFAD6      CLR.L      -1322(A5)
0A3A: 70FF          MOVEQ      #-1,D0
0A3C: 2B40FADA      MOVE.L     D0,-1318(A5)
0A40: 287809D6      MOVEA.L    $09D6.W,A4
0A44: 607C          BRA.S      $0AC2
0A46: 4A2C006E      TST.B      110(A4)
0A4A: 6772          BEQ.S      $0ABE
0A4C: 4AADFAD6      TST.L      -1322(A5)
0A50: 6604          BNE.S      $0A56
0A52: 2B4CFAD6      MOVE.L     A4,-1322(A5)
0A56: 2F0C          MOVE.L     A4,-(A7)
0A58: 4EBAFB78      JSR        -1160(PC)
0A5C: 4A40          TST.W      D0
0A5E: 588F          MOVE.B     A7,(A4)
0A60: 6712          BEQ.S      $0A74
0A62: 4AADFAD2      TST.L      -1326(A5)
0A66: 6656          BNE.S      $0ABE
0A68: 2B4CFAD2      MOVE.L     A4,-1326(A5)
0A6C: 4A06          TST.B      D6
0A6E: 674E          BEQ.S      $0ABE
0A70: 7E00          MOVEQ      #0,D7
0A72: 604A          BRA.S      $0ABE
0A74: 2F0C          MOVE.L     A4,-(A7)
0A76: 4EBAFB86      JSR        -1146(PC)
0A7A: 4A40          TST.W      D0
0A7C: 588F          MOVE.B     A7,(A4)
0A7E: 6736          BEQ.S      $0AB6
0A80: 4AADFAD2      TST.L      -1326(A5)
0A84: 6720          BEQ.S      $0AA6
0A86: 202DFAD2      MOVE.L     -1326(A5),D0                   ; A5-1326
0A8A: B0ADFAD6      MOVE.W     -1322(A5),(A0)                 ; A5-1322
0A8E: 660A          BNE.S      $0A9A
0A90: 2F0C          MOVE.L     A4,-(A7)
0A92: A91F          MOVE.L     (A7)+,-(A4)
0A94: 2B4CFAD6      MOVE.L     A4,-1322(A5)
0A98: 6008          BRA.S      $0AA2
0A9A: 2F2DFAD2      MOVE.L     -1326(A5),-(A7)                ; A5-1326
0A9E: 2F0C          MOVE.L     A4,-(A7)
0AA0: A921          MOVE.L     -(A1),-(A4)
0AA2: 286DFAD2      MOVEA.L    -1326(A5),A4
0AA6: 4AADFACE      TST.L      -1330(A5)
0AAA: 6604          BNE.S      $0AB0
0AAC: 2B4CFACE      MOVE.L     A4,-1330(A5)
0AB0: 2B4CFADA      MOVE.L     A4,-1318(A5)
0AB4: 6008          BRA.S      $0ABE
0AB6: 4AADFACE      TST.L      -1330(A5)
0ABA: 6702          BEQ.S      $0ABE
0ABC: 7C01          MOVEQ      #1,D6
0ABE: 286C0090      MOVEA.L    144(A4),A4
0AC2: 200C          MOVE.L     A4,D0
0AC4: 6680          BNE.S      $0A46
0AC6: 4A07          TST.B      D7
0AC8: 6658          BNE.S      $0B22
0ACA: 4AADFAD2      TST.L      -1326(A5)
0ACE: 6706          BEQ.S      $0AD6
0AD0: 266DFAD2      MOVEA.L    -1326(A5),A3
0AD4: 6004          BRA.S      $0ADA
0AD6: 266DFADA      MOVEA.L    -1318(A5),A3
0ADA: 206DFACE      MOVEA.L    -1330(A5),A0
0ADE: 28680090      MOVEA.L    144(A0),A4
0AE2: 6036          BRA.S      $0B1A
0AE4: 2F0C          MOVE.L     A4,-(A7)
0AE6: 4EAD064A      JSR        1610(A5)                       ; JT[1610]
0AEA: 4A40          TST.W      D0
0AEC: 588F          MOVE.B     A7,(A4)
0AEE: 6726          BEQ.S      $0B16
0AF0: 206C0076      MOVEA.L    118(A4),A0
0AF4: 7002          MOVEQ      #2,D0
0AF6: D090          MOVE.B     (A0),(A0)
0AF8: 2440          MOVEA.L    D0,A2
0AFA: 3E2A0004      MOVE.W     4(A2),D7
0AFE: 35520004      MOVE.W     (A2),4(A2)
0B02: 2F0C          MOVE.L     A4,-(A7)
0B04: 2F0B          MOVE.L     A3,-(A7)
0B06: A921          MOVE.L     -(A1),-(A4)
0B08: 206C0076      MOVEA.L    118(A4),A0
0B0C: 2050          MOVEA.L    (A0),A0
0B0E: 31470006      MOVE.W     D7,6(A0)
0B12: 286DFACE      MOVEA.L    -1330(A5),A4
0B16: 286C0090      MOVEA.L    144(A4),A4
0B1A: 200C          MOVE.L     A4,D0
0B1C: 6704          BEQ.S      $0B22
0B1E: B7CC66C2      MOVE.W     A4,-62(PC,D6.W)
0B22: 202DFACE      MOVE.L     -1330(A5),D0                   ; A5-1330
0B26: B0ADFAD6      MOVE.W     -1322(A5),(A0)                 ; A5-1322
0B2A: 6606          BNE.S      $0B32
0B2C: 202DFAD2      MOVE.L     -1326(A5),D0                   ; A5-1326
0B30: 6004          BRA.S      $0B36
0B32: 202DFAD6      MOVE.L     -1322(A5),D0                   ; A5-1322
0B36: 4CDF1CC0      MOVEM.L    (SP)+,D6/D7/A2/A3/A4           ; restore
0B3A: 4E75          RTS        


; ======= Function at 0x0B3C =======
0B3C: 4E560000      LINK       A6,#0
0B40: 206E000C      MOVEA.L    12(A6),A0
0B44: 7001          MOVEQ      #1,D0
0B46: C028000F      AND.B      15(A0),D0
0B4A: 1F00          MOVE.B     D0,-(A7)
0B4C: 2F2E0008      MOVE.L     8(A6),-(A7)
0B50: 4EBAFD14      JSR        -748(PC)
0B54: 4E5E          UNLK       A6
0B56: 4E75          RTS        
