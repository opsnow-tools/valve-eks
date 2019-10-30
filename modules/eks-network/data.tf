
data "aws_route53_zone" "selected" {
  name         = local.root_domain
  private_zone = false
}

data "aws_security_group" "worker_sg_id" {
  name = "node.${local.lower_name}"
}
