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

module "read_latency_higher_than_average_for_mongodb_host" {
  source    = "./modules/read_latency_higher_than_average_for_mongodb_host"

  providers = {
    shoreline = shoreline
  }
}