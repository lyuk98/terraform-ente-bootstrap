output "role_aws_museum_arn" {
  value       = aws_iam_role.role_aws_museum.arn
  description = "ARN of the IAM role for Museum"
  sensitive   = true
}

output "role_scaleway_postgres_ente_arn" {
  value       = aws_iam_role.role_scaleway_postgres_ente.arn
  description = "ARN of the IAM role for PostgreSQL"
  sensitive   = true
}

output "role_b2_ente_arn" {
  value       = aws_iam_role.role_b2_ente.arn
  description = "ARN of the IAM role for Backblaze B2"
  sensitive   = true
}
