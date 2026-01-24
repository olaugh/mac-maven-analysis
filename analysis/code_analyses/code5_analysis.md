# CODE 5 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 204 bytes |
| JT Offset | 160 |
| JT Entries | 1 |
| Functions | 1 |
| Categories | DAWG_ACCESS, LEXICON_INIT |
| Purpose | **Dictionary Initialization / Lexicon Mode Setup** |
| Confidence | HIGH |

## Menu Context

This code is called when initializing the dictionary system, typically during:
- Application startup
- "New Game" from File menu (Menu ID 129, Item 1)
- Lexicon menu selection (Menu ID 131)

Sets the lexicon mode variable (A5-8604) based on which dictionary is being loaded.

## Functions

Entry points at: 0x0000

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-15522 | g_field_22 | Board buffer 2 (hook-after) |
| A5-15514 | g_field_14 | Board buffer 1 (hook-before) |
| A5-15506 | g_size1 | DAWG section 1 size (56630) |
| A5-15502 | g_size2 | DAWG section 2 size (65536) |
| A5-15498 | g_current_ptr | Current active buffer pointer |
| A5-10388 | g_lookup_tbl | Lookup table |
| A5-8604 | g_lexicon_mode | **Lexicon mode: 1=NA/TWL, 2=UK/OSW, 3=Both/SOWPODS** |

Also references 2 unknown A5-relative globals.

## Lexicon Mode Logic (from disassembly)

```
0x0076: BEQ.S    $009A           ; Branch based on dictionary type
0x0078: LEA      -15514(A5),A0   ; g_field_14 = dictionary 1
0x007C: MOVE.L   A0,-15498(A5)   ; Set as active dictionary
...
0x0090: MOVE.W   #$0003,-8604(A5) ; Set mode = 3 (SOWPODS/Both)

0x009A: LEA      -15522(A5),A0   ; g_field_22 = dictionary 2
0x009E: MOVE.L   A0,-15498(A5)   ; Set as active dictionary
...
0x00B2: MOVE.W   #$0002,-8604(A5) ; Set mode = 2 (OSW/UK)
```

**Decision Logic**:
- If condition at 0x0076 is true → Use g_field_14, set mode=3 (Both/SOWPODS)
- If condition is false → Use g_field_22, set mode=2 (UK/OSW)

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 298(A5) | unknown |
| 658(A5) | init_subsystem |
| 1018(A5) | unknown |
| 1258(A5) | post-search init |
| 1354(A5) | unknown |
| 1362(A5) | state_update |
| 1418(A5) | unknown |
| 2402(A5) | buffer function |
| 3466(A5) | unknown |
| 3490(A5) | copy to/from global |

## Analysis Notes

- **DAWG-related**: Uses 4 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)
- No direct Toolbox calls - may be pure computation or use jump table exclusively

## Refined Analysis (Second Pass)

**Cluster**: Dawg Support

**Category**: CORE_AI, LEXICON_CONTROL

**Global Variable Profile**: 5 DAWG, 1 UI, 9 total

**Calls functions in**: CODE 7, 14, 20, 21, 22, 32, 52

**Assessment**: Dictionary initialization - sets active dictionary pointer and lexicon mode

## Speculative C Translation

```c
// CODE 5: Dictionary initialization
int init_dictionary(void* dict1_data, void* dict2_data,
                    uint32_t size1, uint32_t size2,
                    int use_combined) {
    // Validate and load dictionaries
    if (!validate_dictionary(dict1_data, dict2_data)) {
        if (!show_dialog(0x03FF)) {  // Error dialog
            return 0;
        }
    }

    init_subsystem();
    copy_to_global(dict1_data, &g_field_14);  // A5-15514
    copy_to_global(dict2_data, &g_field_22);  // A5-15522
    state_update();

    g_size2 = size1;  // A5-15502
    g_size1 = size2;  // A5-15506

    post_search_init();
    unknown_1018();
    memset(g_lookup_tbl, 0, 0x121);

    if (use_combined) {
        // Use combined dictionary (SOWPODS)
        g_current_ptr = &g_field_14;   // A5-15498
        buffer_function(&g_field_14);
        buffer_function(&g_field_22);
        g_lexicon_mode = 3;            // Both N.A. and U.K.
    } else {
        // Use OSW dictionary only
        g_current_ptr = &g_field_22;
        buffer_function(&g_field_22);
        buffer_function(&g_field_14);
        g_lexicon_mode = 2;            // United Kingdom
    }

    state_update();
    unknown_298();
    g_simulation_state = 0;  // A5-9810
    return 1;
}
```
