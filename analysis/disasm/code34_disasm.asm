;======================================================================
; CODE 34 Disassembly
; File: /tmp/maven_code_34.bin
; Header: JT offset=2784, JT entries=31
; Code size: 1388 bytes
;======================================================================

0000: 206F0004      MOVEA.L    4(A7),A0
0004: 43E80001      LEA        1(A0),A1
0008: 7000          MOVEQ      #0,D0
000A: 1210          MOVE.B     (A0),D1
000C: 10C0          MOVE.B     D0,(A0)+
000E: 1001          MOVE.B     D1,D0
0010: 66F8          BNE.S      $000A
0012: 91C92008      MOVE.B     A1,$2008.W
0016: 1300          MOVE.B     D0,-(A1)
0018: 2009          MOVE.L     A1,D0
001A: 4E75          RTS        

001C: 206F0004      MOVEA.L    4(A7),A0
0020: 7000          MOVEQ      #0,D0
0022: 1010          MOVE.B     (A0),D0
0024: 6004          BRA.S      $002A
0026: 10E80001      MOVE.B     1(A0),(A0)+
002A: 51C8FFFA      DBF        D0,$0026                       ; loop
002E: 4210          CLR.B      (A0)
0030: 202F0004      MOVE.L     4(A7),D0
0034: 4E75          RTS        

0036: 4A78028E      TST.W      $028E.W
003A: 6B22          BMI.S      $005E
003C: 303C0090      MOVE.W     #$0090,D0
0040: A3462248      MOVE.L     D6,8776(A1)
0044: 303C009F      MOVE.W     #$009F,D0
0048: A746B3C8      MOVE.L     D6,-19512(A3)
004C: 6710          BEQ.S      $005E
004E: 225F          MOVEA.L    (A7)+,A1
0050: 205F          MOVEA.L    (A7)+,A0
0052: 301F          MOVE.W     (A7)+,D0
0054: 2F09          MOVE.L     A1,-(A7)
0056: A090          MOVE.L     (A0),(A0)
0058: 3F400004      MOVE.W     D0,4(A7)
005C: 4E75          RTS        

