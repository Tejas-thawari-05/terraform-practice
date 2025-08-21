resource "aws_vpc" "name" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc-name
  }
}

resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.subnet-cidr
  availability_zone = var.availability_zone
  tags = {
    Name = var.subnet-name
  }
}

output "subnet_id" {
  value = aws_subnet.name.id
}