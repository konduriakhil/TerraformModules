
# public ip for nat gateway
resource "aws_eip" "base" {
  count = var.is_nat_gateway_required ? 1 : 0
  tags = {
    Name = "nat-gateway-ip"
  }
}

resource "aws_nat_gateway" "base" {
  count         = var.is_nat_gateway_required ? 1 : 0
  allocation_id = aws_eip.base[0].id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "nat-gateway"
  }
  depends_on = [aws_subnet.private, aws_eip.base]
}

resource "aws_route" "nat_gateway_route" {
  count                  = var.is_nat_gateway_required ? 1 : 0
  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = local.anywhere
  nat_gateway_id         = aws_nat_gateway.base[0].id
}