005E: 206F0004      MOVEA.L    4(A7),A0
0062: 303C0001      MOVE.W     #$0001,D0
0066: 2248          MOVEA.L    A0,A1
0068: 6006          BRA.S      $0070
006A: 0313          BTST       D1,(A3)
006C: 0B02          BTST       D5,D2
006E: 0100          BTST       D0,D0
0070: 303C0010      MOVE.W     #$0010,D0
0074: E240          MOVEA.L    D0,A1
0076: 53404258      MOVE.B     D0,16984(A1)
007A: 51C8FFFC      DBF        D0,$0078                       ; loop
007E: 32BC0002      MOVE.W     #$0002,(A1)
0082: 207802AE      MOVEA.L    $02AE.W,A0
0086: 337CFFFE0002  MOVE.W     #$FFFE,2(A1)
008C: 0C2800FF0009  CMPI.B     #$00FF,9(A0)
0092: 6742          BEQ.S      $00D6
0094: 4A280008      TST.B      8(A0)
0098: 6E20          BGT.S      $00BA
009A: 337CFFFF0002  MOVE.W     #$FFFF,2(A1)
00A0: 4A78028E      TST.W      $028E.W
00A4: 6B30          BMI.S      $00D6
00A6: 337C00010002  MOVE.W     #$0001,2(A1)
00AC: 4A780B22      TST.W      $0B22.W
00B0: 6A24          BPL.S      $00D6
00B2: 337C00020002  MOVE.W     #$0002,2(A1)
00B8: 601C          BRA.S      $00D6
00BA: 42690002      CLR.W      2(A1)
00BE: 0C2800020008  CMPI.B     #$0002,8(A0)
00C4: 6E10          BGT.S      $00D6
00C6: 6708          BEQ.S      $00D0
00C8: 337C00040002  MOVE.W     #$0004,2(A1)
00CE: 6006          BRA.S      $00D6
00D0: 337C00030002  MOVE.W     #$0003,2(A1)
00D6: 42690004      CLR.W      4(A1)
00DA: 0C380002012F  CMPI.B     #$0002,$012F.W
00E0: 6E0A          BGT.S      $00EC
00E2: 1038012F      MOVE.B     $012F.W,D0
00E6: 5240          MOVEA.B    D0,A1
00E8: 13400007      MOVE.B     D0,7(A1)
00EC: 4A78028E      TST.W      $028E.W
00F0: 6B0E          BMI.S      $0100
00F2: 083800040B22  BTST       #4,$0B22.W
00F8: 6706          BEQ.S      $0100
00FA: 137C00010008  MOVE.B     #$01,8(A1)
0100: 0C783FFF028E  CMPI.W     #$3FFF,$028E.W
0106: 6206          BHI.S      $010E
0108: 137C00010009  MOVE.B     #$01,9(A1)
010E: 1038021E      MOVE.B     $021E.W,D0
0112: 41FAFF5B      LEA        -165(PC),A0
0116: 323C0004      MOVE.W     #$0004,D1
011A: B020          MOVE.W     -(A0),D0
011C: 57C9FFFC      DBEQ       D1,$011A                       ; loop
0120: 5241          MOVEA.B    D1,A1
0122: 3341000A      MOVE.W     D1,10(A1)
0126: 4A380291      TST.B      $0291.W
012A: 6B18          BMI.S      $0144
012C: 123801FB      MOVE.B     $01FB.W,D1
0130: 0201000F      ANDI.B     #$000F,D1
0134: 0C010001      CMPI.B     #$0001,D1
0138: 660A          BNE.S      $0144
013A: 207802DC      MOVEA.L    $02DC.W,A0
013E: 13680007000D  MOVE.B     7(A0),13(A1)
0144: 33780210000E  MOVE.W     $0210.W,14(A1)
014A: 4A7803F6      TST.W      $03F6.W
014E: 6D44          BLT.S      $0194
0150: 4269000E      CLR.W      14(A1)
0154: 323C003C      MOVE.W     #$003C,D1
0158: 4267          CLR.W      -(A7)
015A: 51C9FFFC      DBF        D1,$0158                       ; loop
015E: 204F          MOVEA.L    A7,A0
0160: 31780A580018  MOVE.W     $0A58.W,24(A0)
0166: 7008          MOVEQ      #8,D0
0168: A260          MOVEA.L    -(A0),A1
016A: 6624          BNE.S      $0190
016C: 316800340016  MOVE.W     52(A0),22(A0)
0172: A207          MOVE.L     D7,D1
0174: 661A          BNE.S      $0190
0176: 2168005A0030  MOVE.L     90(A0),48(A0)
017C: 217C4552494B001C  MOVE.L     #$4552494B,28(A0)
0184: 7001          MOVEQ      #1,D0
0186: A260          MOVEA.L    -(A0),A1
0188: 6606          BNE.S      $0190
018A: 33680016000E  MOVE.W     22(A0),14(A1)
0190: 4FEF007A      LEA        122(A7),A7
0194: 2049          MOVEA.L    A1,A0
0196: 225F          MOVEA.L    (A7)+,A1
0198: 5C4F          MOVEA.B    A7,A6
019A: 3EBCEA84      MOVE.W     #$EA84,(A7)
019E: 4ED1          JMP        (A1)
01A0: 225F          MOVEA.L    (A7)+,A1
01A2: 205F          MOVEA.L    (A7)+,A0
01A4: A021          MOVE.L     -(A1),D0
01A6: 2E80          MOVE.L     D0,(A7)
01A8: 6A02          BPL.S      $01AC
01AA: 4297          CLR.L      (A7)
01AC: 4ED1          JMP        (A1)
01AE: 225F          MOVEA.L    (A7)+,A1
01B0: 205F          MOVEA.L    (A7)+,A0
01B2: A025          MOVE.L     -(A5),D0
01B4: 2E80          MOVE.L     D0,(A7)
01B6: 6A02          BPL.S      $01BA
01B8: 4297          CLR.L      (A7)
01BA: 4ED1          JMP        (A1)
01BC: 225F          MOVEA.L    (A7)+,A1
01BE: 101F          MOVE.B     (A7)+,D0
01C0: 205F          MOVEA.L    (A7)+,A0
01C2: 6604          BNE.S      $01C8
01C4: A007          MOVE.L     D7,D0
01C6: 6002          BRA.S      $01CA
01C8: A407          MOVE.L     D7,D2
01CA: 3E80          MOVE.W     D0,(A7)
01CC: 4ED1          JMP        (A1)

