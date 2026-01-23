# Maven CODE 3 Annotated Disassembly

## Compiler Analysis

**Probable Compiler**: THINK C 5.x or MPW C 3.x (1980s)

**Evidence**:
- LINK A6,#-n / MOVEM.L pattern for function prologues
- A5 used for global data pointer (QuickDraw globals convention)
- A6 used as frame pointer (standard Mac calling convention)
- Heavy use of D0/D1 for return values and temporaries
- Toolbox traps via A-line instructions

**Register Conventions**:
- D0-D2: Scratch/return values
- D3-D7: Preserved across calls (callee-saved)
- A0-A1: Scratch
- A2-A4: Preserved (callee-saved)
- A5: Global data pointer
- A6: Frame pointer
- A7: Stack pointer

---

## Function at 0x0004: Main DAWG Access Function

This appears to be the primary DAWG dictionary lookup function.

### Assembly with C Translation

```asm
; ============================================================
; Function: dawg_lookup (speculative name)
; Parameters: (via stack)
;   8(A6): pointer to some structure
; Local variables: -2282 bytes on stack
; ============================================================

0004: 4E56 F706        LINK    A6,#-2282      ; Set up stack frame
```

```c
// Speculative C:
// void dawg_lookup(DawgStruct *param) {
//     char locals[2282];  // Large local buffer
```

```asm
0008: 48E7 1F38        MOVEM.L D3-D7/A2-A4,-(SP)  ; Save registers
```

```c
//     // Compiler saves callee-saved registers
```

```asm
000C: 266E 0008        MOVEA.L 8(A6),A3     ; A3 = first parameter
```

```c
//     DawgStruct *dawg = param;  // A3 = dawg pointer
```

```asm
0010: A9FF             _DCF6                 ; ??? Unknown trap
                                            ; (possibly pack/unpack or custom)
```

```c
//     // Unknown system call - possibly QuickDraw or custom trap
```

---

## Function at 0x01A2: DAWG Bounds Check

This function checks if an index is within the DAWG bounds.

### Assembly with C Translation

```asm
; ============================================================
; Function: dawg_bounds_check (speculative name)
; Parameters:
;   8(A6): pointer to DAWG header structure
; Returns: (implied - checks bounds and possibly sets error)
; ============================================================

01A2: 4E56 0000        LINK    A6,#0          ; No local variables
```

```c
// Boolean dawg_bounds_check(DawgHeader *header) {
```

```asm
01A6: 2F0C             MOVE.L  A4,-(SP)       ; Save A4
01A8: 286E 0008        MOVEA.L 8(A6),A4       ; A4 = header parameter
```

```c
//     DawgHeader *hdr = header;  // A4 = header pointer
```

```asm
01AC: 202C 0010        MOVE.L  16(A4),D0      ; D0 = header->field_0x10
01B0: D0AC 0014        ADD.L   20(A4),D0      ; D0 += header->field_0x14
```

```c
//     long total = hdr->size1 + hdr->size2;  // Fields at offset 0x10, 0x14
```

```asm
01B4: 222D A5DE        MOVE.L  -23074(A5),D1  ; D1 = global_dawg_ptr
01B8: D2AD A5E2        ADD.L   -23070(A5),D1  ; D1 += global_offset1
01BC: D2AD A5E6        ADD.L   -23066(A5),D1  ; D1 += global_offset2
```

```c
//     long loaded_size = g_dawg_ptr + g_offset1 + g_offset2;
//     // Globals at A5-23074, A5-23070, A5-23066
```

```asm
01C0: D0AC 0018        ADD.L   24(A4),D0      ; D0 += header->field_0x18
01C4: B280             CMP.L   D0,D1          ; Compare loaded vs expected
01C6: 6C10             BGE.S   $01D8          ; If loaded >= expected, OK
```

```c
//     total += hdr->size3;  // Field at offset 0x18
//     if (loaded_size >= total) {
//         goto success;
//     }
```

```asm
01C8: 41ED A5CE        LEA     -23090(A5),A0  ; A0 = &global_struct
01CC: 43D4             LEA     (A4),A1        ; A1 = header
01CE: 7007             MOVEQ   #7,D0          ; Copy 8 longs (32 bytes)
01D0: 20D9             MOVE.L  (A1)+,(A0)+    ; Copy loop
01D2: 51C8 FFFC        DBF     D0,$01D0
01D6: 30D9             MOVE.W  (A1)+,(A0)+    ; Copy 2 more bytes
```

```c
//     // Copy header structure to global (34 bytes)
//     memcpy(&g_dawg_info, hdr, 34);
```

```asm
01D8: 285F             MOVEA.L (SP)+,A4       ; Restore A4
01DA: 4E5E             UNLK    A6             ; Restore frame
01DC: 4E75             RTS                    ; Return
```

```c
// success:
//     return;
// }
```

---

## Function at 0x01DE: Initialize Local Buffer

### Assembly with C Translation

