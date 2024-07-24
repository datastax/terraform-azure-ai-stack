resource "azurerm_resource_group" "this" {
  count    = var.resource_group_config.create_resource_group != null ? 1 : 0
  name     = var.resource_group_config.create_resource_group.name
  location = var.resource_group_config.create_resource_group.location
}

data "azurerm_resource_group" "this" {
  count = var.resource_group_config.create_resource_group == null ? 1 : 0
  name  = var.resource_group_config.resource_group_name
}

locals {
  rg_name     = try(data.azurerm_resource_group.this[0].name, azurerm_resource_group.this[0].name)
  rg_location = try(data.azurerm_resource_group.this[0].location, azurerm_resource_group.this[0].location)
  rg_id       = try(data.azurerm_resource_group.this[0].id, azurerm_resource_group.this[0].id)
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-datastax-ai"
  location            = local.rg_location
  resource_group_name = local.rg_name
}

resource "azurerm_container_app_environment" "this" {
  name                       = "cae-datastax-ai"
  location                   = local.rg_location
  resource_group_name        = local.rg_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
}
