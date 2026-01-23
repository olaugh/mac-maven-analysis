# CODE 43 Detailed Analysis - Cross-Check Set Generation

## Overview

| Property | Value |
|----------|-------|
| Size | 1486 bytes |
| JT Offset | 2688 |
| JT Entries | 4 |
| Functions | 5 |
| Purpose | **Generate cross-check sets for board positions, validate perpendicular words** |

## Architecture Role

CODE 43 handles cross-check set generation:
1. Build validity masks for each board position
2. Determine which letters can form valid perpendicular words
3. Cache cross-check results for move generation
4. Support both horizontal and vertical directions

## Key Functions

### Function 0x0000 - Get Cross-Check for Position
```asm
0000: LINK       A6,#-4               ; frame=4
0004: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)

; Get move candidate
0008: MOVEA.L    8(A6),A0
000C: MOVEQ      #0,D5
000E: MOVE.B     13(A0),D5            ; D5 = direction byte

; Calculate cache index
0012: MOVE.L     D5,D7
0014: EXT.L      D7
0016: ...
001C: EXT.L      D5
001E: ...

; Index into cross-check cache
0024: AND.L      D5,A0
0026: LEA        -1664(A5),A4         ; Cross-check cache
002A: ADD.B      A4,(A0)
002C: MOVEA.L    D0,A4

; Check if already computed
002E: TST.W      (A4)                 ; Cached?
0030: BNE.S      $008C                ; Yes - use cached

; Not cached - compute cross-check
0032: MOVEA.L    12(A6),A0            ; Get board position
0036: MOVE.B     32(A0),D3            ; Row
003A: EXT.W      D3
003C: MOVE.B     33(A0),D4            ; Column
0040: EXT.W      D4

; Index into board array
0042: MOVEQ      #17,D0
0044: AND.L      D3,A0
0046: LEA        -17154(A5),A2        ; g_state1
004A: ADD.B      A2,(A0)
004C: MOVEA.W    D4,A2
004E: ADD.B      A2,(A0)
0050: MOVEA.L    D0,A2

; Index into DAWG lookup
0052: MOVEQ      #68,D0
0054: AND.L      D3,A0
0056: MOVE.W     #$0880,D1
005A: AND.L      D5,A1
005C: ADD.B      -12536(A5),(A1)      ; DAWG table base
0060: ADD.B      D1,(A0)
...

; Build cross-check mask by scanning perpendicular
006E: MOVEQ      #0,D5                ; D5 = valid letter mask
0070: MOVE.L     A0,D6                ; D6 = position ptr
0072: BRA.S      $007E

; Loop through adjacent squares
0072: TST.B      (A2)                 ; Empty square?
0074: BNE.S      $0078                ; No - check DAWG
0076: OR.L       (A3),D5              ; Add valid letters
0078: ADDQ       #1,D6                ; Next position
007A: ADDQ       #1,A2                ; Next board square
007C: ADDQ       #4,A3                ; Next DAWG entry
007E: MOVEA.L    D6,A0
0080: TST.B      (A0)                 ; End of check?
0082: BNE.S      $0072                ; Continue

; Store computed cross-check
0084: MOVE.L     D5,2(A4)             ; Store mask
0088: MOVE.W     #$0001,(A4)          ; Mark as valid

; Return cross-check mask
008C: MOVEA.L    A5,A0
008E: MOVE.L     D7,D0
0090: EXT.L      D0
0092: ...
0096: MOVE.L     -26154(A0),D0        ; Get rack mask
009A: AND.L      2(A4),D0             ; AND with cross-check

009E: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
00A2: UNLK       A6
00A4: RTS
```

**C equivalent**:
```c
uint32_t get_crosscheck(Move* move, Position* pos) {
    int direction = move->direction;
    int cache_idx = calculate_index(direction);

    CrossCheck* cached = &g_crosscheck_cache[cache_idx];

    if (cached->valid) {
        // Return cached result AND'd with rack letters
        return g_rack_mask & cached->letter_mask;
    }

    // Compute cross-check
    int row = pos->row;
    int col = pos->col;

    char* board = &g_state1[row * 17 + col];
    uint32_t* dawg = &g_dawg_table[row * 68 + ...];

    uint32_t valid_mask = 0;

    // Scan perpendicular direction for valid extensions
    while (*board) {
        if (*board == 0) {  // Empty
            valid_mask |= *dawg;  // Add DAWG valid letters
        }
        board++;
        dawg++;
    }

    cached->letter_mask = valid_mask;
    cached->valid = 1;

    return g_rack_mask & valid_mask;
}
```

