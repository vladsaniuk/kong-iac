variable "public_subnets" {
  description = "Map of AZ = CIDR block for public subnets"
}

variable "private_subnets" {
  description = "Map of AZ = CIDR block for private subnets"
}

variable "tags" {
  description = "Map of tags from root module"
}

variable "env" {
  description = "Development environment"
}

variable "cluster_name" {
  description = "EKS cluster name"
}
