# Keys

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.microk8s_instance_key
  public_key = tls_private_key.ssh_key.public_key_openssh
}


# VPC & Network

resource "aws_vpc" "microk8s_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "microk8s_vpc"
  }
}

resource "aws_route_table" "microk8s_route_table" {
  vpc_id = aws_vpc.microk8s_vpc.id
}

resource "aws_main_route_table_association" "main_route_table" {
  vpc_id         = aws_vpc.microk8s_vpc.id
  route_table_id = aws_route_table.microk8s_route_table.id
}

resource "aws_internet_gateway" "microk8s_igw" {
  vpc_id = aws_vpc.microk8s_vpc.id

  tags = {
    Name = "microk8s_igw"
  }
}

resource "aws_route" "microk8s_vpc_route" {
  route_table_id         = aws_route_table.microk8s_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.microk8s_igw.id
}

resource "aws_subnet" "microk8s_subnet" {
  vpc_id                  = aws_vpc.microk8s_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "microk8s_subnet"
  }
}

# Security Group

resource "aws_security_group" "microk8s_sg" {
  name        = "sg_microk8s"
  description = "MicroK8s server security group"
  vpc_id      = aws_vpc.microk8s_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "microk8s_sg"
  }
}

# AMI

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}

# Instance

resource "aws_instance" "microk8s_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3a.medium"
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.microk8s_sg.id]
  user_data              = templatefile("${path.module}/userdata.yaml", {})
  subnet_id              = aws_subnet.microk8s_subnet.id

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 25
  }
  
  tags = {
    Name = "microk8s_instance"
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.ssh_key.private_key_pem}' > ./'${var.microk8s_instance_key}'.pem
      chmod 400 ./'${var.microk8s_instance_key}'.pem
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm ./microk8s-instance-key.pem"
  }
}

