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

---

## Speculative C Translation

### Complete File I/O Module

```c
/*
 * CODE 47 - File I/O Operations for Maven
 *
 * This module provides file reading and writing services for:
 * - Game save files
 * - Word list loading
 * - Configuration files
 * - Text export functionality
 */

/* Global variables */
char g_write_buffer[256];      /* A5-1170: Buffer for write operations */

/*--------------------------------------------------------------------
 * Function 0x0000 - Read Single Byte
 *--------------------------------------------------------------------*/
/*
 * file_read_byte - Read one byte from an open file
 *
 * Returns the byte value (0-255) or -1 on EOF/error.
 * This is the primitive used by higher-level read functions.
 *
 * @param file_ref: Open file reference number
 * @return: Byte value (0-255) or -1 on EOF/error
 */
short file_read_byte(short file_ref) {
    char byte_buffer;
    long byte_count = 1;
    OSErr error;

    /* Call FSRead through jump table wrapper */
    error = FSRead(file_ref, &byte_count, &byte_buffer);

    if (error != noErr) {
        return -1;  /* 0xFF sign-extended = -1 */
    }

    /* Return unsigned byte value */
    return (unsigned char)byte_buffer;
}

/*--------------------------------------------------------------------
 * Function 0x0034 - Write Single Byte
 *--------------------------------------------------------------------*/
/*
 * file_write_byte - Write one byte to an open file
 *
 * Writes from the global buffer, which must be set before calling.
 *
 * @param file_ref: Open file reference number
 * @return: OSErr (0 = success)
 */
OSErr file_write_byte(short file_ref) {
    long byte_count = 1;

    /* Write from global buffer */
    return FSWrite(file_ref, &byte_count, g_write_buffer);
}

/*--------------------------------------------------------------------
 * Function 0x0056 - Open File for Reading
 *--------------------------------------------------------------------*/
/*
 * file_open_read - Open file with read permission
 *
 * Uses HOpen with HParamBlockRec for full HFS support.
 *
 * @param filename_ptr: Pascal string filename
 * @param out_file_ref: Receives opened file reference
 * @return: OSErr (0 = success)
 */
OSErr file_open_read(StringPtr filename_ptr, long *out_file_ref) {
    HParamBlockRec param_block;  /* 122 bytes */
    OSErr error;

    /* Clear parameter block */
    memset(&param_block, 0, sizeof(HParamBlockRec));

    /* Set filename pointer at offset 18 (ioNamePtr) */
    param_block.ioNamePtr = filename_ptr;

    /* HOpen with read permission (fsRdPerm = 0) */
    error = PBHOpenSync(&param_block, false);

    if (error == noErr) {
        /* Return file reference from offset 24 (ioRefNum) */
        /* uncertain: exact offset mapping in HParamBlockRec */
        *out_file_ref = param_block.ioParam.ioRefNum;
    }

    return error;
}

/*--------------------------------------------------------------------
 * Function 0x008E - Open File and Get Size
 *--------------------------------------------------------------------*/
/*
 * file_open_read_with_size - Open file and return data+rsrc fork sizes
 *
 * @param filename_ptr: Pascal string filename
 * @param out_total_size: Receives combined file size
 * @return: OSErr
 */
OSErr file_open_read_with_size(StringPtr filename_ptr, long *out_total_size) {
    HParamBlockRec param_block;
    OSErr error;

    memset(&param_block, 0, sizeof(HParamBlockRec));
    param_block.ioNamePtr = filename_ptr;

    error = PBHOpenSync(&param_block, false);

    if (error == noErr) {
        /* Calculate total size (data fork + resource fork) */
        /* uncertain: exact field offsets for fork sizes */
        long data_fork_size = param_block.ioParam.ioMisc;  /* uncertain */
        long rsrc_fork_size = param_block.fileParam.ioFlLgLen;  /* uncertain */
        *out_total_size = data_fork_size + rsrc_fork_size;
    }

    return error;
}

/*--------------------------------------------------------------------
 * Function 0x00CC - Save Dialog
 *--------------------------------------------------------------------*/
/*
 * file_save_dialog - Display save dialog and validate filename
 *
 * Shows standard save dialog. If user enters existing filename,
 * validates it can be replaced.
 *
 * @param default_name: Default filename to suggest
 * @param out_vol_ref: Receives selected volume reference
 * @return: OSErr (0 = success, user pressed OK)
 */
OSErr file_save_dialog(StringPtr default_name, short *out_vol_ref) {
    SFReply reply;                    /* 80 bytes */
    unsigned char filename_buffer[256];  /* Working filename copy */
    OSErr error;
    short selection_index = 1;

    /* Initialize reply structure */
    memset(&reply, 0, sizeof(SFReply));

    /* Copy default name to filename buffer at proper offset */
    /* uncertain: exact offset -258 from A6 in original */
    BlockMove(default_name, filename_buffer, default_name[0] + 1);

    do {
        reply.fName[0] = selection_index;  /* uncertain: selection tracking */

        /* Show StandardPutFile dialog */
        SFPutFile(NULL, "\p", filename_buffer, NULL, &reply);

        if (!reply.good) {
            return userCanceledErr;  /* User cancelled */
        }

        /* Validate the chosen filename doesn't conflict */
        if (validate_save_filename(default_name, filename_buffer)) {
            *out_vol_ref = reply.vRefNum;
            return noErr;
        }

        /* Name exists - increment selection and retry */
        selection_index++;

    } while (1);
}

/*--------------------------------------------------------------------
 * Function 0x01D6 - Write Complete Text File
 *--------------------------------------------------------------------*/
/*
 * file_write_text - Create and write a complete TEXT file
 *
 * Creates file with TEXT type, writes data, flushes, and closes.
 * Handles all error cases with proper cleanup.
 *
 * @param filename: Pascal string filename
 * @param vol_ref: Volume reference number
 * @param data_ptr: Pointer to data buffer
 * @param data_size: Number of bytes to write
 * @return: OSErr
 */
OSErr file_write_text(StringPtr filename, short vol_ref,
                      void *data_ptr, long data_size) {
    short file_ref;
    OSErr error;

    /* Create/open file with TEXT type (0x54455854) */
    error = file_create_open(filename, vol_ref, 'TEXT', true, &file_ref);
    if (error != noErr) {
        return error;
    }

    /* Write the data */
    error = FSWrite(file_ref, &data_size, data_ptr);
    if (error != noErr) {
        FSClose(file_ref);
        return error;
    }

    /* Flush to ensure data is written */
    error = FlushVol(NULL, vol_ref);
    if (error != noErr) {
        FSClose(file_ref);
        return error;
    }

    /* Close the file */
    error = FSClose(file_ref);
    if (error != noErr) {
        return error;
    }

    /* Final volume flush for safety */
    return FlushVol(NULL, vol_ref);
}

/*--------------------------------------------------------------------
 * Function 0x02EA - Read Line from File
 *--------------------------------------------------------------------*/
/*
 * file_read_line - Read characters until line ending
 *
 * Reads characters one at a time until CR, LF, or EOF.
 * Handles backspace (0x08) for interactive editing support.
 * Null-terminates the result.
 *
 * @param buffer: Destination buffer for line
 * @param max_length: Maximum characters to read
 * @param file_ref: Open file reference
 * @return: Pointer to buffer if data read, NULL if empty/EOF
 */
char* file_read_line(char *buffer, long max_length, short file_ref) {
    char *buffer_start = buffer;
    char *write_pos = buffer;
    short current_char;

    /* Reject zero-length requests */
    if (max_length == 0) {
        return NULL;
    }

    /* Read characters until line ending or buffer full */
    while (max_length > 0) {
        max_length--;
        if (max_length < 0) {
            break;  /* Buffer exhausted */
        }

        /* Read next character */
        current_char = file_read_byte(file_ref);

        if (current_char < 0) {
            break;  /* EOF or error */
        }

        /* Handle backspace (delete previous char if possible) */
        if (current_char == 0x08) {
            if (write_pos != buffer_start) {
                max_length++;  /* Reclaim count */
                write_pos--;   /* Back up write position */
            }
            continue;
        }

        /* Store the character */
        *write_pos++ = (char)current_char;

        /* Check for line endings */
        if (current_char == 0x0A) {  /* LF (Unix/modern) */
            break;
        }
        if (current_char == 0x0D) {  /* CR (Classic Mac) */
            break;
        }
    }

    /* Null-terminate the line */
    if (write_pos != buffer_start) {
        *write_pos = '\0';
    }

    /* Return buffer pointer if we read something, else NULL */
    return (write_pos != buffer_start) ? buffer_start : NULL;
}

/*--------------------------------------------------------------------
 * Function 0x0354 - Get File Size / Seek
 *--------------------------------------------------------------------*/
/*
 * file_get_size_and_seek - Get file size and optionally reposition
 *
 * Gets the logical end-of-file then sets the file position.
 *
 * @param file_ref: Open file reference
 * @param seek_mode: Positioning mode for SetFPos
 * @return: 0 on success, -1 on error
 */
short file_get_size_and_seek(short file_ref, short seek_mode) {
    long file_size;
    OSErr error;

    /* Get logical EOF (file size) */
    file_size = GetEOF(file_ref);

    /* Set file position based on mode */
    error = SetFPos(file_ref, seek_mode, &file_size);

    return (error == noErr) ? 0 : -1;
}
```

