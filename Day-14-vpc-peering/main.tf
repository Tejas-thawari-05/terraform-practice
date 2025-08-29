provider "aws" {
  
}
resource "aws_vpc_peering_connection" "foo" {
  peer_vpc_id   = aws_vpc.vpca.id
  vpc_id        = aws_vpc.vpcb.id
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc" "vpca" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_vpc" "vpcb" {
  cidr_block = "10.2.0.0/16"
}

resource "aws_internet_gateway" "A" {
  vpc_id = aws_vpc.vpca.id

}
resource "aws_route_table" "A" {
  vpc_id = aws_vpc.vpca.id
  tags = {
    Name = "A-rout"
  }

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.A.id
  }
}

resource "aws_internet_gateway" "B" {
  vpc_id = aws_vpc.vpcb.id

}
resource "aws_route_table" "B" {
  vpc_id = aws_vpc.vpcb.id
  tags = {
    Name = "B-rout"
  }

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.B.id
  }
}



# Add route in VPC-A route table to reach VPC-B
resource "aws_route" "vpc_a_to_vpc_b" {
  route_table_id            = aws_route_table.A.id
  destination_cidr_block    = aws_vpc.vpcb.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
}

# Add route in VPC-B route table to reach VPC-A
resource "aws_route" "vpc_b_to_vpc_a" {
  route_table_id            = aws_route_table.B.id
  destination_cidr_block    = aws_vpc.vpcb.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
}