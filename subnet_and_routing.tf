
# Public Subnet 1 (AZ 1)
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "${var.project_name}_Public_Subnet_1"
  }

}

# Private Subnet 1 (AZ 1) - App server
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "${var.project_name}_Private_Subnet_1"
  }
}

# Private Subnet 2 (AZ 2) - Database Primary
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "${var.project_name}_Private_Subnet_2"
  }
}

# Private Subnet 3 (AZ 2) - Database Secondary
resource "aws_subnet" "private_3" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_3_cidr
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "${var.project_name}_Private_Subnet_3"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.project_name}_Public_RT"
  }
}

# Route: Public Route Table to Internet Gateway(0.0.0.0/0 -> IGW)
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Route: Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.project_name}-Private_RT"
  }
}

# Associate Private subnets with Private Route Table
resource "aws_route_table_association" "private_rt_assoc_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_rt_assoc_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_rt_assoc_3" {
  subnet_id      = aws_subnet.private_3.id
  route_table_id = aws_route_table.private_rt.id
}
