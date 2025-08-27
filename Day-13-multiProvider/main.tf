provider "aws" {
  region = "us-east-1"
  # alias = "test"

  profile = "prod"     # if we configure keys for the different profile this will apply according to that in resource block i dont need to write provider
}                       # if provider not mention in the resource block the resource block will use profile 

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
  
}