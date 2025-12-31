#!/bin/bash

set -euo pipefail

# このスクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# 出力ファイル
OUTPUT_FILE="${SCRIPT_DIR}/devbox.json"

echo "Merging devbox.json files..."
echo "  - images/go/devbox.json"
echo "  - images/js/devbox.json"
echo "  -> ${OUTPUT_FILE}"

# 汎用スクリプトを呼び出してマージ（相対パスで渡す）
"${PROJECT_ROOT}/utils/generate_devbox/generate_devbox.sh" \
  "images/go/devbox.json" \
  "images/js/devbox.json" \
  > "${OUTPUT_FILE}"

echo "Successfully merged devbox.json files to ${OUTPUT_FILE}"

# jqでバリデーション（存在する場合）
if command -v jq &> /dev/null; then
  echo ""
  echo "Validating with jq..."
  if jq empty "${OUTPUT_FILE}" 2>/dev/null; then
    echo "✓ devbox.json is valid JSON"
  else
    echo "⚠ Warning: devbox.json may have syntax issues (but JSONC comments are expected)"
  fi
fi

echo ""
echo "Done! Generated: ${OUTPUT_FILE}"
