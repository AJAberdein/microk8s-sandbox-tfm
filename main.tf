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

module "resources_s3" {
  source = ".//modules//s3"
}

# data "terraform_remote_state" "resources_s3" {
  # backend = "s3"

  # config = {
  #   bucket = "my-bucket"
  #   key    = "first-module-state/terraform.tfstate"
  #   region = "eu-west-1"
  # }
# }

module "microk8s_instance" {
  source = ".//modules//ec2"
  # depends_on = [
  #   module.resources_s3
  # ]
}

output "ec2" {
  value = module.microk8s_instance.public_ip
}

output "public_ip" {
  value = module.microk8s_instance.public_ip
}

output "ssh_script" {
  value = module.microk8s_instance.ssh_script
}
