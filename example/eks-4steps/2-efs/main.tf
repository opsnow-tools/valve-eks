# efs

terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "seoul-sre-jj-state"
    key    = "jjeks-efs.tfstate"
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region = "ap-northeast-2"
}

module "efs" {
    source = "git::https://github.com/gelius7/valve-eks.git//modules/efs?ref=okc2-1"

    region = "ap-northeast-2"
    city   = "SEOUL"
    stage  = "SRE"
    name   = "JJ0"
    suffix = "EKS"

    vpc_id = "vpc-07d117148dfa20c4b"

    subnet_ids = [
        "subnet-001edd00f119acf6e",
        "subnet-07398d9f9131a3292",
        "subnet-03860c3c405a4870c",
    ]

    # default node.${local.lower_name}
    # mount_target_sg = "sg-0c4c6b74de6721fa6"
}

output "efs_id" {
    value = "${module.efs.efs_id}"
}