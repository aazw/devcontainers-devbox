#!/usr/bin/env node
"use strict";

const fs = require("node:fs/promises");
const path = require("node:path");
const { parse, ParseErrorCode } = require("jsonc-parser");

function printUsage() {
  // Keep stdout clean for piping; write help to stderr.
  process.stderr.write(
    [
      "Usage:",
      "  jsonc2json [--compact] [--help] [<file>|-]",
      "",
      "Reads JSONC from a file or stdin and writes JSON to stdout.",
      "  - If <file> is omitted or '-', reads from stdin.",
      "  - --compact outputs minified JSON (default: pretty-printed).",
      "",
      "Examples:",
      "  node tools/merge_devbox/jsonc2json.js .devcontainer/devbox.json | check-jsonschema --schemafile https://... -",
      "  node tools/merge_devbox/jsonc2json.js - < .devcontainer/devcontainer.json | check-jsonschema --schemafile https://... -",
      "",
    ].join("\n"),
  );
}

function offsetToLineCol(text, offset) {
  let line = 1;
  let col = 1;
  for (let i = 0; i < offset && i < text.length; i += 1) {
    if (text[i] === "\n") {
      line += 1;
      col = 1;
    } else {
      col += 1;
    }
  }
  return { line, col };
}

async function readAllStdin() {
  return await fs.readFile(0, "utf8");
}

async function main() {
  const argv = process.argv.slice(2);
  const compact = argv.includes("--compact");
  const help = argv.includes("--help") || argv.includes("-h");

  const positional = argv.filter((a) => !a.startsWith("-"));
  const input = positional[0] ?? "-";

  if (help) {
    printUsage();
    process.exit(0);
  }

  if (positional.length > 1) {
    process.stderr.write("error: too many positional arguments\n");
    printUsage();
    process.exit(2);
  }

  let filenameForErrors = "<stdin>";
  let text;
  if (input === "-" || input === "") {
    text = await readAllStdin();
  } else {
    filenameForErrors = path.resolve(process.cwd(), input);
    text = await fs.readFile(filenameForErrors, "utf8");
  }

  // Remove UTF-8 BOM if present.
  if (text.charCodeAt(0) === 0xfeff) {
    text = text.slice(1);
  }

  const errors = [];
  const value = parse(text, errors, {
    allowTrailingComma: true,
    disallowComments: false,
  });

  if (errors.length > 0) {
    for (const err of errors) {
      const { line, col } = offsetToLineCol(text, err.offset);
      const codeName =
        Object.entries(ParseErrorCode).find(([, v]) => v === err.error)?.[0] ??
        String(err.error);
      process.stderr.write(
        `${filenameForErrors}:${line}:${col}: parse error (${codeName})\n`,
      );
    }
    process.exit(1);
  }

  if (typeof value === "undefined") {
    process.stderr.write(`${filenameForErrors}: parse error (empty input)\n`);
    process.exit(1);
  }

  const json = compact
    ? JSON.stringify(value)
    : JSON.stringify(value, null, 2) + "\n";
  process.stdout.write(json);
}

main().catch((err) => {
  process.stderr.write(`error: ${err?.message ?? String(err)}\n`);
  process.exit(1);
});
