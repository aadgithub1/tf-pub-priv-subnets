output "vpc-id" {
  value = aws_vpc.main.id
}

output "pub-subnet-a-id" {
  value = aws_subnet.pub_subnet_a.id
}

output "pub-subnet-b-id" {
  value = aws_subnet.pub_subnet_b.id
}

output "priv-subnet-a-id" {
  value = aws_subnet.priv_subnet_a.id
}

output "priv-subnet-b-id" {
  value = aws_subnet.priv_subnet_b.id
}