#!/bin/bash

echo "init instance dependencies"

sudo snap install docker
sudo snap install microk8s --classic
sudo snap install kubectl --classic

sudo usermod -a -G microk8s ubuntu
# sudo groupadd docker
# sudo usermod -a -G docker ubuntu

# sudo docker build ./docker -t helloworld/app
# sudo chown -R ubuntu ~/.kube
newgrp microk8s
# newgrp docker
