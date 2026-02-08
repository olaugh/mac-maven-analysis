# ESTR / PATB / EXPR Resource Pipeline Analysis

## Overview

Maven's leave evaluation uses a three-resource data pipeline for pattern-based
synergy scoring. The leave_orchestrator (CODE 32, 0x09D8) iterates pattern entries
and accumulates two independent scoring channels:

1. **EXPR channel** → `g_work_buffer` (A5-17420): per-pattern synergy values
2. **V/C channel** → `g_estr_patterns` (A5-17166): per-pattern vowel/consonant balance

These buffers are later combined by CODE 35 for the final leave score.

## Resource Summary

| Resource | Size | Format | Global Variable |
|----------|------|--------|-----------------|
| **ESTR** | 536 bytes | 130 null-terminated ASCII strings | g_estr_strings (A5-10912) |
| **PATB** | 18,104 bytes | 8-byte entries in 2 sections | g_estr_entries (A5-10918) |
| **EXPR** | 8,960 bytes | 320 × 28-byte records | g_expr_data (A5-10908 via handle) |

---

## CODE 15 Resource Initialization (0x0B6A–0x0C40)

### Context

CODE 15 function at offset 0x0B6A loads and initializes the leave evaluation
data structures. This is called during game setup, after MUL resources are loaded.

### Annotated Disassembly

Decoded manually from the CODE 15 memory dump (`maven_code_15.bin`, offset +4 for
the 4-byte header). Key sequence:

```asm
;======================================================================
; Load ESTR resource → g_estr_strings
;======================================================================
0x0B86: 42A7             CLR.L   -(SP)            ; push NULL (return slot)
0x0B88: 2F3C 4553 5452  MOVE.L  #'ESTR',-(SP)    ; push resource type
0x0B8E: 4267             CLR.W   -(SP)            ; push resource ID = 0
0x0B90: A9A0             _GetResource              ; returns Handle in (SP)
0x0B92: 285F             MOVEA.L (SP)+,A4         ; A4 = ESTR handle
0x0B94: 200C             MOVE.L  A4,D0            ; test for NULL
0x0B96: 6604             BNE.S   $+6              ; if non-NULL, continue
0x0B98: 4EAD 01A2        JSR     418(A5)          ; fatal error handler

0x0B9A: 204C             MOVEA.L A4,A0
0x0B9C: A064             _HNoPurge                ; prevent purging
0x0B9E: 204C             MOVEA.L A4,A0
0x0BA0: A029             _HLock                   ; lock handle
0x0BA2: 2B54 D560        MOVE.L  (A4),-10912(A5)  ; g_estr_strings = *handle
0x0BA6: 2F0C             MOVE.L  A4,-(SP)
0x0BA8: A992             _DetachResource           ; detach from resource map

;======================================================================
; Load PATB resource → g_estr_entries
;======================================================================
0x0BAA: 42A7             CLR.L   -(SP)            ; push NULL (return slot)
0x0BAC: 2F3C 5041 5442  MOVE.L  #'PATB',-(SP)    ; push resource type
0x0BB2: 4267             CLR.W   -(SP)            ; push resource ID = 0
0x0BB4: A9A0             _GetResource              ; returns Handle in (SP)
0x0BB6: 285F             MOVEA.L (SP)+,A4         ; A4 = PATB handle
0x0BB8: 200C             MOVE.L  A4,D0            ; test for NULL
0x0BBA: 6604             BNE.S   $+6
0x0BBC: 4EAD 01A2        JSR     418(A5)          ; fatal error handler

0x0BBE: 204C             MOVEA.L A4,A0
0x0BC0: A064             _HNoPurge
0x0BC2: 204C             MOVEA.L A4,A0
0x0BC4: A029             _HLock
0x0BC6: 2B54 D55A        MOVE.L  (A4),-10918(A5)  ; g_estr_entries = *handle
0x0BCA: 2F0C             MOVE.L  A4,-(SP)
0x0BCC: A992             _DetachResource

;======================================================================
; Compute entry count from JT call
;======================================================================
0x0BCE: 42A7             CLR.L   -(SP)            ; push NULL (return slot)
0x0BD0: 2F0C             MOVE.L  A4,-(SP)         ; push PATB handle? or other arg
0x0BD2: 4EAD 0B0A        JSR     2826(A5)         ; JT[2826] → returns entry count
0x0BD6: 201F             MOVE.L  (SP)+,D0         ; D0 = result
0x0BD8: E688             LSL.L   #3,D0            ; D0 *= 8 (bytes per entry)
0x0BDA: 3B40 D55E        MOVE.W  D0,-10914(A5)    ; g_estr_entry_count = count * 8

;======================================================================
; Loop: initialize PATB entries (sort string pointers)
; Converts string offsets to absolute pointers using g_estr_strings base
;======================================================================
0x0BDE: ...              ; initialization loop
0x0BEA: ...              ; for each PATB entry:
                         ;   entry->string_ptr = g_estr_strings + entry->string_offset
                         ;   (converts relative offsets to absolute pointers)

;======================================================================
; Load EXPR resource → g_expr_data (handle stored for binary_search_expr)
;======================================================================
0x0C0A: 3F2D D5F8        MOVE.W  -2568(A5),-(SP)  ; push resource ID
0x0C0E: 2F3C 4558 5052  MOVE.L  #'EXPR',-(SP)    ; push resource type
0x0C14: 4EBA FE8E        JSR     local_get_resource ; helper that calls _GetResource
0x0C18: 2B40 D564        MOVE.L  D0,-10908(A5)    ; g_expr_handle = result
```

