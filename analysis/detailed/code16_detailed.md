# CODE 16 Detailed Analysis - Statistics & Game History

## Overview

| Property | Value |
|----------|-------|
| Size | 1,894 bytes |
| JT Offset | 776 |
| JT Entries | 5 |
| Functions | 12 |
| Purpose | **Game statistics, history tracking, score formatting** |


## System Role

**Category**: Simulation
**Function**: Simulation Support

Supports Monte Carlo simulation (6 FP calls)
## Architecture Role

CODE 16 handles game statistics and history:
1. Track game history (moves, scores)
2. Format statistics for display
3. Scale scores for presentation
4. Generate statistical reports

## Key Functions

### Function 0x0000 - Copy Statistics Block
```asm
0000: LINK       A6,#0
0004: MOVEM.L    D7/A3/A4,-(SP)
0008: MOVEA.L    8(A6),A4             ; A4 = dest
000C: MOVEA.L    12(A6),A3            ; A3 = source
0010: MOVEQ      #0,D7                ; D7 = counter
0012: BRA.S      $001A

; Copy loop - 22 longs (88 bytes)
0014: MOVE.L     (A4)+,D0
0016: ADD.L      (A3)+,D0             ; Accumulate
0018: ADDQ.W     #1,D7

001A: CMPI.W     #22,D7
001E: BCS.S      $0014                ; Loop 22 times
0020: MOVEM.L    (SP)+,D7/A3/A4
0024: UNLK       A6
0026: RTS
```

**C equivalent**:
```c
void copy_stats_block(long* dest, long* source) {
    for (int i = 0; i < 22; i++) {
        dest[i] += source[i];
    }
}
```

### Function 0x0028 - Scale Statistics
```asm
0028: LINK       A6,#0
002C: MOVEM.L    D6/D7/A4,-(SP)
0030: MOVEA.L    8(A6),A4             ; A4 = stats block
0034: MOVE.L     16(A6),D7            ; D7 = scale factor

; Scale by 100, then by 2
0038: PEA        100                  ; divisor
003C: MOVE.L     D7,-(A7)             ; dividend
003E: JSR        66(A5)               ; JT[66] - divide
0042: MOVE.L     D0,D7                ; D7 = D7/100
0044: PEA        2
0048: MOVE.L     D7,-(A7)
004A: JSR        90(A5)               ; JT[90] - divide
004E: MOVE.L     D0,D6                ; D6 = D7/2

; Copy source to dest
0050: MOVEA.L    12(A6),A0            ; Source
0054: LEA        (A4),A1              ; Dest
0056: MOVEQ      #21,D0               ; 22 longs
0058: MOVE.L     (A0)+,(A1)+
005A: DBF        D0,$0058

; Scale fields at various offsets
; offset 4
0090: JSR        90(A5)               ; Divide by D7
0094: ADD.L      56(A4),D0
0098: LEA        4(A4),A0
009C: MOVE.L     D7,-(A7)
009E: MOVE.L     (A0),-(A7)
00A0: JSR        90(A5)
00A4: MOVE.L     D0,(A0)

; offset 8
00A6: LEA        8(A4),A1
00AA: MOVE.L     D7,-(A7)
00AC: MOVE.L     (A1),-(A7)
00AE: JSR        90(A5)
00B2: MOVE.L     D0,(A1)

; offset 12
00B4: LEA        12(A4),A0
...
; Continue for offsets 16, 20, 28, 32, 36, 40, 44, 48, 56
```

**Purpose**: Scales a 88-byte statistics block by a percentage factor.

