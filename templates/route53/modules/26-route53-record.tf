# 26-route53-record.tf 

## local variable

locals {
  route53_name = ""  # "*.dev"
  route53_type = "A" # A, CNAME, ...
  weight       = 100 # add new weight local variable
  set_id       = ""  # weighted routing policy unique set id
}

## route53 zone
data "aws_route53_zone" "cluster" {
  name = "" # "dev.com"
}

## weighted routing policy
resource "aws_route53_record" "cluster" {
  zone_id = data.aws_route53_zone.cluster.id
  name    = local.route53_name
  type    = local.route53_type

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }

  weighted_routing_policy {
    weight = local.weight
  }

  set_identifier = local.set_id
}
