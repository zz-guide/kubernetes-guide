#!/usr/bin/env bash

createSecret(){
    kubectl create secret generic zz-redis \
    --namespace=zz-redis \
    --from-literal=password=123456
}

createSecret