;======================================================================
; CODE 45 Disassembly
; File: /tmp/maven_code_45.bin
; Header: JT offset=2752, JT entries=4
; Code size: 1122 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FFF4      LINK       A6,#-12                        ; frame=12
0004: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
0008: 286E0008      MOVEA.L    8(A6),A4
000C: 0C6D0001B1D6  CMPI.W     #$0001,-20010(A5)
0012: 6616          BNE.S      $002A
0014: 0C2C000F0020  CMPI.B     #$000F,32(A4)
001A: 6F0E          BLE.S      $002A
001C: 2F0C          MOVE.L     A4,-(A7)
001E: 4EAD0ACA      JSR        2762(A5)                       ; JT[2762]
0022: 4A40          TST.W      D0
0024: 588F          MOVE.B     A7,(A4)
0026: 6700017C      BEQ.W      $01A6
002A: 4A6C001C      TST.W      28(A4)
002E: 6720          BEQ.S      $0050
0030: 202C0010      MOVE.L     16(A4),D0
0034: B0ADA5DE      MOVE.W     -23074(A5),(A0)                ; g_dawg_ptr
0038: 6F00016A      BLE.W      $01A6
003C: 41EDA5CE      LEA        -23090(A5),A0                  ; g_dawg_info
0040: 43D4          LEA        (A4),A1
0042: 7007          MOVEQ      #7,D0
0044: 20D9          MOVE.L     (A1)+,(A0)+
0046: 51C8FFFC      DBF        D0,$0044                       ; loop
004A: 30D9          MOVE.W     (A1)+,(A0)+
004C: 60000156      BRA.W      $01A6
0050: 2D6DF9D4FFF8  MOVE.L     -1580(A5),-8(A6)               ; A5-1580
0056: 2D6DF9FCFFF4  MOVE.L     -1540(A5),-12(A6)              ; A5-1540
005C: 486EFFFC      PEA        -4(A6)
0060: 486EFFFE      PEA        -2(A6)
0064: 486EFFF4      PEA        -12(A6)
0068: 486EFFF8      PEA        -8(A6)
006C: 2F0C          MOVE.L     A4,-(A7)
006E: 4EAD082A      JSR        2090(A5)                       ; JT[2090]
0072: 4A40          TST.W      D0
0074: 4FEF0014      LEA        20(A7),A7
0078: 6600012A      BNE.W      $01A6
007C: 7E00          MOVEQ      #0,D7
007E: 47EDF9B0      LEA        -1616(A5),A3                   ; A5-1616
0082: 6004          BRA.S      $0088
0084: 5247          MOVEA.B    D7,A1
0086: 588B          MOVE.B     A3,(A4)
0088: BE6DCF04      MOVEA.W    -12540(A5),A7
008C: 6C08          BGE.S      $0096
008E: 202EFFF8      MOVE.L     -8(A6),D0
0092: B093          MOVE.W     (A3),(A0)
0094: 6FEE          BLE.S      $0084
0096: 7C00          MOVEQ      #0,D6
0098: 47EDF9D8      LEA        -1576(A5),A3                   ; A5-1576
009C: 6004          BRA.S      $00A2
009E: 5246          MOVEA.B    D6,A1
00A0: 588B          MOVE.B     A3,(A4)
00A2: BC6DCF04      MOVEA.W    -12540(A5),A6
00A6: 6C08          BGE.S      $00B0
00A8: 202EFFF4      MOVE.L     -12(A6),D0
00AC: B093          MOVE.W     (A3),(A0)
00AE: 6FEE          BLE.S      $009E
00B0: 0C6D000ACF04  CMPI.W     #$000A,-12540(A5)
00B6: 6404          BCC.S      $00BC
00B8: 526DCF04      MOVEA.B    -12540(A5),A1
00BC: 0C47000A      CMPI.W     #$000A,D7
00C0: 6438          BCC.S      $00FA
00C2: 2007          MOVE.L     D7,D0
00C4: 48C0          EXT.L      D0
00C6: E58847ED      MOVE.L     A0,-19(A2,D4.W*8)
00CA: F9B0D08B2640  MOVE.W     -117(A0,A5.W),64(A4,D2.W*8)
00D0: 70FF          MOVEQ      #-1,D0
00D2: D06DCF04      MOVEA.B    -12540(A5),A0
00D6: 9047          MOVEA.B    D7,A0
00D8: 48C0          EXT.L      D0
00DA: E5882F00      MOVE.L     A0,0(A2,D2.L*8)
00DE: 2F0B          MOVE.L     A3,-(A7)
00E0: 204D          MOVEA.L    A5,A0
00E2: 2007          MOVE.L     D7,D0
00E4: 48C0          EXT.L      D0
00E6: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
00EA: 4868F9B4      PEA        -1612(A0)
00EE: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
00F2: 26AEFFF8      MOVE.L     -8(A6),(A3)
00F6: 4FEF000C      LEA        12(A7),A7
00FA: 0C46000A      CMPI.W     #$000A,D6
00FE: 6438          BCC.S      $0138
0100: 2006          MOVE.L     D6,D0
0102: 48C0          EXT.L      D0
0104: E58847ED      MOVE.L     A0,-19(A2,D4.W*8)
0108: F9D8D08B      MOVE.W     (A0)+,#$D08B
010C: 2640          MOVEA.L    D0,A3
010E: 70FF          MOVEQ      #-1,D0
0110: D06DCF04      MOVEA.B    -12540(A5),A0
0114: 9046          MOVEA.B    D6,A0
0116: 48C0          EXT.L      D0
0118: E5882F00      MOVE.L     A0,0(A2,D2.L*8)
011C: 2F0B          MOVE.L     A3,-(A7)
011E: 204D          MOVEA.L    A5,A0
0120: 2006          MOVE.L     D6,D0
0122: 48C0          EXT.L      D0
0124: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0128: 4868F9DC      PEA        -1572(A0)
012C: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0130: 26AEFFF4      MOVE.L     -12(A6),(A3)
0134: 4FEF000C      LEA        12(A7),A7
0138: 4A2C0020      TST.B      32(A4)
013C: 6634          BNE.S      $0172
013E: 2F2DCF28      MOVE.L     -12504(A5),-(A7)               ; A5-12504
0142: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
0146: 3C00          MOVE.W     D0,D6
0148: 2EADCF2C      MOVE.L     -12500(A5),(A7)                ; A5-12500
014C: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
0150: 9C40          MOVEA.B    D0,A6
0152: 3046          MOVEA.W    D6,A0
0154: B1EEFFF4588F  MOVE.W     -12(A6),$588F.W
015A: 6C06          BGE.S      $0162
015C: 3046          MOVEA.W    D6,A0
015E: 2D48FFF4      MOVE.L     A0,-12(A6)
0162: 3046          MOVEA.W    D6,A0
0164: B1EEFFF86C14  MOVE.W     -8(A6),$6C14.W
016A: 3046          MOVEA.W    D6,A0
016C: 2D48FFF8      MOVE.L     A0,-8(A6)
0170: 600C          BRA.S      $017E
0172: 2E2C0010      MOVE.L     16(A4),D7
0176: 9FAEFFF89FAE  MOVE.B     -8(A6),-82(A7,A1.L*8)
017C: FFF4306E      MOVE.W     110(A4,D3.W),???
0180: FFFE          MOVE.W     ???,???
0182: 29480014      MOVE.L     A0,20(A4)
0186: 306EFFFC      MOVEA.W    -4(A6),A0
018A: 29480018      MOVE.L     A0,24(A4)
018E: 202EFFF8      MOVE.L     -8(A6),D0
0192: 4480          NEG.L      D0
0194: 2F00          MOVE.L     D0,-(A7)
0196: 202EFFF4      MOVE.L     -12(A6),D0
019A: 4480          NEG.L      D0
019C: 2F00          MOVE.L     D0,-(A7)
019E: 2F0C          MOVE.L     A4,-(A7)
01A0: 4EAD08A2      JSR        2210(A5)                       ; JT[2210]
01A4: 4CEE18C0FFE4  MOVEM.L    -28(A6),D6/D7/A3/A4
01AA: 4E5E          UNLK       A6
01AC: 4E75          RTS        


