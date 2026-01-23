;======================================================================
; CODE 22 Disassembly
; File: /tmp/maven_code_22.bin
; Header: JT offset=1376, JT entries=6
; Code size: 2056 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FF68      LINK       A6,#-152                       ; frame=152
0004: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; save
0008: 3A2E0008      MOVE.W     8(A6),D5
000C: 7801          MOVEQ      #1,D4
000E: 49ED95A3      LEA        -27229(A5),A4                  ; A5-27229
0012: 41ED97C3      LEA        -26685(A5),A0                  ; A5-26685
0016: 2C08          MOVE.L     A0,D6
0018: 47EDBD0F      LEA        -17137(A5),A3                  ; A5-17137
001C: 41EDBF40      LEA        -16576(A5),A0                  ; A5-16576
0020: 2E08          MOVE.L     A0,D7
0022: 600000DC      BRA.W      $0102
0026: 45EEFF80      LEA        -128(A6),A2
002A: 7601          MOVEQ      #1,D3
002C: 2D47FF78      MOVE.L     D7,-136(A6)
0030: 2D4BFF7C      MOVE.L     A3,-132(A6)
0034: 2D46FF70      MOVE.L     D6,-144(A6)
0038: 2D4CFF6C      MOVE.L     A4,-148(A6)
003C: 3043          MOVEA.W    D3,A0
003E: D1C82D48      MOVE.B     A0,$2D48.W
0042: FF686000008E  MOVE.W     24576(A0),142(A7)
0048: 206EFF78      MOVEA.L    -136(A6),A0
004C: D1EEFF684A50  MOVE.B     -152(A6),$4A50.W
0052: 670A          BEQ.S      $005E
0054: 206EFF7C      MOVEA.L    -132(A6),A0
0058: 14F03000      MOVE.B     0(A0,D3.W),(A2)+
005C: 606C          BRA.S      $00CA
005E: 3043          MOVEA.W    D3,A0
0060: D1CB2D48      MOVE.B     A3,$2D48.W
0064: FF744A106714  MOVE.W     16(A4,D4.L*2),26388(A7)
006A: 206EFF74      MOVEA.L    -140(A6),A0
006E: 1010          MOVE.B     (A0),D0
0070: 4880          EXT.W      D0
0072: 3F00          MOVE.W     D0,-(A7)
0074: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
0078: 14C0          MOVE.B     D0,(A2)+
007A: 548F          MOVE.B     A7,(A2)
007C: 604C          BRA.S      $00CA
007E: 206EFF70      MOVEA.L    -144(A6),A0
0082: 0C3000023000  CMPI.B     #$0002,0(A0,D3.W)
0088: 6606          BNE.S      $0090
008A: 14FC0024      MOVE.B     #$24,(A2)+
008E: 603A          BRA.S      $00CA
0090: 206EFF70      MOVEA.L    -144(A6),A0
0094: 0C3000033000  CMPI.B     #$0003,0(A0,D3.W)
009A: 6606          BNE.S      $00A2
009C: 14FC002A      MOVE.B     #$2A,(A2)+
00A0: 6028          BRA.S      $00CA
00A2: 206EFF6C      MOVEA.L    -148(A6),A0
00A6: 0C3000023000  CMPI.B     #$0002,0(A0,D3.W)
00AC: 6606          BNE.S      $00B4
00AE: 14FC002B      MOVE.B     #$2B,(A2)+
00B2: 6016          BRA.S      $00CA
00B4: 206EFF6C      MOVEA.L    -148(A6),A0
00B8: 0C3000033000  CMPI.B     #$0003,0(A0,D3.W)
00BE: 6606          BNE.S      $00C6
00C0: 14FC0023      MOVE.B     #$23,(A2)+
00C4: 6004          BRA.S      $00CA
00C6: 14FC002D      MOVE.B     #$2D,(A2)+
00CA: 14FC0020      MOVE.B     #$20,(A2)+
00CE: 5243          MOVEA.B    D3,A1
00D0: 54AEFF68      MOVE.B     -152(A6),(A2)
00D4: 0C430010      CMPI.W     #$0010,D3
00D8: 6500FF6E      BCS.W      $004A
00DC: 14FC000D      MOVE.B     #$0D,(A2)+
00E0: 4212          CLR.B      (A2)
00E2: 3F05          MOVE.W     D5,-(A7)
00E4: 486EFF80      PEA        -128(A6)
00E8: 4EAD0D2A      JSR        3370(A5)                       ; JT[3370]
00EC: 5C8F          MOVE.B     A7,(A6)
00EE: 5244          MOVEA.B    D4,A1
00F0: 49EC0011      LEA        17(A4),A4
00F4: 7011          MOVEQ      #17,D0
00F6: DC80          MOVE.B     D0,(A6)
00F8: 47EB0011      LEA        17(A3),A3
00FC: 7022          MOVEQ      #34,D0
00FE: DE80          MOVE.B     D0,(A7)
0100: 0C440010      CMPI.W     #$0010,D4
0104: 6500FF20      BCS.W      $0028
0108: 3F05          MOVE.W     D5,-(A7)
010A: 486DC366      PEA        -15514(A5)                     ; g_field_14
010E: 4EAD0D2A      JSR        3370(A5)                       ; JT[3370]
0112: 3E85          MOVE.W     D5,(A7)
0114: 486DF148      PEA        -3768(A5)                      ; A5-3768
0118: 4EAD0D2A      JSR        3370(A5)                       ; JT[3370]
011C: 3E85          MOVE.W     D5,(A7)
011E: 486DC35E      PEA        -15522(A5)                     ; g_field_22
0122: 4EAD0D2A      JSR        3370(A5)                       ; JT[3370]
0126: 7064          MOVEQ      #100,D0
0128: 2E80          MOVE.L     D0,(A7)
012A: 2F2DC36E      MOVE.L     -15506(A5),-(A7)               ; g_size1=56630
012E: 4EAD005A      JSR        90(A5)                         ; JT[90]
0132: 2E80          MOVE.L     D0,(A7)
0134: 48780064      PEA        $0064.W
0138: 2F2DC372      MOVE.L     -15502(A5),-(A7)               ; g_size2=65536
013C: 4EAD005A      JSR        90(A5)                         ; JT[90]
0140: 2F00          MOVE.L     D0,-(A7)
0142: 2F2DA1F2      MOVE.L     -24078(A5),-(A7)               ; A5-24078
0146: 486EFF80      PEA        -128(A6)
014A: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
014E: 3E85          MOVE.W     D5,(A7)
0150: 486EFF80      PEA        -128(A6)
0154: 4EAD0D2A      JSR        3370(A5)                       ; JT[3370]
0158: 4CEE1CF8FF48  MOVEM.L    -184(A6),D3/D4/D5/D6/D7/A2/A3/A4
015E: 4E5E          UNLK       A6
0160: 4E75          RTS        


