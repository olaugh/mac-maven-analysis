# CODE 11 Detailed Analysis - Game Controller & Event Dispatcher

## Overview

| Property | Value |
|----------|-------|
| File | `resources/CODE/11_11.bin` |
| Total file size | 4,482 bytes (4 header + 4,478 code) |
| Code size | 4,478 bytes |
| JT offset | 376 |
| JT entries | 19 (JT[376]..JT[520]) |
| Functions (LINK) | 31 |
| Non-LINK code blocks | 4 (init block, state machine, validation, error handler) |
| Purpose | **Central event dispatcher, callback system, lexicon controller** |
| Confidence | HIGH |

## System Role

CODE 11 is the **central nervous system** of Maven. It contains:

1. **Callback/dispatch subsystem** -- registration, lookup, and invocation of function pointers via linked dispatch tables and a 16-slot callback array
2. **Main event handler** -- a 1,108-byte function (0x05EA) that processes all Mac Toolbox events (mouse, keyboard, update, activate) through two nested switch statements
3. **Menu management** -- iteration over MENU resources, menu command dispatch, menu bar drawing
4. **Lexicon controller** -- the state machine that manages dictionary loading and switching between TWL, OSW, and SOWPODS modes
5. **Word validation** -- the table-driven lookup that determines whether a word is valid for the current lexicon mode
6. **Handler registration** -- 55 JT-based command handlers registered via A9F1 trap during initialization

## Complete Function Map

| # | Offset | Size | Frame | Purpose | Confidence |
|---|--------|------|-------|---------|------------|
| 1 | 0x0000 | 88 | 0 | `get_handler_data_ptr` -- resolve handler for context | HIGH |
| 2 | 0x0058 | 46 | 0 | `dispatch_with_context` -- call handler via data ptr | HIGH |
| 3 | 0x0086 | 26 | 0 | `dispatch_indirect` -- wrapper combining lookup + call | HIGH |
| 4 | 0x00A0 | 70 | 0 | `lookup_in_list` -- search linked dispatch table for key | HIGH |
| 5 | 0x00E6 | 32 | 0 | `convert_local_to_global` -- coordinate conversion | HIGH |
| 6 | 0x0106 | 70 | 0 | `update_dispatch_entry` -- find and update entry in list | HIGH |
| 7 | 0x014C | 48 | 0 | `is_callback_registered` -- check if callback exists | HIGH |
| 8 | 0x017C | 42 | 0 | `register_callback` -- add callback to table | HIGH |
| 9 | 0x01A6 | 104 | 0 | `unregister_callback` -- remove callback from table | HIGH |
| 10 | 0x020E | 112 | 0 | `dispatch_event_to_handler` -- route event via dispatch | HIGH |
| 11 | 0x027E | 84 | 512 | `iterate_menus_with_action` -- process all menus | HIGH |
| 12 | 0x02D2 | 112 | 262 | `iterate_menu_resources` -- enumerate MENU resources | HIGH |
| 13 | 0x0342 | 60 | 0 | `process_menu_selection` -- handle menu pick | HIGH |
| 14 | 0x037E | 32 | 0 | `hilite_or_draw_menu` -- menu highlight control | HIGH |
| 15 | 0x039E | 22 | 0 | `delete_menu_by_id` -- remove and dispose menu | HIGH |
| 16 | 0x03B4 | 180 | 0 | `process_dispatch_table` -- iterate dispatch nodes | MED |
| 17 | 0x0468 | 96 | 0 | `find_handler_with_fallback` -- primary then fallback lookup | HIGH |
| 18 | 0x04C8 | 136 | 0 | `find_handler_filtered` -- filtered dispatch lookup | MED |
| 19 | 0x0550 | 106 | 0 | `resolve_dual_dispatch` -- search two dispatch chains | HIGH |
| 20 | 0x05BA | 48 | 0 | `track_control_click` -- handle control tracking | HIGH |
| 21 | 0x05EA | 1108 | 36 | **`main_event_handler`** -- central event dispatch | HIGH |
| -- | 0x0A0C | 50 | -- | *(data: switch tables for event handler)* | -- |
| 22 | 0x0A3E | 148 | 0 | `execute_command` -- command table executor | HIGH |
| 23 | 0x0AD2 | 40 | 16 | `drain_events` -- process pending events | HIGH |
| 24 | 0x0AFA | 90 | 0 | `get_cursor_for_context` -- cursor management | MED |
| 25 | 0x0B54 | 160 | 2 | `handle_window_event` -- window activate/deactivate | HIGH |
| 26 | 0x0BF4 | 70 | 4 | `handle_dialog_event` -- dialog item handling | HIGH |
| 27 | 0x0C3A | 30 | 16 | `open_settings_dialog` -- open preferences dialog | HIGH |
| 28 | 0x0C58 | 34 | 0 | `memset_zero` -- zero-fill memory block | HIGH |
| 29 | 0x0C7A | 298 | 282 | `process_xgme_commands` -- XGME command processor | HIGH |
| -- | 0x0D48 | 92 | -- | *(init block 1: register 15 handlers via A9F1)* | -- |
| 30 | 0x0DA4 | 964 | 128 | **`init_lexicon_and_menus`** -- dictionary/menu initialization | HIGH |
| -- | 0x10DE | 12 | -- | *(data: switch table for lexicon states)* | -- |
| -- | 0x10EA | 48 | -- | *(code: lexicon state machine loop)* | -- |
| -- | 0x111C | 72 | -- | *(code: word validation lookup)* | -- |
| -- | 0x1164 | 4 | -- | *(code: debugger trap / assertion failure)* | -- |
| 31 | 0x1168 | 22 | 0 | `is_lexicon_not_mode4` -- check validation state | HIGH |

Total: 31 LINK-based functions + 4 non-LINK code/data blocks.

## Detailed Function Analysis

---

### Function 1: `get_handler_data_ptr` (0x0000-0x0056)

**Signature**: `void* get_handler_data_ptr(GameContext* context)`

Resolves the appropriate handler data pointer for a given game context. Used by the dispatch subsystem to determine which function to call.

**Logic**:
1. If `context == NULL`, return `g_default_data` (A5-27912)
2. If `check_something(context)` via JT[1610] returns true, return `g_alt_data` (A5-27896)
3. If `context->mode_flags >= 8` AND bit 1 of `context->feature_bits` is set AND `check_mode(context)` passes (PC call to 0x014C), return `context->handler_ptr` (offset 152)
4. Otherwise return `g_alt_data` (A5-27896)

```c
void* get_handler_data_ptr(GameContext* ctx) {
    if (ctx == NULL)
        return &g_default_data;          /* A5-27912 */
    if (check_something(ctx))            /* JT[1610] */
        return &g_alt_data;              /* A5-27896 */
    if (ctx->mode_flags >= 8 &&          /* offset 108 */
        (ctx->feature_bits & 0x02) &&    /* offset 109, bit 1 */
        is_callback_registered(ctx))     /* PC-relative to 0x014C */
        return ctx->handler_ptr;         /* offset 152 */
    return &g_alt_data;
}
```

**References**: A5-27912 (g_default_data), A5-27896 (g_alt_data), JT[1610]

---

### Function 2: `dispatch_with_context` (0x0058-0x0084)

**Signature**: `int dispatch_with_context(GameContext* ctx, void* param1, void* param2)`

Resolves handler via `get_handler_data_ptr`, then calls it as a function pointer. Always returns 1.

```c
int dispatch_with_context(GameContext* ctx, void* p1, void* p2) {
    void (*handler)() = (void(*)())get_handler_data_ptr(ctx, p1);
    if (handler != NULL)
        handler(ctx, p2);       /* indirect call: JSR (A4) */
    return 1;
}
```

---

### Function 3: `dispatch_indirect` (0x0086-0x009E)

**Signature**: `void dispatch_indirect(void* p1, void* p2)`

Wrapper that calls `get_handler_data_ptr` (0x0000) then chains to `lookup_in_list` (0x00A0). Combines data pointer resolution with dispatch table lookup.

---

