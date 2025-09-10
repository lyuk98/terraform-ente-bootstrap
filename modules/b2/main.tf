terraform {
  required_providers {
    b2 = {
      source  = "Backblaze/b2"
      version = "~> 0.10"
    }
  }
}

locals {
  # Capabilities of application keys for accessing Terraform state files
  state_key_capabilities = [
    "deleteFiles",
    "listBuckets",
    "listFiles",
    "readFiles",
    "writeFiles"
  ]
}

# Key for creating buckets (Backblaze B2)
resource "b2_application_key" "terraform_b2_ente" {
  capabilities = [
    "deleteBuckets",
    "deleteKeys",
    "listBuckets",
    "listKeys",
    "readBucketEncryption",
    "writeBucketEncryption",
    "writeBucketRetentions",
    "writeBuckets",
    "writeKeys"
  ]
  key_name = "terraform-b2-ente"
}

# Get information about the bucket to store state
data "b2_bucket" "terraform_state" {
  bucket_name = var.tfstate_bucket
}

# Key for accessing Terraform state (Museum)
resource "b2_application_key" "terraform_state_aws_museum" {
  capabilities = local.state_key_capabilities
  key_name     = "terraform-state-aws-museum"
  bucket_id    = data.b2_bucket.terraform_state.bucket_id
  name_prefix  = "terraform-aws-museum"
}

# Key for accessing Terraform state (PostgreSQL)
resource "b2_application_key" "terraform_state_scaleway_postgres_ente" {
  capabilities = local.state_key_capabilities
  key_name     = "terraform-state-scaleway-postgres-ente"
  bucket_id    = data.b2_bucket.terraform_state.bucket_id
  name_prefix  = "terraform-scaleway-postgres-ente"
}

# Key for accessing Terraform state (Backblaze B2)
resource "b2_application_key" "terraform_state_b2_ente" {
  capabilities = local.state_key_capabilities
  key_name     = "terraform-state-b2-ente"
  bucket_id    = data.b2_bucket.terraform_state.bucket_id
  name_prefix  = "terraform-b2-ente"
}
