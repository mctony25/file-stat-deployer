data "template_file" "environment_var" {
  vars = {
    environment-name = "dev"
    app_name = "file-stat-app"
    default-region = "us-east-1"
  }
}

provider "aws" {
  region = data.template_file.environment_var.vars.default-region
}

module "main-vpc" {
  source = "../modules/network"
  environment-context = data.template_file.environment_var.vars.environment-name
  main-vpc-cidr = "10.3.0.0/16"
  app-name = data.template_file.environment_var.vars.app_name
}

module "main-cluster" {
  app-name = "file-stat-app"
  source = "../modules/server"
  environment-context = data.template_file.environment_var.vars.environment-name
  default-subnet = module.main-vpc.default-subnet
  default-vpc = module.main-vpc.default-vpc
  ecs-cluster-sg = module.main-vpc.ecs-cluster-security-group
  associate-public-ip = true
  default-instance-count = 1
  default-instance-type = "t2.micro"
  volume-default-size = 30
  volume-default-type = "gp2"
  default-region = data.template_file.environment_var.vars.default-region
  ecs-cluster-security-group = module.main-vpc.ecs-cluster-security-group
}