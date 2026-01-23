# Maven Scrabble AI - Evaluation Functions Analysis

## Overview

This document describes the evaluation functions discovered through dynamic analysis
of Maven running under QEMU m68k emulation. The analysis was performed by tracing
instruction execution during Monte Carlo move simulation.

## Key Addresses

### Code Segments (Runtime addresses, loaded at ~0x07c8xxxx)

| Address Range | Size | Description |
|---------------|------|-------------|
| 0x07c8bd84 - 0x07c8c100 | 892 bytes | Main evaluation function complex |
| 0x07c8d1e4 - 0x07c8d400 | 540 bytes | Secondary evaluation function |
| 0x07c979f4 - 0x07c97b00 | 268 bytes | Tertiary evaluation function |

### Global Data (A5-relative)

The A5 register points to global data at runtime (observed: A5 = 0x20881000).

| Offset | Absolute Address | Size | Description |
|--------|------------------|------|-------------|
| A5-17154 | 0x2087ccfe | 289+ bytes | Board array (17x17 grid) |
| A5-16610 | 0x2087cf1e | ~578 bytes | Evaluation table (34-byte records, 17 entries) |
| A5-26702 | 0x2087a7b2 | 289 bytes | Cross-check table |
| A5-27246 | 0x2087a592 | 289 bytes | Anchor square table |
| A5-27630 | 0x2087a412 | ~64 bytes | Score multiplier table |
| A5-20010 | 0x2087c1d6 | 2 bytes | Move counter |
| A5-1064  | 0x20880bd8 | varies | Tile flags/properties |

## Board Representation

Maven uses a **17x17 internal board** (15x15 playable + 2 border rows/columns):

```
    0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
   +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
 0 |##|##|##|##|##|##|##|##|##|##|##|##|##|##|##|##|##|  Border
 1 |##|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |##|  Row 1 (A)
 2 |##|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |##|  Row 2 (B)
   ...
15 |##|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |##|  Row 15 (O)
16 |##|##|##|##|##|##|##|##|##|##|##|##|##|##|##|##|##|  Border
```

Board indexing formula: `offset = row * 17 + column`

## SANE Floating-Point Operations

Maven uses Apple's SANE (Standard Apple Numerics Environment) for floating-point
arithmetic via the FP68K trap (A-line trap 0xA9EB, shown as `0124753` in octal).

### Observed SANE Opcodes

| Opcode | Hex | Operation | Frequency |
|--------|-----|-----------|-----------|
| 0 | 0x0000 | FADDX (add extended) | 1 |
| 2 | 0x0002 | FSUBX (subtract extended) | 3 |
| 4 | 0x0004 | FMULX (multiply extended) | 2 |
| 6 | 0x0006 | FDIVX (divide extended) | 5 |
| 8 | 0x0008 | FCMPX (compare extended) | 2 |
| 22 | 0x0016 | FRINTX (round to integer) | 5 |
| 12304 | 0x3010 | FX2I (extended to integer) | 3 |
| 10254 | 0x280E | Conversion operation | varies |

### SANE Calling Convention

```asm
    pea     <source_operand>      ; Push pointer to source (10 bytes)
    pea     <dest_operand>        ; Push pointer to destination (10 bytes)
    movew   #<opcode>,%sp@-       ; Push SANE opcode
    .word   0xA9EB                ; FP68K trap (shown as 0124753 octal)
```

SANE extended precision uses **10 bytes (80 bits)** per value:
- 1 bit sign
- 15 bits exponent (bias 16383)
- 64 bits mantissa (explicit integer bit)

---

## Annotated Disassembly

### Main Evaluation Function Entry (0x07c8be8c)

This function evaluates a board position, taking a pointer argument and returning
a score. It allocates 70 bytes of stack for local FP temporaries.

