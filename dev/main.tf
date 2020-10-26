module "main-vpc" {
  source = "../modules/network"
  environment-context = var.environment-name
  main-vpc-cidr = var.main-vpc-cidr
  app-name = var.app_name
  api-open-port = var.api-open-port
}

module "main-cluster" {
  app-name = "file-stat-app"
  source = "../modules/server"
  environment-context = var.environment-name
  default-subnet = module.main-vpc.default-subnet
  default-vpc = module.main-vpc.default-vpc
  ecs-cluster-sg = module.main-vpc.ecs-cluster-security-group
  default-region = var.default-region
  ecs-cluster-security-group = module.main-vpc.ecs-cluster-security-group
  api-open-port = var.api-open-port
}