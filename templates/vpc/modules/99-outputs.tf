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
