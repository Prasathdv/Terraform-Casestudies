variable "region" {
  default = "us-east-1"
}

variable "amz_ami" {
  default = "ami-090fa75af13c156b4"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "environment" {
  description = "deployment environment"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type    = list(any)
  default = ["10.0.1.0/24"]
}

variable "private_subnets_cidr" {
  type    = list(any)
  default = ["10.0.10.0/24"]
}