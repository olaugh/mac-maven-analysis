# CODE 2 Analysis - Resource & Window Management

## Overview

| Property | Value |
|----------|-------|
| Size | 750 bytes (0x02EE) |
| JT Offset | 80 (0x0050) |
| JT Entries | 4 |
| Functions | 5 |
| Categories | UI_SUPPORT, RESOURCE |
| Purpose | File dialogs, window updates, resource management |
| Confidence | **HIGH** |

## Header

```
Offset 0x00: 0050 = JT offset: 80
Offset 0x02: 0004 = JT entries: 4
Code starts at offset 0x04
```

## Complete Disassembly

### Function 1: file_dialog_handler at 0x0004 (JT[80])

Standard File dialog handler for file selection.

```asm
0004: 4E56 FFF0     LINK     A6,#-16         ; 16 bytes local
0008: 4227          CLR.B    -(A7)           ; Push false (no prompt)
000A: 4267          CLR.W    -(A7)           ; Push 0 (numTypes)
000C: 486E FFF0     PEA      -16(A6)         ; Push reply record ptr
0010: A971          _SFGetFile               ; Standard File dialog
0012: 3B6E 000C 9012 MOVE.W  12(A6),-28654(A5) ; Store dialog ID
0018: 486D D700     PEA      -10496(A5)      ; Push global buffer
001C: 4EAD 0C62     JSR      3170(A5)        ; Call via JT[3170]
0020: 486D 008A     PEA      138(A5)         ; Push another global
0024: 3F3C 0400     MOVE.W   #1024,-(A7)     ; Push constant
0028: 4EAD 0C82     JSR      3202(A5)        ; Call via JT[3202]
002C: 4E5E          UNLK     A6
002E: 4E75          RTS
```

#### C Translation

```c
/*
 * Display file selection dialog
 * Param: dialogID - ID for dialog customization
 * Confidence: HIGH
 */
void file_dialog_handler(short dialogID) {
    SFReply reply;

    SFGetFile(
        NULL,           /* no prompt */
        NULL,           /* no file filter */
        NULL,           /* no filter proc */
        0,              /* numTypes = 0 (all files) */
        NULL,           /* typeList */
        NULL,           /* dlgHook */
        &reply          /* reply record */
    );

    g_dialog_id = dialogID;         /* A5-28654 */
    some_function(g_buffer);        /* JT[3170] */
    another_function(g_ptr, 1024);  /* JT[3202] */
}
```

### Function 2: window_update_handler at 0x0030 (JT[88])

Handles window update events with clipping and drawing.

