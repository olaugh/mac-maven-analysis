"""Instruction-derived edge cases; not a substitute for original call traces."""
import ctypes
from pathlib import Path
import struct
import subprocess
import tempfile
import unittest


class Section(ctypes.Structure):
    _fields_=[('records',ctypes.c_void_p),('root_index',ctypes.c_int32)]


class DictionaryLookupTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temp=tempfile.TemporaryDirectory()
        source=Path(__file__).resolve().parents[1]/'reconstruction/dictionary_lookup.c'
        output=Path(cls.temp.name)/'lookup.dylib'
        subprocess.run(['cc','-std=c99','-Wall','-Wextra','-Werror','-dynamiclib',
                        str(source),'-o',str(output)],check=True)
        cls.lib=ctypes.CDLL(str(output))
        cls.lookup=cls.lib.maven_section_contains
        cls.lookup.argtypes=[ctypes.POINTER(Section),ctypes.c_char_p]
        cls.lookup.restype=ctypes.c_uint32
        cls.counted=cls.lib.maven_counted_sections_contain
        cls.counted.argtypes=[ctypes.POINTER(Section),ctypes.c_int16,ctypes.c_char_p]
        cls.terminated=cls.lib.maven_terminated_sections_contain
        cls.terminated.argtypes=[ctypes.POINTER(Section),ctypes.c_char_p]

    @classmethod
    def tearDownClass(cls):
        cls.temp.cleanup()

    def table(self,words,root=0,base_word=0):
        raw=struct.pack('>'+str(len(words))+'I',*words)
        buffer=ctypes.create_string_buffer(raw)
        section=Section(ctypes.addressof(buffer)+base_word*4,root)
        return buffer,section

    def test_terminal_result_is_256(self):
        buffer,section=self.table([0x361])
        self.assertEqual(self.lookup(ctypes.byref(section),b'a'),256)
        self.assertEqual(self.lookup(ctypes.byref(section),b'at'),0)

    def test_sibling_order_is_signed_byte(self):
        buffer,section=self.table([0x80,0x361])
        self.assertEqual(self.lookup(ctypes.byref(section),b'a'),256)

    def test_last_sibling_prevents_advancing(self):
        buffer,section=self.table([0x261,0x362])
        self.assertEqual(self.lookup(ctypes.byref(section),b'b'),0)

    def test_arithmetic_child_shift_can_point_backwards(self):
        buffer,section=self.table([0x374,0xfffffc61],base_word=1)
        self.assertEqual(self.lookup(ctypes.byref(section),b'at'),256)

    def test_counted_and_terminated_wrappers_are_distinct(self):
        buffer,section=self.table([0,0x361],root=1)
        sections=(Section*2)(section,Section(None,0))
        self.assertEqual(self.counted(sections,0,b'a'),0)
        self.assertEqual(self.counted(sections,-1,b'a'),0)
        self.assertEqual(self.counted(sections,1,b'a'),1)
        self.assertEqual(self.terminated(sections,b'a'),1)


if __name__=='__main__':
    unittest.main()
