# 53-worker-security-group.tf

## local variable
/*
vpc_id : AWS VPC id.
         [Priority] aws_vpc.this.id > local.vpc_id > "vpc-0xxxxxxxx"
allow_ips : Allow ips in Kubernetes worker node. Same with vpc_id.
*/


## worker security group
resource "aws_security_group" "worker" {
  name        = "node.${local.cluster_name}"
  description = "Security group for worker nodes"

  vpc_id = local.vpc_id

  tags = {
    "Name"                                        = "nodes.${local.cluster_name}"
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }
}

resource "aws_security_group" "worker-internal" {
  name        = "node-internal.${local.cluster_name}"
  description = "Security group for worker node's internal rules"

  vpc_id = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow worker to communicate with each other"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description     = "Allow worker to communicate with the cluster API Server"
    security_groups = [aws_security_group.cluster.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }

  tags = {
    "Name"                                        = "node-internal.${local.cluster_name}"
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }
}
