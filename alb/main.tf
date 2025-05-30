# alb
resource "aws_lb" "alb" {
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = var.subnet_ids
  enable_deletion_protection = false
  security_groups            = [aws_security_group.alb_sg.id]
}

# security group
resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id
}
resource "aws_vpc_security_group_ingress_rule" "alb_sb_ingress_rule_1" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "alb_sb_ingress_rule_2" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "alb_sg_egress_rule" {
  security_group_id = aws_security_group.alb_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

# listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Welcome!"
      status_code  = "200"
    }
  }
}

# listener rule
resource "aws_lb_listener_rule" "forward_all" {
  listener_arn = aws_lb_listener.http_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

# target group
resource "aws_lb_target_group" "tg" {
  name_prefix = "app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}

