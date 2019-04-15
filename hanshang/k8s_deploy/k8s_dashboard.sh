#!/bin/bash


wget http://203.110.209.244:88/rpm/kubernetes-1.10/k8s-images-1.10.tar.gz
docker load -i k8s-images-1.10.tar.gz
wget http://203.110.209.244:88/rpm/kubernetes-1.10/kubernetes-dashboard-http.yaml
wget http://203.110.209.244:88/rpm/kubernetes-1.10/admin-role.yaml
wget http://203.110.209.244:88/rpm/kubernetes-1.10/kubernetes-dashboard-admin.rbac.yaml

kubectl apply -f kubernetes-dashboard-http.yaml
kubectl apply -f admin-role.yaml
kubectl apply -f kubernetes-dashboard-admin.rbac.yaml
