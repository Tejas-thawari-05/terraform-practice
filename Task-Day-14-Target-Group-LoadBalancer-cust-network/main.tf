# CREATION OF THE VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  tags = {
    Name= "my-vpc-cust"
  }
}

# CREATION OF SUBNET
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
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-2"
  }
}

resource "aws_subnet" "private-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private-subnet-cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-1"
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
    cidr_block = var.pub-Rt-route-cide
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
    cidr_block = var.pvt-Rt-route-cide
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
resource "aws_instance" "private-ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "private-ec2"
    }
    subnet_id = aws_subnet.private-1.id
    key_name = var.key-name
    vpc_security_group_ids = [ aws_security_group.sg.id ]
   
   user_data = file("script.sh")
}

resource "aws_lb_target_group" "tg" {
    vpc_id = aws_vpc.vpc.id
  name = "cust-tg"
  port = 80
  protocol = "HTTP"

  health_check {
    path = "/"
    port = "80"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    timeout = 2
    healthy_threshold = 2
    unhealthy_threshold = 2
  }

}

resource "aws_lb_target_group_attachment" "tg-attach" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.private-ec2.id
  port = 80
}

resource "aws_lb" "lb" {
  load_balancer_type = "application"
  name = "cust-lb"
  internal = false

  security_groups = [ aws_security_group.sg.id ]

  subnets = [ 
    aws_subnet.public-1.id ,
    aws_subnet.public-2.id
   ]

}

resource "aws_lb_listener" "name" {
  load_balancer_arn = aws_lb.lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}