resource "aws_alb" "main-lb" {
  name = "${var.ui_app_name}-load-balancer"
  subnets = var.default-subnet.*.id
  security_groups = [aws_security_group.aws-lb.id]
  tags = {
    Name = "${var.ui_app_name}-lb"
  }
}

resource "aws_alb_target_group" "ui-app-tg" {
  name = "${var.ui_app_name}-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = var.default-vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold = "3"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = "/"
    unhealthy_threshold = "2"
  }
  tags = {
    Name = "${var.ui_app_name}-alb-target-group"
  }
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main-lb.id
  port = var.ui_app_port
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ui-app-tg.id
    type = "forward"
  }
}

output "ui-app-dns-lb" {
  description = "DNS load balancer"
  value = aws_alb.main-lb.dns_name
}

resource "aws_security_group" "aws-lb" {
  name = "${var.ui_app_name}-load-balancer"
  description = "Controls access to the ALB"
  vpc_id = var.default-vpc.id

  ingress {
    protocol = "tcp"
    from_port = var.ui_app_port
    to_port = var.ui_app_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.ui_app_name}-load-balancer"
  }
}

resource "aws_security_group" "aws-ecs-tasks" {
  name = "${var.ui_app_name}-ecs-tasks"
  description = "Allow inbound access from the LB only"
  vpc_id = var.default-vpc.id

  ingress {
    protocol = "tcp"
    from_port = var.ui_app_port
    to_port = var.ui_app_port
    security_groups = [aws_security_group.aws-lb.id]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.ui_app_name}-ecs-tasks"
  }
}

output "ecs_cluster_runner_ip" {
  description = "External IP of ECS Cluster"
  value       = [aws_instance.ecs-cluster.*.public_ip]
}

