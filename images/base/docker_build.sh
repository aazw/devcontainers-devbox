#!/bin/bash

set -eu

# go to images directory
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "${SCRIPT_DIR}"

DOCKERFILE="${SCRIPT_DIR}/.devcontainer/Dockerfile"
CONTEXT="${SCRIPT_DIR}"

echo "SCRIPT_DIR=${SCRIPT_DIR}"
echo "DOCKERFILE=${DOCKERFILE}"
echo "CONTEXT=${CONTEXT}"

docker build -f "${DOCKERFILE}" "${CONTEXT}"
