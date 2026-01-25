# CODE 2 Detailed Analysis - Resource & Data Loading

## Overview

| Property | Value |
|----------|-------|
| Size | 750 bytes |
| JT Offset | 80 |
| JT Entries | 4 |
| Functions | 6 |
| Purpose | **Resource loading, data initialization, memory allocation** |

## Architecture Role

CODE 2 handles loading and initializing game resources:
1. Loading game data from Mac resources
2. Memory allocation for game buffers (DAWG data, search buffers)
3. Window/event handling for drawing
4. Initial data setup

## Key Functions

### Function 0x0000 - Initialize Game Resources

```asm
0000: LINK       A6,#-16          ; 16 bytes local (Str255 buffer)
0004: CLR.B      -(A7)            ; Push 0 (prompt)
0006: CLR.W      -(A7)            ; Push 0 (reply var)
0008: PEA        -16(A6)          ; Push local buffer
000C: A971                        ; _SFGetFile (Standard File)
000E: ADDQ.W     #4,A7            ; Clean stack (4 bytes)
0010: TST.W      (A7)+            ; Check reply.good
0012: BEQ.S      $0028            ; If cancelled, skip to return
0014: PEA        -10496(A5)       ; Push g_pref_data (A5-10496)
0018: JSR        3170(A5)         ; JT[3170] - init preferences
001C: PEA        138(A5)          ; Push A5+138 (string buffer)
0020: MOVE.W     #$0400,-(A7)     ; Push 1024 (buffer size)
0024: JSR        3202(A5)         ; JT[3202] - setup_buffer
0028: UNLK       A6
002A: RTS
```

**Purpose**: Initialize game resources, showing a file dialog (SFGetFile) and loading preferences.

### Function 0x002C - Window Update Event Handler

```asm
002C: LINK       A6,#-14          ; 14 bytes local
0030: MOVEM.L    A3/A4,-(SP)      ; Save registers
0034: MOVEA.L    16(A6),A3        ; A3 = windowPtr (param3)
0038: MOVEA.L    12(A6),A4        ; A4 = event record (param2)
003C: CMPI.W     #$0006,(A4)      ; Check event->what == updateEvt (6)
0040: BNE.W      $00C8            ; If not update, check other events

; Handle update event
004A: MOVE.L     A3,-(A7)         ; Push windowPtr
004C: A873                        ; _GetPort
004E: PEA        -4(A6)           ; Push &savedPort
0050: A922                        ; _SetPort
0052: MOVE.L     A3,-(A7)
0054: MOVE.L     24(A3),-(A7)     ; Push window's visRgn
0058: A978                        ; _BeginUpdate

; Drawing section
0078: PEA        -28652(A5)       ; Push g_board_rect (A5-28652)
007C: A884                        ; _EraseRect
007E: MOVEA.L    -8584(A5),A0     ; A0 = g_dawg_handle
0082: A029                        ; _HLock
      ; (drawing calls 0x084-0x092 omitted)
0094: MOVEA.L    -8584(A5),A0     ; Dereference handle
0096: MOVEA.L    (A0),A0          ; Get pointer
009A: PEA        814(A0)          ; Push data at offset 814
      ; (draw_rack call 0x09E-0x0A2 omitted)
00A4: MOVEA.L    -8584(A5),A0
00A8: A02A                        ; _HUnlock
00AA: MOVE.L     -4(A6),-(A7)     ; Restore saved port
00AE: MOVE.L     A3,-(A7)
00B0: A923                        ; _EndUpdate

; Check other event types (not updateEvt)
00C6: TST.W      -28654(A5)       ; Check g_flag
00CA: BEQ.S      $00D8
00CC: CMPI.W     #$0001,(A4)      ; mouseDown (1)?
00D0: BEQ.S      $00DC
00D2: CMPI.W     #$0003,(A4)      ; keyDown (3)?
00D6: BEQ.S      $00DC
00D8: MOVEQ      #0,D0            ; Return 0 (not handled)
00DA: BRA.S      $00DE
00DC: MOVEQ      #1,D0            ; Return 1 (handled)
00DE: MOVE.B     D0,20(A6)        ; Store return value

00E2: MOVEM.L    (SP)+,A3/A4      ; Restore
00E6: UNLK       A6
00E8: MOVEA.L    (A7)+,A0         ; Pop return address
00EA: LEA        12(A7),A7        ; Clean 12 bytes of params
00EE: JMP        (A0)             ; Return (Pascal calling convention)
```

