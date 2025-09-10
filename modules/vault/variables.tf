variable "b2_application_key" {
  type        = string
  description = "Application Key for Backblaze B2"
  sensitive   = true
}

variable "b2_application_key_id" {
  type        = string
  description = "Application Key ID for Backblaze B2"
  sensitive   = true
}

variable "scaleway_access_key" {
  type        = string
  description = "Access key for Scaleway (PostgreSQL)"
  sensitive   = true
}

variable "scaleway_secret_key" {
  type        = string
  description = "Secret key for Scaleway (PostgreSQL)"
  sensitive   = true
}

variable "b2_application_key_tfstate_aws_museum" {
  type        = string
  description = "Application Key for accessing Terraform state (Museum)"
  sensitive   = true
}

variable "b2_application_key_id_tfstate_aws_museum" {
  type        = string
  description = "Application Key ID for accessing Terraform state (Museum)"
  sensitive   = true
}

variable "b2_application_key_tfstate_scaleway_postgres_ente" {
  type        = string
  description = "Application Key for accessing Terraform state (PostgreSQL)"
  sensitive   = true
}

variable "b2_application_key_id_tfstate_scaleway_postgres_ente" {
  type        = string
  description = "Application Key ID for accessing Terraform state (PostgreSQL)"
  sensitive   = true
}

variable "b2_application_key_tfstate_b2_ente" {
  type        = string
  description = "Application Key for accessing Terraform state (Backblaze B2)"
  sensitive   = true
}

variable "b2_application_key_id_tfstate_b2_ente" {
  type        = string
  description = "Application Key ID for accessing Terraform state (Backblaze B2)"
  sensitive   = true
}

variable "aws_role_aws_museum_arn" {
  type        = string
  description = "ARN of the IAM role for Museum"
  sensitive   = true
}

variable "aws_role_scaleway_postgres_ente_arn" {
  type        = string
  description = "ARN of the IAM role for PostgreSQL"
  sensitive   = true
}

variable "aws_role_b2_ente_arn" {
  type        = string
  description = "ARN of the IAM role for Backblaze B2"
  sensitive   = true
}
