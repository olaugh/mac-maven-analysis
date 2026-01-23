;======================================================================
; CODE 3 Disassembly
; File: /tmp/maven_code_3.bin
; Header: JT offset=112, JT entries=6
; Code size: 4390 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56F716      LINK       A6,#-2282                      ; frame=2282
0004: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0008: 7018          MOVEQ      #24,D0
000A: D0AE0008      MOVE.B     8(A6),(A0)
000E: 2840          MOVEA.L    D0,A4
0010: 2C2C002A      MOVE.L     42(A4),D6
0014: 206E0008      MOVEA.L    8(A6),A0
0018: 0C680040000C  CMPI.W     #$0040,12(A0)
001E: 6F04          BLE.S      $0024
0020: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0024: 2F06          MOVE.L     D6,-(A7)
0026: 486D902C      PEA        -28628(A5)                     ; g_buffer
002A: 486EFFC1      PEA        -63(A6)
002E: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0032: 1D40FFC0      MOVE.B     D0,-64(A6)
0036: 486EFFC0      PEA        -64(A6)
003A: 4EAD02A2      JSR        674(A5)                        ; JT[674]
003E: 4A86          TST.L      D6
0040: 4FEF0010      LEA        16(A7),A7
0044: 6602          BNE.S      $0048
0046: 7C01          MOVEQ      #1,D6
0048: 7A00          MOVEQ      #0,D5
004A: 206E0008      MOVEA.L    8(A6),A0
004E: 3828000C      MOVE.W     12(A0),D4
0052: 48780002      PEA        $0002.W
0056: 2F06          MOVE.L     D6,-(A7)
0058: 4EAD005A      JSR        90(A5)                         ; JT[90]
005C: 2D40F71A      MOVE.L     D0,-2278(A6)
0060: 7222          MOVEQ      #34,D1
0062: C3C5          ANDA.L     D5,A1
0064: 47EEF740      LEA        -2240(A6),A3
0068: D28B          MOVE.B     A3,(A1)
006A: 2641          MOVEA.L    D1,A3
006C: 600000B8      BRA.W      $0128
0070: 702E          MOVEQ      #46,D0
0072: C1C4          ANDA.L     D4,A0
0074: 2440          MOVEA.L    D0,A2
0076: 204C          MOVEA.L    A4,A0
0078: D1CA43D3      MOVE.B     A2,$43D3.W
007C: 7007          MOVEQ      #7,D0
007E: 22D8          MOVE.L     (A0)+,(A1)+
0080: 51C8FFFC      DBF        D0,$007E                       ; loop
0084: 32D8          MOVE.W     (A0)+,(A1)+
0086: 2F06          MOVE.L     D6,-(A7)
0088: 204C          MOVEA.L    A4,A0
008A: D1CA2028      MOVE.B     A2,$2028.W
008E: 0022D0AE      ORI.B      #$D0AE,-(A2)
0092: F71A          MOVE.W     (A2)+,-(A3)
0094: 2F00          MOVE.L     D0,-(A7)
0096: 4EAD005A      JSR        90(A5)                         ; JT[90]
009A: 2E00          MOVE.L     D0,D7
009C: 2007          MOVE.L     D7,D0
009E: 90AB0014      MOVE.B     20(A3),(A0)
00A2: 90AB0010      MOVE.B     16(A3),(A0)
00A6: 27400018      MOVE.L     D0,24(A3)
00AA: 7600          MOVEQ      #0,D3
00AC: 45EEF740      LEA        -2240(A6),A2
00B0: 600E          BRA.S      $00C0
00B2: BA43          MOVEA.W    D3,A5
00B4: 6E04          BGT.S      $00BA
00B6: 4EAD01A2      JSR        418(A5)                        ; JT[418]
00BA: 5243          MOVEA.B    D3,A1
00BC: 45EA0022      LEA        34(A2),A2
00C0: 202A0010      MOVE.L     16(A2),D0
00C4: D0AA0014      MOVE.B     20(A2),(A0)
00C8: D0AA0018      MOVE.B     24(A2),(A0)
00CC: B087          MOVE.W     D7,(A0)
00CE: 6EE2          BGT.S      $00B2
00D0: 41EEF71E      LEA        -2274(A6),A0
00D4: 43D3          LEA        (A3),A1
00D6: 7007          MOVEQ      #7,D0
00D8: 20D9          MOVE.L     (A1)+,(A0)+
00DA: 51C8FFFC      DBF        D0,$00D8                       ; loop
00DE: 30D9          MOVE.W     (A1)+,(A0)+
00E0: 7022          MOVEQ      #34,D0
00E2: C1C3          ANDA.L     D3,A0
00E4: 45EEF740      LEA        -2240(A6),A2
00E8: D08A          MOVE.B     A2,(A0)
00EA: 2440          MOVEA.L    D0,A2
00EC: 3005          MOVE.W     D5,D0
00EE: 9043          MOVEA.B    D3,A0
00F0: C1FC00222F00  ANDA.L     #$00222F00,A0
00F6: 2F0A          MOVE.L     A2,-(A7)
00F8: 7001          MOVEQ      #1,D0
00FA: D043          MOVEA.B    D3,A0
00FC: C1FC0022204E  ANDA.L     #$0022204E,A0
0102: D1C04868      MOVE.B     D0,$4868.W
0106: F7404EAD      MOVE.W     D0,20141(A3)
010A: 0D8A          BCLR       D6,A2
010C: 41D2          LEA        (A2),A0
010E: 43EEF71E      LEA        -2274(A6),A1
0112: 7007          MOVEQ      #7,D0
0114: 20D9          MOVE.L     (A1)+,(A0)+
0116: 51C8FFFC      DBF        D0,$0114                       ; loop
011A: 30D9          MOVE.W     (A1)+,(A0)+
011C: 4FEF000C      LEA        12(A7),A7
0120: 5245          MOVEA.B    D5,A1
0122: 47EB0022      LEA        34(A3),A3
0126: 53444A44      MOVE.B     D4,19012(A1)
012A: 6C00FF44      BGE.W      $0072
012E: 206E0008      MOVEA.L    8(A6),A0
0132: 3F28000C      MOVE.W     12(A0),-(A7)
0136: 486EF740      PEA        -2240(A6)
013A: 486D903E      PEA        -28610(A5)                     ; A5-28610
013E: 4EAD029A      JSR        666(A5)                        ; JT[666]
0142: 4EAD0672      JSR        1650(A5)                       ; JT[1650]
0146: 4CEE1CF8F6F6  MOVEM.L    -2314(A6),D3/D4/D5/D6/D7/A2/A3/A4
014C: 4E5E          UNLK       A6
014E: 4E75          RTS        

0150: 3F3C0121      MOVE.W     #$0121,-(A7)
0154: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
0158: 4EAD0D7A      JSR        3450(A5)                       ; JT[3450]
015C: 4A40          TST.W      D0
015E: 5C8F          MOVE.B     A7,(A6)
0160: 670A          BEQ.S      $016C
0162: 4A6DDE28      TST.W      -8664(A5)
0166: 6604          BNE.S      $016C
0168: 7001          MOVEQ      #1,D0
016A: 6030          BRA.S      $019C
016C: 4A6DD9AE      TST.W      -9810(A5)
0170: 6704          BEQ.S      $0176
0172: 7000          MOVEQ      #0,D0
0174: 6026          BRA.S      $019C
0176: 4EAD02AA      JSR        682(A5)                        ; JT[682]
017A: 4A40          TST.W      D0
017C: 6604          BNE.S      $0182
017E: 7000          MOVEQ      #0,D0
0180: 601A          BRA.S      $019C
0182: 4EAD093A      JSR        2362(A5)                       ; JT[2362]
0186: 4A40          TST.W      D0
0188: 6704          BEQ.S      $018E
018A: 7000          MOVEQ      #0,D0
018C: 600E          BRA.S      $019C
018E: 4EAD0502      JSR        1282(A5)                       ; JT[1282]
0192: 4A40          TST.W      D0
0194: 6704          BEQ.S      $019A
0196: 7000          MOVEQ      #0,D0
0198: 6002          BRA.S      $019C
019A: 7001          MOVEQ      #1,D0
019C: 4E75          RTS        


; ======= Function at 0x019E =======
019E: 4E560000      LINK       A6,#0
01A2: 2F0C          MOVE.L     A4,-(A7)
01A4: 286E0008      MOVEA.L    8(A6),A4
01A8: 202C0010      MOVE.L     16(A4),D0
01AC: D0AC0014      MOVE.B     20(A4),(A0)
01B0: 222DA5DE      MOVE.L     -23074(A5),D1                  ; g_dawg_ptr
01B4: D2ADA5E2      MOVE.B     -23070(A5),(A1)                ; g_sect1_off
01B8: D2ADA5E6      MOVE.B     -23066(A5),(A1)                ; g_sect2_off
01BC: D0AC0018      MOVE.B     24(A4),(A0)
01C0: B280          MOVE.W     D0,(A1)
01C2: 6C10          BGE.S      $01D4
01C4: 41EDA5CE      LEA        -23090(A5),A0                  ; g_dawg_info
01C8: 43D4          LEA        (A4),A1
01CA: 7007          MOVEQ      #7,D0
01CC: 20D9          MOVE.L     (A1)+,(A0)+
01CE: 51C8FFFC      DBF        D0,$01CC                       ; loop
01D2: 30D9          MOVE.W     (A1)+,(A0)+
01D4: 285F          MOVEA.L    (A7)+,A4
01D6: 4E5E          UNLK       A6
01D8: 4E75          RTS        


