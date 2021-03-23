
locals {
  cluster_name = "url-shortener-cluster"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}


module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  cluster_name                    = local.cluster_name
  cluster_version                 = "1.17"
  subnets                         = module.vpc.private_subnets
  vpc_id                          = module.vpc.vpc_id
  cluster_endpoint_private_access = true
  write_kubeconfig                = true
  enable_irsa                     = true


  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 20
  }

  node_groups = {
    nodes = {
      desired_capacity = var.node_group_desired_instances
      max_capacity     = var.node_group_max_instances
      min_capacity     = var.node_group_min_instances

      instance_types = [var.node_group_instance_type]
      capacity_type  = "ON_DEMAND"
      k8s_labels = {
        Environment = "prod"
      }
    }
  }

}
