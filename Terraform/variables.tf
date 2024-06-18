
variable "resource_group_name" {
  type        = string
  default     = "az102"
  description = "RG name in Azure"
}

variable "location" {
  type        = string
  default     = "East US"
  description = "Resource location on Azure"
}

variable "aks_name" {
  type        = string
  default     = "aks02"
  description = "Name of AKS"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.29.9"
  description = "Kubernetes version"
}

variable "dns_prefix" {
  type        = string
  default     = "aks"
  description = "Value for DNS prefix passed in main.tf"
}

