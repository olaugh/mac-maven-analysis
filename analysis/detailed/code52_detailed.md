# CODE 52 Detailed Analysis - DAWG Entry Flag Accessors and String Utilities

## Overview

| Property | Value |
|----------|-------|
| Size | 938 bytes |
| JT Offset | 3424 |
| JT Entries | 14 |
| Functions | 14 JT functions + string utilities |
| Purpose | **DAWG entry flag/field extraction and string operations** |


## System Role

**Category**: Data Access
**Function**: Flag Operations and String Utilities

DAWG entry bit field extraction and C string manipulation utilities.

## Architecture Role

CODE 52 serves two purposes:
1. DAWG entry flag accessors (first 14 functions via JT)
2. Low-level C string utilities (remaining functions)

## Part 1: DAWG Flag Accessors

### Common Pattern

All DAWG accessor functions at offsets 0x0000-0x0132 follow this exact pattern:
```asm
LINK       A6,#0
MOVEQ      #0,D0
MOVE.B     9(A6),D0         ; Get byte param (DAWG offset)
MOVEA.L    A5,A0
ADDA.L     D0,A0            ; A0 = A5 + offset (into DAWG data)
MOVE.B     (A0),D0          ; Read flags byte from DAWG
EXT.W      D0               ; Sign extend to word
ANDI.W     #mask,D0         ; Mask specific bits
UNLK       A6
RTS
```

### Function Mapping - Bit Field Extraction

| Offset | JT Offset | Mask | Bits | Likely Purpose |
|--------|-----------|------|------|----------------|
| 0x0000 | 3424 | 0x00D0 | 4,6,7 | Combined flags |
| 0x001C | 3432 | 0x00C0 | 6,7 | High flags |
| 0x0038 | 3440 | 0x0003 | 0,1 | **Last sibling / terminal** |
| 0x0054 | 3448 | 0x0010 | 4 | Single flag |
| 0x0070 | 3456 | 0x00D8 | 3,4,6,7 | Combined flags |
| 0x008C | 3464 | 0x0080 | 7 | **End-of-word flag** |
| 0x00A8 | 3472 | 0x00DC | 2,3,4,6,7 | Combined flags |
| 0x00C4 | 3480 | 0x0008 | 3 | Single flag |
| 0x00E0 | 3488 | 0x0006 | 1,2 | Two bits |
| 0x00FC | 3496 | 0x0040 | 6 | Single flag |
| 0x0118 | 3504 | 0x0030 | 4,5 | Two bits |

### Special Accessor Functions

#### Function 0x0134 - Conditional XOR with 0x20
```asm
0134: LINK       A6,#-2
0138: MOVEQ      #0,D0
013A: MOVE.B     9(A6),D0         ; DAWG offset
013E: MOVEA.L    A5,A0
0140: ADDA.L     D0,A0
...
0146: BPL.S      $0152            ; If positive (bit 7 clear)
0148: MOVE.W     8(A6),D0         ; Get word param
014C: EORI.W     #$0020,D0        ; XOR with 0x20 (toggle case)
0150: BRA.S      $0156
0152: MOVE.W     8(A6),D0         ; Just return word param
0156: UNLK       A6
0158: RTS
```

This function conditionally toggles ASCII bit 5 (case bit) based on DAWG flag.

#### Function 0x015A - Conditional XOR Based on Bit 6
```asm
015A: LINK       A6,#-2
015E: MOVEQ      #0,D0
0160: MOVE.B     9(A6),D0         ; DAWG offset
...
016A: BTST       #6,(A0)          ; Test bit 6
016E: BEQ.S      $017A            ; If clear, skip
0170: MOVE.W     8(A6),D0
0174: EORI.W     #$0020,D0        ; Toggle case
0178: BRA.S      $017E
017A: MOVE.W     8(A6),D0         ; Return unchanged
017E: UNLK       A6
0180: RTS
```

## Part 2: String Utility Functions

### Function 0x0182 - memcpy (Block Copy)
```asm
0182: MOVE.L     4(A7),D0         ; dest
0186: MOVEA.L    D0,A0
0188: MOVEA.L    8(A7),A1         ; src
018C: MOVE.L     12(A7),D1        ; count
0190: BRA.S      $0196
0192: MOVE.B     (A1)+,(A0)+      ; Copy byte
0194: SUBQ.L     #1,D1
0196: ...                         ; Loop while count > 0
0198: RTS
```

