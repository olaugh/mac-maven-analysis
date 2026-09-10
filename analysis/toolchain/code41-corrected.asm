0004: 4e56ff00             link.w     a6, #$ff00
0008: 2f2e0008             move.l     $8(a6), -(a7)
000c: 486eff00             pea.l      -$100(a6)
0010: 4ead07da             jsr        $7da(a5) ; CODE23+00bc
0014: 2e80                 move.l     d0, (a7)
0016: 42a7                 clr.l      -(a7)
0018: 42a7                 clr.l      -(a7)
001a: 42a7                 clr.l      -(a7)
001c: a98b                 dc.w       $a98b
001e: 4e5e                 unlk       a6
0020: 4e75                 rts        
0022: 4e56fff8             link.w     a6, #$fff8
0026: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
002a: 3e2e0008             move.w     $8(a6), d7
002e: a850                 dc.w       $a850
0030: 486efff8             pea.l      -$8(a6)
0034: 3f07                 move.w     d7, -(a7)
0036: 2f3c4449544c         move.l     #$4449544c, -(a7)
003c: 4ead060a             jsr        $60a(a5) ; CODE9+0a1c
0040: 2840                 movea.l    d0, a4
0042: 200c                 move.l     a4, d0
0044: 4fef000a             lea.l      $a(a7), a7
0048: 6604                 bne.b      $4e
004a: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
004e: 486efff8             pea.l      -$8(a6)
0052: 3f07                 move.w     d7, -(a7)
0054: 2f3c4449544c         move.l     #$4449544c, -(a7)
005a: 4ead0d12             jsr        $d12(a5) ; CODE49+00bc
005e: 4297                 clr.l      (a7)
0060: 42a7                 clr.l      -(a7)
0062: 486efff8             pea.l      -$8(a6)
0066: 2f2e000a             move.l     $a(a6), -(a7)
006a: 2f3c08050100         move.l     #$8050100, -(a7)
0070: 4878ffff             pea.l      $ffff.w
0074: 4227                 clr.b      -(a7)
0076: 486dfb26             pea.l      -$4da(a5)
007a: 2f0c                 move.l     a4, -(a7)
007c: a97d                 dc.w       $a97d
007e: 265f                 movea.l    (a7)+, a3
0080: 200b                 move.l     a3, d0
0082: 5c8f                 addq.l     #$6, a7
0084: 6604                 bne.b      $8a
0086: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
008a: 2f0b                 move.l     a3, -(a7)
008c: 4ead0212             jsr        $212(a5) ; CODE11+0180
0090: 4257                 clr.w      (a7)
0092: 4ead01da             jsr        $1da(a5) ; CODE11+03a2
0096: 4ead0c42             jsr        $c42(a5) ; CODE46+0a2a
009a: 2eae0012             move.l     $12(a6), (a7)
009e: 2f0b                 move.l     a3, -(a7)
00a0: 206e000e             movea.l    $e(a6), a0
00a4: 4e90                 jsr        (a0)
00a6: 3c00                 move.w     d0, d6
00a8: 3ebc0001             move.w     #$1, (a7)
00ac: 4ead01da             jsr        $1da(a5) ; CODE11+03a2
00b0: 2e8b                 move.l     a3, (a7)
00b2: 3f07                 move.w     d7, -(a7)
00b4: 2f3c4449544c         move.l     #$4449544c, -(a7)
00ba: 4ead0d1a             jsr        $d1a(a5) ; CODE49+0132
00be: 2e8b                 move.l     a3, (a7)
00c0: 4ead021a             jsr        $21a(a5) ; CODE11+01aa
00c4: 2e8b                 move.l     a3, (a7)
00c6: a983                 dc.w       $a983
00c8: 4ead0c42             jsr        $c42(a5) ; CODE46+0a2a
00cc: 3006                 move.w     d6, d0
00ce: 4cee18c0ffe8         movem.l    -$18(a6), d6-d7/a3-a4
00d4: 4e5e                 unlk       a6
00d6: 4e75                 rts        
00d8: 4e560000             link.w     a6, #$0
00dc: 2f2e000a             move.l     $a(a6), -(a7)
00e0: 486d0c5a             pea.l      $c5a(a5)
00e4: 2f2df248             move.l     -$db8(a5), -(a7)
00e8: 3f2e0008             move.w     $8(a6), -(a7)
00ec: 4ebaff34             jsr        $22(pc)
00f0: 4e5e                 unlk       a6
00f2: 4e75                 rts        
00f4: 4e56fffe             link.w     a6, #$fffe
00f8: 2f2e000c             move.l     $c(a6), -(a7)
00fc: 486efffe             pea.l      -$2(a6)
0100: a991                 dc.w       $a991
0102: 302efffe             move.w     -$2(a6), d0
0106: 4e5e                 unlk       a6
0108: 4e75                 rts        
010a: 4e560000             link.w     a6, #$0
010e: a850                 dc.w       $a850
0110: 486d0c8a             pea.l      $c8a(a5)
0114: 3f2e0008             move.w     $8(a6), -(a7)
0118: 4ebaffbe             jsr        $d8(pc)
011c: 4e5e                 unlk       a6
011e: 4e75                 rts        
0120: 4e56fff4             link.w     a6, #$fff4
0124: 48e70118             movem.l    d7/a3-a4, -(a7)
0128: 266e000c             movea.l    $c(a6), a3
012c: 286e0010             movea.l    $10(a6), a4
0130: 3e13                 move.w     (a3), d7
0132: 0c470003             cmpi.w     #$3, d7
0136: 6706                 beq.b      $13e
0138: 0c470005             cmpi.w     #$5, d7
013c: 6638                 bne.b      $176
013e: 3e2b0004             move.w     $4(a3), d7
0142: 024700ff             andi.w     #$ff, d7
0146: 0c470003             cmpi.w     #$3, d7
014a: 6706                 beq.b      $152
014c: 0c47000d             cmpi.w     #$d, d7
0150: 6618                 bne.b      $16a
0152: 4a6c00a8             tst.w      $a8(a4)
0156: 6712                 beq.b      $16a
0158: 206e0008             movea.l    $8(a6), a0
015c: 30ac00a8             move.w     $a8(a4), (a0)
0160: 1d7c00010014         move.b     #$1, $14(a6)
0166: 600000c2             bra.w      $22a
016a: 2f0b                 move.l     a3, -(a7)
016c: 4ead0222             jsr        $222(a5) ; CODE11+05ee
0170: 588f                 addq.l     #$4, a7
0172: 600000b0             bra.w      $224
0176: 0c470006             cmpi.w     #$6, d7
017a: 6706                 beq.b      $182
017c: 0c470008             cmpi.w     #$8, d7
0180: 660c                 bne.b      $18e
0182: 2f0b                 move.l     a3, -(a7)
0184: 4ead0222             jsr        $222(a5) ; CODE11+05ee
0188: 588f                 addq.l     #$4, a7
018a: 60000098             bra.w      $224
018e: 0c470001             cmpi.w     #$1, d7
0192: 66000082             bne.w      $216
0196: 4267                 clr.w      -(a7)
0198: 2f2b000a             move.l     $a(a3), -(a7)
019c: 486efffc             pea.l      -$4(a6)
01a0: a92c                 dc.w       $a92c
01a2: 3e1f                 move.w     (a7)+, d7
01a4: b9eefffc             cmpa.l     -$4(a6), a4
01a8: 6624                 bne.b      $1ce
01aa: 0c470004             cmpi.w     #$4, d7
01ae: 672a                 beq.b      $1da
01b0: 0c470003             cmpi.w     #$3, d7
01b4: 6724                 beq.b      $1da
01b6: 0c470005             cmpi.w     #$5, d7
01ba: 671e                 beq.b      $1da
01bc: 0c470007             cmpi.w     #$7, d7
01c0: 6718                 beq.b      $1da
01c2: 0c470008             cmpi.w     #$8, d7
01c6: 6712                 beq.b      $1da
01c8: 0c470006             cmpi.w     #$6, d7
01cc: 670c                 beq.b      $1da
01ce: 3f3c0001             move.w     #$1, -(a7)
01d2: 4ead0c9a             jsr        $c9a(a5) ; CODE48+0004
01d6: 548f                 addq.l     #$2, a7
01d8: 604a                 bra.b      $224
01da: 0c470003             cmpi.w     #$3, d7
01de: 662c                 bne.b      $20c
01e0: 2d6b000afff8         move.l     $a(a3), -$8(a6)
01e6: 2f2efffc             move.l     -$4(a6), -(a7)
01ea: a873                 dc.w       $a873
01ec: 486efff8             pea.l      -$8(a6)
01f0: a871                 dc.w       $a871
01f2: 4267                 clr.w      -(a7)
01f4: 2f2efff8             move.l     -$8(a6), -(a7)
01f8: 2f2efffc             move.l     -$4(a6), -(a7)
01fc: 486efff4             pea.l      -$c(a6)
0200: a96c                 dc.w       $a96c
0202: 3e1f                 move.w     (a7)+, d7
0204: 6706                 beq.b      $20c
0206: 422e0014             clr.b      $14(a6)
020a: 601e                 bra.b      $22a
020c: 2f0b                 move.l     a3, -(a7)
020e: 4ead0222             jsr        $222(a5) ; CODE11+05ee
0212: 588f                 addq.l     #$4, a7
0214: 600e                 bra.b      $224
0216: 4a47                 tst.w      d7
0218: 660a                 bne.b      $224
021a: 2f0b                 move.l     a3, -(a7)
021c: 2f0c                 move.l     a4, -(a7)
021e: 4ead022a             jsr        $22a(a5) ; CODE11+0afe
0222: 508f                 addq.l     #$8, a7
0224: 4253                 clr.w      (a3)
0226: 422e0014             clr.b      $14(a6)
022a: 4cdf1880             movem.l    (a7)+, d7/a3-a4
022e: 4e5e                 unlk       a6
0230: 205f                 movea.l    (a7)+, a0
0232: 4fef000c             lea.l      $c(a7), a7
0236: 4ed0                 jmp        (a0)
0238: 4e560000             link.w     a6, #$0
023c: 2f2e0008             move.l     $8(a6), -(a7)
0240: 4ebafdc2             jsr        $4(pc)
0244: 3ebc03fd             move.w     #$3fd, (a7)
0248: 4ebafec0             jsr        $10a(pc)
024c: 4e5e                 unlk       a6
024e: 4e75                 rts        
0250: 4e560000             link.w     a6, #$0
0254: 2f2e0008             move.l     $8(a6), -(a7)
0258: 42a7                 clr.l      -(a7)
025a: 42a7                 clr.l      -(a7)
025c: 42a7                 clr.l      -(a7)
025e: a98b                 dc.w       $a98b
0260: 3f3c03fc             move.w     #$3fc, -(a7)
0264: 4ebafea4             jsr        $10a(pc)
0268: 5540                 subq.w     #$2, d0
026a: 548f                 addq.l     #$2, a7
026c: 6626                 bne.b      $294
026e: 2b6d93aca222         move.l     -$6c54(a5), -$5dde(a5)
0274: 536da386             subq.w     #$1, -$5c7a(a5)
0278: 702c                 moveq      #$2c, d0
027a: c1eda386             muls.w     -$5c7a(a5), d0
027e: 41eda226             lea.l      -$5dda(a5), a0
0282: d088                 add.l      a0, d0
0284: 2040                 movea.l    d0, a0
0286: 7001                 moveq      #$1, d0
0288: 4a40                 tst.w      d0
028a: 6602                 bne.b      $28e
028c: 7001                 moveq      #$1, d0
028e: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
0292: 4ed1                 jmp        (a1)
0294: 4e5e                 unlk       a6
0296: 4e75                 rts        
