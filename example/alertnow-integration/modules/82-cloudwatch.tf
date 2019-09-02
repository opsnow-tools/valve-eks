resource "aws_cloudwatch_metric_alarm" "asg_cpu_utilization" {
  alarm_name = "${local.upper_cluster_name}-ASG-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Maximum"
  threshold = "80"

  dimensions = {
    AutoScalingGroupName = "${local.full_name}"
  }

  alarm_description = "This metric monitors cpu utilization of worker nodes."
  alarm_actions     = ["${aws_sns_topic.alarms.arn}"]
}

data "aws_autoscaling_group" "worker" {
  name = "${local.full_name}-EKS-MIXED"
}

resource "aws_cloudwatch_metric_alarm" "asg_group_desired_capacity" {
  alarm_name = "${local.full_name}-ASG-GroupDesiredCapacity"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "GroupDesiredCapacity"
  namespace = "AWS/ASG"
  period = "120"
  statistic = "Maximum"
  threshold = "${data.aws_autoscaling_group.worker.max_size}"

  dimensions = {
    AutoScalingGroupName = "${local.full_name}"
  }

  alarm_description = "This metric monitors group desired capacity of the autoscaling group."
  alarm_actions     = ["${aws_sns_topic.alarms.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "es_cluster_status_green" {
  alarm_name = "${local.full_name}-ES-ClusterStatus-Green"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "ClusterStatus.green"
  namespace = "AWS/ES"
  period = "120"
  statistic = "Minimum"
  threshold = "0"

  dimensions = {
    DomainName = "${local.elasticsearch_name}"
  }

  alarm_description = "This metric monitors clusterstatus.green of the elasticsearch."
  alarm_actions     = ["${aws_sns_topic.alarms.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "es_cluster_free_storage_space" {
  alarm_name = "${local.full_name}-ES-Free-Storage-Space"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "FreeStorageSpace"
  namespace = "AWS/ES"
  period = "120"
  statistic = "Minimum"
  threshold = "10"
  unit = "Gigabytes"

  dimensions = {
    DomainName = "${local.elasticsearch_name}"
  }

  alarm_description = "This metric monitors free storage space of the elasticsearch."
  alarm_actions     = ["${aws_sns_topic.alarms.arn}"]
}