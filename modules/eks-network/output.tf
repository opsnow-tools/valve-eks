output "target_group_http_arn" {
    value = aws_lb_target_group.tg_http.arn
}

output "address" {
    value = aws_route53_record.address.name
}