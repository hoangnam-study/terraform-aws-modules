# get azs
data "aws_availability_zones" "azs" {
  state = "available"
}
