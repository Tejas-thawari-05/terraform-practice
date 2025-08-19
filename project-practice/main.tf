# CUSTUM NETWORK WITH 2 PUBLIC SUBNET AND 6 PRIVATE SUBNETS AND 3 INSTANCE 1 PUBLIC 2 PRIVATE AS  [FRONTEND AND BACKEND] AND 1 RDS 

# CREATION OF THE VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  tags = {
    Name= "my-vpc-cust"
  }
}

# CREATION OF PUBLIC SUBNET
resource "aws_subnet" "public-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public-subnet-cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-2"
  }
}

# CREATION OF PRIVATE FRONTEND SUBNET
resource "aws_subnet" "frontend-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "frontend-1"
  }
}

resource "aws_subnet" "frontend-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "frontend-2"
  }
}

# CREATION OF PRIVATE BACKEND SUBNET
resource "aws_subnet" "backend-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.20.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "backend-1"
  }
}

resource "aws_subnet" "backend-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.21.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "backend-2"
  }
}


# CREATION OF PRIVATE DATABASE SUBNET
resource "aws_subnet" "RDS" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.30.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "RDS"
  }
}

resource "aws_subnet" "replica" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.31.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "replica"
  }
}


# CREATION OF INTERNAET GATEWAY AND ATTACH TO THE VPC
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "cust-IG"
  }
}

# CREATION OF THE ROUTE TABLE AND EDIT ROUTES
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "cust-RT"
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

resource "aws_route_table_association" "associate-2" {
  route_table_id = aws_route_table.RT.id
  subnet_id = aws_subnet.public-2.id
}

# ALLOCATION OF ELASTIC IP
resource "aws_eip" "eip" {
    domain = "vpc"
    tags = {
      Name = "epi-nat"
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
    Name = "pvt-RT"
  }
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

# CREATING SUBNET ASSOCIATION FOR PRIVATE ROUTE TABLE
resource "aws_route_table_association" "pvt-frontend-1" {
  route_table_id = aws_route_table.pvt-RT.id
  subnet_id = aws_subnet.frontend-1.id
}
resource "aws_route_table_association" "pvt-frontend-2" {
  route_table_id = aws_route_table.pvt-RT.id
  subnet_id = aws_subnet.frontend-2.id
}
resource "aws_route_table_association" "pvt-backend-1" {
  route_table_id = aws_route_table.pvt-RT.id
  subnet_id = aws_subnet.backend-1.id
}
resource "aws_route_table_association" "pvt-backend-2" {
  route_table_id = aws_route_table.pvt-RT.id
  subnet_id = aws_subnet.backend-2.id
}

# CREATION OF SECURITY GROUP
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  name        = "allow_tls"
  description = "Allow inbound traffic on port 22 and 80"
  tags = {
    Name = "cust-sg"
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

  ingress {
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
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
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "public-ec2"
  }
  subnet_id = aws_subnet.public-1.id
  vpc_security_group_ids = [ aws_security_group.sg.id ]
  associate_public_ip_address = true
}

# CREATIION OF PRIVATE EC2 INSTANCE
resource "aws_instance" "frontend-ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "frontend-ec2"
    }
    subnet_id = aws_subnet.frontend-1.id
    key_name = var.key-name
    vpc_security_group_ids = [ aws_security_group.sg.id ]
}

resource "aws_instance" "backend-ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "backend-ec2"
    }
    subnet_id = aws_subnet.backend-1.id
    key_name = var.key-name
    vpc_security_group_ids = [ aws_security_group.sg.id ]
}


resource "aws_db_subnet_group" "name" {
  name = "subnet-grup"
  subnet_ids = [aws_subnet.RDS.id,aws_subnet.replica.id]           #  replace subnet ids
  tags = {
    Name = "bd-subnet-grup"
  }
}

resource "aws_db_instance" "name" {
  
  db_subnet_group_name = aws_db_subnet_group.name.name

  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name              = "terraformdb"
  username               = "admin"
  password               = "123456789"
  skip_final_snapshot    = true
  publicly_accessible    = false

  vpc_security_group_ids = [aws_security_group.sg.id]
  
  depends_on = [ aws_db_subnet_group.name ]

}