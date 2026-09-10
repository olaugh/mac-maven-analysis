# Natural dictionary setup caller

The first whole-file load during startup returns to CODE 2+0x108, inside
CODE 2 [0xf4,0x18a). The new capture verifies every byte of loaded CODE 2
as well as CODE 47 and the returned data. See whole-file-caller-live.json.
Do not identify this call as CODE 15's EOF-scanning index helper.

The CODE 2 caller installs four A5 globals:

| Global | Source | Captured value |
| --- | --- | --- |
| A5-0x218c | BE32 file+4 | 122166 |
| A5-0x2190 | BE32 file+8 | 145476 |
| A5-0x2194 | allocation+12 | allocation+12 |
| A5-0x2198 | allocation+116+4*first_root | allocation+488780 |

The first table's base is file+12. Its root is at table+4*122166. The second
base is file+488780, and its root is at table+4*145476. The captured root
records are `00a94861` and `00b7cc61`; both have the low byte 'a'. The
original performs these two byte checks and calls the A5+0x1a2 diagnostic
helper on mismatch. The capture followed the normal return with both checks
passing; it did not inject calls, arguments, registers, or data.

The table-base arithmetic is explicit in CODE 2+0x14c..0x156, including the
constant 0x74 (116). Do not replace this with a guessed scan or a host struct
layout. CODE 15's separate routine searches the end of a file and returns
267671 on the original bytes in host tests, but that result is not used by
this observed startup call.

`dictionary_setup.c` now exposes initialization with the existing whole-file
loader, load-error context, four persistent globals, and a diagnostic callback.
The table-installation replay matches all four captured values and both root
records; see dictionary-setup-replay.json and replay_dictionary_setup.py.
The replay executes the C installation function, while the combined load/setup
entry point's failure transfer and diagnostic behavior have separate host tests.
The original does not validate every header offset before indexing; preserve
the valid-input semantic core while documenting new validation at a port's
input boundary.
