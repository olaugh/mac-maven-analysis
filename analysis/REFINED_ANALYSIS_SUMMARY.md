# Maven Refined Analysis Summary

## Major Discoveries from Second Pass

### 1. CODE 52 is the DAWG Flag Accessor Library

**Critical finding**: CODE 52 contains 14 nearly-identical functions that extract different bit fields from DAWG entries. This is the low-level interface to DAWG data.

| Function | Mask | Purpose |
|----------|------|---------|
| JT[3464] | 0x80 | **End-of-word flag** (bit 7) |
| JT[3440] | 0x03 | **Terminal/sibling flags** (bits 0-1) |
| JT[3432] | 0xC0 | High flags (bits 6-7) |
| JT[3448] | 0x10 | Flag bit 4 |
| ... | ... | Various combinations |

This explains why 23 CODE segments call CODE 52 - it's the **only way to access DAWG entry flags**.

### 2. CODE 9 is the Runtime Support Library

CODE 9 contains 37 utility functions:
- Memory allocation wrappers (NewHandle, DisposePtr)
- Cursor management (SetCursor, InitCursor)
- Time functions (TickCount, elapsed time)
- Global pointer accessors
- Port management

### 3. CODE 34 is String/System Utilities

CODE 34 provides:
- Pascal ↔ C string conversion
- System detection via Gestalt
- Environment block initialization
- Called by 12 segments for string handling

### 4. CODE 30 is the DAWG Traversal Engine

CODE 30 contains the actual tree-walking code:
- 1766-byte stack frame for search state
- Copies g_dawg_info to local storage
- Clears 340-byte working buffer (g_dawg_field)
- Performs compare operations during traversal
- Returns results via g_dawg_field pointer

### 5. CODE 3 is the Search Coordinator

CODE 3 orchestrates searches:
- 2282-byte and 2968-byte frames for state
- Manages hook-before/hook-after buffer selection
- Validates DAWG bounds
- Calls CODE 30 for actual traversal
- Handles result processing

## Revised Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    APPLICATION LAYER                        │
├─────────────────────────────────────────────────────────────┤
│  CODE 11 (Game Controller)  │  CODE 21 (Main UI - 13KB)    │
│  - State machine            │  - Display board             │
│  - Turn management          │  - Show moves                │
│  - Coordinates all          │  - User interaction          │
├─────────────────────────────────────────────────────────────┤
│                      AI ENGINE                              │
├─────────────────────────────────────────────────────────────┤
│  CODE 3 (Coordinator)       │  CODE 7 (Board State)        │
│  - Setup search params      │  - g_field_14 (hook-before)     │
│  - Select hook direction     │  - g_field_22 (hook-after)   │
│  - Manage 34-byte info      │  - Rack management           │
├─────────────────────────────┼───────────────────────────────┤
│  CODE 30 (Traversal)        │  CODE 22 (Processing)        │
│  - Walk DAWG tree           │  - Post-search processing    │
│  - Match words              │  - Score calculation?        │
│  - Return results           │                              │
├─────────────────────────────────────────────────────────────┤
│                    DAWG DATA ACCESS                         │
├─────────────────────────────────────────────────────────────┤
│  CODE 52 (Flag Accessors)   │  Supporting Segments         │
│  - is_end_of_word()         │  CODE 5, 6, 8, 14, 15, 18   │
│  - is_terminal()            │  CODE 27-31, 36, 38, etc.   │
│  - get_flags()              │                              │
├─────────────────────────────────────────────────────────────┤
│                    SUPPORT LAYER                            │
├─────────────────────────────────────────────────────────────┤
│  CODE 9 (Runtime)   │  CODE 34 (Strings)  │  CODE 24 (File) │
│  - Memory           │  - P↔C strings      │  - Save/Load    │
│  - Time             │  - System detect    │  - SFGetFile    │
│  - Cursors          │  - Gestalt          │                 │
├─────────────────────────────────────────────────────────────┤
│  CODE 0: Jump Table (routes calls between segments)        │
└─────────────────────────────────────────────────────────────┘
```

## Key Global Variables Map

### DAWG Data Pointers
| Offset | Name | Size | Purpose |
|--------|------|------|---------|
| A5-23090 | g_dawg_info | 34 bytes | DAWG configuration structure |
| A5-23074 | g_dawg_ptr | 4 bytes | Main DAWG data pointer |
| A5-23070 | g_sect1_off | 4 bytes | Section 1 offset |
| A5-23066 | g_sect2_off | 4 bytes | Section 2 offset |
| A5-23056 | g_dawg_field | 340 bytes | Working/result buffer |
| A5-11972 | g_dawg_ptr2 | 4 bytes | Secondary DAWG pointer |

### Board Buffers
| Offset | Name | Paired Size | Direction |
|--------|------|-------------|-----------|
| A5-15514 | g_field_14 | g_size1 (56630) | Vertical |
| A5-15522 | g_field_22 | g_size2 (65536) | Horizontal |
| A5-15498 | g_current_ptr | - | Active buffer |

### Game State
| Offset | Name | Purpose |
|--------|------|---------|
| A5-8604 | g_game_mode | State: 0=idle, 4=AI, 5=end |
| A5-8510 | g_window_ptr | Main window |
| A5-8584 | g_handle | Data handle |

### Working Storage
| Offset | Size | Purpose |
|--------|------|---------|
| A5-17420 | 256 bytes | Search buffer |
| A5-23674 | 2 bytes | Counter/index |
| A5-24026 | varies | Common data (g_common) |
| A5-24030 | 4 bytes | State pointer |
| A5-25752 | 4 bytes | Compare pointer |

## CODE Resource Classification (Refined)

### Tier 1: Core AI (Must Understand)
| CODE | Size | Key Role |
|------|------|----------|
| 3 | 4,390 | Search coordinator |
| 7 | 2,872 | Board state |
| 11 | 4,478 | Game controller |
| 30 | 3,492 | DAWG traversal |
| 52 | 938 | Flag accessors |

### Tier 2: Supporting AI
| CODE | Size | Key Role |
|------|------|----------|
| 22 | 2,056 | Post-search |
| 36 | 9,102 | Large DAWG (scoring?) |
| 21 | 13,718 | UI + game logic |

### Tier 3: Infrastructure
| CODE | Size | Key Role |
|------|------|----------|
| 9 | 3,940 | Runtime library |
| 34 | 1,388 | String utilities |
| 24 | 6,786 | File I/O |

### Tier 4: Utilities
All other CODE segments - dialogs, UI helpers, etc.

## DAWG Entry Structure (Confirmed)

```c
typedef struct DawgEntry {
    uint16_t child_ptr;    // Offset 0-1: Index to child group
    uint8_t  flags;        // Offset 2: Bit flags
    char     letter;       // Offset 3: ASCII letter
} DawgEntry;  // 4 bytes total

