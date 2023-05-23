terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.2.0"
}


provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "lab6_instance" {
  ami = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  key_name = "demo"
  security_groups = [aws_security_group.Lab6_SG.name]
  user_data = "${file("init.sh")}"
  tags = {
    Name = "Lab 6"
  }
}

resource "aws_key_pair" "TF_key" {
    key_name = "TF_key"
    public_key = tls_private_key.rsa.public_key_openssh

}
resource "local_file" "TF-key" {
    content = tls_private_key.rsa.private_key_pem
    filename = "tfkey"
}
resource "tls_private_key" "rsa" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_security_group" "Lab6_SG" {
  name = "Lab 6 sec group"
  description = "Description of lab 6 sec group"
  vpc_id = "vpc-0564e5a57d5d2fb16"
  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
      description = "SSH"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "Lab6_SG"
  }
}