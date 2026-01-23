set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== Searching for tile point values in full memory ===\n"
printf "Pattern: 1,3,3,2,1,4,2,4,1,8,5,1,3,1,1,3,10,1,1,1,1,4,4,8,4,10\n"

# Search the entire addressable memory
printf "\nSearching 0x0 - 0x100000:\n"
find /b 0x0, 0x100000, 1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10

printf "\nSearching 0x100000 - 0x400000:\n"
find /b 0x100000, 0x400000, 1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10

printf "\nSearching 0x400000 - 0x800000:\n"  
find /b 0x400000, 0x800000, 1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10

printf "\n=== Also searching for just J,K values (8,5) ===\n"
find /b 0x0, 0x800000, 8, 5, 1, 3, 1, 1, 3, 10

detach
quit
