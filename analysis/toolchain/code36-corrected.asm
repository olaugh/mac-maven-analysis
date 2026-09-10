0004: 4e560000             link.w     a6, #$0
0008: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
000c: 286e0008             movea.l    $8(a6), a4
0010: 0cac000013880010     cmpi.l     #$1388, $10(a4)
0018: 6f0a                 ble.b      $24
001a: 102da58d             move.b     -$5a73(a5), d0
001e: b02dcec3             cmp.b      -$313d(a5), d0
0022: 6606                 bne.b      $2a
0024: 7a00                 moveq      #$0, d5
0026: 60000102             bra.w      $12a
002a: 4aadf8e4             tst.l      -$71c(a5)
002e: 670000aa             beq.w      $da
0032: 7a00                 moveq      #$0, d5
0034: 264c                 movea.l    a4, a3
0036: 102c0021             move.b     $21(a4), d0
003a: 4880                 ext.w      d0
003c: 122c0020             move.b     $20(a4), d1
0040: 4881                 ext.w      d1
0042: c3fc0011             muls.w     #$11, d1
0046: 45edbcfe             lea.l      -$4302(a5), a2
004a: d28a                 add.l      a2, d1
004c: 3440                 movea.w    d0, a2
004e: d28a                 add.l      a2, d1
0050: 2441                 movea.l    d1, a2
0052: 607a                 bra.b      $ce
0054: 4a12                 tst.b      (a2)
0056: 6672                 bne.b      $ca
0058: 204d                 movea.l    a5, a0
005a: d0c7                 adda.w     d7, a0
005c: d0c7                 adda.w     d7, a0
005e: 0c6803209412         cmpi.w     #$320, -$6bee(a0)
0064: 6c64                 bge.b      $ca
0066: 102dcec3             move.b     -$313d(a5), d0
006a: 4880                 ext.w      d0
006c: 204d                 movea.l    a5, a0
006e: d0c0                 adda.w     d0, a0
0070: d0c0                 adda.w     d0, a0
0072: 2007                 move.l     d7, d0
0074: 48c0                 ext.l      d0
0076: e988                 lsl.l      #$4, d0
0078: 224d                 movea.l    a5, a1
007a: d2c7                 adda.w     d7, a1
007c: 1229ce84             move.b     -$317c(a1), d1
0080: 4881                 ext.w      d1
0082: 43edb3f2             lea.l      -$4c0e(a5), a1
0086: d089                 add.l      a1, d0
0088: 3241                 movea.w    d1, a1
008a: d3c9                 adda.l     a1, a1
008c: 30310800             move.w     (a1, d0.l), d0
0090: 4640                 not.w      d0
0092: 806c001e             or.w       $1e(a4), d0
0096: c068b7e4             and.w      -$481c(a0), d0
009a: 3800                 move.w     d0, d4
009c: 7000                 moveq      #$0, d0
009e: 3004                 move.w     d4, d0
00a0: d0adf8e4             add.l      -$71c(a5), d0
00a4: 2040                 movea.l    d0, a0
00a6: 1010                 move.b     (a0), d0
00a8: 4880                 ext.w      d0
00aa: b06e000c             cmp.w      $c(a6), d0
00ae: 671a                 beq.b      $ca
00b0: 204d                 movea.l    a5, a0
00b2: d0c7                 adda.w     d7, a0
00b4: 1028ce84             move.b     -$317c(a0), d0
00b8: 4880                 ext.w      d0
00ba: da40                 add.w      d0, d5
00bc: 7000                 moveq      #$0, d0
00be: 3004                 move.w     d4, d0
00c0: d0adf8e4             add.l      -$71c(a5), d0
00c4: 2040                 movea.l    d0, a0
00c6: 10ae000d             move.b     $d(a6), (a0)
00ca: 528b                 addq.l     #$1, a3
00cc: 528a                 addq.l     #$1, a2
00ce: 1e13                 move.b     (a3), d7
00d0: 4887                 ext.w      d7
00d2: 4a47                 tst.w      d7
00d4: 6600ff7e             bne.w      $54
00d8: 6050                 bra.b      $12a
00da: 0c6d0007b1d6         cmpi.w     #$7, -$4e2a(a5)
00e0: 6746                 beq.b      $128
00e2: 302df7d6             move.w     -$82a(a5), d0
00e6: 204d                 movea.l    a5, a0
00e8: d0c0                 adda.w     d0, a0
00ea: 1228ce84             move.b     -$317c(a0), d1
00ee: 4881                 ext.w      d1
00f0: 342df7da             move.w     -$826(a5), d2
00f4: 204d                 movea.l    a5, a0
00f6: d0c2                 adda.w     d2, a0
00f8: 1028ce84             move.b     -$317c(a0), d0
00fc: 4880                 ext.w      d0
00fe: 342df7d4             move.w     -$82c(a5), d2
0102: 204d                 movea.l    a5, a0
0104: d0c2                 adda.w     d2, a0
0106: 1428ce84             move.b     -$317c(a0), d2
010a: 4882                 ext.w      d2
010c: 306df7d8             movea.w    -$828(a5), a0
0110: 41e8ce84             lea.l      -$317c(a0), a0
0114: d1cd                 adda.l     a5, a0
0116: 1610                 move.b     (a0), d3
0118: 4883                 ext.w      d3
011a: 3a2db1d6             move.w     -$4e2a(a5), d5
011e: 9a43                 sub.w      d3, d5
0120: 9a42                 sub.w      d2, d5
0122: 9a40                 sub.w      d0, d5
0124: 9a41                 sub.w      d1, d5
0126: 6002                 bra.b      $12a
0128: 7a07                 moveq      #$7, d5
012a: 264c                 movea.l    a4, a3
012c: 4280                 clr.l      d0
012e: 4281                 clr.l      d1
0130: 4287                 clr.l      d7
0132: 41eda54e             lea.l      -$5ab2(a5), a0
0136: 43edce84             lea.l      -$317c(a5), a1
013a: 45ed9a58             lea.l      -$65a8(a5), a2
013e: 1028003f             move.b     $3f(a0), d0
0142: 1229003f             move.b     $3f(a1), d1
0146: e948                 lsl.w      #$4, d0
0148: d5c0                 adda.l     d0, a2
014a: d241                 add.w      d1, d1
014c: 3c321000             move.w     (a2, d1.w), d6
0150: 1e1b                 move.b     (a3)+, d7
0152: 12317000             move.b     (a1, d7.w), d1
0156: 671c                 beq.b      $174
0158: 42317000             clr.b      (a1, d7.w)
015c: 10307000             move.b     (a0, d7.w), d0
0160: b200                 cmp.b      d0, d1
0162: 6710                 beq.b      $174
0164: 4880                 ext.w      d0
0166: e948                 lsl.w      #$4, d0
0168: 45ed9a58             lea.l      -$65a8(a5), a2
016c: d5c0                 adda.l     d0, a2
016e: d241                 add.w      d1, d1
0170: ccf21000             mulu.w     (a2, d1.w), d6
0174: 1e1b                 move.b     (a3)+, d7
0176: 66da                 bne.b      $152
0178: 4a46                 tst.w      d6
017a: 6604                 bne.b      $180
017c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0180: 3005                 move.w     d5, d0
0182: d046                 add.w      d6, d0
0184: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0188: 4e5e                 unlk       a6
018a: 4e75                 rts        
018c: 4e560000             link.w     a6, #$0
0190: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0194: 266e0008             movea.l    $8(a6), a3
0198: 0c6d0007b1d6         cmpi.w     #$7, -$4e2a(a5)
019e: 6e000332             bgt.w      $4d2
01a2: 49eb0010             lea.l      $10(a3), a4
01a6: 2e2df87c             move.l     -$784(a5), d7
01aa: de94                 add.l      (a4), d7
01ac: 70ff                 moveq      #$ff, d0
01ae: d06dcf04             add.w      -$30fc(a5), d0
01b2: c1fc0042             muls.w     #$42, d0
01b6: 206dcf24             movea.l    -$30dc(a5), a0
01ba: beb00804             cmp.l      $4(a0, d0.l), d7
01be: 6f000312             ble.w      $4d2
01c2: 3c2df7d2             move.w     -$82e(a5), d6
01c6: 9c6db1d6             sub.w      -$4e2a(a5), d6
01ca: 3a06                 move.w     d6, d5
01cc: 5745                 subq.w     #$3, d5
01ce: 0c450007             cmpi.w     #$7, d5
01d2: 6f04                 ble.b      $1d8
01d4: 7a07                 moveq      #$7, d5
01d6: 6006                 bra.b      $1de
01d8: 4a45                 tst.w      d5
01da: 6e02                 bgt.b      $1de
01dc: 7a01                 moveq      #$1, d5
01de: 4eba115a             jsr        $133a(pc)
01e2: 2800                 move.l     d0, d4
01e4: 302db1d6             move.w     -$4e2a(a5), d0
01e8: c1edf8e2             muls.w     -$71e(a5), d0
01ec: 3046                 movea.w    d6, a0
01ee: 2f08                 move.l     a0, -(a7)
01f0: 3045                 movea.w    d5, a0
01f2: 2f08                 move.l     a0, -(a7)
01f4: 2f04                 move.l     d4, -(a7)
01f6: 2200                 move.l     d0, d1
01f8: 4ead0042             jsr        $42(a5) ; CODE1+00ee
01fc: c141                 exg.l      d0, d1
01fe: 2f01                 move.l     d1, -(a7)
0200: 2200                 move.l     d0, d1
0202: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0206: c141                 exg.l      d0, d1
0208: d294                 add.l      (a4), d1
020a: 3040                 movea.w    d0, a0
020c: d288                 add.l      a0, d1
020e: 2e01                 move.l     d1, d7
0210: 70ff                 moveq      #$ff, d0
0212: d06dcf04             add.w      -$30fc(a5), d0
0216: c1fc0042             muls.w     #$42, d0
021a: 206dcf24             movea.l    -$30dc(a5), a0
021e: beb00804             cmp.l      $4(a0, d0.l), d7
0222: 6f0002ae             ble.w      $4d2
0226: 0c6d005acf04         cmpi.w     #$5a, -$30fc(a5)
022c: 6704                 beq.b      $232
022e: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0232: 4aadf8e4             tst.l      -$71c(a5)
0236: 670000e6             beq.w      $31e
023a: 7000                 moveq      #$0, d0
023c: 302b001e             move.w     $1e(a3), d0
0240: d0adf8e4             add.l      -$71c(a5), d0
0244: 2040                 movea.l    d0, a0
0246: 1c10                 move.b     (a0), d6
0248: 4886                 ext.w      d6
024a: 0c46ffff             cmpi.w     #$ffff, d6
024e: 670000ce             beq.w      $31e
0252: bc6dcf04             cmp.w      -$30fc(a5), d6
0256: 6c04                 bge.b      $25c
0258: 4a46                 tst.w      d6
025a: 6c04                 bge.b      $260
025c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0260: 286dcf24             movea.l    -$30dc(a5), a4
0264: 7042                 moveq      #$42, d0
0266: c1edcf04             muls.w     -$30fc(a5), d0
026a: d0adcf24             add.l      -$30dc(a5), d0
026e: b08c                 cmp.l      a4, d0
0270: 6204                 bhi.b      $276
0272: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0276: 45ec0028             lea.l      $28(a4), a2
027a: 3046                 movea.w    d6, a0
027c: b1d2                 cmpa.l     (a2), a0
027e: 66000096             bne.w      $316
0282: 102c0030             move.b     $30(a4), d0
0286: b02b0020             cmp.b      $20(a3), d0
028a: 66000092             bne.w      $31e
028e: 102c0031             move.b     $31(a4), d0
0292: b02b0021             cmp.b      $21(a3), d0
0296: 66000086             bne.w      $31e
029a: 102c003c             move.b     $3c(a4), d0
029e: 4880                 ext.w      d0
02a0: b06db1d6             cmp.w      -$4e2a(a5), d0
02a4: 6678                 bne.b      $31e
02a6: 302df7d8             move.w     -$828(a5), d0
02aa: 204d                 movea.l    a5, a0
02ac: d0c0                 adda.w     d0, a0
02ae: 122c003d             move.b     $3d(a4), d1
02b2: b228ce84             cmp.b      -$317c(a0), d1
02b6: 6666                 bne.b      $31e
02b8: 302df7d4             move.w     -$82c(a5), d0
02bc: 204d                 movea.l    a5, a0
02be: d0c0                 adda.w     d0, a0
02c0: 122c003e             move.b     $3e(a4), d1
02c4: b228ce84             cmp.b      -$317c(a0), d1
02c8: 6654                 bne.b      $31e
02ca: 302df7da             move.w     -$826(a5), d0
02ce: 204d                 movea.l    a5, a0
02d0: d0c0                 adda.w     d0, a0
02d2: 122c003f             move.b     $3f(a4), d1
02d6: b228ce84             cmp.b      -$317c(a0), d1
02da: 6642                 bne.b      $31e
02dc: 302df7d6             move.w     -$82a(a5), d0
02e0: 204d                 movea.l    a5, a0
02e2: d0c0                 adda.w     d0, a0
02e4: 122c0040             move.b     $40(a4), d1
02e8: b228ce84             cmp.b      -$317c(a0), d1
02ec: 6630                 bne.b      $31e
02ee: beac0004             cmp.l      $4(a4), d7
02f2: 6f0001de             ble.w      $4d2
02f6: 29470004             move.l     d7, $4(a4)
02fa: 41ec0010             lea.l      $10(a4), a0
02fe: 43d3                 lea.l      (a3), a1
0300: 7007                 moveq      #$7, d0
0302: 20d9                 move.l     (a1)+, (a0)+
0304: 51c8fffc             dbra       d0, $302
0308: 30d9                 move.w     (a1)+, (a0)+
030a: 3944003a             move.w     d4, $3a(a4)
030e: 3046                 movea.w    d6, a0
0310: 2488                 move.l     a0, (a2)
0312: 600001be             bra.w      $4d2
0316: 49ec0042             lea.l      $42(a4), a4
031a: 6000ff48             bra.w      $264
031e: 7600                 moveq      #$0, d3
0320: 0c6d0007b1d6         cmpi.w     #$7, -$4e2a(a5)
0326: 663a                 bne.b      $362
0328: 286df8c4             movea.l    -$73c(a5), a4
032c: 6026                 bra.b      $354
032e: 204d                 movea.l    a5, a0
0330: d0c5                 adda.w     d5, a0
0332: d0c5                 adda.w     d5, a0
0334: 224d                 movea.l    a5, a1
0336: d2c5                 adda.w     d5, a1
0338: 1029ce84             move.b     -$317c(a1), d0
033c: 4880                 ext.w      d0
033e: 224d                 movea.l    a5, a1
0340: d2c5                 adda.w     d5, a1
0342: 1229a54e             move.b     -$5ab2(a1), d1
0346: 4881                 ext.w      d1
0348: 9240                 sub.w      d0, d1
034a: c3e89412             muls.w     -$6bee(a0), d1
034e: 3041                 movea.w    d1, a0
0350: d688                 add.l      a0, d3
0352: 528c                 addq.l     #$1, a4
0354: 1a14                 move.b     (a4), d5
0356: 4885                 ext.w      d5
0358: 4a45                 tst.w      d5
035a: 66d2                 bne.b      $32e
035c: d683                 add.l      d3, d3
035e: d6ab0010             add.l      $10(a3), d3
0362: 302df7d6             move.w     -$82a(a5), d0
0366: 204d                 movea.l    a5, a0
0368: d0c0                 adda.w     d0, a0
036a: 1228ce84             move.b     -$317c(a0), d1
036e: 4881                 ext.w      d1
0370: 3f01                 move.w     d1, -(a7)
0372: 322df7da             move.w     -$826(a5), d1
0376: 204d                 movea.l    a5, a0
0378: d0c1                 adda.w     d1, a0
037a: 1428ce84             move.b     -$317c(a0), d2
037e: 4882                 ext.w      d2
0380: 3f02                 move.w     d2, -(a7)
0382: 342df7d4             move.w     -$82c(a5), d2
0386: 204d                 movea.l    a5, a0
0388: d0c2                 adda.w     d2, a0
038a: 1028ce84             move.b     -$317c(a0), d0
038e: 4880                 ext.w      d0
0390: 3f00                 move.w     d0, -(a7)
0392: 302df7d8             move.w     -$828(a5), d0
0396: 204d                 movea.l    a5, a0
0398: d0c0                 adda.w     d0, a0
039a: 1028ce84             move.b     -$317c(a0), d0
039e: 4880                 ext.w      d0
03a0: 3f00                 move.w     d0, -(a7)
03a2: 2f0b                 move.l     a3, -(a7)
03a4: 2f07                 move.l     d7, -(a7)
03a6: 2f2dcf24             move.l     -$30dc(a5), -(a7)
03aa: 4eba0fca             jsr        $1376(pc)
03ae: 2840                 movea.l    d0, a4
03b0: 200c                 move.l     a4, d0
03b2: 4fef0014             lea.l      $14(a7), a7
03b6: 6746                 beq.b      $3fe
03b8: 306c000e             movea.w    $e(a4), a0
03bc: b1c3                 cmpa.l     d3, a0
03be: 6c04                 bge.b      $3c4
03c0: 3943000e             move.w     d3, $e(a4)
03c4: 3c2c002a             move.w     $2a(a4), d6
03c8: beac0004             cmp.l      $4(a4), d7
03cc: 6614                 bne.b      $3e2
03ce: 41ec0010             lea.l      $10(a4), a0
03d2: 43d3                 lea.l      (a3), a1
03d4: 7007                 moveq      #$7, d0
03d6: 20d9                 move.l     (a1)+, (a0)+
03d8: 51c8fffc             dbra       d0, $3d6
03dc: 30d9                 move.w     (a1)+, (a0)+
03de: 3944003a             move.w     d4, $3a(a4)
03e2: 3f06                 move.w     d6, -(a7)
03e4: 2f0b                 move.l     a3, -(a7)
03e6: 4ebafc1c             jsr        $4(pc)
03ea: d16c0038             add.w      d0, $38(a4)
03ee: 302b001e             move.w     $1e(a3), d0
03f2: 4640                 not.w      d0
03f4: c16c0036             and.w      d0, $36(a4)
03f8: 5c8f                 addq.l     #$6, a7
03fa: 600000ba             bra.w      $4b6
03fe: 286dcf24             movea.l    -$30dc(a5), a4
0402: 6004                 bra.b      $408
0404: 49ec0042             lea.l      $42(a4), a4
0408: beac0004             cmp.l      $4(a4), d7
040c: 6ff6                 ble.b      $404
040e: 206dcf24             movea.l    -$30dc(a5), a0
0412: 3c28171c             move.w     $171c(a0), d6
0416: 48780042             pea.l      $42.w
041a: 48780042             pea.l      $42.w
041e: 200c                 move.l     a4, d0
0420: 9088                 sub.l      a0, d0
0422: 2f00                 move.l     d0, -(a7)
0424: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0428: 326dcf04             movea.w    -$30fc(a5), a1
042c: 5389                 subq.l     #$1, a1
042e: 93c0                 suba.l     d0, a1
0430: 2f09                 move.l     a1, -(a7)
0432: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0436: 2f00                 move.l     d0, -(a7)
0438: 2f0c                 move.l     a4, -(a7)
043a: 486c0042             pea.l      $42(a4)
043e: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0442: 3944003a             move.w     d4, $3a(a4)
0446: 29470004             move.l     d7, $4(a4)
044a: 41ec0010             lea.l      $10(a4), a0
044e: 43d3                 lea.l      (a3), a1
0450: 7007                 moveq      #$7, d0
0452: 20d9                 move.l     (a1)+, (a0)+
0454: 51c8fffc             dbra       d0, $452
0458: 30d9                 move.w     (a1)+, (a0)+
045a: 196db1d7003c         move.b     -$4e29(a5), $3c(a4)
0460: 3943000e             move.w     d3, $e(a4)
0464: 302df7d8             move.w     -$828(a5), d0
0468: 204d                 movea.l    a5, a0
046a: d0c0                 adda.w     d0, a0
046c: 1968ce84003d         move.b     -$317c(a0), $3d(a4)
0472: 302df7d4             move.w     -$82c(a5), d0
0476: 204d                 movea.l    a5, a0
0478: d0c0                 adda.w     d0, a0
047a: 1968ce84003e         move.b     -$317c(a0), $3e(a4)
0480: 302df7da             move.w     -$826(a5), d0
0484: 204d                 movea.l    a5, a0
0486: d0c0                 adda.w     d0, a0
0488: 1968ce84003f         move.b     -$317c(a0), $3f(a4)
048e: 302df7d6             move.w     -$82a(a5), d0
0492: 204d                 movea.l    a5, a0
0494: d0c0                 adda.w     d0, a0
0496: 1968ce840040         move.b     -$317c(a0), $40(a4)
049c: 302b001e             move.w     $1e(a3), d0
04a0: 4640                 not.w      d0
04a2: 39400036             move.w     d0, $36(a4)
04a6: 3e86                 move.w     d6, (a7)
04a8: 2f0b                 move.l     a3, -(a7)
04aa: 4ebafb58             jsr        $4(pc)
04ae: 39400038             move.w     d0, $38(a4)
04b2: 4fef0010             lea.l      $10(a7), a7
04b6: 4aadf8e4             tst.l      -$71c(a5)
04ba: 6716                 beq.b      $4d2
04bc: 3046                 movea.w    d6, a0
04be: 29480028             move.l     a0, $28(a4)
04c2: 2008                 move.l     a0, d0
04c4: 7200                 moveq      #$0, d1
04c6: 322b001e             move.w     $1e(a3), d1
04ca: d2adf8e4             add.l      -$71c(a5), d1
04ce: 2041                 movea.l    d1, a0
04d0: 1080                 move.b     d0, (a0)
04d2: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
04d6: 4e5e                 unlk       a6
04d8: 4e75                 rts        
04da: 4e560000             link.w     a6, #$0
04de: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
04e2: 266e0008             movea.l    $8(a6), a3
04e6: 0c6d0007b1d6         cmpi.w     #$7, -$4e2a(a5)
04ec: 6e0001e8             bgt.w      $6d6
04f0: 49eb0010             lea.l      $10(a3), a4
04f4: 2e2df87c             move.l     -$784(a5), d7
04f8: de94                 add.l      (a4), d7
04fa: 70ff                 moveq      #$ff, d0
04fc: d06dcf04             add.w      -$30fc(a5), d0
0500: c1fc0042             muls.w     #$42, d0
0504: 206dcf24             movea.l    -$30dc(a5), a0
0508: beb00804             cmp.l      $4(a0, d0.l), d7
050c: 6f0001c8             ble.w      $6d6
0510: 3c2df7d2             move.w     -$82e(a5), d6
0514: 9c6db1d6             sub.w      -$4e2a(a5), d6
0518: 3a06                 move.w     d6, d5
051a: 5745                 subq.w     #$3, d5
051c: 0c450007             cmpi.w     #$7, d5
0520: 6f04                 ble.b      $526
0522: 7a07                 moveq      #$7, d5
0524: 6006                 bra.b      $52c
0526: 4a45                 tst.w      d5
0528: 6e02                 bgt.b      $52c
052a: 7a01                 moveq      #$1, d5
052c: 4eba0e0c             jsr        $133a(pc)
0530: 2800                 move.l     d0, d4
0532: 302db1d6             move.w     -$4e2a(a5), d0
0536: c1edf8e2             muls.w     -$71e(a5), d0
053a: 3046                 movea.w    d6, a0
053c: 2f08                 move.l     a0, -(a7)
053e: 3045                 movea.w    d5, a0
0540: 2f08                 move.l     a0, -(a7)
0542: 2f04                 move.l     d4, -(a7)
0544: 2200                 move.l     d0, d1
0546: 4ead0042             jsr        $42(a5) ; CODE1+00ee
054a: c141                 exg.l      d0, d1
054c: 2f01                 move.l     d1, -(a7)
054e: 2200                 move.l     d0, d1
0550: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0554: c141                 exg.l      d0, d1
0556: d294                 add.l      (a4), d1
0558: 3040                 movea.w    d0, a0
055a: d288                 add.l      a0, d1
055c: 2e01                 move.l     d1, d7
055e: 70ff                 moveq      #$ff, d0
0560: d06dcf04             add.w      -$30fc(a5), d0
0564: c1fc0042             muls.w     #$42, d0
0568: 206dcf24             movea.l    -$30dc(a5), a0
056c: beb00804             cmp.l      $4(a0, d0.l), d7
0570: 6f000164             ble.w      $6d6
0574: 4aadf8e4             tst.l      -$71c(a5)
0578: 670000b0             beq.w      $62a
057c: 7000                 moveq      #$0, d0
057e: 302b001e             move.w     $1e(a3), d0
0582: d0adf8e4             add.l      -$71c(a5), d0
0586: 2040                 movea.l    d0, a0
0588: 1c10                 move.b     (a0), d6
058a: 4886                 ext.w      d6
058c: 0c46ffff             cmpi.w     #$ffff, d6
0590: 67000098             beq.w      $62a
0594: 302df7d8             move.w     -$828(a5), d0
0598: 204d                 movea.l    a5, a0
059a: d0c0                 adda.w     d0, a0
059c: 122a003d             move.b     $3d(a2), d1
05a0: b228ce84             cmp.b      -$317c(a0), d1
05a4: 66000084             bne.w      $62a
05a8: 302df7d4             move.w     -$82c(a5), d0
05ac: 204d                 movea.l    a5, a0
05ae: d0c0                 adda.w     d0, a0
05b0: 122a003e             move.b     $3e(a2), d1
05b4: b228ce84             cmp.b      -$317c(a0), d1
05b8: 6670                 bne.b      $62a
05ba: 302df7da             move.w     -$826(a5), d0
05be: 204d                 movea.l    a5, a0
05c0: d0c0                 adda.w     d0, a0
05c2: 122a003f             move.b     $3f(a2), d1
05c6: b228ce84             cmp.b      -$317c(a0), d1
05ca: 665e                 bne.b      $62a
05cc: 302df7d6             move.w     -$82a(a5), d0
05d0: 204d                 movea.l    a5, a0
05d2: d0c0                 adda.w     d0, a0
05d4: 122a0040             move.b     $40(a2), d1
05d8: b228ce84             cmp.b      -$317c(a0), d1
05dc: 664c                 bne.b      $62a
05de: bc6dcf04             cmp.w      -$30fc(a5), d6
05e2: 6c04                 bge.b      $5e8
05e4: 4a46                 tst.w      d6
05e6: 6c04                 bge.b      $5ec
05e8: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
05ec: 7042                 moveq      #$42, d0
05ee: c1c6                 muls.w     d6, d0
05f0: d0adcf24             add.l      -$30dc(a5), d0
05f4: 2440                 movea.l    d0, a2
05f6: 102a0030             move.b     $30(a2), d0
05fa: b02b0020             cmp.b      $20(a3), d0
05fe: 662a                 bne.b      $62a
0600: 102a0031             move.b     $31(a2), d0
0604: b02b0021             cmp.b      $21(a3), d0
0608: 6620                 bne.b      $62a
060a: 102a003c             move.b     $3c(a2), d0
060e: 4880                 ext.w      d0
0610: b06db1d6             cmp.w      -$4e2a(a5), d0
0614: 6704                 beq.b      $61a
0616: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
061a: beaa0004             cmp.l      $4(a2), d7
061e: 6f0000b6             ble.w      $6d6
0622: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0626: 600000ae             bra.w      $6d6
062a: 302df7d6             move.w     -$82a(a5), d0
062e: 204d                 movea.l    a5, a0
0630: d0c0                 adda.w     d0, a0
0632: 1228ce84             move.b     -$317c(a0), d1
0636: 4881                 ext.w      d1
0638: 3f01                 move.w     d1, -(a7)
063a: 322df7da             move.w     -$826(a5), d1
063e: 204d                 movea.l    a5, a0
0640: d0c1                 adda.w     d1, a0
0642: 1428ce84             move.b     -$317c(a0), d2
0646: 4882                 ext.w      d2
0648: 3f02                 move.w     d2, -(a7)
064a: 342df7d4             move.w     -$82c(a5), d2
064e: 204d                 movea.l    a5, a0
0650: d0c2                 adda.w     d2, a0
0652: 1028ce84             move.b     -$317c(a0), d0
0656: 4880                 ext.w      d0
0658: 3f00                 move.w     d0, -(a7)
065a: 302df7d8             move.w     -$828(a5), d0
065e: 204d                 movea.l    a5, a0
0660: d0c0                 adda.w     d0, a0
0662: 1028ce84             move.b     -$317c(a0), d0
0666: 4880                 ext.w      d0
0668: 3f00                 move.w     d0, -(a7)
066a: 2f0b                 move.l     a3, -(a7)
066c: 2f07                 move.l     d7, -(a7)
066e: 2f2dcf24             move.l     -$30dc(a5), -(a7)
0672: 4eba0d02             jsr        $1376(pc)
0676: 2440                 movea.l    d0, a2
0678: 200a                 move.l     a2, d0
067a: 4fef0014             lea.l      $14(a7), a7
067e: 6756                 beq.b      $6d6
0680: 48780042             pea.l      $42.w
0684: 200a                 move.l     a2, d0
0686: 90adcf24             sub.l      -$30dc(a5), d0
068a: 2f00                 move.l     d0, -(a7)
068c: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0690: 3f00                 move.w     d0, -(a7)
0692: 2f0b                 move.l     a3, -(a7)
0694: 4ebaf96e             jsr        $4(pc)
0698: d16a0038             add.w      d0, $38(a2)
069c: 302b001e             move.w     $1e(a3), d0
06a0: 4640                 not.w      d0
06a2: c16a0036             and.w      d0, $36(a2)
06a6: beaa0004             cmp.l      $4(a2), d7
06aa: 5c8f                 addq.l     #$6, a7
06ac: 6f04                 ble.b      $6b2
06ae: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
06b2: 4aadf8e4             tst.l      -$71c(a5)
06b6: 671e                 beq.b      $6d6
06b8: 48780042             pea.l      $42.w
06bc: 200a                 move.l     a2, d0
06be: 90adcf24             sub.l      -$30dc(a5), d0
06c2: 2f00                 move.l     d0, -(a7)
06c4: 4ead005a             jsr        $5a(a5) ; CODE1+0166
06c8: 7200                 moveq      #$0, d1
06ca: 322b001e             move.w     $1e(a3), d1
06ce: d2adf8e4             add.l      -$71c(a5), d1
06d2: 2041                 movea.l    d1, a0
06d4: 1080                 move.b     d0, (a0)
06d6: 4cdf1cf0             movem.l    (a7)+, d4-d7/a2-a4
06da: 4e5e                 unlk       a6
06dc: 4e75                 rts        
06de: 4e560000             link.w     a6, #$0
06e2: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
06e6: 266e0008             movea.l    $8(a6), a3
06ea: 0c6d0007b1d6         cmpi.w     #$7, -$4e2a(a5)
06f0: 6e000224             bgt.w      $916
06f4: 49eb0010             lea.l      $10(a3), a4
06f8: 2e2df87c             move.l     -$784(a5), d7
06fc: de94                 add.l      (a4), d7
06fe: 0c6d005acf04         cmpi.w     #$5a, -$30fc(a5)
0704: 6608                 bne.b      $70e
0706: beadf880             cmp.l      -$780(a5), d7
070a: 6f00020a             ble.w      $916
070e: 3c2df7d2             move.w     -$82e(a5), d6
0712: 9c6db1d6             sub.w      -$4e2a(a5), d6
0716: 3a06                 move.w     d6, d5
0718: 5745                 subq.w     #$3, d5
071a: 0c450007             cmpi.w     #$7, d5
071e: 6f04                 ble.b      $724
0720: 7a07                 moveq      #$7, d5
0722: 6006                 bra.b      $72a
0724: 4a45                 tst.w      d5
0726: 6e02                 bgt.b      $72a
0728: 7a01                 moveq      #$1, d5
072a: 4eba0c0e             jsr        $133a(pc)
072e: 2800                 move.l     d0, d4
0730: 302db1d6             move.w     -$4e2a(a5), d0
0734: c1edf8e2             muls.w     -$71e(a5), d0
0738: 3046                 movea.w    d6, a0
073a: 2f08                 move.l     a0, -(a7)
073c: 3045                 movea.w    d5, a0
073e: 2f08                 move.l     a0, -(a7)
0740: 2f04                 move.l     d4, -(a7)
0742: 2200                 move.l     d0, d1
0744: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0748: c141                 exg.l      d0, d1
074a: 2f01                 move.l     d1, -(a7)
074c: 2200                 move.l     d0, d1
074e: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0752: c141                 exg.l      d0, d1
0754: d294                 add.l      (a4), d1
0756: 3040                 movea.w    d0, a0
0758: d288                 add.l      a0, d1
075a: 2e01                 move.l     d1, d7
075c: 4a6dcf04             tst.w      -$30fc(a5)
0760: 660a                 bne.b      $76c
0762: 0cadf4143e00f880     cmpi.l     #$f4143e00, -$780(a5)
076a: 671c                 beq.b      $788
076c: 70ff                 moveq      #$ff, d0
076e: d06dcf04             add.w      -$30fc(a5), d0
0772: c1fc0042             muls.w     #$42, d0
0776: 206dcf24             movea.l    -$30dc(a5), a0
077a: 20300804             move.l     $4(a0, d0.l), d0
077e: b0adf880             cmp.l      -$780(a5), d0
0782: 6704                 beq.b      $788
0784: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0788: 0c6d005acf04         cmpi.w     #$5a, -$30fc(a5)
078e: 6608                 bne.b      $798
0790: beadf880             cmp.l      -$780(a5), d7
0794: 6f000180             ble.w      $916
0798: 7c00                 moveq      #$0, d6
079a: 0c6d0007b1d6         cmpi.w     #$7, -$4e2a(a5)
07a0: 6638                 bne.b      $7da
07a2: 246df8c4             movea.l    -$73c(a5), a2
07a6: 6026                 bra.b      $7ce
07a8: 204d                 movea.l    a5, a0
07aa: d0c5                 adda.w     d5, a0
07ac: d0c5                 adda.w     d5, a0
07ae: 224d                 movea.l    a5, a1
07b0: d2c5                 adda.w     d5, a1
07b2: 1029ce84             move.b     -$317c(a1), d0
07b6: 4880                 ext.w      d0
07b8: 224d                 movea.l    a5, a1
07ba: d2c5                 adda.w     d5, a1
07bc: 1229a54e             move.b     -$5ab2(a1), d1
07c0: 4881                 ext.w      d1
07c2: 9240                 sub.w      d0, d1
07c4: c3e89412             muls.w     -$6bee(a0), d1
07c8: 3041                 movea.w    d1, a0
07ca: dc88                 add.l      a0, d6
07cc: 528a                 addq.l     #$1, a2
07ce: 1a12                 move.b     (a2), d5
07d0: 4885                 ext.w      d5
07d2: 4a45                 tst.w      d5
07d4: 66d2                 bne.b      $7a8
07d6: dc86                 add.l      d6, d6
07d8: dc94                 add.l      (a4), d6
07da: 302df7d6             move.w     -$82a(a5), d0
07de: 204d                 movea.l    a5, a0
07e0: d0c0                 adda.w     d0, a0
07e2: 1228ce84             move.b     -$317c(a0), d1
07e6: 4881                 ext.w      d1
07e8: 3f01                 move.w     d1, -(a7)
07ea: 322df7da             move.w     -$826(a5), d1
07ee: 204d                 movea.l    a5, a0
07f0: d0c1                 adda.w     d1, a0
07f2: 1428ce84             move.b     -$317c(a0), d2
07f6: 4882                 ext.w      d2
07f8: 3f02                 move.w     d2, -(a7)
07fa: 342df7d4             move.w     -$82c(a5), d2
07fe: 204d                 movea.l    a5, a0
0800: d0c2                 adda.w     d2, a0
0802: 1028ce84             move.b     -$317c(a0), d0
0806: 4880                 ext.w      d0
0808: 3f00                 move.w     d0, -(a7)
080a: 302df7d8             move.w     -$828(a5), d0
080e: 204d                 movea.l    a5, a0
0810: d0c0                 adda.w     d0, a0
0812: 1028ce84             move.b     -$317c(a0), d0
0816: 4880                 ext.w      d0
0818: 3f00                 move.w     d0, -(a7)
081a: 2f0b                 move.l     a3, -(a7)
081c: 2f07                 move.l     d7, -(a7)
081e: 2f2dcf24             move.l     -$30dc(a5), -(a7)
0822: 4eba0b52             jsr        $1376(pc)
0826: 2840                 movea.l    d0, a4
0828: 200c                 move.l     a4, d0
082a: 4fef0014             lea.l      $14(a7), a7
082e: 6672                 bne.b      $8a2
0830: 0c6d005acf04         cmpi.w     #$5a, -$30fc(a5)
0836: 6612                 bne.b      $84a
0838: 286dcf24             movea.l    -$30dc(a5), a4
083c: 6004                 bra.b      $842
083e: 49ec0042             lea.l      $42(a4), a4
0842: beac0004             cmp.l      $4(a4), d7
0846: 6ff6                 ble.b      $83e
0848: 6024                 bra.b      $86e
084a: 286dcf24             movea.l    -$30dc(a5), a4
084e: 7042                 moveq      #$42, d0
0850: c1edcf04             muls.w     -$30fc(a5), d0
0854: d0adcf24             add.l      -$30dc(a5), d0
0858: 2440                 movea.l    d0, a2
085a: 6004                 bra.b      $860
085c: 49ec0042             lea.l      $42(a4), a4
0860: b5cc                 cmpa.l     a4, a2
0862: 6306                 bls.b      $86a
0864: beac0004             cmp.l      $4(a4), d7
0868: 6ff2                 ble.b      $85c
086a: 526dcf04             addq.w     #$1, -$30fc(a5)
086e: 48780042             pea.l      $42.w
0872: 48780042             pea.l      $42.w
0876: 200c                 move.l     a4, d0
0878: 90adcf24             sub.l      -$30dc(a5), d0
087c: 2f00                 move.l     d0, -(a7)
087e: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0882: 306dcf04             movea.w    -$30fc(a5), a0
0886: 5388                 subq.l     #$1, a0
0888: 91c0                 suba.l     d0, a0
088a: 2f08                 move.l     a0, -(a7)
088c: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0890: 2f00                 move.l     d0, -(a7)
0892: 2f0c                 move.l     a4, -(a7)
0894: 486c0042             pea.l      $42(a4)
0898: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
089c: 4fef000c             lea.l      $c(a7), a7
08a0: 6006                 bra.b      $8a8
08a2: beac0004             cmp.l      $4(a4), d7
08a6: 6d6e                 blt.b      $916
08a8: 3944003a             move.w     d4, $3a(a4)
08ac: 3946000e             move.w     d6, $e(a4)
08b0: 29470004             move.l     d7, $4(a4)
08b4: 41ec0010             lea.l      $10(a4), a0
08b8: 43d3                 lea.l      (a3), a1
08ba: 7007                 moveq      #$7, d0
08bc: 20d9                 move.l     (a1)+, (a0)+
08be: 51c8fffc             dbra       d0, $8bc
08c2: 30d9                 move.w     (a1)+, (a0)+
08c4: 196db1d7003c         move.b     -$4e29(a5), $3c(a4)
08ca: 302df7d8             move.w     -$828(a5), d0
08ce: 204d                 movea.l    a5, a0
08d0: d0c0                 adda.w     d0, a0
08d2: 1968ce84003d         move.b     -$317c(a0), $3d(a4)
08d8: 302df7d4             move.w     -$82c(a5), d0
08dc: 204d                 movea.l    a5, a0
08de: d0c0                 adda.w     d0, a0
08e0: 1968ce84003e         move.b     -$317c(a0), $3e(a4)
08e6: 302df7da             move.w     -$826(a5), d0
08ea: 204d                 movea.l    a5, a0
08ec: d0c0                 adda.w     d0, a0
08ee: 1968ce84003f         move.b     -$317c(a0), $3f(a4)
08f4: 302df7d6             move.w     -$82a(a5), d0
08f8: 204d                 movea.l    a5, a0
08fa: d0c0                 adda.w     d0, a0
08fc: 1968ce840040         move.b     -$317c(a0), $40(a4)
0902: 70ff                 moveq      #$ff, d0
0904: d06dcf04             add.w      -$30fc(a5), d0
0908: c1fc0042             muls.w     #$42, d0
090c: 206dcf24             movea.l    -$30dc(a5), a0
0910: 2b700804f880         move.l     $4(a0, d0.l), -$780(a5)
0916: 4cdf1cf0             movem.l    (a7)+, d4-d7/a2-a4
091a: 4e5e                 unlk       a6
091c: 4e75                 rts        
091e: 4e56ffe8             link.w     a6, #$ffe8
0922: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0926: 286e0008             movea.l    $8(a6), a4
092a: 266e000c             movea.l    $c(a6), a3
092e: 42ac0014             clr.l      $14(a4)
0932: 4a2c0020             tst.b      $20(a4)
0936: 66000310             bne.w      $c48
093a: 204d                 movea.l    a5, a0
093c: 302c001e             move.w     $1e(a4), d0
0940: d0c0                 adda.w     d0, a0
0942: d0c0                 adda.w     d0, a0
0944: 3d68bbf4fff6         move.w     -$440c(a0), -$a(a6)
094a: 3c2efff6             move.w     -$a(a6), d6
094e: 48c6                 ext.l      d6
0950: 2d6b0020fff2         move.l     $20(a3), -$e(a6)
0956: 9caefff2             sub.l      -$e(a6), d6
095a: 9cab0024             sub.l      $24(a3), d6
095e: 182b003c             move.b     $3c(a3), d4
0962: 4884                 ext.w      d4
0964: b86df8cc             cmp.w      -$734(a5), d4
0968: 6f06                 ble.b      $970
096a: 302df8cc             move.w     -$734(a5), d0
096e: 6002                 bra.b      $972
0970: 3004                 move.w     d4, d0
0972: 3a00                 move.w     d0, d5
0974: 9b6df8cc             sub.w      d5, -$734(a5)
0978: 102b003c             move.b     $3c(a3), d0
097c: 4880                 ext.w      d0
097e: 9045                 sub.w      d5, d0
0980: 3d40fffa             move.w     d0, -$6(a6)
0984: 916df8ca             sub.w      d0, -$736(a5)
0988: 7800                 moveq      #$0, d4
098a: 244c                 movea.l    a4, a2
098c: 1612                 move.b     (a2), d3
098e: 4a03                 tst.b      d3
0990: 6730                 beq.b      $9c2
0992: 0c030071             cmpi.b     #$71, d3
0996: 6726                 beq.b      $9be
0998: b62a0001             cmp.b      $1(a2), d3
099c: 6720                 beq.b      $9be
099e: 1003                 move.b     d3, d0
09a0: 4880                 ext.w      d0
09a2: 204d                 movea.l    a5, a0
09a4: d0c0                 adda.w     d0, a0
09a6: 1028ce84             move.b     -$317c(a0), d0
09aa: 4880                 ext.w      d0
09ac: 1203                 move.b     d3, d1
09ae: 4881                 ext.w      d1
09b0: 204d                 movea.l    a5, a0
09b2: d0c1                 adda.w     d1, a0
09b4: d0c1                 adda.w     d1, a0
09b6: c1e8f778             muls.w     -$888(a0), d0
09ba: 3040                 movea.w    d0, a0
09bc: d888                 add.l      a0, d4
09be: 528a                 addq.l     #$1, a2
09c0: 60ca                 bra.b      $98c
09c2: 362b003a             move.w     $3a(a3), d3
09c6: 48c3                 ext.l      d3
09c8: 4a2b003e             tst.b      $3e(a3)
09cc: 660c                 bne.b      $9da
09ce: 4a6df8ce             tst.w      -$732(a5)
09d2: 6706                 beq.b      $9da
09d4: 306df85a             movea.w    -$7a6(a5), a0
09d8: 9688                 sub.l      a0, d3
09da: 102b003c             move.b     $3c(a3), d0
09de: 4880                 ext.w      d0
09e0: 322df7d2             move.w     -$82e(a5), d1
09e4: 9240                 sub.w      d0, d1
09e6: 3d41ffee             move.w     d1, -$12(a6)
09ea: 48c1                 ext.l      d1
09ec: 2e01                 move.l     d1, d7
09ee: 2f07                 move.l     d7, -(a7)
09f0: 306df8ca             movea.w    -$736(a5), a0
09f4: 2f08                 move.l     a0, -(a7)
09f6: 2f03                 move.l     d3, -(a7)
09f8: 4ead0042             jsr        $42(a5) ; CODE1+00ee
09fc: 2f00                 move.l     d0, -(a7)
09fe: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0a02: 306df7d2             movea.w    -$82e(a5), a0
0a06: 4868fff9             pea.l      -$7(a0)
0a0a: 3045                 movea.w    d5, a0
0a0c: 2f08                 move.l     a0, -(a7)
0a0e: 2f07                 move.l     d7, -(a7)
0a10: 306db1d6             movea.w    -$4e2a(a5), a0
0a14: 2f08                 move.l     a0, -(a7)
0a16: 2f03                 move.l     d3, -(a7)
0a18: 2200                 move.l     d0, d1
0a1a: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0a1e: c141                 exg.l      d0, d1
0a20: 2f01                 move.l     d1, -(a7)
0a22: 2200                 move.l     d0, d1
0a24: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0a28: c141                 exg.l      d0, d1
0a2a: 2404                 move.l     d4, d2
0a2c: 9481                 sub.l      d1, d2
0a2e: 2f02                 move.l     d2, -(a7)
0a30: 2200                 move.l     d0, d1
0a32: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0a36: c141                 exg.l      d0, d1
0a38: 2f01                 move.l     d1, -(a7)
0a3a: 2200                 move.l     d0, d1
0a3c: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0a40: c141                 exg.l      d0, d1
0a42: d081                 add.l      d1, d0
0a44: 9c80                 sub.l      d0, d6
0a46: 4a2dcef5             tst.b      -$310b(a5)
0a4a: 6752                 beq.b      $a9e
0a4c: 4a6df8cc             tst.w      -$734(a5)
0a50: 6726                 beq.b      $a78
0a52: 302effee             move.w     -$12(a6), d0
0a56: 9045                 sub.w      d5, d0
0a58: 322df8cc             move.w     -$734(a5), d1
0a5c: 204d                 movea.l    a5, a0
0a5e: d0c1                 adda.w     d1, a0
0a60: d0c1                 adda.w     d1, a0
0a62: c1e89eec             muls.w     -$6114(a0), d0
0a66: 204d                 movea.l    a5, a0
0a68: d0c1                 adda.w     d1, a0
0a6a: d0c1                 adda.w     d1, a0
0a6c: 38289f14             move.w     -$60ec(a0), d4
0a70: c9c5                 muls.w     d5, d4
0a72: d840                 add.w      d0, d4
0a74: 48c4                 ext.l      d4
0a76: 6014                 bra.b      $a8c
0a78: 302effee             move.w     -$12(a6), d0
0a7c: 9045                 sub.w      d5, d0
0a7e: c1ed9cea             muls.w     -$6316(a5), d0
0a82: 382d9dea             move.w     -$6216(a5), d4
0a86: c9c5                 muls.w     d5, d4
0a88: d840                 add.w      d0, d4
0a8a: 48c4                 ext.l      d4
0a8c: 306effee             movea.w    -$12(a6), a0
0a90: 2f08                 move.l     a0, -(a7)
0a92: 2f04                 move.l     d4, -(a7)
0a94: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0a98: dc80                 add.l      d0, d6
0a9a: 6000019c             bra.w      $c38
0a9e: 4a6df8ce             tst.w      -$732(a5)
0aa2: 67000168             beq.w      $c0c
0aa6: 4a2b003e             tst.b      $3e(a3)
0aaa: 66000160             bne.w      $c0c
0aae: 0c6d000df7d2         cmpi.w     #$d, -$82e(a5)
0ab4: 6f000104             ble.w      $bba
0ab8: 3c2efff6             move.w     -$a(a6), d6
0abc: 48c6                 ext.l      d6
0abe: 202b0020             move.l     $20(a3), d0
0ac2: 4480                 neg.l      d0
0ac4: 2d40fff6             move.l     d0, -$a(a6)
0ac8: 322df8cc             move.w     -$734(a5), d1
0acc: 204d                 movea.l    a5, a0
0ace: d0c1                 adda.w     d1, a0
0ad0: d0c1                 adda.w     d1, a0
0ad2: 30689f00             movea.w    -$6100(a0), a0
0ad6: d088                 add.l      a0, d0
0ad8: 2800                 move.l     d0, d4
0ada: 102da5c3             move.b     -$5a3d(a5), d0
0ade: b02dcef9             cmp.b      -$3107(a5), d0
0ae2: 6706                 beq.b      $aea
0ae4: 306df86e             movea.w    -$792(a5), a0
0ae8: d888                 add.l      a0, d4
0aea: 48780007             pea.l      $7.w
0aee: 2f03                 move.l     d3, -(a7)
0af0: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0af4: 2d40ffee             move.l     d0, -$12(a6)
0af8: 322df7d2             move.w     -$82e(a5), d1
0afc: d26db1d6             add.w      -$4e2a(a5), d1
0b00: 5341                 subq.w     #$1, d1
0b02: 3d41ffec             move.w     d1, -$14(a6)
0b06: 3041                 movea.w    d1, a0
0b08: 2f08                 move.l     a0, -(a7)
0b0a: 2f00                 move.l     d0, -(a7)
0b0c: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0b10: 2d40ffee             move.l     d0, -$12(a6)
0b14: 9880                 sub.l      d0, d4
0b16: 306db1d6             movea.w    -$4e2a(a5), a0
0b1a: 2f08                 move.l     a0, -(a7)
0b1c: 2f04                 move.l     d4, -(a7)
0b1e: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0b22: 2800                 move.l     d0, d4
0b24: 302df85a             move.w     -$7a6(a5), d0
0b28: 48c0                 ext.l      d0
0b2a: 81edf7d2             divs.w     -$82e(a5), d0
0b2e: 3040                 movea.w    d0, a0
0b30: 2e2effee             move.l     -$12(a6), d7
0b34: 9e88                 sub.l      a0, d7
0b36: 2d6efff2ffe8         move.l     -$e(a6), -$18(a6)
0b3c: 3041                 movea.w    d1, a0
0b3e: 2f08                 move.l     a0, -(a7)
0b40: 48780006             pea.l      $6.w
0b44: 2f03                 move.l     d3, -(a7)
0b46: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0b4a: 2f00                 move.l     d0, -(a7)
0b4c: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0b50: d1aeffe8             add.l      d0, -$18(a6)
0b54: 302df8cc             move.w     -$734(a5), d0
0b58: 204d                 movea.l    a5, a0
0b5a: d0c0                 adda.w     d0, a0
0b5c: d0c0                 adda.w     d0, a0
0b5e: 3d689f14fff2         move.w     -$60ec(a0), -$e(a6)
0b64: 342efff2             move.w     -$e(a6), d2
0b68: 48c2                 ext.l      d2
0b6a: 95aeffe8             sub.l      d2, -$18(a6)
0b6e: beaeffe8             cmp.l      -$18(a6), d7
0b72: 6c06                 bge.b      $b7a
0b74: 202effe8             move.l     -$18(a6), d0
0b78: 6002                 bra.b      $b7c
0b7a: 2007                 move.l     d7, d0
0b7c: 7207                 moveq      #$7, d1
0b7e: 9245                 sub.w      d5, d1
0b80: 3041                 movea.w    d1, a0
0b82: 2f08                 move.l     a0, -(a7)
0b84: 2f00                 move.l     d0, -(a7)
0b86: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0b8a: 9880                 sub.l      d0, d4
0b8c: 3045                 movea.w    d5, a0
0b8e: 2f08                 move.l     a0, -(a7)
0b90: 202efff6             move.l     -$a(a6), d0
0b94: 90aeffee             sub.l      -$12(a6), d0
0b98: 306efff2             movea.w    -$e(a6), a0
0b9c: 48700800             pea.l      (a0, d0.l)
0ba0: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0ba4: d880                 add.l      d0, d4
0ba6: 306db1d6             movea.w    -$4e2a(a5), a0
0baa: 48680007             pea.l      $7(a0)
0bae: 2f04                 move.l     d4, -(a7)
0bb0: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0bb4: dc80                 add.l      d0, d6
0bb6: 60000080             bra.w      $c38
0bba: 302df8cc             move.w     -$734(a5), d0
0bbe: 204d                 movea.l    a5, a0
0bc0: d0c0                 adda.w     d0, a0
0bc2: d0c0                 adda.w     d0, a0
0bc4: 38289f00             move.w     -$6100(a0), d4
0bc8: 48c4                 ext.l      d4
0bca: 122da5c3             move.b     -$5a3d(a5), d1
0bce: b22dcef9             cmp.b      -$3107(a5), d1
0bd2: 6706                 beq.b      $bda
0bd4: 306df86e             movea.w    -$792(a5), a0
0bd8: d888                 add.l      a0, d4
0bda: 306db1d6             movea.w    -$4e2a(a5), a0
0bde: 2f08                 move.l     a0, -(a7)
0be0: 2f04                 move.l     d4, -(a7)
0be2: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0be6: 2800                 move.l     d0, d4
0be8: 302df8cc             move.w     -$734(a5), d0
0bec: 204d                 movea.l    a5, a0
0bee: d0c0                 adda.w     d0, a0
0bf0: d0c0                 adda.w     d0, a0
0bf2: 7207                 moveq      #$7, d1
0bf4: c3e89f14             muls.w     -$60ec(a0), d1
0bf8: d881                 add.l      d1, d4
0bfa: 306db1d6             movea.w    -$4e2a(a5), a0
0bfe: 48680007             pea.l      $7(a0)
0c02: 2f04                 move.l     d4, -(a7)
0c04: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0c08: dc80                 add.l      d0, d6
0c0a: 602c                 bra.b      $c38
0c0c: 102da5bf             move.b     -$5a41(a5), d0
0c10: b02dcef5             cmp.b      -$310b(a5), d0
0c14: 6712                 beq.b      $c28
0c16: 302df8cc             move.w     -$734(a5), d0
0c1a: 204d                 movea.l    a5, a0
0c1c: d0c0                 adda.w     d0, a0
0c1e: d0c0                 adda.w     d0, a0
0c20: 30689f00             movea.w    -$6100(a0), a0
0c24: dc88                 add.l      a0, d6
0c26: 6010                 bra.b      $c38
0c28: 302df8cc             move.w     -$734(a5), d0
0c2c: 204d                 movea.l    a5, a0
0c2e: d0c0                 adda.w     d0, a0
0c30: d0c0                 adda.w     d0, a0
0c32: 30689eec             movea.w    -$6114(a0), a0
0c36: dc88                 add.l      a0, d6
0c38: 302efffa             move.w     -$6(a6), d0
0c3c: d16df8ca             add.w      d0, -$736(a5)
0c40: db6df8cc             add.w      d5, -$734(a5)
0c44: 600004ea             bra.w      $1130
0c48: 0c2b0007003c         cmpi.b     #$7, $3c(a3)
0c4e: 6634                 bne.b      $c84
0c50: 70f9                 moveq      #$f9, d0
0c52: d06df7d2             add.w      -$82e(a5), d0
0c56: b06db1d6             cmp.w      -$4e2a(a5), d0
0c5a: 6e28                 bgt.b      $c84
0c5c: 346c001e             movea.w    $1e(a4), a2
0c60: d5ca                 adda.l     a2, a2
0c62: 41edbbf4             lea.l      -$440c(a5), a0
0c66: d1ca                 adda.l     a2, a0
0c68: 3c10                 move.w     (a0), d6
0c6a: ee46                 asr.w      #$7, d6
0c6c: 48c6                 ext.l      d6
0c6e: 41edcbfa             lea.l      -$3406(a5), a0
0c72: d1ca                 adda.l     a2, a0
0c74: 3010                 move.w     (a0), d0
0c76: d040                 add.w      d0, d0
0c78: 306b000e             movea.w    $e(a3), a0
0c7c: d0c0                 adda.w     d0, a0
0c7e: 9c88                 sub.l      a0, d6
0c80: 600004ae             bra.w      $1130
0c84: 204d                 movea.l    a5, a0
0c86: 302c001e             move.w     $1e(a4), d0
0c8a: d0c0                 adda.w     d0, a0
0c8c: d0c0                 adda.w     d0, a0
0c8e: 3c28bbf4             move.w     -$440c(a0), d6
0c92: 48c6                 ext.l      d6
0c94: 282b0024             move.l     $24(a3), d4
0c98: 4a84                 tst.l      d4
0c9a: 6708                 beq.b      $ca4
0c9c: 4a6da43e             tst.w      -$5bc2(a5)
0ca0: 6602                 bne.b      $ca4
0ca2: 9c84                 sub.l      d4, d6
0ca4: 9cab0020             sub.l      $20(a3), d6
0ca8: 302db1d6             move.w     -$4e2a(a5), d0
0cac: b06df8cc             cmp.w      -$734(a5), d0
0cb0: 6f06                 ble.b      $cb8
0cb2: 302df8cc             move.w     -$734(a5), d0
0cb6: 6004                 bra.b      $cbc
0cb8: 302db1d6             move.w     -$4e2a(a5), d0
0cbc: 3600                 move.w     d0, d3
0cbe: 976df8cc             sub.w      d3, -$734(a5)
0cc2: 302db1d6             move.w     -$4e2a(a5), d0
0cc6: 9043                 sub.w      d3, d0
0cc8: 916df8c8             sub.w      d0, -$738(a5)
0ccc: 4a6df8cc             tst.w      -$734(a5)
0cd0: 6620                 bne.b      $cf2
0cd2: 102da58d             move.b     -$5a73(a5), d0
0cd6: b02dcec3             cmp.b      -$313d(a5), d0
0cda: 6710                 beq.b      $cec
0cdc: 0c6d0007f8c8         cmpi.w     #$7, -$738(a5)
0ce2: 6608                 bne.b      $cec
0ce4: 0686fffffb50         addi.l     #$fffffb50, d6
0cea: 6006                 bra.b      $cf2
0cec: 0686fffffed4         addi.l     #$fffffed4, d6
0cf2: 182b003c             move.b     $3c(a3), d4
0cf6: 4884                 ext.w      d4
0cf8: b86df8cc             cmp.w      -$734(a5), d4
0cfc: 6f06                 ble.b      $d04
0cfe: 302df8cc             move.w     -$734(a5), d0
0d02: 6002                 bra.b      $d06
0d04: 3004                 move.w     d4, d0
0d06: 3a00                 move.w     d0, d5
0d08: 9b6df8cc             sub.w      d5, -$734(a5)
0d0c: 102b003c             move.b     $3c(a3), d0
0d10: 4880                 ext.w      d0
0d12: 9045                 sub.w      d5, d0
0d14: 916df8ca             sub.w      d0, -$736(a5)
0d18: 382b003a             move.w     $3a(a3), d4
0d1c: 48c4                 ext.l      d4
0d1e: 102b003c             move.b     $3c(a3), d0
0d22: 4880                 ext.w      d0
0d24: 3e2df7d2             move.w     -$82e(a5), d7
0d28: 9e40                 sub.w      d0, d7
0d2a: 48c7                 ext.l      d7
0d2c: 4a2b003e             tst.b      $3e(a3)
0d30: 660e                 bne.b      $d40
0d32: 4a6df8ce             tst.w      -$732(a5)
0d36: 6708                 beq.b      $d40
0d38: 306df85a             movea.w    -$7a6(a5), a0
0d3c: 9888                 sub.l      a0, d4
0d3e: 5387                 subq.l     #$1, d7
0d40: 2f07                 move.l     d7, -(a7)
0d42: 306df8ca             movea.w    -$736(a5), a0
0d46: 2f08                 move.l     a0, -(a7)
0d48: 2f04                 move.l     d4, -(a7)
0d4a: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0d4e: 2f00                 move.l     d0, -(a7)
0d50: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0d54: 9c80                 sub.l      d0, d6
0d56: 4a6df8cc             tst.w      -$734(a5)
0d5a: 670001be             beq.w      $f1a
0d5e: 0c6d000af8cc         cmpi.w     #$a, -$734(a5)
0d64: 6504                 bcs.b      $d6a
0d66: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0d6a: 4a6df8ce             tst.w      -$732(a5)
0d6e: 67000178             beq.w      $ee8
0d72: 4a2b003e             tst.b      $3e(a3)
0d76: 66000170             bne.w      $ee8
0d7a: 70f3                 moveq      #$f3, d0
0d7c: d06df7d2             add.w      -$82e(a5), d0
0d80: b06db1d6             cmp.w      -$4e2a(a5), d0
0d84: 6f000112             ble.w      $e98
0d88: 204d                 movea.l    a5, a0
0d8a: 302c001e             move.w     $1e(a4), d0
0d8e: d0c0                 adda.w     d0, a0
0d90: d0c0                 adda.w     d0, a0
0d92: 3c28bbf4             move.w     -$440c(a0), d6
0d96: 48c6                 ext.l      d6
0d98: 202b0020             move.l     $20(a3), d0
0d9c: 4480                 neg.l      d0
0d9e: 2d40fff6             move.l     d0, -$a(a6)
0da2: 2d6b0020fff2         move.l     $20(a3), -$e(a6)
0da8: 322df8cc             move.w     -$734(a5), d1
0dac: 204d                 movea.l    a5, a0
0dae: d0c1                 adda.w     d1, a0
0db0: d0c1                 adda.w     d1, a0
0db2: 30689f00             movea.w    -$6100(a0), a0
0db6: d088                 add.l      a0, d0
0db8: 2800                 move.l     d0, d4
0dba: 102da5c3             move.b     -$5a3d(a5), d0
0dbe: b02dcef9             cmp.b      -$3107(a5), d0
0dc2: 6706                 beq.b      $dca
0dc4: 306df86e             movea.w    -$792(a5), a0
0dc8: d888                 add.l      a0, d4
0dca: 302b003a             move.w     $3a(a3), d0
0dce: 906df85a             sub.w      -$7a6(a5), d0
0dd2: 3d40fffa             move.w     d0, -$6(a6)
0dd6: c1fc0007             muls.w     #$7, d0
0dda: 3040                 movea.w    d0, a0
0ddc: 2d48ffee             move.l     a0, -$12(a6)
0de0: 70ff                 moveq      #$ff, d0
0de2: d06df7d2             add.w      -$82e(a5), d0
0de6: 3d40ffec             move.w     d0, -$14(a6)
0dea: 3240                 movea.w    d0, a1
0dec: 2f09                 move.l     a1, -(a7)
0dee: 2f08                 move.l     a0, -(a7)
0df0: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0df4: 2d40ffee             move.l     d0, -$12(a6)
0df8: 9880                 sub.l      d0, d4
0dfa: 3043                 movea.w    d3, a0
0dfc: 2f08                 move.l     a0, -(a7)
0dfe: 2f04                 move.l     d4, -(a7)
0e00: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0e04: 2800                 move.l     d0, d4
0e06: 302df8cc             move.w     -$734(a5), d0
0e0a: d045                 add.w      d5, d0
0e0c: 322df85a             move.w     -$7a6(a5), d1
0e10: 48c1                 ext.l      d1
0e12: 83c0                 divs.w     d0, d1
0e14: 3041                 movea.w    d1, a0
0e16: 2e2effee             move.l     -$12(a6), d7
0e1a: 9e88                 sub.l      a0, d7
0e1c: 2d6efff2ffe8         move.l     -$e(a6), -$18(a6)
0e22: 7006                 moveq      #$6, d0
0e24: c1eefffa             muls.w     -$6(a6), d0
0e28: 48c0                 ext.l      d0
0e2a: 81eeffec             divs.w     -$14(a6), d0
0e2e: 48c0                 ext.l      d0
0e30: d1aeffe8             add.l      d0, -$18(a6)
0e34: 302df8cc             move.w     -$734(a5), d0
0e38: 204d                 movea.l    a5, a0
0e3a: d0c0                 adda.w     d0, a0
0e3c: d0c0                 adda.w     d0, a0
0e3e: 3d689f14fff2         move.w     -$60ec(a0), -$e(a6)
0e44: 322efff2             move.w     -$e(a6), d1
0e48: 48c1                 ext.l      d1
0e4a: 93aeffe8             sub.l      d1, -$18(a6)
0e4e: beaeffe8             cmp.l      -$18(a6), d7
0e52: 6c06                 bge.b      $e5a
0e54: 202effe8             move.l     -$18(a6), d0
0e58: 6002                 bra.b      $e5c
0e5a: 2007                 move.l     d7, d0
0e5c: 7207                 moveq      #$7, d1
0e5e: 9245                 sub.w      d5, d1
0e60: 3041                 movea.w    d1, a0
0e62: 2f08                 move.l     a0, -(a7)
0e64: 2f00                 move.l     d0, -(a7)
0e66: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0e6a: 9880                 sub.l      d0, d4
0e6c: 3045                 movea.w    d5, a0
0e6e: 2f08                 move.l     a0, -(a7)
0e70: 202efff6             move.l     -$a(a6), d0
0e74: 90aeffee             sub.l      -$12(a6), d0
0e78: 306efff2             movea.w    -$e(a6), a0
0e7c: 48700800             pea.l      (a0, d0.l)
0e80: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0e84: d880                 add.l      d0, d4
0e86: 3043                 movea.w    d3, a0
0e88: 48680007             pea.l      $7(a0)
0e8c: 2f04                 move.l     d4, -(a7)
0e8e: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0e92: dc80                 add.l      d0, d6
0e94: 6000027c             bra.w      $1112
0e98: 302df8cc             move.w     -$734(a5), d0
0e9c: 204d                 movea.l    a5, a0
0e9e: d0c0                 adda.w     d0, a0
0ea0: d0c0                 adda.w     d0, a0
0ea2: 38289f00             move.w     -$6100(a0), d4
0ea6: 48c4                 ext.l      d4
0ea8: 122da5c3             move.b     -$5a3d(a5), d1
0eac: b22dcef9             cmp.b      -$3107(a5), d1
0eb0: 6706                 beq.b      $eb8
0eb2: 306df86e             movea.w    -$792(a5), a0
0eb6: d888                 add.l      a0, d4
0eb8: 3043                 movea.w    d3, a0
0eba: 2f08                 move.l     a0, -(a7)
0ebc: 2f04                 move.l     d4, -(a7)
0ebe: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0ec2: 2800                 move.l     d0, d4
0ec4: 302df8cc             move.w     -$734(a5), d0
0ec8: 204d                 movea.l    a5, a0
0eca: d0c0                 adda.w     d0, a0
0ecc: d0c0                 adda.w     d0, a0
0ece: 7207                 moveq      #$7, d1
0ed0: c3e89f14             muls.w     -$60ec(a0), d1
0ed4: d881                 add.l      d1, d4
0ed6: 3043                 movea.w    d3, a0
0ed8: 48680007             pea.l      $7(a0)
0edc: 2f04                 move.l     d4, -(a7)
0ede: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0ee2: dc80                 add.l      d0, d6
0ee4: 6000022c             bra.w      $1112
0ee8: 102da5bf             move.b     -$5a41(a5), d0
0eec: b02dcef5             cmp.b      -$310b(a5), d0
0ef0: 6714                 beq.b      $f06
0ef2: 302df8cc             move.w     -$734(a5), d0
0ef6: 204d                 movea.l    a5, a0
0ef8: d0c0                 adda.w     d0, a0
0efa: d0c0                 adda.w     d0, a0
0efc: 30689f00             movea.w    -$6100(a0), a0
0f00: dc88                 add.l      a0, d6
0f02: 6000020e             bra.w      $1112
0f06: 302df8cc             move.w     -$734(a5), d0
0f0a: 204d                 movea.l    a5, a0
0f0c: d0c0                 adda.w     d0, a0
0f0e: d0c0                 adda.w     d0, a0
0f10: 30689eec             movea.w    -$6114(a0), a0
0f14: dc88                 add.l      a0, d6
0f16: 600001fa             bra.w      $1112
0f1a: 4a6df8ce             tst.w      -$732(a5)
0f1e: 6700011c             beq.w      $103c
0f22: 4a2b003e             tst.b      $3e(a3)
0f26: 66000114             bne.w      $103c
0f2a: 102da5c3             move.b     -$5a3d(a5), d0
0f2e: b02dcef9             cmp.b      -$3107(a5), d0
0f32: 671c                 beq.b      $f50
0f34: 302df8c8             move.w     -$738(a5), d0
0f38: 48c0                 ext.l      d0
0f3a: e988                 lsl.l      #$4, d0
0f3c: d08d                 add.l      a5, d0
0f3e: 2040                 movea.l    d0, a0
0f40: 302df8ca             move.w     -$736(a5), d0
0f44: d0c0                 adda.w     d0, a0
0f46: d0c0                 adda.w     d0, a0
0f48: 3e289dec             move.w     -$6214(a0), d7
0f4c: 48c7                 ext.l      d7
0f4e: 6052                 bra.b      $fa2
0f50: 102da58d             move.b     -$5a73(a5), d0
0f54: b02dcec3             cmp.b      -$313d(a5), d0
0f58: 672e                 beq.b      $f88
0f5a: 302df8c8             move.w     -$738(a5), d0
0f5e: 48c0                 ext.l      d0
0f60: e988                 lsl.l      #$4, d0
0f62: d08d                 add.l      a5, d0
0f64: 2040                 movea.l    d0, a0
0f66: 302df8ca             move.w     -$736(a5), d0
0f6a: d0c0                 adda.w     d0, a0
0f6c: d0c0                 adda.w     d0, a0
0f6e: 3e289dec             move.w     -$6214(a0), d7
0f72: 48c7                 ext.l      d7
0f74: 486efffc             pea.l      -$4(a6)
0f78: 2f2d93c4             move.l     -$6c3c(a5), -(a7)
0f7c: 4ead09c2             jsr        $9c2(a5) ; CODE32+16c0
0f80: 3040                 movea.w    d0, a0
0f82: 9e88                 sub.l      a0, d7
0f84: 508f                 addq.l     #$8, a7
0f86: 601a                 bra.b      $fa2
0f88: 302df8c8             move.w     -$738(a5), d0
0f8c: 48c0                 ext.l      d0
0f8e: e988                 lsl.l      #$4, d0
0f90: d08d                 add.l      a5, d0
0f92: 2040                 movea.l    d0, a0
0f94: 302df8ca             move.w     -$736(a5), d0
0f98: d0c0                 adda.w     d0, a0
0f9a: d0c0                 adda.w     d0, a0
0f9c: 3e289cec             move.w     -$6314(a0), d7
0fa0: 48c7                 ext.l      d7
0fa2: 302df8c8             move.w     -$738(a5), d0
0fa6: 48c0                 ext.l      d0
0fa8: e988                 lsl.l      #$4, d0
0faa: d08d                 add.l      a5, d0
0fac: 2040                 movea.l    d0, a0
0fae: 302df8ca             move.w     -$736(a5), d0
0fb2: d0c0                 adda.w     d0, a0
0fb4: d0c0                 adda.w     d0, a0
0fb6: 30689d6c             movea.w    -$6294(a0), a0
0fba: 2d48ffe8             move.l     a0, -$18(a6)
0fbe: 122da58d             move.b     -$5a73(a5), d1
0fc2: b22dcec3             cmp.b      -$313d(a5), d1
0fc6: 6746                 beq.b      $100e
0fc8: 486efffc             pea.l      -$4(a6)
0fcc: 2f2d93c4             move.l     -$6c3c(a5), -(a7)
0fd0: 4ead09c2             jsr        $9c2(a5) ; CODE32+16c0
0fd4: 48c0                 ext.l      d0
0fd6: 91aeffe8             sub.l      d0, -$18(a6)
0fda: 302df8c8             move.w     -$738(a5), d0
0fde: 48c0                 ext.l      d0
0fe0: e988                 lsl.l      #$4, d0
0fe2: d08d                 add.l      a5, d0
0fe4: 2040                 movea.l    d0, a0
0fe6: 302df8ca             move.w     -$736(a5), d0
0fea: d0c0                 adda.w     d0, a0
0fec: d0c0                 adda.w     d0, a0
0fee: 32289b6c             move.w     -$6494(a0), d1
0ff2: 48c1                 ext.l      d1
0ff4: d3aeffe8             add.l      d1, -$18(a6)
0ff8: 4a6df8cc             tst.w      -$734(a5)
0ffc: 508f                 addq.l     #$8, a7
0ffe: 660e                 bne.b      $100e
1000: 0c6d0007f8c8         cmpi.w     #$7, -$738(a5)
1006: 6606                 bne.b      $100e
1008: 0686000004b0         addi.l     #$4b0, d6
100e: 3043                 movea.w    d3, a0
1010: 48680005             pea.l      $5(a0)
1014: 2f07                 move.l     d7, -(a7)
1016: 3043                 movea.w    d3, a0
1018: 2f08                 move.l     a0, -(a7)
101a: 4ead0042             jsr        $42(a5) ; CODE1+00ee
101e: 48780005             pea.l      $5.w
1022: 2f2effe8             move.l     -$18(a6), -(a7)
1026: 2200                 move.l     d0, d1
1028: 4ead0042             jsr        $42(a5) ; CODE1+00ee
102c: c141                 exg.l      d0, d1
102e: d081                 add.l      d1, d0
1030: 2f00                 move.l     d0, -(a7)
1032: 4ead005a             jsr        $5a(a5) ; CODE1+0166
1036: dc80                 add.l      d0, d6
1038: 600000d8             bra.w      $1112
103c: 102da5bf             move.b     -$5a41(a5), d0
1040: b02dcef5             cmp.b      -$310b(a5), d0
1044: 677c                 beq.b      $10c2
1046: 102da5c3             move.b     -$5a3d(a5), d0
104a: b02dcef9             cmp.b      -$3107(a5), d0
104e: 671e                 beq.b      $106e
1050: 302df8c8             move.w     -$738(a5), d0
1054: 48c0                 ext.l      d0
1056: e988                 lsl.l      #$4, d0
1058: d08d                 add.l      a5, d0
105a: 2040                 movea.l    d0, a0
105c: 302df8ca             move.w     -$736(a5), d0
1060: d0c0                 adda.w     d0, a0
1062: d0c0                 adda.w     d0, a0
1064: 30689dec             movea.w    -$6214(a0), a0
1068: dc88                 add.l      a0, d6
106a: 600000a6             bra.w      $1112
106e: 102da58d             move.b     -$5a73(a5), d0
1072: b02dcec3             cmp.b      -$313d(a5), d0
1076: 672e                 beq.b      $10a6
1078: 302df8c8             move.w     -$738(a5), d0
107c: 48c0                 ext.l      d0
107e: e988                 lsl.l      #$4, d0
1080: d08d                 add.l      a5, d0
1082: 2040                 movea.l    d0, a0
1084: 302df8ca             move.w     -$736(a5), d0
1088: d0c0                 adda.w     d0, a0
108a: d0c0                 adda.w     d0, a0
108c: 38289dec             move.w     -$6214(a0), d4
1090: 48c4                 ext.l      d4
1092: 486efffc             pea.l      -$4(a6)
1096: 2f2d93c4             move.l     -$6c3c(a5), -(a7)
109a: 4ead09c2             jsr        $9c2(a5) ; CODE32+16c0
109e: 3040                 movea.w    d0, a0
10a0: 9888                 sub.l      a0, d4
10a2: 508f                 addq.l     #$8, a7
10a4: 606c                 bra.b      $1112
10a6: 302df8c8             move.w     -$738(a5), d0
10aa: 48c0                 ext.l      d0
10ac: e988                 lsl.l      #$4, d0
10ae: d08d                 add.l      a5, d0
10b0: 2040                 movea.l    d0, a0
10b2: 302df8ca             move.w     -$736(a5), d0
10b6: d0c0                 adda.w     d0, a0
10b8: d0c0                 adda.w     d0, a0
10ba: 30689cec             movea.w    -$6314(a0), a0
10be: dc88                 add.l      a0, d6
10c0: 6050                 bra.b      $1112
10c2: 302df8c8             move.w     -$738(a5), d0
10c6: 48c0                 ext.l      d0
10c8: e988                 lsl.l      #$4, d0
10ca: d08d                 add.l      a5, d0
10cc: 2040                 movea.l    d0, a0
10ce: 302df8ca             move.w     -$736(a5), d0
10d2: d0c0                 adda.w     d0, a0
10d4: d0c0                 adda.w     d0, a0
10d6: 30689c6c             movea.w    -$6394(a0), a0
10da: dc88                 add.l      a0, d6
10dc: 122da58d             move.b     -$5a73(a5), d1
10e0: b22dcec3             cmp.b      -$313d(a5), d1
10e4: 672c                 beq.b      $1112
10e6: 486efffc             pea.l      -$4(a6)
10ea: 2f2d93c4             move.l     -$6c3c(a5), -(a7)
10ee: 4ead09c2             jsr        $9c2(a5) ; CODE32+16c0
10f2: 3040                 movea.w    d0, a0
10f4: 9c88                 sub.l      a0, d6
10f6: 302df8c8             move.w     -$738(a5), d0
10fa: 48c0                 ext.l      d0
10fc: e988                 lsl.l      #$4, d0
10fe: d08d                 add.l      a5, d0
1100: 2040                 movea.l    d0, a0
1102: 302df8ca             move.w     -$736(a5), d0
1106: d0c0                 adda.w     d0, a0
1108: d0c0                 adda.w     d0, a0
110a: 30689b6c             movea.w    -$6494(a0), a0
110e: dc88                 add.l      a0, d6
1110: 508f                 addq.l     #$8, a7
1112: 102b003c             move.b     $3c(a3), d0
1116: 4880                 ext.w      d0
1118: 9045                 sub.w      d5, d0
111a: d16df8ca             add.w      d0, -$736(a5)
111e: db6df8cc             add.w      d5, -$734(a5)
1122: 302db1d6             move.w     -$4e2a(a5), d0
1126: 9043                 sub.w      d3, d0
1128: d16df8c8             add.w      d0, -$738(a5)
112c: d76df8cc             add.w      d3, -$734(a5)
1130: 2006                 move.l     d6, d0
1132: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
1136: 4e5e                 unlk       a6
1138: 4e75                 rts        
113a: 4e56fe3a             link.w     a6, #$fe3a
113e: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
1142: 282e0008             move.l     $8(a6), d4
1146: 7e00                 moveq      #$0, d7
1148: 42aefe46             clr.l      -$1ba(a6)
114c: 42aefe42             clr.l      -$1be(a6)
1150: 4ead0ab2             jsr        $ab2(a5) ; CODE43+00aa
1154: 306df7f4             movea.w    -$80c(a5), a0
1158: d1c8                 adda.l     a0, a0
115a: 2f08                 move.l     a0, -(a7)
115c: 486efe96             pea.l      -$16a(a6)
1160: 2f2df7f0             move.l     -$810(a5), -(a7)
1164: 4ead067a             jsr        $67a(a5) ; CODE9+00c2
1168: 266df870             movea.l    -$790(a5), a3
116c: 246df874             movea.l    -$78c(a5), a2
1170: 2d6df880fe8c         move.l     -$780(a5), -$174(a6)
1176: 203c0bebc200         move.l     #$bebc200, d0
117c: 2d40fe3a             move.l     d0, -$1c6(a6)
1180: 2d40fe3e             move.l     d0, -$1c2(a6)
1184: 4fef000c             lea.l      $c(a7), a7
1188: 600000e2             bra.w      $126c
118c: 3d7c0001fe94         move.w     #$1, -$16c(a6)
1192: 200b                 move.l     a3, d0
1194: 675e                 beq.b      $11f4
1196: 200a                 move.l     a2, d0
1198: 670a                 beq.b      $11a4
119a: 202b0004             move.l     $4(a3), d0
119e: b0aa0004             cmp.l      $4(a2), d0
11a2: 6f16                 ble.b      $11ba
11a4: 284b                 movea.l    a3, a4
11a6: 2653                 movea.l    (a3), a3
11a8: 2f04                 move.l     d4, -(a7)
11aa: 2f0c                 move.l     a4, -(a7)
11ac: 4ead0aa2             jsr        $aa2(a5) ; CODE43+0004
11b0: 4a80                 tst.l      d0
11b2: 508f                 addq.l     #$8, a7
11b4: 660000b6             bne.w      $126c
11b8: 6040                 bra.b      $11fa
11ba: 102a000a             move.b     $a(a2), d0
11be: b02b000a             cmp.b      $a(a3), d0
11c2: 6616                 bne.b      $11da
11c4: 102a000b             move.b     $b(a2), d0
11c8: b02b000b             cmp.b      $b(a3), d0
11cc: 660c                 bne.b      $11da
11ce: 102a000c             move.b     $c(a2), d0
11d2: b02b000c             cmp.b      $c(a3), d0
11d6: 6602                 bne.b      $11da
11d8: 2653                 movea.l    (a3), a3
11da: 426efe94             clr.w      -$16c(a6)
11de: 202a0004             move.l     $4(a2), d0
11e2: b0adf880             cmp.l      -$780(a5), d0
11e6: 6e06                 bgt.b      $11ee
11e8: 95ca                 suba.l     a2, a2
11ea: 60000080             bra.w      $126c
11ee: 284a                 movea.l    a2, a4
11f0: 2452                 movea.l    (a2), a2
11f2: 6006                 bra.b      $11fa
11f4: 200a                 move.l     a2, d0
11f6: 66e2                 bne.b      $11da
11f8: 607a                 bra.b      $1274
11fa: 7c00                 moveq      #$0, d6
11fc: 3c2c0038             move.w     $38(a4), d6
1200: 2d6c0032fe90         move.l     $32(a4), -$170(a6)
1206: 206efe90             movea.l    -$170(a6), a0
120a: 54aefe90             addq.l     #$2, -$170(a6)
120e: 3a10                 move.w     (a0), d5
1210: 204e                 movea.l    a6, a0
1212: d0c5                 adda.w     d5, a0
1214: d0c5                 adda.w     d5, a0
1216: 3068fe96             movea.w    -$16a(a0), a0
121a: b1c6                 cmpa.l     d6, a0
121c: 6c0c                 bge.b      $122a
121e: 204e                 movea.l    a6, a0
1220: d0c5                 adda.w     d5, a0
1222: d0c5                 adda.w     d5, a0
1224: 3c28fe96             move.w     -$16a(a0), d6
1228: 48c6                 ext.l      d6
122a: 4a45                 tst.w      d5
122c: 66d8                 bne.b      $1206
122e: 4a86                 tst.l      d6
1230: 673a                 beq.b      $126c
1232: 2d6c0032fe90         move.l     $32(a4), -$170(a6)
1238: 206efe90             movea.l    -$170(a6), a0
123c: 54aefe90             addq.l     #$2, -$170(a6)
1240: 3a10                 move.w     (a0), d5
1242: 204e                 movea.l    a6, a0
1244: d0c5                 adda.w     d5, a0
1246: d0c5                 adda.w     d5, a0
1248: 9d68fe96             sub.w      d6, -$16a(a0)
124c: 4a45                 tst.w      d5
124e: 66e8                 bne.b      $1238
1250: 2f0c                 move.l     a4, -(a7)
1252: 2f04                 move.l     d4, -(a7)
1254: 4ebaf6c8             jsr        $91e(pc)
1258: 2600                 move.l     d0, d3
125a: 2d6c0004fe8c         move.l     $4(a4), -$174(a6)
1260: 2e86                 move.l     d6, (a7)
1262: 2f03                 move.l     d3, -(a7)
1264: 4ead0042             jsr        $42(a5) ; CODE1+00ee
1268: de80                 add.l      d0, d7
126a: 588f                 addq.l     #$4, a7
126c: 4a6efe96             tst.w      -$16a(a6)
1270: 6600ff1a             bne.w      $118c
1274: 4a6efe96             tst.w      -$16a(a6)
1278: 6700008c             beq.w      $1306
127c: 302db1d6             move.w     -$4e2a(a5), d0
1280: 122dcef5             move.b     -$310b(a5), d1
1284: 4881                 ext.w      d1
1286: 48c0                 ext.l      d0
1288: e788                 lsl.l      #$3, d0
128a: 41edf884             lea.l      -$77c(a5), a0
128e: d088                 add.l      a0, d0
1290: 48c1                 ext.l      d1
1292: e589                 lsl.l      #$2, d1
1294: d081                 add.l      d1, d0
1296: 2040                 movea.l    d0, a0
1298: 2610                 move.l     (a0), d3
129a: 0c830bebc200         cmpi.l     #$bebc200, d3
12a0: 6644                 bne.b      $12e6
12a2: 2f2df878             move.l     -$788(a5), -(a7)
12a6: 2f04                 move.l     d4, -(a7)
12a8: 4ebaf674             jsr        $91e(pc)
12ac: 2044                 movea.l    d4, a0
12ae: 3228001e             move.w     $1e(a0), d1
12b2: 204d                 movea.l    a5, a0
12b4: d0c1                 adda.w     d1, a0
12b6: d0c1                 adda.w     d1, a0
12b8: 3068bbf4             movea.w    -$440c(a0), a0
12bc: 2240                 movea.l    d0, a1
12be: 43e9012c             lea.l      $12c(a1), a1
12c2: 93c8                 suba.l     a0, a1
12c4: 302db1d6             move.w     -$4e2a(a5), d0
12c8: 122dcef5             move.b     -$310b(a5), d1
12cc: 4881                 ext.w      d1
12ce: 48c0                 ext.l      d0
12d0: e788                 lsl.l      #$3, d0
12d2: 41edf884             lea.l      -$77c(a5), a0
12d6: d088                 add.l      a0, d0
12d8: 48c1                 ext.l      d1
12da: e589                 lsl.l      #$2, d1
12dc: d081                 add.l      d1, d0
12de: 2040                 movea.l    d0, a0
12e0: 2089                 move.l     a1, (a0)
12e2: 2609                 move.l     a1, d3
12e4: 508f                 addq.l     #$8, a7
12e6: 2044                 movea.l    d4, a0
12e8: 3028001e             move.w     $1e(a0), d0
12ec: 204d                 movea.l    a5, a0
12ee: d0c0                 adda.w     d0, a0
12f0: d0c0                 adda.w     d0, a0
12f2: 3068bbf4             movea.w    -$440c(a0), a0
12f6: d688                 add.l      a0, d3
12f8: 306efe96             movea.w    -$16a(a6), a0
12fc: 2f08                 move.l     a0, -(a7)
12fe: 2f03                 move.l     d3, -(a7)
1300: 4ead0042             jsr        $42(a5) ; CODE1+00ee
1304: de80                 add.l      d0, d7
1306: 306df8d0             movea.w    -$730(a5), a0
130a: 2f08                 move.l     a0, -(a7)
130c: 2f07                 move.l     d7, -(a7)
130e: 4ead005a             jsr        $5a(a5) ; CODE1+0166
1312: 2e00                 move.l     d0, d7
1314: 202efe8c             move.l     -$174(a6), d0
1318: b0adf8ec             cmp.l      -$714(a5), d0
131c: 6c06                 bge.b      $1324
131e: 2b6efe8cf8ec         move.l     -$174(a6), -$714(a5)
1324: 2044                 movea.l    d4, a0
1326: 21470018             move.l     d7, $18(a0)
132a: 2f04                 move.l     d4, -(a7)
132c: 4ead0842             jsr        $842(a5) ; CODE28+0004
1330: 4cee1cf8fe1a         movem.l    -$1e6(a6), d3-d7/a2-a4
1336: 4e5e                 unlk       a6
1338: 4e75                 rts        
133a: 48e70018             movem.l    a3-a4, -(a7)
133e: 286df8c4             movea.l    -$73c(a5), a4
1342: 47edf7f6             lea.l      -$80a(a5), a3
1346: 4280                 clr.l      d0
1348: 41eda54e             lea.l      -$5ab2(a5), a0
134c: 43edce84             lea.l      -$317c(a5), a1
1350: 121c                 move.b     (a4)+, d1
1352: 4881                 ext.w      d1
1354: 4282                 clr.l      d2
1356: 14301000             move.b     (a0, d1.w), d2
135a: 94311000             sub.b      (a1, d1.w), d2
135e: 670c                 beq.b      $136c
1360: 0441003f             subi.w     #$3f, d1
1364: d241                 add.w      d1, d1
1366: c5f31000             muls.w     (a3, d1.w), d2
136a: d082                 add.l      d2, d0
136c: 121c                 move.b     (a4)+, d1
136e: 66e2                 bne.b      $1352
1370: 4cdf1800             movem.l    (a7)+, a3-a4
1374: 4e75                 rts        
1376: 4e56ffbe             link.w     a6, #$ffbe
137a: 48e70338             movem.l    d6-d7/a2-a4, -(a7)
137e: 2c2e0008             move.l     $8(a6), d6
1382: 266e0010             movea.l    $10(a6), a3
1386: 2e2e000c             move.l     $c(a6), d7
138a: 7042                 moveq      #$42, d0
138c: c1edcf04             muls.w     -$30fc(a5), d0
1390: d086                 add.l      d6, d0
1392: 2840                 movea.l    d0, a4
1394: 102b0021             move.b     $21(a3), d0
1398: 4880                 ext.w      d0
139a: 204d                 movea.l    a5, a0
139c: 48c0                 ext.l      d0
139e: e588                 lsl.l      #$2, d0
13a0: d1c0                 adda.l     d0, a0
13a2: 2468f72a             movea.l    -$8d6(a0), a2
13a6: bc8a                 cmp.l      a2, d6
13a8: 6454                 bcc.b      $13fe
13aa: b9ca                 cmpa.l     a2, a4
13ac: 6350                 bls.b      $13fe
13ae: 102a0030             move.b     $30(a2), d0
13b2: b02b0020             cmp.b      $20(a3), d0
13b6: 6646                 bne.b      $13fe
13b8: 102a0031             move.b     $31(a2), d0
13bc: b02b0021             cmp.b      $21(a3), d0
13c0: 663c                 bne.b      $13fe
13c2: 102a003c             move.b     $3c(a2), d0
13c6: 4880                 ext.w      d0
13c8: b06db1d6             cmp.w      -$4e2a(a5), d0
13cc: 6630                 bne.b      $13fe
13ce: 102a003e             move.b     $3e(a2), d0
13d2: 4880                 ext.w      d0
13d4: b06e0016             cmp.w      $16(a6), d0
13d8: 6624                 bne.b      $13fe
13da: 102a003d             move.b     $3d(a2), d0
13de: 4880                 ext.w      d0
13e0: b06e0014             cmp.w      $14(a6), d0
13e4: 6618                 bne.b      $13fe
13e6: 102a003f             move.b     $3f(a2), d0
13ea: 4880                 ext.w      d0
13ec: b06e0018             cmp.w      $18(a6), d0
13f0: 660c                 bne.b      $13fe
13f2: 102a0040             move.b     $40(a2), d0
13f6: 4880                 ext.w      d0
13f8: b06e001a             cmp.w      $1a(a6), d0
13fc: 6770                 beq.b      $146e
13fe: 2446                 movea.l    d6, a2
1400: 600000be             bra.w      $14c0
1404: 102a0030             move.b     $30(a2), d0
1408: b02b0020             cmp.b      $20(a3), d0
140c: 660000ae             bne.w      $14bc
1410: 102a0031             move.b     $31(a2), d0
1414: b02b0021             cmp.b      $21(a3), d0
1418: 660000a2             bne.w      $14bc
141c: 102a003c             move.b     $3c(a2), d0
1420: 4880                 ext.w      d0
1422: b06db1d6             cmp.w      -$4e2a(a5), d0
1426: 66000094             bne.w      $14bc
142a: 102a003e             move.b     $3e(a2), d0
142e: 4880                 ext.w      d0
1430: b06e0016             cmp.w      $16(a6), d0
1434: 66000086             bne.w      $14bc
1438: 102a003d             move.b     $3d(a2), d0
143c: 4880                 ext.w      d0
143e: b06e0014             cmp.w      $14(a6), d0
1442: 6678                 bne.b      $14bc
1444: 102a003f             move.b     $3f(a2), d0
1448: 4880                 ext.w      d0
144a: b06e0018             cmp.w      $18(a6), d0
144e: 666c                 bne.b      $14bc
1450: 102a0040             move.b     $40(a2), d0
1454: 4880                 ext.w      d0
1456: b06e001a             cmp.w      $1a(a6), d0
145a: 6660                 bne.b      $14bc
145c: 102b0021             move.b     $21(a3), d0
1460: 4880                 ext.w      d0
1462: 204d                 movea.l    a5, a0
1464: 48c0                 ext.l      d0
1466: e588                 lsl.l      #$2, d0
1468: d1c0                 adda.l     d0, a0
146a: 214af72a             move.l     a2, -$8d6(a0)
146e: beaa0004             cmp.l      $4(a2), d7
1472: 6f44                 ble.b      $14b8
1474: 41eeffbe             lea.l      -$42(a6), a0
1478: 43d2                 lea.l      (a2), a1
147a: 700f                 moveq      #$f, d0
147c: 20d9                 move.l     (a1)+, (a0)+
147e: 51c8fffc             dbra       d0, $147c
1482: 30d9                 move.w     (a1)+, (a0)+
1484: 6014                 bra.b      $149a
1486: 41d2                 lea.l      (a2), a0
1488: 43eaffbe             lea.l      -$42(a2), a1
148c: 700f                 moveq      #$f, d0
148e: 20d9                 move.l     (a1)+, (a0)+
1490: 51c8fffc             dbra       d0, $148e
1494: 30d9                 move.w     (a1)+, (a0)+
1496: 45eaffbe             lea.l      -$42(a2), a2
149a: bc8a                 cmp.l      a2, d6
149c: 6406                 bcc.b      $14a4
149e: beaaffc2             cmp.l      -$3e(a2), d7
14a2: 6ee2                 bgt.b      $1486
14a4: 41d2                 lea.l      (a2), a0
14a6: 43eeffbe             lea.l      -$42(a6), a1
14aa: 700f                 moveq      #$f, d0
14ac: 20d9                 move.l     (a1)+, (a0)+
14ae: 51c8fffc             dbra       d0, $14ac
14b2: 30d9                 move.w     (a1)+, (a0)+
14b4: 25470004             move.l     d7, $4(a2)
14b8: 200a                 move.l     a2, d0
14ba: 600c                 bra.b      $14c8
14bc: 45ea0042             lea.l      $42(a2), a2
14c0: b9ca                 cmpa.l     a2, a4
14c2: 6200ff40             bhi.w      $1404
14c6: 7000                 moveq      #$0, d0
14c8: 4cdf1cc0             movem.l    (a7)+, d6-d7/a2-a4
14cc: 4e5e                 unlk       a6
14ce: 4e75                 rts        
14d0: 4e56ffbe             link.w     a6, #$ffbe
14d4: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
14d8: 2e2e0008             move.l     $8(a6), d7
14dc: 4a6dcf04             tst.w      -$30fc(a5)
14e0: 6606                 bne.b      $14e8
14e2: 7000                 moveq      #$0, d0
14e4: 60000154             bra.w      $163a
14e8: 7a00                 moveq      #$0, d5
14ea: 99cc                 suba.l     a4, a4
14ec: 600000ec             bra.w      $15da
14f0: 2007                 move.l     d7, d0
14f2: d08c                 add.l      a4, d0
14f4: 2640                 movea.l    d0, a3
14f6: 422b0009             clr.b      $9(a3)
14fa: 422b0008             clr.b      $8(a3)
14fe: 45f47810             lea.l      $10(a4, d7.l), a2
1502: 176a0020000a         move.b     $20(a2), $a(a3)
1508: 176a0021000b         move.b     $21(a2), $b(a3)
150e: 2f0a                 move.l     a2, -(a7)
1510: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
1514: 1740000c             move.b     d0, $c(a3)
1518: 41eb0038             lea.l      $38(a3), a0
151c: 102b003c             move.b     $3c(a3), d0
1520: 4880                 ext.w      d0
1522: 224d                 movea.l    a5, a1
1524: d2c0                 adda.w     d0, a1
1526: d2c0                 adda.w     d0, a1
1528: 3029f8d2             move.w     -$72e(a1), d0
152c: c0d0                 mulu.w     (a0), d0
152e: 3080                 move.w     d0, (a0)
1530: 4257                 clr.w      (a7)
1532: 486df7dc             pea.l      -$824(a5)
1536: 2f0a                 move.l     a2, -(a7)
1538: 4ead0942             jsr        $942(a5) ; CODE31+0184
153c: 45f47824             lea.l      $24(a4, d7.l), a2
1540: 3ebc0001             move.w     #$1, (a7)
1544: 42a7                 clr.l      -(a7)
1546: 42a7                 clr.l      -(a7)
1548: 4ead09da             jsr        $9da(a5) ; CODE35+0a48
154c: 2480                 move.l     d0, (a2)
154e: 4a92                 tst.l      (a2)
1550: 4fef0014             lea.l      $14(a7), a7
1554: 6c06                 bge.b      $155c
1556: 04920000012c         subi.l     #$12c, (a2)
155c: 2012                 move.l     (a2), d0
155e: d1ab0004             add.l      d0, $4(a3)
1562: 486df7dc             pea.l      -$824(a5)
1566: 4ead094a             jsr        $94a(a5) ; CODE31+0642
156a: 486df7dc             pea.l      -$824(a5)
156e: 4ead096a             jsr        $96a(a5) ; CODE31+0992
1572: 3805                 move.w     d5, d4
1574: 7042                 moveq      #$42, d0
1576: c1c4                 muls.w     d4, d0
1578: 2640                 movea.l    d0, a3
157a: 508f                 addq.l     #$8, a7
157c: 6052                 bra.b      $15d0
157e: 2007                 move.l     d7, d0
1580: d08b                 add.l      a3, d0
1582: 2440                 movea.l    d0, a2
1584: 70ff                 moveq      #$ff, d0
1586: d044                 add.w      d4, d0
1588: c1fc0042             muls.w     #$42, d0
158c: d087                 add.l      d7, d0
158e: 2c00                 move.l     d0, d6
1590: 2046                 movea.l    d6, a0
1592: 202a0004             move.l     $4(a2), d0
1596: b0a80004             cmp.l      $4(a0), d0
159a: 6f2e                 ble.b      $15ca
159c: 41eeffbe             lea.l      -$42(a6), a0
15a0: 43d2                 lea.l      (a2), a1
15a2: 700f                 moveq      #$f, d0
15a4: 20d9                 move.l     (a1)+, (a0)+
15a6: 51c8fffc             dbra       d0, $15a4
15aa: 30d9                 move.w     (a1)+, (a0)+
15ac: 2046                 movea.l    d6, a0
15ae: 43d2                 lea.l      (a2), a1
15b0: 700f                 moveq      #$f, d0
15b2: 22d8                 move.l     (a0)+, (a1)+
15b4: 51c8fffc             dbra       d0, $15b2
15b8: 32d8                 move.w     (a0)+, (a1)+
15ba: 2046                 movea.l    d6, a0
15bc: 43eeffbe             lea.l      -$42(a6), a1
15c0: 700f                 moveq      #$f, d0
15c2: 20d9                 move.l     (a1)+, (a0)+
15c4: 51c8fffc             dbra       d0, $15c2
15c8: 30d9                 move.w     (a1)+, (a0)+
15ca: 5344                 subq.w     #$1, d4
15cc: 47ebffbe             lea.l      -$42(a3), a3
15d0: 4a44                 tst.w      d4
15d2: 66aa                 bne.b      $157e
15d4: 5245                 addq.w     #$1, d5
15d6: 49ec0042             lea.l      $42(a4), a4
15da: ba6dcf04             cmp.w      -$30fc(a5), d5
15de: 6d00ff10             blt.w      $14f0
15e2: 7a00                 moveq      #$0, d5
15e4: 99cc                 suba.l     a4, a4
15e6: 603c                 bra.b      $1624
15e8: 47f47838             lea.l      $38(a4, d7.l), a3
15ec: 2007                 move.l     d7, d0
15ee: d08c                 add.l      a4, d0
15f0: 2440                 movea.l    d0, a2
15f2: 3013                 move.w     (a3), d0
15f4: b06df8d0             cmp.w      -$730(a5), d0
15f8: 6304                 bls.b      $15fe
15fa: 36adf8d0             move.w     -$730(a5), (a3)
15fe: 102a003c             move.b     $3c(a2), d0
1602: 4880                 ext.w      d0
1604: c1edf8e2             muls.w     -$71e(a5), d0
1608: 48c0                 ext.l      d0
160a: 91aa0004             sub.l      d0, $4(a2)
160e: 7001                 moveq      #$1, d0
1610: d045                 add.w      d5, d0
1612: c1fc0042             muls.w     #$42, d0
1616: d087                 add.l      d7, d0
1618: 2480                 move.l     d0, (a2)
161a: 1545000d             move.b     d5, $d(a2)
161e: 5245                 addq.w     #$1, d5
1620: 49ec0042             lea.l      $42(a4), a4
1624: ba6dcf04             cmp.w      -$30fc(a5), d5
1628: 6dbe                 blt.b      $15e8
162a: 70ff                 moveq      #$ff, d0
162c: d045                 add.w      d5, d0
162e: c1fc0042             muls.w     #$42, d0
1632: d087                 add.l      d7, d0
1634: 2040                 movea.l    d0, a0
1636: 4290                 clr.l      (a0)
1638: 2007                 move.l     d7, d0
163a: 4cdf1cf0             movem.l    (a7)+, d4-d7/a2-a4
163e: 4e5e                 unlk       a6
1640: 4e75                 rts        
1642: 4e560000             link.w     a6, #$0
1646: 48e70138             movem.l    d7/a2-a4, -(a7)
164a: 266e0008             movea.l    $8(a6), a3
164e: 102b0021             move.b     $21(a3), d0
1652: 4880                 ext.w      d0
1654: 122b0020             move.b     $20(a3), d1
1658: 4881                 ext.w      d1
165a: c3fc0011             muls.w     #$11, d1
165e: 49edbcfe             lea.l      -$4302(a5), a4
1662: d28c                 add.l      a4, d1
1664: 3840                 movea.w    d0, a4
1666: d28c                 add.l      a4, d1
1668: 2841                 movea.l    d1, a4
166a: 426db1d6             clr.w      -$4e2a(a5)
166e: 48780080             pea.l      $80.w
1672: 486dce84             pea.l      -$317c(a5)
1676: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
167a: 244b                 movea.l    a3, a2
167c: 508f                 addq.l     #$8, a7
167e: 1e12                 move.b     (a2), d7
1680: 4a07                 tst.b      d7
1682: 6746                 beq.b      $16ca
1684: 4a1c                 tst.b      (a4)+
1686: 663e                 bne.b      $16c6
1688: 526db1d6             addq.w     #$1, -$4e2a(a5)
168c: 1007                 move.b     d7, d0
168e: 4880                 ext.w      d0
1690: 204d                 movea.l    a5, a0
1692: d0c0                 adda.w     d0, a0
1694: 1007                 move.b     d7, d0
1696: 4880                 ext.w      d0
1698: 224d                 movea.l    a5, a1
169a: d2c0                 adda.w     d0, a1
169c: 1028ce84             move.b     -$317c(a0), d0
16a0: b029a54e             cmp.b      -$5ab2(a1), d0
16a4: 6614                 bne.b      $16ba
16a6: 102dcec3             move.b     -$313d(a5), d0
16aa: b02da58d             cmp.b      -$5a73(a5), d0
16ae: 6d04                 blt.b      $16b4
16b0: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
16b4: 522dcec3             addq.b     #$1, -$313d(a5)
16b8: 600c                 bra.b      $16c6
16ba: 1012                 move.b     (a2), d0
16bc: 4880                 ext.w      d0
16be: 204d                 movea.l    a5, a0
16c0: d0c0                 adda.w     d0, a0
16c2: 5228ce84             addq.b     #$1, -$317c(a0)
16c6: 528a                 addq.l     #$1, a2
16c8: 60b4                 bra.b      $167e
16ca: 4cdf1c80             movem.l    (a7)+, d7/a2-a4
16ce: 4e5e                 unlk       a6
16d0: 4e75                 rts        
16d2: 4e56fffe             link.w     a6, #$fffe
16d6: 2f0c                 move.l     a4, -(a7)
16d8: 286e0016             movea.l    $16(a6), a4
16dc: 6028                 bra.b      $1706
16de: 4a2c0030             tst.b      $30(a4)
16e2: 6f20                 ble.b      $1704
16e4: 3f2c0036             move.w     $36(a4), -(a7)
16e8: 2f2e0012             move.l     $12(a6), -(a7)
16ec: 3f2e0010             move.w     $10(a6), -(a7)
16f0: 2f2e000c             move.l     $c(a6), -(a7)
16f4: 2f2e0008             move.l     $8(a6), -(a7)
16f8: 4eba001a             jsr        $1714(pc)
16fc: 3d400010             move.w     d0, $10(a6)
1700: 4fef0010             lea.l      $10(a7), a7
1704: 2854                 movea.l    (a4), a4
1706: 200c                 move.l     a4, d0
1708: 66d4                 bne.b      $16de
170a: 302e0010             move.w     $10(a6), d0
170e: 285f                 movea.l    (a7)+, a4
1710: 4e5e                 unlk       a6
1712: 4e75                 rts        
1714: 4e560000             link.w     a6, #$0
1718: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
171c: 266e0008             movea.l    $8(a6), a3
1720: 3c2e0010             move.w     $10(a6), d6
1724: 3e2e0016             move.w     $16(a6), d7
1728: 0c47ffff             cmpi.w     #$ffff, d7
172c: 6604                 bne.b      $1732
172e: 3006                 move.w     d6, d0
1730: 6056                 bra.b      $1788
1732: 3846                 movea.w    d6, a4
1734: d9cc                 adda.l     a4, a4
1736: 204b                 movea.l    a3, a0
1738: d1cc                 adda.l     a4, a0
173a: 3087                 move.w     d7, (a0)
173c: 7a00                 moveq      #$0, d5
173e: 204b                 movea.l    a3, a0
1740: d0c6                 adda.w     d6, a0
1742: 38306000             move.w     (a0, d6.w), d4
1746: 3445                 movea.w    d5, a2
1748: d5ca                 adda.l     a2, a2
174a: 6004                 bra.b      $1750
174c: 5245                 addq.w     #$1, d5
174e: 548a                 addq.l     #$2, a2
1750: 204b                 movea.l    a3, a0
1752: d1ca                 adda.l     a2, a0
1754: b850                 cmp.w      (a0), d4
1756: 66f4                 bne.b      $174c
1758: bc45                 cmp.w      d5, d6
175a: 662a                 bne.b      $1786
175c: 302df7d2             move.w     -$82e(a5), d0
1760: 204d                 movea.l    a5, a0
1762: 48c0                 ext.l      d0
1764: e588                 lsl.l      #$2, d0
1766: d1c0                 adda.l     d0, a0
1768: 70ff                 moveq      #$ff, d0
176a: d06899d8             add.w      -$6628(a0), d0
176e: c047                 and.w      d7, d0
1770: 3f00                 move.w     d0, -(a7)
1772: 2f2e0012             move.l     $12(a6), -(a7)
1776: 4ead0a9a             jsr        $a9a(a5) ; CODE42+00a8
177a: 204c                 movea.l    a4, a0
177c: d1ee000c             adda.l     $c(a6), a0
1780: 3080                 move.w     d0, (a0)
1782: 5246                 addq.w     #$1, d6
1784: 5c8f                 addq.l     #$6, a7
1786: 3006                 move.w     d6, d0
1788: 4cdf1cf0             movem.l    (a7)+, d4-d7/a2-a4
178c: 4e5e                 unlk       a6
178e: 4e75                 rts        
1790: 4e56fffc             link.w     a6, #$fffc
1794: 2f0c                 move.l     a4, -(a7)
1796: 286e0012             movea.l    $12(a6), a4
179a: 601c                 bra.b      $17b8
179c: 2f0c                 move.l     a4, -(a7)
179e: 2f2e000e             move.l     $e(a6), -(a7)
17a2: 3f2e000c             move.w     $c(a6), -(a7)
17a6: 2f2e0008             move.l     $8(a6), -(a7)
17aa: 4eba001a             jsr        $17c6(pc)
17ae: 2d40000e             move.l     d0, $e(a6)
17b2: 4fef000e             lea.l      $e(a7), a7
17b6: 2854                 movea.l    (a4), a4
17b8: 200c                 move.l     a4, d0
17ba: 66e0                 bne.b      $179c
17bc: 202e000e             move.l     $e(a6), d0
17c0: 285f                 movea.l    (a7)+, a4
17c2: 4e5e                 unlk       a6
17c4: 4e75                 rts        
17c6: 4e560000             link.w     a6, #$0
17ca: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
17ce: 286e000e             movea.l    $e(a6), a4
17d2: 206e0012             movea.l    $12(a6), a0
17d6: 214c0032             move.l     a4, $32(a0)
17da: 7e01                 moveq      #$1, d7
17dc: 367c0002             movea.w    #$2, a3
17e0: 601c                 bra.b      $17fe
17e2: 206e0012             movea.l    $12(a6), a0
17e6: 3c280036             move.w     $36(a0), d6
17ea: 224b                 movea.l    a3, a1
17ec: d3ee0008             adda.l     $8(a6), a1
17f0: 3011                 move.w     (a1), d0
17f2: 8046                 or.w       d6, d0
17f4: bc40                 cmp.w      d0, d6
17f6: 6602                 bne.b      $17fa
17f8: 38c7                 move.w     d7, (a4)+
17fa: 5247                 addq.w     #$1, d7
17fc: 548b                 addq.l     #$2, a3
17fe: be6e000c             cmp.w      $c(a6), d7
1802: 6dde                 blt.b      $17e2
1804: 425c                 clr.w      (a4)+
1806: 200c                 move.l     a4, d0
1808: 4cdf18c0             movem.l    (a7)+, d6-d7/a3-a4
180c: 4e5e                 unlk       a6
180e: 4e75                 rts        
1810: 4e56cd52             link.w     a6, #$cd52
1814: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
1818: 286e0008             movea.l    $8(a6), a4
181c: 2f0c                 move.l     a4, -(a7)
181e: 4ead096a             jsr        $96a(a5) ; CODE31+0992
1822: 486eff5c             pea.l      -$a4(a6)
1826: 4ead095a             jsr        $95a(a5) ; CODE31+075c
182a: 3b40f7d2             move.w     d0, -$82e(a5)
182e: 2b6dd134a548         move.l     -$2ecc(a5), -$5ab8(a5)
1834: 4a6e000c             tst.w      $c(a6)
1838: 508f                 addq.l     #$8, a7
183a: 665e                 bne.b      $189a
183c: 4ead0692             jsr        $692(a5) ; CODE9+00ee
1840: 2800                 move.l     d0, d4
1842: 1c2da58d             move.b     -$5a73(a5), d6
1846: 4886                 ext.w      d6
1848: 102eff9b             move.b     -$65(a6), d0
184c: 4880                 ext.w      d0
184e: d046                 add.w      d6, d0
1850: 3600                 move.w     d0, d3
1852: 4a2da58d             tst.b      -$5a73(a5)
1856: 6706                 beq.b      $185e
1858: 7001                 moveq      #$1, d0
185a: d046                 add.w      d6, d0
185c: d640                 add.w      d0, d3
185e: 2f04                 move.l     d4, -(a7)
1860: 7012                 moveq      #$12, d0
1862: c1c3                 muls.w     d3, d0
1864: d08d                 add.l      a5, d0
1866: 2040                 movea.l    d0, a0
1868: 302df7d2             move.w     -$82e(a5), d0
186c: d0c0                 adda.w     d0, a0
186e: d0c0                 adda.w     d0, a0
1870: 3228f756             move.w     -$8aa(a0), d1
1874: c3fc2020             muls.w     #$2020, d1
1878: 2f01                 move.l     d1, -(a7)
187a: 4ead004a             jsr        $4a(a5) ; CODE1+0124
187e: 0c80000006a4         cmpi.l     #$6a4, d0
1884: 6314                 bls.b      $189a
1886: 486d0842             pea.l      $842(a5)
188a: 2f0c                 move.l     a4, -(a7)
188c: 4ead0852             jsr        $852(a5) ; CODE28+011a
1890: 41eda5f0             lea.l      -$5a10(a5), a0
1894: 2008                 move.l     a0, d0
1896: 60000af0             bra.w      $2388
189a: 422eff4e             clr.b      -$b2(a6)
189e: 422eff4d             clr.b      -$b3(a6)
18a2: 42adf87c             clr.l      -$784(a5)
18a6: 266d99d2             movea.l    -$662e(a5), a3
18aa: 60000096             bra.w      $1942
18ae: 486efef6             pea.l      -$10a(a6)
18b2: 486eff4c             pea.l      -$b4(a6)
18b6: 4ead09c2             jsr        $9c2(a5) ; CODE32+16c0
18ba: 1213                 move.b     (a3), d1
18bc: 4881                 ext.w      d1
18be: 204d                 movea.l    a5, a0
18c0: d0c1                 adda.w     d1, a0
18c2: d0c1                 adda.w     d1, a0
18c4: 3140f778             move.w     d0, -$888(a0)
18c8: 4a40                 tst.w      d0
18ca: 508f                 addq.l     #$8, a7
18cc: 6f22                 ble.b      $18f0
18ce: 1013                 move.b     (a3), d0
18d0: 4880                 ext.w      d0
18d2: 204e                 movea.l    a6, a0
18d4: d0c0                 adda.w     d0, a0
18d6: 1028ff5c             move.b     -$a4(a0), d0
18da: 4880                 ext.w      d0
18dc: 1213                 move.b     (a3), d1
18de: 4881                 ext.w      d1
18e0: 204d                 movea.l    a5, a0
18e2: d0c1                 adda.w     d1, a0
18e4: d0c1                 adda.w     d1, a0
18e6: c1e8f778             muls.w     -$888(a0), d0
18ea: 48c0                 ext.l      d0
18ec: d1adf87c             add.l      d0, -$784(a5)
18f0: 1013                 move.b     (a3), d0
18f2: 4880                 ext.w      d0
18f4: 204e                 movea.l    a6, a0
18f6: d0c0                 adda.w     d0, a0
18f8: 0c280001ff5c         cmpi.b     #$1, -$a4(a0)
18fe: 6f40                 ble.b      $1940
1900: 1d53ff4d             move.b     (a3), -$b3(a6)
1904: 486efef6             pea.l      -$10a(a6)
1908: 486eff4c             pea.l      -$b4(a6)
190c: 4ead09c2             jsr        $9c2(a5) ; CODE32+16c0
1910: c1fc0007             muls.w     #$7, d0
1914: 1213                 move.b     (a3), d1
1916: 4881                 ext.w      d1
1918: 204e                 movea.l    a6, a0
191a: d0c1                 adda.w     d1, a0
191c: 1228ff5c             move.b     -$a4(a0), d1
1920: 4881                 ext.w      d1
1922: 5341                 subq.w     #$1, d1
1924: c1c1                 muls.w     d1, d0
1926: 48c0                 ext.l      d0
1928: 81edf7d2             divs.w     -$82e(a5), d0
192c: 1213                 move.b     (a3), d1
192e: 4881                 ext.w      d1
1930: 204d                 movea.l    a5, a0
1932: d0c1                 adda.w     d1, a0
1934: d0c1                 adda.w     d1, a0
1936: d168f778             add.w      d0, -$888(a0)
193a: 422eff4d             clr.b      -$b3(a6)
193e: 508f                 addq.l     #$8, a7
1940: 528b                 addq.l     #$1, a3
1942: 1d53ff4c             move.b     (a3), -$b4(a6)
1946: 6600ff66             bne.w      $18ae
194a: 046d01f4f84c         subi.w     #$1f4, -$7b4(a5)
1950: 046d0bb8f85a         subi.w     #$bb8, -$7a6(a5)
1956: 046d03e8f86c         subi.w     #$3e8, -$794(a5)
195c: 486efef6             pea.l      -$10a(a6)
1960: 2f2d93c0             move.l     -$6c40(a5), -(a7)
1964: 4ead09c2             jsr        $9c2(a5) ; CODE32+16c0
1968: 3b40f86e             move.w     d0, -$792(a5)
196c: 2eadf726             move.l     -$8da(a5), (a7)
1970: 486efefa             pea.l      -$106(a6)
1974: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
1978: 45eefefa             lea.l      -$106(a6), a2
197c: 4fef000c             lea.l      $c(a7), a7
1980: 60000090             bra.w      $1a12
1984: 1012                 move.b     (a2), d0
1986: 4880                 ext.w      d0
1988: 3f00                 move.w     d0, -(a7)
198a: 2f2df726             move.l     -$8da(a5), -(a7)
198e: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
1992: 1812                 move.b     (a2), d4
1994: 4884                 ext.w      d4
1996: 48c4                 ext.l      d4
1998: 90adf726             sub.l      -$8da(a5), d0
199c: 204e                 movea.l    a6, a0
199e: d1c4                 adda.l     d4, a0
19a0: 1228ff5c             move.b     -$a4(a0), d1
19a4: 4881                 ext.w      d1
19a6: c3fc001e             muls.w     #$1e, d1
19aa: 204d                 movea.l    a5, a0
19ac: d1c4                 adda.l     d4, a0
19ae: d1c4                 adda.l     d4, a0
19b0: 760a                 moveq      #$a, d3
19b2: c7e89412             muls.w     -$6bee(a0), d3
19b6: 9641                 sub.w      d1, d3
19b8: d640                 add.w      d0, d3
19ba: 47ea0001             lea.l      $1(a2), a3
19be: 5c8f                 addq.l     #$6, a7
19c0: 604a                 bra.b      $1a0c
19c2: 1013                 move.b     (a3), d0
19c4: 4880                 ext.w      d0
19c6: 3f00                 move.w     d0, -(a7)
19c8: 2f2df726             move.l     -$8da(a5), -(a7)
19cc: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
19d0: 1813                 move.b     (a3), d4
19d2: 1c04                 move.b     d4, d6
19d4: 4886                 ext.w      d6
19d6: 48c6                 ext.l      d6
19d8: 90adf726             sub.l      -$8da(a5), d0
19dc: 204e                 movea.l    a6, a0
19de: d1c6                 adda.l     d6, a0
19e0: 1228ff5c             move.b     -$a4(a0), d1
19e4: 4881                 ext.w      d1
19e6: c3fc001e             muls.w     #$1e, d1
19ea: 204d                 movea.l    a5, a0
19ec: d1c6                 adda.l     d6, a0
19ee: d1c6                 adda.l     d6, a0
19f0: 7a0a                 moveq      #$a, d5
19f2: cbe89412             muls.w     -$6bee(a0), d5
19f6: 9a41                 sub.w      d1, d5
19f8: da40                 add.w      d0, d5
19fa: b645                 cmp.w      d5, d3
19fc: 5c8f                 addq.l     #$6, a7
19fe: 6f0a                 ble.b      $1a0a
1a00: 3605                 move.w     d5, d3
1a02: 1a04                 move.b     d4, d5
1a04: 4885                 ext.w      d5
1a06: 1692                 move.b     (a2), (a3)
1a08: 1485                 move.b     d5, (a2)
1a0a: 528b                 addq.l     #$1, a3
1a0c: 4a13                 tst.b      (a3)
1a0e: 66b2                 bne.b      $19c2
1a10: 528a                 addq.l     #$1, a2
1a12: 4a12                 tst.b      (a2)
1a14: 6600ff6e             bne.w      $1984
1a18: 426df7da             clr.w      -$826(a5)
1a1c: 426df7d8             clr.w      -$828(a5)
1a20: 426df7d6             clr.w      -$82a(a5)
1a24: 426df7d4             clr.w      -$82c(a5)
1a28: 47eefefa             lea.l      -$106(a6), a3
1a2c: 1813                 move.b     (a3), d4
1a2e: 4a04                 tst.b      d4
1a30: 672c                 beq.b      $1a5e
1a32: 1004                 move.b     d4, d0
1a34: 4880                 ext.w      d0
1a36: 204e                 movea.l    a6, a0
1a38: d0c0                 adda.w     d0, a0
1a3a: 4a28ff5c             tst.b      -$a4(a0)
1a3e: 671a                 beq.b      $1a5a
1a40: 3b6df7d8f7da         move.w     -$828(a5), -$826(a5)
1a46: 3b6df7d6f7d8         move.w     -$82a(a5), -$828(a5)
1a4c: 3b6df7d4f7d6         move.w     -$82c(a5), -$82a(a5)
1a52: 1004                 move.b     d4, d0
1a54: 4880                 ext.w      d0
1a56: 3b40f7d4             move.w     d0, -$82c(a5)
1a5a: 528b                 addq.l     #$1, a3
1a5c: 60ce                 bra.b      $1a2c
1a5e: 4a6df7da             tst.w      -$826(a5)
1a62: 6604                 bne.b      $1a68
1a64: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
1a68: 0c6d000af7d2         cmpi.w     #$a, -$82e(a5)
1a6e: 6f20                 ble.b      $1a90
1a70: 302df7d6             move.w     -$82a(a5), d0
1a74: 204d                 movea.l    a5, a0
1a76: d0c0                 adda.w     d0, a0
1a78: d0c0                 adda.w     d0, a0
1a7a: 32289412             move.w     -$6bee(a0), d1
1a7e: b26d94d6             cmp.w      -$6b2a(a5), d1
1a82: 6c0c                 bge.b      $1a90
1a84: 426df7da             clr.w      -$826(a5)
1a88: 426df7d8             clr.w      -$828(a5)
1a8c: 426df7d6             clr.w      -$82a(a5)
1a90: 0c6d000df7d2         cmpi.w     #$d, -$82e(a5)
1a96: 6f1c                 ble.b      $1ab4
1a98: 302df7d8             move.w     -$828(a5), d0
1a9c: 204d                 movea.l    a5, a0
1a9e: d0c0                 adda.w     d0, a0
1aa0: d0c0                 adda.w     d0, a0
1aa2: 32289412             move.w     -$6bee(a0), d1
1aa6: b26d94d6             cmp.w      -$6b2a(a5), d1
1aaa: 6e08                 bgt.b      $1ab4
1aac: 426df7da             clr.w      -$826(a5)
1ab0: 426df7d8             clr.w      -$828(a5)
1ab4: 3f3c0071             move.w     #$71, -(a7)
1ab8: 2f0c                 move.l     a4, -(a7)
1aba: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
1abe: 122effcd             move.b     -$33(a6), d1
1ac2: 4881                 ext.w      d1
1ac4: 3041                 movea.w    d1, a0
1ac6: d088                 add.l      a0, d0
1ac8: 5c8f                 addq.l     #$6, a7
1aca: 6706                 beq.b      $1ad2
1acc: 303cfe0c             move.w     #$fe0c, d0
1ad0: 6002                 bra.b      $1ad4
1ad2: 7000                 moveq      #$0, d0
1ad4: 3b40f8e2             move.w     d0, -$71e(a5)
1ad8: 72f9                 moveq      #$f9, d1
1ada: d26df7d2             add.w      -$82e(a5), d1
1ade: 48c0                 ext.l      d0
1ae0: 81c1                 divs.w     d1, d0
1ae2: 3b40f8e2             move.w     d0, -$71e(a5)
1ae6: 122effcd             move.b     -$33(a6), d1
1aea: 4881                 ext.w      d1
1aec: 3b41f8ce             move.w     d1, -$732(a5)
1af0: 48780080             pea.l      $80.w
1af4: 486eff5c             pea.l      -$a4(a6)
1af8: 486da54e             pea.l      -$5ab2(a5)
1afc: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
1b00: 486df7dc             pea.l      -$824(a5)
1b04: 4ead0952             jsr        $952(a5) ; CODE31+071e
1b08: 41eee7a0             lea.l      -$1860(a6), a0
1b0c: 2b48cf24             move.l     a0, -$30dc(a5)
1b10: 426dcf04             clr.w      -$30fc(a5)
1b14: 2b7cf4143e00f880     move.l     #$f4143e00, -$780(a5)
1b1c: 4ead0972             jsr        $972(a5) ; CODE32+0824
1b20: 486eff1a             pea.l      -$e6(a6)
1b24: 486eff5c             pea.l      -$a4(a6)
1b28: 4ead0a92             jsr        $a92(a5) ; CODE42+0004
1b2c: 41eeff1a             lea.l      -$e6(a6), a0
1b30: 2b48f8c4             move.l     a0, -$73c(a5)
1b34: 486d09fa             pea.l      $9fa(a5)
1b38: 4ead0a3a             jsr        $a3a(a5) ; CODE37+0004
1b3c: 4a6dcf04             tst.w      -$30fc(a5)
1b40: 4fef001c             lea.l      $1c(a7), a7
1b44: 6614                 bne.b      $1b5a
1b46: 486d0842             pea.l      $842(a5)
1b4a: 2f0c                 move.l     a4, -(a7)
1b4c: 4ead0852             jsr        $852(a5) ; CODE28+011a
1b50: 41eda5f0             lea.l      -$5a10(a5), a0
1b54: 2008                 move.l     a0, d0
1b56: 60000830             bra.w      $2388
1b5a: 7600                 moveq      #$0, d3
1b5c: 95ca                 suba.l     a2, a2
1b5e: 6020                 bra.b      $1b80
1b60: 2e2dcf24             move.l     -$30dc(a5), d7
1b64: de8a                 add.l      a2, d7
1b66: 2047                 movea.l    d7, a0
1b68: 42680038             clr.w      $38(a0)
1b6c: 2047                 movea.l    d7, a0
1b6e: 42a80032             clr.l      $32(a0)
1b72: 2047                 movea.l    d7, a0
1b74: 317cffff0036         move.w     #$ffff, $36(a0)
1b7a: 5243                 addq.w     #$1, d3
1b7c: 45ea0042             lea.l      $42(a2), a2
1b80: b66dcf04             cmp.w      -$30fc(a5), d3
1b84: 6dda                 blt.b      $1b60
1b86: 302df7d2             move.w     -$82e(a5), d0
1b8a: 204d                 movea.l    a5, a0
1b8c: 48c0                 ext.l      d0
1b8e: e588                 lsl.l      #$2, d0
1b90: d1c0                 adda.l     d0, a0
1b92: 202899d6             move.l     -$662a(a0), d0
1b96: 2b40f8e8             move.l     d0, -$718(a5)
1b9a: 2f00                 move.l     d0, -(a7)
1b9c: 4ead0682             jsr        $682(a5) ; CODE9+00a4
1ba0: 2b40f8e4             move.l     d0, -$71c(a5)
1ba4: 4a80                 tst.l      d0
1ba6: 588f                 addq.l     #$4, a7
1ba8: 6714                 beq.b      $1bbe
1baa: 2f2df8e8             move.l     -$718(a5), -(a7)
1bae: 3f3cffff             move.w     #$ffff, -(a7)
1bb2: 2f2df8e4             move.l     -$71c(a5), -(a7)
1bb6: 4ead0d9a             jsr        $d9a(a5) ; CODE52+0204
1bba: 4fef000a             lea.l      $a(a7), a7
1bbe: 4878003e             pea.l      $3e.w
1bc2: 486ecd5a             pea.l      -$32a6(a6)
1bc6: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
1bca: 7600                 moveq      #$0, d3
1bcc: 95ca                 suba.l     a2, a2
1bce: 508f                 addq.l     #$8, a7
1bd0: 600000cc             bra.w      $1c9e
1bd4: 202dcf24             move.l     -$30dc(a5), d0
1bd8: 18320830             move.b     $30(a2, d0.l), d4
1bdc: 4884                 ext.w      d4
1bde: 4a44                 tst.w      d4
1be0: 6604                 bne.b      $1be6
1be2: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
1be6: 202dcf24             move.l     -$30dc(a5), d0
1bea: 1a320831             move.b     $31(a2, d0.l), d5
1bee: 4885                 ext.w      d5
1bf0: 7e11                 moveq      #$11, d7
1bf2: cfc4                 muls.w     d4, d7
1bf4: 41edbcfe             lea.l      -$4302(a5), a0
1bf8: de88                 add.l      a0, d7
1bfa: 72ff                 moveq      #$ff, d1
1bfc: d244                 add.w      d4, d1
1bfe: c3fc0011             muls.w     #$11, d1
1c02: 41edbcfe             lea.l      -$4302(a5), a0
1c06: d288                 add.l      a0, d1
1c08: 2d41cd52             move.l     d1, -$32ae(a6)
1c0c: 7401                 moveq      #$1, d2
1c0e: d444                 add.w      d4, d2
1c10: c5fc0011             muls.w     #$11, d2
1c14: 41edbcfe             lea.l      -$4302(a5), a0
1c18: d488                 add.l      a0, d2
1c1a: 2d42cd56             move.l     d2, -$32aa(a6)
1c1e: 4a45                 tst.w      d5
1c20: 6604                 bne.b      $1c26
1c22: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
1c26: 0c450010             cmpi.w     #$10, d5
1c2a: 6d04                 blt.b      $1c30
1c2c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
1c30: 3045                 movea.w    d5, a0
1c32: 4a307800             tst.b      (a0, d7.l)
1c36: 6644                 bne.b      $1c7c
1c38: 7011                 moveq      #$11, d0
1c3a: c1c4                 muls.w     d4, d0
1c3c: 41edbcfd             lea.l      -$4303(a5), a0
1c40: d088                 add.l      a0, d0
1c42: 3045                 movea.w    d5, a0
1c44: 4a300800             tst.b      (a0, d0.l)
1c48: 6636                 bne.b      $1c80
1c4a: 7011                 moveq      #$11, d0
1c4c: c1c4                 muls.w     d4, d0
1c4e: 41edbcff             lea.l      -$4301(a5), a0
1c52: d088                 add.l      a0, d0
1c54: 3045                 movea.w    d5, a0
1c56: 4a300800             tst.b      (a0, d0.l)
1c5a: 6624                 bne.b      $1c80
1c5c: 0c440010             cmpi.w     #$10, d4
1c60: 670a                 beq.b      $1c6c
1c62: 206ecd52             movea.l    -$32ae(a6), a0
1c66: 4a305000             tst.b      (a0, d5.w)
1c6a: 6614                 bne.b      $1c80
1c6c: 0c44000f             cmpi.w     #$f, d4
1c70: 670a                 beq.b      $1c7c
1c72: 206ecd56             movea.l    -$32aa(a6), a0
1c76: 4a305000             tst.b      (a0, d5.w)
1c7a: 6604                 bne.b      $1c80
1c7c: 5245                 addq.w     #$1, d5
1c7e: 609e                 bra.b      $1c1e
1c80: 204d                 movea.l    a5, a0
1c82: 2005                 move.l     d5, d0
1c84: 48c0                 ext.l      d0
1c86: e588                 lsl.l      #$2, d0
1c88: d1c0                 adda.l     d0, a0
1c8a: 302899d8             move.w     -$6628(a0), d0
1c8e: 204e                 movea.l    a6, a0
1c90: d0c4                 adda.w     d4, a0
1c92: d0c4                 adda.w     d4, a0
1c94: 8168cd5a             or.w       d0, -$32a6(a0)
1c98: 5243                 addq.w     #$1, d3
1c9a: 45ea0042             lea.l      $42(a2), a2
1c9e: b66dcf04             cmp.w      -$30fc(a5), d3
1ca2: 6d00ff30             blt.w      $1bd4
1ca6: 486d0a02             pea.l      $a02(a5)
1caa: 486ecd5a             pea.l      -$32a6(a6)
1cae: 4ead0a2a             jsr        $a2a(a5) ; CODE37+07b6
1cb2: 7600                 moveq      #$0, d3
1cb4: 45edf884             lea.l      -$77c(a5), a2
1cb8: 508f                 addq.l     #$8, a7
1cba: 602c                 bra.b      $1ce8
1cbc: 7a00                 moveq      #$0, d5
1cbe: 2e0a                 move.l     a2, d7
1cc0: 2005                 move.l     d5, d0
1cc2: 48c0                 ext.l      d0
1cc4: e588                 lsl.l      #$2, d0
1cc6: 2d40cd52             move.l     d0, -$32ae(a6)
1cca: 6012                 bra.b      $1cde
1ccc: 206ecd52             movea.l    -$32ae(a6), a0
1cd0: 21bc0bebc2007800     move.l     #$bebc200, (a0, d7.l)
1cd8: 5245                 addq.w     #$1, d5
1cda: 58aecd52             addq.l     #$4, -$32ae(a6)
1cde: 0c450002             cmpi.w     #$2, d5
1ce2: 65e8                 bcs.b      $1ccc
1ce4: 5243                 addq.w     #$1, d3
1ce6: 508a                 addq.l     #$8, a2
1ce8: 0c430008             cmpi.w     #$8, d3
1cec: 65ce                 bcs.b      $1cbc
1cee: 7600                 moveq      #$0, d3
1cf0: 45edf8d2             lea.l      -$72e(a5), a2
1cf4: 6030                 bra.b      $1d26
1cf6: 302df7d2             move.w     -$82e(a5), d0
1cfa: 9043                 sub.w      d3, d0
1cfc: 0c400011             cmpi.w     #$11, d0
1d00: 6504                 bcs.b      $1d06
1d02: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
1d06: 302df7d2             move.w     -$82e(a5), d0
1d0a: 9043                 sub.w      d3, d0
1d0c: 48c0                 ext.l      d0
1d0e: e988                 lsl.l      #$4, d0
1d10: 7207                 moveq      #$7, d1
1d12: 9243                 sub.w      d3, d1
1d14: 41ed9a58             lea.l      -$65a8(a5), a0
1d18: d088                 add.l      a0, d0
1d1a: 3041                 movea.w    d1, a0
1d1c: d1c8                 adda.l     a0, a0
1d1e: 34b00800             move.w     (a0, d0.l), (a2)
1d22: 5243                 addq.w     #$1, d3
1d24: 548a                 addq.l     #$2, a2
1d26: 0c430008             cmpi.w     #$8, d3
1d2a: 65ca                 bcs.b      $1cf6
1d2c: 3b6df8d2f8d0         move.w     -$72e(a5), -$730(a5)
1d32: 7007                 moveq      #$7, d0
1d34: 3b40f8ca             move.w     d0, -$736(a5)
1d38: 3b40f8c8             move.w     d0, -$738(a5)
1d3c: 72f9                 moveq      #$f9, d1
1d3e: d26df7d2             add.w      -$82e(a5), d1
1d42: 3b41f8cc             move.w     d1, -$734(a5)
1d46: 2f2dcf24             move.l     -$30dc(a5), -(a7)
1d4a: 4ebaf784             jsr        $14d0(pc)
1d4e: 2b40f870             move.l     d0, -$790(a5)
1d52: 42adf874             clr.l      -$78c(a5)
1d56: 2e80                 move.l     d0, (a7)
1d58: 4ead0aba             jsr        $aba(a5) ; CODE43+0314
1d5c: 2b6df870f878         move.l     -$790(a5), -$788(a5)
1d62: 588f                 addq.l     #$4, a7
1d64: 6008                 bra.b      $1d6e
1d66: 206df878             movea.l    -$788(a5), a0
1d6a: 2b50f878             move.l     (a0), -$788(a5)
1d6e: 206df878             movea.l    -$788(a5), a0
1d72: 4a90                 tst.l      (a0)
1d74: 66f0                 bne.b      $1d66
1d76: 41eecf02             lea.l      -$30fe(a6), a0
1d7a: 2b48f7f0             move.l     a0, -$810(a5)
1d7e: 302df7d2             move.w     -$82e(a5), d0
1d82: 224d                 movea.l    a5, a1
1d84: 48c0                 ext.l      d0
1d86: e588                 lsl.l      #$2, d0
1d88: d3c0                 adda.l     d0, a1
1d8a: 70ff                 moveq      #$ff, d0
1d8c: d06999d8             add.w      -$6628(a1), d0
1d90: 4640                 not.w      d0
1d92: 3f00                 move.w     d0, -(a7)
1d94: 486eff5c             pea.l      -$a4(a6)
1d98: 4267                 clr.w      -(a7)
1d9a: 486ecf02             pea.l      -$30fe(a6)
1d9e: 486ecd98             pea.l      -$3268(a6)
1da2: 4ebaf970             jsr        $1714(pc)
1da6: 3b40f7f4             move.w     d0, -$80c(a5)
1daa: 4a6df7d4             tst.w      -$82c(a5)
1dae: 4fef0010             lea.l      $10(a7), a7
1db2: 6742                 beq.b      $1df6
1db4: 302df7d2             move.w     -$82e(a5), d0
1db8: 204d                 movea.l    a5, a0
1dba: 48c0                 ext.l      d0
1dbc: e588                 lsl.l      #$2, d0
1dbe: d1c0                 adda.l     d0, a0
1dc0: 70ff                 moveq      #$ff, d0
1dc2: d06899d8             add.w      -$6628(a0), d0
1dc6: 322df7d4             move.w     -$82c(a5), d1
1dca: 48c1                 ext.l      d1
1dcc: e989                 lsl.l      #$4, d1
1dce: 204d                 movea.l    a5, a0
1dd0: d1c1                 adda.l     d1, a0
1dd2: c068b3f4             and.w      -$4c0c(a0), d0
1dd6: 4640                 not.w      d0
1dd8: 3f00                 move.w     d0, -(a7)
1dda: 486eff5c             pea.l      -$a4(a6)
1dde: 3f2df7f4             move.w     -$80c(a5), -(a7)
1de2: 486ecf02             pea.l      -$30fe(a6)
1de6: 486ecd98             pea.l      -$3268(a6)
1dea: 4ebaf928             jsr        $1714(pc)
1dee: 3b40f7f4             move.w     d0, -$80c(a5)
1df2: 4fef0010             lea.l      $10(a7), a7
1df6: 4a6df7d6             tst.w      -$82a(a5)
1dfa: 6742                 beq.b      $1e3e
1dfc: 302df7d2             move.w     -$82e(a5), d0
1e00: 204d                 movea.l    a5, a0
1e02: 48c0                 ext.l      d0
1e04: e588                 lsl.l      #$2, d0
1e06: d1c0                 adda.l     d0, a0
1e08: 70ff                 moveq      #$ff, d0
1e0a: d06899d8             add.w      -$6628(a0), d0
1e0e: 322df7d6             move.w     -$82a(a5), d1
1e12: 48c1                 ext.l      d1
1e14: e989                 lsl.l      #$4, d1
1e16: 204d                 movea.l    a5, a0
1e18: d1c1                 adda.l     d1, a0
1e1a: c068b3f4             and.w      -$4c0c(a0), d0
1e1e: 4640                 not.w      d0
1e20: 3f00                 move.w     d0, -(a7)
1e22: 486eff5c             pea.l      -$a4(a6)
1e26: 3f2df7f4             move.w     -$80c(a5), -(a7)
1e2a: 486ecf02             pea.l      -$30fe(a6)
1e2e: 486ecd98             pea.l      -$3268(a6)
1e32: 4ebaf8e0             jsr        $1714(pc)
1e36: 3b40f7f4             move.w     d0, -$80c(a5)
1e3a: 4fef0010             lea.l      $10(a7), a7
1e3e: 4a6df7d8             tst.w      -$828(a5)
1e42: 6742                 beq.b      $1e86
1e44: 302df7d2             move.w     -$82e(a5), d0
1e48: 204d                 movea.l    a5, a0
1e4a: 48c0                 ext.l      d0
1e4c: e588                 lsl.l      #$2, d0
1e4e: d1c0                 adda.l     d0, a0
1e50: 70ff                 moveq      #$ff, d0
1e52: d06899d8             add.w      -$6628(a0), d0
1e56: 322df7d8             move.w     -$828(a5), d1
1e5a: 48c1                 ext.l      d1
1e5c: e989                 lsl.l      #$4, d1
1e5e: 204d                 movea.l    a5, a0
1e60: d1c1                 adda.l     d1, a0
1e62: c068b3f4             and.w      -$4c0c(a0), d0
1e66: 4640                 not.w      d0
1e68: 3f00                 move.w     d0, -(a7)
1e6a: 486eff5c             pea.l      -$a4(a6)
1e6e: 3f2df7f4             move.w     -$80c(a5), -(a7)
1e72: 486ecf02             pea.l      -$30fe(a6)
1e76: 486ecd98             pea.l      -$3268(a6)
1e7a: 4ebaf898             jsr        $1714(pc)
1e7e: 3b40f7f4             move.w     d0, -$80c(a5)
1e82: 4fef0010             lea.l      $10(a7), a7
1e86: 4a6df7da             tst.w      -$826(a5)
1e8a: 6742                 beq.b      $1ece
1e8c: 302df7d2             move.w     -$82e(a5), d0
1e90: 204d                 movea.l    a5, a0
1e92: 48c0                 ext.l      d0
1e94: e588                 lsl.l      #$2, d0
1e96: d1c0                 adda.l     d0, a0
1e98: 70ff                 moveq      #$ff, d0
1e9a: d06899d8             add.w      -$6628(a0), d0
1e9e: 322df7da             move.w     -$826(a5), d1
1ea2: 48c1                 ext.l      d1
1ea4: e989                 lsl.l      #$4, d1
1ea6: 204d                 movea.l    a5, a0
1ea8: d1c1                 adda.l     d1, a0
1eaa: c068b3f4             and.w      -$4c0c(a0), d0
1eae: 4640                 not.w      d0
1eb0: 3f00                 move.w     d0, -(a7)
1eb2: 486eff5c             pea.l      -$a4(a6)
1eb6: 3f2df7f4             move.w     -$80c(a5), -(a7)
1eba: 486ecf02             pea.l      -$30fe(a6)
1ebe: 486ecd98             pea.l      -$3268(a6)
1ec2: 4ebaf850             jsr        $1714(pc)
1ec6: 3b40f7f4             move.w     d0, -$80c(a5)
1eca: 4fef0010             lea.l      $10(a7), a7
1ece: 2f2df870             move.l     -$790(a5), -(a7)
1ed2: 486eff5c             pea.l      -$a4(a6)
1ed6: 3f2df7f4             move.w     -$80c(a5), -(a7)
1eda: 486ecf02             pea.l      -$30fe(a6)
1ede: 486ecd98             pea.l      -$3268(a6)
1ee2: 4ebaf7ee             jsr        $16d2(pc)
1ee6: 3b40f7f4             move.w     d0, -$80c(a5)
1eea: 2eadf870             move.l     -$790(a5), (a7)
1eee: 2f2da548             move.l     -$5ab8(a5), -(a7)
1ef2: 3f00                 move.w     d0, -(a7)
1ef4: 486ecd98             pea.l      -$3268(a6)
1ef8: 4ebaf896             jsr        $1790(pc)
1efc: 2440                 movea.l    d0, a2
1efe: 2e8c                 move.l     a4, (a7)
1f00: 4ead096a             jsr        $96a(a5) ; CODE31+0992
1f04: 42adb3e2             clr.l      -$4c1e(a5)
1f08: 4ead097a             jsr        $97a(a5) ; CODE32+09dc
1f0c: 48780154             pea.l      $154.w
1f10: 486da5f0             pea.l      -$5a10(a5)
1f14: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
1f18: 7022                 moveq      #$22, d0
1f1a: 2e80                 move.l     d0, (a7)
1f1c: 486efed4             pea.l      -$12c(a6)
1f20: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
1f24: 426dcf04             clr.w      -$30fc(a5)
1f28: 4ead0932             jsr        $932(a5) ; CODE31+0108
1f2c: 4a40                 tst.w      d0
1f2e: 4fef0028             lea.l      $28(a7), a7
1f32: 670000fa             beq.w      $202e
1f36: 486d0842             pea.l      $842(a5)
1f3a: 4ead09ba             jsr        $9ba(a5) ; CODE32+1304
1f3e: 0c6d0001cf04         cmpi.w     #$1, -$30fc(a5)
1f44: 588f                 addq.l     #$4, a7
1f46: 6704                 beq.b      $1f4c
1f48: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
1f4c: 41eefed4             lea.l      -$12c(a6), a0
1f50: 43eda5f0             lea.l      -$5a10(a5), a1
1f54: 7007                 moveq      #$7, d0
1f56: 20d9                 move.l     (a1)+, (a0)+
1f58: 51c8fffc             dbra       d0, $1f56
1f5c: 30d9                 move.w     (a1)+, (a0)+
1f5e: 3f3c0071             move.w     #$71, -(a7)
1f62: 2f0c                 move.l     a4, -(a7)
1f64: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
1f68: 4a80                 tst.l      d0
1f6a: 5c8f                 addq.l     #$6, a7
1f6c: 6722                 beq.b      $1f90
1f6e: 3f3c0071             move.w     #$71, -(a7)
1f72: 486efed4             pea.l      -$12c(a6)
1f76: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
1f7a: 4a80                 tst.l      d0
1f7c: 5c8f                 addq.l     #$6, a7
1f7e: 6610                 bne.b      $1f90
1f80: 486df8f0             pea.l      -$710(a5)
1f84: 486efed4             pea.l      -$12c(a6)
1f88: 4ead0daa             jsr        $daa(a5) ; CODE52+022c
1f8c: 508f                 addq.l     #$8, a7
1f8e: 6048                 bra.b      $1fd8
1f90: 3f3c0071             move.w     #$71, -(a7)
1f94: 486efed4             pea.l      -$12c(a6)
1f98: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
1f9c: 4a80                 tst.l      d0
1f9e: 5c8f                 addq.l     #$6, a7
1fa0: 6736                 beq.b      $1fd8
1fa2: 3f3c0075             move.w     #$75, -(a7)
1fa6: 486efed4             pea.l      -$12c(a6)
1faa: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
1fae: 2640                 movea.l    d0, a3
1fb0: 200b                 move.l     a3, d0
1fb2: 5c8f                 addq.l     #$6, a7
1fb4: 6722                 beq.b      $1fd8
1fb6: 486efed4             pea.l      -$12c(a6)
1fba: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
1fbe: 204e                 movea.l    a6, a0
1fc0: d1c0                 adda.l     d0, a0
1fc2: 16a8fed3             move.b     -$12d(a0), (a3)
1fc6: 486efed4             pea.l      -$12c(a6)
1fca: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
1fce: 204e                 movea.l    a6, a0
1fd0: d1c0                 adda.l     d0, a0
1fd2: 4228fed3             clr.b      -$12d(a0)
1fd6: 508f                 addq.l     #$8, a7
1fd8: 2f0c                 move.l     a4, -(a7)
1fda: 4ead0952             jsr        $952(a5) ; CODE31+071e
1fde: 47eefed4             lea.l      -$12c(a6), a3
1fe2: 588f                 addq.l     #$4, a7
1fe4: 600e                 bra.b      $1ff4
1fe6: 1013                 move.b     (a3), d0
1fe8: 4880                 ext.w      d0
1fea: 204d                 movea.l    a5, a0
1fec: d0c0                 adda.w     d0, a0
1fee: 5328a54e             subq.b     #$1, -$5ab2(a0)
1ff2: 528b                 addq.l     #$1, a3
1ff4: 4a13                 tst.b      (a3)
1ff6: 66ee                 bne.b      $1fe6
1ff8: 486eff4c             pea.l      -$b4(a6)
1ffc: 4ead0952             jsr        $952(a5) ; CODE31+071e
2000: 486eff4c             pea.l      -$b4(a6)
2004: 2f0c                 move.l     a4, -(a7)
2006: 4ead09a2             jsr        $9a2(a5) ; CODE32+11e6
200a: 3d40fef2             move.w     d0, -$10e(a6)
200e: 486efed4             pea.l      -$12c(a6)
2012: 4ead096a             jsr        $96a(a5) ; CODE31+0992
2016: 486efed4             pea.l      -$12c(a6)
201a: 4ead0952             jsr        $952(a5) ; CODE31+071e
201e: 2e8c                 move.l     a4, (a7)
2020: 4ead096a             jsr        $96a(a5) ; CODE31+0992
2024: 426dcf04             clr.w      -$30fc(a5)
2028: 4fef0014             lea.l      $14(a7), a7
202c: 600e                 bra.b      $203c
202e: 3d7c007ffef2         move.w     #$7f, -$10e(a6)
2034: 306dbcf2             movea.w    -$430e(a5), a0
2038: 2d48fee8             move.l     a0, -$118(a6)
203c: 486efed4             pea.l      -$12c(a6)
2040: 4ebaf600             jsr        $1642(pc)
2044: 486efed4             pea.l      -$12c(a6)
2048: 4ebaf0f0             jsr        $113a(pc)
204c: 48780080             pea.l      $80.w
2050: 486dce84             pea.l      -$317c(a5)
2054: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
2058: 2b7c0bebc200f8ec     move.l     #$bebc200, -$714(a5)
2060: 486d0a0a             pea.l      $a0a(a5)
2064: 4ead0a3a             jsr        $a3a(a5) ; CODE37+0004
2068: 2b6df8ecf880         move.l     -$714(a5), -$780(a5)
206e: 382dcf04             move.w     -$30fc(a5), d4
2072: 7600                 moveq      #$0, d3
2074: 47eda5f0             lea.l      -$5a10(a5), a3
2078: 4fef0014             lea.l      $14(a7), a7
207c: 600002ea             bra.w      $2368
2080: 41eefed4             lea.l      -$12c(a6), a0
2084: 43d3                 lea.l      (a3), a1
2086: 7007                 moveq      #$7, d0
2088: 20d9                 move.l     (a1)+, (a0)+
208a: 51c8fffc             dbra       d0, $2088
208e: 30d9                 move.w     (a1)+, (a0)+
2090: 4a2efef4             tst.b      -$10c(a6)
2094: 670002a4             beq.w      $233a
2098: 4a6e000c             tst.w      $c(a6)
209c: 661a                 bne.b      $20b8
209e: 4a43                 tst.w      d3
20a0: 6716                 beq.b      $20b8
20a2: 202efee4             move.l     -$11c(a6), d0
20a6: d0aefeec             add.l      -$114(a6), d0
20aa: 222da600             move.l     -$5a00(a5), d1
20ae: d2ada608             add.l      -$59f8(a5), d1
20b2: b280                 cmp.l      d0, d1
20b4: 6c000284             bge.w      $233a
20b8: 3b7c005acf04         move.w     #$5a, -$30fc(a5)
20be: 41eed06c             lea.l      -$2f94(a6), a0
20c2: 2b48cf24             move.l     a0, -$30dc(a5)
20c6: 7a00                 moveq      #$0, d5
20c8: 95ca                 suba.l     a2, a2
20ca: 6036                 bra.b      $2102
20cc: 48780042             pea.l      $42.w
20d0: 204a                 movea.l    a2, a0
20d2: d1edcf24             adda.l     -$30dc(a5), a0
20d6: 2f08                 move.l     a0, -(a7)
20d8: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
20dc: 2e2dcf24             move.l     -$30dc(a5), d7
20e0: de8a                 add.l      a2, d7
20e2: 2047                 movea.l    d7, a0
20e4: 216df8800004         move.l     -$780(a5), $4(a0)
20ea: 2047                 movea.l    d7, a0
20ec: 317cffff0036         move.w     #$ffff, $36(a0)
20f2: 3045                 movea.w    d5, a0
20f4: 2247                 movea.l    d7, a1
20f6: 23480028             move.l     a0, $28(a1)
20fa: 508f                 addq.l     #$8, a7
20fc: 5245                 addq.w     #$1, d5
20fe: 45ea0042             lea.l      $42(a2), a2
2102: ba6dcf04             cmp.w      -$30fc(a5), d5
2106: 6dc4                 blt.b      $20cc
2108: 4aadf8e4             tst.l      -$71c(a5)
210c: 6714                 beq.b      $2122
210e: 2f2df8e8             move.l     -$718(a5), -(a7)
2112: 3f3cffff             move.w     #$ffff, -(a7)
2116: 2f2df8e4             move.l     -$71c(a5), -(a7)
211a: 4ead0d9a             jsr        $d9a(a5) ; CODE52+0204
211e: 4fef000a             lea.l      $a(a7), a7
2122: 486df7dc             pea.l      -$824(a5)
2126: 4ead096a             jsr        $96a(a5) ; CODE31+0992
212a: 4ead0972             jsr        $972(a5) ; CODE32+0824
212e: 486df7dc             pea.l      -$824(a5)
2132: 486d0a12             pea.l      $a12(a5)
2136: 2f0c                 move.l     a4, -(a7)
2138: 486efed4             pea.l      -$12c(a6)
213c: 4ead0a32             jsr        $a32(a5) ; CODE37+0548
2140: 2e8c                 move.l     a4, (a7)
2142: 4ead096a             jsr        $96a(a5) ; CODE31+0992
2146: 4257                 clr.w      (a7)
2148: 2f0c                 move.l     a4, -(a7)
214a: 486efed4             pea.l      -$12c(a6)
214e: 4ead0942             jsr        $942(a5) ; CODE31+0184
2152: 486df7dc             pea.l      -$824(a5)
2156: 4ead096a             jsr        $96a(a5) ; CODE31+0992
215a: 486effdc             pea.l      -$24(a6)
215e: 4ead08fa             jsr        $8fa(a5) ; CODE31+0154
2162: 2eadcf24             move.l     -$30dc(a5), (a7)
2166: 4ebaf368             jsr        $14d0(pc)
216a: 2b40f874             move.l     d0, -$78c(a5)
216e: 486effdc             pea.l      -$24(a6)
2172: 4ead0902             jsr        $902(a5) ; CODE31+016c
2176: 2e8c                 move.l     a4, (a7)
2178: 4ead094a             jsr        $94a(a5) ; CODE31+0642
217c: 302df7d2             move.w     -$82e(a5), d0
2180: 204d                 movea.l    a5, a0
2182: 48c0                 ext.l      d0
2184: e588                 lsl.l      #$2, d0
2186: d1c0                 adda.l     d0, a0
2188: 70ff                 moveq      #$ff, d0
218a: d06899d8             add.w      -$6628(a0), d0
218e: 4640                 not.w      d0
2190: 3e80                 move.w     d0, (a7)
2192: 486eff5c             pea.l      -$a4(a6)
2196: 4267                 clr.w      -(a7)
2198: 486ecf02             pea.l      -$30fe(a6)
219c: 486ecd98             pea.l      -$3268(a6)
21a0: 4ebaf572             jsr        $1714(pc)
21a4: 3b40f7f4             move.w     d0, -$80c(a5)
21a8: 4a6df7d4             tst.w      -$82c(a5)
21ac: 4fef0036             lea.l      $36(a7), a7
21b0: 6742                 beq.b      $21f4
21b2: 302df7d2             move.w     -$82e(a5), d0
21b6: 204d                 movea.l    a5, a0
21b8: 48c0                 ext.l      d0
21ba: e588                 lsl.l      #$2, d0
21bc: d1c0                 adda.l     d0, a0
21be: 70ff                 moveq      #$ff, d0
21c0: d06899d8             add.w      -$6628(a0), d0
21c4: 322df7d4             move.w     -$82c(a5), d1
21c8: 48c1                 ext.l      d1
21ca: e989                 lsl.l      #$4, d1
21cc: 204d                 movea.l    a5, a0
21ce: d1c1                 adda.l     d1, a0
21d0: c068b3f4             and.w      -$4c0c(a0), d0
21d4: 4640                 not.w      d0
21d6: 3f00                 move.w     d0, -(a7)
21d8: 486eff5c             pea.l      -$a4(a6)
21dc: 3f2df7f4             move.w     -$80c(a5), -(a7)
21e0: 486ecf02             pea.l      -$30fe(a6)
21e4: 486ecd98             pea.l      -$3268(a6)
21e8: 4ebaf52a             jsr        $1714(pc)
21ec: 3b40f7f4             move.w     d0, -$80c(a5)
21f0: 4fef0010             lea.l      $10(a7), a7
21f4: 4a6df7d6             tst.w      -$82a(a5)
21f8: 6742                 beq.b      $223c
21fa: 302df7d2             move.w     -$82e(a5), d0
21fe: 204d                 movea.l    a5, a0
2200: 48c0                 ext.l      d0
2202: e588                 lsl.l      #$2, d0
2204: d1c0                 adda.l     d0, a0
2206: 70ff                 moveq      #$ff, d0
2208: d06899d8             add.w      -$6628(a0), d0
220c: 322df7d6             move.w     -$82a(a5), d1
2210: 48c1                 ext.l      d1
2212: e989                 lsl.l      #$4, d1
2214: 204d                 movea.l    a5, a0
2216: d1c1                 adda.l     d1, a0
2218: c068b3f4             and.w      -$4c0c(a0), d0
221c: 4640                 not.w      d0
221e: 3f00                 move.w     d0, -(a7)
2220: 486eff5c             pea.l      -$a4(a6)
2224: 3f2df7f4             move.w     -$80c(a5), -(a7)
2228: 486ecf02             pea.l      -$30fe(a6)
222c: 486ecd98             pea.l      -$3268(a6)
2230: 4ebaf4e2             jsr        $1714(pc)
2234: 3b40f7f4             move.w     d0, -$80c(a5)
2238: 4fef0010             lea.l      $10(a7), a7
223c: 4a6df7d8             tst.w      -$828(a5)
2240: 6742                 beq.b      $2284
2242: 302df7d2             move.w     -$82e(a5), d0
2246: 204d                 movea.l    a5, a0
2248: 48c0                 ext.l      d0
224a: e588                 lsl.l      #$2, d0
224c: d1c0                 adda.l     d0, a0
224e: 70ff                 moveq      #$ff, d0
2250: d06899d8             add.w      -$6628(a0), d0
2254: 322df7d8             move.w     -$828(a5), d1
2258: 48c1                 ext.l      d1
225a: e989                 lsl.l      #$4, d1
225c: 204d                 movea.l    a5, a0
225e: d1c1                 adda.l     d1, a0
2260: c068b3f4             and.w      -$4c0c(a0), d0
2264: 4640                 not.w      d0
2266: 3f00                 move.w     d0, -(a7)
2268: 486eff5c             pea.l      -$a4(a6)
226c: 3f2df7f4             move.w     -$80c(a5), -(a7)
2270: 486ecf02             pea.l      -$30fe(a6)
2274: 486ecd98             pea.l      -$3268(a6)
2278: 4ebaf49a             jsr        $1714(pc)
227c: 3b40f7f4             move.w     d0, -$80c(a5)
2280: 4fef0010             lea.l      $10(a7), a7
2284: 4a6df7da             tst.w      -$826(a5)
2288: 6742                 beq.b      $22cc
228a: 302df7d2             move.w     -$82e(a5), d0
228e: 204d                 movea.l    a5, a0
2290: 48c0                 ext.l      d0
2292: e588                 lsl.l      #$2, d0
2294: d1c0                 adda.l     d0, a0
2296: 70ff                 moveq      #$ff, d0
2298: d06899d8             add.w      -$6628(a0), d0
229c: 322df7da             move.w     -$826(a5), d1
22a0: 48c1                 ext.l      d1
22a2: e989                 lsl.l      #$4, d1
22a4: 204d                 movea.l    a5, a0
22a6: d1c1                 adda.l     d1, a0
22a8: c068b3f4             and.w      -$4c0c(a0), d0
22ac: 4640                 not.w      d0
22ae: 3f00                 move.w     d0, -(a7)
22b0: 486eff5c             pea.l      -$a4(a6)
22b4: 3f2df7f4             move.w     -$80c(a5), -(a7)
22b8: 486ecf02             pea.l      -$30fe(a6)
22bc: 486ecd98             pea.l      -$3268(a6)
22c0: 4ebaf452             jsr        $1714(pc)
22c4: 3b40f7f4             move.w     d0, -$80c(a5)
22c8: 4fef0010             lea.l      $10(a7), a7
22cc: 2f2df870             move.l     -$790(a5), -(a7)
22d0: 486eff5c             pea.l      -$a4(a6)
22d4: 3f2df7f4             move.w     -$80c(a5), -(a7)
22d8: 486ecf02             pea.l      -$30fe(a6)
22dc: 486ecd98             pea.l      -$3268(a6)
22e0: 4ebaf3f0             jsr        $16d2(pc)
22e4: 3b40f7f4             move.w     d0, -$80c(a5)
22e8: 2eadf874             move.l     -$78c(a5), (a7)
22ec: 486eff5c             pea.l      -$a4(a6)
22f0: 3f00                 move.w     d0, -(a7)
22f2: 486ecf02             pea.l      -$30fe(a6)
22f6: 486ecd98             pea.l      -$3268(a6)
22fa: 4ebaf3d6             jsr        $16d2(pc)
22fe: 3b40f7f4             move.w     d0, -$80c(a5)
2302: 2eadf870             move.l     -$790(a5), (a7)
2306: 2f2da548             move.l     -$5ab8(a5), -(a7)
230a: 3f00                 move.w     d0, -(a7)
230c: 486ecd98             pea.l      -$3268(a6)
2310: 4ebaf47e             jsr        $1790(pc)
2314: 2440                 movea.l    d0, a2
2316: 2eadf874             move.l     -$78c(a5), (a7)
231a: 2f0a                 move.l     a2, -(a7)
231c: 3f2df7f4             move.w     -$80c(a5), -(a7)
2320: 486ecd98             pea.l      -$3268(a6)
2324: 4ebaf46a             jsr        $1790(pc)
2328: 2440                 movea.l    d0, a2
232a: 2e8c                 move.l     a4, (a7)
232c: 4ead096a             jsr        $96a(a5) ; CODE31+0992
2330: 4ead0972             jsr        $972(a5) ; CODE32+0824
2334: 4fef0034             lea.l      $34(a7), a7
2338: 6004                 bra.b      $233e
233a: 42adf874             clr.l      -$78c(a5)
233e: 3b43cf04             move.w     d3, -$30fc(a5)
2342: 486efed4             pea.l      -$12c(a6)
2346: 4ebaf2fa             jsr        $1642(pc)
234a: 486efed4             pea.l      -$12c(a6)
234e: 4ebaedea             jsr        $113a(pc)
2352: 48780080             pea.l      $80.w
2356: 486dce84             pea.l      -$317c(a5)
235a: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
235e: 4fef0010             lea.l      $10(a7), a7
2362: 5243                 addq.w     #$1, d3
2364: 47eb0022             lea.l      $22(a3), a3
2368: b843                 cmp.w      d3, d4
236a: 6e00fd14             bgt.w      $2080
236e: 4aadf8e4             tst.l      -$71c(a5)
2372: 670e                 beq.b      $2382
2374: 2f2df8e4             move.l     -$71c(a5), -(a7)
2378: 4ead068a             jsr        $68a(a5) ; CODE9+00b4
237c: 42adf8e4             clr.l      -$71c(a5)
2380: 588f                 addq.l     #$4, a7
2382: 41eda5f0             lea.l      -$5a10(a5), a0
2386: 2008                 move.l     a0, d0
2388: 4cee1cf8cd32         movem.l    -$32ce(a6), d3-d7/a2-a4
238e: 4e5e                 unlk       a6
2390: 4e75                 rts        
