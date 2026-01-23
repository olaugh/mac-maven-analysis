# CODE 12 Detailed Analysis - Word Validation & DAWG Search

## Overview

| Property | Value |
|----------|-------|
| Size | 2,722 bytes |
| JT Offset | 528 |
| JT Entries | 8 |
| Functions | 20+ |
| Purpose | **Word validation, DAWG search, rack/letter management** |


## System Role

**Category**: Move Logic
**Function**: Move Validation

Validates move legality
## Architecture Role

CODE 12 is central to word validation:
1. Validates words against the DAWG dictionary
2. Manages letter availability tracking
3. Coordinates search operations
4. Handles rack-based word generation

## Key Data Structures

### Letter Tracking Arrays
```c
short letter_available[128];    // A5-8930: Available letters
short letter_used[128];         // A5-9186: Letters used
char current_word[16];          // A5-9728: Current word buffer
char rack_letters[16];          // A5-9792: Player's rack
char cross_letters[16];         // A5-9776: Cross-check letters
char result_word[32];           // A5-9760: Result buffer
```

## Key Functions

### Function 0x0000 - Initialize and Search
```asm
0000: MOVEM.L    D7/A2/A3/A4,-(SP)
0004: JSR        2084(PC)             ; Call init function
0008: JSR        244(PC)              ; Clear letter arrays
000C: JSR        308(PC)              ; Setup rack
0010: JSR        470(PC)              ; Setup cross-checks
0014: JSR        374(PC)              ; More setup
0018: LEA        -9728(A5),A4         ; A4 = current_word buffer
001C: MOVEQ      #0,D7                ; D7 = index
001E: LEA        -9186(A5),A3         ; A3 = letter_used
0022: LEA        -8930(A5),A2         ; A2 = letter_available

; Build available letters from rack and board
0026: BRA.S      $0048
0028: TST.W      (A2)                 ; Check letter_available[D7]
002A: BNE.S      $0030
002C: TST.W      (A3)                 ; Check letter_used[D7]
002E: BEQ.S      $0042                ; Skip if both zero

0030: CMPI.W     #$003F,D7            ; Is it blank ('?')
0034: BEQ.S      $0038
0036: MOVE.B     D7,(A4)+             ; Add to current word
0038: MOVE.W     (A2),D0              ; Get available count
003A: CMP.W      (A3),D0              ; Compare with used
003C: BLE.S      $0040
003E: MOVE.W     (A2),(A3)            ; Update used
0040: CLR.W      (A2)                 ; Clear available
0042: ADDQ.W     #1,D7                ; Next letter
0044: ADDQ.L     #4,A3                ; Next entry (2 bytes each, aligned)
0046: ADDQ.L     #4,A2

0048: CMPI.W     #128,D7              ; Loop through all 128 entries
004C: BCS.S      $0028
004E: CLR.B      (A4)                 ; Null terminate word

0050: ADDQ.W     #1,-8804(A5)         ; Increment counter
0054: JSR        488(PC)              ; Do validation
0058: MOVEM.L    (SP)+,...
005C: RTS
```

