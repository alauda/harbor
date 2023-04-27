#!/bin/bash

set -e

change_base_image () {
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
            change_base_image $1"/"$file
        elif [[ $file == *Dockerfile* ]]
        then
            sed -i 's/curl -fsSL/wget/' $1"/"$file

            echo $1"/"$file
        fi
    done
}

change_base_image "tools"

# swagger
sed -i 's/registry.npmjs.org/build-nexus.alauda.cn\/repository\/npm\//g' "Makefile"
sed -i 's/BUILDBIN=false/BUILDBIN=true/g' "Makefile"
sed -i 's/PUSHBASEIMAGE=false/PUSHBASEIMAGE=true/g' "Makefile"
sed -i 's/BASEIMAGENAMESPACE=goharbor/BASEIMAGENAMESPACE \?= goharbor/g' "Makefile"
sed -i 's/TRIVYFLAG=false/TRIVYFLAG=true/g' "Makefile"
sed -i 's/-e NPM_REGISTRY=$(NPM_REGISTRY)/-e NPM_REGISTRY=$(NPM_REGISTRY) -e NOTARYFLAG=true -e CHARTFLAG=true/g' "Makefile"
sed -i 's/=goharbor\//=harbor-devops.alauda.cn\/kychen\/goharbor-/g' "Makefile"
sed -i 's/VERSIONTAG=dev/VERSIONTAG \?= dev/g' "Makefile"
sed -i 's/BASEIMAGETAG=dev/BASEIMAGETAG \?= dev/g' "Makefile"
sed -i 's/--pull / /g' "Makefile"
sed -i 's/PULL_BASE_FROM_DOCKERHUB=true/PULL_BASE_FROM_DOCKERHUB=false/g' "Makefile"
sed -i 's/golang:1.19.4/harbor-devops.alauda.cn\/kychen\/golang:1.19.4 /g' "Makefile"


sed -i 's/compile: check_environment versions_prepare compile_core compile_jobservice compile_registryctl compile_notary_migrate_patch/compile: versions_prepare compile_core compile_jobservice compile_registryctl compile_notary_migrate_patch/g' "Makefile"
echo "AMD64 after change the Makefile is "
cat Makefile

# sed -i 's/build: _build_prepare _build_db _build_portal _build_core _build_jobservice _build_log _build_nginx _build_registry _build_registryctl _build_notary _build_trivy_adapter _build_redis _build_chart_server _compile_and_build_exporter/build: _build_portal _build_core _build_jobservice _build_nginx _build_registry _build_registryctl _build_notary _build_trivy_adapter _build_chart_server _compile_and_build_exporter/g' "make/photon/Makefile"
sed -i '1 a TRIVYFLAG=true' "make/photon/Makefile"


sed -i 's/=goharbor\//=build-harbor.alauda.cn\/devops\/goharbor-/g' "make/photon/Makefile"
sed -i 's/BASEIMAGENAMESPACE=goharbor/BASEIMAGENAMESPACE \?= goharbor/g' "make/photon/Makefile"

echo "AMD64 after change the make/photon/Makefile is "
cat make/photon/Makefile
