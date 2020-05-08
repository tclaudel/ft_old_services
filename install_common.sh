#!/bin/bash

## install common for k8s

HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - install common - "$IP
sudo -s
export DEBIAN_FRONTEND=noninteractive

echo "[2] disable swap - "$IP
# swapoff -a to disable swapping
swapoff -a
# sed to comment the swap partition in /etc/fstab
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

echo "[3] install utils - "$IP
apt-get update && apt-get install -y apt-transport-https curl >/dev/null
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
add-apt-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt-get update -qq >/dev/null

echo "[4]: install systemd / kubelet / kubeadm / kubectl / kubernetes-cni - "$IP
apt-get install -y -qq systemd kubelet kubeadm kubectl kubernetes-cni >/dev/null
systemctl enable kubelet
apt-get update -qq >/dev/null
echo vagrant ALL=NOPASSWD:ALL > /etc/sudoers.d/vagrant
echo "END - install common - " $IP

echo "[5]: install autocompletion"
apt-get install bash-completion
echo "source <(kubectl completion bash)" >> ~/.bashrc
source .bashrc

echo "[6]: setting aliases"
echo "alias k='kubectl'" >> ~/.bashrc
echo "alias kcc='kubectl config current-context'" >> ~/.bashrc
echo "alias kg='kubectl get'" >> ~/.bashrc
echo "alias kga='kubectl get all --all-namespaces'" >> ~/.bashrc
echo "alias kgp='kubectl get pods'" >> ~/.bashrc
echo "alias kgs='kubectl get services'" >> ~/.bashrc
echo "alias ksgp='kubectl get pods -n kube-system'" >> ~/.bashrc
echo "alias kuc='kubectl config use-context'" >> ~/.bashrc
source .bashrc



