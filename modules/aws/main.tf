terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.13"
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
resource "aws_iam_role_policy" "ente" {
  name = "terraform-ente"
  role = aws_iam_role.ente.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeAvailabilityZones"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "lightsail:AttachDisk",
          "lightsail:DeleteInstance",
          "lightsail:PutInstancePublicPorts",
          "lightsail:StartInstance",
          "lightsail:StopInstance",
          "lightsail:DeleteKeyPair",
          "lightsail:RebootInstance",
          "lightsail:OpenInstancePublicPorts",
          "lightsail:CloseInstancePublicPorts",
          "lightsail:DeleteDisk",
          "lightsail:DetachDisk",
          "lightsail:UpdateInstanceMetadataOptions"
        ]
        Resource = [
          "arn:aws:lightsail:*:${data.aws_caller_identity.current.account_id}:Disk/*",
          "arn:aws:lightsail:*:${data.aws_caller_identity.current.account_id}:KeyPair/*",
          "arn:aws:lightsail:*:${data.aws_caller_identity.current.account_id}:Instance/*"
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
          "lightsail:GetDisks",
          "lightsail:CreateDisk",
          "lightsail:CreateInstances",
          "lightsail:GetInstance",
          "lightsail:GetDisk",
          "lightsail:GetKeyPairs"
        ]
        Resource = "*"
      }
    ]
  })
}

# Role to assume during deployment (Terraform)
resource "aws_iam_role" "ente" {
  name = "terraform-ente"
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
              "repo:lyuk98/terraform-ente:ref:refs/heads/main"
            ]
          }
        }
      }
    ]
  })
}
