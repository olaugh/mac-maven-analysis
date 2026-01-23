;======================================================================
; CODE 12 Disassembly
; File: /tmp/maven_code_12.bin
; Header: JT offset=528, JT entries=8
; Code size: 2722 bytes
;======================================================================

0000: 48E70138      MOVEM.L    D7/A2/A3/A4,-(SP)              ; save
0004: 4EBA0824      JSR        2084(PC)
0008: 4EBA00F4      JSR        244(PC)
000C: 4EBA0134      JSR        308(PC)
0010: 4EBA01D6      JSR        470(PC)
0014: 4EBA0176      JSR        374(PC)
0018: 49EDDA00      LEA        -9728(A5),A4                   ; A5-9728
001C: 7E00          MOVEQ      #0,D7
001E: 47EDDC1E      LEA        -9186(A5),A3                   ; A5-9186
0022: 45EDDD1E      LEA        -8930(A5),A2                   ; A5-8930
0026: 6020          BRA.S      $0048
0028: 4A52          TST.W      (A2)
002A: 6604          BNE.S      $0030
002C: 4A53          TST.W      (A3)
002E: 6712          BEQ.S      $0042
0030: 0C47003F      CMPI.W     #$003F,D7
0034: 6702          BEQ.S      $0038
0036: 18C7          MOVE.B     D7,(A4)+
0038: 3012          MOVE.W     (A2),D0
003A: B053          MOVEA.W    (A3),A0
003C: 6F02          BLE.S      $0040
003E: 3692          MOVE.W     (A2),(A3)
0040: 4252          CLR.W      (A2)
0042: 5247          MOVEA.B    D7,A1
0044: 548B          MOVE.B     A3,(A2)
0046: 548A          MOVE.B     A2,(A2)
0048: 0C470080      CMPI.W     #$0080,D7
004C: 65DA          BCS.S      $0028
004E: 4214          CLR.B      (A4)
0050: 526DDD9C      MOVEA.B    -8804(A5),A1
0054: 4EBA01E8      JSR        488(PC)
0058: 4CDF1C80      MOVEM.L    (SP)+,D7/A2/A3/A4              ; restore
005C: 4E75          RTS        

005E: 4EBA07CA      JSR        1994(PC)
0062: 4EBA009A      JSR        154(PC)
0066: 4EBA00DA      JSR        218(PC)
006A: 4EBA017C      JSR        380(PC)
006E: 4EBA011C      JSR        284(PC)
0072: 4EBA01CA      JSR        458(PC)
0076: 4E75          RTS        


; ======= Function at 0x0078 =======
0078: 4E56FFF8      LINK       A6,#-8                         ; frame=8
007C: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
0080: 48780100      PEA        $0100.W
0084: 486DDD1E      PEA        -8930(A5)                      ; A5-8930
0088: 4EAD01AA      JSR        426(A5)                        ; JT[426]
008C: 48780100      PEA        $0100.W
0090: 486DDC1E      PEA        -9186(A5)                      ; A5-9186
0094: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0098: 7010          MOVEQ      #16,D0
009A: 2E80          MOVE.L     D0,(A7)
009C: 486DD9C0      PEA        -9792(A5)                      ; A5-9792
00A0: 4EAD01AA      JSR        426(A5)                        ; JT[426]
00A4: 7010          MOVEQ      #16,D0
00A6: 2E80          MOVE.L     D0,(A7)
00A8: 486DD9D0      PEA        -9776(A5)                      ; A5-9776
00AC: 4EAD01AA      JSR        426(A5)                        ; JT[426]
00B0: 7010          MOVEQ      #16,D0
00B2: 2E80          MOVE.L     D0,(A7)
00B4: 486DDA00      PEA        -9728(A5)                      ; A5-9728
00B8: 4EAD01AA      JSR        426(A5)                        ; JT[426]
00BC: 7020          MOVEQ      #32,D0
00BE: 2E80          MOVE.L     D0,(A7)
00C0: 486DD9E0      PEA        -9760(A5)                      ; A5-9760
00C4: 4EAD01AA      JSR        426(A5)                        ; JT[426]
00C8: 7E00          MOVEQ      #0,D7
00CA: 49EDDE28      LEA        -8664(A5),A4                   ; g_flag1
00CE: 4FEF0020      LEA        32(A7),A7
00D2: 6010          BRA.S      $00E4
00D4: 3F06          MOVE.W     D6,-(A7)
00D6: 4EAD0DEA      JSR        3562(A5)                       ; JT[3562]
00DA: 1D8070F8      MOVE.B     D0,-8(A6,D7.W)
00DE: 548F          MOVE.B     A7,(A2)
00E0: 5247          MOVEA.B    D7,A1
00E2: 588C          MOVE.B     A4,(A4)
00E4: 3C14          MOVE.W     (A4),D6
00E6: 66EC          BNE.S      $00D4
00E8: 423670F8      CLR.B      -8(A6,D7.W)
00EC: 486EFFF8      PEA        -8(A6)
00F0: 4EBA06C0      JSR        1728(PC)
00F4: 4CEE10C0FFEC  MOVEM.L    -20(A6),D6/D7/A4
00FA: 4E5E          UNLK       A6
00FC: 4E75          RTS        

00FE: 2F0C          MOVE.L     A4,-(A7)
0100: 48780100      PEA        $0100.W
0104: 486DDD1E      PEA        -8930(A5)                      ; A5-8930
0108: 4EAD01AA      JSR        426(A5)                        ; JT[426]
010C: 486DD9B0      PEA        -9808(A5)                      ; A5-9808
0110: 4EBA05EA      JSR        1514(PC)
0114: 486DD9B0      PEA        -9808(A5)                      ; A5-9808
0118: 486DD9B0      PEA        -9808(A5)                      ; A5-9808
011C: 4EAD07F2      JSR        2034(A5)                       ; JT[2034]
0120: 49EDD9B0      LEA        -9808(A5),A4                   ; A5-9808
0124: 4FEF0014      LEA        20(A7),A7
0128: 6010          BRA.S      $013A
012A: 1014          MOVE.B     (A4),D0
012C: 4880          EXT.W      D0
012E: 204D          MOVEA.L    A5,A0
0130: D0C0          MOVE.B     D0,(A0)+
0132: D0C0          MOVE.B     D0,(A0)+
0134: 5268DD1E      MOVEA.B    -8930(A0),A1
0138: 528C          MOVE.B     A4,(A1)
013A: 4A14          TST.B      (A4)
013C: 66EC          BNE.S      $012A
013E: 285F          MOVEA.L    (A7)+,A4
0140: 4E75          RTS        


