# Original-instruction ↔ C audit

The goal is to account for every original instruction and observable write,
using the existing readable C mappings as the starting point. Matching a few
outputs, or associating a whole resource range with a module, does not establish
that the range's instructions have all been represented.

## Initial inventory

`source-map.json` indexes **33,336 byte-verified disassembly records** from the
35 available corrected listings. **13,127 records** fall inside an existing
source-associated range. The remaining records, missing listings and bytes
outside decoded records need further mapping. These are records, not an exact
instruction coverage count: some directives represent data or traps. Existing
range associations are incomplete and their older validation prose can be stale.
Source and original-resource hashes make later changes detectable.

Rebuild with `python3 analysis/instruction-audit/build_map.py` from the repo root.
The JSON records resource-relative addresses, exact bytes, listing line, candidate
C modules and an explicit association-only status. It does not invent line-level
proof from proximity or similarity.

## First complete routine accounting

[CODE29+0054–00d2](CODE29-REPLY-TIGHTENING.md) maps all **36 decoded instructions**
to the effects in `tighten_replies`. Its called helpers remain explicit audit
boundaries. This routine contains the missing shared-record clear that caused
the VID trailing-byte difference. See the machine-readable companion
`code29-reply-tightening.json` and the original runtime witnesses in
`../toolchain/vid-tail-clear-live.json` and `vid-tail-search-live.json.gz`.

## Required audit record

For each original function/basic block, record:

1. Resource hash, instruction addresses and verified bytes; separate code, tables,
   inline arguments and trap encodings before claiming instruction coverage.
2. C function and exact statements implementing the block, including signedness,
   width, wraparound, flags used by later branches and call/return dependencies.
3. Every read/write: original address or register, width, lifetime, C owner,
   aliases, partial writes and whether initialization actually occurred.
4. Calls intentionally delegated to runtime/Toolbox adapters and their effects.
5. Any omitted optimization with a reason its effects are represented elsewhere.
   Shared writes and inherited registers cannot be dismissed as optimizations.
6. Original debugger evidence and a distinguishing replay/counterexample, including
   reused state. Keep association, static effect audit and runtime acceptance
   as separate statuses.

## Next audit order

- CODE29 reply callbacks and CODE30 final expansion: shared A5-5a32 record,
  full clears versus writes only through NUL, bound scratch and aliases.
- CODE37 row setup and scoring: query buffer A5-6f2, row controls A5-6d2,
  cached multiplier table and inherited A2. POOFIER demonstrates why process
  lifetime belongs in the input contract.
- CODE36 late pool merging and CODE32 masks/leaves: overlapping storage,
  scratch pointers, narrow arithmetic and call ordering.
- Complete the remaining search/simulation/history functions, then UI and
  Toolbox boundaries. Unmapped regions remain visible throughout the audit.

A literal instruction-level C reference can fill ambiguous gaps alongside the
readable implementation. It needs explicit 68K registers, condition codes,
bounded big-endian memory and guest ABI boundaries; translating pointer-looking
expressions into ordinary host pointers would reintroduce undefined behavior.
No complete instruction translator or complete instruction-level C port is
claimed by this initial mapping/audit package.
