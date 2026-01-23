#!/usr/bin/env python3
"""
Second pass analysis - use patterns across CODE resources to refine understanding.
"""

import os
import re
from collections import defaultdict

DISASM_DIR = '/Volumes/T7/retrogames/oldmac/maven_re/analysis/disasm'
OUTPUT_DIR = '/Volumes/T7/retrogames/oldmac/maven_re/analysis/code_analyses'

def parse_all_disasms():
    """Parse all disassembly files and extract detailed information."""
    all_codes = {}

    for filename in sorted(os.listdir(DISASM_DIR)):
        if not filename.endswith('_disasm.asm') or filename.startswith('._'):
            continue

        filepath = os.path.join(DISASM_DIR, filename)
        with open(filepath, 'r') as f:
            content = f.read()

        # Extract CODE ID
        m = re.search(r'CODE (\d+)', content)
        if not m:
            continue
        code_id = int(m.group(1))

        # Extract header info
        jt_offset = 0
        jt_entries = 0
        code_size = 0

        m = re.search(r'JT offset=(\d+)', content)
        if m:
            jt_offset = int(m.group(1))
        m = re.search(r'JT entries=(\d+)', content)
        if m:
            jt_entries = int(m.group(1))
        m = re.search(r'Code size: (\d+)', content)
        if m:
            code_size = int(m.group(1))

        # Extract all JT calls
        jt_calls = re.findall(r'JSR\s+(\d+)\(A5\)', content)
        jt_calls = [int(x) for x in jt_calls]

        # Extract all A5-relative globals
        globals_neg = re.findall(r'-(\d+)\(A5\)', content)
        globals_neg = [-int(x) for x in globals_neg]

        # Extract PC-relative calls (intra-segment)
        pc_calls = re.findall(r'JSR\s+(-?\d+)\(PC\)', content)
        pc_calls = [int(x) for x in pc_calls]

        # Extract function addresses
        functions = re.findall(r'Function at (0x[0-9A-Fa-f]+)', content)

        # Look for specific patterns
        has_link = 'LINK' in content
        has_movem = 'MOVEM' in content
        has_dbf = 'DBF' in content  # Loop indicator
        has_muls = 'MULS' in content or 'MULU' in content  # Multiplication
        has_divs = 'DIVS' in content or 'DIVU' in content  # Division

        # Count specific trap patterns
        trap_a9eb = content.count('A9EB')  # SFGetFile/SFPutFile
        trap_a985 = content.count('A985')  # Alert
        trap_a98c = content.count('A98C')  # ModalDialog
        trap_a850 = content.count('A850')  # InitCursor
        trap_a873 = content.count('A873')  # EqualPt
        trap_a894 = content.count('A894')  # FrameRect
        trap_a896 = content.count('A896')  # EraseRect

        all_codes[code_id] = {
            'jt_offset': jt_offset,
            'jt_entries': jt_entries,
            'size': code_size,
            'jt_calls': jt_calls,
            'jt_calls_unique': list(set(jt_calls)),
            'globals': globals_neg,
            'globals_unique': list(set(globals_neg)),
            'pc_calls': pc_calls,
            'functions': functions,
            'has_loops': has_dbf,
            'has_math': has_muls or has_divs,
            'traps': {
                'file_dialog': trap_a9eb,
                'alert': trap_a985,
                'modal': trap_a98c,
                'cursor': trap_a850,
                'point_cmp': trap_a873,
                'frame_rect': trap_a894,
                'erase_rect': trap_a896,
            }
        }

    return all_codes


def analyze_jt_clustering(all_codes):
    """Find clusters of CODE resources that call similar JT functions."""
    # Build JT call profile for each CODE
    jt_profiles = {}
    for code_id, info in all_codes.items():
        jt_profiles[code_id] = set(info['jt_calls_unique'])

    # Find commonly called JT offsets
    jt_frequency = defaultdict(list)
    for code_id, jt_set in jt_profiles.items():
        for jt in jt_set:
            jt_frequency[jt].append(code_id)

    return jt_frequency


