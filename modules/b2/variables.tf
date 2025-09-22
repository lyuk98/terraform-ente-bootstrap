variable "tfstate_bucket" {
  type        = string
  description = "Name of the bucket to store Terraform state"
  sensitive   = true
}
