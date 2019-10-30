# security group

resource "aws_security_group" "this" {
    name        = "${var.sg_name}.${local.lower_name}"
    description = "${var.sg_desc}"

    vpc_id = "${var.vpc_id}"

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.sg_name}.${local.lower_name}"
        SG_Groups = "${local.lower_name}"

    }

}

resource "aws_security_group_rule" "self" {
    count = var.is_self ? 1 : 0

    description              = "Allow all to communicate with each other"
    security_group_id        = "${aws_security_group.this.id}"
    source_security_group_id = "${aws_security_group.this.id}"
    from_port                = 0
    to_port                  = 65535
    protocol                 = "-1"
    type                     = "ingress"
}

resource "aws_security_group_rule" "sg_ids" {
    count = length(var.source_sg_ids)

    description              = "${var.source_sg_ids[count.index][0]}"
    security_group_id        = "${aws_security_group.this.id}"
    source_security_group_id = "${var.source_sg_ids[count.index][1]}"
    from_port                = "${var.source_sg_ids[count.index][2]}"
    to_port                  = "${var.source_sg_ids[count.index][3]}"
    protocol                 = "${var.source_sg_ids[count.index][4]}"
    type                     = "${var.source_sg_ids[count.index][5]}"
}

resource "aws_security_group_rule" "sg_cidrs" {
    count = length(var.source_sg_cidrs)

    description       = "${var.source_sg_cidrs[count.index][0]}"
    security_group_id = "${aws_security_group.this.id}"
    cidr_blocks       = "${var.source_sg_cidrs[count.index][1]}"
    from_port         = "${var.source_sg_cidrs[count.index][2]}"
    to_port           = "${var.source_sg_cidrs[count.index][3]}"
    protocol          = "${var.source_sg_cidrs[count.index][4]}"
    type              = "${var.source_sg_cidrs[count.index][5]}"
}
