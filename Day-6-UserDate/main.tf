resource "aws_instance" "name" {
  ami = "ami-08a6efd148b1f7504"
  instance_type = "t2.micro"
  tags = {
    Name = "cust-ec2"
  }
  associate_public_ip_address = true
  user_data = file("test.sh")                       #  IN THIS WE HAVE TO SPECIFY THE PATH OF THE FILE
}