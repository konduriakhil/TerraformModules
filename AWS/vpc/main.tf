# create vpc
resource "aws_vpc" "base" {
  cidr_block           = var.vpc_configuration.cidr_block
  instance_tenancy     = var.vpc_configuration.instance_tenancy
  enable_dns_support   = var.vpc_configuration.enable_dns_support
  enable_dns_hostnames = var.vpc_configuration.enable_dns_hostnames
  tags                 = var.vpc_configuration.tags
}

# public subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.base.id
  cidr_block        = var.public_subnets[count.index].cidr_block
  availability_zone = var.public_subnets[count.index].availability_zone
  tags              = var.public_subnets[count.index].tags
  depends_on        = [aws_vpc.base]
}

# private subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.base.id
  cidr_block        = var.private_subnets[count.index].cidr_block
  availability_zone = var.private_subnets[count.index].availability_zone
  tags              = var.private_subnets[count.index].tags
  depends_on        = [aws_vpc.base]

}

# create internet gateway if public subnets are present
resource "aws_internet_gateway" "base" {
  count  = local.is_public
  vpc_id = aws_vpc.base.id
  tags = {
    Name = "Internet Gateway"
  }
  depends_on = [aws_vpc.base]
}

# create a public route table if public subnets are present
resource "aws_route_table" "public" {
  count  = local.is_public
  vpc_id = aws_vpc.base.id
  tags = {
    Name = "Public Route Table"
  }
  depends_on = [aws_vpc.base]
}

# create a route to internet gateway if public subnets are present
resource "aws_route" "public" {
  count                  = local.is_public
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = local.anywhere
  gateway_id             = aws_internet_gateway.base[0].id
  depends_on             = [aws_route_table.public, aws_internet_gateway.base]
}

# associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
  depends_on     = [aws_subnet.public, aws_route_table.public]
}

# create private route table if private subnets are present
resource "aws_route_table" "private" {
  count  = local.is_private
  vpc_id = aws_vpc.base.id
  tags = {
    Name = "Private Route Table"
  }
  depends_on = [aws_vpc.base]
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
  depends_on     = [aws_subnet.private, aws_route_table.private]
}


