data "template_file" "api_app" {
  template = file("../modules/server/template_files/file-stat-api.json")

  vars = {
    app-name = var.api_app_name
    api-app-image = var.api_app_image
    api-app-port = var.api_app_port
    fargate-cpu = var.api_fargate_cpu
    fargate-memory = var.api_fargate_memory
    aws-region = var.default-region
  }
}

resource "aws_ecs_task_definition" "api_app" {
  family = "api-ecs-task"
  execution_role_arn = aws_iam_role.ecs-task-role.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.api_fargate_cpu
  memory = var.api_fargate_memory
  container_definitions = data.template_file.api_app.rendered

  tags = {
    Name = "${var.api_app_name}-task-definition"
    Environment = var.environment-context
  }
}

resource "aws_ecs_service" "api_app" {
  name = var.api_app_name
  cluster = aws_ecs_cluster.aws-ecs.id
  task_definition = aws_ecs_task_definition.api_app.arn
  desired_count = var.api_app_count
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [var.ecs-cluster-sg.id]
    subnets = var.default-subnet.*.id
    assign_public_ip = true
  }

  service_registries {
    registry_arn = ""
  }

  tags = {
    Name = "${var.api_app_name}-ecs-service"
    Environment = var.environment-context
  }
}

