variable "api-app-name" {
  description = "Name of the App"
  default = "file-stat-api"
}

variable "api-app-image" {
  description = "Docker image to run in the ECS cluster"
  default = "docker.io/mctony25/file-stat-api:latest"
}

variable "api-app-count" {
  description = "Number of containers instances to run"
  default = 1
}

variable "api-fargate-cpu" {
  description = "Instance CPU units to provision"
  default = "512"
}

variable "api-fargate-memory" {
  description = "Instance memory to provision"
  default = "1024"
}