# eks-security group

terraform {
  backend "s3" {
    region = "ap-northeast-2"
    bucket = "seoul-sre-jj-state"
    key    = "jjeks-sg.tfstate"
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region = "ap-northeast-2"
}

module "eks-sg-node" {
    source = "../../../modules/securitygroup-inline"
    # source = "git::https://github.com/gelius7/valve-eks.git//modules/securitygroup?ref=okc2-1"

    sg_name = "node"
    sg_desc = "Security group for all worker nodes in the cluster"              

    region = "ap-northeast-2"
    city   = "SEOUL"
    stage  = "SRE"
    name   = "JJ0"
    suffix = "EKS"

    vpc_id = "vpc-07d117148dfa20c4b"

    # tuple : list of {description, source_cidr, from, to, protocol, type}
    source_sg_cidrs = [
        {
            desc = "SRE Bastion",
            cidrs = ["10.10.25.159/32"],
            from = 22,
            to = 22,
            protocol = "tcp",
            type = "ingress"
        },
        {
            desc = "Gangnam 13F 1, 2, wifi",
            cidrs = ["58.151.93.2/32", "58.151.93.9/32", "58.151.93.17/32"],
            from = 22,
            to = 22,
            protocol = "tcp",
            type = "ingress"
        },
        {
            desc = "JJ hometown wifi",
            cidrs = ["183.99.245.239/32"],
            from = 22,
            to = 22,
            protocol = "tcp",
            type = "ingress"
        },
    ]
}

# output "sg-master" {
#     value = "master security group id : ${module.eks-sg-master.sg_id}"
# }

output "sg-node" {
    value = "node security group id : ${module.eks-sg-node.sg_id}"
}

