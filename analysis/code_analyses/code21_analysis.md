# CODE 21 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 13718 bytes |
| JT Offset | 1064 |
| JT Entries | 39 |
| Functions | 53 |
| Categories | DAWG_ACCESS, EVENT_LOOP, MENU_HANDLER |
| Purpose | **Main Event Loop / Menu Handler / Game UI** |
| Confidence | HIGH |

## Menu Context

This is the **main event loop** and primary menu handler:
- Processes all menu selections (File, Edit, Lexicon)
- References Menu IDs: 0x81 (File), 0x82 (Edit), 0x83 (Lexicon), 0x84 (unknown)
- Updates menu enable/disable states based on game state
- Dispatches to other CODE resources for specific actions

## Functions

Entry points at: 0x0000, 0x004E, 0x00F8, 0x045A, 0x04A8, 0x0594, 0x05C6, 0x05FA, 0x0682, 0x0922, 0x0B24, 0x0BE6, 0x0C16, 0x0D20, 0x130C, 0x133A, 0x13F8, 0x142A, 0x147C, 0x1496
... and 33 more

## Toolbox Traps Used

| Trap | Name |
|------|------|
| $A873 | _EqualPt |

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-23090 | g_dawg_info | 34-byte DAWG info structure |
| A5-15522 | g_field_22 | Board buffer 2 (hook-after) |
| A5-15514 | g_field_14 | Board buffer 1 (hook-before) |
| A5-15506 | g_size1 | DAWG section 1 size (56630) |
| A5-15502 | g_size2 | DAWG section 2 size (65536) |
| A5-15498 | g_current_ptr | Current active buffer pointer |
| A5-10388 | g_lookup_tbl | Lookup table |
| A5-8604 | g_lexicon_mode | Lexicon mode for dictionary selection |
| A5-8584 | g_handle | Handle to data structure |
| A5-8510 | g_window_ptr | Main window pointer |
| A5-9810 | g_simulation_state | Simulation/game state |
| A5-4174 | g_menu_str_1 | Menu comparison string 1 |
| A5-4166 | g_menu_str_2 | Menu comparison string 2 |
| A5-4158 | g_menu_str_3 | Menu comparison string 3 |
| A5-4150 | g_menu_str_4 | Menu comparison string 4 |
| A5-4142 | g_menu_str_5 | Menu comparison string 5 |

Also references 85 unknown A5-relative globals.

## Menu ID References

| Offset | Instruction | Menu | Purpose |
|--------|-------------|------|---------|
| 0x1480 | CMPI.W #$0081,12(A6) | File | Check if File menu selected |
| 0x19E0 | MOVE.W #$0082,-(A7) | Edit | Update Edit menu state |
| 0x1A02 | MOVE.W #$0080,-(A7) | Apple | Update Apple menu |
| 0x1A22 | MOVE.W #$0083,-(A7) | Lexicon | Update Lexicon menu |
| 0x1A42 | MOVE.W #$0081,-(A7) | File | Update File menu |
| 0x1A64 | MOVE.W #$0084,-(A7) | Menu 132 | Unknown menu (possibly Options?) |
| 0x1FBA | MOVE.W #$0082,-(A7) | Edit | Edit menu operations |
| 0x2024 | MOVE.W #$0080,-(A7) | Apple | Apple menu operations |
| 0x208E | MOVE.W #$0083,-(A7) | Lexicon | Lexicon menu operations |
| 0x20F8 | MOVE.W #$0081,-(A7) | File | File menu operations |

## Menu Handler Structure (0x19BA-0x1A70)

```asm
; Menu command string comparison and dispatch
19CE: CLR.B    -(A7)
19D0: MOVE.L   -40(A6),-(A7)      ; Push command string
19D4: PEA      -4174(A5)          ; Compare with menu string 1
19D8: _EqualString                 ; Toolbox call
19DC: BEQ.S    $19F0               ; Branch if not equal
19DE: CLR.L    -(A7)
19E0: MOVE.W   #$0082,-(A7)        ; Edit menu (130)
19E4: _HiliteMenu                  ; Highlight menu

19F0: ; Check next menu string...
19F6: PEA      -4166(A5)          ; Compare with menu string 2
...
1A02: MOVE.W   #$0080,-(A7)        ; Apple menu (128)

1A10: ; Check next...
1A16: PEA      -4158(A5)          ; Compare with menu string 3
...
1A22: MOVE.W   #$0083,-(A7)        ; Lexicon menu (131)

1A30: ; Check next...
1A36: PEA      -4150(A5)          ; Compare with menu string 4
...
1A42: MOVE.W   #$0081,-(A7)        ; File menu (129)

1A50: ; Check next...
1A56: PEA      -4142(A5)          ; Compare with menu string 5
...
1A64: MOVE.W   #$0084,-(A7)        ; Menu 132 (unknown)
```