```asm
0030: 4E56 FFF2     LINK     A6,#-14         ; 14 bytes local
0034: 48E7 0018     MOVEM.L  A3/A4,-(SP)     ; Save A3/A4
0038: 266E 0010     MOVEA.L  16(A6),A3       ; A3 = window param
003C: 286E 000C     MOVEA.L  12(A6),A4       ; A4 = rect param
0040: 0C54 0006     CMPI.W   #6,(A4)         ; Check rect type
0044: 6600 0084     BNE.W    $00CA           ; If not 6, skip
0048: B7EC 0002     CMPA.L   2(A4),A3        ; Compare pointers
004C: 667C          BNE.S    $00CA           ; Not equal, skip

004E: 2F0B          MOVE.L   A3,-(A7)        ; Push window
0050: A873          _GetPort                 ; Get current port
0052: 2F0B          MOVE.L   A3,-(A7)        ; Push window
0054: A922          _SetPort                 ; Set as current port
0056: 2F0B          MOVE.L   A3,-(A7)        ; Push window
0058: 2F2B 0018     MOVE.L   24(A3),-(A7)    ; Push visRgn
005C: A978          _BeginUpdate             ; Begin update
0060: 2F0B          MOVE.L   A3,-(A7)        ; Push window
0062: 3F3C 0004     MOVE.W   #4,-(A7)        ; Push 4
0066: 486E FFFA     PEA      -6(A6)          ; Push local rect
006A: 486E FFFC     PEA      -4(A6)          ; Push local rect
006E: 486E FFF2     PEA      -14(A6)         ; Push local rect
0072: A98D          _Pack3                   ; Dialog Manager pack

0074: 3F2E FFF4     MOVE.W   -12(A6),-(A7)   ; Push coord
0078: 3F2E FFF6     MOVE.W   -10(A6),-(A7)   ; Push coord
007C: A893          _LineTo                  ; Draw line

007E: 486D 9014     PEA      -28652(A5)      ; Push global rect
0082: A884          _EraseRect               ; Erase rectangle

0084: 206D DE78     MOVEA.L  -8584(A5),A0    ; A0 = g_handle
0088: A029          _HLock                   ; Lock handle
008A: 206D DE78     MOVEA.L  -8584(A5),A0    ; A0 = g_handle
008E: 2050          MOVEA.L  (A0),A0         ; Dereference
0090: 4868 032E     PEA      814(A0)         ; Push data at offset 814
0094: 4267          CLR.W    -(A7)           ; Push 0
0096: 206D DE78     MOVEA.L  -8584(A5),A0    ; A0 = g_handle
009A: 2050          MOVEA.L  (A0),A0         ; Dereference
009C: 4868 032E     PEA      814(A0)         ; Push data
00A0: 4EAD 0DC2     JSR      3522(A5)        ; Call JT[3522]

00A4: 548F          ADDQ.L   #2,A7           ; Clean stack
00A6: 3E80          MOVE.W   D0,(A7)         ; Store result
00A8: A885          _InvertRect              ; Invert rectangle

00AA: 206D DE78     MOVEA.L  -8584(A5),A0    ; A0 = g_handle
00AE: A02A          _HUnlock                 ; Unlock handle

00B0: 2F0B          MOVE.L   A3,-(A7)        ; Push window
00B2: A923          _EndUpdate               ; End update
00B4: 4A6D 9012     TST.W    -28654(A5)      ; Test global flag
00B8: 6706          BEQ.S    $00C0           ; If 0, skip
00BA: 422E 0014     CLR.B    20(A6)          ; Clear flag
00BE: 6028          BRA.S    $00E8           ; Done

00C0: 4EBA 00CA     JSR      $018C(PC)       ; Call helper
00C4: 1D7C 0001 0014 MOVE.B  #1,20(A6)       ; Set flag
00CA: 601C          BRA.S    $00E8

; Error/skip path
00CC: 4A6D 9012     TST.W    -28654(A5)      ; Test global
00D0: 670C          BEQ.S    $00DE
00D2: 0C54 0001     CMPI.W   #1,(A4)         ; Check type
00D6: 670A          BEQ.S    $00E2
00D8: 0C54 0003     CMPI.W   #3,(A4)         ; Check type
00DC: 6704          BEQ.S    $00E2
00DE: 7000          MOVEQ    #0,D0           ; Return 0
00E0: 6002          BRA.S    $00E4
00E2: 7001          MOVEQ    #1,D0           ; Return 1
00E4: 1D40 0014     MOVE.B   D0,20(A6)       ; Store result

00E8: 4CDF 1800     MOVEM.L  (SP)+,A3/A4     ; Restore
00EC: 4E5E          UNLK     A6
00EE: 205F          MOVEA.L  (A7)+,A0        ; Pop return
00F0: 4FEF 000C     LEA      12(A7),A7       ; Clean params
00F4: 4ED0          JMP      (A0)            ; Return
```

#### C Translation

```c
/*
 * Handle window update event
 * Params: rect - update rectangle, window - target window
 * Returns: success flag
 * Confidence: HIGH
 */
Boolean window_update_handler(Rect *rect, WindowPtr window) {
    GrafPtr oldPort;

    if (rect->top != 6) return false;
    if ((void*)rect + 2 != window) return false;

    GetPort(&oldPort);
    SetPort(window);
    BeginUpdate(window);

    /* Draw using Dialog Manager */
    Pack3(window, 4, &localRect1, &localRect2, &localRect3);
    LineTo(coord1, coord2);
    EraseRect(&g_rect);

    /* Draw from locked handle data */
    HLock(g_handle);
    char *data = (*g_handle) + 814;
    short result = some_function(data, 0, data);
    InvertRect(/* computed rect */);
    HUnlock(g_handle);

    EndUpdate(window);

    if (g_dialog_id != 0) {
        return false;
    }
    helper_function();
    return true;
}
```

### Function 3: resource_init at 0x00F6 (JT[96])

Initializes resources and calculates DAWG pointers.

