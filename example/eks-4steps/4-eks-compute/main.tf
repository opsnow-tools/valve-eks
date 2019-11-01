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
  source = "git::https://github.com/gelius7/valve-eks.git//modules/eks-compute?ref=okc2-1"

  region = "ap-northeast-2"
  city   = "SEOUL"
  stage  = "SRE"
  name   = "JJ0"
  suffix = "EKS"

  kubernetes_version = "1.14"

  vpc_id = "vpc-07d117148dfa20c4b"

  subnet_ids = [
    "subnet-001edd00f119acf6e",
    "subnet-07398d9f9131a3292",
    "subnet-03860c3c405a4870c",
  ]

  instance_type = "m5.large"

  mixed_instances = ["m4.large", "r4.large", "r5.large"]

  volume_size = "64"

  min = "1"
  max = "10"

  on_demand_base = "0"
  on_demand_rate = "0"

  key_name = "SEOUL-SRE-K8S-EKS"

  map_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SEOUL-SRE-K8S-BASTION"
      username = "iam_role_bastion"
      group    = "system:masters"
    },
  ]

  map_users = [
    {
      user     = "user/jamje.kim"
      username = "jamje.kim"
      group    = "system:masters"
    },
    {
      user     = "user/sre1"
      username = "sre1"
      group    = ""
    },
  ]



    # master_sg_id = "sg-0929afac4d3498133"
    # worker_sg_id = "sg-021b6eac0caa0cf81"

    # target_group_http_arn = "arn:aws:elasticloadbalancing:ap-northeast-2:759871273906:targetgroup/SEOUL-SRE-JJ0-EKS-ALB/3103c011a7d327c3"
}

data "aws_caller_identity" "current" {
}

output "config" {
    value = module.eks-compute.config
}