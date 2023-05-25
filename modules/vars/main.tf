locals {
  environments = {
    "staging" : local.staging,
    "production" : local.production,
    "default" : local.default
  }
}
