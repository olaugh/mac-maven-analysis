0004: 4e560000             link.w     a6, #$0
0008: 48e70038             movem.l    a2-a4, -(a7)
000c: 266e0008             movea.l    $8(a6), a3
0010: 426db1d6             clr.w      -$4e2a(a5)
0014: 284b                 movea.l    a3, a4
0016: 102b0021             move.b     $21(a3), d0
001a: 4880                 ext.w      d0
001c: 122b0020             move.b     $20(a3), d1
0020: 4881                 ext.w      d1
0022: c3fc0011             muls.w     #$11, d1
0026: 45edbcfe             lea.l      -$4302(a5), a2
002a: d28a                 add.l      a2, d1
002c: 3440                 movea.w    d0, a2
002e: d28a                 add.l      a2, d1
0030: 2441                 movea.l    d1, a2
0032: 600c                 bra.b      $40
0034: 4a12                 tst.b      (a2)
0036: 6604                 bne.b      $3c
0038: 526db1d6             addq.w     #$1, -$4e2a(a5)
003c: 528c                 addq.l     #$1, a4
003e: 528a                 addq.l     #$1, a2
0040: 4a14                 tst.b      (a4)
0042: 66f0                 bne.b      $34
0044: 4cdf1c00             movem.l    (a7)+, a2-a4
0048: 4e5e                 unlk       a6
004a: 4e75                 rts        
004c: 4e560000             link.w     a6, #$0
0050: 2f0c                 move.l     a4, -(a7)
0052: 7011                 moveq      #$11, d0
0054: c1ee0008             muls.w     $8(a6), d0
0058: d08d                 add.l      a5, d0
005a: 386e000a             movea.w    $a(a6), a4
005e: 49ecbcfd             lea.l      -$4303(a4), a4
0062: d08c                 add.l      a4, d0
0064: 2840                 movea.l    d0, a4
0066: 6002                 bra.b      $6a
0068: 538c                 subq.l     #$1, a4
006a: 4a14                 tst.b      (a4)
006c: 66fa                 bne.b      $68
006e: 200c                 move.l     a4, d0
0070: 5280                 addq.l     #$1, d0
0072: 285f                 movea.l    (a7)+, a4
0074: 4e5e                 unlk       a6
0076: 4e75                 rts        
0078: 4e56fffe             link.w     a6, #$fffe
007c: 0c6e00100008         cmpi.w     #$10, $8(a6)
0082: 6c16                 bge.b      $9a
0084: 700f                 moveq      #$f, d0
0086: d06e000a             add.w      $a(a6), d0
008a: 206e000c             movea.l    $c(a6), a0
008e: 3080                 move.w     d0, (a0)
0090: 226e0010             movea.l    $10(a6), a1
0094: 32ae0008             move.w     $8(a6), (a1)
0098: 6014                 bra.b      $ae
009a: 206e000c             movea.l    $c(a6), a0
009e: 30ae000a             move.w     $a(a6), (a0)
00a2: 70f1                 moveq      #$f1, d0
00a4: d06e0008             add.w      $8(a6), d0
00a8: 226e0010             movea.l    $10(a6), a1
00ac: 3280                 move.w     d0, (a1)
00ae: 4e5e                 unlk       a6
00b0: 4e75                 rts        
00b2: 4a2dc35e             tst.b      -$3ca2(a5)
00b6: 6722                 beq.b      $da
00b8: 4a2dc366             tst.b      -$3c9a(a5)
00bc: 671c                 beq.b      $da
00be: 0c6d0006b3f2         cmpi.w     #$6, -$4c0e(a5)
00c4: 6714                 beq.b      $da
00c6: 0c6d0002b3f2         cmpi.w     #$2, -$4c0e(a5)
00cc: 6608                 bne.b      $d6
00ce: 4eba0038             jsr        $108(pc)
00d2: 4a40                 tst.w      d0
00d4: 6704                 beq.b      $da
00d6: 7000                 moveq      #$0, d0
00d8: 6002                 bra.b      $dc
00da: 7001                 moveq      #$1, d0
00dc: 4e75                 rts        
00de: 4e56fffc             link.w     a6, #$fffc
00e2: 48e70108             movem.l    d7/a4, -(a7)
00e6: 7e00                 moveq      #$0, d7
00e8: 49edbd0f             lea.l      -$42f1(a5), a4
00ec: 6008                 bra.b      $f6
00ee: 4a14                 tst.b      (a4)
00f0: 6702                 beq.b      $f4
00f2: 5247                 addq.w     #$1, d7
00f4: 528c                 addq.l     #$1, a4
00f6: 41edbe0e             lea.l      -$41f2(a5), a0
00fa: b1cc                 cmpa.l     a4, a0
00fc: 62f0                 bhi.b      $ee
00fe: 3007                 move.w     d7, d0
0100: 4cdf1080             movem.l    (a7)+, d7/a4
0104: 4e5e                 unlk       a6
0106: 4e75                 rts        
0108: 4ebaffd4             jsr        $de(pc)
010c: 0c40004f             cmpi.w     #$4f, d0
0110: 5fc0                 sle.b      d0
0112: 4400                 neg.b      d0
0114: 4880                 ext.w      d0
0116: 4e75                 rts        
0118: 4ebaffc4             jsr        $de(pc)
011c: 0c400056             cmpi.w     #$56, d0
0120: 5cc0                 sge.b      d0
0122: 4400                 neg.b      d0
0124: 4880                 ext.w      d0
0126: 4e75                 rts        
0128: 4e560000             link.w     a6, #$0
012c: 2f07                 move.l     d7, -(a7)
012e: 204d                 movea.l    a5, a0
0130: 302e0008             move.w     $8(a6), d0
0134: d0c0                 adda.w     d0, a0
0136: d0c0                 adda.w     d0, a0
0138: 3e289412             move.w     -$6bee(a0), d7
013c: 0c470064             cmpi.w     #$64, d7
0140: 6c04                 bge.b      $146
0142: 3007                 move.w     d7, d0
0144: 6008                 bra.b      $14e
0146: 2007                 move.l     d7, d0
0148: 48c0                 ext.l      d0
014a: 81fc0064             divs.w     #$64, d0
014e: 2e1f                 move.l     (a7)+, d7
0150: 4e5e                 unlk       a6
0152: 4e75                 rts        
0154: 4e560000             link.w     a6, #$0
0158: 48780021             pea.l      $21.w
015c: 486df536             pea.l      -$aca(a5)
0160: 2f2e0008             move.l     $8(a6), -(a7)
0164: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0168: 4e5e                 unlk       a6
016a: 4e75                 rts        
016c: 4e560000             link.w     a6, #$0
0170: 48780021             pea.l      $21.w
0174: 2f2e0008             move.l     $8(a6), -(a7)
0178: 486df536             pea.l      -$aca(a5)
017c: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0180: 4e5e                 unlk       a6
0182: 4e75                 rts        
0184: 4e56f79a             link.w     a6, #$f79a
0188: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
018c: 266e0008             movea.l    $8(a6), a3
0190: 246e000c             movea.l    $c(a6), a2
0194: 49eb0020             lea.l      $20(a3), a4
0198: 1b54f536             move.b     (a4), -$aca(a5)
019c: 7e01                 moveq      #$1, d7
019e: 4a6e0010             tst.w      $10(a6)
01a2: 670000c2             beq.w      $266
01a6: 486ef7c6             pea.l      -$83a(a6)
01aa: 486efbc6             pea.l      -$43a(a6)
01ae: 2f0b                 move.l     a3, -(a7)
01b0: 4ead09e2             jsr        $9e2(a5) ; CODE35+036c
01b4: 7058                 moveq      #$58, d0
01b6: 2e80                 move.l     d0, (a7)
01b8: 486da440             pea.l      -$5bc0(a5)
01bc: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
01c0: 102da5b8             move.b     -$5a48(a5), d0
01c4: 4880                 ext.w      d0
01c6: 3d40f7b6             move.w     d0, -$84a(a6)
01ca: 122da5bf             move.b     -$5a41(a5), d1
01ce: 4881                 ext.w      d1
01d0: 3d41f79e             move.w     d1, -$862(a6)
01d4: 142da5c6             move.b     -$5a3a(a5), d2
01d8: 4882                 ext.w      d2
01da: 3d42f7b0             move.w     d2, -$850(a6)
01de: 102da5c8             move.b     -$5a38(a5), d0
01e2: 4880                 ext.w      d0
01e4: 3d40f7ae             move.w     d0, -$852(a6)
01e8: 102da58d             move.b     -$5a73(a5), d0
01ec: 4880                 ext.w      d0
01ee: 3d40f79c             move.w     d0, -$864(a6)
01f2: 2e8a                 move.l     a2, (a7)
01f4: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
01f8: 3d40f7a8             move.w     d0, -$858(a6)
01fc: 7800                 moveq      #$0, d4
01fe: 3c04                 move.w     d4, d6
0200: 7661                 moveq      #$61, d3
0202: 4fef0010             lea.l      $10(a7), a7
0206: 603e                 bra.b      $246
0208: 204d                 movea.l    a5, a0
020a: d0c3                 adda.w     d3, a0
020c: 1a28a54e             move.b     -$5ab2(a0), d5
0210: 4885                 ext.w      d5
0212: 4a45                 tst.w      d5
0214: 672e                 beq.b      $244
0216: 3f03                 move.w     d3, -(a7)
0218: 4ead07d2             jsr        $7d2(a5) ; CODE23+0004
021c: 4a40                 tst.w      d0
021e: 548f                 addq.l     #$2, a7
0220: 6704                 beq.b      $226
0222: dc45                 add.w      d5, d6
0224: 6002                 bra.b      $228
0226: d845                 add.w      d5, d4
0228: 0c450003             cmpi.w     #$3, d5
022c: 6d06                 blt.b      $234
022e: 52ada480             addq.l     #$1, -$5b80(a5)
0232: 6010                 bra.b      $244
0234: 0c430073             cmpi.w     #$73, d3
0238: 670a                 beq.b      $244
023a: 0c450002             cmpi.w     #$2, d5
023e: 6604                 bne.b      $244
0240: 52ada47c             addq.l     #$1, -$5b84(a5)
0244: 5243                 addq.w     #$1, d3
0246: 0c43007a             cmpi.w     #$7a, d3
024a: 6fbc                 ble.b      $208
024c: 0c460006             cmpi.w     #$6, d6
0250: 6d08                 blt.b      $25a
0252: 7001                 moveq      #$1, d0
0254: 2b40a488             move.l     d0, -$5b78(a5)
0258: 600c                 bra.b      $266
025a: 0c440006             cmpi.w     #$6, d4
025e: 6d06                 blt.b      $266
0260: 7001                 moveq      #$1, d0
0262: 2b40a484             move.l     d0, -$5b7c(a5)
0266: 4ebafe76             jsr        $de(pc)
026a: 3a00                 move.w     d0, d5
026c: 7c00                 moveq      #$0, d6
026e: 4a14                 tst.b      (a4)
0270: 6638                 bne.b      $2aa
0272: 526db3f2             addq.w     #$1, -$4c0e(a5)
0276: 284b                 movea.l    a3, a4
0278: 600e                 bra.b      $288
027a: 1014                 move.b     (a4), d0
027c: 4880                 ext.w      d0
027e: 204d                 movea.l    a5, a0
0280: d0c0                 adda.w     d0, a0
0282: 5328a54e             subq.b     #$1, -$5ab2(a0)
0286: 528c                 addq.l     #$1, a4
0288: 4a14                 tst.b      (a4)
028a: 66ee                 bne.b      $27a
028c: 2f0b                 move.l     a3, -(a7)
028e: 486dbcfe             pea.l      -$4302(a5)
0292: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0296: 4a6e0010             tst.w      $10(a6)
029a: 508f                 addq.l     #$8, a7
029c: 67000258             beq.w      $4f6
02a0: 7001                 moveq      #$1, d0
02a2: 2b40a494             move.l     d0, -$5b6c(a5)
02a6: 6000024e             bra.w      $4f6
02aa: 426db3f2             clr.w      -$4c0e(a5)
02ae: 41eeffde             lea.l      -$22(a6), a0
02b2: 43d3                 lea.l      (a3), a1
02b4: 7007                 moveq      #$7, d0
02b6: 20d9                 move.l     (a1)+, (a0)+
02b8: 51c8fffc             dbra       d0, $2b6
02bc: 30d9                 move.w     (a1)+, (a0)+
02be: 486effce             pea.l      -$32(a6)
02c2: 2f0a                 move.l     a2, -(a7)
02c4: 486effde             pea.l      -$22(a6)
02c8: 4ead098a             jsr        $98a(a5) ; CODE32+0004
02cc: 2d40ffee             move.l     d0, -$12(a6)
02d0: 4aaeffee             tst.l      -$12(a6)
02d4: 4fef000c             lea.l      $c(a7), a7
02d8: 6c04                 bge.b      $2de
02da: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
02de: 4aadb3ee             tst.l      -$4c12(a5)
02e2: 670c                 beq.b      $2f0
02e4: 486effde             pea.l      -$22(a6)
02e8: 206db3ee             movea.l    -$4c12(a5), a0
02ec: 4e90                 jsr        (a0)
02ee: 588f                 addq.l     #$4, a7
02f0: 1814                 move.b     (a4), d4
02f2: 4884                 ext.w      d4
02f4: 162b0021             move.b     $21(a3), d3
02f8: 4883                 ext.w      d3
02fa: 486ef7c2             pea.l      -$83e(a6)
02fe: 486ef7c4             pea.l      -$83c(a6)
0302: 3f03                 move.w     d3, -(a7)
0304: 3f04                 move.w     d4, -(a7)
0306: 4ebafd70             jsr        $78(pc)
030a: 284b                 movea.l    a3, a4
030c: 7011                 moveq      #$11, d0
030e: c1c4                 muls.w     d4, d0
0310: 41edbcfe             lea.l      -$4302(a5), a0
0314: d088                 add.l      a0, d0
0316: 2d40f7aa             move.l     d0, -$856(a6)
031a: 7222                 moveq      #$22, d1
031c: c3c4                 muls.w     d4, d1
031e: 41edbf1e             lea.l      -$40e2(a5), a0
0322: d288                 add.l      a0, d1
0324: 2d41f7b2             move.l     d1, -$84e(a6)
0328: 7411                 moveq      #$11, d2
032a: c5c4                 muls.w     d4, d2
032c: 41ed97b2             lea.l      -$684e(a5), a0
0330: d488                 add.l      a0, d2
0332: 2d42f7ba             move.l     d2, -$846(a6)
0336: 3043                 movea.w    d3, a0
0338: d1c8                 adda.l     a0, a0
033a: 2d48f7a4             move.l     a0, -$85c(a6)
033e: 4fef000c             lea.l      $c(a7), a7
0342: 6000010c             bra.w      $450
0346: 200c                 move.l     a4, d0
0348: 908b                 sub.l      a3, d0
034a: 720f                 moveq      #$f, d1
034c: b280                 cmp.l      d0, d1
034e: 6e04                 bgt.b      $354
0350: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0354: 206ef7aa             movea.l    -$856(a6), a0
0358: 10303000             move.b     (a0, d3.w), d0
035c: b014                 cmp.b      (a4), d0
035e: 6716                 beq.b      $376
0360: 7011                 moveq      #$11, d0
0362: c1c4                 muls.w     d4, d0
0364: 41edbcfe             lea.l      -$4302(a5), a0
0368: d088                 add.l      a0, d0
036a: 3043                 movea.w    d3, a0
036c: 4a300800             tst.b      (a0, d0.l)
0370: 6704                 beq.b      $376
0372: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0376: 7011                 moveq      #$11, d0
0378: c1eef7c4             muls.w     -$83c(a6), d0
037c: d08d                 add.l      a5, d0
037e: 306ef7c2             movea.w    -$83e(a6), a0
0382: d1c0                 adda.l     d0, a0
0384: 1d68bcfef79b         move.b     -$4302(a0), -$865(a6)
038a: 102ef79b             move.b     -$865(a6), d0
038e: b014                 cmp.b      (a4), d0
0390: 670a                 beq.b      $39c
0392: 4a2ef79b             tst.b      -$865(a6)
0396: 6704                 beq.b      $39c
0398: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
039c: 7011                 moveq      #$11, d0
039e: c1c4                 muls.w     d4, d0
03a0: 41edbcfe             lea.l      -$4302(a5), a0
03a4: d088                 add.l      a0, d0
03a6: 3043                 movea.w    d3, a0
03a8: d088                 add.l      a0, d0
03aa: 2d40f7a0             move.l     d0, -$860(a6)
03ae: 2040                 movea.l    d0, a0
03b0: 4a10                 tst.b      (a0)
03b2: 66000090             bne.w      $444
03b6: 1014                 move.b     (a4), d0
03b8: 4880                 ext.w      d0
03ba: 204d                 movea.l    a5, a0
03bc: d0c0                 adda.w     d0, a0
03be: 4a28a54e             tst.b      -$5ab2(a0)
03c2: 6610                 bne.b      $3d4
03c4: 4a2da58d             tst.b      -$5a73(a5)
03c8: 6e04                 bgt.b      $3ce
03ca: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
03ce: 532da58d             subq.b     #$1, -$5a73(a5)
03d2: 600c                 bra.b      $3e0
03d4: 1014                 move.b     (a4), d0
03d6: 4880                 ext.w      d0
03d8: 204d                 movea.l    a5, a0
03da: d0c0                 adda.w     d0, a0
03dc: 5328a54e             subq.b     #$1, -$5ab2(a0)
03e0: 3007                 move.w     d7, d0
03e2: 5247                 addq.w     #$1, d7
03e4: 204d                 movea.l    a5, a0
03e6: d0c0                 adda.w     d0, a0
03e8: 1143f536             move.b     d3, -$aca(a0)
03ec: 7011                 moveq      #$11, d0
03ee: c1eef7c4             muls.w     -$83c(a6), d0
03f2: d08d                 add.l      a5, d0
03f4: 306ef7c2             movea.w    -$83e(a6), a0
03f8: d1c0                 adda.l     d0, a0
03fa: 1014                 move.b     (a4), d0
03fc: 1140bcfe             move.b     d0, -$4302(a0)
0400: 206ef7a0             movea.l    -$860(a6), a0
0404: 1080                 move.b     d0, (a0)
0406: 1014                 move.b     (a4), d0
0408: 4880                 ext.w      d0
040a: 224d                 movea.l    a5, a1
040c: d2c0                 adda.w     d0, a1
040e: d2c0                 adda.w     d0, a1
0410: 7022                 moveq      #$22, d0
0412: c1eef7c4             muls.w     -$83c(a6), d0
0416: d08d                 add.l      a5, d0
0418: 2040                 movea.l    d0, a0
041a: 302ef7c2             move.w     -$83e(a6), d0
041e: d0c0                 adda.w     d0, a0
0420: d0c0                 adda.w     d0, a0
0422: 32299412             move.w     -$6bee(a1), d1
0426: 3141bf1e             move.w     d1, -$40e2(a0)
042a: 206ef7b2             movea.l    -$84e(a6), a0
042e: d1eef7a4             adda.l     -$85c(a6), a0
0432: 3081                 move.w     d1, (a0)
0434: 206ef7ba             movea.l    -$846(a6), a0
0438: 0c3000033000         cmpi.b     #$3, (a0, d3.w)
043e: 6604                 bne.b      $444
0440: 3c2b0012             move.w     $12(a3), d6
0444: 528c                 addq.l     #$1, a4
0446: 5243                 addq.w     #$1, d3
0448: 54aef7a4             addq.l     #$2, -$85c(a6)
044c: 526ef7c4             addq.w     #$1, -$83c(a6)
0450: 4a14                 tst.b      (a4)
0452: 6600fef2             bne.w      $346
0456: 7022                 moveq      #$22, d0
0458: c1edbcf6             muls.w     -$430a(a5), d0
045c: d08d                 add.l      a5, d0
045e: 2040                 movea.l    d0, a0
0460: 302dbcfa             move.w     -$4306(a5), d0
0464: d0c0                 adda.w     d0, a0
0466: d0c0                 adda.w     d0, a0
0468: 4268bf1e             clr.w      -$40e2(a0)
046c: 7222                 moveq      #$22, d1
046e: c3edbcf4             muls.w     -$430c(a5), d1
0472: d28d                 add.l      a5, d1
0474: 2041                 movea.l    d1, a0
0476: 322dbcf8             move.w     -$4308(a5), d1
047a: d0c1                 adda.w     d1, a0
047c: d0c1                 adda.w     d1, a0
047e: 4268bf1e             clr.w      -$40e2(a0)
0482: 0c6d000fbcf4         cmpi.w     #$f, -$430c(a5)
0488: 6f18                 ble.b      $4a2
048a: 7022                 moveq      #$22, d0
048c: c1edbcf8             muls.w     -$4308(a5), d0
0490: d08d                 add.l      a5, d0
0492: 2040                 movea.l    d0, a0
0494: 302dbcf4             move.w     -$430c(a5), d0
0498: d0c0                 adda.w     d0, a0
049a: d0c0                 adda.w     d0, a0
049c: 4268bf00             clr.w      -$4100(a0)
04a0: 601a                 bra.b      $4bc
04a2: 700f                 moveq      #$f, d0
04a4: d06dbcf8             add.w      -$4308(a5), d0
04a8: c1fc0022             muls.w     #$22, d0
04ac: d08d                 add.l      a5, d0
04ae: 2040                 movea.l    d0, a0
04b0: 302dbcf4             move.w     -$430c(a5), d0
04b4: d0c0                 adda.w     d0, a0
04b6: d0c0                 adda.w     d0, a0
04b8: 4268bf1e             clr.w      -$40e2(a0)
04bc: 0c6d000fbcf6         cmpi.w     #$f, -$430a(a5)
04c2: 6f18                 ble.b      $4dc
04c4: 7022                 moveq      #$22, d0
04c6: c1edbcfa             muls.w     -$4306(a5), d0
04ca: d08d                 add.l      a5, d0
04cc: 2040                 movea.l    d0, a0
04ce: 302dbcf6             move.w     -$430a(a5), d0
04d2: d0c0                 adda.w     d0, a0
04d4: d0c0                 adda.w     d0, a0
04d6: 4268bf00             clr.w      -$4100(a0)
04da: 601a                 bra.b      $4f6
04dc: 700f                 moveq      #$f, d0
04de: d06dbcfa             add.w      -$4306(a5), d0
04e2: c1fc0022             muls.w     #$22, d0
04e6: d08d                 add.l      a5, d0
04e8: 2040                 movea.l    d0, a0
04ea: 302dbcf6             move.w     -$430a(a5), d0
04ee: d0c0                 adda.w     d0, a0
04f0: d0c0                 adda.w     d0, a0
04f2: 4268bf1e             clr.w      -$40e2(a0)
04f6: 204d                 movea.l    a5, a0
04f8: d0c7                 adda.w     d7, a0
04fa: 117c00fff536         move.b     #$ff, -$aca(a0)
0500: 2f0a                 move.l     a2, -(a7)
0502: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
0506: 3047                 movea.w    d7, a0
0508: d088                 add.l      a0, d0
050a: 721f                 moveq      #$1f, d1
050c: b280                 cmp.l      d0, d1
050e: 588f                 addq.l     #$4, a7
0510: 6204                 bhi.b      $516
0512: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0516: 2f0a                 move.l     a2, -(a7)
0518: 204d                 movea.l    a5, a0
051a: d0c7                 adda.w     d7, a0
051c: 4868f537             pea.l      -$ac9(a0)
0520: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0524: 2e8a                 move.l     a2, (a7)
0526: 4eba01f6             jsr        $71e(pc)
052a: 4a6e0010             tst.w      $10(a6)
052e: 508f                 addq.l     #$8, a7
0530: 67000108             beq.w      $63a
0534: 102da5b8             move.b     -$5a48(a5), d0
0538: 4880                 ext.w      d0
053a: b06ef7b6             cmp.w      -$84a(a6), d0
053e: 6706                 beq.b      $546
0540: 2b6b0010a468         move.l     $10(a3), -$5b98(a5)
0546: 102da5bf             move.b     -$5a41(a5), d0
054a: 4880                 ext.w      d0
054c: b06ef79e             cmp.w      -$862(a6), d0
0550: 6706                 beq.b      $558
0552: 2b6b0010a460         move.l     $10(a3), -$5ba0(a5)
0558: 102da5c6             move.b     -$5a3a(a5), d0
055c: 4880                 ext.w      d0
055e: b06ef7b0             cmp.w      -$850(a6), d0
0562: 6706                 beq.b      $56a
0564: 2b6b0010a464         move.l     $10(a3), -$5b9c(a5)
056a: 102da5c8             move.b     -$5a38(a5), d0
056e: 4880                 ext.w      d0
0570: b06ef7ae             cmp.w      -$852(a6), d0
0574: 6706                 beq.b      $57c
0576: 2b6b0010a46c         move.l     $10(a3), -$5b94(a5)
057c: 102da58d             move.b     -$5a73(a5), d0
0580: 4880                 ext.w      d0
0582: b06ef79c             cmp.w      -$864(a6), d0
0586: 6706                 beq.b      $58e
0588: 2b6b0010a45c         move.l     $10(a3), -$5ba4(a5)
058e: 7001                 moveq      #$1, d0
0590: 2b40a440             move.l     d0, -$5bc0(a5)
0594: 0c450056             cmpi.w     #$56, d5
0598: 6d08                 blt.b      $5a2
059a: 2b6b0010a450         move.l     $10(a3), -$5bb0(a5)
05a0: 6022                 bra.b      $5c4
05a2: 0c45004d             cmpi.w     #$4d, d5
05a6: 6d08                 blt.b      $5b0
05a8: 2b6b0010a44c         move.l     $10(a3), -$5bb4(a5)
05ae: 6014                 bra.b      $5c4
05b0: 0c45001e             cmpi.w     #$1e, d5
05b4: 6d08                 blt.b      $5be
05b6: 2b6b0010a448         move.l     $10(a3), -$5bb8(a5)
05bc: 6006                 bra.b      $5c4
05be: 2b6b0010a444         move.l     $10(a3), -$5bbc(a5)
05c4: 486effce             pea.l      -$32(a6)
05c8: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
05cc: 4a80                 tst.l      d0
05ce: 588f                 addq.l     #$4, a7
05d0: 661e                 bne.b      $5f0
05d2: 0c6e0007f7a8         cmpi.w     #$7, -$858(a6)
05d8: 6616                 bne.b      $5f0
05da: 0cab000013880010     cmpi.l     #$1388, $10(a3)
05e2: 6d0c                 blt.b      $5f0
05e4: 2b6b0010a454         move.l     $10(a3), -$5bac(a5)
05ea: 7001                 moveq      #$1, d0
05ec: 2b40a458             move.l     d0, -$5ba8(a5)
05f0: 306ef79e             movea.w    -$862(a6), a0
05f4: 2b48a48c             move.l     a0, -$5b74(a5)
05f8: 306ef79c             movea.w    -$864(a6), a0
05fc: 2b48a490             move.l     a0, -$5b70(a5)
0600: 4a46                 tst.w      d6
0602: 670c                 beq.b      $610
0604: 3046                 movea.w    d6, a0
0606: 2b48a470             move.l     a0, -$5b90(a5)
060a: 7001                 moveq      #$1, d0
060c: 2b40a474             move.l     d0, -$5b8c(a5)
0610: 7600                 moveq      #$0, d3
0612: 49eef7c6             lea.l      -$83a(a6), a4
0616: 47eefbc6             lea.l      -$43a(a6), a3
061a: 601a                 bra.b      $636
061c: 3f13                 move.w     (a3), -(a7)
061e: 4ead09f2             jsr        $9f2(a5) ; CODE35+0034
0622: 4a40                 tst.w      d0
0624: 548f                 addq.l     #$2, a7
0626: 6708                 beq.b      $630
0628: 3014                 move.w     (a4), d0
062a: 48c0                 ext.l      d0
062c: d1ada478             add.l      d0, -$5b88(a5)
0630: 5243                 addq.w     #$1, d3
0632: 548c                 addq.l     #$2, a4
0634: 548b                 addq.l     #$2, a3
0636: 4a53                 tst.w      (a3)
0638: 66e2                 bne.b      $61c
063a: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
063e: 4e5e                 unlk       a6
0640: 4e75                 rts        
0642: 4e56fffc             link.w     a6, #$fffc
0646: 48e70718             movem.l    d5-d7/a3-a4, -(a7)
064a: 7e01                 moveq      #$1, d7
064c: 1c2df536             move.b     -$aca(a5), d6
0650: 4886                 ext.w      d6
0652: 4a46                 tst.w      d6
0654: 663c                 bne.b      $692
0656: 0c2d00fff537         cmpi.b     #$ff, -$ac9(a5)
065c: 6704                 beq.b      $662
065e: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0662: 4a2dbcfe             tst.b      -$4302(a5)
0666: 6716                 beq.b      $67e
0668: 204d                 movea.l    a5, a0
066a: d0c7                 adda.w     d7, a0
066c: 4868f537             pea.l      -$ac9(a0)
0670: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
0674: 5f80                 subq.l     #$7, d0
0676: 588f                 addq.l     #$4, a7
0678: 6704                 beq.b      $67e
067a: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
067e: 536db3f2             subq.w     #$1, -$4c0e(a5)
0682: 48780011             pea.l      $11.w
0686: 486dbcfe             pea.l      -$4302(a5)
068a: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
068e: 508f                 addq.l     #$8, a7
0690: 6072                 bra.b      $704
0692: 7011                 moveq      #$11, d0
0694: c1c6                 muls.w     d6, d0
0696: 49edbcfe             lea.l      -$4302(a5), a4
069a: d08c                 add.l      a4, d0
069c: 2840                 movea.l    d0, a4
069e: 7022                 moveq      #$22, d0
06a0: c1c6                 muls.w     d6, d0
06a2: 47edbf1e             lea.l      -$40e2(a5), a3
06a6: d08b                 add.l      a3, d0
06a8: 2640                 movea.l    d0, a3
06aa: 604a                 bra.b      $6f6
06ac: 486efffc             pea.l      -$4(a6)
06b0: 486efffe             pea.l      -$2(a6)
06b4: 3f05                 move.w     d5, -(a7)
06b6: 3f06                 move.w     d6, -(a7)
06b8: 4ebaf9be             jsr        $78(pc)
06bc: 7011                 moveq      #$11, d0
06be: c1eefffe             muls.w     -$2(a6), d0
06c2: d08d                 add.l      a5, d0
06c4: 306efffc             movea.w    -$4(a6), a0
06c8: d1c0                 adda.l     d0, a0
06ca: 4228bcfe             clr.b      -$4302(a0)
06ce: 42345000             clr.b      (a4, d5.w)
06d2: 7022                 moveq      #$22, d0
06d4: c1eefffe             muls.w     -$2(a6), d0
06d8: d08d                 add.l      a5, d0
06da: 2040                 movea.l    d0, a0
06dc: 302efffc             move.w     -$4(a6), d0
06e0: d0c0                 adda.w     d0, a0
06e2: d0c0                 adda.w     d0, a0
06e4: 4268bf1e             clr.w      -$40e2(a0)
06e8: 204b                 movea.l    a3, a0
06ea: d0c5                 adda.w     d5, a0
06ec: 42705000             clr.w      (a0, d5.w)
06f0: 4fef000c             lea.l      $c(a7), a7
06f4: 5247                 addq.w     #$1, d7
06f6: 204d                 movea.l    a5, a0
06f8: d0c7                 adda.w     d7, a0
06fa: 1a28f536             move.b     -$aca(a0), d5
06fe: 4885                 ext.w      d5
0700: 4a45                 tst.w      d5
0702: 6ea8                 bgt.b      $6ac
0704: 204d                 movea.l    a5, a0
0706: d0c7                 adda.w     d7, a0
0708: 4868f537             pea.l      -$ac9(a0)
070c: 2f2e0008             move.l     $8(a6), -(a7)
0710: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0714: 4cee18e0ffe8         movem.l    -$18(a6), d5-d7/a3-a4
071a: 4e5e                 unlk       a6
071c: 4e75                 rts        
071e: 4e560000             link.w     a6, #$0
0722: 48e70718             movem.l    d5-d7/a3-a4, -(a7)
0726: 266e0008             movea.l    $8(a6), a3
072a: 286d99d2             movea.l    -$662e(a5), a4
072e: 601a                 bra.b      $74a
0730: 204d                 movea.l    a5, a0
0732: d0c7                 adda.w     d7, a0
0734: 1c28a54e             move.b     -$5ab2(a0), d6
0738: 4886                 ext.w      d6
073a: 7a00                 moveq      #$0, d5
073c: 6006                 bra.b      $744
073e: 1687                 move.b     d7, (a3)
0740: 5245                 addq.w     #$1, d5
0742: 528b                 addq.l     #$1, a3
0744: bc45                 cmp.w      d5, d6
0746: 6ef6                 bgt.b      $73e
0748: 528c                 addq.l     #$1, a4
074a: 1e14                 move.b     (a4), d7
074c: 4887                 ext.w      d7
074e: 4a47                 tst.w      d7
0750: 66de                 bne.b      $730
0752: 4213                 clr.b      (a3)
0754: 4cdf18e0             movem.l    (a7)+, d5-d7/a3-a4
0758: 4e5e                 unlk       a6
075a: 4e75                 rts        
075c: 4e560000             link.w     a6, #$0
0760: 48e70738             movem.l    d5-d7/a2-a4, -(a7)
0764: 2e2e0008             move.l     $8(a6), d7
0768: 7c00                 moveq      #$0, d6
076a: 48780080             pea.l      $80.w
076e: 486d9512             pea.l      -$6aee(a5)
0772: 2f07                 move.l     d7, -(a7)
0774: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0778: 47edbd0f             lea.l      -$42f1(a5), a3
077c: 49edbf40             lea.l      -$40c0(a5), a4
0780: 4fef000c             lea.l      $c(a7), a7
0784: 601e                 bra.b      $7a4
0786: 1a13                 move.b     (a3), d5
0788: 4885                 ext.w      d5
078a: 4a45                 tst.w      d5
078c: 6712                 beq.b      $7a0
078e: 4a54                 tst.w      (a4)
0790: 6708                 beq.b      $79a
0792: 3045                 movea.w    d5, a0
0794: 53307800             subq.b     #$1, (a0, d7.l)
0798: 6006                 bra.b      $7a0
079a: 2047                 movea.l    d7, a0
079c: 5328003f             subq.b     #$1, $3f(a0)
07a0: 528b                 addq.l     #$1, a3
07a2: 548c                 addq.l     #$2, a4
07a4: 41edbe0e             lea.l      -$41f2(a5), a0
07a8: b1cb                 cmpa.l     a3, a0
07aa: 62da                 bhi.b      $786
07ac: 266d99d2             movea.l    -$662e(a5), a3
07b0: 601c                 bra.b      $7ce
07b2: 3445                 movea.w    d5, a2
07b4: d5c7                 adda.l     d7, a2
07b6: 204d                 movea.l    a5, a0
07b8: d0c5                 adda.w     d5, a0
07ba: 1028a54e             move.b     -$5ab2(a0), d0
07be: 9112                 sub.b      d0, (a2)
07c0: 4a12                 tst.b      (a2)
07c2: 6c02                 bge.b      $7c6
07c4: 4212                 clr.b      (a2)
07c6: 1012                 move.b     (a2), d0
07c8: 4880                 ext.w      d0
07ca: dc40                 add.w      d0, d6
07cc: 528b                 addq.l     #$1, a3
07ce: 1a13                 move.b     (a3), d5
07d0: 4885                 ext.w      d5
07d2: 4a45                 tst.w      d5
07d4: 66dc                 bne.b      $7b2
07d6: 3006                 move.w     d6, d0
07d8: 4cdf1ce0             movem.l    (a7)+, d5-d7/a2-a4
07dc: 4e5e                 unlk       a6
07de: 4e75                 rts        
07e0: 4e56ff74             link.w     a6, #$ff74
07e4: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
07e8: 286e0008             movea.l    $8(a6), a4
07ec: 486eff80             pea.l      -$80(a6)
07f0: 4eba00cc             jsr        $8be(pc)
07f4: 2e00                 move.l     d0, d7
07f6: 2e8c                 move.l     a4, (a7)
07f8: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
07fc: 2c00                 move.l     d0, d6
07fe: 7008                 moveq      #$8, d0
0800: 9086                 sub.l      d6, d0
0802: b087                 cmp.l      d7, d0
0804: 588f                 addq.l     #$4, a7
0806: 6456                 bcc.b      $85e
0808: 486eff7c             pea.l      -$84(a6)
080c: 4ead069a             jsr        $69a(a5) ; CODE9+0076
0810: 2d6eff7cff78         move.l     -$84(a6), -$88(a6)
0816: 47eeff7f             lea.l      -$81(a6), a3
081a: d7c7                 adda.l     d7, a3
081c: 588f                 addq.l     #$4, a7
081e: 6034                 bra.b      $854
0820: 4ead05b2             jsr        $5b2(a5) ; CODE4+0004
0824: 2d40ff74             move.l     d0, -$8c(a6)
0828: 4ead06e2             jsr        $6e2(a5) ; CODE9+006e
082c: 2f07                 move.l     d7, -(a7)
082e: 48c0                 ext.l      d0
0830: d0aeff74             add.l      -$8c(a6), d0
0834: 2f00                 move.l     d0, -(a7)
0836: 4ead0052             jsr        $52(a5) ; CODE1+0144
083a: 2a00                 move.l     d0, d5
083c: 45f65880             lea.l      -$80(a6, d5.l), a2
0840: 1812                 move.b     (a2), d4
0842: 4884                 ext.w      d4
0844: 48c4                 ext.l      d4
0846: 1493                 move.b     (a3), (a2)
0848: 1684                 move.b     d4, (a3)
084a: 486eff78             pea.l      -$88(a6)
084e: 4ead069a             jsr        $69a(a5) ; CODE9+0076
0852: 588f                 addq.l     #$4, a7
0854: 202eff78             move.l     -$88(a6), d0
0858: b0aeff7c             cmp.l      -$84(a6), d0
085c: 67c2                 beq.b      $820
085e: 7800                 moveq      #$0, d4
0860: 6038                 bra.b      $89a
0862: 4ead05b2             jsr        $5b2(a5) ; CODE4+0004
0866: 2a00                 move.l     d0, d5
0868: 4ead06e2             jsr        $6e2(a5) ; CODE9+006e
086c: 3040                 movea.w    d0, a0
086e: da88                 add.l      a0, d5
0870: daaeff7c             add.l      -$84(a6), d5
0874: 2f07                 move.l     d7, -(a7)
0876: 2f05                 move.l     d5, -(a7)
0878: 4ead0052             jsr        $52(a5) ; CODE1+0144
087c: 2a00                 move.l     d0, d5
087e: 45f65880             lea.l      -$80(a6, d5.l), a2
0882: 2006                 move.l     d6, d0
0884: 5286                 addq.l     #$1, d6
0886: 19920800             move.b     (a2), (a4, d0.l)
088a: 5387                 subq.l     #$1, d7
088c: 14b67880             move.b     -$80(a6, d7.l), (a2)
0890: 5284                 addq.l     #$1, d4
0892: 06ae000000d3ff7c     addi.l     #$d3, -$84(a6)
089a: 7007                 moveq      #$7, d0
089c: b086                 cmp.l      d6, d0
089e: 6304                 bls.b      $8a4
08a0: 4a87                 tst.l      d7
08a2: 62be                 bhi.b      $862
08a4: 42346800             clr.b      (a4, d6.l)
08a8: 48780011             pea.l      $11.w
08ac: 486dbcfe             pea.l      -$4302(a5)
08b0: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
08b4: 4cee1cf0ff58         movem.l    -$a8(a6), d4-d7/a2-a4
08ba: 4e5e                 unlk       a6
08bc: 4e75                 rts        
08be: 4e56ff78             link.w     a6, #$ff78
08c2: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
08c6: 2e2e0008             move.l     $8(a6), d7
08ca: 2c07                 move.l     d7, d6
08cc: 48780080             pea.l      $80.w
08d0: 486d9512             pea.l      -$6aee(a5)
08d4: 486eff80             pea.l      -$80(a6)
08d8: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
08dc: 7800                 moveq      #$0, d4
08de: 45edbf1e             lea.l      -$40e2(a5), a2
08e2: 47edbcfe             lea.l      -$4302(a5), a3
08e6: 4fef000c             lea.l      $c(a7), a7
08ea: 604a                 bra.b      $936
08ec: 7a00                 moveq      #$0, d5
08ee: 2d4bff78             move.l     a3, -$88(a6)
08f2: 2d4aff7c             move.l     a2, -$84(a6)
08f6: 3845                 movea.w    d5, a4
08f8: d9cc                 adda.l     a4, a4
08fa: 602a                 bra.b      $926
08fc: 206eff78             movea.l    -$88(a6), a0
0900: 16305000             move.b     (a0, d5.w), d3
0904: 4883                 ext.w      d3
0906: 4a43                 tst.w      d3
0908: 6718                 beq.b      $922
090a: 204c                 movea.l    a4, a0
090c: d1eeff7c             adda.l     -$84(a6), a0
0910: 4a50                 tst.w      (a0)
0912: 6604                 bne.b      $918
0914: 4a44                 tst.w      d4
0916: 6606                 bne.b      $91e
0918: 53363080             subq.b     #$1, -$80(a6, d3.w)
091c: 6004                 bra.b      $922
091e: 532effbf             subq.b     #$1, -$41(a6)
0922: 5245                 addq.w     #$1, d5
0924: 548c                 addq.l     #$2, a4
0926: 0c450010             cmpi.w     #$10, d5
092a: 6dd0                 blt.b      $8fc
092c: 5244                 addq.w     #$1, d4
092e: 45ea0022             lea.l      $22(a2), a2
0932: 47eb0011             lea.l      $11(a3), a3
0936: 0c440010             cmpi.w     #$10, d4
093a: 6db0                 blt.b      $8ec
093c: 45edc35e             lea.l      -$3ca2(a5), a2
0940: 6004                 bra.b      $946
0942: 53363080             subq.b     #$1, -$80(a6, d3.w)
0946: 161a                 move.b     (a2)+, d3
0948: 4883                 ext.w      d3
094a: 4a43                 tst.w      d3
094c: 66f4                 bne.b      $942
094e: 45edc366             lea.l      -$3c9a(a5), a2
0952: 6004                 bra.b      $958
0954: 53363080             subq.b     #$1, -$80(a6, d3.w)
0958: 161a                 move.b     (a2)+, d3
095a: 4883                 ext.w      d3
095c: 4a43                 tst.w      d3
095e: 66f4                 bne.b      $954
0960: 246d99d2             movea.l    -$662e(a5), a2
0964: 6014                 bra.b      $97a
0966: 18363080             move.b     -$80(a6, d3.w), d4
096a: 4884                 ext.w      d4
096c: 6008                 bra.b      $976
096e: 2047                 movea.l    d7, a0
0970: 5287                 addq.l     #$1, d7
0972: 1083                 move.b     d3, (a0)
0974: 5344                 subq.w     #$1, d4
0976: 4a44                 tst.w      d4
0978: 6ef4                 bgt.b      $96e
097a: 161a                 move.b     (a2)+, d3
097c: 4883                 ext.w      d3
097e: 4a43                 tst.w      d3
0980: 66e4                 bne.b      $966
0982: 2047                 movea.l    d7, a0
0984: 4210                 clr.b      (a0)
0986: 2007                 move.l     d7, d0
0988: 9086                 sub.l      d6, d0
098a: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
098e: 4e5e                 unlk       a6
0990: 4e75                 rts        
0992: 4e560000             link.w     a6, #$0
0996: 48e70108             movem.l    d7/a4, -(a7)
099a: 286d99d2             movea.l    -$662e(a5), a4
099e: 600a                 bra.b      $9aa
09a0: 204d                 movea.l    a5, a0
09a2: d0c7                 adda.w     d7, a0
09a4: 4228a54e             clr.b      -$5ab2(a0)
09a8: 528c                 addq.l     #$1, a4
09aa: 1e14                 move.b     (a4), d7
09ac: 4887                 ext.w      d7
09ae: 4a47                 tst.w      d7
09b0: 66ee                 bne.b      $9a0
09b2: 286e0008             movea.l    $8(a6), a4
09b6: 600a                 bra.b      $9c2
09b8: 204d                 movea.l    a5, a0
09ba: d0c7                 adda.w     d7, a0
09bc: 5228a54e             addq.b     #$1, -$5ab2(a0)
09c0: 528c                 addq.l     #$1, a4
09c2: 1e14                 move.b     (a4), d7
09c4: 4887                 ext.w      d7
09c6: 4a47                 tst.w      d7
09c8: 66ee                 bne.b      $9b8
09ca: 4cdf1080             movem.l    (a7)+, d7/a4
09ce: 4e5e                 unlk       a6
09d0: 4e75                 rts        
