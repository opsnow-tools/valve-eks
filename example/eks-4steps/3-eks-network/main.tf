terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "seoul-sre-jj-state"
    key    = "jjeks-network.tfstate"
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region = "ap-northeast-2"
}

module "eks-domain" {
  source = "../../../modules/eks-network"
  # source = "git::https://github.com/gelius7/valve-eks.git//modules/eks-network?ref=okc2-1"

  root_domain = var.root_domain

  region = var.region
  city   = var.city
  stage  = var.stage
  name   = var.name
  suffix = var.suffix

  vpc_id = var.vpc_id

  public_subnet_ids = var.public_subnet_ids

  # default node.${local.lower_name}
  # worker_sg_id = "sg-0c4c6b74de6721fa6"

}

output "record_set" {
    value = module.eks-domain.address
}
