resource "aws_alb" "ui-main-lb" {
  name = "${var.ui-app-name}-load-balancer"
  subnets = var.default-subnet.*.id
  security_groups = [aws_security_group.ui-main-lb-security-group.id]
  tags = {
    Name = "${var.ui-app-name}-lb"
  }
}

resource "aws_alb_target_group" "ui-app-tg" {
  name = "${var.ui-app-name}-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = var.default-vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold = "3"
    interval = "60"
    protocol = "HTTP"
    matcher = "200"
    timeout = "10"
    path = "/"
    unhealthy_threshold = "2"
  }
  tags = {
    Name = "${var.ui-app-name}-alb-target-group"
  }
}

resource "aws_alb_listener" "ui-lb-listener" {
  load_balancer_arn = aws_alb.ui-main-lb.id
  port = var.ui-app-port
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ui-app-tg.id
    type = "forward"
  }
}

output "ui-app-dns-lb" {
  description = "DNS load balancer"
  value = aws_alb.ui-main-lb.dns_name
}

resource "aws_security_group" "ui-main-lb-security-group" {
  name = "${var.ui-app-name}-load-balancer"
  description = "Controls access to the LB"
  vpc_id = var.default-vpc.id

  ingress {
    protocol = "tcp"
    from_port = var.ui-app-port
    to_port = var.ui-app-port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.ui-app-name}-load-balancer"
  }
}

output "ui-lb-dns-name" {
  description = "UI DNS load balancer"
  value       = aws_alb.ui-main-lb.dns_name
}

