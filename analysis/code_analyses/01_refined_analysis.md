# Maven CODE Resources - Refined Second Pass Analysis

## Methodology

This analysis uses patterns discovered in the first pass to refine categorization:
- Jump table call clustering
- Global variable access patterns
- Inter-segment call graph
- Trap usage patterns

## Functional Clusters

### Core AI / DAWG Engine

| CODE | Size | JT Entries | DAWG Refs | Description |
|------|------|------------|-----------|-------------|
| 3 | 4390 | 6 | 11 | DAWG search coordinator |
| 11 | 4478 | 19 | 7 | Game controller / main loop |
| 21 | 13718 | 39 | 6 | Main UI + DAWG display (largest) |
| 22 | 2056 | 6 | 5 | DAWG-heavy processing |

### DAWG Support Functions

| CODE | Size | JT Entries | DAWG Refs | Description |
|------|------|------------|-----------|-------------|
| 5 | 204 | 1 | 5 | DAWG-heavy processing |
| 6 | 1026 | 7 | 3 | DAWG-heavy processing |
| 7 | 2872 | 13 | 5 | Board/rack state management |
| 8 | 2326 | 3 | 3 | DAWG-heavy processing |
| 13 | 512 | 4 | 1 | File dialogs |
| 14 | 2766 | 14 | 3 | DAWG-heavy processing |
| 15 | 3568 | 5 | 2 | General purpose |
| 18 | 4460 | 4 | 1 | General purpose |
| 20 | 3398 | 17 | 1 | General purpose |
| 27 | 662 | 4 | 1 | General purpose |
| 28 | 664 | 3 | 3 | DAWG-heavy processing |
| 29 | 686 | 8 | 2 | General purpose |
| 30 | 3492 | 12 | 7 | DAWG-heavy processing |
| 31 | 2510 | 15 | 2 | General purpose |
| 32 | 6464 | 13 | 1 | File dialogs |
| 35 | 3276 | 4 | 1 | File dialogs |
| 36 | 9102 | 5 | 1 | Large DAWG segment |
| 38 | 374 | 2 | 1 | General purpose |
| 40 | 624 | 4 | 1 | General purpose |
| 44 | 424 | 4 | 1 | General purpose |
| 45 | 1122 | 4 | 3 | DAWG-heavy processing |

### Main UI / Drawing

| CODE | Size | JT Entries | DAWG Refs | Description |
|------|------|------------|-----------|-------------|
| 46 | 2904 | 12 | 0 | General purpose |

### File I/O

| CODE | Size | JT Entries | DAWG Refs | Description |
|------|------|------------|-----------|-------------|
| 16 | 1894 | 5 | 0 | File dialogs |
| 24 | 6786 | 3 | 0 | File save/load |
| 50 | 1174 | 1 | 0 | File dialogs |

### Utilities

| CODE | Size | JT Entries | DAWG Refs | Description |
|------|------|------------|-----------|-------------|
| 1 | 574 | 10 | 0 | Application startup |
| 4 | 108 | 2 | 0 | Startup stub |
| 10 | 138 | 3 | 0 | Small utility |
| 19 | 382 | 10 | 0 | General purpose |
| 23 | 608 | 7 | 0 | General purpose |
| 25 | 200 | 1 | 0 | General purpose |
| 47 | 908 | 4 | 0 | General purpose |
| 48 | 1092 | 15 | 0 | General purpose |
| 49 | 546 | 2 | 0 | General purpose |
| 51 | 236 | 6 | 0 | General purpose |
| 52 | 938 | 14 | 0 | General purpose |
| 53 | 106 | 1 | 0 | Small utility |
| 54 | 42 | 1 | 0 | Small utility |

### Needs Further Analysis

| CODE | Size | JT Entries | DAWG Refs | Description |
|------|------|------------|-----------|-------------|
| 0 | 3564 | 3584 | 0 | Jump table (not executable) |
| 2 | 750 | 4 | 0 | General purpose |
| 9 | 3940 | 37 | 0 | General purpose |
| 12 | 2722 | 8 | 0 | General purpose |
| 17 | 2618 | 29 | 0 | General purpose |
| 34 | 1388 | 31 | 0 | General purpose |
| 37 | 5344 | 4 | 0 | Large segment |
| 39 | 1784 | 4 | 0 | General purpose |
| 41 | 660 | 8 | 0 | General purpose |
| 42 | 734 | 2 | 0 | General purpose |
| 43 | 1486 | 4 | 0 | General purpose |

