# cluster subnet private

locals {
  private_a_cidr = "10.253.3.0/24"
  private_a_az = "ap-northeast-2a"
  private_c_cidr = "10.253.4.0/24"
  private_c_az = "ap-northeast-2c"
}

resource "aws_subnet" "private_A" {
  vpc_id = aws_vpc.this.id
  cidr_block = local.private_a_cidr
  availability_zone = local.private_a_az
  tags = merge(
    {
      "Name" = "${local.region_A_upper_name}-PRIVATE"
    },
    local.tags,
  )
}

resource "aws_subnet" "private_C" {
  vpc_id = aws_vpc.this.id
  cidr_block = local.private_c_cidr
  availability_zone = local.private_c_az
  tags = merge(
    {
      "Name" = "${local.region_C_upper_name}-PRIVATE"
    },
    local.tags,
  )
}

resource "aws_route_table" "private_A" {
  vpc_id = aws_vpc.this.id

  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.private_A.id
  }

  tags = merge(
    {
      "Name" = "${local.region_A_upper_name}-PRIVATE"
    },
    local.tags,
  )
}

resource "aws_route_table" "private_C" {
  vpc_id = aws_vpc.this.id

  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.private_C.id
  }

  tags = merge(
    {
      "Name" = "${local.region_C_upper_name}-PRIVATE"
    },
    local.tags,
  )
}

resource "aws_route_table_association" "private_A" {
  route_table_id = aws_route_table.private_A.id
  subnet_id = aws_subnet.private_A.id
}

resource "aws_route_table_association" "private_C" {
  route_table_id = aws_route_table.private_C.id
  subnet_id = aws_subnet.private_C.id
}
