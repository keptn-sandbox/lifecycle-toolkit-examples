# renovate: datasource=github-tags depName=jaegertracing/jaeger
JAEGER_VERSION ?= v1.39.0
LFC_NAMESPACE ?= keptn-lifecycle-controller-system
PODTATO_NAMESPACE ?= podtato-kubectl
GRAFANA_PORT_FORWARD ?= 3000

.PHONY: install
install:
	make -C ../observability install

.PHONY: port-forward-jaeger
port-forward-jaeger:
	make -C ../observability port-forward-jaeger

.PHONY: port-forward-grafana
port-forward-grafana:
	make -C ../observability port-forward-grafana GRAFANA_PORT_FORWARD=$(GRAFANA_PORT_FORWARD)

.PHONY: deploy-version-1
deploy-version-1:
	kubectl create namespace "$(PODTATO_NAMESPACE)" --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -k version-1

.PHONY: deploy-version-2
deploy-version-2:
	kubectl create namespace "$(PODTATO_NAMESPACE)" --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -k version-2

.PHONY: deploy-version-3
deploy-version-3:
	kubectl create namespace "$(PODTATO_NAMESPACE)" --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -k version-3

.PHONY: undeploy-podtatohead
undeploy-podtatohead:
	kubectl delete ns "$(PODTATO_NAMESPACE)" --ignore-not-found=true

	@echo "######################"
	@echo "PodTatoHead undeployed"
	@echo "######################"

.PHONY: uninstall
uninstall: undeploy-podtatohead
	make -C ../observability uninstall
