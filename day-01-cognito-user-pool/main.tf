
resource "aws_cognito_user_pool" "main" {
  name = "my_health_app_user_pool"

  alias_attributes = ["email"]
  auto_verified_attributes = ["email"]

  mfa_configuration = "OPTIONAL"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = false
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  tags = {
    Environment = "dev"
  }
}