### Function 4: `lookup_in_list` (0x00A0-0x00E4)

**Signature**: `void* lookup_in_list(DispatchNode* head, long target_key)`

Searches a linked list of dispatch nodes for an entry matching the target key. Each node contains multiple entries in 8-byte slots (key at offset 0, data at offset 4).

```c
void* lookup_in_list(DispatchNode* head, long target_key) {
    while (head != NULL) {
        short count = head->count;          /* offset 2 */
        char* base = (char*)head + 8;       /* entries start at offset 8 */
        for (int i = 0; i < count; i++) {
            long key = *(long*)(base + i * 8);
            if (key == target_key)
                return *(void**)(base + i * 8 + 4);
        }
        head = *(DispatchNode**)((char*)head + 4);  /* next node */
    }
    return NULL;
}
```

**Note**: Entry stride is 8 bytes (not 12 as initially estimated). Each entry has a 4-byte key and 4-byte data pointer.

---

### Function 5: `convert_local_to_global` (0x00E6-0x0104)

**Signature**: `void convert_local_to_global(WindowPtr window, Point* pt_out)`

Uses Mac Toolbox `_GetWMgrPort` (A917) and `_LocalToGlobal` (A918) to convert coordinates from a window's local coordinate system to global screen coordinates.

```c
void convert_local_to_global(WindowPtr window, Point* pt_out) {
    GrafPtr wmgrPort;
    GetWMgrPort(&wmgrPort);             /* A917 */
    pt_out->v = wmgrPort->portBits.baseAddr;  /* store global origin */
    LocalToGlobal(window, pt_out);       /* A918 */
}
```

---

### Function 6: `update_dispatch_entry` (0x0106-0x014A)

**Signature**: `void update_dispatch_entry(long key, void* new_data)`

Searches the dispatch list (via `get_handler_data_ptr` at 0x0000) for a matching key, then updates the data pointer for that entry. If not found, calls the error handler (0x1164).

---

### Function 7: `is_callback_registered` (0x014C-0x017A)

**Signature**: `int is_callback_registered(void* callback_ptr)`

Linear search through the 16-slot callback table at A5-27800 to check if a callback is already registered.

```c
int is_callback_registered(void* cb) {
    for (int i = 0; i < g_callback_count; i++) {    /* A5-27872 */
        if (g_callback_table[i] == cb)                /* A5-27800 */
            return 1;
    }
    return 0;
}
```

---

### Function 8: `register_callback` (0x017C-0x01A4)

**Signature**: `void register_callback(void* callback_ptr)`

Adds a callback to the next available slot. Calls `_Debugger` (0x1164) if the table is full (max 16 entries).

```c
void register_callback(void* cb) {
    if (g_callback_count >= 16)
        debugger_break();               /* A9FF trap */
    int idx = g_callback_count++;
    /* MULS.W #?, idx; index calculation */
    g_callback_table[idx] = cb;
}
```

---

### Function 9: `unregister_callback` (0x01A6-0x020C)

**Signature**: `void unregister_callback(void* callback_ptr)`

Finds a callback in the table, removes it by compacting the array. Calls error handlers if callback is not found or if the count is invalid.

```c
void unregister_callback(void* cb) {
    int i = 0;
    while (i < g_callback_count) {
        if (g_callback_table[i] == cb)
            break;
        i++;
    }
    if (i >= g_callback_count)
        debugger_break();                /* not found */
    if (g_callback_count <= 0)
        debugger_break();                /* invalid state */
    g_callback_count--;
    /* Compact: shift entries[i+1..] down by one slot (4 bytes) */
    /* Uses MOVE.L A5+src,A5+dst pattern */
}
```

---

### Function 10: `dispatch_event_to_handler` (0x020E-0x027C)

**Signature**: `void dispatch_event_to_handler(GameContext* ctx, EventRecord* event)`

Routes an event to the appropriate handler by checking the context and event properties. Uses bit 0 of `event->modifiers` (offset 15) to determine which dispatch key to use (4 vs 5).

```c
void dispatch_event_to_handler(GameContext* ctx, EventRecord* event) {
    if (ctx == NULL || ctx->field_110 == 0)
        return;
    void* data_ptr = get_handler_data_ptr(ctx);
    if (event->modifiers & 0x01) {       /* bit 0 of byte 15 */
        g_dispatch_target = ctx;          /* A5-27804 */
        void* handler = lookup_in_list(data_ptr, 4);
        if (handler) handler(ctx, event);
    } else {
        void* handler = lookup_in_list(data_ptr, 5);
        if (handler) handler(ctx, event);
    }
}
```

---

### Function 11: `iterate_menus_with_action` (0x027E-0x02D0)

**Signature**: `void iterate_menus_with_action(WindowPtr window, short should_delete)`

Iterates through menu items in a window using `_FrontWindow` (A950), `_GetIndString` (A946), and conditionally calls `_HiliteMenu` (A939) or `_DrawMenuBar` (A93A).

Frame size: 512 bytes (large local buffer for string operations).

---

### Function 12: `iterate_menu_resources` (0x02D2-0x0340)

**Signature**: `void iterate_all_menus(void (*callback)(short menuID, short param), short param)`

Enumerates all MENU resources using `_CountResources` (A80D), `_GetIndResource` (A80E), and `_GetResource` (A949). For each menu, retrieves it via `_GetHandleSize` (A9A8 - actually used to validate), then calls the provided callback with the menu ID.

```c
void iterate_all_menus(MenuCallback callback, short param) {
    short count = CountResources('MENU');       /* A80D */
    for (short i = count; i >= 1; i--) {        /* DBF loop */
        Boolean found;
        GetIndResource(found, 'MENU', i);       /* A80E (returns handle) */
        Handle h = GetResource('MENU', i);      /* A949 via A99B+A80E */
        if (h == NULL)
            debugger_break();
        /* Extract menu info, get resource name */
        callback(menuID, param);                 /* call via JSR (A0) */
    }
}
```

---

### Function 13: `process_menu_selection` (0x0342-0x037C)

**Signature**: `void process_menu_selection(void (*callback)(short, short), short menu_result)`

Handles a menu selection. First iterates menus via `iterate_menu_resources` (0x02D2) using JT offset 498 (A5+498) as context. Then processes the menu command through the dispatch system, checking the secondary dispatch pointer at A5-1330.

```c
void process_menu_selection(MenuCallback cb, short result) {
    iterate_menu_resources(cb, A5_498);
    dispatch_menu_command(cb, result);
    if (g_secondary_dispatch != NULL) {          /* A5-1330 */
        void* data = get_handler_data_ptr(g_secondary_dispatch);
        process_dispatch_table(g_secondary_dispatch, data);
    }
}
```

---

### Function 14: `hilite_or_draw_menu` (0x037E-0x039C)

**Signature**: `void hilite_or_draw_menu(WindowPtr window, short should_hilite)`

Conditionally calls `_HiliteMenu(window, 0)` (A939) to highlight a menu, or `_DrawMenuBar(window, 0)` (A93A) to redraw the menu bar.

```c
void hilite_or_draw_menu(WindowPtr window, short action) {
    if (action != 0) {
        HiliteMenu(window, 0);          /* A939 */
    } else {
        DrawMenuBar(window, 0);         /* A93A */
    }
}
```

---

### Function 15: `delete_menu_by_id` (0x039E-0x03B2)

**Signature**: `void delete_menu_by_id(short menuID)`

Calls `iterate_menu_resources` to find the menu by ID using JT offset 450 (A5+450), then disposes it with `_DisposeMenu` (A937).

```c
void delete_menu_by_id(short menuID) {
    iterate_menu_resources(menuID, A5_450);
    DisposeMenu(menu);                  /* A937 */
}
```

---

### Function 16: `process_dispatch_table` (0x03B4-0x0466)

**Signature**: `void process_dispatch_table(void* context, void* dispatch_data)`

Iterates through a linked dispatch table with 12-byte entries. For each entry:
1. Checks if entry has a handler (offset 8 != 0)
2. Retrieves the resource via `_GetResource` (A949)
3. Calls the handler function pointer (offset 4)
4. Optionally removes the resource with `_RmveResource` (A86B)
5. Or calls a secondary handler via `iterate_menus_with_action` (0x027E)

