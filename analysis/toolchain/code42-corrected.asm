0004: 4e560000             link.w     a6, #$0
0008: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
000c: 426df97c             clr.w      -$684(a5)
0010: 426df97e             clr.w      -$682(a5)
0014: 49edf960             lea.l      -$6a0(a5), a4
0018: 266d99d2             movea.l    -$662e(a5), a3
001c: 6044                 bra.b      $62
001e: 206e0008             movea.l    $8(a6), a0
0022: 4a307000             tst.b      (a0, d7.w)
0026: 6738                 beq.b      $60
0028: 206e000c             movea.l    $c(a6), a0
002c: 52ae000c             addq.l     #$1, $c(a6)
0030: 1087                 move.b     d7, (a0)
0032: 206e0008             movea.l    $8(a6), a0
0036: 1c307000             move.b     (a0, d7.w), d6
003a: 1006                 move.b     d6, d0
003c: 4880                 ext.w      d0
003e: d16df97e             add.w      d0, -$682(a5)
0042: 0c060001             cmpi.b     #$1, d6
0046: 6616                 bne.b      $5e
0048: 2007                 move.l     d7, d0
004a: 48c0                 ext.l      d0
004c: e988                 lsl.l      #$4, d0
004e: 204d                 movea.l    a5, a0
0050: d1c0                 adda.l     d0, a0
0052: 3028b3f4             move.w     -$4c0c(a0), d0
0056: 4640                 not.w      d0
0058: 816df97c             or.w       d0, -$684(a5)
005c: 6002                 bra.b      $60
005e: 18c7                 move.b     d7, (a4)+
0060: 528b                 addq.l     #$1, a3
0062: 1e13                 move.b     (a3), d7
0064: 4887                 ext.w      d7
0066: 4a47                 tst.w      d7
0068: 66b4                 bne.b      $1e
006a: 206e000c             movea.l    $c(a6), a0
006e: 4210                 clr.b      (a0)
0070: 4214                 clr.b      (a4)
0072: 302df97e             move.w     -$682(a5), d0
0076: 43edbc04             lea.l      -$43fc(a5), a1
007a: 41edbba4             lea.l      -$445c(a5), a0
007e: d0c0                 adda.w     d0, a0
0080: d0c0                 adda.w     d0, a0
0082: b3c8                 cmpa.l     a0, a1
0084: 6204                 bhi.b      $8a
0086: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
008a: 7e00                 moveq      #$0, d7
008c: 49edbba4             lea.l      -$445c(a5), a4
0090: 6008                 bra.b      $9a
0092: 38bcffff             move.w     #$ffff, (a4)
0096: 5247                 addq.w     #$1, d7
0098: 548c                 addq.l     #$2, a4
009a: be6df97e             cmp.w      -$682(a5), d7
009e: 6df2                 blt.b      $92
00a0: 4cdf18c0             movem.l    (a7)+, d6-d7/a3-a4
00a4: 4e5e                 unlk       a6
00a6: 4e75                 rts        
00a8: 4e56ff60             link.w     a6, #$ff60
00ac: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
00b0: 2e2e0008             move.l     $8(a6), d7
00b4: 382e000c             move.w     $c(a6), d4
00b8: 7c07                 moveq      #$7, d6
00ba: 3a2df97c             move.w     -$684(a5), d5
00be: ca44                 and.w      d4, d5
00c0: 600a                 bra.b      $cc
00c2: 5346                 subq.w     #$1, d6
00c4: 70ff                 moveq      #$ff, d0
00c6: d045                 add.w      d5, d0
00c8: c045                 and.w      d5, d0
00ca: 3a00                 move.w     d0, d5
00cc: 4a45                 tst.w      d5
00ce: 66f2                 bne.b      $c2
00d0: 4a46                 tst.w      d6
00d2: 6c04                 bge.b      $d8
00d4: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
00d8: 302df97c             move.w     -$684(a5), d0
00dc: 4640                 not.w      d0
00de: c840                 and.w      d0, d4
00e0: 3a2df97e             move.w     -$682(a5), d5
00e4: da46                 add.w      d6, d5
00e6: 5f45                 subq.w     #$7, d5
00e8: 4a44                 tst.w      d4
00ea: 6616                 bne.b      $102
00ec: 2005                 move.l     d5, d0
00ee: 48c0                 ext.l      d0
00f0: e988                 lsl.l      #$4, d0
00f2: 41ed9a58             lea.l      -$65a8(a5), a0
00f6: d088                 add.l      a0, d0
00f8: 3046                 movea.w    d6, a0
00fa: d1c8                 adda.l     a0, a0
00fc: 30300800             move.w     (a0, d0.l), d0
0100: 605a                 bra.b      $15c
0102: 707b                 moveq      #$7b, d0
0104: d087                 add.l      d7, d0
0106: 2840                 movea.l    d0, a4
0108: 1885                 move.b     d5, (a4)
010a: 45eeff60             lea.l      -$a0(a6), a2
010e: 47edf960             lea.l      -$6a0(a5), a3
0112: 6020                 bra.b      $134
0114: 2005                 move.l     d5, d0
0116: 48c0                 ext.l      d0
0118: e988                 lsl.l      #$4, d0
011a: 204d                 movea.l    a5, a0
011c: d1c0                 adda.l     d0, a0
011e: 3028b3f4             move.w     -$4c0c(a0), d0
0122: 4640                 not.w      d0
0124: c044                 and.w      d4, d0
0126: 670a                 beq.b      $132
0128: 14c5                 move.b     d5, (a2)+
012a: 3045                 movea.w    d5, a0
012c: 10307800             move.b     (a0, d7.l), d0
0130: 9114                 sub.b      d0, (a4)
0132: 528b                 addq.l     #$1, a3
0134: 1a13                 move.b     (a3), d5
0136: 4885                 ext.w      d5
0138: 4a45                 tst.w      d5
013a: 66d8                 bne.b      $114
013c: 14fc007b             move.b     #$7b, (a2)+
0140: 4212                 clr.b      (a2)
0142: 3f06                 move.w     d6, -(a7)
0144: 4267                 clr.w      -(a7)
0146: 486eff60             pea.l      -$a0(a6)
014a: 486eff80             pea.l      -$80(a6)
014e: 3f04                 move.w     d4, -(a7)
0150: 2f07                 move.l     d7, -(a7)
0152: 4eba0012             jsr        $166(pc)
0156: 3a00                 move.w     d0, d5
0158: 4214                 clr.b      (a4)
015a: 3005                 move.w     d5, d0
015c: 4cee1cf0ff44         movem.l    -$bc(a6), d4-d7/a2-a4
0162: 4e5e                 unlk       a6
0164: 4e75                 rts        
0166: 4e56fffe             link.w     a6, #$fffe
016a: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
016e: 246e0008             movea.l    $8(a6), a2
0172: 3c2e000c             move.w     $c(a6), d6
0176: 286e000e             movea.l    $e(a6), a4
017a: 266e0012             movea.l    $12(a6), a3
017e: 3e2e0016             move.w     $16(a6), d7
0182: be6e0018             cmp.w      $18(a6), d7
0186: 6f06                 ble.b      $18e
0188: 7000                 moveq      #$0, d0
018a: 6000014e             bra.w      $2da
018e: be6e0018             cmp.w      $18(a6), d7
0192: 6650                 bne.b      $1e4
0194: 4a46                 tst.w      d6
0196: 6706                 beq.b      $19e
0198: 7000                 moveq      #$0, d0
019a: 6000013e             bra.w      $2da
019e: 4214                 clr.b      (a4)
01a0: 3047                 movea.w    d7, a0
01a2: 99c8                 suba.l     a0, a4
01a4: 7801                 moveq      #$1, d4
01a6: 264c                 movea.l    a4, a3
01a8: 49ebffff             lea.l      -$1(a3), a4
01ac: 1613                 move.b     (a3), d3
01ae: 4a03                 tst.b      d3
01b0: 672c                 beq.b      $1de
01b2: b62b0001             cmp.b      $1(a3), d3
01b6: 6722                 beq.b      $1da
01b8: 1003                 move.b     d3, d0
01ba: 4880                 ext.w      d0
01bc: 10320000             move.b     (a2, d0.w), d0
01c0: 4880                 ext.w      d0
01c2: 48c0                 ext.l      d0
01c4: e988                 lsl.l      #$4, d0
01c6: 220b                 move.l     a3, d1
01c8: 928c                 sub.l      a4, d1
01ca: 41ed9a58             lea.l      -$65a8(a5), a0
01ce: d088                 add.l      a0, d0
01d0: d281                 add.l      d1, d1
01d2: d081                 add.l      d1, d0
01d4: 2040                 movea.l    d0, a0
01d6: c9d0                 muls.w     (a0), d4
01d8: 284b                 movea.l    a3, a4
01da: 528b                 addq.l     #$1, a3
01dc: 60ce                 bra.b      $1ac
01de: 3004                 move.w     d4, d0
01e0: 600000f8             bra.w      $2da
01e4: 4a13                 tst.b      (a3)
01e6: 6606                 bne.b      $1ee
01e8: 7000                 moveq      #$0, d0
01ea: 600000ee             bra.w      $2da
01ee: 4a46                 tst.w      d6
01f0: 66000080             bne.w      $272
01f4: 7a00                 moveq      #$0, d5
01f6: 1613                 move.b     (a3), d3
01f8: 4a03                 tst.b      d3
01fa: 6710                 beq.b      $20c
01fc: 1003                 move.b     d3, d0
01fe: 4880                 ext.w      d0
0200: 10320000             move.b     (a2, d0.w), d0
0204: 4880                 ext.w      d0
0206: da40                 add.w      d0, d5
0208: 528b                 addq.l     #$1, a3
020a: 60ea                 bra.b      $1f6
020c: 3c2e0018             move.w     $18(a6), d6
0210: 9c47                 sub.w      d7, d6
0212: bc45                 cmp.w      d5, d6
0214: 6f06                 ble.b      $21c
0216: 7000                 moveq      #$0, d0
0218: 600000c0             bra.w      $2da
021c: 4214                 clr.b      (a4)
021e: 3047                 movea.w    d7, a0
0220: 99c8                 suba.l     a0, a4
0222: 2005                 move.l     d5, d0
0224: 48c0                 ext.l      d0
0226: e988                 lsl.l      #$4, d0
0228: 41ed9a58             lea.l      -$65a8(a5), a0
022c: d088                 add.l      a0, d0
022e: 3046                 movea.w    d6, a0
0230: d1c8                 adda.l     a0, a0
0232: 38300800             move.w     (a0, d0.l), d4
0236: 264c                 movea.l    a4, a3
0238: 49ebffff             lea.l      -$1(a3), a4
023c: 1613                 move.b     (a3), d3
023e: 4a03                 tst.b      d3
0240: 672c                 beq.b      $26e
0242: b62b0001             cmp.b      $1(a3), d3
0246: 6722                 beq.b      $26a
0248: 1003                 move.b     d3, d0
024a: 4880                 ext.w      d0
024c: 10320000             move.b     (a2, d0.w), d0
0250: 4880                 ext.w      d0
0252: 48c0                 ext.l      d0
0254: e988                 lsl.l      #$4, d0
0256: 220b                 move.l     a3, d1
0258: 928c                 sub.l      a4, d1
025a: 41ed9a58             lea.l      -$65a8(a5), a0
025e: d088                 add.l      a0, d0
0260: d281                 add.l      d1, d1
0262: d081                 add.l      d1, d0
0264: 2040                 movea.l    d0, a0
0266: c9d0                 muls.w     (a0), d4
0268: 284b                 movea.l    a3, a4
026a: 528b                 addq.l     #$1, a3
026c: 60ce                 bra.b      $23c
026e: 3004                 move.w     d4, d0
0270: 6068                 bra.b      $2da
0272: 1013                 move.b     (a3), d0
0274: 4880                 ext.w      d0
0276: 48c0                 ext.l      d0
0278: e988                 lsl.l      #$4, d0
027a: 204d                 movea.l    a5, a0
027c: d1c0                 adda.l     d0, a0
027e: 3028b3f4             move.w     -$4c0c(a0), d0
0282: 4640                 not.w      d0
0284: 5340                 subq.w     #$1, d0
0286: c046                 and.w      d6, d0
0288: 6704                 beq.b      $28e
028a: 7000                 moveq      #$0, d0
028c: 604c                 bra.b      $2da
028e: 7a00                 moveq      #$0, d5
0290: 7800                 moveq      #$0, d4
0292: 3f2e0018             move.w     $18(a6), -(a7)
0296: 3f07                 move.w     d7, -(a7)
0298: 486b0001             pea.l      $1(a3)
029c: 2f0c                 move.l     a4, -(a7)
029e: 3f06                 move.w     d6, -(a7)
02a0: 2f0a                 move.l     a2, -(a7)
02a2: 4ebafec2             jsr        $166(pc)
02a6: d840                 add.w      d0, d4
02a8: 1013                 move.b     (a3), d0
02aa: 4880                 ext.w      d0
02ac: 48c0                 ext.l      d0
02ae: e988                 lsl.l      #$4, d0
02b0: 41edb3f4             lea.l      -$4c0c(a5), a0
02b4: d088                 add.l      a0, d0
02b6: 3045                 movea.w    d5, a0
02b8: d1c8                 adda.l     a0, a0
02ba: cc700800             and.w      (a0, d0.l), d6
02be: 18d3                 move.b     (a3), (a4)+
02c0: 5247                 addq.w     #$1, d7
02c2: 4fef0012             lea.l      $12(a7), a7
02c6: 3005                 move.w     d5, d0
02c8: 5245                 addq.w     #$1, d5
02ca: 1213                 move.b     (a3), d1
02cc: 4881                 ext.w      d1
02ce: 12321000             move.b     (a2, d1.w), d1
02d2: 4881                 ext.w      d1
02d4: b240                 cmp.w      d0, d1
02d6: 6eba                 bgt.b      $292
02d8: 3004                 move.w     d4, d0
02da: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
02de: 4e5e                 unlk       a6
02e0: 4e75                 rts        