**C equivalent**:
```c
Boolean handle_event(void* param1, EventRecord* event, WindowPtr window) {
    if (event->what == updateEvt) {
        GrafPtr savePort;
        GetPort(&savePort);
        SetPort(window);
        BeginUpdate(window);
        EraseRect(&g_board_rect);
        HLock(g_dawg_handle);
        // Draw game content using data at handle+814
        draw_board((*g_dawg_handle) + 814);
        HUnlock(g_dawg_handle);
        EndUpdate(window);
        SetPort(savePort);
        return true;
    }

    // For other events, check if we should handle them
    if (g_flag) {
        if (event->what == mouseDown || event->what == keyDown) {
            return true;
        }
    }
    return false;
}
```

### Function 0x00F0 - Load DAWG Data Section

```asm
00F0: LINK       A6,#-4           ; 4 bytes local
00F4: MOVE.L     A4,-(A7)         ; Save A4
00F6: PEA        -4(A6)           ; Push &local
00FA: CLR.W      -(A7)            ; Push 0 (resource ID?)
00FC: MOVE.L     8(A6),-(A7)      ; Push param (resource name?)
0100: JSR        3386(A5)         ; JT[3386] - load_resource
0104: MOVEA.L    D0,A4            ; A4 = loaded handle
0106: MOVE.L     A4,D0
010C: BNE.S      $0134            ; If loaded OK, extract data

; Load failed - use default pointers
010E: MOVE.L     -24792(A5),-24030(A5)  ; Copy fallback pointer
      ; (instructions 0x114-0x132 set up default state)
011E: LEA        -24026(A5),A0    ; A0 = g_common_data
0132: BRA.S      $0180            ; Skip to return

; Load succeeded - extract fields from loaded data
; NOTE: Disassembly 0x148-0x15A is garbled; raw bytes decoded manually
0134: MOVE.L     4(A4),-8588(A5)  ; g_section1_end = data->field_4 (node count)
013A: MOVE.L     8(A4),-8592(A5)  ; g_section2_end = data->field_8 (total nodes)
0140: LEA        12(A4),A0        ; A0 = &data[12] (letter index start)
0144: MOVE.L     A0,-8596(A5)     ; g_dawg_section1_ptr = A0 (Section 1)
0148: MOVE.L     -8588(A5),D0     ; D0 = section1_end
0150: ASL.L      #2,D0            ; D0 = section1_end * 4 (byte offset)
0152: LEA        0x74(A4,D0.L),A1 ; A1 = A4 + 116 + D0 = Section 2 start
0156: MOVE.L     A1,-8600(A5)     ; g_dawg_section2_ptr = A1 (Section 2)
015A: MOVE.L     -8588(A5),D0     ; D0 = section1_end (reload for validation)
0162: BEQ.S      $0168            ; Skip check if zero
0164: JSR        418(A5)          ; bounds_check (assert)
0168: MOVE.L     -8592(A5),D0     ; D0 = section2_end
0174: CMPI.B     #$61,3(A0)       ; Check byte 3 == 'a' (0x61) - magic validation
017A: BEQ.S      $0180            ; Skip error if valid
017C: JSR        418(A5)          ; bounds_check (assert)
0180: MOVEA.L    (A7)+,A4         ; Restore A4
0182: UNLK       A6
0184: RTS
```

**Purpose**: Load DAWG dictionary data from a resource. The data structure is:
- Bytes 0-3: Header/magic
- Bytes 4-7: section1_end (number of nodes in Section 1)
- Bytes 8-11: section2_end (total node count)
- Bytes 12-115: Letter index (26 × 4 = 104 bytes)
- Bytes 116+: Node array (Section 1 nodes, then Section 2 nodes)

**Section Pointers**:
- A5-8596 = resource + 12 → Section 1 (reversed DAWG with letter index)
- A5-8600 = resource + 116 + section1_end×4 → Section 2 (forward DAWG)

### Function 0x0186 - Allocate Game Buffers

