# alb.tf

## create ALB
resource "aws_lb" "main" {
  name               = "${local.upper_name}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [
                        aws_security_group.alb.id, 
                        # var.worker_sg_id != "" ? var.worker_sg_id : data.aws_security_group.worker_sg_id.id,
                        var.worker_sg_id,
                      ]
  subnets            = var.public_subnet_ids

  ## Optional Arguments
  idle_timeout               = local.idle_timeout
  enable_http2               = local.lb_enable_http2
  enable_deletion_protection = local.lb_enable_deletion_protection

  tags = {
      "Name" = "${local.upper_name}-ALB"
  }    
}

resource "aws_security_group" "alb" {
  vpc_id = var.vpc_id
  name   = "${local.upper_name}-ALB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      "Name" = "${local.upper_name}-ALB"
  }
}

# resource "aws_lb_target_group" "tg_http" {
#   name     = "${local.upper_name}-ALB"
#   vpc_id   = var.vpc_id
#   port     = local.target_group_port
#   protocol = "HTTP"

#   health_check {
#     interval            = 30
#     path                = local.health_check_path
#     port                = "traffic-port"
#     protocol            = "HTTP"
#     timeout             = 5
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#     matcher             = 200
#   }

#   target_type = "instance"

#   ## Create new target group before destroy current target group
#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = aws_lb.main.arn
  port              = local.listener_http_port
  protocol          = "HTTP"

  default_action {
    # target_group_arn = data.aws_lb_target_group.tg_http.id
    target_group_arn = var.target_group_arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "frontend_https" {
  load_balancer_arn = aws_lb.main.arn
  port              = local.listener_https_port
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.default.arn
  ssl_policy        = local.ssl_policy

  default_action {
    # target_group_arn = data.aws_lb_target_group.tg_http.arn
    target_group_arn = var.target_group_arn
    type             = "forward"
  }
}

resource "aws_lb_listener_certificate" "https_listener_no_logs" {
  listener_arn    = aws_lb_listener.frontend_https.arn
  certificate_arn = aws_acm_certificate.default.arn
}
