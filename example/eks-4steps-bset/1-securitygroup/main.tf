# eks-security group

terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "seoul-sre-jj-state"
    key    = "jjeks-sg-bset.tfstate"
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region = "ap-northeast-2"
}

module "eks-sg-node" {
    source = "../../../modules/securitygroup-inline"
    # source = "git::https://github.com/gelius7/valve-eks.git//modules/securitygroup?ref=okc2-1"

    sg_name = var.sg_name
    sg_desc = var.sg_desc

    region = var.region
    city   = var.city
    stage  = var.stage
    name   = var.name
    suffix = var.suffix

    vpc_id = var.vpc_id

    # tuple : list of {description, source_cidr, from, to, protocol, type}
    source_sg_cidrs = var.source_sg_cidrs
}

output "sg-node" {
    value = "node security group id : ${module.eks-sg-node.sg_id}"
}

