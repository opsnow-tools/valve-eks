# security group

# For ALB
resource "aws_security_group" "service" {
    name = "service.${local.lower_name}"
    description = "Security group for load balancer"

    vpc_id = "${var.vpc_id}"

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "http"
        from_port   = 80
        to_port     = 80
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "https"
        from_port   = 443
        to_port     = 443
        protocol    = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "service.${local.lower_name}"
        SG_Groups = "${local.lower_name}"

    }
}

resource "aws_security_group" "node-ingress" {
    name        = "${var.sg_name}.${local.lower_name}"
    description = "${var.sg_desc}"

    vpc_id = "${var.vpc_id}"

    ingress {
        description = "ALB for nginx-ingress-controller"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        security_groups = [aws_security_group.service.id]
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
