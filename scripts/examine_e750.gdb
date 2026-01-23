set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== Examining 0xe740-0xe800 area in detail ===\n"
printf "\nThis area has repeated 64/15 patterns:\n"
x/64xb 0xe740

printf "\nAs 16-bit words:\n"
x/32xh 0xe740

printf "\nAs 32-bit words:\n"
x/16xw 0xe740

printf "\n=== Wider context 0xe700-0xe800 ===\n"
x/64xw 0xe700

detach
quit
