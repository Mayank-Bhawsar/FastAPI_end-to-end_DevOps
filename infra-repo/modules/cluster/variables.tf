variable "environment" {
  description = "The environment name"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type = string
}


variable "public_subnets" {
  description = "A list of public subnet IDs where nodes will be deployed"
  type = list(string)
}