output "lb_endpoint" {
  value = aws_lb.alb.dns_name
}

output "lb_arn" {
  value = aws_lb.alb.arn
}

output "lb_sg" {
  value = aws_security_group.alb_sg

}

output "target_group" {
  value = aws_lb_target_group.tg
}
