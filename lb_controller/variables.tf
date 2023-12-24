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
