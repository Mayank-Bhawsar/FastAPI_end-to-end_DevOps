resource "aws_security_group" "rds" {
  name = "${var.environment}-rds-sg"
  description = "Allow inbound PostgreSQL traffic from within VPC"
  vpc_id = var.vpc_id

  ingress {
    description = "PostgreSQL traffic from EKS nodes"
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

locals {
  db_creds = jsondecode(var.secret_string)
}

resource "aws_db_instance" "postgres" {
  identifier = "${var.environment}-postgres"
  allocated_storage = 20
  max_allocated_storage = 100
  engine = "postgres"
  engine_version = "18.4"
  instance_class = "db.t4g.micro"

  db_name = "fastapidb"
  username = local.db_creds.username
  password = local.db_creds.password

  db_subnet_group_name = var.database_subnet_group_name
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot = true
  publicly_accessible = false
}