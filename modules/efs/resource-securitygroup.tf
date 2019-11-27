# efs security group

resource "aws_security_group" "efs" {
  name        = "efs-sg.${local.lower_name}"
  description = "Security group for efs in the cluster"

  lifecycle {
    create_before_destroy = true
  }

  vpc_id = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name      = "efs-sg.${local.lower_name}",
      SG_Groups = "${local.lower_name}"
  }
}

resource "aws_security_group_rule" "efs-ingress-worker" {
  count = length(var.mount_target_sg) > 0 ? length(var.mount_target_sg) : 1

  lifecycle {
    create_before_destroy = true
  }

  description              = "Allow worker to communicate with each other"
  security_group_id        = "${aws_security_group.efs.id}"
  # source_security_group_id = length(var.mount_target_sg) > 0 ? var.mount_target_sg[count.index] : data.aws_security_group.mount_target_sg[0].id
  source_security_group_id = var.mount_target_sg[count.index]
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  type                     = "ingress"
}
