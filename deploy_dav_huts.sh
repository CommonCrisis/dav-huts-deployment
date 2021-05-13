#!/bin/bash

microk8s enable dns ingress registry rbac storage helm3

cd ./dav-huts
git pull
docker build . -t 75.119.134.70:32000/dav-huts-backend:registry
cd ..
# cd ./dav-huts-frontend
# git pull
# docker build . -t 75.119.134.70:32000/dav-huts-frontend:registry
# cd ..

# "Push images"
docker push 75.119.134.70:32000/dav-huts-frontend:registry
docker push 75.119.134.70:32000/dav-huts-backend:registry


# Deploy "Cluster"
microk8s kubectl apply -f infra/backend_deployment.yaml
microk8s kubectl apply -f infra/frontend_deployment.yaml
microk8s kubectl apply -f infra/mongo_deployment.yaml

# Install cert manager
# microk8s kubectl create namespace cert-manager
# microk8s helm3 repo add jetstack https://charts.jetstack.io
# microk8s helm3 repo update
# microk8s helm3 upgrade --install cert-manager jetstack/cert-manager \
#   --namespace cert-manager\
#   --set installCRDs=true \
#   --set ingressShim.defaultIssuerName=letsencrypt-production \
#   --set ingressShim.defaultIssuerKind=ClusterIssuer \
#   --set ingressShim.defaultIssuerGroup=cert-manager.io

# microk8s kubectl apply -f infra/ssl_cert_manager.yaml

# Add Ingress
# Adjustments need to be done to:
# https://github.com/jetstack/cert-manager/issues/2517#issuecomment-753067396

microk8s kubectl apply -f infra/ingress.yaml
microk8s kubectl rollout restart deployment