; ======= Function at 0x01AE =======
01AE: 4E560000      LINK       A6,#0
01B2: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
01B6: 286E0008      MOVEA.L    8(A6),A4
01BA: 2F2E000C      MOVE.L     12(A6),-(A7)
01BE: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
01C2: D040          MOVEA.B    D0,A0
01C4: 48C0          EXT.L      D0
01C6: 2E00          MOVE.L     D0,D7
01C8: 42AC0014      CLR.L      20(A4)
01CC: 7001          MOVEQ      #1,D0
01CE: 29400018      MOVE.L     D0,24(A4)
01D2: 2C07          MOVE.L     D7,D6
01D4: 4486          NEG.L      D6
01D6: 2E86          MOVE.L     D6,(A7)
01D8: 2F06          MOVE.L     D6,-(A7)
01DA: 2F0C          MOVE.L     A4,-(A7)
01DC: 4EAD08A2      JSR        2210(A5)                       ; JT[2210]
01E0: 4CEE10C0FFF4  MOVEM.L    -12(A6),D6/D7/A4
01E6: 4E5E          UNLK       A6
01E8: 4E75          RTS        


; ======= Function at 0x01EA =======
01EA: 4E56FFFA      LINK       A6,#-6                         ; frame=6
01EE: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
01F2: 286E0008      MOVEA.L    8(A6),A4
01F6: 4EAD0A22      JSR        2594(A5)                       ; JT[2594]
01FA: 302C0008      MOVE.W     8(A4),D0
01FE: 9154426C      MOVE.B     (A4),17004(A0)
0202: 00084A2C      ORI.B      #$4A2C,A0
0206: 0018660A      ORI.B      #$660A,(A0)+
020A: 4A2C001D      TST.B      29(A4)
020E: 6704          BEQ.S      $0214
0210: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0214: 4A2C001A      TST.B      26(A4)
0218: 662C          BNE.S      $0246
021A: 4EAD08B2      JSR        2226(A5)                       ; JT[2226]
021E: 4A40          TST.W      D0
0220: 6724          BEQ.S      $0246
0222: 2F2DCF2C      MOVE.L     -12500(A5),-(A7)               ; A5-12500
0226: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
022A: 3D40FFFA      MOVE.W     D0,-6(A6)
022E: 2EADCF28      MOVE.L     -12504(A5),(A7)                ; A5-12504
0232: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
0236: 322EFFFA      MOVE.W     -6(A6),D1
023A: 9240          MOVEA.B    D0,A1
023C: 3881          MOVE.W     D1,(A4)
023E: 39410002      MOVE.W     D1,2(A4)
0242: 588F          MOVE.B     A7,(A4)
0244: 6066          BRA.S      $02AC
0246: 4A2C001C      TST.B      28(A4)
024A: 6660          BNE.S      $02AC
024C: 4A2C0018      TST.B      24(A4)
0250: 665A          BNE.S      $02AC
0252: 4A6C0004      TST.W      4(A4)
0256: 6654          BNE.S      $02AC
0258: 4A2C001A      TST.B      26(A4)
025C: 6624          BNE.S      $0282
025E: 2F2DCF2C      MOVE.L     -12500(A5),-(A7)               ; A5-12500
0262: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
0266: 3D40FFFA      MOVE.W     D0,-6(A6)
026A: 2EADCF28      MOVE.L     -12504(A5),(A7)                ; A5-12504
026E: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
0272: 322EFFFA      MOVE.W     -6(A6),D1
0276: 9240          MOVEA.B    D0,A1
0278: 3881          MOVE.W     D1,(A4)
027A: 39410002      MOVE.W     D1,2(A4)
027E: 588F          MOVE.B     A7,(A4)
0280: 602A          BRA.S      $02AC
0282: 4EAD08EA      JSR        2282(A5)                       ; JT[2282]
0286: 2640          MOVEA.L    D0,A3
0288: 200B          MOVE.L     A3,D0
028A: 6720          BEQ.S      $02AC
028C: 177C007F0019  MOVE.B     #$7F,25(A3)
0292: 2F0B          MOVE.L     A3,-(A7)
0294: 2F0C          MOVE.L     A4,-(A7)
0296: 4EAD08CA      JSR        2250(A5)                       ; JT[2250]
029A: 302C0002      MOVE.W     2(A4),D0
029E: 4440          NEG.W      D0
02A0: 3680          MOVE.W     D0,(A3)
02A2: 3014          MOVE.W     (A4),D0
02A4: 4440          NEG.W      D0
02A6: 37400002      MOVE.W     D0,2(A3)
02AA: 508F          MOVE.B     A7,(A0)
02AC: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
02B0: 4E5E          UNLK       A6
02B2: 4E75          RTS        


