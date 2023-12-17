
variable "env" {
  description = "Development environment"
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "secrets" {
  description = "List of secret names to create"
  default     = []
}
