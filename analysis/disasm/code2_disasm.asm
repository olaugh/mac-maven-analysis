;======================================================================
; CODE 2 Disassembly
; File: /tmp/maven_code_2.bin
; Header: JT offset=80, JT entries=4
; Code size: 750 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FFF0      LINK       A6,#-16                        ; frame=16
0004: 4227          CLR.B      -(A7)
0006: 4267          CLR.W      -(A7)
0008: 486EFFF0      PEA        -16(A6)
000C: A9713B6E000C  MOVE.L     110(A1,D3.L*2),12(A4)
0012: 9012          MOVE.B     (A2),D0
0014: 486DD700      PEA        -10496(A5)                     ; A5-10496
0018: 4EAD0C62      JSR        3170(A5)                       ; JT[3170]
001C: 486D008A      PEA        138(A5)                        ; A5+138
0020: 3F3C0400      MOVE.W     #$0400,-(A7)
0024: 4EAD0C82      JSR        3202(A5)                       ; JT[3202]
0028: 4E5E          UNLK       A6
002A: 4E75          RTS        


; ======= Function at 0x002C =======
002C: 4E56FFF2      LINK       A6,#-14                        ; frame=14
0030: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
0034: 266E0010      MOVEA.L    16(A6),A3
0038: 286E000C      MOVEA.L    12(A6),A4
003C: 0C540006      CMPI.W     #$0006,(A4)
0040: 66000084      BNE.W      $00C8
0044: B7EC0002667C  MOVE.W     2(A4),124(PC,D6.W)
004A: 2F0B          MOVE.L     A3,-(A7)
004C: A8732F0B      MOVEA.L    11(A3,D2.L*8),A4
0050: A922          MOVE.L     -(A2),-(A4)
0052: 2F0B          MOVE.L     A3,-(A7)
0054: 2F2B0018      MOVE.L     24(A3),-(A7)
0058: A9782F0B3F3C  MOVE.L     $2F0B.W,16188(A4)
005E: 0004486E      ORI.B      #$486E,D4
0062: FFFA486E      MOVE.W     18542(PC),???
0066: FFFC486E      MOVE.W     #$486E,???
006A: FFF2A98D      MOVE.W     -115(A2,A2.L),???
006E: 3F2EFFF4      MOVE.W     -12(A6),-(A7)
0072: 3F2EFFF6      MOVE.W     -10(A6),-(A7)
0076: A893          MOVE.L     (A3),(A4)
0078: 486D9014      PEA        -28652(A5)                     ; A5-28652
007C: A884          MOVE.L     D4,(A4)
007E: 206DDE78      MOVEA.L    -8584(A5),A0
0082: A029206D      MOVE.L     8301(A1),D0
0086: DE782050      MOVEA.B    $2050.W,A7
008A: 4868032E      PEA        814(A0)
008E: 4267          CLR.W      -(A7)
0090: 206DDE78      MOVEA.L    -8584(A5),A0
0094: 2050          MOVEA.L    (A0),A0
0096: 4868032E      PEA        814(A0)
009A: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
009E: 548F          MOVE.B     A7,(A2)
00A0: 3E80          MOVE.W     D0,(A7)
00A2: A885          MOVE.L     D5,(A4)
00A4: 206DDE78      MOVEA.L    -8584(A5),A0
00A8: A02A2F0B      MOVE.L     12043(A2),D0
00AC: A923          MOVE.L     -(A3),-(A4)
00AE: 4A6D9012      TST.W      -28654(A5)
00B2: 6706          BEQ.S      $00BA
00B4: 422E0014      CLR.B      20(A6)
00B8: 6028          BRA.S      $00E2
00BA: 4EBA00CA      JSR        202(PC)
00BE: 1D7C00010014  MOVE.B     #$01,20(A6)
00C4: 601C          BRA.S      $00E2
00C6: 4A6D9012      TST.W      -28654(A5)
00CA: 670C          BEQ.S      $00D8
00CC: 0C540001      CMPI.W     #$0001,(A4)
00D0: 670A          BEQ.S      $00DC
00D2: 0C540003      CMPI.W     #$0003,(A4)
00D6: 6704          BEQ.S      $00DC
00D8: 7000          MOVEQ      #0,D0
00DA: 6002          BRA.S      $00DE
00DC: 7001          MOVEQ      #1,D0
00DE: 1D400014      MOVE.B     D0,20(A6)
00E2: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
00E6: 4E5E          UNLK       A6
00E8: 205F          MOVEA.L    (A7)+,A0
00EA: 4FEF000C      LEA        12(A7),A7
00EE: 4ED0          JMP        (A0)

