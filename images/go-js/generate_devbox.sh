#!/bin/bash

set -euo pipefail

# このスクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${SCRIPT_DIR}"

# 依存関係をインストール（まだインストールされていない場合）
if [ ! -d "node_modules" ]; then
  echo "Installing dependencies..."
  npm install --silent
fi

# Node.jsスクリプトを実行してdevbox.jsonをマージ
node merge_devbox.js

# jqでバリデーション（存在する場合）
if command -v jq &> /dev/null; then
  echo ""
  echo "Validating with jq..."
  if jq empty devbox.json 2>/dev/null; then
    echo "✓ devbox.json is valid JSON"
  else
    echo "⚠ Warning: devbox.json may have syntax issues (but JSONC comments are expected)"
  fi
fi

echo ""
echo "Done! Generated: ${SCRIPT_DIR}/devbox.json"
