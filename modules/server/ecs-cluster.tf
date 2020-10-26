data "template_file" "cluster_user_data" {
  template = file("../modules/server/template_files/cluster_user_data.sh")
  vars = {
    ecs_cluster = aws_ecs_cluster.aws-ecs.name
  }
}

resource "aws_ecs_cluster" "aws-ecs" {
  name = var.app-name
}