### Function 0x0148 - Format Statistics Report
```asm
0148: LINK       A6,#-236             ; Large local frame
014C: MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)
0150: MOVEA.L    8(A6),A4             ; A4 = output buffer

; Get current player
0154: MOVEA.L    -8584(A5),A0         ; Window handle
0158: MOVEA.L    (A0),A0              ; Dereference
015A: MOVE.W     770(A0),D0           ; Current player
015E: MOVEA.L    A5,A0
0160: EXT.L      D0
0162: LSL.L      #3,D0                ; * 8
0166: MOVE.L     -6956(A0,D0.L),-(A7) ; Player data offset
016A: PEA        -6940(A5)            ; Format string
016E: MOVE.L     A4,-(A7)             ; Output buffer
0170: JSR        2066(A5)             ; JT[2066] - sprintf

; Get history handle
017A: JSR        974(PC)              ; Get history
017E: MOVEA.L    D0,A3                ; A3 = history ptr
0180: MOVE.L     A3,D0
0186: BEQ.W      $04E6                ; No history

; Clear counters
018A: CLR.L      -222(A6)             ; wins
018E: CLR.L      -208(A6)             ; losses
0192: CLR.L      -216(A6)             ; ties
0196: CLR.L      -212(A6)             ; games
019A: MOVEQ      #0,D6
019C: MOVE.L     D6,D5
019E: MOVEQ      #0,D4

; Get entry count
01A0: MOVE.L     (A3),D7              ; D7 = count
01A2: MOVEA.L    -8584(A5),A0
01A6: MOVEA.L    (A0),A0
01A8: MOVE.W     770(A0),-218(A6)     ; Store player

; Loop through entries
01B0: MOVE.L     D4,D0
01B2: EXT.L      D0
01B4: LSL.L      #3,D0                ; * 8
01B8: MOVEA.L    A2,A0
01B6: BRA.S      $021A

; Check entry for current player
01B8: MOVE.W     6(A2,D7.L),D0        ; Entry player
01BC: CMP.W      -218(A6),D0          ; Match current?
01C0: BNE.S      $0216                ; Skip if not

; Accumulate statistics
01C4: MOVEA.L    A2,A0
01C8: ADD.L      (A3),$3610.W         ; Add to total
01CC: MOVEA.L    A2,A0
01CE: ADD.L      (A3),$2D48.W
01D2: MOVE.W     4(A4),D0
01D4: EXT.L      D0
01D8: ADD.L      -216(A6),D0          ; Add to ties
...
; Continue accumulating
0216: ADDQ.W     #1,D4
0218: ADDQ.L     #8,A2                ; Next entry
021A: MOVEA.W    D4,A0
021C: CMP.L      -4(A6),A0            ; Check count
0220: BLT.S      $01B8                ; Loop

; Calculate percentages
0230: PEA        2                    ; Divide by 2
0234: MOVE.L     D3,-(A7)
0236: JSR        90(A5)
023A: MOVE.L     D0,D4
...
; Format output strings
02B0: PEA        -15514(A5)           ; g_field_14
02B4: MOVE.L     A4,-(A7)
02B6: JSR        2066(A5)             ; sprintf

; Format various statistics
032E: PEA        -6826(A5)            ; Format string
0330: MOVE.L     A4,-(A7)
0334: JSR        2066(A5)             ; sprintf
...
; Multiple sprintf calls for different stats
```

### Function 0x054A - Get History Resource
```asm
054A: LINK       A6,#0
054E: MOVE.L     A4,-(A7)
0550: CLR.L      -(A7)                ; NULL
0552: MOVE.L     #'HIST',-(A7)        ; Resource type 'HIST'
0558: CLR.W      -(A7)                ; ID 0
055A: A9A0                            ; GetResource trap
055E: MOVEA.L    (A7)+,A4             ; A4 = handle
0560: MOVE.L     A4,D0
0562: BEQ.S      $0574                ; Not found

0562: CLR.L      -(A7)
0564: MOVE.L     A4,-(A7)
0566: JSR        2826(A5)             ; GetHandleSize
056A: MOVE.L     (A7)+,D0
056C: LSR.L      #3,D0                ; / 8
056E: MOVEA.L    8(A6),A0
0572: MOVE.L     D0,(A0)              ; Store count

0574: MOVE.L     A4,D0                ; Return handle
0578: UNLK       A6
057A: RTS
```

**C equivalent**:
```c
Handle get_history(long* count_out) {
    Handle h = GetResource('HIST', 0);
    if (h != NULL) {
        long size = GetHandleSize(h);
        *count_out = size / 8;  // 8 bytes per entry
    }
    return h;
}
```

### Function 0x06F0 - Generate Full Report
```asm
06F0: LINK       A6,#-16384           ; 16KB local buffer!
06F4: MOVE.L     D7,-(A7)
06F6: PEA        -16384(A6)           ; Buffer
06FA: JSR        -1460(PC)            ; Format stats
06FE: MOVE.L     D0,D7                ; D7 = length

0700: PEA        -16384(A6)           ; Buffer
0704: MOVE.L     D7,-(A7)             ; Length
0706: MOVEA.L    -8580(A5),A0         ; Window
070A: MOVE.L     160(A0),-(A7)        ; Get TE handle
070E: A9CF                            ; TESetText trap
0710: MOVE.L     -8580(A5),(A7)
0714: JSR        1890(A5)             ; JT[1890] - update
0718: MOVE.L     -8580(A5),(A7)
071C: JSR        1874(A5)             ; JT[1874] - redraw
0720: CLR.W      (A7)                 ; Push 0
0722: JSR        -424(PC)             ; Another function
072C: RTS
```

**Purpose**: Generates a full statistics report and displays in a TextEdit field.

## Statistics Block Structure (88 bytes)

