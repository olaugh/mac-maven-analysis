;======================================================================
; CODE 17 Disassembly
; File: /tmp/maven_code_17.bin
; Header: JT offset=1736, JT entries=29
; Code size: 2618 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56D8CE      LINK       A6,#-10034                     ; frame=10034
0004: 2F0C          MOVE.L     A4,-(A7)
0006: 286E000C      MOVEA.L    12(A6),A4
000A: 2D7C00002710D8DA  MOVE.L     #$00002710,-10022(A6)
0012: 2D7C54455854FFF0  MOVE.L     #$54455854,-16(A6)
001A: 3F3C0001      MOVE.W     #$0001,-(A7)
001E: 486EFFF0      PEA        -16(A6)
0022: 2F0C          MOVE.L     A4,-(A7)
0024: 4EAD0612      JSR        1554(A5)                       ; JT[1554]
0028: 4A40          TST.W      D0
002A: 4FEF000A      LEA        10(A7),A7
002E: 67000086      BEQ.W      $00B8
0032: 4267          CLR.W      -(A7)
0034: 486C000A      PEA        10(A4)
0038: 3F2C0006      MOVE.W     6(A4),-(A7)
003C: 486EFFEE      PEA        -18(A6)
0040: 4EAD0B1A      JSR        2842(A5)                       ; JT[2842]
0044: 4A5F          TST.W      (A7)+
0046: 6704          BEQ.S      $004C
0048: 4EAD01A2      JSR        418(A5)                        ; JT[418]
004C: 286E0008      MOVEA.L    8(A6),A4
0050: 49EC00A0      LEA        160(A4),A4
0054: 4267          CLR.W      -(A7)
0056: 3F2EFFEE      MOVE.W     -18(A6),-(A7)
005A: 486ED8DA      PEA        -10022(A6)
005E: 486ED8DE      PEA        -10018(A6)
0062: 4EAD0B2A      JSR        2858(A5)                       ; JT[2858]
0066: 486ED8DE      PEA        -10018(A6)
006A: 306ED8DC      MOVEA.W    -10020(A6),A0
006E: 2F08          MOVE.L     A0,-(A7)
0070: 2F14          MOVE.L     (A4),-(A7)
0072: A9DE548F0CAE  MOVE.L     (A6)+,#$548F0CAE
0078: 00002710      ORI.B      #$2710,D0
007C: D8DA          MOVE.B     (A2)+,(A4)+
007E: 67D4          BEQ.S      $0054
0080: 4267          CLR.W      -(A7)
0082: 3F2EFFEE      MOVE.W     -18(A6),-(A7)
0086: 4EAD0B22      JSR        2850(A5)                       ; JT[2850]
008A: 4A5F          TST.W      (A7)+
008C: 6704          BEQ.S      $0092
008E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0092: 2F2E0008      MOVE.L     8(A6),-(A7)
0096: A8732054      MOVEA.L    84(A3,D2.W),A4
009A: 2050          MOVEA.L    (A0),A0
009C: 2D680008D8D2  MOVE.L     8(A0),-10030(A6)
00A2: 2D68000CD8D6  MOVE.L     12(A0),-10026(A6)
00A8: 486ED8D2      PEA        -10030(A6)
00AC: A9282F2E      MOVE.L     12078(A0),-(A4)
00B0: 00084EBA      ORI.B      #$4EBA,A0
00B4: 019E          BCLR       D0,(A6)+
00B6: 286ED8CA      MOVEA.L    -10038(A6),A4
00BA: 4E5E          UNLK       A6
00BC: 4E75          RTS        


; ======= Function at 0x00BE =======
00BE: 4E560000      LINK       A6,#0
00C2: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
00C6: 2E2E000A      MOVE.L     10(A6),D7
00CA: 4A6E0008      TST.W      8(A6)
00CE: 6700009C      BEQ.W      $016E
00D2: 2047          MOVEA.L    D7,A0
00D4: 2050          MOVEA.L    (A0),A0
00D6: 28680004      MOVEA.L    4(A0),A4
00DA: BEAC009C      MOVE.W     156(A4),(A7)
00DE: 6704          BEQ.S      $00E4
00E0: 4EAD01A2      JSR        418(A5)                        ; JT[418]
00E4: 302E0008      MOVE.W     8(A6),D0
00E8: 6B68          BMI.S      $0152
00EA: 04400016      SUBI.W     #$0016,D0
00EE: 672A          BEQ.S      $011A
00F0: 6A08          BPL.S      $00FA
00F2: 5440          MOVEA.B    D0,A2
00F4: 670A          BEQ.S      $0100
00F6: 6A16          BPL.S      $010E
00F8: 6058          BRA.S      $0152
00FA: 55406A54      MOVE.B     D0,27220(A2)
00FE: 6036          BRA.S      $0136
0100: 206C00A0      MOVEA.L    160(A4),A0
0104: 2050          MOVEA.L    (A0),A0
0106: 3C280018      MOVE.W     24(A0),D6
010A: 4446          NEG.W      D6
010C: 6048          BRA.S      $0156
010E: 206C00A0      MOVEA.L    160(A4),A0
0112: 2050          MOVEA.L    (A0),A0
0114: 3C280018      MOVE.W     24(A0),D6
0118: 603C          BRA.S      $0156
011A: 206C00A0      MOVEA.L    160(A4),A0
011E: 7008          MOVEQ      #8,D0
0120: D090          MOVE.B     (A0),(A0)
0122: 2440          MOVEA.L    D0,A2
0124: 206C00A0      MOVEA.L    160(A4),A0
0128: 2650          MOVEA.L    (A0),A3
012A: 3C2B0018      MOVE.W     24(A3),D6
012E: DC52          MOVEA.B    (A2),A6
0130: 9C6A0004      MOVEA.B    4(A2),A6
0134: 6020          BRA.S      $0156
0136: 206C00A0      MOVEA.L    160(A4),A0
013A: 7008          MOVEQ      #8,D0
013C: D090          MOVE.B     (A0),(A0)
013E: 2440          MOVEA.L    D0,A2
0140: 206C00A0      MOVEA.L    160(A4),A0
0144: 2650          MOVEA.L    (A0),A3
0146: 3C2A0004      MOVE.W     4(A2),D6
014A: 9C52          MOVEA.B    (A2),A6
014C: 9C6B0018      MOVEA.B    24(A3),A6
0150: 6004          BRA.S      $0156
0152: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0156: 2F07          MOVE.L     D7,-(A7)
0158: 4267          CLR.W      -(A7)
015A: 2F07          MOVE.L     D7,-(A7)
015C: A960301F      MOVE.L     -(A0),12319(A4)
0160: D046          MOVEA.B    D6,A0
0162: 3F00          MOVE.W     D0,-(A7)
0164: A9632F0C      MOVE.L     -(A3),12044(A4)
0168: 4EBA0010      JSR        16(PC)
016C: 4CEE1CC0FFEC  MOVEM.L    -20(A6),D6/D7/A2/A3/A4
0172: 4E5E          UNLK       A6
0174: 205F          MOVEA.L    (A7)+,A0
0176: 5C8F          MOVE.B     A7,(A6)
0178: 4ED0          JMP        (A0)

