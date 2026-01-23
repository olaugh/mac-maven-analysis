;======================================================================
; CODE 48 Disassembly
; File: /tmp/maven_code_48.bin
; Header: JT offset=3192, JT entries=15
; Code size: 1092 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 6006          BRA.S      $000C
0006: 3F3C0001      MOVE.W     #$0001,-(A7)
000A: A9C8302E0008  MOVE.L     A0,#$302E0008
0010: 536E00084A40  MOVE.B     8(A6),19008(A1)
0016: 66EE          BNE.S      $0006
0018: 4E5E          UNLK       A6
001A: 4E75          RTS        


; ======= Function at 0x001C =======
001C: 4E560000      LINK       A6,#0
0020: 2F2E0008      MOVE.L     8(A6),-(A7)
0024: 4EAD0BC2      JSR        3010(A5)                       ; JT[3010]
0028: 3B7C0001F276  MOVE.W     #$0001,-3466(A5)
002E: 4E5E          UNLK       A6
0030: 4E75          RTS        


; ======= Function at 0x0032 =======
0032: 4E560000      LINK       A6,#0
0036: 2F2E0008      MOVE.L     8(A6),-(A7)
003A: 4EAD0BBA      JSR        3002(A5)                       ; JT[3002]
003E: 3B7C0001F276  MOVE.W     #$0001,-3466(A5)
0044: 4E5E          UNLK       A6
0046: 4E75          RTS        


; ======= Function at 0x0048 =======
0048: 4E560000      LINK       A6,#0
004C: 2F2E0008      MOVE.L     8(A6),-(A7)
0050: 4EAD0BAA      JSR        2986(A5)                       ; JT[2986]
0054: 4E5E          UNLK       A6
0056: 4E75          RTS        


; ======= Function at 0x0058 =======
0058: 4E560000      LINK       A6,#0
005C: 2F2E0008      MOVE.L     8(A6),-(A7)
0060: 4EAD0BB2      JSR        2994(A5)                       ; JT[2994]
0064: 4E5E          UNLK       A6
0066: 4E75          RTS        


; ======= Function at 0x0068 =======
0068: 4E560000      LINK       A6,#0
006C: 206E0008      MOVEA.L    8(A6),A0
0070: 2F2800A0      MOVE.L     160(A0),-(A7)
0074: 4EAD07B2      JSR        1970(A5)                       ; JT[1970]
0078: 4E5E          UNLK       A6
007A: 4E75          RTS        


; ======= Function at 0x007C =======
007C: 4E560000      LINK       A6,#0
0080: 206E0008      MOVEA.L    8(A6),A0
0084: 0C68FFFF00A4  CMPI.W     #$FFFF,164(A0)
008A: 670A          BEQ.S      $0096
008C: 206E0008      MOVEA.L    8(A6),A0
0090: 2F2800A0      MOVE.L     160(A0),-(A7)
0094: A9DA70004E5E  MOVE.L     (A2)+,#$70004E5E
009A: 4E75          RTS        


; ======= Function at 0x009C =======
009C: 4E560000      LINK       A6,#0
00A0: 206E0008      MOVEA.L    8(A6),A0
00A4: 0C68FFFF00A4  CMPI.W     #$FFFF,164(A0)
00AA: 670A          BEQ.S      $00B6
00AC: 206E0008      MOVEA.L    8(A6),A0
00B0: 2F2800A0      MOVE.L     160(A0),-(A7)
00B4: A9D84E5E4E75  MOVE.L     (A0)+,#$4E5E4E75

; ======= Function at 0x00BA =======
00BA: 4E560000      LINK       A6,#0
00BE: 206E0008      MOVEA.L    8(A6),A0
00C2: 0C68FFFF00A4  CMPI.W     #$FFFF,164(A0)
00C8: 670A          BEQ.S      $00D4
00CA: 206E0008      MOVEA.L    8(A6),A0
00CE: 2F2800A0      MOVE.L     160(A0),-(A7)
00D2: A9D94E5E4E75  MOVE.L     (A1)+,#$4E5E4E75

