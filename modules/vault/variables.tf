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

variable "b2_application_key_tfstate_ente" {
  type        = string
  description = "Application Key for accessing Terraform state"
  sensitive   = true
}

variable "b2_application_key_id_tfstate_ente" {
  type        = string
  description = "Application Key ID for accessing Terraform state"
  sensitive   = true
}

variable "aws_role_arn" {
  type        = string
  description = "ARN of the IAM role for Terraform"
  sensitive   = true
}
