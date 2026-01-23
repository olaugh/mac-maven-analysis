;======================================================================
; CODE 5 Disassembly
; File: /tmp/maven_code_5.bin
; Header: JT offset=160, JT entries=1
; Code size: 204 bytes
;======================================================================


; ======= Function at 0x0000 =======
0000: 4E56FB80      LINK       A6,#-1152                      ; frame=1152
0004: 2F2E000C      MOVE.L     12(A6),-(A7)
0008: 2F2E0008      MOVE.L     8(A6),-(A7)
000C: 4EAD054A      JSR        1354(A5)                       ; JT[1354]
0010: 4A40          TST.W      D0
0012: 508F          MOVE.B     A7,(A0)
0014: 670E          BEQ.S      $0024
0016: 3F3C03FF      MOVE.W     #$03FF,-(A7)
001A: 4EAD058A      JSR        1418(A5)                       ; JT[1418]
001E: 4A40          TST.W      D0
0020: 548F          MOVE.B     A7,(A2)
0022: 6606          BNE.S      $002A
0024: 7000          MOVEQ      #0,D0
0026: 600000A0      BRA.W      $00CA
002A: 4EAD0292      JSR        658(A5)                        ; JT[658]
002E: 2F2E0008      MOVE.L     8(A6),-(A7)
0032: 486DC366      PEA        -15514(A5)                     ; g_field_14
0036: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
003A: 2EAE000C      MOVE.L     12(A6),(A7)
003E: 486DC35E      PEA        -15522(A5)                     ; g_field_22
0042: 4EAD0DA2      JSR        3490(A5)                       ; JT[3490]
0046: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
004A: 2B6E0010C372  MOVE.L     16(A6),-15502(A5)
0050: 2B6E0014C36E  MOVE.L     20(A6),-15506(A5)
0056: 4EAD04EA      JSR        1258(A5)                       ; JT[1258]
005A: 4EAD03FA      JSR        1018(A5)                       ; JT[1018]
005E: 48780121      PEA        $0121.W
0062: 486DD76C      PEA        -10388(A5)                     ; g_lookup_tbl
0066: 486DD88D      PEA        -10099(A5)                     ; A5-10099
006A: 4EAD0D8A      JSR        3466(A5)                       ; JT[3466]
006E: 4A6E0018      TST.W      24(A6)
0072: 4FEF0018      LEA        24(A7),A7
0076: 6722          BEQ.S      $009A
0078: 41EDC366      LEA        -15514(A5),A0                  ; g_field_14
007C: 2B48C376      MOVE.L     A0,-15498(A5)
0080: 486DC366      PEA        -15514(A5)                     ; g_field_14
0084: 4EAD0962      JSR        2402(A5)                       ; JT[2402]
0088: 486DC35E      PEA        -15522(A5)                     ; g_field_22
008C: 4EAD0962      JSR        2402(A5)                       ; JT[2402]
0090: 3B7C0003DE64  MOVE.W     #$0003,-8604(A5)
0096: 508F          MOVE.B     A7,(A0)
0098: 6020          BRA.S      $00BA
009A: 41EDC35E      LEA        -15522(A5),A0                  ; g_field_22
009E: 2B48C376      MOVE.L     A0,-15498(A5)
00A2: 486DC35E      PEA        -15522(A5)                     ; g_field_22
00A6: 4EAD0962      JSR        2402(A5)                       ; JT[2402]
00AA: 486DC366      PEA        -15514(A5)                     ; g_field_14
00AE: 4EAD0962      JSR        2402(A5)                       ; JT[2402]
00B2: 3B7C0002DE64  MOVE.W     #$0002,-8604(A5)
00B8: 508F          MOVE.B     A7,(A0)
00BA: 4EAD0552      JSR        1362(A5)                       ; JT[1362]
00BE: 4EAD012A      JSR        298(A5)                        ; JT[298]
00C2: 426DD9AE      CLR.W      -9810(A5)
00C6: 7001          MOVEQ      #1,D0
00C8: 4E5E          UNLK       A6
00CA: 4E75          RTS        
