# CODE 47 Detailed Analysis - File I/O Operations

## Overview

| Property | Value |
|----------|-------|
| Size | 908 bytes |
| JT Offset | 3328 |
| JT Entries | 4 |
| Functions | 10 |
| Purpose | **File input/output operations, text file handling** |

## Architecture Role

CODE 47 provides file I/O functionality:
1. Read/write text files
2. Parse file contents into buffers
3. Handle file selection dialogs
4. Stream-based file operations

## Key Functions

### Function 0x0000 - Read Single Byte
```asm
0000: LINK       A6,#-6               ; frame=6
0004: CLR.B      -1(A6)               ; result = 0
0008: MOVEQ      #1,D0
000A: MOVE.L     D0,-6(A6)            ; count = 1

; Read one byte
000E: CLR.W      -(A7)                ; No error
0010: MOVE.W     8(A6),-(A7)          ; File ref
0014: PEA        -6(A6)               ; Count address
0018: PEA        -1(A6)               ; Buffer (1 byte)
001C: JSR        2858(A5)             ; JT[2858] - FSRead

; Check result
0020: TST.W      (A7)+
0022: BEQ.S      $002A                ; Success
0024: MOVE.B     #$FF,-1(A6)          ; Error: return -1

; Return byte read
002A: MOVE.B     -1(A6),D0
002E: EXT.W      D0                   ; Extend to word
0030: UNLK       A6
0032: RTS
```

**C equivalent**:
```c
int read_byte(int file_ref) {
    char buffer;
    long count = 1;

    OSErr err = FSRead(file_ref, &count, &buffer);

    if (err != noErr) {
        return -1;  // EOF or error
    }
    return (unsigned char)buffer;
}
```

### Function 0x0034 - Write Buffer
```asm
0034: LINK       A6,#-4               ; frame=4
0038: MOVEQ      #1,D0
003A: MOVE.L     D0,-4(A6)            ; count = 1

; Write to file
003E: CLR.W      -(A7)                ; No error
0040: MOVE.W     8(A6),-(A7)          ; File ref
0044: PEA        -4(A6)               ; Count
0048: PEA        -1170(A5)            ; g_write_buffer
004C: JSR        2866(A5)             ; JT[2866] - FSWrite

0050: MOVE.W     (A7)+,D0             ; Return error
0052: UNLK       A6
0054: RTS
```

**C equivalent**:
```c
int write_buffer(int file_ref) {
    long count = 1;
    return FSWrite(file_ref, &count, g_write_buffer);
}
```

### Function 0x0056 - Open File for Reading
```asm
0056: LINK       A6,#-122             ; frame=122 (FSSpec size + extra)
005A: MOVE.L     D7,-(A7)

; Clear param block
005C: PEA        $007A.W              ; 122 bytes
0060: PEA        -122(A6)             ; Local buffer
0064: JSR        426(A5)              ; JT[426] - memset

; Set filename pointer
0068: MOVE.L     8(A6),-104(A6)       ; Store filename

; Open file
006E: CLR.W      (A7)                 ; Clear stack
0070: PEA        -122(A6)             ; Param block
0074: CLR.B      -(A7)                ; Read permission
0076: JSR        2946(A5)             ; JT[2946] - HOpen

; Get file ref
007A: MOVE.W     (A7)+,D7             ; Error code
007C: MOVEA.L    12(A6),A0            ; Result pointer
0080: MOVE.L     -46(A6),(A0)         ; Store file ref
0084: MOVE.W     D7,D0                ; Return error
0086: MOVE.L     -126(A6),D7
008A: UNLK       A6
008C: RTS
```

**C equivalent**:
```c
OSErr open_file_read(StringPtr filename, int* file_ref) {
    HParamBlockRec pb;

    memset(&pb, 0, 122);
    pb.ioNamePtr = filename;

    OSErr err = HOpen(&pb, fsRdPerm);

    *file_ref = pb.ioRefNum;
    return err;
}
```

