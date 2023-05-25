terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

locals {
  environment = terraform.workspace
}

module "vars" {
  source      = "./modules/vars"
  environment = local.environment
}

module "s3" {
  source = "./modules/s3"

  init = module.vars.env.init
}

module "vpc" {
  source = "./modules/vpc"

  count = module.s3.init ? 0 : 1

  # VPC vars
  vpc_cidr = module.vars.env.vpc_cidr
  vpc_name = module.vars.env.vpc_name

  # Internet Gateway vars
  ig_name = module.vars.env.ig_name

  # Subnet vars
  subnets = module.vars.env.subnets

  # Nat Gateway vars
  private_subs = {
    for key, subnet in module.vars.env.subnets :
    key => subnet
    if subnet.public == "false"
  }
  nat_name = module.vars.env.nat_name

  # Route Table Vars
  rt_name = module.vars.env.rt_name

  public_subs = {
    for key, subnet in module.vars.env.subnets :
    key => subnet
    if subnet.public == "true"
  }

  # Security Group Vars
  sg_name = module.vars.env.sg_name

  #Tags
  user = module.vars.env.user

}

module "auto_scaling" {
  source = "./modules/auto_scaling"

  sg_id             = module.vpc[0].sg_id
  public_subnet_ids = module.vpc[0].public_subnet_ids
  vpc_id            = module.vpc[0].vpc_id

  lb_name          = module.vars.env.lb_name
  key_name         = module.vars.env.key_name
  launch_name      = module.vars.env.launch_name
  instance_type    = module.vars.env.instance_type
  tg_name          = module.vars.env.tg_name
  asg_name         = module.vars.env.asg_name
  min_size         = module.vars.env.min_size
  max_size         = module.vars.env.max_size
  desired_capacity = module.vars.env.desired_capacity

  #Tags
  user = module.vars.env.user
}

output "log" {
  value = module.vpc
}