## Jump Table Function Mapping

### Most Called JT Functions

| JT Offset | Called By | Likely Implementing CODE | Purpose |
|-----------|-----------|-------------------------|---------|
| 418(A5) | 36 CODEs | CODE 11 | Bounds check / assertion |
| 426(A5) | 23 CODEs | CODE 11 | Memory clear (memset) |
| 3522(A5) | 23 CODEs | CODE 52 | Unknown |
| 3490(A5) | 16 CODEs | CODE 52 | Global data copy |
| 66(A5) | 15 CODEs | CODE ? | Common utility (string/data) |
| 2410(A5) | 14 CODEs | CODE 31 | Setup buffer |
| 3466(A5) | 14 CODEs | CODE 52 | Unknown |
| 90(A5) | 13 CODEs | CODE 2 | Arithmetic calculation |
| 2826(A5) | 12 CODEs | CODE 34 | Unknown |
| 2066(A5) | 11 CODEs | CODE 17 | Data copy/init |
| 3506(A5) | 10 CODEs | CODE 52 | Comparison function |
| 74(A5) | 10 CODEs | CODE ? | Get size/count |
| 3562(A5) | 8 CODEs | CODE 52 | Unknown |
| 2394(A5) | 8 CODEs | CODE 31 | Setup function |
| 2370(A5) | 7 CODEs | CODE 31 | Setup search params |
| 1362(A5) | 7 CODEs | CODE 21 | State update |
| 3514(A5) | 7 CODEs | CODE 52 | Unknown |
| 658(A5) | 6 CODEs | CODE 11 | Init subsystem |
| 3130(A5) | 6 CODEs | CODE 34 | Unknown |
| 3554(A5) | 6 CODEs | CODE 52 | Unknown |
| 3098(A5) | 5 CODEs | CODE 34 | Unknown |
| 1602(A5) | 5 CODEs | CODE 21 | Unknown |
| 1482(A5) | 5 CODEs | CODE 21 | Unknown |
| 1514(A5) | 5 CODEs | CODE 21 | Unknown |
| 2850(A5) | 5 CODEs | CODE 34 | Unknown |
| 2866(A5) | 5 CODEs | CODE 34 | Unknown |
| 2618(A5) | 5 CODEs | CODE 39 | Unknown |
| 2122(A5) | 5 CODEs | CODE 17 | Buffer comparison/scoring |
| 2434(A5) | 4 CODEs | CODE 31 | DAWG-related (inferred) |
| 1258(A5) | 4 CODEs | CODE 21 | Post-search initialization |

## Inter-Segment Call Graph

Which CODE resources call functions in other CODE resources:

