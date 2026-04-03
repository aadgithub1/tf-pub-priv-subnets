provider "aws" {
  region = "us-east-2"
}

// TO-DO
# create EC2 instance in private subnet
# demonstrate that the public instance can access the internet
# demonstrate that the private instance cannot access the internet



resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.vpc-name
  }
}

resource "aws_subnet" "pub_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

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

resource "aws_security_group" "public_instance_sg" {
  name        = "public-instance-sg"
  description = "Allow HTTP from anywhere"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-instance-sg"
  }
}

resource "aws_instance" "public_instance" {
  ami                    = data.aws_ssm_parameter.al2023_ami.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.pub_subnet_a.id
  vpc_security_group_ids = [aws_security_group.public_instance_sg.id]

  user_data = <<-EOF
  #!/bin/bash
  # Update system packages
  yum update -y

  # Install Apache HTTP Server
  yum install -y httpd

  # Start and enable Apache to run on boot
  systemctl start httpd
  systemctl enable httpd

  # Create a simple Hello World HTML page
  echo "<html><body><h1>Hello World from EC2!</h1></body></html>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "public-instance"
  }
}
