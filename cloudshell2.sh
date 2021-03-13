#!/bin/bash

cd ~/

export CLUSTER_NAME=central
export CLUSTER_ZONE=us-central1-b
export GCLOUD_PROJECT=$(gcloud config get-value project)
gcloud container clusters get-credentials $CLUSTER_NAME \
--zone $CLUSTER_ZONE --project $GCLOUD_PROJECT
export GATEWAY_URL=$(kubectl get svc istio-ingressgateway \
-o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n istio-system)

curl -I http://${GATEWAY_URL}/productpage

curl -LO https://storage.googleapis.com/gke-release/asm/istio-1.6.8-asm.9-linux-amd64.tar.gz
tar xzf istio-1.6.8-asm.9-linux-amd64.tar.gz
cd istio-1.6.8-asm.9
export PATH=$PWD/bin:$PATH

kubectl apply -f samples/bookinfo/networking/destination-rule-all.yaml

kubectl apply -f samples/bookinfo/networking/virtual-service-all-v1.yaml


