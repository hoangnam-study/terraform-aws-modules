variable "vpc_id" {
  type        = string
  description = "the vpc this be lives"
}

variable "subnet_ids" {
  type        = list(string)
  description = "subnets to launch the be"
}

variable "alb_sg_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
