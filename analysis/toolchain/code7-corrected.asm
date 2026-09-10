0004: 4e560000             link.w     a6, #$0
0008: 3f2e0008             move.w     $8(a6), -(a7)
000c: 4eba0582             jsr        $590(pc)
0010: 41edc366             lea.l      -$3c9a(a5), a0
0014: 2b48c376             move.l     a0, -$3c8a(a5)
0018: 4a10                 tst.b      (a0)
001a: 548f                 addq.l     #$2, a7
001c: 6704                 beq.b      $22
001e: 7008                 moveq      #$8, d0
0020: 6002                 bra.b      $24
0022: 7000                 moveq      #$0, d0
0024: 3b40de64             move.w     d0, -$219c(a5)
0028: 4ead040a             jsr        $40a(a5) ; CODE20+03e0
002c: 4ead04ea             jsr        $4ea(a5) ; CODE21+1310
0030: 4ead0552             jsr        $552(a5) ; CODE21+0052
0034: 4ead0292             jsr        $292(a5) ; CODE14+0318
0038: 4e5e                 unlk       a6
003a: 4e75                 rts        
003c: 4e56fffe             link.w     a6, #$fffe
0040: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0044: 266e0008             movea.l    $8(a6), a3
0048: 362e000e             move.w     $e(a6), d3
004c: 302e000c             move.w     $c(a6), d0
0050: 6778                 beq.b      $ca
0052: 6b000292             bmi.w      $2e6
0056: 5740                 subq.w     #$3, d0
0058: 670001e6             beq.w      $240
005c: 6a08                 bpl.b      $66
005e: 5240                 addq.w     #$1, d0
0060: 6a000216             bpl.w      $278
0064: 600a                 bra.b      $70
0066: 5540                 subq.w     #$2, d0
0068: 6a00027c             bpl.w      $2e6
006c: 600001fc             bra.w      $26a
0070: 284b                 movea.l    a3, a4
0072: 48780220             pea.l      $220.w
0076: 486dbcfe             pea.l      -$4302(a5)
007a: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
007e: 48780440             pea.l      $440.w
0082: 486dbf1e             pea.l      -$40e2(a5)
0086: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
008a: 486c0006             pea.l      $6(a4)
008e: 486dc366             pea.l      -$3c9a(a5)
0092: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0096: 486c000e             pea.l      $e(a4)
009a: 486dc35e             pea.l      -$3ca2(a5)
009e: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
00a2: 4a6c0002             tst.w      $2(a4)
00a6: 4fef0020             lea.l      $20(a7), a7
00aa: 6708                 beq.b      $b4
00ac: 41edc366             lea.l      -$3c9a(a5), a0
00b0: 2008                 move.l     a0, d0
00b2: 6006                 bra.b      $ba
00b4: 41edc35e             lea.l      -$3ca2(a5), a0
00b8: 2008                 move.l     a0, d0
00ba: 2b40c376             move.l     d0, -$3c8a(a5)
00be: 42adc372             clr.l      -$3c8e(a5)
00c2: 42adc36e             clr.l      -$3c92(a5)
00c6: 6000021e             bra.w      $2e6
00ca: 284b                 movea.l    a3, a4
00cc: 48780110             pea.l      $110.w
00d0: 486dbcfe             pea.l      -$4302(a5)
00d4: 2f0c                 move.l     a4, -(a7)
00d6: 4ead067a             jsr        $67a(a5) ; CODE9+00c2
00da: 7011                 moveq      #$11, d0
00dc: 2e80                 move.l     d0, (a7)
00de: 486dbcfe             pea.l      -$4302(a5)
00e2: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
00e6: 7810                 moveq      #$10, d4
00e8: 47edbe0e             lea.l      -$41f2(a5), a3
00ec: 4fef0010             lea.l      $10(a7), a7
00f0: 6034                 bra.b      $126
00f2: 7601                 moveq      #$1, d3
00f4: 244b                 movea.l    a3, a2
00f6: 70f1                 moveq      #$f1, d0
00f8: d044                 add.w      d4, d0
00fa: 3d40fffe             move.w     d0, -$2(a6)
00fe: 7e11                 moveq      #$11, d7
0100: cfc3                 muls.w     d3, d7
0102: 41edbcfe             lea.l      -$4302(a5), a0
0106: de88                 add.l      a0, d7
0108: 6010                 bra.b      $11a
010a: 306efffe             movea.w    -$2(a6), a0
010e: 15b078003000         move.b     (a0, d7.l), (a2, d3.w)
0114: 5243                 addq.w     #$1, d3
0116: 7011                 moveq      #$11, d0
0118: de80                 add.l      d0, d7
011a: 0c430010             cmpi.w     #$10, d3
011e: 6dea                 blt.b      $10a
0120: 5244                 addq.w     #$1, d4
0122: 47eb0011             lea.l      $11(a3), a3
0126: 0c440020             cmpi.w     #$20, d4
012a: 65c6                 bcs.b      $f2
012c: 48780440             pea.l      $440.w
0130: 486dbf1e             pea.l      -$40e2(a5)
0134: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0138: 7800                 moveq      #$0, d4
013a: 47edbcfe             lea.l      -$4302(a5), a3
013e: 45edbf1e             lea.l      -$40e2(a5), a2
0142: 508f                 addq.l     #$8, a7
0144: 6040                 bra.b      $186
0146: 7600                 moveq      #$0, d3
0148: 2e0a                 move.l     a2, d7
014a: 2c03                 move.l     d3, d6
014c: 48c6                 ext.l      d6
014e: dc86                 add.l      d6, d6
0150: 6024                 bra.b      $176
0152: 2a03                 move.l     d3, d5
0154: 48c5                 ext.l      d5
0156: da8b                 add.l      a3, d5
0158: 2045                 movea.l    d5, a0
015a: 4a10                 tst.b      (a0)
015c: 6714                 beq.b      $172
015e: 2045                 movea.l    d5, a0
0160: 1010                 move.b     (a0), d0
0162: 4880                 ext.w      d0
0164: 204d                 movea.l    a5, a0
0166: d0c0                 adda.w     d0, a0
0168: d0c0                 adda.w     d0, a0
016a: 2247                 movea.l    d7, a1
016c: d3c6                 adda.l     d6, a1
016e: 32a89412             move.w     -$6bee(a0), (a1)
0172: 5243                 addq.w     #$1, d3
0174: 5486                 addq.l     #$2, d6
0176: 0c430011             cmpi.w     #$11, d3
017a: 65d6                 bcs.b      $152
017c: 5244                 addq.w     #$1, d4
017e: 47eb0011             lea.l      $11(a3), a3
0182: 45ea0022             lea.l      $22(a2), a2
0186: 0c440020             cmpi.w     #$20, d4
018a: 65ba                 bcs.b      $146
018c: 102c012a             move.b     $12a(a4), d0
0190: 4880                 ext.w      d0
0192: c1fc0022             muls.w     #$22, d0
0196: 122c012b             move.b     $12b(a4), d1
019a: 4881                 ext.w      d1
019c: 41edbf1e             lea.l      -$40e2(a5), a0
01a0: d088                 add.l      a0, d0
01a2: 3041                 movea.w    d1, a0
01a4: d1c8                 adda.l     a0, a0
01a6: 42700800             clr.w      (a0, d0.l)
01aa: 102c0128             move.b     $128(a4), d0
01ae: 4880                 ext.w      d0
01b0: c1fc0022             muls.w     #$22, d0
01b4: 122c0129             move.b     $129(a4), d1
01b8: 4881                 ext.w      d1
01ba: 41edbf1e             lea.l      -$40e2(a5), a0
01be: d088                 add.l      a0, d0
01c0: 3041                 movea.w    d1, a0
01c2: d1c8                 adda.l     a0, a0
01c4: 42700800             clr.w      (a0, d0.l)
01c8: 102c012b             move.b     $12b(a4), d0
01cc: 4880                 ext.w      d0
01ce: 06400010             addi.w     #$10, d0
01d2: c1fc0022             muls.w     #$22, d0
01d6: 122c012a             move.b     $12a(a4), d1
01da: 4881                 ext.w      d1
01dc: 41edbf1e             lea.l      -$40e2(a5), a0
01e0: d088                 add.l      a0, d0
01e2: 3041                 movea.w    d1, a0
01e4: d1c8                 adda.l     a0, a0
01e6: 42700800             clr.w      (a0, d0.l)
01ea: 102c0129             move.b     $129(a4), d0
01ee: 4880                 ext.w      d0
01f0: 06400010             addi.w     #$10, d0
01f4: c1fc0022             muls.w     #$22, d0
01f8: 122c0128             move.b     $128(a4), d1
01fc: 4881                 ext.w      d1
01fe: 41edbf1e             lea.l      -$40e2(a5), a0
0202: d088                 add.l      a0, d0
0204: 3041                 movea.w    d1, a0
0206: d1c8                 adda.l     a0, a0
0208: 42700800             clr.w      (a0, d0.l)
020c: 486c0110             pea.l      $110(a4)
0210: 486dc366             pea.l      -$3c9a(a5)
0214: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0218: 486c0118             pea.l      $118(a4)
021c: 486dc35e             pea.l      -$3ca2(a5)
0220: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0224: 41edc366             lea.l      -$3c9a(a5), a0
0228: 2b48c376             move.l     a0, -$3c8a(a5)
022c: 2b6c0124c36e         move.l     $124(a4), -$3c92(a5)
0232: 2b6c0120c372         move.l     $120(a4), -$3c8e(a5)
0238: 4fef0010             lea.l      $10(a7), a7
023c: 600000a8             bra.w      $2e6
0240: 284b                 movea.l    a3, a4
0242: 70ff                 moveq      #$ff, d0
0244: d043                 add.w      d3, d0
0246: 3f00                 move.w     d0, -(a7)
0248: 4eba0346             jsr        $590(pc)
024c: 4a54                 tst.w      (a4)
024e: 548f                 addq.l     #$2, a7
0250: 6708                 beq.b      $25a
0252: 2b6c000ec372         move.l     $e(a4), -$3c8e(a5)
0258: 6006                 bra.b      $260
025a: 2b6c000ec36e         move.l     $e(a4), -$3c92(a5)
0260: 422dc366             clr.b      -$3c9a(a5)
0264: 422dc35e             clr.b      -$3ca2(a5)
0268: 607c                 bra.b      $2e6
026a: 70ff                 moveq      #$ff, d0
026c: d043                 add.w      d3, d0
026e: 3f00                 move.w     d0, -(a7)
0270: 4eba031e             jsr        $590(pc)
0274: 548f                 addq.l     #$2, a7
0276: 606e                 bra.b      $2e6
0278: 284b                 movea.l    a3, a4
027a: 70ff                 moveq      #$ff, d0
027c: d043                 add.w      d3, d0
027e: 3f00                 move.w     d0, -(a7)
0280: 4eba030e             jsr        $590(pc)
0284: 4a6c0022             tst.w      $22(a4)
0288: 548f                 addq.l     #$2, a7
028a: 671c                 beq.b      $2a8
028c: 47edc366             lea.l      -$3c9a(a5), a3
0290: 486c002c             pea.l      $2c(a4)
0294: 486dc35e             pea.l      -$3ca2(a5)
0298: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
029c: 202c0010             move.l     $10(a4), d0
02a0: d1adc372             add.l      d0, -$3c8e(a5)
02a4: 508f                 addq.l     #$8, a7
02a6: 601a                 bra.b      $2c2
02a8: 47edc35e             lea.l      -$3ca2(a5), a3
02ac: 486c002c             pea.l      $2c(a4)
02b0: 486dc366             pea.l      -$3c9a(a5)
02b4: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
02b8: 202c0010             move.l     $10(a4), d0
02bc: d1adc36e             add.l      d0, -$3c92(a5)
02c0: 508f                 addq.l     #$8, a7
02c2: 486c0024             pea.l      $24(a4)
02c6: 2f0b                 move.l     a3, -(a7)
02c8: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
02cc: 2e8b                 move.l     a3, (a7)
02ce: 4ead096a             jsr        $96a(a5) ; CODE31+0992
02d2: 4257                 clr.w      (a7)
02d4: 2f0b                 move.l     a3, -(a7)
02d6: 2f0c                 move.l     a4, -(a7)
02d8: 4ead0942             jsr        $942(a5) ; CODE31+0184
02dc: 2e8b                 move.l     a3, (a7)
02de: 4ead0582             jsr        $582(a5) ; CODE22+048a
02e2: 4fef0010             lea.l      $10(a7), a7
02e6: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
02ea: 4e5e                 unlk       a6
02ec: 4e75                 rts        
02ee: 4e560000             link.w     a6, #$0
02f2: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
02f6: 286e0008             movea.l    $8(a6), a4
02fa: 48780110             pea.l      $110.w
02fe: 2f0c                 move.l     a4, -(a7)
0300: 486dbcfe             pea.l      -$4302(a5)
0304: 4ead067a             jsr        $67a(a5) ; CODE9+00c2
0308: 486dc366             pea.l      -$3c9a(a5)
030c: 486c0110             pea.l      $110(a4)
0310: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0314: 486dc35e             pea.l      -$3ca2(a5)
0318: 486c0118             pea.l      $118(a4)
031c: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0320: 296dc3720120         move.l     -$3c8e(a5), $120(a4)
0326: 296dc36e0124         move.l     -$3c92(a5), $124(a4)
032c: 422c0129             clr.b      $129(a4)
0330: 422c0129             clr.b      $129(a4)
0334: 422c012b             clr.b      $12b(a4)
0338: 422c0128             clr.b      $128(a4)
033c: 422c012a             clr.b      $12a(a4)
0340: 7800                 moveq      #$0, d4
0342: 47edbf1e             lea.l      -$40e2(a5), a3
0346: 45edbcfe             lea.l      -$4302(a5), a2
034a: 4fef001c             lea.l      $1c(a7), a7
034e: 6046                 bra.b      $396
0350: 7600                 moveq      #$0, d3
0352: 2e0a                 move.l     a2, d7
0354: 2c0b                 move.l     a3, d6
0356: 2a03                 move.l     d3, d5
0358: 48c5                 ext.l      d5
035a: da85                 add.l      d5, d5
035c: 6028                 bra.b      $386
035e: 3043                 movea.w    d3, a0
0360: 4a307800             tst.b      (a0, d7.l)
0364: 671c                 beq.b      $382
0366: 2046                 movea.l    d6, a0
0368: d1c5                 adda.l     d5, a0
036a: 4a50                 tst.w      (a0)
036c: 6614                 bne.b      $382
036e: 196c0128012a         move.b     $128(a4), $12a(a4)
0374: 19440128             move.b     d4, $128(a4)
0378: 196c0129012b         move.b     $129(a4), $12b(a4)
037e: 19430129             move.b     d3, $129(a4)
0382: 5243                 addq.w     #$1, d3
0384: 5485                 addq.l     #$2, d5
0386: 0c430011             cmpi.w     #$11, d3
038a: 65d2                 bcs.b      $35e
038c: 5244                 addq.w     #$1, d4
038e: 47eb0022             lea.l      $22(a3), a3
0392: 45ea0011             lea.l      $11(a2), a2
0396: 0c440010             cmpi.w     #$10, d4
039a: 65b4                 bcs.b      $350
039c: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
03a0: 4e5e                 unlk       a6
03a2: 4e75                 rts        
03a4: 4e56ff7e             link.w     a6, #$ff7e
03a8: 48e71f18             movem.l    d3-d7/a3-a4, -(a7)
03ac: 486dc366             pea.l      -$3c9a(a5)
03b0: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
03b4: 3e00                 move.w     d0, d7
03b6: 486dc35e             pea.l      -$3ca2(a5)
03ba: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
03be: 3c00                 move.w     d0, d6
03c0: 4a2dc35e             tst.b      -$3ca2(a5)
03c4: 508f                 addq.l     #$8, a7
03c6: 6604                 bne.b      $3cc
03c8: de47                 add.w      d7, d7
03ca: 6014                 bra.b      $3e0
03cc: 4a2dc366             tst.b      -$3c9a(a5)
03d0: 6604                 bne.b      $3d6
03d2: dc46                 add.w      d6, d6
03d4: 600a                 bra.b      $3e0
03d6: 3a07                 move.w     d7, d5
03d8: 3e06                 move.w     d6, d7
03da: 4447                 neg.w      d7
03dc: 3c05                 move.w     d5, d6
03de: 4446                 neg.w      d6
03e0: 2006                 move.l     d6, d0
03e2: 48c0                 ext.l      d0
03e4: d1ada4a8             add.l      d0, -$5b58(a5)
03e8: 2007                 move.l     d7, d0
03ea: 48c0                 ext.l      d0
03ec: d1ada500             add.l      d0, -$5b00(a5)
03f0: 2007                 move.l     d7, d0
03f2: 48c0                 ext.l      d0
03f4: d1adc36e             add.l      d0, -$3c92(a5)
03f8: 2006                 move.l     d6, d0
03fa: 48c0                 ext.l      d0
03fc: d1adc372             add.l      d0, -$3c8e(a5)
0400: 41edc35e             lea.l      -$3ca2(a5), a0
0404: b1edc376             cmpa.l     -$3c8a(a5), a0
0408: 6614                 bne.b      $41e
040a: 49edc366             lea.l      -$3c9a(a5), a4
040e: 2a2dc36e             move.l     -$3c92(a5), d5
0412: 282dc372             move.l     -$3c8e(a5), d4
0416: 3607                 move.w     d7, d3
0418: 3d46ff7e             move.w     d6, -$82(a6)
041c: 6012                 bra.b      $430
041e: 49edc35e             lea.l      -$3ca2(a5), a4
0422: 2a2dc372             move.l     -$3c8e(a5), d5
0426: 282dc36e             move.l     -$3c92(a5), d4
042a: 3606                 move.w     d6, d3
042c: 3d47ff7e             move.w     d7, -$82(a6)
0430: 4a2dc35e             tst.b      -$3ca2(a5)
0434: 6710                 beq.b      $446
0436: 4a2dc366             tst.b      -$3c9a(a5)
043a: 670a                 beq.b      $446
043c: 264c                 movea.l    a4, a3
043e: 286dc376             movea.l    -$3c8a(a5), a4
0442: 2b4bc376             move.l     a3, -$3c8a(a5)
0446: 2f04                 move.l     d4, -(a7)
0448: 3f03                 move.w     d3, -(a7)
044a: 2f0c                 move.l     a4, -(a7)
044c: 4eba0372             jsr        $7c0(pc)
0450: 2e85                 move.l     d5, (a7)
0452: 3f2eff7e             move.w     -$82(a6), -(a7)
0456: 2f2dc376             move.l     -$3c8a(a5), -(a7)
045a: 4eba0364             jsr        $7c0(pc)
045e: 422dc366             clr.b      -$3c9a(a5)
0462: 4ead0552             jsr        $552(a5) ; CODE21+0052
0466: 4cee18f8ff62         movem.l    -$9e(a6), d3-d7/a3-a4
046c: 4e5e                 unlk       a6
046e: 4e75                 rts        
0470: 4e560000             link.w     a6, #$0
0474: 302e0008             move.w     $8(a6), d0
0478: 6b14                 bmi.b      $48e
047a: 5b40                 subq.w     #$5, d0
047c: 6a10                 bpl.b      $48e
047e: 5640                 addq.w     #$3, d0
0480: 6a06                 bpl.b      $488
0482: 302e000a             move.w     $a(a6), d0
0486: 6006                 bra.b      $48e
0488: 70ff                 moveq      #$ff, d0
048a: d06e000a             add.w      $a(a6), d0
048e: 4e5e                 unlk       a6
0490: 4e75                 rts        
0492: 4e560000             link.w     a6, #$0
0496: 48e70108             movem.l    d7/a4, -(a7)
049a: 302e000c             move.w     $c(a6), d0
049e: 6b66                 bmi.b      $506
04a0: 5740                 subq.w     #$3, d0
04a2: 6708                 beq.b      $4ac
04a4: 6a60                 bpl.b      $506
04a6: 5240                 addq.w     #$1, d0
04a8: 6a18                 bpl.b      $4c2
04aa: 605a                 bra.b      $506
04ac: 422dc35e             clr.b      -$3ca2(a5)
04b0: 422dc366             clr.b      -$3c9a(a5)
04b4: 42adc376             clr.l      -$3c8a(a5)
04b8: 4ead04ea             jsr        $4ea(a5) ; CODE21+1310
04bc: 4ead0552             jsr        $552(a5) ; CODE21+0052
04c0: 6044                 bra.b      $506
04c2: 286e0008             movea.l    $8(a6), a4
04c6: 486c0024             pea.l      $24(a4)
04ca: 486dc366             pea.l      -$3c9a(a5)
04ce: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
04d2: 486c002c             pea.l      $2c(a4)
04d6: 486dc35e             pea.l      -$3ca2(a5)
04da: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
04de: 4a6c0022             tst.w      $22(a4)
04e2: 4fef0010             lea.l      $10(a7), a7
04e6: 660e                 bne.b      $4f6
04e8: 2e2dc36e             move.l     -$3c92(a5), d7
04ec: 2b6dc372c36e         move.l     -$3c8e(a5), -$3c92(a5)
04f2: 2b47c372             move.l     d7, -$3c8e(a5)
04f6: 41edc366             lea.l      -$3c9a(a5), a0
04fa: 2b48c376             move.l     a0, -$3c8a(a5)
04fe: 4ead04ea             jsr        $4ea(a5) ; CODE21+1310
0502: 4ead0552             jsr        $552(a5) ; CODE21+0052
0506: 4cdf1080             movem.l    (a7)+, d7/a4
050a: 4e5e                 unlk       a6
050c: 4e75                 rts        
050e: 4e560000             link.w     a6, #$0
0512: 48e70118             movem.l    d7/a3-a4, -(a7)
0516: 7006                 moveq      #$6, d0
0518: c1ee0008             muls.w     $8(a6), d0
051c: 2840                 movea.l    d0, a4
051e: 206ddec2             movea.l    -$213e(a5), a0
0522: 206800ca             movea.l    $ca(a0), a0
0526: 2010                 move.l     (a0), d0
0528: 2f340802             move.l     $2(a4, d0.l), -(a7)
052c: 4ead05ea             jsr        $5ea(a5) ; CODE9+022e
0530: 2640                 movea.l    d0, a3
0532: 206ddec2             movea.l    -$213e(a5), a0
0536: 206800ca             movea.l    $ca(a0), a0
053a: 224c                 movea.l    a4, a1
053c: d3d0                 adda.l     (a0), a1
053e: 1e11                 move.b     (a1), d7
0540: 4887                 ext.w      d7
0542: 3eae0008             move.w     $8(a6), (a7)
0546: 3f07                 move.w     d7, -(a7)
0548: 2f0b                 move.l     a3, -(a7)
054a: 4ebaff46             jsr        $492(pc)
054e: 206ddec2             movea.l    -$213e(a5), a0
0552: 206800ca             movea.l    $ca(a0), a0
0556: 2010                 move.l     (a0), d0
0558: 20740802             movea.l    $2(a4, d0.l), a0
055c: a02a                 dc.w       $a02a
055e: 4cee1880fff4         movem.l    -$c(a6), d7/a3-a4
0564: 4e5e                 unlk       a6
0566: 4e75                 rts        
0568: 4e560000             link.w     a6, #$0
056c: 3f2e0008             move.w     $8(a6), -(a7)
0570: 206ddec2             movea.l    -$213e(a5), a0
0574: 206800ca             movea.l    $ca(a0), a0
0578: 7006                 moveq      #$6, d0
057a: c1ee0008             muls.w     $8(a6), d0
057e: d090                 add.l      (a0), d0
0580: 2040                 movea.l    d0, a0
0582: 1010                 move.b     (a0), d0
0584: 4880                 ext.w      d0
0586: 3f00                 move.w     d0, -(a7)
0588: 4ebafee6             jsr        $470(pc)
058c: 4e5e                 unlk       a6
058e: 4e75                 rts        
0590: 4e560000             link.w     a6, #$0
0594: 48e70118             movem.l    d7/a3-a4, -(a7)
0598: 7006                 moveq      #$6, d0
059a: c1ee0008             muls.w     $8(a6), d0
059e: 2840                 movea.l    d0, a4
05a0: 206ddec2             movea.l    -$213e(a5), a0
05a4: 206800ca             movea.l    $ca(a0), a0
05a8: 2010                 move.l     (a0), d0
05aa: 2f340802             move.l     $2(a4, d0.l), -(a7)
05ae: 4ead05ea             jsr        $5ea(a5) ; CODE9+022e
05b2: 2640                 movea.l    d0, a3
05b4: 206ddec2             movea.l    -$213e(a5), a0
05b8: 206800ca             movea.l    $ca(a0), a0
05bc: 224c                 movea.l    a4, a1
05be: d3d0                 adda.l     (a0), a1
05c0: 1e11                 move.b     (a1), d7
05c2: 4887                 ext.w      d7
05c4: 3eae0008             move.w     $8(a6), (a7)
05c8: 3f07                 move.w     d7, -(a7)
05ca: 2f0b                 move.l     a3, -(a7)
05cc: 4ebafa6e             jsr        $3c(pc)
05d0: 206ddec2             movea.l    -$213e(a5), a0
05d4: 206800ca             movea.l    $ca(a0), a0
05d8: 2010                 move.l     (a0), d0
05da: 20740802             movea.l    $2(a4, d0.l), a0
05de: a02a                 dc.w       $a02a
05e0: 4cee1880fff4         movem.l    -$c(a6), d7/a3-a4
05e6: 4e5e                 unlk       a6
05e8: 4e75                 rts        
05ea: 4e56fffc             link.w     a6, #$fffc
05ee: 48e70138             movem.l    d7/a2-a4, -(a7)
05f2: 42a7                 clr.l      -(a7)
05f4: 206ddec2             movea.l    -$213e(a5), a0
05f8: 2f2800ca             move.l     $ca(a0), -(a7)
05fc: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
0600: 2d5ffffc             move.l     (a7)+, -$4(a6)
0604: 48780006             pea.l      $6.w
0608: 2f2efffc             move.l     -$4(a6), -(a7)
060c: 4ead004a             jsr        $4a(a5) ; CODE1+0124
0610: 3e00                 move.w     d0, d7
0612: 206ddec2             movea.l    -$213e(a5), a0
0616: 206800ca             movea.l    $ca(a0), a0
061a: 2850                 movea.l    (a0), a4
061c: 6028                 bra.b      $646
061e: 7006                 moveq      #$6, d0
0620: c1c7                 muls.w     d7, d0
0622: 2640                 movea.l    d0, a3
0624: 204c                 movea.l    a4, a0
0626: d1cb                 adda.l     a3, a0
0628: 1010                 move.b     (a0), d0
062a: 6716                 beq.b      $642
062c: 6b18                 bmi.b      $646
062e: 5500                 subq.b     #$2, d0
0630: 6a14                 bpl.b      $646
0632: 204c                 movea.l    a4, a0
0634: d1cb                 adda.l     a3, a0
0636: 24680002             movea.l    $2(a0), a2
063a: 2052                 movea.l    (a2), a0
063c: 30280004             move.w     $4(a0), d0
0640: 600c                 bra.b      $64e
0642: 7000                 moveq      #$0, d0
0644: 6008                 bra.b      $64e
0646: 5347                 subq.w     #$1, d7
0648: 4a47                 tst.w      d7
064a: 6cd2                 bge.b      $61e
064c: 7000                 moveq      #$0, d0
064e: 4cdf1c80             movem.l    (a7)+, d7/a2-a4
0652: 4e5e                 unlk       a6
0654: 4e75                 rts        
0656: 4e56ff66             link.w     a6, #$ff66
065a: 2f07                 move.l     d7, -(a7)
065c: 42a7                 clr.l      -(a7)
065e: 206ddec2             movea.l    -$213e(a5), a0
0662: 2f2800ca             move.l     $ca(a0), -(a7)
0666: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
066a: 2d5fff66             move.l     (a7)+, -$9a(a6)
066e: 48780006             pea.l      $6.w
0672: 2f2eff66             move.l     -$9a(a6), -(a7)
0676: 4ead004a             jsr        $4a(a5) ; CODE1+0124
067a: 3e00                 move.w     d0, d7
067c: 6014                 bra.b      $692
067e: 206ddec2             movea.l    -$213e(a5), a0
0682: 206800ca             movea.l    $ca(a0), a0
0686: 7006                 moveq      #$6, d0
0688: c1c7                 muls.w     d7, d0
068a: 2050                 movea.l    (a0), a0
068c: 20700802             movea.l    $2(a0, d0.l), a0
0690: a023                 dc.w       $a023
0692: 5347                 subq.w     #$1, d7
0694: 4a47                 tst.w      d7
0696: 6ce6                 bge.b      $67e
0698: 206ddec2             movea.l    -$213e(a5), a0
069c: 7000                 moveq      #$0, d0
069e: 206800ca             movea.l    $ca(a0), a0
06a2: a024                 dc.w       $a024
06a4: 4a780220             tst.w      $220.w
06a8: 6704                 beq.b      $6ae
06aa: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
06ae: 2f2ddec2             move.l     -$213e(a5), -(a7)
06b2: a873                 dc.w       $a873
06b4: 206dde80             movea.l    -$2180(a5), a0
06b8: 4868003e             pea.l      $3e(a0)
06bc: a928                 dc.w       $a928
06be: 2f2ddec6             move.l     -$213a(a5), -(a7)
06c2: 4267                 clr.w      -(a7)
06c4: a965                 dc.w       $a965
06c6: 2f2ddec6             move.l     -$213a(a5), -(a7)
06ca: 4267                 clr.w      -(a7)
06cc: a963                 dc.w       $a963
06ce: 426effea             clr.w      -$16(a6)
06d2: 41edc366             lea.l      -$3c9a(a5), a0
06d6: b1edc376             cmpa.l     -$3c8a(a5), a0
06da: 57c0                 seq.b      d0
06dc: 4400                 neg.b      d0
06de: 4880                 ext.w      d0
06e0: 3d40ffec             move.w     d0, -$14(a6)
06e4: 3d7c0001ffee         move.w     #$1, -$12(a6)
06ea: 486dc366             pea.l      -$3c9a(a5)
06ee: 486efff0             pea.l      -$10(a6)
06f2: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
06f6: 486dc35e             pea.l      -$3ca2(a5)
06fa: 486efff8             pea.l      -$8(a6)
06fe: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0702: 1ebc0001             move.b     #$1, (a7)
0706: 48780016             pea.l      $16.w
070a: 486effea             pea.l      -$16(a6)
070e: 3f3c7fff             move.w     #$7fff, -(a7)
0712: 2f2ddec2             move.l     -$213e(a5), -(a7)
0716: 4eba00f4             jsr        $80c(pc)
071a: 426dde54             clr.w      -$21ac(a5)
071e: 206dde78             movea.l    -$2188(a5), a0
0722: a029                 dc.w       $a029
0724: 41edc366             lea.l      -$3c9a(a5), a0
0728: b1edc376             cmpa.l     -$3c8a(a5), a0
072c: 4fef001e             lea.l      $1e(a7), a7
0730: 6624                 bne.b      $756
0732: 486dd700             pea.l      -$2900(a5)
0736: 206dde78             movea.l    -$2188(a5), a0
073a: 2050                 movea.l    (a0), a0
073c: 4868032e             pea.l      $32e(a0)
0740: 486d90c4             pea.l      -$6f3c(a5)
0744: 486eff6b             pea.l      -$95(a6)
0748: 4ead0812             jsr        $812(a5) ; CODE24+16a6
074c: 1d40ff6a             move.b     d0, -$96(a6)
0750: 4fef0010             lea.l      $10(a7), a7
0754: 6022                 bra.b      $778
0756: 206dde78             movea.l    -$2188(a5), a0
075a: 2050                 movea.l    (a0), a0
075c: 4868032e             pea.l      $32e(a0)
0760: 486dd700             pea.l      -$2900(a5)
0764: 486d90cc             pea.l      -$6f34(a5)
0768: 486eff6b             pea.l      -$95(a6)
076c: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0770: 1d40ff6a             move.b     d0, -$96(a6)
0774: 4fef0010             lea.l      $10(a7), a7
0778: 206dde78             movea.l    -$2188(a5), a0
077c: a02a                 dc.w       $a02a
077e: 4878004a             pea.l      $4a.w
0782: 486dd720             pea.l      -$28e0(a5)
0786: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
078a: 486eff6a             pea.l      -$96(a6)
078e: 4ead04da             jsr        $4da(a5) ; CODE21+1908
0792: 2e2eff62             move.l     -$9e(a6), d7
0796: 4e5e                 unlk       a6
0798: 4e75                 rts        
079a: 4e56fed4             link.w     a6, #$fed4
079e: 486efed4             pea.l      -$12c(a6)
07a2: 4ebafb4a             jsr        $2ee(pc)
07a6: 4217                 clr.b      (a7)
07a8: 4878012c             pea.l      $12c.w
07ac: 486efed4             pea.l      -$12c(a6)
07b0: 3f3c7fff             move.w     #$7fff, -(a7)
07b4: 2f2ddec2             move.l     -$213e(a5), -(a7)
07b8: 4eba0052             jsr        $80c(pc)
07bc: 4e5e                 unlk       a6
07be: 4e75                 rts        
07c0: 4e56ff6e             link.w     a6, #$ff6e
07c4: 306e000c             movea.w    $c(a6), a0
07c8: 2d48ff78             move.l     a0, -$88(a6)
07cc: 2d6e000eff7c         move.l     $e(a6), -$84(a6)
07d2: 41edc366             lea.l      -$3c9a(a5), a0
07d6: b1ee0008             cmpa.l     $8(a6), a0
07da: 57c0                 seq.b      d0
07dc: 4400                 neg.b      d0
07de: 4880                 ext.w      d0
07e0: 3d40ff6e             move.w     d0, -$92(a6)
07e4: 2f2e0008             move.l     $8(a6), -(a7)
07e8: 486eff70             pea.l      -$90(a6)
07ec: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
07f0: 1ebc0003             move.b     #$3, (a7)
07f4: 48780012             pea.l      $12.w
07f8: 486eff6e             pea.l      -$92(a6)
07fc: 3f3c7fff             move.w     #$7fff, -(a7)
0800: 2f2ddec2             move.l     -$213e(a5), -(a7)
0804: 4eba0006             jsr        $80c(pc)
0808: 4e5e                 unlk       a6
080a: 4e75                 rts        
080c: 4e56fffc             link.w     a6, #$fffc
0810: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
0814: 266e0008             movea.l    $8(a6), a3
0818: 3c2e000c             move.w     $c(a6), d6
081c: 282e0012             move.l     $12(a6), d4
0820: 286b00ca             movea.l    $ca(a3), a4
0824: 4aab00ce             tst.l      $ce(a3)
0828: 6712                 beq.b      $83c
082a: 1f2e0016             move.b     $16(a6), -(a7)
082e: 3f06                 move.w     d6, -(a7)
0830: 2f0b                 move.l     a3, -(a7)
0832: 206b00ce             movea.l    $ce(a3), a0
0836: 4e90                 jsr        (a0)
0838: 3c00                 move.w     d0, d6
083a: 508f                 addq.l     #$8, a7
083c: 42a7                 clr.l      -(a7)
083e: 2f0c                 move.l     a4, -(a7)
0840: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
0844: 2d5ffffc             move.l     (a7)+, -$4(a6)
0848: 48780006             pea.l      $6.w
084c: 2f2efffc             move.l     -$4(a6), -(a7)
0850: 4ead004a             jsr        $4a(a5) ; CODE1+0124
0854: 2a00                 move.l     d0, d5
0856: 3046                 movea.w    d6, a0
0858: ba88                 cmp.l      a0, d5
085a: 6e1e                 bgt.b      $87a
085c: 3c05                 move.w     d5, d6
085e: 48780006             pea.l      $6.w
0862: 2f0c                 move.l     a4, -(a7)
0864: 4ead05ca             jsr        $5ca(a5) ; CODE9+01ea
0868: 2004                 move.l     d4, d0
086a: a122                 dc.w       $a122
086c: 2448                 movea.l    a0, a2
086e: 7006                 moveq      #$6, d0
0870: c1c6                 muls.w     d6, d0
0872: 2054                 movea.l    (a4), a0
0874: 218a0802             move.l     a2, $2(a0, d0.l)
0878: 508f                 addq.l     #$8, a7
087a: 7e06                 moveq      #$6, d7
087c: cfc6                 muls.w     d6, d7
087e: 2054                 movea.l    (a4), a0
0880: 11ae00167800         move.b     $16(a6), (a0, d7.l)
0886: 2054                 movea.l    (a4), a0
0888: 24707802             movea.l    $2(a0, d7.l), a2
088c: 2004                 move.l     d4, d0
088e: 204a                 movea.l    a2, a0
0890: a024                 dc.w       $a024
0892: 4a780220             tst.w      $220.w
0896: 6704                 beq.b      $89c
0898: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
089c: 204a                 movea.l    a2, a0
089e: a029                 dc.w       $a029
08a0: 2004                 move.l     d4, d0
08a2: 2252                 movea.l    (a2), a1
08a4: 206e000e             movea.l    $e(a6), a0
08a8: a02e                 dc.w       $a02e
08aa: 204a                 movea.l    a2, a0
08ac: a02a                 dc.w       $a02a
08ae: 377c000100d2         move.w     #$1, $d2(a3)
08b4: 4cdf1cf0             movem.l    (a7)+, d4-d7/a2-a4
08b8: 4e5e                 unlk       a6
08ba: 4e75                 rts        
08bc: 4e56ffcc             link.w     a6, #$ffcc
08c0: 206e000e             movea.l    $e(a6), a0
08c4: 43eeffcc             lea.l      -$34(a6), a1
08c8: 7007                 moveq      #$7, d0
08ca: 22d8                 move.l     (a0)+, (a1)+
08cc: 51c8fffc             dbra       d0, $8ca
08d0: 32d8                 move.w     (a0)+, (a1)+
08d2: 41edc366             lea.l      -$3c9a(a5), a0
08d6: b1edc376             cmpa.l     -$3c8a(a5), a0
08da: 57c0                 seq.b      d0
08dc: 4400                 neg.b      d0
08de: 4880                 ext.w      d0
08e0: 3d40ffee             move.w     d0, -$12(a6)
08e4: 2f2dc376             move.l     -$3c8a(a5), -(a7)
08e8: 486efff0             pea.l      -$10(a6)
08ec: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
08f0: 41edc35e             lea.l      -$3ca2(a5), a0
08f4: b1edc376             cmpa.l     -$3c8a(a5), a0
08f8: 508f                 addq.l     #$8, a7
08fa: 6608                 bne.b      $904
08fc: 41edc366             lea.l      -$3c9a(a5), a0
0900: 2008                 move.l     a0, d0
0902: 6006                 bra.b      $90a
0904: 41edc35e             lea.l      -$3ca2(a5), a0
0908: 2008                 move.l     a0, d0
090a: 2f00                 move.l     d0, -(a7)
090c: 486efff8             pea.l      -$8(a6)
0910: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0914: 1ebc0002             move.b     #$2, (a7)
0918: 48780034             pea.l      $34.w
091c: 486effcc             pea.l      -$34(a6)
0920: 3f2e000c             move.w     $c(a6), -(a7)
0924: 2f2e0008             move.l     $8(a6), -(a7)
0928: 4ebafee2             jsr        $80c(pc)
092c: 4e5e                 unlk       a6
092e: 4e75                 rts        
0930: 4e56ff80             link.w     a6, #$ff80
0934: 4a6dde54             tst.w      -$21ac(a5)
0938: 6708                 beq.b      $942
093a: 4ebafe5e             jsr        $79a(pc)
093e: 426dde54             clr.w      -$21ac(a5)
0942: 2f2e000c             move.l     $c(a6), -(a7)
0946: 3f3c7fff             move.w     #$7fff, -(a7)
094a: 2f2ddec2             move.l     -$213e(a5), -(a7)
094e: 4ebaff6c             jsr        $8bc(pc)
0952: 3ebc0006             move.w     #$6, (a7)
0956: 4ead01e2             jsr        $1e2(a5) ; CODE11+0ad6
095a: 4e5e                 unlk       a6
095c: 4e75                 rts        
095e: 4e56fffe             link.w     a6, #$fffe
0962: 0c6d0005de66         cmpi.w     #$5, -$219a(a5)
0968: 6612                 bne.b      $97c
096a: 4ebafc7e             jsr        $5ea(pc)
096e: 4a40                 tst.w      d0
0970: 670a                 beq.b      $97c
0972: 486d90d4             pea.l      -$6f2c(a5)
0976: 4ead0c72             jsr        $c72(a5) ; CODE41+0250
097a: 588f                 addq.l     #$4, a7
097c: 206ddec2             movea.l    -$213e(a5), a0
0980: 4a6800d2             tst.w      $d2(a0)
0984: 6728                 beq.b      $9ae
0986: 3f3c0402             move.w     #$402, -(a7)
098a: 4ead0c6a             jsr        $c6a(a5) ; CODE41+010a
098e: 3d40000c             move.w     d0, $c(a6)
0992: 5340                 subq.w     #$1, d0
0994: 548f                 addq.l     #$2, a7
0996: 660e                 bne.b      $9a6
0998: 3f3c0001             move.w     #$1, -(a7)
099c: 4eba0130             jsr        $ace(pc)
09a0: 4a40                 tst.w      d0
09a2: 548f                 addq.l     #$2, a7
09a4: 6608                 bne.b      $9ae
09a6: 0c6e0002000c         cmpi.w     #$2, $c(a6)
09ac: 6604                 bne.b      $9b2
09ae: 4eba0006             jsr        $9b6(pc)
09b2: 4e5e                 unlk       a6
09b4: 4e75                 rts        
09b6: 4e56ffa6             link.w     a6, #$ffa6
09ba: 4878004a             pea.l      $4a.w
09be: 486effa6             pea.l      -$5a(a6)
09c2: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
09c6: 2d7c58474d45fff0     move.l     #$58474d45, -$10(a6)
09ce: 3ebc0001             move.w     #$1, (a7)
09d2: 486efff0             pea.l      -$10(a6)
09d6: 486effa6             pea.l      -$5a(a6)
09da: 4ead0612             jsr        $612(a5) ; CODE9+0b82
09de: 4a2effa6             tst.b      -$5a(a6)
09e2: 4fef0010             lea.l      $10(a7), a7
09e6: 672e                 beq.b      $a16
09e8: 486effb0             pea.l      -$50(a6)
09ec: 3f2effac             move.w     -$54(a6), -(a7)
09f0: 4ead05aa             jsr        $5aa(a5) ; CODE22+02cc
09f4: 4a40                 tst.w      d0
09f6: 5c8f                 addq.l     #$6, a7
09f8: 671c                 beq.b      $a16
09fa: 41edd720             lea.l      -$28e0(a5), a0
09fe: 43eeffa6             lea.l      -$5a(a6), a1
0a02: 7011                 moveq      #$11, d0
0a04: 20d9                 move.l     (a1)+, (a0)+
0a06: 51c8fffc             dbra       d0, $a04
0a0a: 30d9                 move.w     (a1)+, (a0)+
0a0c: 4ead057a             jsr        $57a(a5) ; CODE21+07f0
0a10: 3b7c0008de64         move.w     #$8, -$219c(a5)
0a16: 4e5e                 unlk       a6
0a18: 4e75                 rts        
0a1a: 4e56fffe             link.w     a6, #$fffe
0a1e: 0c6d0005de66         cmpi.w     #$5, -$219a(a5)
0a24: 6612                 bne.b      $a38
0a26: 4ebafbc2             jsr        $5ea(pc)
0a2a: 4a40                 tst.w      d0
0a2c: 670a                 beq.b      $a38
0a2e: 486d910e             pea.l      -$6ef2(a5)
0a32: 4ead0c72             jsr        $c72(a5) ; CODE41+0250
0a36: 588f                 addq.l     #$4, a7
0a38: 206ddec2             movea.l    -$213e(a5), a0
0a3c: 4a6800d2             tst.w      $d2(a0)
0a40: 6728                 beq.b      $a6a
0a42: 3f3c0401             move.w     #$401, -(a7)
0a46: 4ead0c6a             jsr        $c6a(a5) ; CODE41+010a
0a4a: 3d40000c             move.w     d0, $c(a6)
0a4e: 5340                 subq.w     #$1, d0
0a50: 548f                 addq.l     #$2, a7
0a52: 660e                 bne.b      $a62
0a54: 3f3c0001             move.w     #$1, -(a7)
0a58: 4eba0074             jsr        $ace(pc)
0a5c: 4a40                 tst.w      d0
0a5e: 548f                 addq.l     #$2, a7
0a60: 6608                 bne.b      $a6a
0a62: 0c6e0002000c         cmpi.w     #$2, $c(a6)
0a68: 6606                 bne.b      $a70
0a6a: 3b7c0006de64         move.w     #$6, -$219c(a5)
0a70: 4e5e                 unlk       a6
0a72: 4e75                 rts        
0a74: 4e56fffe             link.w     a6, #$fffe
0a78: 0c6d0005de66         cmpi.w     #$5, -$219a(a5)
0a7e: 6612                 bne.b      $a92
0a80: 4ebafb68             jsr        $5ea(pc)
0a84: 4a40                 tst.w      d0
0a86: 670a                 beq.b      $a92
0a88: 486d9148             pea.l      -$6eb8(a5)
0a8c: 4ead0c72             jsr        $c72(a5) ; CODE41+0250
0a90: 588f                 addq.l     #$4, a7
0a92: 206ddec2             movea.l    -$213e(a5), a0
0a96: 4a6800d2             tst.w      $d2(a0)
0a9a: 6728                 beq.b      $ac4
0a9c: 3f3c0403             move.w     #$403, -(a7)
0aa0: 4ead0c6a             jsr        $c6a(a5) ; CODE41+010a
0aa4: 3d40000c             move.w     d0, $c(a6)
0aa8: 5340                 subq.w     #$1, d0
0aaa: 548f                 addq.l     #$2, a7
0aac: 660e                 bne.b      $abc
0aae: 3f3c0001             move.w     #$1, -(a7)
0ab2: 4eba001a             jsr        $ace(pc)
0ab6: 4a40                 tst.w      d0
0ab8: 548f                 addq.l     #$2, a7
0aba: 6608                 bne.b      $ac4
0abc: 0c6e0002000c         cmpi.w     #$2, $c(a6)
0ac2: 6606                 bne.b      $aca
0ac4: 3b7c0001de64         move.w     #$1, -$219c(a5)
0aca: 4e5e                 unlk       a6
0acc: 4e75                 rts        
0ace: 4e56ffb6             link.w     a6, #$ffb6
0ad2: 1d6e0009ffb6         move.b     $9(a6), -$4a(a6)
0ad8: 6714                 beq.b      $aee
0ada: 41eeffb6             lea.l      -$4a(a6), a0
0ade: 43edd720             lea.l      -$28e0(a5), a1
0ae2: 7011                 moveq      #$11, d0
0ae4: 20d9                 move.l     (a1)+, (a0)+
0ae6: 51c8fffc             dbra       d0, $ae4
0aea: 30d9                 move.w     (a1)+, (a0)+
0aec: 600e                 bra.b      $afc
0aee: 4878004a             pea.l      $4a.w
0af2: 486effb6             pea.l      -$4a(a6)
0af6: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0afa: 508f                 addq.l     #$8, a7
0afc: 4267                 clr.w      -(a7)
0afe: 42a7                 clr.l      -(a7)
0b00: 486effb6             pea.l      -$4a(a6)
0b04: 4ead0612             jsr        $612(a5) ; CODE9+0b82
0b08: 4a2effb6             tst.b      -$4a(a6)
0b0c: 4fef000a             lea.l      $a(a7), a7
0b10: 6720                 beq.b      $b32
0b12: 41edd720             lea.l      -$28e0(a5), a0
0b16: 43eeffb6             lea.l      -$4a(a6), a1
0b1a: 7011                 moveq      #$11, d0
0b1c: 20d9                 move.l     (a1)+, (a0)+
0b1e: 51c8fffc             dbra       d0, $b1c
0b22: 30d9                 move.w     (a1)+, (a0)+
0b24: 486effc0             pea.l      -$40(a6)
0b28: 3f2effbc             move.w     -$44(a6), -(a7)
0b2c: 4ead05a2             jsr        $5a2(a5) ; CODE22+0166
0b30: 5c8f                 addq.l     #$6, a7
0b32: 7000                 moveq      #$0, d0
0b34: 102effb6             move.b     -$4a(a6), d0
0b38: 4e5e                 unlk       a6
0b3a: 4e75                 rts        
