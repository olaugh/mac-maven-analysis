;======================================================================
; CODE 47 Disassembly
; File: /tmp/maven_code_47.bin
; Header: JT offset=3328, JT entries=4
; Code size: 908 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FFFA      LINK       A6,#-6                         ; frame=6
0004: 422EFFFF      CLR.B      -1(A6)
0008: 7001          MOVEQ      #1,D0
000A: 2D40FFFA      MOVE.L     D0,-6(A6)
000E: 4267          CLR.W      -(A7)
0010: 3F2E0008      MOVE.W     8(A6),-(A7)
0014: 486EFFFA      PEA        -6(A6)
0018: 486EFFFF      PEA        -1(A6)
001C: 4EAD0B2A      JSR        2858(A5)                       ; JT[2858]
0020: 4A5F          TST.W      (A7)+
0022: 6706          BEQ.S      $002A
0024: 1D7C00FFFFFF  MOVE.B     #$FF,-1(A6)
002A: 102EFFFF      MOVE.B     -1(A6),D0
002E: 4880          EXT.W      D0
0030: 4E5E          UNLK       A6
0032: 4E75          RTS        


; ======= Function at 0x0034 =======
0034: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0038: 7001          MOVEQ      #1,D0
003A: 2D40FFFC      MOVE.L     D0,-4(A6)
003E: 4267          CLR.W      -(A7)
0040: 3F2E0008      MOVE.W     8(A6),-(A7)
0044: 486EFFFC      PEA        -4(A6)
0048: 486DFB6E      PEA        -1170(A5)                      ; A5-1170
004C: 4EAD0B32      JSR        2866(A5)                       ; JT[2866]
0050: 301F          MOVE.W     (A7)+,D0
0052: 4E5E          UNLK       A6
0054: 4E75          RTS        


; ======= Function at 0x0056 =======
0056: 4E56FF86      LINK       A6,#-122                       ; frame=122
005A: 2F07          MOVE.L     D7,-(A7)
005C: 4878007A      PEA        $007A.W
0060: 486EFF86      PEA        -122(A6)
0064: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0068: 2D6E0008FF98  MOVE.L     8(A6),-104(A6)
006E: 4257          CLR.W      (A7)
0070: 486EFF86      PEA        -122(A6)
0074: 4227          CLR.B      -(A7)
0076: 4EAD0B82      JSR        2946(A5)                       ; JT[2946]
007A: 3E1F          MOVE.W     (A7)+,D7
007C: 206E000C      MOVEA.L    12(A6),A0
0080: 20AEFFD2      MOVE.L     -46(A6),(A0)
0084: 3007          MOVE.W     D7,D0
0086: 2E2EFF82      MOVE.L     -126(A6),D7
008A: 4E5E          UNLK       A6
008C: 4E75          RTS        


; ======= Function at 0x008E =======
008E: 4E56FF86      LINK       A6,#-122                       ; frame=122
0092: 2F07          MOVE.L     D7,-(A7)
0094: 4878007A      PEA        $007A.W
0098: 486EFF86      PEA        -122(A6)
009C: 4EAD01AA      JSR        426(A5)                        ; JT[426]
00A0: 2D6E0008FF98  MOVE.L     8(A6),-104(A6)
00A6: 4257          CLR.W      (A7)
00A8: 486EFF86      PEA        -122(A6)
00AC: 4227          CLR.B      -(A7)
00AE: 4EAD0B82      JSR        2946(A5)                       ; JT[2946]
00B2: 3E1F          MOVE.W     (A7)+,D7
00B4: 202EFFCA      MOVE.L     -54(A6),D0
00B8: D0AEFFC0      MOVE.B     -64(A6),(A0)
00BC: 206E000C      MOVEA.L    12(A6),A0
00C0: 2080          MOVE.L     D0,(A0)
00C2: 3007          MOVE.W     D7,D0
00C4: 2E2EFF82      MOVE.L     -126(A6),D7
00C8: 4E5E          UNLK       A6
00CA: 4E75          RTS        