Entry stride here is 12 bytes (key + data + handler func pointer).

---

### Function 17: `find_handler_with_fallback` (0x0468-0x04C6)

**Signature**: `void* find_handler_with_fallback(DispatchNode** list_ptr, long key, long param)`

Searches the primary dispatch list for a key. If not found, falls back to the secondary dispatch chain at A5-1330.

```c
void* find_handler_with_fallback(DispatchNode** list_ptr, long key, long param) {
    void* result = lookup_in_list(*list_ptr, key, param);
    if (result != NULL)
        return result;
    if (g_secondary_dispatch == NULL)        /* A5-1330 */
        return NULL;
    void* data = get_handler_data_ptr(g_secondary_dispatch);
    result = process_dispatch_table(g_secondary_dispatch, data);
    if (result != NULL)
        *list_ptr = g_secondary_dispatch;    /* update caller's pointer */
    return result;
}
```

---

### Function 18: `find_handler_filtered` (0x04C8-0x054E)

**Signature**: `void* find_handler_filtered(void* context, void* dispatch_ptr, long key)`

Similar to `find_handler_with_fallback` but applies a filter function. Uses dispatch nodes with 12-byte entries. Calls the filter function (entry offset 4) before accepting a match.

---

### Function 19: `resolve_dual_dispatch` (0x0550-0x05B8)

**Signature**: `void* resolve_dual_dispatch(long key)`

Searches both dispatch chains (A5-1326 and A5-1330) for a matching key, using `get_handler_data_ptr` and `lookup_in_list`. Sets `g_dispatch_target` (A5-27804) to whichever chain contained the match.

```c
void* resolve_dual_dispatch(long key) {
    void* data1 = get_handler_data_ptr(g_dispatch_ptr_2);   /* A5-1326 */
    void* data2 = get_handler_data_ptr(g_dispatch_ptr_1);   /* A5-1330 */

    if (lookup_in_list(data1, key)) {
        if (!lookup_in_list(data2, key))
            g_dispatch_target = g_dispatch_ptr_2;            /* A5-27804 */
    } else {
        if (lookup_in_list(data2, key))
            g_dispatch_target = g_dispatch_ptr_1;
        else
            return NULL;
    }
    return g_dispatch_target;
}
```

---

### Function 20: `track_control_click` (0x05BA-0x05E8)

**Signature**: `short track_control_click(WindowPtr window, ControlHandle control)`

Handles tracking of a mouse click in a control using `_TrackControl` (A92C). If the control value is null after tracking, calls JT[3138] to get a default. Stores result in `g_dispatch_target` (A5-27804).

```c
short track_control_click(WindowPtr window, ControlHandle ctrl) {
    short part = TrackControl(ctrl, window);    /* A92C */
    if (*ctrl == NULL) {
        *ctrl = JT_3138();                       /* JT[3138] */
    }
    g_dispatch_target = *ctrl;                   /* A5-27804 */
    return part;
}
```

---

### Function 21: `main_event_handler` (0x05EA-0x0A0A)

**Signature**: `void main_event_handler(EventRecord* event)`

This is the **largest and most important function** in CODE 11 (1,108 bytes). It is the central event dispatcher for the entire Maven application.

**Frame**: 36 bytes of local variables:
- -12(A6): current handler pointer or window ref
- -14(A6): menu item tracking data
- -20(A6): saved window/port reference
- -24(A6): dialog/window handle
- -32(A6): rect for drawing
- -36(A6): point for coordinate conversion

**Structure**: Two nested switch statements:

#### Switch 1: mouseDown events (event->what == 1)

First, calls `track_control_click` (0x05BA) to determine where the click occurred via `_FindWindow` (A95A). The result (part code 0-8) indexes into a jump table at 0x0A2C:

| Part Code | Handler | Description |
|-----------|---------|-------------|
| 0 | 0x0640 | `inDesk` -- set D6=1, fall through to dispatch |
| 1 | 0x0648 | `inMenuBar` -- process menu bar click |
| 2 | 0x0632 | `inMenuBar` -- handle menu selection (via `_MenuSelect` A93E) |
| 3 | 0x069C | `inSysWindow` -- system window click (calls JT[3114]) |
| 4 | 0x0642 | `inContent` -- content area click (same as case 0, D6=1) |
| 5 | 0x0740 | `inDrag` -- window drag (calls dialog item lookup) |
| 6 | 0x078E | `inGrow` -- window resize |
| 7 | 0x075A | `inGoAway` -- close box click |
| 8 | 0x075C | `inZoomIn/Out` -- zoom box click |

For case 1 (inMenuBar):
- Calls `process_menu_selection` (0x0342) to handle the menu command
- Uses `_MenuSelect` (A93E) or `_MenuKey` (A93D) to get the selection
- Looks up handler in dispatch table
- Calls handler via indirect function pointer `JSR (A2)`
- Unhighlights menu with `_HiliteMenu(0)` (A939)

For case 3 (inSysWindow):
- Checks via JT[3114], if valid, sets D6=9 and dispatches
- Otherwise falls through to standard dispatch at D6=18 and exits

For case 5 (inDrag):
- Uses lookup key 0x000B to find handler
- Calls `_GetDialogItem` (A83B) to test if click is in a dialog item
- If so, dispatches to the dialog handler

For case 6 (inGrow):
- Uses lookup key 0x0007 to find handler
- Calls `_EnableItem` (A91E) to check item state
- Dispatches to resize handler

#### Switch 2: non-mouseDown events (event->what != 1)

Indexes into a jump table at 0x0A0C with event type (0-15):

| Event Type | Handler | Description |
|------------|---------|-------------|
| 0 | 0x0A04 | `nullEvent` -- jump to exit |
| 1 | 0x0A06 | (already handled by switch 1) |
| 2 | 0x07E6 | `mouseUp` -- dispatch via table lookup |
| 3 | 0x082A | `keyDown` -- key event processing |
| 4 | 0x07EA | `keyUp` -- same handling as mouseUp |
| 5 | 0x082E | `autoKey` -- same as keyDown with key-repeat |
| 6 | 0x08B6 | `updateEvt` -- window update/redraw |
| 7 | 0x07F0 | `diskEvt` -- disk inserted |
| 8 | 0x0A02 | `activateEvt` -- window activate/deactivate |
| 9 | 0x0A16 | OS event -- ignored |
| 10-14 | 0x07F6-0x07FE | generic dispatch via table |
| 15 | 0x07E8 | suspend/resume |

**Key event handling (cases 3, 5 -- keyDown/autoKey)**:
- Checks byte 14 of event (modifier keys), specifically the command key bit
- If command key is down AND event type is 3 (keyDown):
  - Saves `g_dispatch_target` (A5-27804)
  - Calls `get_handler_data_ptr` to get the handler context
  - Checks byte 5 of context for '/' (0x2F) character -- menu key equivalent
  - If found, dispatches to menu handler (jumps to 0x0660)
  - Otherwise, processes as `_MenuKey` (A93D) and dispatches result

**Update event handling (case 6)**:
- Retrieves window reference from event->message
- Calls `_HNoPurge` (A873) on the window
- Uses `_GetScrap` (A871) to check for clipboard data
- Calls `_GetNewDialog` (A96C) to create an update dialog if needed
- Processes the update:
  - `_FindWindow` (A95A) to locate the window
  - Dispatches to update handler (lookup key 0x0014)
  - Handles menu enable/disable (`_DisableItem` A938)
  - If window has a picture list (offset 140):
    - Walks linked list of pictures
    - For each: `_HLock` (A029), optionally `_SizeRsrc` (A8A3), `_FrameRect` (A8DF), `_DrawPicture` (A8E6), `_HUnlock` (A02A)
  - Uses `_BeginUpdate`/`_EndUpdate` (A922/A923) bracketing
  - Dispatches completion handler (lookup key 0x0003)
  - Dispatches post-update handler (lookup key 0x0015)
  - Calls `_EndUpdate` (A923)

