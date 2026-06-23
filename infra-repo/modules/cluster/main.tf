module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name = "${var.environment}-fastapi-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = true

  vpc_id = var.vpc_id
  subnet_ids = var.public_subnets
  control_plane_subnet_ids = var.public_subnets

  enable_irsa = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    staging_nodes = {
        min_size = 1
        max_size = 2
        desired_size = 1

        instance_type = ["t3.micro"]
        capacity_type = "SPOT"
    }
  }
}