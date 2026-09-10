0004: 4e560000             link.w     a6, #$0
0008: 48e70718             movem.l    d5-d7/a3-a4, -(a7)
000c: 286e000c             movea.l    $c(a6), a4
0010: 200c                 move.l     a4, d0
0012: 6604                 bne.b      $18
0014: 49eda54e             lea.l      -$5ab2(a5), a4
0018: 266e0008             movea.l    $8(a6), a3
001c: 600a                 bra.b      $28
001e: 1013                 move.b     (a3), d0
0020: 4880                 ext.w      d0
0022: 42340000             clr.b      (a4, d0.w)
0026: 528b                 addq.l     #$1, a3
0028: 4a13                 tst.b      (a3)
002a: 66f2                 bne.b      $1e
002c: 7c01                 moveq      #$1, d6
002e: 2e06                 move.l     d6, d7
0030: 266e0008             movea.l    $8(a6), a3
0034: 1a13                 move.b     (a3), d5
0036: 4a05                 tst.b      d5
0038: 676e                 beq.b      $a8
003a: 1005                 move.b     d5, d0
003c: 4880                 ext.w      d0
003e: 10340000             move.b     (a4, d0.w), d0
0042: 4880                 ext.w      d0
0044: 1205                 move.b     d5, d1
0046: 4881                 ext.w      d1
0048: 204d                 movea.l    a5, a0
004a: d0c1                 adda.w     d1, a0
004c: 12289512             move.b     -$6aee(a0), d1
0050: 4881                 ext.w      d1
0052: 9240                 sub.w      d0, d1
0054: 3041                 movea.w    d1, a0
0056: 2f08                 move.l     a0, -(a7)
0058: 2f07                 move.l     d7, -(a7)
005a: 4ead0042             jsr        $42(a5) ; CODE1+00ee
005e: 2e00                 move.l     d0, d7
0060: 4a87                 tst.l      d7
0062: 6744                 beq.b      $a8
0064: 1013                 move.b     (a3), d0
0066: 4880                 ext.w      d0
0068: 52340000             addq.b     #$1, (a4, d0.w)
006c: 10340000             move.b     (a4, d0.w), d0
0070: 4880                 ext.w      d0
0072: 3040                 movea.w    d0, a0
0074: 2f08                 move.l     a0, -(a7)
0076: 2f06                 move.l     d6, -(a7)
0078: 4ead0042             jsr        $42(a5) ; CODE1+00ee
007c: 2c00                 move.l     d0, d6
007e: 2f06                 move.l     d6, -(a7)
0080: 2f07                 move.l     d7, -(a7)
0082: 4ead05ba             jsr        $5ba(a5) ; CODE4+003e
0086: 2a00                 move.l     d0, d5
0088: 7001                 moveq      #$1, d0
008a: b085                 cmp.l      d5, d0
008c: 508f                 addq.l     #$8, a7
008e: 6c14                 bge.b      $a4
0090: 2f05                 move.l     d5, -(a7)
0092: 2f07                 move.l     d7, -(a7)
0094: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0098: 2e00                 move.l     d0, d7
009a: 2f05                 move.l     d5, -(a7)
009c: 2f06                 move.l     d6, -(a7)
009e: 4ead005a             jsr        $5a(a5) ; CODE1+0166
00a2: 2c00                 move.l     d0, d6
00a4: 528b                 addq.l     #$1, a3
00a6: 608c                 bra.b      $34
00a8: 2f06                 move.l     d6, -(a7)
00aa: 2f07                 move.l     d7, -(a7)
00ac: 4ead0062             jsr        $62(a5) ; CODE1+0186
00b0: 4a80                 tst.l      d0
00b2: 6704                 beq.b      $b8
00b4: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
00b8: 2f06                 move.l     d6, -(a7)
00ba: 2f07                 move.l     d7, -(a7)
00bc: 4ead005a             jsr        $5a(a5) ; CODE1+0166
00c0: 2e00                 move.l     d0, d7
00c2: 2007                 move.l     d7, d0
00c4: 4cdf18e0             movem.l    (a7)+, d5-d7/a3-a4
00c8: 4e5e                 unlk       a6
00ca: 4e75                 rts        
