# subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = var.subnet_ids
  tags = {
    Name = "Subnet group for db"
  }
}

# instance
resource "aws_db_instance" "db" {
  engine         = var.engine
  engine_version = var.engine_version
  multi_az       = var.multi_az

  instance_class        = var.instance_class
  allocated_storage     = 20
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  username = var.db_username
  password = coalesce(var.db_password, random_password.db_random_password.result)

  backup_retention_period = 3

  skip_final_snapshot = true

  lifecycle {
    ignore_changes = [password]
  }
}

# random password
resource "random_password" "db_random_password" {
  length  = 32
  special = false
}


# security group
resource "aws_security_group" "db_sg" {
  vpc_id      = var.vpc_id
  name_prefix = "db-sg-"
}
resource "aws_vpc_security_group_ingress_rule" "db_sg_ingress_rule" {
  for_each                     = toset(var.ingress-sg-id-list)
  security_group_id            = aws_security_group.db_sg.id
  referenced_security_group_id = each.value
  from_port                    = aws_db_instance.db.port
  to_port                      = aws_db_instance.db.port
  ip_protocol                  = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "db_sg_egress_rule" {
  security_group_id = aws_security_group.db_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

