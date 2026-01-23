;======================================================================
; CODE 40 Disassembly
; File: /tmp/maven_code_40.bin
; Header: JT offset=2640, JT entries=4
; Code size: 624 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E560000      LINK       A6,#0
0004: 48E70118      MOVEM.L    D7/A3/A4,-(SP)                 ; save
0008: 286E0008      MOVEA.L    8(A6),A4
000C: 2F0C          MOVE.L     A4,-(A7)
000E: 4EAD0ACA      JSR        2762(A5)                       ; JT[2762]
0012: 4A40          TST.W      D0
0014: 588F          MOVE.B     A7,(A4)
0016: 6776          BEQ.S      $008E
0018: 4AAC0014      TST.L      20(A4)
001C: 6704          BEQ.S      $0022
001E: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0022: 2E2C0010      MOVE.L     16(A4),D7
0026: 302C001E      MOVE.W     30(A4),D0
002A: 48C0          EXT.L      D0
002C: E5882640      MOVE.L     A0,64(A2,D2.W*8)
0030: 41EDA756      LEA        -22698(A5),A0                  ; A5-22698
0034: D1CBBE90      MOVE.B     A3,$BE90.W
0038: 6F32          BLE.S      $006C
003A: 204D          MOVEA.L    A5,A0
003C: 302C001E      MOVE.W     30(A4),D0
0040: 48C0          EXT.L      D0
0042: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0046: 224D          MOVEA.L    A5,A1
0048: 302C001E      MOVE.W     30(A4),D0
004C: 48C0          EXT.L      D0
004E: E588D3C0      MOVE.L     A0,-64(A2,A5.W*2)
0052: 2368A756CF30  MOVE.L     -22698(A0),-12496(A1)
0058: 204D          MOVEA.L    A5,A0
005A: 302C001E      MOVE.W     30(A4),D0
005E: 48C0          EXT.L      D0
0060: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0064: 216C0010A756  MOVE.L     16(A4),-22698(A0)
006A: 601C          BRA.S      $0088
006C: 41EDCF30      LEA        -12496(A5),A0                  ; A5-12496
0070: D1CBBE90      MOVE.B     A3,$BE90.W
0074: 6F12          BLE.S      $0088
0076: 204D          MOVEA.L    A5,A0
0078: 302C001E      MOVE.W     30(A4),D0
007C: 48C0          EXT.L      D0
007E: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0082: 216C0010CF30  MOVE.L     16(A4),-12496(A0)
0088: 2F0C          MOVE.L     A4,-(A7)
008A: 4EAD0842      JSR        2114(A5)                       ; JT[2114]
008E: 4CEE1880FFF4  MOVEM.L    -12(A6),D7/A3/A4
0094: 4E5E          UNLK       A6
0096: 4E75          RTS        


; ======= Function at 0x0098 =======
0098: 4E560000      LINK       A6,#0
009C: 2F07          MOVE.L     D7,-(A7)
009E: 2F2E0008      MOVE.L     8(A6),-(A7)
00A2: 4EAD0AFA      JSR        2810(A5)                       ; JT[2810]
00A6: 42ADB3E2      CLR.L      -19486(A5)
00AA: 486D0A7A      PEA        2682(A5)                       ; A5+2682
00AE: 4EAD0A3A      JSR        2618(A5)                       ; JT[2618]
00B2: 48780154      PEA        $0154.W
00B6: 486DA5F0      PEA        -23056(A5)                     ; g_dawg_?
00BA: 2F2E0010      MOVE.L     16(A6),-(A7)
00BE: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
00C2: 3E2DCF04      MOVE.W     -12540(A5),D7                  ; A5-12540
00C6: 2EAE0008      MOVE.L     8(A6),(A7)
00CA: 3F3C0001      MOVE.W     #$0001,-(A7)
00CE: 4EAD0A5A      JSR        2650(A5)                       ; JT[2650]
00D2: 2EAE000C      MOVE.L     12(A6),(A7)
00D6: 4EAD0AFA      JSR        2810(A5)                       ; JT[2810]
00DA: 48780E00      PEA        $0E00.W
00DE: 2F2DD130      MOVE.L     -11984(A5),-(A7)               ; A5-11984
00E2: 4EAD01AA      JSR        426(A5)                        ; JT[426]
00E6: 486D0A72      PEA        2674(A5)                       ; A5+2674
00EA: 4EAD0A3A      JSR        2618(A5)                       ; JT[2618]
00EE: 2EAE000C      MOVE.L     12(A6),(A7)
00F2: 4267          CLR.W      -(A7)
00F4: 4EAD0A5A      JSR        2650(A5)                       ; JT[2650]
00F8: 2EADD130      MOVE.L     -11984(A5),(A7)                ; A5-11984
00FC: 4EAD083A      JSR        2106(A5)                       ; JT[2106]
0100: 2E80          MOVE.L     D0,(A7)
0102: 4EAD0ABA      JSR        2746(A5)                       ; JT[2746]
0106: 3007          MOVE.W     D7,D0
0108: 2E2EFFFC      MOVE.L     -4(A6),D7
010C: 4E5E          UNLK       A6
010E: 4E75          RTS        


