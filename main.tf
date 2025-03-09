terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.90.0"
    }
  }
  backend "s3" {
    bucket = "rocketseat-ci-iac"
    key    = "state/terraform.tfstate"
    region = var.aws_region
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform-state" {
  bucket        = "rocketseat-ci-iac"
  force_destroy = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    IAC = true
  }
}

resource "aws_s3_bucket_versioning" "terraform-state" {
  bucket = aws_s3_bucket.terraform-state.bucket
  versioning_configuration {
    status = "Enabled"
  }
}