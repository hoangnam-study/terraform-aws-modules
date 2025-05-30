locals {
  root_device = one([for device in data.aws_ami.ubuntu_ami.block_device_mappings : device if device.device_name == "/dev/sda1"])
  # region      = "ap-southeast-1"
}
