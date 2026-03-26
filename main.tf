provider "aws" {
  region = "us-east-2"
}

// TO-DO
# make two private subnets
# put one private subnet in each availability zone (us-east-2a and us-east-2b)

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