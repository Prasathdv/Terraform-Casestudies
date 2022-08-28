locals {
  subnets = [aws_subnet.public-subnet-01.id, aws_subnet.public-subnet-02.id]
  sgs     = [aws_security_group.sg-datasource-public01.id, aws_security_group.sg-datasource-public02.id]
}

resource "aws_instance" "ec2-dataami-demo" {
  ami           = data.aws_ami.aws-ami-id.id
  instance_type = var.instance_type
  # Subnet
  count     = var.no_of_instance
  subnet_id = element(local.subnets, count.index)
  # Security Group
  vpc_security_group_ids = [element(local.sgs,count.index)]
  tags = {
    "Name" = "ec2-data-ami-demo-${count.index}"
  }
}