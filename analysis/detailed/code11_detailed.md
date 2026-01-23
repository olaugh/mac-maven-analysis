# CODE 11 Detailed Analysis - Game Controller

## Overview

| Property | Value |
|----------|-------|
| Size | 4,478 bytes |
| JT Offset | 376 |
| JT Entries | 19 |
| Functions | 29+ |
| Purpose | **Central game controller, callback dispatch, state machine** |

## System Role

**Category**: Core System
**Function**: Game Controller

Central dispatch hub for Maven. Manages callback registration, function pointer dispatch, and coordinates between subsystems. Exports key utilities including JT[418] (bounds_check) and JT[426] (memset).

**Related CODE resources**:
- CODE 21 (main game loop)
- CODE 3 (search coordinator)
- CODE 7 (board display)

## Architecture Role

CODE 11 serves as the **central nervous system** of Maven:
1. Dispatches function calls via lookup tables and function pointers
2. Manages callback registration (up to 16 callbacks)
3. Controls game state machine transitions
4. Exports core utilities used throughout the application
5. Handles menu iteration and event routing

## Key Data Structures

### Callback Table
```c
// Located at A5-27800
void* callback_table[16];   // 16 callback slots, 4 bytes each
short callback_count;       // At A5-27872, current registration count
```

### Dispatch Node Structure
```c
struct DispatchNode {
    void* next;         // Offset 0: Link to next node
    short count;        // Offset 2: Number of entries
    // Followed by count entries of 12 bytes each:
    struct {
        long key;       // Offset 0: Lookup key
        void* data;     // Offset 4: Associated data
        void* func;     // Offset 8: Function pointer
    } entries[];
};
```

## Key Functions

### Function 0x0000 - Get Data Pointer
```asm
0000: LINK       A6,#0
0004: MOVE.L     A4,-(A7)
0006: MOVEA.L    8(A6),A4         ; A4 = param
000A: MOVE.L     A4,D0
000C: BNE.S      $0016            ; if not null, continue
000E: LEA        -27912(A5),A0    ; return default data ptr
0012: MOVE.L     A0,D0
0014: BRA.S      $0052

0016: MOVE.L     A4,-(A7)
0018: JSR        1610(A5)         ; JT[1610] - check_something(param)
001C: TST.W      D0
0020: BEQ.S      $002A            ; if check failed
0022: LEA        -27896(A5),A0    ; return alt data ptr
0026: MOVE.L     A0,D0
0028: BRA.S      $0052

002A: CMPI.W     #8,108(A4)       ; if param->field_108 >= 8
0030: BGE.S      $0046
0032: BTST       #1,109(A4)       ; and bit 1 of field_109 set
0038: BEQ.S      $004C
003A: MOVE.L     A4,-(A7)
003C: JSR        270(PC)          ; and check_mode() passes
0040: TST.W      D0
0044: BEQ.S      $004C
0046: MOVE.L     152(A4),D0       ; return param->field_152
004A: BRA.S      $0052
004C: LEA        -27896(A5),A0    ; else return alt
0050: MOVE.L     A0,D0
0052: MOVEA.L    (A7)+,A4
0054: UNLK       A6
0056: RTS
```

**C equivalent**:
```c
void* get_data_ptr(void* param) {
    if (param == NULL)
        return &g_default_data;      // A5-27912

    if (check_something(param))      // JT[1610]
        return &g_alt_data;          // A5-27896

    if (param->field_108 >= 8 &&
        (param->field_109 & 2) &&
        check_mode(param)) {
        return param->field_152;
    }

    return &g_alt_data;
}
```

### Function 0x0058 - Call with Data Pointer
```asm
0058: LINK       A6,#0
005C: MOVE.L     A4,-(A7)
005E: MOVE.L     12(A6),-(A7)     ; push param2
0062: MOVE.L     8(A6),-(A7)      ; push param1
0066: JSR        30(PC)           ; call get_data_ptr
006A: MOVEA.L    D0,A4            ; A4 = result
006C: MOVE.L     A4,D0
0070: BEQ.S      $007E            ; if null, skip
0072: MOVE.L     16(A6),-(A7)     ; push param3
0076: MOVE.L     8(A6),-(A7)      ; push param1
007A: JSR        (A4)             ; CALL FUNCTION POINTER
007E: MOVEQ      #1,D0            ; return 1
0080: MOVEA.L    (A7)+,A4
0082: UNLK       A6
0084: RTS
```

