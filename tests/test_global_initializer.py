"""Compile the reconstructed loader and exercise serialization edge cases."""
import ctypes
from pathlib import Path
import subprocess
import tempfile
import unittest


class GlobalInitializerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temp = tempfile.TemporaryDirectory()
        source = Path(__file__).resolve().parents[1] / 'reconstruction/global_initializer.c'
        library = Path(cls.temp.name) / 'loader.dylib'
        subprocess.run(['cc', '-Wall', '-Wextra', '-Werror', '-dynamiclib',
                        str(source), '-o', str(library)], check=True)
        cls.library = ctypes.CDLL(str(library))
        cls.function = cls.library.maven_initialize_globals
        cls.function.argtypes = [ctypes.c_void_p, ctypes.c_size_t,
                                ctypes.c_void_p, ctypes.c_size_t,
                                ctypes.c_void_p, ctypes.c_size_t,
                                ctypes.c_void_p, ctypes.c_size_t, ctypes.c_uint32]
        cls.function.restype = ctypes.c_int

    @classmethod
    def tearDownClass(cls):
        cls.temp.cleanup()

    def load(self, size, data, zero=b'', reloc=b'', a5=0):
        dest = ctypes.create_string_buffer(b'\xcc' * size, size)
        result = self.function(dest, size, data, len(data), zero, len(zero),
                               reloc, len(reloc), a5)
        return result, dest.raw

    def test_actual_probe_layout(self):
        data = bytes.fromhex('12345678000100030000')
        self.assertEqual(self.load(22, data, bytes.fromhex('000c')),
                         (0, data[:8] + bytes(14)))

    def test_zero_marker_still_writes_two_bytes_with_zero_run(self):
        self.assertEqual(self.load(6, bytes.fromhex('123400005678'), b'\0\0'),
                         (0, bytes.fromhex('123400005678')))

    def test_signed_offset_and_32bit_wrap(self):
        self.assertEqual(self.load(4, bytes.fromhex('fffffff0'), reloc=b'\xff\xfc', a5=0x20),
                         (0, bytes.fromhex('00000010')))

    def test_missing_run_data_is_rejected(self):
        self.assertEqual(self.load(4, b'\0\0')[0], -1)

    def test_run_cannot_overwrite_buffer(self):
        self.assertEqual(self.load(4, b'\0\0', b'\0\x03')[0], -1)

    def test_relocation_cannot_escape_buffer(self):
        self.assertEqual(self.load(4, bytes.fromhex('12345678'), reloc=b'\0\0')[0], -1)


if __name__ == '__main__':
    unittest.main()
