#!/usr/bin/env python3
"""
Analyze all CODE resources and generate detailed markdown analysis files.
"""

import os
import re
from collections import defaultdict

DISASM_DIR = '/Volumes/T7/retrogames/oldmac/maven_re/analysis/disasm'
OUTPUT_DIR = '/Volumes/T7/retrogames/oldmac/maven_re/analysis/code_analyses'

# Known global variables (A5-relative)
KNOWN_GLOBALS = {
    -23090: ("g_dawg_info", "34-byte DAWG info structure"),
    -23074: ("g_dawg_ptr", "Main DAWG data pointer"),
    -23070: ("g_sect1_off", "Section 1 offset"),
    -23066: ("g_sect2_off", "Section 2 offset"),
    -23056: ("g_dawg_field", "DAWG related field"),
    -15522: ("g_field_22", "Board buffer 2 (horizontal)"),
    -15514: ("g_field_14", "Board buffer 1 (vertical)"),
    -15506: ("g_size1", "DAWG section 1 size (56630)"),
    -15502: ("g_size2", "DAWG section 2 size (65536)"),
    -15498: ("g_current_ptr", "Current active buffer pointer"),
    -11972: ("g_dawg_ptr2", "Secondary DAWG pointer"),
    -10388: ("g_lookup_tbl", "Lookup table"),
    -8604: ("g_game_mode", "Game mode/state flag"),
    -8584: ("g_handle", "Handle to data structure"),
    -8510: ("g_window_ptr", "Main window pointer"),
    -24026: ("g_common", "Common data area"),
    -27732: ("g_buffer1", "Buffer area 1"),
    -28628: ("g_buffer2", "Buffer area 2"),
}

