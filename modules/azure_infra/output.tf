output "container_app_environment_id" {
  value = azurerm_container_app_environment.this.id
}

output "resource_group_name" {
  value = local.rg_name
}

output "resource_group_id" {
  value = local.rg_id
}

output "resource_group_location" {
  value = local.rg_location
}
