output "terraform_state" {
  value = {
    bucket   = data.vault_kv_secret.terraform_state.data.b2_bucket
    endpoint = data.vault_kv_secret.terraform_state.data.b2_endpoint
  }
  description = "Terraform state storage information"
}
