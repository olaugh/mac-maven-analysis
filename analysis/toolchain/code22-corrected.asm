0004: 4e56ff68             link.w     a6, #$ff68
0008: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
000c: 3a2e0008             move.w     $8(a6), d5
0010: 7801                 moveq      #$1, d4
0012: 49ed95a3             lea.l      -$6a5d(a5), a4
0016: 41ed97c3             lea.l      -$683d(a5), a0
001a: 2c08                 move.l     a0, d6
001c: 47edbd0f             lea.l      -$42f1(a5), a3
0020: 41edbf40             lea.l      -$40c0(a5), a0
0024: 2e08                 move.l     a0, d7
0026: 600000dc             bra.w      $104
002a: 45eeff80             lea.l      -$80(a6), a2
002e: 7601                 moveq      #$1, d3
0030: 2d47ff78             move.l     d7, -$88(a6)
0034: 2d4bff7c             move.l     a3, -$84(a6)
0038: 2d46ff70             move.l     d6, -$90(a6)
003c: 2d4cff6c             move.l     a4, -$94(a6)
0040: 3043                 movea.w    d3, a0
0042: d1c8                 adda.l     a0, a0
0044: 2d48ff68             move.l     a0, -$98(a6)
0048: 6000008e             bra.w      $d8
004c: 206eff78             movea.l    -$88(a6), a0
0050: d1eeff68             adda.l     -$98(a6), a0
0054: 4a50                 tst.w      (a0)
0056: 670a                 beq.b      $62
0058: 206eff7c             movea.l    -$84(a6), a0
005c: 14f03000             move.b     (a0, d3.w), (a2)+
0060: 606c                 bra.b      $ce
0062: 3043                 movea.w    d3, a0
0064: d1cb                 adda.l     a3, a0
0066: 2d48ff74             move.l     a0, -$8c(a6)
006a: 4a10                 tst.b      (a0)
006c: 6714                 beq.b      $82
006e: 206eff74             movea.l    -$8c(a6), a0
0072: 1010                 move.b     (a0), d0
0074: 4880                 ext.w      d0
0076: 3f00                 move.w     d0, -(a7)
0078: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
007c: 14c0                 move.b     d0, (a2)+
007e: 548f                 addq.l     #$2, a7
0080: 604c                 bra.b      $ce
0082: 206eff70             movea.l    -$90(a6), a0
0086: 0c3000023000         cmpi.b     #$2, (a0, d3.w)
008c: 6606                 bne.b      $94
008e: 14fc0024             move.b     #$24, (a2)+
0092: 603a                 bra.b      $ce
0094: 206eff70             movea.l    -$90(a6), a0
0098: 0c3000033000         cmpi.b     #$3, (a0, d3.w)
009e: 6606                 bne.b      $a6
00a0: 14fc002a             move.b     #$2a, (a2)+
00a4: 6028                 bra.b      $ce
00a6: 206eff6c             movea.l    -$94(a6), a0
00aa: 0c3000023000         cmpi.b     #$2, (a0, d3.w)
00b0: 6606                 bne.b      $b8
00b2: 14fc002b             move.b     #$2b, (a2)+
00b6: 6016                 bra.b      $ce
00b8: 206eff6c             movea.l    -$94(a6), a0
00bc: 0c3000033000         cmpi.b     #$3, (a0, d3.w)
00c2: 6606                 bne.b      $ca
00c4: 14fc0023             move.b     #$23, (a2)+
00c8: 6004                 bra.b      $ce
00ca: 14fc002d             move.b     #$2d, (a2)+
00ce: 14fc0020             move.b     #$20, (a2)+
00d2: 5243                 addq.w     #$1, d3
00d4: 54aeff68             addq.l     #$2, -$98(a6)
00d8: 0c430010             cmpi.w     #$10, d3
00dc: 6500ff6e             bcs.w      $4c
00e0: 14fc000d             move.b     #$d, (a2)+
00e4: 4212                 clr.b      (a2)
00e6: 3f05                 move.w     d5, -(a7)
00e8: 486eff80             pea.l      -$80(a6)
00ec: 4ead0d2a             jsr        $d2a(a5) ; CODE47+0358
00f0: 5c8f                 addq.l     #$6, a7
00f2: 5244                 addq.w     #$1, d4
00f4: 49ec0011             lea.l      $11(a4), a4
00f8: 7011                 moveq      #$11, d0
00fa: dc80                 add.l      d0, d6
00fc: 47eb0011             lea.l      $11(a3), a3
0100: 7022                 moveq      #$22, d0
0102: de80                 add.l      d0, d7
0104: 0c440010             cmpi.w     #$10, d4
0108: 6500ff20             bcs.w      $2a
010c: 3f05                 move.w     d5, -(a7)
010e: 486dc366             pea.l      -$3c9a(a5)
0112: 4ead0d2a             jsr        $d2a(a5) ; CODE47+0358
0116: 3e85                 move.w     d5, (a7)
0118: 486df148             pea.l      -$eb8(a5)
011c: 4ead0d2a             jsr        $d2a(a5) ; CODE47+0358
0120: 3e85                 move.w     d5, (a7)
0122: 486dc35e             pea.l      -$3ca2(a5)
0126: 4ead0d2a             jsr        $d2a(a5) ; CODE47+0358
012a: 7064                 moveq      #$64, d0
012c: 2e80                 move.l     d0, (a7)
012e: 2f2dc36e             move.l     -$3c92(a5), -(a7)
0132: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0136: 2e80                 move.l     d0, (a7)
0138: 48780064             pea.l      $64.w
013c: 2f2dc372             move.l     -$3c8e(a5), -(a7)
0140: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0144: 2f00                 move.l     d0, -(a7)
0146: 2f2da1f2             move.l     -$5e0e(a5), -(a7)
014a: 486eff80             pea.l      -$80(a6)
014e: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0152: 3e85                 move.w     d5, (a7)
0154: 486eff80             pea.l      -$80(a6)
0158: 4ead0d2a             jsr        $d2a(a5) ; CODE47+0358
015c: 4cee1cf8ff48         movem.l    -$b8(a6), d3-d7/a2-a4
0162: 4e5e                 unlk       a6
0164: 4e75                 rts        
0166: 4e56ffe2             link.w     a6, #$ffe2
016a: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
016e: 3c2e0008             move.w     $8(a6), d6
0172: 2e2e000a             move.l     $a(a6), d7
0176: 2f3c54455854         move.l     #$54455854, -(a7)
017c: 3f3c0001             move.w     #$1, -(a7)
0180: 486efffe             pea.l      -$2(a6)
0184: 3f06                 move.w     d6, -(a7)
0186: 2f07                 move.l     d7, -(a7)
0188: 4ead0d32             jsr        $d32(a5) ; CODE47+016c
018c: 4a40                 tst.w      d0
018e: 4fef0010             lea.l      $10(a7), a7
0192: 6704                 beq.b      $198
0194: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0198: 4267                 clr.w      -(a7)
019a: 2f07                 move.l     d7, -(a7)
019c: 3f06                 move.w     d6, -(a7)
019e: 486effe6             pea.l      -$1a(a6)
01a2: 4ead0b3a             jsr        $b3a(a5) ; CODE34+0274
01a6: 2d7c58474d45ffe6     move.l     #$58474d45, -$1a(a6)
01ae: 4257                 clr.w      (a7)
01b0: 2f07                 move.l     d7, -(a7)
01b2: 3f06                 move.w     d6, -(a7)
01b4: 486effe6             pea.l      -$1a(a6)
01b8: 4ead0b5a             jsr        $b5a(a5) ; CODE34+032a
01bc: 4257                 clr.w      (a7)
01be: 3f2efffe             move.w     -$2(a6), -(a7)
01c2: 42a7                 clr.l      -(a7)
01c4: 4ead0b6a             jsr        $b6a(a5) ; CODE34+0386
01c8: 7a00                 moveq      #$0, d5
01ca: 99cc                 suba.l     a4, a4
01cc: 548f                 addq.l     #$2, a7
01ce: 42a7                 clr.l      -(a7)
01d0: 206ddec2             movea.l    -$213e(a5), a0
01d4: 2f2800ca             move.l     $ca(a0), -(a7)
01d8: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
01dc: 2d5fffe2             move.l     (a7)+, -$1e(a6)
01e0: 48780006             pea.l      $6.w
01e4: 2f2effe2             move.l     -$1e(a6), -(a7)
01e8: 4ead004a             jsr        $4a(a5) ; CODE1+0124
01ec: 3045                 movea.w    d5, a0
01ee: b088                 cmp.l      a0, d0
01f0: 630000a4             bls.w      $296
01f4: 206ddec2             movea.l    -$213e(a5), a0
01f8: 206800ca             movea.l    $ca(a0), a0
01fc: 244c                 movea.l    a4, a2
01fe: d5d0                 adda.l     (a0), a2
0200: 1012                 move.b     (a2), d0
0202: 4880                 ext.w      d0
0204: 3d40fffc             move.w     d0, -$4(a6)
0208: 266a0002             movea.l    $2(a2), a3
020c: 7202                 moveq      #$2, d1
020e: 2d41fff6             move.l     d1, -$a(a6)
0212: 4267                 clr.w      -(a7)
0214: 3f2efffe             move.w     -$2(a6), -(a7)
0218: 486efff6             pea.l      -$a(a6)
021c: 486efffc             pea.l      -$4(a6)
0220: 4ead0b32             jsr        $b32(a5) ; CODE34+0230
0224: 42a7                 clr.l      -(a7)
0226: 2f0b                 move.l     a3, -(a7)
0228: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
022c: 201f                 move.l     (a7)+, d0
022e: 3d40fffa             move.w     d0, -$6(a6)
0232: 7202                 moveq      #$2, d1
0234: 2d41fff6             move.l     d1, -$a(a6)
0238: 4257                 clr.w      (a7)
023a: 3f2efffe             move.w     -$2(a6), -(a7)
023e: 486efff6             pea.l      -$a(a6)
0242: 486efffa             pea.l      -$6(a6)
0246: 4ead0b32             jsr        $b32(a5) ; CODE34+0230
024a: 2f0b                 move.l     a3, -(a7)
024c: 4ead05ea             jsr        $5ea(a5) ; CODE9+022e
0250: 2440                 movea.l    d0, a2
0252: 0c6e0001fffc         cmpi.w     #$1, -$4(a6)
0258: 5c8f                 addq.l     #$6, a7
025a: 6608                 bne.b      $264
025c: 382a0004             move.w     $4(a2), d4
0260: 426a0004             clr.w      $4(a2)
0264: 306efffa             movea.w    -$6(a6), a0
0268: 2d48fff6             move.l     a0, -$a(a6)
026c: 4267                 clr.w      -(a7)
026e: 3f2efffe             move.w     -$2(a6), -(a7)
0272: 486efff6             pea.l      -$a(a6)
0276: 2f0a                 move.l     a2, -(a7)
0278: 4ead0b32             jsr        $b32(a5) ; CODE34+0230
027c: 204b                 movea.l    a3, a0
027e: a02a                 dc.w       $a02a
0280: 0c6e0001fffc         cmpi.w     #$1, -$4(a6)
0286: 548f                 addq.l     #$2, a7
0288: 6604                 bne.b      $28e
028a: 35440004             move.w     d4, $4(a2)
028e: 5245                 addq.w     #$1, d5
0290: 5c8c                 addq.l     #$6, a4
0292: 6000ff3a             bra.w      $1ce
0296: 4267                 clr.w      -(a7)
0298: 3f2efffe             move.w     -$2(a6), -(a7)
029c: 4ead0b22             jsr        $b22(a5) ; CODE34+0212
02a0: 4a5f                 tst.w      (a7)+
02a2: 6704                 beq.b      $2a8
02a4: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
02a8: 4267                 clr.w      -(a7)
02aa: 42a7                 clr.l      -(a7)
02ac: 3f06                 move.w     d6, -(a7)
02ae: 4ead0b4a             jsr        $b4a(a5) ; CODE34+02cc
02b2: 206ddec2             movea.l    -$213e(a5), a0
02b6: 426800d2             clr.w      $d2(a0)
02ba: 2f07                 move.l     d7, -(a7)
02bc: 4ead04da             jsr        $4da(a5) ; CODE21+1908
02c0: 7001                 moveq      #$1, d0
02c2: 4cee1cf0ffc6         movem.l    -$3a(a6), d4-d7/a2-a4
02c8: 4e5e                 unlk       a6
02ca: 4e75                 rts        
02cc: 4e56ffe2             link.w     a6, #$ffe2
02d0: 48e70738             movem.l    d5-d7/a2-a4, -(a7)
02d4: 2e2e000a             move.l     $a(a6), d7
02d8: 2047                 movea.l    d7, a0
02da: 1010                 move.b     (a0), d0
02dc: 4880                 ext.w      d0
02de: 2207                 move.l     d7, d1
02e0: 5281                 addq.l     #$1, d1
02e2: 3040                 movea.w    d0, a0
02e4: 42301800             clr.b      (a0, d1.l)
02e8: 4267                 clr.w      -(a7)
02ea: 2f07                 move.l     d7, -(a7)
02ec: 3f2e0008             move.w     $8(a6), -(a7)
02f0: 486efffe             pea.l      -$2(a6)
02f4: 4ead0b1a             jsr        $b1a(a5) ; CODE34+01d2
02f8: 4a5f                 tst.w      (a7)+
02fa: 6704                 beq.b      $300
02fc: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0300: 42a7                 clr.l      -(a7)
0302: 206ddec2             movea.l    -$213e(a5), a0
0306: 2f2800ca             move.l     $ca(a0), -(a7)
030a: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
030e: 2d5fffe2             move.l     (a7)+, -$1e(a6)
0312: 48780006             pea.l      $6.w
0316: 2f2effe2             move.l     -$1e(a6), -(a7)
031a: 4ead004a             jsr        $4a(a5) ; CODE1+0124
031e: 3c00                 move.w     d0, d6
0320: 7a00                 moveq      #$0, d5
0322: 97cb                 suba.l     a3, a3
0324: 7002                 moveq      #$2, d0
0326: 2d40fff6             move.l     d0, -$a(a6)
032a: 4267                 clr.w      -(a7)
032c: 3f2efffe             move.w     -$2(a6), -(a7)
0330: 486efff6             pea.l      -$a(a6)
0334: 486efffc             pea.l      -$4(a6)
0338: 4ead0b2a             jsr        $b2a(a5) ; CODE34+022c
033c: 0c5fffd9             cmpi.w     #$ffd9, (a7)+
0340: 670000d0             beq.w      $412
0344: 7002                 moveq      #$2, d0
0346: 2d40fff6             move.l     d0, -$a(a6)
034a: 4267                 clr.w      -(a7)
034c: 3f2efffe             move.w     -$2(a6), -(a7)
0350: 486efff6             pea.l      -$a(a6)
0354: 486efffa             pea.l      -$6(a6)
0358: 4ead0b2a             jsr        $b2a(a5) ; CODE34+022c
035c: bc45                 cmp.w      d5, d6
035e: 548f                 addq.l     #$2, a7
0360: 6e34                 bgt.b      $396
0362: 206ddec2             movea.l    -$213e(a5), a0
0366: 7001                 moveq      #$1, d0
0368: d045                 add.w      d5, d0
036a: c1fc0006             muls.w     #$6, d0
036e: 206800ca             movea.l    $ca(a0), a0
0372: a024                 dc.w       $a024
0374: 4a780220             tst.w      $220.w
0378: 6704                 beq.b      $37e
037a: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
037e: 302efffa             move.w     -$6(a6), d0
0382: 48c0                 ext.l      d0
0384: a122                 dc.w       $a122
0386: 226ddec2             movea.l    -$213e(a5), a1
038a: 226900ca             movea.l    $ca(a1), a1
038e: 2011                 move.l     (a1), d0
0390: 27880802             move.l     a0, $2(a3, d0.l)
0394: 6020                 bra.b      $3b6
0396: 206ddec2             movea.l    -$213e(a5), a0
039a: 206800ca             movea.l    $ca(a0), a0
039e: 2010                 move.l     (a0), d0
03a0: 20730802             movea.l    $2(a3, d0.l), a0
03a4: 302efffa             move.w     -$6(a6), d0
03a8: 48c0                 ext.l      d0
03aa: a024                 dc.w       $a024
03ac: 4a780220             tst.w      $220.w
03b0: 6704                 beq.b      $3b6
03b2: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
03b6: 246ddec2             movea.l    -$213e(a5), a2
03ba: 45ea00ca             lea.l      $ca(a2), a2
03be: 2052                 movea.l    (a2), a0
03c0: 224b                 movea.l    a3, a1
03c2: d3d0                 adda.l     (a0), a1
03c4: 12aefffd             move.b     -$3(a6), (a1)
03c8: 2052                 movea.l    (a2), a0
03ca: 2010                 move.l     (a0), d0
03cc: 28730802             movea.l    $2(a3, d0.l), a4
03d0: 2f0c                 move.l     a4, -(a7)
03d2: 4ead05ea             jsr        $5ea(a5) ; CODE9+022e
03d6: 2440                 movea.l    d0, a2
03d8: 306efffa             movea.w    -$6(a6), a0
03dc: 2d48fff6             move.l     a0, -$a(a6)
03e0: 4257                 clr.w      (a7)
03e2: 3f2efffe             move.w     -$2(a6), -(a7)
03e6: 486efff6             pea.l      -$a(a6)
03ea: 2f0a                 move.l     a2, -(a7)
03ec: 4ead0b2a             jsr        $b2a(a5) ; CODE34+022c
03f0: 204c                 movea.l    a4, a0
03f2: a02a                 dc.w       $a02a
03f4: 588f                 addq.l     #$4, a7
03f6: 5245                 addq.w     #$1, d5
03f8: 5c8b                 addq.l     #$6, a3
03fa: 6000ff28             bra.w      $324
03fe: 206ddec2             movea.l    -$213e(a5), a0
0402: 206800ca             movea.l    $ca(a0), a0
0406: 7006                 moveq      #$6, d0
0408: c1c6                 muls.w     d6, d0
040a: 2050                 movea.l    (a0), a0
040c: 20700802             movea.l    $2(a0, d0.l), a0
0410: a023                 dc.w       $a023
0412: 5346                 subq.w     #$1, d6
0414: ba46                 cmp.w      d6, d5
0416: 6fe6                 ble.b      $3fe
0418: 206ddec2             movea.l    -$213e(a5), a0
041c: 7006                 moveq      #$6, d0
041e: c1c5                 muls.w     d5, d0
0420: 206800ca             movea.l    $ca(a0), a0
0424: a024                 dc.w       $a024
0426: 4a780220             tst.w      $220.w
042a: 6704                 beq.b      $430
042c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0430: 70ff                 moveq      #$ff, d0
0432: d045                 add.w      d5, d0
0434: 3f00                 move.w     d0, -(a7)
0436: 4ead0162             jsr        $162(a5) ; CODE7+0004
043a: 2f2ddec2             move.l     -$213e(a5), -(a7)
043e: a873                 dc.w       $a873
0440: 206ddec2             movea.l    -$213e(a5), a0
0444: 48680010             pea.l      $10(a0)
0448: a928                 dc.w       $a928
044a: 4ead048a             jsr        $48a(a5) ; CODE21+14a6
044e: 4257                 clr.w      (a7)
0450: 3f2efffe             move.w     -$2(a6), -(a7)
0454: 4ead0b22             jsr        $b22(a5) ; CODE34+0212
0458: 4a5f                 tst.w      (a7)+
045a: 6704                 beq.b      $460
045c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0460: 206ddec2             movea.l    -$213e(a5), a0
0464: 426800d2             clr.w      $d2(a0)
0468: 2f07                 move.l     d7, -(a7)
046a: 4ead04da             jsr        $4da(a5) ; CODE21+1908
046e: 48780121             pea.l      $121.w
0472: 486dd76c             pea.l      -$2894(a5)
0476: 486dd88d             pea.l      -$2773(a5)
047a: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
047e: 7001                 moveq      #$1, d0
0480: 4cee1ce0ffca         movem.l    -$36(a6), d5-d7/a2-a4
0486: 4e5e                 unlk       a6
0488: 4e75                 rts        
048a: 4e560000             link.w     a6, #$0
048e: 41edc366             lea.l      -$3c9a(a5), a0
0492: b1ee0008             cmpa.l     $8(a6), a0
0496: 6604                 bne.b      $49c
0498: 4ead0292             jsr        $292(a5) ; CODE14+0318
049c: 2f2e0008             move.l     $8(a6), -(a7)
04a0: 4ead0962             jsr        $962(a5) ; CODE31+07e0
04a4: 4e5e                 unlk       a6
04a6: 4e75                 rts        
04a8: 4e560000             link.w     a6, #$0
04ac: 48e70300             movem.l    d6-d7, -(a7)
04b0: 3e2e0008             move.w     $8(a6), d7
04b4: 0c6d0008a386         cmpi.w     #$8, -$5c7a(a5)
04ba: 6406                 bcc.b      $4c2
04bc: 4a6da386             tst.w      -$5c7a(a5)
04c0: 6c04                 bge.b      $4c6
04c2: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
04c6: 302da386             move.w     -$5c7a(a5), d0
04ca: 526da386             addq.w     #$1, -$5c7a(a5)
04ce: c1fc002c             muls.w     #$2c, d0
04d2: 41eda226             lea.l      -$5dda(a5), a0
04d6: d088                 add.l      a0, d0
04d8: 2040                 movea.l    d0, a0
04da: 7000                 moveq      #$0, d0
04dc: 43fa0006             lea.l      $4e4(pc), a1
04e0: 48d0def8             movem.l    d3-d7/a1-a4/a6-a7, (a0)
04e4: 4a40                 tst.w      d0
04e6: 663c                 bne.b      $524
04e8: 3f07                 move.w     d7, -(a7)
04ea: 4267                 clr.w      -(a7)
04ec: 486dd76c             pea.l      -$2894(a5)
04f0: 4eba009e             jsr        $590(pc)
04f4: 3c00                 move.w     d0, d6
04f6: 508f                 addq.l     #$8, a7
04f8: 6724                 beq.b      $51e
04fa: 486dd76c             pea.l      -$2894(a5)
04fe: 4eba02b4             jsr        $7b4(pc)
0502: 3e87                 move.w     d7, (a7)
0504: 3f3c0001             move.w     #$1, -(a7)
0508: 486dd76c             pea.l      -$2894(a5)
050c: 4eba0082             jsr        $590(pc)
0510: 3c00                 move.w     d0, d6
0512: 486dd76c             pea.l      -$2894(a5)
0516: 4eba029c             jsr        $7b4(pc)
051a: 4fef000e             lea.l      $e(a7), a7
051e: 536da386             subq.w     #$1, -$5c7a(a5)
0522: 6062                 bra.b      $586
0524: 2f2da222             move.l     -$5dde(a5), -(a7)
0528: 2f2da1b6             move.l     -$5e4a(a5), -(a7)
052c: 4ead0db2             jsr        $db2(a5) ; CODE52+0242
0530: 4a40                 tst.w      d0
0532: 508f                 addq.l     #$8, a7
0534: 6620                 bne.b      $556
0536: 48780022             pea.l      $22.w
053a: 486da5ce             pea.l      -$5a32(a5)
053e: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0542: 486d0432             pea.l      $432(a5)
0546: 4ead042a             jsr        $42a(a5) ; CODE20+041a
054a: 4ead0552             jsr        $552(a5) ; CODE21+0052
054e: 7c01                 moveq      #$1, d6
0550: 4fef000c             lea.l      $c(a7), a7
0554: 6030                 bra.b      $586
0556: 4a6da386             tst.w      -$5c7a(a5)
055a: 6e04                 bgt.b      $560
055c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0560: 2b6da222a222         move.l     -$5dde(a5), -$5dde(a5)
0566: 536da386             subq.w     #$1, -$5c7a(a5)
056a: 702c                 moveq      #$2c, d0
056c: c1eda386             muls.w     -$5c7a(a5), d0
0570: 41eda226             lea.l      -$5dda(a5), a0
0574: d088                 add.l      a0, d0
0576: 2040                 movea.l    d0, a0
0578: 7001                 moveq      #$1, d0
057a: 4a40                 tst.w      d0
057c: 6602                 bne.b      $580
057e: 7001                 moveq      #$1, d0
0580: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
0584: 4ed1                 jmp        (a1)
0586: 3006                 move.w     d6, d0
0588: 4cdf00c0             movem.l    (a7)+, d6-d7
058c: 4e5e                 unlk       a6
058e: 4e75                 rts        
0590: 4e56fee0             link.w     a6, #$fee0
0594: 48e70118             movem.l    d7/a3-a4, -(a7)
0598: 286e0008             movea.l    $8(a6), a4
059c: 600000c2             bra.w      $660
05a0: 1e14                 move.b     (a4), d7
05a2: 4a07                 tst.b      d7
05a4: 676c                 beq.b      $612
05a6: 4a2c0001             tst.b      $1(a4)
05aa: 6766                 beq.b      $612
05ac: 4a2cffff             tst.b      -$1(a4)
05b0: 6660                 bne.b      $612
05b2: 47eeffe0             lea.l      -$20(a6), a3
05b6: 6010                 bra.b      $5c8
05b8: 1014                 move.b     (a4), d0
05ba: 4880                 ext.w      d0
05bc: 3f00                 move.w     d0, -(a7)
05be: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
05c2: 16c0                 move.b     d0, (a3)+
05c4: 548f                 addq.l     #$2, a7
05c6: 528c                 addq.l     #$1, a4
05c8: 4a14                 tst.b      (a4)
05ca: 66ec                 bne.b      $5b8
05cc: 4213                 clr.b      (a3)
05ce: 486effe0             pea.l      -$20(a6)
05d2: 4ead031a             jsr        $31a(a5) ; CODE15+023e
05d6: 4a80                 tst.l      d0
05d8: 588f                 addq.l     #$4, a7
05da: 66000082             bne.w      $65e
05de: 486effe0             pea.l      -$20(a6)
05e2: 4eba0116             jsr        $6fa(pc)
05e6: 4a40                 tst.w      d0
05e8: 588f                 addq.l     #$4, a7
05ea: 6672                 bne.b      $65e
05ec: 3f2e000c             move.w     $c(a6), -(a7)
05f0: 486effe0             pea.l      -$20(a6)
05f4: 3f2e000e             move.w     $e(a6), -(a7)
05f8: 4eba007e             jsr        $678(pc)
05fc: 5340                 subq.w     #$1, d0
05fe: 508f                 addq.l     #$8, a7
0600: 6604                 bne.b      $606
0602: 7000                 moveq      #$0, d0
0604: 606a                 bra.b      $670
0606: 486effe0             pea.l      -$20(a6)
060a: 4eba0128             jsr        $734(pc)
060e: 588f                 addq.l     #$4, a7
0610: 604c                 bra.b      $65e
0612: 4a07                 tst.b      d7
0614: 6748                 beq.b      $65e
0616: 4a2cffff             tst.b      -$1(a4)
061a: 6642                 bne.b      $65e
061c: 4a2c0001             tst.b      $1(a4)
0620: 663c                 bne.b      $65e
0622: 4a2cffef             tst.b      -$11(a4)
0626: 6636                 bne.b      $65e
0628: 4a2c0011             tst.b      $11(a4)
062c: 6630                 bne.b      $65e
062e: 1014                 move.b     (a4), d0
0630: 4880                 ext.w      d0
0632: 3f00                 move.w     d0, -(a7)
0634: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
0638: 1d40ffe0             move.b     d0, -$20(a6)
063c: 422effe1             clr.b      -$1f(a6)
0640: 4a6e000e             tst.w      $e(a6)
0644: 548f                 addq.l     #$2, a7
0646: 6712                 beq.b      $65a
0648: 3f2e000c             move.w     $c(a6), -(a7)
064c: 486effe0             pea.l      -$20(a6)
0650: 3f3c0406             move.w     #$406, -(a7)
0654: 4eba0022             jsr        $678(pc)
0658: 508f                 addq.l     #$8, a7
065a: 7000                 moveq      #$0, d0
065c: 6012                 bra.b      $670
065e: 528c                 addq.l     #$1, a4
0660: 206e0008             movea.l    $8(a6), a0
0664: 41e80121             lea.l      $121(a0), a0
0668: b1cc                 cmpa.l     a4, a0
066a: 6200ff34             bhi.w      $5a0
066e: 7001                 moveq      #$1, d0
0670: 4cdf1880             movem.l    (a7)+, d7/a3-a4
0674: 4e5e                 unlk       a6
0676: 4e75                 rts        
0678: 4e56ffe0             link.w     a6, #$ffe0
067c: 2f07                 move.l     d7, -(a7)
067e: 7e01                 moveq      #$1, d7
0680: 4a6e0008             tst.w      $8(a6)
0684: 676c                 beq.b      $6f2
0686: 2f2e000a             move.l     $a(a6), -(a7)
068a: 2f2e000a             move.l     $a(a6), -(a7)
068e: 4ead07ea             jsr        $7ea(a5) ; CODE23+01fe
0692: 2e80                 move.l     d0, (a7)
0694: 4ead0c62             jsr        $c62(a5) ; CODE41+0004
0698: 4a6e000e             tst.w      $e(a6)
069c: 508f                 addq.l     #$8, a7
069e: 670a                 beq.b      $6aa
06a0: 486dd76c             pea.l      -$2894(a5)
06a4: 4eba010e             jsr        $7b4(pc)
06a8: 588f                 addq.l     #$4, a7
06aa: 3f2e0008             move.w     $8(a6), -(a7)
06ae: 4ead0c6a             jsr        $c6a(a5) ; CODE41+010a
06b2: 3e00                 move.w     d0, d7
06b4: 0c470003             cmpi.w     #$3, d7
06b8: 548f                 addq.l     #$2, a7
06ba: 6626                 bne.b      $6e2
06bc: 2b6da1b6a222         move.l     -$5e4a(a5), -$5dde(a5)
06c2: 536da386             subq.w     #$1, -$5c7a(a5)
06c6: 702c                 moveq      #$2c, d0
06c8: c1eda386             muls.w     -$5c7a(a5), d0
06cc: 41eda226             lea.l      -$5dda(a5), a0
06d0: d088                 add.l      a0, d0
06d2: 2040                 movea.l    d0, a0
06d4: 7001                 moveq      #$1, d0
06d6: 4a40                 tst.w      d0
06d8: 6602                 bne.b      $6dc
06da: 7001                 moveq      #$1, d0
06dc: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
06e0: 4ed1                 jmp        (a1)
06e2: 4a6e000e             tst.w      $e(a6)
06e6: 670a                 beq.b      $6f2
06e8: 486dd76c             pea.l      -$2894(a5)
06ec: 4eba00c6             jsr        $7b4(pc)
06f0: 588f                 addq.l     #$4, a7
06f2: 3007                 move.w     d7, d0
06f4: 2e1f                 move.l     (a7)+, d7
06f6: 4e5e                 unlk       a6
06f8: 4e75                 rts        
06fa: 4e560000             link.w     a6, #$0
06fe: 48e70108             movem.l    d7/a4, -(a7)
0702: 7e00                 moveq      #$0, d7
0704: 49edf14a             lea.l      -$eb6(a5), a4
0708: 601a                 bra.b      $724
070a: 2f0c                 move.l     a4, -(a7)
070c: 2f2e0008             move.l     $8(a6), -(a7)
0710: 4ead0db2             jsr        $db2(a5) ; CODE52+0242
0714: 4a40                 tst.w      d0
0716: 508f                 addq.l     #$8, a7
0718: 6604                 bne.b      $71e
071a: 7001                 moveq      #$1, d0
071c: 600e                 bra.b      $72c
071e: 5247                 addq.w     #$1, d7
0720: 49ec0010             lea.l      $10(a4), a4
0724: be6df23a             cmp.w      -$dc6(a5), d7
0728: 6de0                 blt.b      $70a
072a: 7000                 moveq      #$0, d0
072c: 4cdf1080             movem.l    (a7)+, d7/a4
0730: 4e5e                 unlk       a6
0732: 4e75                 rts        
0734: 4e560000             link.w     a6, #$0
0738: 48e70108             movem.l    d7/a4, -(a7)
073c: 0c6d000ff23a         cmpi.w     #$f, -$dc6(a5)
0742: 6420                 bcc.b      $764
0744: 2f2e0008             move.l     $8(a6), -(a7)
0748: 302df23a             move.w     -$dc6(a5), d0
074c: 526df23a             addq.w     #$1, -$dc6(a5)
0750: 48c0                 ext.l      d0
0752: e988                 lsl.l      #$4, d0
0754: 204d                 movea.l    a5, a0
0756: d1c0                 adda.l     d0, a0
0758: 4868f14a             pea.l      -$eb6(a0)
075c: 4ead07f2             jsr        $7f2(a5) ; CODE23+01be
0760: 508f                 addq.l     #$8, a7
0762: 6048                 bra.b      $7ac
0764: 7e00                 moveq      #$0, d7
0766: 49edf14a             lea.l      -$eb6(a5), a4
076a: 601e                 bra.b      $78a
076c: 2f0c                 move.l     a4, -(a7)
076e: 2007                 move.l     d7, d0
0770: 5240                 addq.w     #$1, d0
0772: 48c0                 ext.l      d0
0774: e988                 lsl.l      #$4, d0
0776: 204d                 movea.l    a5, a0
0778: d1c0                 adda.l     d0, a0
077a: 4868f14a             pea.l      -$eb6(a0)
077e: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0782: 508f                 addq.l     #$8, a7
0784: 5247                 addq.w     #$1, d7
0786: 49ec0010             lea.l      $10(a4), a4
078a: 0c47000e             cmpi.w     #$e, d7
078e: 65dc                 bcs.b      $76c
0790: 2f2e0008             move.l     $8(a6), -(a7)
0794: 486df14a             pea.l      -$eb6(a5)
0798: 4ead07f2             jsr        $7f2(a5) ; CODE23+01be
079c: 70ff                 moveq      #$ff, d0
079e: d06df23a             add.w      -$dc6(a5), d0
07a2: b047                 cmp.w      d7, d0
07a4: 508f                 addq.l     #$8, a7
07a6: 6704                 beq.b      $7ac
07a8: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
07ac: 4cdf1080             movem.l    (a7)+, d7/a4
07b0: 4e5e                 unlk       a6
07b2: 4e75                 rts        
07b4: 4e560000             link.w     a6, #$0
07b8: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
07bc: 7c00                 moveq      #$0, d6
07be: 99cc                 suba.l     a4, a4
07c0: 603c                 bra.b      $7fe
07c2: 7a01                 moveq      #$1, d5
07c4: da46                 add.w      d6, d5
07c6: 264c                 movea.l    a4, a3
07c8: d7ee0008             adda.l     $8(a6), a3
07cc: 7011                 moveq      #$11, d0
07ce: c1c5                 muls.w     d5, d0
07d0: 2440                 movea.l    d0, a2
07d2: 601e                 bra.b      $7f2
07d4: 18335000             move.b     (a3, d5.w), d4
07d8: 204a                 movea.l    a2, a0
07da: d1ee0008             adda.l     $8(a6), a0
07de: d0c6                 adda.w     d6, a0
07e0: 2e08                 move.l     a0, d7
07e2: 2047                 movea.l    d7, a0
07e4: 17905000             move.b     (a0), (a3, d5.w)
07e8: 2047                 movea.l    d7, a0
07ea: 1084                 move.b     d4, (a0)
07ec: 5245                 addq.w     #$1, d5
07ee: 45ea0011             lea.l      $11(a2), a2
07f2: 0c450011             cmpi.w     #$11, d5
07f6: 6ddc                 blt.b      $7d4
07f8: 5246                 addq.w     #$1, d6
07fa: 49ec0011             lea.l      $11(a4), a4
07fe: 0c460011             cmpi.w     #$11, d6
0802: 6dbe                 blt.b      $7c2
0804: 4cdf1cf0             movem.l    (a7)+, d4-d7/a2-a4
0808: 4e5e                 unlk       a6
080a: 4e75                 rts        
