# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "VPC-Main"
  }
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "internetgateway"
  }
}

# Subnets
data "aws_availability_zones" "available" {
  state = "available"
}

# Primary (public) Subnet for web
resource "aws_subnet" "primary" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "primary_subnet"
  }
}


# Secondary (private) Subnet
resource "aws_subnet" "secondary" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "secondary_subnet"
  }
}

# Another Private subnet for db
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]
  tags = {
    Name = "private_subnet"
  }
}

# NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "NATGateway"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.primary.id
  depends_on    = [aws_internet_gateway.igw]
}

# Route Table for Private subnet. Private subnet associated to Main Route table.
resource "aws_route_table" "main-private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "main-private"
  }
}

# Route table for Public subnet
resource "aws_route_table" "Custom-RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Custom-RT"
  }
}

# Route Table Subnet associations
resource "aws_route_table_association" "main-private" {
  route_table_id = aws_route_table.main-private.id
  subnet_id      = aws_subnet.secondary.id
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.main-private.id
  subnet_id      = aws_subnet.private.id
}

resource "aws_route_table_association" "Custom" {
  route_table_id = aws_route_table.Custom-RT.id
  subnet_id      = aws_subnet.primary.id
}