**Activate event handling (case 8)**:
- Stores event->message as window pointer at -12(A6)
- Chains to 0x09F2 (late event handler section)

**Common dispatch path (0x0806)**:
All handlers converge to the common dispatch path at 0x0806:
1. Push handler context (A3) and lookup result
2. Call `find_handler_filtered` (0x04C8) to resolve handler
3. If handler found, call it: `JSR (A2)` with event and context as params
4. Jump to exit

```c
void main_event_handler(EventRecord* event) {
    void* handler_context;
    short part_code;
    WindowPtr window;

    if (event->what == 1) {  /* mouseDown */
        part_code = FindWindow(event->where, &window);
        handler_context = get_handler_data_ptr(window);

        switch (part_code) {
        case inMenuBar:     /* 2 */
            long menu_result = MenuSelect(event->where);
            process_menu_selection(menu_result);
            HiliteMenu(0);
            break;
        case inContent:     /* 4 */
            /* dispatch to content handler */
            break;
        case inDrag:        /* 5 */
            /* dispatch to drag handler */
            break;
        case inGrow:        /* 6 */
            /* dispatch to grow handler */
            break;
        case inGoAway:      /* 7 */
            /* check TrackGoAway, then close */
            break;
        /* ... other cases ... */
        }
    } else {
        switch (event->what) {
        case keyDown:       /* 3 */
        case autoKey:       /* 5 */
            if (event->modifiers & cmdKey) {
                /* MenuKey handling */
            }
            /* dispatch to key handler */
            break;
        case updateEvt:     /* 6 */
            /* BeginUpdate/EndUpdate with picture drawing */
            break;
        case activateEvt:   /* 8 */
            /* window activate/deactivate */
            break;
        }
    }
}
```

---

### Function 22: `execute_command` (0x0A3E-0x0AD0)

**Signature**: `void execute_command(void* param)`

Executes a command from the 44-byte command table at A5-24026. Uses an index counter at A5-23674 (range 0-7).

**Command Table Structure**:
- Location: A5-24026 (`g_common`)
- Entry size: 44 bytes
- Max entries: 8
- Index counter: A5-23674

