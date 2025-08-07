terraform {
  backend "s3" {
    bucket = "testbucket-ttttt"
    key = "day-4/terraform.tfstate"
    region = "us-east-1"


    use_lockfile = true                // USE FOR VERSION 1.10 AND GREATER VERSIONS


    # dynamodb_table = "test"           USE ONLY FOR VERSION LESS THAN 1.10     
    # encrypt = true                    FOR THIS WE NEED TO CREATE DYNAMODB TABLE IN AWS WITH NAME "test" AND PRIMARY KEY "LockID"
  }
}