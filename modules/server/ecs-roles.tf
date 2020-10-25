data "aws_caller_identity" "current" {}


# ecs cluster roles & policies
data "aws_iam_policy_document" "ecs-cluster-policy-document" {
  statement {
    actions = ["ec2:Describe*", "ecr:Describe*", "ecr:BatchGet*"]
    resources = ["*"]
  }
  statement {
    actions = ["ecs:*"]
    resources = ["arn:aws:ecs:${var.default-region}:${data.aws_caller_identity.current.account_id}:service/${var.app-name}/*"]
  }
}

resource "aws_iam_role" "ecs-cluster-role" {
  name = "${var.app-name}-cluster-runner-role"
  assume_role_policy = data.aws_iam_policy_document.instance-policy-document.json
}

resource "aws_iam_role_policy" "ecs-cluster-role-policy" {
  name = "${var.app-name}-cluster-policy"
  role = aws_iam_role.ecs-cluster-role.name
  policy = data.aws_iam_policy_document.ecs-cluster-policy-document.json
}

resource "aws_iam_instance_profile" "ecs-cluster-runner-profile" {
  name = "${var.app-name}-cluster-runner-iam-profile"
  role = aws_iam_role.ecs-cluster-role.name
}


# EC2 instance roles & policies
data "aws_iam_policy_document" "instance-policy-document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance-role" {
  name = "${var.app-name}-role"
  assume_role_policy = data.aws_iam_policy_document.instance-policy-document.json
}

resource "aws_iam_role_policy_attachment" "instance-role-policy-attachment" {
  role = aws_iam_role.instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


# ECS Task role & policy
data "aws_iam_policy_document" "ecs-task-policy-document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs-task-role" {
  name = "${var.app-name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs-task-policy-document.json
}

resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  role = aws_iam_role.ecs-task-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