**Logic**:
1. Bounds check: index must be 0-7 (calls debugger if out of range)
2. Get current index, increment counter
3. Calculate entry address: `base + index * 44` (MULS.W #44,D0)
4. Save register state into the entry
5. If entry is empty (check at +0 returns 0), call the function via `param`
6. Otherwise, compare with the comparison function JT[3506] using buffers A5-24030 and A5-27732
7. If comparison fails, call `_DisableItem` (A938)
8. If comparison succeeds, process the result and return via a computed jump

```c
void execute_command(void* param) {
    if (g_cmd_index >= 8 || g_cmd_index < 0)
        debugger_break();
    short idx = g_cmd_index++;
    CmdEntry* entry = &g_command_table[idx];    /* A5-24026 + idx*44 */
    /* Save state, check, execute or queue */
    if (/* entry matches */) {
        call_function(param);
        g_cmd_index--;
    } else {
        if (compare(g_buffer1, g_alt_data) == 0)
            DisableItem(0);
        /* restore and return via computed jump */
        g_cmd_index--;
    }
}
```

---

### Function 23: `drain_events` (0x0AD2-0x0AF8)

**Signature**: `void drain_events(short event_mask)`

Processes all pending events matching the given mask. Loops calling `_EventAvail` (A971) until no more events are available, processing each via `handle_window_event` (0x0B54).

```c
void drain_events(short mask) {
    EventRecord event;
    while (EventAvail(mask, &event)) {   /* A971 */
        handle_window_event(&event, mask);
    }
}
```

---

### Function 24: `get_cursor_for_context` (0x0AFA-0x0B52)

**Signature**: `void* get_cursor_for_context(void* param1, void* param2)`

Resolves and sets the appropriate cursor for the current context. Uses `get_handler_data_ptr` and dispatch lookup, then falls back to JT[3082]. If no cursor is found, uses a default at A5-1442. Finally calls `_SetCursor` (A851).

```c
void* get_cursor_for_context(void* p1, void* p2) {
    void* data = get_handler_data_ptr(p1);
    void* handler = lookup_in_list(data, 0x0011);  /* cursor lookup key */
    void* cursor = NULL;
    if (handler) {
        cursor = handler(p1, p2);
    }
    void* alt_cursor = JT_3082(p2);
    if (cursor == NULL)
        cursor = alt_cursor;
    if (cursor == NULL)
        cursor = &g_default_cursor;     /* A5-1442 */
    SetCursor(cursor);                   /* A851 */
    return cursor;
}
```

---

### Function 25: `handle_window_event` (0x0B54-0x0BF2)

**Signature**: `void handle_window_event(EventRecord* event, short mask)`

Handles window-level events including activate/deactivate state management. Uses a state variable at A5-27810 to track the current activation state (0=none, 1=active, 2=alternative).

**Logic**:
1. Get window from event via `_GetHandleSize` (A9B4)
2. Check event type with `_GetNextEvent` (A970)
3. Call `track_control_click` (0x05BA via PC call to 0x0A3E)
4. If event type is 8 (activateEvt):
   - Get context via JT[3138]
   - Check with JT[1610]
   - If context is valid and not already active (A5-27810 != 1):
     - Call JT[1570] (activate handler)
     - Set A5-27810 = 1
   - If context is null and currently active:
     - Call JT[1578] (deactivate handler)
     - Set A5-27810 = 0
   - If context has alternative state (via JT[1618]):
     - Call JT[1578], then set A5-27810 = 2
5. For other event types:
   - Get context via JT[3138]
   - If context exists, call `get_cursor_for_context` (0x0AFA)

```c
void handle_window_event(EventRecord* event, short mask) {
    WindowPtr window = (WindowPtr)event;
    /* ... event processing ... */
    if (event->what == activateEvt) {
        void* ctx = JT_3138();
        if (check_something(ctx)) {
            if (g_activate_state != 1) {
                JT_1570();              /* activate */
                g_activate_state = 1;
            }
        } else if (ctx == NULL) {
            if (g_activate_state != 0) {
                JT_1578();              /* deactivate */
                g_activate_state = 0;
            }
        } else if (check_alt(ctx)) {
            if (g_activate_state != 2) {
                JT_1578();
                g_activate_state = 2;
            }
        }
    } else {
        void* ctx = JT_3138();
        if (ctx) get_cursor_for_context(window, ctx);
    }
}
```

---

### Function 26: `handle_dialog_event` (0x0BF4-0x0C38)

**Signature**: `void handle_dialog_event(DialogPtr dialog, short item)`

Handles a dialog item click. Uses `_CheckItem` (A95D), `_SetHandleSize` (A03B), `_FindWindow` (A95A), then dispatches to the dialog handler via indirect call.

```c
void handle_dialog_event(DialogPtr dlg, short item) {
    CheckItem(dlg, item);                /* A95D */
    Rect r;
    SetHandleSize(r, 2);                /* A03B */
    Handle h;
    FindWindow(NULL, dlg);               /* A95A */
    void* handler = lookup_in_list(NULL, 0x0015);
    handler(dlg, 0);                     /* dispatch */
    CheckItem(dlg, 0);                  /* A95D - uncheck */
}
```

---

### Function 27: `open_settings_dialog` (0x0C3A-0x0C56)

**Signature**: `void open_settings_dialog(void)`

Opens the dictionary/settings dialog by setting a global pointer (A5-23666) to a fixed address (0x016A = JT[362]), clearing a flag byte (A5-23672), and calling `handle_window_event` with mask 0xFFFF.

```c
void open_settings_dialog(void) {
    g_dialog_handler = 0x016A;           /* A5-23666 */
    g_dialog_flag = 0;                   /* A5-23672 */
    EventRecord event;
    handle_window_event(&event, -1);     /* mask = 0xFFFF = all events */
}
```

---

### Function 28: `memset_zero` (0x0C58-0x0C78)

**Signature**: `void memset_zero(void* dest, long count)`

Fills a memory region with zero bytes. Simple byte-clearing loop.

```c
void memset_zero(void* dest, long count) {
    char* p = (char*)dest;
    char* end = p + count;
    while (p < end) {
        *p++ = 0;
    }
}
```

---

### Function 29: `process_xgme_commands` (0x0C7A-0x0D46)

**Signature**: `void process_xgme_commands(void)`

Processes commands with the "XGME" (0x58474D45) magic identifier. Uses the same 44-byte command table as `execute_command`. Frame size is 282 bytes (large local buffer for command processing, including a 270-byte buffer at -270(A6)).

**Logic**:
1. Bounds check command index (A5-23674, range 0-7)
2. Get current index, increment, calculate entry address (MULS #44)
3. Call JT[778] to initialize
4. Call JT[2954] to get command list, JT[2962] to get individual commands
5. Loop through commands:
   - Get command at index via JT[2962]
   - Compare magic number: if `*(long*)(-268(A6)) == "XGME"`, call JT[1450] to process
   - Check result flag at -2(A6)
   - Advance to next via JT[2970]
6. If flag indicates error:
   - Call error dialog display (0x10EA area)
   - Load handle A5-8584, show `_DisposDialog` (A9AA)
   - Run `_ModalDialog` (A9AF), check result
   - Call cleanup, `_InitCursor` (A994), `_SelectWindow` (A999)
7. Decrement command index
8. If previous context (A5-24030) exists, call JT[3194]
9. Call JT[1634] for finalization

```c
void process_xgme_commands(void) {
    if (g_cmd_index >= 8 || g_cmd_index < 0)
        debugger_break();
    short idx = g_cmd_index++;
    CmdEntry* entry = &g_command_table[idx];

    JT_778();                           /* init */
    short count;
    JT_2954(&result, &count);           /* get command list */

    Boolean found = false;
    for (short i = 1; i <= count; i++) {
        char buffer[270];
        JT_2962(i, buffer);            /* get command data */
        if (*(long*)buffer == 'XGME') {
            JT_1450(buffer + 8, *(short*)buffer);
            if (result_flag == 1)
                break;
        }
        JT_2970(i);                    /* advance */
    }

    if (!found) {
        /* Show error dialog, handle modal interaction */
        DialogPtr dlg = GetNewDialog(...);
        ModalDialog(NULL, &item);
        if (item != 0) {
            /* handle dialog result */
        }
        InitCursor();
        SelectWindow(...);
    }

    g_cmd_index--;
    if (g_previous_context != NULL)
        JT_3194(g_previous_context);
    JT_1634();                          /* finalize */
}
```

---

### Init Block 1 (0x0D48-0x0DA2)

Not a function -- a block of code that registers 15 handler functions via the A9F1 trap. Each entry is `PEA A5+offset; A9F1`:

| JT Offset | Purpose (estimated) |
|-----------|---------------------|
| A5+2754 | Handler 1 |
| A5+2706 | Handler 2 |
| A5+2722 | Handler 3 |
| A5+2082 | Handler 4 |
| A5+2146 | Handler 5 |
| A5+2226 | Handler 6 |
| A5+2794 | Handler 7 |
| A5+2682 | Handler 8 |
| A5+2586 | Handler 9 |
| A5+3442 | Handler 10 |
| A5+2618 | Handler 11 |
| A5+2642 | Handler 12 |
| A5+2322 | Handler 13 |
| A5+2114 | Handler 14 |
| A5+2442 | Handler 15 |

Ends with RTS at 0x0DA2.

---

### Function 30: `init_lexicon_and_menus` (0x0DA4-0x10DC)

**Signature**: `void init_lexicon_and_menus(void)`

This is the **second largest function** (964 bytes). It handles dictionary initialization, menu setup, and the lexicon mode state machine. Frame size: 128 bytes.

**Structure**:

1. **LINK and init block 2 registration** (0x0DA4-0x0E96): Calls the init block (0x0D48) via PC-relative JSR, then registers 40 additional handler functions via the same PEA/A9F1 pattern.

2. **Lexicon state switch** (0x0E9C-0x10DC): A 6-way switch on `g_validation_state - 3` (A5-8602 after SUBQ #3). The switch table is at 0x10DE:

| State | Target | Description |
|-------|--------|-------------|
| 3 | 0x0EB6 | **Reset/Initialize**: Clear DAWG data, set up default buffers |
| 4 | 0x0FFC | **Load second dictionary**: Load OSW/reverse DAWG |
| 5 | 0x0F38 | **Initialize DAWG info**: Set up 34-byte DAWG info structure |
| 6 | 0x10B0 | **Finalize**: Complete setup, clear window |
| 7 | 0x0F62 | **Load first dictionary**: Load S2 (forward DAWG) |
| 8 | 0x0F44 | **Initialize DAWG pointers**: Set up memory pointers |

#### State 3 (0x0EB6): Reset/Initialize
```c
/* Clear display and DAWG data */
SetCursor(A5_3396);                      /* A851 */
JT_1042();                              /* init subsystem */
g_size2 = 0;                            /* A5-15502 CLR.L */
g_size1 = 0;                            /* A5-15506 CLR.L */
g_field_14 = 0;                         /* A5-15514 MOVE.B #0 */
g_field_22 = 0;                         /* A5-15522 MOVE.B #0 */
g_word_count = 0;                       /* A5-19470 */
JT_1258();                              /* post-search init */
JT_234();                               /* unknown init */
JT_1410(g_field_22);                    /* finalize buffer */
JT_1410(g_field_14);                    /* finalize buffer */
JT_1362();                              /* state update */
FrontWindow();                           /* A850 */
JT_290();                               /* unknown */
g_unk_8618 = 0;                         /* A5-8618 CLR.L */

/* Determine lexicon mode based on buffer state */
if (g_current_ptr == g_field_22)         /* A5-15498 vs A5-15522 */
    g_lexicon_mode = 2;                  /* OSW mode */
else
    g_lexicon_mode = 3;                  /* SOWPODS mode */

/* Clear validation buffers */
memset_zero(A5_23400, 88);              /* 88 bytes = 0x58 */
memset_zero(A5_23312, 88);              /* second buffer */
```

#### State 7 (0x0F62): Load First Dictionary (S2)
```c
g_dict_ptr = A5_370;                     /* A5-19474 */
JT_2410(g_current_ptr);                 /* setup buffer */
JT_2434();                              /* setup more */

/* Calculate DAWG pointer */
g_dawg_ptr += g_size2;                   /* A5-23074 += A5-15502 */

/* Initialize DAWG info structure */
JT_314(g_dawg_info, A5_8490, g_dawg_ptr); /* load DAWG section */
g_dawg_ptr += g_size2;                   /* advance pointer */
JT_1258();                               /* post-search init */

/* Setup validation */
JT_2370(1, g_current_ptr, g_dawg_info); /* setup params */
JT_842(A5_23400, A5_23488);             /* copy buffers */

/* Reset and configure */
g_dict_ptr = 0;
JT_1410(g_current_ptr);                 /* finalize buffer */
JT_1362();                              /* state update */

/* Set current pointer to field_22 */
g_current_ptr = &g_field_22;
JT_658();                               /* init subsystem */

/* Process DAWG */
JT_362(0, g_dawg_info);                 /* process DAWG */
JT_2346();                              /* check result */
if (check_result)
    g_lexicon_mode = 4;
else
    g_lexicon_mode = 2;

/* Copy DAWG info */
memset_zero(A5_23090, 34);              /* 34 bytes = 0x22 */
```

#### State 4 (0x0FFC): Load Second Dictionary
```c
/* Check if we need to switch buffers */
if (g_current_ptr == g_field_22) {
    /* Function at 0x1164 area - setup for second load */
}
g_handler_ptr = A5_458;                  /* A5-23670 */
open_settings_dialog();                  /* call 0x0C3A */
g_lexicon_mode = 0;                     /* clear mode */

/* Read existing DAWG data from current buffer */
JT_650(g_current_ptr, 0x78);            /* get 120 bytes of data */
/* Copy 34 bytes (DAWG info) via MOVE.L loop */
g_handler_ptr = 0;

/* Calculate section 1 pointer */
g_dawg_ptr += g_size1;                   /* A5-23074 += A5-15506 */
JT_1258();                               /* post-search init */

/* Load section 1 data */
JT_314(g_dawg_info, A5_8464, g_size1);  /* load DAWG section 1 */
JT_2370(1, g_current_ptr, g_dawg_info);
JT_842(A5_23312, A5_23488);             /* copy buffers */
JT_1410(g_current_ptr);                 /* finalize */

/* Set up field_14 as current */
g_current_ptr = &g_field_14;
JT_658();                               /* init */

/* Process with flags */
JT_362(0x00010001, g_dawg_info);        /* process DAWG with flag */
JT_2346();
if (check_result)
    g_lexicon_mode = 4;
else
    g_lexicon_mode = 3;                 /* SOWPODS */
```

#### State 6 (0x10B0): Finalize
```c
JT_346();                               /* finalize dictionary */
g_current_ptr = 0;                      /* clear */
g_lexicon_mode = 5;                     /* transitional */

JT_282();                               /* check something */
if (result) {
    JT_3578(g_size1, g_size2);          /* final call with sizes */
}

/* Clear window */
JT_1218(0, g_window_ptr);              /* clear window */
```

---

### Lexicon State Machine (0x10EA-0x111A)

Not a LINK function -- inline code within `init_lexicon_and_menus`. Implements a loop that drives the dictionary setup process through multiple states.

```c
void lexicon_state_machine(void) {
    g_validation_state = 1;              /* A5-8602 */

    do {
        init_lexicon_and_menus();        /* process current state */

        if (g_lexicon_mode == 0) {       /* A5-8604 */
            /* Mode not yet set -- need user interaction */
            do {
                open_settings_dialog();  /* show dialog */
                short result = validate_word();  /* check */
            } while (result == 0);
        }

        g_validation_state = validate_word();    /* get new state */
        g_lexicon_mode = 0;              /* clear mode */

    } while (g_validation_state != 2);   /* loop until state 2 (complete) */
}
```

---

### Word Validation Function (0x111C-0x1162)

Not a LINK function -- uses MOVEM for register save/restore. Implements table-driven word validation.

**Signature**: `short validate_word(void)`

Searches the validation table at A5-24244 (56 bytes = 14 entries x 4 bytes each) to determine if a word is valid for the current lexicon mode.

**Table entry format** (4 bytes):
| Byte | Purpose |
|------|---------|
| 0 | Condition value (matches g_validation_state, or 0xFF = wildcard) |
| 1 | Required lexicon mode (must match g_lexicon_mode) |
| 2 | Result value (returned if both conditions match) |
| 3 | Padding |

```c
short validate_word(void) {
    if (g_lexicon_mode == 0)             /* A5-8604 */
        return 0;                        /* no mode set */

    char* table_end = A5 - 24188;        /* end pointer */
    char* entry = A5 - 24244;            /* start pointer */

    while (entry < table_end) {
        char condition = entry[0];

        /* Match if condition equals validation_state OR condition is 0xFF */
        if ((signed char)condition == (short)g_validation_state ||
            condition == 0xFF) {
            /* Check if lexicon mode matches */
            if ((signed char)entry[1] == (short)g_lexicon_mode) {
                return (signed char)entry[2];   /* return result */
            }
        }
        entry += 4;                      /* next entry */
    }

    return 0;                            /* no match found */
}
```

The table has 14 entries covering all combinations of validation states and lexicon modes, mapping each to a validity result. This is how Maven determines TWL vs OSW word validity without needing separate DAWGs.

---

### Error Handler (0x1164-0x1166)

```asm
1164: A9FF    _Debugger       ; drop into MacsBug debugger
1166: 4E75    RTS
```

Called as an assertion failure handler. Invokes the `_Debugger` trap (A9FF) which drops into MacsBug or the built-in debugger, then returns. Called from bounds checks, not-found errors, and invalid state conditions throughout CODE 11.

---

### Function 31: `is_lexicon_not_mode4` (0x1168-0x117C)

**Signature**: `long is_lexicon_not_mode4(void)`

Simple predicate that returns 1 if `g_validation_state` (A5-8602) is not equal to 4, and 0 if it is.

```c
long is_lexicon_not_mode4(void) {
    return (g_validation_state != 4) ? 1 : 0;
}
```

Assembly:
```asm
1168: LINK    A6,#0
116C: CMPI.W  #4,-8602(A5)    ; compare g_validation_state with 4
1172: SNE     D0              ; D0 = 0xFF if not equal, 0x00 if equal
1174: NEG.B   D0              ; D0 = 0x01 if not equal, 0x00 if equal
1176: EXT.W   D0              ; sign-extend to word
1178: EXT.L   D0              ; sign-extend to long
117A: UNLK    A6
117C: RTS
```

---

## Data Structures

### Callback Table
```c
/* A5-27800: 16-slot callback registration table */
typedef struct {
    void* callbacks[16];       /* A5-27800, 64 bytes */
    /* ... gap ... */
    short count;               /* A5-27872, current registration count */
} CallbackTable;
```

### Dispatch Node (Linked List)
```c
/* Used by lookup_in_list (0x00A0) - 8-byte entries */
typedef struct DispatchNode8 {
    struct DispatchNode8* next;  /* offset 0 */
    short count;                /* offset 2 */
    /* padding to offset 8 */
    struct {
        long key;               /* offset 0 within entry */
        void* data;             /* offset 4 within entry */
    } entries[];                /* starting at node offset 8, stride 8 */
} DispatchNode8;

/* Used by process_dispatch_table (0x03B4) - 12-byte entries */
typedef struct DispatchNode12 {
    struct DispatchNode12* next; /* offset 0 */
    short count;                /* offset 2 */
    struct {
        long key;               /* offset 0 */
        void* handler;          /* offset 4 */
        void* data;             /* offset 8 */
    } entries[];                /* starting at node offset 12, stride 12 */
} DispatchNode12;
```

### Command Table Entry
```c
/* A5-24026: 44-byte command entries, max 8 */
typedef struct CommandEntry {
    char data[44];              /* exact field layout unknown */
    /* Known: register state saved via MOVEM at some offset */
    /* Magic "XGME" compared at offset within local buffer */
} CommandEntry;
```

### Validation Table Entry
```c
/* A5-24244: 4-byte validation entries, 14 entries (56 bytes) */
typedef struct ValidationEntry {
    signed char condition;      /* match against g_validation_state, or 0xFF=wildcard */
    signed char required_mode;  /* must match g_lexicon_mode */
    signed char result;         /* return value if matched */
    char padding;
} ValidationEntry;
```

### Game Context (partial)
```c
/* Passed to get_handler_data_ptr and dispatch functions */
typedef struct GameContext {
    char unknown[108];
    short mode_flags;           /* offset 108 */
    char feature_bits;          /* offset 109: bit 1 checked */
    char field_110;             /* offset 110: checked for non-zero */
    char unknown2[41];
    void* handler_ptr;          /* offset 152: custom handler function */
} GameContext;
```

## Global Variables

| A5 Offset | Type | Name | Purpose |
|-----------|------|------|---------|
| A5-27912 | void* | `g_default_data` | Default handler data pointer |
| A5-27896 | void* | `g_alt_data` | Alternate handler data pointer |
| A5-27872 | short | `g_callback_count` | Number of registered callbacks (max 16) |
| A5-27810 | short | `g_activate_state` | Window activation state (0/1/2) |
| A5-27808 | long | `g_saved_dispatch` | Saved dispatch pointer |
| A5-27804 | long | `g_dispatch_target` | Current dispatch target |
| A5-27800 | void*[16] | `g_callback_table` | 16-slot callback registration array |
| A5-27732 | void* | `g_buffer1` | Buffer area 1 |
| A5-24244 | byte[56] | `g_validation_table` | Word validation lookup table (14 x 4 bytes) |
| A5-24188 | void* | `g_validation_end` | End of validation table |
| A5-24030 | void* | `g_previous_context` | Previous command context |
| A5-24026 | byte[352] | `g_command_table` | Command table (8 x 44 bytes) |
| A5-23674 | short | `g_cmd_index` | Command table index (0-7) |
| A5-23672 | byte | `g_dialog_flag` | Dialog state flag |
| A5-23670 | void* | `g_handler_ptr` | Current handler pointer |
| A5-23488 | byte[] | `g_validation_buf_2` | Validation buffer 2 |
| A5-23400 | byte[88] | `g_validation_buf_s2` | S2 validation buffer |
| A5-23312 | byte[88] | `g_validation_buf_s1` | S1 validation buffer |
| A5-23090 | byte[34] | `g_dawg_info` | 34-byte DAWG info structure |
| A5-23074 | long | `g_dawg_ptr` | Main DAWG data pointer |
| A5-22706 | byte[8] | `g_dawg_aux` | Auxiliary DAWG data |
| A5-19474 | long | `g_dict_ptr` | Dictionary pointer |
| A5-19470 | short | `g_word_count` | Word count tracking |
| A5-15522 | byte | `g_field_22` | Board buffer 2 (hook-after) |
| A5-15514 | byte | `g_field_14` | Board buffer 1 (hook-before) |
| A5-15506 | long | `g_size1` | DAWG section 1 size (56,630) |
| A5-15502 | long | `g_size2` | DAWG section 2 size (65,536) |
| A5-15498 | void* | `g_current_ptr` | Current active buffer pointer |
| A5-8618 | long | `g_unk_8618` | Unknown (cleared during init) |
| A5-8614 | long | `g_unk_8614` | Saved from 0x016A |
| A5-8604 | short | `g_lexicon_mode` | Lexicon mode (0-5) |
| A5-8602 | short | `g_validation_state` | Validation state variable |
| A5-8584 | long | `g_handle` | Handle to data structure |
| A5-8510 | void* | `g_window_ptr` | Main window pointer |
| A5-8490 | byte[] | `g_dawg_buffer_s2` | DAWG buffer for S2 |
| A5-8464 | byte[] | `g_dawg_buffer_s1` | DAWG buffer for S1 |
| A5-3396 | void* | `g_wait_cursor` | Wait cursor resource |
| A5-1442 | void* | `g_default_cursor` | Default cursor |
| A5-1330 | long | `g_dispatch_ptr_1` | Primary dispatch chain pointer |
| A5-1326 | long | `g_dispatch_ptr_2` | Secondary dispatch chain pointer |

### Positive A5 offsets (Jump Table vicinity)

The function at 0x0DA4 registers 55 handlers via `PEA A5+offset; A9F1`. These positive A5 offsets correspond to jump table entries used as command/event handler registrations. Key ones:

| A5 Offset | Used In | Likely Purpose |
|-----------|---------|----------------|
| A5+130 | init | Handler registration |
| A5+162 | init | Handler registration |
| A5+194 | init | Handler registration |
| A5+370 | state 7 | Dictionary pointer base |
| A5+450 | delete_menu | Menu reference |
| A5+458 | state 4 | Handler pointer base |
| A5+498 | process_menu | Menu iteration context |

## Jump Table Calls

### Made FROM CODE 11

| JT Offset | Called From | Purpose |
|-----------|------------|---------|
| JT[234] | 0x0DA4 | Unknown init |
| JT[282] | 0x0DA4 | Check something (state 6) |
| JT[290] | 0x0DA4 | Unknown (state 3) |
| JT[314] | 0x0DA4 | Load DAWG section data |
| JT[346] | 0x0DA4 | Finalize dictionary (state 6) |
| JT[362] | 0x0DA4 | Process DAWG traversal |
| JT[650] | 0x0DA4 | Get data from buffer |
| JT[658] | 0x0DA4 | Init subsystem |
| JT[778] | 0x0C7A | Init (XGME processing) |
| JT[842] | 0x0DA4 | Copy buffers |
| JT[1042] | 0x0DA4 | Init subsystem (state 3) |
| JT[1218] | 0x0DA4 | Clear window (state 6) |
| JT[1258] | 0x0DA4 | Post-search init |
| JT[1362] | 0x0DA4 | State update |
| JT[1410] | 0x0DA4 | Finalize buffer |
| JT[1450] | 0x0C7A | Process XGME command |
| JT[1570] | 0x05EA, 0x0B54 | Activate handler |
| JT[1578] | 0x05EA, 0x0B54 | Deactivate handler |
| JT[1610] | 0x0000, 0x0B54 | Check context validity |
| JT[1618] | 0x0B54 | Check alternative state |
| JT[1626] | 0x05EA | Unknown (event handler) |
| JT[1634] | 0x0C7A | Finalize (XGME) |
| JT[2346] | 0x0DA4 | Check DAWG result |
| JT[2370] | 0x0DA4 | Setup DAWG params |
| JT[2410] | 0x0DA4 | Setup buffer |
| JT[2434] | 0x0DA4 | Setup more |
| JT[2954] | 0x0C7A | Get command list |
| JT[2962] | 0x0C7A | Get individual command |
| JT[2970] | 0x0C7A | Advance to next command |
| JT[3082] | 0x0AFA | Get cursor context |
| JT[3114] | 0x05EA | Check window (inSysWindow) |
| JT[3138] | 0x05BA, 0x0B54 | Get context for window |
| JT[3194] | 0x0C7A | Process previous context |
| JT[3506] | 0x0A3E | Compare function |
| JT[3578] | 0x0DA4 | Final call with DAWG sizes |

### Exported BY CODE 11 (JT[376]-JT[520])

CODE 11 exports 19 functions via JT entries 376-520. Based on cross-referencing with other CODE analyses:

| JT Offset | Function | Purpose |
|-----------|----------|---------|
| JT[376] | 0x0000 | `get_handler_data_ptr` |
| JT[384] | 0x0058 | `dispatch_with_context` |
| JT[392] | 0x0086 | `dispatch_indirect` |
| JT[400] | 0x00A0 | `lookup_in_list` |
| JT[408] | 0x00E6 | `convert_local_to_global` |
| JT[416] | 0x0106 | `update_dispatch_entry` |
| JT[424] | 0x014C | `is_callback_registered` |
| JT[432] | 0x017C | `register_callback` |
| JT[440] | 0x01A6 | `unregister_callback` |
| JT[448] | 0x020E | `dispatch_event_to_handler` |
| JT[456] | 0x027E | `iterate_menus_with_action` |
| JT[464] | 0x02D2 | `iterate_menu_resources` |
| JT[472] | 0x0342 | `process_menu_selection` |
| JT[480] | 0x037E | `hilite_or_draw_menu` |
| JT[488] | 0x039E | `delete_menu_by_id` |
| JT[496] | 0x03B4 | `process_dispatch_table` |
| JT[504] | 0x0468 | `find_handler_with_fallback` |
| JT[512] | 0x04C8 | `find_handler_filtered` |
| JT[520] | 0x0550 | `resolve_dual_dispatch` |

## Toolbox Traps Used

| Trap | Name | Used In |
|------|------|---------|
| A029 | `_HLock` | 0x05EA (update event - lock picture handle) |
| A02A | `_HUnlock` | 0x05EA (update event - unlock picture handle) |
| A03B | `_SetHandleSize` | 0x0BF4 (dialog event) |
| A80D | `_CountResources` | 0x02D2 (count MENU resources) |
| A80E | `_GetIndResource` | 0x02D2 (get menu by index) |
| A83B | `_GetDialogItem` | 0x05EA (mouseDown in dialog) |
| A850 | `_FrontWindow` | 0x027E, 0x0DA4 (get front window) |
| A851 | `_SetCursor` | 0x0AFA, 0x0DA4 (set cursor shape) |
| A86A | `_AddResource` | 0x03B4, 0x04C8, 0x05EA (resource management) |
| A86B | `_RmveResource` | 0x03B4, 0x05EA (remove resource) |
| A871 | `_GetScrap` | 0x05EA (clipboard check during update) |
| A873 | `_HNoPurge` | 0x05EA (prevent handle purging) |
| A8A3 | `_SizeRsrc` | 0x05EA (get resource size for drawing) |
| A8A9 | `_InsetRect` | 0x05EA (inset rectangle for picture) |
| A8D8 | `_OpenRgn` | 0x05EA (begin region definition) |
| A8D9 | `_CloseRgn` | 0x05EA (end region definition) |
| A8DF | `_FrameRect` | 0x05EA (frame rectangle) |
| A8E6 | `_DrawPicture` | 0x05EA (draw PICT resource) |
| A917 | `_GetWMgrPort` | 0x00E6 (get window manager port) |
| A918 | `_LocalToGlobal` | 0x00E6 (coordinate conversion) |
| A91E | `_EnableItem` | 0x05EA (enable menu item) |
| A922 | `_BeginUpdate` | 0x05EA (begin window update) |
| A923 | `_EndUpdate` | 0x05EA (end window update) |
| A92C | `_TrackControl` | 0x05BA (track control click) |
| A937 | `_DisposeMenu` | 0x039E (dispose menu) |
| A938 | `_DisableItem` | 0x0A3E, 0x05EA (disable menu item) |
| A939 | `_HiliteMenu` | 0x027E, 0x037E, 0x03B4, 0x05EA |
| A93A | `_DrawMenuBar` | 0x027E, 0x037E (redraw menu bar) |
| A93D | `_MenuKey` | 0x05EA (check menu key equivalent) |
| A93E | `_MenuSelect` | 0x05EA (track menu selection) |
| A946 | `_GetIndString` | 0x027E (get indexed string) |
| A949 | `_GetResource` | 0x02D2, 0x03B4, 0x04C8, 0x05EA |
| A950 | `_FrontWindow` | 0x027E (get front window) |
| A953 | `_SetWTitle` | 0x05EA (set window title) |
| A95A | `_FindWindow` | 0x05EA, 0x0BF4 (find window at point) |
| A95D | `_CheckItem` | 0x0BF4 (check/uncheck menu item) |
| A968 | `_SetPort` | 0x05EA (set current graphics port) |
| A96C | `_GetNewDialog` | 0x05EA (create dialog from template) |
| A970 | `_GetNextEvent` | 0x0B54 (get next event) |
| A971 | `_EventAvail` | 0x0AD2 (check for pending events) |
| A978 | `_SetWindowPic` | 0x05EA (set window picture) |
| A98D | `_FindDItem` | 0x05EA (find dialog item at point) |
| A994 | `_InitCursor` | 0x0C7A (reset cursor to arrow) |
| A999 | `_SelectWindow` | 0x0C7A (bring window to front) |
| A99B | `_GetIndResource` | 0x02D2 (get indexed resource) |
| A9A8 | `_GetHandleSize` | 0x02D2 (get handle size) |
| A9AA | `_DisposDialog` | 0x0C7A (dispose dialog) |
| A9AF | `_ModalDialog` | 0x0C7A (run modal dialog) |
| A9B3 | `_SetHandleSize` | 0x05EA (resize handle) |
| A9B4 | `_GetHandleSize` | 0x0B54 (get handle size) |
| A9F1 | Custom trap | 0x0D48, 0x0DA4 (register handler, 55 calls) |
| A9FF | `_Debugger` | 0x1164 (assertion failure) |

## Lexicon Mode Values

| Value | Meaning | Set At |
|-------|---------|--------|
| 0 | Reset/cleared | 0x110E, 0x1014 |
| 1 | (implied: North American/TWL) | validation table |
| 2 | UK/OSW dictionary | 0x0F0A, 0x0FE2 |
| 3 | Both/SOWPODS combined | 0x0F0E, 0x10A2 |
| 4 | Dual-dictionary loaded | 0x0FDE, 0x109E |
| 5 | Transitional (mid-switch) | 0x10B2 |

## Architecture Diagram

```
                    +--------------------------+
                    |       CODE 11            |
                    |  (Game Controller)       |
                    +--------------------------+
                    |                          |
    +---------------+---+---+---+----------+--+-----------+
    |               |   |   |   |          |              |
    v               v   v   v   v          v              v
 Callbacks      Dispatch  Menus Events   Lexicon    Validation
 (0x014C-       Tables    (0x027E-      Control     (0x111C)
  0x020C)       (0x00A0-  0x039E)      (0x0DA4-
                 0x0106)               0x10DC)
    |               |       |    |         |
    |               |       |    |         +-- State machine (0x10EA)
    |               |       |    |         +-- DAWG loading
    |               |       |    |         +-- Buffer management
    |               |       |    |
    |               |       |    +-- mouseDown handler (FindWindow switch)
    |               |       |    +-- keyDown handler (MenuKey)
    |               |       |    +-- updateEvt handler (DrawPicture)
    |               |       |    +-- activateEvt handler
    |               |       |
    |               |       +-- CountResources('MENU')
    |               |       +-- GetIndResource
    |               |       +-- DisposeMenu
    |               |
    |               +-- Linked list lookup (8-byte entries)
    |               +-- Linked list lookup (12-byte entries)
    |               +-- Dual-chain dispatch (A5-1326, A5-1330)
    |
    +-- 16-slot callback table (A5-27800)
    +-- Register/unregister/invoke
```

## Cross-References

### CODE resources called via JT
CODE 11 calls functions in approximately 17 other CODE resources via jump table entries. Major relationships:

- **CODE 3** (Search): via JT[362] (DAWG traversal), JT[842] (buffer copy)
- **CODE 7** (Board): via JT[1570]/JT[1578] (activate/deactivate)
- **CODE 9** (DAWG): via JT[314] (load DAWG section), JT[2346]/JT[2370] (validation)
- **CODE 14**: via JT[3138] (get context)
- **CODE 21** (UI): via JT[1218] (clear window)
- **CODE 32** (Leave): via JT[3506] (compare), JT[3578] (final call)

### A9F1 handler registration
55 handlers are registered during initialization, covering the full range of game commands. These handlers are distributed across many CODE resources and are invoked through the dispatch table system when the user performs actions.

## Confidence Assessment

| Area | Level | Notes |
|------|-------|-------|
| Callback system (0x014C-0x020C) | HIGH | Clear register/unregister/invoke pattern |
| Dispatch table lookup (0x00A0) | HIGH | Standard linked-list search |
| Menu management (0x027E-0x039E) | HIGH | Standard Mac Toolbox patterns |
| Main event handler (0x05EA) | HIGH | Classic Mac event loop structure |
| Lexicon controller (0x0DA4) | HIGH | Complex but well-understood state machine |
| Word validation (0x111C) | HIGH | Clear table-driven lookup |
| Command table (0x0A3E, 0x0C7A) | MED | 44-byte entry structure partially understood |
| A9F1 trap purpose | MED | Custom handler registration, exact mechanism unclear |
| Dispatch entry formats | MED | Two formats (8-byte and 12-byte) confirmed |

## Key Insights

1. **TWL/OSW filtering**: The validation table at A5-24244 is the mechanism that filters words by dictionary. No separate TWL DAWG exists -- the SOWPODS DAWG contains all words, and per-word flags combined with the validation table determine which words are valid for each mode.

2. **Two-buffer system**: CODE 11 manages two DAWG buffers (`g_field_14` at A5-15514 and `g_field_22` at A5-15522). S2 (forward DAWG) is loaded into one, S1 (reversed cross-check DAWG) into the other. The `g_current_ptr` (A5-15498) points to whichever is currently active.

3. **State machine**: The lexicon loading process uses a 6-state machine (states 3-8) that handles the complex multi-step process of loading two dictionary sections, initializing DAWG structures, and validating the results.

4. **Handler registration**: The 55 PEA/A9F1 calls during initialization register all of Maven's command handlers into a dispatch system. This is a form of command pattern implementation where each game action (menu commands, mouse clicks, keyboard shortcuts) is handled by a registered function.

5. **XGME magic**: The "XGME" (0x58474D45) identifier in `process_xgme_commands` suggests an inter-application communication or plugin protocol, possibly for exchanging game data or extensions.
