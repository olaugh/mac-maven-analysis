# CODE 11 Analysis: Main Event Loop / Game Controller

## Overview

| Property | Value |
|----------|-------|
| Size | 4,478 bytes |
| JT Offset | 376 |
| JT Entries | 19 |
| Functions | ~31 |
| Categories | DAWG_ACCESS, UI_DRAWING, DIALOGS, FILE_IO, MEMORY, EVENTS, MENUS |

## Purpose (Speculative)

CODE 11 appears to be the **main game controller** that:
- Manages game state transitions
- Coordinates between DAWG search and UI
- Handles file operations (save/load)
- Controls the AI search process
- Copies data between DAWG structures and board state

## Key Global Variables Used

### DAWG Data
| Offset | Name | Code Lines | Purpose |
|--------|------|------------|---------|
| A5-23090 | g_dawg_info | many | 34-byte DAWG info structure |
| A5-23074 | g_dawg_ptr | 0F72, 0F84, 1038 | Main DAWG data pointer |
| A5-15506 | g_size1 | 0EC4, 103C, 1044, 10C0 | Size 56630 |
| A5-15502 | g_size2 | 0EC0, 0F6E, 0F88, 10C4 | Size 65536 |

### Board/Rack State
| Offset | Name | Purpose |
|--------|------|---------|
| A5-15514 | g_field_14 | Primary board buffer |
| A5-15522 | g_field_22 | Secondary board buffer |
| A5-15498 | g_current_ptr | Pointer to active buffer |

### Game State
| Offset | Name | Purpose |
|--------|------|---------|
| A5-8604 | g_game_mode | Game mode/state |
| A5-8602 | g_mode_check | Mode comparison value |
| A5-8510 | g_window_ptr | Window pointer |
| A5-19474 | g_some_ptr | Temporary pointer |
| A5-23670 | g_another_ptr | Another pointer |

### Data Areas
| Offset | Size | Purpose |
|--------|------|---------|
| A5-27912 | ? | Default return value |
| A5-27896 | ? | Alternative return |
| A5-27800 | ? | Data table base |
| A5-23400 | 88 | Buffer 1 |
| A5-23312 | 88 | Buffer 2 |
| A5-23488 | ? | Buffer 3 |
| A5-22706 | 8 | Small buffer |

## Key Functions

### Function 0x0000: Get Data Pointer
```c
void* get_data_ptr(void *param) {
    if (param == NULL) {
        return &g_default_data;  // A5-27912
    }

    if (check_something(param)) {  // JSR 1610(A5)
        return &g_alt_data;  // A5-27896
    }

    if (param->field_108 >= 8) {
        if ((param->field_109 & 1) && check_mode(param)) {
            return param->field_152;  // offset 0x98
        }
    }
    return &g_alt_data;
}
```

### Function 0x00A0: Iterate Data List
```c
// Iterates through a linked list structure
// param->field_2 = count
// param->field_4 = next pointer
// Entries are 8 bytes each

void* find_in_list(void *list, long target) {
    while (list != NULL) {
        short count = list->field_2;
        for (int i = 1; i <= count; i++) {
            Entry *entry = list + 8 + (i * entry_size);
            if (entry->value == target) {
                return entry->data;  // offset 4
            }
        }
        list = list->next;  // offset 4
    }
    return NULL;
}
```

### Function 0x0EB6+: Initialize New Game
```c
void init_new_game() {
    // Clear DAWG size globals
    g_size2 = 0;  // A5-15502
    g_size1 = 0;  // A5-15506

    // Clear board buffers
    g_field_14[0] = 0;
    g_field_22[0] = 0;
    g_some_flag = 0;  // A5-19470

    // Initialize state
    call_jt(1258);  // Init function
    call_jt(234);   // Another init

    // Initialize both board buffers
    init_buffer(g_field_22);  // JSR 1410(A5)
    init_buffer(g_field_14);  // JSR 1410(A5)

    // Update state
    call_jt(1362);  // State update

    // Initialize cursor
    InitCursor();  // A850 trap

    call_jt(290);   // More init
}
```

### Function 0x0F34+: Load DAWG Data
```c
void load_dawg_data() {
    // Store some value
    g_field = *0x016A;  // A5-8614

    // Clear and init 34-byte DAWG info structure
    memset(g_dawg_info, 0, 0x22);  // 34 bytes

    // Clear 8-byte buffer
    memset(&A5_22706, 0, 8);

    // ... complex DAWG initialization
}
```

