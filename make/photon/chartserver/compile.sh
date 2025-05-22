#!/bin/bash
set +e

usage(){
  echo "Usage: compile.sh <code path> <code tag> <main.go path> <binary name>"
  echo "e.g: compile.sh github.com/helm/chartmuseum v0.14.0 cmd/chartmuseum chartm"
  exit 1
}

if [ $# != 4 ]; then
  usage
fi

GIT_PATH="$1"
VERSION="$2"
MAIN_GO_PATH="$3"
BIN_NAME="$4"

set -e

#Get the source code
git clone --depth=1 -b $VERSION $GIT_PATH src_code
ls
SRC_PATH=$(pwd)/src_code

#Checkout the released tag branch
cd $SRC_PATH
#git checkout tags/$VERSION -b $VERSION

export GOPROXY="https://build-nexus.alauda.cn/repository/golang/,direct"
go get helm.sh/helm/v3@v3.14.2
go get github.com/containerd/containerd@v1.7.11
go get github.com/docker/distribution@v2.8.2+incompatible
go get github.com/docker/docker@v25.0.6+incompatible
go get golang.org/x/crypto@v0.35.0
go get github.com/golang-jwt/jwt/v4@v4.5.2
go get github.com/chartmuseum/auth@v0.5.1-0.20220324032459-8c5beb78aaba
go get golang.org/x/net@v0.33.0
go get google.golang.org/grpc@v1.58.3
go get gopkg.in/yaml.v3@v3.0.1
go get oras.land/oras-go@v1.2.5
go mod tidy

#Patch
for p in $(ls /go/bin/*.patch); do
  git apply $p || exit /b 1
done

#Compile
cd $SRC_PATH/$MAIN_GO_PATH && CGO_ENABLED=0 go build -a --ldflags "-w -s -extldflags '-static'" -o $BIN_NAME
mv $BIN_NAME /go/bin/
