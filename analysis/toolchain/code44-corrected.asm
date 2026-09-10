0004: 4e56ff80             link.w     a6, #$ff80
0008: 48e70108             movem.l    d7/a4, -(a7)
000c: 286e0008             movea.l    $8(a6), a4
0010: 2f0c                 move.l     a4, -(a7)
0012: 4ead096a             jsr        $96a(a5) ; CODE31+0992
0016: 486eff80             pea.l      -$80(a6)
001a: 4ead095a             jsr        $95a(a5) ; CODE31+075c
001e: 3e00                 move.w     d0, d7
0020: 0c470011             cmpi.w     #$11, d7
0024: 508f                 addq.l     #$8, a7
0026: 652e                 bcs.b      $56
0028: 3f3c0220             move.w     #$220, -(a7)
002c: 486dbcfe             pea.l      -$4302(a5)
0030: 4ead0d7a             jsr        $d7a(a5) ; CODE54+0004
0034: 4a40                 tst.w      d0
0036: 5c8f                 addq.l     #$6, a7
0038: 6708                 beq.b      $42
003a: 41ed0ad2             lea.l      $ad2(a5), a0
003e: 2008                 move.l     a0, d0
0040: 6002                 bra.b      $44
0042: 7000                 moveq      #$0, d0
0044: 2b40b3e2             move.l     d0, -$4c1e(a5)
0048: 486d0842             pea.l      $842(a5)
004c: 2f0c                 move.l     a4, -(a7)
004e: 4ead0852             jsr        $852(a5) ; CODE28+011a
0052: 508f                 addq.l     #$8, a7
0054: 6020                 bra.b      $76
0056: 0c470008             cmpi.w     #$8, d7
005a: 6c0e                 bge.b      $6a
005c: 2f2e000c             move.l     $c(a6), -(a7)
0060: 2f0c                 move.l     a4, -(a7)
0062: 4ead089a             jsr        $89a(a5) ; CODE30+014e
0066: 508f                 addq.l     #$8, a7
0068: 600c                 bra.b      $76
006a: 3f2e0010             move.w     $10(a6), -(a7)
006e: 2f0c                 move.l     a4, -(a7)
0070: 4ead0a1a             jsr        $a1a(a5) ; CODE36+1810
0074: 5c8f                 addq.l     #$6, a7
0076: 41eda5f0             lea.l      -$5a10(a5), a0
007a: 2008                 move.l     a0, d0
007c: 4cdf1080             movem.l    (a7)+, d7/a4
0080: 4e5e                 unlk       a6
0082: 4e75                 rts        
0084: 4e560000             link.w     a6, #$0
0088: 48e70138             movem.l    d7/a2-a4, -(a7)
008c: 246e0008             movea.l    $8(a6), a2
0090: 49eda5f0             lea.l      -$5a10(a5), a4
0094: 7022                 moveq      #$22, d0
0096: c1edcf04             muls.w     -$30fc(a5), d0
009a: 47eda5f0             lea.l      -$5a10(a5), a3
009e: d08b                 add.l      a3, d0
00a0: 2640                 movea.l    d0, a3
00a2: 2e2a0014             move.l     $14(a2), d7
00a6: deaa0010             add.l      $10(a2), d7
00aa: deaa0018             add.l      $18(a2), d7
00ae: 6030                 bra.b      $e0
00b0: 2f0c                 move.l     a4, -(a7)
00b2: 2f0a                 move.l     a2, -(a7)
00b4: 4ead0db2             jsr        $db2(a5) ; CODE52+0242
00b8: 4a40                 tst.w      d0
00ba: 508f                 addq.l     #$8, a7
00bc: 661e                 bne.b      $dc
00be: 202c0010             move.l     $10(a4), d0
00c2: d0ac0014             add.l      $14(a4), d0
00c6: d0ac0018             add.l      $18(a4), d0
00ca: b087                 cmp.l      d7, d0
00cc: 6d04                 blt.b      $d2
00ce: 7000                 moveq      #$0, d0
00d0: 6014                 bra.b      $e6
00d2: 2f0c                 move.l     a4, -(a7)
00d4: 4eba0098             jsr        $16e(pc)
00d8: 588f                 addq.l     #$4, a7
00da: 6008                 bra.b      $e4
00dc: 49ec0022             lea.l      $22(a4), a4
00e0: b7cc                 cmpa.l     a4, a3
00e2: 62cc                 bhi.b      $b0
00e4: 7001                 moveq      #$1, d0
00e6: 4cdf1c80             movem.l    (a7)+, d7/a2-a4
00ea: 4e5e                 unlk       a6
00ec: 4e75                 rts        
00ee: 4e560000             link.w     a6, #$0
00f2: 48e70118             movem.l    d7/a3-a4, -(a7)
00f6: 286e0008             movea.l    $8(a6), a4
00fa: 0c6d0001b1d6         cmpi.w     #$1, -$4e2a(a5)
0100: 664a                 bne.b      $14c
0102: 0c2c000f0020         cmpi.b     #$f, $20(a4)
0108: 6f42                 ble.b      $14c
010a: 1e2c0020             move.b     $20(a4), d7
010e: 102c0021             move.b     $21(a4), d0
0112: 4880                 ext.w      d0
0114: 1207                 move.b     d7, d1
0116: 4881                 ext.w      d1
0118: c3fc0011             muls.w     #$11, d1
011c: 47edbcfe             lea.l      -$4302(a5), a3
0120: d28b                 add.l      a3, d1
0122: 3640                 movea.w    d0, a3
0124: d28b                 add.l      a3, d1
0126: 2641                 movea.l    d1, a3
0128: 6002                 bra.b      $12c
012a: 528b                 addq.l     #$1, a3
012c: 4a13                 tst.b      (a3)
012e: 66fa                 bne.b      $12a
0130: 0c070010             cmpi.b     #$10, d7
0134: 6706                 beq.b      $13c
0136: 4a2bffef             tst.b      -$11(a3)
013a: 660c                 bne.b      $148
013c: 0c07001e             cmpi.b     #$1e, d7
0140: 670a                 beq.b      $14c
0142: 4a2b0011             tst.b      $11(a3)
0146: 6704                 beq.b      $14c
0148: 7000                 moveq      #$0, d0
014a: 601a                 bra.b      $166
014c: 4aadb3e2             tst.l      -$4c1e(a5)
0150: 6712                 beq.b      $164
0152: 2f0c                 move.l     a4, -(a7)
0154: 206db3e2             movea.l    -$4c1e(a5), a0
0158: 4e90                 jsr        (a0)
015a: 4a40                 tst.w      d0
015c: 588f                 addq.l     #$4, a7
015e: 6604                 bne.b      $164
0160: 7000                 moveq      #$0, d0
0162: 6002                 bra.b      $166
0164: 7001                 moveq      #$1, d0
0166: 4cdf1880             movem.l    (a7)+, d7/a3-a4
016a: 4e5e                 unlk       a6
016c: 4e75                 rts        
016e: 4e56fffc             link.w     a6, #$fffc
0172: 2f0c                 move.l     a4, -(a7)
0174: 536dcf04             subq.w     #$1, -$30fc(a5)
0178: 7022                 moveq      #$22, d0
017a: c1edcf04             muls.w     -$30fc(a5), d0
017e: 49eda5f0             lea.l      -$5a10(a5), a4
0182: d08c                 add.l      a4, d0
0184: 2840                 movea.l    d0, a4
0186: 6012                 bra.b      $19a
0188: 206e0008             movea.l    $8(a6), a0
018c: 43e8ffde             lea.l      -$22(a0), a1
0190: 7007                 moveq      #$7, d0
0192: 22d8                 move.l     (a0)+, (a1)+
0194: 51c8fffc             dbra       d0, $192
0198: 32d8                 move.w     (a0)+, (a1)+
019a: 7022                 moveq      #$22, d0
019c: d1ae0008             add.l      d0, $8(a6)
01a0: b9ee0008             cmpa.l     $8(a6), a4
01a4: 64e2                 bcc.b      $188
01a6: 285f                 movea.l    (a7)+, a4
01a8: 4e5e                 unlk       a6
01aa: 4e75                 rts        