```asm
0186: MOVEM.L    D7/A4,-(SP)      ; Save registers

; Allocate fixed-size buffers
018A: PEA        $0E00.W          ; 3584 bytes
018E: JSR        1666(A5)         ; JT[1666] - NewPtr wrapper
0192: MOVE.L     D0,-11984(A5)    ; g_buffer1 = NewPtr(0xE00)

0196: PEA        $0900.W          ; 2304 bytes each
019A: JSR        1666(A5)
019E: MOVE.L     D0,-12532(A5)    ; g_buffer2

; ... repeat for buffers 3-7 at A5-12528, -12524, -12520, -12516, -12512

; Calculate dynamic buffer size based on available memory
01DE: JSR        1682(A5)         ; JT[1682] - FreeMem wrapper
01E2: MOVE.L     D0,D7            ; D7 = available memory
01E4: CMPI.L     #$00002000,D7    ; If > 8KB available
01EE: BLE.S      $01F6            ; Use 8KB minimum
01F0: MOVE.L     #$00002000,D7    ; Cap at 8KB (for search buffer)
01F6: NOP                         ; (alignment)
01FA: CMPI.L     #$000080CE,D7    ; If > 33KB available
0200: BCC.S      $0206            ; Use that
0206: MOVE.L     D7,-(A7)         ; Push calculated size
0208: JSR        1666(A5)         ; Allocate main search buffer
020C: MOVE.L     D0,-11980(A5)    ; g_search_buffer
0210: LEA        4(A7),A7         ; Clean stack
0212: MOVE.L     D7,-11976(A5)    ; g_search_buffer_size
0218: TST.L      D0               ; Check allocation succeeded
021A: BNE.S      $0220
021C: JSR        418(A5)          ; Fatal error if allocation failed

; Large DAWG/dictionary buffer
0220: PEA        $4400.W          ; 17408 bytes
0224: JSR        1666(A5)
0228: MOVE.L     D0,-12536(A5)    ; g_dawg_buffer

; Initialize data structures
0244: JSR        770(A5)          ; JT[770] - init_game_data
024E: RTS
```

**C equivalent**:
```c
void allocate_game_buffers(void) {
    // Fixed buffers for game state
    g_buffer1 = NewPtr(0xE00);     // 3584 bytes
    g_buffer2 = NewPtr(0x900);     // 2304 bytes
    g_buffer3 = NewPtr(0x900);
    g_buffer4 = NewPtr(0x900);
    g_buffer5 = NewPtr(0x900);
    g_buffer6 = NewPtr(0x900);
    g_buffer7 = NewPtr(0x900);

    // Dynamic search buffer based on available memory
    long available = FreeMem();
    if (available > 0x2000)
        available = 0x2000;        // Min 8KB
    if (available > 0x80CE)
        available = 0x80CE;        // Max 33KB

    g_search_buffer = NewPtr(available);
    g_search_buffer_size = available;
    if (g_search_buffer == NULL)
        fatal_error();

    g_dawg_buffer = NewPtr(0x4400); // 17408 bytes

    init_game_data();
}
```

### Function 0x0250 - Copy Data with Parameters

```asm
0250: LINK       A6,#-8           ; 8 bytes for local struct
0254: MOVE.L     8(A6),-8(A6)     ; local.field_0 = param1 (ptr)
025A: MOVE.W     14(A6),-4(A6)    ; local.field_4 = param2 (word)
0260: MOVE.W     16(A6),-2(A6)    ; local.field_6 = param3 (word)
0266: PEA        -8(A6)           ; Push &local struct
026A: PEA        114(A5)          ; Push A5+114 (dest buffer)
026E: PEA        -28634(A5)       ; Push g_source_data
0272: MOVE.W     12(A6),-(A7)     ; Push index
0276: JSR        3218(A5)         ; JT[3218] - copy_indexed_data
027A: UNLK       A6
027C: RTS
```

### Function 0x027E - Process Data Loop