**C equivalent**:
```c
int call_with_data(void* p1, void* p2, void* p3) {
    void* func = get_data_ptr(p1, p2);
    if (func != NULL) {
        ((func_ptr)func)(p1, p3);  // Indirect function call
    }
    return 1;
}
```

### Function 0x00A0 - Lookup in Linked List
```asm
00A0: LINK       A6,#0
00A4: MOVEM.L    D6/D7/A2/A3/A4,-(SP)
00A8: MOVEA.L    8(A6),A4         ; A4 = list head
00AC: BRA.S      $00D8

00AE: MOVE.W     2(A4),D7         ; D7 = count
00B2: MOVEQ      #1,D6            ; D6 = 1 (starting index)
00B4: MOVEA.W    #8,A3            ; entry offset starts at 8
00B8: BRA.S      $00D0

00BA: MOVEA.L    A3,A2
00BC: ADD.L      A4,A2            ; A2 = &entries[i]
00C0: CMP.L      12(A6),D0        ; compare with target key
00C4: BNE.S      $00CC
00C6: MOVE.L     4(A2),D0         ; FOUND: return entry->data
00CA: BRA.S      $00DE

00CC: ADDQ.W     #1,D6            ; i++
00CE: ADDQ.L     #8,A3            ; next entry (8 bytes each)
00D0: CMP.W      D6,D7
00D2: BGE.S      $00BA            ; while i <= count

00D4: MOVEA.L    4(A4),A4         ; A4 = next node in list
00D8: MOVE.L     A4,D0
00DA: BNE.S      $00AE            ; while node != null
00DC: MOVEQ      #0,D0            ; NOT FOUND: return null
00DE: MOVEM.L    (SP)+,D6/D7/A2/A3/A4
00E2: UNLK       A6
00E4: RTS
```

**C equivalent**:
```c
void* lookup_in_list(DispatchNode* head, long target_key) {
    while (head != NULL) {
        int count = head->count;
        Entry* entries = (Entry*)((char*)head + 8);

        for (int i = 0; i < count; i++) {
            if (entries[i].key == target_key) {
                return entries[i].data;
            }
        }
        head = head->next;
    }
    return NULL;
}
```

### Function 0x014C - Check if Callback Registered
```asm
014C: LINK       A6,#0
0150: MOVEM.L    D7/A4,-(SP)
0154: MOVEQ      #0,D7            ; D7 = index
0156: LEA        -27800(A5),A4    ; A4 = callback_table
015A: BRA.S      $016C
015C: MOVE.L     (A4),D0          ; get callback[i]
015E: CMP.L      8(A6),D0         ; compare with param
0162: BNE.S      $0168
0164: MOVEQ      #1,D0            ; FOUND: return 1
0166: BRA.S      $0174
0168: ADDQ.W     #1,D7            ; i++
016A: ADDQ.L     #4,A4            ; next slot
016C: CMP.W      -27872(A5),D7    ; while i < callback_count
0170: BLT.S      $015C
0172: MOVEQ      #0,D0            ; NOT FOUND: return 0
0174: MOVEM.L    (SP)+,D7/A4
0178: UNLK       A6
017A: RTS
```

### Function 0x017C - Register Callback
```asm
017C: LINK       A6,#0
0180: CMPI.W     #16,-27872(A5)   ; if count >= 16
0186: BCS.S      $018C
0188: JSR        4058(PC)         ; overflow_error()
018C: MOVE.W     -27872(A5),D0    ; D0 = current count
0190: ADDQ.W     #1,-27872(A5)    ; count++
; ... index calculation and store callback at table[count] ...
01A2: UNLK       A6
01A4: RTS
```

