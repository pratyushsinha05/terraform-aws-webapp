resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = 3
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.${16 + count.index}.0/24" 
  availability_zone = element(["${var.AWS_REGION}a", "${var.AWS_REGION}b", "${var.AWS_REGION}c"], count.index)
  tags = {
    Name        = "public_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = 3
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.${22 + count.index}.0/24" 
  availability_zone = element(["${var.AWS_REGION}a", "${var.AWS_REGION}b", "${var.AWS_REGION}c"], count.index)
  tags = {
    Name        = "private_subnet_${count.index + 1}"
  }
}

resource "aws_eip" "elastic_ip" {
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id = element(aws_subnet.public_subnet[*].id, 0)
  tags = {
    Name = "nat-gateway"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-route-table"
  }
}


resource "aws_route_table_association" "public_subnet_association" {
  count          = 3
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = 3
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route" "public_route_to_nat_gateway" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}
