#!/bin/bash

set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "${SCRIPT_DIR}"

# Test mermaid-cli
echo "[mermaid-cli] Generating SVG image from test/mermaid_001.mmd ..."
mmdc -i test/mermaid_001.mmd --puppeteerConfigFile /home/vscode/puppeteer-config.json
echo "[mermaid-cli] Generated: test/mermaid_001.mmd.svg"
echo "[mermaid-cli] Please open the SVG file in a viewer to verify it renders correctly."

# Test Swift (interpreter)
echo "[swift] Running test/main.swift (interpreter) ..."
swift test/main.swift
echo "[swift] Completed successfully."

# Test Swift (compiler)
echo "[swiftc] Compiling test/main.swift ..."
mkdir -p ./bin
swiftc test/main.swift -o ./bin/main
echo "[swiftc] Running ./bin/main ..."
./bin/main
echo "[swiftc] Completed successfully."
