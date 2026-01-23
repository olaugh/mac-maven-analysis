#!/usr/bin/env python3
"""
Update all CODE detailed analysis files with system role information.
"""
import os
import re

ANALYSIS_DIR = "/Volumes/T7/retrogames/oldmac/maven_re/analysis/detailed"

# CODE resource classifications
CODE_ROLES = {
    0: ("Core System", "Segment Loader", "Initializes A5 global pointer, loads code segments on demand"),
    1: ("Core System", "Init/Cleanup", "Application initialization and cleanup routines"),
    2: ("Core System", "Resource Management", "Mac resource file operations"),
    3: ("DAWG Engine", "Search Coordinator", "Main DAWG search with 2282-byte stack frame, coordinates move generation"),
    4: ("Utility", "Small Helper", "Minimal utility functions"),
    5: ("Core System", "Init Helper", "Initialization support routines"),
    6: ("User Interface", "Window Management", "Display pointers, window creation and visibility"),
    7: ("Board State", "Board Management", "Manages g_state1 (letters) and g_state2 (scores) arrays"),
    8: ("User Interface", "Menu Handling", "Menu command dispatch and processing"),
    9: ("User Interface", "Event Handling", "Mac event loop processing"),
    10: ("User Interface", "Dialog Utilities", "Dialog box support functions"),
    11: ("Core System", "Game Controller", "Central dispatch, callback registration, exports JT[418] bounds_check"),
    12: ("Move Logic", "Move Validation", "Validates move legality"),
    13: ("Utility", "Memory Management", "Memory allocation utilities"),
    14: ("Game Logic", "Tile Bag", "Tile bag operations, drawing tiles"),
    15: ("DAWG Engine", "DAWG Traversal + MUL Loading", "DAWG node traversal AND loads MUL leave value resources"),
    16: ("Simulation", "Simulation Support", "Supports Monte Carlo simulation (6 FP calls)"),
    17: ("Scoring", "Score Helpers", "Score calculation support routines"),
    18: ("Scoring", "Position Analysis", "Board position evaluation"),
    19: ("Utility", "Small Helper", "Minimal utility functions"),
    20: ("Board State", "Position Utilities", "Board position helper functions"),
    21: ("Core System", "Main Game Loop", "Largest CODE (13722 bytes), main event/game loop"),
    22: ("Game Logic", "Player Management", "Player state and turn management"),
    23: ("Game Logic", "Turn Handling", "Turn sequence control"),
    24: ("Simulation", "Analysis Functions", "Statistical analysis (9 FP calls)"),
    25: ("Utility", "Small Helper", "Minimal utility functions"),
    27: ("Move Logic", "Move Generation", "Move generation helper"),
    28: ("Scoring", "Cross-word Scoring", "Calculates perpendicular word scores"),
    29: ("Scoring", "Adjacent Tiles", "Checks adjacent tile positions"),
    30: ("Scoring", "Position Scoring", "Position-based score calculation"),
    31: ("Scoring", "Word Score", "Word score calculation"),
    32: ("Scoring", "Move Scoring + Leave Values", "Main move scoring, applies leave values from MUL at offset 0x156A (7 FP calls)"),
    34: ("Scoring", "Score Comparison", "Compares and ranks scores"),
    35: ("Simulation", "SANE FP Statistics", "Heavy FP (22 calls) for simulation statistics - computes averages"),
    36: ("DAWG Engine", "Word Validation", "Validates words against dictionary"),
    37: ("DAWG Engine", "Extended Word Checks", "Additional word validation"),
    38: ("Utility", "Small Helper", "Minimal utility functions"),
    39: ("Scoring", "Letter Combinations", "Letter pair synergy scoring (9632-byte stack frame)"),
    40: ("Game Logic", "Rack Letters", "Rack letter utilities"),
    41: ("Utility", "Helper Functions", "General helper functions"),
    42: ("Scoring", "Rack Analysis", "Analyzes rack for scoring potential"),
    43: ("Move Logic", "Move List", "Move list management"),
    44: ("User Interface", "Score Display", "Score display formatting"),
    45: ("Scoring", "Move Ranking", "Ranks moves by value, maintains top-10 lists"),
    46: ("Game Logic", "History Management", "Game history tracking"),
    47: ("Game Logic", "State Validation", "Game state validation"),
    48: ("User Interface", "UI Utilities", "User interface helper functions"),
    49: ("User Interface", "Clipboard", "Clipboard/scrap operations"),
    50: ("Simulation", "Result Storage", "Heavy FP (25 calls), stores simulation results via ChangedResource"),
    51: ("Utility", "Small Helper", "Minimal utility functions"),
    52: ("Board State", "Flag Operations", "Board flag manipulation"),
    53: ("Utility", "Small Helper", "Minimal utility functions"),
    54: ("Utility", "String Compare", "String equality comparison (smallest CODE at 46 bytes)"),
}