; ======= Function at 0x00F0 =======
00F0: 4E56FFFC      LINK       A6,#-4                         ; frame=4
00F4: 2F0C          MOVE.L     A4,-(A7)
00F6: 486EFFFC      PEA        -4(A6)
00FA: 4267          CLR.W      -(A7)
00FC: 2F2E0008      MOVE.L     8(A6),-(A7)
0100: 4EAD0D3A      JSR        3386(A5)                       ; JT[3386]
0104: 2840          MOVEA.L    D0,A4
0106: 200C          MOVE.L     A4,D0
0108: 4FEF000A      LEA        10(A7),A7
010C: 6626          BNE.S      $0134
010E: 2B6D9F28A222  MOVE.L     -24792(A5),-24030(A5)          ; A5-24792
0114: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
011A: C1EDA386      ANDA.L     -23674(A5),A0
011E: 41EDA226      LEA        -24026(A5),A0                  ; g_common
0122: D088          MOVE.B     A0,(A0)
0124: 2040          MOVEA.L    D0,A0
0126: 7001          MOVEQ      #1,D0
0128: 4A40          TST.W      D0
012A: 6602          BNE.S      $012E
012C: 7001          MOVEQ      #1,D0
012E: 4CD8          DC.W       $4CD8
0130: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
0134: 2B6C0004DE74  MOVE.L     4(A4),-8588(A5)
013A: 2B6C0008DE70  MOVE.L     8(A4),-8592(A5)
0140: 41EC000C      LEA        12(A4),A0
0144: 2B48DE6C      MOVE.L     A0,-8596(A5)
0148: 202DDE74      MOVE.L     -8588(A5),D0                   ; A5-8588
014C: E58843F4      MOVE.L     A0,-12(A2,D4.W*2)
0150: 08742B49DE68  BCHG       #11081,104(A4,A5.L*8)
0156: 202DDE74      MOVE.L     -8588(A5),D0                   ; A5-8588
015A: E5880C30      MOVE.L     A0,48(A2,D0.L*4)
015E: 00610803      ORI.W      #$0803,-(A1)
0162: 6704          BEQ.S      $0168
0164: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0168: 202DDE70      MOVE.L     -8592(A5),D0                   ; A5-8592
016C: E588D0AD      MOVE.L     A0,-83(A2,A5.W)
0170: DE682040      MOVEA.B    8256(A0),A7
0174: 0C2800610003  CMPI.B     #$0061,3(A0)
017A: 6704          BEQ.S      $0180
017C: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0180: 285F          MOVEA.L    (A7)+,A4
0182: 4E5E          UNLK       A6
0184: 4E75          RTS        

0186: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
018A: 48780E00      PEA        $0E00.W
018E: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
0192: 2B40D130      MOVE.L     D0,-11984(A5)
0196: 48780900      PEA        $0900.W
019A: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
019E: 2B40CF0C      MOVE.L     D0,-12532(A5)
01A2: 48780900      PEA        $0900.W
01A6: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
01AA: 2B40CF10      MOVE.L     D0,-12528(A5)
01AE: 48780900      PEA        $0900.W
01B2: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
01B6: 2B40CF14      MOVE.L     D0,-12524(A5)
01BA: 48780900      PEA        $0900.W
01BE: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
01C2: 2B40CF18      MOVE.L     D0,-12520(A5)
01C6: 48780900      PEA        $0900.W
01CA: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
01CE: 2B40CF1C      MOVE.L     D0,-12516(A5)
01D2: 48780900      PEA        $0900.W
01D6: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
01DA: 2B40CF20      MOVE.L     D0,-12512(A5)
01DE: 4EAD0692      JSR        1682(A5)                       ; JT[1682]
01E2: 2E00          MOVE.L     D0,D7
01E4: 0C8700002000  CMPI.L     #$00002000,D7
01EA: 4FEF001C      LEA        28(A7),A7
01EE: 6F06          BLE.S      $01F6
01F0: 2E3C00002000  MOVE.L     #$00002000,D7
01F6: EB8F0C87      MOVE.L     A7,-121(A5,D0.L*4)
01FA: 000080CE      ORI.B      #$80CE,D0
01FE: 6406          BCC.S      $0206
0200: 2E3C000080CE  MOVE.L     #$000080CE,D7
0206: 2F07          MOVE.L     D7,-(A7)
0208: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
020C: 2B40D134      MOVE.L     D0,-11980(A5)
0210: EA8F          MOVE.L     A7,(A5)
0212: 2B47D138      MOVE.L     D7,-11976(A5)
0216: 4A80          TST.L      D0
0218: 588F          MOVE.B     A7,(A4)
021A: 6604          BNE.S      $0220
021C: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0220: 48784400      PEA        $4400.W
0224: 4EAD0682      JSR        1666(A5)                       ; JT[1666]
0228: 2B40CF08      MOVE.L     D0,-12536(A5)
022C: 7200          MOVEQ      #0,D1
022E: 12380910      MOVE.B     $0910.W,D1
0232: 3041          MOVEA.W    D1,A0
0234: 42280911      CLR.B      2321(A0)
0238: 387C0910      MOVEA.W    #$0910,A4
023C: 2E8C          MOVE.L     A4,(A7)
023E: 4EBAFEB0      JSR        -336(PC)
0242: 2E8C          MOVE.L     A4,(A7)
0244: 4EAD0302      JSR        770(A5)                        ; JT[770]
0248: 588F          MOVE.B     A7,(A4)
024A: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
024E: 4E75          RTS        