# Mac Toolbox traps (A-line instructions)
TOOLBOX_TRAPS = {
    0xA000: "_Open",
    0xA001: "_Close",
    0xA002: "_Read",
    0xA003: "_Write",
    0xA009: "_GetApplLimit",
    0xA01C: "_FreeMem",
    0xA01F: "_DisposePtr",
    0xA020: "_SetZone",
    0xA021: "_MaxBlock",
    0xA023: "_DisposeHandle",
    0xA024: "_SetHandleSize",
    0xA025: "_GetHandleSize",
    0xA029: "_HLock",
    0xA02A: "_HUnlock",
    0xA02B: "_EmptyHandle",
    0xA02E: "_BlockMove",
    0xA034: "_ReallocHandle",
    0xA040: "_ResrvMem",
    0xA044: "_PtrToHand",
    0xA049: "_HNoPurge",
    0xA04A: "_HPurge",
    0xA051: "_ReadDateTime",
    0xA055: "_SysBeep",
    0xA064: "_TickCount",
    0xA11A: "_InitApplZone",
    0xA11D: "_MaxApplZone",
    0xA122: "_NewHandle",
    0xA146: "_GetTrapAddress",
    0xA162: "_PurgeSpace",
    0xA1AD: "_Gestalt",
    0xA1E6: "_NewHandleClear",

    # QuickDraw
    0xA850: "_InitCursor",
    0xA851: "_SetCursor",
    0xA852: "_HideCursor",
    0xA853: "_ShowCursor",
    0xA854: "_ObscureCursor",
    0xA855: "_ShieldCursor",
    0xA856: "_SetCursorKind",
    0xA858: "_BitAnd",
    0xA85F: "_InitPort",
    0xA860: "_InitGraf",
    0xA861: "_OpenPort",
    0xA862: "_LocalToGlobal",
    0xA863: "_GlobalToLocal",
    0xA864: "_GrafDevice",
    0xA865: "_SetPort",
    0xA866: "_GetPort",
    0xA867: "_SetPBits",
    0xA868: "_PortSize",
    0xA869: "_MovePortTo",
    0xA86A: "_SetOrigin",
    0xA86B: "_SetClip",
    0xA86C: "_GetClip",
    0xA86D: "_ClipRect",
    0xA86E: "_BackPat",
    0xA86F: "_ClosePort",
    0xA870: "_AddPt",
    0xA871: "_SubPt",
    0xA872: "_SetPt",
    0xA873: "_EqualPt",
    0xA874: "_StdText",
    0xA875: "_DrawChar",
    0xA876: "_DrawString",
    0xA877: "_DrawText",
    0xA878: "_TextWidth",
    0xA879: "_TextFont",
    0xA87A: "_TextFace",
    0xA87B: "_TextMode",
    0xA87C: "_TextSize",
    0xA87E: "_SpaceExtra",
    0xA880: "_GetFontInfo",
    0xA882: "_CharWidth",
    0xA883: "_StringWidth",
    0xA884: "_StdLine",
    0xA885: "_LineTo",
    0xA886: "_Line",
    0xA887: "_MoveTo",
    0xA888: "_Move",
    0xA889: "_HidePen",
    0xA88A: "_ShowPen",
    0xA88B: "_GetPenState",
    0xA88C: "_SetPenState",
    0xA88D: "_GetPen",
    0xA88E: "_PenSize",
    0xA88F: "_PenMode",
    0xA890: "_PenPat",
    0xA891: "_PenNormal",
    0xA892: "_Unimpl",
    0xA893: "_StdRect",
    0xA894: "_FrameRect",
    0xA895: "_PaintRect",
    0xA896: "_EraseRect",
    0xA897: "_InverRect",
    0xA898: "_FillRect",
    0xA899: "_EqualRect",
    0xA89A: "_SetRect",
    0xA89B: "_OffsetRect",
    0xA89C: "_InsetRect",
    0xA89D: "_SectRect",
    0xA89E: "_UnionRect",
    0xA89F: "_PtInRect",
    0xA8A0: "_Pt2Rect",
    0xA8A1: "_PtToAngle",
    0xA8A4: "_FrameOval",
    0xA8A5: "_PaintOval",
    0xA8A6: "_EraseOval",
    0xA8A7: "_InvertOval",
    0xA8A8: "_FillOval",
    0xA8B4: "_FrameArc",
    0xA8B5: "_PaintArc",
    0xA8D0: "_CopyBits",
    0xA8D1: "_SeedFill",
    0xA8D2: "_CalcMask",
    0xA8D3: "_CopyMask",
    0xA8E3: "_OpenPicture",
    0xA8E4: "_ClosePicture",
    0xA8E5: "_KillPicture",
    0xA8E6: "_DrawPicture",
    0xA8F4: "_OpenRgn",
    0xA8F5: "_CloseRgn",
    0xA8F6: "_BitMapToRegion",
    0xA8F7: "_DisposeRgn",
    0xA8F8: "_NewRgn",
    0xA8F9: "_DisposeRgn",
    0xA8FA: "_CopyRgn",
    0xA8FB: "_SetEmptyRgn",
    0xA8FC: "_SetRectRgn",
    0xA8FD: "_RectRgn",
    0xA8FE: "_OffsetRgn",
    0xA8FF: "_InsetRgn",

    # Window Manager
    0xA911: "_NewWindow",
    0xA912: "_DisposeWindow",
    0xA913: "_ShowWindow",
    0xA914: "_HideWindow",
    0xA915: "_GetWRefCon",
    0xA916: "_SetWRefCon",
    0xA917: "_GetWTitle",
    0xA918: "_SetWTitle",
    0xA91A: "_MoveWindow",
    0xA91B: "_SizeWindow",
    0xA91D: "_TrackGoAway",
    0xA91E: "_SelectWindow",
    0xA91F: "_BringToFront",
    0xA920: "_SendBehind",
    0xA921: "_BeginUpdate",
    0xA922: "_EndUpdate",
    0xA923: "_FrontWindow",
    0xA924: "_DragWindow",
    0xA925: "_DragTheRgn",
    0xA92B: "_InvalRect",
    0xA92D: "_ValidRect",
    0xA92E: "_GrowWindow",
    0xA930: "_FindWindow",
    0xA932: "_CloseWindow",
    0xA933: "_SetWindowPic",
    0xA934: "_GetWindowPic",
    0xA935: "_InitWindows",
    0xA939: "_CheckUpdate",
    0xA93D: "_DrawGrowIcon",
    0xA9A0: "_GetResource",
    0xA9A1: "_GetNamedResource",
    0xA9A2: "_LoadResource",
    0xA9A3: "_ReleaseResource",
    0xA9A4: "_HomeResFile",
    0xA9A5: "_SizeRsrc",
    0xA9A6: "_GetResAttrs",
    0xA9A7: "_SetResAttrs",
    0xA9A8: "_GetResInfo",
    0xA9AA: "_SetResPurge",
    0xA9AB: "_GetResFileAttrs",
    0xA9AC: "_SetResFileAttrs",
    0xA9AF: "_ResError",
    0xA9B0: "_WriteResource",
    0xA9B1: "_CreateResFile",
    0xA9B4: "_Count1Types",
    0xA9B5: "_Get1IndType",
    0xA9B6: "_Count1Resources",
    0xA9B7: "_Get1IndResource",
    0xA9B8: "_Get1NamedResource",
    0xA9B9: "_Get1Resource",
    0xA9BD: "_MaxSizeRsrc",
    0xA9C0: "_OpenResFile",
    0xA9C1: "_UseResFile",
    0xA9C2: "_UpdateResFile",
    0xA9C3: "_CloseResFile",
    0xA9C4: "_SetResLoad",
    0xA9C5: "_CountResources",
    0xA9C6: "_GetIndResource",
    0xA9C7: "_CountTypes",
    0xA9C8: "_GetIndType",
    0xA9C9: "_GetResFileAttrs",
    0xA9CB: "_AddResource",
    0xA9CC: "_RmveResource",

    # Menu Manager
    0xA930: "_FindWindow",
    0xA935: "_InitMenus",
    0xA936: "_NewMenu",
    0xA937: "_DisposeMenu",
    0xA938: "_AppendMenu",
    0xA93A: "_DeleteMenu",
    0xA93B: "_InsertMenu",
    0xA93C: "_DrawMenuBar",
    0xA93D: "_HiliteMenu",
    0xA93E: "_EnableItem",
    0xA93F: "_DisableItem",
    0xA940: "_GetMenuBar",
    0xA941: "_SetMenuBar",
    0xA944: "_MenuSelect",
    0xA945: "_MenuKey",
    0xA946: "_GetItmIcon",
    0xA947: "_SetItmIcon",
    0xA948: "_GetItmStyle",
    0xA949: "_SetItmStyle",
    0xA94A: "_GetItmMark",
    0xA94B: "_SetItmMark",
    0xA94C: "_CheckItem",
    0xA94D: "_GetItem",
    0xA94E: "_SetItem",
    0xA94F: "_CalcMenuSize",
    0xA950: "_GetMHandle",
    0xA951: "_SetMFlash",
    0xA954: "_FlashMenuBar",
    0xA955: "_AppendResMenu",
    0xA956: "_InsertResMenu",
    0xA957: "_InsertMenuItem",

    # Dialog Manager
    0xA97C: "_NewDialog",
    0xA97D: "_DisposeDialog",
    0xA97E: "_CouldDialog",
    0xA97F: "_FreeDialog",
    0xA980: "_InitDialogs",
    0xA981: "_GetDItem",
    0xA982: "_SetDItem",
    0xA983: "_HideDItem",
    0xA984: "_ShowDItem",
    0xA985: "_Alert",
    0xA986: "_StopAlert",
    0xA987: "_NoteAlert",
    0xA988: "_CautionAlert",
    0xA989: "_CouldAlert",
    0xA98A: "_FreeAlert",
    0xA98B: "_ParamText",
    0xA98C: "_ModalDialog",
    0xA98D: "_SelIText",
    0xA98E: "_GetIText",
    0xA98F: "_SetIText",
    0xA990: "_FindDItem",
    0xA991: "_NewCDialog",
    0xA99A: "_GetNewDialog",

    # Control Manager
    0xA954: "_NewControl",
    0xA955: "_DisposeControl",
    0xA956: "_KillControls",
    0xA957: "_ShowControl",
    0xA958: "_HideControl",
    0xA959: "_MoveControl",
    0xA95A: "_GetCRefCon",
    0xA95B: "_SetCRefCon",
    0xA95C: "_SizeControl",
    0xA95D: "_HiliteControl",
    0xA95E: "_GetCTitle",
    0xA95F: "_SetCTitle",
    0xA960: "_GetCtlValue",
    0xA961: "_GetMinCtl",
    0xA962: "_GetMaxCtl",
    0xA963: "_SetCtlValue",
    0xA964: "_SetMinCtl",
    0xA965: "_SetMaxCtl",
    0xA966: "_TestControl",
    0xA967: "_DragControl",
    0xA968: "_TrackControl",
    0xA969: "_DrawControls",
    0xA96A: "_GetNewControl",
    0xA96B: "_UpdtControl",

    # Text Edit
    0xA9C9: "_TEInit",
    0xA9CA: "_TEDispose",
    0xA9CB: "_TEStyleNew",
    0xA9CC: "_TESetText",
    0xA9CD: "_TEGetText",
    0xA9CE: "_TEIdle",
    0xA9CF: "_TESetSelect",
    0xA9D0: "_TEActivate",
    0xA9D1: "_TEDeactivate",
    0xA9D2: "_TEKey",
    0xA9D3: "_TECut",
    0xA9D4: "_TECopy",
    0xA9D5: "_TEPaste",
    0xA9D6: "_TEDelete",
    0xA9D7: "_TEInsert",
    0xA9D8: "_TESetJust",
    0xA9D9: "_TEUpdate",
    0xA9DA: "_TETextBox",
    0xA9DB: "_TEScroll",
    0xA9DC: "_TESelView",
    0xA9DD: "_TEPinScroll",
    0xA9DE: "_TEAutoView",
    0xA9DF: "_TECalText",
    0xA9E0: "_TEGetOffset",
    0xA9E1: "_TEGetPoint",
    0xA9E2: "_TEClick",
    0xA9E3: "_TENew",
    0xA9F0: "_TEStyleNew",

    # Event Manager
    0xA96F: "_PostEvent",
    0xA970: "_GetOSEvent",
    0xA971: "_FlushEvents",
    0xA972: "_GetNextEvent",
    0xA973: "_WaitNextEvent",
    0xA974: "_EventAvail",
    0xA975: "_GetMouse",
    0xA976: "_StillDown",
    0xA977: "_Button",
    0xA978: "_GetKeys",
    0xA979: "_WaitMouseUp",

    # File Manager
    0xA000: "_Open",
    0xA001: "_Close",
    0xA002: "_Read",
    0xA003: "_Write",
    0xA004: "_Control",
    0xA005: "_Status",
    0xA006: "_KillIO",
    0xA007: "_GetVolInfo",
    0xA008: "_Create",
    0xA009: "_Delete",
    0xA00A: "_OpenRF",
    0xA00B: "_Rename",
    0xA00C: "_GetFInfo",
    0xA00D: "_SetFInfo",
    0xA00E: "_UnmountVol",
    0xA00F: "_MountVol",
    0xA010: "_Allocate",
    0xA011: "_GetEOF",
    0xA012: "_SetEOF",
    0xA013: "_FlushVol",
    0xA014: "_GetVol",
    0xA015: "_SetVol",
    0xA016: "_Eject",
    0xA017: "_GetFPos",
    0xA018: "_Read",
    0xA044: "_SetFPos",

    # Standard File
    0xA9EA: "_SFPutFile",
    0xA9EB: "_SFGetFile",
    0xA9EE: "_StandardGetFile",
    0xA9EF: "_StandardPutFile",

    # Misc
    0xA03C: "_CmpString",
    0xA050: "_ReadXPRam",
    0xA051: "_WriteXPRam",
    0xA054: "_UprString",
    0xA057: "_SetDateTime",
    0xA85D: "_Random",
    0xA86E: "_NumToString",
    0xA9EE: "_Pack7",
}

