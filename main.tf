terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

module "micro_k8s_instance" {
  source = ".//micro-k8s-instance"
}


output "ec2" {
  value = module.micro_k8s_instance.public_ip
}

output "public_ip" {
  value = module.micro_k8s_instance.public_ip
}

output "ssh_script" {
  value = module.micro_k8s_instance.ssh_script
}