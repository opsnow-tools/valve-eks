# worker iam role
locals {
  eks_ami_id = ""
  instance_type = "m4.xlarge"
  min = 2
  max = 5
  instance_type_mixed = ["m4.xlarge", "r5.xlarge", "r4.xlarge"]
}

resource "aws_iam_role" "worker" {
  name = "${local.upper_cluster_name}-WORKER"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_instance_profile" "worker" {
  name = "${local.upper_cluster_name}-WORKER"
  role = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "worker-AmazonEKS_CNI_Policy" {
  role = aws_iam_role.worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "worker-AmazonEKSWorkerNodePolicy" {
  role = aws_iam_role.worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "worker-AmazonEC2ContainerRegistryReadOnly" {
  role = aws_iam_role.worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "worker_autoscaling" {
  role = aws_iam_role.worker.name
  policy_arn = aws_iam_policy.worker_autoscaling.arn
}

resource "aws_iam_policy" "worker_autoscaling" {
  name = "${aws_iam_role.worker.name}-AUTOSCALING"
  description = "Autoscaling policy for cluster ${local.cluster_name}"
  policy = data.aws_iam_policy_document.worker_autoscaling.json
  path = "/"
}

data "aws_iam_policy_document" "worker_autoscaling" {
  statement {
    sid = "eksWorkerAutoscalingAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  statement {
    sid = "eksWorkerAutoscalingOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    condition {
      test = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${local.cluster_name}"
      values = ["owned"]
    }

    condition {
      test = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values = ["true"]
    }
  }
}

# worker security group

resource "aws_security_group" "worker" {
  name        = "nodes.${local.cluster_name}"
  description = "Security group for all worker nodes in the cluster"

  vpc_id = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                      = "nodes.${local.cluster_name}"
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }
}

resource "aws_security_group_rule" "worker-ingress-self" {
  description              = "Allow worker to communicate with each other"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.worker.id
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.cluster.id
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker-ingress-admin-ssh" {
  description       = "Allow workstation to communicate with the cluster API Server"
  security_group_id = aws_security_group.worker.id
  cidr_blocks       = local.allow_ips
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  type              = "ingress"
}

# eks worker
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

# eks worker spot
/*
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
*/

# eks worker mixed
/*
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

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
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
*/
