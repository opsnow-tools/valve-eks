## output common
output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "subnet_id" {
  value = [aws_subnet.public_A.id, aws_subnet.public_C.id, aws_subnet.private_A.id, aws_subnet.private_C.id]
}

/*
## output efs
output "efs_id" {
  value = aws_efs_file_system.efs.*.id
}

## output eks
output "config" {
  value = local.config
}

output "name" {
  value = aws_eks_cluster.cluster.*.name
}

## output alb
output "target_group_name" {
  value = aws_lb_target_group.tg_http.name
}

output "alb_name" {
  value = aws_lb.main.name
}

output "alb_arn" {
  value = aws_lb.main.arn
}

output "alb_id" {
  value = aws_lb.main.id
}
*/
