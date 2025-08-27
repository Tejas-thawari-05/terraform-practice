resource "aws_s3_bucket" "name" {
  bucket = "aahagagaghja"
}

locals {
  path = "C:/Users/tejas_oiqucju/OneDrive/Desktop/Devops/Terraform-Practice/terraform-practice/Day-13-Lambda/lambda_function.zip"
}

resource "aws_s3_object" "name" {
  bucket = aws_s3_bucket.name.id
  key = "lambda_function.zip"
  source = "${local.path}"
  etag = filemd5("${local.path}")
}


resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"      # if zip file name app.py then "app.lambda_handler" will come in handler
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 128

  #filename         = "lambda_function.zip" # Ensure this file exists

    #   USING S3 BUCKET TO UPLOAD ZIP FILE
  s3_bucket = aws_s3_bucket.name.id
  s3_key = aws_s3_object.name.key


  source_code_hash = filebase64sha256("${local.path}")

  depends_on = [ aws_s3_object.name ]

  #Without source_code_hash, Terraform might not detect when the code in the ZIP file has changed — meaning your Lambda might not update even after uploading a new ZIP.

  #This hash is a checksum that triggers a deployment.
}
