# locals

locals {
  full_name = "${var.city}-${var.stage}-${var.name}-${var.suffix}"
  upper_name = "${upper(local.full_name)}"
  lower_name = "${lower(local.full_name)}"

  record_full_name = "*.${var.name}.${data.aws_route53_zone.selected.name}"
  root_domain = var.root_domain
  base_domain = "${lower(local.record_full_name)}"

}


