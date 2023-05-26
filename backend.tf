module "backend" {
  source = "./modules/backend"

  init = module.vars.env.init

  remote_name = "ce-tf-remote-store"
}