### Utility Functions (Internal)

```c
/*
 * file_create_open - Create file if needed and open it
 *
 * Used internally by file_write_text.
 *
 * @param filename: Pascal string filename
 * @param vol_ref: Volume reference
 * @param file_type: Type code (e.g., 'TEXT')
 * @param create_flag: Create if doesn't exist
 * @param out_ref: Receives file reference
 * @return: OSErr
 */
static OSErr file_create_open(StringPtr filename, short vol_ref,
                              OSType file_type, Boolean create_flag,
                              short *out_ref) {
    OSErr error;

    if (create_flag) {
        /* Try to create the file first */
        error = Create(filename, vol_ref, 'MVNX', file_type);
        /* uncertain: creator code 'MVNX' or 'MAVN' */
        if (error != noErr && error != dupFNErr) {
            return error;  /* Real error, not just "already exists" */
        }
    }

    /* Open the file */
    return FSOpen(filename, vol_ref, out_ref);
}

/*
 * validate_save_filename - Check if save filename is acceptable
 *
 * Called by file_save_dialog to validate user's filename choice.
 *
 * @param default_name: Original suggested name
 * @param entered_name: Name user entered
 * @return: TRUE if acceptable
 */
static Boolean validate_save_filename(StringPtr default_name,
                                      StringPtr entered_name) {
    /* uncertain: exact validation logic */
    /* Likely checks for conflicts, illegal characters, etc. */

    /* JT[2042] wrapper call */
    return check_filename_valid(default_name, entered_name);
}
```

### Error Handling Pattern

All file functions follow this consistent pattern:

```c
/*
 * Standard file operation error handling pattern:
 *
 * 1. Clear stack space for error result
 * 2. Push parameters
 * 3. Call through jump table
 * 4. Pop and test error
 * 5. Either propagate error or continue
 *
 * Example:
 *   error = do_file_operation(params);
 *   if (error != noErr) {
 *       cleanup_if_needed();
 *       return error;
 *   }
 */
```

### Constants and Magic Numbers

```c
/* File type codes */
#define FILE_TYPE_TEXT  'TEXT'  /* 0x54455854 - Plain text */

/* Special characters */
#define CHAR_BACKSPACE  0x08    /* Delete previous character */
#define CHAR_LF         0x0A    /* Unix line ending */
#define CHAR_CR         0x0D    /* Mac line ending */

/* Return codes */
#define READ_EOF        -1      /* End of file reached */
#define SEEK_SUCCESS    0       /* Position set successfully */
#define SEEK_ERROR      -1      /* Position set failed */
```