```asm
00F6: 4E56 FFFC     LINK     A6,#-4          ; 4 bytes local
00FA: 2F0C          MOVE.L   A4,-(A7)        ; Save A4
00FC: 486E FFFC     PEA      -4(A6)          ; Push local
0100: 4267          CLR.W    -(A7)           ; Push 0
0102: 2F2E 0008     MOVE.L   8(A6),-(A7)     ; Push param
0106: 4EAD 0D3A     JSR      3386(A5)        ; Call JT[3386]
010A: 2840          MOVEA.L  D0,A4           ; A4 = result
010C: 200C          MOVE.L   A4,D0           ; D0 = pointer
010E: 4FEF 000A     LEA      10(A7),A7       ; Clean stack
0112: 6626          BNE.S    $013A           ; If not null

; Initialize DAWG section pointers
0114: 2B6D 9F28 A222 MOVE.L  -24792(A5),-23518(A5)  ; Copy ptr
011A: 536D A386     SUBQ.W   #1,-23674(A5)   ; Decrement counter
011E: 702C          MOVEQ    #44,D0          ; D0 = 44
0120: C1ED A386     MULS     -23674(A5),D0   ; D0 = count * 44
0124: 41ED A226     LEA      -23514(A5),A0   ; A0 = base
0128: D088          ADD.L    A0,D0           ; D0 = base + offset
012A: 2040          MOVEA.L  D0,A0           ; A0 = pointer
012C: 7001          MOVEQ    #1,D0           ; D0 = 1
012E: 4A40          TST.W    D0              ; Test
0130: 6602          BNE.S    $0134
0132: 7001          MOVEQ    #1,D0
0134: 4CD8 DEF8     MOVEM.L  (SP)+,...       ; Restore
0138: 4ED1          JMP      (A1)            ; Return

013A: 2B6C 0004 DE74 MOVE.L  4(A4),-8588(A5) ; g_sect1_ptr = param->field_4
0140: 2B6C 0008 DE70 MOVE.L  8(A4),-8592(A5) ; g_sect2_ptr = param->field_8
0146: 41EC 000C     LEA      12(A4),A0       ; A0 = &param->field_12
014A: 2B48 DE6C     MOVE.L   A0,-8596(A5)    ; g_letter_index = A0

; Validate section 1 bounds
014E: 202D DE74     MOVE.L   -8588(A5),D0    ; D0 = sect1_ptr
0152: E588          LSL.L    #2,D0           ; D0 *= 4 (entry size)
0154: 43F4 0874     LEA      2164(A4),A1     ; A1 = data + 2164
0158: 2B49 DE68     MOVE.L   A1,-8600(A5)    ; g_dawg_section1 = A1
015C: 202D DE74     MOVE.L   -8588(A5),D0    ; D0 = sect1_ptr
0160: E588          LSL.L    #2,D0           ; D0 *= 4
0162: 0C30 0061 0803 CMPI.B  #$61,3(A0,D0.L) ; Check for 'a'
0168: 6704          BEQ.S    $016E           ; Valid
016A: 4EAD 01A2     JSR      418(A5)         ; bounds_check error

; Validate section 2 bounds
016E: 202D DE70     MOVE.L   -8592(A5),D0    ; D0 = sect2_ptr
0172: E588          LSL.L    #2,D0           ; D0 *= 4
0174: D0AD DE68     ADD.L    -8600(A5),D0    ; D0 += section1_base
0178: 2040          MOVEA.L  D0,A0           ; A0 = section2_base
017A: 0C28 0061 0003 CMPI.B  #$61,3(A0)      ; Check for 'a'
0180: 6704          BEQ.S    $0186           ; Valid
0182: 4EAD 01A2     JSR      418(A5)         ; bounds_check error

0186: 285F          MOVEA.L  (A7)+,A4        ; Restore A4
0188: 4E5E          UNLK     A6
018A: 4E75          RTS
```

#### C Translation

