# CODE 22 Detailed Analysis - Debug Output & Board Dump

## Overview

| Property | Value |
|----------|-------|
| Size | 2,056 bytes |
| JT Offset | 1376 |
| JT Entries | 6 |
| Functions | 11 |
| Purpose | **Debug/diagnostic output, board state dumping, file I/O, word checking** |

## System Role

**Category**: Debug & I/O
**Function**: Board serialization, debug output, file operations, word validation

## Architecture Role

CODE 22 provides debugging and file I/O functions:
1. Board state text dump (for debugging/logging)
2. Game file save/load functionality
3. Word validation against board
4. Game state serialization

## Key Functions

### Function 0x0000 - Dump Board State to Text

Generates a text representation of the board state for debugging.

```asm
0000: LINK       A6,#-152             ; 152 bytes local (text buffer)
0004: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0008: MOVE.W     8(A6),D5             ; D5 = output file handle
000C: MOVEQ      #1,D4                ; D4 = row counter (1-16)
000E: LEA        -27229(A5),A4        ; A4 = word multiplier array
0012: LEA        -26685(A5),A0        ; A0 = letter multiplier array
0016: MOVE.L     A0,D6
0018: LEA        -17137(A5),A3        ; A3 = board letters (skip border)
001C: LEA        -16576(A5),A0        ; A0 = board scores
0020: MOVE.L     A0,D7
```

**Board symbol encoding**:
| Symbol | Meaning | Check Value |
|--------|---------|-------------|
| Uppercase | Placed tile | Non-zero in letter array |
| Lowercase | Tentative tile (being played) | Check tentative flag |
| `$` | Double letter score | Letter multiplier = 2 |
| `*` | Triple letter score | Letter multiplier = 3 |
| `+` | Double word score | Word multiplier = 2 |
| `#` | Triple word score | Word multiplier = 3 |
| `-` | Empty square | All checks fail |

```asm
; Check cell type and format output
0082: CMPI.B     #2,0(A0,D3.W)        ; Double letter?
0088: BNE.S      $0090
008A: MOVE.B     #'$',(A2)+           ; '$' = 0x24 = double letter
008E: BRA.S      $00CA

0090: CMPI.B     #3,0(A0,D3.W)        ; Triple letter?
009A: BNE.S      $00A2
009C: MOVE.B     #'*',(A2)+           ; '*' = 0x2A = triple letter
00A0: BRA.S      $00CA

00A2: CMPI.B     #2,0(A0,D3.W)        ; Double word?
00AC: BNE.S      $00B4
00AE: MOVE.B     #'+',(A2)+           ; '+' = 0x2B = double word
00B2: BRA.S      $00CA

00B4: CMPI.B     #3,0(A0,D3.W)        ; Triple word?
00BE: BNE.S      $00C6
00C0: MOVE.B     #'#',(A2)+           ; '#' = 0x23 = triple word
00C4: BRA.S      $00CA

00C6: MOVE.B     #'-',(A2)+           ; '-' = 0x2D = empty square
```

**Output format** (example):
```
A B C - - + D E F ...
G H - $ * # - I J ...
...
g_field_14: [word being played]
g_field_22: [cross word]
g_size1: 56630  g_size2: 65536
```

### Function 0x0162 - Save Game to File

Creates and writes a game save file.

```asm
0162: LINK       A6,#-30
0166: MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)
016A: MOVE.W     8(A6),D6             ; D6 = vRefNum (volume)
016E: MOVE.L     10(A6),D7            ; D7 = filename pointer

; Create file with type 'TEXT', creator 'XGME'
0172: MOVE.L     #'TEXT',-(A7)        ; File type = 0x54455854
0178: MOVE.W     #$0001,-(A7)         ; Flags
017C: PEA        -2(A6)               ; Result: file reference
0180: MOVE.W     D6,-(A7)             ; vRefNum
0182: MOVE.L     D7,-(A7)             ; Filename
0184: JSR        3378(A5)             ; JT[3378] - FSCreate
...
01A2: MOVE.L     #'XGME',-26(A6)      ; Creator = 'XGME' (Maven)
```

**File format**:
- Creator: 'XGME' (Maven application)
- Type: 'TEXT'
- 6-byte records for each game element
- Includes: window state, board data, rack, game settings

```asm
; Write records in loop
01DC: PEA        $0006.W              ; Push 6 (record size)
01E0: MOVE.L     -30(A6),-(A7)        ; Push handle size
01E4: JSR        74(A5)               ; JT[74] - divide for record count
...
021C: JSR        2866(A5)             ; JT[2866] - FSWrite
...
02B4: JSR        1242(A5)             ; JT[1242] - FlushVol
02BC: MOVEQ      #1,D0                ; Return success
```

