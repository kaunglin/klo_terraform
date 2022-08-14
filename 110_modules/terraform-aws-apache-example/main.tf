data "aws_vpc" "main" {
  id = var.vpc-id
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
    cidr_blocks      = [var.myip_with_cidr]
    ipv6_cidr_blocks = []
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.myip_with_cidr]
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
  public_key = var.public_key
}

data "aws_ami" "amazon-linux-2" {
 	most_recent = true
	owners = ["amazon"]
	filter {
		name   = "owner-alias"
		values = ["amazon"]
	}
	filter {
		name   = "name"
		values = ["amzn2-ami-hvm*"]
	}
}

resource "aws_instance" "my_server" {
  ami           = "${data.aws_ami.amazon-linux-2.id}"
  instance_type = var.instance_type
  key_name = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  user_data = templatefile("${path.module}/userdata.yaml", {})

  tags = {
    Name = var.server_name
  }
}


