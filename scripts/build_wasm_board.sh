#!/bin/sh
set -eu
compiler=${MAVEN_WASM_CLANG:-/opt/homebrew/opt/llvm@18/bin/clang}
mkdir -p .build
"$compiler" --target=wasm32 -O2 -ffreestanding -fno-builtin -nostdlib \
 -Wall -Wextra -Werror -Iscripts/wasm_include -Ireconstruction \
 scripts/wasm_board.c reconstruction/apply_move.c reconstruction/score_move.c \
 reconstruction/score_accumulate.c reconstruction/place_letters.c \
 reconstruction/move_finalize.c reconstruction/board_state.c \
 reconstruction/rack_counts.c reconstruction/undo_move.c \
 -Wl,--no-entry -Wl,--export-memory -Wl,--export=maven_board_buffer \
 -Wl,--export=maven_board_reset -Wl,--export=maven_board_score \
 -Wl,--export=maven_board_prepare_counts -Wl,--export=maven_board_apply \
 -Wl,--export=maven_board_set_counter -Wl,--export=maven_board_undo \
 -Wl,--export=maven_board_result -Wl,-z,stack-size=1048576 \
 -o .build/maven-board.wasm