; ======= Function at 0x017A =======
017A: 4E560000      LINK       A6,#0
017E: 48E70718      MOVEM.L    D5/D6/D7/A3/A4,-(SP)           ; save
0182: 266E0008      MOVEA.L    8(A6),A3
0186: 49EB00A0      LEA        160(A3),A4
018A: 2F14          MOVE.L     (A4),-(A7)
018C: 4EBA0048      JSR        72(PC)
0190: 3E00          MOVE.W     D0,D7
0192: 4257          CLR.W      (A7)
0194: 2F2B009C      MOVE.L     156(A3),-(A7)
0198: A9603C1F      MOVE.L     -(A0),15391(A4)
019C: 206B00A0      MOVEA.L    160(A3),A0
01A0: 2050          MOVEA.L    (A0),A0
01A2: 3A280018      MOVE.W     24(A0),D5
01A6: 548F          MOVE.B     A7,(A2)
01A8: 6002          BRA.S      $01AC
01AA: 53463006      MOVE.B     D6,12294(A1)
01AE: 9047          MOVEA.B    D7,A0
01B0: 48C0          EXT.L      D0
01B2: 81C5          ORA.L      D5,A0
01B4: 4840          PEA        D0
01B6: 4A40          TST.W      D0
01B8: 66F0          BNE.S      $01AA
01BA: 2F2B009C      MOVE.L     156(A3),-(A7)
01BE: 3F06          MOVE.W     D6,-(A7)
01C0: A9634267      MOVE.L     -(A3),16999(A4)
01C4: 3007          MOVE.W     D7,D0
01C6: 9046          MOVEA.B    D6,A0
01C8: 3F00          MOVE.W     D0,-(A7)
01CA: 2F14          MOVE.L     (A4),-(A7)
01CC: A812          MOVE.L     (A2),D4
01CE: 4CDF18E0      MOVEM.L    (SP)+,D5/D6/D7/A3/A4           ; restore
01D2: 4E5E          UNLK       A6
01D4: 4E75          RTS        


; ======= Function at 0x01D6 =======
01D6: 4E560000      LINK       A6,#0
01DA: 2F0C          MOVE.L     A4,-(A7)
01DC: 206E0008      MOVEA.L    8(A6),A0
01E0: 2850          MOVEA.L    (A0),A4
01E2: 302C0008      MOVE.W     8(A4),D0
01E6: 9054          MOVEA.B    (A4),A0
01E8: 285F          MOVEA.L    (A7)+,A4
01EA: 4E5E          UNLK       A6
01EC: 4E75          RTS        


; ======= Function at 0x01EE =======
01EE: 4E560000      LINK       A6,#0
01F2: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
01F6: 286E0008      MOVEA.L    8(A6),A4
01FA: 266E000C      MOVEA.L    12(A6),A3
01FE: 4267          CLR.W      -(A7)
0200: 2F0C          MOVE.L     A4,-(A7)
0202: A9603E1F      MOVE.L     -(A0),15903(A4)
0206: 4267          CLR.W      -(A7)
0208: 2F0C          MOVE.L     A4,-(A7)
020A: A9623C1F      MOVE.L     -(A2),15391(A4)
020E: 2F0B          MOVE.L     A3,-(A7)
0210: 4EBAFFC4      JSR        -60(PC)
0214: 3A00          MOVE.W     D0,D5
0216: 2E8B          MOVE.L     A3,(A7)
0218: 4EBA0778      JSR        1912(PC)
021C: 2453          MOVEA.L    (A3),A2
021E: 382A005E      MOVE.W     94(A2),D4
0222: 9840          MOVEA.B    D0,A4
0224: C9EA0018      ANDA.L     24(A2),A4
0228: 4A45          TST.W      D5
022A: 588F          MOVE.B     A7,(A4)
022C: 6C02          BGE.S      $0230
022E: 7A00          MOVEQ      #0,D5
0230: 4A44          TST.W      D4
0232: 6C02          BGE.S      $0236
0234: 7800          MOVEQ      #0,D4
0236: B846          MOVEA.W    D6,A4
0238: 6706          BEQ.S      $0240
023A: 2F0C          MOVE.L     A4,-(A7)
023C: 3F04          MOVE.W     D4,-(A7)
023E: A965BA47      MOVE.L     -(A5),-17849(A4)
0242: 6706          BEQ.S      $024A
0244: 2F0C          MOVE.L     A4,-(A7)
0246: 3F05          MOVE.W     D5,-(A7)
0248: A9634CDF      MOVE.L     -(A3),19679(A4)
024C: 1CF04E5E      MOVE.B     94(A0,D4.L*8),(A6)+
0250: 4E75          RTS        


; ======= Function at 0x0252 =======
0252: 4E560000      LINK       A6,#0
0256: 2F0C          MOVE.L     A4,-(A7)
0258: 286E0008      MOVEA.L    8(A6),A4
025C: 49EC009C      LEA        156(A4),A4
0260: 4A94          TST.L      (A4)
0262: 6604          BNE.S      $0268
0264: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0268: 206E0008      MOVEA.L    8(A6),A0
026C: 2F2800A0      MOVE.L     160(A0),-(A7)
0270: 2F14          MOVE.L     (A4),-(A7)
0272: 4EBAFF7A      JSR        -134(PC)
0276: 286EFFFC      MOVEA.L    -4(A6),A4
027A: 4E5E          UNLK       A6
027C: 4E75          RTS        


