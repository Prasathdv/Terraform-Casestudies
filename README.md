# Terraform-Casestudies
## Case Study 01: Creation of basic network structure
1. Create a VPC
2. Two subnets within same VPC (Public & Private)
3. Attach a internet gateway to the VPC
4. NAT Gateway to be attached to Public Subnet
5. Route table creation for each subnet

## Case Study 02: Usage of meta-arg
1. make use of meta-arg length function to replace number counts in the previous created resources.

## Case Study 03: Data source
1. use data source concept to retrieve the AMI ID information
2. Create two EC2 instance based on it, one per subnet
3. one security group for each one of them & inbound traffic to be accepted only from your IP address

## Case Study 04: Creating S3 bucket via the EC2 created
1. create an IAM Role
2. create an IAM Policy
3. Attach IAM Role & Policy created previously
4. Get the IAM Role attached to EC2 instance
5. Connect to the EC2 instance & install AWS CLI
6. Try to create S3 bucket from EC2 instance
