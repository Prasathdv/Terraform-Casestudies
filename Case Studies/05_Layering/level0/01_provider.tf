terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.25.0"
    }
  }
  # backend "s3" {
  #   bucket         = "terraform-remote-state-demo-082922"
  #   key            = "remote/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-remote-state"
  #   profile = "default"
  # }
}

provider "aws" {
  region  = var.aws_region
  profile = "default"
}