; ======= Function at 0x0142 =======
0142: 4E56FF00      LINK       A6,#-256                       ; frame=256
0146: 2F0C          MOVE.L     A4,-(A7)
0148: 48780100      PEA        $0100.W
014C: 486DDC1E      PEA        -9186(A5)                      ; A5-9186
0150: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0154: 486DDA00      PEA        -9728(A5)                      ; A5-9728
0158: 4EBA05BA      JSR        1466(PC)
015C: 486DDA00      PEA        -9728(A5)                      ; A5-9728
0160: 486DDA00      PEA        -9728(A5)                      ; A5-9728
0164: 4EAD07F2      JSR        2034(A5)                       ; JT[2034]
0168: 49EDDA00      LEA        -9728(A5),A4                   ; A5-9728
016C: 4FEF0014      LEA        20(A7),A7
0170: 6010          BRA.S      $0182
0172: 1014          MOVE.B     (A4),D0
0174: 4880          EXT.W      D0
0176: 204D          MOVEA.L    A5,A0
0178: D0C0          MOVE.B     D0,(A0)+
017A: D0C0          MOVE.B     D0,(A0)+
017C: 5268DC1E      MOVEA.B    -9186(A0),A1
0180: 528C          MOVE.B     A4,(A1)
0182: 4A14          TST.B      (A4)
0184: 66EC          BNE.S      $0172
0186: 285F          MOVEA.L    (A7)+,A4
0188: 4E5E          UNLK       A6
018A: 4E75          RTS        


; ======= Function at 0x018C =======
018C: 4E56FF00      LINK       A6,#-256                       ; frame=256
0190: 2F0C          MOVE.L     A4,-(A7)
0192: 48780100      PEA        $0100.W
0196: 486DDB1E      PEA        -9442(A5)                      ; A5-9442
019A: 4EAD01AA      JSR        426(A5)                        ; JT[426]
019E: 486DD9D0      PEA        -9776(A5)                      ; A5-9776
01A2: 4EBA0588      JSR        1416(PC)
01A6: 486DD9D0      PEA        -9776(A5)                      ; A5-9776
01AA: 486DD9D0      PEA        -9776(A5)                      ; A5-9776
01AE: 4EAD07F2      JSR        2034(A5)                       ; JT[2034]
01B2: 49EDD9D0      LEA        -9776(A5),A4                   ; A5-9776
01B6: 4FEF0014      LEA        20(A7),A7
01BA: 6010          BRA.S      $01CC
01BC: 1014          MOVE.B     (A4),D0
01BE: 4880          EXT.W      D0
01C0: 204D          MOVEA.L    A5,A0
01C2: D0C0          MOVE.B     D0,(A0)+
01C4: D0C0          MOVE.B     D0,(A0)+
01C6: 5268DB1E      MOVEA.B    -9442(A0),A1
01CA: 528C          MOVE.B     A4,(A1)
01CC: 4A14          TST.B      (A4)
01CE: 66EC          BNE.S      $01BC
01D0: 426DDB9C      CLR.W      -9316(A5)
01D4: 486DD9D0      PEA        -9776(A5)                      ; A5-9776
01D8: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
01DC: 3B40DE1E      MOVE.W     D0,-8674(A5)
01E0: 286EFEFC      MOVEA.L    -260(A6),A4
01E4: 4E5E          UNLK       A6
01E6: 4E75          RTS        

01E8: 2F0C          MOVE.L     A4,-(A7)
01EA: 48780100      PEA        $0100.W
01EE: 486DDA1E      PEA        -9698(A5)                      ; A5-9698
01F2: 4EAD01AA      JSR        426(A5)                        ; JT[426]
01F6: 486DD9C0      PEA        -9792(A5)                      ; A5-9792
01FA: 4EBA059E      JSR        1438(PC)
01FE: 486DD9C0      PEA        -9792(A5)                      ; A5-9792
0202: 486DD9C0      PEA        -9792(A5)                      ; A5-9792
0206: 4EAD07F2      JSR        2034(A5)                       ; JT[2034]
020A: 49EDD9C0      LEA        -9792(A5),A4                   ; A5-9792
020E: 4FEF0014      LEA        20(A7),A7
0212: 6010          BRA.S      $0224
0214: 1014          MOVE.B     (A4),D0
0216: 4880          EXT.W      D0
0218: 204D          MOVEA.L    A5,A0
021A: D0C0          MOVE.B     D0,(A0)+
021C: D0C0          MOVE.B     D0,(A0)+
021E: 5268DA1E      MOVEA.B    -9698(A0),A1
0222: 528C          MOVE.B     A4,(A1)
0224: 4A14          TST.B      (A4)
0226: 66EC          BNE.S      $0214
0228: 426DDA9C      CLR.W      -9572(A5)
022C: 486DD9C0      PEA        -9792(A5)                      ; A5-9792
0230: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0234: 3B40DE20      MOVE.W     D0,-8672(A5)
0238: 588F          MOVE.B     A7,(A4)
023A: 285F          MOVEA.L    (A7)+,A4
023C: 4E75          RTS        

