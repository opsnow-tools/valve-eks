# data "aws_security_group" "mount_target_sg" {
#   count = length(var.mount_target_sg) > 0 ? 0 : 1
#   name = "nodes.${local.lower_name}"
# }