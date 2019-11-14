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

    dynamic "ingress" {
        for_each = var.source_sg_cidrs
        content {
            description     = ingress.value["desc"]
            from_port       = ingress.value["from"]
            to_port         = ingress.value["to"]
            protocol        = ingress.value["protocol"]
            cidr_blocks     = ingress.value["cidrs"]
        }
    }

    dynamic "ingress" {
        for_each = var.source_sg_ids
        content {
            description     = ingress.value["desc"]
            from_port       = ingress.value["from"]
            to_port         = ingress.value["to"]
            protocol        = ingress.value["protocol"]
            security_groups = ingress.value["security_groups"]
        }
    }

    tags = {
        Name = "${var.sg_name}.${local.lower_name}"
        SG_Groups = "${local.lower_name}"

    }

}