### C Decompilation

```c
/*
 * init_leave_resources - Load ESTR, PATB, and EXPR resources
 *
 * Called during game initialization (CODE 15).
 * Sets up the data structures used by CODE 32's leave_orchestrator.
 *
 * Three resources form the pattern scoring pipeline:
 *   ESTR = pattern string pool (null-terminated ASCII)
 *   PATB = pattern table (8-byte entries mapping strings to EXPR records)
 *   EXPR = pre-computed synergy values (320 × 28-byte MUL-format records)
 */
void init_leave_resources(void) {
    Handle h;

    /* Load ESTR: 130 null-terminated pattern strings */
    h = GetResource('ESTR', 0);
    if (h == NULL) fatal_error();       /* JT[418] */
    HNoPurge(h);
    HLock(h);
    g_estr_strings = *h;               /* A5-10912: dereferenced string pool */
    DetachResource(h);

    /* Load PATB: 8-byte pattern table entries */
    h = GetResource('PATB', 0);
    if (h == NULL) fatal_error();
    HNoPurge(h);
    HLock(h);
    g_estr_entries = *h;               /* A5-10918: dereferenced entry table */
    DetachResource(h);

    /* Compute entry count (result of JT[2826] shifted left 3 = bytes) */
    long count = compute_entry_count(); /* JT[2826] */
    g_estr_entry_count = count * 8;     /* A5-10914: total bytes in entry table */

    /* Convert string offsets to absolute pointers */
    for (int i = 0; i < count; i++) {
        PatbEntry *entry = &g_estr_entries[i];
        entry->string_ptr = g_estr_strings + entry->string_offset;
    }

    /* Load EXPR: 320 × 28-byte synergy records */
    short expr_id = g_resource_id;      /* A5-2568: resource ID */
    g_expr_handle = get_resource('EXPR', expr_id);  /* A5-10908 */
}
```

---

## ESTR Resource Format (536 bytes)

### Structure

The ESTR resource is a pool of 130 null-terminated ASCII strings, stored
contiguously. Strings are sorted in lexicographic order.

### String Sharing Trick

Seven letters (g, h, k, q, t, u, w) have no dedicated single-character string
in the pool. Instead, their PATB entries point to the **second byte** of a
two-character string, exploiting the null terminator to create an implicit
single-character string:

| Missing Letter | Shared String | Offset | Explanation |
|----------------|---------------|--------|-------------|
| g | "gg" at offset 111 | 112 | byte 112 = 'g', byte 113 = '\0' |
| h | "hh" at offset 118 | 119 | byte 119 = 'h', byte 120 = '\0' |
| k | "ck" at offset 62 | 63 | byte 63 = 'k', byte 64 = '\0' |
| q | "aq" at offset 42 | 43 | byte 43 = 'q', byte 44 = '\0' |
| t | "tt" at offset 238 | 239 | byte 239 = 't', byte 240 = '\0' |
| u | "uu" at offset 250 | 251 | byte 251 = 'u', byte 252 = '\0' |
| w | "ww" at offset 267 | 268 | byte 268 = 'w', byte 269 = '\0' |

