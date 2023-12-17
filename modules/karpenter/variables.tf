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

variable "node_group" {
  description = "EKS Node group"
}

variable "cluster_users" {
  description = "map of user ARNs and names"
}
