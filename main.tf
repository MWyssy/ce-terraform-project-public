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

module "vpc" {
  source = "./modules/vpc"

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
    key => subnet.az
    if subnet.public == "false"
  }
  public_subs = {
    for key, subnet in module.vars.env.subnets :
    key => subnet
    if subnet.public == "true"
  }

  #Tags
  user = module.vars.env.user

}

output "log" {
  value = module.vpc
}
