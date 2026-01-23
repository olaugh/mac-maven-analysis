set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== Examining potential game state at 0xb6bc ===\n"
x/64xb 0xb6a0

printf "\nAs words:\n"
x/32xh 0xb6a0

printf "\n=== Examining 0x37d00 area (score patterns) ===\n"
x/64xb 0x37d00

printf "\n=== Setting up to catch SANE calls ===\n"
printf "To catch evaluation, we'll break on FP68K trap\n"
printf "Breakpoint at first SANE call location (0x18316):\n"
break *0x18316

printf "\n=== Now you can click 'Play' to trigger move generation ===\n"
printf "The breakpoint will catch SANE floating-point operations\n"

detach
quit
