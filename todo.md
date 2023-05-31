### TODO
If you want to use on demand instance, you can change the instance type in `variables.tf` file.

### TODO
Verify K8 ports and add to security group, enabled as neeeded.

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