- **CODE 2** calls: CODE 9, CODE 11, CODE 15, CODE 27, CODE 41, CODE 48, CODE 51, CODE 52
- **CODE 3** calls: CODE 2, CODE 4, CODE 9, CODE 10, CODE 11, CODE 14, CODE 17, CODE 20, CODE 21, CODE 27, CODE 29, CODE 30, CODE 31, CODE 32, CODE 34, CODE 36, CODE 37, CODE 39, CODE 47, CODE 48, CODE 51, CODE 52
- **CODE 4** calls: CODE 2
- **CODE 5** calls: CODE 7, CODE 14, CODE 20, CODE 21, CODE 22, CODE 32, CODE 52
- **CODE 6** calls: CODE 3, CODE 11, CODE 21, CODE 27, CODE 52
- **CODE 7** calls: CODE 9, CODE 11, CODE 14, CODE 20, CODE 21, CODE 22, CODE 27, CODE 29, CODE 31, CODE 32, CODE 34, CODE 41, CODE 52
- **CODE 8** calls: CODE 4, CODE 11, CODE 20, CODE 21, CODE 22, CODE 24, CODE 27, CODE 31, CODE 32, CODE 41, CODE 52
- **CODE 9** calls: CODE 2, CODE 11, CODE 23, CODE 34, CODE 46, CODE 51, CODE 52
- **CODE 10** calls: CODE 7, CODE 9, CODE 11
- **CODE 11** calls: CODE 7, CODE 8, CODE 9, CODE 10, CODE 14, CODE 16, CODE 18, CODE 20, CODE 21, CODE 22, CODE 31, CODE 32, CODE 34, CODE 41, CODE 46, CODE 48, CODE 52
- **CODE 12** calls: CODE 9, CODE 11, CODE 16, CODE 17, CODE 24, CODE 27, CODE 41, CODE 46, CODE 47, CODE 48, CODE 52
- **CODE 13** calls: CODE 11, CODE 29, CODE 45
- **CODE 14** calls: CODE 8, CODE 9, CODE 11, CODE 17, CODE 20, CODE 21, CODE 22, CODE 25, CODE 27, CODE 32, CODE 34, CODE 41, CODE 45, CODE 46, CODE 52
- **CODE 15** calls: CODE 3, CODE 7, CODE 9, CODE 11, CODE 12, CODE 14, CODE 17, CODE 21, CODE 22, CODE 27, CODE 34, CODE 36, CODE 41, CODE 46, CODE 47, CODE 51, CODE 52
- **CODE 16** calls: CODE 2, CODE 9, CODE 17, CODE 27, CODE 34, CODE 41, CODE 46
- **CODE 17** calls: CODE 9, CODE 11, CODE 34, CODE 46, CODE 52
- **CODE 18** calls: CODE 2, CODE 9, CODE 11, CODE 15, CODE 17, CODE 20, CODE 23, CODE 24, CODE 27, CODE 31, CODE 32, CODE 34, CODE 36, CODE 41, CODE 46, CODE 52
- **CODE 19** calls: CODE 6, CODE 20, CODE 21
- **CODE 20** calls: CODE 11, CODE 14, CODE 21, CODE 22, CODE 52
- **CODE 21** calls: CODE 2, CODE 7, CODE 8, CODE 9, CODE 10, CODE 11, CODE 14, CODE 15, CODE 20, CODE 22, CODE 24, CODE 27, CODE 31, CODE 32, CODE 34, CODE 41, CODE 48, CODE 49, CODE 52
- **CODE 22** calls: CODE 2, CODE 9, CODE 10, CODE 11, CODE 14, CODE 16, CODE 21, CODE 24, CODE 27, CODE 32, CODE 34, CODE 41, CODE 51, CODE 52
- **CODE 23** calls: CODE 27, CODE 52
- **CODE 24** calls: CODE 2, CODE 32, CODE 52
- **CODE 25** calls: CODE 2, CODE 9, CODE 11
- **CODE 27** calls: CODE 11, CODE 40, CODE 44, CODE 52
- **CODE 28** calls: CODE 2, CODE 11, CODE 31, CODE 32, CODE 35, CODE 36, CODE 39, CODE 45, CODE 52
- **CODE 29** calls: CODE 11, CODE 30, CODE 31, CODE 32, CODE 39, CODE 40
- **CODE 30** calls: CODE 9, CODE 11, CODE 29, CODE 31, CODE 32, CODE 34, CODE 38, CODE 39, CODE 52
- **CODE 31** calls: CODE 2, CODE 9, CODE 11, CODE 17, CODE 23, CODE 32, CODE 36, CODE 52
- **CODE 32** calls: CODE 2, CODE 9, CODE 11, CODE 16, CODE 23, CODE 31, CODE 52
- **CODE 35** calls: CODE 2, CODE 11, CODE 23, CODE 31, CODE 32, CODE 52
- **CODE 36** calls: CODE 2, CODE 9, CODE 11, CODE 29, CODE 31, CODE 32, CODE 35, CODE 38, CODE 39, CODE 43, CODE 44, CODE 52
- **CODE 37** calls: CODE 11, CODE 16, CODE 23, CODE 31, CODE 32, CODE 52
- **CODE 38** calls: CODE 11, CODE 32
- **CODE 39** calls: CODE 11, CODE 32, CODE 44, CODE 52
- **CODE 40** calls: CODE 11, CODE 28, CODE 29, CODE 34, CODE 39, CODE 44, CODE 45, CODE 52
- **CODE 41** calls: CODE 9, CODE 11, CODE 12, CODE 23, CODE 47, CODE 48
- **CODE 42** calls: CODE 11
- **CODE 43** calls: CODE 11, CODE 32, CODE 52
- **CODE 44** calls: CODE 29, CODE 30, CODE 32, CODE 37, CODE 52
- **CODE 45** calls: CODE 11, CODE 28, CODE 29, CODE 30, CODE 31, CODE 32, CODE 38, CODE 39, CODE 43, CODE 52
- **CODE 46** calls: CODE 9, CODE 11, CODE 52
- **CODE 47** calls: CODE 11, CODE 24, CODE 34, CODE 52
- **CODE 48** calls: CODE 9, CODE 11, CODE 23, CODE 34
- **CODE 49** calls: CODE 2, CODE 9, CODE 11, CODE 34
- **CODE 50** calls: CODE 2, CODE 9, CODE 11, CODE 14, CODE 16, CODE 18, CODE 34
- **CODE 51** calls: CODE 11, CODE 41, CODE 46
- **CODE 53** calls: CODE 9, CODE 11

