# cluster subnet public

resource "aws_subnet" "public" {
  count = local.public_count

  vpc_id = data.aws_vpc.this.id

  cidr_block = length(var.public_subnet_cidrs) > 0 ? var.public_subnet_cidrs[count.index] : cidrsubnet(
    data.aws_vpc.this.cidr_block,
    var.public_subnet_newbits,
    count.index + var.public_subnet_netnum,
  )

  availability_zone = local.public_names[count.index]

  tags = merge(
    {
      "Name" = "${var.city}-${upper(
        element(split("", local.public_names[count.index]), local.public_length - 1),
      )}-${local.name}-PUBLIC"
    },
    var.tags,
  )
}

resource "aws_route_table" "public" {
  count = local.public_count > 0 ? 1 : 0

  vpc_id = data.aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    {
      "Name" = "${local.full_name}-PUBLIC"
    },
    var.tags,
  )
}

resource "aws_route_table_association" "public" {
  count = local.public_count

  route_table_id = aws_route_table.public[0].id
  subnet_id      = aws_subnet.public[count.index].id
}
