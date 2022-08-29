# Terraform remote state

# Create S3 bucket
resource "aws_s3_bucket" "s3-remote-state-demo" {
  bucket = "terraform-remote-state-demo-082922"
}

# Create Terraform remote source
resource "aws_dynamodb_table" "terraform-remote-state" {
  name           = "terraform remote state"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}