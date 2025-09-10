output "access_key_postgres_ente" {
  value       = scaleway_iam_api_key.terraform_scaleway_postgres_ente.access_key
  description = "Access key for Scaleway (PostgreSQL)"
  sensitive   = true
}

output "secret_key_postgres_ente" {
  value       = scaleway_iam_api_key.terraform_scaleway_postgres_ente.secret_key
  description = "Secret key for Scaleway (PostgreSQL)"
  sensitive   = true
}