; ======= Function at 0x01DA =======
01DA: 4E56FF80      LINK       A6,#-128                       ; frame=128
01DE: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
01E2: 286E0008      MOVEA.L    8(A6),A4
01E6: 2F0C          MOVE.L     A4,-(A7)
01E8: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
01EC: 486EFF80      PEA        -128(A6)
01F0: 4EAD095A      JSR        2394(A5)                       ; JT[2394]
01F4: 1E00          MOVE.B     D0,D7
01F6: 0C070008      CMPI.B     #$0008,D7
01FA: 508F          MOVE.B     A7,(A0)
01FC: 6C1E          BGE.S      $021C
01FE: 206DD13C      MOVEA.L    -11972(A5),A0
0202: 4A680014      TST.W      20(A0)
0206: 6714          BEQ.S      $021C
0208: 206DD13C      MOVEA.L    -11972(A5),A0
020C: 3068000E      MOVEA.W    14(A0),A0
0210: 2F08          MOVE.L     A0,-(A7)
0212: 2F0C          MOVE.L     A4,-(A7)
0214: 4EAD089A      JSR        2202(A5)                       ; JT[2202]
0218: 508F          MOVE.B     A7,(A0)
021A: 602E          BRA.S      $024A
021C: 0C070007      CMPI.B     #$0007,D7
0220: 6F1C          BLE.S      $023E
0222: 0C070011      CMPI.B     #$0011,D7
0226: 6416          BCC.S      $023E
0228: 206DD13C      MOVEA.L    -11972(A5),A0
022C: 4A680012      TST.W      18(A0)
0230: 670C          BEQ.S      $023E
0232: 4267          CLR.W      -(A7)
0234: 2F0C          MOVE.L     A4,-(A7)
0236: 4EAD0A1A      JSR        2586(A5)                       ; JT[2586]
023A: 5C8F          MOVE.B     A7,(A6)
023C: 600C          BRA.S      $024A
023E: 486D0842      PEA        2114(A5)                       ; A5+2114
0242: 2F0C          MOVE.L     A4,-(A7)
0244: 4EAD0852      JSR        2130(A5)                       ; JT[2130]
0248: 508F          MOVE.B     A7,(A0)
024A: 41EDA5CE      LEA        -23090(A5),A0                  ; g_dawg_info
024E: 43EDA5F0      LEA        -23056(A5),A1                  ; g_dawg_?
0252: 7007          MOVEQ      #7,D0
0254: 20D9          MOVE.L     (A1)+,(A0)+
0256: 51C8FFFC      DBF        D0,$0254                       ; loop
025A: 30D9          MOVE.W     (A1)+,(A0)+
025C: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
0260: 4E5E          UNLK       A6
0262: 4E75          RTS        


; ======= Function at 0x0264 =======
0264: 4E56F468      LINK       A6,#-2968                      ; frame=2968
0268: 48780B98      PEA        $0B98.W
026C: 486EF468      PEA        -2968(A6)
0270: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0274: 486EF468      PEA        -2968(A6)
0278: 4EBA0CEE      JSR        3310(PC)
027C: 4A6EF470      TST.W      -2960(A6)
0280: 4FEF000C      LEA        12(A7),A7
0284: 6E06          BGT.S      $028C
0286: 3D7C0001F470  MOVE.W     #$0001,-2960(A6)
028C: E3EEF4703F3C0121  MOVE.L     -2960(A6),$3F3C0121
0294: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
0298: 4EAD0D7A      JSR        3450(A5)                       ; JT[3450]
029C: 4A40          TST.W      D0
029E: 5C8F          MOVE.B     A7,(A6)
02A0: 6712          BEQ.S      $02B4
02A2: 4A6DDE28      TST.W      -8664(A5)
02A6: 660C          BNE.S      $02B4
02A8: 486EF468      PEA        -2968(A6)
02AC: 4EBA03F0      JSR        1008(PC)
02B0: 588F          MOVE.B     A7,(A4)
02B2: 600A          BRA.S      $02BE
02B4: 486EF468      PEA        -2968(A6)
02B8: 4EBA099A      JSR        2458(PC)
02BC: 588F          MOVE.B     A7,(A4)
02BE: 4E5E          UNLK       A6
02C0: 4E75          RTS        


