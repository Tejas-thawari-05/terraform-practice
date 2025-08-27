provider "aws" {
  region = "us-east-1"
  alias = "test"
}

provider "aws" {
  region = "us-west-2"
  alias = "dev"                 #    THIS IS IMPORTANT TO MENTION DIFFERENT PROVIDER BLOCK
}


resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  provider = aws.dev
}

resource "aws_s3_bucket" "name" {
  bucket = "ahjahfahfha"
  provider = aws.test
}