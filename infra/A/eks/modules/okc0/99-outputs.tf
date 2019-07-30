# output
  
output "config" {
  value = local.config
}

output "name" {
  value = aws_eks_cluster.cluster.*.name
}
