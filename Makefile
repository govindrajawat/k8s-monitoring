.PHONY: deploy-dev deploy-prod port-forward

deploy-dev:
	kubectl apply -k kustomize/overlays/dev

deploy-prod:
	kubectl apply -k kustomize/overlays/prod

port-forward:
	./scripts/port-forward.sh