; ======= Function at 0x01CE =======
01CE: 4E56FFCE      LINK       A6,#-50                        ; frame=50
01D2: 204F          MOVEA.L    A7,A0
01D4: 216E000E0012  MOVE.L     14(A6),18(A0)
01DA: 316E000C0016  MOVE.W     12(A6),22(A0)
01E0: 4228001A      CLR.B      26(A0)
01E4: 4228001B      CLR.B      27(A0)
01E8: 42A8001C      CLR.L      28(A0)
01EC: 701A          MOVEQ      #26,D0
01EE: A060          MOVEA.L    -(A0),A0
01F0: 0C40FFCE      CMPI.W     #$FFCE,D0
01F4: 6602          BNE.S      $01F8
01F6: A000          MOVE.L     D0,D0
01F8: 226E0008      MOVEA.L    8(A6),A1
01FC: 32A80018      MOVE.W     24(A0),(A1)
0200: 3D400012      MOVE.W     D0,18(A6)
0204: 4E5E          UNLK       A6
0206: 205F          MOVEA.L    (A7)+,A0
0208: 4FEF000A      LEA        10(A7),A7
020C: 4ED0          JMP        (A0)

; ======= Function at 0x020E =======
020E: 4E56FFCE      LINK       A6,#-50                        ; frame=50
0212: 204F          MOVEA.L    A7,A0
0214: 316E00080018  MOVE.W     8(A6),24(A0)
021A: A001          MOVE.L     D1,D0
021C: 3D40000A      MOVE.W     D0,10(A6)
0220: 4E5E          UNLK       A6
0222: 205F          MOVEA.L    (A7)+,A0
0224: 548F          MOVE.B     A7,(A2)
0226: 4ED0          JMP        (A0)
0228: 51C1          SF         D1
022A: 6002          BRA.S      $022E
022C: 50C1          ST         D1

; ======= Function at 0x022E =======
022E: 4E56FFCE      LINK       A6,#-50                        ; frame=50
0232: 204F          MOVEA.L    A7,A0
0234: 216E00080020  MOVE.L     8(A6),32(A0)
023A: 316E00100018  MOVE.W     16(A6),24(A0)
0240: 226E000C      MOVEA.L    12(A6),A1
0244: 21510024      MOVE.L     (A1),36(A0)
0248: 4268002C      CLR.W      44(A0)
024C: 42A8002E      CLR.L      46(A0)
0250: 4A01          TST.B      D1
0252: 6604          BNE.S      $0258
0254: A002          MOVE.L     D2,D0
0256: 6002          BRA.S      $025A
0258: A003          MOVE.L     D3,D0
025A: 3D400012      MOVE.W     D0,18(A6)
025E: 226E000C      MOVEA.L    12(A6),A1
0262: 22A80028      MOVE.L     40(A0),(A1)
0266: 4E5E          UNLK       A6
0268: 225F          MOVEA.L    (A7)+,A1
026A: 4FEF000A      LEA        10(A7),A7
026E: 4ED1          JMP        (A1)

; ======= Function at 0x0270 =======
0270: 4E56FFB0      LINK       A6,#-80                        ; frame=80
0274: 204F          MOVEA.L    A7,A0
0276: 216E000E0012  MOVE.L     14(A6),18(A0)
027C: 316E000C0016  MOVE.W     12(A6),22(A0)
0282: 4228001A      CLR.B      26(A0)
0286: 4268001C      CLR.W      28(A0)
028A: A00C          MOVE.L     A4,D0
028C: 3D400012      MOVE.W     D0,18(A6)
0290: 41E80020      LEA        32(A0),A0
0294: 226E0008      MOVEA.L    8(A6),A1
0298: 7010          MOVEQ      #16,D0
029A: A02E4E5E      MOVE.L     20062(A6),D0
029E: 225F          MOVEA.L    (A7)+,A1
02A0: 4FEF000A      LEA        10(A7),A7
02A4: 4ED1          JMP        (A1)

; ======= Function at 0x02A6 =======
02A6: 4E56FFC0      LINK       A6,#-64                        ; frame=64
02AA: 204F          MOVEA.L    A7,A0
02AC: 216E000C0012  MOVE.L     12(A6),18(A0)
02B2: A014          MOVE.L     (A4),D0
02B4: 3D400010      MOVE.W     D0,16(A6)
02B8: 226E0008      MOVEA.L    8(A6),A1
02BC: 32A80016      MOVE.W     22(A0),(A1)
02C0: 4E5E          UNLK       A6
02C2: 225F          MOVEA.L    (A7)+,A1
02C4: 508F          MOVE.B     A7,(A0)
02C6: 4ED1          JMP        (A1)