; ======= Function at 0x00CC =======
00CC: 4E56FEAE      LINK       A6,#-338                       ; frame=338
00D0: 2F07          MOVE.L     D7,-(A7)
00D2: 48780050      PEA        $0050.W
00D6: 486EFEAE      PEA        -338(A6)
00DA: 4EAD01AA      JSR        426(A5)                        ; JT[426]
00DE: 41EEFEFE      LEA        -258(A6),A0
00E2: 2D48FEC0      MOVE.L     A0,-320(A6)
00E6: 3D7C0001FECA  MOVE.W     #$0001,-310(A6)
00EC: 508F          MOVE.B     A7,(A0)
00EE: 4267          CLR.W      -(A7)
00F0: 486EFEAE      PEA        -338(A6)
00F4: 4227          CLR.B      -(A7)
00F6: 4EAD0B12      JSR        2834(A5)                       ; JT[2834]
00FA: 3E1F          MOVE.W     (A7)+,D7
00FC: 6622          BNE.S      $0120
00FE: 2F2E0008      MOVE.L     8(A6),-(A7)
0102: 486EFEFE      PEA        -258(A6)
0106: 4EAD07FA      JSR        2042(A5)                       ; JT[2042]
010A: 4A40          TST.W      D0
010C: 508F          MOVE.B     A7,(A0)
010E: 660A          BNE.S      $011A
0110: 206E000C      MOVEA.L    12(A6),A0
0114: 30AEFEC4      MOVE.W     -316(A6),(A0)
0118: 6006          BRA.S      $0120
011A: 526EFECA      MOVEA.B    -310(A6),A1
011E: 60CE          BRA.S      $00EE
0120: 3007          MOVE.W     D7,D0
0122: 2E1F          MOVE.L     (A7)+,D7
0124: 4E5E          UNLK       A6
0126: 4E75          RTS        


; ======= Function at 0x0128 =======
0128: 4E560000      LINK       A6,#0
012C: 2F07          MOVE.L     D7,-(A7)
012E: 4267          CLR.W      -(A7)
0130: 2F2E0008      MOVE.L     8(A6),-(A7)
0134: 3F2E000C      MOVE.W     12(A6),-(A7)
0138: 2F2E000E      MOVE.L     14(A6),-(A7)
013C: 4EAD0B1A      JSR        2842(A5)                       ; JT[2842]
0140: 3E1F          MOVE.W     (A7)+,D7
0142: 6704          BEQ.S      $0148
0144: 3007          MOVE.W     D7,D0
0146: 601A          BRA.S      $0162
0148: 4A6E0012      TST.W      18(A6)
014C: 6712          BEQ.S      $0160
014E: 4267          CLR.W      -(A7)
0150: 206E000E      MOVEA.L    14(A6),A0
0154: 3F10          MOVE.W     (A0),-(A7)
0156: 42A7          CLR.L      -(A7)
0158: 4EAD0B6A      JSR        2922(A5)                       ; JT[2922]
015C: 301F          MOVE.W     (A7)+,D0
015E: 6002          BRA.S      $0162
0160: 7000          MOVEQ      #0,D0
0162: 2E1F          MOVE.L     (A7)+,D7
0164: 4E5E          UNLK       A6
0166: 4E75          RTS        


; ======= Function at 0x0168 =======
0168: 4E56FFEA      LINK       A6,#-22                        ; frame=22
016C: 2F07          MOVE.L     D7,-(A7)
016E: 3F2E0012      MOVE.W     18(A6),-(A7)
0172: 2F2E000E      MOVE.L     14(A6),-(A7)
0176: 3F2E000C      MOVE.W     12(A6),-(A7)
017A: 2F2E0008      MOVE.L     8(A6),-(A7)
017E: 4EBAFFA8      JSR        -88(PC)
0182: 3E00          MOVE.W     D0,D7
0184: 4FEF000C      LEA        12(A7),A7
0188: 6744          BEQ.S      $01CE
018A: 4267          CLR.W      -(A7)
018C: 48780910      PEA        $0910.W
0190: 4267          CLR.W      -(A7)
0192: 486EFFF0      PEA        -16(A6)
0196: 4EAD0B3A      JSR        2874(A5)                       ; JT[2874]
019A: 4257          CLR.W      (A7)
019C: 2F2E0008      MOVE.L     8(A6),-(A7)
01A0: 3F2E000C      MOVE.W     12(A6),-(A7)
01A4: 2F2EFFF4      MOVE.L     -12(A6),-(A7)
01A8: 2F2E0014      MOVE.L     20(A6),-(A7)
01AC: 4EAD0B52      JSR        2898(A5)                       ; JT[2898]
01B0: 3E1F          MOVE.W     (A7)+,D7
01B2: 661A          BNE.S      $01CE
01B4: 3F2E0012      MOVE.W     18(A6),-(A7)
01B8: 2F2E000E      MOVE.L     14(A6),-(A7)
01BC: 3F2E000C      MOVE.W     12(A6),-(A7)
01C0: 2F2E0008      MOVE.L     8(A6),-(A7)
01C4: 4EBAFF62      JSR        -158(PC)
01C8: 3E00          MOVE.W     D0,D7
01CA: 4FEF000C      LEA        12(A7),A7
01CE: 3007          MOVE.W     D7,D0
01D0: 2E1F          MOVE.L     (A7)+,D7
01D2: 4E5E          UNLK       A6
01D4: 4E75          RTS        


