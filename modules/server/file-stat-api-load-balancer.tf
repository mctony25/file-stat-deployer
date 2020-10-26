resource "aws_alb" "api-main-lb" {
  name = "${var.api-app-name}-load-balancer"
  subnets = var.default-subnet.*.id
  security_groups = [aws_security_group.api-main-lb-security-group.id]
  tags = {
    Name = "${var.api-app-name}-lb"
  }
}

resource "aws_alb_target_group" "api-app-tg" {
  name = "${var.api-app-name}-target-group"
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
    Name = "${var.api-app-name}-alb-target-group"
  }
}

resource "aws_alb_listener" "api-lb-listener" {
  load_balancer_arn = aws_alb.api-main-lb.id
  port = var.api-open-port
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.api-app-tg.id
    type = "forward"
  }
}

output "api-app-dns-lb" {
  description = "DNS load balancer"
  value = aws_alb.ui-main-lb.dns_name
}

resource "aws_security_group" "api-main-lb-security-group" {
  name = "${var.api-app-name}-load-balancer"
  description = "Controls access to the LB"
  vpc_id = var.default-vpc.id

  ingress {
    protocol = "tcp"
    from_port = var.api-open-port
    to_port = var.api-open-port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.api-app-name}-load-balancer"
  }
}

output "api-lb-dns-name" {
  description = "API DNS load balancer"
  value       = aws_alb.api-main-lb.dns_name
}

