#!/bin/bash
terraform import module.efs.aws_security_group.efs sg-014fa9864381c7da9

terraform import module.efs.aws_security_group_rule.efs-ingress-worker sg-014fa9864381c7da9_ingress_tcp_2049_2049_sg-017005a4513dd063c

terraform import module.efs.aws_efs_file_system.efs fs-ef3f4c8e

terraform import 'module.efs.aws_efs_mount_target.efs[0]' fsmt-45904b24
terraform import 'module.efs.aws_efs_mount_target.efs[1]' fsmt-47904b26
terraform import 'module.efs.aws_efs_mount_target.efs[2]' fsmt-49904b28
