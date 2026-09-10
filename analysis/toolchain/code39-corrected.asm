0004: 4e56ffea             link.w     a6, #$ffea
0008: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
000c: 2f2e000c             move.l     $c(a6), -(a7)
0010: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
0014: 204d                 movea.l    a5, a0
0016: e588                 lsl.l      #$2, d0
0018: d1c0                 adda.l     d0, a0
001a: 3a3c0080             move.w     #$80, d5
001e: 9a6899d8             sub.w      -$6628(a0), d5
0022: 206e0018             movea.l    $18(a6), a0
0026: 4290                 clr.l      (a0)
0028: 226e0014             movea.l    $14(a6), a1
002c: 4291                 clr.l      (a1)
002e: 7019                 moveq      #$19, d0
0030: d0ae0008             add.l      $8(a6), d0
0034: 2840                 movea.l    d0, a4
0036: 1014                 move.b     (a4), d0
0038: 4880                 ext.w      d0
003a: 3e80                 move.w     d0, (a7)
003c: 3f3c007f             move.w     #$7f, -(a7)
0040: 4ead09aa             jsr        $9aa(a5) ; CODE32+1242
0044: 8045                 or.w       d5, d0
0046: 3d40fff2             move.w     d0, -$e(a6)
004a: 7c00                 moveq      #$0, d6
004c: 306e0010             movea.w    $10(a6), a0
0050: d1c8                 adda.l     a0, a0
0052: 2d48ffee             move.l     a0, -$12(a6)
0056: 366e0012             movea.w    $12(a6), a3
005a: d7cb                 adda.l     a3, a3
005c: 45edccfc             lea.l      -$3304(a5), a2
0060: d4c6                 adda.w     d6, a2
0062: d4c6                 adda.w     d6, a2
0064: 5c8f                 addq.l     #$6, a7
0066: 60000118             bra.w      $180
006a: 3612                 move.w     (a2), d3
006c: 3005                 move.w     d5, d0
006e: c043                 and.w      d3, d0
0070: b045                 cmp.w      d5, d0
0072: 66000108             bne.w      $17c
0076: 204d                 movea.l    a5, a0
0078: 2003                 move.l     d3, d0
007a: 48c0                 ext.l      d0
007c: e588                 lsl.l      #$2, d0
007e: d1c0                 adda.l     d0, a0
0080: 4aa8a756             tst.l      -$58aa(a0)
0084: 670000f6             beq.w      $17c
0088: 3f12                 move.w     (a2), -(a7)
008a: 3f3c007f             move.w     #$7f, -(a7)
008e: 4ead09aa             jsr        $9aa(a5) ; CODE32+1242
0092: 8045                 or.w       d5, d0
0094: 3600                 move.w     d0, d3
0096: 1814                 move.b     (a4), d4
0098: 4884                 ext.w      d4
009a: 3004                 move.w     d4, d0
009c: 8043                 or.w       d3, d0
009e: b840                 cmp.w      d0, d4
00a0: 588f                 addq.l     #$4, a7
00a2: 6704                 beq.b      $a8
00a4: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
00a8: 7012                 moveq      #$12, d0
00aa: c1c3                 muls.w     d3, d0
00ac: d0adcf0c             add.l      -$30f4(a5), d0
00b0: d0aeffee             add.l      -$12(a6), d0
00b4: 2040                 movea.l    d0, a0
00b6: 224d                 movea.l    a5, a1
00b8: 3012                 move.w     (a2), d0
00ba: 48c0                 ext.l      d0
00bc: e588                 lsl.l      #$2, d0
00be: d3c0                 adda.l     d0, a1
00c0: 3829a758             move.w     -$58a8(a1), d4
00c4: 9850                 sub.w      (a0), d4
00c6: 3f05                 move.w     d5, -(a7)
00c8: 3d43ffec             move.w     d3, -$14(a6)
00cc: 3f03                 move.w     d3, -(a7)
00ce: 3f2efff2             move.w     -$e(a6), -(a7)
00d2: 4ead09b2             jsr        $9b2(a5) ; CODE32+12ce
00d6: 3600                 move.w     d0, d3
00d8: 0c43007f             cmpi.w     #$7f, d3
00dc: 5c8f                 addq.l     #$6, a7
00de: 6632                 bne.b      $112
00e0: 7012                 moveq      #$12, d0
00e2: c1eeffec             muls.w     -$14(a6), d0
00e6: d0adcf10             add.l      -$30f0(a5), d0
00ea: 2040                 movea.l    d0, a0
00ec: 302e0010             move.w     $10(a6), d0
00f0: d0c0                 adda.w     d0, a0
00f2: 3d700000ffea         move.w     (a0, d0.w), -$16(a6)
00f8: 4a6effea             tst.w      -$16(a6)
00fc: 6f14                 ble.b      $112
00fe: 206dcf1c             movea.l    -$30e4(a5), a0
0102: 41e808ee             lea.l      $8ee(a0), a0
0106: d1eeffee             adda.l     -$12(a6), a0
010a: 3010                 move.w     (a0), d0
010c: d06effea             add.w      -$16(a6), d0
0110: d840                 add.w      d0, d4
0112: 206e0014             movea.l    $14(a6), a0
0116: 3244                 movea.w    d4, a1
0118: b3d0                 cmpa.l     (a0), a1
011a: 6f08                 ble.b      $124
011c: 3044                 movea.w    d4, a0
011e: 226e0014             movea.l    $14(a6), a1
0122: 2288                 move.l     a0, (a1)
0124: 7012                 moveq      #$12, d0
0126: c1c3                 muls.w     d3, d0
0128: d0adcf0c             add.l      -$30f4(a5), d0
012c: 2e00                 move.l     d0, d7
012e: 206e0018             movea.l    $18(a6), a0
0132: 226e0008             movea.l    $8(a6), a1
0136: 3012                 move.w     (a2), d0
0138: 48c0                 ext.l      d0
013a: e588                 lsl.l      #$2, d0
013c: 4878a756             pea.l      $a756.w
0140: d09f                 add.l      (a7)+, d0
0142: 3229000a             move.w     $a(a1), d1
0146: d2750802             add.w      $2(a5, d0.l), d1
014a: 92737800             sub.w      (a3, d7.l), d1
014e: 3241                 movea.w    d1, a1
0150: b3d0                 cmpa.l     (a0), a1
0152: 6f28                 ble.b      $17c
0154: 206e001c             movea.l    $1c(a6), a0
0158: 3083                 move.w     d3, (a0)
015a: 226e0008             movea.l    $8(a6), a1
015e: 204d                 movea.l    a5, a0
0160: 3012                 move.w     (a2), d0
0162: 48c0                 ext.l      d0
0164: e588                 lsl.l      #$2, d0
0166: d1c0                 adda.l     d0, a0
0168: 3029000a             move.w     $a(a1), d0
016c: d068a758             add.w      -$58a8(a0), d0
0170: 90737800             sub.w      (a3, d7.l), d0
0174: 3040                 movea.w    d0, a0
0176: 226e0018             movea.l    $18(a6), a1
017a: 2288                 move.l     a0, (a1)
017c: 5246                 addq.w     #$1, d6
017e: 548a                 addq.l     #$2, a2
0180: bc6dccfa             cmp.w      -$3306(a5), d6
0184: 6d00fee4             blt.w      $6a
0188: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
018c: 4e5e                 unlk       a6
018e: 4e75                 rts        
0190: 4e56da60             link.w     a6, #$da60
0194: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0198: 4a6e0008             tst.w      $8(a6)
019c: 6714                 beq.b      $1b2
019e: 2d6dcf0cda84         move.l     -$30f4(a5), -$257c(a6)
01a4: 2d6dcf10da76         move.l     -$30f0(a5), -$258a(a6)
01aa: 2d6dcf14da7c         move.l     -$30ec(a5), -$2584(a6)
01b0: 6012                 bra.b      $1c4
01b2: 2d6dcf18da84         move.l     -$30e8(a5), -$257c(a6)
01b8: 2d6dcf1cda76         move.l     -$30e4(a5), -$258a(a6)
01be: 2d6dcf20da7c         move.l     -$30e0(a5), -$2584(a6)
01c4: 2f2e000a             move.l     $a(a6), -(a7)
01c8: 4ead0aaa             jsr        $aaa(a5) ; CODE43+01dc
01cc: 2eae000a             move.l     $a(a6), (a7)
01d0: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
01d4: 204d                 movea.l    a5, a0
01d6: e588                 lsl.l      #$2, d0
01d8: d1c0                 adda.l     d0, a0
01da: 303c0080             move.w     #$80, d0
01de: 906899d8             sub.w      -$6628(a0), d0
01e2: 3d40da74             move.w     d0, -$258c(a6)
01e6: 7600                 moveq      #$0, d3
01e8: 3d43da7a             move.w     d3, -$2586(a6)
01ec: 45edccfc             lea.l      -$3304(a5), a2
01f0: d4c3                 adda.w     d3, a2
01f2: d4c3                 adda.w     d3, a2
01f4: 588f                 addq.l     #$4, a7
01f6: 6032                 bra.b      $22a
01f8: 3812                 move.w     (a2), d4
01fa: 707f                 moveq      #$7f, d0
01fc: 8044                 or.w       d4, d0
01fe: 0c40007f             cmpi.w     #$7f, d0
0202: 6704                 beq.b      $208
0204: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0208: 302eda74             move.w     -$258c(a6), d0
020c: c044                 and.w      d4, d0
020e: b06eda74             cmp.w      -$258c(a6), d0
0212: 6612                 bne.b      $226
0214: 302eda7a             move.w     -$2586(a6), d0
0218: 526eda7a             addq.w     #$1, -$2586(a6)
021c: 204e                 movea.l    a6, a0
021e: d0c0                 adda.w     d0, a0
0220: d0c0                 adda.w     d0, a0
0222: 3144fefc             move.w     d4, -$104(a0)
0226: 5243                 addq.w     #$1, d3
0228: 548a                 addq.l     #$2, a2
022a: b66dccfa             cmp.w      -$3306(a5), d3
022e: 6dc8                 blt.b      $1f8
0230: 45eedc9c             lea.l      -$2364(a6), a2
0234: 7600                 moveq      #$0, d3
0236: 47eefefc             lea.l      -$104(a6), a3
023a: 41eeda98             lea.l      -$2568(a6), a0
023e: 2d48da88             move.l     a0, -$2578(a6)
0242: 605a                 bra.b      $29e
0244: 206eda88             movea.l    -$2578(a6), a0
0248: 208a                 move.l     a2, (a0)
024a: 3813                 move.w     (a3), d4
024c: 3a03                 move.w     d3, d5
024e: 43eefefc             lea.l      -$104(a6), a1
0252: d2c5                 adda.w     d5, a1
0254: d2c5                 adda.w     d5, a1
0256: 2e09                 move.l     a1, d7
0258: 6036                 bra.b      $290
025a: 2047                 movea.l    d7, a0
025c: 3c10                 move.w     (a0), d6
025e: 3004                 move.w     d4, d0
0260: 8046                 or.w       d6, d0
0262: b840                 cmp.w      d0, d4
0264: 6626                 bne.b      $28c
0266: 204d                 movea.l    a5, a0
0268: 2006                 move.l     d6, d0
026a: 48c0                 ext.l      d0
026c: e588                 lsl.l      #$2, d0
026e: d1c0                 adda.l     d0, a0
0270: 4aa8a756             tst.l      -$58aa(a0)
0274: 6716                 beq.b      $28c
0276: 3f06                 move.w     d6, -(a7)
0278: 3f04                 move.w     d4, -(a7)
027a: 4ead09aa             jsr        $9aa(a5) ; CODE32+1242
027e: 806eda74             or.w       -$258c(a6), d0
0282: 3480                 move.w     d0, (a2)
0284: 35460002             move.w     d6, $2(a2)
0288: 588a                 addq.l     #$4, a2
028a: 588f                 addq.l     #$4, a7
028c: 5245                 addq.w     #$1, d5
028e: 5487                 addq.l     #$2, d7
0290: ba6eda7a             cmp.w      -$2586(a6), d5
0294: 6dc4                 blt.b      $25a
0296: 5243                 addq.w     #$1, d3
0298: 548b                 addq.l     #$2, a3
029a: 58aeda88             addq.l     #$4, -$2578(a6)
029e: b66eda7a             cmp.w      -$2586(a6), d3
02a2: 6da0                 blt.b      $244
02a4: 204e                 movea.l    a6, a0
02a6: 2003                 move.l     d3, d0
02a8: 48c0                 ext.l      d0
02aa: e588                 lsl.l      #$2, d0
02ac: d1c0                 adda.l     d0, a0
02ae: 214ada98             move.l     a2, -$2568(a0)
02b2: 7600                 moveq      #$0, d3
02b4: 45eefefc             lea.l      -$104(a6), a2
02b8: 602c                 bra.b      $2e6
02ba: 3812                 move.w     (a2), d4
02bc: 7012                 moveq      #$12, d0
02be: c1c4                 muls.w     d4, d0
02c0: 2640                 movea.l    d0, a3
02c2: 204b                 movea.l    a3, a0
02c4: d1eeda84             adda.l     -$257c(a6), a0
02c8: 4250                 clr.w      (a0)
02ca: 204b                 movea.l    a3, a0
02cc: d1eeda7c             adda.l     -$2584(a6), a0
02d0: 4250                 clr.w      (a0)
02d2: 204d                 movea.l    a5, a0
02d4: d0c4                 adda.w     d4, a0
02d6: d0c4                 adda.w     d4, a0
02d8: 224b                 movea.l    a3, a1
02da: d3eeda76             adda.l     -$258a(a6), a1
02de: 32a8cbfa             move.w     -$3406(a0), (a1)
02e2: 5243                 addq.w     #$1, d3
02e4: 548a                 addq.l     #$2, a2
02e6: b66eda7a             cmp.w      -$2586(a6), d3
02ea: 6dce                 blt.b      $2ba
02ec: 3d7c0001da74         move.w     #$1, -$258c(a6)
02f2: 3d7c0001da6a         move.w     #$1, -$2596(a6)
02f8: 7002                 moveq      #$2, d0
02fa: 2d40da88             move.l     d0, -$2578(a6)
02fe: 60000198             bra.w      $498
0302: 426eda74             clr.w      -$258c(a6)
0306: 7600                 moveq      #$0, d3
0308: 2e2eda88             move.l     -$2578(a6), d7
030c: 306eda6a             movea.w    -$2596(a6), a0
0310: d1c8                 adda.l     a0, a0
0312: 5588                 subq.l     #$2, a0
0314: 2d48da94             move.l     a0, -$256c(a6)
0318: 2003                 move.l     d3, d0
031a: 48c0                 ext.l      d0
031c: e588                 lsl.l      #$2, d0
031e: 43eeda98             lea.l      -$2568(a6), a1
0322: d089                 add.l      a1, d0
0324: 2d40da8c             move.l     d0, -$2574(a6)
0328: 43eefefc             lea.l      -$104(a6), a1
032c: d2c3                 adda.w     d3, a1
032e: d2c3                 adda.w     d3, a1
0330: 2d49da90             move.l     a1, -$2570(a6)
0334: 60000152             bra.w      $488
0338: 206eda90             movea.l    -$2570(a6), a0
033c: 3810                 move.w     (a0), d4
033e: 7012                 moveq      #$12, d0
0340: c1c4                 muls.w     d4, d0
0342: 2640                 movea.l    d0, a3
0344: 224b                 movea.l    a3, a1
0346: d3eeda84             adda.l     -$257c(a6), a1
034a: d3c7                 adda.l     d7, a1
034c: 2d49da70             move.l     a1, -$2590(a6)
0350: 284b                 movea.l    a3, a4
0352: d9eeda76             adda.l     -$258a(a6), a4
0356: d9c7                 adda.l     d7, a4
0358: 204b                 movea.l    a3, a0
035a: d1eeda7c             adda.l     -$2584(a6), a0
035e: d1c7                 adda.l     d7, a0
0360: 2d48da6c             move.l     a0, -$2594(a6)
0364: 3829fffe             move.w     -$2(a1), d4
0368: 3284                 move.w     d4, (a1)
036a: 48c4                 ext.l      d4
036c: 30a8fffe             move.w     -$2(a0), (a0)
0370: 38acfffe             move.w     -$2(a4), (a4)
0374: 670a                 beq.b      $380
0376: 3054                 movea.w    (a4), a0
0378: d1c8                 adda.l     a0, a0
037a: 70e8                 moveq      #$e8, d0
037c: d880                 add.l      d0, d4
037e: 9888                 sub.l      a0, d4
0380: 206eda8c             movea.l    -$2574(a6), a0
0384: 2450                 movea.l    (a0), a2
0386: 2003                 move.l     d3, d0
0388: 48c0                 ext.l      d0
038a: e588                 lsl.l      #$2, d0
038c: 47eeda9c             lea.l      -$2564(a6), a3
0390: d08b                 add.l      a3, d0
0392: 2640                 movea.l    d0, a3
0394: 600000c0             bra.w      $456
0398: 3c2a0002             move.w     $2(a2), d6
039c: 3a12                 move.w     (a2), d5
039e: 204d                 movea.l    a5, a0
03a0: 2006                 move.l     d6, d0
03a2: 48c0                 ext.l      d0
03a4: e588                 lsl.l      #$2, d0
03a6: d1c0                 adda.l     d0, a0
03a8: 7012                 moveq      #$12, d0
03aa: c1c5                 muls.w     d5, d0
03ac: d0aeda84             add.l      -$257c(a6), d0
03b0: d0aeda94             add.l      -$256c(a6), d0
03b4: 2240                 movea.l    d0, a1
03b6: 3251                 movea.w    (a1), a1
03b8: d3e8a756             adda.l     -$58aa(a0), a1
03bc: 2d49da62             move.l     a1, -$259e(a6)
03c0: 2d49da66             move.l     a1, -$259a(a6)
03c4: 7012                 moveq      #$12, d0
03c6: c1c5                 muls.w     d5, d0
03c8: 5580                 subq.l     #$2, d0
03ca: d0aeda76             add.l      -$258a(a6), d0
03ce: 2040                 movea.l    d0, a0
03d0: 302eda6a             move.w     -$2596(a6), d0
03d4: d0c0                 adda.w     d0, a0
03d6: 3d700000da60         move.w     (a0, d0.w), -$25a0(a6)
03dc: 7212                 moveq      #$12, d1
03de: c3c5                 muls.w     d5, d1
03e0: 5581                 subq.l     #$2, d1
03e2: d2aeda76             add.l      -$258a(a6), d1
03e6: 3040                 movea.w    d0, a0
03e8: d1c8                 adda.l     a0, a0
03ea: d288                 add.l      a0, d1
03ec: 2d41da80             move.l     d1, -$2580(a6)
03f0: 4a6eda60             tst.w      -$25a0(a6)
03f4: 670e                 beq.b      $404
03f6: 306eda60             movea.w    -$25a0(a6), a0
03fa: d1c8                 adda.l     a0, a0
03fc: 7018                 moveq      #$18, d0
03fe: d088                 add.l      a0, d0
0400: 91aeda66             sub.l      d0, -$259a(a6)
0404: b8aeda66             cmp.l      -$259a(a6), d4
0408: 6c4a                 bge.b      $454
040a: 204d                 movea.l    a5, a0
040c: 2006                 move.l     d6, d0
040e: 48c0                 ext.l      d0
0410: e588                 lsl.l      #$2, d0
0412: d1c0                 adda.l     d0, a0
0414: 2828cf30             move.l     -$30d0(a0), d4
0418: 7012                 moveq      #$12, d0
041a: c1c5                 muls.w     d5, d0
041c: 5580                 subq.l     #$2, d0
041e: d0aeda7c             add.l      -$2584(a6), d0
0422: 2040                 movea.l    d0, a0
0424: 302eda6a             move.w     -$2596(a6), d0
0428: d0c0                 adda.w     d0, a0
042a: 3c300000             move.w     (a0, d0.w), d6
042e: 3046                 movea.w    d6, a0
0430: b1c4                 cmpa.l     d4, a0
0432: 6f06                 ble.b      $43a
0434: 2006                 move.l     d6, d0
0436: 48c0                 ext.l      d0
0438: 6002                 bra.b      $43c
043a: 2004                 move.l     d4, d0
043c: 206eda6c             movea.l    -$2594(a6), a0
0440: 3080                 move.w     d0, (a0)
0442: 226eda80             movea.l    -$2580(a6), a1
0446: 3891                 move.w     (a1), (a4)
0448: 206eda70             movea.l    -$2590(a6), a0
044c: 30aeda64             move.w     -$259c(a6), (a0)
0450: 282eda66             move.l     -$259a(a6), d4
0454: 588a                 addq.l     #$4, a2
0456: b5d3                 cmpa.l     (a3), a2
0458: 6500ff3e             bcs.w      $398
045c: 206eda70             movea.l    -$2590(a6), a0
0460: 3010                 move.w     (a0), d0
0462: b060                 cmp.w      -(a0), d0
0464: 6612                 bne.b      $478
0466: 206eda6c             movea.l    -$2594(a6), a0
046a: 3010                 move.w     (a0), d0
046c: b060                 cmp.w      -(a0), d0
046e: 6608                 bne.b      $478
0470: 3014                 move.w     (a4), d0
0472: b06cfffe             cmp.w      -$2(a4), d0
0476: 6706                 beq.b      $47e
0478: 3d7c0001da74         move.w     #$1, -$258c(a6)
047e: 5243                 addq.w     #$1, d3
0480: 58aeda8c             addq.l     #$4, -$2574(a6)
0484: 54aeda90             addq.l     #$2, -$2570(a6)
0488: b66eda7a             cmp.w      -$2586(a6), d3
048c: 6d00feaa             blt.w      $338
0490: 526eda6a             addq.w     #$1, -$2596(a6)
0494: 54aeda88             addq.l     #$2, -$2578(a6)
0498: 4a6eda74             tst.w      -$258c(a6)
049c: 6600fe64             bne.w      $302
04a0: 7600                 moveq      #$0, d3
04a2: 3e2eda6a             move.w     -$2596(a6), d7
04a6: 48c7                 ext.l      d7
04a8: de87                 add.l      d7, d7
04aa: 45eefefc             lea.l      -$104(a6), a2
04ae: d4c3                 adda.w     d3, a2
04b0: d4c3                 adda.w     d3, a2
04b2: 6058                 bra.b      $50c
04b4: 3812                 move.w     (a2), d4
04b6: 7012                 moveq      #$12, d0
04b8: c1c4                 muls.w     d4, d0
04ba: 2640                 movea.l    d0, a3
04bc: 204b                 movea.l    a3, a0
04be: d1eeda84             adda.l     -$257c(a6), a0
04c2: d1c7                 adda.l     d7, a0
04c4: 2d48da70             move.l     a0, -$2590(a6)
04c8: 284b                 movea.l    a3, a4
04ca: d9eeda76             adda.l     -$258a(a6), a4
04ce: d9c7                 adda.l     d7, a4
04d0: 224b                 movea.l    a3, a1
04d2: d3eeda7c             adda.l     -$2584(a6), a1
04d6: d3c7                 adda.l     d7, a1
04d8: 2d49da6c             move.l     a1, -$2594(a6)
04dc: 3a2eda6a             move.w     -$2596(a6), d5
04e0: 6020                 bra.b      $502
04e2: 206eda70             movea.l    -$2590(a6), a0
04e6: 30a8fffe             move.w     -$2(a0), (a0)
04ea: 38acfffe             move.w     -$2(a4), (a4)
04ee: 226eda6c             movea.l    -$2594(a6), a1
04f2: 32a9fffe             move.w     -$2(a1), (a1)
04f6: 5245                 addq.w     #$1, d5
04f8: 54aeda70             addq.l     #$2, -$2590(a6)
04fc: 548c                 addq.l     #$2, a4
04fe: 54aeda6c             addq.l     #$2, -$2594(a6)
0502: 0c450009             cmpi.w     #$9, d5
0506: 6dda                 blt.b      $4e2
0508: 5243                 addq.w     #$1, d3
050a: 548a                 addq.l     #$2, a2
050c: b66eda7a             cmp.w      -$2586(a6), d3
0510: 6da2                 blt.b      $4b4
0512: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0516: 4e5e                 unlk       a6
0518: 4e75                 rts        
051a: 4e560000             link.w     a6, #$0
051e: 48e70108             movem.l    d7/a4, -(a7)
0522: 206e000a             movea.l    $a(a6), a0
0526: 4250                 clr.w      (a0)
0528: 7012                 moveq      #$12, d0
052a: c1ee0008             muls.w     $8(a6), d0
052e: 2840                 movea.l    d0, a4
0530: 202dcf14             move.l     -$30ec(a5), d0
0534: 226e000e             movea.l    $e(a6), a1
0538: 32b40810             move.w     $10(a4, d0.l), (a1)
053c: 7012                 moveq      #$12, d0
053e: c1ee0008             muls.w     $8(a6), d0
0542: 206dcf10             movea.l    -$30f0(a5), a0
0546: 3e300810             move.w     $10(a0, d0.l), d7
054a: 4a47                 tst.w      d7
054c: 6706                 beq.b      $554
054e: 3007                 move.w     d7, d0
0550: 4440                 neg.w      d0
0552: 6008                 bra.b      $55c
0554: 206dcf1c             movea.l    -$30e4(a5), a0
0558: 302808ee             move.w     $8ee(a0), d0
055c: 206dcf1c             movea.l    -$30e4(a5), a0
0560: 222dcf0c             move.l     -$30f4(a5), d1
0564: 342808ee             move.w     $8ee(a0), d2
0568: d4741810             add.w      $10(a4, d1.l), d2
056c: d042                 add.w      d2, d0
056e: 4cdf1080             movem.l    (a7)+, d7/a4
0572: 4e5e                 unlk       a6
0574: 4e75                 rts        
0576: 4e56ffec             link.w     a6, #$ffec
057a: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
057e: 7012                 moveq      #$12, d0
0580: c1ee0008             muls.w     $8(a6), d0
0584: 2840                 movea.l    d0, a4
0586: 264c                 movea.l    a4, a3
0588: d7edcf10             adda.l     -$30f0(a5), a3
058c: 7012                 moveq      #$12, d0
058e: c1ee000a             muls.w     $a(a6), d0
0592: 2440                 movea.l    d0, a2
0594: 2e2dcf1c             move.l     -$30e4(a5), d7
0598: de8a                 add.l      a2, d7
059a: 2c2dcf0c             move.l     -$30f4(a5), d6
059e: dc8c                 add.l      a4, d6
05a0: 204a                 movea.l    a2, a0
05a2: d1edcf18             adda.l     -$30e8(a5), a0
05a6: 2d48ffec             move.l     a0, -$14(a6)
05aa: 224c                 movea.l    a4, a1
05ac: d3edcf14             adda.l     -$30ec(a5), a1
05b0: 2d49fff0             move.l     a1, -$10(a6)
05b4: 284a                 movea.l    a2, a4
05b6: d9edcf20             adda.l     -$30e0(a5), a4
05ba: 3a2b0010             move.w     $10(a3), d5
05be: 2246                 movea.l    d6, a1
05c0: 38290010             move.w     $10(a1), d4
05c4: 98680010             sub.w      $10(a0), d4
05c8: 9845                 sub.w      d5, d4
05ca: 2247                 movea.l    d7, a1
05cc: 36290010             move.w     $10(a1), d3
05d0: 4a43                 tst.w      d3
05d2: 6704                 beq.b      $5d8
05d4: 3003                 move.w     d3, d0
05d6: 6004                 bra.b      $5dc
05d8: 3005                 move.w     d5, d0
05da: 4440                 neg.w      d0
05dc: d840                 add.w      d0, d4
05de: 206e000c             movea.l    $c(a6), a0
05e2: 30ac0010             move.w     $10(a4), (a0)
05e6: 226efff0             movea.l    -$10(a6), a1
05ea: 206e0010             movea.l    $10(a6), a0
05ee: 30a90010             move.w     $10(a1), (a0)
05f2: 7a07                 moveq      #$7, d5
05f4: 347c000e             movea.w    #$e, a2
05f8: 60000082             bra.w      $67c
05fc: 4a727800             tst.w      (a2, d7.l)
0600: 6632                 bne.b      $634
0602: 204b                 movea.l    a3, a0
0604: d1ca                 adda.l     a2, a0
0606: 3010                 move.w     (a0), d0
0608: d040                 add.w      d0, d0
060a: 204a                 movea.l    a2, a0
060c: d1eeffec             adda.l     -$14(a6), a0
0610: 36326800             move.w     (a2, d6.l), d3
0614: 9650                 sub.w      (a0), d3
0616: 9640                 sub.w      d0, d3
0618: b843                 cmp.w      d3, d4
061a: 6f18                 ble.b      $634
061c: 3803                 move.w     d3, d4
061e: 204c                 movea.l    a4, a0
0620: d1ca                 adda.l     a2, a0
0622: 226e000c             movea.l    $c(a6), a1
0626: 3290                 move.w     (a0), (a1)
0628: 204a                 movea.l    a2, a0
062a: d1eefff0             adda.l     -$10(a6), a0
062e: 226e0010             movea.l    $10(a6), a1
0632: 3290                 move.w     (a0), (a1)
0634: 204b                 movea.l    a3, a0
0636: d1ca                 adda.l     a2, a0
0638: 4a50                 tst.w      (a0)
063a: 663c                 bne.b      $678
063c: 3045                 movea.w    d5, a0
063e: 41f050fe             lea.l      -$2(a0, d5.w), a0
0642: 2d48fff4             move.l     a0, -$c(a6)
0646: 2248                 movea.l    a0, a1
0648: d3eeffec             adda.l     -$14(a6), a1
064c: 36326800             move.w     (a2, d6.l), d3
0650: 9651                 sub.w      (a1), d3
0652: 30307800             move.w     (a0, d7.l), d0
0656: d040                 add.w      d0, d0
0658: d640                 add.w      d0, d3
065a: b843                 cmp.w      d3, d4
065c: 6c1a                 bge.b      $678
065e: 3803                 move.w     d3, d4
0660: 204c                 movea.l    a4, a0
0662: d1eefff4             adda.l     -$c(a6), a0
0666: 226e000c             movea.l    $c(a6), a1
066a: 3290                 move.w     (a0), (a1)
066c: 204a                 movea.l    a2, a0
066e: d1eefff0             adda.l     -$10(a6), a0
0672: 226e0010             movea.l    $10(a6), a1
0676: 3290                 move.w     (a0), (a1)
0678: 5345                 subq.w     #$1, d5
067a: 558a                 subq.l     #$2, a2
067c: 4a45                 tst.w      d5
067e: 6e00ff7c             bgt.w      $5fc
0682: 3004                 move.w     d4, d0
0684: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0688: 4e5e                 unlk       a6
068a: 4e75                 rts        
068c: 4e560000             link.w     a6, #$0
0690: 48e70308             movem.l    d6-d7/a4, -(a7)
0694: 3c2e000a             move.w     $a(a6), d6
0698: 2f2e0010             move.l     $10(a6), -(a7)
069c: 2f2e000c             move.l     $c(a6), -(a7)
06a0: 3f06                 move.w     d6, -(a7)
06a2: 3f2e0008             move.w     $8(a6), -(a7)
06a6: 4ebafece             jsr        $576(pc)
06aa: 3e00                 move.w     d0, d7
06ac: 7012                 moveq      #$12, d0
06ae: c1c6                 muls.w     d6, d0
06b0: d0adcf1c             add.l      -$30e4(a5), d0
06b4: 2840                 movea.l    d0, a4
06b6: 7012                 moveq      #$12, d0
06b8: c1c6                 muls.w     d6, d0
06ba: 206dcf20             movea.l    -$30e0(a5), a0
06be: 7212                 moveq      #$12, d1
06c0: c3c6                 muls.w     d6, d1
06c2: 226dcf18             movea.l    -$30e8(a5), a1
06c6: 3414                 move.w     (a4), d2
06c8: d442                 add.w      d2, d2
06ca: d4711810             add.w      $10(a1, d1.l), d2
06ce: b4700810             cmp.w      $10(a0, d0.l), d2
06d2: 4fef000c             lea.l      $c(a7), a7
06d6: 661a                 bne.b      $6f2
06d8: 7012                 moveq      #$12, d0
06da: c1ee0008             muls.w     $8(a6), d0
06de: 206dcf0c             movea.l    -$30f4(a5), a0
06e2: 3214                 move.w     (a4), d1
06e4: d241                 add.w      d1, d1
06e6: d2700810             add.w      $10(a0, d0.l), d1
06ea: 9247                 sub.w      d7, d1
06ec: 226e000c             movea.l    $c(a6), a1
06f0: 3281                 move.w     d1, (a1)
06f2: 3007                 move.w     d7, d0
06f4: 4cdf10c0             movem.l    (a7)+, d6-d7/a4
06f8: 4e5e                 unlk       a6
06fa: 4e75                 rts        