### Function 0x02C8 - Load Game from File

Reads and restores a game from a save file.

```asm
02C8: LINK       A6,#-30
02CC: MOVEM.L    D5/D6/D7/A2/A3/A4,-(SP)
02D0: MOVE.L     10(A6),D7            ; D7 = filename pointer

; Null-terminate Pascal string filename
02D4: MOVEA.L    D7,A0
02D6: MOVE.B     (A0),D0              ; Get length byte
02D8: EXT.W      D0
...
02E0: CLR.B      0(A0,D1.L)           ; Null terminate

; Open file
02E4: CLR.W      -(A7)                ; Read permission
02E6: MOVE.L     D7,-(A7)             ; Filename
02E8: MOVE.W     8(A6),-(A7)          ; vRefNum
02EC: PEA        -2(A6)               ; IOParamBlock
02F0: JSR        2842(A5)             ; JT[2842] - FSOpen
```

**Restoration process**:
1. Open file for reading
2. Read record count
3. For each record: read 6 bytes, parse, apply to game state
4. Update lookup table (289 bytes at A5-10388)
5. Close file

```asm
; Restore lookup table (289 bytes)
046A: PEA        $0121.W              ; 289 = 0x121 bytes
046E: PEA        -10388(A5)           ; g_lookup_tbl destination
0472: PEA        -10099(A5)           ; Source
0476: JSR        3466(A5)             ; JT[3466] - memcpy
047A: MOVEQ      #1,D0                ; Return success
```

### Function 0x0486 - Quick Board Check

Fast validation check for board buffer.

```asm
0486: LINK       A6,#0
048A: LEA        -15514(A5),A0        ; A0 = g_field_14
048E: CMP.L      8(A6),A0             ; Compare with param
0494: BNE.S      $04A2                ; Different, skip
0494: JSR        658(A5)              ; JT[658] - init_subsystem
0498: MOVE.L     8(A6),-(A7)
049C: JSR        2402(A5)             ; JT[2402] - process_buffer
04A2: UNLK       A6
04A4: RTS
```

### Function 0x04A4 - Validate and Initialize Search

Complex validation and search initialization.

```asm
04A4: LINK       A6,#0
04A8: MOVEM.L    D6/D7,-(SP)
04AC: MOVE.W     8(A6),D7             ; D7 = search mode
04B0: CMPI.W     #$0008,-23674(A5)    ; Bounds check
04B6: BCC.S      $04BE
04B8: TST.W      -23674(A5)
04BC: BGE.S      $04C2
04BE: JSR        418(A5)              ; JT[418] - bounds_error
...
04E8: PEA        -10388(A5)           ; g_lookup_tbl
04EC: JSR        158(PC)              ; Local function call
```

### Function 0x058C - Check Word Against Board

Validates that a word on the board exists in the dictionary.

```asm
058C: LINK       A6,#-288             ; Large frame for word buffer
0590: MOVEM.L    D7/A3/A4,-(SP)
0594: MOVEA.L    8(A6),A4             ; A4 = board position pointer

; Find horizontal word start
05A8: TST.B      -1(A4)               ; Check position before
05AC: BNE.S      $060E                ; If not empty, not word start

; Copy word characters to buffer
05AE: LEA        -32(A6),A3           ; A3 = buffer for word
05B2: BRA.S      $05C4

05B4: MOVE.B     (A4),D0              ; Get letter
05B6: EXT.W      D0
05B8: MOVE.W     D0,-(A7)
05BA: JSR        3554(A5)             ; JT[3554] - toupper
05BE: MOVE.B     D0,(A3)+             ; Store uppercase
05C0: LEA        12(A7),A7
05C2: ADDQ.L     #1,A4                ; Next position

05C4: TST.B      (A4)                 ; End of word?
05C6: BNE.S      $05B4                ; Continue if not

; Check dictionary
05C8: CLR.B      (A3)                 ; Null terminate
05CA: PEA        -32(A6)              ; Push word
05CE: JSR        794(A5)              ; JT[794] - check_in_dictionary
05D2: TST.L      D0
05D6: BNE.W      $065C                ; If found, continue
```

**Algorithm**:
1. Find start of horizontal word (no letter to left)
2. Copy letters to uppercase buffer
3. Check against DAWG dictionary
4. Report error if word not found
5. Also checks isolated single letters

