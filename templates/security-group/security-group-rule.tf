# security group

locals {
    sg_name             = "mysg"
    sg_desc             = "This is my Security Group"
    city                = "SEOUL"
    stage               = "STAGE"
    name                = "CLUSTERNAME"
    suffix              = "EKS"
    vpc_id              = "vpc-xxxxx"
    is_self             = false
    source_sg_ids = [
        ["Allow worker Kubelets and pods to receive communication from the cluster control plane",
            "sg-xxxxxxxx", 0, 65535, "-1", "ingress"],
    ]
    # tuple : list of [description, source_cidr, from, to, protocol, type]
    source_sg_cidrs = [
        ["Bastion",
            ["10.xx.xx.xxx/32"], 22, 22, "tcp", "ingress"],
        ["Office 1",
            ["58.xxx.xxx.xxx/32"], 22, 22, "tcp", "ingress"],
        ["Office wifi",
            ["58.xxx.xxx.xxx/32"], 22, 22, "tcp", "ingress"],
    ]
    
    full_name = "${local.city}-${local.stage}-${local.name}-${local.suffix}"
    upper_name = "${upper(local.full_name)}"
    lower_name = "${lower(local.full_name)}"
}


resource "aws_security_group" "this" {
    name        = "${local.sg_name}.${local.lower_name}"
    description = "${local.sg_desc}"

    vpc_id = "${local.vpc_id}"

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${local.sg_name}.${local.lower_name}"
        SG_Groups = "${local.lower_name}"

    }

}

resource "aws_security_group_rule" "self" {
    count = local.is_self ? 1 : 0

    description              = "Allow all to communicate with each other"
    security_group_id        = "${aws_security_group.this.id}"
    source_security_group_id = "${aws_security_group.this.id}"
    from_port                = 0
    to_port                  = 65535
    protocol                 = "-1"
    type                     = "ingress"
}

resource "aws_security_group_rule" "sg_ids" {
    count = length(local.source_sg_ids)

    description              = "${local.source_sg_ids[count.index][0]}"
    security_group_id        = "${aws_security_group.this.id}"
    source_security_group_id = "${local.source_sg_ids[count.index][1]}"
    from_port                = "${local.source_sg_ids[count.index][2]}"
    to_port                  = "${local.source_sg_ids[count.index][3]}"
    protocol                 = "${local.source_sg_ids[count.index][4]}"
    type                     = "${local.source_sg_ids[count.index][5]}"
}

resource "aws_security_group_rule" "sg_cidrs" {
    count = length(local.source_sg_cidrs)

    description       = "${local.source_sg_cidrs[count.index][0]}"
    security_group_id = "${aws_security_group.this.id}"
    cidr_blocks       = "${local.source_sg_cidrs[count.index][1]}"
    from_port         = "${local.source_sg_cidrs[count.index][2]}"
    to_port           = "${local.source_sg_cidrs[count.index][3]}"
    protocol          = "${local.source_sg_cidrs[count.index][4]}"
    type              = "${local.source_sg_cidrs[count.index][5]}"
}