This code compares incoming command strings with predefined menu strings and calls _HiliteMenu to highlight the appropriate menu.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 74(A5) | get size/count |
| 90(A5) | calculation |
| 98(A5) | unknown |
| 298(A5) | unknown |
| 306(A5) | unknown |
| 322(A5) | unknown |
| 338(A5) | unknown |
| 354(A5) | unknown |
| 378(A5) | unknown |
| 410(A5) | unknown |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 466(A5) | unknown |
| 658(A5) | init_subsystem |
| 754(A5) | unknown |
| 762(A5) | unknown |
| 962(A5) | unknown |
| 978(A5) | unknown |
| 986(A5) | unknown |
| 994(A5) | unknown |
| 1002(A5) | unknown |
| 1010(A5) | unknown |
| 1018(A5) | unknown |
| 1058(A5) | unknown |
| 1082(A5) | unknown |
| 1410(A5) | finalize_buffer |
| 1418(A5) | unknown |
| 1474(A5) | unknown |
| 1482(A5) | unknown |
| 1514(A5) | unknown |
| 1594(A5) | unknown |
| 1602(A5) | unknown |
| 1666(A5) | unknown |
| 1674(A5) | unknown |
| 2026(A5) | unknown |
| 2066(A5) | init/copy function |
| 2314(A5) | unknown |
| 2354(A5) | unknown |
| 2410(A5) | setup_buffer |
| 2826(A5) | unknown |
| 3146(A5) | unknown |
| 3170(A5) | unknown |
| 3178(A5) | unknown |
| 3202(A5) | unknown |
| 3210(A5) | unknown |
| 3314(A5) | unknown |
| 3322(A5) | unknown |
| 3458(A5) | unknown |
| 3466(A5) | unknown |
| 3490(A5) | copy to/from global |
| 3514(A5) | unknown |
| 3522(A5) | unknown |
| 3554(A5) | unknown |
| 3562(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 5 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)
- **Large code segment**: 13718 bytes suggests complex functionality

## Refined Analysis (Second Pass)

**Cluster**: Event Loop, Menu Handler

**Category**: UI_CORE, MENU_DISPATCH

**Global Variable Profile**: 6 DAWG, 3 UI, 103 total

**Calls functions in**: CODE 2, 7, 8, 9, 10, 11, 14, 15, 20, 22, 24, 27, 31, 32, 34, 41, 48, 49, 52

**Assessment**: Main event loop - menu dispatch and game UI controller

## Key Functions

| Offset | Purpose |
|--------|---------|
| 0x0000-0x004C | Board data copy/initialization |
| 0x004E-0x00F6 | Field initialization |
| 0x00F8-0x0458 | Tile placement validation |
| 0x08EA | Set lexicon mode to 7 |
| 0x147C-0x1494 | File menu check (returns 0 for File, or A5+1098) |
| 0x19BA-0x1A70 | **Menu command string dispatch** |
| 0x1F80-0x21DA | **Menu enable/disable updates** |

## Menu Item Handlers (Speculative)

Based on menu structure and code analysis:

| Menu | Item | Handler |
|------|------|---------|
| File (129) | New Game | Calls CODE 5/7 for dictionary init |
| File (129) | Open | File dialog handling |
| File (129) | Save | File save operations |
| File (129) | Quit | Application termination |
| Edit (130) | Undo/Cut/Copy/Paste | Standard edit operations |
| Lexicon (131) | North American | Sets mode=1 via CODE 7 |
| Lexicon (131) | United Kingdom | Sets mode=2 via CODE 5 |
| Lexicon (131) | Both | Sets mode=3 via CODE 5 |

## Lexicon Mode Setting

```
0x08EA: MOVE.W   #$0007,-8604(A5)  ; Set lexicon mode to 7
```

Mode 7 appears to be a special state, possibly for simulation or analysis mode.

## Integration with Other CODE Resources

- **CODE 5**: Called for dictionary initialization (modes 2, 3)
- **CODE 7**: Called for lexicon switching (mode 1)
- **CODE 11**: Called for game controller operations and word validation
- **CODE 8**: Called for move scoring (originally thought to be menu handler)
