#  Step 01 : Create a VPC
resource "aws_vpc" "vpc-demo" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_classiclink   = false
  instance_tenancy     = "default"
  tags = {
    "Name" = "vpc-demo-networking"
  }
}

# Step 02: Two subnets within same VPC (Public & Private)
# Public Subnet
# map_public_ip_on_launch: This is so important. The only difference between private and public subnet is this line. If it is true, it will be a public subnet, otherwise private.
resource "aws_subnet" "public-subnet-demo" {
  vpc_id                  = aws_vpc.vpc-demo.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public-subnet-networking"
  }
}

# Private Subnet
resource "aws_subnet" "private-subnet-demo" {
  vpc_id            = aws_vpc.vpc-demo.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    "Name" = "private-subnet-networking"
  }
}

# Step 03: Attach a internet gateway to the VPC
resource "aws_internet_gateway" "ig-demo" {
  vpc_id = aws_vpc.vpc-demo.id
  tags = {
    "Name" = "ig-networking"
  }
}

# Step 04: NAT Gateway to be attached to Public Subnet
# We need Elastic IP, Public Subnet and Internet gateway to create NAT gateway for Public subnet

# Elastic IP
resource "aws_eip" "eip-public" {
  # instance = aws_instance.ec2-demo.id
  depends_on = [aws_internet_gateway.ig-demo]
  vpc        = true
}
# NAT Gateway - Public Subnet
resource "aws_nat_gateway" "nat-public-demo" {
  allocation_id = aws_eip.eip-public.id
  subnet_id     = element(aws_subnet.public-subnet-demo.*.id, 0)

  tags = {
    Name = "Public Subnet NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.ig-demo]
}

# Step 05: Route table creation for each subnet

# Step 05-a - Route table - Public
resource "aws_route_table" "rt-public-demo" {
  vpc_id = aws_vpc.vpc-demo.id
  tags = {
    Name = "route-table-public"
  }
}
# Create Public Route
resource "aws_route" "public-route-demo" {
  route_table_id         = aws_route_table.rt-public-demo.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig-demo.id
}
# Create Route table association with public subnet
resource "aws_route_table_association" "rt-association-public-demo" {
  subnet_id      = aws_subnet.public-subnet-demo.id
  route_table_id = aws_route_table.rt-public-demo.id
}


# Step 05-b - Route table - Private
resource "aws_route_table" "rt-private-demo" {
  vpc_id = aws_vpc.vpc-demo.id

  tags = {
    Name = "route-table-private"
  }
}
# Create Private Route
resource "aws_route" "private-route-demo" {
  route_table_id         = aws_route_table.rt-private-demo.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig-demo.id
}
# Create Route table association with private subnet
resource "aws_route_table_association" "rt-association-private-demo" {
  subnet_id      = aws_subnet.private-subnet-demo.id
  route_table_id = aws_route_table.rt-private-demo.id
}

# Create Security groups
resource "aws_security_group" "sg-demo" {
  name        = "sg_demo"
  description = "aws security group for this case study project"
  vpc_id      = aws_vpc.vpc-demo.id

  ingress = [{
    cidr_blocks      = [aws_vpc.vpc-demo.cidr_block]
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    description      = "ssh connectivity to ec2 instance"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = true
    },
    {
      cidr_blocks      = [aws_vpc.vpc-demo.cidr_block]
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      description      = "http connectivity to ec2 instance"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
  }]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    description      = "demo egress"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = true
  }]

  tags = {
    Name = "sg_demo"
  }
}