```asm
; ============================================================
; Function: init_buffer (speculative name)
; Parameters:
;   8(A6): pointer to structure
; Local variables: 128 bytes
; ============================================================

01DE: 4E56 FF80        LINK    A6,#-128       ; 128 bytes local space
01E2: 48E7 0108        MOVEM.L D7/A4,-(SP)   ; Save D7, A4
01E6: 286E 0008        MOVEA.L 8(A6),A4       ; A4 = parameter
```

```c
// void init_buffer(SomeStruct *param) {
//     char buffer[128];
//     SomeStruct *ptr = param;
```

```asm
01EA: 2F0C             MOVE.L  A4,-(SP)       ; Push param
01EC: 4EAD 096A        JSR     2410(A5)       ; Call subroutine via A5 jump table
```

```c
//     sub_096A(ptr);  // Call via jump table at A5+2410
```

```asm
01F0: 486E FF80        PEA     -128(A6)       ; Push &buffer
01F4: 4EAD 095A        JSR     2394(A5)       ; Call another subroutine
01F8: 1E00             MOVE.B  D0,D7          ; D7 = return value
```

```c
//     result = sub_095A(buffer);  // Returns byte in D0
```

```asm
01FA: 0C07 0008        CMPI.B  #8,D7          ; Compare with 8
01FE: 508F             ADDQ.L  #8,SP          ; Clean up stack (2 args * 4)
0200: 6C1E             BGE.S   $0220          ; If result >= 8, skip
```

```c
//     if (result < 8) {
```

---

## Region 0x0090-0x0130: Structure Field Access

This region shows DAWG entry access patterns.

### Assembly with C Translation

```asm
; ============================================================
; DAWG Entry Access - likely inside a loop
; Context: A2 points to DAWG entries, D2/D3 are indices
; ============================================================

0090: 2028 0022        MOVE.L  34(A0),D0      ; D0 = structure[34]
                                              ; NOTE: 34 = 0x22, entry size?
```

```c
//     long value = ptr->some_array[index];  // Offset 34
```

```asm
0094: D0AE F71A        ADD.L   -2278(A6),D0   ; Add local variable
0098: 2F00             MOVE.L  D0,-(SP)       ; Push as argument
009A: 4EAD 005A        JSR     90(A5)         ; Call via jump table
```

```c
//     value += local_var;
//     some_function(value);
```

```asm
009E: 2E00             MOVE.L  D0,D7          ; D7 = result
00A0: 2007             MOVE.L  D7,D0          ; D0 = D7
00A2: 90AB 0014        SUB.L   20(A3),D0      ; D0 -= struct->field_14
00A6: 90AB 0010        SUB.L   16(A3),D0      ; D0 -= struct->field_10
```

```c
//     result = return_value;
//     adjusted = result - dawg->size1 - dawg->size2;
//     // Fields at offsets 0x10 and 0x14
```

```asm
00AA: 2740 0018        MOVE.L  D0,24(A3)      ; Store at offset 24
```

```c
//     dawg->computed_offset = adjusted;  // Offset 0x18
```

```asm
00AE: 7600             MOVEQ   #0,D3          ; D3 = 0 (loop counter?)
00B0: 45EE F740        LEA     -2240(A6),A2   ; A2 = local buffer
00B4: 600E             BRA.S   $00C4          ; Jump to loop test
```

```c
//     int i = 0;
//     Entry *entries = local_buffer;
//     while (...)
```

```asm
; Loop body
00B6: BA43             CMP.W   D3,D5          ; Compare counters
00B8: 6E04             BGT.S   $00BE          ; If D5 > D3, skip
00BA: 4EAD 01A2        JSR     418(A5)        ; Call bounds check
00BE: 5243             ADDQ.W  #1,D3          ; D3++
00C0: 45EA 0022        LEA     34(A2),A2      ; A2 += 34 (entry size!)
```

```c
//     {
//         if (max_index <= i) {
//             bounds_check();
//         }
//         i++;
//         entry_ptr += ENTRY_SIZE;  // ENTRY_SIZE = 34 bytes???
//     }
```

**NOTE**: The value 34 (0x22) appears as an entry size here, but DAWG entries
are 4 bytes. This might be a different structure (search state? move buffer?).

```asm
; Loop condition
00C4: 202A 0010        MOVE.L  16(A2),D0      ; D0 = entry->field_10
00C8: D0AA 0014        ADD.L   20(A2),D0      ; D0 += entry->field_14
00CC: D0AA 0018        ADD.L   24(A2),D0      ; D0 += entry->field_18
00D0: B087             CMP.L   D7,D0          ; Compare sum with D7
00D2: 6EE2             BGT.S   $00B6          ; If sum > D7, continue loop
```

```c
//     while (entry->f10 + entry->f14 + entry->f18 > limit) {
//         // loop body
//     }
```

---

## Region 0x0590-0x0620: DAWG Data Access

### Assembly with C Translation

```asm
; ============================================================
; Direct DAWG global access
; ============================================================

059A: 222D D13C        MOVE.L  -11972(A5),D1  ; D1 = global at A5-11972
```

```c
//     dawg_base = g_dawg_data;  // Global pointer
```

