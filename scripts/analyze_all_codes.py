#!/usr/bin/env python3
"""
Comprehensive analysis of all Maven CODE resources.
Identifies purpose, key patterns, and cross-references.
"""

import struct
from collections import defaultdict

def load_code_resource(path):
    """Load CODE resource and return (header_info, code_bytes)"""
    with open(path, 'rb') as f:
        data = f.read()

    if len(data) >= 4:
        first_word = struct.unpack('>H', data[0:2])[0]
        if first_word == 0x4E56:  # LINK instruction - no header
            return None, data
        else:
            jt_offset = struct.unpack('>H', data[0:2])[0]
            jt_count = struct.unpack('>H', data[2:4])[0]
            return {'jt_offset': jt_offset, 'jt_count': jt_count}, data[4:]
    return None, data

def u16(data, off):
    if off + 2 > len(data):
        return None
    return struct.unpack('>H', data[off:off+2])[0]

def s16(data, off):
    if off + 2 > len(data):
        return None
    return struct.unpack('>h', data[off:off+2])[0]

# Known Mac Toolbox traps
TOOLBOX_TRAPS = {
    0xA000: "OpenResFile",
    0xA001: "CloseResFile",
    0xA009: "GetResource",
    0xA00A: "GetNamedResource",
    0xA00B: "LoadResource",
    0xA00C: "ReleaseResource",
    0xA01F: "GetHandleSize",
    0xA020: "HandleZone",
    0xA024: "NewHandle",
    0xA025: "DisposHandle",
    0xA029: "HLock",
    0xA02A: "HUnlock",
    0xA032: "FlushEvents",
    0xA051: "GetPort",
    0xA054: "SetPort",
    0xA055: "GetPortBits",
    0xA056: "PortSize",
    0xA057: "MovePortTo",
    0xA061: "HideCursor",
    0xA062: "ShowCursor",
    0xA063: "ShieldCursor",
    0xA064: "ObscureCursor",
    0xA080: "TextFont",
    0xA081: "TextFace",
    0xA082: "TextMode",
    0xA083: "TextSize",
    0xA084: "SpaceExtra",
    0xA085: "DrawChar",
    0xA086: "DrawString",
    0xA087: "DrawText",
    0xA088: "CharWidth",
    0xA089: "StringWidth",
    0xA08A: "TextWidth",
    0xA08B: "MeasureText",
    0xA08C: "GetFontInfo",
    0xA08D: "CharExtra",
    0xA0A3: "InitFonts",
    0xA0A4: "GetFNum",
    0xA0A5: "GetFontName",
    0xA0A6: "RealFont",
    0xA110: "PenNormal",
    0xA111: "PenSize",
    0xA112: "PenMode",
    0xA113: "PenPat",
    0xA114: "PenColor",
    0xA120: "MoveTo",
    0xA121: "Move",
    0xA122: "LineTo",
    0xA123: "Line",
    0xA124: "ForeColor",
    0xA125: "BackColor",
    0xA126: "ColorBit",
    0xA130: "HidePen",
    0xA131: "ShowPen",
    0xA132: "GetPenState",
    0xA133: "SetPenState",
    0xA134: "GetPen",
    0xA140: "FrameRect",
    0xA141: "PaintRect",
    0xA142: "EraseRect",
    0xA143: "InverRect",
    0xA144: "FillRect",
    0xA145: "FrameOval",
    0xA146: "PaintOval",
    0xA147: "EraseOval",
    0xA148: "InvertOval",
    0xA149: "FillOval",
    0xA14A: "FrameRoundRect",
    0xA14B: "PaintRoundRect",
    0xA14C: "EraseRoundRect",
    0xA160: "MapPt",
    0xA161: "MapRect",
    0xA162: "MapRgn",
    0xA163: "MapPoly",
    0xA164: "ScalePt",
    0xA170: "NewRgn",
    0xA171: "DisposRgn",
    0xA172: "OpenRgn",
    0xA173: "CloseRgn",
    0xA174: "CopyRgn",
    0xA175: "SetEmptyRgn",
    0xA176: "SetRectRgn",
    0xA177: "RectRgn",
    0xA178: "OffsetRgn",
    0xA179: "InsetRgn",
    0xA17A: "EmptyRgn",
    0xA17B: "EqualRgn",
    0xA17C: "SectRgn",
    0xA17D: "UnionRgn",
    0xA17E: "DiffRgn",
    0xA17F: "XorRgn",
    0xA180: "PtInRgn",
    0xA181: "RectInRgn",
    0xA182: "SetStdProcs",
    0xA183: "StdRect",
    0xA184: "StdRRect",
    0xA185: "StdOval",
    0xA186: "StdArc",
    0xA187: "StdPoly",
    0xA188: "StdRgn",
    0xA189: "StdBits",
    0xA18A: "StdComment",
    0xA18B: "StdTxMeas",
    0xA18C: "StdGetPic",
    0xA18D: "StdPutPic",
    0xA1E0: "CopyBits",
    0xA1E1: "SeedFill",
    0xA1E2: "CalcMask",
    0xA1E3: "CopyMask",
    0xA200: "InitGraf",
    0xA210: "OpenPort",
    0xA211: "InitPort",
    0xA212: "ClosePort",
    0xA850: "InitCursor",
    0xA851: "SetCursor",
    0xA852: "HideCursor",
    0xA853: "ShowCursor",
    0xA854: "ShieldCursor",
    0xA855: "ObscureCursor",
    0xA858: "GetCursor",
    0xA85D: "SetDateTime",
    0xA85E: "ReadDateTime",
    0xA860: "SysBeep",
    0xA864: "GetCaretTime",
    0xA865: "SetDItem",
    0xA866: "GetDItem",
    0xA867: "SelIText",
    0xA86A: "GetIText",
    0xA86B: "SetIText",
    0xA86E: "GetNewDialog",
    0xA86F: "NewDialog",
    0xA870: "CloseDialog",
    0xA871: "DisposDialog",
    0xA872: "FindDItem",
    0xA873: "Alert",
    0xA874: "StopAlert",
    0xA875: "NoteAlert",
    0xA876: "CautionAlert",
    0xA879: "ModalDialog",
    0xA87B: "ParamText",
    0xA87C: "ErrorSound",
    0xA87D: "GetAlertStage",
    0xA87E: "ResetAlerts",
    0xA880: "GetNewWindow",
    0xA881: "NewWindow",
    0xA882: "DisposWindow",
    0xA883: "SelectWindow",
    0xA884: "BringToFront",
    0xA885: "SendBehind",
    0xA886: "FrontWindow",
    0xA887: "DrawGrowIcon",
    0xA888: "MoveWindow",
    0xA889: "SizeWindow",
    0xA88A: "TrackGoAway",
    0xA88B: "ZoomWindow",
    0xA88C: "InvalRect",
    0xA88D: "ValidRect",
    0xA88E: "InvalRgn",
    0xA88F: "ValidRgn",
    0xA890: "BeginUpdate",
    0xA891: "EndUpdate",
    0xA892: "SetWTitle",
    0xA893: "GetWTitle",
    0xA894: "HiliteWindow",
    0xA895: "HideWindow",
    0xA896: "ShowWindow",
    0xA897: "ShowHide",
    0xA898: "GetWMgrPort",
    0xA899: "CheckUpdate",
    0xA89A: "ClipAbove",
    0xA89B: "SaveOld",
    0xA89C: "DrawNew",
    0xA89D: "PaintOne",
    0xA89E: "PaintBehind",
    0xA8A1: "GrowWindow",
    0xA8A2: "FindWindow",
    0xA8A3: "DragWindow",
    0xA8A4: "GetWRefCon",
    0xA8A5: "SetWRefCon",
    0xA8A6: "GetWVariant",
    0xA8A7: "SetWRefCon",
    0xA8B0: "GetNewControl",
    0xA8B1: "NewControl",
    0xA8B2: "DisposControl",
    0xA8B3: "KillControls",
    0xA8B4: "ShowControl",
    0xA8B5: "HideControl",
    0xA8B6: "MoveControl",
    0xA8B7: "SizeControl",
    0xA8B8: "SetCtlValue",
    0xA8B9: "GetCtlValue",
    0xA8BA: "SetCtlMin",
    0xA8BB: "GetCtlMin",
    0xA8BC: "SetCtlMax",
    0xA8BD: "GetCtlMax",
    0xA8BE: "SetCRefCon",
    0xA8BF: "GetCRefCon",
    0xA8C0: "SetCtlAction",
    0xA8C1: "GetCtlAction",
    0xA8C2: "TrackControl",
    0xA8C3: "DragControl",
    0xA8C4: "TestControl",
    0xA8C5: "FindControl",
    0xA8C6: "DrawControls",
    0xA8C7: "Draw1Control",
    0xA8C8: "HiliteControl",
    0xA8C9: "UpdtControl",
    0xA8CA: "SetCTitle",
    0xA8CB: "GetCTitle",
    0xA8CC: "GetAuxCtl",
    0xA8CD: "SetCrtlColor",
    0xA8D0: "GetMenu",
    0xA8D1: "DisposeMenu",
    0xA8D2: "InsertMenu",
    0xA8D3: "DeleteMenu",
    0xA8D4: "DrawMenuBar",
    0xA8D5: "ClearMenuBar",
    0xA8D6: "GetMenuBar",
    0xA8D7: "SetMenuBar",
    0xA8D8: "GetMenuFlash",
    0xA8D9: "MenuSelect",
    0xA8DA: "MenuKey",
    0xA8DB: "HiliteMenu",
    0xA8DC: "AppendMenu",
    0xA8DD: "GetItem",
    0xA8DE: "SetItem",
    0xA8DF: "DisableItem",
    0xA8E0: "EnableItem",
    0xA8E1: "CheckItem",
    0xA8E2: "SetItemMark",
    0xA8E3: "GetItemMark",
    0xA8E4: "SetItemIcon",
    0xA8E5: "GetItemIcon",
    0xA8E6: "SetItemStyle",
    0xA8E7: "GetItemStyle",
    0xA8E8: "CalcMenuSize",
    0xA8E9: "GetMHandle",
    0xA8EA: "FlashMenuBar",
    0xA8EB: "AppendResMenu",
    0xA8EC: "InsMenuItem",
    0xA8ED: "DelMenuItem",
    0xA8EE: "HiliteWindow",
    0xA8EF: "GetNewMBar",
    0xA8F0: "TEInit",
    0xA8F1: "TENew",
    0xA8F2: "TEDispose",
    0xA8F3: "TESetText",
    0xA8F4: "TEGetText",
    0xA8F5: "TECalText",
    0xA8F6: "TESetSelect",
    0xA8F7: "TEUpdate",
    0xA8F8: "TEActivate",
    0xA8F9: "TEDeactivate",
    0xA8FA: "TEKey",
    0xA8FB: "TECut",
    0xA8FC: "TECopy",
    0xA8FD: "TEPaste",
    0xA8FE: "TEDelete",
    0xA8FF: "TEInsert",
    0xA900: "InitDialogs",
    0xA902: "TEIdle",
    0xA904: "TEClick",
    0xA905: "TEStyleNew",
    0xA910: "GetNextEvent",
    0xA911: "EventAvail",
    0xA912: "WaitNextEvent",
    0xA914: "GlobalToLocal",
    0xA915: "LocalToGlobal",
    0xA916: "GetMouse",
    0xA917: "StillDown",
    0xA918: "Button",
    0xA91A: "TickCount",
    0xA91B: "GetKeys",
    0xA91C: "WaitMouseUp",
    0xA920: "GetNextEvent",
    0xA93A: "SystemTask",
    0xA93D: "SystemMenu",
    0xA944: "FlushVol",
    0xA945: "UnmountVol",
    0xA946: "Eject",
    0xA950: "FSOpen",
    0xA951: "FSClose",
    0xA952: "FSRead",
    0xA953: "FSWrite",
    0xA95F: "Create",
    0xA960: "Delete",
    0xA985: "SFPutFile",
    0xA986: "SFGetFile",
    0xA98E: "Pack3",
    0xA99E: "Pack6",
    0xA9AE: "Pack7",
    0xA9AF: "PtrAndHand",
    0xA9C9: "SysError",
    0xA9E0: "InitPack",
    0xA9E1: "InitAllPacks",
    0xA9FF: "Debugger",
}

