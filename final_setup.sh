#!/bin/bash

## install common for k8s

HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - install common"

echo "[1]: deleting pods"
first_flannel=$(sudo vagrant ssh kubmaster -c "sudo kubectl get pods -n kube-system | grep kube-flannel | sed -n 1p" | awk '{print $1}')
second_flannel=$(sudo vagrant ssh kubmaster -c "sudo kubectl get pods -n kube-system | grep kube-flannel | sed -n 2p" | awk '{print $1}')
sudo vagrant ssh kubmaster -c "sudo kubectl delete pods $first_flannel -n kube-system"
sudo vagrant ssh kubmaster -c "sudo kubectl delete pods $second_flannel -n kube-system"