**C equivalent**:
```c
#define MAX_CALLBACKS 16

void* callback_table[MAX_CALLBACKS];  // A5-27800
short callback_count;                  // A5-27872

int is_callback_registered(void* cb) {
    for (int i = 0; i < callback_count; i++) {
        if (callback_table[i] == cb)
            return 1;
    }
    return 0;
}

void register_callback(void* cb) {
    if (callback_count >= MAX_CALLBACKS)
        overflow_error();
    callback_table[callback_count++] = cb;
}
```

### Function 0x01A6 - Unregister Callback
```asm
01A6: LINK       A6,#0
01AA: MOVEM.L    D7/A4,-(SP)
01AE: MOVEQ      #0,D7            ; D7 = index
01B0: LEA        -27800(A5),A4    ; callback_table
; ... search for callback ...
; ... if found, remove by shifting remaining entries ...
01C8: CMP.W      -27872(A5),D7    ; bounds check
01CC: BNE.S      $01D2
01CE: JSR        3988(PC)         ; error if not found
; ... decrement count, compact array ...
020C: RTS
```

### Function 0x02D2 - Menu Iteration Handler
```asm
02D2: LINK       A6,#-262         ; Large local frame
02D6: MOVEM.L    D7/A4,-(SP)
02DA: CLR.W      -(A7)
02DC: MOVE.L     #'MENU',-(A7)    ; Resource type 'MENU'
02E2: A80D                        ; CountResources trap
02E4: MOVE.W     (A7)+,D7         ; D7 = menu count
02E6: BRA.S      $0336            ; Start loop

02E8: CLR.B      -(A7)
02EA: A99B                        ; GetIndResource trap
; ... get menu resource ...
02F2: MOVE.L     #'MENU',-(A7)
02F4: MOVE.W     D7,-(A7)
02F6: A80E                        ; GetIndResource
; ... process each menu item ...
0320: MOVEA.L    8(A6),A0         ; Get callback
0322: JSR        (A0)             ; Call callback(menuID)
; ... continue loop ...
0334: DBF        D7,$02E8         ; while --D7 >= 0
033A: MOVEM.L    (SP)+,D7/A4
033E: UNLK       A6
0340: RTS
```

## Callback/Dispatch System

CODE 11 implements a flexible callback/dispatch system:

| Global | Size | Purpose |
|--------|------|---------|
| A5-27800 | 64 bytes | Callback table (16 slots x 4 bytes) |
| A5-27804 | 4 bytes | Current dispatch target |
| A5-27872 | 2 bytes | Callback count |
| A5-27896 | 4 bytes | Alternate data pointer |
| A5-27912 | 4 bytes | Default data pointer |
| A5-1330 | 4 bytes | Secondary dispatch pointer |
| A5-1326 | 4 bytes | Tertiary dispatch pointer |

## Jump Table Exports

CODE 11 exports important functions via the jump table:

| JT Offset | Function | Purpose |
|-----------|----------|---------|
| 418 | bounds_check | Assert/error handler for invalid conditions |
| 426 | memset | Clear memory blocks |
| 658 | init_subsystem | System initialization |
| 1362 | state_update | Update game state |
| 1610 | check_something | Validation function |

## Toolbox Traps Used

| Trap | Purpose |
|------|---------|
| A80D | CountResources |
| A80E | GetIndResource |
| A917 | GetWMgrPort |
| A918 | LocalToGlobal |
| A92C | TrackControl |
| A937 | DisposeMenu |
| A939 | HiliteMenu |
| A93A | DrawMenuBar |
| A946 | GetIndString |
| A949 | GetResource |
| A950 | FrontWindow |
| A99B | GetIndResource |

## Relationship to Other CODE

```
                ┌─────────────┐
                │   CODE 11   │
                │ (Controller)│
                └──────┬──────┘
                       │
        ┌──────┬───────┼───────┬───────┐
        │      │       │       │       │
        v      v       v       v       v
    CODE 3  CODE 7  CODE 21  CODE 52  Others
   (Search) (Board)   (UI)   (Flags)
```

## Global Variables Summary

