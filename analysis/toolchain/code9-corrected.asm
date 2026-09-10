0004: 4e560000             link.w     a6, #$0
0008: 4267                 clr.w      -(a7)
000a: 3f2e0008             move.w     $8(a6), -(a7)
000e: 486e000a             pea.l      $a(a6)
0012: 2f2e000e             move.l     $e(a6), -(a7)
0016: 4ead0b32             jsr        $b32(a5) ; CODE34+0230
001a: 4e5e                 unlk       a6
001c: 4e75                 rts        
001e: 4e56fffc             link.w     a6, #$fffc
0022: 43eefffc             lea.l      -$4(a6), a1
0026: 206e0008             movea.l    $8(a6), a0
002a: a03b                 dc.w       $a03b
002c: 2280                 move.l     d0, (a1)
002e: 4e5e                 unlk       a6
0030: 4e75                 rts        
0032: 3f3c0140             move.w     #$140, -(a7)
0036: 4ead01e2             jsr        $1e2(a5) ; CODE11+0ad6
003a: 548f                 addq.l     #$2, a7
003c: 4e75                 rts        
003e: 4e560000             link.w     a6, #$0
0042: 206e0008             movea.l    $8(a6), a0
0046: 20ada38a             move.l     -$5c76(a5), (a0)
004a: 2b6e000ca38a         move.l     $c(a6), -$5c76(a5)
0050: 4e5e                 unlk       a6
0052: 4e75                 rts        
0054: 4e560000             link.w     a6, #$0
0058: 2b6e0008a38a         move.l     $8(a6), -$5c76(a5)
005e: 4e5e                 unlk       a6
0060: 4e75                 rts        
0062: 486df2bc             pea.l      -$d44(a5)
0066: a851                 dc.w       $a851
0068: 4e75                 rts        
006a: a850                 dc.w       $a850
006c: 4e75                 rts        
006e: 4267                 clr.w      -(a7)
0070: a861                 dc.w       $a861
0072: 301f                 move.w     (a7)+, d0
0074: 4e75                 rts        
0076: 4e560000             link.w     a6, #$0
007a: 206e0008             movea.l    $8(a6), a0
007e: 20b8016a             move.l     $16a.w, (a0)
0082: 4e5e                 unlk       a6
0084: 4e75                 rts        
0086: 4e560000             link.w     a6, #$0
008a: 4878003c             pea.l      $3c.w
008e: 2038016a             move.l     $16a.w, d0
0092: 90ae0008             sub.l      $8(a6), d0
0096: 2040                 movea.l    d0, a0
0098: 4868001e             pea.l      $1e(a0)
009c: 4ead005a             jsr        $5a(a5) ; CODE1+0166
00a0: 4e5e                 unlk       a6
00a2: 4e75                 rts        
00a4: 4e560000             link.w     a6, #$0
00a8: 202e0008             move.l     $8(a6), d0
00ac: a11e                 dc.w       $a11e
00ae: 2008                 move.l     a0, d0
00b0: 4e5e                 unlk       a6
00b2: 4e75                 rts        
00b4: 4e560000             link.w     a6, #$0
00b8: 206e0008             movea.l    $8(a6), a0
00bc: a01f                 dc.w       $a01f
00be: 4e5e                 unlk       a6
00c0: 4e75                 rts        
00c2: 4e560000             link.w     a6, #$0
00c6: 202e0010             move.l     $10(a6), d0
00ca: 226e000c             movea.l    $c(a6), a1
00ce: 206e0008             movea.l    $8(a6), a0
00d2: a02e                 dc.w       $a02e
00d4: 4e5e                 unlk       a6
00d6: 4e75                 rts        
00d8: 4e560000             link.w     a6, #$0
00dc: 2f2e000c             move.l     $c(a6), -(a7)
00e0: 4267                 clr.w      -(a7)
00e2: 2f2e0008             move.l     $8(a6), -(a7)
00e6: 4ead0d3a             jsr        $d3a(a5) ; CODE47+025c
00ea: 4e5e                 unlk       a6
00ec: 4e75                 rts        
00ee: 4eba0152             jsr        $242(pc)
00f2: 4eba014e             jsr        $242(pc)
00f6: 4e75                 rts        
00f8: 4e56fffc             link.w     a6, #$fffc
00fc: 42a7                 clr.l      -(a7)
00fe: 2f2e000c             move.l     $c(a6), -(a7)
0102: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
0106: 2f2e000c             move.l     $c(a6), -(a7)
010a: 4eba0122             jsr        $22e(pc)
010e: 2e80                 move.l     d0, (a7)
0110: 2f2e0008             move.l     $8(a6), -(a7)
0114: 4ead07e2             jsr        $7e2(a5) ; CODE23+0128
0118: 206e000c             movea.l    $c(a6), a0
011c: a02a                 dc.w       $a02a
011e: 4e5e                 unlk       a6
0120: 4e75                 rts        
0122: 4e560000             link.w     a6, #$0
0126: 3f2e000c             move.w     $c(a6), -(a7)
012a: 2f2e0008             move.l     $8(a6), -(a7)
012e: 4eba0c34             jsr        $d64(pc)
0132: 2e80                 move.l     d0, (a7)
0134: 4eba00dc             jsr        $212(pc)
0138: 4e5e                 unlk       a6
013a: 4e75                 rts        
013c: 4e560000             link.w     a6, #$0
0140: 3f2e000c             move.w     $c(a6), -(a7)
0144: 2f2e0008             move.l     $8(a6), -(a7)
0148: 4eba0c1a             jsr        $d64(pc)
014c: 2e80                 move.l     d0, (a7)
014e: 3f2e000e             move.w     $e(a6), -(a7)
0152: a95d                 dc.w       $a95d
0154: 4e5e                 unlk       a6
0156: 4e75                 rts        
0158: 4e560000             link.w     a6, #$0
015c: 3f2e000c             move.w     $c(a6), -(a7)
0160: 2f2e0008             move.l     $8(a6), -(a7)
0164: 4eba0bfe             jsr        $d64(pc)
0168: 2e80                 move.l     d0, (a7)
016a: 3f2e000e             move.w     $e(a6), -(a7)
016e: a963                 dc.w       $a963
0170: 4e5e                 unlk       a6
0172: 4e75                 rts        
0174: 4e560000             link.w     a6, #$0
0178: 4267                 clr.w      -(a7)
017a: 3f2e000c             move.w     $c(a6), -(a7)
017e: 2f2e0008             move.l     $8(a6), -(a7)
0182: 4eba0be0             jsr        $d64(pc)
0186: 548f                 addq.l     #$2, a7
0188: 2e80                 move.l     d0, (a7)
018a: a960                 dc.w       $a960
018c: 301f                 move.w     (a7)+, d0
018e: 4e5e                 unlk       a6
0190: 4e75                 rts        
0192: 4e560000             link.w     a6, #$0
0196: 2f2e0008             move.l     $8(a6), -(a7)
019a: a873                 dc.w       $a873
019c: 206e0008             movea.l    $8(a6), a0
01a0: 48680010             pea.l      $10(a0)
01a4: a928                 dc.w       $a928
01a6: 4e5e                 unlk       a6
01a8: 4e75                 rts        
01aa: 4e560000             link.w     a6, #$0
01ae: 2f0c                 move.l     a4, -(a7)
01b0: 42a7                 clr.l      -(a7)
01b2: 2f2e000c             move.l     $c(a6), -(a7)
01b6: 4267                 clr.w      -(a7)
01b8: a9a0                 dc.w       $a9a0
01ba: 285f                 movea.l    (a7)+, a4
01bc: 200c                 move.l     a4, d0
01be: 6724                 beq.b      $1e4
01c0: 204c                 movea.l    a4, a0
01c2: a029                 dc.w       $a029
01c4: 42a7                 clr.l      -(a7)
01c6: 2f0c                 move.l     a4, -(a7)
01c8: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
01cc: 201f                 move.l     (a7)+, d0
01ce: 2254                 movea.l    (a4), a1
01d0: 206e0008             movea.l    $8(a6), a0
01d4: a02e                 dc.w       $a02e
01d6: 204c                 movea.l    a4, a0
01d8: a02a                 dc.w       $a02a
01da: 2f0c                 move.l     a4, -(a7)
01dc: a9aa                 dc.w       $a9aa
01de: 4267                 clr.w      -(a7)
01e0: a994                 dc.w       $a994
01e2: a999                 dc.w       $a999
01e4: 285f                 movea.l    (a7)+, a4
01e6: 4e5e                 unlk       a6
01e8: 4e75                 rts        
01ea: 4e560000             link.w     a6, #$0
01ee: 42a7                 clr.l      -(a7)
01f0: 2f2e0008             move.l     $8(a6), -(a7)
01f4: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
01f8: 202e000c             move.l     $c(a6), d0
01fc: d09f                 add.l      (a7)+, d0
01fe: 206e0008             movea.l    $8(a6), a0
0202: a024                 dc.w       $a024
0204: 4a780220             tst.w      $220.w
0208: 6704                 beq.b      $20e
020a: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
020e: 4e5e                 unlk       a6
0210: 4e75                 rts        
0212: 4e560000             link.w     a6, #$0
0216: 2f2e0008             move.l     $8(a6), -(a7)
021a: 4267                 clr.w      -(a7)
021c: 2f2e0008             move.l     $8(a6), -(a7)
0220: a960                 dc.w       $a960
0222: 7001                 moveq      #$1, d0
0224: 905f                 sub.w      (a7)+, d0
0226: 3f00                 move.w     d0, -(a7)
0228: a963                 dc.w       $a963
022a: 4e5e                 unlk       a6
022c: 4e75                 rts        
022e: 4e560000             link.w     a6, #$0
0232: 206e0008             movea.l    $8(a6), a0
0236: a029                 dc.w       $a029
0238: 206e0008             movea.l    $8(a6), a0
023c: 2010                 move.l     (a0), d0
023e: 4e5e                 unlk       a6
0240: 4e75                 rts        
0242: 48e70300             movem.l    d6-d7, -(a7)
0246: 2e38016a             move.l     $16a.w, d7
024a: 7c00                 moveq      #$0, d6
024c: 6002                 bra.b      $250
024e: 5286                 addq.l     #$1, d6
0250: beb8016a             cmp.l      $16a.w, d7
0254: 67f8                 beq.b      $24e
0256: 2006                 move.l     d6, d0
0258: 4cdf00c0             movem.l    (a7)+, d6-d7
025c: 4e75                 rts        
025e: 4e56fff8             link.w     a6, #$fff8
0262: 2f0c                 move.l     a4, -(a7)
0264: 286e0008             movea.l    $8(a6), a4
0268: 200c                 move.l     a4, d0
026a: 6758                 beq.b      $2c4
026c: 2f0c                 move.l     a4, -(a7)
026e: a958                 dc.w       $a958
0270: 2054                 movea.l    (a4), a0
0272: 20680004             movea.l    $4(a0), a0
0276: 2d680010fff8         move.l     $10(a0), -$8(a6)
027c: 2d680014fffc         move.l     $14(a0), -$4(a6)
0282: 486efff8             pea.l      -$8(a6)
0286: 4878ffff             pea.l      $ffff.w
028a: a8a9                 dc.w       $a8a9
028c: 70f0                 moveq      #$f0, d0
028e: d06efffe             add.w      -$2(a6), d0
0292: 3d40fffa             move.w     d0, -$6(a6)
0296: 046e000ffffc         subi.w     #$f, -$4(a6)
029c: 2f0c                 move.l     a4, -(a7)
029e: 3f2efffa             move.w     -$6(a6), -(a7)
02a2: 3f2efff8             move.w     -$8(a6), -(a7)
02a6: a959                 dc.w       $a959
02a8: 2f0c                 move.l     a4, -(a7)
02aa: 302efffe             move.w     -$2(a6), d0
02ae: 906efffa             sub.w      -$6(a6), d0
02b2: 3f00                 move.w     d0, -(a7)
02b4: 302efffc             move.w     -$4(a6), d0
02b8: 906efff8             sub.w      -$8(a6), d0
02bc: 3f00                 move.w     d0, -(a7)
02be: a95c                 dc.w       $a95c
02c0: 2f0c                 move.l     a4, -(a7)
02c2: a957                 dc.w       $a957
02c4: 285f                 movea.l    (a7)+, a4
02c6: 4e5e                 unlk       a6
02c8: 4e75                 rts        
02ca: 4e56ffec             link.w     a6, #$ffec
02ce: 486efff0             pea.l      -$10(a6)
02d2: a874                 dc.w       $a874
02d4: 2f2e0008             move.l     $8(a6), -(a7)
02d8: a873                 dc.w       $a873
02da: 206e0008             movea.l    $8(a6), a0
02de: 2d680010fff8         move.l     $10(a0), -$8(a6)
02e4: 2d680014fffc         move.l     $14(a0), -$4(a6)
02ea: 486efff8             pea.l      -$8(a6)
02ee: a870                 dc.w       $a870
02f0: 486efffc             pea.l      -$4(a6)
02f4: a870                 dc.w       $a870
02f6: 2d6efff8fff4         move.l     -$8(a6), -$c(a6)
02fc: 302efffe             move.w     -$2(a6), d0
0300: b06dfa5c             cmp.w      -$5a4(a5), d0
0304: 6d10                 blt.b      $316
0306: 302dfa5c             move.w     -$5a4(a5), d0
030a: 906efffe             sub.w      -$2(a6), d0
030e: d06efffa             add.w      -$6(a6), d0
0312: 3d40fff6             move.w     d0, -$a(a6)
0316: 4a6efff6             tst.w      -$a(a6)
031a: 6c04                 bge.b      $320
031c: 426efff6             clr.w      -$a(a6)
0320: 302efffc             move.w     -$4(a6), d0
0324: b06dfa5a             cmp.w      -$5a6(a5), d0
0328: 6d10                 blt.b      $33a
032a: 302dfa5a             move.w     -$5a6(a5), d0
032e: 906efffc             sub.w      -$4(a6), d0
0332: d06efff8             add.w      -$8(a6), d0
0336: 3d40fff4             move.w     d0, -$c(a6)
033a: 0c6e0014fff4         cmpi.w     #$14, -$c(a6)
0340: 6c06                 bge.b      $348
0342: 3d7c0014fff4         move.w     #$14, -$c(a6)
0348: 302efff6             move.w     -$a(a6), d0
034c: b06efffa             cmp.w      -$6(a6), d0
0350: 660a                 bne.b      $35c
0352: 302efff4             move.w     -$c(a6), d0
0356: b06efff8             cmp.w      -$8(a6), d0
035a: 6710                 beq.b      $36c
035c: 2f2e0008             move.l     $8(a6), -(a7)
0360: 3f2efff6             move.w     -$a(a6), -(a7)
0364: 3f2efff4             move.w     -$c(a6), -(a7)
0368: 4227                 clr.b      -(a7)
036a: a91b                 dc.w       $a91b
036c: 2f2efff0             move.l     -$10(a6), -(a7)
0370: a873                 dc.w       $a873
0372: 4e5e                 unlk       a6
0374: 4e75                 rts        
0376: 4e56fff0             link.w     a6, #$fff0
037a: 4227                 clr.b      -(a7)
037c: 3f3c0008             move.w     #$8, -(a7)
0380: 486efff0             pea.l      -$10(a6)
0384: a970                 dc.w       $a970
0386: 4a1f                 tst.b      (a7)+
0388: 673e                 beq.b      $3c8
038a: 082e0000fffe         btst.b     #$0, -$2(a6)
0390: 6708                 beq.b      $39a
0392: 0c2e002efff5         cmpi.b     #$2e, -$b(a6)
0398: 6708                 beq.b      $3a2
039a: 0c2e001bfff5         cmpi.b     #$1b, -$b(a6)
03a0: 6626                 bne.b      $3c8
03a2: 2b6d93aca222         move.l     -$6c54(a5), -$5dde(a5)
03a8: 536da386             subq.w     #$1, -$5c7a(a5)
03ac: 702c                 moveq      #$2c, d0
03ae: c1eda386             muls.w     -$5c7a(a5), d0
03b2: 41eda226             lea.l      -$5dda(a5), a0
03b6: d088                 add.l      a0, d0
03b8: 2040                 movea.l    d0, a0
03ba: 7001                 moveq      #$1, d0
03bc: 4a40                 tst.w      d0
03be: 6602                 bne.b      $3c2
03c0: 7001                 moveq      #$1, d0
03c2: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
03c6: 4ed1                 jmp        (a1)
03c8: 4e5e                 unlk       a6
03ca: 4e75                 rts        
03cc: 4e560000             link.w     a6, #$0
03d0: 2f0c                 move.l     a4, -(a7)
03d2: 42a7                 clr.l      -(a7)
03d4: 3f2e0008             move.w     $8(a6), -(a7)
03d8: a9c0                 dc.w       $a9c0
03da: a93c                 dc.w       $a93c
03dc: 42a7                 clr.l      -(a7)
03de: 3f3c0080             move.w     #$80, -(a7)
03e2: a949                 dc.w       $a949
03e4: 285f                 movea.l    (a7)+, a4
03e6: 200c                 move.l     a4, d0
03e8: 6604                 bne.b      $3ee
03ea: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
03ee: 2f0c                 move.l     a4, -(a7)
03f0: 2f3c44525652         move.l     #$44525652, -(a7)
03f6: a94d                 dc.w       $a94d
03f8: 285f                 movea.l    (a7)+, a4
03fa: 4e5e                 unlk       a6
03fc: 4e75                 rts        
03fe: 4e560000             link.w     a6, #$0
0402: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
0406: 266e0008             movea.l    $8(a6), a3
040a: 3e2e000c             move.w     $c(a6), d7
040e: 3c2e000e             move.w     $e(a6), d6
0412: 2053                 movea.l    (a3), a0
0414: 2f28003e             move.l     $3e(a0), -(a7)
0418: 4ebafe14             jsr        $22e(pc)
041c: 2840                 movea.l    d0, a4
041e: de46                 add.w      d6, d7
0420: 588f                 addq.l     #$4, a7
0422: 6022                 bra.b      $446
0424: 4227                 clr.b      -(a7)
0426: 2f0c                 move.l     a4, -(a7)
0428: 3f07                 move.w     d7, -(a7)
042a: 4eba0316             jsr        $742(pc)
042e: 4a1f                 tst.b      (a7)+
0430: 6612                 bne.b      $444
0432: 4227                 clr.b      -(a7)
0434: 2f0c                 move.l     a4, -(a7)
0436: 3007                 move.w     d7, d0
0438: d046                 add.w      d6, d0
043a: 3f00                 move.w     d0, -(a7)
043c: 4eba0304             jsr        $742(pc)
0440: 4a1f                 tst.b      (a7)+
0442: 660e                 bne.b      $452
0444: de46                 add.w      d6, d7
0446: 4a47                 tst.w      d7
0448: 6f08                 ble.b      $452
044a: 2053                 movea.l    (a3), a0
044c: be68003c             cmp.w      $3c(a0), d7
0450: 6dd2                 blt.b      $424
0452: 2053                 movea.l    (a3), a0
0454: 2068003e             movea.l    $3e(a0), a0
0458: a02a                 dc.w       $a02a
045a: 4a47                 tst.w      d7
045c: 6c04                 bge.b      $462
045e: 7000                 moveq      #$0, d0
0460: 6002                 bra.b      $464
0462: 3007                 move.w     d7, d0
0464: 4cdf18c0             movem.l    (a7)+, d6-d7/a3-a4
0468: 4e5e                 unlk       a6
046a: 4e75                 rts        
046c: 4e560000             link.w     a6, #$0
0470: 48e70118             movem.l    d7/a3-a4, -(a7)
0474: 266e0008             movea.l    $8(a6), a3
0478: 286e000c             movea.l    $c(a6), a4
047c: 1e2c0005             move.b     $5(a4), d7
0480: 2f0c                 move.l     a4, -(a7)
0482: 1f07                 move.b     d7, -(a7)
0484: 2f0b                 move.l     a3, -(a7)
0486: 4eba0068             jsr        $4f0(pc)
048a: 4a40                 tst.w      d0
048c: 4fef000a             lea.l      $a(a7), a7
0490: 6704                 beq.b      $496
0492: 7000                 moveq      #$0, d0
0494: 6052                 bra.b      $4e8
0496: 082c0000000e         btst.b     #$0, $e(a4)
049c: 6704                 beq.b      $4a2
049e: 7000                 moveq      #$0, d0
04a0: 6046                 bra.b      $4e8
04a2: 4a6e0010             tst.w      $10(a6)
04a6: 6704                 beq.b      $4ac
04a8: 7000                 moveq      #$0, d0
04aa: 603c                 bra.b      $4e8
04ac: 0c070009             cmpi.b     #$9, d7
04b0: 6612                 bne.b      $4c4
04b2: 2f0b                 move.l     a3, -(a7)
04b4: a9d7                 dc.w       $a9d7
04b6: 486df300             pea.l      -$d00(a5)
04ba: 48780004             pea.l      $4.w
04be: 2f0b                 move.l     a3, -(a7)
04c0: a9de                 dc.w       $a9de
04c2: 6022                 bra.b      $4e6
04c4: 0c07001b             cmpi.b     #$1b, d7
04c8: 6606                 bne.b      $4d0
04ca: 2f0b                 move.l     a3, -(a7)
04cc: a9d7                 dc.w       $a9d7
04ce: 6016                 bra.b      $4e6
04d0: 2f0b                 move.l     a3, -(a7)
04d2: 1f07                 move.b     d7, -(a7)
04d4: 4eba03aa             jsr        $880(pc)
04d8: 1e00                 move.b     d0, d7
04da: 1007                 move.b     d7, d0
04dc: 4880                 ext.w      d0
04de: 3e80                 move.w     d0, (a7)
04e0: 2f0b                 move.l     a3, -(a7)
04e2: a9dc                 dc.w       $a9dc
04e4: 588f                 addq.l     #$4, a7
04e6: 7001                 moveq      #$1, d0
04e8: 4cdf1880             movem.l    (a7)+, d7/a3-a4
04ec: 4e5e                 unlk       a6
04ee: 4e75                 rts        
04f0: 4e560000             link.w     a6, #$0
04f4: 48e70108             movem.l    d7/a4, -(a7)
04f8: 286e0008             movea.l    $8(a6), a4
04fc: 0c2e001c000c         cmpi.b     #$1c, $c(a6)
0502: 66000118             bne.w      $61c
0506: 206e000e             movea.l    $e(a6), a0
050a: 3e28000e             move.w     $e(a0), d7
050e: 08070009             btst.b     #$9, d7
0512: 670000b4             beq.w      $5c8
0516: 08070008             btst.b     #$8, d7
051a: 6712                 beq.b      $52e
051c: 42a7                 clr.l      -(a7)
051e: 2054                 movea.l    (a4), a0
0520: 30680022             movea.w    $22(a0), a0
0524: 2f08                 move.l     a0, -(a7)
0526: 2f0c                 move.l     a4, -(a7)
0528: a9d1                 dc.w       $a9d1
052a: 60000096             bra.w      $5c2
052e: 0807000b             btst.b     #$b, d7
0532: 6770                 beq.b      $5a4
0534: 4227                 clr.b      -(a7)
0536: 2054                 movea.l    (a4), a0
0538: 2f28003e             move.l     $3e(a0), -(a7)
053c: 4ebafcf0             jsr        $22e(pc)
0540: 2e80                 move.l     d0, (a7)
0542: 2054                 movea.l    (a4), a0
0544: 3f280022             move.w     $22(a0), -(a7)
0548: 4eba01f8             jsr        $742(pc)
054c: 4a1f                 tst.b      (a7)+
054e: 6626                 bne.b      $576
0550: 3f3c0001             move.w     #$1, -(a7)
0554: 2054                 movea.l    (a4), a0
0556: 3f280022             move.w     $22(a0), -(a7)
055a: 2f0c                 move.l     a4, -(a7)
055c: 4ebafea0             jsr        $3fe(pc)
0560: 5240                 addq.w     #$1, d0
0562: 3e00                 move.w     d0, d7
0564: 2054                 movea.l    (a4), a0
0566: 30680020             movea.w    $20(a0), a0
056a: 2e88                 move.l     a0, (a7)
056c: 3047                 movea.w    d7, a0
056e: 2f08                 move.l     a0, -(a7)
0570: 2f0c                 move.l     a4, -(a7)
0572: a9d1                 dc.w       $a9d1
0574: 588f                 addq.l     #$4, a7
0576: 2054                 movea.l    (a4), a0
0578: 2068003e             movea.l    $3e(a0), a0
057c: a02a                 dc.w       $a02a
057e: 3f3cffff             move.w     #$ffff, -(a7)
0582: 2054                 movea.l    (a4), a0
0584: 3f280020             move.w     $20(a0), -(a7)
0588: 2f0c                 move.l     a4, -(a7)
058a: 4ebafe72             jsr        $3fe(pc)
058e: 3e00                 move.w     d0, d7
0590: 3047                 movea.w    d7, a0
0592: 2e88                 move.l     a0, (a7)
0594: 2054                 movea.l    (a4), a0
0596: 30680022             movea.w    $22(a0), a0
059a: 2f08                 move.l     a0, -(a7)
059c: 2f0c                 move.l     a4, -(a7)
059e: a9d1                 dc.w       $a9d1
05a0: 588f                 addq.l     #$4, a7
05a2: 601e                 bra.b      $5c2
05a4: 2054                 movea.l    (a4), a0
05a6: 4a680020             tst.w      $20(a0)
05aa: 6716                 beq.b      $5c2
05ac: 2054                 movea.l    (a4), a0
05ae: 30680020             movea.w    $20(a0), a0
05b2: 4868ffff             pea.l      -$1(a0)
05b6: 2054                 movea.l    (a4), a0
05b8: 30680022             movea.w    $22(a0), a0
05bc: 2f08                 move.l     a0, -(a7)
05be: 2f0c                 move.l     a4, -(a7)
05c0: a9d1                 dc.w       $a9d1
05c2: 7001                 moveq      #$1, d0
05c4: 60000172             bra.w      $738
05c8: 08070008             btst.b     #$8, d7
05cc: 670c                 beq.b      $5da
05ce: 42a7                 clr.l      -(a7)
05d0: 42a7                 clr.l      -(a7)
05d2: 2f0c                 move.l     a4, -(a7)
05d4: a9d1                 dc.w       $a9d1
05d6: 6000015e             bra.w      $736
05da: 0807000b             btst.b     #$b, d7
05de: 6724                 beq.b      $604
05e0: 3f3cffff             move.w     #$ffff, -(a7)
05e4: 2054                 movea.l    (a4), a0
05e6: 3f280020             move.w     $20(a0), -(a7)
05ea: 2f0c                 move.l     a4, -(a7)
05ec: 4ebafe10             jsr        $3fe(pc)
05f0: 3e00                 move.w     d0, d7
05f2: 3047                 movea.w    d7, a0
05f4: 2e88                 move.l     a0, (a7)
05f6: 3047                 movea.w    d7, a0
05f8: 2f08                 move.l     a0, -(a7)
05fa: 2f0c                 move.l     a4, -(a7)
05fc: a9d1                 dc.w       $a9d1
05fe: 7001                 moveq      #$1, d0
0600: 60000136             bra.w      $738
0604: 2054                 movea.l    (a4), a0
0606: 30680020             movea.w    $20(a0), a0
060a: 2f08                 move.l     a0, -(a7)
060c: 2054                 movea.l    (a4), a0
060e: 30680020             movea.w    $20(a0), a0
0612: 2f08                 move.l     a0, -(a7)
0614: 2f0c                 move.l     a4, -(a7)
0616: a9d1                 dc.w       $a9d1
0618: 6000011c             bra.w      $736
061c: 0c2e001d000c         cmpi.b     #$1d, $c(a6)
0622: 66000112             bne.w      $736
0626: 206e000e             movea.l    $e(a6), a0
062a: 3e28000e             move.w     $e(a0), d7
062e: 08070009             btst.b     #$9, d7
0632: 670000b0             beq.w      $6e4
0636: 08070008             btst.b     #$8, d7
063a: 6714                 beq.b      $650
063c: 2054                 movea.l    (a4), a0
063e: 30680020             movea.w    $20(a0), a0
0642: 2f08                 move.l     a0, -(a7)
0644: 48787fff             pea.l      $7fff.w
0648: 2f0c                 move.l     a4, -(a7)
064a: a9d1                 dc.w       $a9d1
064c: 60000092             bra.w      $6e0
0650: 0807000b             btst.b     #$b, d7
0654: 6774                 beq.b      $6ca
0656: 4227                 clr.b      -(a7)
0658: 2054                 movea.l    (a4), a0
065a: 2f28003e             move.l     $3e(a0), -(a7)
065e: 4ebafbce             jsr        $22e(pc)
0662: 2e80                 move.l     d0, (a7)
0664: 2054                 movea.l    (a4), a0
0666: 70ff                 moveq      #$ff, d0
0668: d0680020             add.w      $20(a0), d0
066c: 3f00                 move.w     d0, -(a7)
066e: 4eba00d2             jsr        $742(pc)
0672: 4a1f                 tst.b      (a7)+
0674: 6624                 bne.b      $69a
0676: 3f3cffff             move.w     #$ffff, -(a7)
067a: 2054                 movea.l    (a4), a0
067c: 3f280020             move.w     $20(a0), -(a7)
0680: 2f0c                 move.l     a4, -(a7)
0682: 4ebafd7a             jsr        $3fe(pc)
0686: 3e00                 move.w     d0, d7
0688: 3047                 movea.w    d7, a0
068a: 2e88                 move.l     a0, (a7)
068c: 2054                 movea.l    (a4), a0
068e: 30680022             movea.w    $22(a0), a0
0692: 2f08                 move.l     a0, -(a7)
0694: 2f0c                 move.l     a4, -(a7)
0696: a9d1                 dc.w       $a9d1
0698: 588f                 addq.l     #$4, a7
069a: 2054                 movea.l    (a4), a0
069c: 2068003e             movea.l    $3e(a0), a0
06a0: a02a                 dc.w       $a02a
06a2: 3f3c0001             move.w     #$1, -(a7)
06a6: 2054                 movea.l    (a4), a0
06a8: 3f280022             move.w     $22(a0), -(a7)
06ac: 2f0c                 move.l     a4, -(a7)
06ae: 4ebafd4e             jsr        $3fe(pc)
06b2: 5240                 addq.w     #$1, d0
06b4: 3e00                 move.w     d0, d7
06b6: 2054                 movea.l    (a4), a0
06b8: 30680020             movea.w    $20(a0), a0
06bc: 2e88                 move.l     a0, (a7)
06be: 3047                 movea.w    d7, a0
06c0: 2f08                 move.l     a0, -(a7)
06c2: 2f0c                 move.l     a4, -(a7)
06c4: a9d1                 dc.w       $a9d1
06c6: 588f                 addq.l     #$4, a7
06c8: 6016                 bra.b      $6e0
06ca: 2054                 movea.l    (a4), a0
06cc: 30680020             movea.w    $20(a0), a0
06d0: 2f08                 move.l     a0, -(a7)
06d2: 2054                 movea.l    (a4), a0
06d4: 30680022             movea.w    $22(a0), a0
06d8: 48680001             pea.l      $1(a0)
06dc: 2f0c                 move.l     a4, -(a7)
06de: a9d1                 dc.w       $a9d1
06e0: 7001                 moveq      #$1, d0
06e2: 6054                 bra.b      $738
06e4: 08070008             btst.b     #$8, d7
06e8: 670e                 beq.b      $6f8
06ea: 48787fff             pea.l      $7fff.w
06ee: 48787fff             pea.l      $7fff.w
06f2: 2f0c                 move.l     a4, -(a7)
06f4: a9d1                 dc.w       $a9d1
06f6: 603e                 bra.b      $736
06f8: 0807000b             btst.b     #$b, d7
06fc: 6724                 beq.b      $722
06fe: 3f3c0001             move.w     #$1, -(a7)
0702: 2054                 movea.l    (a4), a0
0704: 3f280022             move.w     $22(a0), -(a7)
0708: 2f0c                 move.l     a4, -(a7)
070a: 4ebafcf2             jsr        $3fe(pc)
070e: 5240                 addq.w     #$1, d0
0710: 3e00                 move.w     d0, d7
0712: 3047                 movea.w    d7, a0
0714: 2e88                 move.l     a0, (a7)
0716: 3047                 movea.w    d7, a0
0718: 2f08                 move.l     a0, -(a7)
071a: 2f0c                 move.l     a4, -(a7)
071c: a9d1                 dc.w       $a9d1
071e: 7001                 moveq      #$1, d0
0720: 6016                 bra.b      $738
0722: 2054                 movea.l    (a4), a0
0724: 30680022             movea.w    $22(a0), a0
0728: 2f08                 move.l     a0, -(a7)
072a: 2054                 movea.l    (a4), a0
072c: 30680022             movea.w    $22(a0), a0
0730: 2f08                 move.l     a0, -(a7)
0732: 2f0c                 move.l     a4, -(a7)
0734: a9d1                 dc.w       $a9d1
0736: 7000                 moveq      #$0, d0
0738: 4cee1080fff8         movem.l    -$8(a6), d7/a4
073e: 4e5e                 unlk       a6
0740: 4e75                 rts        
0742: 4e560000             link.w     a6, #$0
0746: 48e70708             movem.l    d5-d7/a4, -(a7)
074a: 286e000a             movea.l    $a(a6), a4
074e: 3c2e0008             move.w     $8(a6), d6
0752: 1e346000             move.b     (a4, d6.w), d7
0756: 42a7                 clr.l      -(a7)
0758: 2f0c                 move.l     a4, -(a7)
075a: 4ead0b02             jsr        $b02(a5) ; CODE34+01a4
075e: 3046                 movea.w    d6, a0
0760: b1df                 cmpa.l     (a7)+, a0
0762: 6608                 bne.b      $76c
0764: 422e000e             clr.b      $e(a6)
0768: 6000010a             bra.w      $874
076c: 7000                 moveq      #$0, d0
076e: 1007                 move.b     d7, d0
0770: 204d                 movea.l    a5, a0
0772: d1c0                 adda.l     d0, a0
0774: 1a28fbd8             move.b     -$428(a0), d5
0778: 4885                 ext.w      d5
077a: 3005                 move.w     d5, d0
077c: 024000c0             andi.w     #$c0, d0
0780: 6606                 bne.b      $788
0782: 08050004             btst.b     #$4, d5
0786: 6708                 beq.b      $790
0788: 422e000e             clr.b      $e(a6)
078c: 600000e6             bra.w      $874
0790: 0c0700ca             cmpi.b     #$ca, d7
0794: 6724                 beq.b      $7ba
0796: 0c070024             cmpi.b     #$24, d7
079a: 671e                 beq.b      $7ba
079c: 0c0700a2             cmpi.b     #$a2, d7
07a0: 6718                 beq.b      $7ba
07a2: 0c0700a3             cmpi.b     #$a3, d7
07a6: 6712                 beq.b      $7ba
07a8: 0c0700b4             cmpi.b     #$b4, d7
07ac: 670c                 beq.b      $7ba
07ae: 0c070025             cmpi.b     #$25, d7
07b2: 6706                 beq.b      $7ba
07b4: 0c07002d             cmpi.b     #$2d, d7
07b8: 6608                 bne.b      $7c2
07ba: 422e000e             clr.b      $e(a6)
07be: 600000b4             bra.w      $874
07c2: 0c07002c             cmpi.b     #$2c, d7
07c6: 6632                 bne.b      $7fa
07c8: 4a46                 tst.w      d6
07ca: 6f0000a2             ble.w      $86e
07ce: 7000                 moveq      #$0, d0
07d0: 103460ff             move.b     -$1(a4, d6.w), d0
07d4: 204d                 movea.l    a5, a0
07d6: d1c0                 adda.l     d0, a0
07d8: 08280004fbd8         btst.b     #$4, -$428(a0)
07de: 6700008e             beq.w      $86e
07e2: 7000                 moveq      #$0, d0
07e4: 10346001             move.b     $1(a4, d6.w), d0
07e8: 204d                 movea.l    a5, a0
07ea: d1c0                 adda.l     d0, a0
07ec: 08280004fbd8         btst.b     #$4, -$428(a0)
07f2: 677a                 beq.b      $86e
07f4: 422e000e             clr.b      $e(a6)
07f8: 607a                 bra.b      $874
07fa: 0c07002e             cmpi.b     #$2e, d7
07fe: 6618                 bne.b      $818
0800: 7000                 moveq      #$0, d0
0802: 10346001             move.b     $1(a4, d6.w), d0
0806: 204d                 movea.l    a5, a0
0808: d1c0                 adda.l     d0, a0
080a: 08280004fbd8         btst.b     #$4, -$428(a0)
0810: 675c                 beq.b      $86e
0812: 422e000e             clr.b      $e(a6)
0816: 605c                 bra.b      $874
0818: 0c070027             cmpi.b     #$27, d7
081c: 6706                 beq.b      $824
081e: 0c0700d5             cmpi.b     #$d5, d7
0822: 664a                 bne.b      $86e
0824: 4a46                 tst.w      d6
0826: 6f46                 ble.b      $86e
0828: 1e3460ff             move.b     -$1(a4, d6.w), d7
082c: 7000                 moveq      #$0, d0
082e: 1007                 move.b     d7, d0
0830: 204d                 movea.l    a5, a0
0832: d1c0                 adda.l     d0, a0
0834: 1a28fbd8             move.b     -$428(a0), d5
0838: 4885                 ext.w      d5
083a: 3005                 move.w     d5, d0
083c: 024000c0             andi.w     #$c0, d0
0840: 6606                 bne.b      $848
0842: 08050004             btst.b     #$4, d5
0846: 6726                 beq.b      $86e
0848: 1e346001             move.b     $1(a4, d6.w), d7
084c: 7000                 moveq      #$0, d0
084e: 1007                 move.b     d7, d0
0850: 204d                 movea.l    a5, a0
0852: d1c0                 adda.l     d0, a0
0854: 1c28fbd8             move.b     -$428(a0), d6
0858: 4886                 ext.w      d6
085a: 3006                 move.w     d6, d0
085c: 024000c0             andi.w     #$c0, d0
0860: 6606                 bne.b      $868
0862: 08060004             btst.b     #$4, d6
0866: 6706                 beq.b      $86e
0868: 422e000e             clr.b      $e(a6)
086c: 6006                 bra.b      $874
086e: 1d7c0001000e         move.b     #$1, $e(a6)
0874: 4cdf10e0             movem.l    (a7)+, d5-d7/a4
0878: 4e5e                 unlk       a6
087a: 205f                 movea.l    (a7)+, a0
087c: 5c8f                 addq.l     #$6, a7
087e: 4ed0                 jmp        (a0)
0880: 4e560000             link.w     a6, #$0
0884: 48e70708             movem.l    d5-d7/a4, -(a7)
0888: 1e2e0008             move.b     $8(a6), d7
088c: 0c070022             cmpi.b     #$22, d7
0890: 670a                 beq.b      $89c
0892: 0c070027             cmpi.b     #$27, d7
0896: 6704                 beq.b      $89c
0898: 1007                 move.b     d7, d0
089a: 607a                 bra.b      $916
089c: 206e000a             movea.l    $a(a6), a0
08a0: 2850                 movea.l    (a0), a4
08a2: 3c2c0020             move.w     $20(a4), d6
08a6: 226c003e             movea.l    $3e(a4), a1
08aa: 2251                 movea.l    (a1), a1
08ac: 1a3160ff             move.b     -$1(a1, d6.w), d5
08b0: 4885                 ext.w      d5
08b2: 4a46                 tst.w      d6
08b4: 6746                 beq.b      $8fc
08b6: 7000                 moveq      #$0, d0
08b8: 1005                 move.b     d5, d0
08ba: 204d                 movea.l    a5, a0
08bc: d1c0                 adda.l     d0, a0
08be: 7006                 moveq      #$6, d0
08c0: c028fbd8             and.b      -$428(a0), d0
08c4: 6636                 bne.b      $8fc
08c6: 0c450028             cmpi.w     #$28, d5
08ca: 6730                 beq.b      $8fc
08cc: 0c45005b             cmpi.w     #$5b, d5
08d0: 672a                 beq.b      $8fc
08d2: 0c45007b             cmpi.w     #$7b, d5
08d6: 6724                 beq.b      $8fc
08d8: 0c45003c             cmpi.w     #$3c, d5
08dc: 671e                 beq.b      $8fc
08de: 0c45ffca             cmpi.w     #$ffca, d5
08e2: 6718                 beq.b      $8fc
08e4: 0c45ffd2             cmpi.w     #$ffd2, d5
08e8: 6606                 bne.b      $8f0
08ea: 0c070027             cmpi.b     #$27, d7
08ee: 670c                 beq.b      $8fc
08f0: 0c45ffd4             cmpi.w     #$ffd4, d5
08f4: 6614                 bne.b      $90a
08f6: 0c070022             cmpi.b     #$22, d7
08fa: 660e                 bne.b      $90a
08fc: 0c070022             cmpi.b     #$22, d7
0900: 6604                 bne.b      $906
0902: 70d2                 moveq      #$d2, d0
0904: 6010                 bra.b      $916
0906: 70d4                 moveq      #$d4, d0
0908: 600c                 bra.b      $916
090a: 0c070022             cmpi.b     #$22, d7
090e: 6604                 bne.b      $914
0910: 70d3                 moveq      #$d3, d0
0912: 6002                 bra.b      $916
0914: 70d5                 moveq      #$d5, d0
0916: 4cdf10e0             movem.l    (a7)+, d5-d7/a4
091a: 4e5e                 unlk       a6
091c: 4e75                 rts        
091e: 4e56fe5e             link.w     a6, #$fe5e
0922: 48e70108             movem.l    d7/a4, -(a7)
0926: 286e000c             movea.l    $c(a6), a4
092a: 4267                 clr.w      -(a7)
092c: 486eff00             pea.l      -$100(a6)
0930: 2f0c                 move.l     a4, -(a7)
0932: 4ead0b42             jsr        $b42(a5) ; CODE34+02aa
0936: 4878006c             pea.l      $6c.w
093a: 486efe92             pea.l      -$16e(a6)
093e: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0942: 2d6e0008fea4         move.l     $8(a6), -$15c(a6)
0948: 3d54fea8             move.w     (a4), -$158(a6)
094c: 4257                 clr.w      (a7)
094e: 486efe92             pea.l      -$16e(a6)
0952: 4227                 clr.b      -(a7)
0954: 4ead0b7a             jsr        $b7a(a5) ; CODE34+03bc
0958: 206e0010             movea.l    $10(a6), a0
095c: 20aefec2             move.l     -$13e(a6), (a0)
0960: 7034                 moveq      #$34, d0
0962: 2e80                 move.l     d0, (a7)
0964: 486efe5e             pea.l      -$1a2(a6)
0968: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
096c: 48780100             pea.l      $100.w
0970: 486eff00             pea.l      -$100(a6)
0974: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0978: 41eeff00             lea.l      -$100(a6), a0
097c: 2d48fe70             move.l     a0, -$190(a6)
0980: 3d54fe74             move.w     (a4), -$18c(a6)
0984: 4257                 clr.w      (a7)
0986: 486efe5e             pea.l      -$1a2(a6)
098a: 4227                 clr.b      -(a7)
098c: 4ead0b72             jsr        $b72(a5) ; CODE34+03a6
0990: 3e1f                 move.w     (a7)+, d7
0992: 4a47                 tst.w      d7
0994: 4fef0014             lea.l      $14(a7), a7
0998: 6704                 beq.b      $99e
099a: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
099e: 38aefe7e             move.w     -$182(a6), (a4)
09a2: 4cdf1080             movem.l    (a7)+, d7/a4
09a6: 4e5e                 unlk       a6
09a8: 4e75                 rts        
09aa: 4e560000             link.w     a6, #$0
09ae: 48e70718             movem.l    d5-d7/a3-a4, -(a7)
09b2: 266e0008             movea.l    $8(a6), a3
09b6: 49eb0006             lea.l      $6(a3), a4
09ba: 3e14                 move.w     (a4), d7
09bc: 9e6b0002             sub.w      $2(a3), d7
09c0: 3c2b0004             move.w     $4(a3), d6
09c4: 9c53                 sub.w      (a3), d6
09c6: 302dfa5c             move.w     -$5a4(a5), d0
09ca: 906b0002             sub.w      $2(a3), d0
09ce: 9054                 sub.w      (a4), d0
09d0: 48c0                 ext.l      d0
09d2: 81fc0002             divs.w     #$2, d0
09d6: d16b0002             add.w      d0, $2(a3)
09da: 302dfa5a             move.w     -$5a6(a5), d0
09de: 9053                 sub.w      (a3), d0
09e0: 906b0004             sub.w      $4(a3), d0
09e4: 48c0                 ext.l      d0
09e6: 81fc0002             divs.w     #$2, d0
09ea: d153                 add.w      d0, (a3)
09ec: 302dfa5a             move.w     -$5a6(a5), d0
09f0: 48c0                 ext.l      d0
09f2: 81fc0006             divs.w     #$6, d0
09f6: 9153                 sub.w      d0, (a3)
09f8: 7a1c                 moveq      #$1c, d5
09fa: da780baa             add.w      $baa.w, d5
09fe: ba53                 cmp.w      (a3), d5
0a00: 6f02                 ble.b      $a04
0a02: 3685                 move.w     d5, (a3)
0a04: 302b0002             move.w     $2(a3), d0
0a08: d047                 add.w      d7, d0
0a0a: 3880                 move.w     d0, (a4)
0a0c: 3013                 move.w     (a3), d0
0a0e: d046                 add.w      d6, d0
0a10: 37400004             move.w     d0, $4(a3)
0a14: 4cdf18e0             movem.l    (a7)+, d5-d7/a3-a4
0a18: 4e5e                 unlk       a6
0a1a: 4e75                 rts        
0a1c: 4e56fffc             link.w     a6, #$fffc
0a20: 48e70738             movem.l    d5-d7/a2-a4, -(a7)
0a24: 2c2e0008             move.l     $8(a6), d6
0a28: 266e000e             movea.l    $e(a6), a3
0a2c: 42a7                 clr.l      -(a7)
0a2e: 2f06                 move.l     d6, -(a7)
0a30: 3f2e000c             move.w     $c(a6), -(a7)
0a34: a9a0                 dc.w       $a9a0
0a36: 285f                 movea.l    (a7)+, a4
0a38: 200c                 move.l     a4, d0
0a3a: 6604                 bne.b      $a40
0a3c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0a40: 204c                 movea.l    a4, a0
0a42: a029                 dc.w       $a029
0a44: 0c86444c4f47         cmpi.l     #$444c4f47, d6
0a4a: 660e                 bne.b      $a5a
0a4c: 2054                 movea.l    (a4), a0
0a4e: 2690                 move.l     (a0), (a3)
0a50: 276800040004         move.l     $4(a0), $4(a3)
0a56: 600000ae             bra.w      $b06
0a5a: 0c864449544c         cmpi.l     #$4449544c, d6
0a60: 66000094             bne.w      $af6
0a64: 2454                 movea.l    (a4), a2
0a66: 3c12                 move.w     (a2), d6
0a68: 2e0a                 move.l     a2, d7
0a6a: 5487                 addq.l     #$2, d7
0a6c: 48780008             pea.l      $8.w
0a70: 2f0b                 move.l     a3, -(a7)
0a72: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0a76: 303c7fff             move.w     #$7fff, d0
0a7a: 37400002             move.w     d0, $2(a3)
0a7e: 3680                 move.w     d0, (a3)
0a80: 7a00                 moveq      #$0, d5
0a82: 508f                 addq.l     #$8, a7
0a84: 6056                 bra.b      $adc
0a86: 5887                 addq.l     #$4, d7
0a88: 2447                 movea.l    d7, a2
0a8a: 302a0006             move.w     $6(a2), d0
0a8e: b06b0006             cmp.w      $6(a3), d0
0a92: 6f06                 ble.b      $a9a
0a94: 376a00060006         move.w     $6(a2), $6(a3)
0a9a: 302a0004             move.w     $4(a2), d0
0a9e: b06b0004             cmp.w      $4(a3), d0
0aa2: 6f06                 ble.b      $aaa
0aa4: 376a00040004         move.w     $4(a2), $4(a3)
0aaa: 3012                 move.w     (a2), d0
0aac: b053                 cmp.w      (a3), d0
0aae: 6c02                 bge.b      $ab2
0ab0: 3692                 move.w     (a2), (a3)
0ab2: 302a0002             move.w     $2(a2), d0
0ab6: b06b0002             cmp.w      $2(a3), d0
0aba: 6c06                 bge.b      $ac2
0abc: 376a00020002         move.w     $2(a2), $2(a3)
0ac2: 5087                 addq.l     #$8, d7
0ac4: 5287                 addq.l     #$1, d7
0ac6: 2047                 movea.l    d7, a0
0ac8: 7000                 moveq      #$0, d0
0aca: 1010                 move.b     (a0), d0
0acc: 5240                 addq.w     #$1, d0
0ace: 3040                 movea.w    d0, a0
0ad0: de88                 add.l      a0, d7
0ad2: 08070000             btst.b     #$0, d7
0ad6: 6702                 beq.b      $ada
0ad8: 5287                 addq.l     #$1, d7
0ada: 5245                 addq.w     #$1, d5
0adc: bc45                 cmp.w      d5, d6
0ade: 6ca6                 bge.b      $a86
0ae0: 3013                 move.w     (a3), d0
0ae2: d16b0004             add.w      d0, $4(a3)
0ae6: 4253                 clr.w      (a3)
0ae8: 302b0002             move.w     $2(a3), d0
0aec: d16b0006             add.w      d0, $6(a3)
0af0: 426b0002             clr.w      $2(a3)
0af4: 6010                 bra.b      $b06
0af6: 0c86414c5254         cmpi.l     #$414c5254, d6
0afc: 6604                 bne.b      $b02
0afe: 2654                 movea.l    (a4), a3
0b00: 6004                 bra.b      $b06
0b02: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0b06: 2d4cfffc             move.l     a4, -$4(a6)
0b0a: 4267                 clr.w      -(a7)
0b0c: 486efffc             pea.l      -$4(a6)
0b10: 4ead0ba2             jsr        $ba2(a5) ; CODE34+0486
0b14: 3c1f                 move.w     (a7)+, d6
0b16: 4a46                 tst.w      d6
0b18: 6704                 beq.b      $b1e
0b1a: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0b1e: 204c                 movea.l    a4, a0
0b20: a02a                 dc.w       $a02a
0b22: 2f0c                 move.l     a4, -(a7)
0b24: a9a3                 dc.w       $a9a3
0b26: 286efffc             movea.l    -$4(a6), a4
0b2a: 204c                 movea.l    a4, a0
0b2c: a029                 dc.w       $a029
0b2e: 2f0b                 move.l     a3, -(a7)
0b30: 4ebafe78             jsr        $9aa(pc)
0b34: 204c                 movea.l    a4, a0
0b36: a02a                 dc.w       $a02a
0b38: 200c                 move.l     a4, d0
0b3a: 4cee1ce0ffe4         movem.l    -$1c(a6), d5-d7/a2-a4
0b40: 4e5e                 unlk       a6
0b42: 4e75                 rts        
0b44: 4e56fff8             link.w     a6, #$fff8
0b48: 2f0c                 move.l     a4, -(a7)
0b4a: 486efff8             pea.l      -$8(a6)
0b4e: 3f2e000c             move.w     $c(a6), -(a7)
0b52: 2f3c444c4f47         move.l     #$444c4f47, -(a7)
0b58: 4ebafec2             jsr        $a1c(pc)
0b5c: 2840                 movea.l    d0, a4
0b5e: 200c                 move.l     a4, d0
0b60: 4fef000a             lea.l      $a(a7), a7
0b64: 6604                 bne.b      $b6a
0b66: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0b6a: 2f2e0008             move.l     $8(a6), -(a7)
0b6e: 3f2efffa             move.w     -$6(a6), -(a7)
0b72: 3f2efff8             move.w     -$8(a6), -(a7)
0b76: a880                 dc.w       $a880
0b78: 204c                 movea.l    a4, a0
0b7a: a023                 dc.w       $a023
0b7c: 285f                 movea.l    (a7)+, a4
0b7e: 4e5e                 unlk       a6
0b80: 4e75                 rts        
0b82: 4e56fffc             link.w     a6, #$fffc
0b86: 2f0c                 move.l     a4, -(a7)
0b88: 286e0008             movea.l    $8(a6), a4
0b8c: 4a14                 tst.b      (a4)
0b8e: 670e                 beq.b      $b9e
0b90: 486c000a             pea.l      $a(a4)
0b94: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
0b98: 5580                 subq.l     #$2, d0
0b9a: 588f                 addq.l     #$4, a7
0b9c: 6456                 bcc.b      $bf4
0b9e: 4aae000c             tst.l      $c(a6)
0ba2: 672c                 beq.b      $bd0
0ba4: 3f3cf060             move.w     #$f060, -(a7)
0ba8: 486efffc             pea.l      -$4(a6)
0bac: 4ebaff96             jsr        $b44(pc)
0bb0: 2eaefffc             move.l     -$4(a6), (a7)
0bb4: 2f2df248             move.l     -$db8(a5), -(a7)
0bb8: 42a7                 clr.l      -(a7)
0bba: 3f2e0010             move.w     $10(a6), -(a7)
0bbe: 2f2e000c             move.l     $c(a6), -(a7)
0bc2: 42a7                 clr.l      -(a7)
0bc4: 2f0c                 move.l     a4, -(a7)
0bc6: 3f3c0002             move.w     #$2, -(a7)
0bca: a9ea                 dc.w       $a9ea
0bcc: 548f                 addq.l     #$2, a7
0bce: 6024                 bra.b      $bf4
0bd0: 3f3cf061             move.w     #$f061, -(a7)
0bd4: 486efffc             pea.l      -$4(a6)
0bd8: 4ebaff6a             jsr        $b44(pc)
0bdc: 2eaefffc             move.l     -$4(a6), (a7)
0be0: 2f2df24c             move.l     -$db4(a5), -(a7)
0be4: 486c000a             pea.l      $a(a4)
0be8: 42a7                 clr.l      -(a7)
0bea: 2f0c                 move.l     a4, -(a7)
0bec: 3f3c0001             move.w     #$1, -(a7)
0bf0: a9ea                 dc.w       $a9ea
0bf2: 548f                 addq.l     #$2, a7
0bf4: 7000                 moveq      #$0, d0
0bf6: 1014                 move.b     (a4), d0
0bf8: 285f                 movea.l    (a7)+, a4
0bfa: 4e5e                 unlk       a6
0bfc: 4e75                 rts        
0bfe: 4e56fff8             link.w     a6, #$fff8
0c02: 48e70118             movem.l    d7/a3-a4, -(a7)
0c06: 286e0008             movea.l    $8(a6), a4
0c0a: 2f0c                 move.l     a4, -(a7)
0c0c: 4ead0d6a             jsr        $d6a(a5) ; CODE51+0004
0c10: 2e00                 move.l     d0, d7
0c12: 08070006             btst.b     #$6, d7
0c16: 588f                 addq.l     #$4, a7
0c18: 663c                 bne.b      $c56
0c1a: 08070001             btst.b     #$1, d7
0c1e: 6636                 bne.b      $c56
0c20: 2f0c                 move.l     a4, -(a7)
0c22: a873                 dc.w       $a873
0c24: 2d6c0010fff8         move.l     $10(a4), -$8(a6)
0c2a: 2d6c0014fffc         move.l     $14(a4), -$4(a6)
0c30: 70f1                 moveq      #$f1, d0
0c32: d06efffe             add.w      -$2(a6), d0
0c36: 3d40fffa             move.w     d0, -$6(a6)
0c3a: 42a7                 clr.l      -(a7)
0c3c: a8d8                 dc.w       $a8d8
0c3e: 265f                 movea.l    (a7)+, a3
0c40: 2f0b                 move.l     a3, -(a7)
0c42: a87a                 dc.w       $a87a
0c44: 486efff8             pea.l      -$8(a6)
0c48: a87b                 dc.w       $a87b
0c4a: 2f0c                 move.l     a4, -(a7)
0c4c: a904                 dc.w       $a904
0c4e: 2f0b                 move.l     a3, -(a7)
0c50: a879                 dc.w       $a879
0c52: 2f0b                 move.l     a3, -(a7)
0c54: a8d9                 dc.w       $a8d9
0c56: 4cdf1880             movem.l    (a7)+, d7/a3-a4
0c5a: 4e5e                 unlk       a6
0c5c: 4e75                 rts        
0c5e: 42a7                 clr.l      -(a7)
0c60: a9f9                 dc.w       $a9f9
0c62: 205f                 movea.l    (a7)+, a0
0c64: 302df274             move.w     -$d8c(a5), d0
0c68: b0680008             cmp.w      $8(a0), d0
0c6c: 6714                 beq.b      $c82
0c6e: 4267                 clr.w      -(a7)
0c70: 4ead0bca             jsr        $bca(a5) ; CODE34+04ce
0c74: 42a7                 clr.l      -(a7)
0c76: a9f9                 dc.w       $a9f9
0c78: 205f                 movea.l    (a7)+, a0
0c7a: 3b680008f274         move.w     $8(a0), -$d8c(a5)
0c80: 548f                 addq.l     #$2, a7
0c82: 4e75                 rts        
0c84: 4a6df276             tst.w      -$d8a(a5)
0c88: 6716                 beq.b      $ca0
0c8a: 42a7                 clr.l      -(a7)
0c8c: a9fc                 dc.w       $a9fc
0c8e: 201f                 move.l     (a7)+, d0
0c90: 3b40f274             move.w     d0, -$d8c(a5)
0c94: 4267                 clr.w      -(a7)
0c96: 4ead0bd2             jsr        $bd2(a5) ; CODE34+0524
0c9a: 426df276             clr.w      -$d8a(a5)
0c9e: 548f                 addq.l     #$2, a7
0ca0: 4e75                 rts        
0ca2: 4e56fdfc             link.w     a6, #$fdfc
0ca6: 2f07                 move.l     d7, -(a7)
0ca8: 48780200             pea.l      $200.w
0cac: 486efe00             pea.l      -$200(a6)
0cb0: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0cb4: 508f                 addq.l     #$8, a7
0cb6: 601a                 bra.b      $cd2
0cb8: 206e0010             movea.l    $10(a6), a0
0cbc: 52ae0010             addq.l     #$1, $10(a6)
0cc0: 7000                 moveq      #$0, d0
0cc2: 1010                 move.b     (a0), d0
0cc4: 4880                 ext.w      d0
0cc6: 204e                 movea.l    a6, a0
0cc8: d1c0                 adda.l     d0, a0
0cca: d1c0                 adda.l     d0, a0
0ccc: 317c0001fe00         move.w     #$1, -$200(a0)
0cd2: 206e0010             movea.l    $10(a6), a0
0cd6: 4a10                 tst.b      (a0)
0cd8: 66de                 bne.b      $cb8
0cda: 7e00                 moveq      #$0, d7
0cdc: 6022                 bra.b      $d00
0cde: 206e000c             movea.l    $c(a6), a0
0ce2: 7000                 moveq      #$0, d0
0ce4: 1010                 move.b     (a0), d0
0ce6: 4880                 ext.w      d0
0ce8: 224e                 movea.l    a6, a1
0cea: d3c0                 adda.l     d0, a1
0cec: d3c0                 adda.l     d0, a1
0cee: 4a69fe00             tst.w      -$200(a1)
0cf2: 6706                 beq.b      $cfa
0cf4: 52ae000c             addq.l     #$1, $c(a6)
0cf8: 6002                 bra.b      $cfc
0cfa: 7e01                 moveq      #$1, d7
0cfc: 52ae0008             addq.l     #$1, $8(a6)
0d00: 206e0008             movea.l    $8(a6), a0
0d04: 226e000c             movea.l    $c(a6), a1
0d08: 1290                 move.b     (a0), (a1)
0d0a: 66d2                 bne.b      $cde
0d0c: 3007                 move.w     d7, d0
0d0e: 2e1f                 move.l     (a7)+, d7
0d10: 4e5e                 unlk       a6
0d12: 4e75                 rts        
0d14: 4e56fff2             link.w     a6, #$fff2
0d18: 2f2e0008             move.l     $8(a6), -(a7)
0d1c: 3f2e000c             move.w     $c(a6), -(a7)
0d20: 486efffa             pea.l      -$6(a6)
0d24: 486efffc             pea.l      -$4(a6)
0d28: 486efff2             pea.l      -$e(a6)
0d2c: a98d                 dc.w       $a98d
0d2e: 2f2efffc             move.l     -$4(a6), -(a7)
0d32: 2f2e000e             move.l     $e(a6), -(a7)
0d36: a95b                 dc.w       $a95b
0d38: 4e5e                 unlk       a6
0d3a: 4e75                 rts        
0d3c: 4e56fff2             link.w     a6, #$fff2
0d40: 2f2e0008             move.l     $8(a6), -(a7)
0d44: 3f2e000c             move.w     $c(a6), -(a7)
0d48: 486efffa             pea.l      -$6(a6)
0d4c: 486efffc             pea.l      -$4(a6)
0d50: 486efff2             pea.l      -$e(a6)
0d54: a98d                 dc.w       $a98d
0d56: 4267                 clr.w      -(a7)
0d58: 2f2efffc             move.l     -$4(a6), -(a7)
0d5c: a960                 dc.w       $a960
0d5e: 301f                 move.w     (a7)+, d0
0d60: 4e5e                 unlk       a6
0d62: 4e75                 rts        
0d64: 4e56fff2             link.w     a6, #$fff2
0d68: 2f2e0008             move.l     $8(a6), -(a7)
0d6c: 3f2e000c             move.w     $c(a6), -(a7)
0d70: 486efffa             pea.l      -$6(a6)
0d74: 486efffc             pea.l      -$4(a6)
0d78: 486efff2             pea.l      -$e(a6)
0d7c: a98d                 dc.w       $a98d
0d7e: 202efffc             move.l     -$4(a6), d0
0d82: 4e5e                 unlk       a6
0d84: 4e75                 rts        
0d86: 4e56feee             link.w     a6, #$feee
0d8a: 2f2e0008             move.l     $8(a6), -(a7)
0d8e: 3f2e000c             move.w     $c(a6), -(a7)
0d92: 486efffa             pea.l      -$6(a6)
0d96: 486efffc             pea.l      -$4(a6)
0d9a: 486efff2             pea.l      -$e(a6)
0d9e: a98d                 dc.w       $a98d
0da0: 4aaefffc             tst.l      -$4(a6)
0da4: 6604                 bne.b      $daa
0da6: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0daa: 2f2e000e             move.l     $e(a6), -(a7)
0dae: 486efef2             pea.l      -$10e(a6)
0db2: 4ead07da             jsr        $7da(a5) ; CODE23+00bc
0db6: 2eaefffc             move.l     -$4(a6), (a7)
0dba: 486efef2             pea.l      -$10e(a6)
0dbe: a98f                 dc.w       $a98f
0dc0: 2eae0008             move.l     $8(a6), (a7)
0dc4: 3f2e000c             move.w     $c(a6), -(a7)
0dc8: 102efef2             move.b     -$10e(a6), d0
0dcc: 4880                 ext.w      d0
0dce: 3f00                 move.w     d0, -(a7)
0dd0: 102efef2             move.b     -$10e(a6), d0
0dd4: 4880                 ext.w      d0
0dd6: 3f00                 move.w     d0, -(a7)
0dd8: a97e                 dc.w       $a97e
0dda: 2f2e0008             move.l     $8(a6), -(a7)
0dde: a873                 dc.w       $a873
0de0: 486efff2             pea.l      -$e(a6)
0de4: a928                 dc.w       $a928
0de6: 4e5e                 unlk       a6
0de8: 4e75                 rts        
0dea: 4e56fff2             link.w     a6, #$fff2
0dee: 2f0c                 move.l     a4, -(a7)
0df0: 286e000e             movea.l    $e(a6), a4
0df4: 2f2e0008             move.l     $8(a6), -(a7)
0df8: 3f2e000c             move.w     $c(a6), -(a7)
0dfc: 486efffa             pea.l      -$6(a6)
0e00: 486efffc             pea.l      -$4(a6)
0e04: 486efff2             pea.l      -$e(a6)
0e08: a98d                 dc.w       $a98d
0e0a: 4aaefffc             tst.l      -$4(a6)
0e0e: 6604                 bne.b      $e14
0e10: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0e14: 422c0001             clr.b      $1(a4)
0e18: 4214                 clr.b      (a4)
0e1a: 2f2efffc             move.l     -$4(a6), -(a7)
0e1e: 2f0c                 move.l     a4, -(a7)
0e20: a990                 dc.w       $a990
0e22: 2f0c                 move.l     a4, -(a7)
0e24: 4ead0bea             jsr        $bea(a5) ; CODE34+0020
0e28: 286effee             movea.l    -$12(a6), a4
0e2c: 4e5e                 unlk       a6
0e2e: 4e75                 rts        
0e30: 4e56fffc             link.w     a6, #$fffc
0e34: 4aae0008             tst.l      $8(a6)
0e38: 6714                 beq.b      $e4e
0e3a: 206e0008             movea.l    $8(a6), a0
0e3e: 4a68006c             tst.w      $6c(a0)
0e42: 6c0a                 bge.b      $e4e
0e44: 206e0008             movea.l    $8(a6), a0
0e48: 3028006c             move.w     $6c(a0), d0
0e4c: 6002                 bra.b      $e50
0e4e: 7000                 moveq      #$0, d0
0e50: 4e5e                 unlk       a6
0e52: 4e75                 rts        
0e54: 4e560000             link.w     a6, #$0
0e58: 2f0c                 move.l     a4, -(a7)
0e5a: 286e0008             movea.l    $8(a6), a4
0e5e: 200c                 move.l     a4, d0
0e60: 6716                 beq.b      $e78
0e62: 4a6c006c             tst.w      $6c(a4)
0e66: 6d10                 blt.b      $e78
0e68: 0c6c0008006c         cmpi.w     #$8, $6c(a4)
0e6e: 6c0c                 bge.b      $e7c
0e70: 082c0001006d         btst.b     #$1, $6d(a4)
0e76: 6604                 bne.b      $e7c
0e78: 7000                 moveq      #$0, d0
0e7a: 6002                 bra.b      $e7e
0e7c: 7001                 moveq      #$1, d0
0e7e: 285f                 movea.l    (a7)+, a4
0e80: 4e5e                 unlk       a6
0e82: 4e75                 rts        
0e84: 4e560000             link.w     a6, #$0
0e88: 2f07                 move.l     d7, -(a7)
0e8a: 206e0008             movea.l    $8(a6), a0
0e8e: 3e28006c             move.w     $6c(a0), d7
0e92: 4a47                 tst.w      d7
0e94: 6d06                 blt.b      $e9c
0e96: 08070001             btst.b     #$1, d7
0e9a: 6604                 bne.b      $ea0
0e9c: 7000                 moveq      #$0, d0
0e9e: 6002                 bra.b      $ea2
0ea0: 7001                 moveq      #$1, d0
0ea2: 2e1f                 move.l     (a7)+, d7
0ea4: 4e5e                 unlk       a6
0ea6: 4e75                 rts        
0ea8: 4ebafdda             jsr        $c84(pc)
0eac: 4e75                 rts        
0eae: 4e560000             link.w     a6, #$0
0eb2: 2f0c                 move.l     a4, -(a7)
0eb4: 286e0008             movea.l    $8(a6), a4
0eb8: 4878006c             pea.l      $6c.w
0ebc: 2f0c                 move.l     a4, -(a7)
0ebe: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0ec2: 486dfb70             pea.l      -$490(a5)
0ec6: 4227                 clr.b      -(a7)
0ec8: 4878ffff             pea.l      $ffff.w
0ecc: 48780002             pea.l      $2.w
0ed0: 2f2df248             move.l     -$db8(a5), -(a7)
0ed4: 2f2e000c             move.l     $c(a6), -(a7)
0ed8: 2f0c                 move.l     a4, -(a7)
0eda: 4ead0c12             jsr        $c12(a5) ; CODE46+06d8
0ede: b08c                 cmp.l      a4, d0
0ee0: 4fef0022             lea.l      $22(a7), a7
0ee4: 6704                 beq.b      $eea
0ee6: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0eea: 4a6e0010             tst.w      $10(a6)
0eee: 6708                 beq.b      $ef8
0ef0: 2f0c                 move.l     a4, -(a7)
0ef2: 4ead0c1a             jsr        $c1a(a5) ; CODE46+0742
0ef6: 588f                 addq.l     #$4, a7
0ef8: 200c                 move.l     a4, d0
0efa: 285f                 movea.l    (a7)+, a4
0efc: 4e5e                 unlk       a6
0efe: 4e75                 rts        
0f00: 4e560000             link.w     a6, #$0
0f04: 4aae0008             tst.l      $8(a6)
0f08: 670e                 beq.b      $f18
0f0a: 206e0008             movea.l    $8(a6), a0
0f0e: 4a28006e             tst.b      $6e(a0)
0f12: 6704                 beq.b      $f18
0f14: 7000                 moveq      #$0, d0
0f16: 6002                 bra.b      $f1a
0f18: 7001                 moveq      #$1, d0
0f1a: 4e5e                 unlk       a6
0f1c: 4e75                 rts        
0f1e: 4e56fefe             link.w     a6, #$fefe
0f22: 2f2e0008             move.l     $8(a6), -(a7)
0f26: 486efefe             pea.l      -$102(a6)
0f2a: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0f2e: 486efefe             pea.l      -$102(a6)
0f32: 4ead0bf2             jsr        $bf2(a5) ; CODE34+0004
0f36: 3eae000c             move.w     $c(a6), (a7)
0f3a: 3f2e000e             move.w     $e(a6), -(a7)
0f3e: a893                 dc.w       $a893
0f40: 486efefe             pea.l      -$102(a6)
0f44: a884                 dc.w       $a884
0f46: 4e5e                 unlk       a6
0f48: 4e75                 rts        
0f4a: 4e56fff0             link.w     a6, #$fff0
0f4e: 41eefff0             lea.l      -$10(a6), a0
0f52: 700a                 moveq      #$a, d0
0f54: a030                 dc.w       $a030
0f56: 5240                 addq.w     #$1, d0
0f58: 4a00                 tst.b      d0
0f5a: 67f2                 beq.b      $f4e
0f5c: 4878000a             pea.l      $a.w
0f60: 201f                 move.l     (a7)+, d0
0f62: a032                 dc.w       $a032
0f64: 4e5e                 unlk       a6
0f66: 4e75                 rts        