This saves 14 bytes (7 × 2 bytes per string) in the resource — a typical
Classic Mac space optimization. The PATB string_offset field can point to any
byte position in the ESTR data, not just string boundaries.

### Pattern Categories (130 total)

| Category | Count | Examples |
|----------|-------|---------|
| Single letters | 26 (19 explicit + 7 shared) | a, b, c, ..., z, ? |
| Blank patterns | 2 | ?, ?? |
| Duplicate penalties | 41 | aa, bb, ..., zz, aaa, aaaa, ... |
| Digraph synergies | 4 | ch, ck, ht, hw |
| Q-without-U | 6 | aq, adq, aqt, aiq, adiq, diq |
| Q-with-U | 2 | qu, qt |
| Suffix/word patterns | 20 | gin(=ING), flu, ily, osu(=OUS), ... |
| V/C letter groups | 19 | aeio, lnrtsu, bcmp, fhkwvy, aeiou, ... |
| Alphabet/diagnostic | 1 | abcdefghijklmnopqrstuvwxyz |

### Pattern Purpose

Each pattern represents a set of letter tiles (sorted alphabetically) that may
be present in a leave. The orchestrator checks if each pattern is a multiset
subset of the current leave, and computes V/C balance adjustments for matching
patterns. Multi-letter patterns capture tile synergies (e.g., QU together,
ING-potential with GIN).

---

## PATB Resource Format (18,104 bytes)

### Overall Structure

PATB has two sections:

| Section | Entries | Bytes | Purpose |
|---------|---------|-------|---------|
| Section 1 | 113 | 904 | Leave pattern → EXPR mappings |
| Section 2 | ~2,150 | 17,200 | Blank expansion dispatch tables |

### Entry Format (8 bytes, big-endian)

```c
typedef struct {
    uint32_t string_offset;  /* Byte offset into ESTR string pool */
    uint16_t status_word;    /* EXPR record index (letter_id) */
    uint8_t  flag_byte;      /* 0 for EXPR entries, non-zero for dispatch entries */
    uint8_t  reserved;       /* Always 0 in Section 1 */
} PatbEntry;
```

### Section 1: Leave Pattern Entries (indices 0–112)

Each entry maps an ESTR pattern string to an EXPR record:

- **string_offset**: Points into ESTR data. After initialization, converted to
  absolute pointer by CODE 15.
- **status_word**: Used as `letter_id` by binary_search_expr (CODE 32, 0x16BC)
  to index into the EXPR resource: `EXPR[letter_id * 28 + 26]` gives centipoints.
- **flag_byte**: Must be 0 for the entry to be included in the binary search table.

**Entry 0 special case**: status_word = 0, making it fail the filter
`status_word != 0` in binary_search_expr. This entry ('?', EXPR[0] = -878) is
excluded from the search table. Entry 1 ('?', EXPR[1] = +2791) is the active
blank pattern.

### Section 2: Blank Expansion Tables (indices 113+)

Section 2 entries have the same 8-byte format but serve a different purpose:
they define letter groups for the blank_dispatcher's V/C optimization. Each
group of ~24 entries corresponds to one of 31 "blank assignment scenarios"
used by the blank expansion logic in CODE 32.

---

## EXPR Resource Format (8,960 bytes)

### Structure

320 records of 28 bytes each, using the same format as MUL resources:

```c
typedef struct {
    uint8_t  sane_extended_1[10]; /* SANE 80-bit: weighted sum */
    uint8_t  sane_extended_2[10]; /* SANE 80-bit: weighted adjustment */
    uint32_t combination_count;   /* Number of combinations evaluated */
    int16_t  direction_flag;      /* 0 = bonus, -1 = penalty */
    int16_t  centipoints;         /* Leave adjustment in centipoints */
} ExprRecord;
```

The centipoints field at offset 26 is the primary value used at runtime.
Records 0–112 correspond to PATB Section 1 entries. Records 113–319
correspond to Section 2 blank expansion entries.

### Key Values (Section 1, sorted by absolute magnitude)

