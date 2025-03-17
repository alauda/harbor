FROM golang:1.14.15

ARG NOTARY_VERSION
ARG MIGRATE_VERSION
RUN test -n "$NOTARY_VERSION"
RUN test -n "$MIGRATE_VERSION"
ENV NOTARYPKG github.com/theupdateframework/notary
ENV MIGRATEPKG github.com/golang-migrate/migrate

RUN git clone --depth=1 -b $NOTARY_VERSION https://github.com/theupdateframework/notary.git /go/src/${NOTARYPKG}
WORKDIR /go/src/${NOTARYPKG}

RUN GO111MODULE=off CGO_ENABLED=0 go install -tags pkcs11 \
    -ldflags "-w -extldflags '-static' -X ${NOTARYPKG}/version.GitCommit=`git rev-parse --short HEAD` -X ${NOTARYPKG}/version.NotaryVersion=`cat NOTARY_VERSION`" ${NOTARYPKG}/cmd/notary-server

RUN GO111MODULE=off CGO_ENABLED=0 go install -tags pkcs11 \
    -ldflags "-w -extldflags '-static' -X ${NOTARYPKG}/version.GitCommit=`git rev-parse --short HEAD` -X ${NOTARYPKG}/version.NotaryVersion=`cat NOTARY_VERSION`" ${NOTARYPKG}/cmd/notary-signer
RUN cp -r /go/src/${NOTARYPKG}/migrations/ / 

RUN git clone --depth=1 -b $MIGRATE_VERSION https://github.com/golang-migrate/migrate /go/src/${MIGRATEPKG}
WORKDIR /go/src/${MIGRATEPKG}

ENV DATABASES="postgres mysql redshift cassandra spanner cockroachdb"
ENV SOURCES="file go_bindata github aws_s3 google_cloud_storage"

RUN set -ex && \
    cd /go/src/${MIGRATEPKG} && \
    export GOPROXY="https://build-nexus.alauda.cn/repository/golang/,direct" && \
    go get github.com/aws/aws-sdk-go@v1.34.0 && \
    go get github.com/jackc/pgproto3/v2@v2.3.3 && \
    go get golang.org/x/text@v0.3.8 && \
    go get google.golang.org/grpc@v1.58.3 && \
    go get github.com/jackc/pgx/v4@v4.18.2 && \
    go get google.golang.org/protobuf@v1.33.0 && \
    go get golang.org/x/net@v0.33.0 && \
    go get golang.org/x/crypto@v0.31.0 && \
    go mod tidy

RUN CGO_ENABLED=0 go install -tags "$DATABASES $SOURCES" -ldflags="-w -extldflags '-static' -X main.Version=${MIGRATE_VERSION}" ./cli && mv /go/bin/cli /go/bin/migrate