# Cross-references
CROSS_REFS = {
    3: ["CODE 15 (DAWG traversal)", "CODE 36 (word validation)", "CODE 52 (flags)"],
    15: ["CODE 3 (search coordinator)", "CODE 32 (uses loaded MUL)", "CODE 35 (generates MUL data)"],
    32: ["CODE 15 (loads MUL)", "CODE 39 (combinations)", "CODE 45 (ranking)", "CODE 35 (simulation source)"],
    35: ["CODE 50 (stores results)", "CODE 32 (runtime consumer)", "CODE 24 (analysis)"],
    50: ["CODE 35 (FP statistics)", "CODE 15 (MUL resources)"],
    39: ["CODE 32 (scoring)", "CODE 42 (rack analysis)"],
    45: ["CODE 32 (scoring)", "CODE 43 (move list)"],
    7: ["CODE 32 (uses board state)", "CODE 52 (flags)"],
    11: ["CODE 21 (game loop)", "CODE 3 (search)"],
    21: ["CODE 11 (controller)", "CODE 6 (windows)", "CODE 8 (menus)"],
}

# Notes about scale/centipoints
SCALE_NOTES = {
    32: "Uses centipoints (1/100 point). Bingo = 5000 = 50 pts. Leave values SUBTRACTED (negative = bonus).",
    35: "Computes FP averages from simulation, results stored as centipoints in MUL resources.",
    50: "Converts FP statistics to integer centipoints for storage.",
    45: "Score tables initialized to -200,000,000 centipoints.",
}

def get_system_role_section(code_num):
    """Generate the System Role section for a CODE resource."""
    if code_num not in CODE_ROLES:
        return None

    category, short_name, description = CODE_ROLES[code_num]

    lines = [
        "",
        "## System Role",
        "",
        f"**Category**: {category}",
        f"**Function**: {short_name}",
        "",
        description,
        "",
    ]

    # Add cross-references if available
    if code_num in CROSS_REFS:
        lines.append("**Related CODE resources**:")
        for ref in CROSS_REFS[code_num]:
            lines.append(f"- {ref}")
        lines.append("")

    # Add scale notes if available
    if code_num in SCALE_NOTES:
        lines.append(f"**Scale Note**: {SCALE_NOTES[code_num]}")
        lines.append("")

    return "\n".join(lines)

def update_file(filepath):
    """Update a single CODE analysis file."""
    # Extract CODE number from filename
    basename = os.path.basename(filepath)
    match = re.match(r'code(\d+)_detailed\.md', basename)
    if not match:
        return False

    code_num = int(match.group(1))

    # Read existing content
    with open(filepath, 'r') as f:
        content = f.read()

    # Check if already updated
    if "## System Role" in content:
        print(f"  CODE {code_num}: Already has System Role section, skipping")
        return False

    # Get the system role section
    role_section = get_system_role_section(code_num)
    if not role_section:
        print(f"  CODE {code_num}: No role data available")
        return False

    # Find insertion point (after ## Overview section, before ## Architecture Role or ## Key Functions)
    # Look for the end of the Overview table
    patterns = [
        (r'(\| Purpose \|[^\n]+\n\n)', r'\1' + role_section),  # After Purpose row
        (r'(## Architecture Role)', role_section + r'\1'),  # Before Architecture Role
        (r'(## Key Functions)', role_section + r'\1'),  # Before Key Functions
    ]

    updated = False
    for pattern, replacement in patterns:
        if re.search(pattern, content):
            new_content = re.sub(pattern, replacement, content, count=1)
            if new_content != content:
                content = new_content
                updated = True
                break

    if not updated:
        # Fallback: insert after first blank line after header
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if i > 0 and line.strip() == '' and lines[i-1].startswith('# CODE'):
                lines.insert(i+1, role_section)
                content = '\n'.join(lines)
                updated = True
                break

    if updated:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"  CODE {code_num}: Updated")
        return True
    else:
        print(f"  CODE {code_num}: Could not find insertion point")
        return False

def main():
    print("Updating CODE analysis files with System Role sections...")
    print()

    updated = 0
    skipped = 0
    failed = 0

    for filename in sorted(os.listdir(ANALYSIS_DIR)):
        if filename.endswith('_detailed.md') and filename.startswith('code'):
            filepath = os.path.join(ANALYSIS_DIR, filename)
            result = update_file(filepath)
            if result:
                updated += 1
            elif result is False:
                skipped += 1
            else:
                failed += 1

    print()
    print(f"Summary: {updated} updated, {skipped} skipped, {failed} failed")

if __name__ == "__main__":
    main()
