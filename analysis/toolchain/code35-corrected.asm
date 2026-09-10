0004: 4e56fffe             link.w     a6, #$fffe
0008: 4a6e0008             tst.w      $8(a6)
000c: 6f1c                 ble.b      $2a
000e: 302e0008             move.w     $8(a6), d0
0012: b06dd55e             cmp.w      -$2aa2(a5), d0
0016: 6c12                 bge.b      $2a
0018: 302e0008             move.w     $8(a6), d0
001c: 48c0                 ext.l      d0
001e: e788                 lsl.l      #$3, d0
0020: 206dd55a             movea.l    -$2aa6(a5), a0
0024: 4a300806             tst.b      $6(a0, d0.l)
0028: 6604                 bne.b      $2e
002a: 7000                 moveq      #$0, d0
002c: 6002                 bra.b      $30
002e: 7001                 moveq      #$1, d0
0030: 4e5e                 unlk       a6
0032: 4e75                 rts        
0034: 4e56fffe             link.w     a6, #$fffe
0038: 4a6e0008             tst.w      $8(a6)
003c: 6d20                 blt.b      $5e
003e: 302e0008             move.w     $8(a6), d0
0042: b06dd55e             cmp.w      -$2aa2(a5), d0
0046: 6c12                 bge.b      $5a
0048: 302e0008             move.w     $8(a6), d0
004c: 48c0                 ext.l      d0
004e: e788                 lsl.l      #$3, d0
0050: 206dd55a             movea.l    -$2aa6(a5), a0
0054: 4a300806             tst.b      $6(a0, d0.l)
0058: 6704                 beq.b      $5e
005a: 7000                 moveq      #$0, d0
005c: 6002                 bra.b      $60
005e: 7001                 moveq      #$1, d0
0060: 4e5e                 unlk       a6
0062: 4e75                 rts        
0064: 4e56ffda             link.w     a6, #$ffda
0068: 48e70700             movem.l    d5-d7, -(a7)
006c: 7e00                 moveq      #$0, d7
006e: 41eeffe4             lea.l      -$1c(a6), a0
0072: 43ee000c             lea.l      $c(a6), a1
0076: 20d9                 move.l     (a1)+, (a0)+
0078: 20d9                 move.l     (a1)+, (a0)+
007a: 30d9                 move.w     (a1)+, (a0)+
007c: 4868fff6             pea.l      -$a(a0)
0080: 3f3c0016             move.w     #$16, -(a7)
0084: a9eb                 dc.w       $a9eb
0086: 4868fff6             pea.l      -$a(a0)
008a: 486effee             pea.l      -$12(a6)
008e: 3f3c3010             move.w     #$3010, -(a7)
0092: a9eb                 dc.w       $a9eb
0094: 2a2efff2             move.l     -$e(a6), d5
0098: 2c05                 move.l     d5, d6
009a: 6004                 bra.b      $a0
009c: e28e                 lsr.l      #$1, d6
009e: 5247                 addq.w     #$1, d7
00a0: 4a86                 tst.l      d6
00a2: 66f8                 bne.b      $9c
00a4: 2007                 move.l     d7, d0
00a6: 48c0                 ext.l      d0
00a8: 81fc0002             divs.w     #$2, d0
00ac: e0ad                 lsr.l      d0, d5
00ae: 4a85                 tst.l      d5
00b0: 6718                 beq.b      $ca
00b2: 2d45fff2             move.l     d5, -$e(a6)
00b6: 42aeffee             clr.l      -$12(a6)
00ba: 486effee             pea.l      -$12(a6)
00be: 486effe4             pea.l      -$1c(a6)
00c2: 3f3c300e             move.w     #$300e, -(a7)
00c6: a9eb                 dc.w       $a9eb
00c8: 6012                 bra.b      $dc
00ca: 42aeffea             clr.l      -$16(a6)
00ce: 2d7c80000000ffe6     move.l     #$80000000, -$1a(a6)
00d6: 3d7c3fffffe4         move.w     #$3fff, -$1c(a6)
00dc: 41eefff6             lea.l      -$a(a6), a0
00e0: 43eeffe4             lea.l      -$1c(a6), a1
00e4: 20d9                 move.l     (a1)+, (a0)+
00e6: 20d9                 move.l     (a1)+, (a0)+
00e8: 30d9                 move.w     (a1)+, (a0)+
00ea: 487a007e             pea.l      $16a(pc)
00ee: 486e000c             pea.l      $c(a6)
00f2: 3f3c2008             move.w     #$2008, -(a7)
00f6: a9eb                 dc.w       $a9eb
00f8: 6c04                 bge.b      $fe
00fa: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
00fe: 7e00                 moveq      #$0, d7
0100: 6036                 bra.b      $138
0102: 41eeffda             lea.l      -$26(a6), a0
0106: 43ee000c             lea.l      $c(a6), a1
010a: 20d9                 move.l     (a1)+, (a0)+
010c: 20d9                 move.l     (a1)+, (a0)+
010e: 30d9                 move.w     (a1)+, (a0)+
0110: 486efff6             pea.l      -$a(a6)
0114: 4868fff6             pea.l      -$a(a0)
0118: 3f3c0006             move.w     #$6, -(a7)
011c: a9eb                 dc.w       $a9eb
011e: 4868fff6             pea.l      -$a(a0)
0122: 486efff6             pea.l      -$a(a6)
0126: 4267                 clr.w      -(a7)
0128: a9eb                 dc.w       $a9eb
012a: 487a003c             pea.l      $168(pc)
012e: 486efff6             pea.l      -$a(a6)
0132: 3f3c2006             move.w     #$2006, -(a7)
0136: a9eb                 dc.w       $a9eb
0138: 487a002c             pea.l      $166(pc)
013c: 486efff6             pea.l      -$a(a6)
0140: 3f3c2008             move.w     #$2008, -(a7)
0144: a9eb                 dc.w       $a9eb
0146: 6f08                 ble.b      $150
0148: 5247                 addq.w     #$1, d7
014a: 0c470005             cmpi.w     #$5, d7
014e: 6db2                 blt.b      $102
0150: 206e0008             movea.l    $8(a6), a0
0154: 43eefff6             lea.l      -$a(a6), a1
0158: 20d9                 move.l     (a1)+, (a0)+
015a: 20d9                 move.l     (a1)+, (a0)+
015c: 30d9                 move.w     (a1)+, (a0)+
015e: 4cdf00e0             movem.l    (a7)+, d5-d7
0162: 4e5e                 unlk       a6
0164: 4e75                 rts        
0166: 00000002             ori.b      #$2, d0
016a: 00004e56             ori.b      #$56, d0
016e: ffba                 dc.w       $ffba
0170: 48e70028             movem.l    a2/a4, -(a7)
0174: 286e0008             movea.l    $8(a6), a4
0178: 200c                 move.l     a4, d0
017a: 67000190             beq.w      $30c
017e: 7014                 moveq      #$14, d0
0180: b0ac0014             cmp.l      $14(a4), d0
0184: 6e00014e             bgt.w      $2d4
0188: 486c0014             pea.l      $14(a4)
018c: 486effe2             pea.l      -$1e(a6)
0190: 3f3c280e             move.w     #$280e, -(a7)
0194: a9eb                 dc.w       $a9eb
0196: 41eeffd8             lea.l      -$28(a6), a0
019a: 43ec000a             lea.l      $a(a4), a1
019e: 20d9                 move.l     (a1)+, (a0)+
01a0: 20d9                 move.l     (a1)+, (a0)+
01a2: 30d9                 move.w     (a1)+, (a0)+
01a4: 486effe2             pea.l      -$1e(a6)
01a8: 4868fff6             pea.l      -$a(a0)
01ac: 3f3c0006             move.w     #$6, -(a7)
01b0: a9eb                 dc.w       $a9eb
01b2: 43eefff6             lea.l      -$a(a6), a1
01b6: 41e8fff6             lea.l      -$a(a0), a0
01ba: 22d8                 move.l     (a0)+, (a1)+
01bc: 22d8                 move.l     (a0)+, (a1)+
01be: 32d8                 move.w     (a0)+, (a1)+
01c0: 41eeffd8             lea.l      -$28(a6), a0
01c4: 43eefff6             lea.l      -$a(a6), a1
01c8: 20d9                 move.l     (a1)+, (a0)+
01ca: 20d9                 move.l     (a1)+, (a0)+
01cc: 30d9                 move.w     (a1)+, (a0)+
01ce: 486efff6             pea.l      -$a(a6)
01d2: 4868fff6             pea.l      -$a(a0)
01d6: 3f3c0004             move.w     #$4, -(a7)
01da: a9eb                 dc.w       $a9eb
01dc: 43eeffce             lea.l      -$32(a6), a1
01e0: 45d4                 lea.l      (a4), a2
01e2: 22da                 move.l     (a2)+, (a1)+
01e4: 22da                 move.l     (a2)+, (a1)+
01e6: 32da                 move.w     (a2)+, (a1)+
01e8: 486effe2             pea.l      -$1e(a6)
01ec: 4869fff6             pea.l      -$a(a1)
01f0: 3f3c0006             move.w     #$6, -(a7)
01f4: a9eb                 dc.w       $a9eb
01f6: 45eeffc4             lea.l      -$3c(a6), a2
01fa: 43e9fff6             lea.l      -$a(a1), a1
01fe: 24d9                 move.l     (a1)+, (a2)+
0200: 24d9                 move.l     (a1)+, (a2)+
0202: 34d9                 move.w     (a1)+, (a2)+
0204: 4868fff6             pea.l      -$a(a0)
0208: 486afff6             pea.l      -$a(a2)
020c: 3f3c0002             move.w     #$2, -(a7)
0210: a9eb                 dc.w       $a9eb
0212: 41eeffba             lea.l      -$46(a6), a0
0216: 45eafff6             lea.l      -$a(a2), a2
021a: 20da                 move.l     (a2)+, (a0)+
021c: 20da                 move.l     (a2)+, (a0)+
021e: 30da                 move.w     (a2)+, (a0)+
0220: 486effe2             pea.l      -$1e(a6)
0224: 4868fff6             pea.l      -$a(a0)
0228: 3f3c0006             move.w     #$6, -(a7)
022c: a9eb                 dc.w       $a9eb
022e: 43eeffec             lea.l      -$14(a6), a1
0232: 41e8fff6             lea.l      -$a(a0), a0
0236: 22d8                 move.l     (a0)+, (a1)+
0238: 22d8                 move.l     (a0)+, (a1)+
023a: 32d8                 move.w     (a0)+, (a1)+
023c: 41eefff6             lea.l      -$a(a6), a0
0240: 3f20                 move.w     -(a0), -(a7)
0242: 2f20                 move.l     -(a0), -(a7)
0244: 2f20                 move.l     -(a0), -(a7)
0246: 486effd8             pea.l      -$28(a6)
024a: 4ebafe18             jsr        $64(pc)
024e: 41eeffec             lea.l      -$14(a6), a0
0252: 43eeffd8             lea.l      -$28(a6), a1
0256: 20d9                 move.l     (a1)+, (a0)+
0258: 20d9                 move.l     (a1)+, (a0)+
025a: 30d9                 move.w     (a1)+, (a0)+
025c: 487a00b6             pea.l      $314(pc)
0260: 486effec             pea.l      -$14(a6)
0264: 3f3c2008             move.w     #$2008, -(a7)
0268: a9eb                 dc.w       $a9eb
026a: 4fef000e             lea.l      $e(a7), a7
026e: 6f70                 ble.b      $2e0
0270: 486effec             pea.l      -$14(a6)
0274: 486efff6             pea.l      -$a(a6)
0278: 3f3c0008             move.w     #$8, -(a7)
027c: a9eb                 dc.w       $a9eb
027e: 6f10                 ble.b      $290
0280: 486effec             pea.l      -$14(a6)
0284: 486efff6             pea.l      -$a(a6)
0288: 3f3c0002             move.w     #$2, -(a7)
028c: a9eb                 dc.w       $a9eb
028e: 6050                 bra.b      $2e0
0290: 41eeffd8             lea.l      -$28(a6), a0
0294: 43eeffec             lea.l      -$14(a6), a1
0298: 20d9                 move.l     (a1)+, (a0)+
029a: 20d9                 move.l     (a1)+, (a0)+
029c: 30d9                 move.w     (a1)+, (a0)+
029e: 4868fff6             pea.l      -$a(a0)
02a2: 3f3c000d             move.w     #$d, -(a7)
02a6: a9eb                 dc.w       $a9eb
02a8: 4868fff6             pea.l      -$a(a0)
02ac: 486efff6             pea.l      -$a(a6)
02b0: 3f3c0008             move.w     #$8, -(a7)
02b4: a9eb                 dc.w       $a9eb
02b6: 6c0e                 bge.b      $2c6
02b8: 486effec             pea.l      -$14(a6)
02bc: 486efff6             pea.l      -$a(a6)
02c0: 4267                 clr.w      -(a7)
02c2: a9eb                 dc.w       $a9eb
02c4: 601a                 bra.b      $2e0
02c6: 42aefffc             clr.l      -$4(a6)
02ca: 42aefff8             clr.l      -$8(a6)
02ce: 426efff6             clr.w      -$a(a6)
02d2: 600c                 bra.b      $2e0
02d4: 42aefffc             clr.l      -$4(a6)
02d8: 42aefff8             clr.l      -$8(a6)
02dc: 426efff6             clr.w      -$a(a6)
02e0: 41eeffd4             lea.l      -$2c(a6), a0
02e4: 43eefff6             lea.l      -$a(a6), a1
02e8: 20d9                 move.l     (a1)+, (a0)+
02ea: 20d9                 move.l     (a1)+, (a0)+
02ec: 30d9                 move.w     (a1)+, (a0)+
02ee: 4868fff6             pea.l      -$a(a0)
02f2: 3f3c0016             move.w     #$16, -(a7)
02f6: a9eb                 dc.w       $a9eb
02f8: 4868fff6             pea.l      -$a(a0)
02fc: 486effde             pea.l      -$22(a6)
0300: 3f3c2810             move.w     #$2810, -(a7)
0304: a9eb                 dc.w       $a9eb
0306: 296effde0018         move.l     -$22(a6), $18(a4)
030c: 4cdf1400             movem.l    (a7)+, a2/a4
0310: 4e5e                 unlk       a6
0312: 4e75                 rts        
0314: 00504e56             ori.w      #$4e56, (a0)
0318: 000048e7             ori.b      #$e7, d0
031c: 0700                 btst.l     d3, d0
031e: 4aae000c             tst.l      $c(a6)
0322: 6604                 bne.b      $328
0324: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0328: 4aae0008             tst.l      $8(a6)
032c: 6604                 bne.b      $332
032e: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0332: 7e00                 moveq      #$0, d7
0334: 6020                 bra.b      $356
0336: 206e000c             movea.l    $c(a6), a0
033a: 54ae000c             addq.l     #$2, $c(a6)
033e: 3a10                 move.w     (a0), d5
0340: 4a6e0010             tst.w      $10(a6)
0344: 670c                 beq.b      $352
0346: 3f06                 move.w     d6, -(a7)
0348: 4ebafcea             jsr        $34(pc)
034c: 4a40                 tst.w      d0
034e: 548f                 addq.l     #$2, a7
0350: 6704                 beq.b      $356
0352: 3045                 movea.w    d5, a0
0354: de88                 add.l      a0, d7
0356: 206e0008             movea.l    $8(a6), a0
035a: 54ae0008             addq.l     #$2, $8(a6)
035e: 3c10                 move.w     (a0), d6
0360: 66d4                 bne.b      $336
0362: 2007                 move.l     d7, d0
0364: 4cdf00e0             movem.l    (a7)+, d5-d7
0368: 4e5e                 unlk       a6
036a: 4e75                 rts        
036c: 4e56feb6             link.w     a6, #$feb6
0370: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0374: 286e000c             movea.l    $c(a6), a4
0378: 266e0010             movea.l    $10(a6), a3
037c: 42aefec4             clr.l      -$13c(a6)
0380: 2f2dc376             move.l     -$3c8a(a5), -(a7)
0384: 4ead096a             jsr        $96a(a5) ; CODE31+0992
0388: 486eff74             pea.l      -$8c(a6)
038c: 4ead095a             jsr        $95a(a5) ; CODE31+075c
0390: 1d40fec3             move.b     d0, -$13d(a6)
0394: 4a2dbd8e             tst.b      -$4272(a5)
0398: 508f                 addq.l     #$8, a7
039a: 663c                 bne.b      $3d8
039c: 206e0008             movea.l    $8(a6), a0
03a0: 4a280020             tst.b      $20(a0)
03a4: 670c                 beq.b      $3b2
03a6: 2f2e0008             move.l     $8(a6), -(a7)
03aa: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
03ae: 588f                 addq.l     #$4, a7
03b0: 6002                 bra.b      $3b4
03b2: 7000                 moveq      #$0, d0
03b4: 4878001c             pea.l      $1c.w
03b8: 2f00                 move.l     d0, -(a7)
03ba: 4ead0042             jsr        $42(a5) ; CODE1+00ee
03be: 206dd568             movea.l    -$2a98(a5), a0
03c2: 26300818             move.l     $18(a0, d0.l), d3
03c6: d7aefec4             add.l      d3, -$13c(a6)
03ca: 200b                 move.l     a3, d0
03cc: 6702                 beq.b      $3d0
03ce: 36c3                 move.w     d3, (a3)+
03d0: 200c                 move.l     a4, d0
03d2: 6704                 beq.b      $3d8
03d4: 38fcffe0             move.w     #$ffe0, (a4)+
03d8: 206e0008             movea.l    $8(a6), a0
03dc: 1a280020             move.b     $20(a0), d5
03e0: 4a05                 tst.b      d5
03e2: 670002c2             beq.w      $6a6
03e6: 7600                 moveq      #$0, d3
03e8: 1805                 move.b     d5, d4
03ea: 4884                 ext.w      d4
03ec: 206e0008             movea.l    $8(a6), a0
03f0: 1a280021             move.b     $21(a0), d5
03f4: 4885                 ext.w      d5
03f6: 2448                 movea.l    a0, a2
03f8: 7011                 moveq      #$11, d0
03fa: c1c4                 muls.w     d4, d0
03fc: 43edbcfe             lea.l      -$4302(a5), a1
0400: d089                 add.l      a1, d0
0402: 2d40fecc             move.l     d0, -$134(a6)
0406: 72ff                 moveq      #$ff, d1
0408: d244                 add.w      d4, d1
040a: c3fc0011             muls.w     #$11, d1
040e: 43edbcfe             lea.l      -$4302(a5), a1
0412: d289                 add.l      a1, d1
0414: 2d41fed0             move.l     d1, -$130(a6)
0418: 74ff                 moveq      #$ff, d2
041a: d444                 add.w      d4, d2
041c: c5fc0011             muls.w     #$11, d2
0420: 43ed97b2             lea.l      -$684e(a5), a1
0424: d489                 add.l      a1, d2
0426: 2d42fed4             move.l     d2, -$12c(a6)
042a: 70ff                 moveq      #$ff, d0
042c: d044                 add.w      d4, d0
042e: c1fc0011             muls.w     #$11, d0
0432: 43ed9592             lea.l      -$6a6e(a5), a1
0436: d089                 add.l      a1, d0
0438: 2d40fed8             move.l     d0, -$128(a6)
043c: 70fe                 moveq      #$fe, d0
043e: d044                 add.w      d4, d0
0440: c1fc0011             muls.w     #$11, d0
0444: 43edbcfe             lea.l      -$4302(a5), a1
0448: d089                 add.l      a1, d0
044a: 2d40feec             move.l     d0, -$114(a6)
044e: 7001                 moveq      #$1, d0
0450: d044                 add.w      d4, d0
0452: c1fc0011             muls.w     #$11, d0
0456: 43edbcfe             lea.l      -$4302(a5), a1
045a: d089                 add.l      a1, d0
045c: 2d40fee8             move.l     d0, -$118(a6)
0460: 7001                 moveq      #$1, d0
0462: d044                 add.w      d4, d0
0464: c1fc0011             muls.w     #$11, d0
0468: 43ed97b2             lea.l      -$684e(a5), a1
046c: d089                 add.l      a1, d0
046e: 2d40fee4             move.l     d0, -$11c(a6)
0472: 7001                 moveq      #$1, d0
0474: d044                 add.w      d4, d0
0476: c1fc0011             muls.w     #$11, d0
047a: 43ed9592             lea.l      -$6a6e(a5), a1
047e: d089                 add.l      a1, d0
0480: 2d40fee0             move.l     d0, -$120(a6)
0484: 7002                 moveq      #$2, d0
0486: d044                 add.w      d4, d0
0488: c1fc0011             muls.w     #$11, d0
048c: 43edbcfe             lea.l      -$4302(a5), a1
0490: d089                 add.l      a1, d0
0492: 2d40fedc             move.l     d0, -$124(a6)
0496: 1e12                 move.b     (a2), d7
0498: 4a07                 tst.b      d7
049a: 670001f4             beq.w      $690
049e: 7000                 moveq      #$0, d0
04a0: 1007                 move.b     d7, d0
04a2: 204d                 movea.l    a5, a0
04a4: d1c0                 adda.l     d0, a0
04a6: 4a28fbd8             tst.b      -$428(a0)
04aa: 6b04                 bmi.b      $4b0
04ac: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
04b0: 0c440001             cmpi.w     #$1, d4
04b4: 6d12                 blt.b      $4c8
04b6: 0c44001e             cmpi.w     #$1e, d4
04ba: 6e0c                 bgt.b      $4c8
04bc: 0c450001             cmpi.w     #$1, d5
04c0: 6d06                 blt.b      $4c8
04c2: 0c45000f             cmpi.w     #$f, d5
04c6: 6f04                 ble.b      $4cc
04c8: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
04cc: 206efecc             movea.l    -$134(a6), a0
04d0: 4a305000             tst.b      (a0, d5.w)
04d4: 6716                 beq.b      $4ec
04d6: 206efecc             movea.l    -$134(a6), a0
04da: 1012                 move.b     (a2), d0
04dc: b0305000             cmp.b      (a0, d5.w), d0
04e0: 670001a6             beq.w      $688
04e4: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
04e8: 6000019e             bra.w      $688
04ec: 0c440001             cmpi.w     #$1, d4
04f0: 670000c2             beq.w      $5b4
04f4: 0c440010             cmpi.w     #$10, d4
04f8: 670000ba             beq.w      $5b4
04fc: 206efed0             movea.l    -$130(a6), a0
0500: 4a305000             tst.b      (a0, d5.w)
0504: 660000ae             bne.w      $5b4
0508: 206efed4             movea.l    -$12c(a6), a0
050c: 10305000             move.b     (a0, d5.w), d0
0510: 4880                 ext.w      d0
0512: 226efed8             movea.l    -$128(a6), a1
0516: 12315000             move.b     (a1, d5.w), d1
051a: 4881                 ext.w      d1
051c: c1c1                 muls.w     d1, d0
051e: 3d40fec0             move.w     d0, -$140(a6)
0522: 5340                 subq.w     #$1, d0
0524: 6700008e             beq.w      $5b4
0528: 0c440002             cmpi.w     #$2, d4
052c: 6710                 beq.b      $53e
052e: 0c440011             cmpi.w     #$11, d4
0532: 670a                 beq.b      $53e
0534: 206efeec             movea.l    -$114(a6), a0
0538: 4a305000             tst.b      (a0, d5.w)
053c: 6676                 bne.b      $5b4
053e: 0c44000f             cmpi.w     #$f, d4
0542: 6710                 beq.b      $554
0544: 0c44001e             cmpi.w     #$1e, d4
0548: 670a                 beq.b      $554
054a: 206efee8             movea.l    -$118(a6), a0
054e: 4a305000             tst.b      (a0, d5.w)
0552: 6660                 bne.b      $5b4
0554: 426efebe             clr.w      -$142(a6)
0558: 1e12                 move.b     (a2), d7
055a: 1c12                 move.b     (a2), d6
055c: 4886                 ext.w      d6
055e: 41edf68a             lea.l      -$976(a5), a0
0562: 302efebe             move.w     -$142(a6), d0
0566: 48c0                 ext.l      d0
0568: e588                 lsl.l      #$2, d0
056a: d088                 add.l      a0, d0
056c: 2d40feba             move.l     d0, -$146(a6)
0570: 603a                 bra.b      $5ac
0572: 206efeba             movea.l    -$146(a6), a0
0576: 4a280001             tst.b      $1(a0)
057a: 6628                 bne.b      $5a4
057c: 206efeba             movea.l    -$146(a6), a0
0580: 7000                 moveq      #$0, d0
0582: 10280002             move.b     $2(a0), d0
0586: b06efec0             cmp.w      -$140(a6), d0
058a: 6618                 bne.b      $5a4
058c: 206efeba             movea.l    -$146(a6), a0
0590: 7000                 moveq      #$0, d0
0592: 1010                 move.b     (a0), d0
0594: b046                 cmp.w      d6, d0
0596: 660c                 bne.b      $5a4
0598: 206efeba             movea.l    -$146(a6), a0
059c: 7000                 moveq      #$0, d0
059e: 10280003             move.b     $3(a0), d0
05a2: 9680                 sub.l      d0, d3
05a4: 526efebe             addq.w     #$1, -$142(a6)
05a8: 58aefeba             addq.l     #$4, -$146(a6)
05ac: 0c6e0014febe         cmpi.w     #$14, -$142(a6)
05b2: 65be                 bcs.b      $572
05b4: 0c44000f             cmpi.w     #$f, d4
05b8: 670000ce             beq.w      $688
05bc: 0c44001e             cmpi.w     #$1e, d4
05c0: 670000c6             beq.w      $688
05c4: 7001                 moveq      #$1, d0
05c6: d044                 add.w      d4, d0
05c8: c1fc0011             muls.w     #$11, d0
05cc: 41edbcfe             lea.l      -$4302(a5), a0
05d0: d088                 add.l      a0, d0
05d2: 3045                 movea.w    d5, a0
05d4: 4a300800             tst.b      (a0, d0.l)
05d8: 660000ae             bne.w      $688
05dc: 206efee4             movea.l    -$11c(a6), a0
05e0: 10305000             move.b     (a0, d5.w), d0
05e4: 4880                 ext.w      d0
05e6: 226efee0             movea.l    -$120(a6), a1
05ea: 12315000             move.b     (a1, d5.w), d1
05ee: 4881                 ext.w      d1
05f0: c1c1                 muls.w     d1, d0
05f2: 3d40fec0             move.w     d0, -$140(a6)
05f6: 5340                 subq.w     #$1, d0
05f8: 6700008e             beq.w      $688
05fc: 0c440001             cmpi.w     #$1, d4
0600: 671c                 beq.b      $61e
0602: 0c440010             cmpi.w     #$10, d4
0606: 6716                 beq.b      $61e
0608: 70ff                 moveq      #$ff, d0
060a: d044                 add.w      d4, d0
060c: c1fc0011             muls.w     #$11, d0
0610: 41edbcfe             lea.l      -$4302(a5), a0
0614: d088                 add.l      a0, d0
0616: 3045                 movea.w    d5, a0
0618: 4a300800             tst.b      (a0, d0.l)
061c: 666a                 bne.b      $688
061e: 0c44000e             cmpi.w     #$e, d4
0622: 6710                 beq.b      $634
0624: 0c44001d             cmpi.w     #$1d, d4
0628: 670a                 beq.b      $634
062a: 206efedc             movea.l    -$124(a6), a0
062e: 4a305000             tst.b      (a0, d5.w)
0632: 6654                 bne.b      $688
0634: 426efebe             clr.w      -$142(a6)
0638: 41edf68a             lea.l      -$976(a5), a0
063c: 2d48feba             move.l     a0, -$146(a6)
0640: 603e                 bra.b      $680
0642: 206efeba             movea.l    -$146(a6), a0
0646: 4a280001             tst.b      $1(a0)
064a: 672c                 beq.b      $678
064c: 206efeba             movea.l    -$146(a6), a0
0650: 7000                 moveq      #$0, d0
0652: 10280002             move.b     $2(a0), d0
0656: b06efec0             cmp.w      -$140(a6), d0
065a: 661c                 bne.b      $678
065c: 1012                 move.b     (a2), d0
065e: 4880                 ext.w      d0
0660: 206efeba             movea.l    -$146(a6), a0
0664: 7200                 moveq      #$0, d1
0666: 1210                 move.b     (a0), d1
0668: b240                 cmp.w      d0, d1
066a: 660c                 bne.b      $678
066c: 206efeba             movea.l    -$146(a6), a0
0670: 7000                 moveq      #$0, d0
0672: 10280003             move.b     $3(a0), d0
0676: 9680                 sub.l      d0, d3
0678: 526efebe             addq.w     #$1, -$142(a6)
067c: 58aefeba             addq.l     #$4, -$146(a6)
0680: 0c6e0014febe         cmpi.w     #$14, -$142(a6)
0686: 65ba                 bcs.b      $642
0688: 528a                 addq.l     #$1, a2
068a: 5245                 addq.w     #$1, d5
068c: 6000fe08             bra.w      $496
0690: 4a83                 tst.l      d3
0692: 6712                 beq.b      $6a6
0694: d7aefec4             add.l      d3, -$13c(a6)
0698: 200b                 move.l     a3, d0
069a: 6702                 beq.b      $69e
069c: 36c3                 move.w     d3, (a3)+
069e: 200c                 move.l     a4, d0
06a0: 6704                 beq.b      $6a6
06a2: 38fc4e20             move.w     #$4e20, (a4)+
06a6: 4267                 clr.w      -(a7)
06a8: 2f2dc376             move.l     -$3c8a(a5), -(a7)
06ac: 2f2e0008             move.l     $8(a6), -(a7)
06b0: 4ead0942             jsr        $942(a5) ; CODE31+0184
06b4: 102effe9             move.b     -$17(a6), d0
06b8: 4880                 ext.w      d0
06ba: 122effe3             move.b     -$1d(a6), d1
06be: 4881                 ext.w      d1
06c0: 142effdd             move.b     -$23(a6), d2
06c4: 4882                 ext.w      d2
06c6: 3d40feb6             move.w     d0, -$14a(a6)
06ca: 102effd9             move.b     -$27(a6), d0
06ce: 4880                 ext.w      d0
06d0: 1a2effd5             move.b     -$2b(a6), d5
06d4: 4885                 ext.w      d5
06d6: da40                 add.w      d0, d5
06d8: da42                 add.w      d2, d5
06da: da41                 add.w      d1, d5
06dc: da6efeb6             add.w      -$14a(a6), d5
06e0: 182efec3             move.b     -$13d(a6), d4
06e4: 4884                 ext.w      d4
06e6: 3e04                 move.w     d4, d7
06e8: 9e45                 sub.w      d5, d7
06ea: 700a                 moveq      #$a, d0
06ec: c1c5                 muls.w     d5, d0
06ee: 3204                 move.w     d4, d1
06f0: e549                 lsl.w      #$2, d1
06f2: b240                 cmp.w      d0, d1
06f4: 4fef000a             lea.l      $a(a7), a7
06f8: 6f0a                 ble.b      $704
06fa: 162effb3             move.b     -$4d(a6), d3
06fe: 4883                 ext.w      d3
0700: da43                 add.w      d3, d5
0702: 9e43                 sub.w      d3, d7
0704: 426efebe             clr.w      -$142(a6)
0708: 426efec0             clr.w      -$140(a6)
070c: 7800                 moveq      #$0, d4
070e: 246dc376             movea.l    -$3c8a(a5), a2
0712: 6020                 bra.b      $734
0714: 3f06                 move.w     d6, -(a7)
0716: 4ead07d2             jsr        $7d2(a5) ; CODE23+0004
071a: 4a40                 tst.w      d0
071c: 548f                 addq.l     #$2, a7
071e: 6706                 beq.b      $726
0720: 526efec0             addq.w     #$1, -$140(a6)
0724: 600e                 bra.b      $734
0726: 0c46003f             cmpi.w     #$3f, d6
072a: 6704                 beq.b      $730
072c: 5244                 addq.w     #$1, d4
072e: 6004                 bra.b      $734
0730: 526efebe             addq.w     #$1, -$142(a6)
0734: 1c1a                 move.b     (a2)+, d6
0736: 4886                 ext.w      d6
0738: 4a46                 tst.w      d6
073a: 66d8                 bne.b      $714
073c: 7c07                 moveq      #$7, d6
073e: 9c6efec0             sub.w      -$140(a6), d6
0742: 9c44                 sub.w      d4, d6
0744: 9c6efebe             sub.w      -$142(a6), d6
0748: 102efec3             move.b     -$13d(a6), d0
074c: 4880                 ext.w      d0
074e: 5f40                 subq.w     #$7, d0
0750: 3d40feb8             move.w     d0, -$148(a6)
0754: bc40                 cmp.w      d0, d6
0756: 6f12                 ble.b      $76a
0758: 0c2e0007fec3         cmpi.b     #$7, -$13d(a6)
075e: 6e04                 bgt.b      $764
0760: 7000                 moveq      #$0, d0
0762: 6004                 bra.b      $768
0764: 302efeb8             move.w     -$148(a6), d0
0768: 3c00                 move.w     d0, d6
076a: 3f06                 move.w     d6, -(a7)
076c: 3f07                 move.w     d7, -(a7)
076e: 3f05                 move.w     d5, -(a7)
0770: 3f2efebe             move.w     -$142(a6), -(a7)
0774: 3f04                 move.w     d4, -(a7)
0776: 3f2efec0             move.w     -$140(a6), -(a7)
077a: 4ead09ca             jsr        $9ca(a5) ; CODE32+0cc4
077e: 2600                 move.l     d0, d3
0780: d7aefec4             add.l      d3, -$13c(a6)
0784: 200b                 move.l     a3, d0
0786: 4fef000c             lea.l      $c(a7), a7
078a: 6702                 beq.b      $78e
078c: 36c3                 move.w     d3, (a3)+
078e: 200c                 move.l     a4, d0
0790: 6704                 beq.b      $796
0792: 38fcffff             move.w     #$ffff, (a4)+
0796: 206e0008             movea.l    $8(a6), a0
079a: 4a280020             tst.b      $20(a0)
079e: 6704                 beq.b      $7a4
07a0: 9d2efec3             sub.b      d6, -$13d(a6)
07a4: 0c2e0007fec3         cmpi.b     #$7, -$13d(a6)
07aa: 6f30                 ble.b      $7dc
07ac: 0c2e0011fec3         cmpi.b     #$11, -$13d(a6)
07b2: 6c28                 bge.b      $7dc
07b4: 102efec3             move.b     -$13d(a6), d0
07b8: 4880                 ext.w      d0
07ba: 204d                 movea.l    a5, a0
07bc: d0c0                 adda.w     d0, a0
07be: d0c0                 adda.w     d0, a0
07c0: 36289ede             move.w     -$6122(a0), d3
07c4: 966d9eee             sub.w      -$6112(a5), d3
07c8: 48c3                 ext.l      d3
07ca: d7aefec4             add.l      d3, -$13c(a6)
07ce: 200b                 move.l     a3, d0
07d0: 6702                 beq.b      $7d4
07d2: 36c3                 move.w     d3, (a3)+
07d4: 200c                 move.l     a4, d0
07d6: 6704                 beq.b      $7dc
07d8: 38fcffdf             move.w     #$ffdf, (a4)+
07dc: 206e0008             movea.l    $8(a6), a0
07e0: 4a280020             tst.b      $20(a0)
07e4: 6704                 beq.b      $7ea
07e6: dd2efec3             add.b      d6, -$13d(a6)
07ea: 7600                 moveq      #$0, d3
07ec: 422efef1             clr.b      -$10f(a6)
07f0: 246d99d2             movea.l    -$662e(a5), a2
07f4: 604c                 bra.b      $842
07f6: 1d46fef0             move.b     d6, -$110(a6)
07fa: 4a46                 tst.w      d6
07fc: 6d10                 blt.b      $80e
07fe: 0c460080             cmpi.w     #$80, d6
0802: 640a                 bcc.b      $80e
0804: 204e                 movea.l    a6, a0
0806: d0c6                 adda.w     d6, a0
0808: 4a28ff74             tst.b      -$8c(a0)
080c: 6c04                 bge.b      $812
080e: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0812: 41eeff74             lea.l      -$8c(a6), a0
0816: d0c6                 adda.w     d6, a0
0818: 2d48fec8             move.l     a0, -$138(a6)
081c: 4a10                 tst.b      (a0)
081e: 6722                 beq.b      $842
0820: 0c460071             cmpi.w     #$71, d6
0824: 671c                 beq.b      $842
0826: 486eff70             pea.l      -$90(a6)
082a: 486efef0             pea.l      -$110(a6)
082e: 4ead09c2             jsr        $9c2(a5) ; CODE32+16c0
0832: 206efec8             movea.l    -$138(a6), a0
0836: 1210                 move.b     (a0), d1
0838: 4881                 ext.w      d1
083a: c3c0                 muls.w     d0, d1
083c: 3241                 movea.w    d1, a1
083e: d689                 add.l      a1, d3
0840: 508f                 addq.l     #$8, a7
0842: 1c1a                 move.b     (a2)+, d6
0844: 4886                 ext.w      d6
0846: 4a46                 tst.w      d6
0848: 66ac                 bne.b      $7f6
084a: 4a2effe5             tst.b      -$1b(a6)
084e: 6722                 beq.b      $872
0850: 486eff70             pea.l      -$90(a6)
0854: 486df720             pea.l      -$8e0(a5)
0858: 4ead09c2             jsr        $9c2(a5) ; CODE32+16c0
085c: 122effe9             move.b     -$17(a6), d1
0860: 4881                 ext.w      d1
0862: 204d                 movea.l    a5, a0
0864: d0c1                 adda.w     d1, a0
0866: d0c1                 adda.w     d1, a0
0868: 3068f702             movea.w    -$8fe(a0), a0
086c: d0c0                 adda.w     d0, a0
086e: d688                 add.l      a0, d3
0870: 508f                 addq.l     #$8, a7
0872: 2f2dc376             move.l     -$3c8a(a5), -(a7)
0876: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
087a: 7c07                 moveq      #$7, d6
087c: 9c40                 sub.w      d0, d6
087e: 3046                 movea.w    d6, a0
0880: 2e88                 move.l     a0, (a7)
0882: 2f03                 move.l     d3, -(a7)
0884: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0888: 2600                 move.l     d0, d3
088a: 1a2efec3             move.b     -$13d(a6), d5
088e: 4885                 ext.w      d5
0890: 48c5                 ext.l      d5
0892: 8bfc0002             divs.w     #$2, d5
0896: 182efec3             move.b     -$13d(a6), d4
089a: 4884                 ext.w      d4
089c: 3045                 movea.w    d5, a0
089e: d688                 add.l      a0, d3
08a0: 1e2efec3             move.b     -$13d(a6), d7
08a4: 4887                 ext.w      d7
08a6: 48c7                 ext.l      d7
08a8: 2f07                 move.l     d7, -(a7)
08aa: 2f03                 move.l     d3, -(a7)
08ac: 4ead005a             jsr        $5a(a5) ; CODE1+0166
08b0: 2600                 move.l     d0, d3
08b2: d7aefec4             add.l      d3, -$13c(a6)
08b6: 200b                 move.l     a3, d0
08b8: 6702                 beq.b      $8bc
08ba: 36c3                 move.w     d3, (a3)+
08bc: 200c                 move.l     a4, d0
08be: 6704                 beq.b      $8c4
08c0: 38fcfffe             move.w     #$fffe, (a4)+
08c4: 3f3c0075             move.w     #$75, -(a7)
08c8: 2f2dc376             move.l     -$3c8a(a5), -(a7)
08cc: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
08d0: 4a80                 tst.l      d0
08d2: 5c8f                 addq.l     #$6, a7
08d4: 6752                 beq.b      $928
08d6: 4a2effe5             tst.b      -$1b(a6)
08da: 674c                 beq.b      $928
08dc: 486eff70             pea.l      -$90(a6)
08e0: 486df722             pea.l      -$8de(a5)
08e4: 4ead09c2             jsr        $9c2(a5) ; CODE32+16c0
08e8: 122effe9             move.b     -$17(a6), d1
08ec: 4881                 ext.w      d1
08ee: 204d                 movea.l    a5, a0
08f0: d0c1                 adda.w     d1, a0
08f2: d0c1                 adda.w     d1, a0
08f4: 9068f702             sub.w      -$8fe(a0), d0
08f8: 48c0                 ext.l      d0
08fa: 2600                 move.l     d0, d3
08fc: 3046                 movea.w    d6, a0
08fe: 2e88                 move.l     a0, (a7)
0900: 2f03                 move.l     d3, -(a7)
0902: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0906: 2600                 move.l     d0, d3
0908: 3045                 movea.w    d5, a0
090a: d688                 add.l      a0, d3
090c: 2e87                 move.l     d7, (a7)
090e: 2f03                 move.l     d3, -(a7)
0910: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0914: 2600                 move.l     d0, d3
0916: d7aefec4             add.l      d3, -$13c(a6)
091a: 200b                 move.l     a3, d0
091c: 6702                 beq.b      $920
091e: 36c3                 move.w     d3, (a3)+
0920: 200c                 move.l     a4, d0
0922: 6704                 beq.b      $928
0924: 38fcfffd             move.w     #$fffd, (a4)+
0928: 3f3c0071             move.w     #$71, -(a7)
092c: 2f2dc376             move.l     -$3c8a(a5), -(a7)
0930: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
0934: 4a80                 tst.l      d0
0936: 5c8f                 addq.l     #$6, a7
0938: 673e                 beq.b      $978
093a: 3f3c0075             move.w     #$75, -(a7)
093e: 2f2dc376             move.l     -$3c8a(a5), -(a7)
0942: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
0946: 4a80                 tst.l      d0
0948: 5c8f                 addq.l     #$6, a7
094a: 662c                 bne.b      $978
094c: 700a                 moveq      #$a, d0
094e: c1c6                 muls.w     d6, d0
0950: 122effe9             move.b     -$17(a6), d1
0954: 4881                 ext.w      d1
0956: 41edf6da             lea.l      -$926(a5), a0
095a: d088                 add.l      a0, d0
095c: 3041                 movea.w    d1, a0
095e: d1c8                 adda.l     a0, a0
0960: 36300800             move.w     (a0, d0.l), d3
0964: 48c3                 ext.l      d3
0966: d7aefec4             add.l      d3, -$13c(a6)
096a: 200b                 move.l     a3, d0
096c: 6702                 beq.b      $970
096e: 36c3                 move.w     d3, (a3)+
0970: 200c                 move.l     a4, d0
0972: 6704                 beq.b      $978
0974: 38fcfffc             move.w     #$fffc, (a4)+
0978: 246dc376             movea.l    -$3c8a(a5), a2
097c: 1e12                 move.b     (a2), d7
097e: 4a07                 tst.b      d7
0980: 6776                 beq.b      $9f8
0982: be2a0001             cmp.b      $1(a2), d7
0986: 676c                 beq.b      $9f4
0988: 1012                 move.b     (a2), d0
098a: 4880                 ext.w      d0
098c: 204e                 movea.l    a6, a0
098e: d0c0                 adda.w     d0, a0
0990: 1028ff74             move.b     -$8c(a0), d0
0994: 4880                 ext.w      d0
0996: 3f00                 move.w     d0, -(a7)
0998: 3f04                 move.w     d4, -(a7)
099a: 1012                 move.b     (a2), d0
099c: 4880                 ext.w      d0
099e: 3f00                 move.w     d0, -(a7)
09a0: 4ead09d2             jsr        $9d2(a5) ; CODE32+140a
09a4: 2600                 move.l     d0, d3
09a6: 1012                 move.b     (a2), d0
09a8: 4880                 ext.w      d0
09aa: 204d                 movea.l    a5, a0
09ac: d0c0                 adda.w     d0, a0
09ae: 10289512             move.b     -$6aee(a0), d0
09b2: 4880                 ext.w      d0
09b4: 5340                 subq.w     #$1, d0
09b6: 3e80                 move.w     d0, (a7)
09b8: 3f3c0060             move.w     #$60, -(a7)
09bc: 1012                 move.b     (a2), d0
09be: 4880                 ext.w      d0
09c0: 3f00                 move.w     d0, -(a7)
09c2: 4ead09d2             jsr        $9d2(a5) ; CODE32+140a
09c6: 9680                 sub.l      d0, d3
09c8: d7aefec4             add.l      d3, -$13c(a6)
09cc: 200b                 move.l     a3, d0
09ce: 4fef000a             lea.l      $a(a7), a7
09d2: 6702                 beq.b      $9d6
09d4: 36c3                 move.w     d3, (a3)+
09d6: 200c                 move.l     a4, d0
09d8: 671a                 beq.b      $9f4
09da: 1012                 move.b     (a2), d0
09dc: 4880                 ext.w      d0
09de: 3f00                 move.w     d0, -(a7)
09e0: 2f2d99d2             move.l     -$662e(a5), -(a7)
09e4: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
09e8: 90ad99d2             sub.l      -$662e(a5), d0
09ec: 72fb                 moveq      #$fb, d1
09ee: 9240                 sub.w      d0, d1
09f0: 38c1                 move.w     d1, (a4)+
09f2: 5c8f                 addq.l     #$6, a7
09f4: 528a                 addq.l     #$1, a2
09f6: 6084                 bra.b      $97c
09f8: 4267                 clr.w      -(a7)
09fa: 2f0b                 move.l     a3, -(a7)
09fc: 2f0c                 move.l     a4, -(a7)
09fe: 4eba0048             jsr        $a48(pc)
0a02: d1aefec4             add.l      d0, -$13c(a6)
0a06: 246dc376             movea.l    -$3c8a(a5), a2
0a0a: 4fef000a             lea.l      $a(a7), a7
0a0e: 1e12                 move.b     (a2), d7
0a10: 4a07                 tst.b      d7
0a12: 6716                 beq.b      $a2a
0a14: 1007                 move.b     d7, d0
0a16: 4880                 ext.w      d0
0a18: 204d                 movea.l    a5, a0
0a1a: d0c0                 adda.w     d0, a0
0a1c: 4a28a54e             tst.b      -$5ab2(a0)
0a20: 6e04                 bgt.b      $a26
0a22: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0a26: 528a                 addq.l     #$1, a2
0a28: 60e4                 bra.b      $a0e
0a2a: 2f2dc376             move.l     -$3c8a(a5), -(a7)
0a2e: 4ead094a             jsr        $94a(a5) ; CODE31+0642
0a32: 2eadc376             move.l     -$3c8a(a5), (a7)
0a36: 4ead096a             jsr        $96a(a5) ; CODE31+0992
0a3a: 202efec4             move.l     -$13c(a6), d0
0a3e: 4cee1cf8fe96         movem.l    -$16a(a6), d3-d7/a2-a4
0a44: 4e5e                 unlk       a6
0a46: 4e75                 rts        
0a48: 4e56fff4             link.w     a6, #$fff4
0a4c: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0a50: 286e0008             movea.l    $8(a6), a4
0a54: 266e000c             movea.l    $c(a6), a3
0a58: 42aefff6             clr.l      -$a(a6)
0a5c: 7e01                 moveq      #$1, d7
0a5e: 60000250             bra.w      $cb0
0a62: 2007                 move.l     d7, d0
0a64: 48c0                 ext.l      d0
0a66: e788                 lsl.l      #$3, d0
0a68: 206dd55a             movea.l    -$2aa6(a5), a0
0a6c: 4a700804             tst.w      $4(a0, d0.l)
0a70: 6700023c             beq.w      $cae
0a74: 2007                 move.l     d7, d0
0a76: 48c0                 ext.l      d0
0a78: e788                 lsl.l      #$3, d0
0a7a: 206dd55a             movea.l    -$2aa6(a5), a0
0a7e: 18300806             move.b     $6(a0, d0.l), d4
0a82: 4884                 ext.w      d4
0a84: 4a44                 tst.w      d4
0a86: 66000094             bne.w      $b1c
0a8a: 4a6e0010             tst.w      $10(a6)
0a8e: 6600021e             bne.w      $cae
0a92: 2007                 move.l     d7, d0
0a94: 48c0                 ext.l      d0
0a96: e788                 lsl.l      #$3, d0
0a98: 206dd55a             movea.l    -$2aa6(a5), a0
0a9c: 30700802             movea.w    $2(a0, d0.l), a0
0aa0: d1edd560             adda.l     -$2aa0(a5), a0
0aa4: 2d48fffa             move.l     a0, -$6(a6)
0aa8: 2448                 movea.l    a0, a2
0aaa: 6014                 bra.b      $ac0
0aac: 101a                 move.b     (a2)+, d0
0aae: 4880                 ext.w      d0
0ab0: 204d                 movea.l    a5, a0
0ab2: d0c0                 adda.w     d0, a0
0ab4: 1028a54e             move.b     -$5ab2(a0), d0
0ab8: 5328a54e             subq.b     #$1, -$5ab2(a0)
0abc: 4a00                 tst.b      d0
0abe: 6750                 beq.b      $b10
0ac0: 4a12                 tst.b      (a2)
0ac2: 66e8                 bne.b      $aac
0ac4: 200c                 move.l     a4, d0
0ac6: 6702                 beq.b      $aca
0ac8: 38c7                 move.w     d7, (a4)+
0aca: 200b                 move.l     a3, d0
0acc: 6718                 beq.b      $ae6
0ace: 2007                 move.l     d7, d0
0ad0: 48c0                 ext.l      d0
0ad2: e788                 lsl.l      #$3, d0
0ad4: 206dd55a             movea.l    -$2aa6(a5), a0
0ad8: 721c                 moveq      #$1c, d1
0ada: c3f00804             muls.w     $4(a0, d0.l), d1
0ade: 226dd564             movea.l    -$2a9c(a5), a1
0ae2: 36f1181a             move.w     $1a(a1, d1.l), (a3)+
0ae6: 2007                 move.l     d7, d0
0ae8: 48c0                 ext.l      d0
0aea: e788                 lsl.l      #$3, d0
0aec: 206dd55a             movea.l    -$2aa6(a5), a0
0af0: 721c                 moveq      #$1c, d1
0af2: c3f00804             muls.w     $4(a0, d0.l), d1
0af6: 226dd564             movea.l    -$2a9c(a5), a1
0afa: 22311818             move.l     $18(a1, d1.l), d1
0afe: d3aefff6             add.l      d1, -$a(a6)
0b02: 600c                 bra.b      $b10
0b04: 1012                 move.b     (a2), d0
0b06: 4880                 ext.w      d0
0b08: 204d                 movea.l    a5, a0
0b0a: d0c0                 adda.w     d0, a0
0b0c: 5228a54e             addq.b     #$1, -$5ab2(a0)
0b10: 538a                 subq.l     #$1, a2
0b12: b5eefffa             cmpa.l     -$6(a6), a2
0b16: 64ec                 bcc.b      $b04
0b18: 60000194             bra.w      $cae
0b1c: 2007                 move.l     d7, d0
0b1e: 48c0                 ext.l      d0
0b20: e788                 lsl.l      #$3, d0
0b22: 206dd55a             movea.l    -$2aa6(a5), a0
0b26: 1a300807             move.b     $7(a0, d0.l), d5
0b2a: 4885                 ext.w      d5
0b2c: 4a45                 tst.w      d5
0b2e: 6f06                 ble.b      $b36
0b30: 0c450011             cmpi.w     #$11, d5
0b34: 6d04                 blt.b      $b3a
0b36: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0b3a: 4a44                 tst.w      d4
0b3c: 6f06                 ble.b      $b44
0b3e: 0c440011             cmpi.w     #$11, d4
0b42: 6d04                 blt.b      $b48
0b44: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0b48: 7011                 moveq      #$11, d0
0b4a: c1c4                 muls.w     d4, d0
0b4c: 41edbcfe             lea.l      -$4302(a5), a0
0b50: d088                 add.l      a0, d0
0b52: 3045                 movea.w    d5, a0
0b54: 10300800             move.b     (a0, d0.l), d0
0b58: 4880                 ext.w      d0
0b5a: 3d40fff4             move.w     d0, -$c(a6)
0b5e: 4a40                 tst.w      d0
0b60: 6700014c             beq.w      $cae
0b64: 3f2efff4             move.w     -$c(a6), -(a7)
0b68: 2007                 move.l     d7, d0
0b6a: 48c0                 ext.l      d0
0b6c: e788                 lsl.l      #$3, d0
0b6e: 206dd55a             movea.l    -$2aa6(a5), a0
0b72: 30700802             movea.w    $2(a0, d0.l), a0
0b76: d1edd560             adda.l     -$2aa0(a5), a0
0b7a: 2f08                 move.l     a0, -(a7)
0b7c: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
0b80: 4a80                 tst.l      d0
0b82: 5c8f                 addq.l     #$6, a7
0b84: 67000128             beq.w      $cae
0b88: 3c07                 move.w     d7, d6
0b8a: 603a                 bra.b      $bc6
0b8c: 2006                 move.l     d6, d0
0b8e: 48c0                 ext.l      d0
0b90: e788                 lsl.l      #$3, d0
0b92: 206dd55a             movea.l    -$2aa6(a5), a0
0b96: 10300806             move.b     $6(a0, d0.l), d0
0b9a: 4880                 ext.w      d0
0b9c: d044                 add.w      d4, d0
0b9e: 3d40fffe             move.w     d0, -$2(a6)
0ba2: 2206                 move.l     d6, d1
0ba4: 48c1                 ext.l      d1
0ba6: e789                 lsl.l      #$3, d1
0ba8: 12301807             move.b     $7(a0, d1.l), d1
0bac: 4881                 ext.w      d1
0bae: d245                 add.w      d5, d1
0bb0: 3d41fff4             move.w     d1, -$c(a6)
0bb4: c1fc0011             muls.w     #$11, d0
0bb8: 43edbcfe             lea.l      -$4302(a5), a1
0bbc: d089                 add.l      a1, d0
0bbe: 3241                 movea.w    d1, a1
0bc0: 4a310800             tst.b      (a1, d0.l)
0bc4: 6610                 bne.b      $bd6
0bc6: 2006                 move.l     d6, d0
0bc8: 48c0                 ext.l      d0
0bca: e788                 lsl.l      #$3, d0
0bcc: d0add55a             add.l      -$2aa6(a5), d0
0bd0: 2040                 movea.l    d0, a0
0bd2: 3c10                 move.w     (a0), d6
0bd4: 66b6                 bne.b      $b8c
0bd6: 4a46                 tst.w      d6
0bd8: 660000d4             bne.w      $cae
0bdc: 2007                 move.l     d7, d0
0bde: 48c0                 ext.l      d0
0be0: e788                 lsl.l      #$3, d0
0be2: 206dd55a             movea.l    -$2aa6(a5), a0
0be6: 721c                 moveq      #$1c, d1
0be8: c3f00804             muls.w     $4(a0, d0.l), d1
0bec: 226dd564             movea.l    -$2a9c(a5), a1
0bf0: 26311818             move.l     $18(a1, d1.l), d3
0bf4: 7022                 moveq      #$22, d0
0bf6: c1c4                 muls.w     d4, d0
0bf8: 41edbf1e             lea.l      -$40e2(a5), a0
0bfc: d088                 add.l      a0, d0
0bfe: 3045                 movea.w    d5, a0
0c00: d1c8                 adda.l     a0, a0
0c02: 4a700800             tst.w      (a0, d0.l)
0c06: 6658                 bne.b      $c60
0c08: 4a83                 tst.l      d3
0c0a: 6c2c                 bge.b      $c38
0c0c: 7011                 moveq      #$11, d0
0c0e: c1c4                 muls.w     d4, d0
0c10: 41edbcfe             lea.l      -$4302(a5), a0
0c14: d088                 add.l      a0, d0
0c16: 3045                 movea.w    d5, a0
0c18: 10300800             move.b     (a0, d0.l), d0
0c1c: 4880                 ext.w      d0
0c1e: 204d                 movea.l    a5, a0
0c20: d0c0                 adda.w     d0, a0
0c22: d0c0                 adda.w     d0, a0
0c24: 2243                 movea.l    d3, a1
0c26: 36289412             move.w     -$6bee(a0), d3
0c2a: d643                 add.w      d3, d3
0c2c: d2c3                 adda.w     d3, a1
0c2e: 2609                 move.l     a1, d3
0c30: 4a83                 tst.l      d3
0c32: 6f6a                 ble.b      $c9e
0c34: 7600                 moveq      #$0, d3
0c36: 6066                 bra.b      $c9e
0c38: 7011                 moveq      #$11, d0
0c3a: c1c4                 muls.w     d4, d0
0c3c: 41edbcfe             lea.l      -$4302(a5), a0
0c40: d088                 add.l      a0, d0
0c42: 3045                 movea.w    d5, a0
0c44: 10300800             move.b     (a0, d0.l), d0
0c48: 4880                 ext.w      d0
0c4a: 204d                 movea.l    a5, a0
0c4c: d0c0                 adda.w     d0, a0
0c4e: d0c0                 adda.w     d0, a0
0c50: 30689412             movea.w    -$6bee(a0), a0
0c54: d1c8                 adda.l     a0, a0
0c56: 9688                 sub.l      a0, d3
0c58: 4a83                 tst.l      d3
0c5a: 6c42                 bge.b      $c9e
0c5c: 7600                 moveq      #$0, d3
0c5e: 603e                 bra.b      $c9e
0c60: 7011                 moveq      #$11, d0
0c62: c1c4                 muls.w     d4, d0
0c64: 41edbcfe             lea.l      -$4302(a5), a0
0c68: d088                 add.l      a0, d0
0c6a: 3045                 movea.w    d5, a0
0c6c: 0c3000710800         cmpi.b     #$71, (a0, d0.l)
0c72: 662a                 bne.b      $c9e
0c74: 2007                 move.l     d7, d0
0c76: 48c0                 ext.l      d0
0c78: e788                 lsl.l      #$3, d0
0c7a: 206dd55a             movea.l    -$2aa6(a5), a0
0c7e: 30700802             movea.w    $2(a0, d0.l), a0
0c82: d1edd560             adda.l     -$2aa0(a5), a0
0c86: 2f08                 move.l     a0, -(a7)
0c88: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
0c8c: 5380                 subq.l     #$1, d0
0c8e: 588f                 addq.l     #$4, a7
0c90: 630c                 bls.b      $c9e
0c92: 48780002             pea.l      $2.w
0c96: 2f03                 move.l     d3, -(a7)
0c98: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0c9c: 2600                 move.l     d0, d3
0c9e: 200c                 move.l     a4, d0
0ca0: 6702                 beq.b      $ca4
0ca2: 38c7                 move.w     d7, (a4)+
0ca4: 200b                 move.l     a3, d0
0ca6: 6702                 beq.b      $caa
0ca8: 36c3                 move.w     d3, (a3)+
0caa: d7aefff6             add.l      d3, -$a(a6)
0cae: 5247                 addq.w     #$1, d7
0cb0: be6dd55e             cmp.w      -$2aa2(a5), d7
0cb4: 6d00fdac             blt.w      $a62
0cb8: 200c                 move.l     a4, d0
0cba: 6702                 beq.b      $cbe
0cbc: 4254                 clr.w      (a4)
0cbe: 200b                 move.l     a3, d0
0cc0: 6702                 beq.b      $cc4
0cc2: 4253                 clr.w      (a3)
0cc4: 202efff6             move.l     -$a(a6), d0
0cc8: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0ccc: 4e5e                 unlk       a6
0cce: 4e75                 rts        
