KUBECTL=/usr/bin/kubectl
KUBEADM=/usr/bin/kubeadm

DRY_RUN=--dry-run=client
OUT_YAML=-o yaml

.PHONY: help test
help:
	@echo "usage: make <option>"
	@echo "options and effects:"
	@echo "    help                     : Show help"
	@echo "    test                     : Test ..."
	@echo "    init-k8s-yml             : 初始化k8s yml配置文件"

test:
	@echo "test ..."

.PHONY: init-k8s-yml create-ns-zz show-ns-zz-yml

init-k8s-yml:
	${KUBEADM} config print init-defaults

create-ns-zz:
	${KUBECTL} create ns zz
	
show-ns-zz-yml:
	${KUBECTL} create ns zz ${DRY_RUN} ${OUT_YAML}

.PHONY: show-po-nginx-yml
show-po-nginx-yml:
	${KUBECTL} run nginx --image=nginx:alpine ${DRY_RUN} ${OUT_YAML}

.PHONY: enter-nginx
enter-nginx:
	${KUBECTL} exec -it nginx -- sh

.PHONY: scale-nginx-rc scale-nginx-rs scale-nginx-deploy
scale-nginx-rc:
	${KUBECTL} scale rc/nginx-rc --replicas=6

scale-nginx-rs:
	${KUBECTL} scale rs/nginx-rs --replicas=6
scale-nginx-deploy:
	${KUBECTL} scale deploy/nginx-deploy --replicas=6
	kubectl set image deploy nginx-deploy nginx=nginx:latest
	kubectl rollout history deploy nginx-deploy
	kubectl rollout undo deploy nginx-deploy