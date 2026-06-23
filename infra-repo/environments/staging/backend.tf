terraform {
  backend "s3" {
    bucket = "devops-project-01-tfstate-q919ah"
    key = "devops-project-04/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    use_lockfile = true
  }
}
