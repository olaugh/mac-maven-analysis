;======================================================================
; CODE 1 Disassembly
; File: /tmp/maven_code_1.bin
; Header: JT offset=0, JT entries=10
; Code size: 574 bytes
;======================================================================

0000: 000001BA      ORI.B      #$01BA,D0
0004: 00000000      ORI.B      #$0000,D0
0008: 42780A4A      CLR.W      $0A4A.W
000C: 9DCE          MOVE.B     A6,???
000E: 4EBA0034      JSR        52(PC)
0012: 4EBA0024      JSR        36(PC)
0016: 4267          CLR.W      -(A7)
0018: 48790000FFFF  PEA        $0000FFFF
001E: 486F0004      PEA        4(A7)
0022: 4857          PEA        (A7)
0024: 48780001      PEA        $0001.W
0028: 223AFFD6      MOVE.L     -42(PC),D1
002C: 4EB51000      JSR        0(A5,D1.W)
0030: 206D006C      MOVEA.L    108(A5),A0
0034: 4E90          JSR        (A0)
0036: A9F4223AFFCA6704  MOVE.L     58(A4,D2.W*2),#$FFCA6704
003E: 4EB51000      JSR        0(A5,D1.W)
0042: 4E75          RTS        

0044: 598F2F3C      MOVE.B     A7,60(A4,D2.L*8)
0048: 5A45          MOVEA.B    D5,A5
004A: 524F          MOVEA.B    A7,A1
004C: 4267          CLR.W      -(A7)
004E: A9A02457      MOVE.L     -(A0),87(A4,D2.W*4)
0052: 598F2F3C      MOVE.B     A7,60(A4,D2.L*8)
0056: 4441          NEG.W      D1
0058: 5441          MOVEA.B    D1,A2
005A: 4267          CLR.W      -(A7)
005C: A9A02057      MOVE.L     -(A0),87(A4,D2.W)
0060: 2050          MOVEA.L    (A0),A0
0062: 22780908      MOVEA.L    $0908.W,A1
0066: 2452          MOVEA.L    (A2),A2
0068: 600E          BRA.S      $0078
006A: 32D8          MOVE.W     (A0)+,(A1)+
006C: 660A          BNE.S      $0078
006E: 321A          MOVE.W     (A2)+,D1
0070: 6002          BRA.S      $0074
0072: 4219          CLR.B      (A1)+
0074: 51C9FFFC      DBF        D1,$0072                       ; loop
0078: BBC9          MOVE.W     A1,???
007A: 66EE          BNE.S      $006A
007C: A9A3A9A3      MOVE.L     -(A3),-93(A4,A2.L)
0080: 598F2F3C      MOVE.B     A7,60(A4,D2.L*8)
0084: 4452          NEG.W      (A2)
0086: 454C          DC.W       $454C
0088: 4267          CLR.W      -(A7)
008A: A9A02057      MOVE.L     -(A0),87(A4,D2.W)
008E: A025          MOVE.L     -(A5),D0
0090: 2050          MOVEA.L    (A0),A0
0092: E240          MOVEA.L    D0,A1
0094: 240D          MOVE.L     A5,D2
0096: 6006          BRA.S      $009E
0098: 3218          MOVE.W     (A0)+,D1
009A: D5B5100051C8  MOVE.B     0(A5,D1.W),-56(A2,D5.W)
00A0: FFF8A9A3      MOVE.W     $A9A3.W,???
00A4: 4E75          RTS        