; ======= Function at 0x027E =======
027E: 4E56FFF4      LINK       A6,#-12                        ; frame=12
0282: 2F07          MOVE.L     D7,-(A7)
0284: 486EFFF8      PEA        -8(A6)
0288: 2F3C00400040  MOVE.L     #$00400040,-(A7)
028E: 3F2DFA5C      MOVE.W     -1444(A5),-(A7)                ; A5-1444
0292: 3F2DFA5A      MOVE.W     -1446(A5),-(A7)                ; A5-1446
0296: A8A7          MOVE.L     -(A7),(A4)
0298: 42A7          CLR.L      -(A7)
029A: 2F2E0008      MOVE.L     8(A6),-(A7)
029E: 206E000C      MOVEA.L    12(A6),A0
02A2: 2F28000A      MOVE.L     10(A0),-(A7)
02A6: 486EFFF8      PEA        -8(A6)
02AA: A92B2E1F      MOVE.L     11807(A3),-(A4)
02AE: 671E          BEQ.S      $02CE
02B0: 2F2E0008      MOVE.L     8(A6),-(A7)
02B4: 4267          CLR.W      -(A7)
02B6: 2F07          MOVE.L     D7,-(A7)
02B8: A86B4267      MOVEA.L    16999(A3),A4
02BC: 2F07          MOVE.L     D7,-(A7)
02BE: A86A4227      MOVEA.L    16935(A2),A4
02C2: A91D          MOVE.L     (A5)+,-(A4)
02C4: 2F2E0008      MOVE.L     8(A6),-(A7)
02C8: 4EBA0068      JSR        104(PC)
02CC: 588F          MOVE.B     A7,(A4)
02CE: 2E1F          MOVE.L     (A7)+,D7
02D0: 4E5E          UNLK       A6
02D2: 4E75          RTS        


; ======= Function at 0x02D4 =======
02D4: 4E560000      LINK       A6,#0
02D8: 2F0C          MOVE.L     A4,-(A7)
02DA: 286E0008      MOVEA.L    8(A6),A4
02DE: 2F0C          MOVE.L     A4,-(A7)
02E0: A873486C      MOVEA.L    108(A3,D4.L),A4
02E4: 0010A8A3      ORI.B      #$A8A3,(A0)
02E8: 2F0C          MOVE.L     A4,-(A7)
02EA: 3F2E000C      MOVE.W     12(A6),-(A7)
02EE: 1F3C0001      MOVE.B     #$01,-(A7)
02F2: A83A2F0C      MOVE.L     12044(PC),D4
02F6: 4EBA003A      JSR        58(PC)
02FA: 286EFFFC      MOVEA.L    -4(A6),A4
02FE: 4E5E          UNLK       A6
0300: 4E75          RTS        


; ======= Function at 0x0302 =======
0302: 4E560000      LINK       A6,#0
0306: 0C6E0081000C  CMPI.W     #$0081,12(A6)
030C: 6604          BNE.S      $0312
030E: 7000          MOVEQ      #0,D0
0310: 6006          BRA.S      $0318
0312: 41ED074A      LEA        1866(A5),A0                    ; A5+1866
0316: 2008          MOVE.L     A0,D0
0318: 4E5E          UNLK       A6
031A: 4E75          RTS        


; ======= Function at 0x031C =======
031C: 4E560000      LINK       A6,#0
0320: 206E0008      MOVEA.L    8(A6),A0
0324: 2050          MOVEA.L    (A0),A0
0326: 2F280004      MOVE.L     4(A0),-(A7)
032A: 4EBAFE4E      JSR        -434(PC)
032E: 4E5E          UNLK       A6
0330: 4E75          RTS        


