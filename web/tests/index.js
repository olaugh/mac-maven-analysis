// Node's test runner treats a directory argument (`node --test web/tests/`)
// as a module path, which resolves to this file. Import every *.test.mjs
// in this directory so that command runs the whole suite;
// `node --test 'web/tests/*.test.mjs'` works as well.
const fs = require('node:fs');
const path = require('node:path');
for (const f of fs.readdirSync(__dirname).sort()) {
  if (f.endsWith('.test.mjs')) import(path.join(__dirname, f));
}
