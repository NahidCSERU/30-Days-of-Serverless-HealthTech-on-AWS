provider "aws" {
  region = "us-east-1"
}

resource "aws_cognito_user_pool" "main_pool" {
  name = "healthtech-user-pool"

  auto_verified_attributes = ["email"]

  schema {
    name = "user_type"
    attribute_data_type = "String"
    mutable = true
    required = false
  }

  lambda_config {
    post_confirmation = aws_lambda_function.post_confirm_lambda.arn
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "app-client"
  user_pool_id = aws_cognito_user_pool.main_pool.id
}

resource "aws_cognito_user_group" "doctor" {
  name         = "Doctor"
  user_pool_id = aws_cognito_user_pool.main_pool.id
}
resource "aws_cognito_user_group" "patient" {
  name         = "Patient"
  user_pool_id = aws_cognito_user_pool.main_pool.id
}
resource "aws_cognito_user_group" "admin" {
  name         = "Admin"
  user_pool_id = aws_cognito_user_pool.main_pool.id
}

resource "aws_dynamodb_table" "user_table" {
  name           = "health_users"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_cognito_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-dynamodb-cognito"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:PutItem",
          "cognito-idp:AdminAddUserToGroup"
        ],
        Resource = "*"
      },
      {
        Effect: "Allow",
        Action: "logs:*",
        Resource: "*"
      }
    ]
  })
}

resource "aws_lambda_function" "post_confirm_lambda" {
  filename         = "lambda.zip"
  function_name    = "PostConfirmationHandler"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "post_confirmation_handler.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("lambda.zip")
}
