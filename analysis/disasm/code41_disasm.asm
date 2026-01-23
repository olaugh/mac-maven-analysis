;======================================================================
; CODE 41 Disassembly
; File: /tmp/maven_code_41.bin
; Header: JT offset=3128, JT entries=8
; Code size: 660 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FF00      LINK       A6,#-256                       ; frame=256
0004: 2F2E0008      MOVE.L     8(A6),-(A7)
0008: 486EFF00      PEA        -256(A6)
000C: 4EAD07DA      JSR        2010(A5)                       ; JT[2010]
0010: 2E80          MOVE.L     D0,(A7)
0012: 42A7          CLR.L      -(A7)
0014: 42A7          CLR.L      -(A7)
0016: 42A7          CLR.L      -(A7)
0018: A98B4E5E      MOVE.L     A3,94(A4,D4.L*8)
001C: 4E75          RTS        


; ======= Function at 0x001E =======
001E: 4E56FFF8      LINK       A6,#-8                         ; frame=8
0022: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
0026: 3E2E0008      MOVE.W     8(A6),D7
002A: A850          MOVEA.L    (A0),A4
002C: 486EFFF8      PEA        -8(A6)
0030: 3F07          MOVE.W     D7,-(A7)
0032: 2F3C4449544C  MOVE.L     #$4449544C,-(A7)
0038: 4EAD060A      JSR        1546(A5)                       ; JT[1546]
003C: 2840          MOVEA.L    D0,A4
003E: 200C          MOVE.L     A4,D0
0040: 4FEF000A      LEA        10(A7),A7
0044: 6604          BNE.S      $004A
0046: 4EAD01A2      JSR        418(A5)                        ; JT[418]
004A: 486EFFF8      PEA        -8(A6)
004E: 3F07          MOVE.W     D7,-(A7)
0050: 2F3C4449544C  MOVE.L     #$4449544C,-(A7)
0056: 4EAD0D12      JSR        3346(A5)                       ; JT[3346]
005A: 4297          CLR.L      (A7)
005C: 42A7          CLR.L      -(A7)
005E: 486EFFF8      PEA        -8(A6)
0062: 2F2E000A      MOVE.L     10(A6),-(A7)
0066: 2F3C08050100  MOVE.L     #$08050100,-(A7)
006C: 4878FFFF      PEA        $FFFF.W
0070: 4227          CLR.B      -(A7)
0072: 486DFB26      PEA        -1242(A5)                      ; A5-1242
0076: 2F0C          MOVE.L     A4,-(A7)
0078: A97D265F      MOVE.L     ???,9823(A4)
007C: 200B          MOVE.L     A3,D0
007E: 5C8F          MOVE.B     A7,(A6)
0080: 6604          BNE.S      $0086
0082: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0086: 2F0B          MOVE.L     A3,-(A7)
0088: 4EAD0212      JSR        530(A5)                        ; JT[530]
008C: 4257          CLR.W      (A7)
008E: 4EAD01DA      JSR        474(A5)                        ; JT[474]
0092: 4EAD0C42      JSR        3138(A5)                       ; JT[3138]
0096: 2EAE0012      MOVE.L     18(A6),(A7)
009A: 2F0B          MOVE.L     A3,-(A7)
009C: 206E000E      MOVEA.L    14(A6),A0
00A0: 4E90          JSR        (A0)
00A2: 3C00          MOVE.W     D0,D6
00A4: 3EBC0001      MOVE.W     #$0001,(A7)
00A8: 4EAD01DA      JSR        474(A5)                        ; JT[474]
00AC: 2E8B          MOVE.L     A3,(A7)
00AE: 3F07          MOVE.W     D7,-(A7)
00B0: 2F3C4449544C  MOVE.L     #$4449544C,-(A7)
00B6: 4EAD0D1A      JSR        3354(A5)                       ; JT[3354]
00BA: 2E8B          MOVE.L     A3,(A7)
00BC: 4EAD021A      JSR        538(A5)                        ; JT[538]
00C0: 2E8B          MOVE.L     A3,(A7)
00C2: A9834EAD      MOVE.L     D3,-83(A4,D4.L*8)
00C6: 0C423006      CMPI.W     #$3006,D2
00CA: 4CEE18C0FFE8  MOVEM.L    -24(A6),D6/D7/A3/A4
00D0: 4E5E          UNLK       A6
00D2: 4E75          RTS        


