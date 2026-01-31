#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "${SCRIPT_DIR}"

OWNER="aazw"
IMAGES=(
	# base image
	"devcontainers-devbox-base"
	# single-language images
	"devcontainers-devbox-python"
	"devcontainers-devbox-go"
	"devcontainers-devbox-js"
	"devcontainers-devbox-java"
	"devcontainers-devbox-rust"
	"devcontainers-devbox-swift"
	# multi-languages images
	"devcontainers-devbox-go-js"
	"devcontainers-devbox-python-js"
	# specific-purpose images
	"devcontainers-devbox-bi"
)

for IMAGE in "${IMAGES[@]}"; do
	max_tag="$(
		curl -fsSL "https://hub.docker.com/v2/repositories/${OWNER}/${IMAGE}/tags?ordering=last_updated&page_size=100&page=1" |
			jq -r '.results[].name | select(. != "latest")' |
			sort -n |
			tail -1
	)"

	echo "${OWNER}/${IMAGE}:${max_tag}"
done