| Offset | Type | Name | Purpose |
|--------|------|------|---------|
| A5-1326 | long | dispatch_ptr_2 | Secondary dispatch pointer |
| A5-1330 | long | dispatch_ptr_1 | Primary dispatch pointer |
| A5-27800 | long[16] | callback_table | Registered callbacks |
| A5-27804 | long | current_target | Current dispatch target |
| A5-27872 | short | callback_count | Number of registered callbacks |
| A5-27896 | long | alt_data_ptr | Alternative data pointer |
| A5-27912 | long | default_data_ptr | Default data pointer |

## Speculative C Translation

### Header Definitions
```c
/* CODE 11 - Game Controller
 * Central dispatch hub for Maven game engine.
 * Manages callbacks, function pointer dispatch, and subsystem coordination.
 */

#include <MacTypes.h>
#include <Resources.h>
#include <Menus.h>

/*========== Constants ==========*/
#define MAX_CALLBACKS           16
#define DISPATCH_ENTRY_SIZE     12      /* bytes per dispatch table entry */

/*========== Data Structures ==========*/

/* Dispatch table node - linked list of function dispatch entries */
typedef struct DispatchNode {
    struct DispatchNode* next;          /* Offset 0: Link to next node */
    short entry_count;                  /* Offset 4: Number of entries in this node */
    /* Followed by entry_count entries: */
} DispatchNode;

/* Individual dispatch entry within a node */
typedef struct DispatchEntry {
    long lookup_key;                    /* Offset 0: Key for lookup */
    void* associated_data;              /* Offset 4: Data pointer */
    void* handler_func;                 /* Offset 8: Function pointer to call */
} DispatchEntry;

/* Game context structure (partial - fields at specific offsets) */
typedef struct GameContext {
    /* ... fields up to offset 108 ... */
    char padding[108];
    short mode_flags;                   /* Offset 108: Mode/state flags */
    char feature_bits;                  /* Offset 109: Feature bit flags */
    /* ... more fields ... */
    char padding2[42];
    void* handler_ptr;                  /* Offset 152: Handler function pointer */
} GameContext;

/*========== Global Variables (A5-relative) ==========*/
extern void*  g_callback_table[MAX_CALLBACKS];  /* A5-27800: Registered callbacks */
extern short  g_callback_count;                  /* A5-27872: Current callback count */
extern void*  g_dispatch_target;                 /* A5-27804: Current dispatch target */
extern void*  g_default_data_ptr;                /* A5-27912: Default handler data */
extern void*  g_alt_data_ptr;                    /* A5-27896: Alternate handler data */
extern void*  g_primary_dispatch_ptr;            /* A5-1330: Primary dispatch pointer */
extern void*  g_secondary_dispatch_ptr;          /* A5-1326: Secondary dispatch pointer */
```

