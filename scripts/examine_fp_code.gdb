set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== Examining FP code at 0x18316 ===\n"
x/20i 0x18300

printf "\n=== Examining FP code at 0x9010e ===\n"
x/20i 0x90100

printf "\n=== Examining FP code at 0x90158 ===\n"
x/20i 0x90148

printf "\n=== Setting breakpoint on first FP location ===\n"
break *0x18316
printf "Breakpoint set at 0x18316\n"

printf "\n=== Current register state ===\n"
info reg

detach
quit
