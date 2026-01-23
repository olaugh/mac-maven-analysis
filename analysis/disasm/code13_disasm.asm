;======================================================================
; CODE 13 Disassembly
; File: /tmp/maven_code_13.bin
; Header: JT offset=592, JT entries=4
; Code size: 512 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 2F07          MOVE.L     D7,-(A7)
0006: 3E2E0008      MOVE.W     8(A6),D7
000A: 0C470013      CMPI.W     #$0013,D7
000E: 632E          BLS.S      $003E
0010: 206DDE78      MOVEA.L    -8584(A5),A0
0014: 2050          MOVEA.L    (A0),A0
0016: 4A680300      TST.W      768(A0)
001A: 57C0          SEQ        D0
001C: 4400          NEG.B      D0
001E: 4880          EXT.W      D0
0020: 206DDE78      MOVEA.L    -8584(A5),A0
0024: 2050          MOVEA.L    (A0),A0
0026: 31400300      MOVE.W     D0,768(A0)
002A: 206DDE78      MOVEA.L    -8584(A5),A0
002E: 2050          MOVEA.L    (A0),A0
0030: 3F280300      MOVE.W     768(A0),-(A7)
0034: 3F07          MOVE.W     D7,-(A7)
0036: 4EBA01AE      JSR        430(PC)
003A: 588F          MOVE.B     A7,(A4)
003C: 603A          BRA.S      $0078
003E: 4267          CLR.W      -(A7)
0040: 206DDE78      MOVEA.L    -8584(A5),A0
0044: 2250          MOVEA.L    (A0),A1
0046: 30290302      MOVE.W     770(A1),D0
004A: C1FC00C02050  ANDA.L     #$00C02050,A0
0050: 3F30080A      MOVE.W     10(A0,D0.L),-(A7)
0054: 4EBA0190      JSR        400(PC)
0058: 206DDE78      MOVEA.L    -8584(A5),A0
005C: 2250          MOVEA.L    (A0),A1
005E: 30290302      MOVE.W     770(A1),D0
0062: C1FC00C02050  ANDA.L     #$00C02050,A0
0068: 3187080A      MOVE.W     D7,10(A0,D0.L)
006C: 3EBC0001      MOVE.W     #$0001,(A7)
0070: 3F07          MOVE.W     D7,-(A7)
0072: 4EBA0172      JSR        370(PC)
0076: 5C8F          MOVE.B     A7,(A6)
0078: 2E1F          MOVE.L     (A7)+,D7
007A: 4E5E          UNLK       A6
007C: 4E75          RTS        


; ======= Function at 0x007E =======
007E: 4E560000      LINK       A6,#0
0082: 0C6D0100E2E2  CMPI.W     #$0100,-7454(A5)
0088: 6D04          BLT.S      $008E
008A: 426DE2E2      CLR.W      -7454(A5)
008E: 302DE2E2      MOVE.W     -7454(A5),D0                   ; A5-7454
0092: 526DE2E2      MOVEA.B    -7454(A5),A1
0096: 206DE2E4      MOVEA.L    -7452(A5),A0
009A: 4A300000      TST.B      0(A0,D0.W)
009E: 670A          BEQ.S      $00AA
00A0: 2F2E0008      MOVE.L     8(A6),-(A7)
00A4: 4EAD0842      JSR        2114(A5)                       ; JT[2114]
00A8: 588F          MOVE.B     A7,(A4)
00AA: 4E5E          UNLK       A6
00AC: 4E75          RTS        


