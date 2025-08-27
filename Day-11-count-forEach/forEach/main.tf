resource "aws_instance" "name" {
  ami = ""
  instance_type = "t2.micro"

  for_each = toset(var.instance)        # if we want to delete specific server form the list we can delete any time this cannot achieve 
                                        # using count if we want to delete 2 instance count will delete last server and rename previous servers 

  tags = {
    Name = each.value
  }
}

variable "instance" {
  type = list(string)
  default = [ "dev" , "test" , "prod" ]
}