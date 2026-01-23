# CODE 2 Detailed Analysis - Resource & Data Loading

## Overview

| Property | Value |
|----------|-------|
| Size | 750 bytes |
| JT Offset | 80 |
| JT Entries | 4 |
| Functions | 6 |
| Purpose | **Resource loading, data initialization, memory allocation** |


## System Role

**Category**: Core System
**Function**: Resource Management

Mac resource file operations
## Architecture Role

CODE 2 handles loading and initializing game resources:
1. Loading data from resources
2. Memory allocation for game buffers
3. Initial data setup

## Key Functions

### Function 0x0000 - Initialize Game Resources
```asm
0000: LINK       A6,#-16              ; 16 bytes local
0004: CLR.B      -(A7)                ; Push 0 (byte)
0006: CLR.W      -(A7)                ; Push 0 (word)
0008: PEA        -16(A6)              ; Push local buffer
000C: A971...                         ; Toolbox trap
0014: PEA        -10496(A5)           ; Push A5-10496
0018: JSR        3170(A5)             ; JT[3170]
001C: PEA        138(A5)              ; Push A5+138
0020: MOVE.W     #$0400,-(A7)         ; Push 1024
0024: JSR        3202(A5)             ; JT[3202]
0028: UNLK       A6
002A: RTS
```

**Purpose**: Initialize game resources, likely loading preferences or initial data.

### Function 0x002C - Event Handler / Update Callback
```asm
002C: LINK       A6,#-14              ; 14 bytes local
0030: MOVEM.L    A3/A4,-(SP)          ; Save registers
0034: MOVEA.L    16(A6),A3            ; A3 = param3
0038: MOVEA.L    12(A6),A4            ; A4 = param2 (event record?)
003C: CMPI.W     #$0006,(A4)          ; Check event type == 6 (update)
0040: BNE.W      $00C8                ; If not update, skip to end

; Handle update event
0044: CMP.W      2(A4),124(PC,D6.W)   ; Compare window
004A: MOVE.L     A3,-(A7)             ; Push window
004C: A873...                         ; GetPort
0050: A922                            ; SetPort
0052: MOVE.L     A3,-(A7)
0054: MOVE.L     24(A3),-(A7)         ; Push window region
0058: A978...                         ; BeginUpdate

; Set up drawing
0078: PEA        -28652(A5)           ; A5-28652
007C: A884                            ; EraseRect?
007E: MOVEA.L    -8584(A5),A0         ; Get handle
0082: A029...                         ; HLock
0094: MOVEA.L    -8584(A5),A0
0096: PEA        814(A0)              ; Push data at offset 814
009A: JSR        3522(A5)             ; JT[3522] - draw something
...
00B4: JSR        202(PC)              ; Call local function
00BE: MOVE.B     #$01,20(A6)          ; Set return flag
00E2: MOVEM.L    (SP)+,A3/A4
00E6: UNLK       A6
00E8: MOVEA.L    (A7)+,A0             ; Get return address
00EA: LEA        12(A7),A7            ; Pop params
00EE: JMP        (A0)                 ; Return
```

**C equivalent**:
```c
int handle_event(EventRecord* event, WindowPtr window, void* param3) {
    if (event->what == updateEvt) {
        SetPort(window);
        BeginUpdate(window);
        EraseRect(&rect);
        // ... draw content ...
        EndUpdate(window);
        return 1;
    }
    // Handle other events...
    return result;
}
```

