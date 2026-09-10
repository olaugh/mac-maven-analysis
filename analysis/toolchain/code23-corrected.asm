0004: 4e560000             link.w     a6, #$0
0008: 3f2e0008             move.w     $8(a6), -(a7)
000c: 486df436             pea.l      -$bca(a5)
0010: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
0014: 4a80                 tst.l      d0
0016: 56c0                 sne.b      d0
0018: 4400                 neg.b      d0
001a: 4880                 ext.w      d0
001c: 4e5e                 unlk       a6
001e: 4e75                 rts        
0020: 4e560000             link.w     a6, #$0
0024: 2f0c                 move.l     a4, -(a7)
0026: 286e000c             movea.l    $c(a6), a4
002a: 601c                 bra.b      $48
002c: 1014                 move.b     (a4), d0
002e: 4880                 ext.w      d0
0030: 3f00                 move.w     d0, -(a7)
0032: 2f2e0008             move.l     $8(a6), -(a7)
0036: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
003a: 4a80                 tst.l      d0
003c: 5c8f                 addq.l     #$6, a7
003e: 6706                 beq.b      $46
0040: 1014                 move.b     (a4), d0
0042: 4880                 ext.w      d0
0044: 6008                 bra.b      $4e
0046: 528c                 addq.l     #$1, a4
0048: 4a14                 tst.b      (a4)
004a: 66e0                 bne.b      $2c
004c: 7000                 moveq      #$0, d0
004e: 285f                 movea.l    (a7)+, a4
0050: 4e5e                 unlk       a6
0052: 4e75                 rts        
0054: 4e56fffc             link.w     a6, #$fffc
0058: 601c                 bra.b      $76
005a: 206e0008             movea.l    $8(a6), a0
005e: 1010                 move.b     (a0), d0
0060: 4880                 ext.w      d0
0062: 3f00                 move.w     d0, -(a7)
0064: 2f2e0010             move.l     $10(a6), -(a7)
0068: 4ead0dba             jsr        $dba(a5) ; CODE52+0260
006c: 4a80                 tst.l      d0
006e: 5c8f                 addq.l     #$6, a7
0070: 6704                 beq.b      $76
0072: 52ae0008             addq.l     #$1, $8(a6)
0076: 206e000c             movea.l    $c(a6), a0
007a: 52ae000c             addq.l     #$1, $c(a6)
007e: 226e0008             movea.l    $8(a6), a1
0082: 1290                 move.b     (a0), (a1)
0084: 66d4                 bne.b      $5a
0086: 4e5e                 unlk       a6
0088: 4e75                 rts        
008a: 4e560000             link.w     a6, #$0
008e: 2f0c                 move.l     a4, -(a7)
0090: 286e0008             movea.l    $8(a6), a4
0094: 6012                 bra.b      $a8
0096: 7000                 moveq      #$0, d0
0098: 1014                 move.b     (a4), d0
009a: 204d                 movea.l    a5, a0
009c: d1c0                 adda.l     d0, a0
009e: 7006                 moveq      #$6, d0
00a0: c028fbd8             and.b      -$428(a0), d0
00a4: 6602                 bne.b      $a8
00a6: 528c                 addq.l     #$1, a4
00a8: 206e000c             movea.l    $c(a6), a0
00ac: 52ae000c             addq.l     #$1, $c(a6)
00b0: 1890                 move.b     (a0), (a4)
00b2: 66e2                 bne.b      $96
00b4: 4214                 clr.b      (a4)
00b6: 285f                 movea.l    (a7)+, a4
00b8: 4e5e                 unlk       a6
00ba: 4e75                 rts        
00bc: 4e56fffc             link.w     a6, #$fffc
00c0: 2f2e000c             move.l     $c(a6), -(a7)
00c4: 486df43c             pea.l      -$bc4(a5)
00c8: 206e0008             movea.l    $8(a6), a0
00cc: 48680001             pea.l      $1(a0)
00d0: 4ead0812             jsr        $812(a5) ; CODE24+16a6
00d4: 206e0008             movea.l    $8(a6), a0
00d8: 1080                 move.b     d0, (a0)
00da: 2008                 move.l     a0, d0
00dc: 4e5e                 unlk       a6
00de: 4e75                 rts        
00e0: 4e560000             link.w     a6, #$0
00e4: 48e70300             movem.l    d6-d7, -(a7)
00e8: 3e2e0010             move.w     $10(a6), d7
00ec: 5347                 subq.w     #$1, d7
00ee: 3047                 movea.w    d7, a0
00f0: 2f08                 move.l     a0, -(a7)
00f2: 2f2e000c             move.l     $c(a6), -(a7)
00f6: 206e0008             movea.l    $8(a6), a0
00fa: 48680001             pea.l      $1(a0)
00fe: 4ead0dca             jsr        $dca(a5) ; CODE52+034a
0102: 2eae000c             move.l     $c(a6), (a7)
0106: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
010a: 3c00                 move.w     d0, d6
010c: be46                 cmp.w      d6, d7
010e: 4fef000c             lea.l      $c(a7), a7
0112: 6c04                 bge.b      $118
0114: 3007                 move.w     d7, d0
0116: 6002                 bra.b      $11a
0118: 3006                 move.w     d6, d0
011a: 206e0008             movea.l    $8(a6), a0
011e: 1080                 move.b     d0, (a0)
0120: 4cdf00c0             movem.l    (a7)+, d6-d7
0124: 4e5e                 unlk       a6
0126: 4e75                 rts        
0128: 4e560000             link.w     a6, #$0
012c: 206e0008             movea.l    $8(a6), a0
0130: d1ee0010             adda.l     $10(a6), a0
0134: 4210                 clr.b      (a0)
0136: 2f2e0010             move.l     $10(a6), -(a7)
013a: 2f2e000c             move.l     $c(a6), -(a7)
013e: 2f2e0008             move.l     $8(a6), -(a7)
0142: 4ead0dca             jsr        $dca(a5) ; CODE52+034a
0146: 4e5e                 unlk       a6
0148: 4e75                 rts        
014a: 4e560000             link.w     a6, #$0
014e: 48e70018             movem.l    a3-a4, -(a7)
0152: 266e0008             movea.l    $8(a6), a3
0156: 284b                 movea.l    a3, a4
0158: 6002                 bra.b      $15c
015a: 528b                 addq.l     #$1, a3
015c: 4a13                 tst.b      (a3)
015e: 66fa                 bne.b      $15a
0160: 2f2e0010             move.l     $10(a6), -(a7)
0164: 2f2e000c             move.l     $c(a6), -(a7)
0168: 2f0b                 move.l     a3, -(a7)
016a: 4ebaffbc             jsr        $128(pc)
016e: 200c                 move.l     a4, d0
0170: 4cee1800fff8         movem.l    -$8(a6), a3-a4
0176: 4e5e                 unlk       a6
0178: 4e75                 rts        
017a: 4e560000             link.w     a6, #$0
017e: 48e70308             movem.l    d6-d7/a4, -(a7)
0182: 286e000c             movea.l    $c(a6), a4
0186: 206e0008             movea.l    $8(a6), a0
018a: 1014                 move.b     (a4), d0
018c: b010                 cmp.b      (a0), d0
018e: 6704                 beq.b      $194
0190: 7001                 moveq      #$1, d0
0192: 6022                 bra.b      $1b6
0194: 7e01                 moveq      #$1, d7
0196: 1c14                 move.b     (a4), d6
0198: 4886                 ext.w      d6
019a: 6014                 bra.b      $1b0
019c: 206e0008             movea.l    $8(a6), a0
01a0: 10347000             move.b     (a4, d7.w), d0
01a4: b0307000             cmp.b      (a0, d7.w), d0
01a8: 6704                 beq.b      $1ae
01aa: 7001                 moveq      #$1, d0
01ac: 6008                 bra.b      $1b6
01ae: 5247                 addq.w     #$1, d7
01b0: bc47                 cmp.w      d7, d6
01b2: 6ee8                 bgt.b      $19c
01b4: 7000                 moveq      #$0, d0
01b6: 4cdf10c0             movem.l    (a7)+, d6-d7/a4
01ba: 4e5e                 unlk       a6
01bc: 4e75                 rts        
01be: 4e56fff8             link.w     a6, #$fff8
01c2: 2f0c                 move.l     a4, -(a7)
01c4: 286e0008             movea.l    $8(a6), a4
01c8: 601e                 bra.b      $1e8
01ca: 206e000c             movea.l    $c(a6), a0
01ce: 1010                 move.b     (a0), d0
01d0: 4880                 ext.w      d0
01d2: 3f00                 move.w     d0, -(a7)
01d4: 4ead0de2             jsr        $de2(a5) ; CODE52+015e
01d8: 206e0008             movea.l    $8(a6), a0
01dc: 52ae0008             addq.l     #$1, $8(a6)
01e0: 1080                 move.b     d0, (a0)
01e2: 52ae000c             addq.l     #$1, $c(a6)
01e6: 548f                 addq.l     #$2, a7
01e8: 206e000c             movea.l    $c(a6), a0
01ec: 4a10                 tst.b      (a0)
01ee: 66da                 bne.b      $1ca
01f0: 206e0008             movea.l    $8(a6), a0
01f4: 4210                 clr.b      (a0)
01f6: 200c                 move.l     a4, d0
01f8: 285f                 movea.l    (a7)+, a4
01fa: 4e5e                 unlk       a6
01fc: 4e75                 rts        
01fe: 4e56fff8             link.w     a6, #$fff8
0202: 2f0c                 move.l     a4, -(a7)
0204: 286e0008             movea.l    $8(a6), a4
0208: 601e                 bra.b      $228
020a: 206e000c             movea.l    $c(a6), a0
020e: 1010                 move.b     (a0), d0
0210: 4880                 ext.w      d0
0212: 3f00                 move.w     d0, -(a7)
0214: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
0218: 206e0008             movea.l    $8(a6), a0
021c: 52ae0008             addq.l     #$1, $8(a6)
0220: 1080                 move.b     d0, (a0)
0222: 52ae000c             addq.l     #$1, $c(a6)
0226: 548f                 addq.l     #$2, a7
0228: 206e000c             movea.l    $c(a6), a0
022c: 4a10                 tst.b      (a0)
022e: 66da                 bne.b      $20a
0230: 206e0008             movea.l    $8(a6), a0
0234: 4210                 clr.b      (a0)
0236: 200c                 move.l     a4, d0
0238: 285f                 movea.l    (a7)+, a4
023a: 4e5e                 unlk       a6
023c: 4e75                 rts        
023e: 4e56fffc             link.w     a6, #$fffc
0242: 6004                 bra.b      $248
0244: 52ae0008             addq.l     #$1, $8(a6)
0248: 206e0008             movea.l    $8(a6), a0
024c: 7000                 moveq      #$0, d0
024e: 1010                 move.b     (a0), d0
0250: 224d                 movea.l    a5, a1
0252: d3c0                 adda.l     d0, a1
0254: 7006                 moveq      #$6, d0
0256: c029fbd8             and.b      -$428(a1), d0
025a: 66e8                 bne.b      $244
025c: 202e0008             move.l     $8(a6), d0
0260: 4e5e                 unlk       a6
0262: 4e75                 rts        
