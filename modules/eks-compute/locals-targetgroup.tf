## local variable

locals {
  # idle_timeout                  = 60
  # lb_enable_http2               = true
  # lb_enable_deletion_protection = false
  target_group_port             = 32000
  health_check_path             = "/healthz"
  # listener_http_port            = 80
  # listener_https_port           = 443
  # ssl_policy                    = "ELBSecurityPolicy-2016-08"
}