# Jump table function purposes (speculative based on analysis)
KNOWN_JT_FUNCS = {
    66: "common utility",
    74: "get size/count",
    90: "calculation",
    362: "process_dawg - DAWG traversal",
    418: "bounds_check / error",
    426: "memset/clear",
    650: "get_data from buffer",
    658: "init_subsystem",
    666: "copy_buffer",
    674: "init function",
    682: "check function",
    842: "copy_buffers",
    1218: "clear_window",
    1258: "post-search init",
    1282: "check function",
    1346: "data function",
    1362: "state_update",
    1410: "finalize_buffer",
    1610: "check_something",
    1650: "finalize",
    1754: "setup function",
    2066: "init/copy function",
    2122: "buffer comparison/scoring",
    2202: "data copy",
    2346: "check_result",
    2370: "setup_params",
    2394: "setup function",
    2402: "buffer function",
    2410: "setup_buffer",
    2434: "setup_more",
    2754: "allocation",
    3450: "lookup",
    3490: "copy to/from global",
    3506: "compare function",
    3578: "final_call with sizes",
}


def parse_disasm_file(filepath):
    """Parse a disassembly file and extract key information."""
    with open(filepath, 'r') as f:
        content = f.read()
        lines = content.split('\n')

    info = {
        'code_id': None,
        'jt_offset': None,
        'jt_entries': None,
        'code_size': None,
        'functions': [],
        'traps': [],
        'globals': [],
        'jt_calls': [],
        'strings': [],
    }

    # Parse header
    for line in lines[:10]:
        if 'CODE' in line and 'Disassembly' in line:
            m = re.search(r'CODE (\d+)', line)
            if m:
                info['code_id'] = int(m.group(1))
        if 'JT offset=' in line:
            m = re.search(r'JT offset=(\d+)', line)
            if m:
                info['jt_offset'] = int(m.group(1))
        if 'JT entries=' in line:
            m = re.search(r'JT entries=(\d+)', line)
            if m:
                info['jt_entries'] = int(m.group(1))
        if 'Code size:' in line:
            m = re.search(r'Code size: (\d+)', line)
            if m:
                info['code_size'] = int(m.group(1))

    # Parse functions
    current_func = None
    for line in lines:
        # Function marker
        if 'Function at 0x' in line:
            m = re.search(r'Function at (0x[0-9A-Fa-f]+)', line)
            if m:
                current_func = m.group(1)
                info['functions'].append(current_func)

        # A-line traps
        trap_match = re.search(r'\b(A[0-9A-Fa-f]{3})\b', line)
        if trap_match and 'MOVE' not in line[:30]:  # Avoid false positives
            trap = int(trap_match.group(1), 16)
            if trap in TOOLBOX_TRAPS:
                info['traps'].append((trap, TOOLBOX_TRAPS[trap]))

        # Also catch traps that appear as instruction operands
        trap_match2 = re.search(r'DC\.W\s+\$?(A[0-9A-Fa-f]{3})', line, re.IGNORECASE)
        if trap_match2:
            trap = int(trap_match2.group(1), 16)
            if trap in TOOLBOX_TRAPS:
                info['traps'].append((trap, TOOLBOX_TRAPS[trap]))

        # Global variable references (A5-relative)
        global_match = re.search(r'-(\d+)\(A5\)', line)
        if global_match:
            offset = -int(global_match.group(1))
            if offset in KNOWN_GLOBALS:
                name, desc = KNOWN_GLOBALS[offset]
                info['globals'].append((offset, name, desc))
            else:
                info['globals'].append((offset, f"A5{offset}", "unknown"))

        # Jump table calls
        jt_match = re.search(r'JSR\s+(\d+)\(A5\)', line)
        if jt_match:
            jt_offset = int(jt_match.group(1))
            purpose = KNOWN_JT_FUNCS.get(jt_offset, "unknown")
            info['jt_calls'].append((jt_offset, purpose))

    # Deduplicate
    info['traps'] = list(set(info['traps']))
    info['globals'] = list(set(info['globals']))
    info['jt_calls'] = list(set(info['jt_calls']))

    return info


