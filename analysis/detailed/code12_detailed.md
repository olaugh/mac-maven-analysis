# CODE 12 Detailed Analysis - Word Validation & DAWG Search

## Overview

| Property | Value |
|----------|-------|
| Size | 2,722 bytes |
| JT Offset | 528 |
| JT Entries | 8 |
| Functions | 20+ |
| Purpose | **Word validation, DAWG traversal, letter availability tracking** |

## System Role

**Category**: Move Logic
**Function**: Move Validation

Central word validation module. Validates words against the DAWG dictionary, tracks letter availability from rack and board, and performs recursive search to generate valid word candidates.

**Related CODE resources**:
- CODE 3 (search coordinator)
- CODE 15 (DAWG traversal utilities)
- CODE 14 (move selection)

## Architecture Role

CODE 12 is central to word validation:
1. Validates words against the DAWG dictionary
2. Manages letter availability tracking (128-entry arrays)
3. Handles rack-based word generation
4. Performs cross-check validation for perpendicular words
5. Coordinates with DAWG structure for word lookup

## Key Data Structures

### Letter Tracking Arrays
```c
// Each array has 128 entries (2 bytes each = 256 bytes)
// Indexed by ASCII character code

short letter_available[128];    // A5-8930: Available letters for current search
short letter_used[128];         // A5-9186: Letters already used in search
short cross_check[128];         // A5-9442: Cross-check requirements
short rack_count[128];          // A5-9698: Letters available from rack
```

### Word Buffers
```c
char current_word[16];          // A5-9728: Current word being built
char result_word[32];           // A5-9760: Result buffer for valid words
char cross_letters[16];         // A5-9776: Cross-check letter constraints
char rack_letters[16];          // A5-9792: Player's rack letters
char rack_string[16];           // A5-9808: Rack as string
```

### Search State
```c
long result_ptr;                // A5-9708: Pointer to current result position
long search_ptr;                // A5-9712: Current search position in word
short found_count;              // A5-9700: Number of valid words found (max 1000)
short word_counter;             // A5-8804: Words processed counter
short blank_counter;            // A5-8670: Blank tile usage counter
short temp_counter_1;           // A5-8674: Temporary counter
short temp_counter_2;           // A5-8672: Temporary counter
```

## Key Functions

### Function 0x0000 - Initialize and Search
```asm
0000: MOVEM.L    D7/A2/A3/A4,-(SP)
0004: JSR        2084(PC)             ; Call init function
0008: JSR        244(PC)              ; Clear letter arrays (0x00FC)
000C: JSR        308(PC)              ; Setup rack letters (0x0134)
0010: JSR        470(PC)              ; Setup cross-checks (0x01D6)
0014: JSR        374(PC)              ; More setup (0x0176)
0018: LEA        -9728(A5),A4         ; A4 = current_word buffer
001C: MOVEQ      #0,D7                ; D7 = index
001E: LEA        -9186(A5),A3         ; A3 = letter_used
0022: LEA        -8930(A5),A2         ; A2 = letter_available

; Build available letters combining rack and board
0026: BRA.S      $0048                ; Jump into loop
0028: TST.W      (A2)                 ; Check letter_available[D7]
002A: BNE.S      $0030
002C: TST.W      (A3)                 ; Check letter_used[D7]
002E: BEQ.S      $0042                ; Skip if both zero

0030: CMPI.W     #$003F,D7            ; Is it '?' (blank)?
0034: BEQ.S      $0038                ; Skip storing blank
0036: MOVE.B     D7,(A4)+             ; Add letter to current word
0038: MOVE.W     (A2),D0              ; Get available count
003A: CMP.W      (A3),D0              ; Compare with used
003C: BLE.S      $0040
003E: MOVE.W     (A2),(A3)            ; Update used to max
0040: CLR.W      (A2)                 ; Clear available
0042: ADDQ.W     #1,D7                ; Next letter
0044: ADDQ.L     #4,A3                ; Next entry in letter_used
0046: ADDQ.L     #4,A2                ; Next entry in letter_available

0048: CMPI.W     #128,D7              ; Loop through all 128 entries
004C: BCS.S      $0028
004E: CLR.B      (A4)                 ; Null terminate word
0050: ADDQ.W     #1,-8804(A5)         ; Increment word counter
0054: JSR        488(PC)              ; Do validation
0058: MOVEM.L    (SP)+,D7/A2/A3/A4
005C: RTS
```