; ======= Function at 0x0332 =======
0332: 4E56FFE6      LINK       A6,#-26                        ; frame=26
0336: 2F0C          MOVE.L     A4,-(A7)
0338: 286E0008      MOVEA.L    8(A6),A4
033C: 2F0C          MOVE.L     A4,-(A7)
033E: A8732D6C      MOVEA.L    108(A3,D2.L*4),A4
0342: 0010FFE8      ORI.B      #$FFE8,(A0)
0346: 2D6C0014FFEC  MOVE.L     20(A4),-20(A6)
034C: 486EFFE8      PEA        -24(A6)
0350: A8A3          MOVE.L     -(A3),(A4)
0352: 486EFFE8      PEA        -24(A6)
0356: A928486E      MOVE.L     18542(A0),-(A4)
035A: FFF02F3C      MOVE.W     60(A0,D2.L*8),???
035E: 00040000      ORI.B      #$0000,D4
0362: 70F1          MOVEQ      #-15,D0
0364: D06EFFEE      MOVEA.B    -18(A6),A0
0368: 3F00          MOVE.W     D0,-(A7)
036A: 3F2EFFEC      MOVE.W     -20(A6),-(A7)
036E: A8A7          MOVE.L     -(A7),(A4)
0370: 2D6EFFF0FFF8  MOVE.L     -16(A6),-8(A6)
0376: 2D6EFFF4FFFC  MOVE.L     -12(A6),-4(A6)
037C: 3D7C0004FFFA  MOVE.W     #$0004,-6(A6)
0382: 486EFFF8      PEA        -8(A6)
0386: 4267          CLR.W      -(A7)
0388: 206C00A0      MOVEA.L    160(A4),A0
038C: 2050          MOVEA.L    (A0),A0
038E: 226C00A0      MOVEA.L    160(A4),A1
0392: 2251          MOVEA.L    (A1),A1
0394: 3011          MOVE.W     (A1),D0
0396: 90680008      MOVEA.B    8(A0),A0
039A: 3F00          MOVE.W     D0,-(A7)
039C: A8A8206C      MOVE.L     8300(A0),(A4)
03A0: 00A02050302E  ORI.L      #$2050302E,-(A0)
03A6: FFF4906E      MOVE.W     110(A4,A1.W),???
03AA: FFF048C0      MOVE.W     -64(A0,D4.L),???
03AE: 81E80018      ORA.L      24(A0),A0
03B2: 4840          PEA        D0
03B4: 916EFFF4206C  MOVE.B     -12(A6),8300(A0)
03BA: 00A02050216E  ORI.L      #$2050216E,-(A0)
03C0: FFF00008      MOVE.W     8(A0,D0.W),???
03C4: 216EFFF4000C  MOVE.L     -12(A6),12(A0)
03CA: 206C00A0      MOVEA.L    160(A4),A0
03CE: 2050          MOVEA.L    (A0),A0
03D0: 20AEFFF8      MOVE.L     -8(A6),(A0)
03D4: 216EFFFC0004  MOVE.L     -4(A6),4(A0)
03DA: 2F2C00A0      MOVE.L     160(A4),-(A7)
03DE: A9D04AAC009C  MOVE.L     (A0),#$4AAC009C
03E4: 6706          BEQ.S      $03EC
03E6: 2F2C009C      MOVE.L     156(A4),-(A7)
03EA: A9553D7C      MOVE.L     (A5),15740(A4)
03EE: FFFF          MOVE.W     ???,???
03F0: FFE8526E      MOVE.W     21102(A0),???
03F4: FFEE70F0      MOVE.W     28912(A6),???
03F8: D06EFFEE      MOVEA.B    -18(A6),A0
03FC: 3D40FFEA      MOVE.W     D0,-22(A6)
0400: 046E000EFFEC  SUBI.W     #$000E,-20(A6)
0406: 42A7          CLR.L      -(A7)
0408: 2F0C          MOVE.L     A4,-(A7)
040A: 486EFFE8      PEA        -24(A6)
040E: 2F2DF248      MOVE.L     -3512(A5),-(A7)                ; A5-3512
0412: 48780100      PEA        $0100.W
0416: 42A7          CLR.L      -(A7)
0418: 3F3C0010      MOVE.W     #$0010,-(A7)
041C: 486DF33C      PEA        -3268(A5)                      ; A5-3268
0420: A954295F      MOVE.L     (A4),10591(A4)
0424: 009C2F0C4EBA  ORI.L      #$2F0C4EBA,(A4)+
042A: FE28286E      MOVE.W     10350(A0),D7
042E: FFE2          MOVE.W     -(A2),???
0430: 4E5E          UNLK       A6
0432: 4E75          RTS        


; ======= Function at 0x0434 =======
0434: 4E56FFF4      LINK       A6,#-12                        ; frame=12
0438: 2F0C          MOVE.L     A4,-(A7)
043A: 286E0008      MOVEA.L    8(A6),A4
043E: 49EC00A0      LEA        160(A4),A4
0442: 2054          MOVEA.L    (A4),A0
0444: 2050          MOVEA.L    (A0),A0
0446: 2D680008FFF8  MOVE.L     8(A0),-8(A6)
044C: 2D68000CFFFC  MOVE.L     12(A0),-4(A6)
0452: 2F2E0008      MOVE.L     8(A6),-(A7)
0456: A8732F2E      MOVEA.L    46(A3,D2.L*8),A4
045A: 00084EAD      ORI.B      #$4EAD,A0
045E: 061A486E      ADDI.B     #$486E,(A2)+
0462: FFF8A8A3      MOVE.W     $A8A3.W,???
0466: 486EFFF8      PEA        -8(A6)
046A: 2F14          MOVE.L     (A4),-(A7)
046C: A9D3286EFFF0  MOVE.L     (A3),#$286EFFF0
0472: 4E5E          UNLK       A6
0474: 4E75          RTS        


; ======= Function at 0x0476 =======
0476: 4E56FFFC      LINK       A6,#-4                         ; frame=4
047A: 2F2E0008      MOVE.L     8(A6),-(A7)
047E: 4EAD061A      JSR        1562(A5)                       ; JT[1562]
0482: 206E0008      MOVEA.L    8(A6),A0
0486: 2EA800A0      MOVE.L     160(A0),(A7)
048A: A9D8206E0008  MOVE.L     (A0)+,#$206E0008
0490: 2F28009C      MOVE.L     156(A0),-(A7)
0494: 4267          CLR.W      -(A7)
0496: A95D4E5E      MOVE.L     (A5)+,20062(A4)
049A: 4E75          RTS        


; ======= Function at 0x049C =======
049C: 4E56FFFC      LINK       A6,#-4                         ; frame=4
04A0: 2F2E0008      MOVE.L     8(A6),-(A7)
04A4: 4EAD061A      JSR        1562(A5)                       ; JT[1562]
04A8: 206E0008      MOVEA.L    8(A6),A0
04AC: 2EA800A0      MOVE.L     160(A0),(A7)
04B0: A9D9206E0008  MOVE.L     (A1)+,#$206E0008
04B6: 2F28009C      MOVE.L     156(A0),-(A7)
04BA: 3F3C00FF      MOVE.W     #$00FF,-(A7)
04BE: A95D4E5E      MOVE.L     (A5)+,20062(A4)
04C2: 4E75          RTS        


