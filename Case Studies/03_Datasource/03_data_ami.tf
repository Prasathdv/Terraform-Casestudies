data "aws_ami" "aws-ami-id" {
  owners = ["amazon"]
    most_recent = true

  #   Filter by name
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220805.0*"]
  }

  #   Filter by hvm
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # Filter by Root device
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }


}
