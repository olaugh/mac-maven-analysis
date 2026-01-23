set architecture m68k
target remote localhost:1234
set pagination off

printf "\n=== Checking current scores ===\n"
printf "Maven's score at 0xb7b3: "
x/1db 0xb7b3
printf "John's score at 0xb7b2: "
x/1db 0xb7b2

printf "\n=== Setting breakpoint on SANE FP code ===\n"
printf "Will break when floating-point math is performed\n"

# Break on the FP68K trap locations we found earlier
break *0x18316
break *0x9010e

printf "\nBreakpoints set. Now continuing...\n"
printf "Play another move - we'll catch the FP evaluation.\n\n"

continue