; ======= Function at 0x0162 =======
0162: 4E56FFE2      LINK       A6,#-30                        ; frame=30
0166: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
016A: 3C2E0008      MOVE.W     8(A6),D6
016E: 2E2E000A      MOVE.L     10(A6),D7
0172: 2F3C54455854  MOVE.L     #$54455854,-(A7)
0178: 3F3C0001      MOVE.W     #$0001,-(A7)
017C: 486EFFFE      PEA        -2(A6)
0180: 3F06          MOVE.W     D6,-(A7)
0182: 2F07          MOVE.L     D7,-(A7)
0184: 4EAD0D32      JSR        3378(A5)                       ; JT[3378]
0188: 4A40          TST.W      D0
018A: 4FEF0010      LEA        16(A7),A7
018E: 6704          BEQ.S      $0194
0190: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0194: 4267          CLR.W      -(A7)
0196: 2F07          MOVE.L     D7,-(A7)
0198: 3F06          MOVE.W     D6,-(A7)
019A: 486EFFE6      PEA        -26(A6)
019E: 4EAD0B3A      JSR        2874(A5)                       ; JT[2874]
01A2: 2D7C58474D45FFE6  MOVE.L     #$58474D45,-26(A6)
01AA: 4257          CLR.W      (A7)
01AC: 2F07          MOVE.L     D7,-(A7)
01AE: 3F06          MOVE.W     D6,-(A7)
01B0: 486EFFE6      PEA        -26(A6)
01B4: 4EAD0B5A      JSR        2906(A5)                       ; JT[2906]
01B8: 4257          CLR.W      (A7)
01BA: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
01BE: 42A7          CLR.L      -(A7)
01C0: 4EAD0B6A      JSR        2922(A5)                       ; JT[2922]
01C4: 7A00          MOVEQ      #0,D5
01C6: 99CC548F      MOVE.B     A4,#$8F
01CA: 42A7          CLR.L      -(A7)
01CC: 206DDEC2      MOVEA.L    -8510(A5),A0
01D0: 2F2800CA      MOVE.L     202(A0),-(A7)
01D4: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
01D8: 2D5FFFE2      MOVE.L     (A7)+,-30(A6)
01DC: 48780006      PEA        $0006.W
01E0: 2F2EFFE2      MOVE.L     -30(A6),-(A7)
01E4: 4EAD004A      JSR        74(A5)                         ; JT[74]
01E8: 3045          MOVEA.W    D5,A0
01EA: B088          MOVE.W     A0,(A0)
01EC: 630000A4      BLS.W      $0294
01F0: 206DDEC2      MOVEA.L    -8510(A5),A0
01F4: 206800CA      MOVEA.L    202(A0),A0
01F8: 244C          MOVEA.L    A4,A2
01FA: D5D01012      MOVE.B     (A0),4114(PC)
01FE: 4880          EXT.W      D0
0200: 3D40FFFC      MOVE.W     D0,-4(A6)
0204: 266A0002      MOVEA.L    2(A2),A3
0208: 7202          MOVEQ      #2,D1
020A: 2D41FFF6      MOVE.L     D1,-10(A6)
020E: 4267          CLR.W      -(A7)
0210: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
0214: 486EFFF6      PEA        -10(A6)
0218: 486EFFFC      PEA        -4(A6)
021C: 4EAD0B32      JSR        2866(A5)                       ; JT[2866]
0220: 42A7          CLR.L      -(A7)
0222: 2F0B          MOVE.L     A3,-(A7)
0224: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0228: 201F          MOVE.L     (A7)+,D0
022A: 3D40FFFA      MOVE.W     D0,-6(A6)
022E: 7202          MOVEQ      #2,D1
0230: 2D41FFF6      MOVE.L     D1,-10(A6)
0234: 4257          CLR.W      (A7)
0236: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
023A: 486EFFF6      PEA        -10(A6)
023E: 486EFFFA      PEA        -6(A6)
0242: 4EAD0B32      JSR        2866(A5)                       ; JT[2866]
0246: 2F0B          MOVE.L     A3,-(A7)
0248: 4EAD05EA      JSR        1514(A5)                       ; JT[1514]
024C: 2440          MOVEA.L    D0,A2
024E: 0C6E0001FFFC  CMPI.W     #$0001,-4(A6)
0254: 5C8F          MOVE.B     A7,(A6)
0256: 6608          BNE.S      $0260
0258: 382A0004      MOVE.W     4(A2),D4
025C: 426A0004      CLR.W      4(A2)
0260: 306EFFFA      MOVEA.W    -6(A6),A0
0264: 2D48FFF6      MOVE.L     A0,-10(A6)
0268: 4267          CLR.W      -(A7)
026A: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
026E: 486EFFF6      PEA        -10(A6)
0272: 2F0A          MOVE.L     A2,-(A7)
0274: 4EAD0B32      JSR        2866(A5)                       ; JT[2866]
0278: 204B          MOVEA.L    A3,A0
027A: A02A0C6E      MOVE.L     3182(A2),D0
027E: 0001FFFC      ORI.B      #$FFFC,D1
0282: 548F          MOVE.B     A7,(A2)
0284: 6604          BNE.S      $028A
0286: 35440004      MOVE.W     D4,4(A2)
028A: 5245          MOVEA.B    D5,A1
028C: 5C8C          MOVE.B     A4,(A6)
028E: 6000FF3A      BRA.W      $01CC
0292: 4267          CLR.W      -(A7)
0294: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
0298: 4EAD0B22      JSR        2850(A5)                       ; JT[2850]
029C: 4A5F          TST.W      (A7)+
029E: 6704          BEQ.S      $02A4
02A0: 4EAD01A2      JSR        418(A5)                        ; JT[418]
02A4: 4267          CLR.W      -(A7)
02A6: 42A7          CLR.L      -(A7)
02A8: 3F06          MOVE.W     D6,-(A7)
02AA: 4EAD0B4A      JSR        2890(A5)                       ; JT[2890]
02AE: 206DDEC2      MOVEA.L    -8510(A5),A0
02B2: 426800D2      CLR.W      210(A0)
02B6: 2F07          MOVE.L     D7,-(A7)
02B8: 4EAD04DA      JSR        1242(A5)                       ; JT[1242]
02BC: 7001          MOVEQ      #1,D0
02BE: 4CEE1CF0FFC6  MOVEM.L    -58(A6),D4/D5/D6/D7/A2/A3/A4
02C4: 4E5E          UNLK       A6
02C6: 4E75          RTS        


