#!/usr/bin/env bash

createInitYaml(){
    kubeadm config print init-defaults > k8s-init.yaml
}