; ======= Function at 0x01D6 =======
01D6: 4E56FFFE      LINK       A6,#-2                         ; frame=2
01DA: 2F07          MOVE.L     D7,-(A7)
01DC: 2F3C54455854  MOVE.L     #$54455854,-(A7)
01E2: 3F3C0001      MOVE.W     #$0001,-(A7)
01E6: 486EFFFE      PEA        -2(A6)
01EA: 3F2E000C      MOVE.W     12(A6),-(A7)
01EE: 2F2E0008      MOVE.L     8(A6),-(A7)
01F2: 4EBAFF74      JSR        -140(PC)
01F6: 3E00          MOVE.W     D0,D7
01F8: 4FEF0010      LEA        16(A7),A7
01FC: 6652          BNE.S      $0250
01FE: 4267          CLR.W      -(A7)
0200: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
0204: 486E0012      PEA        18(A6)
0208: 2F2E000E      MOVE.L     14(A6),-(A7)
020C: 4EAD0B32      JSR        2866(A5)                       ; JT[2866]
0210: 3E1F          MOVE.W     (A7)+,D7
0212: 6612          BNE.S      $0226
0214: 4267          CLR.W      -(A7)
0216: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
021A: 2F2E0012      MOVE.L     18(A6),-(A7)
021E: 4EAD0B6A      JSR        2922(A5)                       ; JT[2922]
0222: 3E1F          MOVE.W     (A7)+,D7
0224: 670E          BEQ.S      $0234
0226: 4267          CLR.W      -(A7)
0228: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
022C: 4EAD0B22      JSR        2850(A5)                       ; JT[2850]
0230: 548F          MOVE.B     A7,(A2)
0232: 601C          BRA.S      $0250
0234: 4267          CLR.W      -(A7)
0236: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
023A: 4EAD0B22      JSR        2850(A5)                       ; JT[2850]
023E: 3E1F          MOVE.W     (A7)+,D7
0240: 660E          BNE.S      $0250
0242: 4267          CLR.W      -(A7)
0244: 42A7          CLR.L      -(A7)
0246: 3F2E000C      MOVE.W     12(A6),-(A7)
024A: 4EAD0B4A      JSR        2890(A5)                       ; JT[2890]
024E: 3E1F          MOVE.W     (A7)+,D7
0250: 3007          MOVE.W     D7,D0
0252: 2E1F          MOVE.L     (A7)+,D7
0254: 4E5E          UNLK       A6
0256: 4E75          RTS        


; ======= Function at 0x0258 =======
0258: 4E56FFFE      LINK       A6,#-2                         ; frame=2
025C: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
0260: 266E000E      MOVEA.L    14(A6),A3
0264: 4267          CLR.W      -(A7)
0266: 2F2E0008      MOVE.L     8(A6),-(A7)
026A: 3F2E000C      MOVE.W     12(A6),-(A7)
026E: 486EFFFE      PEA        -2(A6)
0272: 4EAD0B1A      JSR        2842(A5)                       ; JT[2842]
0276: 4A5F          TST.W      (A7)+
0278: 6704          BEQ.S      $027E
027A: 7000          MOVEQ      #0,D0
027C: 6064          BRA.S      $02E2
027E: 4267          CLR.W      -(A7)
0280: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
0284: 2F0B          MOVE.L     A3,-(A7)
0286: 4EAD0B62      JSR        2914(A5)                       ; JT[2914]
028A: 4A5F          TST.W      (A7)+
028C: 6704          BEQ.S      $0292
028E: 7000          MOVEQ      #0,D0
0290: 6050          BRA.S      $02E2
0292: 7001          MOVEQ      #1,D0
0294: D093          MOVE.B     (A3),(A0)
0296: A11E          MOVE.L     (A6)+,-(A0)
0298: 2848          MOVEA.L    A0,A4
029A: 2008          MOVE.L     A0,D0
029C: 6604          BNE.S      $02A2
029E: 7000          MOVEQ      #0,D0
02A0: 6040          BRA.S      $02E2
02A2: 4267          CLR.W      -(A7)
02A4: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
02A8: 2F0B          MOVE.L     A3,-(A7)
02AA: 2F0C          MOVE.L     A4,-(A7)
02AC: 4EAD0B2A      JSR        2858(A5)                       ; JT[2858]
02B0: 4A5F          TST.W      (A7)+
02B2: 6628          BNE.S      $02DC
02B4: 42A7          CLR.L      -(A7)
02B6: 2F0C          MOVE.L     A4,-(A7)
02B8: 4EAD0B02      JSR        2818(A5)                       ; JT[2818]
02BC: 7001          MOVEQ      #1,D0
02BE: D093          MOVE.B     (A3),(A0)
02C0: B09F          MOVE.W     (A7)+,(A0)
02C2: 6618          BNE.S      $02DC
02C4: 4267          CLR.W      -(A7)
02C6: 3F2EFFFE      MOVE.W     -2(A6),-(A7)
02CA: 4EAD0B22      JSR        2850(A5)                       ; JT[2850]
02CE: 4A5F          TST.W      (A7)+
02D0: 660A          BNE.S      $02DC
02D2: 204C          MOVEA.L    A4,A0
02D4: D1D34210      MOVE.B     (A3),$4210.W
02D8: 200C          MOVE.L     A4,D0
02DA: 6006          BRA.S      $02E2
02DC: 204C          MOVEA.L    A4,A0
02DE: A01F          MOVE.L     (A7)+,D0
02E0: 7000          MOVEQ      #0,D0
02E2: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
02E6: 4E5E          UNLK       A6
02E8: 4E75          RTS        


