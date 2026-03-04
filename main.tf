provider "aws" {
  region = var.region
}

module "network" {
  source = "./modules/network"
  region = var.region
}

module "vault" {
  source          = "./modules/vault"
  bucket_name     = var.vault_bucket_name
  vpc_endpoint_id = module.network.s3_vpc_endpoint_id
}

module "security" {
  source      = "./modules/security"
  bucket_arn  = module.vault.bucket_arn
  bucket_name = var.vault_bucket_name
}

module "monitoring" {
  source      = "./modules/monitoring"
  bucket_arn  = module.vault.bucket_arn
  bucket_name = var.vault_bucket_name
  alert_email = var.alert_email
}