023E: 48E70300      MOVEM.L    D6/D7,-(SP)                    ; save
0242: 7C00          MOVEQ      #0,D6
0244: 604C          BRA.S      $0292
0246: 204D          MOVEA.L    A5,A0
0248: D0C6          MOVE.B     D6,(A0)+
024A: D0C6          MOVE.B     D6,(A0)+
024C: 224D          MOVEA.L    A5,A1
024E: D2C6          MOVE.B     D6,(A1)+
0250: D2C6          MOVE.B     D6,(A1)+
0252: 3E28DC1E      MOVE.W     -9186(A0),D7
0256: DE69DD1E      MOVEA.B    -8930(A1),A7
025A: 204D          MOVEA.L    A5,A0
025C: D0C6          MOVE.B     D6,(A0)+
025E: D0C6          MOVE.B     D6,(A0)+
0260: BE68DB1E      MOVEA.W    -9442(A0),A7
0264: 6C0A          BGE.S      $0270
0266: 204D          MOVEA.L    A5,A0
0268: D0C6          MOVE.B     D6,(A0)+
026A: D0C6          MOVE.B     D6,(A0)+
026C: 3E28DB1E      MOVE.W     -9442(A0),D7
0270: 204D          MOVEA.L    A5,A0
0272: D0C6          MOVE.B     D6,(A0)+
0274: D0C6          MOVE.B     D6,(A0)+
0276: BE68DA1E      MOVEA.W    -9698(A0),A7
027A: 6C0A          BGE.S      $0286
027C: 204D          MOVEA.L    A5,A0
027E: D0C6          MOVE.B     D6,(A0)+
0280: D0C6          MOVE.B     D6,(A0)+
0282: 3E28DA1E      MOVE.W     -9698(A0),D7
0286: 204D          MOVEA.L    A5,A0
0288: D0C6          MOVE.B     D6,(A0)+
028A: D0C6          MOVE.B     D6,(A0)+
028C: 3147DD1E      MOVE.W     D7,-8930(A0)
0290: 5246          MOVEA.B    D6,A1
0292: 0C460080      CMPI.W     #$0080,D6
0296: 65AE          BCS.S      $0246
0298: 4EBA03CA      JSR        970(PC)
029C: 4EBA00CA      JSR        202(PC)
02A0: 0C6D0008A386  CMPI.W     #$0008,-23674(A5)
02A6: 6406          BCC.S      $02AE
02A8: 4A6DA386      TST.W      -23674(A5)
02AC: 6C04          BGE.S      $02B2
02AE: 4EAD01A2      JSR        418(A5)                        ; JT[418]
02B2: 302DA386      MOVE.W     -23674(A5),D0                  ; A5-23674
02B6: 526DA386      MOVEA.B    -23674(A5),A1
02BA: C1FC002C41ED  ANDA.L     #$002C41ED,A0
02C0: A226          MOVE.L     -(A6),D1
02C2: D088          MOVE.B     A0,(A0)
02C4: 2040          MOVEA.L    D0,A0
02C6: 7000          MOVEQ      #0,D0
02C8: 43FA0006      LEA        6(PC),A1
02CC: 48D0          DC.W       $48D0
02CE: DEF84A40      MOVE.B     $4A40.W,(A7)+
02D2: 6642          BNE.S      $0316
02D4: 7C00          MOVEQ      #0,D6
02D6: 204D          MOVEA.L    A5,A0
02D8: 2006          MOVE.L     D6,D0
02DA: 48C0          EXT.L      D0
02DC: E788D1C0      MOVE.L     A0,-64(A3,A5.W)
02E0: 2B68D148D140  MOVE.L     -11960(A0),-11968(A5)
02E6: 3B46D548      MOVE.W     D6,-10936(A5)
02EA: 204D          MOVEA.L    A5,A0
02EC: 2006          MOVE.L     D6,D0
02EE: 48C0          EXT.L      D0
02F0: E788D1C0      MOVE.L     A0,-64(A3,A5.W)
02F4: 2B68D14CD144  MOVE.L     -11956(A0),-11964(A5)
02FA: 6714          BEQ.S      $0310
02FC: 3B46D548      MOVE.W     D6,-10936(A5)
0300: 42A7          CLR.L      -(A7)
0302: 2F2DD144      MOVE.L     -11964(A5),-(A7)               ; A5-11964
0306: 4EBA00A2      JSR        162(PC)
030A: 508F          MOVE.B     A7,(A0)
030C: 5246          MOVEA.B    D6,A1
030E: 60C6          BRA.S      $02D6
0310: 536DA3866048  MOVE.B     -23674(A5),24648(A1)           ; A5-23674
0316: 2F2DA222      MOVE.L     -24030(A5),-(A7)               ; A5-24030
031A: 2F2D93AC      MOVE.L     -27732(A5),-(A7)               ; A5-27732
031E: 4EAD0DB2      JSR        3506(A5)                       ; JT[3506]
0322: 4A40          TST.W      D0
0324: 508F          MOVE.B     A7,(A0)
0326: 6606          BNE.S      $032E
0328: 4EBA0444      JSR        1092(PC)
032C: 6030          BRA.S      $035E
032E: 4A6DA386      TST.W      -23674(A5)
0332: 6E04          BGT.S      $0338
0334: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0338: 2B6DA222A222  MOVE.L     -24030(A5),-24030(A5)          ; A5-24030
033E: 536DA386702C  MOVE.B     -23674(A5),28716(A1)           ; A5-23674
0344: C1EDA386      ANDA.L     -23674(A5),A0
0348: 41EDA226      LEA        -24026(A5),A0                  ; g_common
034C: D088          MOVE.B     A0,(A0)
034E: 2040          MOVEA.L    D0,A0
0350: 7001          MOVEQ      #1,D0
0352: 4A40          TST.W      D0
0354: 6602          BNE.S      $0358
0356: 7001          MOVEQ      #1,D0
0358: 4CD8          DC.W       $4CD8
035A: DEF84ED1      MOVE.B     $4ED1.W,(A7)+
035E: 4EBA06C4      JSR        1732(PC)
0362: 4CDF00C0      MOVEM.L    (SP)+,D6/D7                    ; restore
0366: 4E75          RTS        

0368: 41EDD9BF      LEA        -9793(A5),A0                   ; A5-9793
036C: 2B48DA10      MOVE.L     A0,-9712(A5)
0370: 43EDD9E0      LEA        -9760(A5),A1                   ; A5-9760
0374: 2B49DA14      MOVE.L     A1,-9708(A5)
0378: 422DD9E0      CLR.B      -9760(A5)
037C: 426DDA1C      CLR.W      -9700(A5)
0380: 426DDE22      CLR.W      -8670(A5)
0384: 4EBA03BE      JSR        958(PC)
0388: 4E75          RTS        


; ======= Function at 0x038A =======
038A: 4E560000      LINK       A6,#0
038E: 0C6D03E8DA1C  CMPI.W     #$03E8,-9700(A5)
0394: 6C10          BGE.S      $03A6
0396: 4EAD06CA      JSR        1738(A5)                       ; JT[1738]
039A: 2F2E0008      MOVE.L     8(A6),-(A7)
039E: 4EBA04F0      JSR        1264(PC)
03A2: 526DDA1C      MOVEA.B    -9700(A5),A1
03A6: 4E5E          UNLK       A6
03A8: 4E75          RTS        


