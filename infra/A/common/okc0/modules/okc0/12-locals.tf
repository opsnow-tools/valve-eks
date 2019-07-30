# locals
  
locals {
  name = "${var.stage}-${var.name}"

  full_name = "${var.city}-${var.stage}-${var.name}"

  /*
    ex) region_A_upper_name, region_B_upper_name, region_C_upper_name, ...
  */
  region_A_upper_name = upper("${var.city}-A-${var.stage}-${var.name}")

  region_C_upper_name = upper("${var.city}-C-${var.stage}-${var.name}")

  cluster_name = "${local.lower_name}-eks"

  upper_cluster_name = upper(local.cluster_name)

  elastic_name = "{local.lower_name}-elasticsearch"

  upper_elastic_name = upper(local.elastic_name)

  tags = map("kubernetes.io/cluster/${local.cluster_name}", "shared")

  upper_name = upper(local.full_name)

  lower_name = lower(local.full_name)

  az_names = data.aws_availability_zones.azs.names

  az_length = length(local.az_names[0])
}
