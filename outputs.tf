output "instance-pub-ip" {
  value = aws_instance.web-server.public_ip
}