terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "seoul-sre-jj-state"
    key    = "jjeks-network-bset.tfstate"
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region = "ap-northeast-2"
}

module "eks-domain" {
  source = "../../../modules/eks-network-migration"
#   source = "git::https://github.com/gelius7/valve-eks.git//modules/eks-network?ref=okc2-1"

  root_domain = var.root_domain

  region = var.region
  city   = var.city
  stage  = var.stage
  name   = var.name
  suffix = var.suffix

  vpc_id = var.vpc_id

  public_subnet_ids = var.public_subnet_ids

  name_represent = var.name_represent

  weighted_routing_represent = var.weighted_routing_represent
  weighted_routing_new = var.weighted_routing_new
  
}

output "record_set" {
    value = module.eks-domain.address_bset
}
output "record_address_represent" {
    value = module.eks-domain.address_represent
}

output "import_command-1" {
  value = module.eks-domain.import_command1
}