### Function 0x0218 - strcpy (String Copy)
```asm
0218: MOVEA.L    4(A7),A0         ; dest
021C: MOVEA.L    8(A7),A1         ; src
0220: MOVE.L     A0,D0            ; Return dest
0222: MOVE.B     (A1)+,(A0)+      ; Copy byte
0224: BNE.S      $0222            ; Loop until null
0226: RTS
```

### Function 0x0228 - strcat (String Concatenate)
```asm
0228: MOVEA.L    4(A7),A0         ; dest
022C: MOVEA.L    8(A7),A1         ; src
0230: MOVE.L     A0,D0            ; Return dest
0232: TST.B      (A0)+            ; Find end of dest
0234: BNE.S      $0232
0236: SUBQ.L     #1,A0            ; Back to null
0238: MOVE.B     (A1)+,(A0)+      ; Copy src
023A: BNE.S      $0238
023C: RTS
```

### Function 0x023E - strcmp (String Compare)
```asm
023E: MOVEA.L    4(A7),A0         ; str1
0242: MOVEA.L    8(A7),A1         ; str2
0246: MOVEQ      #0,D0            ; Assume equal
0248: BRA.S      $024E
024A: TST.B      D1               ; Check if both null
024C: BEQ.S      $025A            ; Equal
024E: MOVE.B     (A0)+,D1         ; Get char from str1
0250: CMP.B      (A1)+,D1         ; Compare with str2
0252: BEQ.S      $024A            ; Equal - continue
0254: BHI.S      $0258            ; str1 > str2
0256: SUBQ.L     #1,D0            ; Return -1
0258: ADDQ.L     #1,D0            ; Return 1
025A: RTS
```

### Function 0x025C - strchr (Find Character in String)
```asm
025C: MOVEA.L    4(A7),A0         ; str
0260: MOVE.B     9(A7),D1         ; char to find
0264: MOVEQ      #0,D0            ; Default NULL
0266: BRA.S      $026C
0268: TST.B      (A0)+            ; Check for null
026A: BEQ.S      $0272            ; Not found
026C: CMP.B      (A0),D1          ; Compare
026E: BNE.S      $0268            ; Not match
0270: MOVE.L     A0,D0            ; Found - return pointer
0272: RTS
```

### Function 0x0274 - strrchr (Find Last Character)
```asm
0274: MOVEA.L    4(A7),A0         ; str
0278: MOVEQ      #-1,D0           ; Not found
027A: ...                         ; Loop from end
...
028C: RTS
```

### Function 0x028E - strpbrk (Find Any of Characters)
```asm
028E: MOVEA.L    4(A7),A0         ; str
0292: MOVEQ      #0,D0            ; Default NULL
...                               ; Search for any char in set
02A8: RTS
```

### Function 0x02AA - strrchr Variant
```asm
02AA: MOVEA.L    4(A7),A0
02AE: MOVE.B     9(A7),D1
02B2: MOVEQ      #0,D0
...
02BE: RTS
```

### Function 0x02C0 - strstr (Find Substring)
```asm
02C0: MOVEA.L    4(A7),A0         ; haystack
02C4: MOVEQ      #0,D0            ; Default NULL
...                               ; Search for needle
02DA: RTS
```

### Function 0x02FA - strtok (Tokenize String)
```asm
02FA: MOVE.L     4(A7),D0         ; str (NULL to continue)
02FE: BNE.S      $0306            ; New string
0300: MOVE.L     -808(A5),D0      ; A5-808 = g_strtok_ptr (saved position)
0304: BEQ.S      $0336            ; No more tokens
0306: CLR.L      -808(A5)         ; Clear saved
030A: MOVEA.L    D0,A0
...                               ; Find delimiter, save next position
0330: MOVE.L     A0,-808(A5)      ; Save position for next call
0334: CLR.B      -(A0)            ; Terminate token
0336: RTS
```

### Function 0x0338 - strlen (String Length)
```asm
0338: MOVEQ      #-1,D0           ; Start at -1
033A: MOVEA.L    4(A7),A0
033E: ADDQ.L     #1,D0            ; Increment
0340: TST.B      (A0)+            ; Check char
0342: BNE.S      $033E            ; Loop until null
0344: RTS
```