| Pattern | EXPR Index | Centipoints | Points | Category |
|---------|------------|-------------|--------|----------|
| ? (blank) | 1 | +2791 | +27.91 | Blank tile value |
| qu | 67 | +1067 | +10.67 | Q+U synergy |
| ?? | 2 | +875 | +8.75 | Double blank |
| s | 72 | +794 | +7.94 | Best single letter |
| x | 88 | +570 | +5.70 | X tile value |
| gin | 91 | +532 | +5.32 | ING-potential synergy |
| z | 92 | +512 | +5.12 | Z tile value |
| elss | 111 | +424 | +4.24 | LESS-potential |
| enss | 112 | +410 | +4.10 | NESS-potential |
| h | 33 | +292 | +2.92 | H tile value |
| q | 65 | -861 | -8.61 | Q alone (very bad) |
| vv | 76 | -1178 | -11.78 | Double V penalty |
| uu | 72 | -1178 | -11.78 | Double U penalty |
| rrr | 62 | -1078 | -10.78 | Triple R penalty |
| iii | 38 | -1031 | -10.31 | Triple I penalty |

### Complete Section 1 Mapping (112 entries)

Entries sorted alphabetically by pattern:

```
Pattern    EXPR_idx  Centipoints  Points
-------    --------  -----------  ------
?               1       +2791   +27.91
??              2        +875    +8.75
a               3         -62    -0.62
aa              4        -600    -6.00
aaa             5        -502    -5.02
aaaa            6        -158    -1.58
aaaaa           7           0     0.00
adiq            8        -649    -6.49
adq             9        +256    +2.56
aeg            10         +28    +0.28
aiq            11        +158    +1.58
aq             12        -150    -1.50
aqt            13        +290    +2.90
ary           109         -33    -0.33
b              14         -36    -0.36
bb             15        -703    -7.03
bel           107         +16    +0.16
boy           105        -130    -1.30
c              16        +131    +1.31
cc             17        -899    -8.99
ch             18         +25    +0.25
ck             19        -265    -2.65
d              20         +51    +0.51
dd             21        -647    -6.47
ddd            22        -531    -5.31
dddd           23           0     0.00
diq            24         -15    -0.15
e              25         -44    -0.44
ee             26        -376    -3.76
eee            27        -545    -5.45
eeee           28        -389    -3.89
eeeee          29           0     0.00
eeeeee         30           0     0.00
eikl          106         +45    +0.45
eiv           101        +169    +1.69
eiz           102         -12    -0.12
elss          111        +424    +4.24
emn           104        -139    -1.39
enss          112        +410    +4.10
ery           108        -233    -2.33
f              31         -60    -0.60
ff             32        -344    -3.44
fiy           110        +218    +2.18
flu            94         +85    +0.85
g              33        -272    -2.72
gg             34        -840    -8.40
ggg            35        -393    -3.93
gin            93        +532    +5.32
h              36        +292    +2.92
hh             37        -691    -6.91
ht             38        -133    -1.33
hw             39        -102    -1.02
i              40        -304    -3.04
ii             41        -890    -8.90
iii            42       -1031   -10.31
iiii           43        -515    -5.15
iiiii          44           0     0.00
ily            95           0     0.00
imu           113        -100    -1.00
ino            96        +132    +1.32
inot           97         +22    +0.22
ity            98        -165    -1.65
j              45         +63    +0.63
k              46        +211    +2.11
l              47         -52    -0.52
ll             48        -758    -7.58
lll            49        -713    -7.13
llll           50        -728    -7.28
ly             99         -30    -0.30
m              51        +190    +1.90
mm             52        -647    -6.47
n              53         -53    -0.53
nn             54        -791    -7.91
nnn            55       -1046   -10.46
nnnn           56           0     0.00
o              57        -312    -3.12
oo             58        -736    -7.36
ooo            59        -587    -5.87
oooo           60           0     0.00
ooooo          61           0     0.00
osu           100         -14    -0.14
otu           101         +64    +0.64
p              62         +75    +0.75
pp             63        -645    -6.45
q              64        -861    -8.61
qt             66        -180    -1.80
qu             67       +1067   +10.67
r              68         +40    +0.40
rr             69        -731    -7.31
rrr            70       -1078   -10.78
rrrr           71        -206    -2.06
s              72        +794    +7.94
ss             73         -50    -0.50
sss            74        -617    -6.17
ssss           75           0     0.00
t              76         -40    -0.40
tt             77        -640    -6.40
ttt            78        -915    -9.15
tttt           79        -505    -5.05
u              80        -542    -5.42
uu             81       -1178   -11.78
uuu            82        -829    -8.29
uuuu           83           0     0.00
v              84        -374    -3.74
vv             85       -1178   -11.78
w              86        -148    -1.48
ww             87        -971    -9.71
x              88        +570    +5.70
y              89        +116    +1.16
yy             90        -771    -7.71
z              91        +512    +5.12
```

