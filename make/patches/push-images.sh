#!/bin/bash

set -e

# create manifest for harbor image

components=(harbor-portal notary-server-photon notary-signer-photon harbor-registryctl registry-photon nginx-photon harbor-jobservice harbor-core harbor-db chartmuseum-photon trivy-adapter-photon harbor-exporter)

for arg in "${components[@]}"; do
  image="goharbor-${arg}:${VERSIONTAG}"
  local="localhost:5000/${image}"
  remote="build-harbor.alauda.cn/devops/${image}"
  docker push "${local}-amd64"
  docker push "${local}-arm64"
  docker manifest create "${remote}" --amend "${local}-amd64" --amend "${local}-arm64"
  docker manifest push "${remote}"
done