### Function 0x0346 - strncpy (Bounded String Copy)
```asm
0346: MOVE.L     4(A7),D0         ; dest
034A: MOVEA.L    D0,A0
034C: MOVEA.L    8(A7),A1         ; src
0350: MOVE.L     12(A7),D1        ; max count
0354: BEQ.S      $0360            ; Zero count
0356: MOVE.B     (A1),(A0)+       ; Copy char
0358: BEQ.S      $035C            ; If null, pad
035A: ADDQ.L     #1,A1            ; Advance src
035C: SUBQ.L     #1,D1            ; Decrement count
035E: BNE.S      $0356            ; Continue
0360: RTS
```

### Function 0x0362 - strncat (Bounded String Concatenate)
```asm
0362: MOVE.L     4(A7),D0         ; dest
0366: MOVEA.L    D0,A0
0368: MOVEA.L    8(A7),A1         ; src
036C: MOVE.L     12(A7),D1        ; max count
0370: BEQ.S      $0382            ; Zero count
0372: TST.B      (A0)+            ; Find end of dest
0374: BNE.S      $0372
0376: SUBQ.L     #1,A0            ; Back to null
...
0382: RTS
```

### Function 0x0384 - strncmp (Bounded String Compare)
```asm
0384: MOVEQ      #0,D0            ; Assume equal
0386: MOVEA.L    4(A7),A0         ; str1
038A: MOVEA.L    8(A7),A1         ; str2
038E: MOVE.L     12(A7),D1        ; max count
...
03A8: RTS
```

## Global Variables

| Offset | Purpose |
|--------|---------|
| A5+offset | DAWG data (indexed by function parameter) |
| A5-808 | g_strtok_ptr - strtok saved position |

## DAWG Entry Structure (inferred)

Based on the bit masks used:
```
Byte layout with bits:
Bit 7 (0x80): End-of-word flag
Bit 6 (0x40): Unknown flag
Bit 5 (0x20): (Case toggle flag?)
Bit 4 (0x10): Unknown flag
Bit 3 (0x08): Unknown flag
Bit 2 (0x04): Unknown flag
Bit 1 (0x02): Unknown flag
Bit 0 (0x01): Last sibling flag
```

## Why 23 CODE Segments Call This

CODE 52 is called by nearly half of all CODE segments because:
1. It's the **only way to access DAWG entry flags**
2. Every DAWG traversal needs to check end-of-word and sibling flags
3. The string utilities are fundamental C library functions

## C Library Implementation

The string functions are a complete C runtime library implementation:
- Memory: memcpy
- String: strlen, strcpy, strncpy, strcat, strncat
- Compare: strcmp, strncmp
- Search: strchr, strrchr, strpbrk, strstr, strtok

## C Equivalent

```c
// DAWG flag accessor
int dawg_get_flags_0x80(int offset) {
    char* dawg = (char*)A5;  // A5-relative
    char flags = dawg[offset];
    return flags & 0x80;  // End-of-word
}

// Case toggle based on flag
int dawg_maybe_toggle_case(int offset, int letter) {
    char* dawg = (char*)A5;
    if (dawg[offset] & 0x80) {  // Check bit 7
        return letter ^ 0x20;  // Toggle case
    }
    return letter;
}

// Standard C functions
void* memcpy(void* dest, const void* src, size_t n);
char* strcpy(char* dest, const char* src);
char* strcat(char* dest, const char* src);
int strcmp(const char* s1, const char* s2);
char* strchr(const char* s, int c);
// etc.
```

## Confidence: VERY HIGH

The repetitive pattern with different bit masks is unmistakable:
- First 14 functions are DAWG bit field accessors
- Remaining functions are standard C string library
- The `A5-808` global for strtok confirms this is a C runtime implementation

---

## Speculative C Translation

### Part 1: DAWG Flag Accessor Functions

