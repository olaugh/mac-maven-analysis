# Running Maven in QEMU with a Rebuilt Dictionary

This guide covers emulating Maven (the Classic Mac Scrabble AI, file type `APPL/MAVN`) using QEMU's Quadra 800 machine emulation, including how to replace the DAWG dictionary with a freshly compiled binary.

---

## 1. Prerequisites

### Emulator

This project uses **QEMU** (`qemu-system-m68k`) with the Quadra 800 machine type (`-M q800`). QEMU's 68k Mac support has improved substantially in recent years, and the project's existing launch scripts, GDB debugging infrastructure, and memory dump tooling are all built around it.

Install QEMU on macOS:

```bash
brew install qemu
```

Or build from source for the latest m68k improvements. The key requirement is that `qemu-system-m68k` supports the `q800` machine type and the virtio-9p shared folder driver.

#### Alternatives

Other 68k Mac emulators exist, but this project has not tested Maven with them:

- **Basilisk II** -- The most commonly used 68k Mac emulator. Supports System 7 and has mature shared folder support. Would likely work for running Maven, but the GDB debugging workflow documented here is QEMU-specific.
- **Mini vMac** -- Emulates compact Macs (Plus, SE, Classic). Maven targets a larger Mac with more RAM, so Mini vMac would need configuration for a higher-end model. No GDB support.
- **SheepShaver** -- A PowerPC Mac emulator (not 68k). Maven's 68000 code would need to run under the 68k emulation layer built into Power Mac ROMs. Not recommended.

### ROM Image

QEMU requires a Macintosh Quadra 800 ROM image. The project stores it at:

```
/Volumes/T7/retrogames/oldmac/roms/quadra800.rom
```

Quadra 800 ROM images can be dumped from physical hardware or found in retro-computing archives. The ROM file is loaded with the `-bios` flag.

### Disk Image

A bootable Mac OS disk image with a supported OS version. The project uses:

```
/Volumes/T7/retrogames/oldmac/hds/macos8.img     (raw format hard disk image)
/Volumes/T7/retrogames/oldmac/isos/os8.iso        (install CD)
/Volumes/T7/retrogames/oldmac/hds/pram.img        (PRAM state, raw format)
```

Mac OS 7.5.3 through Mac OS 8.1 are all viable. Apple released Mac OS 7.5.3 as a free download, making it the easiest to obtain legally. Mac OS 8 (as used in this project) provides a more polished experience.

### Virtio Drivers

QEMU's virtio-9p shared folder support requires a NuBus virtio driver and declaration ROM for Classic Mac OS:

```
/Volumes/T7/retrogames/oldmac/virtio/classic/declrom
```

This enables a shared folder that appears as a mounted volume inside the emulated Mac, making file transfer trivial. The driver is part of the QEMU ecosystem and may require building from source or obtaining from the qemu-m68k project.

### Maven Application

The Maven application file resides in the shared folder:

```
/Volumes/T7/retrogames/oldmac/share/maven2
```

On disk, this file contains both the data fork (1,070,788-byte DAWG dictionary) and the resource fork (stored in `._maven2` as an AppleDouble sidecar file on non-HFS filesystems). The shared folder mechanism preserves both forks when accessed from the emulated Mac.

### Python 3

Required for the DAWG extraction and compilation tools. No special packages needed -- only the standard library (`struct`, `argparse`, `os`, `sys`).

---

## 2. Setting Up the Emulator

### Launch Script

The project includes a headless launch script at `run_headless.sh`. The full QEMU command line is:

```bash
cd /Volumes/T7/retrogames/oldmac

qemu-system-m68k \
    -M q800 \
    -m 128 \
    -bios roms/quadra800.rom \
    -display vnc=:0 \
    -monitor stdio \
    -qmp unix:/tmp/qemu-maven.sock,server,nowait \
    -gdb tcp::1234 \
    -drive file=isos/os8.iso,media=cdrom,if=none,id=cd0 \
    -device scsi-cd,scsi-id=3,drive=cd0 \
    -drive file=hds/pram.img,format=raw,if=mtd \
    -device scsi-hd,scsi-id=0,drive=hd0 \
    -drive file=hds/macos8.img,media=disk,format=raw,if=none,id=hd0 \
    -device nubus-virtio-mmio,romfile=virtio/classic/declrom \
    -device virtio-9p-device,fsdev=qemu-m68k-share,mount_tag="Macintosh HD" \
    -fsdev local,id=qemu-m68k-share,security_model=none,path=share
```

