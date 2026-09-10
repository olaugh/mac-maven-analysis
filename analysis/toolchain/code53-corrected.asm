0004: 4e560000             link.w     a6, #$0
0008: 48e70338             movem.l    d6-d7/a2-a4, -(a7)
000c: 266e0008             movea.l    $8(a6), a3
0010: 284b                 movea.l    a3, a4
0012: d9ee000c             adda.l     $c(a6), a4
0016: 7e00                 moveq      #$0, d7
0018: 4aadfb98             tst.l      -$468(a5)
001c: 6618                 bne.b      $36
001e: 7c00                 moveq      #$0, d6
0020: 45edfb98             lea.l      -$468(a5), a2
0024: 600a                 bra.b      $30
0026: 4ead05b2             jsr        $5b2(a5) ; CODE4+0004
002a: 2480                 move.l     d0, (a2)
002c: 5246                 addq.w     #$1, d6
002e: 588a                 addq.l     #$4, a2
0030: 0c460010             cmpi.w     #$10, d6
0034: 65f0                 bcs.b      $26
0036: 4aadfb98             tst.l      -$468(a5)
003a: 6624                 bne.b      $60
003c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0040: 601e                 bra.b      $60
0042: 1013                 move.b     (a3), d0
0044: 4880                 ext.w      d0
0046: 2207                 move.l     d7, d1
0048: e889                 lsr.l      #$4, d1
004a: 740f                 moveq      #$f, d2
004c: c487                 and.l      d7, d2
004e: 204d                 movea.l    a5, a0
0050: e58a                 lsl.l      #$2, d2
0052: d1c2                 adda.l     d2, a0
0054: d2a8fb98             add.l      -$468(a0), d1
0058: 3040                 movea.w    d0, a0
005a: d288                 add.l      a0, d1
005c: 2e01                 move.l     d1, d7
005e: 528b                 addq.l     #$1, a3
0060: b9cb                 cmpa.l     a3, a4
0062: 62de                 bhi.b      $42
0064: 2007                 move.l     d7, d0
0066: 4cdf1cc0             movem.l    (a7)+, d6-d7/a2-a4
006a: 4e5e                 unlk       a6
006c: 4e75                 rts        
