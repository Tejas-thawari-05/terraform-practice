module "vpc" {
  source = "./module/vpc"
  cidr_block = var.vpc-cidr
  vpc-name = var.vpc-name
  subnet-cidr = var.subnet-cidr
  subnet-name = var.subnet-name
  availability_zone = var.availability_zone
}

module "ec2" {
  source = "./module/ec2"
    ami = var.ami-id
    instance_type = var.instance_type
    instance-name = var.instance-name
    subnet_id = module.vpc.subnet_id
}

module "rds" {
  source         = "./module/RDS"
  aws_db_subnet_group = var.aws_db_subnet_group
  subnet_ids      = module.vpc.subnet_id
  instance_class = var.instance_class
  db_name        = var.db_name
  username        = var.username
  password    = var.password
}