; ======= Function at 0x00D8 =======
00D8: 4E56FFEE      LINK       A6,#-18                        ; frame=18
00DC: 2F0C          MOVE.L     A4,-(A7)
00DE: 286E0008      MOVEA.L    8(A6),A4
00E2: 2F0C          MOVE.L     A4,-(A7)
00E4: 2F2C0018      MOVE.L     24(A4),-(A7)
00E8: A9784A6C00A8  MOVE.L     $4A6C.W,168(A4)
00EE: 673E          BEQ.S      $012E
00F0: 2F0C          MOVE.L     A4,-(A7)
00F2: 3F2C00A8      MOVE.W     168(A4),-(A7)
00F6: 486EFFFE      PEA        -2(A6)
00FA: 486EFFFA      PEA        -6(A6)
00FE: 486EFFF2      PEA        -14(A6)
0102: A98D0C6E      MOVE.L     A5,110(A4,D0.L*4)
0106: 0004FFFE      ORI.B      #$FFFE,D4
010A: 6622          BNE.S      $012E
010C: 2F3C00030003  MOVE.L     #$00030003,-(A7)
0112: A89B          MOVE.L     (A3)+,(A4)
0114: 486EFFF2      PEA        -14(A6)
0118: 2F3CFFFCFFFC  MOVE.L     #$FFFCFFFC,-(A7)
011E: A8A9486E      MOVE.L     18542(A1),(A4)
0122: FFF22F3C      MOVE.W     60(A2,D2.L*8),???
0126: 00100010      ORI.B      #$0010,(A0)
012A: A8B0A89E      MOVE.L     -98(A0,A2.L),(A4)
012E: 285F          MOVEA.L    (A7)+,A4
0130: 4E5E          UNLK       A6
0132: 4E75          RTS        


; ======= Function at 0x0134 =======
0134: 4E56FF00      LINK       A6,#-256                       ; frame=256
0138: 486EFF00      PEA        -256(A6)
013C: 3F2E000C      MOVE.W     12(A6),-(A7)
0140: 2F2E0008      MOVE.L     8(A6),-(A7)
0144: 4EAD0642      JSR        1602(A5)                       ; JT[1602]
0148: 2EAE000E      MOVE.L     14(A6),(A7)
014C: 486EFF00      PEA        -256(A6)
0150: 486EFF00      PEA        -256(A6)
0154: 4EAD0632      JSR        1586(A5)                       ; JT[1586]
0158: 4A40          TST.W      D0
015A: 4FEF0012      LEA        18(A7),A7
015E: 671A          BEQ.S      $017A
0160: 3F3C000F      MOVE.W     #$000F,-(A7)
0164: A9C8486EFF00  MOVE.L     A0,#$486EFF00
016A: 3F2E000C      MOVE.W     12(A6),-(A7)
016E: 2F2E0008      MOVE.L     8(A6),-(A7)
0172: 4EBA0132      JSR        306(PC)
0176: 4FEF000A      LEA        10(A7),A7
017A: 4E5E          UNLK       A6
017C: 4E75          RTS        


; ======= Function at 0x017E =======
017E: 4E560000      LINK       A6,#0
0182: 206E0008      MOVEA.L    8(A6),A0
0186: 70FF          MOVEQ      #-1,D0
0188: D06E000C      MOVEA.B    12(A6),A0
018C: B06800A4      MOVEA.W    164(A0),A0
0190: 670C          BEQ.S      $019E
0192: 3F2E000C      MOVE.W     12(A6),-(A7)
0196: 2F2E0008      MOVE.L     8(A6),-(A7)
019A: 4EBA0006      JSR        6(PC)
019E: 4E5E          UNLK       A6
01A0: 4E75          RTS        


