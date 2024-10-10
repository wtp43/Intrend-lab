#!/bin/zsh

mkdir ~/.kube/
terraform output -raw kube_config >~/.kube/config

mkdir ~/.talos/
terraform output -raw talos_config >~/.talos/config