| Offset | Size | Purpose |
|--------|------|---------|
| 0 | 4 | Total games |
| 4 | 4 | Wins |
| 8 | 4 | Losses |
| 12 | 4 | Ties |
| 16 | 4 | Total points scored |
| 20 | 4 | Total points against |
| 24-84 | - | Various accumulated stats |

## History Entry Structure (8 bytes)

| Offset | Size | Purpose |
|--------|------|---------|
| 0 | 4 | Score/data |
| 4 | 2 | Flags |
| 6 | 2 | Player ID |

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-6826 | Format string |
| A5-6940 | Player format string |
| A5-8580 | Statistics window |
| A5-8584 | Main window handle |
| A5-15514 | g_field_14 |

## Toolbox Traps

| Trap | Purpose |
|------|---------|
| A9A0 | GetResource |
| A9CF | TESetText |

## Speculative C Translation

### Header Definitions
```c
/* CODE 16 - Statistics & Game History
 * Game statistics tracking, history management, score formatting.
 */

#include <MacTypes.h>
#include <Resources.h>
#include <TextEdit.h>

/*========== Constants ==========*/
#define STATS_BLOCK_LONGS       22      /* 22 longs = 88 bytes */
#define STATS_BLOCK_SIZE        88      /* Bytes per stats block */
#define HISTORY_ENTRY_SIZE      8       /* Bytes per history entry */
#define REPORT_BUFFER_SIZE      16384   /* 16KB report buffer */

/*========== Data Structures ==========*/

/* Statistics block (88 bytes, 22 longs) */
typedef struct StatsBlock {
    long total_games;           /* Offset 0: Total games played */
    long wins;                  /* Offset 4: Games won */
    long losses;                /* Offset 8: Games lost */
    long ties;                  /* Offset 12: Games tied */
    long total_scored;          /* Offset 16: Total points scored */
    long total_against;         /* Offset 20: Total points against */
    long field_24;              /* Offset 24: Additional stat */
    long field_28;              /* Offset 28: Additional stat */
    long field_32;              /* Offset 32: Additional stat */
    long field_36;              /* Offset 36: Additional stat */
    long field_40;              /* Offset 40: Additional stat */
    long field_44;              /* Offset 44: Additional stat */
    long field_48;              /* Offset 48: Additional stat */
    long reserved[9];           /* Remaining fields to 88 bytes */
} StatsBlock;

/* History entry (8 bytes each) */
typedef struct HistoryEntry {
    long score_data;            /* Offset 0: Score or data value */
    short flags;                /* Offset 4: Entry flags */
    short player_id;            /* Offset 6: Player identifier */
} HistoryEntry;

/*========== Global Variables (A5-relative) ==========*/
extern Handle   g_main_window_handle;   /* A5-8584: Main window handle */
extern WindowPtr g_stats_window;        /* A5-8580: Statistics window */
extern char     g_format_string[];      /* A5-6940: Player format string */
extern char     g_field_14[];           /* A5-15514: General buffer */
```

### Statistics Block Operations
```c
/*
 * accumulate_stats_block - Add source stats to destination
 *
 * Adds all 22 long values from source to destination.
 *
 * @param dest: Destination statistics block
 * @param source: Source statistics block
 */
void accumulate_stats_block(StatsBlock* dest, StatsBlock* source) {
    long* dest_ptr = (long*)dest;
    long* src_ptr = (long*)source;

    for (int i = 0; i < STATS_BLOCK_LONGS; i++) {
        dest_ptr[i] += src_ptr[i];
    }
}

/*
 * scale_stats_block - Scale statistics by percentage
 *
 * Copies source to dest, then scales certain fields
 * by the provided factor (divided by 100, then by 2).
 *
 * @param dest: Destination statistics block
 * @param source: Source statistics block to scale
 * @param scale_factor: Percentage scale factor
 */
void scale_stats_block(StatsBlock* dest, StatsBlock* source, long scale_factor) {
    long adjusted_factor;
    long half_factor;

    /* Calculate scale factors */
    adjusted_factor = scale_factor / 100;       /* JT[66] divide */
    half_factor = adjusted_factor / 2;          /* JT[90] divide */

    /* Copy source to destination */
    memcpy(dest, source, STATS_BLOCK_SIZE);

    /* Scale specific fields */
    dest->wins = dest->wins / adjusted_factor;
    dest->losses = dest->losses / adjusted_factor;
    dest->ties = dest->ties / adjusted_factor;
    dest->total_scored = dest->total_scored / adjusted_factor;
    dest->total_against = dest->total_against / adjusted_factor;

    /* Continue scaling remaining fields... */
    /* uncertain: exact fields scaled */
}
```

