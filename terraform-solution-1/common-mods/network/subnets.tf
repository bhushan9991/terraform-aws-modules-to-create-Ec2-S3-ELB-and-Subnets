# VPC resources: This will create 2 Subnets, 1 Internet Gateway, 1 Nat Gateway, Route Tables & association.

resource "aws_internet_gateway" "default" {
  vpc_id = var.vpc_id
  tags = {
      Name  = "subnet_1_gatway"
      product_id = "test_product"
  }
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidr_blocks)
  vpc_id = var.vpc_id
}

resource "aws_route" "private" {
  count = length(var.private_subnet_cidr_blocks)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default[count.index].id
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = "eu-west-1a"
  tags = {
      Name       = "subnet_2"
      product_id = "test_product"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true
  tags = {
      Name       = "subnet_1"
      product_id = "test_product"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


# NAT resources: This will create NAT gateway.

resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidr_blocks)

  vpc = true
}

resource "aws_nat_gateway" "default" {
  depends_on = [aws_internet_gateway.default]
  count = length(var.public_subnet_cidr_blocks)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
      Name  = "subnet_1_nat"
      product_id = "test_product"
  }
}
