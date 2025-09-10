terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.11"
    }
  }
}

# Used to get account ID
data "aws_caller_identity" "current" {}

# Used to get ARN of the OpenID Connect provider
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

# Policy for Terraform configuration (Museum)
resource "aws_iam_role_policy" "policy_aws_museum" {
  name = "terraform-aws-museum"
  role = aws_iam_role.role_aws_museum.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lightsail:DeleteInstance",
          "lightsail:PutInstancePublicPorts",
          "lightsail:StartInstance",
          "lightsail:StopInstance",
          "lightsail:DeleteKeyPair",
          "lightsail:RebootInstance",
          "lightsail:OpenInstancePublicPorts",
          "lightsail:CloseInstancePublicPorts",
          "lightsail:UpdateInstanceMetadataOptions"
        ]
        Resource = [
          "arn:aws:lightsail:*:${data.aws_caller_identity.current.account_id}:Instance/*",
          "arn:aws:lightsail:*:${data.aws_caller_identity.current.account_id}:KeyPair/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "lightsail:CreateKeyPair",
          "lightsail:ImportKeyPair",
          "lightsail:GetInstancePortStates",
          "lightsail:GetInstances",
          "lightsail:GetKeyPair",
          "lightsail:CreateInstances",
          "lightsail:GetInstance",
          "lightsail:GetKeyPairs"
        ]
        Resource = "*"
      }
    ]
  })
}

# Role to assume during deployment (Museum)
resource "aws_iam_role" "role_aws_museum" {
  name = "terraform-aws-museum"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = "${data.aws_iam_openid_connect_provider.github.arn}"
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = [
              "sts.amazonaws.com"
            ]
            "token.actions.githubusercontent.com:sub" = [
              "repo:lyuk98/terraform-aws-museum:ref:refs/heads/main"
            ]
          }
        }
      }
    ]
  })
}

# Role to assume during deployment (PostgreSQL)
resource "aws_iam_role" "role_scaleway_postgres_ente" {
  name = "terraform-scaleway-postgres-ente"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = "${data.aws_iam_openid_connect_provider.github.arn}"
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = [
              "sts.amazonaws.com"
            ]
            "token.actions.githubusercontent.com:sub" = [
              "repo:lyuk98/terraform-scaleway-postgres-ente:ref:refs/heads/main"
            ]
          }
        }
      }
    ]
  })
}

# Role to assume during deployment (Backblaze B2)
resource "aws_iam_role" "role_b2_ente" {
  name = "terraform-b2-ente"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = "${data.aws_iam_openid_connect_provider.github.arn}"
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = [
              "sts.amazonaws.com"
            ]
            "token.actions.githubusercontent.com:sub" = [
              "repo:lyuk98/terraform-b2-ente:ref:refs/heads/main"
            ]
          }
        }
      }
    ]
  })
}
