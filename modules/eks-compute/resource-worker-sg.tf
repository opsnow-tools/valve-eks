# worker security group

resource "aws_security_group" "worker" {
  name        = "nodes.${local.lower_name}"
  description = "Security group for all worker nodes in the cluster"

  vpc_id = var.vpc_id

  tags = {
    "Name"                                      = "nodes.${local.lower_name}"
    "kubernetes.io/cluster/${local.lower_name}" = "owned"
  }
}

resource "aws_security_group" "worker-internal" {
  name        = "node-internal.${local.lower_name}"
  description = "Set rules for controlling access within a cluster."

  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow communication between worker nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description     = "Allow communication between master nodes and worker nodes"
    security_groups = [aws_security_group.cluster.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }

  tags = {
    "Name"                                      = "node-internal.${local.lower_name}"
    "kubernetes.io/cluster/${local.lower_name}" = "owned"
  }
}
