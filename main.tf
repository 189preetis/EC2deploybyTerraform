terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
      
    }
  }
}

provider "aws" {
    region= "ap-south-1"
    access_key= "AKIAZGHG7QLF6I64XK7S"
    secret_key = "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"
}
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {}

resource "aws_key_pair" "key_pair" {
  key_name   = "var.key_name"
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
    content= tls_private_key.rsa_4096.private_key_pem
    filename = var.key_name
}

resource "aws_instance" "terraform" {
  ami           = "ami-0e35ddab05955cf57"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.key_pair.key_name

  tags = {
    Name = "terraform"
  }
}
