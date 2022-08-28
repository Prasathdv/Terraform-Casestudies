locals {
  prod_availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

module "Networking" {
  source = "./modules/networking"

  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zone    = local.prod_availability_zones
}