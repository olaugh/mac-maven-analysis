0004: 4e560000             link.w     a6, #$0
0008: 2f0c                 move.l     a4, -(a7)
000a: 286df51e             movea.l    -$ae2(a5), a4
000e: 600c                 bra.b      $1c
0010: 2f0c                 move.l     a4, -(a7)
0012: 206e0008             movea.l    $8(a6), a0
0016: 4e90                 jsr        (a0)
0018: 588f                 addq.l     #$4, a7
001a: 2854                 movea.l    (a4), a4
001c: 200c                 move.l     a4, d0
001e: 66f0                 bne.b      $10
0020: 285f                 movea.l    (a7)+, a4
0022: 4e5e                 unlk       a6
0024: 4e75                 rts        
0026: 4e56fffc             link.w     a6, #$fffc
002a: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
002e: 246e0008             movea.l    $8(a6), a2
0032: 206e0014             movea.l    $14(a6), a0
0036: 4250                 clr.w      (a0)
0038: 7e00                 moveq      #$0, d7
003a: 4ead0ab2             jsr        $ab2(a5) ; CODE43+00aa
003e: 2a3c0bebc200         move.l     #$bebc200, d5
0044: 2c05                 move.l     d5, d6
0046: 49edf51e             lea.l      -$ae2(a5), a4
004a: 600000a0             bra.w      $ec
004e: 2f0a                 move.l     a2, -(a7)
0050: 2f0b                 move.l     a3, -(a7)
0052: 4ead0aa2             jsr        $aa2(a5) ; CODE43+0004
0056: 4a80                 tst.l      d0
0058: 508f                 addq.l     #$8, a7
005a: 6600008e             bne.w      $ea
005e: 4a2b0008             tst.b      $8(a3)
0062: 6726                 beq.b      $8a
0064: 204d                 movea.l    a5, a0
0066: 302a001e             move.w     $1e(a2), d0
006a: d0c0                 adda.w     d0, a0
006c: d0c0                 adda.w     d0, a0
006e: 3068cbfa             movea.w    -$3406(a0), a0
0072: d1c8                 adda.l     a0, a0
0074: 262a0010             move.l     $10(a2), d3
0078: 96ab0004             sub.l      $4(a3), d3
007c: 9688                 sub.l      a0, d3
007e: 2803                 move.l     d3, d4
0080: 206e0014             movea.l    $14(a6), a0
0084: 30bc0001             move.w     #$1, (a0)
0088: 6036                 bra.b      $c0
008a: 486efffc             pea.l      -$4(a6)
008e: 486efffe             pea.l      -$2(a6)
0092: 102b0009             move.b     $9(a3), d0
0096: 4880                 ext.w      d0
0098: 3f00                 move.w     d0, -(a7)
009a: 3f2a001e             move.w     $1e(a2), -(a7)
009e: 4ead0a6a             jsr        $a6a(a5) ; CODE39+068c
00a2: 262a0010             move.l     $10(a2), d3
00a6: 96ab0004             sub.l      $4(a3), d3
00aa: 3040                 movea.w    d0, a0
00ac: d688                 add.l      a0, d3
00ae: 2803                 move.l     d3, d4
00b0: 306efffe             movea.w    -$2(a6), a0
00b4: d888                 add.l      a0, d4
00b6: 306efffc             movea.w    -$4(a6), a0
00ba: 9688                 sub.l      a0, d3
00bc: 4fef000c             lea.l      $c(a7), a7
00c0: bc84                 cmp.l      d4, d6
00c2: 6f02                 ble.b      $c6
00c4: 2c04                 move.l     d4, d6
00c6: ba83                 cmp.l      d3, d5
00c8: 6f02                 ble.b      $cc
00ca: 2a03                 move.l     d3, d5
00cc: 206e000c             movea.l    $c(a6), a0
00d0: bc90                 cmp.l      (a0), d6
00d2: 6c16                 bge.b      $ea
00d4: 206e0010             movea.l    $10(a6), a0
00d8: ba90                 cmp.l      (a0), d5
00da: 6c0e                 bge.b      $ea
00dc: 2893                 move.l     (a3), (a4)
00de: 26adf51e             move.l     -$ae2(a5), (a3)
00e2: 2b4bf51e             move.l     a3, -$ae2(a5)
00e6: 7e01                 moveq      #$1, d7
00e8: 600a                 bra.b      $f4
00ea: 284b                 movea.l    a3, a4
00ec: 2654                 movea.l    (a4), a3
00ee: 200b                 move.l     a3, d0
00f0: 6600ff5c             bne.w      $4e
00f4: 0c860bebc200         cmpi.l     #$bebc200, d6
00fa: 6632                 bne.b      $12e
00fc: 486efffc             pea.l      -$4(a6)
0100: 486efffe             pea.l      -$2(a6)
0104: 3f2a001e             move.w     $1e(a2), -(a7)
0108: 4ead0a62             jsr        $a62(a5) ; CODE39+051a
010c: 48c0                 ext.l      d0
010e: d0aa0010             add.l      $10(a2), d0
0112: 2a00                 move.l     d0, d5
0114: 2c00                 move.l     d0, d6
0116: 306efffe             movea.w    -$2(a6), a0
011a: dc88                 add.l      a0, d6
011c: 306efffc             movea.w    -$4(a6), a0
0120: 9a88                 sub.l      a0, d5
0122: 206e0018             movea.l    $18(a6), a0
0126: 4250                 clr.w      (a0)
0128: 4fef000a             lea.l      $a(a7), a7
012c: 6008                 bra.b      $136
012e: 206e0018             movea.l    $18(a6), a0
0132: 30bc0001             move.w     #$1, (a0)
0136: 206e000c             movea.l    $c(a6), a0
013a: 2086                 move.l     d6, (a0)
013c: 226e0010             movea.l    $10(a6), a1
0140: 2285                 move.l     d5, (a1)
0142: 3007                 move.w     d7, d0
0144: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0148: 4e5e                 unlk       a6
014a: 4e75                 rts        
014c: 4e560000             link.w     a6, #$0
0150: 48e70018             movem.l    a3-a4, -(a7)
0154: 286e0008             movea.l    $8(a6), a4
0158: 266e000c             movea.l    $c(a6), a3
015c: 102c0009             move.b     $9(a4), d0
0160: b02b0009             cmp.b      $9(a3), d0
0164: 661e                 bne.b      $184
0166: 102c000a             move.b     $a(a4), d0
016a: b02b000a             cmp.b      $a(a3), d0
016e: 6614                 bne.b      $184
0170: 102c000b             move.b     $b(a4), d0
0174: b02b000b             cmp.b      $b(a3), d0
0178: 660a                 bne.b      $184
017a: 102c000c             move.b     $c(a4), d0
017e: b02b000c             cmp.b      $c(a3), d0
0182: 6704                 beq.b      $188
0184: 7000                 moveq      #$0, d0
0186: 6002                 bra.b      $18a
0188: 7001                 moveq      #$1, d0
018a: 4cdf1800             movem.l    (a7)+, a3-a4
018e: 4e5e                 unlk       a6
0190: 4e75                 rts        
0192: 4e560000             link.w     a6, #$0
0196: 48e70018             movem.l    a3-a4, -(a7)
019a: 286e0008             movea.l    $8(a6), a4
019e: 266e000c             movea.l    $c(a6), a3
01a2: 196b001d0008         move.b     $1d(a3), $8(a4)
01a8: 296b00100004         move.l     $10(a3), $4(a4)
01ae: 196b0020000a         move.b     $20(a3), $a(a4)
01b4: 196b0021000b         move.b     $21(a3), $b(a4)
01ba: 2f0b                 move.l     a3, -(a7)
01bc: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
01c0: 1940000c             move.b     d0, $c(a4)
01c4: 196b001f0009         move.b     $1f(a3), $9(a4)
01ca: 4cee1800fff8         movem.l    -$8(a6), a3-a4
01d0: 4e5e                 unlk       a6
01d2: 4e75                 rts        
01d4: 4e560000             link.w     a6, #$0
01d8: 48e70738             movem.l    d5-d7/a2-a4, -(a7)
01dc: 2e2e0008             move.l     $8(a6), d7
01e0: 2847                 movea.l    d7, a4
01e2: 7c00                 moveq      #$0, d6
01e4: 2447                 movea.l    d7, a2
01e6: 45ea0e00             lea.l      $e00(a2), a2
01ea: 42adf51e             clr.l      -$ae2(a5)
01ee: 6020                 bra.b      $210
01f0: 4a2a000a             tst.b      $a(a2)
01f4: 671a                 beq.b      $210
01f6: 0c460100             cmpi.w     #$100, d6
01fa: 6d04                 blt.b      $200
01fc: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0200: 3006                 move.w     d6, d0
0202: 5246                 addq.w     #$1, d6
0204: 1540000d             move.b     d0, $d(a2)
0208: 24adf51e             move.l     -$ae2(a5), (a2)
020c: 2b4af51e             move.l     a2, -$ae2(a5)
0210: 45eafff2             lea.l      -$e(a2), a2
0214: b9ca                 cmpa.l     a2, a4
0216: 63d8                 bls.b      $1f0
0218: 7a00                 moveq      #$0, d5
021a: 49eda5f0             lea.l      -$5a10(a5), a4
021e: 47edf492             lea.l      -$b6e(a5), a3
0222: 605e                 bra.b      $282
0224: 244b                 movea.l    a3, a2
0226: 2f0c                 move.l     a4, -(a7)
0228: 2f0a                 move.l     a2, -(a7)
022a: 4ebaff66             jsr        $192(pc)
022e: 102a0009             move.b     $9(a2), d0
0232: 4880                 ext.w      d0
0234: c1fc001c             muls.w     #$1c, d0
0238: d087                 add.l      d7, d0
023a: 2e80                 move.l     d0, (a7)
023c: 2f0a                 move.l     a2, -(a7)
023e: 4ebaff0c             jsr        $14c(pc)
0242: 4a40                 tst.w      d0
0244: 4fef000c             lea.l      $c(a7), a7
0248: 662e                 bne.b      $278
024a: 102a0009             move.b     $9(a2), d0
024e: 4880                 ext.w      d0
0250: c1fc001c             muls.w     #$1c, d0
0254: d087                 add.l      d7, d0
0256: 2040                 movea.l    d0, a0
0258: 4868000e             pea.l      $e(a0)
025c: 2f0a                 move.l     a2, -(a7)
025e: 4ebafeec             jsr        $14c(pc)
0262: 4a40                 tst.w      d0
0264: 508f                 addq.l     #$8, a7
0266: 6610                 bne.b      $278
0268: 3006                 move.w     d6, d0
026a: 5246                 addq.w     #$1, d6
026c: 1540000d             move.b     d0, $d(a2)
0270: 24adf51e             move.l     -$ae2(a5), (a2)
0274: 2b4af51e             move.l     a2, -$ae2(a5)
0278: 5245                 addq.w     #$1, d5
027a: 49ec0022             lea.l      $22(a4), a4
027e: 47eb000e             lea.l      $e(a3), a3
0282: ba6dcf04             cmp.w      -$30fc(a5), d5
0286: 6c06                 bge.b      $28e
0288: 0c460100             cmpi.w     #$100, d6
028c: 6d96                 blt.b      $224
028e: 202df51e             move.l     -$ae2(a5), d0
0292: 4cdf1ce0             movem.l    (a7)+, d5-d7/a2-a4
0296: 4e5e                 unlk       a6
0298: 4e75                 rts        
