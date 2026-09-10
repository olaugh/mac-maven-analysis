0004: 4eba051a             jsr        $520(pc)
0008: 48780220             pea.l      $220.w
000c: 486dbcfe             pea.l      -$4302(a5)
0010: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0014: 48780121             pea.l      $121.w
0018: 486dd76c             pea.l      -$2894(a5)
001c: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0020: 48780121             pea.l      $121.w
0024: 486dd88d             pea.l      -$2773(a5)
0028: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
002c: 48780440             pea.l      $440.w
0030: 486dbf1e             pea.l      -$40e2(a5)
0034: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0038: 426dd9ae             clr.w      -$2652(a5)
003c: 4ead0292             jsr        $292(a5) ; CODE14+0318
0040: 4ead053a             jsr        $53a(a5) ; CODE21+08fe
0044: 4eba0cb4             jsr        $cfa(pc)
0048: 4fef0020             lea.l      $20(a7), a7
004c: 4e75                 rts        
004e: 48780220             pea.l      $220.w
0052: 486dbcfe             pea.l      -$4302(a5)
0056: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
005a: 48780440             pea.l      $440.w
005e: 486dbf1e             pea.l      -$40e2(a5)
0062: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0066: 486d0442             pea.l      $442(a5)
006a: 4eba03ae             jsr        $41a(pc)
006e: 4ead053a             jsr        $53a(a5) ; CODE21+08fe
0072: 4fef0014             lea.l      $14(a7), a7
0076: 4e75                 rts        
0078: 4e560000             link.w     a6, #$0
007c: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
0080: 3e2e0008             move.w     $8(a6), d7
0084: 3c2e000a             move.w     $a(a6), d6
0088: 7011                 moveq      #$11, d0
008a: c1c7                 muls.w     d7, d0
008c: 49edd76c             lea.l      -$2894(a5), a4
0090: d08c                 add.l      a4, d0
0092: 3846                 movea.w    d6, a4
0094: d08c                 add.l      a4, d0
0096: 2840                 movea.l    d0, a4
0098: 7011                 moveq      #$11, d0
009a: c1c7                 muls.w     d7, d0
009c: 47edd88d             lea.l      -$2773(a5), a3
00a0: d08b                 add.l      a3, d0
00a2: 3646                 movea.w    d6, a3
00a4: d08b                 add.l      a3, d0
00a6: 2640                 movea.l    d0, a3
00a8: 1014                 move.b     (a4), d0
00aa: b013                 cmp.b      (a3), d0
00ac: 670c                 beq.b      $ba
00ae: 1893                 move.b     (a3), (a4)
00b0: 3f06                 move.w     d6, -(a7)
00b2: 3f07                 move.w     d7, -(a7)
00b4: 4eba0592             jsr        $648(pc)
00b8: 588f                 addq.l     #$4, a7
00ba: 4cdf18c0             movem.l    (a7)+, d6-d7/a3-a4
00be: 4e5e                 unlk       a6
00c0: 4e75                 rts        
00c2: 4e56fff8             link.w     a6, #$fff8
00c6: 48e71f08             movem.l    d3-d7/a4, -(a7)
00ca: 7e00                 moveq      #$0, d7
00cc: 7c00                 moveq      #$0, d6
00ce: 42aefff8             clr.l      -$8(a6)
00d2: 42aefffc             clr.l      -$4(a6)
00d6: 7a00                 moveq      #$0, d5
00d8: 49edde28             lea.l      -$21d8(a5), a4
00dc: 3814                 move.w     (a4), d4
00de: 4a44                 tst.w      d4
00e0: 6738                 beq.b      $11a
00e2: 2604                 move.l     d4, d3
00e4: 48c3                 ext.l      d3
00e6: d7aefffc             add.l      d3, -$4(a6)
00ea: 2f03                 move.l     d3, -(a7)
00ec: 2f03                 move.l     d3, -(a7)
00ee: 4ead0042             jsr        $42(a5) ; CODE1+00ee
00f2: dc80                 add.l      d0, d6
00f4: 2f03                 move.l     d3, -(a7)
00f6: 2f03                 move.l     d3, -(a7)
00f8: 2f03                 move.l     d3, -(a7)
00fa: 4ead0042             jsr        $42(a5) ; CODE1+00ee
00fe: 2f00                 move.l     d0, -(a7)
0100: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0104: 2800                 move.l     d0, d4
0106: de84                 add.l      d4, d7
0108: 2f04                 move.l     d4, -(a7)
010a: 2f03                 move.l     d3, -(a7)
010c: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0110: d1aefff8             add.l      d0, -$8(a6)
0114: 5285                 addq.l     #$1, d5
0116: 588c                 addq.l     #$4, a4
0118: 60c2                 bra.b      $dc
011a: 486dc366             pea.l      -$3c9a(a5)
011e: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
0122: b085                 cmp.l      d5, d0
0124: 588f                 addq.l     #$4, a7
0126: 6704                 beq.b      $12c
0128: 7000                 moveq      #$0, d0
012a: 6060                 bra.b      $18c
012c: 7a00                 moveq      #$0, d5
012e: 204d                 movea.l    a5, a0
0130: d1c5                 adda.l     d5, a0
0132: 1828c366             move.b     -$3c9a(a0), d4
0136: 4a04                 tst.b      d4
0138: 6738                 beq.b      $172
013a: 1604                 move.b     d4, d3
013c: 4883                 ext.w      d3
013e: 48c3                 ext.l      d3
0140: 97aefffc             sub.l      d3, -$4(a6)
0144: 2f03                 move.l     d3, -(a7)
0146: 2f03                 move.l     d3, -(a7)
0148: 4ead0042             jsr        $42(a5) ; CODE1+00ee
014c: 9c80                 sub.l      d0, d6
014e: 2f03                 move.l     d3, -(a7)
0150: 2f03                 move.l     d3, -(a7)
0152: 2f03                 move.l     d3, -(a7)
0154: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0158: 2f00                 move.l     d0, -(a7)
015a: 4ead0042             jsr        $42(a5) ; CODE1+00ee
015e: 2800                 move.l     d0, d4
0160: 9e84                 sub.l      d4, d7
0162: 2f04                 move.l     d4, -(a7)
0164: 2f03                 move.l     d3, -(a7)
0166: 4ead0042             jsr        $42(a5) ; CODE1+00ee
016a: 91aefff8             sub.l      d0, -$8(a6)
016e: 5285                 addq.l     #$1, d5
0170: 60bc                 bra.b      $12e
0172: 4aaefffc             tst.l      -$4(a6)
0176: 660e                 bne.b      $186
0178: 4a86                 tst.l      d6
017a: 660a                 bne.b      $186
017c: 4a87                 tst.l      d7
017e: 6606                 bne.b      $186
0180: 4aaefff8             tst.l      -$8(a6)
0184: 6704                 beq.b      $18a
0186: 7000                 moveq      #$0, d0
0188: 6002                 bra.b      $18c
018a: 7001                 moveq      #$1, d0
018c: 4cdf10f8             movem.l    (a7)+, d3-d7/a4
0190: 4e5e                 unlk       a6
0192: 4e75                 rts        
0194: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
0198: 486d0432             pea.l      $432(a5)
019c: 4eba027c             jsr        $41a(pc)
01a0: 7008                 moveq      #$8, d0
01a2: 2e80                 move.l     d0, (a7)
01a4: 486da74e             pea.l      -$58b2(a5)
01a8: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
01ac: 4ebaff14             jsr        $c2(pc)
01b0: 4a40                 tst.w      d0
01b2: 508f                 addq.l     #$8, a7
01b4: 6718                 beq.b      $1ce
01b6: 7e00                 moveq      #$0, d7
01b8: 600c                 bra.b      $1c6
01ba: 4267                 clr.w      -(a7)
01bc: 3f07                 move.w     d7, -(a7)
01be: 4ead0562             jsr        $562(a5) ; CODE21+0598
01c2: 588f                 addq.l     #$4, a7
01c4: 5247                 addq.w     #$1, d7
01c6: 0c470007             cmpi.w     #$7, d7
01ca: 6dee                 blt.b      $1ba
01cc: 6062                 bra.b      $230
01ce: 7e00                 moveq      #$0, d7
01d0: 49edde28             lea.l      -$21d8(a5), a4
01d4: 204d                 movea.l    a5, a0
01d6: d0c7                 adda.w     d7, a0
01d8: 1c28c366             move.b     -$3c9a(a0), d6
01dc: 47edc366             lea.l      -$3c9a(a5), a3
01e0: d6c7                 adda.w     d7, a3
01e2: 4a06                 tst.b      d6
01e4: 6724                 beq.b      $20a
01e6: 1006                 move.b     d6, d0
01e8: 4880                 ext.w      d0
01ea: b054                 cmp.w      (a4), d0
01ec: 6706                 beq.b      $1f4
01ee: 397c00010002         move.w     #$1, $2(a4)
01f4: 1013                 move.b     (a3), d0
01f6: 4880                 ext.w      d0
01f8: 3880                 move.w     d0, (a4)
01fa: 4267                 clr.w      -(a7)
01fc: 3f07                 move.w     d7, -(a7)
01fe: 4ead0562             jsr        $562(a5) ; CODE21+0598
0202: 588f                 addq.l     #$4, a7
0204: 5247                 addq.w     #$1, d7
0206: 588c                 addq.l     #$4, a4
0208: 60ca                 bra.b      $1d4
020a: 2007                 move.l     d7, d0
020c: 48c0                 ext.l      d0
020e: e588                 lsl.l      #$2, d0
0210: 49edde28             lea.l      -$21d8(a5), a4
0214: d08c                 add.l      a4, d0
0216: 2840                 movea.l    d0, a4
0218: 6010                 bra.b      $22a
021a: 4254                 clr.w      (a4)
021c: 4267                 clr.w      -(a7)
021e: 3f07                 move.w     d7, -(a7)
0220: 4ead0562             jsr        $562(a5) ; CODE21+0598
0224: 588f                 addq.l     #$4, a7
0226: 5247                 addq.w     #$1, d7
0228: 588c                 addq.l     #$4, a4
022a: 0c470007             cmpi.w     #$7, d7
022e: 6dea                 blt.b      $21a
0230: 4cdf18c0             movem.l    (a7)+, d6-d7/a3-a4
0234: 4e75                 rts        
0236: 4e56fffc             link.w     a6, #$fffc
023a: 4a6dd9ae             tst.w      -$2652(a5)
023e: 6626                 bne.b      $266
0240: 7011                 moveq      #$11, d0
0242: c1ee0008             muls.w     $8(a6), d0
0246: d08d                 add.l      a5, d0
0248: 306e000a             movea.w    $a(a6), a0
024c: d1c0                 adda.l     d0, a0
024e: 7011                 moveq      #$11, d0
0250: c1ee0008             muls.w     $8(a6), d0
0254: d08d                 add.l      a5, d0
0256: 326e000a             movea.w    $a(a6), a1
025a: d3c0                 adda.l     d0, a1
025c: 1028d88d             move.b     -$2773(a0), d0
0260: b029d76c             cmp.b      -$2894(a1), d0
0264: 660c                 bne.b      $272
0266: 3f2e000a             move.w     $a(a6), -(a7)
026a: 3f2e0008             move.w     $8(a6), -(a7)
026e: 4eba0006             jsr        $276(pc)
0272: 4e5e                 unlk       a6
0274: 4e75                 rts        
0276: 4e560000             link.w     a6, #$0
027a: 48e71f08             movem.l    d3-d7/a4, -(a7)
027e: 3c2e0008             move.w     $8(a6), d6
0282: 3a2e000a             move.w     $a(a6), d5
0286: 7011                 moveq      #$11, d0
0288: c1c6                 muls.w     d6, d0
028a: 41edd76c             lea.l      -$2894(a5), a0
028e: d088                 add.l      a0, d0
0290: 3045                 movea.w    d5, a0
0292: 1e300800             move.b     (a0, d0.l), d7
0296: 4887                 ext.w      d7
0298: 7011                 moveq      #$11, d0
029a: c1c6                 muls.w     d6, d0
029c: 49edd88d             lea.l      -$2773(a5), a4
02a0: d08c                 add.l      a4, d0
02a2: 3845                 movea.w    d5, a4
02a4: d08c                 add.l      a4, d0
02a6: 2840                 movea.l    d0, a4
02a8: 1014                 move.b     (a4), d0
02aa: 4880                 ext.w      d0
02ac: be40                 cmp.w      d0, d7
02ae: 670c                 beq.b      $2bc
02b0: 1887                 move.b     d7, (a4)
02b2: 3f05                 move.w     d5, -(a7)
02b4: 3f06                 move.w     d6, -(a7)
02b6: 4eba0390             jsr        $648(pc)
02ba: 588f                 addq.l     #$4, a7
02bc: 4a47                 tst.w      d7
02be: 6774                 beq.b      $334
02c0: 780f                 moveq      #$f, d4
02c2: d845                 add.w      d5, d4
02c4: 3606                 move.w     d6, d3
02c6: 7011                 moveq      #$11, d0
02c8: c1c6                 muls.w     d6, d0
02ca: 49edbcfe             lea.l      -$4302(a5), a4
02ce: d08c                 add.l      a4, d0
02d0: 3845                 movea.w    d5, a4
02d2: d08c                 add.l      a4, d0
02d4: 2840                 movea.l    d0, a4
02d6: 3f07                 move.w     d7, -(a7)
02d8: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
02dc: 1880                 move.b     d0, (a4)
02de: 7211                 moveq      #$11, d1
02e0: c3c4                 muls.w     d4, d1
02e2: 41edbcfe             lea.l      -$4302(a5), a0
02e6: d288                 add.l      a0, d1
02e8: 3043                 movea.w    d3, a0
02ea: 11801800             move.b     d0, (a0, d1.l)
02ee: 7000                 moveq      #$0, d0
02f0: 1007                 move.b     d7, d0
02f2: 204d                 movea.l    a5, a0
02f4: d1c0                 adda.l     d0, a0
02f6: 4a28fbd8             tst.b      -$428(a0)
02fa: 548f                 addq.l     #$2, a7
02fc: 6a04                 bpl.b      $302
02fe: 7000                 moveq      #$0, d0
0300: 600e                 bra.b      $310
0302: 1014                 move.b     (a4), d0
0304: 4880                 ext.w      d0
0306: 204d                 movea.l    a5, a0
0308: d0c0                 adda.w     d0, a0
030a: d0c0                 adda.w     d0, a0
030c: 30289412             move.w     -$6bee(a0), d0
0310: 7222                 moveq      #$22, d1
0312: c3c6                 muls.w     d6, d1
0314: 41edbf1e             lea.l      -$40e2(a5), a0
0318: d288                 add.l      a0, d1
031a: 3045                 movea.w    d5, a0
031c: d1c8                 adda.l     a0, a0
031e: 31801800             move.w     d0, (a0, d1.l)
0322: 7222                 moveq      #$22, d1
0324: c3c4                 muls.w     d4, d1
0326: 41edbf1e             lea.l      -$40e2(a5), a0
032a: d288                 add.l      a0, d1
032c: 3043                 movea.w    d3, a0
032e: d1c8                 adda.l     a0, a0
0330: 31801800             move.w     d0, (a0, d1.l)
0334: 4cdf10f8             movem.l    (a7)+, d3-d7/a4
0338: 4e5e                 unlk       a6
033a: 4e75                 rts        
033c: 4e560000             link.w     a6, #$0
0340: 48e70718             movem.l    d5-d7/a3-a4, -(a7)
0344: 3c2e0008             move.w     $8(a6), d6
0348: 3a2e000a             move.w     $a(a6), d5
034c: 7011                 moveq      #$11, d0
034e: c1c6                 muls.w     d6, d0
0350: 41edbcfe             lea.l      -$4302(a5), a0
0354: d088                 add.l      a0, d0
0356: 3045                 movea.w    d5, a0
0358: 1e300800             move.b     (a0, d0.l), d7
035c: 4887                 ext.w      d7
035e: 7022                 moveq      #$22, d0
0360: c1c6                 muls.w     d6, d0
0362: 41edbf1e             lea.l      -$40e2(a5), a0
0366: d088                 add.l      a0, d0
0368: 3045                 movea.w    d5, a0
036a: d1c8                 adda.l     a0, a0
036c: 4a700800             tst.w      (a0, d0.l)
0370: 670a                 beq.b      $37c
0372: 3f07                 move.w     d7, -(a7)
0374: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
0378: 548f                 addq.l     #$2, a7
037a: 6002                 bra.b      $37e
037c: 3007                 move.w     d7, d0
037e: 7211                 moveq      #$11, d1
0380: c3c6                 muls.w     d6, d1
0382: 49edd88d             lea.l      -$2773(a5), a4
0386: d28c                 add.l      a4, d1
0388: 3845                 movea.w    d5, a4
038a: d28c                 add.l      a4, d1
038c: 2841                 movea.l    d1, a4
038e: 1880                 move.b     d0, (a4)
0390: 7011                 moveq      #$11, d0
0392: c1c6                 muls.w     d6, d0
0394: 47edd76c             lea.l      -$2894(a5), a3
0398: d08b                 add.l      a3, d0
039a: 3645                 movea.w    d5, a3
039c: d08b                 add.l      a3, d0
039e: 2640                 movea.l    d0, a3
03a0: 1013                 move.b     (a3), d0
03a2: b014                 cmp.b      (a4), d0
03a4: 670c                 beq.b      $3b2
03a6: 1694                 move.b     (a4), (a3)
03a8: 3f05                 move.w     d5, -(a7)
03aa: 3f06                 move.w     d6, -(a7)
03ac: 4eba029a             jsr        $648(pc)
03b0: 588f                 addq.l     #$4, a7
03b2: 4cdf18e0             movem.l    (a7)+, d5-d7/a3-a4
03b6: 4e5e                 unlk       a6
03b8: 4e75                 rts        
03ba: 48780220             pea.l      $220.w
03be: 486dbcfe             pea.l      -$4302(a5)
03c2: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
03c6: 48780440             pea.l      $440.w
03ca: 486dbf1e             pea.l      -$40e2(a5)
03ce: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
03d2: 486d041a             pea.l      $41a(a5)
03d6: 4eba0042             jsr        $41a(pc)
03da: 4fef0014             lea.l      $14(a7), a7
03de: 4e75                 rts        
03e0: 4e56fffe             link.w     a6, #$fffe
03e4: 48780121             pea.l      $121.w
03e8: 486dd76c             pea.l      -$2894(a5)
03ec: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
03f0: 48780121             pea.l      $121.w
03f4: 486dd88d             pea.l      -$2773(a5)
03f8: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
03fc: 486d0402             pea.l      $402(a5)
0400: 4eba0018             jsr        $41a(pc)
0404: 4eba011a             jsr        $520(pc)
0408: 4ead053a             jsr        $53a(a5) ; CODE21+08fe
040c: 4e5e                 unlk       a6
040e: 4e75                 rts        
0410: 4eba010e             jsr        $520(pc)
0414: 4eba05ba             jsr        $9d0(pc)
0418: 4e75                 rts        
041a: 4e560000             link.w     a6, #$0
041e: 48e70300             movem.l    d6-d7, -(a7)
0422: 7e01                 moveq      #$1, d7
0424: 601a                 bra.b      $440
0426: 7c01                 moveq      #$1, d6
0428: 600e                 bra.b      $438
042a: 3f06                 move.w     d6, -(a7)
042c: 3f07                 move.w     d7, -(a7)
042e: 206e0008             movea.l    $8(a6), a0
0432: 4e90                 jsr        (a0)
0434: 588f                 addq.l     #$4, a7
0436: 5246                 addq.w     #$1, d6
0438: 0c460010             cmpi.w     #$10, d6
043c: 6dec                 blt.b      $42a
043e: 5247                 addq.w     #$1, d7
0440: 0c470010             cmpi.w     #$10, d7
0444: 6de0                 blt.b      $426
0446: 4cdf00c0             movem.l    (a7)+, d6-d7
044a: 4e5e                 unlk       a6
044c: 4e75                 rts        
044e: 4e56fff8             link.w     a6, #$fff8
0452: 48e71f08             movem.l    d3-d7/a4, -(a7)
0456: 7e00                 moveq      #$0, d7
0458: 7c00                 moveq      #$0, d6
045a: 42aefff8             clr.l      -$8(a6)
045e: 42aefffc             clr.l      -$4(a6)
0462: 7a00                 moveq      #$0, d5
0464: 49edde28             lea.l      -$21d8(a5), a4
0468: 3814                 move.w     (a4), d4
046a: 4a44                 tst.w      d4
046c: 6738                 beq.b      $4a6
046e: 2604                 move.l     d4, d3
0470: 48c3                 ext.l      d3
0472: d7aefffc             add.l      d3, -$4(a6)
0476: 2f03                 move.l     d3, -(a7)
0478: 2f03                 move.l     d3, -(a7)
047a: 4ead0042             jsr        $42(a5) ; CODE1+00ee
047e: dc80                 add.l      d0, d6
0480: 2f03                 move.l     d3, -(a7)
0482: 2f03                 move.l     d3, -(a7)
0484: 2f03                 move.l     d3, -(a7)
0486: 4ead0042             jsr        $42(a5) ; CODE1+00ee
048a: 2f00                 move.l     d0, -(a7)
048c: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0490: 2800                 move.l     d0, d4
0492: de84                 add.l      d4, d7
0494: 2f04                 move.l     d4, -(a7)
0496: 2f03                 move.l     d3, -(a7)
0498: 4ead0042             jsr        $42(a5) ; CODE1+00ee
049c: d1aefff8             add.l      d0, -$8(a6)
04a0: 5285                 addq.l     #$1, d5
04a2: 588c                 addq.l     #$4, a4
04a4: 60c2                 bra.b      $468
04a6: 486dc366             pea.l      -$3c9a(a5)
04aa: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
04ae: b085                 cmp.l      d5, d0
04b0: 588f                 addq.l     #$4, a7
04b2: 6704                 beq.b      $4b8
04b4: 7000                 moveq      #$0, d0
04b6: 6060                 bra.b      $518
04b8: 7a00                 moveq      #$0, d5
04ba: 204d                 movea.l    a5, a0
04bc: d1c5                 adda.l     d5, a0
04be: 1828c366             move.b     -$3c9a(a0), d4
04c2: 4a04                 tst.b      d4
04c4: 6738                 beq.b      $4fe
04c6: 1604                 move.b     d4, d3
04c8: 4883                 ext.w      d3
04ca: 48c3                 ext.l      d3
04cc: 97aefffc             sub.l      d3, -$4(a6)
04d0: 2f03                 move.l     d3, -(a7)
04d2: 2f03                 move.l     d3, -(a7)
04d4: 4ead0042             jsr        $42(a5) ; CODE1+00ee
04d8: 9c80                 sub.l      d0, d6
04da: 2f03                 move.l     d3, -(a7)
04dc: 2f03                 move.l     d3, -(a7)
04de: 2f03                 move.l     d3, -(a7)
04e0: 4ead0042             jsr        $42(a5) ; CODE1+00ee
04e4: 2f00                 move.l     d0, -(a7)
04e6: 4ead0042             jsr        $42(a5) ; CODE1+00ee
04ea: 2800                 move.l     d0, d4
04ec: 9e84                 sub.l      d4, d7
04ee: 2f04                 move.l     d4, -(a7)
04f0: 2f03                 move.l     d3, -(a7)
04f2: 4ead0042             jsr        $42(a5) ; CODE1+00ee
04f6: 91aefff8             sub.l      d0, -$8(a6)
04fa: 5285                 addq.l     #$1, d5
04fc: 60bc                 bra.b      $4ba
04fe: 4aaefffc             tst.l      -$4(a6)
0502: 660e                 bne.b      $512
0504: 4a86                 tst.l      d6
0506: 660a                 bne.b      $512
0508: 4a87                 tst.l      d7
050a: 6606                 bne.b      $512
050c: 4aaefff8             tst.l      -$8(a6)
0510: 6704                 beq.b      $516
0512: 7000                 moveq      #$0, d0
0514: 6002                 bra.b      $518
0516: 7001                 moveq      #$1, d0
0518: 4cdf10f8             movem.l    (a7)+, d3-d7/a4
051c: 4e5e                 unlk       a6
051e: 4e75                 rts        
0520: 4e56fff8             link.w     a6, #$fff8
0524: 2f2ddec2             move.l     -$213e(a5), -(a7)
0528: a873                 dc.w       $a873
052a: 486efff8             pea.l      -$8(a6)
052e: 4eba000c             jsr        $53c(pc)
0532: 486efff8             pea.l      -$8(a6)
0536: a928                 dc.w       $a928
0538: 4e5e                 unlk       a6
053a: 4e75                 rts        
053c: 4e560000             link.w     a6, #$0
0540: 48e70018             movem.l    a3-a4, -(a7)
0544: 286e0008             movea.l    $8(a6), a4
0548: 2f3c00010001         move.l     #$10001, -(a7)
054e: 2f0c                 move.l     a4, -(a7)
0550: 4eba00a2             jsr        $5f4(pc)
0554: 700a                 moveq      #$a, d0
0556: d0adde80             add.l      -$2180(a5), d0
055a: 2640                 movea.l    d0, a3
055c: 700f                 moveq      #$f, d0
055e: c1d3                 muls.w     (a3), d0
0560: d06c0002             add.w      $2(a4), d0
0564: 39400006             move.w     d0, $6(a4)
0568: 700f                 moveq      #$f, d0
056a: c1d3                 muls.w     (a3), d0
056c: d054                 add.w      (a4), d0
056e: 39400004             move.w     d0, $4(a4)
0572: 2e8c                 move.l     a4, (a7)
0574: 2f3cfffefffe         move.l     #$fffefffe, -(a7)
057a: a8a9                 dc.w       $a8a9
057c: 4cee1800fff8         movem.l    -$8(a6), a3-a4
0582: 4e5e                 unlk       a6
0584: 4e75                 rts        
0586: 4e560000             link.w     a6, #$0
058a: 48e70018             movem.l    a3-a4, -(a7)
058e: 266e0008             movea.l    $8(a6), a3
0592: 7010                 moveq      #$10, d0
0594: d0adde80             add.l      -$2180(a5), d0
0598: 2840                 movea.l    d0, a4
059a: 3013                 move.w     (a3), d0
059c: b054                 cmp.w      (a4), d0
059e: 6d0e                 blt.b      $5ae
05a0: 206dde80             movea.l    -$2180(a5), a0
05a4: 302b0002             move.w     $2(a3), d0
05a8: b068000e             cmp.w      $e(a0), d0
05ac: 6c0e                 bge.b      $5bc
05ae: 206e0010             movea.l    $10(a6), a0
05b2: 4250                 clr.w      (a0)
05b4: 226e000c             movea.l    $c(a6), a1
05b8: 4251                 clr.w      (a1)
05ba: 6030                 bra.b      $5ec
05bc: 206dde80             movea.l    -$2180(a5), a0
05c0: 3013                 move.w     (a3), d0
05c2: 9054                 sub.w      (a4), d0
05c4: 48c0                 ext.l      d0
05c6: 81e8000a             divs.w     $a(a0), d0
05ca: 5240                 addq.w     #$1, d0
05cc: 226e000c             movea.l    $c(a6), a1
05d0: 3280                 move.w     d0, (a1)
05d2: 206dde80             movea.l    -$2180(a5), a0
05d6: 302b0002             move.w     $2(a3), d0
05da: 9068000e             sub.w      $e(a0), d0
05de: 48c0                 ext.l      d0
05e0: 81e8000a             divs.w     $a(a0), d0
05e4: 5240                 addq.w     #$1, d0
05e6: 206e0010             movea.l    $10(a6), a0
05ea: 3080                 move.w     d0, (a0)
05ec: 4cdf1800             movem.l    (a7)+, a3-a4
05f0: 4e5e                 unlk       a6
05f2: 4e75                 rts        
05f4: 4e560000             link.w     a6, #$0
05f8: 2f2e0008             move.l     $8(a6), -(a7)
05fc: 206dde80             movea.l    -$2180(a5), a0
0600: 70ff                 moveq      #$ff, d0
0602: d06e000e             add.w      $e(a6), d0
0606: c1e8000a             muls.w     $a(a0), d0
060a: 5340                 subq.w     #$1, d0
060c: 3f00                 move.w     d0, -(a7)
060e: 70ff                 moveq      #$ff, d0
0610: d06e000c             add.w      $c(a6), d0
0614: c1e8000a             muls.w     $a(a0), d0
0618: 5340                 subq.w     #$1, d0
061a: 3f00                 move.w     d0, -(a7)
061c: 3028000a             move.w     $a(a0), d0
0620: c1ee000e             muls.w     $e(a6), d0
0624: 3f00                 move.w     d0, -(a7)
0626: 3028000a             move.w     $a(a0), d0
062a: c1ee000c             muls.w     $c(a6), d0
062e: 3f00                 move.w     d0, -(a7)
0630: a8a7                 dc.w       $a8a7
0632: 2f2e0008             move.l     $8(a6), -(a7)
0636: 206dde80             movea.l    -$2180(a5), a0
063a: 3f28000e             move.w     $e(a0), -(a7)
063e: 3f280010             move.w     $10(a0), -(a7)
0642: a8a8                 dc.w       $a8a8
0644: 4e5e                 unlk       a6
0646: 4e75                 rts        
0648: 4e560000             link.w     a6, #$0
064c: 2f2ddec2             move.l     -$213e(a5), -(a7)
0650: a873                 dc.w       $a873
0652: 3f2e000a             move.w     $a(a6), -(a7)
0656: 3f2e0008             move.w     $8(a6), -(a7)
065a: 4eba01f4             jsr        $850(pc)
065e: 4e5e                 unlk       a6
0660: 4e75                 rts        
0662: 4e560000             link.w     a6, #$0
0666: 48e70308             movem.l    d6-d7/a4, -(a7)
066a: 3e2e0008             move.w     $8(a6), d7
066e: 286e000a             movea.l    $a(a6), a4
0672: 4a2df269             tst.b      -$d97(a5)
0676: 6712                 beq.b      $68a
0678: 3f3c0002             move.w     #$2, -(a7)
067c: aa98                 dc.w       $aa98
067e: 2f0c                 move.l     a4, -(a7)
0680: a8a3                 dc.w       $a8a3
0682: 4878001e             pea.l      $1e.w
0686: a863                 dc.w       $a863
0688: 6004                 bra.b      $68e
068a: 2f0c                 move.l     a4, -(a7)
068c: a8a3                 dc.w       $a8a3
068e: 3f07                 move.w     d7, -(a7)
0690: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
0694: 204d                 movea.l    a5, a0
0696: d0c0                 adda.w     d0, a0
0698: d0c0                 adda.w     d0, a0
069a: 3c289412             move.w     -$6bee(a0), d6
069e: 7000                 moveq      #$0, d0
06a0: 1007                 move.b     d7, d0
06a2: 204d                 movea.l    a5, a0
06a4: d1c0                 adda.l     d0, a0
06a6: 4a28fbd8             tst.b      -$428(a0)
06aa: 548f                 addq.l     #$2, a7
06ac: 6a06                 bpl.b      $6b4
06ae: 2f0c                 move.l     a4, -(a7)
06b0: a8a1                 dc.w       $a8a1
06b2: 7c00                 moveq      #$0, d6
06b4: 3f2e0012             move.w     $12(a6), -(a7)
06b8: a888                 dc.w       $a888
06ba: 3f07                 move.w     d7, -(a7)
06bc: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
06c0: 3e00                 move.w     d0, d7
06c2: 4257                 clr.w      (a7)
06c4: 3f07                 move.w     d7, -(a7)
06c6: a88d                 dc.w       $a88d
06c8: 302c0002             move.w     $2(a4), d0
06cc: d06c0006             add.w      $6(a4), d0
06d0: 905f                 sub.w      (a7)+, d0
06d2: 48c0                 ext.l      d0
06d4: 81fc0002             divs.w     #$2, d0
06d8: 3f00                 move.w     d0, -(a7)
06da: 302c0004             move.w     $4(a4), d0
06de: d054                 add.w      (a4), d0
06e0: 206e000e             movea.l    $e(a6), a0
06e4: 3050                 movea.w    (a0), a0
06e6: d0c0                 adda.w     d0, a0
06e8: 2008                 move.l     a0, d0
06ea: 81fc0002             divs.w     #$2, d0
06ee: 3f00                 move.w     d0, -(a7)
06f0: a893                 dc.w       $a893
06f2: 3f3c0001             move.w     #$1, -(a7)
06f6: a889                 dc.w       $a889
06f8: 3f07                 move.w     d7, -(a7)
06fa: a883                 dc.w       $a883
06fc: 4a6e0012             tst.w      $12(a6)
0700: 660a                 bne.b      $70c
0702: 3f06                 move.w     d6, -(a7)
0704: 2f0c                 move.l     a4, -(a7)
0706: 4eba0496             jsr        $b9e(pc)
070a: 5c8f                 addq.l     #$6, a7
070c: 4cdf10c0             movem.l    (a7)+, d6-d7/a4
0710: 4e5e                 unlk       a6
0712: 4e75                 rts        
0714: 4e560000             link.w     a6, #$0
0718: 48e70118             movem.l    d7/a3-a4, -(a7)
071c: 266e000c             movea.l    $c(a6), a3
0720: 7011                 moveq      #$11, d0
0722: c1ee0008             muls.w     $8(a6), d0
0726: 2840                 movea.l    d0, a4
0728: 41ed97b2             lea.l      -$684e(a5), a0
072c: d1cc                 adda.l     a4, a0
072e: d0ee000a             adda.w     $a(a6), a0
0732: 1e10                 move.b     (a0), d7
0734: 0c070003             cmpi.b     #$3, d7
0738: 661e                 bne.b      $758
073a: 487800cd             pea.l      $cd.w
073e: a862                 dc.w       $a862
0740: 2f0b                 move.l     a3, -(a7)
0742: 486dfaba             pea.l      -$546(a5)
0746: a8a5                 dc.w       $a8a5
0748: 486deea6             pea.l      -$115a(a5)
074c: 2f0b                 move.l     a3, -(a7)
074e: 4eba04f2             jsr        $c42(pc)
0752: 508f                 addq.l     #$8, a7
0754: 60000090             bra.w      $7e6
0758: 0c070002             cmpi.b     #$2, d7
075c: 661c                 bne.b      $77a
075e: 487800cd             pea.l      $cd.w
0762: a862                 dc.w       $a862
0764: 2f0b                 move.l     a3, -(a7)
0766: 486dfab2             pea.l      -$54e(a5)
076a: a8a5                 dc.w       $a8a5
076c: 486deeaa             pea.l      -$1156(a5)
0770: 2f0b                 move.l     a3, -(a7)
0772: 4eba04ce             jsr        $c42(pc)
0776: 508f                 addq.l     #$8, a7
0778: 606c                 bra.b      $7e6
077a: 41ed9592             lea.l      -$6a6e(a5), a0
077e: d1cc                 adda.l     a4, a0
0780: d0ee000a             adda.w     $a(a6), a0
0784: 1e10                 move.b     (a0), d7
0786: 0c070003             cmpi.b     #$3, d7
078a: 661c                 bne.b      $7a8
078c: 48780199             pea.l      $199.w
0790: a862                 dc.w       $a862
0792: 2f0b                 move.l     a3, -(a7)
0794: 486dfaa2             pea.l      -$55e(a5)
0798: a8a5                 dc.w       $a8a5
079a: 486deeae             pea.l      -$1152(a5)
079e: 2f0b                 move.l     a3, -(a7)
07a0: 4eba04a0             jsr        $c42(pc)
07a4: 508f                 addq.l     #$8, a7
07a6: 603e                 bra.b      $7e6
07a8: 0c070002             cmpi.b     #$2, d7
07ac: 661c                 bne.b      $7ca
07ae: 48780199             pea.l      $199.w
07b2: a862                 dc.w       $a862
07b4: 2f0b                 move.l     a3, -(a7)
07b6: 486dfaaa             pea.l      -$556(a5)
07ba: a8a5                 dc.w       $a8a5
07bc: 486deeb2             pea.l      -$114e(a5)
07c0: 2f0b                 move.l     a3, -(a7)
07c2: 4eba047e             jsr        $c42(pc)
07c6: 508f                 addq.l     #$8, a7
07c8: 601c                 bra.b      $7e6
07ca: 4a2df269             tst.b      -$d97(a5)
07ce: 6712                 beq.b      $7e2
07d0: 3f3c0002             move.w     #$2, -(a7)
07d4: aa98                 dc.w       $aa98
07d6: 2f0b                 move.l     a3, -(a7)
07d8: a8a3                 dc.w       $a8a3
07da: 4878001e             pea.l      $1e.w
07de: a863                 dc.w       $a863
07e0: 6004                 bra.b      $7e6
07e2: 2f0b                 move.l     a3, -(a7)
07e4: a8a3                 dc.w       $a8a3
07e6: 4cdf1880             movem.l    (a7)+, d7/a3-a4
07ea: 4e5e                 unlk       a6
07ec: 4e75                 rts        
07ee: 2f07                 move.l     d7, -(a7)
07f0: 206dde80             movea.l    -$2180(a5), a0
07f4: 3028000a             move.w     $a(a0), d0
07f8: 0440000c             subi.w     #$c, d0
07fc: 0c400010             cmpi.w     #$10, d0
0800: 6220                 bhi.b      $822
0802: 43fa002a             lea.l      $82e(pc), a1
0806: d040                 add.w      d0, d0
0808: d2f10000             adda.w     (a1, d0.w), a1
080c: 4ed1                 jmp        (a1)
080e: 7e18                 moveq      #$18, d7
0810: 6014                 bra.b      $826
0812: 7e0e                 moveq      #$e, d7
0814: 6010                 bra.b      $826
0816: 7e0d                 moveq      #$d, d7
0818: 600c                 bra.b      $826
081a: 7e0c                 moveq      #$c, d7
081c: 6008                 bra.b      $826
081e: 7e0a                 moveq      #$a, d7
0820: 6004                 bra.b      $826
0822: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0826: 3f07                 move.w     d7, -(a7)
0828: a88a                 dc.w       $a88a
082a: 2e1f                 move.l     (a7)+, d7
082c: 4e75                 rts        
082e: fff0                 dc.w       $fff0
0830: fff4                 dc.w       $fff4
0832: ffec                 dc.w       $ffec
0834: ffe8                 dc.w       $ffe8
0836: fff4                 dc.w       $fff4
0838: fff4                 dc.w       $fff4
083a: ffe4                 dc.w       $ffe4
083c: fff4                 dc.w       $fff4
083e: ffe4                 dc.w       $ffe4
0840: fff4                 dc.w       $fff4
0842: fff4                 dc.w       $fff4
0844: fff4                 dc.w       $fff4
0846: fff4                 dc.w       $fff4
0848: fff4                 dc.w       $fff4
084a: ffe0                 dc.w       $ffe0
084c: fff4                 dc.w       $fff4
084e: ffe0                 dc.w       $ffe0
0850: 4e56fff0             link.w     a6, #$fff0
0854: 48e70718             movem.l    d5-d7/a3-a4, -(a7)
0858: 3e2e0008             move.w     $8(a6), d7
085c: 3c2e000a             move.w     $a(a6), d6
0860: 4a47                 tst.w      d7
0862: 670000be             beq.w      $922
0866: 4a46                 tst.w      d6
0868: 670000b8             beq.w      $922
086c: 3f3c0003             move.w     #$3, -(a7)
0870: a887                 dc.w       $a887
0872: 4ebaff7a             jsr        $7ee(pc)
0876: 3f06                 move.w     d6, -(a7)
0878: 3f07                 move.w     d7, -(a7)
087a: 486efff8             pea.l      -$8(a6)
087e: 4ebafd74             jsr        $5f4(pc)
0882: 486efff8             pea.l      -$8(a6)
0886: a8a1                 dc.w       $a8a1
0888: 486efff8             pea.l      -$8(a6)
088c: 2f3c00010001         move.l     #$10001, -(a7)
0892: a8a9                 dc.w       $a8a9
0894: 7011                 moveq      #$11, d0
0896: c1c7                 muls.w     d7, d0
0898: 49edd76c             lea.l      -$2894(a5), a4
089c: d08c                 add.l      a4, d0
089e: 3846                 movea.w    d6, a4
08a0: d08c                 add.l      a4, d0
08a2: 2840                 movea.l    d0, a4
08a4: 7011                 moveq      #$11, d0
08a6: c1c7                 muls.w     d7, d0
08a8: 2640                 movea.l    d0, a3
08aa: 1a14                 move.b     (a4), d5
08ac: 4885                 ext.w      d5
08ae: 4a45                 tst.w      d5
08b0: 508f                 addq.l     #$8, a7
08b2: 6730                 beq.b      $8e4
08b4: 486efff0             pea.l      -$10(a6)
08b8: a88b                 dc.w       $a88b
08ba: 41edd88d             lea.l      -$2773(a5), a0
08be: d1cb                 adda.l     a3, a0
08c0: 1014                 move.b     (a4), d0
08c2: b0306000             cmp.b      (a0, d6.w), d0
08c6: 6704                 beq.b      $8cc
08c8: 7008                 moveq      #$8, d0
08ca: 6002                 bra.b      $8ce
08cc: 7001                 moveq      #$1, d0
08ce: 3f00                 move.w     d0, -(a7)
08d0: 486efff0             pea.l      -$10(a6)
08d4: 486efff8             pea.l      -$8(a6)
08d8: 3f05                 move.w     d5, -(a7)
08da: 4ebafd86             jsr        $662(pc)
08de: 4fef000c             lea.l      $c(a7), a7
08e2: 600e                 bra.b      $8f2
08e4: 486efff8             pea.l      -$8(a6)
08e8: 3f06                 move.w     d6, -(a7)
08ea: 3f07                 move.w     d7, -(a7)
08ec: 4ebafe26             jsr        $714(pc)
08f0: 508f                 addq.l     #$8, a7
08f2: be6dde50             cmp.w      -$21b0(a5), d7
08f6: 6610                 bne.b      $908
08f8: bc6dde52             cmp.w      -$21ae(a5), d6
08fc: 660a                 bne.b      $908
08fe: 486efff8             pea.l      -$8(a6)
0902: 4eba0026             jsr        $92a(pc)
0906: 588f                 addq.l     #$4, a7
0908: 48780021             pea.l      $21.w
090c: a862                 dc.w       $a862
090e: 486efff8             pea.l      -$8(a6)
0912: 4878ffff             pea.l      $ffff.w
0916: a8a9                 dc.w       $a8a9
0918: 486efff8             pea.l      -$8(a6)
091c: a92a                 dc.w       $a92a
091e: 4267                 clr.w      -(a7)
0920: a888                 dc.w       $a888
0922: 4cdf18e0             movem.l    (a7)+, d5-d7/a3-a4
0926: 4e5e                 unlk       a6
0928: 4e75                 rts        
092a: 4e56fff8             link.w     a6, #$fff8
092e: 206e0008             movea.l    $8(a6), a0
0932: 2d50fff8             move.l     (a0), -$8(a6)
0936: 2d680004fffc         move.l     $4(a0), -$4(a6)
093c: 48780021             pea.l      $21.w
0940: a862                 dc.w       $a862
0942: 4a6dde4e             tst.w      -$21b2(a5)
0946: 6744                 beq.b      $98c
0948: 7003                 moveq      #$3, d0
094a: d06efff8             add.w      -$8(a6), d0
094e: 3d40fffc             move.w     d0, -$4(a6)
0952: 576efffe             subq.w     #$3, -$2(a6)
0956: 486efff8             pea.l      -$8(a6)
095a: a8a3                 dc.w       $a8a3
095c: 526efff8             addq.w     #$1, -$8(a6)
0960: 7001                 moveq      #$1, d0
0962: d06efffa             add.w      -$6(a6), d0
0966: 3f00                 move.w     d0, -(a7)
0968: 3f2efff8             move.w     -$8(a6), -(a7)
096c: a893                 dc.w       $a893
096e: 70fe                 moveq      #$fe, d0
0970: d06efffe             add.w      -$2(a6), d0
0974: 3f00                 move.w     d0, -(a7)
0976: 3f2efff8             move.w     -$8(a6), -(a7)
097a: a891                 dc.w       $a891
097c: 4878ffff             pea.l      $ffff.w
0980: a894                 dc.w       $a894
0982: 2f3c00020000         move.l     #$20000, -(a7)
0988: a892                 dc.w       $a892
098a: 6040                 bra.b      $9cc
098c: 576efffc             subq.w     #$3, -$4(a6)
0990: 7003                 moveq      #$3, d0
0992: d06efffa             add.w      -$6(a6), d0
0996: 3d40fffe             move.w     d0, -$2(a6)
099a: 486efff8             pea.l      -$8(a6)
099e: a8a3                 dc.w       $a8a3
09a0: 526efffa             addq.w     #$1, -$6(a6)
09a4: 3f2efffa             move.w     -$6(a6), -(a7)
09a8: 7001                 moveq      #$1, d0
09aa: d06efff8             add.w      -$8(a6), d0
09ae: 3f00                 move.w     d0, -(a7)
09b0: a893                 dc.w       $a893
09b2: 3f2efffa             move.w     -$6(a6), -(a7)
09b6: 70fe                 moveq      #$fe, d0
09b8: d06efffc             add.w      -$4(a6), d0
09bc: 3f00                 move.w     d0, -(a7)
09be: a891                 dc.w       $a891
09c0: 4878ffff             pea.l      $ffff.w
09c4: a894                 dc.w       $a894
09c6: 48780002             pea.l      $2.w
09ca: a892                 dc.w       $a892
09cc: 4e5e                 unlk       a6
09ce: 4e75                 rts        
09d0: 4e56ffec             link.w     a6, #$ffec
09d4: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
09d8: 486efff8             pea.l      -$8(a6)
09dc: 4ebafb5e             jsr        $53c(pc)
09e0: 4217                 clr.b      (a7)
09e2: 486efff8             pea.l      -$8(a6)
09e6: 206ddec2             movea.l    -$213e(a5), a0
09ea: 2f280018             move.l     $18(a0), -(a7)
09ee: a8e9                 dc.w       $a8e9
09f0: 4a1f                 tst.b      (a7)+
09f2: 548f                 addq.l     #$2, a7
09f4: 6700019e             beq.w      $b94
09f8: 3f3c0003             move.w     #$3, -(a7)
09fc: a887                 dc.w       $a887
09fe: 4ebafdee             jsr        $7ee(pc)
0a02: 486effec             pea.l      -$14(a6)
0a06: a88b                 dc.w       $a88b
0a08: 7c01                 moveq      #$1, d6
0a0a: 49edd89e             lea.l      -$2762(a5), a4
0a0e: 47edd77d             lea.l      -$2883(a5), a3
0a12: 600000f2             bra.w      $b06
0a16: 48780021             pea.l      $21.w
0a1a: a862                 dc.w       $a862
0a1c: 7aff                 moveq      #$ff, d5
0a1e: da46                 add.w      d6, d5
0a20: 206dde80             movea.l    -$2180(a5), a0
0a24: 70ff                 moveq      #$ff, d0
0a26: d068000e             add.w      $e(a0), d0
0a2a: 3f00                 move.w     d0, -(a7)
0a2c: 3028000a             move.w     $a(a0), d0
0a30: c1c5                 muls.w     d5, d0
0a32: d0680010             add.w      $10(a0), d0
0a36: 5340                 subq.w     #$1, d0
0a38: 3f00                 move.w     d0, -(a7)
0a3a: a893                 dc.w       $a893
0a3c: 206dde80             movea.l    -$2180(a5), a0
0a40: 700f                 moveq      #$f, d0
0a42: c1e8000a             muls.w     $a(a0), d0
0a46: 3f00                 move.w     d0, -(a7)
0a48: 4267                 clr.w      -(a7)
0a4a: a892                 dc.w       $a892
0a4c: 206dde80             movea.l    -$2180(a5), a0
0a50: 3028000a             move.w     $a(a0), d0
0a54: c1c5                 muls.w     d5, d0
0a56: d068000e             add.w      $e(a0), d0
0a5a: 5340                 subq.w     #$1, d0
0a5c: 3f00                 move.w     d0, -(a7)
0a5e: 3f280010             move.w     $10(a0), -(a7)
0a62: a893                 dc.w       $a893
0a64: 4267                 clr.w      -(a7)
0a66: 206dde80             movea.l    -$2180(a5), a0
0a6a: 700f                 moveq      #$f, d0
0a6c: c1e8000a             muls.w     $a(a0), d0
0a70: 5340                 subq.w     #$1, d0
0a72: 3f00                 move.w     d0, -(a7)
0a74: a892                 dc.w       $a892
0a76: 3f3c0001             move.w     #$1, -(a7)
0a7a: 3f06                 move.w     d6, -(a7)
0a7c: 486efff8             pea.l      -$8(a6)
0a80: 4ebafb72             jsr        $5f4(pc)
0a84: 486efff8             pea.l      -$8(a6)
0a88: 2f3c00010001         move.l     #$10001, -(a7)
0a8e: a8a9                 dc.w       $a8a9
0a90: 7a01                 moveq      #$1, d5
0a92: 244b                 movea.l    a3, a2
0a94: 2e0c                 move.l     a4, d7
0a96: 508f                 addq.l     #$8, a7
0a98: 605c                 bra.b      $af6
0a9a: 48780021             pea.l      $21.w
0a9e: a862                 dc.w       $a862
0aa0: 18325000             move.b     (a2, d5.w), d4
0aa4: 4884                 ext.w      d4
0aa6: 4a44                 tst.w      d4
0aa8: 6728                 beq.b      $ad2
0aaa: 3045                 movea.w    d5, a0
0aac: 10325000             move.b     (a2, d5.w), d0
0ab0: b0307800             cmp.b      (a0, d7.l), d0
0ab4: 6704                 beq.b      $aba
0ab6: 7008                 moveq      #$8, d0
0ab8: 6002                 bra.b      $abc
0aba: 7001                 moveq      #$1, d0
0abc: 3f00                 move.w     d0, -(a7)
0abe: 486effec             pea.l      -$14(a6)
0ac2: 486efff8             pea.l      -$8(a6)
0ac6: 3f04                 move.w     d4, -(a7)
0ac8: 4ebafb98             jsr        $662(pc)
0acc: 4fef000c             lea.l      $c(a7), a7
0ad0: 600e                 bra.b      $ae0
0ad2: 486efff8             pea.l      -$8(a6)
0ad6: 3f05                 move.w     d5, -(a7)
0ad8: 3f06                 move.w     d6, -(a7)
0ada: 4ebafc38             jsr        $714(pc)
0ade: 508f                 addq.l     #$8, a7
0ae0: 5245                 addq.w     #$1, d5
0ae2: 206dde80             movea.l    -$2180(a5), a0
0ae6: 3028000a             move.w     $a(a0), d0
0aea: d16efffa             add.w      d0, -$6(a6)
0aee: 3028000a             move.w     $a(a0), d0
0af2: d16efffe             add.w      d0, -$2(a6)
0af6: 0c450010             cmpi.w     #$10, d5
0afa: 6d9e                 blt.b      $a9a
0afc: 5246                 addq.w     #$1, d6
0afe: 49ec0011             lea.l      $11(a4), a4
0b02: 47eb0011             lea.l      $11(a3), a3
0b06: 0c460010             cmpi.w     #$10, d6
0b0a: 6d00ff0a             blt.w      $a16
0b0e: 48780021             pea.l      $21.w
0b12: a862                 dc.w       $a862
0b14: 7aff                 moveq      #$ff, d5
0b16: da46                 add.w      d6, d5
0b18: 206dde80             movea.l    -$2180(a5), a0
0b1c: 3f28000e             move.w     $e(a0), -(a7)
0b20: 3028000a             move.w     $a(a0), d0
0b24: c1c5                 muls.w     d5, d0
0b26: d0680010             add.w      $10(a0), d0
0b2a: 5340                 subq.w     #$1, d0
0b2c: 3f00                 move.w     d0, -(a7)
0b2e: a893                 dc.w       $a893
0b30: 206dde80             movea.l    -$2180(a5), a0
0b34: 700f                 moveq      #$f, d0
0b36: c1e8000a             muls.w     $a(a0), d0
0b3a: 5340                 subq.w     #$1, d0
0b3c: 3f00                 move.w     d0, -(a7)
0b3e: 4267                 clr.w      -(a7)
0b40: a892                 dc.w       $a892
0b42: 206dde80             movea.l    -$2180(a5), a0
0b46: 3028000a             move.w     $a(a0), d0
0b4a: c1c5                 muls.w     d5, d0
0b4c: d068000e             add.w      $e(a0), d0
0b50: 5340                 subq.w     #$1, d0
0b52: 3f00                 move.w     d0, -(a7)
0b54: 3f280010             move.w     $10(a0), -(a7)
0b58: a893                 dc.w       $a893
0b5a: 4267                 clr.w      -(a7)
0b5c: 206dde80             movea.l    -$2180(a5), a0
0b60: 700f                 moveq      #$f, d0
0b62: c1e8000a             muls.w     $a(a0), d0
0b66: 5340                 subq.w     #$1, d0
0b68: 3f00                 move.w     d0, -(a7)
0b6a: a892                 dc.w       $a892
0b6c: 3f2dde52             move.w     -$21ae(a5), -(a7)
0b70: 3f2dde50             move.w     -$21b0(a5), -(a7)
0b74: 486efff8             pea.l      -$8(a6)
0b78: 4ebafa7a             jsr        $5f4(pc)
0b7c: 486efff8             pea.l      -$8(a6)
0b80: 2f3c00010001         move.l     #$10001, -(a7)
0b86: a8a9                 dc.w       $a8a9
0b88: 486efff8             pea.l      -$8(a6)
0b8c: 4ebafd9c             jsr        $92a(pc)
0b90: 4257                 clr.w      (a7)
0b92: a888                 dc.w       $a888
0b94: 4cee1cf0ffd0         movem.l    -$30(a6), d4-d7/a2-a4
0b9a: 4e5e                 unlk       a6
0b9c: 4e75                 rts        
0b9e: 4e560000             link.w     a6, #$0
0ba2: 48e70108             movem.l    d7/a4, -(a7)
0ba6: 286e0008             movea.l    $8(a6), a4
0baa: 3e2e000c             move.w     $c(a6), d7
0bae: 206dde78             movea.l    -$2188(a5), a0
0bb2: 2050                 movea.l    (a0), a0
0bb4: 4a680308             tst.w      $308(a0)
0bb8: 67000080             beq.w      $c3a
0bbc: 4a47                 tst.w      d7
0bbe: 677a                 beq.b      $c3a
0bc0: 3f3c000c             move.w     #$c, -(a7)
0bc4: a88a                 dc.w       $a88a
0bc6: 3f2ddec0             move.w     -$2140(a5), -(a7)
0bca: a887                 dc.w       $a887
0bcc: 0c4703e8             cmpi.w     #$3e8, d7
0bd0: 673c                 beq.b      $c0e
0bd2: 4267                 clr.w      -(a7)
0bd4: 7030                 moveq      #$30, d0
0bd6: d047                 add.w      d7, d0
0bd8: 3f00                 move.w     d0, -(a7)
0bda: a88d                 dc.w       $a88d
0bdc: 302c0006             move.w     $6(a4), d0
0be0: 905f                 sub.w      (a7)+, d0
0be2: 5340                 subq.w     #$1, d0
0be4: 3f00                 move.w     d0, -(a7)
0be6: 70ff                 moveq      #$ff, d0
0be8: d06c0004             add.w      $4(a4), d0
0bec: 3f00                 move.w     d0, -(a7)
0bee: a893                 dc.w       $a893
0bf0: 0c470064             cmpi.w     #$64, d7
0bf4: 6606                 bne.b      $bfc
0bf6: 48780001             pea.l      $1.w
0bfa: a894                 dc.w       $a894
0bfc: 2007                 move.l     d7, d0
0bfe: 48c0                 ext.l      d0
0c00: 81fc0064             divs.w     #$64, d0
0c04: 06400030             addi.w     #$30, d0
0c08: 3f00                 move.w     d0, -(a7)
0c0a: a883                 dc.w       $a883
0c0c: 6022                 bra.b      $c30
0c0e: 4267                 clr.w      -(a7)
0c10: 486deeb6             pea.l      -$114a(a5)
0c14: a88c                 dc.w       $a88c
0c16: 302c0006             move.w     $6(a4), d0
0c1a: 905f                 sub.w      (a7)+, d0
0c1c: 5340                 subq.w     #$1, d0
0c1e: 3f00                 move.w     d0, -(a7)
0c20: 70ff                 moveq      #$ff, d0
0c22: d06c0004             add.w      $4(a4), d0
0c26: 3f00                 move.w     d0, -(a7)
0c28: a893                 dc.w       $a893
0c2a: 486deeba             pea.l      -$1146(a5)
0c2e: a884                 dc.w       $a884
0c30: 4ebafbbc             jsr        $7ee(pc)
0c34: 3f3c0003             move.w     #$3, -(a7)
0c38: a887                 dc.w       $a887
0c3a: 4cdf1080             movem.l    (a7)+, d7/a4
0c3e: 4e5e                 unlk       a6
0c40: 4e75                 rts        
0c42: 4e56fff8             link.w     a6, #$fff8
0c46: 48e70018             movem.l    a3-a4, -(a7)
0c4a: 286e0008             movea.l    $8(a6), a4
0c4e: 266e000c             movea.l    $c(a6), a3
0c52: 206dde78             movea.l    -$2188(a5), a0
0c56: 2050                 movea.l    (a0), a0
0c58: 4a680306             tst.w      $306(a0)
0c5c: 67000094             beq.w      $cf2
0c60: 48780021             pea.l      $21.w
0c64: a862                 dc.w       $a862
0c66: 3f3c000c             move.w     #$c, -(a7)
0c6a: a88a                 dc.w       $a88a
0c6c: 3f2ddec0             move.w     -$2140(a5), -(a7)
0c70: a887                 dc.w       $a887
0c72: 4267                 clr.w      -(a7)
0c74: a888                 dc.w       $a888
0c76: 3014                 move.w     (a4), d0
0c78: d06c0004             add.w      $4(a4), d0
0c7c: 48c0                 ext.l      d0
0c7e: 81fc0002             divs.w     #$2, d0
0c82: 5940                 subq.w     #$4, d0
0c84: 3d40fff8             move.w     d0, -$8(a6)
0c88: 7007                 moveq      #$7, d0
0c8a: d06efff8             add.w      -$8(a6), d0
0c8e: 3d40fffc             move.w     d0, -$4(a6)
0c92: 4267                 clr.w      -(a7)
0c94: 2f0b                 move.l     a3, -(a7)
0c96: a88c                 dc.w       $a88c
0c98: 302c0002             move.w     $2(a4), d0
0c9c: d06c0006             add.w      $6(a4), d0
0ca0: 905f                 sub.w      (a7)+, d0
0ca2: 48c0                 ext.l      d0
0ca4: 81fc0002             divs.w     #$2, d0
0ca8: 3d40fffa             move.w     d0, -$6(a6)
0cac: 4267                 clr.w      -(a7)
0cae: 2f0b                 move.l     a3, -(a7)
0cb0: a88c                 dc.w       $a88c
0cb2: 302efffa             move.w     -$6(a6), d0
0cb6: d05f                 add.w      (a7)+, d0
0cb8: 3d40fffe             move.w     d0, -$2(a6)
0cbc: 486deebe             pea.l      -$1142(a5)
0cc0: 2f0b                 move.l     a3, -(a7)
0cc2: 4ead0db2             jsr        $db2(a5) ; CODE52+0242
0cc6: 4a40                 tst.w      d0
0cc8: 508f                 addq.l     #$8, a7
0cca: 6704                 beq.b      $cd0
0ccc: 526efffe             addq.w     #$1, -$2(a6)
0cd0: 486efff8             pea.l      -$8(a6)
0cd4: a8a3                 dc.w       $a8a3
0cd6: 3f2efffa             move.w     -$6(a6), -(a7)
0cda: 70ff                 moveq      #$ff, d0
0cdc: d06efffc             add.w      -$4(a6), d0
0ce0: 3f00                 move.w     d0, -(a7)
0ce2: a893                 dc.w       $a893
0ce4: 2f0b                 move.l     a3, -(a7)
0ce6: a884                 dc.w       $a884
0ce8: 4ebafb04             jsr        $7ee(pc)
0cec: 3f3c0003             move.w     #$3, -(a7)
0cf0: a887                 dc.w       $a887
0cf2: 4cdf1800             movem.l    (a7)+, a3-a4
0cf6: 4e5e                 unlk       a6
0cf8: 4e75                 rts        
0cfa: 4e56fff8             link.w     a6, #$fff8
0cfe: 2f07                 move.l     d7, -(a7)
0d00: 206dde80             movea.l    -$2180(a5), a0
0d04: 2d680046fff8         move.l     $46(a0), -$8(a6)
0d0a: 2d68004afffc         move.l     $4a(a0), -$4(a6)
0d10: 226dde78             movea.l    -$2188(a5), a1
0d14: 2251                 movea.l    (a1), a1
0d16: 3e29030a             move.w     $30a(a1), d7
0d1a: be6deea4             cmp.w      -$115c(a5), d7
0d1e: 6706                 beq.b      $d26
0d20: 3b47eea4             move.w     d7, -$115c(a5)
0d24: 6012                 bra.b      $d38
0d26: 4a6deea4             tst.w      -$115c(a5)
0d2a: 6718                 beq.b      $d44
0d2c: 486efff8             pea.l      -$8(a6)
0d30: 2f3c00010001         move.l     #$10001, -(a7)
0d36: a8a9                 dc.w       $a8a9
0d38: 2f2ddec2             move.l     -$213e(a5), -(a7)
0d3c: a873                 dc.w       $a873
0d3e: 486efff8             pea.l      -$8(a6)
0d42: a928                 dc.w       $a928
0d44: 2e1f                 move.l     (a7)+, d7
0d46: 4e5e                 unlk       a6
0d48: 4e75                 rts        
