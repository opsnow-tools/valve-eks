# 71-efs.tf local variable
/*
  vpc_id : vpc id made by 'vpc' terraform script
  private_a_subnet : private az A subnet id
  private_c_subnet : private az C subnet id
  worker_sg_id : EKS worker node Security Group id
*/

locals {
#  vpc_id = ""
  private_a_subnet = aws_subnet.private_A.id
  private_c_subnet = aws_subnet.private_C.id
  worker_sg_id = aws_security_group.worker.id
}

# efs security group

resource "aws_security_group" "efs" {
  name       = "efs.${local.cluster_name}"
  description = "Security group for efs in the cluster"

  vpc_id = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                      = "efs.${local.cluster_name}"
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }
}

resource "aws_security_group_rule" "efs-ingress-worker" {
  description              = "Allow worker to communicate with each other"
  security_group_id        = aws_security_group.efs.id
  source_security_group_id = local.worker_sg_id
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "-1"
  type                     = "ingress"
}

# efs

resource "aws_efs_file_system" "efs" {
  creation_token = local.cluster_name

  tags = {
    "Name"                                      = "efs.${local.cluster_name}"
    "KubernetesCluster"                         = local.cluster_name
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }
}

resource "aws_efs_mount_target" "efs_A" {
  file_system_id = aws_efs_file_system.efs.id

  subnet_id = local.private_a_subnet

  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_mount_target" "efs_C" {
  file_system_id = aws_efs_file_system.efs.id

  subnet_id = local.private_c_subnet

  security_groups = [aws_security_group.efs.id]
}