```asm
027E: LINK       A6,#-6           ; 6 bytes local
0282: MOVE.L     A4,-(A7)         ; Save A4
0284: MOVEA.L    12(A6),A4        ; A4 = struct pointer (param2)

; Main processing loop
02A6: PEA        3210(A5)         ; Push constant/callback
02AA: PEA        -2(A6)           ; Push &result
      ; (additional setup pushes 0x2AE-0x2B6 omitted)
02B8: MOVE.L     (A4),-(A7)       ; Push struct->field_0
02BA: MOVE.W     4(A4),-(A7)      ; Push struct->field_4
02BE: MOVE.L     8(A6),-(A7)      ; Push param1
02C2: JSR        1602(A5)         ; JT[1602] - process_entry
02C6: MOVE.L     (A4),(A7)        ; Reuse stack slot
02C8: JSR        2050(A5)         ; JT[2050] - get_next
02CC: MOVE.L     D0,(A7)
02CE: MOVE.L     (A4),-(A7)
02D0: JSR        3490(A5)         ; JT[3490] - copy_to_global
02D4: LEA        10(A7),A7        ; Clean stack
02D8: TST.W      6(A4)            ; Check struct->field_6 (terminator?)
02DC: BNE.S      $02E4            ; If non-zero, exit loop
02DE: MOVEA.L    (A4),A0          ; Check if data continues
02E0: TST.B      (A0)
02E2: BEQ.S      $02A6            ; Loop if more data

02E4: MOVE.W     -2(A6),D0        ; Return result
02EC: RTS
```

## Memory Allocation Map

| Offset | Size | Purpose |
|--------|------|---------|
| A5-11984 | 3584 (0xE00) | General buffer 1 |
| A5-11980 | dynamic (8-33KB) | Main search buffer |
| A5-11976 | 4 | Search buffer size |
| A5-12536 | 17408 (0x4400) | DAWG working buffer |
| A5-12532 | 2304 (0x900) | Buffer 2 |
| A5-12528 | 2304 | Buffer 3 |
| A5-12524 | 2304 | Buffer 4 |
| A5-12520 | 2304 | Buffer 5 |
| A5-12516 | 2304 | Buffer 6 |
| A5-12512 | 2304 | Buffer 7 |

## Global Variables Referenced

| Offset | Purpose |
|--------|---------|
| A5-10496 | Preference data |
| A5-8584 | DAWG data handle |
| A5-8588 | Section 1 node count (section1_end) |
| A5-8592 | Section 2 node count (section2_end) |
| A5-8596 | **DAWG Section 1 pointer** (reversed DAWG, letter index + nodes) |
| A5-8600 | **DAWG Section 2 pointer** (forward DAWG, nodes only) |
| A5-11960 | Active DAWG pointer (set by CODE 6 from A5-8596 or A5-8600) |
| A5-28652 | Board rectangle |
| A5-28654 | Event flag |

### DAWG Pointer Relationship

```
CODE 2 initializes:
  A5-8596 = resource_base + 12      (Section 1: letter index + reversed nodes)
  A5-8600 = resource_base + 116 + section1_end*4  (Section 2: forward nodes)

CODE 6 selects active DAWG based on direction:
  Direction 0 (horizontal): A5-11960 = A5-8596 (Section 1)
  Direction 2 (alternate):  A5-11960 = A5-8600 (Section 2)
  Direction 1 (both):       Uses both sections
```

## Toolbox Traps Used

| Trap | Purpose |
|------|---------|
| A971 | SFGetFile (Standard File) |
| A873 | GetPort |
| A922 | SetPort |
| A978 | BeginUpdate |
| A923 | EndUpdate |
| A884 | EraseRect |
| A029 | HLock |
| A02A | HUnlock |

## Jump Table Calls

| JT Offset | Purpose | Confidence |
|-----------|---------|------------|
| 418(A5) | Assert/bounds check | HIGH |
| 770(A5) | Init game data | MEDIUM |
| 1602(A5) | Process entry | LOW |
| 1666(A5) | NewPtr wrapper | HIGH |
| 1682(A5) | FreeMem wrapper | HIGH |
| 2050(A5) | Get next item | LOW |
| 3170(A5) | Init preferences | MEDIUM |
| 3202(A5) | Setup buffer | MEDIUM |
| 3218(A5) | Copy indexed data | MEDIUM |
| 3290(A5) | Data process | LOW |
| 3386(A5) | Load resource | HIGH |
| 3490(A5) | Copy to global | HIGH |

## Confidence: HIGH

