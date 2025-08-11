# DB Subnet Group
resource "aws_db_subnet_group" "sg-grup" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_ids
  tags = {
    Name = var.db_subnet_group_name
  }
}

# Security Group for RDS
resource "aws_security_group" "sg" {
  name   = var.sg_name
  vpc_id = var.vpc_id

  tags = {
    Name = var.sg_name
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.allowed_sg_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "RDS" {
  allocated_storage      = var.allocated_storage
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  skip_final_snapshot    = true
  publicly_accessible    = var.publicly_accessible

  db_subnet_group_name   = aws_db_subnet_group.sg-grup.name
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = var.db_instance_name
  }

  depends_on = [ aws_db_subnet_group.sg-grup ]
}
