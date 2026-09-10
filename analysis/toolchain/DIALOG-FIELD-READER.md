# Word List field extraction

The CODE 0 entry at A5+0x0642 resolves to CODE 9+0x0dea..0x0e30.
Arguments are a dialog pointer, a 16-bit item number, and an output pointer.
The reader calls GetDItem (A98D), providing local storage for item type,
handle and rectangle. It checks the returned handle; if null, it calls
A5+0x01a2, resolving to CODE 11+0x1168 (`Debugger`, A9FF; then RTS).
This is not an inferred exception or safe early return: execution proceeds
after that call if the debugger returns.

Before GetIText (A990), the reader clears output bytes 1 and 0. It fetches
the Pascal string into that same buffer, then calls A5+0x0bea, which maps to
CODE 34+0x0020. That function shifts exactly the unsigned length byte's
number of bytes left by one, appends NUL and returns the original pointer.
It preserves embedded zero bytes during copying, though later C-string
consumers may stop at them. `pascal_string.c` reconstructs this operation.

No filtering, case conversion, truncation or numeric validation appears in
this reader. The Word List callers separately normalize letter fields. The
attempted `x` in a length control did not reach the observed scanner, but
this reader does not explain that behavior: input dispatch and dialog item
handlers still need auditing. Do not treat the empty captured field as proof
that the scanner rejects nonempty invalid text.

This analysis uses corrected resource bytes and the validated CODE 0 map.
The converter test checks all 256 lengths, arbitrary payload bytes including
embedded zeros, return-pointer identity and untouched trailing bytes. No
natural converter-call trace or Toolbox failure-path capture is claimed.

## Allowed-character filtering before extraction

The separate CODE 12 routine at +0x0686 calls A5+0x0cd2 for items 2..5 with
the string referenced at A5-0x5e06, and items 11/13 with A5-0x5e0a. These
globals are string pointers, not handler pointers. Saved runtime strings are
`?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ` and `0123456789`,
respectively, recorded in `word-list-allowed-characters.json`.

A5+0x0cd2 maps to CODE 48+0x0138..0x0182. It reads the current field using
the reader above, calls A5+0x0632 with source and destination both pointing
to its local 256-byte buffer, and supplies the allowed-character string.
If the result is nonzero, it calls SysBeep (A9C8) with 15 and then its local
field-writing routine at +0x02aa with the filtered buffer.

The filter resolves to CODE 9+0x0ca2..0x0d14. It clears a 512-byte word
lookup table, marks allowed characters, copies accepted bytes forward and
returns a changed flag. `text_filter.c` reconstructs the ASCII path. This
explains how an `x` can be removed before the numeric parser, consistent with
the observed empty input. A direct filter-call trace is still needed to tie
the live event sequence to this static call chain.

The original uses EXT.W after loading each byte for a table index. High-bit
bytes therefore index before the table; their behavior depends on surrounding
stack memory. The reconstruction explicitly contracts to ASCII rather than
claiming safe high-bit filtering is equivalent. Tests cover every nonzero
ASCII byte, exact in-place operation, empty strings and the changed flag.

`dialog_text_filter.c` now reconstructs the CODE 48 wrapper with explicit
Toolbox adapters. It uses the actual reconstructed filter and calls beep(15)
before rewriting only when text changed. Host tests verify operation order,
unchanged and empty fields, complete removal, and partial removal. These are
static contracts, not captured live Toolbox effects.

The local rewrite at CODE 48+0x02aa first calls the field setter A5+0x063a,
then unconditionally invokes +0x01a6. That refresh fetches the item handle,
deactivates TextEdit, installs the handle at TERec+0x3e and its size at +0x3c,
copies the item rectangle into the destination/view rectangles, recalculates
and activates TextEdit, redraws in the dialog port, restores the previous
port, and stores item-minus-one at dialog+0xa4. Selection preservation has
not been established; the adapter must not be described as a mere string
assignment or as verified cursor preservation.

## Field setter and C-to-Pascal conversion

A5+0x063a resolves to CODE 9+0x0d86..0x0dea. After GetDItem and the same
null-handle Debugger call, it invokes A5+0x07da on a local 256-byte buffer.
That helper is CODE 23+0x00bc..0x00e0: sprintf(destination+1, format, source),
then store the low byte of the return value in destination[0]. The saved
runtime format at A5-0x0bc4 is `%s`, with no precision or size bound.
`maven_c_to_pascal` reconstructs the valid, nonoverlapping short-string case;
it includes the trailing NUL produced by sprintf. It is not a reconstruction
of all sprintf behavior or inputs exceeding the Pascal length domain.

The setter calls SetIText (A98F), then SelIText (A97E) with the converted
length as both selection endpoints. Both loads sign-extend the length byte,
so lengths >=128 become negative selection words; their Toolbox interpretation
is not yet established. It sets the dialog port and invalidates the item
rectangle. The preceding claim of no established selection preservation
stands: this path explicitly requests a collapsed selection, not restoration
of the earlier range.

The sprintf helper writes length+2 bytes in total. A 255-character source
would exceed the setter's 256-byte local buffer by one byte. No runtime test
of that boundary has been performed, and no protective truncation is invented
in the reconstruction. Normal Word List input limits still need auditing.

## Event ordering

