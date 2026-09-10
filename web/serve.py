#!/usr/bin/env python3
"""Serve the web app with cross-origin isolation headers so the worker can use
SharedArrayBuffer for cooperative cancellation of searches and simulations.
Usage: python3 web/serve.py [port]  (serves the web/ directory)."""
import http.server, os, sys
os.chdir(os.path.dirname(os.path.abspath(__file__)))
class Handler(http.server.SimpleHTTPRequestHandler):
    extensions_map = {**http.server.SimpleHTTPRequestHandler.extensions_map, '.wasm': 'application/wasm', '.mjs': 'text/javascript', '.js': 'text/javascript', '.dawg': 'application/octet-stream'}
    def end_headers(self):
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        self.send_header('Cache-Control', 'no-cache')
        super().end_headers()
    def log_message(self, *a): pass
port = int(sys.argv[1]) if len(sys.argv) > 1 else 8765
print(f'Maven: http://localhost:{port}/')
http.server.ThreadingHTTPServer(('0.0.0.0', port), Handler).serve_forever()
