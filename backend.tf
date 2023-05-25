module "backend" {
  source = "./modules/backend"

  init = module.vars.env.init
}