```c
/*
 * DAWG (Directed Acyclic Word Graph) Entry Structure
 *
 * Each DAWG node is accessed at an offset from the A5 globals base.
 * The flag byte contains navigation and word-ending information.
 *
 * Flag byte bit layout:
 *   Bit 7 (0x80): End-of-word marker - this node completes a valid word
 *   Bit 6 (0x40): Unknown flag (possibly word continuation)
 *   Bit 5 (0x20): Case flag (used with letter toggle)
 *   Bit 4 (0x10): Unknown flag
 *   Bit 3 (0x08): Unknown flag
 *   Bit 2 (0x04): Unknown flag
 *   Bit 1 (0x02): Unknown flag (with bit 0: sibling info)
 *   Bit 0 (0x01): Last sibling marker - no more siblings at this level
 */

/* Global DAWG data base pointer (conceptually A5) */
extern char *g_dawg_base;

/*
 * dawg_get_flags_D0 - Get combined flags (bits 4,6,7)
 * Mask: 0x00D0
 * JT offset: 3424
 *
 * @param dawg_offset: Offset to DAWG entry from base
 * @return: Flag bits masked with 0xD0
 */
short dawg_get_flags_D0(unsigned char dawg_offset) {
    char flags_byte = g_dawg_base[dawg_offset];
    return (short)(flags_byte & 0x00D0);
}

/*
 * dawg_get_flags_C0 - Get high flags (bits 6,7)
 * Mask: 0x00C0
 * JT offset: 3432
 */
short dawg_get_flags_C0(unsigned char dawg_offset) {
    char flags_byte = g_dawg_base[dawg_offset];
    return (short)(flags_byte & 0x00C0);
}

/*
 * dawg_get_sibling_flags - Get sibling/terminal flags (bits 0,1)
 * Mask: 0x0003
 * JT offset: 3440
 *
 * Used to determine if this is the last sibling at current level.
 */
short dawg_get_sibling_flags(unsigned char dawg_offset) {
    char flags_byte = g_dawg_base[dawg_offset];
    return (short)(flags_byte & 0x0003);
}

/*
 * dawg_get_flag_10 - Get single flag (bit 4)
 * Mask: 0x0010
 * JT offset: 3448
 */
short dawg_get_flag_10(unsigned char dawg_offset) {
    char flags_byte = g_dawg_base[dawg_offset];
    return (short)(flags_byte & 0x0010);
}

/*
 * dawg_get_flags_D8 - Get combined flags (bits 3,4,6,7)
 * Mask: 0x00D8
 * JT offset: 3456
 */
short dawg_get_flags_D8(unsigned char dawg_offset) {
    char flags_byte = g_dawg_base[dawg_offset];
    return (short)(flags_byte & 0x00D8);
}

/*
 * dawg_is_end_of_word - Check end-of-word marker (bit 7)
 * Mask: 0x0080
 * JT offset: 3464
 *
 * Returns non-zero if this DAWG node represents a complete valid word.
 */
short dawg_is_end_of_word(unsigned char dawg_offset) {
    char flags_byte = g_dawg_base[dawg_offset];
    return (short)(flags_byte & 0x0080);
}

/*
 * dawg_get_flags_DC - Get combined flags (bits 2,3,4,6,7)
 * Mask: 0x00DC
 * JT offset: 3472
 */
short dawg_get_flags_DC(unsigned char dawg_offset) {
    char flags_byte = g_dawg_base[dawg_offset];
    return (short)(flags_byte & 0x00DC);
}

/*
 * dawg_get_flag_08 - Get single flag (bit 3)
 * Mask: 0x0008
 * JT offset: 3480
 */
short dawg_get_flag_08(unsigned char dawg_offset) {
    char flags_byte = g_dawg_base[dawg_offset];
    return (short)(flags_byte & 0x0008);
}

/*
 * dawg_get_flags_06 - Get flags (bits 1,2)
 * Mask: 0x0006
 * JT offset: 3488
 */
short dawg_get_flags_06(unsigned char dawg_offset) {
    char flags_byte = g_dawg_base[dawg_offset];
    return (short)(flags_byte & 0x0006);
}

/*
 * dawg_get_flag_40 - Get single flag (bit 6)
 * Mask: 0x0040
 * JT offset: 3496
 */
short dawg_get_flag_40(unsigned char dawg_offset) {
    char flags_byte = g_dawg_base[dawg_offset];
    return (short)(flags_byte & 0x0040);
}

/*
 * dawg_get_flags_30 - Get flags (bits 4,5)
 * Mask: 0x0030
 * JT offset: 3504
 */
short dawg_get_flags_30(unsigned char dawg_offset) {
    char flags_byte = g_dawg_base[dawg_offset];
    return (short)(flags_byte & 0x0030);
}
```

### Special DAWG Accessor Functions

