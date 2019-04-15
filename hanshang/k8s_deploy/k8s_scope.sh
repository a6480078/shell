#!/bin/bash


wget http://203.110.209.244:88/rpm/kubernetes-1.10/scope.yaml
kubectl apply -f scope.yaml