; ======= Function at 0x03AA =======
03AA: 4E560000      LINK       A6,#0
03AE: 48E70F08      MOVEM.L    D4/D5/D6/D7/A4,-(SP)           ; save
03B2: 2C2E0008      MOVE.L     8(A6),D6
03B6: 0C6D03E8DA1C  CMPI.W     #$03E8,-9700(A5)
03BC: 6C0000D8      BGE.W      $0498
03C0: 52ADDA10      MOVE.B     -9712(A5),(A1)                 ; A5-9712
03C4: 206DDA10      MOVEA.L    -9712(A5),A0
03C8: 4A10          TST.B      (A0)
03CA: 6610          BNE.S      $03DC
03CC: 2F2E000C      MOVE.L     12(A6),-(A7)
03D0: 2F06          MOVE.L     D6,-(A7)
03D2: 4EBA00CA      JSR        202(PC)
03D6: 508F          MOVE.B     A7,(A0)
03D8: 600000B8      BRA.W      $0494
03DC: 4A86          TST.L      D6
03DE: 670000B2      BEQ.W      $0494
03E2: 2006          MOVE.L     D6,D0
03E4: 5286          MOVE.B     D6,(A1)
03E6: E588D0AD      MOVE.L     A0,-83(A2,A5.W)
03EA: D1402040      MOVE.B     D0,8256(A0)
03EE: 2A10          MOVE.L     (A0),D5
03F0: 1E05          MOVE.B     D5,D7
03F2: 4887          EXT.W      D7
03F4: 206DDA10      MOVEA.L    -9712(A5),A0
03F8: 1810          MOVE.B     (A0),D4
03FA: 0C04003F      CMPI.B     #$003F,D4
03FE: 670A          BEQ.S      $040A
0400: 1004          MOVE.B     D4,D0
0402: 4880          EXT.W      D0
0404: B047          MOVEA.W    D7,A0
0406: 66000082      BNE.W      $048C
040A: 49EDDD1E      LEA        -8930(A5),A4                   ; A5-8930
040E: D8C7          MOVE.B     D7,(A4)+
0410: D8C7          MOVE.B     D7,(A4)+
0412: 4A54          TST.W      (A4)
0414: 6F32          BLE.S      $0448
0416: 5354206D      MOVE.B     (A4),8301(A1)
041A: DA14          MOVE.B     (A4),D5
041C: 52ADDA14      MOVE.B     -9708(A5),(A1)                 ; A5-9708
0420: 1087          MOVE.B     D7,(A0)
0422: 2005          MOVE.L     D5,D0
0424: 028000000100  ANDI.L     #$00000100,D0
042A: 2F00          MOVE.L     D0,-(A7)
042C: 2005          MOVE.L     D5,D0
042E: 720A          MOVEQ      #10,D1
0430: E2A82F00      MOVE.L     12032(A0),(A1)
0434: 4EBAFF74      JSR        -140(PC)
0438: 206DDA14      MOVEA.L    -9708(A5),A0
043C: 53ADDA144210  MOVE.B     -9708(A5),16(A1,D4.W*2)        ; A5-9708
0442: 5254          MOVEA.B    (A4),A1
0444: 508F          MOVE.B     A7,(A0)
0446: 6042          BRA.S      $048A
0448: 4A6DDD9C      TST.W      -8804(A5)
044C: 6F3C          BLE.S      $048A
044E: 206DDA14      MOVEA.L    -9708(A5),A0
0452: 52ADDA14      MOVE.B     -9708(A5),(A1)                 ; A5-9708
0456: 1087          MOVE.B     D7,(A0)
0458: 536DDD9C526D  MOVE.B     -8804(A5),21101(A1)            ; A5-8804
045E: DE22          MOVE.B     -(A2),D7
0460: 2005          MOVE.L     D5,D0
0462: 028000000100  ANDI.L     #$00000100,D0
0468: 2F00          MOVE.L     D0,-(A7)
046A: 2005          MOVE.L     D5,D0
046C: 720A          MOVEQ      #10,D1
046E: E2A82F00      MOVE.L     12032(A0),(A1)
0472: 4EBAFF36      JSR        -202(PC)
0476: 536DDE22526D  MOVE.B     -8670(A5),21101(A1)            ; A5-8670
047C: DD9C206D      MOVE.B     (A4)+,109(A6,D2.W)
0480: DA14          MOVE.B     (A4),D5
0482: 53ADDA144210  MOVE.B     -9708(A5),16(A1,D4.W*2)        ; A5-9708
0488: 508F          MOVE.B     A7,(A0)
048A: 08050009      BTST       #9,D5
048E: 6700FF52      BEQ.W      $03E4
0492: 53ADDA104CDF  MOVE.B     -9712(A5),-33(A1,D4.L*4)       ; A5-9712
0498: 10F04E5E      MOVE.B     94(A0,D4.L*8),(A0)+
049C: 4E75          RTS        


; ======= Function at 0x049E =======
049E: 4E560000      LINK       A6,#0
04A2: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
04A6: 4AAE000C      TST.L      12(A6)
04AA: 6728          BEQ.S      $04D4
04AC: 4EBA00DE      JSR        222(PC)
04B0: 4A40          TST.W      D0
04B2: 6720          BEQ.S      $04D4
04B4: 4EBA0118      JSR        280(PC)
04B8: 4A40          TST.W      D0
04BA: 6718          BEQ.S      $04D4
04BC: 486DD9E0      PEA        -9760(A5)                      ; A5-9760
04C0: 4EAD0322      JSR        802(A5)                        ; JT[802]
04C4: 4A40          TST.W      D0
04C6: 588F          MOVE.B     A7,(A4)
04C8: 660A          BNE.S      $04D4
04CA: 486DD9E0      PEA        -9760(A5)                      ; A5-9760
04CE: 4EBAFEBA      JSR        -326(PC)
04D2: 588F          MOVE.B     A7,(A4)
04D4: 4AAE0008      TST.L      8(A6)
04D8: 670000AA      BEQ.W      $0586
04DC: 0C6D03E8DA1C  CMPI.W     #$03E8,-9700(A5)
04E2: 6C0000A0      BGE.W      $0586
04E6: 202E0008      MOVE.L     8(A6),D0
04EA: 52AE0008      MOVE.B     8(A6),(A1)
04EE: E588D0AD      MOVE.L     A0,-83(A2,A5.W)
04F2: D1402040      MOVE.B     D0,8256(A0)
04F6: 2C10          MOVE.L     (A0),D6
04F8: 1E06          MOVE.B     D6,D7
04FA: 4887          EXT.W      D7
04FC: 49EDDD1E      LEA        -8930(A5),A4                   ; A5-8930
0500: D8C7          MOVE.B     D7,(A4)+
0502: D8C7          MOVE.B     D7,(A4)+
0504: 4A54          TST.W      (A4)
0506: 6F32          BLE.S      $053A
0508: 5354206D      MOVE.B     (A4),8301(A1)
050C: DA14          MOVE.B     (A4),D5
050E: 52ADDA14      MOVE.B     -9708(A5),(A1)                 ; A5-9708
0512: 1087          MOVE.B     D7,(A0)
0514: 2006          MOVE.L     D6,D0
0516: 028000000100  ANDI.L     #$00000100,D0
051C: 2F00          MOVE.L     D0,-(A7)
051E: 2006          MOVE.L     D6,D0
0520: 720A          MOVEQ      #10,D1
0522: E2A82F00      MOVE.L     12032(A0),(A1)
0526: 4EBAFF76      JSR        -138(PC)
052A: 206DDA14      MOVEA.L    -9708(A5),A0
052E: 53ADDA144210  MOVE.B     -9708(A5),16(A1,D4.W*2)        ; A5-9708
0534: 5254          MOVEA.B    (A4),A1
0536: 508F          MOVE.B     A7,(A0)
0538: 6042          BRA.S      $057C
053A: 4A6DDD9C      TST.W      -8804(A5)
053E: 6F3C          BLE.S      $057C
0540: 206DDA14      MOVEA.L    -9708(A5),A0
0544: 52ADDA14      MOVE.B     -9708(A5),(A1)                 ; A5-9708
0548: 1087          MOVE.B     D7,(A0)
054A: 536DDD9C526D  MOVE.B     -8804(A5),21101(A1)            ; A5-8804
0550: DE22          MOVE.B     -(A2),D7
0552: 2006          MOVE.L     D6,D0
0554: 028000000100  ANDI.L     #$00000100,D0
055A: 2F00          MOVE.L     D0,-(A7)
055C: 2006          MOVE.L     D6,D0
055E: 720A          MOVEQ      #10,D1
0560: E2A82F00      MOVE.L     12032(A0),(A1)
0564: 4EBAFF38      JSR        -200(PC)
0568: 536DDE22526D  MOVE.B     -8670(A5),21101(A1)            ; A5-8670
056E: DD9C206D      MOVE.B     (A4)+,109(A6,D2.W)
0572: DA14          MOVE.B     (A4),D5
0574: 53ADDA144210  MOVE.B     -9708(A5),16(A1,D4.W*2)        ; A5-9708
057A: 508F          MOVE.B     A7,(A0)
057C: 08060009      BTST       #9,D6
0580: 6700FF64      BEQ.W      $04E8
0584: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
0588: 4E5E          UNLK       A6
058A: 4E75          RTS        

