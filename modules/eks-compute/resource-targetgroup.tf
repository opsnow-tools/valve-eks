# target group

resource "aws_lb_target_group" "tg_http" {
  name     = "${local.upper_name}-ALB"
  vpc_id   = var.vpc_id
  port     = local.target_group_port
  protocol = "HTTP"

  health_check {
    interval            = 30
    path                = local.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = 200
  }

  target_type = "instance"

  ## Create new target group before destroy current target group
  lifecycle {
    create_before_destroy = true
  }
}
