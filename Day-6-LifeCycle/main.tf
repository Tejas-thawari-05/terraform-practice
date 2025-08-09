resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cust-vpc"
  }
  lifecycle {
    # prevent_destroy = true                # THIS LINE WILL NOT ALLOW THE VPC TO BE DESTROYED
    create_before_destroy = true            # THIS LINE WILL ALLOW THE VPC TO CREATE FIRST WITH NEW CHANGES THE OLD VPC WILL BE DESTROYED
    ignore_changes = [ tags ]               # THIS LINE WILL IGNORE CHANGES TO THE TAGS WHICH ARE MADE MANUALLY IN THE AWS CONSOLE
  }
}