def analyze_global_clustering(all_codes):
    """Find clusters based on global variable access."""
    # Key DAWG globals
    dawg_globals = {-23090, -23074, -23070, -23066, -23056, -15522, -15514, -15506, -15502, -15498, -11972}
    # UI globals
    ui_globals = {-8510, -8604, -8584}
    # Buffer globals
    buffer_globals = {-27732, -28628, -24026}

    categorization = {}
    for code_id, info in all_codes.items():
        globals_set = set(info['globals_unique'])

        dawg_count = len(globals_set & dawg_globals)
        ui_count = len(globals_set & ui_globals)
        buffer_count = len(globals_set & buffer_globals)

        # Determine primary category
        if dawg_count >= 5:
            cat = "CORE_AI"
        elif dawg_count >= 3:
            cat = "DAWG_SUPPORT"
        elif dawg_count >= 1:
            cat = "DAWG_MINOR"
        elif ui_count >= 2:
            cat = "UI_CORE"
        elif ui_count >= 1:
            cat = "UI_SUPPORT"
        elif info['traps']['file_dialog'] > 0:
            cat = "FILE_IO"
        elif info['traps']['modal'] > 0 or info['traps']['alert'] > 0:
            cat = "DIALOGS"
        elif info['size'] < 200:
            cat = "TINY_UTIL"
        else:
            cat = "UNKNOWN"

        categorization[code_id] = {
            'category': cat,
            'dawg_refs': dawg_count,
            'ui_refs': ui_count,
            'buffer_refs': buffer_count,
            'total_globals': len(globals_set),
        }

    return categorization


def find_jt_implementations(all_codes):
    """Try to map JT offsets to CODE resources that implement them."""
    # Each CODE resource has a JT offset where its functions start
    # JT entries tell us how many functions are exported

    jt_map = {}
    for code_id, info in all_codes.items():
        if info['jt_offset'] > 0 and info['jt_entries'] > 0:
            base = info['jt_offset']
            # Each JT entry is 8 bytes in classic Mac format
            for i in range(info['jt_entries']):
                offset = base + (i * 8)
                jt_map[offset] = code_id

    return jt_map


def identify_function_clusters(all_codes):
    """Identify groups of CODE resources that work together."""
    clusters = {
        'dawg_core': [],      # Core DAWG/AI
        'dawg_support': [],   # DAWG support
        'ui_main': [],        # Main UI
        'ui_dialogs': [],     # Dialog handling
        'file_io': [],        # File operations
        'memory': [],         # Memory management
        'events': [],         # Event handling
        'utilities': [],      # General utilities
        'unknown': [],        # Need more analysis
    }

    for code_id, info in all_codes.items():
        globals_set = set(info['globals_unique'])
        jt_set = set(info['jt_calls_unique'])

        # Core AI detection
        dawg_core_globals = {-23074, -23090, -15506, -15502}
        if len(globals_set & dawg_core_globals) >= 3:
            clusters['dawg_core'].append(code_id)
            continue

        # DAWG support
        dawg_any = {-23090, -23074, -23070, -23066, -23056, -15522, -15514, -15506, -15502, -15498, -11972}
        if len(globals_set & dawg_any) >= 1:
            clusters['dawg_support'].append(code_id)
            continue

        # File I/O
        if info['traps']['file_dialog'] > 0:
            clusters['file_io'].append(code_id)
            continue

        # Dialogs
        if info['traps']['modal'] > 0 or info['traps']['alert'] > 0:
            clusters['ui_dialogs'].append(code_id)
            continue

        # UI (drawing traps)
        if info['traps']['frame_rect'] > 0 or info['traps']['erase_rect'] > 0:
            clusters['ui_main'].append(code_id)
            continue

        # Memory (small, few globals, certain JT patterns)
        if info['size'] < 1200 and len(globals_set) < 5:
            clusters['utilities'].append(code_id)
            continue

        clusters['unknown'].append(code_id)

    return clusters


