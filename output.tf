output "container_app_fqdns" {
  description = "A map of container apps to their fully-qualified domain names (if it exists)"
  value = {
    for component in [module.langflow, module.assistants] : component[0]["container_info"]["name"] => component[0]["fqdn"]
    if try(component[0]["fqdn"], null) != null
  }
}

output "astra_vector_dbs" {
  description = "A map of DB IDs => DB info for all of the dbs created (from the `assistants` module and the `vector_dbs` module)"
  value = zipmap(concat(module.assistants[*].db_id, values(module.vector_dbs)[*].db_id), concat(module.assistants[*].db_info, values(module.vector_dbs)[*].db_info))
}
