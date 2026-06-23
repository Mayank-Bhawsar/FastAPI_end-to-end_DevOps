output "secret_arn" {
    value = aws_secretsmanager_secret.db_credentials.arn
}

output "secret_string" {
  value = aws_secretsmanager_secret_version.db_credentials_val.secret_string
  sensitive = true
}