### Function 0x00F0 - Load DAWG Section
```asm
00F0: LINK       A6,#-4               ; 4 bytes local
00F4: MOVE.L     A4,-(A7)             ; Save A4
00F6: PEA        -4(A6)               ; Push local
00FA: CLR.W      -(A7)                ; Push 0
00FC: MOVE.L     8(A6),-(A7)          ; Push param
0100: JSR        3386(A5)             ; JT[3386] - load resource?
0104: MOVEA.L    D0,A4                ; A4 = result
0106: MOVE.L     A4,D0
010C: BNE.S      $0134                ; If loaded, skip

; Load failed - use defaults
010E: MOVE.L     -24792(A5),-24030(A5)  ; Copy pointer
0114: ... update counters ...
011E: LEA        -24026(A5),A0         ; g_common
0122: ... setup ...
0126: MOVEQ      #1,D0
012C: MOVEQ      #1,D0
...

; Load succeeded - extract data
0134: MOVE.L     4(A4),-8588(A5)      ; Copy field_4 to A5-8588
013A: MOVE.L     8(A4),-8592(A5)      ; Copy field_8 to A5-8592
0140: LEA        12(A4),A0            ; A0 = &data[12]
0144: MOVE.L     A0,-8596(A5)         ; Store pointer
0148: MOVE.L     -8588(A5),D0         ; Get size 1
...
0164: JSR        418(A5)              ; bounds_check
0168: MOVE.L     -8592(A5),D0         ; Get size 2
...
017C: JSR        418(A5)              ; bounds_check
0180: MOVEA.L    (A7)+,A4
0182: UNLK       A6
0184: RTS
```

**Purpose**: Load a DAWG data section and validate its bounds.

### Function 0x0186 - Allocate Game Buffers
```asm
0186: MOVEM.L    D7/A4,-(SP)
018A: PEA        $0E00.W              ; Push 3584 (0xE00)
018E: JSR        1666(A5)             ; JT[1666] - NewPtr
0192: MOVE.L     D0,-11984(A5)        ; Store at A5-11984
0196: PEA        $0900.W              ; Push 2304 (0x900)
019A: JSR        1666(A5)
019E: MOVE.L     D0,-12532(A5)        ; A5-12532
01A2: PEA        $0900.W
01A6: JSR        1666(A5)
01AA: MOVE.L     D0,-12528(A5)        ; A5-12528
01AE: PEA        $0900.W
01B2: JSR        1666(A5)
01B6: MOVE.L     D0,-12524(A5)        ; A5-12524
01BA: PEA        $0900.W
01BE: JSR        1666(A5)
01C2: MOVE.L     D0,-12520(A5)        ; A5-12520
01C6: PEA        $0900.W
01CA: JSR        1666(A5)
01CE: MOVE.L     D0,-12516(A5)        ; A5-12516
01D2: PEA        $0900.W
01D6: JSR        1666(A5)
01DA: MOVE.L     D0,-12512(A5)        ; A5-12512

; Get available memory
01DE: JSR        1682(A5)             ; JT[1682] - FreeMem?
01E2: MOVE.L     D0,D7
01E4: CMPI.L     #$00002000,D7        ; If > 8KB
01EE: BGT.S      $01F6
01F0: MOVE.L     #$00002000,D7        ; Cap at 8KB
01F6: ...
01FA: CMPI.L     #$000080CE,D7        ; If > ~33KB
0200: BCC.S      $0206
0206: MOVE.L     D7,-(A7)
0208: JSR        1666(A5)             ; Allocate main buffer
020C: MOVE.L     D0,-11980(A5)        ; A5-11980
0212: MOVE.L     D7,-11976(A5)        ; Store size
0218: TST.L      D0
021C: BNE.S      $0220
021C: JSR        418(A5)              ; Error if failed

; Allocate more buffers
0220: PEA        $4400.W              ; Push 17408 (0x4400)
0224: JSR        1666(A5)
0228: MOVE.L     D0,-12536(A5)        ; A5-12536
...
0244: JSR        770(A5)              ; JT[770] - init something
024E: RTS
```