; ======= Function at 0x01A2 =======
01A2: 4E56FFEC      LINK       A6,#-20                        ; frame=20
01A6: 2F0C          MOVE.L     A4,-(A7)
01A8: 286E0008      MOVEA.L    8(A6),A4
01AC: 2F0C          MOVE.L     A4,-(A7)
01AE: 3F2E000C      MOVE.W     12(A6),-(A7)
01B2: 486EFFFE      PEA        -2(A6)
01B6: 486EFFFA      PEA        -6(A6)
01BA: 486EFFF2      PEA        -14(A6)
01BE: A98D2F2C      MOVE.L     A5,44(A4,D2.L*8)
01C2: 00A0A9D9206C  ORI.L      #$A9D9206C,-(A0)
01C8: 00A02050216E  ORI.L      #$2050216E,-(A0)
01CE: FFFA003E      MOVE.W     62(PC),???
01D2: 42A7          CLR.L      -(A7)
01D4: 2F2EFFFA      MOVE.L     -6(A6),-(A7)
01D8: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
01DC: 201F          MOVE.L     (A7)+,D0
01DE: 206C00A0      MOVEA.L    160(A4),A0
01E2: 2050          MOVEA.L    (A0),A0
01E4: 3140003C      MOVE.W     D0,60(A0)
01E8: 206C00A0      MOVEA.L    160(A4),A0
01EC: 2050          MOVEA.L    (A0),A0
01EE: 20AEFFF2      MOVE.L     -14(A6),(A0)
01F2: 216EFFF60004  MOVE.L     -10(A6),4(A0)
01F8: 226C00A0      MOVEA.L    160(A4),A1
01FC: 2251          MOVEA.L    (A1),A1
01FE: 23500008      MOVE.L     (A0),8(A1)
0202: 23680004000C  MOVE.L     4(A0),12(A1)
0208: 2F2C00A0      MOVE.L     160(A4),-(A7)
020C: A9D02F2C00A0  MOVE.L     (A0),#$2F2C00A0
0212: A9D82F0C3F2E  MOVE.L     (A0)+,#$2F0C3F2E
0218: 000C486E      ORI.B      #$486E,A4
021C: FFFE          MOVE.W     ???,???
021E: 486EFFFA      PEA        -6(A6)
0222: 486EFFF2      PEA        -14(A6)
0226: A98D486E      MOVE.L     A5,110(A4,D4.L)
022A: FFEEA874      MOVE.W     -22412(A6),???
022E: 2F0C          MOVE.L     A4,-(A7)
0230: A873486E      MOVEA.L    110(A3,D4.L),A4
0234: FFF2A8A3      MOVE.W     -93(A2,A2.L),???
0238: 486EFFF2      PEA        -14(A6)
023C: 2F2C00A0      MOVE.L     160(A4),-(A7)
0240: A9D32F2EFFEE  MOVE.L     (A3),#$2F2EFFEE
0246: A87370FF      MOVEA.L    -1(A3,D7.W),A4
024A: D06E000C      MOVEA.B    12(A6),A0
024E: 394000A4      MOVE.W     D0,164(A4)
0252: 285F          MOVEA.L    (A7)+,A4
0254: 4E5E          UNLK       A6
0256: 4E75          RTS        


; ======= Function at 0x0258 =======
0258: 4E568300      LINK       A6,#-32000                     ; frame=32000
025C: 2F0C          MOVE.L     A4,-(A7)
025E: 286E000E      MOVEA.L    14(A6),A4
0262: 200C          MOVE.L     A4,D0
0264: 6606          BNE.S      $026C
0266: 422E8300      CLR.B      -32000(A6)
026A: 6022          BRA.S      $028E
026C: 42A7          CLR.L      -(A7)
026E: 2F0C          MOVE.L     A4,-(A7)
0270: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0274: 43EE8300      LEA        -32000(A6),A1
0278: 201F          MOVE.L     (A7)+,D0
027A: 2054          MOVEA.L    (A4),A0
027C: A02E42A7      MOVE.L     17063(A6),D0
0280: 2F0C          MOVE.L     A4,-(A7)
0282: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
0286: 204E          MOVEA.L    A6,A0
0288: D1DF4228      MOVE.B     (A7)+,$4228.W
028C: 8300          OR.B       D1,D0
028E: 486E8300      PEA        -32000(A6)
0292: 3F2E000C      MOVE.W     12(A6),-(A7)
0296: 2F2E0008      MOVE.L     8(A6),-(A7)
029A: 4EBA000A      JSR        10(PC)
029E: 286E82FC      MOVEA.L    -32004(A6),A4
02A2: 4E5E          UNLK       A6
02A4: 4E75          RTS        


