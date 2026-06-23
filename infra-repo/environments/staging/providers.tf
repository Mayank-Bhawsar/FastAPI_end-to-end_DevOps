terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }




  backend "s3" {
    bucket = "devops-project-01-tfstate-q919ah"
    key = "devops-project-04/terraform.tfstate"
    region = "ap-south-1"
    #dynamodb_table = "devops-project-01-tflocks"
    encrypt = true
    use_lockfile = true
  }
}


  provider "aws" {
    region = var.aws_region
  

  default_tags {
    tags = {
      Environment = "staging"
      Project = "fastapi-3tier"
      ManagedBy = "terraform"
    }
  }
}