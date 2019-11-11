# EFS module

* AWS 에서 EFS + 필요 Security Group 을 생성하는 module 입니다.

* 아래 그림에서 EFS, efs.CLUSTER 를 가리키고 있습니다.

## Draw

<span style="display:block;text-align:center">![](./img-draw-valve-eks-4steps.svg)</span>
<span style="display:block;text-align:center">valve eks 전체</span>

## Graph

> CMD : terraform graph | dot -Tsvg > graph.svg

## Resource

* "aws_efs_file_system" "efs"

* "aws_efs_mount_target" "efs"

* "aws_security_group" "efs"

* "aws_security_group_rule" "efs-ingress-worker"

## Data

* "aws_security_group" "mount_target_sg"
