# eip & nat-gateway

resource "aws_eip" "private_A" {
  vpc = true
  depends_on = [aws_route_table.public]
  tags = merge(
    {
      "Name" = "${local.region_A_upper_name}-PRIVATE"
    },
    local.tags,
  )
}

resource "aws_eip" "private_C" {
  vpc = true
  depends_on = [aws_route_table.public]
  tags = merge(
    {
      "Name" = "${local.region_C_upper_name}-PRIVATE"
    },
    local.tags,
  )
}

resource "aws_nat_gateway" "private_A" {
  allocation_id = aws_eip.private_A.id
  subnet_id = aws_subnet.public_A.id
  tags = merge(
    {
      "Name" = "${local.region_A_upper_name}-PRIVATE"
    },
    local.tags,
  )
}

resource "aws_nat_gateway" "private_C" {
  allocation_id = aws_eip.private_C.id
  subnet_id = aws_subnet.public_C.id
  tags = merge(
    {
      "Name" = "${local.region_C_upper_name}-PRIVATE"
    },
    local.tags,
  )
}
