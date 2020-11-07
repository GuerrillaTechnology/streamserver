#!/bin/bash

TODAY=$(date --rfc-3339=seconds)

#
# arm32
#
docker pull --platform linux/arm/v7 debian:buster-slim
docker pull --platform linux/arm64 debian:buster-slim

docker login
docker buildx build --platform linux/arm/v7,linux/arm64 -t tobiasbartel/test:${TAG} -t tobiasbartel/test:latest --push .