; ======= Function at 0x02C8 =======
02C8: 4E56FFE2      LINK       A6,#-30                        ; frame=30
02CC: 48E70738      MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)        ; save
02D0: 2E2E000A      MOVE.L     10(A6),D7
02D4: 2047          MOVEA.L    D7,A0
02D6: 1010          MOVE.B     (A0),D0
02D8: 4880          EXT.W      D0
02DA: 2207          MOVE.L     D7,D1
02DC: 5281          MOVE.B     D1,(A1)
02DE: 3040          MOVEA.W    D0,A0
02E0: 42301800      CLR.B      0(A0,D1.L)
02E4: 4267          CLR.W      -(A7)
02E6: 2F07          MOVE.L     D7,-(A7)
02E8: 3F2E0008      MOVE.W     8(A6),-(A7)
02EC: 486EFFFE      PEA        -2(A6)
02F0: 4EAD0B1A      JSR        2842(A5)                       ; JT[2842]
02F4: 4A5F          TST.W      (A7)+
02F6: 6704          BEQ.S      $02FC
02F8: 4EAD01A2      JSR        418(A5)                        ; JT[418]
02FC: 42A7          CLR.L      -(A7)
02FE: 206DDEC2      MOVEA.L    -8510(A5),A0
0302: 2F2800CA      MOVE.L     202(A0),-(A7)
0306: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
030A: 2D5FFFE2      MOVE.L     (A7)+,-30(A6)
030E: 48780006      PEA        $0006.W
0312: 2F2EFFE2      MOVE.L     -30(A6),-(A7)
0316: 4EAD004A      JSR        74(A5)                         ; JT[74]
031A: 3C00          MOVE.W     D0,D6
031C: 7A00          MOVEQ      #0,D5
031E: 97CB7002      MOVE.B     A3,2(PC,D7.W)
0322: 2D40FFF6      MOVE.L     D0,-10(A6)
0326: 4267          CLR.W      -(A7)
0328: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
032C: 486EFFF6      PEA        -10(A6)
0330: 486EFFFC      PEA        -4(A6)
0334: 4EAD0B2A      JSR        2858(A5)                       ; JT[2858]
0338: 0C5FFFD9      CMPI.W     #$FFD9,(A7)+
033C: 670000D0      BEQ.W      $0410
0340: 7002          MOVEQ      #2,D0
0342: 2D40FFF6      MOVE.L     D0,-10(A6)
0346: 4267          CLR.W      -(A7)
0348: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
034C: 486EFFF6      PEA        -10(A6)
0350: 486EFFFA      PEA        -6(A6)
0354: 4EAD0B2A      JSR        2858(A5)                       ; JT[2858]
0358: BC45          MOVEA.W    D5,A6
035A: 548F          MOVE.B     A7,(A2)
035C: 6E34          BGT.S      $0392
035E: 206DDEC2      MOVEA.L    -8510(A5),A0
0362: 7001          MOVEQ      #1,D0
0364: D045          MOVEA.B    D5,A0
0366: C1FC00062068  ANDA.L     #$00062068,A0
036C: 00CA          DC.W       $00CA
036E: A024          MOVE.L     -(A4),D0
0370: 4A780220      TST.W      $0220.W
0374: 6704          BEQ.S      $037A
0376: 4EAD01A2      JSR        418(A5)                        ; JT[418]
037A: 302EFFFA      MOVE.W     -6(A6),D0
037E: 48C0          EXT.L      D0
0380: A122          MOVE.L     -(A2),-(A0)
0382: 226DDEC2      MOVEA.L    -8510(A5),A1
0386: 226900CA      MOVEA.L    202(A1),A1
038A: 2011          MOVE.L     (A1),D0
038C: 27880802      MOVE.L     A0,2(A3,D0.L)
0390: 6020          BRA.S      $03B2
0392: 206DDEC2      MOVEA.L    -8510(A5),A0
0396: 206800CA      MOVEA.L    202(A0),A0
039A: 2010          MOVE.L     (A0),D0
039C: 20730802      MOVEA.L    2(A3,D0.L),A0
03A0: 302EFFFA      MOVE.W     -6(A6),D0
03A4: 48C0          EXT.L      D0
03A6: A024          MOVE.L     -(A4),D0
03A8: 4A780220      TST.W      $0220.W
03AC: 6704          BEQ.S      $03B2
03AE: 4EAD01A2      JSR        418(A5)                        ; JT[418]
03B2: 246DDEC2      MOVEA.L    -8510(A5),A2
03B6: 45EA00CA      LEA        202(A2),A2
03BA: 2052          MOVEA.L    (A2),A0
03BC: 224B          MOVEA.L    A3,A1
03BE: D3D012AEFFFD  MOVE.B     (A0),$12AEFFFD
03C4: 2052          MOVEA.L    (A2),A0
03C6: 2010          MOVE.L     (A0),D0
03C8: 28730802      MOVEA.L    2(A3,D0.L),A4
03CC: 2F0C          MOVE.L     A4,-(A7)
03CE: 4EAD05EA      JSR        1514(A5)                       ; JT[1514]
03D2: 2440          MOVEA.L    D0,A2
03D4: 306EFFFA      MOVEA.W    -6(A6),A0
03D8: 2D48FFF6      MOVE.L     A0,-10(A6)
03DC: 4257          CLR.W      (A7)
03DE: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
03E2: 486EFFF6      PEA        -10(A6)
03E6: 2F0A          MOVE.L     A2,-(A7)
03E8: 4EAD0B2A      JSR        2858(A5)                       ; JT[2858]
03EC: 204C          MOVEA.L    A4,A0
03EE: A02A588F      MOVE.L     22671(A2),D0
03F2: 5245          MOVEA.B    D5,A1
03F4: 5C8B          MOVE.B     A3,(A6)
03F6: 6000FF28      BRA.W      $0322
03FA: 206DDEC2      MOVEA.L    -8510(A5),A0
03FE: 206800CA      MOVEA.L    202(A0),A0
0402: 7006          MOVEQ      #6,D0
0404: C1C6          ANDA.L     D6,A0
0406: 2050          MOVEA.L    (A0),A0
0408: 20700802      MOVEA.L    2(A0,D0.L),A0
040C: A023          MOVE.L     -(A3),D0
040E: 5346BA46      MOVE.B     D6,-17850(A1)
0412: 6FE6          BLE.S      $03FA
0414: 206DDEC2      MOVEA.L    -8510(A5),A0
0418: 7006          MOVEQ      #6,D0
041A: C1C5          ANDA.L     D5,A0
041C: 206800CA      MOVEA.L    202(A0),A0
0420: A024          MOVE.L     -(A4),D0
0422: 4A780220      TST.W      $0220.W
0426: 6704          BEQ.S      $042C
0428: 4EAD01A2      JSR        418(A5)                        ; JT[418]
042C: 70FF          MOVEQ      #-1,D0
042E: D045          MOVEA.B    D5,A0
0430: 3F00          MOVE.W     D0,-(A7)
0432: 4EAD0162      JSR        354(A5)                        ; JT[354]
0436: 2F2DDEC2      MOVE.L     -8510(A5),-(A7)                ; A5-8510
043A: A873206D      MOVEA.L    109(A3,D2.W),A4
043E: DEC2          MOVE.B     D2,(A7)+
0440: 48680010      PEA        16(A0)
0444: A9284EAD      MOVE.L     20141(A0),-(A4)
0448: 048A42573F2E  SUBI.L     #$42573F2E,A2
044E: FFFE          MOVE.W     ???,???
0450: 4EAD0B22      JSR        2850(A5)                       ; JT[2850]
0454: 4A5F          TST.W      (A7)+
0456: 6704          BEQ.S      $045C
0458: 4EAD01A2      JSR        418(A5)                        ; JT[418]
045C: 206DDEC2      MOVEA.L    -8510(A5),A0
0460: 426800D2      CLR.W      210(A0)
0464: 2F07          MOVE.L     D7,-(A7)
0466: 4EAD04DA      JSR        1242(A5)                       ; JT[1242]
046A: 48780121      PEA        $0121.W
046E: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
0472: 486DD88D      PEA        -10099(A5)                     ; A5-10099
0476: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
047A: 7001          MOVEQ      #1,D0
047C: 4CEE1CE0FFCA  MOVEM.L    -54(A6),D5/D6/D7/A2/A3/A4
0482: 4E5E          UNLK       A6
0484: 4E75          RTS        


