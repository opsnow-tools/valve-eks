# locals
data "aws_availability_zones" "azs" {
}
  
locals {
  name = "${var.stage}-${var.name}"

  full_name = "${var.city}-${var.stage}-${var.name}"

  cluster_name = "${local.lower_name}-eks"

  lower_name = lower(local.full_name)

  az_names = data.aws_availability_zones.azs.names
}
