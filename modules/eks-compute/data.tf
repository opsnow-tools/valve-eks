# data

# data "aws_security_group" "worker_sg_id" {
#   name = "node.${local.lower_name}"
# }

data "aws_caller_identity" "current" {}

data "aws_ami" "worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.14-v20190906"]
    # values = ["amazon-eks-node-1.13-v20190814"]
    # values = ["amazon-eks-node-${var.kubernetes_version}-*"]
  }

  owners = ["602401143452"] # Amazon Account ID

  # most_recent = true
}