; ======= Function at 0x02C8 =======
02C8: 4E56FFC0      LINK       A6,#-64                        ; frame=64
02CC: 204F          MOVEA.L    A7,A0
02CE: 316E00080016  MOVE.W     8(A6),22(A0)
02D4: 216E000A0012  MOVE.L     10(A6),18(A0)
02DA: A013          MOVE.L     (A3),D0
02DC: 3D40000E      MOVE.W     D0,14(A6)
02E0: 4E5E          UNLK       A6
02E2: 225F          MOVEA.L    (A7)+,A1
02E4: 5C8F          MOVE.B     A7,(A6)
02E6: 4ED1          JMP        (A1)

; ======= Function at 0x02E8 =======
02E8: 4E56FFB0      LINK       A6,#-80                        ; frame=80
02EC: 204F          MOVEA.L    A7,A0
02EE: 216E00120012  MOVE.L     18(A6),18(A0)
02F4: 316E00100016  MOVE.W     16(A6),22(A0)
02FA: 4228001A      CLR.B      26(A0)
02FE: A008          MOVE.L     A0,D0
0300: 6616          BNE.S      $0318
0302: 4268001C      CLR.W      28(A0)
0306: A00C          MOVE.L     A4,D0
0308: 660E          BNE.S      $0318
030A: 43E80020      LEA        32(A0),A1
030E: 22EE0008      MOVE.L     8(A6),(A1)+
0312: 22AE000C      MOVE.L     12(A6),(A1)
0316: A00D          MOVE.L     A5,D0
0318: 3D400016      MOVE.W     D0,22(A6)
031C: 4E5E          UNLK       A6
031E: 225F          MOVEA.L    (A7)+,A1
0320: 4FEF000E      LEA        14(A7),A7
0324: 4ED1          JMP        (A1)

; ======= Function at 0x0326 =======
0326: 4E56FFB0      LINK       A6,#-80                        ; frame=80
032A: 204F          MOVEA.L    A7,A0
032C: 216E000E0012  MOVE.L     14(A6),18(A0)
0332: 316E000C0016  MOVE.W     12(A6),22(A0)
0338: 4228001A      CLR.B      26(A0)
033C: 4268001C      CLR.W      28(A0)
0340: A00C          MOVE.L     A4,D0
0342: 43E80020      LEA        32(A0),A1
0346: 206E0008      MOVEA.L    8(A6),A0
034A: 7010          MOVEQ      #16,D0
034C: A02E204F      MOVE.L     8271(A6),D0
0350: A00D          MOVE.L     A5,D0
0352: 3D400012      MOVE.W     D0,18(A6)
0356: 4E5E          UNLK       A6
0358: 225F          MOVEA.L    (A7)+,A1
035A: 4FEF000A      LEA        10(A7),A7
035E: 4ED1          JMP        (A1)

; ======= Function at 0x0360 =======
0360: 4E56FFCE      LINK       A6,#-50                        ; frame=50
0364: 204F          MOVEA.L    A7,A0
0366: 316E000C0018  MOVE.W     12(A6),24(A0)
036C: A011          MOVE.L     (A1),D0
036E: 3D40000E      MOVE.W     D0,14(A6)
0372: 226E0008      MOVEA.L    8(A6),A1
0376: 22A8001C      MOVE.L     28(A0),(A1)
037A: 4E5E          UNLK       A6
037C: 225F          MOVEA.L    (A7)+,A1
037E: 5C8F          MOVE.B     A7,(A6)
0380: 4ED1          JMP        (A1)

