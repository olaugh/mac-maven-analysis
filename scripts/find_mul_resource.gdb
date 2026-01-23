set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== Searching for 'MUL' resource type in memory ===\n"
printf "MUL in ASCII: 0x4d554c (M=4d, U=55, L=4c)\n"

# Search for 'MUL1', 'MUL2', etc. patterns (4-byte resource types)
find /b 0x1000, 0x100000, 'M', 'U', 'L', '1'
find /b 0x1000, 0x100000, 'M', 'U', 'L', '2'

printf "\n=== Searching for FP68K trap (SANE) usage ===\n"
printf "A9EB is the SANE FP68K trap\n"
find /h 0x1000, 0x100000, (short)0xa9eb

printf "\n=== Looking at CODE segment addresses ===\n"
printf "\nSearching for DAWG/MUL resource patterns:\n"
find /b 0x1000, 0x100000, 'D', 'A', 'W', 'G'
find /b 0x1000, 0x100000, 'E', 'S', 'T', 'R'

detach
quit
