provider "aws" {
  region  = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "aws" {
  region  = "eu-west-1"
  alias = "eu"
  access_key = var.access_key
  secret_key = var.secret_key
}