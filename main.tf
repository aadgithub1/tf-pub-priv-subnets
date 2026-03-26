provider "aws" {
  region = "us-east-2"
}

// TO-DO
# make public route table
# associate public subnets with public route table
# point public route table to IGW
# 
# make private route table
# associate private subnets with private route table


resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.vpc-name
  }
}

resource "aws_subnet" "pub_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "pub_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "public-subnet-b"
  }
}

resource "aws_subnet" "priv_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "private-subnet-a"
  }
}

resource "aws_subnet" "priv_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "private-subnet-b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }

}

resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "priv_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "pub_subnet_a_assoc" {
  subnet_id      = aws_subnet.pub_subnet_a.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table_association" "pub_subnet_b_assoc" {
  subnet_id      = aws_subnet.pub_subnet_b.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table_association" "priv_subnet_a_assoc" {
  subnet_id      = aws_subnet.priv_subnet_a.id
  route_table_id = aws_route_table.priv_route_table.id
}

resource "aws_route_table_association" "priv_subnet_b_assoc" {
  subnet_id      = aws_subnet.priv_subnet_b.id
  route_table_id = aws_route_table.priv_route_table.id
}