; ======= Function at 0x02C2 =======
02C2: 4E56F8F0      LINK       A6,#-1808                      ; frame=1808
02C6: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
02CA: 282E000C      MOVE.L     12(A6),D4
02CE: 206DD13C      MOVEA.L    -11972(A5),A0
02D2: 4AA80004      TST.L      4(A0)
02D6: 6710          BEQ.S      $02E8
02D8: 2F2DD13C      MOVE.L     -11972(A5),-(A7)               ; g_dawg_ptr2
02DC: 206DD13C      MOVEA.L    -11972(A5),A0
02E0: 20680004      MOVEA.L    4(A0),A0
02E4: 4E90          JSR        (A0)
02E6: 588F          MOVE.B     A7,(A4)
02E8: 48780220      PEA        $0220.W
02EC: 486DBCFE      PEA        -17154(A5)                     ; g_state1
02F0: 486EFD58      PEA        -680(A6)
02F4: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
02F8: 48780440      PEA        $0440.W
02FC: 486DBF1E      PEA        -16610(A5)                     ; g_state2
0300: 486EF918      PEA        -1768(A6)
0304: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0308: 486DC366      PEA        -15514(A5)                     ; g_field_14
030C: 486EF910      PEA        -1776(A6)
0310: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0314: 486DC35E      PEA        -15522(A5)                     ; g_field_22
0318: 486EF908      PEA        -1784(A6)
031C: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0320: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
0324: 2D48F8F0      MOVE.L     A0,-1808(A6)
0328: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
032C: 2D48F8FC      MOVE.L     A0,-1796(A6)
0330: 7C00          MOVEQ      #0,D6
0332: 2A04          MOVE.L     D4,D5
0334: DA85          MOVE.B     D5,(A5)
0336: 702E          MOVEQ      #46,D0
0338: C1C6          ANDA.L     D6,A0
033A: 2840          MOVEA.L    D0,A4
033C: 4FEF0028      LEA        40(A7),A7
0340: 600002FC      BRA.W      $0640
0344: 42AEF900      CLR.L      -1792(A6)
0348: 42AEF8F4      CLR.L      -1804(A6)
034C: 42AEF904      CLR.L      -1788(A6)
0350: 47EC0018      LEA        24(A4),A3
0354: D7EDD13C244B  MOVE.B     -11972(A5),75(PC,D2.W)         ; g_dawg_ptr2
035A: D9AB002A206D  MOVE.B     42(A3),109(A4,D2.W)
0360: D13C4A68      MOVE.B     #$68,-(A0)
0364: 00166734      ORI.B      #$6734,(A6)
0368: 48780121      PEA        $0121.W
036C: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
0370: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0374: 48780121      PEA        $0121.W
0378: 486DD88D      PEA        -10099(A5)                     ; A5-10099
037C: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0380: 486D0402      PEA        1026(A5)                       ; A5+1026
0384: 4EAD042A      JSR        1066(A5)                       ; JT[1066]
0388: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
038C: 4EAD051A      JSR        1306(A5)                       ; JT[1306]
0390: 7078          MOVEQ      #120,D0
0392: 2E80          MOVE.L     D0,(A7)
0394: 4EAD06D2      JSR        1746(A5)                       ; JT[1746]
0398: 4FEF0014      LEA        20(A7),A7
039C: 2F2EF8F0      MOVE.L     -1808(A6),-(A7)
03A0: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
03A4: 4257          CLR.W      (A7)
03A6: 2F2EF8F0      MOVE.L     -1808(A6),-(A7)
03AA: 2F0A          MOVE.L     A2,-(A7)
03AC: 4EAD0942      JSR        2370(A5)                       ; JT[2370]
03B0: 206DD13C      MOVEA.L    -11972(A5),A0
03B4: 4A680016      TST.W      22(A0)
03B8: 4FEF000C      LEA        12(A7),A7
03BC: 6712          BEQ.S      $03D0
03BE: 2F3C00010000  MOVE.L     #$00010000,-(A7)
03C4: 2F0A          MOVE.L     A2,-(A7)
03C6: 4EAD016A      JSR        362(A5)                        ; JT[362]
03CA: 4EAD04D2      JSR        1234(A5)                       ; JT[1234]
03CE: 508F          MOVE.B     A7,(A0)
03D0: 202A0010      MOVE.L     16(A2),D0
03D4: D1AEF8F42D6A  MOVE.B     -1804(A6),106(A0,D2.L*4)
03DA: 0014F8F8      ORI.B      #$F8F8,(A4)
03DE: 2F2E0008      MOVE.L     8(A6),-(A7)
03E2: 2F2EF8FC      MOVE.L     -1796(A6),-(A7)
03E6: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
03EA: 206DD13C      MOVEA.L    -11972(A5),A0
03EE: 4A68000A      TST.W      10(A0)
03F2: 508F          MOVE.B     A7,(A0)
03F4: 6740          BEQ.S      $0436
03F6: 2F2EF8FC      MOVE.L     -1796(A6),-(A7)
03FA: 4EAD0542      JSR        1346(A5)                       ; JT[1346]
03FE: 2EAEF8FC      MOVE.L     -1796(A6),(A7)
0402: 2F2D9028      MOVE.L     -28632(A5),-(A7)               ; A5-28632
0406: 486EFF78      PEA        -136(A6)
040A: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
040E: 48C0          EXT.L      D0
0410: 2600          MOVE.L     D0,D3
0412: 486EFF78      PEA        -136(A6)
0416: 2F03          MOVE.L     D3,-(A7)
0418: 206DD13C      MOVEA.L    -11972(A5),A0
041C: 3F28000A      MOVE.W     10(A0),-(A7)
0420: 4EAD06DA      JSR        1754(A5)                       ; JT[1754]
0424: 206DD13C      MOVEA.L    -11972(A5),A0
0428: 3EA8000A      MOVE.W     10(A0),(A7)
042C: 2F0A          MOVE.L     A2,-(A7)
042E: 4EBA0C6C      JSR        3180(PC)
0432: 4FEF001A      LEA        26(A7),A7
0436: 2F2EF8F0      MOVE.L     -1808(A6),-(A7)
043A: 4EAD0962      JSR        2402(A5)                       ; JT[2402]
043E: 47EEF8FC      LEA        -1796(A6),A3
0442: 45EEF8F0      LEA        -1808(A6),A2
0446: 7600          MOVEQ      #0,D3
0448: 588F          MOVE.B     A7,(A4)
044A: 600000B6      BRA.W      $0504
044E: 206DD13C      MOVEA.L    -11972(A5),A0
0452: 4A680016      TST.W      22(A0)
0456: 673A          BEQ.S      $0492
0458: 486DC366      PEA        -15514(A5)                     ; g_field_14
045C: 486EFFF8      PEA        -8(A6)
0460: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0464: 2E93          MOVE.L     (A3),(A7)
0466: 486DC366      PEA        -15514(A5)                     ; g_field_14
046A: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
046E: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
0472: 486EFFF8      PEA        -8(A6)
0476: 486DC366      PEA        -15514(A5)                     ; g_field_14
047A: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
047E: 4EAD04E2      JSR        1250(A5)                       ; JT[1250]
0482: 4EAD04D2      JSR        1234(A5)                       ; JT[1234]
0486: 7078          MOVEQ      #120,D0
0488: 2E80          MOVE.L     D0,(A7)
048A: 4EAD06D2      JSR        1746(A5)                       ; JT[1746]
048E: 4FEF0014      LEA        20(A7),A7
0492: 2B53C376      MOVE.L     (A3),-15498(A5)
0496: 2F13          MOVE.L     (A3),-(A7)
0498: 4EBAFD40      JSR        -704(PC)
049C: 4257          CLR.W      (A7)
049E: 2F13          MOVE.L     (A3),-(A7)
04A0: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
04A4: 4EAD0942      JSR        2370(A5)                       ; JT[2370]
04A8: 2E93          MOVE.L     (A3),(A7)
04AA: 4EAD0962      JSR        2402(A5)                       ; JT[2402]
04AE: 206DD13C      MOVEA.L    -11972(A5),A0
04B2: 4A68000A      TST.W      10(A0)
04B6: 4FEF000C      LEA        12(A7),A7
04BA: 6712          BEQ.S      $04CE
04BC: 206DD13C      MOVEA.L    -11972(A5),A0
04C0: 3F28000A      MOVE.W     10(A0),-(A7)
04C4: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
04C8: 4EBA0BD2      JSR        3026(PC)
04CC: 5C8F          MOVE.B     A7,(A6)
04CE: 206DD13C      MOVEA.L    -11972(A5),A0
04D2: 4A680016      TST.W      22(A0)
04D6: 6710          BEQ.S      $04E8
04D8: 2F3C00010000  MOVE.L     #$00010000,-(A7)
04DE: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
04E2: 4EAD016A      JSR        362(A5)                        ; JT[362]
04E6: 508F          MOVE.B     A7,(A0)
04E8: 202DA5DE      MOVE.L     -23074(A5),D0                  ; g_dawg_ptr
04EC: D1AB0004276D  MOVE.B     4(A3),109(A0,D2.W*8)
04F2: A5E20008      MOVE.L     -(A2),8(PC)
04F6: 2E0B          MOVE.L     A3,D7
04F8: 264A          MOVEA.L    A2,A3
04FA: 2447          MOVEA.L    D7,A2
04FC: 4EAD06CA      JSR        1738(A5)                       ; JT[1738]
0500: 5243          MOVEA.B    D3,A1
0502: 206DD13C      MOVEA.L    -11972(A5),A0
0506: B6680008      MOVEA.W    8(A0),A3
050A: 6C0A          BGE.S      $0516
050C: 4EAD092A      JSR        2346(A5)                       ; JT[2346]
0510: 4A40          TST.W      D0
0512: 6700FF3A      BEQ.W      $0450
0516: 4EAD092A      JSR        2346(A5)                       ; JT[2346]
051A: 4A40          TST.W      D0
051C: 6612          BNE.S      $0530
051E: 202EF8F8      MOVE.L     -1800(A6),D0
0522: D1AEF8F4202E  MOVE.B     -1804(A6),46(A0,D2.W)
0528: F904          MOVE.W     D4,-(A4)
052A: D1AEF9006056  MOVE.B     -1792(A6),86(A0,D6.W)
0530: 206EF8FC      MOVEA.L    -1796(A6),A0
0534: 4A10          TST.B      (A0)
0536: 6614          BNE.S      $054C
0538: 2F2EF8F0      MOVE.L     -1808(A6),-(A7)
053C: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
0540: D040          MOVEA.B    D0,A0
0542: 48C0          EXT.L      D0
0544: D1AEF900588F  MOVE.B     -1792(A6),-113(A0,D5.L)
054A: 603A          BRA.S      $0586
054C: 206EF8F0      MOVEA.L    -1808(A6),A0
0550: 4A10          TST.B      (A0)
0552: 6614          BNE.S      $0568
0554: 2F2EF8FC      MOVE.L     -1796(A6),-(A7)
0558: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
055C: D040          MOVEA.B    D0,A0
055E: 48C0          EXT.L      D0
0560: D1AEF8F4588F  MOVE.B     -1804(A6),-113(A0,D5.L)
0566: 601E          BRA.S      $0586
0568: 2F2EF8F0      MOVE.L     -1808(A6),-(A7)
056C: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
0570: 48C0          EXT.L      D0
0572: D1AEF9002EAE  MOVE.B     -1792(A6),-82(A0,D2.L*8)
0578: F8FC4EAD      MOVE.W     #$4EAD,(A4)+
057C: 084A48C0      BCHG       #18624,A2
0580: D1AEF8F4588F  MOVE.B     -1804(A6),-113(A0,D5.L)
0586: 2F04          MOVE.L     D4,-(A7)
0588: 202EF8F4      MOVE.L     -1804(A6),D0
058C: 90AEF900      MOVE.B     -1792(A6),(A0)
0590: 2F00          MOVE.L     D0,-(A7)
0592: 4EAD0042      JSR        66(A5)                         ; JT[66]
0596: 222DD13C      MOVE.L     -11972(A5),D1                  ; g_dawg_ptr2
059A: D1B4183A206D  MOVE.B     58(A4,D1.L),109(A0,D2.W)
05A0: D13C4A68      MOVE.B     #$68,-(A0)
05A4: 000A673A      ORI.B      #$673A,A2
05A8: 48780064      PEA        $0064.W
05AC: 202EF8F4      MOVE.L     -1804(A6),D0
05B0: 90AEF900      MOVE.B     -1792(A6),(A0)
05B4: 2F00          MOVE.L     D0,-(A7)
05B6: 4EAD005A      JSR        90(A5)                         ; JT[90]
05BA: 2F00          MOVE.L     D0,-(A7)
05BC: 486D9058      PEA        -28584(A5)                     ; A5-28584
05C0: 486EFF78      PEA        -136(A6)
05C4: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
05C8: 48C0          EXT.L      D0
05CA: 2600          MOVE.L     D0,D3
05CC: 486EFF78      PEA        -136(A6)
05D0: 2F03          MOVE.L     D3,-(A7)
05D2: 206DD13C      MOVEA.L    -11972(A5),A0
05D6: 3F28000A      MOVE.W     10(A0),-(A7)
05DA: 4EAD06DA      JSR        1754(A5)                       ; JT[1754]
05DE: 4FEF0016      LEA        22(A7),A7
05E2: 202EF8F4      MOVE.L     -1804(A6),D0
05E6: B0AEF900      MOVE.W     -1792(A6),(A0)
05EA: 6F0A          BLE.S      $05F6
05EC: 202DD13C      MOVE.L     -11972(A5),D0                  ; g_dawg_ptr2
05F0: DBB4083E6012  MOVE.B     62(A4,D0.L),18(A5,D6.W)
05F6: 202EF8F4      MOVE.L     -1804(A6),D0
05FA: B0AEF900      MOVE.W     -1792(A6),(A0)
05FE: 6608          BNE.S      $0608
0600: 202DD13C      MOVE.L     -11972(A5),D0                  ; g_dawg_ptr2
0604: D9B4083E4878  MOVE.B     62(A4,D0.L),120(A4,D4.L)
060A: 0220486E      ANDI.B     #$486E,-(A0)
060E: FD58486D      MOVE.W     (A0)+,18541(A6)
0612: BCFE          MOVE.W     ???,(A6)+
0614: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0618: 48780440      PEA        $0440.W
061C: 486EF918      PEA        -1768(A6)
0620: 486DBF1E      PEA        -16610(A5)                     ; g_state2
0624: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0628: 486EF910      PEA        -1776(A6)
062C: 486DC366      PEA        -15514(A5)                     ; g_field_14
0630: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0634: 4FEF0020      LEA        32(A7),A7
0638: 5246          MOVEA.B    D6,A1
063A: 49EC002E      LEA        46(A4),A4
063E: 206DD13C      MOVEA.L    -11972(A5),A0
0642: BC68000C      MOVEA.W    12(A0),A6
0646: 6D00FCFC      BLT.W      $0346
064A: 486EF908      PEA        -1784(A6)
064E: 486DC35E      PEA        -15522(A5)                     ; g_field_22
0652: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0656: 206DD13C      MOVEA.L    -11972(A5),A0
065A: 4A680010      TST.W      16(A0)
065E: 508F          MOVE.B     A7,(A0)
0660: 6632          BNE.S      $0694
0662: 206DD13C      MOVEA.L    -11972(A5),A0
0666: 20280042      MOVE.L     66(A0),D0
066A: B090          MOVE.W     (A0),(A0)
066C: 6D26          BLT.S      $0694
066E: 2B6D93ACA222  MOVE.L     -27732(A5),-24030(A5)          ; A5-27732
0674: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
067A: C1EDA386      ANDA.L     -23674(A5),A0
067E: 41EDA226      LEA        -24026(A5),A0                  ; g_common
0682: D088          MOVE.B     A0,(A0)
0684: 2040          MOVEA.L    D0,A0
0686: 7001          MOVEQ      #1,D0
0688: 4A40          TST.W      D0
068A: 6602          BNE.S      $068E
068C: 7001          MOVEQ      #1,D0
068E: 4CD8          DC.W       $4CD8
0690: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
0694: 7000          MOVEQ      #0,D0
0696: 4CDF1CF8      MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4  ; restore
069A: 4E5E          UNLK       A6
069C: 4E75          RTS        


