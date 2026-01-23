set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== Searching for both scores near each other ===\n"
printf "Looking for John=21 and Maven=100 stored together\n\n"

# Dump a larger region of application heap to file for analysis
printf "Dumping application heap 0x1000-0x60000 to file...\n"
dump binary memory /tmp/heap_dump.bin 0x1000 0x60000

printf "\n=== Checking around A5 (application globals) ===\n"
printf "A5 register:\n"
info reg a5

printf "\nDumping globals area (A5-based):\n"
x/64xw $a5-256

printf "\n=== Looking at locations where 0x15 was found ===\n"
printf "\n0xe159:\n"
x/16xb 0xe150

printf "\n0x1e9d2:\n"
x/16xb 0x1e9c8

printf "\n0x37d41:\n"
x/16xb 0x37d38

detach
quit
