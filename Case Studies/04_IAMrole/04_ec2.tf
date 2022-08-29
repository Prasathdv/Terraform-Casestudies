# Step04: Get the IAM Role attached to EC2 instance
resource "aws_instance" "iam-demo-ec2vm" {
  ami                  = var.amz_ami
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.demo-profile-ec2.name
  #   Step05: Connect to the EC2 instance & install AWS CLI
  user_data = <<EOF
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
  EOF

  tags = {
    Name = "iam-ec2-role-attachment-demo"
  }
}

