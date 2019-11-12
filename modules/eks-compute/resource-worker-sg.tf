# worker security group

resource "aws_security_group" "worker" {
  name        = "${local.upper_name}-WORKERS"
  description = "Security group for all worker nodes in the cluster"

  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                      = "${local.upper_name}-WORKERS"
    "kubernetes.io/cluster/${local.upper_name}" = "owned"
  }
}

resource "aws_security_group_rule" "worker-ingress-self" {
  description              = "Allow worker to communicate with each other"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.worker.id
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.cluster.id
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker-ingress-sg" {
  description              = "Allow workstation to communicate with the cluster API Server"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = var.worker_sg_id != "" ? var.worker_sg_id : data.aws_security_group.worker_sg_id.id
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  type                     = "ingress"
}
