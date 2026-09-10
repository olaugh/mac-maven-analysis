#!/bin/sh
set -eu
compiler=${MAVEN_WASM_CLANG:-/opt/homebrew/opt/llvm@18/bin/clang}
mkdir -p .build
"$compiler" --target=wasm32 -O2 -ffreestanding -fno-builtin -nostdlib \
 -Wall -Wextra -Werror -Iscripts/wasm_include -Ireconstruction \
 scripts/wasm_query.c reconstruction/dictionary_tables.c \
 reconstruction/query_prepare.c reconstruction/word_enumerator.c reconstruction/dictionary_lookup.c \
 -Wl,--no-entry -Wl,--export-memory -Wl,--export=maven_wasm_data \
 -Wl,--export=maven_wasm_fields -Wl,--export=maven_wasm_output -Wl,--export=maven_wasm_query \
 -Wl,-z,stack-size=1048576 -o .build/maven-query.wasm
