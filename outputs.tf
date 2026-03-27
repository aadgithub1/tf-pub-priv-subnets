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

output "igw-id" {
  value = aws_internet_gateway.igw.id
}

output "pub-route-table-id" {
  value = aws_route_table.pub_route_table.id
}

output "priv-route-table-id" {
  value = aws_route_table.priv_route_table.id
}

output "public-instance-id" {
  value = aws_instance.public_instance.id
}