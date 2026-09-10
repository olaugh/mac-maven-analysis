0004: 4e560000             link.w     a6, #$0
0008: 7001                 moveq      #$1, d0
000a: 4e5e                 unlk       a6
000c: 4e75                 rts        
000e: 4e56fff8             link.w     a6, #$fff8
0012: 422efff8             clr.b      -$8(a6)
0016: 422dc35e             clr.b      -$3ca2(a5)
001a: 486efff8             pea.l      -$8(a6)
001e: 4ead0962             jsr        $962(a5) ; CODE31+07e0
0022: 486efff8             pea.l      -$8(a6)
0026: 4ebaffdc             jsr        $4(pc)
002a: 4a40                 tst.w      d0
002c: 508f                 addq.l     #$8, a7
002e: 67e2                 beq.b      $12
0030: 48780001             pea.l      $1.w
0034: 486efff8             pea.l      -$8(a6)
0038: 206e0008             movea.l    $8(a6), a0
003c: 4e90                 jsr        (a0)
003e: 508f                 addq.l     #$8, a7
0040: 60d0                 bra.b      $12
0042: 4e5e                 unlk       a6
0044: 4e75                 rts        
0046: 4e56fee0             link.w     a6, #$fee0
004a: 48e70118             movem.l    d7/a3-a4, -(a7)
004e: 4aae0008             tst.l      $8(a6)
0052: 6604                 bne.b      $58
0054: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0058: 486eff80             pea.l      -$80(a6)
005c: 4ead095a             jsr        $95a(a5) ; CODE31+075c
0060: 3e00                 move.w     d0, d7
0062: 0c470012             cmpi.w     #$12, d7
0066: 588f                 addq.l     #$4, a7
0068: 6d04                 blt.b      $6e
006a: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
006e: 49eefee0             lea.l      -$120(a6), a4
0072: 266d99d2             movea.l    -$662e(a5), a3
0076: 1e13                 move.b     (a3), d7
0078: 4a07                 tst.b      d7
007a: 6710                 beq.b      $8c
007c: 1007                 move.b     d7, d0
007e: 4880                 ext.w      d0
0080: 4a360080             tst.b      -$80(a6, d0.w)
0084: 6702                 beq.b      $88
0086: 18d3                 move.b     (a3), (a4)+
0088: 528b                 addq.l     #$1, a3
008a: 60ea                 bra.b      $76
008c: 4214                 clr.b      (a4)
008e: 2f2e0008             move.l     $8(a6), -(a7)
0092: 4267                 clr.w      -(a7)
0094: 486efee0             pea.l      -$120(a6)
0098: 486eff00             pea.l      -$100(a6)
009c: 486eff80             pea.l      -$80(a6)
00a0: 4eba000c             jsr        $ae(pc)
00a4: 4cee1880fed4         movem.l    -$12c(a6), d7/a3-a4
00aa: 4e5e                 unlk       a6
00ac: 4e75                 rts        
00ae: 4e560000             link.w     a6, #$0
00b2: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
00b6: 2e2e0008             move.l     $8(a6), d7
00ba: 286e000c             movea.l    $c(a6), a4
00be: 266e0010             movea.l    $10(a6), a3
00c2: 3c2e0014             move.w     $14(a6), d6
00c6: 0c460007             cmpi.w     #$7, d6
00ca: 6f06                 ble.b      $d2
00cc: 7000                 moveq      #$0, d0
00ce: 600000a0             bra.w      $170
00d2: 0c460007             cmpi.w     #$7, d6
00d6: 6656                 bne.b      $12e
00d8: 4214                 clr.b      (a4)
00da: 5f8c                 subq.l     #$7, a4
00dc: 7c01                 moveq      #$1, d6
00de: 264c                 movea.l    a4, a3
00e0: 45ebffff             lea.l      -$1(a3), a2
00e4: 1a13                 move.b     (a3), d5
00e6: 4a05                 tst.b      d5
00e8: 6738                 beq.b      $122
00ea: ba2b0001             cmp.b      $1(a3), d5
00ee: 672e                 beq.b      $11e
00f0: 1005                 move.b     d5, d0
00f2: 4880                 ext.w      d0
00f4: 3040                 movea.w    d0, a0
00f6: 10307800             move.b     (a0, d7.l), d0
00fa: 4880                 ext.w      d0
00fc: 48c0                 ext.l      d0
00fe: e988                 lsl.l      #$4, d0
0100: 220b                 move.l     a3, d1
0102: 928a                 sub.l      a2, d1
0104: 41ed9a58             lea.l      -$65a8(a5), a0
0108: d088                 add.l      a0, d0
010a: d281                 add.l      d1, d1
010c: d081                 add.l      d1, d0
010e: 2040                 movea.l    d0, a0
0110: 3050                 movea.w    (a0), a0
0112: 2f08                 move.l     a0, -(a7)
0114: 2f06                 move.l     d6, -(a7)
0116: 4ead0042             jsr        $42(a5) ; CODE1+00ee
011a: 2c00                 move.l     d0, d6
011c: 244b                 movea.l    a3, a2
011e: 528b                 addq.l     #$1, a3
0120: 60c2                 bra.b      $e4
0122: 2f06                 move.l     d6, -(a7)
0124: 2f0c                 move.l     a4, -(a7)
0126: 206e0016             movea.l    $16(a6), a0
012a: 4e90                 jsr        (a0)
012c: 6042                 bra.b      $170
012e: 4a13                 tst.b      (a3)
0130: 6604                 bne.b      $136
0132: 7000                 moveq      #$0, d0
0134: 603a                 bra.b      $170
0136: 7800                 moveq      #$0, d4
0138: 2f2e0016             move.l     $16(a6), -(a7)
013c: 3f06                 move.w     d6, -(a7)
013e: 486b0001             pea.l      $1(a3)
0142: 2f0c                 move.l     a4, -(a7)
0144: 2f07                 move.l     d7, -(a7)
0146: 4ebaff66             jsr        $ae(pc)
014a: 4a40                 tst.w      d0
014c: 4fef0012             lea.l      $12(a7), a7
0150: 6704                 beq.b      $156
0152: 7001                 moveq      #$1, d0
0154: 601a                 bra.b      $170
0156: 18d3                 move.b     (a3), (a4)+
0158: 5246                 addq.w     #$1, d6
015a: 3004                 move.w     d4, d0
015c: 5244                 addq.w     #$1, d4
015e: 1213                 move.b     (a3), d1
0160: 4881                 ext.w      d1
0162: 3041                 movea.w    d1, a0
0164: 12307800             move.b     (a0, d7.l), d1
0168: 4881                 ext.w      d1
016a: b240                 cmp.w      d0, d1
016c: 6eca                 bgt.b      $138
016e: 7000                 moveq      #$0, d0
0170: 4cee1cf0ffe4         movem.l    -$1c(a6), d4-d7/a2-a4
0176: 4e5e                 unlk       a6
0178: 4e75                 rts        
