# CODE 15 Analysis - Word Lister

## Overview

| Property | Value |
|----------|-------|
| Size | 3568 bytes |
| JT Offset | 736 |
| JT Entries | 5 |
| Functions | 20 |
| Categories | DAWG_ACCESS, UI_DRAWING |
| Purpose | **Word Lister Dialog** |
| Confidence | **HIGH** (confirmed via QEMU tracing) |

## Function

**Word Lister** - The "Word Lister..." menu item handler that allows users to:
- Enter a rack of letters (or wildcards like `?`)
- Find all valid words that can be formed
- Display results in a scrollable list

### Verified via QEMU Tracing

Testing with 7 wildcards (`???????`) showed:
- First 1000 words displayed from "aa" to "alef"
- Enumerates words by walking the DAWG structure
- Uses both Section 1 and Section 2 of the DAWG

## Functions

Entry points at: 0x0000, 0x00CE, 0x0124, 0x0194, 0x01C4, 0x023A, 0x0272, 0x0356, 0x03D6, 0x0404, 0x0458, 0x04CE, 0x05A6, 0x0670, 0x0936, 0x09D6, 0x0AA4, 0x0B6A, 0x0CA4, 0x0D48

## Toolbox Traps Used

| Trap | Name |
|------|------|
| $A887 | _MoveTo |

## Known Global Variables

| Offset | Name | Description |
|--------|------|-------------|
| A5-24026 | g_common | Common data area |
| A5-15522 | g_field_22 | Board buffer 2 (hook-after) |
| A5-15514 | g_field_14 | Board buffer 1 (hook-before) |
| A5-8584 | g_handle | Handle to data structure |
| A5-8510 | g_window_ptr | Main window pointer |

Also references 61 unknown A5-relative globals.

## Jump Table Calls

| Offset | Purpose |
|--------|---------|
| 74(A5) | get size/count |
| 130(A5) | unknown |
| 242(A5) | unknown |
| 250(A5) | unknown |
| 418(A5) | bounds_check / error |
| 426(A5) | memset/clear |
| 530(A5) | unknown |
| 626(A5) | unknown |
| 1290(A5) | unknown |
| 1298(A5) | unknown |
| 1362(A5) | state_update |
| 1386(A5) | unknown |
| 1394(A5) | unknown |
| 1498(A5) | unknown |
| 1546(A5) | unknown |
| 1570(A5) | unknown |
| 1850(A5) | unknown |
| 2066(A5) | init/copy function |
| 2538(A5) | unknown |
| 2826(A5) | unknown |
| 2842(A5) | unknown |
| 2850(A5) | unknown |
| 2858(A5) | unknown |
| 2866(A5) | unknown |
| 2882(A5) | unknown |
| 2914(A5) | unknown |
| 2922(A5) | unknown |
| 3042(A5) | unknown |
| 3130(A5) | unknown |
| 3346(A5) | unknown |
| 3386(A5) | unknown |
| 3466(A5) | unknown |

## Analysis Notes

- **DAWG-related**: Uses 2 DAWG-related globals
- Uses the two-buffer system (hook-before/hook-after cross-check computation)

## Refined Analysis (Second Pass)

**Cluster**: DAWG Engine
**Category**: DAWG_TRAVERSAL
**Global Variable Profile**: 2 DAWG, 2 UI, 67 total
**Calls functions in**: CODE 3, 7, 9, 11, 12, 14, 17, 21, 22, 27, 34, 36, 41, 46, 47, 51, 52

**Assessment**: DAWG traversal support for Word Lister

## Speculative Decompilation

**Full decompilation available**: See `analysis/detailed/code15_detailed.md`

### Key Functions

#### walk_to_next_child (0x00CE)
```c
long walk_to_next_child(char** pattern_ptr) {
    char target_letter = **pattern_ptr;
    long current_pos = g_dawg_current_pos;      /* A5-11964 */
    long* dawg_base = g_dawg_base_ptr;          /* A5-11960 */

    while (target_letter != '\0') {
        long entry = dawg_base[current_pos];
        char entry_letter = (char)(entry & 0xFF);

        if (entry_letter == target_letter) {
            long child_pos = entry >> 10;  /* Child index */
            if (child_pos == 0) break;
            (*pattern_ptr)++;
            target_letter = **pattern_ptr;
            current_pos = child_pos;
        } else if (entry & 0x200) {  /* Bit 9 = last sibling */
            return 0;
        } else {
            current_pos++;
        }
    }
    return current_pos;
}
```

### DAWG Entry Format (Runtime)
```
Bits 0-7:   Letter (ASCII)
Bit 8:      End-of-word flag
Bit 9:      Last-sibling flag
Bits 10-31: Child node index (22 bits)
```

### Key Discovery: Cross-Check Flag Semantics

The DAWG's `is_word` flag (bit 8) marks positions valid for **cross-checking**, not just dictionary words. This explains:
- Brute-force validation produces ~5x more 2-letter "words" than real dictionary
- Direct enumeration produces 49M+ entries vs ~267K actual words
- Reference-based validation is required for accurate dictionary extraction
