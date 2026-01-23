set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== Looking for score structure around 0x830 ===\n"
printf "\nExpanded view around 0x830 (where we found 0x64=100):\n"
x/64xb 0x800

printf "\nAs 16-bit words:\n"
x/32xh 0x800

printf "\n=== Checking if 21 is stored nearby ===\n"
printf "\nLooking at bytes - 0x15 = 21:\n"
x/128xb 0x800

printf "\n=== Examining 0x37d00 area more closely ===\n"
printf "\nThis area had 0x64 and 0x15 in patterns:\n"
x/32xw 0x37d00

printf "\n=== Checking common Mac low memory globals ===\n"
printf "\nApplZone (0x2AA):\n"
x/1xw 0x2AA

printf "\nHeapEnd (0x114):\n"
x/1xw 0x114

printf "\nCurrentA5 (0x904):\n"
x/1xw 0x904

detach
quit
