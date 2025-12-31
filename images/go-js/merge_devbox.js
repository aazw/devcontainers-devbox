#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const jsonc = require('jsonc-parser');

const projectRoot = path.resolve(__dirname, '../..');

// 入力ファイル
const goDevboxPath = path.join(projectRoot, 'images/go/devbox.json');
const jsDevboxPath = path.join(projectRoot, 'images/js/devbox.json');

// 出力ファイル
const outputPath = path.join(__dirname, 'devbox.json');

console.log('Merging devbox.json files...');
console.log(`  - ${goDevboxPath}`);
console.log(`  - ${jsDevboxPath}`);
console.log(`  -> ${outputPath}`);

// ファイルを読み込み
const goContent = fs.readFileSync(goDevboxPath, 'utf8');
const jsContent = fs.readFileSync(jsDevboxPath, 'utf8');

// JSONCをパース
const goDevbox = jsonc.parse(goContent);
const jsDevbox = jsonc.parse(jsContent);

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

// コメント付きパッケージリストを取得
const goPackagesLines = extractPackagesWithComments(goContent);
const jsPackagesLines = extractPackagesWithComments(jsContent);

// 出力を構築
const output = `{
  "$schema": "${goDevbox.$schema || jsDevbox.$schema}",
  "packages": [
    // ============================================================================
    // Go Development Tools
    // ============================================================================

${goPackagesLines.join('\n').trimEnd()},

    // ============================================================================
    // JavaScript/TypeScript Development Tools
    // ============================================================================

${jsPackagesLines.join('\n').trimEnd()}
  ]
}
`;

// ファイルに書き込み
fs.writeFileSync(outputPath, output, 'utf8');

console.log(`Successfully merged devbox.json files to ${outputPath}`);
console.log(`Total packages: ${(goDevbox.packages || []).length + (jsDevbox.packages || []).length}`);