### Function 0x00A6 - Clear Cross-Check Cache
```asm
00A6: PEA        $0030.W              ; Size = 48 bytes
00AA: PEA        -1664(A5)            ; Cache address
00AE: JSR        426(A5)              ; JT[426] - memset
00B2: ADDQ       #8,A7
00B4: RTS
```

### Function 0x00B6 - Build Full Cross-Check Table
```asm
00B6: LINK       A6,#-12              ; frame=12
00BA: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)

; Clear temporary buffer
00BE: PEA        $0080.W              ; Size = 128 bytes
00C2: PEA        -12668(A5)           ; Temp buffer
00C6: JSR        426(A5)              ; JT[426] - memset

; Initialize iteration
00CA: MOVEQ      #0,D6                ; Counter
00CC: LEA        -13060(A5),A4        ; Letter pair table
00D0: ADDQ       #8,A7
00D2: BRA.W      $01CA

; Process each letter pair entry
00D6: MOVE.W     (A4),D4              ; Get entry
00D8: MOVE.W     D4,-(A7)
00DA: JSR        2450(A5)             ; JT[2450] - get DAWG node
00DE: MOVEA.L    D0,A3                ; A3 = DAWG node
00E0: MOVEA.L    A3,A2
00E2: ADDQ       #4,A7

; Mark valid letters in temp buffer
00E4: BRA.S      $00F0
00E6: MOVEA.L    A5,A0
00E8: ADD.W      D3,A0
00EA: ADDQ.B     #1,-12668(A0)        ; Increment count
00EE: ADDQ       #1,A2

00F0: MOVE.B     (A2),D3              ; Get letter
00F2: EXT.W      D3
00F4: TST.W      D3
00F6: BNE.S      $00E6                ; Continue if not null

; Check against threshold
00F8: MOVE.B     -12605(A5),D0        ; Get threshold
00FC: CMP.B      -23155(A5),D0        ; Compare
0100: BGE.W      $01B0                ; Skip if below

; Process valid combinations
0104: MOVEA.L    A3,A2
0106: MOVE.L     D4,D7
0108: EXT.L      D7
010A: ...
010E: ...
0112: BRA.W      $01A6

; Loop through valid letters
0116: CMPI.W     #$003F,D3            ; Check for '?' (blank)
011A: BEQ.W      $01A4                ; Skip blanks

; Check if letter already adjacent
011E: MOVE.B     1(A2),D0             ; Next letter
0122: EXT.W      D0
0124: CMP.W      D3,A0
0126: BEQ.S      $01A2                ; Skip duplicates

; Build combined entry
0128: MOVE.W     D4,D5
012A: MOVE.L     D3,D0
012C: EXT.L      D0
012E: ...
0134: MOVE.B     -12668(A0),D1        ; Get count
0138: EXT.W      D1

; Look up in cross-word table
013A: LEA        -19470(A5),A0        ; Cross-word validity
013E: ADD.B      A0,(A0)
0140: MOVEA.W    D1,A0
0142: ADD.B      A0,$CA70.W
...

; Check DAWG validity
014C: MOVE.B     -12605(A5),D0        ; Get node
...

; Get cross-check mask
0158: NOT.W      D0                   ; Invert
015A: ANDI.W     #$007F,D0            ; Mask to 7 bits
015E: OR.W       D0,D5                ; Add to mask

; Store in results array
0160: MOVE.L     D5,D0
0162: EXT.L      D0
...
016C: MOVE.L     D0,-8(A6)            ; Store index

; Get score lookup
0170: LEA        -27630(A5),A0        ; Score table
0174: ADD.W      D3,A0
0176: ADD.W      D3,A0
0178: MOVE.L     A0,-4(A6)

; Compare with existing entry
017C: MOVEA.L    D0,A1
017E: MOVEA.W    (A0),A0
0180: MOVE.L     (A1),-12(A6)         ; Current value
0184: MOVEA.L    D7,A1
0186: MOVE.L     (A1),D1
0188: SUB.B      A0,(A1)              ; Compare
018A: CMP.L      -12(A6),D1
018E: BLE.S      $01A2                ; Not better

; Update with better value
0190: MOVEA.L    -4(A6),A0            ; Score ptr
0194: MOVEA.W    (A0),A0
0196: MOVEA.L    D7,A1
0198: MOVE.L     (A1),D0
019A: SUB.B      A0,(A0)
019C: MOVEA.L    -8(A6),A0            ; Destination
01A0: MOVE.L     D0,(A0)              ; Store new best

01A2: ADDQ       #1,A2                ; Next letter
01A4: MOVE.B     (A2),D3
01A6: EXT.W      D3
01A8: TST.W      D3
01AA: BNE.W      $0118                ; Continue

; Clear temp buffer for next iteration
01AE: MOVEA.L    A3,A2
01B0: BRA.S      $01BC

01B2: MOVEA.L    A5,A0
01B4: ADD.W      D3,A0
01B6: CLR.B      -12668(A0)           ; Clear count
01BA: ADDQ       #1,A2

01BC: MOVE.B     (A2),D3
01BE: EXT.W      D3
01C0: TST.W      D3
01C2: BNE.S      $01B2                ; Continue

; Next letter pair entry
01C4: ADDQ       #1,D6                ; Increment counter
01C6: ADDQ       #2,A4                ; Next entry
01C8: CMP.W      -13062(A5),A6        ; Check bounds
01CC: BLT.W      $00D8                ; Continue loop

01D0: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
01D4: UNLK       A6
01D6: RTS
```

