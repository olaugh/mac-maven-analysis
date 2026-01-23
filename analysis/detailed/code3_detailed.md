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
3. Coordinates between hook-before/hook-after cross-check directions
4. Calls into CODE 52 for flag checking (via JT)
5. Manages the two-buffer system

## Key Functions

### Function 0x0000 - Main Search Entry (Large Frame)
```asm
; From disassembly:
0000: 4E56F716      LINK       A6,#-2282            ; frame=2282 bytes!
0004: 48E71F38      MOVEM.L    D3/D4/D5/D6/D7/A2/A3/A4,-(SP)  ; Save registers
0008: 7018          MOVEQ      #24,D0               ; Constant 24
000A: D0AE0008      ADD.L      8(A6),D0             ; Add param
000E: 2840          MOVEA.L    D0,A4                ; A4 = base + 24
0010: 2C2C002A      MOVE.L     42(A4),D6            ; D6 = field at offset 42
0014: 206E0008      MOVEA.L    8(A6),A0             ; A0 = param
0018: 0C680040000C  CMPI.W     #64,12(A0)           ; Check field_12 <= 64
001E: 6F04          BLE.S      $0024                ; OK
0020: 4EAD01A2      JSR        418(A5)              ; JT[418] - assertion failure
0024: 2F06          MOVE.L     D6,-(A7)             ; Push D6
0026: 486D902C      PEA        -28628(A5)           ; Push g_format_buffer
002A: 486EFFC1      PEA        -63(A6)              ; Push local buffer
002E: 4EAD0812      JSR        2066(A5)             ; JT[2066] - sprintf
...
```
**Frame size**: 2,282 bytes - this is a major search function with extensive local storage.

**Local variable layout** (verified from disassembly):
- -2282 to -2278: 4 bytes - loop counter storage
- -2274 to -2240: 34 bytes - DAWG info copy buffer
- -2240 to -0: Array of 34-byte search states (up to 65 entries at 34 bytes each)

**Entry validation**: Checks that param->field_12 <= 64 (max search depth)

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

### Function 0x0264 - Large Buffer Operation (Search State Init)
```asm
; From disassembly:
0264: 4E56F468      LINK       A6,#-2968            ; frame=2968 bytes!
0268: 48780B98      PEA        $0B98.W              ; push 2968 (0xB98)
026C: 486EF468      PEA        -2968(A6)            ; push buffer address
0270: 4EAD01AA      JSR        426(A5)              ; JT[426] - memset(buffer, 0, 2968)
0274: 486EF468      PEA        -2968(A6)            ; push buffer
0278: 4EBA0CEE      JSR        3310(PC)             ; local function - init search state
027C: 4A6EF470      TST.W      -2960(A6)            ; check counter field
0280: 4FEF000C      LEA        12(A7),A7            ; clean stack
0284: 6E06          BGT.S      $028C                ; if > 0, continue
0286: 3D7C0001F470  MOVE.W     #1,-2960(A6)         ; if <= 0, set to 1 (min value)
028C: ...
0294: 486DD76C      PEA        -10388(A5)           ; push g_lookup_tbl
0298: 4EAD0D7A      JSR        3450(A5)             ; JT[3450] - lookup operation
029C: 4A40          TST.W      D0                   ; check result
```

**Purpose**: Initialize a large (2968 byte) search state buffer and begin move generation. The 2968 bytes likely hold multiple candidate moves being evaluated.

## Global Variables Used

| Offset | Name | Usage in CODE 3 |
|--------|------|-----------------|
| A5-23090 | g_dawg_info | 34-byte structure, copied to/from |
| A5-23074 | g_dawg_ptr | Added to section offsets |
| A5-23070 | g_sect1_off | Section 1 offset |
| A5-23066 | g_sect2_off | Section 2 offset |
| A5-23056 | g_dawg_field | Source for 34-byte copy |
| A5-15522 | g_field_22 | Hook-after buffer |
| A5-15514 | g_field_14 | Hook-before buffer |
| A5-15506 | g_size1 | Section 1 size (56630) |
| A5-15502 | g_size2 | Section 2 size (65536) |
| A5-11972 | g_dawg_ptr2 | Secondary DAWG data |
| A5-10388 | g_lookup_tbl | Lookup table |
| A5-8664 | | Flag checked |

## Jump Table Calls Made

| JT Offset | Purpose | Called From |
|-----------|---------|-------------|
| 66(A5) | Multiply | offset calculations |
| 90(A5) | Division | 0x0058 |
| 362(A5) | DAWG traversal | 0x03C6 |
| 418(A5) | bounds_check/assert | 0x0020, error paths |
| 426(A5) | memset/clear | 0x0270, 0x0370, many |
| 666(A5) | Unknown | 0x013E |
| 674(A5) | Unknown | 0x003A |
| 1066(A5) | Unknown | 0x0384 |
| 1234(A5) | Unknown | 0x03CE |
| 1282(A5) | Unknown | 0x018E |
| 1306(A5) | Unknown | 0x038C |
| 1346(A5) | Unknown | 0x03FA |
| 1362(A5) | state_update | 0x0388 |
| 1650(A5) | Unknown | 0x0142 |
| 1738(A5) | Unknown | 0x04FC |
| 1746(A5) | Unknown | 0x0394 |
| 1754(A5) | Unknown | 0x0420 |
| 2066(A5) | sprintf | 0x002E |
| 2122(A5) | buffer_compare | 0x053C |
| 2202(A5) | data_copy | 0x0214 |
| 2346(A5) | check_result | 0x050C, 0x0516 |
| 2362(A5) | Unknown | 0x0182 |
| 2370(A5) | setup_params | 0x03AC, 0x04A4 |
| 2394(A5) | get_something | 0x01F0 |
| 2402(A5) | process_buffer | 0x0436 |
| 2410(A5) | setup_buffer | 0x01E8 |
| 2586(A5) | special_handler | 0x0236 |
| 3450(A5) | lookup | 0x0158, 0x0298 |
| 3466(A5) | memcpy | 0x02F4, 0x0304, many |
| 3490(A5) | copy_global | 0x0310, 0x0318, many |

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
       │(hook-bef)│   │(hook-aft)│   │  buffers  │
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
