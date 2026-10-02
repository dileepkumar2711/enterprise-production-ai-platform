variable "location" {
  description = "Azure region for platform resources"
  type        = string
  default     = "Central India"
}

variable "project_name" {
  description = "Project name used for Azure resource naming"
  type        = string
  default     = "production-ai"
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

variable "aks_node_count" {
  description = "Initial AKS system node count"
  type        = number
  default     = 2
}

variable "aks_vm_size" {
  description = "VM size for the AKS system node pool"
  type        = string
  default     = "Standard_D2s_v5"
}