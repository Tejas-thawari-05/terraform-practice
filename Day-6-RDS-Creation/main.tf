resource "aws_security_group" "dev_rds_sg" {
  name   = "dev-rds-sg"
  vpc_id = "    "                              # add vpc id
  tags = {
    Name = "dev-rds-sg"
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "TCP"
   
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "name" {
  name = "subnet-grup"
  subnet_ids = ["subnet-id-1 ","subnet-id-2"]           #  replace subnet ids
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
  db_name                = "test-db"
  username               = "admin"
  password               = "123456789"
  skip_final_snapshot    = true
  publicly_accessible    = true

  vpc_security_group_ids = [aws_security_group.dev_rds_sg.id]

  depends_on = [ aws_db_subnet_group.dev_db_subnet_group ]

}