output "application_key_b2" {
  value       = b2_application_key.terraform_b2_ente.application_key
  description = "Application Key for Backblaze B2 (Backblaze B2)"
  sensitive   = true
}

output "application_key_id_b2" {
  value       = b2_application_key.terraform_b2_ente.application_key_id
  description = "Application Key ID for Backblaze B2 (Backblaze B2)"
  sensitive   = true
}

output "application_key_tfstate_aws_museum" {
  value       = b2_application_key.terraform_state_aws_museum.application_key
  description = "Application Key for accessing Terraform state (Museum)"
  sensitive   = true
}

output "application_key_id_tfstate_aws_museum" {
  value       = b2_application_key.terraform_state_aws_museum.application_key_id
  description = "Application Key ID for accessing Terraform state (Museum)"
  sensitive   = true
}

output "application_key_tfstate_scaleway_postgres_ente" {
  value       = b2_application_key.terraform_state_scaleway_postgres_ente.application_key
  description = "Application Key for accessing Terraform state (PostgreSQL)"
  sensitive   = true
}

output "application_key_id_tfstate_scaleway_postgres_ente" {
  value       = b2_application_key.terraform_state_scaleway_postgres_ente.application_key_id
  description = "Application Key ID for accessing Terraform state (PostgreSQL)"
  sensitive   = true
}

output "application_key_tfstate_b2_ente" {
  value       = b2_application_key.terraform_state_b2_ente.application_key
  description = "Application Key for accessing Terraform state (Backblaze B2)"
  sensitive   = true
}

output "application_key_id_tfstate_b2_ente" {
  value       = b2_application_key.terraform_state_b2_ente.application_key_id
  description = "Application Key ID for accessing Terraform state (Backblaze B2)"
  sensitive   = true
}
