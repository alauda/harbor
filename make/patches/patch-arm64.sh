#!/bin/bash

set -e

sed -i 's/$(DOCKERBUILD) -f/docker buildx build --platform linux\/arm64 --output=type=docker -f/g' "make/photon/Makefile"

sed -i 's/$(DOCKERCMD) build/$(DOCKERCMD) buildx build --platform linux\/arm64 --progress plain --output=type=registry/' "make/photon/Makefile"
echo "ARM64 after change  make/photon/Makefile is "
cat make/photon/Makefile

#sed -i 's/VERSIONTAG=alauda-v2.2.3-${BUILD_NUMBER}-amd64/VERSIONTAG=alauda-v2.2.3-${BUILD_NUMBER}-arm64/g' "Makefile"

sed -i 's/--rm/--rm --env CGO_ENABLED=0 --env GOOS=linux --env GOARCH=arm64/g' "Makefile"
# build base
sed -i 's/$(DOCKERBUILD)/docker buildx build --platform linux\/arm64 --progress plain --output=type=registry/g' "Makefile"
sed -i 's/docker push/echo /g' "Makefile"
echo "ARM64 after change Makefile is "
cat Makefile


sed -i 's/go build -a/GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -a/g' "make/photon/chartserver/compile.sh"
echo "ARM64 after change make/photon/chartserver/compile.sh is "
cat make/photon/chartserver/compile.sh



sed -i 's/\/go\/bin\/notary-server/\/go\/bin\/linux_arm64\/notary-server/g' make/photon/notary/builder
sed -i 's/\/go\/bin\/notary-signer/\/go\/bin\/linux_arm64\/notary-signer/g' make/photon/notary/builder
echo "ARM64 after change make/photon/notary/builder is "
cat make/photon/notary/builder



sed -i 's/CGO_ENABLED=0/GOOS=linux GOARCH=arm64 CGO_ENABLED=0/g' "make/photon/registry/Dockerfile.binary"
echo "ARM64 after change make/photon/registry/Dockerfile.binary is "
cat make/photon/registry/Dockerfile.binary

sed -i 's/CGO_ENABLED=0/GOOS=linux GOARCH=arm64 CGO_ENABLED=0/g' "make/photon/trivy-adapter/Dockerfile.binary"
echo "ARM64 after change make/photon/trivy-adapter/Dockerfile.binary is "
cat make/photon/trivy-adapter/Dockerfile.binary

sed -i '8 a ENV CGO_ENABLED 0 \nENV GOOS linux \nENV GOARCH arm64' "make/photon/notary/binary.Dockerfile"
sed -i 's/\/go\/bin\/cli/\/go\/bin\/linux_arm64\/cli/g' "make/photon/notary/binary.Dockerfile"

echo "ARM64 after change make/photon/notary/binary.Dockerfile is "
cat make/photon/notary/binary.Dockerfile

echo "ARM64 change trivy download url"
sed -i 's/Linux-64bit/Linux-ARM64/g' "Makefile"

# exporter build
sed -i 's/GOARCH=amd64/GOARCH=arm64/g' "make/photon/exporter/Dockerfile"

DOCKER_BUILD_KIT=1 DOCKER_CLI_EXPERIMENTAL=enabled docker run --rm --privileged build-harbor.alauda.cn/3rdparty/docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
DOCKER_BUILD_KIT=1 DOCKER_CLI_EXPERIMENTAL=enabled docker run --rm --privileged build-harbor.alauda.cn/3rdparty/multiarch/qemu-user-static --reset -p yes

docker context create builder-arm
docker buildx create builder-arm --driver-opt network=host --platform linux/arm64 --use