; ======= Function at 0x0110 =======
0110: 4E560000      LINK       A6,#0
0114: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
0118: 286E0008      MOVEA.L    8(A6),A4
011C: 42ADB3E2      CLR.L      -19486(A5)
0120: 2F0C          MOVE.L     A4,-(A7)
0122: 4EAD0ACA      JSR        2762(A5)                       ; JT[2762]
0126: 4A40          TST.W      D0
0128: 588F          MOVE.B     A7,(A4)
012A: 670000C8      BEQ.W      $01F6
012E: 2E2C0010      MOVE.L     16(A4),D7
0132: 302C001E      MOVE.W     30(A4),D0
0136: 48C0          EXT.L      D0
0138: E5882640      MOVE.L     A0,64(A2,D2.W*8)
013C: 3C2C001E      MOVE.W     30(A4),D6
0140: 41EDA756      LEA        -22698(A5),A0                  ; A5-22698
0144: D1CBBE90      MOVE.B     A3,$BE90.W
0148: 6F5E          BLE.S      $01A8
014A: 701C          MOVEQ      #28,D0
014C: C1C6          ANDA.L     D6,A0
014E: D0ADD130      MOVE.B     -11984(A5),(A0)                ; A5-11984
0152: 2640          MOVEA.L    D0,A3
0154: 701C          MOVEQ      #28,D0
0156: C1EC001E      ANDA.L     30(A4),A0
015A: 206DD130      MOVEA.L    -11984(A5),A0
015E: 41F0080E      LEA        14(A0,D0.L),A0
0162: 43D3          LEA        (A3),A1
0164: 20D9          MOVE.L     (A1)+,(A0)+
0166: 20D9          MOVE.L     (A1)+,(A0)+
0168: 20D9          MOVE.L     (A1)+,(A0)+
016A: 30D9          MOVE.W     (A1)+,(A0)+
016C: 2F0C          MOVE.L     A4,-(A7)
016E: 2F0B          MOVE.L     A3,-(A7)
0170: 4EAD0832      JSR        2098(A5)                       ; JT[2098]
0174: 204D          MOVEA.L    A5,A0
0176: 302C001E      MOVE.W     30(A4),D0
017A: 48C0          EXT.L      D0
017C: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
0180: 224D          MOVEA.L    A5,A1
0182: 302C001E      MOVE.W     30(A4),D0
0186: 48C0          EXT.L      D0
0188: E588D3C0      MOVE.L     A0,-64(A2,A5.W*2)
018C: 2368A756CF30  MOVE.L     -22698(A0),-12496(A1)
0192: 204D          MOVEA.L    A5,A0
0194: 302C001E      MOVE.W     30(A4),D0
0198: 48C0          EXT.L      D0
019A: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
019E: 216C0010A756  MOVE.L     16(A4),-22698(A0)
01A4: 508F          MOVE.B     A7,(A0)
01A6: 6032          BRA.S      $01DA
01A8: 41EDCF30      LEA        -12496(A5),A0                  ; A5-12496
01AC: D1CBBE90      MOVE.B     A3,$BE90.W
01B0: 6F28          BLE.S      $01DA
01B2: 204D          MOVEA.L    A5,A0
01B4: 302C001E      MOVE.W     30(A4),D0
01B8: 48C0          EXT.L      D0
01BA: E588D1C0      MOVE.L     A0,-64(A2,A5.W)
01BE: 216C0010CF30  MOVE.L     16(A4),-12496(A0)
01C4: 2F0C          MOVE.L     A4,-(A7)
01C6: 701C          MOVEQ      #28,D0
01C8: C1EC001E      ANDA.L     30(A4),A0
01CC: 206DD130      MOVEA.L    -11984(A5),A0
01D0: 4870080E      PEA        14(A0,D0.L)
01D4: 4EAD0832      JSR        2098(A5)                       ; JT[2098]
01D8: 508F          MOVE.B     A7,(A0)
01DA: 4A6C001C      TST.W      28(A4)
01DE: 6706          BEQ.S      $01E6
01E0: 7014          MOVEQ      #20,D0
01E2: 29400014      MOVE.L     D0,20(A4)
01E6: 41ED0A82      LEA        2690(A5),A0                    ; A5+2690
01EA: 2B48B3E2      MOVE.L     A0,-19486(A5)
01EE: 2F0C          MOVE.L     A4,-(A7)
01F0: 4EAD0842      JSR        2114(A5)                       ; JT[2114]
01F4: 4CEE18C0FFF0  MOVEM.L    -16(A6),D6/D7/A3/A4
01FA: 4E5E          UNLK       A6
01FC: 4E75          RTS        