00A6: 205F          MOVEA.L    (A7)+,A0
00A8: 3218          MOVE.W     (A0)+,D1
00AA: 3418          MOVE.W     (A0)+,D2
00AC: B058          MOVEA.W    (A0)+,A0
00AE: 57C9FFFA      DBEQ       D1,$00AA                       ; loop
00B2: 4A42          TST.W      D2
00B4: 67FE          BEQ.S      $00B4
00B6: 4EF020FC      JMP        -4(A0,D2.W)
00BA: 205F          MOVEA.L    (A7)+,A0
00BC: 3218          MOVE.W     (A0)+,D1
00BE: 3418          MOVE.W     (A0)+,D2
00C0: B098          MOVE.W     (A0)+,(A0)
00C2: 57C9FFFA      DBEQ       D1,$00BE                       ; loop
00C6: 4A42          TST.W      D2
00C8: 67FE          BEQ.S      $00C8
00CA: 4EF020FA      JMP        -6(A0,D2.W)
00CE: 205F          MOVEA.L    (A7)+,A0
00D0: 3218          MOVE.W     (A0)+,D1
00D2: 3418          MOVE.W     (A0)+,D2
00D4: B042          MOVEA.W    D2,A0
00D6: 6E0A          BGT.S      $00E2
00D8: 9041          MOVEA.B    D1,A0
00DA: 6D06          BLT.S      $00E2
00DC: D040          MOVEA.B    D0,A0
00DE: 41F00002      LEA        2(A0,D0.W),A0
00E2: 3010          MOVE.W     (A0),D0
00E4: 67FE          BEQ.S      $00E4
00E6: 4EF00000      JMP        0(A0,D0.W)
00EA: 202F0004      MOVE.L     4(A7),D0
00EE: 2F410004      MOVE.L     D1,4(A7)
00F2: 222F0008      MOVE.L     8(A7),D1
00F6: 2F5F0004      MOVE.L     (A7)+,4(A7)
00FA: 48E73C00      MOVEM.L    D2/D3/D4/D5,-(SP)              ; save
00FE: 2400          MOVE.L     D0,D2
0100: 2601          MOVE.L     D1,D3
0102: 4842          PEA        D2
0104: C4C3          ANDA.W     D3,A2
0106: 2800          MOVE.L     D0,D4
0108: 2A01          MOVE.L     D1,D5
010A: 4845          PEA        D5
010C: C8C5          ANDA.W     D5,A4
010E: D444          MOVEA.B    D4,A2
0110: 4842          PEA        D2
0112: 4242          CLR.W      D2
0114: C0C1          ANDA.W     D1,A0
0116: D082          MOVE.B     D2,(A0)
0118: 4CDF003C      MOVEM.L    (SP)+,D2/D3/D4/D5              ; restore
011C: 221F          MOVE.L     (A7)+,D1
011E: 4E75          RTS        

0120: 202F0004      MOVE.L     4(A7),D0
0124: 2F410004      MOVE.L     D1,4(A7)
0128: 222F0008      MOVE.L     8(A7),D1
012C: 2F5F0004      MOVE.L     (A7)+,4(A7)
0130: 48E73100      MOVEM.L    D2/D3/D7,-(SP)                 ; save
0134: 4EBA009C      JSR        156(PC)
0138: 4CDF008C      MOVEM.L    (SP)+,D2/D3/D7                 ; restore
013C: 221F          MOVE.L     (A7)+,D1
013E: 4E75          RTS        

0140: 202F0004      MOVE.L     4(A7),D0
0144: 2F410004      MOVE.L     D1,4(A7)
0148: 222F0008      MOVE.L     8(A7),D1
014C: 2F5F0004      MOVE.L     (A7)+,4(A7)
0150: 48E73100      MOVEM.L    D2/D3/D7,-(SP)                 ; save
0154: 4EBA007C      JSR        124(PC)
0158: 2001          MOVE.L     D1,D0
015A: 4CDF008C      MOVEM.L    (SP)+,D2/D3/D7                 ; restore
015E: 221F          MOVE.L     (A7)+,D1
0160: 4E75          RTS        

0162: 202F0004      MOVE.L     4(A7),D0
0166: 2F410004      MOVE.L     D1,4(A7)
016A: 222F0008      MOVE.L     8(A7),D1
016E: 2F5F0004      MOVE.L     (A7)+,4(A7)
0172: 48E73100      MOVEM.L    D2/D3/D7,-(SP)                 ; save
0176: 4EBA002C      JSR        44(PC)
017A: 4CDF008C      MOVEM.L    (SP)+,D2/D3/D7                 ; restore
017E: 221F          MOVE.L     (A7)+,D1
0180: 4E75          RTS        