def categorize_code(info):
    """Categorize a CODE resource based on its characteristics."""
    categories = []
    confidence = "LOW"
    purpose = "Unknown"

    traps = set(t[1] for t in info['traps'])
    globals_used = set(g[1] for g in info['globals'])
    jt_calls = set(j[0] for j in info['jt_calls'])

    # DAWG access
    dawg_globals = {'g_dawg_ptr', 'g_dawg_info', 'g_dawg_ptr2', 'g_size1', 'g_size2',
                   'g_sect1_off', 'g_sect2_off', 'g_field_14', 'g_field_22', 'g_dawg_field'}
    if globals_used & dawg_globals:
        categories.append("DAWG_ACCESS")
        if len(globals_used & dawg_globals) >= 3:
            confidence = "HIGH"

    # UI/Drawing
    drawing_traps = {'_DrawString', '_DrawChar', '_DrawText', '_MoveTo', '_LineTo',
                    '_FrameRect', '_PaintRect', '_EraseRect', '_DrawPicture',
                    '_TextFont', '_TextSize', '_TextFace', '_SetPort', '_GetPort'}
    if traps & drawing_traps:
        categories.append("UI_DRAWING")

    # Window management
    window_traps = {'_NewWindow', '_DisposeWindow', '_SelectWindow', '_ShowWindow',
                   '_HideWindow', '_FrontWindow', '_DragWindow', '_BeginUpdate', '_EndUpdate'}
    if traps & window_traps:
        categories.append("WINDOWS")

    # Dialog handling
    dialog_traps = {'_NewDialog', '_DisposeDialog', '_Alert', '_StopAlert', '_NoteAlert',
                   '_CautionAlert', '_ModalDialog', '_GetDItem', '_SetDItem', '_GetNewDialog'}
    if traps & dialog_traps:
        categories.append("DIALOGS")

    # Menu handling
    menu_traps = {'_MenuSelect', '_MenuKey', '_HiliteMenu', '_DrawMenuBar',
                 '_GetMHandle', '_EnableItem', '_DisableItem'}
    if traps & menu_traps:
        categories.append("MENUS")

    # File I/O
    file_traps = {'_Open', '_Close', '_Read', '_Write', '_Create', '_Delete',
                 '_GetFInfo', '_SetFInfo', '_FSOpen', '_FSClose', '_FSRead', '_FSWrite',
                 '_SFGetFile', '_SFPutFile', '_StandardGetFile', '_StandardPutFile'}
    if traps & file_traps:
        categories.append("FILE_IO")

    # Resource handling
    resource_traps = {'_GetResource', '_ReleaseResource', '_LoadResource',
                     '_Get1Resource', '_OpenResFile', '_CloseResFile'}
    if traps & resource_traps:
        categories.append("RESOURCES")

    # Memory management
    memory_traps = {'_NewHandle', '_DisposeHandle', '_NewPtr', '_DisposePtr',
                   '_HLock', '_HUnlock', '_SetHandleSize', '_GetHandleSize', '_BlockMove'}
    if traps & memory_traps:
        categories.append("MEMORY")

    # Event handling
    event_traps = {'_GetNextEvent', '_WaitNextEvent', '_EventAvail',
                  '_GetMouse', '_Button', '_StillDown'}
    if traps & event_traps:
        categories.append("EVENTS")

    # Text editing
    te_traps = {'_TENew', '_TEDispose', '_TESetText', '_TEGetText', '_TEClick',
               '_TEKey', '_TECut', '_TECopy', '_TEPaste', '_TEUpdate'}
    if traps & te_traps:
        categories.append("TEXT_EDIT")

    # Control handling
    control_traps = {'_NewControl', '_DisposeControl', '_HiliteControl',
                    '_TrackControl', '_GetCtlValue', '_SetCtlValue'}
    if traps & control_traps:
        categories.append("CONTROLS")

    # Determine primary purpose
    if 'DAWG_ACCESS' in categories and len(globals_used & dawg_globals) >= 5:
        purpose = "Core DAWG/AI"
        confidence = "HIGH"
    elif 'DIALOGS' in categories:
        purpose = "Dialog handling"
    elif 'FILE_IO' in categories:
        purpose = "File I/O"
    elif 'UI_DRAWING' in categories:
        purpose = "UI Drawing"
    elif 'WINDOWS' in categories:
        purpose = "Window management"
    elif 'MENUS' in categories:
        purpose = "Menu handling"
    elif 'MEMORY' in categories:
        purpose = "Memory management"
    elif 'EVENTS' in categories:
        purpose = "Event handling"
    elif 'RESOURCES' in categories:
        purpose = "Resource handling"
    elif info['code_size'] and info['code_size'] < 200:
        purpose = "Small utility"

    if not categories:
        categories.append("UNKNOWN")

    return categories, purpose, confidence


