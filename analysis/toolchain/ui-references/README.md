# Emulator UI references (pixel spec for the browser clone)

Authoritative 640x480 screendumps from the owned QEMU Maven (QMP screendump,
CurrentA5 0x07cf5500), used to make web/ pixel-exact.

- `maven-game-rack-board.png`: a real game — board letters with subscript
  values, the rack (B3 E1 L1 T1 square tiles with a right/bottom drop shadow),
  the score box (MOVER/OPPON with a dotted divider at x~536), the Charcoal menu
  bar, and the unseen-tiles box.
- `maven-kibitzer-list.png`: the populated KIBITZER'S CHOICES list. Row pitch
  12px; the BEST row is inverted (white on black); columns at list-inner
  offsets label 1, word 83 (right-aligned), position 97, score 139 (right),
  leave 145; the leave column is the residual rack letters.

Measured facts now encoded in web/toolbox.js and web/maven_ui.js:
- Tiles are square 26x26 with a 1px black frame and a 1px right/bottom shadow.
- The list has NO vertical column rules (its interior is empty of ink here).
- Rack letters are Geneva 20, board letters Geneva 24, list rows Geneva 9,
  the menu/system font is Charcoal 12.
