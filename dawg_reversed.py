#!/usr/bin/env python3
"""
Test hypothesis: Maven's DAWG stores words in REVERSE order.

This would be like a suffix tree where:
- The letter index represents the LAST letter of words
- Children represent preceding letters
- Words are built by prepending letters

This is useful for Scrabble move generation (finding words ending with specific letters).
"""
import struct

def read_file(filepath):
    with open(filepath, 'rb') as f:
        return f.read()

def get_node(data, offset):
    if offset >= len(data) - 4:
        return None
    b0, b1, b2, b3 = data[offset:offset+4]
    if not (97 <= b3 <= 122 or b3 == 63):
        return None
    return {
        'ptr': (b0 << 8) | b1,
        'flags': b2,
        'letter': chr(b3),
        'eow': (b2 & 0x01) != 0,  # End of word (or actually: valid word ending here)
        'last': (b2 & 0x02) != 0,
        'offset': offset
    }

def traverse_reversed_dawg(data, dawg_base=0x400, max_words=10000):
    """
    Traverse DAWG assuming reversed storage.
    Build words by prepending letters.
    """
    words = []

    def get_siblings(ptr):
        """Get all siblings starting at given pointer"""
        if ptr == 0:
            return []
        offset = dawg_base + ptr * 4
        siblings = []
        seen = set()
        while offset not in seen:
            seen.add(offset)
            node = get_node(data, offset)
            if node is None:
                break
            siblings.append(node)
            if node['last']:
                break
            offset += 4
        return siblings

    def dfs(ptr, suffix, depth=0):
        """DFS building words by prepending letters"""
        if depth > 20 or len(words) >= max_words:
            return

        siblings = get_siblings(ptr)

        for node in siblings:
            if len(words) >= max_words:
                return

            # Prepend this letter to the suffix
            word_so_far = node['letter'] + suffix

            # If this is a valid word ending, record it
            if node['eow']:
                words.append(word_so_far)

            # Recurse into children (which are preceding letters)
            if node['ptr'] > 0:
                dfs(node['ptr'], word_so_far, depth + 1)

    # Each index entry represents words ENDING with that letter
    for i in range(26):
        if len(words) >= max_words:
            break
        idx_offset = 0x10 + i * 4
        b0, b1, b2, b3 = data[idx_offset:idx_offset+4]
        root_ptr = (b0 << 8) | b1
        last_letter = chr(ord('a') + i)

        if root_ptr > 0:
            dfs(root_ptr, last_letter, 0)

    return words

def main():
    filepath = "/Volumes/T7/retrogames/oldmac/share/maven2"
    data = read_file(filepath)

    print("Testing REVERSED DAWG interpretation")
    print("=" * 50)

    words = traverse_reversed_dawg(data, max_words=5000)
    words = sorted(set(words))

    print(f"Extracted {len(words)} unique words")

    # Show 2-letter words
    two_letter = sorted([w for w in words if len(w) == 2])
    print(f"\n2-letter words ({len(two_letter)}):")
    print(two_letter[:50])

    # Expected 2-letter Scrabble words
    expected_2 = ['aa', 'ab', 'ad', 'ae', 'ag', 'ah', 'ai', 'al', 'am', 'an',
                  'ar', 'as', 'at', 'aw', 'ax', 'ay', 'ba', 'be', 'bi', 'bo',
                  'by', 'de', 'do', 'ed', 'ef', 'eh', 'el', 'em', 'en', 'er',
                  'es', 'et', 'ex', 'fa', 'go', 'ha', 'he', 'hi', 'hm', 'ho',
                  'id', 'if', 'in', 'is', 'it', 'jo', 'ka', 'ki', 'la', 'li',
                  'lo', 'ma', 'me', 'mi', 'mm', 'mo', 'mu', 'my', 'na', 'ne',
                  'no', 'nu', 'od', 'oe', 'of', 'oh', 'oi', 'om', 'on', 'op',
                  'or', 'os', 'ow', 'ox', 'oy', 'pa', 'pe', 'pi', 'qi', 're',
                  'sh', 'si', 'so', 'ta', 'ti', 'to', 'uh', 'um', 'un', 'up',
                  'us', 'ut', 'we', 'wo', 'xi', 'xu', 'ya', 'ye', 'yo', 'za']

    found_expected = [w for w in two_letter if w in expected_2]
    print(f"\nMatching expected 2-letter words ({len(found_expected)}/{len(expected_2)}):")
    print(found_expected[:30])

    # Show some 3-letter words
    three_letter = sorted([w for w in words if len(w) == 3])
    print(f"\n3-letter words ({len(three_letter)}):")
    print(three_letter[:30])

    # Check for common words
    test_words = ['cat', 'dog', 'the', 'and', 'for', 'are', 'was', 'all',
                  'can', 'had', 'her', 'one', 'our', 'out', 'day', 'get',
                  'has', 'him', 'his', 'how', 'its', 'may', 'new', 'now',
                  'old', 'see', 'way', 'who', 'boy', 'did', 'own', 'say',
                  'she', 'too', 'use', 'zax', 'qi', 'qat', 'suq']
    found_test = [w for w in test_words if w in words]
    print(f"\nFound common words ({len(found_test)}/{len(test_words)}):")
    print(found_test)

    if len(found_expected) > 30:
        output_path = "/Volumes/T7/retrogames/oldmac/maven_re/wordlist_reversed.txt"
        with open(output_path, 'w') as f:
            for word in words:
                f.write(word + '\n')
        print(f"\nSaved {len(words)} words to {output_path}")

if __name__ == "__main__":
    main()