**C equivalent**:
```c
void build_crosscheck_table(void) {
    char temp_counts[128] = {0};

    for (int i = 0; i < g_letter_pair_count; i++) {
        uint16_t entry = g_letter_pair_table[i];

        char* dawg_node = get_dawg_node(entry);

        // Count valid letters
        for (char* p = dawg_node; *p; p++) {
            temp_counts[*p]++;
        }

        if (temp_counts[0] < g_threshold) {
            continue;  // Below threshold
        }

        // Process valid letter combinations
        for (char* p = dawg_node; *p; p++) {
            char letter = *p;

            if (letter == '?') continue;  // Skip blanks
            if (p[1] == letter) continue; // Skip duplicates

            uint16_t combined = entry;
            int count = temp_counts[letter];

            // Check cross-word validity
            int valid = check_crossword_validity(letter, count);

            if (valid) {
                uint16_t mask = (~get_dawg_mask(letter)) & 0x7F;
                combined |= mask;

                // Compare with existing and update if better
                int score = g_score_table[letter * 2];
                if (score > g_best_scores[combined]) {
                    g_best_scores[combined] = score;
                }
            }
        }

        // Clear counts for next iteration
        for (char* p = dawg_node; *p; p++) {
            temp_counts[*p] = 0;
        }
    }
}
```

