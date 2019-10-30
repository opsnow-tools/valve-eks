data "aws_security_group" "mount_target_sg" {
  name = "node.${local.lower_name}"
}
