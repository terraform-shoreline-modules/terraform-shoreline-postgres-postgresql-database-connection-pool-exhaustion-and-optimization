terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "postgresql_database_connection_pool_exhaustion_and_optimization" {
  source    = "./modules/postgresql_database_connection_pool_exhaustion_and_optimization"

  providers = {
    shoreline = shoreline
  }
}