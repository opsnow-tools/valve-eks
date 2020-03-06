# 53-worker-security-group.tf

## local variable
/*
vpc_id : AWS VPC id.
         [Priority] aws_vpc.this.id > local.vpc_id > "vpc-0xxxxxxxx"
allow_ips : Allow ips in Kubernetes worker node. Same with vpc_id.
*/


## worker security group
resource "aws_security_group" "worker-egress" {
  name        = "nodes.${local.cluster_name}-egress"
  description = "Worker security group for egress rules"

  vpc_id = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                        = "nodes.${local.cluster_name}-egress"
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }
}

resource "aws_security_group" "worker-ingress" {
  name        = "nodes.${local.cluster_name}-ingress"
  description = "Worker security group for ingress rules"

  vpc_id = local.vpc_id

  ingress {
    description = "Allow worker to communicate with each other"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description     = "Allow worker to communicate with the cluster API Server"
    security_groups = [aws_security_group.cluster-egress.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }

  ingress {
    description = "Allow worker to communicate with the bastion via SSH"
    cidr_blocks = local.allow_ips
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    description     = "Allow worker to communicate with the ALB for the public nginx ingress"
    security_groups = [aws_security_group.alb.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }

  tags = {
    "Name"                                        = "nodes.${local.cluster_name}-ingress"
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }
}
