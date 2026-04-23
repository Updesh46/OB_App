variable "infra" {
  description = "Complete infrastructure config"
  type        = map(any)
}

variable "subnet_id" {
  description = "Subnet IDs map for private endpoints"
  type        = map(string)
}

variable "vnet_id" {
  description = "Virtual Network IDs map"
  type        = map(string)
}

variable "key_vault_id" {
  description = "Key Vault IDs map for reading secrets"
  type        = map(string)
}
