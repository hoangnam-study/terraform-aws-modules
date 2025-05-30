output "be_sg" {
  value = aws_security_group.be_sg
}

output "linux_default_user_password" {
  value     = random_password.random_password.result
  sensitive = true
}
