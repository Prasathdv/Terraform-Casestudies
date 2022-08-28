# Step01 : Create a VPC
resource "aws_vpc" "vpc-demo-02" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
      Name = "${var.environment}-vpc"
      Environment = var.environment
  }
}

# Step02 : Two subnets within same VPC (Public & Private)
# Public Subnet
resource "aws_subnet" "public-subnet-demo-02" {
  vpc_id = aws_vpc.vpc-demo-02.id
  count = length(var.public_subnets_cidr)
  cidr_block = element(var.public_subnets_cidr, count.index)
  availability_zone = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true
  
  tags = {
      Name = "${var.environment}-${element(var.availability_zone, count.index)}-public-subnet"
      Environment = var.environment
  }
}

# Private subnet
resource "aws_subnet" "private-subnet-demo-02" {
  vpc_id = aws_vpc.vpc-demo-02.id
  count = length(var.private_subnets_cidr)
  cidr_block = element(var.private_subnets_cidr, count.index)
  availability_zone = element(var.availability_zone, count.index)
  map_public_ip_on_launch = false

  tags = {
      Name = "${var.environment}-${element(var.availability_zone, count.index)}-private-subnet"
      Environment = var.environment
  }
}

# Step03: Attach a internet gateway to the VPC
resource "aws_internet_gateway" "ig-demo-02" {
  vpc_id = aws_vpc.vpc-demo-02.id
  tags = {
    Name = "${var.environment}-igw"
    Environment = var.environment
  }
}

# Step04: NAT Gateway to be attached to Public Subnet
# Step04a: To create NAT gateway , create EIP and attach it to IGW first.
resource "aws_eip" "eipnat-demo-02" {
  vpc = true
  depends_on = [aws_internet_gateway.ig-demo-02]
}
# Step04b: Create NAT gateway.
resource "aws_nat_gateway" "natgw-demo-02" {
  allocation_id = aws_eip.eipnat-demo-02.id
  subnet_id = element(aws_subnet.public-subnet-demo-02.*.id, 0)

  tags = {
    Name = "${var.environment}-nat"
    Environment = var.environment
  }
}

# Step05: Route table creation for each subnet
# Step05a: Create RT, Route and RT association for public subnet
resource "aws_route_table" "public-rt-demo-02" {
 vpc_id =  aws_vpc.vpc-demo-02.id
 tags = {
   Name = "${var.environment}-public-route-table"
   Environment = var.environment
 }
}
resource "aws_route" "public-route-igw-02" {
  route_table_id = aws_route_table.public-rt-demo-02.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig-demo-02.id
}
resource "aws_route_table_association" "public-rta-02" {
  count = length(var.public_subnets_cidr)
  subnet_id = element(aws_subnet.public-subnet-demo-02.*.id, count.index)
  route_table_id = aws_route_table.public-rt-demo-02.id
}

# Step05b: Create RT, Route and RT association for private subnet
resource "aws_route_table" "private-rt-demo-02" {
 vpc_id =  aws_vpc.vpc-demo-02.id
 tags = {
   Name = "${var.environment}-private-route-table"
   Environment = var.environment
 }
}
resource "aws_route" "private-route-igw-02" {
  route_table_id = aws_route_table.private-rt-demo-02.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig-demo-02.id
}
resource "aws_route_table_association" "private-rta-02" {
  count = length(var.private_subnets_cidr)
  subnet_id = element(aws_subnet.private-subnet-demo-02.*.id, count.index)
  route_table_id = aws_route_table.private-rt-demo-02.id
}

# Step06: Create a security group
resource "aws_security_group" "sg-demo-02" {
  name = "${var.environment}-sg"
  description = "sg to allow traffic from VPC"
  vpc_id = aws_vpc.vpc-demo-02.id
  depends_on = [
    aws_vpc.vpc-demo-02
  ]

  ingress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    self = true
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    self = true
  }

  tags = {
    Environment = var.environment
  }
}