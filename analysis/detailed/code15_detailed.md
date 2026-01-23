# CODE 15 Detailed Analysis - DAWG Traversal Support

## Overview

| Property | Value |
|----------|-------|
| Size | 3,568 bytes |
| JT Offset | 736 |
| JT Entries | 5 |
| Functions | 18 |
| Purpose | **DAWG node traversal, pattern matching, word generation** |

## Architecture Role

CODE 15 provides DAWG traversal utilities:
1. Walk DAWG child pointers
2. Pattern-based word generation
3. Recursive DAWG search support
4. Window/dialog creation

## Key Functions

### Function 0x0000 - Search DAWG with Pattern
```asm
0000: LINK       A6,#-4
0004: MOVEM.L    D7/A3/A4,-(SP)
0008: MOVEA.L    12(A6),A3            ; A3 = pattern ptr
000C: PEA        -4(A6)               ; Local for result
0010: CLR.W      -(A7)                ; Flags
0012: MOVE.L     8(A6),-(A7)          ; DAWG ptr
0016: JSR        3386(A5)             ; JT[3386] - search
001A: MOVEA.L    D0,A4                ; A4 = result
001C: MOVE.L     A4,D0
001E: LEA        10(A7),A7
0022: BNE.S      $004A                ; Found something

; Not found - set up default
0024: MOVE.L     -24792(A5),-24030(A5) ; Copy default ptr
002A: SUBQ.B     #1,-23674(A5)        ; Decrement counter
0030: MULU.W     #44,-23674(A5)       ; * 44 bytes
0034: LEA        -24026(A5),A0        ; g_common
0038: ADD.L      A0,D0
003A: MOVEA.L    D0,A0
003C: MOVEQ      #1,D0
003E: TST.W      D0
0040: BNE.S      $0044
0042: MOVEQ      #1,D0
0044: DC.W       $4CD8                ; MOVEM.L (SP)+,...
...
004A: MOVE.L     -4(A6),D0            ; Get result
004E: LSR.L      #2,D0                ; / 4
0050: MOVE.L     D0,-4(A6)            ; Store adjusted

; Validate result
0054: SUB.L      D0,D0
0058: TST.L      D0
005A: BHI.S      $0082                ; Valid
005C: MOVE.L     -24792(A5),-24030(A5)
0062: ...                             ; Same default setup
...
; Check bit 9 for end-of-word
0082: MOVE.L     (A3),D7              ; Get pattern entry
0084: MOVE.L     D7,D0
0086: LSR.L      #2,D0                ; Get flags
008A: BTST       #3,D0                ; Check bit
008E: BEQ.S      $00C4                ; Not end of word

; Check word validity
0090: MOVEQ      #-26,D0
0092: ADD.L      -4(A6),D0
0096: CMP.L      D7,D0
0098: BLS.S      $00C0                ; Out of range

; Set result and decrement
009A: MOVE.L     -24792(A5),-24030(A5)
00A0: SUBQ.B     #1,-23674(A5)
...
00C0: SUBQ.L     #1,(A3)              ; Decrement pattern counter
00C4: MOVE.L     A4,D0                ; Return result
00CA: UNLK       A6
00CC: RTS
```

