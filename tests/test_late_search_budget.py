"""Static arithmetic boundaries for the CPU workload gate; no guest acceptance."""
import ctypes as C
from pathlib import Path
import subprocess
import tempfile
import unittest
ROOT = Path(__file__).resolve().parents[1]


class LateBudgetTests(unittest.TestCase):
    def test_blank_groups_unsigned_division_and_threshold(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / 'gate.dylib'
            subprocess.run(['cc', '-shared', '-fPIC', '-std=c99', '-Wall', '-Wextra',
                            '-Werror', str(ROOT / 'reconstruction/late_search_budget.c'),
                            '-o', str(path)], check=True)
            lib = C.CDLL(str(path))
            lib.maven_late_workload_row.argtypes = [C.c_uint, C.c_uint]
            lib.maven_late_estimated_work.argtypes = [C.c_void_p, C.c_uint, C.c_uint,
                                                     C.c_uint, C.c_uint32]
            lib.maven_late_estimated_work.restype = C.c_uint32
            lib.maven_late_estimate_exceeds_budget.argtypes = [C.c_uint32]
            groups = [(0, 0), (0, 1), (0, 2), (1, 0), (1, 1), (2, 0)]
            table = ((C.c_uint16 * 9) * 6)()
            for row, (own, unseen) in enumerate(groups):
                self.assertEqual(lib.maven_late_workload_row(own, unseen), row)
                for column in range(9):
                    table[row][column] = 100 * row + column
                    self.assertEqual(lib.maven_late_estimated_work(
                        table, own, unseen, column + 8, 8224), 100 * row + column)
            for estimate, expected in [(1699, 0), (1700, 0), (1701, 1), (0xffffffff, 1)]:
                self.assertEqual(lib.maven_late_estimate_exceeds_budget(estimate), expected)
            table[0][0] = 0xffff
            self.assertEqual(lib.maven_late_estimated_work(table, 0, 0, 8, 1), 4294959072)
            table[0][0] = 1701
            self.assertEqual(lib.maven_late_estimated_work(table, 0, 0, 8, 8225), 1700)
