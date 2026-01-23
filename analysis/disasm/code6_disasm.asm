;======================================================================
; CODE 6 Disassembly
; File: /tmp/maven_code_6.bin
; Header: JT offset=168, JT entries=7
; Code size: 1026 bytes
;======================================================================

0000: 206DDE78      MOVEA.L    -8584(A5),A0
0004: 2050          MOVEA.L    (A0),A0
0006: 30280302      MOVE.W     770(A0),D0
000A: 670E          BEQ.S      $001A
000C: 6B52          BMI.S      $0060
000E: 5740674A      MOVE.B     D0,26442(A3)
0012: 6A4C          BPL.S      $0060
0014: 5240          MOVEA.B    D0,A1
0016: 6A26          BPL.S      $003E
0018: 6012          BRA.S      $002C
001A: 2B6DDE6CD148  MOVE.L     -8596(A5),-11960(A5)           ; A5-8596
0020: 2B6DDE74D14C  MOVE.L     -8588(A5),-11956(A5)           ; A5-8588
0026: 42ADD154      CLR.L      -11948(A5)
002A: 6034          BRA.S      $0060
002C: 2B6DDE68D148  MOVE.L     -8600(A5),-11960(A5)           ; A5-8600
0032: 2B6DDE70D14C  MOVE.L     -8592(A5),-11956(A5)           ; A5-8592
0038: 42ADD154      CLR.L      -11948(A5)
003C: 6022          BRA.S      $0060
003E: 2B6DDE6CD148  MOVE.L     -8596(A5),-11960(A5)           ; A5-8596
0044: 2B6DDE74D14C  MOVE.L     -8588(A5),-11956(A5)           ; A5-8588
004A: 2B6DDE68D150  MOVE.L     -8600(A5),-11952(A5)           ; A5-8600
0050: 2B6DDE70D154  MOVE.L     -8592(A5),-11948(A5)           ; A5-8592
0056: 42ADD15C      CLR.L      -11940(A5)
005A: 6004          BRA.S      $0060
005C: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0060: 4E75          RTS        


; ======= Function at 0x0062 =======
0062: 4E56FEFE      LINK       A6,#-258                       ; frame=258
0066: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
006A: 4EBA02D2      JSR        722(PC)
006E: 4A40          TST.W      D0
0070: 660000B4      BNE.W      $0128
0074: 4EBA0242      JSR        578(PC)
0078: 422EFF00      CLR.B      -256(A6)
007C: 2F3C00020000  MOVE.L     #$00020000,-(A7)
0082: 3F3C03FA      MOVE.W     #$03FA,-(A7)
0086: 486EFF00      PEA        -256(A6)
008A: 4EAD007A      JSR        122(A5)                        ; JT[122]
008E: 486EFF00      PEA        -256(A6)
0092: 4EBA02C4      JSR        708(PC)
0096: 422EFF00      CLR.B      -256(A6)
009A: 2EBC00020001  MOVE.L     #$00020001,(A7)
00A0: 3F3C03F9      MOVE.W     #$03F9,-(A7)
00A4: 486EFF00      PEA        -256(A6)
00A8: 4EAD007A      JSR        122(A5)                        ; JT[122]
00AC: 486EFEFE      PEA        -258(A6)
00B0: 486D90A2      PEA        -28510(A5)                     ; A5-28510
00B4: 486EFF00      PEA        -256(A6)
00B8: 4EAD081A      JSR        2074(A5)                       ; JT[2074]
00BC: 7E01          MOVEQ      #1,D7
00BE: 0C6E02BCFEFE  CMPI.W     #$02BC,-258(A6)
00C4: 4FEF0020      LEA        32(A7),A7
00C8: 6C0A          BGE.S      $00D4
00CA: 3D7C02BCFEFE  MOVE.W     #$02BC,-258(A6)
00D0: 7E12          MOVEQ      #18,D7
00D2: 600E          BRA.S      $00E2
00D4: 0C6E0834FEFE  CMPI.W     #$0834,-258(A6)
00DA: 6F06          BLE.S      $00E2
00DC: 3D7C0834FEFE  MOVE.W     #$0834,-258(A6)
00E2: 7C04          MOVEQ      #4,D6
00E4: 6026          BRA.S      $010C
00E6: 303C00C0      MOVE.W     #$00C0,D0
00EA: C1C6          ANDA.L     D6,A0
00EC: 2840          MOVEA.L    D0,A4
00EE: 206DDE78      MOVEA.L    -8584(A5),A0
00F2: 2010          MOVE.L     (A0),D0
00F4: 3987080A      MOVE.W     D7,10(A4,D0.L)
00F8: 206DDE78      MOVEA.L    -8584(A5),A0
00FC: 224C          MOVEA.L    A4,A1
00FE: D3D0486EFEFE  MOVE.B     (A0),$486EFEFE
0104: 4851          PEA        (A1)
0106: 3F3C200E      MOVE.W     #$200E,-(A7)
010A: A9EB53464A466CD4  MOVE.L     21318(A3),#$4A466CD4
0112: 486D90A6      PEA        -28506(A5)                     ; A5-28506
0116: 4EBA02B8      JSR        696(PC)
011A: 2EADDE78      MOVE.L     -8584(A5),(A7)                 ; A5-8584
011E: A9AA4267A994  MOVE.L     16999(A2),-108(A4,A2.L)
0124: A999206D      MOVE.L     (A1)+,109(A4,D2.W)
0128: DE782050      MOVEA.B    $2050.W,A7
012C: 4A68030C      TST.W      780(A0)
0130: 6610          BNE.S      $0142
0132: 206DDE78      MOVEA.L    -8584(A5),A0
0136: 2050          MOVEA.L    (A0),A0
0138: 317C0001030C  MOVE.W     #$0001,780(A0)
013E: 4EBA024A      JSR        586(PC)
0142: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
0146: 4E5E          UNLK       A6
0148: 4E75          RTS        


