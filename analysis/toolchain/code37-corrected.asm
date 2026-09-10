0004: 4e56ffa0             link.w     a6, #$ffa0
0008: 48e70118             movem.l    d7/a3-a4, -(a7)
000c: 3f3c0220             move.w     #$220, -(a7)
0010: 486dbcfe             pea.l      -$4302(a5)
0014: 4ead0d7a             jsr        $d7a(a5) ; CODE54+0004
0018: 4a40                 tst.w      d0
001a: 5c8f                 addq.l     #$6, a7
001c: 6700008c             beq.w      $aa
0020: 486effa0             pea.l      -$60(a6)
0024: 2f2e0008             move.l     $8(a6), -(a7)
0028: 4eba00ac             jsr        $d6(pc)
002c: 3b7c0007bcfc         move.w     #$7, -$4304(a5)
0032: 7022                 moveq      #$22, d0
0034: 2e80                 move.l     d0, (a7)
0036: 486dd60e             pea.l      -$29f2(a5)
003a: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
003e: 7022                 moveq      #$22, d0
0040: 2e80                 move.l     d0, (a7)
0042: 486dd630             pea.l      -$29d0(a5)
0046: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
004a: 206dd5fa             movea.l    -$2a06(a5), a0
004e: 117c00080020         move.b     #$8, $20(a0)
0054: 70ff                 moveq      #$ff, d0
0056: d0add5fa             add.l      -$2a06(a5), d0
005a: 2b40d606             move.l     d0, -$29fa(a5)
005e: 41edbd86             lea.l      -$427a(a5), a0
0062: 2b48d5fe             move.l     a0, -$2a02(a5)
0066: 3ebc0008             move.w     #$8, (a7)
006a: 4eba07e2             jsr        $84e(pc)
006e: 41ed961a             lea.l      -$69e6(a5), a0
0072: 2b48d602             move.l     a0, -$29fe(a5)
0076: 7e00                 moveq      #$0, d7
0078: 49edd148             lea.l      -$2eb8(a5), a4
007c: 4fef0010             lea.l      $10(a7), a7
0080: 2b54d140             move.l     (a4), -$2ec0(a5)
0084: 3b47d548             move.w     d7, -$2ab8(a5)
0088: 204d                 movea.l    a5, a0
008a: 2007                 move.l     d7, d0
008c: 48c0                 ext.l      d0
008e: e788                 lsl.l      #$3, d0
0090: d1c0                 adda.l     d0, a0
0092: 2b68d14cd144         move.l     -$2eb4(a0), -$2ebc(a5)
0098: 6734                 beq.b      $ce
009a: 2f2dd144             move.l     -$2ebc(a5), -(a7)
009e: 4eba01ae             jsr        $24e(pc)
00a2: 588f                 addq.l     #$4, a7
00a4: 5247                 addq.w     #$1, d7
00a6: 508c                 addq.l     #$8, a4
00a8: 60d6                 bra.b      $80
00aa: 7e01                 moveq      #$1, d7
00ac: 47eeffc4             lea.l      -$3c(a6), a3
00b0: 6008                 bra.b      $ba
00b2: 36bcffff             move.w     #$ffff, (a3)
00b6: 5247                 addq.w     #$1, d7
00b8: 548b                 addq.l     #$2, a3
00ba: 0c47001f             cmpi.w     #$1f, d7
00be: 6df2                 blt.b      $b2
00c0: 2f2e0008             move.l     $8(a6), -(a7)
00c4: 486effc2             pea.l      -$3e(a6)
00c8: 4eba06ec             jsr        $7b6(pc)
00cc: 508f                 addq.l     #$8, a7
00ce: 4cdf1880             movem.l    (a7)+, d7/a3-a4
00d2: 4e5e                 unlk       a6
00d4: 4e75                 rts        
00d6: 4e560000             link.w     a6, #$0
00da: 48780080             pea.l      $80.w
00de: 486dce84             pea.l      -$317c(a5)
00e2: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
00e6: 2b6e000cd5fa         move.l     $c(a6), -$2a06(a5)
00ec: 7022                 moveq      #$22, d0
00ee: 2e80                 move.l     d0, (a7)
00f0: 2f2e000c             move.l     $c(a6), -(a7)
00f4: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
00f8: 48780080             pea.l      $80.w
00fc: 486da54e             pea.l      -$5ab2(a5)
0100: 486dd678             pea.l      -$2988(a5)
0104: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0108: 2b6e0008d674         move.l     $8(a6), -$298c(a5)
010e: 4e5e                 unlk       a6
0110: 4e75                 rts        
0112: 4e56fffc             link.w     a6, #$fffc
0116: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
011a: 3f3c0011             move.w     #$11, -(a7)
011e: 486df94e             pea.l      -$6b2(a5)
0122: 4ead0d7a             jsr        $d7a(a5) ; CODE54+0004
0126: 4a40                 tst.w      d0
0128: 5c8f                 addq.l     #$6, a7
012a: 6604                 bne.b      $130
012c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0130: 7801                 moveq      #$1, d4
0132: 49eda99a             lea.l      -$5666(a5), a4
0136: 41edbd0f             lea.l      -$42f1(a5), a0
013a: 2a08                 move.l     a0, d5
013c: 60000100             bra.w      $23e
0140: 0c440001             cmpi.w     #$1, d4
0144: 6706                 beq.b      $14c
0146: 0c440010             cmpi.w     #$10, d4
014a: 6608                 bne.b      $154
014c: 41edf94e             lea.l      -$6b2(a5), a0
0150: 2008                 move.l     a0, d0
0152: 600e                 bra.b      $162
0154: 70ff                 moveq      #$ff, d0
0156: d044                 add.w      d4, d0
0158: c1fc0011             muls.w     #$11, d0
015c: 41edbcfe             lea.l      -$4302(a5), a0
0160: d088                 add.l      a0, d0
0162: 2c00                 move.l     d0, d6
0164: 2b45d5fe             move.l     d5, -$2a02(a5)
0168: 0c44000f             cmpi.w     #$f, d4
016c: 6706                 beq.b      $174
016e: 0c44001e             cmpi.w     #$1e, d4
0172: 6608                 bne.b      $17c
0174: 41edf94e             lea.l      -$6b2(a5), a0
0178: 2008                 move.l     a0, d0
017a: 600e                 bra.b      $18a
017c: 7001                 moveq      #$1, d0
017e: d044                 add.w      d4, d0
0180: c1fc0011             muls.w     #$11, d0
0184: 41edbcfe             lea.l      -$4302(a5), a0
0188: d088                 add.l      a0, d0
018a: 2e00                 move.l     d0, d7
018c: 47ec0004             lea.l      $4(a4), a3
0190: 7601                 moveq      #$1, d3
0192: 60000098             bra.w      $22c
0196: 246dd5fe             movea.l    -$2a02(a5), a2
019a: d4c3                 adda.w     d3, a2
019c: 4a12                 tst.b      (a2)
019e: 6712                 beq.b      $1b2
01a0: 1012                 move.b     (a2), d0
01a2: 4880                 ext.w      d0
01a4: 204d                 movea.l    a5, a0
01a6: 48c0                 ext.l      d0
01a8: e588                 lsl.l      #$2, d0
01aa: d1c0                 adda.l     d0, a0
01ac: 26a89852             move.l     -$67ae(a0), (a3)
01b0: 6076                 bra.b      $228
01b2: 3043                 movea.w    d3, a0
01b4: 4a306800             tst.b      (a0, d6.l)
01b8: 660e                 bne.b      $1c8
01ba: 3043                 movea.w    d3, a0
01bc: 4a307800             tst.b      (a0, d7.l)
01c0: 6606                 bne.b      $1c8
01c2: 70ff                 moveq      #$ff, d0
01c4: 2680                 move.l     d0, (a3)
01c6: 6060                 bra.b      $228
01c8: 486efffc             pea.l      -$4(a6)
01cc: 486efffe             pea.l      -$2(a6)
01d0: 3f03                 move.w     d3, -(a7)
01d2: 3f04                 move.w     d4, -(a7)
01d4: 4ead0922             jsr        $922(a5) ; CODE31+0078
01d8: 7011                 moveq      #$11, d0
01da: c1eefffe             muls.w     -$2(a6), d0
01de: d08d                 add.l      a5, d0
01e0: 346efffc             movea.w    -$4(a6), a2
01e4: 45eabcfd             lea.l      -$4303(a2), a2
01e8: d08a                 add.l      a2, d0
01ea: 2440                 movea.l    d0, a2
01ec: 4fef000c             lea.l      $c(a7), a7
01f0: 6002                 bra.b      $1f4
01f2: 538a                 subq.l     #$1, a2
01f4: 4a12                 tst.b      (a2)
01f6: 66fa                 bne.b      $1f2
01f8: 528a                 addq.l     #$1, a2
01fa: 4293                 clr.l      (a3)
01fc: 206d99d2             movea.l    -$662e(a5), a0
0200: 48680001             pea.l      $1(a0)
0204: 2f0a                 move.l     a2, -(a7)
0206: 4eba01c6             jsr        $3ce(pc)
020a: 2440                 movea.l    d0, a2
020c: 508f                 addq.l     #$8, a7
020e: 6014                 bra.b      $224
0210: 1012                 move.b     (a2), d0
0212: 4880                 ext.w      d0
0214: 204d                 movea.l    a5, a0
0216: 48c0                 ext.l      d0
0218: e588                 lsl.l      #$2, d0
021a: d1c0                 adda.l     d0, a0
021c: 20289852             move.l     -$67ae(a0), d0
0220: 8193                 or.l       d0, (a3)
0222: 528a                 addq.l     #$1, a2
0224: 4a12                 tst.b      (a2)
0226: 66e8                 bne.b      $210
0228: 5243                 addq.w     #$1, d3
022a: 588b                 addq.l     #$4, a3
022c: 0c430010             cmpi.w     #$10, d3
0230: 6d00ff64             blt.w      $196
0234: 5244                 addq.w     #$1, d4
0236: 49ec0044             lea.l      $44(a4), a4
023a: 7011                 moveq      #$11, d0
023c: da80                 add.l      d0, d5
023e: 0c44001f             cmpi.w     #$1f, d4
0242: 6d00fefc             blt.w      $140
0246: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
024a: 4e5e                 unlk       a6
024c: 4e75                 rts        
024e: 4e560000             link.w     a6, #$0
0252: 48e70f18             movem.l    d4-d7/a3-a4, -(a7)
0256: 52add606             addq.l     #$1, -$29fa(a5)
025a: 202e0008             move.l     $8(a6), d0
025e: 52ae0008             addq.l     #$1, $8(a6)
0262: e588                 lsl.l      #$2, d0
0264: d0add140             add.l      -$2ec0(a5), d0
0268: 2040                 movea.l    d0, a0
026a: 2e10                 move.l     (a0), d7
026c: 206dd606             movea.l    -$29fa(a5), a0
0270: 1087                 move.b     d7, (a0)
0272: 1c07                 move.b     d7, d6
0274: 206dd606             movea.l    -$29fa(a5), a0
0278: 7000                 moveq      #$0, d0
027a: 1010                 move.b     (a0), d0
027c: 224d                 movea.l    a5, a1
027e: d3c0                 adda.l     d0, a1
0280: 4a29fbd8             tst.b      -$428(a1)
0284: 6b04                 bmi.b      $28a
0286: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
028a: 1006                 move.b     d6, d0
028c: 4880                 ext.w      d0
028e: 49edd678             lea.l      -$2988(a5), a4
0292: d8c0                 adda.w     d0, a4
0294: 4a14                 tst.b      (a4)
0296: 670000b0             beq.w      $348
029a: 5314                 subq.b     #$1, (a4)
029c: 08070008             btst.b     #$8, d7
02a0: 6700008c             beq.w      $32e
02a4: 202dd606             move.l     -$29fa(a5), d0
02a8: 90add5fa             sub.l      -$2a06(a5), d0
02ac: 7a08                 moveq      #$8, d5
02ae: 9a40                 sub.w      d0, d5
02b0: 6076                 bra.b      $328
02b2: 206dd5fa             movea.l    -$2a06(a5), a0
02b6: 11450021             move.b     d5, $21(a0)
02ba: 206dd5fa             movea.l    -$2a06(a5), a0
02be: 42a80018             clr.l      $18(a0)
02c2: 3805                 move.w     d5, d4
02c4: 266dd5fa             movea.l    -$2a06(a5), a3
02c8: 604c                 bra.b      $316
02ca: 1013                 move.b     (a3), d0
02cc: 4880                 ext.w      d0
02ce: 3f00                 move.w     d0, -(a7)
02d0: 4ead07d2             jsr        $7d2(a5) ; CODE23+0004
02d4: 4a40                 tst.w      d0
02d6: 548f                 addq.l     #$2, a7
02d8: 6738                 beq.b      $312
02da: 204d                 movea.l    a5, a0
02dc: d0c4                 adda.w     d4, a0
02de: 0c2800019609         cmpi.b     #$1, -$69f7(a0)
02e4: 6e24                 bgt.b      $30a
02e6: 204d                 movea.l    a5, a0
02e8: d0c4                 adda.w     d4, a0
02ea: 0c2800019829         cmpi.b     #$1, -$67d7(a0)
02f0: 6e18                 bgt.b      $30a
02f2: 204d                 movea.l    a5, a0
02f4: d0c4                 adda.w     d4, a0
02f6: 0c280001962b         cmpi.b     #$1, -$69d5(a0)
02fc: 6e0c                 bgt.b      $30a
02fe: 204d                 movea.l    a5, a0
0300: d0c4                 adda.w     d4, a0
0302: 0c280001984b         cmpi.b     #$1, -$67b5(a0)
0308: 6f08                 ble.b      $312
030a: 206dd5fa             movea.l    -$2a06(a5), a0
030e: 53a80018             subq.l     #$1, $18(a0)
0312: 528b                 addq.l     #$1, a3
0314: 5244                 addq.w     #$1, d4
0316: 4a13                 tst.b      (a3)
0318: 66b0                 bne.b      $2ca
031a: 4eba0b2a             jsr        $e46(pc)
031e: 206dd5fa             movea.l    -$2a06(a5), a0
0322: 42a80018             clr.l      $18(a0)
0326: 5245                 addq.w     #$1, d5
0328: 0c450008             cmpi.w     #$8, d5
032c: 6f84                 ble.b      $2b2
032e: 2007                 move.l     d7, d0
0330: 720a                 moveq      #$a, d1
0332: e2a8                 lsr.l      d1, d0
0334: 670e                 beq.b      $344
0336: 2007                 move.l     d7, d0
0338: 720a                 moveq      #$a, d1
033a: e2a8                 lsr.l      d1, d0
033c: 2f00                 move.l     d0, -(a7)
033e: 4ebaff0e             jsr        $24e(pc)
0342: 588f                 addq.l     #$4, a7
0344: 5214                 addq.b     #$1, (a4)
0346: 600a                 bra.b      $352
0348: 49edd6b7             lea.l      -$2949(a5), a4
034c: 4a14                 tst.b      (a4)
034e: 6600ff4a             bne.w      $29a
0352: 08070009             btst.b     #$9, d7
0356: 6700ff02             beq.w      $25a
035a: 206dd606             movea.l    -$29fa(a5), a0
035e: 53add606             subq.l     #$1, -$29fa(a5)
0362: 4210                 clr.b      (a0)
0364: 4cdf18f0             movem.l    (a7)+, d4-d7/a3-a4
0368: 4e5e                 unlk       a6
036a: 4e75                 rts        
036c: 4e560000             link.w     a6, #$0
0370: 48e70700             movem.l    d5-d7, -(a7)
0374: 206e0008             movea.l    $8(a6), a0
0378: 1e10                 move.b     (a0), d7
037a: 6606                 bne.b      $382
037c: 202dd144             move.l     -$2ebc(a5), d0
0380: 6044                 bra.b      $3c6
0382: 2c2dd144             move.l     -$2ebc(a5), d6
0386: 2006                 move.l     d6, d0
0388: e588                 lsl.l      #$2, d0
038a: d0add140             add.l      -$2ec0(a5), d0
038e: 2040                 movea.l    d0, a0
0390: 2a10                 move.l     (a0), d5
0392: be05                 cmp.b      d5, d7
0394: 661e                 bne.b      $3b4
0396: 2c05                 move.l     d5, d6
0398: 700a                 moveq      #$a, d0
039a: e0a6                 asr.l      d0, d6
039c: 52ae0008             addq.l     #$1, $8(a6)
03a0: 206e0008             movea.l    $8(a6), a0
03a4: 1e10                 move.b     (a0), d7
03a6: 6604                 bne.b      $3ac
03a8: 2006                 move.l     d6, d0
03aa: 601a                 bra.b      $3c6
03ac: 4a86                 tst.l      d6
03ae: 66d6                 bne.b      $386
03b0: 70ff                 moveq      #$ff, d0
03b2: 6012                 bra.b      $3c6
03b4: 08050009             btst.b     #$9, d5
03b8: 6604                 bne.b      $3be
03ba: be05                 cmp.b      d5, d7
03bc: 6c04                 bge.b      $3c2
03be: 70ff                 moveq      #$ff, d0
03c0: 6004                 bra.b      $3c6
03c2: 5286                 addq.l     #$1, d6
03c4: 60c0                 bra.b      $386
03c6: 4cdf00e0             movem.l    (a7)+, d5-d7
03ca: 4e5e                 unlk       a6
03cc: 4e75                 rts        
03ce: 4e56fff2             link.w     a6, #$fff2
03d2: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
03d6: 266e0008             movea.l    $8(a6), a3
03da: 246e000c             movea.l    $c(a6), a2
03de: 2d4bfffc             move.l     a3, -$4(a6)
03e2: 2d4afff8             move.l     a2, -$8(a6)
03e6: 49edf90e             lea.l      -$6f2(a5), a4
03ea: 426efff6             clr.w      -$a(a6)
03ee: 41edd148             lea.l      -$2eb8(a5), a0
03f2: 2d48fff2             move.l     a0, -$e(a6)
03f6: 206efff2             movea.l    -$e(a6), a0
03fa: 2b50d140             move.l     (a0), -$2ec0(a5)
03fe: 302efff6             move.w     -$a(a6), d0
0402: 3b40d548             move.w     d0, -$2ab8(a5)
0406: 224d                 movea.l    a5, a1
0408: 48c0                 ext.l      d0
040a: e788                 lsl.l      #$3, d0
040c: d3c0                 adda.l     d0, a1
040e: 2b69d14cd144         move.l     -$2eb4(a1), -$2ebc(a5)
0414: 670000b4             beq.w      $4ca
0418: 266efffc             movea.l    -$4(a6), a3
041c: 246efff8             movea.l    -$8(a6), a2
0420: 2f0b                 move.l     a3, -(a7)
0422: 4ebaff48             jsr        $36c(pc)
0426: 2c00                 move.l     d0, d6
0428: 4a86                 tst.l      d6
042a: 588f                 addq.l     #$4, a7
042c: 6f000090             ble.w      $4be
0430: 4a1b                 tst.b      (a3)+
0432: 66fc                 bne.b      $430
0434: 2006                 move.l     d6, d0
0436: e588                 lsl.l      #$2, d0
0438: d0add140             add.l      -$2ec0(a5), d0
043c: 2040                 movea.l    d0, a0
043e: 2610                 move.l     (a0), d3
0440: 1812                 move.b     (a2), d4
0442: b803                 cmp.b      d3, d4
0444: 6c04                 bge.b      $44a
0446: 528a                 addq.l     #$1, a2
0448: 6070                 bra.b      $4ba
044a: b803                 cmp.b      d3, d4
044c: 6658                 bne.b      $4a6
044e: 4a13                 tst.b      (a3)
0450: 660a                 bne.b      $45c
0452: 08030008             btst.b     #$8, d3
0456: 674c                 beq.b      $4a4
0458: 18c3                 move.b     d3, (a4)+
045a: 6048                 bra.b      $4a4
045c: 2803                 move.l     d3, d4
045e: 700a                 moveq      #$a, d0
0460: e0ac                 lsr.l      d0, d4
0462: 6740                 beq.b      $4a4
0464: 2e0b                 move.l     a3, d7
0466: 2004                 move.l     d4, d0
0468: e588                 lsl.l      #$2, d0
046a: d0add140             add.l      -$2ec0(a5), d0
046e: 2040                 movea.l    d0, a0
0470: 2a10                 move.l     (a0), d5
0472: 2047                 movea.l    d7, a0
0474: ba10                 cmp.b      (a0), d5
0476: 661c                 bne.b      $494
0478: 5287                 addq.l     #$1, d7
047a: 2047                 movea.l    d7, a0
047c: 4a10                 tst.b      (a0)
047e: 660a                 bne.b      $48a
0480: 08050008             btst.b     #$8, d5
0484: 671e                 beq.b      $4a4
0486: 18c3                 move.b     d3, (a4)+
0488: 601a                 bra.b      $4a4
048a: 2805                 move.l     d5, d4
048c: 700a                 moveq      #$a, d0
048e: e0ac                 lsr.l      d0, d4
0490: 6712                 beq.b      $4a4
0492: 60d2                 bra.b      $466
0494: 08050009             btst.b     #$9, d5
0498: 660a                 bne.b      $4a4
049a: 2047                 movea.l    d7, a0
049c: ba10                 cmp.b      (a0), d5
049e: 6e04                 bgt.b      $4a4
04a0: 5284                 addq.l     #$1, d4
04a2: 60c2                 bra.b      $466
04a4: 528a                 addq.l     #$1, a2
04a6: 08030009             btst.b     #$9, d3
04aa: 6612                 bne.b      $4be
04ac: 5286                 addq.l     #$1, d6
04ae: 2006                 move.l     d6, d0
04b0: e588                 lsl.l      #$2, d0
04b2: d0add140             add.l      -$2ec0(a5), d0
04b6: 2040                 movea.l    d0, a0
04b8: 2610                 move.l     (a0), d3
04ba: 4a12                 tst.b      (a2)
04bc: 6682                 bne.b      $440
04be: 526efff6             addq.w     #$1, -$a(a6)
04c2: 50aefff2             addq.l     #$8, -$e(a6)
04c6: 6000ff2e             bra.w      $3f6
04ca: 4214                 clr.b      (a4)
04cc: 41edf90e             lea.l      -$6f2(a5), a0
04d0: 2008                 move.l     a0, d0
04d2: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
04d6: 4e5e                 unlk       a6
04d8: 4e75                 rts        
04da: 4e560000             link.w     a6, #$0
04de: 204d                 movea.l    a5, a0
04e0: 302e000a             move.w     $a(a6), d0
04e4: 48c0                 ext.l      d0
04e6: e588                 lsl.l      #$2, d0
04e8: d1c0                 adda.l     d0, a0
04ea: 224d                 movea.l    a5, a1
04ec: 302e0008             move.w     $8(a6), d0
04f0: 48c0                 ext.l      d0
04f2: e588                 lsl.l      #$2, d0
04f4: d3c0                 adda.l     d0, a1
04f6: 70ff                 moveq      #$ff, d0
04f8: d0a999d6             add.l      -$662a(a1), d0
04fc: 4680                 not.l      d0
04fe: 72ff                 moveq      #$ff, d1
0500: d2a899da             add.l      -$6626(a0), d1
0504: c081                 and.l      d1, d0
0506: 4e5e                 unlk       a6
0508: 4e75                 rts        
050a: 4e560000             link.w     a6, #$0
050e: 48e70308             movem.l    d6-d7/a4, -(a7)
0512: 3c2e000a             move.w     $a(a6), d6
0516: 7011                 moveq      #$11, d0
0518: c1ee0008             muls.w     $8(a6), d0
051c: 49edbcfe             lea.l      -$4302(a5), a4
0520: d08c                 add.l      a4, d0
0522: 2840                 movea.l    d0, a4
0524: 7e00                 moveq      #$0, d7
0526: 600a                 bra.b      $532
0528: 4a346000             tst.b      (a4, d6.w)
052c: 6602                 bne.b      $530
052e: 5247                 addq.w     #$1, d7
0530: 5346                 subq.w     #$1, d6
0532: 4a46                 tst.w      d6
0534: 6706                 beq.b      $53c
0536: be6e000c             cmp.w      $c(a6), d7
053a: 6dec                 blt.b      $528
053c: 7001                 moveq      #$1, d0
053e: d046                 add.w      d6, d0
0540: 4cdf10c0             movem.l    (a7)+, d6-d7/a4
0544: 4e5e                 unlk       a6
0546: 4e75                 rts        
0548: 4e56ffa8             link.w     a6, #$ffa8
054c: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0550: 286e0008             movea.l    $8(a6), a4
0554: 2f2e0014             move.l     $14(a6), -(a7)
0558: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
055c: 3a00                 move.w     d0, d5
055e: 0c450007             cmpi.w     #$7, d5
0562: 588f                 addq.l     #$4, a7
0564: 6f02                 ble.b      $568
0566: 7a07                 moveq      #$7, d5
0568: 182c0021             move.b     $21(a4), d4
056c: 4884                 ext.w      d4
056e: 1c2c0020             move.b     $20(a4), d6
0572: 4886                 ext.w      d6
0574: 7011                 moveq      #$11, d0
0576: c1c6                 muls.w     d6, d0
0578: 41edbcfe             lea.l      -$4302(a5), a0
057c: d088                 add.l      a0, d0
057e: 3044                 movea.w    d4, a0
0580: d088                 add.l      a0, d0
0582: 2d40ffb0             move.l     d0, -$50(a6)
0586: 4878003e             pea.l      $3e.w
058a: 486effc0             pea.l      -$40(a6)
058e: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0592: 7eff                 moveq      #$ff, d7
0594: de44                 add.w      d4, d7
0596: 2e8c                 move.l     a4, (a7)
0598: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
059c: d044                 add.w      d4, d0
059e: 3e80                 move.w     d0, (a7)
05a0: 3f05                 move.w     d5, -(a7)
05a2: 3f07                 move.w     d7, -(a7)
05a4: 3f06                 move.w     d6, -(a7)
05a6: 4ebaff62             jsr        $50a(pc)
05aa: 588f                 addq.l     #$4, a7
05ac: 3e80                 move.w     d0, (a7)
05ae: 4ebaff2a             jsr        $4da(pc)
05b2: 204e                 movea.l    a6, a0
05b4: d0c6                 adda.w     d6, a0
05b6: 817060c0             or.w       d0, -$40(a0, d6.w)
05ba: 0c440001             cmpi.w     #$1, d4
05be: 4fef000a             lea.l      $a(a7), a7
05c2: 673a                 beq.b      $5fe
05c4: 486effb8             pea.l      -$48(a6)
05c8: 486effba             pea.l      -$46(a6)
05cc: 3f07                 move.w     d7, -(a7)
05ce: 3f06                 move.w     d6, -(a7)
05d0: 4ead0922             jsr        $922(a5) ; CODE31+0078
05d4: 3eaeffb8             move.w     -$48(a6), (a7)
05d8: 3f05                 move.w     d5, -(a7)
05da: 3f2effb8             move.w     -$48(a6), -(a7)
05de: 3f2effba             move.w     -$46(a6), -(a7)
05e2: 4ebaff26             jsr        $50a(pc)
05e6: 588f                 addq.l     #$4, a7
05e8: 3e80                 move.w     d0, (a7)
05ea: 4ebafeee             jsr        $4da(pc)
05ee: 322effba             move.w     -$46(a6), d1
05f2: 48c1                 ext.l      d1
05f4: d281                 add.l      d1, d1
05f6: 817618c0             or.w       d0, -$40(a6, d1.l)
05fa: 4fef000e             lea.l      $e(a7), a7
05fe: 2d4cffa8             move.l     a4, -$58(a6)
0602: 7e01                 moveq      #$1, d7
0604: de46                 add.w      d6, d7
0606: 7002                 moveq      #$2, d0
0608: d045                 add.w      d5, d0
060a: 3d40ffae             move.w     d0, -$52(a6)
060e: 72ff                 moveq      #$ff, d1
0610: d246                 add.w      d6, d1
0612: 3d41ffac             move.w     d1, -$54(a6)
0616: 60000102             bra.w      $71a
061a: 206effb0             movea.l    -$50(a6), a0
061e: 4a10                 tst.b      (a0)
0620: 660000ee             bne.w      $710
0624: 4a44                 tst.w      d4
0626: 6f06                 ble.b      $62e
0628: 0c440010             cmpi.w     #$10, d4
062c: 6d04                 blt.b      $632
062e: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0632: 3607                 move.w     d7, d3
0634: 45f630c0             lea.l      -$40(a6, d3.w), a2
0638: d4c3                 adda.w     d3, a2
063a: 7011                 moveq      #$11, d0
063c: c1c3                 muls.w     d3, d0
063e: 47edbcfe             lea.l      -$4302(a5), a3
0642: d08b                 add.l      a3, d0
0644: 2640                 movea.l    d0, a3
0646: 6028                 bra.b      $670
0648: 4a334000             tst.b      (a3, d4.w)
064c: 661a                 bne.b      $668
064e: 3f04                 move.w     d4, -(a7)
0650: 3f05                 move.w     d5, -(a7)
0652: 3f04                 move.w     d4, -(a7)
0654: 3f03                 move.w     d3, -(a7)
0656: 4ebafeb2             jsr        $50a(pc)
065a: 588f                 addq.l     #$4, a7
065c: 3e80                 move.w     d0, (a7)
065e: 4ebafe7a             jsr        $4da(pc)
0662: 8152                 or.w       d0, (a2)
0664: 588f                 addq.l     #$4, a7
0666: 6014                 bra.b      $67c
0668: 5243                 addq.w     #$1, d3
066a: 548a                 addq.l     #$2, a2
066c: 47eb0011             lea.l      $11(a3), a3
0670: 0c43001f             cmpi.w     #$1f, d3
0674: 6706                 beq.b      $67c
0676: 0c430010             cmpi.w     #$10, d3
067a: 66cc                 bne.b      $648
067c: 0c43001f             cmpi.w     #$1f, d3
0680: 6706                 beq.b      $688
0682: 0c430010             cmpi.w     #$10, d3
0686: 6602                 bne.b      $68a
0688: 5343                 subq.w     #$1, d3
068a: 486effb8             pea.l      -$48(a6)
068e: 486effba             pea.l      -$46(a6)
0692: 3f04                 move.w     d4, -(a7)
0694: 3f03                 move.w     d3, -(a7)
0696: 4ead0922             jsr        $922(a5) ; CODE31+0078
069a: 3eaeffb8             move.w     -$48(a6), (a7)
069e: 3f2effae             move.w     -$52(a6), -(a7)
06a2: 3f2effb8             move.w     -$48(a6), -(a7)
06a6: 3f2effba             move.w     -$46(a6), -(a7)
06aa: 4ebafe5e             jsr        $50a(pc)
06ae: 588f                 addq.l     #$4, a7
06b0: 3e80                 move.w     d0, (a7)
06b2: 4ebafe26             jsr        $4da(pc)
06b6: 322effba             move.w     -$46(a6), d1
06ba: 48c1                 ext.l      d1
06bc: d281                 add.l      d1, d1
06be: 817618c0             or.w       d0, -$40(a6, d1.l)
06c2: 362effac             move.w     -$54(a6), d3
06c6: 45f630c0             lea.l      -$40(a6, d3.w), a2
06ca: d4c3                 adda.w     d3, a2
06cc: 7011                 moveq      #$11, d0
06ce: c1c3                 muls.w     d3, d0
06d0: 47edbcfe             lea.l      -$4302(a5), a3
06d4: d08b                 add.l      a3, d0
06d6: 2640                 movea.l    d0, a3
06d8: 4fef000e             lea.l      $e(a7), a7
06dc: 6028                 bra.b      $706
06de: 4a334000             tst.b      (a3, d4.w)
06e2: 661a                 bne.b      $6fe
06e4: 3f04                 move.w     d4, -(a7)
06e6: 3f05                 move.w     d5, -(a7)
06e8: 3f04                 move.w     d4, -(a7)
06ea: 3f03                 move.w     d3, -(a7)
06ec: 4ebafe1c             jsr        $50a(pc)
06f0: 588f                 addq.l     #$4, a7
06f2: 3e80                 move.w     d0, (a7)
06f4: 4ebafde4             jsr        $4da(pc)
06f8: 8152                 or.w       d0, (a2)
06fa: 588f                 addq.l     #$4, a7
06fc: 6012                 bra.b      $710
06fe: 5343                 subq.w     #$1, d3
0700: 558a                 subq.l     #$2, a2
0702: 47ebffef             lea.l      -$11(a3), a3
0706: 4a43                 tst.w      d3
0708: 6706                 beq.b      $710
070a: 0c43000f             cmpi.w     #$f, d3
070e: 66ce                 bne.b      $6de
0710: 52aeffb0             addq.l     #$1, -$50(a6)
0714: 52aeffa8             addq.l     #$1, -$58(a6)
0718: 5244                 addq.w     #$1, d4
071a: 206effa8             movea.l    -$58(a6), a0
071e: 4a10                 tst.b      (a0)
0720: 6600fef8             bne.w      $61a
0724: 0c440010             cmpi.w     #$10, d4
0728: 673a                 beq.b      $764
072a: 486effb8             pea.l      -$48(a6)
072e: 486effba             pea.l      -$46(a6)
0732: 3f04                 move.w     d4, -(a7)
0734: 3f06                 move.w     d6, -(a7)
0736: 4ead0922             jsr        $922(a5) ; CODE31+0078
073a: 3eaeffb8             move.w     -$48(a6), (a7)
073e: 3f05                 move.w     d5, -(a7)
0740: 3f2effb8             move.w     -$48(a6), -(a7)
0744: 3f2effba             move.w     -$46(a6), -(a7)
0748: 4ebafdc0             jsr        $50a(pc)
074c: 588f                 addq.l     #$4, a7
074e: 3e80                 move.w     d0, (a7)
0750: 4ebafd88             jsr        $4da(pc)
0754: 322effba             move.w     -$46(a6), d1
0758: 48c1                 ext.l      d1
075a: d281                 add.l      d1, d1
075c: 817618c0             or.w       d0, -$40(a6, d1.l)
0760: 4fef000e             lea.l      $e(a7), a7
0764: 2f2e000c             move.l     $c(a6), -(a7)
0768: 4ead096a             jsr        $96a(a5) ; CODE31+0992
076c: 4257                 clr.w      (a7)
076e: 2f2e000c             move.l     $c(a6), -(a7)
0772: 2f0c                 move.l     a4, -(a7)
0774: 4ead0942             jsr        $942(a5) ; CODE31+0184
0778: 2eae0014             move.l     $14(a6), (a7)
077c: 4ead096a             jsr        $96a(a5) ; CODE31+0992
0780: 3ebc0011             move.w     #$11, (a7)
0784: 486df94e             pea.l      -$6b2(a5)
0788: 4ead0d7a             jsr        $d7a(a5) ; CODE54+0004
078c: 4a40                 tst.w      d0
078e: 4fef0010             lea.l      $10(a7), a7
0792: 6604                 bne.b      $798
0794: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0798: 2f2e0010             move.l     $10(a6), -(a7)
079c: 486effc0             pea.l      -$40(a6)
07a0: 4eba0014             jsr        $7b6(pc)
07a4: 2eae000c             move.l     $c(a6), (a7)
07a8: 4ead094a             jsr        $94a(a5) ; CODE31+0642
07ac: 4cee1cf8ff88         movem.l    -$78(a6), d3-d7/a2-a4
07b2: 4e5e                 unlk       a6
07b4: 4e75                 rts        
07b6: 4e56ffbe             link.w     a6, #$ffbe
07ba: 48e70308             movem.l    d6-d7/a4, -(a7)
07be: 4eba066e             jsr        $e2e(pc)
07c2: 486effbe             pea.l      -$42(a6)
07c6: 2f2e000c             move.l     $c(a6), -(a7)
07ca: 4ebaf90a             jsr        $d6(pc)
07ce: 486effe0             pea.l      -$20(a6)
07d2: 4eba05b2             jsr        $d86(pc)
07d6: 2e00                 move.l     d0, d7
07d8: 7c00                 moveq      #$0, d6
07da: 99cc                 suba.l     a4, a4
07dc: 4fef000c             lea.l      $c(a7), a7
07e0: 601c                 bra.b      $7fe
07e2: 204c                 movea.l    a4, a0
07e4: d1ee0008             adda.l     $8(a6), a0
07e8: 3f10                 move.w     (a0), -(a7)
07ea: 486effe0             pea.l      -$20(a6)
07ee: 2f07                 move.l     d7, -(a7)
07f0: 3f06                 move.w     d6, -(a7)
07f2: 4eba0198             jsr        $98c(pc)
07f6: 4fef000c             lea.l      $c(a7), a7
07fa: 5246                 addq.w     #$1, d6
07fc: 548c                 addq.l     #$2, a4
07fe: 0c46001f             cmpi.w     #$1f, d6
0802: 6dde                 blt.b      $7e2
0804: 4cdf10c0             movem.l    (a7)+, d6-d7/a4
0808: 4e5e                 unlk       a6
080a: 4e75                 rts        
080c: 4e560000             link.w     a6, #$0
0810: 48e70138             movem.l    d7/a2-a4, -(a7)
0814: 7011                 moveq      #$11, d0
0816: c1ee0008             muls.w     $8(a6), d0
081a: 2840                 movea.l    d0, a4
081c: 47edbcfe             lea.l      -$4302(a5), a3
0820: d7cc                 adda.l     a4, a3
0822: 528b                 addq.l     #$1, a3
0824: 45ed97b2             lea.l      -$684e(a5), a2
0828: d5cc                 adda.l     a4, a2
082a: 528a                 addq.l     #$1, a2
082c: 6012                 bra.b      $840
082e: 4a13                 tst.b      (a3)
0830: 660a                 bne.b      $83c
0832: 0c070001             cmpi.b     #$1, d7
0836: 6704                 beq.b      $83c
0838: 7000                 moveq      #$0, d0
083a: 600a                 bra.b      $846
083c: 528b                 addq.l     #$1, a3
083e: 528a                 addq.l     #$1, a2
0840: 1e12                 move.b     (a2), d7
0842: 66ea                 bne.b      $82e
0844: 7001                 moveq      #$1, d0
0846: 4cdf1c80             movem.l    (a7)+, d7/a2-a4
084a: 4e5e                 unlk       a6
084c: 4e75                 rts        
084e: 4e56fff2             link.w     a6, #$fff2
0852: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0856: 3a2e0008             move.w     $8(a6), d5
085a: 7011                 moveq      #$11, d0
085c: c1c5                 muls.w     d5, d0
085e: 41ed97b2             lea.l      -$684e(a5), a0
0862: d088                 add.l      a0, d0
0864: 2d40fff8             move.l     d0, -$8(a6)
0868: 204d                 movea.l    a5, a0
086a: d0c5                 adda.w     d5, a0
086c: 4a28f92e             tst.b      -$6d2(a0)
0870: 660c                 bne.b      $87e
0872: 3f05                 move.w     d5, -(a7)
0874: 4ebaff96             jsr        $80c(pc)
0878: 4a40                 tst.w      d0
087a: 548f                 addq.l     #$2, a7
087c: 6716                 beq.b      $894
087e: 47eda14c             lea.l      -$5eb4(a5), a3
0882: 45ed9f4e             lea.l      -$60b2(a5), a2
0886: 6006                 bra.b      $88e
0888: 34bc0001             move.w     #$1, (a2)
088c: 548a                 addq.l     #$2, a2
088e: b7ca                 cmpa.l     a2, a3
0890: 62f6                 bhi.b      $888
0892: 607c                 bra.b      $910
0894: 45ed9f2c             lea.l      -$60d4(a5), a2
0898: 7601                 moveq      #$1, d3
089a: 7011                 moveq      #$11, d0
089c: c1c5                 muls.w     d5, d0
089e: 41edbcfe             lea.l      -$4302(a5), a0
08a2: d088                 add.l      a0, d0
08a4: 2d40fffc             move.l     d0, -$4(a6)
08a8: 7222                 moveq      #$22, d1
08aa: c3c3                 muls.w     d3, d1
08ac: 41ed9f2c             lea.l      -$60d4(a5), a0
08b0: d288                 add.l      a0, d1
08b2: 2d41fff2             move.l     d1, -$e(a6)
08b6: 6052                 bra.b      $90a
08b8: 264a                 movea.l    a2, a3
08ba: 246efff2             movea.l    -$e(a6), a2
08be: 206efffc             movea.l    -$4(a6), a0
08c2: 41f030ff             lea.l      -$1(a0, d3.w), a0
08c6: 2808                 move.l     a0, d4
08c8: 7c00                 moveq      #$0, d6
08ca: 99cc                 suba.l     a4, a4
08cc: 3006                 move.w     d6, d0
08ce: d043                 add.w      d3, d0
08d0: 3d40fff6             move.w     d0, -$a(a6)
08d4: 0c400011             cmpi.w     #$11, d0
08d8: 6428                 bcc.b      $902
08da: 204b                 movea.l    a3, a0
08dc: d1cc                 adda.l     a4, a0
08de: 3e10                 move.w     (a0), d7
08e0: 2044                 movea.l    d4, a0
08e2: 4a10                 tst.b      (a0)
08e4: 660e                 bne.b      $8f4
08e6: 306efff6             movea.w    -$a(a6), a0
08ea: d1eefff8             adda.l     -$8(a6), a0
08ee: 1020                 move.b     -(a0), d0
08f0: 4880                 ext.w      d0
08f2: cfc0                 muls.w     d0, d7
08f4: 204a                 movea.l    a2, a0
08f6: d1cc                 adda.l     a4, a0
08f8: 3087                 move.w     d7, (a0)
08fa: 5246                 addq.w     #$1, d6
08fc: 548c                 addq.l     #$2, a4
08fe: 5284                 addq.l     #$1, d4
0900: 60ca                 bra.b      $8cc
0902: 5243                 addq.w     #$1, d3
0904: 7022                 moveq      #$22, d0
0906: d1aefff2             add.l      d0, -$e(a6)
090a: 0c430010             cmpi.w     #$10, d3
090e: 65a8                 bcs.b      $8b8
0910: 3f05                 move.w     d5, -(a7)
0912: 4eba000c             jsr        $920(pc)
0916: 4cee1cf8ffd2         movem.l    -$2e(a6), d3-d7/a2-a4
091c: 4e5e                 unlk       a6
091e: 4e75                 rts        
0920: 4e560000             link.w     a6, #$0
0924: 48e70138             movem.l    d7/a2-a4, -(a7)
0928: 49edd652             lea.l      -$29ae(a5), a4
092c: 47edd654             lea.l      -$29ac(a5), a3
0930: 7022                 moveq      #$22, d0
0932: c1ee0008             muls.w     $8(a6), d0
0936: 45edbf1e             lea.l      -$40e2(a5), a2
093a: d08a                 add.l      a2, d0
093c: 2440                 movea.l    d0, a2
093e: 41edd674             lea.l      -$298c(a5), a0
0942: 2e08                 move.l     a0, d7
0944: 600c                 bra.b      $952
0946: 3014                 move.w     (a4), d0
0948: d052                 add.w      (a2), d0
094a: 3680                 move.w     d0, (a3)
094c: 548c                 addq.l     #$2, a4
094e: 548b                 addq.l     #$2, a3
0950: 548a                 addq.l     #$2, a2
0952: be8b                 cmp.l      a3, d7
0954: 62f0                 bhi.b      $946
0956: 47edd60e             lea.l      -$29f2(a5), a3
095a: 284b                 movea.l    a3, a4
095c: 548b                 addq.l     #$2, a3
095e: 45edd630             lea.l      -$29d0(a5), a2
0962: 6008                 bra.b      $96c
0964: 3014                 move.w     (a4), d0
0966: d153                 add.w      d0, (a3)
0968: 548c                 addq.l     #$2, a4
096a: 548b                 addq.l     #$2, a3
096c: b5cb                 cmpa.l     a3, a2
096e: 62f4                 bhi.b      $964
0970: 45edd60e             lea.l      -$29f2(a5), a2
0974: 558b                 subq.l     #$2, a3
0976: 558c                 subq.l     #$2, a4
0978: 6006                 bra.b      $980
097a: 3694                 move.w     (a4), (a3)
097c: 558c                 subq.l     #$2, a4
097e: 558b                 subq.l     #$2, a3
0980: b5cc                 cmpa.l     a4, a2
0982: 63f6                 bls.b      $97a
0984: 4cdf1c80             movem.l    (a7)+, d7/a2-a4
0988: 4e5e                 unlk       a6
098a: 4e75                 rts        
098c: 4e56ff8c             link.w     a6, #$ff8c
0990: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0994: 3a2e0008             move.w     $8(a6), d5
0998: 4a6e0012             tst.w      $12(a6)
099c: 670003e0             beq.w      $d7e
09a0: 48780022             pea.l      $22.w
09a4: 486dd60e             pea.l      -$29f2(a5)
09a8: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
09ac: 7022                 moveq      #$22, d0
09ae: 2e80                 move.l     d0, (a7)
09b0: 486dd630             pea.l      -$29d0(a5)
09b4: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
09b8: 7044                 moveq      #$44, d0
09ba: 2e80                 move.l     d0, (a7)
09bc: 486effb8             pea.l      -$48(a6)
09c0: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
09c4: 7011                 moveq      #$11, d0
09c6: 2e80                 move.l     d0, (a7)
09c8: 7011                 moveq      #$11, d0
09ca: c1c5                 muls.w     d5, d0
09cc: 204d                 movea.l    a5, a0
09ce: d1c0                 adda.l     d0, a0
09d0: 48689592             pea.l      -$6a6e(a0)
09d4: 486effa6             pea.l      -$5a(a6)
09d8: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
09dc: 41eeffa6             lea.l      -$5a(a6), a0
09e0: 2b48d602             move.l     a0, -$29fe(a5)
09e4: 426eff92             clr.w      -$6e(a6)
09e8: 7c11                 moveq      #$11, d6
09ea: cdc5                 muls.w     d5, d6
09ec: 43edbcfe             lea.l      -$4302(a5), a1
09f0: dc89                 add.l      a1, d6
09f2: 2b46d5fe             move.l     d6, -$2a02(a5)
09f6: 0c450001             cmpi.w     #$1, d5
09fa: 4fef0018             lea.l      $18(a7), a7
09fe: 6706                 beq.b      $a06
0a00: 0c450010             cmpi.w     #$10, d5
0a04: 6608                 bne.b      $a0e
0a06: 41edf94e             lea.l      -$6b2(a5), a0
0a0a: 2008                 move.l     a0, d0
0a0c: 600e                 bra.b      $a1c
0a0e: 70ff                 moveq      #$ff, d0
0a10: d045                 add.w      d5, d0
0a12: c1fc0011             muls.w     #$11, d0
0a16: 41edbcfe             lea.l      -$4302(a5), a0
0a1a: d088                 add.l      a0, d0
0a1c: 2840                 movea.l    d0, a4
0a1e: 0c45000f             cmpi.w     #$f, d5
0a22: 6706                 beq.b      $a2a
0a24: 0c45001e             cmpi.w     #$1e, d5
0a28: 6608                 bne.b      $a32
0a2a: 41edf94e             lea.l      -$6b2(a5), a0
0a2e: 2008                 move.l     a0, d0
0a30: 600e                 bra.b      $a40
0a32: 7001                 moveq      #$1, d0
0a34: d045                 add.w      d5, d0
0a36: c1fc0011             muls.w     #$11, d0
0a3a: 41edbcfe             lea.l      -$4302(a5), a0
0a3e: d088                 add.l      a0, d0
0a40: 2d40ff9a             move.l     d0, -$66(a6)
0a44: 47eeffb8             lea.l      -$48(a6), a3
0a48: 7601                 moveq      #$1, d3
0a4a: 7211                 moveq      #$11, d1
0a4c: c3c5                 muls.w     d5, d1
0a4e: 41ed97b2             lea.l      -$684e(a5), a0
0a52: d288                 add.l      a0, d1
0a54: 2d41ff8e             move.l     d1, -$72(a6)
0a58: 3043                 movea.w    d3, a0
0a5a: d1c8                 adda.l     a0, a0
0a5c: 2d48ff96             move.l     a0, -$6a(a6)
0a60: 43edd60e             lea.l      -$29f2(a5), a1
0a64: d3c8                 adda.l     a0, a1
0a66: 2d49ff9e             move.l     a1, -$62(a6)
0a6a: 43edd630             lea.l      -$29d0(a5), a1
0a6e: d3c8                 adda.l     a0, a1
0a70: 2d49ffa2             move.l     a1, -$5e(a6)
0a74: 2403                 move.l     d3, d2
0a76: 48c2                 ext.l      d2
0a78: e58a                 lsl.l      #$2, d2
0a7a: 41f628b8             lea.l      -$48(a6, d2.l), a0
0a7e: 2d48ff96             move.l     a0, -$6a(a6)
0a82: 6000014a             bra.w      $bce
0a86: 588b                 addq.l     #$4, a3
0a88: b7eeff96             cmpa.l     -$6a(a6), a3
0a8c: 6704                 beq.b      $a92
0a8e: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0a92: 206dd5fe             movea.l    -$2a02(a5), a0
0a96: 18303000             move.b     (a0, d3.w), d4
0a9a: 4884                 ext.w      d4
0a9c: 4a44                 tst.w      d4
0a9e: 6718                 beq.b      $ab8
0aa0: 204d                 movea.l    a5, a0
0aa2: 2004                 move.l     d4, d0
0aa4: 48c0                 ext.l      d0
0aa6: e588                 lsl.l      #$2, d0
0aa8: d1c0                 adda.l     d0, a0
0aaa: 26a89852             move.l     -$67ae(a0), (a3)
0aae: 3d7c0001ff92         move.w     #$1, -$6e(a6)
0ab4: 6000010a             bra.w      $bc0
0ab8: 4a343000             tst.b      (a4, d3.w)
0abc: 6612                 bne.b      $ad0
0abe: 206eff9a             movea.l    -$66(a6), a0
0ac2: 4a303000             tst.b      (a0, d3.w)
0ac6: 6608                 bne.b      $ad0
0ac8: 26ae000a             move.l     $a(a6), (a3)
0acc: 600000f2             bra.w      $bc0
0ad0: 486efffc             pea.l      -$4(a6)
0ad4: 486efffe             pea.l      -$2(a6)
0ad8: 3f03                 move.w     d3, -(a7)
0ada: 3f05                 move.w     d5, -(a7)
0adc: 4ead0922             jsr        $922(a5) ; CODE31+0078
0ae0: 3eaefffc             move.w     -$4(a6), (a7)
0ae4: 3f2efffe             move.w     -$2(a6), -(a7)
0ae8: 4ead091a             jsr        $91a(a5) ; CODE31+004c
0aec: 2440                 movea.l    d0, a2
0aee: 7011                 moveq      #$11, d0
0af0: c1eefffe             muls.w     -$2(a6), d0
0af4: d08d                 add.l      a5, d0
0af6: 306efffc             movea.w    -$4(a6), a0
0afa: 41e8bcfe             lea.l      -$4302(a0), a0
0afe: d088                 add.l      a0, d0
0b00: b08a                 cmp.l      a2, d0
0b02: 4fef000e             lea.l      $e(a7), a7
0b06: 6604                 bne.b      $b0c
0b08: 4a12                 tst.b      (a2)
0b0a: 670e                 beq.b      $b1a
0b0c: 4a12                 tst.b      (a2)
0b0e: 6706                 beq.b      $b16
0b10: 4a2affff             tst.b      -$1(a2)
0b14: 6704                 beq.b      $b1a
0b16: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0b1a: 2f2e000e             move.l     $e(a6), -(a7)
0b1e: 2f0a                 move.l     a2, -(a7)
0b20: 4ebaf8ac             jsr        $3ce(pc)
0b24: 2e00                 move.l     d0, d7
0b26: 508f                 addq.l     #$8, a7
0b28: 6012                 bra.b      $b3c
0b2a: 204d                 movea.l    a5, a0
0b2c: 2004                 move.l     d4, d0
0b2e: 48c0                 ext.l      d0
0b30: e588                 lsl.l      #$2, d0
0b32: d1c0                 adda.l     d0, a0
0b34: 20289852             move.l     -$67ae(a0), d0
0b38: 8193                 or.l       d0, (a3)
0b3a: 5287                 addq.l     #$1, d7
0b3c: 2047                 movea.l    d7, a0
0b3e: 1810                 move.b     (a0), d4
0b40: 4884                 ext.w      d4
0b42: 4a44                 tst.w      d4
0b44: 66e4                 bne.b      $b2a
0b46: 206eff8e             movea.l    -$72(a6), a0
0b4a: 10303000             move.b     (a0, d3.w), d0
0b4e: 4880                 ext.w      d0
0b50: 123630a6             move.b     -$5a(a6, d3.w), d1
0b54: 4881                 ext.w      d1
0b56: c1c1                 muls.w     d1, d0
0b58: 226effa2             movea.l    -$5e(a6), a1
0b5c: 3280                 move.w     d0, (a1)
0b5e: 4a93                 tst.l      (a3)
0b60: 675e                 beq.b      $bc0
0b62: 3d7c0001ff92         move.w     #$1, -$6e(a6)
0b68: 7011                 moveq      #$11, d0
0b6a: c1eefffe             muls.w     -$2(a6), d0
0b6e: d08d                 add.l      a5, d0
0b70: 306efffc             movea.w    -$4(a6), a0
0b74: d1c0                 adda.l     d0, a0
0b76: 117c003fbcfe         move.b     #$3f, -$4302(a0)
0b7c: 7800                 moveq      #$0, d4
0b7e: 41edbcfe             lea.l      -$4302(a5), a0
0b82: 2e0a                 move.l     a2, d7
0b84: 9e88                 sub.l      a0, d7
0b86: de87                 add.l      d7, d7
0b88: 41edbf1e             lea.l      -$40e2(a5), a0
0b8c: de88                 add.l      a0, d7
0b8e: 6008                 bra.b      $b98
0b90: 2047                 movea.l    d7, a0
0b92: d850                 add.w      (a0), d4
0b94: 528a                 addq.l     #$1, a2
0b96: 5487                 addq.l     #$2, d7
0b98: 4a12                 tst.b      (a2)
0b9a: 66f4                 bne.b      $b90
0b9c: 7011                 moveq      #$11, d0
0b9e: c1eefffe             muls.w     -$2(a6), d0
0ba2: d08d                 add.l      a5, d0
0ba4: 306efffc             movea.w    -$4(a6), a0
0ba8: d1c0                 adda.l     d0, a0
0baa: 4228bcfe             clr.b      -$4302(a0)
0bae: 206eff8e             movea.l    -$72(a6), a0
0bb2: 10303000             move.b     (a0, d3.w), d0
0bb6: 4880                 ext.w      d0
0bb8: c1c4                 muls.w     d4, d0
0bba: 226eff9e             movea.l    -$62(a6), a1
0bbe: 3280                 move.w     d0, (a1)
0bc0: 5243                 addq.w     #$1, d3
0bc2: 54aeff9e             addq.l     #$2, -$62(a6)
0bc6: 54aeffa2             addq.l     #$2, -$5e(a6)
0bca: 58aeff96             addq.l     #$4, -$6a(a6)
0bce: 0c430010             cmpi.w     #$10, d3
0bd2: 6d00feb2             blt.w      $a86
0bd6: 4a6eff92             tst.w      -$6e(a6)
0bda: 670001a2             beq.w      $d7e
0bde: 3f05                 move.w     d5, -(a7)
0be0: 4ebafc6c             jsr        $84e(pc)
0be4: 2846                 movea.l    d6, a4
0be6: 41ec0001             lea.l      $1(a4), a0
0bea: 2b48d60a             move.l     a0, -$29f6(a5)
0bee: 226dd5fa             movea.l    -$2a06(a5), a1
0bf2: 13450020             move.b     d5, $20(a1)
0bf6: 7601                 moveq      #$1, d3
0bf8: 7000                 moveq      #$0, d0
0bfa: 302e0012             move.w     $12(a6), d0
0bfe: 2d40ff92             move.l     d0, -$6e(a6)
0c02: 2203                 move.l     d3, d1
0c04: 48c1                 ext.l      d1
0c06: e589                 lsl.l      #$2, d1
0c08: 2441                 movea.l    d1, a2
0c0a: 41eeffb8             lea.l      -$48(a6), a0
0c0e: d1ca                 adda.l     a2, a0
0c10: 2c08                 move.l     a0, d6
0c12: 41ed99d6             lea.l      -$662a(a5), a0
0c16: d1ca                 adda.l     a2, a0
0c18: 2d48ff9a             move.l     a0, -$66(a6)
0c1c: 47edd630             lea.l      -$29d0(a5), a3
0c20: d6c3                 adda.w     d3, a3
0c22: d6c3                 adda.w     d3, a3
0c24: 548f                 addq.l     #$2, a7
0c26: 6000014e             bra.w      $d76
0c2a: 246dd5fe             movea.l    -$2a02(a5), a2
0c2e: d4c3                 adda.w     d3, a2
0c30: 4a12                 tst.b      (a2)
0c32: 66000138             bne.w      $d6c
0c36: 4a53                 tst.w      (a3)
0c38: 6616                 bne.b      $c50
0c3a: 206dd5fe             movea.l    -$2a02(a5), a0
0c3e: 4a3030ff             tst.b      -$1(a0, d3.w)
0c42: 660c                 bne.b      $c50
0c44: 206dd5fe             movea.l    -$2a02(a5), a0
0c48: 4a303001             tst.b      $1(a0, d3.w)
0c4c: 6700011e             beq.w      $d6c
0c50: 2b4ad6f8             move.l     a2, -$2908(a5)
0c54: 206eff9a             movea.l    -$66(a6), a0
0c58: 2010                 move.l     (a0), d0
0c5a: c0aeff92             and.l      -$6e(a6), d0
0c5e: 67000108             beq.w      $d68
0c62: 2046                 movea.l    d6, a0
0c64: 4a90                 tst.l      (a0)
0c66: 67000100             beq.w      $d68
0c6a: 48780010             pea.l      $10.w
0c6e: 2f2dd5fa             move.l     -$2a06(a5), -(a7)
0c72: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0c76: 2b46d6fc             move.l     d6, -$2904(a5)
0c7a: 206dd5fe             movea.l    -$2a02(a5), a0
0c7e: 4a3030ff             tst.b      -$1(a0, d3.w)
0c82: 508f                 addq.l     #$8, a7
0c84: 676c                 beq.b      $cf2
0c86: 426eff8c             clr.w      -$74(a6)
0c8a: 49edd148             lea.l      -$2eb8(a5), a4
0c8e: 2b54d140             move.l     (a4), -$2ec0(a5)
0c92: 302eff8c             move.w     -$74(a6), d0
0c96: 3b40d548             move.w     d0, -$2ab8(a5)
0c9a: 204d                 movea.l    a5, a0
0c9c: 48c0                 ext.l      d0
0c9e: e788                 lsl.l      #$3, d0
0ca0: d1c0                 adda.l     d0, a0
0ca2: 2b68d14cd144         move.l     -$2eb4(a0), -$2ebc(a5)
0ca8: 670000be             beq.w      $d68
0cac: 3f03                 move.w     d3, -(a7)
0cae: 3f05                 move.w     d5, -(a7)
0cb0: 4ead091a             jsr        $91a(a5) ; CODE31+004c
0cb4: 2440                 movea.l    d0, a2
0cb6: 2e8a                 move.l     a2, (a7)
0cb8: 4ebaf6b2             jsr        $36c(pc)
0cbc: 2800                 move.l     d0, d4
0cbe: 4a84                 tst.l      d4
0cc0: 588f                 addq.l     #$4, a7
0cc2: 6f26                 ble.b      $cea
0cc4: 2b6dd5fad606         move.l     -$2a06(a5), -$29fa(a5)
0cca: 6004                 bra.b      $cd0
0ccc: 52add606             addq.l     #$1, -$29fa(a5)
0cd0: 206dd606             movea.l    -$29fa(a5), a0
0cd4: 109a                 move.b     (a2)+, (a0)
0cd6: 66f4                 bne.b      $ccc
0cd8: 2f2dd6f8             move.l     -$2908(a5), -(a7)
0cdc: 2004                 move.l     d4, d0
0cde: 720a                 moveq      #$a, d1
0ce0: e3a8                 lsl.l      d1, d0
0ce2: 2f00                 move.l     d0, -(a7)
0ce4: 4eba0702             jsr        $13e8(pc)
0ce8: 508f                 addq.l     #$8, a7
0cea: 526eff8c             addq.w     #$1, -$74(a6)
0cee: 508c                 addq.l     #$8, a4
0cf0: 609c                 bra.b      $c8e
0cf2: 426eff8c             clr.w      -$74(a6)
0cf6: 41edd148             lea.l      -$2eb8(a5), a0
0cfa: 2d48ff8e             move.l     a0, -$72(a6)
0cfe: 206eff8e             movea.l    -$72(a6), a0
0d02: 2b50d140             move.l     (a0), -$2ec0(a5)
0d06: 302eff8c             move.w     -$74(a6), d0
0d0a: 3b40d548             move.w     d0, -$2ab8(a5)
0d0e: 224d                 movea.l    a5, a1
0d10: 48c0                 ext.l      d0
0d12: e788                 lsl.l      #$3, d0
0d14: d3c0                 adda.l     d0, a1
0d16: 2b69d14cd144         move.l     -$2eb4(a1), -$2ebc(a5)
0d1c: 674a                 beq.b      $d68
0d1e: 2b6dd5fad606         move.l     -$2a06(a5), -$29fa(a5)
0d24: 2f2dd6f8             move.l     -$2908(a5), -(a7)
0d28: 202dd144             move.l     -$2ebc(a5), d0
0d2c: 720a                 moveq      #$a, d1
0d2e: e3a8                 lsl.l      d1, d0
0d30: 2f00                 move.l     d0, -(a7)
0d32: 4eba06b4             jsr        $13e8(pc)
0d36: 282dd6f8             move.l     -$2908(a5), d4
0d3a: 988c                 sub.l      a4, d4
0d3c: 5344                 subq.w     #$1, d4
0d3e: 4a44                 tst.w      d4
0d40: 508f                 addq.l     #$8, a7
0d42: 671a                 beq.b      $d5e
0d44: 0c440007             cmpi.w     #$7, d4
0d48: 6f02                 ble.b      $d4c
0d4a: 7807                 moveq      #$7, d4
0d4c: 3f04                 move.w     d4, -(a7)
0d4e: 202dd144             move.l     -$2ebc(a5), d0
0d52: 720a                 moveq      #$a, d1
0d54: e3a8                 lsl.l      d1, d0
0d56: 2f00                 move.l     d0, -(a7)
0d58: 4eba05fc             jsr        $1356(pc)
0d5c: 5c8f                 addq.l     #$6, a7
0d5e: 526eff8c             addq.w     #$1, -$74(a6)
0d62: 50aeff8e             addq.l     #$8, -$72(a6)
0d66: 6096                 bra.b      $cfe
0d68: 286dd6f8             movea.l    -$2908(a5), a4
0d6c: 5243                 addq.w     #$1, d3
0d6e: 5886                 addq.l     #$4, d6
0d70: 58aeff9a             addq.l     #$4, -$66(a6)
0d74: 548b                 addq.l     #$2, a3
0d76: 0c430010             cmpi.w     #$10, d3
0d7a: 6d00feae             blt.w      $c2a
0d7e: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0d82: 4e5e                 unlk       a6
0d84: 4e75                 rts        
0d86: 4e560000             link.w     a6, #$0
0d8a: 48e70708             movem.l    d5-d7/a4, -(a7)
0d8e: 286e0008             movea.l    $8(a6), a4
0d92: 7e00                 moveq      #$0, d7
0d94: 102dd6b7             move.b     -$2949(a5), d0
0d98: 4880                 ext.w      d0
0d9a: 3b40bcfc             move.w     d0, -$4304(a5)
0d9e: 6744                 beq.b      $de4
0da0: 7c61                 moveq      #$61, d6
0da2: 6016                 bra.b      $dba
0da4: 204d                 movea.l    a5, a0
0da6: d0c6                 adda.w     d6, a0
0da8: 1a28d678             move.b     -$2988(a0), d5
0dac: 4a05                 tst.b      d5
0dae: 6708                 beq.b      $db8
0db0: 1005                 move.b     d5, d0
0db2: 4880                 ext.w      d0
0db4: d16dbcfc             add.w      d0, -$4304(a5)
0db8: 5246                 addq.w     #$1, d6
0dba: 0c46007a             cmpi.w     #$7a, d6
0dbe: 6fe4                 ble.b      $da4
0dc0: 206d99d2             movea.l    -$662e(a5), a0
0dc4: 48680001             pea.l      $1(a0)
0dc8: 2f0c                 move.l     a4, -(a7)
0dca: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0dce: 7eff                 moveq      #$ff, d7
0dd0: dead9a3e             add.l      -$65c2(a5), d7
0dd4: 202d9a3a             move.l     -$65c6(a5), d0
0dd8: c087                 and.l      d7, d0
0dda: 508f                 addq.l     #$8, a7
0ddc: 6638                 bne.b      $e16
0dde: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0de2: 6032                 bra.b      $e16
0de4: 7c61                 moveq      #$61, d6
0de6: 6026                 bra.b      $e0e
0de8: 204d                 movea.l    a5, a0
0dea: d0c6                 adda.w     d6, a0
0dec: 1a28d678             move.b     -$2988(a0), d5
0df0: 4a05                 tst.b      d5
0df2: 6718                 beq.b      $e0c
0df4: 1005                 move.b     d5, d0
0df6: 4880                 ext.w      d0
0df8: d16dbcfc             add.w      d0, -$4304(a5)
0dfc: 18c6                 move.b     d6, (a4)+
0dfe: 204d                 movea.l    a5, a0
0e00: 2006                 move.l     d6, d0
0e02: 48c0                 ext.l      d0
0e04: e588                 lsl.l      #$2, d0
0e06: d1c0                 adda.l     d0, a0
0e08: 8ea89852             or.l       -$67ae(a0), d7
0e0c: 5246                 addq.w     #$1, d6
0e0e: 0c46007a             cmpi.w     #$7a, d6
0e12: 6fd4                 ble.b      $de8
0e14: 4214                 clr.b      (a4)
0e16: 0c6d0007bcfc         cmpi.w     #$7, -$4304(a5)
0e1c: 6f06                 ble.b      $e24
0e1e: 3b7c0007bcfc         move.w     #$7, -$4304(a5)
0e24: 2007                 move.l     d7, d0
0e26: 4cdf10e0             movem.l    (a7)+, d5-d7/a4
0e2a: 4e5e                 unlk       a6
0e2c: 4e75                 rts        
0e2e: 4aada38a             tst.l      -$5c76(a5)
0e32: 6710                 beq.b      $e44
0e34: 2038016a             move.l     $16a.w, d0
0e38: b0ada38e             cmp.l      -$5c72(a5), d0
0e3c: 6f06                 ble.b      $e44
0e3e: 206da38a             movea.l    -$5c76(a5), a0
0e42: 4e90                 jsr        (a0)
0e44: 4e75                 rts        
0e46: 4e56fff0             link.w     a6, #$fff0
0e4a: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
0e4e: 206dd5fa             movea.l    -$2a06(a5), a0
0e52: 1c280021             move.b     $21(a0), d6
0e56: 4886                 ext.w      d6
0e58: 7800                 moveq      #$0, d4
0e5a: 42aefffc             clr.l      -$4(a6)
0e5e: 2f08                 move.l     a0, -(a7)
0e60: 4ead0322             jsr        $322(a5) ; CODE15+0198
0e64: 588f                 addq.l     #$4, a7
0e66: 4a40                 tst.w      d0
0e68: 660004e4             bne.w      $134e
0e6c: 4aada38a             tst.l      -$5c76(a5)
0e70: 6710                 beq.b      $e82
0e72: 2038016a             move.l     $16a.w, d0
0e76: b0ada38e             cmp.l      -$5c72(a5), d0
0e7a: 6f06                 ble.b      $e82
0e7c: 206da38a             movea.l    -$5c76(a5), a0
0e80: 4e90                 jsr        (a0)
0e82: 3d7cfffffff0         move.w     #$ffff, -$10(a6)
0e88: 246dd5fe             movea.l    -$2a02(a5), a2
0e8c: d4c6                 adda.w     d6, a2
0e8e: 206dd602             movea.l    -$29fe(a5), a0
0e92: d0c6                 adda.w     d6, a0
0e94: 2d48fff8             move.l     a0, -$8(a6)
0e98: 49edd630             lea.l      -$29d0(a5), a4
0e9c: d8c6                 adda.w     d6, a4
0e9e: d8c6                 adda.w     d6, a4
0ea0: 266dd5fa             movea.l    -$2a06(a5), a3
0ea4: 426db1d6             clr.w      -$4e2a(a5)
0ea8: 600000a0             bra.w      $f4a
0eac: 4a12                 tst.b      (a2)
0eae: 66000090             bne.w      $f40
0eb2: 526db1d6             addq.w     #$1, -$4e2a(a5)
0eb6: 4280                 clr.l      d0
0eb8: 3007                 move.w     d7, d0
0eba: d040                 add.w      d0, d0
0ebc: 41ed9412             lea.l      -$6bee(a5), a0
0ec0: 3a300000             move.w     (a0, d0.w), d5
0ec4: 4280                 clr.l      d0
0ec6: 206efff8             movea.l    -$8(a6), a0
0eca: 1010                 move.b     (a0), d0
0ecc: c0c5                 mulu.w     d5, d0
0ece: d840                 add.w      d0, d4
0ed0: 3014                 move.w     (a4), d0
0ed2: 6714                 beq.b      $ee8
0ed4: 48c5                 ext.l      d5
0ed6: 0c000002             cmpi.b     #$2, d0
0eda: 6d08                 blt.b      $ee4
0edc: 6704                 beq.b      $ee2
0ede: dbaefffc             add.l      d5, -$4(a6)
0ee2: da85                 add.l      d5, d5
0ee4: dbaefffc             add.l      d5, -$4(a6)
0ee8: 43edce84             lea.l      -$317c(a5), a1
0eec: 41eda54e             lea.l      -$5ab2(a5), a0
0ef0: 4280                 clr.l      d0
0ef2: 10317000             move.b     (a1, d7.w), d0
0ef6: b0307000             cmp.b      (a0, d7.w), d0
0efa: 662a                 bne.b      $f26
0efc: 206efff8             movea.l    -$8(a6), a0
0f00: 1010                 move.b     (a0), d0
0f02: 3d40fff6             move.w     d0, -$a(a6)
0f06: 3d54fff4             move.w     (a4), -$c(a6)
0f0a: 41edb3e0             lea.l      -$4c20(a5), a0
0f0e: 102dcec3             move.b     -$313d(a5), d0
0f12: 11870000             move.b     d7, (a0, d0.w)
0f16: 3e3c003f             move.w     #$3f, d7
0f1a: 41eda54e             lea.l      -$5ab2(a5), a0
0f1e: b0307000             cmp.b      (a0, d7.w), d0
0f22: 6d06                 blt.b      $f2a
0f24: a9ff                 dc.w       $a9ff
0f26: 10317000             move.b     (a1, d7.w), d0
0f2a: 52317000             addq.b     #$1, (a1, d7.w)
0f2e: e94f                 lsl.w      #$4, d7
0f30: 43edb3f4             lea.l      -$4c0c(a5), a1
0f34: d2c7                 adda.w     d7, a1
0f36: d040                 add.w      d0, d0
0f38: 32310000             move.w     (a1, d0.w), d1
0f3c: c36efff0             and.w      d1, -$10(a6)
0f40: 528a                 addq.l     #$1, a2
0f42: 548c                 addq.l     #$2, a4
0f44: 52aefff8             addq.l     #$1, -$8(a6)
0f48: 528b                 addq.l     #$1, a3
0f4a: 1e13                 move.b     (a3), d7
0f4c: 4887                 ext.w      d7
0f4e: 4a47                 tst.w      d7
0f50: 6600ff5a             bne.w      $eac
0f54: 2e0b                 move.l     a3, d7
0f56: 9eadd5fa             sub.l      -$2a06(a5), d7
0f5a: 7022                 moveq      #$22, d0
0f5c: c1c7                 muls.w     d7, d0
0f5e: 41ed9f2c             lea.l      -$60d4(a5), a0
0f62: d088                 add.l      a0, d0
0f64: 3046                 movea.w    d6, a0
0f66: d1c8                 adda.l     a0, a0
0f68: 3a300800             move.w     (a0, d0.l), d5
0f6c: 0c450003             cmpi.w     #$3, d5
0f70: 6706                 beq.b      $f78
0f72: 0c450009             cmpi.w     #$9, d5
0f76: 6608                 bne.b      $f80
0f78: 3b7c0001a43e         move.w     #$1, -$5bc2(a5)
0f7e: 6004                 bra.b      $f84
0f80: 426da43e             clr.w      -$5bc2(a5)
0f84: de46                 add.w      d6, d7
0f86: 49edd652             lea.l      -$29ae(a5), a4
0f8a: 204c                 movea.l    a4, a0
0f8c: d0c7                 adda.w     d7, a0
0f8e: 30707000             movea.w    (a0, d7.w), a0
0f92: d888                 add.l      a0, d4
0f94: 204c                 movea.l    a4, a0
0f96: d0c6                 adda.w     d6, a0
0f98: 30706000             movea.w    (a0, d6.w), a0
0f9c: 9888                 sub.l      a0, d4
0f9e: 3045                 movea.w    d5, a0
0fa0: 2f08                 move.l     a0, -(a7)
0fa2: 2f04                 move.l     d4, -(a7)
0fa4: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0fa8: 2800                 move.l     d0, d4
0faa: d9aefffc             add.l      d4, -$4(a6)
0fae: 49edd60e             lea.l      -$29f2(a5), a4
0fb2: 204c                 movea.l    a4, a0
0fb4: d0c7                 adda.w     d7, a0
0fb6: 30307000             move.w     (a0, d7.w), d0
0fba: 48c0                 ext.l      d0
0fbc: d1aefffc             add.l      d0, -$4(a6)
0fc0: 204c                 movea.l    a4, a0
0fc2: d0c6                 adda.w     d6, a0
0fc4: 30306000             move.w     (a0, d6.w), d0
0fc8: 48c0                 ext.l      d0
0fca: 91aefffc             sub.l      d0, -$4(a6)
0fce: 302db1d6             move.w     -$4e2a(a5), d0
0fd2: b06dbcfc             cmp.w      -$4304(a5), d0
0fd6: 661e                 bne.b      $ff6
0fd8: 206dd5fa             movea.l    -$2a06(a5), a0
0fdc: 317c0001001c         move.w     #$1, $1c(a0)
0fe2: 0c6d0007b1d6         cmpi.w     #$7, -$4e2a(a5)
0fe8: 6614                 bne.b      $ffe
0fea: 302d9a56             move.w     -$65aa(a5), d0
0fee: 48c0                 ext.l      d0
0ff0: d1aefffc             add.l      d0, -$4(a6)
0ff4: 6008                 bra.b      $ffe
0ff6: 206dd5fa             movea.l    -$2a06(a5), a0
0ffa: 4268001c             clr.w      $1c(a0)
0ffe: 206dd5fa             movea.l    -$2a06(a5), a0
1002: 316efff0001e         move.w     -$10(a6), $1e(a0)
1008: 0c6e0080fff0         cmpi.w     #$80, -$10(a6)
100e: 6418                 bcc.b      $1028
1010: 7000                 moveq      #$0, d0
1012: 302efff0             move.w     -$10(a6), d0
1016: 204d                 movea.l    a5, a0
1018: d1c0                 adda.l     d0, a0
101a: d1c0                 adda.l     d0, a0
101c: 3068bbf4             movea.w    -$440c(a0), a0
1020: 226dd5fa             movea.l    -$2a06(a5), a1
1024: 23480014             move.l     a0, $14(a1)
1028: 4a2dcec3             tst.b      -$313d(a5)
102c: 670002f2             beq.w      $1320
1030: 102db3e0             move.b     -$4c20(a5), d0
1034: 4880                 ext.w      d0
1036: 3d40fff2             move.w     d0, -$e(a6)
103a: 0c2d0001cec3         cmpi.b     #$1, -$313d(a5)
1040: 660000c0             bne.w      $1102
1044: 204d                 movea.l    a5, a0
1046: d0eefff2             adda.w     -$e(a6), a0
104a: 4a28ce84             tst.b      -$317c(a0)
104e: 6614                 bne.b      $1064
1050: 302efff6             move.w     -$a(a6), d0
1054: c1c5                 muls.w     d5, d0
1056: 3d40fff6             move.w     d0, -$a(a6)
105a: 322efff4             move.w     -$c(a6), d1
105e: d36efff6             add.w      d1, -$a(a6)
1062: 606e                 bra.b      $10d2
1064: 246dd5fe             movea.l    -$2a02(a5), a2
1068: d4c6                 adda.w     d6, a2
106a: 206dd602             movea.l    -$29fe(a5), a0
106e: d0c6                 adda.w     d6, a0
1070: 2d48fff8             move.l     a0, -$8(a6)
1074: 49edd630             lea.l      -$29d0(a5), a4
1078: d8c6                 adda.w     d6, a4
107a: d8c6                 adda.w     d6, a4
107c: 224d                 movea.l    a5, a1
107e: d2eefff2             adda.w     -$e(a6), a1
1082: 1c29ce84             move.b     -$317c(a1), d6
1086: 4886                 ext.w      d6
1088: 5246                 addq.w     #$1, d6
108a: 7e00                 moveq      #$0, d7
108c: 3d7c7530fff6         move.w     #$7530, -$a(a6)
1092: 266dd5fa             movea.l    -$2a06(a5), a3
1096: 6036                 bra.b      $10ce
1098: 1013                 move.b     (a3), d0
109a: 4880                 ext.w      d0
109c: b06efff2             cmp.w      -$e(a6), d0
10a0: 6622                 bne.b      $10c4
10a2: 4a12                 tst.b      (a2)
10a4: 661e                 bne.b      $10c4
10a6: 5247                 addq.w     #$1, d7
10a8: 206efff8             movea.l    -$8(a6), a0
10ac: 1010                 move.b     (a0), d0
10ae: 4880                 ext.w      d0
10b0: c1c5                 muls.w     d5, d0
10b2: 3254                 movea.w    (a4), a1
10b4: d2c0                 adda.w     d0, a1
10b6: 2809                 move.l     a1, d4
10b8: 326efff6             movea.w    -$a(a6), a1
10bc: b3c4                 cmpa.l     d4, a1
10be: 6f04                 ble.b      $10c4
10c0: 3d44fff6             move.w     d4, -$a(a6)
10c4: 528b                 addq.l     #$1, a3
10c6: 52aefff8             addq.l     #$1, -$8(a6)
10ca: 548c                 addq.l     #$2, a4
10cc: 528a                 addq.l     #$1, a2
10ce: bc47                 cmp.w      d7, d6
10d0: 6ec6                 bgt.b      $1098
10d2: 204d                 movea.l    a5, a0
10d4: 302efff2             move.w     -$e(a6), d0
10d8: d0c0                 adda.w     d0, a0
10da: d0c0                 adda.w     d0, a0
10dc: 32289412             move.w     -$6bee(a0), d1
10e0: c3eefff6             muls.w     -$a(a6), d1
10e4: 48c1                 ext.l      d1
10e6: 93aefffc             sub.l      d1, -$4(a6)
10ea: 0c6e001dfff6         cmpi.w     #$1d, -$a(a6)
10f0: 6e08                 bgt.b      $10fa
10f2: 4a6efff6             tst.w      -$a(a6)
10f6: 6e00021e             bgt.w      $1316
10fa: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
10fe: 60000216             bra.w      $1316
1102: 246dd5fe             movea.l    -$2a02(a5), a2
1106: d4c6                 adda.w     d6, a2
1108: 206dd602             movea.l    -$29fe(a5), a0
110c: d0c6                 adda.w     d6, a0
110e: 2d48fff8             move.l     a0, -$8(a6)
1112: 49edd630             lea.l      -$29d0(a5), a4
1116: d8c6                 adda.w     d6, a4
1118: d8c6                 adda.w     d6, a4
111a: 102db3e1             move.b     -$4c1f(a5), d0
111e: 4880                 ext.w      d0
1120: b06efff2             cmp.w      -$e(a6), d0
1124: 6700011a             beq.w      $1240
1128: 102db3e1             move.b     -$4c1f(a5), d0
112c: 4880                 ext.w      d0
112e: 204d                 movea.l    a5, a0
1130: d0c0                 adda.w     d0, a0
1132: 4a28ce84             tst.b      -$317c(a0)
1136: 6666                 bne.b      $119e
1138: 302efff6             move.w     -$a(a6), d0
113c: c1c5                 muls.w     d5, d0
113e: 3d40fff6             move.w     d0, -$a(a6)
1142: d16efff4             add.w      d0, -$c(a6)
1146: 204d                 movea.l    a5, a0
1148: d0eefff2             adda.w     -$e(a6), a0
114c: 1c28ce84             move.b     -$317c(a0), d6
1150: 4886                 ext.w      d6
1152: 5246                 addq.w     #$1, d6
1154: 7e00                 moveq      #$0, d7
1156: 3d7c7530fff6         move.w     #$7530, -$a(a6)
115c: 266dd5fa             movea.l    -$2a06(a5), a3
1160: 6036                 bra.b      $1198
1162: 1013                 move.b     (a3), d0
1164: 4880                 ext.w      d0
1166: b06efff2             cmp.w      -$e(a6), d0
116a: 6622                 bne.b      $118e
116c: 4a12                 tst.b      (a2)
116e: 661e                 bne.b      $118e
1170: 5247                 addq.w     #$1, d7
1172: 206efff8             movea.l    -$8(a6), a0
1176: 1010                 move.b     (a0), d0
1178: 4880                 ext.w      d0
117a: c1c5                 muls.w     d5, d0
117c: 3254                 movea.w    (a4), a1
117e: d2c0                 adda.w     d0, a1
1180: 2809                 move.l     a1, d4
1182: 326efff6             movea.w    -$a(a6), a1
1186: b3c4                 cmpa.l     d4, a1
1188: 6f04                 ble.b      $118e
118a: 3d44fff6             move.w     d4, -$a(a6)
118e: 528b                 addq.l     #$1, a3
1190: 52aefff8             addq.l     #$1, -$8(a6)
1194: 548c                 addq.l     #$2, a4
1196: 528a                 addq.l     #$1, a2
1198: bc47                 cmp.w      d7, d6
119a: 6ec6                 bgt.b      $1162
119c: 6070                 bra.b      $120e
119e: 303c7530             move.w     #$7530, d0
11a2: 3d40fff4             move.w     d0, -$c(a6)
11a6: 3d40fff6             move.w     d0, -$a(a6)
11aa: 266dd5fa             movea.l    -$2a06(a5), a3
11ae: 6056                 bra.b      $1206
11b0: 4a12                 tst.b      (a2)
11b2: 664a                 bne.b      $11fe
11b4: bc6efff2             cmp.w      -$e(a6), d6
11b8: 661e                 bne.b      $11d8
11ba: 206efff8             movea.l    -$8(a6), a0
11be: 1010                 move.b     (a0), d0
11c0: 4880                 ext.w      d0
11c2: c1c5                 muls.w     d5, d0
11c4: 3254                 movea.w    (a4), a1
11c6: d2c0                 adda.w     d0, a1
11c8: 2809                 move.l     a1, d4
11ca: 326efff6             movea.w    -$a(a6), a1
11ce: b3c4                 cmpa.l     d4, a1
11d0: 6f2c                 ble.b      $11fe
11d2: 3d44fff6             move.w     d4, -$a(a6)
11d6: 6026                 bra.b      $11fe
11d8: 102db3e1             move.b     -$4c1f(a5), d0
11dc: 4880                 ext.w      d0
11de: b046                 cmp.w      d6, d0
11e0: 661c                 bne.b      $11fe
11e2: 206efff8             movea.l    -$8(a6), a0
11e6: 1010                 move.b     (a0), d0
11e8: 4880                 ext.w      d0
11ea: c1c5                 muls.w     d5, d0
11ec: 3254                 movea.w    (a4), a1
11ee: d2c0                 adda.w     d0, a1
11f0: 2809                 move.l     a1, d4
11f2: 326efff4             movea.w    -$c(a6), a1
11f6: b3c4                 cmpa.l     d4, a1
11f8: 6f04                 ble.b      $11fe
11fa: 3d44fff4             move.w     d4, -$c(a6)
11fe: 52aefff8             addq.l     #$1, -$8(a6)
1202: 548c                 addq.l     #$2, a4
1204: 528a                 addq.l     #$1, a2
1206: 1c1b                 move.b     (a3)+, d6
1208: 4886                 ext.w      d6
120a: 4a46                 tst.w      d6
120c: 66a2                 bne.b      $11b0
120e: 204d                 movea.l    a5, a0
1210: 302efff2             move.w     -$e(a6), d0
1214: d0c0                 adda.w     d0, a0
1216: d0c0                 adda.w     d0, a0
1218: 32289412             move.w     -$6bee(a0), d1
121c: c3eefff6             muls.w     -$a(a6), d1
1220: 142db3e1             move.b     -$4c1f(a5), d2
1224: 4882                 ext.w      d2
1226: 204d                 movea.l    a5, a0
1228: d0c2                 adda.w     d2, a0
122a: d0c2                 adda.w     d2, a0
122c: 34289412             move.w     -$6bee(a0), d2
1230: c5eefff4             muls.w     -$c(a6), d2
1234: d242                 add.w      d2, d1
1236: 48c1                 ext.l      d1
1238: 93aefffc             sub.l      d1, -$4(a6)
123c: 600000d8             bra.w      $1316
1240: 204d                 movea.l    a5, a0
1242: d0eefff2             adda.w     -$e(a6), a0
1246: 4a28ce84             tst.b      -$317c(a0)
124a: 663e                 bne.b      $128a
124c: 302efff6             move.w     -$a(a6), d0
1250: c1c5                 muls.w     d5, d0
1252: 3d40fff6             move.w     d0, -$a(a6)
1256: d16efff4             add.w      d0, -$c(a6)
125a: 266dd5fa             movea.l    -$2a06(a5), a3
125e: 600a                 bra.b      $126a
1260: 528b                 addq.l     #$1, a3
1262: 52aefff8             addq.l     #$1, -$8(a6)
1266: 548c                 addq.l     #$2, a4
1268: 528a                 addq.l     #$1, a2
126a: 1013                 move.b     (a3), d0
126c: 4880                 ext.w      d0
126e: b06efff2             cmp.w      -$e(a6), d0
1272: 66ec                 bne.b      $1260
1274: 4a12                 tst.b      (a2)
1276: 66e8                 bne.b      $1260
1278: 206efff8             movea.l    -$8(a6), a0
127c: 1010                 move.b     (a0), d0
127e: 4880                 ext.w      d0
1280: c1c5                 muls.w     d5, d0
1282: d054                 add.w      (a4), d0
1284: 3d40fff6             move.w     d0, -$a(a6)
1288: 6070                 bra.b      $12fa
128a: 204d                 movea.l    a5, a0
128c: d0eefff2             adda.w     -$e(a6), a0
1290: 1c28ce84             move.b     -$317c(a0), d6
1294: 4886                 ext.w      d6
1296: 5446                 addq.w     #$2, d6
1298: 7e00                 moveq      #$0, d7
129a: 303c7530             move.w     #$7530, d0
129e: 3d40fff4             move.w     d0, -$c(a6)
12a2: 3d40fff6             move.w     d0, -$a(a6)
12a6: 266dd5fa             movea.l    -$2a06(a5), a3
12aa: 604a                 bra.b      $12f6
12ac: 1013                 move.b     (a3), d0
12ae: 4880                 ext.w      d0
12b0: b06efff2             cmp.w      -$e(a6), d0
12b4: 6636                 bne.b      $12ec
12b6: 4a12                 tst.b      (a2)
12b8: 6632                 bne.b      $12ec
12ba: 5247                 addq.w     #$1, d7
12bc: 206efff8             movea.l    -$8(a6), a0
12c0: 1010                 move.b     (a0), d0
12c2: 4880                 ext.w      d0
12c4: c1c5                 muls.w     d5, d0
12c6: 3254                 movea.w    (a4), a1
12c8: d2c0                 adda.w     d0, a1
12ca: 2809                 move.l     a1, d4
12cc: 326efff4             movea.w    -$c(a6), a1
12d0: b3c4                 cmpa.l     d4, a1
12d2: 6f18                 ble.b      $12ec
12d4: 306efff6             movea.w    -$a(a6), a0
12d8: b1c4                 cmpa.l     d4, a0
12da: 6f0c                 ble.b      $12e8
12dc: 3d6efff6fff4         move.w     -$a(a6), -$c(a6)
12e2: 3d44fff6             move.w     d4, -$a(a6)
12e6: 6004                 bra.b      $12ec
12e8: 3d44fff4             move.w     d4, -$c(a6)
12ec: 528b                 addq.l     #$1, a3
12ee: 52aefff8             addq.l     #$1, -$8(a6)
12f2: 548c                 addq.l     #$2, a4
12f4: 528a                 addq.l     #$1, a2
12f6: bc47                 cmp.w      d7, d6
12f8: 6eb2                 bgt.b      $12ac
12fa: 204d                 movea.l    a5, a0
12fc: 302efff2             move.w     -$e(a6), d0
1300: d0c0                 adda.w     d0, a0
1302: d0c0                 adda.w     d0, a0
1304: 322efff6             move.w     -$a(a6), d1
1308: d26efff4             add.w      -$c(a6), d1
130c: c3e89412             muls.w     -$6bee(a0), d1
1310: 48c1                 ext.l      d1
1312: 93aefffc             sub.l      d1, -$4(a6)
1316: 4aaefffc             tst.l      -$4(a6)
131a: 6c04                 bge.b      $1320
131c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
1320: 206dd5fa             movea.l    -$2a06(a5), a0
1324: 216efffc0010         move.l     -$4(a6), $10(a0)
132a: 2f2dd5fa             move.l     -$2a06(a5), -(a7)
132e: 206dd674             movea.l    -$298c(a5), a0
1332: 4e90                 jsr        (a0)
1334: 588f                 addq.l     #$4, a7
1336: 422dcec3             clr.b      -$313d(a5)
133a: 266dd5fa             movea.l    -$2a06(a5), a3
133e: 41edce84             lea.l      -$317c(a5), a0
1342: 1e1b                 move.b     (a3)+, d7
1344: 4887                 ext.w      d7
1346: 42307000             clr.b      (a0, d7.w)
134a: 1e1b                 move.b     (a3)+, d7
134c: 66f6                 bne.b      $1344
134e: 4cdf1cf0             movem.l    (a7)+, d4-d7/a2-a4
1352: 4e5e                 unlk       a6
1354: 4e75                 rts        
1356: 4e560000             link.w     a6, #$0
135a: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
135e: 3c2e000c             move.w     $c(a6), d6
1362: 2f2e0008             move.l     $8(a6), -(a7)
1366: 4eba000c             jsr        $1374(pc)
136a: 4cee18c0fff0         movem.l    -$10(a6), d6-d7/a3-a4
1370: 4e5e                 unlk       a6
1372: 4e75                 rts        
1374: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
1378: 2e2f0014             move.l     $14(a7), d7
137c: 5346                 subq.w     #$1, d6
137e: ea87                 asr.l      #$5, d7
1380: ea87                 asr.l      #$5, d7
1382: e58f                 lsl.l      #$2, d7
1384: 286dd140             movea.l    -$2ec0(a5), a4
1388: d9c7                 adda.l     d7, a4
138a: 2e1c                 move.l     (a4)+, d7
138c: 203cfffffc00         move.l     #$fffffc00, d0
1392: c087                 and.l      d7, d0
1394: 6744                 beq.b      $13da
1396: 1007                 move.b     d7, d0
1398: 4880                 ext.w      d0
139a: 47edd678             lea.l      -$2988(a5), a3
139e: d6c0                 adda.w     d0, a3
13a0: 4a13                 tst.b      (a3)
13a2: 6608                 bne.b      $13ac
13a4: 47edd6b7             lea.l      -$2949(a5), a3
13a8: 4a13                 tst.b      (a3)
13aa: 672e                 beq.b      $13da
13ac: 206dd606             movea.l    -$29fa(a5), a0
13b0: 52add606             addq.l     #$1, -$29fa(a5)
13b4: 1087                 move.b     d7, (a0)
13b6: 5313                 subq.b     #$1, (a3)
13b8: 0247feff             andi.w     #$feff, d7
13bc: 246dd6f8             movea.l    -$2908(a5), a2
13c0: 2f07                 move.l     d7, -(a7)
13c2: 61000042             bsr.w      $1406
13c6: 588f                 addq.l     #$4, a7
13c8: 4a46                 tst.w      d6
13ca: 6708                 beq.b      $13d4
13cc: 2f07                 move.l     d7, -(a7)
13ce: 6100ffa4             bsr.w      $1374
13d2: 588f                 addq.l     #$4, a7
13d4: 5213                 addq.b     #$1, (a3)
13d6: 53add606             subq.l     #$1, -$29fa(a5)
13da: 08070009             btst.b     #$9, d7
13de: 67aa                 beq.b      $138a
13e0: 5246                 addq.w     #$1, d6
13e2: 4cdf18c0             movem.l    (a7)+, d6-d7/a3-a4
13e6: 4e75                 rts        
13e8: 4e560000             link.w     a6, #$0
13ec: 48e70738             movem.l    d5-d7/a2-a4, -(a7)
13f0: 246e000c             movea.l    $c(a6), a2
13f4: 2f2e0008             move.l     $8(a6), -(a7)
13f8: 4eba000c             jsr        $1406(pc)
13fc: 4cee1ce0ffe8         movem.l    -$18(a6), d5-d7/a2-a4
1402: 4e5e                 unlk       a6
1404: 4e75                 rts        
1406: 48e70738             movem.l    d5-d7/a2-a4, -(a7)
140a: 2e2f001c             move.l     $1c(a7), d7
140e: 1a1a                 move.b     (a2)+, d5
1410: 6740                 beq.b      $1452
1412: ea8f                 lsr.l      #$5, d7
1414: ea8f                 lsr.l      #$5, d7
1416: e58f                 lsl.l      #$2, d7
1418: 286dd140             movea.l    -$2ec0(a5), a4
141c: d9c7                 adda.l     d7, a4
141e: 2e1c                 move.l     (a4)+, d7
1420: 08070009             btst.b     #$9, d7
1424: 6604                 bne.b      $142a
1426: be05                 cmp.b      d5, d7
1428: 6df4                 blt.b      $141e
142a: be05                 cmp.b      d5, d7
142c: 660000ae             bne.w      $14dc
1430: 206dd606             movea.l    -$29fa(a5), a0
1434: 52add606             addq.l     #$1, -$29fa(a5)
1438: 1087                 move.b     d7, (a0)
143a: 58add6fc             addq.l     #$4, -$2904(a5)
143e: 2f07                 move.l     d7, -(a7)
1440: 6100ffc4             bsr.w      $1406
1444: 588f                 addq.l     #$4, a7
1446: 59add6fc             subq.l     #$4, -$2904(a5)
144a: 53add606             subq.l     #$1, -$29fa(a5)
144e: 6000008c             bra.w      $14dc
1452: 08070008             btst.b     #$8, d7
1456: 6722                 beq.b      $147a
1458: 206dd606             movea.l    -$29fa(a5), a0
145c: 4210                 clr.b      (a0)
145e: 202dd606             move.l     -$29fa(a5), d0
1462: 90add5fa             sub.l      -$2a06(a5), d0
1466: 220a                 move.l     a2, d1
1468: 92add60a             sub.l      -$29f6(a5), d1
146c: 9200                 sub.b      d0, d1
146e: 206dd5fa             movea.l    -$2a06(a5), a0
1472: 11410021             move.b     d1, $21(a0)
1476: 4ebaf9ce             jsr        $e46(pc)
147a: ea8f                 lsr.l      #$5, d7
147c: ea8f                 lsr.l      #$5, d7
147e: 675c                 beq.b      $14dc
1480: 206dd6fc             movea.l    -$2904(a5), a0
1484: 2c10                 move.l     (a0), d6
1486: 6754                 beq.b      $14dc
1488: e58f                 lsl.l      #$2, d7
148a: 286dd140             movea.l    -$2ec0(a5), a4
148e: d9c7                 adda.l     d7, a4
1490: 2e1c                 move.l     (a4)+, d7
1492: 4280                 clr.l      d0
1494: 1007                 move.b     d7, d0
1496: 04000061             subi.b     #$61, d0
149a: 0106                 btst.l     d0, d6
149c: 6738                 beq.b      $14d6
149e: 1007                 move.b     d7, d0
14a0: 4880                 ext.w      d0
14a2: 47edd678             lea.l      -$2988(a5), a3
14a6: d6c0                 adda.w     d0, a3
14a8: 4a13                 tst.b      (a3)
14aa: 6608                 bne.b      $14b4
14ac: 47edd6b7             lea.l      -$2949(a5), a3
14b0: 4a13                 tst.b      (a3)
14b2: 6722                 beq.b      $14d6
14b4: 206dd606             movea.l    -$29fa(a5), a0
14b8: 52add606             addq.l     #$1, -$29fa(a5)
14bc: 1087                 move.b     d7, (a0)
14be: 5313                 subq.b     #$1, (a3)
14c0: 58add6fc             addq.l     #$4, -$2904(a5)
14c4: 2f07                 move.l     d7, -(a7)
14c6: 6100ff3e             bsr.w      $1406
14ca: 588f                 addq.l     #$4, a7
14cc: 59add6fc             subq.l     #$4, -$2904(a5)
14d0: 5213                 addq.b     #$1, (a3)
14d2: 53add606             subq.l     #$1, -$29fa(a5)
14d6: 08070009             btst.b     #$9, d7
14da: 67b4                 beq.b      $1490
14dc: 538a                 subq.l     #$1, a2
14de: 4cdf1ce0             movem.l    (a7)+, d5-d7/a2-a4
14e2: 4e75                 rts        
