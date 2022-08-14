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

resource "aws_s3_bucket" "bucket" {
  bucket = "test-bucket-depends-on"
  /*
  depends_on = [
    aws_instance.my_server
  ]
  */
}

resource "aws_instance" "my_server" { 
  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  depends_on = [
    aws_s3_bucket.bucket
  ]
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}