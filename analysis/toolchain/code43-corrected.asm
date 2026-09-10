0004: 4e56fffc             link.w     a6, #$fffc
0008: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
000c: 206e0008             movea.l    $8(a6), a0
0010: 7a00                 moveq      #$0, d5
0012: 1a28000d             move.b     $d(a0), d5
0016: 2e05                 move.l     d5, d7
0018: 48c7                 ext.l      d7
001a: 8ffc0020             divs.w     #$20, d7
001e: 4847                 swap       d7
0020: 48c5                 ext.l      d5
0022: 8bfc0020             divs.w     #$20, d5
0026: 7006                 moveq      #$6, d0
0028: c1c5                 muls.w     d5, d0
002a: 49edf980             lea.l      -$680(a5), a4
002e: d08c                 add.l      a4, d0
0030: 2840                 movea.l    d0, a4
0032: 4a54                 tst.w      (a4)
0034: 665a                 bne.b      $90
0036: 206e000c             movea.l    $c(a6), a0
003a: 16280020             move.b     $20(a0), d3
003e: 4883                 ext.w      d3
0040: 18280021             move.b     $21(a0), d4
0044: 4884                 ext.w      d4
0046: 7011                 moveq      #$11, d0
0048: c1c3                 muls.w     d3, d0
004a: 45edbcfe             lea.l      -$4302(a5), a2
004e: d08a                 add.l      a2, d0
0050: 3444                 movea.w    d4, a2
0052: d08a                 add.l      a2, d0
0054: 2440                 movea.l    d0, a2
0056: 7044                 moveq      #$44, d0
0058: c1c3                 muls.w     d3, d0
005a: 323c0880             move.w     #$880, d1
005e: c3c5                 muls.w     d5, d1
0060: d2adcf08             add.l      -$30f8(a5), d1
0064: d081                 add.l      d1, d0
0066: 2204                 move.l     d4, d1
0068: 48c1                 ext.l      d1
006a: e589                 lsl.l      #$2, d1
006c: d280                 add.l      d0, d1
006e: 2641                 movea.l    d1, a3
0070: 7a00                 moveq      #$0, d5
0072: 2c08                 move.l     a0, d6
0074: 600c                 bra.b      $82
0076: 4a12                 tst.b      (a2)
0078: 6602                 bne.b      $7c
007a: 8a93                 or.l       (a3), d5
007c: 5286                 addq.l     #$1, d6
007e: 528a                 addq.l     #$1, a2
0080: 588b                 addq.l     #$4, a3
0082: 2046                 movea.l    d6, a0
0084: 4a10                 tst.b      (a0)
0086: 66ee                 bne.b      $76
0088: 29450002             move.l     d5, $2(a4)
008c: 38bc0001             move.w     #$1, (a4)
0090: 204d                 movea.l    a5, a0
0092: 2007                 move.l     d7, d0
0094: 48c0                 ext.l      d0
0096: e588                 lsl.l      #$2, d0
0098: d1c0                 adda.l     d0, a0
009a: 202899d6             move.l     -$662a(a0), d0
009e: c0ac0002             and.l      $2(a4), d0
00a2: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
00a6: 4e5e                 unlk       a6
00a8: 4e75                 rts        
00aa: 48780030             pea.l      $30.w
00ae: 486df980             pea.l      -$680(a5)
00b2: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
00b6: 508f                 addq.l     #$8, a7
00b8: 4e75                 rts        
00ba: 4e56fff4             link.w     a6, #$fff4
00be: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
00c2: 48780080             pea.l      $80.w
00c6: 486dce84             pea.l      -$317c(a5)
00ca: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
00ce: 7c00                 moveq      #$0, d6
00d0: 49edccfc             lea.l      -$3304(a5), a4
00d4: 508f                 addq.l     #$8, a7
00d6: 600000f4             bra.w      $1cc
00da: 3814                 move.w     (a4), d4
00dc: 3f04                 move.w     d4, -(a7)
00de: 4ead0992             jsr        $992(a5) ; CODE32+0650
00e2: 2640                 movea.l    d0, a3
00e4: 244b                 movea.l    a3, a2
00e6: 548f                 addq.l     #$2, a7
00e8: 600a                 bra.b      $f4
00ea: 204d                 movea.l    a5, a0
00ec: d0c3                 adda.w     d3, a0
00ee: 5228ce84             addq.b     #$1, -$317c(a0)
00f2: 528a                 addq.l     #$1, a2
00f4: 1612                 move.b     (a2), d3
00f6: 4883                 ext.w      d3
00f8: 4a43                 tst.w      d3
00fa: 66ee                 bne.b      $ea
00fc: 102dcec3             move.b     -$313d(a5), d0
0100: b02da58d             cmp.b      -$5a73(a5), d0
0104: 6c0000ac             bge.w      $1b2
0108: 244b                 movea.l    a3, a2
010a: 2e04                 move.l     d4, d7
010c: 48c7                 ext.l      d7
010e: e58f                 lsl.l      #$2, d7
0110: 41eda756             lea.l      -$58aa(a5), a0
0114: de88                 add.l      a0, d7
0116: 60000090             bra.w      $1a8
011a: 0c43003f             cmpi.w     #$3f, d3
011e: 67000086             beq.w      $1a6
0122: 102a0001             move.b     $1(a2), d0
0126: 4880                 ext.w      d0
0128: b043                 cmp.w      d3, d0
012a: 677a                 beq.b      $1a6
012c: 3a04                 move.w     d4, d5
012e: 2003                 move.l     d3, d0
0130: 48c0                 ext.l      d0
0132: e988                 lsl.l      #$4, d0
0134: 204d                 movea.l    a5, a0
0136: d0c3                 adda.w     d3, a0
0138: 1228ce84             move.b     -$317c(a0), d1
013c: 4881                 ext.w      d1
013e: 41edb3f2             lea.l      -$4c0e(a5), a0
0142: d088                 add.l      a0, d0
0144: 3041                 movea.w    d1, a0
0146: d1c8                 adda.l     a0, a0
0148: ca700800             and.w      (a0, d0.l), d5
014c: 102dcec3             move.b     -$313d(a5), d0
0150: 4880                 ext.w      d0
0152: 204d                 movea.l    a5, a0
0154: d0c0                 adda.w     d0, a0
0156: d0c0                 adda.w     d0, a0
0158: 3028b7e4             move.w     -$481c(a0), d0
015c: 4640                 not.w      d0
015e: 0240007f             andi.w     #$7f, d0
0162: 8a40                 or.w       d0, d5
0164: 2005                 move.l     d5, d0
0166: 48c0                 ext.l      d0
0168: e588                 lsl.l      #$2, d0
016a: 41eda756             lea.l      -$58aa(a5), a0
016e: d088                 add.l      a0, d0
0170: 2d40fff8             move.l     d0, -$8(a6)
0174: 41ed9412             lea.l      -$6bee(a5), a0
0178: d0c3                 adda.w     d3, a0
017a: d0c3                 adda.w     d3, a0
017c: 2d48fffc             move.l     a0, -$4(a6)
0180: 2240                 movea.l    d0, a1
0182: 3050                 movea.w    (a0), a0
0184: 2d51fff4             move.l     (a1), -$c(a6)
0188: 2247                 movea.l    d7, a1
018a: 2211                 move.l     (a1), d1
018c: 9288                 sub.l      a0, d1
018e: b2aefff4             cmp.l      -$c(a6), d1
0192: 6f12                 ble.b      $1a6
0194: 206efffc             movea.l    -$4(a6), a0
0198: 3050                 movea.w    (a0), a0
019a: 2247                 movea.l    d7, a1
019c: 2011                 move.l     (a1), d0
019e: 9088                 sub.l      a0, d0
01a0: 206efff8             movea.l    -$8(a6), a0
01a4: 2080                 move.l     d0, (a0)
01a6: 528a                 addq.l     #$1, a2
01a8: 1612                 move.b     (a2), d3
01aa: 4883                 ext.w      d3
01ac: 4a43                 tst.w      d3
01ae: 6600ff6a             bne.w      $11a
01b2: 244b                 movea.l    a3, a2
01b4: 600a                 bra.b      $1c0
01b6: 204d                 movea.l    a5, a0
01b8: d0c3                 adda.w     d3, a0
01ba: 4228ce84             clr.b      -$317c(a0)
01be: 528a                 addq.l     #$1, a2
01c0: 1612                 move.b     (a2), d3
01c2: 4883                 ext.w      d3
01c4: 4a43                 tst.w      d3
01c6: 66ee                 bne.b      $1b6
01c8: 5246                 addq.w     #$1, d6
01ca: 548c                 addq.l     #$2, a4
01cc: bc6dccfa             cmp.w      -$3306(a5), d6
01d0: 6d00ff08             blt.w      $da
01d4: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
01d8: 4e5e                 unlk       a6
01da: 4e75                 rts        
01dc: 4e56fffc             link.w     a6, #$fffc
01e0: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
01e4: 2f2e0008             move.l     $8(a6), -(a7)
01e8: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
01ec: 204d                 movea.l    a5, a0
01ee: e588                 lsl.l      #$2, d0
01f0: d1c0                 adda.l     d0, a0
01f2: 3c3c0080             move.w     #$80, d6
01f6: 9c6899d8             sub.w      -$6628(a0), d6
01fa: 7a00                 moveq      #$0, d5
01fc: 41edccfc             lea.l      -$3304(a5), a0
0200: 2d48fffc             move.l     a0, -$4(a6)
0204: 588f                 addq.l     #$4, a7
0206: 606c                 bra.b      $274
0208: 206efffc             movea.l    -$4(a6), a0
020c: 3810                 move.w     (a0), d4
020e: 3006                 move.w     d6, d0
0210: c044                 and.w      d4, d0
0212: b046                 cmp.w      d6, d0
0214: 6658                 bne.b      $26e
0216: 3f04                 move.w     d4, -(a7)
0218: 3f3c007f             move.w     #$7f, -(a7)
021c: 4ead09aa             jsr        $9aa(a5) ; CODE32+1242
0220: 8046                 or.w       d6, d0
0222: 3600                 move.w     d0, d3
0224: b843                 cmp.w      d3, d4
0226: 588f                 addq.l     #$4, a7
0228: 6d44                 blt.b      $26e
022a: 2004                 move.l     d4, d0
022c: 48c0                 ext.l      d0
022e: e588                 lsl.l      #$2, d0
0230: 47eda756             lea.l      -$58aa(a5), a3
0234: d08b                 add.l      a3, d0
0236: 2640                 movea.l    d0, a3
0238: 2e13                 move.l     (a3), d7
023a: 2003                 move.l     d3, d0
023c: 48c0                 ext.l      d0
023e: e588                 lsl.l      #$2, d0
0240: 45eda756             lea.l      -$58aa(a5), a2
0244: d08a                 add.l      a2, d0
0246: 2440                 movea.l    d0, a2
0248: 2692                 move.l     (a2), (a3)
024a: 2487                 move.l     d7, (a2)
024c: 2004                 move.l     d4, d0
024e: 48c0                 ext.l      d0
0250: e588                 lsl.l      #$2, d0
0252: 45edcf30             lea.l      -$30d0(a5), a2
0256: d08a                 add.l      a2, d0
0258: 2440                 movea.l    d0, a2
025a: 2e12                 move.l     (a2), d7
025c: 2003                 move.l     d3, d0
025e: 48c0                 ext.l      d0
0260: e588                 lsl.l      #$2, d0
0262: 47edcf30             lea.l      -$30d0(a5), a3
0266: d08b                 add.l      a3, d0
0268: 2640                 movea.l    d0, a3
026a: 2493                 move.l     (a3), (a2)
026c: 2687                 move.l     d7, (a3)
026e: 5245                 addq.w     #$1, d5
0270: 54aefffc             addq.l     #$2, -$4(a6)
0274: ba6dccfa             cmp.w      -$3306(a5), d5
0278: 6d8e                 blt.b      $208
027a: 3f3c003f             move.w     #$3f, -(a7)
027e: 2f2e0008             move.l     $8(a6), -(a7)
0282: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
0286: 4a80                 tst.l      d0
0288: 5c8f                 addq.l     #$6, a7
028a: 6704                 beq.b      $290
028c: 4ebafe2c             jsr        $ba(pc)
0290: 7a00                 moveq      #$0, d5
0292: 49edccfc             lea.l      -$3304(a5), a4
0296: 606e                 bra.b      $306
0298: 3814                 move.w     (a4), d4
029a: 204d                 movea.l    a5, a0
029c: 2004                 move.l     d4, d0
029e: 48c0                 ext.l      d0
02a0: e588                 lsl.l      #$2, d0
02a2: d1c0                 adda.l     d0, a0
02a4: 2c28cf30             move.l     -$30d0(a0), d6
02a8: 2004                 move.l     d4, d0
02aa: 48c0                 ext.l      d0
02ac: e588                 lsl.l      #$2, d0
02ae: 45edcf30             lea.l      -$30d0(a5), a2
02b2: d08a                 add.l      a2, d0
02b4: 2440                 movea.l    d0, a2
02b6: 4a86                 tst.l      d6
02b8: 6620                 bne.b      $2da
02ba: 204d                 movea.l    a5, a0
02bc: 2004                 move.l     d4, d0
02be: 48c0                 ext.l      d0
02c0: e588                 lsl.l      #$2, d0
02c2: d1c0                 adda.l     d0, a0
02c4: 4aa8a756             tst.l      -$58aa(a0)
02c8: 6710                 beq.b      $2da
02ca: 204d                 movea.l    a5, a0
02cc: d0c4                 adda.w     d4, a0
02ce: d0c4                 adda.w     d4, a0
02d0: 3028cbfa             move.w     -$3406(a0), d0
02d4: d040                 add.w      d0, d0
02d6: 48c0                 ext.l      d0
02d8: 6004                 bra.b      $2de
02da: 2006                 move.l     d6, d0
02dc: 4480                 neg.l      d0
02de: 204d                 movea.l    a5, a0
02e0: 2204                 move.l     d4, d1
02e2: 48c1                 ext.l      d1
02e4: e589                 lsl.l      #$2, d1
02e6: d1c1                 adda.l     d1, a0
02e8: d0a8a756             add.l      -$58aa(a0), d0
02ec: 2480                 move.l     d0, (a2)
02ee: 204d                 movea.l    a5, a0
02f0: 2004                 move.l     d4, d0
02f2: 48c0                 ext.l      d0
02f4: e588                 lsl.l      #$2, d0
02f6: d1c0                 adda.l     d0, a0
02f8: 4aa8cf30             tst.l      -$30d0(a0)
02fc: 6c04                 bge.b      $302
02fe: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0302: 5245                 addq.w     #$1, d5
0304: 548c                 addq.l     #$2, a4
0306: ba6dccfa             cmp.w      -$3306(a5), d5
030a: 6d8c                 blt.b      $298
030c: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0310: 4e5e                 unlk       a6
0312: 4e75                 rts        
0314: 4e56ffee             link.w     a6, #$ffee
0318: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
031c: 48784400             pea.l      $4400.w
0320: 2f2dcf08             move.l     -$30f8(a5), -(a7)
0324: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0328: 286e0008             movea.l    $8(a6), a4
032c: 508f                 addq.l     #$8, a7
032e: 60000196             bra.w      $4c6
0332: 7600                 moveq      #$0, d3
0334: 162c000d             move.b     $d(a4), d3
0338: 2c03                 move.l     d3, d6
033a: 48c6                 ext.l      d6
033c: 8dfc0020             divs.w     #$20, d6
0340: 4a46                 tst.w      d6
0342: 6d06                 blt.b      $34a
0344: 0c460008             cmpi.w     #$8, d6
0348: 6d04                 blt.b      $34e
034a: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
034e: 48c3                 ext.l      d3
0350: 87fc0020             divs.w     #$20, d3
0354: 4843                 swap       d3
0356: 4a43                 tst.w      d3
0358: 6d06                 blt.b      $360
035a: 0c430020             cmpi.w     #$20, d3
035e: 6504                 bcs.b      $364
0360: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0364: 204d                 movea.l    a5, a0
0366: 2003                 move.l     d3, d0
0368: 48c0                 ext.l      d0
036a: e588                 lsl.l      #$2, d0
036c: d1c0                 adda.l     d0, a0
036e: 2a2899d6             move.l     -$662a(a0), d5
0372: 162c000a             move.b     $a(a4), d3
0376: 4883                 ext.w      d3
0378: 4a43                 tst.w      d3
037a: 6d06                 blt.b      $382
037c: 0c43001f             cmpi.w     #$1f, d3
0380: 6d04                 blt.b      $386
0382: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0386: 4a43                 tst.w      d3
0388: 6700013a             beq.w      $4c4
038c: 182c000b             move.b     $b(a4), d4
0390: 4884                 ext.w      d4
0392: 4a44                 tst.w      d4
0394: 6f06                 ble.b      $39c
0396: 0c44000f             cmpi.w     #$f, d4
039a: 6d04                 blt.b      $3a0
039c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
03a0: 7011                 moveq      #$11, d0
03a2: c1c3                 muls.w     d3, d0
03a4: 41edbcfe             lea.l      -$4302(a5), a0
03a8: d088                 add.l      a0, d0
03aa: 3044                 movea.w    d4, a0
03ac: d088                 add.l      a0, d0
03ae: 2d40fff0             move.l     d0, -$10(a6)
03b2: 122c000c             move.b     $c(a4), d1
03b6: 4881                 ext.w      d1
03b8: 3041                 movea.w    d1, a0
03ba: d088                 add.l      a0, d0
03bc: 2d40fffc             move.l     d0, -$4(a6)
03c0: 323c0880             move.w     #$880, d1
03c4: c3c6                 muls.w     d6, d1
03c6: 2d41fff8             move.l     d1, -$8(a6)
03ca: 2404                 move.l     d4, d2
03cc: 48c2                 ext.l      d2
03ce: e58a                 lsl.l      #$2, d2
03d0: 2442                 movea.l    d2, a2
03d2: 7444                 moveq      #$44, d2
03d4: c5c3                 muls.w     d3, d2
03d6: d2adcf08             add.l      -$30f8(a5), d1
03da: d481                 add.l      d1, d2
03dc: d48a                 add.l      a2, d2
03de: 2e02                 move.l     d2, d7
03e0: 0c440001             cmpi.w     #$1, d4
03e4: 6704                 beq.b      $3ea
03e6: 2047                 movea.l    d7, a0
03e8: 8ba0                 or.l       d5, -(a0)
03ea: 7c01                 moveq      #$1, d6
03ec: dc43                 add.w      d3, d6
03ee: 70ff                 moveq      #$ff, d0
03f0: d043                 add.w      d3, d0
03f2: 3d40ffee             move.w     d0, -$12(a6)
03f6: 2d4afff4             move.l     a2, -$c(a6)
03fa: 600000b2             bra.w      $4ae
03fe: 206efff0             movea.l    -$10(a6), a0
0402: 4a10                 tst.b      (a0)
0404: 6600009c             bne.w      $4a2
0408: 4a44                 tst.w      d4
040a: 6f06                 ble.b      $412
040c: 0c440010             cmpi.w     #$10, d4
0410: 6d04                 blt.b      $416
0412: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0416: 2047                 movea.l    d7, a0
0418: 8b90                 or.l       d5, (a0)
041a: 3606                 move.w     d6, d3
041c: 7044                 moveq      #$44, d0
041e: c1c3                 muls.w     d3, d0
0420: 2440                 movea.l    d0, a2
0422: 7011                 moveq      #$11, d0
0424: c1c3                 muls.w     d3, d0
0426: 47edbcfe             lea.l      -$4302(a5), a3
042a: d08b                 add.l      a3, d0
042c: 2640                 movea.l    d0, a3
042e: 6022                 bra.b      $452
0430: 4a334000             tst.b      (a3, d4.w)
0434: 6612                 bne.b      $448
0436: 206dcf08             movea.l    -$30f8(a5), a0
043a: d1eefff8             adda.l     -$8(a6), a0
043e: d1ca                 adda.l     a2, a0
0440: d1eefff4             adda.l     -$c(a6), a0
0444: 8b90                 or.l       d5, (a0)
0446: 6016                 bra.b      $45e
0448: 5243                 addq.w     #$1, d3
044a: 45ea0044             lea.l      $44(a2), a2
044e: 47eb0011             lea.l      $11(a3), a3
0452: 0c43001f             cmpi.w     #$1f, d3
0456: 6706                 beq.b      $45e
0458: 0c430010             cmpi.w     #$10, d3
045c: 66d2                 bne.b      $430
045e: 362effee             move.w     -$12(a6), d3
0462: 7044                 moveq      #$44, d0
0464: c1c3                 muls.w     d3, d0
0466: 2440                 movea.l    d0, a2
0468: 7011                 moveq      #$11, d0
046a: c1c3                 muls.w     d3, d0
046c: 47edbcfe             lea.l      -$4302(a5), a3
0470: d08b                 add.l      a3, d0
0472: 2640                 movea.l    d0, a3
0474: 6022                 bra.b      $498
0476: 4a334000             tst.b      (a3, d4.w)
047a: 6612                 bne.b      $48e
047c: 206dcf08             movea.l    -$30f8(a5), a0
0480: d1eefff8             adda.l     -$8(a6), a0
0484: d1ca                 adda.l     a2, a0
0486: d1eefff4             adda.l     -$c(a6), a0
048a: 8b90                 or.l       d5, (a0)
048c: 6014                 bra.b      $4a2
048e: 5343                 subq.w     #$1, d3
0490: 45eaffbc             lea.l      -$44(a2), a2
0494: 47ebffef             lea.l      -$11(a3), a3
0498: 4a43                 tst.w      d3
049a: 6706                 beq.b      $4a2
049c: 0c43000f             cmpi.w     #$f, d3
04a0: 66d4                 bne.b      $476
04a2: 52aefff0             addq.l     #$1, -$10(a6)
04a6: 5887                 addq.l     #$4, d7
04a8: 5244                 addq.w     #$1, d4
04aa: 58aefff4             addq.l     #$4, -$c(a6)
04ae: 202efff0             move.l     -$10(a6), d0
04b2: b0aefffc             cmp.l      -$4(a6), d0
04b6: 6500ff46             bcs.w      $3fe
04ba: 0c440010             cmpi.w     #$10, d4
04be: 6704                 beq.b      $4c4
04c0: 2047                 movea.l    d7, a0
04c2: 8b90                 or.l       d5, (a0)
04c4: 2854                 movea.l    (a4), a4
04c6: 200c                 move.l     a4, d0
04c8: 6600fe68             bne.w      $332
04cc: 4eba000a             jsr        $4d8(pc)
04d0: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
04d4: 4e5e                 unlk       a6
04d6: 4e75                 rts        
04d8: 4e56ffee             link.w     a6, #$ffee
04dc: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
04e0: 4aadcf08             tst.l      -$30f8(a5)
04e4: 6604                 bne.b      $4ea
04e6: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
04ea: 7a00                 moveq      #$0, d5
04ec: 99cc                 suba.l     a4, a4
04ee: 600000d2             bra.w      $5c2
04f2: 7600                 moveq      #$0, d3
04f4: 2e2dcf08             move.l     -$30f8(a5), d7
04f8: de8c                 add.l      a4, d7
04fa: 7044                 moveq      #$44, d0
04fc: c1c3                 muls.w     d3, d0
04fe: 2440                 movea.l    d0, a2
0500: 6012                 bra.b      $514
0502: 2007                 move.l     d7, d0
0504: d08a                 add.l      a2, d0
0506: 2640                 movea.l    d0, a3
0508: 42ab0040             clr.l      $40(a3)
050c: 4293                 clr.l      (a3)
050e: 5243                 addq.w     #$1, d3
0510: 45ea0044             lea.l      $44(a2), a2
0514: 0c43001f             cmpi.w     #$1f, d3
0518: 6de8                 blt.b      $502
051a: 7600                 moveq      #$0, d3
051c: 244c                 movea.l    a4, a2
051e: d5edcf08             adda.l     -$30f8(a5), a2
0522: 47ec083c             lea.l      $83c(a4), a3
0526: d7edcf08             adda.l     -$30f8(a5), a3
052a: 2c03                 move.l     d3, d6
052c: 48c6                 ext.l      d6
052e: e58e                 lsl.l      #$2, d6
0530: 600c                 bra.b      $53e
0532: 42b36800             clr.l      (a3, d6.l)
0536: 42b26800             clr.l      (a2, d6.l)
053a: 5243                 addq.w     #$1, d3
053c: 5886                 addq.l     #$4, d6
053e: 0c430011             cmpi.w     #$11, d3
0542: 6dee                 blt.b      $532
0544: 7600                 moveq      #$0, d3
0546: 2003                 move.l     d3, d0
0548: 48c0                 ext.l      d0
054a: e588                 lsl.l      #$2, d0
054c: 2440                 movea.l    d0, a2
054e: 7044                 moveq      #$44, d0
0550: c1c3                 muls.w     d3, d0
0552: 2640                 movea.l    d0, a3
0554: 6060                 bra.b      $5b6
0556: 7800                 moveq      #$0, d4
0558: 204c                 movea.l    a4, a0
055a: d1edcf08             adda.l     -$30f8(a5), a0
055e: d1cb                 adda.l     a3, a0
0560: 2c08                 move.l     a0, d6
0562: 2d4afffc             move.l     a2, -$4(a6)
0566: 2004                 move.l     d4, d0
0568: 48c0                 ext.l      d0
056a: e588                 lsl.l      #$2, d0
056c: 2d40fff4             move.l     d0, -$c(a6)
0570: 6036                 bra.b      $5a8
0572: 700f                 moveq      #$f, d0
0574: d044                 add.w      d4, d0
0576: 3d40ffee             move.w     d0, -$12(a6)
057a: 2206                 move.l     d6, d1
057c: d2aefff4             add.l      -$c(a6), d1
0580: 2d41fff8             move.l     d1, -$8(a6)
0584: c1fc0044             muls.w     #$44, d0
0588: d087                 add.l      d7, d0
058a: d0aefffc             add.l      -$4(a6), d0
058e: 2d40fff0             move.l     d0, -$10(a6)
0592: 2041                 movea.l    d1, a0
0594: 2240                 movea.l    d0, a1
0596: 2410                 move.l     (a0), d2
0598: 8491                 or.l       (a1), d2
059a: 2040                 movea.l    d0, a0
059c: 2082                 move.l     d2, (a0)
059e: 2041                 movea.l    d1, a0
05a0: 2082                 move.l     d2, (a0)
05a2: 5244                 addq.w     #$1, d4
05a4: 58aefff4             addq.l     #$4, -$c(a6)
05a8: 0c440010             cmpi.w     #$10, d4
05ac: 6dc4                 blt.b      $572
05ae: 5243                 addq.w     #$1, d3
05b0: 588a                 addq.l     #$4, a2
05b2: 47eb0044             lea.l      $44(a3), a3
05b6: 0c430010             cmpi.w     #$10, d3
05ba: 6d9a                 blt.b      $556
05bc: 5245                 addq.w     #$1, d5
05be: 49ec0880             lea.l      $880(a4), a4
05c2: 0c450008             cmpi.w     #$8, d5
05c6: 6d00ff2a             blt.w      $4f2
05ca: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
05ce: 4e5e                 unlk       a6
05d0: 4e75                 rts        
