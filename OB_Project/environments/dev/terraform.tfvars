infra = {
  dev = {
    location = "East US"
    rg_name  = "rg-dev"

    hub = {
      vnet_name     = "hub-vnet-dev"
      address_space = ["10.0.0.0/16"]
    }

    spoke = {
      vnet_name     = "spoke-vnet-dev-new"
      address_space = ["10.1.0.0/16"]
      subnet_name   = "aks-subnet"
    }

    private_endpoint = {
      subnet_name = "pe-subnet"
    }

    aks = {
      name       = "aks-dev"
      node_count = 1
      vm_size    = "Standard_DC2s_v3"
    }

    acr = {
      name = "acrdevupdesh01"
      sku  = "Basic"
    }

    keyvault = {
      name = "kv-dev-123"
    }

    monitoring = {
      name = "log-dev"
    }

    
    storage = {
      name = "stdev987654321"
    }

    agw = {
      name           = "agw-dev"
      sku_name       = "Standard_v2"
      sku_tier       = "Standard_v2"
      capacity       = 2
      public_ip_name = "agw-pip-dev"
    }
  }
}


