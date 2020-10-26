data "aws_availability_zones" "aws-az" {
  state = "available"
}

resource "aws_vpc" "main-vpc" {
  cidr_block = var.main-vpc-cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.environment-context}-main-vpc"
    Environment = var.environment-context
  }
}

resource "aws_subnet" "main-subnet" {
  count = 2
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = cidrsubnet(aws_vpc.main-vpc.cidr_block, 8, count.index + 1)
  availability_zone = data.aws_availability_zones.aws-az.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment-context}-main-subnet-${count.index + 1}"
    Environment = var.environment-context
  }
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name        = "${var.app-name}-igw"
    Environment = var.environment-context
  }
}

resource "aws_route_table" "main-route-table" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
  tags = {
    Name        = "${var.app-name}-route-table"
    Environment = var.environment-context
  }
}

resource "aws_main_route_table_association" "main-route-table-association" {
  vpc_id         = aws_vpc.main-vpc.id
  route_table_id = aws_route_table.main-route-table.id
}