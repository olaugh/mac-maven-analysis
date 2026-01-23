# CODE 11 Detailed Analysis - Game Controller

## Overview

| Property | Value |
|----------|-------|
| Size | 4,478 bytes |
| JT Offset | 376 |
| JT Entries | 19 |
| Functions | 29 |
| Purpose | **Main game controller, event dispatch, state machine** |

## Architecture Role

CODE 11 is the **central nervous system** of Maven:
1. Dispatches function calls via lookup tables
2. Manages callback registration
3. Controls game state machine
4. Exports core utilities (memset at JT[426], bounds_check at JT[418])

## Key Functions

### Function 0x0000 - Get Data Pointer
```asm
0000: LINK       A6,#0
0004: MOVE.L     A4,-(A7)
0006: MOVEA.L    8(A6),A4         ; A4 = param
000A: MOVE.L     A4,D0
000C: BNE.S      $0016            ; if not null, continue
000E: LEA        -27912(A5),A0    ; return default
0012: MOVE.L     A0,D0
0014: BRA.S      $0052

0016: MOVE.L     A4,-(A7)
0018: JSR        1610(A5)         ; check_something(param)
001C: TST.W      D0
0020: BEQ.S      $002A
0022: LEA        -27896(A5),A0    ; return alt if check passed
0026: MOVE.L     A0,D0
0028: BRA.S      $0052

002A: CMPI.W     #8,108(A4)       ; if param->field_108 >= 8
0030: BLT.S      $0046
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
        return &g_default_data;  // A5-27912

    if (check_something(param))
        return &g_alt_data;      // A5-27896

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
007A: JSR        (A4)             ; CALL FUNCTION POINTER!
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
        ((func_ptr)func)(p1, p3);  // Call function pointer!
    }
    return 1;
}
```

### Function 0x00A0 - Lookup in Linked List
```asm
00A0: LINK       A6,#0
00A4: MOVEM.L    D6/D7/A2-A4,-(SP)
00A8: MOVEA.L    8(A6),A4         ; A4 = list head
00AC: BRA.S      $00D8

00AE: MOVE.W     2(A4),D7         ; D7 = count
00B2: MOVEQ      #1,D6            ; D6 = 1
00B4: MOVEA.W    #8,A3            ; entry size = 8
00B8: BRA.S      $00D0

00BA: MOVEA.L    A3,A2
00BC: ADD.L      A4,A2            ; A2 = &entries[i]
00C0: CMP.L      12(A6),D0        ; compare with target
00C4: BNE.S      $00CC
00C6: MOVE.L     4(A2),D0         ; return entry->data
00CA: BRA.S      $00DE

00CC: ADDQ.W     #1,D6            ; i++
00CE: ADDQ.L     #8,A3            ; next entry
00D0: CMP.W      D6,D7
00D2: BGE.S      $00BA            ; while i <= count

00D4: MOVEA.L    4(A4),A4         ; A4 = next node
00D8: MOVE.L     A4,D0
00DA: BNE.S      $00AE            ; while node != null
00DC: MOVEQ      #0,D0            ; return null
00DE: MOVEM.L    (SP)+,...
00E2: UNLK       A6
00E4: RTS
```

**C equivalent**:
```c
void* lookup_in_list(ListNode* head, long target) {
    while (head != NULL) {
        int count = head->count;
        Entry* entries = (Entry*)(head + 1);

        for (int i = 0; i < count; i++) {
            if (entries[i].key == target) {
                return entries[i].data;
            }
        }
        head = head->next;
    }
    return NULL;
}
```

### Functions 0x014C and 0x017C - Callback Registration
```asm
; 0x14C: Check if callback registered
014C: LINK       A6,#0
0150: MOVEM.L    D7/A4,-(SP)
0154: MOVEQ      #0,D7
0156: LEA        -27800(A5),A4    ; callback table
015A: BRA.S      $016C
015C: MOVE.L     (A4),D0          ; get callback
015E: CMP.L      8(A6),D0         ; compare with param
0162: BNE.S      $0168
0164: MOVEQ      #1,D0            ; found - return 1
0166: BRA.S      $0174
0168: ADDQ.W     #1,D7
016A: ADDQ.L     #4,A4            ; next slot
016C: CMP.W      -27872(A5),D7    ; while < callback_count
0170: BLT.S      $015C
0172: MOVEQ      #0,D0            ; not found - return 0
0174: MOVEM.L    (SP)+,...
0178: UNLK       A6
017A: RTS

; 0x17C: Register callback
017C: LINK       A6,#0
0180: CMPI.W     #16,-27872(A5)   ; if count >= 16
0186: BCS.S      $018C
0188: JSR        4058(PC)         ; overflow error
018C: MOVE.W     -27872(A5),D0    ; D0 = count
0190: ADDQ.W     #1,-27872(A5)    ; count++
; ... store callback at table[count] ...
```

**C equivalent**:
```c
#define MAX_CALLBACKS 16

void* callback_table[MAX_CALLBACKS];  // A5-27800
int callback_count;                    // A5-27872

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

## Callback/Dispatch System

CODE 11 implements a callback/dispatch system:

| Global | Purpose |
|--------|---------|
| A5-27800 | Callback table (16 slots × 4 bytes) |
| A5-27872 | Callback count |
| A5-27896 | Alt data pointer |
| A5-27912 | Default data pointer |

## Jump Table Exports

CODE 11 exports important functions via the jump table:

| JT Offset | Function | Purpose |
|-----------|----------|---------|
| 418 | bounds_check | Assert/error handler |
| 426 | memset | Clear memory |
| 658 | init_subsystem | Initialization |
| 1362 | state_update | Update game state |

## Relationship to Other CODE

```
              ┌─────────────┐
              │   CODE 11   │
              │ (Controller)│
              └──────┬──────┘
                     │
     ┌───────┬───────┼───────┬───────┐
     │       │       │       │       │
     v       v       v       v       v
 CODE 3   CODE 7  CODE 21 CODE 52  Others
 (Search) (Board)  (UI)   (Flags)
```

## Confidence: HIGH

The dispatch/callback patterns are clear:
- Function pointer calls via JSR (A4)
- Linked list lookup
- Callback registration with bounds checking
- Standard controller architecture
