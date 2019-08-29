# 54-worker.tf 

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
  instance_type = "m4.xlarge"
  min           = 2
  max           = 5
}

## eks worker

resource "aws_launch_configuration" "worker" {
  name_prefix          = "${local.upper_cluster_name}-"
  image_id             = local.eks_ami_id
  instance_type        = local.instance_type
  iam_instance_profile = aws_iam_instance_profile.worker.name
  user_data_base64     = base64encode(local.userdata)

  key_name = "${local.upper_cluster_name}"

  associate_public_ip_address = false

  security_groups = [aws_security_group.worker.id]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "64"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "worker" {
  name = local.upper_name

  min_size = local.min
  max_size = local.max

  vpc_zone_identifier = local.private_subnets

  launch_configuration = aws_launch_configuration.worker.id

  target_group_arns = [aws_lb_target_group.tg_http.arn]

  tags = concat(
    [
      {
        "key"                 = "asg:lifecycle"
        "value"               = "normal"
        "propagate_at_launch" = true
      },
    ],
    local.worker_tags,
  )
}