; ======= Function at 0x069E =======
069E: 4E56E690      LINK       A6,#-6512                      ; frame=6512
06A2: 2B6E0008D13C  MOVE.L     8(A6),-11972(A5)
06A8: 206DD13C      MOVEA.L    -11972(A5),A0
06AC: 4A68000A      TST.W      10(A0)
06B0: 671A          BEQ.S      $06CC
06B2: 4EBA0A3C      JSR        2620(PC)
06B6: 206DD13C      MOVEA.L    -11972(A5),A0
06BA: 3140000A      MOVE.W     D0,10(A0)
06BE: 206DD13C      MOVEA.L    -11972(A5),A0
06C2: 3F28000A      MOVE.W     10(A0),-(A7)
06C6: 4EAD059A      JSR        1434(A5)                       ; JT[1434]
06CA: 548F          MOVE.B     A7,(A2)
06CC: 42ADB3E2      CLR.L      -19486(A5)
06D0: 3F3C0121      MOVE.W     #$0121,-(A7)
06D4: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
06D8: 4EAD0D7A      JSR        3450(A5)                       ; JT[3450]
06DC: 4A40          TST.W      D0
06DE: 5C8F          MOVE.B     A7,(A6)
06E0: 6604          BNE.S      $06E6
06E2: 4EAD01A2      JSR        418(A5)                        ; JT[418]
06E6: 0C6D0008A386  CMPI.W     #$0008,-23674(A5)
06EC: 6406          BCC.S      $06F4
06EE: 4A6DA386      TST.W      -23674(A5)
06F2: 6C04          BGE.S      $06F8
06F4: 4EAD01A2      JSR        418(A5)                        ; JT[418]
06F8: 302DA386      MOVE.W     -23674(A5),D0                  ; A5-23674
06FC: 526DA386      MOVEA.B    -23674(A5),A1
0700: C1FC002C41ED  ANDA.L     #$002C41ED,A0
0706: A226          MOVE.L     -(A6),D1
0708: D088          MOVE.B     A0,(A0)
070A: 2040          MOVEA.L    D0,A0
070C: 7000          MOVEQ      #0,D0
070E: 43FA0006      LEA        6(PC),A1
0712: 48D0          DC.W       $48D0
0714: DEF84A40      MOVE.B     $4A40.W,(A7)+
0718: 6600048C      BNE.W      $0BA8
071C: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
0720: 2D48E7B0      MOVE.L     A0,-6224(A6)
0724: 42AEE728      CLR.L      -6360(A6)
0728: 42AEE724      CLR.L      -6364(A6)
072C: 42AEE720      CLR.L      -6368(A6)
0730: 42AEE710      CLR.L      -6384(A6)
0734: 42AEE714      CLR.L      -6380(A6)
0738: 42AEE718      CLR.L      -6376(A6)
073C: 42AEE71C      CLR.L      -6372(A6)
0740: 206DD13C      MOVEA.L    -11972(A5),A0
0744: 4A680016      TST.W      22(A0)
0748: 6720          BEQ.S      $076A
074A: 48780121      PEA        $0121.W
074E: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
0752: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0756: 48780121      PEA        $0121.W
075A: 486DD88D      PEA        -10099(A5)                     ; A5-10099
075E: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0762: 4EAD051A      JSR        1306(A5)                       ; JT[1306]
0766: 4FEF0010      LEA        16(A7),A7
076A: 48780220      PEA        $0220.W
076E: 486DBCFE      PEA        -17154(A5)                     ; g_state1
0772: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0776: 48780440      PEA        $0440.W
077A: 486DBF1E      PEA        -16610(A5)                     ; g_state2
077E: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0782: 7008          MOVEQ      #8,D0
0784: 2E80          MOVE.L     D0,(A7)
0786: 486DC366      PEA        -15514(A5)                     ; g_field_14
078A: 4EAD01AA      JSR        426(A5)                        ; JT[426]
078E: 7008          MOVEQ      #8,D0
0790: 2E80          MOVE.L     D0,(A7)
0792: 486DC35E      PEA        -15522(A5)                     ; g_field_22
0796: 4EAD01AA      JSR        426(A5)                        ; JT[426]
079A: 42ADC372      CLR.L      -15502(A5)
079E: 42ADC36E      CLR.L      -15506(A5)
07A2: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
07A6: B1EEE7B04FEF  MOVE.W     -6224(A6),$4FEF.W
07AC: 00186608      ORI.B      #$6608,(A0)+
07B0: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
07B4: 2008          MOVE.L     A0,D0
07B6: 6006          BRA.S      $07BE
07B8: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
07BC: 2008          MOVE.L     A0,D0
07BE: 2B40C376      MOVE.L     D0,-15498(A5)
07C2: 2D40E7B0      MOVE.L     D0,-6224(A6)
07C6: 486DC366      PEA        -15514(A5)                     ; g_field_14
07CA: 4EAD0962      JSR        2402(A5)                       ; JT[2402]
07CE: 486DC35E      PEA        -15522(A5)                     ; g_field_22
07D2: 4EAD0962      JSR        2402(A5)                       ; JT[2402]
07D6: 41EEE7EE      LEA        -6162(A6),A0
07DA: 2D48E7D6      MOVE.L     A0,-6186(A6)
07DE: 43EEEBEE      LEA        -5138(A6),A1
07E2: 2D49E7D2      MOVE.L     A1,-6190(A6)
07E6: 41EEEFEE      LEA        -4114(A6),A0
07EA: 2D48E7CE      MOVE.L     A0,-6194(A6)
07EE: 41EEF3EE      LEA        -3090(A6),A0
07F2: 2D48E7E2      MOVE.L     A0,-6174(A6)
07F6: 41EEF7EE      LEA        -2066(A6),A0
07FA: 2D48E7DE      MOVE.L     A0,-6178(A6)
07FE: 41EEFBEE      LEA        -1042(A6),A0
0802: 2D48E7DA      MOVE.L     A0,-6182(A6)
0806: 426EE7C8      CLR.W      -6200(A6)
080A: 508F          MOVE.B     A7,(A0)
080C: 206DD13C      MOVEA.L    -11972(A5),A0
0810: 4A680016      TST.W      22(A0)
0814: 6730          BEQ.S      $0846
0816: 486DC366      PEA        -15514(A5)                     ; g_field_14
081A: 486EFFF0      PEA        -16(A6)
081E: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0822: 2EADC376      MOVE.L     -15498(A5),(A7)                ; A5-15498
0826: 486DC366      PEA        -15514(A5)                     ; g_field_14
082A: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
082E: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
0832: 4EAD03C2      JSR        962(A5)                        ; JT[962]
0836: 486EFFF0      PEA        -16(A6)
083A: 486DC366      PEA        -15514(A5)                     ; g_field_14
083E: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0842: 4FEF0014      LEA        20(A7),A7
0846: 4EAD0672      JSR        1650(A5)                       ; JT[1650]
084A: 4EAD06CA      JSR        1738(A5)                       ; JT[1738]
084E: 2F2DC376      MOVE.L     -15498(A5),-(A7)               ; A5-15498
0852: 4EBAF986      JSR        -1658(PC)
0856: 4EAD093A      JSR        2362(A5)                       ; JT[2362]
085A: 4A40          TST.W      D0
085C: 588F          MOVE.B     A7,(A4)
085E: 66000178      BNE.W      $09DA
0862: 486DC35E      PEA        -15522(A5)                     ; g_field_22
0866: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
086A: 5F80588F      MOVE.B     D0,-113(A7,D5.L)
086E: 6704          BEQ.S      $0874
0870: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0874: 486DC366      PEA        -15514(A5)                     ; g_field_14
0878: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
087C: 5F80588F      MOVE.B     D0,-113(A7,D5.L)
0880: 6704          BEQ.S      $0886
0882: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0886: 48780022      PEA        $0022.W
088A: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
088E: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0892: 2B7CFFFF8001A5DE  MOVE.L     #$FFFF8001,-23074(A5)
089A: 426EFFEE      CLR.W      -18(A6)
089E: 508F          MOVE.B     A7,(A0)
08A0: 6000012A      BRA.W      $09CE
08A4: 4A2DBD8E      TST.B      -17010(A5)
08A8: 66000084      BNE.W      $0930
08AC: 7022          MOVEQ      #34,D0
08AE: C1EEFFEE      ANDA.L     -18(A6),A0
08B2: 204D          MOVEA.L    A5,A0
08B4: D1C04A28      MOVE.B     D0,$4A28.W
08B8: A610          MOVE.L     (A0),D3
08BA: 6728          BEQ.S      $08E4
08BC: 7022          MOVEQ      #34,D0
08BE: C1EEFFEE      ANDA.L     -18(A6),A0
08C2: 204D          MOVEA.L    A5,A0
08C4: D1C04868      MOVE.B     D0,$4868.W
08C8: A5F04EAD0DC2  MOVE.L     -83(A0,D4.L*8),3522(PC)
08CE: 5980588F      MOVE.B     D0,-113(A4,D5.L)
08D2: 6310          BLS.S      $08E4
08D4: 7022          MOVEQ      #34,D0
08D6: C1EEFFEE      ANDA.L     -18(A6),A0
08DA: 204D          MOVEA.L    A5,A0
08DC: D1C07064      MOVE.B     D0,$7064.W
08E0: D1A8A6087022  MOVE.B     -23032(A0),34(A0,D7.W)
08E6: C1EEFFEE      ANDA.L     -18(A6),A0
08EA: 204D          MOVEA.L    A5,A0
08EC: D1C04A28      MOVE.B     D0,$4A28.W
08F0: A610          MOVE.L     (A0),D3
08F2: 6716          BEQ.S      $090A
08F4: 7022          MOVEQ      #34,D0
08F6: C1EEFFEE      ANDA.L     -18(A6),A0
08FA: 204D          MOVEA.L    A5,A0
08FC: D1C04868      MOVE.B     D0,$4868.W
0900: A5F04EAD0DC2  MOVE.L     -83(A0,D4.L*8),3522(PC)
0906: 588F          MOVE.B     A7,(A4)
0908: 6002          BRA.S      $090C
090A: 7000          MOVEQ      #0,D0
090C: 4878001C      PEA        $001C.W
0910: 2F00          MOVE.L     D0,-(A7)
0912: 4EAD0042      JSR        66(A5)                         ; JT[66]
0916: 206DD568      MOVEA.L    -10904(A5),A0
091A: 7222          MOVEQ      #34,D1
091C: C3EEFFEE      ANDA.L     -18(A6),A1
0920: 20300818      MOVE.L     24(A0,D0.L),D0
0924: 224D          MOVEA.L    A5,A1
0926: D3C1D1A9A608  MOVE.B     D1,$D1A9A608
092C: 600E          BRA.S      $093C
092E: 7022          MOVEQ      #34,D0
0930: C1EEFFEE      ANDA.L     -18(A6),A0
0934: 204D          MOVEA.L    A5,A0
0936: D1C042A8      MOVE.B     D0,$42A8.W
093A: A608          MOVE.L     A0,D3
093C: 42A7          CLR.L      -(A7)
093E: 42A7          CLR.L      -(A7)
0940: 7022          MOVEQ      #34,D0
0942: C1EEFFEE      ANDA.L     -18(A6),A0
0946: 204D          MOVEA.L    A5,A0
0948: D1C04868      MOVE.B     D0,$4868.W
094C: A5F04EAD09E2  MOVE.L     -83(A0,D4.L*8),2530(PC)
0952: 7222          MOVEQ      #34,D1
0954: C3EEFFEE      ANDA.L     -18(A6),A1
0958: 204D          MOVEA.L    A5,A0
095A: D1C190A8      MOVE.B     D1,$90A8.W
095E: A604          MOVE.L     D4,D3
0960: 7222          MOVEQ      #34,D1
0962: C3EEFFEE      ANDA.L     -18(A6),A1
0966: 204D          MOVEA.L    A5,A0
0968: D1C1D1A8      MOVE.B     D1,$D1A8.W
096C: A608          MOVE.L     A0,D3
096E: 202DA5DE      MOVE.L     -23074(A5),D0                  ; g_dawg_ptr
0972: D0ADA5E2      MOVE.B     -23070(A5),(A0)                ; g_sect1_off
0976: 7222          MOVEQ      #34,D1
0978: C3EEFFEE      ANDA.L     -18(A6),A1
097C: 204D          MOVEA.L    A5,A0
097E: D1C17222      MOVE.B     D1,$7222.W
0982: C3EEFFEE      ANDA.L     -18(A6),A1
0986: 224D          MOVEA.L    A5,A1
0988: D3C12228A600  MOVE.B     D1,$2228A600
098E: D2A9A604      MOVE.B     -23036(A1),(A1)
0992: 7422          MOVEQ      #34,D2
0994: C5EEFFEE      ANDA.L     -18(A6),A2
0998: 204D          MOVEA.L    A5,A0
099A: D1C2D2A8      MOVE.B     D2,$D2A8.W
099E: A608          MOVE.L     A0,D3
09A0: D0ADA5E6      MOVE.B     -23066(A5),(A0)                ; g_sect2_off
09A4: B280          MOVE.W     D0,(A1)
09A6: 4FEF000C      LEA        12(A7),A7
09AA: 6F1C          BLE.S      $09C8
09AC: 7022          MOVEQ      #34,D0
09AE: C1EEFFEE      ANDA.L     -18(A6),A0
09B2: 204D          MOVEA.L    A5,A0
09B4: D1C043ED      MOVE.B     D0,$43ED.W
09B8: A5CE41E8      MOVE.L     A6,16872(PC)
09BC: A5F0700722D8  MOVE.L     7(A0,D7.W),8920(PC)
09C2: 51C8FFFC      DBF        D0,$09C0                       ; loop
09C6: 32D8          MOVE.W     (A0)+,(A1)+
09C8: 526EFFEE      MOVEA.B    -18(A6),A1
09CC: 302EFFEE      MOVE.W     -18(A6),D0
09D0: B06DCF04      MOVEA.W    -12540(A5),A0
09D4: 6D00FECE      BLT.W      $08A6
09D8: 206DD13C      MOVEA.L    -11972(A5),A0
09DC: 4A68000A      TST.W      10(A0)
09E0: 6744          BEQ.S      $0A26
09E2: 2F2DC376      MOVE.L     -15498(A5),-(A7)               ; A5-15498
09E6: 4EAD0542      JSR        1346(A5)                       ; JT[1346]
09EA: 2EADC376      MOVE.L     -15498(A5),(A7)                ; A5-15498
09EE: 2F2D9028      MOVE.L     -28632(A5),-(A7)               ; A5-28632
09F2: 486EE72C      PEA        -6356(A6)
09F6: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
09FA: 3040          MOVEA.W    D0,A0
09FC: 2D48E7C4      MOVE.L     A0,-6204(A6)
0A00: 486EE72C      PEA        -6356(A6)
0A04: 2F08          MOVE.L     A0,-(A7)
0A06: 226DD13C      MOVEA.L    -11972(A5),A1
0A0A: 3F29000A      MOVE.W     10(A1),-(A7)
0A0E: 4EAD06DA      JSR        1754(A5)                       ; JT[1754]
0A12: 206DD13C      MOVEA.L    -11972(A5),A0
0A16: 3EA8000A      MOVE.W     10(A0),(A7)
0A1A: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0A1E: 4EBA067C      JSR        1660(PC)
0A22: 4FEF001A      LEA        26(A7),A7
0A26: 2F2EE7CE      MOVE.L     -6194(A6),-(A7)
0A2A: 2F2EE7DA      MOVE.L     -6182(A6),-(A7)
0A2E: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0A32: 4EAD09E2      JSR        2530(A5)                       ; JT[2530]
0A36: 2D6DA5DEE7C0  MOVE.L     -23074(A5),-6208(A6)           ; g_dawg_ptr
0A3C: 48780080      PEA        $0080.W
0A40: 486DA54E      PEA        -23218(A5)                     ; A5-23218
0A44: 486EE690      PEA        -6512(A6)
0A48: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0A4C: 2D6EE7D6E7CA  MOVE.L     -6186(A6),-6198(A6)
0A52: 2D6EE7D2E7D6  MOVE.L     -6190(A6),-6186(A6)
0A58: 2D6EE7CEE7D2  MOVE.L     -6194(A6),-6190(A6)
0A5E: 2D6EE7CAE7CE  MOVE.L     -6198(A6),-6194(A6)
0A64: 2D6EE7E2E7CA  MOVE.L     -6174(A6),-6198(A6)
0A6A: 2D6EE7DEE7E2  MOVE.L     -6178(A6),-6174(A6)
0A70: 2D6EE7DAE7DE  MOVE.L     -6182(A6),-6178(A6)
0A76: 2D6EE7CAE7DA  MOVE.L     -6198(A6),-6182(A6)
0A7C: 4257          CLR.W      (A7)
0A7E: 2F2DC376      MOVE.L     -15498(A5),-(A7)               ; A5-15498
0A82: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0A86: 4EAD0942      JSR        2370(A5)                       ; JT[2370]
0A8A: 526EE7C8      MOVEA.B    -6200(A6),A1
0A8E: 2EADC376      MOVE.L     -15498(A5),(A7)                ; A5-15498
0A92: 4EAD0962      JSR        2402(A5)                       ; JT[2402]
0A96: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
0A9A: B1EDC3764FEF  MOVE.W     -15498(A5),$4FEF.W             ; A5-15498
0AA0: 00206612      ORI.B      #$6612,-(A0)
0AA4: 202DA5DE      MOVE.L     -23074(A5),D0                  ; g_dawg_ptr
0AA8: D1ADC37241ED  MOVE.B     -15502(A5),-19(A0,D4.W)        ; g_size2=65536
0AAE: C35E          AND.W      D1,(A6)+
0AB0: 2B48C376      MOVE.L     A0,-15498(A5)
0AB4: 6010          BRA.S      $0AC6
0AB6: 202DA5DE      MOVE.L     -23074(A5),D0                  ; g_dawg_ptr
0ABA: D1ADC36E41ED  MOVE.B     -15506(A5),-19(A0,D4.W)        ; g_size1=56630
0AC0: C366          AND.W      D1,-(A6)
0AC2: 2B48C376      MOVE.L     A0,-15498(A5)
0AC6: 206DD13C      MOVEA.L    -11972(A5),A0
0ACA: 4A680016      TST.W      22(A0)
0ACE: 6714          BEQ.S      $0AE4
0AD0: 2F3C00010000  MOVE.L     #$00010000,-(A7)
0AD6: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0ADA: 4EAD016A      JSR        362(A5)                        ; JT[362]
0ADE: 4EAD04EA      JSR        1258(A5)                       ; JT[1258]
0AE2: 508F          MOVE.B     A7,(A0)
0AE4: 4EAD092A      JSR        2346(A5)                       ; JT[2346]
0AE8: 4A40          TST.W      D0
0AEA: 6700FD20      BEQ.W      $080E
0AEE: 4A2DC35E      TST.B      -15522(A5)
0AF2: 6726          BEQ.S      $0B1A
0AF4: 4A2DC366      TST.B      -15514(A5)
0AF8: 6720          BEQ.S      $0B1A
0AFA: 486DC35E      PEA        -15522(A5)                     ; g_field_22
0AFE: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
0B02: 48C0          EXT.L      D0
0B04: 91ADC36E486D  MOVE.B     -15506(A5),109(A0,D4.L)        ; g_size1=56630
0B0A: C366          AND.W      D1,-(A6)
0B0C: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
0B10: 48C0          EXT.L      D0
0B12: 91ADC372508F  MOVE.B     -15502(A5),-113(A0,D5.W)       ; g_size2=65536
0B18: 6036          BRA.S      $0B50
0B1A: 4A2DC366      TST.B      -15514(A5)
0B1E: 6714          BEQ.S      $0B34
0B20: 486DC366      PEA        -15514(A5)                     ; g_field_14
0B24: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
0B28: D040          MOVEA.B    D0,A0
0B2A: 48C0          EXT.L      D0
0B2C: D1ADC36E588F  MOVE.B     -15506(A5),-113(A0,D5.L)       ; g_size1=56630
0B32: 601C          BRA.S      $0B50
0B34: 4A2DC35E      TST.B      -15522(A5)
0B38: 6604          BNE.S      $0B3E
0B3A: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0B3E: 486DC35E      PEA        -15522(A5)                     ; g_field_22
0B42: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
0B46: D040          MOVEA.B    D0,A0
0B48: 48C0          EXT.L      D0
0B4A: D1ADC372588F  MOVE.B     -15502(A5),-113(A0,D5.L)       ; g_size2=65536
0B50: 202DC36E      MOVE.L     -15506(A5),D0                  ; g_size1=56630
0B54: D1AEE71C222D  MOVE.B     -6372(A6),45(A0,D2.W*2)
0B5A: C372D3AE      AND.W      D1,-82(A2,A5.W*2)
0B5E: E718          MOVE.L     (A0)+,-(A3)
0B60: D081          MOVE.B     D1,(A0)
0B62: D1AEE728302E  MOVE.B     -6360(A6),46(A0,D3.W)
0B68: E7C848C0      MOVE.L     A0,-64(PC,D4.L)
0B6C: D1AEE72052AE  MOVE.B     -6368(A6),-82(A0,D5.W*2)
0B72: E724          MOVE.L     -(A4),-(A3)
0B74: B2ADC36E      MOVE.W     -15506(A5),(A1)                ; g_size1=56630
0B78: 6C08          BGE.S      $0B82
0B7A: 54AEE714      MOVE.B     -6380(A6),(A2)
0B7E: 6000FBC0      BRA.W      $0742
0B82: 202DC36E      MOVE.L     -15506(A5),D0                  ; g_size1=56630
0B86: B0ADC372      MOVE.W     -15502(A5),(A0)                ; g_size2=65536
0B8A: 6C08          BGE.S      $0B94
0B8C: 54AEE710      MOVE.B     -6384(A6),(A2)
0B90: 6000FBAE      BRA.W      $0742
0B94: 52AEE710      MOVE.B     -6384(A6),(A1)
0B98: 52AEE714      MOVE.B     -6380(A6),(A1)
0B9C: 6000FBA2      BRA.W      $0742
0BA0: 536DA3866042  MOVE.B     -23674(A5),24642(A1)           ; A5-23674
0BA6: 2F2DA222      MOVE.L     -24030(A5),-(A7)               ; A5-24030
0BAA: 2F2D93AC      MOVE.L     -27732(A5),-(A7)               ; A5-27732
0BAE: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
0BB2: 4A40          TST.W      D0
0BB4: 508F          MOVE.B     A7,(A0)
0BB6: 6730          BEQ.S      $0BE8
0BB8: 4A6DA386      TST.W      -23674(A5)
0BBC: 6E04          BGT.S      $0BC2
0BBE: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0BC2: 2B6DA222A222  MOVE.L     -24030(A5),-24030(A5)          ; A5-24030
0BC8: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
0BCE: C1EDA386      ANDA.L     -23674(A5),A0
0BD2: 41EDA226      LEA        -24026(A5),A0                  ; g_common
0BD6: D088          MOVE.B     A0,(A0)
0BD8: 2040          MOVEA.L    D0,A0
0BDA: 7001          MOVEQ      #1,D0
0BDC: 4A40          TST.W      D0
0BDE: 6602          BNE.S      $0BE2
0BE0: 7001          MOVEQ      #1,D0
0BE2: 4CD8          DC.W       $4CD8
0BE4: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
0BE8: 48780220      PEA        $0220.W
0BEC: 486DBCFE      PEA        -17154(A5)                     ; g_state1
0BF0: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0BF4: 48780440      PEA        $0440.W
0BF8: 486DBF1E      PEA        -16610(A5)                     ; g_state2
0BFC: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0C00: 7008          MOVEQ      #8,D0
0C02: 2E80          MOVE.L     D0,(A7)
0C04: 486DC366      PEA        -15514(A5)                     ; g_field_14
0C08: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0C0C: 7008          MOVEQ      #8,D0
0C0E: 2E80          MOVE.L     D0,(A7)
0C10: 486DC35E      PEA        -15522(A5)                     ; g_field_22
0C14: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0C18: 42ADC372      CLR.L      -15502(A5)
0C1C: 42ADC36E      CLR.L      -15506(A5)
0C20: 206DD13C      MOVEA.L    -11972(A5),A0
0C24: 4A68000A      TST.W      10(A0)
0C28: 4FEF0018      LEA        24(A7),A7
0C2C: 670E          BEQ.S      $0C3C
0C2E: 206DD13C      MOVEA.L    -11972(A5),A0
0C32: 3F28000A      MOVE.W     10(A0),-(A7)
0C36: 4EBA04DC      JSR        1244(PC)
0C3A: 548F          MOVE.B     A7,(A2)
0C3C: 4EAD040A      JSR        1034(A5)                       ; JT[1034]
0C40: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
0C44: 4EAD04EA      JSR        1258(A5)                       ; JT[1258]
0C48: 4EAD03C2      JSR        962(A5)                        ; JT[962]
0C4C: 4EAD06B2      JSR        1714(A5)                       ; JT[1714]
0C50: 4E5E          UNLK       A6
0C52: 4E75          RTS        