### Key Flags Explained

| Flag | Purpose |
|------|---------|
| `-M q800` | Quadra 800 machine type (68040 CPU, NuBus slots) |
| `-m 128` | 128 MB RAM |
| `-bios roms/quadra800.rom` | Macintosh ROM image |
| `-display vnc=:0` | VNC display on port 5900 (connect with a VNC client) |
| `-monitor stdio` | QEMU monitor on the terminal (for `savevm`, memory dumps, etc.) |
| `-qmp unix:/tmp/qemu-maven.sock,...` | QEMU Machine Protocol socket for automation |
| `-gdb tcp::1234` | GDB server on port 1234 (for debugging Maven) |
| `-device virtio-9p-device,...` | Shared folder: host `share/` directory appears as "Macintosh HD" volume |

### Connecting to the Display

With `-display vnc=:0`, connect using any VNC client:

```bash
# macOS built-in
open vnc://localhost:5900

# Or use a standalone VNC client
```

For a graphical window instead of VNC, replace `-display vnc=:0` with `-display cocoa` (macOS) or `-display gtk` (Linux).

### First-Time Setup

1. Start QEMU with the command above.
2. The emulated Quadra 800 should boot from the hard disk image (`macos8.img`). If no OS is installed yet, it will boot from the CD.
3. After booting, the shared folder appears as a mounted volume called "Macintosh HD" on the Mac desktop.
4. Maven (`maven2`) should be visible in the shared folder. Double-click to launch.

### Alternative: Interactive Launch

For development work where VNC is inconvenient, the `debug_setup.md` file references a script at `/Volumes/T7/retrogames/oldmac/qemu-m68k.sh` that may use `-display cocoa` or similar for a native window. The core machine configuration is the same.

---

## 3. Maven's File Structure

Maven is a Classic Macintosh application with two distinct parts:

### Resource Fork

Contains all executable code and pre-computed data:

| Resource Type | Count | Description |
|---------------|-------|-------------|
| CODE 0-54 | 55 | 68000 machine code segments (~112 KB total) |
| MUL a-z, ? | 27 | Per-tile leave value tables (8 records x 28 bytes each) |
| ESTR 0 | 1 | 130 pattern strings for synergy scoring (536 bytes) |
| PATB 0 | 1 | Pattern-to-value mapping table (18,104 bytes) |
| EXPR 0 | 1 | 320 pre-computed synergy records (8,960 bytes) |
| MENU, DLOG, DITL, WIND, WDEF, PICT, STR# | various | UI resources |

