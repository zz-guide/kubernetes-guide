#!/usr/bin/env bash

CONTROLLER_VERSION=1.9.5
CERTGEN_VERSION=v20231011
replaceImage(){
    sed -i "s/image: registry.k8s.io\/ingress-nginx\/kube-webhook-certgen.*/image: m.daocloud.io\/registry.k8s.io\/ingress-nginx\/kube-webhook-certgen:${CERTGEN_VERSION}/g" ingress-nginx-deploy.yaml
    sed -i "s/image: registry.k8s.io\/ingress-nginx\/controller.*/image: m.daocloud.io\/registry.k8s.io\/ingress-nginx\/controller:${CONTROLLER_VERSION}/g" ingress-nginx-deploy.yaml
}

# replaceImage

replaceImage2(){
    sed -i "s/registry.k8s.io/m.daocloud.io\/registry.k8s.io/g" ingress-nginx-deploy.yaml
}

replaceImage2