The patterns are clear Mac Toolbox usage:
- Memory allocation with NewPtr
- Resource loading
- Window update event handling with Begin/EndUpdate
- Handle locking for drawing
- Standard File dialog

---

## Speculative C Translation

```c
/* CODE 2 - Speculative C Translation */
/* Resource & Data Loading */

/*============================================================
 * Type Definitions for DAWG Resource
 *============================================================*/
typedef struct DAWGResource {
    long magic;              /* Offset 0: Header/magic number */
    long section1_end;       /* Offset 4: Number of nodes in Section 1 */
    long section2_end;       /* Offset 8: Total node count (both sections) */
    /* Offset 12-115: Letter index (26 entries × 4 bytes = 104 bytes) */
    /* Offset 116+: Node array (Section 1 reversed nodes, then Section 2 forward nodes) */
} DAWGResource;

typedef struct GameWindow {
    char data[770];          /* Unknown fields 0-769 */
    short direction_mode;    /* Offset 770: 0=horiz, 1=both, 2=alt */
    char data2[42];          /* Fields 772-813 */
    char rack_display[17];   /* Offset 814: Current rack for display */
} GameWindow;

/*============================================================
 * Global Variables - DAWG Pointers
 *============================================================*/
extern long   g_section1_end;           /* A5-8588: Section 1 node count */
extern long   g_section2_end;           /* A5-8592: Section 2 node count (total) */
extern char*  g_dawg_section1_ptr;      /* A5-8596: Section 1 data (letter index + reversed nodes) */
extern char*  g_dawg_section2_ptr;      /* A5-8600: Section 2 data (forward nodes) */
extern char*  g_active_dawg_base;       /* A5-11960: Currently active DAWG base (set by CODE 6) */

/*============================================================
 * Function 0x0000 - Initialize Game Resources
 * JT Offset: 80(A5)
 *============================================================*/
void init_game_resources(void) {
    SFReply file_reply;              /* -16(A6) local variable */
    Point dialog_position = {0, 0};

    /* Show Standard File dialog - possibly for dictionary file */
    /* A971 trap at 0x000C */
    SFGetFile(dialog_position,      /* where */
              "\p",                  /* prompt (empty) */
              NULL,                  /* fileFilter */
              0,                     /* numTypes */
              NULL,                  /* typeList */
              NULL,                  /* dlgHook */
              &file_reply);          /* reply -> -16(A6) */

    /* Initialize preferences from global storage */
    init_preferences(&g_pref_data);  /* JT[3170] at 0x0018 */

    /* Set up string buffer with 1KB capacity */
    setup_string_buffer(
        (char*)(A5_BASE + 138),      /* destination at A5+138 */
        0x0400                        /* 1024 bytes */
    );                               /* JT[3202] at 0x0024 */
}

/*============================================================
 * Function 0x002C - Window Update Event Handler
 * Pascal calling convention (caller cleans 12 bytes)
 *============================================================*/
pascal Boolean handle_window_event(
    long unused_param,               /* 8(A6) - not used */
    EventRecord *the_event,          /* 12(A6) -> A4 */
    WindowPtr game_window            /* 16(A6) -> A3 */
) {
    GrafPtr saved_port;              /* local variable */
    Rect clip_rect;                  /* local for clipping */

    /* Check event type */
    if (the_event->what == updateEvt) {  /* CMPI.W #6 at 0x003C */
        /* Verify the update is for our window */
        if ((WindowPtr)the_event->message != game_window) {
            return false;
        }

        /* Save current port and switch to our window */
        GetPort(&saved_port);        /* A873 trap */
        SetPort(game_window);        /* A922 trap */

        /* Begin update processing */
        BeginUpdate(game_window);    /* A978 trap at 0x0058 */
        /* Uses visRgn at offset 24 of window */

        /* Get clipping rectangle */
        /* -12(A6) to -4(A6) used for rect */
        clip_rect = game_window->portRect;  /* uncertain */

        /* Erase the board area */
        EraseRect(&g_board_rect);    /* A884 at 0x007C */

        /* Lock DAWG handle for safe access during draw */
        HLock(g_dawg_handle);        /* A029 at 0x0082 */

        /* Get pointer to window data */
        GameWindow *win_data = (GameWindow*)*g_dawg_handle;

        /* Draw board content - rack display at offset 814 */
        short rack_len = strlen(win_data->rack_display);  /* JT[3522] */
        draw_rack_display(win_data->rack_display, rack_len);

        /* Unlock handle */
        HUnlock(g_dawg_handle);      /* A02A at 0x00A8 */

        /* End update processing */
        EndUpdate(game_window);      /* A923 at 0x00AC */

        /* Check flag for special handling */
        if (g_event_flag == 0) {     /* TST.W at 0x00AE */
            do_board_refresh();      /* JSR 202(PC) */
            return true;
        }
        return false;
    }

    /* Not an update event - check for input events */
    if (g_event_flag != 0) {         /* TST.W at 0x00C6 */
        /* Intercept mouse and key events during certain states */
        if (the_event->what == mouseDown ||   /* CMPI.W #1 */
            the_event->what == keyDown) {     /* CMPI.W #3 */
            return true;  /* Event handled/intercepted */
        }
    }

    return false;  /* Let event pass through */
}

/*============================================================
 * Function 0x00F0 - Load DAWG Dictionary Data
 *============================================================*/
void load_dawg_data(const char *resource_name /* 8(A6) */) {
    Handle dawg_handle;              /* -4(A6), stored in A4 */

    /* Try to load named resource */
    dawg_handle = load_named_resource(
        resource_name,               /* 8(A6) */
        0                            /* resource ID */
    );                               /* JT[3386] at 0x0100 */

    if (dawg_handle == NULL) {       /* BNE.S $0134 */
        /* Resource load failed - use built-in defaults */
        g_dawg_ptr = g_default_dawg_ptr;     /* A5-24030 = A5-24792 */
        /* uncertain: additional fallback setup */

        /* Point to common data area */
        char *common = (char*)(A5_BASE - 24026);  /* LEA at 0x011E */
        /* Initialize with defaults */
        return;
    }

    /* Resource loaded successfully - parse DAWG header */
    char *base = (char*)*dawg_handle;

    /* Extract size fields */
    g_section1_end = *(long*)(base + 4);     /* offset 4 -> A5-8588 */
    g_section2_end = *(long*)(base + 8);     /* offset 8 -> A5-8592 */

    /* Set up Section 1 pointer (letter index + reversed DAWG nodes) */
    g_dawg_section1_ptr = base + 12;         /* LEA 12(A4) at 0x0140 -> A5-8596 */

    /* Set up Section 2 pointer (forward DAWG nodes) */
    /* Section 2 starts after: 12-byte header + 104-byte letter index + Section 1 nodes */
    /* = base + 116 + section1_end * 4 */
    g_dawg_section2_ptr = base + 116 + (g_section1_end * 4);  /* -> A5-8600 */

    /* Validate the DAWG data */
    /* Check that section1_end has certain bits set */
    if ((g_section1_end & 0x0800) == 0) {    /* uncertain bit check */
        fatal_bounds_error();                 /* JT[418] at 0x0164 */
    }

    /* Check section2_end byte 3 equals 'a' (0x61) - magic validation */
    if (((g_section2_end >> 24) & 0xFF) != 0x61) {
        fatal_bounds_error();                 /* JT[418] at 0x017C */
    }
}

/*============================================================
 * Function 0x0186 - Allocate Game Buffers
 *============================================================*/
void allocate_game_buffers(void) {
    long available_memory;           /* D7 */

    /*
     * Allocate fixed-size working buffers
     * These are used for various game operations:
     * - Move generation scratch space
     * - Search state storage
     * - Cross-check data
     */

    /* Main state buffer - 3584 bytes */
    g_state_buffer = NewPtr(0x0E00);     /* 0x018A */

    /* Six 2304-byte buffers for move candidates and search */
    /* These may be parallel search buffers for h/v directions */
    g_move_buffer_1 = NewPtr(0x0900);    /* 0x0196 -> A5-12532 */
    g_move_buffer_2 = NewPtr(0x0900);    /* 0x01A2 -> A5-12528 */
    g_move_buffer_3 = NewPtr(0x0900);    /* 0x01AE -> A5-12524 */
    g_move_buffer_4 = NewPtr(0x0900);    /* 0x01BA -> A5-12520 */
    g_move_buffer_5 = NewPtr(0x0900);    /* 0x01C6 -> A5-12516 */
    g_move_buffer_6 = NewPtr(0x0900);    /* 0x01D2 -> A5-12512 */

    /*
     * Calculate dynamic search buffer size
     * The search algorithm needs working memory proportional
     * to dictionary size and search depth
     */
    available_memory = FreeMem();        /* JT[1682] at 0x01DE */

    /* Clamp to reasonable range: 8KB minimum, ~33KB maximum */
    if (available_memory > 0x2000) {     /* 8KB */
        available_memory = 0x2000;
    }
    if (available_memory > 0x80CE) {     /* ~33KB */
        available_memory = 0x80CE;
    }

    /* Allocate search buffer */
    g_search_buffer = NewPtr(available_memory);  /* 0x0208 */
    g_search_buffer_size = available_memory;     /* 0x0212 */

    /* Fatal error if allocation failed - game cannot run */
    if (g_search_buffer == NULL) {       /* TST.L at 0x0216 */
        fatal_bounds_error();            /* JT[418] at 0x021C */
    }

    /* Large DAWG working buffer - 17KB */
    /* Used for traversal state during word generation */
    g_dawg_work_buffer = NewPtr(0x4400); /* 0x0220 */

    /*
     * Initialize from low-memory globals
     * $0910/$0911 may be cursor/system state
     */
    /* uncertain: some low-memory setup */

    /* Load DAWG dictionary (recursive call) */
    load_dawg_data(NULL);                /* JSR -336(PC) at 0x023E */

    /* Initialize game data structures */
    init_game_data();                    /* JT[770] at 0x0244 */
}

/*============================================================
 * Function 0x0250 - Copy Indexed Data Structure
 *============================================================*/
void copy_indexed_data_struct(
    void *source_ptr,                /* 8(A6) */
    short data_index,                /* 12(A6) */
    short param1,                    /* 14(A6) */
    short param2                     /* 16(A6) */
) {
    /* Build local parameter struct on stack */
    struct {
        void *ptr;                   /* -8(A6) */
        short field1;                /* -4(A6) */
        short field2;                /* -2(A6) */
    } local_params;

    local_params.ptr = source_ptr;
    local_params.field1 = param1;
    local_params.field2 = param2;

    /* Copy indexed data to global buffer */
    copy_indexed_entry(
        &g_source_table,             /* A5-28634, source */
        (char*)(A5_BASE + 114),      /* A5+114, destination */
        data_index,
        &local_params
    );                               /* JT[3218] at 0x0276 */
}

/*============================================================
 * Function 0x027E - Iterate Data Processing
 *============================================================*/
short process_data_iterator(
    void *context,                   /* 8(A6) */
    struct DataIterator *iter        /* 12(A6) -> A4 */
) {
    /*
     * DataIterator structure:
     *   Offset 0: void* current_ptr
     *   Offset 4: short type_index
     *   Offset 6: short done_flag
     */

    short result;                    /* -2(A6) */

    /* Initial processing call */
    process_data_entry(
        context,
        iter->type_index,            /* 4(A4) */
        iter->current_ptr            /* (A4) */
    );                               /* JT[3290] at 0x0292 */

    get_data_value(context, iter->type_index);  /* JT[3234] */

    /* Main iteration loop */
    do {
        /* Push callback reference - uncertain purpose */
        /* A991 trap - possibly GetResource variant */

        /* Check termination condition */
        if (/* some condition */ 0) {  /* uncertain */
            break;
        }

        /* Process current entry */
        process_single_entry(
            context,
            iter->type_index,
            iter->current_ptr
        );                           /* JT[1602] at 0x02C2 */

        /* Advance to next entry */
        void *next_ptr = get_next_entry(iter->current_ptr);  /* JT[2050] */

        /* Copy result to global storage */
        copy_to_global(next_ptr, iter->current_ptr);         /* JT[3490] */

        /* Check done flag */
        if (iter->done_flag != 0) {  /* TST.W 6(A4) at 0x02D8 */
            break;
        }

        /* Check if data continues (null terminator) */
    } while (*(char*)iter->current_ptr != '\0');  /* TST.B (A0) */

    return result;
}
```