# Known globals from CODE 3 analysis
KNOWN_GLOBALS = {
    -23090: "g_dawg_info_struct",
    -23074: "g_dawg_data_ptr",
    -23070: "g_section1_offset",
    -23066: "g_section2_offset",
    -15506: "g_dawg_size1 (56630)",
    -15502: "g_dawg_size2 (65536)",
    -11972: "g_dawg_ptr2",
    -28628: "g_global_buffer",
    -10388: "g_lookup_table",
    -8664: "g_flag1",
    -9810: "g_flag2",
}

def analyze_code_resource(code_id, header, data):
    """Analyze a single CODE resource"""
    analysis = {
        'id': code_id,
        'size': len(data),
        'header': header,
        'functions': [],
        'traps': [],
        'a5_refs': [],
        'jsr_a5': [],
        'strings': [],
        'constants': [],
    }

    # Find function boundaries (LINK A6,#n)
    i = 0
    while i < len(data) - 3:
        w = u16(data, i)
        if w == 0x4E56:  # LINK A6
            frame_size = s16(data, i+2)
            # Look for UNLK/RTS to find function end
            j = i + 4
            while j < len(data) - 1:
                wj = u16(data, j)
                if wj == 0x4E5E:  # UNLK A6
                    # Check for RTS after
                    if j + 2 < len(data) and u16(data, j+2) == 0x4E75:
                        analysis['functions'].append({
                            'start': i,
                            'end': j + 4,
                            'frame_size': -frame_size if frame_size < 0 else 0,
                        })
                        break
                j += 2
            i = j + 4 if j < len(data) else i + 2
        else:
            i += 2

    # Find A-line traps
    for i in range(0, len(data) - 1, 2):
        w = u16(data, i)
        if w and (w & 0xF000) == 0xA000:
            trap_name = TOOLBOX_TRAPS.get(w, f"Unknown_{w:04X}")
            analysis['traps'].append((i, w, trap_name))

    # Find A5-relative references
    for i in range(0, len(data) - 3, 2):
        w = u16(data, i)
        if w is None:
            continue

        # MOVE.L d(A5),Dn = 0x202D, 0x222D, 0x242D, etc.
        if (w & 0xF1FF) == 0x202D:
            d = s16(data, i+2)
            if d is not None:
                analysis['a5_refs'].append((i, d, 'MOVE.L', KNOWN_GLOBALS.get(d, '')))

        # LEA d(A5),An = 0x41ED, 0x43ED, etc.
        if (w & 0xF1FF) == 0x41ED:
            d = s16(data, i+2)
            if d is not None:
                analysis['a5_refs'].append((i, d, 'LEA', KNOWN_GLOBALS.get(d, '')))

        # JSR d(A5)
        if w == 0x4EAD:
            d = s16(data, i+2)
            if d is not None:
                analysis['jsr_a5'].append((i, d))

    # Look for embedded strings (sequences of printable chars)
    i = 0
    while i < len(data):
        # Pascal string: length byte followed by printable chars
        if data[i] > 0 and data[i] < 64:
            strlen = data[i]
            if i + 1 + strlen <= len(data):
                s = data[i+1:i+1+strlen]
                if all(32 <= c < 127 for c in s):
                    analysis['strings'].append((i, s.decode('ascii')))
                    i += 1 + strlen
                    continue
        i += 1

    return analysis

