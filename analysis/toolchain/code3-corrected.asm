0004: 4e56f716             link.w     a6, #$f716
0008: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
000c: 7018                 moveq      #$18, d0
000e: d0ae0008             add.l      $8(a6), d0
0012: 2840                 movea.l    d0, a4
0014: 2c2c002a             move.l     $2a(a4), d6
0018: 206e0008             movea.l    $8(a6), a0
001c: 0c680040000c         cmpi.w     #$40, $c(a0)
0022: 6f04                 ble.b      $28
0024: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0028: 2f06                 move.l     d6, -(a7)
002a: 486d902c             pea.l      -$6fd4(a5)
002e: 486effc1             pea.l      -$3f(a6)
0032: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0036: 1d40ffc0             move.b     d0, -$40(a6)
003a: 486effc0             pea.l      -$40(a6)
003e: 4ead02a2             jsr        $2a2(a5) ; CODE14+0306
0042: 4a86                 tst.l      d6
0044: 4fef0010             lea.l      $10(a7), a7
0048: 6602                 bne.b      $4c
004a: 7c01                 moveq      #$1, d6
004c: 7a00                 moveq      #$0, d5
004e: 206e0008             movea.l    $8(a6), a0
0052: 3828000c             move.w     $c(a0), d4
0056: 48780002             pea.l      $2.w
005a: 2f06                 move.l     d6, -(a7)
005c: 4ead005a             jsr        $5a(a5) ; CODE1+0166
0060: 2d40f71a             move.l     d0, -$8e6(a6)
0064: 7222                 moveq      #$22, d1
0066: c3c5                 muls.w     d5, d1
0068: 47eef740             lea.l      -$8c0(a6), a3
006c: d28b                 add.l      a3, d1
006e: 2641                 movea.l    d1, a3
0070: 600000b8             bra.w      $12a
0074: 702e                 moveq      #$2e, d0
0076: c1c4                 muls.w     d4, d0
0078: 2440                 movea.l    d0, a2
007a: 204c                 movea.l    a4, a0
007c: d1ca                 adda.l     a2, a0
007e: 43d3                 lea.l      (a3), a1
0080: 7007                 moveq      #$7, d0
0082: 22d8                 move.l     (a0)+, (a1)+
0084: 51c8fffc             dbra       d0, $82
0088: 32d8                 move.w     (a0)+, (a1)+
008a: 2f06                 move.l     d6, -(a7)
008c: 204c                 movea.l    a4, a0
008e: d1ca                 adda.l     a2, a0
0090: 20280022             move.l     $22(a0), d0
0094: d0aef71a             add.l      -$8e6(a6), d0
0098: 2f00                 move.l     d0, -(a7)
009a: 4ead005a             jsr        $5a(a5) ; CODE1+0166
009e: 2e00                 move.l     d0, d7
00a0: 2007                 move.l     d7, d0
00a2: 90ab0014             sub.l      $14(a3), d0
00a6: 90ab0010             sub.l      $10(a3), d0
00aa: 27400018             move.l     d0, $18(a3)
00ae: 7600                 moveq      #$0, d3
00b0: 45eef740             lea.l      -$8c0(a6), a2
00b4: 600e                 bra.b      $c4
00b6: ba43                 cmp.w      d3, d5
00b8: 6e04                 bgt.b      $be
00ba: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
00be: 5243                 addq.w     #$1, d3
00c0: 45ea0022             lea.l      $22(a2), a2
00c4: 202a0010             move.l     $10(a2), d0
00c8: d0aa0014             add.l      $14(a2), d0
00cc: d0aa0018             add.l      $18(a2), d0
00d0: b087                 cmp.l      d7, d0
00d2: 6ee2                 bgt.b      $b6
00d4: 41eef71e             lea.l      -$8e2(a6), a0
00d8: 43d3                 lea.l      (a3), a1
00da: 7007                 moveq      #$7, d0
00dc: 20d9                 move.l     (a1)+, (a0)+
00de: 51c8fffc             dbra       d0, $dc
00e2: 30d9                 move.w     (a1)+, (a0)+
00e4: 7022                 moveq      #$22, d0
00e6: c1c3                 muls.w     d3, d0
00e8: 45eef740             lea.l      -$8c0(a6), a2
00ec: d08a                 add.l      a2, d0
00ee: 2440                 movea.l    d0, a2
00f0: 3005                 move.w     d5, d0
00f2: 9043                 sub.w      d3, d0
00f4: c1fc0022             muls.w     #$22, d0
00f8: 2f00                 move.l     d0, -(a7)
00fa: 2f0a                 move.l     a2, -(a7)
00fc: 7001                 moveq      #$1, d0
00fe: d043                 add.w      d3, d0
0100: c1fc0022             muls.w     #$22, d0
0104: 204e                 movea.l    a6, a0
0106: d1c0                 adda.l     d0, a0
0108: 4868f740             pea.l      -$8c0(a0)
010c: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0110: 41d2                 lea.l      (a2), a0
0112: 43eef71e             lea.l      -$8e2(a6), a1
0116: 7007                 moveq      #$7, d0
0118: 20d9                 move.l     (a1)+, (a0)+
011a: 51c8fffc             dbra       d0, $118
011e: 30d9                 move.w     (a1)+, (a0)+
0120: 4fef000c             lea.l      $c(a7), a7
0124: 5245                 addq.w     #$1, d5
0126: 47eb0022             lea.l      $22(a3), a3
012a: 5344                 subq.w     #$1, d4
012c: 4a44                 tst.w      d4
012e: 6c00ff44             bge.w      $74
0132: 206e0008             movea.l    $8(a6), a0
0136: 3f28000c             move.w     $c(a0), -(a7)
013a: 486ef740             pea.l      -$8c0(a6)
013e: 486d903e             pea.l      -$6fc2(a5)
0142: 4ead029a             jsr        $29a(a5) ; CODE14+044a
0146: 4ead0672             jsr        $672(a5) ; CODE9+0032
014a: 4cee1cf8f6f6         movem.l    -$90a(a6), d3-d7/a2-a4
0150: 4e5e                 unlk       a6
0152: 4e75                 rts        
0154: 3f3c0121             move.w     #$121, -(a7)
0158: 486dd76c             pea.l      -$2894(a5)
015c: 4ead0d7a             jsr        $d7a(a5) ; CODE54+0004
0160: 4a40                 tst.w      d0
0162: 5c8f                 addq.l     #$6, a7
0164: 670a                 beq.b      $170
0166: 4a6dde28             tst.w      -$21d8(a5)
016a: 6604                 bne.b      $170
016c: 7001                 moveq      #$1, d0
016e: 6030                 bra.b      $1a0
0170: 4a6dd9ae             tst.w      -$2652(a5)
0174: 6704                 beq.b      $17a
0176: 7000                 moveq      #$0, d0
0178: 6026                 bra.b      $1a0
017a: 4ead02aa             jsr        $2aa(a5) ; CODE14+0aaa
017e: 4a40                 tst.w      d0
0180: 6604                 bne.b      $186
0182: 7000                 moveq      #$0, d0
0184: 601a                 bra.b      $1a0
0186: 4ead093a             jsr        $93a(a5) ; CODE31+0118
018a: 4a40                 tst.w      d0
018c: 6704                 beq.b      $192
018e: 7000                 moveq      #$0, d0
0190: 600e                 bra.b      $1a0
0192: 4ead0502             jsr        $502(a5) ; CODE21+30a2
0196: 4a40                 tst.w      d0
0198: 6704                 beq.b      $19e
019a: 7000                 moveq      #$0, d0
019c: 6002                 bra.b      $1a0
019e: 7001                 moveq      #$1, d0
01a0: 4e75                 rts        
01a2: 4e560000             link.w     a6, #$0
01a6: 2f0c                 move.l     a4, -(a7)
01a8: 286e0008             movea.l    $8(a6), a4
01ac: 202c0010             move.l     $10(a4), d0
01b0: d0ac0014             add.l      $14(a4), d0
01b4: 222da5de             move.l     -$5a22(a5), d1
01b8: d2ada5e2             add.l      -$5a1e(a5), d1
01bc: d2ada5e6             add.l      -$5a1a(a5), d1
01c0: d0ac0018             add.l      $18(a4), d0
01c4: b280                 cmp.l      d0, d1
01c6: 6c10                 bge.b      $1d8
01c8: 41eda5ce             lea.l      -$5a32(a5), a0
01cc: 43d4                 lea.l      (a4), a1
01ce: 7007                 moveq      #$7, d0
01d0: 20d9                 move.l     (a1)+, (a0)+
01d2: 51c8fffc             dbra       d0, $1d0
01d6: 30d9                 move.w     (a1)+, (a0)+
01d8: 285f                 movea.l    (a7)+, a4
01da: 4e5e                 unlk       a6
01dc: 4e75                 rts        
01de: 4e56ff80             link.w     a6, #$ff80
01e2: 48e70108             movem.l    d7/a4, -(a7)
01e6: 286e0008             movea.l    $8(a6), a4
01ea: 2f0c                 move.l     a4, -(a7)
01ec: 4ead096a             jsr        $96a(a5) ; CODE31+0992
01f0: 486eff80             pea.l      -$80(a6)
01f4: 4ead095a             jsr        $95a(a5) ; CODE31+075c
01f8: 1e00                 move.b     d0, d7
01fa: 0c070008             cmpi.b     #$8, d7
01fe: 508f                 addq.l     #$8, a7
0200: 6c1e                 bge.b      $220
0202: 206dd13c             movea.l    -$2ec4(a5), a0
0206: 4a680014             tst.w      $14(a0)
020a: 6714                 beq.b      $220
020c: 206dd13c             movea.l    -$2ec4(a5), a0
0210: 3068000e             movea.w    $e(a0), a0
0214: 2f08                 move.l     a0, -(a7)
0216: 2f0c                 move.l     a4, -(a7)
0218: 4ead089a             jsr        $89a(a5) ; CODE30+014e
021c: 508f                 addq.l     #$8, a7
021e: 602e                 bra.b      $24e
0220: 0c070007             cmpi.b     #$7, d7
0224: 6f1c                 ble.b      $242
0226: 0c070011             cmpi.b     #$11, d7
022a: 6416                 bcc.b      $242
022c: 206dd13c             movea.l    -$2ec4(a5), a0
0230: 4a680012             tst.w      $12(a0)
0234: 670c                 beq.b      $242
0236: 4267                 clr.w      -(a7)
0238: 2f0c                 move.l     a4, -(a7)
023a: 4ead0a1a             jsr        $a1a(a5) ; CODE36+1810
023e: 5c8f                 addq.l     #$6, a7
0240: 600c                 bra.b      $24e
0242: 486d0842             pea.l      $842(a5)
0246: 2f0c                 move.l     a4, -(a7)
0248: 4ead0852             jsr        $852(a5) ; CODE28+011a
024c: 508f                 addq.l     #$8, a7
024e: 41eda5ce             lea.l      -$5a32(a5), a0
0252: 43eda5f0             lea.l      -$5a10(a5), a1
0256: 7007                 moveq      #$7, d0
0258: 20d9                 move.l     (a1)+, (a0)+
025a: 51c8fffc             dbra       d0, $258
025e: 30d9                 move.w     (a1)+, (a0)+
0260: 4cdf1080             movem.l    (a7)+, d7/a4
0264: 4e5e                 unlk       a6
0266: 4e75                 rts        
0268: 4e56f468             link.w     a6, #$f468
026c: 48780b98             pea.l      $b98.w
0270: 486ef468             pea.l      -$b98(a6)
0274: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0278: 486ef468             pea.l      -$b98(a6)
027c: 4eba0cee             jsr        $f6c(pc)
0280: 4a6ef470             tst.w      -$b90(a6)
0284: 4fef000c             lea.l      $c(a7), a7
0288: 6e06                 bgt.b      $290
028a: 3d7c0001f470         move.w     #$1, -$b90(a6)
0290: e3eef470             lsl.w      -$b90(a6)
0294: 3f3c0121             move.w     #$121, -(a7)
0298: 486dd76c             pea.l      -$2894(a5)
029c: 4ead0d7a             jsr        $d7a(a5) ; CODE54+0004
02a0: 4a40                 tst.w      d0
02a2: 5c8f                 addq.l     #$6, a7
02a4: 6712                 beq.b      $2b8
02a6: 4a6dde28             tst.w      -$21d8(a5)
02aa: 660c                 bne.b      $2b8
02ac: 486ef468             pea.l      -$b98(a6)
02b0: 4eba03f0             jsr        $6a2(pc)
02b4: 588f                 addq.l     #$4, a7
02b6: 600a                 bra.b      $2c2
02b8: 486ef468             pea.l      -$b98(a6)
02bc: 4eba099a             jsr        $c58(pc)
02c0: 588f                 addq.l     #$4, a7
02c2: 4e5e                 unlk       a6
02c4: 4e75                 rts        
02c6: 4e56f8f0             link.w     a6, #$f8f0
02ca: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
02ce: 282e000c             move.l     $c(a6), d4
02d2: 206dd13c             movea.l    -$2ec4(a5), a0
02d6: 4aa80004             tst.l      $4(a0)
02da: 6710                 beq.b      $2ec
02dc: 2f2dd13c             move.l     -$2ec4(a5), -(a7)
02e0: 206dd13c             movea.l    -$2ec4(a5), a0
02e4: 20680004             movea.l    $4(a0), a0
02e8: 4e90                 jsr        (a0)
02ea: 588f                 addq.l     #$4, a7
02ec: 48780220             pea.l      $220.w
02f0: 486dbcfe             pea.l      -$4302(a5)
02f4: 486efd58             pea.l      -$2a8(a6)
02f8: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
02fc: 48780440             pea.l      $440.w
0300: 486dbf1e             pea.l      -$40e2(a5)
0304: 486ef918             pea.l      -$6e8(a6)
0308: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
030c: 486dc366             pea.l      -$3c9a(a5)
0310: 486ef910             pea.l      -$6f0(a6)
0314: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0318: 486dc35e             pea.l      -$3ca2(a5)
031c: 486ef908             pea.l      -$6f8(a6)
0320: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0324: 41edc366             lea.l      -$3c9a(a5), a0
0328: 2d48f8f0             move.l     a0, -$710(a6)
032c: 41edc35e             lea.l      -$3ca2(a5), a0
0330: 2d48f8fc             move.l     a0, -$704(a6)
0334: 7c00                 moveq      #$0, d6
0336: 2a04                 move.l     d4, d5
0338: da85                 add.l      d5, d5
033a: 702e                 moveq      #$2e, d0
033c: c1c6                 muls.w     d6, d0
033e: 2840                 movea.l    d0, a4
0340: 4fef0028             lea.l      $28(a7), a7
0344: 600002fc             bra.w      $642
0348: 42aef900             clr.l      -$700(a6)
034c: 42aef8f4             clr.l      -$70c(a6)
0350: 42aef904             clr.l      -$6fc(a6)
0354: 47ec0018             lea.l      $18(a4), a3
0358: d7edd13c             adda.l     -$2ec4(a5), a3
035c: 244b                 movea.l    a3, a2
035e: d9ab002a             add.l      d4, $2a(a3)
0362: 206dd13c             movea.l    -$2ec4(a5), a0
0366: 4a680016             tst.w      $16(a0)
036a: 6734                 beq.b      $3a0
036c: 48780121             pea.l      $121.w
0370: 486dd76c             pea.l      -$2894(a5)
0374: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0378: 48780121             pea.l      $121.w
037c: 486dd88d             pea.l      -$2773(a5)
0380: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0384: 486d0402             pea.l      $402(a5)
0388: 4ead042a             jsr        $42a(a5) ; CODE20+041a
038c: 4ead0552             jsr        $552(a5) ; CODE21+0052
0390: 4ead051a             jsr        $51a(a5) ; CODE21+286e
0394: 7078                 moveq      #$78, d0
0396: 2e80                 move.l     d0, (a7)
0398: 4ead06d2             jsr        $6d2(a5) ; CODE9+001e
039c: 4fef0014             lea.l      $14(a7), a7
03a0: 2f2ef8f0             move.l     -$710(a6), -(a7)
03a4: 4ead096a             jsr        $96a(a5) ; CODE31+0992
03a8: 4257                 clr.w      (a7)
03aa: 2f2ef8f0             move.l     -$710(a6), -(a7)
03ae: 2f0a                 move.l     a2, -(a7)
03b0: 4ead0942             jsr        $942(a5) ; CODE31+0184
03b4: 206dd13c             movea.l    -$2ec4(a5), a0
03b8: 4a680016             tst.w      $16(a0)
03bc: 4fef000c             lea.l      $c(a7), a7
03c0: 6712                 beq.b      $3d4
03c2: 2f3c00010000         move.l     #$10000, -(a7)
03c8: 2f0a                 move.l     a2, -(a7)
03ca: 4ead016a             jsr        $16a(a5) ; CODE8+0718
03ce: 4ead04d2             jsr        $4d2(a5) ; CODE21+3440
03d2: 508f                 addq.l     #$8, a7
03d4: 202a0010             move.l     $10(a2), d0
03d8: d1aef8f4             add.l      d0, -$70c(a6)
03dc: 2d6a0014f8f8         move.l     $14(a2), -$708(a6)
03e2: 2f2e0008             move.l     $8(a6), -(a7)
03e6: 2f2ef8fc             move.l     -$704(a6), -(a7)
03ea: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
03ee: 206dd13c             movea.l    -$2ec4(a5), a0
03f2: 4a68000a             tst.w      $a(a0)
03f6: 508f                 addq.l     #$8, a7
03f8: 6740                 beq.b      $43a
03fa: 2f2ef8fc             move.l     -$704(a6), -(a7)
03fe: 4ead0542             jsr        $542(a5) ; CODE21+0004
0402: 2eaef8fc             move.l     -$704(a6), (a7)
0406: 2f2d9028             move.l     -$6fd8(a5), -(a7)
040a: 486eff78             pea.l      -$88(a6)
040e: 4ead0812             jsr        $812(a5) ; CODE24+16a6
0412: 48c0                 ext.l      d0
0414: 2600                 move.l     d0, d3
0416: 486eff78             pea.l      -$88(a6)
041a: 2f03                 move.l     d3, -(a7)
041c: 206dd13c             movea.l    -$2ec4(a5), a0
0420: 3f28000a             move.w     $a(a0), -(a7)
0424: 4ead06da             jsr        $6da(a5) ; CODE9+0004
0428: 206dd13c             movea.l    -$2ec4(a5), a0
042c: 3ea8000a             move.w     $a(a0), (a7)
0430: 2f0a                 move.l     a2, -(a7)
0432: 4eba0c6c             jsr        $10a0(pc)
0436: 4fef001a             lea.l      $1a(a7), a7
043a: 2f2ef8f0             move.l     -$710(a6), -(a7)
043e: 4ead0962             jsr        $962(a5) ; CODE31+07e0
0442: 47eef8fc             lea.l      -$704(a6), a3
0446: 45eef8f0             lea.l      -$710(a6), a2
044a: 7600                 moveq      #$0, d3
044c: 588f                 addq.l     #$4, a7
044e: 600000b6             bra.w      $506
0452: 206dd13c             movea.l    -$2ec4(a5), a0
0456: 4a680016             tst.w      $16(a0)
045a: 673a                 beq.b      $496
045c: 486dc366             pea.l      -$3c9a(a5)
0460: 486efff8             pea.l      -$8(a6)
0464: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0468: 2e93                 move.l     (a3), (a7)
046a: 486dc366             pea.l      -$3c9a(a5)
046e: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0472: 4ead0552             jsr        $552(a5) ; CODE21+0052
0476: 486efff8             pea.l      -$8(a6)
047a: 486dc366             pea.l      -$3c9a(a5)
047e: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0482: 4ead04e2             jsr        $4e2(a5) ; CODE21+28bc
0486: 4ead04d2             jsr        $4d2(a5) ; CODE21+3440
048a: 7078                 moveq      #$78, d0
048c: 2e80                 move.l     d0, (a7)
048e: 4ead06d2             jsr        $6d2(a5) ; CODE9+001e
0492: 4fef0014             lea.l      $14(a7), a7
0496: 2b53c376             move.l     (a3), -$3c8a(a5)
049a: 2f13                 move.l     (a3), -(a7)
049c: 4ebafd40             jsr        $1de(pc)
04a0: 4257                 clr.w      (a7)
04a2: 2f13                 move.l     (a3), -(a7)
04a4: 486da5ce             pea.l      -$5a32(a5)
04a8: 4ead0942             jsr        $942(a5) ; CODE31+0184
04ac: 2e93                 move.l     (a3), (a7)
04ae: 4ead0962             jsr        $962(a5) ; CODE31+07e0
04b2: 206dd13c             movea.l    -$2ec4(a5), a0
04b6: 4a68000a             tst.w      $a(a0)
04ba: 4fef000c             lea.l      $c(a7), a7
04be: 6712                 beq.b      $4d2
04c0: 206dd13c             movea.l    -$2ec4(a5), a0
04c4: 3f28000a             move.w     $a(a0), -(a7)
04c8: 486da5ce             pea.l      -$5a32(a5)
04cc: 4eba0bd2             jsr        $10a0(pc)
04d0: 5c8f                 addq.l     #$6, a7
04d2: 206dd13c             movea.l    -$2ec4(a5), a0
04d6: 4a680016             tst.w      $16(a0)
04da: 6710                 beq.b      $4ec
04dc: 2f3c00010000         move.l     #$10000, -(a7)
04e2: 486da5ce             pea.l      -$5a32(a5)
04e6: 4ead016a             jsr        $16a(a5) ; CODE8+0718
04ea: 508f                 addq.l     #$8, a7
04ec: 202da5de             move.l     -$5a22(a5), d0
04f0: d1ab0004             add.l      d0, $4(a3)
04f4: 276da5e20008         move.l     -$5a1e(a5), $8(a3)
04fa: 2e0b                 move.l     a3, d7
04fc: 264a                 movea.l    a2, a3
04fe: 2447                 movea.l    d7, a2
0500: 4ead06ca             jsr        $6ca(a5) ; CODE9+0376
0504: 5243                 addq.w     #$1, d3
0506: 206dd13c             movea.l    -$2ec4(a5), a0
050a: b6680008             cmp.w      $8(a0), d3
050e: 6c0a                 bge.b      $51a
0510: 4ead092a             jsr        $92a(a5) ; CODE31+00b2
0514: 4a40                 tst.w      d0
0516: 6700ff3a             beq.w      $452
051a: 4ead092a             jsr        $92a(a5) ; CODE31+00b2
051e: 4a40                 tst.w      d0
0520: 6612                 bne.b      $534
0522: 202ef8f8             move.l     -$708(a6), d0
0526: d1aef8f4             add.l      d0, -$70c(a6)
052a: 202ef904             move.l     -$6fc(a6), d0
052e: d1aef900             add.l      d0, -$700(a6)
0532: 6056                 bra.b      $58a
0534: 206ef8fc             movea.l    -$704(a6), a0
0538: 4a10                 tst.b      (a0)
053a: 6614                 bne.b      $550
053c: 2f2ef8f0             move.l     -$710(a6), -(a7)
0540: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
0544: d040                 add.w      d0, d0
0546: 48c0                 ext.l      d0
0548: d1aef900             add.l      d0, -$700(a6)
054c: 588f                 addq.l     #$4, a7
054e: 603a                 bra.b      $58a
0550: 206ef8f0             movea.l    -$710(a6), a0
0554: 4a10                 tst.b      (a0)
0556: 6614                 bne.b      $56c
0558: 2f2ef8fc             move.l     -$704(a6), -(a7)
055c: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
0560: d040                 add.w      d0, d0
0562: 48c0                 ext.l      d0
0564: d1aef8f4             add.l      d0, -$70c(a6)
0568: 588f                 addq.l     #$4, a7
056a: 601e                 bra.b      $58a
056c: 2f2ef8f0             move.l     -$710(a6), -(a7)
0570: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
0574: 48c0                 ext.l      d0
0576: d1aef900             add.l      d0, -$700(a6)
057a: 2eaef8fc             move.l     -$704(a6), (a7)
057e: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
0582: 48c0                 ext.l      d0
0584: d1aef8f4             add.l      d0, -$70c(a6)
0588: 588f                 addq.l     #$4, a7
058a: 2f04                 move.l     d4, -(a7)
058c: 202ef8f4             move.l     -$70c(a6), d0
0590: 90aef900             sub.l      -$700(a6), d0
0594: 2f00                 move.l     d0, -(a7)
0596: 4ead0042             jsr        $42(a5) ; CODE1+00ee
059a: 222dd13c             move.l     -$2ec4(a5), d1
059e: d1b4183a             add.l      d0, $3a(a4, d1.l)
05a2: 206dd13c             movea.l    -$2ec4(a5), a0
05a6: 4a68000a             tst.w      $a(a0)
05aa: 673a                 beq.b      $5e6
05ac: 48780064             pea.l      $64.w
05b0: 202ef8f4             move.l     -$70c(a6), d0
05b4: 90aef900             sub.l      -$700(a6), d0
05b8: 2f00                 move.l     d0, -(a7)
05ba: 4ead005a             jsr        $5a(a5) ; CODE1+0166
05be: 2f00                 move.l     d0, -(a7)
05c0: 486d9058             pea.l      -$6fa8(a5)
05c4: 486eff78             pea.l      -$88(a6)
05c8: 4ead0812             jsr        $812(a5) ; CODE24+16a6
05cc: 48c0                 ext.l      d0
05ce: 2600                 move.l     d0, d3
05d0: 486eff78             pea.l      -$88(a6)
05d4: 2f03                 move.l     d3, -(a7)
05d6: 206dd13c             movea.l    -$2ec4(a5), a0
05da: 3f28000a             move.w     $a(a0), -(a7)
05de: 4ead06da             jsr        $6da(a5) ; CODE9+0004
05e2: 4fef0016             lea.l      $16(a7), a7
05e6: 202ef8f4             move.l     -$70c(a6), d0
05ea: b0aef900             cmp.l      -$700(a6), d0
05ee: 6f0a                 ble.b      $5fa
05f0: 202dd13c             move.l     -$2ec4(a5), d0
05f4: dbb4083e             add.l      d5, $3e(a4, d0.l)
05f8: 6012                 bra.b      $60c
05fa: 202ef8f4             move.l     -$70c(a6), d0
05fe: b0aef900             cmp.l      -$700(a6), d0
0602: 6608                 bne.b      $60c
0604: 202dd13c             move.l     -$2ec4(a5), d0
0608: d9b4083e             add.l      d4, $3e(a4, d0.l)
060c: 48780220             pea.l      $220.w
0610: 486efd58             pea.l      -$2a8(a6)
0614: 486dbcfe             pea.l      -$4302(a5)
0618: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
061c: 48780440             pea.l      $440.w
0620: 486ef918             pea.l      -$6e8(a6)
0624: 486dbf1e             pea.l      -$40e2(a5)
0628: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
062c: 486ef910             pea.l      -$6f0(a6)
0630: 486dc366             pea.l      -$3c9a(a5)
0634: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0638: 4fef0020             lea.l      $20(a7), a7
063c: 5246                 addq.w     #$1, d6
063e: 49ec002e             lea.l      $2e(a4), a4
0642: 206dd13c             movea.l    -$2ec4(a5), a0
0646: bc68000c             cmp.w      $c(a0), d6
064a: 6d00fcfc             blt.w      $348
064e: 486ef908             pea.l      -$6f8(a6)
0652: 486dc35e             pea.l      -$3ca2(a5)
0656: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
065a: 206dd13c             movea.l    -$2ec4(a5), a0
065e: 4a680010             tst.w      $10(a0)
0662: 508f                 addq.l     #$8, a7
0664: 6632                 bne.b      $698
0666: 206dd13c             movea.l    -$2ec4(a5), a0
066a: 20280042             move.l     $42(a0), d0
066e: b090                 cmp.l      (a0), d0
0670: 6d26                 blt.b      $698
0672: 2b6d93aca222         move.l     -$6c54(a5), -$5dde(a5)
0678: 536da386             subq.w     #$1, -$5c7a(a5)
067c: 702c                 moveq      #$2c, d0
067e: c1eda386             muls.w     -$5c7a(a5), d0
0682: 41eda226             lea.l      -$5dda(a5), a0
0686: d088                 add.l      a0, d0
0688: 2040                 movea.l    d0, a0
068a: 7001                 moveq      #$1, d0
068c: 4a40                 tst.w      d0
068e: 6602                 bne.b      $692
0690: 7001                 moveq      #$1, d0
0692: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
0696: 4ed1                 jmp        (a1)
0698: 7000                 moveq      #$0, d0
069a: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
069e: 4e5e                 unlk       a6
06a0: 4e75                 rts        
06a2: 4e56e690             link.w     a6, #$e690
06a6: 2b6e0008d13c         move.l     $8(a6), -$2ec4(a5)
06ac: 206dd13c             movea.l    -$2ec4(a5), a0
06b0: 4a68000a             tst.w      $a(a0)
06b4: 671a                 beq.b      $6d0
06b6: 4eba0a3c             jsr        $10f4(pc)
06ba: 206dd13c             movea.l    -$2ec4(a5), a0
06be: 3140000a             move.w     d0, $a(a0)
06c2: 206dd13c             movea.l    -$2ec4(a5), a0
06c6: 3f28000a             move.w     $a(a0), -(a7)
06ca: 4ead059a             jsr        $59a(a5) ; CODE22+0004
06ce: 548f                 addq.l     #$2, a7
06d0: 42adb3e2             clr.l      -$4c1e(a5)
06d4: 3f3c0121             move.w     #$121, -(a7)
06d8: 486dd76c             pea.l      -$2894(a5)
06dc: 4ead0d7a             jsr        $d7a(a5) ; CODE54+0004
06e0: 4a40                 tst.w      d0
06e2: 5c8f                 addq.l     #$6, a7
06e4: 6604                 bne.b      $6ea
06e6: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
06ea: 0c6d0008a386         cmpi.w     #$8, -$5c7a(a5)
06f0: 6406                 bcc.b      $6f8
06f2: 4a6da386             tst.w      -$5c7a(a5)
06f6: 6c04                 bge.b      $6fc
06f8: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
06fc: 302da386             move.w     -$5c7a(a5), d0
0700: 526da386             addq.w     #$1, -$5c7a(a5)
0704: c1fc002c             muls.w     #$2c, d0
0708: 41eda226             lea.l      -$5dda(a5), a0
070c: d088                 add.l      a0, d0
070e: 2040                 movea.l    d0, a0
0710: 7000                 moveq      #$0, d0
0712: 43fa0006             lea.l      $71a(pc), a1
0716: 48d0def8             movem.l    d3-d7/a1-a4/a6-a7, (a0)
071a: 4a40                 tst.w      d0
071c: 6600048c             bne.w      $baa
0720: 41edc35e             lea.l      -$3ca2(a5), a0
0724: 2d48e7b0             move.l     a0, -$1850(a6)
0728: 42aee728             clr.l      -$18d8(a6)
072c: 42aee724             clr.l      -$18dc(a6)
0730: 42aee720             clr.l      -$18e0(a6)
0734: 42aee710             clr.l      -$18f0(a6)
0738: 42aee714             clr.l      -$18ec(a6)
073c: 42aee718             clr.l      -$18e8(a6)
0740: 42aee71c             clr.l      -$18e4(a6)
0744: 206dd13c             movea.l    -$2ec4(a5), a0
0748: 4a680016             tst.w      $16(a0)
074c: 6720                 beq.b      $76e
074e: 48780121             pea.l      $121.w
0752: 486dd76c             pea.l      -$2894(a5)
0756: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
075a: 48780121             pea.l      $121.w
075e: 486dd88d             pea.l      -$2773(a5)
0762: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0766: 4ead051a             jsr        $51a(a5) ; CODE21+286e
076a: 4fef0010             lea.l      $10(a7), a7
076e: 48780220             pea.l      $220.w
0772: 486dbcfe             pea.l      -$4302(a5)
0776: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
077a: 48780440             pea.l      $440.w
077e: 486dbf1e             pea.l      -$40e2(a5)
0782: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0786: 7008                 moveq      #$8, d0
0788: 2e80                 move.l     d0, (a7)
078a: 486dc366             pea.l      -$3c9a(a5)
078e: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0792: 7008                 moveq      #$8, d0
0794: 2e80                 move.l     d0, (a7)
0796: 486dc35e             pea.l      -$3ca2(a5)
079a: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
079e: 42adc372             clr.l      -$3c8e(a5)
07a2: 42adc36e             clr.l      -$3c92(a5)
07a6: 41edc35e             lea.l      -$3ca2(a5), a0
07aa: b1eee7b0             cmpa.l     -$1850(a6), a0
07ae: 4fef0018             lea.l      $18(a7), a7
07b2: 6608                 bne.b      $7bc
07b4: 41edc366             lea.l      -$3c9a(a5), a0
07b8: 2008                 move.l     a0, d0
07ba: 6006                 bra.b      $7c2
07bc: 41edc35e             lea.l      -$3ca2(a5), a0
07c0: 2008                 move.l     a0, d0
07c2: 2b40c376             move.l     d0, -$3c8a(a5)
07c6: 2d40e7b0             move.l     d0, -$1850(a6)
07ca: 486dc366             pea.l      -$3c9a(a5)
07ce: 4ead0962             jsr        $962(a5) ; CODE31+07e0
07d2: 486dc35e             pea.l      -$3ca2(a5)
07d6: 4ead0962             jsr        $962(a5) ; CODE31+07e0
07da: 41eee7ee             lea.l      -$1812(a6), a0
07de: 2d48e7d6             move.l     a0, -$182a(a6)
07e2: 43eeebee             lea.l      -$1412(a6), a1
07e6: 2d49e7d2             move.l     a1, -$182e(a6)
07ea: 41eeefee             lea.l      -$1012(a6), a0
07ee: 2d48e7ce             move.l     a0, -$1832(a6)
07f2: 41eef3ee             lea.l      -$c12(a6), a0
07f6: 2d48e7e2             move.l     a0, -$181e(a6)
07fa: 41eef7ee             lea.l      -$812(a6), a0
07fe: 2d48e7de             move.l     a0, -$1822(a6)
0802: 41eefbee             lea.l      -$412(a6), a0
0806: 2d48e7da             move.l     a0, -$1826(a6)
080a: 426ee7c8             clr.w      -$1838(a6)
080e: 508f                 addq.l     #$8, a7
0810: 206dd13c             movea.l    -$2ec4(a5), a0
0814: 4a680016             tst.w      $16(a0)
0818: 6730                 beq.b      $84a
081a: 486dc366             pea.l      -$3c9a(a5)
081e: 486efff0             pea.l      -$10(a6)
0822: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0826: 2eadc376             move.l     -$3c8a(a5), (a7)
082a: 486dc366             pea.l      -$3c9a(a5)
082e: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0832: 4ead0552             jsr        $552(a5) ; CODE21+0052
0836: 4ead03c2             jsr        $3c2(a5) ; CODE20+0cfa
083a: 486efff0             pea.l      -$10(a6)
083e: 486dc366             pea.l      -$3c9a(a5)
0842: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0846: 4fef0014             lea.l      $14(a7), a7
084a: 4ead0672             jsr        $672(a5) ; CODE9+0032
084e: 4ead06ca             jsr        $6ca(a5) ; CODE9+0376
0852: 2f2dc376             move.l     -$3c8a(a5), -(a7)
0856: 4ebaf986             jsr        $1de(pc)
085a: 4ead093a             jsr        $93a(a5) ; CODE31+0118
085e: 4a40                 tst.w      d0
0860: 588f                 addq.l     #$4, a7
0862: 66000178             bne.w      $9dc
0866: 486dc35e             pea.l      -$3ca2(a5)
086a: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
086e: 5f80                 subq.l     #$7, d0
0870: 588f                 addq.l     #$4, a7
0872: 6704                 beq.b      $878
0874: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0878: 486dc366             pea.l      -$3c9a(a5)
087c: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
0880: 5f80                 subq.l     #$7, d0
0882: 588f                 addq.l     #$4, a7
0884: 6704                 beq.b      $88a
0886: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
088a: 48780022             pea.l      $22.w
088e: 486da5ce             pea.l      -$5a32(a5)
0892: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0896: 2b7cffff8001a5de     move.l     #$ffff8001, -$5a22(a5)
089e: 426effee             clr.w      -$12(a6)
08a2: 508f                 addq.l     #$8, a7
08a4: 6000012a             bra.w      $9d0
08a8: 4a2dbd8e             tst.b      -$4272(a5)
08ac: 66000084             bne.w      $932
08b0: 7022                 moveq      #$22, d0
08b2: c1eeffee             muls.w     -$12(a6), d0
08b6: 204d                 movea.l    a5, a0
08b8: d1c0                 adda.l     d0, a0
08ba: 4a28a610             tst.b      -$59f0(a0)
08be: 6728                 beq.b      $8e8
08c0: 7022                 moveq      #$22, d0
08c2: c1eeffee             muls.w     -$12(a6), d0
08c6: 204d                 movea.l    a5, a0
08c8: d1c0                 adda.l     d0, a0
08ca: 4868a5f0             pea.l      -$5a10(a0)
08ce: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
08d2: 5980                 subq.l     #$4, d0
08d4: 588f                 addq.l     #$4, a7
08d6: 6310                 bls.b      $8e8
08d8: 7022                 moveq      #$22, d0
08da: c1eeffee             muls.w     -$12(a6), d0
08de: 204d                 movea.l    a5, a0
08e0: d1c0                 adda.l     d0, a0
08e2: 7064                 moveq      #$64, d0
08e4: d1a8a608             add.l      d0, -$59f8(a0)
08e8: 7022                 moveq      #$22, d0
08ea: c1eeffee             muls.w     -$12(a6), d0
08ee: 204d                 movea.l    a5, a0
08f0: d1c0                 adda.l     d0, a0
08f2: 4a28a610             tst.b      -$59f0(a0)
08f6: 6716                 beq.b      $90e
08f8: 7022                 moveq      #$22, d0
08fa: c1eeffee             muls.w     -$12(a6), d0
08fe: 204d                 movea.l    a5, a0
0900: d1c0                 adda.l     d0, a0
0902: 4868a5f0             pea.l      -$5a10(a0)
0906: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
090a: 588f                 addq.l     #$4, a7
090c: 6002                 bra.b      $910
090e: 7000                 moveq      #$0, d0
0910: 4878001c             pea.l      $1c.w
0914: 2f00                 move.l     d0, -(a7)
0916: 4ead0042             jsr        $42(a5) ; CODE1+00ee
091a: 206dd568             movea.l    -$2a98(a5), a0
091e: 7222                 moveq      #$22, d1
0920: c3eeffee             muls.w     -$12(a6), d1
0924: 20300818             move.l     $18(a0, d0.l), d0
0928: 224d                 movea.l    a5, a1
092a: d3c1                 adda.l     d1, a1
092c: d1a9a608             add.l      d0, -$59f8(a1)
0930: 600e                 bra.b      $940
0932: 7022                 moveq      #$22, d0
0934: c1eeffee             muls.w     -$12(a6), d0
0938: 204d                 movea.l    a5, a0
093a: d1c0                 adda.l     d0, a0
093c: 42a8a608             clr.l      -$59f8(a0)
0940: 42a7                 clr.l      -(a7)
0942: 42a7                 clr.l      -(a7)
0944: 7022                 moveq      #$22, d0
0946: c1eeffee             muls.w     -$12(a6), d0
094a: 204d                 movea.l    a5, a0
094c: d1c0                 adda.l     d0, a0
094e: 4868a5f0             pea.l      -$5a10(a0)
0952: 4ead09e2             jsr        $9e2(a5) ; CODE35+036c
0956: 7222                 moveq      #$22, d1
0958: c3eeffee             muls.w     -$12(a6), d1
095c: 204d                 movea.l    a5, a0
095e: d1c1                 adda.l     d1, a0
0960: 90a8a604             sub.l      -$59fc(a0), d0
0964: 7222                 moveq      #$22, d1
0966: c3eeffee             muls.w     -$12(a6), d1
096a: 204d                 movea.l    a5, a0
096c: d1c1                 adda.l     d1, a0
096e: d1a8a608             add.l      d0, -$59f8(a0)
0972: 202da5de             move.l     -$5a22(a5), d0
0976: d0ada5e2             add.l      -$5a1e(a5), d0
097a: 7222                 moveq      #$22, d1
097c: c3eeffee             muls.w     -$12(a6), d1
0980: 204d                 movea.l    a5, a0
0982: d1c1                 adda.l     d1, a0
0984: 7222                 moveq      #$22, d1
0986: c3eeffee             muls.w     -$12(a6), d1
098a: 224d                 movea.l    a5, a1
098c: d3c1                 adda.l     d1, a1
098e: 2228a600             move.l     -$5a00(a0), d1
0992: d2a9a604             add.l      -$59fc(a1), d1
0996: 7422                 moveq      #$22, d2
0998: c5eeffee             muls.w     -$12(a6), d2
099c: 204d                 movea.l    a5, a0
099e: d1c2                 adda.l     d2, a0
09a0: d2a8a608             add.l      -$59f8(a0), d1
09a4: d0ada5e6             add.l      -$5a1a(a5), d0
09a8: b280                 cmp.l      d0, d1
09aa: 4fef000c             lea.l      $c(a7), a7
09ae: 6f1c                 ble.b      $9cc
09b0: 7022                 moveq      #$22, d0
09b2: c1eeffee             muls.w     -$12(a6), d0
09b6: 204d                 movea.l    a5, a0
09b8: d1c0                 adda.l     d0, a0
09ba: 43eda5ce             lea.l      -$5a32(a5), a1
09be: 41e8a5f0             lea.l      -$5a10(a0), a0
09c2: 7007                 moveq      #$7, d0
09c4: 22d8                 move.l     (a0)+, (a1)+
09c6: 51c8fffc             dbra       d0, $9c4
09ca: 32d8                 move.w     (a0)+, (a1)+
09cc: 526effee             addq.w     #$1, -$12(a6)
09d0: 302effee             move.w     -$12(a6), d0
09d4: b06dcf04             cmp.w      -$30fc(a5), d0
09d8: 6d00fece             blt.w      $8a8
09dc: 206dd13c             movea.l    -$2ec4(a5), a0
09e0: 4a68000a             tst.w      $a(a0)
09e4: 6744                 beq.b      $a2a
09e6: 2f2dc376             move.l     -$3c8a(a5), -(a7)
09ea: 4ead0542             jsr        $542(a5) ; CODE21+0004
09ee: 2eadc376             move.l     -$3c8a(a5), (a7)
09f2: 2f2d9028             move.l     -$6fd8(a5), -(a7)
09f6: 486ee72c             pea.l      -$18d4(a6)
09fa: 4ead0812             jsr        $812(a5) ; CODE24+16a6
09fe: 3040                 movea.w    d0, a0
0a00: 2d48e7c4             move.l     a0, -$183c(a6)
0a04: 486ee72c             pea.l      -$18d4(a6)
0a08: 2f08                 move.l     a0, -(a7)
0a0a: 226dd13c             movea.l    -$2ec4(a5), a1
0a0e: 3f29000a             move.w     $a(a1), -(a7)
0a12: 4ead06da             jsr        $6da(a5) ; CODE9+0004
0a16: 206dd13c             movea.l    -$2ec4(a5), a0
0a1a: 3ea8000a             move.w     $a(a0), (a7)
0a1e: 486da5ce             pea.l      -$5a32(a5)
0a22: 4eba067c             jsr        $10a0(pc)
0a26: 4fef001a             lea.l      $1a(a7), a7
0a2a: 2f2ee7ce             move.l     -$1832(a6), -(a7)
0a2e: 2f2ee7da             move.l     -$1826(a6), -(a7)
0a32: 486da5ce             pea.l      -$5a32(a5)
0a36: 4ead09e2             jsr        $9e2(a5) ; CODE35+036c
0a3a: 2d6da5dee7c0         move.l     -$5a22(a5), -$1840(a6)
0a40: 48780080             pea.l      $80.w
0a44: 486da54e             pea.l      -$5ab2(a5)
0a48: 486ee690             pea.l      -$1970(a6)
0a4c: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0a50: 2d6ee7d6e7ca         move.l     -$182a(a6), -$1836(a6)
0a56: 2d6ee7d2e7d6         move.l     -$182e(a6), -$182a(a6)
0a5c: 2d6ee7cee7d2         move.l     -$1832(a6), -$182e(a6)
0a62: 2d6ee7cae7ce         move.l     -$1836(a6), -$1832(a6)
0a68: 2d6ee7e2e7ca         move.l     -$181e(a6), -$1836(a6)
0a6e: 2d6ee7dee7e2         move.l     -$1822(a6), -$181e(a6)
0a74: 2d6ee7dae7de         move.l     -$1826(a6), -$1822(a6)
0a7a: 2d6ee7cae7da         move.l     -$1836(a6), -$1826(a6)
0a80: 4257                 clr.w      (a7)
0a82: 2f2dc376             move.l     -$3c8a(a5), -(a7)
0a86: 486da5ce             pea.l      -$5a32(a5)
0a8a: 4ead0942             jsr        $942(a5) ; CODE31+0184
0a8e: 526ee7c8             addq.w     #$1, -$1838(a6)
0a92: 2eadc376             move.l     -$3c8a(a5), (a7)
0a96: 4ead0962             jsr        $962(a5) ; CODE31+07e0
0a9a: 41edc366             lea.l      -$3c9a(a5), a0
0a9e: b1edc376             cmpa.l     -$3c8a(a5), a0
0aa2: 4fef0020             lea.l      $20(a7), a7
0aa6: 6612                 bne.b      $aba
0aa8: 202da5de             move.l     -$5a22(a5), d0
0aac: d1adc372             add.l      d0, -$3c8e(a5)
0ab0: 41edc35e             lea.l      -$3ca2(a5), a0
0ab4: 2b48c376             move.l     a0, -$3c8a(a5)
0ab8: 6010                 bra.b      $aca
0aba: 202da5de             move.l     -$5a22(a5), d0
0abe: d1adc36e             add.l      d0, -$3c92(a5)
0ac2: 41edc366             lea.l      -$3c9a(a5), a0
0ac6: 2b48c376             move.l     a0, -$3c8a(a5)
0aca: 206dd13c             movea.l    -$2ec4(a5), a0
0ace: 4a680016             tst.w      $16(a0)
0ad2: 6714                 beq.b      $ae8
0ad4: 2f3c00010000         move.l     #$10000, -(a7)
0ada: 486da5ce             pea.l      -$5a32(a5)
0ade: 4ead016a             jsr        $16a(a5) ; CODE8+0718
0ae2: 4ead04ea             jsr        $4ea(a5) ; CODE21+1310
0ae6: 508f                 addq.l     #$8, a7
0ae8: 4ead092a             jsr        $92a(a5) ; CODE31+00b2
0aec: 4a40                 tst.w      d0
0aee: 6700fd20             beq.w      $810
0af2: 4a2dc35e             tst.b      -$3ca2(a5)
0af6: 6726                 beq.b      $b1e
0af8: 4a2dc366             tst.b      -$3c9a(a5)
0afc: 6720                 beq.b      $b1e
0afe: 486dc35e             pea.l      -$3ca2(a5)
0b02: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
0b06: 48c0                 ext.l      d0
0b08: 91adc36e             sub.l      d0, -$3c92(a5)
0b0c: 486dc366             pea.l      -$3c9a(a5)
0b10: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
0b14: 48c0                 ext.l      d0
0b16: 91adc372             sub.l      d0, -$3c8e(a5)
0b1a: 508f                 addq.l     #$8, a7
0b1c: 6036                 bra.b      $b54
0b1e: 4a2dc366             tst.b      -$3c9a(a5)
0b22: 6714                 beq.b      $b38
0b24: 486dc366             pea.l      -$3c9a(a5)
0b28: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
0b2c: d040                 add.w      d0, d0
0b2e: 48c0                 ext.l      d0
0b30: d1adc36e             add.l      d0, -$3c92(a5)
0b34: 588f                 addq.l     #$4, a7
0b36: 601c                 bra.b      $b54
0b38: 4a2dc35e             tst.b      -$3ca2(a5)
0b3c: 6604                 bne.b      $b42
0b3e: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0b42: 486dc35e             pea.l      -$3ca2(a5)
0b46: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
0b4a: d040                 add.w      d0, d0
0b4c: 48c0                 ext.l      d0
0b4e: d1adc372             add.l      d0, -$3c8e(a5)
0b52: 588f                 addq.l     #$4, a7
0b54: 202dc36e             move.l     -$3c92(a5), d0
0b58: d1aee71c             add.l      d0, -$18e4(a6)
0b5c: 222dc372             move.l     -$3c8e(a5), d1
0b60: d3aee718             add.l      d1, -$18e8(a6)
0b64: d081                 add.l      d1, d0
0b66: d1aee728             add.l      d0, -$18d8(a6)
0b6a: 302ee7c8             move.w     -$1838(a6), d0
0b6e: 48c0                 ext.l      d0
0b70: d1aee720             add.l      d0, -$18e0(a6)
0b74: 52aee724             addq.l     #$1, -$18dc(a6)
0b78: b2adc36e             cmp.l      -$3c92(a5), d1
0b7c: 6c08                 bge.b      $b86
0b7e: 54aee714             addq.l     #$2, -$18ec(a6)
0b82: 6000fbc0             bra.w      $744
0b86: 202dc36e             move.l     -$3c92(a5), d0
0b8a: b0adc372             cmp.l      -$3c8e(a5), d0
0b8e: 6c08                 bge.b      $b98
0b90: 54aee710             addq.l     #$2, -$18f0(a6)
0b94: 6000fbae             bra.w      $744
0b98: 52aee710             addq.l     #$1, -$18f0(a6)
0b9c: 52aee714             addq.l     #$1, -$18ec(a6)
0ba0: 6000fba2             bra.w      $744
0ba4: 536da386             subq.w     #$1, -$5c7a(a5)
0ba8: 6042                 bra.b      $bec
0baa: 2f2da222             move.l     -$5dde(a5), -(a7)
0bae: 2f2d93ac             move.l     -$6c54(a5), -(a7)
0bb2: 4ead0db2             jsr        $db2(a5) ; CODE52+0242
0bb6: 4a40                 tst.w      d0
0bb8: 508f                 addq.l     #$8, a7
0bba: 6730                 beq.b      $bec
0bbc: 4a6da386             tst.w      -$5c7a(a5)
0bc0: 6e04                 bgt.b      $bc6
0bc2: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0bc6: 2b6da222a222         move.l     -$5dde(a5), -$5dde(a5)
0bcc: 536da386             subq.w     #$1, -$5c7a(a5)
0bd0: 702c                 moveq      #$2c, d0
0bd2: c1eda386             muls.w     -$5c7a(a5), d0
0bd6: 41eda226             lea.l      -$5dda(a5), a0
0bda: d088                 add.l      a0, d0
0bdc: 2040                 movea.l    d0, a0
0bde: 7001                 moveq      #$1, d0
0be0: 4a40                 tst.w      d0
0be2: 6602                 bne.b      $be6
0be4: 7001                 moveq      #$1, d0
0be6: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
0bea: 4ed1                 jmp        (a1)
0bec: 48780220             pea.l      $220.w
0bf0: 486dbcfe             pea.l      -$4302(a5)
0bf4: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0bf8: 48780440             pea.l      $440.w
0bfc: 486dbf1e             pea.l      -$40e2(a5)
0c00: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0c04: 7008                 moveq      #$8, d0
0c06: 2e80                 move.l     d0, (a7)
0c08: 486dc366             pea.l      -$3c9a(a5)
0c0c: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0c10: 7008                 moveq      #$8, d0
0c12: 2e80                 move.l     d0, (a7)
0c14: 486dc35e             pea.l      -$3ca2(a5)
0c18: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0c1c: 42adc372             clr.l      -$3c8e(a5)
0c20: 42adc36e             clr.l      -$3c92(a5)
0c24: 206dd13c             movea.l    -$2ec4(a5), a0
0c28: 4a68000a             tst.w      $a(a0)
0c2c: 4fef0018             lea.l      $18(a7), a7
0c30: 670e                 beq.b      $c40
0c32: 206dd13c             movea.l    -$2ec4(a5), a0
0c36: 3f28000a             move.w     $a(a0), -(a7)
0c3a: 4eba04dc             jsr        $1118(pc)
0c3e: 548f                 addq.l     #$2, a7
0c40: 4ead040a             jsr        $40a(a5) ; CODE20+03e0
0c44: 4ead0552             jsr        $552(a5) ; CODE21+0052
0c48: 4ead04ea             jsr        $4ea(a5) ; CODE21+1310
0c4c: 4ead03c2             jsr        $3c2(a5) ; CODE20+0cfa
0c50: 4ead06b2             jsr        $6b2(a5) ; CODE9+006a
0c54: 4e5e                 unlk       a6
0c56: 4e75                 rts        
0c58: 4e56f98c             link.w     a6, #$f98c
0c5c: 2b6e0008d13c         move.l     $8(a6), -$2ec4(a5)
0c62: 4ead06aa             jsr        $6aa(a5) ; CODE9+0062
0c66: 206dd13c             movea.l    -$2ec4(a5), a0
0c6a: 4a68000a             tst.w      $a(a0)
0c6e: 671a                 beq.b      $c8a
0c70: 4eba0482             jsr        $10f4(pc)
0c74: 206dd13c             movea.l    -$2ec4(a5), a0
0c78: 3140000a             move.w     d0, $a(a0)
0c7c: 206dd13c             movea.l    -$2ec4(a5), a0
0c80: 3f28000a             move.w     $a(a0), -(a7)
0c84: 4ead059a             jsr        $59a(a5) ; CODE22+0004
0c88: 548f                 addq.l     #$2, a7
0c8a: 42adb3e2             clr.l      -$4c1e(a5)
0c8e: 48780220             pea.l      $220.w
0c92: 486dbcfe             pea.l      -$4302(a5)
0c96: 486efde0             pea.l      -$220(a6)
0c9a: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0c9e: 48780440             pea.l      $440.w
0ca2: 486dbf1e             pea.l      -$40e2(a5)
0ca6: 486ef9a0             pea.l      -$660(a6)
0caa: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0cae: 486dc366             pea.l      -$3c9a(a5)
0cb2: 486ef998             pea.l      -$668(a6)
0cb6: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0cba: 486dc35e             pea.l      -$3ca2(a5)
0cbe: 486ef990             pea.l      -$670(a6)
0cc2: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0cc6: 2d6dc376f98c         move.l     -$3c8a(a5), -$674(a6)
0ccc: 0c6d0008a386         cmpi.w     #$8, -$5c7a(a5)
0cd2: 4fef0028             lea.l      $28(a7), a7
0cd6: 6406                 bcc.b      $cde
0cd8: 4a6da386             tst.w      -$5c7a(a5)
0cdc: 6c04                 bge.b      $ce2
0cde: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0ce2: 302da386             move.w     -$5c7a(a5), d0
0ce6: 526da386             addq.w     #$1, -$5c7a(a5)
0cea: c1fc002c             muls.w     #$2c, d0
0cee: 41eda226             lea.l      -$5dda(a5), a0
0cf2: d088                 add.l      a0, d0
0cf4: 2040                 movea.l    d0, a0
0cf6: 7000                 moveq      #$0, d0
0cf8: 43fa0006             lea.l      $d00(pc), a1
0cfc: 48d0def8             movem.l    d3-d7/a1-a4/a6-a7, (a0)
0d00: 4a40                 tst.w      d0
0d02: 6640                 bne.b      $d44
0d04: 206dd13c             movea.l    -$2ec4(a5), a0
0d08: 4a680010             tst.w      $10(a0)
0d0c: 6726                 beq.b      $d34
0d0e: 486d00ba             pea.l      $ba(a5)
0d12: 4ead0a42             jsr        $a42(a5) ; CODE38+0046
0d16: 206dd13c             movea.l    -$2ec4(a5), a0
0d1a: 4aa80004             tst.l      $4(a0)
0d1e: 588f                 addq.l     #$4, a7
0d20: 671c                 beq.b      $d3e
0d22: 2f2dd13c             move.l     -$2ec4(a5), -(a7)
0d26: 206dd13c             movea.l    -$2ec4(a5), a0
0d2a: 20680004             movea.l    $4(a0), a0
0d2e: 4e90                 jsr        (a0)
0d30: 588f                 addq.l     #$4, a7
0d32: 600a                 bra.b      $d3e
0d34: 486d00ba             pea.l      $ba(a5)
0d38: 4ead0a4a             jsr        $a4a(a5) ; CODE38+000e
0d3c: 588f                 addq.l     #$4, a7
0d3e: 536da386             subq.w     #$1, -$5c7a(a5)
0d42: 6042                 bra.b      $d86
0d44: 2f2da222             move.l     -$5dde(a5), -(a7)
0d48: 2f2d93ac             move.l     -$6c54(a5), -(a7)
0d4c: 4ead0db2             jsr        $db2(a5) ; CODE52+0242
0d50: 4a40                 tst.w      d0
0d52: 508f                 addq.l     #$8, a7
0d54: 6730                 beq.b      $d86
0d56: 4a6da386             tst.w      -$5c7a(a5)
0d5a: 6e04                 bgt.b      $d60
0d5c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0d60: 2b6da222a222         move.l     -$5dde(a5), -$5dde(a5)
0d66: 536da386             subq.w     #$1, -$5c7a(a5)
0d6a: 702c                 moveq      #$2c, d0
0d6c: c1eda386             muls.w     -$5c7a(a5), d0
0d70: 41eda226             lea.l      -$5dda(a5), a0
0d74: d088                 add.l      a0, d0
0d76: 2040                 movea.l    d0, a0
0d78: 7001                 moveq      #$1, d0
0d7a: 4a40                 tst.w      d0
0d7c: 6602                 bne.b      $d80
0d7e: 7001                 moveq      #$1, d0
0d80: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
0d84: 4ed1                 jmp        (a1)
0d86: 48780220             pea.l      $220.w
0d8a: 486efde0             pea.l      -$220(a6)
0d8e: 486dbcfe             pea.l      -$4302(a5)
0d92: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0d96: 48780440             pea.l      $440.w
0d9a: 486ef9a0             pea.l      -$660(a6)
0d9e: 486dbf1e             pea.l      -$40e2(a5)
0da2: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0da6: 486ef998             pea.l      -$668(a6)
0daa: 486dc366             pea.l      -$3c9a(a5)
0dae: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0db2: 486ef990             pea.l      -$670(a6)
0db6: 486dc35e             pea.l      -$3ca2(a5)
0dba: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0dbe: 2b6ef98cc376         move.l     -$674(a6), -$3c8a(a5)
0dc4: 41edc366             lea.l      -$3c9a(a5), a0
0dc8: b1edc376             cmpa.l     -$3c8a(a5), a0
0dcc: 4fef0028             lea.l      $28(a7), a7
0dd0: 6704                 beq.b      $dd6
0dd2: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0dd6: 2f2dc376             move.l     -$3c8a(a5), -(a7)
0dda: 4ead096a             jsr        $96a(a5) ; CODE31+0992
0dde: 4ead099a             jsr        $99a(a5) ; CODE32+0efa
0de2: 206dd13c             movea.l    -$2ec4(a5), a0
0de6: 4a68000a             tst.w      $a(a0)
0dea: 588f                 addq.l     #$4, a7
0dec: 670e                 beq.b      $dfc
0dee: 206dd13c             movea.l    -$2ec4(a5), a0
0df2: 3f28000a             move.w     $a(a0), -(a7)
0df6: 4eba0320             jsr        $1118(pc)
0dfa: 548f                 addq.l     #$2, a7
0dfc: 206dd13c             movea.l    -$2ec4(a5), a0
0e00: 4a680016             tst.w      $16(a0)
0e04: 6708                 beq.b      $e0e
0e06: 4ead040a             jsr        $40a(a5) ; CODE20+03e0
0e0a: 4ead0552             jsr        $552(a5) ; CODE21+0052
0e0e: 4ead06b2             jsr        $6b2(a5) ; CODE9+006a
0e12: 4e5e                 unlk       a6
0e14: 4e75                 rts        
0e16: 4e560000             link.w     a6, #$0
0e1a: 4ebaf338             jsr        $154(pc)
0e1e: 4e5e                 unlk       a6
0e20: 4e75                 rts        
0e22: 4e56ff80             link.w     a6, #$ff80
0e26: 2f0c                 move.l     a4, -(a7)
0e28: 3f3c0004             move.w     #$4, -(a7)
0e2c: 2f2d9078             move.l     -$6f88(a5), -(a7)
0e30: 4ead05f2             jsr        $5f2(a5) ; CODE9+0d64
0e34: 2e80                 move.l     d0, (a7)
0e36: 4267                 clr.w      -(a7)
0e38: a963                 dc.w       $a963
0e3a: 3ebc0003             move.w     #$3, (a7)
0e3e: 2f2d9078             move.l     -$6f88(a5), -(a7)
0e42: 4ead05f2             jsr        $5f2(a5) ; CODE9+0d64
0e46: 2e80                 move.l     d0, (a7)
0e48: 4267                 clr.w      -(a7)
0e4a: a963                 dc.w       $a963
0e4c: 3ebc0002             move.w     #$2, (a7)
0e50: 2f2d9078             move.l     -$6f88(a5), -(a7)
0e54: 4ead05f2             jsr        $5f2(a5) ; CODE9+0d64
0e58: 2e80                 move.l     d0, (a7)
0e5a: 4267                 clr.w      -(a7)
0e5c: a963                 dc.w       $a963
0e5e: 3ebc000a             move.w     #$a, (a7)
0e62: 2f2d9078             move.l     -$6f88(a5), -(a7)
0e66: 4ead05f2             jsr        $5f2(a5) ; CODE9+0d64
0e6a: 2e80                 move.l     d0, (a7)
0e6c: 4267                 clr.w      -(a7)
0e6e: a963                 dc.w       $a963
0e70: 3ebc0008             move.w     #$8, (a7)
0e74: 2f2d9078             move.l     -$6f88(a5), -(a7)
0e78: 4ead05f2             jsr        $5f2(a5) ; CODE9+0d64
0e7c: 2840                 movea.l    d0, a4
0e7e: 2e8c                 move.l     a4, (a7)
0e80: 4267                 clr.w      -(a7)
0e82: a963                 dc.w       $a963
0e84: 486dc366             pea.l      -$3c9a(a5)
0e88: 4ead096a             jsr        $96a(a5) ; CODE31+0992
0e8c: 2e8c                 move.l     a4, (a7)
0e8e: 486eff80             pea.l      -$80(a6)
0e92: 4ead095a             jsr        $95a(a5) ; CODE31+075c
0e96: 0c40000c             cmpi.w     #$c, d0
0e9a: 588f                 addq.l     #$4, a7
0e9c: 6f06                 ble.b      $ea4
0e9e: 303c00ff             move.w     #$ff, d0
0ea2: 6002                 bra.b      $ea6
0ea4: 7000                 moveq      #$0, d0
0ea6: 3f00                 move.w     d0, -(a7)
0ea8: a95d                 dc.w       $a95d
0eaa: 486d907c             pea.l      -$6f84(a5)
0eae: 3f3c0005             move.w     #$5, -(a7)
0eb2: 2f2d9078             move.l     -$6f88(a5), -(a7)
0eb6: 4ead063a             jsr        $63a(a5) ; CODE9+0d86
0eba: 286eff7c             movea.l    -$84(a6), a4
0ebe: 4e5e                 unlk       a6
0ec0: 4e75                 rts        
0ec2: 4e560000             link.w     a6, #$0
0ec6: 2f2e000c             move.l     $c(a6), -(a7)
0eca: 2f2e0008             move.l     $8(a6), -(a7)
0ece: 4ead0d0a             jsr        $d0a(a5) ; CODE48+0376
0ed2: 2eada1f6             move.l     -$5e0a(a5), (a7)
0ed6: 3f3c0005             move.w     #$5, -(a7)
0eda: 2f2e0008             move.l     $8(a6), -(a7)
0ede: 4ead0cd2             jsr        $cd2(a5) ; CODE48+0138
0ee2: 4e5e                 unlk       a6
0ee4: 4e75                 rts        
0ee6: 4e560000             link.w     a6, #$0
0eea: 42a7                 clr.l      -(a7)
0eec: 486d0092             pea.l      $92(a5)
0ef0: 2f2da21e             move.l     -$5de2(a5), -(a7)
0ef4: 3f3c03f7             move.w     #$3f7, -(a7)
0ef8: 4ead0c92             jsr        $c92(a5) ; CODE41+0022
0efc: 4e5e                 unlk       a6
0efe: 4e75                 rts        
0f00: 4e56fffe             link.w     a6, #$fffe
0f04: 2b6e00089078         move.l     $8(a6), -$6f88(a5)
0f0a: 4ebaff16             jsr        $e22(pc)
0f0e: 486d0c8a             pea.l      $c8a(a5)
0f12: 486efffe             pea.l      -$2(a6)
0f16: a991                 dc.w       $a991
0f18: 302efffe             move.w     -$2(a6), d0
0f1c: 0c40000b             cmpi.w     #$b, d0
0f20: 62ec                 bhi.b      $f0e
0f22: 43fa0030             lea.l      $f54(pc), a1
0f26: d040                 add.w      d0, d0
0f28: d2f10000             adda.w     (a1, d0.w), a1
0f2c: 4ed1                 jmp        (a1)
0f2e: 4ebaf338             jsr        $268(pc)
0f32: 601c                 bra.b      $f50
0f34: 4ebafeec             jsr        $e22(pc)
0f38: 60d4                 bra.b      $f0e
0f3a: 3f2efffe             move.w     -$2(a6), -(a7)
0f3e: 2f2d9078             move.l     -$6f88(a5), -(a7)
0f42: 4ead05f2             jsr        $5f2(a5) ; CODE9+0d64
0f46: 2e80                 move.l     d0, (a7)
0f48: 4ead05d2             jsr        $5d2(a5) ; CODE9+0212
0f4c: 5c8f                 addq.l     #$6, a7
0f4e: 60be                 bra.b      $f0e
0f50: 4e5e                 unlk       a6
0f52: 4e75                 rts        
0f54: ffba                 dc.w       $ffba
0f56: ffda                 dc.w       $ffda
0f58: ffe6                 dc.w       $ffe6
0f5a: ffe6                 dc.w       $ffe6
0f5c: ffe6                 dc.w       $ffe6
0f5e: ffba                 dc.w       $ffba
0f60: ffe0                 dc.w       $ffe0
0f62: ffba                 dc.w       $ffba
0f64: ffe6                 dc.w       $ffe6
0f66: ffba                 dc.w       $ffba
0f68: ffe6                 dc.w       $ffe6
0f6a: fffc                 dc.w       $fffc
0f6c: 4e56fdfc             link.w     a6, #$fdfc
0f70: 48e70f38             movem.l    d4-d7/a2-a4, -(a7)
0f74: 286e0008             movea.l    $8(a6), a4
0f78: 3f3c0004             move.w     #$4, -(a7)
0f7c: 2f2d9078             move.l     -$6f88(a5), -(a7)
0f80: 4ead05e2             jsr        $5e2(a5) ; CODE9+0d3c
0f84: 39400012             move.w     d0, $12(a4)
0f88: 3ebc0003             move.w     #$3, (a7)
0f8c: 2f2d9078             move.l     -$6f88(a5), -(a7)
0f90: 4ead05e2             jsr        $5e2(a5) ; CODE9+0d3c
0f94: 39400014             move.w     d0, $14(a4)
0f98: 3ebc0002             move.w     #$2, (a7)
0f9c: 2f2d9078             move.l     -$6f88(a5), -(a7)
0fa0: 4ead05e2             jsr        $5e2(a5) ; CODE9+0d3c
0fa4: 3940000a             move.w     d0, $a(a4)
0fa8: 3ebc0008             move.w     #$8, (a7)
0fac: 2f2d9078             move.l     -$6f88(a5), -(a7)
0fb0: 4ead05e2             jsr        $5e2(a5) ; CODE9+0d3c
0fb4: 39400010             move.w     d0, $10(a4)
0fb8: 3ebc000a             move.w     #$a, (a7)
0fbc: 2f2d9078             move.l     -$6f88(a5), -(a7)
0fc0: 4ead05e2             jsr        $5e2(a5) ; CODE9+0d3c
0fc4: 39400016             move.w     d0, $16(a4)
0fc8: 486eff00             pea.l      -$100(a6)
0fcc: 3f3c0005             move.w     #$5, -(a7)
0fd0: 2f2d9078             move.l     -$6f88(a5), -(a7)
0fd4: 4ead0642             jsr        $642(a5) ; CODE9+0dea
0fd8: 486c0008             pea.l      $8(a4)
0fdc: 486d907e             pea.l      -$6f82(a5)
0fe0: 486eff00             pea.l      -$100(a6)
0fe4: 4ead081a             jsr        $81a(a5) ; CODE24+16fa
0fe8: 4297                 clr.l      (a7)
0fea: 48780007             pea.l      $7.w
0fee: 2f2d9078             move.l     -$6f88(a5), -(a7)
0ff2: 4ead01ea             jsr        $1ea(a5) ; CODE11+005c
0ff6: 3ebc0121             move.w     #$121, (a7)
0ffa: 486dd76c             pea.l      -$2894(a5)
0ffe: 4ead0d7a             jsr        $d7a(a5) ; CODE54+0004
1002: 4a40                 tst.w      d0
1004: 4fef0038             lea.l      $38(a7), a7
1008: 6708                 beq.b      $1012
100a: 4a6dde28             tst.w      -$21d8(a5)
100e: 67000088             beq.w      $1098
1012: 42a7                 clr.l      -(a7)
1014: 206ddeb8             movea.l    -$2148(a5), a0
1018: 2f2800ca             move.l     $ca(a0), -(a7)
101c: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
1020: 2d5ffdfc             move.l     (a7)+, -$204(a6)
1024: 48780006             pea.l      $6.w
1028: 2f2efdfc             move.l     -$204(a6), -(a7)
102c: 4ead004a             jsr        $4a(a5) ; CODE1+0124
1030: 3a00                 move.w     d0, d5
1032: 0c450040             cmpi.w     #$40, d5
1036: 6f02                 ble.b      $103a
1038: 7a40                 moveq      #$40, d5
103a: 397c0078000e         move.w     #$78, $e(a4)
1040: 3945000c             move.w     d5, $c(a4)
1044: 28bc0bebc200         move.l     #$bebc200, (a4)
104a: 41ed00b2             lea.l      $b2(a5), a0
104e: 29480004             move.l     a0, $4(a4)
1052: 7800                 moveq      #$0, d4
1054: 97cb                 suba.l     a3, a3
1056: 7e00                 moveq      #$0, d7
1058: 603a                 bra.b      $1094
105a: 206ddeb8             movea.l    -$2148(a5), a0
105e: 206800ca             movea.l    $ca(a0), a0
1062: 2050                 movea.l    (a0), a0
1064: 20707802             movea.l    $2(a0, d7.l), a0
1068: 2450                 movea.l    (a0), a2
106a: 41eb0018             lea.l      $18(a3), a0
106e: d1cc                 adda.l     a4, a0
1070: 2c08                 move.l     a0, d6
1072: 7022                 moveq      #$22, d0
1074: 2246                 movea.l    d6, a1
1076: 204a                 movea.l    a2, a0
1078: a02e                 dc.w       $a02e
107a: 202a0010             move.l     $10(a2), d0
107e: d0aa0014             add.l      $14(a2), d0
1082: d0aa0018             add.l      $18(a2), d0
1086: 2046                 movea.l    d6, a0
1088: 21400022             move.l     d0, $22(a0)
108c: 5244                 addq.w     #$1, d4
108e: 47eb002e             lea.l      $2e(a3), a3
1092: 5c87                 addq.l     #$6, d7
1094: ba44                 cmp.w      d4, d5
1096: 6ec2                 bgt.b      $105a
1098: 4cdf1cf0             movem.l    (a7)+, d4-d7/a2-a4
109c: 4e5e                 unlk       a6
109e: 4e75                 rts        
10a0: 4e56ff7c             link.w     a6, #$ff7c
10a4: 2f0c                 move.l     a4, -(a7)
10a6: 286e0008             movea.l    $8(a6), a4
10aa: 2f0c                 move.l     a4, -(a7)
10ac: 2f0c                 move.l     a4, -(a7)
10ae: 4a2c0020             tst.b      $20(a4)
10b2: 6704                 beq.b      $10b8
10b4: 70fc                 moveq      #$fc, d0
10b6: 6002                 bra.b      $10ba
10b8: 7000                 moveq      #$0, d0
10ba: 3f00                 move.w     d0, -(a7)
10bc: 2f0c                 move.l     a4, -(a7)
10be: 486d9082             pea.l      -$6f7e(a5)
10c2: 486eff80             pea.l      -$80(a6)
10c6: 4ead0812             jsr        $812(a5) ; CODE24+16a6
10ca: 3040                 movea.w    d0, a0
10cc: 2d48ff7c             move.l     a0, -$84(a6)
10d0: 4257                 clr.w      (a7)
10d2: 3f2e000c             move.w     $c(a6), -(a7)
10d6: 486eff7c             pea.l      -$84(a6)
10da: 486eff80             pea.l      -$80(a6)
10de: 4ead0b32             jsr        $b32(a5) ; CODE34+0230
10e2: 4a5f                 tst.w      (a7)+
10e4: 4fef0014             lea.l      $14(a7), a7
10e8: 6704                 beq.b      $10ee
10ea: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
10ee: 285f                 movea.l    (a7)+, a4
10f0: 4e5e                 unlk       a6
10f2: 4e75                 rts        
10f4: 4e56fffe             link.w     a6, #$fffe
10f8: 2f3c54455854         move.l     #$54455854, -(a7)
10fe: 3f3c0001             move.w     #$1, -(a7)
1102: 486efffe             pea.l      -$2(a6)
1106: 4267                 clr.w      -(a7)
1108: 486d9092             pea.l      -$6f6e(a5)
110c: 4ead0d32             jsr        $d32(a5) ; CODE47+016c
1110: 302efffe             move.w     -$2(a6), d0
1114: 4e5e                 unlk       a6
1116: 4e75                 rts        
1118: 4e560000             link.w     a6, #$0
111c: 4267                 clr.w      -(a7)
111e: 3f2e0008             move.w     $8(a6), -(a7)
1122: 4ead0b22             jsr        $b22(a5) ; CODE34+0212
1126: 4e5e                 unlk       a6
1128: 4e75                 rts        
