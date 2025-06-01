module "vpc" {
  source = "../../vpc/src"
}

module "test" {
  source     = "../src"
  vpc_id     = module.vpc.vpc.id
  subnet_ids = module.vpc.public_subnets
}