def generate_analysis_md(info, categories, purpose, confidence):
    """Generate markdown analysis for a CODE resource."""
    md = []
    md.append(f"# CODE {info['code_id']} Analysis")
    md.append("")
    md.append("## Overview")
    md.append("")
    md.append("| Property | Value |")
    md.append("|----------|-------|")
    md.append(f"| Size | {info['code_size']} bytes |")
    md.append(f"| JT Offset | {info['jt_offset']} |")
    md.append(f"| JT Entries | {info['jt_entries']} |")
    md.append(f"| Functions | {len(info['functions'])} |")
    md.append(f"| Categories | {', '.join(categories)} |")
    md.append(f"| Purpose | {purpose} |")
    md.append(f"| Confidence | {confidence} |")
    md.append("")

    # Functions
    if info['functions']:
        md.append("## Functions")
        md.append("")
        md.append(f"Entry points at: {', '.join(info['functions'][:20])}")
        if len(info['functions']) > 20:
            md.append(f"... and {len(info['functions']) - 20} more")
        md.append("")

    # Toolbox traps
    if info['traps']:
        md.append("## Toolbox Traps Used")
        md.append("")
        md.append("| Trap | Name |")
        md.append("|------|------|")
        for trap, name in sorted(set(info['traps'])):
            md.append(f"| ${trap:04X} | {name} |")
        md.append("")

    # Global variables
    if info['globals']:
        # Filter to known globals for cleaner output
        known = [(o, n, d) for o, n, d in info['globals'] if not n.startswith('A5')]
        if known:
            md.append("## Known Global Variables")
            md.append("")
            md.append("| Offset | Name | Description |")
            md.append("|--------|------|-------------|")
            for offset, name, desc in sorted(set(known)):
                md.append(f"| A5{offset} | {name} | {desc} |")
            md.append("")

        # Count unknown globals
        unknown = [o for o, n, d in info['globals'] if n.startswith('A5')]
        if unknown:
            md.append(f"Also references {len(set(unknown))} unknown A5-relative globals.")
            md.append("")

    # Jump table calls
    if info['jt_calls']:
        md.append("## Jump Table Calls")
        md.append("")
        md.append("| Offset | Purpose |")
        md.append("|--------|---------|")
        for offset, purpose in sorted(set(info['jt_calls'])):
            md.append(f"| {offset}(A5) | {purpose} |")
        md.append("")

    # Notes based on category
    md.append("## Analysis Notes")
    md.append("")

    if 'DAWG_ACCESS' in categories:
        dawg_count = len([g for g in info['globals'] if g[1].startswith('g_dawg') or g[1].startswith('g_size') or g[1].startswith('g_field')])
        md.append(f"- **DAWG-related**: Uses {dawg_count} DAWG-related globals")
        if 'g_field_14' in [g[1] for g in info['globals']] or 'g_field_22' in [g[1] for g in info['globals']]:
            md.append("- Uses the two-buffer system (horizontal/vertical word directions)")

    if info['code_size'] and info['code_size'] > 5000:
        md.append(f"- **Large code segment**: {info['code_size']} bytes suggests complex functionality")

    if info['code_size'] and info['code_size'] < 200:
        md.append("- **Small utility**: Likely a simple helper function")

    if not info['traps']:
        md.append("- No direct Toolbox calls - may be pure computation or use jump table exclusively")

    md.append("")

    return '\n'.join(md)


