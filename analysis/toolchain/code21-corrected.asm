0004: 4e560000             link.w     a6, #$0
0008: 48e70338             movem.l    d6-d7/a2-a4, -(a7)
000c: 2f2e0008             move.l     $8(a6), -(a7)
0010: 4ead096a             jsr        $96a(a5) ; CODE31+0992
0014: 266e0008             movea.l    $8(a6), a3
0018: 206dde78             movea.l    -$2188(a5), a0
001c: 2850                 movea.l    (a0), a4
001e: 49ec0312             lea.l      $312(a4), a4
0022: 588f                 addq.l     #$4, a7
0024: 601a                 bra.b      $40
0026: 7c00                 moveq      #$0, d6
0028: 45eda54e             lea.l      -$5ab2(a5), a2
002c: d4c7                 adda.w     d7, a2
002e: 6006                 bra.b      $36
0030: 1687                 move.b     d7, (a3)
0032: 5246                 addq.w     #$1, d6
0034: 528b                 addq.l     #$1, a3
0036: 1012                 move.b     (a2), d0
0038: 4880                 ext.w      d0
003a: b046                 cmp.w      d6, d0
003c: 6ef2                 bgt.b      $30
003e: 528c                 addq.l     #$1, a4
0040: 1e14                 move.b     (a4), d7
0042: 4887                 ext.w      d7
0044: 4a47                 tst.w      d7
0046: 66de                 bne.b      $26
0048: 4213                 clr.b      (a3)
004a: 4cdf1cc0             movem.l    (a7)+, d6-d7/a2-a4
004e: 4e5e                 unlk       a6
0050: 4e75                 rts        
0052: 4e56fffc             link.w     a6, #$fffc
0056: 48e70738             movem.l    d5-d7/a2-a4, -(a7)
005a: 486dc366             pea.l      -$3c9a(a5)
005e: 4ebaffa4             jsr        $4(pc)
0062: 7c00                 moveq      #$0, d6
0064: 49edde28             lea.l      -$21d8(a5), a4
0068: 588f                 addq.l     #$4, a7
006a: 6028                 bra.b      $94
006c: 486dc366             pea.l      -$3c9a(a5)
0070: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
0074: 3046                 movea.w    d6, a0
0076: b088                 cmp.l      a0, d0
0078: 588f                 addq.l     #$4, a7
007a: 6204                 bhi.b      $80
007c: 4254                 clr.w      (a4)
007e: 600c                 bra.b      $8c
0080: 204d                 movea.l    a5, a0
0082: d0c6                 adda.w     d6, a0
0084: 1028c366             move.b     -$3c9a(a0), d0
0088: 4880                 ext.w      d0
008a: 3880                 move.w     d0, (a4)
008c: 426c0002             clr.w      $2(a4)
0090: 5246                 addq.w     #$1, d6
0092: 588c                 addq.l     #$4, a4
0094: 0c460007             cmpi.w     #$7, d6
0098: 6dd2                 blt.b      $6c
009a: 426dde44             clr.w      -$21bc(a5)
009e: 4eba0b4a             jsr        $bea(pc)
00a2: 7c01                 moveq      #$1, d6
00a4: 49edd77d             lea.l      -$2883(a5), a4
00a8: 47edd89e             lea.l      -$2762(a5), a3
00ac: 6038                 bra.b      $e6
00ae: 7a01                 moveq      #$1, d5
00b0: 244b                 movea.l    a3, a2
00b2: 2e0c                 move.l     a4, d7
00b4: 6020                 bra.b      $d6
00b6: 3045                 movea.w    d5, a0
00b8: 10325000             move.b     (a2, d5.w), d0
00bc: b0307800             cmp.b      (a0, d7.l), d0
00c0: 6712                 beq.b      $d4
00c2: 3045                 movea.w    d5, a0
00c4: 11b250007800         move.b     (a2, d5.w), (a0, d7.l)
00ca: 3f05                 move.w     d5, -(a7)
00cc: 3f06                 move.w     d6, -(a7)
00ce: 4ead03da             jsr        $3da(a5) ; CODE20+0648
00d2: 588f                 addq.l     #$4, a7
00d4: 5245                 addq.w     #$1, d5
00d6: 0c450010             cmpi.w     #$10, d5
00da: 6dda                 blt.b      $b6
00dc: 5246                 addq.w     #$1, d6
00de: 49ec0011             lea.l      $11(a4), a4
00e2: 47eb0011             lea.l      $11(a3), a3
00e6: 0c460010             cmpi.w     #$10, d6
00ea: 6dc2                 blt.b      $ae
00ec: 4ead03c2             jsr        $3c2(a5) ; CODE20+0cfa
00f0: 4eba080c             jsr        $8fe(pc)
00f4: 4cdf1ce0             movem.l    (a7)+, d5-d7/a2-a4
00f8: 4e5e                 unlk       a6
00fa: 4e75                 rts        
00fc: 4e56ffea             link.w     a6, #$ffea
0100: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0104: 362e000c             move.w     $c(a6), d3
0108: 4a6dd9ae             tst.w      -$2652(a5)
010c: 66000326             bne.w      $434
0110: 7011                 moveq      #$11, d0
0112: c1ee0008             muls.w     $8(a6), d0
0116: d08d                 add.l      a5, d0
0118: 386e000a             movea.w    $a(a6), a4
011c: 49ecd88d             lea.l      -$2773(a4), a4
0120: d08c                 add.l      a4, d0
0122: 2840                 movea.l    d0, a4
0124: 4a14                 tst.b      (a4)
0126: 6722                 beq.b      $14a
0128: 1014                 move.b     (a4), d0
012a: 4880                 ext.w      d0
012c: 3f00                 move.w     d0, -(a7)
012e: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
0132: 3d40ffea             move.w     d0, -$16(a6)
0136: 3e83                 move.w     d3, (a7)
0138: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
013c: b06effea             cmp.w      -$16(a6), d0
0140: 548f                 addq.l     #$2, a7
0142: 6706                 beq.b      $14a
0144: 7000                 moveq      #$0, d0
0146: 6000030c             bra.w      $454
014a: 3f03                 move.w     d3, -(a7)
014c: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
0150: 7211                 moveq      #$11, d1
0152: c3ee0008             muls.w     $8(a6), d1
0156: d28d                 add.l      a5, d1
0158: 306e000a             movea.w    $a(a6), a0
015c: d1c1                 adda.l     d1, a0
015e: 1228d76c             move.b     -$2894(a0), d1
0162: 4881                 ext.w      d1
0164: b041                 cmp.w      d1, d0
0166: 548f                 addq.l     #$2, a7
0168: 660a                 bne.b      $174
016a: 3f03                 move.w     d3, -(a7)
016c: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
0170: 3600                 move.w     d0, d3
0172: 548f                 addq.l     #$2, a7
0174: 486dc366             pea.l      -$3c9a(a5)
0178: 4ead096a             jsr        $96a(a5) ; CODE31+0992
017c: 426efff2             clr.w      -$e(a6)
0180: 7e00                 moveq      #$0, d7
0182: 3d47fff4             move.w     d7, -$c(a6)
0186: 3c07                 move.w     d7, d6
0188: 7801                 moveq      #$1, d4
018a: 49edd89e             lea.l      -$2762(a5), a4
018e: 47edd77d             lea.l      -$2883(a5), a3
0192: 588f                 addq.l     #$4, a7
0194: 600000ae             bra.w      $244
0198: 7a01                 moveq      #$1, d5
019a: 2d4bfffa             move.l     a3, -$6(a6)
019e: 2d4cfff6             move.l     a4, -$a(a6)
01a2: 6000008e             bra.w      $232
01a6: 206efffa             movea.l    -$6(a6), a0
01aa: 226efff6             movea.l    -$a(a6), a1
01ae: 10305000             move.b     (a0, d5.w), d0
01b2: b0315000             cmp.b      (a1, d5.w), d0
01b6: 6778                 beq.b      $230
01b8: 2d4cfff6             move.l     a4, -$a(a6)
01bc: 206efff6             movea.l    -$a(a6), a0
01c0: 4a305000             tst.b      (a0, d5.w)
01c4: 6704                 beq.b      $1ca
01c6: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
01ca: 3445                 movea.w    d5, a2
01cc: d5cb                 adda.l     a3, a2
01ce: 2d4bfffa             move.l     a3, -$6(a6)
01d2: 7000                 moveq      #$0, d0
01d4: 1012                 move.b     (a2), d0
01d6: 204d                 movea.l    a5, a0
01d8: d1c0                 adda.l     d0, a0
01da: 4a28fbd8             tst.b      -$428(a0)
01de: 6a0c                 bpl.b      $1ec
01e0: 4a2da58d             tst.b      -$5a73(a5)
01e4: 674a                 beq.b      $230
01e6: 532da58d             subq.b     #$1, -$5a73(a5)
01ea: 6044                 bra.b      $230
01ec: 1012                 move.b     (a2), d0
01ee: 4880                 ext.w      d0
01f0: 3f00                 move.w     d0, -(a7)
01f2: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
01f6: 3d40ffec             move.w     d0, -$14(a6)
01fa: 204d                 movea.l    a5, a0
01fc: d0c0                 adda.w     d0, a0
01fe: 4a28a54e             tst.b      -$5ab2(a0)
0202: 548f                 addq.l     #$2, a7
0204: 670c                 beq.b      $212
0206: 204d                 movea.l    a5, a0
0208: d0eeffec             adda.w     -$14(a6), a0
020c: 5328a54e             subq.b     #$1, -$5ab2(a0)
0210: 601e                 bra.b      $230
0212: 4a2da58d             tst.b      -$5a73(a5)
0216: 6712                 beq.b      $22a
0218: 532da58d             subq.b     #$1, -$5a73(a5)
021c: 3d46fff4             move.w     d6, -$c(a6)
0220: 3c04                 move.w     d4, d6
0222: 3d47fff2             move.w     d7, -$e(a6)
0226: 3e05                 move.w     d5, d7
0228: 6006                 bra.b      $230
022a: 7000                 moveq      #$0, d0
022c: 60000226             bra.w      $454
0230: 5245                 addq.w     #$1, d5
0232: 0c450010             cmpi.w     #$10, d5
0236: 6d00ff6e             blt.w      $1a6
023a: 5244                 addq.w     #$1, d4
023c: 49ec0011             lea.l      $11(a4), a4
0240: 47eb0011             lea.l      $11(a3), a3
0244: 0c440010             cmpi.w     #$10, d4
0248: 6d00ff4e             blt.w      $198
024c: 4a43                 tst.w      d3
024e: 663e                 bne.b      $28e
0250: 7011                 moveq      #$11, d0
0252: c1ee0008             muls.w     $8(a6), d0
0256: d08d                 add.l      a5, d0
0258: 386e000a             movea.w    $a(a6), a4
025c: 49ecd76c             lea.l      -$2894(a4), a4
0260: d08c                 add.l      a4, d0
0262: 2840                 movea.l    d0, a4
0264: 7000                 moveq      #$0, d0
0266: 1014                 move.b     (a4), d0
0268: 204d                 movea.l    a5, a0
026a: d1c0                 adda.l     d0, a0
026c: 4a28fbd8             tst.b      -$428(a0)
0270: 6a04                 bpl.b      $276
0272: 703f                 moveq      #$3f, d0
0274: 600c                 bra.b      $282
0276: 1014                 move.b     (a4), d0
0278: 4880                 ext.w      d0
027a: 3f00                 move.w     d0, -(a7)
027c: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
0280: 548f                 addq.l     #$2, a7
0282: 204d                 movea.l    a5, a0
0284: d0c0                 adda.w     d0, a0
0286: 5228a54e             addq.b     #$1, -$5ab2(a0)
028a: 600000e6             bra.w      $372
028e: 7011                 moveq      #$11, d0
0290: c1ee0008             muls.w     $8(a6), d0
0294: d08d                 add.l      a5, d0
0296: 306e000a             movea.w    $a(a6), a0
029a: d1c0                 adda.l     d0, a0
029c: 1828d76c             move.b     -$2894(a0), d4
02a0: 7011                 moveq      #$11, d0
02a2: c1ee0008             muls.w     $8(a6), d0
02a6: d08d                 add.l      a5, d0
02a8: 386e000a             movea.w    $a(a6), a4
02ac: 49ecd76c             lea.l      -$2894(a4), a4
02b0: d08c                 add.l      a4, d0
02b2: 2840                 movea.l    d0, a4
02b4: 4a04                 tst.b      d4
02b6: 6726                 beq.b      $2de
02b8: 7000                 moveq      #$0, d0
02ba: 1004                 move.b     d4, d0
02bc: 204d                 movea.l    a5, a0
02be: d1c0                 adda.l     d0, a0
02c0: 4a28fbd8             tst.b      -$428(a0)
02c4: 6a04                 bpl.b      $2ca
02c6: 703f                 moveq      #$3f, d0
02c8: 600c                 bra.b      $2d6
02ca: 1014                 move.b     (a4), d0
02cc: 4880                 ext.w      d0
02ce: 3f00                 move.w     d0, -(a7)
02d0: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
02d4: 548f                 addq.l     #$2, a7
02d6: 204d                 movea.l    a5, a0
02d8: d0c0                 adda.w     d0, a0
02da: 5228a54e             addq.b     #$1, -$5ab2(a0)
02de: 7000                 moveq      #$0, d0
02e0: 1003                 move.b     d3, d0
02e2: 204d                 movea.l    a5, a0
02e4: d1c0                 adda.l     d0, a0
02e6: 4a28fbd8             tst.b      -$428(a0)
02ea: 6a28                 bpl.b      $314
02ec: 4a2da58d             tst.b      -$5a73(a5)
02f0: 6622                 bne.b      $314
02f2: 3f03                 move.w     d3, -(a7)
02f4: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
02f8: 204d                 movea.l    a5, a0
02fa: d0c0                 adda.w     d0, a0
02fc: 4a28a54e             tst.b      -$5ab2(a0)
0300: 548f                 addq.l     #$2, a7
0302: 6606                 bne.b      $30a
0304: 7000                 moveq      #$0, d0
0306: 6000014c             bra.w      $454
030a: 3f03                 move.w     d3, -(a7)
030c: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
0310: 3600                 move.w     d0, d3
0312: 548f                 addq.l     #$2, a7
0314: 7000                 moveq      #$0, d0
0316: 1003                 move.b     d3, d0
0318: 204d                 movea.l    a5, a0
031a: d1c0                 adda.l     d0, a0
031c: 4a28fbd8             tst.b      -$428(a0)
0320: 6a0c                 bpl.b      $32e
0322: 4a2da58d             tst.b      -$5a73(a5)
0326: 674a                 beq.b      $372
0328: 532da58d             subq.b     #$1, -$5a73(a5)
032c: 6044                 bra.b      $372
032e: 3f03                 move.w     d3, -(a7)
0330: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
0334: 3d40ffec             move.w     d0, -$14(a6)
0338: 204d                 movea.l    a5, a0
033a: d0c0                 adda.w     d0, a0
033c: 4a28a54e             tst.b      -$5ab2(a0)
0340: 548f                 addq.l     #$2, a7
0342: 670c                 beq.b      $350
0344: 204d                 movea.l    a5, a0
0346: d0eeffec             adda.w     -$14(a6), a0
034a: 5328a54e             subq.b     #$1, -$5ab2(a0)
034e: 6022                 bra.b      $372
0350: 4a2da58d             tst.b      -$5a73(a5)
0354: 6716                 beq.b      $36c
0356: 532da58d             subq.b     #$1, -$5a73(a5)
035a: 3d46fff4             move.w     d6, -$c(a6)
035e: 3c2e0008             move.w     $8(a6), d6
0362: 3d47fff2             move.w     d7, -$e(a6)
0366: 3e2e000a             move.w     $a(a6), d7
036a: 6006                 bra.b      $372
036c: 7000                 moveq      #$0, d0
036e: 600000e4             bra.w      $454
0372: 1883                 move.b     d3, (a4)
0374: 7011                 moveq      #$11, d0
0376: c1c6                 muls.w     d6, d0
0378: 49edd76c             lea.l      -$2894(a5), a4
037c: d08c                 add.l      a4, d0
037e: 3847                 movea.w    d7, a4
0380: d08c                 add.l      a4, d0
0382: 2840                 movea.l    d0, a4
0384: 1014                 move.b     (a4), d0
0386: 4880                 ext.w      d0
0388: 3f00                 move.w     d0, -(a7)
038a: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
038e: 1880                 move.b     d0, (a4)
0390: 3e87                 move.w     d7, (a7)
0392: 3f06                 move.w     d6, -(a7)
0394: 4ead03da             jsr        $3da(a5) ; CODE20+0648
0398: 7011                 moveq      #$11, d0
039a: c1eefff4             muls.w     -$c(a6), d0
039e: d08d                 add.l      a5, d0
03a0: 386efff2             movea.w    -$e(a6), a4
03a4: 49ecd76c             lea.l      -$2894(a4), a4
03a8: d08c                 add.l      a4, d0
03aa: 2840                 movea.l    d0, a4
03ac: 1014                 move.b     (a4), d0
03ae: 4880                 ext.w      d0
03b0: 3e80                 move.w     d0, (a7)
03b2: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
03b6: 1880                 move.b     d0, (a4)
03b8: 3eaefff2             move.w     -$e(a6), (a7)
03bc: 3f2efff4             move.w     -$c(a6), -(a7)
03c0: 4ead03da             jsr        $3da(a5) ; CODE20+0648
03c4: 4a6e0010             tst.w      $10(a6)
03c8: 5c8f                 addq.l     #$6, a7
03ca: 673c                 beq.b      $408
03cc: 7800                 moveq      #$0, d4
03ce: 49edde28             lea.l      -$21d8(a5), a4
03d2: 3614                 move.w     (a4), d3
03d4: 4a43                 tst.w      d3
03d6: 6730                 beq.b      $408
03d8: 3d43ffec             move.w     d3, -$14(a6)
03dc: 45eda54e             lea.l      -$5ab2(a5), a2
03e0: d4eeffec             adda.w     -$14(a6), a2
03e4: 4a12                 tst.b      (a2)
03e6: 660e                 bne.b      $3f6
03e8: 3f3c0001             move.w     #$1, -(a7)
03ec: 3f04                 move.w     d4, -(a7)
03ee: 4eba01a8             jsr        $598(pc)
03f2: 588f                 addq.l     #$4, a7
03f4: 600c                 bra.b      $402
03f6: 5312                 subq.b     #$1, (a2)
03f8: 4267                 clr.w      -(a7)
03fa: 3f04                 move.w     d4, -(a7)
03fc: 4eba019a             jsr        $598(pc)
0400: 588f                 addq.l     #$4, a7
0402: 5244                 addq.w     #$1, d4
0404: 588c                 addq.l     #$4, a4
0406: 60ca                 bra.b      $3d2
0408: 4a6e000e             tst.w      $e(a6)
040c: 6738                 beq.b      $446
040e: 4267                 clr.w      -(a7)
0410: 4ead017a             jsr        $17a(a5) ; CODE8+0374
0414: 4a40                 tst.w      d0
0416: 548f                 addq.l     #$2, a7
0418: 670a                 beq.b      $424
041a: 486da5ce             pea.l      -$5a32(a5)
041e: 4ead02fa             jsr        $2fa(a5) ; CODE14+0186
0422: 588f                 addq.l     #$4, a7
0424: 48780022             pea.l      $22.w
0428: 486da5ce             pea.l      -$5a32(a5)
042c: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0430: 508f                 addq.l     #$8, a7
0432: 6012                 bra.b      $446
0434: 7011                 moveq      #$11, d0
0436: c1ee0008             muls.w     $8(a6), d0
043a: d08d                 add.l      a5, d0
043c: 306e000a             movea.w    $a(a6), a0
0440: d1c0                 adda.l     d0, a0
0442: 1143d76c             move.b     d3, -$2894(a0)
0446: 3f2e000a             move.w     $a(a6), -(a7)
044a: 3f2e0008             move.w     $8(a6), -(a7)
044e: 4ead03da             jsr        $3da(a5) ; CODE20+0648
0452: 7001                 moveq      #$1, d0
0454: 4cee1cf8ffca         movem.l    -$36(a6), d3-d7/a2-a4
045a: 4e5e                 unlk       a6
045c: 4e75                 rts        
045e: 4e560000             link.w     a6, #$0
0462: 48e70700             movem.l    d5-d7, -(a7)
0466: 3e2e0008             move.w     $8(a6), d7
046a: 3c2e000a             move.w     $a(a6), d6
046e: be6dde50             cmp.w      -$21b0(a5), d7
0472: 6606                 bne.b      $47a
0474: bc6dde52             cmp.w      -$21ae(a5), d6
0478: 672a                 beq.b      $4a4
047a: 3a2dde50             move.w     -$21b0(a5), d5
047e: 3b47de50             move.w     d7, -$21b0(a5)
0482: 3e05                 move.w     d5, d7
0484: 3a2dde52             move.w     -$21ae(a5), d5
0488: 3b46de52             move.w     d6, -$21ae(a5)
048c: 3c05                 move.w     d5, d6
048e: 3f06                 move.w     d6, -(a7)
0490: 3f07                 move.w     d7, -(a7)
0492: 4ead03da             jsr        $3da(a5) ; CODE20+0648
0496: 3eadde52             move.w     -$21ae(a5), (a7)
049a: 3f2dde50             move.w     -$21b0(a5), -(a7)
049e: 4ead03da             jsr        $3da(a5) ; CODE20+0648
04a2: 5c8f                 addq.l     #$6, a7
04a4: 4cdf00e0             movem.l    (a7)+, d5-d7
04a8: 4e5e                 unlk       a6
04aa: 4e75                 rts        
04ac: 4e56ff80             link.w     a6, #$ff80
04b0: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
04b4: 7c00                 moveq      #$0, d6
04b6: 48780080             pea.l      $80.w
04ba: 486d9512             pea.l      -$6aee(a5)
04be: 486eff80             pea.l      -$80(a6)
04c2: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
04c6: 7a01                 moveq      #$1, d5
04c8: 49edd89e             lea.l      -$2762(a5), a4
04cc: 47edd77d             lea.l      -$2883(a5), a3
04d0: 4fef000c             lea.l      $c(a7), a7
04d4: 6050                 bra.b      $526
04d6: 7801                 moveq      #$1, d4
04d8: 244b                 movea.l    a3, a2
04da: 2e0c                 move.l     a4, d7
04dc: 6038                 bra.b      $516
04de: 16324000             move.b     (a2, d4.w), d3
04e2: 4883                 ext.w      d3
04e4: 4a43                 tst.w      d3
04e6: 672c                 beq.b      $514
04e8: 3044                 movea.w    d4, a0
04ea: 10307800             move.b     (a0, d7.l), d0
04ee: 4880                 ext.w      d0
04f0: b640                 cmp.w      d0, d3
04f2: 6620                 bne.b      $514
04f4: 7000                 moveq      #$0, d0
04f6: 1003                 move.b     d3, d0
04f8: 204d                 movea.l    a5, a0
04fa: d1c0                 adda.l     d0, a0
04fc: 4a28fbd8             tst.b      -$428(a0)
0500: 6a06                 bpl.b      $508
0502: 532effbf             subq.b     #$1, -$41(a6)
0506: 600c                 bra.b      $514
0508: 3f03                 move.w     d3, -(a7)
050a: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
050e: 53360080             subq.b     #$1, -$80(a6, d0.w)
0512: 548f                 addq.l     #$2, a7
0514: 5244                 addq.w     #$1, d4
0516: 0c440010             cmpi.w     #$10, d4
051a: 6dc2                 blt.b      $4de
051c: 5245                 addq.w     #$1, d5
051e: 49ec0011             lea.l      $11(a4), a4
0522: 47eb0011             lea.l      $11(a3), a3
0526: 0c450010             cmpi.w     #$10, d5
052a: 6daa                 blt.b      $4d6
052c: 7a00                 moveq      #$0, d5
052e: 49edde28             lea.l      -$21d8(a5), a4
0532: 600a                 bra.b      $53e
0534: 3014                 move.w     (a4), d0
0536: 53360080             subq.b     #$1, -$80(a6, d0.w)
053a: 5245                 addq.w     #$1, d5
053c: 588c                 addq.l     #$4, a4
053e: 4a54                 tst.w      (a4)
0540: 66f2                 bne.b      $534
0542: 206dde78             movea.l    -$2188(a5), a0
0546: 2850                 movea.l    (a0), a4
0548: 49ec0312             lea.l      $312(a4), a4
054c: 266e0008             movea.l    $8(a6), a3
0550: 6028                 bra.b      $57a
0552: 18363080             move.b     -$80(a6, d3.w), d4
0556: 4884                 ext.w      d4
0558: 4a44                 tst.w      d4
055a: 6f1c                 ble.b      $578
055c: 3f03                 move.w     d3, -(a7)
055e: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
0562: 3600                 move.w     d0, d3
0564: dc44                 add.w      d4, d6
0566: 7a00                 moveq      #$0, d5
0568: 548f                 addq.l     #$2, a7
056a: 6004                 bra.b      $570
056c: 16c3                 move.b     d3, (a3)+
056e: 5245                 addq.w     #$1, d5
0570: b845                 cmp.w      d5, d4
0572: 6ef8                 bgt.b      $56c
0574: 16fc0020             move.b     #$20, (a3)+
0578: 528c                 addq.l     #$1, a4
057a: 1614                 move.b     (a4), d3
057c: 4883                 ext.w      d3
057e: 4a43                 tst.w      d3
0580: 66d0                 bne.b      $552
0582: 3f06                 move.w     d6, -(a7)
0584: 486deeda             pea.l      -$1126(a5)
0588: 2f0b                 move.l     a3, -(a7)
058a: 4ead0812             jsr        $812(a5) ; CODE24+16a6
058e: 4cee1cf8ff60         movem.l    -$a0(a6), d3-d7/a2-a4
0594: 4e5e                 unlk       a6
0596: 4e75                 rts        
0598: 4e560000             link.w     a6, #$0
059c: 2f0c                 move.l     a4, -(a7)
059e: 49edde2a             lea.l      -$21d6(a5), a4
05a2: 302e0008             move.w     $8(a6), d0
05a6: 48c0                 ext.l      d0
05a8: e588                 lsl.l      #$2, d0
05aa: d08c                 add.l      a4, d0
05ac: 2840                 movea.l    d0, a4
05ae: 3014                 move.w     (a4), d0
05b0: b06e000a             cmp.w      $a(a6), d0
05b4: 670e                 beq.b      $5c4
05b6: 38ae000a             move.w     $a(a6), (a4)
05ba: 3f2e0008             move.w     $8(a6), -(a7)
05be: 4eba251a             jsr        $2ada(pc)
05c2: 548f                 addq.l     #$2, a7
05c4: 285f                 movea.l    (a7)+, a4
05c6: 4e5e                 unlk       a6
05c8: 4e75                 rts        
05ca: 4e560000             link.w     a6, #$0
05ce: 48e70118             movem.l    d7/a3-a4, -(a7)
05d2: 286e0008             movea.l    $8(a6), a4
05d6: 7e00                 moveq      #$0, d7
05d8: 47edde28             lea.l      -$21d8(a5), a3
05dc: 600e                 bra.b      $5ec
05de: 4a6b0002             tst.w      $2(a3)
05e2: 6604                 bne.b      $5e8
05e4: 18eb0001             move.b     $1(a3), (a4)+
05e8: 5247                 addq.w     #$1, d7
05ea: 588b                 addq.l     #$4, a3
05ec: 4a53                 tst.w      (a3)
05ee: 66ee                 bne.b      $5de
05f0: 4214                 clr.b      (a4)
05f2: 202e0008             move.l     $8(a6), d0
05f6: 4cdf1880             movem.l    (a7)+, d7/a3-a4
05fa: 4e5e                 unlk       a6
05fc: 4e75                 rts        
05fe: 4e560000             link.w     a6, #$0
0602: 48e70338             movem.l    d6-d7/a2-a4, -(a7)
0606: 286e0008             movea.l    $8(a6), a4
060a: 2f0c                 move.l     a4, -(a7)
060c: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
0610: 5f80                 subq.l     #$7, d0
0612: 588f                 addq.l     #$4, a7
0614: 6304                 bls.b      $61a
0616: 7000                 moveq      #$0, d0
0618: 6062                 bra.b      $67c
061a: 7e00                 moveq      #$0, d7
061c: 47edde28             lea.l      -$21d8(a5), a3
0620: 1c347000             move.b     (a4, d7.w), d6
0624: 3447                 movea.w    d7, a2
0626: d5cc                 adda.l     a4, a2
0628: 4a06                 tst.b      d6
062a: 6730                 beq.b      $65c
062c: 7000                 moveq      #$0, d0
062e: 1006                 move.b     d6, d0
0630: 204d                 movea.l    a5, a0
0632: d1c0                 adda.l     d0, a0
0634: 1028fbd8             move.b     -$428(a0), d0
0638: 020000c0             andi.b     #$c0, d0
063c: 660a                 bne.b      $648
063e: 0c06003f             cmpi.b     #$3f, d6
0642: 6704                 beq.b      $648
0644: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0648: 1012                 move.b     (a2), d0
064a: 4880                 ext.w      d0
064c: 3f00                 move.w     d0, -(a7)
064e: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
0652: 3680                 move.w     d0, (a3)
0654: 548f                 addq.l     #$2, a7
0656: 5247                 addq.w     #$1, d7
0658: 588b                 addq.l     #$4, a3
065a: 60c4                 bra.b      $620
065c: 3f3c03ff             move.w     #$3ff, -(a7)
0660: 4ead058a             jsr        $58a(a5) ; CODE22+04a8
0664: 4a40                 tst.w      d0
0666: 548f                 addq.l     #$2, a7
0668: 6604                 bne.b      $66e
066a: 7000                 moveq      #$0, d0
066c: 600e                 bra.b      $67c
066e: 42a7                 clr.l      -(a7)
0670: 2f0c                 move.l     a4, -(a7)
0672: 4ebaff56             jsr        $5ca(pc)
0676: 2e80                 move.l     d0, (a7)
0678: 4eba000c             jsr        $686(pc)
067c: 4cee1cc0ffec         movem.l    -$14(a6), d6-d7/a2-a4
0682: 4e5e                 unlk       a6
0684: 4e75                 rts        
0686: 4e56fef8             link.w     a6, #$fef8
068a: 48e70718             movem.l    d5-d7/a3-a4, -(a7)
068e: 48780100             pea.l      $100.w
0692: 486eff00             pea.l      -$100(a6)
0696: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
069a: 7e01                 moveq      #$1, d7
069c: 49edd77d             lea.l      -$2883(a5), a4
06a0: 508f                 addq.l     #$8, a7
06a2: 6058                 bra.b      $6fc
06a4: 7c01                 moveq      #$1, d6
06a6: 264c                 movea.l    a4, a3
06a8: 6046                 bra.b      $6f0
06aa: 1a336000             move.b     (a3, d6.w), d5
06ae: 4885                 ext.w      d5
06b0: 4a45                 tst.w      d5
06b2: 673a                 beq.b      $6ee
06b4: 4a2dd7fc             tst.b      -$2804(a5)
06b8: 660e                 bne.b      $6c8
06ba: 3f3c03e9             move.w     #$3e9, -(a7)
06be: 4ead0c6a             jsr        $c6a(a5) ; CODE41+010a
06c2: 7000                 moveq      #$0, d0
06c4: 600000da             bra.w      $7a0
06c8: 7000                 moveq      #$0, d0
06ca: 1005                 move.b     d5, d0
06cc: 204d                 movea.l    a5, a0
06ce: d1c0                 adda.l     d0, a0
06d0: 4a28fbd8             tst.b      -$428(a0)
06d4: 6a06                 bpl.b      $6dc
06d6: 526eff7e             addq.w     #$1, -$82(a6)
06da: 6012                 bra.b      $6ee
06dc: 3f05                 move.w     d5, -(a7)
06de: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
06e2: 204e                 movea.l    a6, a0
06e4: d0c0                 adda.w     d0, a0
06e6: d0c0                 adda.w     d0, a0
06e8: 5268ff00             addq.w     #$1, -$100(a0)
06ec: 548f                 addq.l     #$2, a7
06ee: 5246                 addq.w     #$1, d6
06f0: 0c460010             cmpi.w     #$10, d6
06f4: 6db4                 blt.b      $6aa
06f6: 5247                 addq.w     #$1, d7
06f8: 49ec0011             lea.l      $11(a4), a4
06fc: 0c470010             cmpi.w     #$10, d7
0700: 6da2                 blt.b      $6a4
0702: 4aae0008             tst.l      $8(a6)
0706: 660c                 bne.b      $714
0708: 601a                 bra.b      $724
070a: 204e                 movea.l    a6, a0
070c: d0c5                 adda.w     d5, a0
070e: d0c5                 adda.w     d5, a0
0710: 5268ff00             addq.w     #$1, -$100(a0)
0714: 206e0008             movea.l    $8(a6), a0
0718: 52ae0008             addq.l     #$1, $8(a6)
071c: 1a10                 move.b     (a0), d5
071e: 4885                 ext.w      d5
0720: 4a45                 tst.w      d5
0722: 66e6                 bne.b      $70a
0724: 4aae000c             tst.l      $c(a6)
0728: 660c                 bne.b      $736
072a: 601a                 bra.b      $746
072c: 204e                 movea.l    a6, a0
072e: d0c5                 adda.w     d5, a0
0730: d0c5                 adda.w     d5, a0
0732: 5268ff00             addq.w     #$1, -$100(a0)
0736: 206e000c             movea.l    $c(a6), a0
073a: 52ae000c             addq.l     #$1, $c(a6)
073e: 1a10                 move.b     (a0), d5
0740: 4885                 ext.w      d5
0742: 4a45                 tst.w      d5
0744: 66e6                 bne.b      $72c
0746: 286d99d2             movea.l    -$662e(a5), a4
074a: 604a                 bra.b      $796
074c: 204e                 movea.l    a6, a0
074e: d0c5                 adda.w     d5, a0
0750: d0c5                 adda.w     d5, a0
0752: 224d                 movea.l    a5, a1
0754: d2c5                 adda.w     d5, a1
0756: 10299512             move.b     -$6aee(a1), d0
075a: 4880                 ext.w      d0
075c: b068ff00             cmp.w      -$100(a0), d0
0760: 6c34                 bge.b      $796
0762: 1d45fef8             move.b     d5, -$108(a6)
0766: 422efef9             clr.b      -$107(a6)
076a: 0c45003f             cmpi.w     #$3f, d5
076e: 6708                 beq.b      $778
0770: 41eefef8             lea.l      -$108(a6), a0
0774: 2008                 move.l     a0, d0
0776: 6006                 bra.b      $77e
0778: 41edeede             lea.l      -$1122(a5), a0
077c: 2008                 move.l     a0, d0
077e: 2f00                 move.l     d0, -(a7)
0780: 4ead0c62             jsr        $c62(a5) ; CODE41+0004
0784: 3ebc03f1             move.w     #$3f1, (a7)
0788: 4ead0c6a             jsr        $c6a(a5) ; CODE41+010a
078c: 5340                 subq.w     #$1, d0
078e: 588f                 addq.l     #$4, a7
0790: 6704                 beq.b      $796
0792: 7000                 moveq      #$0, d0
0794: 600a                 bra.b      $7a0
0796: 1a1c                 move.b     (a4)+, d5
0798: 4885                 ext.w      d5
079a: 4a45                 tst.w      d5
079c: 66ae                 bne.b      $74c
079e: 7001                 moveq      #$1, d0
07a0: 4cee18e0fee4         movem.l    -$11c(a6), d5-d7/a3-a4
07a6: 4e5e                 unlk       a6
07a8: 4e75                 rts        
07aa: 4eba0b64             jsr        $1310(pc)
07ae: 4ead03c2             jsr        $3c2(a5) ; CODE20+0cfa
07b2: 4267                 clr.w      -(a7)
07b4: 4eba0c46             jsr        $13fc(pc)
07b8: 4eba03cc             jsr        $b86(pc)
07bc: 4eba0270             jsr        $a2e(pc)
07c0: 548f                 addq.l     #$2, a7
07c2: 4e75                 rts        
07c4: 4a6dd9ae             tst.w      -$2652(a5)
07c8: 670e                 beq.b      $7d8
07ca: 4ead043a             jsr        $43a(a5) ; CODE20+0194
07ce: 4ead03c2             jsr        $3c2(a5) ; CODE20+0cfa
07d2: 4eba001c             jsr        $7f0(pc)
07d6: 6012                 bra.b      $7ea
07d8: 4a6dde54             tst.w      -$21ac(a5)
07dc: 670c                 beq.b      $7ea
07de: 4eba1194             jsr        $1974(pc)
07e2: 3f00                 move.w     d0, -(a7)
07e4: 4ead0162             jsr        $162(a5) ; CODE7+0004
07e8: 548f                 addq.l     #$2, a7
07ea: 426dde54             clr.w      -$21ac(a5)
07ee: 4e75                 rts        
07f0: 426dd9ae             clr.w      -$2652(a5)
07f4: 4eba110a             jsr        $1900(pc)
07f8: 2f00                 move.l     d0, -(a7)
07fa: 4eba110c             jsr        $1908(pc)
07fe: 4eba10fa             jsr        $18fa(pc)
0802: 2b40de5a             move.l     d0, -$21a6(a5)
0806: 4eba106c             jsr        $1874(pc)
080a: 588f                 addq.l     #$4, a7
080c: 4e75                 rts        
080e: 48e70308             movem.l    d6-d7/a4, -(a7)
0812: 4eba288e             jsr        $30a2(pc)
0816: 4a40                 tst.w      d0
0818: 670e                 beq.b      $828
081a: 3f3c0001             move.w     #$1, -(a7)
081e: 4eba0106             jsr        $926(pc)
0822: 548f                 addq.l     #$2, a7
0824: 600000d2             bra.w      $8f8
0828: 4a6dd9ae             tst.w      -$2652(a5)
082c: 670000a8             beq.w      $8d6
0830: 4eba21ea             jsr        $2a1c(pc)
0834: 4a40                 tst.w      d0
0836: 670000c0             beq.w      $8f8
083a: 4a2dc366             tst.b      -$3c9a(a5)
083e: 6728                 beq.b      $868
0840: 4267                 clr.w      -(a7)
0842: 4ead017a             jsr        $17a(a5) ; CODE8+0374
0846: 4a40                 tst.w      d0
0848: 548f                 addq.l     #$2, a7
084a: 671c                 beq.b      $868
084c: 4a6dde54             tst.w      -$21ac(a5)
0850: 6616                 bne.b      $868
0852: 486da5ce             pea.l      -$5a32(a5)
0856: 3f3c7fff             move.w     #$7fff, -(a7)
085a: 4eba21a8             jsr        $2a04(pc)
085e: 4eba0ab0             jsr        $1310(pc)
0862: 7e00                 moveq      #$0, d7
0864: 5c8f                 addq.l     #$6, a7
0866: 6002                 bra.b      $86a
0868: 7e01                 moveq      #$1, d7
086a: 4ead0422             jsr        $422(a5) ; CODE20+03ba
086e: 41edc366             lea.l      -$3c9a(a5), a0
0872: 2b48c376             move.l     a0, -$3c8a(a5)
0876: 7c00                 moveq      #$0, d6
0878: 49edde28             lea.l      -$21d8(a5), a4
087c: 6012                 bra.b      $890
087e: 204d                 movea.l    a5, a0
0880: d0c6                 adda.w     d6, a0
0882: 116c0001c366         move.b     $1(a4), -$3c9a(a0)
0888: 426c0002             clr.w      $2(a4)
088c: 5246                 addq.w     #$1, d6
088e: 588c                 addq.l     #$4, a4
0890: 4a54                 tst.w      (a4)
0892: 66ea                 bne.b      $87e
0894: 204d                 movea.l    a5, a0
0896: d0c6                 adda.w     d6, a0
0898: 4228c366             clr.b      -$3c9a(a0)
089c: 422dc35e             clr.b      -$3ca2(a5)
08a0: 486dc35e             pea.l      -$3ca2(a5)
08a4: 4ead0582             jsr        $582(a5) ; CODE22+048a
08a8: 486dc366             pea.l      -$3c9a(a5)
08ac: 4ead0582             jsr        $582(a5) ; CODE22+048a
08b0: 486dc366             pea.l      -$3c9a(a5)
08b4: 4ebaf74e             jsr        $4(pc)
08b8: 4ebaff36             jsr        $7f0(pc)
08bc: 4ead03c2             jsr        $3c2(a5) ; CODE20+0cfa
08c0: 4a47                 tst.w      d7
08c2: 4fef000c             lea.l      $c(a7), a7
08c6: 6730                 beq.b      $8f8
08c8: 42adc372             clr.l      -$3c8e(a5)
08cc: 42adc36e             clr.l      -$3c92(a5)
08d0: 4ead012a             jsr        $12a(a5) ; CODE7+079a
08d4: 6022                 bra.b      $8f8
08d6: 41edc366             lea.l      -$3c9a(a5), a0
08da: b1edc376             cmpa.l     -$3c8a(a5), a0
08de: 6618                 bne.b      $8f8
08e0: 3f3c03fb             move.w     #$3fb, -(a7)
08e4: 4ead017a             jsr        $17a(a5) ; CODE8+0374
08e8: 4a40                 tst.w      d0
08ea: 548f                 addq.l     #$2, a7
08ec: 670a                 beq.b      $8f8
08ee: 3b7c0007de64         move.w     #$7, -$219c(a5)
08f4: 4ead0292             jsr        $292(a5) ; CODE14+0318
08f8: 4cdf10c0             movem.l    (a7)+, d6-d7/a4
08fc: 4e75                 rts        
08fe: 2f07                 move.l     d7, -(a7)
0900: 4ead0932             jsr        $932(a5) ; CODE31+0108
0904: 4a40                 tst.w      d0
0906: 6706                 beq.b      $90e
0908: 4a6dde28             tst.w      -$21d8(a5)
090c: 6604                 bne.b      $912
090e: 7e00                 moveq      #$0, d7
0910: 6002                 bra.b      $914
0912: 7e01                 moveq      #$1, d7
0914: be6dde5e             cmp.w      -$21a2(a5), d7
0918: 6708                 beq.b      $922
091a: 3b47de5e             move.w     d7, -$21a2(a5)
091e: 4eba20d2             jsr        $29f2(pc)
0922: 2e1f                 move.l     (a7)+, d7
0924: 4e75                 rts        
0926: 4e560000             link.w     a6, #$0
092a: 4aadeed6             tst.l      -$112a(a5)
092e: 670000ec             beq.w      $a1c
0932: 4a6e0008             tst.w      $8(a6)
0936: 6626                 bne.b      $95e
0938: 48780220             pea.l      $220.w
093c: 2f2deec2             move.l     -$113e(a5), -(a7)
0940: 486d97b2             pea.l      -$684e(a5)
0944: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0948: 48780220             pea.l      $220.w
094c: 2f2deec6             move.l     -$113a(a5), -(a7)
0950: 486d9592             pea.l      -$6a6e(a5)
0954: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0958: 4fef0018             lea.l      $18(a7), a7
095c: 603e                 bra.b      $99c
095e: 4aadde60             tst.l      -$21a0(a5)
0962: 6604                 bne.b      $968
0964: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0968: 4eba2a7a             jsr        $33e4(pc)
096c: 48780220             pea.l      $220.w
0970: 486d97b2             pea.l      -$684e(a5)
0974: 206dde60             movea.l    -$21a0(a5), a0
0978: 2f10                 move.l     (a0), -(a7)
097a: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
097e: 48780220             pea.l      $220.w
0982: 486d9592             pea.l      -$6a6e(a5)
0986: 206dde60             movea.l    -$21a0(a5), a0
098a: 2050                 movea.l    (a0), a0
098c: 48680220             pea.l      $220(a0)
0990: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0994: 4eba2a68             jsr        $33fe(pc)
0998: 4fef0018             lea.l      $18(a7), a7
099c: 48780121             pea.l      $121.w
09a0: 2f2deece             move.l     -$1132(a5), -(a7)
09a4: 486dd76c             pea.l      -$2894(a5)
09a8: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
09ac: 48780121             pea.l      $121.w
09b0: 2f2deed2             move.l     -$112e(a5), -(a7)
09b4: 486dd88d             pea.l      -$2773(a5)
09b8: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
09bc: 48780220             pea.l      $220.w
09c0: 2f2deeca             move.l     -$1136(a5), -(a7)
09c4: 486dbcfe             pea.l      -$4302(a5)
09c8: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
09cc: 48780440             pea.l      $440.w
09d0: 2f2deed6             move.l     -$112a(a5), -(a7)
09d4: 486dbf1e             pea.l      -$40e2(a5)
09d8: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
09dc: 2eadeec2             move.l     -$113e(a5), (a7)
09e0: 4ead068a             jsr        $68a(a5) ; CODE9+00b4
09e4: 2eadeec6             move.l     -$113a(a5), (a7)
09e8: 4ead068a             jsr        $68a(a5) ; CODE9+00b4
09ec: 2eadeece             move.l     -$1132(a5), (a7)
09f0: 4ead068a             jsr        $68a(a5) ; CODE9+00b4
09f4: 2eadeed2             move.l     -$112e(a5), (a7)
09f8: 4ead068a             jsr        $68a(a5) ; CODE9+00b4
09fc: 2eadeeca             move.l     -$1136(a5), (a7)
0a00: 4ead068a             jsr        $68a(a5) ; CODE9+00b4
0a04: 2eadeed6             move.l     -$112a(a5), (a7)
0a08: 4ead068a             jsr        $68a(a5) ; CODE9+00b4
0a0c: 7018                 moveq      #$18, d0
0a0e: 2e80                 move.l     d0, (a7)
0a10: 486deec2             pea.l      -$113e(a5)
0a14: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0a18: 4fef0034             lea.l      $34(a7), a7
0a1c: 4eba0e62             jsr        $1880(pc)
0a20: 4eba0ede             jsr        $1900(pc)
0a24: 2f00                 move.l     d0, -(a7)
0a26: 4eba0ee0             jsr        $1908(pc)
0a2a: 4e5e                 unlk       a6
0a2c: 4e75                 rts        
0a2e: 48780220             pea.l      $220.w
0a32: 4ead0682             jsr        $682(a5) ; CODE9+00a4
0a36: 2b40eec2             move.l     d0, -$113e(a5)
0a3a: 48780220             pea.l      $220.w
0a3e: 4ead0682             jsr        $682(a5) ; CODE9+00a4
0a42: 2b40eec6             move.l     d0, -$113a(a5)
0a46: 48780121             pea.l      $121.w
0a4a: 4ead0682             jsr        $682(a5) ; CODE9+00a4
0a4e: 2b40eece             move.l     d0, -$1132(a5)
0a52: 48780121             pea.l      $121.w
0a56: 4ead0682             jsr        $682(a5) ; CODE9+00a4
0a5a: 2b40eed2             move.l     d0, -$112e(a5)
0a5e: 48780220             pea.l      $220.w
0a62: 4ead0682             jsr        $682(a5) ; CODE9+00a4
0a66: 2b40eeca             move.l     d0, -$1136(a5)
0a6a: 48780440             pea.l      $440.w
0a6e: 4ead0682             jsr        $682(a5) ; CODE9+00a4
0a72: 2b40eed6             move.l     d0, -$112a(a5)
0a76: 4aadeed6             tst.l      -$112a(a5)
0a7a: 4fef0018             lea.l      $18(a7), a7
0a7e: 6604                 bne.b      $a84
0a80: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0a84: 48780220             pea.l      $220.w
0a88: 486d97b2             pea.l      -$684e(a5)
0a8c: 2f2deec2             move.l     -$113e(a5), -(a7)
0a90: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0a94: 48780220             pea.l      $220.w
0a98: 486d9592             pea.l      -$6a6e(a5)
0a9c: 2f2deec6             move.l     -$113a(a5), -(a7)
0aa0: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0aa4: 48780121             pea.l      $121.w
0aa8: 486dd76c             pea.l      -$2894(a5)
0aac: 2f2deece             move.l     -$1132(a5), -(a7)
0ab0: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0ab4: 48780121             pea.l      $121.w
0ab8: 486dd88d             pea.l      -$2773(a5)
0abc: 2f2deed2             move.l     -$112e(a5), -(a7)
0ac0: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0ac4: 48780220             pea.l      $220.w
0ac8: 486dbcfe             pea.l      -$4302(a5)
0acc: 2f2deeca             move.l     -$1136(a5), -(a7)
0ad0: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0ad4: 48780440             pea.l      $440.w
0ad8: 486dbf1e             pea.l      -$40e2(a5)
0adc: 2f2deed6             move.l     -$112a(a5), -(a7)
0ae0: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0ae4: 48780121             pea.l      $121.w
0ae8: 486dd76c             pea.l      -$2894(a5)
0aec: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0af0: 48780121             pea.l      $121.w
0af4: 486dd88d             pea.l      -$2773(a5)
0af8: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0afc: 48780220             pea.l      $220.w
0b00: 486dbcfe             pea.l      -$4302(a5)
0b04: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0b08: 48780440             pea.l      $440.w
0b0c: 486dbf1e             pea.l      -$40e2(a5)
0b10: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0b14: 4fef0068             lea.l      $68(a7), a7
0b18: 4eba0da0             jsr        $18ba(pc)
0b1c: 486deee4             pea.l      -$111c(a5)
0b20: 4eba0de6             jsr        $1908(pc)
0b24: 588f                 addq.l     #$4, a7
0b26: 4e75                 rts        
0b28: 4e560000             link.w     a6, #$0
0b2c: 48e70108             movem.l    d7/a4, -(a7)
0b30: 3e2e0008             move.w     $8(a6), d7
0b34: 700a                 moveq      #$a, d0
0b36: c1c7                 muls.w     d7, d0
0b38: 49edefe2             lea.l      -$101e(a5), a4
0b3c: d08c                 add.l      a4, d0
0b3e: 2840                 movea.l    d0, a4
0b40: 2f14                 move.l     (a4), -(a7)
0b42: a9a3                 dc.w       $a9a3
0b44: 536def1c             subq.w     #$1, -$10e4(a5)
0b48: 302def1c             move.w     -$10e4(a5), d0
0b4c: 9047                 sub.w      d7, d0
0b4e: c1fc000a             muls.w     #$a, d0
0b52: 2f00                 move.l     d0, -(a7)
0b54: 7001                 moveq      #$1, d0
0b56: d047                 add.w      d7, d0
0b58: c1fc000a             muls.w     #$a, d0
0b5c: 204d                 movea.l    a5, a0
0b5e: d1c0                 adda.l     d0, a0
0b60: 4868efe2             pea.l      -$101e(a0)
0b64: 2f0c                 move.l     a4, -(a7)
0b66: 4ead0d82             jsr        $d82(a5) ; CODE52+0186
0b6a: 4a47                 tst.w      d7
0b6c: 4fef000c             lea.l      $c(a7), a7
0b70: 660c                 bne.b      $b7e
0b72: 2038016a             move.l     $16a.w, d0
0b76: d1adefe6             add.l      d0, -$101a(a5)
0b7a: 4eba000a             jsr        $b86(pc)
0b7e: 4cdf1080             movem.l    (a7)+, d7/a4
0b82: 4e5e                 unlk       a6
0b84: 4e75                 rts        
0b86: 2f2ddec2             move.l     -$213e(a5), -(a7)
0b8a: a873                 dc.w       $a873
0b8c: 206dde80             movea.l    -$2180(a5), a0
0b90: 48680062             pea.l      $62(a0)
0b94: a928                 dc.w       $a928
0b96: 4e75                 rts        
0b98: 2f0c                 move.l     a4, -(a7)
0b9a: 206dde78             movea.l    -$2188(a5), a0
0b9e: 2050                 movea.l    (a0), a0
0ba0: 4a680310             tst.w      $310(a0)
0ba4: 6740                 beq.b      $be6
0ba6: 4a6def1c             tst.w      -$10e4(a5)
0baa: 673a                 beq.b      $be6
0bac: 4227                 clr.b      -(a7)
0bae: 206dde80             movea.l    -$2180(a5), a0
0bb2: 48680062             pea.l      $62(a0)
0bb6: 226ddec2             movea.l    -$213e(a5), a1
0bba: 2f290018             move.l     $18(a1), -(a7)
0bbe: a8e9                 dc.w       $a8e9
0bc0: 4a1f                 tst.b      (a7)+
0bc2: 6722                 beq.b      $be6
0bc4: 286defe2             movea.l    -$101e(a5), a4
0bc8: 204c                 movea.l    a4, a0
0bca: a029                 dc.w       $a029
0bcc: 2f14                 move.l     (a4), -(a7)
0bce: 42a7                 clr.l      -(a7)
0bd0: 2f0c                 move.l     a4, -(a7)
0bd2: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
0bd6: 206dde80             movea.l    -$2180(a5), a0
0bda: 48680062             pea.l      $62(a0)
0bde: 4267                 clr.w      -(a7)
0be0: a9ce                 dc.w       $a9ce
0be2: 204c                 movea.l    a4, a0
0be4: a02a                 dc.w       $a02a
0be6: 285f                 movea.l    (a7)+, a4
0be8: 4e75                 rts        
0bea: 4e56fff8             link.w     a6, #$fff8
0bee: 2f07                 move.l     d7, -(a7)
0bf0: 2f2ddec2             move.l     -$213e(a5), -(a7)
0bf4: a873                 dc.w       $a873
0bf6: 7e00                 moveq      #$0, d7
0bf8: 6014                 bra.b      $c0e
0bfa: 486efff8             pea.l      -$8(a6)
0bfe: 3f07                 move.w     d7, -(a7)
0c00: 4eba1e7c             jsr        $2a7e(pc)
0c04: 486efff8             pea.l      -$8(a6)
0c08: a928                 dc.w       $a928
0c0a: 5c8f                 addq.l     #$6, a7
0c0c: 5247                 addq.w     #$1, d7
0c0e: 0c470007             cmpi.w     #$7, d7
0c12: 6de6                 blt.b      $bfa
0c14: 2e1f                 move.l     (a7)+, d7
0c16: 4e5e                 unlk       a6
0c18: 4e75                 rts        
0c1a: 4e56fff4             link.w     a6, #$fff4
0c1e: 48e70f18             movem.l    d4-d7/a3-a4, -(a7)
0c22: 3e2e000c             move.w     $c(a6), d7
0c26: 206e0008             movea.l    $8(a6), a0
0c2a: 286800ca             movea.l    $ca(a0), a4
0c2e: 42a7                 clr.l      -(a7)
0c30: 2f0c                 move.l     a4, -(a7)
0c32: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
0c36: 2d5ffff4             move.l     (a7)+, -$c(a6)
0c3a: 48780006             pea.l      $6.w
0c3e: 2f2efff4             move.l     -$c(a6), -(a7)
0c42: 4ead004a             jsr        $4a(a5) ; CODE1+0124
0c46: 3047                 movea.w    d7, a0
0c48: b088                 cmp.l      a0, d0
0c4a: 641a                 bcc.b      $c66
0c4c: 42a7                 clr.l      -(a7)
0c4e: 2f0c                 move.l     a4, -(a7)
0c50: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
0c54: 2d5ffff4             move.l     (a7)+, -$c(a6)
0c58: 48780006             pea.l      $6.w
0c5c: 2f2efff4             move.l     -$c(a6), -(a7)
0c60: 4ead004a             jsr        $4a(a5) ; CODE1+0124
0c64: 3e00                 move.w     d0, d7
0c66: 0c2e0001000e         cmpi.b     #$1, $e(a6)
0c6c: 6706                 beq.b      $c74
0c6e: 4a2e000e             tst.b      $e(a6)
0c72: 6614                 bne.b      $c88
0c74: 2c07                 move.l     d7, d6
0c76: 48c6                 ext.l      d6
0c78: 8dfc0002             divs.w     #$2, d6
0c7c: 4846                 swap       d6
0c7e: 7a02                 moveq      #$2, d5
0c80: da46                 add.w      d6, d5
0c82: 3806                 move.w     d6, d4
0c84: d847                 add.w      d7, d4
0c86: 6004                 bra.b      $c8c
0c88: 7a01                 moveq      #$1, d5
0c8a: 3807                 move.w     d7, d4
0c8c: 7006                 moveq      #$6, d0
0c8e: c1c5                 muls.w     d5, d0
0c90: 2f00                 move.l     d0, -(a7)
0c92: 2f0c                 move.l     a4, -(a7)
0c94: 4ead05ca             jsr        $5ca(a5) ; CODE9+01ea
0c98: 2eae0008             move.l     $8(a6), (a7)
0c9c: a873                 dc.w       $a873
0c9e: 204c                 movea.l    a4, a0
0ca0: a029                 dc.w       $a029
0ca2: 588f                 addq.l     #$4, a7
0ca4: 6066                 bra.b      $d0c
0ca6: 3c05                 move.w     d5, d6
0ca8: dc47                 add.w      d7, d6
0caa: 7006                 moveq      #$6, d0
0cac: c1c6                 muls.w     d6, d0
0cae: 2640                 movea.l    d0, a3
0cb0: 204b                 movea.l    a3, a0
0cb2: d1d4                 adda.l     (a4), a0
0cb4: 10bc0004             move.b     #$4, (a0)
0cb8: 7000                 moveq      #$0, d0
0cba: a122                 dc.w       $a122
0cbc: 2014                 move.l     (a4), d0
0cbe: 27880802             move.l     a0, $2(a3, d0.l)
0cc2: 0c460016             cmpi.w     #$16, d6
0cc6: 6f06                 ble.b      $cce
0cc8: 7c16                 moveq      #$16, d6
0cca: 9c45                 sub.w      d5, d6
0ccc: 5346                 subq.w     #$1, d6
0cce: 703e                 moveq      #$3e, d0
0cd0: d0adde80             add.l      -$2180(a5), d0
0cd4: 2640                 movea.l    d0, a3
0cd6: 70ef                 moveq      #$ef, d0
0cd8: d06b0006             add.w      $6(a3), d0
0cdc: 3d40fffe             move.w     d0, -$2(a6)
0ce0: 3d6b0002fffa         move.w     $2(a3), -$6(a6)
0ce6: 2006                 move.l     d6, d0
0ce8: 48c0                 ext.l      d0
0cea: 81fc0002             divs.w     #$2, d0
0cee: c1fc000c             muls.w     #$c, d0
0cf2: d053                 add.w      (a3), d0
0cf4: 0640000f             addi.w     #$f, d0
0cf8: 3d40fff8             move.w     d0, -$8(a6)
0cfc: 700c                 moveq      #$c, d0
0cfe: d06efff8             add.w      -$8(a6), d0
0d02: 3d40fffc             move.w     d0, -$4(a6)
0d06: 486efff8             pea.l      -$8(a6)
0d0a: a928                 dc.w       $a928
0d0c: 5345                 subq.w     #$1, d5
0d0e: 4a45                 tst.w      d5
0d10: 6c94                 bge.b      $ca6
0d12: 204c                 movea.l    a4, a0
0d14: a02a                 dc.w       $a02a
0d16: 4eba078e             jsr        $14a6(pc)
0d1a: 3004                 move.w     d4, d0
0d1c: 4cdf18f0             movem.l    (a7)+, d4-d7/a3-a4
0d20: 4e5e                 unlk       a6
0d22: 4e75                 rts        
0d24: 4e56fe62             link.w     a6, #$fe62
0d28: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0d2c: 206dde80             movea.l    -$2180(a5), a0
0d30: 7a0d                 moveq      #$d, d5
0d32: da68003e             add.w      $3e(a0), d5
0d36: 700e                 moveq      #$e, d0
0d38: d0680040             add.w      $40(a0), d0
0d3c: 3d40fe74             move.w     d0, -$18c(a6)
0d40: 72f0                 moveq      #$f0, d1
0d42: d2680044             add.w      $44(a0), d1
0d46: 3d41fe76             move.w     d1, -$18a(a6)
0d4a: 3c280044             move.w     $44(a0), d6
0d4e: dc680040             add.w      $40(a0), d6
0d52: 5546                 subq.w     #$2, d6
0d54: 48c6                 ext.l      d6
0d56: 8dfc0002             divs.w     #$2, d6
0d5a: 4227                 clr.b      -(a7)
0d5c: 4868003e             pea.l      $3e(a0)
0d60: 226ddec2             movea.l    -$213e(a5), a1
0d64: 2f290018             move.l     $18(a1), -(a7)
0d68: a8e9                 dc.w       $a8e9
0d6a: 4a1f                 tst.b      (a7)+
0d6c: 6700059a             beq.w      $1308
0d70: 2f2ddec2             move.l     -$213e(a5), -(a7)
0d74: a873                 dc.w       $a873
0d76: 2f3c00020002         move.l     #$20002, -(a7)
0d7c: a89b                 dc.w       $a89b
0d7e: 206dde80             movea.l    -$2180(a5), a0
0d82: 4868003e             pea.l      $3e(a0)
0d86: a8a1                 dc.w       $a8a1
0d88: 206dde80             movea.l    -$2180(a5), a0
0d8c: 3f280040             move.w     $40(a0), -(a7)
0d90: 3f05                 move.w     d5, -(a7)
0d92: a893                 dc.w       $a893
0d94: 206dde80             movea.l    -$2180(a5), a0
0d98: 70fe                 moveq      #$fe, d0
0d9a: d0680044             add.w      $44(a0), d0
0d9e: 3f00                 move.w     d0, -(a7)
0da0: 3f05                 move.w     d5, -(a7)
0da2: a891                 dc.w       $a891
0da4: a89e                 dc.w       $a89e
0da6: 486dfab2             pea.l      -$54e(a5)
0daa: a89d                 dc.w       $a89d
0dac: 3f3c0009             move.w     #$9, -(a7)
0db0: a89c                 dc.w       $a89c
0db2: 3f2efe74             move.w     -$18c(a6), -(a7)
0db6: 3f05                 move.w     d5, -(a7)
0db8: a893                 dc.w       $a893
0dba: 3f2efe74             move.w     -$18c(a6), -(a7)
0dbe: 206dde80             movea.l    -$2180(a5), a0
0dc2: 70fe                 moveq      #$fe, d0
0dc4: d0680042             add.w      $42(a0), d0
0dc8: 3f00                 move.w     d0, -(a7)
0dca: a891                 dc.w       $a891
0dcc: 3f06                 move.w     d6, -(a7)
0dce: 206dde80             movea.l    -$2180(a5), a0
0dd2: 3f28003e             move.w     $3e(a0), -(a7)
0dd6: a893                 dc.w       $a893
0dd8: 3f06                 move.w     d6, -(a7)
0dda: 206dde80             movea.l    -$2180(a5), a0
0dde: 70fe                 moveq      #$fe, d0
0de0: d0680042             add.w      $42(a0), d0
0de4: 3f00                 move.w     d0, -(a7)
0de6: a891                 dc.w       $a891
0de8: a89e                 dc.w       $a89e
0dea: 3f3c0004             move.w     #$4, -(a7)
0dee: a887                 dc.w       $a887
0df0: 3f3c0009             move.w     #$9, -(a7)
0df4: a88a                 dc.w       $a88a
0df6: 4267                 clr.w      -(a7)
0df8: a888                 dc.w       $a888
0dfa: 4267                 clr.w      -(a7)
0dfc: a889                 dc.w       $a889
0dfe: 0645000c             addi.w     #$c, d5
0e02: 41edc366             lea.l      -$3c9a(a5), a0
0e06: b1edc376             cmpa.l     -$3c8a(a5), a0
0e0a: 57c0                 seq.b      d0
0e0c: 4400                 neg.b      d0
0e0e: 4880                 ext.w      d0
0e10: 3d40fe70             move.w     d0, -$190(a6)
0e14: 4267                 clr.w      -(a7)
0e16: 2f2ddec6             move.l     -$213a(a5), -(a7)
0e1a: a960                 dc.w       $a960
0e1c: 3e1f                 move.w     (a7)+, d7
0e1e: be6e0008             cmp.w      $8(a6), d7
0e22: 6f04                 ble.b      $e28
0e24: 3d470008             move.w     d7, $8(a6)
0e28: 0c6e7fff000a         cmpi.w     #$7fff, $a(a6)
0e2e: 660a                 bne.b      $e3a
0e30: 7016                 moveq      #$16, d0
0e32: d06e0008             add.w      $8(a6), d0
0e36: 3d40000a             move.w     d0, $a(a6)
0e3a: 3d7c0001fe6e         move.w     #$1, -$192(a6)
0e40: 7600                 moveq      #$0, d3
0e42: 42a7                 clr.l      -(a7)
0e44: 206ddec2             movea.l    -$213e(a5), a0
0e48: 2f2800ca             move.l     $ca(a0), -(a7)
0e4c: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
0e50: 2d5ffe62             move.l     (a7)+, -$19e(a6)
0e54: 48780006             pea.l      $6.w
0e58: 2f2efe62             move.l     -$19e(a6), -(a7)
0e5c: 4ead004a             jsr        $4a(a5) ; CODE1+0124
0e60: 3043                 movea.w    d3, a0
0e62: b088                 cmp.l      a0, d0
0e64: 63000324             bls.w      $118a
0e68: 3803                 move.w     d3, d4
0e6a: 9847                 sub.w      d7, d4
0e6c: 48c4                 ext.l      d4
0e6e: 89fc0002             divs.w     #$2, d4
0e72: 206ddec2             movea.l    -$213e(a5), a0
0e76: 206800ca             movea.l    $ca(a0), a0
0e7a: 7006                 moveq      #$6, d0
0e7c: c1c3                 muls.w     d3, d0
0e7e: d090                 add.l      (a0), d0
0e80: 2040                 movea.l    d0, a0
0e82: 1010                 move.b     (a0), d0
0e84: 6764                 beq.b      $eea
0e86: 6b0002c8             bmi.w      $1150
0e8a: 5700                 subq.b     #$3, d0
0e8c: 670000c0             beq.w      $f4e
0e90: 6a08                 bpl.b      $e9a
0e92: 5200                 addq.b     #$1, d0
0e94: 6a000172             bpl.w      $1008
0e98: 6026                 bra.b      $ec0
0e9a: 5500                 subq.b     #$2, d0
0e9c: 6a0002b2             bpl.w      $1150
0ea0: b66e0008             cmp.w      $8(a6), d3
0ea4: 6d0002aa             blt.w      $1150
0ea8: b66e000a             cmp.w      $a(a6), d3
0eac: 6c0002a2             bge.w      $1150
0eb0: 3003                 move.w     d3, d0
0eb2: 9047                 sub.w      d7, d0
0eb4: 3f00                 move.w     d0, -(a7)
0eb6: 4eba0744             jsr        $15fc(pc)
0eba: 548f                 addq.l     #$2, a7
0ebc: 60000292             bra.w      $1150
0ec0: 206ddec2             movea.l    -$213e(a5), a0
0ec4: 206800ca             movea.l    $ca(a0), a0
0ec8: 7006                 moveq      #$6, d0
0eca: c1c3                 muls.w     d3, d0
0ecc: 2050                 movea.l    (a0), a0
0ece: 2f300802             move.l     $2(a0, d0.l), -(a7)
0ed2: 4ead05ea             jsr        $5ea(a5) ; CODE9+022e
0ed6: 2d40fffc             move.l     d0, -$4(a6)
0eda: 2040                 movea.l    d0, a0
0edc: 3d680004fe6e         move.w     $4(a0), -$192(a6)
0ee2: 45edf09a             lea.l      -$f66(a5), a2
0ee6: 588f                 addq.l     #$4, a7
0ee8: 600e                 bra.b      $ef8
0eea: b66dde54             cmp.w      -$21ac(a5), d3
0eee: 6e04                 bgt.b      $ef4
0ef0: 426efe6e             clr.w      -$192(a6)
0ef4: 45edf0a4             lea.l      -$f5c(a5), a2
0ef8: 3d7c0001fe72         move.w     #$1, -$18e(a6)
0efe: 2003                 move.l     d3, d0
0f00: 48c0                 ext.l      d0
0f02: 81fc0002             divs.w     #$2, d0
0f06: 4840                 swap       d0
0f08: 4a40                 tst.w      d0
0f0a: 6704                 beq.b      $f10
0f0c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0f10: b66e0008             cmp.w      $8(a6), d3
0f14: 6d00023a             blt.w      $1150
0f18: b66e000a             cmp.w      $a(a6), d3
0f1c: 6c000232             bge.w      $1150
0f20: 4267                 clr.w      -(a7)
0f22: 3f04                 move.w     d4, -(a7)
0f24: 4eba08a0             jsr        $17c6(pc)
0f28: 7002                 moveq      #$2, d0
0f2a: d06efe74             add.w      -$18c(a6), d0
0f2e: 3e80                 move.w     d0, (a7)
0f30: 700c                 moveq      #$c, d0
0f32: c1c4                 muls.w     d4, d0
0f34: d045                 add.w      d5, d0
0f36: 3f00                 move.w     d0, -(a7)
0f38: a893                 dc.w       $a893
0f3a: 2f0a                 move.l     a2, -(a7)
0f3c: a884                 dc.w       $a884
0f3e: 3003                 move.w     d3, d0
0f40: 9047                 sub.w      d7, d0
0f42: 3e80                 move.w     d0, (a7)
0f44: 4eba0766             jsr        $16ac(pc)
0f48: 548f                 addq.l     #$2, a7
0f4a: 60000204             bra.w      $1150
0f4e: b66e0008             cmp.w      $8(a6), d3
0f52: 6d0001fc             blt.w      $1150
0f56: b66e000a             cmp.w      $a(a6), d3
0f5a: 6c0001f4             bge.w      $1150
0f5e: 206ddec2             movea.l    -$213e(a5), a0
0f62: 206800ca             movea.l    $ca(a0), a0
0f66: 7006                 moveq      #$6, d0
0f68: c1c3                 muls.w     d3, d0
0f6a: 2050                 movea.l    (a0), a0
0f6c: 2f300802             move.l     $2(a0, d0.l), -(a7)
0f70: 4ead05ea             jsr        $5ea(a5) ; CODE9+022e
0f74: 2d40fffc             move.l     d0, -$4(a6)
0f78: 2203                 move.l     d3, d1
0f7a: 48c1                 ext.l      d1
0f7c: 83fc0002             divs.w     #$2, d1
0f80: 4841                 swap       d1
0f82: 4a41                 tst.w      d1
0f84: 588f                 addq.l     #$4, a7
0f86: 660a                 bne.b      $f92
0f88: 4267                 clr.w      -(a7)
0f8a: 3f04                 move.w     d4, -(a7)
0f8c: 4eba0838             jsr        $17c6(pc)
0f90: 588f                 addq.l     #$4, a7
0f92: 48780064             pea.l      $64.w
0f96: 206efffc             movea.l    -$4(a6), a0
0f9a: 2f28000a             move.l     $a(a0), -(a7)
0f9e: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0fa2: 2f00                 move.l     d0, -(a7)
0fa4: 48680002             pea.l      $2(a0)
0fa8: 486df0b2             pea.l      -$f4e(a5)
0fac: 486efefd             pea.l      -$103(a6)
0fb0: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0fb4: 1d40fefc             move.b     d0, -$104(a6)
0fb8: 2003                 move.l     d3, d0
0fba: 48c0                 ext.l      d0
0fbc: 81fc0002             divs.w     #$2, d0
0fc0: 4840                 swap       d0
0fc2: 4a40                 tst.w      d0
0fc4: 4fef0010             lea.l      $10(a7), a7
0fc8: 6706                 beq.b      $fd0
0fca: 302efe76             move.w     -$18a(a6), d0
0fce: 6002                 bra.b      $fd2
0fd0: 3006                 move.w     d6, d0
0fd2: 3d40fe64             move.w     d0, -$19c(a6)
0fd6: 4267                 clr.w      -(a7)
0fd8: 486efefc             pea.l      -$104(a6)
0fdc: a88c                 dc.w       $a88c
0fde: 302efe64             move.w     -$19c(a6), d0
0fe2: 905f                 sub.w      (a7)+, d0
0fe4: 5540                 subq.w     #$2, d0
0fe6: 3f00                 move.w     d0, -(a7)
0fe8: 700c                 moveq      #$c, d0
0fea: c1c4                 muls.w     d4, d0
0fec: d045                 add.w      d5, d0
0fee: 3f00                 move.w     d0, -(a7)
0ff0: a893                 dc.w       $a893
0ff2: 3003                 move.w     d3, d0
0ff4: 9047                 sub.w      d7, d0
0ff6: 3f00                 move.w     d0, -(a7)
0ff8: 4eba0744             jsr        $173e(pc)
0ffc: 486efefc             pea.l      -$104(a6)
1000: a884                 dc.w       $a884
1002: 548f                 addq.l     #$2, a7
1004: 6000014a             bra.w      $1150
1008: 206ddec2             movea.l    -$213e(a5), a0
100c: 206800ca             movea.l    $ca(a0), a0
1010: 7006                 moveq      #$6, d0
1012: c1c3                 muls.w     d3, d0
1014: 2050                 movea.l    (a0), a0
1016: 2f300802             move.l     $2(a0, d0.l), -(a7)
101a: 4ead05ea             jsr        $5ea(a5) ; CODE9+022e
101e: 2d40fffc             move.l     d0, -$4(a6)
1022: 0c6e0001fe72         cmpi.w     #$1, -$18e(a6)
1028: 588f                 addq.l     #$4, a7
102a: 661c                 bne.b      $1048
102c: 2003                 move.l     d3, d0
102e: 48c0                 ext.l      d0
1030: 81fc0002             divs.w     #$2, d0
1034: 4840                 swap       d0
1036: 4a40                 tst.w      d0
1038: 6704                 beq.b      $103e
103a: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
103e: 206efffc             movea.l    -$4(a6), a0
1042: 3d680022fe70         move.w     $22(a0), -$190(a6)
1048: 526efe72             addq.w     #$1, -$18e(a6)
104c: b66e0008             cmp.w      $8(a6), d3
1050: 6d0000fe             blt.w      $1150
1054: b66e000a             cmp.w      $a(a6), d3
1058: 6c0000f6             bge.w      $1150
105c: 302efe72             move.w     -$18e(a6), d0
1060: 48c0                 ext.l      d0
1062: 81fc0002             divs.w     #$2, d0
1066: 3f00                 move.w     d0, -(a7)
1068: 3f04                 move.w     d4, -(a7)
106a: 4eba075a             jsr        $17c6(pc)
106e: 206efffc             movea.l    -$4(a6), a0
1072: 4a280020             tst.b      $20(a0)
1076: 588f                 addq.l     #$4, a7
1078: 672a                 beq.b      $10a4
107a: 48780064             pea.l      $64.w
107e: 206efffc             movea.l    -$4(a6), a0
1082: 2f280010             move.l     $10(a0), -(a7)
1086: 4ead005a             jsr        $5a(a5) ; CODE1+0166
108a: 2f00                 move.l     d0, -(a7)
108c: 2f08                 move.l     a0, -(a7)
108e: 486df0bc             pea.l      -$f44(a5)
1092: 486efefd             pea.l      -$103(a6)
1096: 4ead0812             jsr        $812(a5) ; CODE24+16a6
109a: 1d40fefc             move.b     d0, -$104(a6)
109e: 4fef0010             lea.l      $10(a7), a7
10a2: 6064                 bra.b      $1108
10a4: 206efffc             movea.l    -$4(a6), a0
10a8: 4a680022             tst.w      $22(a0)
10ac: 672a                 beq.b      $10d8
10ae: 48780064             pea.l      $64.w
10b2: 206efffc             movea.l    -$4(a6), a0
10b6: 2f280010             move.l     $10(a0), -(a7)
10ba: 4ead005a             jsr        $5a(a5) ; CODE1+0166
10be: 2f00                 move.l     d0, -(a7)
10c0: 2f08                 move.l     a0, -(a7)
10c2: 486df0c4             pea.l      -$f3c(a5)
10c6: 486efefd             pea.l      -$103(a6)
10ca: 4ead0812             jsr        $812(a5) ; CODE24+16a6
10ce: 1d40fefc             move.b     d0, -$104(a6)
10d2: 4fef0010             lea.l      $10(a7), a7
10d6: 6030                 bra.b      $1108
10d8: 48780064             pea.l      $64.w
10dc: 206efffc             movea.l    -$4(a6), a0
10e0: 2f280010             move.l     $10(a0), -(a7)
10e4: 4ead005a             jsr        $5a(a5) ; CODE1+0166
10e8: 2f00                 move.l     d0, -(a7)
10ea: 2f08                 move.l     a0, -(a7)
10ec: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
10f0: 548f                 addq.l     #$2, a7
10f2: 3e80                 move.w     d0, (a7)
10f4: 486df0ce             pea.l      -$f32(a5)
10f8: 486efefd             pea.l      -$103(a6)
10fc: 4ead0812             jsr        $812(a5) ; CODE24+16a6
1100: 1d40fefc             move.b     d0, -$104(a6)
1104: 4fef000e             lea.l      $e(a7), a7
1108: 2003                 move.l     d3, d0
110a: 48c0                 ext.l      d0
110c: 81fc0002             divs.w     #$2, d0
1110: 4840                 swap       d0
1112: 4a40                 tst.w      d0
1114: 6706                 beq.b      $111c
1116: 302efe76             move.w     -$18a(a6), d0
111a: 6002                 bra.b      $111e
111c: 3006                 move.w     d6, d0
111e: 3d40fe64             move.w     d0, -$19c(a6)
1122: 4267                 clr.w      -(a7)
1124: 486efefc             pea.l      -$104(a6)
1128: a88c                 dc.w       $a88c
112a: 302efe64             move.w     -$19c(a6), d0
112e: 905f                 sub.w      (a7)+, d0
1130: 5540                 subq.w     #$2, d0
1132: 3f00                 move.w     d0, -(a7)
1134: 700c                 moveq      #$c, d0
1136: c1c4                 muls.w     d4, d0
1138: d045                 add.w      d5, d0
113a: 3f00                 move.w     d0, -(a7)
113c: a893                 dc.w       $a893
113e: 3003                 move.w     d3, d0
1140: 9047                 sub.w      d7, d0
1142: 3f00                 move.w     d0, -(a7)
1144: 4eba05f8             jsr        $173e(pc)
1148: 486efefc             pea.l      -$104(a6)
114c: a884                 dc.w       $a884
114e: 548f                 addq.l     #$2, a7
1150: 206ddec2             movea.l    -$213e(a5), a0
1154: 206800ca             movea.l    $ca(a0), a0
1158: 7006                 moveq      #$6, d0
115a: c1c3                 muls.w     d3, d0
115c: 2050                 movea.l    (a0), a0
115e: 20700802             movea.l    $2(a0, d0.l), a0
1162: a02a                 dc.w       $a02a
1164: 5243                 addq.w     #$1, d3
1166: 6000fcda             bra.w      $e42
116a: 3803                 move.w     d3, d4
116c: 5243                 addq.w     #$1, d3
116e: 9847                 sub.w      d7, d4
1170: 4267                 clr.w      -(a7)
1172: 2004                 move.l     d4, d0
1174: 5240                 addq.w     #$1, d0
1176: 48c0                 ext.l      d0
1178: 81fc0002             divs.w     #$2, d0
117c: 3f00                 move.w     d0, -(a7)
117e: 4eba0646             jsr        $17c6(pc)
1182: 3e84                 move.w     d4, (a7)
1184: 4eba0476             jsr        $15fc(pc)
1188: 588f                 addq.l     #$4, a7
118a: b66e000a             cmp.w      $a(a6), d3
118e: 6dda                 blt.b      $116a
1190: 0645fff4             addi.w     #$fff4, d5
1194: 206dde78             movea.l    -$2188(a5), a0
1198: a029                 dc.w       $a029
119a: 206dde78             movea.l    -$2188(a5), a0
119e: 2050                 movea.l    (a0), a0
11a0: 4868032e             pea.l      $32e(a0)
11a4: 486eff7c             pea.l      -$84(a6)
11a8: 4ead07ea             jsr        $7ea(a5) ; CODE23+01fe
11ac: 206dde78             movea.l    -$2188(a5), a0
11b0: a02a                 dc.w       $a02a
11b2: 3ebc0020             move.w     #$20, (a7)
11b6: 486eff7c             pea.l      -$84(a6)
11ba: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
11be: 2440                 movea.l    d0, a2
11c0: 200a                 move.l     a2, d0
11c2: 4fef000c             lea.l      $c(a7), a7
11c6: 6702                 beq.b      $11ca
11c8: 4212                 clr.b      (a2)
11ca: 422eff86             clr.b      -$7a(a6)
11ce: 48780064             pea.l      $64.w
11d2: 2f2dc372             move.l     -$3c8e(a5), -(a7)
11d6: 4ead005a             jsr        $5a(a5) ; CODE1+0166
11da: 2f00                 move.l     d0, -(a7)
11dc: 4a6efe6e             tst.w      -$192(a6)
11e0: 6708                 beq.b      $11ea
11e2: 41eeff7c             lea.l      -$84(a6), a0
11e6: 2008                 move.l     a0, d0
11e8: 6006                 bra.b      $11f0
11ea: 41edf0dc             lea.l      -$f24(a5), a0
11ee: 2008                 move.l     a0, d0
11f0: 2f00                 move.l     d0, -(a7)
11f2: 486df0e4             pea.l      -$f1c(a5)
11f6: 486efefd             pea.l      -$103(a6)
11fa: 4ead0812             jsr        $812(a5) ; CODE24+16a6
11fe: 1d40fefc             move.b     d0, -$104(a6)
1202: 7064                 moveq      #$64, d0
1204: 2e80                 move.l     d0, (a7)
1206: 2f2dc36e             move.l     -$3c92(a5), -(a7)
120a: 4ead005a             jsr        $5a(a5) ; CODE1+0166
120e: 2e80                 move.l     d0, (a7)
1210: 4a6efe6e             tst.w      -$192(a6)
1214: 6708                 beq.b      $121e
1216: 41edf0ec             lea.l      -$f14(a5), a0
121a: 2008                 move.l     a0, d0
121c: 6006                 bra.b      $1224
121e: 41edf0f2             lea.l      -$f0e(a5), a0
1222: 2008                 move.l     a0, d0
1224: 2f00                 move.l     d0, -(a7)
1226: 486df0fa             pea.l      -$f06(a5)
122a: 486efe7d             pea.l      -$183(a6)
122e: 4ead0812             jsr        $812(a5) ; CODE24+16a6
1232: 1d40fe7c             move.b     d0, -$184(a6)
1236: 4a6efe70             tst.w      -$190(a6)
123a: 4fef0018             lea.l      $18(a7), a7
123e: 670a                 beq.b      $124a
1240: 49eefefc             lea.l      -$104(a6), a4
1244: 47eefe7c             lea.l      -$184(a6), a3
1248: 6008                 bra.b      $1252
124a: 49eefe7c             lea.l      -$184(a6), a4
124e: 47eefefc             lea.l      -$104(a6), a3
1252: 3f3c0001             move.w     #$1, -(a7)
1256: a888                 dc.w       $a888
1258: 206dde80             movea.l    -$2180(a5), a0
125c: 7002                 moveq      #$2, d0
125e: d068003e             add.w      $3e(a0), d0
1262: 3d40fe66             move.w     d0, -$19a(a6)
1266: 700b                 moveq      #$b, d0
1268: d06efe66             add.w      -$19a(a6), d0
126c: 3d40fe6a             move.w     d0, -$196(a6)
1270: 4267                 clr.w      -(a7)
1272: 2f0c                 move.l     a4, -(a7)
1274: a88c                 dc.w       $a88c
1276: 3006                 move.w     d6, d0
1278: 905f                 sub.w      (a7)+, d0
127a: 5540                 subq.w     #$2, d0
127c: 3d40fe6c             move.w     d0, -$194(a6)
1280: 3f00                 move.w     d0, -(a7)
1282: 70fe                 moveq      #$fe, d0
1284: d045                 add.w      d5, d0
1286: 3f00                 move.w     d0, -(a7)
1288: a893                 dc.w       $a893
128a: 206dde80             movea.l    -$2180(a5), a0
128e: 7002                 moveq      #$2, d0
1290: d0680040             add.w      $40(a0), d0
1294: 3d40fe68             move.w     d0, -$198(a6)
1298: 486efe66             pea.l      -$19a(a6)
129c: a8a3                 dc.w       $a8a3
129e: 2f0c                 move.l     a4, -(a7)
12a0: a884                 dc.w       $a884
12a2: 4267                 clr.w      -(a7)
12a4: 2f0b                 move.l     a3, -(a7)
12a6: a88c                 dc.w       $a88c
12a8: 302efe76             move.w     -$18a(a6), d0
12ac: 905f                 sub.w      (a7)+, d0
12ae: 5540                 subq.w     #$2, d0
12b0: 3d40fe6c             move.w     d0, -$194(a6)
12b4: 3f00                 move.w     d0, -(a7)
12b6: 70fe                 moveq      #$fe, d0
12b8: d045                 add.w      d5, d0
12ba: 3f00                 move.w     d0, -(a7)
12bc: a893                 dc.w       $a893
12be: 7002                 moveq      #$2, d0
12c0: d046                 add.w      d6, d0
12c2: b06efe6c             cmp.w      -$194(a6), d0
12c6: 6f12                 ble.b      $12da
12c8: 7002                 moveq      #$2, d0
12ca: d046                 add.w      d6, d0
12cc: 906efe6c             sub.w      -$194(a6), d0
12d0: 3f00                 move.w     d0, -(a7)
12d2: 4267                 clr.w      -(a7)
12d4: a894                 dc.w       $a894
12d6: 3d46fe6c             move.w     d6, -$194(a6)
12da: 206dde80             movea.l    -$2180(a5), a0
12de: 30280040             move.w     $40(a0), d0
12e2: d0680044             add.w      $44(a0), d0
12e6: 5540                 subq.w     #$2, d0
12e8: 48c0                 ext.l      d0
12ea: 81fc0002             divs.w     #$2, d0
12ee: 5240                 addq.w     #$1, d0
12f0: 3d40fe68             move.w     d0, -$198(a6)
12f4: 486efe66             pea.l      -$19a(a6)
12f8: a8a3                 dc.w       $a8a3
12fa: 2f0b                 move.l     a3, -(a7)
12fc: a884                 dc.w       $a884
12fe: 4267                 clr.w      -(a7)
1300: a888                 dc.w       $a888
1302: 3f3c0001             move.w     #$1, -(a7)
1306: a889                 dc.w       $a889
1308: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
130c: 4e5e                 unlk       a6
130e: 4e75                 rts        
1310: 4e56fff8             link.w     a6, #$fff8
1314: 206dde80             movea.l    -$2180(a5), a0
1318: 2d68003efff8         move.l     $3e(a0), -$8(a6)
131e: 2d680042fffc         move.l     $42(a0), -$4(a6)
1324: 2f2ddec2             move.l     -$213e(a5), -(a7)
1328: a873                 dc.w       $a873
132a: 700d                 moveq      #$d, d0
132c: d06efff8             add.w      -$8(a6), d0
1330: 3d40fffc             move.w     d0, -$4(a6)
1334: 486efff8             pea.l      -$8(a6)
1338: a928                 dc.w       $a928
133a: 4e5e                 unlk       a6
133c: 4e75                 rts        
133e: 4e56ffd8             link.w     a6, #$ffd8
1342: 2f07                 move.l     d7, -(a7)
1344: 206dde78             movea.l    -$2188(a5), a0
1348: 2050                 movea.l    (a0), a0
134a: 4a68030e             tst.w      $30e(a0)
134e: 670000a4             beq.w      $13f4
1352: 3f3c0012             move.w     #$12, -(a7)
1356: a88a                 dc.w       $a88a
1358: 3f3c0003             move.w     #$3, -(a7)
135c: a887                 dc.w       $a887
135e: 4267                 clr.w      -(a7)
1360: a889                 dc.w       $a889
1362: 206dde80             movea.l    -$2180(a5), a0
1366: 2d68004effd8         move.l     $4e(a0), -$28(a6)
136c: 2d680052ffdc         move.l     $52(a0), -$24(a6)
1372: 486effd8             pea.l      -$28(a6)
1376: a8a1                 dc.w       $a8a1
1378: 4878003c             pea.l      $3c.w
137c: 2f2dde56             move.l     -$21aa(a5), -(a7)
1380: 4ead005a             jsr        $5a(a5) ; CODE1+0166
1384: 2e00                 move.l     d0, d7
1386: 4878003c             pea.l      $3c.w
138a: 2f07                 move.l     d7, -(a7)
138c: 4ead0062             jsr        $62(a5) ; CODE1+0186
1390: 2f00                 move.l     d0, -(a7)
1392: 48780064             pea.l      $64.w
1396: 4878003c             pea.l      $3c.w
139a: 2f07                 move.l     d7, -(a7)
139c: 4ead005a             jsr        $5a(a5) ; CODE1+0166
13a0: 2f00                 move.l     d0, -(a7)
13a2: 4ead0062             jsr        $62(a5) ; CODE1+0186
13a6: 2f00                 move.l     d0, -(a7)
13a8: 486df102             pea.l      -$efe(a5)
13ac: 486effe1             pea.l      -$1f(a6)
13b0: 4ead0812             jsr        $812(a5) ; CODE24+16a6
13b4: 1d40ffe0             move.b     d0, -$20(a6)
13b8: 4257                 clr.w      (a7)
13ba: 486effe0             pea.l      -$20(a6)
13be: a88c                 dc.w       $a88c
13c0: 3e2effde             move.w     -$22(a6), d7
13c4: 9e5f                 sub.w      (a7)+, d7
13c6: 5347                 subq.w     #$1, d7
13c8: 486effd8             pea.l      -$28(a6)
13cc: 2f3c00010001         move.l     #$10001, -(a7)
13d2: a8a9                 dc.w       $a8a9
13d4: 3d47ffde             move.w     d7, -$22(a6)
13d8: 486effd8             pea.l      -$28(a6)
13dc: a8a3                 dc.w       $a8a3
13de: 3e87                 move.w     d7, (a7)
13e0: 206dde80             movea.l    -$2180(a5), a0
13e4: 70fb                 moveq      #$fb, d0
13e6: d0680052             add.w      $52(a0), d0
13ea: 3f00                 move.w     d0, -(a7)
13ec: a893                 dc.w       $a893
13ee: 486effe0             pea.l      -$20(a6)
13f2: a884                 dc.w       $a884
13f4: 2e2effd4             move.l     -$2c(a6), d7
13f8: 4e5e                 unlk       a6
13fa: 4e75                 rts        
13fc: 4e56fff8             link.w     a6, #$fff8
1400: 206dde80             movea.l    -$2180(a5), a0
1404: 2d68004efff8         move.l     $4e(a0), -$8(a6)
140a: 2d680052fffc         move.l     $52(a0), -$4(a6)
1410: 2f2ddec2             move.l     -$213e(a5), -(a7)
1414: a873                 dc.w       $a873
1416: 486efff8             pea.l      -$8(a6)
141a: 3f2e0008             move.w     $8(a6), -(a7)
141e: 3f2e0008             move.w     $8(a6), -(a7)
1422: a8a9                 dc.w       $a8a9
1424: 486efff8             pea.l      -$8(a6)
1428: a928                 dc.w       $a928
142a: 4e5e                 unlk       a6
142c: 4e75                 rts        
142e: 4e560000             link.w     a6, #$0
1432: 2f07                 move.l     d7, -(a7)
1434: 302e0008             move.w     $8(a6), d0
1438: 6b3c                 bmi.b      $1476
143a: 04400016             subi.w     #$16, d0
143e: 6718                 beq.b      $1458
1440: 6a08                 bpl.b      $144a
1442: 5440                 addq.w     #$2, d0
1444: 670a                 beq.b      $1450
1446: 6a0c                 bpl.b      $1454
1448: 602c                 bra.b      $1476
144a: 5540                 subq.w     #$2, d0
144c: 6a28                 bpl.b      $1476
144e: 600c                 bra.b      $145c
1450: 7efe                 moveq      #$fe, d7
1452: 600a                 bra.b      $145e
1454: 7e02                 moveq      #$2, d7
1456: 6006                 bra.b      $145e
1458: 7eee                 moveq      #$ee, d7
145a: 6002                 bra.b      $145e
145c: 7e12                 moveq      #$12, d7
145e: 2f2e000a             move.l     $a(a6), -(a7)
1462: 4267                 clr.w      -(a7)
1464: 2f2e000a             move.l     $a(a6), -(a7)
1468: a960                 dc.w       $a960
146a: 301f                 move.w     (a7)+, d0
146c: d047                 add.w      d7, d0
146e: 3f00                 move.w     d0, -(a7)
1470: a963                 dc.w       $a963
1472: 4eba00a2             jsr        $1516(pc)
1476: 2e1f                 move.l     (a7)+, d7
1478: 4e5e                 unlk       a6
147a: 205f                 movea.l    (a7)+, a0
147c: 5c8f                 addq.l     #$6, a7
147e: 4ed0                 jmp        (a0)
1480: 4e560000             link.w     a6, #$0
1484: 0c6e0081000c         cmpi.w     #$81, $c(a6)
148a: 6604                 bne.b      $1490
148c: 7000                 moveq      #$0, d0
148e: 6006                 bra.b      $1496
1490: 41ed044a             lea.l      $44a(a5), a0
1494: 2008                 move.l     a0, d0
1496: 4e5e                 unlk       a6
1498: 4e75                 rts        
149a: 4e560000             link.w     a6, #$0
149e: 4eba0076             jsr        $1516(pc)
14a2: 4e5e                 unlk       a6
14a4: 4e75                 rts        
14a6: 4e56fffa             link.w     a6, #$fffa
14aa: 2f07                 move.l     d7, -(a7)
14ac: 42a7                 clr.l      -(a7)
14ae: 206ddec2             movea.l    -$213e(a5), a0
14b2: 2f2800ca             move.l     $ca(a0), -(a7)
14b6: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
14ba: 2d5ffffa             move.l     (a7)+, -$6(a6)
14be: 48780006             pea.l      $6.w
14c2: 2f2efffa             move.l     -$6(a6), -(a7)
14c6: 4ead004a             jsr        $4a(a5) ; CODE1+0124
14ca: 3e00                 move.w     d0, d7
14cc: 0647ffea             addi.w     #$ffea, d7
14d0: 2007                 move.l     d7, d0
14d2: 48c0                 ext.l      d0
14d4: 81fc0002             divs.w     #$2, d0
14d8: 4840                 swap       d0
14da: de40                 add.w      d0, d7
14dc: 4267                 clr.w      -(a7)
14de: 2f2ddec6             move.l     -$213a(a5), -(a7)
14e2: a960                 dc.w       $a960
14e4: be5f                 cmp.w      (a7)+, d7
14e6: 6728                 beq.b      $1510
14e8: 4a47                 tst.w      d7
14ea: 6d24                 blt.b      $1510
14ec: 2f2ddec6             move.l     -$213a(a5), -(a7)
14f0: 3f07                 move.w     d7, -(a7)
14f2: a965                 dc.w       $a965
14f4: 2f2ddec6             move.l     -$213a(a5), -(a7)
14f8: 3f07                 move.w     d7, -(a7)
14fa: a963                 dc.w       $a963
14fc: 3b47ef00             move.w     d7, -$1100(a5)
1500: 2f2ddec2             move.l     -$213e(a5), -(a7)
1504: a873                 dc.w       $a873
1506: 206dde80             movea.l    -$2180(a5), a0
150a: 4868003e             pea.l      $3e(a0)
150e: a928                 dc.w       $a928
1510: 2e1f                 move.l     (a7)+, d7
1512: 4e5e                 unlk       a6
1514: 4e75                 rts        
1516: 48e70300             movem.l    d6-d7, -(a7)
151a: 4267                 clr.w      -(a7)
151c: 2f2ddec6             move.l     -$213a(a5), -(a7)
1520: a960                 dc.w       $a960
1522: 3e1f                 move.w     (a7)+, d7
1524: 2c07                 move.l     d7, d6
1526: 48c6                 ext.l      d6
1528: 8dfc0002             divs.w     #$2, d6
152c: 4846                 swap       d6
152e: 4a46                 tst.w      d6
1530: 670a                 beq.b      $153c
1532: 9e46                 sub.w      d6, d7
1534: 2f2ddec6             move.l     -$213a(a5), -(a7)
1538: 3f07                 move.w     d7, -(a7)
153a: a963                 dc.w       $a963
153c: be6def00             cmp.w      -$1100(a5), d7
1540: 6712                 beq.b      $1554
1542: 302def00             move.w     -$1100(a5), d0
1546: 9047                 sub.w      d7, d0
1548: 3f00                 move.w     d0, -(a7)
154a: 4eba000e             jsr        $155a(pc)
154e: 3b47ef00             move.w     d7, -$1100(a5)
1552: 548f                 addq.l     #$2, a7
1554: 4cdf00c0             movem.l    (a7)+, d6-d7
1558: 4e75                 rts        
155a: 4e56fff4             link.w     a6, #$fff4
155e: 48e70708             movem.l    d5-d7/a4, -(a7)
1562: 3e2e0008             move.w     $8(a6), d7
1566: 206dde80             movea.l    -$2180(a5), a0
156a: 2d68003efff4         move.l     $3e(a0), -$c(a6)
1570: 2d680042fff8         move.l     $42(a0), -$8(a6)
1576: 2f2ddec2             move.l     -$213e(a5), -(a7)
157a: a873                 dc.w       $a873
157c: 486efff4             pea.l      -$c(a6)
1580: 2f3c00020002         move.l     #$20002, -(a7)
1586: a8a9                 dc.w       $a8a9
1588: 066e000dfff4         addi.w     #$d, -$c(a6)
158e: 046e0010fffa         subi.w     #$10, -$6(a6)
1594: 0c470016             cmpi.w     #$16, d7
1598: 6f02                 ble.b      $159c
159a: 7e16                 moveq      #$16, d7
159c: 42a7                 clr.l      -(a7)
159e: a8d8                 dc.w       $a8d8
15a0: 285f                 movea.l    (a7)+, a4
15a2: 486efff4             pea.l      -$c(a6)
15a6: 4267                 clr.w      -(a7)
15a8: 2007                 move.l     d7, d0
15aa: 48c0                 ext.l      d0
15ac: 81fc0002             divs.w     #$2, d0
15b0: 4840                 swap       d0
15b2: d047                 add.w      d7, d0
15b4: 48c0                 ext.l      d0
15b6: 81fc0002             divs.w     #$2, d0
15ba: c1fc000c             muls.w     #$c, d0
15be: 3f00                 move.w     d0, -(a7)
15c0: 2f0c                 move.l     a4, -(a7)
15c2: a8ef                 dc.w       $a8ef
15c4: 2f0c                 move.l     a4, -(a7)
15c6: a8d9                 dc.w       $a8d9
15c8: 4267                 clr.w      -(a7)
15ca: 2f2ddec6             move.l     -$213a(a5), -(a7)
15ce: a960                 dc.w       $a960
15d0: 3c1f                 move.w     (a7)+, d6
15d2: 3a07                 move.w     d7, d5
15d4: da46                 add.w      d6, d5
15d6: 4a47                 tst.w      d7
15d8: 6f08                 ble.b      $15e2
15da: 3e05                 move.w     d5, d7
15dc: 3a06                 move.w     d6, d5
15de: 3c07                 move.w     d7, d6
15e0: 6008                 bra.b      $15ea
15e2: 06450016             addi.w     #$16, d5
15e6: 06460016             addi.w     #$16, d6
15ea: 3f06                 move.w     d6, -(a7)
15ec: 3f05                 move.w     d5, -(a7)
15ee: 4ebaf734             jsr        $d24(pc)
15f2: 4cee10e0ffe4         movem.l    -$1c(a6), d5-d7/a4
15f8: 4e5e                 unlk       a6
15fa: 4e75                 rts        
15fc: 4e56fff8             link.w     a6, #$fff8
1600: 48e70138             movem.l    d7/a2-a4, -(a7)
1604: 3e2e0008             move.w     $8(a6), d7
1608: 4a47                 tst.w      d7
160a: 6d000098             blt.w      $16a4
160e: 2007                 move.l     d7, d0
1610: 48c0                 ext.l      d0
1612: 81fc0002             divs.w     #$2, d0
1616: 4840                 swap       d0
1618: 4a40                 tst.w      d0
161a: 6732                 beq.b      $164e
161c: 7044                 moveq      #$44, d0
161e: d0adde80             add.l      -$2180(a5), d0
1622: 2840                 movea.l    d0, a4
1624: 703e                 moveq      #$3e, d0
1626: d0adde80             add.l      -$2180(a5), d0
162a: 2640                 movea.l    d0, a3
162c: 70ef                 moveq      #$ef, d0
162e: d054                 add.w      (a4), d0
1630: 3d40fffe             move.w     d0, -$2(a6)
1634: 206dde80             movea.l    -$2180(a5), a0
1638: 30280040             move.w     $40(a0), d0
163c: d054                 add.w      (a4), d0
163e: 5540                 subq.w     #$2, d0
1640: 48c0                 ext.l      d0
1642: 81fc0002             divs.w     #$2, d0
1646: 5240                 addq.w     #$1, d0
1648: 3d40fffa             move.w     d0, -$6(a6)
164c: 6030                 bra.b      $167e
164e: 7040                 moveq      #$40, d0
1650: d0adde80             add.l      -$2180(a5), d0
1654: 2440                 movea.l    d0, a2
1656: 703e                 moveq      #$3e, d0
1658: d0adde80             add.l      -$2180(a5), d0
165c: 2640                 movea.l    d0, a3
165e: 700f                 moveq      #$f, d0
1660: d052                 add.w      (a2), d0
1662: 3d40fffa             move.w     d0, -$6(a6)
1666: 206dde80             movea.l    -$2180(a5), a0
166a: 30280044             move.w     $44(a0), d0
166e: d052                 add.w      (a2), d0
1670: 5540                 subq.w     #$2, d0
1672: 48c0                 ext.l      d0
1674: 81fc0002             divs.w     #$2, d0
1678: 5340                 subq.w     #$1, d0
167a: 3d40fffe             move.w     d0, -$2(a6)
167e: 2007                 move.l     d7, d0
1680: 48c0                 ext.l      d0
1682: 81fc0002             divs.w     #$2, d0
1686: c1fc000c             muls.w     #$c, d0
168a: d053                 add.w      (a3), d0
168c: 0640000f             addi.w     #$f, d0
1690: 3d40fff8             move.w     d0, -$8(a6)
1694: 700c                 moveq      #$c, d0
1696: d06efff8             add.w      -$8(a6), d0
169a: 3d40fffc             move.w     d0, -$4(a6)
169e: 486efff8             pea.l      -$8(a6)
16a2: a8a3                 dc.w       $a8a3
16a4: 4cdf1c80             movem.l    (a7)+, d7/a2-a4
16a8: 4e5e                 unlk       a6
16aa: 4e75                 rts        
16ac: 4e56fff4             link.w     a6, #$fff4
16b0: 48e70308             movem.l    d6-d7/a4, -(a7)
16b4: 3e2e0008             move.w     $8(a6), d7
16b8: 4a47                 tst.w      d7
16ba: 6d7a                 blt.b      $1736
16bc: 2c07                 move.l     d7, d6
16be: 48c6                 ext.l      d6
16c0: 8dfc0002             divs.w     #$2, d6
16c4: 4846                 swap       d6
16c6: 4a46                 tst.w      d6
16c8: 6704                 beq.b      $16ce
16ca: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
16ce: 486efff4             pea.l      -$c(a6)
16d2: a89a                 dc.w       $a89a
16d4: 3d6efff6fffa         move.w     -$a(a6), -$6(a6)
16da: 4a46                 tst.w      d6
16dc: 6714                 beq.b      $16f2
16de: 703e                 moveq      #$3e, d0
16e0: d0adde80             add.l      -$2180(a5), d0
16e4: 2840                 movea.l    d0, a4
16e6: 70ef                 moveq      #$ef, d0
16e8: d06c0006             add.w      $6(a4), d0
16ec: 3d40fffe             move.w     d0, -$2(a6)
16f0: 601e                 bra.b      $1710
16f2: 703e                 moveq      #$3e, d0
16f4: d0adde80             add.l      -$2180(a5), d0
16f8: 2840                 movea.l    d0, a4
16fa: 302c0002             move.w     $2(a4), d0
16fe: d06c0006             add.w      $6(a4), d0
1702: 5540                 subq.w     #$2, d0
1704: 48c0                 ext.l      d0
1706: 81fc0002             divs.w     #$2, d0
170a: 5340                 subq.w     #$1, d0
170c: 3d40fffe             move.w     d0, -$2(a6)
1710: 2007                 move.l     d7, d0
1712: 48c0                 ext.l      d0
1714: 81fc0002             divs.w     #$2, d0
1718: c1fc000c             muls.w     #$c, d0
171c: d054                 add.w      (a4), d0
171e: 0640000f             addi.w     #$f, d0
1722: 3d40fff8             move.w     d0, -$8(a6)
1726: 700c                 moveq      #$c, d0
1728: d06efff8             add.w      -$8(a6), d0
172c: 3d40fffc             move.w     d0, -$4(a6)
1730: 486efff8             pea.l      -$8(a6)
1734: a8a3                 dc.w       $a8a3
1736: 4cdf10c0             movem.l    (a7)+, d6-d7/a4
173a: 4e5e                 unlk       a6
173c: 4e75                 rts        
173e: 4e56fff2             link.w     a6, #$fff2
1742: 2f0c                 move.l     a4, -(a7)
1744: 4a6e0008             tst.w      $8(a6)
1748: 6d76                 blt.b      $17c0
174a: 486efff4             pea.l      -$c(a6)
174e: a89a                 dc.w       $a89a
1750: 3d6efff6fffe         move.w     -$a(a6), -$2(a6)
1756: 302e0008             move.w     $8(a6), d0
175a: 48c0                 ext.l      d0
175c: 81fc0002             divs.w     #$2, d0
1760: 4840                 swap       d0
1762: 4a40                 tst.w      d0
1764: 6720                 beq.b      $1786
1766: 703e                 moveq      #$3e, d0
1768: d0adde80             add.l      -$2180(a5), d0
176c: 2840                 movea.l    d0, a4
176e: 302c0002             move.w     $2(a4), d0
1772: d06c0006             add.w      $6(a4), d0
1776: 5540                 subq.w     #$2, d0
1778: 48c0                 ext.l      d0
177a: 81fc0002             divs.w     #$2, d0
177e: 5240                 addq.w     #$1, d0
1780: 3d40fffa             move.w     d0, -$6(a6)
1784: 6012                 bra.b      $1798
1786: 703e                 moveq      #$3e, d0
1788: d0adde80             add.l      -$2180(a5), d0
178c: 2840                 movea.l    d0, a4
178e: 700f                 moveq      #$f, d0
1790: d06c0002             add.w      $2(a4), d0
1794: 3d40fffa             move.w     d0, -$6(a6)
1798: 302e0008             move.w     $8(a6), d0
179c: 48c0                 ext.l      d0
179e: 81fc0002             divs.w     #$2, d0
17a2: c1fc000c             muls.w     #$c, d0
17a6: d054                 add.w      (a4), d0
17a8: 0640000f             addi.w     #$f, d0
17ac: 3d40fff8             move.w     d0, -$8(a6)
17b0: 700c                 moveq      #$c, d0
17b2: d06efff8             add.w      -$8(a6), d0
17b6: 3d40fffc             move.w     d0, -$4(a6)
17ba: 486efff8             pea.l      -$8(a6)
17be: a8a3                 dc.w       $a8a3
17c0: 285f                 movea.l    (a7)+, a4
17c2: 4e5e                 unlk       a6
17c4: 4e75                 rts        
17c6: 4e56fff0             link.w     a6, #$fff0
17ca: 48e70118             movem.l    d7/a3-a4, -(a7)
17ce: 3e2e0008             move.w     $8(a6), d7
17d2: 0c47000b             cmpi.w     #$b, d7
17d6: 6c000088             bge.w      $1860
17da: 4a47                 tst.w      d7
17dc: 6d000082             blt.w      $1860
17e0: 7040                 moveq      #$40, d0
17e2: d0adde80             add.l      -$2180(a5), d0
17e6: 2840                 movea.l    d0, a4
17e8: 703e                 moveq      #$3e, d0
17ea: d0adde80             add.l      -$2180(a5), d0
17ee: 2640                 movea.l    d0, a3
17f0: 7002                 moveq      #$2, d0
17f2: d054                 add.w      (a4), d0
17f4: 3d40fff2             move.w     d0, -$e(a6)
17f8: 700e                 moveq      #$e, d0
17fa: d054                 add.w      (a4), d0
17fc: 3d40fff6             move.w     d0, -$a(a6)
1800: 700c                 moveq      #$c, d0
1802: c1c7                 muls.w     d7, d0
1804: d053                 add.w      (a3), d0
1806: 0640000f             addi.w     #$f, d0
180a: 3d40fff0             move.w     d0, -$10(a6)
180e: 700c                 moveq      #$c, d0
1810: d06efff0             add.w      -$10(a6), d0
1814: 3d40fff4             move.w     d0, -$c(a6)
1818: 4a6e000a             tst.w      $a(a6)
181c: 673c                 beq.b      $185a
181e: 3f2e000a             move.w     $a(a6), -(a7)
1822: 486df10e             pea.l      -$ef2(a5)
1826: 486efff9             pea.l      -$7(a6)
182a: 4ead0812             jsr        $812(a5) ; CODE24+16a6
182e: 1d40fff8             move.b     d0, -$8(a6)
1832: 4257                 clr.w      (a7)
1834: 486efff8             pea.l      -$8(a6)
1838: a88c                 dc.w       $a88c
183a: 301f                 move.w     (a7)+, d0
183c: 916efff6             sub.w      d0, -$a(a6)
1840: 3eaefff6             move.w     -$a(a6), (a7)
1844: 70fe                 moveq      #$fe, d0
1846: d06efff4             add.w      -$c(a6), d0
184a: 3f00                 move.w     d0, -(a7)
184c: a893                 dc.w       $a893
184e: 536efff6             subq.w     #$1, -$a(a6)
1852: 486efff8             pea.l      -$8(a6)
1856: a884                 dc.w       $a884
1858: 5c8f                 addq.l     #$6, a7
185a: 486efff0             pea.l      -$10(a6)
185e: a8a3                 dc.w       $a8a3
1860: 4cdf1880             movem.l    (a7)+, d7/a3-a4
1864: 4e5e                 unlk       a6
1866: 4e75                 rts        
1868: 4e560000             link.w     a6, #$0
186c: 4ebaefa0             jsr        $80e(pc)
1870: 4e5e                 unlk       a6
1872: 4e75                 rts        
1874: 2f2ddec2             move.l     -$213e(a5), -(a7)
1878: 3f3c0003             move.w     #$3, -(a7)
187c: a827                 dc.w       $a827
187e: 4e75                 rts        
1880: 2f2ddec2             move.l     -$213e(a5), -(a7)
1884: 3f3c0004             move.w     #$4, -(a7)
1888: a827                 dc.w       $a827
188a: 2f2ddec2             move.l     -$213e(a5), -(a7)
188e: 3f3c0002             move.w     #$2, -(a7)
1892: a828                 dc.w       $a828
1894: 206dded2             movea.l    -$212e(a5), a0
1898: 2050                 movea.l    (a0), a0
189a: 42280010             clr.b      $10(a0)
189e: 206ddec6             movea.l    -$213a(a5), a0
18a2: 2050                 movea.l    (a0), a0
18a4: 117c00ff0010         move.b     #$ff, $10(a0)
18aa: 2f2ddec2             move.l     -$213e(a5), -(a7)
18ae: 4ead05c2             jsr        $5c2(a5) ; CODE9+0192
18b2: 42adefda             clr.l      -$1026(a5)
18b6: 588f                 addq.l     #$4, a7
18b8: 4e75                 rts        
18ba: 206dded2             movea.l    -$212e(a5), a0
18be: 2050                 movea.l    (a0), a0
18c0: 117c00ff0010         move.b     #$ff, $10(a0)
18c6: 206ddec6             movea.l    -$213a(a5), a0
18ca: 2050                 movea.l    (a0), a0
18cc: 42280010             clr.b      $10(a0)
18d0: 2f2ddec6             move.l     -$213a(a5), -(a7)
18d4: a96d                 dc.w       $a96d
18d6: 2f2ddec2             move.l     -$213e(a5), -(a7)
18da: 3f3c0004             move.w     #$4, -(a7)
18de: a828                 dc.w       $a828
18e0: 2f2ddec2             move.l     -$213e(a5), -(a7)
18e4: 3f3c0002             move.w     #$2, -(a7)
18e8: a827                 dc.w       $a827
18ea: 2f2ddec2             move.l     -$213e(a5), -(a7)
18ee: 4ead05c2             jsr        $5c2(a5) ; CODE9+0192
18f2: 42adefda             clr.l      -$1026(a5)
18f6: 588f                 addq.l     #$4, a7
18f8: 4e75                 rts        
18fa: 2038016a             move.l     $16a.w, d0
18fe: 4e75                 rts        
1900: 41edd72a             lea.l      -$28d6(a5), a0
1904: 2008                 move.l     a0, d0
1906: 4e75                 rts        
1908: 4e560000             link.w     a6, #$0
190c: 2f0c                 move.l     a4, -(a7)
190e: 286e0008             movea.l    $8(a6), a4
1912: 1014                 move.b     (a4), d0
1914: 4880                 ext.w      d0
1916: 42340001             clr.b      $1(a4, d0.w)
191a: 2f0c                 move.l     a4, -(a7)
191c: 486dd72a             pea.l      -$28d6(a5)
1920: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
1924: 2eaddec2             move.l     -$213e(a5), (a7)
1928: 2f0c                 move.l     a4, -(a7)
192a: a91a                 dc.w       $a91a
192c: 286efffc             movea.l    -$4(a6), a4
1930: 4e5e                 unlk       a6
1932: 4e75                 rts        
1934: 4e56fffc             link.w     a6, #$fffc
1938: 2f07                 move.l     d7, -(a7)
193a: 4a6dde5e             tst.w      -$21a2(a5)
193e: 672e                 beq.b      $196e
1940: 486efffc             pea.l      -$4(a6)
1944: a972                 dc.w       $a972
1946: 4227                 clr.b      -(a7)
1948: 2f2efffc             move.l     -$4(a6), -(a7)
194c: 206dde80             movea.l    -$2180(a5), a0
1950: 48680012             pea.l      $12(a0)
1954: a8ad                 dc.w       $a8ad
1956: 7e00                 moveq      #$0, d7
1958: 1e1f                 move.b     (a7)+, d7
195a: be6def02             cmp.w      -$10fe(a5), d7
195e: 670a                 beq.b      $196a
1960: 206dde80             movea.l    -$2180(a5), a0
1964: 48680012             pea.l      $12(a0)
1968: a8a4                 dc.w       $a8a4
196a: 3b47ef02             move.w     d7, -$10fe(a5)
196e: 2e1f                 move.l     (a7)+, d7
1970: 4e5e                 unlk       a6
1972: 4e75                 rts        
1974: 4e56fffc             link.w     a6, #$fffc
1978: 42a7                 clr.l      -(a7)
197a: 206ddec2             movea.l    -$213e(a5), a0
197e: 2f2800ca             move.l     $ca(a0), -(a7)
1982: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
1986: 2d5ffffc             move.l     (a7)+, -$4(a6)
198a: 48780006             pea.l      $6.w
198e: 2f2efffc             move.l     -$4(a6), -(a7)
1992: 4ead004a             jsr        $4a(a5) ; CODE1+0124
1996: 5380                 subq.l     #$1, d0
1998: 4e5e                 unlk       a6
199a: 4e75                 rts        
199c: 4e56ff9a             link.w     a6, #$ff9a
19a0: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
19a4: 286e000c             movea.l    $c(a6), a4
19a8: 202e0008             move.l     $8(a6), d0
19ac: b0addec2             cmp.l      -$213e(a5), d0
19b0: 6704                 beq.b      $19b6
19b2: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
19b6: 2f2e0008             move.l     $8(a6), -(a7)
19ba: a873                 dc.w       $a873
19bc: 2d6c000affd8         move.l     $a(a4), -$28(a6)
19c2: 486effd8             pea.l      -$28(a6)
19c6: a871                 dc.w       $a871
19c8: 4eba16d8             jsr        $30a2(pc)
19cc: 4a40                 tst.w      d0
19ce: 670000a4             beq.w      $1a74
19d2: 4227                 clr.b      -(a7)
19d4: 2f2effd8             move.l     -$28(a6), -(a7)
19d8: 486defb2             pea.l      -$104e(a5)
19dc: a8ad                 dc.w       $a8ad
19de: 4a1f                 tst.b      (a7)+
19e0: 6712                 beq.b      $19f4
19e2: 42a7                 clr.l      -(a7)
19e4: 3f3c0082             move.w     #$82, -(a7)
19e8: a9b9                 dc.w       $a9b9
19ea: 205f                 movea.l    (a7)+, a0
19ec: 2b50efda             move.l     (a0), -$1026(a5)
19f0: 60000082             bra.w      $1a74
19f4: 4227                 clr.b      -(a7)
19f6: 2f2effd8             move.l     -$28(a6), -(a7)
19fa: 486defba             pea.l      -$1046(a5)
19fe: a8ad                 dc.w       $a8ad
1a00: 4a1f                 tst.b      (a7)+
1a02: 6710                 beq.b      $1a14
1a04: 42a7                 clr.l      -(a7)
1a06: 3f3c0080             move.w     #$80, -(a7)
1a0a: a9b9                 dc.w       $a9b9
1a0c: 205f                 movea.l    (a7)+, a0
1a0e: 2b50efda             move.l     (a0), -$1026(a5)
1a12: 6060                 bra.b      $1a74
1a14: 4227                 clr.b      -(a7)
1a16: 2f2effd8             move.l     -$28(a6), -(a7)
1a1a: 486defc2             pea.l      -$103e(a5)
1a1e: a8ad                 dc.w       $a8ad
1a20: 4a1f                 tst.b      (a7)+
1a22: 6710                 beq.b      $1a34
1a24: 42a7                 clr.l      -(a7)
1a26: 3f3c0083             move.w     #$83, -(a7)
1a2a: a9b9                 dc.w       $a9b9
1a2c: 205f                 movea.l    (a7)+, a0
1a2e: 2b50efda             move.l     (a0), -$1026(a5)
1a32: 6040                 bra.b      $1a74
1a34: 4227                 clr.b      -(a7)
1a36: 2f2effd8             move.l     -$28(a6), -(a7)
1a3a: 486defca             pea.l      -$1036(a5)
1a3e: a8ad                 dc.w       $a8ad
1a40: 4a1f                 tst.b      (a7)+
1a42: 6710                 beq.b      $1a54
1a44: 42a7                 clr.l      -(a7)
1a46: 3f3c0081             move.w     #$81, -(a7)
1a4a: a9b9                 dc.w       $a9b9
1a4c: 205f                 movea.l    (a7)+, a0
1a4e: 2b50efda             move.l     (a0), -$1026(a5)
1a52: 6020                 bra.b      $1a74
1a54: 4227                 clr.b      -(a7)
1a56: 2f2effd8             move.l     -$28(a6), -(a7)
1a5a: 486defd2             pea.l      -$102e(a5)
1a5e: a8ad                 dc.w       $a8ad
1a60: 4a1f                 tst.b      (a7)+
1a62: 6700050a             beq.w      $1f6e
1a66: 42a7                 clr.l      -(a7)
1a68: 3f3c0084             move.w     #$84, -(a7)
1a6c: a9b9                 dc.w       $a9b9
1a6e: 205f                 movea.l    (a7)+, a0
1a70: 2b50efda             move.l     (a0), -$1026(a5)
1a74: 206ddec2             movea.l    -$213e(a5), a0
1a78: 2d6800a0ff9e         move.l     $a0(a0), -$62(a6)
1a7e: 4a6dd9ae             tst.w      -$2652(a5)
1a82: 670000ac             beq.w      $1b30
1a86: 2f2ddec2             move.l     -$213e(a5), -(a7)
1a8a: 3f3c0003             move.w     #$3, -(a7)
1a8e: 486effc4             pea.l      -$3c(a6)
1a92: 486effa2             pea.l      -$5e(a6)
1a96: 486effaa             pea.l      -$56(a6)
1a9a: a98d                 dc.w       $a98d
1a9c: 4227                 clr.b      -(a7)
1a9e: 2f2effd8             move.l     -$28(a6), -(a7)
1aa2: 486effaa             pea.l      -$56(a6)
1aa6: a8ad                 dc.w       $a8ad
1aa8: 4a1f                 tst.b      (a7)+
1aaa: 6732                 beq.b      $1ade
1aac: 0c6d0001d9ae         cmpi.w     #$1, -$2652(a5)
1ab2: 6706                 beq.b      $1aba
1ab4: 2f2eff9e             move.l     -$62(a6), -(a7)
1ab8: a9d8                 dc.w       $a9d8
1aba: 2f2effd8             move.l     -$28(a6), -(a7)
1abe: 082c0001000e         btst.b     #$1, $e(a4)
1ac4: 6704                 beq.b      $1aca
1ac6: 7001                 moveq      #$1, d0
1ac8: 6002                 bra.b      $1acc
1aca: 7000                 moveq      #$0, d0
1acc: 1f00                 move.b     d0, -(a7)
1ace: 2f2eff9e             move.l     -$62(a6), -(a7)
1ad2: a9d4                 dc.w       $a9d4
1ad4: 3b7c0001d9ae         move.w     #$1, -$2652(a5)
1ada: 60000a12             bra.w      $24ee
1ade: 486effcc             pea.l      -$34(a6)
1ae2: 486effce             pea.l      -$32(a6)
1ae6: 486effd8             pea.l      -$28(a6)
1aea: 4ead03f2             jsr        $3f2(a5) ; CODE20+0586
1aee: 4a6effce             tst.w      -$32(a6)
1af2: 4fef000c             lea.l      $c(a7), a7
1af6: 6f38                 ble.b      $1b30
1af8: 0c6e000fffce         cmpi.w     #$f, -$32(a6)
1afe: 6e30                 bgt.b      $1b30
1b00: 4a6effcc             tst.w      -$34(a6)
1b04: 6f2a                 ble.b      $1b30
1b06: 0c6e000fffcc         cmpi.w     #$f, -$34(a6)
1b0c: 6e22                 bgt.b      $1b30
1b0e: 0c6d0001d9ae         cmpi.w     #$1, -$2652(a5)
1b14: 6606                 bne.b      $1b1c
1b16: 2f2eff9e             move.l     -$62(a6), -(a7)
1b1a: a9d9                 dc.w       $a9d9
1b1c: 3f2effcc             move.w     -$34(a6), -(a7)
1b20: 3f2effce             move.w     -$32(a6), -(a7)
1b24: 4eba0a4a             jsr        $2570(pc)
1b28: 3b7c0002d9ae         move.w     #$2, -$2652(a5)
1b2e: 588f                 addq.l     #$4, a7
1b30: 486effaa             pea.l      -$56(a6)
1b34: 2f2effd8             move.l     -$28(a6), -(a7)
1b38: 4eba0f02             jsr        $2a3c(pc)
1b3c: 3e00                 move.w     d0, d7
1b3e: 0c47ffff             cmpi.w     #$ffff, d7
1b42: 508f                 addq.l     #$8, a7
1b44: 67000428             beq.w      $1f6e
1b48: 204d                 movea.l    a5, a0
1b4a: 2007                 move.l     d7, d0
1b4c: 48c0                 ext.l      d0
1b4e: e588                 lsl.l      #$2, d0
1b50: d1c0                 adda.l     d0, a0
1b52: 4a68de2a             tst.w      -$21d6(a0)
1b56: 670000c4             beq.w      $1c1c
1b5a: 204d                 movea.l    a5, a0
1b5c: 2007                 move.l     d7, d0
1b5e: 48c0                 ext.l      d0
1b60: e588                 lsl.l      #$2, d0
1b62: d1c0                 adda.l     d0, a0
1b64: 3f28de28             move.w     -$21d8(a0), -(a7)
1b68: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
1b6c: 1800                 move.b     d0, d4
1b6e: 1004                 move.b     d4, d0
1b70: 4880                 ext.w      d0
1b72: 3e80                 move.w     d0, (a7)
1b74: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
1b78: 3e80                 move.w     d0, (a7)
1b7a: 486da74e             pea.l      -$58b2(a5)
1b7e: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
1b82: 2640                 movea.l    d0, a3
1b84: 200b                 move.l     a3, d0
1b86: 5c8f                 addq.l     #$6, a7
1b88: 6604                 bne.b      $1b8e
1b8a: 600c                 bra.b      $1b98
1b8c: 528b                 addq.l     #$1, a3
1b8e: 16ab0001             move.b     $1(a3), (a3)
1b92: 66f8                 bne.b      $1b8c
1b94: 60000092             bra.w      $1c28
1b98: 7a01                 moveq      #$1, d5
1b9a: 6076                 bra.b      $1c12
1b9c: 7c01                 moveq      #$1, d6
1b9e: 606a                 bra.b      $1c0a
1ba0: 7011                 moveq      #$11, d0
1ba2: c1c5                 muls.w     d5, d0
1ba4: 41edd88d             lea.l      -$2773(a5), a0
1ba8: d088                 add.l      a0, d0
1baa: 3046                 movea.w    d6, a0
1bac: 7211                 moveq      #$11, d1
1bae: c3c5                 muls.w     d5, d1
1bb0: 43edd76c             lea.l      -$2894(a5), a1
1bb4: d289                 add.l      a1, d1
1bb6: 3246                 movea.w    d6, a1
1bb8: 12311800             move.b     (a1, d1.l), d1
1bbc: b2300800             cmp.b      (a0, d0.l), d1
1bc0: 6746                 beq.b      $1c08
1bc2: 7011                 moveq      #$11, d0
1bc4: c1c5                 muls.w     d5, d0
1bc6: 41edd76c             lea.l      -$2894(a5), a0
1bca: d088                 add.l      a0, d0
1bcc: 3046                 movea.w    d6, a0
1bce: b8300800             cmp.b      (a0, d0.l), d4
1bd2: 6722                 beq.b      $1bf6
1bd4: 0c04003f             cmpi.b     #$3f, d4
1bd8: 662e                 bne.b      $1c08
1bda: 7011                 moveq      #$11, d0
1bdc: c1c5                 muls.w     d5, d0
1bde: 41edd76c             lea.l      -$2894(a5), a0
1be2: d088                 add.l      a0, d0
1be4: 3046                 movea.w    d6, a0
1be6: 7200                 moveq      #$0, d1
1be8: 12300800             move.b     (a0, d0.l), d1
1bec: 204d                 movea.l    a5, a0
1bee: d1c1                 adda.l     d1, a0
1bf0: 4a28fbd8             tst.b      -$428(a0)
1bf4: 6a12                 bpl.b      $1c08
1bf6: 42a7                 clr.l      -(a7)
1bf8: 4267                 clr.w      -(a7)
1bfa: 3f06                 move.w     d6, -(a7)
1bfc: 3f05                 move.w     d5, -(a7)
1bfe: 4ebae4fc             jsr        $fc(pc)
1c02: 4fef000a             lea.l      $a(a7), a7
1c06: 6020                 bra.b      $1c28
1c08: 5246                 addq.w     #$1, d6
1c0a: 0c460010             cmpi.w     #$10, d6
1c0e: 6d90                 blt.b      $1ba0
1c10: 5245                 addq.w     #$1, d5
1c12: 0c450010             cmpi.w     #$10, d5
1c16: 6d84                 blt.b      $1b9c
1c18: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
1c1c: 3f3c0001             move.w     #$1, -(a7)
1c20: 3f07                 move.w     d7, -(a7)
1c22: 4ebae974             jsr        $598(pc)
1c26: 588f                 addq.l     #$4, a7
1c28: 206ddec2             movea.l    -$213e(a5), a0
1c2c: 2d680010ffb2         move.l     $10(a0), -$4e(a6)
1c32: 2d680014ffb6         move.l     $14(a0), -$4a(a6)
1c38: 2d680010ffba         move.l     $10(a0), -$46(a6)
1c3e: 2d680014ffbe         move.l     $14(a0), -$42(a6)
1c44: 302effac             move.w     -$54(a6), d0
1c48: d06effb0             add.w      -$50(a6), d0
1c4c: 48c0                 ext.l      d0
1c4e: 81fc0002             divs.w     #$2, d0
1c52: 3d40ffda             move.w     d0, -$26(a6)
1c56: 302effaa             move.w     -$56(a6), d0
1c5a: d06effae             add.w      -$52(a6), d0
1c5e: 48c0                 ext.l      d0
1c60: 81fc0002             divs.w     #$2, d0
1c64: 3d40ffd8             move.w     d0, -$28(a6)
1c68: 42a7                 clr.l      -(a7)
1c6a: a8d8                 dc.w       $a8d8
1c6c: 245f                 movea.l    (a7)+, a2
1c6e: 2f0a                 move.l     a2, -(a7)
1c70: 486effaa             pea.l      -$56(a6)
1c74: a8df                 dc.w       $a8df
1c76: 426def02             clr.w      -$10fe(a5)
1c7a: 42a7                 clr.l      -(a7)
1c7c: 2f0a                 move.l     a2, -(a7)
1c7e: 2f2effd8             move.l     -$28(a6), -(a7)
1c82: 486effb2             pea.l      -$4e(a6)
1c86: 486effba             pea.l      -$46(a6)
1c8a: 4267                 clr.w      -(a7)
1c8c: 486d0452             pea.l      $452(a5)
1c90: a905                 dc.w       $a905
1c92: 2d5fffa6             move.l     (a7)+, -$5a(a6)
1c96: 4a6def02             tst.w      -$10fe(a5)
1c9a: 670a                 beq.b      $1ca6
1c9c: 206dde80             movea.l    -$2180(a5), a0
1ca0: 48680012             pea.l      $12(a0)
1ca4: a8a4                 dc.w       $a8a4
1ca6: 2f0a                 move.l     a2, -(a7)
1ca8: a8d9                 dc.w       $a8d9
1caa: 4267                 clr.w      -(a7)
1cac: 2f2effa6             move.l     -$5a(a6), -(a7)
1cb0: a86b                 dc.w       $a86b
1cb2: 302effda             move.w     -$26(a6), d0
1cb6: d05f                 add.w      (a7)+, d0
1cb8: 3d40ffd6             move.w     d0, -$2a(a6)
1cbc: 4267                 clr.w      -(a7)
1cbe: 2f2effa6             move.l     -$5a(a6), -(a7)
1cc2: a86a                 dc.w       $a86a
1cc4: 302effd8             move.w     -$28(a6), d0
1cc8: d05f                 add.w      (a7)+, d0
1cca: 3d40ffd4             move.w     d0, -$2c(a6)
1cce: 486effd4             pea.l      -$2c(a6)
1cd2: a870                 dc.w       $a870
1cd4: 4267                 clr.w      -(a7)
1cd6: 2f2effd4             move.l     -$2c(a6), -(a7)
1cda: 486e0008             pea.l      $8(a6)
1cde: a92c                 dc.w       $a92c
1ce0: 4aae0008             tst.l      $8(a6)
1ce4: 548f                 addq.l     #$2, a7
1ce6: 670007fe             beq.w      $24e6
1cea: 202e0008             move.l     $8(a6), d0
1cee: b0addec2             cmp.l      -$213e(a5), d0
1cf2: 660007f2             bne.w      $24e6
1cf6: 486effd4             pea.l      -$2c(a6)
1cfa: a871                 dc.w       $a871
1cfc: 4227                 clr.b      -(a7)
1cfe: 2f2effd4             move.l     -$2c(a6), -(a7)
1d02: 206dde80             movea.l    -$2180(a5), a0
1d06: 48680012             pea.l      $12(a0)
1d0a: a8ad                 dc.w       $a8ad
1d0c: 4a1f                 tst.b      (a7)+
1d0e: 670000b8             beq.w      $1dc8
1d12: 4ead0932             jsr        $932(a5) ; CODE31+0108
1d16: 4a40                 tst.w      d0
1d18: 670000ae             beq.w      $1dc8
1d1c: 41edc35e             lea.l      -$3ca2(a5), a0
1d20: b1edc376             cmpa.l     -$3c8a(a5), a0
1d24: 6608                 bne.b      $1d2e
1d26: 363c03ee             move.w     #$3ee, d3
1d2a: 600007b2             bra.w      $24de
1d2e: 7a01                 moveq      #$1, d5
1d30: 6038                 bra.b      $1d6a
1d32: 7c01                 moveq      #$1, d6
1d34: 602c                 bra.b      $1d62
1d36: 7011                 moveq      #$11, d0
1d38: c1c5                 muls.w     d5, d0
1d3a: 41edd88d             lea.l      -$2773(a5), a0
1d3e: d088                 add.l      a0, d0
1d40: 3046                 movea.w    d6, a0
1d42: 7211                 moveq      #$11, d1
1d44: c3c5                 muls.w     d5, d1
1d46: 43edd76c             lea.l      -$2894(a5), a1
1d4a: d289                 add.l      a1, d1
1d4c: 3246                 movea.w    d6, a1
1d4e: 12311800             move.b     (a1, d1.l), d1
1d52: b2300800             cmp.b      (a0, d0.l), d1
1d56: 6708                 beq.b      $1d60
1d58: 363c03ef             move.w     #$3ef, d3
1d5c: 60000780             bra.w      $24de
1d60: 5246                 addq.w     #$1, d6
1d62: 0c460010             cmpi.w     #$10, d6
1d66: 6dce                 blt.b      $1d36
1d68: 5245                 addq.w     #$1, d5
1d6a: 0c450010             cmpi.w     #$10, d5
1d6e: 6dc2                 blt.b      $1d32
1d70: 204d                 movea.l    a5, a0
1d72: 2007                 move.l     d7, d0
1d74: 48c0                 ext.l      d0
1d76: e588                 lsl.l      #$2, d0
1d78: d1c0                 adda.l     d0, a0
1d7a: 1828de29             move.b     -$21d7(a0), d4
1d7e: 47eda74e             lea.l      -$58b2(a5), a3
1d82: 6002                 bra.b      $1d86
1d84: 528b                 addq.l     #$1, a3
1d86: b813                 cmp.b      (a3), d4
1d88: 6dfa                 blt.b      $1d84
1d8a: 1c13                 move.b     (a3), d6
1d8c: 4886                 ext.w      d6
1d8e: 16c4                 move.b     d4, (a3)+
1d90: 1806                 move.b     d6, d4
1d92: 4a04                 tst.b      d4
1d94: 66f4                 bne.b      $1d8a
1d96: 4213                 clr.b      (a3)
1d98: 4a6dd9ae             tst.w      -$2652(a5)
1d9c: 66000750             bne.w      $24ee
1da0: 4267                 clr.w      -(a7)
1da2: 4ead017a             jsr        $17a(a5) ; CODE8+0374
1da6: 4a40                 tst.w      d0
1da8: 548f                 addq.l     #$2, a7
1daa: 670a                 beq.b      $1db6
1dac: 486da5ce             pea.l      -$5a32(a5)
1db0: 4ead02fa             jsr        $2fa(a5) ; CODE14+0186
1db4: 588f                 addq.l     #$4, a7
1db6: 48780022             pea.l      $22.w
1dba: 486da5ce             pea.l      -$5a32(a5)
1dbe: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
1dc2: 508f                 addq.l     #$8, a7
1dc4: 60000728             bra.w      $24ee
1dc8: 486effaa             pea.l      -$56(a6)
1dcc: 2f2effd4             move.l     -$2c(a6), -(a7)
1dd0: 4eba0c6a             jsr        $2a3c(pc)
1dd4: 3c00                 move.w     d0, d6
1dd6: 0c46ffff             cmpi.w     #$ffff, d6
1dda: 508f                 addq.l     #$8, a7
1ddc: 677a                 beq.b      $1e58
1dde: bc47                 cmp.w      d7, d6
1de0: 6d04                 blt.b      $1de6
1de2: 7001                 moveq      #$1, d0
1de4: 6002                 bra.b      $1de8
1de6: 70ff                 moveq      #$ff, d0
1de8: 3d40ffca             move.w     d0, -$36(a6)
1dec: 204d                 movea.l    a5, a0
1dee: 2207                 move.l     d7, d1
1df0: 48c1                 ext.l      d1
1df2: e589                 lsl.l      #$2, d1
1df4: d1c1                 adda.l     d1, a0
1df6: 2b68de28de48         move.l     -$21d8(a0), -$21b8(a5)
1dfc: 3a07                 move.w     d7, d5
1dfe: 602c                 bra.b      $1e2c
1e00: 306effca             movea.w    -$36(a6), a0
1e04: d0c5                 adda.w     d5, a0
1e06: 2008                 move.l     a0, d0
1e08: e588                 lsl.l      #$2, d0
1e0a: 2040                 movea.l    d0, a0
1e0c: 41e8de28             lea.l      -$21d8(a0), a0
1e10: d1cd                 adda.l     a5, a0
1e12: 224d                 movea.l    a5, a1
1e14: 2005                 move.l     d5, d0
1e16: 48c0                 ext.l      d0
1e18: e588                 lsl.l      #$2, d0
1e1a: d3c0                 adda.l     d0, a1
1e1c: 2350de28             move.l     (a0), -$21d8(a1)
1e20: 3f05                 move.w     d5, -(a7)
1e22: 4eba0cb6             jsr        $2ada(pc)
1e26: 548f                 addq.l     #$2, a7
1e28: da6effca             add.w      -$36(a6), d5
1e2c: bc45                 cmp.w      d5, d6
1e2e: 66d0                 bne.b      $1e00
1e30: 204d                 movea.l    a5, a0
1e32: 2006                 move.l     d6, d0
1e34: 48c0                 ext.l      d0
1e36: e588                 lsl.l      #$2, d0
1e38: d1c0                 adda.l     d0, a0
1e3a: 316dde48de28         move.w     -$21b8(a5), -$21d8(a0)
1e40: 204d                 movea.l    a5, a0
1e42: 2006                 move.l     d6, d0
1e44: 48c0                 ext.l      d0
1e46: e588                 lsl.l      #$2, d0
1e48: d1c0                 adda.l     d0, a0
1e4a: 4268de2a             clr.w      -$21d6(a0)
1e4e: 3f06                 move.w     d6, -(a7)
1e50: 4eba0c88             jsr        $2ada(pc)
1e54: 60000698             bra.w      $24ee
1e58: 486effcc             pea.l      -$34(a6)
1e5c: 486effce             pea.l      -$32(a6)
1e60: 486effd4             pea.l      -$2c(a6)
1e64: 4ead03f2             jsr        $3f2(a5) ; CODE20+0586
1e68: 0c6e0001ffce         cmpi.w     #$1, -$32(a6)
1e6e: 4fef000c             lea.l      $c(a7), a7
1e72: 6d000672             blt.w      $24e6
1e76: 0c6e000fffce         cmpi.w     #$f, -$32(a6)
1e7c: 6e000668             bgt.w      $24e6
1e80: 0c6e0001ffcc         cmpi.w     #$1, -$34(a6)
1e86: 6d00065e             blt.w      $24e6
1e8a: 0c6e000fffcc         cmpi.w     #$f, -$34(a6)
1e90: 6e000654             bgt.w      $24e6
1e94: 41edc35e             lea.l      -$3ca2(a5), a0
1e98: b1edc376             cmpa.l     -$3c8a(a5), a0
1e9c: 6608                 bne.b      $1ea6
1e9e: 363c03ee             move.w     #$3ee, d3
1ea2: 6000063a             bra.w      $24de
1ea6: 4a2da74e             tst.b      -$58b2(a5)
1eaa: 6708                 beq.b      $1eb4
1eac: 363c03ef             move.w     #$3ef, d3
1eb0: 6000062c             bra.w      $24de
1eb4: 7011                 moveq      #$11, d0
1eb6: c1eeffce             muls.w     -$32(a6), d0
1eba: d08d                 add.l      a5, d0
1ebc: 306effcc             movea.w    -$34(a6), a0
1ec0: d1c0                 adda.l     d0, a0
1ec2: 4a28d76c             tst.b      -$2894(a0)
1ec6: 6708                 beq.b      $1ed0
1ec8: 363c03ed             move.w     #$3ed, d3
1ecc: 60000610             bra.w      $24de
1ed0: 204d                 movea.l    a5, a0
1ed2: 2007                 move.l     d7, d0
1ed4: 48c0                 ext.l      d0
1ed6: e588                 lsl.l      #$2, d0
1ed8: d1c0                 adda.l     d0, a0
1eda: 4268de2a             clr.w      -$21d6(a0)
1ede: 204d                 movea.l    a5, a0
1ee0: 2007                 move.l     d7, d0
1ee2: 48c0                 ext.l      d0
1ee4: e588                 lsl.l      #$2, d0
1ee6: d1c0                 adda.l     d0, a0
1ee8: 0c68003fde28         cmpi.w     #$3f, -$21d8(a0)
1eee: 6636                 bne.b      $1f26
1ef0: 42a7                 clr.l      -(a7)
1ef2: 3f3c003f             move.w     #$3f, -(a7)
1ef6: 3f2effcc             move.w     -$34(a6), -(a7)
1efa: 3f2effce             move.w     -$32(a6), -(a7)
1efe: 4ebae1fc             jsr        $fc(pc)
1f02: 4eba1686             jsr        $358a(pc)
1f06: 2ebc00010001         move.l     #$10001, (a7)
1f0c: 102dde4c             move.b     -$21b4(a5), d0
1f10: 4880                 ext.w      d0
1f12: 3f00                 move.w     d0, -(a7)
1f14: 3f2effcc             move.w     -$34(a6), -(a7)
1f18: 3f2effce             move.w     -$32(a6), -(a7)
1f1c: 4ebae1de             jsr        $fc(pc)
1f20: 4fef0010             lea.l      $10(a7), a7
1f24: 602a                 bra.b      $1f50
1f26: 2f3c00010001         move.l     #$10001, -(a7)
1f2c: 204d                 movea.l    a5, a0
1f2e: 2007                 move.l     d7, d0
1f30: 48c0                 ext.l      d0
1f32: e588                 lsl.l      #$2, d0
1f34: d1c0                 adda.l     d0, a0
1f36: 3f28de28             move.w     -$21d8(a0), -(a7)
1f3a: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
1f3e: 3e80                 move.w     d0, (a7)
1f40: 3f2effcc             move.w     -$34(a6), -(a7)
1f44: 3f2effce             move.w     -$32(a6), -(a7)
1f48: 4ebae1b2             jsr        $fc(pc)
1f4c: 4fef000a             lea.l      $a(a7), a7
1f50: 204d                 movea.l    a5, a0
1f52: 2007                 move.l     d7, d0
1f54: 48c0                 ext.l      d0
1f56: e588                 lsl.l      #$2, d0
1f58: d1c0                 adda.l     d0, a0
1f5a: 4a68de2a             tst.w      -$21d6(a0)
1f5e: 6600058e             bne.w      $24ee
1f62: 3f07                 move.w     d7, -(a7)
1f64: 4eba0b74             jsr        $2ada(pc)
1f68: 548f                 addq.l     #$2, a7
1f6a: 60000582             bra.w      $24ee
1f6e: 486effcc             pea.l      -$34(a6)
1f72: 486effce             pea.l      -$32(a6)
1f76: 486effd8             pea.l      -$28(a6)
1f7a: 4ead03f2             jsr        $3f2(a5) ; CODE20+0586
1f7e: 4eba1122             jsr        $30a2(pc)
1f82: 4a40                 tst.w      d0
1f84: 4fef000c             lea.l      $c(a7), a7
1f88: 67000252             beq.w      $21dc
1f8c: 0c6e0001ffce         cmpi.w     #$1, -$32(a6)
1f92: 6d00055a             blt.w      $24ee
1f96: 0c6e000fffce         cmpi.w     #$f, -$32(a6)
1f9c: 6e000550             bgt.w      $24ee
1fa0: 0c6e0001ffcc         cmpi.w     #$1, -$34(a6)
1fa6: 6d000546             blt.w      $24ee
1faa: 0c6e000fffcc         cmpi.w     #$f, -$34(a6)
1fb0: 6e00053c             bgt.w      $24ee
1fb4: 4aadefda             tst.l      -$1026(a5)
1fb8: 67000212             beq.w      $21cc
1fbc: 42a7                 clr.l      -(a7)
1fbe: 3f3c0082             move.w     #$82, -(a7)
1fc2: a9b9                 dc.w       $a9b9
1fc4: 205f                 movea.l    (a7)+, a0
1fc6: 202defda             move.l     -$1026(a5), d0
1fca: b090                 cmp.l      (a0), d0
1fcc: 6658                 bne.b      $2026
1fce: 700f                 moveq      #$f, d0
1fd0: d06effcc             add.w      -$34(a6), d0
1fd4: c1fc0011             muls.w     #$11, d0
1fd8: d08d                 add.l      a5, d0
1fda: 306effce             movea.w    -$32(a6), a0
1fde: d1c0                 adda.l     d0, a0
1fe0: 7003                 moveq      #$3, d0
1fe2: 114097b2             move.b     d0, -$684e(a0)
1fe6: 7211                 moveq      #$11, d1
1fe8: c3eeffce             muls.w     -$32(a6), d1
1fec: d28d                 add.l      a5, d1
1fee: 306effcc             movea.w    -$34(a6), a0
1ff2: d1c1                 adda.l     d1, a0
1ff4: 114097b2             move.b     d0, -$684e(a0)
1ff8: 700f                 moveq      #$f, d0
1ffa: d06effcc             add.w      -$34(a6), d0
1ffe: c1fc0011             muls.w     #$11, d0
2002: d08d                 add.l      a5, d0
2004: 306effce             movea.w    -$32(a6), a0
2008: d1c0                 adda.l     d0, a0
200a: 7001                 moveq      #$1, d0
200c: 11409592             move.b     d0, -$6a6e(a0)
2010: 7211                 moveq      #$11, d1
2012: c3eeffce             muls.w     -$32(a6), d1
2016: d28d                 add.l      a5, d1
2018: 306effcc             movea.w    -$34(a6), a0
201c: d1c1                 adda.l     d1, a0
201e: 11409592             move.b     d0, -$6a6e(a0)
2022: 600001a8             bra.w      $21cc
2026: 42a7                 clr.l      -(a7)
2028: 3f3c0080             move.w     #$80, -(a7)
202c: a9b9                 dc.w       $a9b9
202e: 205f                 movea.l    (a7)+, a0
2030: 202defda             move.l     -$1026(a5), d0
2034: b090                 cmp.l      (a0), d0
2036: 6658                 bne.b      $2090
2038: 700f                 moveq      #$f, d0
203a: d06effcc             add.w      -$34(a6), d0
203e: c1fc0011             muls.w     #$11, d0
2042: d08d                 add.l      a5, d0
2044: 306effce             movea.w    -$32(a6), a0
2048: d1c0                 adda.l     d0, a0
204a: 7001                 moveq      #$1, d0
204c: 114097b2             move.b     d0, -$684e(a0)
2050: 7211                 moveq      #$11, d1
2052: c3eeffce             muls.w     -$32(a6), d1
2056: d28d                 add.l      a5, d1
2058: 306effcc             movea.w    -$34(a6), a0
205c: d1c1                 adda.l     d1, a0
205e: 114097b2             move.b     d0, -$684e(a0)
2062: 700f                 moveq      #$f, d0
2064: d06effcc             add.w      -$34(a6), d0
2068: c1fc0011             muls.w     #$11, d0
206c: d08d                 add.l      a5, d0
206e: 306effce             movea.w    -$32(a6), a0
2072: d1c0                 adda.l     d0, a0
2074: 7003                 moveq      #$3, d0
2076: 11409592             move.b     d0, -$6a6e(a0)
207a: 7211                 moveq      #$11, d1
207c: c3eeffce             muls.w     -$32(a6), d1
2080: d28d                 add.l      a5, d1
2082: 306effcc             movea.w    -$34(a6), a0
2086: d1c1                 adda.l     d1, a0
2088: 11409592             move.b     d0, -$6a6e(a0)
208c: 6000013e             bra.w      $21cc
2090: 42a7                 clr.l      -(a7)
2092: 3f3c0083             move.w     #$83, -(a7)
2096: a9b9                 dc.w       $a9b9
2098: 205f                 movea.l    (a7)+, a0
209a: 202defda             move.l     -$1026(a5), d0
209e: b090                 cmp.l      (a0), d0
20a0: 6658                 bne.b      $20fa
20a2: 700f                 moveq      #$f, d0
20a4: d06effcc             add.w      -$34(a6), d0
20a8: c1fc0011             muls.w     #$11, d0
20ac: d08d                 add.l      a5, d0
20ae: 306effce             movea.w    -$32(a6), a0
20b2: d1c0                 adda.l     d0, a0
20b4: 7002                 moveq      #$2, d0
20b6: 114097b2             move.b     d0, -$684e(a0)
20ba: 7211                 moveq      #$11, d1
20bc: c3eeffce             muls.w     -$32(a6), d1
20c0: d28d                 add.l      a5, d1
20c2: 306effcc             movea.w    -$34(a6), a0
20c6: d1c1                 adda.l     d1, a0
20c8: 114097b2             move.b     d0, -$684e(a0)
20cc: 700f                 moveq      #$f, d0
20ce: d06effcc             add.w      -$34(a6), d0
20d2: c1fc0011             muls.w     #$11, d0
20d6: d08d                 add.l      a5, d0
20d8: 306effce             movea.w    -$32(a6), a0
20dc: d1c0                 adda.l     d0, a0
20de: 7001                 moveq      #$1, d0
20e0: 11409592             move.b     d0, -$6a6e(a0)
20e4: 7211                 moveq      #$11, d1
20e6: c3eeffce             muls.w     -$32(a6), d1
20ea: d28d                 add.l      a5, d1
20ec: 306effcc             movea.w    -$34(a6), a0
20f0: d1c1                 adda.l     d1, a0
20f2: 11409592             move.b     d0, -$6a6e(a0)
20f6: 600000d4             bra.w      $21cc
20fa: 42a7                 clr.l      -(a7)
20fc: 3f3c0081             move.w     #$81, -(a7)
2100: a9b9                 dc.w       $a9b9
2102: 205f                 movea.l    (a7)+, a0
2104: 202defda             move.l     -$1026(a5), d0
2108: b090                 cmp.l      (a0), d0
210a: 6656                 bne.b      $2162
210c: 700f                 moveq      #$f, d0
210e: d06effcc             add.w      -$34(a6), d0
2112: c1fc0011             muls.w     #$11, d0
2116: d08d                 add.l      a5, d0
2118: 306effce             movea.w    -$32(a6), a0
211c: d1c0                 adda.l     d0, a0
211e: 7001                 moveq      #$1, d0
2120: 114097b2             move.b     d0, -$684e(a0)
2124: 7211                 moveq      #$11, d1
2126: c3eeffce             muls.w     -$32(a6), d1
212a: d28d                 add.l      a5, d1
212c: 306effcc             movea.w    -$34(a6), a0
2130: d1c1                 adda.l     d1, a0
2132: 114097b2             move.b     d0, -$684e(a0)
2136: 700f                 moveq      #$f, d0
2138: d06effcc             add.w      -$34(a6), d0
213c: c1fc0011             muls.w     #$11, d0
2140: d08d                 add.l      a5, d0
2142: 306effce             movea.w    -$32(a6), a0
2146: d1c0                 adda.l     d0, a0
2148: 7002                 moveq      #$2, d0
214a: 11409592             move.b     d0, -$6a6e(a0)
214e: 7211                 moveq      #$11, d1
2150: c3eeffce             muls.w     -$32(a6), d1
2154: d28d                 add.l      a5, d1
2156: 306effcc             movea.w    -$34(a6), a0
215a: d1c1                 adda.l     d1, a0
215c: 11409592             move.b     d0, -$6a6e(a0)
2160: 606a                 bra.b      $21cc
2162: 42a7                 clr.l      -(a7)
2164: 3f3c0084             move.w     #$84, -(a7)
2168: a9b9                 dc.w       $a9b9
216a: 205f                 movea.l    (a7)+, a0
216c: 202defda             move.l     -$1026(a5), d0
2170: b090                 cmp.l      (a0), d0
2172: 6704                 beq.b      $2178
2174: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
2178: 700f                 moveq      #$f, d0
217a: d06effcc             add.w      -$34(a6), d0
217e: c1fc0011             muls.w     #$11, d0
2182: d08d                 add.l      a5, d0
2184: 306effce             movea.w    -$32(a6), a0
2188: d1c0                 adda.l     d0, a0
218a: 7001                 moveq      #$1, d0
218c: 114097b2             move.b     d0, -$684e(a0)
2190: 7211                 moveq      #$11, d1
2192: c3eeffce             muls.w     -$32(a6), d1
2196: d28d                 add.l      a5, d1
2198: 306effcc             movea.w    -$34(a6), a0
219c: d1c1                 adda.l     d1, a0
219e: 114097b2             move.b     d0, -$684e(a0)
21a2: 700f                 moveq      #$f, d0
21a4: d06effcc             add.w      -$34(a6), d0
21a8: c1fc0011             muls.w     #$11, d0
21ac: d08d                 add.l      a5, d0
21ae: 306effce             movea.w    -$32(a6), a0
21b2: d1c0                 adda.l     d0, a0
21b4: 7001                 moveq      #$1, d0
21b6: 11409592             move.b     d0, -$6a6e(a0)
21ba: 7211                 moveq      #$11, d1
21bc: c3eeffce             muls.w     -$32(a6), d1
21c0: d28d                 add.l      a5, d1
21c2: 306effcc             movea.w    -$34(a6), a0
21c6: d1c1                 adda.l     d1, a0
21c8: 11409592             move.b     d0, -$6a6e(a0)
21cc: 3f2effcc             move.w     -$34(a6), -(a7)
21d0: 3f2effce             move.w     -$32(a6), -(a7)
21d4: 4ead03da             jsr        $3da(a5) ; CODE20+0648
21d8: 60000314             bra.w      $24ee
21dc: 0c6e0001ffce         cmpi.w     #$1, -$32(a6)
21e2: 6d1a                 blt.b      $21fe
21e4: 0c6e000fffce         cmpi.w     #$f, -$32(a6)
21ea: 6e12                 bgt.b      $21fe
21ec: 0c6e0001ffcc         cmpi.w     #$1, -$34(a6)
21f2: 6d0a                 blt.b      $21fe
21f4: 0c6e000fffcc         cmpi.w     #$f, -$34(a6)
21fa: 6f000128             ble.w      $2324
21fe: 2f2effd8             move.l     -$28(a6), -(a7)
2202: 486efffe             pea.l      -$2(a6)
2206: 4eba02f0             jsr        $24f8(pc)
220a: 4a40                 tst.w      d0
220c: 508f                 addq.l     #$8, a7
220e: 670000ae             beq.w      $22be
2212: 302defb0             move.w     -$1050(a5), d0
2216: b06efffe             cmp.w      -$2(a6), d0
221a: 66000092             bne.w      $22ae
221e: 202c0006             move.l     $6(a4), d0
2222: 90adefde             sub.l      -$1022(a5), d0
2226: b0b802f0             cmp.l      $2f0.w, d0
222a: 62000082             bhi.w      $22ae
222e: 42a7                 clr.l      -(a7)
2230: 42a7                 clr.l      -(a7)
2232: 42a7                 clr.l      -(a7)
2234: 4ead019a             jsr        $19a(a5) ; CODE11+116c
2238: 4a80                 tst.l      d0
223a: 4fef000c             lea.l      $c(a7), a7
223e: 676e                 beq.b      $22ae
2240: 4267                 clr.w      -(a7)
2242: 2f2ddec6             move.l     -$213a(a5), -(a7)
2246: a960                 dc.w       $a960
2248: 302efffe             move.w     -$2(a6), d0
224c: d05f                 add.w      (a7)+, d0
224e: 3b40de54             move.w     d0, -$21ac(a5)
2252: 42a7                 clr.l      -(a7)
2254: 206ddec2             movea.l    -$213e(a5), a0
2258: 2f2800ca             move.l     $ca(a0), -(a7)
225c: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
2260: 2d5fff9a             move.l     (a7)+, -$66(a6)
2264: 48780006             pea.l      $6.w
2268: 2f2eff9a             move.l     -$66(a6), -(a7)
226c: 4ead004a             jsr        $4a(a5) ; CODE1+0124
2270: 306dde54             movea.w    -$21ac(a5), a0
2274: b088                 cmp.l      a0, d0
2276: 6332                 bls.b      $22aa
2278: 206ddec2             movea.l    -$213e(a5), a0
227c: 206800ca             movea.l    $ca(a0), a0
2280: 7006                 moveq      #$6, d0
2282: c1edde54             muls.w     -$21ac(a5), d0
2286: d090                 add.l      (a0), d0
2288: 2040                 movea.l    d0, a0
228a: 0c100004             cmpi.b     #$4, (a0)
228e: 671a                 beq.b      $22aa
2290: 3f2dde54             move.w     -$21ac(a5), -(a7)
2294: 4ead0132             jsr        $132(a5) ; CODE7+0568
2298: 3e80                 move.w     d0, (a7)
229a: 4ead0162             jsr        $162(a5) ; CODE7+0004
229e: 3eadde54             move.w     -$21ac(a5), (a7)
22a2: 4ead0142             jsr        $142(a5) ; CODE7+050e
22a6: 548f                 addq.l     #$2, a7
22a8: 6004                 bra.b      $22ae
22aa: 426dde54             clr.w      -$21ac(a5)
22ae: 3b6efffeefb0         move.w     -$2(a6), -$1050(a5)
22b4: 2b6c0006efde         move.l     $6(a4), -$1022(a5)
22ba: 60000232             bra.w      $24ee
22be: 4227                 clr.b      -(a7)
22c0: 2f2effd8             move.l     -$28(a6), -(a7)
22c4: 206dde80             movea.l    -$2180(a5), a0
22c8: 48680012             pea.l      $12(a0)
22cc: a8ad                 dc.w       $a8ad
22ce: 4a1f                 tst.b      (a7)+
22d0: 6700021c             beq.w      $24ee
22d4: 206ddeb8             movea.l    -$2148(a5), a0
22d8: 4a28006e             tst.b      $6e(a0)
22dc: 67000210             beq.w      $24ee
22e0: 0c6dffefefb0         cmpi.w     #$ffef, -$1050(a5)
22e6: 662c                 bne.b      $2314
22e8: 202c0006             move.l     $6(a4), d0
22ec: 90adefde             sub.l      -$1022(a5), d0
22f0: b0b802f0             cmp.l      $2f0.w, d0
22f4: 621e                 bhi.b      $2314
22f6: 48780022             pea.l      $22.w
22fa: 486effdc             pea.l      -$24(a6)
22fe: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
2302: 3d7c007ffffa         move.w     #$7f, -$6(a6)
2308: 486effdc             pea.l      -$24(a6)
230c: 4ead02fa             jsr        $2fa(a5) ; CODE14+0186
2310: 4fef000c             lea.l      $c(a7), a7
2314: 3b7cffefefb0         move.w     #$ffef, -$1050(a5)
231a: 2b6c0006efde         move.l     $6(a4), -$1022(a5)
2320: 600001cc             bra.w      $24ee
2324: 4a6dd9ae             tst.w      -$2652(a5)
2328: 660000ca             bne.w      $23f4
232c: 7011                 moveq      #$11, d0
232e: c1eeffce             muls.w     -$32(a6), d0
2332: d08d                 add.l      a5, d0
2334: 306effcc             movea.w    -$34(a6), a0
2338: d1c0                 adda.l     d0, a0
233a: 7011                 moveq      #$11, d0
233c: c1eeffce             muls.w     -$32(a6), d0
2340: d08d                 add.l      a5, d0
2342: 326effcc             movea.w    -$34(a6), a1
2346: d3c0                 adda.l     d0, a1
2348: 1028d88d             move.b     -$2773(a0), d0
234c: b029d76c             cmp.b      -$2894(a1), d0
2350: 67000088             beq.w      $23da
2354: 7011                 moveq      #$11, d0
2356: c1eeffce             muls.w     -$32(a6), d0
235a: d08d                 add.l      a5, d0
235c: 306effcc             movea.w    -$34(a6), a0
2360: d1c0                 adda.l     d0, a0
2362: 1828d76c             move.b     -$2894(a0), d4
2366: 42a7                 clr.l      -(a7)
2368: 4267                 clr.w      -(a7)
236a: 3f2effcc             move.w     -$34(a6), -(a7)
236e: 3f2effce             move.w     -$32(a6), -(a7)
2372: 4ebadd88             jsr        $fc(pc)
2376: 7000                 moveq      #$0, d0
2378: 1004                 move.b     d4, d0
237a: 204d                 movea.l    a5, a0
237c: d1c0                 adda.l     d0, a0
237e: 4a28fbd8             tst.b      -$428(a0)
2382: 4fef000a             lea.l      $a(a7), a7
2386: 6a04                 bpl.b      $238c
2388: 703f                 moveq      #$3f, d0
238a: 600c                 bra.b      $2398
238c: 1004                 move.b     d4, d0
238e: 4880                 ext.w      d0
2390: 3f00                 move.w     d0, -(a7)
2392: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
2396: 548f                 addq.l     #$2, a7
2398: 1800                 move.b     d0, d4
239a: 7e00                 moveq      #$0, d7
239c: 6002                 bra.b      $23a0
239e: 5247                 addq.w     #$1, d7
23a0: 204d                 movea.l    a5, a0
23a2: 2007                 move.l     d7, d0
23a4: 48c0                 ext.l      d0
23a6: e588                 lsl.l      #$2, d0
23a8: d1c0                 adda.l     d0, a0
23aa: 4a68de28             tst.w      -$21d8(a0)
23ae: 6700f878             beq.w      $1c28
23b2: 204d                 movea.l    a5, a0
23b4: 2007                 move.l     d7, d0
23b6: 48c0                 ext.l      d0
23b8: e588                 lsl.l      #$2, d0
23ba: d1c0                 adda.l     d0, a0
23bc: 4a68de2a             tst.w      -$21d6(a0)
23c0: 67dc                 beq.b      $239e
23c2: 204d                 movea.l    a5, a0
23c4: 2007                 move.l     d7, d0
23c6: 48c0                 ext.l      d0
23c8: e588                 lsl.l      #$2, d0
23ca: d1c0                 adda.l     d0, a0
23cc: 1004                 move.b     d4, d0
23ce: 4880                 ext.w      d0
23d0: b068de28             cmp.w      -$21d8(a0), d0
23d4: 66c8                 bne.b      $239e
23d6: 6000f850             bra.w      $1c28
23da: 0c6d0004de66         cmpi.w     #$4, -$219a(a5)
23e0: 6712                 beq.b      $23f4
23e2: 4ead043a             jsr        $43a(a5) ; CODE20+0194
23e6: 4ead03fa             jsr        $3fa(a5) ; CODE20+004e
23ea: 486dc366             pea.l      -$3c9a(a5)
23ee: 4ead02f2             jsr        $2f2(a5) ; CODE14+0004
23f2: 588f                 addq.l     #$4, a7
23f4: 3f2effcc             move.w     -$34(a6), -(a7)
23f8: 3f2effce             move.w     -$32(a6), -(a7)
23fc: 4eba0172             jsr        $2570(pc)
2400: 588f                 addq.l     #$4, a7
2402: 600000ce             bra.w      $24d2
2406: 486effd8             pea.l      -$28(a6)
240a: a972                 dc.w       $a972
240c: 486effc6             pea.l      -$3a(a6)
2410: 486effc8             pea.l      -$38(a6)
2414: 486effd8             pea.l      -$28(a6)
2418: 4ead03f2             jsr        $3f2(a5) ; CODE20+0586
241c: 0c6e000fffc8         cmpi.w     #$f, -$38(a6)
2422: 4fef000c             lea.l      $c(a7), a7
2426: 6f08                 ble.b      $2430
2428: 3d7c000fffc8         move.w     #$f, -$38(a6)
242e: 600e                 bra.b      $243e
2430: 0c6e0001ffc8         cmpi.w     #$1, -$38(a6)
2436: 6c06                 bge.b      $243e
2438: 3d7c0001ffc8         move.w     #$1, -$38(a6)
243e: 0c6e000fffc6         cmpi.w     #$f, -$3a(a6)
2444: 6f08                 ble.b      $244e
2446: 3d7c000fffc6         move.w     #$f, -$3a(a6)
244c: 600e                 bra.b      $245c
244e: 0c6e0001ffc6         cmpi.w     #$1, -$3a(a6)
2454: 6c06                 bge.b      $245c
2456: 3d7c0001ffc6         move.w     #$1, -$3a(a6)
245c: 302effc8             move.w     -$38(a6), d0
2460: b06effce             cmp.w      -$32(a6), d0
2464: 6624                 bne.b      $248a
2466: 302effc6             move.w     -$3a(a6), d0
246a: b06effcc             cmp.w      -$34(a6), d0
246e: 6f1a                 ble.b      $248a
2470: 4a6dde4e             tst.w      -$21b2(a5)
2474: 6614                 bne.b      $248a
2476: 3b7c0001de4e         move.w     #$1, -$21b2(a5)
247c: 3f2effcc             move.w     -$34(a6), -(a7)
2480: 3f2effce             move.w     -$32(a6), -(a7)
2484: 4ead03da             jsr        $3da(a5) ; CODE20+0648
2488: 588f                 addq.l     #$4, a7
248a: 302effc6             move.w     -$3a(a6), d0
248e: b06effcc             cmp.w      -$34(a6), d0
2492: 6622                 bne.b      $24b6
2494: 302effc8             move.w     -$38(a6), d0
2498: b06effce             cmp.w      -$32(a6), d0
249c: 6f18                 ble.b      $24b6
249e: 4a6dde4e             tst.w      -$21b2(a5)
24a2: 6712                 beq.b      $24b6
24a4: 426dde4e             clr.w      -$21b2(a5)
24a8: 3f2effcc             move.w     -$34(a6), -(a7)
24ac: 3f2effce             move.w     -$32(a6), -(a7)
24b0: 4ead03da             jsr        $3da(a5) ; CODE20+0648
24b4: 588f                 addq.l     #$4, a7
24b6: 2f0c                 move.l     a4, -(a7)
24b8: 2f2e0008             move.l     $8(a6), -(a7)
24bc: 4eba0c36             jsr        $30f4(pc)
24c0: 2d40ffd0             move.l     d0, -$30(a6)
24c4: 508f                 addq.l     #$8, a7
24c6: 6708                 beq.b      $24d0
24c8: 2f2effd0             move.l     -$30(a6), -(a7)
24cc: a851                 dc.w       $a851
24ce: 6002                 bra.b      $24d2
24d0: a850                 dc.w       $a850
24d2: 4227                 clr.b      -(a7)
24d4: a973                 dc.w       $a973
24d6: 4a1f                 tst.b      (a7)+
24d8: 6600ff2c             bne.w      $2406
24dc: 6010                 bra.b      $24ee
24de: 3f03                 move.w     d3, -(a7)
24e0: 4ead0c6a             jsr        $c6a(a5) ; CODE41+010a
24e4: 548f                 addq.l     #$2, a7
24e6: 4267                 clr.w      -(a7)
24e8: 3f07                 move.w     d7, -(a7)
24ea: 4ebae0ac             jsr        $598(pc)
24ee: 4cee1cf8ff7a         movem.l    -$86(a6), d3-d7/a2-a4
24f4: 4e5e                 unlk       a6
24f6: 4e75                 rts        
24f8: 4e56fff8             link.w     a6, #$fff8
24fc: 2f07                 move.l     d7, -(a7)
24fe: 206dde80             movea.l    -$2180(a5), a0
2502: 2d68003efff8         move.l     $3e(a0), -$8(a6)
2508: 2d680042fffc         move.l     $42(a0), -$4(a6)
250e: 066e000dfff8         addi.w     #$d, -$8(a6)
2514: 066e000efffa         addi.w     #$e, -$6(a6)
251a: 046e0010fffe         subi.w     #$10, -$2(a6)
2520: 4227                 clr.b      -(a7)
2522: 2f2e000c             move.l     $c(a6), -(a7)
2526: 486efff8             pea.l      -$8(a6)
252a: a8ad                 dc.w       $a8ad
252c: 4a1f                 tst.b      (a7)+
252e: 6604                 bne.b      $2534
2530: 7000                 moveq      #$0, d0
2532: 6036                 bra.b      $256a
2534: 3e2e000c             move.w     $c(a6), d7
2538: 9e6efff8             sub.w      -$8(a6), d7
253c: 48c7                 ext.l      d7
253e: 8ffc000c             divs.w     #$c, d7
2542: de47                 add.w      d7, d7
2544: 302efffa             move.w     -$6(a6), d0
2548: d06efffe             add.w      -$2(a6), d0
254c: 322e000e             move.w     $e(a6), d1
2550: d241                 add.w      d1, d1
2552: b041                 cmp.w      d1, d0
2554: 6c02                 bge.b      $2558
2556: 5247                 addq.w     #$1, d7
2558: 206e0008             movea.l    $8(a6), a0
255c: 3087                 move.w     d7, (a0)
255e: 0c47ffef             cmpi.w     #$ffef, d7
2562: 6604                 bne.b      $2568
2564: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
2568: 7001                 moveq      #$1, d0
256a: 2e1f                 move.l     (a7)+, d7
256c: 4e5e                 unlk       a6
256e: 4e75                 rts        
2570: 4e560000             link.w     a6, #$0
2574: 48e70700             movem.l    d5-d7, -(a7)
2578: 3e2e0008             move.w     $8(a6), d7
257c: 3c2e000a             move.w     $a(a6), d6
2580: be6dde50             cmp.w      -$21b0(a5), d7
2584: 6606                 bne.b      $258c
2586: bc6dde52             cmp.w      -$21ae(a5), d6
258a: 672a                 beq.b      $25b6
258c: 3a2dde50             move.w     -$21b0(a5), d5
2590: 3b47de50             move.w     d7, -$21b0(a5)
2594: 3e05                 move.w     d5, d7
2596: 3a2dde52             move.w     -$21ae(a5), d5
259a: 3b46de52             move.w     d6, -$21ae(a5)
259e: 3c05                 move.w     d5, d6
25a0: 3f06                 move.w     d6, -(a7)
25a2: 3f07                 move.w     d7, -(a7)
25a4: 4ead03da             jsr        $3da(a5) ; CODE20+0648
25a8: 3eadde52             move.w     -$21ae(a5), (a7)
25ac: 3f2dde50             move.w     -$21b0(a5), -(a7)
25b0: 4ead03da             jsr        $3da(a5) ; CODE20+0648
25b4: 5c8f                 addq.l     #$6, a7
25b6: 4cdf00e0             movem.l    (a7)+, d5-d7
25ba: 4e5e                 unlk       a6
25bc: 4e75                 rts        
25be: 4e56ffe8             link.w     a6, #$ffe8
25c2: 48e70718             movem.l    d5-d7/a3-a4, -(a7)
25c6: 202ddec2             move.l     -$213e(a5), d0
25ca: b0ae0008             cmp.l      $8(a6), d0
25ce: 6704                 beq.b      $25d4
25d0: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
25d4: 42a7                 clr.l      -(a7)
25d6: a8d8                 dc.w       $a8d8
25d8: 265f                 movea.l    (a7)+, a3
25da: 206e0008             movea.l    $8(a6), a0
25de: 2f280018             move.l     $18(a0), -(a7)
25e2: 2f0b                 move.l     a3, -(a7)
25e4: a8dc                 dc.w       $a8dc
25e6: 2f3c00010001         move.l     #$10001, -(a7)
25ec: 486efff0             pea.l      -$10(a6)
25f0: 4ead03ea             jsr        $3ea(a5) ; CODE20+05f4
25f4: 2ebc000f000f         move.l     #$f000f, (a7)
25fa: 486effe8             pea.l      -$18(a6)
25fe: 4ead03ea             jsr        $3ea(a5) ; CODE20+05f4
2602: 3d6effeefff6         move.w     -$12(a6), -$a(a6)
2608: 3d6effecfff4         move.w     -$14(a6), -$c(a6)
260e: 4297                 clr.l      (a7)
2610: a8d8                 dc.w       $a8d8
2612: 285f                 movea.l    (a7)+, a4
2614: 2e8c                 move.l     a4, (a7)
2616: 486efff0             pea.l      -$10(a6)
261a: a8df                 dc.w       $a8df
261c: 2e8b                 move.l     a3, (a7)
261e: 2f0c                 move.l     a4, -(a7)
2620: 2f0b                 move.l     a3, -(a7)
2622: a8e6                 dc.w       $a8e6
2624: 4eba0a7c             jsr        $30a2(pc)
2628: 4a40                 tst.w      d0
262a: 6668                 bne.b      $2694
262c: 206dde78             movea.l    -$2188(a5), a0
2630: 2050                 movea.l    (a0), a0
2632: 4a68030a             tst.w      $30a(a0)
2636: 6714                 beq.b      $264c
2638: 2f0c                 move.l     a4, -(a7)
263a: 206dde80             movea.l    -$2180(a5), a0
263e: 48680046             pea.l      $46(a0)
2642: a8df                 dc.w       $a8df
2644: 2f0b                 move.l     a3, -(a7)
2646: 2f0c                 move.l     a4, -(a7)
2648: 2f0b                 move.l     a3, -(a7)
264a: a8e6                 dc.w       $a8e6
264c: 2f0c                 move.l     a4, -(a7)
264e: 206dde80             movea.l    -$2180(a5), a0
2652: 4868003e             pea.l      $3e(a0)
2656: a8df                 dc.w       $a8df
2658: 2f0b                 move.l     a3, -(a7)
265a: 2f0c                 move.l     a4, -(a7)
265c: 2f0b                 move.l     a3, -(a7)
265e: a8e6                 dc.w       $a8e6
2660: 206dde78             movea.l    -$2188(a5), a0
2664: 2050                 movea.l    (a0), a0
2666: 4a68030e             tst.w      $30e(a0)
266a: 6714                 beq.b      $2680
266c: 2f0c                 move.l     a4, -(a7)
266e: 206dde80             movea.l    -$2180(a5), a0
2672: 4868004e             pea.l      $4e(a0)
2676: a8df                 dc.w       $a8df
2678: 2f0b                 move.l     a3, -(a7)
267a: 2f0c                 move.l     a4, -(a7)
267c: 2f0b                 move.l     a3, -(a7)
267e: a8e6                 dc.w       $a8e6
2680: 2f0b                 move.l     a3, -(a7)
2682: a8d4                 dc.w       $a8d4
2684: 2f0b                 move.l     a3, -(a7)
2686: a8d9                 dc.w       $a8d9
2688: 4eba01e4             jsr        $286e(pc)
268c: 4ebaecb0             jsr        $133e(pc)
2690: 60000192             bra.w      $2824
2694: 2f0b                 move.l     a3, -(a7)
2696: a8d4                 dc.w       $a8d4
2698: 2f0b                 move.l     a3, -(a7)
269a: a8d9                 dc.w       $a8d9
269c: 3f3c0003             move.w     #$3, -(a7)
26a0: a887                 dc.w       $a887
26a2: 3f3c000c             move.w     #$c, -(a7)
26a6: a88a                 dc.w       $a88a
26a8: 4267                 clr.w      -(a7)
26aa: a889                 dc.w       $a889
26ac: 4267                 clr.w      -(a7)
26ae: a888                 dc.w       $a888
26b0: 486efff8             pea.l      -$8(a6)
26b4: a88b                 dc.w       $a88b
26b6: 7e03                 moveq      #$3, d7
26b8: cfeefffe             muls.w     -$2(a6), d7
26bc: 3c07                 move.w     d7, d6
26be: dc46                 add.w      d6, d6
26c0: 3a2efffa             move.w     -$6(a6), d5
26c4: da6efff8             add.w      -$8(a6), d5
26c8: da6efffe             add.w      -$2(a6), d5
26cc: da46                 add.w      d6, d5
26ce: 206dde80             movea.l    -$2180(a5), a0
26d2: 3b680040efb4         move.w     $40(a0), -$104c(a5)
26d8: 3b68003eefb2         move.w     $3e(a0), -$104e(a5)
26de: 302defb2             move.w     -$104e(a5), d0
26e2: d045                 add.w      d5, d0
26e4: 9047                 sub.w      d7, d0
26e6: 3b40efb6             move.w     d0, -$104a(a5)
26ea: 4267                 clr.w      -(a7)
26ec: 486df112             pea.l      -$eee(a5)
26f0: a88c                 dc.w       $a88c
26f2: 302defb4             move.w     -$104c(a5), d0
26f6: d05f                 add.w      (a7)+, d0
26f8: d046                 add.w      d6, d0
26fa: 3b40efb8             move.w     d0, -$1048(a5)
26fe: 486defb2             pea.l      -$104e(a5)
2702: a8a1                 dc.w       $a8a1
2704: 206dde80             movea.l    -$2180(a5), a0
2708: 30280040             move.w     $40(a0), d0
270c: d047                 add.w      d7, d0
270e: 3f00                 move.w     d0, -(a7)
2710: 3028003e             move.w     $3e(a0), d0
2714: d06efff8             add.w      -$8(a6), d0
2718: d047                 add.w      d7, d0
271a: 3f00                 move.w     d0, -(a7)
271c: a893                 dc.w       $a893
271e: 486df116             pea.l      -$eea(a5)
2722: a884                 dc.w       $a884
2724: 2b6defb2efba         move.l     -$104e(a5), -$1046(a5)
272a: 2b6defb6efbe         move.l     -$104a(a5), -$1042(a5)
2730: db6defba             add.w      d5, -$1046(a5)
2734: db6defbe             add.w      d5, -$1042(a5)
2738: 486defba             pea.l      -$1046(a5)
273c: a8a1                 dc.w       $a8a1
273e: 206dde80             movea.l    -$2180(a5), a0
2742: 30280040             move.w     $40(a0), d0
2746: d047                 add.w      d7, d0
2748: 3f00                 move.w     d0, -(a7)
274a: 3028003e             move.w     $3e(a0), d0
274e: d06efff8             add.w      -$8(a6), d0
2752: d045                 add.w      d5, d0
2754: d047                 add.w      d7, d0
2756: 3f00                 move.w     d0, -(a7)
2758: a893                 dc.w       $a893
275a: 486df11a             pea.l      -$ee6(a5)
275e: a884                 dc.w       $a884
2760: 2b6defbaefc2         move.l     -$1046(a5), -$103e(a5)
2766: 2b6defbeefc6         move.l     -$1042(a5), -$103a(a5)
276c: db6defc2             add.w      d5, -$103e(a5)
2770: db6defc6             add.w      d5, -$103a(a5)
2774: 486defc2             pea.l      -$103e(a5)
2778: a8a1                 dc.w       $a8a1
277a: 206dde80             movea.l    -$2180(a5), a0
277e: 30280040             move.w     $40(a0), d0
2782: d047                 add.w      d7, d0
2784: 3f00                 move.w     d0, -(a7)
2786: 3028003e             move.w     $3e(a0), d0
278a: d06efff8             add.w      -$8(a6), d0
278e: 3205                 move.w     d5, d1
2790: d241                 add.w      d1, d1
2792: d041                 add.w      d1, d0
2794: d047                 add.w      d7, d0
2796: 3f00                 move.w     d0, -(a7)
2798: a893                 dc.w       $a893
279a: 486df11e             pea.l      -$ee2(a5)
279e: a884                 dc.w       $a884
27a0: 2b6defc2efca         move.l     -$103e(a5), -$1036(a5)
27a6: 2b6defc6efce         move.l     -$103a(a5), -$1032(a5)
27ac: db6defca             add.w      d5, -$1036(a5)
27b0: db6defce             add.w      d5, -$1032(a5)
27b4: 486defca             pea.l      -$1036(a5)
27b8: a8a1                 dc.w       $a8a1
27ba: 206dde80             movea.l    -$2180(a5), a0
27be: 30280040             move.w     $40(a0), d0
27c2: d047                 add.w      d7, d0
27c4: 3f00                 move.w     d0, -(a7)
27c6: 3028003e             move.w     $3e(a0), d0
27ca: d06efff8             add.w      -$8(a6), d0
27ce: 7203                 moveq      #$3, d1
27d0: c3c5                 muls.w     d5, d1
27d2: d041                 add.w      d1, d0
27d4: d047                 add.w      d7, d0
27d6: 3f00                 move.w     d0, -(a7)
27d8: a893                 dc.w       $a893
27da: 486df122             pea.l      -$ede(a5)
27de: a884                 dc.w       $a884
27e0: 2b6defcaefd2         move.l     -$1036(a5), -$102e(a5)
27e6: 2b6defceefd6         move.l     -$1032(a5), -$102a(a5)
27ec: db6defd2             add.w      d5, -$102e(a5)
27f0: db6defd6             add.w      d5, -$102a(a5)
27f4: 486defd2             pea.l      -$102e(a5)
27f8: a8a1                 dc.w       $a8a1
27fa: 206dde80             movea.l    -$2180(a5), a0
27fe: 30280040             move.w     $40(a0), d0
2802: d047                 add.w      d7, d0
2804: 3f00                 move.w     d0, -(a7)
2806: 3028003e             move.w     $3e(a0), d0
280a: d06efff8             add.w      -$8(a6), d0
280e: 3205                 move.w     d5, d1
2810: e549                 lsl.w      #$2, d1
2812: d041                 add.w      d1, d0
2814: d047                 add.w      d7, d0
2816: 3f00                 move.w     d0, -(a7)
2818: a893                 dc.w       $a893
281a: 486df126             pea.l      -$eda(a5)
281e: a884                 dc.w       $a884
2820: 4ead03d2             jsr        $3d2(a5) ; CODE20+09d0
2824: 2f0c                 move.l     a4, -(a7)
2826: a8d9                 dc.w       $a8d9
2828: 4eba0a90             jsr        $32ba(pc)
282c: 2f3c00030003         move.l     #$30003, -(a7)
2832: a89b                 dc.w       $a89b
2834: 206dde80             movea.l    -$2180(a5), a0
2838: 4868001a             pea.l      $1a(a0)
283c: 2f3cfffcfffc         move.l     #$fffcfffc, -(a7)
2842: a8a9                 dc.w       $a8a9
2844: 206dde80             movea.l    -$2180(a5), a0
2848: 4868001a             pea.l      $1a(a0)
284c: 2f3c00100010         move.l     #$100010, -(a7)
2852: a8b0                 dc.w       $a8b0
2854: 206dde80             movea.l    -$2180(a5), a0
2858: 4868001a             pea.l      $1a(a0)
285c: 2f3c00040004         move.l     #$40004, -(a7)
2862: a8a9                 dc.w       $a8a9
2864: a89e                 dc.w       $a89e
2866: 4cdf18e0             movem.l    (a7)+, d5-d7/a3-a4
286a: 4e5e                 unlk       a6
286c: 4e75                 rts        
286e: 4e56fff2             link.w     a6, #$fff2
2872: 4eba0048             jsr        $28bc(pc)
2876: 48787fff             pea.l      $7fff.w
287a: 4ebae4a8             jsr        $d24(pc)
287e: 4ead03d2             jsr        $3d2(a5) ; CODE20+09d0
2882: 4eba0bbc             jsr        $3440(pc)
2886: 4ebae310             jsr        $b98(pc)
288a: 4ead0932             jsr        $932(a5) ; CODE31+0108
288e: 4a40                 tst.w      d0
2890: 588f                 addq.l     #$4, a7
2892: 671a                 beq.b      $28ae
2894: 4a6dde28             tst.w      -$21d8(a5)
2898: 6714                 beq.b      $28ae
289a: 206dde80             movea.l    -$2180(a5), a0
289e: 48680012             pea.l      $12(a0)
28a2: 42a7                 clr.l      -(a7)
28a4: 3f3c00b6             move.w     #$b6, -(a7)
28a8: a9bb                 dc.w       $a9bb
28aa: a94b                 dc.w       $a94b
28ac: 600a                 bra.b      $28b8
28ae: 206dde80             movea.l    -$2180(a5), a0
28b2: 48680012             pea.l      $12(a0)
28b6: a8a3                 dc.w       $a8a3
28b8: 4e5e                 unlk       a6
28ba: 4e75                 rts        
28bc: 4e56fff0             link.w     a6, #$fff0
28c0: 2f07                 move.l     d7, -(a7)
28c2: 4a6dd9ae             tst.w      -$2652(a5)
28c6: 6648                 bne.b      $2910
28c8: 486efff8             pea.l      -$8(a6)
28cc: 4267                 clr.w      -(a7)
28ce: 4eba01ae             jsr        $2a7e(pc)
28d2: 486efff0             pea.l      -$10(a6)
28d6: 3f3c0006             move.w     #$6, -(a7)
28da: 4eba01a2             jsr        $2a7e(pc)
28de: 3d6efff6fffe         move.w     -$a(a6), -$2(a6)
28e4: 4217                 clr.b      (a7)
28e6: 486efff8             pea.l      -$8(a6)
28ea: 206ddec2             movea.l    -$213e(a5), a0
28ee: 2f280018             move.l     $18(a0), -(a7)
28f2: a8e9                 dc.w       $a8e9
28f4: 4a1f                 tst.b      (a7)+
28f6: 4fef000a             lea.l      $a(a7), a7
28fa: 6714                 beq.b      $2910
28fc: 7e00                 moveq      #$0, d7
28fe: 600a                 bra.b      $290a
2900: 3f07                 move.w     d7, -(a7)
2902: 4eba01d6             jsr        $2ada(pc)
2906: 548f                 addq.l     #$2, a7
2908: 5247                 addq.w     #$1, d7
290a: 0c470007             cmpi.w     #$7, d7
290e: 6df0                 blt.b      $2900
2910: 2e1f                 move.l     (a7)+, d7
2912: 4e5e                 unlk       a6
2914: 4e75                 rts        
2916: 4e56ffda             link.w     a6, #$ffda
291a: 48e70108             movem.l    d7/a4, -(a7)
291e: 3b7c0001d9ae         move.w     #$1, -$2652(a5)
2924: 7e00                 moveq      #$0, d7
2926: 49edde28             lea.l      -$21d8(a5), a4
292a: 6018                 bra.b      $2944
292c: 3f14                 move.w     (a4), -(a7)
292e: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
2932: 1d8070e2             move.b     d0, -$1e(a6, d7.w)
2936: 4254                 clr.w      (a4)
2938: 3e87                 move.w     d7, (a7)
293a: 4eba019e             jsr        $2ada(pc)
293e: 548f                 addq.l     #$2, a7
2940: 5247                 addq.w     #$1, d7
2942: 588c                 addq.l     #$4, a4
2944: 0c470008             cmpi.w     #$8, d7
2948: 65e2                 bcs.b      $292c
294a: 423670e2             clr.b      -$1e(a6, d7.w)
294e: 206ddec2             movea.l    -$213e(a5), a0
2952: 286800a0             movea.l    $a0(a0), a4
2956: 3f3c0003             move.w     #$3, -(a7)
295a: a887                 dc.w       $a887
295c: 3f3c0001             move.w     #$1, -(a7)
2960: a888                 dc.w       $a888
2962: 206dde80             movea.l    -$2180(a5), a0
2966: 3f28000c             move.w     $c(a0), -(a7)
296a: a88a                 dc.w       $a88a
296c: 486effda             pea.l      -$26(a6)
2970: a88b                 dc.w       $a88b
2972: 2054                 movea.l    (a4), a0
2974: 317c0003004a         move.w     #$3, $4a(a0)
297a: 2054                 movea.l    (a4), a0
297c: 117c0001004c         move.b     #$1, $4c(a0)
2982: 206dde80             movea.l    -$2180(a5), a0
2986: 2254                 movea.l    (a4), a1
2988: 3368000c0050         move.w     $c(a0), $50(a1)
298e: 302effda             move.w     -$26(a6), d0
2992: d06effdc             add.w      -$24(a6), d0
2996: d06effe0             add.w      -$20(a6), d0
299a: 2054                 movea.l    (a4), a0
299c: 31400018             move.w     d0, $18(a0)
29a0: 2054                 movea.l    (a4), a0
29a2: 316effda001a         move.w     -$26(a6), $1a(a0)
29a8: 2054                 movea.l    (a4), a0
29aa: 4228004c             clr.b      $4c(a0)
29ae: 2f2ddec2             move.l     -$213e(a5), -(a7)
29b2: 3f3c0003             move.w     #$3, -(a7)
29b6: a828                 dc.w       $a828
29b8: 486effe2             pea.l      -$1e(a6)
29bc: 3f3c0003             move.w     #$3, -(a7)
29c0: 2f2ddec2             move.l     -$213e(a5), -(a7)
29c4: 4ead063a             jsr        $63a(a5) ; CODE9+0d86
29c8: 2eaddec2             move.l     -$213e(a5), (a7)
29cc: 48780003             pea.l      $3.w
29d0: 3f3c7fff             move.w     #$7fff, -(a7)
29d4: a97e                 dc.w       $a97e
29d6: 2eaddec2             move.l     -$213e(a5), (a7)
29da: 486df12a             pea.l      -$ed6(a5)
29de: a91a                 dc.w       $a91a
29e0: 4ead0292             jsr        $292(a5) ; CODE14+0318
29e4: 4ebafe88             jsr        $286e(pc)
29e8: 4cee1080ffd2         movem.l    -$2e(a6), d7/a4
29ee: 4e5e                 unlk       a6
29f0: 4e75                 rts        
29f2: 2f2ddec2             move.l     -$213e(a5), -(a7)
29f6: a873                 dc.w       $a873
29f8: 206dde80             movea.l    -$2180(a5), a0
29fc: 48680012             pea.l      $12(a0)
2a00: a928                 dc.w       $a928
2a02: 4e75                 rts        
2a04: 4e560000             link.w     a6, #$0
2a08: 2f2e000a             move.l     $a(a6), -(a7)
2a0c: 3f3c7fff             move.w     #$7fff, -(a7)
2a10: 2f2ddec2             move.l     -$213e(a5), -(a7)
2a14: 4ead0152             jsr        $152(a5) ; CODE7+08bc
2a18: 4e5e                 unlk       a6
2a1a: 4e75                 rts        
2a1c: 4e56fefe             link.w     a6, #$fefe
2a20: 486efefe             pea.l      -$102(a6)
2a24: 3f3c0003             move.w     #$3, -(a7)
2a28: 2f2ddec2             move.l     -$213e(a5), -(a7)
2a2c: 4ead0642             jsr        $642(a5) ; CODE9+0dea
2a30: 486efefe             pea.l      -$102(a6)
2a34: 4ebadbc8             jsr        $5fe(pc)
2a38: 4e5e                 unlk       a6
2a3a: 4e75                 rts        
2a3c: 4e560000             link.w     a6, #$0
2a40: 48e70108             movem.l    d7/a4, -(a7)
2a44: 7e00                 moveq      #$0, d7
2a46: 49edde28             lea.l      -$21d8(a5), a4
2a4a: 6024                 bra.b      $2a70
2a4c: 2f2e000c             move.l     $c(a6), -(a7)
2a50: 3f07                 move.w     d7, -(a7)
2a52: 4eba002a             jsr        $2a7e(pc)
2a56: 4217                 clr.b      (a7)
2a58: 2f2e0008             move.l     $8(a6), -(a7)
2a5c: 2f2e000c             move.l     $c(a6), -(a7)
2a60: a8ad                 dc.w       $a8ad
2a62: 4a1f                 tst.b      (a7)+
2a64: 588f                 addq.l     #$4, a7
2a66: 6704                 beq.b      $2a6c
2a68: 3007                 move.w     d7, d0
2a6a: 600a                 bra.b      $2a76
2a6c: 5247                 addq.w     #$1, d7
2a6e: 588c                 addq.l     #$4, a4
2a70: 4a54                 tst.w      (a4)
2a72: 66d8                 bne.b      $2a4c
2a74: 70ff                 moveq      #$ff, d0
2a76: 4cdf1080             movem.l    (a7)+, d7/a4
2a7a: 4e5e                 unlk       a6
2a7c: 4e75                 rts        
2a7e: 4e560000             link.w     a6, #$0
2a82: 48e70018             movem.l    a3-a4, -(a7)
2a86: 266e000a             movea.l    $a(a6), a3
2a8a: 49eb0002             lea.l      $2(a3), a4
2a8e: 206dde80             movea.l    -$2180(a5), a0
2a92: 38a80006             move.w     $6(a0), (a4)
2a96: 206dde80             movea.l    -$2180(a5), a0
2a9a: 30280004             move.w     $4(a0), d0
2a9e: d054                 add.w      (a4), d0
2aa0: 5240                 addq.w     #$1, d0
2aa2: 37400006             move.w     d0, $6(a3)
2aa6: 206dde80             movea.l    -$2180(a5), a0
2aaa: 36a80008             move.w     $8(a0), (a3)
2aae: 206dde80             movea.l    -$2180(a5), a0
2ab2: 30280004             move.w     $4(a0), d0
2ab6: d053                 add.w      (a3), d0
2ab8: 5240                 addq.w     #$1, d0
2aba: 37400004             move.w     d0, $4(a3)
2abe: 2f0b                 move.l     a3, -(a7)
2ac0: 206dde80             movea.l    -$2180(a5), a0
2ac4: 30280002             move.w     $2(a0), d0
2ac8: c1ee0008             muls.w     $8(a6), d0
2acc: 3f00                 move.w     d0, -(a7)
2ace: 4267                 clr.w      -(a7)
2ad0: a8a8                 dc.w       $a8a8
2ad2: 4cdf1800             movem.l    (a7)+, a3-a4
2ad6: 4e5e                 unlk       a6
2ad8: 4e75                 rts        
2ada: 4e56fff0             link.w     a6, #$fff0
2ade: 48e70708             movem.l    d5-d7/a4, -(a7)
2ae2: 3e2e0008             move.w     $8(a6), d7
2ae6: 4a47                 tst.w      d7
2ae8: 6d06                 blt.b      $2af0
2aea: 0c470008             cmpi.w     #$8, d7
2aee: 6504                 bcs.b      $2af4
2af0: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
2af4: 0c470007             cmpi.w     #$7, d7
2af8: 6c0001f2             bge.w      $2cec
2afc: 2f2ddec2             move.l     -$213e(a5), -(a7)
2b00: a873                 dc.w       $a873
2b02: 486efff8             pea.l      -$8(a6)
2b06: 3f07                 move.w     d7, -(a7)
2b08: 4ebaff74             jsr        $2a7e(pc)
2b0c: 4a6dd9ae             tst.w      -$2652(a5)
2b10: 5c8f                 addq.l     #$6, a7
2b12: 6610                 bne.b      $2b24
2b14: 204d                 movea.l    a5, a0
2b16: 2007                 move.l     d7, d0
2b18: 48c0                 ext.l      d0
2b1a: e588                 lsl.l      #$2, d0
2b1c: d1c0                 adda.l     d0, a0
2b1e: 4a68de28             tst.w      -$21d8(a0)
2b22: 660a                 bne.b      $2b2e
2b24: 486efff8             pea.l      -$8(a6)
2b28: a8a3                 dc.w       $a8a3
2b2a: 600001c0             bra.w      $2cec
2b2e: 4a2df269             tst.b      -$d97(a5)
2b32: 6714                 beq.b      $2b48
2b34: 3f3c0002             move.w     #$2, -(a7)
2b38: aa98                 dc.w       $aa98
2b3a: 486efff8             pea.l      -$8(a6)
2b3e: a8a3                 dc.w       $a8a3
2b40: 4878001e             pea.l      $1e.w
2b44: a863                 dc.w       $a863
2b46: 6006                 bra.b      $2b4e
2b48: 486efff8             pea.l      -$8(a6)
2b4c: a8a3                 dc.w       $a8a3
2b4e: 70ff                 moveq      #$ff, d0
2b50: d06efffe             add.w      -$2(a6), d0
2b54: 3f00                 move.w     d0, -(a7)
2b56: 7001                 moveq      #$1, d0
2b58: d06efff8             add.w      -$8(a6), d0
2b5c: 3f00                 move.w     d0, -(a7)
2b5e: a893                 dc.w       $a893
2b60: 70ff                 moveq      #$ff, d0
2b62: d06efffe             add.w      -$2(a6), d0
2b66: 3f00                 move.w     d0, -(a7)
2b68: 70ff                 moveq      #$ff, d0
2b6a: d06efffc             add.w      -$4(a6), d0
2b6e: 3f00                 move.w     d0, -(a7)
2b70: a891                 dc.w       $a891
2b72: 7001                 moveq      #$1, d0
2b74: d06efffa             add.w      -$6(a6), d0
2b78: 3f00                 move.w     d0, -(a7)
2b7a: 70ff                 moveq      #$ff, d0
2b7c: d06efffc             add.w      -$4(a6), d0
2b80: 3f00                 move.w     d0, -(a7)
2b82: a891                 dc.w       $a891
2b84: 536efffe             subq.w     #$1, -$2(a6)
2b88: 536efffc             subq.w     #$1, -$4(a6)
2b8c: 486efff8             pea.l      -$8(a6)
2b90: a8a1                 dc.w       $a8a1
2b92: 2007                 move.l     d7, d0
2b94: 48c0                 ext.l      d0
2b96: e588                 lsl.l      #$2, d0
2b98: 49edde28             lea.l      -$21d8(a5), a4
2b9c: d08c                 add.l      a4, d0
2b9e: 2840                 movea.l    d0, a4
2ba0: 3f14                 move.w     (a4), -(a7)
2ba2: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
2ba6: 3e00                 move.w     d0, d7
2ba8: 0c54003f             cmpi.w     #$3f, (a4)
2bac: 548f                 addq.l     #$2, a7
2bae: 6604                 bne.b      $2bb4
2bb0: 7000                 moveq      #$0, d0
2bb2: 600e                 bra.b      $2bc2
2bb4: 3f07                 move.w     d7, -(a7)
2bb6: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
2bba: 3e80                 move.w     d0, (a7)
2bbc: 4ead090a             jsr        $90a(a5) ; CODE31+0128
2bc0: 548f                 addq.l     #$2, a7
2bc2: 3c00                 move.w     d0, d6
2bc4: 3f3c0003             move.w     #$3, -(a7)
2bc8: a887                 dc.w       $a887
2bca: 206dde80             movea.l    -$2180(a5), a0
2bce: 3f28000c             move.w     $c(a0), -(a7)
2bd2: a88a                 dc.w       $a88a
2bd4: 3f3c0001             move.w     #$1, -(a7)
2bd8: a888                 dc.w       $a888
2bda: 3f3c0001             move.w     #$1, -(a7)
2bde: a889                 dc.w       $a889
2be0: 4267                 clr.w      -(a7)
2be2: 3f07                 move.w     d7, -(a7)
2be4: a88d                 dc.w       $a88d
2be6: 3a1f                 move.w     (a7)+, d5
2be8: 486efff0             pea.l      -$10(a6)
2bec: a88b                 dc.w       $a88b
2bee: 302efffa             move.w     -$6(a6), d0
2bf2: d06efffe             add.w      -$2(a6), d0
2bf6: 9045                 sub.w      d5, d0
2bf8: 48c0                 ext.l      d0
2bfa: 81fc0002             divs.w     #$2, d0
2bfe: 5540                 subq.w     #$2, d0
2c00: 3f00                 move.w     d0, -(a7)
2c02: 302efffc             move.w     -$4(a6), d0
2c06: d06efff8             add.w      -$8(a6), d0
2c0a: 306efff0             movea.w    -$10(a6), a0
2c0e: 5340                 subq.w     #$1, d0
2c10: d0c0                 adda.w     d0, a0
2c12: 2008                 move.l     a0, d0
2c14: 81fc0002             divs.w     #$2, d0
2c18: 5340                 subq.w     #$1, d0
2c1a: 3f00                 move.w     d0, -(a7)
2c1c: a893                 dc.w       $a893
2c1e: 0c47005a             cmpi.w     #$5a, d7
2c22: 660a                 bne.b      $2c2e
2c24: 2f3c0000ffff         move.l     #$ffff, -(a7)
2c2a: a894                 dc.w       $a894
2c2c: 601c                 bra.b      $2c4a
2c2e: 0c470051             cmpi.w     #$51, d7
2c32: 660a                 bne.b      $2c3e
2c34: 2f3c0000fffe         move.l     #$fffe, -(a7)
2c3a: a894                 dc.w       $a894
2c3c: 600c                 bra.b      $2c4a
2c3e: 0c470057             cmpi.w     #$57, d7
2c42: 6606                 bne.b      $2c4a
2c44: 48780001             pea.l      $1.w
2c48: a894                 dc.w       $a894
2c4a: 3f07                 move.w     d7, -(a7)
2c4c: a883                 dc.w       $a883
2c4e: 3005                 move.w     d5, d0
2c50: 4440                 neg.w      d0
2c52: 3f00                 move.w     d0, -(a7)
2c54: 3f3cffff             move.w     #$ffff, -(a7)
2c58: a894                 dc.w       $a894
2c5a: 3f07                 move.w     d7, -(a7)
2c5c: a883                 dc.w       $a883
2c5e: 3f3c0009             move.w     #$9, -(a7)
2c62: a88a                 dc.w       $a88a
2c64: 4267                 clr.w      -(a7)
2c66: a888                 dc.w       $a888
2c68: 0c46000a             cmpi.w     #$a, d6
2c6c: 6628                 bne.b      $2c96
2c6e: 70f6                 moveq      #$f6, d0
2c70: d06efffe             add.w      -$2(a6), d0
2c74: 3f00                 move.w     d0, -(a7)
2c76: 70fe                 moveq      #$fe, d0
2c78: d06efffc             add.w      -$4(a6), d0
2c7c: 3f00                 move.w     d0, -(a7)
2c7e: a893                 dc.w       $a893
2c80: 3f3c0031             move.w     #$31, -(a7)
2c84: a883                 dc.w       $a883
2c86: 2f3c0000fffe         move.l     #$fffe, -(a7)
2c8c: a894                 dc.w       $a894
2c8e: 3f3c0030             move.w     #$30, -(a7)
2c92: a883                 dc.w       $a883
2c94: 6032                 bra.b      $2cc8
2c96: 0c46000a             cmpi.w     #$a, d6
2c9a: 6c04                 bge.b      $2ca0
2c9c: 4a46                 tst.w      d6
2c9e: 6c04                 bge.b      $2ca4
2ca0: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
2ca4: 7e30                 moveq      #$30, d7
2ca6: de46                 add.w      d6, d7
2ca8: 4267                 clr.w      -(a7)
2caa: 3f07                 move.w     d7, -(a7)
2cac: a88d                 dc.w       $a88d
2cae: 3a1f                 move.w     (a7)+, d5
2cb0: 302efffe             move.w     -$2(a6), d0
2cb4: 9045                 sub.w      d5, d0
2cb6: 5540                 subq.w     #$2, d0
2cb8: 3f00                 move.w     d0, -(a7)
2cba: 70fe                 moveq      #$fe, d0
2cbc: d06efffc             add.w      -$4(a6), d0
2cc0: 3f00                 move.w     d0, -(a7)
2cc2: a893                 dc.w       $a893
2cc4: 3f07                 move.w     d7, -(a7)
2cc6: a883                 dc.w       $a883
2cc8: 4a6c0002             tst.w      $2(a4)
2ccc: 671e                 beq.b      $2cec
2cce: 486dfab2             pea.l      -$54e(a5)
2cd2: a89d                 dc.w       $a89d
2cd4: 3f3c000b             move.w     #$b, -(a7)
2cd8: a89c                 dc.w       $a89c
2cda: 486efff8             pea.l      -$8(a6)
2cde: a8a2                 dc.w       $a8a2
2ce0: 486dfaba             pea.l      -$546(a5)
2ce4: a89d                 dc.w       $a89d
2ce6: 3f3c0008             move.w     #$8, -(a7)
2cea: a89c                 dc.w       $a89c
2cec: 4cdf10e0             movem.l    (a7)+, d5-d7/a4
2cf0: 4e5e                 unlk       a6
2cf2: 4e75                 rts        
2cf4: 4e560000             link.w     a6, #$0
2cf8: 48e70118             movem.l    d7/a3-a4, -(a7)
2cfc: 286e0008             movea.l    $8(a6), a4
2d00: 7e00                 moveq      #$0, d7
2d02: 47edde28             lea.l      -$21d8(a5), a3
2d06: 600e                 bra.b      $2d16
2d08: 4a6b0002             tst.w      $2(a3)
2d0c: 6604                 bne.b      $2d12
2d0e: 18eb0001             move.b     $1(a3), (a4)+
2d12: 5247                 addq.w     #$1, d7
2d14: 588b                 addq.l     #$4, a3
2d16: 4a53                 tst.w      (a3)
2d18: 66ee                 bne.b      $2d08
2d1a: 4214                 clr.b      (a4)
2d1c: 202e0008             move.l     $8(a6), d0
2d20: 4cdf1880             movem.l    (a7)+, d7/a3-a4
2d24: 4e5e                 unlk       a6
2d26: 4e75                 rts        
2d28: 4e56fff4             link.w     a6, #$fff4
2d2c: 48e71f08             movem.l    d3-d7/a4, -(a7)
2d30: 206e000c             movea.l    $c(a6), a0
2d34: 1a280005             move.b     $5(a0), d5
2d38: 0c6d0001d9ae         cmpi.w     #$1, -$2652(a5)
2d3e: 66000098             bne.w      $2dd8
2d42: 1005                 move.b     d5, d0
2d44: 4880                 ext.w      d0
2d46: 3f00                 move.w     d0, -(a7)
2d48: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
2d4c: 1a00                 move.b     d0, d5
2d4e: 206e000c             movea.l    $c(a6), a0
2d52: 08280000000e         btst.b     #$0, $e(a0)
2d58: 548f                 addq.l     #$2, a7
2d5a: 660002b2             bne.w      $300e
2d5e: 7000                 moveq      #$0, d0
2d60: 1005                 move.b     d5, d0
2d62: 204d                 movea.l    a5, a0
2d64: d1c0                 adda.l     d0, a0
2d66: 1028fbd8             move.b     -$428(a0), d0
2d6a: 020000c0             andi.b     #$c0, d0
2d6e: 661a                 bne.b      $2d8a
2d70: 0c05003f             cmpi.b     #$3f, d5
2d74: 6714                 beq.b      $2d8a
2d76: 0c05001b             cmpi.b     #$1b, d5
2d7a: 670e                 beq.b      $2d8a
2d7c: 0c050008             cmpi.b     #$8, d5
2d80: 6708                 beq.b      $2d8a
2d82: 0c050003             cmpi.b     #$3, d5
2d86: 66000286             bne.w      $300e
2d8a: 206ddec2             movea.l    -$213e(a5), a0
2d8e: 286800a0             movea.l    $a0(a0), a4
2d92: 0c05001b             cmpi.b     #$1b, d5
2d96: 6712                 beq.b      $2daa
2d98: 0c050008             cmpi.b     #$8, d5
2d9c: 6614                 bne.b      $2db2
2d9e: 2054                 movea.l    (a4), a0
2da0: 30280020             move.w     $20(a0), d0
2da4: b0680022             cmp.w      $22(a0), d0
2da8: 6708                 beq.b      $2db2
2daa: 2f0c                 move.l     a4, -(a7)
2dac: a9d7                 dc.w       $a9d7
2dae: 6000025e             bra.w      $300e
2db2: 0c050003             cmpi.b     #$3, d5
2db6: 6612                 bne.b      $2dca
2db8: 3f3c000a             move.w     #$a, -(a7)
2dbc: 2f2ddeca             move.l     -$2136(a5), -(a7)
2dc0: 4ead01d2             jsr        $1d2(a5) ; CODE11+0bf8
2dc4: 5c8f                 addq.l     #$6, a7
2dc6: 60000246             bra.w      $300e
2dca: 1005                 move.b     d5, d0
2dcc: 4880                 ext.w      d0
2dce: 3f00                 move.w     d0, -(a7)
2dd0: 2f0c                 move.l     a4, -(a7)
2dd2: a9dc                 dc.w       $a9dc
2dd4: 60000238             bra.w      $300e
2dd8: 41edc35e             lea.l      -$3ca2(a5), a0
2ddc: b1edc376             cmpa.l     -$3c8a(a5), a0
2de0: 6700022c             beq.w      $300e
2de4: 362dde50             move.w     -$21b0(a5), d3
2de8: 382dde52             move.w     -$21ae(a5), d4
2dec: 4a6dde4e             tst.w      -$21b2(a5)
2df0: 6704                 beq.b      $2df6
2df2: 7001                 moveq      #$1, d0
2df4: 6002                 bra.b      $2df8
2df6: 7000                 moveq      #$0, d0
2df8: 3c00                 move.w     d0, d6
2dfa: 7e01                 moveq      #$1, d7
2dfc: 9e46                 sub.w      d6, d7
2dfe: 7011                 moveq      #$11, d0
2e00: c1c3                 muls.w     d3, d0
2e02: 41edd76c             lea.l      -$2894(a5), a0
2e06: d088                 add.l      a0, d0
2e08: 3044                 movea.w    d4, a0
2e0a: 1d700800ffff         move.b     (a0, d0.l), -$1(a6)
2e10: 1005                 move.b     d5, d0
2e12: 4880                 ext.w      d0
2e14: 5740                 subq.w     #$3, d0
2e16: 0c40001d             cmpi.w     #$1d, d0
2e1a: 62000172             bhi.w      $2f8e
2e1e: 43fa01f8             lea.l      $3018(pc), a1
2e22: d040                 add.w      d0, d0
2e24: d2f10000             adda.w     (a1, d0.w), a1
2e28: 4ed1                 jmp        (a1)
2e2a: 0c430001             cmpi.w     #$1, d3
2e2e: 6f0001d6             ble.w      $3006
2e32: 5343                 subq.w     #$1, d3
2e34: 600001d0             bra.w      $3006
2e38: 7001                 moveq      #$1, d0
2e3a: d043                 add.w      d3, d0
2e3c: 0c400010             cmpi.w     #$10, d0
2e40: 6c0001c4             bge.w      $3006
2e44: 5243                 addq.w     #$1, d3
2e46: 600001be             bra.w      $3006
2e4a: 0c440001             cmpi.w     #$1, d4
2e4e: 6f0001b6             ble.w      $3006
2e52: 5344                 subq.w     #$1, d4
2e54: 600001b0             bra.w      $3006
2e58: 0c440001             cmpi.w     #$1, d4
2e5c: 6604                 bne.b      $2e62
2e5e: 4a46                 tst.w      d6
2e60: 660a                 bne.b      $2e6c
2e62: 0c430001             cmpi.w     #$1, d3
2e66: 660e                 bne.b      $2e76
2e68: 4a47                 tst.w      d7
2e6a: 670a                 beq.b      $2e76
2e6c: 3f3c000f             move.w     #$f, -(a7)
2e70: a9c8                 dc.w       $a9c8
2e72: 60000192             bra.w      $3006
2e76: 3004                 move.w     d4, d0
2e78: d046                 add.w      d6, d0
2e7a: 0c400010             cmpi.w     #$10, d0
2e7e: 670a                 beq.b      $2e8a
2e80: 3003                 move.w     d3, d0
2e82: d047                 add.w      d7, d0
2e84: 0c400010             cmpi.w     #$10, d0
2e88: 6626                 bne.b      $2eb0
2e8a: 7011                 moveq      #$11, d0
2e8c: c1c3                 muls.w     d3, d0
2e8e: 41edd76c             lea.l      -$2894(a5), a0
2e92: d088                 add.l      a0, d0
2e94: 3044                 movea.w    d4, a0
2e96: 4a300800             tst.b      (a0, d0.l)
2e9a: 6714                 beq.b      $2eb0
2e9c: 7011                 moveq      #$11, d0
2e9e: c1c3                 muls.w     d3, d0
2ea0: 41edd76c             lea.l      -$2894(a5), a0
2ea4: d088                 add.l      a0, d0
2ea6: 3044                 movea.w    d4, a0
2ea8: 1d700800ffff         move.b     (a0, d0.l), -$1(a6)
2eae: 6016                 bra.b      $2ec6
2eb0: 9647                 sub.w      d7, d3
2eb2: 7011                 moveq      #$11, d0
2eb4: c1c3                 muls.w     d3, d0
2eb6: 9846                 sub.w      d6, d4
2eb8: 41edd76c             lea.l      -$2894(a5), a0
2ebc: d088                 add.l      a0, d0
2ebe: 3044                 movea.w    d4, a0
2ec0: 1d700800ffff         move.b     (a0, d0.l), -$1(a6)
2ec6: 4a2effff             tst.b      -$1(a6)
2eca: 6700013a             beq.w      $3006
2ece: 2f3c00010001         move.l     #$10001, -(a7)
2ed4: 4267                 clr.w      -(a7)
2ed6: 3f04                 move.w     d4, -(a7)
2ed8: 3f03                 move.w     d3, -(a7)
2eda: 4ebad220             jsr        $fc(pc)
2ede: 4a40                 tst.w      d0
2ee0: 4fef000a             lea.l      $a(a7), a7
2ee4: 67000128             beq.w      $300e
2ee8: 6000011c             bra.w      $3006
2eec: 7001                 moveq      #$1, d0
2eee: d044                 add.w      d4, d0
2ef0: 0c400010             cmpi.w     #$10, d0
2ef4: 6c000110             bge.w      $3006
2ef8: 5244                 addq.w     #$1, d4
2efa: 6000010a             bra.w      $3006
2efe: 4a6dd9ae             tst.w      -$2652(a5)
2f02: 6718                 beq.b      $2f1c
2f04: 7801                 moveq      #$1, d4
2f06: 7001                 moveq      #$1, d0
2f08: d043                 add.w      d3, d0
2f0a: 0c400010             cmpi.w     #$10, d0
2f0e: 6c06                 bge.b      $2f16
2f10: 5243                 addq.w     #$1, d3
2f12: 600000f2             bra.w      $3006
2f16: 7601                 moveq      #$1, d3
2f18: 600000ec             bra.w      $3006
2f1c: 206ddeca             movea.l    -$2136(a5), a0
2f20: 2050                 movea.l    (a0), a0
2f22: 4a280011             tst.b      $11(a0)
2f26: 660000de             bne.w      $3006
2f2a: 3f3c000a             move.w     #$a, -(a7)
2f2e: 2f2ddeca             move.l     -$2136(a5), -(a7)
2f32: 4ead01d2             jsr        $1d2(a5) ; CODE11+0bf8
2f36: 5c8f                 addq.l     #$6, a7
2f38: 600000cc             bra.w      $3006
2f3c: 0c6d0002d9ae         cmpi.w     #$2, -$2652(a5)
2f42: 660000c2             bne.w      $3006
2f46: 206ddec2             movea.l    -$213e(a5), a0
2f4a: 2f2800a0             move.l     $a0(a0), -(a7)
2f4e: a9d8                 dc.w       $a9d8
2f50: 3b7c0001d9ae         move.w     #$1, -$2652(a5)
2f56: 600000ae             bra.w      $3006
2f5a: 4a2effff             tst.b      -$1(a6)
2f5e: 671a                 beq.b      $2f7a
2f60: 2f3c00010001         move.l     #$10001, -(a7)
2f66: 4267                 clr.w      -(a7)
2f68: 3f04                 move.w     d4, -(a7)
2f6a: 3f03                 move.w     d3, -(a7)
2f6c: 4ebad18e             jsr        $fc(pc)
2f70: 4a40                 tst.w      d0
2f72: 4fef000a             lea.l      $a(a7), a7
2f76: 67000096             beq.w      $300e
2f7a: 4a47                 tst.w      d7
2f7c: 6600feba             bne.w      $2e38
2f80: 4a46                 tst.w      d6
2f82: 6600ff68             bne.w      $2eec
2f86: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
2f8a: 6000ff60             bra.w      $2eec
2f8e: 7000                 moveq      #$0, d0
2f90: 1005                 move.b     d5, d0
2f92: 204d                 movea.l    a5, a0
2f94: d1c0                 adda.l     d0, a0
2f96: 08280006fbd8         btst.b     #$6, -$428(a0)
2f9c: 670e                 beq.b      $2fac
2f9e: 1005                 move.b     d5, d0
2fa0: 4880                 ext.w      d0
2fa2: 3f00                 move.w     d0, -(a7)
2fa4: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
2fa8: 548f                 addq.l     #$2, a7
2faa: 600c                 bra.b      $2fb8
2fac: 1005                 move.b     d5, d0
2fae: 4880                 ext.w      d0
2fb0: 3f00                 move.w     d0, -(a7)
2fb2: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
2fb6: 548f                 addq.l     #$2, a7
2fb8: 1a00                 move.b     d0, d5
2fba: 7000                 moveq      #$0, d0
2fbc: 1005                 move.b     d5, d0
2fbe: 204d                 movea.l    a5, a0
2fc0: d1c0                 adda.l     d0, a0
2fc2: 1028fbd8             move.b     -$428(a0), d0
2fc6: 020000c0             andi.b     #$c0, d0
2fca: 6742                 beq.b      $300e
2fcc: ba2effff             cmp.b      -$1(a6), d5
2fd0: 671c                 beq.b      $2fee
2fd2: 2f3c00010001         move.l     #$10001, -(a7)
2fd8: 1005                 move.b     d5, d0
2fda: 4880                 ext.w      d0
2fdc: 3f00                 move.w     d0, -(a7)
2fde: 3f04                 move.w     d4, -(a7)
2fe0: 3f03                 move.w     d3, -(a7)
2fe2: 4ebad118             jsr        $fc(pc)
2fe6: 4a40                 tst.w      d0
2fe8: 4fef000a             lea.l      $a(a7), a7
2fec: 6720                 beq.b      $300e
2fee: 3004                 move.w     d4, d0
2ff0: d046                 add.w      d6, d0
2ff2: 0c400010             cmpi.w     #$10, d0
2ff6: 6c0e                 bge.b      $3006
2ff8: 3003                 move.w     d3, d0
2ffa: d047                 add.w      d7, d0
2ffc: 0c400010             cmpi.w     #$10, d0
3000: 6c04                 bge.b      $3006
3002: d846                 add.w      d6, d4
3004: d647                 add.w      d7, d3
3006: 3f04                 move.w     d4, -(a7)
3008: 3f03                 move.w     d3, -(a7)
300a: 4ebaf564             jsr        $2570(pc)
300e: 4cee10f8ffdc         movem.l    -$24(a6), d3-d7/a4
3014: 4e5e                 unlk       a6
3016: 4e75                 rts        
3018: ff04                 dc.w       $ff04
301a: ff76ff76ff76ff76     frestore   ([$ff76ff76, a6])
3022: fe40ff24             ftanh.b    d0
3026: ff76ff76ff76fee6     frestore   ([$ff76fee6, a6])
302e: ff76ff76ff76ff76     frestore   ([$ff76ff76, a6])
3036: ff76ff76ff76ff76     frestore   ([$ff76ff76, a6])
303e: ff76ff76ff76ff76     frestore   ([$ff76ff76, a6])
3046: ff76ff76fe32fed4     frestore   ([$fe32fed4, a6])
304e: fe12fe20             fmovem     invalid, (a2)
3052: ff42                 dc.w       $ff42
3054: 4e560000             link.w     a6, #$0
3058: 4a6dd9ae             tst.w      -$2652(a5)
305c: 6620                 bne.b      $307e
305e: 4eba0042             jsr        $30a2(pc)
3062: 4a40                 tst.w      d0
3064: 6618                 bne.b      $307e
3066: 2f2e0010             move.l     $10(a6), -(a7)
306a: 2f2e000c             move.l     $c(a6), -(a7)
306e: 2f2e0008             move.l     $8(a6), -(a7)
3072: 4ead019a             jsr        $19a(a5) ; CODE11+116c
3076: 4a80                 tst.l      d0
3078: 4fef000c             lea.l      $c(a7), a7
307c: 6604                 bne.b      $3082
307e: 7000                 moveq      #$0, d0
3080: 6002                 bra.b      $3084
3082: 7001                 moveq      #$1, d0
3084: 4e5e                 unlk       a6
3086: 4e75                 rts        
3088: 4e560000             link.w     a6, #$0
308c: 4ebad71c             jsr        $7aa(pc)
3090: 4e5e                 unlk       a6
3092: 4e75                 rts        
3094: 4e560000             link.w     a6, #$0
3098: 4267                 clr.w      -(a7)
309a: 4ebad88a             jsr        $926(pc)
309e: 4e5e                 unlk       a6
30a0: 4e75                 rts        
30a2: 206dded2             movea.l    -$212e(a5), a0
30a6: 2050                 movea.l    (a0), a0
30a8: 4a280010             tst.b      $10(a0)
30ac: 56c0                 sne.b      d0
30ae: 4400                 neg.b      d0
30b0: 4880                 ext.w      d0
30b2: 4e75                 rts        
30b4: 4e560000             link.w     a6, #$0
30b8: 2f2e000c             move.l     $c(a6), -(a7)
30bc: 2f2e0008             move.l     $8(a6), -(a7)
30c0: 4ead0cf2             jsr        $cf2(a5) ; CODE48+00a0
30c4: 2eae000c             move.l     $c(a6), (a7)
30c8: 2f2e0008             move.l     $8(a6), -(a7)
30cc: 4ead0c4a             jsr        $c4a(a5) ; CODE46+0b40
30d0: 4e5e                 unlk       a6
30d2: 4e75                 rts        
30d4: 4e560000             link.w     a6, #$0
30d8: 2f2e000c             move.l     $c(a6), -(a7)
30dc: 2f2e0008             move.l     $8(a6), -(a7)
30e0: 4ead0cfa             jsr        $cfa(a5) ; CODE48+00be
30e4: 2eae000c             move.l     $c(a6), (a7)
30e8: 2f2e0008             move.l     $8(a6), -(a7)
30ec: 4ead0c4a             jsr        $c4a(a5) ; CODE46+0b40
30f0: 4e5e                 unlk       a6
30f2: 4e75                 rts        
30f4: 4e56fff2             link.w     a6, #$fff2
30f8: 48e70118             movem.l    d7/a3-a4, -(a7)
30fc: 266e000c             movea.l    $c(a6), a3
3100: 99cc                 suba.l     a4, a4
3102: 2f2e0008             move.l     $8(a6), -(a7)
3106: a873                 dc.w       $a873
3108: 2d6b000afff4         move.l     $a(a3), -$c(a6)
310e: 486efff4             pea.l      -$c(a6)
3112: a871                 dc.w       $a871
3114: 4227                 clr.b      -(a7)
3116: 2f2efff4             move.l     -$c(a6), -(a7)
311a: 206e0008             movea.l    $8(a6), a0
311e: 2f280018             move.l     $18(a0), -(a7)
3122: a8e8                 dc.w       $a8e8
3124: 4a1f                 tst.b      (a7)+
3126: 673c                 beq.b      $3164
3128: 486efff8             pea.l      -$8(a6)
312c: 4ead03e2             jsr        $3e2(a5) ; CODE20+053c
3130: 4217                 clr.b      (a7)
3132: 2f2efff4             move.l     -$c(a6), -(a7)
3136: 486efff8             pea.l      -$8(a6)
313a: a8ad                 dc.w       $a8ad
313c: 4a1f                 tst.b      (a7)+
313e: 548f                 addq.l     #$2, a7
3140: 6722                 beq.b      $3164
3142: 4a6dde4e             tst.w      -$21b2(a5)
3146: 670e                 beq.b      $3156
3148: 42a7                 clr.l      -(a7)
314a: 3f3c3903             move.w     #$3903, -(a7)
314e: a9b9                 dc.w       $a9b9
3150: 205f                 movea.l    (a7)+, a0
3152: 2010                 move.l     (a0), d0
3154: 600c                 bra.b      $3162
3156: 42a7                 clr.l      -(a7)
3158: 3f3c0003             move.w     #$3, -(a7)
315c: a9b9                 dc.w       $a9b9
315e: 205f                 movea.l    (a7)+, a0
3160: 2010                 move.l     (a0), d0
3162: 2840                 movea.l    d0, a4
3164: 4ebaff3c             jsr        $30a2(pc)
3168: 4a40                 tst.w      d0
316a: 6622                 bne.b      $318e
316c: 4a6dd9ae             tst.w      -$2652(a5)
3170: 661c                 bne.b      $318e
3172: 0c6d0005de66         cmpi.w     #$5, -$219a(a5)
3178: 6708                 beq.b      $3182
317a: 0c6d0008de66         cmpi.w     #$8, -$219a(a5)
3180: 6606                 bne.b      $3188
3182: 4a2dc366             tst.b      -$3c9a(a5)
3186: 6606                 bne.b      $318e
3188: 303c00ff             move.w     #$ff, d0
318c: 6002                 bra.b      $3190
318e: 7000                 moveq      #$0, d0
3190: 3e00                 move.w     d0, d7
3192: 206ddeca             movea.l    -$2136(a5), a0
3196: 2050                 movea.l    (a0), a0
3198: 7000                 moveq      #$0, d0
319a: 10280011             move.b     $11(a0), d0
319e: b047                 cmp.w      d7, d0
31a0: 6708                 beq.b      $31aa
31a2: 2f2ddeca             move.l     -$2136(a5), -(a7)
31a6: 3f07                 move.w     d7, -(a7)
31a8: a95d                 dc.w       $a95d
31aa: 302dd9ae             move.w     -$2652(a5), d0
31ae: b06defac             cmp.w      -$1054(a5), d0
31b2: 661a                 bne.b      $31ce
31b4: 4a2da74e             tst.b      -$58b2(a5)
31b8: 56c0                 sne.b      d0
31ba: 4400                 neg.b      d0
31bc: 4880                 ext.w      d0
31be: b06defaa             cmp.w      -$1056(a5), d0
31c2: 660a                 bne.b      $31ce
31c4: 302dde66             move.w     -$219a(a5), d0
31c8: b06defae             cmp.w      -$1052(a5), d0
31cc: 674c                 beq.b      $321a
31ce: 4a2da74e             tst.b      -$58b2(a5)
31d2: 56c0                 sne.b      d0
31d4: 4400                 neg.b      d0
31d6: 4880                 ext.w      d0
31d8: 3b40efaa             move.w     d0, -$1056(a5)
31dc: 3b6dd9aeefac         move.w     -$2652(a5), -$1054(a5)
31e2: 3b6dde66efae         move.w     -$219a(a5), -$1052(a5)
31e8: 2f2ddeca             move.l     -$2136(a5), -(a7)
31ec: 4a6dd9ae             tst.w      -$2652(a5)
31f0: 6608                 bne.b      $31fa
31f2: 4ebafeae             jsr        $30a2(pc)
31f6: 4a40                 tst.w      d0
31f8: 6708                 beq.b      $3202
31fa: 41edf138             lea.l      -$ec8(a5), a0
31fe: 2008                 move.l     a0, d0
3200: 6014                 bra.b      $3216
3202: 4a6defaa             tst.w      -$1056(a5)
3206: 6708                 beq.b      $3210
3208: 41edf13c             lea.l      -$ec4(a5), a0
320c: 2008                 move.l     a0, d0
320e: 6006                 bra.b      $3216
3210: 41edf142             lea.l      -$ebe(a5), a0
3214: 2008                 move.l     a0, d0
3216: 2f00                 move.l     d0, -(a7)
3218: a95f                 dc.w       $a95f
321a: 2f2ddece             move.l     -$2132(a5), -(a7)
321e: 4a6dd9ae             tst.w      -$2652(a5)
3222: 6606                 bne.b      $322a
3224: 4a6dde54             tst.w      -$21ac(a5)
3228: 6704                 beq.b      $322e
322a: 7000                 moveq      #$0, d0
322c: 6004                 bra.b      $3232
322e: 303c00ff             move.w     #$ff, d0
3232: 3f00                 move.w     d0, -(a7)
3234: a95d                 dc.w       $a95d
3236: 4a6dd9ae             tst.w      -$2652(a5)
323a: 662e                 bne.b      $326a
323c: 0c6d0005de66         cmpi.w     #$5, -$219a(a5)
3242: 6626                 bne.b      $326a
3244: 2e2b0006             move.l     $6(a3), d7
3248: 703c                 moveq      #$3c, d0
324a: d0adde5a             add.l      -$21a6(a5), d0
324e: b087                 cmp.l      d7, d0
3250: 6e18                 bgt.b      $326a
3252: 2007                 move.l     d7, d0
3254: 90adde5a             sub.l      -$21a6(a5), d0
3258: d1adde56             add.l      d0, -$21aa(a5)
325c: 2b47de5a             move.l     d7, -$21a6(a5)
3260: 3f3c0001             move.w     #$1, -(a7)
3264: 4ebae196             jsr        $13fc(pc)
3268: 548f                 addq.l     #$2, a7
326a: 4a6def1c             tst.w      -$10e4(a5)
326e: 6722                 beq.b      $3292
3270: 202defe6             move.l     -$101a(a5), d0
3274: b0ab0006             cmp.l      $6(a3), d0
3278: 6e18                 bgt.b      $3292
327a: 0c6d0001ef1c         cmpi.w     #$1, -$10e4(a5)
3280: 6c08                 bge.b      $328a
3282: 703c                 moveq      #$3c, d0
3284: d1adefe6             add.l      d0, -$101a(a5)
3288: 6008                 bra.b      $3292
328a: 4267                 clr.w      -(a7)
328c: 4ebad89a             jsr        $b28(pc)
3290: 548f                 addq.l     #$2, a7
3292: 0c6d0001d9ae         cmpi.w     #$1, -$2652(a5)
3298: 660a                 bne.b      $32a4
329a: 206ddec2             movea.l    -$213e(a5), a0
329e: 2f2800a0             move.l     $a0(a0), -(a7)
32a2: a9da                 dc.w       $a9da
32a4: 4ebafdfc             jsr        $30a2(pc)
32a8: 4a40                 tst.w      d0
32aa: 6704                 beq.b      $32b0
32ac: 286defda             movea.l    -$1026(a5), a4
32b0: 200c                 move.l     a4, d0
32b2: 4cdf1880             movem.l    (a7)+, d7/a3-a4
32b6: 4e5e                 unlk       a6
32b8: 4e75                 rts        
32ba: 4e56fff0             link.w     a6, #$fff0
32be: 48e70300             movem.l    d6-d7, -(a7)
32c2: 206dde78             movea.l    -$2188(a5), a0
32c6: 2050                 movea.l    (a0), a0
32c8: 4a68030c             tst.w      $30c(a0)
32cc: 6700010e             beq.w      $33dc
32d0: 3f3c0016             move.w     #$16, -(a7)
32d4: a887                 dc.w       $a887
32d6: 3f3c000a             move.w     #$a, -(a7)
32da: a88a                 dc.w       $a88a
32dc: 486efff0             pea.l      -$10(a6)
32e0: a88b                 dc.w       $a88b
32e2: 7e41                 moveq      #$41, d7
32e4: 6042                 bra.b      $3328
32e6: 1c07                 move.b     d7, d6
32e8: 4886                 ext.w      d6
32ea: 70c0                 moveq      #$c0, d0
32ec: d046                 add.w      d6, d0
32ee: 3f00                 move.w     d0, -(a7)
32f0: 3f3c0001             move.w     #$1, -(a7)
32f4: 486efff8             pea.l      -$8(a6)
32f8: 4ead03ea             jsr        $3ea(a5) ; CODE20+05f4
32fc: 4257                 clr.w      (a7)
32fe: 3f06                 move.w     d6, -(a7)
3300: a88d                 dc.w       $a88d
3302: 302efffe             move.w     -$2(a6), d0
3306: d06efffa             add.w      -$6(a6), d0
330a: 905f                 sub.w      (a7)+, d0
330c: 48c0                 ext.l      d0
330e: 81fc0002             divs.w     #$2, d0
3312: 3e80                 move.w     d0, (a7)
3314: 302efff8             move.w     -$8(a6), d0
3318: 906efff2             sub.w      -$e(a6), d0
331c: 3f00                 move.w     d0, -(a7)
331e: a893                 dc.w       $a893
3320: 3e86                 move.w     d6, (a7)
3322: a883                 dc.w       $a883
3324: 548f                 addq.l     #$2, a7
3326: 5207                 addq.b     #$1, d7
3328: 0c07004f             cmpi.b     #$4f, d7
332c: 6fb8                 ble.b      $32e6
332e: 7e31                 moveq      #$31, d7
3330: 6046                 bra.b      $3378
3332: 1c07                 move.b     d7, d6
3334: 4886                 ext.w      d6
3336: 3f3c0001             move.w     #$1, -(a7)
333a: 70d0                 moveq      #$d0, d0
333c: d046                 add.w      d6, d0
333e: 3f00                 move.w     d0, -(a7)
3340: 486efff8             pea.l      -$8(a6)
3344: 4ead03ea             jsr        $3ea(a5) ; CODE20+05f4
3348: 4257                 clr.w      (a7)
334a: 3f06                 move.w     d6, -(a7)
334c: a88d                 dc.w       $a88d
334e: 302efffa             move.w     -$6(a6), d0
3352: 905f                 sub.w      (a7)+, d0
3354: 5540                 subq.w     #$2, d0
3356: 3e80                 move.w     d0, (a7)
3358: 302efff8             move.w     -$8(a6), d0
335c: d06efffc             add.w      -$4(a6), d0
3360: 306efff0             movea.w    -$10(a6), a0
3364: d0c0                 adda.w     d0, a0
3366: 2008                 move.l     a0, d0
3368: 81fc0002             divs.w     #$2, d0
336c: 3f00                 move.w     d0, -(a7)
336e: a893                 dc.w       $a893
3370: 3e86                 move.w     d6, (a7)
3372: a883                 dc.w       $a883
3374: 548f                 addq.l     #$2, a7
3376: 5207                 addq.b     #$1, d7
3378: 0c070039             cmpi.b     #$39, d7
337c: 6fb4                 ble.b      $3332
337e: 7e30                 moveq      #$30, d7
3380: 6054                 bra.b      $33d6
3382: 1c07                 move.b     d7, d6
3384: 4886                 ext.w      d6
3386: 3f3c0001             move.w     #$1, -(a7)
338a: 70da                 moveq      #$da, d0
338c: d046                 add.w      d6, d0
338e: 3f00                 move.w     d0, -(a7)
3390: 486efff8             pea.l      -$8(a6)
3394: 4ead03ea             jsr        $3ea(a5) ; CODE20+05f4
3398: 4257                 clr.w      (a7)
339a: 3f06                 move.w     d6, -(a7)
339c: a88d                 dc.w       $a88d
339e: 301f                 move.w     (a7)+, d0
33a0: d040                 add.w      d0, d0
33a2: 322efffa             move.w     -$6(a6), d1
33a6: 9240                 sub.w      d0, d1
33a8: 3e81                 move.w     d1, (a7)
33aa: 302efff8             move.w     -$8(a6), d0
33ae: d06efffc             add.w      -$4(a6), d0
33b2: 306efff0             movea.w    -$10(a6), a0
33b6: d0c0                 adda.w     d0, a0
33b8: 2008                 move.l     a0, d0
33ba: 81fc0002             divs.w     #$2, d0
33be: 3f00                 move.w     d0, -(a7)
33c0: a893                 dc.w       $a893
33c2: 3ebc0031             move.w     #$31, (a7)
33c6: a883                 dc.w       $a883
33c8: 2f3c0000ffff         move.l     #$ffff, -(a7)
33ce: a894                 dc.w       $a894
33d0: 3e86                 move.w     d6, (a7)
33d2: a883                 dc.w       $a883
33d4: 5207                 addq.b     #$1, d7
33d6: 0c070035             cmpi.b     #$35, d7
33da: 6fa6                 ble.b      $3382
33dc: 4cdf00c0             movem.l    (a7)+, d6-d7
33e0: 4e5e                 unlk       a6
33e2: 4e75                 rts        
33e4: 2f2dde60             move.l     -$21a0(a5), -(a7)
33e8: a9a2                 dc.w       $a9a2
33ea: 206dde60             movea.l    -$21a0(a5), a0
33ee: 4a90                 tst.l      (a0)
33f0: 6604                 bne.b      $33f6
33f2: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
33f6: 206dde60             movea.l    -$21a0(a5), a0
33fa: a029                 dc.w       $a029
33fc: 4e75                 rts        
33fe: 206dde60             movea.l    -$21a0(a5), a0
3402: a02a                 dc.w       $a02a
3404: 2f2dde60             move.l     -$21a0(a5), -(a7)
3408: 3f3c0020             move.w     #$20, -(a7)
340c: a9a7                 dc.w       $a9a7
340e: 2f2dde60             move.l     -$21a0(a5), -(a7)
3412: a9aa                 dc.w       $a9aa
3414: 4267                 clr.w      -(a7)
3416: a994                 dc.w       $a994
3418: a999                 dc.w       $a999
341a: 4e75                 rts        
341c: 4e560000             link.w     a6, #$0
3420: 4ebad3a2             jsr        $7c4(pc)
3424: 4e5e                 unlk       a6
3426: 4e75                 rts        
3428: 4aaddec2             tst.l      -$213e(a5)
342c: 6710                 beq.b      $343e
342e: 2f2ddec2             move.l     -$213e(a5), -(a7)
3432: a873                 dc.w       $a873
3434: 206ddec2             movea.l    -$213e(a5), a0
3438: 48680010             pea.l      $10(a0)
343c: a928                 dc.w       $a928
343e: 4e75                 rts        
3440: 4e56fef8             link.w     a6, #$fef8
3444: 206dde78             movea.l    -$2188(a5), a0
3448: 2050                 movea.l    (a0), a0
344a: 4a68030a             tst.w      $30a(a0)
344e: 6778                 beq.b      $34c8
3450: 4227                 clr.b      -(a7)
3452: 206dde80             movea.l    -$2180(a5), a0
3456: 48680046             pea.l      $46(a0)
345a: 226ddec2             movea.l    -$213e(a5), a1
345e: 2f290018             move.l     $18(a1), -(a7)
3462: a8e9                 dc.w       $a8e9
3464: 4a1f                 tst.b      (a7)+
3466: 6760                 beq.b      $34c8
3468: 2f2ddec2             move.l     -$213e(a5), -(a7)
346c: a873                 dc.w       $a873
346e: 4267                 clr.w      -(a7)
3470: a889                 dc.w       $a889
3472: 3f3c0004             move.w     #$4, -(a7)
3476: a887                 dc.w       $a887
3478: 3f3c0009             move.w     #$9, -(a7)
347c: a88a                 dc.w       $a88a
347e: 206dde80             movea.l    -$2180(a5), a0
3482: 48680046             pea.l      $46(a0)
3486: a8a1                 dc.w       $a8a1
3488: 486eff00             pea.l      -$100(a6)
348c: 4ebad01e             jsr        $4ac(pc)
3490: 206dde80             movea.l    -$2180(a5), a0
3494: 2d680046fef8         move.l     $46(a0), -$108(a6)
349a: 2d68004afefc         move.l     $4a(a0), -$104(a6)
34a0: 486efef8             pea.l      -$108(a6)
34a4: 2f3c00010001         move.l     #$10001, -(a7)
34aa: a8a9                 dc.w       $a8a9
34ac: 486eff00             pea.l      -$100(a6)
34b0: 486eff00             pea.l      -$100(a6)
34b4: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
34b8: 2e80                 move.l     d0, (a7)
34ba: 486efef8             pea.l      -$108(a6)
34be: 4267                 clr.w      -(a7)
34c0: a9ce                 dc.w       $a9ce
34c2: 3ebc0001             move.w     #$1, (a7)
34c6: a889                 dc.w       $a889
34c8: 4e5e                 unlk       a6
34ca: 4e75                 rts        
34cc: 4ebaff5a             jsr        $3428(pc)
34d0: 206dde78             movea.l    -$2188(a5), a0
34d4: 2050                 movea.l    (a0), a0
34d6: 4a68030c             tst.w      $30c(a0)
34da: 671e                 beq.b      $34fa
34dc: 206dde80             movea.l    -$2180(a5), a0
34e0: 5568000a             subq.w     #$2, $a(a0)
34e4: 206dde80             movea.l    -$2180(a5), a0
34e8: 0668000d000e         addi.w     #$d, $e(a0)
34ee: 206dde80             movea.l    -$2180(a5), a0
34f2: 0668000d0010         addi.w     #$d, $10(a0)
34f8: 601c                 bra.b      $3516
34fa: 206dde80             movea.l    -$2180(a5), a0
34fe: 5468000a             addq.w     #$2, $a(a0)
3502: 206dde80             movea.l    -$2180(a5), a0
3506: 0468000d000e         subi.w     #$d, $e(a0)
350c: 206dde80             movea.l    -$2180(a5), a0
3510: 0468000d0010         subi.w     #$d, $10(a0)
3516: 4e75                 rts        
3518: 4e560000             link.w     a6, #$0
351c: 2f0c                 move.l     a4, -(a7)
351e: 286e000c             movea.l    $c(a6), a4
3522: 0c540003             cmpi.w     #$3, (a4)
3526: 6640                 bne.b      $3568
3528: 70ff                 moveq      #$ff, d0
352a: c02c0005             and.b      $5(a4), d0
352e: 1b40de4c             move.b     d0, -$21b4(a5)
3532: 322c000e             move.w     $e(a4), d1
3536: 02410900             andi.w     #$900, d1
353a: 662c                 bne.b      $3568
353c: 7000                 moveq      #$0, d0
353e: 102dde4c             move.b     -$21b4(a5), d0
3542: 204d                 movea.l    a5, a0
3544: d1c0                 adda.l     d0, a0
3546: 1028fbd8             move.b     -$428(a0), d0
354a: 020000c0             andi.b     #$c0, d0
354e: 6718                 beq.b      $3568
3550: 102dde4c             move.b     -$21b4(a5), d0
3554: 4880                 ext.w      d0
3556: 3f00                 move.w     d0, -(a7)
3558: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
355c: 1b40de4c             move.b     d0, -$21b4(a5)
3560: 1d7c00010014         move.b     #$1, $14(a6)
3566: 6014                 bra.b      $357c
3568: 4227                 clr.b      -(a7)
356a: 2f2e0010             move.l     $10(a6), -(a7)
356e: 2f0c                 move.l     a4, -(a7)
3570: 2f2e0008             move.l     $8(a6), -(a7)
3574: 4ead0c8a             jsr        $c8a(a5) ; CODE41+0120
3578: 1d5f0014             move.b     (a7)+, $14(a6)
357c: 286efffc             movea.l    -$4(a6), a4
3580: 4e5e                 unlk       a6
3582: 205f                 movea.l    (a7)+, a0
3584: 4fef000c             lea.l      $c(a7), a7
3588: 4ed0                 jmp        (a0)
358a: 486d0532             pea.l      $532(a5)
358e: 3f3c03f2             move.w     #$3f2, -(a7)
3592: 4ead0c82             jsr        $c82(a5) ; CODE41+00d8
3596: 5c8f                 addq.l     #$6, a7
3598: 4e75                 rts        
