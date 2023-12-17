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

variable "cluster_users" {
  description = "map of user ARNs and names"
  default = [
    { ARN = "", username = "" }
  ]
  type = list(object({
    ARN      = string
    username = string
  }))
}
