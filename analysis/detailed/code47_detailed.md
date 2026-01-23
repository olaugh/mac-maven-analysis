# CODE 47 Detailed Analysis - File I/O Operations

## Overview

| Property | Value |
|----------|-------|
| Size | 908 bytes |
| JT Offset | 3328 |
| JT Entries | 4 |
| Functions | 10 |
| Purpose | **File input/output, text file handling** |

## System Role

**Category**: System Services
**Function**: File I/O

Provides file reading/writing functionality for game saves, word lists, and configuration.

**Related CODE resources**:
- CODE 50 (HIST resource handling)
- CODE 49 (Scrap/clipboard with file-like operations)

## Mac File Manager Calls

The code uses standard File Manager traps via jump table wrappers:

| JT Offset | File Manager Call | Purpose |
|-----------|-------------------|---------|
| 2818 | ? | Unknown file operation |
| 2834 | HOpenRF | Open resource fork |
| 2842 | FSWrite | Write to file |
| 2850 | FSClose | Close file |
| 2858 | FSRead | Read from file |
| 2866 | FSWrite / SetFPos | Write or set position |
| 2874 | ? | File info operation |
| 2890 | FlushVol | Flush volume |
| 2898 | ? | File operation |
| 2914 | ? | File operation |
| 2922 | FlushVol | Flush volume |
| 2946 | HOpen | Open file |
| 3522 | GetEOF | Get end of file |

## Key Functions

### Function 0x0000 - Read Single Byte
**Purpose**: Read one byte from open file, return -1 on EOF/error

```asm
0000: LINK       A6,#-6               ; frame: 1 byte result + 4 byte count + 1 pad
0004: CLR.B      -1(A6)               ; result = 0
0008: MOVEQ      #1,D0
000A: MOVE.L     D0,-6(A6)            ; count = 1

; FSRead(fileRef, &count, &buffer)
000E: CLR.W      -(A7)                ; ioResult placeholder
0010: MOVE.W     8(A6),-(A7)          ; ioRefNum
0014: PEA        -6(A6)               ; ioReqCount pointer
0018: PEA        -1(A6)               ; ioBuffer (1 byte)
001C: JSR        2858(A5)             ; JT[2858] - FSRead

; Check result
0020: TST.W      (A7)+                ; pop and test error
0022: BEQ.S      $002A                ; No error
0024: MOVE.B     #$FF,-1(A6)          ; Error: return -1

; Return byte value
002A: MOVE.B     -1(A6),D0
002E: EXT.W      D0                   ; Sign extend to word
0030: UNLK       A6
0032: RTS
```

**C equivalent**:
```c
int read_byte(short fileRef) {
    char buffer;
    long count = 1;

    OSErr err = FSRead(fileRef, &count, &buffer);

    if (err != noErr || count == 0) {
        return -1;  // EOF or error
    }
    return (unsigned char)buffer;
}
```

### Function 0x0034 - Write Single Byte from Global Buffer
**Purpose**: Write one byte from global buffer to file

```asm
0034: LINK       A6,#-4
0038: MOVEQ      #1,D0
003A: MOVE.L     D0,-4(A6)            ; count = 1

; FSWrite(fileRef, &count, g_write_buffer)
003E: CLR.W      -(A7)                ; ioResult
0040: MOVE.W     8(A6),-(A7)          ; ioRefNum
0044: PEA        -4(A6)               ; ioReqCount
0048: PEA        -1170(A5)            ; g_write_buffer
004C: JSR        2866(A5)             ; JT[2866] - FSWrite

0050: MOVE.W     (A7)+,D0             ; Return error code
0052: UNLK       A6
0054: RTS
```

### Function 0x0056 - Open File for Reading
**Purpose**: Open file with read permission using HOpen