; ======= Function at 0x02EA =======
02EA: 4E560000      LINK       A6,#0
02EE: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
02F2: 266E0008      MOVEA.L    8(A6),A3
02F6: 2E2E000C      MOVE.L     12(A6),D7
02FA: 284B          MOVEA.L    A3,A4
02FC: 4A87          TST.L      D7
02FE: 6626          BNE.S      $0326
0300: 7000          MOVEQ      #0,D0
0302: 6048          BRA.S      $034C
0304: 0C460008      CMPI.W     #$0008,D6
0308: 660E          BNE.S      $0318
030A: B7CC6706      MOVE.W     A4,6(PC,D6.W)
030E: 5487          MOVE.B     D7,(A2)
0310: 538C6012      MOVE.B     A4,18(A1,D6.W)
0314: 5287          MOVE.B     D7,(A1)
0316: 600E          BRA.S      $0326
0318: 18C6          MOVE.B     D6,(A4)+
031A: 0C06000A      CMPI.B     #$000A,D6
031E: 671C          BEQ.S      $033C
0320: 0C46000D      CMPI.W     #$000D,D6
0324: 6716          BEQ.S      $033C
0326: 53874A87      MOVE.B     D7,-121(A1,D4.L*2)
032A: 6510          BCS.S      $033C
032C: 3F2E0010      MOVE.W     16(A6),-(A7)
0330: 4EBAFCCE      JSR        -818(PC)
0334: 3C00          MOVE.W     D0,D6
0336: 5240          MOVEA.B    D0,A1
0338: 548F          MOVE.B     A7,(A2)
033A: 66C8          BNE.S      $0304
033C: B9CB6702      MOVE.W     A3,#$6702
0340: 4214          CLR.B      (A4)
0342: B7CC6604      MOVE.W     A4,4(PC,D6.W)
0346: 7000          MOVEQ      #0,D0
0348: 6002          BRA.S      $034C
034A: 200B          MOVE.L     A3,D0
034C: 4CDF18C0      MOVEM.L    (SP)+,D6/D7/A3/A4              ; restore
0350: 4E5E          UNLK       A6
0352: 4E75          RTS        


; ======= Function at 0x0354 =======
0354: 4E56FFFC      LINK       A6,#-4                         ; frame=4
0358: 2F07          MOVE.L     D7,-(A7)
035A: 2F2E0008      MOVE.L     8(A6),-(A7)
035E: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0362: 2D40FFFC      MOVE.L     D0,-4(A6)
0366: 4257          CLR.W      (A7)
0368: 3F2E000C      MOVE.W     12(A6),-(A7)
036C: 486EFFFC      PEA        -4(A6)
0370: 2F2E0008      MOVE.L     8(A6),-(A7)
0374: 4EAD0B32      JSR        2866(A5)                       ; JT[2866]
0378: 3E1F          MOVE.W     (A7)+,D7
037A: 4A47          TST.W      D7
037C: 548F          MOVE.B     A7,(A2)
037E: 6704          BEQ.S      $0384
0380: 70FF          MOVEQ      #-1,D0
0382: 6002          BRA.S      $0386
0384: 7000          MOVEQ      #0,D0
0386: 2E1F          MOVE.L     (A7)+,D7
0388: 4E5E          UNLK       A6
038A: 4E75          RTS        
