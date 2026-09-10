0004: 4e560000             link.w     a6, #$0
0008: 48e70138             movem.l    d7/a2-a4, -(a7)
000c: 286e0008             movea.l    $8(a6), a4
0010: 2e2c0014             move.l     $14(a4), d7
0014: deac0010             add.l      $10(a4), d7
0018: deac0018             add.l      $18(a4), d7
001c: 0c6d000acf04         cmpi.w     #$a, -$30fc(a5)
0022: 6608                 bne.b      $2c
0024: beadf522             cmp.l      -$ade(a5), d7
0028: 6f0000b6             ble.w      $e0
002c: 2f0c                 move.l     a4, -(a7)
002e: 4ead0aca             jsr        $aca(a5) ; CODE44+00ee
0032: 4a40                 tst.w      d0
0034: 588f                 addq.l     #$4, a7
0036: 670000a8             beq.w      $e0
003a: 0c6d000acf04         cmpi.w     #$a, -$30fc(a5)
0040: 661c                 bne.b      $5e
0042: 47eda5f0             lea.l      -$5a10(a5), a3
0046: 6004                 bra.b      $4c
0048: 47eb0022             lea.l      $22(a3), a3
004c: 202b0010             move.l     $10(a3), d0
0050: d0ab0014             add.l      $14(a3), d0
0054: d0ab0018             add.l      $18(a3), d0
0058: b087                 cmp.l      d7, d0
005a: 6cec                 bge.b      $48
005c: 6030                 bra.b      $8e
005e: 47eda5f0             lea.l      -$5a10(a5), a3
0062: 7022                 moveq      #$22, d0
0064: c1edcf04             muls.w     -$30fc(a5), d0
0068: 45eda5f0             lea.l      -$5a10(a5), a2
006c: d08a                 add.l      a2, d0
006e: 2440                 movea.l    d0, a2
0070: 6004                 bra.b      $76
0072: 47eb0022             lea.l      $22(a3), a3
0076: b5cb                 cmpa.l     a3, a2
0078: 6310                 bls.b      $8a
007a: 202b0010             move.l     $10(a3), d0
007e: d0ab0014             add.l      $14(a3), d0
0082: d0ab0018             add.l      $18(a3), d0
0086: b087                 cmp.l      d7, d0
0088: 6ce8                 bge.b      $72
008a: 526dcf04             addq.w     #$1, -$30fc(a5)
008e: 48780022             pea.l      $22.w
0092: 48780022             pea.l      $22.w
0096: 41eda5f0             lea.l      -$5a10(a5), a0
009a: 200b                 move.l     a3, d0
009c: 9088                 sub.l      a0, d0
009e: 2f00                 move.l     d0, -(a7)
00a0: 4ead005a             jsr        $5a(a5) ; CODE1+0166
00a4: 306dcf04             movea.w    -$30fc(a5), a0
00a8: 5388                 subq.l     #$1, a0
00aa: 91c0                 suba.l     d0, a0
00ac: 2f08                 move.l     a0, -(a7)
00ae: 4ead0042             jsr        $42(a5) ; CODE1+00ee
00b2: 2f00                 move.l     d0, -(a7)
00b4: 2f0b                 move.l     a3, -(a7)
00b6: 486b0022             pea.l      $22(a3)
00ba: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
00be: 41d3                 lea.l      (a3), a0
00c0: 43d4                 lea.l      (a4), a1
00c2: 7007                 moveq      #$7, d0
00c4: 20d9                 move.l     (a1)+, (a0)+
00c6: 51c8fffc             dbra       d0, $c4
00ca: 30d9                 move.w     (a1)+, (a0)+
00cc: 47eda722             lea.l      -$58de(a5), a3
00d0: 202b0010             move.l     $10(a3), d0
00d4: d0ab0014             add.l      $14(a3), d0
00d8: d0ab0018             add.l      $18(a3), d0
00dc: 2b40f522             move.l     d0, -$ade(a5)
00e0: 4cee1c80fff0         movem.l    -$10(a6), d7/a2-a4
00e6: 4e5e                 unlk       a6
00e8: 4e75                 rts        
00ea: 4e560000             link.w     a6, #$0
00ee: 48e70300             movem.l    d6-d7, -(a7)
00f2: 7e00                 moveq      #$0, d7
00f4: 600e                 bra.b      $104
00f6: 1006                 move.b     d6, d0
00f8: 4880                 ext.w      d0
00fa: 204d                 movea.l    a5, a0
00fc: d0c0                 adda.w     d0, a0
00fe: d0c0                 adda.w     d0, a0
0100: de689412             add.w      -$6bee(a0), d7
0104: 206e0008             movea.l    $8(a6), a0
0108: 52ae0008             addq.l     #$1, $8(a6)
010c: 1c10                 move.b     (a0), d6
010e: 66e6                 bne.b      $f6
0110: 3007                 move.w     d7, d0
0112: 4cdf00c0             movem.l    (a7)+, d6-d7
0116: 4e5e                 unlk       a6
0118: 4e75                 rts        
011a: 4e56fdf0             link.w     a6, #$fdf0
011e: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0122: 286e0008             movea.l    $8(a6), a4
0126: 266e000c             movea.l    $c(a6), a3
012a: 2f0c                 move.l     a4, -(a7)
012c: 4ead096a             jsr        $96a(a5) ; CODE31+0992
0130: 486eff7c             pea.l      -$84(a6)
0134: 4ead095a             jsr        $95a(a5) ; CODE31+075c
0138: 1800                 move.b     d0, d4
013a: 4ead099a             jsr        $99a(a5) ; CODE32+0efa
013e: 48780154             pea.l      $154.w
0142: 486da5f0             pea.l      -$5a10(a5)
0146: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
014a: 7022                 moveq      #$22, d0
014c: 2e80                 move.l     d0, (a7)
014e: 486eff4a             pea.l      -$b6(a6)
0152: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0156: 426dcf04             clr.w      -$30fc(a5)
015a: 426db1d6             clr.w      -$4e2a(a5)
015e: 2b7cf4143e00a600     move.l     #$f4143e00, -$5a00(a5)
0166: 4ead0932             jsr        $932(a5) ; CODE31+0108
016a: 4a40                 tst.w      d0
016c: 4fef0014             lea.l      $14(a7), a7
0170: 670a                 beq.b      $17c
0172: 2f0b                 move.l     a3, -(a7)
0174: 4ead09ba             jsr        $9ba(a5) ; CODE32+1304
0178: 588f                 addq.l     #$4, a7
017a: 6046                 bra.b      $1c2
017c: 4ead093a             jsr        $93a(a5) ; CODE31+0118
0180: 4a40                 tst.w      d0
0182: 673e                 beq.b      $1c2
0184: 41edc366             lea.l      -$3c9a(a5), a0
0188: b1cc                 cmpa.l     a4, a0
018a: 6608                 bne.b      $194
018c: 41edc35e             lea.l      -$3ca2(a5), a0
0190: 2008                 move.l     a0, d0
0192: 6006                 bra.b      $19a
0194: 41edc366             lea.l      -$3c9a(a5), a0
0198: 2008                 move.l     a0, d0
019a: 2f00                 move.l     d0, -(a7)
019c: 4ebaff4c             jsr        $ea(pc)
01a0: 4440                 neg.w      d0
01a2: 3d40fdf0             move.w     d0, -$210(a6)
01a6: 2e8c                 move.l     a4, (a7)
01a8: 4ebaff40             jsr        $ea(pc)
01ac: d040                 add.w      d0, d0
01ae: 322efdf0             move.w     -$210(a6), d1
01b2: 9240                 sub.w      d0, d1
01b4: 3041                 movea.w    d1, a0
01b6: 2d48ff5e             move.l     a0, -$a2(a6)
01ba: 486eff4a             pea.l      -$b6(a6)
01be: 4e93                 jsr        (a3)
01c0: 508f                 addq.l     #$8, a7
01c2: 2f0b                 move.l     a3, -(a7)
01c4: 4ead0a3a             jsr        $a3a(a5) ; CODE37+0004
01c8: 0cadf4143e00a600     cmpi.l     #$f4143e00, -$5a00(a5)
01d0: 588f                 addq.l     #$4, a7
01d2: 6608                 bne.b      $1dc
01d4: 42ada600             clr.l      -$5a00(a5)
01d8: 600000ba             bra.w      $294
01dc: 0c040011             cmpi.b     #$11, d4
01e0: 650000b2             bcs.w      $294
01e4: 48780154             pea.l      $154.w
01e8: 486da5f0             pea.l      -$5a10(a5)
01ec: 486efdf6             pea.l      -$20a(a6)
01f0: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
01f4: 382dcf04             move.w     -$30fc(a5), d4
01f8: 426dcf04             clr.w      -$30fc(a5)
01fc: 7a00                 moveq      #$0, d5
01fe: 47eefdf6             lea.l      -$20a(a6), a3
0202: 4fef000c             lea.l      $c(a7), a7
0206: 60000086             bra.w      $28e
020a: 4a2dbd8e             tst.b      -$4272(a5)
020e: 665c                 bne.b      $26c
0210: 2f0b                 move.l     a3, -(a7)
0212: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
0216: 7609                 moveq      #$9, d3
0218: 9640                 sub.w      d0, d3
021a: 45eb0021             lea.l      $21(a3), a2
021e: 7e18                 moveq      #$18, d7
0220: de8b                 add.l      a3, d7
0222: 7c14                 moveq      #$14, d6
0224: dc8b                 add.l      a3, d6
0226: 41eb0010             lea.l      $10(a3), a0
022a: 2d48fdf2             move.l     a0, -$20e(a6)
022e: 588f                 addq.l     #$4, a7
0230: 6032                 bra.b      $264
0232: 1483                 move.b     d3, (a2)
0234: 42a7                 clr.l      -(a7)
0236: 42a7                 clr.l      -(a7)
0238: 2f0b                 move.l     a3, -(a7)
023a: 4ead09e2             jsr        $9e2(a5) ; CODE35+036c
023e: 2046                 movea.l    d6, a0
0240: 9090                 sub.l      (a0), d0
0242: 2047                 movea.l    d7, a0
0244: 2080                 move.l     d0, (a0)
0246: 486eff6c             pea.l      -$94(a6)
024a: 2f0c                 move.l     a4, -(a7)
024c: 2f0b                 move.l     a3, -(a7)
024e: 4ead098a             jsr        $98a(a5) ; CODE32+0004
0252: 206efdf2             movea.l    -$20e(a6), a0
0256: 2080                 move.l     d0, (a0)
0258: 2e8b                 move.l     a3, (a7)
025a: 4ebafda8             jsr        $4(pc)
025e: 4fef0018             lea.l      $18(a7), a7
0262: 5243                 addq.w     #$1, d3
0264: 0c430008             cmpi.w     #$8, d3
0268: 6fc8                 ble.b      $232
026a: 601c                 bra.b      $288
026c: 42a7                 clr.l      -(a7)
026e: 42a7                 clr.l      -(a7)
0270: 2f0b                 move.l     a3, -(a7)
0272: 4ead09e2             jsr        $9e2(a5) ; CODE35+036c
0276: 90ab0014             sub.l      $14(a3), d0
027a: 27400018             move.l     d0, $18(a3)
027e: 2e8b                 move.l     a3, (a7)
0280: 4ebafd82             jsr        $4(pc)
0284: 4fef000c             lea.l      $c(a7), a7
0288: 5245                 addq.w     #$1, d5
028a: 47eb0022             lea.l      $22(a3), a3
028e: b845                 cmp.w      d5, d4
0290: 6e00ff78             bgt.w      $20a
0294: 4cdf1cf8             movem.l    (a7)+, d3-d7/a2-a4
0298: 4e5e                 unlk       a6
029a: 4e75                 rts        
