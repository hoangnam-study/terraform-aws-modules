output "ip" {
  value = aws_instance.server.public_ip
}


output "ec2_sg" {
  value = aws_security_group.ec2_sg
}