### Function 0x01D8 - Swap Cross-Check Entries
```asm
01D8: LINK       A6,#-4               ; frame=4
01DC: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)

; Initialize rack
01E0: MOVE.L     8(A6),-(A7)
01E4: JSR        3522(A5)             ; JT[3522] - init rack

; Setup mask
01E8: MOVEA.L    A5,A0
01EA: ...
01EE: MOVE.W     #$0080,D6            ; Processed flag
01F2: SUB.B      -26152(A0),A6        ; Adjust for rack

; Initialize iteration
01F6: MOVEQ      #0,D5
01F8: LEA        -13060(A5),A0        ; Letter pair table
01FC: MOVE.L     A0,-4(A6)
0200: ADDQ       #8,A7
0202: BRA.S      $0270

; Process each entry
0204: MOVEA.L    -4(A6),A0
0208: MOVE.W     (A0),D4              ; Get entry

; Check if processed
020A: MOVE.W     D6,D0
020C: AND.W      D4,D0
020E: CMP.W      D6,A0
0210: BNE.S      $026A                ; Already processed

; Get cross-check value
0212: MOVE.W     D4,-(A7)
0214: MOVE.W     #$007F,-(A7)         ; Mask
0218: JSR        2474(A5)             ; JT[2474]
021C: OR.W       D6,D0                ; Mark processed
021E: MOVE.W     D0,D3
0220: CMP.W      D3,A4
0222: ADDQ       #4,A7
0224: BLT.S      $026A                ; Invalid - skip

; Swap entries between tables
0226: MOVE.L     D4,D0
0228: EXT.L      D0
022A: ...
0232: MOVEA.L    D0,A3
0234: MOVE.L     (A3),D7              ; Get current value

; Get other entry
0236: MOVE.L     D3,D0
0238: EXT.L      D0
023A: ...
0242: MOVEA.L    D0,A2

; Swap values
0244: MOVE.L     (A2),(A3)            ; A3 = A2
0246: MOVE.L     D7,(A2)              ; A2 = D7 (old A3)

; Repeat for second table
0248: MOVE.L     D4,D0
024A: EXT.L      D0
024C: ...
0254: MOVEA.L    D0,A2
0256: MOVE.L     (A2),D7              ; Get value

025A: MOVE.L     D3,D0
025C: EXT.L      D0
025E: ...
0264: MOVEA.L    D0,A3
0266: MOVE.L     (A3),(A2)            ; Swap
0268: MOVE.L     D7,(A3)

; Next entry
026A: ADDQ       #1,D5
026C: ADDQ.L     #2,-4(A6)            ; Advance table ptr
0270: CMP.W      -13062(A5),A5        ; Check bounds
0274: BLT.S      $0204                ; Continue

; Check for blank handling
0276: MOVE.W     #$003F,-(A7)         ; '?' character
027A: MOVE.L     8(A6),-(A7)
027E: JSR        3514(A5)             ; JT[3514]
0282: TST.L      D0
0284: ADDQ       #6,A7
0286: BEQ.S      $028C
0288: JSR        -468(PC)             ; Additional processing

; Process results
028C: MOVEQ      #0,D5
028E: LEA        -13060(A5),A4        ; Letter pair table
0292: BRA.S      $0302

; Update result entries
0294: MOVE.W     (A4),D4
0296: MOVEA.L    A5,A0
0298: MOVE.L     D4,D0
029A: EXT.L      D0
029C: ...
02A0: MOVE.L     -12496(A0),D6        ; Get cache value

; Check validity
02A4: MOVE.L     D4,D0
02A6: EXT.L      D0
02A8: ...
02B0: MOVEA.L    D0,A2
02B2: TST.L      D6
02B4: BNE.S      $02D6                ; Has value

; Check results array
02B6: MOVEA.L    A5,A0
02B8: MOVE.L     D4,D0
02BA: EXT.L      D0
02BC: ...
02C0: TST.L      -22698(A0)           ; g_results_array
02C4: BEQ.S      $02D6                ; No result

; Get adjusted value
02C6: MOVEA.L    A5,A0
02C8: ADD.W      D4,A0
02CA: ADD.W      D4,A0
02CC: MOVE.W     -13318(A0),D0        ; Get adjustment
02D0: ADD.B      D0,A0
02D2: EXT.L      D0
02D4: BRA.S      $02DA

02D6: MOVE.L     D6,D0
02D8: NEG.L      D0                   ; Negate

; Store final value
02DA: MOVEA.L    A5,A0
02DC: MOVE.L     D4,D1
02DE: EXT.L      D1
02E0: ...
02E4: ADD.B      -22698(A0),(A0)      ; Store

02E8: MOVE.L     D0,(A2)

; Validate result
02EA: MOVEA.L    A5,A0
02EC: MOVE.L     D4,D0
02EE: EXT.L      D0
02F0: ...
02F4: TST.L      -12496(A0)           ; Check cache
02F8: BGE.S      $02FE                ; Valid
02FA: JSR        418(A5)              ; JT[418] - error

02FE: ADDQ       #1,D5
0300: ADDQ       #2,A4
0302: CMP.W      -13062(A5),A5
0306: BLT.S      $0294                ; Continue

0308: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
030C: UNLK       A6
030E: RTS
```

