resource "aws_security_group" "sg-layer-demo" {
  name = "${var.env}-sg-demo"
  description = "Allows inbound traffic"
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id

  ingress  {
      description = "Allows inbound ssh traffic"
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["106.208.56.34/32"]
  }

  ingress {
      description = "Allows inbound http traffic"
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["106.208.56.34/32"]
  }

  egress {
      description = "Allows all outbound traffic"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-sg"
  }
}