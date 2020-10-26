data "template_file" "ui_app" {
  template = file("../modules/server/template_files/file-stat-ui.json")

  vars = {
    app-name = var.ui-app-name
    ui-app-image = var.ui-app-image
    ui-app-port = var.ui-app-port
    fargate-cpu = var.ui-fargate-cpu
    fargate-memory = var.ui-fargate-memory
    aws-region = var.default-region
    api-host = aws_alb.api-main-lb.dns_name
    api-port = var.api-open-port
  }
}

resource "aws_ecs_task_definition" "ui_app" {
  family = "ui-ecs-task"
  execution_role_arn = aws_iam_role.ecs-task-role.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.ui-fargate-cpu
  memory = var.ui-fargate-memory
  container_definitions = data.template_file.ui_app.rendered

  tags = {
    Name = "${var.ui-app-name}-task-definition"
    Environment = var.environment-context
  }
}

resource "aws_ecs_service" "ui_app" {
  name = var.ui-app-name
  cluster = aws_ecs_cluster.aws-ecs.id
  task_definition = aws_ecs_task_definition.ui_app.arn
  desired_count = var.ui-app-count
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [var.ecs-cluster-sg.id]
    subnets = var.default-subnet.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.ui-app-tg.id
    container_name   = var.ui-app-name
    container_port   = var.ui-app-port
  }

  depends_on = [aws_alb_listener.ui-lb-listener]

  tags = {
    Name = "${var.ui-app-name}-ecs-service"
    Environment = var.environment-context
  }
}

