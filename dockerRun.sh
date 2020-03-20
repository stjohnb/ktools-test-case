#!/usr/bin/env bash

set -euo pipefail

VERSION="$(date "+%Y%m%d%H%M%S")"
IMAGE="ktools-segfault:${VERSION}"

docker build . -t "${IMAGE}"

echo "Built image ${IMAGE}"

CONTAINER_DIR="/ktools-test"


docker run -ti \
  --mount type=bind,source="$(pwd)",target="${CONTAINER_DIR}" \
  "${IMAGE}" \
  "-c" \
  "cd ${CONTAINER_DIR} && ./run.sh"
