variable "vm_name" {
  type = string

}

variable "image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "disk_type" {
  type    = string
  default = "pd-ssd"
}

variable "ssh_pubkey_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}