058C: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0590: 306DDE1E      MOVEA.W    -8674(A5),A0
0594: 202DDA14      MOVE.L     -9708(A5),D0                   ; A5-9708
0598: 9088          MOVE.B     A0,(A0)
059A: 2840          MOVEA.L    D0,A4
059C: 41EDD9E0      LEA        -9760(A5),A0                   ; A5-9760
05A0: B1CC6304      MOVE.W     A4,$6304.W
05A4: 7000          MOVEQ      #0,D0
05A6: 6020          BRA.S      $05C8
05A8: 47EDD9D0      LEA        -9776(A5),A3                   ; A5-9776
05AC: 1E13          MOVE.B     (A3),D7
05AE: 4A07          TST.B      D7
05B0: 6714          BEQ.S      $05C6
05B2: 0C07003F      CMPI.B     #$003F,D7
05B6: 6708          BEQ.S      $05C0
05B8: BE14          MOVE.W     (A4),D7
05BA: 6704          BEQ.S      $05C0
05BC: 7000          MOVEQ      #0,D0
05BE: 6008          BRA.S      $05C8
05C0: 528B          MOVE.B     A3,(A1)
05C2: 528C          MOVE.B     A4,(A1)
05C4: 60E6          BRA.S      $05AC
05C6: 7001          MOVEQ      #1,D0
05C8: 4CDF1880      MOVEM.L    (SP)+,D7/A3/A4                 ; restore
05CC: 4E75          RTS        

05CE: 48E70108      MOVEM.L    D7/A4,-(SP)                    ; save
05D2: 49EDD9E0      LEA        -9760(A5),A4                   ; A5-9760
05D6: 6010          BRA.S      $05E8
05D8: 1014          MOVE.B     (A4),D0
05DA: 4880          EXT.W      D0
05DC: 204D          MOVEA.L    A5,A0
05DE: D0C0          MOVE.B     D0,(A0)+
05E0: D0C0          MOVE.B     D0,(A0)+
05E2: 5268E148      MOVEA.B    -7864(A0),A1
05E6: 528C          MOVE.B     A4,(A1)
05E8: 4A14          TST.B      (A4)
05EA: 66EC          BNE.S      $05D8
05EC: 41EDD9E0      LEA        -9760(A5),A0                   ; A5-9760
05F0: 2E0C          MOVE.L     A4,D7
05F2: 9E88          MOVE.B     A0,(A7)
05F4: BE6DDA18      MOVEA.W    -9704(A5),A7
05F8: 6D46          BLT.S      $0640
05FA: BE6DDA1A      MOVEA.W    -9702(A5),A7
05FE: 6E40          BGT.S      $0640
0600: 302DDE22      MOVE.W     -8670(A5),D0                   ; A5-8670
0604: B06DDC9C      MOVEA.W    -9060(A5),A0
0608: 6D36          BLT.S      $0640
060A: 49EDDA00      LEA        -9728(A5),A4                   ; A5-9728
060E: 1E14          MOVE.B     (A4),D7
0610: 4A07          TST.B      D7
0612: 6722          BEQ.S      $0636
0614: 1007          MOVE.B     D7,D0
0616: 4880          EXT.W      D0
0618: 204D          MOVEA.L    A5,A0
061A: D0C0          MOVE.B     D0,(A0)+
061C: D0C0          MOVE.B     D0,(A0)+
061E: 1007          MOVE.B     D7,D0
0620: 4880          EXT.W      D0
0622: 224D          MOVEA.L    A5,A1
0624: D2C0          MOVE.B     D0,(A1)+
0626: D2C0          MOVE.B     D0,(A1)+
0628: 3028E148      MOVE.W     -7864(A0),D0
062C: B069DC1E      MOVEA.W    -9186(A1),A0
0630: 6D04          BLT.S      $0636
0632: 528C          MOVE.B     A4,(A1)
0634: 60D8          BRA.S      $060E
0636: 4A14          TST.B      (A4)
0638: 57C7          SEQ        D7
063A: 4407          NEG.B      D7
063C: 4887          EXT.W      D7
063E: 6002          BRA.S      $0642
0640: 7E00          MOVEQ      #0,D7
0642: 49EDD9E0      LEA        -9760(A5),A4                   ; A5-9760
0646: 6010          BRA.S      $0658
0648: 1014          MOVE.B     (A4),D0
064A: 4880          EXT.W      D0
064C: 204D          MOVEA.L    A5,A0
064E: D0C0          MOVE.B     D0,(A0)+
0650: D0C0          MOVE.B     D0,(A0)+
0652: 4268E148      CLR.W      -7864(A0)
0656: 528C          MOVE.B     A4,(A1)
0658: 4A14          TST.B      (A4)
065A: 66EC          BNE.S      $0648
065C: 3007          MOVE.W     D7,D0
065E: 4CDF1080      MOVEM.L    (SP)+,D7/A4                    ; restore
0662: 4E75          RTS        

0664: 4EAD06AA      JSR        1706(A5)                       ; JT[1706]
0668: 4E75          RTS        


; ======= Function at 0x066A =======
066A: 4E560000      LINK       A6,#0
066E: 4EBAF990      JSR        -1648(PC)
0672: 4E5E          UNLK       A6
0674: 4E75          RTS        


; ======= Function at 0x0676 =======
0676: 4E560000      LINK       A6,#0
067A: 4EBAF9E2      JSR        -1566(PC)
067E: 4E5E          UNLK       A6
0680: 4E75          RTS        