; ======= Function at 0x0382 =======
0382: 4E56FFCE      LINK       A6,#-50                        ; frame=50
0386: 204F          MOVEA.L    A7,A0
0388: 316E000C0018  MOVE.W     12(A6),24(A0)
038E: 216E0008001C  MOVE.L     8(A6),28(A0)
0394: A012          MOVE.L     (A2),D0
0396: 3D40000E      MOVE.W     D0,14(A6)
039A: 4E5E          UNLK       A6
039C: 225F          MOVEA.L    (A7)+,A1
039E: 5C8F          MOVE.B     A7,(A6)
03A0: 4ED1          JMP        (A1)
03A2: 225F          MOVEA.L    (A7)+,A1
03A4: 101F          MOVE.B     (A7)+,D0
03A6: 205F          MOVEA.L    (A7)+,A0
03A8: 6606          BNE.S      $03B0
03AA: 7007          MOVEQ      #7,D0
03AC: A260          MOVEA.L    -(A0),A1
03AE: 6004          BRA.S      $03B4
03B0: 7007          MOVEQ      #7,D0
03B2: A660          MOVEA.L    -(A0),A3
03B4: 3E80          MOVE.W     D0,(A7)
03B6: 4ED1          JMP        (A1)
03B8: 225F          MOVEA.L    (A7)+,A1
03BA: 101F          MOVE.B     (A7)+,D0
03BC: 205F          MOVEA.L    (A7)+,A0
03BE: 6606          BNE.S      $03C6
03C0: 7009          MOVEQ      #9,D0
03C2: A260          MOVEA.L    -(A0),A1
03C4: 6004          BRA.S      $03CA
03C6: 7009          MOVEQ      #9,D0
03C8: A660          MOVEA.L    -(A0),A3
03CA: 3E80          MOVE.W     D0,(A7)
03CC: 4ED1          JMP        (A1)
03CE: 225F          MOVEA.L    (A7)+,A1
03D0: 101F          MOVE.B     (A7)+,D0
03D2: 205F          MOVEA.L    (A7)+,A0
03D4: 6604          BNE.S      $03DA
03D6: A20C          MOVE.L     A4,D1
03D8: 6002          BRA.S      $03DC
03DA: A60C          MOVE.L     A4,D3
03DC: 3E80          MOVE.W     D0,(A7)
03DE: 4ED1          JMP        (A1)
03E0: 226F0004      MOVEA.L    4(A7),A1
03E4: 4251          CLR.W      (A1)
03E6: 20780AEC      MOVEA.L    $0AEC.W,A0
03EA: A025          MOVE.L     -(A5),D0
03EC: 4A80          TST.L      D0
03EE: 6F0E          BLE.S      $03FE
03F0: 2050          MOVEA.L    (A0),A0
03F2: 226F0008      MOVEA.L    8(A7),A1
03F6: 3298          MOVE.W     (A0)+,(A1)
03F8: 226F0004      MOVEA.L    4(A7),A1
03FC: 3290          MOVE.W     (A0),(A1)
03FE: 205F          MOVEA.L    (A7)+,A0
0400: 504F          MOVEA.B    A7,A0
0402: 4ED0          JMP        (A0)
0404: 48E70030      MOVEM.L    A2/A3,-(SP)                    ; save
0408: 226F000C      MOVEA.L    12(A7),A1
040C: 42A90002      CLR.L      2(A1)
0410: 20780AEC      MOVEA.L    $0AEC.W,A0
0414: A025          MOVE.L     -(A5),D0
0416: 4A80          TST.L      D0
0418: 6F26          BLE.S      $0440
041A: 2450          MOVEA.L    (A0),A2
041C: 544A          MOVEA.B    A2,A2
041E: 322F0010      MOVE.W     16(A7),D1
0422: B25A          MOVEA.W    (A2)+,A1
0424: 6E1A          BGT.S      $0440
0426: 53416D16      MOVE.B     D1,27926(A1)
042A: 204A          MOVEA.L    A2,A0
042C: 7002          MOVEQ      #2,D0
042E: D0280008      MOVE.B     8(A0),D0
0432: 0240FFFE      ANDI.W     #$FFFE,D0
0436: 5040          MOVEA.B    D0,A0
0438: D4C0          MOVE.B     D0,(A2)+
043A: A02E5341      MOVE.L     21313(A6),D0
043E: 60E8          BRA.S      $0428
0440: 4CDF0C00      MOVEM.L    (SP)+,A2/A3                    ; restore
0444: 205F          MOVEA.L    (A7)+,A0
0446: 5C4F          MOVEA.B    A7,A6
0448: 4ED0          JMP        (A0)
044A: 20780AEC      MOVEA.L    $0AEC.W,A0
044E: A025          MOVE.L     -(A5),D0
0450: 4A80          TST.L      D0
0452: 6F28          BLE.S      $047C
0454: 2050          MOVEA.L    (A0),A0
0456: 5448          MOVEA.B    A0,A2
0458: 322F0004      MOVE.W     4(A7),D1
045C: B258          MOVEA.W    (A0)+,A1
045E: 6E1C          BGT.S      $047C
0460: 53416D18      MOVE.B     D1,27928(A1)
0464: 6712          BEQ.S      $0478
0466: 7002          MOVEQ      #2,D0
0468: D0280008      MOVE.B     8(A0),D0
046C: 0240FFFE      ANDI.W     #$FFFE,D0
0470: 5040          MOVEA.B    D0,A0
0472: D0C0          MOVE.B     D0,(A0)+
0474: 534160EA      MOVE.B     D1,24810(A1)
0478: 42A80002      CLR.L      2(A0)
047C: 205F          MOVEA.L    (A7)+,A0
047E: 544F          MOVEA.B    A7,A2
0480: 4ED0          JMP        (A0)
0482: 206F0004      MOVEA.L    4(A7),A0
0486: 2050          MOVEA.L    (A0),A0
0488: A9E1226F0004  MOVE.L     -(A1),#$226F0004
048E: 2288          MOVE.L     A0,(A1)
0490: 3F400008      MOVE.W     D0,8(A7)
0494: 2E9F          MOVE.L     (A7)+,(A7)
0496: 4E75          RTS        

