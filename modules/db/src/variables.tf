variable "vpc_id" {
  type        = string
  description = "the vpc this db lives"
}
variable "subnet_ids" {
  type        = list(string)
  description = "subnets to launch the db"
}

variable "ingress-sg-id-list" {
  type        = list(string)
  description = "list of sg ids that can connect to this db"
  default     = []
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "max_allocated_storage" {
  type    = number
  default = 30
}

variable "engine" {
  type    = string
  default = "postgres"
}

variable "engine_version" {
  type    = string
  default = null
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_username" {
  type    = string
  default = "rootuser"
}
variable "db_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "Optional DB password. If not set, a random password will be used."
}