; ======= Function at 0x0682 =======
0682: 4E560000      LINK       A6,#0
0686: 2F0C          MOVE.L     A4,-(A7)
0688: 286E0008      MOVEA.L    8(A6),A4
068C: 2F2E000C      MOVE.L     12(A6),-(A7)
0690: 2F0C          MOVE.L     A4,-(A7)
0692: 4EAD0D0A      JSR        3338(A5)                       ; JT[3338]
0696: 2EADA1FA      MOVE.L     -24070(A5),(A7)                ; A5-24070
069A: 3F3C0002      MOVE.W     #$0002,-(A7)
069E: 2F0C          MOVE.L     A4,-(A7)
06A0: 4EAD0CD2      JSR        3282(A5)                       ; JT[3282]
06A4: 2EADA1FA      MOVE.L     -24070(A5),(A7)                ; A5-24070
06A8: 3F3C0003      MOVE.W     #$0003,-(A7)
06AC: 2F0C          MOVE.L     A4,-(A7)
06AE: 4EAD0CD2      JSR        3282(A5)                       ; JT[3282]
06B2: 2EADA1FA      MOVE.L     -24070(A5),(A7)                ; A5-24070
06B6: 3F3C0004      MOVE.W     #$0004,-(A7)
06BA: 2F0C          MOVE.L     A4,-(A7)
06BC: 4EAD0CD2      JSR        3282(A5)                       ; JT[3282]
06C0: 2EADA1FA      MOVE.L     -24070(A5),(A7)                ; A5-24070
06C4: 3F3C0005      MOVE.W     #$0005,-(A7)
06C8: 2F0C          MOVE.L     A4,-(A7)
06CA: 4EAD0CD2      JSR        3282(A5)                       ; JT[3282]
06CE: 2EADA1F6      MOVE.L     -24074(A5),(A7)                ; A5-24074
06D2: 3F3C000B      MOVE.W     #$000B,-(A7)
06D6: 2F0C          MOVE.L     A4,-(A7)
06D8: 4EAD0CD2      JSR        3282(A5)                       ; JT[3282]
06DC: 2EADA1F6      MOVE.L     -24074(A5),(A7)                ; A5-24074
06E0: 3F3C000D      MOVE.W     #$000D,-(A7)
06E4: 2F0C          MOVE.L     A4,-(A7)
06E6: 4EAD0CD2      JSR        3282(A5)                       ; JT[3282]
06EA: 286EFFFC      MOVEA.L    -4(A6),A4
06EE: 4E5E          UNLK       A6
06F0: 4E75          RTS        


; ======= Function at 0x06F2 =======
06F2: 4E560000      LINK       A6,#0
06F6: 7001          MOVEQ      #1,D0
06F8: 4E5E          UNLK       A6
06FA: 4E75          RTS        


; ======= Function at 0x06FC =======
06FC: 4E560000      LINK       A6,#0
0700: 2F2E0008      MOVE.L     8(A6),-(A7)
0704: 3F3C0002      MOVE.W     #$0002,-(A7)
0708: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
070C: 4EAD0642      JSR        1602(A5)                       ; JT[1602]
0710: 4E5E          UNLK       A6
0712: 4E75          RTS        


; ======= Function at 0x0714 =======
0714: 4E560000      LINK       A6,#0
0718: 2F2E0008      MOVE.L     8(A6),-(A7)
071C: 3F3C0003      MOVE.W     #$0003,-(A7)
0720: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
0724: 4EAD0642      JSR        1602(A5)                       ; JT[1602]
0728: 4E5E          UNLK       A6
072A: 4E75          RTS        


; ======= Function at 0x072C =======
072C: 4E560000      LINK       A6,#0
0730: 2F2E0008      MOVE.L     8(A6),-(A7)
0734: 3F3C0005      MOVE.W     #$0005,-(A7)
0738: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
073C: 4EAD0642      JSR        1602(A5)                       ; JT[1602]
0740: 4E5E          UNLK       A6
0742: 4E75          RTS        

0744: 3F3C000F      MOVE.W     #$000F,-(A7)
0748: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
074C: 4EAD05F2      JSR        1522(A5)                       ; JT[1522]
0750: 2E80          MOVE.L     D0,(A7)
0752: 486DE248      PEA        -7608(A5)                      ; A5-7608
0756: A95B2F2D      MOVE.L     (A3)+,12077(A4)
075A: A1D23F3C      MOVE.L     (A2),$3F3C.W
075E: 00102F2D      ORI.B      #$2F2D,(A0)
0762: DEB44EAD      MOVE.B     -83(A4,D4.L*8),(A7)
0766: 0CDA          DC.W       $0CDA
0768: 4FEF000C      LEA        12(A7),A7
076C: 4E75          RTS        

076E: 486DE2A0      PEA        -7520(A5)                      ; A5-7520
0772: 48780001      PEA        $0001.W
0776: 206DDEB4      MOVEA.L    -8524(A5),A0
077A: 2F2800A0      MOVE.L     160(A0),-(A7)
077E: A9DE2F2D93AC  MOVE.L     (A6)+,#$2F2D93AC
0784: 2F2D93AC      MOVE.L     -27732(A5),-(A7)               ; A5-27732
0788: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
078C: 2E80          MOVE.L     D0,(A7)
078E: 206DDEB4      MOVEA.L    -8524(A5),A0
0792: 2F2800A0      MOVE.L     160(A0),-(A7)
0796: A9DE4E754E56  MOVE.L     (A6)+,#$4E754E56
079C: 00002F2E      ORI.B      #$2F2E,D0
07A0: 00083F3C      ORI.B      #$3F3C,A0
07A4: 00042F2D      ORI.B      #$2F2D,D4
07A8: DEB44EAD      MOVE.B     -83(A4,D4.L*8),(A7)
07AC: 06424E5E      ADDI.W     #$4E5E,D2
07B0: 4E75          RTS        


; ======= Function at 0x07B2 =======
07B2: 4E560000      LINK       A6,#0
07B6: 486DE2A2      PEA        -7518(A5)                      ; A5-7518
07BA: 3F3C000B      MOVE.W     #$000B,-(A7)
07BE: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
07C2: 4EAD0CDA      JSR        3290(A5)                       ; JT[3290]
07C6: 486DE2A4      PEA        -7516(A5)                      ; A5-7516
07CA: 3F3C000D      MOVE.W     #$000D,-(A7)
07CE: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
07D2: 4EAD0CDA      JSR        3290(A5)                       ; JT[3290]
07D6: 2EADA1D2      MOVE.L     -24110(A5),(A7)                ; A5-24110
07DA: 3F3C0003      MOVE.W     #$0003,-(A7)
07DE: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
07E2: 4EAD0CDA      JSR        3290(A5)                       ; JT[3290]
07E6: 2EADA1D2      MOVE.L     -24110(A5),(A7)                ; A5-24110
07EA: 3F3C0004      MOVE.W     #$0004,-(A7)
07EE: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
07F2: 4EAD0CDA      JSR        3290(A5)                       ; JT[3290]
07F6: 2EADA1D2      MOVE.L     -24110(A5),(A7)                ; A5-24110
07FA: 3F3C0005      MOVE.W     #$0005,-(A7)
07FE: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
0802: 4EAD0CDA      JSR        3290(A5)                       ; JT[3290]
0806: 2EADA1D2      MOVE.L     -24110(A5),(A7)                ; A5-24110
080A: 3F3C0010      MOVE.W     #$0010,-(A7)
080E: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
0812: 4EAD0CDA      JSR        3290(A5)                       ; JT[3290]
0816: 2EAE0008      MOVE.L     8(A6),(A7)
081A: 3F3C0002      MOVE.W     #$0002,-(A7)
081E: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
0822: 4EAD0CDA      JSR        3290(A5)                       ; JT[3290]
0826: 4E5E          UNLK       A6
0828: 4E75          RTS        


