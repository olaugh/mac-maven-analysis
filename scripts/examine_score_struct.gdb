set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== FOUND SCORES at 0xb7b2-0xb7b3 ===\n"
printf "0x21 = 33 (John), 0x6c = 108 (Maven)\n\n"

printf "Extended context 0xb780-0xb800:\n"
x/64xb 0xb780

printf "\nAs 32-bit words:\n"
x/32xw 0xb780

printf "\n=== Looking for player names near scores ===\n"
printf "Searching for 'JOHN' or 'MAVE'...\n"

printf "\n0xb700-0xb800 as ASCII where printable:\n"
x/256cb 0xb700

detach
quit