; ======= Function at 0x0486 =======
0486: 4E560000      LINK       A6,#0
048A: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
048E: B1EE00086604  MOVE.W     8(A6),$6604.W
0494: 4EAD0292      JSR        658(A5)                        ; JT[658]
0498: 2F2E0008      MOVE.L     8(A6),-(A7)
049C: 4EAD0962      JSR        2402(A5)                       ; JT[2402]
04A0: 4E5E          UNLK       A6
04A2: 4E75          RTS        


; ======= Function at 0x04A4 =======
04A4: 4E560000      LINK       A6,#0
04A8: 48E70300      MOVEM.L    D6/D7,-(SP)                    ; save
04AC: 3E2E0008      MOVE.W     8(A6),D7
04B0: 0C6D0008A386  CMPI.W     #$0008,-23674(A5)
04B6: 6406          BCC.S      $04BE
04B8: 4A6DA386      TST.W      -23674(A5)
04BC: 6C04          BGE.S      $04C2
04BE: 4EAD01A2      JSR        418(A5)                        ; JT[418]
04C2: 302DA386      MOVE.W     -23674(A5),D0                  ; A5-23674
04C6: 526DA386      MOVEA.B    -23674(A5),A1
04CA: C1FC002C41ED  ANDA.L     #$002C41ED,A0
04D0: A226          MOVE.L     -(A6),D1
04D2: D088          MOVE.B     A0,(A0)
04D4: 2040          MOVEA.L    D0,A0
04D6: 7000          MOVEQ      #0,D0
04D8: 43FA0006      LEA        6(PC),A1
04DC: 48D0          DC.W       $48D0
04DE: DEF84A40      MOVE.B     $4A40.W,(A7)+
04E2: 663C          BNE.S      $0520
04E4: 3F07          MOVE.W     D7,-(A7)
04E6: 4267          CLR.W      -(A7)
04E8: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
04EC: 4EBA009E      JSR        158(PC)
04F0: 3C00          MOVE.W     D0,D6
04F2: 508F          MOVE.B     A7,(A0)
04F4: 6724          BEQ.S      $051A
04F6: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
04FA: 4EBA02B4      JSR        692(PC)
04FE: 3E87          MOVE.W     D7,(A7)
0500: 3F3C0001      MOVE.W     #$0001,-(A7)
0504: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
0508: 4EBA0082      JSR        130(PC)
050C: 3C00          MOVE.W     D0,D6
050E: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
0512: 4EBA029C      JSR        668(PC)
0516: 4FEF000E      LEA        14(A7),A7
051A: 536DA3866062  MOVE.B     -23674(A5),24674(A1)           ; A5-23674
0520: 2F2DA222      MOVE.L     -24030(A5),-(A7)               ; A5-24030
0524: 2F2DA1B6      MOVE.L     -24138(A5),-(A7)               ; A5-24138
0528: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
052C: 4A40          TST.W      D0
052E: 508F          MOVE.B     A7,(A0)
0530: 6620          BNE.S      $0552
0532: 48780022      PEA        $0022.W
0536: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
053A: 4EAD01AA      JSR        426(A5)                        ; JT[426]
053E: 486D0432      PEA        1074(A5)                       ; A5+1074
0542: 4EAD042A      JSR        1066(A5)                       ; JT[1066]
0546: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
054A: 7C01          MOVEQ      #1,D6
054C: 4FEF000C      LEA        12(A7),A7
0550: 6030          BRA.S      $0582
0552: 4A6DA386      TST.W      -23674(A5)
0556: 6E04          BGT.S      $055C
0558: 4EAD01A2      JSR        418(A5)                        ; JT[418]
055C: 2B6DA222A222  MOVE.L     -24030(A5),-24030(A5)          ; A5-24030
0562: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
0568: C1EDA386      ANDA.L     -23674(A5),A0
056C: 41EDA226      LEA        -24026(A5),A0                  ; g_common
0570: D088          MOVE.B     A0,(A0)
0572: 2040          MOVEA.L    D0,A0
0574: 7001          MOVEQ      #1,D0
0576: 4A40          TST.W      D0
0578: 6602          BNE.S      $057C
057A: 7001          MOVEQ      #1,D0
057C: 4CD8          DC.W       $4CD8
057E: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
0582: 3006          MOVE.W     D6,D0
0584: 4CDF00C0      MOVEM.L    (SP)+,D6/D7                    ; restore
0588: 4E5E          UNLK       A6
058A: 4E75          RTS        