### Function 0x00CC - Open File with Options
```asm
00CC: LINK       A6,#-338             ; frame=338
00D0: MOVE.L     D7,-(A7)

; Clear large param block
00D2: PEA        $0050.W              ; 80 bytes
00D6: PEA        -338(A6)             ; Param block
00DA: JSR        426(A5)              ; JT[426] - memset

; Set up buffers
00DE: LEA        -258(A6),A0          ; Text buffer
00E2: MOVE.L     A0,-320(A6)          ; Store pointer
00E6: MOVE.W     #$0001,-310(A6)      ; Set flag

; Loop: try to open, process
00EE: CLR.W      -(A7)
00F0: PEA        -338(A6)             ; Param block
00F4: CLR.B      -(A7)                ; Permission
00F6: JSR        2834(A5)             ; JT[2834] - HOpenRF

00FA: MOVE.W     (A7)+,D7             ; Error
00FC: BNE.S      $0120                ; Failed - return

; Process file
00FE: MOVE.L     8(A6),-(A7)          ; Callback
0102: PEA        -258(A6)             ; Buffer
0106: JSR        2042(A5)             ; JT[2042] - process

010A: TST.W      D0
010C: ...
010E: BNE.S      $011A                ; Done
0110: MOVEA.L    12(A6),A0
0114: MOVE.W     -316(A6),(A0)        ; Store result
0118: BRA.S      $0120

; Increment counter and retry
011A: MOVEA.B    -310(A6),A1          ; Counter++
011E: BRA.S      $00EE                ; Loop

0120: MOVE.W     D7,D0
0122: MOVE.L     (A7)+,D7
0124: UNLK       A6
0126: RTS
```

**C equivalent**:
```c
OSErr open_file_with_options(Callback callback, int* result) {
    HParamBlockRec pb;
    char buffer[256];

    memset(&pb, 0, 80);
    pb.ioNamePtr = buffer;
    int counter = 1;

    do {
        OSErr err = HOpenRF(&pb, fsRdPerm);
        if (err) return err;

        if (callback(buffer) == 0) {
            *result = pb.ioResult;
            break;
        }
        counter++;
    } while (1);

    return noErr;
}
```

### Function 0x0128 - Write File
```asm
0128: LINK       A6,#0
012C: MOVE.L     D7,-(A7)

; Call write function
012E: CLR.W      -(A7)
0130: MOVE.L     8(A6),-(A7)          ; Data
0134: MOVE.W     12(A6),-(A7)         ; File ref
0138: MOVE.L     14(A6),-(A7)         ; Count
013C: JSR        2842(A5)             ; JT[2842] - FSWrite

0140: MOVE.W     (A7)+,D7             ; Error
0142: BEQ.S      $0148                ; Success
0144: MOVE.W     D7,D0
0146: BRA.S      $0162                ; Return error

; Check if should flush
0148: TST.W      18(A6)               ; Flush flag
014C: BEQ.S      $0160                ; No flush

; Flush file
014E: CLR.W      -(A7)
0150: MOVEA.L    14(A6),A0
0154: MOVE.W     (A0),-(A7)           ; File ref
0156: CLR.L      -(A7)
0158: JSR        2922(A5)             ; JT[2922] - FlushVol

015C: MOVE.W     (A7)+,D0
015E: BRA.S      $0162

0160: MOVEQ      #0,D0                ; Return success

0162: MOVE.L     (A7)+,D7
0164: UNLK       A6
0166: RTS
```

**C equivalent**:
```c
OSErr write_file(void* data, int file_ref, long* count, int flush) {
    OSErr err = FSWrite(file_ref, count, data);

    if (err != noErr) return err;

    if (flush) {
        return FlushVol(NULL, *count);
    }
    return noErr;
}
```

