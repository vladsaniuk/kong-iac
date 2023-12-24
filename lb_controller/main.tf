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

module "aws_load_balancer_controller" {
  source       = "../modules/lb_controller"
  cluster_name = var.cluster_name
  env          = var.env
  eks_oidc     = data.terraform_remote_state.cluster.outputs.eks_oidc
  tags         = local.tags
}