def analyze_call_graph(all_codes, jt_map):
    """Build a call graph between CODE resources."""
    call_graph = defaultdict(set)

    for code_id, info in all_codes.items():
        for jt_call in info['jt_calls_unique']:
            # Find which CODE implements this JT offset
            # We need to check ranges, not exact matches
            for jt_offset, impl_code in jt_map.items():
                # Check if this call falls within the CODE's JT range
                impl_info = all_codes.get(impl_code, {})
                jt_base = impl_info.get('jt_offset', 0)
                jt_count = impl_info.get('jt_entries', 0)
                if jt_base <= jt_call < jt_base + (jt_count * 8):
                    if impl_code != code_id:
                        call_graph[code_id].add(impl_code)
                    break

    return call_graph


def generate_refined_analysis(all_codes, categorization, clusters, jt_frequency, jt_map, call_graph):
    """Generate refined analysis markdown."""
    md = []
    md.append("# Maven CODE Resources - Refined Second Pass Analysis")
    md.append("")
    md.append("## Methodology")
    md.append("")
    md.append("This analysis uses patterns discovered in the first pass to refine categorization:")
    md.append("- Jump table call clustering")
    md.append("- Global variable access patterns")
    md.append("- Inter-segment call graph")
    md.append("- Trap usage patterns")
    md.append("")

    # Clusters
    md.append("## Functional Clusters")
    md.append("")

    cluster_names = {
        'dawg_core': 'Core AI / DAWG Engine',
        'dawg_support': 'DAWG Support Functions',
        'ui_main': 'Main UI / Drawing',
        'ui_dialogs': 'Dialog Handling',
        'file_io': 'File I/O',
        'memory': 'Memory Management',
        'events': 'Event Handling',
        'utilities': 'Utilities',
        'unknown': 'Needs Further Analysis',
    }

    for cluster_key, cluster_codes in clusters.items():
        if not cluster_codes:
            continue
        md.append(f"### {cluster_names[cluster_key]}")
        md.append("")
        md.append("| CODE | Size | JT Entries | DAWG Refs | Description |")
        md.append("|------|------|------------|-----------|-------------|")
        for code_id in sorted(cluster_codes):
            info = all_codes[code_id]
            cat_info = categorization[code_id]
            desc = get_code_description(code_id, info, cat_info)
            md.append(f"| {code_id} | {info['size']} | {info['jt_entries']} | {cat_info['dawg_refs']} | {desc} |")
        md.append("")

    # Jump Table Analysis
    md.append("## Jump Table Function Mapping")
    md.append("")
    md.append("### Most Called JT Functions")
    md.append("")
    md.append("| JT Offset | Called By | Likely Implementing CODE | Purpose |")
    md.append("|-----------|-----------|-------------------------|---------|")

    # Sort by frequency
    sorted_jt = sorted(jt_frequency.items(), key=lambda x: len(x[1]), reverse=True)[:30]
    for jt_offset, callers in sorted_jt:
        impl_code = "?"
        for jt_base, code_id in jt_map.items():
            code_info = all_codes.get(code_id, {})
            jt_count = code_info.get('jt_entries', 0)
            if jt_base <= jt_offset < jt_base + (jt_count * 8):
                impl_code = str(code_id)
                break

        purpose = get_jt_purpose(jt_offset, callers, all_codes)
        md.append(f"| {jt_offset}(A5) | {len(callers)} CODEs | CODE {impl_code} | {purpose} |")
    md.append("")

    # Call Graph
    md.append("## Inter-Segment Call Graph")
    md.append("")
    md.append("Which CODE resources call functions in other CODE resources:")
    md.append("")

    for code_id in sorted(call_graph.keys()):
        targets = call_graph[code_id]
        if targets:
            md.append(f"- **CODE {code_id}** calls: {', '.join(f'CODE {t}' for t in sorted(targets))}")
    md.append("")

    # Refined categorization
    md.append("## Refined Categorization")
    md.append("")
    md.append("| CODE | Size | Category | DAWG | UI | Globals | Assessment |")
    md.append("|------|------|----------|------|----|---------|-----------| ")

    for code_id in sorted(all_codes.keys()):
        info = all_codes[code_id]
        cat_info = categorization[code_id]
        assessment = get_assessment(code_id, info, cat_info, clusters)
        md.append(f"| {code_id} | {info['size']} | {cat_info['category']} | {cat_info['dawg_refs']} | {cat_info['ui_refs']} | {cat_info['total_globals']} | {assessment} |")
    md.append("")

    # Key insights
    md.append("## Key Insights from Second Pass")
    md.append("")
    md.append("### DAWG Engine Architecture")
    md.append("")
    dawg_core = clusters.get('dawg_core', [])
    dawg_support = clusters.get('dawg_support', [])
    md.append(f"- **Core engine**: CODE {', '.join(map(str, sorted(dawg_core)))}")
    md.append(f"- **Support functions**: CODE {', '.join(map(str, sorted(dawg_support)))}")
    md.append(f"- Total DAWG-related code: ~{sum(all_codes[c]['size'] for c in dawg_core + dawg_support)} bytes")
    md.append("")

    md.append("### Jump Table Organization")
    md.append("")
    # Find JT offset ranges
    jt_ranges = []
    for code_id in sorted(all_codes.keys()):
        info = all_codes[code_id]
        if info['jt_offset'] > 0:
            jt_ranges.append((info['jt_offset'], info['jt_entries'], code_id))
    jt_ranges.sort()

    for jt_offset, jt_entries, code_id in jt_ranges[:15]:
        end_offset = jt_offset + (jt_entries * 8) - 8
        md.append(f"- CODE {code_id}: JT offsets {jt_offset}-{end_offset} ({jt_entries} functions)")
    if len(jt_ranges) > 15:
        md.append(f"- ... and {len(jt_ranges) - 15} more")
    md.append("")

    md.append("### Recommended Deep-Dive Targets")
    md.append("")
    md.append("Based on this analysis, prioritize these for detailed reverse engineering:")
    md.append("")
    md.append("1. **CODE 3** (4390 bytes) - Main DAWG search coordinator, 8 DAWG refs")
    md.append("2. **CODE 7** (2872 bytes) - Board state management, two-buffer system")
    md.append("3. **CODE 21** (13718 bytes) - Largest segment, main UI + game logic")
    md.append("4. **CODE 36** (9102 bytes) - Large DAWG segment, likely move scoring")
    md.append("5. **CODE 11** (4478 bytes) - Game controller, state machine")
    md.append("")

    return '\n'.join(md)


