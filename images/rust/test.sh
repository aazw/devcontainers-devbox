#!/bin/bash

set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "${SCRIPT_DIR}"

# Test mermaid-cli
echo "[mermaid-cli] Generating SVG image from test/mermaid_001.mmd ..."
mmdc -i test/mermaid_001.mmd --puppeteerConfigFile /home/vscode/puppeteer-config.json
echo "[mermaid-cli] Generated: test/mermaid_001.mmd.svg"
echo "[mermaid-cli] Please open the SVG file in a viewer to verify it renders correctly."

# Test Rust
echo "[rust] Compiling test/main.rs ..."
mkdir -p ./bin
rustc -o ./bin/main test/main.rs
chmod +x ./bin/main
echo "[rust] Running ./bin/main ..."
./bin/main
echo "[rust] Completed successfully."