### Function 0x0674 - Extended Word Validation

More comprehensive word validation with multiple checks.

```asm
0674: LINK       A6,#-32              ; frame=32
0678: MOVE.L     D7,-(A7)
067A: MOVEQ      #1,D7                ; D7 = result flag
...
0696: PEA        -10388(A5)           ; g_lookup_tbl
06A0: JSR        270(PC)              ; Local validation function
...
; Check DAWG comparison
06B8: MOVE.L     -24138(A5),-(A7)
06BE: MOVE.L     -24030(A5),-(A7)
...
06C8: LEA        -24026(A5),A0        ; g_common
```

### Function 0x07B0 - Transpose Board

Swaps rows and columns for vertical word processing.

```asm
07B0: LINK       A6,#0
07B4: MOVEM.L    D4/D5/D6/D7/A2/A3/A4,-(SP)
07B8: MOVEQ      #0,D6                ; D6 = row counter
...
; Swap board[row][col] with board[col][row]
07D0: MOVE.B     0(A3,D5.W),D4        ; Get [row][col]
07D4: MOVEA.L    A2,A0
07D6: ADDA.L     8(A6),A0             ; Offset
07DC: MOVE.L     A0,D7
07DE: MOVEA.L    D7,A0
07E0: MOVE.B     (A0),0(A3,D5.W)      ; Swap
07E4: MOVEA.L    D7,A0
07E6: MOVE.B     D4,(A0)              ; Complete swap
07E8: ADDQ.B     #1,D5                ; Next column
07EA: LEA        17(A2),A2            ; Next row of source
...
07F4: ADDQ.B     #1,D6                ; Next row
07F6: LEA        17(A4),A4
07FA: CMPI.W     #17,D6               ; 17 rows
07FE: BLT.S      $07BE
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-3768 | Additional data buffer |
| A5-8510 | Window pointer (Toolbox) |
| A5-10099 | Source board array |
| A5-10388 | g_lookup_tbl (289 bytes) |
| A5-15502 | g_size2 |
| A5-15506 | g_size1 |
| A5-15514 | g_field_14 (current word being played) |
| A5-15522 | g_field_22 (cross word) |
| A5-16576 | Board score array |
| A5-17137 | Board letter array (offset by 17 for border) |
| A5-23674 | Counter/state variable |
| A5-24026 | g_common |
| A5-24030 | DAWG pointer |
| A5-24138 | DAWG comparison pointer |
| A5-26685 | Letter multiplier array (17x17) |
| A5-27229 | Word multiplier array (17x17) |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 74 | Integer division |
| 354 | set_random_seed |
| 418 | bounds_error |
| 658 | init_subsystem |
| 794 | check_in_dictionary |
| 1242 | FlushVol |
| 1514 | Get resource handle |
| 2026 | Wide string conversion |
| 2402 | process_buffer |
| 2826 | GetHandleSize |
| 2842 | FSOpen (read) |
| 2850 | FSClose |
| 2858 | FSRead |
| 2866 | FSWrite |
| 2874 | FSOpen (write) |
| 2890 | SetFileInfo |
| 2906 | SetFileType |
| 2922 | SetEOF |
| 3370 | Write string to file |
| 3378 | FSCreate |
| 3466 | memcpy |
| 3506 | strcmp |
| 3554 | toupper |
| 3562 | tolower |

## File Format Details

**Save file structure**:
- File creator: 'XGME' (Maven executable)
- File type: 'TEXT'
- Record size: 6 bytes
- Records include:
  - Window data from offset 202 of window structure
  - Board state
  - Game settings
  - Rack contents

## Board Representation

The 17x17 board includes border cells:
- Playable area: rows/cols 1-15 (0 and 16 are borders)
- Letter array: stores character codes (0 = empty)
- Score array: stores letter point values
- Letter multiplier array: 1=normal, 2=DL, 3=TL
- Word multiplier array: 1=normal, 2=DW, 3=TW

## Confidence: HIGH

The patterns are clear and well-documented:
- Standard Mac OS file I/O (FSCreate, FSOpen, FSRead, FSWrite, FSClose)
- Text formatting for board display
- Record-based save format
- Dictionary validation via JT[794]
- Board transpose for vertical word processing

---

## Speculative C Translation

### Global Variables

```c
/* Board data structures - 17x17 arrays with border cells */
char  g_word_multipliers[289];   /* A5-27229: Word multiplier grid (1=none, 2=DW, 3=TW) */
char  g_letter_multipliers[289]; /* A5-26685: Letter multiplier grid (1=none, 2=DL, 3=TL) */
char  g_board_letters[289];      /* A5-17137: Board letters (17x17, +17 to skip border) */
short g_board_scores[289];       /* A5-16576: Board tile scores */

