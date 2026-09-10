"""Regression tests for DeRez ASCII comments truncating CODE resources."""
import tempfile
import unittest
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from extract_resources import parse_rdump


class ResourceExtractionTests(unittest.TestCase):
    def test_ascii_comment_brace_does_not_end_resource(self):
        text = '''data 'CODE' (8) {
            $"49ED D77D" /* I..} */
            $"47ED D89E" /* also { and $"DEAD" */
        };
        data 'STR ' (1, "literal /* name */") { $"0141" };'''
        with tempfile.TemporaryDirectory() as temp:
            p = Path(temp) / 'sample.rdump'
            p.write_text(text)
            result = parse_rdump(p)
        self.assertEqual(result['CODE'][8]['data'], bytes.fromhex('49edd77d47edd89e'))
        self.assertEqual(result['STR '][1]['name'], 'literal /* name */')
        self.assertEqual(result['STR '][1]['data'], b'\x01A')


if __name__ == '__main__':
    unittest.main()