; ======= Function at 0x01FE =======
01FE: 4E560000      LINK       A6,#0
0202: 48E70038      MOVEM.L    A2/A3/A4,-(SP)                 ; save
0206: 246E0008      MOVEA.L    8(A6),A2
020A: 49EDA5F0      LEA        -23056(A5),A4                  ; g_dawg_?
020E: 47EA001E      LEA        30(A2),A3
0212: 6042          BRA.S      $0256
0214: 302C001E      MOVE.W     30(A4),D0
0218: B053          MOVEA.W    (A3),A0
021A: 6636          BNE.S      $0252
021C: 102C0020      MOVE.B     32(A4),D0
0220: B02A0020      MOVE.W     32(A2),D0
0224: 662C          BNE.S      $0252
0226: 102C0021      MOVE.B     33(A4),D0
022A: B02A0021      MOVE.W     33(A2),D0
022E: 6622          BNE.S      $0252
0230: 202C0010      MOVE.L     16(A4),D0
0234: D0AC0014      MOVE.B     20(A4),(A0)
0238: 222A0010      MOVE.L     16(A2),D1
023C: D2AA0014      MOVE.B     20(A2),(A1)
0240: B280          MOVE.W     D0,(A1)
0242: 6F0A          BLE.S      $024E
0244: 2F0C          MOVE.L     A4,-(A7)
0246: 4EAD0ADA      JSR        2778(A5)                       ; JT[2778]
024A: 588F          MOVE.B     A7,(A4)
024C: 6018          BRA.S      $0266
024E: 7000          MOVEQ      #0,D0
0250: 6016          BRA.S      $0268
0252: 49EC0022      LEA        34(A4),A4
0256: 7022          MOVEQ      #34,D0
0258: C1EDCF04      ANDA.L     -12540(A5),A0
025C: 41EDA5F0      LEA        -23056(A5),A0                  ; g_dawg_?
0260: D088          MOVE.B     A0,(A0)
0262: B08C          MOVE.W     A4,(A0)
0264: 62AE          BHI.S      $0214
0266: 7001          MOVEQ      #1,D0
0268: 4CDF1C00      MOVEM.L    (SP)+,A2/A3/A4                 ; restore
026C: 4E5E          UNLK       A6
026E: 4E75          RTS        
