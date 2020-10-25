resource "aws_security_group" "ecs-cluster-security-group" {
  name = "${var.app-name}-ecs-cluster-security-group"
  description = "${var.app-name}-ecs-cluster-security-group"
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.app-name}-ecs-cluster-security-group-${var.environment-context}"
    Environment = var.environment-context
    Role = "ecs-cluster"
  }

  ingress {
    description = "Allow inbound HTTP traffic from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.main-vpc-cidr]
  }

  ingress {
    description = "Allow inbound http traffic from VPC on port 5051"
    from_port = 5051
    to_port = 5051
    protocol = "tcp"
    cidr_blocks = [var.main-vpc-cidr]
  }

  ingress {
    description = "Allow inbound SSH traffic from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.main-vpc-cidr]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
