;======================================================================
; CODE 29 Disassembly
; File: /tmp/maven_code_29.bin
; Header: JT offset=2104, JT entries=8
; Code size: 686 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FFDE      LINK       A6,#-34                        ; frame=34
0004: 2F2E0008      MOVE.L     8(A6),-(A7)
0008: 486EFFDE      PEA        -34(A6)
000C: 4EAD08F2      JSR        2290(A5)                       ; JT[2290]
0010: 2EAE0014      MOVE.L     20(A6),(A7)
0014: 2F2E0010      MOVE.L     16(A6),-(A7)
0018: 2F2E000C      MOVE.L     12(A6),-(A7)
001C: 486EFFDE      PEA        -34(A6)
0020: 4EAD0A32      JSR        2610(A5)                       ; JT[2610]
0024: 4E5E          UNLK       A6
0026: 4E75          RTS        


; ======= Function at 0x0028 =======
0028: 4E560000      LINK       A6,#0
002C: 2B6E0008CF28  MOVE.L     8(A6),-12504(A5)
0032: 2B6E000CCF2C  MOVE.L     12(A6),-12500(A5)
0038: 2F2E000C      MOVE.L     12(A6),-(A7)
003C: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
0040: 4EAD0982      JSR        2434(A5)                       ; JT[2434]
0044: 486D0872      PEA        2162(A5)                       ; A5+2162
0048: 4EAD08C2      JSR        2242(A5)                       ; JT[2242]
004C: 4E5E          UNLK       A6
004E: 4E75          RTS        


; ======= Function at 0x0050 =======
0050: 4E560000      LINK       A6,#0
0054: 2F0C          MOVE.L     A4,-(A7)
0056: 286E0008      MOVEA.L    8(A6),A4
005A: 4A2C001C      TST.B      28(A4)
005E: 6668          BNE.S      $00C8
0060: 4A6C0004      TST.W      4(A4)
0064: 6662          BNE.S      $00C8
0066: 4A2C001A      TST.B      26(A4)
006A: 675C          BEQ.S      $00C8
006C: 48780022      PEA        $0022.W
0070: 486DA5CE      PEA        -23090(A5)                     ; g_dawg_info
0074: 4EAD01AA      JSR        426(A5)                        ; JT[426]
0078: 306C0002      MOVEA.W    2(A4),A0
007C: 2B48A600      MOVE.L     A0,-23040(A5)
0080: 3054          MOVEA.W    (A4),A0
0082: 2B48A622      MOVE.L     A0,-23006(A5)
0086: 102C0019      MOVE.B     25(A4),D0
008A: 4880          EXT.W      D0
008C: 3B40F526      MOVE.W     D0,-2778(A5)
0090: 2EADCF2C      MOVE.L     -12500(A5),(A7)                ; A5-12500
0094: 486D087A      PEA        2170(A5)                       ; A5+2170
0098: 2F2DCF28      MOVE.L     -12504(A5),-(A7)               ; A5-12504
009C: 2F0C          MOVE.L     A4,-(A7)
009E: 4EBAFF60      JSR        -160(PC)
00A2: 396DA6020002  MOVE.W     -23038(A5),2(A4)               ; A5-23038
00A8: 38ADA624      MOVE.W     -23004(A5),(A4)                ; A5-23004
00AC: 4A6DA5EA      TST.W      -23062(A5)
00B0: 4FEF0014      LEA        20(A7),A7
00B4: 6706          BEQ.S      $00BC
00B6: 197C0001001D  MOVE.B     #$01,29(A4)
00BC: 4AADA5E6      TST.L      -23066(A5)
00C0: 6706          BEQ.S      $00C8
00C2: 197C00010018  MOVE.B     #$01,24(A4)
00C8: 285F          MOVEA.L    (A7)+,A4
00CA: 4E5E          UNLK       A6
00CC: 4E75          RTS        