0182: 202F0004      MOVE.L     4(A7),D0
0186: 2F410004      MOVE.L     D1,4(A7)
018A: 222F0008      MOVE.L     8(A7),D1
018E: 2F5F0004      MOVE.L     (A7)+,4(A7)
0192: 48E73100      MOVEM.L    D2/D3/D7,-(SP)                 ; save
0196: 4EBA000C      JSR        12(PC)
019A: 2001          MOVE.L     D1,D0
019C: 4CDF008C      MOVEM.L    (SP)+,D2/D3/D7                 ; restore
01A0: 221F          MOVE.L     (A7)+,D1
01A2: 4E75          RTS        

01A4: 4A80          TST.L      D0
01A6: 6A1C          BPL.S      $01C4
01A8: 4A81          TST.L      D1
01AA: 6A0C          BPL.S      $01B8
01AC: 4480          NEG.L      D0
01AE: 4481          NEG.L      D1
01B0: 4EBA0020      JSR        32(PC)
01B4: 4481          NEG.L      D1
01B6: 4E75          RTS        

01B8: 4480          NEG.L      D0
01BA: 4EBA0016      JSR        22(PC)
01BE: 4480          NEG.L      D0
01C0: 4481          NEG.L      D1
01C2: 4E75          RTS        

01C4: 4A81          TST.L      D1
01C6: 6A0A          BPL.S      $01D2
01C8: 4481          NEG.L      D1
01CA: 4EBA0006      JSR        6(PC)
01CE: 4480          NEG.L      D0
01D0: 4E75          RTS        

01D2: 2E3C0000FFFF  MOVE.L     #$0000FFFF,D7
01D8: B280          MOVE.W     D0,(A1)
01DA: 6306          BLS.S      $01E2
01DC: 2200          MOVE.L     D0,D1
01DE: 7000          MOVEQ      #0,D0
01E0: 4E75          RTS        

01E2: B087          MOVE.W     D7,(A0)
01E4: 620C          BHI.S      $01F2
01E6: 80C1          ORA.W      D1,A0
01E8: 4840          PEA        D0
01EA: 3200          MOVE.W     D0,D1
01EC: 4240          CLR.W      D0
01EE: 4840          PEA        D0
01F0: 4E75          RTS        

01F2: B287          MOVE.W     D7,(A1)
01F4: 621A          BHI.S      $0210
01F6: 2E00          MOVE.L     D0,D7
01F8: 4240          CLR.W      D0
01FA: 4840          PEA        D0
01FC: 80C1          ORA.W      D1,A0
01FE: 4840          PEA        D0
0200: 4847          PEA        D7
0202: 3E00          MOVE.W     D0,D7
0204: 4847          PEA        D7
0206: 8EC1          ORA.W      D1,A7
0208: 3007          MOVE.W     D7,D0
020A: 4847          PEA        D7
020C: 3207          MOVE.W     D7,D1
020E: 4E75          RTS        

0210: 2400          MOVE.L     D0,D2
0212: 2601          MOVE.L     D1,D3
0214: E288          MOVE.L     A0,(A1)
0216: E289          MOVE.L     A1,(A1)
0218: B287          MOVE.W     D7,(A1)
021A: 62F8          BHI.S      $0214
021C: 80C1          ORA.W      D1,A0
021E: C087          AND.L      D7,D0
0220: 3203          MOVE.W     D3,D1
0222: C2C0          ANDA.W     D0,A1
0224: 2E03          MOVE.L     D3,D7
0226: 4847          PEA        D7
0228: CEC0          ANDA.W     D0,A7
022A: 4847          PEA        D7
022C: D287          MOVE.B     D7,(A1)
022E: 6508          BCS.S      $0238
0230: 9282          MOVE.B     D2,(A1)
0232: 6204          BHI.S      $0238
0234: 4481          NEG.L      D1
0236: 4E75          RTS        

0238: 534060E4      MOVE.B     D0,24804(A1)
023C: 4E75          RTS        
