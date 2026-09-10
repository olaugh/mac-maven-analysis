0004: 4e56ffc0             link.w     a6, #$ffc0
0008: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
000c: 266e0008             movea.l    $8(a6), a3
0010: 42aeffdc             clr.l      -$24(a6)
0014: 7e01                 moveq      #$1, d7
0016: 42aeffcc             clr.l      -$34(a6)
001a: 41eb0010             lea.l      $10(a3), a0
001e: 2d48ffe4             move.l     a0, -$1c(a6)
0022: 42ab0014             clr.l      $14(a3)
0026: 7000                 moveq      #$0, d0
0028: 3740001e             move.w     d0, $1e(a3)
002c: 3240                 movea.w    d0, a1
002e: 27490018             move.l     a1, $18(a3)
0032: 2009                 move.l     a1, d0
0034: 3740001c             move.w     d0, $1c(a3)
0038: 3240                 movea.w    d0, a1
003a: 2089                 move.l     a1, (a0)
003c: 2009                 move.l     a1, d0
003e: 3b40bcfa             move.w     d0, -$4306(a5)
0042: 3b40bcf8             move.w     d0, -$4308(a5)
0046: 3b40bcf6             move.w     d0, -$430a(a5)
004a: 3b40bcf4             move.w     d0, -$430c(a5)
004e: 3b40b1d6             move.w     d0, -$4e2a(a5)
0052: 162b0020             move.b     $20(a3), d3
0056: 4a03                 tst.b      d3
0058: 67000312             beq.w      $36c
005c: 2d4bffe0             move.l     a3, -$20(a6)
0060: 0c030010             cmpi.b     #$10, d3
0064: 6c24                 bge.b      $8a
0066: 1c2b0021             move.b     $21(a3), d6
006a: 4886                 ext.w      d6
006c: 48c6                 ext.l      d6
006e: 1003                 move.b     d3, d0
0070: 4880                 ext.w      d0
0072: c1fc0011             muls.w     #$11, d0
0076: 41edd76c             lea.l      -$2894(a5), a0
007a: d088                 add.l      a0, d0
007c: d086                 add.l      d6, d0
007e: 2d40ffd4             move.l     d0, -$2c(a6)
0082: 7201                 moveq      #$1, d1
0084: 2d41ffd0             move.l     d1, -$30(a6)
0088: 602c                 bra.b      $b6
008a: 1c2b0021             move.b     $21(a3), d6
008e: 4886                 ext.w      d6
0090: 48c6                 ext.l      d6
0092: 48780011             pea.l      $11.w
0096: 2f06                 move.l     d6, -(a7)
0098: 4ead0042             jsr        $42(a5) ; CODE1+00ee
009c: 122b0020             move.b     $20(a3), d1
00a0: 4881                 ext.w      d1
00a2: 41edd75d             lea.l      -$28a3(a5), a0
00a6: d088                 add.l      a0, d0
00a8: 3041                 movea.w    d1, a0
00aa: d088                 add.l      a0, d0
00ac: 2d40ffd4             move.l     d0, -$2c(a6)
00b0: 7211                 moveq      #$11, d1
00b2: 2d41ffd0             move.l     d1, -$30(a6)
00b6: 1803                 move.b     d3, d4
00b8: 4884                 ext.w      d4
00ba: 48c4                 ext.l      d4
00bc: 2606                 move.l     d6, d3
00be: 2d4bffe0             move.l     a3, -$20(a6)
00c2: 48780011             pea.l      $11.w
00c6: 2f04                 move.l     d4, -(a7)
00c8: 4ead0042             jsr        $42(a5) ; CODE1+00ee
00cc: 41edbcfe             lea.l      -$4302(a5), a0
00d0: d088                 add.l      a0, d0
00d2: 2d40fff4             move.l     d0, -$c(a6)
00d6: 48780011             pea.l      $11.w
00da: 2f04                 move.l     d4, -(a7)
00dc: 4ead0042             jsr        $42(a5) ; CODE1+00ee
00e0: 41ed97b2             lea.l      -$684e(a5), a0
00e4: d088                 add.l      a0, d0
00e6: 2d40ffec             move.l     d0, -$14(a6)
00ea: 122b0020             move.b     $20(a3), d1
00ee: 4881                 ext.w      d1
00f0: 3d41ffca             move.w     d1, -$36(a6)
00f4: 48780011             pea.l      $11.w
00f8: 2f04                 move.l     d4, -(a7)
00fa: 4ead0042             jsr        $42(a5) ; CODE1+00ee
00fe: 41ed9592             lea.l      -$6a6e(a5), a0
0102: d088                 add.l      a0, d0
0104: 2d40fff0             move.l     d0, -$10(a6)
0108: 48780011             pea.l      $11.w
010c: 2044                 movea.l    d4, a0
010e: 4868ffff             pea.l      -$1(a0)
0112: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0116: 41edbcfe             lea.l      -$4302(a5), a0
011a: d088                 add.l      a0, d0
011c: 2d40fff8             move.l     d0, -$8(a6)
0120: 48780011             pea.l      $11.w
0124: 2044                 movea.l    d4, a0
0126: 48680001             pea.l      $1(a0)
012a: 4ead0042             jsr        $42(a5) ; CODE1+00ee
012e: 41edbcfe             lea.l      -$4302(a5), a0
0132: d088                 add.l      a0, d0
0134: 2d40fffc             move.l     d0, -$4(a6)
0138: 48780022             pea.l      $22.w
013c: 2f04                 move.l     d4, -(a7)
013e: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0142: 41edbf1e             lea.l      -$40e2(a5), a0
0146: d088                 add.l      a0, d0
0148: 2d40ffe8             move.l     d0, -$18(a6)
014c: 2403                 move.l     d3, d2
014e: d482                 add.l      d2, d2
0150: 2d42ffd8             move.l     d2, -$28(a6)
0154: 600001a4             bra.w      $2fa
0158: 206efff4             movea.l    -$c(a6), a0
015c: 4a303800             tst.b      (a0, d3.l)
0160: 6600016e             bne.w      $2d0
0164: 526db1d6             addq.w     #$1, -$4e2a(a5)
0168: 206effec             movea.l    -$14(a6), a0
016c: 10303800             move.b     (a0, d3.l), d0
0170: 4880                 ext.w      d0
0172: 3240                 movea.w    d0, a1
0174: 2f09                 move.l     a1, -(a7)
0176: 2f07                 move.l     d7, -(a7)
0178: 4ead0042             jsr        $42(a5) ; CODE1+00ee
017c: 2e00                 move.l     d0, d7
017e: 226effd4             movea.l    -$2c(a6), a1
0182: 7000                 moveq      #$0, d0
0184: 1011                 move.b     (a1), d0
0186: 204d                 movea.l    a5, a0
0188: d1c0                 adda.l     d0, a0
018a: 4a28fbd8             tst.b      -$428(a0)
018e: 6a1e                 bpl.b      $1ae
0190: 4a6dbcf4             tst.w      -$430c(a5)
0194: 660c                 bne.b      $1a2
0196: 3b6effcabcf4         move.w     -$36(a6), -$430c(a5)
019c: 3b43bcf8             move.w     d3, -$4308(a5)
01a0: 600a                 bra.b      $1ac
01a2: 3b6effcabcf6         move.w     -$36(a6), -$430a(a5)
01a8: 3b43bcfa             move.w     d3, -$4306(a5)
01ac: 7c3f                 moveq      #$3f, d6
01ae: 204d                 movea.l    a5, a0
01b0: d1c6                 adda.l     d6, a0
01b2: d1c6                 adda.l     d6, a0
01b4: 3d689412ffc8         move.w     -$6bee(a0), -$38(a6)
01ba: 206efff0             movea.l    -$10(a6), a0
01be: 10303800             move.b     (a0, d3.l), d0
01c2: 4880                 ext.w      d0
01c4: c1eeffc8             muls.w     -$38(a6), d0
01c8: 48c0                 ext.l      d0
01ca: d1aeffdc             add.l      d0, -$24(a6)
01ce: 7010                 moveq      #$10, d0
01d0: b084                 cmp.l      d4, d0
01d2: 670a                 beq.b      $1de
01d4: 206efff8             movea.l    -$8(a6), a0
01d8: 4a303800             tst.b      (a0, d3.l)
01dc: 6614                 bne.b      $1f2
01de: 700f                 moveq      #$f, d0
01e0: b084                 cmp.l      d4, d0
01e2: 67000108             beq.w      $2ec
01e6: 206efffc             movea.l    -$4(a6), a0
01ea: 4a303800             tst.b      (a0, d3.l)
01ee: 670000fc             beq.w      $2ec
01f2: 42aeffc4             clr.l      -$3c(a6)
01f6: 2a04                 move.l     d4, d5
01f8: 5385                 subq.l     #$1, d5
01fa: 246effd8             movea.l    -$28(a6), a2
01fe: 48780022             pea.l      $22.w
0202: 2f05                 move.l     d5, -(a7)
0204: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0208: 49edbf1e             lea.l      -$40e2(a5), a4
020c: d08c                 add.l      a4, d0
020e: 2840                 movea.l    d0, a4
0210: 48780011             pea.l      $11.w
0214: 2f05                 move.l     d5, -(a7)
0216: 4ead0042             jsr        $42(a5) ; CODE1+00ee
021a: 41edbcfe             lea.l      -$4302(a5), a0
021e: d088                 add.l      a0, d0
0220: 2d40ffc0             move.l     d0, -$40(a6)
0224: 6018                 bra.b      $23e
0226: 204c                 movea.l    a4, a0
0228: d1ca                 adda.l     a2, a0
022a: 3010                 move.w     (a0), d0
022c: 48c0                 ext.l      d0
022e: d1aeffc4             add.l      d0, -$3c(a6)
0232: 5385                 subq.l     #$1, d5
0234: 49ecffde             lea.l      -$22(a4), a4
0238: 70ef                 moveq      #$ef, d0
023a: d1aeffc0             add.l      d0, -$40(a6)
023e: 700f                 moveq      #$f, d0
0240: b085                 cmp.l      d5, d0
0242: 670a                 beq.b      $24e
0244: 206effc0             movea.l    -$40(a6), a0
0248: 4a303800             tst.b      (a0, d3.l)
024c: 66d8                 bne.b      $226
024e: 2a04                 move.l     d4, d5
0250: 5285                 addq.l     #$1, d5
0252: 48780022             pea.l      $22.w
0256: 2f05                 move.l     d5, -(a7)
0258: 4ead0042             jsr        $42(a5) ; CODE1+00ee
025c: 49edbf1e             lea.l      -$40e2(a5), a4
0260: d08c                 add.l      a4, d0
0262: 2840                 movea.l    d0, a4
0264: 48780011             pea.l      $11.w
0268: 2f05                 move.l     d5, -(a7)
026a: 4ead0042             jsr        $42(a5) ; CODE1+00ee
026e: 41edbcfe             lea.l      -$4302(a5), a0
0272: d088                 add.l      a0, d0
0274: 2d40ffc0             move.l     d0, -$40(a6)
0278: 6018                 bra.b      $292
027a: 204c                 movea.l    a4, a0
027c: d1ca                 adda.l     a2, a0
027e: 3010                 move.w     (a0), d0
0280: 48c0                 ext.l      d0
0282: d1aeffc4             add.l      d0, -$3c(a6)
0286: 5285                 addq.l     #$1, d5
0288: 49ec0022             lea.l      $22(a4), a4
028c: 7011                 moveq      #$11, d0
028e: d1aeffc0             add.l      d0, -$40(a6)
0292: 7010                 moveq      #$10, d0
0294: b085                 cmp.l      d5, d0
0296: 670a                 beq.b      $2a2
0298: 206effc0             movea.l    -$40(a6), a0
029c: 4a303800             tst.b      (a0, d3.l)
02a0: 66d8                 bne.b      $27a
02a2: 206effec             movea.l    -$14(a6), a0
02a6: 10303800             move.b     (a0, d3.l), d0
02aa: 4880                 ext.w      d0
02ac: 3240                 movea.w    d0, a1
02ae: 2f09                 move.l     a1, -(a7)
02b0: 226efff0             movea.l    -$10(a6), a1
02b4: 10313800             move.b     (a1, d3.l), d0
02b8: 4880                 ext.w      d0
02ba: c1eeffc8             muls.w     -$38(a6), d0
02be: 48c0                 ext.l      d0
02c0: d0aeffc4             add.l      -$3c(a6), d0
02c4: 2f00                 move.l     d0, -(a7)
02c6: 4ead0042             jsr        $42(a5) ; CODE1+00ee
02ca: d1aeffcc             add.l      d0, -$34(a6)
02ce: 601c                 bra.b      $2ec
02d0: 246effd8             movea.l    -$28(a6), a2
02d4: 204a                 movea.l    a2, a0
02d6: d1eeffe8             adda.l     -$18(a6), a0
02da: 4a50                 tst.w      (a0)
02dc: 670e                 beq.b      $2ec
02de: 204a                 movea.l    a2, a0
02e0: d1eeffe8             adda.l     -$18(a6), a0
02e4: 3010                 move.w     (a0), d0
02e6: 48c0                 ext.l      d0
02e8: d1aeffdc             add.l      d0, -$24(a6)
02ec: 5283                 addq.l     #$1, d3
02ee: 54aeffd8             addq.l     #$2, -$28(a6)
02f2: 202effd0             move.l     -$30(a6), d0
02f6: d1aeffd4             add.l      d0, -$2c(a6)
02fa: 206effe0             movea.l    -$20(a6), a0
02fe: 52aeffe0             addq.l     #$1, -$20(a6)
0302: 1c10                 move.b     (a0), d6
0304: 4886                 ext.w      d6
0306: 48c6                 ext.l      d6
0308: 6600fe4e             bne.w      $158
030c: 7001                 moveq      #$1, d0
030e: b087                 cmp.l      d7, d0
0310: 671c                 beq.b      $32e
0312: 7002                 moveq      #$2, d0
0314: b087                 cmp.l      d7, d0
0316: 6716                 beq.b      $32e
0318: 7003                 moveq      #$3, d0
031a: b087                 cmp.l      d7, d0
031c: 6710                 beq.b      $32e
031e: 7004                 moveq      #$4, d0
0320: b087                 cmp.l      d7, d0
0322: 670a                 beq.b      $32e
0324: 7009                 moveq      #$9, d0
0326: b087                 cmp.l      d7, d0
0328: 6704                 beq.b      $32e
032a: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
032e: 2f2effdc             move.l     -$24(a6), -(a7)
0332: 2f07                 move.l     d7, -(a7)
0334: 4ead0042             jsr        $42(a5) ; CODE1+00ee
0338: d1aeffcc             add.l      d0, -$34(a6)
033c: 486dc366             pea.l      -$3c9a(a5)
0340: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
0344: 306db1d6             movea.w    -$4e2a(a5), a0
0348: b088                 cmp.l      a0, d0
034a: 588f                 addq.l     #$4, a7
034c: 6616                 bne.b      $364
034e: 0c6d0007b1d6         cmpi.w     #$7, -$4e2a(a5)
0354: 6608                 bne.b      $35e
0356: 06ae00001388ffcc     addi.l     #$1388, -$34(a6)
035e: 377c0001001c         move.w     #$1, $1c(a3)
0364: 206effe4             movea.l    -$1c(a6), a0
0368: 20aeffcc             move.l     -$34(a6), (a0)
036c: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0370: 4e5e                 unlk       a6
0372: 4e75                 rts        
0374: 4e56ff68             link.w     a6, #$ff68
0378: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
037c: 7e01                 moveq      #$1, d7
037e: 426eff74             clr.w      -$8c(a6)
0382: 426eff72             clr.w      -$8e(a6)
0386: 7c11                 moveq      #$11, d6
0388: 426eff70             clr.w      -$90(a6)
038c: 3d7c0011ff6c         move.w     #$11, -$94(a6)
0392: 426eff6e             clr.w      -$92(a6)
0396: 486dc366             pea.l      -$3c9a(a5)
039a: 4ead096a             jsr        $96a(a5) ; CODE31+0992
039e: 7801                 moveq      #$1, d4
03a0: 49edd77d             lea.l      -$2883(a5), a4
03a4: 47edd89e             lea.l      -$2762(a5), a3
03a8: 588f                 addq.l     #$4, a7
03aa: 6000008a             bra.w      $436
03ae: 7601                 moveq      #$1, d3
03b0: 2d4bff7a             move.l     a3, -$86(a6)
03b4: 244c                 movea.l    a4, a2
03b6: 606e                 bra.b      $426
03b8: 206eff7a             movea.l    -$86(a6), a0
03bc: 10303000             move.b     (a0, d3.w), d0
03c0: b0323000             cmp.b      (a2, d3.w), d0
03c4: 675e                 beq.b      $424
03c6: bc44                 cmp.w      d4, d6
03c8: 6f02                 ble.b      $3cc
03ca: 3c04                 move.w     d4, d6
03cc: b86eff70             cmp.w      -$90(a6), d4
03d0: 6f04                 ble.b      $3d6
03d2: 3d44ff70             move.w     d4, -$90(a6)
03d6: b66eff6c             cmp.w      -$94(a6), d3
03da: 6c04                 bge.b      $3e0
03dc: 3d43ff6c             move.w     d3, -$94(a6)
03e0: b66eff6e             cmp.w      -$92(a6), d3
03e4: 6f04                 ble.b      $3ea
03e6: 3d43ff6e             move.w     d3, -$92(a6)
03ea: 7e00                 moveq      #$0, d7
03ec: 244c                 movea.l    a4, a2
03ee: 10323000             move.b     (a2, d3.w), d0
03f2: 4880                 ext.w      d0
03f4: 3f00                 move.w     d0, -(a7)
03f6: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
03fa: 3a00                 move.w     d0, d5
03fc: 41eda54e             lea.l      -$5ab2(a5), a0
0400: d0c5                 adda.w     d5, a0
0402: 2d48ff76             move.l     a0, -$8a(a6)
0406: 4a10                 tst.b      (a0)
0408: 548f                 addq.l     #$2, a7
040a: 6612                 bne.b      $41e
040c: 4a2da58d             tst.b      -$5a73(a5)
0410: 6606                 bne.b      $418
0412: 7000                 moveq      #$0, d0
0414: 600002f8             bra.w      $70e
0418: 532da58d             subq.b     #$1, -$5a73(a5)
041c: 6006                 bra.b      $424
041e: 206eff76             movea.l    -$8a(a6), a0
0422: 5310                 subq.b     #$1, (a0)
0424: 5243                 addq.w     #$1, d3
0426: 0c430010             cmpi.w     #$10, d3
042a: 6d8c                 blt.b      $3b8
042c: 5244                 addq.w     #$1, d4
042e: 49ec0011             lea.l      $11(a4), a4
0432: 47eb0011             lea.l      $11(a3), a3
0436: 0c440010             cmpi.w     #$10, d4
043a: 6d00ff72             blt.w      $3ae
043e: 486dc366             pea.l      -$3c9a(a5)
0442: 4ead096a             jsr        $96a(a5) ; CODE31+0992
0446: 4a47                 tst.w      d7
0448: 588f                 addq.l     #$4, a7
044a: 674c                 beq.b      $498
044c: 4a2da74e             tst.b      -$58b2(a5)
0450: 6628                 bne.b      $47a
0452: 486dc366             pea.l      -$3c9a(a5)
0456: 4ead08da             jsr        $8da(a5) ; CODE30+004e
045a: 4a40                 tst.w      d0
045c: 588f                 addq.l     #$4, a7
045e: 671a                 beq.b      $47a
0460: 4a6e0008             tst.w      $8(a6)
0464: 670e                 beq.b      $474
0466: 3f3c03f0             move.w     #$3f0, -(a7)
046a: 4ead0c6a             jsr        $c6a(a5) ; CODE41+010a
046e: 5340                 subq.w     #$1, d0
0470: 548f                 addq.l     #$2, a7
0472: 6606                 bne.b      $47a
0474: 7000                 moveq      #$0, d0
0476: 60000296             bra.w      $70e
047a: 48780022             pea.l      $22.w
047e: 486da5ce             pea.l      -$5a32(a5)
0482: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0486: 486da74e             pea.l      -$58b2(a5)
048a: 486da5ce             pea.l      -$5a32(a5)
048e: 4ead07f2             jsr        $7f2(a5) ; CODE23+01be
0492: 7001                 moveq      #$1, d0
0494: 60000278             bra.w      $70e
0498: 48780022             pea.l      $22.w
049c: 486da5ce             pea.l      -$5a32(a5)
04a0: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
04a4: 302eff6e             move.w     -$92(a6), d0
04a8: b06eff6c             cmp.w      -$94(a6), d0
04ac: 508f                 addq.l     #$8, a7
04ae: 6f1c                 ble.b      $4cc
04b0: bc6eff70             cmp.w      -$90(a6), d6
04b4: 6c16                 bge.b      $4cc
04b6: 4a6e0008             tst.w      $8(a6)
04ba: 670a                 beq.b      $4c6
04bc: 3f3c03ec             move.w     #$3ec, -(a7)
04c0: 4ead0c6a             jsr        $c6a(a5) ; CODE41+010a
04c4: 548f                 addq.l     #$2, a7
04c6: 7000                 moveq      #$0, d0
04c8: 60000244             bra.w      $70e
04cc: bc6eff70             cmp.w      -$90(a6), d6
04d0: 6704                 beq.b      $4d6
04d2: 7001                 moveq      #$1, d0
04d4: 6002                 bra.b      $4d8
04d6: 7000                 moveq      #$0, d0
04d8: 3e00                 move.w     d0, d7
04da: 302eff6e             move.w     -$92(a6), d0
04de: b06eff6c             cmp.w      -$94(a6), d0
04e2: 6704                 beq.b      $4e8
04e4: 7001                 moveq      #$1, d0
04e6: 6002                 bra.b      $4ea
04e8: 7000                 moveq      #$0, d0
04ea: 3a00                 move.w     d0, d5
04ec: 4a47                 tst.w      d7
04ee: 6672                 bne.b      $562
04f0: 4a45                 tst.w      d5
04f2: 666e                 bne.b      $562
04f4: 4a2dbd8e             tst.b      -$4272(a5)
04f8: 662a                 bne.b      $524
04fa: 7011                 moveq      #$11, d0
04fc: c1c6                 muls.w     d6, d0
04fe: d08d                 add.l      a5, d0
0500: 306eff6c             movea.w    -$94(a6), a0
0504: d1c0                 adda.l     d0, a0
0506: 1d68d76cff7e         move.b     -$2894(a0), -$82(a6)
050c: 422eff7f             clr.b      -$81(a6)
0510: 4267                 clr.w      -(a7)
0512: 486eff7e             pea.l      -$82(a6)
0516: 3f2e0008             move.w     $8(a6), -(a7)
051a: 4ead0592             jsr        $592(a5) ; CODE22+0678
051e: 7000                 moveq      #$0, d0
0520: 600001ec             bra.w      $70e
0524: 0c460010             cmpi.w     #$10, d6
0528: 6716                 beq.b      $540
052a: 70ff                 moveq      #$ff, d0
052c: d046                 add.w      d6, d0
052e: c1fc0011             muls.w     #$11, d0
0532: d08d                 add.l      a5, d0
0534: 306eff6c             movea.w    -$94(a6), a0
0538: d1c0                 adda.l     d0, a0
053a: 4a28bcfe             tst.b      -$4302(a0)
053e: 661c                 bne.b      $55c
0540: 0c46000f             cmpi.w     #$f, d6
0544: 671a                 beq.b      $560
0546: 7001                 moveq      #$1, d0
0548: d046                 add.w      d6, d0
054a: c1fc0011             muls.w     #$11, d0
054e: d08d                 add.l      a5, d0
0550: 306eff6c             movea.w    -$94(a6), a0
0554: d1c0                 adda.l     d0, a0
0556: 4a28bcfe             tst.b      -$4302(a0)
055a: 6704                 beq.b      $560
055c: 7e01                 moveq      #$1, d7
055e: 6002                 bra.b      $562
0560: 7a01                 moveq      #$1, d5
0562: 3806                 move.w     d6, d4
0564: 362eff6c             move.w     -$94(a6), d3
0568: 6004                 bra.b      $56e
056a: 9847                 sub.w      d7, d4
056c: 9645                 sub.w      d5, d3
056e: 7011                 moveq      #$11, d0
0570: c1c4                 muls.w     d4, d0
0572: 41edd76c             lea.l      -$2894(a5), a0
0576: d088                 add.l      a0, d0
0578: 3043                 movea.w    d3, a0
057a: 4a300800             tst.b      (a0, d0.l)
057e: 66ea                 bne.b      $56a
0580: d847                 add.w      d7, d4
0582: d645                 add.w      d5, d3
0584: 0c450001             cmpi.w     #$1, d5
0588: 660a                 bne.b      $594
058a: 1b44a5ee             move.b     d4, -$5a12(a5)
058e: 1b43a5ef             move.b     d3, -$5a11(a5)
0592: 600c                 bra.b      $5a0
0594: 700f                 moveq      #$f, d0
0596: d003                 add.b      d3, d0
0598: 1b40a5ee             move.b     d0, -$5a12(a5)
059c: 1b44a5ef             move.b     d4, -$5a11(a5)
05a0: 49eda5ce             lea.l      -$5a32(a5), a4
05a4: 6004                 bra.b      $5aa
05a6: d847                 add.w      d7, d4
05a8: d645                 add.w      d5, d3
05aa: 7011                 moveq      #$11, d0
05ac: c1c4                 muls.w     d4, d0
05ae: 41edd76c             lea.l      -$2894(a5), a0
05b2: d088                 add.l      a0, d0
05b4: 3043                 movea.w    d3, a0
05b6: 10300800             move.b     (a0, d0.l), d0
05ba: 4880                 ext.w      d0
05bc: 3f00                 move.w     d0, -(a7)
05be: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
05c2: 18c0                 move.b     d0, (a4)+
05c4: 548f                 addq.l     #$2, a7
05c6: 66de                 bne.b      $5a6
05c8: 486eff7e             pea.l      -$82(a6)
05cc: 486dc366             pea.l      -$3c9a(a5)
05d0: 486da5ce             pea.l      -$5a32(a5)
05d4: 4ead098a             jsr        $98a(a5) ; CODE32+0004
05d8: 2b40a5de             move.l     d0, -$5a22(a5)
05dc: 3006                 move.w     d6, d0
05de: 9047                 sub.w      d7, d0
05e0: c1fc0011             muls.w     #$11, d0
05e4: 322eff6c             move.w     -$94(a6), d1
05e8: 9245                 sub.w      d5, d1
05ea: 41edd76c             lea.l      -$2894(a5), a0
05ee: d088                 add.l      a0, d0
05f0: 3041                 movea.w    d1, a0
05f2: 4a300800             tst.b      (a0, d0.l)
05f6: 4fef000c             lea.l      $c(a7), a7
05fa: 6706                 beq.b      $602
05fc: 3d7c0001ff72         move.w     #$1, -$8e(a6)
0602: 3806                 move.w     d6, d4
0604: 362eff6c             move.w     -$94(a6), d3
0608: 60000096             bra.w      $6a0
060c: 0c440008             cmpi.w     #$8, d4
0610: 660c                 bne.b      $61e
0612: 0c430008             cmpi.w     #$8, d3
0616: 6606                 bne.b      $61e
0618: 3d7c0001ff74         move.w     #$1, -$8c(a6)
061e: 7011                 moveq      #$11, d0
0620: c1c4                 muls.w     d4, d0
0622: 41edd76c             lea.l      -$2894(a5), a0
0626: d088                 add.l      a0, d0
0628: 3043                 movea.w    d3, a0
062a: 1d700800ff69         move.b     (a0, d0.l), -$97(a6)
0630: 4a2eff69             tst.b      -$97(a6)
0634: 6616                 bne.b      $64c
0636: 4a6e0008             tst.w      $8(a6)
063a: 670a                 beq.b      $646
063c: 3f3c03eb             move.w     #$3eb, -(a7)
0640: 4ead0c6a             jsr        $c6a(a5) ; CODE41+010a
0644: 548f                 addq.l     #$2, a7
0646: 7000                 moveq      #$0, d0
0648: 600000c4             bra.w      $70e
064c: 7011                 moveq      #$11, d0
064e: c1c4                 muls.w     d4, d0
0650: 41edd88d             lea.l      -$2773(a5), a0
0654: d088                 add.l      a0, d0
0656: 3043                 movea.w    d3, a0
0658: 10300800             move.b     (a0, d0.l), d0
065c: b02eff69             cmp.b      -$97(a6), d0
0660: 6734                 beq.b      $696
0662: 3004                 move.w     d4, d0
0664: d045                 add.w      d5, d0
0666: c1fc0011             muls.w     #$11, d0
066a: 3203                 move.w     d3, d1
066c: d247                 add.w      d7, d1
066e: 41edd76c             lea.l      -$2894(a5), a0
0672: d088                 add.l      a0, d0
0674: 3041                 movea.w    d1, a0
0676: 4a300800             tst.b      (a0, d0.l)
067a: 661a                 bne.b      $696
067c: 3004                 move.w     d4, d0
067e: 9045                 sub.w      d5, d0
0680: c1fc0011             muls.w     #$11, d0
0684: 3203                 move.w     d3, d1
0686: 9247                 sub.w      d7, d1
0688: 41edd76c             lea.l      -$2894(a5), a0
068c: d088                 add.l      a0, d0
068e: 3041                 movea.w    d1, a0
0690: 4a300800             tst.b      (a0, d0.l)
0694: 6706                 beq.b      $69c
0696: 3d7c0001ff72         move.w     #$1, -$8e(a6)
069c: d847                 add.w      d7, d4
069e: d645                 add.w      d5, d3
06a0: b86eff70             cmp.w      -$90(a6), d4
06a4: 6e08                 bgt.b      $6ae
06a6: b66eff6e             cmp.w      -$92(a6), d3
06aa: 6f00ff60             ble.w      $60c
06ae: 7011                 moveq      #$11, d0
06b0: c1c4                 muls.w     d4, d0
06b2: 41edd76c             lea.l      -$2894(a5), a0
06b6: d088                 add.l      a0, d0
06b8: 3043                 movea.w    d3, a0
06ba: 4a300800             tst.b      (a0, d0.l)
06be: 6706                 beq.b      $6c6
06c0: 3d7c0001ff72         move.w     #$1, -$8e(a6)
06c6: 4a2dbd8e             tst.b      -$4272(a5)
06ca: 671a                 beq.b      $6e6
06cc: 4a6eff72             tst.w      -$8e(a6)
06d0: 6614                 bne.b      $6e6
06d2: 4a6e0008             tst.w      $8(a6)
06d6: 670a                 beq.b      $6e2
06d8: 3f3c03ea             move.w     #$3ea, -(a7)
06dc: 4ead0c6a             jsr        $c6a(a5) ; CODE41+010a
06e0: 548f                 addq.l     #$2, a7
06e2: 7000                 moveq      #$0, d0
06e4: 6028                 bra.b      $70e
06e6: 4a2dbd8e             tst.b      -$4272(a5)
06ea: 661a                 bne.b      $706
06ec: 4a6eff74             tst.w      -$8c(a6)
06f0: 6614                 bne.b      $706
06f2: 4a6e0008             tst.w      $8(a6)
06f6: 670a                 beq.b      $702
06f8: 3f3c03e9             move.w     #$3e9, -(a7)
06fc: 4ead0c6a             jsr        $c6a(a5) ; CODE41+010a
0700: 548f                 addq.l     #$2, a7
0702: 7000                 moveq      #$0, d0
0704: 6008                 bra.b      $70e
0706: 3f2e0008             move.w     $8(a6), -(a7)
070a: 4ead058a             jsr        $58a(a5) ; CODE22+04a8
070e: 4cee1cf8ff48         movem.l    -$b8(a6), d3-d7/a2-a4
0714: 4e5e                 unlk       a6
0716: 4e75                 rts        
0718: 4e56ff74             link.w     a6, #$ff74
071c: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0720: 286e0008             movea.l    $8(a6), a4
0724: 4a2c0020             tst.b      $20(a4)
0728: 6640                 bne.b      $76a
072a: 4a6e000e             tst.w      $e(a6)
072e: 672a                 beq.b      $75a
0730: 486da5ce             pea.l      -$5a32(a5)
0734: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
0738: 3e80                 move.w     d0, (a7)
073a: 486d9172             pea.l      -$6e8e(a5)
073e: 486eff7c             pea.l      -$84(a6)
0742: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0746: 486eff7c             pea.l      -$84(a6)
074a: 4ead0c62             jsr        $c62(a5) ; CODE41+0004
074e: 3ebc03e8             move.w     #$3e8, (a7)
0752: 4ead0c6a             jsr        $c6a(a5) ; CODE41+010a
0756: 4fef0010             lea.l      $10(a7), a7
075a: 2f0c                 move.l     a4, -(a7)
075c: 486db3e6             pea.l      -$4c1a(a5)
0760: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0764: 508f                 addq.l     #$8, a7
0766: 60000190             bra.w      $8f8
076a: 0c2c00100020         cmpi.b     #$10, $20(a4)
0770: 6c14                 bge.b      $786
0772: 1e2c0020             move.b     $20(a4), d7
0776: 4887                 ext.w      d7
0778: 1c2c0021             move.b     $21(a4), d6
077c: 4886                 ext.w      d6
077e: 7a00                 moveq      #$0, d5
0780: 47eeff7a             lea.l      -$86(a6), a3
0784: 6016                 bra.b      $79c
0786: 1e2c0021             move.b     $21(a4), d7
078a: 4887                 ext.w      d7
078c: 1c2c0020             move.b     $20(a4), d6
0790: 4886                 ext.w      d6
0792: 0646fff1             addi.w     #$fff1, d6
0796: 7a01                 moveq      #$1, d5
0798: 47eeff78             lea.l      -$88(a6), a3
079c: 7801                 moveq      #$1, d4
079e: 9845                 sub.w      d5, d4
07a0: 3f06                 move.w     d6, -(a7)
07a2: 3f07                 move.w     d7, -(a7)
07a4: 486eff74             pea.l      -$8c(a6)
07a8: 4ead03ea             jsr        $3ea(a5) ; CODE20+05f4
07ac: 4297                 clr.l      (a7)
07ae: 2f3c464f4e54         move.l     #$464f4e54, -(a7)
07b4: 2f2d916e             move.l     -$6e92(a5), -(a7)
07b8: a9a1                 dc.w       $a9a1
07ba: 205f                 movea.l    (a7)+, a0
07bc: a04a                 dc.w       $a04a
07be: 41edb3e6             lea.l      -$4c1a(a5), a0
07c2: 2608                 move.l     a0, d3
07c4: 244c                 movea.l    a4, a2
07c6: 588f                 addq.l     #$4, a7
07c8: 600000c0             bra.w      $88a
07cc: 7011                 moveq      #$11, d0
07ce: c1c7                 muls.w     d7, d0
07d0: 41edd76c             lea.l      -$2894(a5), a0
07d4: d088                 add.l      a0, d0
07d6: 3046                 movea.w    d6, a0
07d8: 4a300800             tst.b      (a0, d0.l)
07dc: 6722                 beq.b      $800
07de: 7011                 moveq      #$11, d0
07e0: c1c7                 muls.w     d7, d0
07e2: 41edd76c             lea.l      -$2894(a5), a0
07e6: d088                 add.l      a0, d0
07e8: 3046                 movea.w    d6, a0
07ea: 7211                 moveq      #$11, d1
07ec: c3c7                 muls.w     d7, d1
07ee: 43edd88d             lea.l      -$2773(a5), a1
07f2: d289                 add.l      a1, d1
07f4: 3246                 movea.w    d6, a1
07f6: 12311800             move.b     (a1, d1.l), d1
07fa: b2300800             cmp.b      (a0, d0.l), d1
07fe: 677a                 beq.b      $87a
0800: 7011                 moveq      #$11, d0
0802: c1c7                 muls.w     d7, d0
0804: 41edbcfe             lea.l      -$4302(a5), a0
0808: d088                 add.l      a0, d0
080a: 3046                 movea.w    d6, a0
080c: 4a300800             tst.b      (a0, d0.l)
0810: 6604                 bne.b      $816
0812: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0816: 7022                 moveq      #$22, d0
0818: c1c7                 muls.w     d7, d0
081a: 41edbf1e             lea.l      -$40e2(a5), a0
081e: d088                 add.l      a0, d0
0820: 3046                 movea.w    d6, a0
0822: d1c8                 adda.l     a0, a0
0824: 4a700800             tst.w      (a0, d0.l)
0828: 670e                 beq.b      $838
082a: 1012                 move.b     (a2), d0
082c: 4880                 ext.w      d0
082e: 3f00                 move.w     d0, -(a7)
0830: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
0834: 548f                 addq.l     #$2, a7
0836: 6004                 bra.b      $83c
0838: 1012                 move.b     (a2), d0
083a: 4880                 ext.w      d0
083c: 7211                 moveq      #$11, d1
083e: c3c7                 muls.w     d7, d1
0840: 41edd76c             lea.l      -$2894(a5), a0
0844: d288                 add.l      a0, d1
0846: 3046                 movea.w    d6, a0
0848: 11801800             move.b     d0, (a0, d1.l)
084c: 2043                 movea.l    d3, a0
084e: 5283                 addq.l     #$1, d3
0850: 1080                 move.b     d0, (a0)
0852: 7011                 moveq      #$11, d0
0854: c1c7                 muls.w     d7, d0
0856: 41edd76c             lea.l      -$2894(a5), a0
085a: d088                 add.l      a0, d0
085c: 3046                 movea.w    d6, a0
085e: 7211                 moveq      #$11, d1
0860: c3c7                 muls.w     d7, d1
0862: 43edd88d             lea.l      -$2773(a5), a1
0866: d289                 add.l      a1, d1
0868: 3246                 movea.w    d6, a1
086a: 13b008001800         move.b     (a0, d0.l), (a1, d1.l)
0870: 3f06                 move.w     d6, -(a7)
0872: 3f07                 move.w     d7, -(a7)
0874: 4ead03da             jsr        $3da(a5) ; CODE20+0648
0878: 588f                 addq.l     #$4, a7
087a: de45                 add.w      d5, d7
087c: dc44                 add.w      d4, d6
087e: 528a                 addq.l     #$1, a2
0880: 206dde80             movea.l    -$2180(a5), a0
0884: 3028000a             move.w     $a(a0), d0
0888: d153                 add.w      d0, (a3)
088a: 4a12                 tst.b      (a2)
088c: 6600ff3e             bne.w      $7cc
0890: 42a7                 clr.l      -(a7)
0892: 2f3c464f4e54         move.l     #$464f4e54, -(a7)
0898: 2f2d916e             move.l     -$6e92(a5), -(a7)
089c: a9a1                 dc.w       $a9a1
089e: 205f                 movea.l    (a7)+, a0
08a0: a049                 dc.w       $a049
08a2: 206dde80             movea.l    -$2180(a5), a0
08a6: 3028000a             move.w     $a(a0), d0
08aa: 9153                 sub.w      d0, (a3)
08ac: 2043                 movea.l    d3, a0
08ae: 4210                 clr.b      (a0)
08b0: 4a6e000c             tst.w      $c(a6)
08b4: 6742                 beq.b      $8f8
08b6: 2f2ddec2             move.l     -$213e(a5), -(a7)
08ba: a873                 dc.w       $a873
08bc: 486eff74             pea.l      -$8c(a6)
08c0: a8a4                 dc.w       $a8a4
08c2: 43eefffc             lea.l      -$4(a6), a1
08c6: 307c000f             movea.w    #$f, a0
08ca: a03b                 dc.w       $a03b
08cc: 2280                 move.l     d0, (a1)
08ce: 486eff74             pea.l      -$8c(a6)
08d2: a8a4                 dc.w       $a8a4
08d4: 43eefffc             lea.l      -$4(a6), a1
08d8: 307c000f             movea.w    #$f, a0
08dc: a03b                 dc.w       $a03b
08de: 2280                 move.l     d0, (a1)
08e0: 486eff74             pea.l      -$8c(a6)
08e4: a8a4                 dc.w       $a8a4
08e6: 43eefffc             lea.l      -$4(a6), a1
08ea: 307c000f             movea.w    #$f, a0
08ee: a03b                 dc.w       $a03b
08f0: 2280                 move.l     d0, (a1)
08f2: 486eff74             pea.l      -$8c(a6)
08f6: a8a4                 dc.w       $a8a4
08f8: 48780121             pea.l      $121.w
08fc: 486dd76c             pea.l      -$2894(a5)
0900: 486dd88d             pea.l      -$2773(a5)
0904: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0908: 4ead053a             jsr        $53a(a5) ; CODE21+08fe
090c: 4ead03c2             jsr        $3c2(a5) ; CODE20+0cfa
0910: 4cee1cf8ff54         movem.l    -$ac(a6), d3-d7/a2-a4
0916: 4e5e                 unlk       a6
0918: 4e75                 rts        