On non-HFS filesystems (like the host's APFS/ext4), the resource fork is stored in the AppleDouble sidecar file `._maven2`. Inside the emulated Mac (on the HFS volume or through virtio-9p), the resource fork is accessed transparently.

### Data Fork

The DAWG dictionary binary (1,070,788 bytes in the original). This is what `build_dawg.py` replaces. Layout:

```
Offset        Size         Content
0             12           Header: 3 x uint32 BE (boundary, s1_count, s2_count)
12            488,664      S1 entries (122,166 x 4 bytes)
488,676       104          S1 letter index copy (26 x 4 bytes)
488,780       581,904      S2 entries (145,476 x 4 bytes)
1,070,684     104          S2 letter index copy (26 x 4 bytes)
```

Each DAWG entry is a 32-bit big-endian value:

```
Bits 0-7:    Letter (ASCII lowercase, 0x61-0x7A)
Bit 8:       End-of-word flag
Bit 9:       Last-sibling flag
Bits 10-31:  Child entry index (22 bits)
```

### Key Point

The data fork and resource fork are independent. Replacing the data fork with a new DAWG binary does not affect the resource fork (program code, UI, evaluation tables). Conversely, the resource fork must remain intact -- it contains everything Maven needs to execute.

---

## 4. Replacing the Dictionary

### Step 1: Extract the Current Dictionaries

```bash
cd /Volumes/T7/retrogames/oldmac/maven_re
python3 dump_dawg_sections.py
```

This reads the original DAWG at `/Volumes/T7/retrogames/oldmac/share/maven2` and produces two word list files:

```
lexica/s1_words.txt    (172,233 words -- TWL98-era, stored reversed in S1)
lexica/s2_words.txt    (210,643 words -- OSW, stored forward in S2)
```

These serve as the baseline for comparison. The script also prints detailed statistics: length distribution, S1/S2 overlap, and cross-reference against TWL98 and SOWPODS reference lists if available.

### Step 2: Prepare Updated Word Lists

Prepare two plain text files (one word per line, any case, alphabetic characters only):

- **S1 word list**: The TWL-equivalent dictionary. For modern North American tournament play, this would be NWL23 (NASPA Word List 2023). For the international lexicon, use CSW (Collins Scrabble Words).
- **S2 word list**: The OSW-equivalent dictionary. Use CSW or the same list as S1 if you want both sections identical.

Requirements:
- One word per line, alphabetic characters only (a-z or A-Z)
- The compiler lowercases everything automatically
- Non-alphabetic lines are silently skipped
- No annotations, definitions, or part-of-speech markers

**Important note about S1**: In the original Maven, S1 is a reversed cross-check DAWG -- words are stored backwards, and the end-of-word flag has non-standard semantics for cross-check position validity. The `build_dawg.py` compiler builds S1 as a standard reversed DAWG from the input word list. This approach works (the DAWG format is the same), though the cross-check behavior may differ slightly from Maven's original S1. In practice, this has not caused observable problems.

### Step 3: Build the New DAWG

```bash
python3 build_dawg.py lexica/nwl23.txt lexica/csw.txt -o maven2_new
```

The compiler will:
1. Load both word lists
2. Build tries, then minimize them into DAWGs (typically 20-30% the size of the trie)
3. Serialize into Maven's 32-bit entry format
4. Automatically verify round-trip correctness (extract all words from the built DAWG and compare against input)
5. Write the binary output

Expected output:

```
Loading word lists...
  S1: 192,111 words from lexica/nwl23.txt
  S2: 279,496 words from lexica/csw.txt

Building S1 DAWG...
  S1: 192,111 words
  S1: trie has 612,004 nodes
  S1: DAWG has 148,592 nodes (24% of trie)
  S1: 148,592 entries (boundary=63412)

Building S2 DAWG...
  [similar output]

Verifying built DAWGs...
  S1: PASS (192,111 words)
  S2: PASS (279,496 words)

Wrote 1,384,216 bytes to maven2_new
  S1: 148,592 entries
  S2: 197,340 entries
```

(Word counts and entry counts will vary depending on your actual word lists.)

### Step 4: Verify Round-Trip

To verify against the original DAWG:

```bash
python3 build_dawg.py --verify
```

This extracts words from the original `maven2`, rebuilds the DAWG from those words, and verifies the rebuilt DAWG contains exactly the same words. It tests the compiler's correctness without requiring external word lists.

To verify the newly built file independently:

```bash
python3 dump_dawg_sections.py --path maven2_new
```

(Note: `dump_dawg_sections.py` uses a hardcoded `DAWG_PATH` constant by default. Edit the constant or pass the path if supported.)

### Step 5: Replace the Data Fork

The data fork is the file `maven2` in the shared folder. The resource fork is in the AppleDouble sidecar `._maven2`.

```bash
# Back up the original
cp /Volumes/T7/retrogames/oldmac/share/maven2 /Volumes/T7/retrogames/oldmac/share/maven2.bak

# Replace data fork only (preserves the ._maven2 sidecar = resource fork)
cp maven2_new /Volumes/T7/retrogames/oldmac/share/maven2
```

Because the resource fork is stored separately in `._maven2` on the host filesystem, overwriting `maven2` with the new DAWG binary replaces only the data fork. The resource fork sidecar file is untouched.

**Critical**: Do NOT delete `._maven2`. This file contains the resource fork with all of Maven's executable code, leave evaluation tables, pattern synergy data, and UI resources. Without it, Maven is just a binary blob of dictionary data with no program to read it.

---

## 5. Transferring Files to the Emulated Mac

### Virtio-9p Shared Folder (Recommended)

The QEMU launch configuration maps the host directory `share/` to a Mac volume called "Macintosh HD" via virtio-9p:

```
-device virtio-9p-device,fsdev=qemu-m68k-share,mount_tag="Macintosh HD"
-fsdev local,id=qemu-m68k-share,security_model=none,path=share
```

Files placed in `/Volumes/T7/retrogames/oldmac/share/` on the host appear immediately on the emulated Mac's desktop (or in the "Macintosh HD" volume). This is the simplest transfer method and handles resource forks correctly when the files use AppleDouble format (`._` sidecar files).

To replace the dictionary:
1. Replace `share/maven2` on the host with the new DAWG binary (as described in Step 5 above).
2. The change is visible immediately inside the emulated Mac.
3. Launch Maven from the shared volume.

### HFS Disk Image Tools

For working with HFS disk images directly (without running the emulator), the `hfsutils` package provides command-line tools:

```bash
# Install on macOS
brew install hfsutils

# Mount an HFS disk image
hmount hds/macos8.img

# List files
hls -la

# Copy a file into the image (data fork only)
hcopy maven2_new :maven2

# Copy with resource fork preservation (if available as MacBinary)
hcopy -m maven2.bin :maven2

# Unmount
humount
```

**Caveat**: Plain `hcopy` copies only the data fork. If you need to replace the data fork of an existing file while preserving its resource fork, it is safer to do this from within the running emulated Mac (using the shared folder) or by directly manipulating the disk image at the block level.

### MacBinary / BinHex

If transferring files outside the shared folder mechanism, Classic Mac files with resource forks may need to be encoded in MacBinary (.bin) or BinHex (.hqx) format, which bundles both forks into a single file. However, the virtio-9p shared folder approach avoids this entirely.

---

## 6. Running Maven

### Launching

1. Start QEMU using the launch script or command line from Section 2.
2. Connect to the display (VNC or native window).
3. Wait for Mac OS to boot.
4. Navigate to the shared folder volume on the Mac desktop.
5. Double-click `maven2` to launch Maven.

### Dictionary Mode Selection

Maven supports three lexicon modes, typically accessible through its menus:

| Mode | Name | Dictionary Source |
|------|------|-------------------|
| 1 | NA / TWL | S1 and S2 combined with TWL-only filtering |
| 2 | UK / OSW | S2 forward dictionary (primary) |
| 3 | Both / SOWPODS | S1 union S2 (all words from both sections) |

After replacing the dictionary:
- Mode 2 (OSW) will use the S2 section's word list directly.
- Mode 3 (Both) will accept any word in either S1 or S2.
- Mode 1 (TWL) behavior depends on the interaction between S1 and S2 contents and Maven's validation state machine. If S1 and S2 contain the same word list, all three modes will behave identically.

### Gameplay

Maven plays Scrabble with full move generation, pre-endgame search, and endgame solving. Standard usage:
1. Select dictionary mode from the menu.
2. Start a new game.
3. Maven will alternate turns with the human player.
4. The AI thinks for a variable amount of time depending on board complexity.
5. The Word Lister feature can be used to find all valid words matching a pattern.

---

## 7. Debugging and Memory Inspection

### GDB Connection

The QEMU launch includes `-gdb tcp::1234`, enabling remote debugging. This is the primary tool for verifying runtime behavior of the DAWG traversal code after a dictionary replacement.

Connect with GDB:

```bash
gdb
(gdb) set architecture m68k
(gdb) target remote localhost:1234
(gdb) continue
```

Or source one of the project's GDB scripts:

```bash
gdb -x /Volumes/T7/retrogames/oldmac/maven_re/break_leave_calc.gdb
```

### Key Registers

| Register | Purpose |
|----------|---------|
| A5 | Application globals base pointer. All `g_` variables are at fixed signed 16-bit offsets from A5. |
| A6 | Current stack frame pointer (LINK/UNLK convention). |
| A7 | Stack pointer. |
| PC | Program counter. |

### Key A5-Relative Globals for DAWG Debugging

| A5 Offset | Size | Content |
|-----------|------|---------|
| A5-8588 | 4 | S1 total entries (loaded from header offset 4) |
| A5-8592 | 4 | S2 total entries (loaded from header offset 8) |
| A5-8596 | 4 | S1 base pointer (data fork + 12) |
| A5-11968 | 4 | Current DAWG base pointer (set to S1 or S2 before traversal) |
| A5-15506 | 4 | Boundary field from header (original value: 56,630) |

### Memory Dump Helper

The project includes `qemu_debug.py`, a Python script that connects to QEMU's GDB server and can inspect Maven's runtime state:

```bash
# Show all 68k registers
python3 qemu_debug.py regs

# Show resource handles
python3 qemu_debug.py handles

# Dump MUL resource for tile S from running memory
python3 qemu_debug.py dump_mul S

# Compare disk vs memory for VCBh resource
python3 qemu_debug.py compare
```

This requires QEMU to be running with `-gdb tcp::1234` (or equivalently `-s`).

### Dumping Memory Regions

From the QEMU monitor (the terminal where QEMU is running, or via QMP):

```
# Dump 4 MB of memory starting at address 0x100000
(qemu) memsave 0x100000 0x400000 /tmp/memdump.bin

# Dump the entire first 8 MB
(qemu) memsave 0 0x800000 /tmp/full_dump.bin
```

From GDB:

```gdb
# Dump a range
dump binary memory /tmp/heap.bin 0x100000 0x500000

# Read specific values
x/10xw $a5-8596       # S1 base pointer
x/10xw $a5-8588       # S1 entry count
x/10xw $a5-11968      # Current DAWG base pointer
```

The project has used memory dumps extensively to verify DAWG format, CODE resource disassembly, and leave evaluation behavior. Saved dumps are in `traces/memory_dumps/`.

### GDB Scripts

The `traces/gdb_scripts/` directory contains numerous purpose-built GDB scripts:

| Script | Purpose |
|--------|---------|
| `find_maven_data.gdb` | Search for Maven's data structures in memory |
| `dump_globals.gdb` | Dump A5-relative global variables |
| `dump_eval_funcs.gdb` | Inspect evaluation function state |
| `examine_game_state.gdb` | Capture board state, rack, scores |
| `find_mul_resource.gdb` | Locate MUL resource data in memory |
| `capture_rack_before.gdb` / `capture_rack_after.gdb` | Snapshot rack state around moves |
| `watch_scores.gdb` | Monitor score computation |

### Finding CODE Resources in Memory

Maven's CODE segments are loaded by the Segment Loader into the application heap. To find a specific CODE segment:

1. Read A5 from registers.
2. The jump table starts at A5+32 (on classic 68k apps; exact offset varies).
3. JT entries contain segment load stubs that resolve to CODE segment addresses.
4. Alternatively, search memory for known byte sequences from CODE resources (as `break_leave_calc.gdb` does for CODE 32).

The project's `traces/memory_dumps/` directory contains pre-captured CODE segment dumps (`maven_code_0.bin` through `maven_code_54.bin`) extracted from a running instance. These have a 4-byte header (JT offset + count) before the actual code; the code offset in the file is file_offset - 4.

---

## 8. Troubleshooting

### Maven Crashes After Dictionary Replacement

**Check the data fork format.** The most likely cause is a malformed DAWG binary. Verify:

1. **Header correctness**: The first 12 bytes must be three big-endian uint32 values: `(boundary, s1_count, s2_count)`. The `s1_count` and `s2_count` must match the actual number of entries in each section.

2. **File size formula**: The total file size must equal `12 + (s1_count * 4) + 104 + (s2_count * 4) + 104`. Any deviation means the S2 base pointer computation will be wrong.

3. **Letter index copies**: The 26-entry letter index copies after each section must exactly duplicate entries 1-26 of that section. The S2 base pointer is computed as `data + 12 + 104 + s1_count * 4`, which skips over the S1 letter index copy. If the copy is missing or wrong size, S2 lookups will read garbage.

4. **Entry format**: Every non-sentinel entry must have a valid letter byte in bits 0-7 (range 0x61-0x7A for a-z). Invalid letter values will cause the traversal to fail silently or read wrong children.

The `build_dawg.py` compiler handles all of these automatically and verifies round-trip correctness before writing. If you are building the binary manually, these are the common failure modes.

### Maven Runs But Words Are Missing

1. **Run `dump_dawg_sections.py`** on the new DAWG binary and verify the expected words are present in the output.

2. **Check which section you're testing.** In OSW mode (Mode 2), Maven uses S2 for word validation. In TWL mode (Mode 1), the interaction between S1 and S2 determines validity. If a word is in S2 but not in S1, it may not be accepted in TWL mode.

3. **Cross-check failures.** If Maven's AI generates moves but rejects certain perpendicular words, the S1 cross-check DAWG may be incomplete. The S1 section is used for cross-check generation (CODE 37), and missing words in S1 mean missing cross-check entries, which means the AI will not consider certain tile placements valid.

### Resource Fork Lost or Corrupted

If `._maven2` is deleted or corrupted, Maven cannot run -- it has no executable code. Restore from backup. The resource fork is never modified by dictionary replacement.

If you see "Application could not be found" or a similar error when double-clicking maven2 inside the emulated Mac, the Finder cannot locate the resource fork. This happens when:
- The `._maven2` sidecar was not present in the shared folder.
- The virtio-9p driver failed to expose the AppleDouble metadata.
- The file was copied without preserving the sidecar.

### File Size Changes

The rebuilt DAWG will almost certainly be a different size than the original (1,070,788 bytes). This is expected and harmless. Maven reads the entry counts from the 12-byte header and computes base pointers from those counts. It does no file size validation. Larger dictionaries produce larger files; smaller dictionaries produce smaller files.

### QEMU Crashes or Hangs

- **Out of memory**: Increase `-m` beyond 128 if needed, though 128 MB is generous for System 7/8.
- **ROM incompatibility**: Ensure the ROM file matches the machine type. The Quadra 800 ROM is required for `-M q800`.
- **Disk image corruption**: If the Mac OS boot fails, the HFS disk image may be damaged. Keep backups.
- **VNC connection refused**: Verify QEMU started successfully and is listening on port 5900. Check for port conflicts.

### Boundary Field

The first field in the DAWG header (56,630 in the original) has unclear runtime semantics. It is stored at A5-15506 during initialization (CODE 5) but does not appear to function as a traversal boundary -- S1 letter index child pointers span the entire entry range without respecting it. The `build_dawg.py` compiler computes a boundary based on where the a-h subtrees end in S1, which approximates the original's structure. An incorrect boundary value is unlikely to cause problems, but matching the original's convention is a reasonable precaution.

---

## Appendix: Directory Layout

```
/Volumes/T7/retrogames/oldmac/
    roms/quadra800.rom              Quadra 800 ROM image
    hds/macos8.img                  Mac OS 8 boot disk (raw format)
    hds/pram.img                    PRAM state file
    isos/os8.iso                    Mac OS 8 install CD
    virtio/classic/declrom          NuBus virtio declaration ROM
    share/                          Shared folder (appears as Mac volume)
        maven2                      Maven application DATA FORK (DAWG)
        ._maven2                    Maven application RESOURCE FORK (AppleDouble)
    run_headless.sh -> maven_re/run_headless.sh  (may be symlinked)

/Volumes/T7/retrogames/oldmac/maven_re/
    build_dawg.py                   DAWG compiler (word lists -> binary)
    dump_dawg_sections.py           DAWG extractor (binary -> word lists)
    qemu_debug.py                   GDB helper for runtime inspection
    run_headless.sh                 QEMU headless launch script
    debug_setup.md                  GDB debugging setup notes
    break_leave_calc.gdb            GDB script for leave calculation breakpoints
    lexica/
        s1_words.txt                Extracted S1 words (TWL98-era)
        s2_words.txt                Extracted S2 words (OSW)
    resources/                      Extracted resource fork contents
        CODE/                       CODE segments (0-54)
        MUL/                        Leave value tables
        ...
    traces/
        qemu_trace.log              QEMU execution trace
        memory_dumps/               Memory dumps from QEMU/GDB sessions
            maven_code_*.bin        CODE segments captured from running Maven
            bigdump.bin             Large memory region dump
            heap_dump.bin           Application heap capture
        gdb_scripts/                GDB automation scripts
    analysis/                       Reverse engineering analysis documents
    docs/                           Project documentation
```

## Appendix: Quick Reference

### Build and install a new dictionary (complete workflow)

```bash
cd /Volumes/T7/retrogames/oldmac/maven_re

# 1. Extract current dictionaries (optional, for reference)
python3 dump_dawg_sections.py

# 2. Build new DAWG from word lists
python3 build_dawg.py lexica/nwl23.txt lexica/csw.txt -o maven2_new

# 3. Back up original
cp /Volumes/T7/retrogames/oldmac/share/maven2 /Volumes/T7/retrogames/oldmac/share/maven2.bak

# 4. Install (replace data fork only; ._maven2 resource fork is untouched)
cp maven2_new /Volumes/T7/retrogames/oldmac/share/maven2

# 5. Launch QEMU
cd /Volumes/T7/retrogames/oldmac
bash maven_re/run_headless.sh

# 6. Connect VNC and test
open vnc://localhost:5900
```

### Round-trip verification

```bash
python3 build_dawg.py --verify
```

### Connect GDB to running QEMU

```bash
gdb
(gdb) set architecture m68k
(gdb) target remote localhost:1234
(gdb) info registers
(gdb) x/4xw $a5-8588    # S1 count, S2 count, S1 base
```
