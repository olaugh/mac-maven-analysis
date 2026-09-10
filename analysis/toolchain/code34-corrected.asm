0004: 206f0004             movea.l    $4(a7), a0
0008: 43e80001             lea.l      $1(a0), a1
000c: 7000                 moveq      #$0, d0
000e: 1210                 move.b     (a0), d1
0010: 10c0                 move.b     d0, (a0)+
0012: 1001                 move.b     d1, d0
0014: 66f8                 bne.b      $e
0016: 91c9                 suba.l     a1, a0
0018: 2008                 move.l     a0, d0
001a: 1300                 move.b     d0, -(a1)
001c: 2009                 move.l     a1, d0
001e: 4e75                 rts        
0020: 206f0004             movea.l    $4(a7), a0
0024: 7000                 moveq      #$0, d0
0026: 1010                 move.b     (a0), d0
0028: 6004                 bra.b      $2e
002a: 10e80001             move.b     $1(a0), (a0)+
002e: 51c8fffa             dbra       d0, $2a
0032: 4210                 clr.b      (a0)
0034: 202f0004             move.l     $4(a7), d0
0038: 4e75                 rts        
003a: 4a78028e             tst.w      $28e.w
003e: 6b22                 bmi.b      $62
0040: 303c0090             move.w     #$90, d0
0044: a346                 dc.w       $a346
0046: 2248                 movea.l    a0, a1
0048: 303c009f             move.w     #$9f, d0
004c: a746                 dc.w       $a746
004e: b3c8                 cmpa.l     a0, a1
0050: 6710                 beq.b      $62
0052: 225f                 movea.l    (a7)+, a1
0054: 205f                 movea.l    (a7)+, a0
0056: 301f                 move.w     (a7)+, d0
0058: 2f09                 move.l     a1, -(a7)
005a: a090                 dc.w       $a090
005c: 3f400004             move.w     d0, $4(a7)
0060: 4e75                 rts        
0062: 206f0004             movea.l    $4(a7), a0
0066: 303c0001             move.w     #$1, d0
006a: 2248                 movea.l    a0, a1
006c: 6006                 bra.b      $74
006e: 0313                 btst.l     d1, (a3)
0070: 0b02                 btst.l     d5, d2
0072: 0100                 btst.l     d0, d0
0074: 303c0010             move.w     #$10, d0
0078: e240                 asr.w      #$1, d0
007a: 5340                 subq.w     #$1, d0
007c: 4258                 clr.w      (a0)+
007e: 51c8fffc             dbra       d0, $7c
0082: 32bc0002             move.w     #$2, (a1)
0086: 207802ae             movea.l    $2ae.w, a0
008a: 337cfffe0002         move.w     #$fffe, $2(a1)
0090: 0c2800ff0009         cmpi.b     #$ff, $9(a0)
0096: 6742                 beq.b      $da
0098: 4a280008             tst.b      $8(a0)
009c: 6e20                 bgt.b      $be
009e: 337cffff0002         move.w     #$ffff, $2(a1)
00a4: 4a78028e             tst.w      $28e.w
00a8: 6b30                 bmi.b      $da
00aa: 337c00010002         move.w     #$1, $2(a1)
00b0: 4a780b22             tst.w      $b22.w
00b4: 6a24                 bpl.b      $da
00b6: 337c00020002         move.w     #$2, $2(a1)
00bc: 601c                 bra.b      $da
00be: 42690002             clr.w      $2(a1)
00c2: 0c2800020008         cmpi.b     #$2, $8(a0)
00c8: 6e10                 bgt.b      $da
00ca: 6708                 beq.b      $d4
00cc: 337c00040002         move.w     #$4, $2(a1)
00d2: 6006                 bra.b      $da
00d4: 337c00030002         move.w     #$3, $2(a1)
00da: 42690004             clr.w      $4(a1)
00de: 0c380002012f         cmpi.b     #$2, $12f.w
00e4: 6e0a                 bgt.b      $f0
00e6: 1038012f             move.b     $12f.w, d0
00ea: 5240                 addq.w     #$1, d0
00ec: 13400007             move.b     d0, $7(a1)
00f0: 4a78028e             tst.w      $28e.w
00f4: 6b0e                 bmi.b      $104
00f6: 083800040b22         btst.b     #$4, $b22.w
00fc: 6706                 beq.b      $104
00fe: 137c00010008         move.b     #$1, $8(a1)
0104: 0c783fff028e         cmpi.w     #$3fff, $28e.w
010a: 6206                 bhi.b      $112
010c: 137c00010009         move.b     #$1, $9(a1)
0112: 1038021e             move.b     $21e.w, d0
0116: 41faff5b             lea.l      $73(pc), a0
011a: 323c0004             move.w     #$4, d1
011e: b020                 cmp.b      -(a0), d0
0120: 57c9fffc             dbeq       d1, $11e
0124: 5241                 addq.w     #$1, d1
0126: 3341000a             move.w     d1, $a(a1)
012a: 4a380291             tst.b      $291.w
012e: 6b18                 bmi.b      $148
0130: 123801fb             move.b     $1fb.w, d1
0134: 0201000f             andi.b     #$f, d1
0138: 0c010001             cmpi.b     #$1, d1
013c: 660a                 bne.b      $148
013e: 207802dc             movea.l    $2dc.w, a0
0142: 13680007000d         move.b     $7(a0), $d(a1)
0148: 33780210000e         move.w     $210.w, $e(a1)
014e: 4a7803f6             tst.w      $3f6.w
0152: 6d44                 blt.b      $198
0154: 4269000e             clr.w      $e(a1)
0158: 323c003c             move.w     #$3c, d1
015c: 4267                 clr.w      -(a7)
015e: 51c9fffc             dbra       d1, $15c
0162: 204f                 movea.l    a7, a0
0164: 31780a580018         move.w     $a58.w, $18(a0)
016a: 7008                 moveq      #$8, d0
016c: a260                 dc.w       $a260
016e: 6624                 bne.b      $194
0170: 316800340016         move.w     $34(a0), $16(a0)
0176: a207                 dc.w       $a207
0178: 661a                 bne.b      $194
017a: 2168005a0030         move.l     $5a(a0), $30(a0)
0180: 217c4552494b001c     move.l     #$4552494b, $1c(a0)
0188: 7001                 moveq      #$1, d0
018a: a260                 dc.w       $a260
018c: 6606                 bne.b      $194
018e: 33680016000e         move.w     $16(a0), $e(a1)
0194: 4fef007a             lea.l      $7a(a7), a7
0198: 2049                 movea.l    a1, a0
019a: 225f                 movea.l    (a7)+, a1
019c: 5c4f                 addq.w     #$6, a7
019e: 3ebcea84             move.w     #$ea84, (a7)
01a2: 4ed1                 jmp        (a1)
01a4: 225f                 movea.l    (a7)+, a1
01a6: 205f                 movea.l    (a7)+, a0
01a8: a021                 dc.w       $a021
01aa: 2e80                 move.l     d0, (a7)
01ac: 6a02                 bpl.b      $1b0
01ae: 4297                 clr.l      (a7)
01b0: 4ed1                 jmp        (a1)
01b2: 225f                 movea.l    (a7)+, a1
01b4: 205f                 movea.l    (a7)+, a0
01b6: a025                 dc.w       $a025
01b8: 2e80                 move.l     d0, (a7)
01ba: 6a02                 bpl.b      $1be
01bc: 4297                 clr.l      (a7)
01be: 4ed1                 jmp        (a1)
01c0: 225f                 movea.l    (a7)+, a1
01c2: 101f                 move.b     (a7)+, d0
01c4: 205f                 movea.l    (a7)+, a0
01c6: 6604                 bne.b      $1cc
01c8: a007                 dc.w       $a007
01ca: 6002                 bra.b      $1ce
01cc: a407                 dc.w       $a407
01ce: 3e80                 move.w     d0, (a7)
01d0: 4ed1                 jmp        (a1)
01d2: 4e56ffce             link.w     a6, #$ffce
01d6: 204f                 movea.l    a7, a0
01d8: 216e000e0012         move.l     $e(a6), $12(a0)
01de: 316e000c0016         move.w     $c(a6), $16(a0)
01e4: 4228001a             clr.b      $1a(a0)
01e8: 4228001b             clr.b      $1b(a0)
01ec: 42a8001c             clr.l      $1c(a0)
01f0: 701a                 moveq      #$1a, d0
01f2: a060                 dc.w       $a060
01f4: 0c40ffce             cmpi.w     #$ffce, d0
01f8: 6602                 bne.b      $1fc
01fa: a000                 dc.w       $a000
01fc: 226e0008             movea.l    $8(a6), a1
0200: 32a80018             move.w     $18(a0), (a1)
0204: 3d400012             move.w     d0, $12(a6)
0208: 4e5e                 unlk       a6
020a: 205f                 movea.l    (a7)+, a0
020c: 4fef000a             lea.l      $a(a7), a7
0210: 4ed0                 jmp        (a0)
0212: 4e56ffce             link.w     a6, #$ffce
0216: 204f                 movea.l    a7, a0
0218: 316e00080018         move.w     $8(a6), $18(a0)
021e: a001                 dc.w       $a001
0220: 3d40000a             move.w     d0, $a(a6)
0224: 4e5e                 unlk       a6
0226: 205f                 movea.l    (a7)+, a0
0228: 548f                 addq.l     #$2, a7
022a: 4ed0                 jmp        (a0)
022c: 51c1                 sf.b       d1
022e: 6002                 bra.b      $232
0230: 50c1                 st.b       d1
0232: 4e56ffce             link.w     a6, #$ffce
0236: 204f                 movea.l    a7, a0
0238: 216e00080020         move.l     $8(a6), $20(a0)
023e: 316e00100018         move.w     $10(a6), $18(a0)
0244: 226e000c             movea.l    $c(a6), a1
0248: 21510024             move.l     (a1), $24(a0)
024c: 4268002c             clr.w      $2c(a0)
0250: 42a8002e             clr.l      $2e(a0)
0254: 4a01                 tst.b      d1
0256: 6604                 bne.b      $25c
0258: a002                 dc.w       $a002
025a: 6002                 bra.b      $25e
025c: a003                 dc.w       $a003
025e: 3d400012             move.w     d0, $12(a6)
0262: 226e000c             movea.l    $c(a6), a1
0266: 22a80028             move.l     $28(a0), (a1)
026a: 4e5e                 unlk       a6
026c: 225f                 movea.l    (a7)+, a1
026e: 4fef000a             lea.l      $a(a7), a7
0272: 4ed1                 jmp        (a1)
0274: 4e56ffb0             link.w     a6, #$ffb0
0278: 204f                 movea.l    a7, a0
027a: 216e000e0012         move.l     $e(a6), $12(a0)
0280: 316e000c0016         move.w     $c(a6), $16(a0)
0286: 4228001a             clr.b      $1a(a0)
028a: 4268001c             clr.w      $1c(a0)
028e: a00c                 dc.w       $a00c
0290: 3d400012             move.w     d0, $12(a6)
0294: 41e80020             lea.l      $20(a0), a0
0298: 226e0008             movea.l    $8(a6), a1
029c: 7010                 moveq      #$10, d0
029e: a02e                 dc.w       $a02e
02a0: 4e5e                 unlk       a6
02a2: 225f                 movea.l    (a7)+, a1
02a4: 4fef000a             lea.l      $a(a7), a7
02a8: 4ed1                 jmp        (a1)
02aa: 4e56ffc0             link.w     a6, #$ffc0
02ae: 204f                 movea.l    a7, a0
02b0: 216e000c0012         move.l     $c(a6), $12(a0)
02b6: a014                 dc.w       $a014
02b8: 3d400010             move.w     d0, $10(a6)
02bc: 226e0008             movea.l    $8(a6), a1
02c0: 32a80016             move.w     $16(a0), (a1)
02c4: 4e5e                 unlk       a6
02c6: 225f                 movea.l    (a7)+, a1
02c8: 508f                 addq.l     #$8, a7
02ca: 4ed1                 jmp        (a1)
02cc: 4e56ffc0             link.w     a6, #$ffc0
02d0: 204f                 movea.l    a7, a0
02d2: 316e00080016         move.w     $8(a6), $16(a0)
02d8: 216e000a0012         move.l     $a(a6), $12(a0)
02de: a013                 dc.w       $a013
02e0: 3d40000e             move.w     d0, $e(a6)
02e4: 4e5e                 unlk       a6
02e6: 225f                 movea.l    (a7)+, a1
02e8: 5c8f                 addq.l     #$6, a7
02ea: 4ed1                 jmp        (a1)
02ec: 4e56ffb0             link.w     a6, #$ffb0
02f0: 204f                 movea.l    a7, a0
02f2: 216e00120012         move.l     $12(a6), $12(a0)
02f8: 316e00100016         move.w     $10(a6), $16(a0)
02fe: 4228001a             clr.b      $1a(a0)
0302: a008                 dc.w       $a008
0304: 6616                 bne.b      $31c
0306: 4268001c             clr.w      $1c(a0)
030a: a00c                 dc.w       $a00c
030c: 660e                 bne.b      $31c
030e: 43e80020             lea.l      $20(a0), a1
0312: 22ee0008             move.l     $8(a6), (a1)+
0316: 22ae000c             move.l     $c(a6), (a1)
031a: a00d                 dc.w       $a00d
031c: 3d400016             move.w     d0, $16(a6)
0320: 4e5e                 unlk       a6
0322: 225f                 movea.l    (a7)+, a1
0324: 4fef000e             lea.l      $e(a7), a7
0328: 4ed1                 jmp        (a1)
032a: 4e56ffb0             link.w     a6, #$ffb0
032e: 204f                 movea.l    a7, a0
0330: 216e000e0012         move.l     $e(a6), $12(a0)
0336: 316e000c0016         move.w     $c(a6), $16(a0)
033c: 4228001a             clr.b      $1a(a0)
0340: 4268001c             clr.w      $1c(a0)
0344: a00c                 dc.w       $a00c
0346: 43e80020             lea.l      $20(a0), a1
034a: 206e0008             movea.l    $8(a6), a0
034e: 7010                 moveq      #$10, d0
0350: a02e                 dc.w       $a02e
0352: 204f                 movea.l    a7, a0
0354: a00d                 dc.w       $a00d
0356: 3d400012             move.w     d0, $12(a6)
035a: 4e5e                 unlk       a6
035c: 225f                 movea.l    (a7)+, a1
035e: 4fef000a             lea.l      $a(a7), a7
0362: 4ed1                 jmp        (a1)
0364: 4e56ffce             link.w     a6, #$ffce
0368: 204f                 movea.l    a7, a0
036a: 316e000c0018         move.w     $c(a6), $18(a0)
0370: a011                 dc.w       $a011
0372: 3d40000e             move.w     d0, $e(a6)
0376: 226e0008             movea.l    $8(a6), a1
037a: 22a8001c             move.l     $1c(a0), (a1)
037e: 4e5e                 unlk       a6
0380: 225f                 movea.l    (a7)+, a1
0382: 5c8f                 addq.l     #$6, a7
0384: 4ed1                 jmp        (a1)
0386: 4e56ffce             link.w     a6, #$ffce
038a: 204f                 movea.l    a7, a0
038c: 316e000c0018         move.w     $c(a6), $18(a0)
0392: 216e0008001c         move.l     $8(a6), $1c(a0)
0398: a012                 dc.w       $a012
039a: 3d40000e             move.w     d0, $e(a6)
039e: 4e5e                 unlk       a6
03a0: 225f                 movea.l    (a7)+, a1
03a2: 5c8f                 addq.l     #$6, a7
03a4: 4ed1                 jmp        (a1)
03a6: 225f                 movea.l    (a7)+, a1
03a8: 101f                 move.b     (a7)+, d0
03aa: 205f                 movea.l    (a7)+, a0
03ac: 6606                 bne.b      $3b4
03ae: 7007                 moveq      #$7, d0
03b0: a260                 dc.w       $a260
03b2: 6004                 bra.b      $3b8
03b4: 7007                 moveq      #$7, d0
03b6: a660                 dc.w       $a660
03b8: 3e80                 move.w     d0, (a7)
03ba: 4ed1                 jmp        (a1)
03bc: 225f                 movea.l    (a7)+, a1
03be: 101f                 move.b     (a7)+, d0
03c0: 205f                 movea.l    (a7)+, a0
03c2: 6606                 bne.b      $3ca
03c4: 7009                 moveq      #$9, d0
03c6: a260                 dc.w       $a260
03c8: 6004                 bra.b      $3ce
03ca: 7009                 moveq      #$9, d0
03cc: a660                 dc.w       $a660
03ce: 3e80                 move.w     d0, (a7)
03d0: 4ed1                 jmp        (a1)
03d2: 225f                 movea.l    (a7)+, a1
03d4: 101f                 move.b     (a7)+, d0
03d6: 205f                 movea.l    (a7)+, a0
03d8: 6604                 bne.b      $3de
03da: a20c                 dc.w       $a20c
03dc: 6002                 bra.b      $3e0
03de: a60c                 dc.w       $a60c
03e0: 3e80                 move.w     d0, (a7)
03e2: 4ed1                 jmp        (a1)
03e4: 226f0004             movea.l    $4(a7), a1
03e8: 4251                 clr.w      (a1)
03ea: 20780aec             movea.l    $aec.w, a0
03ee: a025                 dc.w       $a025
03f0: 4a80                 tst.l      d0
03f2: 6f0e                 ble.b      $402
03f4: 2050                 movea.l    (a0), a0
03f6: 226f0008             movea.l    $8(a7), a1
03fa: 3298                 move.w     (a0)+, (a1)
03fc: 226f0004             movea.l    $4(a7), a1
0400: 3290                 move.w     (a0), (a1)
0402: 205f                 movea.l    (a7)+, a0
0404: 504f                 addq.w     #$8, a7
0406: 4ed0                 jmp        (a0)
0408: 48e70030             movem.l    a2-a3, -(a7)
040c: 226f000c             movea.l    $c(a7), a1
0410: 42a90002             clr.l      $2(a1)
0414: 20780aec             movea.l    $aec.w, a0
0418: a025                 dc.w       $a025
041a: 4a80                 tst.l      d0
041c: 6f26                 ble.b      $444
041e: 2450                 movea.l    (a0), a2
0420: 544a                 addq.w     #$2, a2
0422: 322f0010             move.w     $10(a7), d1
0426: b25a                 cmp.w      (a2)+, d1
0428: 6e1a                 bgt.b      $444
042a: 5341                 subq.w     #$1, d1
042c: 6d16                 blt.b      $444
042e: 204a                 movea.l    a2, a0
0430: 7002                 moveq      #$2, d0
0432: d0280008             add.b      $8(a0), d0
0436: 0240fffe             andi.w     #$fffe, d0
043a: 5040                 addq.w     #$8, d0
043c: d4c0                 adda.w     d0, a2
043e: a02e                 dc.w       $a02e
0440: 5341                 subq.w     #$1, d1
0442: 60e8                 bra.b      $42c
0444: 4cdf0c00             movem.l    (a7)+, a2-a3
0448: 205f                 movea.l    (a7)+, a0
044a: 5c4f                 addq.w     #$6, a7
044c: 4ed0                 jmp        (a0)
044e: 20780aec             movea.l    $aec.w, a0
0452: a025                 dc.w       $a025
0454: 4a80                 tst.l      d0
0456: 6f28                 ble.b      $480
0458: 2050                 movea.l    (a0), a0
045a: 5448                 addq.w     #$2, a0
045c: 322f0004             move.w     $4(a7), d1
0460: b258                 cmp.w      (a0)+, d1
0462: 6e1c                 bgt.b      $480
0464: 5341                 subq.w     #$1, d1
0466: 6d18                 blt.b      $480
0468: 6712                 beq.b      $47c
046a: 7002                 moveq      #$2, d0
046c: d0280008             add.b      $8(a0), d0
0470: 0240fffe             andi.w     #$fffe, d0
0474: 5040                 addq.w     #$8, d0
0476: d0c0                 adda.w     d0, a0
0478: 5341                 subq.w     #$1, d1
047a: 60ea                 bra.b      $466
047c: 42a80002             clr.l      $2(a0)
0480: 205f                 movea.l    (a7)+, a0
0482: 544f                 addq.w     #$2, a7
0484: 4ed0                 jmp        (a0)
0486: 206f0004             movea.l    $4(a7), a0
048a: 2050                 movea.l    (a0), a0
048c: a9e1                 dc.w       $a9e1
048e: 226f0004             movea.l    $4(a7), a1
0492: 2288                 move.l     a0, (a1)
0494: 3f400008             move.w     d0, $8(a7)
0498: 2e9f                 move.l     (a7)+, (a7)
049a: 4e75                 rts        
049c: 6118                 bsr.b      $4b6
049e: a9db                 dc.w       $a9db
04a0: 2e9f                 move.l     (a7)+, (a7)
04a2: 4e75                 rts        
04a4: 6110                 bsr.b      $4b6
04a6: a9d6                 dc.w       $a9d6
04a8: 60f6                 bra.b      $4a0
04aa: 610a                 bsr.b      $4b6
04ac: a9d5                 dc.w       $a9d5
04ae: 60f0                 bra.b      $4a0
04b0: 6104                 bsr.b      $4b6
04b2: a9d7                 dc.w       $a9d7
04b4: 60ea                 bra.b      $4a0
04b6: 206f0008             movea.l    $8(a7), a0
04ba: 4a6800a4             tst.w      $a4(a0)
04be: 6b08                 bmi.b      $4c8
04c0: 225f                 movea.l    (a7)+, a1
04c2: 2f2800a0             move.l     $a0(a0), -(a7)
04c6: 4ed1                 jmp        (a1)
04c8: 4cdf0301             movem.l    (a7)+, d0/a0-a1
04cc: 4ed0                 jmp        (a0)
04ce: 42a7                 clr.l      -(a7)
04d0: 594f                 subq.w     #$4, a7
04d2: 42a7                 clr.l      -(a7)
04d4: 2f3c54455854         move.l     #$54455854, -(a7)
04da: 486f000c             pea.l      $c(a7)
04de: a9fd                 dc.w       $a9fd
04e0: 201f                 move.l     (a7)+, d0
04e2: 584f                 addq.w     #$4, a7
04e4: 6b28                 bmi.b      $50e
04e6: 0c8000007d01         cmpi.l     #$7d01, d0
04ec: 6506                 bcs.b      $4f4
04ee: 303cfe0b             move.w     #$fe0b, d0
04f2: 601a                 bra.b      $50e
04f4: 42a7                 clr.l      -(a7)
04f6: 594f                 subq.w     #$4, a7
04f8: 2f380ab4             move.l     $ab4.w, -(a7)
04fc: 2f3c54455854         move.l     #$54455854, -(a7)
0502: 486f000c             pea.l      $c(a7)
0506: a9fd                 dc.w       $a9fd
0508: 201f                 move.l     (a7)+, d0
050a: 584f                 addq.w     #$4, a7
050c: 6a06                 bpl.b      $514
050e: 42780ab0             clr.w      $ab0.w
0512: 600a                 bra.b      $51e
0514: 426f0004             clr.w      $4(a7)
0518: 31c00ab0             move.w     d0, $ab0.w
051c: 7000                 moveq      #$0, d0
051e: 3f400004             move.w     d0, $4(a7)
0522: 4e75                 rts        
0524: 20780ab4             movea.l    $ab4.w, a0
0528: a029                 dc.w       $a029
052a: 594f                 subq.w     #$4, a7
052c: 3f380ab0             move.w     $ab0.w, -(a7)
0530: 4267                 clr.w      -(a7)
0532: 2f3c54455854         move.l     #$54455854, -(a7)
0538: 2f10                 move.l     (a0), -(a7)
053a: a9fe                 dc.w       $a9fe
053c: 544f                 addq.w     #$2, a7
053e: 3f5f0004             move.w     (a7)+, $4(a7)
0542: 20780ab4             movea.l    $ab4.w, a0
0546: a02a                 dc.w       $a02a
0548: 4e75                 rts        
054a: 201f                 move.l     (a7)+, d0
054c: 225f                 movea.l    (a7)+, a1
054e: 2b5f0018             move.l     (a7)+, $18(a5)
0552: 2251                 movea.l    (a1), a1
0554: 41fa000a             lea.l      $560(pc), a0
0558: 23480026             move.l     a0, $26(a1)
055c: 2040                 movea.l    d0, a0
055e: 4ed0                 jmp        (a0)
0560: 4227                 clr.b      -(a7)
0562: 2f08                 move.l     a0, -(a7)
0564: 3f00                 move.w     d0, -(a7)
0566: 206d0018             movea.l    $18(a5), a0
056a: 4e90                 jsr        (a0)
056c: 4a1f                 tst.b      (a7)+
056e: 4e75                 rts        