; ======= Function at 0x04C4 =======
04C4: 4E560000      LINK       A6,#0
04C8: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
04CC: 266E0008      MOVEA.L    8(A6),A3
04D0: 206E000C      MOVEA.L    12(A6),A0
04D4: 3E280004      MOVE.W     4(A0),D7
04D8: 0247FF00      ANDI.W     #$FF00,D7
04DC: 0C470001      CMPI.W     #$0001,D7
04E0: 6612          BNE.S      $04F4
04E2: 2F2B009C      MOVE.L     156(A3),-(A7)
04E6: 4267          CLR.W      -(A7)
04E8: A9632F0B      MOVE.L     -(A3),12043(A4)
04EC: 4EBAFC8C      JSR        -884(PC)
04F0: 588F          MOVE.B     A7,(A4)
04F2: 606C          BRA.S      $0560
04F4: 0C470004      CMPI.W     #$0004,D7
04F8: 6618          BNE.S      $0512
04FA: 49EB009C      LEA        156(A3),A4
04FE: 2F14          MOVE.L     (A4),-(A7)
0500: 4267          CLR.W      -(A7)
0502: 2F14          MOVE.L     (A4),-(A7)
0504: A962A963      MOVE.L     -(A2),-22173(A4)
0508: 2F0B          MOVE.L     A3,-(A7)
050A: 4EBAFC6E      JSR        -914(PC)
050E: 588F          MOVE.B     A7,(A4)
0510: 604E          BRA.S      $0560
0512: 0C47000B      CMPI.W     #$000B,D7
0516: 660E          BNE.S      $0526
0518: 2F2B009C      MOVE.L     156(A3),-(A7)
051C: 3F3C0016      MOVE.W     #$0016,-(A7)
0520: 4EBAFB9C      JSR        -1124(PC)
0524: 603A          BRA.S      $0560
0526: 0C47000C      CMPI.W     #$000C,D7
052A: 660E          BNE.S      $053A
052C: 2F2B009C      MOVE.L     156(A3),-(A7)
0530: 3F3C0017      MOVE.W     #$0017,-(A7)
0534: 4EBAFB88      JSR        -1144(PC)
0538: 6026          BRA.S      $0560
053A: 3F2B00A6      MOVE.W     166(A3),-(A7)
053E: 2F2E000C      MOVE.L     12(A6),-(A7)
0542: 2F2B00A0      MOVE.L     160(A3),-(A7)
0546: 4EAD05FA      JSR        1530(A5)                       ; JT[1530]
054A: 4A40          TST.W      D0
054C: 4FEF000A      LEA        10(A7),A7
0550: 670E          BEQ.S      $0560
0552: 377C000100A4  MOVE.W     #$0001,164(A3)
0558: 2F0B          MOVE.L     A3,-(A7)
055A: 4EBAFCF6      JSR        -778(PC)
055E: 588F          MOVE.B     A7,(A4)
0560: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
0564: 4E5E          UNLK       A6
0566: 4E75          RTS        


; ======= Function at 0x0568 =======
0568: 4E56FFFC      LINK       A6,#-4                         ; frame=4
056C: 2F0C          MOVE.L     A4,-(A7)
056E: 286E0008      MOVEA.L    8(A6),A4
0572: 206E000C      MOVEA.L    12(A6),A0
0576: 2D68000AFFFC  MOVE.L     10(A0),-4(A6)
057C: 2F0C          MOVE.L     A4,-(A7)
057E: A873486E      MOVEA.L    110(A3,D4.L),A4
0582: FFFCA871      MOVE.W     #$A871,???
0586: 4227          CLR.B      -(A7)
0588: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
058C: 206C00A0      MOVEA.L    160(A4),A0
0590: 2050          MOVEA.L    (A0),A0
0592: 48680008      PEA        8(A0)
0596: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
059A: 672A          BEQ.S      $05C6
059C: 486DF278      PEA        -3464(A5)                      ; A5-3464
05A0: A851          MOVEA.L    (A1),A4
05A2: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
05A6: 206E000C      MOVEA.L    12(A6),A0
05AA: 08280001000E  BTST       #1,14(A0)
05B0: 6704          BEQ.S      $05B6
05B2: 7001          MOVEQ      #1,D0
05B4: 6002          BRA.S      $05B8
05B6: 7000          MOVEQ      #0,D0
05B8: 1F00          MOVE.B     D0,-(A7)
05BA: 2F2C00A0      MOVE.L     160(A4),-(A7)
05BE: A9D42F0C4EBA  MOVE.L     (A4),#$2F0C4EBA
05C4: FC8E          MOVE.W     A6,(A6)
05C6: 286EFFF8      MOVEA.L    -8(A6),A4
05CA: 4E5E          UNLK       A6
05CC: 4E75          RTS        


; ======= Function at 0x05CE =======
05CE: 4E56FFFC      LINK       A6,#-4                         ; frame=4
05D2: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
05D6: 266E0008      MOVEA.L    8(A6),A3
05DA: 99CC2F0B      MOVE.B     A4,#$0B
05DE: A873206E      MOVEA.L    110(A3,D2.W),A4
05E2: 000C2D68      ORI.B      #$2D68,A4
05E6: 000AFFFC      ORI.B      #$FFFC,A2
05EA: 486EFFFC      PEA        -4(A6)
05EE: A8714227      MOVEA.L    39(A1,D4.W*2),A4
05F2: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
05F6: 2F2B0018      MOVE.L     24(A3),-(A7)
05FA: A8E84A1F      MOVE.L     18975(A0),(A4)+
05FE: 6620          BNE.S      $0620
0600: 4A6B00A6      TST.W      166(A3)
0604: 661A          BNE.S      $0620
0606: 4227          CLR.B      -(A7)
0608: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
060C: 206B00A0      MOVEA.L    160(A3),A0
0610: 2050          MOVEA.L    (A0),A0
0612: 48680008      PEA        8(A0)
0616: A8AD4A1F      MOVE.L     18975(A5),(A4)                 ; A5+18975
061A: 6704          BEQ.S      $0620
061C: 49EDF278      LEA        -3464(A5),A4                   ; A5-3464
0620: 4A6B00A6      TST.W      166(A3)
0624: 670E          BEQ.S      $0634
0626: 206B00A0      MOVEA.L    160(A3),A0
062A: 2050          MOVEA.L    (A0),A0
062C: 0C68FFFF0038  CMPI.W     #$FFFF,56(A0)
0632: 6606          BNE.S      $063A
0634: 2F2B00A0      MOVE.L     160(A3),-(A7)
0638: A9DA200C4CDF  MOVE.L     (A2)+,#$200C4CDF
063E: 1800          MOVE.B     D0,D4
0640: 4E5E          UNLK       A6
0642: 4E75          RTS        