```c
/*
 * Initialize DAWG resource pointers
 * Param: resource - handle to DAWG data
 * Confidence: HIGH
 */
void resource_init(Handle resource) {
    DawgResource *dawg;

    dawg = (DawgResource *)call_jt_3386(&local, 0, resource);

    if (dawg == NULL) {
        /* Fallback initialization */
        g_some_ptr = g_other_ptr;
        g_counter--;
        void *base = g_base_array + g_counter * 44;
        return;
    }

    /* Set up DAWG section pointers */
    g_section1_count = dawg->field_4;       /* A5-8588 */
    g_section2_count = dawg->field_8;       /* A5-8592 */
    g_letter_index = &dawg->field_12;       /* A5-8596 */

    /* Calculate section 1 base (offset 2164 = 0x874) */
    g_dawg_section1 = (long *)((char *)dawg + 2164);  /* A5-8600 */

    /* Validate section 1 - first entry should have letter 'a' */
    long *entry = g_dawg_section1 + g_section1_count;
    if (((*entry) & 0xFF) != 'a') {
        bounds_check();  /* Error! */
    }

    /* Validate section 2 */
    long *sect2 = g_dawg_section1 + g_section2_count;
    if (((*sect2) & 0xFF) != 'a') {
        bounds_check();  /* Error! */
    }
}
```

### Function 4: allocate_buffers at 0x018C

Allocates memory buffers for game state.

```asm
018C: 48E7 0108     MOVEM.L  D7/A4,-(SP)     ; Save
0190: 4878 0E00     PEA      $0E00.W         ; Push 3584
0194: 4EAD 0682     JSR      1666(A5)        ; NewPtr/NewHandle
0198: 2B40 D130     MOVE.L   D0,-12016(A5)   ; Store handle

019C: 4878 0900     PEA      $0900.W         ; Push 2304
01A0: 4EAD 0682     JSR      1666(A5)        ; NewPtr
01A4: 2B40 CF0C     MOVE.L   D0,-12532(A5)   ; Store

01A8: 4878 0900     PEA      $0900.W         ; Push 2304
01AC: 4EAD 0682     JSR      1666(A5)        ; NewPtr
01B0: 2B40 CF10     MOVE.L   D0,-12528(A5)   ; Store

01B4: 4878 0900     PEA      $0900.W         ; Push 2304
01B8: 4EAD 0682     JSR      1666(A5)        ; NewPtr
01BC: 2B40 CF14     MOVE.L   D0,-12524(A5)   ; Store

01C0: 4878 0900     PEA      $0900.W         ; Push 2304
01C4: 4EAD 0682     JSR      1666(A5)        ; NewPtr
01C8: 2B40 CF18     MOVE.L   D0,-12520(A5)   ; Store

01CC: 4878 0900     PEA      $0900.W         ; Push 2304
01D0: 4EAD 0682     JSR      1666(A5)        ; NewPtr
01D4: 2B40 CF1C     MOVE.L   D0,-12516(A5)   ; Store

01D8: 4878 0900     PEA      $0900.W         ; Push 2304
01DC: 4EAD 0682     JSR      1666(A5)        ; NewPtr
01E0: 2B40 CF20     MOVE.L   D0,-12512(A5)   ; Store

01E4: 4EAD 0692     JSR      1682(A5)        ; Get memory size
01E8: 2E00          MOVE.L   D0,D7           ; D7 = size
01EA: 0C87 0000 2000 CMPI.L  #$2000,D7       ; Compare with 8192
01F0: 4FEF 001C     LEA      28(A7),A7       ; Clean stack
01F4: 6F06          BLE.S    $01FC           ; If <= 8192
01F6: 2E3C 0000 2000 MOVE.L  #$2000,D7       ; Cap at 8192

01FC: EB8F          LSL.L    #5,D7           ; D7 *= 32
01FE: 0C87 0000 80CE CMPI.L  #$80CE,D7       ; Compare with 32974
0204: 6406          BCC.S    $020C           ; If >= 32974
0206: 2E3C 0000 80CE MOVE.L  #$80CE,D7       ; Set to 32974

020C: 2F07          MOVE.L   D7,-(A7)        ; Push size
020E: 4EAD 0682     JSR      1666(A5)        ; NewPtr
0212: 2B40 D134     MOVE.L   D0,-12012(A5)   ; Store large buffer

0216: EA8F          LSR.L    #5,D7           ; D7 /= 32
0218: 2B47 D138     MOVE.L   D7,-12008(A5)   ; Store count

021C: 4A80          TST.L    D0              ; Test allocation
021E: 588F          ADDQ.L   #4,A7           ; Clean stack
0220: 6604          BNE.S    $0226           ; If successful
0222: 4EAD 01A2     JSR      418(A5)         ; bounds_check error

0226: 4878 4400     PEA      $4400.W         ; Push 17408
022A: 4EAD 0682     JSR      1666(A5)        ; NewPtr
022E: 2B40 CF08     MOVE.L   D0,-12536(A5)   ; Store

; Initialize machine ID byte
0232: 7200          MOVEQ    #0,D1           ; D1 = 0
0234: 1238 0910     MOVE.B   $0910.W,D1      ; D1 = CPUFlag (machine type)
0238: 3041          MOVEA.W  D1,A0           ; A0 = machine type
023A: 4228 0911     CLR.B    $0911(A0)       ; Clear byte at offset
023E: 387C 0910     MOVEA.W  #$0910,A4       ; A4 = low memory ptr
0242: 2E8C          MOVE.L   A4,(A7)         ; Store
0244: 4EBA FEB0     JSR      $00F6(PC)       ; Call resource_init
0248: 2E8C          MOVE.L   A4,(A7)         ; Store
024A: 4EAD 0302     JSR      770(A5)         ; Call JT[770]
024E: 588F          ADDQ.L   #4,A7           ; Clean stack
0250: 4CDF 1080     MOVEM.L  (SP)+,D7/A4     ; Restore
0254: 4E75          RTS
```

