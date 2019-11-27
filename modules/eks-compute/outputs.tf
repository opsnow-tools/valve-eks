# output

output "config" {
  value = "${local.config}"
}

output "name" {
  value = "${aws_eks_cluster.cluster.*.name}"
}
output "target_group_arn" {
  value = "${aws_lb_target_group.tg_http.arn}"
}
