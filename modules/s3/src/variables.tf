variable "bucket_prefix" {
  type    = string
  default = null
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "enable_versioning" {
  type    = bool
  default = false
}

variable "log_config" {
  type = object({
    enable            = bool
    log_bucket_prefix = string
  })
  default = {
    enable            = false
    log_bucket_prefix = null
  }
}
