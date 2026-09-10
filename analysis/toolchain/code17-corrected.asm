0004: 4e56d8ce             link.w     a6, #$d8ce
0008: 2f0c                 move.l     a4, -(a7)
000a: 286e000c             movea.l    $c(a6), a4
000e: 2d7c00002710d8da     move.l     #$2710, -$2726(a6)
0016: 2d7c54455854fff0     move.l     #$54455854, -$10(a6)
001e: 3f3c0001             move.w     #$1, -(a7)
0022: 486efff0             pea.l      -$10(a6)
0026: 2f0c                 move.l     a4, -(a7)
0028: 4ead0612             jsr        $612(a5) ; CODE9+0b82
002c: 4a40                 tst.w      d0
002e: 4fef000a             lea.l      $a(a7), a7
0032: 67000086             beq.w      $ba
0036: 4267                 clr.w      -(a7)
0038: 486c000a             pea.l      $a(a4)
003c: 3f2c0006             move.w     $6(a4), -(a7)
0040: 486effee             pea.l      -$12(a6)
0044: 4ead0b1a             jsr        $b1a(a5) ; CODE34+01d2
0048: 4a5f                 tst.w      (a7)+
004a: 6704                 beq.b      $50
004c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0050: 286e0008             movea.l    $8(a6), a4
0054: 49ec00a0             lea.l      $a0(a4), a4
0058: 4267                 clr.w      -(a7)
005a: 3f2effee             move.w     -$12(a6), -(a7)
005e: 486ed8da             pea.l      -$2726(a6)
0062: 486ed8de             pea.l      -$2722(a6)
0066: 4ead0b2a             jsr        $b2a(a5) ; CODE34+022c
006a: 486ed8de             pea.l      -$2722(a6)
006e: 306ed8dc             movea.w    -$2724(a6), a0
0072: 2f08                 move.l     a0, -(a7)
0074: 2f14                 move.l     (a4), -(a7)
0076: a9de                 dc.w       $a9de
0078: 548f                 addq.l     #$2, a7
007a: 0cae00002710d8da     cmpi.l     #$2710, -$2726(a6)
0082: 67d4                 beq.b      $58
0084: 4267                 clr.w      -(a7)
0086: 3f2effee             move.w     -$12(a6), -(a7)
008a: 4ead0b22             jsr        $b22(a5) ; CODE34+0212
008e: 4a5f                 tst.w      (a7)+
0090: 6704                 beq.b      $96
0092: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0096: 2f2e0008             move.l     $8(a6), -(a7)
009a: a873                 dc.w       $a873
009c: 2054                 movea.l    (a4), a0
009e: 2050                 movea.l    (a0), a0
00a0: 2d680008d8d2         move.l     $8(a0), -$272e(a6)
00a6: 2d68000cd8d6         move.l     $c(a0), -$272a(a6)
00ac: 486ed8d2             pea.l      -$272e(a6)
00b0: a928                 dc.w       $a928
00b2: 2f2e0008             move.l     $8(a6), -(a7)
00b6: 4eba019e             jsr        $256(pc)
00ba: 286ed8ca             movea.l    -$2736(a6), a4
00be: 4e5e                 unlk       a6
00c0: 4e75                 rts        
00c2: 4e560000             link.w     a6, #$0
00c6: 48e70338             movem.l    d6-d7/a2-a4, -(a7)
00ca: 2e2e000a             move.l     $a(a6), d7
00ce: 4a6e0008             tst.w      $8(a6)
00d2: 6700009c             beq.w      $170
00d6: 2047                 movea.l    d7, a0
00d8: 2050                 movea.l    (a0), a0
00da: 28680004             movea.l    $4(a0), a4
00de: beac009c             cmp.l      $9c(a4), d7
00e2: 6704                 beq.b      $e8
00e4: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
00e8: 302e0008             move.w     $8(a6), d0
00ec: 6b68                 bmi.b      $156
00ee: 04400016             subi.w     #$16, d0
00f2: 672a                 beq.b      $11e
00f4: 6a08                 bpl.b      $fe
00f6: 5440                 addq.w     #$2, d0
00f8: 670a                 beq.b      $104
00fa: 6a16                 bpl.b      $112
00fc: 6058                 bra.b      $156
00fe: 5540                 subq.w     #$2, d0
0100: 6a54                 bpl.b      $156
0102: 6036                 bra.b      $13a
0104: 206c00a0             movea.l    $a0(a4), a0
0108: 2050                 movea.l    (a0), a0
010a: 3c280018             move.w     $18(a0), d6
010e: 4446                 neg.w      d6
0110: 6048                 bra.b      $15a
0112: 206c00a0             movea.l    $a0(a4), a0
0116: 2050                 movea.l    (a0), a0
0118: 3c280018             move.w     $18(a0), d6
011c: 603c                 bra.b      $15a
011e: 206c00a0             movea.l    $a0(a4), a0
0122: 7008                 moveq      #$8, d0
0124: d090                 add.l      (a0), d0
0126: 2440                 movea.l    d0, a2
0128: 206c00a0             movea.l    $a0(a4), a0
012c: 2650                 movea.l    (a0), a3
012e: 3c2b0018             move.w     $18(a3), d6
0132: dc52                 add.w      (a2), d6
0134: 9c6a0004             sub.w      $4(a2), d6
0138: 6020                 bra.b      $15a
013a: 206c00a0             movea.l    $a0(a4), a0
013e: 7008                 moveq      #$8, d0
0140: d090                 add.l      (a0), d0
0142: 2440                 movea.l    d0, a2
0144: 206c00a0             movea.l    $a0(a4), a0
0148: 2650                 movea.l    (a0), a3
014a: 3c2a0004             move.w     $4(a2), d6
014e: 9c52                 sub.w      (a2), d6
0150: 9c6b0018             sub.w      $18(a3), d6
0154: 6004                 bra.b      $15a
0156: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
015a: 2f07                 move.l     d7, -(a7)
015c: 4267                 clr.w      -(a7)
015e: 2f07                 move.l     d7, -(a7)
0160: a960                 dc.w       $a960
0162: 301f                 move.w     (a7)+, d0
0164: d046                 add.w      d6, d0
0166: 3f00                 move.w     d0, -(a7)
0168: a963                 dc.w       $a963
016a: 2f0c                 move.l     a4, -(a7)
016c: 4eba0010             jsr        $17e(pc)
0170: 4cee1cc0ffec         movem.l    -$14(a6), d6-d7/a2-a4
0176: 4e5e                 unlk       a6
0178: 205f                 movea.l    (a7)+, a0
017a: 5c8f                 addq.l     #$6, a7
017c: 4ed0                 jmp        (a0)
017e: 4e560000             link.w     a6, #$0
0182: 48e70718             movem.l    d5-d7/a3-a4, -(a7)
0186: 266e0008             movea.l    $8(a6), a3
018a: 49eb00a0             lea.l      $a0(a3), a4
018e: 2f14                 move.l     (a4), -(a7)
0190: 4eba0048             jsr        $1da(pc)
0194: 3e00                 move.w     d0, d7
0196: 4257                 clr.w      (a7)
0198: 2f2b009c             move.l     $9c(a3), -(a7)
019c: a960                 dc.w       $a960
019e: 3c1f                 move.w     (a7)+, d6
01a0: 206b00a0             movea.l    $a0(a3), a0
01a4: 2050                 movea.l    (a0), a0
01a6: 3a280018             move.w     $18(a0), d5
01aa: 548f                 addq.l     #$2, a7
01ac: 6002                 bra.b      $1b0
01ae: 5346                 subq.w     #$1, d6
01b0: 3006                 move.w     d6, d0
01b2: 9047                 sub.w      d7, d0
01b4: 48c0                 ext.l      d0
01b6: 81c5                 divs.w     d5, d0
01b8: 4840                 swap       d0
01ba: 4a40                 tst.w      d0
01bc: 66f0                 bne.b      $1ae
01be: 2f2b009c             move.l     $9c(a3), -(a7)
01c2: 3f06                 move.w     d6, -(a7)
01c4: a963                 dc.w       $a963
01c6: 4267                 clr.w      -(a7)
01c8: 3007                 move.w     d7, d0
01ca: 9046                 sub.w      d6, d0
01cc: 3f00                 move.w     d0, -(a7)
01ce: 2f14                 move.l     (a4), -(a7)
01d0: a812                 dc.w       $a812
01d2: 4cdf18e0             movem.l    (a7)+, d5-d7/a3-a4
01d6: 4e5e                 unlk       a6
01d8: 4e75                 rts        
01da: 4e560000             link.w     a6, #$0
01de: 2f0c                 move.l     a4, -(a7)
01e0: 206e0008             movea.l    $8(a6), a0
01e4: 2850                 movea.l    (a0), a4
01e6: 302c0008             move.w     $8(a4), d0
01ea: 9054                 sub.w      (a4), d0
01ec: 285f                 movea.l    (a7)+, a4
01ee: 4e5e                 unlk       a6
01f0: 4e75                 rts        
01f2: 4e560000             link.w     a6, #$0
01f6: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
01fa: 286e0008             movea.l    $8(a6), a4
01fe: 266e000c             movea.l    $c(a6), a3
0202: 4267                 clr.w      -(a7)
0204: 2f0c                 move.l     a4, -(a7)
0206: a960                 dc.w       $a960
0208: 3e1f                 move.w     (a7)+, d7
020a: 4267                 clr.w      -(a7)
020c: 2f0c                 move.l     a4, -(a7)
020e: a962                 dc.w       $a962
0210: 3c1f                 move.w     (a7)+, d6
0212: 2f0b                 move.l     a3, -(a7)
0214: 4ebaffc4             jsr        $1da(pc)
0218: 3a00                 move.w     d0, d5
021a: 2e8b                 move.l     a3, (a7)
021c: 4eba0778             jsr        $996(pc)
0220: 2453                 movea.l    (a3), a2
0222: 382a005e             move.w     $5e(a2), d4
0226: 9840                 sub.w      d0, d4
0228: c9ea0018             muls.w     $18(a2), d4
022c: 4a45                 tst.w      d5
022e: 588f                 addq.l     #$4, a7
0230: 6c02                 bge.b      $234
0232: 7a00                 moveq      #$0, d5
0234: 4a44                 tst.w      d4
0236: 6c02                 bge.b      $23a
0238: 7800                 moveq      #$0, d4
023a: b846                 cmp.w      d6, d4
023c: 6706                 beq.b      $244
023e: 2f0c                 move.l     a4, -(a7)
0240: 3f04                 move.w     d4, -(a7)
0242: a965                 dc.w       $a965
0244: ba47                 cmp.w      d7, d5
0246: 6706                 beq.b      $24e
0248: 2f0c                 move.l     a4, -(a7)
024a: 3f05                 move.w     d5, -(a7)
024c: a963                 dc.w       $a963
024e: 4cdf1cf0             movem.l    (a7)+, d4-d7/a2-a4
0252: 4e5e                 unlk       a6
0254: 4e75                 rts        
0256: 4e560000             link.w     a6, #$0
025a: 2f0c                 move.l     a4, -(a7)
025c: 286e0008             movea.l    $8(a6), a4
0260: 49ec009c             lea.l      $9c(a4), a4
0264: 4a94                 tst.l      (a4)
0266: 6604                 bne.b      $26c
0268: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
026c: 206e0008             movea.l    $8(a6), a0
0270: 2f2800a0             move.l     $a0(a0), -(a7)
0274: 2f14                 move.l     (a4), -(a7)
0276: 4ebaff7a             jsr        $1f2(pc)
027a: 286efffc             movea.l    -$4(a6), a4
027e: 4e5e                 unlk       a6
0280: 4e75                 rts        
0282: 4e56fff4             link.w     a6, #$fff4
0286: 2f07                 move.l     d7, -(a7)
0288: 486efff8             pea.l      -$8(a6)
028c: 2f3c00400040         move.l     #$400040, -(a7)
0292: 3f2dfa5c             move.w     -$5a4(a5), -(a7)
0296: 3f2dfa5a             move.w     -$5a6(a5), -(a7)
029a: a8a7                 dc.w       $a8a7
029c: 42a7                 clr.l      -(a7)
029e: 2f2e0008             move.l     $8(a6), -(a7)
02a2: 206e000c             movea.l    $c(a6), a0
02a6: 2f28000a             move.l     $a(a0), -(a7)
02aa: 486efff8             pea.l      -$8(a6)
02ae: a92b                 dc.w       $a92b
02b0: 2e1f                 move.l     (a7)+, d7
02b2: 671e                 beq.b      $2d2
02b4: 2f2e0008             move.l     $8(a6), -(a7)
02b8: 4267                 clr.w      -(a7)
02ba: 2f07                 move.l     d7, -(a7)
02bc: a86b                 dc.w       $a86b
02be: 4267                 clr.w      -(a7)
02c0: 2f07                 move.l     d7, -(a7)
02c2: a86a                 dc.w       $a86a
02c4: 4227                 clr.b      -(a7)
02c6: a91d                 dc.w       $a91d
02c8: 2f2e0008             move.l     $8(a6), -(a7)
02cc: 4eba0068             jsr        $336(pc)
02d0: 588f                 addq.l     #$4, a7
02d2: 2e1f                 move.l     (a7)+, d7
02d4: 4e5e                 unlk       a6
02d6: 4e75                 rts        
02d8: 4e560000             link.w     a6, #$0
02dc: 2f0c                 move.l     a4, -(a7)
02de: 286e0008             movea.l    $8(a6), a4
02e2: 2f0c                 move.l     a4, -(a7)
02e4: a873                 dc.w       $a873
02e6: 486c0010             pea.l      $10(a4)
02ea: a8a3                 dc.w       $a8a3
02ec: 2f0c                 move.l     a4, -(a7)
02ee: 3f2e000c             move.w     $c(a6), -(a7)
02f2: 1f3c0001             move.b     #$1, -(a7)
02f6: a83a                 dc.w       $a83a
02f8: 2f0c                 move.l     a4, -(a7)
02fa: 4eba003a             jsr        $336(pc)
02fe: 286efffc             movea.l    -$4(a6), a4
0302: 4e5e                 unlk       a6
0304: 4e75                 rts        
0306: 4e560000             link.w     a6, #$0
030a: 0c6e0081000c         cmpi.w     #$81, $c(a6)
0310: 6604                 bne.b      $316
0312: 7000                 moveq      #$0, d0
0314: 6006                 bra.b      $31c
0316: 41ed074a             lea.l      $74a(a5), a0
031a: 2008                 move.l     a0, d0
031c: 4e5e                 unlk       a6
031e: 4e75                 rts        
0320: 4e560000             link.w     a6, #$0
0324: 206e0008             movea.l    $8(a6), a0
0328: 2050                 movea.l    (a0), a0
032a: 2f280004             move.l     $4(a0), -(a7)
032e: 4ebafe4e             jsr        $17e(pc)
0332: 4e5e                 unlk       a6
0334: 4e75                 rts        
0336: 4e56ffe6             link.w     a6, #$ffe6
033a: 2f0c                 move.l     a4, -(a7)
033c: 286e0008             movea.l    $8(a6), a4
0340: 2f0c                 move.l     a4, -(a7)
0342: a873                 dc.w       $a873
0344: 2d6c0010ffe8         move.l     $10(a4), -$18(a6)
034a: 2d6c0014ffec         move.l     $14(a4), -$14(a6)
0350: 486effe8             pea.l      -$18(a6)
0354: a8a3                 dc.w       $a8a3
0356: 486effe8             pea.l      -$18(a6)
035a: a928                 dc.w       $a928
035c: 486efff0             pea.l      -$10(a6)
0360: 2f3c00040000         move.l     #$40000, -(a7)
0366: 70f1                 moveq      #$f1, d0
0368: d06effee             add.w      -$12(a6), d0
036c: 3f00                 move.w     d0, -(a7)
036e: 3f2effec             move.w     -$14(a6), -(a7)
0372: a8a7                 dc.w       $a8a7
0374: 2d6efff0fff8         move.l     -$10(a6), -$8(a6)
037a: 2d6efff4fffc         move.l     -$c(a6), -$4(a6)
0380: 3d7c0004fffa         move.w     #$4, -$6(a6)
0386: 486efff8             pea.l      -$8(a6)
038a: 4267                 clr.w      -(a7)
038c: 206c00a0             movea.l    $a0(a4), a0
0390: 2050                 movea.l    (a0), a0
0392: 226c00a0             movea.l    $a0(a4), a1
0396: 2251                 movea.l    (a1), a1
0398: 3011                 move.w     (a1), d0
039a: 90680008             sub.w      $8(a0), d0
039e: 3f00                 move.w     d0, -(a7)
03a0: a8a8                 dc.w       $a8a8
03a2: 206c00a0             movea.l    $a0(a4), a0
03a6: 2050                 movea.l    (a0), a0
03a8: 302efff4             move.w     -$c(a6), d0
03ac: 906efff0             sub.w      -$10(a6), d0
03b0: 48c0                 ext.l      d0
03b2: 81e80018             divs.w     $18(a0), d0
03b6: 4840                 swap       d0
03b8: 916efff4             sub.w      d0, -$c(a6)
03bc: 206c00a0             movea.l    $a0(a4), a0
03c0: 2050                 movea.l    (a0), a0
03c2: 216efff00008         move.l     -$10(a6), $8(a0)
03c8: 216efff4000c         move.l     -$c(a6), $c(a0)
03ce: 206c00a0             movea.l    $a0(a4), a0
03d2: 2050                 movea.l    (a0), a0
03d4: 20aefff8             move.l     -$8(a6), (a0)
03d8: 216efffc0004         move.l     -$4(a6), $4(a0)
03de: 2f2c00a0             move.l     $a0(a4), -(a7)
03e2: a9d0                 dc.w       $a9d0
03e4: 4aac009c             tst.l      $9c(a4)
03e8: 6706                 beq.b      $3f0
03ea: 2f2c009c             move.l     $9c(a4), -(a7)
03ee: a955                 dc.w       $a955
03f0: 3d7cffffffe8         move.w     #$ffff, -$18(a6)
03f6: 526effee             addq.w     #$1, -$12(a6)
03fa: 70f0                 moveq      #$f0, d0
03fc: d06effee             add.w      -$12(a6), d0
0400: 3d40ffea             move.w     d0, -$16(a6)
0404: 046e000effec         subi.w     #$e, -$14(a6)
040a: 42a7                 clr.l      -(a7)
040c: 2f0c                 move.l     a4, -(a7)
040e: 486effe8             pea.l      -$18(a6)
0412: 2f2df248             move.l     -$db8(a5), -(a7)
0416: 48780100             pea.l      $100.w
041a: 42a7                 clr.l      -(a7)
041c: 3f3c0010             move.w     #$10, -(a7)
0420: 486df33c             pea.l      -$cc4(a5)
0424: a954                 dc.w       $a954
0426: 295f009c             move.l     (a7)+, $9c(a4)
042a: 2f0c                 move.l     a4, -(a7)
042c: 4ebafe28             jsr        $256(pc)
0430: 286effe2             movea.l    -$1e(a6), a4
0434: 4e5e                 unlk       a6
0436: 4e75                 rts        
0438: 4e56fff4             link.w     a6, #$fff4
043c: 2f0c                 move.l     a4, -(a7)
043e: 286e0008             movea.l    $8(a6), a4
0442: 49ec00a0             lea.l      $a0(a4), a4
0446: 2054                 movea.l    (a4), a0
0448: 2050                 movea.l    (a0), a0
044a: 2d680008fff8         move.l     $8(a0), -$8(a6)
0450: 2d68000cfffc         move.l     $c(a0), -$4(a6)
0456: 2f2e0008             move.l     $8(a6), -(a7)
045a: a873                 dc.w       $a873
045c: 2f2e0008             move.l     $8(a6), -(a7)
0460: 4ead061a             jsr        $61a(a5) ; CODE9+0bfe
0464: 486efff8             pea.l      -$8(a6)
0468: a8a3                 dc.w       $a8a3
046a: 486efff8             pea.l      -$8(a6)
046e: 2f14                 move.l     (a4), -(a7)
0470: a9d3                 dc.w       $a9d3
0472: 286efff0             movea.l    -$10(a6), a4
0476: 4e5e                 unlk       a6
0478: 4e75                 rts        
047a: 4e56fffc             link.w     a6, #$fffc
047e: 2f2e0008             move.l     $8(a6), -(a7)
0482: 4ead061a             jsr        $61a(a5) ; CODE9+0bfe
0486: 206e0008             movea.l    $8(a6), a0
048a: 2ea800a0             move.l     $a0(a0), (a7)
048e: a9d8                 dc.w       $a9d8
0490: 206e0008             movea.l    $8(a6), a0
0494: 2f28009c             move.l     $9c(a0), -(a7)
0498: 4267                 clr.w      -(a7)
049a: a95d                 dc.w       $a95d
049c: 4e5e                 unlk       a6
049e: 4e75                 rts        
04a0: 4e56fffc             link.w     a6, #$fffc
04a4: 2f2e0008             move.l     $8(a6), -(a7)
04a8: 4ead061a             jsr        $61a(a5) ; CODE9+0bfe
04ac: 206e0008             movea.l    $8(a6), a0
04b0: 2ea800a0             move.l     $a0(a0), (a7)
04b4: a9d9                 dc.w       $a9d9
04b6: 206e0008             movea.l    $8(a6), a0
04ba: 2f28009c             move.l     $9c(a0), -(a7)
04be: 3f3c00ff             move.w     #$ff, -(a7)
04c2: a95d                 dc.w       $a95d
04c4: 4e5e                 unlk       a6
04c6: 4e75                 rts        
04c8: 4e560000             link.w     a6, #$0
04cc: 48e70118             movem.l    d7/a3-a4, -(a7)
04d0: 266e0008             movea.l    $8(a6), a3
04d4: 206e000c             movea.l    $c(a6), a0
04d8: 3e280004             move.w     $4(a0), d7
04dc: 0247ff00             andi.w     #$ff00, d7
04e0: 0c470001             cmpi.w     #$1, d7
04e4: 6612                 bne.b      $4f8
04e6: 2f2b009c             move.l     $9c(a3), -(a7)
04ea: 4267                 clr.w      -(a7)
04ec: a963                 dc.w       $a963
04ee: 2f0b                 move.l     a3, -(a7)
04f0: 4ebafc8c             jsr        $17e(pc)
04f4: 588f                 addq.l     #$4, a7
04f6: 606c                 bra.b      $564
04f8: 0c470004             cmpi.w     #$4, d7
04fc: 6618                 bne.b      $516
04fe: 49eb009c             lea.l      $9c(a3), a4
0502: 2f14                 move.l     (a4), -(a7)
0504: 4267                 clr.w      -(a7)
0506: 2f14                 move.l     (a4), -(a7)
0508: a962                 dc.w       $a962
050a: a963                 dc.w       $a963
050c: 2f0b                 move.l     a3, -(a7)
050e: 4ebafc6e             jsr        $17e(pc)
0512: 588f                 addq.l     #$4, a7
0514: 604e                 bra.b      $564
0516: 0c47000b             cmpi.w     #$b, d7
051a: 660e                 bne.b      $52a
051c: 2f2b009c             move.l     $9c(a3), -(a7)
0520: 3f3c0016             move.w     #$16, -(a7)
0524: 4ebafb9c             jsr        $c2(pc)
0528: 603a                 bra.b      $564
052a: 0c47000c             cmpi.w     #$c, d7
052e: 660e                 bne.b      $53e
0530: 2f2b009c             move.l     $9c(a3), -(a7)
0534: 3f3c0017             move.w     #$17, -(a7)
0538: 4ebafb88             jsr        $c2(pc)
053c: 6026                 bra.b      $564
053e: 3f2b00a6             move.w     $a6(a3), -(a7)
0542: 2f2e000c             move.l     $c(a6), -(a7)
0546: 2f2b00a0             move.l     $a0(a3), -(a7)
054a: 4ead05fa             jsr        $5fa(a5) ; CODE9+046c
054e: 4a40                 tst.w      d0
0550: 4fef000a             lea.l      $a(a7), a7
0554: 670e                 beq.b      $564
0556: 377c000100a4         move.w     #$1, $a4(a3)
055c: 2f0b                 move.l     a3, -(a7)
055e: 4ebafcf6             jsr        $256(pc)
0562: 588f                 addq.l     #$4, a7
0564: 4cdf1880             movem.l    (a7)+, d7/a3-a4
0568: 4e5e                 unlk       a6
056a: 4e75                 rts        
056c: 4e56fffc             link.w     a6, #$fffc
0570: 2f0c                 move.l     a4, -(a7)
0572: 286e0008             movea.l    $8(a6), a4
0576: 206e000c             movea.l    $c(a6), a0
057a: 2d68000afffc         move.l     $a(a0), -$4(a6)
0580: 2f0c                 move.l     a4, -(a7)
0582: a873                 dc.w       $a873
0584: 486efffc             pea.l      -$4(a6)
0588: a871                 dc.w       $a871
058a: 4227                 clr.b      -(a7)
058c: 2f2efffc             move.l     -$4(a6), -(a7)
0590: 206c00a0             movea.l    $a0(a4), a0
0594: 2050                 movea.l    (a0), a0
0596: 48680008             pea.l      $8(a0)
059a: a8ad                 dc.w       $a8ad
059c: 4a1f                 tst.b      (a7)+
059e: 672a                 beq.b      $5ca
05a0: 486df278             pea.l      -$d88(a5)
05a4: a851                 dc.w       $a851
05a6: 2f2efffc             move.l     -$4(a6), -(a7)
05aa: 206e000c             movea.l    $c(a6), a0
05ae: 08280001000e         btst.b     #$1, $e(a0)
05b4: 6704                 beq.b      $5ba
05b6: 7001                 moveq      #$1, d0
05b8: 6002                 bra.b      $5bc
05ba: 7000                 moveq      #$0, d0
05bc: 1f00                 move.b     d0, -(a7)
05be: 2f2c00a0             move.l     $a0(a4), -(a7)
05c2: a9d4                 dc.w       $a9d4
05c4: 2f0c                 move.l     a4, -(a7)
05c6: 4ebafc8e             jsr        $256(pc)
05ca: 286efff8             movea.l    -$8(a6), a4
05ce: 4e5e                 unlk       a6
05d0: 4e75                 rts        
05d2: 4e56fffc             link.w     a6, #$fffc
05d6: 48e70018             movem.l    a3-a4, -(a7)
05da: 266e0008             movea.l    $8(a6), a3
05de: 99cc                 suba.l     a4, a4
05e0: 2f0b                 move.l     a3, -(a7)
05e2: a873                 dc.w       $a873
05e4: 206e000c             movea.l    $c(a6), a0
05e8: 2d68000afffc         move.l     $a(a0), -$4(a6)
05ee: 486efffc             pea.l      -$4(a6)
05f2: a871                 dc.w       $a871
05f4: 4227                 clr.b      -(a7)
05f6: 2f2efffc             move.l     -$4(a6), -(a7)
05fa: 2f2b0018             move.l     $18(a3), -(a7)
05fe: a8e8                 dc.w       $a8e8
0600: 4a1f                 tst.b      (a7)+
0602: 6620                 bne.b      $624
0604: 4a6b00a6             tst.w      $a6(a3)
0608: 661a                 bne.b      $624
060a: 4227                 clr.b      -(a7)
060c: 2f2efffc             move.l     -$4(a6), -(a7)
0610: 206b00a0             movea.l    $a0(a3), a0
0614: 2050                 movea.l    (a0), a0
0616: 48680008             pea.l      $8(a0)
061a: a8ad                 dc.w       $a8ad
061c: 4a1f                 tst.b      (a7)+
061e: 6704                 beq.b      $624
0620: 49edf278             lea.l      -$d88(a5), a4
0624: 4a6b00a6             tst.w      $a6(a3)
0628: 670e                 beq.b      $638
062a: 206b00a0             movea.l    $a0(a3), a0
062e: 2050                 movea.l    (a0), a0
0630: 0c68ffff0038         cmpi.w     #$ffff, $38(a0)
0636: 6606                 bne.b      $63e
0638: 2f2b00a0             move.l     $a0(a3), -(a7)
063c: a9da                 dc.w       $a9da
063e: 200c                 move.l     a4, d0
0640: 4cdf1800             movem.l    (a7)+, a3-a4
0644: 4e5e                 unlk       a6
0646: 4e75                 rts        
0648: 4e560000             link.w     a6, #$0
064c: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
0650: 286e0008             movea.l    $8(a6), a4
0654: 49ec009c             lea.l      $9c(a4), a4
0658: 4267                 clr.w      -(a7)
065a: 2f14                 move.l     (a4), -(a7)
065c: a960                 dc.w       $a960
065e: 3e1f                 move.w     (a7)+, d7
0660: 4267                 clr.w      -(a7)
0662: 2f14                 move.l     (a4), -(a7)
0664: a962                 dc.w       $a962
0666: 3c1f                 move.w     (a7)+, d6
0668: 206e0008             movea.l    $8(a6), a0
066c: 246800a0             movea.l    $a0(a0), a2
0670: 2f0a                 move.l     a2, -(a7)
0672: 4ebafb66             jsr        $1da(pc)
0676: 3a00                 move.w     d0, d5
0678: 2e8a                 move.l     a2, (a7)
067a: 4eba031a             jsr        $996(pc)
067e: 2652                 movea.l    (a2), a3
0680: 382b005e             move.w     $5e(a3), d4
0684: 9840                 sub.w      d0, d4
0686: c9eb0018             muls.w     $18(a3), d4
068a: 4a45                 tst.w      d5
068c: 588f                 addq.l     #$4, a7
068e: 6c02                 bge.b      $692
0690: 7a00                 moveq      #$0, d5
0692: 4a44                 tst.w      d4
0694: 6c02                 bge.b      $698
0696: 7800                 moveq      #$0, d4
0698: b846                 cmp.w      d6, d4
069a: 6706                 beq.b      $6a2
069c: 2f14                 move.l     (a4), -(a7)
069e: 3f04                 move.w     d4, -(a7)
06a0: a965                 dc.w       $a965
06a2: ba47                 cmp.w      d7, d5
06a4: 6706                 beq.b      $6ac
06a6: 2f14                 move.l     (a4), -(a7)
06a8: 3f05                 move.w     d5, -(a7)
06aa: a963                 dc.w       $a963
06ac: 4cdf1cf0             movem.l    (a7)+, d4-d7/a2-a4
06b0: 4e5e                 unlk       a6
06b2: 4e75                 rts        
06b4: 4e56fffc             link.w     a6, #$fffc
06b8: 2f0c                 move.l     a4, -(a7)
06ba: 286e0008             movea.l    $8(a6), a4
06be: 49ec00a0             lea.l      $a0(a4), a4
06c2: 2f14                 move.l     (a4), -(a7)
06c4: a9d6                 dc.w       $a9d6
06c6: 2f14                 move.l     (a4), -(a7)
06c8: a9d0                 dc.w       $a9d0
06ca: 2f2e0008             move.l     $8(a6), -(a7)
06ce: 4ebaff78             jsr        $648(pc)
06d2: 206e0008             movea.l    $8(a6), a0
06d6: 317c000100a4         move.w     #$1, $a4(a0)
06dc: 3b7c0001f276         move.w     #$1, -$d8a(a5)
06e2: 286efff8             movea.l    -$8(a6), a4
06e6: 4e5e                 unlk       a6
06e8: 4e75                 rts        
06ea: 4e560000             link.w     a6, #$0
06ee: 206e0008             movea.l    $8(a6), a0
06f2: 2f2800a0             move.l     $a0(a0), -(a7)
06f6: a9d5                 dc.w       $a9d5
06f8: 3b7c0001f276         move.w     #$1, -$d8a(a5)
06fe: 4e5e                 unlk       a6
0700: 4e75                 rts        
0702: 4e56fffc             link.w     a6, #$fffc
0706: 2f0c                 move.l     a4, -(a7)
0708: 286e0008             movea.l    $8(a6), a4
070c: 49ec00a0             lea.l      $a0(a4), a4
0710: 2f14                 move.l     (a4), -(a7)
0712: a9db                 dc.w       $a9db
0714: 2f14                 move.l     (a4), -(a7)
0716: a9d0                 dc.w       $a9d0
0718: 2f2e0008             move.l     $8(a6), -(a7)
071c: 4ebaff2a             jsr        $648(pc)
0720: 206e0008             movea.l    $8(a6), a0
0724: 317c000100a4         move.w     #$1, $a4(a0)
072a: 286efff8             movea.l    -$8(a6), a4
072e: 4e5e                 unlk       a6
0730: 4e75                 rts        
0732: 4e560000             link.w     a6, #$0
0736: 48e70038             movem.l    a2-a4, -(a7)
073a: 266e0008             movea.l    $8(a6), a3
073e: 49eb00a0             lea.l      $a0(a3), a4
0742: 2054                 movea.l    (a4), a0
0744: 2450                 movea.l    (a0), a2
0746: 302a0020             move.w     $20(a2), d0
074a: b06a0022             cmp.w      $22(a2), d0
074e: 6716                 beq.b      $766
0750: 2f14                 move.l     (a4), -(a7)
0752: a9d7                 dc.w       $a9d7
0754: 2f14                 move.l     (a4), -(a7)
0756: a9d0                 dc.w       $a9d0
0758: 2f0b                 move.l     a3, -(a7)
075a: 4ebafeec             jsr        $648(pc)
075e: 377c000100a4         move.w     #$1, $a4(a3)
0764: 588f                 addq.l     #$4, a7
0766: 4cdf1c00             movem.l    (a7)+, a2-a4
076a: 4e5e                 unlk       a6
076c: 4e75                 rts        
076e: 4e560000             link.w     a6, #$0
0772: 206e0008             movea.l    $8(a6), a0
0776: 2f2800a0             move.l     $a0(a0), -(a7)
077a: 4eba028e             jsr        $a0a(pc)
077e: 4e5e                 unlk       a6
0780: 4e75                 rts        
0782: 4e560000             link.w     a6, #$0
0786: 206e0008             movea.l    $8(a6), a0
078a: 302800a6             move.w     $a6(a0), d0
078e: 4e5e                 unlk       a6
0790: 4e75                 rts        
0792: 4e560000             link.w     a6, #$0
0796: 2f0c                 move.l     a4, -(a7)
0798: 206e0008             movea.l    $8(a6), a0
079c: 286800a0             movea.l    $a0(a0), a4
07a0: 2254                 movea.l    (a4), a1
07a2: 30290020             move.w     $20(a1), d0
07a6: b0690022             cmp.w      $22(a1), d0
07aa: 6724                 beq.b      $7d0
07ac: 2f2e0008             move.l     $8(a6), -(a7)
07b0: 4ebaffd0             jsr        $782(pc)
07b4: 4a40                 tst.w      d0
07b6: 588f                 addq.l     #$4, a7
07b8: 6616                 bne.b      $7d0
07ba: 2f2e000c             move.l     $c(a6), -(a7)
07be: 4267                 clr.w      -(a7)
07c0: 2f2e0010             move.l     $10(a6), -(a7)
07c4: a86b                 dc.w       $a86b
07c6: 2f2df354             move.l     -$cac(a5), -(a7)
07ca: a947                 dc.w       $a947
07cc: 7001                 moveq      #$1, d0
07ce: 6014                 bra.b      $7e4
07d0: 2f2e000c             move.l     $c(a6), -(a7)
07d4: 4267                 clr.w      -(a7)
07d6: 2f2e0010             move.l     $10(a6), -(a7)
07da: a86b                 dc.w       $a86b
07dc: 2f2df250             move.l     -$db0(a5), -(a7)
07e0: a947                 dc.w       $a947
07e2: 7000                 moveq      #$0, d0
07e4: 285f                 movea.l    (a7)+, a4
07e6: 4e5e                 unlk       a6
07e8: 4e75                 rts        
07ea: 4e560000             link.w     a6, #$0
07ee: 2f0c                 move.l     a4, -(a7)
07f0: 206e0008             movea.l    $8(a6), a0
07f4: 286800a0             movea.l    $a0(a0), a4
07f8: 2254                 movea.l    (a4), a1
07fa: 30290020             move.w     $20(a1), d0
07fe: b0690022             cmp.w      $22(a1), d0
0802: 6724                 beq.b      $828
0804: 2f2e0008             move.l     $8(a6), -(a7)
0808: 4ebaff78             jsr        $782(pc)
080c: 4a40                 tst.w      d0
080e: 588f                 addq.l     #$4, a7
0810: 6616                 bne.b      $828
0812: 2f2e000c             move.l     $c(a6), -(a7)
0816: 4267                 clr.w      -(a7)
0818: 2f2e0010             move.l     $10(a6), -(a7)
081c: a86b                 dc.w       $a86b
081e: 2f2df358             move.l     -$ca8(a5), -(a7)
0822: a947                 dc.w       $a947
0824: 7001                 moveq      #$1, d0
0826: 6014                 bra.b      $83c
0828: 2f2e000c             move.l     $c(a6), -(a7)
082c: 4267                 clr.w      -(a7)
082e: 2f2e0010             move.l     $10(a6), -(a7)
0832: a86b                 dc.w       $a86b
0834: 2f2df254             move.l     -$dac(a5), -(a7)
0838: a947                 dc.w       $a947
083a: 7000                 moveq      #$0, d0
083c: 285f                 movea.l    (a7)+, a4
083e: 4e5e                 unlk       a6
0840: 4e75                 rts        
0842: 4e560000             link.w     a6, #$0
0846: 48e70018             movem.l    a3-a4, -(a7)
084a: 206e0008             movea.l    $8(a6), a0
084e: 286800a0             movea.l    $a0(a0), a4
0852: 2654                 movea.l    (a4), a3
0854: 302b0020             move.w     $20(a3), d0
0858: b06b0022             cmp.w      $22(a3), d0
085c: 6716                 beq.b      $874
085e: 2f2e000c             move.l     $c(a6), -(a7)
0862: 4267                 clr.w      -(a7)
0864: 2f2e0010             move.l     $10(a6), -(a7)
0868: a86b                 dc.w       $a86b
086a: 2f2df35c             move.l     -$ca4(a5), -(a7)
086e: a947                 dc.w       $a947
0870: 7001                 moveq      #$1, d0
0872: 6014                 bra.b      $888
0874: 2f2e000c             move.l     $c(a6), -(a7)
0878: 4267                 clr.w      -(a7)
087a: 2f2e0010             move.l     $10(a6), -(a7)
087e: a86b                 dc.w       $a86b
0880: 2f2df258             move.l     -$da8(a5), -(a7)
0884: a947                 dc.w       $a947
0886: 7000                 moveq      #$0, d0
0888: 4cdf1800             movem.l    (a7)+, a3-a4
088c: 4e5e                 unlk       a6
088e: 4e75                 rts        
0890: 4e560000             link.w     a6, #$0
0894: 4a780ab0             tst.w      $ab0.w
0898: 6724                 beq.b      $8be
089a: 2f2e0008             move.l     $8(a6), -(a7)
089e: 4ebafee2             jsr        $782(pc)
08a2: 4a40                 tst.w      d0
08a4: 588f                 addq.l     #$4, a7
08a6: 6616                 bne.b      $8be
08a8: 2f2e000c             move.l     $c(a6), -(a7)
08ac: 4267                 clr.w      -(a7)
08ae: 2f2e0010             move.l     $10(a6), -(a7)
08b2: a86b                 dc.w       $a86b
08b4: 2f2df360             move.l     -$ca0(a5), -(a7)
08b8: a947                 dc.w       $a947
08ba: 7001                 moveq      #$1, d0
08bc: 6014                 bra.b      $8d2
08be: 2f2e000c             move.l     $c(a6), -(a7)
08c2: 4267                 clr.w      -(a7)
08c4: 2f2e0010             move.l     $10(a6), -(a7)
08c8: a86b                 dc.w       $a86b
08ca: 2f2df25c             move.l     -$da4(a5), -(a7)
08ce: a947                 dc.w       $a947
08d0: 7000                 moveq      #$0, d0
08d2: 4e5e                 unlk       a6
08d4: 4e75                 rts        
08d6: 4e56fff4             link.w     a6, #$fff4
08da: 2f0b                 move.l     a3, -(a7)
08dc: 4aae0008             tst.l      $8(a6)
08e0: 660c                 bne.b      $8ee
08e2: 203c000000a8         move.l     #$a8, d0
08e8: a11e                 dc.w       $a11e
08ea: 2d480008             move.l     a0, $8(a6)
08ee: 42a7                 clr.l      -(a7)
08f0: 2f2e0008             move.l     $8(a6), -(a7)
08f4: 2f2e000c             move.l     $c(a6), -(a7)
08f8: 2f2e0010             move.l     $10(a6), -(a7)
08fc: 2f3c00080000         move.l     #$80000, -(a7)
0902: 4878ffff             pea.l      $ffff.w
0906: 1f3c0001             move.b     #$1, -(a7)
090a: 486df3ac             pea.l      -$c54(a5)
090e: a913                 dc.w       $a913
0910: 265f                 movea.l    (a7)+, a3
0912: 42ab009c             clr.l      $9c(a3)
0916: 426b00a4             clr.w      $a4(a3)
091a: 3f2e0018             move.w     $18(a6), -(a7)
091e: 3f2e0016             move.w     $16(a6), -(a7)
0922: 3f2e0014             move.w     $14(a6), -(a7)
0926: 2f2e000c             move.l     $c(a6), -(a7)
092a: 2f0b                 move.l     a3, -(a7)
092c: 4eba000c             jsr        $93a(pc)
0930: 200b                 move.l     a3, d0
0932: 266efff0             movea.l    -$10(a6), a3
0936: 4e5e                 unlk       a6
0938: 4e75                 rts        
093a: 4e560000             link.w     a6, #$0
093e: 2f0c                 move.l     a4, -(a7)
0940: 286e0008             movea.l    $8(a6), a4
0944: 200c                 move.l     a4, d0
0946: 6604                 bne.b      $94c
0948: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
094c: 2f0c                 move.l     a4, -(a7)
094e: a873                 dc.w       $a873
0950: 3f2e0012             move.w     $12(a6), -(a7)
0954: a887                 dc.w       $a887
0956: 3f2e0014             move.w     $14(a6), -(a7)
095a: a88a                 dc.w       $a88a
095c: 396e001000a6         move.w     $10(a6), $a6(a4)
0962: 42a7                 clr.l      -(a7)
0964: 2f2e000c             move.l     $c(a6), -(a7)
0968: 2f2e000c             move.l     $c(a6), -(a7)
096c: a9d2                 dc.w       $a9d2
096e: 295f00a0             move.l     (a7)+, $a0(a4)
0972: 486d0602             pea.l      $602(a5)
0976: 2f2c00a0             move.l     $a0(a4), -(a7)
097a: 4ead0bda             jsr        $bda(a5) ; CODE34+054a
097e: 1f3c0001             move.b     #$1, -(a7)
0982: 2f2c00a0             move.l     $a0(a4), -(a7)
0986: a813                 dc.w       $a813
0988: 2f0c                 move.l     a4, -(a7)
098a: 4ebaf9aa             jsr        $336(pc)
098e: 286efffc             movea.l    -$4(a6), a4
0992: 4e5e                 unlk       a6
0994: 4e75                 rts        
0996: 4e56fff8             link.w     a6, #$fff8
099a: 206e0008             movea.l    $8(a6), a0
099e: 2050                 movea.l    (a0), a0
09a0: 2d680008fff8         move.l     $8(a0), -$8(a6)
09a6: 2d68000cfffc         move.l     $c(a0), -$4(a6)
09ac: 206e0008             movea.l    $8(a6), a0
09b0: 2050                 movea.l    (a0), a0
09b2: 302efffc             move.w     -$4(a6), d0
09b6: 906efff8             sub.w      -$8(a6), d0
09ba: 48c0                 ext.l      d0
09bc: 81e80018             divs.w     $18(a0), d0
09c0: 4e5e                 unlk       a6
09c2: 4e75                 rts        
09c4: 4e560000             link.w     a6, #$0
09c8: 48e70018             movem.l    a3-a4, -(a7)
09cc: 266e0008             movea.l    $8(a6), a3
09d0: 49eb00a0             lea.l      $a0(a3), a4
09d4: 4a94                 tst.l      (a4)
09d6: 6604                 bne.b      $9dc
09d8: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
09dc: 2f2e000c             move.l     $c(a6), -(a7)
09e0: 2f2e000c             move.l     $c(a6), -(a7)
09e4: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
09e8: 2e80                 move.l     d0, (a7)
09ea: 2f14                 move.l     (a4), -(a7)
09ec: a9de                 dc.w       $a9de
09ee: 2f0b                 move.l     a3, -(a7)
09f0: 4ebaf864             jsr        $256(pc)
09f4: 2e8b                 move.l     a3, (a7)
09f6: 4ebaf786             jsr        $17e(pc)
09fa: 377c000100a4         move.w     #$1, $a4(a3)
0a00: 4cee1800fff8         movem.l    -$8(a6), a3-a4
0a06: 4e5e                 unlk       a6
0a08: 4e75                 rts        
0a0a: 4e560000             link.w     a6, #$0
0a0e: 42a7                 clr.l      -(a7)
0a10: 2f3c0000ffff         move.l     #$ffff, -(a7)
0a16: 2f2e0008             move.l     $8(a6), -(a7)
0a1a: a9d1                 dc.w       $a9d1
0a1c: 4e5e                 unlk       a6
0a1e: 4e75                 rts        
0a20: 4e560000             link.w     a6, #$0
0a24: 2f0c                 move.l     a4, -(a7)
0a26: 286e0008             movea.l    $8(a6), a4
0a2a: 49ec00a0             lea.l      $a0(a4), a4
0a2e: 2f14                 move.l     (a4), -(a7)
0a30: 4ebaffd8             jsr        $a0a(pc)
0a34: 2e94                 move.l     (a4), (a7)
0a36: a9d7                 dc.w       $a9d7
0a38: 285f                 movea.l    (a7)+, a4
0a3a: 4e5e                 unlk       a6
0a3c: 4e75                 rts        
