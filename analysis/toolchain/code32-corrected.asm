0004: 4e56febc             link.w     a6, #$febc
0008: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
000c: 426dbcfa             clr.w      -$4306(a5)
0010: 426dbcf8             clr.w      -$4308(a5)
0014: 426dbcf6             clr.w      -$430a(a5)
0018: 426dbcf4             clr.w      -$430c(a5)
001c: 426db1d6             clr.w      -$4e2a(a5)
0020: 7020                 moveq      #$20, d0
0022: d0ae0008             add.l      $8(a6), d0
0026: 2840                 movea.l    d0, a4
0028: 4a14                 tst.b      (a4)
002a: 6606                 bne.b      $32
002c: 7000                 moveq      #$0, d0
002e: 60000618             bra.w      $648
0032: 246d99d2             movea.l    -$662e(a5), a2
0036: 600c                 bra.b      $44
0038: 204e                 movea.l    a6, a0
003a: d0c6                 adda.w     d6, a0
003c: d0c6                 adda.w     d6, a0
003e: 4268ff00             clr.w      -$100(a0)
0042: 528a                 addq.l     #$1, a2
0044: 1c12                 move.b     (a2), d6
0046: 4886                 ext.w      d6
0048: 4a46                 tst.w      d6
004a: 66ec                 bne.b      $38
004c: 246e000c             movea.l    $c(a6), a2
0050: 600c                 bra.b      $5e
0052: 204e                 movea.l    a6, a0
0054: d0c6                 adda.w     d6, a0
0056: d0c6                 adda.w     d6, a0
0058: 5268ff00             addq.w     #$1, -$100(a0)
005c: 528a                 addq.l     #$1, a2
005e: 1c12                 move.b     (a2), d6
0060: 4886                 ext.w      d6
0062: 4a46                 tst.w      d6
0064: 66ec                 bne.b      $52
0066: 306eff7e             movea.w    -$82(a6), a0
006a: 2d48fee2             move.l     a0, -$11e(a6)
006e: 42aefece             clr.l      -$132(a6)
0072: 7a00                 moveq      #$0, d5
0074: 7001                 moveq      #$1, d0
0076: 2d40febc             move.l     d0, -$144(a6)
007a: 1814                 move.b     (a4), d4
007c: 4884                 ext.w      d4
007e: 226e0008             movea.l    $8(a6), a1
0082: 16290021             move.b     $21(a1), d3
0086: 4883                 ext.w      d3
0088: 2449                 movea.l    a1, a2
008a: 7211                 moveq      #$11, d1
008c: c3c4                 muls.w     d4, d1
008e: 49edbcfe             lea.l      -$4302(a5), a4
0092: d28c                 add.l      a4, d1
0094: 2841                 movea.l    d1, a4
0096: 7211                 moveq      #$11, d1
0098: c3c4                 muls.w     d4, d1
009a: 41ed97b2             lea.l      -$684e(a5), a0
009e: d288                 add.l      a0, d1
00a0: 2d41fed2             move.l     d1, -$12e(a6)
00a4: 7411                 moveq      #$11, d2
00a6: c5c4                 muls.w     d4, d2
00a8: 41ed9592             lea.l      -$6a6e(a5), a0
00ac: d488                 add.l      a0, d2
00ae: 2d42fed6             move.l     d2, -$12a(a6)
00b2: 70ff                 moveq      #$ff, d0
00b4: d044                 add.w      d4, d0
00b6: 3d40feca             move.w     d0, -$136(a6)
00ba: 70ff                 moveq      #$ff, d0
00bc: d044                 add.w      d4, d0
00be: c1fc0011             muls.w     #$11, d0
00c2: 41edbcfe             lea.l      -$4302(a5), a0
00c6: d088                 add.l      a0, d0
00c8: 2d40fef2             move.l     d0, -$10e(a6)
00cc: 7001                 moveq      #$1, d0
00ce: d044                 add.w      d4, d0
00d0: 3d40fec6             move.w     d0, -$13a(a6)
00d4: 7001                 moveq      #$1, d0
00d6: d044                 add.w      d4, d0
00d8: c1fc0011             muls.w     #$11, d0
00dc: 41edbcfe             lea.l      -$4302(a5), a0
00e0: d088                 add.l      a0, d0
00e2: 2d40fef6             move.l     d0, -$10a(a6)
00e6: 7022                 moveq      #$22, d0
00e8: c1c4                 muls.w     d4, d0
00ea: 41edbf1e             lea.l      -$40e2(a5), a0
00ee: d088                 add.l      a0, d0
00f0: 2d40fefa             move.l     d0, -$106(a6)
00f4: 3043                 movea.w    d3, a0
00f6: d1c8                 adda.l     a0, a0
00f8: 2d48feee             move.l     a0, -$112(a6)
00fc: 600001f0             bra.w      $2ee
0100: 7000                 moveq      #$0, d0
0102: 1006                 move.b     d6, d0
0104: 204d                 movea.l    a5, a0
0106: d1c0                 adda.l     d0, a0
0108: 4a28fbd8             tst.b      -$428(a0)
010c: 6b04                 bmi.b      $112
010e: 4ead01a2             jsr        $1a2(a5)
0112: 4a343000             tst.b      (a4, d3.w)
0116: 660001a2             bne.w      $2ba
011a: 2f2efebc             move.l     -$144(a6), -(a7)
011e: 206efed2             movea.l    -$12e(a6), a0
0122: 10303000             move.b     (a0, d3.w), d0
0126: 4880                 ext.w      d0
0128: 3240                 movea.w    d0, a1
012a: 2f09                 move.l     a1, -(a7)
012c: 4ead0042             jsr        $42(a5)
0130: 2d40febc             move.l     d0, -$144(a6)
0134: 526db1d6             addq.w     #$1, -$4e2a(a5)
0138: 0c6d0008b1d6         cmpi.w     #$8, -$4e2a(a5)
013e: 6c06                 bge.b      $146
0140: 4a6db1d6             tst.w      -$4e2a(a5)
0144: 6e04                 bgt.b      $14a
0146: 4ead01a2             jsr        $1a2(a5)
014a: 47eeff00             lea.l      -$100(a6), a3
014e: d6c6                 adda.w     d6, a3
0150: d6c6                 adda.w     d6, a3
0152: 4a53                 tst.w      (a3)
0154: 6628                 bne.b      $17e
0156: 302eff7e             move.w     -$82(a6), d0
015a: 536eff7e             subq.w     #$1, -$82(a6)
015e: 3040                 movea.w    d0, a0
0160: 202efee2             move.l     -$11e(a6), d0
0164: 9088                 sub.l      a0, d0
0166: 204e                 movea.l    a6, a0
0168: d1c0                 adda.l     d0, a0
016a: 1146fefe             move.b     d6, -$102(a0)
016e: 4a6eff7e             tst.w      -$82(a6)
0172: 6c0c                 bge.b      $180
0174: 2d7cffff3cb0fece     move.l     #$ffff3cb0, -$132(a6)
017c: 6002                 bra.b      $180
017e: 5353                 subq.w     #$1, (a3)
0180: 204d                 movea.l    a5, a0
0182: d0c6                 adda.w     d6, a0
0184: d0c6                 adda.w     d6, a0
0186: 3d689412fec4         move.w     -$6bee(a0), -$13c(a6)
018c: 206efed6             movea.l    -$12a(a6), a0
0190: 10303000             move.b     (a0, d3.w), d0
0194: 4880                 ext.w      d0
0196: c1eefec4             muls.w     -$13c(a6), d0
019a: 3240                 movea.w    d0, a1
019c: da89                 add.l      a1, d5
019e: 0c440010             cmpi.w     #$10, d4
01a2: 670a                 beq.b      $1ae
01a4: 206efef2             movea.l    -$10e(a6), a0
01a8: 4a303000             tst.b      (a0, d3.w)
01ac: 6614                 bne.b      $1c2
01ae: 0c44000f             cmpi.w     #$f, d4
01b2: 67000134             beq.w      $2e8
01b6: 206efef6             movea.l    -$10a(a6), a0
01ba: 4a303000             tst.b      (a0, d3.w)
01be: 67000128             beq.w      $2e8
01c2: 42aefec0             clr.l      -$140(a6)
01c6: 3e2efeca             move.w     -$136(a6), d7
01ca: 48c7                 ext.l      d7
01cc: 266efeee             movea.l    -$112(a6), a3
01d0: 48780022             pea.l      $22.w
01d4: 2f07                 move.l     d7, -(a7)
01d6: 4ead0042             jsr        $42(a5)
01da: 41edbf1e             lea.l      -$40e2(a5), a0
01de: d088                 add.l      a0, d0
01e0: 2d40fede             move.l     d0, -$122(a6)
01e4: 48780011             pea.l      $11.w
01e8: 2f07                 move.l     d7, -(a7)
01ea: 4ead0042             jsr        $42(a5)
01ee: 41edbcfe             lea.l      -$4302(a5), a0
01f2: d088                 add.l      a0, d0
01f4: 2d40feda             move.l     d0, -$126(a6)
01f8: 601c                 bra.b      $216
01fa: 204b                 movea.l    a3, a0
01fc: d1eefede             adda.l     -$122(a6), a0
0200: 3010                 move.w     (a0), d0
0202: 48c0                 ext.l      d0
0204: d1aefec0             add.l      d0, -$140(a6)
0208: 5387                 subq.l     #$1, d7
020a: 70de                 moveq      #$de, d0
020c: d1aefede             add.l      d0, -$122(a6)
0210: 70ef                 moveq      #$ef, d0
0212: d1aefeda             add.l      d0, -$126(a6)
0216: 4a87                 tst.l      d7
0218: 6710                 beq.b      $22a
021a: 700f                 moveq      #$f, d0
021c: b087                 cmp.l      d7, d0
021e: 670a                 beq.b      $22a
0220: 206efeda             movea.l    -$126(a6), a0
0224: 4a303000             tst.b      (a0, d3.w)
0228: 66d0                 bne.b      $1fa
022a: 3e2efec6             move.w     -$13a(a6), d7
022e: 48c7                 ext.l      d7
0230: 48780022             pea.l      $22.w
0234: 2f07                 move.l     d7, -(a7)
0236: 4ead0042             jsr        $42(a5)
023a: 41edbf1e             lea.l      -$40e2(a5), a0
023e: d088                 add.l      a0, d0
0240: 2d40fede             move.l     d0, -$122(a6)
0244: 48780011             pea.l      $11.w
0248: 2f07                 move.l     d7, -(a7)
024a: 4ead0042             jsr        $42(a5)
024e: 41edbcfe             lea.l      -$4302(a5), a0
0252: d088                 add.l      a0, d0
0254: 2d40feda             move.l     d0, -$126(a6)
0258: 601c                 bra.b      $276
025a: 204b                 movea.l    a3, a0
025c: d1eefede             adda.l     -$122(a6), a0
0260: 3010                 move.w     (a0), d0
0262: 48c0                 ext.l      d0
0264: d1aefec0             add.l      d0, -$140(a6)
0268: 5287                 addq.l     #$1, d7
026a: 7022                 moveq      #$22, d0
026c: d1aefede             add.l      d0, -$122(a6)
0270: 7011                 moveq      #$11, d0
0272: d1aefeda             add.l      d0, -$126(a6)
0276: 701f                 moveq      #$1f, d0
0278: b087                 cmp.l      d7, d0
027a: 6710                 beq.b      $28c
027c: 7010                 moveq      #$10, d0
027e: b087                 cmp.l      d7, d0
0280: 670a                 beq.b      $28c
0282: 206efeda             movea.l    -$126(a6), a0
0286: 4a303000             tst.b      (a0, d3.w)
028a: 66ce                 bne.b      $25a
028c: 206efed2             movea.l    -$12e(a6), a0
0290: 10303000             move.b     (a0, d3.w), d0
0294: 4880                 ext.w      d0
0296: 3240                 movea.w    d0, a1
0298: 2f09                 move.l     a1, -(a7)
029a: 226efed6             movea.l    -$12a(a6), a1
029e: 10313000             move.b     (a1, d3.w), d0
02a2: 4880                 ext.w      d0
02a4: c1eefec4             muls.w     -$13c(a6), d0
02a8: 48c0                 ext.l      d0
02aa: d0aefec0             add.l      -$140(a6), d0
02ae: 2f00                 move.l     d0, -(a7)
02b0: 4ead0042             jsr        $42(a5)
02b4: d1aefece             add.l      d0, -$132(a6)
02b8: 602e                 bra.b      $2e8
02ba: 266efeee             movea.l    -$112(a6), a3
02be: 204b                 movea.l    a3, a0
02c0: d1eefefa             adda.l     -$106(a6), a0
02c4: 4a50                 tst.w      (a0)
02c6: 670c                 beq.b      $2d4
02c8: 204b                 movea.l    a3, a0
02ca: d1eefefa             adda.l     -$106(a6), a0
02ce: 3050                 movea.w    (a0), a0
02d0: da88                 add.l      a0, d5
02d2: 6014                 bra.b      $2e8
02d4: 3b6dbcf6bcf4         move.w     -$430a(a5), -$430c(a5)
02da: 3b6dbcfabcf8         move.w     -$4306(a5), -$4308(a5)
02e0: 3b44bcf6             move.w     d4, -$430a(a5)
02e4: 3b43bcfa             move.w     d3, -$4306(a5)
02e8: 5243                 addq.w     #$1, d3
02ea: 54aefeee             addq.l     #$2, -$112(a6)
02ee: 1c1a                 move.b     (a2)+, d6
02f0: 4886                 ext.w      d6
02f2: 4a46                 tst.w      d6
02f4: 6600fe0a             bne.w      $100
02f8: 7001                 moveq      #$1, d0
02fa: b0aefebc             cmp.l      -$144(a6), d0
02fe: 672c                 beq.b      $32c
0300: 7002                 moveq      #$2, d0
0302: b0aefebc             cmp.l      -$144(a6), d0
0306: 6724                 beq.b      $32c
0308: 7003                 moveq      #$3, d0
030a: b0aefebc             cmp.l      -$144(a6), d0
030e: 671c                 beq.b      $32c
0310: 7004                 moveq      #$4, d0
0312: b0aefebc             cmp.l      -$144(a6), d0
0316: 6714                 beq.b      $32c
0318: 7009                 moveq      #$9, d0
031a: b0aefebc             cmp.l      -$144(a6), d0
031e: 670c                 beq.b      $32c
0320: 701b                 moveq      #$1b, d0
0322: b0aefebc             cmp.l      -$144(a6), d0
0326: 6704                 beq.b      $32c
0328: 4ead01a2             jsr        $1a2(a5)
032c: 0c6d0007b1d6         cmpi.w     #$7, -$4e2a(a5)
0332: 6606                 bne.b      $33a
0334: 303c1388             move.w     #$1388, d0
0338: 6002                 bra.b      $33c
033a: 7000                 moveq      #$0, d0
033c: 2f05                 move.l     d5, -(a7)
033e: 2f2efebc             move.l     -$144(a6), -(a7)
0342: 2200                 move.l     d0, d1
0344: 4ead0042             jsr        $42(a5)
0348: c141                 exg.l      d0, d1
034a: 3040                 movea.w    d0, a0
034c: d288                 add.l      a0, d1
034e: d3aefece             add.l      d1, -$132(a6)
0352: 306eff7e             movea.w    -$82(a6), a0
0356: b1eefee2             cmpa.l     -$11e(a6), a0
035a: 670002b2             beq.w      $60e
035e: 206e0008             movea.l    $8(a6), a0
0362: 16280021             move.b     $21(a0), d3
0366: 4883                 ext.w      d3
0368: 3b44bcf4             move.w     d4, -$430c(a5)
036c: 203c00007530         move.l     #$7530, d0
0372: 2d40fec6             move.l     d0, -$13a(a6)
0376: 2d40feca             move.l     d0, -$136(a6)
037a: 326eff7e             movea.w    -$82(a6), a1
037e: 222efee2             move.l     -$11e(a6), d1
0382: 9289                 sub.l      a1, d1
0384: 5381                 subq.l     #$1, d1
0386: 660000ac             bne.w      $434
038a: 246e0008             movea.l    $8(a6), a2
038e: 102efefe             move.b     -$102(a6), d0
0392: 4880                 ext.w      d0
0394: 3d40fee2             move.w     d0, -$11e(a6)
0398: 6000008c             bra.w      $426
039c: bc6efee2             cmp.w      -$11e(a6), d6
03a0: 66000082             bne.w      $424
03a4: 7011                 moveq      #$11, d0
03a6: c1c4                 muls.w     d4, d0
03a8: 41edbcfe             lea.l      -$4302(a5), a0
03ac: d088                 add.l      a0, d0
03ae: 3043                 movea.w    d3, a0
03b0: 4a300800             tst.b      (a0, d0.l)
03b4: 666e                 bne.b      $424
03b6: 2a2efebc             move.l     -$144(a6), d5
03ba: 0c440010             cmpi.w     #$10, d4
03be: 6716                 beq.b      $3d6
03c0: 70ff                 moveq      #$ff, d0
03c2: d044                 add.w      d4, d0
03c4: c1fc0011             muls.w     #$11, d0
03c8: 41edbcfe             lea.l      -$4302(a5), a0
03cc: d088                 add.l      a0, d0
03ce: 3043                 movea.w    d3, a0
03d0: 4a300800             tst.b      (a0, d0.l)
03d4: 661c                 bne.b      $3f2
03d6: 0c44000f             cmpi.w     #$f, d4
03da: 6724                 beq.b      $400
03dc: 7001                 moveq      #$1, d0
03de: d044                 add.w      d4, d0
03e0: c1fc0011             muls.w     #$11, d0
03e4: 41edbcfe             lea.l      -$4302(a5), a0
03e8: d088                 add.l      a0, d0
03ea: 3043                 movea.w    d3, a0
03ec: 4a300800             tst.b      (a0, d0.l)
03f0: 670e                 beq.b      $400
03f2: 206efed2             movea.l    -$12e(a6), a0
03f6: 10303000             move.b     (a0, d3.w), d0
03fa: 4880                 ext.w      d0
03fc: 3240                 movea.w    d0, a1
03fe: da89                 add.l      a1, d5
0400: 206efed6             movea.l    -$12a(a6), a0
0404: 10303000             move.b     (a0, d3.w), d0
0408: 4880                 ext.w      d0
040a: 3240                 movea.w    d0, a1
040c: 2f09                 move.l     a1, -(a7)
040e: 2f05                 move.l     d5, -(a7)
0410: 4ead0042             jsr        $42(a5)
0414: 2a00                 move.l     d0, d5
0416: baaefeca             cmp.l      -$136(a6), d5
041a: 6c08                 bge.b      $424
041c: 3b43bcf8             move.w     d3, -$4308(a5)
0420: 2d45feca             move.l     d5, -$136(a6)
0424: 5243                 addq.w     #$1, d3
0426: 1c1a                 move.b     (a2)+, d6
0428: 4886                 ext.w      d6
042a: 4a46                 tst.w      d6
042c: 6600ff6e             bne.w      $39c
0430: 600001b4             bra.w      $5e6
0434: 3b44bcf6             move.w     d4, -$430a(a5)
0438: 102efefe             move.b     -$102(a6), d0
043c: b02efeff             cmp.b      -$101(a6), d0
0440: 670000c8             beq.w      $50a
0444: 246e0008             movea.l    $8(a6), a2
0448: 600000b2             bra.w      $4fc
044c: 4a343000             tst.b      (a4, d3.w)
0450: 660000a8             bne.w      $4fa
0454: 102efefe             move.b     -$102(a6), d0
0458: 4880                 ext.w      d0
045a: b046                 cmp.w      d6, d0
045c: 670c                 beq.b      $46a
045e: 102efeff             move.b     -$101(a6), d0
0462: 4880                 ext.w      d0
0464: b046                 cmp.w      d6, d0
0466: 66000092             bne.w      $4fa
046a: 7000                 moveq      #$0, d0
046c: 1006                 move.b     d6, d0
046e: 204d                 movea.l    a5, a0
0470: d1c0                 adda.l     d0, a0
0472: 1028fbd8             move.b     -$428(a0), d0
0476: 020000c0             andi.b     #$c0, d0
047a: 6604                 bne.b      $480
047c: 4ead01a2             jsr        $1a2(a5)
0480: 2a2efebc             move.l     -$144(a6), d5
0484: 0c440010             cmpi.w     #$10, d4
0488: 670a                 beq.b      $494
048a: 206efef2             movea.l    -$10e(a6), a0
048e: 4a303000             tst.b      (a0, d3.w)
0492: 6610                 bne.b      $4a4
0494: 0c44000f             cmpi.w     #$f, d4
0498: 6718                 beq.b      $4b2
049a: 206efef6             movea.l    -$10a(a6), a0
049e: 4a303000             tst.b      (a0, d3.w)
04a2: 670e                 beq.b      $4b2
04a4: 206efed2             movea.l    -$12e(a6), a0
04a8: 10303000             move.b     (a0, d3.w), d0
04ac: 4880                 ext.w      d0
04ae: 3240                 movea.w    d0, a1
04b0: da89                 add.l      a1, d5
04b2: 206efed6             movea.l    -$12a(a6), a0
04b6: 10303000             move.b     (a0, d3.w), d0
04ba: 4880                 ext.w      d0
04bc: 3240                 movea.w    d0, a1
04be: 2f09                 move.l     a1, -(a7)
04c0: 2f05                 move.l     d5, -(a7)
04c2: 4ead0042             jsr        $42(a5)
04c6: 2a00                 move.l     d0, d5
04c8: 102efefe             move.b     -$102(a6), d0
04cc: 4880                 ext.w      d0
04ce: b046                 cmp.w      d6, d0
04d0: 6610                 bne.b      $4e2
04d2: baaefeca             cmp.l      -$136(a6), d5
04d6: 6c0a                 bge.b      $4e2
04d8: 3b43bcf8             move.w     d3, -$4308(a5)
04dc: 2d45feca             move.l     d5, -$136(a6)
04e0: 6018                 bra.b      $4fa
04e2: 102efeff             move.b     -$101(a6), d0
04e6: 4880                 ext.w      d0
04e8: b046                 cmp.w      d6, d0
04ea: 660e                 bne.b      $4fa
04ec: baaefec6             cmp.l      -$13a(a6), d5
04f0: 6c08                 bge.b      $4fa
04f2: 3b43bcfa             move.w     d3, -$4306(a5)
04f6: 2d45fec6             move.l     d5, -$13a(a6)
04fa: 5243                 addq.w     #$1, d3
04fc: 1c1a                 move.b     (a2)+, d6
04fe: 4886                 ext.w      d6
0500: 4a46                 tst.w      d6
0502: 6600ff48             bne.w      $44c
0506: 600000c0             bra.w      $5c8
050a: 246e0008             movea.l    $8(a6), a2
050e: 600000ae             bra.w      $5be
0512: 102efefe             move.b     -$102(a6), d0
0516: 4880                 ext.w      d0
0518: b046                 cmp.w      d6, d0
051a: 660000a0             bne.w      $5bc
051e: 7011                 moveq      #$11, d0
0520: c1c4                 muls.w     d4, d0
0522: 41edbcfe             lea.l      -$4302(a5), a0
0526: d088                 add.l      a0, d0
0528: 3043                 movea.w    d3, a0
052a: 4a300800             tst.b      (a0, d0.l)
052e: 6600008c             bne.w      $5bc
0532: 2a2efebc             move.l     -$144(a6), d5
0536: 0c440010             cmpi.w     #$10, d4
053a: 6716                 beq.b      $552
053c: 70ff                 moveq      #$ff, d0
053e: d044                 add.w      d4, d0
0540: c1fc0011             muls.w     #$11, d0
0544: 41edbcfe             lea.l      -$4302(a5), a0
0548: d088                 add.l      a0, d0
054a: 3043                 movea.w    d3, a0
054c: 4a300800             tst.b      (a0, d0.l)
0550: 661c                 bne.b      $56e
0552: 0c44000f             cmpi.w     #$f, d4
0556: 6724                 beq.b      $57c
0558: 7001                 moveq      #$1, d0
055a: d044                 add.w      d4, d0
055c: c1fc0011             muls.w     #$11, d0
0560: 41edbcfe             lea.l      -$4302(a5), a0
0564: d088                 add.l      a0, d0
0566: 3043                 movea.w    d3, a0
0568: 4a300800             tst.b      (a0, d0.l)
056c: 670e                 beq.b      $57c
056e: 206efed2             movea.l    -$12e(a6), a0
0572: 10303000             move.b     (a0, d3.w), d0
0576: 4880                 ext.w      d0
0578: 3240                 movea.w    d0, a1
057a: da89                 add.l      a1, d5
057c: 206efed6             movea.l    -$12a(a6), a0
0580: 10303000             move.b     (a0, d3.w), d0
0584: 4880                 ext.w      d0
0586: 3240                 movea.w    d0, a1
0588: 2f09                 move.l     a1, -(a7)
058a: 2f05                 move.l     d5, -(a7)
058c: 4ead0042             jsr        $42(a5)
0590: 2a00                 move.l     d0, d5
0592: baaefec6             cmp.l      -$13a(a6), d5
0596: 6c24                 bge.b      $5bc
0598: baaefeca             cmp.l      -$136(a6), d5
059c: 6c16                 bge.b      $5b4
059e: 3b6dbcf8bcfa         move.w     -$4308(a5), -$4306(a5)
05a4: 2d6efecafec6         move.l     -$136(a6), -$13a(a6)
05aa: 3b43bcf8             move.w     d3, -$4308(a5)
05ae: 2d45feca             move.l     d5, -$136(a6)
05b2: 6008                 bra.b      $5bc
05b4: 3b43bcfa             move.w     d3, -$4306(a5)
05b8: 2d45fec6             move.l     d5, -$13a(a6)
05bc: 5243                 addq.w     #$1, d3
05be: 1c1a                 move.b     (a2)+, d6
05c0: 4886                 ext.w      d6
05c2: 4a46                 tst.w      d6
05c4: 6600ff4c             bne.w      $512
05c8: 2f2efec6             move.l     -$13a(a6), -(a7)
05cc: 102efeff             move.b     -$101(a6), d0
05d0: 4880                 ext.w      d0
05d2: 204d                 movea.l    a5, a0
05d4: d0c0                 adda.w     d0, a0
05d6: d0c0                 adda.w     d0, a0
05d8: 30689412             movea.w    -$6bee(a0), a0
05dc: 2f08                 move.l     a0, -(a7)
05de: 4ead0042             jsr        $42(a5)
05e2: 91aefece             sub.l      d0, -$132(a6)
05e6: 2f2efeca             move.l     -$136(a6), -(a7)
05ea: 102efefe             move.b     -$102(a6), d0
05ee: 4880                 ext.w      d0
05f0: 204d                 movea.l    a5, a0
05f2: d0c0                 adda.w     d0, a0
05f4: d0c0                 adda.w     d0, a0
05f6: 30689412             movea.w    -$6bee(a0), a0
05fa: 2f08                 move.l     a0, -(a7)
05fc: 4ead0042             jsr        $42(a5)
0600: 91aefece             sub.l      d0, -$132(a6)
0604: 4aaefece             tst.l      -$132(a6)
0608: 6c04                 bge.b      $60e
060a: 4ead01a2             jsr        $1a2(a5)
060e: 246d99d2             movea.l    -$662e(a5), a2
0612: 6022                 bra.b      $636
0614: 204e                 movea.l    a6, a0
0616: d0c6                 adda.w     d6, a0
0618: d0c6                 adda.w     d6, a0
061a: 3a28ff00             move.w     -$100(a0), d5
061e: 48c5                 ext.l      d5
0620: 7e00                 moveq      #$0, d7
0622: 600c                 bra.b      $630
0624: 206e0010             movea.l    $10(a6), a0
0628: 1086                 move.b     d6, (a0)
062a: 5287                 addq.l     #$1, d7
062c: 52ae0010             addq.l     #$1, $10(a6)
0630: ba87                 cmp.l      d7, d5
0632: 6ef0                 bgt.b      $624
0634: 528a                 addq.l     #$1, a2
0636: 1c12                 move.b     (a2), d6
0638: 4886                 ext.w      d6
063a: 4a46                 tst.w      d6
063c: 66d6                 bne.b      $614
063e: 206e0010             movea.l    $10(a6), a0
0642: 4210                 clr.b      (a0)
0644: 202efece             move.l     -$132(a6), d0
0648: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
064c: 4e5e                 unlk       a6
064e: 4e75                 rts        
0650: 4e560000             link.w     a6, #$0
0654: 48e70138             movem.l    d7/a2-a4, -(a7)
0658: 3f2e0008             move.w     $8(a6), -(a7)
065c: 4eba0162             jsr        $7c0(pc)
0660: 7e00                 moveq      #$0, d7
0662: 49edf558             lea.l      -$aa8(a5), a4
0666: 47edcdfc             lea.l      -$3204(a5), a3
066a: 2007                 move.l     d7, d0
066c: 48c0                 ext.l      d0
066e: e588                 lsl.l      #$2, d0
0670: 45ed99d6             lea.l      -$662a(a5), a2
0674: d08a                 add.l      a2, d0
0676: 2440                 movea.l    d0, a2
0678: 548f                 addq.l     #$2, a7
067a: 6012                 bra.b      $68e
067c: 302e0008             move.w     $8(a6), d0
0680: 48c0                 ext.l      d0
0682: c092                 and.l      (a2), d0
0684: 6702                 beq.b      $688
0686: 18d3                 move.b     (a3), (a4)+
0688: 528b                 addq.l     #$1, a3
068a: 5247                 addq.w     #$1, d7
068c: 588a                 addq.l     #$4, a2
068e: 4a13                 tst.b      (a3)
0690: 66ea                 bne.b      $67c
0692: 4214                 clr.b      (a4)
0694: 41edf558             lea.l      -$aa8(a5), a0
0698: 2008                 move.l     a0, d0
069a: 4cdf1c80             movem.l    (a7)+, d7/a2-a4
069e: 4e5e                 unlk       a6
06a0: 4e75                 rts        
06a2: 4e56fffc             link.w     a6, #$fffc
06a6: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
06aa: 3e2e0010             move.w     $10(a6), d7
06ae: 3c2e0012             move.w     $12(a6), d6
06b2: 7011                 moveq      #$11, d0
06b4: c1c7                 muls.w     d7, d0
06b6: 41edbcfe             lea.l      -$4302(a5), a0
06ba: d088                 add.l      a0, d0
06bc: 3046                 movea.w    d6, a0
06be: 4a300800             tst.b      (a0, d0.l)
06c2: 6704                 beq.b      $6c8
06c4: 4ead01a2             jsr        $1a2(a5)
06c8: 0c470010             cmpi.w     #$10, d7
06cc: 6716                 beq.b      $6e4
06ce: 70ff                 moveq      #$ff, d0
06d0: d047                 add.w      d7, d0
06d2: c1fc0011             muls.w     #$11, d0
06d6: 41edbcfe             lea.l      -$4302(a5), a0
06da: d088                 add.l      a0, d0
06dc: 3046                 movea.w    d6, a0
06de: 4a300800             tst.b      (a0, d0.l)
06e2: 6620                 bne.b      $704
06e4: 0c47000f             cmpi.w     #$f, d7
06e8: 6716                 beq.b      $700
06ea: 7001                 moveq      #$1, d0
06ec: d047                 add.w      d7, d0
06ee: c1fc0011             muls.w     #$11, d0
06f2: 41edbcfe             lea.l      -$4302(a5), a0
06f6: d088                 add.l      a0, d0
06f8: 3046                 movea.w    d6, a0
06fa: 4a300800             tst.b      (a0, d0.l)
06fe: 6604                 bne.b      $704
0700: 4ead01a2             jsr        $1a2(a5)
0704: 486efffc             pea.l      -$4(a6)
0708: 486efffe             pea.l      -$2(a6)
070c: 3f06                 move.w     d6, -(a7)
070e: 3f07                 move.w     d7, -(a7)
0710: 4ead0922             jsr        $922(a5)
0714: 7011                 moveq      #$11, d0
0716: c1eefffe             muls.w     -$2(a6), d0
071a: 49edbcfe             lea.l      -$4302(a5), a4
071e: d08c                 add.l      a4, d0
0720: 2840                 movea.l    d0, a4
0722: 47ecffff             lea.l      -$1(a4), a3
0726: d6eefffc             adda.w     -$4(a6), a3
072a: 4fef000c             lea.l      $c(a7), a7
072e: 6002                 bra.b      $732
0730: 538b                 subq.l     #$1, a3
0732: 4a13                 tst.b      (a3)
0734: 66fa                 bne.b      $730
0736: 528b                 addq.l     #$1, a3
0738: 306efffc             movea.w    -$4(a6), a0
073c: d1cc                 adda.l     a4, a0
073e: b1cb                 cmpa.l     a3, a0
0740: 6604                 bne.b      $746
0742: 4a13                 tst.b      (a3)
0744: 670e                 beq.b      $754
0746: 4a13                 tst.b      (a3)
0748: 6706                 beq.b      $750
074a: 4a2bffff             tst.b      -$1(a3)
074e: 6704                 beq.b      $754
0750: 4ead01a2             jsr        $1a2(a5)
0754: 286e000c             movea.l    $c(a6), a4
0758: 6042                 bra.b      $79c
075a: 206e0008             movea.l    $8(a6), a0
075e: d0c7                 adda.w     d7, a0
0760: 4a707000             tst.w      (a0, d7.w)
0764: 6734                 beq.b      $79a
0766: 7011                 moveq      #$11, d0
0768: c1eefffe             muls.w     -$2(a6), d0
076c: d08d                 add.l      a5, d0
076e: 306efffc             movea.w    -$4(a6), a0
0772: d1c0                 adda.l     d0, a0
0774: 1147bcfe             move.b     d7, -$4302(a0)
0778: 2f0b                 move.l     a3, -(a7)
077a: 4ead031a             jsr        $31a(a5)
077e: 4a80                 tst.l      d0
0780: 588f                 addq.l     #$4, a7
0782: 6716                 beq.b      $79a
0784: 7011                 moveq      #$11, d0
0786: c1eefffe             muls.w     -$2(a6), d0
078a: d08d                 add.l      a5, d0
078c: 306efffc             movea.w    -$4(a6), a0
0790: d1c0                 adda.l     d0, a0
0792: 4228bcfe             clr.b      -$4302(a0)
0796: 7001                 moveq      #$1, d0
0798: 601e                 bra.b      $7b8
079a: 528c                 addq.l     #$1, a4
079c: 1e14                 move.b     (a4), d7
079e: 4887                 ext.w      d7
07a0: 4a47                 tst.w      d7
07a2: 66b6                 bne.b      $75a
07a4: 7011                 moveq      #$11, d0
07a6: c1eefffe             muls.w     -$2(a6), d0
07aa: d08d                 add.l      a5, d0
07ac: 306efffc             movea.w    -$4(a6), a0
07b0: d1c0                 adda.l     d0, a0
07b2: 4228bcfe             clr.b      -$4302(a0)
07b6: 7000                 moveq      #$0, d0
07b8: 4cdf18c0             movem.l    (a7)+, d6-d7/a3-a4
07bc: 4e5e                 unlk       a6
07be: 4e75                 rts        
07c0: 4e560000             link.w     a6, #$0
07c4: 3f2e0008             move.w     $8(a6), -(a7)
07c8: 4eba0010             jsr        $7da(pc)
07cc: 4a40                 tst.w      d0
07ce: 548f                 addq.l     #$2, a7
07d0: 6604                 bne.b      $7d6
07d2: 4ead01a2             jsr        $1a2(a5)
07d6: 4e5e                 unlk       a6
07d8: 4e75                 rts        
07da: 4e560000             link.w     a6, #$0
07de: 48e70f00             movem.l    d4-d7, -(a7)
07e2: 7e00                 moveq      #$0, d7
07e4: 7cff                 moveq      #$ff, d6
07e6: dc6dccfa             add.w      -$3306(a5), d6
07ea: 602a                 bra.b      $816
07ec: 3a07                 move.w     d7, d5
07ee: da46                 add.w      d6, d5
07f0: e245                 asr.w      #$1, d5
07f2: 204d                 movea.l    a5, a0
07f4: d0c5                 adda.w     d5, a0
07f6: d0c5                 adda.w     d5, a0
07f8: 3828ccfc             move.w     -$3304(a0), d4
07fc: b86e0008             cmp.w      $8(a6), d4
0800: 6604                 bne.b      $806
0802: 7001                 moveq      #$1, d0
0804: 6016                 bra.b      $81c
0806: b86e0008             cmp.w      $8(a6), d4
080a: 6f06                 ble.b      $812
080c: 7e01                 moveq      #$1, d7
080e: de45                 add.w      d5, d7
0810: 6004                 bra.b      $816
0812: 7cff                 moveq      #$ff, d6
0814: dc45                 add.w      d5, d6
0816: be46                 cmp.w      d6, d7
0818: 6fd2                 ble.b      $7ec
081a: 7000                 moveq      #$0, d0
081c: 4cdf00f0             movem.l    (a7)+, d4-d7
0820: 4e5e                 unlk       a6
0822: 4e75                 rts        
0824: 48e70738             movem.l    d5-d7/a2-a4, -(a7)
0828: 486dcdfc             pea.l      -$3204(a5)
082c: 4ead0952             jsr        $952(a5)
0830: 486dcdfc             pea.l      -$3204(a5)
0834: 4ead0dc2             jsr        $dc2(a5)
0838: 7211                 moveq      #$11, d1
083a: b280                 cmp.l      d0, d1
083c: 508f                 addq.l     #$8, a7
083e: 6204                 bhi.b      $844
0840: 4ead01a2             jsr        $1a2(a5)
0844: 486dcdfc             pea.l      -$3204(a5)
0848: 4ead0dc2             jsr        $dc2(a5)
084c: 204d                 movea.l    a5, a0
084e: e588                 lsl.l      #$2, d0
0850: d1c0                 adda.l     d0, a0
0852: 7eff                 moveq      #$ff, d7
0854: dea899d6             add.l      -$662a(a0), d7
0858: 707f                 moveq      #$7f, d0
085a: b087                 cmp.l      d7, d0
085c: 588f                 addq.l     #$4, a7
085e: 6302                 bls.b      $862
0860: 7e7f                 moveq      #$7f, d7
0862: 49edcdfc             lea.l      -$3204(a5), a4
0866: 47ed99d6             lea.l      -$662a(a5), a3
086a: 6042                 bra.b      $8ae
086c: 41edcdfc             lea.l      -$3204(a5), a0
0870: b1cc                 cmpa.l     a4, a0
0872: 670a                 beq.b      $87e
0874: 102cffff             move.b     -$1(a4), d0
0878: 4880                 ext.w      d0
087a: b046                 cmp.w      d6, d0
087c: 6704                 beq.b      $882
087e: 7a00                 moveq      #$0, d5
0880: 6002                 bra.b      $884
0882: 5245                 addq.w     #$1, d5
0884: 2006                 move.l     d6, d0
0886: 48c0                 ext.l      d0
0888: e988                 lsl.l      #$4, d0
088a: 45edb3f4             lea.l      -$4c0c(a5), a2
088e: d08a                 add.l      a2, d0
0890: 3445                 movea.w    d5, a2
0892: d5ca                 adda.l     a2, a2
0894: d08a                 add.l      a2, d0
0896: 2440                 movea.l    d0, a2
0898: 302b0002             move.w     $2(a3), d0
089c: 4640                 not.w      d0
089e: c047                 and.w      d7, d0
08a0: 3480                 move.w     d0, (a2)
08a2: 4a52                 tst.w      (a2)
08a4: 6604                 bne.b      $8aa
08a6: 4ead01a2             jsr        $1a2(a5)
08aa: 588b                 addq.l     #$4, a3
08ac: 528c                 addq.l     #$1, a4
08ae: 1c14                 move.b     (a4), d6
08b0: 4886                 ext.w      d6
08b2: 4a46                 tst.w      d6
08b4: 66b6                 bne.b      $86c
08b6: 4cdf1ce0             movem.l    (a7)+, d5-d7/a2-a4
08ba: 4e75                 rts        
08bc: 4e56ff78             link.w     a6, #$ff78
08c0: 48e70338             movem.l    d6-d7/a2-a4, -(a7)
08c4: 2e2e000c             move.l     $c(a6), d7
08c8: 286e0010             movea.l    $10(a6), a4
08cc: 52adb1dc             addq.l     #$1, -$4e24(a5)
08d0: 2b6db1dcb1d8         move.l     -$4e24(a5), -$4e28(a5)
08d6: 48780100             pea.l      $100.w
08da: 486dbbf4             pea.l      -$440c(a5)
08de: 4ead01aa             jsr        $1aa(a5)
08e2: 48780100             pea.l      $100.w
08e6: 486dccfc             pea.l      -$3304(a5)
08ea: 4ead01aa             jsr        $1aa(a5)
08ee: 426dccfa             clr.w      -$3306(a5)
08f2: 4ebaff30             jsr        $824(pc)
08f6: 486dce04             pea.l      -$31fc(a5)
08fa: 4ead095a             jsr        $95a(a5)
08fe: 3b40cf06             move.w     d0, -$30fa(a5)
0902: 422eff7d             clr.b      -$83(a6)
0906: 2047                 movea.l    d7, a0
0908: 4250                 clr.w      (a0)
090a: 206e0008             movea.l    $8(a6), a0
090e: 4290                 clr.l      (a0)
0910: 266d99d2             movea.l    -$662e(a5), a3
0914: 4fef0014             lea.l      $14(a7), a7
0918: 6052                 bra.b      $96c
091a: 1d46ff7c             move.b     d6, -$84(a6)
091e: 4a46                 tst.w      d6
0920: 6d10                 blt.b      $932
0922: 0c460080             cmpi.w     #$80, d6
0926: 640a                 bcc.b      $932
0928: 204d                 movea.l    a5, a0
092a: d0c6                 adda.w     d6, a0
092c: 4a28ce04             tst.b      -$31fc(a0)
0930: 6c04                 bge.b      $936
0932: 4ead01a2             jsr        $1a2(a5)
0936: 45edce04             lea.l      -$31fc(a5), a2
093a: d4c6                 adda.w     d6, a2
093c: 1012                 move.b     (a2), d0
093e: 4880                 ext.w      d0
0940: 204d                 movea.l    a5, a0
0942: d0c6                 adda.w     d6, a0
0944: d0c6                 adda.w     d6, a0
0946: c1e89412             muls.w     -$6bee(a0), d0
094a: 2047                 movea.l    d7, a0
094c: d150                 add.w      d0, (a0)
094e: 486eff78             pea.l      -$88(a6)
0952: 486eff7c             pea.l      -$84(a6)
0956: 4eba0d68             jsr        $16c0(pc)
095a: 1212                 move.b     (a2), d1
095c: 4881                 ext.w      d1
095e: c3c0                 muls.w     d0, d1
0960: 48c1                 ext.l      d1
0962: 206e0008             movea.l    $8(a6), a0
0966: d390                 add.l      d1, (a0)
0968: 508f                 addq.l     #$8, a7
096a: 528b                 addq.l     #$1, a3
096c: 1c13                 move.b     (a3), d6
096e: 4886                 ext.w      d6
0970: 4a46                 tst.w      d6
0972: 66a6                 bne.b      $91a
0974: 2047                 movea.l    d7, a0
0976: 4a50                 tst.w      (a0)
0978: 6c04                 bge.b      $97e
097a: 4ead01a2             jsr        $1a2(a5)
097e: 102dce65             move.b     -$319b(a5), d0
0982: 4880                 ext.w      d0
0984: 122dce69             move.b     -$3197(a5), d1
0988: 4881                 ext.w      d1
098a: d041                 add.w      d1, d0
098c: 122dce6d             move.b     -$3193(a5), d1
0990: 4881                 ext.w      d1
0992: d041                 add.w      d1, d0
0994: 122dce73             move.b     -$318d(a5), d1
0998: 4881                 ext.w      d1
099a: d041                 add.w      d1, d0
099c: 122dce79             move.b     -$3187(a5), d1
09a0: 4881                 ext.w      d1
09a2: d041                 add.w      d1, d0
09a4: 3880                 move.w     d0, (a4)
09a6: 322dcf06             move.w     -$30fa(a5), d1
09aa: 9240                 sub.w      d0, d1
09ac: 206e0014             movea.l    $14(a6), a0
09b0: 3081                 move.w     d1, (a0)
09b2: 700a                 moveq      #$a, d0
09b4: c1d4                 muls.w     (a4), d0
09b6: 322dcf06             move.w     -$30fa(a5), d1
09ba: e549                 lsl.w      #$2, d1
09bc: b240                 cmp.w      d0, d1
09be: 6f14                 ble.b      $9d4
09c0: 102dce43             move.b     -$31bd(a5), d0
09c4: 4880                 ext.w      d0
09c6: d154                 add.w      d0, (a4)
09c8: 102dce43             move.b     -$31bd(a5), d0
09cc: 4880                 ext.w      d0
09ce: 206e0014             movea.l    $14(a6), a0
09d2: 9150                 sub.w      d0, (a0)
09d4: 4cdf1cc0             movem.l    (a7)+, d6-d7/a2-a4
09d8: 4e5e                 unlk       a6
09da: 4e75                 rts        
09dc: 4e56ffd8             link.w     a6, #$ffd8
09e0: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
09e4: 486effea             pea.l      -$16(a6)
09e8: 486effec             pea.l      -$14(a6)
09ec: 486effee             pea.l      -$12(a6)
09f0: 486effe6             pea.l      -$1a(a6)
09f4: 4ebafec6             jsr        $8bc(pc)
09f8: 486effe2             pea.l      -$1e(a6)
09fc: 2f2d93bc             move.l     -$6c44(a5), -(a7)
0a00: 4eba0cbe             jsr        $16c0(pc)
0a04: 122dce75             move.b     -$318b(a5), d1
0a08: 4881                 ext.w      d1
0a0a: c3c0                 muls.w     d0, d1
0a0c: 48c1                 ext.l      d1
0a0e: 93aeffe6             sub.l      d1, -$1a(a6)
0a12: 7c7f                 moveq      #$7f, d6
0a14: 49edbcf2             lea.l      -$430e(a5), a4
0a18: 41edccf8             lea.l      -$3308(a5), a0
0a1c: 2e08                 move.l     a0, d7
0a1e: 4fef0018             lea.l      $18(a7), a7
0a22: 600001ce             bra.w      $bf2
0a26: 426effe0             clr.w      -$20(a6)
0a2a: 426effde             clr.w      -$22(a6)
0a2e: 426effdc             clr.w      -$24(a6)
0a32: 47edcdfc             lea.l      -$3204(a5), a3
0a36: 45eefff0             lea.l      -$10(a6), a2
0a3a: 7800                 moveq      #$0, d4
0a3c: 41ed99d6             lea.l      -$662a(a5), a0
0a40: 2d48ffd8             move.l     a0, -$28(a6)
0a44: 6056                 bra.b      $a9c
0a46: 206effd8             movea.l    -$28(a6), a0
0a4a: 2006                 move.l     d6, d0
0a4c: 48c0                 ext.l      d0
0a4e: c090                 and.l      (a0), d0
0a50: 6742                 beq.b      $a94
0a52: 14c5                 move.b     d5, (a2)+
0a54: 3f05                 move.w     d5, -(a7)
0a56: 4ead07d2             jsr        $7d2(a5)
0a5a: 4a40                 tst.w      d0
0a5c: 548f                 addq.l     #$2, a7
0a5e: 6706                 beq.b      $a66
0a60: 526effdc             addq.w     #$1, -$24(a6)
0a64: 6010                 bra.b      $a76
0a66: 0c45003f             cmpi.w     #$3f, d5
0a6a: 6706                 beq.b      $a72
0a6c: 526effde             addq.w     #$1, -$22(a6)
0a70: 6004                 bra.b      $a76
0a72: 526effe0             addq.w     #$1, -$20(a6)
0a76: 102b0001             move.b     $1(a3), d0
0a7a: 4880                 ext.w      d0
0a7c: b045                 cmp.w      d5, d0
0a7e: 6614                 bne.b      $a94
0a80: 204d                 movea.l    a5, a0
0a82: 2004                 move.l     d4, d0
0a84: 48c0                 ext.l      d0
0a86: e588                 lsl.l      #$2, d0
0a88: d1c0                 adda.l     d0, a0
0a8a: 2006                 move.l     d6, d0
0a8c: 48c0                 ext.l      d0
0a8e: c0a899da             and.l      -$6626(a0), d0
0a92: 6710                 beq.b      $aa4
0a94: 5244                 addq.w     #$1, d4
0a96: 58aeffd8             addq.l     #$4, -$28(a6)
0a9a: 528b                 addq.l     #$1, a3
0a9c: 1a13                 move.b     (a3), d5
0a9e: 4885                 ext.w      d5
0aa0: 4a45                 tst.w      d5
0aa2: 66a2                 bne.b      $a46
0aa4: 4a45                 tst.w      d5
0aa6: 66000144             bne.w      $bec
0aaa: 4212                 clr.b      (a2)
0aac: 302dccfa             move.w     -$3306(a5), d0
0ab0: 526dccfa             addq.w     #$1, -$3306(a5)
0ab4: 204d                 movea.l    a5, a0
0ab6: d0c0                 adda.w     d0, a0
0ab8: d0c0                 adda.w     d0, a0
0aba: 3146ccfc             move.w     d6, -$3304(a0)
0abe: 2047                 movea.l    d7, a0
0ac0: 4250                 clr.w      (a0)
0ac2: 45eefff0             lea.l      -$10(a6), a2
0ac6: 6010                 bra.b      $ad8
0ac8: 204d                 movea.l    a5, a0
0aca: d0c5                 adda.w     d5, a0
0acc: d0c5                 adda.w     d5, a0
0ace: 30289412             move.w     -$6bee(a0), d0
0ad2: 2047                 movea.l    d7, a0
0ad4: d150                 add.w      d0, (a0)
0ad6: 528a                 addq.l     #$1, a2
0ad8: 1a12                 move.b     (a2), d5
0ada: 4885                 ext.w      d5
0adc: 4a45                 tst.w      d5
0ade: 66e8                 bne.b      $ac8
0ae0: 486efff0             pea.l      -$10(a6)
0ae4: 4ead0dc2             jsr        $dc2(a5)
0ae8: 7807                 moveq      #$7, d4
0aea: 9840                 sub.w      d0, d4
0aec: 76f9                 moveq      #$f9, d3
0aee: d66dcf06             add.w      -$30fa(a5), d3
0af2: b644                 cmp.w      d4, d3
0af4: 588f                 addq.l     #$4, a7
0af6: 6c04                 bge.b      $afc
0af8: 3003                 move.w     d3, d0
0afa: 6002                 bra.b      $afe
0afc: 3004                 move.w     d4, d0
0afe: 3800                 move.w     d0, d4
0b00: 486effe2             pea.l      -$1e(a6)
0b04: 486efff0             pea.l      -$10(a6)
0b08: 4eba0b42             jsr        $164c(pc)
0b0c: 3600                 move.w     d0, d3
0b0e: 508f                 addq.l     #$8, a7
0b10: 670000a2             beq.w      $bb4
0b14: 206effe2             movea.l    -$1e(a6), a0
0b18: 2010                 move.l     (a0), d0
0b1a: b0adb1d8             cmp.l      -$4e28(a5), d0
0b1e: 6e000094             bgt.w      $bb4
0b22: 3f3c0071             move.w     #$71, -(a7)
0b26: 486efff0             pea.l      -$10(a6)
0b2a: 4ead0dba             jsr        $dba(a5)
0b2e: 4a80                 tst.l      d0
0b30: 5c8f                 addq.l     #$6, a7
0b32: 6738                 beq.b      $b6c
0b34: 2f2d93bc             move.l     -$6c44(a5), -(a7)
0b38: 486efff0             pea.l      -$10(a6)
0b3c: 4ead0db2             jsr        $db2(a5)
0b40: 4a40                 tst.w      d0
0b42: 508f                 addq.l     #$8, a7
0b44: 6622                 bne.b      $b68
0b46: 306dcf06             movea.w    -$30fa(a5), a0
0b4a: 2f08                 move.l     a0, -(a7)
0b4c: 306dcf06             movea.w    -$30fa(a5), a0
0b50: 202effe6             move.l     -$1a(a6), d0
0b54: 9088                 sub.l      a0, d0
0b56: 2f00                 move.l     d0, -(a7)
0b58: 4ead005a             jsr        $5a(a5)
0b5c: 3600                 move.w     d0, d3
0b5e: 0c43ff9c             cmpi.w     #$ff9c, d3
0b62: 6f3a                 ble.b      $b9e
0b64: 769c                 moveq      #$9c, d3
0b66: 6036                 bra.b      $b9e
0b68: 7600                 moveq      #$0, d3
0b6a: 6032                 bra.b      $b9e
0b6c: 486df684             pea.l      -$97c(a5)
0b70: 486efff0             pea.l      -$10(a6)
0b74: 4ead0db2             jsr        $db2(a5)
0b78: 4a40                 tst.w      d0
0b7a: 508f                 addq.l     #$8, a7
0b7c: 6620                 bne.b      $b9e
0b7e: 4a2dce75             tst.b      -$318b(a5)
0b82: 671a                 beq.b      $b9e
0b84: 4a2dce79             tst.b      -$3187(a5)
0b88: 6614                 bne.b      $b9e
0b8a: 486effe2             pea.l      -$1e(a6)
0b8e: 2f2d93c0             move.l     -$6c40(a5), -(a7)
0b92: 4eba0b2c             jsr        $16c0(pc)
0b96: 06400258             addi.w     #$258, d0
0b9a: 3600                 move.w     d0, d3
0b9c: 508f                 addq.l     #$8, a7
0b9e: 52adb1dc             addq.l     #$1, -$4e24(a5)
0ba2: 206effe2             movea.l    -$1e(a6), a0
0ba6: 20adb1dc             move.l     -$4e24(a5), (a0)
0baa: 3f03                 move.w     d3, -(a7)
0bac: 3f06                 move.w     d6, -(a7)
0bae: 4eba0d34             jsr        $18e4(pc)
0bb2: 588f                 addq.l     #$4, a7
0bb4: 3f04                 move.w     d4, -(a7)
0bb6: 3f2effea             move.w     -$16(a6), -(a7)
0bba: 3f2effec             move.w     -$14(a6), -(a7)
0bbe: 3f2effe0             move.w     -$20(a6), -(a7)
0bc2: 3f2effde             move.w     -$22(a6), -(a7)
0bc6: 3f2effdc             move.w     -$24(a6), -(a7)
0bca: 4eba00f8             jsr        $cc4(pc)
0bce: d154                 add.w      d0, (a4)
0bd0: 306dcf06             movea.w    -$30fa(a5), a0
0bd4: 2e88                 move.l     a0, (a7)
0bd6: 3044                 movea.w    d4, a0
0bd8: 2f08                 move.l     a0, -(a7)
0bda: 2f2effe6             move.l     -$1a(a6), -(a7)
0bde: 4ead0042             jsr        $42(a5)
0be2: 2f00                 move.l     d0, -(a7)
0be4: 4ead005a             jsr        $5a(a5)
0be8: d154                 add.w      d0, (a4)
0bea: 508f                 addq.l     #$8, a7
0bec: 5346                 subq.w     #$1, d6
0bee: 558c                 subq.l     #$2, a4
0bf0: 5587                 subq.l     #$2, d7
0bf2: 4a46                 tst.w      d6
0bf4: 6c00fe30             bge.w      $a26
0bf8: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0bfc: 4e5e                 unlk       a6
0bfe: 4e75                 rts        
0c00: 4e56fffa             link.w     a6, #$fffa
0c04: 48e71f08             movem.l    d3-d7/a4, -(a7)
0c08: 3c2e0008             move.w     $8(a6), d6
0c0c: 3a2e000a             move.w     $a(a6), d5
0c10: 382e000c             move.w     $c(a6), d4
0c14: 3e2e000e             move.w     $e(a6), d7
0c18: 4a6e0010             tst.w      $10(a6)
0c1c: 6c04                 bge.b      $c22
0c1e: 4ead01a2             jsr        $1a2(a5)
0c22: 3006                 move.w     d6, d0
0c24: d045                 add.w      d5, d0
0c26: d06e0010             add.w      $10(a6), d0
0c2a: 5f40                 subq.w     #$7, d0
0c2c: 6f0a                 ble.b      $c38
0c2e: 7007                 moveq      #$7, d0
0c30: 9046                 sub.w      d6, d0
0c32: 9045                 sub.w      d5, d0
0c34: 3d400010             move.w     d0, $10(a6)
0c38: 4a45                 tst.w      d5
0c3a: 6608                 bne.b      $c44
0c3c: 4a46                 tst.w      d6
0c3e: 6604                 bne.b      $c44
0c40: 7000                 moveq      #$0, d0
0c42: 6078                 bra.b      $cbc
0c44: 3044                 movea.w    d4, a0
0c46: b1edf668             cmpa.l     -$998(a5), a0
0c4a: 6608                 bne.b      $c54
0c4c: 3047                 movea.w    d7, a0
0c4e: b1edf66c             cmpa.l     -$994(a5), a0
0c52: 671a                 beq.b      $c6e
0c54: 48780100             pea.l      $100.w
0c58: 486df568             pea.l      -$a98(a5)
0c5c: 4ead01aa             jsr        $1aa(a5)
0c60: 3044                 movea.w    d4, a0
0c62: 2b48f668             move.l     a0, -$998(a5)
0c66: 3247                 movea.w    d7, a1
0c68: 2b49f66c             move.l     a1, -$994(a5)
0c6c: 508f                 addq.l     #$8, a7
0c6e: 2005                 move.l     d5, d0
0c70: 48c0                 ext.l      d0
0c72: eb88                 lsl.l      #$5, d0
0c74: 49edf568             lea.l      -$a98(a5), a4
0c78: d08c                 add.l      a4, d0
0c7a: 2206                 move.l     d6, d1
0c7c: 48c1                 ext.l      d1
0c7e: e589                 lsl.l      #$2, d1
0c80: d280                 add.l      d0, d1
0c82: 2841                 movea.l    d1, a4
0c84: 4a94                 tst.l      (a4)
0c86: 6632                 bne.b      $cba
0c88: 3605                 move.w     d5, d3
0c8a: d646                 add.w      d6, d3
0c8c: d66e0010             add.w      $10(a6), d3
0c90: 3f03                 move.w     d3, -(a7)
0c92: 3f07                 move.w     d7, -(a7)
0c94: 3f04                 move.w     d4, -(a7)
0c96: 3f05                 move.w     d5, -(a7)
0c98: 3f06                 move.w     d6, -(a7)
0c9a: 4eba0114             jsr        $db0(pc)
0c9e: 2d40fffa             move.l     d0, -$6(a6)
0ca2: 3e83                 move.w     d3, (a7)
0ca4: 3f07                 move.w     d7, -(a7)
0ca6: 3f04                 move.w     d4, -(a7)
0ca8: 42a7                 clr.l      -(a7)
0caa: 4eba0104             jsr        $db0(pc)
0cae: 222efffa             move.l     -$6(a6), d1
0cb2: 9280                 sub.l      d0, d1
0cb4: 2881                 move.l     d1, (a4)
0cb6: 4fef0012             lea.l      $12(a7), a7
0cba: 2014                 move.l     (a4), d0
0cbc: 4cdf10f8             movem.l    (a7)+, d3-d7/a4
0cc0: 4e5e                 unlk       a6
0cc2: 4e75                 rts        
0cc4: 4e56fffc             link.w     a6, #$fffc
0cc8: 48e71f00             movem.l    d3-d7, -(a7)
0ccc: 3c2e0008             move.w     $8(a6), d6
0cd0: 382e000e             move.w     $e(a6), d4
0cd4: 3a2e0010             move.w     $10(a6), d5
0cd8: 0c6e0002000c         cmpi.w     #$2, $c(a6)
0cde: 6662                 bne.b      $d42
0ce0: 3f2e0012             move.w     $12(a6), -(a7)
0ce4: 3f05                 move.w     d5, -(a7)
0ce6: 3f04                 move.w     d4, -(a7)
0ce8: 7002                 moveq      #$2, d0
0cea: d06e000a             add.w      $a(a6), d0
0cee: 3f00                 move.w     d0, -(a7)
0cf0: 3f06                 move.w     d6, -(a7)
0cf2: 4ebaff0c             jsr        $c00(pc)
0cf6: 2e00                 move.l     d0, d7
0cf8: 3eae0012             move.w     $12(a6), (a7)
0cfc: 3f05                 move.w     d5, -(a7)
0cfe: 3f04                 move.w     d4, -(a7)
0d00: 7001                 moveq      #$1, d0
0d02: d06e000a             add.w      $a(a6), d0
0d06: 3f00                 move.w     d0, -(a7)
0d08: 7001                 moveq      #$1, d0
0d0a: d046                 add.w      d6, d0
0d0c: 3f00                 move.w     d0, -(a7)
0d0e: 4ebafef0             jsr        $c00(pc)
0d12: 2600                 move.l     d0, d3
0d14: be83                 cmp.l      d3, d7
0d16: 4fef0012             lea.l      $12(a7), a7
0d1a: 6c02                 bge.b      $d1e
0d1c: 2e03                 move.l     d3, d7
0d1e: 3f2e0012             move.w     $12(a6), -(a7)
0d22: 3f05                 move.w     d5, -(a7)
0d24: 3f04                 move.w     d4, -(a7)
0d26: 3f2e000a             move.w     $a(a6), -(a7)
0d2a: 7002                 moveq      #$2, d0
0d2c: d046                 add.w      d6, d0
0d2e: 3f00                 move.w     d0, -(a7)
0d30: 4ebafece             jsr        $c00(pc)
0d34: 2600                 move.l     d0, d3
0d36: be83                 cmp.l      d3, d7
0d38: 4fef000a             lea.l      $a(a7), a7
0d3c: 6c68                 bge.b      $da6
0d3e: 2e03                 move.l     d3, d7
0d40: 6064                 bra.b      $da6
0d42: 0c6e0001000c         cmpi.w     #$1, $c(a6)
0d48: 6644                 bne.b      $d8e
0d4a: 3f2e0012             move.w     $12(a6), -(a7)
0d4e: 3f05                 move.w     d5, -(a7)
0d50: 3f04                 move.w     d4, -(a7)
0d52: 7001                 moveq      #$1, d0
0d54: d06e000a             add.w      $a(a6), d0
0d58: 3f00                 move.w     d0, -(a7)
0d5a: 3f06                 move.w     d6, -(a7)
0d5c: 4ebafea2             jsr        $c00(pc)
0d60: 2e00                 move.l     d0, d7
0d62: 3eae0012             move.w     $12(a6), (a7)
0d66: 3f05                 move.w     d5, -(a7)
0d68: 3f04                 move.w     d4, -(a7)
0d6a: 3f2e000a             move.w     $a(a6), -(a7)
0d6e: 7001                 moveq      #$1, d0
0d70: d046                 add.w      d6, d0
0d72: 3f00                 move.w     d0, -(a7)
0d74: 4ebafe8a             jsr        $c00(pc)
0d78: 2600                 move.l     d0, d3
0d7a: de83                 add.l      d3, d7
0d7c: 7002                 moveq      #$2, d0
0d7e: 2e80                 move.l     d0, (a7)
0d80: 2f07                 move.l     d7, -(a7)
0d82: 4ead005a             jsr        $5a(a5)
0d86: 2e00                 move.l     d0, d7
0d88: 4fef000e             lea.l      $e(a7), a7
0d8c: 6018                 bra.b      $da6
0d8e: 3f2e0012             move.w     $12(a6), -(a7)
0d92: 3f05                 move.w     d5, -(a7)
0d94: 3f04                 move.w     d4, -(a7)
0d96: 3f2e000a             move.w     $a(a6), -(a7)
0d9a: 3f06                 move.w     d6, -(a7)
0d9c: 4ebafe62             jsr        $c00(pc)
0da0: 2e00                 move.l     d0, d7
0da2: 4fef000a             lea.l      $a(a7), a7
0da6: 2007                 move.l     d7, d0
0da8: 4cdf00f8             movem.l    (a7)+, d3-d7
0dac: 4e5e                 unlk       a6
0dae: 4e75                 rts        
0db0: 4e56fef0             link.w     a6, #$fef0
0db4: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0db8: 3c2e0010             move.w     $10(a6), d6
0dbc: 7e00                 moveq      #$0, d7
0dbe: 2006                 move.l     d6, d0
0dc0: 48c0                 ext.l      d0
0dc2: e588                 lsl.l      #$2, d0
0dc4: 49edd56c             lea.l      -$2a94(a5), a4
0dc8: d08c                 add.l      a4, d0
0dca: 2840                 movea.l    d0, a4
0dcc: 4878001c             pea.l      $1c.w
0dd0: 2f07                 move.l     d7, -(a7)
0dd2: 4ead0042             jsr        $42(a5)
0dd6: 2640                 movea.l    d0, a3
0dd8: 2007                 move.l     d7, d0
0dda: eb88                 lsl.l      #$5, d0
0ddc: 45eeff00             lea.l      -$100(a6), a2
0de0: d08a                 add.l      a2, d0
0de2: 2440                 movea.l    d0, a2
0de4: 601a                 bra.b      $e00
0de6: 2014                 move.l     (a4), d0
0de8: 3046                 movea.w    d6, a0
0dea: 91c7                 suba.l     d7, a0
0dec: 2208                 move.l     a0, d1
0dee: e589                 lsl.l      #$2, d1
0df0: 25b308181800         move.l     $18(a3, d0.l), (a2, d1.l)
0df6: 5287                 addq.l     #$1, d7
0df8: 47eb001c             lea.l      $1c(a3), a3
0dfc: 45ea0020             lea.l      $20(a2), a2
0e00: 3046                 movea.w    d6, a0
0e02: b1c7                 cmpa.l     d7, a0
0e04: 6ce0                 bge.b      $de6
0e06: 2e06                 move.l     d6, d7
0e08: 5347                 subq.w     #$1, d7
0e0a: 48c7                 ext.l      d7
0e0c: 3c2e000a             move.w     $a(a6), d6
0e10: dc6e0008             add.w      $8(a6), d6
0e14: 600000ba             bra.w      $ed0
0e18: 362e000a             move.w     $a(a6), d3
0e1c: 48c3                 ext.l      d3
0e1e: 306e0008             movea.w    $8(a6), a0
0e22: 2007                 move.l     d7, d0
0e24: 9088                 sub.l      a0, d0
0e26: 2d40fefc             move.l     d0, -$104(a6)
0e2a: 306e000c             movea.w    $c(a6), a0
0e2e: 91c7                 suba.l     d7, a0
0e30: 2d48fef8             move.l     a0, -$108(a6)
0e34: 2203                 move.l     d3, d1
0e36: eb89                 lsl.l      #$5, d1
0e38: 49eeff00             lea.l      -$100(a6), a4
0e3c: d28c                 add.l      a4, d1
0e3e: 2841                 movea.l    d1, a4
0e40: 60000084             bra.w      $ec6
0e44: 306e000e             movea.w    $e(a6), a0
0e48: 91c3                 suba.l     d3, a0
0e4a: d0ee000a             adda.w     $a(a6), a0
0e4e: 2808                 move.l     a0, d4
0e50: 4a84                 tst.l      d4
0e52: 6c02                 bge.b      $e56
0e54: 7800                 moveq      #$0, d4
0e56: 2a03                 move.l     d3, d5
0e58: daaefef8             add.l      -$108(a6), d5
0e5c: 306e0008             movea.w    $8(a6), a0
0e60: da88                 add.l      a0, d5
0e62: 4a85                 tst.l      d5
0e64: 6c02                 bge.b      $e68
0e66: 7a00                 moveq      #$0, d5
0e68: 2004                 move.l     d4, d0
0e6a: d085                 add.l      d5, d0
0e6c: 6604                 bne.b      $e72
0e6e: 7801                 moveq      #$1, d4
0e70: 7a01                 moveq      #$1, d5
0e72: 2007                 move.l     d7, d0
0e74: 9083                 sub.l      d3, d0
0e76: e588                 lsl.l      #$2, d0
0e78: 2640                 movea.l    d0, a3
0e7a: 2007                 move.l     d7, d0
0e7c: 9083                 sub.l      d3, d0
0e7e: 2d40fef0             move.l     d0, -$110(a6)
0e82: 2204                 move.l     d4, d1
0e84: d285                 add.l      d5, d1
0e86: 2f01                 move.l     d1, -(a7)
0e88: 2f04                 move.l     d4, -(a7)
0e8a: 2203                 move.l     d3, d1
0e8c: 5281                 addq.l     #$1, d1
0e8e: eb89                 lsl.l      #$5, d1
0e90: 41eeff00             lea.l      -$100(a6), a0
0e94: d288                 add.l      a0, d1
0e96: 2f331800             move.l     (a3, d1.l), -(a7)
0e9a: 4ead0042             jsr        $42(a5)
0e9e: 2f05                 move.l     d5, -(a7)
0ea0: 222efef0             move.l     -$110(a6), d1
0ea4: e589                 lsl.l      #$2, d1
0ea6: 2f341804             move.l     $4(a4, d1.l), -(a7)
0eaa: 2200                 move.l     d0, d1
0eac: 4ead0042             jsr        $42(a5)
0eb0: c141                 exg.l      d0, d1
0eb2: d081                 add.l      d1, d0
0eb4: 2f00                 move.l     d0, -(a7)
0eb6: 4ead005a             jsr        $5a(a5)
0eba: 204c                 movea.l    a4, a0
0ebc: d1cb                 adda.l     a3, a0
0ebe: 2080                 move.l     d0, (a0)
0ec0: 5283                 addq.l     #$1, d3
0ec2: 49ec0020             lea.l      $20(a4), a4
0ec6: b6aefefc             cmp.l      -$104(a6), d3
0eca: 6f00ff78             ble.w      $e44
0ece: 5387                 subq.l     #$1, d7
0ed0: 3046                 movea.w    d6, a0
0ed2: b1c7                 cmpa.l     d7, a0
0ed4: 6f00ff42             ble.w      $e18
0ed8: 302e000a             move.w     $a(a6), d0
0edc: 48c0                 ext.l      d0
0ede: eb88                 lsl.l      #$5, d0
0ee0: d08e                 add.l      a6, d0
0ee2: 2040                 movea.l    d0, a0
0ee4: 302e0008             move.w     $8(a6), d0
0ee8: 48c0                 ext.l      d0
0eea: e588                 lsl.l      #$2, d0
0eec: d1c0                 adda.l     d0, a0
0eee: 2028ff00             move.l     -$100(a0), d0
0ef2: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0ef6: 4e5e                 unlk       a6
0ef8: 4e75                 rts        
0efa: 4e56ff5c             link.w     a6, #$ff5c
0efe: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0f02: 486eff76             pea.l      -$8a(a6)
0f06: 486eff78             pea.l      -$88(a6)
0f0a: 486eff7a             pea.l      -$86(a6)
0f0e: 486eff72             pea.l      -$8e(a6)
0f12: 4ebaf9a8             jsr        $8bc(pc)
0f16: 102dce79             move.b     -$3187(a5), d0
0f1a: 4880                 ext.w      d0
0f1c: 204d                 movea.l    a5, a0
0f1e: d0c0                 adda.w     d0, a0
0f20: d0c0                 adda.w     d0, a0
0f22: 3028f702             move.w     -$8fe(a0), d0
0f26: 48c0                 ext.l      d0
0f28: d1aeff72             add.l      d0, -$8e(a6)
0f2c: 486eff6e             pea.l      -$92(a6)
0f30: 486df686             pea.l      -$97a(a5)
0f34: 4eba078a             jsr        $16c0(pc)
0f38: 3040                 movea.w    d0, a0
0f3a: 2d48ff6a             move.l     a0, -$96(a6)
0f3e: 7a7f                 moveq      #$7f, d5
0f40: 49edbcf2             lea.l      -$430e(a5), a4
0f44: 47edccf8             lea.l      -$3308(a5), a3
0f48: 4fef0018             lea.l      $18(a7), a7
0f4c: 60000200             bra.w      $114e
0f50: 426eff64             clr.w      -$9c(a6)
0f54: 426eff66             clr.w      -$9a(a6)
0f58: 426eff5e             clr.w      -$a2(a6)
0f5c: 426eff5c             clr.w      -$a4(a6)
0f60: 426eff68             clr.w      -$98(a6)
0f64: 41edcdfc             lea.l      -$3204(a5), a0
0f68: 2e08                 move.l     a0, d7
0f6a: 45eeff7c             lea.l      -$84(a6), a2
0f6e: 7600                 moveq      #$0, d3
0f70: 41ed99d6             lea.l      -$662a(a5), a0
0f74: 2d48ff60             move.l     a0, -$a0(a6)
0f78: 6070                 bra.b      $fea
0f7a: 206eff60             movea.l    -$a0(a6), a0
0f7e: 2005                 move.l     d5, d0
0f80: 48c0                 ext.l      d0
0f82: c090                 and.l      (a0), d0
0f84: 675c                 beq.b      $fe2
0f86: 14c4                 move.b     d4, (a2)+
0f88: 3f04                 move.w     d4, -(a7)
0f8a: 4ead07d2             jsr        $7d2(a5)
0f8e: 4a40                 tst.w      d0
0f90: 548f                 addq.l     #$2, a7
0f92: 6712                 beq.b      $fa6
0f94: 0c440075             cmpi.w     #$75, d4
0f98: 6606                 bne.b      $fa0
0f9a: 3d7c0001ff5c         move.w     #$1, -$a4(a6)
0fa0: 526eff5e             addq.w     #$1, -$a2(a6)
0fa4: 601c                 bra.b      $fc2
0fa6: 0c44003f             cmpi.w     #$3f, d4
0faa: 6712                 beq.b      $fbe
0fac: 0c440071             cmpi.w     #$71, d4
0fb0: 6606                 bne.b      $fb8
0fb2: 3d7c0001ff68         move.w     #$1, -$98(a6)
0fb8: 526eff66             addq.w     #$1, -$9a(a6)
0fbc: 6004                 bra.b      $fc2
0fbe: 526eff64             addq.w     #$1, -$9c(a6)
0fc2: 2047                 movea.l    d7, a0
0fc4: 10280001             move.b     $1(a0), d0
0fc8: 4880                 ext.w      d0
0fca: b044                 cmp.w      d4, d0
0fcc: 6614                 bne.b      $fe2
0fce: 204d                 movea.l    a5, a0
0fd0: 2003                 move.l     d3, d0
0fd2: 48c0                 ext.l      d0
0fd4: e588                 lsl.l      #$2, d0
0fd6: d1c0                 adda.l     d0, a0
0fd8: 2005                 move.l     d5, d0
0fda: 48c0                 ext.l      d0
0fdc: c0a899da             and.l      -$6626(a0), d0
0fe0: 6712                 beq.b      $ff4
0fe2: 5243                 addq.w     #$1, d3
0fe4: 58aeff60             addq.l     #$4, -$a0(a6)
0fe8: 5287                 addq.l     #$1, d7
0fea: 2047                 movea.l    d7, a0
0fec: 1810                 move.b     (a0), d4
0fee: 4884                 ext.w      d4
0ff0: 4a44                 tst.w      d4
0ff2: 6686                 bne.b      $f7a
0ff4: 4a44                 tst.w      d4
0ff6: 66000150             bne.w      $1148
0ffa: 4212                 clr.b      (a2)
0ffc: 302dccfa             move.w     -$3306(a5), d0
1000: 526dccfa             addq.w     #$1, -$3306(a5)
1004: 204d                 movea.l    a5, a0
1006: d0c0                 adda.w     d0, a0
1008: d0c0                 adda.w     d0, a0
100a: 3145ccfc             move.w     d5, -$3304(a0)
100e: 0c6d0007cf06         cmpi.w     #$7, -$30fa(a5)
1014: 6e42                 bgt.b      $1058
1016: 4253                 clr.w      (a3)
1018: 45eeff7c             lea.l      -$84(a6), a2
101c: 600e                 bra.b      $102c
101e: 204d                 movea.l    a5, a0
1020: d0c4                 adda.w     d4, a0
1022: d0c4                 adda.w     d4, a0
1024: 30289412             move.w     -$6bee(a0), d0
1028: d153                 add.w      d0, (a3)
102a: 528a                 addq.l     #$1, a2
102c: 1812                 move.b     (a2), d4
102e: 4884                 ext.w      d4
1030: 4a44                 tst.w      d4
1032: 66ea                 bne.b      $101e
1034: 4a2eff7c             tst.b      -$84(a6)
1038: 660c                 bne.b      $1046
103a: 302eff7a             move.w     -$86(a6), d0
103e: d040                 add.w      d0, d0
1040: 3880                 move.w     d0, (a4)
1042: 60000104             bra.w      $1148
1046: 3013                 move.w     (a3), d0
1048: d040                 add.w      d0, d0
104a: 322eff7a             move.w     -$86(a6), d1
104e: 4441                 neg.w      d1
1050: 9240                 sub.w      d0, d1
1052: 3881                 move.w     d1, (a4)
1054: 600000f2             bra.w      $1148
1058: 486eff7c             pea.l      -$84(a6)
105c: 4ead0dc2             jsr        $dc2(a5)
1060: 7607                 moveq      #$7, d3
1062: 9640                 sub.w      d0, d3
1064: 7cf9                 moveq      #$f9, d6
1066: dc6dcf06             add.w      -$30fa(a5), d6
106a: bc43                 cmp.w      d3, d6
106c: 588f                 addq.l     #$4, a7
106e: 6c04                 bge.b      $1074
1070: 3006                 move.w     d6, d0
1072: 6002                 bra.b      $1076
1074: 3003                 move.w     d3, d0
1076: 3600                 move.w     d0, d3
1078: 486eff6e             pea.l      -$92(a6)
107c: 486eff7c             pea.l      -$84(a6)
1080: 4eba05ca             jsr        $164c(pc)
1084: 3c00                 move.w     d0, d6
1086: 508f                 addq.l     #$8, a7
1088: 6722                 beq.b      $10ac
108a: 206eff6e             movea.l    -$92(a6), a0
108e: 2010                 move.l     (a0), d0
1090: b0adb1d8             cmp.l      -$4e28(a5), d0
1094: 6e16                 bgt.b      $10ac
1096: 52adb1dc             addq.l     #$1, -$4e24(a5)
109a: 206eff6e             movea.l    -$92(a6), a0
109e: 20adb1dc             move.l     -$4e24(a5), (a0)
10a2: 3f06                 move.w     d6, -(a7)
10a4: 3f05                 move.w     d5, -(a7)
10a6: 4eba083c             jsr        $18e4(pc)
10aa: 588f                 addq.l     #$4, a7
10ac: 3f03                 move.w     d3, -(a7)
10ae: 3f2eff76             move.w     -$8a(a6), -(a7)
10b2: 3f2eff78             move.w     -$88(a6), -(a7)
10b6: 3f2eff64             move.w     -$9c(a6), -(a7)
10ba: 3f2eff66             move.w     -$9a(a6), -(a7)
10be: 3f2eff5e             move.w     -$a2(a6), -(a7)
10c2: 4ebafc00             jsr        $cc4(pc)
10c6: 3c00                 move.w     d0, d6
10c8: d154                 add.w      d0, (a4)
10ca: 4a6eff68             tst.w      -$98(a6)
10ce: 4fef000c             lea.l      $c(a7), a7
10d2: 6720                 beq.b      $10f4
10d4: 4a6eff5c             tst.w      -$a4(a6)
10d8: 661a                 bne.b      $10f4
10da: 700a                 moveq      #$a, d0
10dc: c1c3                 muls.w     d3, d0
10de: 122dce79             move.b     -$3187(a5), d1
10e2: 4881                 ext.w      d1
10e4: 41edf6da             lea.l      -$926(a5), a0
10e8: d088                 add.l      a0, d0
10ea: 3041                 movea.w    d1, a0
10ec: d1c8                 adda.l     a0, a0
10ee: 30300800             move.w     (a0, d0.l), d0
10f2: d154                 add.w      d0, (a4)
10f4: 4a6eff5c             tst.w      -$a4(a6)
10f8: 6734                 beq.b      $112e
10fa: 4a2dce75             tst.b      -$318b(a5)
10fe: 672e                 beq.b      $112e
1100: 306dcf06             movea.w    -$30fa(a5), a0
1104: 2f08                 move.l     a0, -(a7)
1106: 102dce79             move.b     -$3187(a5), d0
110a: 4880                 ext.w      d0
110c: 204d                 movea.l    a5, a0
110e: d0c0                 adda.w     d0, a0
1110: d0c0                 adda.w     d0, a0
1112: 3068f702             movea.w    -$8fe(a0), a0
1116: 202eff6a             move.l     -$96(a6), d0
111a: 9088                 sub.l      a0, d0
111c: 2f00                 move.l     d0, -(a7)
111e: 3043                 movea.w    d3, a0
1120: 2f08                 move.l     a0, -(a7)
1122: 4ead0042             jsr        $42(a5)
1126: 2f00                 move.l     d0, -(a7)
1128: 4ead005a             jsr        $5a(a5)
112c: d154                 add.w      d0, (a4)
112e: 306dcf06             movea.w    -$30fa(a5), a0
1132: 2f08                 move.l     a0, -(a7)
1134: 3043                 movea.w    d3, a0
1136: 2f08                 move.l     a0, -(a7)
1138: 2f2eff72             move.l     -$8e(a6), -(a7)
113c: 4ead0042             jsr        $42(a5)
1140: 2f00                 move.l     d0, -(a7)
1142: 4ead005a             jsr        $5a(a5)
1146: d154                 add.w      d0, (a4)
1148: 5345                 subq.w     #$1, d5
114a: 558c                 subq.l     #$2, a4
114c: 558b                 subq.l     #$2, a3
114e: 4a45                 tst.w      d5
1150: 6c00fdfe             bge.w      $f50
1154: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
1158: 4e5e                 unlk       a6
115a: 4e75                 rts        
115c: 48e70718             movem.l    d5-d7/a3-a4, -(a7)
1160: 48780100             pea.l      $100.w
1164: 486dccfc             pea.l      -$3304(a5)
1168: 4ead01aa             jsr        $1aa(a5)
116c: 426dccfa             clr.w      -$3306(a5)
1170: 48780100             pea.l      $100.w
1174: 486dcbfa             pea.l      -$3406(a5)
1178: 4ead01aa             jsr        $1aa(a5)
117c: 4ebaf6a6             jsr        $824(pc)
1180: 7c7f                 moveq      #$7f, d6
1182: 4fef0010             lea.l      $10(a7), a7
1186: 6054                 bra.b      $11dc
1188: 49edcdfc             lea.l      -$3204(a5), a4
118c: 7e00                 moveq      #$0, d7
118e: 47ed99d6             lea.l      -$662a(a5), a3
1192: 6026                 bra.b      $11ba
1194: 2006                 move.l     d6, d0
1196: 48c0                 ext.l      d0
1198: c09b                 and.l      (a3)+, d0
119a: 671c                 beq.b      $11b8
119c: ba2c0001             cmp.b      $1(a4), d5
11a0: 6608                 bne.b      $11aa
11a2: 2006                 move.l     d6, d0
11a4: 48c0                 ext.l      d0
11a6: c093                 and.l      (a3), d0
11a8: 6730                 beq.b      $11da
11aa: 1005                 move.b     d5, d0
11ac: 4880                 ext.w      d0
11ae: 204d                 movea.l    a5, a0
11b0: d0c0                 adda.w     d0, a0
11b2: d0c0                 adda.w     d0, a0
11b4: de689412             add.w      -$6bee(a0), d7
11b8: 528c                 addq.l     #$1, a4
11ba: 1a14                 move.b     (a4), d5
11bc: 66d6                 bne.b      $1194
11be: 302dccfa             move.w     -$3306(a5), d0
11c2: 526dccfa             addq.w     #$1, -$3306(a5)
11c6: 204d                 movea.l    a5, a0
11c8: d0c0                 adda.w     d0, a0
11ca: d0c0                 adda.w     d0, a0
11cc: 3146ccfc             move.w     d6, -$3304(a0)
11d0: 204d                 movea.l    a5, a0
11d2: d0c6                 adda.w     d6, a0
11d4: d0c6                 adda.w     d6, a0
11d6: 3147cbfa             move.w     d7, -$3406(a0)
11da: 5346                 subq.w     #$1, d6
11dc: 4a46                 tst.w      d6
11de: 6ca8                 bge.b      $1188
11e0: 4cdf18e0             movem.l    (a7)+, d5-d7/a3-a4
11e4: 4e75                 rts        
11e6: 4e56ffee             link.w     a6, #$ffee
11ea: 48e70738             movem.l    d5-d7/a2-a4, -(a7)
11ee: 7e00                 moveq      #$0, d7
11f0: 49edccfc             lea.l      -$3304(a5), a4
11f4: 603a                 bra.b      $1230
11f6: 3c14                 move.w     (a4), d6
11f8: 47eeffee             lea.l      -$12(a6), a3
11fc: 7a01                 moveq      #$1, d5
11fe: 246e0008             movea.l    $8(a6), a2
1202: 600c                 bra.b      $1210
1204: 3006                 move.w     d6, d0
1206: c045                 and.w      d5, d0
1208: 6702                 beq.b      $120c
120a: 16d2                 move.b     (a2), (a3)+
120c: 528a                 addq.l     #$1, a2
120e: da45                 add.w      d5, d5
1210: 4a12                 tst.b      (a2)
1212: 66f0                 bne.b      $1204
1214: 4213                 clr.b      (a3)
1216: 2f2e000c             move.l     $c(a6), -(a7)
121a: 486effee             pea.l      -$12(a6)
121e: 4ead0db2             jsr        $db2(a5)
1222: 4a40                 tst.w      d0
1224: 508f                 addq.l     #$8, a7
1226: 6604                 bne.b      $122c
1228: 3006                 move.w     d6, d0
122a: 600e                 bra.b      $123a
122c: 5247                 addq.w     #$1, d7
122e: 548c                 addq.l     #$2, a4
1230: be6dccfa             cmp.w      -$3306(a5), d7
1234: 6dc0                 blt.b      $11f6
1236: 4ead01a2             jsr        $1a2(a5)
123a: 4cdf1ce0             movem.l    (a7)+, d5-d7/a2-a4
123e: 4e5e                 unlk       a6
1240: 4e75                 rts        
1242: 4e560000             link.w     a6, #$0
1246: 48e70f18             movem.l    d4-d7/a3-a4, -(a7)
124a: 3e2e0008             move.w     $8(a6), d7
124e: 3c2e000a             move.w     $a(a6), d6
1252: 3007                 move.w     d7, d0
1254: 8046                 or.w       d6, d0
1256: be40                 cmp.w      d0, d7
1258: 6704                 beq.b      $125e
125a: 4ead01a2             jsr        $1a2(a5)
125e: 3006                 move.w     d6, d0
1260: 4640                 not.w      d0
1262: c047                 and.w      d7, d0
1264: 3c00                 move.w     d0, d6
1266: 7a00                 moveq      #$0, d5
1268: 3e05                 move.w     d5, d7
126a: 49edcdfc             lea.l      -$3204(a5), a4
126e: 2007                 move.l     d7, d0
1270: 48c0                 ext.l      d0
1272: e588                 lsl.l      #$2, d0
1274: 47ed99d6             lea.l      -$662a(a5), a3
1278: d08b                 add.l      a3, d0
127a: 2640                 movea.l    d0, a3
127c: 1814                 move.b     (a4), d4
127e: 4a04                 tst.b      d4
1280: 6742                 beq.b      $12c4
1282: 8a6b0002             or.w       $2(a3), d5
1286: b82c0001             cmp.b      $1(a4), d4
128a: 6730                 beq.b      $12bc
128c: 3806                 move.w     d6, d4
128e: c845                 and.w      d5, d4
1290: 6728                 beq.b      $12ba
1292: 3005                 move.w     d5, d0
1294: 4640                 not.w      d0
1296: cc40                 and.w      d0, d6
1298: 4a44                 tst.w      d4
129a: 6604                 bne.b      $12a0
129c: 4ead01a2             jsr        $1a2(a5)
12a0: 0c440080             cmpi.w     #$80, d4
12a4: 6d04                 blt.b      $12aa
12a6: 4ead01a2             jsr        $1a2(a5)
12aa: d844                 add.w      d4, d4
12ac: 3004                 move.w     d4, d0
12ae: c045                 and.w      d5, d0
12b0: b840                 cmp.w      d0, d4
12b2: 67e4                 beq.b      $1298
12b4: 3004                 move.w     d4, d0
12b6: e240                 asr.w      #$1, d0
12b8: 8c40                 or.w       d0, d6
12ba: 7a00                 moveq      #$0, d5
12bc: 528c                 addq.l     #$1, a4
12be: 5247                 addq.w     #$1, d7
12c0: 588b                 addq.l     #$4, a3
12c2: 60b8                 bra.b      $127c
12c4: 3006                 move.w     d6, d0
12c6: 4cdf18f0             movem.l    (a7)+, d4-d7/a3-a4
12ca: 4e5e                 unlk       a6
12cc: 4e75                 rts        
12ce: 4e560000             link.w     a6, #$0
12d2: 48e70f00             movem.l    d4-d7, -(a7)
12d6: 382e0008             move.w     $8(a6), d4
12da: 3c2e000a             move.w     $a(a6), d6
12de: 3e2e000c             move.w     $c(a6), d7
12e2: 4647                 not.w      d7
12e4: 600c                 bra.b      $12f2
12e6: 3a04                 move.w     d4, d5
12e8: 8846                 or.w       d6, d4
12ea: 3005                 move.w     d5, d0
12ec: c047                 and.w      d7, d0
12ee: cc40                 and.w      d0, d6
12f0: e246                 asr.w      #$1, d6
12f2: 4a46                 tst.w      d6
12f4: 66f0                 bne.b      $12e6
12f6: 3007                 move.w     d7, d0
12f8: 4640                 not.w      d0
12fa: 8044                 or.w       d4, d0
12fc: 4cdf00f0             movem.l    (a7)+, d4-d7
1300: 4e5e                 unlk       a6
1302: 4e75                 rts        
1304: 4e56fe5a             link.w     a6, #$fe5a
1308: 48e70f18             movem.l    d4-d7/a3-a4, -(a7)
130c: 486efe5e             pea.l      -$1a2(a6)
1310: 4ead095a             jsr        $95a(a5)
1314: 3e00                 move.w     d0, d7
1316: 5f47                 subq.w     #$7, d7
1318: 7022                 moveq      #$22, d0
131a: 2e80                 move.l     d0, (a7)
131c: 486effde             pea.l      -$22(a6)
1320: 4ead01aa             jsr        $1aa(a5)
1324: 422efe5f             clr.b      -$1a1(a6)
1328: 286dc376             movea.l    -$3c8a(a5), a4
132c: 508f                 addq.l     #$8, a7
132e: 601e                 bra.b      $134e
1330: 486efe5a             pea.l      -$1a6(a6)
1334: 486efe5e             pea.l      -$1a2(a6)
1338: 4eba0312             jsr        $164c(pc)
133c: 1214                 move.b     (a4), d1
133e: 4881                 ext.w      d1
1340: 204e                 movea.l    a6, a0
1342: d0c1                 adda.w     d1, a0
1344: d0c1                 adda.w     d1, a0
1346: 3140fede             move.w     d0, -$122(a0)
134a: 508f                 addq.l     #$8, a7
134c: 528c                 addq.l     #$1, a4
134e: 1d54fe5e             move.b     (a4), -$1a2(a6)
1352: 66dc                 bne.b      $1330
1354: 7c00                 moveq      #$0, d6
1356: 47edccfc             lea.l      -$3304(a5), a3
135a: 60000092             bra.w      $13ee
135e: 3d53fffc             move.w     (a3), -$4(a6)
1362: 3f2efffc             move.w     -$4(a6), -(a7)
1366: 4ebaf458             jsr        $7c0(pc)
136a: 204d                 movea.l    a5, a0
136c: 302efffc             move.w     -$4(a6), d0
1370: d0c0                 adda.w     d0, a0
1372: d0c0                 adda.w     d0, a0
1374: 3028bbf4             move.w     -$440c(a0), d0
1378: d06da54c             add.w      -$5ab4(a5), d0
137c: 3040                 movea.w    d0, a0
137e: 2d48fff2             move.l     a0, -$e(a6)
1382: 3eaefffc             move.w     -$4(a6), (a7)
1386: 3f3c007f             move.w     #$7f, -(a7)
138a: 4ebafeb6             jsr        $1242(pc)
138e: 3e80                 move.w     d0, (a7)
1390: 4ebaf2be             jsr        $650(pc)
1394: 2e80                 move.l     d0, (a7)
1396: 486effde             pea.l      -$22(a6)
139a: 4ead0da2             jsr        $da2(a5)
139e: 7a00                 moveq      #$0, d5
13a0: 49eeffde             lea.l      -$22(a6), a4
13a4: 508f                 addq.l     #$8, a7
13a6: 1814                 move.b     (a4), d4
13a8: 4a04                 tst.b      d4
13aa: 6712                 beq.b      $13be
13ac: 1004                 move.b     d4, d0
13ae: 4880                 ext.w      d0
13b0: 204e                 movea.l    a6, a0
13b2: d0c0                 adda.w     d0, a0
13b4: d0c0                 adda.w     d0, a0
13b6: 9a68fede             sub.w      -$122(a0), d5
13ba: 528c                 addq.l     #$1, a4
13bc: 60e8                 bra.b      $13a6
13be: da45                 add.w      d5, d5
13c0: 48c5                 ext.l      d5
13c2: 8bc7                 divs.w     d7, d5
13c4: 4a2dbd8e             tst.b      -$4272(a5)
13c8: 660e                 bne.b      $13d8
13ca: 206dd568             movea.l    -$2a98(a5), a0
13ce: 3028001a             move.w     $1a(a0), d0
13d2: 906800a6             sub.w      $a6(a0), d0
13d6: da40                 add.w      d0, d5
13d8: 3045                 movea.w    d5, a0
13da: 2d48fff6             move.l     a0, -$a(a6)
13de: 486effde             pea.l      -$22(a6)
13e2: 206e0008             movea.l    $8(a6), a0
13e6: 4e90                 jsr        (a0)
13e8: 588f                 addq.l     #$4, a7
13ea: 5246                 addq.w     #$1, d6
13ec: 548b                 addq.l     #$2, a3
13ee: bc6dccfa             cmp.w      -$3306(a5), d6
13f2: 6d00ff6a             blt.w      $135e
13f6: 4a6dcf04             tst.w      -$30fc(a5)
13fa: 6706                 beq.b      $1402
13fc: 3b7c0001cf04         move.w     #$1, -$30fc(a5)
1402: 4cdf18f0             movem.l    (a7)+, d4-d7/a3-a4
1406: 4e5e                 unlk       a6
1408: 4e75                 rts        
140a: 4e56ffce             link.w     a6, #$ffce
140e: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
1412: 3a2e0008             move.w     $8(a6), d5
1416: 3c2e000a             move.w     $a(a6), d6
141a: 0c460007             cmpi.w     #$7, d6
141e: 6c06                 bge.b      $1426
1420: 7000                 moveq      #$0, d0
1422: 60000220             bra.w      $1644
1426: 0c45003f             cmpi.w     #$3f, d5
142a: 6604                 bne.b      $1430
142c: 7000                 moveq      #$0, d0
142e: 6004                 bra.b      $1434
1430: 70a0                 moveq      #$a0, d0
1432: d045                 add.w      d5, d0
1434: 3a00                 move.w     d0, d5
1436: 4aadf670             tst.l      -$990(a5)
143a: 660000d0             bne.w      $150c
143e: 48781f90             pea.l      $1f90.w
1442: 4ead0682             jsr        $682(a5)
1446: 2b40f670             move.l     d0, -$990(a5)
144a: 4a80                 tst.l      d0
144c: 588f                 addq.l     #$4, a7
144e: 6604                 bne.b      $1454
1450: 4ead01a2             jsr        $1a2(a5)
1454: 7801                 moveq      #$1, d4
1456: 387c000a             movea.w    #$a, a4
145a: 6016                 bra.b      $1472
145c: 204c                 movea.l    a4, a0
145e: d1edf670             adda.l     -$990(a5), a0
1462: 42a80006             clr.l      $6(a0)
1466: 42a80002             clr.l      $2(a0)
146a: 4250                 clr.w      (a0)
146c: 5244                 addq.w     #$1, d4
146e: 49ec000a             lea.l      $a(a4), a4
1472: 0c440008             cmpi.w     #$8, d4
1476: 6de4                 blt.b      $145c
1478: 7800                 moveq      #$0, d4
147a: 99cc                 suba.l     a4, a4
147c: 601c                 bra.b      $149a
147e: 204c                 movea.l    a4, a0
1480: d1edf670             adda.l     -$990(a5), a0
1484: 42a80006             clr.l      $6(a0)
1488: 217c800000000002     move.l     #$80000000, $2(a0)
1490: 30bc3fff             move.w     #$3fff, (a0)
1494: 5244                 addq.w     #$1, d4
1496: 49ec0050             lea.l      $50(a4), a4
149a: 0c440065             cmpi.w     #$65, d4
149e: 6dde                 blt.b      $147e
14a0: 7801                 moveq      #$1, d4
14a2: 387c0050             movea.w    #$50, a4
14a6: 605e                 bra.b      $1506
14a8: 7601                 moveq      #$1, d3
14aa: 70ff                 moveq      #$ff, d0
14ac: d044                 add.w      d4, d0
14ae: c1fc0050             muls.w     #$50, d0
14b2: d0adf670             add.l      -$990(a5), d0
14b6: 2640                 movea.l    d0, a3
14b8: 700a                 moveq      #$a, d0
14ba: c1c3                 muls.w     d3, d0
14bc: 2440                 movea.l    d0, a2
14be: 603a                 bra.b      $14fa
14c0: 70ff                 moveq      #$ff, d0
14c2: d043                 add.w      d3, d0
14c4: c1fc000a             muls.w     #$a, d0
14c8: 204b                 movea.l    a3, a0
14ca: d1ca                 adda.l     a2, a0
14cc: 43eeffd2             lea.l      -$2e(a6), a1
14d0: 22d8                 move.l     (a0)+, (a1)+
14d2: 22d8                 move.l     (a0)+, (a1)+
14d4: 32d8                 move.w     (a0)+, (a1)+
14d6: 48730800             pea.l      (a3, d0.l)
14da: 4869fff6             pea.l      -$a(a1)
14de: 4267                 clr.w      -(a7)
14e0: a9eb                 dc.w       $a9eb
14e2: 204c                 movea.l    a4, a0
14e4: d1edf670             adda.l     -$990(a5), a0
14e8: d1ca                 adda.l     a2, a0
14ea: 43e9fff6             lea.l      -$a(a1), a1
14ee: 20d9                 move.l     (a1)+, (a0)+
14f0: 20d9                 move.l     (a1)+, (a0)+
14f2: 30d9                 move.w     (a1)+, (a0)+
14f4: 5243                 addq.w     #$1, d3
14f6: 45ea000a             lea.l      $a(a2), a2
14fa: 0c430008             cmpi.w     #$8, d3
14fe: 6dc0                 blt.b      $14c0
1500: 5244                 addq.w     #$1, d4
1502: 49ec0050             lea.l      $50(a4), a4
1506: 0c440065             cmpi.w     #$65, d4
150a: 6d9c                 blt.b      $14a8
150c: 42aefff2             clr.l      -$e(a6)
1510: 42aeffee             clr.l      -$12(a6)
1514: 426effec             clr.w      -$14(a6)
1518: 42aeffe8             clr.l      -$18(a6)
151c: 42aeffe4             clr.l      -$1c(a6)
1520: 426effe2             clr.w      -$1e(a6)
1524: 78f9                 moveq      #$f9, d4
1526: d846                 add.w      d6, d4
1528: 0c440006             cmpi.w     #$6, d4
152c: 6c04                 bge.b      $1532
152e: 3004                 move.w     d4, d0
1530: 6002                 bra.b      $1534
1532: 7006                 moveq      #$6, d0
1534: 3600                 move.w     d0, d3
1536: 9c6e000c             sub.w      $c(a6), d6
153a: 7800                 moveq      #$0, d4
153c: 7050                 moveq      #$50, d0
153e: c1ee000c             muls.w     $c(a6), d0
1542: d0adf670             add.l      -$990(a5), d0
1546: 2840                 movea.l    d0, a4
1548: 7050                 moveq      #$50, d0
154a: c1c6                 muls.w     d6, d0
154c: d0adf670             add.l      -$990(a5), d0
1550: 2640                 movea.l    d0, a3
1552: 204d                 movea.l    a5, a0
1554: 2005                 move.l     d5, d0
1556: 48c0                 ext.l      d0
1558: e588                 lsl.l      #$2, d0
155a: d1c0                 adda.l     d0, a0
155c: 2468d58c             movea.l    -$2a74(a0), a2
1560: 204d                 movea.l    a5, a0
1562: 2005                 move.l     d5, d0
1564: 48c0                 ext.l      d0
1566: e588                 lsl.l      #$2, d0
1568: d1c0                 adda.l     d0, a0
156a: 2068d58c             movea.l    -$2a74(a0), a0
156e: 2d680018ffdc         move.l     $18(a0), -$24(a6)
1574: 7e0a                 moveq      #$a, d7
1576: cfc4                 muls.w     d4, d7
1578: 60000082             bra.w      $15fc
157c: 3003                 move.w     d3, d0
157e: 9044                 sub.w      d4, d0
1580: c1fc000a             muls.w     #$a, d0
1584: 41eeffd2             lea.l      -$2e(a6), a0
1588: 43f47800             lea.l      (a4, d7.l), a1
158c: 20d9                 move.l     (a1)+, (a0)+
158e: 20d9                 move.l     (a1)+, (a0)+
1590: 30d9                 move.w     (a1)+, (a0)+
1592: 48730800             pea.l      (a3, d0.l)
1596: 4868fff6             pea.l      -$a(a0)
159a: 3f3c0004             move.w     #$4, -(a7)
159e: a9eb                 dc.w       $a9eb
15a0: 43eefff6             lea.l      -$a(a6), a1
15a4: 41e8fff6             lea.l      -$a(a0), a0
15a8: 22d8                 move.l     (a0)+, (a1)+
15aa: 22d8                 move.l     (a0)+, (a1)+
15ac: 32d8                 move.w     (a0)+, (a1)+
15ae: 486efff6             pea.l      -$a(a6)
15b2: 486effe2             pea.l      -$1e(a6)
15b6: 4267                 clr.w      -(a7)
15b8: a9eb                 dc.w       $a9eb
15ba: 7001                 moveq      #$1, d0
15bc: d044                 add.w      d4, d0
15be: c1fc001c             muls.w     #$1c, d0
15c2: 20320818             move.l     $18(a2, d0.l), d0
15c6: 90aeffdc             sub.l      -$24(a6), d0
15ca: 41eeffd2             lea.l      -$2e(a6), a0
15ce: 43eefff6             lea.l      -$a(a6), a1
15d2: 20d9                 move.l     (a1)+, (a0)+
15d4: 20d9                 move.l     (a1)+, (a0)+
15d6: 30d9                 move.w     (a1)+, (a0)+
15d8: 2d40ffce             move.l     d0, -$32(a6)
15dc: 486effce             pea.l      -$32(a6)
15e0: 4868fff6             pea.l      -$a(a0)
15e4: 3f3c2804             move.w     #$2804, -(a7)
15e8: a9eb                 dc.w       $a9eb
15ea: 4868fff6             pea.l      -$a(a0)
15ee: 486effec             pea.l      -$14(a6)
15f2: 4267                 clr.w      -(a7)
15f4: a9eb                 dc.w       $a9eb
15f6: 5244                 addq.w     #$1, d4
15f8: 700a                 moveq      #$a, d0
15fa: de80                 add.l      d0, d7
15fc: b86e000c             cmp.w      $c(a6), d4
1600: 6e06                 bgt.b      $1608
1602: b644                 cmp.w      d4, d3
1604: 6c00ff76             bge.w      $157c
1608: 486effe2             pea.l      -$1e(a6)
160c: 486effec             pea.l      -$14(a6)
1610: 3f3c0006             move.w     #$6, -(a7)
1614: a9eb                 dc.w       $a9eb
1616: dc6e000c             add.w      $c(a6), d6
161a: 41eeffce             lea.l      -$32(a6), a0
161e: 43eeffec             lea.l      -$14(a6), a1
1622: 20d9                 move.l     (a1)+, (a0)+
1624: 20d9                 move.l     (a1)+, (a0)+
1626: 30d9                 move.w     (a1)+, (a0)+
1628: 4868fff6             pea.l      -$a(a0)
162c: 3f3c0016             move.w     #$16, -(a7)
1630: a9eb                 dc.w       $a9eb
1632: 4868fff6             pea.l      -$a(a0)
1636: 486effd8             pea.l      -$28(a6)
163a: 3f3c2810             move.w     #$2810, -(a7)
163e: a9eb                 dc.w       $a9eb
1640: 202effd8             move.l     -$28(a6), d0
1644: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
1648: 4e5e                 unlk       a6
164a: 4e75                 rts        
164c: 4e560000             link.w     a6, #$0
1650: 48e70108             movem.l    d7/a4, -(a7)
1654: 286e0008             movea.l    $8(a6), a4
1658: 2f2e000c             move.l     $c(a6), -(a7)
165c: 2f0c                 move.l     a4, -(a7)
165e: 4eba0060             jsr        $16c0(pc)
1662: 3e00                 move.w     d0, d7
1664: 2e8c                 move.l     a4, (a7)
1666: 4ead0dc2             jsr        $dc2(a5)
166a: 5380                 subq.l     #$1, d0
166c: 508f                 addq.l     #$8, a7
166e: 6646                 bne.b      $16b6
1670: 1014                 move.b     (a4), d0
1672: 4880                 ext.w      d0
1674: 204d                 movea.l    a5, a0
1676: d0c0                 adda.w     d0, a0
1678: 1028ce04             move.b     -$31fc(a0), d0
167c: 4880                 ext.w      d0
167e: 3f00                 move.w     d0, -(a7)
1680: 3f2dcf06             move.w     -$30fa(a5), -(a7)
1684: 1014                 move.b     (a4), d0
1686: 4880                 ext.w      d0
1688: 3f00                 move.w     d0, -(a7)
168a: 4ebafd7e             jsr        $140a(pc)
168e: de40                 add.w      d0, d7
1690: 1014                 move.b     (a4), d0
1692: 4880                 ext.w      d0
1694: 204d                 movea.l    a5, a0
1696: d0c0                 adda.w     d0, a0
1698: 10289512             move.b     -$6aee(a0), d0
169c: 4880                 ext.w      d0
169e: 5340                 subq.w     #$1, d0
16a0: 3e80                 move.w     d0, (a7)
16a2: 3f3c0060             move.w     #$60, -(a7)
16a6: 1014                 move.b     (a4), d0
16a8: 4880                 ext.w      d0
16aa: 3f00                 move.w     d0, -(a7)
16ac: 4ebafd5c             jsr        $140a(pc)
16b0: 9e40                 sub.w      d0, d7
16b2: 4fef000a             lea.l      $a(a7), a7
16b6: 3007                 move.w     d7, d0
16b8: 4cdf1080             movem.l    (a7)+, d7/a4
16bc: 4e5e                 unlk       a6
16be: 4e75                 rts        
16c0: 4e560000             link.w     a6, #$0
16c4: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
16c8: 4aadf674             tst.l      -$98c(a5)
16cc: 660001a4             bne.w      $1872
16d0: 4a6df682             tst.w      -$97e(a5)
16d4: 6704                 beq.b      $16da
16d6: 4ead01a2             jsr        $1a2(a5)
16da: 7c01                 moveq      #$1, d6
16dc: 387c0008             movea.w    #$8, a4
16e0: 601a                 bra.b      $16fc
16e2: 264c                 movea.l    a4, a3
16e4: d7edd55a             adda.l     -$2aa6(a5), a3
16e8: 4a6b0004             tst.w      $4(a3)
16ec: 670a                 beq.b      $16f8
16ee: 4a2b0006             tst.b      $6(a3)
16f2: 6604                 bne.b      $16f8
16f4: 526df682             addq.w     #$1, -$97e(a5)
16f8: 5246                 addq.w     #$1, d6
16fa: 508c                 addq.l     #$8, a4
16fc: bc6dd55e             cmp.w      -$2aa2(a5), d6
1700: 6de0                 blt.b      $16e2
1702: 700a                 moveq      #$a, d0
1704: c1edf682             muls.w     -$97e(a5), d0
1708: 2f00                 move.l     d0, -(a7)
170a: 4ead0682             jsr        $682(a5)
170e: 2b40f674             move.l     d0, -$98c(a5)
1712: 3a2df682             move.w     -$97e(a5), d5
1716: 48c5                 ext.l      d5
1718: 426df682             clr.w      -$97e(a5)
171c: 7c01                 moveq      #$1, d6
171e: 387c0008             movea.w    #$8, a4
1722: 588f                 addq.l     #$4, a7
1724: 6064                 bra.b      $178a
1726: 264c                 movea.l    a4, a3
1728: d7edd55a             adda.l     -$2aa6(a5), a3
172c: 4a6b0004             tst.w      $4(a3)
1730: 6754                 beq.b      $1786
1732: 4a2b0006             tst.b      $6(a3)
1736: 664e                 bne.b      $1786
1738: 306b0002             movea.w    $2(a3), a0
173c: 700a                 moveq      #$a, d0
173e: c1edf682             muls.w     -$97e(a5), d0
1742: d1edd560             adda.l     -$2aa0(a5), a0
1746: d0adf674             add.l      -$98c(a5), d0
174a: 2240                 movea.l    d0, a1
174c: 2288                 move.l     a0, (a1)
174e: 2448                 movea.l    a0, a2
1750: 600c                 bra.b      $175e
1752: 1012                 move.b     (a2), d0
1754: b02affff             cmp.b      -$1(a2), d0
1758: 6c04                 bge.b      $175e
175a: 4ead01a2             jsr        $1a2(a5)
175e: 528a                 addq.l     #$1, a2
1760: 4a12                 tst.b      (a2)
1762: 66ee                 bne.b      $1752
1764: 700a                 moveq      #$a, d0
1766: c1edf682             muls.w     -$97e(a5), d0
176a: d0adf674             add.l      -$98c(a5), d0
176e: 2e00                 move.l     d0, d7
1770: 2047                 movea.l    d7, a0
1772: 42a80004             clr.l      $4(a0)
1776: 202dd55a             move.l     -$2aa6(a5), d0
177a: 2047                 movea.l    d7, a0
177c: 317408040008         move.w     $4(a4, d0.l), $8(a0)
1782: 526df682             addq.w     #$1, -$97e(a5)
1786: 5246                 addq.w     #$1, d6
1788: 508c                 addq.l     #$8, a4
178a: bc6dd55e             cmp.w      -$2aa2(a5), d6
178e: 6d96                 blt.b      $1726
1790: 306df682             movea.w    -$97e(a5), a0
1794: ba88                 cmp.l      a0, d5
1796: 6704                 beq.b      $179c
1798: 4ead01a2             jsr        $1a2(a5)
179c: 7a00                 moveq      #$0, d5
179e: cbfc0003             muls.w     #$3, d5
17a2: 5245                 addq.w     #$1, d5
17a4: ba6df682             cmp.w      -$97e(a5), d5
17a8: 6df4                 blt.b      $179e
17aa: 48c5                 ext.l      d5
17ac: 8bfc0003             divs.w     #$3, d5
17b0: 3805                 move.w     d5, d4
17b2: 700a                 moveq      #$a, d0
17b4: c1c4                 muls.w     d4, d0
17b6: 2840                 movea.l    d0, a4
17b8: 6070                 bra.b      $182a
17ba: 204c                 movea.l    a4, a0
17bc: d1edf674             adda.l     -$98c(a5), a0
17c0: 43edf678             lea.l      -$988(a5), a1
17c4: 22d8                 move.l     (a0)+, (a1)+
17c6: 22d8                 move.l     (a0)+, (a1)+
17c8: 32d8                 move.w     (a0)+, (a1)+
17ca: 3c04                 move.w     d4, d6
17cc: 6020                 bra.b      $17ee
17ce: 3006                 move.w     d6, d0
17d0: 9045                 sub.w      d5, d0
17d2: c1fc000a             muls.w     #$a, d0
17d6: d0adf674             add.l      -$98c(a5), d0
17da: 2040                 movea.l    d0, a0
17dc: 700a                 moveq      #$a, d0
17de: c1c6                 muls.w     d6, d0
17e0: d0adf674             add.l      -$98c(a5), d0
17e4: 2240                 movea.l    d0, a1
17e6: 22d8                 move.l     (a0)+, (a1)+
17e8: 22d8                 move.l     (a0)+, (a1)+
17ea: 32d8                 move.w     (a0)+, (a1)+
17ec: 9c45                 sub.w      d5, d6
17ee: ba46                 cmp.w      d6, d5
17f0: 6e1e                 bgt.b      $1810
17f2: 3006                 move.w     d6, d0
17f4: 9045                 sub.w      d5, d0
17f6: c1fc000a             muls.w     #$a, d0
17fa: d0adf674             add.l      -$98c(a5), d0
17fe: 2040                 movea.l    d0, a0
1800: 2f10                 move.l     (a0), -(a7)
1802: 2f2df678             move.l     -$988(a5), -(a7)
1806: 4ead0db2             jsr        $db2(a5)
180a: 4a40                 tst.w      d0
180c: 508f                 addq.l     #$8, a7
180e: 6dbe                 blt.b      $17ce
1810: 700a                 moveq      #$a, d0
1812: c1c6                 muls.w     d6, d0
1814: d0adf674             add.l      -$98c(a5), d0
1818: 2040                 movea.l    d0, a0
181a: 43edf678             lea.l      -$988(a5), a1
181e: 20d9                 move.l     (a1)+, (a0)+
1820: 20d9                 move.l     (a1)+, (a0)+
1822: 30d9                 move.w     (a1)+, (a0)+
1824: 5244                 addq.w     #$1, d4
1826: 49ec000a             lea.l      $a(a4), a4
182a: b86df682             cmp.w      -$97e(a5), d4
182e: 6d8a                 blt.b      $17ba
1830: 0c450001             cmpi.w     #$1, d5
1834: 6e00ff74             bgt.w      $17aa
1838: 7a01                 moveq      #$1, d5
183a: 387c000a             movea.w    #$a, a4
183e: 602c                 bra.b      $186c
1840: 70ff                 moveq      #$ff, d0
1842: d045                 add.w      d5, d0
1844: c1fc000a             muls.w     #$a, d0
1848: d0adf674             add.l      -$98c(a5), d0
184c: 2040                 movea.l    d0, a0
184e: 2f10                 move.l     (a0), -(a7)
1850: 204c                 movea.l    a4, a0
1852: d1edf674             adda.l     -$98c(a5), a0
1856: 2f10                 move.l     (a0), -(a7)
1858: 4ead0db2             jsr        $db2(a5)
185c: 4a40                 tst.w      d0
185e: 508f                 addq.l     #$8, a7
1860: 6e04                 bgt.b      $1866
1862: 4ead01a2             jsr        $1a2(a5)
1866: 5245                 addq.w     #$1, d5
1868: 49ec000a             lea.l      $a(a4), a4
186c: ba6df682             cmp.w      -$97e(a5), d5
1870: 6dce                 blt.b      $1840
1872: 7a00                 moveq      #$0, d5
1874: 7cff                 moveq      #$ff, d6
1876: dc6df682             add.w      -$97e(a5), d6
187a: 206e000c             movea.l    $c(a6), a0
187e: 4290                 clr.l      (a0)
1880: 6054                 bra.b      $18d6
1882: 3806                 move.w     d6, d4
1884: d845                 add.w      d5, d4
1886: e244                 asr.w      #$1, d4
1888: 700a                 moveq      #$a, d0
188a: c1c4                 muls.w     d4, d0
188c: d0adf674             add.l      -$98c(a5), d0
1890: 2040                 movea.l    d0, a0
1892: 2f10                 move.l     (a0), -(a7)
1894: 2f2e0008             move.l     $8(a6), -(a7)
1898: 4ead0db2             jsr        $db2(a5)
189c: 3600                 move.w     d0, d3
189e: 4a43                 tst.w      d3
18a0: 508f                 addq.l     #$8, a7
18a2: 6624                 bne.b      $18c8
18a4: 700a                 moveq      #$a, d0
18a6: c1c4                 muls.w     d4, d0
18a8: d0adf674             add.l      -$98c(a5), d0
18ac: 2840                 movea.l    d0, a4
18ae: 41ec0004             lea.l      $4(a4), a0
18b2: 226e000c             movea.l    $c(a6), a1
18b6: 2288                 move.l     a0, (a1)
18b8: 701c                 moveq      #$1c, d0
18ba: c1ec0008             muls.w     $8(a4), d0
18be: 206dd564             movea.l    -$2a9c(a5), a0
18c2: 3030081a             move.w     $1a(a0, d0.l), d0
18c6: 6014                 bra.b      $18dc
18c8: 4a43                 tst.w      d3
18ca: 6c06                 bge.b      $18d2
18cc: 7cff                 moveq      #$ff, d6
18ce: dc44                 add.w      d4, d6
18d0: 6004                 bra.b      $18d6
18d2: 7a01                 moveq      #$1, d5
18d4: da44                 add.w      d4, d5
18d6: ba46                 cmp.w      d6, d5
18d8: 6fa8                 ble.b      $1882
18da: 7000                 moveq      #$0, d0
18dc: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
18e0: 4e5e                 unlk       a6
18e2: 4e75                 rts        
18e4: 4e560000             link.w     a6, #$0
18e8: 48e70308             movem.l    d6-d7/a4, -(a7)
18ec: 3e2e0008             move.w     $8(a6), d7
18f0: 2007                 move.l     d7, d0
18f2: 48c0                 ext.l      d0
18f4: e588                 lsl.l      #$2, d0
18f6: 49edb1e0             lea.l      -$4e20(a5), a4
18fa: d08c                 add.l      a4, d0
18fc: 2840                 movea.l    d0, a4
18fe: 2014                 move.l     (a4), d0
1900: b0adb1dc             cmp.l      -$4e24(a5), d0
1904: 6736                 beq.b      $193c
1906: 28adb1dc             move.l     -$4e24(a5), (a4)
190a: 302e000a             move.w     $a(a6), d0
190e: 204d                 movea.l    a5, a0
1910: d0c7                 adda.w     d7, a0
1912: d0c7                 adda.w     d7, a0
1914: d168bbf4             add.w      d0, -$440c(a0)
1918: 7c00                 moveq      #$0, d6
191a: 49ed99d6             lea.l      -$662a(a5), a4
191e: 6016                 bra.b      $1936
1920: 3f2e000a             move.w     $a(a6), -(a7)
1924: 302c0002             move.w     $2(a4), d0
1928: 8047                 or.w       d7, d0
192a: 3f00                 move.w     d0, -(a7)
192c: 4ebaffb6             jsr        $18e4(pc)
1930: 588f                 addq.l     #$4, a7
1932: 5246                 addq.w     #$1, d6
1934: 588c                 addq.l     #$4, a4
1936: 0c460007             cmpi.w     #$7, d6
193a: 6de4                 blt.b      $1920
193c: 4cdf10c0             movem.l    (a7)+, d6-d7/a4
1940: 4e5e                 unlk       a6
1942: 4e75                 rts        
