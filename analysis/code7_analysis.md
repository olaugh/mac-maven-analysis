# CODE 7 Analysis: Board and Rack State Management

## Overview

| Property | Value |
|----------|-------|
| Size | 2872 bytes |
| JT Offset | 224 |
| JT Entries | 13 |
| Functions | ~21 |
| Categories | DAWG_ACCESS, DIALOGS, MEMORY |

## Purpose (Speculative)

CODE 7 appears to manage **board state and rack letters** for the Scrabble game. It:
- Maintains two parallel data structures (horizontal/vertical board views?)
- Copies data between board state and DAWG lookup structures
- Handles 17x17 grid operations (standard Scrabble = 15x15 + 1 for boundaries?)

## Key Global Variables Used

| Offset | Name | Purpose |
|--------|------|---------|
| A5-15514 | g_field_14 | Primary board/rack buffer (8 bytes) |
| A5-15522 | g_field_22 | Secondary board/rack buffer (8 bytes) |
| A5-15498 | g_current_ptr | Pointer to current active buffer |
| A5-15506 | g_size1 | DAWG section 1 size (56630) |
| A5-15502 | g_size2 | DAWG section 2 size (65536) |
| A5-17154 | g_state1 | State buffer 1 (272 bytes = 0x110) |
| A5-16610 | g_state2 | State buffer 2 (1088 bytes = 0x440) |
| A5-16882 | unknown | Used in board iteration |
| A5-10464 | g_state3 | Game state structure (74 bytes) |
| A5-8510 | g_window_ptr | Window/document pointer |
| A5-8604 | g_game_mode | Game mode flag |
| A5-8602 | g_mode_check | Mode comparison value |

## Function Analysis

### Function 0x0000: Initialize Board State
```c
void init_board_state(short param) {
    // Call init via PC-relative jump
    init_func(param);  // JSR 1410(PC)

    // Set up field_14 pointer
    g_current_ptr = &g_field_14;  // A5-15498 = &A5-15514

    // Set game mode based on buffer contents
    if (*g_field_14 != 0) {
        g_game_mode = 8;  // A5-8604
    } else {
        g_game_mode = 0;
    }

    // Initialize via jump table
    call_via_jt(1034);  // JT[1034]
    call_via_jt(1258);  // JT[1258]
    call_via_jt(1362);  // JT[1362]
    call_via_jt(658);   // JT[658]
}
```

### Function 0x0038: Main Board Setup (Large, Complex)
```c
// Parameters: pointer, short, short
// Large function handling different board setup modes

void setup_board(void *param, short mode, short value) {
    // Save D3-D7, A2-A4

    if (mode == 0) {
        // Initialize state buffers
        memset(g_state1, 0, 0x110);  // 272 bytes via JSR 426(A5)
        memset(g_state2, 0, 0x440);  // 1088 bytes

        // Copy board data to global fields
        copy_to_global(param+6, g_field_14);   // JSR 3490(A5)
        copy_to_global(param+14, g_field_22);

        // Select which buffer to use based on param->field_2
        if (param->field_2 != 0) {
            g_current_ptr = &g_field_14;
        } else {
            g_current_ptr = &g_field_22;
        }

        // Clear size globals
        g_size1 = 0;  // A5-15506
        g_size2 = 0;  // A5-15502
    }
    else if (mode > 0) {
        // Different initialization path
        // Uses 17x17 and 34-byte structures

        // 17 columns (0x11)
        // 32 rows (0x20)
        // Entry size appears to be 34 bytes (0x22)
    }
    // ... more modes
}
```

### Function 0x02EA: Copy Board State to Output
```c
void copy_board_to_output(void *output) {
    // Initialize state1 from output
    init_state_from(output, g_state1, 0x110);  // JSR 1658(A5)

    // Copy field values back
    copy_from_global(g_field_14, output+272);
    copy_from_global(g_field_22, output+280);

    // Store size values
    output->field_288 = g_size2;  // A5-15502
    output->field_292 = g_size1;  // A5-15506

    // Clear marker bytes
    output->field_296 = 0;
    output->field_297 = 0;
    output->field_298 = 0;
    output->field_299 = 0;

    // Iterate through 16x17 grid
    // Inner loop: 17 iterations (columns)
    // Outer loop: 16 iterations (rows?)
}
```

