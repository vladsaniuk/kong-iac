variable "public_subnets" {
  description = "Map of AZ = CIDR block for public subnets"
  default = {
    us-east-1a = "10.0.0.0/19"
    us-east-1b = "10.0.32.0/19"
  }
}

variable "private_subnets" {
  description = "Map of AZ = CIDR block for private subnets"
  default = {
    us-east-1a = "10.0.128.0/19"
    us-east-1b = "10.0.160.0/19"
  }
}

variable "env" {
  description = "Development environment"
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
}

variable "disk_size" {
  description = "Node disk size"
  default     = 40
}

variable "instance_types" {
  description = "Node instance type"
  default     = ["t3.small"]
}


variable "desired_size" {
  description = "Node group desired size"
  default     = 1
}

variable "max_size" {
  description = "Node group max size"
  default     = 2
}

variable "min_size" {
  description = "Node group min size"
  default     = 1
}