### Function 0x0310 - Initialize Cross-Check Tables
```asm
0310: LINK       A6,#-18              ; frame=18
0314: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)

; Clear main table (17408 bytes = 0x4400)
0318: PEA        $4400.W
031C: MOVE.L     -12536(A5),-(A7)     ; Table pointer
0320: JSR        426(A5)              ; JT[426] - memset

; Get move list
0324: MOVEA.L    8(A6),A4             ; A4 = move list head
0328: ADDQ       #8,A7
032A: BRA.W      $04C4

; Process each move
032E: MOVEQ      #0,D3
0330: MOVE.B     13(A4),D3            ; Direction
0334: MOVE.L     D3,D6
0336: EXT.L      D6

; Validate direction
0338: ...
033E: BLT.S      $0346
0340: CMPI.W     #8,D6
0344: BLT.S      $034A
0346: JSR        418(A5)              ; JT[418] - error

; Validate row
034A: EXT.L      D3
034C: ...
0352: TST.W      D3
0354: BLT.S      $035C
0356: CMPI.W     #$0020,D3
035A: BCS.S      $0360
035C: JSR        418(A5)              ; JT[418] - error

; Get rack mask
0360: MOVEA.L    A5,A0
0362: MOVE.L     D3,D0
0364: EXT.L      D0
0366: ...
036A: MOVE.L     -26154(A0),D5        ; D5 = rack mask

; Get position from move
036E: MOVE.B     10(A4),D3            ; Row
0372: EXT.W      D3

; Validate row
0374: TST.W      D3
0376: BLT.S      $037E
0378: CMPI.W     #$001F,D3
037C: BLT.S      $0382
037E: JSR        418(A5)              ; JT[418] - error

; Skip if row is 0
0382: TST.W      D3
0384: BEQ.W      $04C2

; Get column
0388: MOVE.B     11(A4),D4            ; Column
038C: EXT.W      D4

; Validate column
038E: TST.W      D4
0390: BLE.S      $0398
0392: CMPI.W     #$000F,D4
0396: BLT.S      $039C
0398: JSR        418(A5)              ; JT[418] - error

; Calculate board index
039C: MOVEQ      #17,D0
039E: AND.L      D3,A0
03A0: LEA        -17154(A5),A0        ; g_state1
03A4: ADD.B      A0,(A0)
03A6: MOVEA.W    D4,A0
03A8: ADD.B      A0,(A0)
03AA: MOVE.L     D0,-16(A6)

; Get tile from board
03AE: MOVE.B     12(A4),D1            ; Tile value
03B2: EXT.W      D1
03B4: MOVEA.W    D1,A0
03B6: ADD.B      A0,(A0)
03B8: MOVE.L     D0,-4(A6)

; Calculate DAWG index
03BC: MOVE.W     #$0880,D1
03C0: AND.L      D6,A1
03C2: MOVE.L     D1,-8(A6)

03C6: MOVE.L     D4,D2
03C8: EXT.L      D2
...
03CE: MOVEQ      #68,D2
03D0: AND.L      D3,A2
03D2: ADD.B      -12536(A5),(A1)
03D6: ADD.B      D1,(A2)
03D8: ADD.B      A2,(A2)
03DA: MOVE.L     D2,D7

; Check column boundary
03DC: CMPI.W     #1,D4
03E0: BEQ.S      $03E6
03E2: MOVEA.L    D7,A0
03E4: OR.L       D5,-(A0)             ; Set bit for adjacent

; Initialize loop
03E6: MOVEQ      #1,D6                ; Start column 1
03E8: ADD.W      D3,A6
03EA: MOVEQ      #-1,D0
03EC: ADD.B      D3,A0
03EE: MOVE.W     D0,-18(A6)           ; Store -1
03F2: MOVE.L     A2,-12(A6)
03F6: BRA.W      $04AC

; Check board position
03FA: MOVEA.L    -16(A6),A0
03FE: TST.B      (A0)                 ; Empty?
0400: BNE.W      $04A0                ; No - skip

; Validate column
0404: TST.W      D4
0406: BLE.S      $040E
0408: CMPI.W     #$0010,D4
040C: BLT.S      $0412
040E: JSR        418(A5)              ; JT[418] - error

; OR in rack mask
0412: MOVEA.L    D7,A0
0414: OR.L       D5,(A0)

; Scan forward for cross-check
0416: MOVE.W     D6,D3
0418: MOVEQ      #68,D0
041A: AND.L      D3,A0
041C: MOVEA.L    D0,A2
041E: MOVEQ      #17,D0
0420: AND.L      D3,A0
0422: LEA        -17154(A5),A3        ; g_state1
0426: ADD.B      A3,(A0)
0428: MOVEA.L    D0,A3
042A: BRA.S      $044E

; Loop forward
042C: TST.B      0(A3,D4.W)           ; Check position
0430: BNE.S      $0444                ; Occupied - stop

; OR in DAWG valid letters
0432: MOVEA.L    -12536(A5),A0
0436: ADD.B      -8(A6),(A0)
043A: ADD.B      A2,(A0)
...
0442: BRA.S      $045A

0444: ADDQ       #1,D3                ; Next column
0446: LEA        68(A2),A2
044A: LEA        17(A3),A3
044E: CMPI.W     #$001F,D3            ; Check bound
0452: BEQ.S      $045A
0454: CMPI.W     #$0010,D3
0458: BNE.S      $042C                ; Continue

; Scan backward
045A: MOVE.W     -18(A6),D3           ; Get -1
045E: MOVEQ      #68,D0
0460: AND.L      D3,A0
0462: MOVEA.L    D0,A2
0464: MOVEQ      #17,D0
0466: AND.L      D3,A0
0468: LEA        -17154(A5),A3
046C: ADD.B      A3,(A0)
046E: MOVEA.L    D0,A3
0470: BRA.S      $0494

; Loop backward
0472: TST.B      0(A3,D4.W)
0476: BNE.S      $048A                ; Occupied - stop

; OR in DAWG valid letters
0478: MOVEA.L    -12536(A5),A0
047C: ADD.B      -8(A6),(A0)
...
0488: BRA.S      $049E

048A: SUBQ       #1,D3                ; Previous column
048E: LEA        -68(A2),A2
0494: TST.W      D3                   ; Check bound
0496: BEQ.S      $049E
0498: CMPI.W     #$000F,D3
049C: BNE.S      $0472                ; Continue

; Advance to next position
049E: ADD.L      #1,-16(A6)           ; Next board pos
04A2: ADDQ       #4,D7                ; Next DAWG entry
04A4: ADDQ       #1,D4                ; Next column
04A6: ADD.L      #4,-12(A6)

; Check loop bounds
04AA: MOVE.L     -16(A6),D0
04AE: CMP.L      -4(A6),D0
04B2: BCS.W      $03FC                ; Continue

; Handle end boundary
04B6: CMPI.W     #$0010,D4
04BA: BEQ.S      $04C0
04BC: MOVEA.L    D7,A0
04BE: OR.L       D5,(A0)              ; Set end bit

; Next move
04C0: MOVEA.L    (A4),A4              ; Follow link
04C2: MOVE.L     A4,D0
04C4: BNE.W      $0330                ; Continue

; Finalize
04C8: JSR        10(PC)               ; Post-processing

04CC: MOVEM.L    (SP)+,D3/D4/D5/D6/D7/A2/A3/A4
04D0: UNLK       A6
04D2: RTS
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1664 | Cross-check cache (48 bytes) |
| A5-12536 | DAWG table base pointer |
| A5-12605 | Threshold value |
| A5-12668 | Temporary count buffer (128 bytes) |
| A5-13060 | Letter pair table |
| A5-13062 | Letter pair count |
| A5-17154 | g_state1 - Board letters |
| A5-19470 | Cross-word validity table |
| A5-22698 | g_results_array |
| A5-23155 | Comparison threshold |
| A5-26154 | Rack letter mask |
| A5-27630 | Score lookup table |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418 | Error handler |
| 426 | memset |
| 2450 | Get DAWG node |
| 2474 | Get cross-check value |
| 3514 | Check for character |
| 3522 | Initialize rack |

## Algorithm

Cross-check generation process:
1. For each board position
2. Scan perpendicular direction (forward and backward)
3. Find existing tiles that form partial words
4. Query DAWG to find letters that extend to valid words
5. Build mask of valid letters for that position
6. Cache results for move generation reuse

## Confidence: MEDIUM-HIGH

Complex cross-check logic with:
- Two-directional scanning (forward/backward)
- DAWG integration for word validation
- Caching for performance
- Proper boundary checking

Some disassembly artifacts but algorithm patterns are recognizable.