### Function 0x0078 - Clear Letter Arrays and Setup Rack
```asm
0078: LINK       A6,#-8               ; 8 bytes local
007C: MOVEM.L    D6/D7/A4,-(SP)

; Clear letter_available (256 bytes)
0080: PEA        $0100.W              ; 256 bytes
0084: PEA        -8930(A5)            ; letter_available
0088: JSR        426(A5)              ; JT[426] - memset

; Clear letter_used (256 bytes)
008C: PEA        $0100.W
0090: PEA        -9186(A5)            ; letter_used
0094: JSR        426(A5)              ; JT[426] - memset

; Clear rack_letters (16 bytes)
0098: MOVEQ      #16,D0
009A: MOVE.L     D0,(A7)
009C: PEA        -9792(A5)            ; rack_letters
00A0: JSR        426(A5)

; Clear cross_letters (16 bytes)
00A4: MOVEQ      #16,D0
00A6: MOVE.L     D0,(A7)
00A8: PEA        -9776(A5)            ; cross_letters
00AC: JSR        426(A5)

; Clear current_word (16 bytes)
00B0: MOVEQ      #16,D0
00B2: MOVE.L     D0,(A7)
00B4: PEA        -9728(A5)            ; current_word
00B8: JSR        426(A5)

; Clear result_word (32 bytes)
00BC: MOVEQ      #32,D0
00BE: MOVE.L     D0,(A7)
00C0: PEA        -9760(A5)            ; result_word
00C4: JSR        426(A5)

; Build rack string from g_flag1 (rack structure)
00C8: MOVEQ      #0,D7                ; D7 = index
00CA: LEA        -8664(A5),A4         ; A4 = g_flag1 (rack)
00CE: LEA        32(A7),A7            ; Clean stack
00D2: BRA.S      $00E4

; Loop through rack tiles
00D4: MOVE.W     D6,-(A7)             ; Push tile value
00D6: JSR        3562(A5)             ; JT[3562] - tolower
00DA: MOVE.B     D0,-8(A6,D7.W)       ; Store lowercase in local
00DE: ADDQ.L     #2,A7                ; Clean stack
00E0: ADDQ.W     #1,D7                ; D7++
00E2: ADDQ.L     #8,A4                ; Next rack entry (8 bytes)
00E4: MOVE.W     (A4),D6              ; D6 = tile value
00E6: BNE.S      $00D4                ; While not zero
00E8: CLR.B      -8(A6,D7.W)          ; Null terminate
00EC: PEA        -8(A6)               ; Push local buffer
00F0: JSR        1728(PC)             ; Process rack string
00F4: MOVEM.L    -20(A6),D6/D7/A4
00FA: UNLK       A6
00FC: RTS
```

### Function 0x023E - Merge Letter Arrays
```asm
023E: MOVEM.L    D6/D7,-(SP)
0242: MOVEQ      #0,D6                ; D6 = index

; For each of 128 letter slots
0244: BRA.S      $0292
0246: MOVEA.L    A5,A0
0248: ADDA.W     D6,A0
024A: ADDA.W     D6,A0                ; A0 = base + D6*2
024C: MOVEA.L    A5,A1
024E: ADDA.W     D6,A1
0250: ADDA.W     D6,A1                ; A1 = base + D6*2

; Merge used and available counts
0252: MOVE.W     -9186(A0),D7         ; D7 = letter_used[D6]
0256: ADD.W      -8930(A1),D7         ; + letter_available[D6]
; ... more merging ...

; Apply cross-check constraints
0268: MOVE.W     -9442(A0),D7         ; Get cross_check value
; ... constrain available letters ...

; Store result
028C: MOVE.W     D7,-8930(A0)         ; Update letter_available
0290: ADDQ.W     #1,D6
0292: CMPI.W     #128,D6
0296: BCS.S      $0246                ; Loop 128 times

; Continue validation
0298: JSR        970(PC)              ; Sub-function
029C: JSR        202(PC)              ; More validation

; Bounds check for internal counter
02A0: CMPI.W     #8,-23674(A5)        ; Check bounds
02A6: BCC.S      $02AE
02A8: TST.W      -23674(A5)
02AC: BGE.S      $02B2
02AE: JSR        418(A5)              ; JT[418] - bounds_check error

; Compare with DAWG
0316: MOVE.L     -24030(A5),-(A7)     ; Push compare ptr
031A: MOVE.L     -27732(A5),-(A7)     ; Push DAWG ptr
031E: JSR        3506(A5)             ; JT[3506] - strcmp
0322: TST.W      D0
0328: BNE.S      $032E
032A: JSR        1092(PC)             ; Word not found handler
...
```

