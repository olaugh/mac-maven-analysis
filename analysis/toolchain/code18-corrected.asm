0004: 4e56ffe8             link.w     a6, #$ffe8
0008: 48e70018             movem.l    a3-a4, -(a7)
000c: 266e0008             movea.l    $8(a6), a3
0010: 286e000c             movea.l    $c(a6), a4
0014: 4a2c0020             tst.b      $20(a4)
0018: 6730                 beq.b      $4a
001a: 2f0c                 move.l     a4, -(a7)
001c: 2f0c                 move.l     a4, -(a7)
001e: 2f2e0010             move.l     $10(a6), -(a7)
0022: 2f0c                 move.l     a4, -(a7)
0024: 4ead0db2             jsr        $db2(a5) ; CODE52+0242
0028: 4a40                 tst.w      d0
002a: 508f                 addq.l     #$8, a7
002c: 6708                 beq.b      $36
002e: 41ede9d2             lea.l      -$162e(a5), a0
0032: 2008                 move.l     a0, d0
0034: 6006                 bra.b      $3c
0036: 41ede9d6             lea.l      -$162a(a5), a0
003a: 2008                 move.l     a0, d0
003c: 2f00                 move.l     d0, -(a7)
003e: 2f0b                 move.l     a3, -(a7)
0040: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0044: 4fef0010             lea.l      $10(a7), a7
0048: 6044                 bra.b      $8e
004a: 4a14                 tst.b      (a4)
004c: 660e                 bne.b      $5c
004e: 486de9dc             pea.l      -$1624(a5)
0052: 2f0b                 move.l     a3, -(a7)
0054: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0058: 508f                 addq.l     #$8, a7
005a: 6032                 bra.b      $8e
005c: 206e0010             movea.l    $10(a6), a0
0060: 4a280020             tst.b      $20(a0)
0064: 661c                 bne.b      $82
0066: 2f0c                 move.l     a4, -(a7)
0068: 486effe8             pea.l      -$18(a6)
006c: 4ead07ea             jsr        $7ea(a5) ; CODE23+01fe
0070: 2e80                 move.l     d0, (a7)
0072: 486de9e4             pea.l      -$161c(a5)
0076: 2f0b                 move.l     a3, -(a7)
0078: 4ead0812             jsr        $812(a5) ; CODE24+16a6
007c: 4fef0010             lea.l      $10(a7), a7
0080: 600c                 bra.b      $8e
0082: 486de9f0             pea.l      -$1610(a5)
0086: 2f0b                 move.l     a3, -(a7)
0088: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
008c: 508f                 addq.l     #$8, a7
008e: 200b                 move.l     a3, d0
0090: 4cdf1800             movem.l    (a7)+, a3-a4
0094: 4e5e                 unlk       a6
0096: 4e75                 rts        
0098: 4e56ff5c             link.w     a6, #$ff5c
009c: 48e71f00             movem.l    d3-d7, -(a7)
00a0: 3e2e0008             move.w     $8(a6), d7
00a4: 4a47                 tst.w      d7
00a6: 6604                 bne.b      $ac
00a8: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
00ac: 486eff70             pea.l      -$90(a6)
00b0: 4ead095a             jsr        $95a(a5) ; CODE31+075c
00b4: 0c474e20             cmpi.w     #$4e20, d7
00b8: 588f                 addq.l     #$4, a7
00ba: 662a                 bne.b      $e6
00bc: 4a6e000c             tst.w      $c(a6)
00c0: 670a                 beq.b      $cc
00c2: 41ede9fc             lea.l      -$1604(a5), a0
00c6: 2008                 move.l     a0, d0
00c8: 600004d4             bra.w      $59e
00cc: 4a6e000a             tst.w      $a(a6)
00d0: 6f0a                 ble.b      $dc
00d2: 41edea28             lea.l      -$15d8(a5), a0
00d6: 2008                 move.l     a0, d0
00d8: 600004c4             bra.w      $59e
00dc: 41edea4e             lea.l      -$15b2(a5), a0
00e0: 2008                 move.l     a0, d0
00e2: 600004ba             bra.w      $59e
00e6: 0c478001             cmpi.w     #$8001, d7
00ea: 660a                 bne.b      $f6
00ec: 41edea74             lea.l      -$158c(a5), a0
00f0: 2008                 move.l     a0, d0
00f2: 600004aa             bra.w      $59e
00f6: 0c47ffff             cmpi.w     #$ffff, d7
00fa: 660a                 bne.b      $106
00fc: 41edea7a             lea.l      -$1586(a5), a0
0100: 2008                 move.l     a0, d0
0102: 6000049a             bra.w      $59e
0106: 0c47fffe             cmpi.w     #$fffe, d7
010a: 660a                 bne.b      $116
010c: 41edea92             lea.l      -$156e(a5), a0
0110: 2008                 move.l     a0, d0
0112: 6000048a             bra.w      $59e
0116: 0c47ffe0             cmpi.w     #$ffe0, d7
011a: 660a                 bne.b      $126
011c: 41edeaaa             lea.l      -$1556(a5), a0
0120: 2008                 move.l     a0, d0
0122: 6000047a             bra.w      $59e
0126: 0c47ffdf             cmpi.w     #$ffdf, d7
012a: 660a                 bne.b      $136
012c: 41edeaba             lea.l      -$1546(a5), a0
0130: 2008                 move.l     a0, d0
0132: 6000046a             bra.w      $59e
0136: 0c47fffd             cmpi.w     #$fffd, d7
013a: 661a                 bne.b      $156
013c: 4a6e000c             tst.w      $c(a6)
0140: 670a                 beq.b      $14c
0142: 41edeaca             lea.l      -$1536(a5), a0
0146: 2008                 move.l     a0, d0
0148: 60000454             bra.w      $59e
014c: 41edeb0a             lea.l      -$14f6(a5), a0
0150: 2008                 move.l     a0, d0
0152: 6000044a             bra.w      $59e
0156: 0c4707da             cmpi.w     #$7da, d7
015a: 660a                 bne.b      $166
015c: 41edeb26             lea.l      -$14da(a5), a0
0160: 2008                 move.l     a0, d0
0162: 6000043a             bra.w      $59e
0166: 0c47fffc             cmpi.w     #$fffc, d7
016a: 660a                 bne.b      $176
016c: 41edeb3c             lea.l      -$14c4(a5), a0
0170: 2008                 move.l     a0, d0
0172: 6000042a             bra.w      $59e
0176: 0c47fffb             cmpi.w     #$fffb, d7
017a: 6e00008c             bgt.w      $208
017e: 0c47ffe1             cmpi.w     #$ffe1, d7
0182: 6d000084             blt.w      $208
0186: 70fb                 moveq      #$fb, d0
0188: 9047                 sub.w      d7, d0
018a: 206d99d2             movea.l    -$662e(a5), a0
018e: 10300000             move.b     (a0, d0.w), d0
0192: 4880                 ext.w      d0
0194: 224e                 movea.l    a6, a1
0196: d2c0                 adda.w     d0, a1
0198: 4a29ff70             tst.b      -$90(a1)
019c: 662a                 bne.b      $1c8
019e: 70fb                 moveq      #$fb, d0
01a0: 9047                 sub.w      d7, d0
01a2: 206d99d2             movea.l    -$662e(a5), a0
01a6: 10300000             move.b     (a0, d0.w), d0
01aa: 4880                 ext.w      d0
01ac: 3f00                 move.w     d0, -(a7)
01ae: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
01b2: 3e80                 move.w     d0, (a7)
01b4: 486deb60             pea.l      -$14a0(a5)
01b8: 486de972             pea.l      -$168e(a5)
01bc: 4ead0812             jsr        $812(a5) ; CODE24+16a6
01c0: 4fef000a             lea.l      $a(a7), a7
01c4: 600003d2             bra.w      $598
01c8: 70fb                 moveq      #$fb, d0
01ca: 9047                 sub.w      d7, d0
01cc: 206d99d2             movea.l    -$662e(a5), a0
01d0: 10300000             move.b     (a0, d0.w), d0
01d4: 4880                 ext.w      d0
01d6: 3f00                 move.w     d0, -(a7)
01d8: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
01dc: 3e80                 move.w     d0, (a7)
01de: 4a6e000a             tst.w      $a(a6)
01e2: 6f08                 ble.b      $1ec
01e4: 41edeb74             lea.l      -$148c(a5), a0
01e8: 2008                 move.l     a0, d0
01ea: 6006                 bra.b      $1f2
01ec: 41edeb78             lea.l      -$1488(a5), a0
01f0: 2008                 move.l     a0, d0
01f2: 2f00                 move.l     d0, -(a7)
01f4: 486deb7e             pea.l      -$1482(a5)
01f8: 486de972             pea.l      -$168e(a5)
01fc: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0200: 4fef000e             lea.l      $e(a7), a7
0204: 60000392             bra.w      $598
0208: 2007                 move.l     d7, d0
020a: 48c0                 ext.l      d0
020c: e788                 lsl.l      #$3, d0
020e: 206dd55a             movea.l    -$2aa6(a5), a0
0212: 4a300806             tst.b      $6(a0, d0.l)
0216: 6632                 bne.b      $24a
0218: 2007                 move.l     d7, d0
021a: 48c0                 ext.l      d0
021c: e788                 lsl.l      #$3, d0
021e: 206dd55a             movea.l    -$2aa6(a5), a0
0222: 30700802             movea.w    $2(a0, d0.l), a0
0226: d1edd560             adda.l     -$2aa0(a5), a0
022a: 2f08                 move.l     a0, -(a7)
022c: 486efff0             pea.l      -$10(a6)
0230: 4ead07ea             jsr        $7ea(a5) ; CODE23+01fe
0234: 2e80                 move.l     d0, (a7)
0236: 486deb94             pea.l      -$146c(a5)
023a: 486de972             pea.l      -$168e(a5)
023e: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0242: 4fef0010             lea.l      $10(a7), a7
0246: 60000350             bra.w      $598
024a: 7c00                 moveq      #$0, d6
024c: 3606                 move.w     d6, d3
024e: 3a06                 move.w     d6, d5
0250: 3806                 move.w     d6, d4
0252: 3d47ff60             move.w     d7, -$a0(a6)
0256: 604e                 bra.b      $2a6
0258: 302eff60             move.w     -$a0(a6), d0
025c: 48c0                 ext.l      d0
025e: e788                 lsl.l      #$3, d0
0260: 206dd55a             movea.l    -$2aa6(a5), a0
0264: 10300806             move.b     $6(a0, d0.l), d0
0268: 4880                 ext.w      d0
026a: 3d40ff66             move.w     d0, -$9a(a6)
026e: 322eff60             move.w     -$a0(a6), d1
0272: 48c1                 ext.l      d1
0274: e789                 lsl.l      #$3, d1
0276: 12301807             move.b     $7(a0, d1.l), d1
027a: 4881                 ext.w      d1
027c: 3d41ff68             move.w     d1, -$98(a6)
0280: ba40                 cmp.w      d0, d5
0282: 6c04                 bge.b      $288
0284: 3a2eff66             move.w     -$9a(a6), d5
0288: b86eff66             cmp.w      -$9a(a6), d4
028c: 6f04                 ble.b      $292
028e: 382eff66             move.w     -$9a(a6), d4
0292: bc6eff68             cmp.w      -$98(a6), d6
0296: 6c04                 bge.b      $29c
0298: 3c2eff68             move.w     -$98(a6), d6
029c: b66eff68             cmp.w      -$98(a6), d3
02a0: 6f04                 ble.b      $2a6
02a2: 362eff68             move.w     -$98(a6), d3
02a6: 302eff60             move.w     -$a0(a6), d0
02aa: 48c0                 ext.l      d0
02ac: e788                 lsl.l      #$3, d0
02ae: d0add55a             add.l      -$2aa6(a5), d0
02b2: 2040                 movea.l    d0, a0
02b4: 3d50ff60             move.w     (a0), -$a0(a6)
02b8: 669e                 bne.b      $258
02ba: 2007                 move.l     d7, d0
02bc: 48c0                 ext.l      d0
02be: e788                 lsl.l      #$3, d0
02c0: 206dd55a             movea.l    -$2aa6(a5), a0
02c4: 10300807             move.b     $7(a0, d0.l), d0
02c8: 4880                 ext.w      d0
02ca: d046                 add.w      d6, d0
02cc: 0c40000f             cmpi.w     #$f, d0
02d0: 6602                 bne.b      $2d4
02d2: 5246                 addq.w     #$1, d6
02d4: 2007                 move.l     d7, d0
02d6: 48c0                 ext.l      d0
02d8: e788                 lsl.l      #$3, d0
02da: 206dd55a             movea.l    -$2aa6(a5), a0
02de: 10300807             move.b     $7(a0, d0.l), d0
02e2: 4880                 ext.w      d0
02e4: d043                 add.w      d3, d0
02e6: 5340                 subq.w     #$1, d0
02e8: 6602                 bne.b      $2ec
02ea: 5343                 subq.w     #$1, d3
02ec: 2007                 move.l     d7, d0
02ee: 48c0                 ext.l      d0
02f0: e788                 lsl.l      #$3, d0
02f2: 206dd55a             movea.l    -$2aa6(a5), a0
02f6: 10300806             move.b     $6(a0, d0.l), d0
02fa: 4880                 ext.w      d0
02fc: d045                 add.w      d5, d0
02fe: 0c40000f             cmpi.w     #$f, d0
0302: 6602                 bne.b      $306
0304: 5245                 addq.w     #$1, d5
0306: 2007                 move.l     d7, d0
0308: 48c0                 ext.l      d0
030a: e788                 lsl.l      #$3, d0
030c: 206dd55a             movea.l    -$2aa6(a5), a0
0310: 10300806             move.b     $6(a0, d0.l), d0
0314: 4880                 ext.w      d0
0316: d044                 add.w      d4, d0
0318: 5340                 subq.w     #$1, d0
031a: 6602                 bne.b      $31e
031c: 5344                 subq.w     #$1, d4
031e: 3005                 move.w     d5, d0
0320: 9044                 sub.w      d4, d0
0322: 3206                 move.w     d6, d1
0324: 9243                 sub.w      d3, d1
0326: b240                 cmp.w      d0, d1
0328: 6c000128             bge.w      $452
032c: 3006                 move.w     d6, d0
032e: 9043                 sub.w      d3, d0
0330: 67000254             beq.w      $586
0334: 6b000250             bmi.w      $586
0338: 5740                 subq.w     #$3, d0
033a: 6734                 beq.b      $370
033c: 6a000248             bpl.w      $586
0340: 5240                 addq.w     #$1, d0
0342: 6a16                 bpl.b      $35a
0344: 2007                 move.l     d7, d0
0346: 48c0                 ext.l      d0
0348: e788                 lsl.l      #$3, d0
034a: 206dd55a             movea.l    -$2aa6(a5), a0
034e: 10300807             move.b     $7(a0, d0.l), d0
0352: 4880                 ext.w      d0
0354: 3d40ff62             move.w     d0, -$9e(a6)
0358: 6052                 bra.b      $3ac
035a: 2007                 move.l     d7, d0
035c: 48c0                 ext.l      d0
035e: e788                 lsl.l      #$3, d0
0360: 206dd55a             movea.l    -$2aa6(a5), a0
0364: 10300807             move.b     $7(a0, d0.l), d0
0368: 4880                 ext.w      d0
036a: 3d40ff62             move.w     d0, -$9e(a6)
036e: 603c                 bra.b      $3ac
0370: 0c43ffff             cmpi.w     #$ffff, d3
0374: 6618                 bne.b      $38e
0376: 2007                 move.l     d7, d0
0378: 48c0                 ext.l      d0
037a: e788                 lsl.l      #$3, d0
037c: 206dd55a             movea.l    -$2aa6(a5), a0
0380: 10300807             move.b     $7(a0, d0.l), d0
0384: 4880                 ext.w      d0
0386: 5240                 addq.w     #$1, d0
0388: 3d40ff62             move.w     d0, -$9e(a6)
038c: 601e                 bra.b      $3ac
038e: 0c43fffe             cmpi.w     #$fffe, d3
0392: 660001f2             bne.w      $586
0396: 2007                 move.l     d7, d0
0398: 48c0                 ext.l      d0
039a: e788                 lsl.l      #$3, d0
039c: 206dd55a             movea.l    -$2aa6(a5), a0
03a0: 10300807             move.b     $7(a0, d0.l), d0
03a4: 4880                 ext.w      d0
03a6: 5340                 subq.w     #$1, d0
03a8: 3d40ff62             move.w     d0, -$9e(a6)
03ac: 066e0040ff62         addi.w     #$40, -$9e(a6)
03b2: 2007                 move.l     d7, d0
03b4: 48c0                 ext.l      d0
03b6: e788                 lsl.l      #$3, d0
03b8: 206dd55a             movea.l    -$2aa6(a5), a0
03bc: 10300807             move.b     $7(a0, d0.l), d0
03c0: 4880                 ext.w      d0
03c2: d046                 add.w      d6, d0
03c4: 0c400010             cmpi.w     #$10, d0
03c8: 6602                 bne.b      $3cc
03ca: 5346                 subq.w     #$1, d6
03cc: 2007                 move.l     d7, d0
03ce: 48c0                 ext.l      d0
03d0: e788                 lsl.l      #$3, d0
03d2: 206dd55a             movea.l    -$2aa6(a5), a0
03d6: 10300807             move.b     $7(a0, d0.l), d0
03da: 4880                 ext.w      d0
03dc: d043                 add.w      d3, d0
03de: 6602                 bne.b      $3e2
03e0: 5243                 addq.w     #$1, d3
03e2: 2007                 move.l     d7, d0
03e4: 48c0                 ext.l      d0
03e6: e788                 lsl.l      #$3, d0
03e8: 206dd55a             movea.l    -$2aa6(a5), a0
03ec: 10300806             move.b     $6(a0, d0.l), d0
03f0: 4880                 ext.w      d0
03f2: d045                 add.w      d5, d0
03f4: 0c400010             cmpi.w     #$10, d0
03f8: 6602                 bne.b      $3fc
03fa: 5345                 subq.w     #$1, d5
03fc: 2007                 move.l     d7, d0
03fe: 48c0                 ext.l      d0
0400: e788                 lsl.l      #$3, d0
0402: 206dd55a             movea.l    -$2aa6(a5), a0
0406: 10300806             move.b     $6(a0, d0.l), d0
040a: 4880                 ext.w      d0
040c: d044                 add.w      d4, d0
040e: 6602                 bne.b      $412
0410: 5244                 addq.w     #$1, d4
0412: 2007                 move.l     d7, d0
0414: 48c0                 ext.l      d0
0416: e788                 lsl.l      #$3, d0
0418: 206dd55a             movea.l    -$2aa6(a5), a0
041c: 10300806             move.b     $6(a0, d0.l), d0
0420: 4880                 ext.w      d0
0422: d045                 add.w      d5, d0
0424: 3f00                 move.w     d0, -(a7)
0426: 3f2eff62             move.w     -$9e(a6), -(a7)
042a: 2007                 move.l     d7, d0
042c: 48c0                 ext.l      d0
042e: e788                 lsl.l      #$3, d0
0430: 10300806             move.b     $6(a0, d0.l), d0
0434: 4880                 ext.w      d0
0436: d044                 add.w      d4, d0
0438: 3f00                 move.w     d0, -(a7)
043a: 3f2eff62             move.w     -$9e(a6), -(a7)
043e: 486deba2             pea.l      -$145e(a5)
0442: 486de972             pea.l      -$168e(a5)
0446: 4ead0812             jsr        $812(a5) ; CODE24+16a6
044a: 4fef0010             lea.l      $10(a7), a7
044e: 60000148             bra.w      $598
0452: 3005                 move.w     d5, d0
0454: 9044                 sub.w      d4, d0
0456: 3206                 move.w     d6, d1
0458: 9243                 sub.w      d3, d1
045a: b240                 cmp.w      d0, d1
045c: 6d000128             blt.w      $586
0460: 3005                 move.w     d5, d0
0462: 9044                 sub.w      d4, d0
0464: 67000120             beq.w      $586
0468: 6b00011c             bmi.w      $586
046c: 5740                 subq.w     #$3, d0
046e: 6734                 beq.b      $4a4
0470: 6a000114             bpl.w      $586
0474: 5240                 addq.w     #$1, d0
0476: 6a16                 bpl.b      $48e
0478: 2007                 move.l     d7, d0
047a: 48c0                 ext.l      d0
047c: e788                 lsl.l      #$3, d0
047e: 206dd55a             movea.l    -$2aa6(a5), a0
0482: 10300806             move.b     $6(a0, d0.l), d0
0486: 4880                 ext.w      d0
0488: 3d40ff64             move.w     d0, -$9c(a6)
048c: 6052                 bra.b      $4e0
048e: 2007                 move.l     d7, d0
0490: 48c0                 ext.l      d0
0492: e788                 lsl.l      #$3, d0
0494: 206dd55a             movea.l    -$2aa6(a5), a0
0498: 10300806             move.b     $6(a0, d0.l), d0
049c: 4880                 ext.w      d0
049e: 3d40ff64             move.w     d0, -$9c(a6)
04a2: 603c                 bra.b      $4e0
04a4: 0c44ffff             cmpi.w     #$ffff, d4
04a8: 6618                 bne.b      $4c2
04aa: 2007                 move.l     d7, d0
04ac: 48c0                 ext.l      d0
04ae: e788                 lsl.l      #$3, d0
04b0: 206dd55a             movea.l    -$2aa6(a5), a0
04b4: 10300806             move.b     $6(a0, d0.l), d0
04b8: 4880                 ext.w      d0
04ba: 5240                 addq.w     #$1, d0
04bc: 3d40ff64             move.w     d0, -$9c(a6)
04c0: 601e                 bra.b      $4e0
04c2: 0c44fffe             cmpi.w     #$fffe, d4
04c6: 660000be             bne.w      $586
04ca: 2007                 move.l     d7, d0
04cc: 48c0                 ext.l      d0
04ce: e788                 lsl.l      #$3, d0
04d0: 206dd55a             movea.l    -$2aa6(a5), a0
04d4: 10300806             move.b     $6(a0, d0.l), d0
04d8: 4880                 ext.w      d0
04da: 5340                 subq.w     #$1, d0
04dc: 3d40ff64             move.w     d0, -$9c(a6)
04e0: 2007                 move.l     d7, d0
04e2: 48c0                 ext.l      d0
04e4: e788                 lsl.l      #$3, d0
04e6: 206dd55a             movea.l    -$2aa6(a5), a0
04ea: 10300807             move.b     $7(a0, d0.l), d0
04ee: 4880                 ext.w      d0
04f0: d046                 add.w      d6, d0
04f2: 0c400010             cmpi.w     #$10, d0
04f6: 6602                 bne.b      $4fa
04f8: 5346                 subq.w     #$1, d6
04fa: 2007                 move.l     d7, d0
04fc: 48c0                 ext.l      d0
04fe: e788                 lsl.l      #$3, d0
0500: 206dd55a             movea.l    -$2aa6(a5), a0
0504: 10300807             move.b     $7(a0, d0.l), d0
0508: 4880                 ext.w      d0
050a: d043                 add.w      d3, d0
050c: 6602                 bne.b      $510
050e: 5243                 addq.w     #$1, d3
0510: 2007                 move.l     d7, d0
0512: 48c0                 ext.l      d0
0514: e788                 lsl.l      #$3, d0
0516: 206dd55a             movea.l    -$2aa6(a5), a0
051a: 10300806             move.b     $6(a0, d0.l), d0
051e: 4880                 ext.w      d0
0520: d045                 add.w      d5, d0
0522: 0c400010             cmpi.w     #$10, d0
0526: 6602                 bne.b      $52a
0528: 5345                 subq.w     #$1, d5
052a: 2007                 move.l     d7, d0
052c: 48c0                 ext.l      d0
052e: e788                 lsl.l      #$3, d0
0530: 206dd55a             movea.l    -$2aa6(a5), a0
0534: 10300806             move.b     $6(a0, d0.l), d0
0538: 4880                 ext.w      d0
053a: d044                 add.w      d4, d0
053c: 6602                 bne.b      $540
053e: 5244                 addq.w     #$1, d4
0540: 2007                 move.l     d7, d0
0542: 48c0                 ext.l      d0
0544: e788                 lsl.l      #$3, d0
0546: 206dd55a             movea.l    -$2aa6(a5), a0
054a: 10300807             move.b     $7(a0, d0.l), d0
054e: 4880                 ext.w      d0
0550: d046                 add.w      d6, d0
0552: 06400040             addi.w     #$40, d0
0556: 3f00                 move.w     d0, -(a7)
0558: 3f2eff64             move.w     -$9c(a6), -(a7)
055c: 2007                 move.l     d7, d0
055e: 48c0                 ext.l      d0
0560: e788                 lsl.l      #$3, d0
0562: 10300807             move.b     $7(a0, d0.l), d0
0566: 4880                 ext.w      d0
0568: d043                 add.w      d3, d0
056a: 06400040             addi.w     #$40, d0
056e: 3f00                 move.w     d0, -(a7)
0570: 3f2eff64             move.w     -$9c(a6), -(a7)
0574: 486debb8             pea.l      -$1448(a5)
0578: 486de972             pea.l      -$168e(a5)
057c: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0580: 4fef0010             lea.l      $10(a7), a7
0584: 6012                 bra.b      $598
0586: 3f07                 move.w     d7, -(a7)
0588: 486debce             pea.l      -$1432(a5)
058c: 486de972             pea.l      -$168e(a5)
0590: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0594: 4fef000a             lea.l      $a(a7), a7
0598: 41ede972             lea.l      -$168e(a5), a0
059c: 2008                 move.l     a0, d0
059e: 4cdf00f8             movem.l    (a7)+, d3-d7
05a2: 4e5e                 unlk       a6
05a4: 4e75                 rts        
05a6: 4e560000             link.w     a6, #$0
05aa: 48e70308             movem.l    d6-d7/a4, -(a7)
05ae: 3c2e0008             move.w     $8(a6), d6
05b2: 2006                 move.l     d6, d0
05b4: 48c0                 ext.l      d0
05b6: 81fc0064             divs.w     #$64, d0
05ba: c1fc0064             muls.w     #$64, d0
05be: 3e06                 move.w     d6, d7
05c0: 9e40                 sub.w      d0, d7
05c2: 4a47                 tst.w      d7
05c4: 6d06                 blt.b      $5cc
05c6: 0c470064             cmpi.w     #$64, d7
05ca: 6d04                 blt.b      $5d0
05cc: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
05d0: 0c470002             cmpi.w     #$2, d7
05d4: 6c0e                 bge.b      $5e4
05d6: 0c460001             cmpi.w     #$1, d6
05da: 6f08                 ble.b      $5e4
05dc: 49edebd8             lea.l      -$1428(a5), a4
05e0: 6000009c             bra.w      $67e
05e4: 4a46                 tst.w      d6
05e6: 6c06                 bge.b      $5ee
05e8: 3006                 move.w     d6, d0
05ea: 4440                 neg.w      d0
05ec: 6002                 bra.b      $5f0
05ee: 3006                 move.w     d6, d0
05f0: 0c40000a             cmpi.w     #$a, d0
05f4: 6c08                 bge.b      $5fe
05f6: 49edebe6             lea.l      -$141a(a5), a4
05fa: 60000082             bra.w      $67e
05fe: 4a46                 tst.w      d6
0600: 6c06                 bge.b      $608
0602: 3006                 move.w     d6, d0
0604: 4440                 neg.w      d0
0606: 6002                 bra.b      $60a
0608: 3006                 move.w     d6, d0
060a: 0c40001e             cmpi.w     #$1e, d0
060e: 6c06                 bge.b      $616
0610: 49edebf0             lea.l      -$1410(a5), a4
0614: 6068                 bra.b      $67e
0616: 4a46                 tst.w      d6
0618: 6c06                 bge.b      $620
061a: 3006                 move.w     d6, d0
061c: 4440                 neg.w      d0
061e: 6002                 bra.b      $622
0620: 3006                 move.w     d6, d0
0622: 0c400032             cmpi.w     #$32, d0
0626: 6c06                 bge.b      $62e
0628: 49edebfa             lea.l      -$1406(a5), a4
062c: 6050                 bra.b      $67e
062e: 0c47000a             cmpi.w     #$a, d7
0632: 6c06                 bge.b      $63a
0634: 49edec04             lea.l      -$13fc(a5), a4
0638: 6044                 bra.b      $67e
063a: 0c470019             cmpi.w     #$19, d7
063e: 6c06                 bge.b      $646
0640: 49edec1c             lea.l      -$13e4(a5), a4
0644: 6038                 bra.b      $67e
0646: 0c470030             cmpi.w     #$30, d7
064a: 6c06                 bge.b      $652
064c: 49edec34             lea.l      -$13cc(a5), a4
0650: 602c                 bra.b      $67e
0652: 0c470034             cmpi.w     #$34, d7
0656: 6c06                 bge.b      $65e
0658: 49edec4a             lea.l      -$13b6(a5), a4
065c: 6020                 bra.b      $67e
065e: 0c47003c             cmpi.w     #$3c, d7
0662: 6c06                 bge.b      $66a
0664: 49edec5a             lea.l      -$13a6(a5), a4
0668: 6014                 bra.b      $67e
066a: 0c47004b             cmpi.w     #$4b, d7
066e: 6c06                 bge.b      $676
0670: 49edec74             lea.l      -$138c(a5), a4
0674: 6008                 bra.b      $67e
0676: 06460064             addi.w     #$64, d6
067a: 49edec8e             lea.l      -$1372(a5), a4
067e: 2e06                 move.l     d6, d7
0680: 48c7                 ext.l      d7
0682: 8ffc0064             divs.w     #$64, d7
0686: 0c470001             cmpi.w     #$1, d7
068a: 6608                 bne.b      $694
068c: 41edeca4             lea.l      -$135c(a5), a0
0690: 2008                 move.l     a0, d0
0692: 6006                 bra.b      $69a
0694: 41edeca6             lea.l      -$135a(a5), a0
0698: 2008                 move.l     a0, d0
069a: 2f00                 move.l     d0, -(a7)
069c: 3f07                 move.w     d7, -(a7)
069e: 2f0c                 move.l     a4, -(a7)
06a0: 486de9b2             pea.l      -$164e(a5)
06a4: 4ead0812             jsr        $812(a5) ; CODE24+16a6
06a8: 41ede9b2             lea.l      -$164e(a5), a0
06ac: 2008                 move.l     a0, d0
06ae: 4cee10c0fff4         movem.l    -$c(a6), d6-d7/a4
06b4: 4e5e                 unlk       a6
06b6: 4e75                 rts        
06b8: 4e560000             link.w     a6, #$0
06bc: 4a6e0008             tst.w      $8(a6)
06c0: 6c38                 bge.b      $6fa
06c2: 4ead05b2             jsr        $5b2(a5) ; CODE4+0004
06c6: 48780003             pea.l      $3.w
06ca: 2f00                 move.l     d0, -(a7)
06cc: 4ead0052             jsr        $52(a5) ; CODE1+0144
06d0: 4a80                 tst.l      d0
06d2: 670a                 beq.b      $6de
06d4: 6b20                 bmi.b      $6f6
06d6: 5580                 subq.l     #$2, d0
06d8: 6714                 beq.b      $6ee
06da: 6a1a                 bpl.b      $6f6
06dc: 6008                 bra.b      $6e6
06de: 41edeca8             lea.l      -$1358(a5), a0
06e2: 2008                 move.l     a0, d0
06e4: 603a                 bra.b      $720
06e6: 41edecae             lea.l      -$1352(a5), a0
06ea: 2008                 move.l     a0, d0
06ec: 6032                 bra.b      $720
06ee: 41edecb8             lea.l      -$1348(a5), a0
06f2: 2008                 move.l     a0, d0
06f4: 602a                 bra.b      $720
06f6: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
06fa: 4ead05b2             jsr        $5b2(a5) ; CODE4+0004
06fe: 7201                 moveq      #$1, d1
0700: c280                 and.l      d0, d1
0702: 6708                 beq.b      $70c
0704: 6b16                 bmi.b      $71c
0706: 5581                 subq.l     #$2, d1
0708: 6a12                 bpl.b      $71c
070a: 6008                 bra.b      $714
070c: 41edecbe             lea.l      -$1342(a5), a0
0710: 2008                 move.l     a0, d0
0712: 600c                 bra.b      $720
0714: 41edecc6             lea.l      -$133a(a5), a0
0718: 2008                 move.l     a0, d0
071a: 6004                 bra.b      $720
071c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0720: 4e5e                 unlk       a6
0722: 4e75                 rts        
0724: 4e560000             link.w     a6, #$0
0728: 48e70f18             movem.l    d4-d7/a3-a4, -(a7)
072c: 3e2e0008             move.w     $8(a6), d7
0730: 3c2e000a             move.w     $a(a6), d6
0734: 4a47                 tst.w      d7
0736: 6604                 bne.b      $73c
0738: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
073c: 4a46                 tst.w      d6
073e: 6604                 bne.b      $744
0740: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0744: 4a47                 tst.w      d7
0746: 6f0001ac             ble.w      $8f4
074a: be6dd55e             cmp.w      -$2aa2(a5), d7
074e: 6c0001a4             bge.w      $8f4
0752: 2007                 move.l     d7, d0
0754: 48c0                 ext.l      d0
0756: e788                 lsl.l      #$3, d0
0758: 206dd55a             movea.l    -$2aa6(a5), a0
075c: 4a300806             tst.b      $6(a0, d0.l)
0760: 6654                 bne.b      $7b6
0762: 2007                 move.l     d7, d0
0764: 48c0                 ext.l      d0
0766: e788                 lsl.l      #$3, d0
0768: 206dd55a             movea.l    -$2aa6(a5), a0
076c: 30700802             movea.w    $2(a0, d0.l), a0
0770: d1edd560             adda.l     -$2aa0(a5), a0
0774: 2f08                 move.l     a0, -(a7)
0776: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
077a: 5380                 subq.l     #$1, d0
077c: 588f                 addq.l     #$4, a7
077e: 6636                 bne.b      $7b6
0780: 2007                 move.l     d7, d0
0782: 48c0                 ext.l      d0
0784: e788                 lsl.l      #$3, d0
0786: 206dd55a             movea.l    -$2aa6(a5), a0
078a: 30700802             movea.w    $2(a0, d0.l), a0
078e: d1edd560             adda.l     -$2aa0(a5), a0
0792: 1010                 move.b     (a0), d0
0794: 4880                 ext.w      d0
0796: 3f00                 move.w     d0, -(a7)
0798: 2f2d99d2             move.l     -$662e(a5), -(a7)
079c: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
07a0: 90ad99d2             sub.l      -$662e(a5), d0
07a4: 72fb                 moveq      #$fb, d1
07a6: 9280                 sub.l      d0, d1
07a8: 3046                 movea.w    d6, a0
07aa: b288                 cmp.l      a0, d1
07ac: 5c8f                 addq.l     #$6, a7
07ae: 6606                 bne.b      $7b6
07b0: 7001                 moveq      #$1, d0
07b2: 60000142             bra.w      $8f6
07b6: 2007                 move.l     d7, d0
07b8: 48c0                 ext.l      d0
07ba: e788                 lsl.l      #$3, d0
07bc: 206dd55a             movea.l    -$2aa6(a5), a0
07c0: 4a300806             tst.b      $6(a0, d0.l)
07c4: 6662                 bne.b      $828
07c6: 4a46                 tst.w      d6
07c8: 6f5e                 ble.b      $828
07ca: bc6dd55e             cmp.w      -$2aa2(a5), d6
07ce: 6c58                 bge.b      $828
07d0: 2006                 move.l     d6, d0
07d2: 48c0                 ext.l      d0
07d4: e788                 lsl.l      #$3, d0
07d6: 206dd55a             movea.l    -$2aa6(a5), a0
07da: 4a300806             tst.b      $6(a0, d0.l)
07de: 6648                 bne.b      $828
07e0: 2007                 move.l     d7, d0
07e2: 48c0                 ext.l      d0
07e4: e788                 lsl.l      #$3, d0
07e6: 206dd55a             movea.l    -$2aa6(a5), a0
07ea: 38700802             movea.w    $2(a0, d0.l), a4
07ee: d9edd560             adda.l     -$2aa0(a5), a4
07f2: 2006                 move.l     d6, d0
07f4: 48c0                 ext.l      d0
07f6: e788                 lsl.l      #$3, d0
07f8: 36700802             movea.w    $2(a0, d0.l), a3
07fc: d7edd560             adda.l     -$2aa0(a5), a3
0800: 6018                 bra.b      $81a
0802: 1013                 move.b     (a3), d0
0804: 4880                 ext.w      d0
0806: 3f00                 move.w     d0, -(a7)
0808: 2f0c                 move.l     a4, -(a7)
080a: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
080e: 2840                 movea.l    d0, a4
0810: 200c                 move.l     a4, d0
0812: 5c8f                 addq.l     #$6, a7
0814: 6708                 beq.b      $81e
0816: 528b                 addq.l     #$1, a3
0818: 528c                 addq.l     #$1, a4
081a: 4a13                 tst.b      (a3)
081c: 66e4                 bne.b      $802
081e: 200c                 move.l     a4, d0
0820: 6706                 beq.b      $828
0822: 7001                 moveq      #$1, d0
0824: 600000d0             bra.w      $8f6
0828: 2007                 move.l     d7, d0
082a: 48c0                 ext.l      d0
082c: e788                 lsl.l      #$3, d0
082e: 206dd55a             movea.l    -$2aa6(a5), a0
0832: 4a300806             tst.b      $6(a0, d0.l)
0836: 670000bc             beq.w      $8f4
083a: 4a46                 tst.w      d6
083c: 6f0000b6             ble.w      $8f4
0840: bc6dd55e             cmp.w      -$2aa2(a5), d6
0844: 6c0000ae             bge.w      $8f4
0848: 2006                 move.l     d6, d0
084a: 48c0                 ext.l      d0
084c: e788                 lsl.l      #$3, d0
084e: 206dd55a             movea.l    -$2aa6(a5), a0
0852: 4a300806             tst.b      $6(a0, d0.l)
0856: 6700009c             beq.w      $8f4
085a: 2006                 move.l     d6, d0
085c: 48c0                 ext.l      d0
085e: e788                 lsl.l      #$3, d0
0860: 206dd55a             movea.l    -$2aa6(a5), a0
0864: 2207                 move.l     d7, d1
0866: 48c1                 ext.l      d1
0868: e789                 lsl.l      #$3, d1
086a: 12301806             move.b     $6(a0, d1.l), d1
086e: b2300806             cmp.b      $6(a0, d0.l), d1
0872: 66000080             bne.w      $8f4
0876: 2006                 move.l     d6, d0
0878: 48c0                 ext.l      d0
087a: e788                 lsl.l      #$3, d0
087c: 206dd55a             movea.l    -$2aa6(a5), a0
0880: 2207                 move.l     d7, d1
0882: 48c1                 ext.l      d1
0884: e789                 lsl.l      #$3, d1
0886: 12301807             move.b     $7(a0, d1.l), d1
088a: b2300807             cmp.b      $7(a0, d0.l), d1
088e: 6664                 bne.b      $8f4
0890: 3a06                 move.w     d6, d5
0892: 604c                 bra.b      $8e0
0894: 3807                 move.w     d7, d4
0896: 6034                 bra.b      $8cc
0898: 2004                 move.l     d4, d0
089a: 48c0                 ext.l      d0
089c: e788                 lsl.l      #$3, d0
089e: 206dd55a             movea.l    -$2aa6(a5), a0
08a2: 2205                 move.l     d5, d1
08a4: 48c1                 ext.l      d1
08a6: e789                 lsl.l      #$3, d1
08a8: 12301806             move.b     $6(a0, d1.l), d1
08ac: b2300806             cmp.b      $6(a0, d0.l), d1
08b0: 661a                 bne.b      $8cc
08b2: 2004                 move.l     d4, d0
08b4: 48c0                 ext.l      d0
08b6: e788                 lsl.l      #$3, d0
08b8: 206dd55a             movea.l    -$2aa6(a5), a0
08bc: 2205                 move.l     d5, d1
08be: 48c1                 ext.l      d1
08c0: e789                 lsl.l      #$3, d1
08c2: 12301807             move.b     $7(a0, d1.l), d1
08c6: b2300807             cmp.b      $7(a0, d0.l), d1
08ca: 6710                 beq.b      $8dc
08cc: 2004                 move.l     d4, d0
08ce: 48c0                 ext.l      d0
08d0: e788                 lsl.l      #$3, d0
08d2: d0add55a             add.l      -$2aa6(a5), d0
08d6: 2040                 movea.l    d0, a0
08d8: 3810                 move.w     (a0), d4
08da: 66bc                 bne.b      $898
08dc: 4a44                 tst.w      d4
08de: 6714                 beq.b      $8f4
08e0: 2005                 move.l     d5, d0
08e2: 48c0                 ext.l      d0
08e4: e788                 lsl.l      #$3, d0
08e6: d0add55a             add.l      -$2aa6(a5), d0
08ea: 2040                 movea.l    d0, a0
08ec: 3a10                 move.w     (a0), d5
08ee: 66a4                 bne.b      $894
08f0: 7001                 moveq      #$1, d0
08f2: 6002                 bra.b      $8f6
08f4: 7000                 moveq      #$0, d0
08f6: 4cdf18f0             movem.l    (a7)+, d4-d7/a3-a4
08fa: 4e5e                 unlk       a6
08fc: 4e75                 rts        
08fe: 4e56fdde             link.w     a6, #$fdde
0902: 2f06                 move.l     d6, -(a7)
0904: 3c2e000c             move.w     $c(a6), d6
0908: 526dde84             addq.w     #$1, -$217c(a5)
090c: 4a6e000a             tst.w      $a(a6)
0910: 673c                 beq.b      $94e
0912: 4a46                 tst.w      d6
0914: 6c06                 bge.b      $91c
0916: 3006                 move.w     d6, d0
0918: 4440                 neg.w      d0
091a: 6002                 bra.b      $91e
091c: 3006                 move.w     d6, d0
091e: 3f00                 move.w     d0, -(a7)
0920: 4ebafc84             jsr        $5a6(pc)
0924: 2f00                 move.l     d0, -(a7)
0926: 2f2e000e             move.l     $e(a6), -(a7)
092a: 3f2e000a             move.w     $a(a6), -(a7)
092e: 3f06                 move.w     d6, -(a7)
0930: 3f2e0008             move.w     $8(a6), -(a7)
0934: 4ebaf762             jsr        $98(pc)
0938: 548f                 addq.l     #$2, a7
093a: 2e80                 move.l     d0, (a7)
093c: 486deccc             pea.l      -$1334(a5)
0940: 486efe00             pea.l      -$200(a6)
0944: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0948: 4fef0016             lea.l      $16(a7), a7
094c: 6044                 bra.b      $992
094e: 4a46                 tst.w      d6
0950: 6c06                 bge.b      $958
0952: 3006                 move.w     d6, d0
0954: 4440                 neg.w      d0
0956: 6002                 bra.b      $95a
0958: 3006                 move.w     d6, d0
095a: 3f00                 move.w     d0, -(a7)
095c: 4ebafc48             jsr        $5a6(pc)
0960: 2f00                 move.l     d0, -(a7)
0962: 2f2e000e             move.l     $e(a6), -(a7)
0966: 3f06                 move.w     d6, -(a7)
0968: 4ebafd4e             jsr        $6b8(pc)
096c: 548f                 addq.l     #$2, a7
096e: 2f00                 move.l     d0, -(a7)
0970: 3f2e000a             move.w     $a(a6), -(a7)
0974: 3f06                 move.w     d6, -(a7)
0976: 3f2e0008             move.w     $8(a6), -(a7)
097a: 4ebaf71c             jsr        $98(pc)
097e: 548f                 addq.l     #$2, a7
0980: 2e80                 move.l     d0, (a7)
0982: 486dece6             pea.l      -$131a(a5)
0986: 486efe00             pea.l      -$200(a6)
098a: 4ead0812             jsr        $812(a5) ; CODE24+16a6
098e: 4fef001a             lea.l      $1a(a7), a7
0992: 486efe00             pea.l      -$200(a6)
0996: 4eba0326             jsr        $cbe(pc)
099a: 2c2efdda             move.l     -$226(a6), d6
099e: 4e5e                 unlk       a6
09a0: 4e75                 rts        
09a2: 4e560000             link.w     a6, #$0
09a6: 3f2e0008             move.w     $8(a6), -(a7)
09aa: 4ead09f2             jsr        $9f2(a5) ; CODE35+0034
09ae: 4a40                 tst.w      d0
09b0: 57c0                 seq.b      d0
09b2: 4400                 neg.b      d0
09b4: 4880                 ext.w      d0
09b6: 4e5e                 unlk       a6
09b8: 4e75                 rts        
09ba: 4e56ff00             link.w     a6, #$ff00
09be: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
09c2: 206e0008             movea.l    $8(a6), a0
09c6: 2e280010             move.l     $10(a0), d7
09ca: 47e80010             lea.l      $10(a0), a3
09ce: 226e0018             movea.l    $18(a6), a1
09d2: 2c290010             move.l     $10(a1), d6
09d6: 49e90010             lea.l      $10(a1), a4
09da: bc87                 cmp.l      d7, d6
09dc: 661c                 bne.b      $9fa
09de: 486dde9b             pea.l      -$2165(a5)
09e2: 486dde86             pea.l      -$217a(a5)
09e6: 486decf8             pea.l      -$1308(a5)
09ea: 486eff00             pea.l      -$100(a6)
09ee: 4ead0812             jsr        $812(a5) ; CODE24+16a6
09f2: 4fef0010             lea.l      $10(a7), a7
09f6: 6000008c             bra.w      $a84
09fa: bc87                 cmp.l      d7, d6
09fc: 6c44                 bge.b      $a42
09fe: 2013                 move.l     (a3), d0
0a00: 9094                 sub.l      (a4), d0
0a02: 7264                 moveq      #$64, d1
0a04: b280                 cmp.l      d0, d1
0a06: 6608                 bne.b      $a10
0a08: 41eded14             lea.l      -$12ec(a5), a0
0a0c: 2008                 move.l     a0, d0
0a0e: 6006                 bra.b      $a16
0a10: 41eded16             lea.l      -$12ea(a5), a0
0a14: 2008                 move.l     a0, d0
0a16: 2f00                 move.l     d0, -(a7)
0a18: 48780064             pea.l      $64.w
0a1c: 2013                 move.l     (a3), d0
0a1e: 9094                 sub.l      (a4), d0
0a20: 2f00                 move.l     d0, -(a7)
0a22: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0a26: 2f00                 move.l     d0, -(a7)
0a28: 486dde9b             pea.l      -$2165(a5)
0a2c: 486dde86             pea.l      -$217a(a5)
0a30: 486ded18             pea.l      -$12e8(a5)
0a34: 486eff00             pea.l      -$100(a6)
0a38: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0a3c: 4fef0018             lea.l      $18(a7), a7
0a40: 6042                 bra.b      $a84
0a42: 2014                 move.l     (a4), d0
0a44: 9093                 sub.l      (a3), d0
0a46: 7264                 moveq      #$64, d1
0a48: b280                 cmp.l      d0, d1
0a4a: 6608                 bne.b      $a54
0a4c: 41eded3a             lea.l      -$12c6(a5), a0
0a50: 2008                 move.l     a0, d0
0a52: 6006                 bra.b      $a5a
0a54: 41eded3c             lea.l      -$12c4(a5), a0
0a58: 2008                 move.l     a0, d0
0a5a: 2f00                 move.l     d0, -(a7)
0a5c: 48780064             pea.l      $64.w
0a60: 2014                 move.l     (a4), d0
0a62: 9093                 sub.l      (a3), d0
0a64: 2f00                 move.l     d0, -(a7)
0a66: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0a6a: 2f00                 move.l     d0, -(a7)
0a6c: 486dde86             pea.l      -$217a(a5)
0a70: 486dde9b             pea.l      -$2165(a5)
0a74: 486ded3e             pea.l      -$12c2(a5)
0a78: 486eff00             pea.l      -$100(a6)
0a7c: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0a80: 4fef0018             lea.l      $18(a7), a7
0a84: 486eff00             pea.l      -$100(a6)
0a88: 4eba0234             jsr        $cbe(pc)
0a8c: 4cee18c0fef0         movem.l    -$110(a6), d6-d7/a3-a4
0a92: 4e5e                 unlk       a6
0a94: 4e75                 rts        
0a96: 4e56fdea             link.w     a6, #$fdea
0a9a: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0a9e: 2e2e000c             move.l     $c(a6), d7
0aa2: 7a00                 moveq      #$0, d5
0aa4: 3605                 move.w     d5, d3
0aa6: 7c00                 moveq      #$0, d6
0aa8: 99cc                 suba.l     a4, a4
0aaa: 6022                 bra.b      $ace
0aac: 244c                 movea.l    a4, a2
0aae: d5ee0010             adda.l     $10(a6), a2
0ab2: 4a52                 tst.w      (a2)
0ab4: 6714                 beq.b      $aca
0ab6: 3f347800             move.w     (a4, d7.l), -(a7)
0aba: 206e0028             movea.l    $28(a6), a0
0abe: 4e90                 jsr        (a0)
0ac0: 4a40                 tst.w      d0
0ac2: 548f                 addq.l     #$2, a7
0ac4: 6704                 beq.b      $aca
0ac6: 5245                 addq.w     #$1, d5
0ac8: d652                 add.w      (a2), d3
0aca: 5246                 addq.w     #$1, d6
0acc: 548c                 addq.l     #$2, a4
0ace: 4a747800             tst.w      (a4, d7.l)
0ad2: 66d8                 bne.b      $aac
0ad4: 7c00                 moveq      #$0, d6
0ad6: 99cc                 suba.l     a4, a4
0ad8: 6026                 bra.b      $b00
0ada: 244c                 movea.l    a4, a2
0adc: d5ee0020             adda.l     $20(a6), a2
0ae0: 4a52                 tst.w      (a2)
0ae2: 6718                 beq.b      $afc
0ae4: 204c                 movea.l    a4, a0
0ae6: d1ee001c             adda.l     $1c(a6), a0
0aea: 3f10                 move.w     (a0), -(a7)
0aec: 206e0028             movea.l    $28(a6), a0
0af0: 4e90                 jsr        (a0)
0af2: 4a40                 tst.w      d0
0af4: 548f                 addq.l     #$2, a7
0af6: 6704                 beq.b      $afc
0af8: 5245                 addq.w     #$1, d5
0afa: 9652                 sub.w      (a2), d3
0afc: 5246                 addq.w     #$1, d6
0afe: 548c                 addq.l     #$2, a4
0b00: 204c                 movea.l    a4, a0
0b02: d1ee001c             adda.l     $1c(a6), a0
0b06: 4a50                 tst.w      (a0)
0b08: 66d0                 bne.b      $ada
0b0a: 4a45                 tst.w      d5
0b0c: 662c                 bne.b      $b3a
0b0e: 4a43                 tst.w      d3
0b10: 6704                 beq.b      $b16
0b12: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0b16: 2f2e002c             move.l     $2c(a6), -(a7)
0b1a: 486dde9b             pea.l      -$2165(a5)
0b1e: 486dde86             pea.l      -$217a(a5)
0b22: 486ded60             pea.l      -$12a0(a5)
0b26: 486efdfe             pea.l      -$202(a6)
0b2a: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0b2e: 486efdfe             pea.l      -$202(a6)
0b32: 4eba018a             jsr        $cbe(pc)
0b36: 6000009e             bra.w      $bd6
0b3a: 2f2e0030             move.l     $30(a6), -(a7)
0b3e: 4a43                 tst.w      d3
0b40: 6f08                 ble.b      $b4a
0b42: 41edde86             lea.l      -$217a(a5), a0
0b46: 2008                 move.l     a0, d0
0b48: 6006                 bra.b      $b50
0b4a: 41edde9b             lea.l      -$2165(a5), a0
0b4e: 2008                 move.l     a0, d0
0b50: 2f00                 move.l     d0, -(a7)
0b52: 486ded70             pea.l      -$1290(a5)
0b56: 486efdfe             pea.l      -$202(a6)
0b5a: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0b5e: 486efdfe             pea.l      -$202(a6)
0b62: 4eba015a             jsr        $cbe(pc)
0b66: 4a43                 tst.w      d3
0b68: 4fef0014             lea.l      $14(a7), a7
0b6c: 6f10                 ble.b      $b7e
0b6e: 49edde86             lea.l      -$217a(a5), a4
0b72: 2447                 movea.l    d7, a2
0b74: 266e0010             movea.l    $10(a6), a3
0b78: 282e0014             move.l     $14(a6), d4
0b7c: 6010                 bra.b      $b8e
0b7e: 49edde9b             lea.l      -$2165(a5), a4
0b82: 246e001c             movea.l    $1c(a6), a2
0b86: 266e0020             movea.l    $20(a6), a3
0b8a: 282e0024             move.l     $24(a6), d4
0b8e: 2f2e0028             move.l     $28(a6), -(a7)
0b92: 2f04                 move.l     d4, -(a7)
0b94: 2f0b                 move.l     a3, -(a7)
0b96: 2f0a                 move.l     a2, -(a7)
0b98: 2f0c                 move.l     a4, -(a7)
0b9a: 4eba0044             jsr        $be0(pc)
0b9e: 4a43                 tst.w      d3
0ba0: 4fef0014             lea.l      $14(a7), a7
0ba4: 6e10                 bgt.b      $bb6
0ba6: 49edde86             lea.l      -$217a(a5), a4
0baa: 2447                 movea.l    d7, a2
0bac: 266e0010             movea.l    $10(a6), a3
0bb0: 282e0014             move.l     $14(a6), d4
0bb4: 6010                 bra.b      $bc6
0bb6: 49edde9b             lea.l      -$2165(a5), a4
0bba: 246e001c             movea.l    $1c(a6), a2
0bbe: 266e0020             movea.l    $20(a6), a3
0bc2: 282e0024             move.l     $24(a6), d4
0bc6: 2f2e0028             move.l     $28(a6), -(a7)
0bca: 2f04                 move.l     d4, -(a7)
0bcc: 2f0b                 move.l     a3, -(a7)
0bce: 2f0a                 move.l     a2, -(a7)
0bd0: 2f0c                 move.l     a4, -(a7)
0bd2: 4eba000c             jsr        $be0(pc)
0bd6: 4cee1cf8fdca         movem.l    -$236(a6), d3-d7/a2-a4
0bdc: 4e5e                 unlk       a6
0bde: 4e75                 rts        
0be0: 4e560000             link.w     a6, #$0
0be4: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0be8: 3e3c8001             move.w     #$8001, d7
0bec: 7c00                 moveq      #$0, d6
0bee: 99cc                 suba.l     a4, a4
0bf0: 264c                 movea.l    a4, a3
0bf2: d7ee000c             adda.l     $c(a6), a3
0bf6: 4a53                 tst.w      (a3)
0bf8: 6736                 beq.b      $c30
0bfa: 244c                 movea.l    a4, a2
0bfc: d5ee0010             adda.l     $10(a6), a2
0c00: 4a52                 tst.w      (a2)
0c02: 6726                 beq.b      $c2a
0c04: 204c                 movea.l    a4, a0
0c06: d1ee000c             adda.l     $c(a6), a0
0c0a: 3f10                 move.w     (a0), -(a7)
0c0c: 206e0018             movea.l    $18(a6), a0
0c10: 4e90                 jsr        (a0)
0c12: 4a40                 tst.w      d0
0c14: 548f                 addq.l     #$2, a7
0c16: 6712                 beq.b      $c2a
0c18: be52                 cmp.w      (a2), d7
0c1a: 6c0e                 bge.b      $c2a
0c1c: 3e12                 move.w     (a2), d7
0c1e: 3a06                 move.w     d6, d5
0c20: 3813                 move.w     (a3), d4
0c22: 204c                 movea.l    a4, a0
0c24: d1ee0014             adda.l     $14(a6), a0
0c28: 3610                 move.w     (a0), d3
0c2a: 5246                 addq.w     #$1, d6
0c2c: 548c                 addq.l     #$2, a4
0c2e: 60c0                 bra.b      $bf0
0c30: 0c478001             cmpi.w     #$8001, d7
0c34: 671e                 beq.b      $c54
0c36: 2f2e0008             move.l     $8(a6), -(a7)
0c3a: 3f07                 move.w     d7, -(a7)
0c3c: 3f03                 move.w     d3, -(a7)
0c3e: 3f04                 move.w     d4, -(a7)
0c40: 4ebafcbc             jsr        $8fe(pc)
0c44: 206e0010             movea.l    $10(a6), a0
0c48: d0c5                 adda.w     d5, a0
0c4a: 42705000             clr.w      (a0, d5.w)
0c4e: 4fef000a             lea.l      $a(a7), a7
0c52: 6094                 bra.b      $be8
0c54: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0c58: 4e5e                 unlk       a6
0c5a: 4e75                 rts        
0c5c: 4e560000             link.w     a6, #$0
0c60: 48e70108             movem.l    d7/a4, -(a7)
0c64: 3e2e000a             move.w     $a(a6), d7
0c68: 99cc                 suba.l     a4, a4
0c6a: 0c4707d0             cmpi.w     #$7d0, d7
0c6e: 6f06                 ble.b      $c76
0c70: 49eded7a             lea.l      -$1286(a5), a4
0c74: 6034                 bra.b      $caa
0c76: 0c4703e8             cmpi.w     #$3e8, d7
0c7a: 6f06                 ble.b      $c82
0c7c: 49eded90             lea.l      -$1270(a5), a4
0c80: 6028                 bra.b      $caa
0c82: 0c4701f4             cmpi.w     #$1f4, d7
0c86: 6f06                 ble.b      $c8e
0c88: 49ededa4             lea.l      -$125c(a5), a4
0c8c: 601c                 bra.b      $caa
0c8e: 0c4700fa             cmpi.w     #$fa, d7
0c92: 6f06                 ble.b      $c9a
0c94: 49ededba             lea.l      -$1246(a5), a4
0c98: 6010                 bra.b      $caa
0c9a: 4a6e0008             tst.w      $8(a6)
0c9e: 6606                 bne.b      $ca6
0ca0: 49ededd2             lea.l      -$122e(a5), a4
0ca4: 6004                 bra.b      $caa
0ca6: 49ededec             lea.l      -$1214(a5), a4
0caa: 200c                 move.l     a4, d0
0cac: 6708                 beq.b      $cb6
0cae: 2f0c                 move.l     a4, -(a7)
0cb0: 4eba000c             jsr        $cbe(pc)
0cb4: 588f                 addq.l     #$4, a7
0cb6: 4cdf1080             movem.l    (a7)+, d7/a4
0cba: 4e5e                 unlk       a6
0cbc: 4e75                 rts        
0cbe: 4e560000             link.w     a6, #$0
0cc2: 2f2e0008             move.l     $8(a6), -(a7)
0cc6: 2f2ddeb0             move.l     -$2150(a5), -(a7)
0cca: 4ead07aa             jsr        $7aa(a5) ; CODE17+09c4
0cce: 4e5e                 unlk       a6
0cd0: 4e75                 rts        
0cd2: 4e560000             link.w     a6, #$0
0cd6: 2f2e0008             move.l     $8(a6), -(a7)
0cda: 4ead077a             jsr        $77a(a5) ; CODE17+0438
0cde: 4e5e                 unlk       a6
0ce0: 4e75                 rts        
0ce2: 4e56ff7c             link.w     a6, #$ff7c
0ce6: 48e70038             movem.l    a2-a4, -(a7)
0cea: 4a6dd76a             tst.w      -$2896(a5)
0cee: 6f0000e2             ble.w      $dd2
0cf2: 42a7                 clr.l      -(a7)
0cf4: 206e0008             movea.l    $8(a6), a0
0cf8: 2f2800ca             move.l     $ca(a0), -(a7)
0cfc: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
0d00: 2d5fff7c             move.l     (a7)+, -$84(a6)
0d04: 48780006             pea.l      $6.w
0d08: 2f2eff7c             move.l     -$84(a6), -(a7)
0d0c: 4ead004a             jsr        $4a(a5) ; CODE1+0124
0d10: 306dd76a             movea.w    -$2896(a5), a0
0d14: b088                 cmp.l      a0, d0
0d16: 630000ba             bls.w      $dd2
0d1a: 4ead093a             jsr        $93a(a5) ; CODE31+0118
0d1e: 4a40                 tst.w      d0
0d20: 660000b0             bne.w      $dd2
0d24: 206ddeb8             movea.l    -$2148(a5), a0
0d28: 206800ca             movea.l    $ca(a0), a0
0d2c: 2050                 movea.l    (a0), a0
0d2e: 20680002             movea.l    $2(a0), a0
0d32: a029                 dc.w       $a029
0d34: 206ddeb8             movea.l    -$2148(a5), a0
0d38: 206800ca             movea.l    $ca(a0), a0
0d3c: 7006                 moveq      #$6, d0
0d3e: c1edd76a             muls.w     -$2896(a5), d0
0d42: 2050                 movea.l    (a0), a0
0d44: 20700802             movea.l    $2(a0, d0.l), a0
0d48: a029                 dc.w       $a029
0d4a: 206ddeb8             movea.l    -$2148(a5), a0
0d4e: 206800ca             movea.l    $ca(a0), a0
0d52: 2850                 movea.l    (a0), a4
0d54: 206c0002             movea.l    $2(a4), a0
0d58: 2650                 movea.l    (a0), a3
0d5a: 7006                 moveq      #$6, d0
0d5c: c1edd76a             muls.w     -$2896(a5), d0
0d60: 20740802             movea.l    $2(a4, d0.l), a0
0d64: 2450                 movea.l    (a0), a2
0d66: 2f0a                 move.l     a2, -(a7)
0d68: 2f0b                 move.l     a3, -(a7)
0d6a: 486dde86             pea.l      -$217a(a5)
0d6e: 4ebaf294             jsr        $4(pc)
0d72: 2e8b                 move.l     a3, (a7)
0d74: 2f0a                 move.l     a2, -(a7)
0d76: 486dde9b             pea.l      -$2165(a5)
0d7a: 4ebaf288             jsr        $4(pc)
0d7e: 206ddeb8             movea.l    -$2148(a5), a0
0d82: 206800ca             movea.l    $ca(a0), a0
0d86: 2050                 movea.l    (a0), a0
0d88: 20680002             movea.l    $2(a0), a0
0d8c: a02a                 dc.w       $a02a
0d8e: 206ddeb8             movea.l    -$2148(a5), a0
0d92: 206800ca             movea.l    $ca(a0), a0
0d96: 7006                 moveq      #$6, d0
0d98: c1edd76a             muls.w     -$2896(a5), d0
0d9c: 2050                 movea.l    (a0), a0
0d9e: 20700802             movea.l    $2(a0, d0.l), a0
0da2: a02a                 dc.w       $a02a
0da4: 486dde86             pea.l      -$217a(a5)
0da8: 486dde9b             pea.l      -$2165(a5)
0dac: 486dee16             pea.l      -$11ea(a5)
0db0: 486eff81             pea.l      -$7f(a6)
0db4: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0db8: 1d40ff80             move.b     d0, -$80(a6)
0dbc: 2eae000c             move.l     $c(a6), (a7)
0dc0: 4267                 clr.w      -(a7)
0dc2: 2f2e0010             move.l     $10(a6), -(a7)
0dc6: a86b                 dc.w       $a86b
0dc8: 486eff80             pea.l      -$80(a6)
0dcc: a947                 dc.w       $a947
0dce: 7001                 moveq      #$1, d0
0dd0: 6002                 bra.b      $dd4
0dd2: 7000                 moveq      #$0, d0
0dd4: 4cee1c00ff70         movem.l    -$90(a6), a2-a4
0dda: 4e5e                 unlk       a6
0ddc: 4e75                 rts        
0dde: 4e56e58c             link.w     a6, #$e58c
0de2: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0de6: 286e0008             movea.l    $8(a6), a4
0dea: 49ec00ca             lea.l      $ca(a4), a4
0dee: 2054                 movea.l    (a4), a0
0df0: 2050                 movea.l    (a0), a0
0df2: 20680002             movea.l    $2(a0), a0
0df6: 2050                 movea.l    (a0), a0
0df8: 43eeffde             lea.l      -$22(a6), a1
0dfc: 7007                 moveq      #$7, d0
0dfe: 22d8                 move.l     (a0)+, (a1)+
0e00: 51c8fffc             dbra       d0, $dfe
0e04: 32d8                 move.w     (a0)+, (a1)+
0e06: 2054                 movea.l    (a4), a0
0e08: 7006                 moveq      #$6, d0
0e0a: c1edd76a             muls.w     -$2896(a5), d0
0e0e: 2050                 movea.l    (a0), a0
0e10: 20700802             movea.l    $2(a0, d0.l), a0
0e14: 2050                 movea.l    (a0), a0
0e16: 43eeffbc             lea.l      -$44(a6), a1
0e1a: 7007                 moveq      #$7, d0
0e1c: 22d8                 move.l     (a0)+, (a1)+
0e1e: 51c8fffc             dbra       d0, $e1c
0e22: 32d8                 move.w     (a0)+, (a1)+
0e24: 4ead03fa             jsr        $3fa(a5) ; CODE20+004e
0e28: 486dc366             pea.l      -$3c9a(a5)
0e2c: 4ead02f2             jsr        $2f2(a5) ; CODE14+0004
0e30: 486ef7b4             pea.l      -$84c(a6)
0e34: 486efbb4             pea.l      -$44c(a6)
0e38: 486effde             pea.l      -$22(a6)
0e3c: 4ead09e2             jsr        $9e2(a5) ; CODE35+036c
0e40: d0aeffee             add.l      -$12(a6), d0
0e44: 2d40e59a             move.l     d0, -$1a66(a6)
0e48: 48780400             pea.l      $400.w
0e4c: 486eebb4             pea.l      -$144c(a6)
0e50: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0e54: 486eefb4             pea.l      -$104c(a6)
0e58: 486ef3b4             pea.l      -$c4c(a6)
0e5c: 486effbc             pea.l      -$44(a6)
0e60: 4ead09e2             jsr        $9e2(a5) ; CODE35+036c
0e64: d0aeffcc             add.l      -$34(a6), d0
0e68: 91aee59a             sub.l      d0, -$1a66(a6)
0e6c: 48780400             pea.l      $400.w
0e70: 486ee7b4             pea.l      -$184c(a6)
0e74: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0e78: 7800                 moveq      #$0, d4
0e7a: 49eeebb4             lea.l      -$144c(a6), a4
0e7e: 47eef7b4             lea.l      -$84c(a6), a3
0e82: 41eefbb4             lea.l      -$44c(a6), a0
0e86: 2e08                 move.l     a0, d7
0e88: 4fef002c             lea.l      $2c(a7), a7
0e8c: 60000094             bra.w      $f22
0e90: 7600                 moveq      #$0, d3
0e92: 244b                 movea.l    a3, a2
0e94: 2d4ce592             move.l     a4, -$1a6e(a6)
0e98: 2a03                 move.l     d3, d5
0e9a: 48c5                 ext.l      d5
0e9c: da85                 add.l      d5, d5
0e9e: 41eee7b4             lea.l      -$184c(a6), a0
0ea2: d1c5                 adda.l     d5, a0
0ea4: 2d48e596             move.l     a0, -$1a6a(a6)
0ea8: 2c05                 move.l     d5, d6
0eaa: 43eeefb4             lea.l      -$104c(a6), a1
0eae: dc89                 add.l      a1, d6
0eb0: 43eef3b4             lea.l      -$c4c(a6), a1
0eb4: d3c5                 adda.l     d5, a1
0eb6: 2d49e59e             move.l     a1, -$1a62(a6)
0eba: 206ee59e             movea.l    -$1a62(a6), a0
0ebe: 3d50e58e             move.w     (a0), -$1a72(a6)
0ec2: 4a6ee58e             tst.w      -$1a72(a6)
0ec6: 6752                 beq.b      $f1a
0ec8: 2047                 movea.l    d7, a0
0eca: 3010                 move.w     (a0), d0
0ecc: b06ee58e             cmp.w      -$1a72(a6), d0
0ed0: 663a                 bne.b      $f0c
0ed2: 2046                 movea.l    d6, a0
0ed4: 3610                 move.w     (a0), d3
0ed6: b652                 cmp.w      (a2), d3
0ed8: 6608                 bne.b      $ee2
0eda: 2046                 movea.l    d6, a0
0edc: 4250                 clr.w      (a0)
0ede: 4252                 clr.w      (a2)
0ee0: 6038                 bra.b      $f1a
0ee2: b652                 cmp.w      (a2), d3
0ee4: 6c14                 bge.b      $efa
0ee6: 2046                 movea.l    d6, a0
0ee8: 3010                 move.w     (a0), d0
0eea: 9152                 sub.w      d0, (a2)
0eec: 206ee592             movea.l    -$1a6e(a6), a0
0ef0: 30bc0001             move.w     #$1, (a0)
0ef4: 2246                 movea.l    d6, a1
0ef6: 4251                 clr.w      (a1)
0ef8: 6020                 bra.b      $f1a
0efa: 3012                 move.w     (a2), d0
0efc: 2046                 movea.l    d6, a0
0efe: 9150                 sub.w      d0, (a0)
0f00: 206ee596             movea.l    -$1a6a(a6), a0
0f04: 30bc0001             move.w     #$1, (a0)
0f08: 4252                 clr.w      (a2)
0f0a: 600e                 bra.b      $f1a
0f0c: 5243                 addq.w     #$1, d3
0f0e: 54aee596             addq.l     #$2, -$1a6a(a6)
0f12: 5486                 addq.l     #$2, d6
0f14: 54aee59e             addq.l     #$2, -$1a62(a6)
0f18: 60a0                 bra.b      $eba
0f1a: 5244                 addq.w     #$1, d4
0f1c: 548c                 addq.l     #$2, a4
0f1e: 548b                 addq.l     #$2, a3
0f20: 5487                 addq.l     #$2, d7
0f22: 2047                 movea.l    d7, a0
0f24: 4a50                 tst.w      (a0)
0f26: 6600ff68             bne.w      $e90
0f2a: 7800                 moveq      #$0, d4
0f2c: 49eef7b4             lea.l      -$84c(a6), a4
0f30: 47eefbb4             lea.l      -$44c(a6), a3
0f34: 2e0b                 move.l     a3, d7
0f36: 2047                 movea.l    d7, a0
0f38: 4a50                 tst.w      (a0)
0f3a: 6758                 beq.b      $f94
0f3c: 4a54                 tst.w      (a4)
0f3e: 674c                 beq.b      $f8c
0f40: 7600                 moveq      #$0, d3
0f42: 2a03                 move.l     d3, d5
0f44: 48c5                 ext.l      d5
0f46: da85                 add.l      d5, d5
0f48: 45eef7b4             lea.l      -$84c(a6), a2
0f4c: d5c5                 adda.l     d5, a2
0f4e: 41eefbb4             lea.l      -$44c(a6), a0
0f52: d1c5                 adda.l     d5, a0
0f54: 2d48e592             move.l     a0, -$1a6e(a6)
0f58: 602a                 bra.b      $f84
0f5a: b644                 cmp.w      d4, d3
0f5c: 671e                 beq.b      $f7c
0f5e: 4a52                 tst.w      (a2)
0f60: 671a                 beq.b      $f7c
0f62: 206ee592             movea.l    -$1a6e(a6), a0
0f66: 3f10                 move.w     (a0), -(a7)
0f68: 2247                 movea.l    d7, a1
0f6a: 3f11                 move.w     (a1), -(a7)
0f6c: 4ebaf7b6             jsr        $724(pc)
0f70: 4a40                 tst.w      d0
0f72: 588f                 addq.l     #$4, a7
0f74: 6706                 beq.b      $f7c
0f76: 3012                 move.w     (a2), d0
0f78: d154                 add.w      d0, (a4)
0f7a: 4252                 clr.w      (a2)
0f7c: 5243                 addq.w     #$1, d3
0f7e: 548a                 addq.l     #$2, a2
0f80: 54aee592             addq.l     #$2, -$1a6e(a6)
0f84: 206ee592             movea.l    -$1a6e(a6), a0
0f88: 4a50                 tst.w      (a0)
0f8a: 66ce                 bne.b      $f5a
0f8c: 5244                 addq.w     #$1, d4
0f8e: 548c                 addq.l     #$2, a4
0f90: 548b                 addq.l     #$2, a3
0f92: 60a0                 bra.b      $f34
0f94: 7800                 moveq      #$0, d4
0f96: 49eeefb4             lea.l      -$104c(a6), a4
0f9a: 47eef3b4             lea.l      -$c4c(a6), a3
0f9e: 6044                 bra.b      $fe4
0fa0: 4a54                 tst.w      (a4)
0fa2: 673a                 beq.b      $fde
0fa4: 7600                 moveq      #$0, d3
0fa6: 41eeefb4             lea.l      -$104c(a6), a0
0faa: 2e08                 move.l     a0, d7
0fac: 45eef3b4             lea.l      -$c4c(a6), a2
0fb0: 6028                 bra.b      $fda
0fb2: b644                 cmp.w      d4, d3
0fb4: 671e                 beq.b      $fd4
0fb6: 2047                 movea.l    d7, a0
0fb8: 4a50                 tst.w      (a0)
0fba: 6718                 beq.b      $fd4
0fbc: 3f12                 move.w     (a2), -(a7)
0fbe: 3f13                 move.w     (a3), -(a7)
0fc0: 4ebaf762             jsr        $724(pc)
0fc4: 4a40                 tst.w      d0
0fc6: 588f                 addq.l     #$4, a7
0fc8: 670a                 beq.b      $fd4
0fca: 2047                 movea.l    d7, a0
0fcc: 3010                 move.w     (a0), d0
0fce: d154                 add.w      d0, (a4)
0fd0: 2047                 movea.l    d7, a0
0fd2: 4250                 clr.w      (a0)
0fd4: 5243                 addq.w     #$1, d3
0fd6: 5487                 addq.l     #$2, d7
0fd8: 548a                 addq.l     #$2, a2
0fda: 4a52                 tst.w      (a2)
0fdc: 66d4                 bne.b      $fb2
0fde: 5244                 addq.w     #$1, d4
0fe0: 548c                 addq.l     #$2, a4
0fe2: 548b                 addq.l     #$2, a3
0fe4: 4a53                 tst.w      (a3)
0fe6: 66b8                 bne.b      $fa0
0fe8: 202effee             move.l     -$12(a6), d0
0fec: b0aeffcc             cmp.l      -$34(a6), d0
0ff0: 6d04                 blt.b      $ff6
0ff2: 7000                 moveq      #$0, d0
0ff4: 6002                 bra.b      $ff8
0ff6: 7001                 moveq      #$1, d0
0ff8: 3040                 movea.w    d0, a0
0ffa: 2d48e58e             move.l     a0, -$1a72(a6)
0ffe: 202effee             move.l     -$12(a6), d0
1002: b0aeffcc             cmp.l      -$34(a6), d0
1006: 6604                 bne.b      $100c
1008: 7000                 moveq      #$0, d0
100a: 6002                 bra.b      $100e
100c: 7001                 moveq      #$1, d0
100e: 3b40de84             move.w     d0, -$217c(a5)
1012: 7800                 moveq      #$0, d4
1014: 49eef7b4             lea.l      -$84c(a6), a4
1018: 47eefbb4             lea.l      -$44c(a6), a3
101c: 6018                 bra.b      $1036
101e: 3614                 move.w     (a4), d3
1020: 4a43                 tst.w      d3
1022: 670c                 beq.b      $1030
1024: 526dde84             addq.w     #$1, -$217c(a5)
1028: 4a43                 tst.w      d3
102a: 6c04                 bge.b      $1030
102c: 52aee58e             addq.l     #$1, -$1a72(a6)
1030: 5244                 addq.w     #$1, d4
1032: 548c                 addq.l     #$2, a4
1034: 548b                 addq.l     #$2, a3
1036: 4a53                 tst.w      (a3)
1038: 66e4                 bne.b      $101e
103a: 7600                 moveq      #$0, d3
103c: 49eef3b4             lea.l      -$c4c(a6), a4
1040: 6024                 bra.b      $1066
1042: 204e                 movea.l    a6, a0
1044: d0c4                 adda.w     d4, a0
1046: d0c4                 adda.w     d4, a0
1048: 3d68efb4e58c         move.w     -$104c(a0), -$1a74(a6)
104e: 4a6ee58c             tst.w      -$1a74(a6)
1052: 670e                 beq.b      $1062
1054: 526dde84             addq.w     #$1, -$217c(a5)
1058: 4a6ee58c             tst.w      -$1a74(a6)
105c: 6f04                 ble.b      $1062
105e: 52aee58e             addq.l     #$1, -$1a72(a6)
1062: 5243                 addq.w     #$1, d3
1064: 548c                 addq.l     #$2, a4
1066: 4a54                 tst.w      (a4)
1068: 66d8                 bne.b      $1042
106a: 2f2ddeb0             move.l     -$2150(a5), -(a7)
106e: 4ead07ba             jsr        $7ba(a5) ; CODE17+0a20
1072: 4a6dde84             tst.w      -$217c(a5)
1076: 588f                 addq.l     #$4, a7
1078: 6628                 bne.b      $10a2
107a: 486dde9b             pea.l      -$2165(a5)
107e: 486dde86             pea.l      -$217a(a5)
1082: 486dee28             pea.l      -$11d8(a5)
1086: 486ee5a6             pea.l      -$1a5a(a6)
108a: 4ead0812             jsr        $812(a5) ; CODE24+16a6
108e: 486ee5a6             pea.l      -$1a5a(a6)
1092: 2f2ddeb0             move.l     -$2150(a5), -(a7)
1096: 4ead07aa             jsr        $7aa(a5) ; CODE17+09c4
109a: 4fef0018             lea.l      $18(a7), a7
109e: 600000a6             bra.w      $1146
10a2: 426dde84             clr.w      -$217c(a5)
10a6: 486ee7b4             pea.l      -$184c(a6)
10aa: 486eefb4             pea.l      -$104c(a6)
10ae: 486ef3b4             pea.l      -$c4c(a6)
10b2: 486effbc             pea.l      -$44(a6)
10b6: 486eebb4             pea.l      -$144c(a6)
10ba: 486ef7b4             pea.l      -$84c(a6)
10be: 486efbb4             pea.l      -$44c(a6)
10c2: 486effde             pea.l      -$22(a6)
10c6: 4ebaf8f2             jsr        $9ba(pc)
10ca: 486dee3e             pea.l      -$11c2(a5)
10ce: 486dee58             pea.l      -$11a8(a5)
10d2: 486d09f2             pea.l      $9f2(a5)
10d6: 486ee7b4             pea.l      -$184c(a6)
10da: 486eefb4             pea.l      -$104c(a6)
10de: 486ef3b4             pea.l      -$c4c(a6)
10e2: 486effbc             pea.l      -$44(a6)
10e6: 486eebb4             pea.l      -$144c(a6)
10ea: 486ef7b4             pea.l      -$84c(a6)
10ee: 486efbb4             pea.l      -$44c(a6)
10f2: 486effde             pea.l      -$22(a6)
10f6: 4ebaf99e             jsr        $a96(pc)
10fa: 486dee74             pea.l      -$118c(a5)
10fe: 486dee8c             pea.l      -$1174(a5)
1102: 486d036a             pea.l      $36a(a5)
1106: 486ee7b4             pea.l      -$184c(a6)
110a: 486eefb4             pea.l      -$104c(a6)
110e: 486ef3b4             pea.l      -$c4c(a6)
1112: 486effbc             pea.l      -$44(a6)
1116: 486eebb4             pea.l      -$144c(a6)
111a: 486ef7b4             pea.l      -$84c(a6)
111e: 486efbb4             pea.l      -$44c(a6)
1122: 486effde             pea.l      -$22(a6)
1126: 4ebaf96e             jsr        $a96(pc)
112a: 4fef0078             lea.l      $78(a7), a7
112e: 486effbc             pea.l      -$44(a6)
1132: 486effde             pea.l      -$22(a6)
1136: 3f2ee59c             move.w     -$1a64(a6), -(a7)
113a: 3f2ee590             move.w     -$1a70(a6), -(a7)
113e: 4ebafb1c             jsr        $c5c(pc)
1142: 4fef000c             lea.l      $c(a7), a7
1146: 2f2ddeb0             move.l     -$2150(a5), -(a7)
114a: a873                 dc.w       $a873
114c: 206ddeb0             movea.l    -$2150(a5), a0
1150: 48680010             pea.l      $10(a0)
1154: a928                 dc.w       $a928
1156: 2f2ddeb0             move.l     -$2150(a5), -(a7)
115a: 4ead0c3a             jsr        $c3a(a5) ; CODE46+0966
115e: 2eaddeb0             move.l     -$2150(a5), (a7)
1162: 4ead0c1a             jsr        $c1a(a5) ; CODE46+0742
1166: 4cee1cf8e56c         movem.l    -$1a94(a6), d3-d7/a2-a4
116c: 4e5e                 unlk       a6
116e: 4e75                 rts        
