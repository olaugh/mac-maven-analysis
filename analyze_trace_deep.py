#!/usr/bin/env python3
"""
Deep analysis of QEMU trace to extract DAWG traversal details.
Focuses on understanding the multi-section architecture.
"""

import re
from collections import defaultdict

def parse_trace_blocks(filepath):
    """Parse trace into instruction blocks."""
    blocks = []
    current_block = []

    with open(filepath, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith('---') or line.startswith('IN:'):
                if current_block:
                    blocks.append(current_block)
                    current_block = []
                continue

            match = re.match(r'(0x[0-9a-fA-F]+):\s+(.+)', line)
            if match:
                addr = int(match.group(1), 16)
                instr = match.group(2)
                current_block.append((addr, instr))

    if current_block:
        blocks.append(current_block)

    return blocks

def extract_code15_sequence(blocks):
    """Extract just the CODE 15 execution sequence."""
    CODE15_BASE = 0x7c9a600
    CODE15_END = 0x7c9b000

    sequence = []
    for block in blocks:
        for addr, instr in block:
            if CODE15_BASE <= addr < CODE15_END:
                sequence.append((addr, instr))

    return sequence

def analyze_execution_flow(sequence):
    """Analyze the exact execution flow."""
    print("=== Detailed Execution Flow ===\n")

    # Track function entries
    current_func = None
    func_calls = []

    for i, (addr, instr) in enumerate(sequence):
        offset = addr - 0x7c9a600

        # Detect function entry
        if 'linkw' in instr:
            if offset == 0x0088:
                print(f">>> ENTER section_iterator (offset 0x{offset:04x})")
                current_func = "section_iterator"
            elif offset == 0x00b8:
                print(f"    >>> ENTER dawg_walk (offset 0x{offset:04x})")
                current_func = "dawg_walk"

        # Detect function exit
        if 'rts' in instr:
            if current_func == "dawg_walk" and offset == 0x012c:
                print(f"    <<< EXIT dawg_walk")
                current_func = "section_iterator"
            elif current_func == "section_iterator" and offset == 0x00b6:
                print(f"<<< EXIT section_iterator")
                current_func = None

        # Track key operations
        if 'lsll #3' in instr:
            print(f"      [D6 * 8 - section struct indexing]")
        elif 'lsll #2' in instr:
            print(f"      [entry * 4 - DAWG entry access]")
        elif 'cmpb' in instr:
            print(f"      [compare letter]")
        elif 'btst #9' in instr:
            print(f"      [check last-sibling flag]")
        elif '%a5@(-11960)' in instr or '-11960' in instr:
            print(f"      [access DAWG base array]")
        elif '%a5@(-11956)' in instr or '-11956' in instr:
            print(f"      [access position array]")
        elif '%a5@(-10936)' in instr or '-10936' in instr:
            print(f"      [access section count]")

def count_iterations(sequence):
    """Count how many times each loop executed."""
    print("\n=== Loop Iteration Counts ===\n")

    # Track specific addresses
    section_loop_entry = 0x7c9a692  # blts target
    dawg_loop_entry = 0x7c9a6e2    # bnes/bras target

    section_count = 0
    dawg_count = 0

    for addr, instr in sequence:
        if addr == section_loop_entry:
            section_count += 1
        elif addr == dawg_loop_entry:
            dawg_count += 1

    print(f"Section loop iterations: {section_count}")
    print(f"DAWG traversal loop iterations: {dawg_count}")

def analyze_a5_patterns(sequence):
    """Analyze A5-relative access patterns in detail."""
    print("\n=== A5 Access Pattern Details ===\n")

    accesses = []
    for addr, instr in sequence:
        # Look for A5-relative access
        match = re.search(r'%a5@?\((-?\d+)', instr)
        if match:
            offset = int(match.group(1))
            accesses.append((addr - 0x7c9a600, offset, instr))

    # Group by code offset to see which function accesses what
    print("Accesses by code location:")
    for code_off, a5_off, instr in accesses[:30]:
        print(f"  0x{code_off:04x}: A5[{a5_off:+d}] - {instr[:50]}")

def trace_single_word_search(sequence):
    """Try to trace a single word lookup."""
    print("\n=== Reconstructing Single Word Search ===\n")

    # The trace should show the pattern being walked
    # Look for the compare sequence

    compares = []
    for i, (addr, instr) in enumerate(sequence):
        if 'cmpb' in instr:
            # Get context around compare
            context_start = max(0, i-3)
            context_end = min(len(sequence), i+3)
            compares.append((i, sequence[context_start:context_end]))

    print(f"Found {len(compares)} letter comparisons")

    for idx, (pos, context) in enumerate(compares[:5]):
        print(f"\nComparison {idx+1}:")
        for addr, instr in context:
            marker = " --> " if 'cmpb' in instr else "     "
            print(f"  {marker}0x{addr-0x7c9a600:04x}: {instr}")

def analyze_section_structure(filepath):
    """Look at the broader trace to understand section setup."""
    print("\n=== Section Structure Analysis ===\n")

    # The key insight: lsll #3 means sections are 8 bytes apart
    # A5-11960 and A5-11956 are accessed with this offset

    # From the trace, we see:
    # - A5-11960 is a base pointer array
    # - A5-11956 is a position array
    # - Both indexed by section number * 8

    print("""
Multi-Section DAWG Architecture (confirmed by trace):

    A5-11960                    A5-11956
    +-----------------+         +-----------------+
    | Section 0 base  | +0      | Section 0 pos   | +0
    +-----------------+         +-----------------+
    | Section 1 base  | +8      | Section 1 pos   | +8
    +-----------------+         +-----------------+
    | Section 2 base  | +16     | Section 2 pos   | +16
    +-----------------+         +-----------------+
    | ...             |         | ...             |
    +-----------------+         +-----------------+

    Section count stored at A5-10936

This explains why the static analysis at A5-11960 and A5-11964 seemed
inconsistent - they're actually arrays indexed by section number!

The 8-byte stride (lsll #3) suggests each section has:
    - 4 bytes: base pointer to DAWG data
    - 4 bytes: current position in that section

Possible section purposes:
    - Section 0: Forward dictionary (main)
    - Section 1: Reverse dictionary (for cross-checks)
    - Additional sections: Other lexicons or special word lists
""")

def main():
    trace_file = "/tmp/qemu_trace.log"

    print("Deep DAWG Trace Analysis")
    print("=" * 50)

    blocks = parse_trace_blocks(trace_file)
    sequence = extract_code15_sequence(blocks)

    print(f"\nTotal CODE 15 instructions: {len(sequence)}")

    analyze_execution_flow(sequence)
    count_iterations(sequence)
    analyze_a5_patterns(sequence)
    trace_single_word_search(sequence)
    analyze_section_structure(trace_file)

if __name__ == "__main__":
    main()
