# vpc

resource "aws_vpc" "this" {
  count = var.vpc_id == "" ? 1 : 0

  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true

  tags = merge(
    {
      "Name" = local.full_name
    },
    var.tags,
  )
}

data "aws_vpc" "this" {
  id = var.vpc_id == "" ? element(concat(aws_vpc.this.*.id, [""]), 0) : var.vpc_id
}

resource "aws_internet_gateway" "this" {
  count = var.vpc_id == "" ? 1 : 0

  vpc_id = element(concat(aws_vpc.this.*.id, [""]), 0)

  tags = merge(
    {
      "Name" = local.full_name
    },
    var.tags,
  )
}

data "aws_internet_gateway" "this" {
  count = var.vpc_id == "" ? 0 : 1
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id == "" ? element(concat(aws_vpc.this.*.id, [""]), 0) : var.vpc_id]
  }
}