char  g_current_word[32];        /* A5-15514: g_field_14 - word being played */
char  g_cross_word[32];          /* A5-15522: g_field_22 - perpendicular word */
long  g_size1;                   /* A5-15506: Size parameter 1 (56630 observed) */
long  g_size2;                   /* A5-15502: Size parameter 2 (65536 observed) */

char  g_lookup_table[289];       /* A5-10388: Board lookup table */
WindowPtr g_main_window;         /* A5-8510: Main game window (Toolbox) */

#define BOARD_WIDTH 17
#define BOARD_SIZE  289          /* 17 * 17 */
```

### Function 0x0000 - Dump Board State to Text

Generates a human-readable text representation of the board for debugging or logging.

```c
/*
 * dump_board_to_file - Write board state as ASCII art
 *
 * @param file_handle: File reference number to write to
 *
 * Output format:
 *   A B C - - + D E F ...   (letters on board)
 *   G H - $ * # - I J ...   ($ = DL, * = TL, + = DW, # = TW, - = empty)
 *   ...
 *   g_field_14: EXAMPLE      (current word)
 *   g_field_22: TEST         (cross word)
 *   g_size1: 56630  g_size2: 65536
 */
void dump_board_to_file(short file_handle) {
    char line_buffer[128];       /* -128(A6): Output line buffer */
    int row_counter;             /* D4: Current row (1-16) */
    char* word_mult_ptr;         /* A4: Word multiplier array */
    char* letter_mult_ptr;       /* D6: Letter multiplier array */
    char* board_ptr;             /* A3: Board letters */
    char* score_ptr;             /* D7: Board scores */

    row_counter = 1;
    word_mult_ptr = g_word_multipliers;
    letter_mult_ptr = g_letter_multipliers;
    board_ptr = g_board_letters + BOARD_WIDTH;  /* Skip border row */
    score_ptr = g_board_scores;

    /* Process each row */
    while (row_counter <= 16) {
        char* output_ptr = line_buffer;  /* A2 */
        int col = 1;                      /* D3 */

        /* Store column pointers for this row */
        char* score_row = score_ptr;      /* -136(A6) */
        char* board_row = board_ptr;      /* -132(A6) */
        char* letter_row = letter_mult_ptr; /* -144(A6) */
        char* word_row = word_mult_ptr;   /* -148(A6) */

        /* Process each column */
        while (col <= 16) {
            /* Check if cell has a tile */
            if (score_row[col] != 0) {
                /* Has tile - check if tentative (being played) */
                char letter = board_row[col];

                if (is_tentative_tile(col)) {  /* uncertain: exact check */
                    /* Lowercase = tentative tile */
                    *output_ptr++ = tolower(letter);  /* JT[3562] */
                } else {
                    /* Uppercase = placed tile */
                    *output_ptr++ = letter;
                }
            } else {
                /* Empty cell - show multiplier type */
                if (letter_row[col] == 2) {
                    *output_ptr++ = '$';     /* Double letter */
                } else if (letter_row[col] == 3) {
                    *output_ptr++ = '*';     /* Triple letter */
                } else if (word_row[col] == 2) {
                    *output_ptr++ = '+';     /* Double word */
                } else if (word_row[col] == 3) {
                    *output_ptr++ = '#';     /* Triple word */
                } else {
                    *output_ptr++ = '-';     /* Regular empty */
                }
            }

            *output_ptr++ = ' ';  /* Space between cells */
            col++;
        }

        /* End line with carriage return */
        *output_ptr++ = '\r';
        *output_ptr = '\0';

        /* Write line to file */
        write_string_to_file(file_handle, line_buffer);  /* JT[3370] */

        /* Advance to next row */
        row_counter++;
        word_mult_ptr += BOARD_WIDTH;
        letter_mult_ptr += BOARD_WIDTH;
        board_ptr += BOARD_WIDTH;
        score_ptr += (BOARD_WIDTH * 2);  /* Scores are word-sized */
    }

    /* Write additional debug info */
    write_string_to_file(file_handle, g_current_word);   /* g_field_14 */
    write_string_to_file(file_handle, g_cross_word);     /* g_field_22 */

    /* Format and write size values */
    long size1_scaled = divide_long(g_size1, 100);  /* JT[90] */
    long size2_scaled = divide_long(g_size2, 100);  /* JT[90] */
    sprintf(line_buffer, "g_size1: %ld  g_size2: %ld", size1_scaled, size2_scaled);  /* JT[2066] */
    write_string_to_file(file_handle, line_buffer);
}
```

### Function 0x0162 - Save Game to File

Creates a save file with the current game state.

```c
#define FILE_TYPE_TEXT   'TEXT'
#define FILE_CREATOR     'XGME'    /* Maven application signature */
#define RECORD_SIZE      6

