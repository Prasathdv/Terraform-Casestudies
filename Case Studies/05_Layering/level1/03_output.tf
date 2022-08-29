output "vpc_id" {
  value = aws_vpc.vpc-layer-demo.id
}

output "public-subnet-id" {
  value = aws_subnet.public-subnet-layer-demo.*.id
}

output "private-subnet-id" {
  value = aws_subnet.private-subnet-layer-demo.*.id
}

output "vpc-cidr-block" {
  value = aws_vpc.vpc-layer-demo.cidr_block
}