; ======= Function at 0x014A =======
014A: 4E56FE00      LINK       A6,#-512                       ; frame=512
014E: 486EFE00      PEA        -512(A6)
0152: 4EBA0256      JSR        598(PC)
0156: 2EBC00020001  MOVE.L     #$00020001,(A7)
015C: 3F3C03FE      MOVE.W     #$03FE,-(A7)
0160: 486EFE00      PEA        -512(A6)
0164: 4EAD007A      JSR        122(A5)                        ; JT[122]
0168: 53404FEF      MOVE.B     D0,20463(A1)
016C: 000A660A      ORI.B      #$660A,A2
0170: 486EFE00      PEA        -512(A6)
0174: 4EBA0008      JSR        8(PC)
0178: 588F          MOVE.B     A7,(A4)
017A: 4E5E          UNLK       A6
017C: 4E75          RTS        


; ======= Function at 0x017E =======
017E: 4E56FE00      LINK       A6,#-512                       ; frame=512
0182: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
0186: 2E2E0008      MOVE.L     8(A6),D7
018A: 48780100      PEA        $0100.W
018E: 486EFF00      PEA        -256(A6)
0192: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0196: 286DA1FA      MOVEA.L    -24070(A5),A4
019A: 508F          MOVE.B     A7,(A0)
019C: 600C          BRA.S      $01AA
019E: 204E          MOVEA.L    A6,A0
01A0: D0C6          MOVE.B     D6,(A0)+
01A2: 117C0001FF00  MOVE.B     #$01,-256(A0)
01A8: 528C          MOVE.B     A4,(A1)
01AA: 1C14          MOVE.B     (A4),D6
01AC: 4886          EXT.W      D6
01AE: 4A46          TST.W      D6
01B0: 66EC          BNE.S      $019E
01B2: 206DA1FA      MOVEA.L    -24070(A5),A0
01B6: 48680001      PEA        1(A0)
01BA: 2F07          MOVE.L     D7,-(A7)
01BC: 4EAD0DAA      JSR        3498(A5)                       ; JT[3498]
01C0: 486D90C2      PEA        -28478(A5)                     ; A5-28478
01C4: 2F07          MOVE.L     D7,-(A7)
01C6: 4EAD0DAA      JSR        3498(A5)                       ; JT[3498]
01CA: 45EEFE00      LEA        -512(A6),A2
01CE: 2847          MOVEA.L    D7,A4
01D0: 4FEF0010      LEA        16(A7),A7
01D4: 6010          BRA.S      $01E6
01D6: 47EEFF00      LEA        -256(A6),A3
01DA: D6C6          MOVE.B     D6,(A3)+
01DC: 4A13          TST.B      (A3)
01DE: 6704          BEQ.S      $01E4
01E0: 14C6          MOVE.B     D6,(A2)+
01E2: 4213          CLR.B      (A3)
01E4: 528C          MOVE.B     A4,(A1)
01E6: 1014          MOVE.B     (A4),D0
01E8: 4880          EXT.W      D0
01EA: 3F00          MOVE.W     D0,-(A7)
01EC: 4EAD0DE2      JSR        3554(A5)                       ; JT[3554]
01F0: 3C00          MOVE.W     D0,D6
01F2: 548F          MOVE.B     A7,(A2)
01F4: 66E0          BNE.S      $01D6
01F6: 4212          CLR.B      (A2)
01F8: 486EFE00      PEA        -512(A6)
01FC: 4EBA01D2      JSR        466(PC)
0200: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
0204: 4CEE1CC0FDEC  MOVEM.L    -532(A6),D6/D7/A2/A3/A4
020A: 4E5E          UNLK       A6
020C: 4E75          RTS        