; ======= Function at 0x0644 =======
0644: 4E560000      LINK       A6,#0
0648: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
064C: 286E0008      MOVEA.L    8(A6),A4
0650: 49EC009C      LEA        156(A4),A4
0654: 4267          CLR.W      -(A7)
0656: 2F14          MOVE.L     (A4),-(A7)
0658: A9603E1F      MOVE.L     -(A0),15903(A4)
065C: 4267          CLR.W      -(A7)
065E: 2F14          MOVE.L     (A4),-(A7)
0660: A9623C1F      MOVE.L     -(A2),15391(A4)
0664: 206E0008      MOVEA.L    8(A6),A0
0668: 246800A0      MOVEA.L    160(A0),A2
066C: 2F0A          MOVE.L     A2,-(A7)
066E: 4EBAFB66      JSR        -1178(PC)
0672: 3A00          MOVE.W     D0,D5
0674: 2E8A          MOVE.L     A2,(A7)
0676: 4EBA031A      JSR        794(PC)
067A: 2652          MOVEA.L    (A2),A3
067C: 382B005E      MOVE.W     94(A3),D4
0680: 9840          MOVEA.B    D0,A4
0682: C9EB0018      ANDA.L     24(A3),A4
0686: 4A45          TST.W      D5
0688: 588F          MOVE.B     A7,(A4)
068A: 6C02          BGE.S      $068E
068C: 7A00          MOVEQ      #0,D5
068E: 4A44          TST.W      D4
0690: 6C02          BGE.S      $0694
0692: 7800          MOVEQ      #0,D4
0694: B846          MOVEA.W    D6,A4
0696: 6706          BEQ.S      $069E
0698: 2F14          MOVE.L     (A4),-(A7)
069A: 3F04          MOVE.W     D4,-(A7)
069C: A965BA47      MOVE.L     -(A5),-17849(A4)
06A0: 6706          BEQ.S      $06A8
06A2: 2F14          MOVE.L     (A4),-(A7)
06A4: 3F05          MOVE.W     D5,-(A7)
06A6: A9634CDF      MOVE.L     -(A3),19679(A4)
06AA: 1CF04E5E      MOVE.B     94(A0,D4.L*8),(A6)+
06AE: 4E75          RTS        


; ======= Function at 0x06B0 =======
06B0: 4E56FFFC      LINK       A6,#-4                         ; frame=4
06B4: 2F0C          MOVE.L     A4,-(A7)
06B6: 286E0008      MOVEA.L    8(A6),A4
06BA: 49EC00A0      LEA        160(A4),A4
06BE: 2F14          MOVE.L     (A4),-(A7)
06C0: A9D62F14A9D0  MOVE.L     (A6),#$2F14A9D0
06C6: 2F2E0008      MOVE.L     8(A6),-(A7)
06CA: 4EBAFF78      JSR        -136(PC)
06CE: 206E0008      MOVEA.L    8(A6),A0
06D2: 317C000100A4  MOVE.W     #$0001,164(A0)
06D8: 3B7C0001F276  MOVE.W     #$0001,-3466(A5)
06DE: 286EFFF8      MOVEA.L    -8(A6),A4
06E2: 4E5E          UNLK       A6
06E4: 4E75          RTS        


; ======= Function at 0x06E6 =======
06E6: 4E560000      LINK       A6,#0
06EA: 206E0008      MOVEA.L    8(A6),A0
06EE: 2F2800A0      MOVE.L     160(A0),-(A7)
06F2: A9D53B7C0001  MOVE.L     (A5),#$3B7C0001
06F8: F2764E5E      MOVEA.W    94(A6,D4.L*8),A1
06FC: 4E75          RTS        


; ======= Function at 0x06FE =======
06FE: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0702: 2F0C          MOVE.L     A4,-(A7)
0704: 286E0008      MOVEA.L    8(A6),A4
0708: 49EC00A0      LEA        160(A4),A4
070C: 2F14          MOVE.L     (A4),-(A7)
070E: A9DB2F14A9D0  MOVE.L     (A3)+,#$2F14A9D0
0714: 2F2E0008      MOVE.L     8(A6),-(A7)
0718: 4EBAFF2A      JSR        -214(PC)
071C: 206E0008      MOVEA.L    8(A6),A0
0720: 317C000100A4  MOVE.W     #$0001,164(A0)
0726: 286EFFF8      MOVEA.L    -8(A6),A4
072A: 4E5E          UNLK       A6
072C: 4E75          RTS        


; ======= Function at 0x072E =======
072E: 4E560000      LINK       A6,#0
0732: 48E70038      MOVEM.L    A2/A3/A4,-(SP)                 ; save
0736: 266E0008      MOVEA.L    8(A6),A3
073A: 49EB00A0      LEA        160(A3),A4
073E: 2054          MOVEA.L    (A4),A0
0740: 2450          MOVEA.L    (A0),A2
0742: 302A0020      MOVE.W     32(A2),D0
0746: B06A0022      MOVEA.W    34(A2),A0
074A: 6716          BEQ.S      $0762
074C: 2F14          MOVE.L     (A4),-(A7)
074E: A9D72F14A9D0  MOVE.L     (A7),#$2F14A9D0
0754: 2F0B          MOVE.L     A3,-(A7)
0756: 4EBAFEEC      JSR        -276(PC)
075A: 377C000100A4  MOVE.W     #$0001,164(A3)
0760: 588F          MOVE.B     A7,(A4)
0762: 4CDF1C00      MOVEM.L    (SP)+,A2/A3/A4                 ; restore
0766: 4E5E          UNLK       A6
0768: 4E75          RTS        


; ======= Function at 0x076A =======
076A: 4E560000      LINK       A6,#0
076E: 206E0008      MOVEA.L    8(A6),A0
0772: 2F2800A0      MOVE.L     160(A0),-(A7)
0776: 4EBA028E      JSR        654(PC)
077A: 4E5E          UNLK       A6
077C: 4E75          RTS        


; ======= Function at 0x077E =======
077E: 4E560000      LINK       A6,#0
0782: 206E0008      MOVEA.L    8(A6),A0
0786: 302800A6      MOVE.W     166(A0),D0
078A: 4E5E          UNLK       A6
078C: 4E75          RTS        