def main():
    # Create output directory
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    # Process all disassembly files
    results = []

    for filename in sorted(os.listdir(DISASM_DIR)):
        if not filename.endswith('_disasm.asm'):
            continue
        if filename.startswith('._'):
            continue

        filepath = os.path.join(DISASM_DIR, filename)
        print(f"Analyzing {filename}...")

        info = parse_disasm_file(filepath)
        if info['code_id'] is None:
            continue

        categories, purpose, confidence = categorize_code(info)

        # Generate markdown
        md_content = generate_analysis_md(info, categories, purpose, confidence)

        # Write to file
        output_path = os.path.join(OUTPUT_DIR, f"code{info['code_id']}_analysis.md")
        with open(output_path, 'w') as f:
            f.write(md_content)

        results.append({
            'id': info['code_id'],
            'size': info['code_size'],
            'categories': categories,
            'purpose': purpose,
            'confidence': confidence,
            'functions': len(info['functions']),
            'traps': len(info['traps']),
            'dawg_refs': len([g for g in info['globals'] if 'dawg' in g[1].lower() or 'size' in g[1].lower() or 'field' in g[1].lower()]),
        })

    # Generate summary
    print("\n" + "="*60)
    print("ANALYSIS SUMMARY")
    print("="*60)

    # Sort by ID
    results.sort(key=lambda x: x['id'])

    print(f"\n{'ID':>4} {'Size':>6} {'Funcs':>5} {'Traps':>5} {'DAWG':>4} {'Purpose':<25} {'Categories'}")
    print("-"*100)

    for r in results:
        print(f"{r['id']:>4} {r['size']:>6} {r['functions']:>5} {r['traps']:>5} {r['dawg_refs']:>4} {r['purpose']:<25} {', '.join(r['categories'])}")

    # Write master summary
    summary_path = os.path.join(OUTPUT_DIR, "00_master_summary.md")
    with open(summary_path, 'w') as f:
        f.write("# Maven CODE Resources - Master Summary\n\n")
        f.write("| ID | Size | Funcs | Traps | DAWG Refs | Purpose | Categories |\n")
        f.write("|---:|-----:|------:|------:|----------:|---------|------------|\n")
        for r in results:
            f.write(f"| {r['id']} | {r['size']} | {r['functions']} | {r['traps']} | {r['dawg_refs']} | {r['purpose']} | {', '.join(r['categories'])} |\n")

        f.write("\n## Category Breakdown\n\n")

        # Group by category
        by_category = defaultdict(list)
        for r in results:
            for cat in r['categories']:
                by_category[cat].append(r['id'])

        for cat in sorted(by_category.keys()):
            f.write(f"### {cat}\n")
            f.write(f"CODE IDs: {', '.join(map(str, sorted(by_category[cat])))}\n\n")

    print(f"\nAnalysis files written to: {OUTPUT_DIR}")
    print(f"Master summary: {summary_path}")


if __name__ == '__main__':
    main()
