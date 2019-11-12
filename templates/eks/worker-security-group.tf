# 53-worker-security-group.tf

## local variable
/*
vpc_id : AWS VPC id.
         [Priority] aws_vpc.this.id > local.vpc_id > "vpc-0xxxxxxxx"
allow_ips : Allow ips in Kubernetes worker node. Same with vpc_id.
*/


## worker security group

resource "aws_security_group" "worker" {
  name        = "nodes.${local.cluster_name}"
  description = "Security group for all worker nodes in the cluster"

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
    description     = "Allow worker Kubernetes and pods to receive communication from the cluster control plane"
    security_groups = [aws_security_group.cluster.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }

  ingress {
    description = "Allow worker to communicate with the cluster API Server"
    cidr_blocks = local.allow_ips
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    description     = "Allow worker Kubernetes and pods to receive communication from the ALB for the public nginx ingress"
    security_groups = [aws_security_group.alb.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }

  tags = {
    "Name"                                        = "nodes.${local.cluster_name}"
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }
}