; ======= Function at 0x0250 =======
0250: 4E56FFF8      LINK       A6,#-8                         ; frame=8
0254: 2D6E0008FFF8  MOVE.L     8(A6),-8(A6)
025A: 3D6E000EFFFC  MOVE.W     14(A6),-4(A6)
0260: 3D6E0010FFFE  MOVE.W     16(A6),-2(A6)
0266: 486EFFF8      PEA        -8(A6)
026A: 486D0072      PEA        114(A5)                        ; A5+114
026E: 486D9026      PEA        -28634(A5)                     ; A5-28634
0272: 3F2E000C      MOVE.W     12(A6),-(A7)
0276: 4EAD0C92      JSR        3218(A5)                       ; JT[3218]
027A: 4E5E          UNLK       A6
027C: 4E75          RTS        


; ======= Function at 0x027E =======
027E: 4E56FFFA      LINK       A6,#-6                         ; frame=6
0282: 2F0C          MOVE.L     A4,-(A7)
0284: 286E000C      MOVEA.L    12(A6),A4
0288: 2F14          MOVE.L     (A4),-(A7)
028A: 3F2C0004      MOVE.W     4(A4),-(A7)
028E: 2F2E0008      MOVE.L     8(A6),-(A7)
0292: 4EAD0CDA      JSR        3290(A5)                       ; JT[3290]
0296: 3EAC0004      MOVE.W     4(A4),(A7)
029A: 2F2E0008      MOVE.L     8(A6),-(A7)
029E: 4EAD0CA2      JSR        3234(A5)                       ; JT[3234]
02A2: 4FEF000E      LEA        14(A7),A7
02A6: 486D0C8A      PEA        3210(A5)                       ; A5+3210
02AA: 486EFFFE      PEA        -2(A6)
02AE: A9910C6E      MOVE.L     (A1),110(A4,D0.L*4)
02B2: 0001FFFE      ORI.B      #$FFFE,D1
02B6: 662C          BNE.S      $02E4
02B8: 2F14          MOVE.L     (A4),-(A7)
02BA: 3F2C0004      MOVE.W     4(A4),-(A7)
02BE: 2F2E0008      MOVE.L     8(A6),-(A7)
02C2: 4EAD0642      JSR        1602(A5)                       ; JT[1602]
02C6: 2E94          MOVE.L     (A4),(A7)
02C8: 4EAD0802      JSR        2050(A5)                       ; JT[2050]
02CC: 2E80          MOVE.L     D0,(A7)
02CE: 2F14          MOVE.L     (A4),-(A7)
02D0: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
02D4: 4FEF000E      LEA        14(A7),A7
02D8: 4A6C0006      TST.W      6(A4)
02DC: 6606          BNE.S      $02E4
02DE: 2054          MOVEA.L    (A4),A0
02E0: 4A10          TST.B      (A0)
02E2: 67C2          BEQ.S      $02A6
02E4: 302EFFFE      MOVE.W     -2(A6),D0
02E8: 285F          MOVEA.L    (A7)+,A4
02EA: 4E5E          UNLK       A6
02EC: 4E75          RTS        
