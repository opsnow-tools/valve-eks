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

module "eks-sg-master" {
    source = "git::https://github.com/gelius7/valve-eks.git//modules/securitygroup?ref=okc2-1"

    sg_name = "master"
    sg_desc = "Cluster communication with worker nodes"              

    region = "ap-northeast-2"
    city   = "SEOUL"
    stage  = "SRE"
    name   = "JJ1"
    suffix = "EKS"

    vpc_id = "vpc-07d117148dfa20c4b"

    is_self = false

    source_sg_ids = [
        ["Allow node to communicate with the cluster API Server",
            "${module.eks-sg-node.sg_id}", 443, 443, "tcp", "ingress"],
    ]
}

module "eks-sg-node" {
    source = "git::https://github.com/gelius7/valve-eks.git//modules/securitygroup?ref=okc2-1"

    sg_name = "node"
    sg_desc = "Security group for all worker nodes in the cluster"              

    region = "ap-northeast-2"
    city   = "SEOUL"
    stage  = "SRE"
    name   = "JJ1"
    suffix = "EKS"

    vpc_id = "vpc-07d117148dfa20c4b"

    is_self = true

    # tuple : list of [description, source_sg_id, from, to, protocol, type]
    source_sg_ids = [
        ["Allow worker Kubelets and pods to receive communication from the cluster control plane",
            "${module.eks-sg-master.sg_id}", 0, 65535, "-1", "ingress"],
    ]

    # tuple : list of [description, source_cidr, from, to, protocol, type]
    source_sg_cidrs = [
        ["SRE Bastion",
            ["10.10.25.159/32"], 22, 22, "tcp", "ingress"],
        ["Gangnam 13F 1",
            ["58.151.93.2/32"], 22, 22, "tcp", "ingress"],
        ["Gangnam 13F 2",
            ["58.151.93.9/32"], 22, 22, "tcp", "ingress"],
        ["Gangnam 13F wifi",
            ["58.151.93.17/32"], 22, 22, "tcp", "ingress"],
    ]
}

output "sg-master" {
    value = "master security group id : ${module.eks-sg-master.sg_id}"
}

output "sg-node" {
    value = "node security group id : ${module.eks-sg-node.sg_id}"
}