; ======= Function at 0x078E =======
078E: 4E560000      LINK       A6,#0
0792: 2F0C          MOVE.L     A4,-(A7)
0794: 206E0008      MOVEA.L    8(A6),A0
0798: 286800A0      MOVEA.L    160(A0),A4
079C: 2254          MOVEA.L    (A4),A1
079E: 30290020      MOVE.W     32(A1),D0
07A2: B0690022      MOVEA.W    34(A1),A0
07A6: 6724          BEQ.S      $07CC
07A8: 2F2E0008      MOVE.L     8(A6),-(A7)
07AC: 4EBAFFD0      JSR        -48(PC)
07B0: 4A40          TST.W      D0
07B2: 588F          MOVE.B     A7,(A4)
07B4: 6616          BNE.S      $07CC
07B6: 2F2E000C      MOVE.L     12(A6),-(A7)
07BA: 4267          CLR.W      -(A7)
07BC: 2F2E0010      MOVE.L     16(A6),-(A7)
07C0: A86B2F2D      MOVEA.L    12077(A3),A4
07C4: F354A947      MOVE.W     (A4),-22201(A1)
07C8: 7001          MOVEQ      #1,D0
07CA: 6014          BRA.S      $07E0
07CC: 2F2E000C      MOVE.L     12(A6),-(A7)
07D0: 4267          CLR.W      -(A7)
07D2: 2F2E0010      MOVE.L     16(A6),-(A7)
07D6: A86B2F2D      MOVEA.L    12077(A3),A4
07DA: F250          MOVEA.W    (A0),A1
07DC: A9477000      MOVE.L     D7,28672(A4)
07E0: 285F          MOVEA.L    (A7)+,A4
07E2: 4E5E          UNLK       A6
07E4: 4E75          RTS        


; ======= Function at 0x07E6 =======
07E6: 4E560000      LINK       A6,#0
07EA: 2F0C          MOVE.L     A4,-(A7)
07EC: 206E0008      MOVEA.L    8(A6),A0
07F0: 286800A0      MOVEA.L    160(A0),A4
07F4: 2254          MOVEA.L    (A4),A1
07F6: 30290020      MOVE.W     32(A1),D0
07FA: B0690022      MOVEA.W    34(A1),A0
07FE: 6724          BEQ.S      $0824
0800: 2F2E0008      MOVE.L     8(A6),-(A7)
0804: 4EBAFF78      JSR        -136(PC)
0808: 4A40          TST.W      D0
080A: 588F          MOVE.B     A7,(A4)
080C: 6616          BNE.S      $0824
080E: 2F2E000C      MOVE.L     12(A6),-(A7)
0812: 4267          CLR.W      -(A7)
0814: 2F2E0010      MOVE.L     16(A6),-(A7)
0818: A86B2F2D      MOVEA.L    12077(A3),A4
081C: F358A947      MOVE.W     (A0)+,-22201(A1)
0820: 7001          MOVEQ      #1,D0
0822: 6014          BRA.S      $0838
0824: 2F2E000C      MOVE.L     12(A6),-(A7)
0828: 4267          CLR.W      -(A7)
082A: 2F2E0010      MOVE.L     16(A6),-(A7)
082E: A86B2F2D      MOVEA.L    12077(A3),A4
0832: F254          MOVEA.W    (A4),A1
0834: A9477000      MOVE.L     D7,28672(A4)
0838: 285F          MOVEA.L    (A7)+,A4
083A: 4E5E          UNLK       A6
083C: 4E75          RTS        


; ======= Function at 0x083E =======
083E: 4E560000      LINK       A6,#0
0842: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
0846: 206E0008      MOVEA.L    8(A6),A0
084A: 286800A0      MOVEA.L    160(A0),A4
084E: 2654          MOVEA.L    (A4),A3
0850: 302B0020      MOVE.W     32(A3),D0
0854: B06B0022      MOVEA.W    34(A3),A0
0858: 6716          BEQ.S      $0870
085A: 2F2E000C      MOVE.L     12(A6),-(A7)
085E: 4267          CLR.W      -(A7)
0860: 2F2E0010      MOVE.L     16(A6),-(A7)
0864: A86B2F2D      MOVEA.L    12077(A3),A4
0868: F35CA947      MOVE.W     (A4)+,-22201(A1)
086C: 7001          MOVEQ      #1,D0
086E: 6014          BRA.S      $0884
0870: 2F2E000C      MOVE.L     12(A6),-(A7)
0874: 4267          CLR.W      -(A7)
0876: 2F2E0010      MOVE.L     16(A6),-(A7)
087A: A86B2F2D      MOVEA.L    12077(A3),A4
087E: F258          MOVEA.W    (A0)+,A1
0880: A9477000      MOVE.L     D7,28672(A4)
0884: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
0888: 4E5E          UNLK       A6
088A: 4E75          RTS        


; ======= Function at 0x088C =======
088C: 4E560000      LINK       A6,#0
0890: 4A780AB0      TST.W      $0AB0.W
0894: 6724          BEQ.S      $08BA
0896: 2F2E0008      MOVE.L     8(A6),-(A7)
089A: 4EBAFEE2      JSR        -286(PC)
089E: 4A40          TST.W      D0
08A0: 588F          MOVE.B     A7,(A4)
08A2: 6616          BNE.S      $08BA
08A4: 2F2E000C      MOVE.L     12(A6),-(A7)
08A8: 4267          CLR.W      -(A7)
08AA: 2F2E0010      MOVE.L     16(A6),-(A7)
08AE: A86B2F2D      MOVEA.L    12077(A3),A4
08B2: F360A947      MOVE.W     -(A0),-22201(A1)
08B6: 7001          MOVEQ      #1,D0
08B8: 6014          BRA.S      $08CE
08BA: 2F2E000C      MOVE.L     12(A6),-(A7)
08BE: 4267          CLR.W      -(A7)
08C0: 2F2E0010      MOVE.L     16(A6),-(A7)
08C4: A86B2F2D      MOVEA.L    12077(A3),A4
08C8: F25C          MOVEA.W    (A4)+,A1
08CA: A9477000      MOVE.L     D7,28672(A4)
08CE: 4E5E          UNLK       A6
08D0: 4E75          RTS        