; ======= Function at 0x00AE =======
00AE: 4E56FEF4      LINK       A6,#-268                       ; frame=268
00B2: 48E70708      MOVEM.L    D5/D6/D7/A4,-(SP)              ; save
00B6: 206DDE78      MOVEA.L    -8584(A5),A0
00BA: 2250          MOVEA.L    (A0),A1
00BC: 30290302      MOVE.W     770(A1),D0
00C0: C1FC00C02050  ANDA.L     #$00C02050,A0
00C6: 3E30080A      MOVE.W     10(A0,D0.L),D7
00CA: 206DDE78      MOVEA.L    -8584(A5),A0
00CE: 2250          MOVEA.L    (A0),A1
00D0: 30290302      MOVE.W     770(A1),D0
00D4: C1FC00C0D090  ANDA.L     #$00C0D090,A0
00DA: 2240          MOVEA.L    D0,A1
00DC: 204D          MOVEA.L    A5,A0
00DE: D0C7          MOVE.B     D7,(A0)+
00E0: D0C7          MOVE.B     D7,(A0)+
00E2: 4868A18C      PEA        -24180(A0)
00E6: 486EFEF6      PEA        -266(A6)
00EA: 3F3C200E      MOVE.W     #$200E,-(A7)
00EE: A9EB4851486EFEF6  MOVE.L     18513(A3),#$486EFEF6
00F6: 3F3C0002      MOVE.W     #$0002,-(A7)
00FA: A9EB486EFEF63F3C  MOVE.L     18542(A3),#$FEF63F3C
0102: 0016A9EB      ORI.B      #$A9EB,(A6)
0106: 486EFEF6      PEA        -266(A6)
010A: 486EFEF4      PEA        -268(A6)
010E: 3F3C2010      MOVE.W     #$2010,-(A7)
0112: A9EB3B6EFEF4A54C  MOVE.L     15214(A3),#$FEF4A54C
011A: 0C470001      CMPI.W     #$0001,D7
011E: 6618          BNE.S      $0138
0120: 4267          CLR.W      -(A7)
0122: 2F2E000C      MOVE.L     12(A6),-(A7)
0126: 2F2E0008      MOVE.L     8(A6),-(A7)
012A: 4EAD0AC2      JSR        2754(A5)                       ; JT[2754]
012E: 2840          MOVEA.L    D0,A4
0130: 4FEF000A      LEA        10(A7),A7
0134: 60000092      BRA.W      $01CA
0138: 41EEFF00      LEA        -256(A6),A0
013C: 2B48E2E4      MOVE.L     A0,-7452(A5)
0140: 48780100      PEA        $0100.W
0144: 486EFF00      PEA        -256(A6)
0148: 4EAD01AA      JSR        426(A5)                        ; JT[426]
014C: 206DDE78      MOVEA.L    -8584(A5),A0
0150: 2250          MOVEA.L    (A0),A1
0152: 30290302      MOVE.W     770(A1),D0
0156: C1FC00C02050  ANDA.L     #$00C02050,A0
015C: 0C700013080A  CMPI.W     #$0013,10(A0,D0.L)
0162: 508F          MOVE.B     A7,(A0)
0164: 6504          BCS.S      $016A
0166: 4EAD01A2      JSR        418(A5)                        ; JT[418]
016A: 7A00          MOVEQ      #0,D5
016C: 3C05          MOVE.W     D5,D6
016E: 6026          BRA.S      $0196
0170: 0C460100      CMPI.W     #$0100,D6
0174: 6508          BCS.S      $017E
0176: 3006          MOVE.W     D6,D0
0178: 0640FF00      ADDI.W     #$FF00,D0
017C: 3C00          MOVE.W     D0,D6
017E: 49EEFF00      LEA        -256(A6),A4
0182: D8C6          MOVE.B     D6,(A4)+
0184: 4A14          TST.B      (A4)
0186: 6704          BEQ.S      $018C
0188: 4EAD01A2      JSR        418(A5)                        ; JT[418]
018C: 18BC0001      MOVE.B     #$01,(A4)
0190: 5245          MOVEA.B    D5,A1
0192: 06460011      ADDI.W     #$0011,D6
0196: 206DDE78      MOVEA.L    -8584(A5),A0
019A: 2250          MOVEA.L    (A0),A1
019C: 30290302      MOVE.W     770(A1),D0
01A0: C1FC00C02050  ANDA.L     #$00C02050,A0
01A6: 3030080A      MOVE.W     10(A0,D0.L),D0
01AA: 204D          MOVEA.L    A5,A0
01AC: D0C0          MOVE.B     D0,(A0)+
01AE: D0C0          MOVE.B     D0,(A0)+
01B0: BA68E2BC      MOVEA.W    -7492(A0),A5
01B4: 6DBA          BLT.S      $0170
01B6: 486D0282      PEA        642(A5)                        ; A5+642
01BA: 2F2E0008      MOVE.L     8(A6),-(A7)
01BE: 4EAD0852      JSR        2130(A5)                       ; JT[2130]
01C2: 49EDA5F0      LEA        -23056(A5),A4                  ; g_dawg_?
01C6: 508F          MOVE.B     A7,(A0)
01C8: 426DA54C      CLR.W      -23220(A5)
01CC: 200C          MOVE.L     A4,D0
01CE: 4CDF10E0      MOVEM.L    (SP)+,D5/D6/D7/A4              ; restore
01D2: 4E5E          UNLK       A6
01D4: 4E75          RTS        


; ======= Function at 0x01D6 =======
01D6: 4E560000      LINK       A6,#0
01DA: 3F2E000C      MOVE.W     12(A6),-(A7)
01DE: 4EBAFE20      JSR        -480(PC)
01E2: 4E5E          UNLK       A6
01E4: 4E75          RTS        


; ======= Function at 0x01E6 =======
01E6: 4E560000      LINK       A6,#0
01EA: 42A7          CLR.L      -(A7)
01EC: 3F3C0005      MOVE.W     #$0005,-(A7)
01F0: A9493F2E      MOVE.L     A1,16174(A4)
01F4: 00081F2E      ORI.B      #$1F2E,A0
01F8: 000BA945      ORI.B      #$A945,A3
01FC: 4E5E          UNLK       A6
01FE: 4E75          RTS        