/*
 * save_game_to_file - Write game state to a file
 *
 * @param volume_ref: Volume reference number
 * @param filename: Pascal string filename
 * Returns: 1 on success, 0 on failure
 */
int save_game_to_file(short volume_ref, char* filename) {
    short file_ref;              /* -2(A6): File reference */
    long file_size;              /* -30(A6): Handle size */
    OSErr err;
    /* uncertain */ ParamBlock pb;  /* -26(A6): File info block */

    /* Create the file with TEXT type */
    err = FSCreate(filename, volume_ref, &file_ref, 0x0001, FILE_TYPE_TEXT);  /* JT[3378] */
    if (err != noErr) {
        bounds_error();  /* JT[418] */
    }

    /* Open file for writing */
    err = FSOpen_Write(&pb, volume_ref, filename, 0);  /* JT[2874] */

    /* Set file creator to Maven */
    pb.creator = FILE_CREATOR;  /* 'XGME' = 0x58474D45 */
    FSSetFileInfo(&pb, volume_ref, filename, 0);  /* JT[2906] */

    /* Set file to empty (will write from beginning) */
    SetEOF(file_ref, 0);  /* JT[2922] */

    /* Get window data handle */
    Handle window_data = g_main_window->data_handle;  /* offset 202 in window */
    file_size = GetHandleSize(window_data);  /* JT[2826] */

    /* Calculate number of 6-byte records */
    long record_count = divide_long(file_size, RECORD_SIZE);  /* JT[74] */

    /* Write each record */
    for (long i = 0; i < record_count; i++) {
        long bytes_to_write = RECORD_SIZE;

        /* Get record data from window handle */
        Handle record_handle = get_resource_handle(i);  /* JT[1514] */

        /* Special handling for first record */
        if (i == 0) {
            /* uncertain */ short temp = record_handle[4];
            record_handle[4] = 0;  /* Clear something */
        }

        /* Write 6 bytes */
        FSWrite(file_ref, &bytes_to_write, record_handle);  /* JT[2866] */
    }

    /* Flush volume to ensure data is written */
    FlushVol(volume_ref);  /* JT[1242] */

    return 1;  /* Success */
}
```

### Function 0x02C8 - Load Game from File

Reads and restores a game from a save file.

```c
/*
 * load_game_from_file - Restore game state from file
 *
 * @param volume_ref: Volume reference number
 * @param filename: Pascal string filename
 * Returns: 1 on success, 0 on failure
 */
int load_game_from_file(short volume_ref, char* filename) {
    short file_ref;              /* -2(A6): File reference */
    long bytes_read;             /* -10(A6): Bytes actually read */
    short record_type;           /* -4(A6): Type of current record */
    short record_length;         /* -6(A6): Length of record data */
    OSErr err;

    /* Null-terminate Pascal string for C compatibility */
    char* p = filename;
    int len = (unsigned char)*p;
    p[len + 1] = '\0';

    /* Open file for reading */
    err = FSOpen(filename, volume_ref, &file_ref, 0);  /* JT[2842] */
    if (err != noErr) {
        return 0;
    }

    /* Read and process records */
    while (1) {
        /* Read record header (2 bytes type, 2 bytes length) */
        bytes_read = 2;
        err = FSRead(file_ref, &bytes_read, &record_type);  /* JT[2858] */
        if (err != noErr || bytes_read != 2) break;

        bytes_read = 2;
        err = FSRead(file_ref, &bytes_read, &record_length);
        if (err != noErr) break;

        /* Read record data based on type */
        /* uncertain: exact record processing */
        Handle data_handle = get_resource_handle(record_type);  /* JT[1514] */
        if (data_handle) {
            bytes_read = record_length;
            FSRead(file_ref, &bytes_read, *data_handle);

            /* Process based on record type */
            apply_record_to_game_state(record_type, data_handle);  /* uncertain */
        }
    }

    /* Restore lookup table (289 bytes) */
    memcpy(g_lookup_table, g_lookup_table_source, 289);  /* JT[3466] */
    /* Note: 0x121 = 289 bytes = 17*17 board */

    /* Close file */
    FSClose(file_ref);  /* JT[2850] */

    return 1;  /* Success */
}
```

### Function 0x058C - Check Word Against Board

Validates that a word on the board exists in the dictionary.

```c
/*
 * check_word_on_board - Validate a horizontal word at given position
 *
 * @param board_position: Pointer to first letter position on board
 * Returns: 1 if valid word, 0 if not in dictionary
 */
