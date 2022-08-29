resource "aws_s3_bucket" "s3-iam-ec2-demo" {
  bucket = aws_instance.iam-demo-ec2vm.id

  tags = {
    "Name" = "demo-iam-ec2-s3bucket"
  }
}

resource "aws_s3_bucket_acl" "s3-acl" {
  bucket = aws_s3_bucket.s3-iam-ec2-demo.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "s3-versioning" {
  bucket = aws_s3_bucket.s3-iam-ec2-demo.id
  versioning_configuration {
    status = "Enabled"
  }
}