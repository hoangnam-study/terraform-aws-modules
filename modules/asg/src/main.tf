resource "aws_launch_template" "launch_template" {
  description = "Launch template for ASG to launch EC2 web servers"

  image_id      = data.aws_ami.ubuntu_ami.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.be_sg.id]

  # key_name = aws_key_pair.deployer.key_name

  # iam_instance_profile {
  #   arn = aws_iam_instance_profile.ssm_instance_profile.arn
  # }

  block_device_mappings {
    device_name = local.root_device.device_name

    ebs {
      volume_size           = 10
      volume_type           = "gp3"
      delete_on_termination = "true"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = base64encode(templatefile("${path.module}/ec2-user-data.sh", { default_user_password : random_password.random_password.result }))
}

# random password
resource "random_password" "random_password" {
  length  = 32
  special = false
}

# key pair
# resource "aws_key_pair" "deployer" {
#   key_name_prefix = "deployer-key"
#   public_key      = tls_private_key.tls_key.public_key_openssh
# }

# resource "tls_private_key" "tls_key" {
#   algorithm = "ED25519"
# }

# resource "local_sensitive_file" "private_key" {
#   content  = tls_private_key.tls_key.private_key_pem
#   filename = "${path.module}/private_key.pem"
# }


# security group
resource "aws_security_group" "be_sg" {
  vpc_id      = var.vpc_id
  name_prefix = "be-sg"
}
resource "aws_vpc_security_group_ingress_rule" "be_sg_ingress_rule" {
  security_group_id            = aws_security_group.be_sg.id
  referenced_security_group_id = var.alb_sg_id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "be_sg_egress_rule" {
  security_group_id = aws_security_group.be_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

# auto scaling group
resource "aws_autoscaling_group" "asg" {
  max_size         = 3
  min_size         = 0
  desired_capacity = 1

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 0
      instance_warmup        = 300
    }
  }

  vpc_zone_identifier = var.subnet_ids

  health_check_grace_period = 300
  health_check_type         = "ELB"


}

# register to target group 
resource "aws_autoscaling_attachment" "attachment" {
  lb_target_group_arn    = var.target_group_arn
  autoscaling_group_name = aws_autoscaling_group.asg.name
}
