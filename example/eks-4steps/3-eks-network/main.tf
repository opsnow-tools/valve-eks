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
  source = "git::https://github.com/gelius7/valve-eks.git//modules/eks-network"

  root_domain = "opsnow.io"

  region = "ap-northeast-2"
  city   = "SEOUL"
  stage  = "SRE"
  name   = "JJ0"
  suffix = "EKS"

  vpc_id = "vpc-07d117148dfa20c4b"

  public_subnet_ids = [
    "subnet-075965ec063a312ce",
    "subnet-00150e09bc435ff7e",
    "subnet-0bd5f618dc302fee4",
  ]

  # default node.${local.lower_name}
  # worker_sg_id = "sg-0c4c6b74de6721fa6"

}

output "record_set" {
    value = module.eks-domain.address
}

output "target_group_http_arn" {
    value = module.eks-domain.target_group_http_arn
}