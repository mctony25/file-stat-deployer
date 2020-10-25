data "aws_ami" "ecs-ami" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.default-ecs-ami-filter]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"]
}

data "template_file" "cluster_user_data" {
  template = file("../modules/server/template_files/cluster_user_data.sh")
  vars = {
    ecs_cluster = aws_ecs_cluster.aws-ecs.name
  }
}


resource "aws_ecs_cluster" "aws-ecs" {
  name = var.app-name
}

resource "aws_instance" "ecs-cluster" {
  ami = data.aws_ami.ecs-ami.id
  instance_type = var.default-instance-type
  subnet_id = var.default-subnet.*.id[0]
  vpc_security_group_ids = [var.ecs-cluster-security-group.id]
  count = var.default-instance-count
  associate_public_ip_address = var.associate-public-ip
  user_data = data.template_file.cluster_user_data.rendered
  iam_instance_profile = aws_iam_instance_profile.ecs-cluster-runner-profile.name

  volume_tags = {
    Name = "${var.environment-context}-${var.app-name}-ecs-cluster"
    Environment = var.environment-context
    Role = "ecs-cluster"
  }

  tags = {
    Name = "${var.environment-context}-${var.app-name}-ecs-cluster"
    Environment = var.environment-context
    Role = "ecs-cluster"
  }

  root_block_device {
    delete_on_termination = true
    volume_size = var.volume-default-size
    volume_type = var.volume-default-type
  }
}