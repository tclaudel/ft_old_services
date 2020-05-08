#!/bin/bash

## install nodes for k8s

TOKEN="abcdef.0123456789abcdef"
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - install node - "$IP

echo "[0]: reset cluster if exist - "$IP
kubeadm reset -f 2> error.log

echo "[1]: kubadm join - "$IP
sysctl net.bridge.bridge-nf-call-iptables=1
kubeadm join --apiserver-advertise-address=$IP --token="$TOKEN" 192.168.56.101:6443 --discovery-token-unsafe-skip-ca-verification

echo "[3]: restart and enable kubelet - "$IP
systemctl enable kubelet
service kubelet restart

echo "[4]: adding hosts - "$IP
sed -i.bak '1i 192.168.56.102\tkubnode\tkubnode' /etc/hosts

echo "END - install master - " $IP