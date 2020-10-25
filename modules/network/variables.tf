variable "app-name" {}
variable "environment-context" {}

variable "main-vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "main-subnet-cidr" {
  default = "10.0.1.0/24"
}