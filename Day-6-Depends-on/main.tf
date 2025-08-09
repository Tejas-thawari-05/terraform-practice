resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }

  depends_on = [ aws_s3_bucket.name ]           #  THIS RESOURCE BLOCK WILL START CREATION OF RESOURCE ONLY AFTER S3 BUCKET IS CREATED
}

resource "aws_s3_bucket" "name" {
  bucket = "my-bucket"
}