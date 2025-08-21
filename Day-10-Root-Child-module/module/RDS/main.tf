resource "aws_db_subnet_group" "name" {
  name = var.aws_db_subnet_group
  subnet_ids = [ var.subnet_ids ]
    tags = {
      Name = var.subnet-grup-tag
    }
}

resource "aws_db_instance" "name" {
  allocated_storage = 20
  engine = "mysql"
  instance_class = var.instance_class
  db_name = var.db_name
  username = var.username
  password = var.password
  db_subnet_group_name =  "aws_db_subnet_group.name"
  skip_final_snapshot = true
}


