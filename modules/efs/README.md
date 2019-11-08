# EFS module

* AWS 에서 EFS + 필요 Security Group 을 생성하는 module 입니다.

## Resource

* "aws_efs_file_system" "efs"

* "aws_efs_mount_target" "efs"

* "aws_security_group" "efs"

* "aws_security_group_rule" "efs-ingress-worker"

## Data

* "aws_security_group" "mount_target_sg"
