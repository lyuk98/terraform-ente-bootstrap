terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.13"
    }
    b2 = {
      source  = "Backblaze/b2"
      version = "~> 0.10"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.3"
    }
  }
}

provider "aws" {}

provider "b2" {}

provider "vault" {}