def get_code_description(code_id, info, cat_info):
    """Generate a short description for a CODE resource."""
    if code_id == 0:
        return "Jump table (not executable)"
    if code_id == 1:
        return "Application startup"
    if code_id == 3:
        return "DAWG search coordinator"
    if code_id == 4:
        return "Startup stub"
    if code_id == 7:
        return "Board/rack state management"
    if code_id == 11:
        return "Game controller / main loop"
    if code_id == 21:
        return "Main UI + DAWG display (largest)"
    if code_id == 24:
        return "File save/load"
    if code_id == 36:
        return "Large DAWG segment"

    if cat_info['dawg_refs'] >= 3:
        return "DAWG-heavy processing"
    if info['traps']['file_dialog'] > 0:
        return "File dialogs"
    if info['traps']['modal'] > 0:
        return "Modal dialogs"
    if info['size'] < 200:
        return "Small utility"
    if info['size'] > 5000:
        return "Large segment"

    return "General purpose"


def get_jt_purpose(jt_offset, callers, all_codes):
    """Infer JT function purpose from callers."""
    purposes = {
        66: "Common utility (string/data)",
        74: "Get size/count",
        82: "Data accessor",
        90: "Arithmetic calculation",
        98: "Data accessor",
        362: "DAWG traversal (core)",
        418: "Bounds check / assertion",
        426: "Memory clear (memset)",
        658: "Init subsystem",
        666: "Buffer copy",
        674: "Initialization",
        682: "Validation check",
        842: "Buffer operations",
        1258: "Post-search initialization",
        1362: "State update",
        1410: "Buffer finalization",
        1650: "Finalization",
        2066: "Data copy/init",
        2122: "Buffer comparison/scoring",
        2202: "Data copy",
        2346: "Check search result",
        2370: "Setup search params",
        2394: "Setup function",
        2402: "Buffer management",
        2410: "Setup buffer",
        3450: "Table lookup",
        3490: "Global data copy",
        3506: "Comparison function",
    }

    if jt_offset in purposes:
        return purposes[jt_offset]

    # Infer from callers
    caller_cats = []
    for caller in callers:
        info = all_codes.get(caller, {})
        globals_set = set(info.get('globals_unique', []))
        if -23074 in globals_set or -23090 in globals_set:
            caller_cats.append('DAWG')
        elif -8510 in globals_set:
            caller_cats.append('UI')

    if caller_cats.count('DAWG') > len(callers) // 2:
        return "DAWG-related (inferred)"
    if caller_cats.count('UI') > len(callers) // 2:
        return "UI-related (inferred)"

    return "Unknown"


