## cluster security group

resource "aws_security_group" "cluster" {
  name        = "master.${local.lower_name}"
  description = "Cluster security group for egress rules"

  vpc_id = var.vpc_id

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

  tags = {
    "Name"                                      = "masters.${local.lower_name}"
    "kubernetes.io/cluster/${local.lower_name}" = "owned"
  }
}

# resource "aws_security_group_rule" "cluster-ingress-node-https" {
#   description              = "Allow node to communicate with the cluster API Server"
#   security_group_id        = aws_security_group.cluster.id
#   source_security_group_id = aws_security_group.worker.id
#   from_port                = 443
#   to_port                  = 443
#   protocol                 = "tcp"
#   type                     = "ingress"
# }

# resource "aws_security_group_rule" "cluster-ingress-admin-https" {
#   description       = "Allow workstation to communicate with the cluster API Server"
#   security_group_id = aws_security_group.cluster.id
#   cidr_blocks       = local.allow_ips
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   type              = "ingress"
# }
