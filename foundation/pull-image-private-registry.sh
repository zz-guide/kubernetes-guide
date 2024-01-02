#!/usr/bin/env bash

alreadyLogin(){
    kubectl create secret generic harborsecret  \
    --from-file=.dockerconfigjson=/root/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
}

first(){
    kubectl create secret docker-registry harborsecret \
    --docker-server=zz.harbor.com \
    --docker-username=admin \
    --docker-password=123456 \
    --docker-email=<your-email>
}

info(){
    # kubectl get secret harborsecret --output=yaml
    # kubectl get secret harborsecret --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode
}