TOKEN="abcdef.0123456789abcdef"
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START -install master - "$IP
sudo -s
echo "[0]: reset cluster if exist"
kubeadm reset -f 2>error.log

echo "[1]: kubadm init - " $IP
kubeadm init --apiserver-advertise-address=$IP --token="$TOKEN" --node-name $HOSTNAME --pod-network-cidr=10.244.0.0/16

echo "[2]: Creating config files - " $IP
echo "what is home $HOME"
mkdir -p $HOME/.kube
mkdir -p .kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo cp -i /etc/kubernetes/admin.conf .kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo chown $(id -u):$(id -g) .kube/config
sudo chmod 755 .kube/config

echo "[3]: add pod system - " $IP
sudo sysctl net.bridge.bridge-nf-call-iptables=1
wget -O kube-flannel.yaml https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml > /dev/null
sed -i 's/10.244.0.0/10.10.0.0/g' kube-flannel.yaml
kubectl apply -f kube-flannel.yaml
rm kube-flannel.yaml

echo "[4]: create watcher.sh - " $IP
echo '#! /bin/bash

watch -n 0.5 "sudo kubectl get all --all-namespaces"
' > ./watcher.sh
chmod 755 watcher.sh

echo "[5]: adding hosts"
sed -i.bak '1i 192.168.56.101\tkubmaster\tkubmaster' /etc/hosts

echo "END - install master - " $IP