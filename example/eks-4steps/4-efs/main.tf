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
    source = "../../../modules/efs"
    # source = "git::https://github.com/gelius7/valve-eks.git//modules/efs?ref=okc2-1"

    region = var.region
    city   = var.city
    stage  = var.stage
    name   = var.name
    suffix = var.suffix

    vpc_id = var.vpc_id

    subnet_ids = var.subnet_ids

    # default node.${local.lower_name}
    # mount_target_sg = "sg-0c4c6b74de6721fa6"
}

output "efs_id" {
    value = "\nterraform import module.efs.aws_efs_file_system.efs ${module.efs.efs_id}\n"
}

output "efs_mount_target_ids" {
    value = "\nterraform import 'module.efs.aws_efs_mount_target.efs[0]' ${join("\nterraform import 'module.efs.aws_efs_mount_target.efs[*]' ", module.efs.efs_mount_target_ids)}\n"
}

output "aws_security_group_id" {
    value = "\nterraform import module.efs.aws_security_group.efs ${module.efs.aws_security_group_id}\n"
}

output "aws_security_group_rule_id" {
    value = "\nterraform import module.efs.aws_security_group_rule.efs-ingress-worker ${module.efs.aws_security_group_rule_import_param}\n"
}
