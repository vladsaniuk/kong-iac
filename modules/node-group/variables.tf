variable "cluster_name" {
  description = "EKS cluster name"
}

variable "env" {
  description = "Development environment"
}

variable "tags" {
  description = "Map of tags from root module"
}

variable "private_subnets_ids" {
  description = "Private subnets IDs from Network module"
}

variable "disk_size" {
  description = "Node disk size"
}

variable "instance_types" {
  description = "Node instance type"
}

variable "desired_size" {
  description = "Node group desired size"
}

variable "max_size" {
  description = "Node group max size"
}

variable "min_size" {
  description = "Node group min size"
}
