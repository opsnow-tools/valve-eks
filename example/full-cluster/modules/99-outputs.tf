# output
  
output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "subnet_id" {
  value = [aws_subnet.private_A.id, aws_subnet.private_C.id]
}

output "config" {
  value = local.config
}

output "name" {
  value = aws_eks_cluster.cluster.*.name
}

output "efs_id" {
  value = aws_efs_file_system.efs.*.id
}