### Function 0x038A - Add Word to Search Results
```asm
038A: LINK       A6,#0
038E: CMPI.W     #1000,-9700(A5)      ; Check word count limit
0394: BGE.S      $03A6                ; Skip if at 1000 words
0396: JSR        1738(A5)             ; JT[1738] - init for add
039A: MOVE.L     8(A6),-(A7)          ; Push word
039E: JSR        1264(PC)             ; Process and add word
03A2: ADDQ.W     #1,-9700(A5)         ; Increment found_count
03A6: UNLK       A6
03A8: RTS
```

**C equivalent**:
```c
void add_word_to_results(char* word) {
    if (found_count >= 1000) return;  // Max 1000 words

    init_add();           // JT[1738]
    process_word(word);   // Internal function
    found_count++;
}
```

### Function 0x03AA - Recursive DAWG Search
```asm
03AA: LINK       A6,#0
03AE: MOVEM.L    D4/D5/D6/D7/A4,-(SP)
03B2: MOVE.L     8(A6),D6             ; D6 = DAWG node index
03B6: CMPI.W     #1000,-9700(A5)      ; Check limit
03BC: BGE.W      $0498                ; Exit if at limit

; Advance search pointer
03C0: ADDQ.L     #1,-9712(A5)         ; search_ptr++
03C4: MOVEA.L    -9712(A5),A0
03C8: TST.B      (A0)                 ; End of pattern?
03CA: BNE.S      $03DC                ; No, continue

; End of pattern - check if callback needed
03CC: MOVE.L     12(A6),-(A7)         ; Push callback context
03D0: MOVE.L     D6,-(A7)             ; Push node
03D2: JSR        202(PC)              ; Check/add word
; ...

; Not end of pattern - traverse DAWG
03DC: TST.L      D6                   ; Check node valid
03DE: BEQ.W      $0494                ; Exit if null
03E2: MOVE.L     D6,D0
03E4: ADDQ.L     #1,D6                ; Next node
03E6: LSL.L      #2,D0                ; * 4 (entry size)
03EA: ADD.L      -11960(A5),D0        ; + DAWG base
03EE: MOVEA.L    D0,A0
03F0: MOVE.L     (A0),D5              ; D5 = DAWG entry

; Extract letter from entry
03F2: MOVE.B     D5,D7                ; D7 = letter (bits 0-7)
03F4: EXT.W      D7

; Check letter availability
040A: LEA        -8930(A5),A4         ; letter_available
040E: ADDA.W     D7,A4
0410: ADDA.W     D7,A4                ; Index by letter
0412: TST.W      (A4)                 ; Available?
0414: BLE.S      $0448                ; No, try blank

; Use the letter
0416: SUBQ.W     #1,(A4)              ; Decrement available
041A: ...
; Store letter in result
0420: MOVE.B     D7,(A0)

; Check DAWG flags
0422: MOVE.L     D5,D0
0424: ANDI.L     #$00000100,D0        ; Bit 8 = end-of-word
042A: MOVE.L     D0,-(A7)
042C: MOVE.L     D5,D0
042E: MOVEQ      #10,D1
0430: LSR.L      D1,D0                ; >> 10 = child index
0432: MOVE.L     D0,-(A7)
0434: JSR        -140(PC)             ; Recurse with child

; Restore letter
0438: MOVEA.L    -9708(A5),A0
043C: SUBQ.L     #1,-9708(A5)
0442: CLR.B      (A0)                 ; Clear from result
0444: ADDQ.W     #1,(A4)              ; Restore available count

; Try blank if available
0448: TST.W      -8804(A5)            ; blank_counter > 0?
044C: BLE.S      $048A                ; No blanks
; ... blank handling similar to above ...

; Check end-of-sibling flag
048A: BTST       #9,D5                ; Bit 9 = last sibling?
048E: BEQ.W      $03E4                ; No, continue siblings
0492: SUBQ.L     #1,-9712(A5)         ; search_ptr--
0498: MOVEM.L    (SP)+,...
049C: UNLK       A6
049E: RTS
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
04C8: BNE.S      $04D4                ; Word exists, skip

; Word not in dictionary - add to results
04CA: PEA        -9760(A5)
04CE: JSR        -326(PC)             ; add_word_to_results
04D2: ADDQ.L     #4,A7

; Process main word parameter
04D4: TST.L      8(A6)                ; Check main word
04D8: BEQ.W      $0586                ; Skip if none
04DC: CMPI.W     #1000,-9700(A5)      ; Check limit
04E2: BGE.W      $0586

; Continue DAWG traversal with main word
; ... similar pattern to 0x03AA ...
```

