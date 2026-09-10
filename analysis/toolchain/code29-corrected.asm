0004: 4e56ffde             link.w     a6, #$ffde
0008: 2f2e0008             move.l     $8(a6), -(a7)
000c: 486effde             pea.l      -$22(a6)
0010: 4ead08f2             jsr        $8f2(a5) ; CODE30+0cd2
0014: 2eae0014             move.l     $14(a6), (a7)
0018: 2f2e0010             move.l     $10(a6), -(a7)
001c: 2f2e000c             move.l     $c(a6), -(a7)
0020: 486effde             pea.l      -$22(a6)
0024: 4ead0a32             jsr        $a32(a5) ; CODE37+0548
0028: 4e5e                 unlk       a6
002a: 4e75                 rts        
002c: 4e560000             link.w     a6, #$0
0030: 2b6e0008cf28         move.l     $8(a6), -$30d8(a5)
0036: 2b6e000ccf2c         move.l     $c(a6), -$30d4(a5)
003c: 2f2e000c             move.l     $c(a6), -(a7)
0040: 4ead096a             jsr        $96a(a5) ; CODE31+0992
0044: 4ead0982             jsr        $982(a5) ; CODE32+115c
0048: 486d0872             pea.l      $872(a5)
004c: 4ead08c2             jsr        $8c2(a5) ; CODE30+0d66
0050: 4e5e                 unlk       a6
0052: 4e75                 rts        
0054: 4e560000             link.w     a6, #$0
0058: 2f0c                 move.l     a4, -(a7)
005a: 286e0008             movea.l    $8(a6), a4
005e: 4a2c001c             tst.b      $1c(a4)
0062: 6668                 bne.b      $cc
0064: 4a6c0004             tst.w      $4(a4)
0068: 6662                 bne.b      $cc
006a: 4a2c001a             tst.b      $1a(a4)
006e: 675c                 beq.b      $cc
0070: 48780022             pea.l      $22.w
0074: 486da5ce             pea.l      -$5a32(a5)
0078: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
007c: 306c0002             movea.w    $2(a4), a0
0080: 2b48a600             move.l     a0, -$5a00(a5)
0084: 3054                 movea.w    (a4), a0
0086: 2b48a622             move.l     a0, -$59de(a5)
008a: 102c0019             move.b     $19(a4), d0
008e: 4880                 ext.w      d0
0090: 3b40f526             move.w     d0, -$ada(a5)
0094: 2eadcf2c             move.l     -$30d4(a5), (a7)
0098: 486d087a             pea.l      $87a(a5)
009c: 2f2dcf28             move.l     -$30d8(a5), -(a7)
00a0: 2f0c                 move.l     a4, -(a7)
00a2: 4ebaff60             jsr        $4(pc)
00a6: 396da6020002         move.w     -$59fe(a5), $2(a4)
00ac: 38ada624             move.w     -$59dc(a5), (a4)
00b0: 4a6da5ea             tst.w      -$5a16(a5)
00b4: 4fef0014             lea.l      $14(a7), a7
00b8: 6706                 beq.b      $c0
00ba: 197c0001001d         move.b     #$1, $1d(a4)
00c0: 4aada5e6             tst.l      -$5a1a(a5)
00c4: 6706                 beq.b      $cc
00c6: 197c00010018         move.b     #$1, $18(a4)
00cc: 285f                 movea.l    (a7)+, a4
00ce: 4e5e                 unlk       a6
00d0: 4e75                 rts        
00d2: 4e56fffc             link.w     a6, #$fffc
00d6: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
00da: 266e0008             movea.l    $8(a6), a3
00de: 7001                 moveq      #$1, d0
00e0: 2b40a5e6             move.l     d0, -$5a1a(a5)
00e4: 49eb001c             lea.l      $1c(a3), a4
00e8: 4a54                 tst.w      (a4)
00ea: 6718                 beq.b      $104
00ec: 2f2dcf28             move.l     -$30d8(a5), -(a7)
00f0: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
00f4: d040                 add.w      d0, d0
00f6: 48c0                 ext.l      d0
00f8: d0ab0010             add.l      $10(a3), d0
00fc: 2c00                 move.l     d0, d6
00fe: 2e00                 move.l     d0, d7
0100: 588f                 addq.l     #$4, a7
0102: 6036                 bra.b      $13a
0104: 486efffc             pea.l      -$4(a6)
0108: 486efffe             pea.l      -$2(a6)
010c: 3f2b001e             move.w     $1e(a3), -(a7)
0110: 3f2df526             move.w     -$ada(a5), -(a7)
0114: 4ead0a6a             jsr        $a6a(a5) ; CODE39+068c
0118: 3040                 movea.w    d0, a0
011a: 2c2b0010             move.l     $10(a3), d6
011e: 9c88                 sub.l      a0, d6
0120: 2e06                 move.l     d6, d7
0122: 306efffc             movea.w    -$4(a6), a0
0126: de88                 add.l      a0, d7
0128: 306efffe             movea.w    -$2(a6), a0
012c: 9c88                 sub.l      a0, d6
012e: bc87                 cmp.l      d7, d6
0130: 4fef000c             lea.l      $c(a7), a7
0134: 6f04                 ble.b      $13a
0136: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
013a: beada600             cmp.l      -$5a00(a5), d7
013e: 6f08                 ble.b      $148
0140: 3b54a5ea             move.w     (a4), -$5a16(a5)
0144: 2b47a600             move.l     d7, -$5a00(a5)
0148: bcada622             cmp.l      -$59de(a5), d6
014c: 6f08                 ble.b      $156
014e: 3b54a5ea             move.w     (a4), -$5a16(a5)
0152: 2b46a622             move.l     d6, -$59de(a5)
0156: 4cdf18c0             movem.l    (a7)+, d6-d7/a3-a4
015a: 4e5e                 unlk       a6
015c: 4e75                 rts        
015e: 4e560000             link.w     a6, #$0
0162: 2b6e000ccf28         move.l     $c(a6), -$30d8(a5)
0168: 2b6e0008cf2c         move.l     $8(a6), -$30d4(a5)
016e: 2f2e0008             move.l     $8(a6), -(a7)
0172: 4ead096a             jsr        $96a(a5) ; CODE31+0992
0176: 4ead0982             jsr        $982(a5) ; CODE32+115c
017a: 486d088a             pea.l      $88a(a5)
017e: 4ead08c2             jsr        $8c2(a5) ; CODE30+0d66
0182: 4e5e                 unlk       a6
0184: 4e75                 rts        
0186: 4e56fff6             link.w     a6, #$fff6
018a: 48e70308             movem.l    d6-d7/a4, -(a7)
018e: 286e0008             movea.l    $8(a6), a4
0192: 4a2c001c             tst.b      $1c(a4)
0196: 66000088             bne.w      $220
019a: 4a2c001d             tst.b      $1d(a4)
019e: 66000080             bne.w      $220
01a2: 4a6c0004             tst.w      $4(a4)
01a6: 6678                 bne.b      $220
01a8: 4a2c001a             tst.b      $1a(a4)
01ac: 6772                 beq.b      $220
01ae: 48780200             pea.l      $200.w
01b2: 486da756             pea.l      -$58aa(a5)
01b6: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
01ba: 2eadcf2c             move.l     -$30d4(a5), (a7)
01be: 486d0892             pea.l      $892(a5)
01c2: 2f2dcf2c             move.l     -$30d4(a5), -(a7)
01c6: 2f0c                 move.l     a4, -(a7)
01c8: 4ebafe3a             jsr        $4(pc)
01cc: 1e2c0018             move.b     $18(a4), d7
01d0: 4a07                 tst.b      d7
01d2: 4fef0014             lea.l      $14(a7), a7
01d6: 6704                 beq.b      $1dc
01d8: 7001                 moveq      #$1, d0
01da: 6002                 bra.b      $1de
01dc: 7008                 moveq      #$8, d0
01de: 3c00                 move.w     d0, d6
01e0: 4a07                 tst.b      d7
01e2: 6704                 beq.b      $1e8
01e4: 7002                 moveq      #$2, d0
01e6: 6002                 bra.b      $1ea
01e8: 7008                 moveq      #$8, d0
01ea: 3e00                 move.w     d0, d7
01ec: 486df528             pea.l      -$ad8(a5)
01f0: 486df52a             pea.l      -$ad6(a5)
01f4: 486efff6             pea.l      -$a(a6)
01f8: 3f07                 move.w     d7, -(a7)
01fa: 3f06                 move.w     d6, -(a7)
01fc: 2f2dcf2c             move.l     -$30d4(a5), -(a7)
0200: 2f0c                 move.l     a4, -(a7)
0202: 4ead0a52             jsr        $a52(a5) ; CODE39+0004
0206: 302efff8             move.w     -$8(a6), d0
020a: 9154                 sub.w      d0, (a4)
020c: 4aadf52a             tst.l      -$ad6(a5)
0210: 4fef0018             lea.l      $18(a7), a7
0214: 670a                 beq.b      $220
0216: 486d085a             pea.l      $85a(a5)
021a: 4ead08c2             jsr        $8c2(a5) ; CODE30+0d66
021e: 588f                 addq.l     #$4, a7
0220: 4cdf10c0             movem.l    (a7)+, d6-d7/a4
0224: 4e5e                 unlk       a6
0226: 4e75                 rts        
0228: 4e560000             link.w     a6, #$0
022c: 48e70018             movem.l    a3-a4, -(a7)
0230: 266e0008             movea.l    $8(a6), a3
0234: 49eb0008             lea.l      $8(a3), a4
0238: 3054                 movea.w    (a4), a0
023a: b1edf52a             cmpa.l     -$ad6(a5), a0
023e: 6c2a                 bge.b      $26a
0240: 4a2b001c             tst.b      $1c(a3)
0244: 6624                 bne.b      $26a
0246: 4a2b001d             tst.b      $1d(a3)
024a: 661e                 bne.b      $26a
024c: 4a6b0004             tst.w      $4(a3)
0250: 6618                 bne.b      $26a
0252: 102b0019             move.b     $19(a3), d0
0256: 4880                 ext.w      d0
0258: 806df528             or.w       -$ad8(a5), d0
025c: 122b0019             move.b     $19(a3), d1
0260: 4881                 ext.w      d1
0262: b240                 cmp.w      d0, d1
0264: 6604                 bne.b      $26a
0266: 38adf52c             move.w     -$ad4(a5), (a4)
026a: 4cdf1800             movem.l    (a7)+, a3-a4
026e: 4e5e                 unlk       a6
0270: 4e75                 rts        
0272: 4e56fffa             link.w     a6, #$fffa
0276: 2f0c                 move.l     a4, -(a7)
0278: 7010                 moveq      #$10, d0
027a: d0ae0008             add.l      $8(a6), d0
027e: 2840                 movea.l    d0, a4
0280: 206e0008             movea.l    $8(a6), a0
0284: 3028001e             move.w     $1e(a0), d0
0288: 224d                 movea.l    a5, a1
028a: 48c0                 ext.l      d0
028c: e588                 lsl.l      #$2, d0
028e: d3c0                 adda.l     d0, a1
0290: 2014                 move.l     (a4), d0
0292: b0a9a756             cmp.l      -$58aa(a1), d0
0296: 6f14                 ble.b      $2ac
0298: 206e0008             movea.l    $8(a6), a0
029c: 3028001e             move.w     $1e(a0), d0
02a0: 224d                 movea.l    a5, a1
02a2: 48c0                 ext.l      d0
02a4: e588                 lsl.l      #$2, d0
02a6: d3c0                 adda.l     d0, a1
02a8: 2354a756             move.l     (a4), -$58aa(a1)
02ac: 285f                 movea.l    (a7)+, a4
02ae: 4e5e                 unlk       a6
02b0: 4e75                 rts        
