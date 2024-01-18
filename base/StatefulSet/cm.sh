#!/usr/bin/env bash

createConfigMap(){
    kubectl create cm zz-redis \
    --namespace=zz-redis \
    --from-file=redis-conf=./redis/redis.conf \
    --from-file=sentinel-conf=./sentinel/sentinel.conf
}

createConfigMap