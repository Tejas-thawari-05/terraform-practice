#  PROVISIONER ARE OF THREE TYPES 1. FILE
#                                 2. LOCAL exec PROVISIONER
#                                 3. REMOTE exec PROCISIONAR

# PROVISIONER BLOCK IS WRITTEN IN THE RESOURCE BLOCK


#Solution-2 to Re-Run the Provisioner
#Use terraform taint to manually mark the resource for recreation:
# terraform taint aws_instance.name
# terraform apply

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cust-vpc"
  }
}

resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.name.id
    }
}

resource "aws_route_table_association" "name" {
  subnet_id = aws_subnet.name.id
  route_table_id = aws_route_table.name.id
}

resource "aws_security_group" "name" {
  name = "cust-sg"
  vpc_id = aws_vpc.name.id

  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "22"
    to_port = "22"
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

# resource "aws_key_pair" "name" {
#   key_name = "test"
#   public_key = file("~/.ssh/id_ed25519.pub")
# }

resource "aws_instance" "name" {

    ami = "ami-08a6efd148b1f7504"
    instance_type = "t2.micro"

    vpc_security_group_ids = [ aws_security_group.name.id ]

    subnet_id = aws_subnet.name.id

    key_name = "project"

    associate_public_ip_address = true

    tags = {
      Name = "test-ec2-provisioner"
    }


# connection {
#     type = "ssh"
#     user = "ec2-user"
#     port = "22"
#     #private_key = file("~/.ssh/id_ed25519")
#     private_key = file("C:/Users/tejas_oiqucju/Downloads/project.pem")
#     host = self.public_ip
#     timeout = 2
# }

#   provisioner "file" {
#     source      = "file10"
#     destination = "/home/ec2-user/file10"
#   }

#   provisioner "local-exec" {
#     command = "touch file20"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "touch /home/ec2-user/file30",
#       "echo 'hello from devops' >> /home/ec2-user/file30"
#     ]
#   }
}


resource "null_resource" "run_script" {
  provisioner "remote-exec" {
    connection {
      host        = aws_instance.name.public_ip
      user        = "ec2-user"
      private_key = file("C:/Users/tejas_oiqucju/Downloads/project.pem")
    }

    inline = [
        "echo 'hello from multicloud' >> /home/ec2-user/file30"
    ]
  }

  triggers = {
    always_run = "${timestamp()}" # Forces rerun every time
  }
}