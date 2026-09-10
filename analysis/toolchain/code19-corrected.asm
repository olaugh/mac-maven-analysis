0004: 4e560000             link.w     a6, #$0
0008: 2f2e000c             move.l     $c(a6), -(a7)
000c: 3f2e0012             move.w     $12(a6), -(a7)
0010: 206dde78             movea.l    -$2188(a5), a0
0014: 2050                 movea.l    (a0), a0
0016: 1f280307             move.b     $307(a0), -(a7)
001a: a945                 dc.w       $a945
001c: 7001                 moveq      #$1, d0
001e: 4e5e                 unlk       a6
0020: 4e75                 rts        
0022: 4e560000             link.w     a6, #$0
0026: 206dde78             movea.l    -$2188(a5), a0
002a: 2050                 movea.l    (a0), a0
002c: 4a680306             tst.w      $306(a0)
0030: 57c0                 seq.b      d0
0032: 4400                 neg.b      d0
0034: 4880                 ext.w      d0
0036: 206dde78             movea.l    -$2188(a5), a0
003a: 2050                 movea.l    (a0), a0
003c: 31400306             move.w     d0, $306(a0)
0040: 4ead03ca             jsr        $3ca(a5) ; CODE20+0520
0044: 4e5e                 unlk       a6
0046: 4e75                 rts        
0048: 4e560000             link.w     a6, #$0
004c: 2f2e000c             move.l     $c(a6), -(a7)
0050: 3f2e0012             move.w     $12(a6), -(a7)
0054: 206dde78             movea.l    -$2188(a5), a0
0058: 2050                 movea.l    (a0), a0
005a: 1f280309             move.b     $309(a0), -(a7)
005e: a945                 dc.w       $a945
0060: 7001                 moveq      #$1, d0
0062: 4e5e                 unlk       a6
0064: 4e75                 rts        
0066: 4e560000             link.w     a6, #$0
006a: 206dde78             movea.l    -$2188(a5), a0
006e: 2050                 movea.l    (a0), a0
0070: 4a680308             tst.w      $308(a0)
0074: 57c0                 seq.b      d0
0076: 4400                 neg.b      d0
0078: 4880                 ext.w      d0
007a: 206dde78             movea.l    -$2188(a5), a0
007e: 2050                 movea.l    (a0), a0
0080: 31400308             move.w     d0, $308(a0)
0084: 4ead03ca             jsr        $3ca(a5) ; CODE20+0520
0088: 4e5e                 unlk       a6
008a: 4e75                 rts        
008c: 4e560000             link.w     a6, #$0
0090: 2f2e000c             move.l     $c(a6), -(a7)
0094: 3f2e0012             move.w     $12(a6), -(a7)
0098: 206dde78             movea.l    -$2188(a5), a0
009c: 2050                 movea.l    (a0), a0
009e: 1f28030b             move.b     $30b(a0), -(a7)
00a2: a945                 dc.w       $a945
00a4: 7001                 moveq      #$1, d0
00a6: 4e5e                 unlk       a6
00a8: 4e75                 rts        
00aa: 4e560000             link.w     a6, #$0
00ae: 206dde78             movea.l    -$2188(a5), a0
00b2: 2050                 movea.l    (a0), a0
00b4: 4a68030a             tst.w      $30a(a0)
00b8: 57c0                 seq.b      d0
00ba: 4400                 neg.b      d0
00bc: 4880                 ext.w      d0
00be: 206dde78             movea.l    -$2188(a5), a0
00c2: 2050                 movea.l    (a0), a0
00c4: 3140030a             move.w     d0, $30a(a0)
00c8: 4ead03c2             jsr        $3c2(a5) ; CODE20+0cfa
00cc: 4e5e                 unlk       a6
00ce: 4e75                 rts        
00d0: 4e560000             link.w     a6, #$0
00d4: 2f2e000c             move.l     $c(a6), -(a7)
00d8: 3f2e0012             move.w     $12(a6), -(a7)
00dc: 206dde78             movea.l    -$2188(a5), a0
00e0: 2050                 movea.l    (a0), a0
00e2: 1f28030f             move.b     $30f(a0), -(a7)
00e6: a945                 dc.w       $a945
00e8: 7001                 moveq      #$1, d0
00ea: 4e5e                 unlk       a6
00ec: 4e75                 rts        
00ee: 4e560000             link.w     a6, #$0
00f2: 206dde78             movea.l    -$2188(a5), a0
00f6: 2050                 movea.l    (a0), a0
00f8: 4a68030e             tst.w      $30e(a0)
00fc: 57c0                 seq.b      d0
00fe: 4400                 neg.b      d0
0100: 4880                 ext.w      d0
0102: 206dde78             movea.l    -$2188(a5), a0
0106: 2050                 movea.l    (a0), a0
0108: 3140030e             move.w     d0, $30e(a0)
010c: 4267                 clr.w      -(a7)
010e: 4ead04fa             jsr        $4fa(a5) ; CODE21+13fc
0112: 4e5e                 unlk       a6
0114: 4e75                 rts        
0116: 4e560000             link.w     a6, #$0
011a: 2f2e000c             move.l     $c(a6), -(a7)
011e: 3f2e0012             move.w     $12(a6), -(a7)
0122: 206dde78             movea.l    -$2188(a5), a0
0126: 2050                 movea.l    (a0), a0
0128: 1f280311             move.b     $311(a0), -(a7)
012c: a945                 dc.w       $a945
012e: 4e5e                 unlk       a6
0130: 4e75                 rts        
0132: 4e560000             link.w     a6, #$0
0136: 206dde78             movea.l    -$2188(a5), a0
013a: 2050                 movea.l    (a0), a0
013c: 4a680310             tst.w      $310(a0)
0140: 57c0                 seq.b      d0
0142: 4400                 neg.b      d0
0144: 4880                 ext.w      d0
0146: 206dde78             movea.l    -$2188(a5), a0
014a: 2050                 movea.l    (a0), a0
014c: 31400310             move.w     d0, $310(a0)
0150: 4ead0482             jsr        $482(a5) ; CODE21+0b86
0154: 4e5e                 unlk       a6
0156: 4e75                 rts        
0158: 4e560000             link.w     a6, #$0
015c: 2f2e000c             move.l     $c(a6), -(a7)
0160: 3f2e0012             move.w     $12(a6), -(a7)
0164: 206dde78             movea.l    -$2188(a5), a0
0168: 2050                 movea.l    (a0), a0
016a: 1f28030d             move.b     $30d(a0), -(a7)
016e: a945                 dc.w       $a945
0170: 7001                 moveq      #$1, d0
0172: 4e5e                 unlk       a6
0174: 4e75                 rts        
0176: 4e560000             link.w     a6, #$0
017a: 4ead00ca             jsr        $ca(a5) ; CODE6+038e
017e: 4e5e                 unlk       a6
0180: 4e75                 rts        
