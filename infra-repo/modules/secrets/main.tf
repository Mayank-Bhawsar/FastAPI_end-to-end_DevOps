resource "random_password" "db_password" {
  length = 8
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_credentials" {
    name = "${var.environment}-database-credentials"
    recovery_window_in_days = 0
  
}

resource "aws_secretsmanager_secret_version" "db_credentials_val" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "postgres"
    password = random_password.db_password.result
    db_name = "fastapi_db"
  })
}