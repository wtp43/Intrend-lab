#!/bin/zsh

mkdir -p ~/.kube/
mkdir -p ~/.talos/
terraform output -raw kube_config >~/.kube/config
terraform output -raw talos_config >~/.talos/config
chmod 600 ~/.kube/config
chmod 600 ~/.talos/config
