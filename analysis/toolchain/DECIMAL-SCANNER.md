# Single decimal conversion reconstruction

`reconstruction/decimal_scan.c` specializes the original scanner for the
single `%d` format observed in Word List length controls. It does not replace
the full scanner, its stream implementation, floating-point formats or other
conversion flags. The interface takes the original character-class table and
an explicit 16-bit errno word rather than using host libc behavior.

CODE 24 instruction evidence (resource offsets include the header):

- +0x0f7c clears the long accumulator. +0x0fb0..0x0fbe tests class bits 1/2
  to skip whitespace. +0x0fc8 supplies default field width 32767.
- +0x1000 handles an optional sign; +0x101e handles leading zero;
  +0x1078..0x10ba converts and checks digits against the selected base.
- +0x10be..0x10d6 performs two unsigned word multiplies, detects upper-product
  overflow and carry, and sets a sticky overflow flag. When the upper product
  overflows, the accumulator is left unchanged for that digit. The portable
  reconstruction retains this detail.
- +0x11da..0x120e applies sign and signed-long checks. The unmodified `%d`
  branch +0x1256..0x1282 checks that the result fits a signed word.
- +0x1282..0x12d8 saturates overflow to the signed-word endpoint selected by
  the input sign and writes 34 to A5-0x0bc0. Nonoverflow leaves errno unchanged.
- +0x135c stores a word; +0x1378..0x138c returns EOF when no conversion
  succeeded and the last input was EOF, otherwise the assignment count.

The recovered THINK C 6.0.1 `scanf.c` agrees with these paths, including its
inline multiplication assembly and saturation. This is additional runtime
source correspondence, not proof of a uniquely identified compiler release.
The source hash is recorded in `word-length-controls.json`.

Host tests cover signed-word endpoints, 32-bit accumulation overflow, very
long input, sign-only EOF, invalid input, trailing characters, non-ASCII input,
and the 32767-character field width. All 19 focused tests pass. These tests
are instruction-derived. Natural original-runtime comparisons now supplement
them: `capture_length_controls.py` observed six calls across three UI queries,
checking complete loaded CODE 12 and CODE 24 identities before reporting.
Return values, assigned words and errno match the compiled reconstruction in
all six calls. The final caller limits also match in all three queries.

Actual captured inputs were `2` / `15`, `32768` / empty, and `2068` / `3`.
Overflow assigned 32767 and set errno to 34. Empty input returned -1 without
changing the preset 15 or clearing errno. Later successful conversions kept
errno at 34. Both inverted intervals ended with maximum 15 while retaining
their larger minimum. The intended edit to 20 left trailing digits in the
small scrolling field; 2068 is the authoritative captured input. An attempted
`x` did not reach the parser, so this run does not prove nonempty invalid-input
behavior. Evidence is indexed in `length-controls-live-summary.json`.

The disposable VM was terminated after saving the captures. Negative inputs,
nonempty malformed inputs, the long field-width boundary and the other scanf
formats remain outside the natural-runtime coverage.

The length-control reconstruction now invokes `maven_scan_decimal_word`
directly. Only field extraction remains an adapter; the character table and
errno word are explicit application state. The integrated replay test feeds
the three captured pairs of field strings through both compiled modules and
checks final limits and errno against the original observations. This replaces
the former synthetic scanner callback test. All 19 focused tests pass.
