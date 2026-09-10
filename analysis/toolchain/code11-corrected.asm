0004: 4e560000             link.w     a6, #$0
0008: 2f0c                 move.l     a4, -(a7)
000a: 286e0008             movea.l    $8(a6), a4
000e: 200c                 move.l     a4, d0
0010: 6608                 bne.b      $1a
0012: 41ed92f8             lea.l      -$6d08(a5), a0
0016: 2008                 move.l     a0, d0
0018: 603c                 bra.b      $56
001a: 2f0c                 move.l     a4, -(a7)
001c: 4ead064a             jsr        $64a(a5) ; CODE9+0e30
0020: 4a40                 tst.w      d0
0022: 588f                 addq.l     #$4, a7
0024: 6708                 beq.b      $2e
0026: 41ed9308             lea.l      -$6cf8(a5), a0
002a: 2008                 move.l     a0, d0
002c: 6028                 bra.b      $56
002e: 0c6c0008006c         cmpi.w     #$8, $6c(a4)
0034: 6c14                 bge.b      $4a
0036: 082c0001006d         btst.b     #$1, $6d(a4)
003c: 6712                 beq.b      $50
003e: 2f0c                 move.l     a4, -(a7)
0040: 4eba010e             jsr        $150(pc)
0044: 4a40                 tst.w      d0
0046: 588f                 addq.l     #$4, a7
0048: 6706                 beq.b      $50
004a: 202c0098             move.l     $98(a4), d0
004e: 6006                 bra.b      $56
0050: 41ed9308             lea.l      -$6cf8(a5), a0
0054: 2008                 move.l     a0, d0
0056: 285f                 movea.l    (a7)+, a4
0058: 4e5e                 unlk       a6
005a: 4e75                 rts        
005c: 4e560000             link.w     a6, #$0
0060: 2f0c                 move.l     a4, -(a7)
0062: 2f2e000c             move.l     $c(a6), -(a7)
0066: 2f2e0008             move.l     $8(a6), -(a7)
006a: 4eba001e             jsr        $8a(pc)
006e: 2840                 movea.l    d0, a4
0070: 200c                 move.l     a4, d0
0072: 508f                 addq.l     #$8, a7
0074: 670c                 beq.b      $82
0076: 2f2e0010             move.l     $10(a6), -(a7)
007a: 2f2e0008             move.l     $8(a6), -(a7)
007e: 4e94                 jsr        (a4)
0080: 508f                 addq.l     #$8, a7
0082: 7001                 moveq      #$1, d0
0084: 285f                 movea.l    (a7)+, a4
0086: 4e5e                 unlk       a6
0088: 4e75                 rts        
008a: 4e560000             link.w     a6, #$0
008e: 2f2e000c             move.l     $c(a6), -(a7)
0092: 2f2e0008             move.l     $8(a6), -(a7)
0096: 4ebaff6c             jsr        $4(pc)
009a: 2e80                 move.l     d0, (a7)
009c: 4eba0006             jsr        $a4(pc)
00a0: 4e5e                 unlk       a6
00a2: 4e75                 rts        
00a4: 4e560000             link.w     a6, #$0
00a8: 48e70338             movem.l    d6-d7/a2-a4, -(a7)
00ac: 286e0008             movea.l    $8(a6), a4
00b0: 602a                 bra.b      $dc
00b2: 3e2c0002             move.w     $2(a4), d7
00b6: 7c01                 moveq      #$1, d6
00b8: 367c0008             movea.w    #$8, a3
00bc: 6016                 bra.b      $d4
00be: 244b                 movea.l    a3, a2
00c0: d5cc                 adda.l     a4, a2
00c2: 2012                 move.l     (a2), d0
00c4: b0ae000c             cmp.l      $c(a6), d0
00c8: 6606                 bne.b      $d0
00ca: 202a0004             move.l     $4(a2), d0
00ce: 6012                 bra.b      $e2
00d0: 5246                 addq.w     #$1, d6
00d2: 508b                 addq.l     #$8, a3
00d4: be46                 cmp.w      d6, d7
00d6: 6ce6                 bge.b      $be
00d8: 286c0004             movea.l    $4(a4), a4
00dc: 200c                 move.l     a4, d0
00de: 66d2                 bne.b      $b2
00e0: 7000                 moveq      #$0, d0
00e2: 4cdf1cc0             movem.l    (a7)+, d6-d7/a2-a4
00e6: 4e5e                 unlk       a6
00e8: 4e75                 rts        
00ea: 4e560000             link.w     a6, #$0
00ee: 42a7                 clr.l      -(a7)
00f0: 2f2e0008             move.l     $8(a6), -(a7)
00f4: a917                 dc.w       $a917
00f6: 206e000c             movea.l    $c(a6), a0
00fa: 215f0004             move.l     (a7)+, $4(a0)
00fe: 2f2e0008             move.l     $8(a6), -(a7)
0102: 2f08                 move.l     a0, -(a7)
0104: a918                 dc.w       $a918
0106: 4e5e                 unlk       a6
0108: 4e75                 rts        
010a: 4e560000             link.w     a6, #$0
010e: 48e70138             movem.l    d7/a2-a4, -(a7)
0112: 2f2e0008             move.l     $8(a6), -(a7)
0116: 4ebafeec             jsr        $4(pc)
011a: 2840                 movea.l    d0, a4
011c: 7e01                 moveq      #$1, d7
011e: 367c0008             movea.w    #$8, a3
0122: 588f                 addq.l     #$4, a7
0124: 6018                 bra.b      $13e
0126: 244b                 movea.l    a3, a2
0128: d5cc                 adda.l     a4, a2
012a: 2012                 move.l     (a2), d0
012c: b0ae000c             cmp.l      $c(a6), d0
0130: 6608                 bne.b      $13a
0132: 256e00100004         move.l     $10(a6), $4(a2)
0138: 600e                 bra.b      $148
013a: 5247                 addq.w     #$1, d7
013c: 508b                 addq.l     #$8, a3
013e: 3047                 movea.w    d7, a0
0140: b1d4                 cmpa.l     (a4), a0
0142: 6fe2                 ble.b      $126
0144: 4eba1022             jsr        $1168(pc)
0148: 4cdf1c80             movem.l    (a7)+, d7/a2-a4
014c: 4e5e                 unlk       a6
014e: 4e75                 rts        
0150: 4e560000             link.w     a6, #$0
0154: 48e70108             movem.l    d7/a4, -(a7)
0158: 7e00                 moveq      #$0, d7
015a: 49ed9368             lea.l      -$6c98(a5), a4
015e: 6010                 bra.b      $170
0160: 2014                 move.l     (a4), d0
0162: b0ae0008             cmp.l      $8(a6), d0
0166: 6604                 bne.b      $16c
0168: 7001                 moveq      #$1, d0
016a: 600c                 bra.b      $178
016c: 5247                 addq.w     #$1, d7
016e: 588c                 addq.l     #$4, a4
0170: be6d9320             cmp.w      -$6ce0(a5), d7
0174: 6dea                 blt.b      $160
0176: 7000                 moveq      #$0, d0
0178: 4cdf1080             movem.l    (a7)+, d7/a4
017c: 4e5e                 unlk       a6
017e: 4e75                 rts        
0180: 4e560000             link.w     a6, #$0
0184: 0c6d00109320         cmpi.w     #$10, -$6ce0(a5)
018a: 6504                 bcs.b      $190
018c: 4eba0fda             jsr        $1168(pc)
0190: 302d9320             move.w     -$6ce0(a5), d0
0194: 526d9320             addq.w     #$1, -$6ce0(a5)
0198: 204d                 movea.l    a5, a0
019a: 48c0                 ext.l      d0
019c: e588                 lsl.l      #$2, d0
019e: d1c0                 adda.l     d0, a0
01a0: 216e00089368         move.l     $8(a6), -$6c98(a0)
01a6: 4e5e                 unlk       a6
01a8: 4e75                 rts        
01aa: 4e560000             link.w     a6, #$0
01ae: 48e70108             movem.l    d7/a4, -(a7)
01b2: 7e00                 moveq      #$0, d7
01b4: 49ed9368             lea.l      -$6c98(a5), a4
01b8: 6004                 bra.b      $1be
01ba: 5247                 addq.w     #$1, d7
01bc: 588c                 addq.l     #$4, a4
01be: be6d9320             cmp.w      -$6ce0(a5), d7
01c2: 6c08                 bge.b      $1cc
01c4: 2014                 move.l     (a4), d0
01c6: b0ae0008             cmp.l      $8(a6), d0
01ca: 66ee                 bne.b      $1ba
01cc: be6d9320             cmp.w      -$6ce0(a5), d7
01d0: 6604                 bne.b      $1d6
01d2: 4eba0f94             jsr        $1168(pc)
01d6: 4a6d9320             tst.w      -$6ce0(a5)
01da: 6e04                 bgt.b      $1e0
01dc: 4eba0f8a             jsr        $1168(pc)
01e0: 536d9320             subq.w     #$1, -$6ce0(a5)
01e4: 302d9320             move.w     -$6ce0(a5), d0
01e8: 204d                 movea.l    a5, a0
01ea: 48c0                 ext.l      d0
01ec: e588                 lsl.l      #$2, d0
01ee: d1c0                 adda.l     d0, a0
01f0: 224d                 movea.l    a5, a1
01f2: 2007                 move.l     d7, d0
01f4: 48c0                 ext.l      d0
01f6: e588                 lsl.l      #$2, d0
01f8: d3c0                 adda.l     d0, a1
01fa: 236893689368         move.l     -$6c98(a0), -$6c98(a1)
0200: 48780004             pea.l      $4.w
0204: 4eba034e             jsr        $554(pc)
0208: 4cee1080fff8         movem.l    -$8(a6), d7/a4
020e: 4e5e                 unlk       a6
0210: 4e75                 rts        
0212: 4e560000             link.w     a6, #$0
0216: 48e70138             movem.l    d7/a2-a4, -(a7)
021a: 286e0008             movea.l    $8(a6), a4
021e: 2e2e000c             move.l     $c(a6), d7
0222: 200c                 move.l     a4, d0
0224: 6754                 beq.b      $27a
0226: 4a2c006e             tst.b      $6e(a4)
022a: 674e                 beq.b      $27a
022c: 2f0c                 move.l     a4, -(a7)
022e: 4ebafdd4             jsr        $4(pc)
0232: 2640                 movea.l    d0, a3
0234: 2047                 movea.l    d7, a0
0236: 08280000000f         btst.b     #$0, $f(a0)
023c: 588f                 addq.l     #$4, a7
023e: 6720                 beq.b      $260
0240: 2b4c9364             move.l     a4, -$6c9c(a5)
0244: 48780004             pea.l      $4.w
0248: 2f0b                 move.l     a3, -(a7)
024a: 4ebafe58             jsr        $a4(pc)
024e: 2440                 movea.l    d0, a2
0250: 200a                 move.l     a2, d0
0252: 508f                 addq.l     #$8, a7
0254: 6724                 beq.b      $27a
0256: 2f07                 move.l     d7, -(a7)
0258: 2f0c                 move.l     a4, -(a7)
025a: 4e92                 jsr        (a2)
025c: 508f                 addq.l     #$8, a7
025e: 601a                 bra.b      $27a
0260: 48780005             pea.l      $5.w
0264: 2f0b                 move.l     a3, -(a7)
0266: 4ebafe3c             jsr        $a4(pc)
026a: 2440                 movea.l    d0, a2
026c: 200a                 move.l     a2, d0
026e: 508f                 addq.l     #$8, a7
0270: 6708                 beq.b      $27a
0272: 2f07                 move.l     d7, -(a7)
0274: 2f0c                 move.l     a4, -(a7)
0276: 4e92                 jsr        (a2)
0278: 508f                 addq.l     #$8, a7
027a: 4cdf1c80             movem.l    (a7)+, d7/a2-a4
027e: 4e5e                 unlk       a6
0280: 4e75                 rts        
0282: 4e56fe00             link.w     a6, #$fe00
0286: 48e70308             movem.l    d6-d7/a4, -(a7)
028a: 286e0008             movea.l    $8(a6), a4
028e: 200c                 move.l     a4, d0
0290: 6604                 bne.b      $296
0292: 4eba0ed4             jsr        $1168(pc)
0296: 4267                 clr.w      -(a7)
0298: 2f0c                 move.l     a4, -(a7)
029a: a950                 dc.w       $a950
029c: 3e1f                 move.w     (a7)+, d7
029e: 7c01                 moveq      #$1, d6
02a0: 6028                 bra.b      $2ca
02a2: 2f0c                 move.l     a4, -(a7)
02a4: 3f06                 move.w     d6, -(a7)
02a6: 486efe00             pea.l      -$200(a6)
02aa: a946                 dc.w       $a946
02ac: 0c2e002dfe01         cmpi.b     #$2d, -$1ff(a6)
02b2: 670e                 beq.b      $2c2
02b4: 4a6e000c             tst.w      $c(a6)
02b8: 6708                 beq.b      $2c2
02ba: 2f0c                 move.l     a4, -(a7)
02bc: 3f06                 move.w     d6, -(a7)
02be: a939                 dc.w       $a939
02c0: 6006                 bra.b      $2c8
02c2: 2f0c                 move.l     a4, -(a7)
02c4: 3f06                 move.w     d6, -(a7)
02c6: a93a                 dc.w       $a93a
02c8: 5246                 addq.w     #$1, d6
02ca: be46                 cmp.w      d6, d7
02cc: 6cd4                 bge.b      $2a2
02ce: 4cdf10c0             movem.l    (a7)+, d6-d7/a4
02d2: 4e5e                 unlk       a6
02d4: 4e75                 rts        
02d6: 4e56fefa             link.w     a6, #$fefa
02da: 48e70108             movem.l    d7/a4, -(a7)
02de: 4267                 clr.w      -(a7)
02e0: 2f3c4d454e55         move.l     #$4d454e55, -(a7)
02e6: a80d                 dc.w       $a80d
02e8: 3e1f                 move.w     (a7)+, d7
02ea: 604e                 bra.b      $33a
02ec: 4227                 clr.b      -(a7)
02ee: a99b                 dc.w       $a99b
02f0: 42a7                 clr.l      -(a7)
02f2: 2f3c4d454e55         move.l     #$4d454e55, -(a7)
02f8: 3f07                 move.w     d7, -(a7)
02fa: a80e                 dc.w       $a80e
02fc: 285f                 movea.l    (a7)+, a4
02fe: 200c                 move.l     a4, d0
0300: 6604                 bne.b      $306
0302: 4eba0e64             jsr        $1168(pc)
0306: 1f3c0001             move.b     #$1, -(a7)
030a: a99b                 dc.w       $a99b
030c: 2f0c                 move.l     a4, -(a7)
030e: 486efffe             pea.l      -$2(a6)
0312: 486efffa             pea.l      -$6(a6)
0316: 486efefa             pea.l      -$106(a6)
031a: a9a8                 dc.w       $a9a8
031c: 42a7                 clr.l      -(a7)
031e: 3f2efffe             move.w     -$2(a6), -(a7)
0322: a949                 dc.w       $a949
0324: 285f                 movea.l    (a7)+, a4
0326: 200c                 move.l     a4, d0
0328: 670e                 beq.b      $338
032a: 3f2e000c             move.w     $c(a6), -(a7)
032e: 2f0c                 move.l     a4, -(a7)
0330: 206e0008             movea.l    $8(a6), a0
0334: 4e90                 jsr        (a0)
0336: 5c8f                 addq.l     #$6, a7
0338: 5347                 subq.w     #$1, d7
033a: 4a47                 tst.w      d7
033c: 66ae                 bne.b      $2ec
033e: 4cdf1080             movem.l    (a7)+, d7/a4
0342: 4e5e                 unlk       a6
0344: 4e75                 rts        
0346: 4e560000             link.w     a6, #$0
034a: 4267                 clr.w      -(a7)
034c: 486d01f2             pea.l      $1f2(a5)
0350: 4ebaff84             jsr        $2d6(pc)
0354: 2eae000c             move.l     $c(a6), (a7)
0358: 2f2e0008             move.l     $8(a6), -(a7)
035c: 4eba005a             jsr        $3b8(pc)
0360: 4aadface             tst.l      -$532(a5)
0364: 4fef000a             lea.l      $a(a7), a7
0368: 6714                 beq.b      $37e
036a: 2f2dface             move.l     -$532(a5), -(a7)
036e: 4ebafc94             jsr        $4(pc)
0372: 2e80                 move.l     d0, (a7)
0374: 2f2dface             move.l     -$532(a5), -(a7)
0378: 4eba003e             jsr        $3b8(pc)
037c: 508f                 addq.l     #$8, a7
037e: 4e5e                 unlk       a6
0380: 4e75                 rts        
0382: 4e560000             link.w     a6, #$0
0386: 4a6e000c             tst.w      $c(a6)
038a: 670a                 beq.b      $396
038c: 2f2e0008             move.l     $8(a6), -(a7)
0390: 4267                 clr.w      -(a7)
0392: a939                 dc.w       $a939
0394: 6008                 bra.b      $39e
0396: 2f2e0008             move.l     $8(a6), -(a7)
039a: 4267                 clr.w      -(a7)
039c: a93a                 dc.w       $a93a
039e: 4e5e                 unlk       a6
03a0: 4e75                 rts        
03a2: 4e560000             link.w     a6, #$0
03a6: 3f2e0008             move.w     $8(a6), -(a7)
03aa: 486d01c2             pea.l      $1c2(a5)
03ae: 4ebaff26             jsr        $2d6(pc)
03b2: a937                 dc.w       $a937
03b4: 4e5e                 unlk       a6
03b6: 4e75                 rts        
03b8: 4e560000             link.w     a6, #$0
03bc: 48e70338             movem.l    d6-d7/a2-a4, -(a7)
03c0: 286e000c             movea.l    $c(a6), a4
03c4: 42a7                 clr.l      -(a7)
03c6: 2f0c                 move.l     a4, -(a7)
03c8: 4ebafcda             jsr        $a4(pc)
03cc: 2840                 movea.l    d0, a4
03ce: 508f                 addq.l     #$8, a7
03d0: 6000008c             bra.w      $45e
03d4: 7c01                 moveq      #$1, d6
03d6: 367c000c             movea.w    #$c, a3
03da: 6078                 bra.b      $454
03dc: 204b                 movea.l    a3, a0
03de: d1cc                 adda.l     a4, a0
03e0: 2e08                 move.l     a0, d7
03e2: 2047                 movea.l    d7, a0
03e4: 4aa80008             tst.l      $8(a0)
03e8: 6764                 beq.b      $44e
03ea: 42a7                 clr.l      -(a7)
03ec: 4267                 clr.w      -(a7)
03ee: 2047                 movea.l    d7, a0
03f0: 2f10                 move.l     (a0), -(a7)
03f2: a86a                 dc.w       $a86a
03f4: a949                 dc.w       $a949
03f6: 245f                 movea.l    (a7)+, a2
03f8: 200a                 move.l     a2, d0
03fa: 6752                 beq.b      $44e
03fc: 204c                 movea.l    a4, a0
03fe: d1cb                 adda.l     a3, a0
0400: 4aa80004             tst.l      $4(a0)
0404: 671c                 beq.b      $422
0406: 204c                 movea.l    a4, a0
0408: d1cb                 adda.l     a3, a0
040a: 2f10                 move.l     (a0), -(a7)
040c: 2f0a                 move.l     a2, -(a7)
040e: 2f2e0008             move.l     $8(a6), -(a7)
0412: 204c                 movea.l    a4, a0
0414: d1cb                 adda.l     a3, a0
0416: 20680004             movea.l    $4(a0), a0
041a: 4e90                 jsr        (a0)
041c: 4fef000c             lea.l      $c(a7), a7
0420: 6002                 bra.b      $424
0422: 7001                 moveq      #$1, d0
0424: 4a80                 tst.l      d0
0426: 6726                 beq.b      $44e
0428: 4267                 clr.w      -(a7)
042a: 2047                 movea.l    d7, a0
042c: 2f10                 move.l     (a0), -(a7)
042e: a86b                 dc.w       $a86b
0430: 4a5f                 tst.w      (a7)+
0432: 670e                 beq.b      $442
0434: 2f0a                 move.l     a2, -(a7)
0436: 4267                 clr.w      -(a7)
0438: 2047                 movea.l    d7, a0
043a: 2f10                 move.l     (a0), -(a7)
043c: a86b                 dc.w       $a86b
043e: a939                 dc.w       $a939
0440: 600c                 bra.b      $44e
0442: 3f3c0001             move.w     #$1, -(a7)
0446: 2f0a                 move.l     a2, -(a7)
0448: 4ebafe38             jsr        $282(pc)
044c: 5c8f                 addq.l     #$6, a7
044e: 5246                 addq.w     #$1, d6
0450: 47eb000c             lea.l      $c(a3), a3
0454: 3046                 movea.w    d6, a0
0456: b1d4                 cmpa.l     (a4), a0
0458: 6f82                 ble.b      $3dc
045a: 286c0008             movea.l    $8(a4), a4
045e: 200c                 move.l     a4, d0
0460: 6600ff72             bne.w      $3d4
0464: 4cdf1cc0             movem.l    (a7)+, d6-d7/a2-a4
0468: 4e5e                 unlk       a6
046a: 4e75                 rts        
046c: 4e560000             link.w     a6, #$0
0470: 2f0c                 move.l     a4, -(a7)
0472: 2f2e0010             move.l     $10(a6), -(a7)
0476: 2f2e000c             move.l     $c(a6), -(a7)
047a: 206e0008             movea.l    $8(a6), a0
047e: 2f10                 move.l     (a0), -(a7)
0480: 4eba004a             jsr        $4cc(pc)
0484: 2840                 movea.l    d0, a4
0486: 200c                 move.l     a4, d0
0488: 4fef000c             lea.l      $c(a7), a7
048c: 6704                 beq.b      $492
048e: 200c                 move.l     a4, d0
0490: 6034                 bra.b      $4c6
0492: 4aadface             tst.l      -$532(a5)
0496: 672c                 beq.b      $4c4
0498: 2f2e0010             move.l     $10(a6), -(a7)
049c: 2f2dface             move.l     -$532(a5), -(a7)
04a0: 4ebafb62             jsr        $4(pc)
04a4: 2e80                 move.l     d0, (a7)
04a6: 2f2dface             move.l     -$532(a5), -(a7)
04aa: 4eba0020             jsr        $4cc(pc)
04ae: 2840                 movea.l    d0, a4
04b0: 200c                 move.l     a4, d0
04b2: 4fef000c             lea.l      $c(a7), a7
04b6: 670c                 beq.b      $4c4
04b8: 206e0008             movea.l    $8(a6), a0
04bc: 20adface             move.l     -$532(a5), (a0)
04c0: 200c                 move.l     a4, d0
04c2: 6002                 bra.b      $4c6
04c4: 7000                 moveq      #$0, d0
04c6: 285f                 movea.l    (a7)+, a4
04c8: 4e5e                 unlk       a6
04ca: 4e75                 rts        
04cc: 4e560000             link.w     a6, #$0
04d0: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
04d4: 286e000c             movea.l    $c(a6), a4
04d8: 2c2e0010             move.l     $10(a6), d6
04dc: 02460000             andi.w     #$0, d6
04e0: 42a7                 clr.l      -(a7)
04e2: 2f0c                 move.l     a4, -(a7)
04e4: 4ebafbbe             jsr        $a4(pc)
04e8: 2840                 movea.l    d0, a4
04ea: 508f                 addq.l     #$8, a7
04ec: 6058                 bra.b      $546
04ee: 3a2c0002             move.w     $2(a4), d5
04f2: 7801                 moveq      #$1, d4
04f4: 367c000c             movea.w    #$c, a3
04f8: 6044                 bra.b      $53e
04fa: 244b                 movea.l    a3, a2
04fc: d5cc                 adda.l     a4, a2
04fe: 2612                 move.l     (a2), d3
0500: b6ae0010             cmp.l      $10(a6), d3
0504: 6704                 beq.b      $50a
0506: bc83                 cmp.l      d3, d6
0508: 662e                 bne.b      $538
050a: 42a7                 clr.l      -(a7)
050c: 4267                 clr.w      -(a7)
050e: 2f12                 move.l     (a2), -(a7)
0510: a86a                 dc.w       $a86a
0512: a949                 dc.w       $a949
0514: 2e1f                 move.l     (a7)+, d7
0516: 4aaa0004             tst.l      $4(a2)
051a: 6716                 beq.b      $532
051c: 2f12                 move.l     (a2), -(a7)
051e: 2f07                 move.l     d7, -(a7)
0520: 2f2e0008             move.l     $8(a6), -(a7)
0524: 206a0004             movea.l    $4(a2), a0
0528: 4e90                 jsr        (a0)
052a: 4a80                 tst.l      d0
052c: 4fef000c             lea.l      $c(a7), a7
0530: 6706                 beq.b      $538
0532: 202a0008             move.l     $8(a2), d0
0536: 6014                 bra.b      $54c
0538: 5244                 addq.w     #$1, d4
053a: 47eb000c             lea.l      $c(a3), a3
053e: ba44                 cmp.w      d4, d5
0540: 6cb8                 bge.b      $4fa
0542: 286c0008             movea.l    $8(a4), a4
0546: 200c                 move.l     a4, d0
0548: 66a4                 bne.b      $4ee
054a: 7000                 moveq      #$0, d0
054c: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0550: 4e5e                 unlk       a6
0552: 4e75                 rts        
0554: 4e560000             link.w     a6, #$0
0558: 48e70118             movem.l    d7/a3-a4, -(a7)
055c: 2e2e0008             move.l     $8(a6), d7
0560: 2f2dfad2             move.l     -$52e(a5), -(a7)
0564: 4ebafa9e             jsr        $4(pc)
0568: 2840                 movea.l    d0, a4
056a: 2eadface             move.l     -$532(a5), (a7)
056e: 4ebafa94             jsr        $4(pc)
0572: 2640                 movea.l    d0, a3
0574: 2e87                 move.l     d7, (a7)
0576: 2f0c                 move.l     a4, -(a7)
0578: 4ebafb2a             jsr        $a4(pc)
057c: 4a80                 tst.l      d0
057e: 508f                 addq.l     #$8, a7
0580: 6716                 beq.b      $598
0582: 2f07                 move.l     d7, -(a7)
0584: 2f0b                 move.l     a3, -(a7)
0586: 4ebafb1c             jsr        $a4(pc)
058a: 4a80                 tst.l      d0
058c: 508f                 addq.l     #$8, a7
058e: 6622                 bne.b      $5b2
0590: 2b6dfad29364         move.l     -$52e(a5), -$6c9c(a5)
0596: 601a                 bra.b      $5b2
0598: 2f07                 move.l     d7, -(a7)
059a: 2f0b                 move.l     a3, -(a7)
059c: 4ebafb06             jsr        $a4(pc)
05a0: 4a80                 tst.l      d0
05a2: 508f                 addq.l     #$8, a7
05a4: 6708                 beq.b      $5ae
05a6: 2b6dface9364         move.l     -$532(a5), -$6c9c(a5)
05ac: 6004                 bra.b      $5b2
05ae: 7000                 moveq      #$0, d0
05b0: 6004                 bra.b      $5b6
05b2: 202d9364             move.l     -$6c9c(a5), d0
05b6: 4cdf1880             movem.l    (a7)+, d7/a3-a4
05ba: 4e5e                 unlk       a6
05bc: 4e75                 rts        
05be: 4e560000             link.w     a6, #$0
05c2: 48e70108             movem.l    d7/a4, -(a7)
05c6: 286e000c             movea.l    $c(a6), a4
05ca: 4267                 clr.w      -(a7)
05cc: 2f2e0008             move.l     $8(a6), -(a7)
05d0: 2f0c                 move.l     a4, -(a7)
05d2: a92c                 dc.w       $a92c
05d4: 3e1f                 move.w     (a7)+, d7
05d6: 4a94                 tst.l      (a4)
05d8: 6606                 bne.b      $5e0
05da: 4ead0c42             jsr        $c42(a5) ; CODE46+0a2a
05de: 2880                 move.l     d0, (a4)
05e0: 2b549364             move.l     (a4), -$6c9c(a5)
05e4: 3007                 move.w     d7, d0
05e6: 4cdf1080             movem.l    (a7)+, d7/a4
05ea: 4e5e                 unlk       a6
05ec: 4e75                 rts        
05ee: 4e56ffdc             link.w     a6, #$ffdc
05f2: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
05f6: 286e0008             movea.l    $8(a6), a4
05fa: 0c540001             cmpi.w     #$1, (a4)
05fe: 660001b8             bne.w      $7b8
0602: 486efff4             pea.l      -$c(a6)
0606: 2f2c000a             move.l     $a(a4), -(a7)
060a: 4ebaffb2             jsr        $5be(pc)
060e: 3a00                 move.w     d0, d5
0610: 2eaefff4             move.l     -$c(a6), (a7)
0614: 4ebaf9ee             jsr        $4(pc)
0618: 2640                 movea.l    d0, a3
061a: 3005                 move.w     d5, d0
061c: 0c400008             cmpi.w     #$8, d0
0620: 508f                 addq.l     #$8, a7
0622: 620003e4             bhi.w      $a08
0626: 43fa0408             lea.l      $a30(pc), a1
062a: d040                 add.w      d0, d0
062c: d2f10000             adda.w     (a1, d0.w), a1
0630: 4ed1                 jmp        (a1)
0632: 2f0c                 move.l     a4, -(a7)
0634: 2f2efff4             move.l     -$c(a6), -(a7)
0638: a9b3                 dc.w       $a9b3
063a: 600003cc             bra.w      $a08
063e: 7c08                 moveq      #$8, d6
0640: 600001c6             bra.w      $808
0644: 7c01                 moveq      #$1, d6
0646: 600001c0             bra.w      $808
064a: a850                 dc.w       $a850
064c: 2f0b                 move.l     a3, -(a7)
064e: 2f2efff4             move.l     -$c(a6), -(a7)
0652: 4ebafcf2             jsr        $346(pc)
0656: 4297                 clr.l      (a7)
0658: 2f2c000a             move.l     $a(a4), -(a7)
065c: a93d                 dc.w       $a93d
065e: 2e1f                 move.l     (a7)+, d7
0660: 588f                 addq.l     #$4, a7
0662: 4267                 clr.w      -(a7)
0664: 2f07                 move.l     d7, -(a7)
0666: a86a                 dc.w       $a86a
0668: 4a5f                 tst.w      (a7)+
066a: 6700039c             beq.w      $a08
066e: 2f07                 move.l     d7, -(a7)
0670: 2f0b                 move.l     a3, -(a7)
0672: 486efff4             pea.l      -$c(a6)
0676: 4ebafdf4             jsr        $46c(pc)
067a: 2440                 movea.l    d0, a2
067c: 200a                 move.l     a2, d0
067e: 4fef000c             lea.l      $c(a7), a7
0682: 670e                 beq.b      $692
0684: 4267                 clr.w      -(a7)
0686: 2f07                 move.l     d7, -(a7)
0688: a86b                 dc.w       $a86b
068a: 2f2efff4             move.l     -$c(a6), -(a7)
068e: 4e92                 jsr        (a2)
0690: 5c8f                 addq.l     #$6, a7
0692: 4267                 clr.w      -(a7)
0694: a938                 dc.w       $a938
0696: 60000370             bra.w      $a08
069a: 2f2efff4             move.l     -$c(a6), -(a7)
069e: 4ead0c2a             jsr        $c2a(a5) ; CODE46+0774
06a2: 4a40                 tst.w      d0
06a4: 588f                 addq.l     #$4, a7
06a6: 6606                 bne.b      $6ae
06a8: 7c12                 moveq      #$12, d6
06aa: 6000015c             bra.w      $808
06ae: 2d6c000affec         move.l     $a(a4), -$14(a6)
06b4: 2f2efff4             move.l     -$c(a6), -(a7)
06b8: a873                 dc.w       $a873
06ba: 486effec             pea.l      -$14(a6)
06be: a871                 dc.w       $a871
06c0: 4267                 clr.w      -(a7)
06c2: 2f2effec             move.l     -$14(a6), -(a7)
06c6: 2f2efff4             move.l     -$c(a6), -(a7)
06ca: 486effe8             pea.l      -$18(a6)
06ce: a96c                 dc.w       $a96c
06d0: 3a1f                 move.w     (a7)+, d5
06d2: 6760                 beq.b      $734
06d4: 42a7                 clr.l      -(a7)
06d6: 2f2effe8             move.l     -$18(a6), -(a7)
06da: a95a                 dc.w       $a95a
06dc: 265f                 movea.l    (a7)+, a3
06de: 48780014             pea.l      $14.w
06e2: 2f0b                 move.l     a3, -(a7)
06e4: 4ebaf9be             jsr        $a4(pc)
06e8: 2440                 movea.l    d0, a2
06ea: 200a                 move.l     a2, d0
06ec: 508f                 addq.l     #$8, a7
06ee: 670c                 beq.b      $6fc
06f0: 3f05                 move.w     d5, -(a7)
06f2: 2f2effe8             move.l     -$18(a6), -(a7)
06f6: 4e92                 jsr        (a2)
06f8: 2440                 movea.l    d0, a2
06fa: 5c8f                 addq.l     #$6, a7
06fc: 4267                 clr.w      -(a7)
06fe: 2f2effe8             move.l     -$18(a6), -(a7)
0702: 2f2effec             move.l     -$14(a6), -(a7)
0706: 2f0a                 move.l     a2, -(a7)
0708: a968                 dc.w       $a968
070a: 3a1f                 move.w     (a7)+, d5
070c: 4a45                 tst.w      d5
070e: 670002f8             beq.w      $a08
0712: 48780015             pea.l      $15.w
0716: 2f0b                 move.l     a3, -(a7)
0718: 4ebaf98a             jsr        $a4(pc)
071c: 2440                 movea.l    d0, a2
071e: 200a                 move.l     a2, d0
0720: 508f                 addq.l     #$8, a7
0722: 670002e4             beq.w      $a08
0726: 3f05                 move.w     d5, -(a7)
0728: 2f2effe8             move.l     -$18(a6), -(a7)
072c: 4e92                 jsr        (a2)
072e: 5c8f                 addq.l     #$6, a7
0730: 600002d6             bra.w      $a08
0734: 7c06                 moveq      #$6, d6
0736: 600000d0             bra.w      $808
073a: 2f2efff4             move.l     -$c(a6), -(a7)
073e: 4ead0c2a             jsr        $c2a(a5) ; CODE46+0774
0742: 4a40                 tst.w      d0
0744: 588f                 addq.l     #$4, a7
0746: 6700ff60             beq.w      $6a8
074a: 7c09                 moveq      #$9, d6
074c: 600000ba             bra.w      $808
0750: 4878000b             pea.l      $b.w
0754: 2f0b                 move.l     a3, -(a7)
0756: 4ebaf94c             jsr        $a4(pc)
075a: 2440                 movea.l    d0, a2
075c: 200a                 move.l     a2, d0
075e: 508f                 addq.l     #$8, a7
0760: 670002a6             beq.w      $a08
0764: 4227                 clr.b      -(a7)
0766: 2f2efff4             move.l     -$c(a6), -(a7)
076a: 2f2c000a             move.l     $a(a4), -(a7)
076e: 3f05                 move.w     d5, -(a7)
0770: a83b                 dc.w       $a83b
0772: 4a1f                 tst.b      (a7)+
0774: 67000292             beq.w      $a08
0778: 3f05                 move.w     d5, -(a7)
077a: 2f2efff4             move.l     -$c(a6), -(a7)
077e: 4e92                 jsr        (a2)
0780: 5c8f                 addq.l     #$6, a7
0782: 60000284             bra.w      $a08
0786: 48780007             pea.l      $7.w
078a: 2f0b                 move.l     a3, -(a7)
078c: 4ebaf916             jsr        $a4(pc)
0790: 2440                 movea.l    d0, a2
0792: 200a                 move.l     a2, d0
0794: 508f                 addq.l     #$8, a7
0796: 67000270             beq.w      $a08
079a: 4227                 clr.b      -(a7)
079c: 2f2efff4             move.l     -$c(a6), -(a7)
07a0: 2f2c000a             move.l     $a(a4), -(a7)
07a4: a91e                 dc.w       $a91e
07a6: 4a1f                 tst.b      (a7)+
07a8: 6700025e             beq.w      $a08
07ac: 2f2efff4             move.l     -$c(a6), -(a7)
07b0: 4e92                 jsr        (a2)
07b2: 588f                 addq.l     #$4, a7
07b4: 60000252             bra.w      $a08
07b8: 3014                 move.w     (a4), d0
07ba: 0c40000f             cmpi.w     #$f, d0
07be: 62000248             bhi.w      $a08
07c2: 43fa024c             lea.l      $a10(pc), a1
07c6: d040                 add.w      d0, d0
07c8: d2f10000             adda.w     (a1, d0.w), a1
07cc: 4ed1                 jmp        (a1)
07ce: 082c0000000f         btst.b     #$0, $f(a4)
07d4: 6708                 beq.b      $7de
07d6: 4ead0622             jsr        $622(a5) ; CODE9+0c5e
07da: 6000022c             bra.w      $a08
07de: 4ead062a             jsr        $62a(a5) ; CODE9+0c84
07e2: 60000224             bra.w      $a08
07e6: 204d                 movea.l    a5, a0
07e8: 3014                 move.w     (a4), d0
07ea: 48c0                 ext.l      d0
07ec: e588                 lsl.l      #$2, d0
07ee: d1c0                 adda.l     d0, a0
07f0: 2c289322             move.l     -$6cde(a0), d6
07f4: 2f06                 move.l     d6, -(a7)
07f6: 4ebafd5c             jsr        $554(pc)
07fa: 2d40fff4             move.l     d0, -$c(a6)
07fe: 2e80                 move.l     d0, (a7)
0800: 4ebaf802             jsr        $4(pc)
0804: 2640                 movea.l    d0, a3
0806: 588f                 addq.l     #$4, a7
0808: 2f06                 move.l     d6, -(a7)
080a: 2f0b                 move.l     a3, -(a7)
080c: 4ebaf896             jsr        $a4(pc)
0810: 2440                 movea.l    d0, a2
0812: 200a                 move.l     a2, d0
0814: 508f                 addq.l     #$8, a7
0816: 670001f0             beq.w      $a08
081a: 2f0c                 move.l     a4, -(a7)
081c: 2f2efff4             move.l     -$c(a6), -(a7)
0820: 4e92                 jsr        (a2)
0822: 508f                 addq.l     #$8, a7
0824: 600001e2             bra.w      $a08
0828: 082c0000000e         btst.b     #$0, $e(a4)
082e: 6758                 beq.b      $888
0830: 0c540003             cmpi.w     #$3, (a4)
0834: 660001d2             bne.w      $a08
0838: 2d6d9364fff4         move.l     -$6c9c(a5), -$c(a6)
083e: 2f2efff4             move.l     -$c(a6), -(a7)
0842: 4ebaf7c0             jsr        $4(pc)
0846: 2640                 movea.l    d0, a3
0848: 0c2c002f0005         cmpi.b     #$2f, $5(a4)
084e: 588f                 addq.l     #$4, a7
0850: 660a                 bne.b      $85c
0852: 2e2d9360             move.l     -$6ca0(a5), d7
0856: 6600fe0a             bne.w      $662
085a: 6028                 bra.b      $884
085c: 2f0b                 move.l     a3, -(a7)
085e: 2f2efff4             move.l     -$c(a6), -(a7)
0862: 4ebafae2             jsr        $346(pc)
0866: 4297                 clr.l      (a7)
0868: 302c0004             move.w     $4(a4), d0
086c: 024000ff             andi.w     #$ff, d0
0870: 3f00                 move.w     d0, -(a7)
0872: a93e                 dc.w       $a93e
0874: 2e1f                 move.l     (a7)+, d7
0876: 4257                 clr.w      (a7)
0878: 2f07                 move.l     d7, -(a7)
087a: a86a                 dc.w       $a86a
087c: 4a5f                 tst.w      (a7)+
087e: 548f                 addq.l     #$2, a7
0880: 6600fde0             bne.w      $662
0884: 7c13                 moveq      #$13, d6
0886: 6080                 bra.b      $808
0888: 202c0002             move.l     $2(a4), d0
088c: 02800000ff00         andi.l     #$ff00, d0
0892: 5b80                 subq.l     #$5, d0
0894: 6612                 bne.b      $8a8
0896: 2d6d9364fff4         move.l     -$6c9c(a5), -$c(a6)
089c: 2e2d9360             move.l     -$6ca0(a5), d7
08a0: 6600fdc0             bne.w      $662
08a4: 60000162             bra.w      $a08
08a8: 7c0c                 moveq      #$c, d6
08aa: 6000ff48             bra.w      $7f4
08ae: 2d6c0002fff4         move.l     $2(a4), -$c(a6)
08b4: 2f2efff4             move.l     -$c(a6), -(a7)
08b8: a873                 dc.w       $a873
08ba: 2f2efff4             move.l     -$c(a6), -(a7)
08be: a922                 dc.w       $a922
08c0: 2f2efff4             move.l     -$c(a6), -(a7)
08c4: 4ead065a             jsr        $65a(a5) ; CODE9+0e84
08c8: 4a40                 tst.w      d0
08ca: 588f                 addq.l     #$4, a7
08cc: 6610                 bne.b      $8de
08ce: 2f2efff4             move.l     -$c(a6), -(a7)
08d2: 206efff4             movea.l    -$c(a6), a0
08d6: 2f280018             move.l     $18(a0), -(a7)
08da: a953                 dc.w       $a953
08dc: 6074                 bra.b      $952
08de: 2f2efff4             move.l     -$c(a6), -(a7)
08e2: 206efff4             movea.l    -$c(a6), a0
08e6: 2f280018             move.l     $18(a0), -(a7)
08ea: a978                 dc.w       $a978
08ec: 42a7                 clr.l      -(a7)
08ee: a8d8                 dc.w       $a8d8
08f0: 261f                 move.l     (a7)+, d3
08f2: 7801                 moveq      #$1, d4
08f4: 604a                 bra.b      $940
08f6: 2f2efff4             move.l     -$c(a6), -(a7)
08fa: 3f04                 move.w     d4, -(a7)
08fc: 486efff2             pea.l      -$e(a6)
0900: 486effdc             pea.l      -$24(a6)
0904: 486effe0             pea.l      -$20(a6)
0908: a98d                 dc.w       $a98d
090a: 082e0002fff3         btst.b     #$2, -$d(a6)
0910: 662c                 bne.b      $93e
0912: 082e0004fff3         btst.b     #$4, -$d(a6)
0918: 670c                 beq.b      $926
091a: 486effe0             pea.l      -$20(a6)
091e: 2f3cfffcfffc         move.l     #$fffcfffc, -(a7)
0924: a8a9                 dc.w       $a8a9
0926: 2f03                 move.l     d3, -(a7)
0928: 486effe0             pea.l      -$20(a6)
092c: a8df                 dc.w       $a8df
092e: 206efff4             movea.l    -$c(a6), a0
0932: 2f280018             move.l     $18(a0), -(a7)
0936: 2f03                 move.l     d3, -(a7)
0938: 2f280018             move.l     $18(a0), -(a7)
093c: a8e6                 dc.w       $a8e6
093e: 5244                 addq.w     #$1, d4
0940: 206efff4             movea.l    -$c(a6), a0
0944: 2068009c             movea.l    $9c(a0), a0
0948: 2050                 movea.l    (a0), a0
094a: b850                 cmp.w      (a0), d4
094c: 6fa8                 ble.b      $8f6
094e: 2f03                 move.l     d3, -(a7)
0950: a8d9                 dc.w       $a8d9
0952: 206efff4             movea.l    -$c(a6), a0
0956: 4aa8008c             tst.l      $8c(a0)
095a: 6770                 beq.b      $9cc
095c: 42a7                 clr.l      -(a7)
095e: a8d8                 dc.w       $a8d8
0960: 2d5ffffc             move.l     (a7)+, -$4(a6)
0964: 206efff4             movea.l    -$c(a6), a0
0968: 2d68008cfff8         move.l     $8c(a0), -$8(a6)
096e: 6050                 bra.b      $9c0
0970: 206efff8             movea.l    -$8(a6), a0
0974: a029                 dc.w       $a029
0976: 206efff8             movea.l    -$8(a6), a0
097a: 2050                 movea.l    (a0), a0
097c: 4a280010             tst.b      $10(a0)
0980: 660c                 bne.b      $98e
0982: 206efff8             movea.l    -$8(a6), a0
0986: 2050                 movea.l    (a0), a0
0988: 48680008             pea.l      $8(a0)
098c: a8a3                 dc.w       $a8a3
098e: 2f2efffc             move.l     -$4(a6), -(a7)
0992: 206efff8             movea.l    -$8(a6), a0
0996: 2050                 movea.l    (a0), a0
0998: 48680008             pea.l      $8(a0)
099c: a8df                 dc.w       $a8df
099e: 206efff8             movea.l    -$8(a6), a0
09a2: a02a                 dc.w       $a02a
09a4: 206efff4             movea.l    -$c(a6), a0
09a8: 2f280018             move.l     $18(a0), -(a7)
09ac: 2f2efffc             move.l     -$4(a6), -(a7)
09b0: 2f280018             move.l     $18(a0), -(a7)
09b4: a8e6                 dc.w       $a8e6
09b6: 206efff8             movea.l    -$8(a6), a0
09ba: 2050                 movea.l    (a0), a0
09bc: 2d50fff8             move.l     (a0), -$8(a6)
09c0: 4aaefff8             tst.l      -$8(a6)
09c4: 66aa                 bne.b      $970
09c6: 2f2efffc             move.l     -$4(a6), -(a7)
09ca: a8d9                 dc.w       $a8d9
09cc: 48780003             pea.l      $3.w
09d0: 2f2efff4             move.l     -$c(a6), -(a7)
09d4: 4ebaf62e             jsr        $4(pc)
09d8: 2e80                 move.l     d0, (a7)
09da: 4ebaf6c8             jsr        $a4(pc)
09de: 2440                 movea.l    d0, a2
09e0: 200a                 move.l     a2, d0
09e2: 508f                 addq.l     #$8, a7
09e4: 6708                 beq.b      $9ee
09e6: 2f2efff4             move.l     -$c(a6), -(a7)
09ea: 4e92                 jsr        (a2)
09ec: 588f                 addq.l     #$4, a7
09ee: 2f2efff4             move.l     -$c(a6), -(a7)
09f2: a923                 dc.w       $a923
09f4: 6012                 bra.b      $a08
09f6: 2d6c0002fff4         move.l     $2(a4), -$c(a6)
09fc: 2f0c                 move.l     a4, -(a7)
09fe: 2f2c0002             move.l     $2(a4), -(a7)
0a02: 4ebaf80e             jsr        $212(pc)
0a06: 508f                 addq.l     #$8, a7
0a08: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0a0c: 4e5e                 unlk       a6
0a0e: 4e75                 rts        
0a10: fff8                 dc.w       $fff8
0a12: fff8                 dc.w       $fff8
0a14: fdd6                 dc.w       $fdd6
0a16: fe18fdd6             fmovem     invalid, (a0)+
0a1a: fe18fe9e             fmovem     invalid, (a0)+
0a1e: fdd6                 dc.w       $fdd6
0a20: ffe6                 dc.w       $ffe6
0a22: fff8                 dc.w       $fff8
0a24: fdd6                 dc.w       $fdd6
0a26: fdd6                 dc.w       $fdd6
0a28: fdd6                 dc.w       $fdd6
0a2a: fdd6                 dc.w       $fdd6
0a2c: fdd6                 dc.w       $fdd6
0a2e: fdbe                 dc.w       $fdbe
0a30: fc14fc1a             fmovem     invalid, (a4)
0a34: fc02fc6a             fmovem     invalid, d2
0a38: fc0efd0a             fmovem     invalid, a6
0a3c: fd56                 frestore   (a6)
0a3e: fd20                 fsave      -(a0)
0a40: fd20                 fsave      -(a0)
0a42: 4e560000             link.w     a6, #$0
0a46: 0c6d0008a386         cmpi.w     #$8, -$5c7a(a5)
0a4c: 6406                 bcc.b      $a54
0a4e: 4a6da386             tst.w      -$5c7a(a5)
0a52: 6c04                 bge.b      $a58
0a54: 4eba0712             jsr        $1168(pc)
0a58: 302da386             move.w     -$5c7a(a5), d0
0a5c: 526da386             addq.w     #$1, -$5c7a(a5)
0a60: c1fc002c             muls.w     #$2c, d0
0a64: 41eda226             lea.l      -$5dda(a5), a0
0a68: d088                 add.l      a0, d0
0a6a: 2040                 movea.l    d0, a0
0a6c: 7000                 moveq      #$0, d0
0a6e: 43fa0006             lea.l      $a76(pc), a1
0a72: 48d0def8             movem.l    d3-d7/a1-a4/a6-a7, (a0)
0a76: 4a40                 tst.w      d0
0a78: 6610                 bne.b      $a8a
0a7a: 2f2e0008             move.l     $8(a6), -(a7)
0a7e: 4ebafb6e             jsr        $5ee(pc)
0a82: 536da386             subq.w     #$1, -$5c7a(a5)
0a86: 588f                 addq.l     #$4, a7
0a88: 6048                 bra.b      $ad2
0a8a: 2f2da222             move.l     -$5dde(a5), -(a7)
0a8e: 2f2d93ac             move.l     -$6c54(a5), -(a7)
0a92: 4ead0db2             jsr        $db2(a5) ; CODE52+0242
0a96: 4a40                 tst.w      d0
0a98: 508f                 addq.l     #$8, a7
0a9a: 6606                 bne.b      $aa2
0a9c: 4267                 clr.w      -(a7)
0a9e: a938                 dc.w       $a938
0aa0: 6030                 bra.b      $ad2
0aa2: 4a6da386             tst.w      -$5c7a(a5)
0aa6: 6e04                 bgt.b      $aac
0aa8: 4eba06be             jsr        $1168(pc)
0aac: 2b6da222a222         move.l     -$5dde(a5), -$5dde(a5)
0ab2: 536da386             subq.w     #$1, -$5c7a(a5)
0ab6: 702c                 moveq      #$2c, d0
0ab8: c1eda386             muls.w     -$5c7a(a5), d0
0abc: 41eda226             lea.l      -$5dda(a5), a0
0ac0: d088                 add.l      a0, d0
0ac2: 2040                 movea.l    d0, a0
0ac4: 7001                 moveq      #$1, d0
0ac6: 4a40                 tst.w      d0
0ac8: 6602                 bne.b      $acc
0aca: 7001                 moveq      #$1, d0
0acc: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
0ad0: 4ed1                 jmp        (a1)
0ad2: 4e5e                 unlk       a6
0ad4: 4e75                 rts        
0ad6: 4e56fff0             link.w     a6, #$fff0
0ada: 600e                 bra.b      $aea
0adc: 486efff0             pea.l      -$10(a6)
0ae0: 3f2e0008             move.w     $8(a6), -(a7)
0ae4: 4eba0072             jsr        $b58(pc)
0ae8: 5c8f                 addq.l     #$6, a7
0aea: 4227                 clr.b      -(a7)
0aec: 3f2e0008             move.w     $8(a6), -(a7)
0af0: 486efff0             pea.l      -$10(a6)
0af4: a971                 dc.w       $a971
0af6: 4a1f                 tst.b      (a7)+
0af8: 66e2                 bne.b      $adc
0afa: 4e5e                 unlk       a6
0afc: 4e75                 rts        
0afe: 4e560000             link.w     a6, #$0
0b02: 48e70038             movem.l    a2-a4, -(a7)
0b06: 2f2e0008             move.l     $8(a6), -(a7)
0b0a: 4ebaf4f8             jsr        $4(pc)
0b0e: 2840                 movea.l    d0, a4
0b10: 97cb                 suba.l     a3, a3
0b12: 7011                 moveq      #$11, d0
0b14: 2e80                 move.l     d0, (a7)
0b16: 2f0c                 move.l     a4, -(a7)
0b18: 4ebaf58a             jsr        $a4(pc)
0b1c: 2440                 movea.l    d0, a2
0b1e: 200a                 move.l     a2, d0
0b20: 508f                 addq.l     #$8, a7
0b22: 670e                 beq.b      $b32
0b24: 2f2e000c             move.l     $c(a6), -(a7)
0b28: 2f2e0008             move.l     $8(a6), -(a7)
0b2c: 4e92                 jsr        (a2)
0b2e: 2640                 movea.l    d0, a3
0b30: 508f                 addq.l     #$8, a7
0b32: 2f2e000c             move.l     $c(a6), -(a7)
0b36: 4ead0c0a             jsr        $c0a(a5) ; CODE46+0616
0b3a: 2840                 movea.l    d0, a4
0b3c: 200b                 move.l     a3, d0
0b3e: 588f                 addq.l     #$4, a7
0b40: 6602                 bne.b      $b44
0b42: 264c                 movea.l    a4, a3
0b44: 200b                 move.l     a3, d0
0b46: 6604                 bne.b      $b4c
0b48: 47edfa5e             lea.l      -$5a2(a5), a3
0b4c: 2f0b                 move.l     a3, -(a7)
0b4e: a851                 dc.w       $a851
0b50: 4cdf1c00             movem.l    (a7)+, a2-a4
0b54: 4e5e                 unlk       a6
0b56: 4e75                 rts        
0b58: 4e56fffe             link.w     a6, #$fffe
0b5c: 48e70018             movem.l    a3-a4, -(a7)
0b60: 286e000a             movea.l    $a(a6), a4
0b64: a9b4                 dc.w       $a9b4
0b66: 4227                 clr.b      -(a7)
0b68: 3f2e0008             move.w     $8(a6), -(a7)
0b6c: 2f0c                 move.l     a4, -(a7)
0b6e: a970                 dc.w       $a970
0b70: 4a1f                 tst.b      (a7)+
0b72: 6708                 beq.b      $b7c
0b74: 2f0c                 move.l     a4, -(a7)
0b76: 4ebafeca             jsr        $a42(pc)
0b7a: 588f                 addq.l     #$4, a7
0b7c: 0c540008             cmpi.w     #$8, (a4)
0b80: 665a                 bne.b      $bdc
0b82: 4ead0c42             jsr        $c42(a5) ; CODE46+0a2a
0b86: 2640                 movea.l    d0, a3
0b88: 2f0b                 move.l     a3, -(a7)
0b8a: 4ead064a             jsr        $64a(a5) ; CODE9+0e30
0b8e: 4a40                 tst.w      d0
0b90: 588f                 addq.l     #$4, a7
0b92: 6714                 beq.b      $ba8
0b94: 0c6d0001935e         cmpi.w     #$1, -$6ca2(a5)
0b9a: 6754                 beq.b      $bf0
0b9c: 4ead0622             jsr        $622(a5) ; CODE9+0c5e
0ba0: 3b7c0001935e         move.w     #$1, -$6ca2(a5)
0ba6: 6048                 bra.b      $bf0
0ba8: 200b                 move.l     a3, d0
0baa: 6610                 bne.b      $bbc
0bac: 4a6d935e             tst.w      -$6ca2(a5)
0bb0: 673e                 beq.b      $bf0
0bb2: 4ead062a             jsr        $62a(a5) ; CODE9+0c84
0bb6: 426d935e             clr.w      -$6ca2(a5)
0bba: 6034                 bra.b      $bf0
0bbc: 2f0b                 move.l     a3, -(a7)
0bbe: 4ead0652             jsr        $652(a5) ; CODE9+0e54
0bc2: 4a40                 tst.w      d0
0bc4: 588f                 addq.l     #$4, a7
0bc6: 6728                 beq.b      $bf0
0bc8: 0c6d0002935e         cmpi.w     #$2, -$6ca2(a5)
0bce: 6720                 beq.b      $bf0
0bd0: 4ead062a             jsr        $62a(a5) ; CODE9+0c84
0bd4: 3b7c0002935e         move.w     #$2, -$6ca2(a5)
0bda: 6014                 bra.b      $bf0
0bdc: 4ead0c42             jsr        $c42(a5) ; CODE46+0a2a
0be0: 2640                 movea.l    d0, a3
0be2: 200b                 move.l     a3, d0
0be4: 670a                 beq.b      $bf0
0be6: 2f0c                 move.l     a4, -(a7)
0be8: 2f0b                 move.l     a3, -(a7)
0bea: 4ebaff12             jsr        $afe(pc)
0bee: 508f                 addq.l     #$8, a7
0bf0: 4cdf1800             movem.l    (a7)+, a3-a4
0bf4: 4e5e                 unlk       a6
0bf6: 4e75                 rts        
0bf8: 4e56fffc             link.w     a6, #$fffc
0bfc: 48e70018             movem.l    a3-a4, -(a7)
0c00: 286e0008             movea.l    $8(a6), a4
0c04: 2f0c                 move.l     a4, -(a7)
0c06: 3f2e000c             move.w     $c(a6), -(a7)
0c0a: a95d                 dc.w       $a95d
0c0c: 43eefffc             lea.l      -$4(a6), a1
0c10: 307c0002             movea.w    #$2, a0
0c14: a03b                 dc.w       $a03b
0c16: 2280                 move.l     d0, (a1)
0c18: 48780015             pea.l      $15.w
0c1c: 42a7                 clr.l      -(a7)
0c1e: 2f0c                 move.l     a4, -(a7)
0c20: a95a                 dc.w       $a95a
0c22: 4ebaf480             jsr        $a4(pc)
0c26: 2640                 movea.l    d0, a3
0c28: 4257                 clr.w      (a7)
0c2a: 2f0c                 move.l     a4, -(a7)
0c2c: 4e93                 jsr        (a3)
0c2e: 2e8c                 move.l     a4, (a7)
0c30: 4267                 clr.w      -(a7)
0c32: a95d                 dc.w       $a95d
0c34: 4cee1800fff4         movem.l    -$c(a6), a3-a4
0c3a: 4e5e                 unlk       a6
0c3c: 4e75                 rts        
0c3e: 4e56fff0             link.w     a6, #$fff0
0c42: 2b78016aa38e         move.l     $16a.w, -$5c72(a5)
0c48: 422da388             clr.b      -$5c78(a5)
0c4c: 486efff0             pea.l      -$10(a6)
0c50: 3f3cffff             move.w     #$ffff, -(a7)
0c54: 4ebaff02             jsr        $b58(pc)
0c58: 4e5e                 unlk       a6
0c5a: 4e75                 rts        
0c5c: 4e560000             link.w     a6, #$0
0c60: 48e70018             movem.l    a3-a4, -(a7)
0c64: 286e0008             movea.l    $8(a6), a4
0c68: 264c                 movea.l    a4, a3
0c6a: d7ee000c             adda.l     $c(a6), a3
0c6e: 6002                 bra.b      $c72
0c70: 421c                 clr.b      (a4)+
0c72: b7cc                 cmpa.l     a4, a3
0c74: 62fa                 bhi.b      $c70
0c76: 4cdf1800             movem.l    (a7)+, a3-a4
0c7a: 4e5e                 unlk       a6
0c7c: 4e75                 rts        
0c7e: 4e56fee6             link.w     a6, #$fee6
0c82: 0c6d0008a386         cmpi.w     #$8, -$5c7a(a5)
0c88: 6406                 bcc.b      $c90
0c8a: 4a6da386             tst.w      -$5c7a(a5)
0c8e: 6c04                 bge.b      $c94
0c90: 4eba04d6             jsr        $1168(pc)
0c94: 302da386             move.w     -$5c7a(a5), d0
0c98: 526da386             addq.w     #$1, -$5c7a(a5)
0c9c: c1fc002c             muls.w     #$2c, d0
0ca0: 41eda226             lea.l      -$5dda(a5), a0
0ca4: d088                 add.l      a0, d0
0ca6: 2040                 movea.l    d0, a0
0ca8: 7000                 moveq      #$0, d0
0caa: 43fa0006             lea.l      $cb2(pc), a1
0cae: 48d0def8             movem.l    d3-d7/a1-a4/a6-a7, (a0)
0cb2: 4a40                 tst.w      d0
0cb4: 66000084             bne.w      $d3a
0cb8: 4ead030a             jsr        $30a(a5) ; CODE15+04d2
0cbc: 486efffe             pea.l      -$2(a6)
0cc0: 486efffc             pea.l      -$4(a6)
0cc4: 4ead0b8a             jsr        $b8a(a5) ; CODE34+03e4
0cc8: 3d7c0001fffa         move.w     #$1, -$6(a6)
0cce: 6036                 bra.b      $d06
0cd0: 3f2efffa             move.w     -$6(a6), -(a7)
0cd4: 486efef2             pea.l      -$10e(a6)
0cd8: 4ead0b92             jsr        $b92(a5) ; CODE34+0408
0cdc: 0cae58474d45fef4     cmpi.l     #$58474d45, -$10c(a6)
0ce4: 6614                 bne.b      $cfa
0ce6: 486efefa             pea.l      -$106(a6)
0cea: 3f2efef2             move.w     -$10e(a6), -(a7)
0cee: 4ead05aa             jsr        $5aa(a5) ; CODE22+02cc
0cf2: 0c6e0001fffe         cmpi.w     #$1, -$2(a6)
0cf8: 5c8f                 addq.l     #$6, a7
0cfa: 3f2efffa             move.w     -$6(a6), -(a7)
0cfe: 4ead0b9a             jsr        $b9a(a5) ; CODE34+044e
0d02: 526efffa             addq.w     #$1, -$6(a6)
0d06: 302efffa             move.w     -$6(a6), d0
0d0a: b06efffc             cmp.w      -$4(a6), d0
0d0e: 6fc0                 ble.b      $cd0
0d10: 0c6e0001fffe         cmpi.w     #$1, -$2(a6)
0d16: 671c                 beq.b      $d34
0d18: 4eba03d4             jsr        $10ee(pc)
0d1c: 2f2dde78             move.l     -$2188(a5), -(a7)
0d20: a9aa                 dc.w       $a9aa
0d22: 4267                 clr.w      -(a7)
0d24: a9af                 dc.w       $a9af
0d26: 4a5f                 tst.w      (a7)+
0d28: 6704                 beq.b      $d2e
0d2a: 4eba043c             jsr        $1168(pc)
0d2e: 4267                 clr.w      -(a7)
0d30: a994                 dc.w       $a994
0d32: a999                 dc.w       $a999
0d34: 536da386             subq.w     #$1, -$5c7a(a5)
0d38: 600a                 bra.b      $d44
0d3a: 2f2da222             move.l     -$5dde(a5), -(a7)
0d3e: 4ead0c7a             jsr        $c7a(a5) ; CODE41+0238
0d42: 588f                 addq.l     #$4, a7
0d44: 4ead0662             jsr        $662(a5) ; CODE9+0ea8
0d48: 4e5e                 unlk       a6
0d4a: 4e75                 rts        
0d4c: 486d0ac2             pea.l      $ac2(a5)
0d50: a9f1                 dc.w       $a9f1
0d52: 486d0a92             pea.l      $a92(a5)
0d56: a9f1                 dc.w       $a9f1
0d58: 486d0aa2             pea.l      $aa2(a5)
0d5c: a9f1                 dc.w       $a9f1
0d5e: 486d0822             pea.l      $822(a5)
0d62: a9f1                 dc.w       $a9f1
0d64: 486d0862             pea.l      $862(a5)
0d68: a9f1                 dc.w       $a9f1
0d6a: 486d08b2             pea.l      $8b2(a5)
0d6e: a9f1                 dc.w       $a9f1
0d70: 486d0aea             pea.l      $aea(a5)
0d74: a9f1                 dc.w       $a9f1
0d76: 486d0a7a             pea.l      $a7a(a5)
0d7a: a9f1                 dc.w       $a9f1
0d7c: 486d0a1a             pea.l      $a1a(a5)
0d80: a9f1                 dc.w       $a9f1
0d82: 486d0d72             pea.l      $d72(a5)
0d86: a9f1                 dc.w       $a9f1
0d88: 486d0a3a             pea.l      $a3a(a5)
0d8c: a9f1                 dc.w       $a9f1
0d8e: 486d0a52             pea.l      $a52(a5)
0d92: a9f1                 dc.w       $a9f1
0d94: 486d0912             pea.l      $912(a5)
0d98: a9f1                 dc.w       $a9f1
0d9a: 486d0842             pea.l      $842(a5)
0d9e: a9f1                 dc.w       $a9f1
0da0: 486d098a             pea.l      $98a(a5)
0da4: a9f1                 dc.w       $a9f1
0da6: 4e75                 rts        
0da8: 4e56ff80             link.w     a6, #$ff80
0dac: 4ebaff9e             jsr        $d4c(pc)
0db0: 486d0d7a             pea.l      $d7a(a5)
0db4: a9f1                 dc.w       $a9f1
0db6: 486d0c62             pea.l      $c62(a5)
0dba: a9f1                 dc.w       $a9f1
0dbc: 486d09f2             pea.l      $9f2(a5)
0dc0: a9f1                 dc.w       $a9f1
0dc2: 486d0df2             pea.l      $df2(a5)
0dc6: a9f1                 dc.w       $a9f1
0dc8: 486d00c2             pea.l      $c2(a5)
0dcc: a9f1                 dc.w       $a9f1
0dce: 486d0082             pea.l      $82(a5)
0dd2: a9f1                 dc.w       $a9f1
0dd4: 486d0582             pea.l      $582(a5)
0dd8: a9f1                 dc.w       $a9f1
0dda: 486d059a             pea.l      $59a(a5)
0dde: a9f1                 dc.w       $a9f1
0de0: 486d0362             pea.l      $362(a5)
0de4: a9f1                 dc.w       $a9f1
0de6: 486d0c6a             pea.l      $c6a(a5)
0dea: a9f1                 dc.w       $a9f1
0dec: 486d05b2             pea.l      $5b2(a5)
0df0: a9f1                 dc.w       $a9f1
0df2: 486d0c22             pea.l      $c22(a5)
0df6: a9f1                 dc.w       $a9f1
0df8: 486d0812             pea.l      $812(a5)
0dfc: a9f1                 dc.w       $a9f1
0dfe: 486d0312             pea.l      $312(a5)
0e02: a9f1                 dc.w       $a9f1
0e04: 486d030a             pea.l      $30a(a5)
0e08: a9f1                 dc.w       $a9f1
0e0a: 486d0242             pea.l      $242(a5)
0e0e: a9f1                 dc.w       $a9f1
0e10: 486d02c2             pea.l      $2c2(a5)
0e14: a9f1                 dc.w       $a9f1
0e16: 486d0a4a             pea.l      $a4a(a5)
0e1a: a9f1                 dc.w       $a9f1
0e1c: 486d027a             pea.l      $27a(a5)
0e20: a9f1                 dc.w       $a9f1
0e22: 486d0d22             pea.l      $d22(a5)
0e26: a9f1                 dc.w       $a9f1
0e28: 486d0342             pea.l      $342(a5)
0e2c: a9f1                 dc.w       $a9f1
0e2e: 486d05ea             pea.l      $5ea(a5)
0e32: a9f1                 dc.w       $a9f1
0e34: 486d0d12             pea.l      $d12(a5)
0e38: a9f1                 dc.w       $a9f1
0e3a: 486d0dda             pea.l      $dda(a5)
0e3e: a9f1                 dc.w       $a9f1
0e40: 486d0dca             pea.l      $dca(a5)
0e44: a9f1                 dc.w       $a9f1
0e46: 486d0da2             pea.l      $da2(a5)
0e4a: a9f1                 dc.w       $a9f1
0e4c: 486d0d82             pea.l      $d82(a5)
0e50: a9f1                 dc.w       $a9f1
0e52: 486d0482             pea.l      $482(a5)
0e56: a9f1                 dc.w       $a9f1
0e58: 486d00f2             pea.l      $f2(a5)
0e5c: a9f1                 dc.w       $a9f1
0e5e: 486d0d62             pea.l      $d62(a5)
0e62: a9f1                 dc.w       $a9f1
0e64: 486d0412             pea.l      $412(a5)
0e68: a9f1                 dc.w       $a9f1
0e6a: 486d0742             pea.l      $742(a5)
0e6e: a9f1                 dc.w       $a9f1
0e70: 486d07da             pea.l      $7da(a5)
0e74: a9f1                 dc.w       $a9f1
0e76: 486d0dfa             pea.l      $dfa(a5)
0e7a: a9f1                 dc.w       $a9f1
0e7c: 486d00a2             pea.l      $a2(a5)
0e80: a9f1                 dc.w       $a9f1
0e82: 486d011a             pea.l      $11a(a5)
0e86: a9f1                 dc.w       $a9f1
0e88: 486d0172             pea.l      $172(a5)
0e8c: a9f1                 dc.w       $a9f1
0e8e: 486d0182             pea.l      $182(a5)
0e92: a9f1                 dc.w       $a9f1
0e94: 486d0caa             pea.l      $caa(a5)
0e98: a9f1                 dc.w       $a9f1
0e9a: 486d0372             pea.l      $372(a5)
0e9e: a9f1                 dc.w       $a9f1
0ea0: 302dde66             move.w     -$219a(a5), d0
0ea4: 5740                 subq.w     #$3, d0
0ea6: 0c400005             cmpi.w     #$5, d0
0eaa: 62000232             bhi.w      $10de
0eae: 43fa0232             lea.l      $10e2(pc), a1
0eb2: d040                 add.w      d0, d0
0eb4: d2f10000             adda.w     (a1, d0.w), a1
0eb8: 4ed1                 jmp        (a1)
0eba: 486df2bc             pea.l      -$d44(a5)
0ebe: a851                 dc.w       $a851
0ec0: 4ead0412             jsr        $412(a5) ; CODE20+0004
0ec4: 42adc372             clr.l      -$3c8e(a5)
0ec8: 42adc36e             clr.l      -$3c92(a5)
0ecc: 7000                 moveq      #$0, d0
0ece: 1b40c366             move.b     d0, -$3c9a(a5)
0ed2: 1b40c35e             move.b     d0, -$3ca2(a5)
0ed6: 4880                 ext.w      d0
0ed8: 3b40b3f2             move.w     d0, -$4c0e(a5)
0edc: 4ead04ea             jsr        $4ea(a5) ; CODE21+1310
0ee0: 4ead00ea             jsr        $ea(a5) ; CODE6+0212
0ee4: 486dc35e             pea.l      -$3ca2(a5)
0ee8: 4ead0582             jsr        $582(a5) ; CODE22+048a
0eec: 486dc366             pea.l      -$3c9a(a5)
0ef0: 4ead0582             jsr        $582(a5) ; CODE22+048a
0ef4: 4ead0552             jsr        $552(a5) ; CODE21+0052
0ef8: a850                 dc.w       $a850
0efa: 4ead0122             jsr        $122(a5) ; CODE7+0656
0efe: 42adde56             clr.l      -$21aa(a5)
0f02: 41edc35e             lea.l      -$3ca2(a5), a0
0f06: b1edc376             cmpa.l     -$3c8a(a5), a0
0f0a: 508f                 addq.l     #$8, a7
0f0c: 6604                 bne.b      $f12
0f0e: 7002                 moveq      #$2, d0
0f10: 6002                 bra.b      $f14
0f12: 7003                 moveq      #$3, d0
0f14: 3b40de64             move.w     d0, -$219c(a5)
0f18: 48780058             pea.l      $58.w
0f1c: 486da498             pea.l      -$5b68(a5)
0f20: 4ebafd3a             jsr        $c5c(pc)
0f24: 7058                 moveq      #$58, d0
0f26: 2e80                 move.l     d0, (a7)
0f28: 486da4f0             pea.l      -$5b10(a5)
0f2c: 4ebafd2e             jsr        $c5c(pc)
0f30: 4fef000c             lea.l      $c(a7), a7
0f34: 600001a8             bra.w      $10de
0f38: 2b78016ade5a         move.l     $16a.w, -$21a6(a5)
0f3e: 48780022             pea.l      $22.w
0f42: 486da5ce             pea.l      -$5a32(a5)
0f46: 4ebafd14             jsr        $c5c(pc)
0f4a: 7008                 moveq      #$8, d0
0f4c: 2e80                 move.l     d0, (a7)
0f4e: 486da74e             pea.l      -$58b2(a5)
0f52: 4ebafd08             jsr        $c5c(pc)
0f56: 4fef000c             lea.l      $c(a7), a7
0f5a: 60000182             bra.w      $10de
0f5e: 41ed0172             lea.l      $172(a5), a0
0f62: 2b48b3ee             move.l     a0, -$4c12(a5)
0f66: 2f2dc376             move.l     -$3c8a(a5), -(a7)
0f6a: 4ead096a             jsr        $96a(a5) ; CODE31+0992
0f6e: 4ead0982             jsr        $982(a5) ; CODE32+115c
0f72: 202dc372             move.l     -$3c8e(a5), d0
0f76: d0ada5de             add.l      -$5a22(a5), d0
0f7a: 2e80                 move.l     d0, (a7)
0f7c: 486da5ce             pea.l      -$5a32(a5)
0f80: 486dded6             pea.l      -$212a(a5)
0f84: 4ead013a             jsr        $13a(a5) ; CODE7+0930
0f88: 202da5de             move.l     -$5a22(a5), d0
0f8c: d1adc372             add.l      d0, -$3c8e(a5)
0f90: 4ead04ea             jsr        $4ea(a5) ; CODE21+1310
0f94: 3ebc0001             move.w     #$1, (a7)
0f98: 2f2dc376             move.l     -$3c8a(a5), -(a7)
0f9c: 486da5ce             pea.l      -$5a32(a5)
0fa0: 4ead0942             jsr        $942(a5) ; CODE31+0184
0fa4: 486da498             pea.l      -$5b68(a5)
0fa8: 486da440             pea.l      -$5bc0(a5)
0fac: 4ead034a             jsr        $34a(a5) ; CODE16+0004
0fb0: 42adb3ee             clr.l      -$4c12(a5)
0fb4: 2eadc376             move.l     -$3c8a(a5), (a7)
0fb8: 4ead0582             jsr        $582(a5) ; CODE22+048a
0fbc: 4ead0552             jsr        $552(a5) ; CODE21+0052
0fc0: 41edc35e             lea.l      -$3ca2(a5), a0
0fc4: 2b48c376             move.l     a0, -$3c8a(a5)
0fc8: 4ead0292             jsr        $292(a5) ; CODE14+0318
0fcc: 4297                 clr.l      (a7)
0fce: 486da5ce             pea.l      -$5a32(a5)
0fd2: 4ead016a             jsr        $16a(a5) ; CODE8+0718
0fd6: 4ead092a             jsr        $92a(a5) ; CODE31+00b2
0fda: 4a40                 tst.w      d0
0fdc: 4fef0020             lea.l      $20(a7), a7
0fe0: 6704                 beq.b      $fe6
0fe2: 7004                 moveq      #$4, d0
0fe4: 6002                 bra.b      $fe8
0fe6: 7002                 moveq      #$2, d0
0fe8: 3b40de64             move.w     d0, -$219c(a5)
0fec: 48780022             pea.l      $22.w
0ff0: 486da5ce             pea.l      -$5a32(a5)
0ff4: 4ebafc66             jsr        $c5c(pc)
0ff8: 508f                 addq.l     #$8, a7
0ffa: 600000e2             bra.w      $10de
0ffe: 41edc35e             lea.l      -$3ca2(a5), a0
1002: b1edc376             cmpa.l     -$3c8a(a5), a0
1006: 6704                 beq.b      $100c
1008: 4eba015e             jsr        $1168(pc)
100c: 41ed01ca             lea.l      $1ca(a5), a0
1010: 2b48a38a             move.l     a0, -$5c76(a5)
1014: 4ebafc28             jsr        $c3e(pc)
1018: 426dde64             clr.w      -$219c(a5)
101c: 48780078             pea.l      $78.w
1020: 2f2dc376             move.l     -$3c8a(a5), -(a7)
1024: 4ead028a             jsr        $28a(a5) ; CODE13+00b2
1028: 2040                 movea.l    d0, a0
102a: 43eda5ce             lea.l      -$5a32(a5), a1
102e: 7007                 moveq      #$7, d0
1030: 22d8                 move.l     (a0)+, (a1)+
1032: 51c8fffc             dbra       d0, $1030
1036: 32d8                 move.w     (a0)+, (a1)+
1038: 42ada38a             clr.l      -$5c76(a5)
103c: 202da5de             move.l     -$5a22(a5), d0
1040: d1adc36e             add.l      d0, -$3c92(a5)
1044: 4ead04ea             jsr        $4ea(a5) ; CODE21+1310
1048: 2eadc36e             move.l     -$3c92(a5), (a7)
104c: 486da5ce             pea.l      -$5a32(a5)
1050: 486ddef0             pea.l      -$2110(a5)
1054: 4ead013a             jsr        $13a(a5) ; CODE7+0930
1058: 3ebc0001             move.w     #$1, (a7)
105c: 2f2dc376             move.l     -$3c8a(a5), -(a7)
1060: 486da5ce             pea.l      -$5a32(a5)
1064: 4ead0942             jsr        $942(a5) ; CODE31+0184
1068: 486da4f0             pea.l      -$5b10(a5)
106c: 486da440             pea.l      -$5bc0(a5)
1070: 4ead034a             jsr        $34a(a5) ; CODE16+0004
1074: 2eadc376             move.l     -$3c8a(a5), (a7)
1078: 4ead0582             jsr        $582(a5) ; CODE22+048a
107c: 41edc366             lea.l      -$3c9a(a5), a0
1080: 2b48c376             move.l     a0, -$3c8a(a5)
1084: 4ead0292             jsr        $292(a5) ; CODE14+0318
1088: 2ebc00010001         move.l     #$10001, (a7)
108e: 486da5ce             pea.l      -$5a32(a5)
1092: 4ead016a             jsr        $16a(a5) ; CODE8+0718
1096: 4ead092a             jsr        $92a(a5) ; CODE31+00b2
109a: 4a40                 tst.w      d0
109c: 4fef0024             lea.l      $24(a7), a7
10a0: 6704                 beq.b      $10a6
10a2: 7004                 moveq      #$4, d0
10a4: 6002                 bra.b      $10a8
10a6: 7003                 moveq      #$3, d0
10a8: 3b40de64             move.w     d0, -$219c(a5)
10ac: 6030                 bra.b      $10de
10ae: 4ead015a             jsr        $15a(a5) ; CODE7+03a4
10b2: 42adc376             clr.l      -$3c8a(a5)
10b6: 3b7c0005de64         move.w     #$5, -$219c(a5)
10bc: 4ead011a             jsr        $11a(a5) ; CODE7+05ea
10c0: 4a40                 tst.w      d0
10c2: 670e                 beq.b      $10d2
10c4: 2f2dc36e             move.l     -$3c92(a5), -(a7)
10c8: 2f2dc372             move.l     -$3c8e(a5), -(a7)
10cc: 4ead0dfa             jsr        $dfa(a5) ; CODE50+0004
10d0: 508f                 addq.l     #$8, a7
10d2: 42a7                 clr.l      -(a7)
10d4: 2f2ddec2             move.l     -$213e(a5), -(a7)
10d8: 4ead04c2             jsr        $4c2(a5) ; CODE21+30f4
10dc: 508f                 addq.l     #$8, a7
10de: 4e5e                 unlk       a6
10e0: 4e75                 rts        
10e2: fdd8                 dc.w       $fdd8
10e4: ff1c                 dc.w       $ff1c
10e6: fe56ffcc             fsult.b    (a6)
10ea: fe7cfe5c             ftrapult   
10ee: 3b7c0001de66         move.w     #$1, -$219a(a5)
10f4: 4ebafcb2             jsr        $da8(pc)
10f8: 4a6dde64             tst.w      -$219c(a5)
10fc: 660c                 bne.b      $110a
10fe: 4ebafb3e             jsr        $c3e(pc)
1102: 4eba001c             jsr        $1120(pc)
1106: 4a40                 tst.w      d0
1108: 67f4                 beq.b      $10fe
110a: 4eba0014             jsr        $1120(pc)
110e: 3b40de66             move.w     d0, -$219a(a5)
1112: 426dde64             clr.w      -$219c(a5)
1116: 0c6d0002de66         cmpi.w     #$2, -$219a(a5)
111c: 66d6                 bne.b      $10f4
111e: 4e75                 rts        
1120: 48e70118             movem.l    d7/a3-a4, -(a7)
1124: 4a6dde64             tst.w      -$219c(a5)
1128: 6736                 beq.b      $1160
112a: 49eda184             lea.l      -$5e7c(a5), a4
112e: 47eda14c             lea.l      -$5eb4(a5), a3
1132: 6028                 bra.b      $115c
1134: 1e13                 move.b     (a3), d7
1136: 1007                 move.b     d7, d0
1138: 4880                 ext.w      d0
113a: b06dde66             cmp.w      -$219a(a5), d0
113e: 6706                 beq.b      $1146
1140: 0c0700ff             cmpi.b     #$ff, d7
1144: 6614                 bne.b      $115a
1146: 102b0001             move.b     $1(a3), d0
114a: 4880                 ext.w      d0
114c: b06dde64             cmp.w      -$219c(a5), d0
1150: 6608                 bne.b      $115a
1152: 102b0002             move.b     $2(a3), d0
1156: 4880                 ext.w      d0
1158: 6008                 bra.b      $1162
115a: 588b                 addq.l     #$4, a3
115c: b9cb                 cmpa.l     a3, a4
115e: 62d4                 bhi.b      $1134
1160: 7000                 moveq      #$0, d0
1162: 4cdf1880             movem.l    (a7)+, d7/a3-a4
1166: 4e75                 rts        
1168: a9ff                 dc.w       $a9ff
116a: 4e75                 rts        
116c: 4e560000             link.w     a6, #$0
1170: 0c6d0004de66         cmpi.w     #$4, -$219a(a5)
1176: 56c0                 sne.b      d0
1178: 4400                 neg.b      d0
117a: 4880                 ext.w      d0
117c: 48c0                 ext.l      d0
117e: 4e5e                 unlk       a6
1180: 4e75                 rts        