; ======= Function at 0x02A6 =======
02A6: 4E560000      LINK       A6,#0
02AA: 2F2E000E      MOVE.L     14(A6),-(A7)
02AE: 3F2E000C      MOVE.W     12(A6),-(A7)
02B2: 2F2E0008      MOVE.L     8(A6),-(A7)
02B6: 4EAD063A      JSR        1594(A5)                       ; JT[1594]
02BA: 3EAE000C      MOVE.W     12(A6),(A7)
02BE: 2F2E0008      MOVE.L     8(A6),-(A7)
02C2: 4EBAFEDE      JSR        -290(PC)
02C6: 4E5E          UNLK       A6
02C8: 4E75          RTS        


; ======= Function at 0x02CA =======
02CA: 4E560000      LINK       A6,#0
02CE: 3F2E000C      MOVE.W     12(A6),-(A7)
02D2: 2F2E0008      MOVE.L     8(A6),-(A7)
02D6: 4EBAFEA6      JSR        -346(PC)
02DA: 4297          CLR.L      (A7)
02DC: 2F3C0BEBC200  MOVE.L     #$0BEBC200,-(A7)
02E2: 206E0008      MOVEA.L    8(A6),A0
02E6: 2F2800A0      MOVE.L     160(A0),-(A7)
02EA: A9D14E5E4E75  MOVE.L     (A1),#$4E5E4E75

; ======= Function at 0x02F0 =======
02F0: 4E56FFEA      LINK       A6,#-22                        ; frame=22
02F4: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
02F8: 286E0008      MOVEA.L    8(A6),A4
02FC: 486EFFEA      PEA        -22(A6)
0300: A8742F0C      MOVEA.L    12(A4,D2.L*8),A4
0304: A873206E      MOVEA.L    110(A3,D2.W),A4
0308: 000C2D68      ORI.B      #$2D68,A4
030C: 000AFFEE      ORI.B      #$FFEE,A2
0310: 486EFFEE      PEA        -18(A6)
0314: A8714267      MOVEA.L    103(A1,D4.W*2),A4
0318: 2F0C          MOVE.L     A4,-(A7)
031A: 2F2EFFEE      MOVE.L     -18(A6),-(A7)
031E: A9843E1F      MOVE.L     D4,31(A4,D3.L*8)
0322: 0C47FFFF      CMPI.W     #$FFFF,D7
0326: 673C          BEQ.S      $0364
0328: 5247          MOVEA.B    D7,A1
032A: 2F0C          MOVE.L     A4,-(A7)
032C: 3F07          MOVE.W     D7,-(A7)
032E: 486EFFFE      PEA        -2(A6)
0332: 486EFFFA      PEA        -6(A6)
0336: 486EFFF2      PEA        -14(A6)
033A: A98D082E      MOVE.L     A5,46(A4,D0.L)
033E: 0004FFFF      ORI.B      #$FFFF,D4
0342: 6720          BEQ.S      $0364
0344: 3F07          MOVE.W     D7,-(A7)
0346: 2F0C          MOVE.L     A4,-(A7)
0348: 4EBAFE34      JSR        -460(PC)
034C: 2EAEFFEE      MOVE.L     -18(A6),(A7)
0350: 206E000C      MOVEA.L    12(A6),A0
0354: 7000          MOVEQ      #0,D0
0356: C028000F      AND.B      15(A0),D0
035A: 1F00          MOVE.B     D0,-(A7)
035C: 2F2C00A0      MOVE.L     160(A4),-(A7)
0360: A9D4548F2F2E  MOVE.L     (A4),#$548F2F2E
0366: FFEAA873      MOVE.W     -22413(A2),???
036A: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
036E: 4E5E          UNLK       A6
0370: 4E75          RTS        


