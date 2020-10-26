variable "ui-app-name" {
  description = "Name of the App"
  default = "file-stat-ui"
}

variable "ui-app-image" {
  description = "Docker image to run in the cluster"
  default = "docker.io/mctony25/file-stat-ui:latest"
}

variable "ui-app-port" {
  description = "The port to expose of the Docker container"
  default = 80
}

variable "ui-app-count" {
  description = "Number of containers instances to run"
  default = 1
}

variable "ui-fargate-cpu" {
  description = "Instance CPU units to provision"
  default = "512"
}

variable "ui-fargate-memory" {
  description = "Instance memory to provision"
  default = "1024"
}