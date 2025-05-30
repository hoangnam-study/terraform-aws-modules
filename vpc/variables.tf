variable "cidr_block" {
  type        = string
  description = "cidr_block for the vpc"
  default     = "10.0.0.0/16"
}

variable "number_of_azs" {
  type        = number
  description = "number of availability zones to deploy the app"
  default     = 3

}
