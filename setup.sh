#!/usr/bin/env bash
set -euo pipefail
IMAGE=devops-challenge-app:local

eval $(minikube -p minikube docker-env)
docker build -t $IMAGE .
eval $(minikube -p minikube docker-env --unset)

cd terraform
terraform init
terraform apply -auto-approve
cd ..

helm upgrade --install devops-challenge ./helm --namespace devops-challenge --create-namespace \
  --set image.repository=devops-challenge-app --set image.tag=local

