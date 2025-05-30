output "db_endpoint" {
  value = aws_db_instance.db.endpoint
}

output "db_port" {
  value = aws_db_instance.db.port
}

output "db_sg" {
  value = aws_security_group.db_sg
}

output "db_username" {
  value = aws_db_instance.db.username
}

output "db_password" {
  value     = aws_db_instance.db.password
  sensitive = true
}
