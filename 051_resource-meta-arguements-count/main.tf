terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.25.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "my_server" {
  count = 2
  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  tags = {
    Name = "Server-${count.index}"
  }
}

output "public_ip" {
  value = aws_instance.my_server[*].public_ip
}
