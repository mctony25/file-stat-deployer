variable "app_name" {
  type = string
  description = "Application name"
}

variable "environment-name" {
  type = string
  description = "Application environment"
}

variable "main-vpc-cidr" {
  type = string
  description = "The main VPC CIDR"
}
variable "api-open-port" {}