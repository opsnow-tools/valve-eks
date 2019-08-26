resource "aws_cloudwatch_metric_alarm" "alarm1" {
  alarm_name = "${local.upper_cluster_name}-EC2-ASG-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Maximum"
  threshold = "4"

  dimensions = {
      AutoScalingGroupName = "${local.upper_cluster_name}-MIXED"
  }

  alarm_description = "This metric monitors cpu utilization of worker nodes."
  alarm_actions     = ["${aws_sns_topic.alarms.arn}"]
}