; ======= Function at 0x082A =======
082A: 4E56FF00      LINK       A6,#-256                       ; frame=256
082E: 486EFF00      PEA        -256(A6)
0832: 3F3C000B      MOVE.W     #$000B,-(A7)
0836: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
083A: 4EAD0642      JSR        1602(A5)                       ; JT[1602]
083E: 426DDA18      CLR.W      -9704(A5)
0842: 486DDA18      PEA        -9704(A5)                      ; A5-9704
0846: 2F2DA1BA      MOVE.L     -24134(A5),-(A7)               ; A5-24134
084A: 486EFF00      PEA        -256(A6)
084E: 4EAD081A      JSR        2074(A5)                       ; JT[2074]
0852: 486EFF00      PEA        -256(A6)
0856: 3F3C000D      MOVE.W     #$000D,-(A7)
085A: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
085E: 4EAD0642      JSR        1602(A5)                       ; JT[1602]
0862: 3B7C000FDA1A  MOVE.W     #$000F,-9702(A5)
0868: 486DDA1A      PEA        -9702(A5)                      ; A5-9702
086C: 2F2DA1BA      MOVE.L     -24134(A5),-(A7)               ; A5-24134
0870: 486EFF00      PEA        -256(A6)
0874: 4EAD081A      JSR        2074(A5)                       ; JT[2074]
0878: 302DDA1A      MOVE.W     -9702(A5),D0                   ; A5-9702
087C: B06DDA18      MOVEA.W    -9704(A5),A0
0880: 4FEF002C      LEA        44(A7),A7
0884: 6C06          BGE.S      $088C
0886: 3B7C000FDA1A  MOVE.W     #$000F,-9702(A5)
088C: 4E5E          UNLK       A6
088E: 4E75          RTS        


; ======= Function at 0x0890 =======
0890: 4E56FF80      LINK       A6,#-128                       ; frame=128
0894: 2F07          MOVE.L     D7,-(A7)
0896: 2F2E0008      MOVE.L     8(A6),-(A7)
089A: 486DE2A8      PEA        -7512(A5)                      ; A5-7512
089E: 486EFF80      PEA        -128(A6)
08A2: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
08A6: 48C0          EXT.L      D0
08A8: 2E00          MOVE.L     D0,D7
08AA: 486EFF80      PEA        -128(A6)
08AE: 2F07          MOVE.L     D7,-(A7)
08B0: 206DDEB4      MOVEA.L    -8524(A5),A0
08B4: 2F2800A0      MOVE.L     160(A0),-(A7)
08B8: A9DE302DDA1C  MOVE.L     (A6)+,#$302DDA1C
08BE: 48C0          EXT.L      D0
08C0: 81FC00034840  ORA.L      #$00034840,A0
08C6: 55404FEF      MOVE.B     D0,20463(A2)
08CA: 000C6612      ORI.B      #$6612,A4
08CE: 486DE2AE      PEA        -7506(A5)                      ; A5-7506
08D2: 48780001      PEA        $0001.W
08D6: 206DDEB4      MOVEA.L    -8524(A5),A0
08DA: 2F2800A0      MOVE.L     160(A0),-(A7)
08DE: A9DE206DDEB4  MOVE.L     (A6)+,#$206DDEB4
08E4: 2F2800A0      MOVE.L     160(A0),-(A7)
08E8: A811          MOVE.L     (A1),D4
08EA: 2E1F          MOVE.L     (A7)+,D7
08EC: 4E5E          UNLK       A6
08EE: 4E75          RTS        


; ======= Function at 0x08F0 =======
08F0: 4E560000      LINK       A6,#0
08F4: 48E70708      MOVEM.L    D5/D6/D7/A4,-(SP)              ; save
08F8: 206DDEB4      MOVEA.L    -8524(A5),A0
08FC: 286800A0      MOVEA.L    160(A0),A4
0900: 2F0C          MOVE.L     A4,-(A7)
0902: 4EAD075A      JSR        1882(A5)                       ; JT[1882]
0906: 3E00          MOVE.W     D0,D7
0908: 4257          CLR.W      (A7)
090A: 2F2E0008      MOVE.L     8(A6),-(A7)
090E: A9603C1F      MOVE.L     -(A0),15391(A4)
0912: 2054          MOVEA.L    (A4),A0
0914: 3A280018      MOVE.W     24(A0),D5
0918: 548F          MOVE.B     A7,(A2)
091A: 6002          BRA.S      $091E
091C: 53463006      MOVE.B     D6,12294(A1)
0920: 9047          MOVEA.B    D7,A0
0922: 48C0          EXT.L      D0
0924: 81C5          ORA.L      D5,A0
0926: 4840          PEA        D0
0928: 4A40          TST.W      D0
092A: 66F0          BNE.S      $091C
092C: 2F2E0008      MOVE.L     8(A6),-(A7)
0930: 3F06          MOVE.W     D6,-(A7)
0932: A9634267      MOVE.L     -(A3),16999(A4)
0936: 3007          MOVE.W     D7,D0
0938: 9046          MOVEA.B    D6,A0
093A: 3F00          MOVE.W     D0,-(A7)
093C: 2F0C          MOVE.L     A4,-(A7)
093E: A812          MOVE.L     (A2),D4
0940: 4CDF10E0      MOVEM.L    (SP)+,D5/D6/D7/A4              ; restore
0944: 4E5E          UNLK       A6
0946: 4E75          RTS        