020E: 206DDE78      MOVEA.L    -8584(A5),A0
0212: 2050          MOVEA.L    (A0),A0
0214: 4A680304      TST.W      772(A0)
0218: 6714          BEQ.S      $022E
021A: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
021E: 2B48C376      MOVE.L     A0,-15498(A5)
0222: 226DDE78      MOVEA.L    -8584(A5),A1
0226: 2251          MOVEA.L    (A1),A1
0228: 42690304      CLR.W      772(A1)
022C: 6014          BRA.S      $0242
022E: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
0232: 2B48C376      MOVE.L     A0,-15498(A5)
0236: 226DDE78      MOVEA.L    -8584(A5),A1
023A: 2251          MOVEA.L    (A1),A1
023C: 337C00010304  MOVE.W     #$0001,772(A1)
0242: 4E75          RTS        


; ======= Function at 0x0244 =======
0244: 4E560000      LINK       A6,#0
0248: 2F07          MOVE.L     D7,-(A7)
024A: 2E2E0010      MOVE.L     16(A6),D7
024E: 2F2E000C      MOVE.L     12(A6),-(A7)
0252: 3F07          MOVE.W     D7,-(A7)
0254: 206DDE78      MOVEA.L    -8584(A5),A0
0258: 2050          MOVEA.L    (A0),A0
025A: 70FF          MOVEQ      #-1,D0
025C: D047          MOVEA.B    D7,A0
025E: B0680302      MOVEA.W    770(A0),A0
0262: 57C0          SEQ        D0
0264: 4400          NEG.B      D0
0266: 1F00          MOVE.B     D0,-(A7)
0268: A9452F07      MOVE.L     D5,12039(A4)
026C: 2F2E000C      MOVE.L     12(A6),-(A7)
0270: 2F2E0008      MOVE.L     8(A6),-(A7)
0274: 4EAD019A      JSR        410(A5)                        ; JT[410]
0278: 4A80          TST.L      D0
027A: 4FEF000C      LEA        12(A7),A7
027E: 6614          BNE.S      $0294
0280: 206DDE78      MOVEA.L    -8584(A5),A0
0284: 2050          MOVEA.L    (A0),A0
0286: 70FF          MOVEQ      #-1,D0
0288: D047          MOVEA.B    D7,A0
028A: B0680302      MOVEA.W    770(A0),A0
028E: 6704          BEQ.S      $0294
0290: 7000          MOVEQ      #0,D0
0292: 6002          BRA.S      $0296
0294: 7001          MOVEQ      #1,D0
0296: 2E1F          MOVE.L     (A7)+,D7
0298: 4E5E          UNLK       A6
029A: 4E75          RTS        


; ======= Function at 0x029C =======
029C: 4E560000      LINK       A6,#0
02A0: 206DDE78      MOVEA.L    -8584(A5),A0
02A4: 70FF          MOVEQ      #-1,D0
02A6: D06E000C      MOVEA.B    12(A6),A0
02AA: 2050          MOVEA.L    (A0),A0
02AC: 31400302      MOVE.W     D0,770(A0)
02B0: 4EBAFD4E      JSR        -690(PC)
02B4: 4E5E          UNLK       A6
02B6: 4E75          RTS        

