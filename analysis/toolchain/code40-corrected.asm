0004: 4e560000             link.w     a6, #$0
0008: 48e70118             movem.l    d7/a3-a4, -(a7)
000c: 286e0008             movea.l    $8(a6), a4
0010: 2f0c                 move.l     a4, -(a7)
0012: 4ead0aca             jsr        $aca(a5) ; CODE44+00ee
0016: 4a40                 tst.w      d0
0018: 588f                 addq.l     #$4, a7
001a: 6776                 beq.b      $92
001c: 4aac0014             tst.l      $14(a4)
0020: 6704                 beq.b      $26
0022: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0026: 2e2c0010             move.l     $10(a4), d7
002a: 302c001e             move.w     $1e(a4), d0
002e: 48c0                 ext.l      d0
0030: e588                 lsl.l      #$2, d0
0032: 2640                 movea.l    d0, a3
0034: 41eda756             lea.l      -$58aa(a5), a0
0038: d1cb                 adda.l     a3, a0
003a: be90                 cmp.l      (a0), d7
003c: 6f32                 ble.b      $70
003e: 204d                 movea.l    a5, a0
0040: 302c001e             move.w     $1e(a4), d0
0044: 48c0                 ext.l      d0
0046: e588                 lsl.l      #$2, d0
0048: d1c0                 adda.l     d0, a0
004a: 224d                 movea.l    a5, a1
004c: 302c001e             move.w     $1e(a4), d0
0050: 48c0                 ext.l      d0
0052: e588                 lsl.l      #$2, d0
0054: d3c0                 adda.l     d0, a1
0056: 2368a756cf30         move.l     -$58aa(a0), -$30d0(a1)
005c: 204d                 movea.l    a5, a0
005e: 302c001e             move.w     $1e(a4), d0
0062: 48c0                 ext.l      d0
0064: e588                 lsl.l      #$2, d0
0066: d1c0                 adda.l     d0, a0
0068: 216c0010a756         move.l     $10(a4), -$58aa(a0)
006e: 601c                 bra.b      $8c
0070: 41edcf30             lea.l      -$30d0(a5), a0
0074: d1cb                 adda.l     a3, a0
0076: be90                 cmp.l      (a0), d7
0078: 6f12                 ble.b      $8c
007a: 204d                 movea.l    a5, a0
007c: 302c001e             move.w     $1e(a4), d0
0080: 48c0                 ext.l      d0
0082: e588                 lsl.l      #$2, d0
0084: d1c0                 adda.l     d0, a0
0086: 216c0010cf30         move.l     $10(a4), -$30d0(a0)
008c: 2f0c                 move.l     a4, -(a7)
008e: 4ead0842             jsr        $842(a5) ; CODE28+0004
0092: 4cee1880fff4         movem.l    -$c(a6), d7/a3-a4
0098: 4e5e                 unlk       a6
009a: 4e75                 rts        
009c: 4e560000             link.w     a6, #$0
00a0: 2f07                 move.l     d7, -(a7)
00a2: 2f2e0008             move.l     $8(a6), -(a7)
00a6: 4ead0afa             jsr        $afa(a5) ; CODE45+042a
00aa: 42adb3e2             clr.l      -$4c1e(a5)
00ae: 486d0a7a             pea.l      $a7a(a5)
00b2: 4ead0a3a             jsr        $a3a(a5) ; CODE37+0004
00b6: 48780154             pea.l      $154.w
00ba: 486da5f0             pea.l      -$5a10(a5)
00be: 2f2e0010             move.l     $10(a6), -(a7)
00c2: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
00c6: 3e2dcf04             move.w     -$30fc(a5), d7
00ca: 2eae0008             move.l     $8(a6), (a7)
00ce: 3f3c0001             move.w     #$1, -(a7)
00d2: 4ead0a5a             jsr        $a5a(a5) ; CODE39+0190
00d6: 2eae000c             move.l     $c(a6), (a7)
00da: 4ead0afa             jsr        $afa(a5) ; CODE45+042a
00de: 48780e00             pea.l      $e00.w
00e2: 2f2dd130             move.l     -$2ed0(a5), -(a7)
00e6: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
00ea: 486d0a72             pea.l      $a72(a5)
00ee: 4ead0a3a             jsr        $a3a(a5) ; CODE37+0004
00f2: 2eae000c             move.l     $c(a6), (a7)
00f6: 4267                 clr.w      -(a7)
00f8: 4ead0a5a             jsr        $a5a(a5) ; CODE39+0190
00fc: 2eadd130             move.l     -$2ed0(a5), (a7)
0100: 4ead083a             jsr        $83a(a5) ; CODE27+01d4
0104: 2e80                 move.l     d0, (a7)
0106: 4ead0aba             jsr        $aba(a5) ; CODE43+0314
010a: 3007                 move.w     d7, d0
010c: 2e2efffc             move.l     -$4(a6), d7
0110: 4e5e                 unlk       a6
0112: 4e75                 rts        
0114: 4e560000             link.w     a6, #$0
0118: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
011c: 286e0008             movea.l    $8(a6), a4
0120: 42adb3e2             clr.l      -$4c1e(a5)
0124: 2f0c                 move.l     a4, -(a7)
0126: 4ead0aca             jsr        $aca(a5) ; CODE44+00ee
012a: 4a40                 tst.w      d0
012c: 588f                 addq.l     #$4, a7
012e: 670000c8             beq.w      $1f8
0132: 2e2c0010             move.l     $10(a4), d7
0136: 302c001e             move.w     $1e(a4), d0
013a: 48c0                 ext.l      d0
013c: e588                 lsl.l      #$2, d0
013e: 2640                 movea.l    d0, a3
0140: 3c2c001e             move.w     $1e(a4), d6
0144: 41eda756             lea.l      -$58aa(a5), a0
0148: d1cb                 adda.l     a3, a0
014a: be90                 cmp.l      (a0), d7
014c: 6f5e                 ble.b      $1ac
014e: 701c                 moveq      #$1c, d0
0150: c1c6                 muls.w     d6, d0
0152: d0add130             add.l      -$2ed0(a5), d0
0156: 2640                 movea.l    d0, a3
0158: 701c                 moveq      #$1c, d0
015a: c1ec001e             muls.w     $1e(a4), d0
015e: 206dd130             movea.l    -$2ed0(a5), a0
0162: 41f0080e             lea.l      $e(a0, d0.l), a0
0166: 43d3                 lea.l      (a3), a1
0168: 20d9                 move.l     (a1)+, (a0)+
016a: 20d9                 move.l     (a1)+, (a0)+
016c: 20d9                 move.l     (a1)+, (a0)+
016e: 30d9                 move.w     (a1)+, (a0)+
0170: 2f0c                 move.l     a4, -(a7)
0172: 2f0b                 move.l     a3, -(a7)
0174: 4ead0832             jsr        $832(a5) ; CODE27+0192
0178: 204d                 movea.l    a5, a0
017a: 302c001e             move.w     $1e(a4), d0
017e: 48c0                 ext.l      d0
0180: e588                 lsl.l      #$2, d0
0182: d1c0                 adda.l     d0, a0
0184: 224d                 movea.l    a5, a1
0186: 302c001e             move.w     $1e(a4), d0
018a: 48c0                 ext.l      d0
018c: e588                 lsl.l      #$2, d0
018e: d3c0                 adda.l     d0, a1
0190: 2368a756cf30         move.l     -$58aa(a0), -$30d0(a1)
0196: 204d                 movea.l    a5, a0
0198: 302c001e             move.w     $1e(a4), d0
019c: 48c0                 ext.l      d0
019e: e588                 lsl.l      #$2, d0
01a0: d1c0                 adda.l     d0, a0
01a2: 216c0010a756         move.l     $10(a4), -$58aa(a0)
01a8: 508f                 addq.l     #$8, a7
01aa: 6032                 bra.b      $1de
01ac: 41edcf30             lea.l      -$30d0(a5), a0
01b0: d1cb                 adda.l     a3, a0
01b2: be90                 cmp.l      (a0), d7
01b4: 6f28                 ble.b      $1de
01b6: 204d                 movea.l    a5, a0
01b8: 302c001e             move.w     $1e(a4), d0
01bc: 48c0                 ext.l      d0
01be: e588                 lsl.l      #$2, d0
01c0: d1c0                 adda.l     d0, a0
01c2: 216c0010cf30         move.l     $10(a4), -$30d0(a0)
01c8: 2f0c                 move.l     a4, -(a7)
01ca: 701c                 moveq      #$1c, d0
01cc: c1ec001e             muls.w     $1e(a4), d0
01d0: 206dd130             movea.l    -$2ed0(a5), a0
01d4: 4870080e             pea.l      $e(a0, d0.l)
01d8: 4ead0832             jsr        $832(a5) ; CODE27+0192
01dc: 508f                 addq.l     #$8, a7
01de: 4a6c001c             tst.w      $1c(a4)
01e2: 6706                 beq.b      $1ea
01e4: 7014                 moveq      #$14, d0
01e6: 29400014             move.l     d0, $14(a4)
01ea: 41ed0a82             lea.l      $a82(a5), a0
01ee: 2b48b3e2             move.l     a0, -$4c1e(a5)
01f2: 2f0c                 move.l     a4, -(a7)
01f4: 4ead0842             jsr        $842(a5) ; CODE28+0004
01f8: 4cee18c0fff0         movem.l    -$10(a6), d6-d7/a3-a4
01fe: 4e5e                 unlk       a6
0200: 4e75                 rts        
0202: 4e560000             link.w     a6, #$0
0206: 48e70038             movem.l    a2-a4, -(a7)
020a: 246e0008             movea.l    $8(a6), a2
020e: 49eda5f0             lea.l      -$5a10(a5), a4
0212: 47ea001e             lea.l      $1e(a2), a3
0216: 6042                 bra.b      $25a
0218: 302c001e             move.w     $1e(a4), d0
021c: b053                 cmp.w      (a3), d0
021e: 6636                 bne.b      $256
0220: 102c0020             move.b     $20(a4), d0
0224: b02a0020             cmp.b      $20(a2), d0
0228: 662c                 bne.b      $256
022a: 102c0021             move.b     $21(a4), d0
022e: b02a0021             cmp.b      $21(a2), d0
0232: 6622                 bne.b      $256
0234: 202c0010             move.l     $10(a4), d0
0238: d0ac0014             add.l      $14(a4), d0
023c: 222a0010             move.l     $10(a2), d1
0240: d2aa0014             add.l      $14(a2), d1
0244: b280                 cmp.l      d0, d1
0246: 6f0a                 ble.b      $252
0248: 2f0c                 move.l     a4, -(a7)
024a: 4ead0ada             jsr        $ada(a5) ; CODE44+016e
024e: 588f                 addq.l     #$4, a7
0250: 6018                 bra.b      $26a
0252: 7000                 moveq      #$0, d0
0254: 6016                 bra.b      $26c
0256: 49ec0022             lea.l      $22(a4), a4
025a: 7022                 moveq      #$22, d0
025c: c1edcf04             muls.w     -$30fc(a5), d0
0260: 41eda5f0             lea.l      -$5a10(a5), a0
0264: d088                 add.l      a0, d0
0266: b08c                 cmp.l      a4, d0
0268: 62ae                 bhi.b      $218
026a: 7001                 moveq      #$1, d0
026c: 4cdf1c00             movem.l    (a7)+, a2-a4
0270: 4e5e                 unlk       a6
0272: 4e75                 rts        
