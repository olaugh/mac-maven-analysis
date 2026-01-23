set architecture m68k
target remote localhost:1234
set pagination off

# Search for 'ESTR' resource type in memory (0x45535452)
# This would indicate Maven's pattern strings are loaded

echo \n=== Searching for Maven data in memory ===\n

# Dump some memory regions to look for patterns
# Application heap is typically in low memory

echo \nLow memory (potential app heap):\n
x/32xw 0x1000

echo \nChecking A5 world (globals):\n
info reg a5

echo \nReady for interactive inspection.\n
