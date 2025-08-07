output "user_pool_id" {
  value = aws_cognito_user_pool.main.id
}

output "app_client_id" {
  value = aws_cognito_user_pool_client.app_client.id
}

output "hosted_ui_url" {
  value = "https://${aws_cognito_user_pool_domain.main.domain}.auth.${var.region}.amazoncognito.com/login?client_id=${aws_cognito_user_pool_client.app_client.id}&response_type=code&scope=email+openid+profile&redirect_uri=https://example.com/callback"
}
