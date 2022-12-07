# renovate: datasource=github-tags depName=jaegertracing/jaeger
JAEGER_VERSION ?= v1.39.0
LFC_NAMESPACE ?= keptn-lifecycle-controller-system
PODTATO_NAMESPACE ?= podtato-kubectl
GRAFANA_PORT_FORWARD ?= 3000
CERT_MANAGER_VERSION ?= v1.10.1

.PHONY: install
install:
	@echo "-----------------------------------"
	@echo "Create Namespace and install Keptn-lifecycle-toolkit"
	@echo "-----------------------------------"
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/$(CERT_MANAGER_VERSION)/cert-manager.yaml
	kubectl wait --for=condition=available deployment/cert-manager-webhook -n cert-manager --timeout=300s
	kubectl apply -f https://github.com/keptn/lifecycle-toolkit/releases/download/v0.4.1/manifest.yaml #x-release-please-version
	kubectl wait --for=condition=available deployment/klc-controller-manager -n keptn-lifecycle-toolkit-system --timeout=300s

.PHONY: install-observability
install-observability:
	make -C support/observability install

.PHONY: install-argo
install-argo:
	make -C support/argo install

.PHONY: port-forward-jaeger
port-forward-jaeger:
	make -C support/observability port-forward-jaeger

.PHONY: port-forward-grafana
port-forward-grafana:
	make -C support/observability port-forward-grafana GRAFANA_PORT_FORWARD=$(GRAFANA_PORT_FORWARD)

.PHONY: deploy-version-1
deploy-version-1:
	kubectl create namespace "$(PODTATO_NAMESPACE)" --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -k sample-app/version-1

.PHONY: deploy-version-2
deploy-version-2:
	kubectl create namespace "$(PODTATO_NAMESPACE)" --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -k sample-app/version-2

.PHONY: deploy-version-3
deploy-version-3:
	kubectl create namespace "$(PODTATO_NAMESPACE)" --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -k sample-app/version-3

.PHONY: undeploy-podtatohead
undeploy-podtatohead:
	kubectl delete ns "$(PODTATO_NAMESPACE)" --ignore-not-found=true

	@echo "######################"
	@echo "PodTatoHead undeployed"
	@echo "######################"

.PHONY: uninstall-observability
uninstall-observability: undeploy-podtatohead
	make -C support/observability uninstall
