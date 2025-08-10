# 🏥 HealthTech Signup Flow (Cognito + Lambda + DynamoDB)

This project demonstrates how to implement a secure signup flow using **AWS Cognito** with a **PostConfirmation Lambda Trigger** to store user profiles in **DynamoDB** and assign them to specific Cognito Groups automatically.

---

## 🏗️ Architecture

```text
[User Signup]
     ↓
[Cognito User Created]
     ↓
[Email Confirmed]
     ↓
[Lambda (PostConfirmation) Runs → Save to DynamoDB + Add to Group]
     ↓
[User Login → Cognito Token Issue]
# 📁 Project Structure

healthtech-signup-flow/
├── terraform/
│   ├── main.tf                # Terraform Infrastructure Code
│   ├── variables.tf           # Variables for Terraform
│   ├── outputs.tf             # Terraform Outputs
│   └── lambda.zip             # Bundled Lambda code
├── lambda/
│   └── post_confirmation_handler.py  # Lambda Function code
└── README.md                  # Project documentation
## 🔧 Tech Stack
AWS Cognito → User Authentication & Authorization

AWS Lambda → PostConfirmation Trigger

AWS DynamoDB → User Profile Storage

Terraform → Infrastructure as Code (IaC)

Python 3.9 → Lambda Runtime

## 🚀 Deployment Steps
1️⃣ Clone the Project

git clone https://github.com/yourusername/healthtech-signup-flow.git
cd healthtech-signup-flow
2️⃣ Bundle the Lambda Code

cd lambda
zip ../terraform/lambda.zip post_confirmation_handler.py
cd ../terraform
3️⃣ Deploy with Terraform

terraform init
terraform apply
4️⃣ Sign up a User via Cognito Hosted UI or CLI
Confirm the email, then check the health_users table in DynamoDB.

📜 What the Lambda Does
Retrieves user attributes (email, name, custom:user_type)

Saves the profile in DynamoDB

Assigns the user to the appropriate Cognito Group

🔐 Group Naming Convention
custom:user_type attribute value must match the Cognito Group name

Example: Doctor, Patient, Admin

🧪 How to Test
Sign up a new user

Confirm the email

Check DynamoDB table (user profile should be present)

Verify Cognito group assignment in AWS Console

Log in to generate JWT tokens

📌 Notes
This demo uses minimal security settings (no MFA, no custom policies). For production, configure proper security measures.

DynamoDB is set to PAY_PER_REQUEST mode — switch to Provisioned Capacity if needed.
