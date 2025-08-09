resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cust-vpc"
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "ssssgsgssgssg"
}


                                            # terraform plan --target=aws_s3_bucket.name            TO PLAN TO CREATE PERTICULAR RESOURCE ONLY
                                            # terraform apply --target=aws_s3_bucket.name           TO APPLY PERTICULAR RESOURCE CREATION ONLY
                                            # terraform destroy --target=aws_s3_bucket.name         TO DESTROY PERTICULAR RESOURCE only