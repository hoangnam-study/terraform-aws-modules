variable "vpc_id" {
  type        = string
  description = "the vpc this alb lives"
}

variable "subnet_ids" {
  type        = list(string)
  description = "subnets to launch the alb"
}