### History Resource Access
```c
/*
 * get_history_resource - Load game history from resource
 *
 * Loads 'HIST' resource and returns count of entries.
 * Each entry is 8 bytes.
 *
 * @param count_out: Output - number of history entries
 * @return: Handle to history data, NULL if not found
 */
Handle get_history_resource(long* count_out) {
    Handle history_handle;
    long handle_size;

    /* Load 'HIST' resource ID 0 */
    history_handle = GetResource('HIST', 0);

    if (history_handle != NULL) {
        /* Calculate entry count from handle size */
        handle_size = GetHandleSize(history_handle);    /* JT[2826] */
        *count_out = handle_size / HISTORY_ENTRY_SIZE;  /* >> 3 */
    }
    else {
        *count_out = 0;
    }

    return history_handle;
}
```

### Statistics Report Generation
```c
/*
 * format_statistics_report - Generate statistics report text
 *
 * Processes game history and formats comprehensive statistics
 * report for display.
 *
 * @param output_buffer: Buffer to receive formatted text
 * @return: Length of generated text
 */
long format_statistics_report(char* output_buffer) {
    Handle history_handle;
    HistoryEntry* history_ptr;
    long entry_count;
    long wins = 0, losses = 0, ties = 0, games = 0;
    short current_player;

    /* Get current player from window data */
    WindowData** wh = (WindowData**)g_main_window_handle;
    WindowData* w = *wh;
    current_player = w->current_player;         /* Offset 770 */

    /* Format player header */
    /* uncertain: exact format string location */
    sprintf(output_buffer, g_format_string,
            /* player name at A5-6956 indexed by player */ );

    /* Load history resource */
    history_handle = get_history_resource(&entry_count);

    if (history_handle == NULL) {
        return strlen(output_buffer);
    }

    /* Lock and process history */
    HLock(history_handle);
    history_ptr = (HistoryEntry*)*history_handle;

    /* Accumulate statistics for current player */
    for (long i = 0; i < entry_count; i++) {
        HistoryEntry* entry = &history_ptr[i];

        /* Check if entry is for current player */
        if (entry->player_id == current_player) {
            games++;

            /* Accumulate based on flags */
            /* uncertain: exact flag interpretation */
            if (entry->flags & /* win flag */) {
                wins++;
            }
            else if (entry->flags & /* loss flag */) {
                losses++;
            }
            else {
                ties++;
            }

            /* Accumulate score totals */
            /* uncertain: how score_data is used */
        }
    }

    HUnlock(history_handle);

    /* Calculate percentages */
    long win_percent = (games > 0) ? (wins * 100 / games) : 0;
    long loss_percent = (games > 0) ? (losses * 100 / games) : 0;

    /* Format statistics */
    char* ptr = output_buffer + strlen(output_buffer);

    sprintf(ptr, "Games: %ld\nWins: %ld (%ld%%)\nLosses: %ld (%ld%%)\nTies: %ld\n",
            games, wins, win_percent, losses, loss_percent, ties);

    /* uncertain: additional statistics formatting */

    return strlen(output_buffer);
}
```

### Report Display
```c
/*
 * generate_and_display_report - Create and show full report
 *
 * Generates statistics report and displays in TextEdit field.
 * Uses 16KB local buffer for report text.
 */
void generate_and_display_report(void) {
    char report_buffer[REPORT_BUFFER_SIZE];     /* 16KB stack frame! */
    long report_length;
    TEHandle te_handle;

    /* Generate report */
    report_length = format_statistics_report(report_buffer);

    /* Get TextEdit handle from stats window */
    te_handle = (TEHandle)((char*)g_stats_window + 160);    /* TE at offset 160 */

    /* Set text in TextEdit record */
    TESetText(report_buffer, report_length, te_handle);

    /* Update display */
    update_stats_window();      /* JT[1890] */
    redraw_stats_window();      /* JT[1874] */

    /* Additional processing */
    additional_report_func(0);  /* PC-relative */
}
```

### Percentage Calculation
```c
/*
 * calculate_percentage - Compute percentage with rounding
 *
 * @param numerator: Value to calculate percentage of
 * @param denominator: Total value (100%)
 * @return: Percentage (0-100)
 */
short calculate_percentage(long numerator, long denominator) {
    if (denominator == 0) {
        return 0;
    }

    /* Multiply by 100 first for precision */
    long scaled = numerator * 100;

    /* Add half denominator for rounding */
    scaled += denominator / 2;

    /* Divide */
    return (short)(scaled / denominator);
}
```

## Confidence: HIGH

Clear statistics tracking:
- History resource loading ('HIST')
- Accumulation of wins/losses/ties
- Percentage calculations
- Text formatting for display
