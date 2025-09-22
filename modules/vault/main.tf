terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.3"
    }
  }
}

# Read Vault for Terraform state storage information
data "vault_kv_secret" "terraform_state" {
  path = "kv/ente/b2/tfstate-bootstrap"
}

# Application Key for Backblaze B2
resource "vault_kv_secret" "application_key_b2" {
  path = "kv/ente/b2/terraform-b2-ente"
  data_json = jsonencode({
    application_key    = var.b2_application_key,
    application_key_id = var.b2_application_key_id
  })
}

# Application Key for accessing Terraform state
resource "vault_kv_secret" "application_key_tfstate_ente" {
  path = "kv/ente/b2/tfstate-ente"
  data_json = jsonencode({
    application_key    = var.b2_application_key_tfstate_ente
    application_key_id = var.b2_application_key_id_tfstate_ente
  })
}

# Mount AWS authentication backend
data "vault_auth_backend" "aws" {
  path = "aws"
}

# Vault policy document (Vault token)
data "vault_policy_document" "auth_token" {
  rule {
    path         = "auth/token/create"
    capabilities = ["create", "update"]
    description  = "Allow creating child tokens"
  }
}

# Vault policy document (Terraform state)
data "vault_policy_document" "terraform_state" {
  rule {
    path         = data.vault_kv_secret.terraform_state.path
    capabilities = ["read"]
    description  = "Allow reading Terraform state information"
  }
  rule {
    path         = vault_kv_secret.application_key_tfstate_ente.path
    capabilities = ["read"]
    description  = "Allow reading B2 application key for writing Terraform state"
  }
}

# Vault policy document (Vault policy)
data "vault_policy_document" "acl" {
  rule {
    path         = "sys/policies/acl/museum"
    capabilities = ["create", "read", "update", "delete"]
    description  = "Allow creation of policy to access credentials for Museum"
  }
}

# Vault policy document (Museum)
data "vault_policy_document" "aws_museum" {
  rule {
    path         = "sys/mounts/auth/approle"
    capabilities = ["read"]
    description  = "Allow reading configuration of AppRole authentication method"
  }
  rule {
    path         = "kv/ente/aws/museum"
    capabilities = ["create", "read", "update", "delete"]
    description  = "Allow creation of credentials for Museum"
  }
  rule {
    path         = "kv/ente/cloudflare/certificate"
    capabilities = ["read"]
    description  = "Allow reading certificate and certificate key"
  }
  rule {
    path         = "auth/approle/role/museum"
    capabilities = ["create", "read", "update", "delete"]
    description  = "Allow creation of AppRole for Museum"
  }
  rule {
    path         = "auth/approle/role/museum/*"
    capabilities = ["create", "read", "update", "delete"]
    description  = "Allow access to AppRole information for Museum"
  }
}

# Vault policy document (Backblaze B2)
data "vault_policy_document" "b2_ente" {
  rule {
    path         = vault_kv_secret.application_key_b2.path
    capabilities = ["read"]
    description  = "Allow reading application key for Backblaze B2"
  }
  rule {
    path         = "kv/ente/b2/ente-b2"
    capabilities = ["create", "read", "update", "delete"]
    description  = "Allow creation of access credentials for Backblaze B2"
  }
}

# Policy to grant creation of child tokens
resource "vault_policy" "auth_token" {
  name   = "terraform-vault-auth-token-ente"
  policy = data.vault_policy_document.auth_token.hcl
}

# Policy to grant access to Terraform state information
resource "vault_policy" "terraform_state" {
  name   = "terraform-state-ente"
  policy = data.vault_policy_document.terraform_state.hcl
}

# Policy to grant creation of a Vault role
resource "vault_policy" "acl" {
  name   = "terraform-vault-acl-ente"
  policy = data.vault_policy_document.acl.hcl
}

# Policy to write (Museum)
resource "vault_policy" "aws_museum" {
  name   = "terraform-aws-museum"
  policy = data.vault_policy_document.aws_museum.hcl
}

# Policy to write (Backblaze B2)
resource "vault_policy" "b2" {
  name   = "terraform-b2-ente"
  policy = data.vault_policy_document.b2_ente.hcl
}

# Vault role for Terraform configurations
resource "vault_aws_auth_backend_role" "ente" {
  backend   = data.vault_auth_backend.aws.path
  role      = "terraform-ente"
  auth_type = "iam"
  token_policies = [
    vault_policy.auth_token.name,
    vault_policy.terraform_state.name,
    vault_policy.acl.name,
    vault_policy.aws_museum.name,
    vault_policy.b2.name
  ]
  bound_iam_principal_arns = [var.aws_role_arn]
}
