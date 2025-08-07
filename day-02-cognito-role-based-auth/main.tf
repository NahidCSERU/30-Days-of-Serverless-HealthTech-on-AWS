provider "aws" {
  region = "us-east-1"
}

#########################
# 1️⃣ User Pool
#########################
resource "aws_cognito_user_pool" "main" {
  name = "healthtech-user-pool"
}

#########################
# 2️⃣ User Groups
#########################
resource "aws_cognito_user_group" "patient_group" {
  user_pool_id = aws_cognito_user_pool.main.id
  name         = "Patient"
  description  = "Patients of the app"
}

resource "aws_cognito_user_group" "doctor_group" {
  user_pool_id = aws_cognito_user_pool.main.id
  name         = "Doctor"
  description  = "Doctors of the app"
}

resource "aws_cognito_user_group" "admin_group" {
  user_pool_id = aws_cognito_user_pool.main.id
  name         = "Admin"
  description  = "Admins of the app"
}

#########################
# 3️⃣ App Client
#########################
resource "aws_cognito_user_pool_client" "app_client" {
  name                             = "healthtech-client"
  user_pool_id                     = aws_cognito_user_pool.main.id
  generate_secret                  = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows             = ["code"]
  allowed_oauth_scopes            = ["openid", "email", "profile"]
  callback_urls                   = ["https://example.com/callback"]
  logout_urls                     = ["https://example.com/logout"]
  supported_identity_providers    = ["COGNITO"]

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}

#########################
# 4️⃣ Hosted UI Domain
#########################
resource "aws_cognito_user_pool_domain" "main" {
  domain       = "healthtech-auth-ui-${random_id.suffix.hex}"
  user_pool_id = aws_cognito_user_pool.main.id
}

resource "random_id" "suffix" {
  byte_length = 4
}

#########################
# 5️⃣ Create Sample Users
#########################
resource "aws_cognito_user" "admin_user" {
  user_pool_id = aws_cognito_user_pool.main.id
  username     = "admin01@health.com"
  attributes = {
    email          = "admin01@health.com"
    email_verified = true
  }
  temporary_password = "AdminTemp123!"
  force_alias_creation = false
}

resource "aws_cognito_user" "doctor_user" {
  user_pool_id = aws_cognito_user_pool.main.id
  username     = "doctor01@health.com"
  attributes = {
    email          = "doctor01@health.com"
    email_verified = true
  }
  temporary_password = "DoctorTemp123!"
  force_alias_creation = false
}

resource "aws_cognito_user" "patient_user" {
  user_pool_id = aws_cognito_user_pool.main.id
  username     = "patient01@health.com"
  attributes = {
    email          = "patient01@health.com"
    email_verified = true
  }
  temporary_password = "PatientTemp123!"
  force_alias_creation = false
}

#########################
# 6️⃣ Assign Users to Groups
#########################
resource "aws_cognito_user_in_group" "assign_admin" {
  user_pool_id = aws_cognito_user_pool.main.id
  username     = aws_cognito_user.admin_user.username
  group_name   = aws_cognito_user_group.admin_group.name
}

resource "aws_cognito_user_in_group" "assign_doctor" {
  user_pool_id = aws_cognito_user_pool.main.id
  username     = aws_cognito_user.doctor_user.username
  group_name   = aws_cognito_user_group.doctor_group.name
}

resource "aws_cognito_user_in_group" "assign_patient" {
  user_pool_id = aws_cognito_user_pool.main.id
  username     = aws_cognito_user.patient_user.username
  group_name   = aws_cognito_user_group.patient_group.name
}
