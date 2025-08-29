resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cust-vpc"
  }
}

# for migrating terraform to opentofu we need to take backup of statefile in s3 as disaster Recovery nad s3 versioning

# then install opentofu :- winget install --exact --id=OpenTofu.Tofu

#check version
# tofu -version

# tofu init
# tofu plan
# tofu apply -auto-approve
# tofu destroy -auto-approve