### Function 0x00CE - Walk to Next Child
```asm
00CE: LINK       A6,#0
00D2: MOVEM.L    D5/D6/D7,-(SP)
00D6: MOVEA.L    8(A6),A0             ; A0 = current ptr
00DA: MOVE.B     (A0),D7              ; D7 = current letter
00DC: MOVE.L     -11964(A5),D6        ; D6 = DAWG base

; Walk sibling chain
00E0: BRA.S      $0116                ; Start loop
00E2: MOVE.L     D6,D0
00E4: LSL.L      #2,D0                ; * 4 (entry size)
00E8: ADD.L      -11960(A5),D0        ; + base
00EC: MOVEA.L    D0,A0                ; A0 = entry ptr
00EE: MOVE.L     (A0),D5              ; D5 = entry

; Check if letter matches
00F0: CMP.B      D5,D7                ; Compare letters
00F2: BNE.S      $0106                ; No match

; Found - return child index
00F4: MOVE.L     D5,D6                ; Update position
00F6: MOVEQ      #10,D0
00F8: LSR.L      D0,D6                ; >> 10 = child index
00FA: BEQ.S      $011A                ; No child
00FE: ADDQ.L     #1,8(A6)             ; Increment pattern ptr
0102: MOVEA.L    8(A6),A0
0106: MOVE.B     (A0),D7              ; Get next letter
0108: BRA.S      $0116                ; Continue

; Check end-of-sibling flag
0106: BTST       #9,D5                ; Bit 9 = last sibling?
010A: BNE.S      $0110                ; Yes, done
010C: CMP.B      D5,D7
010E: BGE.S      $0114
0110: MOVEQ      #0,D0                ; Not found
0112: BRA.S      $011C

0114: ADDQ.L     #1,D6                ; Next sibling
0116: TST.B      D7                   ; More letters?
0118: BNE.S      $00E2                ; Continue
011A: MOVE.L     D6,D0                ; Return position
011C: MOVEM.L    (SP)+,D5/D6/D7
0120: UNLK       A6
0122: RTS
```

**C equivalent**:
```c
long walk_to_child(char* pattern) {
    char letter = *pattern;
    long pos = g_dawg_position;  // A5-11964
    long* base = g_dawg_base;    // A5-11960

    while (letter != 0) {
        long entry = base[pos];
        char entry_letter = entry & 0xFF;

        if (entry_letter == letter) {
            pos = (entry >> 10);  // Child index
            if (pos == 0) break;  // No child
            pattern++;
            letter = *pattern;
        } else if (entry & 0x200) {  // Last sibling?
            return 0;  // Not found
        } else {
            pos++;  // Next sibling
        }
    }
    return pos;
}
```

### Function 0x0124 - Generate Words from Pattern
```asm
0124: LINK       A6,#0
0128: MOVEM.L    D5/D6/D7/A3/A4,-(SP)
012C: MOVEA.L    8(A6),A3             ; A3 = output buffer
0130: MOVEQ      #0,D7                ; D7 = count
0132: LEA        -11960(A5),A4        ; A4 = DAWG array ptr
0136: MOVE.L     (A4),-11968(A5)      ; Store base
013A: MOVE.W     D7,-10936(A5)        ; Clear counter

; Setup position
013E: MOVEA.L    A5,A0
0140: MOVE.L     D7,D0
0142: EXT.L      D0
0144: LSL.L      #2,D0                ; * 4
0148: MOVE.L     -11956(A0,D0.L),-11964(A5)
014E: BEQ.S      $018A                ; No more entries

; Process pattern
0150: MOVE.L     12(A6),-(A7)         ; Push pattern
0154: JSR        -136(PC)             ; Walk to child
0158: MOVE.L     D0,D6                ; D6 = child pos
015A: TST.L      D6
015C: BEQ.S      $0184                ; Not found

; Copy result letter
0160: MOVE.L     D6,D0
0162: ADDQ.L     #1,D6
0164: LSL.L      #2,D0                ; * 4
0168: ADD.L      -11960(A5),D0
016C: MOVEA.L    D0,A0
016E: MOVE.L     (A0),D5              ; Get entry
0170: MOVE.B     D5,(A3)              ; Store letter

; Check flags
0172: TST.W      16(A6)               ; Check param
0174: BEQ.S      $017C                ; Skip
0176: BTST       #8,D5                ; Check flag
017A: BEQ.S      $017E

017C: ADDQ.L     #1,A3                ; Next output pos
017E: BTST       #9,D5                ; End of word?
0182: BEQ.S      $0160                ; Continue

0184: ADDQ.W     #1,D7                ; Increment count
0186: ADDQ.L     #4,A4                ; Next section
0188: BRA.S      $0136                ; Loop

018A: CLR.B      (A3)                 ; Null terminate
018C: MOVEM.L    (SP)+,...
0190: UNLK       A6
0192: RTS
```