```asm
; Function: evaluate_position
; Args: %fp@(8) = pointer to position structure
; Returns: score in D0
; Local stack: 70 bytes for SANE extended temps

0x07c8be8c:  linkw   %fp,#-70          ; Allocate 70 bytes local storage
0x07c8be90:  moveml  %a2/%a4,%sp@-     ; Save registers
0x07c8be94:  moveal  %fp@(8),%a4       ; A4 = position pointer
0x07c8be98:  movel   %a4,%d0           ;
0x07c8be9a:  beqw    0x7c8c02c         ; Return if NULL

; Check some threshold value
0x07c8be9e:  moveq   #20,%d0           ; D0 = 20
0x07c8bea0:  cmpl    %a4@(20),%d0      ; Compare with position[20]
0x07c8bea4:  bgtw    0x7c8bff4         ; Branch if 20 > position[20]

; === SANE FP Operation: Convert position[20] ===
0x07c8bea8:  pea     %a4@(20)          ; Source: position+20
0x07c8beac:  pea     %fp@(-30)         ; Dest: local temp at fp-30
0x07c8beb0:  movew   #10254,%sp@-      ; Opcode 0x280E (conversion)
0x07c8beb4:  .word   0xA9EB            ; SANE trap

; Copy 10-byte extended value from position[10] to local temp
0x07c8beb6:  lea     %fp@(-40),%a0     ; A0 = dest (fp-40)
0x07c8beba:  lea     %a4@(10),%a1      ; A1 = source (position+10)
0x07c8bebe:  movel   %a1@+,%a0@+       ; Copy 4 bytes
0x07c8bec0:  movel   %a1@+,%a0@+       ; Copy 4 bytes
0x07c8bec2:  movew   %a1@+,%a0@+       ; Copy 2 bytes (total 10)

; === SANE FP Operation: Divide ===
0x07c8bec4:  pea     %fp@(-30)         ; Divisor (converted value)
0x07c8bec8:  pea     %a0@(-10)         ; Dividend (copied value at fp-40)
0x07c8becc:  movew   #6,%sp@-          ; Opcode 6 = FDIVX
0x07c8bed0:  .word   0xA9EB            ; SANE trap: fp[-40] /= fp[-30]

; Copy result to another temp
0x07c8bed2:  lea     %fp@(-10),%a1     ; A1 = dest (fp-10)
0x07c8bed6:  lea     %a0@(-10),%a0     ; A0 = source (fp-40)
0x07c8beda:  movel   %a0@+,%a1@+       ; Copy 10 bytes
0x07c8bedc:  movel   %a0@+,%a1@+
0x07c8bede:  movew   %a0@+,%a1@+

; Setup for another operation
0x07c8bee0:  lea     %fp@(-40),%a0
0x07c8bee4:  lea     %fp@(-10),%a1
0x07c8bee8:  movel   %a1@+,%a0@+       ; Copy 10 bytes back
0x07c8beea:  movel   %a1@+,%a0@+
0x07c8beec:  movew   %a1@+,%a0@+

; === SANE FP Operation: Multiply ===
0x07c8beee:  pea     %fp@(-10)
0x07c8bef2:  pea     %a0@(-10)         ; fp-40
0x07c8bef6:  movew   #4,%sp@-          ; Opcode 4 = FMULX
0x07c8befa:  .word   0xA9EB            ; SANE trap

; More FP operations follow...
; [continues with subtract, more divides, etc.]
```

### Inner Evaluation Helper (0x07c8bd84)

This function appears to handle bit manipulation for rack tile evaluation.
It converts FP values to integers and counts bits.