; ======= Function at 0x00CE =======
00CE: 4E56FFFC      LINK       A6,#-4                         ; frame=4
00D2: 48E70318      MOVEM.L    D6/D7/A3/A4,-(SP)              ; save
00D6: 266E0008      MOVEA.L    8(A6),A3
00DA: 7001          MOVEQ      #1,D0
00DC: 2B40A5E6      MOVE.L     D0,-23066(A5)
00E0: 49EB001C      LEA        28(A3),A4
00E4: 4A54          TST.W      (A4)
00E6: 6718          BEQ.S      $0100
00E8: 2F2DCF28      MOVE.L     -12504(A5),-(A7)               ; A5-12504
00EC: 4EAD084A      JSR        2122(A5)                       ; JT[2122]
00F0: D040          MOVEA.B    D0,A0
00F2: 48C0          EXT.L      D0
00F4: D0AB0010      MOVE.B     16(A3),(A0)
00F8: 2C00          MOVE.L     D0,D6
00FA: 2E00          MOVE.L     D0,D7
00FC: 588F          MOVE.B     A7,(A4)
00FE: 6036          BRA.S      $0136
0100: 486EFFFC      PEA        -4(A6)
0104: 486EFFFE      PEA        -2(A6)
0108: 3F2B001E      MOVE.W     30(A3),-(A7)
010C: 3F2DF526      MOVE.W     -2778(A5),-(A7)                ; A5-2778
0110: 4EAD0A6A      JSR        2666(A5)                       ; JT[2666]
0114: 3040          MOVEA.W    D0,A0
0116: 2C2B0010      MOVE.L     16(A3),D6
011A: 9C88          MOVE.B     A0,(A6)
011C: 2E06          MOVE.L     D6,D7
011E: 306EFFFC      MOVEA.W    -4(A6),A0
0122: DE88          MOVE.B     A0,(A7)
0124: 306EFFFE      MOVEA.W    -2(A6),A0
0128: 9C88          MOVE.B     A0,(A6)
012A: BC87          MOVE.W     D7,(A6)
012C: 4FEF000C      LEA        12(A7),A7
0130: 6F04          BLE.S      $0136
0132: 4EAD01A2      JSR        418(A5)                        ; JT[418]
0136: BEADA600      MOVE.W     -23040(A5),(A7)                ; A5-23040
013A: 6F08          BLE.S      $0144
013C: 3B54A5EA      MOVE.W     (A4),-23062(A5)
0140: 2B47A600      MOVE.L     D7,-23040(A5)
0144: BCADA622      MOVE.W     -23006(A5),(A6)                ; A5-23006
0148: 6F08          BLE.S      $0152
014A: 3B54A5EA      MOVE.W     (A4),-23062(A5)
014E: 2B46A622      MOVE.L     D6,-23006(A5)
0152: 4CDF18C0      MOVEM.L    (SP)+,D6/D7/A3/A4              ; restore
0156: 4E5E          UNLK       A6
0158: 4E75          RTS        


; ======= Function at 0x015A =======
015A: 4E560000      LINK       A6,#0
015E: 2B6E000CCF28  MOVE.L     12(A6),-12504(A5)
0164: 2B6E0008CF2C  MOVE.L     8(A6),-12500(A5)
016A: 2F2E0008      MOVE.L     8(A6),-(A7)
016E: 4EAD096A      JSR        2410(A5)                       ; JT[2410]
0172: 4EAD0982      JSR        2434(A5)                       ; JT[2434]
0176: 486D088A      PEA        2186(A5)                       ; A5+2186
017A: 4EAD08C2      JSR        2242(A5)                       ; JT[2242]
017E: 4E5E          UNLK       A6
0180: 4E75          RTS        


