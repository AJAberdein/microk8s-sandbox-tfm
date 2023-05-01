# MicroK8s sandbox

This is a terraform script which creates an ec2 sandbox for playing with [MicroK8s](https://microk8s.io/). Kubernetes need minimum 2CPU and 2 GB Ram. Because of that, we select t3a.medium with a 25GB volume size.

## Installation

Create infra with `terraform apply` command. Be aware this will generate a cost. You can check what infrastructure will be created with `terraform plan` command.

```
terraform apply
```

Access the instance with the output ssh command after instance create. Key gets generated to the local with relevant access permissions.

Example:
```
 ssh -i microk8s-instance-key.pem ubuntu@ec2-00-000-000-00.eu-west-1.compute.amazonaws.com
```

### TODO
On demand Prices are nearly 4 times expensive then Spot Prices. Install a Spot instance with low price.

### TODO
K8 ports add to security group:

|TCP|Inbound|80|Http|All|
|TCP|Inbound|443|Https|All|
|TCP|Inbound|6443|Kubernetes API server|All|
|TCP|Inbound|2379–2380|`etcd` server client API|kube-apiserver, etcd|
|TCP|Inbound|10250|Kubelet API|Self, Control plane|
|TCP|Inbound|10251|kube-scheduler|Self|
|TCP|Inbound|10252|kube-controller-manager|Self|
|TCP|Inbound|22|remote access with ssh|Self|
|UDP|Inbound|8472|Cluster-Wide Network Comm. — Flannel VXLAN|Self|
|TCP|Inbound|30000–32767|NodePort Services†|All|
