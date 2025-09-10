terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.59"
    }
  }
}

# Get project details
data "scaleway_account_project" "ente" {
  name = "Ente"
}

# IAM application for setting up database
resource "scaleway_iam_application" "terraform_scaleway_postgres_ente" {
  name = "terraform-scaleway-postgres-ente"
}

# Policy for allowing modification of serverless SQL database and IAM applications
resource "scaleway_iam_policy" "terraform_scaleway_postgres_ente" {
  name           = "terraform-scaleway-postgres-ente"
  application_id = scaleway_iam_application.terraform_scaleway_postgres_ente.id
  rule {
    project_ids          = [data.scaleway_account_project.ente.project_id]
    permission_set_names = ["ServerlessSQLDatabaseFullAccess"]
  }
  rule {
    organization_id      = data.scaleway_account_project.ente.organization_id
    permission_set_names = ["IAMManager"]
  }
}

# API key for accessing the IAM user
resource "scaleway_iam_api_key" "terraform_scaleway_postgres_ente" {
  description        = "terraform-scaleway-postgres-ente"
  application_id     = scaleway_iam_application.terraform_scaleway_postgres_ente.id
  default_project_id = data.scaleway_account_project.ente.id
}