```asm
0056: LINK       A6,#-122             ; HParamBlockRec size
005A: MOVE.L     D7,-(A7)

; Clear parameter block
005C: PEA        $007A.W              ; 122 bytes
0060: PEA        -122(A6)
0064: JSR        426(A5)              ; memset to 0

; Set filename
0068: MOVE.L     8(A6),-104(A6)       ; pb.ioNamePtr

; HOpen(&pb, fsRdPerm)
006E: CLR.W      (A7)
0070: PEA        -122(A6)             ; param block
0074: CLR.B      -(A7)                ; fsRdPerm = 0
0076: JSR        2946(A5)             ; JT[2946] - HOpen

; Return file ref
007A: MOVE.W     (A7)+,D7             ; error code
007C: MOVEA.L    12(A6),A0            ; result pointer
0080: MOVE.L     -46(A6),(A0)         ; pb.ioRefNum

0084: MOVE.W     D7,D0                ; return error
008A: UNLK       A6
008C: RTS
```

### Function 0x01D6 - Write Text File
**Purpose**: Create/write a complete TEXT file with flush

```asm
01D6: LINK       A6,#-2               ; local for fileRef
01DA: MOVE.L     D7,-(A7)

; Create/open file with type 'TEXT'
01DC: MOVE.L     #$54455854,-(A7)     ; 'TEXT' file type
01E2: MOVE.W     #$0001,-(A7)         ; create flag
01E6: PEA        -2(A6)               ; &fileRef
01EA: MOVE.W     12(A6),-(A7)         ; vRefNum
01EE: MOVE.L     8(A6),-(A7)          ; filename
01F2: JSR        -140(PC)             ; open_file_create
01F6: MOVE.W     D0,D7
01FC: BNE.S      $0250                ; Failed - return error

; Write data to file
01FE: CLR.W      -(A7)
0200: MOVE.W     -2(A6),-(A7)         ; fileRef
0204: PEA        18(A6)               ; data buffer
0208: MOVE.L     14(A6),-(A7)         ; byte count
020C: JSR        2866(A5)             ; FSWrite
0210: MOVE.W     (A7)+,D7
0212: BNE.S      $0226                ; Write failed - close and return

; Flush to disk
0214: CLR.W      -(A7)
0216: MOVE.W     -2(A6),-(A7)
021A: MOVE.L     18(A6),-(A7)         ; vRefNum for flush
021E: JSR        2922(A5)             ; FlushVol
0222: MOVE.W     (A7)+,D7
0224: BEQ.S      $0234                ; Success - continue to close

; Error path - close file
0226: CLR.W      -(A7)
0228: MOVE.W     -2(A6),-(A7)
022C: JSR        2850(A5)             ; FSClose
0232: BRA.S      $0250                ; Return with error

; Success path - close file
0234: CLR.W      -(A7)
0236: MOVE.W     -2(A6),-(A7)
023A: JSR        2850(A5)             ; FSClose
023E: MOVE.W     (A7)+,D7
0240: BNE.S      $0250                ; Close failed

; Final volume flush
0242: CLR.W      -(A7)
0244: CLR.L      -(A7)                ; NULL volume name
0246: MOVE.W     12(A6),-(A7)         ; vRefNum
024A: JSR        2890(A5)             ; FlushVol
024E: MOVE.W     (A7)+,D7

0250: MOVE.W     D7,D0                ; Return error code
0254: UNLK       A6
0256: RTS
```

**C equivalent**:
```c
OSErr write_text_file(StringPtr filename, short vRefNum,
                      void* data, long count) {
    short fileRef;
    OSErr err;

    // Create/open as TEXT file
    err = create_open_file(filename, vRefNum, 'TEXT', 1, &fileRef);
    if (err) return err;

    // Write data
    err = FSWrite(fileRef, &count, data);
    if (err) {
        FSClose(fileRef);
        return err;
    }

    // Flush file
    err = FlushVol(NULL, vRefNum);
    if (err) {
        FSClose(fileRef);
        return err;
    }

    // Close
    err = FSClose(fileRef);
    if (err) return err;

    // Final volume flush
    return FlushVol(NULL, vRefNum);
}
```

### Function 0x02EA - Read Line from File
**Purpose**: Read a line (until CR or LF) into buffer

