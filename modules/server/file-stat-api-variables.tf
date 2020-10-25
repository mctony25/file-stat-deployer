variable "api_app_name" {
  description = "Name of the App"
  default = "file-stat-api"
}

variable "api_app_image" {
  description = "Docker image to run in the ECS cluster"
  default = "docker.io/mctony25/file-stat-api:1.0.0"
}

variable "api_app_port" {
  description = "The port to expose of the Docker container"
  default = 5150
}

variable "api_app_count" {
  description = "Number of containers instances to run"
  default = 1
}

variable "api_fargate_cpu" {
  description = "Instance CPU units to provision"
  default = "512"
}

variable "api_fargate_memory" {
  description = "Instance memory to provision"
  default = "1024"
}