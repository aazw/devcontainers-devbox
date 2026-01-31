# Image Development Guide

このドキュメントでは、`images/` ディレクトリ内の各イメージの作成・検証・マージ方法を説明します。

## ディレクトリ構造

各イメージは以下の構造を持ちます：

```
images/<image-name>/
├── .devcontainer/
│   ├── Dockerfile           # マルチステージビルド
│   └── devcontainer.json    # VS Code DevContainer設定
├── devbox.json              # パッケージ定義（メイン設定）
├── devbox.lock              # ロックファイル（依存関係の固定）
├── puppeteer-config.json    # mermaid-cli用設定（baseのみ）
├── test/
│   ├── mermaid_001.mmd      # mermaid-cliテスト用
│   └── main.<ext>           # 言語別テストファイル
└── test.sh                  # テストスクリプト
```

## 1. 新規イメージの作成

### 1.1 ディレクトリの準備

既存のイメージをベースにコピーします：

```bash
# 例: pythonイメージをベースに新しいイメージを作成
cp -r images/python images/new-language
cd images/new-language
```

### 1.2 devbox.json の編集

`devbox.json` にパッケージを追加します。利用可能なパッケージは [Nixhub](https://www.nixhub.io/) で検索できます。

```json
{
  "$schema": "https://raw.githubusercontent.com/jetify-com/devbox/0.16.0/.schema/devbox.schema.json",
  "packages": [
    "your-package@version"
  ]
}
```

### 1.3 devbox.lock の生成・更新

`devbox.json` を編集したら、`devbox install` を実行して `devbox.lock` を生成・更新します。
このコマンドは devbox 環境が必要なため、Docker コンテナ内で実行します。

```bash
# ローカル環境から実行
docker run -it --rm \
  -v $(pwd)/<image-path>:/tmp/app \
  -w /tmp/app \
  jetpackio/devbox:0.16.0 \
  devbox install

# 例: 新規作成した devcontainer イメージの devbox.lock を生成・更新
docker run -it --rm \
  -v $(pwd)/.devcontainer:/tmp/app \
  -w /tmp/app \
  jetpackio/devbox:0.16.0 \
  devbox install

# 例: 新規作成した base イメージの devbox.lock を生成・更新
docker run -it --rm \
  -v $(pwd)/images/base:/tmp/app \
  -w /tmp/app \
  jetpackio/devbox:0.16.0 \
  devbox install

# 例: 新規作成した go イメージの devbox.lock を生成・更新
docker run -it --rm \
  -v $(pwd)/images/go:/tmp/app \
  -w /tmp/app \
  jetpackio/devbox:0.16.0 \
  devbox install

# 例: 新規作成した ruby イメージの devbox.lock を生成・更新
docker run -it --rm \
  -v $(pwd)/images/ruby:/tmp/app \
  -w /tmp/app \
  jetpackio/devbox:0.16.0 \
  devbox install
```

DevContainer 内から実行する場合：

```bash
# 構文
docker run -it --rm \
  -v ${LOCAL_WORKSPACE_FOLDER}/<image-path>:/tmp/app \
  -w /tmp/app \
  jetpackio/devbox:0.16.0 \
  devbox install

# 例: .devcontainer イメージの devbox.lock を生成・更新
docker run -it --rm \
  -v ${LOCAL_WORKSPACE_FOLDER}/.devcontainer:/tmp/app \
  -w /tmp/app \
  jetpackio/devbox:0.16.0 \
  devbox install

# 例: base イメージの devbox.lock を生成・更新
docker run -it --rm \
  -v ${LOCAL_WORKSPACE_FOLDER}/images/base:/tmp/app \
  -w /tmp/app \
  jetpackio/devbox:0.16.0 \
  devbox install

# 例: go イメージの devbox.lock を生成・更新
docker run -it --rm \
  -v ${LOCAL_WORKSPACE_FOLDER}/images/go:/tmp/app \
  -w /tmp/app \
  jetpackio/devbox:0.16.0 \
  devbox install

# 例: python イメージの devbox.lock を生成・更新
docker run -it --rm \
  -v ${LOCAL_WORKSPACE_FOLDER}/images/python:/tmp/app \
  -w /tmp/app \
  jetpackio/devbox:0.16.0 \
  devbox install
```

成功すると `devbox.lock` が生成・更新され、依存関係が固定されます。
エラーが出た場合は `devbox.json` のパッケージ名やバージョンを確認してください。

### 1.4 Dockerfile の編集

`.devcontainer/Dockerfile` を編集し、コピー先パスを変更します：

```dockerfile
FROM jetpackio/devbox:0.16.0 AS builder

WORKDIR /code/<image-name>
# ... 以下同様
```

### 1.5 devcontainer.json の編集

`.devcontainer/devcontainer.json` で必要な拡張機能を追加します。

### 1.6 テストの作成

`test/` ディレクトリに言語別のテストファイルを作成し、`test.sh` を更新します。

## 2. devbox.json の検証

既存イメージの `devbox.json` を変更した場合や、新規作成後に検証する方法です。

### 2.1 devbox install による検証（推奨）

[1.3 devbox.lock の生成](#13-devboxlock-の生成) と同じコマンドで検証できます。
`devbox install` が成功すれば、パッケージ定義は正しいと判断できます。

### 2.2 JSON 構文チェック

```bash
# 構文
jq empty images/<image-name>/devbox.json

# 例: go イメージの構文チェック
jq empty images/go/devbox.json

# 例: python イメージの構文チェック
jq empty images/python/devbox.json
```

※ JSONC形式のコメントがある場合は警告が出ますが、devbox は JSONC をサポートしているため問題ありません。

### 2.3 Docker イメージのビルド

フルビルドで検証します：

```bash
# 構文
cd images/<image-name>
docker build -f .devcontainer/Dockerfile -t test-image .

# 例: go イメージのビルド
cd images/go
docker build -f .devcontainer/Dockerfile -t test-go .

# 例: python イメージのビルド
cd images/python
docker build -f .devcontainer/Dockerfile -t test-python .
```

## 3. 複数イメージのマージ

`tools/merge_devbox/` スクリプトを使用して、複数の `devbox.json` をマージできます。

### 使用方法

```bash
# 例: go と js をマージして go-js を生成
tools/merge_devbox/merge_devbox.sh \
  images/go/devbox.json \
  images/js/devbox.json \
  > images/go-js/devbox.json
```

### 仕組み

- 各 `devbox.json` から `packages` 配列を抽出
- 順序を保持しながらマージ
- 重複パッケージは最初の出現を優先
- 出力先のファイルヘッダーにソースファイルを記載

### マージ後の確認

```bash
# マージ結果を確認
cat images/go-js/devbox.json

# 検証
docker run -it --rm \
  -v $(pwd)/images/go-js:/tmp/app \
  -w /tmp/app \
  jetpackio/devbox:0.16.0 \
  devbox install
```

## 4. テストの実行

各イメージには `test.sh` が含まれています。DevContainer 内で実行します：

```bash
# 構文
cd images/<image-name>
./test.sh

# 例: go イメージのテスト
cd images/go
./test.sh

# 例: python イメージのテスト
cd images/python
./test.sh
```

テスト内容：

- mermaid-cli による SVG 生成
- 言語固有のコード実行（例: `go run`, `python`, `bun` など）

## 5. CI/CD

GitHub Actions（`.github/workflows/build-devcontainer-images.yaml`）により、以下のタイミングで自動ビルドされます：

- `images/*/devbox.json` の変更時
- `images/*/.devcontainer/Dockerfile` の変更時

ビルドされたイメージは Docker Hub にプッシュされます：

- `aazw/devcontainers-devbox-<image-name>:latest`
- `aazw/devcontainers-devbox-<image-name>:<numeric-tag>`
- `aazw/devcontainers-devbox-<image-name>:<commit-sha>`
