resource "aws_security_group" "ecs-cluster-security-group" {
  name = "${var.app-name}-ecs-cluster-security-group"
  description = "${var.app-name}-ecs-cluster-security-group"
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.app-name}-ecs-cluster-security-group-${var.environment-context}"
    Environment = var.environment-context
  }

  ingress {
    description = "Allow inbound HTTP traffic from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow inbound http traffic from VPC on port 5150"
    from_port = var.api-open-port
    to_port = var.api-open-port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow inbound SSH traffic from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