; ======= Function at 0x0948 =======
0948: 4E560000      LINK       A6,#0
094C: 48E70338      MOVEM.L    D6/D7/A2/A3/A4,-(SP)           ; save
0950: 2E2E000A      MOVE.L     10(A6),D7
0954: 7C00          MOVEQ      #0,D6
0956: 206DDEB4      MOVEA.L    -8524(A5),A0
095A: 286800A0      MOVEA.L    160(A0),A4
095E: 302E0008      MOVE.W     8(A6),D0
0962: 6B4E          BMI.S      $09B2
0964: 04400016      SUBI.W     #$0016,D0
0968: 6722          BEQ.S      $098C
096A: 6A08          BPL.S      $0974
096C: 5440          MOVEA.B    D0,A2
096E: 670A          BEQ.S      $097A
0970: 6A12          BPL.S      $0984
0972: 603E          BRA.S      $09B2
0974: 55406A3A      MOVE.B     D0,27194(A2)
0978: 6026          BRA.S      $09A0
097A: 2054          MOVEA.L    (A4),A0
097C: 3C280018      MOVE.W     24(A0),D6
0980: 4446          NEG.W      D6
0982: 602E          BRA.S      $09B2
0984: 2054          MOVEA.L    (A4),A0
0986: 3C280018      MOVE.W     24(A0),D6
098A: 6026          BRA.S      $09B2
098C: 7008          MOVEQ      #8,D0
098E: D094          MOVE.B     (A4),(A0)
0990: 2640          MOVEA.L    D0,A3
0992: 2454          MOVEA.L    (A4),A2
0994: 3C2A0018      MOVE.W     24(A2),D6
0998: DC53          MOVEA.B    (A3),A6
099A: 9C6B0004      MOVEA.B    4(A3),A6
099E: 6012          BRA.S      $09B2
09A0: 7008          MOVEQ      #8,D0
09A2: D094          MOVE.B     (A4),(A0)
09A4: 2640          MOVEA.L    D0,A3
09A6: 2454          MOVEA.L    (A4),A2
09A8: 3C2B0004      MOVE.W     4(A3),D6
09AC: 9C53          MOVEA.B    (A3),A6
09AE: 9C6A0018      MOVEA.B    24(A2),A6
09B2: 2F07          MOVE.L     D7,-(A7)
09B4: 4267          CLR.W      -(A7)
09B6: 2F07          MOVE.L     D7,-(A7)
09B8: A960301F      MOVE.L     -(A0),12319(A4)
09BC: D046          MOVEA.B    D6,A0
09BE: 3F00          MOVE.W     D0,-(A7)
09C0: A9632F07      MOVE.L     -(A3),12039(A4)
09C4: 4EBAFF2A      JSR        -214(PC)
09C8: 4CEE1CC0FFEC  MOVEM.L    -20(A6),D6/D7/A2/A3/A4
09CE: 4E5E          UNLK       A6
09D0: 205F          MOVEA.L    (A7)+,A0
09D2: 5C8F          MOVE.B     A7,(A6)
09D4: 4ED0          JMP        (A0)

; ======= Function at 0x09D6 =======
09D6: 4E560000      LINK       A6,#0
09DA: 0C6E0081000C  CMPI.W     #$0081,12(A6)
09E0: 6604          BNE.S      $09E6
09E2: 7000          MOVEQ      #0,D0
09E4: 6006          BRA.S      $09EC
09E6: 41ED0252      LEA        594(A5),A0                     ; A5+594
09EA: 2008          MOVE.L     A0,D0
09EC: 4E5E          UNLK       A6
09EE: 4E75          RTS        


; ======= Function at 0x09F0 =======
09F0: 4E560000      LINK       A6,#0
09F4: 2F2E0008      MOVE.L     8(A6),-(A7)
09F8: 4EBAFEF6      JSR        -266(PC)
09FC: 4E5E          UNLK       A6
09FE: 4E75          RTS        

0A00: 486DF2BC      PEA        -3396(A5)                      ; A5-3396
0A04: A851          MOVEA.L    (A1),A4
0A06: 4E75          RTS        


; ======= Function at 0x0A08 =======
0A08: 4E560000      LINK       A6,#0
0A0C: 2F2DDEB4      MOVE.L     -8524(A5),-(A7)                ; A5-8524
0A10: 4EAD0C3A      JSR        3130(A5)                       ; JT[3130]
0A14: 2EADDEB4      MOVE.L     -8524(A5),(A7)                 ; A5-8524
0A18: 4EAD0C1A      JSR        3098(A5)                       ; JT[3098]
0A1C: 4EBAF65A      JSR        -2470(PC)
0A20: 4E5E          UNLK       A6
0A22: 4E75          RTS        


; ======= Function at 0x0A24 =======
0A24: 4E56FF80      LINK       A6,#-128                       ; frame=128
0A28: 2F07          MOVE.L     D7,-(A7)
0A2A: 3F2DDA1C      MOVE.W     -9700(A5),-(A7)                ; A5-9700
0A2E: 486DE2B0      PEA        -7504(A5)                      ; A5-7504
0A32: 486EFF80      PEA        -128(A6)
0A36: 4EAD0812      JSR        2066(A5)                       ; JT[2066]
0A3A: 48C0          EXT.L      D0
0A3C: 2E00          MOVE.L     D0,D7
0A3E: 486EFF80      PEA        -128(A6)
0A42: 2F07          MOVE.L     D7,-(A7)
0A44: 206DDEB4      MOVEA.L    -8524(A5),A0
0A48: 2F2800A0      MOVE.L     160(A0),-(A7)
0A4C: A9DE0C6D03E8  MOVE.L     (A6)+,#$0C6D03E8
0A52: DA1C          MOVE.B     (A4)+,D5
0A54: 4FEF000A      LEA        10(A7),A7
0A58: 6D18          BLT.S      $0A72
0A5A: 2F2DA1EE      MOVE.L     -24082(A5),-(A7)               ; A5-24082
0A5E: 2F2DA1EE      MOVE.L     -24082(A5),-(A7)               ; A5-24082
0A62: 4EAD0DC2      JSR        3522(A5)                       ; JT[3522]
0A66: 2E80          MOVE.L     D0,(A7)
0A68: 206DDEB4      MOVEA.L    -8524(A5),A0
0A6C: 2F2800A0      MOVE.L     160(A0),-(A7)
0A70: A9DE206DDEB4  MOVE.L     (A6)+,#$206DDEB4
0A76: 2F2800A0      MOVE.L     160(A0),-(A7)
0A7A: A811          MOVE.L     (A1),D4
0A7C: 206DDEB4      MOVEA.L    -8524(A5),A0
0A80: 2F2800A0      MOVE.L     160(A0),-(A7)
0A84: 3F3C000F      MOVE.W     #$000F,-(A7)
0A88: 2F08          MOVE.L     A0,-(A7)
0A8A: 4EAD05F2      JSR        1522(A5)                       ; JT[1522]
0A8E: 548F          MOVE.B     A7,(A2)
0A90: 2E80          MOVE.L     D0,(A7)
0A92: 4EAD06EA      JSR        1770(A5)                       ; JT[1770]
0A96: 4EAD06B2      JSR        1714(A5)                       ; JT[1714]
0A9A: 2E2EFF7C      MOVE.L     -132(A6),D7
0A9E: 4E5E          UNLK       A6
0AA0: 4E75          RTS        
