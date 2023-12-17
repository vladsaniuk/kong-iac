module "secrets" {
  for_each = toset(var.secrets)
  source   = "../modules/secrets"
  name     = each.key
  env      = var.env
  tags     = local.tags
}
