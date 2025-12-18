# Creating a NAT Gateway in Public subnet using allocated elastic ip (EIP)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "$(project_name)-nat_gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}

# Route : from private route table to NAT Gateway
resource "aws_route" "private_to_nat" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
