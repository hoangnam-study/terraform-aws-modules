module "vpc" {
  source = "../../modules/vpc/src"
}

module "alb" {
  source     = "../../modules/alb/src"
  vpc_id     = module.vpc.vpc.id
  subnet_ids = values(module.vpc.public_subnets)[*].id
}

module "asg" {
  source           = "../../modules/asg/src"
  vpc_id           = module.vpc.vpc.id
  subnet_ids       = values(module.vpc.be_subnets)[*].id
  alb_sg_id        = module.alb.lb_sg.id
  target_group_arn = module.alb.target_group.arn
}