### Core Dispatch Functions
```c
/*
 * get_handler_data_ptr - Retrieve appropriate handler data pointer
 *
 * Determines which data pointer to use based on context state.
 * Returns default, alternate, or context-specific handler.
 *
 * @param context: Game context structure (may be NULL)
 * @return: Appropriate data pointer for dispatch
 */
void* get_handler_data_ptr(GameContext* context) {
    /* NULL context -> return default data pointer */
    if (context == NULL) {
        return g_default_data_ptr;      /* A5-27912 */
    }

    /* Check if context requires special handling via JT[1610] */
    if (check_context_validity(context)) {  /* uncertain: exact check unknown */
        return g_alt_data_ptr;          /* A5-27896 */
    }

    /* Check mode and feature flags for custom handler */
    if (context->mode_flags >= 8 &&
        (context->feature_bits & 0x02) &&   /* Bit 1 set */
        verify_mode_active(context)) {       /* uncertain: PC-relative call */
        return context->handler_ptr;    /* Custom handler at offset 152 */
    }

    return g_alt_data_ptr;
}

/*
 * dispatch_with_context - Call handler through data pointer
 *
 * Retrieves appropriate handler and calls it with provided parameters.
 * Always returns 1 (success indicator).
 *
 * @param context: Game context for handler lookup
 * @param param1: First parameter passed to handler
 * @param param2: Second parameter passed to handler
 * @return: Always returns 1
 */
int dispatch_with_context(GameContext* context, void* param1, void* param2) {
    typedef void (*HandlerFunc)(GameContext*, void*);

    HandlerFunc handler = (HandlerFunc)get_handler_data_ptr(context);

    if (handler != NULL) {
        handler(context, param2);       /* Indirect call via JSR (A4) */
    }

    return 1;
}

/*
 * lookup_dispatch_entry - Search linked dispatch tables for key
 *
 * Traverses linked list of dispatch nodes looking for matching key.
 * Each node contains multiple 12-byte entries (key, data, func).
 *
 * @param list_head: Head of dispatch node linked list
 * @param target_key: Key value to search for
 * @return: Associated data pointer if found, NULL otherwise
 */
void* lookup_dispatch_entry(DispatchNode* list_head, long target_key) {
    DispatchNode* current_node = list_head;

    while (current_node != NULL) {
        int entry_count = current_node->entry_count;
        DispatchEntry* entries = (DispatchEntry*)((char*)current_node + 8);

        /* Search all entries in this node */
        for (int i = 0; i < entry_count; i++) {
            if (entries[i].lookup_key == target_key) {
                return entries[i].associated_data;  /* Found! */
            }
        }

        /* Move to next node in chain */
        current_node = current_node->next;
    }

    return NULL;    /* Not found */
}
```

### Callback Management Functions
```c
/*
 * is_callback_registered - Check if callback already in table
 *
 * Linear search through callback table to find matching pointer.
 *
 * @param callback_ptr: Callback function pointer to search for
 * @return: 1 if found, 0 if not registered
 */
int is_callback_registered(void* callback_ptr) {
    for (int i = 0; i < g_callback_count; i++) {
        if (g_callback_table[i] == callback_ptr) {
            return 1;   /* Found */
        }
    }
    return 0;   /* Not found */
}

/*
 * register_callback - Add callback to table
 *
 * Adds callback pointer to next available slot.
 * Calls overflow_error() if table is full (16 max).
 *
 * @param callback_ptr: Callback function to register
 */
void register_callback(void* callback_ptr) {
    if (g_callback_count >= MAX_CALLBACKS) {
        overflow_error();   /* PC-relative call at 0x4058 */
        return;             /* uncertain: may not return */
    }

    g_callback_table[g_callback_count] = callback_ptr;
    g_callback_count++;
}

/*
 * unregister_callback - Remove callback from table
 *
 * Finds callback in table, removes it by compacting array.
 * Calls error handler if callback not found.
 *
 * @param callback_ptr: Callback function to remove
 */
void unregister_callback(void* callback_ptr) {
    int found_index = -1;

    /* Find the callback */
    for (int i = 0; i < g_callback_count; i++) {
        if (g_callback_table[i] == callback_ptr) {
            found_index = i;
            break;
        }
    }

    if (found_index < 0) {
        not_found_error();      /* PC-relative call at 0x3988 */
        return;
    }

    /* Compact array by shifting remaining entries */
    for (int i = found_index; i < g_callback_count - 1; i++) {
        g_callback_table[i] = g_callback_table[i + 1];
    }

    g_callback_count--;
}

/*
 * invoke_all_callbacks - Call all registered callbacks
 *
 * Iterates through callback table and invokes each one.
 * uncertain: exact parameter passing convention
 *
 * @param event_data: Data to pass to each callback
 */
void invoke_all_callbacks(void* event_data) {
    typedef void (*CallbackFunc)(void*);

    for (int i = 0; i < g_callback_count; i++) {
        CallbackFunc cb = (CallbackFunc)g_callback_table[i];
        if (cb != NULL) {
            cb(event_data);
        }
    }
}
```