CODE 12+0x0686..0x06f6 first calls the general text-event routine at
A5+0x0d0a, then filters items 2, 3, 4, 5, 11 and 13 in that order.
`maven_word_list_text_event` now reconstructs that orchestration with the
event dispatcher external and the actual reconstructed filter wrapper.
All six fields are inspected after dispatch; rewriting remains conditional
on each field's changed flag. Tests check dispatch-before-read and item order.

The dispatcher maps to CODE 48+0x0376..0x0446. It reads the low byte of the
event message at event+5. Return/Enter can activate the dialog's default item
at +0xa8; Tab scans for an editable item and switches TextEdit focus; other
characters reach the helper at A5+0x05fa when an edit field is active.
These branches are statically identified, not yet reconstructed or traced
end to end. In particular, the Tab scan's wrap comparison uses the item-list
header directly and should not be replaced with a guessed host item count.

The dispatcher is now reconstructed in `dialog_key_event.c`; its Toolbox
actions and text-key helper remain adapters. Return (13) and Enter (3) both
activate an existing default control with highlight 10. Without a default,
Enter is ignored while Return can reach text handling. No active edit item
(-1) suppresses ordinary text and Tab. Tab starts at active-index+2, uses
signed word arithmetic and the raw item-list header comparison, skips items
without type bit 16, focuses the selected field and calls the select-all
helper (CODE 17+0x0a0a). It has no original cycle limit. A null item handle
calls Debugger and then continues if the debugger returns.

Instruction-derived tests check these branches and a wrapping Tab scan.
They do not validate the original event loop or Toolbox side effects live.

## Ordinary text and smart quotes

The text-key helper A5+0x05fa resolves to CODE 9+0x046c..0x04f0. It first
calls local +0x04f0; a nonzero result suppresses subsequent editing. It then
suppresses editing for bit 0 of the high modifier byte (EventRecord+14),
or a nonzero explicit flag. Its Tab path deletes and inserts four bytes from
A5-0x0d00 (four spaces in the saved snapshot); Escape deletes; other bytes
pass through the quote converter at +0x0880 and then TEKey. The initial
helper and actual TextEdit effects still need reconstruction and live tracing.

`smart_quotes.c` reconstructs the quote decision: ASCII single/double quote
becomes MacRoman D4/D2 at selection start zero, after whitespace, an opening
bracket `([{<`, byte CA, or the other opening quote in a nested pair.
Otherwise it becomes D5/D3. Nonquote bytes pass through unchanged.
Original instructions read the preceding byte before testing selection start
zero; the pure decision interface does not reproduce that out-of-buffer
read and does not claim equivalent fault behavior. Tests cover all preceding
byte values and both nested quote cases. No natural quote-call trace yet.

`text_key.c` now reconstructs +0x046c..0x04f0 with explicit navigation,
quote-conversion and Toolbox adapters. Navigation runs before modifier and
suppression checks. A handled navigation event returns zero from this wrapper;
successful insertion/deletion returns one. Converted bytes are sign-extended
to the TEKey word argument. Host tests verify this order and return behavior.
The navigation helper at +0x04f0 handles left/right character codes 28/29 and
tests modifier bits 9, 8 and 11 for selection variants. Its full word-boundary
and selection behavior remains to be reconstructed and observed live.

## Word-boundary predicate

CODE 9+0x0742..0x0880 returns a Pascal Boolean indicating a separator.
The decision is reconstructed in `word_boundary.c`. Letters/digits (class
mask D0), bytes CA/A2/A3/B4, dollar, percent and hyphen are nonseparators.
Comma is a nonseparator only between digits with index >0; period requires
only a following digit. ASCII apostrophe and D5 require alphanumeric bytes
on both sides and index >0. Other bytes are separators.

Before classification, the original compares the signed index with the
GetPtrSize result (A5+0x0b02, CODE 34+0x01a4, A021). Equality returns false,
even for a separator character. This is allocation size, not text length.
It already loaded the current byte before making that comparison; some
branches also read adjacent bytes without validating their bounds. The pure
predicate accepts those byte values explicitly and does not claim equivalent
memory-fault behavior. Host tests cover punctuation contexts and the equality
override. Natural Option-arrow traces remain pending.

The surrounding CODE 9+0x03fe..0x046c loop is reconstructed in
`word_navigation.c`. It locks text, moves one signed-word step before testing,
and scans while the index is strictly between zero and text length. A
nonseparator followed in the scan direction by a separator stops the scan
at the nonseparator. The second predicate call is skipped when the first
already reports a separator. Text is unlocked before returning; only negative
results are clamped to zero, with no upper clamp. Tests preserve exact
predicate-call order and exercise both endpoints. Locking and guest byte
access remain adapters; this is not yet a live navigation comparison.

`arrow_navigation.c` reconstructs the surrounding left/right modifier paths
at +0x04f0..0x0742. Command takes precedence over Option, including when
Shift is present. Plain and Command arrows adjust selection but return zero,
so the outer text-key path may continue; Shift/Option variants return one.
Selection callbacks must update the state observed by subsequent getters.
The Shift-Option paths can make two sequential selection changes and retain
the original nested locking calls. The helper at +0x022e executes HLock and
dereferences the handle; subsequent HUnlock calls do not restore prior lock
state. Tests check modifier precedence and sequential selection updates;
actual TextEdit normalization, nested Memory Manager effects and live arrow
traces remain unverified.
