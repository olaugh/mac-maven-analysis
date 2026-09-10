#!/bin/sh
set -eu
compiler=${MAVEN_WASM_CLANG:-/opt/homebrew/opt/llvm@18/bin/clang}
mkdir -p .build
"$compiler" --target=wasm32 -O2 -ffreestanding -fno-builtin -nostdlib \
 -Wall -Wextra -Werror -Iscripts/wasm_include -Ireconstruction \
 scripts/wasm_history.c reconstruction/history_records.c reconstruction/history_snapshot.c reconstruction/display_board.c reconstruction/history_playback.c \
 reconstruction/apply_move.c reconstruction/score_move.c reconstruction/score_accumulate.c \
 reconstruction/place_letters.c reconstruction/move_finalize.c reconstruction/board_state.c \
 reconstruction/rack_counts.c reconstruction/rack_refill.c reconstruction/remaining_tiles.c \
 -Wl,--no-entry -Wl,--export-memory -Wl,--export=maven_history_buffer \
 -Wl,--export=maven_history_decode -Wl,--export=maven_history_snapshot \
 -Wl,--export=maven_history_rebuild -Wl,--export=maven_history_count -Wl,--export=maven_history_side \
 -Wl,--export=maven_history_play -Wl,--export=maven_history_set -Wl,--export=maven_history_get \
 -Wl,-z,stack-size=1048576 -o .build/maven-history.wasm