### Function 0x0272 - Recursive Pattern Match
```asm
0272: LINK       A6,#-4
0276: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
027A: MOVE.W     14(A6),D4            ; D4 = flags
027E: MOVEA.L    28(A6),A4            ; A4 = callback

; Check if should continue
0282: TST.W      12(A6)
0286: BNE.S      $02A6                ; Has data
0288: TST.L      20(A6)               ; Check callback ptr
028C: BEQ.S      $02A0                ; No callback

; Call callback function
028E: MOVE.L     36(A6),-(A7)         ; Context
0292: MOVE.L     A4,-(A7)             ; Result buffer
0294: MOVEA.L    24(A6),A0            ; Callback
0298: JSR        (A0)                 ; Call it
029A: LEA        8(A7),A7
029C: BRA.W      $0350                ; Done

02A0: MOVEQ      #0,D0                ; Return 0
02A2: BRA.W      $0350

; Process DAWG entry
02A6: TST.L      16(A6)               ; Check DAWG ptr
02AA: BNE.S      $02B2
02AC: MOVEQ      #0,D0                ; No DAWG
02AE: BRA.W      $0350

; Setup for traversal
02B2: MOVE.L     D4,D0
02B4: EXT.L      D0
02B6: LSL.L      #2,D0                ; * 4
02BA: ADD.L      32(A6),D0            ; + offset
02BE: MOVEA.L    D0,A2                ; A2 = section ptr
02C0: MOVEA.W    D4,A2
02C4: ADD.L      A4,A2
02C6: MOVEQ      #1,D7
02C8: ADD.W      D4,D7                ; D7 = count
02CA: MOVEQ      #-1,D4
02CC: ADD.W      12(A6),D4            ; Adjust

; Get DAWG entry
02D0: MOVE.L     16(A6),D0
02D4: ADDQ.L     #1,16(A6)            ; Increment ptr
02D8: LSL.L      #2,D0                ; * 4
02DC: ADD.L      -11960(A5),D0        ; + base
02E0: MOVEA.L    D0,A0
02E2: MOVE.L     (A0),D3              ; D3 = entry

; Extract letter
02DE: MOVE.B     D3,D6                ; D6 = letter
02E0: EXT.W      D6

; Get pattern letter
02E2: MOVEA.L    8(A6),A0
02E6: MOVE.B     (A0),D5              ; D5 = pattern char
02E8: MOVE.B     D5,D0
02EA: EXT.W      D0
02EC: CMP.W      D0,D6                ; Compare
02EE: BEQ.S      $0306                ; Match

; Check if past target
02F0: TST.B      D5                   ; End of pattern?
02F2: BNE.S      $0346                ; No, continue
02F4: TST.L      32(A6)               ; Check context
02F8: BEQ.S      $0306                ; None

; Handle blank/wildcard
02FA: MOVEQ      #-97,D0              ; 'a' - 1
02FC: ADD.B      D6,D0                ; Normalize
02FE: MOVEQ      #1,D1
0300: LSL.L      D0,D1                ; Bit mask
0304: AND.L      D1,(A3)              ; Apply
0306: MOVE.B     D6,(A2)              ; Store letter

; Recursive call
0308: MOVE.L     36(A6),-(A7)         ; Context
030C: MOVE.L     32(A6),-(A7)         ; User data
0310: MOVE.L     A4,-(A7)             ; Buffer
0312: MOVE.L     24(A6),-(A7)         ; Callback
0316: MOVE.L     D3,D0
0318: ANDI.L     #$100,D0             ; Check end-of-word
031E: MOVE.L     D0,-(A7)
0320: MOVE.L     D3,D0
0322: MOVEQ      #10,D1
0324: LSR.L      D1,D0                ; Child index
0326: MOVE.L     D0,-(A7)
0328: MOVE.W     D7,-(A7)             ; Level
032A: MOVE.W     D4,-(A7)             ; Flags
032C: MOVEA.L    8(A6),A0
0330: PEA        1(A0)                ; pattern+1
0334: JSR        -196(PC)             ; Recurse

; Check return value
0338: MOVE.W     D0,D6
033A: TST.W      D6
033C: BEQ.S      $0346                ; Continue
0340: LEA        32(A7),A7
0342: MOVE.W     D6,D0
0344: BRA.S      $034E                ; Return result

; Check last sibling flag
0346: BTST       #9,D3                ; Bit 9 = last?
034A: BEQ.S      $02CC                ; No, continue
034C: MOVEQ      #0,D0                ; Return 0

034E: MOVEM.L    (SP)+,...
0352: UNLK       A6
0354: RTS
```