02B8: 203C0000042E  MOVE.L     #$0000042E,D0
02BE: A322          MOVE.L     -(A2),-(A1)
02C0: 2B48DE78      MOVE.L     A0,-8584(A5)
02C4: 2008          MOVE.L     A0,D0
02C6: 6626          BNE.S      $02EE
02C8: 2B6D93A8A222  MOVE.L     -27736(A5),-24030(A5)          ; A5-27736
02CE: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
02D4: C1EDA386      ANDA.L     -23674(A5),A0
02D8: 41EDA226      LEA        -24026(A5),A0                  ; g_common
02DC: D088          MOVE.B     A0,(A0)
02DE: 2040          MOVEA.L    D0,A0
02E0: 7001          MOVEQ      #1,D0
02E2: 4A40          TST.W      D0
02E4: 6602          BNE.S      $02E8
02E6: 7001          MOVEQ      #1,D0
02E8: 4CD8          DC.W       $4CD8
02EA: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
02EE: 206DDE78      MOVEA.L    -8584(A5),A0
02F2: 2050          MOVEA.L    (A0),A0
02F4: 317C0001030C  MOVE.W     #$0001,780(A0)
02FA: 206DDE78      MOVEA.L    -8584(A5),A0
02FE: 2050          MOVEA.L    (A0),A0
0300: 317C0001030E  MOVE.W     #$0001,782(A0)
0306: 206DDE78      MOVEA.L    -8584(A5),A0
030A: 2050          MOVEA.L    (A0),A0
030C: 317C0001030A  MOVE.W     #$0001,778(A0)
0312: 206DDE78      MOVEA.L    -8584(A5),A0
0316: 2050          MOVEA.L    (A0),A0
0318: 317C00010310  MOVE.W     #$0001,784(A0)
031E: 2F2DDE78      MOVE.L     -8584(A5),-(A7)                ; A5-8584
0322: 2F3C70726673  MOVE.L     #$70726673,-(A7)
0328: 4267          CLR.W      -(A7)
032A: 2F2DF248      MOVE.L     -3512(A5),-(A7)                ; A5-3512
032E: A9AB2F2DDE78  MOVE.L     12077(A3),120(A4,A5.L*8)
0334: A9AA4267A994  MOVE.L     16999(A2),-108(A4,A2.L)
033A: A9994E75      MOVE.L     (A1)+,117(A4,D4.L*8)
033E: 42A7          CLR.L      -(A7)
0340: 2F3C70726673  MOVE.L     #$70726673,-(A7)
0346: 4267          CLR.W      -(A7)
0348: A9A0201F      MOVE.L     -(A0),31(A4,D2.W)
034C: 2B40DE78      MOVE.L     D0,-8584(A5)
0350: 56C0          SNE        D0
0352: 4400          NEG.B      D0
0354: 4880          EXT.W      D0
0356: 4E75          RTS        


; ======= Function at 0x0358 =======
0358: 4E560000      LINK       A6,#0
035C: 206DDE78      MOVEA.L    -8584(A5),A0
0360: A0292F2E      MOVE.L     12078(A1),D0
0364: 0008206D      ORI.B      #$206D,A0
0368: DE782050      MOVEA.B    $2050.W,A7
036C: 4868032E      PEA        814(A0)
0370: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0374: 206DDE78      MOVEA.L    -8584(A5),A0
0378: A02A2EAD      MOVE.L     11949(A2),D0
037C: DE78A9AA      MOVEA.B    $A9AA.W,A7
0380: 4257          CLR.W      (A7)
0382: A994A999      MOVE.L     (A4),-103(A4,A2.L)
0386: 4E5E          UNLK       A6
0388: 4E75          RTS        

038A: 206DDE78      MOVEA.L    -8584(A5),A0
038E: 2050          MOVEA.L    (A0),A0
0390: 4A68030C      TST.W      780(A0)
0394: 57C0          SEQ        D0
0396: 4400          NEG.B      D0
0398: 4880          EXT.W      D0
039A: 206DDE78      MOVEA.L    -8584(A5),A0
039E: 2050          MOVEA.L    (A0),A0
03A0: 3140030C      MOVE.W     D0,780(A0)
03A4: 4EAD04F2      JSR        1266(A5)                       ; JT[1266]
03A8: 4E75          RTS        


; ======= Function at 0x03AA =======
03AA: 4E560000      LINK       A6,#0
03AE: 206DDE78      MOVEA.L    -8584(A5),A0
03B2: A029206D      MOVE.L     8301(A1),D0
03B6: DE782050      MOVEA.B    $2050.W,A7
03BA: 48680312      PEA        786(A0)
03BE: 2F2E0008      MOVE.L     8(A6),-(A7)
03C2: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
03C6: 206DDE78      MOVEA.L    -8584(A5),A0
03CA: A02A4E5E      MOVE.L     20062(A2),D0
03CE: 4E75          RTS        


; ======= Function at 0x03D0 =======
03D0: 4E560000      LINK       A6,#0
03D4: 206DDE78      MOVEA.L    -8584(A5),A0
03D8: A0292F2E      MOVE.L     12078(A1),D0
03DC: 0008206D      ORI.B      #$206D,A0
03E0: DE782050      MOVEA.B    $2050.W,A7
03E4: 48680312      PEA        786(A0)
03E8: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
03EC: 206DDE78      MOVEA.L    -8584(A5),A0
03F0: A02A4E5E      MOVE.L     20062(A2),D0
03F4: 4E75          RTS        


; ======= Function at 0x03F6 =======
03F6: 4E560000      LINK       A6,#0
03FA: 4EBAFD4E      JSR        -690(PC)
03FE: 4E5E          UNLK       A6
0400: 4E75          RTS        
