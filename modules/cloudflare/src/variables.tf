variable "domain" {
  type        = string
  description = "The domain name to use for the static site"
}

variable "subdomain" {
  type        = string
  description = "The subdomain to set dns"
}

variable "ip" {
  type = string
}
variable "proxied" {
  type    = bool
  default = false
}
