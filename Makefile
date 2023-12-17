SHELL=/bin/bash

ifeq (${ELEMENT},)
	echo "Please, provide ELEMENT variable"
endif

ifeq (${ENV},)
	echo "Please, provide ENV variable: dev | stage | prod"
endif

ifeq (${REGION},)
	REGION = us-east-1
endif

copy-config: 
	cp versions.tf ${ELEMENT}/

init: copy-config
	cd ${ELEMENT} && \
	terraform init -upgrade -backend-config=envs/${ENV}/${ENV}.s3.tfbackend -backend-config=envs/${ENV}/regions/${REGION}/child.s3.tfbackend

plan: copy-config
	cd ${ELEMENT} && \
	terraform plan -var-file envs/${ENV}/${ENV}.tfvars -var-file envs/${ENV}/regions/${REGION}/child.tfvars $(foreach target, ${TARGETS}, -target=${target}) -out=${ELEMENT}.tfplan

apply: copy-config
	cd ${ELEMENT} && \
	terraform apply "${ELEMENT}.tfplan"

destroy-plan: copy-config
	cd ${ELEMENT} && \
	terraform plan -destroy -var-file ${ELEMENT}/envs/${ENV}/${ENV}.tfvars -var-file ${ELEMENT}/envs/${ENV}/regions/${REGION}/child.tfvars $(foreach target, ${TARGETS}, -target=${target}) -out=destroy_${ELEMENT}.tfplan

destroy: copy-config
	cd ${ELEMENT} && \
	terraform apply "destroy_${ELEMENT}.tfplan"

check-vars-import:
	ifeq (${IMPORT_TARGET},)
		echo "Please, provide IMPORT_TARGET variable = complete tf resource address"
	endif

	ifeq (${ID},)
		echo "Please, provide ID variable = AWS resource ID"
	endif

import: copy-config check-vars-import
	cd ${ELEMENT} && \
	terraform import -var-file ${ELEMENT}/envs/${ENV}/${ENV}.tfvars -var-file ${ELEMENT}/envs/${ENV}/regions/${REGION}/child.tfvars ${IMPORT_TARGET} ${ID}

help:
	echo "Required vars are ELEMENT, REGION and TARGETS (space-separated, if more then 1)"

.PHONY: copy-config init plan apply help