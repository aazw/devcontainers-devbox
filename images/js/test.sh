#!/bin/bash

set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "${SCRIPT_DIR}"

# Test mermaid-cli
echo "[mermaid-cli] Generating SVG image from test/mermaid_001.mmd ..."
mmdc -i test/mermaid_001.mmd --puppeteerConfigFile /home/vscode/puppeteer-config.json
echo "[mermaid-cli] Generated: test/mermaid_001.mmd.svg"
echo "[mermaid-cli] Please open the SVG file in a viewer to verify it renders correctly."

# Test JavaScript
echo "[bun] Running test/index_js.js ..."
bun ./test/index_js.js
echo "[bun] Completed successfully."

# Test TypeScript
echo "[bun] Running test/index_ts.tsx ..."
bun ./test/index_ts.tsx
echo "[bun] Completed successfully."