; ======= Function at 0x00D4 =======
00D4: 4E560000      LINK       A6,#0
00D8: 2F2E000A      MOVE.L     10(A6),-(A7)
00DC: 486D0C5A      PEA        3162(A5)                       ; A5+3162
00E0: 2F2DF248      MOVE.L     -3512(A5),-(A7)                ; A5-3512
00E4: 3F2E0008      MOVE.W     8(A6),-(A7)
00E8: 4EBAFF34      JSR        -204(PC)
00EC: 4E5E          UNLK       A6
00EE: 4E75          RTS        


; ======= Function at 0x00F0 =======
00F0: 4E56FFFE      LINK       A6,#-2                         ; frame=2
00F4: 2F2E000C      MOVE.L     12(A6),-(A7)
00F8: 486EFFFE      PEA        -2(A6)
00FC: A991302E      MOVE.L     (A1),46(A4,D3.W)
0100: FFFE          MOVE.W     ???,???
0102: 4E5E          UNLK       A6
0104: 4E75          RTS        


; ======= Function at 0x0106 =======
0106: 4E560000      LINK       A6,#0
010A: A850          MOVEA.L    (A0),A4
010C: 486D0C8A      PEA        3210(A5)                       ; A5+3210
0110: 3F2E0008      MOVE.W     8(A6),-(A7)
0114: 4EBAFFBE      JSR        -66(PC)
0118: 4E5E          UNLK       A6
011A: 4E75          RTS        


; ======= Function at 0x011C =======
011C: 4E56FFF4      LINK       A6,#-12                        ; frame=12
0120: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0124: 266E000C      MOVEA.L    12(A6),A3
0128: 286E0010      MOVEA.L    16(A6),A4
012C: 3E13          MOVE.W     (A3),D7
012E: 0C470003      CMPI.W     #$0003,D7
0132: 6706          BEQ.S      $013A
0134: 0C470005      CMPI.W     #$0005,D7
0138: 6638          BNE.S      $0172
013A: 3E2B0004      MOVE.W     4(A3),D7
013E: 024700FF      ANDI.W     #$00FF,D7
0142: 0C470003      CMPI.W     #$0003,D7
0146: 6706          BEQ.S      $014E
0148: 0C47000D      CMPI.W     #$000D,D7
014C: 6618          BNE.S      $0166
014E: 4A6C00A8      TST.W      168(A4)
0152: 6712          BEQ.S      $0166
0154: 206E0008      MOVEA.L    8(A6),A0
0158: 30AC00A8      MOVE.W     168(A4),(A0)
015C: 1D7C00010014  MOVE.B     #$01,20(A6)
0162: 600000C2      BRA.W      $0228
0166: 2F0B          MOVE.L     A3,-(A7)
0168: 4EAD0222      JSR        546(A5)                        ; JT[546]
016C: 588F          MOVE.B     A7,(A4)
016E: 600000B0      BRA.W      $0222
0172: 0C470006      CMPI.W     #$0006,D7
0176: 6706          BEQ.S      $017E
0178: 0C470008      CMPI.W     #$0008,D7
017C: 660C          BNE.S      $018A
017E: 2F0B          MOVE.L     A3,-(A7)
0180: 4EAD0222      JSR        546(A5)                        ; JT[546]
0184: 588F          MOVE.B     A7,(A4)
0186: 60000098      BRA.W      $0222
018A: 0C470001      CMPI.W     #$0001,D7
018E: 66000082      BNE.W      $0214
0192: 4267          CLR.W      -(A7)
0194: 2F2B000A      MOVE.L     10(A3),-(A7)
0198: 486EFFFC      PEA        -4(A6)
019C: A92C3E1F      MOVE.L     15903(A4),-(A4)
01A0: B9EEFFFC6624  MOVE.W     -4(A6),#$6624
01A6: 0C470004      CMPI.W     #$0004,D7
01AA: 672A          BEQ.S      $01D6
01AC: 0C470003      CMPI.W     #$0003,D7
01B0: 6724          BEQ.S      $01D6
01B2: 0C470005      CMPI.W     #$0005,D7
01B6: 671E          BEQ.S      $01D6
01B8: 0C470007      CMPI.W     #$0007,D7
01BC: 6718          BEQ.S      $01D6
01BE: 0C470008      CMPI.W     #$0008,D7
01C2: 6712          BEQ.S      $01D6
01C4: 0C470006      CMPI.W     #$0006,D7
01C8: 670C          BEQ.S      $01D6
01CA: 3F3C0001      MOVE.W     #$0001,-(A7)
01CE: 4EAD0C9A      JSR        3226(A5)                       ; JT[3226]
01D2: 548F          MOVE.B     A7,(A2)
01D4: 604A          BRA.S      $0220
01D6: 0C470003      CMPI.W     #$0003,D7
01DA: 662C          BNE.S      $0208
01DC: 2D6B000AFFF8  MOVE.L     10(A3),-8(A6)
01E2: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
01E6: A873486E      MOVEA.L    110(A3,D4.L),A4
01EA: FFF8A871      MOVE.W     $A871.W,???
01EE: 4267          CLR.W      -(A7)
01F0: 2F2EFFF8      MOVE.L     -8(A6),-(A7)
01F4: 2F2EFFFC      MOVE.L     -4(A6),-(A7)
01F8: 486EFFF4      PEA        -12(A6)
01FC: A96C3E1F6706  MOVE.L     15903(A4),26374(A4)
0202: 422E0014      CLR.B      20(A6)
0206: 601E          BRA.S      $0226
0208: 2F0B          MOVE.L     A3,-(A7)
020A: 4EAD0222      JSR        546(A5)                        ; JT[546]
020E: 588F          MOVE.B     A7,(A4)
0210: 600E          BRA.S      $0220
0212: 4A47          TST.W      D7
0214: 660A          BNE.S      $0220
0216: 2F0B          MOVE.L     A3,-(A7)
0218: 2F0C          MOVE.L     A4,-(A7)
021A: 4EAD022A      JSR        554(A5)                        ; JT[554]
021E: 508F          MOVE.B     A7,(A0)
0220: 4253          CLR.W      (A3)
0222: 422E0014      CLR.B      20(A6)
0226: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
022A: 4E5E          UNLK       A6
022C: 205F          MOVEA.L    (A7)+,A0
022E: 4FEF000C      LEA        12(A7),A7
0232: 4ED0          JMP        (A0)

