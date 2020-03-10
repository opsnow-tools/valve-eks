# 43-cluster-security-group.tf

## local variable
/*
vpc_id : AWS VPC id. 
         [Priority] aws_vpc.this.id > local.vpc_id > "vpc-0xxxxxxxx"
allow_ips : Allow ips in Kubernetes worker node. Same with vpc_id.
*/

locals {
  vpc_id    = ""
  allow_ips = []
}

## cluster security group
resource "aws_security_group" "cluster" {
  name        = "masters.${local.cluster_name}"
  description = "Security group for cluster"

  vpc_id = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allow node to communicate with the cluster API Server"
    security_groups = [aws_security_group.worker.id]
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
  }

  ingress {
    description     = "Allow workstation to communicate with the cluster API server"
    cidr_blocks     = local.allow_ips
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
  }

  tags = {
    "Name"                                        = "masters.${local.cluster_name}"
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }
}