def categorize_code(analysis):
    """Categorize CODE resource by its characteristics"""
    categories = []

    # Check for DAWG access
    dawg_refs = [r for r in analysis['a5_refs'] if r[1] in [-23074, -23070, -23066, -15506, -15502, -11972]]
    if dawg_refs:
        categories.append("DAWG_ACCESS")

    # Check for UI traps
    ui_traps = ['DrawString', 'DrawChar', 'DrawText', 'TextFont', 'MoveTo',
                'FrameRect', 'PaintRect', 'EraseRect', 'NewWindow', 'GetNewWindow',
                'DrawMenuBar', 'MenuSelect', 'ShowWindow', 'SelectWindow']
    if any(t[2] in ui_traps for t in analysis['traps']):
        categories.append("UI_DRAWING")

    # Check for dialog/alert traps
    dialog_traps = ['Alert', 'StopAlert', 'NoteAlert', 'CautionAlert',
                    'ModalDialog', 'GetNewDialog', 'NewDialog']
    if any(t[2] in dialog_traps for t in analysis['traps']):
        categories.append("DIALOGS")

    # Check for file I/O
    file_traps = ['FSOpen', 'FSClose', 'FSRead', 'FSWrite', 'Create', 'Delete',
                  'OpenResFile', 'CloseResFile', 'GetResource']
    if any(t[2] in file_traps for t in analysis['traps']):
        categories.append("FILE_IO")

    # Check for memory management
    mem_traps = ['NewHandle', 'DisposHandle', 'HLock', 'HUnlock', 'GetHandleSize']
    if any(t[2] in mem_traps for t in analysis['traps']):
        categories.append("MEMORY")

    # Check for event handling
    event_traps = ['GetNextEvent', 'WaitNextEvent', 'EventAvail', 'GetMouse', 'Button']
    if any(t[2] in event_traps for t in analysis['traps']):
        categories.append("EVENTS")

    # Check for menu handling
    menu_traps = ['MenuSelect', 'MenuKey', 'GetMenu', 'InsertMenu', 'HiliteMenu']
    if any(t[2] in menu_traps for t in analysis['traps']):
        categories.append("MENUS")

    # Check for text editing
    te_traps = ['TEInit', 'TENew', 'TEKey', 'TEClick', 'TECut', 'TECopy', 'TEPaste']
    if any(t[2] in te_traps for t in analysis['traps']):
        categories.append("TEXT_EDIT")

    # Large frame = complex algorithm
    if analysis['functions'] and max(f['frame_size'] for f in analysis['functions']) > 500:
        categories.append("COMPLEX_ALGO")

    return categories

