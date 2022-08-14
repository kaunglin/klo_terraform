terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.25.0"
    }
  }

}

provider "aws" {
  region = "us-east-1"
  profile = "tf-user"
}



data "aws_vpc" "main" {
  id = "vpc-0db41aeb0f0b7b160"
}

resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "MyServer Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrrDqdCv/xawKP2A/zIpZ4sBYIr+58D7lL0O54IJjYOuApd2awwwt+XSrx6lPhqxxgPGJHODh4yMNj7KsK7o8gPwmERkgr5pttBVS6GnhGUXyW1V1jGPTZGkj8Q56wFM0cZ8oo/CSW4GK+LSeN/qbKHM0RXRlS9BoLPzdC3mw5hEUB5s9Hgr8ZrS+RchkNn3IgIHe91DUVLiZnlWzONJFWBxVLIMHLiM1zy8bNaUthDs0v+Yb4sD5BEV7/lasuV4ijmUzkEvnJycORtPokgAxg5u0Zd0Bq2sNH4pspFl9vV0YWeS+RKrbh/JwJxS7+WjLViqWfBUG0xtRwO220a+YVo0xMZ011ykLe/YaHea93NvJtHHf5OkGyVb5zf0WHJobisY/ZDQXjB76a+Z5N2LJvAAxVDLNGJy7SYseorahW3hdmyUi96KKAq1FzYQZ8ENptLw1O9eQKFkTyE1LH2dIJR1KVtz9cg+Mp0xpB24smlqJKp/SHDEwl+hsllkTYpKM= kaunglinoo@KLO-MacBook-Pro.local"
}


resource "aws_instance" "my_server" {
  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  user_data = templatefile("${path.module}/userdata.yaml", {})
  /*
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
  */
  /*
  provisioner "remote-exec" {
    inline = [
      "echo ${self.private_ip} >> /home/ec2-user/private_ips"
    ]
    connection {
      type     = "ssh"
      user     = "ec2-user"
      host     = "${self.public_ip}"
      private_key = file("${path.module}/terraform")
    }
  }
  */
  provisioner "file" {
    content = "File testing from Kaung Lin Oo"
    destination = "/home/ec2-user/testing.txt"
    connection {
      type     = "ssh"
      user     = "ec2-user"
      host     = "${self.public_ip}"
      private_key = file("${path.module}/terraform")
    }
  }
  

  tags = {
    Name = "MyServer"
  }
}

resource "null_resource" "status" {
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.my_server.id}"
  }
  depends_on = [
    aws_instance.my_server
  ]
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}
