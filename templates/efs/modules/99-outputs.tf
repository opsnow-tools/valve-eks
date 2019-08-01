# output
output "vpc_id" {
  value = "vpc-0d6ce01efd73de7f8"
}

output "vpc_cidr" {
  value = "10.253.0.0/16"
}
  
output "efs_id" {
  value = aws_efs_file_system.efs.*.id
}