### Menu Iteration Handler
```c
/*
 * iterate_all_menus - Process all MENU resources with callback
 *
 * Uses Resource Manager to enumerate all MENU resources,
 * then calls provided callback for each menu's items.
 *
 * @param menu_callback: Function to call for each menu
 * @param user_data: Context data passed to callback
 */
void iterate_all_menus(void (*menu_callback)(short menuID, void* data),
                       void* user_data) {
    short menu_count;
    Handle menu_handle;
    short menu_id;
    char local_buffer[256];     /* Stack frame: -262 bytes */

    /* Count MENU resources */
    menu_count = CountResources('MENU');

    /* Process each menu resource */
    for (short i = menu_count; i >= 1; i--) {  /* DBF counts down */
        menu_handle = GetIndResource('MENU', i);

        if (menu_handle != NULL) {
            /* Extract menu ID from resource */
            /* uncertain: exact menu structure parsing */
            MenuHandle mh = (MenuHandle)menu_handle;
            menu_id = (**mh).menuID;

            /* Call the provided callback */
            menu_callback(menu_id, user_data);
        }
    }
}

/*
 * process_menu_command - Handle menu selection
 *
 * Dispatches menu command to appropriate handler based on menu ID.
 * Uses dispatch table lookup for extensible command handling.
 *
 * @param menu_id: Selected menu's ID
 * @param item_num: Selected item number within menu
 */
void process_menu_command(short menu_id, short item_num) {
    long menu_key = ((long)menu_id << 16) | item_num;

    /* Look up handler in dispatch table */
    void* handler_data = lookup_dispatch_entry(
        (DispatchNode*)g_primary_dispatch_ptr,
        menu_key
    );

    if (handler_data != NULL) {
        /* uncertain: exact dispatch mechanism */
        dispatch_with_context(NULL, handler_data, NULL);
    }

    /* Unhighlight menu after processing */
    HiliteMenu(0);
}
```

### Utility Functions
```c
/*
 * bounds_check_assert - Validate value is within expected range
 *
 * Called when validation fails - likely shows error dialog and aborts.
 * Exported via JT[418] for use throughout the application.
 */
void bounds_check_assert(void) {
    /* uncertain: exact error handling behavior */
    /* Likely shows alert dialog then exits or throws exception */
    SysBeep(10);
    /* May call ExitToShell() or DebugStr() */
}

/*
 * clear_memory_block - Zero-fill memory region
 *
 * Exported via JT[426] - standard memset(ptr, 0, size).
 *
 * @param dest: Destination pointer
 * @param byte_count: Number of bytes to clear
 */
void clear_memory_block(void* dest, long byte_count) {
    char* p = (char*)dest;
    while (byte_count-- > 0) {
        *p++ = 0;
    }
}

/*
 * init_controller_subsystem - Initialize game controller
 *
 * Sets up callback tables, dispatch pointers, and related state.
 * Called during application startup.
 */
void init_controller_subsystem(void) {
    /* Clear callback table */
    clear_memory_block(g_callback_table, MAX_CALLBACKS * sizeof(void*));
    g_callback_count = 0;

    /* Initialize dispatch pointers */
    g_primary_dispatch_ptr = NULL;      /* uncertain: actual initial value */
    g_secondary_dispatch_ptr = NULL;
    g_dispatch_target = NULL;

    /* uncertain: additional initialization steps */
}
```

### State Machine Control
```c
/*
 * update_game_state - Transition game state machine
 *
 * Exported via JT[1362]. Handles state transitions and
 * notifies registered callbacks of state changes.
 *
 * @param new_state: Target state to transition to
 * @param transition_data: Context for the transition
 */
void update_game_state(short new_state, void* transition_data) {
    /* uncertain: exact state machine implementation */

    /* Validate state transition */
    /* uncertain: state validation logic */

    /* Update current state */
    /* uncertain: where state is stored */

    /* Notify callbacks of state change */
    invoke_all_callbacks(transition_data);
}
```

## Confidence: HIGH

The dispatch/callback patterns are well-understood:
- Function pointer calls via JSR (A4)
- Linked list lookup for dispatch tables
- Callback registration with bounds checking (max 16)
- Standard controller architecture with clear responsibilities
- Menu iteration using Mac Toolbox Resource Manager
