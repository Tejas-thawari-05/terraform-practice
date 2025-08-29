resource "aws_db_instance" "default" {
  allocated_storage       = 10
   identifier =             "book-rds"
  db_name                 = "mydb"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"



#   RDS MANAGED SECRETS IN SECRET MANAGER RDS AUTOMATICALLY CREATES PASSWORD WITH AUTO ROTATION
  manage_master_user_password = true #rds and secret manager manage this password



  username                    = "admin"
  
  parameter_group_name    = "default.mysql8.0"
  backup_retention_period  = 7   # Retain backups for 7 days
  backup_window            = "02:00-03:00" # Daily backup window (UTC)

  # Enable performance insights
#   performance_insights_enabled          = true
#   performance_insights_retention_period = 7  # Retain insights for 7 days
  maintenance_window = "sun:04:00-sun:05:00"  # Maintenance every Sunday (UTC)
  deletion_protection = false
  skip_final_snapshot = true
  
}


data "aws_secretsmanager_secret_version" "name" {
  secret_id = aws_db_instance.default.master_user_secret_kms_key_id
  depends_on = [ aws_db_instance.default ]
}

# Example EC2 instance (replace with yours if already existing)
resource "aws_instance" "sql_runner" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type          = "t2.micro"
  key_name               = "project"                # Replace with your key pair name
  associate_public_ip_address = true

  tags = {
    Name = "SQL Runner"
  }
}

# Deploy SQL remotely using null_resource + remote-exec
resource "null_resource" "remote_sql_exec" {
  depends_on = [aws_db_instance.default, aws_instance.sql_runner]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/tejas_oiqucju/Downloads/project.pem")   # Replace with your PEM file path
    host        = aws_instance.sql_runner.public_ip
  }

  provisioner "file" {
    source      = "init.sql"
    destination = "/tmp/init.sql"
  }

  provisioner "remote-exec" {
    inline = [
        "sudo su -",
        "sudo yum install mariadb105-server -y",
      "mysql -h ${aws_db_instance.default.address} -u ${aws_db_instance.default.username} -p${data.aws_secretsmanager_secret_version.name.secret_string} < /tmp/init.sql"
    ]
  }

  triggers = {
    always_run = timestamp() #trigger every time apply 
  }
}




# ADD RDS creation script only accessbale interanlly is disable public access 
# Remote provisioner server also should create insame vpc 
# enable secrets fro secret manager and call secrets into RDS for this process vpc endpoint is require or nat gateway is required to access secrets to rds internall as secremanger is not in side VPC sefrvice 