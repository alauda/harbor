#!/bin/bash

set -e

# create manifest for harbor image

docker image ls

components=(harbor-portal notary-server-photon notary-signer-photon harbor-registryctl registry-photon nginx-photon harbor-jobservice harbor-core chartmuseum-photon trivy-adapter-photon harbor-exporter)

for arg in "${components[@]}"; do
  image="build-harbor.alauda.cn/devops/goharbor-${arg}:${VERSIONTAG}"
  # only for amd64, arm has pushed when buildx build --type=registry
  docker push "${image}-amd64"
  docker manifest create "${image}" --amend "${image}-amd64" --amend "${image}-arm64"
  docker manifest push "${image}"
done
