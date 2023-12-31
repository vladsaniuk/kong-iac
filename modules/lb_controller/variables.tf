variable "cluster_name" {
  description = "EKS cluster name"
}

variable "env" {
  description = "Development environment"
}

variable "tags" {
  description = "Map of tags from root module"
}

variable "eks_oidc" {
  description = "EKS OIDC provider"
}