; ======= Function at 0x0C54 =======
0C54: 4E56F98C      LINK       A6,#-1652                      ; frame=1652
0C58: 2B6E0008D13C  MOVE.L     8(A6),-11972(A5)
0C5E: 4EAD06AA      JSR        1706(A5)                       ; JT[1706]
0C62: 206DD13C      MOVEA.L    -11972(A5),A0
0C66: 4A68000A      TST.W      10(A0)
0C6A: 671A          BEQ.S      $0C86
0C6C: 4EBA0482      JSR        1154(PC)
0C70: 206DD13C      MOVEA.L    -11972(A5),A0
0C74: 3140000A      MOVE.W     D0,10(A0)
0C78: 206DD13C      MOVEA.L    -11972(A5),A0
0C7C: 3F28000A      MOVE.W     10(A0),-(A7)
0C80: 4EAD059A      JSR        1434(A5)                       ; JT[1434]
0C84: 548F          MOVE.B     A7,(A2)
0C86: 42ADB3E2      CLR.L      -19486(A5)
0C8A: 48780220      PEA        $0220.W
0C8E: 486DBCFE      PEA        -17154(A5)                     ; g_state1
0C92: 486EFDE0      PEA        -544(A6)
0C96: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0C9A: 48780440      PEA        $0440.W
0C9E: 486DBF1E      PEA        -16610(A5)                     ; g_state2
0CA2: 486EF9A0      PEA        -1632(A6)
0CA6: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0CAA: 486DC366      PEA        -15514(A5)                     ; g_field_14
0CAE: 486EF998      PEA        -1640(A6)
0CB2: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0CB6: 486DC35E      PEA        -15522(A5)                     ; g_field_22
0CBA: 486EF990      PEA        -1648(A6)
0CBE: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0CC2: 2D6DC376F98C  MOVE.L     -15498(A5),-1652(A6)           ; A5-15498
0CC8: 0C6D0008A386  CMPI.W     #$0008,-23674(A5)
0CCE: 4FEF0028      LEA        40(A7),A7
0CD2: 6406          BCC.S      $0CDA
0CD4: 4A6DA386      TST.W      -23674(A5)
0CD8: 6C04          BGE.S      $0CDE
0CDA: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0CDE: 302DA386      MOVE.W     -23674(A5),D0                  ; A5-23674
0CE2: 526DA386      MOVEA.B    -23674(A5),A1
0CE6: C1FC002C41ED  ANDA.L     #$002C41ED,A0
0CEC: A226          MOVE.L     -(A6),D1
0CEE: D088          MOVE.B     A0,(A0)
0CF0: 2040          MOVEA.L    D0,A0
0CF2: 7000          MOVEQ      #0,D0
0CF4: 43FA0006      LEA        6(PC),A1
0CF8: 48D0          DC.W       $48D0
0CFA: DEF84A40      MOVE.B     $4A40.W,(A7)+
0CFE: 6640          BNE.S      $0D40
0D00: 206DD13C      MOVEA.L    -11972(A5),A0
0D04: 4A680010      TST.W      16(A0)
0D08: 6726          BEQ.S      $0D30
0D0A: 486D00BA      PEA        186(A5)                        ; A5+186
0D0E: 4EAD0A42      JSR        2626(A5)                       ; JT[2626]
0D12: 206DD13C      MOVEA.L    -11972(A5),A0
0D16: 4AA80004      TST.L      4(A0)
0D1A: 588F          MOVE.B     A7,(A4)
0D1C: 671C          BEQ.S      $0D3A
0D1E: 2F2DD13C      MOVE.L     -11972(A5),-(A7)               ; g_dawg_ptr2
0D22: 206DD13C      MOVEA.L    -11972(A5),A0
0D26: 20680004      MOVEA.L    4(A0),A0
0D2A: 4E90          JSR        (A0)
0D2C: 588F          MOVE.B     A7,(A4)
0D2E: 600A          BRA.S      $0D3A
0D30: 486D00BA      PEA        186(A5)                        ; A5+186
0D34: 4EAD0A4A      JSR        2634(A5)                       ; JT[2634]
0D38: 588F          MOVE.B     A7,(A4)
0D3A: 536DA3866042  MOVE.B     -23674(A5),24642(A1)           ; A5-23674
0D40: 2F2DA222      MOVE.L     -24030(A5),-(A7)               ; A5-24030
0D44: 2F2D93AC      MOVE.L     -27732(A5),-(A7)               ; A5-27732
0D48: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
0D4C: 4A40          TST.W      D0
0D4E: 508F          MOVE.B     A7,(A0)
0D50: 6730          BEQ.S      $0D82
0D52: 4A6DA386      TST.W      -23674(A5)
0D56: 6E04          BGT.S      $0D5C
0D58: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0D5C: 2B6DA222A222  MOVE.L     -24030(A5),-24030(A5)          ; A5-24030
0D62: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
0D68: C1EDA386      ANDA.L     -23674(A5),A0
0D6C: 41EDA226      LEA        -24026(A5),A0                  ; g_common
0D70: D088          MOVE.B     A0,(A0)
0D72: 2040          MOVEA.L    D0,A0
0D74: 7001          MOVEQ      #1,D0
0D76: 4A40          TST.W      D0
0D78: 6602          BNE.S      $0D7C
0D7A: 7001          MOVEQ      #1,D0
0D7C: 4CD8          DC.W       $4CD8
0D7E: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
0D82: 48780220      PEA        $0220.W
0D86: 486EFDE0      PEA        -544(A6)
0D8A: 486DBCFE      PEA        -17154(A5)                     ; g_state1
0D8E: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0D92: 48780440      PEA        $0440.W
0D96: 486EF9A0      PEA        -1632(A6)
0D9A: 486DBF1E      PEA        -16610(A5)                     ; g_state2
0D9E: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
0DA2: 486EF998      PEA        -1640(A6)
0DA6: 486DC366      PEA        -15514(A5)                     ; g_field_14
0DAA: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0DAE: 486EF990      PEA        -1648(A6)
0DB2: 486DC35E      PEA        -15522(A5)                     ; g_field_22
0DB6: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0DBA: 2B6EF98CC376  MOVE.L     -1652(A6),-15498(A5)
0DC0: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
0DC4: B1EDC3764FEF  MOVE.W     -15498(A5),$4FEF.W             ; A5-15498
0DCA: 002867044EAD  ORI.B      #$6704,20141(A0)
0DD0: 01A2          BCLR       D0,-(A2)
0DD2: 2F2DC376      MOVE.L     -15498(A5),-(A7)               ; A5-15498
0DD6: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
0DDA: 4EAD099A      JSR        2458(A5)                       ; JT[2458]
0DDE: 206DD13C      MOVEA.L    -11972(A5),A0
0DE2: 4A68000A      TST.W      10(A0)
0DE6: 588F          MOVE.B     A7,(A4)
0DE8: 670E          BEQ.S      $0DF8
0DEA: 206DD13C      MOVEA.L    -11972(A5),A0
0DEE: 3F28000A      MOVE.W     10(A0),-(A7)
0DF2: 4EBA0320      JSR        800(PC)
0DF6: 548F          MOVE.B     A7,(A2)
0DF8: 206DD13C      MOVEA.L    -11972(A5),A0
0DFC: 4A680016      TST.W      22(A0)
0E00: 6708          BEQ.S      $0E0A
0E02: 4EAD040A      JSR        1034(A5)                       ; JT[1034]
0E06: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
0E0A: 4EAD06B2      JSR        1714(A5)                       ; JT[1714]
0E0E: 4E5E          UNLK       A6
0E10: 4E75          RTS        


