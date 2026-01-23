# CODE 3 Detailed Analysis - DAWG Search Coordinator

## Overview

| Property | Value |
|----------|-------|
| Size | 4,390 bytes |
| JT Offset | 112 |
| JT Entries | 6 |
| Functions | 16 |
| Purpose | **Main DAWG search coordination and move generation** |


## System Role

**Category**: DAWG Engine
**Function**: Search Coordinator

Main DAWG search with 2282-byte stack frame, coordinates move generation

**Related CODE resources**:
- CODE 15 (DAWG traversal)
- CODE 36 (word validation)
- CODE 52 (flags)
## Architecture Role

CODE 3 is the **central coordinator** for DAWG operations. It:
1. Sets up search parameters
2. Manages the 34-byte DAWG info structure
3. Coordinates between horizontal/vertical search directions
4. Calls into CODE 52 for flag checking (via JT)
5. Manages the two-buffer system

## Key Functions

### Function 0x0000 - Main Search Entry (Large Frame)
```asm
0000: LINK       A6,#-2282       ; frame=2282 bytes!
0004: MOVEM.L    D3-D7/A2-A4,-(SP)
...
```
**Frame size**: 2,282 bytes - this is a major search function with extensive local storage.

**Local variable layout** (speculative):
- -2282 to -2240: 42 bytes of state
- -2240 to -0: Array of 34-byte search states (up to 65 entries)

### Function 0x019E - Validate DAWG Bounds
```asm
019E: LINK       A6,#0
01A2: MOVE.L     A4,-(A7)         ; save A4
01A4: MOVEA.L    8(A6),A4         ; A4 = param (DawgHeader*)
01A8: MOVE.L     16(A4),D0        ; D0 = header->field_10
01AC: ADD.L      20(A4),D0        ; D0 += header->field_14
01B0: MOVE.L     -23074(A5),D1    ; D1 = g_dawg_ptr
01B4: ADD.L      -23070(A5),D1    ; D1 += g_sect1_off
01B8: ADD.L      -23066(A5),D1    ; D1 += g_sect2_off
01BC: ADD.L      24(A4),D0        ; D0 += header->field_18
01C0: CMP.L      D0,D1            ; compare
01C2: BGE.S      $01D4            ; if loaded >= expected, OK
; Error path - copy header to global
01C4: LEA        -23090(A5),A0    ; A0 = &g_dawg_info
01C8: LEA        (A4),A1          ; A1 = param
01CA: MOVEQ      #7,D0            ; copy 8 longs
01CC: MOVE.L     (A1)+,(A0)+
01CE: DBF        D0,$01CC
01D2: MOVE.W     (A1)+,(A0)+      ; copy final word (34 bytes total)
01D4: MOVEA.L    (A7)+,A4
01D6: UNLK       A6
01D8: RTS
```

**C equivalent**:
```c
void validate_dawg_bounds(DawgHeader* header) {
    // Calculate expected size from header
    long expected = header->size_10 + header->size_14 + header->size_18;

    // Calculate loaded size from globals
    long loaded = g_dawg_ptr + g_sect1_off + g_sect2_off;

    if (loaded < expected) {
        // Copy 34-byte header to global for error reporting
        memcpy(&g_dawg_info, header, 34);
    }
}
```

### Function 0x01DA - Setup with Range Check
```asm
01DA: LINK       A6,#-128         ; 128 bytes of locals
01DE: MOVEM.L    D7/A4,-(SP)
01E2: MOVEA.L    8(A6),A4         ; A4 = param
01E6: MOVE.L     A4,-(A7)
01E8: JSR        2410(A5)         ; setup_buffer(param)
01EC: PEA        -128(A6)         ; local buffer
01F0: JSR        2394(A5)         ; get_something()
01F4: MOVE.B     D0,D7            ; D7 = result (type byte)
01F6: CMPI.B     #8,D7            ; if type >= 8
01FA: ...
01FC: BGE.S      $021C

; Type < 8 path
01FE: MOVEA.L    -11972(A5),A0    ; A0 = g_dawg_ptr2
0202: TST.W      20(A0)           ; check field_20
0206: BEQ.S      $021C            ; if zero, skip
0208: MOVEA.L    -11972(A5),A0
020C: MOVEA.W    14(A0),A0        ; A0 = ptr->field_14
0210: MOVE.L     A0,-(A7)         ; push
0212: MOVE.L     A4,-(A7)         ; push param
0214: JSR        2202(A5)         ; call data_copy
...

; Type 8-16 path
021C: CMPI.B     #7,D7
0220: BLE.S      $023E            ; if <= 7, skip
0222: CMPI.B     #17,D7
0226: BCC.S      $023E            ; if >= 17, skip
; Type 8-16 specific handling
0228: MOVEA.L    -11972(A5),A0
022C: TST.W      18(A0)           ; check field_18
0230: BEQ.S      $023E
0232: CLR.W      -(A7)            ; push 0
0234: MOVE.L     A4,-(A7)
0236: JSR        2586(A5)         ; call special_handler
...

; Copy from g_dawg_field to g_dawg_info
024A: LEA        -23090(A5),A0    ; dest = g_dawg_info
024E: LEA        -23056(A5),A1    ; src = g_dawg_field
0252: MOVEQ      #7,D0            ; 8 longs
0254: MOVE.L     (A1)+,(A0)+
0256: DBF        D0,$0254
025A: MOVE.W     (A1)+,(A0)+      ; + 1 word = 34 bytes
```