## Refined Categorization

| CODE | Size | Category | DAWG | UI | Globals | Assessment |
|------|------|----------|------|----|---------|-----------| 
| 0 | 3564 | UNKNOWN | 0 | 0 | 0 | Standard |
| 1 | 574 | UNKNOWN | 0 | 0 | 0 | Utility functions |
| 2 | 750 | UI_SUPPORT | 0 | 1 | 22 | Standard |
| 3 | 4390 | CORE_AI | 11 | 0 | 37 | Core AI - high priority |
| 4 | 108 | TINY_UTIL | 0 | 0 | 1 | Utility functions |
| 5 | 204 | CORE_AI | 5 | 1 | 9 | DAWG support |
| 6 | 1026 | DAWG_SUPPORT | 3 | 1 | 22 | DAWG support |
| 7 | 2872 | CORE_AI | 5 | 3 | 22 | DAWG support |
| 8 | 2326 | DAWG_SUPPORT | 3 | 1 | 28 | DAWG support |
| 9 | 3940 | UNKNOWN | 0 | 0 | 12 | Standard |
| 10 | 138 | TINY_UTIL | 0 | 0 | 1 | Utility functions |
| 11 | 4478 | CORE_AI | 7 | 3 | 41 | Core AI - high priority |
| 12 | 2722 | UNKNOWN | 0 | 0 | 44 | Standard |
| 13 | 512 | DAWG_MINOR | 1 | 1 | 5 | DAWG support |
| 14 | 2766 | DAWG_SUPPORT | 3 | 0 | 33 | DAWG support |
| 15 | 3568 | DAWG_MINOR | 2 | 2 | 67 | DAWG support |
| 16 | 1894 | UI_SUPPORT | 0 | 1 | 16 | File operations |
| 17 | 2618 | UNKNOWN | 0 | 0 | 7 | Standard |
| 18 | 4460 | DAWG_MINOR | 1 | 0 | 78 | DAWG support |
| 19 | 382 | UI_SUPPORT | 0 | 1 | 1 | Utility functions |
| 20 | 3398 | DAWG_MINOR | 1 | 2 | 32 | DAWG support |
| 21 | 13718 | CORE_AI | 6 | 3 | 103 | Core AI - high priority |
| 22 | 2056 | CORE_AI | 5 | 1 | 20 | Core AI - high priority |
| 23 | 608 | UNKNOWN | 0 | 0 | 2 | Utility functions |
| 24 | 6786 | FILE_IO | 0 | 0 | 13 | File operations |
| 25 | 200 | UNKNOWN | 0 | 0 | 1 | Utility functions |
| 27 | 662 | DAWG_MINOR | 1 | 0 | 4 | DAWG support |
| 28 | 664 | DAWG_SUPPORT | 3 | 0 | 9 | DAWG support |
| 29 | 686 | DAWG_MINOR | 2 | 0 | 14 | DAWG support |
| 30 | 3492 | CORE_AI | 7 | 0 | 28 | DAWG support |
| 31 | 2510 | DAWG_MINOR | 2 | 0 | 46 | DAWG support |
| 32 | 6464 | DAWG_MINOR | 1 | 0 | 50 | DAWG support |
| 34 | 1388 | UNKNOWN | 0 | 0 | 0 | Standard |
| 35 | 3276 | DAWG_MINOR | 1 | 0 | 13 | DAWG support |
| 36 | 9102 | DAWG_MINOR | 1 | 0 | 64 | DAWG support |
| 37 | 5344 | UNKNOWN | 0 | 0 | 46 | Large - needs analysis |
| 38 | 374 | DAWG_MINOR | 1 | 0 | 3 | DAWG support |
| 39 | 1784 | UNKNOWN | 0 | 0 | 8 | Standard |
| 40 | 624 | DAWG_MINOR | 1 | 0 | 6 | DAWG support |
| 41 | 660 | UNKNOWN | 0 | 0 | 6 | Standard |
| 42 | 734 | UNKNOWN | 0 | 0 | 7 | Standard |
| 43 | 1486 | UNKNOWN | 0 | 0 | 10 | Standard |
| 44 | 424 | DAWG_MINOR | 1 | 0 | 5 | DAWG support |
| 45 | 1122 | DAWG_SUPPORT | 3 | 0 | 15 | DAWG support |
| 46 | 2904 | UNKNOWN | 0 | 0 | 4 | UI drawing |
| 47 | 908 | UNKNOWN | 0 | 0 | 1 | Utility functions |
| 48 | 1092 | UNKNOWN | 0 | 0 | 1 | Utility functions |
| 49 | 546 | UNKNOWN | 0 | 0 | 3 | Utility functions |
| 50 | 1174 | UI_SUPPORT | 0 | 1 | 2 | File operations |
| 51 | 236 | UNKNOWN | 0 | 0 | 1 | Utility functions |
| 52 | 938 | UNKNOWN | 0 | 0 | 1 | Utility functions |
| 53 | 106 | TINY_UTIL | 0 | 0 | 1 | Utility functions |
| 54 | 42 | TINY_UTIL | 0 | 0 | 0 | Utility functions |

