0004: 4e560000             link.w     a6, #$0
0008: 48e70118             movem.l    d7/a3-a4, -(a7)
000c: 286e0008             movea.l    $8(a6), a4
0010: 7e00                 moveq      #$0, d7
0012: 47edde28             lea.l      -$21d8(a5), a3
0016: 6008                 bra.b      $20
0018: 18eb0001             move.b     $1(a3), (a4)+
001c: 5247                 addq.w     #$1, d7
001e: 588b                 addq.l     #$4, a3
0020: 4a53                 tst.w      (a3)
0022: 66f4                 bne.b      $18
0024: 4214                 clr.b      (a4)
0026: 202e0008             move.l     $8(a6), d0
002a: 4cdf1880             movem.l    (a7)+, d7/a3-a4
002e: 4e5e                 unlk       a6
0030: 4e75                 rts        
0032: 4e56fffc             link.w     a6, #$fffc
0036: 4eba0a40             jsr        $a78(pc)
003a: 4ead043a             jsr        $43a(a5) ; CODE20+0194
003e: 4ead03fa             jsr        $3fa(a5) ; CODE20+004e
0042: 486dc366             pea.l      -$3c9a(a5)
0046: 4ebaffbc             jsr        $4(pc)
004a: 4ead06aa             jsr        $6aa(a5) ; CODE9+0062
004e: 486d02b2             pea.l      $2b2(a5)
0052: 486efffc             pea.l      -$4(a6)
0056: 4ead06ba             jsr        $6ba(a5) ; CODE9+003e
005a: 0c6d0008a386         cmpi.w     #$8, -$5c7a(a5)
0060: 4fef000c             lea.l      $c(a7), a7
0064: 6406                 bcc.b      $6c
0066: 4a6da386             tst.w      -$5c7a(a5)
006a: 6c04                 bge.b      $70
006c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0070: 302da386             move.w     -$5c7a(a5), d0
0074: 526da386             addq.w     #$1, -$5c7a(a5)
0078: c1fc002c             muls.w     #$2c, d0
007c: 41eda226             lea.l      -$5dda(a5), a0
0080: d088                 add.l      a0, d0
0082: 2040                 movea.l    d0, a0
0084: 7000                 moveq      #$0, d0
0086: 43fa0006             lea.l      $8e(pc), a1
008a: 48d0def8             movem.l    d3-d7/a1-a4/a6-a7, (a0)
008e: 4a40                 tst.w      d0
0090: 662e                 bne.b      $c0
0092: 3f3c0001             move.w     #$1, -(a7)
0096: 48780078             pea.l      $78.w
009a: 486dc366             pea.l      -$3c9a(a5)
009e: 4ead0ac2             jsr        $ac2(a5) ; CODE44+0004
00a2: 4ead01b2             jsr        $1b2(a5) ; CODE11+0d4c
00a6: 3eadcf04             move.w     -$30fc(a5), (a7)
00aa: 486da5f0             pea.l      -$5a10(a5)
00ae: 486de2e8             pea.l      -$1d18(a5)
00b2: 4eba0396             jsr        $44a(pc)
00b6: 536da386             subq.w     #$1, -$5c7a(a5)
00ba: 4fef0012             lea.l      $12(a7), a7
00be: 6048                 bra.b      $108
00c0: 2f2da222             move.l     -$5dde(a5), -(a7)
00c4: 2f2d93ac             move.l     -$6c54(a5), -(a7)
00c8: 4ead0db2             jsr        $db2(a5) ; CODE52+0242
00cc: 4a40                 tst.w      d0
00ce: 508f                 addq.l     #$8, a7
00d0: 6606                 bne.b      $d8
00d2: 4eba0244             jsr        $318(pc)
00d6: 6030                 bra.b      $108
00d8: 4a6da386             tst.w      -$5c7a(a5)
00dc: 6e04                 bgt.b      $e2
00de: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
00e2: 2b6da222a222         move.l     -$5dde(a5), -$5dde(a5)
00e8: 536da386             subq.w     #$1, -$5c7a(a5)
00ec: 702c                 moveq      #$2c, d0
00ee: c1eda386             muls.w     -$5c7a(a5), d0
00f2: 41eda226             lea.l      -$5dda(a5), a0
00f6: d088                 add.l      a0, d0
00f8: 2040                 movea.l    d0, a0
00fa: 7001                 moveq      #$1, d0
00fc: 4a40                 tst.w      d0
00fe: 6602                 bne.b      $102
0100: 7001                 moveq      #$1, d0
0102: 4cd8def8             movem.l    (a0)+, d3-d7/a1-a4/a6-a7
0106: 4ed1                 jmp        (a1)
0108: 42adb3e2             clr.l      -$4c1e(a5)
010c: 4ead06b2             jsr        $6b2(a5) ; CODE9+006a
0110: 2f2efffc             move.l     -$4(a6), -(a7)
0114: 4ead06c2             jsr        $6c2(a5) ; CODE9+0054
0118: 4e5e                 unlk       a6
011a: 4e75                 rts        
011c: 4e560000             link.w     a6, #$0
0120: 48e70718             movem.l    d5-d7/a3-a4, -(a7)
0124: 286e0008             movea.l    $8(a6), a4
0128: 266e000c             movea.l    $c(a6), a3
012c: 2e2c0014             move.l     $14(a4), d7
0130: deac0010             add.l      $10(a4), d7
0134: deac0018             add.l      $18(a4), d7
0138: 2c2b0014             move.l     $14(a3), d6
013c: dcab0010             add.l      $10(a3), d6
0140: dcab0018             add.l      $18(a3), d6
0144: be86                 cmp.l      d6, d7
0146: 6e30                 bgt.b      $178
0148: bc87                 cmp.l      d7, d6
014a: 6608                 bne.b      $154
014c: 41ede2fe             lea.l      -$1d02(a5), a0
0150: 2008                 move.l     a0, d0
0152: 602a                 bra.b      $17e
0154: 2a06                 move.l     d6, d5
0156: 9a87                 sub.l      d7, d5
0158: 0c85000000c8         cmpi.l     #$c8, d5
015e: 6e08                 bgt.b      $168
0160: 41ede304             lea.l      -$1cfc(a5), a0
0164: 2008                 move.l     a0, d0
0166: 6016                 bra.b      $17e
0168: 0c85000001f4         cmpi.l     #$1f4, d5
016e: 6e08                 bgt.b      $178
0170: 41ede30a             lea.l      -$1cf6(a5), a0
0174: 2008                 move.l     a0, d0
0176: 6006                 bra.b      $17e
0178: 41ede30e             lea.l      -$1cf2(a5), a0
017c: 2008                 move.l     a0, d0
017e: 4cdf18e0             movem.l    (a7)+, d5-d7/a3-a4
0182: 4e5e                 unlk       a6
0184: 4e75                 rts        
0186: 4e56fff0             link.w     a6, #$fff0
018a: 48e70738             movem.l    d5-d7/a2-a4, -(a7)
018e: 246e0008             movea.l    $8(a6), a2
0192: 4eba0916             jsr        $aaa(pc)
0196: 4a40                 tst.w      d0
0198: 6700013a             beq.w      $2d4
019c: 486dc366             pea.l      -$3c9a(a5)
01a0: 4ead096a             jsr        $96a(a5) ; CODE31+0992
01a4: 486dc366             pea.l      -$3c9a(a5)
01a8: 4ead0952             jsr        $952(a5) ; CODE31+071e
01ac: 7e00                 moveq      #$0, d7
01ae: 49edde28             lea.l      -$21d8(a5), a4
01b2: 508f                 addq.l     #$8, a7
01b4: 601a                 bra.b      $1d0
01b6: 4a6c0002             tst.w      $2(a4)
01ba: 6710                 beq.b      $1cc
01bc: 47eda54e             lea.l      -$5ab2(a5), a3
01c0: d6c6                 adda.w     d6, a3
01c2: 4a13                 tst.b      (a3)
01c4: 6c04                 bge.b      $1ca
01c6: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
01ca: 5313                 subq.b     #$1, (a3)
01cc: 5247                 addq.w     #$1, d7
01ce: 588c                 addq.l     #$4, a4
01d0: 3c14                 move.w     (a4), d6
01d2: 66e2                 bne.b      $1b6
01d4: 486efff0             pea.l      -$10(a6)
01d8: 4ead0952             jsr        $952(a5) ; CODE31+071e
01dc: 49ea001e             lea.l      $1e(a2), a4
01e0: 486efff0             pea.l      -$10(a6)
01e4: 486dc366             pea.l      -$3c9a(a5)
01e8: 4ead09a2             jsr        $9a2(a5) ; CODE32+11e6
01ec: 3880                 move.w     d0, (a4)
01ee: 204d                 movea.l    a5, a0
01f0: 3014                 move.w     (a4), d0
01f2: d0c0                 adda.w     d0, a0
01f4: d0c0                 adda.w     d0, a0
01f6: 3068bbf4             movea.w    -$440c(a0), a0
01fa: 25480014             move.l     a0, $14(a2)
01fe: 4eba01b0             jsr        $3b0(pc)
0202: 48c0                 ext.l      d0
0204: 2c00                 move.l     d0, d6
0206: 7e00                 moveq      #$0, d7
0208: 4fef000c             lea.l      $c(a7), a7
020c: 6042                 bra.b      $250
020e: 3f07                 move.w     d7, -(a7)
0210: 4eba01c4             jsr        $3d6(pc)
0214: 2840                 movea.l    d0, a4
0216: 102a0020             move.b     $20(a2), d0
021a: b02c0020             cmp.b      $20(a4), d0
021e: 548f                 addq.l     #$2, a7
0220: 6618                 bne.b      $23a
0222: 102a0021             move.b     $21(a2), d0
0226: b02c0021             cmp.b      $21(a4), d0
022a: 660e                 bne.b      $23a
022c: 2f0c                 move.l     a4, -(a7)
022e: 2f0a                 move.l     a2, -(a7)
0230: 4ead0db2             jsr        $db2(a5) ; CODE52+0242
0234: 4a40                 tst.w      d0
0236: 508f                 addq.l     #$8, a7
0238: 6704                 beq.b      $23e
023a: 7a00                 moveq      #$0, d5
023c: 6002                 bra.b      $240
023e: 7a01                 moveq      #$1, d5
0240: 3f07                 move.w     d7, -(a7)
0242: 4eba01e8             jsr        $42c(pc)
0246: 4a45                 tst.w      d5
0248: 548f                 addq.l     #$2, a7
024a: 66000088             bne.w      $2d4
024e: 5247                 addq.w     #$1, d7
0250: 3047                 movea.w    d7, a0
0252: bc88                 cmp.l      a0, d6
0254: 6eb8                 bgt.b      $20e
0256: 4a86                 tst.l      d6
0258: 6604                 bne.b      $25e
025a: 5286                 addq.l     #$1, d6
025c: 6066                 bra.b      $2c4
025e: 7eff                 moveq      #$ff, d7
0260: de46                 add.w      d6, d7
0262: 3f07                 move.w     d7, -(a7)
0264: 4eba0170             jsr        $3d6(pc)
0268: 2840                 movea.l    d0, a4
026a: 102a0020             move.b     $20(a2), d0
026e: b02c0020             cmp.b      $20(a4), d0
0272: 548f                 addq.l     #$2, a7
0274: 6644                 bne.b      $2ba
0276: 486a0001             pea.l      $1(a2)
027a: 2f0c                 move.l     a4, -(a7)
027c: 4ead0db2             jsr        $db2(a5) ; CODE52+0242
0280: 4a40                 tst.w      d0
0282: 508f                 addq.l     #$8, a7
0284: 6612                 bne.b      $298
0286: 102c0021             move.b     $21(a4), d0
028a: 4880                 ext.w      d0
028c: 122a0021             move.b     $21(a2), d1
0290: 4881                 ext.w      d1
0292: 5241                 addq.w     #$1, d1
0294: b240                 cmp.w      d0, d1
0296: 6724                 beq.b      $2bc
0298: 2f0c                 move.l     a4, -(a7)
029a: 4ead0dc2             jsr        $dc2(a5) ; CODE52+033c
029e: 2e80                 move.l     d0, (a7)
02a0: 2f0c                 move.l     a4, -(a7)
02a2: 2f0a                 move.l     a2, -(a7)
02a4: 4ead0dd2             jsr        $dd2(a5) ; CODE52+0388
02a8: 4a40                 tst.w      d0
02aa: 4fef000c             lea.l      $c(a7), a7
02ae: 660a                 bne.b      $2ba
02b0: 102a0021             move.b     $21(a2), d0
02b4: b02c0021             cmp.b      $21(a4), d0
02b8: 6702                 beq.b      $2bc
02ba: 5286                 addq.l     #$1, d6
02bc: 3f07                 move.w     d7, -(a7)
02be: 4eba016c             jsr        $42c(pc)
02c2: 548f                 addq.l     #$2, a7
02c4: 2f0a                 move.l     a2, -(a7)
02c6: 70ff                 moveq      #$ff, d0
02c8: d046                 add.w      d6, d0
02ca: 3f00                 move.w     d0, -(a7)
02cc: 4eba0146             jsr        $414(pc)
02d0: 4eba0232             jsr        $504(pc)
02d4: 4cee1ce0ffd8         movem.l    -$28(a6), d5-d7/a2-a4
02da: 4e5e                 unlk       a6
02dc: 4e75                 rts        
02de: 4e560000             link.w     a6, #$0
02e2: 302dd76a             move.w     -$2896(a5), d0
02e6: b06e0008             cmp.w      $8(a6), d0
02ea: 6716                 beq.b      $302
02ec: 3f2dd76a             move.w     -$2896(a5), -(a7)
02f0: 4eba044c             jsr        $73e(pc)
02f4: 3b6e0008d76a         move.w     $8(a6), -$2896(a5)
02fa: 3eadd76a             move.w     -$2896(a5), (a7)
02fe: 4eba043e             jsr        $73e(pc)
0302: 4e5e                 unlk       a6
0304: 4e75                 rts        
0306: 4e560000             link.w     a6, #$0
030a: 2f2ddeb8             move.l     -$2148(a5), -(a7)
030e: 2f2e0008             move.l     $8(a6), -(a7)
0312: a91a                 dc.w       $a91a
0314: 4e5e                 unlk       a6
0316: 4e75                 rts        
0318: 4267                 clr.w      -(a7)
031a: 2f2ddeb8             move.l     -$2148(a5), -(a7)
031e: 4ead0d62             jsr        $d62(a5) ; CODE51+0048
0322: 4257                 clr.w      (a7)
0324: 2f2ddeb0             move.l     -$2150(a5), -(a7)
0328: 4ead0d62             jsr        $d62(a5) ; CODE51+0048
032c: 4fef000a             lea.l      $a(a7), a7
0330: 4e75                 rts        
0332: 4e56fff8             link.w     a6, #$fff8
0336: 206e0008             movea.l    $8(a6), a0
033a: 2d680010fff8         move.l     $10(a0), -$8(a6)
0340: 2d680014fffc         move.l     $14(a0), -$4(a6)
0346: 700c                 moveq      #$c, d0
0348: c1ee000c             muls.w     $c(a6), d0
034c: 3d40fffc             move.w     d0, -$4(a6)
0350: 3d40fff8             move.w     d0, -$8(a6)
0354: 066e000cfffc         addi.w     #$c, -$4(a6)
035a: 2f08                 move.l     a0, -(a7)
035c: a873                 dc.w       $a873
035e: 486efff8             pea.l      -$8(a6)
0362: a928                 dc.w       $a928
0364: 302e000c             move.w     $c(a6), d0
0368: 4e5e                 unlk       a6
036a: 4e75                 rts        
036c: 4e560000             link.w     a6, #$0
0370: 41edc366             lea.l      -$3c9a(a5), a0
0374: b1edc376             cmpa.l     -$3c8a(a5), a0
0378: 6614                 bne.b      $38e
037a: 4a2dc366             tst.b      -$3c9a(a5)
037e: 670e                 beq.b      $38e
0380: 4ead0502             jsr        $502(a5) ; CODE21+30a2
0384: 4a40                 tst.w      d0
0386: 6606                 bne.b      $38e
0388: 4a6dd9ae             tst.w      -$2652(a5)
038c: 6704                 beq.b      $392
038e: 7000                 moveq      #$0, d0
0390: 6002                 bra.b      $394
0392: 7001                 moveq      #$1, d0
0394: 4e5e                 unlk       a6
0396: 4e75                 rts        
0398: 2b78016aa38e         move.l     $16a.w, -$5c72(a5)
039e: 4ead06ca             jsr        $6ca(a5) ; CODE9+0376
03a2: 4e75                 rts        
03a4: 4e560000             link.w     a6, #$0
03a8: 4ebafc88             jsr        $32(pc)
03ac: 4e5e                 unlk       a6
03ae: 4e75                 rts        
03b0: 4e56fffc             link.w     a6, #$fffc
03b4: 42a7                 clr.l      -(a7)
03b6: 206ddeb8             movea.l    -$2148(a5), a0
03ba: 2f2800ca             move.l     $ca(a0), -(a7)
03be: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
03c2: 2d5ffffc             move.l     (a7)+, -$4(a6)
03c6: 48780006             pea.l      $6.w
03ca: 2f2efffc             move.l     -$4(a6), -(a7)
03ce: 4ead004a             jsr        $4a(a5) ; CODE1+0124
03d2: 4e5e                 unlk       a6
03d4: 4e75                 rts        
03d6: 4e560000             link.w     a6, #$0
03da: 2f0c                 move.l     a4, -(a7)
03dc: 7006                 moveq      #$6, d0
03de: c1ee0008             muls.w     $8(a6), d0
03e2: 2840                 movea.l    d0, a4
03e4: 206ddeb8             movea.l    -$2148(a5), a0
03e8: 206800ca             movea.l    $ca(a0), a0
03ec: 224c                 movea.l    a4, a1
03ee: d3d0                 adda.l     (a0), a1
03f0: 0c110002             cmpi.b     #$2, (a1)
03f4: 6704                 beq.b      $3fa
03f6: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
03fa: 206ddeb8             movea.l    -$2148(a5), a0
03fe: 206800ca             movea.l    $ca(a0), a0
0402: 2010                 move.l     (a0), d0
0404: 2f340802             move.l     $2(a4, d0.l), -(a7)
0408: 4ead05ea             jsr        $5ea(a5) ; CODE9+022e
040c: 286efffc             movea.l    -$4(a6), a4
0410: 4e5e                 unlk       a6
0412: 4e75                 rts        
0414: 4e560000             link.w     a6, #$0
0418: 2f2e000a             move.l     $a(a6), -(a7)
041c: 3f2e0008             move.w     $8(a6), -(a7)
0420: 2f2ddeb8             move.l     -$2148(a5), -(a7)
0424: 4ead0152             jsr        $152(a5) ; CODE7+08bc
0428: 4e5e                 unlk       a6
042a: 4e75                 rts        
042c: 4e560000             link.w     a6, #$0
0430: 206ddeb8             movea.l    -$2148(a5), a0
0434: 206800ca             movea.l    $ca(a0), a0
0438: 7006                 moveq      #$6, d0
043a: c1ee0008             muls.w     $8(a6), d0
043e: 2050                 movea.l    (a0), a0
0440: 20700802             movea.l    $2(a0, d0.l), a0
0444: a02a                 dc.w       $a02a
0446: 4e5e                 unlk       a6
0448: 4e75                 rts        
044a: 4e56fff6             link.w     a6, #$fff6
044e: 48e70308             movem.l    d6-d7/a4, -(a7)
0452: 42a7                 clr.l      -(a7)
0454: 206ddeb8             movea.l    -$2148(a5), a0
0458: 2f2800ca             move.l     $ca(a0), -(a7)
045c: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
0460: 2d5ffff6             move.l     (a7)+, -$a(a6)
0464: 48780006             pea.l      $6.w
0468: 2f2efff6             move.l     -$a(a6), -(a7)
046c: 4ead004a             jsr        $4a(a5) ; CODE1+0124
0470: 2e00                 move.l     d0, d7
0472: 7c00                 moveq      #$0, d6
0474: 99cc                 suba.l     a4, a4
0476: 601c                 bra.b      $494
0478: 204c                 movea.l    a4, a0
047a: d1ee000c             adda.l     $c(a6), a0
047e: 2f08                 move.l     a0, -(a7)
0480: 3f06                 move.w     d6, -(a7)
0482: 2f2ddeb8             move.l     -$2148(a5), -(a7)
0486: 4ead0152             jsr        $152(a5) ; CODE7+08bc
048a: 4fef000a             lea.l      $a(a7), a7
048e: 5246                 addq.w     #$1, d6
0490: 49ec0022             lea.l      $22(a4), a4
0494: bc6e0010             cmp.w      $10(a6), d6
0498: 6dde                 blt.b      $478
049a: 7006                 moveq      #$6, d0
049c: c1c6                 muls.w     d6, d0
049e: 2840                 movea.l    d0, a4
04a0: 6014                 bra.b      $4b6
04a2: 206ddeb8             movea.l    -$2148(a5), a0
04a6: 206800ca             movea.l    $ca(a0), a0
04aa: 2010                 move.l     (a0), d0
04ac: 20740802             movea.l    $2(a4, d0.l), a0
04b0: a023                 dc.w       $a023
04b2: 5246                 addq.w     #$1, d6
04b4: 5c8c                 addq.l     #$6, a4
04b6: 3046                 movea.w    d6, a0
04b8: be88                 cmp.l      a0, d7
04ba: 6ee6                 bgt.b      $4a2
04bc: 206ddeb8             movea.l    -$2148(a5), a0
04c0: 7006                 moveq      #$6, d0
04c2: c1ee0010             muls.w     $10(a6), d0
04c6: 206800ca             movea.l    $ca(a0), a0
04ca: a024                 dc.w       $a024
04cc: 4a780220             tst.w      $220.w
04d0: 6704                 beq.b      $4d6
04d2: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
04d6: 4eba002c             jsr        $504(pc)
04da: 2f2e0008             move.l     $8(a6), -(a7)
04de: 206ddeb8             movea.l    -$2148(a5), a0
04e2: 486800aa             pea.l      $aa(a0)
04e6: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
04ea: 2eaddeb8             move.l     -$2148(a5), (a7)
04ee: a873                 dc.w       $a873
04f0: 206ddeb8             movea.l    -$2148(a5), a0
04f4: 48680010             pea.l      $10(a0)
04f8: a928                 dc.w       $a928
04fa: 4cee10c0ffea         movem.l    -$16(a6), d6-d7/a4
0500: 4e5e                 unlk       a6
0502: 4e75                 rts        
0504: 4e56fffc             link.w     a6, #$fffc
0508: 2f07                 move.l     d7, -(a7)
050a: 42a7                 clr.l      -(a7)
050c: 206ddeb8             movea.l    -$2148(a5), a0
0510: 2f2800ca             move.l     $ca(a0), -(a7)
0514: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
0518: 2d5ffffc             move.l     (a7)+, -$4(a6)
051c: 48780006             pea.l      $6.w
0520: 2f2efffc             move.l     -$4(a6), -(a7)
0524: 4ead004a             jsr        $4a(a5) ; CODE1+0124
0528: 3e00                 move.w     d0, d7
052a: 4a47                 tst.w      d7
052c: 660c                 bne.b      $53a
052e: 2f2ddeb8             move.l     -$2148(a5), -(a7)
0532: 4ead0c02             jsr        $c02(a5) ; CODE46+0658
0536: 588f                 addq.l     #$4, a7
0538: 6032                 bra.b      $56c
053a: 2f2ddeb8             move.l     -$2148(a5), -(a7)
053e: 206ddeb8             movea.l    -$2148(a5), a0
0542: 3f280016             move.w     $16(a0), -(a7)
0546: 700c                 moveq      #$c, d0
0548: c1c7                 muls.w     d7, d0
054a: 3f00                 move.w     d0, -(a7)
054c: 1f3c0001             move.b     #$1, -(a7)
0550: a91d                 dc.w       $a91d
0552: be6dd76a             cmp.w      -$2896(a5), d7
0556: 6e14                 bgt.b      $56c
0558: 70ff                 moveq      #$ff, d0
055a: d047                 add.w      d7, d0
055c: 3b40d76a             move.w     d0, -$2896(a5)
0560: 42ade368             clr.l      -$1c98(a5)
0564: 3f00                 move.w     d0, -(a7)
0566: 4eba01d6             jsr        $73e(pc)
056a: 548f                 addq.l     #$2, a7
056c: 2e1f                 move.l     (a7)+, d7
056e: 4e5e                 unlk       a6
0570: 4e75                 rts        
0572: 4e56ff58             link.w     a6, #$ff58
0576: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
057a: 286e0008             movea.l    $8(a6), a4
057e: 426eff60             clr.w      -$a0(a6)
0582: 426eff62             clr.w      -$9e(a6)
0586: 2f2c0018             move.l     $18(a4), -(a7)
058a: a8d4                 dc.w       $a8d4
058c: 47eeffde             lea.l      -$22(a6), a3
0590: 206c00ca             movea.l    $ca(a4), a0
0594: 2050                 movea.l    (a0), a0
0596: 20680002             movea.l    $2(a0), a0
059a: 2050                 movea.l    (a0), a0
059c: 43eeffbc             lea.l      -$44(a6), a1
05a0: 7007                 moveq      #$7, d0
05a2: 22d8                 move.l     (a0)+, (a1)+
05a4: 51c8fffc             dbra       d0, $5a2
05a8: 32d8                 move.w     (a0)+, (a1)+
05aa: 41eeffde             lea.l      -$22(a6), a0
05ae: 43e9ffde             lea.l      -$22(a1), a1
05b2: 7007                 moveq      #$7, d0
05b4: 20d9                 move.l     (a1)+, (a0)+
05b6: 51c8fffc             dbra       d0, $5b4
05ba: 30d9                 move.w     (a1)+, (a0)+
05bc: 282b0014             move.l     $14(a3), d4
05c0: d8ab0010             add.l      $10(a3), d4
05c4: d8ab0018             add.l      $18(a3), d4
05c8: 2a04                 move.l     d4, d5
05ca: 42a7                 clr.l      -(a7)
05cc: 2f2c00ca             move.l     $ca(a4), -(a7)
05d0: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
05d4: 2d5fff58             move.l     (a7)+, -$a8(a6)
05d8: 48780006             pea.l      $6.w
05dc: 2f2eff58             move.l     -$a8(a6), -(a7)
05e0: 4ead004a             jsr        $4a(a5) ; CODE1+0124
05e4: 2d40ff68             move.l     d0, -$98(a6)
05e8: 7600                 moveq      #$0, d3
05ea: 41ec0016             lea.l      $16(a4), a0
05ee: 2d48ff70             move.l     a0, -$90(a6)
05f2: 43ec0012             lea.l      $12(a4), a1
05f6: 2d49ff6c             move.l     a1, -$94(a6)
05fa: 7c0c                 moveq      #$c, d6
05fc: cdc3                 muls.w     d3, d6
05fe: 7206                 moveq      #$6, d1
0600: c3c3                 muls.w     d3, d1
0602: 2d41ff64             move.l     d1, -$9c(a6)
0606: 6000011a             bra.w      $722
060a: 206c00ca             movea.l    $ca(a4), a0
060e: 2050                 movea.l    (a0), a0
0610: d1eeff64             adda.l     -$9c(a6), a0
0614: 20680002             movea.l    $2(a0), a0
0618: 2050                 movea.l    (a0), a0
061a: 43eeffde             lea.l      -$22(a6), a1
061e: 7007                 moveq      #$7, d0
0620: 22d8                 move.l     (a0)+, (a1)+
0622: 51c8fffc             dbra       d0, $620
0626: 32d8                 move.w     (a0)+, (a1)+
0628: 45edfac2             lea.l      -$53e(a5), a2
062c: 2e2b0014             move.l     $14(a3), d7
0630: deab0010             add.l      $10(a3), d7
0634: deab0018             add.l      $18(a3), d7
0638: 2004                 move.l     d4, d0
063a: 9087                 sub.l      d7, d0
063c: 2d40ff5c             move.l     d0, -$a4(a6)
0640: 0c80000000c8         cmpi.l     #$c8, d0
0646: 6f16                 ble.b      $65e
0648: 2004                 move.l     d4, d0
064a: 9085                 sub.l      d5, d0
064c: 0c80000000c8         cmpi.l     #$c8, d0
0652: 6e0a                 bgt.b      $65e
0654: 4a6eff60             tst.w      -$a0(a6)
0658: 6604                 bne.b      $65e
065a: 45edfab2             lea.l      -$54e(a5), a2
065e: 0cae000001f4ff5c     cmpi.l     #$1f4, -$a4(a6)
0666: 6f16                 ble.b      $67e
0668: 2004                 move.l     d4, d0
066a: 9085                 sub.l      d5, d0
066c: 0c80000001f4         cmpi.l     #$1f4, d0
0672: 6e0a                 bgt.b      $67e
0674: 4a6eff62             tst.w      -$9e(a6)
0678: 6604                 bne.b      $67e
067a: 45edfaba             lea.l      -$546(a5), a2
067e: 41edfac2             lea.l      -$53e(a5), a0
0682: b1ca                 cmpa.l     a2, a0
0684: 6742                 beq.b      $6c8
0686: 41edfab2             lea.l      -$54e(a5), a0
068a: b1ca                 cmpa.l     a2, a0
068c: 57c0                 seq.b      d0
068e: 4400                 neg.b      d0
0690: 4880                 ext.w      d0
0692: 3d40ff60             move.w     d0, -$a0(a6)
0696: 41edfaba             lea.l      -$546(a5), a0
069a: b1ca                 cmpa.l     a2, a0
069c: 57c1                 seq.b      d1
069e: 4401                 neg.b      d1
06a0: 4881                 ext.w      d1
06a2: 3d41ff62             move.w     d1, -$9e(a6)
06a6: 4267                 clr.w      -(a7)
06a8: 3f06                 move.w     d6, -(a7)
06aa: a893                 dc.w       $a893
06ac: 2f0a                 move.l     a2, -(a7)
06ae: a89d                 dc.w       $a89d
06b0: 206eff6c             movea.l    -$94(a6), a0
06b4: 226eff70             movea.l    -$90(a6), a1
06b8: 3011                 move.w     (a1), d0
06ba: 9050                 sub.w      (a0), d0
06bc: 3f00                 move.w     d0, -(a7)
06be: 4267                 clr.w      -(a7)
06c0: a892                 dc.w       $a892
06c2: 486dfaba             pea.l      -$546(a5)
06c6: a89d                 dc.w       $a89d
06c8: 2a07                 move.l     d7, d5
06ca: 2f0b                 move.l     a3, -(a7)
06cc: 2f0b                 move.l     a3, -(a7)
06ce: 2f0b                 move.l     a3, -(a7)
06d0: 4a2b0020             tst.b      $20(a3)
06d4: 6704                 beq.b      $6da
06d6: 7004                 moveq      #$4, d0
06d8: 6002                 bra.b      $6dc
06da: 7004                 moveq      #$4, d0
06dc: 3f00                 move.w     d0, -(a7)
06de: 2f0b                 move.l     a3, -(a7)
06e0: 486effbc             pea.l      -$44(a6)
06e4: 2f0b                 move.l     a3, -(a7)
06e6: 4ebafa34             jsr        $11c(pc)
06ea: 588f                 addq.l     #$4, a7
06ec: 2e80                 move.l     d0, (a7)
06ee: 206ddeb8             movea.l    -$2148(a5), a0
06f2: 486800aa             pea.l      $aa(a0)
06f6: 486eff75             pea.l      -$8b(a6)
06fa: 4ead0812             jsr        $812(a5) ; CODE24+16a6
06fe: 1d40ff74             move.b     d0, -$8c(a6)
0702: 3ebc0001             move.w     #$1, (a7)
0706: 700a                 moveq      #$a, d0
0708: d046                 add.w      d6, d0
070a: 3f00                 move.w     d0, -(a7)
070c: a893                 dc.w       $a893
070e: 486eff74             pea.l      -$8c(a6)
0712: a884                 dc.w       $a884
0714: 4fef001c             lea.l      $1c(a7), a7
0718: 5243                 addq.w     #$1, d3
071a: 0646000c             addi.w     #$c, d6
071e: 5caeff64             addq.l     #$6, -$9c(a6)
0722: 3043                 movea.w    d3, a0
0724: b1eeff68             cmpa.l     -$98(a6), a0
0728: 6d00fee0             blt.w      $60a
072c: 3f2dd76a             move.w     -$2896(a5), -(a7)
0730: 4eba000c             jsr        $73e(pc)
0734: 4cee1cf8ff38         movem.l    -$c8(a6), d3-d7/a2-a4
073a: 4e5e                 unlk       a6
073c: 4e75                 rts        
073e: 4e56fff8             link.w     a6, #$fff8
0742: 4a6e0008             tst.w      $8(a6)
0746: 6d30                 blt.b      $778
0748: 2f2ddeb8             move.l     -$2148(a5), -(a7)
074c: a873                 dc.w       $a873
074e: 206ddeb8             movea.l    -$2148(a5), a0
0752: 2d680010fff8         move.l     $10(a0), -$8(a6)
0758: 2d680014fffc         move.l     $14(a0), -$4(a6)
075e: 700c                 moveq      #$c, d0
0760: c1ee0008             muls.w     $8(a6), d0
0764: 3d40fffc             move.w     d0, -$4(a6)
0768: 3d40fff8             move.w     d0, -$8(a6)
076c: 066e000cfffc         addi.w     #$c, -$4(a6)
0772: 486efff8             pea.l      -$8(a6)
0776: a8a4                 dc.w       $a8a4
0778: 4e5e                 unlk       a6
077a: 4e75                 rts        
077c: 4e56ffc4             link.w     a6, #$ffc4
0780: 48e71f38             movem.l    d3-d7/a2-a4, -(a7)
0784: 266e0008             movea.l    $8(a6), a3
0788: 286e000c             movea.l    $c(a6), a4
078c: 2d6c000afffc         move.l     $a(a4), -$4(a6)
0792: 2f0b                 move.l     a3, -(a7)
0794: a873                 dc.w       $a873
0796: b7eddeb8             cmpa.l     -$2148(a5), a3
079a: 6704                 beq.b      $7a0
079c: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
07a0: 486efffc             pea.l      -$4(a6)
07a4: a871                 dc.w       $a871
07a6: 3e2efffc             move.w     -$4(a6), d7
07aa: 48c7                 ext.l      d7
07ac: 8ffc000c             divs.w     #$c, d7
07b0: 0c540001             cmpi.w     #$1, (a4)
07b4: 6600016e             bne.w      $924
07b8: 4ead043a             jsr        $43a(a5) ; CODE20+0194
07bc: be6dd76a             cmp.w      -$2896(a5), d7
07c0: 6600015c             bne.w      $91e
07c4: 202c0006             move.l     $6(a4), d0
07c8: 90ade368             sub.l      -$1c98(a5), d0
07cc: b0b802f0             cmp.l      $2f0.w, d0
07d0: 6200014c             bhi.w      $91e
07d4: 246b00ca             movea.l    $ca(a3), a2
07d8: 42a7                 clr.l      -(a7)
07da: 2f0a                 move.l     a2, -(a7)
07dc: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
07e0: 2d5fffc4             move.l     (a7)+, -$3c(a6)
07e4: 48780006             pea.l      $6.w
07e8: 2f2effc4             move.l     -$3c(a6), -(a7)
07ec: 4ead004a             jsr        $4a(a5) ; CODE1+0124
07f0: 3c00                 move.w     d0, d6
07f2: bc47                 cmp.w      d7, d6
07f4: 6f000128             ble.w      $91e
07f8: 7006                 moveq      #$6, d0
07fa: c1c7                 muls.w     d7, d0
07fc: 2052                 movea.l    (a2), a0
07fe: 20700802             movea.l    $2(a0, d0.l), a0
0802: 2050                 movea.l    (a0), a0
0804: 43eeffca             lea.l      -$36(a6), a1
0808: 7007                 moveq      #$7, d0
080a: 22d8                 move.l     (a0)+, (a1)+
080c: 51c8fffc             dbra       d0, $80a
0810: 32d8                 move.w     (a0)+, (a1)+
0812: 4a2effea             tst.b      -$16(a6)
0816: 6644                 bne.b      $85c
0818: 486effca             pea.l      -$36(a6)
081c: 486da74e             pea.l      -$58b2(a5)
0820: 4ead0da2             jsr        $da2(a5) ; CODE52+021c
0824: 47eeffca             lea.l      -$36(a6), a3
0828: 508f                 addq.l     #$8, a7
082a: 6024                 bra.b      $850
082c: 7a00                 moveq      #$0, d5
082e: 45edde28             lea.l      -$21d8(a5), a2
0832: 6004                 bra.b      $838
0834: 5245                 addq.w     #$1, d5
0836: 588a                 addq.l     #$4, a2
0838: 4a6a0002             tst.w      $2(a2)
083c: 66f6                 bne.b      $834
083e: bc52                 cmp.w      (a2), d6
0840: 66f2                 bne.b      $834
0842: 3f3c0001             move.w     #$1, -(a7)
0846: 3f05                 move.w     d5, -(a7)
0848: 4ead0562             jsr        $562(a5) ; CODE21+0598
084c: 588f                 addq.l     #$4, a7
084e: 528b                 addq.l     #$1, a3
0850: 1c13                 move.b     (a3), d6
0852: 4886                 ext.w      d6
0854: 4a46                 tst.w      d6
0856: 66d4                 bne.b      $82c
0858: 600000c4             bra.w      $91e
085c: 486effec             pea.l      -$14(a6)
0860: 486dc366             pea.l      -$3c9a(a5)
0864: 486effca             pea.l      -$36(a6)
0868: 4ead098a             jsr        $98a(a5) ; CODE32+0004
086c: 0c2e0010ffea         cmpi.b     #$10, -$16(a6)
0872: 4fef000c             lea.l      $c(a7), a7
0876: 6c10                 bge.b      $888
0878: 1a2effea             move.b     -$16(a6), d5
087c: 4885                 ext.w      d5
087e: 182effeb             move.b     -$15(a6), d4
0882: 4884                 ext.w      d4
0884: 7600                 moveq      #$0, d3
0886: 6042                 bra.b      $8ca
0888: 4a6dbcf4             tst.w      -$430c(a5)
088c: 6712                 beq.b      $8a0
088e: 3a2dbcf8             move.w     -$4308(a5), d5
0892: 70f1                 moveq      #$f1, d0
0894: d06dbcf4             add.w      -$430c(a5), d0
0898: 3b40bcf8             move.w     d0, -$4308(a5)
089c: 3b45bcf4             move.w     d5, -$430c(a5)
08a0: 4a6dbcf6             tst.w      -$430a(a5)
08a4: 6712                 beq.b      $8b8
08a6: 3a2dbcfa             move.w     -$4306(a5), d5
08aa: 70f1                 moveq      #$f1, d0
08ac: d06dbcf6             add.w      -$430a(a5), d0
08b0: 3b40bcfa             move.w     d0, -$4306(a5)
08b4: 3b45bcf6             move.w     d5, -$430a(a5)
08b8: 1a2effeb             move.b     -$15(a6), d5
08bc: 4885                 ext.w      d5
08be: 182effea             move.b     -$16(a6), d4
08c2: 4884                 ext.w      d4
08c4: 0644fff1             addi.w     #$fff1, d4
08c8: 7601                 moveq      #$1, d3
08ca: 7001                 moveq      #$1, d0
08cc: 9043                 sub.w      d3, d0
08ce: 3d40ffc8             move.w     d0, -$38(a6)
08d2: 47eeffca             lea.l      -$36(a6), a3
08d6: 603e                 bra.b      $916
08d8: 48780001             pea.l      $1.w
08dc: ba6dbcf4             cmp.w      -$430c(a5), d5
08e0: 6606                 bne.b      $8e8
08e2: b86dbcf8             cmp.w      -$4308(a5), d4
08e6: 670c                 beq.b      $8f4
08e8: ba6dbcf6             cmp.w      -$430a(a5), d5
08ec: 660a                 bne.b      $8f8
08ee: b86dbcfa             cmp.w      -$4306(a5), d4
08f2: 6604                 bne.b      $8f8
08f4: 3006                 move.w     d6, d0
08f6: 6008                 bra.b      $900
08f8: 3f06                 move.w     d6, -(a7)
08fa: 4ead0dea             jsr        $dea(a5) ; CODE52+0138
08fe: 548f                 addq.l     #$2, a7
0900: 3f00                 move.w     d0, -(a7)
0902: 3f04                 move.w     d4, -(a7)
0904: 3f05                 move.w     d5, -(a7)
0906: 4ead055a             jsr        $55a(a5) ; CODE21+00fc
090a: 4fef000a             lea.l      $a(a7), a7
090e: da43                 add.w      d3, d5
0910: d86effc8             add.w      -$38(a6), d4
0914: 528b                 addq.l     #$1, a3
0916: 1c13                 move.b     (a3), d6
0918: 4886                 ext.w      d6
091a: 4a46                 tst.w      d6
091c: 66ba                 bne.b      $8d8
091e: 2b6c0006e368         move.l     $6(a4), -$1c98(a5)
0924: 3f07                 move.w     d7, -(a7)
0926: 4ebaf9b6             jsr        $2de(pc)
092a: 4cee1cf8ffa4         movem.l    -$5c(a6), d3-d7/a2-a4
0930: 4e5e                 unlk       a6
0932: 4e75                 rts        
0934: 4e56fff4             link.w     a6, #$fff4
0938: 48e70118             movem.l    d7/a3-a4, -(a7)
093c: 286e0008             movea.l    $8(a6), a4
0940: 2f0c                 move.l     a4, -(a7)
0942: a873                 dc.w       $a873
0944: 2d6c0010fff8         move.l     $10(a4), -$8(a6)
094a: 2d6c0014fffc         move.l     $14(a4), -$4(a6)
0950: 42a7                 clr.l      -(a7)
0952: 2f2c00ca             move.l     $ca(a4), -(a7)
0956: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
095a: 2d5ffff4             move.l     (a7)+, -$c(a6)
095e: 48780006             pea.l      $6.w
0962: 2f2efff4             move.l     -$c(a6), -(a7)
0966: 4ead004a             jsr        $4a(a5) ; CODE1+0124
096a: 2e00                 move.l     d0, d7
096c: 4a6dd76a             tst.w      -$2896(a5)
0970: 6d08                 blt.b      $97a
0972: 306dd76a             movea.w    -$2896(a5), a0
0976: be88                 cmp.l      a0, d7
0978: 6e04                 bgt.b      $97e
097a: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
097e: 700c                 moveq      #$c, d0
0980: c1edd76a             muls.w     -$2896(a5), d0
0984: 3d40fff8             move.w     d0, -$8(a6)
0988: 486efff8             pea.l      -$8(a6)
098c: a928                 dc.w       $a928
098e: 4a87                 tst.l      d7
0990: 6e04                 bgt.b      $996
0992: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0996: 42a7                 clr.l      -(a7)
0998: 2f2c00ca             move.l     $ca(a4), -(a7)
099c: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
09a0: 2d5ffff4             move.l     (a7)+, -$c(a6)
09a4: 2f07                 move.l     d7, -(a7)
09a6: 48780006             pea.l      $6.w
09aa: 4ead0042             jsr        $42(a5) ; CODE1+00ee
09ae: b0aefff4             cmp.l      -$c(a6), d0
09b2: 6704                 beq.b      $9b8
09b4: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
09b8: 2f2c00ca             move.l     $ca(a4), -(a7)
09bc: 4ead05ea             jsr        $5ea(a5) ; CODE9+022e
09c0: 2640                 movea.l    d0, a3
09c2: 7006                 moveq      #$6, d0
09c4: c1edd76a             muls.w     -$2896(a5), d0
09c8: 20730802             movea.l    $2(a3, d0.l), a0
09cc: a023                 dc.w       $a023
09ce: 7006                 moveq      #$6, d0
09d0: 2e80                 move.l     d0, (a7)
09d2: 306dd76a             movea.w    -$2896(a5), a0
09d6: 2007                 move.l     d7, d0
09d8: 5380                 subq.l     #$1, d0
09da: 9088                 sub.l      a0, d0
09dc: 2f00                 move.l     d0, -(a7)
09de: 4ead0042             jsr        $42(a5) ; CODE1+00ee
09e2: 2f00                 move.l     d0, -(a7)
09e4: 7006                 moveq      #$6, d0
09e6: c1edd76a             muls.w     -$2896(a5), d0
09ea: 48730806             pea.l      $6(a3, d0.l)
09ee: 7006                 moveq      #$6, d0
09f0: c1edd76a             muls.w     -$2896(a5), d0
09f4: 48730800             pea.l      (a3, d0.l)
09f8: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
09fc: 206c00ca             movea.l    $ca(a4), a0
0a00: a02a                 dc.w       $a02a
0a02: 70fa                 moveq      #$fa, d0
0a04: 2e80                 move.l     d0, (a7)
0a06: 2f2c00ca             move.l     $ca(a4), -(a7)
0a0a: 4ead05ca             jsr        $5ca(a5) ; CODE9+01ea
0a0e: 4ebafaf4             jsr        $504(pc)
0a12: 4cee1880ffe8         movem.l    -$18(a6), d7/a3-a4
0a18: 4e5e                 unlk       a6
0a1a: 4e75                 rts        
0a1c: 4e56fffc             link.w     a6, #$fffc
0a20: 48e70108             movem.l    d7/a4, -(a7)
0a24: 42a7                 clr.l      -(a7)
0a26: 206e0008             movea.l    $8(a6), a0
0a2a: 2f2800ca             move.l     $ca(a0), -(a7)
0a2e: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
0a32: 2d5ffffc             move.l     (a7)+, -$4(a6)
0a36: 48780006             pea.l      $6.w
0a3a: 2f2efffc             move.l     -$4(a6), -(a7)
0a3e: 4ead004a             jsr        $4a(a5) ; CODE1+0124
0a42: 306dd76a             movea.w    -$2896(a5), a0
0a46: b088                 cmp.l      a0, d0
0a48: 630e                 bls.b      $a58
0a4a: 4a6dd76a             tst.w      -$2896(a5)
0a4e: 6d08                 blt.b      $a58
0a50: 49ede36c             lea.l      -$1c94(a5), a4
0a54: 7e01                 moveq      #$1, d7
0a56: 6006                 bra.b      $a5e
0a58: 286df250             movea.l    -$db0(a5), a4
0a5c: 7e00                 moveq      #$0, d7
0a5e: 2f2e000c             move.l     $c(a6), -(a7)
0a62: 4267                 clr.w      -(a7)
0a64: 2f2e0010             move.l     $10(a6), -(a7)
0a68: a86b                 dc.w       $a86b
0a6a: 2f0c                 move.l     a4, -(a7)
0a6c: a947                 dc.w       $a947
0a6e: 2007                 move.l     d7, d0
0a70: 4cdf1080             movem.l    (a7)+, d7/a4
0a74: 4e5e                 unlk       a6
0a76: 4e75                 rts        
0a78: 2f2ddeb8             move.l     -$2148(a5), -(a7)
0a7c: 486de376             pea.l      -$1c8a(a5)
0a80: a91a                 dc.w       $a91a
0a82: 2f2ddeb8             move.l     -$2148(a5), -(a7)
0a86: 4ead0c3a             jsr        $c3a(a5) ; CODE46+0966
0a8a: 2eaddeb8             move.l     -$2148(a5), (a7)
0a8e: 4ead0c1a             jsr        $c1a(a5) ; CODE46+0742
0a92: 2eaddeb8             move.l     -$2148(a5), (a7)
0a96: a873                 dc.w       $a873
0a98: 206ddeb8             movea.l    -$2148(a5), a0
0a9c: 48680010             pea.l      $10(a0)
0aa0: a8a3                 dc.w       $a8a3
0aa2: 3b7cffffd76a         move.w     #$ffff, -$2896(a5)
0aa8: 4e75                 rts        
0aaa: 2f2ddeb8             move.l     -$2148(a5), -(a7)
0aae: 4ead066a             jsr        $66a(a5) ; CODE9+0f00
0ab2: 4a40                 tst.w      d0
0ab4: 588f                 addq.l     #$4, a7
0ab6: 6612                 bne.b      $aca
0ab8: 42a7                 clr.l      -(a7)
0aba: 206ddeb8             movea.l    -$2148(a5), a0
0abe: 2f2800ca             move.l     $ca(a0), -(a7)
0ac2: 4ead0b0a             jsr        $b0a(a5) ; CODE34+01b2
0ac6: 4a9f                 tst.l      (a7)+
0ac8: 6604                 bne.b      $ace
0aca: 7000                 moveq      #$0, d0
0acc: 6002                 bra.b      $ad0
0ace: 7001                 moveq      #$1, d0
0ad0: 4e75                 rts        