#### C Translation

```c
/*
 * Allocate game buffers
 * Confidence: HIGH
 */
void allocate_buffers(void) {
    /* Allocate primary buffers */
    g_buffer_3584 = NewPtr(3584);           /* A5-12016 */
    g_buffer_2304_1 = NewPtr(2304);         /* A5-12532 */
    g_buffer_2304_2 = NewPtr(2304);         /* A5-12528 */
    g_buffer_2304_3 = NewPtr(2304);         /* A5-12524 */
    g_buffer_2304_4 = NewPtr(2304);         /* A5-12520 */
    g_buffer_2304_5 = NewPtr(2304);         /* A5-12516 */
    g_buffer_2304_6 = NewPtr(2304);         /* A5-12512 */

    /* Calculate dynamic buffer size based on available memory */
    long memSize = get_memory_size();       /* JT[1682] */
    if (memSize > 8192) {
        memSize = 8192;
    }
    memSize *= 32;
    if (memSize < 32974) {
        memSize = 32974;
    }

    g_large_buffer = NewPtr(memSize);       /* A5-12012 */
    g_buffer_count = memSize / 32;          /* A5-12008 */

    if (g_large_buffer == NULL) {
        bounds_check();  /* Fatal error */
    }

    g_buffer_17408 = NewPtr(17408);         /* A5-12536 */

    /* Initialize based on machine type */
    Byte machineType = CPUFlag;             /* $0910 low memory */
    /* ... machine-specific init ... */

    resource_init(/* low memory ptr */);
    call_jt_770(/* ... */);
}
```

### Function 5: dialog_helper at 0x0256 (JT[104])

```asm
0256: 4E56 FFF8     LINK     A6,#-8          ; 8 bytes local
025A: 2D6E 0008 FFF8 MOVE.L  8(A6),-8(A6)    ; Copy param
0260: 3D6E 000E FFFC MOVE.W  14(A6),-4(A6)   ; Copy param
0266: 3D6E 0010 FFFE MOVE.W  16(A6),-2(A6)   ; Copy param
026C: 486E FFF8     PEA      -8(A6)          ; Push local struct
0270: 486D 0072     PEA      114(A5)         ; Push global
0274: 486D 9026     PEA      -28634(A5)      ; Push global
0278: 3F2E 000C     MOVE.W   12(A6),-(A7)    ; Push param
027C: 4EAD 0C92     JSR      3218(A5)        ; Call JT[3218]
0280: 4E5E          UNLK     A6
0282: 4E75          RTS
```

### Function 6: point_handler at 0x0284

