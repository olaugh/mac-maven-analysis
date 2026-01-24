#!/usr/bin/env python3
"""
Analyze QEMU trace log to understand Maven's DAWG traversal algorithm.
Extracts CODE 15 execution patterns and reconstructs the algorithm flow.
"""

import re
import sys
from collections import defaultdict, Counter

def parse_trace_log(filepath):
    """Parse QEMU trace log into instruction records."""
    instructions = []
    current_block = []

    with open(filepath, 'r') as f:
        for line in f:
            line = line.strip()

            # Skip empty lines and block markers
            if not line or line.startswith('---') or line.startswith('IN:'):
                if current_block:
                    instructions.extend(current_block)
                    current_block = []
                continue

            # Parse instruction line: 0xADDRESS:  instruction
            match = re.match(r'(0x[0-9a-fA-F]+):\s+(.+)', line)
            if match:
                addr = int(match.group(1), 16)
                instr = match.group(2)
                current_block.append((addr, instr))

    if current_block:
        instructions.extend(current_block)

    return instructions

def analyze_code15_calls(instructions):
    """Analyze CODE 15 function calls and execution patterns."""
    # CODE 15 appears to be loaded at base 0x7c9a600
    CODE15_BASE = 0x7c9a600
    CODE15_END = 0x7c9b000  # Approximate end

    code15_instrs = [(addr, instr) for addr, instr in instructions
                     if CODE15_BASE <= addr < CODE15_END]

    print(f"=== CODE 15 Execution Analysis ===")
    print(f"Total CODE 15 instructions executed: {len(code15_instrs)}")

    # Group by function (based on LINK instructions)
    functions = defaultdict(list)
    current_func = None

    for addr, instr in code15_instrs:
        if 'linkw' in instr or 'link ' in instr:
            current_func = addr
        if current_func:
            functions[current_func].append((addr, instr))

    print(f"\nFunctions identified (by LINK instruction):")
    for func_addr in sorted(functions.keys()):
        offset = func_addr - CODE15_BASE
        count = len(functions[func_addr])
        print(f"  0x{func_addr:08x} (offset 0x{offset:04x}): {count} instructions")

    return code15_instrs, functions

def analyze_dawg_operations(instructions):
    """Extract DAWG-specific operations from trace."""
    print(f"\n=== DAWG Operations Analysis ===")

    # Look for A5-relative accesses (DAWG globals)
    a5_accesses = defaultdict(list)

    for addr, instr in instructions:
        # Match A5-relative addressing: %a5@(-OFFSET) or -OFFSET(A5)
        match = re.search(r'%a5@\((-?\d+)\)|(-\d+)\(%a5\)', instr)
        if match:
            offset = int(match.group(1) or match.group(2))
            a5_accesses[offset].append((addr, instr))

    print(f"A5-relative global accesses (DAWG-related):")
    dawg_offsets = {
        -11960: "DAWG base pointer array",
        -11956: "DAWG position array",
        -11964: "Current DAWG position",
        -11968: "DAWG start position",
        -10936: "Section count/limit",
        -23674: "Bounds counter",
        -24030: "Compare pointer",
        -24792: "Default pointer"
    }

    for offset in sorted(a5_accesses.keys(), reverse=True):
        if -25000 < offset < -10000:  # DAWG-related range
            count = len(a5_accesses[offset])
            name = dawg_offsets.get(offset, "unknown")
            print(f"  A5{offset:+d}: {count:4d} accesses - {name}")

    return a5_accesses

def analyze_bit_operations(instructions):
    """Analyze bit test operations (DAWG flags)."""
    print(f"\n=== Bit Operations (DAWG Flags) ===")

    bit_tests = []
    for addr, instr in instructions:
        if 'btst' in instr:
            bit_tests.append((addr, instr))

    # Count which bits are tested
    bit_counts = Counter()
    for addr, instr in bit_tests:
        match = re.search(r'#(\d+)', instr)
        if match:
            bit_counts[int(match.group(1))] += 1

    print(f"Bit test frequency:")
    for bit, count in sorted(bit_counts.items()):
        meaning = {
            8: "End-of-word flag",
            9: "Last-sibling flag"
        }.get(bit, "unknown")
        print(f"  Bit {bit}: {count:4d} tests - {meaning}")

    return bit_tests

