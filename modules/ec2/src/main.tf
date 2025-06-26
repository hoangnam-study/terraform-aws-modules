# key pair
resource "tls_private_key" "tls_key" {
  algorithm = "ED25519"
}
resource "aws_key_pair" "key_pair" {
  key_name_prefix = "tf-ec2-key-pair"
  public_key      = tls_private_key.tls_key.public_key_openssh
}

resource "local_sensitive_file" "private_key" {
  content  = tls_private_key.tls_key.private_key_openssh
  filename = "${path.root}/private_key"
}

# ec2 instances
resource "aws_instance" "server" {
  ami             = data.aws_ami.ubuntu_ami.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.key_pair.key_name
  security_groups = [aws_security_group.ec2_sg.name]

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = "true"

  }
}


# security group
resource "aws_security_group" "ec2_sg" {
  name_prefix = "tf-ec2-sg"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_internal" {
  security_group_id            = aws_security_group.ec2_sg.id
  referenced_security_group_id = aws_security_group.ec2_sg.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_http" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_https" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_ssh" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress_rule" {
  security_group_id = aws_security_group.ec2_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