```asm
02EA: LINK       A6,#0
02EE: MOVEM.L    D6/D7/A3/A4,-(SP)
02F2: MOVEA.L    8(A6),A3             ; A3 = buffer start
02F6: MOVE.L     12(A6),D7            ; D7 = max length
02FA: MOVEA.L    A3,A4                ; A4 = current position

; Handle zero-length request
02FC: TST.L      D7
02FE: BNE.S      $0326
0300: MOVEQ      #0,D0                ; Return NULL
0302: BRA.S      $034C

; Character processing loop
0304: CMPI.W     #$0008,D6            ; Backspace?
0308: BNE.S      $0318
; Handle backspace - move position back if not at start
0316: BRA.S      $0326

; Store character
0318: MOVE.B     D6,(A4)+             ; *pos++ = char

; Check for line ending
031A: CMPI.B     #$000A,D6            ; LF (Unix)?
031E: BEQ.S      $033C
0320: CMPI.W     #$000D,D6            ; CR (Mac)?
0324: BEQ.S      $033C

; Read next character
0326: ; ... decrement remaining length
032C: MOVE.W     16(A6),-(A7)         ; fileRef
0330: JSR        -818(PC)             ; read_byte
0334: MOVE.W     D0,D6                ; D6 = character
033A: BNE.S      $0304                ; Not EOF - continue

; End of line or file
033C: ; Check if anything read
0340: CLR.B      (A4)                 ; Null terminate
; ... check if pos == start
0346: MOVEQ      #0,D0                ; Return 0 (success/EOF)
0348: BRA.S      $034C

034A: MOVE.L     A3,D0                ; Return buffer pointer

034C: MOVEM.L    (SP)+,D6/D7/A3/A4
0350: UNLK       A6
0352: RTS
```

**C equivalent**:
```c
char* read_line(char* buffer, long maxLen, short fileRef) {
    char* pos = buffer;

    if (maxLen == 0) return NULL;

    while (maxLen > 0) {
        int ch = read_byte(fileRef);

        if (ch < 0) break;  // EOF

        if (ch == 0x08 && pos > buffer) {  // Backspace
            pos--;
            continue;
        }

        *pos++ = ch;

        if (ch == '\n' || ch == '\r') {
            break;  // End of line
        }

        maxLen--;
    }

    *pos = '\0';

    return (pos == buffer) ? NULL : buffer;
}
```

### Function 0x0354 - Get/Set File Position
**Purpose**: Get file size and optionally set position

```asm
0354: LINK       A6,#-4
0358: MOVE.L     D7,-(A7)

; Get logical EOF
035A: MOVE.L     8(A6),-(A7)          ; fileRef
035E: JSR        3522(A5)             ; GetEOF
0362: MOVE.L     D0,-4(A6)            ; size = EOF position

; Set file position
0366: CLR.W      (A7)
0368: MOVE.W     12(A6),-(A7)         ; positioning mode
036C: PEA        -4(A6)               ; &position
0370: MOVE.L     8(A6),-(A7)          ; fileRef
0374: JSR        2866(A5)             ; SetFPos

0378: MOVE.W     (A7)+,D7
037C: TST.W      D7
037E: BEQ.S      $0384
0380: MOVEQ      #-1,D0               ; Error
0382: BRA.S      $0386

0384: MOVEQ      #0,D0                ; Success

0386: UNLK       A6
038A: RTS
```

## Global Variables

| Offset | Size | Purpose |
|--------|------|---------|
| A5-1170 | 1+ | g_write_buffer - Buffer for single-byte writes |

## File Type Constants

| Type | Value | Description |
|------|-------|-------------|
| TEXT | 0x54455854 | Plain text file |

## Error Handling Pattern

All file functions follow the pattern:
1. Clear error placeholder on stack
2. Call File Manager routine
3. Pop and test error code
4. Propagate error or continue

## Confidence: HIGH

Standard Mac File Manager patterns:
- HParamBlockRec usage (122 bytes)
- Proper error checking and propagation
- FSRead/FSWrite with count pointer
- FlushVol after writes for data integrity
- Line reading with CR/LF handling (Mac and Unix compatible)
