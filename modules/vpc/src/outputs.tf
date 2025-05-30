# output "tmp" {
#   # value = local.app_az_order_number_map
#   value = aws_subnet.public_subnets

# }

output "vpc" {
  value = aws_vpc.vpc
}

output "azs" {
  value = local.app_azs
}

output "public_subnets" {
  value = aws_subnet.public_subnets
}

output "be_subnets" {
  value = aws_subnet.be_subnets
}

output "db_subnets" {
  value = aws_subnet.db_subnets
}
