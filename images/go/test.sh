#!/bin/bash

set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "${SCRIPT_DIR}"

# Test mermaid-cli
echo "[mermaid-cli] Generating SVG image from test/mermaid_001.mmd ..."
mmdc -i test/mermaid_001.mmd --puppeteerConfigFile /home/vscode/puppeteer-config.json
echo "[mermaid-cli] Generated: test/mermaid_001.mmd.svg"
echo "[mermaid-cli] Please open the SVG file in a viewer to verify it renders correctly."

# Test Go
echo "[go] Running test/main.go ..."
go run ./test/main.go
echo "[go] Completed successfully."
