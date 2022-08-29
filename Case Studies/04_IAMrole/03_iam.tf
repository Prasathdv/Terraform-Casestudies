# Step01: Create IAM role
resource "aws_iam_role" "iam-role-demo" {
  name               = "iam-role-demo"
  assume_role_policy = file("./policies/assumerolepolicy.json")
}

# Step02: Create IAM Policy
resource "aws_iam_policy" "iam-policy-demo" {
  name   = "iam-polici-demo"
  policy = file("./policies/s3fullaccess.json")
}

# Step03: Attach IAM Role & Policy created previously
resource "aws_iam_policy_attachment" "policy-attachment-demo" {
  name       = "iam-policy-attachment-with-role"
  roles      = [aws_iam_role.iam-role-demo.name]
  policy_arn = aws_iam_policy.iam-policy-demo.arn
}

resource "aws_iam_instance_profile" "demo-profile-ec2" {
  role = aws_iam_role.iam-role-demo.name
}

