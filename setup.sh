#!/bin/bash

check_mark="\u2714\ufe0f"

function loading {
	
	printf "\033[2K\r%s \t" "$1"
	sleep 0.15
	printf "\033[2K\r%s.\t" "$1"
	sleep 0.15
	printf "\033[2K\r%s ..\t" "$1"
	sleep 0.15
	printf "\033[2K\r%s ...\t" "$1"
	sleep 0.15
	printf "\033[2K\r%s \t" "$1"
	sleep 0.15
	printf "\033[2K\r%s .\t" "$1"
	sleep 0.15
	printf "\033[2K\r%s ..\t" "$1"
	sleep 0.15
	printf "\033[2K\r%s ...\t" "$1"
	sleep 0.15
	printf "\n"
}

function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

function destroy {
	if [ "$1" == "all" ] || [ "$1" == "vagrant" ]; then
		loading "deleting everything"
		sudo vagrant destroy
		# sudo apt-get remove --auto-remove vagrant -y
	fi
}

function set_distant_access {
	loading "[3]: creating distant access "
	sudo mkdir -p $HOME/.kube 2> /dev/null
	echo "vagrant" | sudo ssh vagrant@192.168.56.101 "sudo cat /etc/kubernetes/admin.conf" > $HOME/.kube/config
}

function install_vagrant {
	printf "\nVagrant version\t: "
	vagrant -v
	if [ "$?" == "127" ]; then
		wget https://releases.hashicorp.com/vagrant/2.2.7/vagrant_2.2.7_x86_64.deb
		sudo dpkg -i vagrant_2.2.7_x86_64.deb
		rm vagrant_2.2.7_x86_64.deb
		printf "Vagrant installed succesfully $check_mark \n"
	else
		printf "valgrant installed $check_mark \n"
	fi
	loading "[0]: vagrant up"
	sudo vagrant up
	is_master_up=`sudo vagrant status | grep kubmaster | awk '{print $2}'`
	echo $is_master_up
	if [ $is_master_up != "running" ]; then
		sudo ./final_setup.sh
	fi
	kubectl version --client > setup.log
	if [ "$?" == "127" ]; then
		sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
		sudo add-apt-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main" 
		sudo apt-get install kubectl -y -qq
		apt-get update -qq >/dev/null
	fi
	printf "\nVagrant installed succesfully $check_mark \n"
	printf "kmaster installed $check_mark \n\n"
	sudo vagrant global-status
}

eval $(parse_yaml vagrant.yaml vagrant_)
if [ "$1" == "destroy" ]; then
	sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "$vagrant_kmaster_ip"
	sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "$vagrant_knode_ip"
	destroy "$2"
	exit
fi
if [ "$1" == "reset" ]; then 
	./setup.sh destroy all; bash time ./setup.sh
fi
if { [ "$1" == "connect" ] && [ "$2" == "ssh" ]; }; then
	printf "\e[3mdefault password is vagrant\e[0m\n"
	if { [ -z $3 ] || [ "$3" == "kmaster" ]; }; then
		sudo ssh vagrant@"$vagrant_kmaster_ip"
	else
		sudo ssh vagrant@"$vagrant_knode_ip"
	fi
	exit
fi
if { [ "$1" == "vagrant" ] && [ "$2" == "restart" ]; } || [ "$1" == "restart" ]; then
	loading "restarting vagrant"
	sudo vagrant halt "$3"
	sudo vagrant up "$3"
fi
install_vagrant;
loading "[1]: create $USER namespace  "
kubectl create namespace $USER 2> error.log
loading "[2]: create config $USER     "
kubectl config set-context $USER --namespace $USER --user kubernetes-admin --cluster kubernetes
if [ ! -d .kube ]; then
	set_distant_access
else
	echo "[3]: distant access already exist"
fi
kubectl config get-contexts 