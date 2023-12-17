data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket         = "vlad-sanyuk-tfstate-bucket-dev"
    key            = "cluster/${var.region}/terraform.tfstate"
    region         = var.region
    encrypt        = true
    dynamodb_table = "state_lock"
  }
}

module "karpenter" {
  source        = "../modules/karpenter"
  cluster_name  = var.cluster_name
  env           = var.env
  eks_oidc      = data.terraform_remote_state.cluster.outputs.eks_oidc
  node_group    = data.terraform_remote_state.cluster.outputs.node_group
  cluster_users = var.cluster_users
  tags          = local.tags
}