; ======= Function at 0x0372 =======
0372: 4E56FFEE      LINK       A6,#-18                        ; frame=18
0376: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
037A: 286E0008      MOVEA.L    8(A6),A4
037E: 206E000C      MOVEA.L    12(A6),A0
0382: 1E280005      MOVE.B     5(A0),D7
0386: 0C070003      CMPI.B     #$0003,D7
038A: 6706          BEQ.S      $0392
038C: 0C07000D      CMPI.B     #$000D,D7
0390: 662C          BNE.S      $03BE
0392: 4A6C00A8      TST.W      168(A4)
0396: 6726          BEQ.S      $03BE
0398: 2F0C          MOVE.L     A4,-(A7)
039A: 3F2C00A8      MOVE.W     168(A4),-(A7)
039E: 486EFFFE      PEA        -2(A6)
03A2: 486EFFFA      PEA        -6(A6)
03A6: 486EFFF2      PEA        -14(A6)
03AA: A98D3F3C      MOVE.L     A5,60(A4,D3.L*8)
03AE: 000A2F2E      ORI.B      #$2F2E,A2
03B2: FFFA4EAD      MOVE.W     20141(PC),???
03B6: 01D2          BSET       D0,(A2)
03B8: 5C8F          MOVE.B     A7,(A6)
03BA: 60000080      BRA.W      $043E
03BE: 0C070003      CMPI.B     #$0003,D7
03C2: 6778          BEQ.S      $043C
03C4: 3C2C00A4      MOVE.W     164(A4),D6
03C8: 0C46FFFF      CMPI.W     #$FFFF,D6
03CC: 676E          BEQ.S      $043C
03CE: 0C070009      CMPI.B     #$0009,D7
03D2: 6656          BNE.S      $042A
03D4: 7E02          MOVEQ      #2,D7
03D6: DE46          MOVEA.B    D6,A7
03D8: 206C009C      MOVEA.L    156(A4),A0
03DC: 2050          MOVEA.L    (A0),A0
03DE: BE50          MOVEA.W    (A0),A7
03E0: 6F02          BLE.S      $03E4
03E2: 7E01          MOVEQ      #1,D7
03E4: 3D7CFFFFFFFE  MOVE.W     #$FFFF,-2(A6)
03EA: 42AEFFFA      CLR.L      -6(A6)
03EE: 2F0C          MOVE.L     A4,-(A7)
03F0: 3F07          MOVE.W     D7,-(A7)
03F2: 486EFFFE      PEA        -2(A6)
03F6: 486EFFFA      PEA        -6(A6)
03FA: 486EFFF2      PEA        -14(A6)
03FE: A98D4AAE      MOVE.L     A5,-82(A4,D4.L*2)
0402: FFFA6604      MOVE.W     26116(PC),???
0406: 4EAD01A2      JSR        418(A5)                        ; JT[418]
040A: 082E0004FFFF  BTST       #4,-1(A6)
0410: 6714          BEQ.S      $0426
0412: 3F07          MOVE.W     D7,-(A7)
0414: 2F0C          MOVE.L     A4,-(A7)
0416: 4EBAFD66      JSR        -666(PC)
041A: 2EAC00A0      MOVE.L     160(A4),(A7)
041E: 4EAD07B2      JSR        1970(A5)                       ; JT[1970]
0422: 5C8F          MOVE.B     A7,(A6)
0424: 6016          BRA.S      $043C
0426: 5247          MOVEA.B    D7,A1
0428: 60AE          BRA.S      $03D8
042A: 4267          CLR.W      -(A7)
042C: 2F2E000C      MOVE.L     12(A6),-(A7)
0430: 2F2C00A0      MOVE.L     160(A4),-(A7)
0434: 4EAD05FA      JSR        1530(A5)                       ; JT[1530]
0438: 4FEF000A      LEA        10(A7),A7
043C: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
0440: 4E5E          UNLK       A6
0442: 4E75          RTS        
