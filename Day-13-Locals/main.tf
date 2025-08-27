locals {
  region = "us-east-1"
  instance_type = "t2.micro"
  instance-name = "dev"
}


data "aws_ami" "amzlinux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"

    values = [ "amzn2-ami-hvm-*-gp2" ]
  }
             filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
        filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

resource "aws_instance" "name" {
  ami = data.aws_ami.amzlinux.id
  instance_type = local.instance_type
  tags = {
    Name = "local.instance-name-${local.region}"
  }
}