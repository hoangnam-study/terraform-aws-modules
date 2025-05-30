locals {
  app_azs = slice(data.aws_availability_zones.azs.names, 0, var.number_of_azs)
}

locals {
  app_az_order_number_map = zipmap(local.app_azs, range(0, length(local.app_azs)))
}
