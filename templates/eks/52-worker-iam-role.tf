# 52-worker-iam-role.tf 

## worker iam role

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