; ======= Function at 0x02B4 =======
02B4: 4E56FEAA      LINK       A6,#-342                       ; frame=342
02B8: 48E70738      MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)        ; save
02BC: 266E0008      MOVEA.L    8(A6),A3
02C0: 286E000C      MOVEA.L    12(A6),A4
02C4: 2F0C          MOVE.L     A4,-(A7)
02C6: 2F0B          MOVE.L     A3,-(A7)
02C8: 42A7          CLR.L      -(A7)
02CA: 4EAD08E2      JSR        2274(A5)                       ; JT[2274]
02CE: 4A80          TST.L      D0
02D0: 4FEF000C      LEA        12(A7),A7
02D4: 66000146      BNE.W      $041E
02D8: 486EFEAC      PEA        -340(A6)
02DC: 2F0C          MOVE.L     A4,-(A7)
02DE: 2F0B          MOVE.L     A3,-(A7)
02E0: 4EAD0A8A      JSR        2698(A5)                       ; JT[2698]
02E4: 3C00          MOVE.W     D0,D6
02E6: 4A46          TST.W      D6
02E8: 4FEF000C      LEA        12(A7),A7
02EC: 6656          BNE.S      $0344
02EE: 4EAD08B2      JSR        2226(A5)                       ; JT[2226]
02F2: 4A40          TST.W      D0
02F4: 6740          BEQ.S      $0336
02F6: 48780022      PEA        $0022.W
02FA: 486EFEAC      PEA        -340(A6)
02FE: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0302: 3D7C007FFECA  MOVE.W     #$007F,-310(A6)
0308: 2E8B          MOVE.L     A3,(A7)
030A: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
030E: 3D40FEAA      MOVE.W     D0,-342(A6)
0312: 2E8C          MOVE.L     A4,(A7)
0314: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
0318: 3A2EFEAA      MOVE.W     -342(A6),D5
031C: 9A40          MOVEA.B    D0,A5
031E: 3045          MOVEA.W    D5,A0
0320: 2E88          MOVE.L     A0,(A7)
0322: 3045          MOVEA.W    D5,A0
0324: 2F08          MOVE.L     A0,-(A7)
0326: 486EFEAC      PEA        -340(A6)
032A: 4EAD08A2      JSR        2210(A5)                       ; JT[2210]
032E: 4FEF0010      LEA        16(A7),A7
0332: 600000E8      BRA.W      $041E
0336: 2F0C          MOVE.L     A4,-(A7)
0338: 2F0B          MOVE.L     A3,-(A7)
033A: 4EAD08AA      JSR        2218(A5)                       ; JT[2218]
033E: 508F          MOVE.B     A7,(A0)
0340: 600000DA      BRA.W      $041E
0344: 2F0B          MOVE.L     A3,-(A7)
0346: 4EBA00DE      JSR        222(PC)
034A: 2B4BCF2C      MOVE.L     A3,-12500(A5)
034E: 2B4CCF28      MOVE.L     A4,-12504(A5)
0352: 7A00          MOVEQ      #0,D5
0354: 45EDF9D8      LEA        -1576(A5),A2                   ; A5-1576
0358: 41EDF9B0      LEA        -1616(A5),A0                   ; A5-1616
035C: 2E08          MOVE.L     A0,D7
035E: 588F          MOVE.B     A7,(A4)
0360: 6012          BRA.S      $0374
0362: 203CF4143E00  MOVE.L     #$F4143E00,D0
0368: 2480          MOVE.L     D0,(A2)
036A: 2047          MOVEA.L    D7,A0
036C: 2080          MOVE.L     D0,(A0)
036E: 5245          MOVEA.B    D5,A1
0370: 588A          MOVE.B     A2,(A4)
0372: 5887          MOVE.B     D7,(A4)
0374: 0C45000A      CMPI.W     #$000A,D5
0378: 65E8          BCS.S      $0362
037A: 48780022      PEA        $0022.W
037E: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0382: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0386: 42ADB3E2      CLR.L      -19486(A5)
038A: 7A00          MOVEQ      #0,D5
038C: 45EEFEAC      LEA        -340(A6),A2
0390: 508F          MOVE.B     A7,(A0)
0392: 6014          BRA.S      $03A8
0394: 2F0A          MOVE.L     A2,-(A7)
0396: 4EAD0912      JSR        2322(A5)                       ; JT[2322]
039A: 2E8A          MOVE.L     A2,(A7)
039C: 4EBAFC62      JSR        -926(PC)
03A0: 588F          MOVE.B     A7,(A4)
03A2: 5245          MOVEA.B    D5,A1
03A4: 45EA0022      LEA        34(A2),A2
03A8: BC45          MOVEA.W    D5,A6
03AA: 6EE8          BGT.S      $0394
03AC: 0C46000A      CMPI.W     #$000A,D6
03B0: 660E          BNE.S      $03C0
03B2: 4EAD08BA      JSR        2234(A5)                       ; JT[2234]
03B6: 486D0AEA      PEA        2794(A5)                       ; A5+2794
03BA: 4EAD0A3A      JSR        2618(A5)                       ; JT[2618]
03BE: 588F          MOVE.B     A7,(A4)
03C0: 48780022      PEA        $0022.W
03C4: 486EFEAC      PEA        -340(A6)
03C8: 4EAD01AA      JSR        426(A5)                        ; JT[426]
03CC: 3D7C007FFECA  MOVE.W     #$007F,-310(A6)
03D2: 486EFEAC      PEA        -340(A6)
03D6: 4EBAFC28      JSR        -984(PC)
03DA: 4A6DA5EA      TST.W      -23062(A5)
03DE: 4FEF000C      LEA        12(A7),A7
03E2: 670C          BEQ.S      $03F0
03E4: 2F0C          MOVE.L     A4,-(A7)
03E6: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
03EA: 4EBAFDC2      JSR        -574(PC)
03EE: 508F          MOVE.B     A7,(A0)
03F0: 2F0C          MOVE.L     A4,-(A7)
03F2: 2F0B          MOVE.L     A3,-(A7)
03F4: 4EAD086A      JSR        2154(A5)                       ; JT[2154]
03F8: 2E8C          MOVE.L     A4,(A7)
03FA: 2F0B          MOVE.L     A3,-(A7)
03FC: 4EAD0882      JSR        2178(A5)                       ; JT[2178]
0400: B7EDCF2C4FEF  MOVE.W     -12500(A5),-17(PC,D4.L)        ; A5-12500
0406: 000C6606      ORI.B      #$6606,A4
040A: B9EDCF286704  MOVE.W     -12504(A5),#$6704              ; A5-12504
0410: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0414: 486D0AE2      PEA        2786(A5)                       ; A5+2786
0418: 4EAD08C2      JSR        2242(A5)                       ; JT[2242]
041C: 4CEE1CE0FE92  MOVEM.L    -366(A6),D5/D6/D7/A2/A3/A4
0422: 4E5E          UNLK       A6
0424: 4E75          RTS        


; ======= Function at 0x0426 =======
0426: 4E560000      LINK       A6,#0
042A: 2F2E0008      MOVE.L     8(A6),-(A7)
042E: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
0432: 426DCF04      CLR.W      -12540(A5)
0436: 4EAD0982      JSR        2434(A5)                       ; JT[2434]
043A: 48780154      PEA        $0154.W
043E: 486DA5F0      PEA        -23056(A5)                     ; g_dawg_?
0442: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0446: 48780200      PEA        $0200.W
044A: 486DA756      PEA        -22698(A5)                     ; A5-22698
044E: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0452: 48780200      PEA        $0200.W
0456: 486DCF30      PEA        -12496(A5)                     ; A5-12496
045A: 4EAD01AA      JSR        426(A5)                        ; JT[426]
045E: 4E5E          UNLK       A6
0460: 4E75          RTS        