; ======= Function at 0x0E12 =======
0E12: 4E560000      LINK       A6,#0
0E16: 4EBAF338      JSR        -3272(PC)
0E1A: 4E5E          UNLK       A6
0E1C: 4E75          RTS        


; ======= Function at 0x0E1E =======
0E1E: 4E56FF80      LINK       A6,#-128                       ; frame=128
0E22: 2F0C          MOVE.L     A4,-(A7)
0E24: 3F3C0004      MOVE.W     #$0004,-(A7)
0E28: 2F2D9078      MOVE.L     -28552(A5),-(A7)               ; A5-28552
0E2C: 4EAD05F2      JSR        1522(A5)                       ; JT[1522]
0E30: 2E80          MOVE.L     D0,(A7)
0E32: 4267          CLR.W      -(A7)
0E34: A9633EBC      MOVE.L     -(A3),16060(A4)
0E38: 00032F2D      ORI.B      #$2F2D,D3
0E3C: 90784EAD      MOVEA.B    $4EAD.W,A0
0E40: 05F22E80      BSET       D2,-128(A2,D2.L*8)
0E44: 4267          CLR.W      -(A7)
0E46: A9633EBC      MOVE.L     -(A3),16060(A4)
0E4A: 00022F2D      ORI.B      #$2F2D,D2
0E4E: 90784EAD      MOVEA.B    $4EAD.W,A0
0E52: 05F22E80      BSET       D2,-128(A2,D2.L*8)
0E56: 4267          CLR.W      -(A7)
0E58: A9633EBC      MOVE.L     -(A3),16060(A4)
0E5C: 000A2F2D      ORI.B      #$2F2D,A2
0E60: 90784EAD      MOVEA.B    $4EAD.W,A0
0E64: 05F22E80      BSET       D2,-128(A2,D2.L*8)
0E68: 4267          CLR.W      -(A7)
0E6A: A9633EBC      MOVE.L     -(A3),16060(A4)
0E6E: 00082F2D      ORI.B      #$2F2D,A0
0E72: 90784EAD      MOVEA.B    $4EAD.W,A0
0E76: 05F22840      BSET       D2,64(A2,D2.L)
0E7A: 2E8C          MOVE.L     A4,(A7)
0E7C: 4267          CLR.W      -(A7)
0E7E: A963486D      MOVE.L     -(A3),18541(A4)
0E82: C366          AND.W      D1,-(A6)
0E84: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
0E88: 2E8C          MOVE.L     A4,(A7)
0E8A: 486EFF80      PEA        -128(A6)
0E8E: 4EAD095A      JSR        2394(A5)                       ; JT[2394]
0E92: 0C40000C      CMPI.W     #$000C,D0
0E96: 588F          MOVE.B     A7,(A4)
0E98: 6F06          BLE.S      $0EA0
0E9A: 303C00FF      MOVE.W     #$00FF,D0
0E9E: 6002          BRA.S      $0EA2
0EA0: 7000          MOVEQ      #0,D0
0EA2: 3F00          MOVE.W     D0,-(A7)
0EA4: A95D486D      MOVE.L     (A5)+,18541(A4)
0EA8: 907C3F3C      MOVEA.B    #$3C,A0
0EAC: 00052F2D      ORI.B      #$2F2D,D5
0EB0: 90784EAD      MOVEA.B    $4EAD.W,A0
0EB4: 063A286EFF7C  ADDI.B     #$286E,-132(PC)
0EBA: 4E5E          UNLK       A6
0EBC: 4E75          RTS        


