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

## Confidence: HIGH

The dispatch/callback patterns are well-understood:
- Function pointer calls via JSR (A4)
- Linked list lookup for dispatch tables
- Callback registration with bounds checking (max 16)
- Standard controller architecture with clear responsibilities
- Menu iteration using Mac Toolbox Resource Manager
