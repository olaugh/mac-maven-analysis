#!/usr/bin/env python3
"""
Analyze the actual file format vs runtime format.
"""

import struct

NODE_START = 0x410

def main():
    with open("/Volumes/T7/retrogames/oldmac/share/maven2", 'rb') as f:
        data = f.read()

    section1_end = struct.unpack('>I', data[0:4])[0]
    print(f"Section 1 ends at entry {section1_end}")

    # Look at letter index
    print("\n" + "="*60)
    print("Letter Index Analysis")
    print("="*60)

    for i in range(26):
        offset = 0x10 + i * 4
        b0, b1, b2, b3 = data[offset:offset+4]
        letter = chr(ord('a') + i)

        # Original interpretation
        ptr = (b0 << 8) | b1
        flags = b2
        stored_letter = chr(b3) if 97 <= b3 <= 122 else f'0x{b3:02x}'

        # Runtime interpretation (if we treat it as 32-bit big-endian)
        entry_32 = struct.unpack('>I', data[offset:offset+4])[0]
        runtime_letter = chr(entry_32 & 0xFF) if 97 <= (entry_32 & 0xFF) <= 122 else '?'
        runtime_is_word = (entry_32 >> 8) & 1
        runtime_is_last = (entry_32 >> 9) & 1
        runtime_child = entry_32 >> 10

        print(f"\n{letter}: bytes=[{b0:02x} {b1:02x} {b2:02x} {b3:02x}]")
        print(f"   Original: ptr={ptr}, flags={b2:02x} ({b2:08b}), letter={stored_letter}")
        print(f"   Runtime:  entry={entry_32:08x}, letter={runtime_letter}, is_word={runtime_is_word}, is_last={runtime_is_last}, child={runtime_child}")

        # What's the actual interpretation?
        # The letter_index seems to have different structure than node entries

    # Now look at actual node entries
    print("\n" + "="*60)
    print("First few node entries (starting at offset 0x410)")
    print("="*60)

    for entry_idx in range(10):
        offset = NODE_START + entry_idx * 4
        b0, b1, b2, b3 = data[offset:offset+4]

        # As 32-bit big-endian
        entry_32 = struct.unpack('>I', data[offset:offset+4])[0]

        print(f"\nEntry {entry_idx}: bytes=[{b0:02x} {b1:02x} {b2:02x} {b3:02x}]")

        # Original interpretation (my file parser)
        ptr = (b0 << 8) | b1
        flags = b2
        letter = chr(b3) if 97 <= b3 <= 122 else f'0x{b3:02x}'
        orig_is_word = (flags >> 7) & 1  # bit 7
        orig_is_last = flags & 1          # bit 0
        orig_child = ptr + (flags & 0x7e)
        print(f"   Original: ptr={ptr}, flags={flags:02x}, letter={letter}")
        print(f"             is_word={orig_is_word}, is_last={orig_is_last}, child={orig_child}")

        # Runtime interpretation
        rt_letter = chr(entry_32 & 0xFF) if 97 <= (entry_32 & 0xFF) <= 122 else '?'
        rt_is_word = (entry_32 >> 8) & 1  # bit 8
        rt_is_last = (entry_32 >> 9) & 1  # bit 9
        rt_child = entry_32 >> 10
        print(f"   Runtime:  letter={rt_letter}, is_word={rt_is_word}, is_last={rt_is_last}, child={rt_child}")

    # Check a known entry - let's look at entry 472 (the 'a' in 'c' range)
    print("\n" + "="*60)
    print("Entry 472 ('a' in 'c' range) - should have is_word=False")
    print("="*60)

    offset = NODE_START + 472 * 4
    b0, b1, b2, b3 = data[offset:offset+4]
    entry_32 = struct.unpack('>I', data[offset:offset+4])[0]

    print(f"bytes=[{b0:02x} {b1:02x} {b2:02x} {b3:02x}]")

    ptr = (b0 << 8) | b1
    flags = b2
    letter = chr(b3) if 97 <= b3 <= 122 else f'0x{b3:02x}'
    orig_is_word = (flags >> 7) & 1
    orig_is_last = flags & 1
    orig_child = ptr + (flags & 0x7e)
    print(f"Original: ptr={ptr}, flags={flags:02x} ({flags:08b}), letter={letter}")
    print(f"          is_word={orig_is_word}, is_last={orig_is_last}, child={orig_child}")

    rt_letter = chr(entry_32 & 0xFF) if 97 <= (entry_32 & 0xFF) <= 122 else '?'
    rt_is_word = (entry_32 >> 8) & 1
    rt_is_last = (entry_32 >> 9) & 1
    rt_child = entry_32 >> 10
    print(f"Runtime:  letter={rt_letter}, is_word={rt_is_word}, is_last={rt_is_last}, child={rt_child}")

    # Check entry 106 ('c' with is_word=True supposedly)
    print("\n" + "="*60)
    print("Entry 106 ('c' with is_word=True supposedly)")
    print("="*60)

    offset = NODE_START + 106 * 4
    b0, b1, b2, b3 = data[offset:offset+4]
    entry_32 = struct.unpack('>I', data[offset:offset+4])[0]

    print(f"bytes=[{b0:02x} {b1:02x} {b2:02x} {b3:02x}]")

    ptr = (b0 << 8) | b1
    flags = b2
    letter = chr(b3) if 97 <= b3 <= 122 else f'0x{b3:02x}'
    orig_is_word = (flags >> 7) & 1
    orig_is_last = flags & 1
    orig_child = ptr + (flags & 0x7e)
    print(f"Original: ptr={ptr}, flags={flags:02x} ({flags:08b}), letter={letter}")
    print(f"          is_word={orig_is_word}, is_last={orig_is_last}, child={orig_child}")

    rt_letter = chr(entry_32 & 0xFF) if 97 <= (entry_32 & 0xFF) <= 122 else '?'
    rt_is_word = (entry_32 >> 8) & 1
    rt_is_last = (entry_32 >> 9) & 1
    rt_child = entry_32 >> 10
    print(f"Runtime:  letter={rt_letter}, is_word={rt_is_word}, is_last={rt_is_last}, child={rt_child}")


if __name__ == "__main__":
    main()