def print_analysis(analysis):
    """Print detailed analysis"""
    print(f"\n{'='*70}")
    print(f"CODE {analysis['id']} Analysis")
    print(f"{'='*70}")
    print(f"Size: {analysis['size']} bytes")
    if analysis['header']:
        print(f"JT Offset: {analysis['header']['jt_offset']}")
        print(f"JT Entries: {analysis['header']['jt_count']}")

    categories = categorize_code(analysis)
    print(f"Categories: {', '.join(categories) if categories else 'UNKNOWN'}")

    print(f"\nFunctions: {len(analysis['functions'])}")
    for f in analysis['functions'][:10]:
        print(f"  0x{f['start']:04X}-0x{f['end']:04X}: frame={f['frame_size']} bytes")
    if len(analysis['functions']) > 10:
        print(f"  ... and {len(analysis['functions'])-10} more")

    print(f"\nToolbox Traps: {len(analysis['traps'])}")
    # Group by trap name
    trap_counts = defaultdict(int)
    for t in analysis['traps']:
        trap_counts[t[2]] += 1
    for name, count in sorted(trap_counts.items(), key=lambda x: -x[1])[:15]:
        print(f"  {name}: {count}")
    if len(trap_counts) > 15:
        print(f"  ... and {len(trap_counts)-15} more unique traps")

    print(f"\nA5-relative references: {len(analysis['a5_refs'])}")
    # Group by offset
    ref_counts = defaultdict(int)
    for r in analysis['a5_refs']:
        ref_counts[r[1]] += 1
    for offset, count in sorted(ref_counts.items(), key=lambda x: -x[1])[:15]:
        name = KNOWN_GLOBALS.get(offset, '')
        print(f"  A5{offset:+d}: {count} refs {name}")

    print(f"\nJSR d(A5) calls: {len(analysis['jsr_a5'])}")
    # Group by offset
    jsr_counts = defaultdict(int)
    for j in analysis['jsr_a5']:
        jsr_counts[j[1]] += 1
    for offset, count in sorted(jsr_counts.items(), key=lambda x: -x[1])[:10]:
        print(f"  JSR {offset}(A5): {count} calls")

    if analysis['strings']:
        print(f"\nStrings found: {len(analysis['strings'])}")
        for off, s in analysis['strings'][:10]:
            print(f"  0x{off:04X}: \"{s}\"")


