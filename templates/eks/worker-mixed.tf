# 56-worker-mixed.tf

## local variable
/*
  eks_ami_id : EKS AMI id. Must find in AWS Console. example is 'ami-07fd7609df6c8e39b : amazon-eks-node-1.13-v20190701'
  instance_type : EC2 instance type
  min : EC2 instance min value
  max : EC2 instance max value
  instance_type_mixed(optional - mixed) : It is for using EKS mixed cluster. Multiple EC2 instance type can be written.
  on_demand_base(optional - mixed) : defining the number of OnDemand instances that you want as a basis (our minimum of instances to be safe with your minimum traffic for example).
  on_demand_rate(optional - mixed) : defining the percentage of OnDemand instances compared to Spot instances beyond the base capacity (0 : 0% OnDemand, 100% Spot).

  private_subnets : Already define in 45-cluster.tf.
*/

locals {
  eks_ami_id          = ""
  instance_type       = "m4.xlarge"
  min                 = 2
  max                 = 5
  instance_type_mixed = ["m4.xlarge", "r5.xlarge", "r4.xlarge"]
  on_demand_base      = 2
  on_demand_rate      = 25
}

## eks worker mixed

resource "aws_launch_template" "worker-mixed" {
  name_prefix   = "${local.upper_cluster_name}-MIXED-"
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
}

resource "aws_autoscaling_group" "worker-mixed" {
  name = "${local.upper_cluster_name}-MIXED"

  min_size = local.min
  max_size = local.max

  vpc_zone_identifier = local.private_subnets

  enabled_metrics = [ 
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = local.on_demand_base
      on_demand_percentage_above_base_capacity = local.on_demand_rate
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.worker-mixed.id
        version            = "$Latest"
      }

      override {
        instance_type = local.instance_type
      }

      dynamic "override" {
        for_each = local.instance_type_mixed
        content {
          instance_type = override.value
        }
      }
    }
  }

  target_group_arns = [aws_lb_target_group.tg_http.arn]

  tags = concat(
    [
      {
        "key"                 = "asg:lifecycle"
        "value"               = "mixed"
        "propagate_at_launch" = true
      },
    ],
    local.worker_tags,
  )
}