---

## Data Flow: Resources → Orchestrator → Scoring

### Initialization (CODE 15)

```
ESTR resource ──→ g_estr_strings (A5-10912): raw string pool
PATB resource ──→ g_estr_entries (A5-10918): 8-byte entry table
EXPR resource ──→ g_expr_handle  (A5-10908): 320 × 28-byte records

CODE 15 loop converts PATB string_offset fields to absolute pointers:
  entry->string_ptr = g_estr_strings + entry->string_offset
```

### binary_search_expr (CODE 32, 0x16BC) — One-time Table Build

On first call, builds a sorted 10-byte entry table from PATB entries that
pass the filter `status_word != 0 && flag_byte == 0`:

```c
typedef struct {
    char *string_ptr;       /* Pointer to sorted pattern string (4 bytes) */
    long  value_field;      /* Accumulator, initially 0 (4 bytes) */
    short letter_id;        /* From PATB status_word (2 bytes) */
} ExprTableEntry;           /* Total: 10 bytes */
```

Binary search matches the query string against sorted entries. On match:
- Returns `EXPR_data[letter_id * 28 + 26]` (centipoints)
- Stores pointer to `entry->value_field` for orchestrator's use

### tile_string_helper (CODE 32, 0x1648)

```
Input: pattern string
Output: EXPR value (or 0 if not found)

Multi-letter patterns: return binary_search_expr result directly
Single-letter patterns: return EXPR value + binomial correction
  correction = binomial_leave(letter, unseen, current_dist)
             - binomial_leave(letter, 96, original_dist - 1)
```

### leave_orchestrator (CODE 32, 0x09D8)

```
For each PATB Section 1 entry:
  1. Read pattern string from entry
  2. Check if pattern is multiset subset of leave → skip if not
  3. tile_string_helper(pattern) → helper_result
  4. If helper_result == 0 → skip (pattern has no EXPR data)
  5. Q-without-U check → may override helper_result with penalty
  6. pre_vcb_helper(index, helper_result) → g_work_buffer[index] += value
  7. blank_dispatcher(V, C, blank, ...) → V/C result
  8. g_estr_patterns[index] += V/C result
```

### Two Separate Output Buffers

| Buffer | Address | Size | Content |
|--------|---------|------|---------|
| g_work_buffer | A5-17420 | 256 bytes | EXPR values per pattern (via pre_vcb_helper) |
| g_estr_patterns | A5-17166 | 256 bytes | V/C balance values per pattern |

These are independent scoring channels, consumed separately by CODE 35 for
the final leave score computation. The exact combination formula in CODE 35
has not yet been decoded.

---

## Confidence Levels

| Component | Confidence | Notes |
|-----------|------------|-------|
| ESTR = string pool, 130 patterns | **VERY HIGH** | Directly parsed from resource |
| PATB → g_estr_entries, not ESTR | **VERY HIGH** | CODE 15 hex manually decoded |
| PATB 8-byte entry format | **VERY HIGH** | Consistent across all 113 entries |
| EXPR 28-byte records, offset 26 = centipoints | **VERY HIGH** | Same format as MUL, values make strategic sense |
| String sharing trick (7 hidden letters) | **VERY HIGH** | Verified byte-by-byte in ESTR data |
| CODE 15 initialization sequence | **HIGH** | Manually decoded from raw hex dump |
| PATB Section 2 = blank expansion | **MEDIUM** | Structure identified but not fully decoded |
| g_estr_entry_count computation | **MEDIUM** | JT[2826] call return value processing |
