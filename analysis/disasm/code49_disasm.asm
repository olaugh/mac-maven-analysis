;======================================================================
; CODE 49 Disassembly
; File: /tmp/maven_code_49.bin
; Header: JT offset=3312, JT entries=2
; Code size: 546 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FFF0      LINK       A6,#-16                        ; frame=16
0004: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
0008: 2D6DFA56FFF0  MOVE.L     -1450(A5),-16(A6)              ; A5-1450
000E: 2D6DFA5AFFF4  MOVE.L     -1446(A5),-12(A6)              ; A5-1446
0014: 7E00          MOVEQ      #0,D7
0016: 603E          BRA.S      $0056
0018: 2054          MOVEA.L    (A4),A0
001A: 2D50FFF8      MOVE.L     (A0),-8(A6)
001E: 2D680004FFFC  MOVE.L     4(A0),-4(A6)
0024: 302EFFF8      MOVE.W     -8(A6),D0
0028: B06EFFF0      MOVEA.W    -16(A6),A0
002C: 6622          BNE.S      $0050
002E: 302EFFFC      MOVE.W     -4(A6),D0
0032: B06EFFF4      MOVEA.W    -12(A6),A0
0036: 6618          BNE.S      $0050
0038: 302EFFFA      MOVE.W     -6(A6),D0
003C: B06EFFF2      MOVEA.W    -14(A6),A0
0040: 660E          BNE.S      $0050
0042: 302EFFFE      MOVE.W     -2(A6),D0
0046: B06EFFF6      MOVEA.W    -10(A6),A0
004A: 6604          BNE.S      $0050
004C: 200C          MOVE.L     A4,D0
004E: 6060          BRA.S      $00B0
0050: 2F0C          MOVE.L     A4,-(A7)
0052: A9A35247      MOVE.L     -(A3),71(A4,D5.W*2)
0056: 42A7          CLR.L      -(A7)
0058: 2F3C77706C63  MOVE.L     #$77706C63,-(A7)
005E: 3F07          MOVE.W     D7,-(A7)
0060: A9A0285F      MOVE.L     -(A0),95(A4,D2.L)
0064: 200C          MOVE.L     A4,D0
0066: 66B0          BNE.S      $0018
0068: 7008          MOVEQ      #8,D0
006A: A122          MOVE.L     -(A2),-(A0)
006C: 2848          MOVEA.L    A0,A4
006E: 200C          MOVE.L     A4,D0
0070: 6604          BNE.S      $0076
0072: 7000          MOVEQ      #0,D0
0074: 603A          BRA.S      $00B0
0076: 42A7          CLR.L      -(A7)
0078: 2F0C          MOVE.L     A4,-(A7)
007A: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
007E: 7008          MOVEQ      #8,D0
0080: B09F          MOVE.W     (A7)+,(A0)
0082: 6704          BEQ.S      $0088
0084: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0088: 2054          MOVEA.L    (A4),A0
008A: 20AEFFF0      MOVE.L     -16(A6),(A0)
008E: 216EFFF40004  MOVE.L     -12(A6),4(A0)
0094: 2F0C          MOVE.L     A4,-(A7)
0096: 2F3C77706C63  MOVE.L     #$77706C63,-(A7)
009C: 3F07          MOVE.W     D7,-(A7)
009E: 2F2DF248      MOVE.L     -3512(A5),-(A7)                ; A5-3512
00A2: A9AB2F0CA9AA  MOVE.L     12044(A3),-86(A4,A2.L)
00A8: 4267          CLR.W      -(A7)
00AA: A994A999      MOVE.L     (A4),-103(A4,A2.L)
00AE: 200C          MOVE.L     A4,D0
00B0: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
00B4: 4E5E          UNLK       A6
00B6: 4E75          RTS        


; ======= Function at 0x00B8 =======
00B8: 4E56FFFC      LINK       A6,#-4                         ; frame=4
00BC: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
00C0: 4EBAFF3E      JSR        -194(PC)
00C4: 2840          MOVEA.L    D0,A4
00C6: 200C          MOVE.L     A4,D0
00C8: 675C          BEQ.S      $0126
00CA: 42A7          CLR.L      -(A7)
00CC: 2F0C          MOVE.L     A4,-(A7)
00CE: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
00D2: 2D5FFFFC      MOVE.L     (A7)+,-4(A6)
00D6: 4878000E      PEA        $000E.W
00DA: 206EFFFC      MOVEA.L    -4(A6),A0
00DE: 4868FFEA      PEA        -22(A0)
00E2: 4EAD005A      JSR        90(A5)                         ; JT[90]
00E6: 2E00          MOVE.L     D0,D7
00E8: 7C00          MOVEQ      #0,D6
00EA: 97CB6030      MOVE.B     A3,48(PC,D6.W)
00EE: 45EB0008      LEA        8(A3),A2
00F2: D5D4202E      MOVE.B     (A4),8238(PC)
00F6: 0008B092      ORI.B      #$B092,A0
00FA: 661C          BNE.S      $0118
00FC: 302E000C      MOVE.W     12(A6),D0
0100: B06A0004      MOVEA.W    4(A2),A0
0104: 6612          BNE.S      $0118
0106: 2014          MOVE.L     (A4),D0
0108: 206E000E      MOVEA.L    14(A6),A0
010C: 20B3080E      MOVE.L     14(A3,D0.L),(A0)
0110: 217308120004  MOVE.L     18(A3,D0.L),4(A0)
0116: 600A          BRA.S      $0122
0118: 5286          MOVE.B     D6,(A1)
011A: 47EB000E      LEA        14(A3),A3
011E: BE86          MOVE.W     D6,(A7)
0120: 6CCC          BGE.S      $00EE
0122: 2F0C          MOVE.L     A4,-(A7)
0124: A9A34CDF      MOVE.L     -(A3),-33(A4,D4.L*4)
0128: 1CC0          MOVE.B     D0,(A6)+
012A: 4E5E          UNLK       A6
012C: 4E75          RTS        


