
output "address_bset" {
    value = aws_route53_record.address_bset.name
}

output "address_represent" {
    value = aws_route53_record.address_represent.name
}

output "import_command1" {
    value = "\nterraform import -var-file=YOUR module.eks-domain.aws_route53_record.validation ${aws_route53_record.validation.zone_id}_${aws_route53_record.validation.name}._${aws_route53_record.validation.type}\n"
}