def main():
    # Get all CODE resources
    import os
    code_ids = []
    for f in os.listdir('/tmp'):
        if f.startswith('maven_code_') and f.endswith('.bin'):
            code_id = int(f.replace('maven_code_', '').replace('.bin', ''))
            code_ids.append(code_id)
    code_ids.sort()

    all_analyses = []

    for code_id in code_ids:
        path = f'/tmp/maven_code_{code_id}.bin'
        try:
            header, data = load_code_resource(path)
            analysis = analyze_code_resource(code_id, header, data)
            all_analyses.append(analysis)
            print_analysis(analysis)
        except FileNotFoundError:
            print(f"CODE {code_id}: not found")

    # Summary
    print("\n" + "="*70)
    print("SUMMARY")
    print("="*70)

    print("\nCODE Resource Purposes (Speculative):")
    for a in all_analyses:
        cats = categorize_code(a)
        purpose = "Unknown"
        if "DAWG_ACCESS" in cats and "COMPLEX_ALGO" in cats:
            purpose = "DAWG Search/Move Generation"
        elif "DAWG_ACCESS" in cats:
            purpose = "DAWG Access/Validation"
        elif "UI_DRAWING" in cats and "EVENTS" in cats:
            purpose = "Main Event Loop/UI"
        elif "UI_DRAWING" in cats:
            purpose = "UI Drawing"
        elif "DIALOGS" in cats:
            purpose = "Dialog Handling"
        elif "FILE_IO" in cats:
            purpose = "File I/O"
        elif "MENUS" in cats:
            purpose = "Menu Handling"
        elif "TEXT_EDIT" in cats:
            purpose = "Text Editing"
        elif "MEMORY" in cats:
            purpose = "Memory Management"
        print(f"  CODE {a['id']:2d}: {a['size']:5d} bytes - {purpose}")

    # Cross-reference A5 jump table
    print("\nA5 Jump Table Cross-Reference:")
    all_jsr = defaultdict(set)
    for a in all_analyses:
        for off, d in a['jsr_a5']:
            all_jsr[d].add(a['id'])

    for offset, callers in sorted(all_jsr.items())[:20]:
        print(f"  {offset}(A5): called from CODE {sorted(callers)}")


if __name__ == '__main__':
    main()
