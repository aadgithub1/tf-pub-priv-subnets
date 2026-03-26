provider "aws" {
  region = "us-east-2"
}

data "aws_ssm_parameter" "amzn-linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "web-server" {
  ami           = data.aws_ssm_parameter.amzn-linux.value
  instance_type = "t3.micro"

  tags = {
    Name = var.instance-name
  }
}