; ======= Function at 0x0182 =======
0182: 4E56FFF6      LINK       A6,#-10                        ; frame=10
0186: 48E70308      MOVEM.L    D6/D7/A4,-(SP)                 ; save
018A: 286E0008      MOVEA.L    8(A6),A4
018E: 4A2C001C      TST.B      28(A4)
0192: 66000088      BNE.W      $021E
0196: 4A2C001D      TST.B      29(A4)
019A: 66000080      BNE.W      $021E
019E: 4A6C0004      TST.W      4(A4)
01A2: 6678          BNE.S      $021C
01A4: 4A2C001A      TST.B      26(A4)
01A8: 6772          BEQ.S      $021C
01AA: 48780200      PEA        $0200.W
01AE: 486DA756      PEA        -22698(A5)                     ; A5-22698
01B2: 4EAD01AA      JSR        426(A5)                        ; JT[426]
01B6: 2EADCF2C      MOVE.L     -12500(A5),(A7)                ; A5-12500
01BA: 486D0892      PEA        2194(A5)                       ; A5+2194
01BE: 2F2DCF2C      MOVE.L     -12500(A5),-(A7)               ; A5-12500
01C2: 2F0C          MOVE.L     A4,-(A7)
01C4: 4EBAFE3A      JSR        -454(PC)
01C8: 1E2C0018      MOVE.B     24(A4),D7
01CC: 4A07          TST.B      D7
01CE: 4FEF0014      LEA        20(A7),A7
01D2: 6704          BEQ.S      $01D8
01D4: 7001          MOVEQ      #1,D0
01D6: 6002          BRA.S      $01DA
01D8: 7008          MOVEQ      #8,D0
01DA: 3C00          MOVE.W     D0,D6
01DC: 4A07          TST.B      D7
01DE: 6704          BEQ.S      $01E4
01E0: 7002          MOVEQ      #2,D0
01E2: 6002          BRA.S      $01E6
01E4: 7008          MOVEQ      #8,D0
01E6: 3E00          MOVE.W     D0,D7
01E8: 486DF528      PEA        -2776(A5)                      ; A5-2776
01EC: 486DF52A      PEA        -2774(A5)                      ; A5-2774
01F0: 486EFFF6      PEA        -10(A6)
01F4: 3F07          MOVE.W     D7,-(A7)
01F6: 3F06          MOVE.W     D6,-(A7)
01F8: 2F2DCF2C      MOVE.L     -12500(A5),-(A7)               ; A5-12500
01FC: 2F0C          MOVE.L     A4,-(A7)
01FE: 4EAD0A52      JSR        2642(A5)                       ; JT[2642]
0202: 302EFFF8      MOVE.W     -8(A6),D0
0206: 91544AAD      MOVE.B     (A4),19117(A0)
020A: F52A4FEF      MOVE.W     20463(A2),-(A2)
020E: 0018670A      ORI.B      #$670A,(A0)+
0212: 486D085A      PEA        2138(A5)                       ; A5+2138
0216: 4EAD08C2      JSR        2242(A5)                       ; JT[2242]
021A: 588F          MOVE.B     A7,(A4)
021C: 4CDF10C0      MOVEM.L    (SP)+,D6/D7/A4                 ; restore
0220: 4E5E          UNLK       A6
0222: 4E75          RTS        


; ======= Function at 0x0224 =======
0224: 4E560000      LINK       A6,#0
0228: 48E70018      MOVEM.L    A3/A4,-(SP)                    ; save
022C: 266E0008      MOVEA.L    8(A6),A3
0230: 49EB0008      LEA        8(A3),A4
0234: 3054          MOVEA.W    (A4),A0
0236: B1EDF52A6C2A  MOVE.W     -2774(A5),$6C2A.W              ; A5-2774
023C: 4A2B001C      TST.B      28(A3)
0240: 6624          BNE.S      $0266
0242: 4A2B001D      TST.B      29(A3)
0246: 661E          BNE.S      $0266
0248: 4A6B0004      TST.W      4(A3)
024C: 6618          BNE.S      $0266
024E: 102B0019      MOVE.B     25(A3),D0
0252: 4880          EXT.W      D0
0254: 806DF528      OR.W       -2776(A5),D0                   ; A5-2776
0258: 122B0019      MOVE.B     25(A3),D1
025C: 4881          EXT.W      D1
025E: B240          MOVEA.W    D0,A1
0260: 6604          BNE.S      $0266
0262: 38ADF52C      MOVE.W     -2772(A5),(A4)                 ; A5-2772
0266: 4CDF1800      MOVEM.L    (SP)+,A3/A4                    ; restore
026A: 4E5E          UNLK       A6
026C: 4E75          RTS        


; ======= Function at 0x026E =======
026E: 4E56FFFA      LINK       A6,#-6                         ; frame=6
0272: 2F0C          MOVE.L     A4,-(A7)
0274: 7010          MOVEQ      #16,D0
0276: D0AE0008      MOVE.B     8(A6),(A0)
027A: 2840          MOVEA.L    D0,A4
027C: 206E0008      MOVEA.L    8(A6),A0
0280: 3028001E      MOVE.W     30(A0),D0
0284: 224D          MOVEA.L    A5,A1
0286: 48C0          EXT.L      D0
0288: E588D3C0      MOVE.L     A0,-64(A2,A5.W*2)
028C: 2014          MOVE.L     (A4),D0
028E: B0A9A756      MOVE.W     -22698(A1),(A0)
0292: 6F14          BLE.S      $02A8
0294: 206E0008      MOVEA.L    8(A6),A0
0298: 3028001E      MOVE.W     30(A0),D0
029C: 224D          MOVEA.L    A5,A1
029E: 48C0          EXT.L      D0
02A0: E588D3C0      MOVE.L     A0,-64(A2,A5.W*2)
02A4: 2354A756      MOVE.L     (A4),-22698(A1)
02A8: 285F          MOVEA.L    (A7)+,A4
02AA: 4E5E          UNLK       A6
02AC: 4E75          RTS        
