output "amz-ami-id" {
  value = [data.aws_ami.aws-ami-id.id]
}