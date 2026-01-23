set architecture m68k
target remote localhost:1234
set pagination off

printf "=== Dumping Maven evaluation functions ===\n"

# Main evaluation functions
dump binary memory /tmp/maven_eval1.bin 0x07c8bd84 0x07c8c100
dump binary memory /tmp/maven_eval2.bin 0x07c8d1e4 0x07c8d400
dump binary memory /tmp/maven_eval3.bin 0x07c979f4 0x07c97b00

printf "Dumped evaluation functions to /tmp/maven_eval*.bin\n"

# Also get some context - what calls these functions?
printf "\n=== Disassembling main eval function at 0x07c8bd84 ===\n"
x/80i 0x07c8bd84

printf "\n=== Disassembling eval function at 0x07c8be8c ===\n"
x/100i 0x07c8be8c

detach
quit
