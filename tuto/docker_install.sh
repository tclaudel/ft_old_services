#!/bin/bash

curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
groupadd -g 500000 dockermap &&
groupadd -g 50100 dockermap-user &&
useradd -u 500000 -g dockermap -s /bin/false dockermap &&
useradd -u 501000 -g dockermap-user -s /bin/false dockermap-user
echo "dockermap:500000:65536" >> /etc/subuid &&
echo "dockermap:500000:65536" >> /etc/subgid
echo "
	{
		"userns-remap\": "default\"