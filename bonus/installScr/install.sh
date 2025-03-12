#!/bin/bash

echo "Install starting"
#take down all running processes
#if docker and k3d is not installed, install them
#Installing Docker
echo "Docker Installing"
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg git-all -y
sudo apt-get update
sudo apt-get install docker.io -y
sudo usermod -aG docker $USER
#newgrp docker

#Installing K3D | Argo
echo "K3d Installing"
sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256) kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)
# curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v$VERSION/argocd-linux-amd64
# sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
# rm argocd-linux-amd64

#Installing Helm and Gitlab
sudo snap install helm --classic

helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm install gitlab gitlab/gitlab --namespace gitlab --values helm.yaml
kubectl get pods --namespace gitlab
kubectl get ingress --namespace gitlab


#creating a namespace for argocd and equipping it with argocd
echo "Beginning Setup"
../deploymentScr/Deploy.sh
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=120s
kubectl port-forward svc/argocd-server -n argocd 8082:443 &