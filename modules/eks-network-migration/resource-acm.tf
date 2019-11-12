
resource "aws_acm_certificate" "default" {
  domain_name       = local.base_domain_represent
  subject_alternative_names = [
      local.base_domain
    ]
  validation_method = "DNS"

  tags = {
    Name                = "acm.${local.lower_name}"
    KubernetesCluster   = local.lower_name
    Environment         = var.name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  name    = "${aws_acm_certificate.default.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.default.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  records = ["${aws_acm_certificate.default.domain_validation_options.0.resource_record_value}"]
  ttl     = "60"
}

resource "aws_route53_record" "validation_alt1" {
  name    = "${aws_acm_certificate.default.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.default.domain_validation_options.1.resource_record_type}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  records = ["${aws_acm_certificate.default.domain_validation_options.1.resource_record_value}"]
  ttl     = "60"
}

resource "aws_acm_certificate_validation" "default" {
  certificate_arn = "${aws_acm_certificate.default.arn}"
  
  validation_record_fqdns = [
    "${aws_route53_record.validation.fqdn}",
    "${aws_route53_record.validation_alt1.fqdn}",
  ]
}
