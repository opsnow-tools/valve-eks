terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "seoul-sre-jj-state"
    key    = "jjeks-compute.tfstate"
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region = "ap-northeast-2"
}

module "eks-compute" {
  source = "../../../modules/eks-compute"
  # source = "git::https://github.com/gelius7/valve-eks.git//modules/eks-compute?ref=okc2-1"

  region = var.region
  city   = var.city
  stage  = var.stage
  name   = var.name
  suffix = var.suffix

  kubernetes_version = var.kubernetes_version

  vpc_id = var.vpc_id

  subnet_ids = var.subnet_ids

  instance_type = var.instance_type

  mixed_instances = var.mixed_instances

  volume_size = var.volume_size

  min = var.min
  max = var.max

  on_demand_base = var.on_demand_base
  on_demand_rate = var.on_demand_rate

  key_name = var.key_name

  map_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SEOUL-SRE-K8S-BASTION"
      username = "iam_role_bastion"
      group    = "system:masters"
    },
  ]

  map_users = var.map_users

}

data "aws_caller_identity" "current" {
}

output "config" {
    value = module.eks-compute.config
}