```asm
0284: 4E56 FFFA     LINK     A6,#-6
0288: 2F0C          MOVE.L   A4,-(A7)        ; Save A4
028A: 286E 000C     MOVEA.L  12(A6),A4       ; A4 = param
028E: 2F14          MOVE.L   (A4),-(A7)      ; Push point
0290: 3F2C 0004     MOVE.W   4(A4),-(A7)     ; Push value
0294: 2F2E 0008     MOVE.L   8(A6),-(A7)     ; Push param
0298: 4EAD 0CDA     JSR      3290(A5)        ; Call JT[3290]
029C: 3EAC 0004     MOVE.W   4(A4),(A7)      ; Store result
02A0: 2F2E 0008     MOVE.L   8(A6),-(A7)     ; Push param
02A4: 4EAD 0CA2     JSR      3234(A5)        ; Call JT[3234]
02A8: 4FEF 000E     LEA      14(A7),A7       ; Clean stack
02AC: 486D 0C8A     PEA      3210(A5)        ; Push global
02B0: 486E FFFE     PEA      -2(A6)          ; Push local
02B4: A991          _Pack6                   ; Dialog Manager

02B6: 0C6E 0001 FFFE CMPI.W  #1,-2(A6)       ; Compare result
02BC: 662C          BNE.S    $02EA           ; If not 1
02BE: 2F14          MOVE.L   (A4),-(A7)      ; Push point
02C0: 3F2C 0004     MOVE.W   4(A4),-(A7)     ; Push value
02C4: 2F2E 0008     MOVE.L   8(A6),-(A7)     ; Push param
02C8: 4EAD 0642     JSR      1602(A5)        ; Call JT[1602]
02CC: 2E94          MOVE.L   (A4),(A7)       ; Store
02CE: 4EAD 0802     JSR      2050(A5)        ; Call JT[2050]
02D2: 2E80          MOVE.L   D0,(A7)         ; Store result
02D4: 2F14          MOVE.L   (A4),-(A7)      ; Push point
02D6: 4EAD 0DA2     JSR      3490(A5)        ; copy_to_global
02DA: 4FEF 000E     LEA      14(A7),A7       ; Clean stack

02DE: 4A6C 0006     TST.W    6(A4)           ; Test flag
02E2: 6606          BNE.S    $02EA           ; If set, skip
02E4: 2054          MOVEA.L  (A4),A0         ; A0 = pointer
02E6: 4A10          TST.B    (A0)            ; Test byte
02E8: 67C2          BEQ.S    $02AC           ; Loop if zero

02EA: 302E FFFE     MOVE.W   -2(A6),D0       ; Return result
02EE: 285F          MOVEA.L  (A7)+,A4        ; Restore A4
02F0: 4E5E          UNLK     A6
02F2: 4E75          RTS
```

## Toolbox Traps Used

| Trap | Name | Usage |
|------|------|-------|
| $A971 | _SFGetFile | File selection dialog |
| $A873 | _GetPort | Get current graphics port |
| $A922 | _SetPort | Set graphics port |
| $A978 | _BeginUpdate | Begin window update |
| $A923 | _EndUpdate | End window update |
| $A884 | _EraseRect | Erase rectangle |
| $A893 | _LineTo | Draw line |
| $A885 | _InvertRect | Invert rectangle |
| $A029 | _HLock | Lock handle |
| $A02A | _HUnlock | Unlock handle |
| $A98D | _Pack3 | Standard File Package |
| $A991 | _Pack6 | Dialog Manager Package |

## Key Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-8584 | g_handle | Main data handle |
| A5-8588 | g_section1_count | DAWG section 1 entry count |
| A5-8592 | g_section2_count | DAWG section 2 entry count |
| A5-8596 | g_letter_index | Pointer to letter index table |
| A5-8600 | g_dawg_section1 | Base pointer to DAWG section 1 |
| A5-12012 | g_large_buffer | Main game buffer |
| A5-12016 | g_buffer_3584 | 3584-byte buffer |
| A5-28654 | g_dialog_id | Current dialog identifier |

## Analysis Notes

- **DAWG Initialization**: Sets up critical pointers for dictionary access
- **Memory Management**: Allocates ~45KB of buffers for game state
- **Window Handling**: Full update cycle with proper locking

## Confidence Levels

| Aspect | Confidence | Notes |
|--------|------------|-------|
| Function boundaries | HIGH | Clear LINK/UNLK/RTS |
| Disassembly | HIGH | Complete |
| Toolbox trap usage | HIGH | Standard patterns |
| DAWG pointer setup | HIGH | Verified by offsets |
| Function names | MEDIUM | Inferred from behavior |

## Refined Analysis (Second Pass)

**Cluster**: Resources

**Category**: UI_SUPPORT, RESOURCE

**Global Variable Profile**: 0 DAWG direct, 1 UI, 22 total (but sets up DAWG pointers)

**Calls functions in**: CODE 9, 11, 15, 27, 41, 48, 51, 52

**Assessment**: Critical resource initialization - sets up DAWG section pointers