// Flag bits (from CODE 52 analysis):
#define FLAG_END_OF_WORD  0x80  // Bit 7: This path is a complete word
#define FLAG_TERMINAL     0x01  // Bit 0: Last sibling at this level
// Other bits still being decoded...
```

## Search Flow (Reconstructed)

1. **Game Controller (CODE 11)** initiates search
2. **Coordinator (CODE 3)** sets up:
   - Copies parameters to g_dawg_info
   - Selects buffer (g_field_14 or g_field_22)
   - Validates DAWG bounds
3. **Traversal (CODE 30)** walks the tree:
   - Copies g_dawg_info to local storage
   - Clears g_dawg_field working buffer
   - Uses **CODE 52** to check flags
   - Stores results in g_dawg_field
4. **Results** returned via g_dawg_field pointer
5. **UI (CODE 21)** displays found moves

## Confidence Assessment

| Component | Confidence | Evidence |
|-----------|------------|----------|
| CODE 52 = flag accessors | **VERY HIGH** | Identical pattern with different masks |
| CODE 9 = runtime | **HIGH** | Toolbox wrappers, standard patterns |
| CODE 34 = strings | **HIGH** | Clear P↔C conversion, Gestalt |
| CODE 30 = traversal | **HIGH** | 34-byte copy, large frame, compare calls |
| CODE 3 = coordinator | **HIGH** | Buffer selection, validation |
| Exact algorithm | **MEDIUM** | Need deeper analysis |
| Scoring system | **LOW** | Not yet located |

## Next Steps

1. **Decode remaining flag bits** in CODE 52
2. **Trace JT[362]** - likely the actual node iteration
3. **Find scoring code** - probably in CODE 36
4. **Map complete state machine** in CODE 11
5. **Extract word list** from DAWG data

## Files Updated

- `analysis/detailed/code3_detailed.md` - Coordinator analysis
- `analysis/detailed/code9_detailed.md` - Runtime library
- `analysis/detailed/code30_detailed.md` - Traversal engine
- `analysis/detailed/code34_detailed.md` - String utilities
- `analysis/detailed/code52_detailed.md` - **Flag accessors (key discovery)**
- `analysis/code_analyses/01_refined_analysis.md` - Second pass summary
