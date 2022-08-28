resource "aws_instance" "ec2-demo" {
  ami           = var.amz_ami
  instance_type = var.instance_type
  # Public Subnet
  subnet_id = aws_subnet.public-subnet-demo.id
  # Security Group
  vpc_security_group_ids = [aws_security_group.sg-demo.id]


  tags = {
    "Name" = "ec2-demo-networking"
  }
}