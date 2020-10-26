# Setup the AWS provider | provider.tf

terraform {
  required_version = ">= 0.13"
}

provider "aws" {
  version     = "~> 2.12"
  region      = var.default-region
  access_key  = var.aws-access-key
  secret_key  = var.aws-secret-key
}
