set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== Searching for board near score area ===\n"
printf "Looking for 15x15 array of tile values...\n"
printf "Current tiles on board: J,A,T,O,S (JATOS), F,O,R,K (FORK), G,A,L,E,R,E,S (GALERES), V,E,R,T (VERT)\n\n"

# Dump wider area around scores for analysis
printf "Dumping 0xb000-0xc000 for board search:\n"
dump binary memory /tmp/game_state_area.bin 0xb000 0xc000

# Also search for JATOS pattern: J=10, A=1, T=20, O=15, S=19
printf "\nSearching for JATOS (10,1,20,15,19):\n"
find /b 0xb000, 0xd000, 10, 1, 20, 15, 19

printf "\nSearching for VERT (22,5,18,20) - V=22:\n"
find /b 0xb000, 0xd000, 22, 5, 18, 20

printf "\nSearching for any V tile (22) in game area:\n"
find /b 0xb000, 0x20000, 22

detach
quit
