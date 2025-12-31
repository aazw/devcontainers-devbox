#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const jsonc = require('jsonc-parser');

// コマンドライン引数から入力ファイルを取得
const inputFiles = process.argv.slice(2);

if (inputFiles.length === 0) {
  console.error('Usage: merge_devbox.js <devbox.json1> <devbox.json2> ...');
  console.error('');
  console.error('Example:');
  console.error('  merge_devbox.js images/go/devbox.json images/js/devbox.json');
  process.exit(1);
}

// 各ファイルが存在するか確認
for (const file of inputFiles) {
  if (!fs.existsSync(file)) {
    console.error(`Error: File not found: ${file}`);
    process.exit(1);
  }
}

// ファイルを読み込んでパース
const devboxConfigs = inputFiles.map(file => {
  const content = fs.readFileSync(file, 'utf8');
  return {
    file,
    content,
    parsed: jsonc.parse(content)
  };
});

// 元のファイルからコメント付きパッケージリストを抽出
function extractPackagesWithComments(content) {
  const lines = content.split('\n');
  const packagesStart = lines.findIndex(line => line.includes('"packages"'));
  const packagesEnd = lines.findIndex((line, idx) => idx > packagesStart && line.includes(']'));

  if (packagesStart === -1 || packagesEnd === -1) {
    return [];
  }

  return lines.slice(packagesStart + 1, packagesEnd);
}

// $schemaを取得（最初の有効なものを使用）
const schema = devboxConfigs.find(config => config.parsed.$schema)?.$schema ||
               'https://raw.githubusercontent.com/jetify-com/devbox/0.16.0/.schema/devbox.schema.json';

// 各ファイルからコメント付きパッケージリストを抽出
const packagesSections = devboxConfigs.map((config, index) => {
  const lines = extractPackagesWithComments(config.content);
  const fileName = path.basename(path.dirname(config.file));

  // セクションヘッダーを生成
  let header = '';
  if (index === 0) {
    header = `    // ============================================================================
    // Packages from ${config.file}
    // ============================================================================\n`;
  } else {
    header = `\n    // ============================================================================
    // Packages from ${config.file}
    // ============================================================================\n`;
  }

  return header + lines.join('\n').trimEnd();
});

// 最後のセクション以外にカンマを追加
const formattedSections = packagesSections.map((section, index) => {
  if (index < packagesSections.length - 1) {
    return section + ',';
  }
  return section;
});

// 出力を構築
const output = `{
  "$schema": "${schema}",
  "packages": [
${formattedSections.join('\n')}
  ]
}
`;

// 標準出力に出力
process.stdout.write(output);
