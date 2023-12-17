terraform {
  backend "s3" {}

  required_version = ">= 1.6.6"
}

locals {
  tags = {
    Project = "k8s-practice"
    Env     = var.env
  }
}
