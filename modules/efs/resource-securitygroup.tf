# efs security group

resource "aws_security_group" "efs" {
  name        = "efs.${local.lower_name}"
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
      Name      = "efs.${local.lower_name}",
      SG_Groups = "${local.lower_name}"
  }
}

resource "aws_security_group_rule" "efs-ingress-worker" {

  lifecycle {
    create_before_destroy = true
  }

  description              = "Allow worker to communicate with each other"
  security_group_id        = "${aws_security_group.efs.id}"
  source_security_group_id = var.mount_target_sg != "" ? var.mount_target_sg : data.aws_security_group.mount_target_sg.id
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  type                     = "ingress"
}