int check_word_on_board(char* board_position) {
    char word_buffer[32];        /* -32(A6): Buffer to collect word */
    char* word_ptr = word_buffer; /* A3 */
    char* pos = board_position;   /* A4 */

    /* Check if this is the start of a word (no letter to the left) */
    if (pos[-1] != 0) {
        /* Not word start - this is middle of a longer word */
        return 0;  /* uncertain: maybe returns different value */
    }

    /* Collect letters until end of word */
    while (*pos != 0) {
        char letter = *pos;

        /* Convert to uppercase for dictionary lookup */
        *word_ptr++ = toupper(letter);  /* JT[3554] */

        pos++;
    }

    /* Null-terminate the word */
    *word_ptr = '\0';

    /* Check if word is in dictionary */
    int found = check_in_dictionary(word_buffer);  /* JT[794] */
    if (!found) {
        /* Word not in dictionary - invalid */
        return 0;
    }

    /* Word is valid */
    return 1;
}
```

### Function 0x07B0 - Transpose Board

Swaps rows and columns for vertical word processing. This is a common technique in Scrabble engines to reuse horizontal word-finding logic for vertical words.

```c
/*
 * transpose_board - Swap board rows and columns in-place
 *
 * @param board_offset: Offset to add to board calculations
 *
 * After transpose:
 *   board[row][col] becomes board[col][row]
 *
 * This allows the horizontal word finder to find vertical words
 * by transposing, finding, then transposing back.
 */
void transpose_board(long board_offset) {
    int row, col;                /* D6, D5: Loop counters */
    char* row_ptr;               /* A4: Current row pointer */
    char* col_ptr;               /* A2: Column traversal pointer */
    char temp;                   /* D4: Swap temporary */

    char* board_base = g_board_letters;  /* A3 */
    row_ptr = board_base;

    /* For each row */
    for (row = 0; row < BOARD_WIDTH; row++) {
        col_ptr = board_base;

        /* For each column (only need to swap upper triangle) */
        for (col = row + 1; col < BOARD_WIDTH; col++) {
            /* Calculate source position: board[row][col] */
            int src_offset = row * BOARD_WIDTH + col;

            /* Calculate dest position: board[col][row] */
            char* dest_ptr = col_ptr + board_offset;
            long dest_offset = col * BOARD_WIDTH + row;

            /* Swap the two cells */
            temp = board_base[src_offset];
            board_base[src_offset] = *dest_ptr;
            *dest_ptr = temp;

            col_ptr += BOARD_WIDTH;  /* Move to next column's row */
        }

        row_ptr += BOARD_WIDTH;  /* Move to next row */
    }
}
```

### File Format Summary

```c
/*
 * Maven Save File Format (.XGME)
 *
 * File header:
 *   Type:    'TEXT'
 *   Creator: 'XGME' (Maven)
 *
 * File structure:
 *   Series of 6-byte records:
 *     +0 (2 bytes): Record type
 *     +2 (2 bytes): Record length (sometimes)
 *     +4 (2 bytes): Data or handle reference
 *
 * Record types (uncertain - inferred):
 *   - Window position and state
 *   - Board letter array (289 bytes)
 *   - Board score array (578 bytes)
 *   - Multiplier arrays
 *   - Rack contents
 *   - Game settings
 *   - Move history
 */
```

### Board Symbol Legend

| Symbol | ASCII | Meaning | Detection Method |
|--------|-------|---------|------------------|
| A-Z | 0x41-0x5A | Placed tile (permanent) | Score != 0, not tentative |
| a-z | 0x61-0x7A | Tentative tile (being played) | Score == 0 or tentative flag |
| $ | 0x24 | Double Letter Score | letter_mult[pos] == 2 |
| * | 0x2A | Triple Letter Score | letter_mult[pos] == 3 |
| + | 0x2B | Double Word Score | word_mult[pos] == 2 |
| # | 0x23 | Triple Word Score | word_mult[pos] == 3 |
| - | 0x2D | Empty square | All multipliers == 1 |