; ======= Function at 0x08D2 =======
08D2: 4E56FFF4      LINK       A6,#-12                        ; frame=12
08D6: 2F0B          MOVE.L     A3,-(A7)
08D8: 4AAE0008      TST.L      8(A6)
08DC: 660C          BNE.S      $08EA
08DE: 203C000000A8  MOVE.L     #$000000A8,D0
08E4: A11E          MOVE.L     (A6)+,-(A0)
08E6: 2D480008      MOVE.L     A0,8(A6)
08EA: 42A7          CLR.L      -(A7)
08EC: 2F2E0008      MOVE.L     8(A6),-(A7)
08F0: 2F2E000C      MOVE.L     12(A6),-(A7)
08F4: 2F2E0010      MOVE.L     16(A6),-(A7)
08F8: 2F3C00080000  MOVE.L     #$00080000,-(A7)
08FE: 4878FFFF      PEA        $FFFF.W
0902: 1F3C0001      MOVE.B     #$01,-(A7)
0906: 486DF3AC      PEA        -3156(A5)                      ; A5-3156
090A: A913          MOVE.L     (A3),-(A4)
090C: 265F          MOVEA.L    (A7)+,A3
090E: 42AB009C      CLR.L      156(A3)
0912: 426B00A4      CLR.W      164(A3)
0916: 3F2E0018      MOVE.W     24(A6),-(A7)
091A: 3F2E0016      MOVE.W     22(A6),-(A7)
091E: 3F2E0014      MOVE.W     20(A6),-(A7)
0922: 2F2E000C      MOVE.L     12(A6),-(A7)
0926: 2F0B          MOVE.L     A3,-(A7)
0928: 4EBA000C      JSR        12(PC)
092C: 200B          MOVE.L     A3,D0
092E: 266EFFF0      MOVEA.L    -16(A6),A3
0932: 4E5E          UNLK       A6
0934: 4E75          RTS        


; ======= Function at 0x0936 =======
0936: 4E560000      LINK       A6,#0
093A: 2F0C          MOVE.L     A4,-(A7)
093C: 286E0008      MOVEA.L    8(A6),A4
0940: 200C          MOVE.L     A4,D0
0942: 6604          BNE.S      $0948
0944: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0948: 2F0C          MOVE.L     A4,-(A7)
094A: A8733F2E      MOVEA.L    46(A3,D3.L*8),A4
094E: 0012A887      ORI.B      #$A887,(A2)
0952: 3F2E0014      MOVE.W     20(A6),-(A7)
0956: A88A          MOVE.L     A2,(A4)
0958: 396E001000A6  MOVE.W     16(A6),166(A4)
095E: 42A7          CLR.L      -(A7)
0960: 2F2E000C      MOVE.L     12(A6),-(A7)
0964: 2F2E000C      MOVE.L     12(A6),-(A7)
0968: A9D2295F00A0  MOVE.L     (A2),#$295F00A0
096E: 486D0602      PEA        1538(A5)                       ; A5+1538
0972: 2F2C00A0      MOVE.L     160(A4),-(A7)
0976: 4EAD0BDA      JSR        3034(A5)                       ; JT[3034]
097A: 1F3C0001      MOVE.B     #$01,-(A7)
097E: 2F2C00A0      MOVE.L     160(A4),-(A7)
0982: A813          MOVE.L     (A3),D4
0984: 2F0C          MOVE.L     A4,-(A7)
0986: 4EBAF9AA      JSR        -1622(PC)
098A: 286EFFFC      MOVEA.L    -4(A6),A4
098E: 4E5E          UNLK       A6
0990: 4E75          RTS        


; ======= Function at 0x0992 =======
0992: 4E56FFF8      LINK       A6,#-8                         ; frame=8
0996: 206E0008      MOVEA.L    8(A6),A0
099A: 2050          MOVEA.L    (A0),A0
099C: 2D680008FFF8  MOVE.L     8(A0),-8(A6)
09A2: 2D68000CFFFC  MOVE.L     12(A0),-4(A6)
09A8: 206E0008      MOVEA.L    8(A6),A0
09AC: 2050          MOVEA.L    (A0),A0
09AE: 302EFFFC      MOVE.W     -4(A6),D0
09B2: 906EFFF8      MOVEA.B    -8(A6),A0
09B6: 48C0          EXT.L      D0
09B8: 81E80018      ORA.L      24(A0),A0
09BC: 4E5E          UNLK       A6
09BE: 4E75          RTS        


; ======= Function at 0x09C0 =======
09C0: 4E560000      LINK       A6,#0
09C4: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
09C8: 266E0008      MOVEA.L    8(A6),A3
09CC: 49EB00A0      LEA        160(A3),A4
09D0: 4A94          TST.L      (A4)
09D2: 6604          BNE.S      $09D8
09D4: 4EAD01A2      JSR        418(A5)                        ; JT[418]
09D8: 2F2E000C      MOVE.L     12(A6),-(A7)
09DC: 2F2E000C      MOVE.L     12(A6),-(A7)
09E0: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
09E4: 2E80          MOVE.L     D0,(A7)
09E6: 2F14          MOVE.L     (A4),-(A7)
09E8: A9DE2F0B4EBA  MOVE.L     (A6)+,#$2F0B4EBA
09EE: F864          MOVEA.W    -(A4),A4
09F0: 2E8B          MOVE.L     A3,(A7)
09F2: 4EBAF786      JSR        -2170(PC)
09F6: 377C000100A4  MOVE.W     #$0001,164(A3)
09FC: 4CEE1800FFF8  MOVEM.L    -8(A6),A3/A4
0A02: 4E5E          UNLK       A6
0A04: 4E75          RTS        


; ======= Function at 0x0A06 =======
0A06: 4E560000      LINK       A6,#0
0A0A: 42A7          CLR.L      -(A7)
0A0C: 2F3C0000FFFF  MOVE.L     #$0000FFFF,-(A7)
0A12: 2F2E0008      MOVE.L     8(A6),-(A7)
0A16: A9D14E5E4E75  MOVE.L     (A1),#$4E5E4E75

; ======= Function at 0x0A1C =======
0A1C: 4E560000      LINK       A6,#0
0A20: 2F0C          MOVE.L     A4,-(A7)
0A22: 286E0008      MOVEA.L    8(A6),A4
0A26: 49EC00A0      LEA        160(A4),A4
0A2A: 2F14          MOVE.L     (A4),-(A7)
0A2C: 4EBAFFD8      JSR        -40(PC)
0A30: 2E94          MOVE.L     (A4),(A7)
0A32: A9D7285F4E5E  MOVE.L     (A7),#$285F4E5E
0A38: 4E75          RTS        