; ======= Function at 0x012E =======
012E: 4E56FFF4      LINK       A6,#-12                        ; frame=12
0132: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
0136: 4EBAFEC8      JSR        -312(PC)
013A: 2840          MOVEA.L    D0,A4
013C: 200C          MOVE.L     A4,D0
013E: 670000DA      BEQ.W      $021C
0142: 206E000E      MOVEA.L    14(A6),A0
0146: 2D680010FFF8  MOVE.L     16(A0),-8(A6)
014C: 2D680014FFFC  MOVE.L     20(A0),-4(A6)
0152: 2F08          MOVE.L     A0,-(A7)
0154: A873486E      MOVEA.L    110(A3,D4.L),A4
0158: FFF8A870      MOVE.W     $A870.W,???
015C: 486EFFFC      PEA        -4(A6)
0160: A8704878      MOVEA.L    120(A0,D4.L),A4
0164: 000E2F0C      ORI.B      #$2F0C,A6
0168: 4EAD05CA      JSR        1482(A5)                       ; JT[1482]
016C: 4A780220      TST.W      $0220.W
0170: 508F          MOVE.B     A7,(A0)
0172: 660000A2      BNE.W      $0218
0176: 42A7          CLR.L      -(A7)
0178: 2F0C          MOVE.L     A4,-(A7)
017A: 4EAD0B0A      JSR        2826(A5)                       ; JT[2826]
017E: 2D5FFFF4      MOVE.L     (A7)+,-12(A6)
0182: 4878000E      PEA        $000E.W
0186: 206EFFF4      MOVEA.L    -12(A6),A0
018A: 4868FFEA      PEA        -22(A0)
018E: 4EAD004A      JSR        74(A5)                         ; JT[74]
0192: 2E00          MOVE.L     D0,D7
0194: 4878000E      PEA        $000E.W
0198: 2F07          MOVE.L     D7,-(A7)
019A: 4EAD0042      JSR        66(A5)                         ; JT[66]
019E: 2640          MOVEA.L    D0,A3
01A0: 2014          MOVE.L     (A4),D0
01A2: 27AE00080808  MOVE.L     8(A6),8(A3,D0.L)
01A8: 2014          MOVE.L     (A4),D0
01AA: 37AE000C080C  MOVE.W     12(A6),12(A3,D0.L)
01B0: 7C00          MOVEQ      #0,D6
01B2: 7008          MOVEQ      #8,D0
01B4: D094          MOVE.B     (A4),(A0)
01B6: 2440          MOVEA.L    D0,A2
01B8: 4878000E      PEA        $000E.W
01BC: 2F06          MOVE.L     D6,-(A7)
01BE: 4EAD0042      JSR        66(A5)                         ; JT[66]
01C2: 2640          MOVEA.L    D0,A3
01C4: 6006          BRA.S      $01CC
01C6: 5286          MOVE.B     D6,(A1)
01C8: 47EB000E      LEA        14(A3),A3
01CC: 204A          MOVEA.L    A2,A0
01CE: D1CB202E      MOVE.B     A3,$202E.W
01D2: 0008B090      ORI.B      #$B090,A0
01D6: 66EE          BNE.S      $01C6
01D8: 2014          MOVE.L     (A4),D0
01DA: 3033080C      MOVE.W     12(A3,D0.L),D0
01DE: B06E000C      MOVEA.W    12(A6),A0
01E2: 66E2          BNE.S      $01C6
01E4: 4878000E      PEA        $000E.W
01E8: 2F06          MOVE.L     D6,-(A7)
01EA: 4EAD0042      JSR        66(A5)                         ; JT[66]
01EE: 2054          MOVEA.L    (A4),A0
01F0: 41F0080E      LEA        14(A0,D0.L),A0
01F4: 20EEFFF8      MOVE.L     -8(A6),(A0)+
01F8: 20EEFFFC      MOVE.L     -4(A6),(A0)+
01FC: BE86          MOVE.W     D6,(A7)
01FE: 6F0C          BLE.S      $020C
0200: 4878FFF2      PEA        $FFF2.W
0204: 2F0C          MOVE.L     A4,-(A7)
0206: 4EAD05CA      JSR        1482(A5)                       ; JT[1482]
020A: 508F          MOVE.B     A7,(A0)
020C: 2F0C          MOVE.L     A4,-(A7)
020E: A9AA4267A994  MOVE.L     16999(A2),-108(A4,A2.L)
0214: A9992F0C      MOVE.L     (A1)+,12(A4,D2.L*8)
0218: A9A34CDF      MOVE.L     -(A3),-33(A4,D4.L*4)
021C: 1CC0          MOVE.B     D0,(A6)+
021E: 4E5E          UNLK       A6
0220: 4E75          RTS        