**C equivalent**:
```c
void allocate_game_buffers(void) {
    g_buffer1 = NewPtr(0xE00);   // 3584 bytes at A5-11984
    g_buffer2 = NewPtr(0x900);   // 2304 bytes at A5-12532
    g_buffer3 = NewPtr(0x900);   // at A5-12528
    g_buffer4 = NewPtr(0x900);   // at A5-12524
    g_buffer5 = NewPtr(0x900);   // at A5-12520
    g_buffer6 = NewPtr(0x900);   // at A5-12516
    g_buffer7 = NewPtr(0x900);   // at A5-12512

    long free_mem = FreeMem();
    if (free_mem > 0x2000) free_mem = 0x2000;
    if (free_mem > 0x80CE) free_mem = 0x80CE;

    g_main_buffer = NewPtr(free_mem);
    g_main_size = free_mem;
    if (g_main_buffer == NULL) error();

    g_large_buffer = NewPtr(0x4400);  // 17408 bytes
    init_data();
}
```

### Function 0x0250 - Copy Data with Parameters
```asm
0250: LINK       A6,#-8
0254: MOVE.L     8(A6),-8(A6)         ; Copy param1
025A: MOVE.W     14(A6),-4(A6)        ; Copy param2 (word)
0260: MOVE.W     16(A6),-2(A6)        ; Copy param3 (word)
0266: PEA        -8(A6)               ; Push local struct
026A: PEA        114(A5)              ; Push A5+114
026E: PEA        -28634(A5)           ; Push A5-28634
0272: MOVE.W     12(A6),-(A7)         ; Push index
0276: JSR        3218(A5)             ; JT[3218]
027C: RTS
```

### Function 0x027E - Process Data Loop
```asm
027E: LINK       A6,#-6
0282: MOVE.L     A4,-(A7)
0284: MOVEA.L    12(A6),A4            ; A4 = param2
0288: MOVE.L     (A4),-(A7)           ; Push data[0]
028A: MOVE.W     4(A4),-(A7)          ; Push data[4]
028E: MOVE.L     8(A6),-(A7)          ; Push param1
0292: JSR        3290(A5)             ; JT[3290]
...
02A6: PEA        -2(A6)               ; Local result
02AA: PEA        3210(A5)             ; Constant
...
02B8: MOVE.L     (A4),-(A7)           ; data[0]
02BA: MOVE.W     4(A4),-(A7)          ; data[4]
02BE: MOVE.L     8(A6),-(A7)          ; param1
02C2: JSR        1602(A5)             ; JT[1602]
02C6: MOVE.L     (A4),(A7)
02C8: JSR        2050(A5)             ; JT[2050]
02CC: MOVE.L     D0,(A7)
02CE: MOVE.L     (A4),-(A7)
02D0: JSR        3490(A5)             ; JT[3490] - copy to global
...
02E2: BEQ.S      $02A6                ; Loop while condition
02E4: MOVE.W     -2(A6),D0            ; Return result
02EC: RTS
```

## Memory Allocation Map

| Offset | Size | Purpose |
|--------|------|---------|
| A5-11984 | 3584 | Buffer 1 |
| A5-11980 | dynamic | Main buffer |
| A5-11976 | 4 | Main buffer size |
| A5-12532 | 2304 | Buffer 2 |
| A5-12528 | 2304 | Buffer 3 |
| A5-12524 | 2304 | Buffer 4 |
| A5-12520 | 2304 | Buffer 5 |
| A5-12516 | 2304 | Buffer 6 |
| A5-12512 | 2304 | Buffer 7 |
| A5-12536 | 17408 | Large buffer |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 418(A5) | bounds_check/error |
| 770(A5) | init_data |
| 1602(A5) | process function |
| 1666(A5) | NewPtr (memory allocation) |
| 1682(A5) | FreeMem |
| 2050(A5) | data function |
| 3170(A5) | init function |
| 3202(A5) | setup function |
| 3290(A5) | data process |
| 3386(A5) | load resource |
| 3490(A5) | copy_to_global |
| 3522(A5) | draw function |

## Confidence: HIGH

The patterns are clear:
- Memory allocation with NewPtr (A322 trap)
- Resource loading
- Buffer initialization
- Event handling
