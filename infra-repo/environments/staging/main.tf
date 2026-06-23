module "networking" {
    source = "../../modules/networking"
    vpc_cidr = var.vpc_cidr
    environment = var.environment
}

module "registry" {
    source = "../../modules/registry"
    environment = var.environment
}

module "secrets" {
    source = "../../modules/secrets"
    environment = var.environment
  
}

module "database" {
  source = "../../modules/database"
  environment = var.environment
  vpc_id = module.networking.vpc_id
  vpc_cidr = var.vpc_cidr
  database_subnet_group_name = module.networking.database_subnet_group_name
  secret_string = module.secrets.secret_string
}

module "cluster" {
  source = "../../modules/cluster"
  environment = var.environment
  vpc_id = module.networking.vpc_id
  public_subnets = module.networking.public_subnets
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "backend_ecr_url" {
  value = module.registry.backend_url
}

output "db_endpoint" {
  value = module.database.db_endpoint
}