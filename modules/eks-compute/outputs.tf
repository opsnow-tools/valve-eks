# output

output "config" {
  value = "${local.config}"
}

output "name" {
  value = "${aws_eks_cluster.cluster.*.name}"
}

# output "buckets" {
#   value = "${aws_s3_bucket.buckets.*.bucket}"
# }