```asm
; Function: evaluate_rack_bits
; Takes extended FP value on stack, returns integer score
; Uses bit counting to iterate over tiles in rack

0x07c8bd84:  linkw   %fp,#-38          ; 38 bytes local storage
0x07c8bd88:  moveml  %d5-%d7,%sp@-     ; Save D5, D6, D7
0x07c8bd8c:  moveq   #0,%d7            ; D7 = 0 (bit counter)

; Copy 10-byte FP argument to local temp
0x07c8bd8e:  lea     %fp@(-28),%a0     ; Dest
0x07c8bd92:  lea     %fp@(12),%a1      ; Source (stack arg)
0x07c8bd96:  movel   %a1@+,%a0@+       ; Copy 10 bytes
0x07c8bd98:  movel   %a1@+,%a0@+
0x07c8bd9a:  movew   %a1@+,%a0@+

; === SANE: Round to integer ===
0x07c8bd9c:  pea     %a0@(-10)         ; Operand
0x07c8bda0:  movew   #22,%sp@-         ; Opcode 22 = FRINTX (round)
0x07c8bda4:  .word   0xA9EB            ; SANE trap

; === SANE: Convert extended to integer ===
0x07c8bda6:  pea     %a0@(-10)         ; Source (rounded FP)
0x07c8bdaa:  pea     %fp@(-18)         ; Dest (integer result)
0x07c8bdae:  movew   #12304,%sp@-      ; Opcode 0x3010 = FX2I
0x07c8bdb2:  .word   0xA9EB            ; SANE trap

; Extract integer result
0x07c8bdb4:  movel   %fp@(-14),%d5     ; D5 = integer value
0x07c8bdb8:  movel   %d5,%d6           ; D6 = copy for bit counting

; === Bit counting loop ===
; Counts number of 1-bits in D6
0x07c8bdba:  bras    0x7c8bdc0         ; Enter loop

0x07c8bdbc:  lsrl    #1,%d6            ; Shift right, LSB -> carry
0x07c8bdbe:  addqw   #1,%d7            ; D7++ (count the bit)

0x07c8bdc0:  tstl    %d6               ; Test if D6 == 0
0x07c8bdc2:  bnes    0x7c8bdbc         ; Loop while D6 != 0

; Calculate final value
0x07c8bdc4:  movel   %d7,%d0           ; D0 = bit count
0x07c8bdc6:  extl    %d0               ; Sign extend
0x07c8bdc8:  divsw   #2,%d0            ; D0 /= 2

; [Function continues with more processing...]
```

### Board Evaluation Loop (from trace at 0x07c8be20)

This section iterates over board positions using the 17x17 grid structure:

```asm
; Board iteration using A5-relative tables
; D3 = column index, D4 = row index
; Uses multiplication by 17 for row offset calculation

0x07c8bdac:  moveq   #17,%d1           ; D1 = 17 (row stride)
0x07c8bdae:  mulsw   %d4,%d1           ; D1 = row * 17
0x07c8bdae:  lea     %a5@(-17154),%a4  ; A4 = board base address
0x07c8bdb2:  addl    %a4,%d1           ; D1 = &board[row][0]
0x07c8bdb4:  moveal  %d1,%a4           ; A4 = row pointer

; Similar setup for other tables
0x07c8bdb6:  moveq   #17,%d1
0x07c8bdb8:  mulsw   %d4,%d1
0x07c8bdba:  lea     %a5@(-26702),%a0  ; Cross-check table
0x07c8bdbe:  addl    %a0,%d1

0x07c8bdc4:  moveq   #17,%d2
0x07c8bdc6:  mulsw   %d4,%d2
0x07c8bdc8:  lea     %a5@(-27246),%a0  ; Anchor square table
0x07c8bdcc:  addl    %a0,%d2

; Check if square is empty
0x07c8be32:  tstb    %a4@(0,%d3:w)     ; board[row][col] == 0?
0x07c8be36:  bnew    0x7c8bfda         ; Skip if not empty

; Score calculation using multiplier table
0x07c8bea6:  movew   %a0@(-27630),%fp@(-316)  ; Get score multiplier
0x07c8beac:  moveal  %fp@(-298),%a0
0x07c8beb0:  moveb   %a0@(0,%d3:w),%d0        ; Get cross-score value
0x07c8beb4:  extw    %d0
0x07c8beb6:  mulsw   %fp@(-316),%d0           ; Multiply by weight
0x07c8beba:  moveaw  %d0,%a1
0x07c8bebc:  addl    %a1,%d5                  ; Accumulate score

; Boundary checks (board edges at 15 and 16)
0x07c8bebe:  cmpiw   #16,%d4           ; Row == 16 (bottom border)?
0x07c8bec2:  beqs    0x7c8bece
0x07c8bece:  cmpiw   #15,%d4           ; Row == 15 (last playable)?
0x07c8bed2:  beqw    0x7c8c008
```

---

## Data Structures

### Position Structure (passed to evaluate_position)

Based on the code accessing `%a4@(offset)`:

