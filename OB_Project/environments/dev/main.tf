# Resource Group
module "rg" {
  source = "../../modules/resource_group"
  infra  = var.infra
}

# NETWORK (Hub-Spoke + Firewall + PE Subnet)
module "network" {
  depends_on = [module.rg]
  source     = "../../modules/network"
  infra      = var.infra
}

# APPLICATION GATEWAY
module "agw" {
  depends_on = [module.network]
  source     = "../../modules/application_gateway"
  infra      = var.infra

  subnet_id = module.network.agw_subnet_id
}

# STORAGE
module "storage" {
  depends_on = [ module.rg ]
  source = "../../modules/storage"
  infra  = var.infra
}

# Azure Container Registry (WITH PRIVATE ENDPOINT)
module "acr" {
  depends_on = [module.rg, module.network]
  source     = "../../modules/acr"
  infra      = var.infra

  subnet_id = module.network.private_endpoint_subnet_id
}

# Key Vault (WITH PRIVATE ENDPOINT)
module "keyvault" {
  depends_on = [ module.rg ]
  source = "../../modules/keyvault"
  infra  = var.infra

  subnet_id = module.network.private_endpoint_subnet_id
}

# MONITORING
module "monitoring" {
  depends_on = [module.rg, module.network, module.acr, module.keyvault, module.storage]
  source     = "../../modules/monitoring"
  infra      = var.infra
}

# AKS (with ACR + Monitoring)
module "aks" {
  depends_on = [module.rg, module.network, module.acr, module.keyvault, module.storage]
  source     = "../../modules/aks"
  infra      = var.infra

  acr_id           = module.acr.acr_id
  log_workspace_id = module.monitoring.log_workspace_id
}// ...existing code...

