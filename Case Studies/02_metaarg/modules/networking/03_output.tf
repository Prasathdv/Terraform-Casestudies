output "vpc_id" {
  value = aws_vpc.vpc-demo-02.id
}

output "public_subnets_id" {
  value = [aws_subnet.public-subnet-demo-02.*.id]
}

output "private_subnets_id" {
  value = [aws_subnet.private-subnet-demo-02.*.id]
}

output "security_group_id" {
  value = [aws_security_group.sg-demo-02.id]
}

output "public_route_table_id" {
  value = aws_route_table.public-rt-demo-02.id
}

