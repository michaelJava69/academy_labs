
##  Thios is written for tERRAFORM 0.13
## https://www.terraform.io/docs/configuration/provider-requirements.html#v0-12-compatible-provider-requirements
## In other words, Terraform v0.12.26 ignores the source argument and considers only the version argument, using the given local name as the un-namespaced provider type to install.



terraform {
  required_providers {
    gitinnov = {
      source  = "innovationnorway/git"
      version = "0.1.3"
    }
    gitpaul = {
      source  = "paultyng/git"
      version = "0.1.0"
    }
  }
}

data "git_repository" "this" {
  provider = gitinnov
  path     = "../.."
}

data "git_repository" "that" {
  provider = gitpaul
  path     = "../.."
}