## DAWG Entry Format

Each DAWG entry is 4 bytes:
```
Bits 0-7:   Letter (ASCII character)
Bit 8:      End-of-word flag (1 = valid word ends here)
Bit 9:      Last-sibling flag (1 = last child of parent)
Bits 10-31: Child node index (22 bits, offset into DAWG array)
```

## Search Algorithm Summary

1. **Initialize**: Clear all letter tracking arrays
2. **Build rack**: Convert rack tiles to letter counts in letter_available
3. **Build constraints**: Merge rack letters with cross-check requirements
4. **DAWG search**: Recursive depth-first traversal
   - At each node, try each available letter
   - Decrement count when using letter
   - Follow child pointer if letter matches
   - Restore count on backtrack
   - Handle blanks as wildcards
5. **Collect results**: Store valid words (max 1000)

## Global Variables

| Offset | Type | Name | Purpose |
|--------|------|------|---------|
| A5-8664 | struct[7] | g_flag1 | Rack entries (7 tiles, 8 bytes each) |
| A5-8670 | short | blank_counter_2 | Secondary blank counter |
| A5-8672 | short | temp_counter_2 | Temporary counter |
| A5-8674 | short | temp_counter_1 | Temporary counter |
| A5-8804 | short | word_counter | Words processed |
| A5-8930 | short[128] | letter_available | Available letters (256 bytes) |
| A5-9186 | short[128] | letter_used | Letters used (256 bytes) |
| A5-9316 | short | cross_counter | Cross-check counter |
| A5-9442 | short[128] | cross_check | Cross-check requirements |
| A5-9572 | short | rack_counter | Rack letter counter |
| A5-9698 | short[128] | rack_count | Rack letter counts |
| A5-9700 | short | found_count | Valid words found (max 1000) |
| A5-9708 | long | result_ptr | Current result position |
| A5-9712 | long | search_ptr | Current search position |
| A5-9728 | char[16] | current_word | Word being built |
| A5-9760 | char[32] | result_word | Result buffer |
| A5-9776 | char[16] | cross_letters | Cross-check letters |
| A5-9792 | char[16] | rack_letters | Rack letters |
| A5-9808 | char[16] | rack_string | Rack as string |
| A5-11960 | long | dawg_base | DAWG array base pointer |
| A5-11964 | long | dawg_position | Current DAWG position |
| A5-23674 | short | bounds_counter | Bounds checking counter |
| A5-24030 | long | compare_ptr | DAWG compare pointer |
| A5-27732 | long | dawg_ptr | Main DAWG pointer |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | bounds_check - Assert/error handler |
| 426 | memset - Clear memory |
| 802 | check_dictionary - Verify word exists |
| 1738 | init_add - Initialize for adding word |
| 2034 | string function |
| 3506 | strcmp - String comparison |
| 3522 | strlen - String length |
| 3562 | tolower - Convert to lowercase |

## Confidence: HIGH

Clear word validation patterns:
- Letter availability tracking with 128-entry arrays
- Recursive DAWG search with backtracking
- Cross-check validation for perpendicular words
- Result collection with 1000-word limit
- Blank tile handling as wildcards
