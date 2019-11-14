

resource "aws_route53_record" "address_bset" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = local.base_domain
  type    = "A"

  weighted_routing_policy {
    weight = var.weighted_routing_new
  }

  set_identifier = "subSet"

  alias {
      name = "${aws_lb.main.dns_name}"
      zone_id = "${aws_lb.main.zone_id}"
      evaluate_target_health = true
  }
}



resource "aws_route53_record" "address_represent" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = local.base_domain_represent
  type    = "A"

  weighted_routing_policy {
    weight = var.weighted_routing_represent
  }

  set_identifier = "NewSet"

  alias {
      name = "${aws_lb.main.dns_name}"
      zone_id = "${aws_lb.main.zone_id}"
      evaluate_target_health = true
  }
}