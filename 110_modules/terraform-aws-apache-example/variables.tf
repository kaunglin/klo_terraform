variable "vpc-id" {
  type = string
}
variable "myip_with_cidr" {
  type = string
  description = "Provide your public IP address"
}
variable "public_key" {
  type = string
}
variable "server_name" {
  type = string
  default = "Apache Server Name"
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}