```c
/*
 * dawg_conditional_case_toggle_bit7 - Toggle case if bit 7 set
 * JT offset: 3512 (approximate)
 *
 * If the DAWG entry has bit 7 (end-of-word) set, toggles the case
 * of the input letter by XORing with 0x20 (ASCII case bit).
 *
 * @param dawg_offset: Offset to DAWG entry
 * @param letter: ASCII letter to potentially toggle
 * @return: Original or case-toggled letter
 */
short dawg_conditional_case_toggle_bit7(unsigned char dawg_offset,
                                         short letter) {
    char flags_byte = g_dawg_base[dawg_offset];

    /* Check if bit 7 (sign bit when treated as signed) is set */
    if (flags_byte < 0) {  /* BPL.S branches if positive (bit 7 clear) */
        return letter ^ 0x0020;  /* Toggle ASCII case bit */
    }

    return letter;
}

/*
 * dawg_conditional_case_toggle_bit6 - Toggle case if bit 6 set
 * JT offset: 3520 (approximate)
 *
 * Similar to above but checks bit 6 instead of bit 7.
 *
 * @param dawg_offset: Offset to DAWG entry
 * @param letter: ASCII letter to potentially toggle
 * @return: Original or case-toggled letter
 */
short dawg_conditional_case_toggle_bit6(unsigned char dawg_offset,
                                         short letter) {
    char flags_byte = g_dawg_base[dawg_offset];

    /* Check bit 6 explicitly */
    if (flags_byte & 0x40) {
        return letter ^ 0x0020;  /* Toggle ASCII case bit */
    }

    return letter;
}
```

### Part 2: Standard C String Library Implementation

