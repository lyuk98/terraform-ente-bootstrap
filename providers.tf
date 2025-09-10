terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.11"
    }
    b2 = {
      source  = "Backblaze/b2"
      version = "~> 0.10"
    }
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.59"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.2"
    }
  }
}

provider "aws" {}

provider "b2" {}

provider "scaleway" {}

provider "vault" {}
