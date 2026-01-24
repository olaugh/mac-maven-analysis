# CODE 11 Analysis

## Overview

| Property | Value |
|----------|-------|
| Size | 4478 bytes |
| JT Offset | 376 |
| JT Entries | 19 |
| Functions | 29 |
| Categories | DAWG_ACCESS, UI_DRAWING, GAME_CONTROLLER |
| Purpose | **Game Controller / Lexicon Dispatcher / Word Validation** |
| Confidence | HIGH |

## Menu Context

This is the **central game controller** that:
- Dispatches lexicon operations based on mode (A5-8604)
- Implements **table-driven word validation** at A5-24244
- Handles game state transitions
- Called from CODE 21 (main event loop) when processing game actions

## Functions

Entry points at: 0x0000, 0x0058, 0x0086, 0x00A0, 0x00E6, 0x0106, 0x014C, 0x017C, 0x01A6, 0x020E, 0x027E, 0x02D2, 0x0342, 0x037E, 0x039E, 0x03B4, 0x0468, 0x04C8, 0x0550, 0x05BA
... and 9 more

## Toolbox Traps Used

| Trap | Name |
|------|------|
| $A8E6 | _DrawPicture |

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-27732 | g_buffer1 | Buffer area 1 |
| A5-24026 | g_common | Common data area |
| A5-23090 | g_dawg_info | 34-byte DAWG info structure |
| A5-23074 | g_dawg_ptr | Main DAWG data pointer |
| A5-15522 | g_field_22 | Board buffer 2 (hook-after) |
| A5-15514 | g_field_14 | Board buffer 1 (hook-before) |
| A5-15506 | g_size1 | DAWG section 1 size (56630) |
| A5-15502 | g_size2 | DAWG section 2 size (65536) |
| A5-15498 | g_current_ptr | Current active buffer pointer |
| A5-8604 | g_lexicon_mode | **Lexicon mode for word validation** |
| A5-8602 | g_validation_state | Validation state variable |
| A5-8584 | g_handle | Handle to data structure |
| A5-8510 | g_window_ptr | Main window pointer |
| A5-24244 | g_validation_table | **Word validation lookup table (56 bytes)** |
| A5-24188 | g_validation_end | End of validation table |

Also references 27 unknown A5-relative globals.

## Lexicon Mode Dispatch (from disassembly)

```
0x0F0A: MOVEQ    #2,D0           ; Mode 2 (UK/OSW)
0x0F0C: BRA.S    $0F10
0x0F0E: MOVEQ    #3,D0           ; Mode 3 (Both/SOWPODS)
0x0F10: MOVE.W   D0,-8604(A5)    ; Set g_lexicon_mode

0x0FE2: MOVEQ    #2,D0           ; Fallback mode 2
0x0FE4: MOVE.W   D0,-8604(A5)

0x10A2: MOVEQ    #3,D0           ; Mode 3
0x10A4: MOVE.W   D0,-8604(A5)

0x10B2: MOVE.W   #$0005,-8604(A5) ; Mode 5 (transitional)

0x110E: CLR.W    -8604(A5)       ; Clear mode (reset)
```

## Word Validation Algorithm (at 0x111C)

```asm
; Function at 0x111C - Word validation using lookup table
111C: MOVEM.L  D7/A3/A4,-(SP)
1120: TST.W    -8604(A5)       ; Check lexicon mode
1124: BEQ.S    $115C           ; If 0, return 0
1126: LEA      -24188(A5),A4   ; A4 = end of table
112A: LEA      -24244(A5),A3   ; A3 = start of table

; Loop through validation table entries
1130: MOVE.B   (A3),D7         ; Get entry byte 0
1136: CMP.W    -8602(A5),D0    ; Compare with validation state
113A: BEQ.S    $1142           ; Match found
113C: CMPI.B   #$FF,D7         ; End marker?
1140: BNE.S    $1156           ; No, try next entry
1142: MOVE.B   1(A3),D0        ; Get byte 1 (lexicon mode requirement)
1148: CMP.W    -8604(A5),D0    ; Compare with current mode
114C: BNE.S    $1156           ; No match, continue
114E: MOVE.B   2(A3),D0        ; Get byte 2 (validity result)
115E: RTS                       ; Return with result
```

**Validation Table Structure** (A5-24244, 56 bytes = 14 entries × 4 bytes):
- Byte 0: Condition/state value (0xFF = end marker)
- Byte 1: Required lexicon mode (1=NA, 2=UK, 3=Both)
- Byte 2: Validity result (0=invalid, non-0=valid)
- Byte 3: Reserved/padding

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 234(A5) | unknown |
| 282(A5) | unknown |
| 290(A5) | unknown |
| 314(A5) | unknown |
| 346(A5) | unknown |
| 362(A5) | process_dawg - DAWG traversal |
| 650(A5) | get_data from buffer |
| 658(A5) | init_subsystem |
| 778(A5) | unknown |
| 842(A5) | copy_buffers |
| 1042(A5) | unknown |
| 1218(A5) | clear_window |
| 1258(A5) | post-search init |
| 1362(A5) | state_update |
| 1410(A5) | finalize_buffer |
| 1450(A5) | unknown |
| 1570(A5) | unknown |
| 1578(A5) | unknown |
| 1610(A5) | check_something |
| 1618(A5) | unknown |
| 1626(A5) | unknown |
| 1634(A5) | unknown |
| 2346(A5) | check_result |
| 2370(A5) | setup_params |
| 2410(A5) | setup_buffer |
| 2434(A5) | setup_more |
| 2954(A5) | unknown |
| 2962(A5) | unknown |
| 2970(A5) | unknown |
| 3082(A5) | unknown |
| 3114(A5) | unknown |
| 3138(A5) | unknown |
| 3194(A5) | unknown |
| 3506(A5) | compare function |
| 3578(A5) | final_call with sizes |

## Analysis Notes

- **DAWG-related**: Uses 6 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)

## Refined Analysis (Second Pass)

**Cluster**: Dawg Core, Game Controller

**Category**: CORE_AI, LEXICON_CONTROL

**Global Variable Profile**: 7 DAWG, 3 UI, 41 total

**Calls functions in**: CODE 7, 8, 9, 10, 14, 16, 18, 20, 21, 22, 31, 32, 34, 41, 46, 48, 52

**Assessment**: Central game controller - lexicon mode dispatch and word validation

## Key Functions

| Offset | Purpose |
|--------|---------|
| 0x0EE4-0x0F30 | Dictionary buffer setup and mode selection |
| 0x0F34-0x0F56 | DAWG info initialization |
| 0x0F5A-0x10DC | Lexicon switching logic (modes 0, 2, 3, 4, 5) |
| 0x10DE-0x111A | Mode state machine |
| 0x111C-0x1162 | **Word validation lookup** (table-driven) |

## How TWL Filtering Works

Based on this analysis, TWL (North American) filtering works as follows:

1. Words are looked up in the SOWPODS DAWG (combined dictionary)
2. Each word has an associated "dictionary flag"
3. When lexicon_mode=1 (North American), the validation table at A5-24244 is consulted
4. The table maps (word_flag, mode) → valid/invalid
5. OSW-only words return invalid for TWL mode

This explains why there's no separate TWL DAWG - the SOWPODS DAWG serves as the master dictionary with per-word flags indicating TWL/OSW membership.
