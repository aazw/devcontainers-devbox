#!/bin/bash

set -eu

# go to project root
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_ROOT=$(cd -- "$SCRIPT_DIR/../.." && pwd)
SCRIPT_DIR_FROM_PROJECT_ROOT=$(realpath --relative-to="$PROJECT_ROOT" "$SCRIPT_DIR")

echo "SCRIPT_DIR=${SCRIPT_DIR}"
echo "PROJECT_ROOT=${PROJECT_ROOT}"
echo "SCRIPT_DIR_FROM_PROJECT_ROOT=${SCRIPT_DIR_FROM_PROJECT_ROOT}"
echo "LOCAL_WORKSPACE_FOLDER=${LOCAL_WORKSPACE_FOLDER}"

docker run -it --rm \
	-v "${LOCAL_WORKSPACE_FOLDER:-$PROJECT_ROOT}/${SCRIPT_DIR_FROM_PROJECT_ROOT}:/tmp/app" \
	-w /tmp/app \
	jetpackio/devbox:0.16.0 \
	devbox install
