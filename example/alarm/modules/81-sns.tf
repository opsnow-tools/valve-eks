
locals{
  alertnow_alerts_endpoint = "https://alertnowitgr.opsnow.com/integration/cloudwatch/v1/3a2c88131a75c711e889b01802af26874d72"
}

resource "aws_sns_topic" "alarms" {
  name = "${local.upper_cluster_name}-ALARMS"
}
resource "aws_sns_topic_subscription" "cloudwatch_alarms" {
  count = "${local.alertnow_alerts_endpoint != "" ? 1 : 0}"

  endpoint               = "${local.alertnow_alerts_endpoint}"
  endpoint_auto_confirms = true
  protocol               = "https"
  topic_arn              = "${aws_sns_topic.alarms.arn}"
}