def get_assessment(code_id, info, cat_info, clusters):
    """Get assessment string for a CODE resource."""
    if code_id in clusters.get('dawg_core', []):
        return "Core AI - high priority"
    if code_id in clusters.get('dawg_support', []):
        return "DAWG support"
    if code_id in clusters.get('file_io', []):
        return "File operations"
    if code_id in clusters.get('ui_dialogs', []):
        return "Dialog handling"
    if code_id in clusters.get('ui_main', []):
        return "UI drawing"
    if code_id in clusters.get('utilities', []):
        return "Utility functions"
    if info['size'] > 5000:
        return "Large - needs analysis"
    return "Standard"


def main():
    print("Second pass analysis of Maven CODE resources...")
    print()

    # Parse all disassemblies
    all_codes = parse_all_disasms()
    print(f"Parsed {len(all_codes)} CODE resources")

    # Analyze JT clustering
    jt_frequency = analyze_jt_clustering(all_codes)
    print(f"Found {len(jt_frequency)} unique JT offsets")

    # Map JT offsets to implementing CODEs
    jt_map = find_jt_implementations(all_codes)
    print(f"Mapped {len(jt_map)} JT entries to CODE resources")

    # Analyze global variable clustering
    categorization = analyze_global_clustering(all_codes)

    # Identify functional clusters
    clusters = identify_function_clusters(all_codes)
    print("\nFunctional clusters:")
    for name, codes in clusters.items():
        if codes:
            print(f"  {name}: {codes}")

    # Build call graph
    call_graph = analyze_call_graph(all_codes, jt_map)
    print(f"\nCall graph has {len(call_graph)} source nodes")

    # Generate refined analysis
    md_content = generate_refined_analysis(all_codes, categorization, clusters, jt_frequency, jt_map, call_graph)

    output_path = os.path.join(OUTPUT_DIR, "01_refined_analysis.md")
    with open(output_path, 'w') as f:
        f.write(md_content)

    print(f"\nRefined analysis written to: {output_path}")

    # Also update individual CODE analyses with refined info
    for code_id, info in all_codes.items():
        cat_info = categorization[code_id]
        update_individual_analysis(code_id, info, cat_info, clusters, call_graph)

    print("Updated individual CODE analyses with refined information")


def update_individual_analysis(code_id, info, cat_info, clusters, call_graph):
    """Update individual CODE analysis with refined information."""
    filepath = os.path.join(OUTPUT_DIR, f"code{code_id}_analysis.md")

    if not os.path.exists(filepath):
        return

    with open(filepath, 'r') as f:
        content = f.read()

    # Find which cluster this CODE belongs to
    cluster_name = "Unknown"
    for name, codes in clusters.items():
        if code_id in codes:
            cluster_name = name.replace('_', ' ').title()
            break

    # Build refined notes section
    refined = []
    refined.append("\n## Refined Analysis (Second Pass)\n")
    refined.append(f"**Cluster**: {cluster_name}\n")
    refined.append(f"**Category**: {cat_info['category']}\n")
    refined.append(f"**Global Variable Profile**: {cat_info['dawg_refs']} DAWG, {cat_info['ui_refs']} UI, {cat_info['total_globals']} total\n")

    # Add call graph info
    if code_id in call_graph:
        targets = sorted(call_graph[code_id])
        refined.append(f"**Calls functions in**: CODE {', '.join(map(str, targets))}\n")

    # Add assessment
    assessment = get_assessment(code_id, info, cat_info, clusters)
    refined.append(f"**Assessment**: {assessment}\n")

    # Append to file
    with open(filepath, 'a') as f:
        f.write('\n'.join(refined))


if __name__ == '__main__':
    main()