**C equivalent**:
```c
void setup_with_range_check(void* param) {
    char local_buf[128];

    setup_buffer(param);
    int type = get_something(local_buf);

    if (type < 8) {
        DawgData* data = g_dawg_ptr2;
        if (data->field_20 != 0) {
            data_copy(param, data->field_14);
        }
    } else if (type >= 8 && type < 17) {
        DawgData* data = g_dawg_ptr2;
        if (data->field_18 != 0) {
            special_handler(param, 0);
        }
    } else {
        // Default handling
        some_function(param, 2114);  // constant offset
    }

    // Copy 34 bytes from g_dawg_field to g_dawg_info
    memcpy(&g_dawg_info, &g_dawg_field, 34);
}
```

### Function 0x0264 - Large Buffer Operation
```asm
0264: LINK       A6,#-2968        ; 2968 bytes of locals!
0268: PEA        $0B98.W          ; push 2968
026C: PEA        -2968(A6)        ; push buffer address
0270: JSR        426(A5)          ; memset(buffer, 0, 2968)
0274: PEA        -2968(A6)
0278: JSR        3310(PC)         ; local function call
027C: TST.W      -2960(A6)        ; check field
0280: LEA        12(A7),A7
0284: BGT.S      $028C
0286: MOVE.W     #1,-2960(A6)     ; if <= 0, set to 1
028C: ...
0294: PEA        -10388(A5)       ; push g_lookup_tbl
0298: JSR        3450(A5)         ; lookup()
029C: TST.W      D0
```

**Purpose**: Initialize a large (2968 byte) buffer and perform lookups. This is likely the main search state initialization.

## Global Variables Used

| Offset | Name | Usage in CODE 3 |
|--------|------|-----------------|
| A5-23090 | g_dawg_info | 34-byte structure, copied to/from |
| A5-23074 | g_dawg_ptr | Added to section offsets |
| A5-23070 | g_sect1_off | Section 1 offset |
| A5-23066 | g_sect2_off | Section 2 offset |
| A5-23056 | g_dawg_field | Source for 34-byte copy |
| A5-15522 | g_field_22 | Horizontal buffer |
| A5-15514 | g_field_14 | Vertical buffer |
| A5-15506 | g_size1 | Section 1 size (56630) |
| A5-15502 | g_size2 | Section 2 size (65536) |
| A5-11972 | g_dawg_ptr2 | Secondary DAWG data |
| A5-10388 | g_lookup_tbl | Lookup table |
| A5-8664 | | Flag checked |

## Jump Table Calls Made

| JT Offset | Purpose | Called From |
|-----------|---------|-------------|
| 426(A5) | memset/clear | 0x0270, many |
| 418(A5) | bounds_check | error paths |
| 2066(A5) | init/copy | several |
| 2122(A5) | buffer_compare | scoring |
| 2202(A5) | data_copy | 0x0214 |
| 2346(A5) | check_result | after search |
| 2370(A5) | setup_params | search setup |
| 2394(A5) | get_something | 0x01F0 |
| 2410(A5) | setup_buffer | 0x01E8 |
| 2586(A5) | special_handler | 0x0236 |
| 3450(A5) | lookup | 0x0298 |
| 3490(A5) | copy_global | many |

## Data Flow

```
                    ┌─────────────────┐
                    │   g_dawg_ptr    │ (A5-23074)
                    │   + g_sect1_off │ (A5-23070)
                    │   + g_sect2_off │ (A5-23066)
                    └────────┬────────┘
                             │
                             v
┌──────────────┐    ┌────────────────┐    ┌──────────────┐
│ g_dawg_field │───>│  g_dawg_info   │<───│ Input Header │
│  (A5-23056)  │    │   (A5-23090)   │    │   (param)    │
└──────────────┘    └────────┬───────┘    └──────────────┘
                             │
              ┌──────────────┼──────────────┐
              v              v              v
       ┌──────────┐   ┌──────────┐   ┌──────────┐
       │g_field_14│   │g_field_22│   │Large local│
       │(vertical)│   │(horizntl)│   │  buffers  │
       └──────────┘   └──────────┘   └──────────┘
```

## Algorithm Sketch

1. **Initialization**:
   - Clear large local buffer (2968 bytes)
   - Copy 34-byte DAWG info structure
   - Validate sizes match

2. **Search Setup**:
   - Determine search type (0-7, 8-16, or 17+)
   - Select appropriate buffer (field_14 or field_22)
   - Call setup_params with g_dawg_info

3. **Search Execution**:
   - Iterate through 34-byte state entries
   - Use JT[362] for actual DAWG traversal
   - Check results via JT[2346]

4. **Result Processing**:
   - Copy results back to globals
   - Update game state

## Confidence Levels

| Aspect | Confidence |
|--------|------------|
| Function boundaries | HIGH |
| 34-byte structure handling | HIGH |
| Buffer selection logic | HIGH |
| Jump table purposes | MEDIUM |
| Local variable layouts | LOW |
| Exact algorithm | LOW |

## Relationship to Other CODE

- **CODE 7**: Provides board state that CODE 3 searches
- **CODE 11**: Calls CODE 3 to perform AI search
- **CODE 52**: Called via JT for flag extraction
- **CODE 21**: Uses results for display
