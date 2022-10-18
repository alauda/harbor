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
            sed -i 's/photon:2.0/photon:4.0/' $1"/"$file
            sed -i 's/FROM ${harbor_base_namespace}\//FROM build-harbor.alauda.cn\/test\//g' $1"/"$file
            echo $1"/"$file
        elif [[ $file == "docker-healthcheck.sh" ]]
        then
            sed -i '/host=/ s/$/\nhost="${host%%[[:space:]]*}"/' $1"/"$file
        fi
    done
}

change_base_image "make/photon"

# swagger
sed -i 's/--template-dir=$(TOOLSPATH)/--template-dir=$(COMPILEBUILDPATH)\/tools/g' "Makefile"
sed -i 's/-v $(BUILDPATH):$(BUILDPATH) -w $(BUILDPATH)/-v $(COMPILEBUILDPATH):$(COMPILEBUILDPATH) -w $(COMPILEBUILDPATH)/g' "Makefile"
sed -i 's/-v $(BUILDPATH):$(GOBUILDPATHINCONTAINER)/-v $(COMPILEBUILDPATH):$(GOBUILDPATHINCONTAINER)/g' "Makefile"
sed -i '1 a COMPILEBUILDPATH=/harbor-builder' "Makefile"
sed -i 's/registry.npmjs.org/build-nexus.alauda.cn\/repository\/npm\//g' "Makefile"
sed -i 's/BUILDBIN=false/BUILDBIN=true/g' "Makefile"
#sed -i 's/PUSHBASEIMAGE=false/PUSHBASEIMAGE=true/g' "Makefile"
sed -i 's/BASEIMAGENAMESPACE=goharbor/BASEIMAGENAMESPACE=build-harbor.alauda.cn\/devops/g' "Makefile"
sed -i 's/TRIVYFLAG=false/TRIVYFLAG=true/g' "Makefile"
sed -i 's/-e NPM_REGISTRY=$(NPM_REGISTRY)/-e NPM_REGISTRY=$(NPM_REGISTRY) -e NOTARYFLAG=true -e CHARTFLAG=true/g' "Makefile"
sed -i 's/=goharbor\//=build-harbor.alauda.cn\/devops\/goharbor-/g' "Makefile"
#sed -i 's/VERSIONTAG=dev/VERSIONTAG=alauda-v2.2.3-${BUILD_NUMBER}-amd64/g' "Makefile"
#sed -i 's/BASEIMAGETAG=dev/BASEIMAGETAG=v2.2.3/g' "Makefile"
sed -i 's/$(PUSHSCRIPTPATH)\/$(PUSHSCRIPTNAME) $(BASEIMAGENAMESPACE)\/harbor-$$name-base:$(BASEIMAGETAG) $(REGISTRYUSER) $(REGISTRYPASSWORD)/docker push build-harbor.alauda.cn\/devops\/harbor-$$name-base:$(BASEIMAGETAG)/g' "Makefile"
sed -i 's/$(BASEIMAGENAMESPACE)\/harbor-$$name-base/build-harbor.alauda.cn\/devops\/harbor-$$name-base/g' "Makefile"
sed -i 's/--pull / /g' "Makefile"
sed -i 's/compile: check_environment versions_prepare compile_core compile_jobservice compile_registryctl compile_notary_migrate_patch/compile: versions_prepare compile_core compile_jobservice compile_registryctl compile_notary_migrate_patch/g' "Makefile"
echo "AMD64 after change the Makefile is "
cat Makefile

sed -i 's/build: _build_prepare _build_db _build_portal _build_core _build_jobservice _build_log _build_nginx _build_registry _build_registryctl _build_notary _build_trivy_adapter _build_redis _build_chart_server _compile_and_build_exporter/build: _build_db _build_portal _build_core _build_jobservice _build_nginx _build_registry _build_registryctl _build_notary _build_trivy_adapter _build_chart_server _compile_and_build_exporter/g' "make/photon/Makefile"
sed -i '1 a TRIVYFLAG=true' "make/photon/Makefile"

sed -i 's/chartserver trivy-adapter core db jobservice log nginx notary-server notary-signer portal prepare redis registry registryctl exporter/chartserver trivy-adapter core db jobservice nginx notary-server notary-signer portal registry registryctl exporter/g' "Makefile"

sed -i 's/=goharbor\//=build-harbor.alauda.cn\/devops\/goharbor-/g' "make/photon/Makefile"

echo "AMD64 after change the make/photon/Makefile is "
cat make/photon/Makefile


sed -i 's/docker run -it/docker run -i/g' "make/photon/chartserver/builder"
sed -i 's/$PWD/\/harbor-builder\/make\/photon\/chartserver/g' "make/photon/chartserver/builder"
echo "AMD64 after change make/photon/chartserver/builder is"
cat make/photon/chartserver/builder




