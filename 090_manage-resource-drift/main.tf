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
  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  tags = {
    Name = "Server"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "my-new-bucket-1823837392929"
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}