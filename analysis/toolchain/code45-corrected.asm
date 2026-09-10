0004: 4e56fff4             link.w     a6, #$fff4
0008: 48e70318             movem.l    d6-d7/a3-a4, -(a7)
000c: 286e0008             movea.l    $8(a6), a4
0010: 0c6d0001b1d6         cmpi.w     #$1, -$4e2a(a5)
0016: 6616                 bne.b      $2e
0018: 0c2c000f0020         cmpi.b     #$f, $20(a4)
001e: 6f0e                 ble.b      $2e
0020: 2f0c                 move.l     a4, -(a7)
0022: 4ead0aca             jsr        $aca(a5) ; CODE44+00ee
0026: 4a40                 tst.w      d0
0028: 588f                 addq.l     #$4, a7
002a: 6700017c             beq.w      $1a8
002e: 4a6c001c             tst.w      $1c(a4)
0032: 6720                 beq.b      $54
0034: 202c0010             move.l     $10(a4), d0
0038: b0ada5de             cmp.l      -$5a22(a5), d0
003c: 6f00016a             ble.w      $1a8
0040: 41eda5ce             lea.l      -$5a32(a5), a0
0044: 43d4                 lea.l      (a4), a1
0046: 7007                 moveq      #$7, d0
0048: 20d9                 move.l     (a1)+, (a0)+
004a: 51c8fffc             dbra       d0, $48
004e: 30d9                 move.w     (a1)+, (a0)+
0050: 60000156             bra.w      $1a8
0054: 2d6df9d4fff8         move.l     -$62c(a5), -$8(a6)
005a: 2d6df9fcfff4         move.l     -$604(a5), -$c(a6)
0060: 486efffc             pea.l      -$4(a6)
0064: 486efffe             pea.l      -$2(a6)
0068: 486efff4             pea.l      -$c(a6)
006c: 486efff8             pea.l      -$8(a6)
0070: 2f0c                 move.l     a4, -(a7)
0072: 4ead082a             jsr        $82a(a5) ; CODE27+0026
0076: 4a40                 tst.w      d0
0078: 4fef0014             lea.l      $14(a7), a7
007c: 6600012a             bne.w      $1a8
0080: 7e00                 moveq      #$0, d7
0082: 47edf9b0             lea.l      -$650(a5), a3
0086: 6004                 bra.b      $8c
0088: 5247                 addq.w     #$1, d7
008a: 588b                 addq.l     #$4, a3
008c: be6dcf04             cmp.w      -$30fc(a5), d7
0090: 6c08                 bge.b      $9a
0092: 202efff8             move.l     -$8(a6), d0
0096: b093                 cmp.l      (a3), d0
0098: 6fee                 ble.b      $88
009a: 7c00                 moveq      #$0, d6
009c: 47edf9d8             lea.l      -$628(a5), a3
00a0: 6004                 bra.b      $a6
00a2: 5246                 addq.w     #$1, d6
00a4: 588b                 addq.l     #$4, a3
00a6: bc6dcf04             cmp.w      -$30fc(a5), d6
00aa: 6c08                 bge.b      $b4
00ac: 202efff4             move.l     -$c(a6), d0
00b0: b093                 cmp.l      (a3), d0
00b2: 6fee                 ble.b      $a2
00b4: 0c6d000acf04         cmpi.w     #$a, -$30fc(a5)
00ba: 6404                 bcc.b      $c0
00bc: 526dcf04             addq.w     #$1, -$30fc(a5)
00c0: 0c47000a             cmpi.w     #$a, d7
00c4: 6438                 bcc.b      $fe
00c6: 2007                 move.l     d7, d0
00c8: 48c0                 ext.l      d0
00ca: e588                 lsl.l      #$2, d0
00cc: 47edf9b0             lea.l      -$650(a5), a3
00d0: d08b                 add.l      a3, d0
00d2: 2640                 movea.l    d0, a3
00d4: 70ff                 moveq      #$ff, d0
00d6: d06dcf04             add.w      -$30fc(a5), d0
00da: 9047                 sub.w      d7, d0
00dc: 48c0                 ext.l      d0
00de: e588                 lsl.l      #$2, d0
00e0: 2f00                 move.l     d0, -(a7)
00e2: 2f0b                 move.l     a3, -(a7)
00e4: 204d                 movea.l    a5, a0
00e6: 2007                 move.l     d7, d0
00e8: 48c0                 ext.l      d0
00ea: e588                 lsl.l      #$2, d0
00ec: d1c0                 adda.l     d0, a0
00ee: 4868f9b4             pea.l      -$64c(a0)
00f2: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
00f6: 26aefff8             move.l     -$8(a6), (a3)
00fa: 4fef000c             lea.l      $c(a7), a7
00fe: 0c46000a             cmpi.w     #$a, d6
0102: 6438                 bcc.b      $13c
0104: 2006                 move.l     d6, d0
0106: 48c0                 ext.l      d0
0108: e588                 lsl.l      #$2, d0
010a: 47edf9d8             lea.l      -$628(a5), a3
010e: d08b                 add.l      a3, d0
0110: 2640                 movea.l    d0, a3
0112: 70ff                 moveq      #$ff, d0
0114: d06dcf04             add.w      -$30fc(a5), d0
0118: 9046                 sub.w      d6, d0
011a: 48c0                 ext.l      d0
011c: e588                 lsl.l      #$2, d0
011e: 2f00                 move.l     d0, -(a7)
0120: 2f0b                 move.l     a3, -(a7)
0122: 204d                 movea.l    a5, a0
0124: 2006                 move.l     d6, d0
0126: 48c0                 ext.l      d0
0128: e588                 lsl.l      #$2, d0
012a: d1c0                 adda.l     d0, a0
012c: 4868f9dc             pea.l      -$624(a0)
0130: 4ead0d8a             jsr        $d8a(a5) ; CODE52+019e
0134: 26aefff4             move.l     -$c(a6), (a3)
0138: 4fef000c             lea.l      $c(a7), a7
013c: 4a2c0020             tst.b      $20(a4)
0140: 6634                 bne.b      $176
0142: 2f2dcf28             move.l     -$30d8(a5), -(a7)
0146: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
014a: 3c00                 move.w     d0, d6
014c: 2eadcf2c             move.l     -$30d4(a5), (a7)
0150: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
0154: 9c40                 sub.w      d0, d6
0156: 3046                 movea.w    d6, a0
0158: b1eefff4             cmpa.l     -$c(a6), a0
015c: 588f                 addq.l     #$4, a7
015e: 6c06                 bge.b      $166
0160: 3046                 movea.w    d6, a0
0162: 2d48fff4             move.l     a0, -$c(a6)
0166: 3046                 movea.w    d6, a0
0168: b1eefff8             cmpa.l     -$8(a6), a0
016c: 6c14                 bge.b      $182
016e: 3046                 movea.w    d6, a0
0170: 2d48fff8             move.l     a0, -$8(a6)
0174: 600c                 bra.b      $182
0176: 2e2c0010             move.l     $10(a4), d7
017a: 9faefff8             sub.l      d7, -$8(a6)
017e: 9faefff4             sub.l      d7, -$c(a6)
0182: 306efffe             movea.w    -$2(a6), a0
0186: 29480014             move.l     a0, $14(a4)
018a: 306efffc             movea.w    -$4(a6), a0
018e: 29480018             move.l     a0, $18(a4)
0192: 202efff8             move.l     -$8(a6), d0
0196: 4480                 neg.l      d0
0198: 2f00                 move.l     d0, -(a7)
019a: 202efff4             move.l     -$c(a6), d0
019e: 4480                 neg.l      d0
01a0: 2f00                 move.l     d0, -(a7)
01a2: 2f0c                 move.l     a4, -(a7)
01a4: 4ead08a2             jsr        $8a2(a5) ; CODE30+0c22
01a8: 4cee18c0ffe4         movem.l    -$1c(a6), d6-d7/a3-a4
01ae: 4e5e                 unlk       a6
01b0: 4e75                 rts        
01b2: 4e560000             link.w     a6, #$0
01b6: 48e70308             movem.l    d6-d7/a4, -(a7)
01ba: 286e0008             movea.l    $8(a6), a4
01be: 2f2e000c             move.l     $c(a6), -(a7)
01c2: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
01c6: d040                 add.w      d0, d0
01c8: 48c0                 ext.l      d0
01ca: 2e00                 move.l     d0, d7
01cc: 42ac0014             clr.l      $14(a4)
01d0: 7001                 moveq      #$1, d0
01d2: 29400018             move.l     d0, $18(a4)
01d6: 2c07                 move.l     d7, d6
01d8: 4486                 neg.l      d6
01da: 2e86                 move.l     d6, (a7)
01dc: 2f06                 move.l     d6, -(a7)
01de: 2f0c                 move.l     a4, -(a7)
01e0: 4ead08a2             jsr        $8a2(a5) ; CODE30+0c22
01e4: 4cee10c0fff4         movem.l    -$c(a6), d6-d7/a4
01ea: 4e5e                 unlk       a6
01ec: 4e75                 rts        
01ee: 4e56fffa             link.w     a6, #$fffa
01f2: 48e70018             movem.l    a3-a4, -(a7)
01f6: 286e0008             movea.l    $8(a6), a4
01fa: 4ead0a22             jsr        $a22(a5) ; CODE37+0e2e
01fe: 302c0008             move.w     $8(a4), d0
0202: 9154                 sub.w      d0, (a4)
0204: 426c0008             clr.w      $8(a4)
0208: 4a2c0018             tst.b      $18(a4)
020c: 660a                 bne.b      $218
020e: 4a2c001d             tst.b      $1d(a4)
0212: 6704                 beq.b      $218
0214: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0218: 4a2c001a             tst.b      $1a(a4)
021c: 662c                 bne.b      $24a
021e: 4ead08b2             jsr        $8b2(a5) ; CODE30+0004
0222: 4a40                 tst.w      d0
0224: 6724                 beq.b      $24a
0226: 2f2dcf2c             move.l     -$30d4(a5), -(a7)
022a: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
022e: 3d40fffa             move.w     d0, -$6(a6)
0232: 2eadcf28             move.l     -$30d8(a5), (a7)
0236: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
023a: 322efffa             move.w     -$6(a6), d1
023e: 9240                 sub.w      d0, d1
0240: 3881                 move.w     d1, (a4)
0242: 39410002             move.w     d1, $2(a4)
0246: 588f                 addq.l     #$4, a7
0248: 6066                 bra.b      $2b0
024a: 4a2c001c             tst.b      $1c(a4)
024e: 6660                 bne.b      $2b0
0250: 4a2c0018             tst.b      $18(a4)
0254: 665a                 bne.b      $2b0
0256: 4a6c0004             tst.w      $4(a4)
025a: 6654                 bne.b      $2b0
025c: 4a2c001a             tst.b      $1a(a4)
0260: 6624                 bne.b      $286
0262: 2f2dcf2c             move.l     -$30d4(a5), -(a7)
0266: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
026a: 3d40fffa             move.w     d0, -$6(a6)
026e: 2eadcf28             move.l     -$30d8(a5), (a7)
0272: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
0276: 322efffa             move.w     -$6(a6), d1
027a: 9240                 sub.w      d0, d1
027c: 3881                 move.w     d1, (a4)
027e: 39410002             move.w     d1, $2(a4)
0282: 588f                 addq.l     #$4, a7
0284: 602a                 bra.b      $2b0
0286: 4ead08ea             jsr        $8ea(a5) ; CODE30+0b46
028a: 2640                 movea.l    d0, a3
028c: 200b                 move.l     a3, d0
028e: 6720                 beq.b      $2b0
0290: 177c007f0019         move.b     #$7f, $19(a3)
0296: 2f0b                 move.l     a3, -(a7)
0298: 2f0c                 move.l     a4, -(a7)
029a: 4ead08ca             jsr        $8ca(a5) ; CODE30+0bbc
029e: 302c0002             move.w     $2(a4), d0
02a2: 4440                 neg.w      d0
02a4: 3680                 move.w     d0, (a3)
02a6: 3014                 move.w     (a4), d0
02a8: 4440                 neg.w      d0
02aa: 37400002             move.w     d0, $2(a3)
02ae: 508f                 addq.l     #$8, a7
02b0: 4cdf1800             movem.l    (a7)+, a3-a4
02b4: 4e5e                 unlk       a6
02b6: 4e75                 rts        
02b8: 4e56feaa             link.w     a6, #$feaa
02bc: 48e70738             movem.l    d5-d7/a2-a4, -(a7)
02c0: 266e0008             movea.l    $8(a6), a3
02c4: 286e000c             movea.l    $c(a6), a4
02c8: 2f0c                 move.l     a4, -(a7)
02ca: 2f0b                 move.l     a3, -(a7)
02cc: 42a7                 clr.l      -(a7)
02ce: 4ead08e2             jsr        $8e2(a5) ; CODE30+07fc
02d2: 4a80                 tst.l      d0
02d4: 4fef000c             lea.l      $c(a7), a7
02d8: 66000146             bne.w      $420
02dc: 486efeac             pea.l      -$154(a6)
02e0: 2f0c                 move.l     a4, -(a7)
02e2: 2f0b                 move.l     a3, -(a7)
02e4: 4ead0a8a             jsr        $a8a(a5) ; CODE40+009c
02e8: 3c00                 move.w     d0, d6
02ea: 4a46                 tst.w      d6
02ec: 4fef000c             lea.l      $c(a7), a7
02f0: 6656                 bne.b      $348
02f2: 4ead08b2             jsr        $8b2(a5) ; CODE30+0004
02f6: 4a40                 tst.w      d0
02f8: 6740                 beq.b      $33a
02fa: 48780022             pea.l      $22.w
02fe: 486efeac             pea.l      -$154(a6)
0302: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0306: 3d7c007ffeca         move.w     #$7f, -$136(a6)
030c: 2e8b                 move.l     a3, (a7)
030e: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
0312: 3d40feaa             move.w     d0, -$156(a6)
0316: 2e8c                 move.l     a4, (a7)
0318: 4ead084a             jsr        $84a(a5) ; CODE28+00ea
031c: 3a2efeaa             move.w     -$156(a6), d5
0320: 9a40                 sub.w      d0, d5
0322: 3045                 movea.w    d5, a0
0324: 2e88                 move.l     a0, (a7)
0326: 3045                 movea.w    d5, a0
0328: 2f08                 move.l     a0, -(a7)
032a: 486efeac             pea.l      -$154(a6)
032e: 4ead08a2             jsr        $8a2(a5) ; CODE30+0c22
0332: 4fef0010             lea.l      $10(a7), a7
0336: 600000e8             bra.w      $420
033a: 2f0c                 move.l     a4, -(a7)
033c: 2f0b                 move.l     a3, -(a7)
033e: 4ead08aa             jsr        $8aa(a5) ; CODE30+07a4
0342: 508f                 addq.l     #$8, a7
0344: 600000da             bra.w      $420
0348: 2f0b                 move.l     a3, -(a7)
034a: 4eba00de             jsr        $42a(pc)
034e: 2b4bcf2c             move.l     a3, -$30d4(a5)
0352: 2b4ccf28             move.l     a4, -$30d8(a5)
0356: 7a00                 moveq      #$0, d5
0358: 45edf9d8             lea.l      -$628(a5), a2
035c: 41edf9b0             lea.l      -$650(a5), a0
0360: 2e08                 move.l     a0, d7
0362: 588f                 addq.l     #$4, a7
0364: 6012                 bra.b      $378
0366: 203cf4143e00         move.l     #$f4143e00, d0
036c: 2480                 move.l     d0, (a2)
036e: 2047                 movea.l    d7, a0
0370: 2080                 move.l     d0, (a0)
0372: 5245                 addq.w     #$1, d5
0374: 588a                 addq.l     #$4, a2
0376: 5887                 addq.l     #$4, d7
0378: 0c45000a             cmpi.w     #$a, d5
037c: 65e8                 bcs.b      $366
037e: 48780022             pea.l      $22.w
0382: 486da5ce             pea.l      -$5a32(a5)
0386: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
038a: 42adb3e2             clr.l      -$4c1e(a5)
038e: 7a00                 moveq      #$0, d5
0390: 45eefeac             lea.l      -$154(a6), a2
0394: 508f                 addq.l     #$8, a7
0396: 6014                 bra.b      $3ac
0398: 2f0a                 move.l     a2, -(a7)
039a: 4ead0912             jsr        $912(a5) ; CODE31+0004
039e: 2e8a                 move.l     a2, (a7)
03a0: 4ebafc62             jsr        $4(pc)
03a4: 588f                 addq.l     #$4, a7
03a6: 5245                 addq.w     #$1, d5
03a8: 45ea0022             lea.l      $22(a2), a2
03ac: bc45                 cmp.w      d5, d6
03ae: 6ee8                 bgt.b      $398
03b0: 0c46000a             cmpi.w     #$a, d6
03b4: 660e                 bne.b      $3c4
03b6: 4ead08ba             jsr        $8ba(a5) ; CODE30+07f2
03ba: 486d0aea             pea.l      $aea(a5)
03be: 4ead0a3a             jsr        $a3a(a5) ; CODE37+0004
03c2: 588f                 addq.l     #$4, a7
03c4: 48780022             pea.l      $22.w
03c8: 486efeac             pea.l      -$154(a6)
03cc: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
03d0: 3d7c007ffeca         move.w     #$7f, -$136(a6)
03d6: 486efeac             pea.l      -$154(a6)
03da: 4ebafc28             jsr        $4(pc)
03de: 4a6da5ea             tst.w      -$5a16(a5)
03e2: 4fef000c             lea.l      $c(a7), a7
03e6: 670c                 beq.b      $3f4
03e8: 2f0c                 move.l     a4, -(a7)
03ea: 486da5ce             pea.l      -$5a32(a5)
03ee: 4ebafdc2             jsr        $1b2(pc)
03f2: 508f                 addq.l     #$8, a7
03f4: 2f0c                 move.l     a4, -(a7)
03f6: 2f0b                 move.l     a3, -(a7)
03f8: 4ead086a             jsr        $86a(a5) ; CODE29+002c
03fc: 2e8c                 move.l     a4, (a7)
03fe: 2f0b                 move.l     a3, -(a7)
0400: 4ead0882             jsr        $882(a5) ; CODE29+015e
0404: b7edcf2c             cmpa.l     -$30d4(a5), a3
0408: 4fef000c             lea.l      $c(a7), a7
040c: 6606                 bne.b      $414
040e: b9edcf28             cmpa.l     -$30d8(a5), a4
0412: 6704                 beq.b      $418
0414: 4ead01a2             jsr        $1a2(a5) ; CODE11+1168
0418: 486d0ae2             pea.l      $ae2(a5)
041c: 4ead08c2             jsr        $8c2(a5) ; CODE30+0d66
0420: 4cee1ce0fe92         movem.l    -$16e(a6), d5-d7/a2-a4
0426: 4e5e                 unlk       a6
0428: 4e75                 rts        
042a: 4e560000             link.w     a6, #$0
042e: 2f2e0008             move.l     $8(a6), -(a7)
0432: 4ead096a             jsr        $96a(a5) ; CODE31+0992
0436: 426dcf04             clr.w      -$30fc(a5)
043a: 4ead0982             jsr        $982(a5) ; CODE32+115c
043e: 48780154             pea.l      $154.w
0442: 486da5f0             pea.l      -$5a10(a5)
0446: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
044a: 48780200             pea.l      $200.w
044e: 486da756             pea.l      -$58aa(a5)
0452: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0456: 48780200             pea.l      $200.w
045a: 486dcf30             pea.l      -$30d0(a5)
045e: 4ead01aa             jsr        $1aa(a5) ; CODE11+0c5c
0462: 4e5e                 unlk       a6
0464: 4e75                 rts        
