0004: 202df52e             move.l     -$ad2(a5), d0
0008: b0add134             cmp.l      -$2ecc(a5), d0
000c: 670a                 beq.b      $18
000e: 206df52e             movea.l    -$ad2(a5), a0
0012: 4a28001a             tst.b      $1a(a0)
0016: 6704                 beq.b      $1c
0018: 7000                 moveq      #$0, d0
001a: 6002                 bra.b      $1e
001c: 7001                 moveq      #$1, d0
001e: 4e75                 rts        
0020: 4e560000             link.w     a6, #$0
0024: 2b6d9b68a222         move.l     -$6498(a5), -$5dde(a5)
002a: 536da386             subq.w     #$1, -$5c7a(a5)
002e: 702c                 moveq      #$2c, d0
0030: c1eda386             muls.w     -$5c7a(a5), d0
0034: 41eda226             lea.l      -$5dda(a5), a0
0038: d088                 add.l      a0, d0
003a: 2040                 movea.l    d0, a0
003c: 7001                 moveq      #$1, d0
003e: 4a40                 tst.w      d0
0040: 6602                 bne.b      $44
0042: 7001                 moveq      #$1, d0
0044: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
0048: 4ed1                 jmp        (a1)
004a: 4e5e                 unlk       a6
004c: 4e75                 rts        
004e: 4e560000             link.w     a6, #$0
0052: 2f07                 move.l     d7, -(a7)
0054: 7e00                 moveq      #$0, d7
0056: 2f2e0008             move.l     $8(a6), -(a7)
005a: 4ead0afa             jsr        $afa(a5) ; CODE45+042a
005e: 3b7c007fa60e         move.w     #$7f, -$59f2(a5)
0064: 0c6d0008a386         cmpi.w     #$8, -$5c7a(a5)
006a: 588f                 addq.l     #$4, a7
006c: 6406                 bcc.b      $74
006e: 4a6da386             tst.w      -$5c7a(a5)
0072: 6c04                 bge.b      $78
0074: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0078: 302da386             move.w     -$5c7a(a5), d0
007c: 526da386             addq.w     #$1, -$5c7a(a5)
0080: c1fc002c             muls.w     #$2c, d0
0084: 41eda226             lea.l      -$5dda(a5), a0
0088: d088                 add.l      a0, d0
008a: 2040                 movea.l    d0, a0
008c: 7000                 moveq      #$0, d0
008e: 43fa0006             lea.l      $96(pc), a1
0092: 48d0def8             movem.l    d3-d7/a1-a4/a6-a7, (a0)
0096: 4a40                 tst.w      d0
0098: 6610                 bne.b      $aa
009a: 486d08d2             pea.l      $8d2(a5)
009e: 4ead0a3a             jsr        $a3a(a5) ; CODE37+0004
00a2: 536da386             subq.w     #$1, -$5c7a(a5)
00a6: 588f                 addq.l     #$4, a7
00a8: 6046                 bra.b      $f0
00aa: 2f2da222             move.l     -$5dde(a5), -(a7)
00ae: 2f2d9b68             move.l     -$6498(a5), -(a7)
00b2: 4ead0db2             jsr        $db2(a5) ; CODE52+0242
00b6: 4a40                 tst.w      d0
00b8: 508f                 addq.l     #$8, a7
00ba: 6604                 bne.b      $c0
00bc: 7e01                 moveq      #$1, d7
00be: 6030                 bra.b      $f0
00c0: 4a6da386             tst.w      -$5c7a(a5)
00c4: 6e04                 bgt.b      $ca
00c6: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
00ca: 2b6da222a222         move.l     -$5dde(a5), -$5dde(a5)
00d0: 536da386             subq.w     #$1, -$5c7a(a5)
00d4: 702c                 moveq      #$2c, d0
00d6: c1eda386             muls.w     -$5c7a(a5), d0
00da: 41eda226             lea.l      -$5dda(a5), a0
00de: d088                 add.l      a0, d0
00e0: 2040                 movea.l    d0, a0
00e2: 7001                 moveq      #$1, d0
00e4: 4a40                 tst.w      d0
00e6: 6602                 bne.b      $ea
00e8: 7001                 moveq      #$1, d0
00ea: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
00ee: 4ed1                 jmp        (a1)
00f0: 3007                 move.w     d7, d0
00f2: 2e1f                 move.l     (a7)+, d7
00f4: 4e5e                 unlk       a6
00f6: 4e75                 rts        
00f8: 2f07                 move.l     d7, -(a7)
00fa: 4aadd134             tst.l      -$2ecc(a5)
00fe: 6604                 bne.b      $104
0100: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0104: 202dd138             move.l     -$2ec8(a5), d0
0108: eb88                 lsl.l      #$5, d0
010a: 2f00                 move.l     d0, -(a7)
010c: 2f2dd134             move.l     -$2ecc(a5), -(a7)
0110: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0114: 3b7c0001f532         move.w     #$1, -$ace(a5)
011a: 3e2dd13a             move.w     -$2ec6(a5), d7
011e: 5347                 subq.w     #$1, d7
0120: 2007                 move.l     d7, d0
0122: 48c0                 ext.l      d0
0124: eb88                 lsl.l      #$5, d0
0126: 206dd134             movea.l    -$2ecc(a5), a0
012a: 42700806             clr.w      $6(a0, d0.l)
012e: 508f                 addq.l     #$8, a7
0130: 6012                 bra.b      $144
0132: 2007                 move.l     d7, d0
0134: 48c0                 ext.l      d0
0136: eb88                 lsl.l      #$5, d0
0138: 7201                 moveq      #$1, d1
013a: d247                 add.w      d7, d1
013c: 206dd134             movea.l    -$2ecc(a5), a0
0140: 31810806             move.w     d1, $6(a0, d0.l)
0144: 5347                 subq.w     #$1, d7
0146: 4a47                 tst.w      d7
0148: 6ce8                 bge.b      $132
014a: 2e1f                 move.l     (a7)+, d7
014c: 4e75                 rts        
014e: 4e56f91a             link.w     a6, #$f91a
0152: 48e70738             movem.l    d5-d7/a2-a4, -(a7)
0156: 41eef926             lea.l      -$6da(a6), a0
015a: 43eda5ce             lea.l      -$5a32(a5), a1
015e: 7007                 moveq      #$7, d0
0160: 20d9                 move.l     (a1)+, (a0)+
0162: 51c8fffc             dbra       d0, $160
0166: 30d9                 move.w     (a1)+, (a0)+
0168: 426ef922             clr.w      -$6de(a6)
016c: 486ef91e             pea.l      -$6e2(a6)
0170: 4ead069a             jsr        $69a(a5) ; CODE9+0076
0174: 48780154             pea.l      $154.w
0178: 486da5f0             pea.l      -$5a10(a5)
017c: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0180: 2eae0008             move.l     $8(a6), (a7)
0184: 4ebafec8             jsr        $4e(pc)
0188: 4a40                 tst.w      d0
018a: 4fef000c             lea.l      $c(a7), a7
018e: 6610                 bne.b      $1a0
0190: 3b7c0001cf04         move.w     #$1, -$30fc(a5)
0196: 41eda5f0             lea.l      -$5a10(a5), a0
019a: 2008                 move.l     a0, d0
019c: 600004c0             bra.w      $65e
01a0: 4eba04c4             jsr        $666(pc)
01a4: 4ebaff52             jsr        $f8(pc)
01a8: 48780100             pea.l      $100.w
01ac: 486dbbf4             pea.l      -$440c(a5)
01b0: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
01b4: 41edc35e             lea.l      -$3ca2(a5), a0
01b8: b1ee0008             cmpa.l     $8(a6), a0
01bc: 508f                 addq.l     #$8, a7
01be: 670e                 beq.b      $1ce
01c0: 41edc366             lea.l      -$3c9a(a5), a0
01c4: b1ee0008             cmpa.l     $8(a6), a0
01c8: 6704                 beq.b      $1ce
01ca: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
01ce: 41edc366             lea.l      -$3c9a(a5), a0
01d2: b1ee0008             cmpa.l     $8(a6), a0
01d6: 6608                 bne.b      $1e0
01d8: 41edc35e             lea.l      -$3ca2(a5), a0
01dc: 2008                 move.l     a0, d0
01de: 6006                 bra.b      $1e6
01e0: 41edc366             lea.l      -$3c9a(a5), a0
01e4: 2008                 move.l     a0, d0
01e6: 2840                 movea.l    d0, a4
01e8: 2f0c                 move.l     a4, -(a7)
01ea: 4ead096a             jsr        $96a(a5) ; CODE31+0992
01ee: 2e8c                 move.l     a4, (a7)
01f0: 4ead0952             jsr        $952(a5) ; CODE31+071e
01f4: 2eae0008             move.l     $8(a6), (a7)
01f8: 4ead096a             jsr        $96a(a5) ; CODE31+0992
01fc: 2eae0008             move.l     $8(a6), (a7)
0200: 4ead0952             jsr        $952(a5) ; CODE31+071e
0204: 48780220             pea.l      $220.w
0208: 486dbcfe             pea.l      -$4302(a5)
020c: 486efdce             pea.l      -$232(a6)
0210: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0214: 48780440             pea.l      $440.w
0218: 486dbf1e             pea.l      -$40e2(a5)
021c: 486ef98e             pea.l      -$672(a6)
0220: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0224: 3d6db3f2f924         move.w     -$4c0e(a5), -$6dc(a6)
022a: 246e0008             movea.l    $8(a6), a2
022e: 264c                 movea.l    a4, a3
0230: 2eae0008             move.l     $8(a6), (a7)
0234: 486efff6             pea.l      -$a(a6)
0238: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
023c: 2e8c                 move.l     a4, (a7)
023e: 486effee             pea.l      -$12(a6)
0242: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0246: 2d6dd134f98a         move.l     -$2ecc(a5), -$676(a6)
024c: 0c6d0008a386         cmpi.w     #$8, -$5c7a(a5)
0252: 4fef0024             lea.l      $24(a7), a7
0256: 6406                 bcc.b      $25e
0258: 4a6da386             tst.w      -$5c7a(a5)
025c: 6c04                 bge.b      $262
025e: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0262: 302da386             move.w     -$5c7a(a5), d0
0266: 526da386             addq.w     #$1, -$5c7a(a5)
026a: c1fc002c             muls.w     #$2c, d0
026e: 41eda226             lea.l      -$5dda(a5), a0
0272: d088                 add.l      a0, d0
0274: 2040                 movea.l    d0, a0
0276: 7000                 moveq      #$0, d0
0278: 43fa0006             lea.l      $280(pc), a1
027c: 48d0def8             movem.l    d3-d7/a1-a4/a6-a7, (a0)
0280: 4a40                 tst.w      d0
0282: 6600030a             bne.w      $58e
0286: 426efffe             clr.w      -$2(a6)
028a: 202ef98a             move.l     -$676(a6), d0
028e: 2b40f52e             move.l     d0, -$ad2(a5)
0292: 2d40f97a             move.l     d0, -$686(a6)
0296: 6078                 bra.b      $310
0298: 202df52e             move.l     -$ad2(a5), d0
029c: b0add134             cmp.l      -$2ecc(a5), d0
02a0: 6760                 beq.b      $302
02a2: 526efffe             addq.w     #$1, -$2(a6)
02a6: 0c6e00c8fffe         cmpi.w     #$c8, -$2(a6)
02ac: 6d04                 blt.b      $2b2
02ae: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
02b2: 2d6df52ef97a         move.l     -$ad2(a5), -$686(a6)
02b8: 2f2e0008             move.l     $8(a6), -(a7)
02bc: 4ead096a             jsr        $96a(a5) ; CODE31+0992
02c0: 4ead0982             jsr        $982(a5) ; CODE32+115c
02c4: 2eadf52e             move.l     -$ad2(a5), (a7)
02c8: 486ef948             pea.l      -$6b8(a6)
02cc: 4eba0a04             jsr        $cd2(pc)
02d0: 4257                 clr.w      (a7)
02d2: 2f2e0008             move.l     $8(a6), -(a7)
02d6: 486ef948             pea.l      -$6b8(a6)
02da: 4ead0942             jsr        $942(a5) ; CODE31+0184
02de: 3eaef966             move.w     -$69a(a6), (a7)
02e2: 4ead0992             jsr        $992(a5) ; CODE32+0650
02e6: 2e80                 move.l     d0, (a7)
02e8: 2f2e0008             move.l     $8(a6), -(a7)
02ec: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
02f0: 2d6e0008f976         move.l     $8(a6), -$68a(a6)
02f6: 2d4c0008             move.l     a4, $8(a6)
02fa: 286ef976             movea.l    -$68a(a6), a4
02fe: 4fef0014             lea.l      $14(a7), a7
0302: 2f2df52e             move.l     -$ad2(a5), -(a7)
0306: 4eba05b6             jsr        $8be(pc)
030a: 2b40f52e             move.l     d0, -$ad2(a5)
030e: 588f                 addq.l     #$4, a7
0310: 4aadf52e             tst.l      -$ad2(a5)
0314: 6682                 bne.b      $298
0316: 2b6ef97af52e         move.l     -$686(a6), -$ad2(a5)
031c: 202df52e             move.l     -$ad2(a5), d0
0320: b0add134             cmp.l      -$2ecc(a5), d0
0324: 6510                 bcs.b      $336
0326: 202dd138             move.l     -$2ec8(a5), d0
032a: eb88                 lsl.l      #$5, d0
032c: d0add134             add.l      -$2ecc(a5), d0
0330: b0adf52e             cmp.l      -$ad2(a5), d0
0334: 6404                 bcc.b      $33a
0336: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
033a: 2f0c                 move.l     a4, -(a7)
033c: 2f2e0008             move.l     $8(a6), -(a7)
0340: 4ead0af2             jsr        $af2(a5) ; CODE45+02b8
0344: 2eadd134             move.l     -$2ecc(a5), (a7)
0348: 4eba05da             jsr        $924(pc)
034c: 2eadd134             move.l     -$2ecc(a5), (a7)
0350: 4eba056c             jsr        $8be(pc)
0354: 2d40f986             move.l     d0, -$67a(a6)
0358: 223cf4143e00         move.l     #$f4143e00, d1
035e: 2d41f96a             move.l     d1, -$696(a6)
0362: 2d41f972             move.l     d1, -$68e(a6)
0366: 2d41f96e             move.l     d1, -$692(a6)
036a: 42aef97e             clr.l      -$682(a6)
036e: 42aef982             clr.l      -$67e(a6)
0372: 206dd134             movea.l    -$2ecc(a5), a0
0376: 3e280004             move.w     $4(a0), d7
037a: 508f                 addq.l     #$8, a7
037c: 6064                 bra.b      $3e2
037e: 2007                 move.l     d7, d0
0380: 48c0                 ext.l      d0
0382: eb88                 lsl.l      #$5, d0
0384: d0add134             add.l      -$2ecc(a5), d0
0388: 2d40f97a             move.l     d0, -$686(a6)
038c: 2040                 movea.l    d0, a0
038e: 3a28000a             move.w     $a(a0), d5
0392: 48c5                 ext.l      d5
0394: 2c05                 move.l     d5, d6
0396: 2040                 movea.l    d0, a0
0398: 3050                 movea.w    (a0), a0
039a: 9c88                 sub.l      a0, d6
039c: 2040                 movea.l    d0, a0
039e: 30680002             movea.w    $2(a0), a0
03a2: 9a88                 sub.l      a0, d5
03a4: b0aef986             cmp.l      -$67a(a6), d0
03a8: 6710                 beq.b      $3ba
03aa: bcaef972             cmp.l      -$68e(a6), d6
03ae: 6f0a                 ble.b      $3ba
03b0: 2d6ef97af97e         move.l     -$686(a6), -$682(a6)
03b6: 2d46f972             move.l     d6, -$68e(a6)
03ba: baaef96e             cmp.l      -$692(a6), d5
03be: 6e0c                 bgt.b      $3cc
03c0: baaef96e             cmp.l      -$692(a6), d5
03c4: 6614                 bne.b      $3da
03c6: bcaef96a             cmp.l      -$696(a6), d6
03ca: 6f0e                 ble.b      $3da
03cc: 2d6ef97af982         move.l     -$686(a6), -$67e(a6)
03d2: 2d45f96e             move.l     d5, -$692(a6)
03d6: 2d46f96a             move.l     d6, -$696(a6)
03da: 206ef97a             movea.l    -$686(a6), a0
03de: 3e280006             move.w     $6(a0), d7
03e2: 4a47                 tst.w      d7
03e4: 6698                 bne.b      $37e
03e6: 202ef986             move.l     -$67a(a6), d0
03ea: b0aef982             cmp.l      -$67e(a6), d0
03ee: 6616                 bne.b      $406
03f0: 202ef98a             move.l     -$676(a6), d0
03f4: b0aef986             cmp.l      -$67a(a6), d0
03f8: 660c                 bne.b      $406
03fa: 4aaef97e             tst.l      -$682(a6)
03fe: 6706                 beq.b      $406
0400: 202ef97e             move.l     -$682(a6), d0
0404: 6004                 bra.b      $40a
0406: 202ef986             move.l     -$67a(a6), d0
040a: 2d40f98a             move.l     d0, -$676(a6)
040e: 48780220             pea.l      $220.w
0412: 486efdce             pea.l      -$232(a6)
0416: 486dbcfe             pea.l      -$4302(a5)
041a: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
041e: 48780440             pea.l      $440.w
0422: 486ef98e             pea.l      -$672(a6)
0426: 486dbf1e             pea.l      -$40e2(a5)
042a: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
042e: 2d4a0008             move.l     a2, $8(a6)
0432: 284b                 movea.l    a3, a4
0434: 486efff6             pea.l      -$a(a6)
0438: 2f2e0008             move.l     $8(a6), -(a7)
043c: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0440: 486effee             pea.l      -$12(a6)
0444: 2f0c                 move.l     a4, -(a7)
0446: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
044a: 4a6ef922             tst.w      -$6de(a6)
044e: 4fef0028             lea.l      $28(a7), a7
0452: 6606                 bne.b      $45a
0454: 3d6df534f922         move.w     -$acc(a5), -$6de(a6)
045a: 302df534             move.w     -$acc(a5), d0
045e: d06ef922             add.w      -$6de(a6), d0
0462: 3040                 movea.w    d0, a0
0464: b1edd138             cmpa.l     -$2ec8(a5), a0
0468: 6c5a                 bge.b      $4c4
046a: 2f2ef91e             move.l     -$6e2(a6), -(a7)
046e: 4ead06a2             jsr        $6a2(a5) ; CODE9+0086
0472: b0ae000c             cmp.l      $c(a6), d0
0476: 588f                 addq.l     #$4, a7
0478: 6c4a                 bge.b      $4c4
047a: 4aaef97e             tst.l      -$682(a6)
047e: 6744                 beq.b      $4c4
0480: 206ef986             movea.l    -$67a(a6), a0
0484: 4a680004             tst.w      $4(a0)
0488: 660c                 bne.b      $496
048a: 206ef986             movea.l    -$67a(a6), a0
048e: 4a28001c             tst.b      $1c(a0)
0492: 6700fdf2             beq.w      $286
0496: 206ef986             movea.l    -$67a(a6), a0
049a: 30680002             movea.w    $2(a0), a0
049e: 226ef986             movea.l    -$67a(a6), a1
04a2: 3269000a             movea.w    $a(a1), a1
04a6: 93c8                 suba.l     a0, a1
04a8: 206ef97e             movea.l    -$682(a6), a0
04ac: 3050                 movea.w    (a0), a0
04ae: 2d49f91a             move.l     a1, -$6e6(a6)
04b2: 226ef97e             movea.l    -$682(a6), a1
04b6: 3269000a             movea.w    $a(a1), a1
04ba: 93c8                 suba.l     a0, a1
04bc: b3eef91a             cmpa.l     -$6e6(a6), a1
04c0: 6e00fdc4             bgt.w      $286
04c4: 2f2e0008             move.l     $8(a6), -(a7)
04c8: 4ead0afa             jsr        $afa(a5) ; CODE45+042a
04cc: 426dcf04             clr.w      -$30fc(a5)
04d0: 42adb3e2             clr.l      -$4c1e(a5)
04d4: 206dd134             movea.l    -$2ecc(a5), a0
04d8: 3e280004             move.w     $4(a0), d7
04dc: 588f                 addq.l     #$4, a7
04de: 600000a0             bra.w      $580
04e2: 2007                 move.l     d7, d0
04e4: 48c0                 ext.l      d0
04e6: eb88                 lsl.l      #$5, d0
04e8: d0add134             add.l      -$2ecc(a5), d0
04ec: 2d40f97a             move.l     d0, -$686(a6)
04f0: 2040                 movea.l    d0, a0
04f2: 3a28000a             move.w     $a(a0), d5
04f6: 48c5                 ext.l      d5
04f8: 2c05                 move.l     d5, d6
04fa: 2040                 movea.l    d0, a0
04fc: 3050                 movea.w    (a0), a0
04fe: 9c88                 sub.l      a0, d6
0500: 2040                 movea.l    d0, a0
0502: 30680002             movea.w    $2(a0), a0
0506: 9a88                 sub.l      a0, d5
0508: 2f00                 move.l     d0, -(a7)
050a: 486da5ce             pea.l      -$5a32(a5)
050e: 4eba07c2             jsr        $cd2(pc)
0512: 4a6ef924             tst.w      -$6dc(a6)
0516: 508f                 addq.l     #$8, a7
0518: 6734                 beq.b      $54e
051a: 4a2da5ee             tst.b      -$5a12(a5)
051e: 662e                 bne.b      $54e
0520: 2f0b                 move.l     a3, -(a7)
0522: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
0526: 3d40f91c             move.w     d0, -$6e4(a6)
052a: 2e8a                 move.l     a2, (a7)
052c: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
0530: 322ef91c             move.w     -$6e4(a6), d1
0534: 9240                 sub.w      d0, d1
0536: 3041                 movea.w    d1, a0
0538: 2b48a5de             move.l     a0, -$5a22(a5)
053c: 7064                 moveq      #$64, d0
053e: 2e80                 move.l     d0, (a7)
0540: 2f2da5de             move.l     -$5a22(a5), -(a7)
0544: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0548: 2b40a5de             move.l     d0, -$5a22(a5)
054c: 6018                 bra.b      $566
054e: 206ef97a             movea.l    -$686(a6), a0
0552: 7064                 moveq      #$64, d0
0554: c1e80002             muls.w     $2(a0), d0
0558: 4440                 neg.w      d0
055a: 3240                 movea.w    d0, a1
055c: 2b49a5e2             move.l     a1, -$5a1e(a5)
0560: 3050                 movea.w    (a0), a0
0562: 2b48a5e6             move.l     a0, -$5a1a(a5)
0566: 486da5ce             pea.l      -$5a32(a5)
056a: 4ead0912             jsr        $912(a5) ; CODE31+0004
056e: 486da5ce             pea.l      -$5a32(a5)
0572: 4ead0842             jsr        $842(a5) ; CODE28+0004
0576: 508f                 addq.l     #$8, a7
0578: 206ef97a             movea.l    -$686(a6), a0
057c: 3e280006             move.w     $6(a0), d7
0580: 4a47                 tst.w      d7
0582: 6600ff5e             bne.w      $4e2
0586: 536da386             subq.w     #$1, -$5c7a(a5)
058a: 600000b0             bra.w      $63c
058e: 2f2da222             move.l     -$5dde(a5), -(a7)
0592: 2f2d93ac             move.l     -$6c54(a5), -(a7)
0596: 4ead0db2             jsr        $db2(a5) ; CODE52+0242
059a: 4a40                 tst.w      d0
059c: 508f                 addq.l     #$8, a7
059e: 666c                 bne.b      $60c
05a0: 4eba012e             jsr        $6d0(pc)
05a4: 48780220             pea.l      $220.w
05a8: 486efdce             pea.l      -$232(a6)
05ac: 486dbcfe             pea.l      -$4302(a5)
05b0: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
05b4: 48780440             pea.l      $440.w
05b8: 486ef98e             pea.l      -$672(a6)
05bc: 486dbf1e             pea.l      -$40e2(a5)
05c0: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
05c4: 2d4a0008             move.l     a2, $8(a6)
05c8: 284b                 movea.l    a3, a4
05ca: 486efff6             pea.l      -$a(a6)
05ce: 2f2e0008             move.l     $8(a6), -(a7)
05d2: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
05d6: 486effee             pea.l      -$12(a6)
05da: 2f0c                 move.l     a4, -(a7)
05dc: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
05e0: 2b6d93aca222         move.l     -$6c54(a5), -$5dde(a5)
05e6: 536da386             subq.w     #$1, -$5c7a(a5)
05ea: 702c                 moveq      #$2c, d0
05ec: c1eda386             muls.w     -$5c7a(a5), d0
05f0: 41eda226             lea.l      -$5dda(a5), a0
05f4: d088                 add.l      a0, d0
05f6: 2040                 movea.l    d0, a0
05f8: 7001                 moveq      #$1, d0
05fa: 4a40                 tst.w      d0
05fc: 6602                 bne.b      $600
05fe: 7001                 moveq      #$1, d0
0600: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
0604: 4ed1                 jmp        (a1)
0606: 4fef0028             lea.l      $28(a7), a7
060a: 6030                 bra.b      $63c
060c: 4a6da386             tst.w      -$5c7a(a5)
0610: 6e04                 bgt.b      $616
0612: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0616: 2b6da222a222         move.l     -$5dde(a5), -$5dde(a5)
061c: 536da386             subq.w     #$1, -$5c7a(a5)
0620: 702c                 moveq      #$2c, d0
0622: c1eda386             muls.w     -$5c7a(a5), d0
0626: 41eda226             lea.l      -$5dda(a5), a0
062a: d088                 add.l      a0, d0
062c: 2040                 movea.l    d0, a0
062e: 7001                 moveq      #$1, d0
0630: 4a40                 tst.w      d0
0632: 6602                 bne.b      $636
0634: 7001                 moveq      #$1, d0
0636: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
063a: 4ed1                 jmp        (a1)
063c: 41eda5ce             lea.l      -$5a32(a5), a0
0640: 43eef926             lea.l      -$6da(a6), a1
0644: 7007                 moveq      #$7, d0
0646: 20d9                 move.l     (a1)+, (a0)+
0648: 51c8fffc             dbra       d0, $646
064c: 30d9                 move.w     (a1)+, (a0)+
064e: 3b6ef924b3f2         move.w     -$6dc(a6), -$4c0e(a5)
0654: 4eba007a             jsr        $6d0(pc)
0658: 41eda5f0             lea.l      -$5a10(a5), a0
065c: 2008                 move.l     a0, d0
065e: 4cdf1ce0             movem.l    (a7)+, d5-d7/a2-a4
0662: 4e5e                 unlk       a6
0664: 4e75                 rts        
0666: 48e70338             movem.l    d6-d7/a2-a4, -(a7)
066a: 7e00                 moveq      #$0, d7
066c: 49edbf1e             lea.l      -$40e2(a5), a4
0670: 6028                 bra.b      $69a
0672: 7c00                 moveq      #$0, d6
0674: 264c                 movea.l    a4, a3
0676: 3446                 movea.w    d6, a2
0678: d5ca                 adda.l     a2, a2
067a: 6012                 bra.b      $68e
067c: 204b                 movea.l    a3, a0
067e: d1ca                 adda.l     a2, a0
0680: 3010                 move.w     (a0), d0
0682: 48c0                 ext.l      d0
0684: 81fc0064             divs.w     #$64, d0
0688: 3080                 move.w     d0, (a0)
068a: 5246                 addq.w     #$1, d6
068c: 548a                 addq.l     #$2, a2
068e: 0c460011             cmpi.w     #$11, d6
0692: 65e8                 bcs.b      $67c
0694: 5247                 addq.w     #$1, d7
0696: 49ec0022             lea.l      $22(a4), a4
069a: 0c470020             cmpi.w     #$20, d7
069e: 65d2                 bcs.b      $672
06a0: 7e00                 moveq      #$0, d7
06a2: 49ed9412             lea.l      -$6bee(a5), a4
06a6: 600e                 bra.b      $6b6
06a8: 3014                 move.w     (a4), d0
06aa: 48c0                 ext.l      d0
06ac: 81fc0064             divs.w     #$64, d0
06b0: 3880                 move.w     d0, (a4)
06b2: 5247                 addq.w     #$1, d7
06b4: 548c                 addq.l     #$2, a4
06b6: 0c470080             cmpi.w     #$80, d7
06ba: 65ec                 bcs.b      $6a8
06bc: 302d9a56             move.w     -$65aa(a5), d0
06c0: 48c0                 ext.l      d0
06c2: 81fc0064             divs.w     #$64, d0
06c6: 3b409a56             move.w     d0, -$65aa(a5)
06ca: 4cdf1cc0             movem.l    (a7)+, d6-d7/a2-a4
06ce: 4e75                 rts        
06d0: 48e70338             movem.l    d6-d7/a2-a4, -(a7)
06d4: 7e00                 moveq      #$0, d7
06d6: 49edbf1e             lea.l      -$40e2(a5), a4
06da: 6024                 bra.b      $700
06dc: 7c00                 moveq      #$0, d6
06de: 264c                 movea.l    a4, a3
06e0: 3446                 movea.w    d6, a2
06e2: d5ca                 adda.l     a2, a2
06e4: 600e                 bra.b      $6f4
06e6: 204b                 movea.l    a3, a0
06e8: d1ca                 adda.l     a2, a0
06ea: 7064                 moveq      #$64, d0
06ec: c1d0                 muls.w     (a0), d0
06ee: 3080                 move.w     d0, (a0)
06f0: 5246                 addq.w     #$1, d6
06f2: 548a                 addq.l     #$2, a2
06f4: 0c460011             cmpi.w     #$11, d6
06f8: 65ec                 bcs.b      $6e6
06fa: 5247                 addq.w     #$1, d7
06fc: 49ec0022             lea.l      $22(a4), a4
0700: 0c470020             cmpi.w     #$20, d7
0704: 65d6                 bcs.b      $6dc
0706: 7e00                 moveq      #$0, d7
0708: 49ed9412             lea.l      -$6bee(a5), a4
070c: 600a                 bra.b      $718
070e: 7064                 moveq      #$64, d0
0710: c1d4                 muls.w     (a4), d0
0712: 3880                 move.w     d0, (a4)
0714: 5247                 addq.w     #$1, d7
0716: 548c                 addq.l     #$2, a4
0718: 0c470080             cmpi.w     #$80, d7
071c: 65f0                 bcs.b      $70e
071e: 7064                 moveq      #$64, d0
0720: c1ed9a56             muls.w     -$65aa(a5), d0
0724: 3b409a56             move.w     d0, -$65aa(a5)
0728: 4cdf1cc0             movem.l    (a7)+, d6-d7/a2-a4
072c: 4e75                 rts        
072e: 4e560000             link.w     a6, #$0
0732: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
0736: 286e0008             movea.l    $8(a6), a4
073a: 0c6e00020010         cmpi.w     #$2, $10(a6)
0740: 6604                 bne.b      $746
0742: 7000                 moveq      #$0, d0
0744: 6056                 bra.b      $79c
0746: 202c000c             move.l     $c(a4), d0
074a: b0ae000c             cmp.l      $c(a6), d0
074e: 6604                 bne.b      $754
0750: 200c                 move.l     a4, d0
0752: 6048                 bra.b      $79c
0754: 3e2c0004             move.w     $4(a4), d7
0758: 7c01                 moveq      #$1, d6
075a: dc6e0010             add.w      $10(a6), d6
075e: 6036                 bra.b      $796
0760: 2007                 move.l     d7, d0
0762: 48c0                 ext.l      d0
0764: eb88                 lsl.l      #$5, d0
0766: d0add134             add.l      -$2ecc(a5), d0
076a: 2840                 movea.l    d0, a4
076c: 4a2c001a             tst.b      $1a(a4)
0770: 6604                 bne.b      $776
0772: 3006                 move.w     d6, d0
0774: 6002                 bra.b      $778
0776: 7000                 moveq      #$0, d0
0778: 3f00                 move.w     d0, -(a7)
077a: 2f2e000c             move.l     $c(a6), -(a7)
077e: 2f0c                 move.l     a4, -(a7)
0780: 4ebaffac             jsr        $72e(pc)
0784: 2640                 movea.l    d0, a3
0786: 200b                 move.l     a3, d0
0788: 4fef000a             lea.l      $a(a7), a7
078c: 6704                 beq.b      $792
078e: 200b                 move.l     a3, d0
0790: 600a                 bra.b      $79c
0792: 3e2c0006             move.w     $6(a4), d7
0796: 4a47                 tst.w      d7
0798: 66c6                 bne.b      $760
079a: 7000                 moveq      #$0, d0
079c: 4cdf18c0             movem.l    (a7)+, d6-d7/a3-a4
07a0: 4e5e                 unlk       a6
07a2: 4e75                 rts        
07a4: 4e56fffc             link.w     a6, #$fffc
07a8: 2f0c                 move.l     a4, -(a7)
07aa: 4eba039a             jsr        $b46(pc)
07ae: 2840                 movea.l    d0, a4
07b0: 200c                 move.l     a4, d0
07b2: 6738                 beq.b      $7ec
07b4: 197c007f0019         move.b     #$7f, $19(a4)
07ba: 2f0c                 move.l     a4, -(a7)
07bc: 2f2df52e             move.l     -$ad2(a5), -(a7)
07c0: 4eba03fa             jsr        $bbc(pc)
07c4: 206df52e             movea.l    -$ad2(a5), a0
07c8: 30280002             move.w     $2(a0), d0
07cc: 4440                 neg.w      d0
07ce: 3880                 move.w     d0, (a4)
07d0: 206df52e             movea.l    -$ad2(a5), a0
07d4: 3010                 move.w     (a0), d0
07d6: 4440                 neg.w      d0
07d8: 39400002             move.w     d0, $2(a4)
07dc: 206df52e             movea.l    -$ad2(a5), a0
07e0: 4a680004             tst.w      $4(a0)
07e4: 508f                 addq.l     #$8, a7
07e6: 6604                 bne.b      $7ec
07e8: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
07ec: 285f                 movea.l    (a7)+, a4
07ee: 4e5e                 unlk       a6
07f0: 4e75                 rts        
07f2: 206df52e             movea.l    -$ad2(a5), a0
07f6: 42680004             clr.w      $4(a0)
07fa: 4e75                 rts        
07fc: 4e56fff8             link.w     a6, #$fff8
0800: 48e70108             movem.l    d7/a4, -(a7)
0804: 48780110             pea.l      $110.w
0808: 486dbcfe             pea.l      -$4302(a5)
080c: 4ead0d72             jsr        $d72(a5) ; CODE53+0004
0810: 2d40fffc             move.l     d0, -$4(a6)
0814: 2eae000c             move.l     $c(a6), (a7)
0818: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
081c: 2e80                 move.l     d0, (a7)
081e: 2f2e000c             move.l     $c(a6), -(a7)
0822: 4ead0d72             jsr        $d72(a5) ; CODE53+0004
0826: 2d40fff8             move.l     d0, -$8(a6)
082a: 2eae0010             move.l     $10(a6), (a7)
082e: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
0832: 2e80                 move.l     d0, (a7)
0834: 2f2e0010             move.l     $10(a6), -(a7)
0838: 4ead0d72             jsr        $d72(a5) ; CODE53+0004
083c: 2e2efff8             move.l     -$8(a6), d7
0840: deaefffc             add.l      -$4(a6), d7
0844: d080                 add.l      d0, d0
0846: de80                 add.l      d0, d7
0848: 4ead0a22             jsr        $a22(a5) ; CODE37+0e2e
084c: 4a87                 tst.l      d7
084e: 4fef0010             lea.l      $10(a7), a7
0852: 6602                 bne.b      $856
0854: 7e01                 moveq      #$1, d7
0856: 4267                 clr.w      -(a7)
0858: 2f07                 move.l     d7, -(a7)
085a: 2f2dd134             move.l     -$2ecc(a5), -(a7)
085e: 4ebafece             jsr        $72e(pc)
0862: 2840                 movea.l    d0, a4
0864: 200c                 move.l     a4, d0
0866: 4fef000a             lea.l      $a(a7), a7
086a: 660c                 bne.b      $878
086c: 206df52e             movea.l    -$ad2(a5), a0
0870: 2147000c             move.l     d7, $c(a0)
0874: 7000                 moveq      #$0, d0
0876: 603e                 bra.b      $8b6
0878: 206df52e             movea.l    -$ad2(a5), a0
087c: 2147000c             move.l     d7, $c(a0)
0880: 206df52e             movea.l    -$ad2(a5), a0
0884: 316c00040004         move.w     $4(a4), $4(a0)
088a: 206df52e             movea.l    -$ad2(a5), a0
088e: 316c00020002         move.w     $2(a4), $2(a0)
0894: 206df52e             movea.l    -$ad2(a5), a0
0898: 3094                 move.w     (a4), (a0)
089a: 206df52e             movea.l    -$ad2(a5), a0
089e: 4a680004             tst.w      $4(a0)
08a2: 6610                 bne.b      $8b4
08a4: 206df52e             movea.l    -$ad2(a5), a0
08a8: 30280002             move.w     $2(a0), d0
08ac: b050                 cmp.w      (a0), d0
08ae: 6704                 beq.b      $8b4
08b0: 7000                 moveq      #$0, d0
08b2: 6002                 bra.b      $8b6
08b4: 200c                 move.l     a4, d0
08b6: 4cdf1080             movem.l    (a7)+, d7/a4
08ba: 4e5e                 unlk       a6
08bc: 4e75                 rts        
08be: 4e560000             link.w     a6, #$0
08c2: 48e70738             movem.l    d5-d7/a2-a4, -(a7)
08c6: 286e0008             movea.l    $8(a6), a4
08ca: b9edd134             cmpa.l     -$2ecc(a5), a4
08ce: 6706                 beq.b      $8d6
08d0: 4a2c0010             tst.b      $10(a4)
08d4: 6704                 beq.b      $8da
08d6: 7e00                 moveq      #$0, d7
08d8: 6002                 bra.b      $8dc
08da: 7e01                 moveq      #$1, d7
08dc: 2c3cf4143e00         move.l     #$f4143e00, d6
08e2: 97cb                 suba.l     a3, a3
08e4: 3a2c0004             move.w     $4(a4), d5
08e8: 602c                 bra.b      $916
08ea: 2005                 move.l     d5, d0
08ec: 48c0                 ext.l      d0
08ee: eb88                 lsl.l      #$5, d0
08f0: d0add134             add.l      -$2ecc(a5), d0
08f4: 2440                 movea.l    d0, a2
08f6: 3a2a000a             move.w     $a(a2), d5
08fa: 48c5                 ext.l      d5
08fc: 3052                 movea.w    (a2), a0
08fe: 9a88                 sub.l      a0, d5
0900: bc85                 cmp.l      d5, d6
0902: 6c0e                 bge.b      $912
0904: 4a47                 tst.w      d7
0906: 6706                 beq.b      $90e
0908: 4a2a0010             tst.b      $10(a2)
090c: 6704                 beq.b      $912
090e: 2c05                 move.l     d5, d6
0910: 264a                 movea.l    a2, a3
0912: 3a2a0006             move.w     $6(a2), d5
0916: 4a45                 tst.w      d5
0918: 66d0                 bne.b      $8ea
091a: 200b                 move.l     a3, d0
091c: 4cdf1ce0             movem.l    (a7)+, d5-d7/a2-a4
0920: 4e5e                 unlk       a6
0922: 4e75                 rts        
0924: 4e560000             link.w     a6, #$0
0928: 48e71f18             movem.l    d3-d7/a3-a4, -(a7)
092c: 286e0008             movea.l    $8(a6), a4
0930: b9edd134             cmpa.l     -$2ecc(a5), a4
0934: 650e                 bcs.b      $944
0936: 202dd138             move.l     -$2ec8(a5), d0
093a: eb88                 lsl.l      #$5, d0
093c: d0add134             add.l      -$2ecc(a5), d0
0940: b08c                 cmp.l      a4, d0
0942: 6204                 bhi.b      $948
0944: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0948: 3e2c0004             move.w     $4(a4), d7
094c: 6770                 beq.b      $9be
094e: 4a2c001e             tst.b      $1e(a4)
0952: 666a                 bne.b      $9be
0954: 197c0001001e         move.b     #$1, $1e(a4)
095a: 2a3cf4143e00         move.l     #$f4143e00, d5
0960: 2c05                 move.l     d5, d6
0962: 6044                 bra.b      $9a8
0964: 2007                 move.l     d7, d0
0966: 48c0                 ext.l      d0
0968: eb88                 lsl.l      #$5, d0
096a: d0add134             add.l      -$2ecc(a5), d0
096e: 2640                 movea.l    d0, a3
0970: be6b0006             cmp.w      $6(a3), d7
0974: 6604                 bne.b      $97a
0976: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
097a: 2f0b                 move.l     a3, -(a7)
097c: 4ebaffa6             jsr        $924(pc)
0980: 3e2b000a             move.w     $a(a3), d7
0984: 2807                 move.l     d7, d4
0986: 48c4                 ext.l      d4
0988: 3053                 movea.w    (a3), a0
098a: 9888                 sub.l      a0, d4
098c: 2607                 move.l     d7, d3
098e: 48c3                 ext.l      d3
0990: 306b0002             movea.w    $2(a3), a0
0994: 9688                 sub.l      a0, d3
0996: bc84                 cmp.l      d4, d6
0998: 588f                 addq.l     #$4, a7
099a: 6c02                 bge.b      $99e
099c: 2c04                 move.l     d4, d6
099e: ba83                 cmp.l      d3, d5
09a0: 6c02                 bge.b      $9a4
09a2: 2a03                 move.l     d3, d5
09a4: 3e2b0006             move.w     $6(a3), d7
09a8: 4a47                 tst.w      d7
09aa: 66b8                 bne.b      $964
09ac: ba86                 cmp.l      d6, d5
09ae: 6f04                 ble.b      $9b4
09b0: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
09b4: 39460002             move.w     d6, $2(a4)
09b8: 3885                 move.w     d5, (a4)
09ba: 422c001e             clr.b      $1e(a4)
09be: 4cdf18f8             movem.l    (a7)+, d3-d7/a3-a4
09c2: 4e5e                 unlk       a6
09c4: 4e75                 rts        
09c6: 4e560000             link.w     a6, #$0
09ca: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
09ce: 286e0008             movea.l    $8(a6), a4
09d2: b9edf52e             cmpa.l     -$ad2(a5), a4
09d6: 670000bc             beq.w      $a94
09da: 4a2c001e             tst.b      $1e(a4)
09de: 6704                 beq.b      $9e4
09e0: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
09e4: 197c0001001e         move.b     #$1, $1e(a4)
09ea: 4a2c001c             tst.b      $1c(a4)
09ee: 670a                 beq.b      $9fa
09f0: 4a6c0004             tst.w      $4(a4)
09f4: 6704                 beq.b      $9fa
09f6: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
09fa: 2e3cf4143e00         move.l     #$f4143e00, d7
0a00: 3c2c0004             move.w     $4(a4), d6
0a04: 6022                 bra.b      $a28
0a06: 2006                 move.l     d6, d0
0a08: 48c0                 ext.l      d0
0a0a: eb88                 lsl.l      #$5, d0
0a0c: d0add134             add.l      -$2ecc(a5), d0
0a10: 2640                 movea.l    d0, a3
0a12: 3a2b000a             move.w     $a(a3), d5
0a16: 48c5                 ext.l      d5
0a18: 306b0002             movea.w    $2(a3), a0
0a1c: 9a88                 sub.l      a0, d5
0a1e: be85                 cmp.l      d5, d7
0a20: 6c02                 bge.b      $a24
0a22: 2e05                 move.l     d5, d7
0a24: 3c2b0006             move.w     $6(a3), d6
0a28: 4a46                 tst.w      d6
0a2a: 66da                 bne.b      $a06
0a2c: 45ec0004             lea.l      $4(a4), a2
0a30: 605a                 bra.b      $a8c
0a32: 2006                 move.l     d6, d0
0a34: 48c0                 ext.l      d0
0a36: eb88                 lsl.l      #$5, d0
0a38: d0add134             add.l      -$2ecc(a5), d0
0a3c: 2640                 movea.l    d0, a3
0a3e: 3a2b000a             move.w     $a(a3), d5
0a42: 48c5                 ext.l      d5
0a44: 3813                 move.w     (a3), d4
0a46: 3044                 movea.w    d4, a0
0a48: 9a88                 sub.l      a0, d5
0a4a: be85                 cmp.l      d5, d7
0a4c: 6e0c                 bgt.b      $a5a
0a4e: be85                 cmp.l      d5, d7
0a50: 6622                 bne.b      $a74
0a52: 3013                 move.w     (a3), d0
0a54: b06b0002             cmp.w      $2(a3), d0
0a58: 671a                 beq.b      $a74
0a5a: 3a2b0006             move.w     $6(a3), d5
0a5e: 4a45                 tst.w      d5
0a60: 6d08                 blt.b      $a6a
0a62: 3045                 movea.w    d5, a0
0a64: b1edd138             cmpa.l     -$2ec8(a5), a0
0a68: 6d04                 blt.b      $a6e
0a6a: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0a6e: 34ab0006             move.w     $6(a3), (a2)
0a72: 6018                 bra.b      $a8c
0a74: b86b0002             cmp.w      $2(a3), d4
0a78: 6606                 bne.b      $a80
0a7a: 426b0004             clr.w      $4(a3)
0a7e: 6008                 bra.b      $a88
0a80: 2f0b                 move.l     a3, -(a7)
0a82: 4ebaff42             jsr        $9c6(pc)
0a86: 588f                 addq.l     #$4, a7
0a88: 45eb0006             lea.l      $6(a3), a2
0a8c: 3c12                 move.w     (a2), d6
0a8e: 66a2                 bne.b      $a32
0a90: 422c001e             clr.b      $1e(a4)
0a94: 4cdf1cf0             movem.l    (a7)+, d4-d7/a2-a4
0a98: 4e5e                 unlk       a6
0a9a: 4e75                 rts        
0a9c: 4e56fffc             link.w     a6, #$fffc
0aa0: 48780020             pea.l      $20.w
0aa4: 2f2e0008             move.l     $8(a6), -(a7)
0aa8: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0aac: 206e0008             movea.l    $8(a6), a0
0ab0: 316df5320006         move.w     -$ace(a5), $6(a0)
0ab6: 91edd134             suba.l     -$2ecc(a5), a0
0aba: 2008                 move.l     a0, d0
0abc: ea80                 asr.l      #$5, d0
0abe: 3b40f532             move.w     d0, -$ace(a5)
0ac2: 4e5e                 unlk       a6
0ac4: 4e75                 rts        
0ac6: 48e70018             movem.l    a3-a4, -(a7)
0aca: 202dd138             move.l     -$2ec8(a5), d0
0ace: eb88                 lsl.l      #$5, d0
0ad0: d0add134             add.l      -$2ecc(a5), d0
0ad4: 2840                 movea.l    d0, a4
0ad6: 266dd134             movea.l    -$2ecc(a5), a3
0ada: 6012                 bra.b      $aee
0adc: 4a2b001e             tst.b      $1e(a3)
0ae0: 6608                 bne.b      $aea
0ae2: 2f0b                 move.l     a3, -(a7)
0ae4: 4ebaffb6             jsr        $a9c(pc)
0ae8: 588f                 addq.l     #$4, a7
0aea: 47eb0020             lea.l      $20(a3), a3
0aee: b9cb                 cmpa.l     a3, a4
0af0: 62ea                 bhi.b      $adc
0af2: 4cdf1800             movem.l    (a7)+, a3-a4
0af6: 4e75                 rts        
0af8: 4e560000             link.w     a6, #$0
0afc: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
0b00: 3e2e000c             move.w     $c(a6), d7
0b04: 701e                 moveq      #$1e, d0
0b06: d0ae0008             add.l      $8(a6), d0
0b0a: 2840                 movea.l    d0, a4
0b0c: 1014                 move.b     (a4), d0
0b0e: 4880                 ext.w      d0
0b10: be40                 cmp.w      d0, d7
0b12: 672a                 beq.b      $b3e
0b14: 1887                 move.b     d7, (a4)
0b16: 206e0008             movea.l    $8(a6), a0
0b1a: 3c280004             move.w     $4(a0), d6
0b1e: 601a                 bra.b      $b3a
0b20: 2006                 move.l     d6, d0
0b22: 48c0                 ext.l      d0
0b24: eb88                 lsl.l      #$5, d0
0b26: d0add134             add.l      -$2ecc(a5), d0
0b2a: 2640                 movea.l    d0, a3
0b2c: 3f07                 move.w     d7, -(a7)
0b2e: 2f0b                 move.l     a3, -(a7)
0b30: 4ebaffc6             jsr        $af8(pc)
0b34: 5c8f                 addq.l     #$6, a7
0b36: 3c2b0006             move.w     $6(a3), d6
0b3a: 4a46                 tst.w      d6
0b3c: 66e2                 bne.b      $b20
0b3e: 4cdf18c0             movem.l    (a7)+, d6-d7/a3-a4
0b42: 4e5e                 unlk       a6
0b44: 4e75                 rts        
0b46: 2f0c                 move.l     a4, -(a7)
0b48: 4a6df532             tst.w      -$ace(a5)
0b4c: 6634                 bne.b      $b82
0b4e: 2f2dd134             move.l     -$2ecc(a5), -(a7)
0b52: 4ebafe72             jsr        $9c6(pc)
0b56: 3ebc0001             move.w     #$1, (a7)
0b5a: 2f2dd134             move.l     -$2ecc(a5), -(a7)
0b5e: 4ebaff98             jsr        $af8(pc)
0b62: 4ead0a22             jsr        $a22(a5) ; CODE37+0e2e
0b66: 4ebaff5e             jsr        $ac6(pc)
0b6a: 4257                 clr.w      (a7)
0b6c: 2f2dd134             move.l     -$2ecc(a5), -(a7)
0b70: 4ebaff86             jsr        $af8(pc)
0b74: 4a6df532             tst.w      -$ace(a5)
0b78: 4fef000c             lea.l      $c(a7), a7
0b7c: 6604                 bne.b      $b82
0b7e: 7000                 moveq      #$0, d0
0b80: 6036                 bra.b      $bb8
0b82: 4a6df532             tst.w      -$ace(a5)
0b86: 6d0a                 blt.b      $b92
0b88: 306df532             movea.w    -$ace(a5), a0
0b8c: b1edd138             cmpa.l     -$2ec8(a5), a0
0b90: 6d04                 blt.b      $b96
0b92: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0b96: 302df532             move.w     -$ace(a5), d0
0b9a: 48c0                 ext.l      d0
0b9c: eb88                 lsl.l      #$5, d0
0b9e: d0add134             add.l      -$2ecc(a5), d0
0ba2: 2840                 movea.l    d0, a4
0ba4: 3b6c0006f532         move.w     $6(a4), -$ace(a5)
0baa: 48780020             pea.l      $20.w
0bae: 2f0c                 move.l     a4, -(a7)
0bb0: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0bb4: 200c                 move.l     a4, d0
0bb6: 508f                 addq.l     #$8, a7
0bb8: 285f                 movea.l    (a7)+, a4
0bba: 4e75                 rts        
0bbc: 4e560000             link.w     a6, #$0
0bc0: 48e70138             movem.l    d7/a2-a4, -(a7)
0bc4: 266e0008             movea.l    $8(a6), a3
0bc8: 246e000c             movea.l    $c(a6), a2
0bcc: 49eb0004             lea.l      $4(a3), a4
0bd0: 3e14                 move.w     (a4), d7
0bd2: 4a47                 tst.w      d7
0bd4: 6d08                 blt.b      $bde
0bd6: 3047                 movea.w    d7, a0
0bd8: b1edd138             cmpa.l     -$2ec8(a5), a0
0bdc: 6d04                 blt.b      $be2
0bde: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0be2: 3014                 move.w     (a4), d0
0be4: 48c0                 ext.l      d0
0be6: eb88                 lsl.l      #$5, d0
0be8: d0add134             add.l      -$2ecc(a5), d0
0bec: b08a                 cmp.l      a2, d0
0bee: 6604                 bne.b      $bf4
0bf0: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0bf4: 35540006             move.w     (a4), $6(a2)
0bf8: b5edd134             cmpa.l     -$2ecc(a5), a2
0bfc: 650e                 bcs.b      $c0c
0bfe: 202dd138             move.l     -$2ec8(a5), d0
0c02: eb88                 lsl.l      #$5, d0
0c04: d0add134             add.l      -$2ecc(a5), d0
0c08: b08a                 cmp.l      a2, d0
0c0a: 6204                 bhi.b      $c10
0c0c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0c10: 200a                 move.l     a2, d0
0c12: 90add134             sub.l      -$2ecc(a5), d0
0c16: ea80                 asr.l      #$5, d0
0c18: 3880                 move.w     d0, (a4)
0c1a: 4cdf1c80             movem.l    (a7)+, d7/a2-a4
0c1e: 4e5e                 unlk       a6
0c20: 4e75                 rts        
0c22: 4e560000             link.w     a6, #$0
0c26: 48e70138             movem.l    d7/a2-a4, -(a7)
0c2a: 266e0008             movea.l    $8(a6), a3
0c2e: 4ebaff16             jsr        $b46(pc)
0c32: 2840                 movea.l    d0, a4
0c34: 200c                 move.l     a4, d0
0c36: 67000092             beq.w      $cca
0c3a: 202e000c             move.l     $c(a6), d0
0c3e: b0ae0010             cmp.l      $10(a6), d0
0c42: 6c04                 bge.b      $c48
0c44: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0c48: 196b0017001d         move.b     $17(a3), $1d(a4)
0c4e: 196b001b0018         move.b     $1b(a3), $18(a4)
0c54: 196b001d001c         move.b     $1d(a3), $1c(a4)
0c5a: 396e000e0002         move.w     $e(a6), $2(a4)
0c60: 38ae0012             move.w     $12(a6), (a4)
0c64: 2f0c                 move.l     a4, -(a7)
0c66: 2f2df52e             move.l     -$ad2(a5), -(a7)
0c6a: 4ebaff50             jsr        $bbc(pc)
0c6e: 396b0012000a         move.w     $12(a3), $a(a4)
0c74: 196b0020001a         move.b     $20(a3), $1a(a4)
0c7a: 196b0021001b         move.b     $21(a3), $1b(a4)
0c80: 196b001f0019         move.b     $1f(a3), $19(a4)
0c86: 102b0021             move.b     $21(a3), d0
0c8a: 4880                 ext.w      d0
0c8c: 1e2b0020             move.b     $20(a3), d7
0c90: 4887                 ext.w      d7
0c92: cffc0011             muls.w     #$11, d7
0c96: 41edbcfe             lea.l      -$4302(a5), a0
0c9a: de88                 add.l      a0, d7
0c9c: 3040                 movea.w    d0, a0
0c9e: de88                 add.l      a0, d7
0ca0: 45ec0010             lea.l      $10(a4), a2
0ca4: 284b                 movea.l    a3, a4
0ca6: 508f                 addq.l     #$8, a7
0ca8: 600c                 bra.b      $cb6
0caa: 2047                 movea.l    d7, a0
0cac: 5287                 addq.l     #$1, d7
0cae: 4a10                 tst.b      (a0)
0cb0: 6602                 bne.b      $cb4
0cb2: 14d4                 move.b     (a4), (a2)+
0cb4: 528c                 addq.l     #$1, a4
0cb6: 4a14                 tst.b      (a4)
0cb8: 66f0                 bne.b      $caa
0cba: 4212                 clr.b      (a2)
0cbc: 206df52e             movea.l    -$ad2(a5), a0
0cc0: 4a680004             tst.w      $4(a0)
0cc4: 6604                 bne.b      $cca
0cc6: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0cca: 4cdf1c80             movem.l    (a7)+, d7/a2-a4
0cce: 4e5e                 unlk       a6
0cd0: 4e75                 rts        
0cd2: 4e560000             link.w     a6, #$0
0cd6: 48e70138             movem.l    d7/a2-a4, -(a7)
0cda: 266e0008             movea.l    $8(a6), a3
0cde: 246e000c             movea.l    $c(a6), a2
0ce2: 49eb0010             lea.l      $10(a3), a4
0ce6: 306a000a             movea.w    $a(a2), a0
0cea: 2888                 move.l     a0, (a4)
0cec: 48780064             pea.l      $64.w
0cf0: 2f14                 move.l     (a4), -(a7)
0cf2: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0cf6: 2880                 move.l     d0, (a4)
0cf8: 176a001a0020         move.b     $1a(a2), $20(a3)
0cfe: 176a001b0021         move.b     $1b(a2), $21(a3)
0d04: 102a0019             move.b     $19(a2), d0
0d08: 4880                 ext.w      d0
0d0a: 3740001e             move.w     d0, $1e(a3)
0d0e: 42ab0018             clr.l      $18(a3)
0d12: 42ab0014             clr.l      $14(a3)
0d16: 102a001c             move.b     $1c(a2), d0
0d1a: 4880                 ext.w      d0
0d1c: 3740001c             move.w     d0, $1c(a3)
0d20: 102b0021             move.b     $21(a3), d0
0d24: 4880                 ext.w      d0
0d26: 122b0020             move.b     $20(a3), d1
0d2a: 4881                 ext.w      d1
0d2c: c3fc0011             muls.w     #$11, d1
0d30: 49edbcfe             lea.l      -$4302(a5), a4
0d34: d28c                 add.l      a4, d1
0d36: 3840                 movea.w    d0, a4
0d38: d28c                 add.l      a4, d1
0d3a: 2841                 movea.l    d1, a4
0d3c: 7e10                 moveq      #$10, d7
0d3e: de8a                 add.l      a2, d7
0d40: 244b                 movea.l    a3, a2
0d42: 600e                 bra.b      $d52
0d44: 1494                 move.b     (a4), (a2)
0d46: 6606                 bne.b      $d4e
0d48: 2047                 movea.l    d7, a0
0d4a: 5287                 addq.l     #$1, d7
0d4c: 1490                 move.b     (a0), (a2)
0d4e: 528a                 addq.l     #$1, a2
0d50: 528c                 addq.l     #$1, a4
0d52: 2047                 movea.l    d7, a0
0d54: 4a10                 tst.b      (a0)
0d56: 66ec                 bne.b      $d44
0d58: 4a14                 tst.b      (a4)
0d5a: 66e8                 bne.b      $d44
0d5c: 4212                 clr.b      (a2)
0d5e: 4cdf1c80             movem.l    (a7)+, d7/a2-a4
0d62: 4e5e                 unlk       a6
0d64: 4e75                 rts        
0d66: 4e560000             link.w     a6, #$0
0d6a: 48e70108             movem.l    d7/a4, -(a7)
0d6e: 206df52e             movea.l    -$ad2(a5), a0
0d72: 3e280004             move.w     $4(a0), d7
0d76: 6024                 bra.b      $d9c
0d78: 2007                 move.l     d7, d0
0d7a: 48c0                 ext.l      d0
0d7c: eb88                 lsl.l      #$5, d0
0d7e: d0add134             add.l      -$2ecc(a5), d0
0d82: 2840                 movea.l    d0, a4
0d84: 2f0c                 move.l     a4, -(a7)
0d86: 206e0008             movea.l    $8(a6), a0
0d8a: 4e90                 jsr        (a0)
0d8c: be6c0006             cmp.w      $6(a4), d7
0d90: 588f                 addq.l     #$4, a7
0d92: 6604                 bne.b      $d98
0d94: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0d98: 3e2c0006             move.w     $6(a4), d7
0d9c: 4a47                 tst.w      d7
0d9e: 66d8                 bne.b      $d78
0da0: 4cdf1080             movem.l    (a7)+, d7/a4
0da4: 4e5e                 unlk       a6
0da6: 4e75                 rts        