```asm
05A2: 206D D13C        MOVEA.L -11972(A5),A0  ; A0 = same global
05A6: 4A68 000A        TST.W   10(A0)         ; Test field at offset 10
05AA: 673A             BEQ.S   $05E6          ; If zero, skip
```

```c
//     DawgPtr dawg_ptr = g_dawg_data;
//     if (dawg_ptr->some_flag != 0) {
//         // process...
//     }
```

```asm
05F0: 202D D13C        MOVE.L  -11972(A5),D0  ; Load DAWG pointer
```

```c
//     base = g_dawg_data;
```

---

## Region 0x0B50-0x0BA0: DAWG Size Calculations

### Assembly with C Translation

```asm
; ============================================================
; DAWG size calculations using two globals
; ============================================================

0B54: 202D C36E        MOVE.L  -15506(A5),D0  ; D0 = dawg_size_1 (56630?)
```

```c
//     size1 = g_dawg_size1;  // Likely 56630
```

```asm
0B58: D1AE E71C        ADD.L   D0,-6372(A6)   ; Add to local
0B5C: 222D C372        MOVE.L  -15502(A5),D1  ; D1 = dawg_size_2
```

```c
//     local_offset += size1;
//     size2 = g_dawg_size2;  // Likely 65536
```

```asm
0B60: D3AE E718        ADD.L   D1,-6376(A6)   ; Add to different local
0B64: D081             ADD.L   D1,D0          ; D0 = size1 + size2
0B66: D1AE E728        ADD.L   D0,-6360(A6)   ; Store combined
```

```c
//     local_offset2 += size2;
//     combined = size1 + size2;  // = 122166 total entries
//     local_combined = combined;
```

---

## Uncertain Sections

### 0x00E0-0x0110: Block Memory Copy

```asm
00DA: 7007             MOVEQ   #7,D0          ; Count = 8
00DC: 20D9             MOVE.L  (A1)+,(A0)+    ; Copy long
00DE: 51C8 FFFC        DBF     D0,$00DC       ; Loop
00E2: 30D9             MOVE.W  (A1)+,(A0)+    ; Copy final word
```

This is a 34-byte memory copy (8 longs + 1 word = 32 + 2 = 34).
Used multiple times - possibly copying DAWG entry structures.

**UNCERTAIN**: Why 34 bytes? DAWG entries are 4 bytes. This might be:
- Move generation state structure
- Search node
- Play candidate structure

### 0x0F26: Table Lookup Pattern

```asm
0F26: D040             ADD.W   D0,D0          ; D0 *= 2
0F28: 43FA 0030        LEA     48(PC),A1      ; A1 = table address
0F2C: D2F1 0000        ADDA.W  (A1,D0.W),A1   ; Add offset from table
```

This is a switch/case jump table pattern. The compiler generated a table
of offsets at PC+48, indexed by D0*2.

---

## Global Variables Summary

| Offset | Likely Purpose |
|--------|----------------|
| A5-23090 | DAWG info structure (34 bytes) |
| A5-23074 | Main DAWG data pointer |
| A5-23070 | DAWG offset/size 1 |
| A5-23066 | DAWG offset/size 2 |
| A5-15506 | First DAWG size (56630) |
| A5-15502 | Second DAWG size (65536) |
| A5-11972 | Another DAWG pointer |

---

## Speculative Data Structures

```c
// DAWG Header (at file offset 0x00)
typedef struct DawgHeader {
    long size1;          // 0x00: 56630 - first section size
    long size2;          // 0x04: 122166 - cumulative size
    long size3;          // 0x08: 145476 - another size
    long reserved;       // 0x0C: 768
    // 0x10: letter index begins
} DawgHeader;

// DAWG Entry (4 bytes, at file offset 0x410+)
typedef struct DawgEntry {
    unsigned short ptr;  // 0x00: child pointer/offset
    unsigned char flags; // 0x02: bit7=word, bit0=last, bits1-6=offset addon
    unsigned char letter;// 0x03: ASCII letter (0x61-0x7A)
} DawgEntry;

// Letter Index Entry (4 bytes, at file offset 0x10)
typedef struct LetterIndex {
    unsigned short entry_idx; // Start entry for this letter
    unsigned char flags;      // Unknown purpose
    unsigned char letter;     // The letter (ASCII)
} LetterIndex;

// Global DAWG State (speculative)
typedef struct DawgState {
    DawgEntry *entries;      // A5-23074
    long section1_offset;    // A5-23070
    long section2_offset;    // A5-23066
    long size1;              // A5-15506 = 56630
    long size2;              // A5-15502 = 65536
    // ... more fields
} DawgState;
```

---

## Notes on Disassembly Quality

1. **High confidence**: Function prologues/epilogues, register saves, basic arithmetic
2. **Medium confidence**: Structure field access patterns, loop constructs
3. **Low confidence**: Purpose of specific calculations, meaning of magic numbers
4. **Unknown**: Many trap calls (0xADxx, 0xAExx) - need Mac toolbox reference

The 34-byte structure size (0x22) appearing frequently is puzzling since DAWG
entries are 4 bytes. This might be a move/play structure used during search.
