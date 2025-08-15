HealthTech Serverless Signup & User Profile API
📌 Overview

This project implements a secure, serverless HealthTech user registration system using AWS Cognito, Lambda, API Gateway, and DynamoDB.

When a user signs up via Cognito, a PostConfirmation Lambda trigger automatically stores their basic profile in DynamoDB.
Additionally, an API Gateway + Lambda endpoint allows retrieving and updating user data.
An optional S3 bucket is available for storing profile pictures or other user-related files.

🏗 Architecture
User (Sign Up) → Cognito User Pool → PostConfirmation Lambda → DynamoDB (User Profile)
                                     ↑
API Gateway (REST API) ← Lambda (api_handler) ← DynamoDB
Optional: S3 Bucket for profile pictures or file uploads

⚙ Tech Stack

AWS Cognito — Secure authentication and signup

AWS Lambda — Serverless functions for triggers and API processing

AWS DynamoDB — NoSQL database for storing user profiles

AWS API Gateway — REST API endpoint

AWS S3 (optional) — Profile picture or file storage

Terraform — Infrastructure as Code

📂 Project Structure
healthtech-api/
│
├── main.tf                   # Terraform main config
├── variables.tf              # Terraform variables
├── outputs.tf                # Terraform outputs
├── lambda/
│   ├── post_confirmation/    # Lambda for PostConfirmation trigger
│   │   └── handler.py
│   └── api_handler/          # Lambda for API Gateway endpoint
│       └── handler.py
├── terraform.tfvars          # Environment variables
├── deployment/
│   ├── post_confirmation.zip
│   └── api_handler.zip
└── README.md

🔹 Signup Flow

User signs up with:

Email

Phone Number

Name

Date of Birth (custom:dob)

Gender (custom:gender)

Blood Group (custom:blood_group)

Cognito PostConfirmation Lambda trigger runs.

Lambda stores a basic user profile in DynamoDB.

📄 Example Signup Request
{
  "username": "john@example.com",
  "password": "StrongPass123!",
  "user_attributes": {
    "name": "John Doe",
    "email": "john@example.com",
    "phone_number": "+8801712345678",
    "custom:dob": "1990-05-14",
    "custom:gender": "Male",
    "custom:blood_group": "A+"
  }
}

🔹 API Endpoint

Base URL:

https://abcd1234.execute-api.us-east-1.amazonaws.com/prod/users


Methods:

GET /users/{id} — Fetch user profile

PUT /users/{id} — Update user profile

🚀 Deployment
# Initialize Terraform
terraform init

# Preview resources
terraform plan

# Deploy resources
terraform apply

📌 Environment Variables

For Lambda functions, configure:

DYNAMODB_TABLE=Users
S3_BUCKET=healthtech-profile-pics  # optional

🛡 Security

Cognito handles secure authentication & password policies

DynamoDB stores only verified user data

API Gateway secured with Cognito Authorizer

Optional S3 storage uses pre-signed URLs for controlled access

📜 License

MIT License