### Function 0x0F5A+: Setup Search
```c
void setup_search() {
    // Set pointer to data area
    g_some_ptr = &A5_370;

    // Initialize search state
    setup_buffer(g_current_ptr);  // JSR 2410(A5)
    setup_more();  // JSR 2434(A5)

    // Calculate offset: g_size2 + g_dawg_ptr
    long offset = g_size2 + g_dawg_ptr;

    // Initialize DAWG info structure
    init_dawg_info(g_dawg_info, offset, &A5_8490);

    // Copy more data
    copy_data(g_dawg_ptr + g_size2, ...);

    // Setup search parameters
    setup_params(1, g_current_ptr, g_dawg_info);  // JSR 2370(A5)

    // Copy buffers
    copy_buffers(&A5_23400, &A5_23488);  // JSR 842(A5)

    // Finalize
    g_some_ptr = 0;
    finalize_buffer(g_current_ptr);  // JSR 1410(A5)
    update_state();  // JSR 1362(A5)

    // Set g_field_22 as current
    g_current_ptr = &g_field_22;
    init_subsystem();  // JSR 658(A5)

    // Process with DAWG info
    process_dawg(0, g_dawg_info);  // JSR 362(A5)
    result = check_result();  // JSR 2346(A5)

    // Set game mode based on result
    g_game_mode = result ? 4 : 2;
}
```

### Function 0x0FFA+: Alternative Search Setup
```c
void alt_search_setup() {
    // Check if g_field_22 == g_current_ptr
    if (g_current_ptr == &g_field_22) {
        call_local_func();  // JSR 350(PC)
    }

    // Set another pointer
    g_another_ptr = &A5_458;

    call_another();  // JSR -984(PC)
    g_game_mode = 0;  // Clear mode

    // Get 120 bytes from current buffer
    void *data = get_data(g_current_ptr, 0x78);  // JSR 650(A5)

    // Copy 34 bytes to DAWG info (8 longs + 1 word)
    memcpy(g_dawg_info, data, 34);

    // Clear pointer
    g_another_ptr = 0;

    // Calculate: g_dawg_ptr + g_size1
    long offset = g_dawg_ptr + g_size1;

    // Continue processing
    init_dawg_info(g_dawg_info, offset, &A5_8464);

    // Setup search with parameters
    setup_params(1, g_current_ptr, g_dawg_info);

    // Copy buffers
    copy_buffers(&A5_23312, &A5_23488);

    // Switch to g_field_14
    finalize_buffer(g_current_ptr);
    g_current_ptr = &g_field_14;
    init_subsystem();

    // Process DAWG
    process_dawg(0x00010001, g_dawg_info);
    result = check_result();

    g_game_mode = result ? 4 : 3;
}
```

### Function 0x10AA+: End Game Processing
```c
void end_game() {
    call_jt(346);  // Finalize

    g_current_ptr = 0;  // Clear buffer pointer
    g_game_mode = 5;    // End game mode

    if (check_something()) {  // JSR 282(A5)
        // Push DAWG sizes and call final function
        final_call(g_size1, g_size2);  // JSR 3578(A5)
    }

    // Clear window
    clear_window(0, g_window_ptr);  // JSR 1218(A5)
}
```

## State Machine

Based on the code, g_game_mode appears to control game states:

| Value | State |
|-------|-------|
| 0 | Idle/Processing |
| 1 | ? |
| 2 | Player's turn (using g_field_22) |
| 3 | Player's turn (using g_field_14) |
| 4 | AI thinking |
| 5 | End game |
| 8 | Loaded game |

## Data Flow

1. **New Game**: Clears all DAWG globals and board buffers
2. **Load DAWG**: Copies 34-byte header to g_dawg_info
3. **Search Setup**: Uses g_dawg_ptr + g_size1 or g_size2 for offset calculation
4. **State Switch**: Alternates between g_field_14 and g_field_22

## Key Observations

1. **Two Buffer System**: Like CODE 7, uses g_field_14 and g_field_22 alternately
2. **34-byte Structure**: Copies DAWG info as 8 longs + 1 word = 34 bytes
3. **DAWG Offset Calculation**: Uses `g_dawg_ptr + g_size1` or `g_dawg_ptr + g_size2`
4. **State Machine**: g_game_mode controls flow between game states
5. **Heavy Jump Table Usage**: Many calls via JSR d(A5) for modularity

## Confidence Levels

| Aspect | Confidence |
|--------|------------|
| Function boundaries | HIGH |
| Global variable identification | MEDIUM |
| State machine values | LOW |
| Data structure copying | HIGH |
| Control flow | MEDIUM |
