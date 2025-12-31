#!/bin/bash

set -euo pipefail

# このスクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 使用方法を表示
if [ $# -eq 0 ]; then
  echo "Usage: $0 <devbox.json1> <devbox.json2> ..."
  echo ""
  echo "Merges multiple devbox.json files and outputs the result to stdout."
  echo ""
  echo "Example:"
  echo "  $0 images/go/devbox.json images/js/devbox.json > images/go-js/devbox.json"
  exit 1
fi

# 依存関係をインストール（まだインストールされていない場合）
if [ ! -d "${SCRIPT_DIR}/node_modules" ]; then
  echo "Installing dependencies..." >&2
  (cd "${SCRIPT_DIR}" && npm install --silent)
fi

# Node.jsスクリプトを実行してdevbox.jsonをマージ
# エラーメッセージは stderr に、結果は stdout に出力
node "${SCRIPT_DIR}/merge_devbox.js" "$@"