### Function 0x03D6 - Create Modeless Window
```asm
03D6: LINK       A6,#0
03DA: MOVE.L     A4,-(A7)
03DC: CLR.L      -(A7)                ; Behind
03DE: MOVE.W     8(A6),-(A7)          ; ResID
03E2: MOVE.L     10(A6),-(A7)         ; Rect
03E6: MOVE.L     14(A6),-(A7)         ; Title
03EA: A9BD                            ; GetNewWindow trap
03EE: MOVEA.L    (A7)+,A4             ; A4 = window
03F0: MOVE.L     A4,-(A7)
03F2: MOVE.B     #1,-(A7)             ; Visible
03F4: A91C                            ; ShowWindow trap
03F6: MOVE.L     -7284(A5),126(A4)    ; Store refCon
03FC: MOVE.L     A4,D0                ; Return window
0400: UNLK       A6
0402: RTS
```

### Function 0x04CE - Initialize DAWG Tables
```asm
04CE: LINK       A6,#-8
04D2: JSR        2024(PC)             ; Get system info
04D6: MOVE.L     $0908.W,D0           ; RAM size
04DA: ADDI.L     #$FFFF4000,D0        ; Offset
04E0: MOVEA.L    D0,A0
04E2: A02D                            ; GetZone trap

; Format string based on screen size
04E6: PEA        -7340(A5)
04EA: PEA        -7000(A5)
04EC: JSR        2066(A5)             ; sprintf

; Check screen dimensions
04F0: CMPI.W     #640,-1444(A5)       ; Screen width
04F6: BLT.S      $050C
04FA: CMPI.W     #480,-1446(A5)       ; Screen height
0500: BLT.S      $050C

; Large screen - use bigger strings
0502: LEA        -7272(A5),A0
0506: MOVE.L     A0,-8576(A5)
050A: BRA.S      $0514

; Small screen
050C: LEA        -7166(A5),A0
0510: MOVE.L     A0,-8576(A5)

0514: JSR        -102(PC)             ; More setup
...
```

## DAWG Entry Format (4 bytes)

```
Bits 0-7:   Letter (ASCII)
Bit 8:      End-of-word flag
Bit 9:      Last-sibling flag
Bits 10-31: Child node index (22 bits)
```

## Pattern Matching Algorithm

1. Start at root node
2. For each pattern character:
   - Walk sibling chain looking for match
   - If found, follow child pointer
   - If not found, return failure
3. Check end-of-word flag for complete words
4. Use callback for results

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-7166 | Small screen strings |
| A5-7272 | Large screen strings |
| A5-7284 | Window refCon |
| A5-8576 | String table ptr |
| A5-10936 | Word counter |
| A5-11960 | DAWG base pointer |
| A5-11964 | Current DAWG position |
| A5-11968 | DAWG start position |
| A5-23674 | Counter |
| A5-24030 | Compare pointer |
| A5-24792 | Default pointer |

## Confidence: HIGH

Clear DAWG traversal patterns:
- Child/sibling navigation
- Bit flag extraction
- Recursive pattern matching
- End-of-word detection
