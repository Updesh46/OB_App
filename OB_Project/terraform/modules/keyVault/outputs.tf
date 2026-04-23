output "key_vault_id" {
  description = "Key Vault IDs"
  value = {
    for k, v in azurerm_key_vault.kv : k => v.id
  }
}

output "key_vault_uri" {
  description = "Key Vault URIs"
  value = {
    for k, v in azurerm_key_vault.kv : k => v.vault_uri
  }
}