; ======= Function at 0x0EBE =======
0EBE: 4E560000      LINK       A6,#0
0EC2: 2F2E000C      MOVE.L     12(A6),-(A7)
0EC6: 2F2E0008      MOVE.L     8(A6),-(A7)
0ECA: 4EAD0D0A      JSR        3338(A5)                       ; JT[3338]
0ECE: 2EADA1F6      MOVE.L     -24074(A5),(A7)                ; A5-24074
0ED2: 3F3C0005      MOVE.W     #$0005,-(A7)
0ED6: 2F2E0008      MOVE.L     8(A6),-(A7)
0EDA: 4EAD0CD2      JSR        3282(A5)                       ; JT[3282]
0EDE: 4E5E          UNLK       A6
0EE0: 4E75          RTS        


; ======= Function at 0x0EE2 =======
0EE2: 4E560000      LINK       A6,#0
0EE6: 42A7          CLR.L      -(A7)
0EE8: 486D0092      PEA        146(A5)                        ; A5+146
0EEC: 2F2DA21E      MOVE.L     -24034(A5),-(A7)               ; A5-24034
0EF0: 3F3C03F7      MOVE.W     #$03F7,-(A7)
0EF4: 4EAD0C92      JSR        3218(A5)                       ; JT[3218]
0EF8: 4E5E          UNLK       A6
0EFA: 4E75          RTS        


