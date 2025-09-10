terraform {
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    region                      = "us-west-002"

    use_path_style = true
    key            = "terraform-ente-bootstrap.tfstate"
  }
}

module "aws" {
  source = "./modules/aws"
}

module "b2" {
  source         = "./modules/b2"
  tfstate_bucket = module.vault.terraform_state.bucket
}

module "scaleway" {
  source = "./modules/scaleway"
}

module "vault" {
  source = "./modules/vault"

  b2_application_key    = module.b2.application_key_b2
  b2_application_key_id = module.b2.application_key_id_b2

  scaleway_access_key = module.scaleway.access_key_postgres_ente
  scaleway_secret_key = module.scaleway.secret_key_postgres_ente

  b2_application_key_tfstate_aws_museum                = module.b2.application_key_tfstate_aws_museum
  b2_application_key_id_tfstate_aws_museum             = module.b2.application_key_id_tfstate_aws_museum
  b2_application_key_tfstate_scaleway_postgres_ente    = module.b2.application_key_tfstate_scaleway_postgres_ente
  b2_application_key_id_tfstate_scaleway_postgres_ente = module.b2.application_key_id_tfstate_scaleway_postgres_ente
  b2_application_key_tfstate_b2_ente                   = module.b2.application_key_tfstate_b2_ente
  b2_application_key_id_tfstate_b2_ente                = module.b2.application_key_id_tfstate_b2_ente

  aws_role_aws_museum_arn             = module.aws.role_aws_museum_arn
  aws_role_scaleway_postgres_ente_arn = module.aws.role_scaleway_postgres_ente_arn
  aws_role_b2_ente_arn                = module.aws.role_b2_ente_arn
}
