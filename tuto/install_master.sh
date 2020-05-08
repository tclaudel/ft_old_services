#!/bin/bash

## install master for k8s

TOKEN="abcdef.0123456789abcdef"
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - install master - "$IP

echo "[0]: reset cluster if exist"
kubeadm reset -f

echo "[1]: kubadm init"
kubeadm init --apiserver-advertise-address=$IP #--token="$TOKEN" --pod-network-cidr=10.244.0.0/16

echo "[2]: create config file"
mkdir $HOME/.kube
cp /etc/kubernetes/admin.conf $HOME/.kube/config

echo "[3]: create flannel pods network"
wget -O kube-flannel.yaml https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
sed -i 's/10.244.0.0/10.10.0.0/g' kube-flannel.yaml
kubectl apply -f kube-flannel.yaml

echo "[4]: restart and enable kubelet"
systemctl enable kubelet
service kubelet restart

echo "END - install master - " $IP
