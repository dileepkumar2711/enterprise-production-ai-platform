variable "aws_region" {
  description = "AWS region used for the production AI platform"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name used to identify platform resources"
  type        = string
  default     = "enterprise-production-ai-platform"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
variable "vpc_cidr" {
  description = "CIDR block for the platform VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones used for high availability"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private application/EKS subnets"
  type        = list(string)
  default     = ["10.20.11.0/24", "10.20.12.0/24"]
}