## Key Insights from Second Pass

### DAWG Engine Architecture

- **Core engine**: CODE 3, 11, 21, 22
- **Support functions**: CODE 5, 6, 7, 8, 13, 14, 15, 18, 20, 27, 28, 29, 30, 31, 32, 35, 36, 38, 40, 44, 45
- Total DAWG-related code: ~75174 bytes

### Jump Table Organization

- CODE 2: JT offsets 80-104 (4 functions)
- CODE 3: JT offsets 112-152 (6 functions)
- CODE 5: JT offsets 160-160 (1 functions)
- CODE 6: JT offsets 168-216 (7 functions)
- CODE 7: JT offsets 224-320 (13 functions)
- CODE 8: JT offsets 328-344 (3 functions)
- CODE 10: JT offsets 352-368 (3 functions)
- CODE 11: JT offsets 376-520 (19 functions)
- CODE 12: JT offsets 528-584 (8 functions)
- CODE 13: JT offsets 592-616 (4 functions)
- CODE 14: JT offsets 624-728 (14 functions)
- CODE 15: JT offsets 736-768 (5 functions)
- CODE 16: JT offsets 776-808 (5 functions)
- CODE 18: JT offsets 816-840 (4 functions)
- CODE 19: JT offsets 848-920 (10 functions)
- ... and 36 more

### Recommended Deep-Dive Targets

Based on this analysis, prioritize these for detailed reverse engineering:

1. **CODE 3** (4390 bytes) - Main DAWG search coordinator, 8 DAWG refs
2. **CODE 7** (2872 bytes) - Board state management, two-buffer system
3. **CODE 21** (13718 bytes) - Largest segment, main UI + game logic
4. **CODE 36** (9102 bytes) - Large DAWG segment, likely move scoring
5. **CODE 11** (4478 bytes) - Game controller, state machine
