resource "aws_instance" "ec2-layer-demo" {
  ami = data.aws_ami.amazonlinuxami.id
  associate_public_ip_address = true
  instance_type = var.instance_type
  vpc_security_group_ids = [ "value" ]
  subnet_id = data.terraform_remote_state.level1.outputs.public_subnet_id[1]
  user_data = file("awscli.sh")


  tags = {
    Name = "ec2-layer-demo"
  }
}