0498: 6118          BSR.S      $04B2
049A: A9DB2E9F4E75  MOVE.L     (A3)+,#$2E9F4E75
04A0: 6110          BSR.S      $04B2
04A2: A9D660F6610A  MOVE.L     (A6),#$60F6610A
04A8: A9D560F06104  MOVE.L     (A5),#$60F06104
04AE: A9D760EA206F  MOVE.L     (A7),#$60EA206F
04B4: 00084A68      ORI.B      #$4A68,A0
04B8: 00A46B08225F  ORI.L      #$6B08225F,-(A4)
04BE: 2F2800A0      MOVE.L     160(A0),-(A7)
04C2: 4ED1          JMP        (A1)
04C4: 4CDF0301      MOVEM.L    (SP)+,D0/A0/A1                 ; restore
04C8: 4ED0          JMP        (A0)
04CA: 42A7          CLR.L      -(A7)
04CC: 594F42A7      MOVE.B     A7,17063(A4)
04D0: 2F3C54455854  MOVE.L     #$54455854,-(A7)
04D6: 486F000C      PEA        12(A7)
04DA: A9FD201F584F  MOVE.L     ???,#$201F584F
04E0: 6B28          BMI.S      $050A
04E2: 0C8000007D01  CMPI.L     #$00007D01,D0
04E8: 6506          BCS.S      $04F0
04EA: 303CFE0B      MOVE.W     #$FE0B,D0
04EE: 601A          BRA.S      $050A
04F0: 42A7          CLR.L      -(A7)
04F2: 594F2F38      MOVE.B     A7,12088(A4)
04F6: 0AB42F3C54455854  EORI.L     #$2F3C5445,84(A4,D5.L)
04FE: 486F000C      PEA        12(A7)
0502: A9FD201F584F  MOVE.L     ???,#$201F584F
0508: 6A06          BPL.S      $0510
050A: 42780AB0      CLR.W      $0AB0.W
050E: 600A          BRA.S      $051A
0510: 426F0004      CLR.W      4(A7)
0514: 31C00AB0      MOVE.W     D0,$0AB0.W
0518: 7000          MOVEQ      #0,D0
051A: 3F400004      MOVE.W     D0,4(A7)
051E: 4E75          RTS        

0520: 20780AB4      MOVEA.L    $0AB4.W,A0
0524: A029594F      MOVE.L     22863(A1),D0
0528: 3F380AB0      MOVE.W     $0AB0.W,-(A7)
052C: 4267          CLR.W      -(A7)
052E: 2F3C54455854  MOVE.L     #$54455854,-(A7)
0534: 2F10          MOVE.L     (A0),-(A7)
0536: A9FE544F3F5F  MOVE.L     ???,#$544F3F5F
053C: 00042078      ORI.B      #$2078,D4
0540: 0AB4A02A4E75201F  EORI.L     #$A02A4E75,31(A4,D2.W)
0548: 225F          MOVEA.L    (A7)+,A1
054A: 2B5F0018      MOVE.L     (A7)+,24(A5)
054E: 2251          MOVEA.L    (A1),A1
0550: 41FA000A      LEA        10(PC),A0
0554: 23480026      MOVE.L     A0,38(A1)
0558: 2040          MOVEA.L    D0,A0
055A: 4ED0          JMP        (A0)
055C: 4227          CLR.B      -(A7)
055E: 2F08          MOVE.L     A0,-(A7)
0560: 3F00          MOVE.W     D0,-(A7)
0562: 206D0018      MOVEA.L    24(A5),A0
0566: 4E90          JSR        (A0)
0568: 4A1F          TST.B      (A7)+
056A: 4E75          RTS        
