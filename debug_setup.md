# Maven Debugging Setup with QEMU

## Overview

Maven is a 68000 Macintosh application. The existing QEMU setup includes GDB support:
- `-gdb tcp::1234` - GDB listens on port 1234
- `-S` - Start paused (waiting for debugger)

## Launching QEMU for Debugging

1. Start QEMU:
```bash
cd /Volumes/T7/retrogames/oldmac
./qemu-m68k.sh
```

2. Connect with GDB (in another terminal):
```bash
gdb
(gdb) target remote localhost:1234
(gdb) continue
```

Or use the helper script:
```bash
./maven_re/connect_gdb.sh
```

## Finding Maven in Memory

When Maven is launched in the emulator:
1. The CODE 0 resource is the jump table (loaded first)
2. CODE 1 and higher are the actual code segments
3. The Segment Loader places CODE resources based on the jump table

### Memory Map (Approximate for Quadra 800)
- ROM: 0x40800000 - 0x408FFFFF
- RAM: 0x00000000 - 0x07FFFFFF (128MB configured)
- Application heap: dynamically allocated

### Breakpoint Strategy

Since we're looking for leave value calculations:
1. Look for floating-point operations (SANE calls, 68881 instructions)
2. Look for resource loading (GetResource, LoadResource traps)
3. Look for string pattern matching (ESTR patterns)

## Key 68k Instructions to Watch

SANE (Standard Apple Numerics Environment) traps:
- A9EB: Pack4 (floating point arithmetic)
- A9EA: Pack5 (transcendental functions)

Resource Manager traps:
- A9A0: GetResource
- A9A1: ReleaseResource
- A9A3: LoadResource

## GDB Commands for 68k

```gdb
# Set architecture
set architecture m68k

# Connect to QEMU
target remote localhost:1234

# Show registers
info registers

# Disassemble at PC
x/20i $pc

# Break on A-line trap (example for GetResource)
# Note: A-line traps are intercepted by the OS, not easy to catch

# Memory dump
x/100xb ADDRESS

# Single step
stepi

# Continue
continue
```

## Finding Leave Calculation Code

The leave values are stored in MUL* and EXPR resources. To find the code that uses them:

1. Set a breakpoint when these resources are loaded
2. Follow the code path from resource data to calculation
3. Look for FMOVE, FADD, FMUL instructions (floating point)

## Alternative: MacsBug

If MacsBug is installed on the emulated system:
- Press Command+Power (or Programmer Key) to enter MacsBug
- Use MacsBug commands: `dm` (display memory), `il` (disassemble), `br` (breakpoint)

## CODE Resource Entry Points

Based on analysis of CODE resources:
- CODE 0: Jump table (entry points for all segments)
- CODE 1-54: Application code segments

The main entry point is typically at the start of CODE 1.
