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

module "vault" {
  source = "./modules/vault"

  b2_application_key                 = module.b2.application_key_b2
  b2_application_key_id              = module.b2.application_key_id_b2
  b2_application_key_tfstate_ente    = module.b2.application_key_tfstate_ente
  b2_application_key_id_tfstate_ente = module.b2.application_key_id_tfstate_ente
  aws_role_arn                       = module.aws.aws_role_arn
}