### Function 0x0078 - Clear Letter Arrays
```asm
0078: LINK       A6,#-8
007C: MOVEM.L    D6/D7/A4,-(SP)

; Clear letter_available
0080: PEA        $0100.W              ; 256 bytes
0084: PEA        -8930(A5)            ; letter_available
0088: JSR        426(A5)              ; memset

; Clear letter_used
008C: PEA        $0100.W
0090: PEA        -9186(A5)            ; letter_used
0094: JSR        426(A5)

; Clear more buffers
0098: MOVEQ      #16,D0
009A: MOVE.L     D0,(A7)
009C: PEA        -9792(A5)            ; rack_letters
00A0: JSR        426(A5)

00A4: MOVEQ      #16,D0
00A6: MOVE.L     D0,(A7)
00A8: PEA        -9776(A5)            ; cross_letters
00AC: JSR        426(A5)

00B0: MOVEQ      #16,D0
00B2: MOVE.L     D0,(A7)
00B4: PEA        -9728(A5)            ; current_word
00B8: JSR        426(A5)

00BC: MOVEQ      #32,D0
00BE: MOVE.L     D0,(A7)
00C0: PEA        -9760(A5)            ; result_word
00C4: JSR        426(A5)

; Build initial rack from g_flag1
00C8: MOVEQ      #0,D7
00CA: LEA        -8664(A5),A4         ; g_flag1 (rack)
00D2: BRA.S      $00E4
00D4: MOVE.W     D6,-(A7)
00D6: JSR        3562(A5)             ; JT[3562] - tolower
00DA: MOVE.B     D0,-8(A6,D7.W)       ; Store in local buffer
00DE: LEA        12(A7),A7
00E0: ADDQ.W     #1,D7
00E2: ADDQ.L     #8,A4                ; Next rack entry
00E4: MOVE.W     (A4),D6              ; Get tile value
00E6: BNE.S      $00D4                ; While not zero
00E8: CLR.B      -8(A6,D7.W)          ; Null terminate
00EC: PEA        -8(A6)               ; Push local buffer
00F0: JSR        1728(PC)             ; Process rack
00FC: RTS
```

### Function 0x023E - Compare and Validate
```asm
023E: MOVEM.L    D6/D7,-(SP)
0242: MOVEQ      #0,D6                ; D6 = index

; For each letter in alphabet
0244: BRA.S      $0292
0246: MOVEA.L    A5,A0
0248: ADDA.W     D6,A0
024A: ADDA.W     D6,A0                ; A0 = &letter_arrays[D6*2]
024C: MOVEA.L    A5,A1
024E: ADDA.W     D6,A1
0250: ADDA.W     D6,A1

; Get max of available and used
0252: MOVE.W     -9186(A0),D7         ; letter_used
0256: ADD.W      -8930(A1),D7         ; + letter_available
025A: MOVEA.L    A5,A0
...

; Compare with cross-check requirements
0268: MOVE.W     -9442(A0),D7         ; Cross-check value
...

; Store result
028C: MOVE.W     D7,-8930(A0)         ; Update letter_available
0290: ADDQ.W     #1,D6
0292: CMPI.W     #128,D6
0296: BCS.S      $0246

; Continue validation
0298: JSR        970(PC)              ; Call sub-function
029C: JSR        202(PC)              ; More validation

; Bounds check
02A0: CMPI.W     #8,-23674(A5)
02A6: BCC.S      $02AE
02A8: TST.W      -23674(A5)
02AC: BGE.S      $02B2
02AE: JSR        418(A5)              ; bounds_check
...

; Compare with DAWG
0316: MOVE.L     -24030(A5),-(A7)     ; Push compare ptr
031A: MOVE.L     -27732(A5),-(A7)     ; Push DAWG ptr
031E: JSR        3506(A5)             ; JT[3506] - compare
0322: TST.W      D0
0328: BNE.S      $032E
032A: JSR        1092(PC)             ; Not found handler
032E: ...
```

### Function 0x038A - Add Word to Search
```asm
038A: LINK       A6,#0
038E: CMPI.W     #1000,-9700(A5)      ; Check word count limit
0394: BGE.S      $03A6                ; Skip if at limit
0396: JSR        1738(A5)             ; JT[1738] - some init
039A: MOVE.L     8(A6),-(A7)          ; Push word
039E: JSR        1264(PC)             ; Process word
03A2: ADDQ.W     #1,-9700(A5)         ; Increment count
03A6: UNLK       A6
03A8: RTS
```

