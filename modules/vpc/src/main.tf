# vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
}

# igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# public subnets
resource "aws_subnet" "public_subnets" {
  for_each          = toset(local.app_azs)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value
  cidr_block        = cidrsubnet(var.cidr_block, 8, local.app_az_order_number_map[each.value])

  tags = {
    Name = "Public subnet ${local.app_az_order_number_map[each.value]}"
  }
}

# backend subnets
resource "aws_subnet" "be_subnets" {
  for_each          = toset(local.app_azs)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value
  cidr_block        = cidrsubnet(var.cidr_block, 8, local.app_az_order_number_map[each.value] + length(local.app_azs))

  tags = {
    Name = "Backend subnet ${local.app_az_order_number_map[each.value]}"
  }
}

# database subnets
resource "aws_subnet" "db_subnets" {
  for_each          = toset(local.app_azs)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value
  cidr_block        = cidrsubnet(var.cidr_block, 8, local.app_az_order_number_map[each.value] + length(local.app_azs) * 2)

  tags = {
    Name = "Database subnet ${local.app_az_order_number_map[each.value]}"
  }
}

# route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Public route table"
  }
}
resource "aws_route" "route_to_igw" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "public-route-table-association" {
  for_each       = aws_subnet.public_subnets
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = each.value.id
}
