output "application_key_b2" {
  value       = b2_application_key.terraform_b2_ente.application_key
  description = "Application Key for Backblaze B2"
  sensitive   = true
}

output "application_key_id_b2" {
  value       = b2_application_key.terraform_b2_ente.application_key_id
  description = "Application Key ID for Backblaze B2"
  sensitive   = true
}

output "application_key_tfstate_ente" {
  value       = b2_application_key.terraform_state_ente.application_key
  description = "Application Key for accessing Terraform state"
  sensitive   = true
}

output "application_key_id_tfstate_ente" {
  value       = b2_application_key.terraform_state_ente.application_key_id
  description = "Application Key ID for accessing Terraform state"
  sensitive   = true
}