### Function 0x049E - Validate Word Against Constraints
```asm
049E: LINK       A6,#0
04A2: MOVEM.L    D6/D7/A4,-(SP)
04A6: TST.L      12(A6)               ; Check if has cross-checks
04AA: BEQ.S      $04D4                ; Skip if none

; Validate against cross-checks
04AC: JSR        222(PC)              ; Check something
04B0: TST.W      D0
04B2: BEQ.S      $04D4                ; If failed

04B4: JSR        280(PC)              ; More checks
04B8: TST.W      D0
04BA: BEQ.S      $04D4

; Check word in dictionary
04BC: PEA        -9760(A5)            ; result_word
04C0: JSR        802(A5)              ; JT[802] - check_dictionary
04C4: TST.W      D0
04C8: BNE.S      $04D4                ; Word exists

; Word not in dictionary - add to results
04CA: PEA        -9760(A5)
04CE: JSR        -326(PC)             ; Add to found list
04D2: LEA        12(A7),A7

04D4: TST.L      8(A6)                ; Check main word
04D8: BEQ.W      $0586                ; Skip if none

; Validate main word
04DC: CMPI.W     #1000,-9700(A5)      ; Check limit
04E2: BGE.W      $0586

; Process each letter
04E6: MOVE.L     8(A6),D0
04EA: ADDQ.L     #1,8(A6)
04EE: LSL.L      #2,D0
04F2: ADDA.L     -20010(A5),D0
04F6: MOVEA.L    D0,A0
04F6: MOVE.L     (A0),D6              ; Get next entry
04FA: MOVE.B     D6,D7                ; D7 = letter
04FC: EXT.W      D7

; Check letter availability
04FC: LEA        -8930(A5),A4         ; letter_available
0500: ADDA.W     D7,A4
0502: ADDA.W     D7,A4
0504: TST.W      (A4)                 ; Letter available?
0506: BLE.S      $053A                ; No

; Use the letter
0508: SUBQ.W     #1,(A4)              ; Decrement available
050C: ADDQ.L     #1,-9708(A5)         ; Increment result ptr
0510: MOVE.B     D7,(A0)              ; Store letter

; Check flags
0512: MOVE.L     D6,D0
0514: ANDI.L     #$00000100,D0        ; End-of-word flag?
051A: MOVE.L     D0,-(A7)
051C: MOVE.L     D6,D0
051E: MOVEQ      #10,D1
0520: LSR.L      D1,D0                ; Get child index
0522: MOVE.L     D0,-(A7)
0524: JSR        -140(PC)             ; Recurse
...

; Restore letter
052A: MOVEA.L    -9708(A5),A0
052E: SUBQ.L     #1,-9708(A5)
0534: CLR.B      (A0)                 ; Clear from result
0536: ADDQ.W     #1,(A4)              ; Restore available count
...
```

## Global Variables

| Offset | Name | Purpose |
|--------|------|---------|
| A5-8664 | g_flag1 | Rack entries (7 tiles) |
| A5-8804 | word_counter | Words found counter |
| A5-8930 | letter_available | 128-entry availability |
| A5-9186 | letter_used | 128-entry usage tracking |
| A5-9442 | cross_check | Cross-check requirements |
| A5-9700 | found_count | Found words count |
| A5-9708 | result_ptr | Current result position |
| A5-9728 | current_word | Current word buffer |
| A5-9760 | result_word | Result buffer (32 bytes) |
| A5-9776 | cross_letters | Cross-check letters |
| A5-9792 | rack_letters | Rack letters |
| A5-20010 | search_data | Search state pointer |
| A5-23674 | counter | Bounds checking |
| A5-24030 | compare_ptr | DAWG compare pointer |
| A5-27732 | dawg_ptr | DAWG data pointer |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | bounds_check |
| 426 | memset |
| 802 | check_dictionary |
| 1738 | init_something |
| 3506 | compare |
| 3562 | tolower |

## Algorithm Summary

1. **Initialize**: Clear all letter tracking arrays
2. **Build rack**: Convert rack tiles to letter counts
3. **Cross-check**: Validate against cross-word requirements
4. **DAWG search**: Recursive search through dictionary
5. **Collect results**: Store valid words found

## Confidence: HIGH

Clear word validation patterns:
- Letter availability tracking
- Recursive DAWG search
- Cross-check validation
- Result collection
