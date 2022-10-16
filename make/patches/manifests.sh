set -e
# patch version is our patch version based on harbor
# another place is in buildimage.sh that used build_num
PATCH_VERSION=master

HARBOR_VERSION='2.2.3'

echo build-harbor.alauda.cn/devops/goharbor-harbor-portal:${HARBOR_VERSION}-${PATCH_VERSION}-amd64
docker push build-harbor.alauda.cn/devops/goharbor-harbor-portal:${HARBOR_VERSION}-${PATCH_VERSION}-amd64

echo build-harbor.alauda.cn/devops/goharbor-notary-server-photon:${HARBOR_VERSION}-${PATCH_VERSION}-amd64
docker push build-harbor.alauda.cn/devops/goharbor-notary-server-photon:${HARBOR_VERSION}-${PATCH_VERSION}-amd64

echo build-harbor.alauda.cn/devops/goharbor-notary-signer-photon:${HARBOR_VERSION}-${PATCH_VERSION}-amd64
docker push build-harbor.alauda.cn/devops/goharbor-notary-signer-photon:${HARBOR_VERSION}-${PATCH_VERSION}-amd64

echo build-harbor.alauda.cn/devops/goharbor-harbor-registryctl:${HARBOR_VERSION}-${PATCH_VERSION}-amd64
docker push build-harbor.alauda.cn/devops/goharbor-harbor-registryctl:${HARBOR_VERSION}-${PATCH_VERSION}-amd64

echo build-harbor.alauda.cn/devops/goharbor-registry-photon:${HARBOR_VERSION}-${PATCH_VERSION}-amd64
docker push build-harbor.alauda.cn/devops/goharbor-registry-photon:${HARBOR_VERSION}-${PATCH_VERSION}-amd64

echo build-harbor.alauda.cn/devops/goharbor-nginx-photon:${HARBOR_VERSION}-${PATCH_VERSION}-amd64
docker push build-harbor.alauda.cn/devops/goharbor-nginx-photon:${HARBOR_VERSION}-${PATCH_VERSION}-amd64

echo build-harbor.alauda.cn/devops/goharbor-harbor-jobservice:${HARBOR_VERSION}-${PATCH_VERSION}-amd64
docker push build-harbor.alauda.cn/devops/goharbor-harbor-jobservice:${HARBOR_VERSION}-${PATCH_VERSION}-amd64

echo build-harbor.alauda.cn/devops/goharbor-harbor-core:${HARBOR_VERSION}-${PATCH_VERSION}-amd64
docker push build-harbor.alauda.cn/devops/goharbor-harbor-core:${HARBOR_VERSION}-${PATCH_VERSION}-amd64

echo build-harbor.alauda.cn/devops/goharbor-harbor-db:${HARBOR_VERSION}-${PATCH_VERSION}-amd64
docker push build-harbor.alauda.cn/devops/goharbor-harbor-db:${HARBOR_VERSION}-${PATCH_VERSION}-amd64

echo build-harbor.alauda.cn/devops/goharbor-chartmuseum-photon:${HARBOR_VERSION}-${PATCH_VERSION}-amd64
docker push build-harbor.alauda.cn/devops/goharbor-chartmuseum-photon:${HARBOR_VERSION}-${PATCH_VERSION}-amd64

echo build-harbor.alauda.cn/devops/goharbor-trivy-adapter-photon:${HARBOR_VERSION}-${PATCH_VERSION}-amd64
docker push build-harbor.alauda.cn/devops/goharbor-trivy-adapter-photon:${HARBOR_VERSION}-${PATCH_VERSION}-amd64

echo build-harbor.alauda.cn/devops/goharbor-harbor-exporter:${HARBOR_VERSION}-${PATCH_VERSION}-amd64
docker push build-harbor.alauda.cn/devops/goharbor-harbor-exporter:${HARBOR_VERSION}-${PATCH_VERSION}-amd64


