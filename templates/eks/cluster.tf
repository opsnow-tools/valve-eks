# 41-cluster.tf 

## local variable
/*
  vpc_id : vpc id made by 'vpc' terraform script
  allow_ips : allow ips with cidr in master node. ["0.0.0.0/0", ...]
  eks_version : current eks version
  private_subnets : private subnet ids. ["subnet_id_1", "subnet_id_2", ...]
*/

locals {
  eks_version     = ""
  private_subnets = []
}

## eks cluster

resource "aws_eks_cluster" "cluster" {
  name     = local.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = local.eks_version

  vpc_config {
    subnet_ids         = local.private_subnets
    security_group_ids = [aws_security_group.cluster-ingress.id, aws_security_group.cluster-egress.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]
}
