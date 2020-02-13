terraform {
  required_version = ">= 0.12"
}
provider "aws" {
  region = var.aws_region
}
module "vpc" {
  # source = "git::https://github.com/opsnow-tools/valve-eks.git//modules/vpc-pubsubnet-prisubnet?ref=v0.0.1"
  source = "../../modules/vpc-pubsubnet-prisubnet"
  region = var.aws_region
  city   = var.city
  stage  = var.stage
  name   = var.cluster_name

  vpc_cidr = var.vpc_cidr
 
  public_subnet_enable = true
  public_subnet_count = 3
  public_subnet_zones = [
    "ap-northeast-2a",
    "ap-northeast-2b",
    "ap-northeast-2c",
  ]
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_enable = true
  private_subnet_count = 3
  private_subnet_zones = [
    "ap-northeast-2a",
    "ap-northeast-2b",
    "ap-northeast-2c",
  ]
  private_subnet_cidrs = var.private_subnet_cidrs
  single_nat_gateway = true
  tags = {
    "kubernetes.io/cluster/${lower(var.city)}-${lower(var.stage)}-${lower(var.cluster_name)}-eks"  = "shared"
  }
}
output "vpc_id" {
  value = module.vpc.vpc_id
}
output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}
output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}
output "public_subnet_cidr" {
  value = module.vpc.public_subnet_cidr
}
output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
} 
output "private_subnet_cidr" {
  value = module.vpc.private_subnet_cidr
}
output "nat_ip" {
  value = module.vpc.nat_ip
}

module "eks-sg-node" {
  # source = "git::https://github.com/opsnow-tools/valve-eks.git//modules/securitygroup-inline?ref=v0.0.1"
  source = "../../modules/securitygroup-inline"
  sg_name = var.sg_name
  sg_desc = var.sg_desc
  region = var.aws_region
  city   = var.city
  stage  = var.stage
  name   = var.cluster_name
  suffix = var.suffix
  source_sg_cidrs = var.source_sg_cidrs   # tuple : list of {description, source_cidr, from, to, protocol, type}
  vpc_id = module.vpc.vpc_id
}
output "sg-node" {
    value = "node security group id : ${module.eks-sg-node.sg_id}"
}

data "aws_caller_identity" "current" {
}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}
output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

module "eks-compute" {
  # source = "git::https://github.com/opsnow-tools/valve-eks.git//modules/eks-compute?ref=v0.0.1"
  source = "../../modules/eks-compute"
  region = var.aws_region
  city   = var.city
  stage  = var.stage
  name   = var.cluster_name
  suffix = var.suffix
  kubernetes_version = var.kubernetes_version
  instance_type = var.instance_type
  mixed_instances = var.mixed_instances
  volume_size = var.volume_size
  min = var.min
  max = var.max
  on_demand_base = var.on_demand_base
  on_demand_rate = var.on_demand_rate
  key_name = var.key_name
  # AWS EC2(Bastion)에서 terraform을 실행하기 위한 설정.
  # map_users 설정에 IAM 사용자 정보를 설정하고 IAM 사용자 권한으로 terraform 실행하는 경우는 필요 없음.
  map_roles = [
    {
      # AWS IAM Role, 사전에 생성되어 있어야 함. AdministratorAccess 정책이 맵핑되어 있어야 함.
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SEOUL-SRE-K8S-BASTION"
      # 쿠버네티스 RBAC 사용자이름, 기본값이므로 그냥 사용.
      username = "iam_role_bastion"
      # 쿠버네티스 RBAC 그룹, 기본값이므로 그냥 사용.
      group    = "system:masters"
    },
  ]
  map_users = var.map_users
  worker_sg_id = module.eks-sg-node.sg_id
  vpc_id  = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
}
output "config" {
    value = module.eks-compute.config
}
output "target_group_arn" {
    value = module.eks-compute.target_group_arn
}

module "eks-domain" {
  # source = "git::https://github.com/opsnow-tools/valve-eks.git//modules/eks-network?ref=v0.0.1"
  source = "../../modules/eks-network"
  root_domain = var.root_domain
  region = var.aws_region
  city   = var.city
  stage  = var.stage
  name   = var.cluster_name
  suffix = var.suffix
  weighted_routing = var.weighted_routing
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  worker_sg_id = module.eks-sg-node.sg_id
  target_group_arn = module.eks-compute.target_group_arn
}
output "record_set" {
  value = module.eks-domain.address
}
output "import_command-1" {
  value = module.eks-domain.import_command1
}

module "efs" {
  # source = "git::https://github.com/opsnow-tools/valve-eks.git//modules/efs?ref=v0.0.1"
  source = "../../modules/efs"
  region = var.aws_region
  city   = var.city
  stage  = var.stage
  name   = var.cluster_name
  suffix = var.suffix
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  mount_target_sg = ["${module.eks-compute.worknode_security_group_id}"]
}
output "efs_id" {
    value = "\nterraform import module.efs.aws_efs_file_system.efs ${module.efs.efs_id}\n"
}
output "efs_mount_target_ids" {
    value = "\nterraform import 'module.efs.aws_efs_mount_target.efs[0]' ${join("\nterraform import 'module.efs.aws_efs_mount_target.efs[*]' ", module.efs.efs_mount_target_ids)}\n"
}
