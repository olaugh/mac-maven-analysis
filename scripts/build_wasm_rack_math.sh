#!/bin/sh
set -eu
compiler=${MAVEN_WASM_CLANG:-/opt/homebrew/opt/llvm@18/bin/clang}
mkdir -p .build
"$compiler" --target=wasm32 -O2 -ffreestanding -fno-builtin -nostdlib \
 -Wall -Wextra -Werror -Ireconstruction \
 scripts/wasm_rack_math.c reconstruction/letter_expectation.c reconstruction/rack_composition.c \
 -Wl,--no-entry -Wl,--export-memory -Wl,--export=maven_rack_math_scores \
 -Wl,--export=maven_rack_math_expectation -Wl,--export=maven_rack_math_composition \
 -Wl,-z,stack-size=1048576 -o .build/maven-rack-math.wasm