### Function 0x01D6 - Write Text File
```asm
01D6: LINK       A6,#-2               ; frame=2
01DA: MOVE.L     D7,-(A7)

; Open for writing with type 'TEXT'
01DC: MOVE.L     #$54455854,-(A7)     ; 'TEXT'
01E2: MOVE.W     #$0001,-(A7)         ; Flag
01E6: PEA        -2(A6)               ; File ref storage
01EA: MOVE.W     12(A6),-(A7)         ; Volume ref
01EE: MOVE.L     8(A6),-(A7)          ; Filename
01F2: JSR        -140(PC)             ; Open file

01F6: MOVE.W     D0,D7
01F8: LEA        16(A7),A7
01FC: BNE.S      $0250                ; Failed

; Write data
01FE: CLR.W      -(A7)
0200: MOVE.W     -2(A6),-(A7)         ; File ref
0204: PEA        18(A6)               ; Data
0208: MOVE.L     14(A6),-(A7)         ; Count
020C: JSR        2866(A5)             ; JT[2866] - FSWrite

0210: MOVE.W     (A7)+,D7
0212: BNE.S      $0226                ; Write failed

; Flush
0214: CLR.W      -(A7)
0216: MOVE.W     -2(A6),-(A7)         ; File ref
021A: MOVE.L     18(A6),-(A7)         ; Volume ref
021E: JSR        2922(A5)             ; JT[2922] - FlushVol

0222: MOVE.W     (A7)+,D7
0224: BEQ.S      $0234                ; Success

; Close on error
0226: CLR.W      -(A7)
0228: MOVE.W     -2(A6),-(A7)
022C: JSR        2850(A5)             ; JT[2850] - FSClose
0230: ...
0232: BRA.S      $0250                ; Return error

; Close successfully
0234: CLR.W      -(A7)
0236: MOVE.W     -2(A6),-(A7)
023A: JSR        2850(A5)             ; JT[2850] - FSClose

023E: MOVE.W     (A7)+,D7
0240: BNE.S      $0250                ; Close failed

; Flush volume
0242: CLR.W      -(A7)
0244: CLR.L      -(A7)
0246: MOVE.W     12(A6),-(A7)         ; Volume ref
024A: JSR        2890(A5)             ; JT[2890] - FlushVol

024E: MOVE.W     (A7)+,D7

0250: MOVE.W     D7,D0
0252: MOVE.L     (A7)+,D7
0254: UNLK       A6
0256: RTS
```

**C equivalent**:
```c
OSErr write_text_file(StringPtr filename, int vRefNum,
                      void* data, long count) {
    int fileRef;
    OSErr err;

    // Create/open file as TEXT
    err = open_file_create(filename, vRefNum, 'TEXT', &fileRef);
    if (err) return err;

    // Write data
    err = FSWrite(fileRef, &count, data);
    if (err) {
        FSClose(fileRef);
        return err;
    }

    // Flush and close
    err = FlushVol(NULL, vRefNum);
    if (err) {
        FSClose(fileRef);
        return err;
    }

    err = FSClose(fileRef);
    if (err) return err;

    return FlushVol(NULL, vRefNum);
}
```

