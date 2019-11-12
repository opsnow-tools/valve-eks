# security group



locals {
    sg_name             = "mysg"
    sg_desc             = "This is my Security Group"
    city                = "SEOUL"
    stage               = "STAGE"
    name                = "CLUSTERNAME"
    suffix              = "EKS"
    vpc_id              = "vpc-xxxxx"
    source_sg_ids       = []
    source_sg_cidrs     = [
                            {
                                desc = "Bastion",
                                cidrs = ["10.xxx.xx.xxx/32"],
                                from = 22,
                                to = 22,
                                protocol = "tcp",
                                type = "ingress"
                            },
                            {
                                desc = "Office",
                                cidrs = ["58.xxx.xxx.xxx/32", "58.xxx.xx.xxx/32", "58.xxx.xxx.xxx/32"],
                                from = 22,
                                to = 22,
                                protocol = "tcp",
                                type = "ingress"
                            },
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

    dynamic "ingress" {
        for_each = local.source_sg_cidrs
        content {
            description     = ingress.value["desc"]
            from_port       = ingress.value["from"]
            to_port         = ingress.value["to"]
            protocol        = ingress.value["protocol"]
            cidr_blocks     = ingress.value["cidrs"]
        }
    }

    dynamic "ingress" {
        for_each = local.source_sg_ids
        content {
            description     = ingress.value["desc"]
            from_port       = ingress.value["from"]
            to_port         = ingress.value["to"]
            protocol        = ingress.value["protocol"]
            security_groups = ingress.value["security_groups"]
        }
    }

    tags = {
        Name = "${local.sg_name}.${local.lower_name}"
        SG_Groups = "${local.lower_name}"

    }

}
