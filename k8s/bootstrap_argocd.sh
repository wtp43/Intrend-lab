#!/bin/zsh

kustomize build --enable-helm infra/controllers/argocd | kubectl apply -f -
kubectl apply -k infra
kubectl apply -k apps
kubectl apply -k sets