```c
struct Position {
    uint8_t  extended_value1[10];  // Offset 0: SANE extended FP
    uint8_t  extended_value2[10];  // Offset 10: SANE extended FP
    uint32_t threshold_or_count;   // Offset 20: compared with 20
    // ... more fields
};
```

### Board Tables (A5-relative)

```c
// Main board - 17x17 grid with borders
// Values: 0 = empty, 1-26 = tiles A-Z, 0xFF = border
uint8_t board[17][17];              // At A5-17154

// Cross-check validity table - which tiles valid at each square
uint8_t cross_checks[17][17];       // At A5-26702

// Anchor squares - where words can start
uint8_t anchors[17][17];            // At A5-27246

// Evaluation weights - 34 bytes per row (17 * 2)
int16_t eval_weights[17][17];       // At A5-16610

// Score multipliers indexed by tile/position
int16_t score_mult[32];             // At A5-27630
```

---

## Files

| File | Description |
|------|-------------|
| `/tmp/qemu_trace.log` | Full instruction trace (15MB) |
| `/tmp/maven_eval1.bin` | Evaluation function 1 binary (892 bytes) |
| `/tmp/maven_eval2.bin` | Evaluation function 2 binary (540 bytes) |
| `/tmp/maven_eval3.bin` | Evaluation function 3 binary (268 bytes) |

---

## Next Steps

1. **Locate MUL resource usage** - Find where leave values from MUL resources are loaded
2. **DAWG traversal** - Trace dictionary lookups during move generation
3. **Complete CFG** - Build control flow graph of evaluation functions
4. **Decompile to C** - Produce readable C equivalent of evaluation logic

---

## DAWG Dictionary Structure

### File Location
- **Data fork**: `/Volumes/T7/retrogames/oldmac/share/maven2`
- **Size**: 1,070,788 bytes (1.02 MB)

### File Layout

| Offset | Size | Description |
|--------|------|-------------|
| 0x0000-0x000F | 16 bytes | Header (size info, data offsets) |
| 0x0010-0x0077 | 104 bytes | Letter index (26 entries × 4 bytes) |
| 0x0078-0x040D | ~912 bytes | Padding (zeros) |
| 0x040E+ | ~1 MB | DAWG node data |

### Letter Index Format (0x0010-0x0077)

Each 4-byte entry:
```
Bytes 0-1: Child pointer (big-endian 16-bit)
Byte 2:    Flags (0x80 = end-of-word)
Byte 3:    Letter (ASCII lowercase a-z, 0x61-0x7A)
```

Example entries:
```
0x0010: 00 a9 48 61  -> 'a' children at ptr 0x00a9, flags 0x48
0x0020: 02 8b 84 65  -> 'e' children at ptr 0x028b, flags 0x84 (EOW set)
0x0030: 03 9a f8 69  -> 'i' children at ptr 0x039a, flags 0xf8 (EOW set)
```

Single-letter words: e, h, i, l, m, p, r, s, t, u, w, z (based on EOW flags)

### DAWG Node Format (0x040E+)

Node data uses 4-byte entries:
```
Bytes 0-1: Pointer/offset (big-endian 16-bit)  
Byte 2:    Flags
           - 0x80: End of word
           - 0x40: Last sibling (tentative)
           - Other bits: Unknown
Byte 3:    Letter (ASCII lowercase)
```

Example at 0x0760 (children of first 'a'):
```
0760: 00 07 52 61  -> 'a', ptr=7, "AA" starts here
0764: 00 06 ac 61  -> 'a', ptr=6, flags=0xAC (EOW), "AA" is a word!
0768: 00 06 c4 63  -> 'c', flags=0xC4 (EOW)
076c: 00 00 01 64  -> 'd'
0770: 00 06 dc 6c  -> 'l', flags=0xDC (EOW), "AL" is a word
```

### Code References

Based on trace analysis, the DAWG access code:
- Loads base pointer from A5-relative storage
- Uses indexed addressing for node access
- Tests bit flags for end-of-word
- Follows child pointers for tree traversal

Still needs investigation:
- Exact pointer interpretation (absolute vs relative)
- Complete traversal algorithm
- How prefixes are handled for move generation