; ======= Function at 0x058C =======
058C: 4E56FEE0      LINK       A6,#-288                       ; frame=288
0590: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0594: 286E0008      MOVEA.L    8(A6),A4
0598: 600000C2      BRA.W      $065E
059C: 1E14          MOVE.B     (A4),D7
059E: 4A07          TST.B      D7
05A0: 676C          BEQ.S      $060E
05A2: 4A2C0001      TST.B      1(A4)
05A6: 6766          BEQ.S      $060E
05A8: 4A2CFFFF      TST.B      -1(A4)
05AC: 6660          BNE.S      $060E
05AE: 47EEFFE0      LEA        -32(A6),A3
05B2: 6010          BRA.S      $05C4
05B4: 1014          MOVE.B     (A4),D0
05B6: 4880          EXT.W      D0
05B8: 3F00          MOVE.W     D0,-(A7)
05BA: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
05BE: 16C0          MOVE.B     D0,(A3)+
05C0: 548F          MOVE.B     A7,(A2)
05C2: 528C          MOVE.B     A4,(A1)
05C4: 4A14          TST.B      (A4)
05C6: 66EC          BNE.S      $05B4
05C8: 4213          CLR.B      (A3)
05CA: 486EFFE0      PEA        -32(A6)
05CE: 4EAD031A      JSR        794(A5)                        ; JT[794]
05D2: 4A80          TST.L      D0
05D4: 588F          MOVE.B     A7,(A4)
05D6: 66000082      BNE.W      $065C
05DA: 486EFFE0      PEA        -32(A6)
05DE: 4EBA0116      JSR        278(PC)
05E2: 4A40          TST.W      D0
05E4: 588F          MOVE.B     A7,(A4)
05E6: 6672          BNE.S      $065A
05E8: 3F2E000C      MOVE.W     12(A6),-(A7)
05EC: 486EFFE0      PEA        -32(A6)
05F0: 3F2E000E      MOVE.W     14(A6),-(A7)
05F4: 4EBA007E      JSR        126(PC)
05F8: 5340508F      MOVE.B     D0,20623(A1)
05FC: 6604          BNE.S      $0602
05FE: 7000          MOVEQ      #0,D0
0600: 606A          BRA.S      $066C
0602: 486EFFE0      PEA        -32(A6)
0606: 4EBA0128      JSR        296(PC)
060A: 588F          MOVE.B     A7,(A4)
060C: 604C          BRA.S      $065A
060E: 4A07          TST.B      D7
0610: 6748          BEQ.S      $065A
0612: 4A2CFFFF      TST.B      -1(A4)
0616: 6642          BNE.S      $065A
0618: 4A2C0001      TST.B      1(A4)
061C: 663C          BNE.S      $065A
061E: 4A2CFFEF      TST.B      -17(A4)
0622: 6636          BNE.S      $065A
0624: 4A2C0011      TST.B      17(A4)
0628: 6630          BNE.S      $065A
062A: 1014          MOVE.B     (A4),D0
062C: 4880          EXT.W      D0
062E: 3F00          MOVE.W     D0,-(A7)
0630: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
0634: 1D40FFE0      MOVE.B     D0,-32(A6)
0638: 422EFFE1      CLR.B      -31(A6)
063C: 4A6E000E      TST.W      14(A6)
0640: 548F          MOVE.B     A7,(A2)
0642: 6712          BEQ.S      $0656
0644: 3F2E000C      MOVE.W     12(A6),-(A7)
0648: 486EFFE0      PEA        -32(A6)
064C: 3F3C0406      MOVE.W     #$0406,-(A7)
0650: 4EBA0022      JSR        34(PC)
0654: 508F          MOVE.B     A7,(A0)
0656: 7000          MOVEQ      #0,D0
0658: 6012          BRA.S      $066C
065A: 528C          MOVE.B     A4,(A1)
065C: 206E0008      MOVEA.L    8(A6),A0
0660: 41E80121      LEA        289(A0),A0
0664: B1CC6200      MOVE.W     A4,$6200.W
0668: FF347001      MOVE.W     1(A4,D7.W),-(A7)
066C: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
0670: 4E5E          UNLK       A6
0672: 4E75          RTS        