### Function 0x02EA - Read Line from File
```asm
02EA: LINK       A6,#0
02EE: MOVEM.L    D6/D7/A3/A4,-(SP)
02F2: MOVEA.L    8(A6),A3             ; A3 = buffer
02F6: MOVE.L     12(A6),D7            ; D7 = max length
02FA: MOVEA.L    A3,A4                ; A4 = current pos

; Check for zero length
02FC: TST.L      D7
02FE: BNE.S      $0326                ; Continue
0300: MOVEQ      #0,D0                ; Return NULL
0302: BRA.S      $034C

; Read loop
0304: CMPI.W     #$0008,D6            ; Backspace?
0308: BNE.S      $0318
030A: MOVE.W     A4,6(PC,D6.W)        ; Check position
030E: ...
0310: ...
0314: ...
0316: BRA.S      $0326

; Store character
0318: MOVE.B     D6,(A4)+             ; Store char

; Check for line end
031A: CMPI.B     #$000A,D6            ; LF?
031E: BEQ.S      $033C                ; End of line
0320: CMPI.W     #$000D,D6            ; CR?
0324: BEQ.S      $033C                ; End of line

; Read next character
0326: ...
032A: ...
032C: MOVE.W     16(A6),-(A7)         ; File ref
0330: JSR        -818(PC)             ; Read byte
0334: MOVE.W     D0,D6                ; D6 = char
0336: ...
0338: ...
033A: BNE.S      $0304                ; Not EOF - continue

; End of line/file
033C: MOVE.W     A3,#$6702            ; Check if empty
0340: CLR.B      (A4)                 ; Null terminate
0342: MOVE.W     A4,4(PC,D6.W)        ; Update position
0346: MOVEQ      #0,D0                ; Return 0 (success)
0348: BRA.S      $034C

034A: MOVE.L     A3,D0                ; Return buffer

034C: MOVEM.L    (SP)+,D6/D7/A3/A4
0350: UNLK       A6
0352: RTS
```

**C equivalent**:
```c
char* read_line(char* buffer, long max_length, int file_ref) {
    char* pos = buffer;

    if (max_length == 0) return NULL;

    while (max_length > 0) {
        int ch = read_byte(file_ref);
        if (ch < 0) break;  // EOF or error

        if (ch == 0x08) {  // Backspace
            if (pos > buffer) pos--;
            continue;
        }

        *pos++ = ch;

        if (ch == '\n' || ch == '\r') {
            break;  // End of line
        }

        max_length--;
    }

    *pos = '\0';  // Null terminate

    return (pos == buffer) ? NULL : buffer;
}
```

### Function 0x0354 - Get File Size
```asm
0354: LINK       A6,#-4               ; frame=4
0358: MOVE.L     D7,-(A7)

; Get logical EOF
035A: MOVE.L     8(A6),-(A7)          ; File ref
035E: JSR        3522(A5)             ; JT[3522] - GetEOF
0362: MOVE.L     D0,-4(A6)            ; Store size

; Set position to start
0366: CLR.W      (A7)
0368: MOVE.W     12(A6),-(A7)         ; Mode
036C: PEA        -4(A6)               ; Position
0370: MOVE.L     8(A6),-(A7)          ; File ref
0374: JSR        2866(A5)             ; JT[2866] - SetFPos

0378: MOVE.W     (A7)+,D7
037A: TST.W      D7
037C: ...
037E: BEQ.S      $0384
0380: MOVEQ      #-1,D0               ; Error
0382: BRA.S      $0386

0384: MOVEQ      #0,D0                ; Success

0386: MOVE.L     (A7)+,D7
0388: UNLK       A6
038A: RTS
```

**C equivalent**:
```c
int get_file_size(int file_ref, int mode) {
    long size = GetEOF(file_ref);

    OSErr err = SetFPos(file_ref, mode, &size);

    return (err != noErr) ? -1 : 0;
}
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5-1170 | g_write_buffer - Single byte write buffer |

## Jump Table Calls

| JT Offset | Purpose |
|-----------|---------|
| 426 | Memory clear (memset) |
| 2042 | File processing callback |
| 2834 | HOpenRF (open resource fork) |
| 2842 | FSWrite |
| 2850 | FSClose |
| 2858 | FSRead |
| 2866 | FSWrite |
| 2890 | FlushVol |
| 2922 | FlushVol |
| 2946 | HOpen |
| 3522 | GetEOF |

## File Type Constants

| Code | Type |
|------|------|
| TEXT | 0x54455854 - Text file |

## Confidence: HIGH

Standard Mac File Manager patterns:
- Parameter block-based operations
- Error checking and propagation
- Proper file close on error
- Line-by-line text reading with CR/LF handling
