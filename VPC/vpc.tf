# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-main-vpc"
  })
}


# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-igw"
  })
}


#  Public Subnets
resource "aws_subnet" "public_subnet_az_1a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[0]
  availability_zone = var.availability_zones[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-subnet-az-1a"
  })
}

resource "aws_subnet" "public_subnet_az_1b" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[1]
  availability_zone = var.availability_zones[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-subnet-az-1b"
  })
}


# Private Subnets
resource "aws_subnet" "private_subnet_az_1a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[0]
  availability_zone = var.availability_zones[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-subnet-az-1a"
  })
}

resource "aws_subnet" "private_subnet_az_1b" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[1]
  availability_zone = var.availability_zones[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-subnet-az-1b"
  })
}


#Database Subnets
resource "aws_subnet" "database_subnet_az_1a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.database_subnet_cidr_blocks[0]
  availability_zone = var.availability_zones[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-database-subnet-az-1a"
  })
}

resource "aws_subnet" "database_subnet_az_1b" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.database_subnet_cidr_blocks[1]
  availability_zone = var.availability_zones[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-database-subnet-az-1b"
  })
}


# Route Table for Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-rt"
  })
}


# Associate Public Subnets with Route Table
resource "aws_route_table_association" "public_subnet_az_1a_association" {
  subnet_id      = aws_subnet.public_subnet_az_1a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_az_1b_association" {
  subnet_id      = aws_subnet.public_subnet_az_1b.id
  route_table_id = aws_route_table.public_route_table.id
}


#EIP for NAT Gateways
resource "aws_eip" "nat_eip_az_1a" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-eip-az-1a"
  })
}

resource "aws_eip" "nat_eip_az_1b" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-eip-az-1b"
  })
}


# NAT Gateways
resource "aws_nat_gateway" "nat_gw_az_1a" {
  allocation_id = aws_eip.nat_eip_az_1a.allocation_id
  subnet_id     = aws_subnet.public_subnet_az_1a.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw-az-1a"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gw_az_1b" {
  allocation_id = aws_eip.nat_eip_az_1b.allocation_id
  subnet_id     = aws_subnet.public_subnet_az_1b.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw-az-1b"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}


# Private Route Tables for Private Subnets
resource "aws_route_table" "private_route_table_az_1a" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_az_1a.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-az-1a"
  })
}

resource "aws_route_table" "private_route_table_az_1b" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_az_1b.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-az-1b"
  })
}


# Associate Private Subnets with Private Route Tables
resource "aws_route_table_association" "private_subnet_az_1a_association" {
  subnet_id      = aws_subnet.private_subnet_az_1a.id
  route_table_id = aws_route_table.private_route_table_az_1a.id
}

resource "aws_route_table_association" "private_subnet_az_1b_association" {
  subnet_id      = aws_subnet.private_subnet_az_1b.id
  route_table_id = aws_route_table.private_route_table_az_1b.id
}

#Associate Database Subnets with Private Route Tables
resource "aws_route_table_association" "database_subnet_az_1a_association" {
  subnet_id      = aws_subnet.database_subnet_az_1a.id
  route_table_id = aws_route_table.private_route_table_az_1a.id
}

resource "aws_route_table_association" "database_subnet_az_1b_association" {
  subnet_id      = aws_subnet.database_subnet_az_1b.id
  route_table_id = aws_route_table.private_route_table_az_1b.id
}

