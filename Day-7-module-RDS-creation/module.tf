module "dev_rds" {
  source = "./RDS"

  db_subnet_group_name = "dev-db-subnet-group"
  subnet_ids           = ["subnet-00fee1454668ab5cb" , "subnet-0a6b71039669ef29e"]
  sg_name              = "dev-rds-sg"
  vpc_id               = "vpc-0ee5c504a0d6077b3"
  allowed_sg_ids       = ["sg-0fe25815639092376"]
  allocated_storage    = 20
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "devdb"
  username             = "admin"
  password             = "123456789"
  publicly_accessible  = true
  db_instance_name     = "dev-rds"
}
