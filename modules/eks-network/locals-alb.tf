## local variable
/*
  public_subnet_ids : public subnet ids in same VPC  || ["subnet-0xxxxx",...] || [aws_subnet.public_A.id, ...]
  idle_timeout : Application LoadBalancer timeout value
  lb_enable_http2 : enable http2 true/false
  lb_enable_deletion_protection : When someone delete this ApplicationLoadBalancer, protect or not
  vpc_id : VPC id
           [Priority] aws_vpc.this.id > local.vpc_id > "vpc-0xxxxxxxx"
  target_group_port : Port for target group
  health_check_path : Path for health check worker node
  listener_http_port : Port for http listener
  listener_https_port : Port for https listener
  route53_certificate_arn : ARN for route53 certificate value. There is a guide on upper side.
*/


locals {
  idle_timeout                  = 60
  lb_enable_http2               = true
  lb_enable_deletion_protection = false
  target_group_port             = 32000
  health_check_path             = "/healthz"
  listener_http_port            = 80
  listener_https_port           = 443
  ssl_policy                    = "ELBSecurityPolicy-2016-08"
}