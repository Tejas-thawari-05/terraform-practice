# CREATION OF THE VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name= "my-vpc-cust"
  }
}

# CREATION OF SUBNET
resource "aws_subnet" "public-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    name = "public-1"
  }
}

resource "aws_subnet" "private-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    name = "private-1"
  }
}

# CREATION OF INTERNAET GATEWAY AND ATTACH TO THE VPC
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    name = "cust-IG"
  }
}

# CREATION OF THE ROUTE TABLE AND EDIT ROUTES
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    name = "cust-RT"
  }
  route { 
    cidr_block = "0.0.0.0/0"
    gateway_id =  aws_internet_gateway.IGW.id
  } 
}

# CREATION OF SUBNET ASSOCIATION
resource "aws_route_table_association" "associate" {
  route_table_id = aws_route_table.RT.id
  subnet_id = aws_subnet.public-1.id
}

# ALLOCATION OF ELASTIC IP
resource "aws_eip" "eip" {
    domain = "vpc"
    tags = {
      name = "epi-nat"
    }
}


# CREATION OF NAT GATEWAY
resource "aws_nat_gateway" "nat" {
  subnet_id = aws_subnet.public-1.id
  connectivity_type = "public"
  allocation_id = aws_eip.eip.id
  depends_on = [ aws_internet_gateway.IGW ]
}


# CREATING PRIVATE ROUTE TABLE
resource "aws_route_table" "pvt-RT" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    name = "pvt-RT"
  }
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

# CREATING SUBNET ASSOCIATION FOR PRIVATE ROUTE TABLE
resource "aws_route_table_association" "pvt-association" {
  route_table_id = aws_route_table.pvt-RT.id
  subnet_id = aws_subnet.private-1.id
}

# CREATION OF SECURITY GROUP
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  name        = "allow_tls"
  description = "Allow inbound traffic on port 22 and 80"
  tags = {
    name = "cust-sg"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# CREATION OF PUBLIC EC2 INSTANCE
resource "aws_instance" "public-ec2" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  tags = {
    name = "public-ec2"
  }
  subnet_id = aws_subnet.public-1.id
  vpc_security_group_ids = [ aws_security_group.sg.id ]
  associate_public_ip_address = true
}

# CREATIION OF PRIVATE EC2 INSTANCE
resource "aws_instance" "private-ec2" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  tags = {
    name = "private-ec2"
    }
    subnet_id = aws_subnet.private-1.id
    key_name = "project"
    vpc_security_group_ids = [ aws_security_group.sg.id ]
}
