variable "environment" {
  description = "Deployment environment"
}

variable "public_subnets_cidr" {
  type = list
  description = "CIDR block/list for public subnet"
}

variable "private_subnets_cidr" {
  type = list
  description = "CIDR block/list for private subnet"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
}

variable "availability_zone" {
  type = list
  description = "List of Availability zones in which all resources to be deployed"
}

variable "region" {
  description = "region"
  default = "us-east-1"
}