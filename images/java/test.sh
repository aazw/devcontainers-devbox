#!/bin/bash

set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "${SCRIPT_DIR}"

# Test mermaid-cli
echo "[mermaid-cli] Generating SVG image from test/mermaid_001.mmd ..."
mmdc -i test/mermaid_001.mmd --puppeteerConfigFile /home/vscode/puppeteer-config.json
echo "[mermaid-cli] Generated: test/mermaid_001.mmd.svg"
echo "[mermaid-cli] Please open the SVG file in a viewer to verify it renders correctly."

# Test Java
echo "[java] Running test/main.java ..."
java test/main.java
echo "[java] Completed successfully."