def analyze_shift_operations(instructions):
    """Analyze shift operations (child index extraction)."""
    print(f"\n=== Shift Operations ===")

    shifts = []
    for addr, instr in instructions:
        if 'lsl' in instr or 'lsr' in instr or 'asr' in instr:
            shifts.append((addr, instr))

    # Count shift amounts
    shift_counts = Counter()
    for addr, instr in shifts:
        match = re.search(r'#(\d+)', instr)
        if match:
            shift_counts[int(match.group(1))] += 1

    print(f"Shift amount frequency:")
    for amount, count in sorted(shift_counts.items()):
        meaning = {
            2: "Entry size * 4 (4-byte DAWG entries)",
            3: "Section index * 8 (8-byte section structures)",
            10: "Child index extraction (>> 10)"
        }.get(amount, "")
        print(f"  Shift by {amount:2d}: {count:4d} times  {meaning}")

    return shifts

def analyze_loop_patterns(code15_instrs):
    """Identify loop patterns in CODE 15."""
    print(f"\n=== Loop Analysis ===")

    # Find backward branches (loops)
    loops = []
    for i, (addr, instr) in enumerate(code15_instrs):
        if 'bra' in instr or 'bne' in instr or 'beq' in instr or 'blt' in instr or 'bge' in instr:
            # Extract target address
            match = re.search(r'0x([0-9a-fA-F]+)', instr)
            if match:
                target = int(match.group(1), 16)
                if target < addr:  # Backward branch = loop
                    loops.append((addr, target, instr))

    print(f"Backward branches (loops) found: {len(loops)}")
    for addr, target, instr in loops[:10]:  # Show first 10
        offset = addr - 0x7c9a600
        target_offset = target - 0x7c9a600
        print(f"  0x{offset:04x} -> 0x{target_offset:04x}: {instr}")

    return loops

def analyze_call_graph(instructions):
    """Analyze function call relationships."""
    print(f"\n=== Call Graph (CODE 15 internal) ===")

    CODE15_BASE = 0x7c9a600
    CODE15_END = 0x7c9b000

    calls = []
    for addr, instr in instructions:
        if CODE15_BASE <= addr < CODE15_END:
            if 'jsr' in instr or 'bsr' in instr:
                match = re.search(r'0x([0-9a-fA-F]+)', instr)
                if match:
                    target = int(match.group(1), 16)
                    calls.append((addr, target, instr))

    print(f"Function calls from CODE 15:")
    for addr, target, instr in calls[:15]:
        src_offset = addr - CODE15_BASE
        if CODE15_BASE <= target < CODE15_END:
            tgt_offset = target - CODE15_BASE
            print(f"  0x{src_offset:04x} calls 0x{tgt_offset:04x} (internal)")
        else:
            print(f"  0x{src_offset:04x} calls 0x{target:08x} (external)")

    return calls

def reconstruct_algorithm(code15_instrs):
    """Attempt to reconstruct the high-level algorithm from trace."""
    print(f"\n=== Algorithm Reconstruction ===")

    # Track register values through execution (simplified)
    print("""
Based on trace analysis, the Word Lister algorithm appears to be:

1. SECTION LOOP (0x7c9a688):
   - Initialize D7 = 0 (section counter)
   - Loop while D7 < A5[-10936] (section count)
   - For each section, call inner walk function

2. INNER WALK (0x7c9a6b8):
   - D6 = section index from caller
   - Calculate section struct offset: D6 * 8 (lsll #3)
   - Get DAWG base: A5[-11960 + D6*8] -> A4
   - Get position: A5[-11956 + D6*8] -> D6
   - D7 = first letter of pattern

3. DAWG TRAVERSAL LOOP (0x7c9a6e2):
   - Get entry: A4[D6 * 4] -> D5
   - Compare D5.byte with D7 (pattern letter)
   - If match:
     - Advance pattern pointer
     - Get next pattern letter
     - Extract child: D5 >> 10 -> D6
   - If no match:
     - Check bit 9 (last sibling)
     - If not last, D6++ and continue
     - If last, return 0 (not found)

4. WORD VALIDATION:
   - Check bit 8 for end-of-word
   - Bit 256 (0x100) in entry = valid word ending
""")

def main():
    trace_file = "/tmp/qemu_trace.log"

    print(f"Parsing trace log: {trace_file}")
    instructions = parse_trace_log(trace_file)
    print(f"Total instructions parsed: {len(instructions)}")

    # Filter to application code range
    app_instructions = [(a, i) for a, i in instructions if 0x07000000 <= a < 0x08000000]
    print(f"Application code instructions: {len(app_instructions)}")

    code15_instrs, functions = analyze_code15_calls(app_instructions)
    analyze_dawg_operations(app_instructions)
    analyze_bit_operations(code15_instrs)
    analyze_shift_operations(code15_instrs)
    analyze_loop_patterns(code15_instrs)
    analyze_call_graph(app_instructions)
    reconstruct_algorithm(code15_instrs)

if __name__ == "__main__":
    main()
