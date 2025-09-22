output "aws_role_arn" {
  value       = aws_iam_role.ente.arn
  description = "ARN of the IAM role for Terraform"
  sensitive   = true
}