### Function 0x03A0: Calculate Score/Evaluate
```c
// Frame: 130 bytes
// Uses g_field_14, g_field_22, size globals

void calculate_score() {
    // Get values from both buffers via JSR 2122(A5)
    short val1 = get_value(g_field_14);
    short val2 = get_value(g_field_22);

    // Complex calculation involving size1, size2
    // Appears to compute board evaluation

    if (g_field_22[0] == 0) {
        // Use val1
    } else if (g_field_14[0] == 0) {
        // Use val2
    } else {
        // Negate and swap values
        val1 = -val1;
        val2 = -val2;
    }

    // Add to global accumulators
    // Multiple A5-23xxx references suggest DAWG data access
}
```

### Function 0x048E: Load/Save Game State
```c
void load_save_state(void *param, short mode) {
    if (mode < 0) {
        return;
    }

    switch (mode) {
        case 0:  // Reset
            g_field_22[0] = 0;
            g_field_14[0] = 0;
            g_current_ptr = 0;
            call_via_jt(1258);  // Reinitialize
            call_via_jt(1362);
            break;

        case 1:  // Load from param
            copy_to_global(param+36, g_field_14);
            copy_to_global(param+44, g_field_22);

            if (param->field_34 == 0) {
                // Swap size values
                temp = g_size1;
                g_size1 = g_size2;
                g_size2 = temp;
            }

            g_current_ptr = &g_field_14;
            call_via_jt(1258);
            call_via_jt(1362);
            break;
    }
}
```

### Function 0x09B2: Load Game (XGME format)
```c
void load_game_xgme() {
    char buffer[74];

    memset(buffer, 0, 74);  // JSR 426(A5)

    // Set magic number
    *(long*)(buffer-16) = 'XGME';  // 0x58474D45

    // Try to load file with type 'XGME'
    load_file_type(buffer, 1);  // JSR 1554(A5)

    if (buffer[0] != 0) {
        // Load succeeded
        open_file(buffer+16, buffer[20]);  // JSR 1450(A5)

        // Copy to g_state3
        memcpy(g_state3, buffer, 74);  // 18 longs + 1 word

        call_via_jt(1402);  // Initialize from loaded data
        g_game_mode = 8;
    }
}
```

## Data Structure Insights

### Board State Structure (272 bytes = 0x110)
```c
// g_state1 at A5-17154
// Appears to be 16 rows × 17 columns = 272 cells
// Each cell = 1 byte (letter or empty)
```

### Extended Board Structure (1088 bytes = 0x440)
```c
// g_state2 at A5-16610
// 1088 = 32 × 34 bytes
// 34-byte entries contain:
//   - Position info
//   - Cross-word data
//   - Score multipliers?
```

### Game State Structure (74 bytes)
```c
// g_state3 at A5-10464
typedef struct GameState {
    char header[16];      // File header
    short file_ref;       // at offset 20
    char data[56];        // Game data
    short flags;          // at offset 72
} GameState;
```

## Jump Table Calls

| Offset | Calls | Purpose |
|--------|-------|---------|
| 74(A5) | 3 | Get size/count |
| 418(A5) | 1 | Error check/alert |
| 426(A5) | 7 | memset/clear buffer |
| 658(A5) | 1 | Initialize subsystem |
| 1034(A5) | 1 | Init function |
| 1258(A5) | 3 | Reinit/refresh |
| 1362(A5) | 4 | Update state |
| 1658(A5) | 2 | Copy state |
| 2122(A5) | 2 | Get value from buffer |
| 2370(A5) | 1 | Process state |
| 2410(A5) | 1 | Setup function |
| 2826(A5) | 3 | Window/resource call |
| 3178(A5) | 3 | Dialog/menu check |
| 3186(A5) | 3 | Display message |
| 3490(A5) | 16 | Copy to/from global |

## Key Observations

1. **Two Parallel Buffers**: g_field_14 and g_field_22 seem to represent horizontal and vertical word directions
2. **Board Size**: 17×17 iterations suggest boundary padding around 15×15 Scrabble board
3. **34-byte Structures**: Match the 34-byte entry size seen in CODE 3 - likely search state
4. **XGME Format**: Custom game save format with magic number 0x58474D45
5. **State Management**: Complex state copying between local buffers and global variables
6. **No Direct DAWG Access**: Uses g_size1/g_size2 but doesn't access raw DAWG entries

## Confidence Levels

| Aspect | Confidence |
|--------|------------|
| Function boundaries | HIGH |
| Board buffer purpose | MEDIUM |
| Data structure sizes | MEDIUM |
| Loop counts (17, 16, 32) | HIGH |
| Variable purposes | LOW-MEDIUM |
| File format (XGME) | MEDIUM |
