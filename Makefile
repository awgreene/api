##########################
#  OLM - Build and Test  #
##########################

SHELL := /bin/bash
PKG   := github.com/operator-framework/api
CODEGEN_INTERNAL := ./vendor/k8s.io/code-generator/generate_internal_groups.sh
export GO111MODULE=on

vendor:
	go mod tidy
	go mod vendor

# Must be run in gopath: https://github.com/kubernetes/kubernetes/issues/67566
# use container-codegen
codegen: export GO111MODULE := off
codegen:
	cp scripts/generate_internal_groups.sh vendor/k8s.io/code-generator/generate_internal_groups.sh
	mkdir -p vendor/k8s.io/code-generator/hack
	cp boilerplate.go.txt vendor/k8s.io/code-generator/hack/boilerplate.go.txt
	$(CODEGEN_INTERNAL) deepcopy $(PKG)/pkg/apis $(PKG)/pkg/apis $(PKG)/pkg/apis "operators:shared,v1alpha1,v1,v2"