; ======= Function at 0x0234 =======
0234: 4E560000      LINK       A6,#0
0238: 2F2E0008      MOVE.L     8(A6),-(A7)
023C: 4EBAFDC2      JSR        -574(PC)
0240: 3EBC03FD      MOVE.W     #$03FD,(A7)
0244: 4EBAFEC0      JSR        -320(PC)
0248: 4E5E          UNLK       A6
024A: 4E75          RTS        


; ======= Function at 0x024C =======
024C: 4E560000      LINK       A6,#0
0250: 2F2E0008      MOVE.L     8(A6),-(A7)
0254: 42A7          CLR.L      -(A7)
0256: 42A7          CLR.L      -(A7)
0258: 42A7          CLR.L      -(A7)
025A: A98B3F3C      MOVE.L     A3,60(A4,D3.L*8)
025E: 03FC4EBA      BSET       D1,#$BA
0262: FEA4          MOVE.W     -(A4),(A7)
0264: 5540548F      MOVE.B     D0,21647(A2)
0268: 6626          BNE.S      $0290
026A: 2B6D93ACA222  MOVE.L     -27732(A5),-24030(A5)          ; A5-27732
0270: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
0276: C1EDA386      ANDA.L     -23674(A5),A0
027A: 41EDA226      LEA        -24026(A5),A0                  ; g_common
027E: D088          MOVE.B     A0,(A0)
0280: 2040          MOVEA.L    D0,A0
0282: 7001          MOVEQ      #1,D0
0284: 4A40          TST.W      D0
0286: 6602          BNE.S      $028A
0288: 7001          MOVEQ      #1,D0
028A: 4CD8          DC.W       $4CD8
028C: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
0290: 4E5E          UNLK       A6
0292: 4E75          RTS        