; ======= Function at 0x0674 =======
0674: 4E56FFE0      LINK       A6,#-32                        ; frame=32
0678: 2F07          MOVE.L     D7,-(A7)
067A: 7E01          MOVEQ      #1,D7
067C: 4A6E0008      TST.W      8(A6)
0680: 676C          BEQ.S      $06EE
0682: 2F2E000A      MOVE.L     10(A6),-(A7)
0686: 2F2E000A      MOVE.L     10(A6),-(A7)
068A: 4EAD07EA      JSR        2026(A5)                       ; JT[2026]
068E: 2E80          MOVE.L     D0,(A7)
0690: 4EAD0C62      JSR        3170(A5)                       ; JT[3170]
0694: 4A6E000E      TST.W      14(A6)
0698: 508F          MOVE.B     A7,(A0)
069A: 670A          BEQ.S      $06A6
069C: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
06A0: 4EBA010E      JSR        270(PC)
06A4: 588F          MOVE.B     A7,(A4)
06A6: 3F2E0008      MOVE.W     8(A6),-(A7)
06AA: 4EAD0C6A      JSR        3178(A5)                       ; JT[3178]
06AE: 3E00          MOVE.W     D0,D7
06B0: 0C470003      CMPI.W     #$0003,D7
06B4: 548F          MOVE.B     A7,(A2)
06B6: 6626          BNE.S      $06DE
06B8: 2B6DA1B6A222  MOVE.L     -24138(A5),-24030(A5)          ; A5-24138
06BE: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
06C4: C1EDA386      ANDA.L     -23674(A5),A0
06C8: 41EDA226      LEA        -24026(A5),A0                  ; g_common
06CC: D088          MOVE.B     A0,(A0)
06CE: 2040          MOVEA.L    D0,A0
06D0: 7001          MOVEQ      #1,D0
06D2: 4A40          TST.W      D0
06D4: 6602          BNE.S      $06D8
06D6: 7001          MOVEQ      #1,D0
06D8: 4CD8          DC.W       $4CD8
06DA: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
06DE: 4A6E000E      TST.W      14(A6)
06E2: 670A          BEQ.S      $06EE
06E4: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
06E8: 4EBA00C6      JSR        198(PC)
06EC: 588F          MOVE.B     A7,(A4)
06EE: 3007          MOVE.W     D7,D0
06F0: 2E1F          MOVE.L     (A7)+,D7
06F2: 4E5E          UNLK       A6
06F4: 4E75          RTS        


