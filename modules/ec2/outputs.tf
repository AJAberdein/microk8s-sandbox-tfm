output "image_id" {
  value = data.aws_ami.ubuntu.id
}

output "ec2" {
  # value = aws_instance.microk8s_instance
  value = aws_spot_instance_request.microk8s_spot_instance
}

output "public_ip" {
  # value = aws_instance.microk8s_instance.public_ip
  value = aws_spot_instance_request.microk8s_spot_instance.public_ip
}

output "ssh_script" {
  # value = "ssh -i ${var.microk8s_instance_key}.pem ubuntu@${aws_instance.microk8s_instance.public_dns}"
  value = "ssh -i ${var.microk8s_instance_key}.pem ubuntu@${aws_spot_instance_request.microk8s_spot_instance.public_ip}"
}

output "private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}
