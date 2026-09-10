0004: 4e56fffc             link.w     a6, #$fffc
0008: 48e70118             movem.l    d7/a3-a4, -(a7)
000c: 266e000c             movea.l    $c(a6), a3
0010: 486efffc             pea.l      -$4(a6)
0014: 4267                 clr.w      -(a7)
0016: 2f2e0008             move.l     $8(a6), -(a7)
001a: 4ead0d3a             jsr        $d3a(a5) ; CODE47+025c
001e: 2840                 movea.l    d0, a4
0020: 200c                 move.l     a4, d0
0022: 4fef000a             lea.l      $a(a7), a7
0026: 6626                 bne.b      $4e
0028: 2b6d9f28a222         move.l     -$60d8(a5), -$5dde(a5)
002e: 536da386             subq.w     #$1, -$5c7a(a5)
0032: 702c                 moveq      #$2c, d0
0034: c1eda386             muls.w     -$5c7a(a5), d0
0038: 41eda226             lea.l      -$5dda(a5), a0
003c: d088                 add.l      a0, d0
003e: 2040                 movea.l    d0, a0
0040: 7001                 moveq      #$1, d0
0042: 4a40                 tst.w      d0
0044: 6602                 bne.b      $48
0046: 7001                 moveq      #$1, d0
0048: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
004c: 4ed1                 jmp        (a1)
004e: 202efffc             move.l     -$4(a6), d0
0052: e488                 lsr.l      #$2, d0
0054: 2d40fffc             move.l     d0, -$4(a6)
0058: 5580                 subq.l     #$2, d0
005a: 2680                 move.l     d0, (a3)
005c: 4a80                 tst.l      d0
005e: 6226                 bhi.b      $86
0060: 2b6d9f28a222         move.l     -$60d8(a5), -$5dde(a5)
0066: 536da386             subq.w     #$1, -$5c7a(a5)
006a: 702c                 moveq      #$2c, d0
006c: c1eda386             muls.w     -$5c7a(a5), d0
0070: 41eda226             lea.l      -$5dda(a5), a0
0074: d088                 add.l      a0, d0
0076: 2040                 movea.l    d0, a0
0078: 7001                 moveq      #$1, d0
007a: 4a40                 tst.w      d0
007c: 6602                 bne.b      $80
007e: 7001                 moveq      #$1, d0
0080: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
0084: 4ed1                 jmp        (a1)
0086: 2e13                 move.l     (a3), d7
0088: 2007                 move.l     d7, d0
008a: e588                 lsl.l      #$2, d0
008c: 0c3400610803         cmpi.b     #$61, $3(a4, d0.l)
0092: 6734                 beq.b      $c8
0094: 70e6                 moveq      #$e6, d0
0096: d0aefffc             add.l      -$4(a6), d0
009a: b087                 cmp.l      d7, d0
009c: 6326                 bls.b      $c4
009e: 2b6d9f28a222         move.l     -$60d8(a5), -$5dde(a5)
00a4: 536da386             subq.w     #$1, -$5c7a(a5)
00a8: 702c                 moveq      #$2c, d0
00aa: c1eda386             muls.w     -$5c7a(a5), d0
00ae: 41eda226             lea.l      -$5dda(a5), a0
00b2: d088                 add.l      a0, d0
00b4: 2040                 movea.l    d0, a0
00b6: 7001                 moveq      #$1, d0
00b8: 4a40                 tst.w      d0
00ba: 6602                 bne.b      $be
00bc: 7001                 moveq      #$1, d0
00be: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
00c2: 4ed1                 jmp        (a1)
00c4: 5393                 subq.l     #$1, (a3)
00c6: 60be                 bra.b      $86
00c8: 200c                 move.l     a4, d0
00ca: 4cdf1880             movem.l    (a7)+, d7/a3-a4
00ce: 4e5e                 unlk       a6
00d0: 4e75                 rts        
00d2: 4e560000             link.w     a6, #$0
00d6: 48e70700             movem.l    d5-d7, -(a7)
00da: 206e0008             movea.l    $8(a6), a0
00de: 1e10                 move.b     (a0), d7
00e0: 2c2dd144             move.l     -$2ebc(a5), d6
00e4: 6034                 bra.b      $11a
00e6: 2006                 move.l     d6, d0
00e8: e588                 lsl.l      #$2, d0
00ea: d0add140             add.l      -$2ec0(a5), d0
00ee: 2040                 movea.l    d0, a0
00f0: 2a10                 move.l     (a0), d5
00f2: be05                 cmp.b      d5, d7
00f4: 6614                 bne.b      $10a
00f6: 2c05                 move.l     d5, d6
00f8: 700a                 moveq      #$a, d0
00fa: e0a6                 asr.l      d0, d6
00fc: 6720                 beq.b      $11e
00fe: 52ae0008             addq.l     #$1, $8(a6)
0102: 206e0008             movea.l    $8(a6), a0
0106: 1e10                 move.b     (a0), d7
0108: 6010                 bra.b      $11a
010a: 08050009             btst.b     #$9, d5
010e: 6604                 bne.b      $114
0110: be05                 cmp.b      d5, d7
0112: 6c04                 bge.b      $118
0114: 7000                 moveq      #$0, d0
0116: 6008                 bra.b      $120
0118: 5286                 addq.l     #$1, d6
011a: 4a07                 tst.b      d7
011c: 66c8                 bne.b      $e6
011e: 2006                 move.l     d6, d0
0120: 4cdf00e0             movem.l    (a7)+, d5-d7
0124: 4e5e                 unlk       a6
0126: 4e75                 rts        
0128: 4e560000             link.w     a6, #$0
012c: 48e70718             movem.l    d5-d7/a3-a4, -(a7)
0130: 266e0008             movea.l    $8(a6), a3
0134: 7e00                 moveq      #$0, d7
0136: 49edd148             lea.l      -$2eb8(a5), a4
013a: 2b54d140             move.l     (a4), -$2ec0(a5)
013e: 3b47d548             move.w     d7, -$2ab8(a5)
0142: 204d                 movea.l    a5, a0
0144: 2007                 move.l     d7, d0
0146: 48c0                 ext.l      d0
0148: e788                 lsl.l      #$3, d0
014a: d1c0                 adda.l     d0, a0
014c: 2b68d14cd144         move.l     -$2eb4(a0), -$2ebc(a5)
0152: 673a                 beq.b      $18e
0154: 2f2e000c             move.l     $c(a6), -(a7)
0158: 4ebaff78             jsr        $d2(pc)
015c: 2c00                 move.l     d0, d6
015e: 4a86                 tst.l      d6
0160: 588f                 addq.l     #$4, a7
0162: 6724                 beq.b      $188
0164: 2006                 move.l     d6, d0
0166: 5286                 addq.l     #$1, d6
0168: e588                 lsl.l      #$2, d0
016a: d0add140             add.l      -$2ec0(a5), d0
016e: 2040                 movea.l    d0, a0
0170: 2a10                 move.l     (a0), d5
0172: 1685                 move.b     d5, (a3)
0174: 4a6e0010             tst.w      $10(a6)
0178: 6706                 beq.b      $180
017a: 08050008             btst.b     #$8, d5
017e: 6702                 beq.b      $182
0180: 528b                 addq.l     #$1, a3
0182: 08050009             btst.b     #$9, d5
0186: 67dc                 beq.b      $164
0188: 5287                 addq.l     #$1, d7
018a: 508c                 addq.l     #$8, a4
018c: 60ac                 bra.b      $13a
018e: 4213                 clr.b      (a3)
0190: 4cdf18e0             movem.l    (a7)+, d5-d7/a3-a4
0194: 4e5e                 unlk       a6
0196: 4e75                 rts        
0198: 4e560000             link.w     a6, #$0
019c: 2f07                 move.l     d7, -(a7)
019e: 7e00                 moveq      #$0, d7
01a0: 6018                 bra.b      $1ba
01a2: 2f2e0008             move.l     $8(a6), -(a7)
01a6: 3047                 movea.w    d7, a0
01a8: 2f08                 move.l     a0, -(a7)
01aa: 4eba001c             jsr        $1c8(pc)
01ae: 4a80                 tst.l      d0
01b0: 508f                 addq.l     #$8, a7
01b2: 6704                 beq.b      $1b8
01b4: 7001                 moveq      #$1, d0
01b6: 600a                 bra.b      $1c2
01b8: 5247                 addq.w     #$1, d7
01ba: be6dd548             cmp.w      -$2ab8(a5), d7
01be: 6de2                 blt.b      $1a2
01c0: 7000                 moveq      #$0, d0
01c2: 2e1f                 move.l     (a7)+, d7
01c4: 4e5e                 unlk       a6
01c6: 4e75                 rts        
01c8: 4e560000             link.w     a6, #$0
01cc: 48e70708             movem.l    d5-d7/a4, -(a7)
01d0: 2c2e0008             move.l     $8(a6), d6
01d4: 206e000c             movea.l    $c(a6), a0
01d8: 1e10                 move.b     (a0), d7
01da: 224d                 movea.l    a5, a1
01dc: 2006                 move.l     d6, d0
01de: e788                 lsl.l      #$3, d0
01e0: d3c0                 adda.l     d0, a1
01e2: 2869d148             movea.l    -$2eb8(a1), a4
01e6: 224d                 movea.l    a5, a1
01e8: 2006                 move.l     d6, d0
01ea: e788                 lsl.l      #$3, d0
01ec: d3c0                 adda.l     d0, a1
01ee: 2c29d14c             move.l     -$2eb4(a1), d6
01f2: 2006                 move.l     d6, d0
01f4: e588                 lsl.l      #$2, d0
01f6: 2a340800             move.l     (a4, d0.l), d5
01fa: be05                 cmp.b      d5, d7
01fc: 6622                 bne.b      $220
01fe: 52ae000c             addq.l     #$1, $c(a6)
0202: 206e000c             movea.l    $c(a6), a0
0206: 1e10                 move.b     (a0), d7
0208: 660a                 bne.b      $214
020a: 2005                 move.l     d5, d0
020c: 028000000100         andi.l     #$100, d0
0212: 6022                 bra.b      $236
0214: 2c05                 move.l     d5, d6
0216: 700a                 moveq      #$a, d0
0218: e0a6                 asr.l      d0, d6
021a: 66d6                 bne.b      $1f2
021c: 7000                 moveq      #$0, d0
021e: 6016                 bra.b      $236
0220: 08050009             btst.b     #$9, d5
0224: 6604                 bne.b      $22a
0226: be05                 cmp.b      d5, d7
0228: 6c04                 bge.b      $22e
022a: 7000                 moveq      #$0, d0
022c: 6008                 bra.b      $236
022e: 5286                 addq.l     #$1, d6
0230: 60c0                 bra.b      $1f2
0232: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0236: 4cdf10e0             movem.l    (a7)+, d5-d7/a4
023a: 4e5e                 unlk       a6
023c: 4e75                 rts        
023e: 4e560000             link.w     a6, #$0
0242: 48e70108             movem.l    d7/a4, -(a7)
0246: 7e00                 moveq      #$0, d7
0248: 49edd148             lea.l      -$2eb8(a5), a4
024c: 6018                 bra.b      $266
024e: 2f2e0008             move.l     $8(a6), -(a7)
0252: 2f07                 move.l     d7, -(a7)
0254: 4ebaff72             jsr        $1c8(pc)
0258: 4a80                 tst.l      d0
025a: 508f                 addq.l     #$8, a7
025c: 6704                 beq.b      $262
025e: 7001                 moveq      #$1, d0
0260: 600c                 bra.b      $26e
0262: 5287                 addq.l     #$1, d7
0264: 508c                 addq.l     #$8, a4
0266: 4aac0004             tst.l      $4(a4)
026a: 66e2                 bne.b      $24e
026c: 7000                 moveq      #$0, d0
026e: 4cdf1080             movem.l    (a7)+, d7/a4
0272: 4e5e                 unlk       a6
0274: 4e75                 rts        
0276: 4e56fffc             link.w     a6, #$fffc
027a: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
027e: 382e000e             move.w     $e(a6), d4
0282: 286e001c             movea.l    $1c(a6), a4
0286: 4a6e000c             tst.w      $c(a6)
028a: 661e                 bne.b      $2aa
028c: 4aae0014             tst.l      $14(a6)
0290: 6712                 beq.b      $2a4
0292: 2f2e0024             move.l     $24(a6), -(a7)
0296: 2f0c                 move.l     a4, -(a7)
0298: 206e0018             movea.l    $18(a6), a0
029c: 4e90                 jsr        (a0)
029e: 508f                 addq.l     #$8, a7
02a0: 600000b0             bra.w      $352
02a4: 7000                 moveq      #$0, d0
02a6: 600000aa             bra.w      $352
02aa: 4aae0010             tst.l      $10(a6)
02ae: 6606                 bne.b      $2b6
02b0: 7000                 moveq      #$0, d0
02b2: 6000009e             bra.w      $352
02b6: 2004                 move.l     d4, d0
02b8: 48c0                 ext.l      d0
02ba: e588                 lsl.l      #$2, d0
02bc: d0ae0020             add.l      $20(a6), d0
02c0: 2640                 movea.l    d0, a3
02c2: 3444                 movea.w    d4, a2
02c4: d5cc                 adda.l     a4, a2
02c6: 7e01                 moveq      #$1, d7
02c8: de44                 add.w      d4, d7
02ca: 78ff                 moveq      #$ff, d4
02cc: d86e000c             add.w      $c(a6), d4
02d0: 202e0010             move.l     $10(a6), d0
02d4: 52ae0010             addq.l     #$1, $10(a6)
02d8: e588                 lsl.l      #$2, d0
02da: d0add140             add.l      -$2ec0(a5), d0
02de: 2040                 movea.l    d0, a0
02e0: 2610                 move.l     (a0), d3
02e2: 1c03                 move.b     d3, d6
02e4: 4886                 ext.w      d6
02e6: 206e0008             movea.l    $8(a6), a0
02ea: 1a10                 move.b     (a0), d5
02ec: 1005                 move.b     d5, d0
02ee: 4880                 ext.w      d0
02f0: bc40                 cmp.w      d0, d6
02f2: 6716                 beq.b      $30a
02f4: 4a05                 tst.b      d5
02f6: 6652                 bne.b      $34a
02f8: 4aae0020             tst.l      $20(a6)
02fc: 670c                 beq.b      $30a
02fe: 709f                 moveq      #$9f, d0
0300: d006                 add.b      d6, d0
0302: 7201                 moveq      #$1, d1
0304: e1a9                 lsl.l      d0, d1
0306: c293                 and.l      (a3), d1
0308: 6740                 beq.b      $34a
030a: 1486                 move.b     d6, (a2)
030c: 2f2e0024             move.l     $24(a6), -(a7)
0310: 2f2e0020             move.l     $20(a6), -(a7)
0314: 2f0c                 move.l     a4, -(a7)
0316: 2f2e0018             move.l     $18(a6), -(a7)
031a: 2003                 move.l     d3, d0
031c: 028000000100         andi.l     #$100, d0
0322: 2f00                 move.l     d0, -(a7)
0324: 2003                 move.l     d3, d0
0326: 720a                 moveq      #$a, d1
0328: e2a8                 lsr.l      d1, d0
032a: 2f00                 move.l     d0, -(a7)
032c: 3f07                 move.w     d7, -(a7)
032e: 3f04                 move.w     d4, -(a7)
0330: 206e0008             movea.l    $8(a6), a0
0334: 48680001             pea.l      $1(a0)
0338: 4ebaff3c             jsr        $276(pc)
033c: 3c00                 move.w     d0, d6
033e: 4a46                 tst.w      d6
0340: 4fef0020             lea.l      $20(a7), a7
0344: 6704                 beq.b      $34a
0346: 3006                 move.w     d6, d0
0348: 6008                 bra.b      $352
034a: 08030009             btst.b     #$9, d3
034e: 6780                 beq.b      $2d0
0350: 7000                 moveq      #$0, d0
0352: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0356: 4e5e                 unlk       a6
0358: 4e75                 rts        
035a: 4e56ff00             link.w     a6, #$ff00
035e: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
0362: 7e00                 moveq      #$0, d7
0364: 302e000c             move.w     $c(a6), d0
0368: 49eeff00             lea.l      -$100(a6), a4
036c: d8c0                 adda.w     d0, a4
036e: 2207                 move.l     d7, d1
0370: 48c1                 ext.l      d1
0372: e789                 lsl.l      #$3, d1
0374: 47edd148             lea.l      -$2eb8(a5), a3
0378: d28b                 add.l      a3, d1
037a: 2641                 movea.l    d1, a3
037c: 2b53d140             move.l     (a3), -$2ec0(a5)
0380: 3b47d548             move.w     d7, -$2ab8(a5)
0384: 204d                 movea.l    a5, a0
0386: 2007                 move.l     d7, d0
0388: 48c0                 ext.l      d0
038a: e788                 lsl.l      #$3, d0
038c: d1c0                 adda.l     d0, a0
038e: 2b68d14cd144         move.l     -$2eb4(a0), -$2ebc(a5)
0394: 673a                 beq.b      $3d0
0396: 4214                 clr.b      (a4)
0398: 2f2e0016             move.l     $16(a6), -(a7)
039c: 2f2e0012             move.l     $12(a6), -(a7)
03a0: 486eff00             pea.l      -$100(a6)
03a4: 2f2e000e             move.l     $e(a6), -(a7)
03a8: 42a7                 clr.l      -(a7)
03aa: 2f2dd144             move.l     -$2ebc(a5), -(a7)
03ae: 4267                 clr.w      -(a7)
03b0: 3f2e000c             move.w     $c(a6), -(a7)
03b4: 2f2e0008             move.l     $8(a6), -(a7)
03b8: 4ebafebc             jsr        $276(pc)
03bc: 3c00                 move.w     d0, d6
03be: 4a46                 tst.w      d6
03c0: 4fef0020             lea.l      $20(a7), a7
03c4: 6704                 beq.b      $3ca
03c6: 3006                 move.w     d6, d0
03c8: 6008                 bra.b      $3d2
03ca: 5247                 addq.w     #$1, d7
03cc: 508b                 addq.l     #$8, a3
03ce: 60ac                 bra.b      $37c
03d0: 7000                 moveq      #$0, d0
03d2: 4cdf18c0             movem.l    (a7)+, d6-d7/a3-a4
03d6: 4e5e                 unlk       a6
03d8: 4e75                 rts        
03da: 4e560000             link.w     a6, #$0
03de: 2f0c                 move.l     a4, -(a7)
03e0: 42a7                 clr.l      -(a7)
03e2: 3f2e0008             move.w     $8(a6), -(a7)
03e6: 2f2e000a             move.l     $a(a6), -(a7)
03ea: 2f2e000e             move.l     $e(a6), -(a7)
03ee: a9bd                 dc.w       $a9bd
03f0: 285f                 movea.l    (a7)+, a4
03f2: 2f0c                 move.l     a4, -(a7)
03f4: 1f3c0001             move.b     #$1, -(a7)
03f8: a91c                 dc.w       $a91c
03fa: 296de38c007e         move.l     -$1c74(a5), $7e(a4)
0400: 200c                 move.l     a4, d0
0402: 285f                 movea.l    (a7)+, a4
0404: 4e5e                 unlk       a6
0406: 4e75                 rts        
0408: 4e560000             link.w     a6, #$0
040c: 2f0c                 move.l     a4, -(a7)
040e: 42a7                 clr.l      -(a7)
0410: 2f2e0008             move.l     $8(a6), -(a7)
0414: 2f2e000c             move.l     $c(a6), -(a7)
0418: 2f2e0010             move.l     $10(a6), -(a7)
041c: 4227                 clr.b      -(a7)
041e: 3f2e0016             move.w     $16(a6), -(a7)
0422: 42a7                 clr.l      -(a7)
0424: 1f2e001c             move.b     $1c(a6), -(a7)
0428: 2f2e001e             move.l     $1e(a6), -(a7)
042c: a913                 dc.w       $a913
042e: 285f                 movea.l    (a7)+, a4
0430: 2f0c                 move.l     a4, -(a7)
0432: 1f3c0001             move.b     #$1, -(a7)
0436: a91c                 dc.w       $a91c
0438: 296de38c007e         move.l     -$1c74(a5), $7e(a4)
043e: 2f0c                 move.l     a4, -(a7)
0440: 4ead0c3a             jsr        $c3a(a5) ; CODE46+0966
0444: 4a2e0014             tst.b      $14(a6)
0448: 588f                 addq.l     #$4, a7
044a: 6708                 beq.b      $454
044c: 2f0c                 move.l     a4, -(a7)
044e: 1f3c0001             move.b     #$1, -(a7)
0452: a908                 dc.w       $a908
0454: 200c                 move.l     a4, d0
0456: 285f                 movea.l    (a7)+, a4
0458: 4e5e                 unlk       a6
045a: 4e75                 rts        
045c: 4e560000             link.w     a6, #$0
0460: 2f0c                 move.l     a4, -(a7)
0462: 42a7                 clr.l      -(a7)
0464: 2f2e0008             move.l     $8(a6), -(a7)
0468: 2f2e000c             move.l     $c(a6), -(a7)
046c: 2f2e0010             move.l     $10(a6), -(a7)
0470: 4227                 clr.b      -(a7)
0472: 3f2e0016             move.w     $16(a6), -(a7)
0476: 42a7                 clr.l      -(a7)
0478: 1f2e001c             move.b     $1c(a6), -(a7)
047c: 2f2e001e             move.l     $1e(a6), -(a7)
0480: 2f2e0022             move.l     $22(a6), -(a7)
0484: a97d                 dc.w       $a97d
0486: 285f                 movea.l    (a7)+, a4
0488: 2f0c                 move.l     a4, -(a7)
048a: 1f3c0001             move.b     #$1, -(a7)
048e: a91c                 dc.w       $a91c
0490: 296de38c007e         move.l     -$1c74(a5), $7e(a4)
0496: 2f0c                 move.l     a4, -(a7)
0498: 4ead0c3a             jsr        $c3a(a5) ; CODE46+0966
049c: 4a2e0014             tst.b      $14(a6)
04a0: 588f                 addq.l     #$4, a7
04a2: 6708                 beq.b      $4ac
04a4: 2f0c                 move.l     a4, -(a7)
04a6: 1f3c0001             move.b     #$1, -(a7)
04aa: a908                 dc.w       $a908
04ac: 200c                 move.l     a4, d0
04ae: 285f                 movea.l    (a7)+, a4
04b0: 4e5e                 unlk       a6
04b2: 4e75                 rts        
04b4: 7006                 moveq      #$6, d0
04b6: a122                 dc.w       $a122
04b8: 2b48e38c             move.l     a0, -$1c74(a5)
04bc: 2050                 movea.l    (a0), a0
04be: 30bc4ef9             move.w     #$4ef9, (a0)
04c2: 206de38c             movea.l    -$1c74(a5), a0
04c6: 43ed0c52             lea.l      $c52(a5), a1
04ca: 2050                 movea.l    (a0), a0
04cc: 21490002             move.l     a1, $2(a0)
04d0: 4e75                 rts        
04d2: 4e56fff8             link.w     a6, #$fff8
04d6: 4eba07e8             jsr        $cc0(pc)
04da: 20380908             move.l     $908.w, d0
04de: 0680ffff4000         addi.l     #$ffff4000, d0
04e4: 2040                 movea.l    d0, a0
04e6: a02d                 dc.w       $a02d
04e8: 486de46c             pea.l      -$1b94(a5)
04ec: 486dd700             pea.l      -$2900(a5)
04f0: 4ead0812             jsr        $812(a5) ; CODE24+16a6
04f4: 0c6d0280fa5c         cmpi.w     #$280, -$5a4(a5)
04fa: 508f                 addq.l     #$8, a7
04fc: 6d12                 blt.b      $510
04fe: 0c6d01e0fa5a         cmpi.w     #$1e0, -$5a6(a5)
0504: 6d0a                 blt.b      $510
0506: 41ede398             lea.l      -$1c68(a5), a0
050a: 2b48de80             move.l     a0, -$2180(a5)
050e: 6008                 bra.b      $518
0510: 41ede402             lea.l      -$1bfe(a5), a0
0514: 2b48de80             move.l     a0, -$2180(a5)
0518: 4ebaff9a             jsr        $4b4(pc)
051c: 3f2df270             move.w     -$d90(a5), -(a7)
0520: 48780910             pea.l      $910.w
0524: 4eba0826             jsr        $d4c(pc)
0528: 4a40                 tst.w      d0
052a: 5c8f                 addq.l     #$6, a7
052c: 6726                 beq.b      $554
052e: 2b6da1b2a222         move.l     -$5e4e(a5), -$5dde(a5)
0534: 536da386             subq.w     #$1, -$5c7a(a5)
0538: 702c                 moveq      #$2c, d0
053a: c1eda386             muls.w     -$5c7a(a5), d0
053e: 41eda226             lea.l      -$5dda(a5), a0
0542: d088                 add.l      a0, d0
0544: 2040                 movea.l    d0, a0
0546: 7001                 moveq      #$1, d0
0548: 4a40                 tst.w      d0
054a: 6602                 bne.b      $54e
054c: 7001                 moveq      #$1, d0
054e: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
0552: 4ed1                 jmp        (a1)
0554: 4ead00f2             jsr        $f2(a5) ; CODE6+0066
0558: 422dc35e             clr.b      -$3ca2(a5)
055c: 422dc366             clr.b      -$3c9a(a5)
0560: 4a2dd72a             tst.b      -$28d6(a5)
0564: 6618                 bne.b      $57e
0566: 486dd700             pea.l      -$2900(a5)
056a: 486de47c             pea.l      -$1b84(a5)
056e: 486dd72b             pea.l      -$28d5(a5)
0572: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0576: 1b40d72a             move.b     d0, -$28d6(a5)
057a: 4fef000c             lea.l      $c(a7), a7
057e: 4eba04de             jsr        $a5e(pc)
0582: 486de488             pea.l      -$1b78(a5)
0586: 486ddec0             pea.l      -$2140(a5)
058a: a900                 dc.w       $a900
058c: 4a6ddec0             tst.w      -$2140(a5)
0590: 6604                 bne.b      $596
0592: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0596: 4267                 clr.w      -(a7)
0598: 42a7                 clr.l      -(a7)
059a: 4ead0082             jsr        $82(a5) ; CODE2+0004
059e: 4ead00fa             jsr        $fa(a5) ; CODE6+0004
05a2: 4eba006a             jsr        $60e(pc)
05a6: 4e5e                 unlk       a6
05a8: 4e75                 rts        
05aa: 4e56fff8             link.w     a6, #$fff8
05ae: 2f0c                 move.l     a4, -(a7)
05b0: 486efff8             pea.l      -$8(a6)
05b4: 206dde80             movea.l    -$2180(a5), a0
05b8: 3f28005a             move.w     $5a(a0), -(a7)
05bc: 3f28005c             move.w     $5c(a0), -(a7)
05c0: 3f28005e             move.w     $5e(a0), -(a7)
05c4: 3f280060             move.w     $60(a0), -(a7)
05c8: a8a7                 dc.w       $a8a7
05ca: 2f2e000c             move.l     $c(a6), -(a7)
05ce: 1f3c0001             move.b     #$1, -(a7)
05d2: 4878ffff             pea.l      $ffff.w
05d6: 42a7                 clr.l      -(a7)
05d8: 2f2e0008             move.l     $8(a6), -(a7)
05dc: 486efff8             pea.l      -$8(a6)
05e0: 203c000000a8         move.l     #$a8, d0
05e6: a31e                 dc.w       $a31e
05e8: 2f08                 move.l     a0, -(a7)
05ea: 4ebafe1c             jsr        $408(pc)
05ee: 2840                 movea.l    d0, a4
05f0: 2ebc0016000a         move.l     #$16000a, (a7)
05f6: 3f3c0001             move.w     #$1, -(a7)
05fa: 486efff8             pea.l      -$8(a6)
05fe: 2f0c                 move.l     a4, -(a7)
0600: 4ead073a             jsr        $73a(a5) ; CODE17+093a
0604: 200c                 move.l     a4, d0
0606: 286efff4             movea.l    -$c(a6), a4
060a: 4e5e                 unlk       a6
060c: 4e75                 rts        
060e: 2f0c                 move.l     a4, -(a7)
0610: 42a7                 clr.l      -(a7)
0612: 3f3c0081             move.w     #$81, -(a7)
0616: a9c0                 dc.w       $a9c0
0618: a93c                 dc.w       $a93c
061a: 42a7                 clr.l      -(a7)
061c: 3f3c0080             move.w     #$80, -(a7)
0620: a949                 dc.w       $a949
0622: 285f                 movea.l    (a7)+, a4
0624: 200c                 move.l     a4, d0
0626: 6604                 bne.b      $62c
0628: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
062c: 2f0c                 move.l     a4, -(a7)
062e: 2f3c44525652         move.l     #$44525652, -(a7)
0634: a94d                 dc.w       $a94d
0636: 206dde78             movea.l    -$2188(a5), a0
063a: 2050                 movea.l    (a0), a0
063c: 3f280300             move.w     $300(a0), -(a7)
0640: 4267                 clr.w      -(a7)
0642: 42a7                 clr.l      -(a7)
0644: 3f3c0005             move.w     #$5, -(a7)
0648: a949                 dc.w       $a949
064a: a950                 dc.w       $a950
064c: 4ead0272             jsr        $272(a5) ; CODE13+01ea
0650: 3ebc0001             move.w     #$1, (a7)
0654: 206dde78             movea.l    -$2188(a5), a0
0658: 2250                 movea.l    (a0), a1
065a: 30290302             move.w     $302(a1), d0
065e: c1fc00c0             muls.w     #$c0, d0
0662: 2050                 movea.l    (a0), a0
0664: 3f30080a             move.w     $a(a0, d0.l), -(a7)
0668: 4ead0272             jsr        $272(a5) ; CODE13+01ea
066c: a937                 dc.w       $a937
066e: 5c8f                 addq.l     #$6, a7
0670: 285f                 movea.l    (a7)+, a4
0672: 4e75                 rts        
0674: 4e56ffe6             link.w     a6, #$ffe6
0678: 48e70738             movem.l    d5-d7/a2-a4, -(a7)
067c: 486efff8             pea.l      -$8(a6)
0680: 206dde80             movea.l    -$2180(a5), a0
0684: 3f28002e             move.w     $2e(a0), -(a7)
0688: 3f280030             move.w     $30(a0), -(a7)
068c: 3f280032             move.w     $32(a0), -(a7)
0690: 3f280034             move.w     $34(a0), -(a7)
0694: a8a7                 dc.w       $a8a7
0696: 42a7                 clr.l      -(a7)
0698: 2f3c4449544c         move.l     #$4449544c, -(a7)
069e: 206dde80             movea.l    -$2180(a5), a0
06a2: 3f10                 move.w     (a0), -(a7)
06a4: a9a0                 dc.w       $a9a0
06a6: 285f                 movea.l    (a7)+, a4
06a8: 200c                 move.l     a4, d0
06aa: 6604                 bne.b      $6b0
06ac: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
06b0: 486efff8             pea.l      -$8(a6)
06b4: 206dde80             movea.l    -$2180(a5), a0
06b8: 3f10                 move.w     (a0), -(a7)
06ba: 2f3c4449544c         move.l     #$4449544c, -(a7)
06c0: 4ead0d12             jsr        $d12(a5) ; CODE49+00bc
06c4: 4a2df269             tst.b      -$d97(a5)
06c8: 4fef000a             lea.l      $a(a7), a7
06cc: 6740                 beq.b      $70e
06ce: 42a7                 clr.l      -(a7)
06d0: 203c000000d4         move.l     #$d4, d0
06d6: a31e                 dc.w       $a31e
06d8: 2f08                 move.l     a0, -(a7)
06da: 486efff8             pea.l      -$8(a6)
06de: 486dd72a             pea.l      -$28d6(a5)
06e2: 2f3c00040100         move.l     #$40100, -(a7)
06e8: 4878ffff             pea.l      $ffff.w
06ec: 4227                 clr.b      -(a7)
06ee: 486def2a             pea.l      -$10d6(a5)
06f2: 2f0c                 move.l     a4, -(a7)
06f4: aa4b                 dc.w       $aa4b
06f6: 2b5fdec2             move.l     (a7)+, -$213e(a5)
06fa: 2f2ddec2             move.l     -$213e(a5), -(a7)
06fe: 42a7                 clr.l      -(a7)
0700: 3f3c0080             move.w     #$80, -(a7)
0704: aa92                 dc.w       $aa92
0706: 1f3c0001             move.b     #$1, -(a7)
070a: aa95                 dc.w       $aa95
070c: 602c                 bra.b      $73a
070e: 42a7                 clr.l      -(a7)
0710: 203c000000d4         move.l     #$d4, d0
0716: a31e                 dc.w       $a31e
0718: 2f08                 move.l     a0, -(a7)
071a: 486efff8             pea.l      -$8(a6)
071e: 486dd72a             pea.l      -$28d6(a5)
0722: 2f3c00040100         move.l     #$40100, -(a7)
0728: 4878ffff             pea.l      $ffff.w
072c: 4227                 clr.b      -(a7)
072e: 486def2a             pea.l      -$10d6(a5)
0732: 2f0c                 move.l     a4, -(a7)
0734: a97d                 dc.w       $a97d
0736: 2b5fdec2             move.l     (a7)+, -$213e(a5)
073a: 2f2ddec2             move.l     -$213e(a5), -(a7)
073e: 4ead0212             jsr        $212(a5) ; CODE11+0180
0742: 4ead0552             jsr        $552(a5) ; CODE21+0052
0746: 7001                 moveq      #$1, d0
0748: 3b40de4e             move.w     d0, -$21b2(a5)
074c: 3b40de52             move.w     d0, -$21ae(a5)
0750: 3b40de50             move.w     d0, -$21b0(a5)
0754: 486def7a             pea.l      -$1086(a5)
0758: 3f3c0001             move.w     #$1, -(a7)
075c: 2f2ddec2             move.l     -$213e(a5), -(a7)
0760: 4ead05da             jsr        $5da(a5) ; CODE9+0d14
0764: 2eaddec2             move.l     -$213e(a5), (a7)
0768: 3f3c0001             move.w     #$1, -(a7)
076c: 486efff6             pea.l      -$a(a6)
0770: 486ddeca             pea.l      -$2136(a5)
0774: 486efff8             pea.l      -$8(a6)
0778: a98d                 dc.w       $a98d
077a: 486def8a             pea.l      -$1076(a5)
077e: 3f3c0002             move.w     #$2, -(a7)
0782: 2f2ddec2             move.l     -$213e(a5), -(a7)
0786: 4ead05da             jsr        $5da(a5) ; CODE9+0d14
078a: 2eaddec2             move.l     -$213e(a5), (a7)
078e: 3f3c0002             move.w     #$2, -(a7)
0792: 486efff6             pea.l      -$a(a6)
0796: 486ddece             pea.l      -$2132(a5)
079a: 486efff8             pea.l      -$8(a6)
079e: a98d                 dc.w       $a98d
07a0: 486def9a             pea.l      -$1066(a5)
07a4: 3f3c0004             move.w     #$4, -(a7)
07a8: 2f2ddec2             move.l     -$213e(a5), -(a7)
07ac: 4ead05da             jsr        $5da(a5) ; CODE9+0d14
07b0: 2eaddec2             move.l     -$213e(a5), (a7)
07b4: 3f3c0004             move.w     #$4, -(a7)
07b8: 486efff6             pea.l      -$a(a6)
07bc: 486dded2             pea.l      -$212e(a5)
07c0: 486efff8             pea.l      -$8(a6)
07c4: a98d                 dc.w       $a98d
07c6: 2eaddec2             move.l     -$213e(a5), (a7)
07ca: 3f3c0003             move.w     #$3, -(a7)
07ce: a827                 dc.w       $a827
07d0: 206dde80             movea.l    -$2180(a5), a0
07d4: 2d68003efff8         move.l     $3e(a0), -$8(a6)
07da: 2d680042fffc         move.l     $42(a0), -$4(a6)
07e0: 486efff8             pea.l      -$8(a6)
07e4: 2f3c00010001         move.l     #$10001, -(a7)
07ea: a8a9                 dc.w       $a8a9
07ec: 70f0                 moveq      #$f0, d0
07ee: d06efffe             add.w      -$2(a6), d0
07f2: 3d40fffa             move.w     d0, -$6(a6)
07f6: 066e000dfff8         addi.w     #$d, -$8(a6)
07fc: 4297                 clr.l      (a7)
07fe: 2f2ddec2             move.l     -$213e(a5), -(a7)
0802: 486efff8             pea.l      -$8(a6)
0806: 2f2df248             move.l     -$db8(a5), -(a7)
080a: 42a7                 clr.l      -(a7)
080c: 42a7                 clr.l      -(a7)
080e: 3f3c0010             move.w     #$10, -(a7)
0812: 486def04             pea.l      -$10fc(a5)
0816: a954                 dc.w       $a954
0818: 2b5fdec6             move.l     (a7)+, -$213a(a5)
081c: 2eaddec6             move.l     -$213a(a5), (a7)
0820: a957                 dc.w       $a957
0822: 4297                 clr.l      (a7)
0824: 2f3c43464947         move.l     #$43464947, -(a7)
082a: 4267                 clr.w      -(a7)
082c: a9a0                 dc.w       $a9a0
082e: 201f                 move.l     (a7)+, d0
0830: 2b40de60             move.l     d0, -$21a0(a5)
0834: 5c8f                 addq.l     #$6, a7
0836: 660000be             bne.w      $8f6
083a: 203c00000440         move.l     #$440, d0
0840: a322                 dc.w       $a322
0842: 2b48de60             move.l     a0, -$21a0(a5)
0846: 2008                 move.l     a0, d0
0848: 6626                 bne.b      $870
084a: 2b6d93a8a222         move.l     -$6c58(a5), -$5dde(a5)
0850: 536da386             subq.w     #$1, -$5c7a(a5)
0854: 702c                 moveq      #$2c, d0
0856: c1eda386             muls.w     -$5c7a(a5), d0
085a: 41eda226             lea.l      -$5dda(a5), a0
085e: d088                 add.l      a0, d0
0860: 2040                 movea.l    d0, a0
0862: 7001                 moveq      #$1, d0
0864: 4a40                 tst.w      d0
0866: 6602                 bne.b      $86a
0868: 7001                 moveq      #$1, d0
086a: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
086e: 4ed1                 jmp        (a1)
0870: 2f2dde60             move.l     -$21a0(a5), -(a7)
0874: 2f3c43464947         move.l     #$43464947, -(a7)
087a: 4267                 clr.w      -(a7)
087c: 2f2df248             move.l     -$db8(a5), -(a7)
0880: a9ab                 dc.w       $a9ab
0882: 7c01                 moveq      #$1, d6
0884: 49ed95a3             lea.l      -$6a5d(a5), a4
0888: 47ed97c3             lea.l      -$683d(a5), a3
088c: 6026                 bra.b      $8b4
088e: 7a01                 moveq      #$1, d5
0890: 244b                 movea.l    a3, a2
0892: 2e0c                 move.l     a4, d7
0894: 600e                 bra.b      $8a4
0896: 3045                 movea.w    d5, a0
0898: 7001                 moveq      #$1, d0
089a: 11807800             move.b     d0, (a0, d7.l)
089e: 15805000             move.b     d0, (a2, d5.w)
08a2: 5245                 addq.w     #$1, d5
08a4: 0c450010             cmpi.w     #$10, d5
08a8: 65ec                 bcs.b      $896
08aa: 5246                 addq.w     #$1, d6
08ac: 49ec0011             lea.l      $11(a4), a4
08b0: 47eb0011             lea.l      $11(a3), a3
08b4: 0c46001f             cmpi.w     #$1f, d6
08b8: 65d4                 bcs.b      $88e
08ba: 206dde60             movea.l    -$21a0(a5), a0
08be: a029                 dc.w       $a029
08c0: 48780220             pea.l      $220.w
08c4: 486d97b2             pea.l      -$684e(a5)
08c8: 206dde60             movea.l    -$21a0(a5), a0
08cc: 2f10                 move.l     (a0), -(a7)
08ce: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
08d2: 48780220             pea.l      $220.w
08d6: 486d9592             pea.l      -$6a6e(a5)
08da: 206dde60             movea.l    -$21a0(a5), a0
08de: 2050                 movea.l    (a0), a0
08e0: 48680220             pea.l      $220(a0)
08e4: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
08e8: 4ead056a             jsr        $56a(a5) ; CODE21+0a2e
08ec: 4ead0512             jsr        $512(a5) ; CODE21+33fe
08f0: 4fef0018             lea.l      $18(a7), a7
08f4: 603c                 bra.b      $932
08f6: 4ead050a             jsr        $50a(a5) ; CODE21+33e4
08fa: 48780220             pea.l      $220.w
08fe: 206dde60             movea.l    -$21a0(a5), a0
0902: 2f10                 move.l     (a0), -(a7)
0904: 486d97b2             pea.l      -$684e(a5)
0908: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
090c: 48780220             pea.l      $220.w
0910: 206dde60             movea.l    -$21a0(a5), a0
0914: 2050                 movea.l    (a0), a0
0916: 48680220             pea.l      $220(a0)
091a: 486d9592             pea.l      -$6a6e(a5)
091e: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0922: 206dde60             movea.l    -$21a0(a5), a0
0926: a02a                 dc.w       $a02a
0928: 4257                 clr.w      (a7)
092a: 4ead0572             jsr        $572(a5) ; CODE21+0926
092e: 4fef0018             lea.l      $18(a7), a7
0932: 4cdf1ce0             movem.l    (a7)+, d5-d7/a2-a4
0936: 4e5e                 unlk       a6
0938: 4e75                 rts        
093a: 4e56ffec             link.w     a6, #$ffec
093e: 2f0c                 move.l     a4, -(a7)
0940: 486effec             pea.l      -$14(a6)
0944: 3f3c03f6             move.w     #$3f6, -(a7)
0948: 2f3c4449544c         move.l     #$4449544c, -(a7)
094e: 4ead060a             jsr        $60a(a5) ; CODE9+0a1c
0952: 2840                 movea.l    d0, a4
0954: 200c                 move.l     a4, d0
0956: 4fef000a             lea.l      $a(a7), a7
095a: 6604                 bne.b      $960
095c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0960: 3f3c0016             move.w     #$16, -(a7)
0964: 31df0afa             move.w     (a7)+, $afa.w
0968: 2f0c                 move.l     a4, -(a7)
096a: 486de260             pea.l      -$1da0(a5)
096e: 1f3c0001             move.b     #$1, -(a7)
0972: 4878ffff             pea.l      $ffff.w
0976: 48780004             pea.l      $4.w
097a: 2f2da1ea             move.l     -$5e16(a5), -(a7)
097e: 486effec             pea.l      -$14(a6)
0982: 203c000000aa         move.l     #$aa, d0
0988: a31e                 dc.w       $a31e
098a: 2f08                 move.l     a0, -(a7)
098c: 4ebaface             jsr        $45c(pc)
0990: 2b40deb4             move.l     d0, -$214c(a5)
0994: 4257                 clr.w      (a7)
0996: 31df0afa             move.w     (a7)+, $afa.w
099a: 2eaddeb4             move.l     -$214c(a5), (a7)
099e: 4ead0212             jsr        $212(a5) ; CODE11+0180
09a2: 486de280             pea.l      -$1d80(a5)
09a6: 3f3c0001             move.w     #$1, -(a7)
09aa: 2f2ddeb4             move.l     -$214c(a5), -(a7)
09ae: 4ead05da             jsr        $5da(a5) ; CODE9+0d14
09b2: 486de290             pea.l      -$1d70(a5)
09b6: 3f3c000a             move.w     #$a, -(a7)
09ba: 2f2ddeb4             move.l     -$214c(a5), -(a7)
09be: 4ead05da             jsr        $5da(a5) ; CODE9+0d14
09c2: 486de248             pea.l      -$1db8(a5)
09c6: 3f3c000f             move.w     #$f, -(a7)
09ca: 2f2ddeb4             move.l     -$214c(a5), -(a7)
09ce: 4ead05da             jsr        $5da(a5) ; CODE9+0d14
09d2: 286effe8             movea.l    -$18(a6), a4
09d6: 4e5e                 unlk       a6
09d8: 4e75                 rts        
09da: 4e56fff8             link.w     a6, #$fff8
09de: 486efff8             pea.l      -$8(a6)
09e2: 206dde80             movea.l    -$2180(a5), a0
09e6: 3f280036             move.w     $36(a0), -(a7)
09ea: 3f280038             move.w     $38(a0), -(a7)
09ee: 3f28003a             move.w     $3a(a0), -(a7)
09f2: 3f28003c             move.w     $3c(a0), -(a7)
09f6: a8a7                 dc.w       $a8a7
09f8: 486de338             pea.l      -$1cc8(a5)
09fc: 1f3c0001             move.b     #$1, -(a7)
0a00: 42a7                 clr.l      -(a7)
0a02: 48780004             pea.l      $4.w
0a06: 486de490             pea.l      -$1b70(a5)
0a0a: 486efff8             pea.l      -$8(a6)
0a0e: 203c000000d4         move.l     #$d4, d0
0a14: a31e                 dc.w       $a31e
0a16: 2f08                 move.l     a0, -(a7)
0a18: 4ebaf9ee             jsr        $408(pc)
0a1c: 2b40deb8             move.l     d0, -$2148(a5)
0a20: 2e80                 move.l     d0, (a7)
0a22: a873                 dc.w       $a873
0a24: 3ebc0016             move.w     #$16, (a7)
0a28: a887                 dc.w       $a887
0a2a: 3ebc000a             move.w     #$a, (a7)
0a2e: a88a                 dc.w       $a88a
0a30: 426efffc             clr.w      -$4(a6)
0a34: 426efffa             clr.w      -$6(a6)
0a38: 426efff8             clr.w      -$8(a6)
0a3c: 3d7c0001fffe         move.w     #$1, -$2(a6)
0a42: 7000                 moveq      #$0, d0
0a44: a122                 dc.w       $a122
0a46: 226ddeb8             movea.l    -$2148(a5), a1
0a4a: 234800ca             move.l     a0, $ca(a1)
0a4e: 41ed02ba             lea.l      $2ba(a5), a0
0a52: 226ddeb8             movea.l    -$2148(a5), a1
0a56: 234800ce             move.l     a0, $ce(a1)
0a5a: 4e5e                 unlk       a6
0a5c: 4e75                 rts        
0a5e: 4ebafc14             jsr        $674(pc)
0a62: 4ebafed6             jsr        $93a(pc)
0a66: 4ebaff72             jsr        $9da(pc)
0a6a: 486de936             pea.l      -$16ca(a5)
0a6e: 2f2da216             move.l     -$5dea(a5), -(a7)
0a72: 4ebafb36             jsr        $5aa(pc)
0a76: 2b40de7c             move.l     d0, -$2184(a5)
0a7a: 486dedfe             pea.l      -$1202(a5)
0a7e: 2f2da21a             move.l     -$5de6(a5), -(a7)
0a82: 4ebafb26             jsr        $5aa(pc)
0a86: 2b40deb0             move.l     d0, -$2150(a5)
0a8a: 7000                 moveq      #$0, d0
0a8c: a122                 dc.w       $a122
0a8e: 226ddec2             movea.l    -$213e(a5), a1
0a92: 234800ca             move.l     a0, $ca(a1)
0a96: 41ed04b2             lea.l      $4b2(a5), a0
0a9a: 226ddec2             movea.l    -$213e(a5), a1
0a9e: 234800ce             move.l     a0, $ce(a1)
0aa2: 4fef0010             lea.l      $10(a7), a7
0aa6: 4e75                 rts        
0aa8: 4e56fffc             link.w     a6, #$fffc
0aac: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
0ab0: 3c2e000c             move.w     $c(a6), d6
0ab4: 42a7                 clr.l      -(a7)
0ab6: 2f2e0008             move.l     $8(a6), -(a7)
0aba: 4267                 clr.w      -(a7)
0abc: a9a0                 dc.w       $a9a0
0abe: 285f                 movea.l    (a7)+, a4
0ac0: 200c                 move.l     a4, d0
0ac2: 6614                 bne.b      $ad8
0ac4: 7000                 moveq      #$0, d0
0ac6: a122                 dc.w       $a122
0ac8: 2848                 movea.l    a0, a4
0aca: 2f0c                 move.l     a4, -(a7)
0acc: 2f2e0008             move.l     $8(a6), -(a7)
0ad0: 4267                 clr.w      -(a7)
0ad2: 486de4d2             pea.l      -$1b2e(a5)
0ad6: a9ab                 dc.w       $a9ab
0ad8: 200c                 move.l     a4, d0
0ada: 6604                 bne.b      $ae0
0adc: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0ae0: 4a94                 tst.l      (a4)
0ae2: 6604                 bne.b      $ae8
0ae4: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0ae8: 42a7                 clr.l      -(a7)
0aea: 2f0c                 move.l     a4, -(a7)
0aec: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
0af0: 2d5ffffc             move.l     (a7)+, -$4(a6)
0af4: 4878001c             pea.l      $1c.w
0af8: 2f2efffc             move.l     -$4(a6), -(a7)
0afc: 4ead004a             jsr        $4a(a5) ; CODE1+0124
0b00: 3e00                 move.w     d0, d7
0b02: bc47                 cmp.w      d7, d6
0b04: 6734                 beq.b      $b3a
0b06: 701c                 moveq      #$1c, d0
0b08: c1c6                 muls.w     d6, d0
0b0a: 204c                 movea.l    a4, a0
0b0c: a024                 dc.w       $a024
0b0e: 701c                 moveq      #$1c, d0
0b10: c1c7                 muls.w     d7, d0
0b12: 2640                 movea.l    d0, a3
0b14: 6016                 bra.b      $b2c
0b16: 4878001c             pea.l      $1c.w
0b1a: 204b                 movea.l    a3, a0
0b1c: d1d4                 adda.l     (a4), a0
0b1e: 2f08                 move.l     a0, -(a7)
0b20: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0b24: 508f                 addq.l     #$8, a7
0b26: 5247                 addq.w     #$1, d7
0b28: 47eb001c             lea.l      $1c(a3), a3
0b2c: bc47                 cmp.w      d7, d6
0b2e: 6ee6                 bgt.b      $b16
0b30: 2f0c                 move.l     a4, -(a7)
0b32: a9aa                 dc.w       $a9aa
0b34: 4267                 clr.w      -(a7)
0b36: a994                 dc.w       $a994
0b38: a999                 dc.w       $a999
0b3a: 204c                 movea.l    a4, a0
0b3c: a064                 dc.w       $a064
0b3e: 204c                 movea.l    a4, a0
0b40: a029                 dc.w       $a029
0b42: 2654                 movea.l    (a4), a3
0b44: 2f0c                 move.l     a4, -(a7)
0b46: a992                 dc.w       $a992
0b48: 7e00                 moveq      #$0, d7
0b4a: 99cc                 suba.l     a4, a4
0b4c: 6012                 bra.b      $b60
0b4e: 204b                 movea.l    a3, a0
0b50: d1cc                 adda.l     a4, a0
0b52: 2f08                 move.l     a0, -(a7)
0b54: 4ead09ea             jsr        $9ea(a5) ; CODE35+016c
0b58: 588f                 addq.l     #$4, a7
0b5a: 5247                 addq.w     #$1, d7
0b5c: 49ec001c             lea.l      $1c(a4), a4
0b60: bc47                 cmp.w      d7, d6
0b62: 6eea                 bgt.b      $b4e
0b64: 200b                 move.l     a3, d0
0b66: 4cdf18c0             movem.l    (a7)+, d6-d7/a3-a4
0b6a: 4e5e                 unlk       a6
0b6c: 4e75                 rts        
0b6e: 4e56fffc             link.w     a6, #$fffc
0b72: 48e70708             movem.l    d5-d7/a4, -(a7)
0b76: 4267                 clr.w      -(a7)
0b78: 2f2e0008             move.l     $8(a6), -(a7)
0b7c: a997                 dc.w       $a997
0b7e: 3e1f                 move.w     (a7)+, d7
0b80: 4a47                 tst.w      d7
0b82: 6c04                 bge.b      $b88
0b84: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0b88: 42a7                 clr.l      -(a7)
0b8a: 2f3c45535452         move.l     #$45535452, -(a7)
0b90: 4267                 clr.w      -(a7)
0b92: a9a0                 dc.w       $a9a0
0b94: 285f                 movea.l    (a7)+, a4
0b96: 200c                 move.l     a4, d0
0b98: 6604                 bne.b      $b9e
0b9a: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0b9e: 204c                 movea.l    a4, a0
0ba0: a064                 dc.w       $a064
0ba2: 204c                 movea.l    a4, a0
0ba4: a029                 dc.w       $a029
0ba6: 2b54d560             move.l     (a4), -$2aa0(a5)
0baa: 2f0c                 move.l     a4, -(a7)
0bac: a992                 dc.w       $a992
0bae: 42a7                 clr.l      -(a7)
0bb0: 2f3c50415442         move.l     #$50415442, -(a7)
0bb6: 4267                 clr.w      -(a7)
0bb8: a9a0                 dc.w       $a9a0
0bba: 285f                 movea.l    (a7)+, a4
0bbc: 200c                 move.l     a4, d0
0bbe: 6604                 bne.b      $bc4
0bc0: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0bc4: 204c                 movea.l    a4, a0
0bc6: a064                 dc.w       $a064
0bc8: 204c                 movea.l    a4, a0
0bca: a029                 dc.w       $a029
0bcc: 2b54d55a             move.l     (a4), -$2aa6(a5)
0bd0: 2f0c                 move.l     a4, -(a7)
0bd2: a992                 dc.w       $a992
0bd4: 42a7                 clr.l      -(a7)
0bd6: 2f0c                 move.l     a4, -(a7)
0bd8: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
0bdc: 201f                 move.l     (a7)+, d0
0bde: e688                 lsr.l      #$3, d0
0be0: 3b40d55e             move.w     d0, -$2aa2(a5)
0be4: 426dd5f8             clr.w      -$2a08(a5)
0be8: 7c00                 moveq      #$0, d6
0bea: 99cc                 suba.l     a4, a4
0bec: 6016                 bra.b      $c04
0bee: 202dd55a             move.l     -$2aa6(a5), d0
0bf2: 3a340804             move.w     $4(a4, d0.l), d5
0bf6: ba6dd5f8             cmp.w      -$2a08(a5), d5
0bfa: 6f04                 ble.b      $c00
0bfc: 3b45d5f8             move.w     d5, -$2a08(a5)
0c00: 5246                 addq.w     #$1, d6
0c02: 508c                 addq.l     #$8, a4
0c04: bc6dd55e             cmp.w      -$2aa2(a5), d6
0c08: 6de4                 blt.b      $bee
0c0a: 526dd5f8             addq.w     #$1, -$2a08(a5)
0c0e: 3f2dd5f8             move.w     -$2a08(a5), -(a7)
0c12: 2f3c45585052         move.l     #$45585052, -(a7)
0c18: 4ebafe8e             jsr        $aa8(pc)
0c1c: 2b40d564             move.l     d0, -$2a9c(a5)
0c20: 3ebc0008             move.w     #$8, (a7)
0c24: 2f3c46525354         move.l     #$46525354, -(a7)
0c2a: 4ebafe7c             jsr        $aa8(pc)
0c2e: 2b40d568             move.l     d0, -$2a98(a5)
0c32: 7c00                 moveq      #$0, d6
0c34: 49edd56c             lea.l      -$2a94(a5), a4
0c38: 4fef000a             lea.l      $a(a7), a7
0c3c: 601a                 bra.b      $c58
0c3e: 3f3c0008             move.w     #$8, -(a7)
0c42: 3046                 movea.w    d6, a0
0c44: d1fc56434261         adda.l     #$56434261, a0
0c4a: 2f08                 move.l     a0, -(a7)
0c4c: 4ebafe5a             jsr        $aa8(pc)
0c50: 2880                 move.l     d0, (a4)
0c52: 5c8f                 addq.l     #$6, a7
0c54: 5246                 addq.w     #$1, d6
0c56: 588c                 addq.l     #$4, a4
0c58: 0c460008             cmpi.w     #$8, d6
0c5c: 65e0                 bcs.b      $c3e
0c5e: 7c00                 moveq      #$0, d6
0c60: 49edd58c             lea.l      -$2a74(a5), a4
0c64: 6024                 bra.b      $c8a
0c66: 3f3c0008             move.w     #$8, -(a7)
0c6a: 206d99d2             movea.l    -$662e(a5), a0
0c6e: 10306000             move.b     (a0, d6.w), d0
0c72: 4880                 ext.w      d0
0c74: 3240                 movea.w    d0, a1
0c76: d3fc4d554c00         adda.l     #$4d554c00, a1
0c7c: 2f09                 move.l     a1, -(a7)
0c7e: 4ebafe28             jsr        $aa8(pc)
0c82: 2880                 move.l     d0, (a4)
0c84: 5c8f                 addq.l     #$6, a7
0c86: 5246                 addq.w     #$1, d6
0c88: 588c                 addq.l     #$4, a4
0c8a: 0c46001b             cmpi.w     #$1b, d6
0c8e: 65d6                 bcs.b      $c66
0c90: 202e0008             move.l     $8(a6), d0
0c94: b0bc00000910         cmp.l      #$910, d0
0c9a: 6704                 beq.b      $ca0
0c9c: 3f07                 move.w     d7, -(a7)
0c9e: a99a                 dc.w       $a99a
0ca0: 4cdf10e0             movem.l    (a7)+, d5-d7/a4
0ca4: 4e5e                 unlk       a6
0ca6: 4e75                 rts        
0ca8: 4e56fffa             link.w     a6, #$fffa
0cac: 2038020c             move.l     $20c.w, d0
0cb0: b0ae0008             cmp.l      $8(a6), d0
0cb4: 6404                 bcc.b      $cba
0cb6: 7000                 moveq      #$0, d0
0cb8: 6002                 bra.b      $cbc
0cba: 7001                 moveq      #$1, d0
0cbc: 4e5e                 unlk       a6
0cbe: 4e75                 rts        
0cc0: 2f07                 move.l     d7, -(a7)
0cc2: 7e00                 moveq      #$0, d7
0cc4: 6004                 bra.b      $cca
0cc6: a036                 dc.w       $a036
0cc8: 5247                 addq.w     #$1, d7
0cca: 0c470004             cmpi.w     #$4, d7
0cce: 6df6                 blt.b      $cc6
0cd0: 486dfaca             pea.l      -$536(a5)
0cd4: a86e                 dc.w       $a86e
0cd6: a8fe                 dc.w       $a8fe
0cd8: a912                 dc.w       $a912
0cda: a930                 dc.w       $a930
0cdc: a9cc                 dc.w       $a9cc
0cde: 42a7                 clr.l      -(a7)
0ce0: a97b                 dc.w       $a97b
0ce2: 4267                 clr.w      -(a7)
0ce4: 3f3c0001             move.w     #$1, -(a7)
0ce8: 486df260             pea.l      -$da0(a5)
0cec: 4ead0be2             jsr        $be2(a5) ; CODE34+003a
0cf0: a850                 dc.w       $a850
0cf2: 4ead0622             jsr        $622(a5) ; CODE9+0c5e
0cf6: 42a7                 clr.l      -(a7)
0cf8: 3f3c0001             move.w     #$1, -(a7)
0cfc: a9b9                 dc.w       $a9b9
0cfe: 205f                 movea.l    (a7)+, a0
0d00: 2050                 movea.l    (a0), a0
0d02: 43edf278             lea.l      -$d88(a5), a1
0d06: 7010                 moveq      #$10, d0
0d08: 22d8                 move.l     (a0)+, (a1)+
0d0a: 51c8fffc             dbra       d0, $d08
0d0e: 42a7                 clr.l      -(a7)
0d10: 3f3c0004             move.w     #$4, -(a7)
0d14: a9b9                 dc.w       $a9b9
0d16: 205f                 movea.l    (a7)+, a0
0d18: 2050                 movea.l    (a0), a0
0d1a: 43edf2bc             lea.l      -$d44(a5), a1
0d1e: 7010                 moveq      #$10, d0
0d20: 22d8                 move.l     (a0)+, (a1)+
0d22: 51c8fffc             dbra       d0, $d20
0d26: 2f3c0000ffff         move.l     #$ffff, -(a7)
0d2c: 201f                 move.l     (a7)+, d0
0d2e: a032                 dc.w       $a032
0d30: 70ff                 moveq      #$ff, d0
0d32: 31c00144             move.w     d0, $144.w
0d36: 4257                 clr.w      (a7)
0d38: 42a7                 clr.l      -(a7)
0d3a: 486df270             pea.l      -$d90(a5)
0d3e: 4ead0b42             jsr        $b42(a5) ; CODE34+02aa
0d42: 1ebc0001             move.b     #$1, (a7)
0d46: a993                 dc.w       $a993
0d48: 2e1f                 move.l     (a7)+, d7
0d4a: 4e75                 rts        
0d4c: 4e56ffd6             link.w     a6, #$ffd6
0d50: 2f07                 move.l     d7, -(a7)
0d52: 7001                 moveq      #$1, d0
0d54: 2d40ffdc             move.l     d0, -$24(a6)
0d58: 4267                 clr.w      -(a7)
0d5a: 2f2e0008             move.l     $8(a6), -(a7)
0d5e: 3f2e000c             move.w     $c(a6), -(a7)
0d62: 486effda             pea.l      -$26(a6)
0d66: 4ead0b1a             jsr        $b1a(a5) ; CODE34+01d2
0d6a: 4a5f                 tst.w      (a7)+
0d6c: 6704                 beq.b      $d72
0d6e: 7001                 moveq      #$1, d0
0d70: 607c                 bra.b      $dee
0d72: 4267                 clr.w      -(a7)
0d74: 3f2effda             move.w     -$26(a6), -(a7)
0d78: 486effd6             pea.l      -$2a(a6)
0d7c: 4ead0b62             jsr        $b62(a5) ; CODE34+0364
0d80: 4a5f                 tst.w      (a7)+
0d82: 6704                 beq.b      $d88
0d84: 7001                 moveq      #$1, d0
0d86: 6066                 bra.b      $dee
0d88: 4267                 clr.w      -(a7)
0d8a: 3f2effda             move.w     -$26(a6), -(a7)
0d8e: 486effdc             pea.l      -$24(a6)
0d92: 486effe0             pea.l      -$20(a6)
0d96: 4ead0b2a             jsr        $b2a(a5) ; CODE34+022c
0d9a: 3e1f                 move.w     (a7)+, d7
0d9c: 4a47                 tst.w      d7
0d9e: 670a                 beq.b      $daa
0da0: 0c47ffd9             cmpi.w     #$ffd9, d7
0da4: 6704                 beq.b      $daa
0da6: 7001                 moveq      #$1, d0
0da8: 6044                 bra.b      $dee
0daa: 4267                 clr.w      -(a7)
0dac: 3f2effda             move.w     -$26(a6), -(a7)
0db0: 486effdc             pea.l      -$24(a6)
0db4: 486effe0             pea.l      -$20(a6)
0db8: 4ead0b32             jsr        $b32(a5) ; CODE34+0230
0dbc: 4a5f                 tst.w      (a7)+
0dbe: 6704                 beq.b      $dc4
0dc0: 7001                 moveq      #$1, d0
0dc2: 602a                 bra.b      $dee
0dc4: 4267                 clr.w      -(a7)
0dc6: 3f2effda             move.w     -$26(a6), -(a7)
0dca: 2f2effd6             move.l     -$2a(a6), -(a7)
0dce: 4ead0b6a             jsr        $b6a(a5) ; CODE34+0386
0dd2: 4a5f                 tst.w      (a7)+
0dd4: 6704                 beq.b      $dda
0dd6: 7001                 moveq      #$1, d0
0dd8: 6014                 bra.b      $dee
0dda: 4267                 clr.w      -(a7)
0ddc: 3f2effda             move.w     -$26(a6), -(a7)
0de0: 4ead0b22             jsr        $b22(a5) ; CODE34+0212
0de4: 4a5f                 tst.w      (a7)+
0de6: 6704                 beq.b      $dec
0de8: 7001                 moveq      #$1, d0
0dea: 6002                 bra.b      $dee
0dec: 7000                 moveq      #$0, d0
0dee: 2e1f                 move.l     (a7)+, d7
0df0: 4e5e                 unlk       a6
0df2: 4e75                 rts        
