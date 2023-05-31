#!/bin/bash

echo "build MicroK8s kubernetes cluster"

# microk8s status --wait-ready

microk8s enable dashboard 
microk8s enable dns
microk8s enable registry
microk8s enable ingress

# df -h

aws s3 cp s3://microk8s-125385123512/scripts/build.sh ~/scripts/
aws s3 cp s3://microk8s-125385123512/docker/app.js ~/docker/
aws s3 cp s3://microk8s-125385123512/docker/package.json ~/docker/
aws s3 cp s3://microk8s-125385123512/docker/Dockerfile ~/docker/
aws s3 cp s3://microk8s-125385123512/k8s/deployment.yaml ~/k8s/

sudo docker build ./docker -t helloworld/app
sudo docker save helloworld/app > helloWorldAppImage.tar
sudo microk8s ctr image import helloWorldAppImage.tar
# sudo microk8s ctr images ls

microk8s config > ~/.kube/config
alias k=kubectl

kubectl apply -f ~/k8s/deployment.yaml
kubectl get pods

# microk8s kubectl apply -f ~/k8s/deployment.yaml
# microk8s kubectl get pods


# microk8s kubectl describe pod

# microk8s kubectl port-forward deployments/helloworldapp-deployment 3000:3000 --address 0.0.0.0

# sudo docker run --name api -p 3000:3000 -d app
# sudo docker container ls -a

# microk8s inspect
# microk8s status
# microk8s stop
# microk8s start

# microk8s kubectl cluster-info

# dashboard
# token=$(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
# microk8s kubectl -n kube-system describe secret $token
# microk8s dashboard-proxy

# ip
# k get pods -o wide

# busybox
# k run -it --rm --restart=Never busybox --image=gcr.io/google-containers/busybox sh

# k api-resources

# Ingress test
# curl localhost/hello-ingress

# k create job hello --image-busybox -- echo "Hello World!"
# k create job hello --image=busybox --schedule="*/1 * * * *" -- echo "Hello World!"