```c
/*
 * memcpy - Copy memory block
 *
 * Standard C library function implemented in 68K assembly.
 *
 * @param dest: Destination buffer
 * @param src: Source buffer
 * @param count: Number of bytes to copy
 * @return: Destination pointer
 */
void* memcpy(void *dest, const void *src, size_t count) {
    unsigned char *d = (unsigned char*)dest;
    const unsigned char *s = (const unsigned char*)src;

    while (count > 0) {
        *d++ = *s++;
        count--;
    }

    return dest;
}

/*
 * memmove - Copy with overlap handling
 *
 * Handles overlapping source and destination.
 */
void* memmove(void *dest, const void *src, size_t count) {
    unsigned char *d = (unsigned char*)dest;
    const unsigned char *s = (const unsigned char*)src;

    if (count == 0) return dest;

    /* Check for overlap requiring reverse copy */
    if (s < d && d < s + count) {
        /* Copy backwards */
        d += count;
        s += count;
        while (count > 0) {
            *--d = *--s;
            count--;
        }
    } else {
        /* Copy forwards */
        while (count > 0) {
            *d++ = *s++;
            count--;
        }
    }

    return dest;
}

/*
 * memcmp - Compare memory blocks
 */
int memcmp(const void *s1, const void *s2, size_t count) {
    const unsigned char *p1 = (const unsigned char*)s1;
    const unsigned char *p2 = (const unsigned char*)s2;

    while (count > 0) {
        if (*p1 != *p2) {
            return (*p1 < *p2) ? -1 : 1;
        }
        p1++;
        p2++;
        count--;
    }

    return 0;  /* Equal */
}

/*
 * memset - Fill memory with byte value
 */
void* memset(void *dest, int value, size_t count) {
    unsigned char *d = (unsigned char*)dest;
    unsigned char byte_val = (unsigned char)value;

    while (count > 0) {
        *d++ = byte_val;
        count--;
    }

    return dest;
}

/*
 * memchr - Find byte in memory block
 */
void* memchr(const void *s, int c, size_t count) {
    const unsigned char *p = (const unsigned char*)s;
    unsigned char byte_val = (unsigned char)c;

    while (count > 0) {
        if (*p == byte_val) {
            return (void*)p;
        }
        p++;
        count--;
    }

    return NULL;
}

/*
 * strlen - Get string length
 */
size_t strlen(const char *s) {
    size_t len = 0;

    while (*s++ != '\0') {
        len++;
    }

    return len;
}

/*
 * strcpy - Copy string
 */
char* strcpy(char *dest, const char *src) {
    char *result = dest;

    while ((*dest++ = *src++) != '\0') {
        /* Copy including null terminator */
    }

    return result;
}

/*
 * strncpy - Copy string with length limit
 */
char* strncpy(char *dest, const char *src, size_t count) {
    char *result = dest;

    while (count > 0) {
        if (*src != '\0') {
            *dest++ = *src++;
        } else {
            *dest++ = '\0';  /* Pad with nulls */
        }
        count--;
    }

    return result;
}

/*
 * strcat - Concatenate strings
 */
char* strcat(char *dest, const char *src) {
    char *result = dest;

    /* Find end of dest */
    while (*dest != '\0') {
        dest++;
    }

    /* Copy src */
    while ((*dest++ = *src++) != '\0') {
        /* Copy including null */
    }

    return result;
}

/*
 * strncat - Concatenate with length limit
 */
char* strncat(char *dest, const char *src, size_t count) {
    char *result = dest;

    /* Find end of dest */
    while (*dest != '\0') {
        dest++;
    }

    /* Copy up to count chars from src */
    while (count > 0 && *src != '\0') {
        *dest++ = *src++;
        count--;
    }

    *dest = '\0';  /* Always null-terminate */

    return result;
}

/*
 * strcmp - Compare strings
 */
int strcmp(const char *s1, const char *s2) {
    while (*s1 == *s2) {
        if (*s1 == '\0') {
            return 0;  /* Equal */
        }
        s1++;
        s2++;
    }

    return (*s1 < *s2) ? -1 : 1;
}

/*
 * strncmp - Compare strings with length limit
 */
int strncmp(const char *s1, const char *s2, size_t count) {
    while (count > 0) {
        if (*s1 != *s2) {
            return (*s1 < *s2) ? -1 : 1;
        }
        if (*s1 == '\0') {
            return 0;  /* Equal (both ended) */
        }
        s1++;
        s2++;
        count--;
    }

    return 0;  /* Equal for first count chars */
}

/*
 * strchr - Find character in string
 */
char* strchr(const char *s, int c) {
    char ch = (char)c;

    while (*s != '\0') {
        if (*s == ch) {
            return (char*)s;
        }
        s++;
    }

    /* Check for searching for null terminator */
    if (ch == '\0') {
        return (char*)s;
    }

    return NULL;
}

/*
 * strrchr - Find last occurrence of character
 */
char* strrchr(const char *s, int c) {
    char ch = (char)c;
    const char *last = NULL;

    while (*s != '\0') {
        if (*s == ch) {
            last = s;
        }
        s++;
    }

    if (ch == '\0') {
        return (char*)s;
    }

    return (char*)last;
}

/*
 * strpbrk - Find any character from set in string
 */
char* strpbrk(const char *s, const char *accept) {
    while (*s != '\0') {
        const char *a = accept;
        while (*a != '\0') {
            if (*s == *a) {
                return (char*)s;
            }
            a++;
        }
        s++;
    }

    return NULL;
}

/*
 * strstr - Find substring in string
 */
char* strstr(const char *haystack, const char *needle) {
    if (*needle == '\0') {
        return (char*)haystack;
    }

    while (*haystack != '\0') {
        const char *h = haystack;
        const char *n = needle;

        while (*n != '\0' && *h == *n) {
            h++;
            n++;
        }

        if (*n == '\0') {
            return (char*)haystack;  /* Found */
        }

        haystack++;
    }

    return NULL;
}

/* Global state for strtok */
static char *g_strtok_ptr;  /* A5-808 */

/*
 * strtok - Tokenize string
 */
char* strtok(char *str, const char *delim) {
    char *token_start;

    /* Use saved position if str is NULL */
    if (str == NULL) {
        str = g_strtok_ptr;
        if (str == NULL) {
            return NULL;  /* No more tokens */
        }
    }

    /* Clear saved position */
    g_strtok_ptr = NULL;

    /* Skip leading delimiters */
    while (*str != '\0' && strchr(delim, *str) != NULL) {
        str++;
    }

    if (*str == '\0') {
        return NULL;  /* No token found */
    }

    token_start = str;

    /* Find end of token */
    while (*str != '\0' && strchr(delim, *str) == NULL) {
        str++;
    }

    if (*str != '\0') {
        /* Save position for next call */
        g_strtok_ptr = str + 1;
        *str = '\0';  /* Terminate token */
    }

    return token_start;
}
```

### Why DAWG Accessors Are Critical

Every DAWG traversal operation needs to:
1. Check end-of-word flag (0x80) to know if current path forms valid word
2. Check sibling flags (0x03) to know when to stop iterating siblings
3. Get combined flags for navigation decisions

The case-toggle functions (0x0134, 0x015A) suggest the DAWG stores case information as flags rather than in the letter data itself, allowing compact representation.
