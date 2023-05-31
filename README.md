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

On demand Prices are nearly 4 times expensive then Spot Prices, therefore a spot instance are initiated. Spot instance can be terminated by AWS at any time. 