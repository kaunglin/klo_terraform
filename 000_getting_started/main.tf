terraform {
  cloud {
    organization = "Kaung-Lin-Oo"

    workspaces {
      name = "getting-started"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.25.0"
    }
  }
}

locals {
  project_name = "KaungLinOo"
}