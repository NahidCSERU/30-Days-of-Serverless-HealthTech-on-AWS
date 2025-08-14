provider "aws" {
  region = "us-east-1"
}

# DynamoDB Table
resource "aws_dynamodb_table" "users" {
  name         = "healthtech-users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  tags = {
    Name = "HealthTech Users Table"
  }
}

# Cognito User Pool
resource "aws_cognito_user_pool" "user_pool" {
  name = "healthtech-user-pool"
  auto_verified_attributes = ["email"]
}
