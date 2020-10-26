data "template_file" "api_app" {
  template = file("../modules/server/template_files/file-stat-api.json")

  vars = {
    app-name = var.api-app-name
    api-app-image = var.api-app-image
    api-app-port = var.api-open-port
    fargate-cpu = var.api-fargate-cpu
    fargate-memory = var.api-fargate-memory
    aws-region = var.default-region
  }
}

resource "aws_ecs_task_definition" "api_app" {
  family = "api-ecs-task"
  execution_role_arn = aws_iam_role.ecs-task-role.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.api-fargate-cpu
  memory = var.api-fargate-memory
  container_definitions = data.template_file.api_app.rendered

  tags = {
    Name = "${var.api-app-name}-task-definition"
    Environment = var.environment-context
  }

}

resource "aws_ecs_service" "api_app" {
  name = var.api-app-name
  cluster = aws_ecs_cluster.aws-ecs.id
  task_definition = aws_ecs_task_definition.api_app.arn
  desired_count = var.api-app-count
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [var.ecs-cluster-sg.id]
    subnets = var.default-subnet.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.api-app-tg.id
    container_name   = var.api-app-name
    container_port   = var.api-open-port
  }

  depends_on = [aws_alb_listener.api-lb-listener]

  tags = {
    Name = "${var.api-app-name}-ecs-service"
    Environment = var.environment-context
  }
}