; ======= Function at 0x0EFC =======
0EFC: 4E56FFFE      LINK       A6,#-2                         ; frame=2
0F00: 2B6E00089078  MOVE.L     8(A6),-28552(A5)
0F06: 4EBAFF16      JSR        -234(PC)
0F0A: 486D0C8A      PEA        3210(A5)                       ; A5+3210
0F0E: 486EFFFE      PEA        -2(A6)
0F12: A991302E      MOVE.L     (A1),46(A4,D3.W)
0F16: FFFE          MOVE.W     ???,???
0F18: 0C40000B      CMPI.W     #$000B,D0
0F1C: 62EC          BHI.S      $0F0A
0F1E: 43FA0030      LEA        48(PC),A1
0F22: D040          MOVEA.B    D0,A0
0F24: D2F10000      MOVE.B     0(A1,D0.W),(A1)+
0F28: 4ED1          JMP        (A1)
0F2A: 4EBAF338      JSR        -3272(PC)
0F2E: 601C          BRA.S      $0F4C
0F30: 4EBAFEEC      JSR        -276(PC)
0F34: 60D4          BRA.S      $0F0A
0F36: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
0F3A: 2F2D9078      MOVE.L     -28552(A5),-(A7)               ; A5-28552
0F3E: 4EAD05F2      JSR        1522(A5)                       ; JT[1522]
0F42: 2E80          MOVE.L     D0,(A7)
0F44: 4EAD05D2      JSR        1490(A5)                       ; JT[1490]
0F48: 5C8F          MOVE.B     A7,(A6)
0F4A: 60BE          BRA.S      $0F0A
0F4C: 4E5E          UNLK       A6
0F4E: 4E75          RTS        

0F50: FFBAFFDAFFE6  MOVE.W     -38(PC),-26(A7,A7.L*8)
0F56: FFE6          MOVE.W     -(A6),???
0F58: FFE6          MOVE.W     -(A6),???
0F5A: FFBAFFE0FFBA  MOVE.W     -32(PC),-70(A7,A7.L*8)
0F60: FFE6          MOVE.W     -(A6),???
0F62: FFBAFFE6FFFC  MOVE.W     -26(PC),-4(A7,A7.L*8)

; ======= Function at 0x0F68 =======
0F68: 4E56FDFC      LINK       A6,#-516                       ; frame=516
0F6C: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
0F70: 286E0008      MOVEA.L    8(A6),A4
0F74: 3F3C0004      MOVE.W     #$0004,-(A7)
0F78: 2F2D9078      MOVE.L     -28552(A5),-(A7)               ; A5-28552
0F7C: 4EAD05E2      JSR        1506(A5)                       ; JT[1506]
0F80: 39400012      MOVE.W     D0,18(A4)
0F84: 3EBC0003      MOVE.W     #$0003,(A7)
0F88: 2F2D9078      MOVE.L     -28552(A5),-(A7)               ; A5-28552
0F8C: 4EAD05E2      JSR        1506(A5)                       ; JT[1506]
0F90: 39400014      MOVE.W     D0,20(A4)
0F94: 3EBC0002      MOVE.W     #$0002,(A7)
0F98: 2F2D9078      MOVE.L     -28552(A5),-(A7)               ; A5-28552
0F9C: 4EAD05E2      JSR        1506(A5)                       ; JT[1506]
0FA0: 3940000A      MOVE.W     D0,10(A4)
0FA4: 3EBC0008      MOVE.W     #$0008,(A7)
0FA8: 2F2D9078      MOVE.L     -28552(A5),-(A7)               ; A5-28552
0FAC: 4EAD05E2      JSR        1506(A5)                       ; JT[1506]
0FB0: 39400010      MOVE.W     D0,16(A4)
0FB4: 3EBC000A      MOVE.W     #$000A,(A7)
0FB8: 2F2D9078      MOVE.L     -28552(A5),-(A7)               ; A5-28552
0FBC: 4EAD05E2      JSR        1506(A5)                       ; JT[1506]
0FC0: 39400016      MOVE.W     D0,22(A4)
0FC4: 486EFF00      PEA        -256(A6)
0FC8: 3F3C0005      MOVE.W     #$0005,-(A7)
0FCC: 2F2D9078      MOVE.L     -28552(A5),-(A7)               ; A5-28552
0FD0: 4EAD0642      JSR        1602(A5)                       ; JT[1602]
0FD4: 486C0008      PEA        8(A4)
0FD8: 486D907E      PEA        -28546(A5)                     ; A5-28546
0FDC: 486EFF00      PEA        -256(A6)
0FE0: 4EAD081A      JSR        2074(A5)                       ; JT[2074]
0FE4: 4297          CLR.L      (A7)
0FE6: 48780007      PEA        $0007.W
0FEA: 2F2D9078      MOVE.L     -28552(A5),-(A7)               ; A5-28552
0FEE: 4EAD01EA      JSR        490(A5)                        ; JT[490]
0FF2: 3EBC0121      MOVE.W     #$0121,(A7)
0FF6: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
0FFA: 4EAD0D7A      JSR        3450(A5)                       ; JT[3450]
0FFE: 4A40          TST.W      D0
1000: 4FEF0038      LEA        56(A7),A7
1004: 6708          BEQ.S      $100E
1006: 4A6DDE28      TST.W      -8664(A5)
100A: 67000088      BEQ.W      $1096
100E: 42A7          CLR.L      -(A7)
1010: 206DDEB8      MOVEA.L    -8520(A5),A0
1014: 2F2800CA      MOVE.L     202(A0),-(A7)
1018: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
101C: 2D5FFDFC      MOVE.L     (A7)+,-516(A6)
1020: 48780006      PEA        $0006.W
1024: 2F2EFDFC      MOVE.L     -516(A6),-(A7)
1028: 4EAD004A      JSR        74(A5)                         ; JT[74]
102C: 3A00          MOVE.W     D0,D5
102E: 0C450040      CMPI.W     #$0040,D5
1032: 6F02          BLE.S      $1036
1034: 7A40          MOVEQ      #64,D5
1036: 397C0078000E  MOVE.W     #$0078,14(A4)
103C: 3945000C      MOVE.W     D5,12(A4)
1040: 28BC0BEBC200  MOVE.L     #$0BEBC200,(A4)
1046: 41ED00B2      LEA        178(A5),A0                     ; A5+178
104A: 29480004      MOVE.L     A0,4(A4)
104E: 7800          MOVEQ      #0,D4
1050: 97CB7E00      MOVE.B     A3,0(PC,D7.L)
1054: 603A          BRA.S      $1090
1056: 206DDEB8      MOVEA.L    -8520(A5),A0
105A: 206800CA      MOVEA.L    202(A0),A0
105E: 2050          MOVEA.L    (A0),A0
1060: 20707802      MOVEA.L    2(A0,D7.L),A0
1064: 2450          MOVEA.L    (A0),A2
1066: 41EB0018      LEA        24(A3),A0
106A: D1CC2C08      MOVE.B     A4,$2C08.W
106E: 7022          MOVEQ      #34,D0
1070: 2246          MOVEA.L    D6,A1
1072: 204A          MOVEA.L    A2,A0
1074: A02E202A      MOVE.L     8234(A6),D0
1078: 0010D0AA      ORI.B      #$D0AA,(A0)
107C: 0014D0AA      ORI.B      #$D0AA,(A4)
1080: 00182046      ORI.B      #$2046,(A0)+
1084: 21400022      MOVE.L     D0,34(A0)
1088: 5244          MOVEA.B    D4,A1
108A: 47EB002E      LEA        46(A3),A3
108E: 5C87          MOVE.B     D7,(A6)
1090: BA44          MOVEA.W    D4,A5
1092: 6EC2          BGT.S      $1056
1094: 4CDF1CF0      MOVEM.L    (SP)+,D4/D5/D6/D7/A2/A3/A4     ; restore
1098: 4E5E          UNLK       A6
109A: 4E75          RTS        


; ======= Function at 0x109C =======
109C: 4E56FF7C      LINK       A6,#-132                       ; frame=132
10A0: 2F0C          MOVE.L     A4,-(A7)
10A2: 286E0008      MOVEA.L    8(A6),A4
10A6: 2F0C          MOVE.L     A4,-(A7)
10A8: 2F0C          MOVE.L     A4,-(A7)
10AA: 4A2C0020      TST.B      32(A4)
10AE: 6704          BEQ.S      $10B4
10B0: 70FC          MOVEQ      #-4,D0
10B2: 6002          BRA.S      $10B6
10B4: 7000          MOVEQ      #0,D0
10B6: 3F00          MOVE.W     D0,-(A7)
10B8: 2F0C          MOVE.L     A4,-(A7)
10BA: 486D9082      PEA        -28542(A5)                     ; A5-28542
10BE: 486EFF80      PEA        -128(A6)
10C2: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
10C6: 3040          MOVEA.W    D0,A0
10C8: 2D48FF7C      MOVE.L     A0,-132(A6)
10CC: 4257          CLR.W      (A7)
10CE: 3F2E000C      MOVE.W     12(A6),-(A7)
10D2: 486EFF7C      PEA        -132(A6)
10D6: 486EFF80      PEA        -128(A6)
10DA: 4EAD0B32      JSR        2866(A5)                       ; JT[2866]
10DE: 4A5F          TST.W      (A7)+
10E0: 4FEF0014      LEA        20(A7),A7
10E4: 6704          BEQ.S      $10EA
10E6: 4EAD01A2      JSR        418(A5)                        ; JT[418]
10EA: 285F          MOVEA.L    (A7)+,A4
10EC: 4E5E          UNLK       A6
10EE: 4E75          RTS        


; ======= Function at 0x10F0 =======
10F0: 4E56FFFE      LINK       A6,#-2                         ; frame=2
10F4: 2F3C54455854  MOVE.L     #$54455854,-(A7)
10FA: 3F3C0001      MOVE.W     #$0001,-(A7)
10FE: 486EFFFE      PEA        -2(A6)
1102: 4267          CLR.W      -(A7)
1104: 486D9092      PEA        -28526(A5)                     ; A5-28526
1108: 4EAD0D32      JSR        3378(A5)                       ; JT[3378]
110C: 302EFFFE      MOVE.W     -2(A6),D0
1110: 4E5E          UNLK       A6
1112: 4E75          RTS        


; ======= Function at 0x1114 =======
1114: 4E560000      LINK       A6,#0
1118: 4267          CLR.W      -(A7)
111A: 3F2E0008      MOVE.W     8(A6),-(A7)
111E: 4EAD0B22      JSR        2850(A5)                       ; JT[2850]
1122: 4E5E          UNLK       A6
1124: 4E75          RTS        
