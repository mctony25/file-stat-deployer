variable "app-name" {}
variable "default-region" {}
variable "environment-context" {}
variable "default-subnet" {}
variable "default-vpc" {}
variable "default-instance-count" {}
variable "default-instance-type" {}
variable "associate-public-ip" {}
variable "volume-default-size" {}
variable "volume-default-type" {}
variable "ecs-cluster-sg" {}
variable "ecs-cluster-security-group" {}

variable "default-ecs-ami-filter" {
  default = "amzn2-ami-ecs-hvm-2.0.*"
}
