terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.37.0"
    }
  }

  required_version = ">=1.2"

  backend "s3" {
    bucket = "amzn-aaron-tf-state-bucket"
    key    = "network/terraform.tfstate"
    region = "us-east-2"
  }
}