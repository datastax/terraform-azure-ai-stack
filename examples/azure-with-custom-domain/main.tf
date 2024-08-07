provider "astra" {
  token = var.astra_token
}

provider "azurerm" {
  features {}
}

module "datastax-ai-stack-azure" {
  source = "./../.."

  resource_group_config = {
    create_resource_group = {
      name     = "datastax-ai-stack"
      location = "East US"
    }
  }

  domain_config = {
    auto_azure_dns_setup = true
    dns_zones = {
      default = { dns_zone = var.dns_zone }
    }
  }

  langflow = {
    subdomain = "langflow"
    postgres_db = {
      sku_name = "B_Standard_B1ms"
    }
  }

  assistants = {
    subdomain = "assistants"
    astra_db = {
      deletion_protection = false
    }
  }

  vector_dbs = [{
    name                = "my_db"
    keyspaces           = ["main_keyspace", "other_keyspace"]
    deletion_protection = false
  }]
}
