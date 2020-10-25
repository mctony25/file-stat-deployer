data "template_file" "ui_app" {
  template = file("../modules/server/template_files/file-stat-ui.json")

  vars = {
    app-name = var.ui_app_name
    ui-app-image = var.ui_app_image
    ui-app-port = var.ui_app_port
    fargate-cpu = var.ui_fargate_cpu
    fargate-memory = var.ui_fargate_memory
    aws-region = var.default-region
  }
}

resource "aws_ecs_task_definition" "ui_app" {
  family = "ui-ecs-task"
  execution_role_arn = aws_iam_role.ecs-task-role.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.ui_fargate_cpu
  memory = var.ui_fargate_memory
  container_definitions = data.template_file.ui_app.rendered

  tags = {
    Name = "${var.ui_app_name}-task-definition"
    Environment = var.environment-context
  }
}

resource "aws_ecs_service" "ui_app" {
  name = var.ui_app_name
  cluster = aws_ecs_cluster.aws-ecs.id
  task_definition = aws_ecs_task_definition.ui_app.arn
  desired_count = var.ui_app_count
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [var.ecs-cluster-sg.id]
    subnets = var.default-subnet.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.ui-app-tg.id
    container_name   = var.ui_app_name
    container_port   = var.ui_app_port
  }

  depends_on = [aws_alb_listener.front_end]

  tags = {
    Name = "${var.ui_app_name}-ecs-service"
    Environment = var.environment-context
  }
}

