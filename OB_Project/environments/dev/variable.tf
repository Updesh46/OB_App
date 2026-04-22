variable "infra" {
  description = "Complete infrastructure config"
  type = map(object({
    location = string
    rg_name  = string

    hub = object({
      vnet_name     = string
      address_space = list(string)
    })

    

    spoke = object({
      vnet_name     = string
      address_space = list(string)
      subnet_name   = string
    })

    # 🔥 ADD THIS (IMPORTANT)
    private_endpoint = object({
      subnet_name = string
    })

    aks = object({
      name       = string
      node_count = number
      vm_size    = string
    })

    acr = object({
      name = string
      sku  = string
    })

    keyvault = object({
      name = string
    })

    monitoring = object({
      name = string
    })

    storage = object({
      name = string
    })

    agw = object({
      name            = string
      sku_name        = string
      sku_tier        = string
      capacity        = number
      public_ip_name  = string
    })
  }))
}


