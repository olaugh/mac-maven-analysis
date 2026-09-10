"""Check nested nonlocal transfers without assuming the host's jmp_buf layout."""
from pathlib import Path
import subprocess
import tempfile
import unittest


class ErrorContextTests(unittest.TestCase):
    def test_nested_handlers_pop_before_transfer(self):
        root=Path(__file__).resolve().parents[1]
        source=r'''
#include "error_context.h"
#include <assert.h>
static MavenErrorContext context;
static int first_error, second_error;
static int transfers;
int main(void)
{
    if (MAVEN_SAVE_ERROR_CONTEXT(&context) == 0) {
        assert(context.depth == 1);
        if (MAVEN_SAVE_ERROR_CONTEXT(&context) == 0) {
            assert(context.depth == 2);
            maven_raise_error(&context, &first_error);
            assert(0);
        } else {
            assert(context.depth == 1);
            assert(context.pending_error == &first_error);
            ++transfers;
            maven_raise_error(&context, &second_error);
            assert(0);
        }
    } else {
        assert(context.depth == 0);
        assert(context.pending_error == &second_error);
        ++transfers;
    }
    assert(transfers == 2);
    return 0;
}
'''
        with tempfile.TemporaryDirectory() as temp:
            test=Path(temp)/'test.c';test.write_text(source)
            executable=Path(temp)/'test'
            subprocess.run(['cc','-std=c89','-pedantic','-Wall','-Wextra','-Werror',
                            '-I',str(root/'reconstruction'),str(test),
                            str(root/'reconstruction/error_context.c'),
                            '-o',str(executable)],check=True)
            subprocess.run([str(executable)],check=True)


if __name__=='__main__':
    unittest.main()
