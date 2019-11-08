output "efs_id" {
    value = aws_efs_file_system.efs.id
}

output "efs_mount_target_ids" {
    value = aws_efs_mount_target.efs.*.id
}

output "aws_security_group_id" {
    value = aws_security_group.efs.id
}

output "aws_security_group_rule_import_param" {
    value = "${aws_security_group.efs.id}_${aws_security_group_rule.efs-ingress-worker.type}_${aws_security_group_rule.efs-ingress-worker.protocol}_${aws_security_group_rule.efs-ingress-worker.from_port}_${aws_security_group_rule.efs-ingress-worker.to_port}_${data.aws_security_group.mount_target_sg.id}"
}

output "sg_rule_delete_cmd" {
    value = "terraform destroy --target=module.efs.aws_security_group_rule.efs-ingress-worker"
}
