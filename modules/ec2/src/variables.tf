variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "root_volume_size" {
  type    = number
  default = 8
}

variable "root_volume_type" {
  type    = string
  default = "gp2"
}
