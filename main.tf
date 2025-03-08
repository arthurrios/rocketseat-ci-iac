terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.90.0"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = terraform.workspace == "default" ? "Admin" : null
}