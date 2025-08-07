

resource "aws_instance" "name" {
  ami = var.ami
  instance_type = var.instance-type
   tags = {
      Name = var.instance-name
    }
    
} 