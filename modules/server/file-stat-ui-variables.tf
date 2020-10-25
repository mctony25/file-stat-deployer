variable "ui_app_name" {
  description = "Name of the App"
  default = "file-stat-ui"
}

variable "ui_app_image" {
  description = "Docker image to run in the cluster"
  default = "docker.io/mctony25/file-stat-ui:1.0.0"
}

variable "ui_app_port" {
  description = "The port to expose of the Docker container"
  default = 80
}

variable "ui_app_count" {
  description = "Number of containers instances to run"
  default = 1
}

variable "ui_fargate_cpu" {
  description = "Instance CPU units to provision"
  default = "512"
}

variable "ui_fargate_memory" {
  description = "Instance memory to provision"
  default = "1024"
}