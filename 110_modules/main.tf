terraform {
  
}

provider "aws" {
  region = "us-east-1"
}

module "apache" {
  source = "./terraform-aws-apache-example"
  vpc-id = "vpc-0db41aeb0f0b7b160"
  myip_with_cidr = "0.0.0.0/0"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrrDqdCv/xawKP2A/zIpZ4sBYIr+58D7lL0O54IJjYOuApd2awwwt+XSrx6lPhqxxgPGJHODh4yMNj7KsK7o8gPwmERkgr5pttBVS6GnhGUXyW1V1jGPTZGkj8Q56wFM0cZ8oo/CSW4GK+LSeN/qbKHM0RXRlS9BoLPzdC3mw5hEUB5s9Hgr8ZrS+RchkNn3IgIHe91DUVLiZnlWzONJFWBxVLIMHLiM1zy8bNaUthDs0v+Yb4sD5BEV7/lasuV4ijmUzkEvnJycORtPokgAxg5u0Zd0Bq2sNH4pspFl9vV0YWeS+RKrbh/JwJxS7+WjLViqWfBUG0xtRwO220a+YVo0xMZ011ykLe/YaHea93NvJtHHf5OkGyVb5zf0WHJobisY/ZDQXjB76a+Z5N2LJvAAxVDLNGJy7SYseorahW3hdmyUi96KKAq1FzYQZ8ENptLw1O9eQKFkTyE1LH2dIJR1KVtz9cg+Mp0xpB24smlqJKp/SHDEwl+hsllkTYpKM= kaunglinoo@KLO-MacBook-Pro.local"
  server_name = "My Apache Server"
  instance_type = "t2.micro"
}

output "public_ip" {
  value = module.apache.public_ip
}