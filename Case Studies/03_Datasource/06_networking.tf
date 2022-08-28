resource "aws_vpc" "vpc-datasource" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-datasource"
  }
}

resource "aws_subnet" "public-subnet-01" {
  vpc_id                  = aws_vpc.vpc-datasource.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-subnet-01"
  }
}


resource "aws_subnet" "public-subnet-02" {
  vpc_id                  = aws_vpc.vpc-datasource.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-subnet-02"
  }
}

resource "aws_security_group" "sg-datasource-public01" {
  name   = "datasource-public01"
  vpc_id = aws_vpc.vpc-datasource.id
  depends_on = [
    aws_vpc.vpc-datasource
  ]

  ingress {
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["192.168.0.1/32"]
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  tags = {
    Name = "sg-datasource-demo-public01"
  }
}

resource "aws_security_group" "sg-datasource-public02" {
  name   = "datasource-public02"
  vpc_id = aws_vpc.vpc-datasource.id
  depends_on = [
    aws_vpc.vpc-datasource
  ]

  ingress {
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["192.168.0.1/32"]
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  tags = {
    Name = "sg-datasource-demo-public02"
  }
}