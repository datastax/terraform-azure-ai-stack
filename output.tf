output "container_app_fqdns" {
  value = {
    for component in [module.langflow, module.assistants] : component[0]["container_info"]["name"] => component[0]["fqdn"]
    if try(component[0]["fqdn"], null) != null
  }
}

output "astra_vector_dbs" {
  value = zipmap(concat(module.assistants[*].db_id, values(module.vector_dbs)[*].db_id), concat(module.assistants[*].db_info, values(module.vector_dbs)[*].db_info))
}
