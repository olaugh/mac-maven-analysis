0004: 4e56fdc2             link.w     a6, #$fdc2
0008: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
000c: 286e000c             movea.l    $c(a6), a4
0010: 7800                 moveq      #$0, d4
0012: 1e14                 move.b     (a4), d7
0014: 4887                 ext.w      d7
0016: 600009b2             bra.w      $9ca
001a: 0c470025             cmpi.w     #$25, d7
001e: 660008a0             bne.w      $8c0
0022: 2d6df442fde6         move.l     -$bbe(a5), -$21a(a6)
0028: 2d6df446fdea         move.l     -$bba(a5), -$216(a6)
002e: 528c                 addq.l     #$1, a4
0030: 1e14                 move.b     (a4), d7
0032: 4887                 ext.w      d7
0034: 0c47002d             cmpi.w     #$2d, d7
0038: 6608                 bne.b      $42
003a: 08ee0007fde6         bset.b     #$7, -$21a(a6)
0040: 60ec                 bra.b      $2e
0042: 0c47002b             cmpi.w     #$2b, d7
0046: 6608                 bne.b      $50
0048: 08ee0006fde6         bset.b     #$6, -$21a(a6)
004e: 60de                 bra.b      $2e
0050: 0c470020             cmpi.w     #$20, d7
0054: 6608                 bne.b      $5e
0056: 1d7c0020fde8         move.b     #$20, -$218(a6)
005c: 60d0                 bra.b      $2e
005e: 0c470023             cmpi.w     #$23, d7
0062: 6608                 bne.b      $6c
0064: 08ee0005fde6         bset.b     #$5, -$21a(a6)
006a: 60c2                 bra.b      $2e
006c: 0c470030             cmpi.w     #$30, d7
0070: 6608                 bne.b      $7a
0072: 08ee0004fde6         bset.b     #$4, -$21a(a6)
0078: 60b4                 bra.b      $2e
007a: 0c47002a             cmpi.w     #$2a, d7
007e: 6640                 bne.b      $c0
0080: 206e0010             movea.l    $10(a6), a0
0084: 54ae0010             addq.l     #$2, $10(a6)
0088: 3010                 move.w     (a0), d0
008a: 3d40fdea             move.w     d0, -$216(a6)
008e: 4a40                 tst.w      d0
0090: 6c10                 bge.b      $a2
0092: 08ee0007fde6         bset.b     #$7, -$21a(a6)
0098: 302efdea             move.w     -$216(a6), d0
009c: 4440                 neg.w      d0
009e: 3d40fdea             move.w     d0, -$216(a6)
00a2: 528c                 addq.l     #$1, a4
00a4: 1e14                 move.b     (a4), d7
00a6: 4887                 ext.w      d7
00a8: 6022                 bra.b      $cc
00aa: 700a                 moveq      #$a, d0
00ac: c1eefdea             muls.w     -$216(a6), d0
00b0: 0640ffd0             addi.w     #$ffd0, d0
00b4: d047                 add.w      d7, d0
00b6: 3d40fdea             move.w     d0, -$216(a6)
00ba: 528c                 addq.l     #$1, a4
00bc: 1e14                 move.b     (a4), d7
00be: 4887                 ext.w      d7
00c0: 0c470030             cmpi.w     #$30, d7
00c4: 6d06                 blt.b      $cc
00c6: 0c470039             cmpi.w     #$39, d7
00ca: 6fde                 ble.b      $aa
00cc: 0c47002e             cmpi.w     #$2e, d7
00d0: 664e                 bne.b      $120
00d2: 528c                 addq.l     #$1, a4
00d4: 1e14                 move.b     (a4), d7
00d6: 4887                 ext.w      d7
00d8: 0c47002a             cmpi.w     #$2a, d7
00dc: 662a                 bne.b      $108
00de: 206e0010             movea.l    $10(a6), a0
00e2: 54ae0010             addq.l     #$2, $10(a6)
00e6: 3d50fdec             move.w     (a0), -$214(a6)
00ea: 528c                 addq.l     #$1, a4
00ec: 1e14                 move.b     (a4), d7
00ee: 4887                 ext.w      d7
00f0: 6022                 bra.b      $114
00f2: 700a                 moveq      #$a, d0
00f4: c1eefdec             muls.w     -$214(a6), d0
00f8: 0640ffd0             addi.w     #$ffd0, d0
00fc: d047                 add.w      d7, d0
00fe: 3d40fdec             move.w     d0, -$214(a6)
0102: 528c                 addq.l     #$1, a4
0104: 1e14                 move.b     (a4), d7
0106: 4887                 ext.w      d7
0108: 0c470030             cmpi.w     #$30, d7
010c: 6d06                 blt.b      $114
010e: 0c470039             cmpi.w     #$39, d7
0112: 6fde                 ble.b      $f2
0114: 4a6efdec             tst.w      -$214(a6)
0118: 6d06                 blt.b      $120
011a: 08ee0003fde6         bset.b     #$3, -$21a(a6)
0120: 45eefff6             lea.l      -$a(a6), a2
0124: 4a2efde6             tst.b      -$21a(a6)
0128: 6a06                 bpl.b      $130
012a: 08ae0004fde6         bclr.b     #$4, -$21a(a6)
0130: 3007                 move.w     d7, d0
0132: 04400045             subi.w     #$45, d0
0136: 0c400033             cmpi.w     #$33, d0
013a: 6200077c             bhi.w      $8b8
013e: 43fa089c             lea.l      $9dc(pc), a1
0142: d040                 add.w      d0, d0
0144: d2f10000             adda.w     (a1, d0.w), a1
0148: 4ed1                 jmp        (a1)
014a: 206e0010             movea.l    $10(a6), a0
014e: 58ae0010             addq.l     #$4, $10(a6)
0152: 2650                 movea.l    (a0), a3
0154: 4a2b0020             tst.b      $20(a3)
0158: 6716                 beq.b      $170
015a: 2f0b                 move.l     a3, -(a7)
015c: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
0160: 538a                 subq.l     #$1, a2
0162: 95c0                 suba.l     d0, a2
0164: 2e8b                 move.l     a3, (a7)
0166: 2f0a                 move.l     a2, -(a7)
0168: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
016c: 508f                 addq.l     #$8, a7
016e: 6046                 bra.b      $1b6
0170: 082e0005fde6         btst.b     #$5, -$21a(a6)
0176: 671a                 beq.b      $192
0178: 2f0b                 move.l     a3, -(a7)
017a: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
017e: 3e80                 move.w     d0, (a7)
0180: 2f2da1e6             move.l     -$5e1a(a5), -(a7)
0184: 486efdf6             pea.l      -$20a(a6)
0188: 4eba151c             jsr        $16a6(pc)
018c: 4fef000c             lea.l      $c(a7), a7
0190: 6012                 bra.b      $1a4
0192: 2f0b                 move.l     a3, -(a7)
0194: 2f2da1e2             move.l     -$5e1e(a5), -(a7)
0198: 486efdf6             pea.l      -$20a(a6)
019c: 4eba1508             jsr        $16a6(pc)
01a0: 4fef000c             lea.l      $c(a7), a7
01a4: 3040                 movea.w    d0, a0
01a6: 95c8                 suba.l     a0, a2
01a8: 538a                 subq.l     #$1, a2
01aa: 486efdf6             pea.l      -$20a(a6)
01ae: 2f0a                 move.l     a2, -(a7)
01b0: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
01b4: 508f                 addq.l     #$8, a7
01b6: 08ae0005fde6         bclr.b     #$5, -$21a(a6)
01bc: 0c470057             cmpi.w     #$57, d7
01c0: 66000666             bne.w      $828
01c4: 2f0a                 move.l     a2, -(a7)
01c6: 2f0a                 move.l     a2, -(a7)
01c8: 4ead07ea             jsr        $7ea(a5) ; CODE23+01fe
01cc: 508f                 addq.l     #$8, a7
01ce: 60000658             bra.w      $828
01d2: 206e0010             movea.l    $10(a6), a0
01d6: 58ae0010             addq.l     #$4, $10(a6)
01da: 2650                 movea.l    (a0), a3
01dc: 4a2b0020             tst.b      $20(a3)
01e0: 6606                 bne.b      $1e8
01e2: 4212                 clr.b      (a2)
01e4: 60000642             bra.w      $828
01e8: 0c2b00100020         cmpi.b     #$10, $20(a3)
01ee: 6c28                 bge.b      $218
01f0: 70ff                 moveq      #$ff, d0
01f2: d02b0021             add.b      $21(a3), d0
01f6: 06000041             addi.b     #$41, d0
01fa: 4880                 ext.w      d0
01fc: 3f00                 move.w     d0, -(a7)
01fe: 102b0020             move.b     $20(a3), d0
0202: 4880                 ext.w      d0
0204: 3f00                 move.w     d0, -(a7)
0206: 2f2da1c2             move.l     -$5e3e(a5), -(a7)
020a: 486efdf6             pea.l      -$20a(a6)
020e: 4eba1496             jsr        $16a6(pc)
0212: 4fef000c             lea.l      $c(a7), a7
0216: 6026                 bra.b      $23e
0218: 102b0021             move.b     $21(a3), d0
021c: 4880                 ext.w      d0
021e: 3f00                 move.w     d0, -(a7)
0220: 70f0                 moveq      #$f0, d0
0222: d02b0020             add.b      $20(a3), d0
0226: 06000041             addi.b     #$41, d0
022a: 4880                 ext.w      d0
022c: 3f00                 move.w     d0, -(a7)
022e: 2f2da1c6             move.l     -$5e3a(a5), -(a7)
0232: 486efdf6             pea.l      -$20a(a6)
0236: 4eba146e             jsr        $16a6(pc)
023a: 4fef000c             lea.l      $c(a7), a7
023e: 3040                 movea.w    d0, a0
0240: 95c8                 suba.l     a0, a2
0242: 538a                 subq.l     #$1, a2
0244: 486efdf6             pea.l      -$20a(a6)
0248: 2f0a                 move.l     a2, -(a7)
024a: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
024e: 508f                 addq.l     #$8, a7
0250: 600005d6             bra.w      $828
0254: 206e0010             movea.l    $10(a6), a0
0258: 58ae0010             addq.l     #$4, $10(a6)
025c: 2650                 movea.l    (a0), a3
025e: 3f2b001e             move.w     $1e(a3), -(a7)
0262: 4ead0992             jsr        $992(a5) ; CODE32+0650
0266: 2440                 movea.l    d0, a2
0268: 0c470052             cmpi.w     #$52, d7
026c: 548f                 addq.l     #$2, a7
026e: 660005b8             bne.w      $828
0272: 2f0a                 move.l     a2, -(a7)
0274: 2f0a                 move.l     a2, -(a7)
0276: 4ead07ea             jsr        $7ea(a5) ; CODE23+01fe
027a: 508f                 addq.l     #$8, a7
027c: 600005aa             bra.w      $828
0280: 206e0010             movea.l    $10(a6), a0
0284: 58ae0010             addq.l     #$4, $10(a6)
0288: 2650                 movea.l    (a0), a3
028a: 486b0010             pea.l      $10(a3)
028e: 486efff6             pea.l      -$a(a6)
0292: 3f3c280e             move.w     #$280e, -(a7)
0296: a9eb                 dc.w       $a9eb
0298: 0c470054             cmpi.w     #$54, d7
029c: 661a                 bne.b      $2b8
029e: 202b0018             move.l     $18(a3), d0
02a2: d0ab0014             add.l      $14(a3), d0
02a6: 2d40fdc2             move.l     d0, -$23e(a6)
02aa: 486efdc2             pea.l      -$23e(a6)
02ae: 486efff6             pea.l      -$a(a6)
02b2: 3f3c2800             move.w     #$2800, -(a7)
02b6: a9eb                 dc.w       $a9eb
02b8: 487a0720             pea.l      $9da(pc)
02bc: 486efff6             pea.l      -$a(a6)
02c0: 3f3c2006             move.w     #$2006, -(a7)
02c4: a9eb                 dc.w       $a9eb
02c6: 08ae0004fde6         bclr.b     #$4, -$21a(a6)
02cc: 08ae0006fde6         bclr.b     #$6, -$21a(a6)
02d2: 422efde9             clr.b      -$217(a6)
02d6: 082e0003fde6         btst.b     #$3, -$21a(a6)
02dc: 6604                 bne.b      $2e2
02de: 426efdec             clr.w      -$214(a6)
02e2: 486efff6             pea.l      -$a(a6)
02e6: 486efdc6             pea.l      -$23a(a6)
02ea: 3f2efdec             move.w     -$214(a6), -(a7)
02ee: 3f3c0001             move.w     #$1, -(a7)
02f2: 4eba0750             jsr        $a44(pc)
02f6: 4fef000c             lea.l      $c(a7), a7
02fa: 600002b0             bra.w      $5ac
02fe: 08ee0002fde6         bset.b     #$2, -$21a(a6)
0304: 528c                 addq.l     #$1, a4
0306: 1e14                 move.b     (a4), d7
0308: 4887                 ext.w      d7
030a: 6000fe24             bra.w      $130
030e: 08ee0001fde6         bset.b     #$1, -$21a(a6)
0314: 528c                 addq.l     #$1, a4
0316: 1e14                 move.b     (a4), d7
0318: 4887                 ext.w      d7
031a: 6000fe14             bra.w      $130
031e: 08ee0000fde6         bset.b     #$0, -$21a(a6)
0324: 528c                 addq.l     #$1, a4
0326: 1e14                 move.b     (a4), d7
0328: 4887                 ext.w      d7
032a: 6000fe04             bra.w      $130
032e: 082e0001fde6         btst.b     #$1, -$21a(a6)
0334: 670c                 beq.b      $342
0336: 206e0010             movea.l    $10(a6), a0
033a: 58ae0010             addq.l     #$4, $10(a6)
033e: 2610                 move.l     (a0), d3
0340: 600c                 bra.b      $34e
0342: 206e0010             movea.l    $10(a6), a0
0346: 54ae0010             addq.l     #$2, $10(a6)
034a: 3610                 move.w     (a0), d3
034c: 48c3                 ext.l      d3
034e: 082e0002fde6         btst.b     #$2, -$21a(a6)
0354: 6702                 beq.b      $358
0356: 48c3                 ext.l      d3
0358: 4a83                 tst.l      d3
035a: 6c0a                 bge.b      $366
035c: 4483                 neg.l      d3
035e: 1d7c002dfde8         move.b     #$2d, -$218(a6)
0364: 6042                 bra.b      $3a8
0366: 082e0006fde6         btst.b     #$6, -$21a(a6)
036c: 673a                 beq.b      $3a8
036e: 1d7c002bfde8         move.b     #$2b, -$218(a6)
0374: 6032                 bra.b      $3a8
0376: 082e0001fde6         btst.b     #$1, -$21a(a6)
037c: 670c                 beq.b      $38a
037e: 206e0010             movea.l    $10(a6), a0
0382: 58ae0010             addq.l     #$4, $10(a6)
0386: 2610                 move.l     (a0), d3
0388: 600c                 bra.b      $396
038a: 206e0010             movea.l    $10(a6), a0
038e: 54ae0010             addq.l     #$2, $10(a6)
0392: 7600                 moveq      #$0, d3
0394: 3610                 move.w     (a0), d3
0396: 082e0002fde6         btst.b     #$2, -$21a(a6)
039c: 6706                 beq.b      $3a4
039e: 7000                 moveq      #$0, d0
03a0: 3003                 move.w     d3, d0
03a2: 2600                 move.l     d0, d3
03a4: 422efde8             clr.b      -$218(a6)
03a8: 082e0003fde6         btst.b     #$3, -$21a(a6)
03ae: 6626                 bne.b      $3d6
03b0: 082e0004fde6         btst.b     #$4, -$21a(a6)
03b6: 6710                 beq.b      $3c8
03b8: 3d6efdeafdec         move.w     -$216(a6), -$214(a6)
03be: 4a2efde8             tst.b      -$218(a6)
03c2: 6704                 beq.b      $3c8
03c4: 536efdec             subq.w     #$1, -$214(a6)
03c8: 0c6e0001fdec         cmpi.w     #$1, -$214(a6)
03ce: 6c06                 bge.b      $3d6
03d0: 3d7c0001fdec         move.w     #$1, -$214(a6)
03d6: 7c00                 moveq      #$0, d6
03d8: 6020                 bra.b      $3fa
03da: 4878000a             pea.l      $a.w
03de: 2f03                 move.l     d3, -(a7)
03e0: 4ead0052             jsr        $52(a5) ; CODE1+0144
03e4: 06000030             addi.b     #$30, d0
03e8: 538a                 subq.l     #$1, a2
03ea: 1480                 move.b     d0, (a2)
03ec: 4878000a             pea.l      $a.w
03f0: 2f03                 move.l     d3, -(a7)
03f2: 4ead004a             jsr        $4a(a5) ; CODE1+0124
03f6: 2600                 move.l     d0, d3
03f8: 5246                 addq.w     #$1, d6
03fa: 4a83                 tst.l      d3
03fc: 66dc                 bne.b      $3da
03fe: 6008                 bra.b      $408
0400: 538a                 subq.l     #$1, a2
0402: 14bc0030             move.b     #$30, (a2)
0406: 5246                 addq.w     #$1, d6
0408: bc6efdec             cmp.w      -$214(a6), d6
040c: 6df2                 blt.b      $400
040e: 4a2efde8             tst.b      -$218(a6)
0412: 670004ec             beq.w      $900
0416: 538a                 subq.l     #$1, a2
0418: 14aefde8             move.b     -$218(a6), (a2)
041c: 5246                 addq.w     #$1, d6
041e: 600004e0             bra.w      $900
0422: 082e0001fde6         btst.b     #$1, -$21a(a6)
0428: 670c                 beq.b      $436
042a: 206e0010             movea.l    $10(a6), a0
042e: 58ae0010             addq.l     #$4, $10(a6)
0432: 2610                 move.l     (a0), d3
0434: 600c                 bra.b      $442
0436: 206e0010             movea.l    $10(a6), a0
043a: 54ae0010             addq.l     #$2, $10(a6)
043e: 7600                 moveq      #$0, d3
0440: 3610                 move.w     (a0), d3
0442: 082e0002fde6         btst.b     #$2, -$21a(a6)
0448: 6706                 beq.b      $450
044a: 7000                 moveq      #$0, d0
044c: 3003                 move.w     d3, d0
044e: 2600                 move.l     d0, d3
0450: 082e0003fde6         btst.b     #$3, -$21a(a6)
0456: 661c                 bne.b      $474
0458: 082e0004fde6         btst.b     #$4, -$21a(a6)
045e: 6706                 beq.b      $466
0460: 3d6efdeafdec         move.w     -$216(a6), -$214(a6)
0466: 0c6e0001fdec         cmpi.w     #$1, -$214(a6)
046c: 6c06                 bge.b      $474
046e: 3d7c0001fdec         move.w     #$1, -$214(a6)
0474: 7c00                 moveq      #$0, d6
0476: 6010                 bra.b      $488
0478: 7007                 moveq      #$7, d0
047a: c083                 and.l      d3, d0
047c: 06000030             addi.b     #$30, d0
0480: 538a                 subq.l     #$1, a2
0482: 1480                 move.b     d0, (a2)
0484: e68b                 lsr.l      #$3, d3
0486: 5246                 addq.w     #$1, d6
0488: 4a83                 tst.l      d3
048a: 66ec                 bne.b      $478
048c: 082e0005fde6         btst.b     #$5, -$21a(a6)
0492: 671c                 beq.b      $4b0
0494: 4a46                 tst.w      d6
0496: 6718                 beq.b      $4b0
0498: 0c120030             cmpi.b     #$30, (a2)
049c: 6712                 beq.b      $4b0
049e: 538a                 subq.l     #$1, a2
04a0: 14bc0030             move.b     #$30, (a2)
04a4: 5246                 addq.w     #$1, d6
04a6: 6008                 bra.b      $4b0
04a8: 538a                 subq.l     #$1, a2
04aa: 14bc0030             move.b     #$30, (a2)
04ae: 5246                 addq.w     #$1, d6
04b0: bc6efdec             cmp.w      -$214(a6), d6
04b4: 6df2                 blt.b      $4a8
04b6: 60000448             bra.w      $900
04ba: 08ee0001fde6         bset.b     #$1, -$21a(a6)
04c0: 08ee0003fde6         bset.b     #$3, -$21a(a6)
04c6: 3d7c0008fdec         move.w     #$8, -$214(a6)
04cc: 41edf46e             lea.l      -$b92(a5), a0
04d0: 2d48fdf2             move.l     a0, -$20e(a6)
04d4: 6008                 bra.b      $4de
04d6: 41edf480             lea.l      -$b80(a5), a0
04da: 2d48fdf2             move.l     a0, -$20e(a6)
04de: 082e0001fde6         btst.b     #$1, -$21a(a6)
04e4: 670c                 beq.b      $4f2
04e6: 206e0010             movea.l    $10(a6), a0
04ea: 58ae0010             addq.l     #$4, $10(a6)
04ee: 2610                 move.l     (a0), d3
04f0: 600c                 bra.b      $4fe
04f2: 206e0010             movea.l    $10(a6), a0
04f6: 54ae0010             addq.l     #$2, $10(a6)
04fa: 7600                 moveq      #$0, d3
04fc: 3610                 move.w     (a0), d3
04fe: 082e0002fde6         btst.b     #$2, -$21a(a6)
0504: 6706                 beq.b      $50c
0506: 7000                 moveq      #$0, d0
0508: 3003                 move.w     d3, d0
050a: 2600                 move.l     d0, d3
050c: 082e0003fde6         btst.b     #$3, -$21a(a6)
0512: 6628                 bne.b      $53c
0514: 082e0004fde6         btst.b     #$4, -$21a(a6)
051a: 6712                 beq.b      $52e
051c: 3d6efdeafdec         move.w     -$216(a6), -$214(a6)
0522: 082e0005fde6         btst.b     #$5, -$21a(a6)
0528: 6704                 beq.b      $52e
052a: 556efdec             subq.w     #$2, -$214(a6)
052e: 0c6e0001fdec         cmpi.w     #$1, -$214(a6)
0534: 6c06                 bge.b      $53c
0536: 3d7c0001fdec         move.w     #$1, -$214(a6)
053c: 7c00                 moveq      #$0, d6
053e: 6012                 bra.b      $552
0540: 700f                 moveq      #$f, d0
0542: c083                 and.l      d3, d0
0544: d0aefdf2             add.l      -$20e(a6), d0
0548: 2040                 movea.l    d0, a0
054a: 538a                 subq.l     #$1, a2
054c: 1490                 move.b     (a0), (a2)
054e: e88b                 lsr.l      #$4, d3
0550: 5246                 addq.w     #$1, d6
0552: 4a83                 tst.l      d3
0554: 66ea                 bne.b      $540
0556: 6008                 bra.b      $560
0558: 538a                 subq.l     #$1, a2
055a: 14bc0030             move.b     #$30, (a2)
055e: 5246                 addq.w     #$1, d6
0560: bc6efdec             cmp.w      -$214(a6), d6
0564: 6df2                 blt.b      $558
0566: 082e0005fde6         btst.b     #$5, -$21a(a6)
056c: 67000392             beq.w      $900
0570: 538a                 subq.l     #$1, a2
0572: 1487                 move.b     d7, (a2)
0574: 538a                 subq.l     #$1, a2
0576: 14bc0030             move.b     #$30, (a2)
057a: 5446                 addq.w     #$2, d6
057c: 60000382             bra.w      $900
0580: 082e0003fde6         btst.b     #$3, -$21a(a6)
0586: 6606                 bne.b      $58e
0588: 3d7c0006fdec         move.w     #$6, -$214(a6)
058e: 2f2e0010             move.l     $10(a6), -(a7)
0592: 486efdc6             pea.l      -$23a(a6)
0596: 3f2efdec             move.w     -$214(a6), -(a7)
059a: 3f3c0001             move.w     #$1, -(a7)
059e: 4eba04a4             jsr        $a44(pc)
05a2: 700a                 moveq      #$a, d0
05a4: d1ae0010             add.l      d0, $10(a6)
05a8: 4fef000c             lea.l      $c(a7), a7
05ac: 102efdca             move.b     -$236(a6), d0
05b0: 4880                 ext.w      d0
05b2: d06efdc8             add.w      -$238(a6), d0
05b6: 3d40fde2             move.w     d0, -$21e(a6)
05ba: 302efde2             move.w     -$21e(a6), d0
05be: 3d40fde0             move.w     d0, -$220(a6)
05c2: 5340                 subq.w     #$1, d0
05c4: 6f06                 ble.b      $5cc
05c6: 3d7c0001fde0         move.w     #$1, -$220(a6)
05cc: 302efde2             move.w     -$21e(a6), d0
05d0: d06efdec             add.w      -$214(a6), d0
05d4: 3d40fde4             move.w     d0, -$21c(a6)
05d8: 600000fe             bra.w      $6d8
05dc: 082e0003fde6         btst.b     #$3, -$21a(a6)
05e2: 6606                 bne.b      $5ea
05e4: 3d7c0006fdec         move.w     #$6, -$214(a6)
05ea: 1d47fde9             move.b     d7, -$217(a6)
05ee: 2f2e0010             move.l     $10(a6), -(a7)
05f2: 486efdc6             pea.l      -$23a(a6)
05f6: 7001                 moveq      #$1, d0
05f8: d06efdec             add.w      -$214(a6), d0
05fc: 3d40fde4             move.w     d0, -$21c(a6)
0600: 3f00                 move.w     d0, -(a7)
0602: 4267                 clr.w      -(a7)
0604: 4eba043e             jsr        $a44(pc)
0608: 7001                 moveq      #$1, d0
060a: 3d40fde2             move.w     d0, -$21e(a6)
060e: 3d40fde0             move.w     d0, -$220(a6)
0612: 102efdca             move.b     -$236(a6), d0
0616: 4880                 ext.w      d0
0618: 5340                 subq.w     #$1, d0
061a: d16efdc8             add.w      d0, -$238(a6)
061e: 4fef000c             lea.l      $c(a7), a7
0622: 600000ae             bra.w      $6d2
0626: 082e0003fde6         btst.b     #$3, -$21a(a6)
062c: 6608                 bne.b      $636
062e: 3d7c0006fdec         move.w     #$6, -$214(a6)
0634: 600c                 bra.b      $642
0636: 4a6efdec             tst.w      -$214(a6)
063a: 6606                 bne.b      $642
063c: 3d7c0001fdec         move.w     #$1, -$214(a6)
0642: 70fe                 moveq      #$fe, d0
0644: d007                 add.b      d7, d0
0646: 1d40fde9             move.b     d0, -$217(a6)
064a: 2f2e0010             move.l     $10(a6), -(a7)
064e: 486efdc6             pea.l      -$23a(a6)
0652: 302efdec             move.w     -$214(a6), d0
0656: 3d40fde4             move.w     d0, -$21c(a6)
065a: 3f00                 move.w     d0, -(a7)
065c: 4267                 clr.w      -(a7)
065e: 4eba03e4             jsr        $a44(pc)
0662: 7001                 moveq      #$1, d0
0664: 3d40fde2             move.w     d0, -$21e(a6)
0668: 3d40fde0             move.w     d0, -$220(a6)
066c: 102efdca             move.b     -$236(a6), d0
0670: 4880                 ext.w      d0
0672: 5340                 subq.w     #$1, d0
0674: d16efdc8             add.w      d0, -$238(a6)
0678: 0c6efffcfdc8         cmpi.w     #$fffc, -$238(a6)
067e: 4fef000c             lea.l      $c(a7), a7
0682: 6d24                 blt.b      $6a8
0684: 302efdc8             move.w     -$238(a6), d0
0688: b06efdec             cmp.w      -$214(a6), d0
068c: 6c1a                 bge.b      $6a8
068e: 422efde9             clr.b      -$217(a6)
0692: 302efdc8             move.w     -$238(a6), d0
0696: d16efde2             add.w      d0, -$21e(a6)
069a: 0c6e0001fde2         cmpi.w     #$1, -$21e(a6)
06a0: 6c06                 bge.b      $6a8
06a2: 3d6efde2fde0         move.w     -$21e(a6), -$220(a6)
06a8: 082e0005fde6         btst.b     #$5, -$21a(a6)
06ae: 6622                 bne.b      $6d2
06b0: 102efdca             move.b     -$236(a6), d0
06b4: 4880                 ext.w      d0
06b6: b06efde4             cmp.w      -$21c(a6), d0
06ba: 6c16                 bge.b      $6d2
06bc: 102efdca             move.b     -$236(a6), d0
06c0: 4880                 ext.w      d0
06c2: 3d40fde4             move.w     d0, -$21c(a6)
06c6: b06efde2             cmp.w      -$21e(a6), d0
06ca: 6c06                 bge.b      $6d2
06cc: 3d6efde2fde4         move.w     -$21e(a6), -$21c(a6)
06d2: 700a                 moveq      #$a, d0
06d4: d1ae0010             add.l      d0, $10(a6)
06d8: 0c2e0039fdcb         cmpi.b     #$39, -$235(a6)
06de: 6f18                 ble.b      $6f8
06e0: 422efde9             clr.b      -$217(a6)
06e4: 426efde2             clr.w      -$21e(a6)
06e8: 3d7c0001fde0         move.w     #$1, -$220(a6)
06ee: 102efdca             move.b     -$236(a6), d0
06f2: 4880                 ext.w      d0
06f4: 3d40fde4             move.w     d0, -$21c(a6)
06f8: 7c00                 moveq      #$0, d6
06fa: 4a2efde9             tst.b      -$217(a6)
06fe: 6764                 beq.b      $764
0700: 4a6efdc8             tst.w      -$238(a6)
0704: 6c08                 bge.b      $70e
0706: 302efdc8             move.w     -$238(a6), d0
070a: 4440                 neg.w      d0
070c: 6004                 bra.b      $712
070e: 302efdc8             move.w     -$238(a6), d0
0712: 48c0                 ext.l      d0
0714: 2600                 move.l     d0, d3
0716: 6020                 bra.b      $738
0718: 4878000a             pea.l      $a.w
071c: 2f03                 move.l     d3, -(a7)
071e: 4ead0052             jsr        $52(a5) ; CODE1+0144
0722: 06000030             addi.b     #$30, d0
0726: 538a                 subq.l     #$1, a2
0728: 1480                 move.b     d0, (a2)
072a: 4878000a             pea.l      $a.w
072e: 2f03                 move.l     d3, -(a7)
0730: 4ead004a             jsr        $4a(a5) ; CODE1+0124
0734: 2600                 move.l     d0, d3
0736: 5246                 addq.w     #$1, d6
0738: 4a83                 tst.l      d3
073a: 66dc                 bne.b      $718
073c: 6008                 bra.b      $746
073e: 538a                 subq.l     #$1, a2
0740: 14bc0030             move.b     #$30, (a2)
0744: 5246                 addq.w     #$1, d6
0746: 0c460002             cmpi.w     #$2, d6
074a: 6df2                 blt.b      $73e
074c: 4a6efdc8             tst.w      -$238(a6)
0750: 6c04                 bge.b      $756
0752: 702d                 moveq      #$2d, d0
0754: 6002                 bra.b      $758
0756: 702b                 moveq      #$2b, d0
0758: 538a                 subq.l     #$1, a2
075a: 1480                 move.b     d0, (a2)
075c: 538a                 subq.l     #$1, a2
075e: 14aefde9             move.b     -$217(a6), (a2)
0762: 5446                 addq.w     #$2, d6
0764: 3a2efde4             move.w     -$21c(a6), d5
0768: ba6efde2             cmp.w      -$21e(a6), d5
076c: 660c                 bne.b      $77a
076e: 082e0005fde6         btst.b     #$5, -$21a(a6)
0774: 6604                 bne.b      $77a
0776: 526efde2             addq.w     #$1, -$21e(a6)
077a: ba6efde2             cmp.w      -$21e(a6), d5
077e: 6608                 bne.b      $788
0780: 538a                 subq.l     #$1, a2
0782: 14bc002e             move.b     #$2e, (a2)
0786: 5246                 addq.w     #$1, d6
0788: 4a45                 tst.w      d5
078a: 6f16                 ble.b      $7a2
078c: 102efdca             move.b     -$236(a6), d0
0790: 4880                 ext.w      d0
0792: b045                 cmp.w      d5, d0
0794: 6d0c                 blt.b      $7a2
0796: 204e                 movea.l    a6, a0
0798: d0c5                 adda.w     d5, a0
079a: 1028fdca             move.b     -$236(a0), d0
079e: 4880                 ext.w      d0
07a0: 6002                 bra.b      $7a4
07a2: 7030                 moveq      #$30, d0
07a4: 538a                 subq.l     #$1, a2
07a6: 1480                 move.b     d0, (a2)
07a8: 5345                 subq.w     #$1, d5
07aa: ba6efde0             cmp.w      -$220(a6), d5
07ae: 6cca                 bge.b      $77a
07b0: 302efde4             move.w     -$21c(a6), d0
07b4: 9045                 sub.w      d5, d0
07b6: dc40                 add.w      d0, d6
07b8: 4a2efdc6             tst.b      -$23a(a6)
07bc: 6708                 beq.b      $7c6
07be: 1d7c002dfde8         move.b     #$2d, -$218(a6)
07c4: 600e                 bra.b      $7d4
07c6: 082e0006fde6         btst.b     #$6, -$21a(a6)
07cc: 6706                 beq.b      $7d4
07ce: 1d7c002bfde8         move.b     #$2b, -$218(a6)
07d4: 082e0004fde6         btst.b     #$4, -$21a(a6)
07da: 671a                 beq.b      $7f6
07dc: 3a2efdea             move.w     -$216(a6), d5
07e0: 4a2efde8             tst.b      -$218(a6)
07e4: 670c                 beq.b      $7f2
07e6: 5345                 subq.w     #$1, d5
07e8: 6008                 bra.b      $7f2
07ea: 538a                 subq.l     #$1, a2
07ec: 14bc0030             move.b     #$30, (a2)
07f0: 5246                 addq.w     #$1, d6
07f2: ba46                 cmp.w      d6, d5
07f4: 6ef4                 bgt.b      $7ea
07f6: 4a2efde8             tst.b      -$218(a6)
07fa: 67000104             beq.w      $900
07fe: 538a                 subq.l     #$1, a2
0800: 14aefde8             move.b     -$218(a6), (a2)
0804: 5246                 addq.w     #$1, d6
0806: 600000f8             bra.w      $900
080a: 206e0010             movea.l    $10(a6), a0
080e: 54ae0010             addq.l     #$2, $10(a6)
0812: 538a                 subq.l     #$1, a2
0814: 14a80001             move.b     $1(a0), (a2)
0818: 7c01                 moveq      #$1, d6
081a: 600000e4             bra.w      $900
081e: 206e0010             movea.l    $10(a6), a0
0822: 58ae0010             addq.l     #$4, $10(a6)
0826: 2450                 movea.l    (a0), a2
0828: 082e0005fde6         btst.b     #$5, -$21a(a6)
082e: 671e                 beq.b      $84e
0830: 7c00                 moveq      #$0, d6
0832: 1c1a                 move.b     (a2)+, d6
0834: 082e0003fde6         btst.b     #$3, -$21a(a6)
083a: 670000c4             beq.w      $900
083e: bc6efdec             cmp.w      -$214(a6), d6
0842: 6f0000bc             ble.w      $900
0846: 3c2efdec             move.w     -$214(a6), d6
084a: 600000b4             bra.w      $900
084e: 082e0003fde6         btst.b     #$3, -$21a(a6)
0854: 660e                 bne.b      $864
0856: 2f0a                 move.l     a2, -(a7)
0858: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
085c: 3c00                 move.w     d0, d6
085e: 588f                 addq.l     #$4, a7
0860: 6000009e             bra.w      $900
0864: 306efdec             movea.w    -$214(a6), a0
0868: 2f08                 move.l     a0, -(a7)
086a: 4267                 clr.w      -(a7)
086c: 2f0a                 move.l     a2, -(a7)
086e: 4ead0d92             jsr        $d92(a5) ; CODE52+01e6
0872: 2d40fdee             move.l     d0, -$212(a6)
0876: 4fef000a             lea.l      $a(a7), a7
087a: 6708                 beq.b      $884
087c: 2c2efdee             move.l     -$212(a6), d6
0880: 9c8a                 sub.l      a2, d6
0882: 607c                 bra.b      $900
0884: 3c2efdec             move.w     -$214(a6), d6
0888: 6076                 bra.b      $900
088a: 206e0010             movea.l    $10(a6), a0
088e: 58ae0010             addq.l     #$4, $10(a6)
0892: 2450                 movea.l    (a0), a2
0894: 082e0002fde6         btst.b     #$2, -$21a(a6)
089a: 6706                 beq.b      $8a2
089c: 3484                 move.w     d4, (a2)
089e: 60000124             bra.w      $9c4
08a2: 082e0001fde6         btst.b     #$1, -$21a(a6)
08a8: 6708                 beq.b      $8b2
08aa: 3044                 movea.w    d4, a0
08ac: 2488                 move.l     a0, (a2)
08ae: 60000114             bra.w      $9c4
08b2: 3484                 move.w     d4, (a2)
08b4: 6000010e             bra.w      $9c4
08b8: 0c470025             cmpi.w     #$25, d7
08bc: 66000112             bne.w      $9d0
08c0: 206e0008             movea.l    $8(a6), a0
08c4: 20280012             move.l     $12(a0), d0
08c8: 53a80012             subq.l     #$1, $12(a0)
08cc: 5380                 subq.l     #$1, d0
08ce: 6314                 bls.b      $8e4
08d0: 206e0008             movea.l    $8(a6), a0
08d4: 2268000e             movea.l    $e(a0), a1
08d8: 52a8000e             addq.l     #$1, $e(a0)
08dc: 1287                 move.b     d7, (a1)
08de: 7000                 moveq      #$0, d0
08e0: 1007                 move.b     d7, d0
08e2: 600c                 bra.b      $8f0
08e4: 2f2e0008             move.l     $8(a6), -(a7)
08e8: 3f07                 move.w     d7, -(a7)
08ea: 4eba108e             jsr        $197a(pc)
08ee: 5c8f                 addq.l     #$6, a7
08f0: 4a40                 tst.w      d0
08f2: 6c06                 bge.b      $8fa
08f4: 70ff                 moveq      #$ff, d0
08f6: 600000da             bra.w      $9d2
08fa: 5244                 addq.w     #$1, d4
08fc: 600000c6             bra.w      $9c4
0900: bc6efdea             cmp.w      -$216(a6), d6
0904: 6c52                 bge.b      $958
0906: 4a2efde6             tst.b      -$21a(a6)
090a: 6b4c                 bmi.b      $958
090c: 206e0008             movea.l    $8(a6), a0
0910: 20280012             move.l     $12(a0), d0
0914: 53a80012             subq.l     #$1, $12(a0)
0918: 5380                 subq.l     #$1, d0
091a: 6316                 bls.b      $932
091c: 206e0008             movea.l    $8(a6), a0
0920: 2268000e             movea.l    $e(a0), a1
0924: 52a8000e             addq.l     #$1, $e(a0)
0928: 7020                 moveq      #$20, d0
092a: 1280                 move.b     d0, (a1)
092c: 7200                 moveq      #$0, d1
092e: 1200                 move.b     d0, d1
0930: 6010                 bra.b      $942
0932: 2f2e0008             move.l     $8(a6), -(a7)
0936: 3f3c0020             move.w     #$20, -(a7)
093a: 4eba103e             jsr        $197a(pc)
093e: 3200                 move.w     d0, d1
0940: 5c8f                 addq.l     #$6, a7
0942: 4a41                 tst.w      d1
0944: 6c06                 bge.b      $94c
0946: 70ff                 moveq      #$ff, d0
0948: 60000088             bra.w      $9d2
094c: 5244                 addq.w     #$1, d4
094e: 536efdea             subq.w     #$1, -$216(a6)
0952: bc6efdea             cmp.w      -$216(a6), d6
0956: 6db4                 blt.b      $90c
0958: 2f2e0008             move.l     $8(a6), -(a7)
095c: 3046                 movea.w    d6, a0
095e: 2f08                 move.l     a0, -(a7)
0960: 48780001             pea.l      $1.w
0964: 2f0a                 move.l     a2, -(a7)
0966: 4eba0e1a             jsr        $1782(pc)
096a: 3046                 movea.w    d6, a0
096c: b1c0                 cmpa.l     d0, a0
096e: 4fef0010             lea.l      $10(a7), a7
0972: 6704                 beq.b      $978
0974: 70ff                 moveq      #$ff, d0
0976: 605a                 bra.b      $9d2
0978: d846                 add.w      d6, d4
097a: 6042                 bra.b      $9be
097c: 206e0008             movea.l    $8(a6), a0
0980: 20280012             move.l     $12(a0), d0
0984: 53a80012             subq.l     #$1, $12(a0)
0988: 5380                 subq.l     #$1, d0
098a: 6316                 bls.b      $9a2
098c: 206e0008             movea.l    $8(a6), a0
0990: 2268000e             movea.l    $e(a0), a1
0994: 52a8000e             addq.l     #$1, $e(a0)
0998: 7020                 moveq      #$20, d0
099a: 1280                 move.b     d0, (a1)
099c: 7200                 moveq      #$0, d1
099e: 1200                 move.b     d0, d1
09a0: 6010                 bra.b      $9b2
09a2: 2f2e0008             move.l     $8(a6), -(a7)
09a6: 3f3c0020             move.w     #$20, -(a7)
09aa: 4eba0fce             jsr        $197a(pc)
09ae: 3200                 move.w     d0, d1
09b0: 5c8f                 addq.l     #$6, a7
09b2: 4a41                 tst.w      d1
09b4: 6c04                 bge.b      $9ba
09b6: 70ff                 moveq      #$ff, d0
09b8: 6018                 bra.b      $9d2
09ba: 5244                 addq.w     #$1, d4
09bc: 5246                 addq.w     #$1, d6
09be: bc6efdea             cmp.w      -$216(a6), d6
09c2: 6db8                 blt.b      $97c
09c4: 528c                 addq.l     #$1, a4
09c6: 1e14                 move.b     (a4), d7
09c8: 4887                 ext.w      d7
09ca: 4a47                 tst.w      d7
09cc: 6600f64c             bne.w      $1a
09d0: 3004                 move.w     d4, d0
09d2: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
09d6: 4e5e                 unlk       a6
09d8: 4e75                 rts        
09da: 0064fc00             ori.w      #$fc00, -(a4)
09de: fedcfc4afedc         fbf.l      $fc4b08bc
09e4: fedcfedcfedc         fbf.l      $fedd08c2
09ea: f942                 dc.w       $f942
09ec: fedcfedcfedc         fbf.l      $fedd08ca
09f2: f7f6                 dc.w       $f7f6
09f4: fedcf878f8a4         fbf.l      $f879029a
09fa: f8a4fedc             fbf.w      $8d8
09fe: fedcf76efaf0         fbf.l      $f76f04f0
0a04: fedcfedcfedc         fbf.l      $fedd08e2
0a0a: fedcfedcfedc         fbf.l      $fedd08e8
0a10: fedcfedcfedc         fbf.l      $fedd08ee
0a16: fedcfe2ef952         fbf.l      $fe2f036a
0a1c: fc00fba4             fmovem     invalid, d0
0a20: fc4af922f952         fdbf       d2, $376
0a26: fedcfedcf932         fbf.l      $fedd035a
0a2c: fedcfeaefa46         fbf.l      $feaf0474
0a32: fadefedcf878         fbf.l      $fedd02ac
0a38: fe42fedc             fsult.b    d2
0a3c: f99a                 dc.w       $f99a
0a3e: fedcf76efafa         fbf.l      $f76f053a
0a44: 4e56fffc             link.w     a6, #$fffc
0a48: 48e70118             movem.l    d7/a3-a4, -(a7)
0a4c: 3e2e000a             move.w     $a(a6), d7
0a50: 266e000c             movea.l    $c(a6), a3
0a54: 0c470014             cmpi.w     #$14, d7
0a58: 6502                 bcs.b      $a5c
0a5a: 7e13                 moveq      #$13, d7
0a5c: 1d6e0009fffc         move.b     $9(a6), -$4(a6)
0a62: 3d47fffe             move.w     d7, -$2(a6)
0a66: 486efffc             pea.l      -$4(a6)
0a6a: 2f2e0010             move.l     $10(a6), -(a7)
0a6e: 2f0b                 move.l     a3, -(a7)
0a70: 3f3c000b             move.w     #$b, -(a7)
0a74: a9eb                 dc.w       $a9eb
0a76: 0c2b003f0005         cmpi.b     #$3f, $5(a3)
0a7c: 661a                 bne.b      $a98
0a7e: 422efffc             clr.b      -$4(a6)
0a82: 3d7c0013fffe         move.w     #$13, -$2(a6)
0a88: 486efffc             pea.l      -$4(a6)
0a8c: 2f2e0010             move.l     $10(a6), -(a7)
0a90: 2f0b                 move.l     a3, -(a7)
0a92: 3f3c000b             move.w     #$b, -(a7)
0a96: a9eb                 dc.w       $a9eb
0a98: 49eb0004             lea.l      $4(a3), a4
0a9c: 1e14                 move.b     (a4), d7
0a9e: 4887                 ext.w      d7
0aa0: 6006                 bra.b      $aa8
0aa2: 526b0002             addq.w     #$1, $2(a3)
0aa6: 5347                 subq.w     #$1, d7
0aa8: 0c470001             cmpi.w     #$1, d7
0aac: 6f08                 ble.b      $ab6
0aae: 0c3300307004         cmpi.b     #$30, $4(a3, d7.w)
0ab4: 67ec                 beq.b      $aa2
0ab6: 1887                 move.b     d7, (a4)
0ab8: 1e2b0005             move.b     $5(a3), d7
0abc: 0c070030             cmpi.b     #$30, d7
0ac0: 6608                 bne.b      $aca
0ac2: 4213                 clr.b      (a3)
0ac4: 426b0002             clr.w      $2(a3)
0ac8: 602e                 bra.b      $af8
0aca: 0c070049             cmpi.b     #$49, d7
0ace: 6612                 bne.b      $ae2
0ad0: 18bc0003             move.b     #$3, (a4)
0ad4: 177c004e0006         move.b     #$4e, $6(a3)
0ada: 177c00460007         move.b     #$46, $7(a3)
0ae0: 6016                 bra.b      $af8
0ae2: 0c07004e             cmpi.b     #$4e, d7
0ae6: 6610                 bne.b      $af8
0ae8: 18bc0005             move.b     #$5, (a4)
0aec: 177c00410006         move.b     #$41, $6(a3)
0af2: 177c004e0007         move.b     #$4e, $7(a3)
0af8: 4cdf1880             movem.l    (a7)+, d7/a3-a4
0afc: 4e5e                 unlk       a6
0afe: 4e75                 rts        
0b00: 4e56ffd8             link.w     a6, #$ffd8
0b04: 48e70f08             movem.l    d4-d7/a4, -(a7)
0b08: 426efffe             clr.w      -$2(a6)
0b0c: 426efffc             clr.w      -$4(a6)
0b10: 426efffa             clr.w      -$6(a6)
0b14: 206e000c             movea.l    $c(a6), a0
0b18: 1e10                 move.b     (a0), d7
0b1a: 4887                 ext.w      d7
0b1c: 60000854             bra.w      $1372
0b20: 0c470025             cmpi.w     #$25, d7
0b24: 660002de             bne.w      $e04
0b28: 2d6df44afff0         move.l     -$bb6(a5), -$10(a6)
0b2e: 52ae000c             addq.l     #$1, $c(a6)
0b32: 206e000c             movea.l    $c(a6), a0
0b36: 1e10                 move.b     (a0), d7
0b38: 4887                 ext.w      d7
0b3a: 0c47002a             cmpi.w     #$2a, d7
0b3e: 6612                 bne.b      $b52
0b40: 08ee0007fff0         bset.b     #$7, -$10(a6)
0b46: 52ae000c             addq.l     #$1, $c(a6)
0b4a: 206e000c             movea.l    $c(a6), a0
0b4e: 1e10                 move.b     (a0), d7
0b50: 4887                 ext.w      d7
0b52: 7000                 moveq      #$0, d0
0b54: 1007                 move.b     d7, d0
0b56: 204d                 movea.l    a5, a0
0b58: d1c0                 adda.l     d0, a0
0b5a: 08280004fbd8         btst.b     #$4, -$428(a0)
0b60: 673a                 beq.b      $b9c
0b62: 08ee0006fff0         bset.b     #$6, -$10(a6)
0b68: 700a                 moveq      #$a, d0
0b6a: c1eefff2             muls.w     -$e(a6), d0
0b6e: 0640ffd0             addi.w     #$ffd0, d0
0b72: d047                 add.w      d7, d0
0b74: 3d40fff2             move.w     d0, -$e(a6)
0b78: 52ae000c             addq.l     #$1, $c(a6)
0b7c: 206e000c             movea.l    $c(a6), a0
0b80: 1e10                 move.b     (a0), d7
0b82: 4887                 ext.w      d7
0b84: 7000                 moveq      #$0, d0
0b86: 1007                 move.b     d7, d0
0b88: 204d                 movea.l    a5, a0
0b8a: d1c0                 adda.l     d0, a0
0b8c: 08280004fbd8         btst.b     #$4, -$428(a0)
0b92: 66d4                 bne.b      $b68
0b94: 4a6efff2             tst.w      -$e(a6)
0b98: 6f0007de             ble.w      $1378
0b9c: 3007                 move.w     d7, d0
0b9e: 0440003f             subi.w     #$3f, d0
0ba2: 0c400039             cmpi.w     #$39, d0
0ba6: 62000254             bhi.w      $dfc
0baa: 43fa07e8             lea.l      $1394(pc), a1
0bae: d040                 add.w      d0, d0
0bb0: d2f10000             adda.w     (a1, d0.w), a1
0bb4: 4ed1                 jmp        (a1)
0bb6: 08ee0007fff1         bset.b     #$7, -$f(a6)
0bbc: 52ae000c             addq.l     #$1, $c(a6)
0bc0: 206e000c             movea.l    $c(a6), a0
0bc4: 1e10                 move.b     (a0), d7
0bc6: 4887                 ext.w      d7
0bc8: 60d2                 bra.b      $b9c
0bca: 08ee0006fff1         bset.b     #$6, -$f(a6)
0bd0: 52ae000c             addq.l     #$1, $c(a6)
0bd4: 206e000c             movea.l    $c(a6), a0
0bd8: 1e10                 move.b     (a0), d7
0bda: 4887                 ext.w      d7
0bdc: 60be                 bra.b      $b9c
0bde: 08ee0005fff1         bset.b     #$5, -$f(a6)
0be4: 52ae000c             addq.l     #$1, $c(a6)
0be8: 206e000c             movea.l    $c(a6), a0
0bec: 1e10                 move.b     (a0), d7
0bee: 4887                 ext.w      d7
0bf0: 60aa                 bra.b      $b9c
0bf2: 08ee0005fff0         bset.b     #$5, -$10(a6)
0bf8: 52ae000c             addq.l     #$1, $c(a6)
0bfc: 206e000c             movea.l    $c(a6), a0
0c00: 1e10                 move.b     (a0), d7
0c02: 4887                 ext.w      d7
0c04: 6096                 bra.b      $b9c
0c06: 7c0a                 moveq      #$a, d6
0c08: 6000035c             bra.w      $f66
0c0c: 7c00                 moveq      #$0, d6
0c0e: 60000356             bra.w      $f66
0c12: 7c08                 moveq      #$8, d6
0c14: 6000034a             bra.w      $f60
0c18: 7c0a                 moveq      #$a, d6
0c1a: 60000344             bra.w      $f60
0c1e: 08ee0006fff1         bset.b     #$6, -$f(a6)
0c24: 7c10                 moveq      #$10, d6
0c26: 60000338             bra.w      $f60
0c2a: 08ee0001fff0         bset.b     #$1, -$10(a6)
0c30: 3d7cfffffff6         move.w     #$ffff, -$a(a6)
0c36: 60000344             bra.w      $f7c
0c3a: 206e0008             movea.l    $8(a6), a0
0c3e: 20280012             move.l     $12(a0), d0
0c42: 53a80012             subq.l     #$1, $12(a0)
0c46: 4a80                 tst.l      d0
0c48: 6712                 beq.b      $c5c
0c4a: 206e0008             movea.l    $8(a6), a0
0c4e: 2268000e             movea.l    $e(a0), a1
0c52: 52a8000e             addq.l     #$1, $e(a0)
0c56: 7000                 moveq      #$0, d0
0c58: 1011                 move.b     (a1), d0
0c5a: 600a                 bra.b      $c66
0c5c: 2f2e0008             move.l     $8(a6), -(a7)
0c60: 4eba0cb4             jsr        $1916(pc)
0c64: 588f                 addq.l     #$4, a7
0c66: 3e00                 move.w     d0, d7
0c68: 526efffa             addq.w     #$1, -$6(a6)
0c6c: 7000                 moveq      #$0, d0
0c6e: 1007                 move.b     d7, d0
0c70: 204d                 movea.l    a5, a0
0c72: d1c0                 adda.l     d0, a0
0c74: 7006                 moveq      #$6, d0
0c76: c028fbd8             and.b      -$428(a0), d0
0c7a: 66be                 bne.b      $c3a
0c7c: 3f3c0001             move.w     #$1, -(a7)
0c80: 4eba0786             jsr        $1408(pc)
0c84: 548f                 addq.l     #$2, a7
0c86: 60000234             bra.w      $ebc
0c8a: 52ae000c             addq.l     #$1, $c(a6)
0c8e: 206e000c             movea.l    $c(a6), a0
0c92: 1e10                 move.b     (a0), d7
0c94: 4887                 ext.w      d7
0c96: 0c47005e             cmpi.w     #$5e, d7
0c9a: 6612                 bne.b      $cae
0c9c: 08ee0004fff0         bset.b     #$4, -$10(a6)
0ca2: 52ae000c             addq.l     #$1, $c(a6)
0ca6: 206e000c             movea.l    $c(a6), a0
0caa: 1e10                 move.b     (a0), d7
0cac: 4887                 ext.w      d7
0cae: 4267                 clr.w      -(a7)
0cb0: 4eba0756             jsr        $1408(pc)
0cb4: 548f                 addq.l     #$2, a7
0cb6: 4a47                 tst.w      d7
0cb8: 670006be             beq.w      $1378
0cbc: 7000                 moveq      #$0, d0
0cbe: 1007                 move.b     d7, d0
0cc0: 3f00                 move.w     d0, -(a7)
0cc2: 4eba0778             jsr        $143c(pc)
0cc6: 548f                 addq.l     #$2, a7
0cc8: 52ae000c             addq.l     #$1, $c(a6)
0ccc: 206e000c             movea.l    $c(a6), a0
0cd0: 1e10                 move.b     (a0), d7
0cd2: 4887                 ext.w      d7
0cd4: 0c47005d             cmpi.w     #$5d, d7
0cd8: 6758                 beq.b      $d32
0cda: 0c47002d             cmpi.w     #$2d, d7
0cde: 66d6                 bne.b      $cb6
0ce0: 206e000c             movea.l    $c(a6), a0
0ce4: 0c28005d0001         cmpi.b     #$5d, $1(a0)
0cea: 67ca                 beq.b      $cb6
0cec: 206e000c             movea.l    $c(a6), a0
0cf0: 10280001             move.b     $1(a0), d0
0cf4: 4880                 ext.w      d0
0cf6: 1220                 move.b     -(a0), d1
0cf8: 1d41fff5             move.b     d1, -$b(a6)
0cfc: 7400                 moveq      #$0, d2
0cfe: 1401                 move.b     d1, d2
0d00: b440                 cmp.w      d0, d2
0d02: 6eb2                 bgt.b      $cb6
0d04: 52ae000c             addq.l     #$1, $c(a6)
0d08: 206e000c             movea.l    $c(a6), a0
0d0c: 1e10                 move.b     (a0), d7
0d0e: 4887                 ext.w      d7
0d10: 6014                 bra.b      $d26
0d12: 102efff5             move.b     -$b(a6), d0
0d16: 522efff5             addq.b     #$1, -$b(a6)
0d1a: 7200                 moveq      #$0, d1
0d1c: 1200                 move.b     d0, d1
0d1e: 3f01                 move.w     d1, -(a7)
0d20: 4eba071a             jsr        $143c(pc)
0d24: 548f                 addq.l     #$2, a7
0d26: 7000                 moveq      #$0, d0
0d28: 102efff5             move.b     -$b(a6), d0
0d2c: be40                 cmp.w      d0, d7
0d2e: 66e2                 bne.b      $d12
0d30: 6084                 bra.b      $cb6
0d32: 082e0004fff0         btst.b     #$4, -$10(a6)
0d38: 6704                 beq.b      $d3e
0d3a: 4eba0720             jsr        $145c(pc)
0d3e: 206e0008             movea.l    $8(a6), a0
0d42: 20280012             move.l     $12(a0), d0
0d46: 53a80012             subq.l     #$1, $12(a0)
0d4a: 4a80                 tst.l      d0
0d4c: 6712                 beq.b      $d60
0d4e: 206e0008             movea.l    $8(a6), a0
0d52: 2268000e             movea.l    $e(a0), a1
0d56: 52a8000e             addq.l     #$1, $e(a0)
0d5a: 7000                 moveq      #$0, d0
0d5c: 1011                 move.b     (a1), d0
0d5e: 600a                 bra.b      $d6a
0d60: 2f2e0008             move.l     $8(a6), -(a7)
0d64: 4eba0bb0             jsr        $1916(pc)
0d68: 588f                 addq.l     #$4, a7
0d6a: 3e00                 move.w     d0, d7
0d6c: 526efffa             addq.w     #$1, -$6(a6)
0d70: 6000014a             bra.w      $ebc
0d74: 082e0006fff0         btst.b     #$6, -$10(a6)
0d7a: 6606                 bne.b      $d82
0d7c: 3d7c0001fff2         move.w     #$1, -$e(a6)
0d82: 4a2efff0             tst.b      -$10(a6)
0d86: 6b4c                 bmi.b      $dd4
0d88: 206e0010             movea.l    $10(a6), a0
0d8c: 58ae0010             addq.l     #$4, $10(a6)
0d90: 2850                 movea.l    (a0), a4
0d92: 6040                 bra.b      $dd4
0d94: 206e0008             movea.l    $8(a6), a0
0d98: 20280012             move.l     $12(a0), d0
0d9c: 53a80012             subq.l     #$1, $12(a0)
0da0: 4a80                 tst.l      d0
0da2: 6712                 beq.b      $db6
0da4: 206e0008             movea.l    $8(a6), a0
0da8: 2268000e             movea.l    $e(a0), a1
0dac: 52a8000e             addq.l     #$1, $e(a0)
0db0: 7000                 moveq      #$0, d0
0db2: 1011                 move.b     (a1), d0
0db4: 600a                 bra.b      $dc0
0db6: 2f2e0008             move.l     $8(a6), -(a7)
0dba: 4eba0b5a             jsr        $1916(pc)
0dbe: 588f                 addq.l     #$4, a7
0dc0: 3e00                 move.w     d0, d7
0dc2: 5240                 addq.w     #$1, d0
0dc4: 670005b2             beq.w      $1378
0dc8: 4a2efff0             tst.b      -$10(a6)
0dcc: 6b02                 bmi.b      $dd0
0dce: 18c7                 move.b     d7, (a4)+
0dd0: 526efffa             addq.w     #$1, -$6(a6)
0dd4: 302efff2             move.w     -$e(a6), d0
0dd8: 536efff2             subq.w     #$1, -$e(a6)
0ddc: 4a40                 tst.w      d0
0dde: 6eb4                 bgt.b      $d94
0de0: 4a2efff0             tst.b      -$10(a6)
0de4: 6b04                 bmi.b      $dea
0de6: 526efffe             addq.w     #$1, -$2(a6)
0dea: 526efffc             addq.w     #$1, -$4(a6)
0dee: 60000576             bra.w      $1366
0df2: 382efffa             move.w     -$6(a6), d4
0df6: 48c4                 ext.l      d4
0df8: 600004de             bra.w      $12d8
0dfc: 0c470025             cmpi.w     #$25, d7
0e00: 66000576             bne.w      $1378
0e04: 7000                 moveq      #$0, d0
0e06: 1007                 move.b     d7, d0
0e08: 204d                 movea.l    a5, a0
0e0a: d1c0                 adda.l     d0, a0
0e0c: 7006                 moveq      #$6, d0
0e0e: c028fbd8             and.b      -$428(a0), d0
0e12: 6756                 beq.b      $e6a
0e14: 206e0008             movea.l    $8(a6), a0
0e18: 20280012             move.l     $12(a0), d0
0e1c: 53a80012             subq.l     #$1, $12(a0)
0e20: 4a80                 tst.l      d0
0e22: 6712                 beq.b      $e36
0e24: 206e0008             movea.l    $8(a6), a0
0e28: 2268000e             movea.l    $e(a0), a1
0e2c: 52a8000e             addq.l     #$1, $e(a0)
0e30: 7000                 moveq      #$0, d0
0e32: 1011                 move.b     (a1), d0
0e34: 600a                 bra.b      $e40
0e36: 2f2e0008             move.l     $8(a6), -(a7)
0e3a: 4eba0ada             jsr        $1916(pc)
0e3e: 588f                 addq.l     #$4, a7
0e40: 3e00                 move.w     d0, d7
0e42: 526efffa             addq.w     #$1, -$6(a6)
0e46: 7000                 moveq      #$0, d0
0e48: 1007                 move.b     d7, d0
0e4a: 204d                 movea.l    a5, a0
0e4c: d1c0                 adda.l     d0, a0
0e4e: 7006                 moveq      #$6, d0
0e50: c028fbd8             and.b      -$428(a0), d0
0e54: 66be                 bne.b      $e14
0e56: 2f2e0008             move.l     $8(a6), -(a7)
0e5a: 3f07                 move.w     d7, -(a7)
0e5c: 4eba06e6             jsr        $1544(pc)
0e60: 5c8f                 addq.l     #$6, a7
0e62: 536efffa             subq.w     #$1, -$6(a6)
0e66: 600004fe             bra.w      $1366
0e6a: 206e0008             movea.l    $8(a6), a0
0e6e: 20280012             move.l     $12(a0), d0
0e72: 53a80012             subq.l     #$1, $12(a0)
0e76: 4a80                 tst.l      d0
0e78: 6712                 beq.b      $e8c
0e7a: 206e0008             movea.l    $8(a6), a0
0e7e: 2268000e             movea.l    $e(a0), a1
0e82: 52a8000e             addq.l     #$1, $e(a0)
0e86: 7000                 moveq      #$0, d0
0e88: 1011                 move.b     (a1), d0
0e8a: 600a                 bra.b      $e96
0e8c: 2f2e0008             move.l     $8(a6), -(a7)
0e90: 4eba0a84             jsr        $1916(pc)
0e94: 588f                 addq.l     #$4, a7
0e96: 3e00                 move.w     d0, d7
0e98: 206e000c             movea.l    $c(a6), a0
0e9c: 7200                 moveq      #$0, d1
0e9e: 1210                 move.b     (a0), d1
0ea0: b240                 cmp.w      d0, d1
0ea2: 6710                 beq.b      $eb4
0ea4: 2f2e0008             move.l     $8(a6), -(a7)
0ea8: 3f07                 move.w     d7, -(a7)
0eaa: 4eba0698             jsr        $1544(pc)
0eae: 5c8f                 addq.l     #$6, a7
0eb0: 600004c6             bra.w      $1378
0eb4: 526efffa             addq.w     #$1, -$6(a6)
0eb8: 600004ac             bra.w      $1366
0ebc: 082e0006fff0         btst.b     #$6, -$10(a6)
0ec2: 6606                 bne.b      $eca
0ec4: 3d7c7ffffff2         move.w     #$7fff, -$e(a6)
0eca: 4a2efff0             tst.b      -$10(a6)
0ece: 6b5c                 bmi.b      $f2c
0ed0: 206e0010             movea.l    $10(a6), a0
0ed4: 58ae0010             addq.l     #$4, $10(a6)
0ed8: 2850                 movea.l    (a0), a4
0eda: 6050                 bra.b      $f2c
0edc: 536efff2             subq.w     #$1, -$e(a6)
0ee0: 3f07                 move.w     d7, -(a7)
0ee2: 4eba058e             jsr        $1472(pc)
0ee6: 548f                 addq.l     #$2, a7
0ee8: 4a40                 tst.w      d0
0eea: 6746                 beq.b      $f32
0eec: 08ee0003fff0         bset.b     #$3, -$10(a6)
0ef2: 18c7                 move.b     d7, (a4)+
0ef4: 4a6efff2             tst.w      -$e(a6)
0ef8: 6748                 beq.b      $f42
0efa: 206e0008             movea.l    $8(a6), a0
0efe: 20280012             move.l     $12(a0), d0
0f02: 53a80012             subq.l     #$1, $12(a0)
0f06: 4a80                 tst.l      d0
0f08: 6712                 beq.b      $f1c
0f0a: 206e0008             movea.l    $8(a6), a0
0f0e: 2268000e             movea.l    $e(a0), a1
0f12: 52a8000e             addq.l     #$1, $e(a0)
0f16: 7000                 moveq      #$0, d0
0f18: 1011                 move.b     (a1), d0
0f1a: 600a                 bra.b      $f26
0f1c: 2f2e0008             move.l     $8(a6), -(a7)
0f20: 4eba09f4             jsr        $1916(pc)
0f24: 588f                 addq.l     #$4, a7
0f26: 3e00                 move.w     d0, d7
0f28: 526efffa             addq.w     #$1, -$6(a6)
0f2c: 0c47ffff             cmpi.w     #$ffff, d7
0f30: 66aa                 bne.b      $edc
0f32: 2f2e0008             move.l     $8(a6), -(a7)
0f36: 3f07                 move.w     d7, -(a7)
0f38: 4eba060a             jsr        $1544(pc)
0f3c: 5c8f                 addq.l     #$6, a7
0f3e: 536efffa             subq.w     #$1, -$6(a6)
0f42: 082e0003fff0         btst.b     #$3, -$10(a6)
0f48: 6700042e             beq.w      $1378
0f4c: 4a2efff0             tst.b      -$10(a6)
0f50: 6b06                 bmi.b      $f58
0f52: 4214                 clr.b      (a4)
0f54: 526efffe             addq.w     #$1, -$2(a6)
0f58: 526efffc             addq.w     #$1, -$4(a6)
0f5c: 60000408             bra.w      $1366
0f60: 08ee0002fff0         bset.b     #$2, -$10(a6)
0f66: 082e0005fff0         btst.b     #$5, -$10(a6)
0f6c: 670a                 beq.b      $f78
0f6e: 206e0010             movea.l    $10(a6), a0
0f72: 54ae0010             addq.l     #$2, $10(a6)
0f76: 3c10                 move.w     (a0), d6
0f78: 426efff6             clr.w      -$a(a6)
0f7c: 7800                 moveq      #$0, d4
0f7e: 206e0008             movea.l    $8(a6), a0
0f82: 20280012             move.l     $12(a0), d0
0f86: 53a80012             subq.l     #$1, $12(a0)
0f8a: 4a80                 tst.l      d0
0f8c: 6712                 beq.b      $fa0
0f8e: 206e0008             movea.l    $8(a6), a0
0f92: 2268000e             movea.l    $e(a0), a1
0f96: 52a8000e             addq.l     #$1, $e(a0)
0f9a: 7000                 moveq      #$0, d0
0f9c: 1011                 move.b     (a1), d0
0f9e: 600a                 bra.b      $faa
0fa0: 2f2e0008             move.l     $8(a6), -(a7)
0fa4: 4eba0970             jsr        $1916(pc)
0fa8: 588f                 addq.l     #$4, a7
0faa: 3e00                 move.w     d0, d7
0fac: 526efffa             addq.w     #$1, -$6(a6)
0fb0: 7000                 moveq      #$0, d0
0fb2: 1007                 move.b     d7, d0
0fb4: 204d                 movea.l    a5, a0
0fb6: d1c0                 adda.l     d0, a0
0fb8: 7006                 moveq      #$6, d0
0fba: c028fbd8             and.b      -$428(a0), d0
0fbe: 66be                 bne.b      $f7e
0fc0: 082e0006fff0         btst.b     #$6, -$10(a6)
0fc6: 6606                 bne.b      $fce
0fc8: 3d7c7ffffff2         move.w     #$7fff, -$e(a6)
0fce: 426efff8             clr.w      -$8(a6)
0fd2: 600001e4             bra.w      $11b8
0fd6: 536efff2             subq.w     #$1, -$e(a6)
0fda: 302efff6             move.w     -$a(a6), d0
0fde: 6720                 beq.b      $1000
0fe0: 6a0e                 bpl.b      $ff0
0fe2: 5440                 addq.w     #$2, d0
0fe4: 67000122             beq.w      $1108
0fe8: 6a0000f6             bpl.w      $10e0
0fec: 60000192             bra.w      $1180
0ff0: 5740                 subq.w     #$3, d0
0ff2: 67000084             beq.w      $1078
0ff6: 6a000188             bpl.w      $1180
0ffa: 5240                 addq.w     #$1, d0
0ffc: 6a5c                 bpl.b      $105a
0ffe: 601e                 bra.b      $101e
1000: 3d7c0001fff6         move.w     #$1, -$a(a6)
1006: 0c47002d             cmpi.w     #$2d, d7
100a: 660a                 bne.b      $1016
100c: 08ee0004fff0         bset.b     #$4, -$10(a6)
1012: 6000016c             bra.w      $1180
1016: 0c47002b             cmpi.w     #$2b, d7
101a: 67000164             beq.w      $1180
101e: 3d7c0003fff6         move.w     #$3, -$a(a6)
1024: 0c470030             cmpi.w     #$30, d7
1028: 664e                 bne.b      $1078
102a: 08ee0003fff0         bset.b     #$3, -$10(a6)
1030: 4a6efff2             tst.w      -$e(a6)
1034: 6700014a             beq.w      $1180
1038: 4a46                 tst.w      d6
103a: 660c                 bne.b      $1048
103c: 7c08                 moveq      #$8, d6
103e: 3d7c0002fff6         move.w     #$2, -$a(a6)
1044: 6000013a             bra.w      $1180
1048: 0c460010             cmpi.w     #$10, d6
104c: 66000132             bne.w      $1180
1050: 3d7c0002fff6         move.w     #$2, -$a(a6)
1056: 60000128             bra.w      $1180
105a: 3d7c0003fff6         move.w     #$3, -$a(a6)
1060: 0c470078             cmpi.w     #$78, d7
1064: 6706                 beq.b      $106c
1066: 0c470058             cmpi.w     #$58, d7
106a: 660c                 bne.b      $1078
106c: 7c10                 moveq      #$10, d6
106e: 08ae0003fff0         bclr.b     #$3, -$10(a6)
1074: 6000010a             bra.w      $1180
1078: 3a07                 move.w     d7, d5
107a: 0c450030             cmpi.w     #$30, d5
107e: 6d0c                 blt.b      $108c
1080: 0c450039             cmpi.w     #$39, d5
1084: 6e06                 bgt.b      $108c
1086: 0645ffd0             addi.w     #$ffd0, d5
108a: 6026                 bra.b      $10b2
108c: 0c450041             cmpi.w     #$41, d5
1090: 6d0c                 blt.b      $109e
1092: 0c45005a             cmpi.w     #$5a, d5
1096: 6e06                 bgt.b      $109e
1098: 0645ffc9             addi.w     #$ffc9, d5
109c: 6014                 bra.b      $10b2
109e: 0c450061             cmpi.w     #$61, d5
10a2: 6d00011c             blt.w      $11c0
10a6: 0c45007a             cmpi.w     #$7a, d5
10aa: 6e000114             bgt.w      $11c0
10ae: 0645ffa9             addi.w     #$ffa9, d5
10b2: 4a46                 tst.w      d6
10b4: 6602                 bne.b      $10b8
10b6: 7c0a                 moveq      #$a, d6
10b8: bc45                 cmp.w      d5, d6
10ba: 6f000104             ble.w      $11c0
10be: 2004                 move.l     d4, d0
10c0: 4840                 swap       d0
10c2: c0c6                 mulu.w     d6, d0
10c4: 4840                 swap       d0
10c6: 4a40                 tst.w      d0
10c8: 6608                 bne.b      $10d2
10ca: 3005                 move.w     d5, d0
10cc: c8c6                 mulu.w     d6, d4
10ce: d880                 add.l      d0, d4
10d0: 6404                 bcc.b      $10d6
10d2: 50eefff8             st.b       -$8(a6)
10d6: 08ee0003fff0         bset.b     #$3, -$10(a6)
10dc: 600000a2             bra.w      $1180
10e0: 3d7cfffefff6         move.w     #$fffe, -$a(a6)
10e6: 426effda             clr.w      -$26(a6)
10ea: 422effdc             clr.b      -$24(a6)
10ee: 0c47002d             cmpi.w     #$2d, d7
10f2: 660a                 bne.b      $10fe
10f4: 1d7c0001ffd8         move.b     #$1, -$28(a6)
10fa: 60000084             bra.w      $1180
10fe: 422effd8             clr.b      -$28(a6)
1102: 0c47002b             cmpi.w     #$2b, d7
1106: 6778                 beq.b      $1180
1108: 0c470030             cmpi.w     #$30, d7
110c: 6d3c                 blt.b      $114a
110e: 0c470039             cmpi.w     #$39, d7
1112: 6e36                 bgt.b      $114a
1114: 08ee0003fff0         bset.b     #$3, -$10(a6)
111a: 0c470030             cmpi.w     #$30, d7
111e: 6606                 bne.b      $1126
1120: 4a2effdc             tst.b      -$24(a6)
1124: 675a                 beq.b      $1180
1126: 0c2e0013ffdc         cmpi.b     #$13, -$24(a6)
112c: 640e                 bcc.b      $113c
112e: 522effdc             addq.b     #$1, -$24(a6)
1132: 102effdc             move.b     -$24(a6), d0
1136: 4880                 ext.w      d0
1138: 1d8700dc             move.b     d7, -$24(a6, d0.w)
113c: 082e0000fff0         btst.b     #$0, -$10(a6)
1142: 673c                 beq.b      $1180
1144: 536effda             subq.w     #$1, -$26(a6)
1148: 6036                 bra.b      $1180
114a: 0c47002e             cmpi.w     #$2e, d7
114e: 6610                 bne.b      $1160
1150: 082e0000fff0         btst.b     #$0, -$10(a6)
1156: 6608                 bne.b      $1160
1158: 08ee0000fff0         bset.b     #$0, -$10(a6)
115e: 6020                 bra.b      $1180
1160: 0c470065             cmpi.w     #$65, d7
1164: 6706                 beq.b      $116c
1166: 0c470045             cmpi.w     #$45, d7
116a: 6654                 bne.b      $11c0
116c: 082e0003fff0         btst.b     #$3, -$10(a6)
1172: 674c                 beq.b      $11c0
1174: 7c0a                 moveq      #$a, d6
1176: 08ae0003fff0         bclr.b     #$3, -$10(a6)
117c: 426efff6             clr.w      -$a(a6)
1180: 4a6efff2             tst.w      -$e(a6)
1184: 674a                 beq.b      $11d0
1186: 206e0008             movea.l    $8(a6), a0
118a: 20280012             move.l     $12(a0), d0
118e: 53a80012             subq.l     #$1, $12(a0)
1192: 4a80                 tst.l      d0
1194: 6712                 beq.b      $11a8
1196: 206e0008             movea.l    $8(a6), a0
119a: 2268000e             movea.l    $e(a0), a1
119e: 52a8000e             addq.l     #$1, $e(a0)
11a2: 7000                 moveq      #$0, d0
11a4: 1011                 move.b     (a1), d0
11a6: 600a                 bra.b      $11b2
11a8: 2f2e0008             move.l     $8(a6), -(a7)
11ac: 4eba0768             jsr        $1916(pc)
11b0: 588f                 addq.l     #$4, a7
11b2: 3e00                 move.w     d0, d7
11b4: 526efffa             addq.w     #$1, -$6(a6)
11b8: 0c47ffff             cmpi.w     #$ffff, d7
11bc: 6600fe18             bne.w      $fd6
11c0: 2f2e0008             move.l     $8(a6), -(a7)
11c4: 3f07                 move.w     d7, -(a7)
11c6: 4eba037c             jsr        $1544(pc)
11ca: 5c8f                 addq.l     #$6, a7
11cc: 536efffa             subq.w     #$1, -$6(a6)
11d0: 082e0003fff0         btst.b     #$3, -$10(a6)
11d6: 670001a0             beq.w      $1378
11da: 082e0004fff0         btst.b     #$4, -$10(a6)
11e0: 671a                 beq.b      $11fc
11e2: 4a84                 tst.l      d4
11e4: 6716                 beq.b      $11fc
11e6: 4484                 neg.l      d4
11e8: 082e0002fff0         btst.b     #$2, -$10(a6)
11ee: 6604                 bne.b      $11f4
11f0: 4a84                 tst.l      d4
11f2: 6f1a                 ble.b      $120e
11f4: 3d7c0001fff8         move.w     #$1, -$8(a6)
11fa: 6012                 bra.b      $120e
11fc: 082e0002fff0         btst.b     #$2, -$10(a6)
1202: 660a                 bne.b      $120e
1204: 4a84                 tst.l      d4
1206: 6c06                 bge.b      $120e
1208: 3d7c0001fff8         move.w     #$1, -$8(a6)
120e: 082e0001fff0         btst.b     #$1, -$10(a6)
1214: 6714                 beq.b      $122a
1216: 306effda             movea.w    -$26(a6), a0
121a: d888                 add.l      a0, d4
121c: 6906                 bvs.b      $1224
121e: 2044                 movea.l    d4, a0
1220: b0c8                 cmpa.w     a0, a0
1222: 6704                 beq.b      $1228
1224: 50eefff8             st.b       -$8(a6)
1228: 6058                 bra.b      $1282
122a: 4a2efff1             tst.b      -$f(a6)
122e: 6a26                 bpl.b      $1256
1230: 082e0002fff0         btst.b     #$2, -$10(a6)
1236: 6710                 beq.b      $1248
1238: 7000                 moveq      #$0, d0
123a: 3004                 move.w     d4, d0
123c: b880                 cmp.l      d0, d4
123e: 6742                 beq.b      $1282
1240: 3d7c0001fff8         move.w     #$1, -$8(a6)
1246: 603a                 bra.b      $1282
1248: 3044                 movea.w    d4, a0
124a: b888                 cmp.l      a0, d4
124c: 6734                 beq.b      $1282
124e: 3d7c0001fff8         move.w     #$1, -$8(a6)
1254: 602c                 bra.b      $1282
1256: 082e0006fff1         btst.b     #$6, -$f(a6)
125c: 6624                 bne.b      $1282
125e: 082e0002fff0         btst.b     #$2, -$10(a6)
1264: 6710                 beq.b      $1276
1266: 7000                 moveq      #$0, d0
1268: 3004                 move.w     d4, d0
126a: b880                 cmp.l      d0, d4
126c: 6714                 beq.b      $1282
126e: 3d7c0001fff8         move.w     #$1, -$8(a6)
1274: 600c                 bra.b      $1282
1276: 3044                 movea.w    d4, a0
1278: b888                 cmp.l      a0, d4
127a: 6706                 beq.b      $1282
127c: 3d7c0001fff8         move.w     #$1, -$8(a6)
1282: 4a6efff8             tst.w      -$8(a6)
1286: 6750                 beq.b      $12d8
1288: 082e0002fff0         btst.b     #$2, -$10(a6)
128e: 6704                 beq.b      $1294
1290: 7800                 moveq      #$0, d4
1292: 602c                 bra.b      $12c0
1294: 4a2efff1             tst.b      -$f(a6)
1298: 6b08                 bmi.b      $12a2
129a: 082e0001fff0         btst.b     #$1, -$10(a6)
12a0: 6708                 beq.b      $12aa
12a2: 283cffff8000         move.l     #$ffff8000, d4
12a8: 6016                 bra.b      $12c0
12aa: 082e0006fff1         btst.b     #$6, -$f(a6)
12b0: 6708                 beq.b      $12ba
12b2: 283c80000000         move.l     #$80000000, d4
12b8: 6006                 bra.b      $12c0
12ba: 283cffff8000         move.l     #$ffff8000, d4
12c0: 082e0004fff0         btst.b     #$4, -$10(a6)
12c6: 6602                 bne.b      $12ca
12c8: 4684                 not.l      d4
12ca: 082e0001fff0         btst.b     #$1, -$10(a6)
12d0: 6606                 bne.b      $12d8
12d2: 3b7c0022f440         move.w     #$22, -$bc0(a5)
12d8: 4a2efff0             tst.b      -$10(a6)
12dc: 6b000084             bmi.w      $1362
12e0: 206e0010             movea.l    $10(a6), a0
12e4: 58ae0010             addq.l     #$4, $10(a6)
12e8: 2850                 movea.l    (a0), a4
12ea: 082e0001fff0         btst.b     #$1, -$10(a6)
12f0: 6754                 beq.b      $1346
12f2: 3d44ffda             move.w     d4, -$26(a6)
12f6: 082e0006fff1         btst.b     #$6, -$f(a6)
12fc: 6608                 bne.b      $1306
12fe: 082e0005fff1         btst.b     #$5, -$f(a6)
1304: 6712                 beq.b      $1318
1306: 2f0c                 move.l     a4, -(a7)
1308: 486effd8             pea.l      -$28(a6)
130c: 4267                 clr.w      -(a7)
130e: 4eba0186             jsr        $1496(pc)
1312: 4fef000a             lea.l      $a(a7), a7
1316: 6046                 bra.b      $135e
1318: 4a2efff1             tst.b      -$f(a6)
131c: 6a14                 bpl.b      $1332
131e: 2f0c                 move.l     a4, -(a7)
1320: 486effd8             pea.l      -$28(a6)
1324: 3f3c0800             move.w     #$800, -(a7)
1328: 4eba016c             jsr        $1496(pc)
132c: 4fef000a             lea.l      $a(a7), a7
1330: 602c                 bra.b      $135e
1332: 2f0c                 move.l     a4, -(a7)
1334: 486effd8             pea.l      -$28(a6)
1338: 3f3c1000             move.w     #$1000, -(a7)
133c: 4eba0158             jsr        $1496(pc)
1340: 4fef000a             lea.l      $a(a7), a7
1344: 6018                 bra.b      $135e
1346: 082e0006fff1         btst.b     #$6, -$f(a6)
134c: 6704                 beq.b      $1352
134e: 2884                 move.l     d4, (a4)
1350: 600c                 bra.b      $135e
1352: 4a2efff1             tst.b      -$f(a6)
1356: 6a04                 bpl.b      $135c
1358: 3884                 move.w     d4, (a4)
135a: 6002                 bra.b      $135e
135c: 3884                 move.w     d4, (a4)
135e: 526efffe             addq.w     #$1, -$2(a6)
1362: 526efffc             addq.w     #$1, -$4(a6)
1366: 52ae000c             addq.l     #$1, $c(a6)
136a: 206e000c             movea.l    $c(a6), a0
136e: 1e10                 move.b     (a0), d7
1370: 4887                 ext.w      d7
1372: 4a47                 tst.w      d7
1374: 6600f7aa             bne.w      $b20
1378: 4a6efffc             tst.w      -$4(a6)
137c: 660a                 bne.b      $1388
137e: 0c47ffff             cmpi.w     #$ffff, d7
1382: 6604                 bne.b      $1388
1384: 70ff                 moveq      #$ff, d0
1386: 6004                 bra.b      $138c
1388: 302efffe             move.w     -$2(a6), d0
138c: 4cdf10f0             movem.l    (a7)+, d4-d7/a4
1390: 4e5e                 unlk       a6
1392: 4e75                 rts        
1394: f85efa68             ftrapogt.b (a6)+
1398: fa68fa68fa68         ftrapogt.b -$598(a0)
139e: fa68f896fa68         fsogl.b    -$598(a0)
13a4: f896fa68             fbf.w      $e0e
13a8: fa68fa68fa68         ftrapogt.b -$598(a0)
13ae: f84afa68fa68         fdbf       d2, $e1a
13b4: fa68fa68fa68         ftrapogt.b -$598(a0)
13ba: fa68fa68fa68         ftrapogt.b -$598(a0)
13c0: fa68fa68fa68         ftrapogt.b -$598(a0)
13c6: f890fa68             fbf.w      $e30
13ca: fa68f8f6fa68         ftrapf.b   -$598(a0)
13d0: fa68fa68fa68         ftrapogt.b -$598(a0)
13d6: fa68fa68fa68         ftrapogt.b -$598(a0)
13dc: f9e0                 dc.w       $f9e0
13de: f872f896f896         fsogl.b    -$6a(a2, a7.l)
13e4: f896f822             fbf.w      $c08
13e8: f878fa68fa68         ftrapogt.b $fa68.w
13ee: f836fa68fa5e         fmovem     invalid, $5e(a6, a7.l)
13f4: f87e                 dc.w       $f87e
13f6: f88afa68             fbf.w      $e60
13fa: fa68f8a6fa68         ftrapf.b   -$598(a0)
1400: f884fa68             fbf.w      $e6a
1404: fa68f8904e56         fsf.b      $4e56(a0)
140a: 000041ed             ori.b      #$ed, d0
140e: f44e700020c0         fdbf       d6, $34d2
1414: 20c0                 move.l     d0, (a0)+
1416: 20c0                 move.l     d0, (a0)+
1418: 20c0                 move.l     d0, (a0)+
141a: 20c0                 move.l     d0, (a0)+
141c: 20c0                 move.l     d0, (a0)+
141e: 20c0                 move.l     d0, (a0)+
1420: 20c0                 move.l     d0, (a0)+
1422: 4a6e0008             tst.w      $8(a6)
1426: 6710                 beq.b      $1438
1428: 1b7c003ef44f         move.b     #$3e, -$bb1(a5)
142e: 1b7c0001f452         move.b     #$1, -$bae(a5)
1434: 4eba0026             jsr        $145c(pc)
1438: 4e5e                 unlk       a6
143a: 4e75                 rts        
143c: 4e560000             link.w     a6, #$0
1440: 7007                 moveq      #$7, d0
1442: c02e0009             and.b      $9(a6), d0
1446: 7201                 moveq      #$1, d1
1448: e129                 lsl.b      d0, d1
144a: 302e0008             move.w     $8(a6), d0
144e: e640                 asr.w      #$3, d0
1450: 204d                 movea.l    a5, a0
1452: d0c0                 adda.w     d0, a0
1454: 8328f44e             or.b       d1, -$bb2(a0)
1458: 4e5e                 unlk       a6
145a: 4e75                 rts        
145c: 41edf44e             lea.l      -$bb2(a5), a0
1460: 4698                 not.l      (a0)+
1462: 4698                 not.l      (a0)+
1464: 4698                 not.l      (a0)+
1466: 4698                 not.l      (a0)+
1468: 4698                 not.l      (a0)+
146a: 4698                 not.l      (a0)+
146c: 4698                 not.l      (a0)+
146e: 4698                 not.l      (a0)+
1470: 4e75                 rts        
1472: 4e560000             link.w     a6, #$0
1476: 7007                 moveq      #$7, d0
1478: c02e0009             and.b      $9(a6), d0
147c: 7201                 moveq      #$1, d1
147e: e169                 lsl.w      d0, d1
1480: 302e0008             move.w     $8(a6), d0
1484: e640                 asr.w      #$3, d0
1486: 204d                 movea.l    a5, a0
1488: d0c0                 adda.w     d0, a0
148a: 1028f44e             move.b     -$bb2(a0), d0
148e: 4880                 ext.w      d0
1490: c041                 and.w      d1, d0
1492: 4e5e                 unlk       a6
1494: 4e75                 rts        
1496: 4e56fffc             link.w     a6, #$fffc
149a: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
149e: 286e000a             movea.l    $a(a6), a4
14a2: 3e2e0008             move.w     $8(a6), d7
14a6: 266e000e             movea.l    $e(a6), a3
14aa: 7c30                 moveq      #$30, d6
14ac: 486efffe             pea.l      -$2(a6)
14b0: 3f3c0017             move.w     #$17, -(a7)
14b4: a9eb                 dc.w       $a9eb
14b6: 4a2c0004             tst.b      $4(a4)
14ba: 675e                 beq.b      $151a
14bc: 2f0c                 move.l     a4, -(a7)
14be: 2f0b                 move.l     a3, -(a7)
14c0: 7009                 moveq      #$9, d0
14c2: d047                 add.w      d7, d0
14c4: 3f00                 move.w     d0, -(a7)
14c6: a9eb                 dc.w       $a9eb
14c8: 486efffe             pea.l      -$2(a6)
14cc: 3f3c0003             move.w     #$3, -(a7)
14d0: a9eb                 dc.w       $a9eb
14d2: 2f0b                 move.l     a3, -(a7)
14d4: 486efffc             pea.l      -$4(a6)
14d8: 701c                 moveq      #$1c, d0
14da: d047                 add.w      d7, d0
14dc: 3f00                 move.w     d0, -(a7)
14de: a9eb                 dc.w       $a9eb
14e0: 4a6efffc             tst.w      -$4(a6)
14e4: 6c0a                 bge.b      $14f0
14e6: 302efffc             move.w     -$4(a6), d0
14ea: 4440                 neg.w      d0
14ec: 3d40fffc             move.w     d0, -$4(a6)
14f0: 0c6e0003fffc         cmpi.w     #$3, -$4(a6)
14f6: 6708                 beq.b      $1500
14f8: 082e0002fffe         btst.b     #$2, -$2(a6)
14fe: 6704                 beq.b      $1504
1500: 7c49                 moveq      #$49, d6
1502: 6010                 bra.b      $1514
1504: 0c6e0005fffc         cmpi.w     #$5, -$4(a6)
150a: 6608                 bne.b      $1514
150c: 082e0001fffe         btst.b     #$1, -$2(a6)
1512: 6728                 beq.b      $153c
1514: 3b7c0022f440         move.w     #$22, -$bc0(a5)
151a: 0c460030             cmpi.w     #$30, d6
151e: 6602                 bne.b      $1522
1520: 4214                 clr.b      (a4)
1522: 426c0002             clr.w      $2(a4)
1526: 197c00010004         move.b     #$1, $4(a4)
152c: 19460005             move.b     d6, $5(a4)
1530: 2f0c                 move.l     a4, -(a7)
1532: 2f0b                 move.l     a3, -(a7)
1534: 7009                 moveq      #$9, d0
1536: d047                 add.w      d7, d0
1538: 3f00                 move.w     d0, -(a7)
153a: a9eb                 dc.w       $a9eb
153c: 4cdf18c0             movem.l    (a7)+, d6-d7/a3-a4
1540: 4e5e                 unlk       a6
1542: 4e75                 rts        
1544: 4e560000             link.w     a6, #$0
1548: 48e70108             movem.l    d7/a4, -(a7)
154c: 286e000a             movea.l    $a(a6), a4
1550: 0c6effff0008         cmpi.w     #$ffff, $8(a6)
1556: 6606                 bne.b      $155e
1558: 70ff                 moveq      #$ff, d0
155a: 6000008a             bra.w      $15e6
155e: 2f0c                 move.l     a4, -(a7)
1560: 4eba008c             jsr        $15ee(pc)
1564: 4a2c0001             tst.b      $1(a4)
1568: 588f                 addq.l     #$4, a7
156a: 6a0a                 bpl.b      $1576
156c: 4aac0012             tst.l      $12(a4)
1570: 6758                 beq.b      $15ca
1572: 70ff                 moveq      #$ff, d0
1574: 6070                 bra.b      $15e6
1576: 2e2c000a             move.l     $a(a4), d7
157a: beac0012             cmp.l      $12(a4), d7
157e: 6620                 bne.b      $15a0
1580: 4a87                 tst.l      d7
1582: 671c                 beq.b      $15a0
1584: 202c0012             move.l     $12(a4), d0
1588: 91ac0016             sub.l      d0, $16(a4)
158c: 42ac0012             clr.l      $12(a4)
1590: 41ec0004             lea.l      $4(a4), a0
1594: 2948000e             move.l     a0, $e(a4)
1598: 08ec00070001         bset.b     #$7, $1(a4)
159e: 602a                 bra.b      $15ca
15a0: 202c000e             move.l     $e(a4), d0
15a4: b0ac0006             cmp.l      $6(a4), d0
15a8: 6620                 bne.b      $15ca
15aa: 2f2c0012             move.l     $12(a4), -(a7)
15ae: 2f2c0006             move.l     $6(a4), -(a7)
15b2: 202c000a             move.l     $a(a4), d0
15b6: 90ac0012             sub.l      $12(a4), d0
15ba: d1ac000e             add.l      d0, $e(a4)
15be: 2f2c000e             move.l     $e(a4), -(a7)
15c2: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
15c6: 4fef000c             lea.l      $c(a7), a7
15ca: 08940005             bclr.b     #$5, (a4)
15ce: 52ac0012             addq.l     #$1, $12(a4)
15d2: 53ac000e             subq.l     #$1, $e(a4)
15d6: 206c000e             movea.l    $e(a4), a0
15da: 102e0009             move.b     $9(a6), d0
15de: 1080                 move.b     d0, (a0)
15e0: 7200                 moveq      #$0, d1
15e2: 1200                 move.b     d0, d1
15e4: 3001                 move.w     d1, d0
15e6: 4cdf1080             movem.l    (a7)+, d7/a4
15ea: 4e5e                 unlk       a6
15ec: 4e75                 rts        
15ee: 4e560000             link.w     a6, #$0
15f2: 2f0c                 move.l     a4, -(a7)
15f4: 286e0008             movea.l    $8(a6), a4
15f8: 4a6c0004             tst.w      $4(a4)
15fc: 661a                 bne.b      $1618
15fe: 41ec0002             lea.l      $2(a4), a0
1602: 29480006             move.l     a0, $6(a4)
1606: 2948000e             move.l     a0, $e(a4)
160a: 7001                 moveq      #$1, d0
160c: 2940000a             move.l     d0, $a(a4)
1610: 41ed080a             lea.l      $80a(a5), a0
1614: 29480022             move.l     a0, $22(a4)
1618: 200c                 move.l     a4, d0
161a: 285f                 movea.l    (a7)+, a4
161c: 4e5e                 unlk       a6
161e: 4e75                 rts        
1620: 4e560000             link.w     a6, #$0
1624: 2f2e000c             move.l     $c(a6), -(a7)
1628: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
162c: 2e80                 move.l     d0, (a7)
162e: 2f2e000c             move.l     $c(a6), -(a7)
1632: 2f2e0008             move.l     $8(a6), -(a7)
1636: 4eba002c             jsr        $1664(pc)
163a: 202e0008             move.l     $8(a6), d0
163e: 4e5e                 unlk       a6
1640: 4e75                 rts        
1642: 4e56fffc             link.w     a6, #$fffc
1646: 4878ffff             pea.l      $ffff.w
164a: 2f2e000c             move.l     $c(a6), -(a7)
164e: 2f2e0008             move.l     $8(a6), -(a7)
1652: 4eba0010             jsr        $1664(pc)
1656: 206e0008             movea.l    $8(a6), a0
165a: 08d00003             bset.b     #$3, (a0)
165e: 2008                 move.l     a0, d0
1660: 4e5e                 unlk       a6
1662: 4e75                 rts        
1664: 4e560000             link.w     a6, #$0
1668: 2f0c                 move.l     a4, -(a7)
166a: 286e0008             movea.l    $8(a6), a4
166e: 48780026             pea.l      $26.w
1672: 4267                 clr.w      -(a7)
1674: 2f0c                 move.l     a4, -(a7)
1676: 4ead0d9a             jsr        $d9a(a5) ; CODE52+0204
167a: 397cffff0004         move.w     #$ffff, $4(a4)
1680: 296e000c000e         move.l     $c(a6), $e(a4)
1686: 296e00100012         move.l     $10(a6), $12(a4)
168c: 41ed080a             lea.l      $80a(a5), a0
1690: 29480022             move.l     a0, $22(a4)
1694: 286efffc             movea.l    -$4(a6), a4
1698: 4e5e                 unlk       a6
169a: 4e75                 rts        
169c: 4e560000             link.w     a6, #$0
16a0: 70ff                 moveq      #$ff, d0
16a2: 4e5e                 unlk       a6
16a4: 4e75                 rts        
16a6: 4e560000             link.w     a6, #$0
16aa: 486e0010             pea.l      $10(a6)
16ae: 2f2e000c             move.l     $c(a6), -(a7)
16b2: 2f2e0008             move.l     $8(a6), -(a7)
16b6: 4eba0006             jsr        $16be(pc)
16ba: 4e5e                 unlk       a6
16bc: 4e75                 rts        
16be: 4e56ffda             link.w     a6, #$ffda
16c2: 2f07                 move.l     d7, -(a7)
16c4: 2f2e0010             move.l     $10(a6), -(a7)
16c8: 2f2e000c             move.l     $c(a6), -(a7)
16cc: 2f2e0008             move.l     $8(a6), -(a7)
16d0: 486effda             pea.l      -$26(a6)
16d4: 4ebaff6c             jsr        $1642(pc)
16d8: 588f                 addq.l     #$4, a7
16da: 2e80                 move.l     d0, (a7)
16dc: 4ebae926             jsr        $4(pc)
16e0: 3e00                 move.w     d0, d7
16e2: 4a40                 tst.w      d0
16e4: 4fef000c             lea.l      $c(a7), a7
16e8: 6d08                 blt.b      $16f2
16ea: 206e0008             movea.l    $8(a6), a0
16ee: 42307000             clr.b      (a0, d7.w)
16f2: 3007                 move.w     d7, d0
16f4: 2e1f                 move.l     (a7)+, d7
16f6: 4e5e                 unlk       a6
16f8: 4e75                 rts        
16fa: 4e560000             link.w     a6, #$0
16fe: 486e0010             pea.l      $10(a6)
1702: 2f2e000c             move.l     $c(a6), -(a7)
1706: 2f2e0008             move.l     $8(a6), -(a7)
170a: 4eba0006             jsr        $1712(pc)
170e: 4e5e                 unlk       a6
1710: 4e75                 rts        
1712: 4e56ffda             link.w     a6, #$ffda
1716: 2f2e0010             move.l     $10(a6), -(a7)
171a: 2f2e000c             move.l     $c(a6), -(a7)
171e: 2f2e0008             move.l     $8(a6), -(a7)
1722: 486effda             pea.l      -$26(a6)
1726: 4ebafef8             jsr        $1620(pc)
172a: 588f                 addq.l     #$4, a7
172c: 2e80                 move.l     d0, (a7)
172e: 4ebaf3d0             jsr        $b00(pc)
1732: 4e5e                 unlk       a6
1734: 4e75                 rts        
1736: 4e560000             link.w     a6, #$0
173a: 4267                 clr.w      -(a7)
173c: 2f2e0008             move.l     $8(a6), -(a7)
1740: 206e0008             movea.l    $8(a6), a0
1744: 20680022             movea.l    $22(a0), a0
1748: 4e90                 jsr        (a0)
174a: 4e5e                 unlk       a6
174c: 4e75                 rts        
174e: 4e560000             link.w     a6, #$0
1752: 3f3c0001             move.w     #$1, -(a7)
1756: 2f2e0008             move.l     $8(a6), -(a7)
175a: 206e0008             movea.l    $8(a6), a0
175e: 20680022             movea.l    $22(a0), a0
1762: 4e90                 jsr        (a0)
1764: 4e5e                 unlk       a6
1766: 4e75                 rts        
1768: 4e560000             link.w     a6, #$0
176c: 3f3c0002             move.w     #$2, -(a7)
1770: 2f2e0008             move.l     $8(a6), -(a7)
1774: 206e0008             movea.l    $8(a6), a0
1778: 20680022             movea.l    $22(a0), a0
177c: 4e90                 jsr        (a0)
177e: 4e5e                 unlk       a6
1780: 4e75                 rts        
1782: 4e560000             link.w     a6, #$0
1786: 48e71f18             movem.l    d3-d7/a3-a4, -(a7)
178a: 2c2e000c             move.l     $c(a6), d6
178e: 2a2e0010             move.l     $10(a6), d5
1792: 266e0014             movea.l    $14(a6), a3
1796: 286e0008             movea.l    $8(a6), a4
179a: 2f05                 move.l     d5, -(a7)
179c: 2f06                 move.l     d6, -(a7)
179e: 4ead0042             jsr        $42(a5) ; CODE1+00ee
17a2: 2e00                 move.l     d0, d7
17a4: 4a87                 tst.l      d7
17a6: 6606                 bne.b      $17ae
17a8: 7000                 moveq      #$0, d0
17aa: 60000114             bra.w      $18c0
17ae: 2f0b                 move.l     a3, -(a7)
17b0: 4ebafe3c             jsr        $15ee(pc)
17b4: 08130001             btst.b     #$1, (a3)
17b8: 588f                 addq.l     #$4, a7
17ba: 670c                 beq.b      $17c8
17bc: 08130003             btst.b     #$3, (a3)
17c0: 6606                 bne.b      $17c8
17c2: 276b001a0016         move.l     $1a(a3), $16(a3)
17c8: 4a6b0004             tst.w      $4(a3)
17cc: 6f62                 ble.b      $1830
17ce: 08130006             btst.b     #$6, (a3)
17d2: 675c                 beq.b      $1830
17d4: 4aab0012             tst.l      $12(a3)
17d8: 6656                 bne.b      $1830
17da: beab000a             cmp.l      $a(a3), d7
17de: 6550                 bcs.b      $1830
17e0: 7001                 moveq      #$1, d0
17e2: b0ab000a             cmp.l      $a(a3), d0
17e6: 6710                 beq.b      $17f8
17e8: 2f2b000a             move.l     $a(a3), -(a7)
17ec: 2f2b0016             move.l     $16(a3), -(a7)
17f0: 4ead0052             jsr        $52(a5) ; CODE1+0144
17f4: 4a80                 tst.l      d0
17f6: 6638                 bne.b      $1830
17f8: 2807                 move.l     d7, d4
17fa: 262b000a             move.l     $a(a3), d3
17fe: 7001                 moveq      #$1, d0
1800: b083                 cmp.l      d3, d0
1802: 640a                 bcc.b      $180e
1804: 2f03                 move.l     d3, -(a7)
1806: 2f04                 move.l     d4, -(a7)
1808: 4ead0052             jsr        $52(a5) ; CODE1+0144
180c: 9880                 sub.l      d0, d4
180e: 274c000e             move.l     a4, $e(a3)
1812: 27440012             move.l     d4, $12(a3)
1816: d9ab0016             add.l      d4, $16(a3)
181a: 2f0b                 move.l     a3, -(a7)
181c: 4ebaff30             jsr        $174e(pc)
1820: 3600                 move.w     d0, d3
1822: 2e8b                 move.l     a3, (a7)
1824: 4eba023a             jsr        $1a60(pc)
1828: 4a43                 tst.w      d3
182a: 588f                 addq.l     #$4, a7
182c: 667c                 bne.b      $18aa
182e: 6072                 bra.b      $18a2
1830: 08130003             btst.b     #$3, (a3)
1834: 6706                 beq.b      $183c
1836: 4aab001e             tst.l      $1e(a3)
183a: 6736                 beq.b      $1872
183c: 202b0012             move.l     $12(a3), d0
1840: 53ab0012             subq.l     #$1, $12(a3)
1844: 5380                 subq.l     #$1, d0
1846: 6312                 bls.b      $185a
1848: 206b000e             movea.l    $e(a3), a0
184c: 52ab000e             addq.l     #$1, $e(a3)
1850: 1014                 move.b     (a4), d0
1852: 1080                 move.b     d0, (a0)
1854: 7200                 moveq      #$0, d1
1856: 1200                 move.b     d0, d1
1858: 6010                 bra.b      $186a
185a: 2f0b                 move.l     a3, -(a7)
185c: 7000                 moveq      #$0, d0
185e: 1014                 move.b     (a4), d0
1860: 3f00                 move.w     d0, -(a7)
1862: 4eba0116             jsr        $197a(pc)
1866: 3200                 move.w     d0, d1
1868: 5c8f                 addq.l     #$6, a7
186a: 5241                 addq.w     #$1, d1
186c: 673c                 beq.b      $18aa
186e: 7801                 moveq      #$1, d4
1870: 6030                 bra.b      $18a2
1872: 282b0012             move.l     $12(a3), d4
1876: be84                 cmp.l      d4, d7
1878: 6402                 bcc.b      $187c
187a: 2807                 move.l     d7, d4
187c: 2f04                 move.l     d4, -(a7)
187e: 2f0c                 move.l     a4, -(a7)
1880: 2f2b000e             move.l     $e(a3), -(a7)
1884: 4ead0d82             jsr        $d82(a5) ; CODE52+0186
1888: d9ab000e             add.l      d4, $e(a3)
188c: 99ab0012             sub.l      d4, $12(a3)
1890: 4fef000c             lea.l      $c(a7), a7
1894: 660c                 bne.b      $18a2
1896: 2f0b                 move.l     a3, -(a7)
1898: 4eba002e             jsr        $18c8(pc)
189c: 4a40                 tst.w      d0
189e: 588f                 addq.l     #$4, a7
18a0: 6608                 bne.b      $18aa
18a2: d9c4                 adda.l     d4, a4
18a4: 9e84                 sub.l      d4, d7
18a6: 6600ff20             bne.w      $17c8
18aa: 4a87                 tst.l      d7
18ac: 6710                 beq.b      $18be
18ae: 2f06                 move.l     d6, -(a7)
18b0: 2007                 move.l     d7, d0
18b2: d086                 add.l      d6, d0
18b4: 5380                 subq.l     #$1, d0
18b6: 2f00                 move.l     d0, -(a7)
18b8: 4ead004a             jsr        $4a(a5) ; CODE1+0124
18bc: 9a80                 sub.l      d0, d5
18be: 2005                 move.l     d5, d0
18c0: 4cdf18f8             movem.l    (a7)+, d3-d7/a3-a4
18c4: 4e5e                 unlk       a6
18c6: 4e75                 rts        
18c8: 4e560000             link.w     a6, #$0
18cc: 48e70108             movem.l    d7/a4, -(a7)
18d0: 286e0008             movea.l    $8(a6), a4
18d4: 7e00                 moveq      #$0, d7
18d6: 202c0012             move.l     $12(a4), d0
18da: 91ac0016             sub.l      d0, $16(a4)
18de: 08140003             btst.b     #$3, (a4)
18e2: 6720                 beq.b      $1904
18e4: 202c000e             move.l     $e(a4), d0
18e8: 90ac0006             sub.l      $6(a4), d0
18ec: 29400012             move.l     d0, $12(a4)
18f0: 296c0006000e         move.l     $6(a4), $e(a4)
18f6: 08940003             bclr.b     #$3, (a4)
18fa: 2f0c                 move.l     a4, -(a7)
18fc: 4ebafe50             jsr        $174e(pc)
1900: 3e00                 move.w     d0, d7
1902: 588f                 addq.l     #$4, a7
1904: 2f0c                 move.l     a4, -(a7)
1906: 4eba0158             jsr        $1a60(pc)
190a: 3007                 move.w     d7, d0
190c: 4cee1080fff8         movem.l    -$8(a6), d7/a4
1912: 4e5e                 unlk       a6
1914: 4e75                 rts        
1916: 4e560000             link.w     a6, #$0
191a: 48e70018             movem.l    a3-a4, -(a7)
191e: 266e0008             movea.l    $8(a6), a3
1922: 49eb0012             lea.l      $12(a3), a4
1926: 4294                 clr.l      (a4)
1928: 2f0b                 move.l     a3, -(a7)
192a: 4ebafcc2             jsr        $15ee(pc)
192e: 4a2b0001             tst.b      $1(a3)
1932: 588f                 addq.l     #$4, a7
1934: 6a18                 bpl.b      $194e
1936: 202b000a             move.l     $a(a3), d0
193a: 2880                 move.l     d0, (a4)
193c: d1ab0016             add.l      d0, $16(a3)
1940: 276b0006000e         move.l     $6(a3), $e(a3)
1946: 08ab00070001         bclr.b     #$7, $1(a3)
194c: 6016                 bra.b      $1964
194e: 2f0b                 move.l     a3, -(a7)
1950: 4eba00cc             jsr        $1a1e(pc)
1954: 2e8b                 move.l     a3, (a7)
1956: 4ebafdde             jsr        $1736(pc)
195a: 4a40                 tst.w      d0
195c: 588f                 addq.l     #$4, a7
195e: 6704                 beq.b      $1964
1960: 70ff                 moveq      #$ff, d0
1962: 600e                 bra.b      $1972
1964: 5394                 subq.l     #$1, (a4)
1966: 206b000e             movea.l    $e(a3), a0
196a: 52ab000e             addq.l     #$1, $e(a3)
196e: 7000                 moveq      #$0, d0
1970: 1010                 move.b     (a0), d0
1972: 4cdf1800             movem.l    (a7)+, a3-a4
1976: 4e5e                 unlk       a6
1978: 4e75                 rts        
197a: 4e560000             link.w     a6, #$0
197e: 48e70108             movem.l    d7/a4, -(a7)
1982: 3e2e0008             move.w     $8(a6), d7
1986: 286e000a             movea.l    $a(a6), a4
198a: 08140003             btst.b     #$3, (a4)
198e: 6642                 bne.b      $19d2
1990: 2f0c                 move.l     a4, -(a7)
1992: 4ebafc5a             jsr        $15ee(pc)
1996: 08140001             btst.b     #$1, (a4)
199a: 588f                 addq.l     #$4, a7
199c: 6706                 beq.b      $19a4
199e: 296c001a0016         move.l     $1a(a4), $16(a4)
19a4: 2f0c                 move.l     a4, -(a7)
19a6: 4eba0076             jsr        $1a1e(pc)
19aa: 4aac001e             tst.l      $1e(a4)
19ae: 588f                 addq.l     #$4, a7
19b0: 6706                 beq.b      $19b8
19b2: 7001                 moveq      #$1, d0
19b4: 29400012             move.l     d0, $12(a4)
19b8: 08d40003             bset.b     #$3, (a4)
19bc: 53ac0012             subq.l     #$1, $12(a4)
19c0: 6710                 beq.b      $19d2
19c2: 206c000e             movea.l    $e(a4), a0
19c6: 52ac000e             addq.l     #$1, $e(a4)
19ca: 1087                 move.b     d7, (a0)
19cc: 7000                 moveq      #$0, d0
19ce: 1007                 move.b     d7, d0
19d0: 6044                 bra.b      $1a16
19d2: 7000                 moveq      #$0, d0
19d4: 1007                 move.b     d7, d0
19d6: 3e00                 move.w     d0, d7
19d8: 206c000e             movea.l    $e(a4), a0
19dc: 52ac000e             addq.l     #$1, $e(a4)
19e0: 1080                 move.b     d0, (a0)
19e2: 4aac001e             tst.l      $1e(a4)
19e6: 671c                 beq.b      $1a04
19e8: 0c470020             cmpi.w     #$20, d7
19ec: 6d16                 blt.b      $1a04
19ee: 202c000e             move.l     $e(a4), d0
19f2: 90ac0006             sub.l      $6(a4), d0
19f6: b0ac000a             cmp.l      $a(a4), d0
19fa: 6408                 bcc.b      $1a04
19fc: 7001                 moveq      #$1, d0
19fe: 29400012             move.l     d0, $12(a4)
1a02: 6010                 bra.b      $1a14
1a04: 2f0c                 move.l     a4, -(a7)
1a06: 4ebafec0             jsr        $18c8(pc)
1a0a: 4a40                 tst.w      d0
1a0c: 588f                 addq.l     #$4, a7
1a0e: 6704                 beq.b      $1a14
1a10: 70ff                 moveq      #$ff, d0
1a12: 6002                 bra.b      $1a16
1a14: 3007                 move.w     d7, d0
1a16: 4cdf1080             movem.l    (a7)+, d7/a4
1a1a: 4e5e                 unlk       a6
1a1c: 4e75                 rts        
1a1e: 4e560000             link.w     a6, #$0
1a22: 2f0c                 move.l     a4, -(a7)
1a24: 286e0008             movea.l    $8(a6), a4
1a28: 296c0006000e         move.l     $6(a4), $e(a4)
1a2e: 296c000a0012         move.l     $a(a4), $12(a4)
1a34: 4a6c0004             tst.w      $4(a4)
1a38: 6f18                 ble.b      $1a52
1a3a: 7001                 moveq      #$1, d0
1a3c: b0ac000a             cmp.l      $a(a4), d0
1a40: 6410                 bcc.b      $1a52
1a42: 2f2c000a             move.l     $a(a4), -(a7)
1a46: 2f2c0016             move.l     $16(a4), -(a7)
1a4a: 4ead0052             jsr        $52(a5) ; CODE1+0144
1a4e: 91ac0012             sub.l      d0, $12(a4)
1a52: 202c0012             move.l     $12(a4), d0
1a56: d1ac0016             add.l      d0, $16(a4)
1a5a: 285f                 movea.l    (a7)+, a4
1a5c: 4e5e                 unlk       a6
1a5e: 4e75                 rts        
1a60: 4e560000             link.w     a6, #$0
1a64: 2f0c                 move.l     a4, -(a7)
1a66: 286e0008             movea.l    $8(a6), a4
1a6a: 206c0006             movea.l    $6(a4), a0
1a6e: d1ec000a             adda.l     $a(a4), a0
1a72: 2948000e             move.l     a0, $e(a4)
1a76: 42ac0012             clr.l      $12(a4)
1a7a: 08ac00070001         bclr.b     #$7, $1(a4)
1a80: 285f                 movea.l    (a7)+, a4
1a82: 4e5e                 unlk       a6
1a84: 4e75                 rts        
