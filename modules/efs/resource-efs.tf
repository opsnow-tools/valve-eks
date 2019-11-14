# efs

resource "aws_efs_file_system" "efs" {
  creation_token = "${local.lower_name}"

  tags = {
    "Name"                                      = "${local.lower_name}-EFS"
    "KubernetesCluster"                         = local.lower_name
  }
}

resource "aws_efs_mount_target" "efs" {
  count = length(var.subnet_ids)

  file_system_id = aws_efs_file_system.efs.id

  subnet_id = "${var.subnet_ids[count.index]}"

  security_groups = ["${aws_security_group.efs.id}"]
}
