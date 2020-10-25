data "aws_availability_zones" "aws-az" {
  state = "available"
}

resource "aws_vpc" "main-vpc" {
  cidr_block = var.main-vpc-cidr
  instance_tenancy = "default"

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
    Name = "${var.environment-context}-main-subnet"
    Environment = var.environment-context
  }
}

resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name        = "${var.app-name}-igw"
    Environment = var.environment-context
  }
}

resource "aws_route_table" "aws-route-table" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-igw.id
  }
  tags = {
    Name        = "${var.app-name}-route-table"
    Environment = var.environment-context
  }
}

resource "aws_main_route_table_association" "aws-route-table-association" {
  vpc_id         = aws_vpc.main-vpc.id
  route_table_id = aws_route_table.aws-route-table.id
}