; ======= Function at 0x06F6 =======
06F6: 4E560000      LINK       A6,#0
06FA: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
06FE: 7E00          MOVEQ      #0,D7
0700: 49EDF14A      LEA        -3766(A5),A4                   ; A5-3766
0704: 601A          BRA.S      $0720
0706: 2F0C          MOVE.L     A4,-(A7)
0708: 2F2E0008      MOVE.L     8(A6),-(A7)
070C: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
0710: 4A40          TST.W      D0
0712: 508F          MOVE.B     A7,(A0)
0714: 6604          BNE.S      $071A
0716: 7001          MOVEQ      #1,D0
0718: 600E          BRA.S      $0728
071A: 5247          MOVEA.B    D7,A1
071C: 49EC0010      LEA        16(A4),A4
0720: BE6DF23A      MOVEA.W    -3526(A5),A7
0724: 6DE0          BLT.S      $0706
0726: 7000          MOVEQ      #0,D0
0728: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
072C: 4E5E          UNLK       A6
072E: 4E75          RTS        


; ======= Function at 0x0730 =======
0730: 4E560000      LINK       A6,#0
0734: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0738: 0C6D000FF23A  CMPI.W     #$000F,-3526(A5)
073E: 6420          BCC.S      $0760
0740: 2F2E0008      MOVE.L     8(A6),-(A7)
0744: 302DF23A      MOVE.W     -3526(A5),D0                   ; A5-3526
0748: 526DF23A      MOVEA.B    -3526(A5),A1
074C: 48C0          EXT.L      D0
074E: E988204D      MOVE.L     A0,77(A4,D2.W)
0752: D1C04868      MOVE.B     D0,$4868.W
0756: F14A4EAD      MOVE.W     A2,20141(A0)
075A: 07F2508F      BSET       D3,-113(A2,D5.W)
075E: 6048          BRA.S      $07A8
0760: 7E00          MOVEQ      #0,D7
0762: 49EDF14A      LEA        -3766(A5),A4                   ; A5-3766
0766: 601E          BRA.S      $0786
0768: 2F0C          MOVE.L     A4,-(A7)
076A: 2007          MOVE.L     D7,D0
076C: 5240          MOVEA.B    D0,A1
076E: 48C0          EXT.L      D0
0770: E988204D      MOVE.L     A0,77(A4,D2.W)
0774: D1C04868      MOVE.B     D0,$4868.W
0778: F14A4EAD      MOVE.W     A2,20141(A0)
077C: 0DA2          BCLR       D6,-(A2)
077E: 508F          MOVE.B     A7,(A0)
0780: 5247          MOVEA.B    D7,A1
0782: 49EC0010      LEA        16(A4),A4
0786: 0C47000E      CMPI.W     #$000E,D7
078A: 65DC          BCS.S      $0768
078C: 2F2E0008      MOVE.L     8(A6),-(A7)
0790: 486DF14A      PEA        -3766(A5)                      ; A5-3766
0794: 4EAD07F2      JSR        2034(A5)                       ; JT[2034]
0798: 70FF          MOVEQ      #-1,D0
079A: D06DF23A      MOVEA.B    -3526(A5),A0
079E: B047          MOVEA.W    D7,A0
07A0: 508F          MOVE.B     A7,(A0)
07A2: 6704          BEQ.S      $07A8
07A4: 4EAD01A2      JSR        418(A5)                        ; JT[418]
07A8: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
07AC: 4E5E          UNLK       A6
07AE: 4E75          RTS        


