# 55-worker-spot.tf

## local variable
/*
  eks_ami_id : EKS AMI id. Must find in AWS Console. example is 'ami-07fd7609df6c8e39b : amazon-eks-node-1.13-v20190701'
  instance_type : EC2 instance type
  min : EC2 instance min value
  max : EC2 instance max value

  private_subnets : Already define in 45-cluster.tf.
*/

locals {
  eks_ami_id    = ""
  instance_type = ""
  min           = 2
  max           = 5
}

## eks worker spot

resource "aws_launch_template" "worker-spot" {
  name_prefix   = "${local.upper_cluster_name}-"
  image_id      = local.eks_ami_id
  instance_type = local.instance_type
  user_data     = base64encode(local.userdata)

  key_name = "${local.upper_cluster_name}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "gp2"
      volume_size           = "64"
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.worker.name
  }

  network_interfaces {
    delete_on_termination       = true
    associate_public_ip_address = false
    security_groups             = [aws_security_group.worker.id]
  }

  instance_market_options {
    market_type = "spot"
  }
}

resource "aws_autoscaling_group" "worker-spot" {
  name = local.upper_name

  min_size = local.min
  max_size = local.max

  vpc_zone_identifier = local.private_subnets

  launch_template {
    id      = aws_launch_template.worker-spot.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg_http.arn]

  tags = concat(
    [
      {
        "key"                 = "asg:lifecycle"
        "value"               = "spot"
        "propagate_at_launch" = true
      },
    ],
    local.worker_tags,
  )
}
