output "default-vpc" {
  description = "Main VPC id"
  value = aws_vpc.main-vpc
}

output "default-subnet" {
  description = "Main Subnet id"
  value = aws_subnet.main-subnet
}

output "ecs-cluster-security-group" {
  description = "ECS Cluster default security group"
  value = aws_security_group.ecs-cluster-security-group
}