module "network" {
  source          = "../modules/network"
  cluster_name    = var.cluster_name
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  env             = var.env
  tags            = local.tags
}

module "eks" {
  source              = "../modules/eks"
  public_subnets_ids  = module.network.public_subnets_ids
  private_subnets_ids = module.network.private_subnets_ids
  cluster_name        = var.cluster_name
  k8s_version         = "1.28"
  env                 = var.env
  tags                = local.tags
}

module "node_group" {
  source              = "../modules/node-group"
  cluster_name        = var.cluster_name
  private_subnets_ids = module.network.private_subnets_ids
  disk_size           = var.disk_size
  instance_types      = var.instance_types
  desired_size        = var.desired_size
  max_size            = var.max_size
  min_size            = var.min_size
  env                 = var.env
  tags                = local.tags
}

module "add_ons" {
  source       = "../modules/add-ons"
  cluster_name = var.cluster_name
  env          = var.env
  tags         = local.tags

  depends_on = [
    module.node_group
  ]
}
