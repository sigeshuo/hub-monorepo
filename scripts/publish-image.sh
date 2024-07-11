#!/bin/bash

# Builds and publishes image to Docker Hub.
# This is intended to be run by our GitHub Actions workflow.
#
# MUST be run from the root of the repository so the Docker build context is correct.
#
# You must `docker login ...` first so that we have the necessary permissions to
# push the image layers + tags to Docker Hub.

HUBBLE_VERSION=$(node -e "console.log(require('./apps/hubble/package.json').version);")

echo "Publishing $HUBBLE_VERSION"

# 设置 builder 名称
BUILDER_NAME="hubble-builder"

# 检查 builder 是否存在
if ! docker buildx inspect $BUILDER_NAME >/dev/null 2>&1; then
  echo "Builder '$BUILDER_NAME' 不存在，创建新的 builder..."
  # Enable Buildx
  docker buildx create --name $BUILDER_NAME --use
else
  echo "Builder '$BUILDER_NAME' 已存在，使用现有的 builder..."
  docker buildx use $BUILDER_NAME
fi

docker buildx build -f Dockerfile.hubble \
  --platform "linux/amd64,linux/arm64" \
  -t sigeshuo/hubble:${HUBBLE_VERSION} \
  -t sigeshuo/hubble:latest \
  --load \
  .

docker tag sigeshuo/hubble:${HUBBLE_VERSION} sigeshuo/farcaster:${HUBBLE_VERSION}
docker tag sigeshuo/hubble:latest sigeshuo/farcaster:latest

docker push sigeshuo/hubble:${HUBBLE_VERSION}
docker push sigeshuo/hubble:latest

docker push sigeshuo/farcaster:${HUBBLE_VERSION}
docker push sigeshuo/farcaster:latest