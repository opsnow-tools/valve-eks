# locals
locals {
  full_name = "${var.city}-${var.stage}-${var.name}"
  lower_name = lower(local.full_name)
  cluster_name = "${local.lower_name}-eks"
  elasticsearch_name = "${local.lower_name}-es"
  upper_cluster_name = upper(local.cluster_name)
}

