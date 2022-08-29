# vpc
resource "aws_vpc" "vpc-layer-demo" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Name = "${var.env}-vpc"
    Environment = var.env
  }
}

# Public Subnet
resource "aws_subnet" "public-subnet-layer-demo" {
  vpc_id = aws_vpc.vpc-layer-demo.id
  count = length(var.public_subnets_cidr)
  cidr_block = var.public_subnets_cidr[count.index]
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-${count.index+1}"
    Environment = var.env
  }
}

# Private Subnet
resource "aws_subnet" "private-subnet-layer-demo" {
  vpc_id = aws_vpc.vpc-layer-demo.id
  count = length(var.private_subnets_cidr)
  cidr_block = var.private_subnets_cidr[count.index]
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-private-${count.index+1}"
    Environment = var.env
  }
}

# Internet Gateway
resource "aws_internet_gateway" "ig-layer-demo" {
  vpc_id = aws_vpc.vpc-layer-demo.id

  tags = {
    Name = "${var.env}-ig-demo"
    Environment = var.env
  }
}

# Elastic IP creation
resource "aws_eip" "eip-layer-demo" {
  vpc = true
  count = length(var.public_subnets_cidr)

  tags = {
    Name = "${var.env}-${count.index + 1}"
    Environment = var.env
  }
}

# NAT Gateway
resource "aws_nat_gateway" "natgw-layer-demo" {
  count = length(var.public_subnets_cidr)

  allocation_id = aws_eip.eip-layer-demo.id
  subnet_id = aws_subnet.public-subnet-layer-demo[count.index].id

  tags = {
      Name = "${var.env}-${count.index + 1}"
      Environment = var.env
  }
}

# Route table - Public
resource "aws_route_table" "public-route-layer-demo" {
  vpc_id = aws_vpc.vpc-layer-demo.id

  count = length(var.public_subnets_cidr)

  tags = {
    Name = "${var.env}-${count.index + 1}"
  }
}
resource "aws_route" "public-rt" {
  route_table_id = aws_route_table.public-route-layer-demo.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig-layer-demo.id
}
resource "aws_route_table_association" "public-rta-layer-demo" {
  count = length(var.public_subnets_cidr)
  subnet_id = aws_subnet.public-subnet-layer-demo[count.index].id
  route_table_id = aws_route_table.public-route-layer-demo.id
}
