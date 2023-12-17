variable "public_subnets_ids" {
  description = "Public subnets IDs from Network module"
}
variable "private_subnets_ids" {
  description = "Private subnets IDs from Network module"
}

variable "tags" {
  description = "Map of tags from root module"
}

variable "cluster_name" {
  description = "EKS cluster name"
}

variable "env" {
  description = "Development environment"
}

variable "k8s_version" {
  description = "EKS Kubernetes versions"
}
