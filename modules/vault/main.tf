terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.2"
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

# API key for Scaleway (PostgreSQL)
resource "vault_kv_secret" "api_key_scaleway_postgres_ente" {
  path = "kv/ente/scaleway/terraform-scaleway-postgres-ente"
  data_json = jsonencode({
    access_key = var.scaleway_access_key
    secret_key = var.scaleway_secret_key
  })
}

# Application Key for accessing Terraform state (Museum)
resource "vault_kv_secret" "application_key_tfstate_aws_museum" {
  path = "kv/ente/b2/tfstate-aws-museum"
  data_json = jsonencode({
    application_key    = var.b2_application_key_tfstate_aws_museum
    application_key_id = var.b2_application_key_id_tfstate_aws_museum
  })
}

# Application Key for accessing Terraform state (PostgreSQL)
resource "vault_kv_secret" "application_key_tfstate_scaleway_postgres_ente" {
  path = "kv/ente/b2/tfstate-scaleway-postgres-ente"
  data_json = jsonencode({
    application_key    = var.b2_application_key_tfstate_scaleway_postgres_ente
    application_key_id = var.b2_application_key_id_tfstate_scaleway_postgres_ente
  })
}

# Application Key for accessing Terraform state (Backblaze B2)
resource "vault_kv_secret" "application_key_tfstate_b2_ente" {
  path = "kv/ente/b2/tfstate-b2-ente"
  data_json = jsonencode({
    application_key    = var.b2_application_key_tfstate_b2_ente
    application_key_id = var.b2_application_key_id_tfstate_b2_ente
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
}

# Vault policy document (Museum)
data "vault_policy_document" "aws_museum" {
  rule {
    path         = "sys/mounts/auth/approle"
    capabilities = ["read"]
    description  = "Allow reading configuration of AppRole authentication method"
  }
  rule {
    path         = vault_kv_secret.application_key_tfstate_aws_museum.path
    capabilities = ["read"]
    description  = "Allow reading B2 application key for writing Terraform state (Museum)"
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
    path         = "sys/policies/acl/museum"
    capabilities = ["create", "read", "update", "delete"]
    description  = "Allow creation of policy to access Museum's credentials"
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

# Vault policy document (PostgreSQL)
data "vault_policy_document" "scaleway_postgres_ente" {
  rule {
    path         = vault_kv_secret.api_key_scaleway_postgres_ente.path
    capabilities = ["read"]
    description  = "Allow reading API key for Scaleway"
  }
  rule {
    path         = vault_kv_secret.application_key_tfstate_scaleway_postgres_ente.path
    capabilities = ["read"]
    description  = "Allow reading B2 application key for writing Terraform state (PostgreSQL)"
  }
  rule {
    path         = "kv/ente/scaleway/ente-scaleway-postgres"
    capabilities = ["create", "read", "update", "delete"]
    description  = "Allow creation of access credentials for PostgreSQL database"
  }
  rule {
    path         = "sys/policies/acl/ente-scaleway-postgres"
    capabilities = ["create", "read", "update", "delete"]
    description  = "Allow creation of policy to access PostgreSQL access credentials"
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
    path         = vault_kv_secret.application_key_tfstate_b2_ente.path
    capabilities = ["read"]
    description  = "Allow reading B2 application key for writing Terraform state (Backblaze B2)"
  }
  rule {
    path         = "kv/ente/b2/ente-b2"
    capabilities = ["create", "read", "update", "delete"]
    description  = "Allow creation of access credentials for Backblaze B2"
  }
  rule {
    path         = "sys/policies/acl/ente-b2"
    capabilities = ["create", "read", "update", "delete"]
    description  = "Allow creation of policy to access B2 credentials"
  }
}

# Policy to grant creation of child tokens
resource "vault_policy" "policy_auth_token" {
  name   = "terraform-vault-auth-token-ente"
  policy = data.vault_policy_document.auth_token.hcl
}

# Policy to grant access to Terraform state information
resource "vault_policy" "policy_terraform_state" {
  name   = "terraform-state-ente"
  policy = data.vault_policy_document.terraform_state.hcl
}

# Policy to write (Museum)
resource "vault_policy" "policy_aws_museum" {
  name   = "terraform-aws-museum"
  policy = data.vault_policy_document.aws_museum.hcl
}

# Policy to write (PostgreSQL)
resource "vault_policy" "policy_scaleway_postgres_ente" {
  name   = "terraform-scaleway-postgres-ente"
  policy = data.vault_policy_document.scaleway_postgres_ente.hcl
}

# Policy to write (Backblaze B2)
resource "vault_policy" "policy_b2" {
  name   = "terraform-b2-ente"
  policy = data.vault_policy_document.b2_ente.hcl
}

# Vault role for Terraform configurations specific to Amazon Web Services
resource "vault_aws_auth_backend_role" "role_aws_museum" {
  backend   = data.vault_auth_backend.aws.path
  role      = "terraform-aws-museum"
  auth_type = "iam"
  token_policies = [
    vault_policy.policy_auth_token.name,
    vault_policy.policy_terraform_state.name,
    vault_policy.policy_aws_museum.name
  ]
  bound_iam_principal_arns = [var.aws_role_aws_museum_arn]
}

# Vault role for Terraform configurations specific to Scaleway
resource "vault_aws_auth_backend_role" "role_scaleway_postgres_ente" {
  backend   = data.vault_auth_backend.aws.path
  role      = "terraform-scaleway-postgres-ente"
  auth_type = "iam"
  token_policies = [
    vault_policy.policy_auth_token.name,
    vault_policy.policy_terraform_state.name,
    vault_policy.policy_scaleway_postgres_ente.name
  ]
  bound_iam_principal_arns = [var.aws_role_scaleway_postgres_ente_arn]
}

# Vault role for Terraform configurations specific to Backblaze B2
resource "vault_aws_auth_backend_role" "role_b2_ente" {
  backend   = data.vault_auth_backend.aws.path
  role      = "terraform-b2-ente"
  auth_type = "iam"
  token_policies = [
    vault_policy.policy_auth_token.name,
    vault_policy.policy_terraform_state.name,
    vault_policy.policy_b2.name
  ]
  bound_iam_principal_arns = [var.aws_role_b2_ente_arn]
}
