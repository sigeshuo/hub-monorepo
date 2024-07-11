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

# Enable Buildx
docker buildx create --use

docker buildx build -f Dockerfile.hubble \
  --platform "linux/amd64,linux/arm64" \
  -t sigeshuo/hubble:${HUBBLE_VERSION} \
  -t sigeshuo/hubble:latest \
  .

docker tag sigeshuo/hubble:${HUBBLE_VERSION} sigeshuo/farcaster:${HUBBLE_VERSION}
docker tag sigeshuo/hubble:latest sigeshuo/farcaster:latest
  .

  docker push sigeshuo/hubble:${HUBBLE_VERSION}
  docker push sigeshuo/hubble:latest

  docker push sigeshuo/farcaster:${HUBBLE_VERSION}
  docker push sigeshuo/farcaster:latest