; ======= Function at 0x07B0 =======
07B0: 4E560000      LINK       A6,#0
07B4: 48E70F38      MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)     ; save
07B8: 7C00          MOVEQ      #0,D6
07BA: 99CC603C      MOVE.B     A4,#$3C
07BE: 7A01          MOVEQ      #1,D5
07C0: DA46          MOVEA.B    D6,A5
07C2: 264C          MOVEA.L    A4,A3
07C4: D7EE00087011  MOVE.B     8(A6),17(PC,D7.W)
07CA: C1C5          ANDA.L     D5,A0
07CC: 2440          MOVEA.L    D0,A2
07CE: 601E          BRA.S      $07EE
07D0: 18335000      MOVE.B     0(A3,D5.W),D4
07D4: 204A          MOVEA.L    A2,A0
07D6: D1EE0008D0C6  MOVE.B     8(A6),$D0C6.W
07DC: 2E08          MOVE.L     A0,D7
07DE: 2047          MOVEA.L    D7,A0
07E0: 17905000      MOVE.B     (A0),0(A3,D5.W)
07E4: 2047          MOVEA.L    D7,A0
07E6: 1084          MOVE.B     D4,(A0)
07E8: 5245          MOVEA.B    D5,A1
07EA: 45EA0011      LEA        17(A2),A2
07EE: 0C450011      CMPI.W     #$0011,D5
07F2: 6DDC          BLT.S      $07D0
07F4: 5246          MOVEA.B    D6,A1
07F6: 49EC0011      LEA        17(A4),A4
07FA: 0C460011      CMPI.W     #$0011,D6
07FE: 6DBE          BLT.S      $07BE
0800: 4CDF1CF0      MOVEM.L    (SP)+,D4/D5/D6/D7/A2/A3/A4     ; restore
0804: 4E5E          UNLK       A6
0806: 4E75          RTS        
